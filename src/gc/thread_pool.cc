/*
 * Copyright (c) [2020] Huawei Technologies Co.,Ltd.All rights reserved.
 *
 * OpenArkCompiler is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan
 * PSL v2. You may obtain a copy of Mulan PSL v2 at:
 *
 *     http://license.coscl.org.cn/MulanPSL2
 *
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY
 * KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
 * NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE. See the
 * Mulan PSL v2 for more details.
 */
#ifdef ENABLE_COMPATIBLE_MM
#include "gc/thread_pool.h"

#include <sys/resource.h>
#include <sys/time.h>

#include "gc/logger.h"

#define CHECK_PTHREAD_CALL(call, args, what)                       \
  do {                                                             \
    int rc = call args;                                            \
    if (rc != 0) {                                                 \
      errno = rc;                                                  \
      std::cout << #call << " failed for " << (what) << " reason " \
                << strerror(errno) << " return " << errno;         \
    }                                                              \
  } while (false)

// thread pool implementation
namespace ROS_GC {
MplPoolThread::MplPoolThread(MplThreadPool *threadPool, const char *threadName,
                             size_t threadId, size_t stackSize)
    : schedCores(nullptr),
      id(threadId),
      tid(-1),
      name(threadName),
      pool(threadPool) {
  SCOPED_LOGGER(__func__);
  pthread_attr_t attr;
  CHECK_PTHREAD_CALL(pthread_attr_init, (&attr), "");
  CHECK_PTHREAD_CALL(pthread_attr_setstacksize, (&attr, stackSize), stackSize);
  CHECK_PTHREAD_CALL(pthread_create,
                     (&pthread, nullptr, &WorkerFunc, (void *)this),
                     "MplPoolThread init");
#if defined(ANDROID) || defined(__ANDROID__)
  CHECK_PTHREAD_CALL(pthread_setname_np, (pthread, threadName),
                     "MplThreadPool SetName");
#endif
  CHECK_PTHREAD_CALL(pthread_attr_destroy, (&attr), "MplPoolThread init");
}

MplPoolThread::~MplPoolThread() {
  CHECK_PTHREAD_CALL(pthread_join, (pthread, nullptr), "thread deinit");
  schedCores = nullptr;
  pool = nullptr;
}

void MplPoolThread::SetPriority(int32_t priority) {
  int32_t result = setpriority(static_cast<int>(PRIO_PROCESS), tid, priority);
  if (result != 0) {
    // LOG(ERROR) << "Failed to setpriority to :" << priority;
  }
}

void *MplPoolThread::WorkerFunc(void *param) {
  MplPoolThread *thread = reinterpret_cast<MplPoolThread *>(param);
  MplThreadPool *pool = thread->pool;

  while (!pool->IsExited()) {
    MplTask *task = nullptr;
    {
      std::unique_lock<std::mutex> taskLock(pool->taskMutex);
      // hang up in threadSleepingCondVar when pool stopped or to many active
      // thread
      while (((pool->currActiveThreadNum.load() > pool->maxActiveThreadNum) ||
              !pool->IsRunning()) &&
             !pool->IsExited()) {
        // currActiveThreadNum start at maxThreadNum, dec before thread hangup
        // in sleeping state
        --(pool->currActiveThreadNum);
        if (pool->currActiveThreadNum.load() == 0) {
          // all thread sleeping, pool in stop state, notify wait stop thread
          pool->allThreadStopped.notify_all();
        }
        pool->threadSleepingCondVar.wait(taskLock);
        ++(pool->currActiveThreadNum);
      }
      // if no task available thread hung up in taskEmptyCondVar
      while (pool->taskQueue.empty() && pool->IsRunning() &&
             !pool->IsExited()) {
        // currExecuteThreadNum start at 0, inc before thread wait for task
        ++(pool->currWaittingThreadNum);
        bool hasNewTask = false;
        if (pool->currWaittingThreadNum.load() == pool->maxActiveThreadNum) {
          // all task is done, notify wait finish thread
          auto func = pool->GetNofifyFunc();
          hasNewTask = !pool->taskQueue.empty();
          if (func && !hasNewTask) {
            func(0);
          }
          if (!hasNewTask) pool->allWorkDoneCondVar.notify_all();
        }
        if (!hasNewTask) {
          pool->taskEmptyCondVar.wait(taskLock);
        }
        --(pool->currWaittingThreadNum);
      }
      if (!pool->taskQueue.empty() && pool->IsRunning() && !pool->IsExited()) {
        task = pool->taskQueue.front();
        pool->taskQueue.pop();
      }
    }
    if (task != nullptr) {
      if (thread->schedCores != nullptr) {
        // thread->schedCores->push_back(sched_getcpu());
      }
      task->Execute(thread->id);
      delete task;
    }
  }
  {
    std::unique_lock<std::mutex> taskLock(pool->taskMutex);
    --(pool->currActiveThreadNum);
    if (pool->currActiveThreadNum.load() == 0) {
      // all thread sleeping, pool in stop state, notify wait stop thread
      pool->allThreadStopped.notify_all();
    }
  }
  return nullptr;
}

const int kMaxNameLen = 256;

MplThreadPool::MplThreadPool(const char *poolName, int32_t threadNum,
                             int32_t prior)
    //    : priority(prior),
    : name(poolName),
      running(false),
      exit(false),
      maxThreadNum(threadNum),
      maxActiveThreadNum(0) {
  // init and start thread
  currActiveThreadNum.store(0);
  currWaittingThreadNum.store(0);
  char threadName[kMaxNameLen];
  for (int32_t i = 0; i < maxThreadNum; ++i) {
    // threadID 0 is main thread, sub threadID start at 1
    int ret = snprintf(threadName, (kMaxNameLen - 1), "RosPool%s_%d", poolName,
                       (i + 1));
    if (ret < 0) {
      std::cout << "snprintf "
                << "name = " << name << "threadId" << (i + 1)
                << " in MplThreadPool::MplThreadPool return " << ret
                << " rather than 0." << std::endl;
    }
    // default Sleeping
    MplPoolThread *threadItem = new (std::nothrow)
        MplPoolThread(this, threadName, (i + 1), kDefaultStackSize);
    if (threadItem == nullptr) {
      // LOG(FATAL) << "new MplPoolThread failed" << std::endl;
      std::cout << "new MplThreadPool failed" << std::endl;
    } else {
      threads.push_back(threadItem);
      maxActiveThreadNum++;
      currActiveThreadNum++;
    }
  }
  // pool init in stop state
  Stop();
  // LOG(DEBUGY) << "MplThreadPool init" << std::endl;
}

void MplThreadPool::Exit() {
  std::unique_lock<std::mutex> taskLock(taskMutex);
  // set pool exit flag
  exit.store(true, std::memory_order_relaxed);

  // notify all waitting thread exit
  taskEmptyCondVar.notify_all();
  // notify all stopped thread exit
  threadSleepingCondVar.notify_all();

  // notify all WaitFinish thread return
  allWorkDoneCondVar.notify_all();
  // notify all WaitStop thread return
  allThreadStopped.notify_all();
  // LOG(DEBUGY) << "MplThreadPool Exit" << std::endl;
}

MplThreadPool::~MplThreadPool() {
  Exit();
  // wait until threads exit
  for (auto thread : threads) {
    delete thread;
  }
  threads.clear();
  ClearAllTask();
}

void MplThreadPool::SetPriority(int32_t prior) {
  for (auto thread : threads) {
    thread->SetPriority(prior);
  }
}

void MplThreadPool::SetMaxActiveThreadNum(int32_t num) {
  std::unique_lock<std::mutex> taskLock(taskMutex);
  int32_t oldNum = maxActiveThreadNum;
  if (num >= maxThreadNum) {
    maxActiveThreadNum = maxThreadNum;
  } else if (num > 0) {
    maxActiveThreadNum = num;
  } else {
    // LOG(ERROR) << "SetMaxActiveThreadNum invalid input val" << std::endl;;
    return;
  }
  // active more thread get to work when pool is running
  if ((maxActiveThreadNum > oldNum) && (currWaittingThreadNum.load() > 0) &&
      IsRunning()) {
    threadSleepingCondVar.notify_all();
  }
}

void MplThreadPool::AddTask(MplTask *task) {
  if (UNLIKELY(task == nullptr)) {
    // LOG(FATAL) << "failed to add a null task" << std::endl;
  }
  std::unique_lock<std::mutex> taskLock(taskMutex);
  taskQueue.push(task);
  // do not notify when pool isn't running, notify_all in start
  // notify if there is active thread waiting for task
  if (IsRunning() && (currWaittingThreadNum.load() > 0)) {
    taskEmptyCondVar.notify_one();
  }
}

// only used in remark phase. gc worker thread already acquired taskMutex
// when it posts a remark task.
void MplThreadPool::AddTaskNoLock(MplTask *task) {
  taskQueue.push(task);
  if (IsRunning() && (currWaittingThreadNum.load() > 0)) {
    taskEmptyCondVar.notify_one();
  }
}

void MplThreadPool::AddTask(std::function<void(size_t)> func) {
  AddTask(new (std::nothrow) MplLambdaTask(func));
}

void MplThreadPool::Start() {
  // notify all sleeping threads get to work
  std::unique_lock<std::mutex> taskLock(taskMutex);
  running.store(true, std::memory_order_relaxed);
  threadSleepingCondVar.notify_all();
}

void MplThreadPool::DrainTaskQueue() {
  //__MRT_ASSERT(!IsRunning(), "thread pool is running");
  MplTask *task = nullptr;
  do {
    task = nullptr;
    taskMutex.lock();
    if (!taskQueue.empty()) {
      task = taskQueue.front();
      taskQueue.pop();
    }
    taskMutex.unlock();
    if (task != nullptr) {
      task->Execute(0);
      delete task;
    }
  } while (task != nullptr);
}
void MplThreadPool::WaitFinishAndKeepNotifyFunc(bool addToExecute) {
  auto notifyFunc = GetNofifyFunc();
  SetNotifyFunc(nullptr);
  WaitFinish(true);
  SetNotifyFunc(notifyFunc);
}
void MplThreadPool::WaitFinish(bool addToExecute,
                               std::vector<int32_t> *schedCores) {
  if (addToExecute) {
    MplTask *task = nullptr;
    do {
      task = nullptr;
      taskMutex.lock();
      if (!taskQueue.empty() && IsRunning() && !IsExited()) {
        task = taskQueue.front();
        taskQueue.pop();
      }
      taskMutex.unlock();
      if (task != nullptr) {
        if (schedCores != nullptr) {
          // schedCores->push_back(sched_getcpu());
        }
        task->Execute(0);
        delete task;
      }
    } while (task != nullptr);
  }

  // wait all task excute finish
  // currWaittingThreadNum == maxActiveThreadNum indicate all work done
  // no need to wait when pool stopped or exited
  {
    std::unique_lock<std::mutex> taskLock(taskMutex);
    while ((currWaittingThreadNum.load() != maxActiveThreadNum) &&
           IsRunning() && !IsExited()) {
      allWorkDoneCondVar.wait(taskLock);
    }
  }
  // let all thread sleeing for next start
  // if threads not in sleeping mode, next start signal may be missed
  Stop();
  // clean up task in GC thread, thread pool might receive "exit" in stop thread
  DrainTaskQueue();
}

void MplThreadPool::Stop() {
  // notify & wait all thread enter stopped state
  std::unique_lock<std::mutex> taskLock(taskMutex);
  running.store(false, std::memory_order_relaxed);
  taskEmptyCondVar.notify_all();
  while (currActiveThreadNum.load() != 0) {
    allThreadStopped.wait(taskLock);
  }
}

void MplThreadPool::ClearAllTask() {
  std::unique_lock<std::mutex> taskLock(taskMutex);
  while (!taskQueue.empty()) {
    MplTask *task = taskQueue.front();
    taskQueue.pop();
    delete task;
  }
}
}  // namespace ROS_GC
#endif  // ENABLE_COMPATIBLE_MM
