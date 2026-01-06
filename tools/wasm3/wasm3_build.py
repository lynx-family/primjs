#!/usr/bin/env python3
# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

import argparse
import subprocess
import sys
import os


def parse_args():
  parser = argparse.ArgumentParser(epilog=__doc__,
                                   formatter_class=argparse.RawDescriptionHelpFormatter)
  parser.add_argument('sources', help='input file')
  parser.add_argument('-b', '--builder', required=True, help='build scirpt')
  parser.add_argument('-o', '--output', required=True, help='output directory')
  parser.add_argument('-d', '--debug', default="false", help='output directory')
  parser.add_argument('-cc', '--c_compiler', default='clang', help='gcc or clang compiler')
  parser.add_argument('-cxx', '--cxx_compiler', default='clang++', help='g++ or clang++ compiler')
  parser.add_argument('-arch', default='x86_64', help='compiler target architecture')
  args = parser.parse_args()
  return args


def which(program):
  """
  Finds the given executable 'program' in PATH.
  Operates like the Unix tool 'which'.
  """

  def is_exe(fpath):
    return os.path.isfile(fpath) and os.access(fpath, os.X_OK)

  if os.path.isabs(program):
    if os.path.isfile(program):
      return program

  fpath, fname = os.path.split(program)
  if fpath:
    if is_exe(program):
      return program
  else:
    for path in os.environ["PATH"].split(os.pathsep):
      path = path.strip('"')
      exe_file = os.path.join(path, program)
      if is_exe(exe_file):
        return exe_file

  return None


def main():
  args = parse_args()
  debug_str = ""
  if args.debug == "true":
    debug_str = "-d"

  cc = which(args.c_compiler)
  cxx = which(args.cxx_compiler)

  wasm3_build_cmd = """bash %s --wasm3 %s --install %s %s -cc %s -cxx %s -arch %s""" % (
      args.builder, args.sources, args.output, debug_str, cc, cxx, args.arch)

  print(wasm3_build_cmd)
  subprocess.check_call(wasm3_build_cmd, shell=True)
  sys.exit(0)


if __name__ == '__main__':
  sys.exit(main())
