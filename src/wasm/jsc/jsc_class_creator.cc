// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_class_creator.h"

#include "jsc/jsc_ext_api.h"

namespace primjs::jsc {
JSClassRef JSClassCreator::JSCreateClass(const JSClassDefinition& def) {
  return JSClassCreate(&def);
}

JSClassRef JSClassCreator::JSCreateClass(const char* name,
                                         JSObjectFinalizeCallback finalizer) {
  JSClassDefinition def = GetClassDefinition(name, finalizer);
  return JSClassCreate(&def);
}

JSClassDefinition JSClassCreator::GetClassDefinition(
    const char* name, JSObjectFinalizeCallback finalizer,
    JSObjectCallAsConstructorCallback ctorCallback) {
  JSClassDefinition def = kJSClassDefinitionEmpty;
  def.attributes = kJSClassAttributeNoAutomaticPrototype;
  if (ctorCallback) {
    def.callAsConstructor = ctorCallback;
    // callAsFunction must be set so as to make typeof(constructor) ==
    // "function" for [[Constructor]], NOTE(): def.callAsFunction can be
    // overwritten by GetClassDefinition caller to allow the constructor can be
    // [[Call]] rather than the default behavior to throw exception.
    def.hasInstance = HasInstance;
    def.callAsFunction = ThrowCallException;
  }
  def.className = name;
  def.finalize = finalizer;
  return def;
}

}  // namespace primjs::jsc
