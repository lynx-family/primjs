// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
function test_debugger_keyword() {
	let a = true;
	if(a) {
		debugger;
	}
}

test_debugger_keyword();


function test_debugger_keyword2() {
	for(let i = 0; i < 10; i++) {
		debugger;
	}
}
test_debugger_keyword2();