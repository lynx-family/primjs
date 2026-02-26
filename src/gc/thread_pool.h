#ifndef SRC_GC_THREAD_POOL_H_
#define SRC_GC_THREAD_POOL_H_

#include <condition_variable>
#include <functional>
#include <mutex>
#include <queue>
#include <vector>
#ifndef _WIN32
#include <pthread.h>
#endif

#include "gc/alloc_utils.h"

// thread pool implementation
namespace ROS_GC {
class MplTask {
 public:
  MplTask() = default;
  virtual ~MplTask() = default;
  virtual void Execute(size_t threadId) = 0;
};

class MplLambdaTask : public MplTask {
 public:
  explicit MplLambdaTask(const std::function<void(size_t)> &function)
      : func(function) {}
  ~MplLambdaTask() = default;
  void Execute(size_t threadId) override { func(threadId); }

 private:
  std::function<void(size_t)> func;
};

class MplThreadPool;

class MplPoolThread {
 public:
  // use for profiling
  std::vector<int32_t> *schedCores;

  MplPoolThread(MplThreadPool *threadPool, const char *threadName,
                size_t threadId, size_t stackSize);
  ~MplPoolThread();

  void SetPriority(int32_t prior);
#ifndef _WIN32
  // get pthread of thread
  pthread_t GetThread() const { return pthread; }

  // get thread id of thread
  pid_t GetTid() const { return tid; }
#endif

  static void *WorkerFunc(void *param);

 private:
  size_t id;
#ifndef _WIN32
  pthread_t pthread;
  pid_t tid;
#endif
  std::string name;
  MplThreadPool *pool;
};

// manual
// new  (SetMaxActiveThreadNum(optional) addTask  startPool waitFinish)^. Exit
// delete if need to change MaxActiveThreadNum, should waitFinish or stop pool
// at first
class MplThreadPool {
 public:
  // Constructor for thread pool, 1) Create threads, 2) wait all thread created
  // & sleep name is the thread pool name. thread name =
  // Pool_$(poolname)_ThreadId_$(threadId) maxThreadNum is the max thread number
  // in pool. prior is the priority of threads in pool.
  MplThreadPool(const char *name, int32_t maxThreadNum, int32_t prior);

  // Destructor for thread pool, 1) close pool 2) wait thread in pool to exit,
  // 3) release resources of class
  ~MplThreadPool();

  // Set priority of each thread in pool.
  void SetPriority(int32_t prior);

  // Set max active thread number of pool, redundant thread hangup in sleep
  // condition var. notify more waitting thread get to work when pool is
  // running. Range [1 - maxThreadNum].
  void SetMaxActiveThreadNum(int32_t num);

  // Get max active thread number of pool.
  int32_t GetMaxActiveThreadNum() const { return maxActiveThreadNum; }

  // Get max thread number of pool, defalut = maxThreadNum.
  int32_t GetMaxThreadNum() const { return maxThreadNum; }

  // Add new task to task queue , task should inherit from MplTask.
  void AddTask(MplTask *task);
  void AddTaskNoLock(MplTask *task);

  // Add task to thread , func indicate Lambda statement.
  void AddTask(std::function<void(size_t)> func);

  // Start thread pool, notify all sleep threads to get to work
  void Start();

  // Wait all task in task queue finished, if pool stopped, only wait until
  // current excuting task finish after all task finished, stop pool
  // addToExecute indicate whether the caller thread excute task
  void WaitFinish(bool addToExecute,
                  std::vector<int32_t> *schedCores = nullptr);
  void WaitFinishAndKeepNotifyFunc(bool addToExecute);

  // used in none-parallel concurrent mark
  void DrainTaskQueue();

  // Notify & Wait all thread waitting for task to sleep
  void Stop();

  // Notify all thread in pool to exit , notify all waitFinish thread to
  // return,nonblock ^.
  void Exit();

  // Remove all task in task queue
  void ClearAllTask();

  // Get task count in queue
  size_t GetTaskNumber() {
    std::unique_lock<std::mutex> taskLock(taskMutex);
    return taskQueue.size();
  }

  // Get all MplPoolThread in pool
  const std::vector<MplPoolThread *> &GetThreads() const { return threads; }
  // currently, we only use this notify mechanism to notice rts thread that
  // concurrent-mark is finished. this can shorten concurrent-mark phase(also
  // decreate memory footprint), and avoid lots of write-barriers. we may add
  // more callbacks later, and this notify_func need to change as a list
  void SetNotifyFunc(std::function<void(size_t)> f) {
    std::lock_guard guard(notify_func_mtx);
    notify_func = f;
  }

  std::function<void(size_t)> GetNofifyFunc() {
    std::lock_guard guard(notify_func_mtx);
    return notify_func;
  }
  // is pool running or stopped
  bool IsRunning() const { return running.load(std::memory_order_relaxed); }
  bool IsStopped() const {
    return currWaittingThreadNum.load() == maxActiveThreadNum;
  }

  bool CheckCanDistributeTask() {
    return (currActiveThreadNum.load() < maxActiveThreadNum) ||
           (currWaittingThreadNum.load() > 0);
  }

 private:
  // thread default stack size 512 KB.
  static const size_t kDefaultStackSize = (512 * 1024);
  // int32_t priority;

  std::string name;
  // pool stop or running state
  std::atomic<bool> running;
  // is pool exit
  std::atomic<bool> exit;
  // all task put in task queue
  std::queue<MplTask *> taskQueue;

  // active thread 0 ..... maxActiveThreadNum .....maxThreadNum
  // max thread number in pool
  int32_t maxThreadNum;

  // max active thread number, redundant thread hang up in threadSleepingCondVar
  int32_t maxActiveThreadNum;

  // current active thread, when equals to zero, no thread running, all thread
  // slept
  std::atomic<int32_t> currActiveThreadNum;

  // current waitting thread, when equals to currActiveThreadNum
  // no thread excuting, all task finished
  std::atomic<int32_t> currWaittingThreadNum;
  // single lock
  std::mutex taskMutex;

  // hangup when no task available
  std::condition_variable taskEmptyCondVar;

  // hangup when too much active thread or pool stopped
  std::condition_variable threadSleepingCondVar;

  // hangup when there is thread excuting
  std::condition_variable allWorkDoneCondVar;

  // hangup when there is thread active
  std::condition_variable allThreadStopped;

  // use for profiling
  std::vector<MplPoolThread *> threads;

  bool IsExited() const { return exit.load(std::memory_order_relaxed); }
  std::mutex notify_func_mtx;
  std::function<void(size_t)> notify_func{nullptr};

  friend class MplPoolThread;
};
}  // namespace ROS_GC

#endif  // SRC_GC_THREAD_POOL_H_
