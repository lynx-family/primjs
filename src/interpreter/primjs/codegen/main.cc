// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/codegen/setup.h"
#include "primjs/son/compilationOptions.h"

extern "C" {
struct jit_descriptor {
  uint32_t version;
  uint32_t action_flag;
  void *relevant_entry;
  void *first_entry;
};
extern struct jit_descriptor __jit_debug_descriptor = {1, 0, 0, 0};

void __jit_debug_register_code() {}
extern "C" void __jit_debug_register_code();

int setupterm(char *term, int filedes, int *errret) { return 0; }
struct term *set_curterm(struct term *termp) { return nullptr; }
int del_curterm(struct term *termp) { return 0; }
int tigetnum(char *capname) { return 0; }
#ifdef HAVE_TERMINFO
extern "C" int setupterm(char *term, int filedes, int *errret);
extern "C" struct term *set_curterm(struct term *termp);
extern "C" int del_curterm(struct term *termp);
extern "C" int tigetnum(char *capname);
#endif
// zstd
void ZSTD_CCtx_setParameter() {}
void ZSTD_compress2() {}
void ZSTD_createCCtx() {}
void ZSTD_freeCCtx() {}
void ZSTD_compress() {}
void ZSTD_compressBound() {}
void ZSTD_decompress() {}
void ZSTD_getErrorName() {}
void ZSTD_isError() {}
void crc32() {}
void compress2() {}
void compressBound() {}
void uncompress() {}
}

static void PrintHelper() {
  printf("USAGE: vm_codegen [options] <filename>\n");
  printf("\nOPTIONS: \n\n");
  printf("-h|--help Print available options\n");
  printf("-trace trace asm debug trace\n");
  printf("-multi-table support mutil-table opt\n");
  printf("-virtual-sp support virtual sp\n");
  printf("-no-fast-path not support fast path\n");
}

int main(int argc, char **argv) {
  if (argc < 1) {
    fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
    exit(EXIT_FAILURE);
    return EXIT_FAILURE;
  }

  const char *file_name = nullptr;
  son::CompilationOptions options;
  bool use_fast_path = true;
  for (int i = 1; i < argc; ++i) {
    std::string_view arg(argv[i]);
    if (arg == "-h" || arg == "--help") {
      PrintHelper();
    } else if (arg == "-trace") {
      options.SetFlag(son::CompilationOptions::Flag::kDebugTrace);
    } else if (arg == "-multi-table") {
      options.SetFlag(son::CompilationOptions::Flag::kSupportMutiTable);
    } else if (arg == "-virtual-sp") {
      options.SetFlag(son::CompilationOptions::Flag::kSupportVirtualSp);
    } else if (arg == "-no-fast-path") {
      use_fast_path = false;
    } else if (!arg.empty() && arg.front() == '-') {
      fprintf(stderr, "Unknown option: %.*s\n", static_cast<int>(arg.size()),
              arg.data());
      return EXIT_FAILURE;
    } else {
      file_name = argv[i];
    }
  }

  if (use_fast_path) {
    options.SetFlag(son::CompilationOptions::Flag::kUseFastPath);
  }

  primjs::InterpreterSetup::Setup(file_name, options);
  return 0;
}
