//
//  m3_bind.c
//
//  Created by Steven Massey on 4/29/19.
//  Copyright © 2019 Steven Massey. All rights reserved.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "m3_env.h"
#include "m3_exception.h"
#include "m3_info.h"

u8 ConvertTypeCharToTypeId(char i_code) {
  switch (i_code) {
    case 'v':
      return c_m3Type_none;
    case 'i':
      return c_m3Type_i32;
    case 'I':
      return c_m3Type_i64;
    case 'f':
      return c_m3Type_f32;
    case 'F':
      return c_m3Type_f64;
    case '*':
      return c_m3Type_i32;
  }
  return c_m3Type_unknown;
}

M3Result SignatureToFuncType(IM3FuncType* o_functionType, ccstr_t i_signature) {
  IM3FuncType funcType = NULL;

  _try {
    if (not o_functionType) _throw("null function type");

    if (not i_signature) _throw("null function signature");

    cstr_t sig = i_signature;

    size_t maxNumTypes = strlen(i_signature);

    // assume min signature is "()"
    _throwif(m3Err_malformedFunctionSignature, maxNumTypes < 2);
    maxNumTypes -= 2;

    _throwif(m3Err_tooManyArgsRets,
             maxNumTypes > d_m3MaxSaneFunctionArgRetCount);

    _(AllocFuncType(&funcType, (u32)maxNumTypes));

    u8* typelist = funcType->types;

    bool parsingRets = true;
    while (*sig) {
      char typeChar = *sig++;

      if (typeChar == '(') {
        parsingRets = false;
        continue;
      } else if (typeChar == ' ')
        continue;
      else if (typeChar == ')')
        break;

      u8 type = ConvertTypeCharToTypeId(typeChar);

      _throwif("unknown argument type char", c_m3Type_unknown == type);

      if (type == c_m3Type_none) continue;

      if (parsingRets) {
        _throwif("malformed signature; return count overflow",
                 funcType->numRets >= maxNumTypes);
        funcType->numRets++;
        *typelist++ = type;
      } else {
        _throwif("malformed signature; arg count overflow",
                 (u32)(funcType->numRets) + funcType->numArgs >= maxNumTypes);
        funcType->numArgs++;
        *typelist++ = type;
      }
    }
  }
_catch:

  if (result) m3_Free(funcType);

  *o_functionType = funcType;

  return result;
}

static M3Result ValidateSignature(IM3Function i_function,
                                  ccstr_t i_linkingSignature) {
  M3Result result = m3Err_none;

  IM3FuncType ftype = NULL;
  _(SignatureToFuncType(&ftype, i_linkingSignature));

  if (not AreFuncTypesEqual(ftype, i_function->funcType)) {
    m3log(module, "expected: %s", SPrintFuncTypeSignature(ftype));
    m3log(module, "   found: %s",
          SPrintFuncTypeSignature(i_function->funcType));

    _throw("function signature mismatch");
  }

_catch:

  m3_Free(ftype);

  return result;
}

M3Result FindAndLinkFunction(IM3Module io_module, ccstr_t i_moduleName,
                             ccstr_t i_functionName, ccstr_t i_signature,
                             voidptr_t i_function, voidptr_t i_userdata) {
  _try {
    _throwif(m3Err_moduleNotLinked, !io_module->runtime);

    const bool wildcardModule = (strcmp(i_moduleName, "*") == 0);

    result = m3Err_functionLookupFailed;

    for (u32 i = 0; i < io_module->numFunctions; ++i) {
      const IM3Function f = &io_module->functions[i];

      if (f->import.moduleUtf8 and f->import.fieldUtf8) {
        if (strcmp(f->import.fieldUtf8, i_functionName) == 0 and
            (wildcardModule or
             strcmp(f->import.moduleUtf8, i_moduleName) == 0)) {
          if (i_signature) {
            _(ValidateSignature(f, i_signature));
          }
          _(CompileRawFunction(io_module, f, i_function, i_userdata));
        }
      }
    }
  }
_catch:
  return result;
}

M3Result m3_LinkRawFunctionEx(IM3Module io_module,
                              const char* const i_moduleName,
                              const char* const i_functionName,
                              const char* const i_signature,
                              M3RawCall i_function, const void* i_userdata) {
  return FindAndLinkFunction(io_module, i_moduleName, i_functionName,
                             i_signature, (voidptr_t)i_function, i_userdata);
}

M3Result m3_LinkRawFunction(IM3Module io_module, const char* const i_moduleName,
                            const char* const i_functionName,
                            const char* const i_signature,
                            M3RawCall i_function) {
  return FindAndLinkFunction(io_module, i_moduleName, i_functionName,
                             i_signature, (voidptr_t)i_function, NULL);
}

// Only called from outside (out of wasm3 runtime). Owner of this memory is
// outside, so no one in wasm3 runtime will free this memory.
M3Result m3_NewMemory(IM3Memory* p_memory, IM3Runtime io_runtime,
                      uint32_t initial, uint32_t maximum) {
  if (initial > maximum || maximum > 65536) {
    return m3Err_memoryInvalidRange;
  }

  IM3Memory i_memory = m3_AllocStruct(M3Memory);
  if (!i_memory) {
    return m3Err_mallocFailed;
  }

  M3Result result = AllocMemory(i_memory, io_runtime, initial);
  if (result) {
    m3_Free(i_memory);
    return result;
  }

  i_memory->maxPages = maximum;
  *p_memory = i_memory;

  return result;
}

// Link Memory on one module, but not meaning module or runtime owns this
// memory. For example, in JS, instance of WebAssembly.Memory is responsible for
// destructing the memory.
M3Result m3_LinkMemory(IM3Module io_module, IM3Memory i_memory) {
  if (M3_UNLIKELY(!i_memory || !i_memory->mallocated)) {
    return m3Err_memoryImportMissing;
  }
  io_module->memory = i_memory;

  if (M3_UNLIKELY(!i_memory->mallocated)) {
    return m3Err_unallocatedMemory;
  }

  M3ModuleList* moduleList = m3_AllocStruct(M3ModuleList);

  moduleList->next = i_memory->mallocated->moduleList;
  i_memory->mallocated->moduleList = moduleList;
  moduleList->module = io_module;

  return m3Err_none;
}

// Can be called if the external memory has been completely deleted but the
// module still exists, or modules using this memory has been deleted but memory
// exists.
M3Result m3_UnLinkMemory(IM3Module io_module, IM3Memory i_memory) {
  if (M3_UNLIKELY(!io_module)) return m3Err_none;

  if (io_module->memory) io_module->memory = NULL;

  if (i_memory && i_memory->mallocated) {
    M3ModuleList* item = i_memory->mallocated->moduleList;
    M3ModuleList* prev = NULL;
    while (item) {
      if (item->module == io_module) {
        if (prev)
          prev->next = item->next;
        else
          i_memory->mallocated->moduleList = item->next;
        m3_Free(item);
        break;
      }
      prev = item;
      item = item->next;
    }
  }

  return m3Err_none;
}

M3Result m3_FreeMemory(IM3Memory i_memory) {
  M3Result result = m3Err_none;

  if (i_memory) {
    if (i_memory->mallocated) {
      M3ModuleList* head = i_memory->mallocated->moduleList;
      M3ModuleList* node = NULL;
      while (head) {
        node = head;
        head = head->next;
        if (node->module) {
          node->module->memory = NULL;
        }
        m3_Free(node);
      }
    }
    m3_Free(i_memory->mallocated);
  }
  m3_Free(i_memory);

  result = m3Err_releasedMemory;

  return result;
}

M3Result m3_GrowMemory(IM3Memory i_memory, IM3Runtime io_runtime,
                       uint32_t numPagesToGrow) {
  return ResizeMemory(i_memory, io_runtime,
                      i_memory->numPages + numPagesToGrow);
}

// Table
M3Result m3_NewTable(IM3Table* p_table, M3TableElemType tableElemTy,
                     uint32_t initial, uint32_t maximum) {
  if (initial > maximum || maximum > d_m3MaxSaneTableSize) {
    return m3Err_tableInvalidRange;
  }

  IM3Table i_table = m3_AllocStruct(M3Table);
  if (!i_table) {
    return m3Err_mallocFailed;
  }

  // FIXME: handle cases when initial = 0;
  i_table->funcs = m3_AllocArray(IM3Function, initial);
  if (not i_table->funcs && initial > 0) {
    m3_Free(i_table);
    return m3Err_mallocFailed;
  }

  i_table->info.curSize = initial;
  i_table->info.maxSize = maximum;
  i_table->info.elemTy = tableElemTy;

  *(p_table) = i_table;

  return m3Err_none;
}

M3Result m3_LinkTable(IM3Module io_module, IM3Table i_table) {
  d_m3Assert(!i_table->mod && !io_module->table);
  // The caller is responsible to pass a M3Module need a table imported
  // and a valid M3Table.
  M3TableInfo info = i_table->info;
  M3TableInfo t_info = io_module->tableInfo;

  if (info.curSize != t_info.curSize || info.maxSize != t_info.maxSize ||
      info.elemTy != t_info.elemTy) {
    return m3Err_tableImportMissing;
  }

  io_module->table = i_table;
  io_module->tableElems = i_table->funcs;
  i_table->mod = io_module;
  i_table->info.tableName = io_module->tableInfo.tableName;

  return m3Err_none;
}

M3Result m3_GrowTable(IM3Table i_table, uint32_t numToGrow) {
  uint32_t newSize = i_table->info.curSize + numToGrow;
  if (newSize > i_table->info.maxSize) {
    return m3Err_tableInvalidRange;
  }
  i_table->funcs = m3_ReallocArray(IM3Function, i_table->funcs, newSize,
                                   i_table->info.curSize);

  if (not i_table->funcs) {
    return m3Err_mallocFailed;
  }
  if (i_table->mod) {
    i_table->mod->tableElems = i_table->funcs;
    i_table->mod->tableInfo.curSize = newSize;
  }
  i_table->info.curSize = newSize;

  return m3Err_none;
}

IM3Table m3_GetTable(IM3Module io_module) {
  if (io_module->table == NULL && io_module->tableElems) {
    IM3Table table = m3_AllocStruct(M3Table);
    if (M3_LIKELY(table)) {
      io_module->table = table;
      table->funcs = io_module->tableElems;
      table->info = io_module->tableInfo;
      table->mod = io_module;
    }
  }
  return io_module->table;
}

void m3_FreeTable(IM3Table i_table) {
  if (i_table->mod) {
    // Detach the linked module.
    i_table->mod->table = NULL;
  } else {
    // If a module is detached or no module is linked to
    // this table at all, the array is released here.
    m3_Free(i_table->funcs);
  }
  m3_Free(i_table);
}
