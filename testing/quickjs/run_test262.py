# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

#!/use/bin/python
import subprocess
import sys
from threading import Thread, Lock
import json
import argparse

dirs = "."
lock = Lock()
result = []
args = ""

def readTests(args):
  # remove useless case
  cmd = "find ./test -name '*.fail' |xargs rm"
  subprocess.getstatusoutput(cmd)

  cmd = "test262-harness --help"
  status, output = subprocess.getstatusoutput(cmd)
  if status == 0:
     subprocess.getstatusoutput("npm install -g test262-harness")
  cmd = "find %s -name '*.js'" % args.test262Dir
  status, output = subprocess.getstatusoutput(cmd)
  return output

def run_test(tests):
  global args
  cmd = "test262-harness --reporter json --reporter-keys result,file --hostType %s --hostPath %s" % (args.type, args.bin)
  print(("run_test: %d" % len(tests)))
  success = 0
  runned = 0
  global result
  localResult = []
  for test in tests:
    cmd = cmd + " " + test + " "

  status, output = subprocess.getstatusoutput(cmd)
  retArray = (output.strip("[\n").strip("]\n").split("\n,"))

  for ret in retArray:
    try:
      ret = json.loads(ret)
      localResult.append(str(ret["result"]["pass"]) + " " + ret["file"] + "\n")
    except:
      print(ret)

  lock.acquire()
  result.extend(localResult)
  lock.release()
  print("finish_test: %d" % len(tests))

def main():
  parser = argparse.ArgumentParser(description="To run test262 cases")
  parser.add_argument("--test262Dir", help="test262 root dirctory", type=str, default=".")
  parser.add_argument("--type", help="host vm type example d8/node/qjs", type=str)
  parser.add_argument("--bin", help="vm execute path", type=str)
  parser.add_argument("--output", help="result output file", type=str, default="./result.output")
  parser.add_argument("--t", help="thread count to run", type=int, default=5)


  global args
  args = parser.parse_args()

  with open(args.output, "w") as f:
    f = f
  # find all tests
  tests = readTests(args).split("\n")
  totalCount = len(tests)
  print("Total case: %d" % totalCount)

  thread_lists = []
  thread_count = args.t

  prethread = totalCount / thread_count
  # use 10 thread to run tests
  for i in range(0, thread_count):
    t = Thread(target=run_test, args=(tests[i*prethread : (i+1) * prethread ],))
    thread_lists.append(t)
    t.start()

  for t in thread_lists:
    t.join()

  if  prethread * thread_count < totalCount:
    run_test(tests[prethread * thread_count :])

  # write to file
  global result
  print("Run case: %d" % len(result))
  with open(args.output, "a") as f:
    for line in result:
      f.write(line)

if __name__=="__main__":
    main()
