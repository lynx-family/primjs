#!/usr/bin/env python3

import argparse
import os
import sys
from subprocess import check_call
import tempfile
import subprocess

CUR_DIR = os.path.dirname(os.path.abspath(__file__))
HARMONY_DIR = os.path.normpath(os.path.join(CUR_DIR, '..'))
PRIMJS_DIR = os.path.normpath(os.path.join(HARMONY_DIR, '..'))


def patch_oh_package(module_path, version):
    cmd = 'ohpm version {}'.format(version)
    print(f'run command {cmd} in {module_path}')
    check_call(cmd, shell=True, cwd=module_path)
    
    package_file = os.path.join(module_path, "oh-package.json5")
    # print replaced file
    with open(package_file, "r") as f:
        print(f.read())

# only used in unofficial build and publish
# not used in harmony bits component upgrade
def parse_version_file(unofficial_publish, commit_hash):
    # read PRIMJS_VERSION file
    short_commit_hash = commit_hash[:30]
    version_file = os.path.join(HARMONY_DIR, "../PRIMJS_VERSION")
    with open(version_file, "r") as f:
        version = f.read().strip()

    if unofficial_publish:
        version += '-unofficial-' + short_commit_hash


    # ohpm do not allow version over 64 characters
    return version

def collect_module_config_list(args):
    import json5
    with open(os.path.join(HARMONY_DIR,'build-profile.json5'), 'r') as f:
        build_profile = json5.load(f)

    module_config_list = build_profile['modules']
    if args.verbose:
        print('module_config_list is'+ str(module_config_list))
    return module_config_list

def run_package_har(module_name, module_path, verbose):
    if verbose:
        print(f'===== start run package {module_name} =====')

    local_properties_path = os.path.join(HARMONY_DIR, 'local.properties')
    if not os.path.exists(local_properties_path):
        print('harmony/local.properties not found')
        if 'HARMONY_HOME' in os.environ:
            # write hwsdk.dir to local.properties
            harmony_sdk_path = os.environ['HARMONY_HOME']
            print('harmony/local.properties not found, write hwsdk.dir with {} to it'.format(harmony_sdk_path))
            with open(local_properties_path, 'w') as f:
                f.write('hwsdk.dir={}'.format(harmony_sdk_path))
        else:
            print('harmony/local.properties not found, and HARMONY_HOME is not set.')

    cmd = f'hvigorw assembleHar --mode module -p module={module_name}@default -p product=default -p buildMode=debug --no-daemon'
    if verbose:
        print(f'run command {cmd}')
    check_call(cmd, shell=True, cwd=HARMONY_DIR)
    # as even hvigor build failed, it still return value 0, so we need to check har file exist or not
    har_path = os.path.join(HARMONY_DIR, module_path, 'build', 'default', 'outputs', 'default', f'{module_name}.har')
    print(f'har_path is {har_path}')
    if not os.path.isfile(har_path):
        raise Exception('har file not found, please check your build')

def do_publish(har_path):
    print(f'start publish {har_path}.')

    cmd = f'ohpm publish {har_path}'

    check_call(cmd, shell=True, cwd=HARMONY_DIR)


def publish_primjs(version, unofficial_publish, modules):
    for module in modules:
        do_publish(f'{module}/build/default/outputs/default/{os.path.basename(module)}.har')
    
    if unofficial_publish:
        # as unofficial build, do not tag
        return 0
    
    tag_name = 'platform_harmony_' + version
    print("tag name: %s" % tag_name)
    os.system("git tag %s" % tag_name)
    os.system("git push origin %s --no-verify" % tag_name)

def packJsPrimjsHeaderFiles():
    src_path = os.path.join(PRIMJS_DIR, "include")

    # copy quickjs header files
    dest_path = os.path.join(HARMONY_DIR, 'primjs/src/main/quick/include')
    if not os.path.exists(dest_path):
        os.makedirs(dest_path)

    cmds = [
        f"cp -rL {src_path}/* ./"
    ]
    cmd = " && ".join(cmds)
    check_call(cmd, shell=True, cwd=dest_path)

    # copy weak-node-api header files
    weak_node_api_src = os.path.join(PRIMJS_DIR, "packages/weak-node-api/headers")
    weak_node_api_dest = os.path.join(HARMONY_DIR, 'primjs/src/main/weak-node-api/include')
    if not os.path.exists(weak_node_api_dest):
        os.makedirs(weak_node_api_dest)

    cmds = [
        f"cp -rL {weak_node_api_src}/* ./"
    ]
    cmd = " && ".join(cmds)
    check_call(cmd, shell=True, cwd=weak_node_api_dest)


def resolve_native_sdk(args, parser):
    if args.sdk_native_dir:
        native_dir = os.path.abspath(os.path.expanduser(args.sdk_native_dir))
        toolchain = os.path.join(native_dir, 'build/cmake/ohos.toolchain.cmake')
    else:
        harmony_home = os.getenv('HARMONY_HOME')
        if not harmony_home:
            parser.error('set HARMONY_HOME or pass --sdk-native-dir /path/to/native')
        sdk_dir = os.path.join(os.path.abspath(os.path.expanduser(harmony_home)), 'default')
        native_dir = os.path.join(sdk_dir, 'openharmony/native')
        toolchain = os.path.join(sdk_dir, 'hms/native/build/cmake/hmos.toolchain.cmake')

    cmake = os.path.join(native_dir, 'build-tools/cmake/bin/cmake')
    required_files = [toolchain, cmake,
                      os.path.join(native_dir, 'llvm/bin/clang'),
                      os.path.join(native_dir, 'llvm/bin/clang++')]
    missing = [file for file in required_files if not os.path.isfile(file)]
    if not os.path.isdir(os.path.join(native_dir, 'sysroot')):
        missing.append(os.path.join(native_dir, 'sysroot'))
    if missing:
        parser.error('incomplete native SDK; missing: ' + ', '.join(missing))
    tools = [cmake, os.path.join(native_dir, 'llvm/bin/clang'),
             os.path.join(native_dir, 'llvm/bin/clang++')]
    not_executable = [tool for tool in tools if not os.access(tool, os.X_OK)]
    if not_executable:
        parser.error('native SDK tools are not executable: ' + ', '.join(not_executable))
    if not args.disable_jsvm:
        jsvm_headers = os.path.join(native_dir, 'sysroot/usr/include/ark_runtime')
        if not all(os.path.isfile(os.path.join(jsvm_headers, name))
                   for name in ('jsvm.h', 'jsvm_types.h')):
            parser.error('native SDK has no JSVM headers; pass --disable_jsvm for a PrimJS-only build')
    return native_dir, cmake, toolchain


def main(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument("--verbose", action="store_true", default=False, help="verbose print")
    parser.add_argument("--version", type=str, default=None, help="override version")
    parser.add_argument("--publish_har", action="store_true", default=False, help="publish har")
    parser.add_argument("--modules", nargs="*", help="list of modules name")
    parser.add_argument("--unofficial_publish", action="store_true", required=False, help="as unofficial build")
    parser.add_argument("--only_build", action="store_true", required=False, help="only build dynamic library")
    parser.add_argument("--no_build", action="store_true", required=False, help="only build dynamic library")
    parser.add_argument("--build_napi_v8", action="store_true", required=False, help="build libnapi_v8.so")
    parser.add_argument("--build_napi_adapter", action="store_true", required=False, help="build libnapi_adapter.so")
    parser.add_argument("--build_worker", action="store_true", required=False, help="build libworker.so")
    parser.add_argument("--build_type", type=str, default="Debug", required=False, help="cmake build type")
    parser.add_argument("--enable_ut", type=bool, default=False, required=False, help="Enable Unittests")
    parser.add_argument("--disable_jsvm", action="store_true", help="omit the optional JSVM backend and JSVM-specific tests")
    parser.add_argument("--sdk-native-dir", help="standalone OpenHarmony native SDK directory (uses ohos.toolchain.cmake)")
    args = parser.parse_args(argv)
    if not args.no_build:
        harmony_ndk_root, harmony_cmake, harmony_toolchain_file = resolve_native_sdk(args, parser)
    enable_jsvm_tests = args.enable_ut and not args.disable_jsvm
    if args.enable_ut and args.disable_jsvm:
        print('JSVM is disabled; skipping JSVM-specific unit tests')
    commit_hash = os.popen('git rev-parse HEAD').read().strip()
    if not args.no_build:
        abis = ['arm64-v8a', 'x86_64'] # temporarily build arm64
        with tempfile.TemporaryDirectory() as temp_dir:
            for abi in abis:
                # 1. create native lib dir
                native_lib_dir = os.path.join(temp_dir, abi)
                os.makedirs(native_lib_dir, exist_ok=True)
                if args.build_type != "Debug":
                    args.build_type = "Release"
                # build harmony native libs
                cmake_cmd = [
                    f"{harmony_cmake}",
                    f"-DOHOS_ARCH={abi}",
                    f"-DCMAKE_SYSTEM_NAME=OHOS",
                    f"-DOHOS_SDK_NATIVE={harmony_ndk_root}",
                    f"-DCMAKE_TOOLCHAIN_FILE={harmony_toolchain_file}",
                    f"-DCMAKE_BUILD_TYPE={args.build_type}",
                    f"-DENABLE_LEPUSNG=true",
                    f"-DENABLE_WORKER=true" if args.build_worker else "-DENABLE_WORKER=false",
                    f"-DENABLE_MONITOR=true",
                    f"-DENABLE_QUICKJS_DEBUGGER=true",
                    f"-DENABLE_COMPATIBLE_MM=true",
                    f"-LH",
                    f'-DENABLE_BUILD_AAR=true',
                    f'-DENABLE_PRIMJS_HARMONY=true', 
                    f"-DENABLE_JSVM={'OFF' if args.disable_jsvm else 'ON'}",
                    f"-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
                    f"-DENABLE_UNITTESTS={enable_jsvm_tests}",
                    f"-DENABLE_NAPI_ADAPTER=true" if args.build_napi_adapter else "-DENABLE_NAPI_ADAPTER=false",
                    f"-DUSE_WEAK_SUFFIX_NAPI=true",
                    f"{PRIMJS_DIR}/harmony/primjs",
                ]
                check_call(cmake_cmd, cwd=native_lib_dir)
                make_cmd = "make napi quick"
                libs = ["libquick.so", "libnapi.so"]
                if args.build_napi_v8:
                    make_cmd = f'{make_cmd} napi_v8'
                    libs.append("libnapi_v8.so")
                if args.build_napi_adapter:
                    make_cmd = f'{make_cmd} napi_adapter'
                    libs.append("libnapi_adapter.so")
                if args.build_worker:
                    make_cmd = f'{make_cmd} worker'
                    libs.append("libworker.so")
                if enable_jsvm_tests:
                    make_cmd = f'{make_cmd} napi_test'
                    libs.append("libnapi_test.so")
                make_cmd = make_cmd + " VERBOSE=1"

                check_call(make_cmd, shell=True, cwd=native_lib_dir)

                # 3. copy libs to har specified path
                for lib in libs:
                    lib_path = os.path.join(HARMONY_DIR, "primjs/libs", abi)
                    if not os.path.exists(lib_path):
                        os.makedirs(lib_path)
                    cp_cmd = f'cp {os.path.join(native_lib_dir, "binary", lib)} {lib_path}/'
                    check_call(cp_cmd, shell=True, cwd=native_lib_dir)

    if args.only_build:
        return 0

    modules = args.modules if args.modules else []
    if len(modules) == 0:
        print('no module specified to build')
        return 0

    publish_version = args.version if args.version else parse_version_file(args.unofficial_publish, commit_hash)

    for module in modules:
        module_config_list = collect_module_config_list(args)
        for module_config in module_config_list:
            if module_config['name'] == module:
                module_path = module_config['srcPath']
                break
        else:
            raise Exception(f"module {module} not found in build-profile.json5")
        module_full_path = os.path.join(HARMONY_DIR, module_path)
        patch_oh_package(module_full_path, publish_version)
        if module == "primjs":
            packJsPrimjsHeaderFiles()
        run_package_har(module, module_full_path, args.verbose)

    if args.publish_har:
        publish_primjs(publish_version, args.unofficial_publish, modules)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
