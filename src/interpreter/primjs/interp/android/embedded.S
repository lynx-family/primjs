#if defined(__aarch64__) && defined(ENABLE_PRIMJS_SNAPSHOT) && !defined(ENABLE_QUICKJS_DEBUGGER)
	.file	"primjs"
	.text
	.p2align	2                               // -- Begin function call_native_entry_asm_h
	.type	.Lcall_native_entry_asm_h,@function
.Lcall_native_entry_asm_h:              // @call_native_entry_asm_h
	.cfi_startproc
// %bb.0:                               // %B29
	stp	x29, x30, [sp, #-16]!           // 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldrh	w9, [x22, #6]
	ldr	x8, [x24, #8]
	add	w10, w9, w9, lsl #2
	ldr	x8, [x8, #80]
	cmp	w9, #12
	add	w10, w10, #3
	ldr	x8, [x8, w10, uxtw #3]
	b.ne	.LBB0_26
// %bb.1:                               // %B12
	ldrb	w9, [x22, #40]
	mov	w3, w0
	cmp	w3, w9
	b.lt	.LBB0_31
// %bb.2:                               // %B26
	ldr	x8, [x24, #296]
	ldr	x9, [x8]
	sub	x8, sp, #144
	cmp	x8, x9
	b.ls	.LBB0_29
// %bb.3:                               // %B15
	mov	x19, sp
	mov	sp, x8
	stp	x23, x22, [x8]
	mov	x28, x20
	mov	x27, xzr
	stp	xzr, xzr, [x8, #48]
	stp	w3, wzr, [x8, #40]
	stp	x20, xzr, [x8, #16]
	str	xzr, [x8, #64]
	str	wzr, [x8, #72]
	ldr	x9, [x24, #8]
	str	x8, [x9, #256]
	ldrb	w9, [x22, #41]
	ldr	x8, [x22, #32]
	cmp	w9, #7
	b.gt	.LBB0_8
// %bb.4:                               // %B15
	cmp	w9, #3
	b.gt	.LBB0_12
// %bb.5:                               // %B15
	cbz	w9, .LBB0_19
// %bb.6:                               // %B15
	cmp	w9, #1
	b.ne	.LBB0_24
// %bb.7:                               // %B19
	ldrsh	w4, [x22, #42]
	mov	x1, x21
	mov	x0, x24
	b	.LBB0_15
.LBB0_8:                                // %B15
	cmp	w9, #9
	b.gt	.LBB0_16
// %bb.9:                               // %B15
	cmp	w9, #8
	b.eq	.LBB0_20
// %bb.10:                              // %B15
	cmp	w9, #9
	b.ne	.LBB0_24
// %bb.11:                              // %B22
	ldr	x2, [x20]
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	.LBB0_25
.LBB0_12:                               // %B15
	cmp	w9, #4
	b.eq	.LBB0_21
// %bb.13:                              // %B15
	cmp	w9, #5
	b.ne	.LBB0_24
// %bb.14:                              // %B18
	ldrsh	w4, [x22, #42]
	mov	x0, x24
	mov	w1, #18                         // =0x12
.LBB0_15:                               // %B21
	mov	w2, w3
	mov	x3, x20
	blr	x8
	b	.LBB0_25
.LBB0_16:                               // %B15
	cmp	w9, #10
	b.eq	.LBB0_23
// %bb.17:                              // %B15
	cmp	w9, #11
	b.ne	.LBB0_24
// %bb.18:                              // %B24
	ldr	x2, [x20]
	ldrsh	w3, [x22, #42]
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	.LBB0_25
.LBB0_19:                               // %B17
	mov	x1, x21
	mov	x0, x24
	b	.LBB0_22
.LBB0_20:                               // %B20
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	.LBB0_25
.LBB0_21:                               // %B16
	mov	x0, x24
	mov	w1, #18                         // =0x12
.LBB0_22:                               // %B21
	mov	w2, w3
	mov	x3, x20
	blr	x8
	b	.LBB0_25
.LBB0_23:                               // %B23
	ldrsh	w2, [x22, #42]
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	.LBB0_25
.LBB0_24:                               // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	x4, x20
	bl	prim_call_c_function_default
.LBB0_25:                               // %B21
	ldr	x8, [x24, #8]
	mov	x1, x0
	mov	x30, x28
	mov	x0, x1
	str	x23, [x8, #256]
	mov	sp, x19
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	ret
.LBB0_26:                               // %B29
	cmp	w9, #15
	b.ne	.LBB0_30
// %bb.27:                              // %B8
	ldr	x9, [x22, #32]
	mov	w2, w0
	ldrb	w10, [x9, #8]
	cmp	w2, w10
	b.lt	.LBB0_31
// %bb.28:                              // %B10
	ldr	x8, [x9]
	ldrh	w4, [x9, #10]
	add	x5, x9, #16
	mov	x0, x24
	mov	x1, x21
	mov	x3, x20
	blr	x8
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	ret
.LBB0_29:                               // %B27
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	b	.LThrowStackOverflow_Return_asm_h
.LBB0_30:                               // %B2
	cbz	x8, .LBB0_32
.LBB0_31:                               // %B5
	mov	x3, x0
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	x4, x20
	mov	w5, w19
                                        // kill: def $w3 killed $w3 killed $x3
	blr	x8
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	ret
.LBB0_32:                               // %B3
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	b	.LThrowTypeErrorNotFunction_Return_asm_h
.Lfunc_end0:
	.size	.Lcall_native_entry_asm_h, .Lfunc_end0-.Lcall_native_entry_asm_h
	.cfi_endproc
                                        // -- End function
	.p2align	2                               // -- Begin function ThrowTypeErrorNotFunction_Return_asm_h
	.type	.LThrowTypeErrorNotFunction_Return_asm_h,@function
.LThrowTypeErrorNotFunction_Return_asm_h: // @ThrowTypeErrorNotFunction_Return_asm_h
// %bb.0:                               // %B0
	mov	x0, x24
	mov	x22, x30
	bl	JS_ThrowTypeErrorNotFunction
	mov	x30, x22
	ret
.Lfunc_end1:
	.size	.LThrowTypeErrorNotFunction_Return_asm_h, .Lfunc_end1-.LThrowTypeErrorNotFunction_Return_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function ThrowStackOverflow_Return_asm_h
	.type	.LThrowStackOverflow_Return_asm_h,@function
.LThrowStackOverflow_Return_asm_h:      // @ThrowStackOverflow_Return_asm_h
// %bb.0:                               // %B0
	mov	x0, x24
	mov	x22, x30
	bl	JS_ThrowStackOverflow
	mov	x30, x22
	ret
.Lfunc_end2:
	.size	.LThrowStackOverflow_Return_asm_h, .Lfunc_end2-.LThrowStackOverflow_Return_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_native_asm_h
	.type	.Lcall_native_asm_h,@function
.Lcall_native_asm_h:                    // @call_native_asm_h
	.cfi_startproc
// %bb.0:                               // %B29
	stp	x29, x30, [sp, #-16]!           // 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldrh	w9, [x22, #6]
	ldr	x8, [x24, #8]
	add	w10, w9, w9, lsl #2
	ldr	x8, [x8, #80]
	cmp	w9, #12
	add	w10, w10, #3
	ldr	x8, [x8, w10, uxtw #3]
	b.ne	.LBB3_26
// %bb.1:                               // %B12
	ldrb	w9, [x22, #40]
	mov	w3, w0
	cmp	w3, w9
	b.lt	.LBB3_31
// %bb.2:                               // %B26
	ldr	x8, [x24, #296]
	ldr	x9, [x8]
	sub	x8, sp, #144
	cmp	x8, x9
	b.ls	.LBB3_29
// %bb.3:                               // %B15
	mov	x19, sp
	mov	sp, x8
	stp	x23, x22, [x8]
	mov	x28, x20
	mov	x27, xzr
	stp	xzr, xzr, [x8, #48]
	stp	w3, wzr, [x8, #40]
	stp	x20, xzr, [x8, #16]
	str	xzr, [x8, #64]
	str	wzr, [x8, #72]
	ldr	x9, [x24, #8]
	str	x8, [x9, #256]
	ldrb	w9, [x22, #41]
	ldr	x8, [x22, #32]
	cmp	w9, #7
	b.gt	.LBB3_8
// %bb.4:                               // %B15
	cmp	w9, #3
	b.gt	.LBB3_12
// %bb.5:                               // %B15
	cbz	w9, .LBB3_19
// %bb.6:                               // %B15
	cmp	w9, #1
	b.ne	.LBB3_24
// %bb.7:                               // %B19
	ldrsh	w4, [x22, #42]
	mov	x1, x21
	mov	x0, x24
	b	.LBB3_15
.LBB3_8:                                // %B15
	cmp	w9, #9
	b.gt	.LBB3_16
// %bb.9:                               // %B15
	cmp	w9, #8
	b.eq	.LBB3_20
// %bb.10:                              // %B15
	cmp	w9, #9
	b.ne	.LBB3_24
// %bb.11:                              // %B22
	ldr	x2, [x20]
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	.LBB3_25
.LBB3_12:                               // %B15
	cmp	w9, #4
	b.eq	.LBB3_21
// %bb.13:                              // %B15
	cmp	w9, #5
	b.ne	.LBB3_24
// %bb.14:                              // %B18
	ldrsh	w4, [x22, #42]
	mov	x0, x24
	mov	w1, #18                         // =0x12
.LBB3_15:                               // %B21
	mov	w2, w3
	mov	x3, x20
	blr	x8
	b	.LBB3_25
.LBB3_16:                               // %B15
	cmp	w9, #10
	b.eq	.LBB3_23
// %bb.17:                              // %B15
	cmp	w9, #11
	b.ne	.LBB3_24
// %bb.18:                              // %B24
	ldr	x2, [x20]
	ldrsh	w3, [x22, #42]
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	.LBB3_25
.LBB3_19:                               // %B17
	mov	x1, x21
	mov	x0, x24
	b	.LBB3_22
.LBB3_20:                               // %B20
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	.LBB3_25
.LBB3_21:                               // %B16
	mov	x0, x24
	mov	w1, #18                         // =0x12
.LBB3_22:                               // %B21
	mov	w2, w3
	mov	x3, x20
	blr	x8
	b	.LBB3_25
.LBB3_23:                               // %B23
	ldrsh	w2, [x22, #42]
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	.LBB3_25
.LBB3_24:                               // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	x4, x20
	bl	prim_call_c_function_default
.LBB3_25:                               // %B21
	ldr	x8, [x24, #8]
	mov	x1, x0
	mov	x30, x28
	mov	x0, x1
	str	x23, [x8, #256]
	mov	sp, x19
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	ret
.LBB3_26:                               // %B29
	cmp	w9, #15
	b.ne	.LBB3_30
// %bb.27:                              // %B8
	ldr	x9, [x22, #32]
	mov	w2, w0
	ldrb	w10, [x9, #8]
	cmp	w2, w10
	b.lt	.LBB3_31
// %bb.28:                              // %B10
	ldr	x8, [x9]
	ldrh	w4, [x9, #10]
	add	x5, x9, #16
	mov	x0, x24
	mov	x1, x21
	mov	x3, x20
	blr	x8
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	ret
.LBB3_29:                               // %B27
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	b	.LThrowStackOverflow_Return_asm_h
.LBB3_30:                               // %B2
	cbz	x8, .LBB3_32
.LBB3_31:                               // %B5
	mov	x3, x0
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	x4, x20
	mov	w5, wzr
                                        // kill: def $w3 killed $w3 killed $x3
	blr	x8
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	ret
.LBB3_32:                               // %B3
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	b	.LThrowTypeErrorNotFunction_Return_asm_h
.Lfunc_end3:
	.size	.Lcall_native_asm_h, .Lfunc_end3-.Lcall_native_asm_h
	.cfi_endproc
                                        // -- End function
	.p2align	2                               // -- Begin function common_call_from_entry_asm_h
	.type	.Lcommon_call_from_entry_asm_h,@function
.Lcommon_call_from_entry_asm_h:         // @common_call_from_entry_asm_h
// %bb.0:                               // %B40
	tbz	w19, #2, .LBB4_3
// %bb.1:                               // %B31
	mov	x8, sp
	and	x9, x22, #0xfffffffffffc
	stp	x8, x30, [x9, #144]
	add	x11, x9, #16
	ldr	x8, [x24, #8]
	mov	x23, x11
	ldr	x10, [x8, #256]
	str	x10, [x9, #16]
	str	x11, [x8, #256]
	ldp	x27, x19, [x9, #40]
	ldr	w8, [x9, #12]
	ldr	x20, [x9, #64]
	ldr	x28, [x9, #32]
	ldr	x26, [x9, #112]
	cbnz	w8, .LBB4_11
.LBB4_2:                                // %B23
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB4_3:                                // %B34
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB4_12
// %bb.4:                               // %B36
	ldrh	w8, [x22, #6]
	cmp	w8, #13
	b.ne	.LBB4_13
// %bb.5:                               // %B1
	ldr	x11, [x22, #32]
	ldr	x10, [x24, #296]
	mov	x12, x23
	mov	x13, sp
	ldrh	w9, [x11, #40]
	ldrh	w8, [x11, #42]
	ldrh	w15, [x11, #46]
	ldr	x14, [x10]
	cmp	w0, w9
	add	w10, w8, w15
	b.lt	.LBB4_14
// %bb.6:                               // %B28
	add	w9, w10, w0
	lsl	w9, w9, #3
	add	w9, w9, #144
	and	w10, w9, #0x8
	add	w9, w9, w10
	sub	x9, x13, x9
	cmp	x9, x14
	b.ls	.LBB4_21
// %bb.7:                               // %B30
	mov	sp, x9
	stp	x13, x30, [x9, #128]
	mov	x23, x9
	stp	x12, x22, [x9]
	stp	x21, x27, [x9, #80]
	ldr	x13, [x22, #40]
	str	x13, [x9, #96]
	mov	x26, x13
	ldrb	w10, [x11, #5]
	str	w10, [x9, #44]
	ldr	x19, [x11, #8]
	str	w0, [x9, #112]
	ldr	x12, [x11, #48]
	add	x11, x9, #144
	add	x10, x11, w0, uxtw #3
	str	x12, [x9, #104]
	mov	x12, x11
	cmp	x11, x10
	b.ge	.LBB4_9
.LBB4_8:                                // %B25
                                        // =>This Inner Loop Header: Depth=1
	ldr	x13, [x20], #8
	str	x13, [x12], #8
	cmp	x12, x10
	b.lt	.LBB4_8
.LBB4_9:                                // %B27
	add	w12, w0, w8
	str	w0, [x9, #40]
	add	x20, x10, x8, lsl #3
	stp	x11, x10, [x9, #16]
	mov	w8, #18                         // =0x12
	mov	x28, x11
	str	xzr, [x9, #64]
	mov	x27, x10
	str	w12, [x9, #72]
	ldr	x12, [x24, #8]
	str	x9, [x12, #256]
	cmp	x10, x20
	b.ge	.LBB4_2
.LBB4_10:                               // %B21
                                        // =>This Inner Loop Header: Depth=1
	str	x8, [x10], #8
	cmp	x10, x20
	b.lt	.LBB4_10
	b	.LBB4_2
.LBB4_11:                               // %B32
	b	.Lexception_asm_h
.LBB4_12:                               // %B39
	b	.LThrowTypeErrorNotFunction_Return_asm_h
.LBB4_13:                               // %B37
	b	.Lcall_native_entry_asm_h
.LBB4_14:                               // %B16
	add	w10, w10, w9
	lsl	w10, w10, #3
	add	w10, w10, #144
	and	w15, w10, #0x8
	add	w10, w10, w15
	sub	x10, x13, x10
	cmp	x10, x14
	b.ls	.LBB4_21
// %bb.15:                              // %B18
	mov	sp, x10
	stp	x13, x30, [x10, #128]
	mov	x23, x10
	stp	x12, x22, [x10]
	stp	x21, x27, [x10, #80]
	ldr	x13, [x22, #40]
	str	x13, [x10, #96]
	mov	x26, x13
	ldrb	w12, [x11, #5]
	str	w12, [x10, #44]
	ldr	x19, [x11, #8]
	str	w0, [x10, #112]
	ldr	x12, [x11, #48]
	add	x11, x10, #144
	str	x12, [x10, #104]
	mov	x12, x11
	cmp	w0, w9
	csel	w13, w0, w9, lt
	add	x13, x11, w13, uxtw #3
	cmp	x11, x13
	b.ge	.LBB4_17
.LBB4_16:                               // %B5
                                        // =>This Inner Loop Header: Depth=1
	ldr	x13, [x20], #8
	str	x13, [x12], #8
	cmp	w0, w9
	csel	w13, w0, w9, lt
	add	x13, x11, w13, uxtw #3
	cmp	x12, x13
	b.lt	.LBB4_16
.LBB4_17:                               // %B9.preheader
	add	x12, x11, x9, lsl #3
	mov	w14, #18                        // =0x12
	cmp	x13, x12
	b.ge	.LBB4_19
.LBB4_18:                               // %B10
                                        // =>This Inner Loop Header: Depth=1
	str	x14, [x13], #8
	cmp	x13, x12
	b.lt	.LBB4_18
.LBB4_19:                               // %B11
	str	w9, [x10, #40]
	add	w9, w9, w8
	add	x20, x12, x8, lsl #3
	stp	x11, x12, [x10, #16]
	mov	w8, #18                         // =0x12
	mov	x28, x11
	str	xzr, [x10, #64]
	mov	x27, x12
	str	w9, [x10, #72]
	ldr	x9, [x24, #8]
	str	x10, [x9, #256]
	cmp	x12, x20
	b.ge	.LBB4_2
.LBB4_20:                               // %B14
                                        // =>This Inner Loop Header: Depth=1
	str	x8, [x12], #8
	cmp	x12, x20
	b.lt	.LBB4_20
	b	.LBB4_2
.LBB4_21:                               // %B17
	b	.LThrowStackOverflow_Return_asm_h
.Lfunc_end4:
	.size	.Lcommon_call_from_entry_asm_h, .Lfunc_end4-.Lcommon_call_from_entry_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function exception_asm_h
	.type	.Lexception_asm_h,@function
.Lexception_asm_h:                      // @exception_asm_h
// %bb.0:                               // %B17
	sub	sp, sp, #32
	ldr	x9, [x24, #8]
	ldr	w8, [x9, #248]
	stp	x9, x20, [sp, #8]               // 16-byte Folded Spill
	ldr	x20, [x9, #240]
	cbz	w8, .LBB5_2
// %bb.1:                               // %B18
	mov	x0, x24
	mov	x1, x20
	mov	x2, xzr
	mov	x3, xzr
	mov	x4, x19
	mov	w5, wzr
	mov	w6, wzr
	bl	build_backtrace
.LBB5_2:                                // %B2
	mov	x0, x24
	mov	x1, x20
	bl	JS_IsUncatchableError_GC
	cbz	w0, .LBB5_4
.LBB5_3:                                // %B4
	ldr	x20, [sp, #16]                  // 8-byte Folded Reload
	mov	w0, #130                        // =0x82
	add	sp, sp, #32
	b	.Lcommon_return_asm_h
.LBB5_4:                                // %B6
	ldr	x8, [x23, #8]
	str	x19, [sp, #24]                  // 8-byte Folded Spill
	ldr	x8, [x8, #32]
	str	x8, [sp]                        // 8-byte Folded Spill
	ldrh	w8, [x8, #42]
	add	x20, x27, x8, lsl #3
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
.LBB5_5:                                // %B7
                                        // =>This Inner Loop Header: Depth=1
	cmp	x8, x20
	b.le	.LBB5_3
// %bb.6:                               // %B12
                                        //   in Loop: Header=BB5_5 Depth=1
	ldr	x9, [x8, #-8]!
	tst	x9, #0xffff000000000000
	b.ne	.LBB5_5
// %bb.7:                               // %B12
                                        //   in Loop: Header=BB5_5 Depth=1
	mov	w10, #247                       // =0xf7
	and	x10, x9, x10
	cmp	x10, #66
	b.ne	.LBB5_5
// %bb.8:                               // %B9
                                        //   in Loop: Header=BB5_5 Depth=1
	lsr	x9, x9, #16
	cbnz	w9, .LBB5_10
// %bb.9:                               // %B10
                                        //   in Loop: Header=BB5_5 Depth=1
	ldur	x1, [x8, #-16]
	mov	x0, x24
	mov	w2, #1                          // =0x1
	sub	x19, x8, #8
	bl	JS_IteratorClose
	mov	x8, x19
	ldr	x19, [sp, #24]                  // 8-byte Folded Reload
	b	.LBB5_5
.LBB5_10:                               // %B11
	ldr	x12, [sp, #8]                   // 8-byte Folded Reload
	mov	w11, #2                         // =0x2
	ldr	x10, [x12, #240]
	str	x10, [x8], #8
	ldr	x10, [sp]                       // 8-byte Folded Reload
	str	x11, [x12, #240]
	mov	x20, x8
	ldr	x10, [x10, #8]
	add	x19, x10, w9, sxtw
	ldrb	w9, [x19], #1
	ldr	x1, [x25, x9, lsl #3]
	add	sp, sp, #32
	br	x1
.Lfunc_end5:
	.size	.Lexception_asm_h, .Lfunc_end5-.Lexception_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function common_call_asm_h
	.type	.Lcommon_call_asm_h,@function
.Lcommon_call_asm_h:                    // @common_call_asm_h
// %bb.0:                               // %B30
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB6_7
// %bb.1:                               // %B27
	ldrh	w8, [x22, #6]
	cmp	w8, #13
	b.ne	.LBB6_8
// %bb.2:                               // %B1
	ldr	x11, [x22, #32]
	ldr	x10, [x24, #296]
	mov	x12, x23
	mov	x13, sp
	ldrh	w9, [x11, #40]
	ldrh	w8, [x11, #42]
	ldrh	w15, [x11, #46]
	ldr	x14, [x10]
	cmp	w0, w9
	add	w10, w8, w15
	b.lt	.LBB6_9
// %bb.3:                               // %B24
	lsl	w9, w10, #3
	add	w9, w9, #144
	and	w10, w9, #0x8
	add	w9, w9, w10
	sub	x9, x13, x9
	cmp	x9, x14
	b.ls	.LBB6_17
// %bb.4:                               // %B26
	mov	sp, x9
	stp	x13, x30, [x9, #128]
	mov	x23, x9
	mov	x28, x20
	stp	x12, x22, [x9]
	stp	x21, x27, [x9, #80]
	ldr	x12, [x22, #40]
	str	x12, [x9, #96]
	mov	x26, x12
	ldrb	w10, [x11, #5]
	str	w10, [x9, #44]
	ldr	x19, [x11, #8]
	str	w0, [x9, #112]
	ldr	x10, [x11, #48]
	add	w11, w0, w8
	str	w0, [x9, #40]
	str	xzr, [x9, #64]
	str	x10, [x9, #104]
	add	x10, x9, #144
	stp	x20, x10, [x9, #16]
	add	x8, x10, x8, lsl #3
	mov	x27, x10
	str	w11, [x9, #72]
	ldr	x11, [x24, #8]
	str	x9, [x11, #256]
	mov	w11, #18                        // =0x12
	cmp	x10, x8
	b.ge	.LBB6_6
.LBB6_5:                                // %B21
                                        // =>This Inner Loop Header: Depth=1
	str	x11, [x10], #8
	cmp	x10, x8
	b.lt	.LBB6_5
.LBB6_6:                                // %B23
	ldrb	w9, [x19], #1
	mov	x20, x8
	ldr	x1, [x25, x9, lsl #3]
	br	x1
.LBB6_7:                                // %B32
	b	.LThrowTypeErrorNotFunction_Return_asm_h
.LBB6_8:                                // %B28
	b	.Lcall_native_asm_h
.LBB6_9:                                // %B16
	add	w10, w10, w9
	lsl	w10, w10, #3
	add	w10, w10, #144
	and	w15, w10, #0x8
	add	w10, w10, w15
	sub	x10, x13, x10
	cmp	x10, x14
	b.ls	.LBB6_17
// %bb.10:                              // %B18
	mov	sp, x10
	stp	x13, x30, [x10, #128]
	mov	x23, x10
	stp	x12, x22, [x10]
	stp	x21, x27, [x10, #80]
	ldr	x13, [x22, #40]
	str	x13, [x10, #96]
	mov	x26, x13
	ldrb	w12, [x11, #5]
	str	w12, [x10, #44]
	ldr	x19, [x11, #8]
	str	w0, [x10, #112]
	ldr	x12, [x11, #48]
	add	x11, x10, #144
	str	x12, [x10, #104]
	mov	x12, x11
	cmp	w0, w9
	csel	w13, w0, w9, lt
	add	x13, x11, w13, uxtw #3
	cmp	x11, x13
	b.ge	.LBB6_12
.LBB6_11:                               // %B5
                                        // =>This Inner Loop Header: Depth=1
	ldr	x13, [x20], #8
	str	x13, [x12], #8
	cmp	w0, w9
	csel	w13, w0, w9, lt
	add	x13, x11, w13, uxtw #3
	cmp	x12, x13
	b.lt	.LBB6_11
.LBB6_12:                               // %B9.preheader
	add	x12, x11, x9, lsl #3
	mov	w14, #18                        // =0x12
	cmp	x13, x12
	b.ge	.LBB6_14
.LBB6_13:                               // %B10
                                        // =>This Inner Loop Header: Depth=1
	str	x14, [x13], #8
	cmp	x13, x12
	b.lt	.LBB6_13
.LBB6_14:                               // %B11
	str	w9, [x10, #40]
	add	w9, w9, w8
	add	x20, x12, x8, lsl #3
	stp	x11, x12, [x10, #16]
	mov	w8, #18                         // =0x12
	mov	x28, x11
	str	xzr, [x10, #64]
	mov	x27, x12
	str	w9, [x10, #72]
	ldr	x9, [x24, #8]
	str	x10, [x9, #256]
	cmp	x12, x20
	b.ge	.LBB6_16
.LBB6_15:                               // %B14
                                        // =>This Inner Loop Header: Depth=1
	str	x8, [x12], #8
	cmp	x12, x20
	b.lt	.LBB6_15
.LBB6_16:                               // %B15
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB6_17:                               // %B17
	b	.LThrowStackOverflow_Return_asm_h
.Lfunc_end6:
	.size	.Lcommon_call_asm_h, .Lfunc_end6-.Lcommon_call_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function common_return_direct_asm_h
	.type	.Lcommon_return_direct_asm_h,@function
.Lcommon_return_direct_asm_h:           // @common_return_direct_asm_h
// %bb.0:                               // %B0
	ldp	x9, x8, [x23, #128]
	ldr	x10, [x23]
	mov	x30, x8
	mov	sp, x9
	ldr	x8, [x24, #8]
	mov	x23, x10
	str	x10, [x8, #256]
	ret
.Lfunc_end7:
	.size	.Lcommon_return_direct_asm_h, .Lfunc_end7-.Lcommon_return_direct_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function common_call_debugger0_asm_h
	.type	.Lcommon_call_debugger0_asm_h,@function
.Lcommon_call_debugger0_asm_h:          // @common_call_debugger0_asm_h
// %bb.0:                               // %B0
	ldurb	w8, [x19, #-1]
	sub	w8, w8, #741
	ldr	x1, [x25, w8, sxtw #3]
	br	x1
.Lfunc_end8:
	.size	.Lcommon_call_debugger0_asm_h, .Lfunc_end8-.Lcommon_call_debugger0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function common_call_debugger1_asm_h
	.type	.Lcommon_call_debugger1_asm_h,@function
.Lcommon_call_debugger1_asm_h:          // @common_call_debugger1_asm_h
// %bb.0:                               // %B0
	ldurb	w8, [x19, #-1]
	sub	w8, w8, #494
	ldr	x1, [x25, w8, sxtw #3]
	br	x1
.Lfunc_end9:
	.size	.Lcommon_call_debugger1_asm_h, .Lfunc_end9-.Lcommon_call_debugger1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function common_call_debugger2_asm_h
	.type	.Lcommon_call_debugger2_asm_h,@function
.Lcommon_call_debugger2_asm_h:          // @common_call_debugger2_asm_h
// %bb.0:                               // %B0
	ldurb	w8, [x19, #-1]
	sub	w8, w8, #247
	ldr	x1, [x25, w8, sxtw #3]
	br	x1
.Lfunc_end10:
	.size	.Lcommon_call_debugger2_asm_h, .Lfunc_end10-.Lcommon_call_debugger2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function SlowCloseVarRefs_asm_h
	.type	.LSlowCloseVarRefs_asm_h,@function
.LSlowCloseVarRefs_asm_h:               // @SlowCloseVarRefs_asm_h
// %bb.0:                               // %B0
	mov	x22, x0
	mov	x0, x24
	mov	x1, x23
	bl	prim_close_var_refs_gc
	mov	x0, x22
	b	.Lcommon_return_direct_asm_h
.Lfunc_end11:
	.size	.LSlowCloseVarRefs_asm_h, .Lfunc_end11-.LSlowCloseVarRefs_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function common_return_asm_h
	.type	.Lcommon_return_asm_h,@function
.Lcommon_return_asm_h:                  // @common_return_asm_h
// %bb.0:                               // %B6
	ldr	x8, [x23, #64]
	cbnz	x8, .LBB12_3
// %bb.1:                               // %B1
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB12_4
// %bb.2:                               // %B1
	cbz	x26, .LBB12_4
.LBB12_3:                               // %B3
	b	.LSlowCloseVarRefs_asm_h
.LBB12_4:                               // %B5
	b	.Lcommon_return_direct_asm_h
.Lfunc_end12:
	.size	.Lcommon_return_asm_h, .Lfunc_end12-.Lcommon_return_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function exception_spill_top0_asm_h
	.type	.Lexception_spill_top0_asm_h,@function
.Lexception_spill_top0_asm_h:           // @exception_spill_top0_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lexception_asm_h
.Lfunc_end13:
	.size	.Lexception_spill_top0_asm_h, .Lfunc_end13-.Lexception_spill_top0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function exception_spill_top1_asm_h
	.type	.Lexception_spill_top1_asm_h,@function
.Lexception_spill_top1_asm_h:           // @exception_spill_top1_asm_h
// %bb.0:                               // %B0
	str	x21, [x20], #8
	b	.Lexception_asm_h
.Lfunc_end14:
	.size	.Lexception_spill_top1_asm_h, .Lfunc_end14-.Lexception_spill_top1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function exception_spill_top0_top1_asm_h
	.type	.Lexception_spill_top0_top1_asm_h,@function
.Lexception_spill_top0_top1_asm_h:      // @exception_spill_top0_top1_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lexception_asm_h
.Lfunc_end15:
	.size	.Lexception_spill_top0_top1_asm_h, .Lfunc_end15-.Lexception_spill_top0_top1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function spill_table1_to_table0_asm_h
	.type	.Lspill_table1_to_table0_asm_h,@function
.Lspill_table1_to_table0_asm_h:         // @spill_table1_to_table0_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	ldurb	w8, [x19, #-1]
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end16:
	.size	.Lspill_table1_to_table0_asm_h, .Lfunc_end16-.Lspill_table1_to_table0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function spill_table2_to_table0_asm_h
	.type	.Lspill_table2_to_table0_asm_h,@function
.Lspill_table2_to_table0_asm_h:         // @spill_table2_to_table0_asm_h
// %bb.0:                               // %B0
	stp	x22, x21, [x20], #16
	ldurb	w8, [x19, #-1]
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end17:
	.size	.Lspill_table2_to_table0_asm_h, .Lfunc_end17-.Lspill_table2_to_table0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function SlowToBoolean_asm_h
	.type	.LSlowToBoolean_asm_h,@function
.LSlowToBoolean_asm_h:                  // @SlowToBoolean_asm_h
// %bb.0:                               // %B1
	mov	x1, x0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_ToBoolFree_GC
	tbnz	w0, #31, .LBB18_2
// %bb.1:                               // %B3
	cmp	w0, #0
	mov	w8, #6                          // =0x6
	cinc	x8, x8, ne
	stur	x8, [x20, #-8]
	ldurb	w8, [x19, #-1]
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB18_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end18:
	.size	.LSlowToBoolean_asm_h, .Lfunc_end18-.LSlowToBoolean_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function SlowJSPostInc_asm_h
	.type	.LSlowJSPostInc_asm_h,@function
.LSlowJSPostInc_asm_h:                  // @SlowJSPostInc_asm_h
// %bb.0:                               // %B1
	mov	w2, w0
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	js_post_inc_slow_gc
	tbnz	w0, #31, .LBB19_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB19_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end19:
	.size	.LSlowJSPostInc_asm_h, .Lfunc_end19-.LSlowJSPostInc_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function SlowJSNot_asm_h
	.type	.LSlowJSNot_asm_h,@function
.LSlowJSNot_asm_h:                      // @SlowJSNot_asm_h
// %bb.0:                               // %B1
	mov	x1, x0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	prim_js_not_slow_gc
	cmp	x0, #130
	b.eq	.LBB20_2
// %bb.1:                               // %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB20_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end20:
	.size	.LSlowJSNot_asm_h, .Lfunc_end20-.LSlowJSNot_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function FastJSConcatString_asm_h
	.type	.LFastJSConcatString_asm_h,@function
.LFastJSConcatString_asm_h:             // @FastJSConcatString_asm_h
// %bb.0:                               // %B33
	sub	sp, sp, #48
	mov	x22, x0
	cbnz	x22, .LBB21_8
// %bb.1:                               // %B36
	ldp	x12, x11, [x20, #-16]
	mov	x9, #-281474976710653           // =0xffff000000000003
	and	x8, x12, #0xfffffffffffc
	bics	xzr, x9, x12
	b.eq	.LBB21_9
.LBB21_2:
	mov	w13, #1                         // =0x1
	bics	xzr, x9, x11
	and	x9, x11, #0xfffffffffffc
	str	x19, [sp, #40]                  // 8-byte Folded Spill
	stp	x12, x11, [sp, #16]             // 16-byte Folded Spill
	b.eq	.LBB21_10
.LBB21_3:                               // %B22
	ldr	w19, [x8, #4]
	ldr	w8, [x9, #4]
	mov	x0, x24
	mov	w1, #32                         // =0x20
	mov	w2, #20                         // =0x14
	str	x20, [sp, #32]                  // 8-byte Folded Spill
	stp	w8, w13, [sp, #8]               // 8-byte Folded Spill
	str	x20, [x23, #48]
	bl	prim_try_malloc_gc
	mov	x20, x0
	cbz	x20, .LBB21_11
// %bb.4:                               // %B14
	ldr	w11, [sp, #8]                   // 4-byte Folded Reload
	and	w9, w19, #0x3fffffff
	mov	w8, #1                          // =0x1
	str	w8, [x20]
	orr	w10, w19, w11
	and	w11, w11, #0x3fffffff
	add	w9, w9, w11
	and	w10, w10, #0x80000000
	ldr	w11, [sp, #12]                  // 4-byte Folded Reload
	orr	w9, w9, w10
	stp	w9, w11, [x20, #4]
	ldr	x9, [sp, #16]                   // 8-byte Folded Reload
	str	x9, [x20, #16]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB21_14
// %bb.5:                               // %B18
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	ldr	x19, [sp, #40]                  // 8-byte Folded Reload
	str	x9, [x20, #24]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB21_15
.LBB21_6:                               // %B1
	orr	x8, x20, #0xffff000000000003
	cbz	x22, .LBB21_16
.LBB21_7:                               // %B2
	ldrb	w9, [x19]
	str	x8, [x27, x9, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #32]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #48
	br	x1
.LBB21_8:                               // %B34
	ldrb	w8, [x19]
	ldr	x12, [x27, x8, lsl #3]
	ldur	x11, [x20, #-8]
	mov	x9, #-281474976710653           // =0xffff000000000003
	and	x8, x12, #0xfffffffffffc
	bics	xzr, x9, x12
	b.ne	.LBB21_2
.LBB21_9:                               // %B30
	ldr	w10, [x8, #8]
	add	w13, w10, #1
	bics	xzr, x9, x11
	and	x9, x11, #0xfffffffffffc
	str	x19, [sp, #40]                  // 8-byte Folded Spill
	stp	x12, x11, [sp, #16]             // 16-byte Folded Spill
	b.ne	.LBB21_3
.LBB21_10:                              // %B26
	ldr	w10, [x9, #8]
	add	w11, w10, #1
	cmp	w13, w11
	csinc	w13, w13, w10, gt
	b	.LBB21_3
.LBB21_11:                              // %B5
	ldp	x2, x8, [sp, #24]               // 16-byte Folded Reload
	mov	x0, x24
	ldr	x1, [sp, #16]                   // 8-byte Folded Reload
	str	x8, [x23, #48]
	bl	JS_ConcatString_GC
	cmp	x0, #130
	cbnz	x22, .LBB21_17
// %bb.12:                              // %B11
	b.eq	.LBB21_19
// %bb.13:                              // %B13
	ldp	x9, x19, [sp, #32]              // 16-byte Folded Reload
	stur	x0, [x9, #-16]
	ldrb	w8, [x19], #1
	sub	x20, x9, #8
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
.LBB21_14:                              // %B21
	mov	x0, x9
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	ldr	x19, [sp, #40]                  // 8-byte Folded Reload
	str	x9, [x20, #24]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB21_6
.LBB21_15:                              // %B20
	mov	x0, x9
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	orr	x8, x20, #0xffff000000000003
	cbnz	x22, .LBB21_7
.LBB21_16:                              // %B4
	ldr	x9, [sp, #32]                   // 8-byte Folded Reload
	stur	x8, [x9, #-16]
	ldrb	w8, [x19], #1
	sub	x20, x9, #8
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
.LBB21_17:                              // %B7
	b.eq	.LBB21_19
// %bb.18:                              // %B9
	ldr	x9, [sp, #40]                   // 8-byte Folded Reload
	ldrb	w8, [x9]
	add	x19, x9, #2
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x9, #1]
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #32]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #48
	br	x1
.LBB21_19:                              // %B12
	ldp	x20, x19, [sp, #32]             // 16-byte Folded Reload
	add	sp, sp, #48
	b	.Lexception_asm_h
.Lfunc_end21:
	.size	.LFastJSConcatString_asm_h, .Lfunc_end21-.LFastJSConcatString_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function FastStringEqual_asm_h
	.type	.LFastStringEqual_asm_h,@function
.LFastStringEqual_asm_h:                // @FastStringEqual_asm_h
// %bb.0:                               // %B74
	ldp	x1, x2, [x20, #-16]
	and	x8, x1, #0xfffffffffffc
	and	x9, x2, #0xfffffffffffc
	ldr	w8, [x8, #4]
	ldr	w9, [x9, #4]
	and	w8, w8, #0x3fffffff
	and	w9, w9, #0x3fffffff
	cmp	w8, w9
	b.eq	.LBB22_3
.LBB22_1:                               // %B15
	mov	w8, #6                          // =0x6
	bfxil	x8, x0, #0, #1
.LBB22_2:                               // %B16
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB22_3:                               // %B1
	mov	x8, #-281474976710653           // =0xffff000000000003
	bics	xzr, x8, x1
	b.eq	.LBB22_15
// %bb.4:                               // %B69
	bics	xzr, x8, x2
	b.eq	.LBB22_17
.LBB22_5:                               // %B54
	and	x8, x1, #0xfffffffffffc
	and	x9, x2, #0xfffffffffffc
	cmp	x8, x9
	b.eq	.LBB22_19
.LBB22_6:                               // %B57
	ldrb	w10, [x8, #7]
	tbnz	w10, #6, .LBB22_20
// %bb.7:                               // %B60
	ldr	w10, [x8, #8]
	ldrb	w11, [x9, #7]
	tbnz	w11, #6, .LBB22_21
.LBB22_8:                               // %B53
	ldr	w11, [x9, #8]
	asr	w10, w10, #30
	cmp	w10, #1
	b.ne	.LBB22_10
.LBB22_9:                               // %B49
	asr	w10, w11, #30
	cmp	w10, #1
	b.eq	.LBB22_1
.LBB22_10:                              // %B8
	ldr	w10, [x8, #4]
	ldr	w11, [x9, #4]
	add	x8, x8, #16
	add	x9, x9, #16
	tst	w10, #0xbfffffff
	and	w10, w10, #0x3fffffff
	and	w11, w11, #0xbfffffff
	b.lt	.LBB22_22
// %bb.11:                              // %B32
	tbnz	w11, #31, .LBB22_26
// %bb.12:                              // %B46.preheader
	mov	w11, wzr
	cmp	w10, wzr
	b.eq	.LBB22_19
.LBB22_13:                              // %B43
                                        // =>This Inner Loop Header: Depth=1
	ldrb	w12, [x8, w11, sxtw]
	ldrb	w13, [x9, w11, sxtw]
	cmp	w12, w13
	b.ne	.LBB22_1
// %bb.14:                              // %B45
                                        //   in Loop: Header=BB22_13 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	.LBB22_13
	b	.LBB22_19
.LBB22_15:                              // %B66
	and	x9, x1, #0xfffffffffffc
	ldr	x10, [x9, #24]
	cmp	x10, #2
	b.ne	.LBB22_29
// %bb.16:                              // %B67
	ldr	x1, [x9, #16]
	bics	xzr, x8, x2
	b.ne	.LBB22_5
.LBB22_17:                              // %B3
	and	x8, x2, #0xfffffffffffc
	ldr	x9, [x8, #24]
	cmp	x9, #2
	b.ne	.LBB22_29
// %bb.18:                              // %B4
	ldr	x2, [x8, #16]
	and	x8, x1, #0xfffffffffffc
	and	x9, x2, #0xfffffffffffc
	cmp	x8, x9
	b.ne	.LBB22_6
.LBB22_19:                              // %B21
	mvn	w9, w0
	mov	w8, #6                          // =0x6
	bfxil	x8, x9, #0, #1
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB22_20:                              // %B58
	ldr	x10, [x8, #8]
	ldr	w10, [x10]
	ldrb	w11, [x9, #7]
	tbz	w11, #6, .LBB22_8
.LBB22_21:                              // %B7
	ldr	x11, [x9, #8]
	ldr	w11, [x11]
	asr	w10, w10, #30
	cmp	w10, #1
	b.eq	.LBB22_9
	b	.LBB22_10
.LBB22_22:                              // %B10
	tbnz	w11, #31, .LBB22_31
// %bb.23:                              // %B28.preheader
	mov	w11, wzr
	cmp	w10, wzr
	b.eq	.LBB22_19
.LBB22_24:                              // %B25
                                        // =>This Inner Loop Header: Depth=1
	ldrh	w12, [x8, w11, sxtw #1]
	ldrb	w13, [x9, w11, sxtw]
	cmp	w12, w13
	b.ne	.LBB22_1
// %bb.25:                              // %B27
                                        //   in Loop: Header=BB22_24 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	.LBB22_24
	b	.LBB22_19
.LBB22_26:                              // %B38.preheader
	mov	w11, wzr
	cmp	w10, wzr
	b.eq	.LBB22_19
.LBB22_27:                              // %B35
                                        // =>This Inner Loop Header: Depth=1
	ldrb	w12, [x8, w11, sxtw]
	ldrh	w13, [x9, w11, sxtw #1]
	cmp	w12, w13
	b.ne	.LBB22_1
// %bb.28:                              // %B37
                                        //   in Loop: Header=BB22_27 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	.LBB22_27
	b	.LBB22_19
.LBB22_29:                              // %B63
	mov	w3, w0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	mov	x8, x0
	b.ne	.LBB22_2
// %bb.30:                              // %B64
	b	.Lexception_asm_h
.LBB22_31:                              // %B19.preheader
	mov	w11, wzr
	cmp	w10, wzr
	b.eq	.LBB22_19
.LBB22_32:                              // %B13
                                        // =>This Inner Loop Header: Depth=1
	ldrh	w12, [x8, w11, sxtw #1]
	ldrh	w13, [x9, w11, sxtw #1]
	cmp	w12, w13
	b.ne	.LBB22_1
// %bb.33:                              // %B18
                                        //   in Loop: Header=BB22_32 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	.LBB22_32
	b	.LBB22_19
.Lfunc_end22:
	.size	.LFastStringEqual_asm_h, .Lfunc_end22-.LFastStringEqual_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function ThrowReferenceErrorUninitialized_asm_h
	.type	.LThrowReferenceErrorUninitialized_asm_h,@function
.LThrowReferenceErrorUninitialized_asm_h: // @ThrowReferenceErrorUninitialized_asm_h
// %bb.0:                               // %B0
	mov	x0, x24
	mov	w1, wzr
	str	x20, [x23, #48]
	bl	JS_ThrowReferenceErrorUninitialized_GC
	b	.Lexception_asm_h
.Lfunc_end23:
	.size	.LThrowReferenceErrorUninitialized_asm_h, .Lfunc_end23-.LThrowReferenceErrorUninitialized_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function ThrowThisReferenceError_asm_h
	.type	.LThrowThisReferenceError_asm_h,@function
.LThrowThisReferenceError_asm_h:        // @ThrowThisReferenceError_asm_h
// %bb.0:                               // %B0
	adrp	x1, .L__unnamed_1
	add	x1, x1, :lo12:.L__unnamed_1
	mov	x0, x24
	str	x20, [x23, #48]
	bl	LEPUS_ThrowReferenceError
	b	.Lexception_asm_h
.Lfunc_end24:
	.size	.LThrowThisReferenceError_asm_h, .Lfunc_end24-.LThrowThisReferenceError_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function FastBuildArguments_asm_h
	.type	.LFastBuildArguments_asm_h,@function
.LFastBuildArguments_asm_h:             // @FastBuildArguments_asm_h
// %bb.0:                               // %B51
	sub	sp, sp, #48
	str	x20, [sp, #40]                  // 8-byte Folded Spill
	ldrb	w8, [x24, #355]
	ldr	w20, [x23, #112]
	str	x19, [sp, #24]                  // 8-byte Folded Spill
	cbnz	w8, .LBB25_19
// %bb.1:                               // %B48
	ldr	x8, [x24, #408]
	cbz	x8, .LBB25_19
// %bb.2:                               // %B45
	str	x8, [sp, #16]                   // 8-byte Folded Spill
	str	x20, [sp, #32]                  // 8-byte Folded Spill
	cbz	w20, .LBB25_8
// %bb.3:                               // %B6
	lsl	x1, x20, #3
	ldr	x8, [sp, #40]                   // 8-byte Folded Reload
	mov	x0, x24
	mov	w2, #42                         // =0x2a
	str	x8, [x23, #48]
	bl	prim_try_malloc_gc
	cbz	x0, .LBB25_19
// %bb.4:                               // %B9.preheader
	mov	x8, x0
	add	x10, x0, x20, lsl #3
	mov	x19, x28
	mov	x20, x8
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	cmp	x8, x10
	b.ge	.LBB25_9
.LBB25_5:                               // %B12
                                        // =>This Inner Loop Header: Depth=1
	ldr	x8, [x19]
	str	x8, [x20]
	ldrb	w9, [x24, #376]
	cbnz	w9, .LBB25_7
.LBB25_6:                               // %B11
                                        //   in Loop: Header=BB25_5 Depth=1
	add	x20, x20, #8
	add	x19, x19, #8
	cmp	x20, x10
	b.lt	.LBB25_5
	b	.LBB25_9
.LBB25_7:                               // %B14
                                        //   in Loop: Header=BB25_5 Depth=1
	mov	x0, x8
	mov	x1, x24
	str	x10, [sp]                       // 8-byte Folded Spill
	bl	prim_WriteBarrierNoStore
	ldr	x10, [sp]                       // 8-byte Folded Reload
	b	.LBB25_6
.LBB25_8:
	str	xzr, [sp, #8]                   // 8-byte Folded Spill
.LBB25_9:                               // %B17
	ldr	x8, [sp, #40]                   // 8-byte Folded Reload
	mov	x0, x24
	mov	w1, #16                         // =0x10
	mov	w2, #42                         // =0x2a
	str	x8, [x23, #48]
	bl	prim_try_malloc_gc
	ldr	x20, [sp, #32]                  // 8-byte Folded Reload
	mov	x9, x0
	cbz	x9, .LBB25_19
// %bb.10:                              // %B40
	ldr	x20, [x24, #192]
	str	x20, [x9]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB25_17
// %bb.11:                              // %B37
	str	x20, [x9, #8]
	ldrb	w8, [x24, #376]
	str	x9, [sp]                        // 8-byte Folded Spill
	cbnz	w8, .LBB25_18
.LBB25_12:                              // %B21
	ldr	x8, [sp, #40]                   // 8-byte Folded Reload
	mov	x0, x24
	mov	w1, #88                         // =0x58
	mov	w2, #2                          // =0x2
	str	x8, [x23, #48]
	bl	prim_try_malloc_gc
	ldr	x20, [sp, #32]                  // 8-byte Folded Reload
	ldr	x9, [sp, #16]                   // 8-byte Folded Reload
	mov	x19, x0
	ldr	x10, [sp]                       // 8-byte Folded Reload
	cbz	x19, .LBB25_19
// %bb.13:                              // %B32
	ldr	w8, [x9]
	add	w8, w8, #1
	str	w8, [x9]
	mov	w8, #1                          // =0x1
	str	w8, [x19]
	mov	w8, #13                         // =0xd
	strb	w8, [x19, #5]
	mov	w8, #8                          // =0x8
	strh	w8, [x19, #6]
	add	x8, x19, #8
	stlr	x9, [x8]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB25_21
.LBB25_14:                              // %B29
	orr	x8, x20, #0xfffe000000000000
	mov	x9, x19
	str	x8, [x9, #56]!
	ldr	x8, [sp, #8]                    // 8-byte Folded Reload
	stur	x9, [x9, #-40]
	stur	x8, [x9, #-16]
	stur	w20, [x9, #-8]
	ldr	x8, [x24, #184]
	str	x8, [x9, #8]
	ldrb	w9, [x24, #376]
	cbnz	w9, .LBB25_22
// %bb.15:                              // %B26
	str	x10, [x19, #72]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB25_23
.LBB25_16:                              // %B4
	ldr	x20, [sp, #40]                  // 8-byte Folded Reload
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	str	x19, [x20], #8
	add	x19, x9, #2
	ldrb	w8, [x9, #1]
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
.LBB25_17:                              // %B42
	mov	x0, x20
	mov	x1, x24
	mov	x19, x9
	bl	prim_WriteBarrierNoStore
	str	x20, [x19, #8]
	ldrb	w8, [x24, #376]
	str	x19, [sp]                       // 8-byte Folded Spill
	cbz	w8, .LBB25_12
.LBB25_18:                              // %B39
	mov	x0, x20
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	b	.LBB25_12
.LBB25_19:                              // %B1
	ldr	x8, [sp, #40]                   // 8-byte Folded Reload
	mov	x0, x24
	mov	w1, w20
	mov	x2, x28
	str	x8, [x23, #48]
	bl	js_build_arguments_gc
	cmp	x0, #130
	mov	x19, x0
	b.ne	.LBB25_16
// %bb.20:                              // %B2
	ldr	x19, [sp, #24]                  // 8-byte Folded Reload
	ldr	x20, [sp, #40]                  // 8-byte Folded Reload
	add	sp, sp, #48
	b	.Lexception_asm_h
.LBB25_21:                              // %B34
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	prim_WriteBarrierNoStore
	ldr	x10, [sp]                       // 8-byte Folded Reload
	b	.LBB25_14
.LBB25_22:                              // %B31
	mov	x0, x8
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldr	x10, [sp]                       // 8-byte Folded Reload
	str	x10, [x19, #72]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB25_16
.LBB25_23:                              // %B28
	mov	x0, x10
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	b	.LBB25_16
.Lfunc_end25:
	.size	.LFastBuildArguments_asm_h, .Lfunc_end25-.LFastBuildArguments_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function FastFclosure_asm_h
	.type	.LFastFclosure_asm_h,@function
.LFastFclosure_asm_h:                   // @FastFclosure_asm_h
// %bb.0:                               // %B104
	sub	sp, sp, #128
	and	x8, x0, #0xfffffffffffc
	mov	x14, x20
	str	x19, [sp, #32]                  // 8-byte Folded Spill
	str	x8, [sp, #80]                   // 8-byte Folded Spill
	ldrb	w8, [x8, #6]
	str	x20, [sp, #120]                 // 8-byte Folded Spill
	tst	w8, #0x30
	str	w8, [sp, #76]                   // 4-byte Folded Spill
	b.ne	.LBB26_38
// %bb.1:                               // %B91
	ldrb	w8, [x24, #355]
	cbnz	w8, .LBB26_38
// %bb.2:                               // %B94
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB26_38
// %bb.3:                               // %B97
	ldr	w8, [sp, #76]                   // 4-byte Folded Reload
	tst	w8, #0x1
	mov	w8, #6                          // =0x6
	cinc	w8, w8, eq
	ldr	x10, [x24, w8, uxtw #3]
	cbz	x10, .LBB26_38
// %bb.4:                               // %B9
	ldr	x8, [sp, #80]                   // 8-byte Folded Reload
	mov	w9, #47                         // =0x2f
	ldr	w8, [x8, #20]
	cmp	w8, #0
	csel	w8, w9, w8, eq
	tbnz	w8, #31, .LBB26_38
// %bb.5:                               // %B86
	ldr	x9, [x24, #8]
	ldr	x9, [x9, #64]
	ldr	x9, [x9, w8, sxtw #3]
	ldrb	w8, [x9, #7]
	tbnz	w8, #6, .LBB26_23
// %bb.6:                               // %B89
	ldr	w8, [x9, #8]
	asr	w8, w8, #30
	str	x9, [sp, #24]                   // 8-byte Folded Spill
	cmp	w8, #1
	b.ne	.LBB26_38
.LBB26_7:                               // %B19
	ldr	x8, [sp, #80]                   // 8-byte Folded Reload
	str	x10, [sp, #16]                  // 8-byte Folded Spill
	ldr	w9, [x8, #60]
	cbz	w9, .LBB26_24
// %bb.8:                               // %B82
	ldr	x8, [x8, #32]
	lsl	x1, x9, #3
	ldr	w19, [x23, #40]
	ldr	x20, [x23, #64]
	mov	x0, x24
	mov	w2, #48                         // =0x30
	stp	x8, x9, [sp, #56]               // 16-byte Folded Spill
	str	x14, [x23, #48]
	bl	prim_try_malloc_gc
	ldp	x11, x10, [sp, #56]             // 16-byte Folded Reload
	ldr	x14, [sp, #120]                 // 8-byte Folded Reload
	cbz	x0, .LBB26_38
// %bb.9:                               // %B83
	mov	w12, w19
	mov	w13, wzr
	mov	x15, x0
	mov	w19, wzr
	str	x0, [sp, #8]                    // 8-byte Folded Spill
	str	w12, [sp, #44]                  // 4-byte Folded Spill
	b	.LBB26_11
.LBB26_10:                              // %B74
                                        //   in Loop: Header=BB26_11 Depth=1
	add	w19, w19, #1
	add	w13, w13, #8
	cmp	w19, w10
	str	x8, [x15], #8
	b.hs	.LBB26_25
.LBB26_11:                              // %B25
                                        // =>This Inner Loop Header: Depth=1
	add	x8, x11, w13, uxtw
	ldrb	w9, [x8]
	tbz	w9, #0, .LBB26_14
// %bb.12:                              // %B27
                                        //   in Loop: Header=BB26_11 Depth=1
	ldrh	w16, [x8, #2]
	tst	w9, #0x2
	csel	x17, x27, x28, eq
	add	w8, w12, w16
	csel	w9, w8, w16, eq
	cbz	x20, .LBB26_16
// %bb.13:                              // %B43
                                        //   in Loop: Header=BB26_11 Depth=1
	ldr	x8, [x20, w9, uxtw #3]
	cbnz	x8, .LBB26_10
	b	.LBB26_18
.LBB26_14:                              // %B21
                                        //   in Loop: Header=BB26_11 Depth=1
	cbz	x26, .LBB26_38
// %bb.15:                              // %B23
                                        //   in Loop: Header=BB26_11 Depth=1
	ldrh	w8, [x8, #2]
	ldr	x8, [x26, x8, lsl #3]
	b	.LBB26_10
.LBB26_16:                              // %B29
                                        //   in Loop: Header=BB26_11 Depth=1
	ldr	w8, [x23, #72]
	mov	x0, x24
	mov	w2, #48                         // =0x30
	str	x17, [sp, #88]                  // 8-byte Folded Spill
	mov	w20, w13
	lsl	x1, x8, #3
	str	w9, [sp, #100]                  // 4-byte Folded Spill
	stp	x16, x15, [sp, #104]            // 16-byte Folded Spill
	str	x14, [x23, #48]
	bl	prim_try_malloc_gc
	ldp	x15, x14, [sp, #112]            // 16-byte Folded Reload
	cbz	x0, .LBB26_38
// %bb.17:                              // %B30
                                        //   in Loop: Header=BB26_11 Depth=1
	ldr	x16, [sp, #104]                 // 8-byte Folded Reload
	ldr	w9, [sp, #100]                  // 4-byte Folded Reload
	mov	w13, w20
	ldr	x17, [sp, #88]                  // 8-byte Folded Reload
	mov	x20, x0
	str	x0, [x23, #64]
.LBB26_18:                              // %B39
                                        //   in Loop: Header=BB26_11 Depth=1
	ldr	w8, [x23, #44]
	str	x20, [sp, #48]                  // 8-byte Folded Spill
	mov	w20, w13
	mov	w1, #16                         // =0x10
	str	x17, [sp, #88]                  // 8-byte Folded Spill
	mov	x0, x24
	str	w9, [sp, #100]                  // 4-byte Folded Spill
	stp	x16, x15, [sp, #104]            // 16-byte Folded Spill
	str	x14, [x23, #48]
	tbnz	w8, #4, .LBB26_22
// %bb.19:                              // %B32
                                        //   in Loop: Header=BB26_11 Depth=1
	mov	w2, #16                         // =0x10
.LBB26_20:                              // %B32
                                        //   in Loop: Header=BB26_11 Depth=1
	bl	prim_try_malloc_gc
	ldp	x15, x14, [sp, #112]            // 16-byte Folded Reload
	mov	w13, w20
	ldp	x11, x10, [sp, #56]             // 16-byte Folded Reload
	ldr	w12, [sp, #44]                  // 4-byte Folded Reload
	ldr	x20, [sp, #48]                  // 8-byte Folded Reload
	cbz	x0, .LBB26_38
// %bb.21:                              //   in Loop: Header=BB26_11 Depth=1
	ldr	x9, [sp, #104]                  // 8-byte Folded Reload
	ldr	x16, [sp, #88]                  // 8-byte Folded Reload
	mov	x8, x0
	add	x9, x16, x9, lsl #3
	str	x9, [x8]
	mov	w9, #18                         // =0x12
	str	x9, [x8, #8]
	ldr	w9, [sp, #100]                  // 4-byte Folded Reload
	str	x8, [x20, w9, uxtw #3]
	b	.LBB26_10
.LBB26_22:                              // %B36
                                        //   in Loop: Header=BB26_11 Depth=1
	mov	w2, #57                         // =0x39
	b	.LBB26_20
.LBB26_23:                              // %B87
	ldr	x8, [x9, #8]
	ldr	w8, [x8]
	asr	w8, w8, #30
	str	x9, [sp, #24]                   // 8-byte Folded Spill
	cmp	w8, #1
	b.eq	.LBB26_7
	b	.LBB26_38
.LBB26_24:
	str	xzr, [sp, #8]                   // 8-byte Folded Spill
.LBB26_25:                              // %B79
	ldr	w8, [sp, #76]                   // 4-byte Folded Reload
	tbnz	w8, #0, .LBB26_32
// %bb.26:                              // %B67
	mov	x0, x24
	mov	w1, #88                         // =0x58
	mov	w2, #2                          // =0x2
	str	x14, [x23, #48]
	bl	prim_try_malloc_gc
	ldr	x14, [sp, #120]                 // 8-byte Folded Reload
	ldr	x11, [sp, #16]                  // 8-byte Folded Reload
	cbz	x0, .LBB26_38
// %bb.27:                              // %B70
	ldr	w9, [x11]
	mov	w10, #1                         // =0x1
	mov	x19, x0
	mov	x20, xzr
	mov	x8, x0
	add	w9, w9, #1
	str	w9, [x11]
	mov	w9, #13                         // =0xd
	str	w10, [x0]
	strb	w10, [x0, #5]
	add	x10, x0, #8
	strh	w9, [x0, #6]
	mov	x9, xzr
	stlr	x11, [x10]
	ldrb	w10, [x24, #376]
	cbnz	w10, .LBB26_35
.LBB26_28:                              // %B58
	ldr	x11, [sp, #80]                  // 8-byte Folded Reload
	ldr	x12, [sp, #8]                   // 8-byte Folded Reload
	add	x10, x8, #56
	str	x10, [x8, #16]
	ldr	x13, [sp, #24]                  // 8-byte Folded Reload
	stp	x11, x12, [x8, #32]
	mov	x12, #2                         // =0x2
	ldrh	w11, [x11, #44]
	movk	x12, #1, lsl #48
	orr	x12, x13, x12
	orr	x11, x11, #0xfffe000000000000
	stp	x11, x12, [x8, #56]
	ldr	w11, [sp, #76]                  // 4-byte Folded Reload
	tbnz	w11, #0, .LBB26_36
.LBB26_29:                              // %B61
	ldr	x19, [sp, #32]                  // 8-byte Folded Reload
.LBB26_30:                              // %B6
	str	x8, [x14], #8
	ldurb	w8, [x19, #-1]
	cmp	w8, #189
	b.ne	.LBB26_37
// %bb.31:                              // %B7
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	mov	x20, x14
	add	sp, sp, #128
	br	x1
.LBB26_32:                              // %B52
	ldr	x20, [x24, #424]
	cbz	x20, .LBB26_38
// %bb.33:                              // %B55
	mov	x0, x24
	mov	w1, #88                         // =0x58
	mov	w2, #2                          // =0x2
	str	x14, [x23, #48]
	bl	prim_try_malloc_gc
	ldr	x11, [sp, #16]                  // 8-byte Folded Reload
	ldr	x14, [sp, #120]                 // 8-byte Folded Reload
	cbz	x0, .LBB26_38
// %bb.34:                              // %B63
	ldr	w9, [x11]
	mov	w10, #1                         // =0x1
	mov	x19, x0
	mov	x8, x0
	add	w9, w9, #1
	str	w9, [x11]
	mov	w9, #17                         // =0x11
	str	w10, [x0]
	mov	w10, #13                        // =0xd
	strb	w9, [x0, #5]
	add	x9, x0, #8
	strh	w10, [x0, #6]
	stlr	x11, [x9]
	mov	x9, x20
	ldrb	w10, [x24, #376]
	cbz	w10, .LBB26_28
.LBB26_35:                              // %B58.sink.split
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x11, x8
	bl	prim_WriteBarrierNoStore
	ldr	x14, [sp, #120]                 // 8-byte Folded Reload
	mov	x8, x19
	mov	x9, x20
	b	.LBB26_28
.LBB26_36:                              // %B60
	str	x9, [x10, #16]
	b	.LBB26_29
.LBB26_37:                              // %B8
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	mov	x20, x14
	add	sp, sp, #128
	br	x1
.LBB26_38:                              // %B1
	ldr	x1, [sp, #80]                   // 8-byte Folded Reload
	mov	x0, x24
	mov	x2, x26
	mov	x3, x23
	str	x14, [x23, #48]
	bl	js_closure_gc_slowpath
	ldr	x14, [sp, #120]                 // 8-byte Folded Reload
	ldr	x19, [sp, #32]                  // 8-byte Folded Reload
	cmp	x0, #130
	mov	x8, x0
	b.ne	.LBB26_30
// %bb.39:                              // %B2
	mov	x20, x14
	add	sp, sp, #128
	b	.Lexception_asm_h
.Lfunc_end26:
	.size	.LFastFclosure_asm_h, .Lfunc_end26-.LFastFclosure_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function FastCallConstructor_asm_h
	.type	.LFastCallConstructor_asm_h,@function
.LFastCallConstructor_asm_h:            // @FastCallConstructor_asm_h
// %bb.0:                               // %B9
	sub	sp, sp, #16
	mov	w8, w0
	mov	x0, x24
	str	x20, [sp, #8]                   // 8-byte Folded Spill
	str	w8, [sp, #4]                    // 4-byte Folded Spill
	sub	x8, x20, w8, uxtw #3
	str	x20, [x23, #48]
	mov	x1, x8
	mov	x20, x8
	bl	js_create_ordinary_constructor_this_GC
	cmp	x0, #130
	b.eq	.LBB27_5
// %bb.1:                               // %B6
	ldr	x9, [sp, #8]                    // 8-byte Folded Reload
	stur	x0, [x20, #-8]
	add	x19, x19, #2
	ldur	x8, [x20, #-16]
	mov	x21, x0
	str	x19, [x23, #32]
	str	x9, [x23, #48]
	ldr	w9, [sp, #4]                    // 4-byte Folded Reload
	mov	x22, x8
	mov	x27, x8
	mov	w0, w9
	bl	.Lcommon_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #96]
	b.eq	.LBB27_6
// %bb.2:                               // %B1
	mov	x9, #2                          // =0x2
	ldurh	w8, [x19, #-2]
	movk	x9, #65535, lsl #48
	tst	x0, x9
	b.eq	.LBB27_7
// %bb.3:                               // %B5
	sub	x9, x20, x8, lsl #3
	ldur	x9, [x9, #-8]
.LBB27_4:                               // %B3
	sub	x8, x20, x8, lsl #3
	stur	x9, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19], #1
	ldr	x1, [x25, x9, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB27_5:                               // %B10
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
.LBB27_6:                               // %B7
	add	sp, sp, #16
	b	.Lexception_asm_h
.LBB27_7:
	mov	x9, x0
	b	.LBB27_4
.Lfunc_end27:
	.size	.LFastCallConstructor_asm_h, .Lfunc_end27-.LFastCallConstructor_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function FastCallDerivedConstructor_asm_h
	.type	.LFastCallDerivedConstructor_asm_h,@function
.LFastCallDerivedConstructor_asm_h:     // @FastCallDerivedConstructor_asm_h
// %bb.0:                               // %B2
	mov	w9, w0
	add	x19, x19, #2
	mov	w21, #18                        // =0x12
	sub	x8, x20, w9, uxtw #3
	mov	w0, w9
	ldur	x10, [x8, #-16]
	str	x20, [x23, #48]
	mov	x20, x8
	str	x19, [x23, #32]
	mov	x22, x10
	mov	x27, x10
	bl	.Lcommon_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #96]
	b.eq	.LBB28_2
// %bb.1:                               // %B4
	ldurh	w8, [x19, #-2]
	sub	x8, x20, x8, lsl #3
	stur	x0, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19], #1
	ldr	x1, [x25, x9, lsl #3]
	br	x1
.LBB28_2:                               // %B3
	b	.Lexception_asm_h
.Lfunc_end28:
	.size	.LFastCallDerivedConstructor_asm_h, .Lfunc_end28-.LFastCallDerivedConstructor_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function invalid_0_asm_h
	.type	.Linvalid_0_asm_h,@function
.Linvalid_0_asm_h:                      // @invalid_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #8]
	adrp	x1, .L__unnamed_2
	add	x1, x1, :lo12:.L__unnamed_2
	mov	x0, x24
	mov	w3, wzr
	ldr	x8, [x8, #32]
	ldr	w8, [x8, #8]
	str	x20, [x23, #48]
	mvn	w8, w8
	add	w2, w8, w19
	bl	LEPUS_ThrowInternalError
	b	.Lexception_asm_h
.Lfunc_end29:
	.size	.Linvalid_0_asm_h, .Lfunc_end29-.Linvalid_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i32_0_asm_h
	.type	.Lpush_i32_0_asm_h,@function
.Lpush_i32_0_asm_h:                     // @push_i32_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #4]
	ldr	w9, [x19], #5
	add	w8, w8, #247
	orr	x22, x9, #0xfffe000000000000
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end30:
	.size	.Lpush_i32_0_asm_h, .Lfunc_end30-.Lpush_i32_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_const_0_asm_h
	.type	.Lpush_const_0_asm_h,@function
.Lpush_const_0_asm_h:                   // @push_const_0_asm_h
// %bb.0:                               // %B0
	ldrb	w9, [x19, #4]
	ldr	x8, [x23, #104]
	ldrsw	x10, [x19]
	add	x19, x19, #5
	add	w9, w9, #247
	ldr	x22, [x8, x10, lsl #3]
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end31:
	.size	.Lpush_const_0_asm_h, .Lfunc_end31-.Lpush_const_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function fclosure_0_asm_h
	.type	.Lfclosure_0_asm_h,@function
.Lfclosure_0_asm_h:                     // @fclosure_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #104]
	ldrsw	x9, [x19]
	ldr	x0, [x8, x9, lsl #3]
	b	.LFastFclosure_asm_h
.Lfunc_end32:
	.size	.Lfclosure_0_asm_h, .Lfunc_end32-.Lfclosure_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_atom_value_0_asm_h
	.type	.Lpush_atom_value_0_asm_h,@function
.Lpush_atom_value_0_asm_h:              // @push_atom_value_0_asm_h
// %bb.0:                               // %B13
	ldr	w1, [x19]
	tbnz	w1, #31, .LBB33_5
// %bb.1:                               // %B1
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, sxtw #3]
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, .LBB33_4
// %bb.2:                               // %B9
	ldr	w9, [x8, #8]
	asr	w9, w9, #30
	cmp	w9, #1
	b.ne	.LBB33_5
.LBB33_3:                               // %B7
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	mov	x9, #2                          // =0x2
	movk	x9, #1, lsl #48
	orr	x22, x8, x9
	br	x1
.LBB33_4:                               // %B2
	ldr	x9, [x8, #8]
	ldr	w9, [x9]
	asr	w9, w9, #30
	cmp	w9, #1
	b.eq	.LBB33_3
.LBB33_5:                               // %B10
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB33_7
// %bb.6:                               // %B12
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB33_7:                               // %B11
	b	.Lexception_asm_h
.Lfunc_end33:
	.size	.Lpush_atom_value_0_asm_h, .Lfunc_end33-.Lpush_atom_value_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function private_symbol_0_asm_h
	.type	.Lprivate_symbol_0_asm_h,@function
.Lprivate_symbol_0_asm_h:               // @private_symbol_0_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, #4                          // =0x4
	str	x20, [x23, #48]
	bl	JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	.LBB34_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB34_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end34:
	.size	.Lprivate_symbol_0_asm_h, .Lfunc_end34-.Lprivate_symbol_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function undefined_0_asm_h
	.type	.Lundefined_0_asm_h,@function
.Lundefined_0_asm_h:                    // @undefined_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w22, #18                        // =0x12
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end35:
	.size	.Lundefined_0_asm_h, .Lfunc_end35-.Lundefined_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function null_0_asm_h
	.type	.Lnull_0_asm_h,@function
.Lnull_0_asm_h:                         // @null_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w22, #2                         // =0x2
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end36:
	.size	.Lnull_0_asm_h, .Lfunc_end36-.Lnull_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_this_0_asm_h
	.type	.Lpush_this_0_asm_h,@function
.Lpush_this_0_asm_h:                    // @push_this_0_asm_h
// %bb.0:                               // %B12
	ldr	w8, [x23, #44]
	ldr	x1, [x23, #80]
	tbnz	w8, #0, .LBB37_2
// %bb.1:                               // %B12
	ldr	x8, [x23, #80]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, .LBB37_3
.LBB37_2:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x1
	add	w8, w8, #247
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.LBB37_3:                               // %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	.LBB37_5
// %bb.4:                               // %B7
	ldrb	w8, [x19], #1
	ldr	x22, [x24, #208]
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB37_5:                               // %B9
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB37_7
// %bb.6:                               // %B11
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB37_7:                               // %B10
	b	.Lexception_asm_h
.Lfunc_end37:
	.size	.Lpush_this_0_asm_h, .Lfunc_end37-.Lpush_this_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_false_0_asm_h
	.type	.Lpush_false_0_asm_h,@function
.Lpush_false_0_asm_h:                   // @push_false_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end38:
	.size	.Lpush_false_0_asm_h, .Lfunc_end38-.Lpush_false_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_true_0_asm_h
	.type	.Lpush_true_0_asm_h,@function
.Lpush_true_0_asm_h:                    // @push_true_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end39:
	.size	.Lpush_true_0_asm_h, .Lfunc_end39-.Lpush_true_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function object_0_asm_h
	.type	.Lobject_0_asm_h,@function
.Lobject_0_asm_h:                       // @object_0_asm_h
// %bb.0:                               // %B16
	ldrb	w8, [x24, #355]
	stp	x19, x20, [sp, #-16]!           // 16-byte Folded Spill
	cbnz	w8, .LBB40_5
// %bb.1:                               // %B1
	ldr	x19, [x24, #392]
	cbz	x19, .LBB40_5
// %bb.2:                               // %B5
	mov	x0, x24
	mov	w1, #64                         // =0x40
	mov	w2, #2                          // =0x2
	str	x20, [x23, #48]
	bl	prim_try_malloc_gc
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	mov	x10, x0
	cbz	x10, .LBB40_5
// %bb.3:                               // %B7
	ldr	w8, [x19]
	mov	w9, #1                          // =0x1
	add	w8, w8, #1
	str	w8, [x19]
	add	x8, x10, #8
	str	w9, [x10]
	strb	w9, [x10, #5]
	strh	w9, [x10, #6]
	stlr	x19, [x8]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB40_7
.LBB40_4:                               // %B9
	add	x8, x10, #32
	ldr	x19, [sp]                       // 8-byte Folded Reload
	mov	x22, x10
	str	x8, [x10, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
.LBB40_5:                               // %B13
	mov	x0, x24
	str	x20, [x23, #48]
	bl	PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	.LBB40_8
// %bb.6:                               // %B15
	ldp	x19, x20, [sp]                  // 16-byte Folded Reload
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
.LBB40_7:                               // %B11
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x19, x8
	mov	x19, x10
	bl	prim_WriteBarrierNoStore
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	mov	x10, x19
	b	.LBB40_4
.LBB40_8:                               // %B14
	ldp	x19, x20, [sp], #16             // 16-byte Folded Reload
	b	.Lexception_asm_h
.Lfunc_end40:
	.size	.Lobject_0_asm_h, .Lfunc_end40-.Lobject_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function special_object_0_asm_h
	.type	.Lspecial_object_0_asm_h,@function
.Lspecial_object_0_asm_h:               // @special_object_0_asm_h
// %bb.0:                               // %B12
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	.LBB41_5
// %bb.1:                               // %B12
	cbz	w8, .LBB41_8
// %bb.2:                               // %B12
	cmp	w8, #1
	b.ne	.LBB41_10
// %bb.3:                               // %B2
	ldr	x8, [x23, #8]
	ldr	w1, [x23, #112]
	mov	x0, x24
	mov	x2, x28
	mov	x3, x23
	ldr	x8, [x8, #32]
	ldrh	w8, [x8, #40]
	str	x20, [x23, #48]
	cmp	w8, w1
	csel	w4, w8, w1, lt
	bl	js_build_mapped_arguments_gc
	cmp	x0, #130
	b.eq	.LBB41_12
.LBB41_4:
	mov	x8, x0
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB41_5:                               // %B12
	cmp	w8, #3
	b.eq	.LBB41_9
// %bb.6:                               // %B12
	cmp	w8, #4
	b.ne	.LBB41_11
// %bb.7:                               // %B6
	ldr	x8, [x23, #8]
	mov	w9, #18                         // =0x12
	ldr	x8, [x8, #48]
	cmp	x8, #0
	csel	x8, x9, x8, eq
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB41_8:                               // %B13
	b	.LFastBuildArguments_asm_h
.LBB41_9:                               // %B16
	ldr	x8, [x23, #88]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB41_10:                              // %B15
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB41_11:                              // %B9
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x23, #48]
	bl	JS_NewObjectProto_GC
	cmp	x0, #130
	b.ne	.LBB41_4
.LBB41_12:                              // %B10
	b	.Lexception_asm_h
.Lfunc_end41:
	.size	.Lspecial_object_0_asm_h, .Lfunc_end41-.Lspecial_object_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rest_0_asm_h
	.type	.Lrest_0_asm_h,@function
.Lrest_0_asm_h:                         // @rest_0_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x23, #112]
	ldrh	w1, [x19]
	mov	x0, x24
	mov	x3, x28
	str	x20, [x23, #48]
	bl	js_build_rest_gc
	cmp	x0, #130
	b.eq	.LBB42_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB42_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end42:
	.size	.Lrest_0_asm_h, .Lfunc_end42-.Lrest_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function drop_0_asm_h
	.type	.Ldrop_0_asm_h,@function
.Ldrop_0_asm_h:                         // @drop_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end43:
	.size	.Ldrop_0_asm_h, .Lfunc_end43-.Ldrop_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nip_0_asm_h
	.type	.Lnip_0_asm_h,@function
.Lnip_0_asm_h:                          // @nip_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldur	x22, [x20, #-8]
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x8, x20, #16
	mov	x20, x8
	br	x1
.Lfunc_end44:
	.size	.Lnip_0_asm_h, .Lfunc_end44-.Lnip_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nip1_0_asm_h
	.type	.Lnip1_0_asm_h,@function
.Lnip1_0_asm_h:                         // @nip1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldp	x22, x21, [x20, #-16]
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	sub	x8, x20, #24
	mov	x20, x8
	br	x1
.Lfunc_end45:
	.size	.Lnip1_0_asm_h, .Lfunc_end45-.Lnip1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup_0_asm_h
	.type	.Ldup_0_asm_h,@function
.Ldup_0_asm_h:                          // @dup_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x20, #-8]!
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x22
	br	x1
.Lfunc_end46:
	.size	.Ldup_0_asm_h, .Lfunc_end46-.Ldup_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup1_0_asm_h
	.type	.Ldup1_0_asm_h,@function
.Ldup1_0_asm_h:                         // @dup1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x20, #-8]!
	ldur	x22, [x20, #-8]
	add	w8, w8, #494
	ldr	x2, [x25, w8, uxtw #3]
	mov	x1, x22
	mov	x22, x21
	mov	x22, x1
	br	x2
.Lfunc_end47:
	.size	.Ldup1_0_asm_h, .Lfunc_end47-.Ldup1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup2_0_asm_h
	.type	.Ldup2_0_asm_h,@function
.Ldup2_0_asm_h:                         // @dup2_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldp	x22, x21, [x20, #-16]
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end48:
	.size	.Ldup2_0_asm_h, .Lfunc_end48-.Ldup2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup3_0_asm_h
	.type	.Ldup3_0_asm_h,@function
.Ldup3_0_asm_h:                         // @dup3_0_asm_h
// %bb.0:                               // %B0
	ldp	x8, x22, [x20, #-24]
	ldur	x21, [x20, #-8]
	str	x8, [x20], #8
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end49:
	.size	.Ldup3_0_asm_h, .Lfunc_end49-.Ldup3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function insert2_0_asm_h
	.type	.Linsert2_0_asm_h,@function
.Linsert2_0_asm_h:                      // @insert2_0_asm_h
// %bb.0:                               // %B0
	ldr	x21, [x20, #-8]!
	ldur	x22, [x20, #-8]
	stur	x21, [x20, #-8]
	mov	x1, x22
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x22, x1
	add	w8, w8, #494
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.Lfunc_end50:
	.size	.Linsert2_0_asm_h, .Lfunc_end50-.Linsert2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function insert3_0_asm_h
	.type	.Linsert3_0_asm_h,@function
.Linsert3_0_asm_h:                      // @insert3_0_asm_h
// %bb.0:                               // %B0
	ldr	x21, [x20, #-8]!
	ldp	x8, x22, [x20, #-16]
	stp	x21, x8, [x20, #-16]
	mov	x2, x22
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x22, x2
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end51:
	.size	.Linsert3_0_asm_h, .Lfunc_end51-.Linsert3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function insert4_0_asm_h
	.type	.Linsert4_0_asm_h,@function
.Linsert4_0_asm_h:                      // @insert4_0_asm_h
// %bb.0:                               // %B0
	ldr	x21, [x20, #-8]!
	ldur	x22, [x20, #-8]
	ldp	x9, x8, [x20, #-24]
	stur	x21, [x20, #-24]
	mov	x1, x22
	mov	x22, x21
	mov	x22, x1
	stp	x9, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.Lfunc_end52:
	.size	.Linsert4_0_asm_h, .Lfunc_end52-.Linsert4_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function perm3_0_asm_h
	.type	.Lperm3_0_asm_h,@function
.Lperm3_0_asm_h:                        // @perm3_0_asm_h
// %bb.0:                               // %B0
	ldp	x22, x21, [x20, #-16]!
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end53:
	.size	.Lperm3_0_asm_h, .Lfunc_end53-.Lperm3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function perm4_0_asm_h
	.type	.Lperm4_0_asm_h,@function
.Lperm4_0_asm_h:                        // @perm4_0_asm_h
// %bb.0:                               // %B0
	ldp	x22, x21, [x20, #-16]!
	mov	x9, x22
	ldp	x8, x22, [x20, #-16]
	stp	x9, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end54:
	.size	.Lperm4_0_asm_h, .Lfunc_end54-.Lperm4_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function perm5_0_asm_h
	.type	.Lperm5_0_asm_h,@function
.Lperm5_0_asm_h:                        // @perm5_0_asm_h
// %bb.0:                               // %B0
	ldp	x22, x21, [x20, #-16]!
	ldp	x9, x8, [x20, #-24]
	mov	x10, x22
	ldur	x22, [x20, #-8]
	stur	x10, [x20, #-24]
	stp	x9, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end55:
	.size	.Lperm5_0_asm_h, .Lfunc_end55-.Lperm5_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function swap_0_asm_h
	.type	.Lswap_0_asm_h,@function
.Lswap_0_asm_h:                         // @swap_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldp	x22, x21, [x20, #-16]!
	add	w8, w8, #494
	ldr	x2, [x25, w8, uxtw #3]
	mov	x1, x22
	mov	x22, x21
	mov	x21, x1
	br	x2
.Lfunc_end56:
	.size	.Lswap_0_asm_h, .Lfunc_end56-.Lswap_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function swap2_0_asm_h
	.type	.Lswap2_0_asm_h,@function
.Lswap2_0_asm_h:                        // @swap2_0_asm_h
// %bb.0:                               // %B0
	ldp	x22, x21, [x20, #-16]!
	ldp	x8, x9, [x20, #-16]
	stp	x22, x21, [x20, #-16]
	ldrb	w10, [x19], #1
	mov	x22, x8
	mov	x21, x9
	add	w10, w10, #494
	ldr	x1, [x25, w10, uxtw #3]
	br	x1
.Lfunc_end57:
	.size	.Lswap2_0_asm_h, .Lfunc_end57-.Lswap2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rot3l_0_asm_h
	.type	.Lrot3l_0_asm_h,@function
.Lrot3l_0_asm_h:                        // @rot3l_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-16]!
	ldur	x8, [x20, #-8]
	ldr	x21, [x20, #8]
	stur	x22, [x20, #-8]
	ldrb	w9, [x19], #1
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end58:
	.size	.Lrot3l_0_asm_h, .Lfunc_end58-.Lrot3l_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rot3r_0_asm_h
	.type	.Lrot3r_0_asm_h,@function
.Lrot3r_0_asm_h:                        // @rot3r_0_asm_h
// %bb.0:                               // %B0
	ldp	x22, x21, [x20, #-16]!
	mov	x8, x21
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end59:
	.size	.Lrot3r_0_asm_h, .Lfunc_end59-.Lrot3r_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rot4l_0_asm_h
	.type	.Lrot4l_0_asm_h,@function
.Lrot4l_0_asm_h:                        // @rot4l_0_asm_h
// %bb.0:                               // %B0
	ldp	x22, x21, [x20, #-16]!
	ldp	x9, x8, [x20, #-16]
	stp	x8, x22, [x20, #-16]
	mov	x22, x21
	mov	x21, x9
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end60:
	.size	.Lrot4l_0_asm_h, .Lfunc_end60-.Lrot4l_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rot5l_0_asm_h
	.type	.Lrot5l_0_asm_h,@function
.Lrot5l_0_asm_h:                        // @rot5l_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-16]!
	ldur	x10, [x20, #-24]
	ldp	x8, x9, [x20, #-16]
	ldr	x21, [x20, #8]
	stur	x22, [x20, #-8]
	mov	x22, x21
	mov	x21, x10
	stp	x8, x9, [x20, #-24]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end61:
	.size	.Lrot5l_0_asm_h, .Lfunc_end61-.Lrot5l_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_constructor_0_asm_h
	.type	.Lcall_constructor_0_asm_h,@function
.Lcall_constructor_0_asm_h:             // @call_constructor_0_asm_h
// %bb.0:                               // %B18
	ldrh	w3, [x19]
	sub	x4, x20, w3, uxtw #3
	ldp	x1, x2, [x4, #-16]
	and	x8, x1, #0xfffffffffffffffe
	cmp	x1, x2
	and	x8, x8, #0xffff000000000003
	ccmp	x8, #0, #0, eq
	b.ne	.LBB62_5
// %bb.1:                               // %B14
	ldrh	w8, [x1, #6]
	cmp	w8, #13
	b.ne	.LBB62_5
// %bb.2:                               // %B7
	ldrb	w8, [x1, #5]
	tbz	w8, #4, .LBB62_5
// %bb.3:                               // %B9
	ldr	x8, [x1, #32]
	mov	x0, x3
	ldrb	w8, [x8, #6]
	tbnz	w8, #2, .LBB62_7
// %bb.4:                               // %B10
	b	.LFastCallConstructor_asm_h
.LBB62_5:                               // %B2
	add	x8, x19, #2
	mov	x0, x24
	mov	w5, wzr
	str	x8, [x23, #32]
                                        // kill: def $w3 killed $w3 killed $x3
	str	x20, [x23, #48]
	bl	JS_CallConstructorInternal_GC
	cmp	x0, #130
	b.eq	.LBB62_8
// %bb.6:                               // %B4
	ldrh	w8, [x19]
	sub	x8, x20, x8, lsl #3
	stur	x0, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x9, lsl #3]
	br	x1
.LBB62_7:                               // %B11
	b	.LFastCallDerivedConstructor_asm_h
.LBB62_8:                               // %B3
	b	.Lexception_asm_h
.Lfunc_end62:
	.size	.Lcall_constructor_0_asm_h, .Lfunc_end62-.Lcall_constructor_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_0_asm_h
	.type	.Lcall_0_asm_h,@function
.Lcall_0_asm_h:                         // @call_0_asm_h
// %bb.0:                               // %B2
	ldrh	w9, [x19], #2
	str	x19, [x23, #32]
	str	x20, [x23, #48]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	sub	x8, x20, x9, lsl #3
	mov	x0, x9
	ldur	x22, [x8, #-8]
	mov	x20, x8
	bl	.Lcommon_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #96]
	b.eq	.LBB63_2
// %bb.1:                               // %B4
	ldurh	w8, [x19, #-2]
	add	w8, w8, #1
	sub	x20, x20, w8, uxtw #3
	str	x0, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB63_2:                               // %B3
	b	.Lexception_asm_h
.Lfunc_end63:
	.size	.Lcall_0_asm_h, .Lfunc_end63-.Lcall_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function tail_call_0_asm_h
	.type	.Ltail_call_0_asm_h,@function
.Ltail_call_0_asm_h:                    // @tail_call_0_asm_h
// %bb.0:                               // %B2
	ldrh	w9, [x19], #2
	str	x19, [x23, #32]
	str	x20, [x23, #48]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	sub	x8, x20, x9, lsl #3
	mov	x0, x9
	ldur	x22, [x8, #-8]
	mov	x20, x8
	bl	.Lcommon_call_asm_h
	cmp	x0, #130
	b.eq	.LBB64_2
// %bb.1:                               // %B4
	ldr	x26, [x23, #96]
	mov	x19, xzr
	mov	x20, xzr
	b	.Lcommon_return_asm_h
.LBB64_2:                               // %B3
	mov	x19, xzr
	mov	x20, xzr
	b	.Lexception_asm_h
.Lfunc_end64:
	.size	.Ltail_call_0_asm_h, .Lfunc_end64-.Ltail_call_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_method_0_asm_h
	.type	.Lcall_method_0_asm_h,@function
.Lcall_method_0_asm_h:                  // @call_method_0_asm_h
// %bb.0:                               // %B2
	ldrh	w9, [x19], #2
	str	x19, [x23, #32]
	str	x20, [x23, #48]
	mov	w27, #18                        // =0x12
	sub	x8, x20, x9, lsl #3
	mov	x0, x9
	ldp	x21, x22, [x8, #-16]
	mov	x20, x8
	bl	.Lcommon_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #96]
	b.eq	.LBB65_2
// %bb.1:                               // %B4
	ldurh	w8, [x19, #-2]
	add	w8, w8, #2
	sub	x20, x20, w8, uxtw #3
	str	x0, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB65_2:                               // %B3
	b	.Lexception_asm_h
.Lfunc_end65:
	.size	.Lcall_method_0_asm_h, .Lfunc_end65-.Lcall_method_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function tail_call_method_0_asm_h
	.type	.Ltail_call_method_0_asm_h,@function
.Ltail_call_method_0_asm_h:             // @tail_call_method_0_asm_h
// %bb.0:                               // %B2
	ldrh	w9, [x19], #2
	str	x19, [x23, #32]
	str	x20, [x23, #48]
	mov	w27, #18                        // =0x12
	sub	x8, x20, x9, lsl #3
	mov	x0, x9
	ldp	x21, x22, [x8, #-16]
	mov	x20, x8
	bl	.Lcommon_call_asm_h
	cmp	x0, #130
	b.eq	.LBB66_2
// %bb.1:                               // %B4
	ldr	x26, [x23, #96]
	mov	x19, xzr
	mov	x20, xzr
	b	.Lcommon_return_asm_h
.LBB66_2:                               // %B3
	mov	x19, xzr
	mov	x20, xzr
	b	.Lexception_asm_h
.Lfunc_end66:
	.size	.Ltail_call_method_0_asm_h, .Lfunc_end66-.Ltail_call_method_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function array_from_0_asm_h
	.type	.Larray_from_0_asm_h,@function
.Larray_from_0_asm_h:                   // @array_from_0_asm_h
// %bb.0:                               // %B32
	sub	sp, sp, #64
	ldrh	w1, [x19]
	ldrb	w8, [x24, #355]
	str	x19, [sp, #40]                  // 8-byte Folded Spill
	str	x20, [sp, #56]                  // 8-byte Folded Spill
	sub	x9, x20, w1, uxtw #3
	str	x9, [sp, #24]                   // 8-byte Folded Spill
	cbnz	w8, .LBB67_13
// %bb.1:                               // %B1
	ldr	x8, [x24, #40]
	str	x8, [sp, #32]                   // 8-byte Folded Spill
	cbz	x8, .LBB67_13
// %bb.2:                               // %B5
	str	x1, [sp, #48]                   // 8-byte Folded Spill
	cbz	w1, .LBB67_8
// %bb.3:                               // %B10
	ldp	x9, x8, [sp, #48]               // 16-byte Folded Reload
	mov	x0, x24
	mov	w2, #42                         // =0x2a
	lsl	x1, x9, #3
	str	x8, [x23, #48]
	bl	prim_try_malloc_gc
	ldr	x1, [sp, #48]                   // 8-byte Folded Reload
	cbz	x0, .LBB67_13
// %bb.4:                               // %B13.preheader
	add	x10, x0, x1, lsl #3
	ldr	x19, [sp, #24]                  // 8-byte Folded Reload
	mov	x20, x0
	str	x20, [sp, #16]                  // 8-byte Folded Spill
	cmp	x20, x10
	b.ge	.LBB67_9
.LBB67_5:                               // %B15
                                        // =>This Inner Loop Header: Depth=1
	ldr	x8, [x19]
	str	x8, [x20]
	ldrb	w9, [x24, #376]
	cbnz	w9, .LBB67_7
.LBB67_6:                               // %B17
                                        //   in Loop: Header=BB67_5 Depth=1
	add	x20, x20, #8
	add	x19, x19, #8
	cmp	x20, x10
	b.lt	.LBB67_5
	b	.LBB67_9
.LBB67_7:                               // %B18
                                        //   in Loop: Header=BB67_5 Depth=1
	mov	x0, x8
	mov	x1, x24
	str	x10, [sp, #8]                   // 8-byte Folded Spill
	bl	prim_WriteBarrierNoStore
	ldr	x10, [sp, #8]                   // 8-byte Folded Reload
	b	.LBB67_6
.LBB67_8:
	str	xzr, [sp, #16]                  // 8-byte Folded Spill
.LBB67_9:                               // %B21
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	mov	x0, x24
	mov	w1, #88                         // =0x58
	mov	w2, #2                          // =0x2
	mov	w20, #2                         // =0x2
	str	x8, [x23, #48]
	bl	prim_try_malloc_gc
	ldr	x1, [sp, #48]                   // 8-byte Folded Reload
	mov	x19, x0
	cbz	x19, .LBB67_13
// %bb.10:                              // %B23
	ldr	x9, [sp, #32]                   // 8-byte Folded Reload
	ldr	w8, [x9]
	add	w8, w8, #1
	str	w8, [x9]
	mov	w8, #1                          // =0x1
	str	w8, [x19]
	mov	w8, #13                         // =0xd
	strb	w8, [x19, #5]
	add	x8, x19, #8
	strh	w20, [x19, #6]
	stlr	x9, [x8]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB67_15
.LBB67_11:                              // %B25
	orr	x8, x1, #0xfffe000000000000
	mov	x9, x19
	str	x8, [x9, #56]!
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	str	x9, [x19, #16]
	str	x8, [x19, #40]
	str	w1, [x19, #32]
	str	w1, [x19, #48]
.LBB67_12:                              // %B26
	ldr	x9, [sp, #40]                   // 8-byte Folded Reload
	ldr	x10, [sp, #56]                  // 8-byte Folded Reload
	ldrh	w8, [x9]
	sub	x20, x10, x8, lsl #3
	str	x19, [x20], #8
	add	x19, x9, #3
	ldrb	w8, [x9, #2]
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #64
	br	x1
.LBB67_13:                              // %B29
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	ldr	x2, [sp, #24]                   // 8-byte Folded Reload
	mov	x0, x24
                                        // kill: def $w1 killed $w1 killed $x1
	str	x8, [x23, #48]
	bl	JS_NewArrayWithArgs_GC
	cmp	x0, #130
	mov	x19, x0
	b.ne	.LBB67_12
// %bb.14:                              // %B30
	ldr	x19, [sp, #40]                  // 8-byte Folded Reload
	ldr	x20, [sp, #56]                  // 8-byte Folded Reload
	add	sp, sp, #64
	b	.Lexception_asm_h
.LBB67_15:                              // %B27
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	prim_WriteBarrierNoStore
	ldr	x1, [sp, #48]                   // 8-byte Folded Reload
	b	.LBB67_11
.Lfunc_end67:
	.size	.Larray_from_0_asm_h, .Lfunc_end67-.Larray_from_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function apply_0_asm_h
	.type	.Lapply_0_asm_h,@function
.Lapply_0_asm_h:                        // @apply_0_asm_h
// %bb.0:                               // %B1
	sub	sp, sp, #16
	ldrh	w4, [x19]
	ldur	x1, [x20, #-24]
	sub	x3, x20, #16
	mov	x0, x24
	mov	w2, #2                          // =0x2
	str	x20, [x23, #48]
	str	x3, [sp, #8]                    // 8-byte Folded Spill
	bl	js_function_apply_gc
	cmp	x0, #130
	b.eq	.LBB68_2
// %bb.1:                               // %B3
	stur	x0, [x20, #-24]
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB68_2:                               // %B2
	add	sp, sp, #16
	b	.Lexception_asm_h
.Lfunc_end68:
	.size	.Lapply_0_asm_h, .Lfunc_end68-.Lapply_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_0_asm_h
	.type	.Lreturn_0_asm_h,@function
.Lreturn_0_asm_h:                       // @return_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	mov	x0, x22
	b	.Lcommon_return_asm_h
.Lfunc_end69:
	.size	.Lreturn_0_asm_h, .Lfunc_end69-.Lreturn_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_undef_0_asm_h
	.type	.Lreturn_undef_0_asm_h,@function
.Lreturn_undef_0_asm_h:                 // @return_undef_0_asm_h
// %bb.0:                               // %B0
	mov	w0, #18                         // =0x12
	b	.Lcommon_return_asm_h
.Lfunc_end70:
	.size	.Lreturn_undef_0_asm_h, .Lfunc_end70-.Lreturn_undef_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_ctor_return_0_asm_h
	.type	.Lcheck_ctor_return_0_asm_h,@function
.Lcheck_ctor_return_0_asm_h:            // @check_ctor_return_0_asm_h
// %bb.0:                               // %B5
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	.LBB71_3
// %bb.1:                               // %B2
	cmp	x22, #18
	b.eq	.LBB71_4
// %bb.2:                               // %B3
	adrp	x1, .L__unnamed_3
	add	x1, x1, :lo12:.L__unnamed_3
	mov	x0, x24
	str	x20, [x23, #48]
	bl	LEPUS_ThrowTypeError
	b	.Lexception_asm_h
.LBB71_3:                               // %B6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w21, #6                         // =0x6
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB71_4:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w21, #7                         // =0x7
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end71:
	.size	.Lcheck_ctor_return_0_asm_h, .Lfunc_end71-.Lcheck_ctor_return_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_ctor_0_asm_h
	.type	.Lcheck_ctor_0_asm_h,@function
.Lcheck_ctor_0_asm_h:                   // @check_ctor_0_asm_h
// %bb.0:                               // %B2
	ldr	x8, [x23, #88]
	cmp	x8, #18
	b.ne	.LBB72_2
// %bb.1:                               // %B3
	adrp	x1, .L__unnamed_4
	add	x1, x1, :lo12:.L__unnamed_4
	mov	x0, x24
	str	x20, [x23, #48]
	bl	LEPUS_ThrowTypeError
	b	.Lexception_asm_h
.LBB72_2:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end72:
	.size	.Lcheck_ctor_0_asm_h, .Lfunc_end72-.Lcheck_ctor_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_brand_0_asm_h
	.type	.Lcheck_brand_0_asm_h,@function
.Lcheck_brand_0_asm_h:                  // @check_brand_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	JS_CheckBrand_GC
	tbnz	w0, #31, .LBB73_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB73_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end73:
	.size	.Lcheck_brand_0_asm_h, .Lfunc_end73-.Lcheck_brand_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_brand_0_asm_h
	.type	.Ladd_brand_0_asm_h,@function
.Ladd_brand_0_asm_h:                    // @add_brand_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	JS_AddBrand_GC
	tbnz	w0, #31, .LBB74_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB74_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end74:
	.size	.Ladd_brand_0_asm_h, .Lfunc_end74-.Ladd_brand_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_async_0_asm_h
	.type	.Lreturn_async_0_asm_h,@function
.Lreturn_async_0_asm_h:                 // @return_async_0_asm_h
// %bb.0:                               // %B0
	str	x19, [x23, #32]
	mov	w0, #18                         // =0x12
	str	x20, [x23, #48]
	b	.Lcommon_return_direct_asm_h
.Lfunc_end75:
	.size	.Lreturn_async_0_asm_h, .Lfunc_end75-.Lreturn_async_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function throw_0_asm_h
	.type	.Lthrow_0_asm_h,@function
.Lthrow_0_asm_h:                        // @throw_0_asm_h
// %bb.0:                               // %B0
	ldr	x1, [x20, #-8]!
	mov	x0, x24
	str	x20, [x23, #48]
	bl	LEPUS_Throw
	b	.Lexception_asm_h
.Lfunc_end76:
	.size	.Lthrow_0_asm_h, .Lfunc_end76-.Lthrow_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function throw_var_0_asm_h
	.type	.Lthrow_var_0_asm_h,@function
.Lthrow_var_0_asm_h:                    // @throw_var_0_asm_h
// %bb.0:                               // %B3
	ldrb	w8, [x19, #4]
	ldr	w2, [x19]
	str	x20, [x23, #48]
	cmp	w8, #1
	b.le	.LBB77_5
// %bb.1:                               // %B3
	cmp	w8, #2
	b.eq	.LBB77_8
// %bb.2:                               // %B3
	cmp	w8, #3
	b.eq	.LBB77_9
// %bb.3:                               // %B3
	cmp	w8, #4
	b.ne	.LBB77_11
// %bb.4:                               // %B8
	adrp	x1, .L__unnamed_5
	add	x1, x1, :lo12:.L__unnamed_5
	mov	x0, x24
	bl	LEPUS_ThrowTypeError
	b	.Lexception_asm_h
.LBB77_5:                               // %B3
	cbz	w8, .LBB77_10
// %bb.6:                               // %B3
	cmp	w8, #1
	b.ne	.LBB77_11
// %bb.7:                               // %B5
	mov	x0, x24
	mov	w1, w2
	bl	JS_ThrowSyntaxErrorVarRedeclaration_GC
	b	.Lexception_asm_h
.LBB77_8:                               // %B6
	mov	x0, x24
	mov	w1, w2
	bl	JS_ThrowReferenceErrorUninitialized_GC
	b	.Lexception_asm_h
.LBB77_9:                               // %B7
	adrp	x1, .L__unnamed_6
	add	x1, x1, :lo12:.L__unnamed_6
	mov	x0, x24
	bl	LEPUS_ThrowReferenceError
	b	.Lexception_asm_h
.LBB77_10:                              // %B4
	mov	x0, x24
	mov	w1, #16384                      // =0x4000
	bl	JS_ThrowTypeErrorReadOnly
	b	.Lexception_asm_h
.LBB77_11:                              // %B9
	adrp	x1, .L__unnamed_7
	add	x1, x1, :lo12:.L__unnamed_7
	mov	x0, x24
	bl	LEPUS_ThrowInternalError
	b	.Lexception_asm_h
.Lfunc_end77:
	.size	.Lthrow_var_0_asm_h, .Lfunc_end77-.Lthrow_var_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function eval_0_asm_h
	.type	.Leval_0_asm_h,@function
.Leval_0_asm_h:                         // @eval_0_asm_h
// %bb.0:                               // %B1
	ldrh	w8, [x19]
	ldur	x2, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #48]
	sub	w1, w8, #1
	bl	prim_js_op_eval_gc
	cmp	x0, #130
	b.eq	.LBB78_2
// %bb.1:                               // %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB78_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end78:
	.size	.Leval_0_asm_h, .Lfunc_end78-.Leval_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function regexp_0_asm_h
	.type	.Lregexp_0_asm_h,@function
.Lregexp_0_asm_h:                       // @regexp_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w1, #18                         // =0x12
	str	x20, [x23, #48]
	mov	x2, x22
	mov	x3, x21
	bl	js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	.LBB79_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB79_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end79:
	.size	.Lregexp_0_asm_h, .Lfunc_end79-.Lregexp_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_super_ctor_0_asm_h
	.type	.Lget_super_ctor_0_asm_h,@function
.Lget_super_ctor_0_asm_h:               // @get_super_ctor_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	bl	primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	.LBB80_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB80_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end80:
	.size	.Lget_super_ctor_0_asm_h, .Lfunc_end80-.Lget_super_ctor_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_super_0_asm_h
	.type	.Lget_super_0_asm_h,@function
.Lget_super_0_asm_h:                    // @get_super_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	bl	JS_GetPrototype_GC
	cmp	x0, #130
	b.eq	.LBB81_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB81_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end81:
	.size	.Lget_super_0_asm_h, .Lfunc_end81-.Lget_super_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function import_0_asm_h
	.type	.Limport_0_asm_h,@function
.Limport_0_asm_h:                       // @import_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	bl	js_dynamic_import
	cmp	x0, #130
	b.eq	.LBB82_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB82_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end82:
	.size	.Limport_0_asm_h, .Lfunc_end82-.Limport_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_var_0_asm_h
	.type	.Lcheck_var_0_asm_h,@function
.Lcheck_var_0_asm_h:                    // @check_var_0_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_CheckGlobalVar_GC
	tbnz	w0, #31, .LBB83_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB83_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end83:
	.size	.Lcheck_var_0_asm_h, .Lfunc_end83-.Lcheck_var_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_undef_0_asm_h
	.type	.Lget_var_undef_0_asm_h,@function
.Lget_var_undef_0_asm_h:                // @get_var_undef_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x24, #216]
	ldr	w9, [x19]
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x10, x10, #64
	lsl	w12, w11, #2
	and	w11, w9, w11
	ldr	w11, [x10, w11, sxtw #2]
	add	w12, w12, #4
	add	x10, x10, x12
	cbz	w11, .LBB84_3
.LBB84_1:                               // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	.LBB84_9
// %bb.2:                               // %B15
                                        //   in Loop: Header=BB84_1 Depth=1
	and	w11, w12, #0x3ffffff
	cbnz	w11, .LBB84_1
.LBB84_3:                               // %B18
	ldr	x8, [x24, #208]
	mov	w10, #18                        // =0x12
.LBB84_4:                               // %B36
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB84_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w9, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, .LBB84_7
.LBB84_5:                               // %B25
                                        //   Parent Loop BB84_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w9
	b.eq	.LBB84_10
// %bb.6:                               // %B27
                                        //   in Loop: Header=BB84_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB84_5
.LBB84_7:                               // %B30
                                        //   in Loop: Header=BB84_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	.LBB84_15
// %bb.8:                               // %B33
                                        //   in Loop: Header=BB84_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB84_4
	b	.LBB84_13
.LBB84_9:                               // %B10
	lsr	w9, w12, #26
	b	.LBB84_11
.LBB84_10:                              // %B19
	lsr	w9, w13, #26
.LBB84_11:                              // %B19
	tst	w9, #0x30
	b.ne	.LBB84_15
// %bb.12:                              // %B14.sink.split
	ldr	x8, [x8, #16]
	sub	w9, w11, #1
	ldr	x10, [x8, w9, sxtw #3]
.LBB84_13:                              // %B14
	cmp	x10, #34
	b.eq	.LBB84_17
// %bb.14:                              // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x10
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB84_15:                              // %B7
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB84_18
// %bb.16:                              // %B9
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB84_17:                              // %B3
	b	.LThrowReferenceErrorUninitialized_asm_h
.LBB84_18:                              // %B8
	b	.Lexception_asm_h
.Lfunc_end84:
	.size	.Lget_var_undef_0_asm_h, .Lfunc_end84-.Lget_var_undef_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_0_asm_h
	.type	.Lget_var_0_asm_h,@function
.Lget_var_0_asm_h:                      // @get_var_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x24, #216]
	ldr	w9, [x19]
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w9, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB85_3
.LBB85_1:                               // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	.LBB85_9
// %bb.2:                               // %B15
                                        //   in Loop: Header=BB85_1 Depth=1
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB85_1
.LBB85_3:                               // %B18
	ldr	x8, [x24, #208]
.LBB85_4:                               // %B35
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB85_5 Depth 2
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w9, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB85_7
.LBB85_5:                               // %B24
                                        //   Parent Loop BB85_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	.LBB85_9
// %bb.6:                               // %B26
                                        //   in Loop: Header=BB85_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB85_5
.LBB85_7:                               // %B29
                                        //   in Loop: Header=BB85_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB85_12
// %bb.8:                               // %B32
                                        //   in Loop: Header=BB85_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB85_4
	b	.LBB85_12
.LBB85_9:                               // %B19
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	.LBB85_12
// %bb.10:                              // %B14
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	.LBB85_14
// %bb.11:                              // %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB85_12:                              // %B7
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x20, [x23, #48]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB85_15
// %bb.13:                              // %B9
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB85_14:                              // %B3
	b	.LThrowReferenceErrorUninitialized_asm_h
.LBB85_15:                              // %B8
	b	.Lexception_asm_h
.Lfunc_end85:
	.size	.Lget_var_0_asm_h, .Lfunc_end85-.Lget_var_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_0_asm_h
	.type	.Lput_var_0_asm_h,@function
.Lput_var_0_asm_h:                      // @put_var_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	mov	w3, wzr
	str	x20, [x23, #48]
	mov	x2, x22
	bl	JS_SetGlobalVar_GC
	tbnz	w0, #31, .LBB86_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB86_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end86:
	.size	.Lput_var_0_asm_h, .Lfunc_end86-.Lput_var_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_init_0_asm_h
	.type	.Lput_var_init_0_asm_h,@function
.Lput_var_init_0_asm_h:                 // @put_var_init_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x23, #48]
	mov	x2, x22
	bl	JS_SetGlobalVar_GC
	tbnz	w0, #31, .LBB87_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB87_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end87:
	.size	.Lput_var_init_0_asm_h, .Lfunc_end87-.Lput_var_init_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_strict_0_asm_h
	.type	.Lput_var_strict_0_asm_h,@function
.Lput_var_strict_0_asm_h:               // @put_var_strict_0_asm_h
// %bb.0:                               // %B5
	ldp	x22, x21, [x20, #-16]
	cmp	x22, #7
	b.ne	.LBB88_3
// %bb.1:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          // =0x2
	str	x20, [x23, #48]
	bl	JS_SetGlobalVar_GC
	tbnz	w0, #31, .LBB88_4
// %bb.2:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB88_3:                               // %B6
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB88_4:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end88:
	.size	.Lput_var_strict_0_asm_h, .Lfunc_end88-.Lput_var_strict_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_ref_value_0_asm_h
	.type	.Lget_ref_value_0_asm_h,@function
.Lget_ref_value_0_asm_h:                // @get_ref_value_0_asm_h
// %bb.0:                               // %B49
	ldp	x22, x21, [x20, #-16]
	cmp	x22, #18
	b.eq	.LBB89_7
// %bb.1:                               // %B1
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB89_5
// %bb.2:                               // %B39
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	.LBB89_5
// %bb.3:                               // %B3
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB89_5
// %bb.4:                               // %B3
	mov	x9, #2                          // =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	.LBB89_10
.LBB89_5:                               // %B43
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB89_9
// %bb.6:                               // %B45
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB89_7:                               // %B46
	mov	x0, x24
	mov	x1, x21
	str	x20, [x23, #48]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB89_9
// %bb.8:                               // %B48
	mov	w1, w0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB89_9:                               // %B47
	b	.Lexception_asm_h
.LBB89_10:                              // %B9
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, .LBB89_22
// %bb.11:                              // %B37
	ldr	w8, [x1, #8]
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	.LBB89_5
.LBB89_12:                              // %B11
	ldr	x0, [x24, #8]
	bl	prim_get_interned_non_index_atom
	cbz	w0, .LBB89_5
// %bb.13:                              // %B14.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB89_14:                              // %B14
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB89_15 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB89_17
.LBB89_15:                              // %B25
                                        //   Parent Loop BB89_14 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	.LBB89_19
// %bb.16:                              // %B30
                                        //   in Loop: Header=BB89_15 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB89_15
.LBB89_17:                              // %B16
                                        //   in Loop: Header=BB89_14 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB89_5
// %bb.18:                              // %B19
                                        //   in Loop: Header=BB89_14 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB89_14
	b	.LBB89_21
.LBB89_19:                              // %B27
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB89_5
// %bb.20:                              // %B28
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB89_21:                              // %B22
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB89_22:                              // %B10
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
	asr	w8, w8, #30
	cmp	w8, #1
	b.eq	.LBB89_12
	b	.LBB89_5
.Lfunc_end89:
	.size	.Lget_ref_value_0_asm_h, .Lfunc_end89-.Lget_ref_value_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_ref_value_0_asm_h
	.type	.Lput_ref_value_0_asm_h,@function
.Lput_ref_value_0_asm_h:                // @put_ref_value_0_asm_h
// %bb.0:                               // %B103
	sub	sp, sp, #32
	ldp	x10, x22, [x20, #-24]
	ldur	x21, [x20, #-8]
	cmp	x10, #18
	b.eq	.LBB90_7
// %bb.1:                               // %B1
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x10, x8
	b.ne	.LBB90_5
.LBB90_2:                               // %B89
	ldrh	w8, [x10, #6]
	cmp	w8, #1
	b.ne	.LBB90_5
// %bb.3:                               // %B3
	ldr	w8, [x10, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB90_5
// %bb.4:                               // %B3
	mov	x9, #2                          // =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	.LBB90_9
.LBB90_5:                               // %B93
	mov	x0, x24
	mov	x1, x10
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	str	x20, [x23, #48]
	bl	JS_SetPropertyValue_GC
	tbnz	w0, #31, .LBB90_45
// %bb.6:                               // %B95
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
.LBB90_7:                               // %B99
	ldr	w8, [x23, #44]
	tbnz	w8, #0, .LBB90_34
// %bb.8:                               // %B100
	ldr	x10, [x24, #208]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x10, x8
	b.eq	.LBB90_2
	b	.LBB90_5
.LBB90_9:                               // %B9
	and	x1, x22, #0xfffffffffffc
	stp	x10, x20, [sp, #16]             // 16-byte Folded Spill
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, .LBB90_36
// %bb.10:                              // %B87
	ldr	w8, [x1, #8]
	asr	w8, w8, #30
	ldp	x10, x20, [sp, #16]             // 16-byte Folded Reload
	cmp	w8, #1
	b.ne	.LBB90_5
.LBB90_11:                              // %B11
	ldr	x0, [x24, #8]
	bl	prim_get_interned_non_index_atom
	ldp	x10, x20, [sp, #16]             // 16-byte Folded Reload
	cbz	w0, .LBB90_5
// %bb.12:                              // %B13
	ldr	x8, [x10, #8]
	str	w0, [sp, #12]                   // 4-byte Folded Spill
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w0, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, .LBB90_15
.LBB90_13:                              // %B16
                                        // =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	.LBB90_21
// %bb.14:                              // %B26
                                        //   in Loop: Header=BB90_13 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, .LBB90_13
.LBB90_15:                              // %B28.preheader
	ldp	x8, x20, [sp, #16]              // 16-byte Folded Reload
.LBB90_16:                              // %B28
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB90_17 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w0, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, .LBB90_19
.LBB90_17:                              // %B64
                                        //   Parent Loop BB90_16 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	.LBB90_24
// %bb.18:                              // %B69
                                        //   in Loop: Header=BB90_17 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB90_17
.LBB90_19:                              // %B29
                                        //   in Loop: Header=BB90_16 Depth=1
	ldr	w9, [x8, #4]
	ldr	x10, [sp, #16]                  // 8-byte Folded Reload
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	.LBB90_5
// %bb.20:                              // %B58
                                        //   in Loop: Header=BB90_16 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB90_16
	b	.LBB90_25
.LBB90_21:                              // %B18
	mov	w9, #58                         // =0x3a
	and	w9, w9, w10, lsr #26
	ldp	x10, x20, [sp, #16]             // 16-byte Folded Reload
	cmp	w9, #2
	b.ne	.LBB90_5
// %bb.22:                              // %B22
	ldr	x9, [x10, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB90_43
.LBB90_23:                              // %B39
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #32
	br	x1
.LBB90_24:                              // %B66
	mov	w8, #58                         // =0x3a
	and	w8, w8, w10, lsr #26
	ldp	x10, x20, [sp, #16]             // 16-byte Folded Reload
	cmp	w8, #2
	b.ne	.LBB90_5
.LBB90_25:                              // %B32
	ldr	w8, [x10, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	.LBB90_5
// %bb.26:                              // %B51
	ldr	x20, [x10, #8]
	ldr	x8, [x20, #40]
	str	x8, [sp]                        // 8-byte Folded Spill
	cbz	x8, .LBB90_31
// %bb.27:                              // %B34
	ldr	x10, [sp, #16]                  // 8-byte Folded Reload
	ldr	x9, [sp]                        // 8-byte Folded Reload
	ldr	w11, [x20, #16]
	ldr	x8, [x10, #16]
	ldr	w9, [x9, #16]
	add	x10, x10, #32
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	.LBB90_29
// %bb.28:                              // %B34
	cbz	w8, .LBB90_41
.LBB90_29:                              // %B44
	ldr	w8, [x20, #48]
	cmp	w8, w0
	b.ne	.LBB90_31
// %bb.30:                              // %B44
	ldrb	w8, [x20, #52]
	cmp	w8, #7
	b.eq	.LBB90_38
.LBB90_31:                              // %B73
	ldr	x0, [x24, #8]
	ldr	w2, [sp, #12]                   // 4-byte Folded Reload
	mov	x1, x20
	mov	w3, #7                          // =0x7
	bl	find_hashed_shape_prop_gc
	cbz	x0, .LBB90_41
// %bb.32:                              // %B55
	ldr	x10, [sp, #16]                  // 8-byte Folded Reload
	ldr	w9, [x0, #16]
	ldr	w11, [x20, #16]
	ldr	x8, [x10, #16]
	add	x10, x10, #32
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	.LBB90_37
// %bb.33:
	str	x0, [sp]                        // 8-byte Folded Spill
	b	.LBB90_38
.LBB90_34:                              // %B96
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #48]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB90_45
// %bb.35:                              // %B98
	mov	w1, w0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_ThrowReferenceErrorNotDefined_GC
	add	sp, sp, #32
	b	.Lexception_asm_h
.LBB90_36:                              // %B10
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
	asr	w8, w8, #30
	ldp	x10, x20, [sp, #16]             // 16-byte Folded Reload
	cmp	w8, #1
	b.eq	.LBB90_11
	b	.LBB90_5
.LBB90_37:                              // %B55
	str	x0, [sp]                        // 8-byte Folded Spill
	cbz	w8, .LBB90_41
.LBB90_38:                              // %B36
	ldr	x10, [sp]                       // 8-byte Folded Reload
	ldr	x9, [sp, #16]                   // 8-byte Folded Reload
	ldr	w8, [x10]
	add	x9, x9, #8
	add	w8, w8, #1
	str	w8, [x10]
	ldr	w8, [x20]
	sub	w8, w8, #1
	str	w8, [x20]
	stlr	x10, [x9]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB90_40
// %bb.39:                              // %B43
	ldr	x9, [sp]                        // 8-byte Folded Reload
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	prim_WriteBarrierNoStore
.LBB90_40:                              // %B40
	ldr	x8, [sp]                        // 8-byte Folded Reload
	ldr	x9, [sp, #16]                   // 8-byte Folded Reload
	ldr	w8, [x8, #20]
	ldr	x9, [x9, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB90_23
	b	.LBB90_43
.LBB90_41:                              // %B76
	ldp	x1, x8, [sp, #16]               // 16-byte Folded Reload
	mov	x0, x24
	ldr	w2, [sp, #12]                   // 4-byte Folded Reload
	mov	w3, #7                          // =0x7
	str	x8, [x23, #48]
	bl	add_property_gc
	cbz	x0, .LBB90_44
// %bb.42:                              // %B80
	str	x21, [x0]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB90_23
.LBB90_43:                              // %B42
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #32
	br	x1
.LBB90_44:                              // %B77
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	sub	x20, x8, #24
.LBB90_45:                              // %B97
	add	sp, sp, #32
	b	.Lexception_asm_h
.Lfunc_end90:
	.size	.Lput_ref_value_0_asm_h, .Lfunc_end90-.Lput_ref_value_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_var_0_asm_h
	.type	.Ldefine_var_0_asm_h,@function
.Ldefine_var_0_asm_h:                   // @define_var_0_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_DefineGlobalVar_GC
	tbnz	w0, #31, .LBB91_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB91_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end91:
	.size	.Ldefine_var_0_asm_h, .Lfunc_end91-.Ldefine_var_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_define_var_0_asm_h
	.type	.Lcheck_define_var_0_asm_h,@function
.Lcheck_define_var_0_asm_h:             // @check_define_var_0_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, .LBB92_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB92_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end92:
	.size	.Lcheck_define_var_0_asm_h, .Lfunc_end92-.Lcheck_define_var_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_func_0_asm_h
	.type	.Ldefine_func_0_asm_h,@function
.Ldefine_func_0_asm_h:                  // @define_func_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	ldrb	w3, [x19, #4]
	str	x20, [x23, #48]
	mov	x2, x22
	bl	JS_DefineGlobalFunction_GC
	tbnz	w0, #31, .LBB93_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	sub	x20, x20, #8
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB93_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end93:
	.size	.Ldefine_func_0_asm_h, .Lfunc_end93-.Ldefine_func_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_field_0_asm_h
	.type	.Lget_field_0_asm_h,@function
.Lget_field_0_asm_h:                    // @get_field_0_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB94_10
// %bb.1:                               // %B25
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB94_2:                               // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB94_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB94_5
.LBB94_3:                               // %B1
                                        //   Parent Loop BB94_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	.LBB94_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB94_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB94_3
.LBB94_5:                               // %B14
                                        //   in Loop: Header=BB94_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB94_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB94_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB94_2
	b	.LBB94_9
.LBB94_7:                               // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB94_10
// %bb.8:                               // %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB94_9:                               // %B6
	ldrb	w9, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB94_10:                              // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB94_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB94_12:                              // %B22
	b	.Lexception_asm_h
.Lfunc_end94:
	.size	.Lget_field_0_asm_h, .Lfunc_end94-.Lget_field_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_field2_0_asm_h
	.type	.Lget_field2_0_asm_h,@function
.Lget_field2_0_asm_h:                   // @get_field2_0_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB95_10
// %bb.1:                               // %B25
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB95_2:                               // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB95_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB95_5
.LBB95_3:                               // %B1
                                        //   Parent Loop BB95_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	.LBB95_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB95_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB95_3
.LBB95_5:                               // %B14
                                        //   in Loop: Header=BB95_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB95_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB95_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB95_2
	b	.LBB95_9
.LBB95_7:                               // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB95_10
// %bb.8:                               // %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB95_9:                               // %B6
	ldrb	w9, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB95_10:                              // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB95_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB95_12:                              // %B22
	b	.Lexception_asm_h
.Lfunc_end95:
	.size	.Lget_field2_0_asm_h, .Lfunc_end95-.Lget_field2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_field_0_asm_h
	.type	.Lput_field_0_asm_h,@function
.Lput_field_0_asm_h:                    // @put_field_0_asm_h
// %bb.0:                               // %B80
	sub	sp, sp, #32
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          // =0x2
	mov	x12, x19
	movk	x8, #65535, lsl #48
	ldr	w19, [x19]
	tst	x22, x8
	b.ne	.LBB96_25
// %bb.1:                               // %B81
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w19, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, .LBB96_4
.LBB96_2:                               // %B1
                                        // =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w19
	b.eq	.LBB96_10
// %bb.3:                               // %B12
                                        //   in Loop: Header=BB96_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, .LBB96_2
.LBB96_4:                               // %B17.preheader
	mov	x8, x22
.LBB96_5:                               // %B17
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB96_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w19, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, .LBB96_8
.LBB96_6:                               // %B18
                                        //   Parent Loop BB96_5 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w19
	b.eq	.LBB96_13
// %bb.7:                               // %B59
                                        //   in Loop: Header=BB96_6 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB96_6
.LBB96_8:                               // %B66
                                        //   in Loop: Header=BB96_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	.LBB96_25
// %bb.9:                               // %B63
                                        //   in Loop: Header=BB96_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB96_5
	b	.LBB96_14
.LBB96_10:                              // %B3
	mov	w9, #58                         // =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	.LBB96_25
// %bb.11:                              // %B38
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB96_24
.LBB96_12:                              // %B37
	ldrb	w8, [x12, #4]
	sub	x20, x20, #16
	add	x19, x12, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
.LBB96_13:                              // %B20
	mov	w8, #58                         // =0x3a
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	.LBB96_25
.LBB96_14:                              // %B23
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	.LBB96_25
// %bb.15:                              // %B25
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	.LBB96_32
// %bb.16:                              // %B25
	tbnz	w19, #31, .LBB96_32
// %bb.17:                              // %B54
	ldr	x13, [x22, #8]
	ldr	x14, [x13, #40]
	cbz	x14, .LBB96_27
// %bb.18:                              // %B32
	ldr	x8, [x22, #16]
	ldr	w9, [x14, #16]
	add	x10, x22, #32
	ldr	w11, [x13, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	.LBB96_20
// %bb.19:                              // %B32
	cbz	w8, .LBB96_32
.LBB96_20:                              // %B42
	ldr	w8, [x13, #48]
	cmp	w8, w19
	b.ne	.LBB96_27
// %bb.21:                              // %B42
	ldrb	w8, [x13, #52]
	cmp	w8, #7
	b.ne	.LBB96_27
.LBB96_22:                              // %B34
	ldr	w8, [x14]
	add	x9, x22, #8
	add	w8, w8, #1
	str	w8, [x14]
	ldr	w8, [x13]
	sub	w8, w8, #1
	str	w8, [x13]
	stlr	x14, [x9]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB96_30
.LBB96_23:                              // %B38
	ldr	w8, [x14, #20]
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB96_12
.LBB96_24:                              // %B40
	mov	x0, x21
	mov	x1, x24
	mov	x19, x12
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
.LBB96_25:                              // %B77
	mov	x0, x24
	mov	x1, x22
	mov	w2, w19
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	str	x12, [sp, #24]                  // 8-byte Folded Spill
	str	x20, [x23, #48]
	bl	JS_SetPropertyInternalImpl_GC
	tbnz	w0, #31, .LBB96_37
// %bb.26:                              // %B79
	ldr	x19, [sp, #24]                  // 8-byte Folded Reload
	sub	x20, x20, #16
	ldrb	w8, [x19, #4]
	ldr	x1, [x25, x8, lsl #3]
	add	x19, x19, #5
	add	sp, sp, #32
	br	x1
.LBB96_27:                              // %B47
	ldr	x0, [x24, #8]
	mov	x1, x13
	mov	w2, w19
	mov	w3, #7                          // =0x7
	stp	x13, x20, [sp, #8]              // 16-byte Folded Spill
	str	x12, [sp, #24]                  // 8-byte Folded Spill
	bl	find_hashed_shape_prop_gc
	ldp	x11, x20, [sp, #8]              // 16-byte Folded Reload
	ldr	x12, [sp, #24]                  // 8-byte Folded Reload
	cbz	x0, .LBB96_32
// %bb.28:                              // %B50
	ldr	x8, [x22, #16]
	ldr	w9, [x0, #16]
	add	x10, x22, #32
	ldr	w11, [x11, #16]
	mov	x14, x0
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	.LBB96_31
// %bb.29:
	ldp	x20, x12, [sp, #16]             // 16-byte Folded Reload
	ldr	x13, [sp, #8]                   // 8-byte Folded Reload
	b	.LBB96_22
.LBB96_30:                              // %B41
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	mov	x19, x12
	orr	x0, x14, x8
	str	x14, [sp, #16]                  // 8-byte Folded Spill
	bl	prim_WriteBarrierNoStore
	ldr	x14, [sp, #16]                  // 8-byte Folded Reload
	mov	x12, x19
	b	.LBB96_23
.LBB96_31:                              // %B50
	ldp	x20, x12, [sp, #16]             // 16-byte Folded Reload
	ldr	x13, [sp, #8]                   // 8-byte Folded Reload
	cbnz	w8, .LBB96_22
.LBB96_32:                              // %B70
	mov	x0, x24
	mov	x1, x22
	mov	w2, w19
	mov	w3, #7                          // =0x7
	stp	x20, x12, [sp, #16]             // 16-byte Folded Spill
	str	x20, [x23, #48]
	bl	add_property_gc
	cbz	x0, .LBB96_36
// %bb.33:                              // %B74
	str	x21, [x0]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB96_35
// %bb.34:                              // %B76
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
.LBB96_35:                              // %B73
	ldr	x19, [sp, #24]                  // 8-byte Folded Reload
	ldrb	w8, [x19, #4]
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	x19, x19, #5
	add	sp, sp, #32
	br	x1
.LBB96_36:                              // %B71
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #16
.LBB96_37:                              // %B78
	ldr	x19, [sp, #24]                  // 8-byte Folded Reload
	add	sp, sp, #32
	b	.Lexception_asm_h
.Lfunc_end96:
	.size	.Lput_field_0_asm_h, .Lfunc_end96-.Lput_field_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_private_field_0_asm_h
	.type	.Lget_private_field_0_asm_h,@function
.Lget_private_field_0_asm_h:            // @get_private_field_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	.LBB97_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB97_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end97:
	.size	.Lget_private_field_0_asm_h, .Lfunc_end97-.Lget_private_field_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_private_field_0_asm_h
	.type	.Lput_private_field_0_asm_h,@function
.Lput_private_field_0_asm_h:            // @put_private_field_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	str	x20, [x23, #48]
	mov	x2, x21
	mov	x3, x22
	bl	JS_SetPrivateField_GC
	tbnz	w0, #31, .LBB98_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB98_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end98:
	.size	.Lput_private_field_0_asm_h, .Lfunc_end98-.Lput_private_field_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_private_field_0_asm_h
	.type	.Ldefine_private_field_0_asm_h,@function
.Ldefine_private_field_0_asm_h:         // @define_private_field_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	str	x20, [x23, #48]
	mov	x2, x22
	mov	x3, x21
	bl	JS_DefinePrivateField_GC
	tbnz	w0, #31, .LBB99_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB99_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end99:
	.size	.Ldefine_private_field_0_asm_h, .Lfunc_end99-.Ldefine_private_field_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_array_el_0_asm_h
	.type	.Lget_array_el_0_asm_h,@function
.Lget_array_el_0_asm_h:                 // @get_array_el_0_asm_h
// %bb.0:                               // %B112
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB100_12
// %bb.1:                               // %B109
	mov	w9, #65534                      // =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	.LBB100_5
// %bb.2:                               // %B1
	cmp	w8, #2
	b.ne	.LBB100_10
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	.LBB100_14
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #16
	add	w8, w8, #247
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB100_5:                              // %B69
	cmp	w8, #1
	b.ne	.LBB100_12
// %bb.6:                               // %B72
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB100_12
// %bb.7:                               // %B72
	mov	x9, #2                          // =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	.LBB100_12
// %bb.8:                               // %B101
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, .LBB100_24
// %bb.9:                               // %B104
	ldr	w8, [x1, #8]
	b	.LBB100_25
.LBB100_10:                             // %B30
	sxth	w9, w8
	cmp	w9, #21
	b.lt	.LBB100_12
// %bb.11:                              // %B30
	cmp	w9, #29
	b.le	.LBB100_33
.LBB100_12:                             // %B106
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB100_38
// %bb.13:                              // %B108
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB100_14:                             // %B7
	tbnz	w21, #31, .LBB100_12
// %bb.15:                              // %B9.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB100_16:                             // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB100_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, .LBB100_19
.LBB100_17:                             // %B10
                                        //   Parent Loop BB100_16 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	.LBB100_21
// %bb.18:                              // %B17
                                        //   in Loop: Header=BB100_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB100_17
.LBB100_19:                             // %B24
                                        //   in Loop: Header=BB100_16 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB100_12
// %bb.20:                              // %B21
                                        //   in Loop: Header=BB100_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB100_16
	b	.LBB100_23
.LBB100_21:                             // %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	.LBB100_12
// %bb.22:                              // %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB100_23:                             // %B87
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB100_24:                             // %B102
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
.LBB100_25:                             // %B98
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	.LBB100_12
// %bb.26:                              // %B77
	ldr	x0, [x24, #8]
	bl	prim_get_interned_non_index_atom
	cbz	w0, .LBB100_12
// %bb.27:                              // %B80.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB100_28:                             // %B80
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB100_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB100_31
.LBB100_29:                             // %B83
                                        //   Parent Loop BB100_28 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	.LBB100_39
// %bb.30:                              // %B89
                                        //   in Loop: Header=BB100_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB100_29
.LBB100_31:                             // %B94
                                        //   in Loop: Header=BB100_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB100_12
// %bb.32:                              // %B91
                                        //   in Loop: Header=BB100_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB100_28
	b	.LBB100_23
.LBB100_33:                             // %B32
	ldr	w9, [x22, #48]
	cmp	w21, w9
	b.hs	.LBB100_12
// %bb.34:                              // %B34
	ldr	x9, [x22, #40]
	cmp	w8, #23
	b.ge	.LBB100_41
// %bb.35:                              // %B34
	cmp	w8, #21
	b.eq	.LBB100_42
// %bb.36:                              // %B34
	cmp	w8, #22
	b.ne	.LBB100_12
// %bb.37:                              // %B35
	ldrsb	w8, [x9, w21, sxtw]
	b	.LBB100_54
.LBB100_38:                             // %B107
	b	.Lexception_asm_h
.LBB100_39:                             // %B85
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB100_12
// %bb.40:                              // %B86
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB100_41:                             // %B34
	b.gt	.LBB100_43
.LBB100_42:                             // %B39
	ldrb	w8, [x9, w21, sxtw]
	b	.LBB100_54
.LBB100_43:                             // %B34
	cmp	w8, #25
	b.gt	.LBB100_47
// %bb.44:                              // %B34
	cmp	w8, #24
	b.eq	.LBB100_51
// %bb.45:                              // %B34
	cmp	w8, #25
	b.ne	.LBB100_12
// %bb.46:                              // %B45
	ldrh	w8, [x9, w21, sxtw #1]
	b	.LBB100_54
.LBB100_47:                             // %B34
	cmp	w8, #26
	b.eq	.LBB100_52
// %bb.48:                              // %B34
	cmp	w8, #27
	b.eq	.LBB100_53
// %bb.49:                              // %B34
	cmp	w8, #29
	b.ne	.LBB100_12
// %bb.50:                              // %B62
	ldr	d0, [x9, w21, sxtw #3]
	b	.LBB100_56
.LBB100_51:                             // %B42
	ldrsh	w8, [x9, w21, sxtw #1]
	b	.LBB100_54
.LBB100_52:                             // %B48
	ldr	w8, [x9, w21, sxtw #2]
	b	.LBB100_54
.LBB100_53:                             // %B56
	ldr	w8, [x9, w21, sxtw #2]
	tbnz	w8, #31, .LBB100_55
.LBB100_54:                             // %B57
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB100_55:                             // %B52
	ucvtf	d0, w8
.LBB100_56:                             // %B36
	fmov	x8, d0
	fcmp	d0, d0
	mov	x9, #562949953421312            // =0x2000000000000
	add	x8, x8, x9
	mov	x9, #9221683186994511872        // =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end100:
	.size	.Lget_array_el_0_asm_h, .Lfunc_end100-.Lget_array_el_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_array_el2_0_asm_h
	.type	.Lget_array_el2_0_asm_h,@function
.Lget_array_el2_0_asm_h:                // @get_array_el2_0_asm_h
// %bb.0:                               // %B112
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB101_12
// %bb.1:                               // %B109
	mov	w9, #65534                      // =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	.LBB101_5
// %bb.2:                               // %B1
	cmp	w8, #2
	b.ne	.LBB101_10
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	.LBB101_14
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #16
	add	w8, w8, #494
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB101_5:                              // %B69
	cmp	w8, #1
	b.ne	.LBB101_12
// %bb.6:                               // %B72
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB101_12
// %bb.7:                               // %B72
	mov	x9, #2                          // =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	.LBB101_12
// %bb.8:                               // %B101
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, .LBB101_24
// %bb.9:                               // %B104
	ldr	w8, [x1, #8]
	b	.LBB101_25
.LBB101_10:                             // %B30
	sxth	w9, w8
	cmp	w9, #21
	b.lt	.LBB101_12
// %bb.11:                              // %B30
	cmp	w9, #29
	b.le	.LBB101_33
.LBB101_12:                             // %B106
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB101_38
// %bb.13:                              // %B108
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB101_14:                             // %B7
	tbnz	w21, #31, .LBB101_12
// %bb.15:                              // %B9.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB101_16:                             // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB101_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, .LBB101_19
.LBB101_17:                             // %B10
                                        //   Parent Loop BB101_16 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	.LBB101_21
// %bb.18:                              // %B17
                                        //   in Loop: Header=BB101_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB101_17
.LBB101_19:                             // %B24
                                        //   in Loop: Header=BB101_16 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB101_12
// %bb.20:                              // %B21
                                        //   in Loop: Header=BB101_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB101_16
	b	.LBB101_23
.LBB101_21:                             // %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	.LBB101_12
// %bb.22:                              // %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB101_23:                             // %B87
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB101_24:                             // %B102
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
.LBB101_25:                             // %B98
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	.LBB101_12
// %bb.26:                              // %B77
	ldr	x0, [x24, #8]
	bl	prim_get_interned_non_index_atom
	cbz	w0, .LBB101_12
// %bb.27:                              // %B80.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB101_28:                             // %B80
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB101_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB101_31
.LBB101_29:                             // %B83
                                        //   Parent Loop BB101_28 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	.LBB101_39
// %bb.30:                              // %B89
                                        //   in Loop: Header=BB101_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB101_29
.LBB101_31:                             // %B94
                                        //   in Loop: Header=BB101_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB101_12
// %bb.32:                              // %B91
                                        //   in Loop: Header=BB101_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB101_28
	b	.LBB101_23
.LBB101_33:                             // %B32
	ldr	w9, [x22, #48]
	cmp	w21, w9
	b.hs	.LBB101_12
// %bb.34:                              // %B34
	ldr	x9, [x22, #40]
	cmp	w8, #23
	b.ge	.LBB101_41
// %bb.35:                              // %B34
	cmp	w8, #21
	b.eq	.LBB101_42
// %bb.36:                              // %B34
	cmp	w8, #22
	b.ne	.LBB101_12
// %bb.37:                              // %B35
	ldrsb	w8, [x9, w21, sxtw]
	b	.LBB101_54
.LBB101_38:                             // %B107
	b	.Lexception_asm_h
.LBB101_39:                             // %B85
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB101_12
// %bb.40:                              // %B86
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB101_41:                             // %B34
	b.gt	.LBB101_43
.LBB101_42:                             // %B39
	ldrb	w8, [x9, w21, sxtw]
	b	.LBB101_54
.LBB101_43:                             // %B34
	cmp	w8, #25
	b.gt	.LBB101_47
// %bb.44:                              // %B34
	cmp	w8, #24
	b.eq	.LBB101_51
// %bb.45:                              // %B34
	cmp	w8, #25
	b.ne	.LBB101_12
// %bb.46:                              // %B45
	ldrh	w8, [x9, w21, sxtw #1]
	b	.LBB101_54
.LBB101_47:                             // %B34
	cmp	w8, #26
	b.eq	.LBB101_52
// %bb.48:                              // %B34
	cmp	w8, #27
	b.eq	.LBB101_53
// %bb.49:                              // %B34
	cmp	w8, #29
	b.ne	.LBB101_12
// %bb.50:                              // %B62
	ldr	d0, [x9, w21, sxtw #3]
	b	.LBB101_56
.LBB101_51:                             // %B42
	ldrsh	w8, [x9, w21, sxtw #1]
	b	.LBB101_54
.LBB101_52:                             // %B48
	ldr	w8, [x9, w21, sxtw #2]
	b	.LBB101_54
.LBB101_53:                             // %B56
	ldr	w8, [x9, w21, sxtw #2]
	tbnz	w8, #31, .LBB101_55
.LBB101_54:                             // %B57
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB101_55:                             // %B52
	ucvtf	d0, w8
.LBB101_56:                             // %B36
	fmov	x8, d0
	fcmp	d0, d0
	mov	x9, #562949953421312            // =0x2000000000000
	add	x8, x8, x9
	mov	x9, #9221683186994511872        // =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end101:
	.size	.Lget_array_el2_0_asm_h, .Lfunc_end101-.Lget_array_el2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_array_el_0_asm_h
	.type	.Lput_array_el_0_asm_h,@function
.Lput_array_el_0_asm_h:                 // @put_array_el_0_asm_h
// %bb.0:                               // %B190
	sub	sp, sp, #32
	ldp	x10, x22, [x20, #-24]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	ldur	x21, [x20, #-8]
	tst	x10, x8
	b.ne	.LBB102_7
// %bb.1:                               // %B1
	mov	w8, #65534                      // =0xfffe
	ldrh	w9, [x10, #6]
	cmp	x8, x22, lsr #48
	b.ne	.LBB102_10
// %bb.2:                               // %B3
	cmp	w9, #2
	b.ne	.LBB102_15
// %bb.3:                               // %B5
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB102_7
// %bb.4:                               // %B50
	ldr	w8, [x10, #48]
	cmp	w22, w8
	b.hs	.LBB102_22
// %bb.5:                               // %B7
	ldr	x8, [x10, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB102_33
// %bb.6:                               // %B9
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
.LBB102_7:
	stp	x20, x10, [sp, #16]             // 16-byte Folded Spill
.LBB102_8:                              // %B187
	mov	w4, #32768                      // =0x8000
.LBB102_9:                              // %B187
	ldp	x8, x1, [sp, #16]               // 16-byte Folded Reload
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	str	x8, [x23, #48]
	bl	JS_SetPropertyValue_GC
	tbz	w0, #31, .LBB102_32
	b	.LBB102_63
.LBB102_10:                             // %B100
	cmp	w9, #1
	stp	x20, x10, [sp, #16]             // 16-byte Folded Spill
	b.ne	.LBB102_8
// %bb.11:                              // %B181
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	mov	w4, #32768                      // =0x8000
	ldr	w8, [x8, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB102_9
// %bb.12:                              // %B181
	mov	x9, #2                          // =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	.LBB102_9
// %bb.13:                              // %B103
	and	x1, x22, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, .LBB102_48
// %bb.14:                              // %B180
	ldr	w8, [x1, #8]
	b	.LBB102_49
.LBB102_15:                             // %B55
	sxth	w8, w9
	mov	w4, #32768                      // =0x8000
	stp	x20, x10, [sp, #16]             // 16-byte Folded Spill
	cmp	w8, #21
	b.lt	.LBB102_9
// %bb.16:                              // %B55
	cmp	w8, #29
	b.gt	.LBB102_9
// %bb.17:                              // %B57
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB102_47
// %bb.18:                              // %B59
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	ldr	w8, [x8, #48]
	cmp	w22, w8
	b.hs	.LBB102_47
// %bb.19:                              // %B61
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	sub	w10, w9, #22
	cmp	w10, #2
	ldr	x8, [x8, #40]
	b.hs	.LBB102_34
// %bb.20:                              // %B71
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	.LBB102_47
// %bb.21:                              // %B72
	strb	w21, [x8, w22, sxtw]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #32
	br	x1
.LBB102_22:                             // %B12
	stp	x20, x10, [sp, #16]             // 16-byte Folded Spill
	b.ne	.LBB102_60
// %bb.23:                              // %B40
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	mov	w4, #32768                      // =0x8000
	ldr	w9, [x9, #4]
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	b.ne	.LBB102_9
// %bb.24:                              // %B40
	ubfx	w9, w9, #8, #1
	cbz	w9, .LBB102_9
// %bb.25:                              // %B14
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbz	x9, .LBB102_27
// %bb.26:                              // %B36
	ldr	w9, [x9, #4]
	ubfx	w9, w9, #13, #1
	cmp	w9, #1
	b.ne	.LBB102_9
.LBB102_27:                             // %B32
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	ldr	x9, [x9, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	.LBB102_29
// %bb.28:                              // %B32
	cmp	w9, w10
	b.hi	.LBB102_62
.LBB102_29:                             // %B29
	ldr	x10, [sp, #24]                  // 8-byte Folded Reload
	ldr	w10, [x10, #32]
	cmp	w9, w10
	b.hi	.LBB102_62
// %bb.30:                              // %B25
	ldr	x11, [sp, #24]                  // 8-byte Folded Reload
	ldr	x10, [x11, #40]
	str	w9, [x11, #48]
	str	x21, [x10, w8, sxtw #3]
.LBB102_31:                             // %B133
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB102_64
.LBB102_32:                             // %B132
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #32
	br	x1
.LBB102_33:                             // %B11
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
.LBB102_34:                             // %B61
	cmp	w9, #25
	mov	w4, wzr
	b.gt	.LBB102_38
// %bb.35:                              // %B61
	sub	w10, w9, #24
	cmp	w10, #2
	b.hs	.LBB102_41
// %bb.36:                              // %B77
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	.LBB102_47
// %bb.37:                              // %B78
	strh	w21, [x8, w22, sxtw #1]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #32
	br	x1
.LBB102_38:                             // %B61
	sub	w10, w9, #26
	cmp	w10, #2
	b.hs	.LBB102_44
// %bb.39:                              // %B83
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	.LBB102_47
// %bb.40:                              // %B84
	str	w21, [x8, w22, sxtw #2]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #32
	br	x1
.LBB102_41:                             // %B61
	cmp	w9, #21
	b.ne	.LBB102_9
// %bb.42:                              // %B63
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	.LBB102_47
// %bb.43:                              // %B64
	cmp	w21, #255
	mov	w9, #255                        // =0xff
	csel	w9, w21, w9, lt
	bic	w9, w9, w9, asr #31
	strb	w9, [x8, w22, sxtw]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #32
	br	x1
.LBB102_44:                             // %B61
	cmp	w9, #29
	b.ne	.LBB102_9
// %bb.45:                              // %B89
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	.LBB102_65
// %bb.46:                              // %B90
	scvtf	d0, w21
	str	d0, [x8, w22, sxtw #3]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #32
	br	x1
.LBB102_47:
	mov	w4, wzr
	b	.LBB102_9
.LBB102_48:                             // %B104
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
.LBB102_49:                             // %B176
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	.LBB102_9
// %bb.50:                              // %B105
	ldr	x0, [x24, #8]
	bl	prim_get_interned_non_index_atom
	cbz	w0, .LBB102_8
// %bb.51:                              // %B107
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	str	w0, [sp, #4]                    // 4-byte Folded Spill
	ldr	x8, [x8, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w0, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, .LBB102_54
.LBB102_52:                             // %B110
                                        // =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	.LBB102_68
// %bb.53:                              // %B119
                                        //   in Loop: Header=BB102_52 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, .LBB102_52
.LBB102_54:                             // %B121.preheader
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
.LBB102_55:                             // %B121
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB102_56 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w0, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, .LBB102_58
.LBB102_56:                             // %B157
                                        //   Parent Loop BB102_55 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	.LBB102_69
// %bb.57:                              // %B162
                                        //   in Loop: Header=BB102_56 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB102_56
.LBB102_58:                             // %B122
                                        //   in Loop: Header=BB102_55 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	.LBB102_8
// %bb.59:                              // %B151
                                        //   in Loop: Header=BB102_55 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB102_55
	b	.LBB102_70
.LBB102_60:                             // %B44
	tbnz	w22, #31, .LBB102_8
// %bb.61:                              // %B46
	ldp	x8, x1, [sp, #16]               // 16-byte Folded Reload
	mov	x0, x24
	mov	w2, w22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	str	x8, [x23, #48]
	bl	JS_SetArrayIntPropertyValue_GC
	tbz	w0, #31, .LBB102_32
	b	.LBB102_63
.LBB102_62:                             // %B20
	ldp	x8, x1, [sp, #16]               // 16-byte Folded Reload
	mov	x0, x24
	mov	x2, x21
	mov	w3, #32768                      // =0x8000
	str	x8, [x23, #48]
	bl	add_fast_array_element_gc
	tbz	w0, #31, .LBB102_32
.LBB102_63:                             // %B47
	ldr	x20, [sp, #16]                  // 8-byte Folded Reload
	add	sp, sp, #32
	b	.Lexception_asm_h
.LBB102_64:                             // %B135
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #32
	br	x1
.LBB102_65:                             // %B92
	and	x9, x21, #0xfffe000000000000
	mov	x10, #-562949953421312          // =0xfffe000000000000
	mov	w4, wzr
	cmp	x9, x10
	b.eq	.LBB102_9
// %bb.66:                              // %B92
	cbz	x9, .LBB102_9
// %bb.67:                              // %B93
	mov	x9, #-562949953421312           // =0xfffe000000000000
	add	x9, x21, x9
	str	x9, [x8, w22, sxtw #3]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #32
	br	x1
.LBB102_68:                             // %B112
	mov	w9, #58                         // =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.eq	.LBB102_83
	b	.LBB102_8
.LBB102_69:                             // %B159
	mov	w8, #58                         // =0x3a
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	.LBB102_8
.LBB102_70:                             // %B125
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	ldr	w8, [x8, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	.LBB102_8
// %bb.71:                              // %B144
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	ldr	x8, [x8, #8]
	mov	x20, x8
	ldr	x8, [x8, #40]
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	cbz	x8, .LBB102_76
// %bb.72:                              // %B127
	ldr	x10, [sp, #24]                  // 8-byte Folded Reload
	ldr	x9, [sp, #8]                    // 8-byte Folded Reload
	ldr	w11, [x20, #16]
	ldr	x8, [x10, #16]
	ldr	w9, [x9, #16]
	add	x10, x10, #32
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	.LBB102_74
// %bb.73:                              // %B127
	cbz	w8, .LBB102_84
.LBB102_74:                             // %B137
	ldr	w8, [x20, #48]
	cmp	w8, w0
	b.ne	.LBB102_76
// %bb.75:                              // %B137
	ldrb	w8, [x20, #52]
	cmp	w8, #7
	b.eq	.LBB102_80
.LBB102_76:                             // %B166
	ldr	x0, [x24, #8]
	ldr	w2, [sp, #4]                    // 4-byte Folded Reload
	mov	x1, x20
	mov	w3, #7                          // =0x7
	bl	find_hashed_shape_prop_gc
	cbz	x0, .LBB102_84
// %bb.77:                              // %B148
	ldr	x10, [sp, #24]                  // 8-byte Folded Reload
	ldr	w9, [x0, #16]
	ldr	w11, [x20, #16]
	ldr	x8, [x10, #16]
	add	x10, x10, #32
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	.LBB102_79
// %bb.78:
	str	x0, [sp, #8]                    // 8-byte Folded Spill
	b	.LBB102_80
.LBB102_79:                             // %B148
	str	x0, [sp, #8]                    // 8-byte Folded Spill
	cbz	w8, .LBB102_84
.LBB102_80:                             // %B129
	ldr	x10, [sp, #8]                   // 8-byte Folded Reload
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	ldr	w8, [x10]
	add	x9, x9, #8
	add	w8, w8, #1
	str	w8, [x10]
	ldr	w8, [x20]
	sub	w8, w8, #1
	str	w8, [x20]
	stlr	x10, [x9]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB102_82
// %bb.81:                              // %B136
	ldr	x9, [sp, #8]                    // 8-byte Folded Reload
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	prim_WriteBarrierNoStore
.LBB102_82:                             // %B133
	ldr	x8, [sp, #8]                    // 8-byte Folded Reload
	ldr	w8, [x8, #20]
.LBB102_83:                             // %B133
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	sub	w8, w8, #1
	ldr	x9, [x9, #16]
	str	x21, [x9, w8, sxtw #3]
	b	.LBB102_31
.LBB102_84:                             // %B169
	ldp	x8, x1, [sp, #16]               // 16-byte Folded Reload
	mov	x0, x24
	ldr	w2, [sp, #4]                    // 4-byte Folded Reload
	mov	w3, #7                          // =0x7
	str	x8, [x23, #48]
	bl	add_property_gc
	cbz	x0, .LBB102_86
// %bb.85:                              // %B173
	str	x21, [x0]
	b	.LBB102_31
.LBB102_86:                             // %B170
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #32
	b	.Lexception_asm_h
.Lfunc_end102:
	.size	.Lput_array_el_0_asm_h, .Lfunc_end102-.Lput_array_el_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_super_value_0_asm_h
	.type	.Lget_super_value_0_asm_h,@function
.Lget_super_value_0_asm_h:              // @get_super_value_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x21
	bl	js_value_to_atom_gc
	cbz	w0, .LBB103_3
// %bb.1:                               // %B5
	ldur	x3, [x20, #-24]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB103_3
// %bb.2:                               // %B7
	stur	x0, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB103_3:                              // %B6
	b	.Lexception_asm_h
.Lfunc_end103:
	.size	.Lget_super_value_0_asm_h, .Lfunc_end103-.Lget_super_value_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_super_value_0_asm_h
	.type	.Lput_super_value_0_asm_h,@function
.Lput_super_value_0_asm_h:              // @put_super_value_0_asm_h
// %bb.0:                               // %B8
	sub	sp, sp, #16
	ldur	x9, [x20, #-24]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x9, x8
	b.eq	.LBB104_3
// %bb.1:                               // %B10
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_ThrowTypeErrorNotAnObject
.LBB104_2:                              // %B6
	add	sp, sp, #16
	b	.Lexception_asm_h
.LBB104_3:                              // %B1
	ldur	x1, [x20, #-16]
	mov	x0, x24
	str	x9, [sp, #8]                    // 8-byte Folded Spill
	str	x20, [x23, #48]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB104_2
// %bb.4:                               // %B5
	ldur	x3, [x20, #-8]
	ldur	x4, [x20, #-32]
	mov	w2, w0
	ldr	x1, [sp, #8]                    // 8-byte Folded Reload
	mov	x0, x24
	mov	w5, #32768                      // =0x8000
	str	x20, [x23, #48]
	bl	JS_SetPropertyGeneric_GC
	tbnz	w0, #31, .LBB104_2
// %bb.5:                               // %B7
	ldrb	w8, [x19], #1
	sub	x20, x20, #32
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.Lfunc_end104:
	.size	.Lput_super_value_0_asm_h, .Lfunc_end104-.Lput_super_value_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_field_0_asm_h
	.type	.Ldefine_field_0_asm_h,@function
.Ldefine_field_0_asm_h:                 // @define_field_0_asm_h
// %bb.0:                               // %B58
	sub	sp, sp, #32
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	ldr	w2, [x19]
	tst	x22, x8
	b.ne	.LBB105_4
// %bb.1:                               // %B55
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	.LBB105_4
// %bb.2:                               // %B49
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB105_4
// %bb.3:                               // %B52
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.eq	.LBB105_6
.LBB105_4:                              // %B46
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #16391                      // =0x4007
	str	x20, [x23, #48]
	bl	JS_DefinePropertyValue_GC
	tbnz	w0, #31, .LBB105_17
.LBB105_5:                              // %B4
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #32
	br	x1
.LBB105_6:                              // %B53
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, .LBB105_9
.LBB105_7:                              // %B35
                                        // =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	.LBB105_18
// %bb.8:                               // %B37
                                        //   in Loop: Header=BB105_7 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, .LBB105_7
.LBB105_9:                              // %B40
	tbnz	w2, #31, .LBB105_4
// %bb.10:                              // %B11
	ldr	x8, [x22, #8]
	str	x8, [sp, #24]                   // 8-byte Folded Spill
	ldr	x8, [x8, #40]
	str	x8, [sp, #16]                   // 8-byte Folded Spill
	cbz	x8, .LBB105_21
// %bb.11:                              // %B15
	ldp	x9, x11, [sp, #16]              // 16-byte Folded Reload
	add	x10, x22, #32
	ldr	x8, [x22, #16]
	ldr	w9, [x9, #16]
	ldr	w11, [x11, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	.LBB105_13
// %bb.12:                              // %B15
	cbz	w8, .LBB105_4
.LBB105_13:                             // %B17
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	ldr	w8, [x8, #48]
	cmp	w8, w2
	b.ne	.LBB105_21
// %bb.14:                              // %B17
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	ldrb	w8, [x8, #52]
	cmp	w8, #7
	b.ne	.LBB105_21
.LBB105_15:                             // %B25
	ldp	x11, x10, [sp, #16]             // 16-byte Folded Reload
	add	x9, x22, #8
	ldr	w8, [x11]
	add	w8, w8, #1
	str	w8, [x11]
	ldr	w8, [x10]
	sub	w8, w8, #1
	str	w8, [x10]
	stlr	x11, [x9]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB105_24
.LBB105_16:                             // %B22
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	ldr	w8, [x8, #20]
	b	.LBB105_19
.LBB105_17:                             // %B47
	add	sp, sp, #32
	b	.Lexception_asm_h
.LBB105_18:                             // %B1
	lsr	w9, w10, #26
	and	w9, w9, #0xfffffff7
	cmp	w9, #7
	b.ne	.LBB105_4
.LBB105_19:                             // %B22
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB105_5
// %bb.20:
	mov	x1, x24
	mov	x0, x21
	bl	prim_WriteBarrierNoStore
	b	.LBB105_5
.LBB105_21:                             // %B43
	ldr	x0, [x24, #8]
	ldr	x1, [sp, #24]                   // 8-byte Folded Reload
	mov	w3, #7                          // =0x7
	str	w2, [sp, #12]                   // 4-byte Folded Spill
	bl	find_hashed_shape_prop_gc
	ldr	w2, [sp, #12]                   // 4-byte Folded Reload
	cbz	x0, .LBB105_4
// %bb.22:                              // %B30
	ldr	x8, [x22, #16]
	ldr	x11, [sp, #24]                  // 8-byte Folded Reload
	add	x10, x22, #32
	ldr	w9, [x0, #16]
	ldr	w11, [x11, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	.LBB105_25
// %bb.23:
	str	x0, [sp, #16]                   // 8-byte Folded Spill
	b	.LBB105_15
.LBB105_24:                             // %B27
	ldr	x9, [sp, #16]                   // 8-byte Folded Reload
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	prim_WriteBarrierNoStore
	b	.LBB105_16
.LBB105_25:                             // %B30
	ldr	w2, [sp, #12]                   // 4-byte Folded Reload
	str	x0, [sp, #16]                   // 8-byte Folded Spill
	cbnz	w8, .LBB105_15
	b	.LBB105_4
.Lfunc_end105:
	.size	.Ldefine_field_0_asm_h, .Lfunc_end105-.Ldefine_field_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_name_0_asm_h
	.type	.Lset_name_0_asm_h,@function
.Lset_name_0_asm_h:                     // @set_name_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x23, #48]
	mov	x1, x22
	bl	JS_DefineObjectName
	tbnz	w0, #31, .LBB106_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB106_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end106:
	.size	.Lset_name_0_asm_h, .Lfunc_end106-.Lset_name_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_name_computed_0_asm_h
	.type	.Lset_name_computed_0_asm_h,@function
.Lset_name_computed_0_asm_h:            // @set_name_computed_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x23, #48]
	mov	x1, x21
	mov	x2, x22
	bl	JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, .LBB107_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB107_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end107:
	.size	.Lset_name_computed_0_asm_h, .Lfunc_end107-.Lset_name_computed_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_proto_0_asm_h
	.type	.Lset_proto_0_asm_h,@function
.Lset_proto_0_asm_h:                    // @set_proto_0_asm_h
// %bb.0:                               // %B6
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB108_3
// %bb.1:                               // %B6
	cmp	x21, #2
	b.eq	.LBB108_3
.LBB108_2:                              // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB108_3:                              // %B1
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x20, [x23, #48]
	bl	JS_SetPrototypeInternal_GC
	tbz	w0, #31, .LBB108_2
// %bb.4:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end108:
	.size	.Lset_proto_0_asm_h, .Lfunc_end108-.Lset_proto_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_home_object_0_asm_h
	.type	.Lset_home_object_0_asm_h,@function
.Lset_home_object_0_asm_h:              // @set_home_object_0_asm_h
// %bb.0:                               // %B0
	sub	sp, sp, #16
	mov	x8, x20
	ldur	x21, [x20, #-8]
	mov	x0, x24
	ldr	x22, [x8, #-16]!
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	mov	x1, x21
	str	x20, [x23, #48]
	mov	x2, x22
	bl	js_method_set_home_object_gc
	ldrb	w8, [x19], #1
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
.Lfunc_end109:
	.size	.Lset_home_object_0_asm_h, .Lfunc_end109-.Lset_home_object_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_array_el_0_asm_h
	.type	.Ldefine_array_el_0_asm_h,@function
.Ldefine_array_el_0_asm_h:              // @define_array_el_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	mov	w4, #16391                      // =0x4007
	str	x20, [x23, #48]
	mov	x2, x22
	mov	x3, x21
	bl	JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, .LBB110_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB110_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end110:
	.size	.Ldefine_array_el_0_asm_h, .Lfunc_end110-.Ldefine_array_el_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function append_0_asm_h
	.type	.Lappend_0_asm_h,@function
.Lappend_0_asm_h:                       // @append_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	js_append_enumerate_gc
	tbnz	w0, #31, .LBB111_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB111_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end111:
	.size	.Lappend_0_asm_h, .Lfunc_end111-.Lappend_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function copy_data_properties_0_asm_h
	.type	.Lcopy_data_properties_0_asm_h,@function
.Lcopy_data_properties_0_asm_h:         // @copy_data_properties_0_asm_h
// %bb.0:                               // %B1
	ldrb	w2, [x19]
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	prim_js_copy_data_properties_gc
	tbnz	w0, #31, .LBB112_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB112_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end112:
	.size	.Lcopy_data_properties_0_asm_h, .Lfunc_end112-.Lcopy_data_properties_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_method_0_asm_h
	.type	.Ldefine_method_0_asm_h,@function
.Ldefine_method_0_asm_h:                // @define_method_0_asm_h
// %bb.0:                               // %B15
	sub	sp, sp, #64
	ldrb	w8, [x19, #4]
	mov	w9, #17665                      // =0x4501
	mov	w10, #17669                     // =0x4505
	mov	x11, x19
	ldr	w19, [x19]
	tst	w8, #0x4
	str	x11, [sp, #48]                  // 8-byte Folded Spill
	csel	w10, w10, w9, ne
	ldp	x9, x12, [x20, #-16]
	ands	w8, w8, #0x3
	b.eq	.LBB113_3
// %bb.1:                               // %B15
	cmp	w8, #1
	b.ne	.LBB113_4
// %bb.2:                               // %B13
	mov	w8, #18                         // =0x12
	mov	w11, #2048                      // =0x800
	stp	x12, x8, [sp, #16]              // 16-byte Folded Spill
	b	.LBB113_5
.LBB113_3:
	mov	w8, #18                         // =0x12
	str	x12, [sp, #40]                  // 8-byte Folded Spill
	mov	w11, #8706                      // =0x2202
	str	x8, [sp, #24]                   // 8-byte Folded Spill
	mov	w8, #18                         // =0x12
	str	x8, [sp, #16]                   // 8-byte Folded Spill
	b	.LBB113_6
.LBB113_4:                              // %B14
	mov	w11, #4096                      // =0x1000
	mov	w8, #18                         // =0x12
	stp	x8, x12, [sp, #16]              // 16-byte Folded Spill
.LBB113_5:                              // %B10
	mov	w8, #18                         // =0x12
	str	x8, [sp, #40]                   // 8-byte Folded Spill
.LBB113_6:                              // %B10
	ldur	x1, [x20, #-8]
	orr	w3, w10, w11
	mov	x0, x24
	mov	w2, w19
	mov	x4, x9
	str	x20, [x23, #48]
	str	w11, [sp, #36]                  // 4-byte Folded Spill
	str	x20, [sp, #56]                  // 8-byte Folded Spill
	mov	w20, w19
	mov	x19, x9
	str	w10, [sp, #12]                  // 4-byte Folded Spill
	bl	js_method_set_properties_gc
	tbnz	w0, #31, .LBB113_9
// %bb.7:                               // %B5
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	ldr	w9, [sp, #12]                   // 4-byte Folded Reload
	mov	x0, x24
	ldp	x4, x5, [sp, #16]               // 16-byte Folded Reload
	mov	x1, x19
	str	x8, [x23, #48]
	ldr	w8, [sp, #36]                   // 4-byte Folded Reload
	mov	w2, w20
	ldr	x3, [sp, #40]                   // 8-byte Folded Reload
	orr	w6, w9, w8
	bl	JS_DefineProperty_GC
	tbnz	w0, #31, .LBB113_9
// %bb.8:                               // %B7
	ldr	x9, [sp, #48]                   // 8-byte Folded Reload
	ldrb	w8, [x9, #5]
	add	x19, x9, #6
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #64
	br	x1
.LBB113_9:                              // %B2
	ldp	x19, x20, [sp, #48]             // 16-byte Folded Reload
	add	sp, sp, #64
	b	.Lexception_asm_h
.Lfunc_end113:
	.size	.Ldefine_method_0_asm_h, .Lfunc_end113-.Ldefine_method_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_method_computed_0_asm_h
	.type	.Ldefine_method_computed_0_asm_h,@function
.Ldefine_method_computed_0_asm_h:       // @define_method_computed_0_asm_h
// %bb.0:                               // %B8
	sub	sp, sp, #64
	ldur	x1, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	js_value_to_atom_gc
	mov	w11, w0
	cbz	w11, .LBB114_11
// %bb.1:                               // %B11
	ldrb	w8, [x19]
	mov	w9, #17665                      // =0x4501
	mov	w10, #17669                     // =0x4505
	ldur	x12, [x20, #-24]
	str	x19, [sp, #48]                  // 8-byte Folded Spill
	tst	w8, #0x4
	csel	w9, w10, w9, ne
	ldur	x10, [x20, #-8]
	ands	w8, w8, #0x3
	b.eq	.LBB114_4
// %bb.2:                               // %B11
	cmp	w8, #1
	b.ne	.LBB114_5
// %bb.3:                               // %B19
	mov	w8, #18                         // =0x12
	mov	w13, #2048                      // =0x800
	stp	x10, x8, [sp, #16]              // 16-byte Folded Spill
	b	.LBB114_6
.LBB114_4:
	mov	w8, #18                         // =0x12
	str	x10, [sp, #40]                  // 8-byte Folded Spill
	mov	w13, #8706                      // =0x2202
	str	x8, [sp, #24]                   // 8-byte Folded Spill
	mov	w8, #18                         // =0x12
	str	x8, [sp, #16]                   // 8-byte Folded Spill
	b	.LBB114_7
.LBB114_5:                              // %B20
	mov	w13, #4096                      // =0x1000
	mov	w8, #18                         // =0x12
	stp	x8, x10, [sp, #16]              // 16-byte Folded Spill
.LBB114_6:                              // %B16
	mov	w8, #18                         // =0x12
	str	x8, [sp, #40]                   // 8-byte Folded Spill
.LBB114_7:                              // %B16
	ldur	x1, [x20, #-8]
	orr	w3, w9, w13
	mov	x0, x24
	mov	w2, w11
	mov	x4, x12
	str	x20, [x23, #48]
	str	w13, [sp, #36]                  // 4-byte Folded Spill
	mov	x19, x12
	str	x20, [sp, #56]                  // 8-byte Folded Spill
	mov	w20, w11
	str	w9, [sp, #12]                   // 4-byte Folded Spill
	bl	js_method_set_properties_gc
	tbnz	w0, #31, .LBB114_10
// %bb.8:                               // %B5
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	ldr	w9, [sp, #12]                   // 4-byte Folded Reload
	mov	x0, x24
	ldp	x4, x5, [sp, #16]               // 16-byte Folded Reload
	mov	x1, x19
	str	x8, [x23, #48]
	ldr	w8, [sp, #36]                   // 4-byte Folded Reload
	mov	w2, w20
	ldr	x3, [sp, #40]                   // 8-byte Folded Reload
	orr	w6, w9, w8
	bl	JS_DefineProperty_GC
	tbnz	w0, #31, .LBB114_10
// %bb.9:                               // %B7
	ldr	x9, [sp, #48]                   // 8-byte Folded Reload
	ldrb	w8, [x9, #1]
	add	x19, x9, #2
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #64
	br	x1
.LBB114_10:                             // %B2
	ldp	x19, x20, [sp, #48]             // 16-byte Folded Reload
.LBB114_11:                             // %B9
	add	sp, sp, #64
	b	.Lexception_asm_h
.Lfunc_end114:
	.size	.Ldefine_method_computed_0_asm_h, .Lfunc_end114-.Ldefine_method_computed_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_class_0_asm_h
	.type	.Ldefine_class_0_asm_h,@function
.Ldefine_class_0_asm_h:                 // @define_class_0_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #4]
	mov	x0, x24
	mov	x1, x20
	mov	x4, x26
	mov	x5, x23
	str	x20, [x23, #48]
	bl	js_op_define_class
	tbnz	w0, #31, .LBB115_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB115_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end115:
	.size	.Ldefine_class_0_asm_h, .Lfunc_end115-.Ldefine_class_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc_0_asm_h
	.type	.Lget_loc_0_asm_h,@function
.Lget_loc_0_asm_h:                      // @get_loc_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #247
	ldr	x22, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end116:
	.size	.Lget_loc_0_asm_h, .Lfunc_end116-.Lget_loc_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc_0_asm_h
	.type	.Lput_loc_0_asm_h,@function
.Lput_loc_0_asm_h:                      // @put_loc_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end117:
	.size	.Lput_loc_0_asm_h, .Lfunc_end117-.Lput_loc_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc_0_asm_h
	.type	.Lset_loc_0_asm_h,@function
.Lset_loc_0_asm_h:                      // @set_loc_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end118:
	.size	.Lset_loc_0_asm_h, .Lfunc_end118-.Lset_loc_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg_0_asm_h
	.type	.Lget_arg_0_asm_h,@function
.Lget_arg_0_asm_h:                      // @get_arg_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #247
	ldr	x22, [x28, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end119:
	.size	.Lget_arg_0_asm_h, .Lfunc_end119-.Lget_arg_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg_0_asm_h
	.type	.Lput_arg_0_asm_h,@function
.Lput_arg_0_asm_h:                      // @put_arg_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end120:
	.size	.Lput_arg_0_asm_h, .Lfunc_end120-.Lput_arg_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg_0_asm_h
	.type	.Lset_arg_0_asm_h,@function
.Lset_arg_0_asm_h:                      // @set_arg_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end121:
	.size	.Lset_arg_0_asm_h, .Lfunc_end121-.Lset_arg_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref_0_asm_h
	.type	.Lget_var_ref_0_asm_h,@function
.Lget_var_ref_0_asm_h:                  // @get_var_ref_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x8, [x26, x8, lsl #3]
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x22, [x8]
	br	x1
.Lfunc_end122:
	.size	.Lget_var_ref_0_asm_h, .Lfunc_end122-.Lget_var_ref_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_0_asm_h
	.type	.Lput_var_ref_0_asm_h,@function
.Lput_var_ref_0_asm_h:                  // @put_var_ref_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end123:
	.size	.Lput_var_ref_0_asm_h, .Lfunc_end123-.Lput_var_ref_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref_0_asm_h
	.type	.Lset_var_ref_0_asm_h,@function
.Lset_var_ref_0_asm_h:                  // @set_var_ref_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end124:
	.size	.Lset_var_ref_0_asm_h, .Lfunc_end124-.Lset_var_ref_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc_uninitialized_0_asm_h
	.type	.Lset_loc_uninitialized_0_asm_h,@function
.Lset_loc_uninitialized_0_asm_h:        // @set_loc_uninitialized_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	mov	w9, #34                         // =0x22
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end125:
	.size	.Lset_loc_uninitialized_0_asm_h, .Lfunc_end125-.Lset_loc_uninitialized_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc_check_0_asm_h
	.type	.Lget_loc_check_0_asm_h,@function
.Lget_loc_check_0_asm_h:                // @get_loc_check_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	.LBB126_2
// %bb.1:                               // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB126_2:                              // %B3
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end126:
	.size	.Lget_loc_check_0_asm_h, .Lfunc_end126-.Lget_loc_check_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc_check_0_asm_h
	.type	.Lput_loc_check_0_asm_h,@function
.Lput_loc_check_0_asm_h:                // @put_loc_check_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	.LBB127_2
// %bb.1:                               // %B4
	str	x22, [x27, w8, uxtw #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB127_2:                              // %B3
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end127:
	.size	.Lput_loc_check_0_asm_h, .Lfunc_end127-.Lput_loc_check_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc_check_init_0_asm_h
	.type	.Lput_loc_check_init_0_asm_h,@function
.Lput_loc_check_init_0_asm_h:           // @put_loc_check_init_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	.LBB128_2
// %bb.1:                               // %B4
	str	x22, [x27, w8, uxtw #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB128_2:                              // %B3
	b	.LThrowThisReferenceError_asm_h
.Lfunc_end128:
	.size	.Lput_loc_check_init_0_asm_h, .Lfunc_end128-.Lput_loc_check_init_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref_check_0_asm_h
	.type	.Lget_var_ref_check_0_asm_h,@function
.Lget_var_ref_check_0_asm_h:            // @get_var_ref_check_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB129_2
// %bb.1:                               // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB129_2:                              // %B3
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end129:
	.size	.Lget_var_ref_check_0_asm_h, .Lfunc_end129-.Lget_var_ref_check_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_check_0_asm_h
	.type	.Lput_var_ref_check_0_asm_h,@function
.Lput_var_ref_check_0_asm_h:            // @put_var_ref_check_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	.LBB130_2
// %bb.1:                               // %B4
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB130_2:                              // %B3
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end130:
	.size	.Lput_var_ref_check_0_asm_h, .Lfunc_end130-.Lput_var_ref_check_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_check_init_0_asm_h
	.type	.Lput_var_ref_check_init_0_asm_h,@function
.Lput_var_ref_check_init_0_asm_h:       // @put_var_ref_check_init_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	.LBB131_2
// %bb.1:                               // %B4
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB131_2:                              // %B3
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end131:
	.size	.Lput_var_ref_check_init_0_asm_h, .Lfunc_end131-.Lput_var_ref_check_init_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function close_loc_0_asm_h
	.type	.Lclose_loc_0_asm_h,@function
.Lclose_loc_0_asm_h:                    // @close_loc_0_asm_h
// %bb.0:                               // %B0
	ldrh	w2, [x19]
	mov	x0, x24
	mov	x1, x23
	bl	close_lexical_var
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end132:
	.size	.Lclose_loc_0_asm_h, .Lfunc_end132-.Lclose_loc_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_false_0_asm_h
	.type	.Lif_false_0_asm_h,@function
.Lif_false_0_asm_h:                     // @if_false_0_asm_h
// %bb.0:                               // %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	.LBB133_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB133_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB133_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB133_6
	b	.LBB133_7
.LBB133_4:                              // %B23
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x9
	b.eq	.LBB133_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB133_7
.LBB133_6:                              // %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB133_7:                              // %B9
	mov	x9, #-281474976710656           // =0xffff000000000000
	cmp	x22, x9
	b.hs	.LBB133_13
// %bb.8:                               // %B11
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x9
	b.lo	.LBB133_10
.LBB133_9:                              // %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB133_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB133_13
// %bb.11:                              // %B17
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB133_6
	b.vs	.LBB133_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB133_9
	b	.LBB133_6
.LBB133_13:                             // %B15
	mov	x20, x8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.Lfunc_end133:
	.size	.Lif_false_0_asm_h, .Lfunc_end133-.Lif_false_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_true_0_asm_h
	.type	.Lif_true_0_asm_h,@function
.Lif_true_0_asm_h:                      // @if_true_0_asm_h
// %bb.0:                               // %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	.LBB134_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB134_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB134_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB134_6
	b	.LBB134_7
.LBB134_4:                              // %B23
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x9
	b.eq	.LBB134_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB134_7
.LBB134_6:                              // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB134_7:                              // %B9
	mov	x9, #-281474976710656           // =0xffff000000000000
	cmp	x22, x9
	b.hs	.LBB134_13
// %bb.8:                               // %B11
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x9
	b.lo	.LBB134_10
.LBB134_9:                              // %B19
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB134_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB134_13
// %bb.11:                              // %B17
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB134_6
	b.vs	.LBB134_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB134_9
	b	.LBB134_6
.LBB134_13:                             // %B15
	mov	x20, x8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.Lfunc_end134:
	.size	.Lif_true_0_asm_h, .Lfunc_end134-.Lif_true_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function goto_0_asm_h
	.type	.Lgoto_0_asm_h,@function
.Lgoto_0_asm_h:                         // @goto_0_asm_h
// %bb.0:                               // %B0
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end135:
	.size	.Lgoto_0_asm_h, .Lfunc_end135-.Lgoto_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function catch_0_asm_h
	.type	.Lcatch_0_asm_h,@function
.Lcatch_0_asm_h:                        // @catch_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #4]
	ldr	w10, [x19]
	ldr	x8, [x8, #32]
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	mov	w9, #66                         // =0x42
	ldr	x8, [x8, #8]
	sub	x8, x19, x8
	add	x19, x19, #5
	add	x8, x8, x10
	orr	x22, x9, x8, lsl #16
	br	x1
.Lfunc_end136:
	.size	.Lcatch_0_asm_h, .Lfunc_end136-.Lcatch_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gosub_0_asm_h
	.type	.Lgosub_0_asm_h,@function
.Lgosub_0_asm_h:                        // @gosub_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #8]
	ldrsw	x9, [x19]
	ldr	x10, [x8, #32]
	add	x8, x19, x9
	ldrb	w9, [x8], #1
	ldr	w10, [x10, #8]
	add	w9, w9, #247
	sub	w10, w19, w10
	ldr	x1, [x25, w9, uxtw #3]
	mov	x19, x8
	add	w9, w10, #4
	orr	x22, x9, #0xfffe000000000000
	br	x1
.Lfunc_end137:
	.size	.Lgosub_0_asm_h, .Lfunc_end137-.Lgosub_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function ret_0_asm_h
	.type	.Lret_0_asm_h,@function
.Lret_0_asm_h:                          // @ret_0_asm_h
// %bb.0:                               // %B6
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB138_3
// %bb.1:                               // %B1
	ldr	x8, [x23, #8]
	ldr	x8, [x8, #32]
	ldr	w9, [x8, #16]
	cmp	w22, w9
	b.ge	.LBB138_3
// %bb.2:                               // %B5
	ldr	x8, [x8, #8]
	sub	x20, x20, #8
	add	x19, x8, w22, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB138_3:                              // %B3
	adrp	x1, .L__unnamed_8
	add	x1, x1, :lo12:.L__unnamed_8
	mov	x0, x24
	str	x20, [x23, #48]
	bl	LEPUS_ThrowInternalError
	b	.Lexception_asm_h
.Lfunc_end138:
	.size	.Lret_0_asm_h, .Lfunc_end138-.Lret_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_object_0_asm_h
	.type	.Lto_object_0_asm_h,@function
.Lto_object_0_asm_h:                    // @to_object_0_asm_h
// %bb.0:                               // %B6
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB139_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB139_2:                              // %B1
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #48]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB139_4
// %bb.3:                               // %B3
	mov	x22, x0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB139_4:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end139:
	.size	.Lto_object_0_asm_h, .Lfunc_end139-.Lto_object_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_propkey_0_asm_h
	.type	.Lto_propkey_0_asm_h,@function
.Lto_propkey_0_asm_h:                   // @to_propkey_0_asm_h
// %bb.0:                               // %B15
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	.LBB140_4
// %bb.1:                               // %B15
	mov	x9, #1                          // =0x1
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	.LBB140_4
// %bb.2:                               // %B15
	cmp	x8, x9
	b.eq	.LBB140_4
// %bb.3:                               // %B15
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB140_5
.LBB140_4:                              // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB140_5:                              // %B12
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #48]
	bl	JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	.LBB140_7
// %bb.6:                               // %B14
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB140_7:                              // %B13
	b	.Lexception_asm_h
.Lfunc_end140:
	.size	.Lto_propkey_0_asm_h, .Lfunc_end140-.Lto_propkey_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_propkey2_0_asm_h
	.type	.Lto_propkey2_0_asm_h,@function
.Lto_propkey2_0_asm_h:                  // @to_propkey2_0_asm_h
// %bb.0:                               // %B18
	ldp	x22, x21, [x20, #-16]
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	.LBB141_3
// %bb.1:                               // %B19
	adrp	x1, .L__unnamed_9
	add	x1, x1, :lo12:.L__unnamed_9
	mov	x0, x24
	str	x20, [x23, #48]
	bl	LEPUS_ThrowTypeError
.LBB141_2:                              // %B16
	b	.Lexception_asm_h
.LBB141_3:                              // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB141_7
// %bb.4:                               // %B2
	mov	x9, #1                          // =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	.LBB141_7
// %bb.5:                               // %B2
	cmp	x8, x9
	b.eq	.LBB141_7
// %bb.6:                               // %B2
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB141_8
.LBB141_7:                              // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB141_8:                              // %B15
	mov	x0, x24
	mov	x1, x21
	str	x20, [x23, #48]
	bl	JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	.LBB141_2
// %bb.9:                               // %B17
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end141:
	.size	.Lto_propkey2_0_asm_h, .Lfunc_end141-.Lto_propkey2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_get_var_0_asm_h
	.type	.Lwith_get_var_0_asm_h,@function
.Lwith_get_var_0_asm_h:                 // @with_get_var_0_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #113                        // =0x71
	str	x20, [x23, #48]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB142_4
// %bb.1:                               // %B4
	cbz	w0, .LBB142_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB142_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB142_4:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end142:
	.size	.Lwith_get_var_0_asm_h, .Lfunc_end142-.Lwith_get_var_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_put_var_0_asm_h
	.type	.Lwith_put_var_0_asm_h,@function
.Lwith_put_var_0_asm_h:                 // @with_put_var_0_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #114                        // =0x72
	str	x20, [x23, #48]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB143_4
// %bb.1:                               // %B4
	cbz	w0, .LBB143_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	sub	x20, x20, #16
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB143_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB143_4:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end143:
	.size	.Lwith_put_var_0_asm_h, .Lfunc_end143-.Lwith_put_var_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_delete_var_0_asm_h
	.type	.Lwith_delete_var_0_asm_h,@function
.Lwith_delete_var_0_asm_h:              // @with_delete_var_0_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #115                        // =0x73
	str	x20, [x23, #48]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB144_4
// %bb.1:                               // %B4
	cbz	w0, .LBB144_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB144_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB144_4:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end144:
	.size	.Lwith_delete_var_0_asm_h, .Lfunc_end144-.Lwith_delete_var_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_make_ref_0_asm_h
	.type	.Lwith_make_ref_0_asm_h,@function
.Lwith_make_ref_0_asm_h:                // @with_make_ref_0_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #116                        // =0x74
	str	x20, [x23, #48]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB145_4
// %bb.1:                               // %B4
	cbz	w0, .LBB145_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB145_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB145_4:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end145:
	.size	.Lwith_make_ref_0_asm_h, .Lfunc_end145-.Lwith_make_ref_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_get_ref_0_asm_h
	.type	.Lwith_get_ref_0_asm_h,@function
.Lwith_get_ref_0_asm_h:                 // @with_get_ref_0_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #117                        // =0x75
	str	x20, [x23, #48]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB146_4
// %bb.1:                               // %B4
	cbz	w0, .LBB146_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB146_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB146_4:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end146:
	.size	.Lwith_get_ref_0_asm_h, .Lfunc_end146-.Lwith_get_ref_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_get_ref_undef_0_asm_h
	.type	.Lwith_get_ref_undef_0_asm_h,@function
.Lwith_get_ref_undef_0_asm_h:           // @with_get_ref_undef_0_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #118                        // =0x76
	str	x20, [x23, #48]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB147_4
// %bb.1:                               // %B4
	cbz	w0, .LBB147_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB147_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB147_4:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end147:
	.size	.Lwith_get_ref_undef_0_asm_h, .Lfunc_end147-.Lwith_get_ref_undef_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_loc_ref_0_asm_h
	.type	.Lmake_loc_ref_0_asm_h,@function
.Lmake_loc_ref_0_asm_h:                 // @make_loc_ref_0_asm_h
// %bb.0:                               // %B16
	sub	sp, sp, #16
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x23, #48]
	bl	JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	.LBB148_6
// %bb.1:                               // %B1
	mov	w8, #18                         // =0x12
	mov	x1, x23
	mov	w3, wzr
	stp	x0, x8, [x20], #16
	mov	x0, x24
	ldrh	w2, [x19, #4]
	str	x20, [x23, #48]
	bl	get_var_ref_gc
	mov	x8, x0
	cbz	x8, .LBB148_6
// %bb.2:                               // %B6
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #34                         // =0x22
	str	x20, [x23, #48]
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	bl	add_property_gc
	ldr	x9, [sp, #8]                    // 8-byte Folded Reload
	cbz	x0, .LBB148_6
// %bb.3:                               // %B9
	mov	x8, #2                          // =0x2
	movk	x8, #65533, lsl #48
	orr	x8, x9, x8
	str	x8, [x0]
	ldrb	w9, [x24, #376]
	cbnz	w9, .LBB148_7
.LBB148_4:                              // %B13
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB148_6
// %bb.5:                               // %B15
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB148_6:                              // %B14
	add	sp, sp, #16
	b	.Lexception_asm_h
.LBB148_7:                              // %B12
	mov	x0, x8
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	b	.LBB148_4
.Lfunc_end148:
	.size	.Lmake_loc_ref_0_asm_h, .Lfunc_end148-.Lmake_loc_ref_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_arg_ref_0_asm_h
	.type	.Lmake_arg_ref_0_asm_h,@function
.Lmake_arg_ref_0_asm_h:                 // @make_arg_ref_0_asm_h
// %bb.0:                               // %B16
	sub	sp, sp, #16
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x23, #48]
	bl	JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	.LBB149_6
// %bb.1:                               // %B1
	mov	w8, #18                         // =0x12
	mov	x1, x23
	mov	w3, #1                          // =0x1
	stp	x0, x8, [x20], #16
	mov	x0, x24
	ldrh	w2, [x19, #4]
	str	x20, [x23, #48]
	bl	get_var_ref_gc
	mov	x8, x0
	cbz	x8, .LBB149_6
// %bb.2:                               // %B6
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #34                         // =0x22
	str	x20, [x23, #48]
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	bl	add_property_gc
	ldr	x9, [sp, #8]                    // 8-byte Folded Reload
	cbz	x0, .LBB149_6
// %bb.3:                               // %B9
	mov	x8, #2                          // =0x2
	movk	x8, #65533, lsl #48
	orr	x8, x9, x8
	str	x8, [x0]
	ldrb	w9, [x24, #376]
	cbnz	w9, .LBB149_7
.LBB149_4:                              // %B13
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB149_6
// %bb.5:                               // %B15
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB149_6:                              // %B14
	add	sp, sp, #16
	b	.Lexception_asm_h
.LBB149_7:                              // %B12
	mov	x0, x8
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	b	.LBB149_4
.Lfunc_end149:
	.size	.Lmake_arg_ref_0_asm_h, .Lfunc_end149-.Lmake_arg_ref_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_var_ref_ref_0_asm_h
	.type	.Lmake_var_ref_ref_0_asm_h,@function
.Lmake_var_ref_ref_0_asm_h:             // @make_var_ref_ref_0_asm_h
// %bb.0:                               // %B12
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x23, #48]
	bl	JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	.LBB150_5
// %bb.1:                               // %B1
	mov	x1, x0
	mov	w8, #18                         // =0x12
	mov	x0, x24
	stp	x1, x8, [x20], #16
	mov	w3, #34                         // =0x22
	ldr	w2, [x19]
	str	x20, [x23, #48]
	bl	add_property_gc
	cbz	x0, .LBB150_5
// %bb.2:                               // %B4
	ldrh	w8, [x19, #4]
	mov	x9, #2                          // =0x2
	movk	x9, #65533, lsl #48
	ldr	x8, [x26, x8, lsl #3]
	orr	x8, x8, x9
	str	x8, [x0]
	ldrb	w9, [x24, #376]
	cbnz	w9, .LBB150_6
.LBB150_3:                              // %B9
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB150_5
// %bb.4:                               // %B11
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB150_5:                              // %B10
	b	.Lexception_asm_h
.LBB150_6:                              // %B7
	mov	x0, x8
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	b	.LBB150_3
.Lfunc_end150:
	.size	.Lmake_var_ref_ref_0_asm_h, .Lfunc_end150-.Lmake_var_ref_ref_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_var_ref_0_asm_h
	.type	.Lmake_var_ref_0_asm_h,@function
.Lmake_var_ref_0_asm_h:                 // @make_var_ref_0_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x20
	str	x20, [x23, #48]
	bl	JS_GetGlobalVarRef_GC
	tbnz	w0, #31, .LBB151_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB151_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end151:
	.size	.Lmake_var_ref_0_asm_h, .Lfunc_end151-.Lmake_var_ref_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_in_start_0_asm_h
	.type	.Lfor_in_start_0_asm_h,@function
.Lfor_in_start_0_asm_h:                 // @for_in_start_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	bl	prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	.LBB152_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB152_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end152:
	.size	.Lfor_in_start_0_asm_h, .Lfunc_end152-.Lfor_in_start_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_of_start_0_asm_h
	.type	.Lfor_of_start_0_asm_h,@function
.Lfor_of_start_0_asm_h:                 // @for_of_start_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	js_for_of_start_gc
	tbnz	w0, #31, .LBB153_2
// %bb.1:                               // %B3
	mov	w8, #66                         // =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB153_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end153:
	.size	.Lfor_of_start_0_asm_h, .Lfunc_end153-.Lfor_of_start_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_await_of_start_0_asm_h
	.type	.Lfor_await_of_start_0_asm_h,@function
.Lfor_await_of_start_0_asm_h:           // @for_await_of_start_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	mov	w2, #1                          // =0x1
	str	x20, [x23, #48]
	bl	js_for_of_start_gc
	tbnz	w0, #31, .LBB154_2
// %bb.1:                               // %B3
	mov	w8, #66                         // =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB154_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end154:
	.size	.Lfor_await_of_start_0_asm_h, .Lfunc_end154-.Lfor_await_of_start_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_in_next_0_asm_h
	.type	.Lfor_in_next_0_asm_h,@function
.Lfor_in_next_0_asm_h:                  // @for_in_next_0_asm_h
// %bb.0:                               // %B65
	ldur	x8, [x20, #-8]
	mov	x11, #2                         // =0x2
	movk	x11, #65535, lsl #48
	tst	x8, x11
	b.ne	.LBB155_4
// %bb.1:                               // %B62
	ldrh	w9, [x8, #6]
	cmp	w9, #17
	b.ne	.LBB155_4
// %bb.2:                               // %B1
	ldr	x8, [x8, #32]
	cbz	x8, .LBB155_4
// %bb.3:                               // %B9
	ldp	w9, w10, [x8, #8]
	cmp	w9, w10
	b.lo	.LBB155_6
.LBB155_4:                              // %B4
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	js_for_in_next_gc
	tbnz	w0, #31, .LBB155_27
// %bb.5:                               // %B6
	ldrb	w8, [x19], #1
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB155_6:                              // %B11
	ldr	x10, [x8]
	tst	x10, x11
	b.ne	.LBB155_4
// %bb.7:                               // %B13
	ldrb	w11, [x8, #17]
	cbnz	w11, .LBB155_21
// %bb.8:                               // %B37
	ldrb	w11, [x8, #16]
	cbnz	w11, .LBB155_4
// %bb.9:                               // %B40
	ldr	x11, [x8, #24]
	cbz	x11, .LBB155_4
// %bb.10:                              // %B57
	lsl	w12, w9, #3
	add	x11, x11, x12
	ldr	w12, [x11]
	cbz	w12, .LBB155_15
// %bb.11:                              // %B59
	ldr	x12, [x10, #8]
	ldr	w1, [x11, #4]
	ldr	w13, [x12, #12]
	add	x14, x12, #64
	lsl	w11, w13, #2
	and	w12, w1, w13
	ldr	w12, [x14, w12, sxtw #2]
	add	w11, w11, #4
	add	x11, x14, x11
	cbz	w12, .LBB155_14
.LBB155_12:                             // %B52
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w12, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w1
	b.eq	.LBB155_16
// %bb.13:                              // %B54
                                        //   in Loop: Header=BB155_12 Depth=1
	and	w12, w12, #0x3ffffff
	cbnz	w12, .LBB155_12
.LBB155_14:                             // %B46
	ldr	w10, [x10, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB155_4
.LBB155_15:                             // %B49
	add	w9, w9, #1
	str	w9, [x8, #8]
	b	.LBB155_4
.LBB155_16:                             // %B43
	lsr	w10, w12, #26
	tst	w10, #0x30
	b.ne	.LBB155_4
// %bb.17:                              // %B44
	add	w9, w9, #1
	str	w9, [x8, #8]
	tbnz	w1, #31, .LBB155_25
.LBB155_18:                             // %B18
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, sxtw #3]
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, .LBB155_24
// %bb.19:                              // %B28
	ldr	w9, [x8, #8]
	asr	w9, w9, #30
	cmp	w9, #1
	b.ne	.LBB155_25
.LBB155_20:                             // %B26
	mov	x9, #2                          // =0x2
	movk	x9, #1, lsl #48
	orr	x8, x8, x9
	mov	w9, #6                          // =0x6
	stp	x8, x9, [x20], #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB155_21:                             // %B33
	ldr	w11, [x10, #4]
	ubfx	w11, w11, #11, #1
	cmp	w11, #1
	b.ne	.LBB155_4
// %bb.22:                              // %B15
	ldr	w10, [x10, #48]
	cmp	w9, w10
	b.hs	.LBB155_4
// %bb.23:                              // %B16
	add	w10, w9, #1
	orr	w1, w9, #0x80000000
	str	w10, [x8, #8]
	tbz	w1, #31, .LBB155_18
	b	.LBB155_25
.LBB155_24:                             // %B19
	ldr	x9, [x8, #8]
	ldr	w9, [x9]
	asr	w9, w9, #30
	cmp	w9, #1
	b.eq	.LBB155_20
.LBB155_25:                             // %B23
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB155_27
// %bb.26:                              // %B25
	mov	w8, #6                          // =0x6
	stp	x0, x8, [x20], #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB155_27:                             // %B5
	b	.Lexception_asm_h
.Lfunc_end155:
	.size	.Lfor_in_next_0_asm_h, .Lfunc_end155-.Lfor_in_next_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_of_next_0_asm_h
	.type	.Lfor_of_next_0_asm_h,@function
.Lfor_of_next_0_asm_h:                  // @for_of_next_0_asm_h
// %bb.0:                               // %B1
	ldrb	w9, [x19]
	mov	w8, #-3                         // =0xfffffffd
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	sub	w2, w8, w9
	bl	js_for_of_next_gc
	tbnz	w0, #31, .LBB156_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB156_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end156:
	.size	.Lfor_of_next_0_asm_h, .Lfunc_end156-.Lfor_of_next_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_await_of_next_0_asm_h
	.type	.Lfor_await_of_next_0_asm_h,@function
.Lfor_await_of_next_0_asm_h:            // @for_await_of_next_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	js_for_await_of_next_gc
	tbnz	w0, #31, .LBB157_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB157_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end157:
	.size	.Lfor_await_of_next_0_asm_h, .Lfunc_end157-.Lfor_await_of_next_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_get_value_done_0_asm_h
	.type	.Literator_get_value_done_0_asm_h,@function
.Literator_get_value_done_0_asm_h:      // @iterator_get_value_done_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	js_iterator_get_value_done_gc
	tbnz	w0, #31, .LBB158_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB158_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end158:
	.size	.Literator_get_value_done_0_asm_h, .Lfunc_end158-.Literator_get_value_done_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_close_0_asm_h
	.type	.Literator_close_0_asm_h,@function
.Literator_close_0_asm_h:               // @iterator_close_0_asm_h
// %bb.0:                               // %B6
	ldur	x1, [x20, #-24]
	sub	x20, x20, #16
	cmp	x1, #18
	b.eq	.LBB159_2
// %bb.1:                               // %B1
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	JS_IteratorClose
	tbnz	w0, #31, .LBB159_3
.LBB159_2:                              // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB159_3:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end159:
	.size	.Literator_close_0_asm_h, .Lfunc_end159-.Literator_close_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_close_return_0_asm_h
	.type	.Literator_close_return_0_asm_h,@function
.Literator_close_return_0_asm_h:        // @iterator_close_return_0_asm_h
// %bb.0:                               // %B0
	ldr	x9, [x23, #8]
	ldr	x8, [x20, #-8]!
	mov	w10, #247                       // =0xf7
	ldr	x9, [x9, #32]
	ldrh	w9, [x9, #42]
	add	x9, x27, x9, lsl #3
	b	.LBB160_2
.LBB160_1:                              // %B10
                                        //   in Loop: Header=BB160_2 Depth=1
	sub	x20, x20, #8
.LBB160_2:                              // %B2
                                        // =>This Inner Loop Header: Depth=1
	cmp	x20, x9
	b.le	.LBB160_5
// %bb.3:                               // %B4
                                        //   in Loop: Header=BB160_2 Depth=1
	ldur	x11, [x20, #-8]
	tst	x11, #0xffff000000000000
	b.ne	.LBB160_1
// %bb.4:                               // %B4
                                        //   in Loop: Header=BB160_2 Depth=1
	and	x11, x11, x10
	cmp	x11, #66
	b.ne	.LBB160_1
.LBB160_5:                              // %B7
	add	x9, x9, #24
	cmp	x20, x9
	add	x20, x20, #8
	b.lt	.LBB160_7
// %bb.6:                               // %B9
	ldur	x9, [x20, #-16]
	ldur	q0, [x20, #-32]
	stur	x8, [x20, #-32]
	stur	x9, [x20, #-8]
	stur	q0, [x20, #-24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB160_7:                              // %B8
	adrp	x1, .L__unnamed_10
	add	x1, x1, :lo12:.L__unnamed_10
	mov	x0, x24
	str	x20, [x23, #48]
	bl	LEPUS_ThrowInternalError
	b	.Lexception_asm_h
.Lfunc_end160:
	.size	.Literator_close_return_0_asm_h, .Lfunc_end160-.Literator_close_return_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_iterator_close_0_asm_h
	.type	.Lasync_iterator_close_0_asm_h,@function
.Lasync_iterator_close_0_asm_h:         // @async_iterator_close_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	prim_js_async_iterator_close_gc
	tbnz	w0, #31, .LBB161_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB161_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end161:
	.size	.Lasync_iterator_close_0_asm_h, .Lfunc_end161-.Lasync_iterator_close_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_iterator_next_0_asm_h
	.type	.Lasync_iterator_next_0_asm_h,@function
.Lasync_iterator_next_0_asm_h:          // @async_iterator_next_0_asm_h
// %bb.0:                               // %B1
	ldp	x2, x1, [x20, #-32]
	sub	x4, x20, #8
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x23, #48]
	bl	JS_Call_GC
	cmp	x0, #130
	b.eq	.LBB162_2
// %bb.1:                               // %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB162_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end162:
	.size	.Lasync_iterator_next_0_asm_h, .Lfunc_end162-.Lasync_iterator_next_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_iterator_get_0_asm_h
	.type	.Lasync_iterator_get_0_asm_h,@function
.Lasync_iterator_get_0_asm_h:           // @async_iterator_get_0_asm_h
// %bb.0:                               // %B1
	ldrb	w2, [x19]
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	prim_js_async_iterator_get_gc
	tbnz	w0, #31, .LBB163_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB163_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end163:
	.size	.Lasync_iterator_get_0_asm_h, .Lfunc_end163-.Lasync_iterator_get_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function initial_yield_0_asm_h
	.type	.Linitial_yield_0_asm_h,@function
.Linitial_yield_0_asm_h:                // @initial_yield_0_asm_h
// %bb.0:                               // %B0
	str	x19, [x23, #32]
	mov	w0, #18                         // =0x12
	str	x20, [x23, #48]
	b	.Lcommon_return_direct_asm_h
.Lfunc_end164:
	.size	.Linitial_yield_0_asm_h, .Lfunc_end164-.Linitial_yield_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function yield_0_asm_h
	.type	.Lyield_0_asm_h,@function
.Lyield_0_asm_h:                        // @yield_0_asm_h
// %bb.0:                               // %B0
	str	x19, [x23, #32]
	mov	x0, #-562949953421311           // =0xfffe000000000001
	str	x20, [x23, #48]
	b	.Lcommon_return_direct_asm_h
.Lfunc_end165:
	.size	.Lyield_0_asm_h, .Lfunc_end165-.Lyield_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function yield_star_0_asm_h
	.type	.Lyield_star_0_asm_h,@function
.Lyield_star_0_asm_h:                   // @yield_star_0_asm_h
// %bb.0:                               // %B0
	mov	x0, #2                          // =0x2
	str	x19, [x23, #32]
	str	x20, [x23, #48]
	movk	x0, #65534, lsl #48
	b	.Lcommon_return_direct_asm_h
.Lfunc_end166:
	.size	.Lyield_star_0_asm_h, .Lfunc_end166-.Lyield_star_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_yield_star_0_asm_h
	.type	.Lasync_yield_star_0_asm_h,@function
.Lasync_yield_star_0_asm_h:             // @async_yield_star_0_asm_h
// %bb.0:                               // %B0
	mov	x0, #2                          // =0x2
	str	x19, [x23, #32]
	str	x20, [x23, #48]
	movk	x0, #65534, lsl #48
	b	.Lcommon_return_direct_asm_h
.Lfunc_end167:
	.size	.Lasync_yield_star_0_asm_h, .Lfunc_end167-.Lasync_yield_star_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function await_0_asm_h
	.type	.Lawait_0_asm_h,@function
.Lawait_0_asm_h:                        // @await_0_asm_h
// %bb.0:                               // %B0
	str	x19, [x23, #32]
	mov	x0, #-562949953421312           // =0xfffe000000000000
	str	x20, [x23, #48]
	b	.Lcommon_return_direct_asm_h
.Lfunc_end168:
	.size	.Lawait_0_asm_h, .Lfunc_end168-.Lawait_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function neg_0_asm_h
	.type	.Lneg_0_asm_h,@function
.Lneg_0_asm_h:                          // @neg_0_asm_h
// %bb.0:                               // %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB169_3
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB169_6
// %bb.2:                               // %B13
	orr	w8, w22, #0x80000000
	mov	w9, #-2147483648                // =0x80000000
	cmp	w8, w9
	b.ne	.LBB169_5
.LBB169_3:                              // %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        // =0x8c
	str	x20, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB169_8
// %bb.4:                               // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB169_5:                              // %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB169_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB169_3
// %bb.7:                               // %B7
	movi	d0, #0000000000000000
	add	x8, x22, x8
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	fsub	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
.LBB169_8:                              // %B17
	b	.Lexception_asm_h
.Lfunc_end169:
	.size	.Lneg_0_asm_h, .Lfunc_end169-.Lneg_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function plus_0_asm_h
	.type	.Lplus_0_asm_h,@function
.Lplus_0_asm_h:                         // @plus_0_asm_h
// %bb.0:                               // %B13
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB170_4
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB170_3
.LBB170_2:                              // %B7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB170_3:                              // %B3
	tst	x22, #0xfffe000000000000
	b.ne	.LBB170_2
.LBB170_4:                              // %B10
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        // =0x8d
	str	x20, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB170_6
// %bb.5:                               // %B12
	mov	x22, x0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB170_6:                              // %B11
	b	.Lexception_asm_h
.Lfunc_end170:
	.size	.Lplus_0_asm_h, .Lfunc_end170-.Lplus_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dec_0_asm_h
	.type	.Ldec_0_asm_h,@function
.Ldec_0_asm_h:                          // @dec_0_asm_h
// %bb.0:                               // %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB171_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB171_4
// %bb.2:                               // %B13
	subs	w8, w22, #1
	b.vs	.LBB171_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB171_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB171_6
// %bb.5:                               // %B7
	add	x8, x22, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
.LBB171_6:                              // %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        // =0x8e
	str	x20, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB171_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB171_8:                              // %B17
	b	.Lexception_asm_h
.Lfunc_end171:
	.size	.Ldec_0_asm_h, .Lfunc_end171-.Ldec_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_0_asm_h
	.type	.Linc_0_asm_h,@function
.Linc_0_asm_h:                          // @inc_0_asm_h
// %bb.0:                               // %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB172_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB172_4
// %bb.2:                               // %B13
	adds	w8, w22, #1
	b.vs	.LBB172_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB172_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB172_6
// %bb.5:                               // %B7
	add	x8, x22, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
.LBB172_6:                              // %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        // =0x8f
	str	x20, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB172_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB172_8:                              // %B17
	b	.Lexception_asm_h
.Lfunc_end172:
	.size	.Linc_0_asm_h, .Lfunc_end172-.Linc_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function post_dec_0_asm_h
	.type	.Lpost_dec_0_asm_h,@function
.Lpost_dec_0_asm_h:                     // @post_dec_0_asm_h
// %bb.0:                               // %B16
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB173_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB173_4
// %bb.2:                               // %B13
	subs	w8, w22, #1
	b.vs	.LBB173_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB173_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB173_6
// %bb.5:                               // %B8
	add	x8, x22, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #494
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
.LBB173_6:                              // %B5
	mov	w0, #144                        // =0x90
	b	.LSlowJSPostInc_asm_h
.Lfunc_end173:
	.size	.Lpost_dec_0_asm_h, .Lfunc_end173-.Lpost_dec_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function post_inc_0_asm_h
	.type	.Lpost_inc_0_asm_h,@function
.Lpost_inc_0_asm_h:                     // @post_inc_0_asm_h
// %bb.0:                               // %B16
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB174_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB174_4
// %bb.2:                               // %B13
	adds	w8, w22, #1
	b.vs	.LBB174_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB174_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB174_6
// %bb.5:                               // %B8
	add	x8, x22, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #494
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
.LBB174_6:                              // %B5
	mov	w0, #145                        // =0x91
	b	.LSlowJSPostInc_asm_h
.Lfunc_end174:
	.size	.Lpost_inc_0_asm_h, .Lfunc_end174-.Lpost_inc_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dec_loc_0_asm_h
	.type	.Ldec_loc_0_asm_h,@function
.Ldec_loc_0_asm_h:                      // @dec_loc_0_asm_h
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	.LBB175_6
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB175_4
// %bb.2:                               // %B13
	subs	w9, w1, #1
	b.vs	.LBB175_6
// %bb.3:                               // %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB175_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB175_6
// %bb.5:                               // %B8
	add	x9, x1, x9
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB175_6:                              // %B16
	mov	x0, x24
	mov	w2, #142                        // =0x8e
	str	x20, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB175_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB175_8:                              // %B17
	b	.Lexception_asm_h
.Lfunc_end175:
	.size	.Ldec_loc_0_asm_h, .Lfunc_end175-.Ldec_loc_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_loc_0_asm_h
	.type	.Linc_loc_0_asm_h,@function
.Linc_loc_0_asm_h:                      // @inc_loc_0_asm_h
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	.LBB176_6
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB176_4
// %bb.2:                               // %B13
	adds	w9, w1, #1
	b.vs	.LBB176_6
// %bb.3:                               // %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB176_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB176_6
// %bb.5:                               // %B8
	add	x9, x1, x9
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB176_6:                              // %B16
	mov	x0, x24
	mov	w2, #143                        // =0x8f
	str	x20, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB176_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB176_8:                              // %B17
	b	.Lexception_asm_h
.Lfunc_end176:
	.size	.Linc_loc_0_asm_h, .Lfunc_end176-.Linc_loc_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_loc_0_asm_h
	.type	.Ladd_loc_0_asm_h,@function
.Ladd_loc_0_asm_h:                      // @add_loc_0_asm_h
// %bb.0:                               // %B46
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldur	x22, [x20, #-8]
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	ccmp	x22, x9, #2, ls
	b.hi	.LBB177_15
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB177_5
// %bb.2:                               // %B26
	cmp	x22, x9
	b.lo	.LBB177_8
// %bb.3:                               // %B36
	adds	w9, w1, w22
	sub	x20, x20, #8
	b.vs	.LBB177_12
// %bb.4:                               // %B42
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB177_5:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB177_15
// %bb.6:                               // %B11
	cmp	x22, x9
	b.lo	.LBB177_13
// %bb.7:                               // %B21
	scvtf	d0, w22
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	.LBB177_11
.LBB177_8:                              // %B28
	tst	x22, #0xfffe000000000000
	b.eq	.LBB177_15
// %bb.9:                               // %B31
	scvtf	d0, w1
	add	x9, x22, x9
.LBB177_10:                             // %B31
	fmov	d1, x9
	fadd	d0, d0, d1
.LBB177_11:                             // %B31
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB177_12:                             // %B38
	scvtf	d0, w1
	scvtf	d1, w22
	mov	x10, #562949953421312           // =0x2000000000000
	fadd	d0, d0, d1
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB177_13:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB177_15
// %bb.14:                              // %B16
	add	x10, x1, x9
	add	x9, x22, x9
	fmov	d0, x10
	b	.LBB177_10
.LBB177_15:                             // %B7
	and	x8, x22, #0xffff000000000003
	mov	x9, #-281474976710653           // =0xffff000000000003
	mov	x10, #2                         // =0x2
	cmp	x8, x9
	movk	x10, #1, lsl #48
	and	x11, x1, #0xffff000000000003
	ccmp	x8, x10, #4, ne
	cset	w8, eq
	cmp	x11, x10
	ccmp	x11, x9, #4, ne
	ccmp	w8, #0, #4, eq
	b.ne	.LBB177_18
// %bb.16:                              // %B43
	mov	x0, x24
	mov	x2, x22
	str	x20, [x23, #48]
	bl	prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	.LBB177_19
// %bb.17:                              // %B45
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB177_18:                             // %B8
	mov	w0, #1                          // =0x1
	b	.LFastJSConcatString_asm_h
.LBB177_19:                             // %B44
	b	.Lexception_asm_h
.Lfunc_end177:
	.size	.Ladd_loc_0_asm_h, .Lfunc_end177-.Ladd_loc_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function not_0_asm_h
	.type	.Lnot_0_asm_h,@function
.Lnot_0_asm_h:                          // @not_0_asm_h
// %bb.0:                               // %B2
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB178_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB178_2:                              // %B4
	mov	x0, x22
	b	.LSlowJSNot_asm_h
.Lfunc_end178:
	.size	.Lnot_0_asm_h, .Lfunc_end178-.Lnot_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lnot_0_asm_h
	.type	.Llnot_0_asm_h,@function
.Llnot_0_asm_h:                         // @lnot_0_asm_h
// %bb.0:                               // %B14
	ldur	x22, [x20, #-8]
	cmp	x22, #5
	b.le	.LBB179_4
// %bb.1:                               // %B14
	cmp	x22, #6
	b.eq	.LBB179_6
// %bb.2:                               // %B14
	cmp	x22, #7
	b.eq	.LBB179_8
// %bb.3:                               // %B14
	cmp	x22, #18
	b.eq	.LBB179_6
	b	.LBB179_7
.LBB179_4:                              // %B14
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB179_6
// %bb.5:                               // %B14
	cmp	x22, #2
	b.ne	.LBB179_7
.LBB179_6:                              // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB179_7:                              // %B10
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB179_9
.LBB179_8:                              // %B12
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB179_9:                              // %B13
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.Lfunc_end179:
	.size	.Llnot_0_asm_h, .Lfunc_end179-.Llnot_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function typeof_0_asm_h
	.type	.Ltypeof_0_asm_h,@function
.Ltypeof_0_asm_h:                       // @typeof_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	mov	x1, x22
	bl	js_operator_typeof_gc
	mov	w1, w0
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x20, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB180_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB180_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end180:
	.size	.Ltypeof_0_asm_h, .Lfunc_end180-.Ltypeof_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function delete_0_asm_h
	.type	.Ldelete_0_asm_h,@function
.Ldelete_0_asm_h:                       // @delete_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	.LBB181_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB181_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end181:
	.size	.Ldelete_0_asm_h, .Lfunc_end181-.Ldelete_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function delete_var_0_asm_h
	.type	.Ldelete_var_0_asm_h,@function
.Ldelete_var_0_asm_h:                   // @delete_var_0_asm_h
// %bb.0:                               // %B1
	ldr	x1, [x24, #208]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, wzr
	str	x20, [x23, #48]
	bl	JS_DeleteProperty_GC
	tbnz	w0, #31, .LBB182_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB182_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end182:
	.size	.Ldelete_var_0_asm_h, .Lfunc_end182-.Ldelete_var_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function mul_0_asm_h
	.type	.Lmul_0_asm_h,@function
.Lmul_0_asm_h:                          // @mul_0_asm_h
// %bb.0:                               // %B51
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB183_19
// %bb.1:                               // %B51
	cmp	x21, x8
	b.hi	.LBB183_19
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB183_8
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB183_11
// %bb.4:                               // %B33
	smull	x8, w22, w21
	sub	x20, x20, #16
	cmp	x8, w8, sxtw
	b.ne	.LBB183_15
// %bb.5:                               // %B40
	cbnz	w8, .LBB183_7
// %bb.6:                               // %B40
	orr	w9, w22, w21
	tbnz	w9, #31, .LBB183_16
.LBB183_7:                              // %B47
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB183_8:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB183_19
// %bb.9:                               // %B7
	cmp	x21, x8
	b.lo	.LBB183_17
// %bb.10:                              // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	.LBB183_14
.LBB183_11:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB183_19
// %bb.12:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB183_13:                             // %B28
	fmov	d1, x8
	fmul	d0, d0, d1
.LBB183_14:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #16
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB183_15:                             // %B35
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	fmul	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB183_16:                             // %B44
	mov	x22, #-9222809086901354496      // =0x8002000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB183_17:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB183_19
// %bb.18:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB183_13
.LBB183_19:                             // %B48
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        // =0x9a
	str	x20, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB183_21
// %bb.20:                              // %B50
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB183_21:                             // %B49
	b	.Lexception_asm_h
.Lfunc_end183:
	.size	.Lmul_0_asm_h, .Lfunc_end183-.Lmul_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function div_0_asm_h
	.type	.Ldiv_0_asm_h,@function
.Ldiv_0_asm_h:                          // @div_0_asm_h
// %bb.0:                               // %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB184_14
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB184_14
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB184_5
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB184_8
// %bb.4:                               // %B33
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x8, #562949953421312            // =0x2000000000000
	ldrb	w10, [x19], #1
	mov	x12, #9221683186994511872       // =0x7ffa000000000000
	sub	x20, x20, #16
	add	w10, w10, #247
	fdiv	d0, d0, d1
	ldr	x1, [x25, w10, uxtw #3]
	fcvtzs	w9, d0
	fmov	x11, d0
	fcmp	d0, d0
	add	x8, x11, x8
	csel	x8, x8, x12, vc
	cmp	x9, x11
	orr	x9, x9, #0xfffe000000000000
	csel	x22, x8, x9, ne
	br	x1
.LBB184_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB184_14
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB184_12
// %bb.7:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	.LBB184_11
.LBB184_8:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB184_14
// %bb.9:                               // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB184_10:                             // %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
.LBB184_11:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #16
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB184_12:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB184_14
// %bb.13:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB184_10
.LBB184_14:                             // %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        // =0x9b
	str	x20, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB184_16
// %bb.15:                              // %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB184_16:                             // %B42
	b	.Lexception_asm_h
.Lfunc_end184:
	.size	.Ldiv_0_asm_h, .Lfunc_end184-.Ldiv_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function mod_0_asm_h
	.type	.Lmod_0_asm_h,@function
.Lmod_0_asm_h:                          // @mod_0_asm_h
// %bb.0:                               // %B39
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB185_16
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB185_16
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB185_7
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB185_10
// %bb.4:                               // %B33
	tbnz	w22, #31, .LBB185_16
// %bb.5:                               // %B33
	cmp	w21, #1
	b.lt	.LBB185_16
// %bb.6:                               // %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB185_7:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB185_16
// %bb.8:                               // %B7
	cmp	x21, x8
	b.lo	.LBB185_14
// %bb.9:                               // %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	.LBB185_13
.LBB185_10:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB185_16
// %bb.11:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB185_12:                             // %B28
	fmov	d1, x8
.LBB185_13:                             // %B28
	bl	fmod
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #16
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB185_14:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB185_16
// %bb.15:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB185_12
.LBB185_16:                             // %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        // =0x9c
	str	x20, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB185_18
// %bb.17:                              // %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB185_18:                             // %B37
	b	.Lexception_asm_h
.Lfunc_end185:
	.size	.Lmod_0_asm_h, .Lfunc_end185-.Lmod_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_0_asm_h
	.type	.Ladd_0_asm_h,@function
.Ladd_0_asm_h:                          // @add_0_asm_h
// %bb.0:                               // %B46
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB186_16
// %bb.1:                               // %B46
	cmp	x21, x8
	b.hi	.LBB186_16
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB186_6
// %bb.3:                               // %B26
	cmp	x21, x8
	b.lo	.LBB186_9
// %bb.4:                               // %B36
	adds	w8, w22, w21
	sub	x20, x20, #16
	b.vs	.LBB186_13
// %bb.5:                               // %B42
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB186_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB186_16
// %bb.7:                               // %B11
	cmp	x21, x8
	b.lo	.LBB186_14
// %bb.8:                               // %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	.LBB186_12
.LBB186_9:                              // %B28
	tst	x21, #0xfffe000000000000
	b.eq	.LBB186_16
// %bb.10:                              // %B31
	scvtf	d0, w22
	add	x8, x21, x8
.LBB186_11:                             // %B31
	fmov	d1, x8
	fadd	d0, d0, d1
.LBB186_12:                             // %B31
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #16
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB186_13:                             // %B38
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	fadd	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB186_14:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB186_16
// %bb.15:                              // %B16
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB186_11
.LBB186_16:                             // %B7
	and	x8, x21, #0xffff000000000003
	mov	x9, #-281474976710653           // =0xffff000000000003
	mov	x10, #2                         // =0x2
	cmp	x8, x9
	movk	x10, #1, lsl #48
	and	x11, x22, #0xffff000000000003
	ccmp	x8, x10, #4, ne
	cset	w8, eq
	cmp	x11, x10
	ccmp	x11, x9, #4, ne
	b.ne	.LBB186_19
// %bb.17:                              // %B7
	cbz	w8, .LBB186_19
// %bb.18:                              // %B8
	mov	x0, xzr
	b	.LFastJSConcatString_asm_h
.LBB186_19:                             // %B43
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	.LBB186_21
// %bb.20:                              // %B45
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB186_21:                             // %B44
	b	.Lexception_asm_h
.Lfunc_end186:
	.size	.Ladd_0_asm_h, .Lfunc_end186-.Ladd_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function sub_0_asm_h
	.type	.Lsub_0_asm_h,@function
.Lsub_0_asm_h:                          // @sub_0_asm_h
// %bb.0:                               // %B43
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB187_16
// %bb.1:                               // %B43
	cmp	x21, x8
	b.hi	.LBB187_16
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB187_6
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB187_9
// %bb.4:                               // %B33
	subs	w8, w22, w21
	sub	x20, x20, #16
	b.vs	.LBB187_13
// %bb.5:                               // %B39
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB187_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB187_16
// %bb.7:                               // %B7
	cmp	x21, x8
	b.lo	.LBB187_14
// %bb.8:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	.LBB187_12
.LBB187_9:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB187_16
// %bb.10:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB187_11:                             // %B28
	fmov	d1, x8
	fsub	d0, d0, d1
.LBB187_12:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #16
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB187_13:                             // %B35
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	fsub	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB187_14:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB187_16
// %bb.15:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB187_11
.LBB187_16:                             // %B40
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        // =0x9e
	str	x20, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB187_18
// %bb.17:                              // %B42
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB187_18:                             // %B41
	b	.Lexception_asm_h
.Lfunc_end187:
	.size	.Lsub_0_asm_h, .Lfunc_end187-.Lsub_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function pow_0_asm_h
	.type	.Lpow_0_asm_h,@function
.Lpow_0_asm_h:                          // @pow_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w3, #159                        // =0x9f
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB188_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB188_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end188:
	.size	.Lpow_0_asm_h, .Lfunc_end188-.Lpow_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function shl_0_asm_h
	.type	.Lshl_0_asm_h,@function
.Lshl_0_asm_h:                          // @shl_0_asm_h
// %bb.0:                               // %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB189_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB189_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB189_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB189_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB189_5:                              // %B16
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #16
	add	w9, w9, #247
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB189_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB189_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB189_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB189_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB189_5
.LBB189_10:                             // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        // =0xa0
	str	x20, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB189_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB189_12:                             // %B26
	b	.Lexception_asm_h
.Lfunc_end189:
	.size	.Lshl_0_asm_h, .Lfunc_end189-.Lshl_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function sar_0_asm_h
	.type	.Lsar_0_asm_h,@function
.Lsar_0_asm_h:                          // @sar_0_asm_h
// %bb.0:                               // %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB190_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB190_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB190_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB190_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB190_5:                              // %B16
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #16
	add	w9, w9, #247
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB190_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB190_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB190_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB190_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB190_5
.LBB190_10:                             // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        // =0xa1
	str	x20, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB190_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB190_12:                             // %B26
	b	.Lexception_asm_h
.Lfunc_end190:
	.size	.Lsar_0_asm_h, .Lfunc_end190-.Lsar_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function shr_0_asm_h
	.type	.Lshr_0_asm_h,@function
.Lshr_0_asm_h:                          // @shr_0_asm_h
// %bb.0:                               // %B36
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB191_11
// %bb.1:                               // %B36
	cmp	x21, x8
	b.hi	.LBB191_11
// %bb.2:                               // %B10
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB191_6
// %bb.3:                               // %B27
	cmp	x21, x8
	b.lo	.LBB191_11
// %bb.4:                               // %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, .LBB191_10
.LBB191_5:                              // %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB191_6:                              // %B12
	tst	x22, #0xfffe000000000000
	b.eq	.LBB191_11
// %bb.7:                               // %B12
	cmp	x21, x8
	b.lo	.LBB191_11
// %bb.8:                               // %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB191_11
// %bb.9:                               // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, .LBB191_5
.LBB191_10:                             // %B6
	ucvtf	d0, w8
	mov	x9, #562949953421312            // =0x2000000000000
	fmov	x8, d0
	fcmp	d0, d0
	add	x8, x8, x9
	mov	x9, #9221683186994511872        // =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB191_11:                             // %B33
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	.LBB191_13
// %bb.12:                              // %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB191_13:                             // %B34
	b	.Lexception_asm_h
.Lfunc_end191:
	.size	.Lshr_0_asm_h, .Lfunc_end191-.Lshr_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lt_0_asm_h
	.type	.Llt_0_asm_h,@function
.Llt_0_asm_h:                           // @lt_0_asm_h
// %bb.0:                               // %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB192_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB192_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB192_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB192_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, lt
	br	x1
.LBB192_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB192_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB192_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB192_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB192_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB192_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB192_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB192_12:                             // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        // =0xa3
	str	x20, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB192_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB192_14:                             // %B22
	b	.Lexception_asm_h
.Lfunc_end192:
	.size	.Llt_0_asm_h, .Lfunc_end192-.Llt_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lte_0_asm_h
	.type	.Llte_0_asm_h,@function
.Llte_0_asm_h:                          // @lte_0_asm_h
// %bb.0:                               // %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB193_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB193_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB193_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB193_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, le
	br	x1
.LBB193_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB193_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB193_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB193_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB193_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB193_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB193_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB193_12:                             // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        // =0xa4
	str	x20, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB193_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB193_14:                             // %B22
	b	.Lexception_asm_h
.Lfunc_end193:
	.size	.Llte_0_asm_h, .Lfunc_end193-.Llte_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gt_0_asm_h
	.type	.Lgt_0_asm_h,@function
.Lgt_0_asm_h:                           // @gt_0_asm_h
// %bb.0:                               // %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB194_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB194_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB194_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB194_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB194_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB194_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB194_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB194_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB194_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB194_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB194_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB194_12:                             // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        // =0xa5
	str	x20, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB194_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB194_14:                             // %B22
	b	.Lexception_asm_h
.Lfunc_end194:
	.size	.Lgt_0_asm_h, .Lfunc_end194-.Lgt_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gte_0_asm_h
	.type	.Lgte_0_asm_h,@function
.Lgte_0_asm_h:                          // @gte_0_asm_h
// %bb.0:                               // %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB195_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB195_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB195_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB195_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB195_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB195_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB195_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB195_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB195_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB195_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB195_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB195_12:                             // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        // =0xa6
	str	x20, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB195_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB195_14:                             // %B22
	b	.Lexception_asm_h
.Lfunc_end195:
	.size	.Lgte_0_asm_h, .Lfunc_end195-.Lgte_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function instanceof_0_asm_h
	.type	.Linstanceof_0_asm_h,@function
.Linstanceof_0_asm_h:                   // @instanceof_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	.LBB196_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB196_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end196:
	.size	.Linstanceof_0_asm_h, .Lfunc_end196-.Linstanceof_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function in_0_asm_h
	.type	.Lin_0_asm_h,@function
.Lin_0_asm_h:                           // @in_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	.LBB197_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB197_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end197:
	.size	.Lin_0_asm_h, .Lfunc_end197-.Lin_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function eq_0_asm_h
	.type	.Leq_0_asm_h,@function
.Leq_0_asm_h:                           // @eq_0_asm_h
// %bb.0:                               // %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB198_13
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB198_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB198_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB198_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB198_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB198_13
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB198_11
// %bb.7:                               // %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #247
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB198_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB198_13
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB198_10:                             // %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #247
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB198_11:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB198_13
// %bb.12:                              // %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB198_10
.LBB198_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB198_15
.LBB198_14:                             // %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB198_15:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB198_17
// %bb.16:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB198_14
	b	.LBB198_20
.LBB198_17:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB198_20
// %bb.18:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB198_21
// %bb.19:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB198_21
.LBB198_20:                             // %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB198_21:                             // %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x23, #48]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB198_23
// %bb.22:                              // %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB198_23:                             // %B42
	b	.Lexception_asm_h
.Lfunc_end198:
	.size	.Leq_0_asm_h, .Lfunc_end198-.Leq_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function neq_0_asm_h
	.type	.Lneq_0_asm_h,@function
.Lneq_0_asm_h:                          // @neq_0_asm_h
// %bb.0:                               // %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB199_13
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB199_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB199_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB199_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB199_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB199_13
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB199_11
// %bb.7:                               // %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #247
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB199_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB199_13
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB199_10:                             // %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #247
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB199_11:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB199_13
// %bb.12:                              // %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB199_10
.LBB199_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB199_15
.LBB199_14:                             // %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB199_15:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB199_17
// %bb.16:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB199_14
	b	.LBB199_20
.LBB199_17:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB199_20
// %bb.18:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB199_21
// %bb.19:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB199_21
.LBB199_20:                             // %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB199_21:                             // %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x20, [x23, #48]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB199_23
// %bb.22:                              // %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB199_23:                             // %B42
	b	.Lexception_asm_h
.Lfunc_end199:
	.size	.Lneq_0_asm_h, .Lfunc_end199-.Lneq_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function strict_eq_0_asm_h
	.type	.Lstrict_eq_0_asm_h,@function
.Lstrict_eq_0_asm_h:                    // @strict_eq_0_asm_h
// %bb.0:                               // %B39
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB200_13
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB200_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB200_5
// %bb.3:                               // %B30
	cmp	x21, x8
	b.lo	.LBB200_8
// %bb.4:                               // %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB200_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB200_13
// %bb.6:                               // %B23
	cmp	x21, x8
	b.lo	.LBB200_11
// %bb.7:                               // %B28
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #247
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB200_8:                              // %B32
	tst	x21, #0xfffe000000000000
	b.eq	.LBB200_13
// %bb.9:                               // %B34
	scvtf	d0, w22
	add	x8, x21, x8
.LBB200_10:                             // %B34
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #247
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB200_11:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB200_13
// %bb.12:                              // %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB200_10
.LBB200_13:                             // %B10
	cmp	x22, x21
	b.ne	.LBB200_15
// %bb.14:                              // %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB200_15:                             // %B13
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x10, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w9, eq
	cmp	x10, x11
	ccmp	x10, x12, #4, ne
	cset	w11, eq
	cmp	w9, #1
	b.ne	.LBB200_17
// %bb.16:                              // %B13
	cbnz	w11, .LBB200_22
.LBB200_17:                             // %B16
	mov	x12, #2                         // =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, .LBB200_19
// %bb.18:                              // %B16
	tbnz	w8, #0, .LBB200_23
.LBB200_19:                             // %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x9, x8
	b.ne	.LBB200_21
// %bb.20:                              // %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	.LBB200_25
.LBB200_21:                             // %B21
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB200_22:                             // %B14
	mov	x0, xzr
	b	.LFastStringEqual_asm_h
.LBB200_23:                             // %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x23, #48]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB200_27
// %bb.24:                              // %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB200_25:                             // %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #16
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB200_28
// %bb.26:                              // %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB200_27:                             // %B37
	b	.Lexception_asm_h
.LBB200_28:                             // %B8
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end200:
	.size	.Lstrict_eq_0_asm_h, .Lfunc_end200-.Lstrict_eq_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function strict_neq_0_asm_h
	.type	.Lstrict_neq_0_asm_h,@function
.Lstrict_neq_0_asm_h:                   // @strict_neq_0_asm_h
// %bb.0:                               // %B39
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB201_13
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB201_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB201_5
// %bb.3:                               // %B30
	cmp	x21, x8
	b.lo	.LBB201_8
// %bb.4:                               // %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB201_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB201_13
// %bb.6:                               // %B23
	cmp	x21, x8
	b.lo	.LBB201_11
// %bb.7:                               // %B28
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #247
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB201_8:                              // %B32
	tst	x21, #0xfffe000000000000
	b.eq	.LBB201_13
// %bb.9:                               // %B34
	scvtf	d0, w22
	add	x8, x21, x8
.LBB201_10:                             // %B34
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #247
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB201_11:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB201_13
// %bb.12:                              // %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB201_10
.LBB201_13:                             // %B10
	cmp	x22, x21
	b.ne	.LBB201_15
// %bb.14:                              // %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB201_15:                             // %B13
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x10, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w9, eq
	cmp	x10, x11
	ccmp	x10, x12, #4, ne
	cset	w11, eq
	cmp	w9, #1
	b.ne	.LBB201_17
// %bb.16:                              // %B13
	cbnz	w11, .LBB201_22
.LBB201_17:                             // %B16
	mov	x12, #2                         // =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, .LBB201_19
// %bb.18:                              // %B16
	tbnz	w8, #0, .LBB201_23
.LBB201_19:                             // %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x9, x8
	b.ne	.LBB201_21
// %bb.20:                              // %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	.LBB201_25
.LBB201_21:                             // %B21
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB201_22:                             // %B14
	mov	w0, #1                          // =0x1
	b	.LFastStringEqual_asm_h
.LBB201_23:                             // %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x20, [x23, #48]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB201_27
// %bb.24:                              // %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB201_25:                             // %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #16
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB201_28
// %bb.26:                              // %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB201_27:                             // %B37
	b	.Lexception_asm_h
.LBB201_28:                             // %B8
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end201:
	.size	.Lstrict_neq_0_asm_h, .Lfunc_end201-.Lstrict_neq_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function and_0_asm_h
	.type	.Land_0_asm_h,@function
.Land_0_asm_h:                          // @and_0_asm_h
// %bb.0:                               // %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB202_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB202_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB202_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB202_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB202_5:                              // %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	and	w8, w8, w21
	add	w9, w9, #247
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB202_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB202_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB202_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB202_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB202_5
.LBB202_10:                             // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        // =0xad
	str	x20, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB202_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB202_12:                             // %B26
	b	.Lexception_asm_h
.Lfunc_end202:
	.size	.Land_0_asm_h, .Lfunc_end202-.Land_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function xor_0_asm_h
	.type	.Lxor_0_asm_h,@function
.Lxor_0_asm_h:                          // @xor_0_asm_h
// %bb.0:                               // %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB203_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB203_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB203_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB203_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB203_5:                              // %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	eor	w8, w8, w21
	add	w9, w9, #247
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB203_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB203_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB203_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB203_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB203_5
.LBB203_10:                             // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        // =0xae
	str	x20, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB203_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB203_12:                             // %B26
	b	.Lexception_asm_h
.Lfunc_end203:
	.size	.Lxor_0_asm_h, .Lfunc_end203-.Lxor_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function or_0_asm_h
	.type	.Lor_0_asm_h,@function
.Lor_0_asm_h:                           // @or_0_asm_h
// %bb.0:                               // %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB204_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB204_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB204_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB204_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB204_5:                              // %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	orr	w8, w8, w21
	add	w9, w9, #247
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB204_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB204_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB204_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB204_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB204_5
.LBB204_10:                             // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        // =0xaf
	str	x20, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB204_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB204_12:                             // %B26
	b	.Lexception_asm_h
.Lfunc_end204:
	.size	.Lor_0_asm_h, .Lfunc_end204-.Lor_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nop_0_asm_h
	.type	.Lnop_0_asm_h,@function
.Lnop_0_asm_h:                          // @nop_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end205:
	.size	.Lnop_0_asm_h, .Lfunc_end205-.Lnop_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_minus1_0_asm_h
	.type	.Lpush_minus1_0_asm_h,@function
.Lpush_minus1_0_asm_h:                  // @push_minus1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562945658454017          // =0xfffe0000ffffffff
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end206:
	.size	.Lpush_minus1_0_asm_h, .Lfunc_end206-.Lpush_minus1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_0_0_asm_h
	.type	.Lpush_0_0_asm_h,@function
.Lpush_0_0_asm_h:                       // @push_0_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421312          // =0xfffe000000000000
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end207:
	.size	.Lpush_0_0_asm_h, .Lfunc_end207-.Lpush_0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_1_0_asm_h
	.type	.Lpush_1_0_asm_h,@function
.Lpush_1_0_asm_h:                       // @push_1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421311          // =0xfffe000000000001
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end208:
	.size	.Lpush_1_0_asm_h, .Lfunc_end208-.Lpush_1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_2_0_asm_h
	.type	.Lpush_2_0_asm_h,@function
.Lpush_2_0_asm_h:                       // @push_2_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #2                         // =0x2
	movk	x22, #65534, lsl #48
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end209:
	.size	.Lpush_2_0_asm_h, .Lfunc_end209-.Lpush_2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_3_0_asm_h
	.type	.Lpush_3_0_asm_h,@function
.Lpush_3_0_asm_h:                       // @push_3_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421309          // =0xfffe000000000003
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end210:
	.size	.Lpush_3_0_asm_h, .Lfunc_end210-.Lpush_3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_4_0_asm_h
	.type	.Lpush_4_0_asm_h,@function
.Lpush_4_0_asm_h:                       // @push_4_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #4                         // =0x4
	movk	x22, #65534, lsl #48
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end211:
	.size	.Lpush_4_0_asm_h, .Lfunc_end211-.Lpush_4_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_5_0_asm_h
	.type	.Lpush_5_0_asm_h,@function
.Lpush_5_0_asm_h:                       // @push_5_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #5                         // =0x5
	movk	x22, #65534, lsl #48
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end212:
	.size	.Lpush_5_0_asm_h, .Lfunc_end212-.Lpush_5_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_6_0_asm_h
	.type	.Lpush_6_0_asm_h,@function
.Lpush_6_0_asm_h:                       // @push_6_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #6                         // =0x6
	movk	x22, #65534, lsl #48
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end213:
	.size	.Lpush_6_0_asm_h, .Lfunc_end213-.Lpush_6_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_7_0_asm_h
	.type	.Lpush_7_0_asm_h,@function
.Lpush_7_0_asm_h:                       // @push_7_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421305          // =0xfffe000000000007
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end214:
	.size	.Lpush_7_0_asm_h, .Lfunc_end214-.Lpush_7_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i8_0_asm_h
	.type	.Lpush_i8_0_asm_h,@function
.Lpush_i8_0_asm_h:                      // @push_i8_0_asm_h
// %bb.0:                               // %B0
	ldrb	w9, [x19, #1]
	ldrsb	x10, [x19]
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x19, x19, #2
	add	w9, w9, #247
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x22, x8
	br	x1
.Lfunc_end215:
	.size	.Lpush_i8_0_asm_h, .Lfunc_end215-.Lpush_i8_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i16_0_asm_h
	.type	.Lpush_i16_0_asm_h,@function
.Lpush_i16_0_asm_h:                     // @push_i16_0_asm_h
// %bb.0:                               // %B0
	ldrb	w9, [x19, #2]
	ldrsh	x10, [x19]
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x19, x19, #3
	add	w9, w9, #247
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x22, x8
	br	x1
.Lfunc_end216:
	.size	.Lpush_i16_0_asm_h, .Lfunc_end216-.Lpush_i16_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_const8_0_asm_h
	.type	.Lpush_const8_0_asm_h,@function
.Lpush_const8_0_asm_h:                  // @push_const8_0_asm_h
// %bb.0:                               // %B0
	ldrb	w9, [x19, #1]
	ldr	x8, [x23, #104]
	ldrb	w10, [x19], #2
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x22, [x8, x10, lsl #3]
	br	x1
.Lfunc_end217:
	.size	.Lpush_const8_0_asm_h, .Lfunc_end217-.Lpush_const8_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function fclosure8_0_asm_h
	.type	.Lfclosure8_0_asm_h,@function
.Lfclosure8_0_asm_h:                    // @fclosure8_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #104]
	ldrb	w9, [x19]
	ldr	x0, [x8, x9, lsl #3]
	b	.LFastFclosure_asm_h
.Lfunc_end218:
	.size	.Lfclosure8_0_asm_h, .Lfunc_end218-.Lfclosure8_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_empty_string_0_asm_h
	.type	.Lpush_empty_string_0_asm_h,@function
.Lpush_empty_string_0_asm_h:            // @push_empty_string_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	w1, #47                         // =0x2f
	mov	w2, #1                          // =0x1
	str	x20, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB219_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB219_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end219:
	.size	.Lpush_empty_string_0_asm_h, .Lfunc_end219-.Lpush_empty_string_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc8_0_asm_h
	.type	.Lget_loc8_0_asm_h,@function
.Lget_loc8_0_asm_h:                     // @get_loc8_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #1]
	ldrb	w9, [x19], #2
	add	w8, w8, #247
	ldr	x22, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end220:
	.size	.Lget_loc8_0_asm_h, .Lfunc_end220-.Lget_loc8_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc8_0_asm_h
	.type	.Lput_loc8_0_asm_h,@function
.Lput_loc8_0_asm_h:                     // @put_loc8_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end221:
	.size	.Lput_loc8_0_asm_h, .Lfunc_end221-.Lput_loc8_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc8_0_asm_h
	.type	.Lset_loc8_0_asm_h,@function
.Lset_loc8_0_asm_h:                     // @set_loc8_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end222:
	.size	.Lset_loc8_0_asm_h, .Lfunc_end222-.Lset_loc8_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc0_0_asm_h
	.type	.Lget_loc0_0_asm_h,@function
.Lget_loc0_0_asm_h:                     // @get_loc0_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27]
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end223:
	.size	.Lget_loc0_0_asm_h, .Lfunc_end223-.Lget_loc0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc1_0_asm_h
	.type	.Lget_loc1_0_asm_h,@function
.Lget_loc1_0_asm_h:                     // @get_loc1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27, #8]
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end224:
	.size	.Lget_loc1_0_asm_h, .Lfunc_end224-.Lget_loc1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc2_0_asm_h
	.type	.Lget_loc2_0_asm_h,@function
.Lget_loc2_0_asm_h:                     // @get_loc2_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27, #16]
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end225:
	.size	.Lget_loc2_0_asm_h, .Lfunc_end225-.Lget_loc2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc3_0_asm_h
	.type	.Lget_loc3_0_asm_h,@function
.Lget_loc3_0_asm_h:                     // @get_loc3_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27, #24]
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end226:
	.size	.Lget_loc3_0_asm_h, .Lfunc_end226-.Lget_loc3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc0_0_asm_h
	.type	.Lput_loc0_0_asm_h,@function
.Lput_loc0_0_asm_h:                     // @put_loc0_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end227:
	.size	.Lput_loc0_0_asm_h, .Lfunc_end227-.Lput_loc0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc1_0_asm_h
	.type	.Lput_loc1_0_asm_h,@function
.Lput_loc1_0_asm_h:                     // @put_loc1_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end228:
	.size	.Lput_loc1_0_asm_h, .Lfunc_end228-.Lput_loc1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc2_0_asm_h
	.type	.Lput_loc2_0_asm_h,@function
.Lput_loc2_0_asm_h:                     // @put_loc2_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end229:
	.size	.Lput_loc2_0_asm_h, .Lfunc_end229-.Lput_loc2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc3_0_asm_h
	.type	.Lput_loc3_0_asm_h,@function
.Lput_loc3_0_asm_h:                     // @put_loc3_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end230:
	.size	.Lput_loc3_0_asm_h, .Lfunc_end230-.Lput_loc3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc0_0_asm_h
	.type	.Lset_loc0_0_asm_h,@function
.Lset_loc0_0_asm_h:                     // @set_loc0_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end231:
	.size	.Lset_loc0_0_asm_h, .Lfunc_end231-.Lset_loc0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc1_0_asm_h
	.type	.Lset_loc1_0_asm_h,@function
.Lset_loc1_0_asm_h:                     // @set_loc1_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end232:
	.size	.Lset_loc1_0_asm_h, .Lfunc_end232-.Lset_loc1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc2_0_asm_h
	.type	.Lset_loc2_0_asm_h,@function
.Lset_loc2_0_asm_h:                     // @set_loc2_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end233:
	.size	.Lset_loc2_0_asm_h, .Lfunc_end233-.Lset_loc2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc3_0_asm_h
	.type	.Lset_loc3_0_asm_h,@function
.Lset_loc3_0_asm_h:                     // @set_loc3_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end234:
	.size	.Lset_loc3_0_asm_h, .Lfunc_end234-.Lset_loc3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg0_0_asm_h
	.type	.Lget_arg0_0_asm_h,@function
.Lget_arg0_0_asm_h:                     // @get_arg0_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28]
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end235:
	.size	.Lget_arg0_0_asm_h, .Lfunc_end235-.Lget_arg0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg1_0_asm_h
	.type	.Lget_arg1_0_asm_h,@function
.Lget_arg1_0_asm_h:                     // @get_arg1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28, #8]
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end236:
	.size	.Lget_arg1_0_asm_h, .Lfunc_end236-.Lget_arg1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg2_0_asm_h
	.type	.Lget_arg2_0_asm_h,@function
.Lget_arg2_0_asm_h:                     // @get_arg2_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28, #16]
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end237:
	.size	.Lget_arg2_0_asm_h, .Lfunc_end237-.Lget_arg2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg3_0_asm_h
	.type	.Lget_arg3_0_asm_h,@function
.Lget_arg3_0_asm_h:                     // @get_arg3_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28, #24]
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end238:
	.size	.Lget_arg3_0_asm_h, .Lfunc_end238-.Lget_arg3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg0_0_asm_h
	.type	.Lput_arg0_0_asm_h,@function
.Lput_arg0_0_asm_h:                     // @put_arg0_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end239:
	.size	.Lput_arg0_0_asm_h, .Lfunc_end239-.Lput_arg0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg1_0_asm_h
	.type	.Lput_arg1_0_asm_h,@function
.Lput_arg1_0_asm_h:                     // @put_arg1_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end240:
	.size	.Lput_arg1_0_asm_h, .Lfunc_end240-.Lput_arg1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg2_0_asm_h
	.type	.Lput_arg2_0_asm_h,@function
.Lput_arg2_0_asm_h:                     // @put_arg2_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end241:
	.size	.Lput_arg2_0_asm_h, .Lfunc_end241-.Lput_arg2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg3_0_asm_h
	.type	.Lput_arg3_0_asm_h,@function
.Lput_arg3_0_asm_h:                     // @put_arg3_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end242:
	.size	.Lput_arg3_0_asm_h, .Lfunc_end242-.Lput_arg3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg0_0_asm_h
	.type	.Lset_arg0_0_asm_h,@function
.Lset_arg0_0_asm_h:                     // @set_arg0_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end243:
	.size	.Lset_arg0_0_asm_h, .Lfunc_end243-.Lset_arg0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg1_0_asm_h
	.type	.Lset_arg1_0_asm_h,@function
.Lset_arg1_0_asm_h:                     // @set_arg1_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end244:
	.size	.Lset_arg1_0_asm_h, .Lfunc_end244-.Lset_arg1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg2_0_asm_h
	.type	.Lset_arg2_0_asm_h,@function
.Lset_arg2_0_asm_h:                     // @set_arg2_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end245:
	.size	.Lset_arg2_0_asm_h, .Lfunc_end245-.Lset_arg2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg3_0_asm_h
	.type	.Lset_arg3_0_asm_h,@function
.Lset_arg3_0_asm_h:                     // @set_arg3_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end246:
	.size	.Lset_arg3_0_asm_h, .Lfunc_end246-.Lset_arg3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref0_0_asm_h
	.type	.Lget_var_ref0_0_asm_h,@function
.Lget_var_ref0_0_asm_h:                 // @get_var_ref0_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x22, [x8]
	br	x1
.Lfunc_end247:
	.size	.Lget_var_ref0_0_asm_h, .Lfunc_end247-.Lget_var_ref0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref1_0_asm_h
	.type	.Lget_var_ref1_0_asm_h,@function
.Lget_var_ref1_0_asm_h:                 // @get_var_ref1_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x22, [x8]
	br	x1
.Lfunc_end248:
	.size	.Lget_var_ref1_0_asm_h, .Lfunc_end248-.Lget_var_ref1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref2_0_asm_h
	.type	.Lget_var_ref2_0_asm_h,@function
.Lget_var_ref2_0_asm_h:                 // @get_var_ref2_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x22, [x8]
	br	x1
.Lfunc_end249:
	.size	.Lget_var_ref2_0_asm_h, .Lfunc_end249-.Lget_var_ref2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref3_0_asm_h
	.type	.Lget_var_ref3_0_asm_h,@function
.Lget_var_ref3_0_asm_h:                 // @get_var_ref3_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x22, [x8]
	br	x1
.Lfunc_end250:
	.size	.Lget_var_ref3_0_asm_h, .Lfunc_end250-.Lget_var_ref3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref0_0_asm_h
	.type	.Lput_var_ref0_0_asm_h,@function
.Lput_var_ref0_0_asm_h:                 // @put_var_ref0_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end251:
	.size	.Lput_var_ref0_0_asm_h, .Lfunc_end251-.Lput_var_ref0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref1_0_asm_h
	.type	.Lput_var_ref1_0_asm_h,@function
.Lput_var_ref1_0_asm_h:                 // @put_var_ref1_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end252:
	.size	.Lput_var_ref1_0_asm_h, .Lfunc_end252-.Lput_var_ref1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref2_0_asm_h
	.type	.Lput_var_ref2_0_asm_h,@function
.Lput_var_ref2_0_asm_h:                 // @put_var_ref2_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end253:
	.size	.Lput_var_ref2_0_asm_h, .Lfunc_end253-.Lput_var_ref2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref3_0_asm_h
	.type	.Lput_var_ref3_0_asm_h,@function
.Lput_var_ref3_0_asm_h:                 // @put_var_ref3_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end254:
	.size	.Lput_var_ref3_0_asm_h, .Lfunc_end254-.Lput_var_ref3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref0_0_asm_h
	.type	.Lset_var_ref0_0_asm_h,@function
.Lset_var_ref0_0_asm_h:                 // @set_var_ref0_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end255:
	.size	.Lset_var_ref0_0_asm_h, .Lfunc_end255-.Lset_var_ref0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref1_0_asm_h
	.type	.Lset_var_ref1_0_asm_h,@function
.Lset_var_ref1_0_asm_h:                 // @set_var_ref1_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end256:
	.size	.Lset_var_ref1_0_asm_h, .Lfunc_end256-.Lset_var_ref1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref2_0_asm_h
	.type	.Lset_var_ref2_0_asm_h,@function
.Lset_var_ref2_0_asm_h:                 // @set_var_ref2_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end257:
	.size	.Lset_var_ref2_0_asm_h, .Lfunc_end257-.Lset_var_ref2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref3_0_asm_h
	.type	.Lset_var_ref3_0_asm_h,@function
.Lset_var_ref3_0_asm_h:                 // @set_var_ref3_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end258:
	.size	.Lset_var_ref3_0_asm_h, .Lfunc_end258-.Lset_var_ref3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_length_0_asm_h
	.type	.Lget_length_0_asm_h,@function
.Lget_length_0_asm_h:                   // @get_length_0_asm_h
// %bb.0:                               // %B27
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #1, lsl #48
	and	x9, x22, #0xffff000000000003
	cmp	x9, x8
	mov	x8, #-281474976710653           // =0xffff000000000003
	ccmp	x9, x8, #4, ne
	b.ne	.LBB259_2
// %bb.1:                               // %B28
	and	x8, x22, #0xfffffffffffc
	ldrb	w9, [x19], #1
	ldr	w8, [x8, #4]
	mov	x10, #-562949953421312          // =0xfffe000000000000
	sub	x20, x20, #8
	add	w9, w9, #247
	bfxil	x10, x8, #0, #30
	ldr	x1, [x25, w9, uxtw #3]
	mov	x22, x10
	br	x1
.LBB259_2:                              // %B21
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB259_12
// %bb.3:                               // %B22
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB259_4:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB259_5 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w11, #0x30
	ldr	w10, [x13, w10, uxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB259_7
.LBB259_5:                              // %B1
                                        //   Parent Loop BB259_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, #48
	b.eq	.LBB259_9
// %bb.6:                               // %B9
                                        //   in Loop: Header=BB259_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB259_5
.LBB259_7:                              // %B14
                                        //   in Loop: Header=BB259_4 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB259_12
// %bb.8:                               // %B17
                                        //   in Loop: Header=BB259_4 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB259_4
	b	.LBB259_11
.LBB259_9:                              // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB259_12
// %bb.10:                              // %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB259_11:                             // %B6
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB259_12:                             // %B24
	mov	x0, x24
	mov	x1, x22
	mov	w2, #48                         // =0x30
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB259_14
// %bb.13:                              // %B26
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB259_14:                             // %B25
	b	.Lexception_asm_h
.Lfunc_end259:
	.size	.Lget_length_0_asm_h, .Lfunc_end259-.Lget_length_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_false8_0_asm_h
	.type	.Lif_false8_0_asm_h,@function
.Lif_false8_0_asm_h:                    // @if_false8_0_asm_h
// %bb.0:                               // %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	.LBB260_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB260_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB260_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB260_6
	b	.LBB260_7
.LBB260_4:                              // %B23
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x9
	b.eq	.LBB260_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB260_7
.LBB260_6:                              // %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB260_7:                              // %B9
	mov	x9, #-281474976710656           // =0xffff000000000000
	cmp	x22, x9
	b.hs	.LBB260_13
// %bb.8:                               // %B11
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x9
	b.lo	.LBB260_10
.LBB260_9:                              // %B19
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB260_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB260_13
// %bb.11:                              // %B17
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB260_6
	b.vs	.LBB260_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB260_9
	b	.LBB260_6
.LBB260_13:                             // %B15
	mov	x20, x8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.Lfunc_end260:
	.size	.Lif_false8_0_asm_h, .Lfunc_end260-.Lif_false8_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_true8_0_asm_h
	.type	.Lif_true8_0_asm_h,@function
.Lif_true8_0_asm_h:                     // @if_true8_0_asm_h
// %bb.0:                               // %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	.LBB261_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB261_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB261_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB261_6
	b	.LBB261_7
.LBB261_4:                              // %B23
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x9
	b.eq	.LBB261_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB261_7
.LBB261_6:                              // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB261_7:                              // %B9
	mov	x9, #-281474976710656           // =0xffff000000000000
	cmp	x22, x9
	b.hs	.LBB261_13
// %bb.8:                               // %B11
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x9
	b.lo	.LBB261_10
.LBB261_9:                              // %B19
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB261_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB261_13
// %bb.11:                              // %B17
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB261_6
	b.vs	.LBB261_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB261_9
	b	.LBB261_6
.LBB261_13:                             // %B15
	mov	x20, x8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.Lfunc_end261:
	.size	.Lif_true8_0_asm_h, .Lfunc_end261-.Lif_true8_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function goto8_0_asm_h
	.type	.Lgoto8_0_asm_h,@function
.Lgoto8_0_asm_h:                        // @goto8_0_asm_h
// %bb.0:                               // %B0
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end262:
	.size	.Lgoto8_0_asm_h, .Lfunc_end262-.Lgoto8_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function goto16_0_asm_h
	.type	.Lgoto16_0_asm_h,@function
.Lgoto16_0_asm_h:                       // @goto16_0_asm_h
// %bb.0:                               // %B0
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end263:
	.size	.Lgoto16_0_asm_h, .Lfunc_end263-.Lgoto16_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call0_0_asm_h
	.type	.Lcall0_0_asm_h,@function
.Lcall0_0_asm_h:                        // @call0_0_asm_h
// %bb.0:                               // %B2
	str	x19, [x23, #32]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	str	x20, [x23, #48]
	mov	x0, xzr
	ldur	x22, [x20, #-8]
	bl	.Lcommon_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #96]
	b.eq	.LBB264_2
// %bb.1:                               // %B4
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB264_2:                              // %B3
	b	.Lexception_asm_h
.Lfunc_end264:
	.size	.Lcall0_0_asm_h, .Lfunc_end264-.Lcall0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call1_0_asm_h
	.type	.Lcall1_0_asm_h,@function
.Lcall1_0_asm_h:                        // @call1_0_asm_h
// %bb.0:                               // %B2
	str	x19, [x23, #32]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	str	x20, [x23, #48]
	mov	w0, #1                          // =0x1
	ldur	x22, [x20, #-16]
	sub	x20, x20, #8
	bl	.Lcommon_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #96]
	b.eq	.LBB265_2
// %bb.1:                               // %B4
	stur	x0, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB265_2:                              // %B3
	b	.Lexception_asm_h
.Lfunc_end265:
	.size	.Lcall1_0_asm_h, .Lfunc_end265-.Lcall1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call2_0_asm_h
	.type	.Lcall2_0_asm_h,@function
.Lcall2_0_asm_h:                        // @call2_0_asm_h
// %bb.0:                               // %B2
	str	x19, [x23, #32]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	str	x20, [x23, #48]
	mov	w0, #2                          // =0x2
	ldur	x22, [x20, #-24]
	sub	x20, x20, #16
	bl	.Lcommon_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #96]
	b.eq	.LBB266_2
// %bb.1:                               // %B4
	stur	x0, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB266_2:                              // %B3
	b	.Lexception_asm_h
.Lfunc_end266:
	.size	.Lcall2_0_asm_h, .Lfunc_end266-.Lcall2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call3_0_asm_h
	.type	.Lcall3_0_asm_h,@function
.Lcall3_0_asm_h:                        // @call3_0_asm_h
// %bb.0:                               // %B2
	str	x19, [x23, #32]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	str	x20, [x23, #48]
	mov	w0, #3                          // =0x3
	ldur	x22, [x20, #-32]
	sub	x20, x20, #24
	bl	.Lcommon_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #96]
	b.eq	.LBB267_2
// %bb.1:                               // %B4
	stur	x0, [x20, #-32]
	sub	x20, x20, #24
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB267_2:                              // %B3
	b	.Lexception_asm_h
.Lfunc_end267:
	.size	.Lcall3_0_asm_h, .Lfunc_end267-.Lcall3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_undefined_0_asm_h
	.type	.Lis_undefined_0_asm_h,@function
.Lis_undefined_0_asm_h:                 // @is_undefined_0_asm_h
// %bb.0:                               // %B2
	ldur	x22, [x20, #-8]
	cmp	x22, #18
	b.ne	.LBB268_2
// %bb.1:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB268_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end268:
	.size	.Lis_undefined_0_asm_h, .Lfunc_end268-.Lis_undefined_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_null_0_asm_h
	.type	.Lis_null_0_asm_h,@function
.Lis_null_0_asm_h:                      // @is_null_0_asm_h
// %bb.0:                               // %B2
	ldur	x22, [x20, #-8]
	cmp	x22, #2
	b.ne	.LBB269_2
// %bb.1:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB269_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end269:
	.size	.Lis_null_0_asm_h, .Lfunc_end269-.Lis_null_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_function_0_asm_h
	.type	.Lis_function_0_asm_h,@function
.Lis_function_0_asm_h:                  // @is_function_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	mov	x1, x22
	bl	js_operator_typeof_gc
	cmp	w0, #27
	b.ne	.LBB270_2
// %bb.1:                               // %B2
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB270_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end270:
	.size	.Lis_function_0_asm_h, .Lfunc_end270-.Lis_function_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_coverage_0_asm_h
	.type	.Linc_coverage_0_asm_h,@function
.Linc_coverage_0_asm_h:                 // @inc_coverage_0_asm_h
// %bb.0:                               // %B10
	ldr	x8, [x23, #8]
	ldr	x1, [x8, #32]
	ldr	x8, [x1, #112]
	cbz	x8, .LBB271_3
// %bb.1:                               // %B7
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbnz	x8, .LBB271_4
.LBB271_2:                              // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB271_3:                              // %B11
	mov	x0, x24
	str	x20, [x23, #48]
	bl	EnsureCoverageCounters
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbz	x8, .LBB271_2
.LBB271_4:                              // %B2
	ldr	w9, [x19]
	ldr	w10, [x10, #104]
	cmp	w9, w10
	b.hs	.LBB271_2
// %bb.5:                               // %B6
	ldr	w10, [x8, w9, sxtw #2]
	add	w10, w10, #1
	str	w10, [x8, w9, sxtw #2]
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end271:
	.size	.Linc_coverage_0_asm_h, .Lfunc_end271-.Linc_coverage_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_global_ref_undef_0_asm_h
	.type	.Lget_global_ref_undef_0_asm_h,@function
.Lget_global_ref_undef_0_asm_h:         // @get_global_ref_undef_0_asm_h
// %bb.0:                               // %B6
	ldr	x8, [x23, #8]
	ldrh	w9, [x19]
	ldr	x8, [x8, #40]
	ldr	x8, [x8, x9, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB272_2
.LBB272_1:                              // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB272_2:                              // %B1
	ldr	x1, [x23, #8]
	ldrh	w2, [x19]
	mov	x0, x24
	mov	w3, wzr
	str	x20, [x23, #48]
	bl	JS_GetGlobalRef_GC
	cmp	x0, #130
	mov	x8, x0
	b.ne	.LBB272_1
// %bb.3:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end272:
	.size	.Lget_global_ref_undef_0_asm_h, .Lfunc_end272-.Lget_global_ref_undef_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_global_ref_0_asm_h
	.type	.Lget_global_ref_0_asm_h,@function
.Lget_global_ref_0_asm_h:               // @get_global_ref_0_asm_h
// %bb.0:                               // %B6
	ldr	x8, [x23, #8]
	ldrh	w9, [x19]
	ldr	x8, [x8, #40]
	ldr	x8, [x8, x9, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB273_2
.LBB273_1:                              // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB273_2:                              // %B1
	ldr	x1, [x23, #8]
	ldrh	w2, [x19]
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x23, #48]
	bl	JS_GetGlobalRef_GC
	cmp	x0, #130
	mov	x8, x0
	b.ne	.LBB273_1
// %bb.3:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end273:
	.size	.Lget_global_ref_0_asm_h, .Lfunc_end273-.Lget_global_ref_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_global_ref_0_asm_h
	.type	.Lput_global_ref_0_asm_h,@function
.Lput_global_ref_0_asm_h:               // @put_global_ref_0_asm_h
// %bb.0:                               // %B10
	ldr	x8, [x23, #8]
	ldrh	w9, [x19]
	ldur	x22, [x20, #-8]
	ldr	x8, [x8, #40]
	ldr	x8, [x8, x9, lsl #3]
	ldr	x9, [x8]
	and	x8, x9, #0xfffffffffffffffc
	and	w9, w9, #0x2
	ldr	x10, [x8]
	cmp	x10, #34
	ccmp	w9, #0, #0, ne
	b.ne	.LBB274_3
// %bb.1:                               // %B1
	str	x22, [x8]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB274_5
.LBB274_2:                              // %B4
	ldrb	w8, [x19, #2]
	sub	x20, x20, #8
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB274_3:                              // %B7
	ldr	x1, [x23, #8]
	ldrh	w2, [x19]
	mov	x0, x24
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	JS_SetGlobalRef_GC
	tbz	w0, #31, .LBB274_2
// %bb.4:                               // %B8
	b	.Lexception_asm_h
.LBB274_5:                              // %B6
	mov	x0, x22
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #2]
	sub	x20, x20, #8
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end274:
	.size	.Lput_global_ref_0_asm_h, .Lfunc_end274-.Lput_global_ref_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_global_ref_init_0_asm_h
	.type	.Lput_global_ref_init_0_asm_h,@function
.Lput_global_ref_init_0_asm_h:          // @put_global_ref_init_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	ldr	x1, [x23, #8]
	mov	x0, x24
	ldrh	w2, [x19]
	mov	w4, #1                          // =0x1
	str	x20, [x23, #48]
	mov	x3, x22
	bl	JS_SetGlobalRef_GC
	tbnz	w0, #31, .LBB275_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #2]
	sub	x20, x20, #8
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB275_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end275:
	.size	.Lput_global_ref_init_0_asm_h, .Lfunc_end275-.Lput_global_ref_init_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function invalid_1_asm_h
	.type	.Linvalid_1_asm_h,@function
.Linvalid_1_asm_h:                      // @invalid_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #8]
	adrp	x1, .L__unnamed_11
	add	x1, x1, :lo12:.L__unnamed_11
	mov	x0, x24
	mov	w3, wzr
	ldr	x8, [x8, #32]
	ldr	w8, [x8, #8]
	str	x20, [x23, #48]
	mvn	w8, w8
	add	w2, w8, w19
	bl	LEPUS_ThrowInternalError
	b	.Lexception_asm_h
.Lfunc_end276:
	.size	.Linvalid_1_asm_h, .Lfunc_end276-.Linvalid_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i32_1_asm_h
	.type	.Lpush_i32_1_asm_h,@function
.Lpush_i32_1_asm_h:                     // @push_i32_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #4]
	ldr	w9, [x19], #5
	add	w8, w8, #494
	orr	x21, x9, #0xfffe000000000000
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end277:
	.size	.Lpush_i32_1_asm_h, .Lfunc_end277-.Lpush_i32_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_const_1_asm_h
	.type	.Lpush_const_1_asm_h,@function
.Lpush_const_1_asm_h:                   // @push_const_1_asm_h
// %bb.0:                               // %B0
	ldrb	w9, [x19, #4]
	ldr	x8, [x23, #104]
	ldrsw	x10, [x19]
	add	x19, x19, #5
	add	w9, w9, #494
	ldr	x21, [x8, x10, lsl #3]
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end278:
	.size	.Lpush_const_1_asm_h, .Lfunc_end278-.Lpush_const_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function fclosure_1_asm_h
	.type	.Lfclosure_1_asm_h,@function
.Lfclosure_1_asm_h:                     // @fclosure_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lfclosure_0_asm_h
.Lfunc_end279:
	.size	.Lfclosure_1_asm_h, .Lfunc_end279-.Lfclosure_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_atom_value_1_asm_h
	.type	.Lpush_atom_value_1_asm_h,@function
.Lpush_atom_value_1_asm_h:              // @push_atom_value_1_asm_h
// %bb.0:                               // %B13
	ldr	w1, [x19]
	tbnz	w1, #31, .LBB280_5
// %bb.1:                               // %B1
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, sxtw #3]
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, .LBB280_4
// %bb.2:                               // %B9
	ldr	w9, [x8, #8]
	asr	w9, w9, #30
	cmp	w9, #1
	b.ne	.LBB280_5
.LBB280_3:                              // %B7
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	mov	x9, #2                          // =0x2
	movk	x9, #1, lsl #48
	orr	x21, x8, x9
	br	x1
.LBB280_4:                              // %B2
	ldr	x9, [x8, #8]
	ldr	w9, [x9]
	asr	w9, w9, #30
	cmp	w9, #1
	b.eq	.LBB280_3
.LBB280_5:                              // %B10
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB280_7
// %bb.6:                               // %B12
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB280_7:                              // %B11
	b	.Lexception_spill_top0_asm_h
.Lfunc_end280:
	.size	.Lpush_atom_value_1_asm_h, .Lfunc_end280-.Lpush_atom_value_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function private_symbol_1_asm_h
	.type	.Lprivate_symbol_1_asm_h,@function
.Lprivate_symbol_1_asm_h:               // @private_symbol_1_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #4                          // =0x4
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	.LBB281_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB281_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end281:
	.size	.Lprivate_symbol_1_asm_h, .Lfunc_end281-.Lprivate_symbol_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function undefined_1_asm_h
	.type	.Lundefined_1_asm_h,@function
.Lundefined_1_asm_h:                    // @undefined_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w21, #18                        // =0x12
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end282:
	.size	.Lundefined_1_asm_h, .Lfunc_end282-.Lundefined_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function null_1_asm_h
	.type	.Lnull_1_asm_h,@function
.Lnull_1_asm_h:                         // @null_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w21, #2                         // =0x2
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end283:
	.size	.Lnull_1_asm_h, .Lfunc_end283-.Lnull_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_this_1_asm_h
	.type	.Lpush_this_1_asm_h,@function
.Lpush_this_1_asm_h:                    // @push_this_1_asm_h
// %bb.0:                               // %B12
	ldr	w8, [x23, #44]
	ldr	x1, [x23, #80]
	tbnz	w8, #0, .LBB284_2
// %bb.1:                               // %B12
	ldr	x8, [x23, #80]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, .LBB284_3
.LBB284_2:                              // %B3
	ldrb	w8, [x19], #1
	mov	x21, x1
	add	w8, w8, #494
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.LBB284_3:                              // %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	.LBB284_5
// %bb.4:                               // %B7
	ldrb	w8, [x19], #1
	ldr	x21, [x24, #208]
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB284_5:                              // %B9
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB284_7
// %bb.6:                               // %B11
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB284_7:                              // %B10
	b	.Lexception_spill_top0_asm_h
.Lfunc_end284:
	.size	.Lpush_this_1_asm_h, .Lfunc_end284-.Lpush_this_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_false_1_asm_h
	.type	.Lpush_false_1_asm_h,@function
.Lpush_false_1_asm_h:                   // @push_false_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w21, #6                         // =0x6
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end285:
	.size	.Lpush_false_1_asm_h, .Lfunc_end285-.Lpush_false_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_true_1_asm_h
	.type	.Lpush_true_1_asm_h,@function
.Lpush_true_1_asm_h:                    // @push_true_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w21, #7                         // =0x7
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end286:
	.size	.Lpush_true_1_asm_h, .Lfunc_end286-.Lpush_true_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function object_1_asm_h
	.type	.Lobject_1_asm_h,@function
.Lobject_1_asm_h:                       // @object_1_asm_h
// %bb.0:                               // %B16
	ldrb	w8, [x24, #355]
	stp	x19, x20, [sp, #-16]!           // 16-byte Folded Spill
	cbnz	w8, .LBB287_5
// %bb.1:                               // %B1
	ldr	x19, [x24, #392]
	cbz	x19, .LBB287_5
// %bb.2:                               // %B5
	mov	x8, x20
	mov	x0, x24
	mov	w1, #64                         // =0x40
	mov	w2, #2                          // =0x2
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	prim_try_malloc_gc
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	mov	x10, x0
	cbz	x10, .LBB287_5
// %bb.3:                               // %B7
	ldr	w8, [x19]
	mov	w9, #1                          // =0x1
	add	w8, w8, #1
	str	w8, [x19]
	add	x8, x10, #8
	str	w9, [x10]
	strb	w9, [x10, #5]
	strh	w9, [x10, #6]
	stlr	x19, [x8]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB287_7
.LBB287_4:                              // %B9
	add	x8, x10, #32
	ldr	x19, [sp]                       // 8-byte Folded Reload
	mov	x21, x10
	str	x8, [x10, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
.LBB287_5:                              // %B13
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	.LBB287_8
// %bb.6:                               // %B15
	ldp	x19, x20, [sp]                  // 16-byte Folded Reload
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
.LBB287_7:                              // %B11
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x19, x8
	mov	x19, x10
	bl	prim_WriteBarrierNoStore
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	mov	x10, x19
	b	.LBB287_4
.LBB287_8:                              // %B14
	ldp	x19, x20, [sp], #16             // 16-byte Folded Reload
	b	.Lexception_spill_top0_asm_h
.Lfunc_end287:
	.size	.Lobject_1_asm_h, .Lfunc_end287-.Lobject_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function special_object_1_asm_h
	.type	.Lspecial_object_1_asm_h,@function
.Lspecial_object_1_asm_h:               // @special_object_1_asm_h
// %bb.0:                               // %B12
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	.LBB288_5
// %bb.1:                               // %B12
	cbz	w8, .LBB288_8
// %bb.2:                               // %B12
	cmp	w8, #1
	b.ne	.LBB288_10
// %bb.3:                               // %B2
	ldr	x8, [x23, #8]
	ldr	w1, [x23, #112]
	mov	x9, x20
	mov	x0, x24
	mov	x2, x28
	mov	x3, x23
	ldr	x8, [x8, #32]
	ldrh	w8, [x8, #40]
	str	x22, [x9], #8
	str	x9, [x23, #48]
	cmp	w8, w1
	csel	w4, w8, w1, lt
	bl	js_build_mapped_arguments_gc
	cmp	x0, #130
	b.eq	.LBB288_12
.LBB288_4:
	mov	x8, x0
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB288_5:                              // %B12
	cmp	w8, #3
	b.eq	.LBB288_9
// %bb.6:                               // %B12
	cmp	w8, #4
	b.ne	.LBB288_11
// %bb.7:                               // %B6
	ldr	x8, [x23, #8]
	mov	w9, #18                         // =0x12
	ldr	x8, [x8, #48]
	cmp	x8, #0
	csel	x8, x9, x8, eq
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB288_8:                              // %B13
	str	x22, [x20], #8
	b	.LFastBuildArguments_asm_h
.LBB288_9:                              // %B16
	ldr	x8, [x23, #88]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB288_10:                             // %B15
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB288_11:                             // %B9
	mov	x8, x20
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_NewObjectProto_GC
	cmp	x0, #130
	b.ne	.LBB288_4
.LBB288_12:                             // %B10
	b	.Lexception_spill_top0_asm_h
.Lfunc_end288:
	.size	.Lspecial_object_1_asm_h, .Lfunc_end288-.Lspecial_object_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rest_1_asm_h
	.type	.Lrest_1_asm_h,@function
.Lrest_1_asm_h:                         // @rest_1_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x23, #112]
	ldrh	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x3, x28
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	js_build_rest_gc
	cmp	x0, #130
	b.eq	.LBB289_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB289_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end289:
	.size	.Lrest_1_asm_h, .Lfunc_end289-.Lrest_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function drop_1_asm_h
	.type	.Ldrop_1_asm_h,@function
.Ldrop_1_asm_h:                         // @drop_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end290:
	.size	.Ldrop_1_asm_h, .Lfunc_end290-.Ldrop_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nip_1_asm_h
	.type	.Lnip_1_asm_h,@function
.Lnip_1_asm_h:                          // @nip_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end291:
	.size	.Lnip_1_asm_h, .Lfunc_end291-.Lnip_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nip1_1_asm_h
	.type	.Lnip1_1_asm_h,@function
.Lnip1_1_asm_h:                         // @nip1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	sub	x8, x20, #16
	mov	x20, x8
	br	x1
.Lfunc_end292:
	.size	.Lnip1_1_asm_h, .Lfunc_end292-.Lnip1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup_1_asm_h
	.type	.Ldup_1_asm_h,@function
.Ldup_1_asm_h:                          // @dup_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end293:
	.size	.Ldup_1_asm_h, .Lfunc_end293-.Ldup_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup1_1_asm_h
	.type	.Ldup1_1_asm_h,@function
.Ldup1_1_asm_h:                         // @dup1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	w8, w8, #494
	ldr	x2, [x25, w8, uxtw #3]
	mov	x1, x22
	mov	x22, x21
	mov	x22, x1
	br	x2
.Lfunc_end294:
	.size	.Ldup1_1_asm_h, .Lfunc_end294-.Ldup1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup2_1_asm_h
	.type	.Ldup2_1_asm_h,@function
.Ldup2_1_asm_h:                         // @dup2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20]
	mov	x21, x22
	ldrb	w8, [x19], #1
	ldr	x22, [x20], #8
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end295:
	.size	.Ldup2_1_asm_h, .Lfunc_end295-.Ldup2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup3_1_asm_h
	.type	.Ldup3_1_asm_h,@function
.Ldup3_1_asm_h:                         // @dup3_1_asm_h
// %bb.0:                               // %B0
	ldur	x8, [x20, #-16]
	mov	x21, x22
	stp	x22, x8, [x20], #16
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end296:
	.size	.Ldup3_1_asm_h, .Lfunc_end296-.Ldup3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function insert2_1_asm_h
	.type	.Linsert2_1_asm_h,@function
.Linsert2_1_asm_h:                      // @insert2_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x21, [x20, #-8]
	ldrb	w8, [x19], #1
	mov	x1, x22
	mov	x22, x21
	add	w8, w8, #494
	mov	x22, x1
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.Lfunc_end297:
	.size	.Linsert2_1_asm_h, .Lfunc_end297-.Linsert2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function insert3_1_asm_h
	.type	.Linsert3_1_asm_h,@function
.Linsert3_1_asm_h:                      // @insert3_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldp	x8, x22, [x20, #-16]
	stp	x21, x8, [x20, #-16]
	mov	x2, x22
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x22, x2
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end298:
	.size	.Linsert3_1_asm_h, .Lfunc_end298-.Linsert3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function insert4_1_asm_h
	.type	.Linsert4_1_asm_h,@function
.Linsert4_1_asm_h:                      // @insert4_1_asm_h
// %bb.0:                               // %B0
	ldp	x9, x8, [x20, #-24]
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x21, [x20, #-24]
	stp	x9, x8, [x20, #-16]
	mov	x1, x22
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x22, x1
	add	w8, w8, #494
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.Lfunc_end299:
	.size	.Linsert4_1_asm_h, .Lfunc_end299-.Linsert4_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function perm3_1_asm_h
	.type	.Lperm3_1_asm_h,@function
.Lperm3_1_asm_h:                        // @perm3_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end300:
	.size	.Lperm3_1_asm_h, .Lfunc_end300-.Lperm3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function perm4_1_asm_h
	.type	.Lperm4_1_asm_h,@function
.Lperm4_1_asm_h:                        // @perm4_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	mov	x9, x22
	ldp	x8, x22, [x20, #-16]
	stp	x9, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end301:
	.size	.Lperm4_1_asm_h, .Lfunc_end301-.Lperm4_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function perm5_1_asm_h
	.type	.Lperm5_1_asm_h,@function
.Lperm5_1_asm_h:                        // @perm5_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldp	x9, x8, [x20, #-24]
	mov	x10, x22
	ldur	x22, [x20, #-8]
	stur	x10, [x20, #-24]
	stp	x9, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end302:
	.size	.Lperm5_1_asm_h, .Lfunc_end302-.Lperm5_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function swap_1_asm_h
	.type	.Lswap_1_asm_h,@function
.Lswap_1_asm_h:                         // @swap_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	add	w8, w8, #494
	ldr	x2, [x25, w8, uxtw #3]
	mov	x1, x22
	mov	x22, x21
	mov	x21, x1
	br	x2
.Lfunc_end303:
	.size	.Lswap_1_asm_h, .Lfunc_end303-.Lswap_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function swap2_1_asm_h
	.type	.Lswap2_1_asm_h,@function
.Lswap2_1_asm_h:                        // @swap2_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldp	x8, x9, [x20, #-16]
	stp	x22, x21, [x20, #-16]
	ldrb	w10, [x19], #1
	mov	x22, x8
	mov	x21, x9
	add	w10, w10, #494
	ldr	x1, [x25, w10, uxtw #3]
	br	x1
.Lfunc_end304:
	.size	.Lswap2_1_asm_h, .Lfunc_end304-.Lswap2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rot3l_1_asm_h
	.type	.Lrot3l_1_asm_h,@function
.Lrot3l_1_asm_h:                        // @rot3l_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldur	x8, [x20, #-8]
	stur	x22, [x20, #-8]
	mov	x22, x21
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end305:
	.size	.Lrot3l_1_asm_h, .Lfunc_end305-.Lrot3l_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rot3r_1_asm_h
	.type	.Lrot3r_1_asm_h,@function
.Lrot3r_1_asm_h:                        // @rot3r_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	mov	x8, x21
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end306:
	.size	.Lrot3r_1_asm_h, .Lfunc_end306-.Lrot3r_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rot4l_1_asm_h
	.type	.Lrot4l_1_asm_h,@function
.Lrot4l_1_asm_h:                        // @rot4l_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldp	x9, x8, [x20, #-16]
	stp	x8, x22, [x20, #-16]
	mov	x22, x21
	mov	x21, x9
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end307:
	.size	.Lrot4l_1_asm_h, .Lfunc_end307-.Lrot4l_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rot5l_1_asm_h
	.type	.Lrot5l_1_asm_h,@function
.Lrot5l_1_asm_h:                        // @rot5l_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldp	x8, x9, [x20, #-16]
	ldur	x10, [x20, #-24]
	stur	x22, [x20, #-8]
	mov	x22, x21
	mov	x21, x10
	stp	x8, x9, [x20, #-24]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end308:
	.size	.Lrot5l_1_asm_h, .Lfunc_end308-.Lrot5l_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_constructor_1_asm_h
	.type	.Lcall_constructor_1_asm_h,@function
.Lcall_constructor_1_asm_h:             // @call_constructor_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcall_constructor_0_asm_h
.Lfunc_end309:
	.size	.Lcall_constructor_1_asm_h, .Lfunc_end309-.Lcall_constructor_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_1_asm_h
	.type	.Lcall_1_asm_h,@function
.Lcall_1_asm_h:                         // @call_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcall_0_asm_h
.Lfunc_end310:
	.size	.Lcall_1_asm_h, .Lfunc_end310-.Lcall_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function tail_call_1_asm_h
	.type	.Ltail_call_1_asm_h,@function
.Ltail_call_1_asm_h:                    // @tail_call_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ltail_call_0_asm_h
.Lfunc_end311:
	.size	.Ltail_call_1_asm_h, .Lfunc_end311-.Ltail_call_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_method_1_asm_h
	.type	.Lcall_method_1_asm_h,@function
.Lcall_method_1_asm_h:                  // @call_method_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcall_method_0_asm_h
.Lfunc_end312:
	.size	.Lcall_method_1_asm_h, .Lfunc_end312-.Lcall_method_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function tail_call_method_1_asm_h
	.type	.Ltail_call_method_1_asm_h,@function
.Ltail_call_method_1_asm_h:             // @tail_call_method_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ltail_call_method_0_asm_h
.Lfunc_end313:
	.size	.Ltail_call_method_1_asm_h, .Lfunc_end313-.Ltail_call_method_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function array_from_1_asm_h
	.type	.Larray_from_1_asm_h,@function
.Larray_from_1_asm_h:                   // @array_from_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Larray_from_0_asm_h
.Lfunc_end314:
	.size	.Larray_from_1_asm_h, .Lfunc_end314-.Larray_from_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function apply_1_asm_h
	.type	.Lapply_1_asm_h,@function
.Lapply_1_asm_h:                        // @apply_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lapply_0_asm_h
.Lfunc_end315:
	.size	.Lapply_1_asm_h, .Lfunc_end315-.Lapply_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_1_asm_h
	.type	.Lreturn_1_asm_h,@function
.Lreturn_1_asm_h:                       // @return_1_asm_h
// %bb.0:                               // %B0
	mov	x0, x22
	b	.Lcommon_return_asm_h
.Lfunc_end316:
	.size	.Lreturn_1_asm_h, .Lfunc_end316-.Lreturn_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_undef_1_asm_h
	.type	.Lreturn_undef_1_asm_h,@function
.Lreturn_undef_1_asm_h:                 // @return_undef_1_asm_h
// %bb.0:                               // %B0
	mov	w0, #18                         // =0x12
	b	.Lcommon_return_asm_h
.Lfunc_end317:
	.size	.Lreturn_undef_1_asm_h, .Lfunc_end317-.Lreturn_undef_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_ctor_return_1_asm_h
	.type	.Lcheck_ctor_return_1_asm_h,@function
.Lcheck_ctor_return_1_asm_h:            // @check_ctor_return_1_asm_h
// %bb.0:                               // %B5
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	.LBB318_3
// %bb.1:                               // %B2
	cmp	x22, #18
	b.eq	.LBB318_4
// %bb.2:                               // %B3
	mov	x8, x20
	adrp	x1, .L__unnamed_12
	add	x1, x1, :lo12:.L__unnamed_12
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	LEPUS_ThrowTypeError
	b	.Lexception_spill_top0_asm_h
.LBB318_3:                              // %B6
	ldrb	w8, [x19], #1
	mov	w21, #6                         // =0x6
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB318_4:                              // %B4
	ldrb	w8, [x19], #1
	mov	w21, #7                         // =0x7
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end318:
	.size	.Lcheck_ctor_return_1_asm_h, .Lfunc_end318-.Lcheck_ctor_return_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_ctor_1_asm_h
	.type	.Lcheck_ctor_1_asm_h,@function
.Lcheck_ctor_1_asm_h:                   // @check_ctor_1_asm_h
// %bb.0:                               // %B2
	ldr	x8, [x23, #88]
	cmp	x8, #18
	b.ne	.LBB319_2
// %bb.1:                               // %B3
	mov	x8, x20
	adrp	x1, .L__unnamed_13
	add	x1, x1, :lo12:.L__unnamed_13
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	LEPUS_ThrowTypeError
	b	.Lexception_spill_top0_asm_h
.LBB319_2:                              // %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end319:
	.size	.Lcheck_ctor_1_asm_h, .Lfunc_end319-.Lcheck_ctor_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_brand_1_asm_h
	.type	.Lcheck_brand_1_asm_h,@function
.Lcheck_brand_1_asm_h:                  // @check_brand_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #48]
	bl	JS_CheckBrand_GC
	tbnz	w0, #31, .LBB320_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB320_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end320:
	.size	.Lcheck_brand_1_asm_h, .Lfunc_end320-.Lcheck_brand_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_brand_1_asm_h
	.type	.Ladd_brand_1_asm_h,@function
.Ladd_brand_1_asm_h:                    // @add_brand_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #48]
	bl	JS_AddBrand_GC
	tbnz	w0, #31, .LBB321_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB321_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end321:
	.size	.Ladd_brand_1_asm_h, .Lfunc_end321-.Ladd_brand_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_async_1_asm_h
	.type	.Lreturn_async_1_asm_h,@function
.Lreturn_async_1_asm_h:                 // @return_async_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lreturn_async_0_asm_h
.Lfunc_end322:
	.size	.Lreturn_async_1_asm_h, .Lfunc_end322-.Lreturn_async_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function throw_1_asm_h
	.type	.Lthrow_1_asm_h,@function
.Lthrow_1_asm_h:                        // @throw_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lthrow_0_asm_h
.Lfunc_end323:
	.size	.Lthrow_1_asm_h, .Lfunc_end323-.Lthrow_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function throw_var_1_asm_h
	.type	.Lthrow_var_1_asm_h,@function
.Lthrow_var_1_asm_h:                    // @throw_var_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lthrow_var_0_asm_h
.Lfunc_end324:
	.size	.Lthrow_var_1_asm_h, .Lfunc_end324-.Lthrow_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function eval_1_asm_h
	.type	.Leval_1_asm_h,@function
.Leval_1_asm_h:                         // @eval_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Leval_0_asm_h
.Lfunc_end325:
	.size	.Leval_1_asm_h, .Lfunc_end325-.Leval_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function regexp_1_asm_h
	.type	.Lregexp_1_asm_h,@function
.Lregexp_1_asm_h:                       // @regexp_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	w1, #18                         // =0x12
	mov	x3, x21
	mov	x2, x22
	str	x21, [x20]
	str	x8, [x23, #48]
	bl	js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	.LBB326_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB326_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end326:
	.size	.Lregexp_1_asm_h, .Lfunc_end326-.Lregexp_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_super_ctor_1_asm_h
	.type	.Lget_super_ctor_1_asm_h,@function
.Lget_super_ctor_1_asm_h:               // @get_super_ctor_1_asm_h
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	.LBB327_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB327_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end327:
	.size	.Lget_super_ctor_1_asm_h, .Lfunc_end327-.Lget_super_ctor_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_super_1_asm_h
	.type	.Lget_super_1_asm_h,@function
.Lget_super_1_asm_h:                    // @get_super_1_asm_h
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetPrototype_GC
	cmp	x0, #130
	b.eq	.LBB328_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB328_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end328:
	.size	.Lget_super_1_asm_h, .Lfunc_end328-.Lget_super_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function import_1_asm_h
	.type	.Limport_1_asm_h,@function
.Limport_1_asm_h:                       // @import_1_asm_h
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	js_dynamic_import
	cmp	x0, #130
	b.eq	.LBB329_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB329_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end329:
	.size	.Limport_1_asm_h, .Lfunc_end329-.Limport_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_var_1_asm_h
	.type	.Lcheck_var_1_asm_h,@function
.Lcheck_var_1_asm_h:                    // @check_var_1_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_CheckGlobalVar_GC
	tbnz	w0, #31, .LBB330_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x21, x8, ne
	br	x1
.LBB330_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end330:
	.size	.Lcheck_var_1_asm_h, .Lfunc_end330-.Lcheck_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_undef_1_asm_h
	.type	.Lget_var_undef_1_asm_h,@function
.Lget_var_undef_1_asm_h:                // @get_var_undef_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x24, #216]
	ldr	w9, [x19]
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x10, x10, #64
	lsl	w12, w11, #2
	and	w11, w9, w11
	ldr	w11, [x10, w11, sxtw #2]
	add	w12, w12, #4
	add	x10, x10, x12
	cbz	w11, .LBB331_3
.LBB331_1:                              // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	.LBB331_9
// %bb.2:                               // %B15
                                        //   in Loop: Header=BB331_1 Depth=1
	and	w11, w12, #0x3ffffff
	cbnz	w11, .LBB331_1
.LBB331_3:                              // %B18
	ldr	x8, [x24, #208]
	mov	w10, #18                        // =0x12
.LBB331_4:                              // %B36
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB331_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w9, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, .LBB331_7
.LBB331_5:                              // %B25
                                        //   Parent Loop BB331_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w9
	b.eq	.LBB331_10
// %bb.6:                               // %B27
                                        //   in Loop: Header=BB331_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB331_5
.LBB331_7:                              // %B30
                                        //   in Loop: Header=BB331_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	.LBB331_15
// %bb.8:                               // %B33
                                        //   in Loop: Header=BB331_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB331_4
	b	.LBB331_13
.LBB331_9:                              // %B10
	lsr	w9, w12, #26
	b	.LBB331_11
.LBB331_10:                             // %B19
	lsr	w9, w13, #26
.LBB331_11:                             // %B19
	tst	w9, #0x30
	b.ne	.LBB331_15
// %bb.12:                              // %B14.sink.split
	ldr	x8, [x8, #16]
	sub	w9, w11, #1
	ldr	x10, [x8, w9, sxtw #3]
.LBB331_13:                             // %B14
	cmp	x10, #34
	b.eq	.LBB331_17
// %bb.14:                              // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x10
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB331_15:                             // %B7
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB331_18
// %bb.16:                              // %B9
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB331_17:                             // %B3
	str	x22, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.LBB331_18:                             // %B8
	b	.Lexception_spill_top0_asm_h
.Lfunc_end331:
	.size	.Lget_var_undef_1_asm_h, .Lfunc_end331-.Lget_var_undef_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_1_asm_h
	.type	.Lget_var_1_asm_h,@function
.Lget_var_1_asm_h:                      // @get_var_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x24, #216]
	ldr	w9, [x19]
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w9, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB332_3
.LBB332_1:                              // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	.LBB332_9
// %bb.2:                               // %B15
                                        //   in Loop: Header=BB332_1 Depth=1
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB332_1
.LBB332_3:                              // %B18
	ldr	x8, [x24, #208]
.LBB332_4:                              // %B35
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB332_5 Depth 2
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w9, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB332_7
.LBB332_5:                              // %B24
                                        //   Parent Loop BB332_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	.LBB332_9
// %bb.6:                               // %B26
                                        //   in Loop: Header=BB332_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB332_5
.LBB332_7:                              // %B29
                                        //   in Loop: Header=BB332_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB332_12
// %bb.8:                               // %B32
                                        //   in Loop: Header=BB332_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB332_4
	b	.LBB332_12
.LBB332_9:                              // %B19
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	.LBB332_12
// %bb.10:                              // %B14
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	.LBB332_14
// %bb.11:                              // %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB332_12:                             // %B7
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB332_15
// %bb.13:                              // %B9
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB332_14:                             // %B3
	str	x22, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.LBB332_15:                             // %B8
	b	.Lexception_spill_top0_asm_h
.Lfunc_end332:
	.size	.Lget_var_1_asm_h, .Lfunc_end332-.Lget_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_1_asm_h
	.type	.Lput_var_1_asm_h,@function
.Lput_var_1_asm_h:                      // @put_var_1_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	w3, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_SetGlobalVar_GC
	tbnz	w0, #31, .LBB333_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB333_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end333:
	.size	.Lput_var_1_asm_h, .Lfunc_end333-.Lput_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_init_1_asm_h
	.type	.Lput_var_init_1_asm_h,@function
.Lput_var_init_1_asm_h:                 // @put_var_init_1_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	w3, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_SetGlobalVar_GC
	tbnz	w0, #31, .LBB334_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB334_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end334:
	.size	.Lput_var_init_1_asm_h, .Lfunc_end334-.Lput_var_init_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_strict_1_asm_h
	.type	.Lput_var_strict_1_asm_h,@function
.Lput_var_strict_1_asm_h:               // @put_var_strict_1_asm_h
// %bb.0:                               // %B5
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	cmp	x22, #7
	b.ne	.LBB335_3
// %bb.1:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          // =0x2
	stur	x21, [x8, #-8]
	str	x8, [x23, #48]
	bl	JS_SetGlobalVar_GC
	tbnz	w0, #31, .LBB335_4
// %bb.2:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB335_3:                              // %B6
	ldr	w1, [x19]
	mov	x0, x24
	str	x21, [x20]
	str	x8, [x23, #48]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB335_4:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end335:
	.size	.Lput_var_strict_1_asm_h, .Lfunc_end335-.Lput_var_strict_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_ref_value_1_asm_h
	.type	.Lget_ref_value_1_asm_h,@function
.Lget_ref_value_1_asm_h:                // @get_ref_value_1_asm_h
// %bb.0:                               // %B49
	mov	x21, x22
	ldur	x22, [x20, #-8]
	cmp	x22, #18
	b.eq	.LBB336_7
// %bb.1:                               // %B1
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB336_5
// %bb.2:                               // %B39
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	.LBB336_5
// %bb.3:                               // %B3
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB336_5
// %bb.4:                               // %B3
	mov	x9, #2                          // =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	.LBB336_10
.LBB336_5:                              // %B43
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB336_9
// %bb.6:                               // %B45
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB336_7:                              // %B46
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB336_9
// %bb.8:                               // %B48
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB336_9:                              // %B47
	b	.Lexception_spill_top1_asm_h
.LBB336_10:                             // %B9
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, .LBB336_22
// %bb.11:                              // %B37
	ldr	w8, [x1, #8]
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	.LBB336_5
.LBB336_12:                             // %B11
	ldr	x0, [x24, #8]
	bl	prim_get_interned_non_index_atom
	cbz	w0, .LBB336_5
// %bb.13:                              // %B14.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB336_14:                             // %B14
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB336_15 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB336_17
.LBB336_15:                             // %B25
                                        //   Parent Loop BB336_14 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	.LBB336_19
// %bb.16:                              // %B30
                                        //   in Loop: Header=BB336_15 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB336_15
.LBB336_17:                             // %B16
                                        //   in Loop: Header=BB336_14 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB336_5
// %bb.18:                              // %B19
                                        //   in Loop: Header=BB336_14 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB336_14
	b	.LBB336_21
.LBB336_19:                             // %B27
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB336_5
// %bb.20:                              // %B28
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB336_21:                             // %B22
	ldrb	w9, [x19], #1
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB336_22:                             // %B10
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
	asr	w8, w8, #30
	cmp	w8, #1
	b.eq	.LBB336_12
	b	.LBB336_5
.Lfunc_end336:
	.size	.Lget_ref_value_1_asm_h, .Lfunc_end336-.Lget_ref_value_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_ref_value_1_asm_h
	.type	.Lput_ref_value_1_asm_h,@function
.Lput_ref_value_1_asm_h:                // @put_ref_value_1_asm_h
// %bb.0:                               // %B103
	sub	sp, sp, #32
	mov	x21, x22
	ldp	x10, x22, [x20, #-16]
	cmp	x10, #18
	b.eq	.LBB337_7
// %bb.1:                               // %B1
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x10, x8
	b.ne	.LBB337_5
.LBB337_2:                              // %B89
	ldrh	w8, [x10, #6]
	cmp	w8, #1
	b.ne	.LBB337_5
// %bb.3:                               // %B3
	ldr	w8, [x10, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB337_5
// %bb.4:                               // %B3
	mov	x9, #2                          // =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	.LBB337_9
.LBB337_5:                              // %B93
	mov	x8, x20
	mov	x0, x24
	mov	x1, x10
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_SetPropertyValue_GC
	tbnz	w0, #31, .LBB337_45
// %bb.6:                               // %B95
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
.LBB337_7:                              // %B99
	ldrb	w8, [x23, #44]
	tbnz	w8, #0, .LBB337_34
// %bb.8:                               // %B100
	ldr	x10, [x24, #208]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x10, x8
	b.eq	.LBB337_2
	b	.LBB337_5
.LBB337_9:                              // %B9
	and	x1, x22, #0xfffffffffffc
	stp	x10, x20, [sp, #16]             // 16-byte Folded Spill
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, .LBB337_36
// %bb.10:                              // %B87
	ldr	w8, [x1, #8]
	asr	w8, w8, #30
	ldp	x10, x20, [sp, #16]             // 16-byte Folded Reload
	cmp	w8, #1
	b.ne	.LBB337_5
.LBB337_11:                             // %B11
	ldr	x0, [x24, #8]
	bl	prim_get_interned_non_index_atom
	ldp	x10, x20, [sp, #16]             // 16-byte Folded Reload
	cbz	w0, .LBB337_5
// %bb.12:                              // %B13
	ldr	x8, [x10, #8]
	str	w0, [sp, #12]                   // 4-byte Folded Spill
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w0, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, .LBB337_15
.LBB337_13:                             // %B16
                                        // =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	.LBB337_21
// %bb.14:                              // %B26
                                        //   in Loop: Header=BB337_13 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, .LBB337_13
.LBB337_15:                             // %B28.preheader
	ldp	x8, x20, [sp, #16]              // 16-byte Folded Reload
.LBB337_16:                             // %B28
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB337_17 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w0, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, .LBB337_19
.LBB337_17:                             // %B64
                                        //   Parent Loop BB337_16 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	.LBB337_24
// %bb.18:                              // %B69
                                        //   in Loop: Header=BB337_17 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB337_17
.LBB337_19:                             // %B29
                                        //   in Loop: Header=BB337_16 Depth=1
	ldr	w9, [x8, #4]
	ldr	x10, [sp, #16]                  // 8-byte Folded Reload
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	.LBB337_5
// %bb.20:                              // %B58
                                        //   in Loop: Header=BB337_16 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB337_16
	b	.LBB337_25
.LBB337_21:                             // %B18
	mov	w9, #58                         // =0x3a
	and	w9, w9, w10, lsr #26
	ldp	x10, x20, [sp, #16]             // 16-byte Folded Reload
	cmp	w9, #2
	b.ne	.LBB337_5
// %bb.22:                              // %B22
	ldr	x9, [x10, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB337_43
.LBB337_23:                             // %B39
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #32
	br	x1
.LBB337_24:                             // %B66
	mov	w8, #58                         // =0x3a
	and	w8, w8, w10, lsr #26
	ldp	x10, x20, [sp, #16]             // 16-byte Folded Reload
	cmp	w8, #2
	b.ne	.LBB337_5
.LBB337_25:                             // %B32
	ldr	w8, [x10, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	.LBB337_5
// %bb.26:                              // %B51
	ldr	x20, [x10, #8]
	ldr	x8, [x20, #40]
	str	x8, [sp]                        // 8-byte Folded Spill
	cbz	x8, .LBB337_31
// %bb.27:                              // %B34
	ldr	x10, [sp, #16]                  // 8-byte Folded Reload
	ldr	x9, [sp]                        // 8-byte Folded Reload
	ldr	w11, [x20, #16]
	ldr	x8, [x10, #16]
	ldr	w9, [x9, #16]
	add	x10, x10, #32
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	.LBB337_29
// %bb.28:                              // %B34
	cbz	w8, .LBB337_41
.LBB337_29:                             // %B44
	ldr	w8, [x20, #48]
	cmp	w8, w0
	b.ne	.LBB337_31
// %bb.30:                              // %B44
	ldrb	w8, [x20, #52]
	cmp	w8, #7
	b.eq	.LBB337_38
.LBB337_31:                             // %B73
	ldr	x0, [x24, #8]
	ldr	w2, [sp, #12]                   // 4-byte Folded Reload
	mov	x1, x20
	mov	w3, #7                          // =0x7
	bl	find_hashed_shape_prop_gc
	cbz	x0, .LBB337_41
// %bb.32:                              // %B55
	ldr	x10, [sp, #16]                  // 8-byte Folded Reload
	ldr	w9, [x0, #16]
	ldr	w11, [x20, #16]
	ldr	x8, [x10, #16]
	add	x10, x10, #32
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	.LBB337_37
// %bb.33:
	str	x0, [sp]                        // 8-byte Folded Spill
	b	.LBB337_38
.LBB337_34:                             // %B96
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB337_45
// %bb.35:                              // %B98
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_ThrowReferenceErrorNotDefined_GC
	add	sp, sp, #32
	b	.Lexception_spill_top1_asm_h
.LBB337_36:                             // %B10
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
	asr	w8, w8, #30
	ldp	x10, x20, [sp, #16]             // 16-byte Folded Reload
	cmp	w8, #1
	b.eq	.LBB337_11
	b	.LBB337_5
.LBB337_37:                             // %B55
	str	x0, [sp]                        // 8-byte Folded Spill
	cbz	w8, .LBB337_41
.LBB337_38:                             // %B36
	ldr	x10, [sp]                       // 8-byte Folded Reload
	ldr	x9, [sp, #16]                   // 8-byte Folded Reload
	ldr	w8, [x10]
	add	x9, x9, #8
	add	w8, w8, #1
	str	w8, [x10]
	ldr	w8, [x20]
	sub	w8, w8, #1
	str	w8, [x20]
	stlr	x10, [x9]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB337_40
// %bb.39:                              // %B43
	ldr	x9, [sp]                        // 8-byte Folded Reload
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	prim_WriteBarrierNoStore
.LBB337_40:                             // %B40
	ldr	x8, [sp]                        // 8-byte Folded Reload
	ldr	x9, [sp, #16]                   // 8-byte Folded Reload
	ldr	w8, [x8, #20]
	ldr	x9, [x9, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB337_23
	b	.LBB337_43
.LBB337_41:                             // %B76
	ldp	x1, x8, [sp, #16]               // 16-byte Folded Reload
	mov	x0, x24
	ldr	w2, [sp, #12]                   // 4-byte Folded Reload
	mov	w3, #7                          // =0x7
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	add_property_gc
	cbz	x0, .LBB337_44
// %bb.42:                              // %B80
	str	x21, [x0]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB337_23
.LBB337_43:                             // %B42
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #32
	br	x1
.LBB337_44:                             // %B77
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	sub	x20, x8, #16
.LBB337_45:                             // %B97
	add	sp, sp, #32
	b	.Lexception_spill_top1_asm_h
.Lfunc_end337:
	.size	.Lput_ref_value_1_asm_h, .Lfunc_end337-.Lput_ref_value_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_var_1_asm_h
	.type	.Ldefine_var_1_asm_h,@function
.Ldefine_var_1_asm_h:                   // @define_var_1_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_DefineGlobalVar_GC
	tbnz	w0, #31, .LBB338_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB338_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end338:
	.size	.Ldefine_var_1_asm_h, .Lfunc_end338-.Ldefine_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_define_var_1_asm_h
	.type	.Lcheck_define_var_1_asm_h,@function
.Lcheck_define_var_1_asm_h:             // @check_define_var_1_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, .LBB339_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB339_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end339:
	.size	.Lcheck_define_var_1_asm_h, .Lfunc_end339-.Lcheck_define_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_func_1_asm_h
	.type	.Ldefine_func_1_asm_h,@function
.Ldefine_func_1_asm_h:                  // @define_func_1_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w3, [x19, #4]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_DefineGlobalFunction_GC
	tbnz	w0, #31, .LBB340_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB340_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end340:
	.size	.Ldefine_func_1_asm_h, .Lfunc_end340-.Ldefine_func_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_field_1_asm_h
	.type	.Lget_field_1_asm_h,@function
.Lget_field_1_asm_h:                    // @get_field_1_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB341_10
// %bb.1:                               // %B25
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB341_2:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB341_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB341_5
.LBB341_3:                              // %B1
                                        //   Parent Loop BB341_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	.LBB341_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB341_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB341_3
.LBB341_5:                              // %B14
                                        //   in Loop: Header=BB341_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB341_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB341_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB341_2
	b	.LBB341_9
.LBB341_7:                              // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB341_10
// %bb.8:                               // %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB341_9:                              // %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB341_10:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB341_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB341_12:                             // %B22
	b	.Lexception_spill_top0_asm_h
.Lfunc_end341:
	.size	.Lget_field_1_asm_h, .Lfunc_end341-.Lget_field_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_field2_1_asm_h
	.type	.Lget_field2_1_asm_h,@function
.Lget_field2_1_asm_h:                   // @get_field2_1_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB342_10
// %bb.1:                               // %B25
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB342_2:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB342_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB342_5
.LBB342_3:                              // %B1
                                        //   Parent Loop BB342_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	.LBB342_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB342_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB342_3
.LBB342_5:                              // %B14
                                        //   in Loop: Header=BB342_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB342_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB342_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB342_2
	b	.LBB342_9
.LBB342_7:                              // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB342_10
// %bb.8:                               // %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB342_9:                              // %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB342_10:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB342_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB342_12:                             // %B22
	b	.Lexception_spill_top0_asm_h
.Lfunc_end342:
	.size	.Lget_field2_1_asm_h, .Lfunc_end342-.Lget_field2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_field_1_asm_h
	.type	.Lput_field_1_asm_h,@function
.Lput_field_1_asm_h:                    // @put_field_1_asm_h
// %bb.0:                               // %B80
	sub	sp, sp, #16
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	mov	x12, x20
	movk	x8, #65535, lsl #48
	ldr	w20, [x19]
	tst	x22, x8
	b.ne	.LBB343_25
// %bb.1:                               // %B81
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w20, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, .LBB343_4
.LBB343_2:                              // %B1
                                        // =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w20
	b.eq	.LBB343_10
// %bb.3:                               // %B12
                                        //   in Loop: Header=BB343_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, .LBB343_2
.LBB343_4:                              // %B17.preheader
	mov	x8, x22
.LBB343_5:                              // %B17
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB343_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w20, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, .LBB343_8
.LBB343_6:                              // %B18
                                        //   Parent Loop BB343_5 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w20
	b.eq	.LBB343_13
// %bb.7:                               // %B59
                                        //   in Loop: Header=BB343_6 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB343_6
.LBB343_8:                              // %B66
                                        //   in Loop: Header=BB343_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	.LBB343_25
// %bb.9:                               // %B63
                                        //   in Loop: Header=BB343_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB343_5
	b	.LBB343_14
.LBB343_10:                             // %B3
	mov	w9, #58                         // =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	.LBB343_25
// %bb.11:                              // %B7
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB343_27
// %bb.12:                              // %B5
	ldrb	w8, [x19, #4]
	sub	x20, x12, #8
	ldr	x1, [x25, x8, lsl #3]
	add	x19, x19, #5
	add	sp, sp, #16
	br	x1
.LBB343_13:                             // %B20
	mov	w8, #58                         // =0x3a
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	.LBB343_25
.LBB343_14:                             // %B23
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	.LBB343_25
// %bb.15:                              // %B25
	ldrh	w8, [x22, #6]
	str	x19, [sp, #8]                   // 8-byte Folded Spill
	cmp	w8, #1
	b.ne	.LBB343_34
// %bb.16:                              // %B25
	tbnz	w20, #31, .LBB343_34
// %bb.17:                              // %B54
	ldr	x19, [x22, #8]
	ldr	x13, [x19, #40]
	cbz	x13, .LBB343_28
// %bb.18:                              // %B32
	ldr	x8, [x22, #16]
	ldr	w9, [x13, #16]
	add	x10, x22, #32
	ldr	w11, [x19, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	.LBB343_20
// %bb.19:                              // %B32
	cbz	w8, .LBB343_34
.LBB343_20:                             // %B42
	ldr	w8, [x19, #48]
	cmp	w8, w20
	b.ne	.LBB343_28
// %bb.21:                              // %B42
	ldrb	w8, [x19, #52]
	cmp	w8, #7
	b.ne	.LBB343_28
.LBB343_22:                             // %B34
	ldr	w8, [x13]
	add	x9, x22, #8
	add	w8, w8, #1
	str	w8, [x13]
	ldr	w8, [x19]
	sub	w8, w8, #1
	str	w8, [x19]
	stlr	x13, [x9]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB343_31
// %bb.23:                              // %B38
	ldr	w8, [x13, #20]
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB343_32
.LBB343_24:                             // %B37
	ldr	x9, [sp, #8]                    // 8-byte Folded Reload
	sub	x20, x12, #8
	ldrb	w8, [x9, #4]
	ldr	x1, [x25, x8, lsl #3]
	add	x19, x9, #5
	add	sp, sp, #16
	br	x1
.LBB343_25:                             // %B77
	mov	x8, x12
	mov	x0, x24
	mov	x1, x22
	mov	w2, w20
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	str	x21, [x8], #8
	mov	x20, x12
	str	x8, [x23, #48]
	bl	JS_SetPropertyInternalImpl_GC
	tbnz	w0, #31, .LBB343_39
// %bb.26:                              // %B79
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	add	x19, x19, #5
	add	sp, sp, #16
	br	x1
.LBB343_27:                             // %B9
	mov	x0, x21
	mov	x1, x24
	mov	x20, x12
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	add	x19, x19, #5
	add	sp, sp, #16
	br	x1
.LBB343_28:                             // %B47
	ldr	x0, [x24, #8]
	mov	x1, x19
	mov	w2, w20
	mov	w3, #7                          // =0x7
	str	x12, [sp]                       // 8-byte Folded Spill
	bl	find_hashed_shape_prop_gc
	ldr	x12, [sp]                       // 8-byte Folded Reload
	cbz	x0, .LBB343_34
// %bb.29:                              // %B50
	ldr	x8, [x22, #16]
	ldr	w9, [x0, #16]
	add	x10, x22, #32
	ldr	w11, [x19, #16]
	mov	x13, x0
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	.LBB343_33
// %bb.30:
	ldr	x12, [sp]                       // 8-byte Folded Reload
	b	.LBB343_22
.LBB343_31:                             // %B41
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	mov	x20, x12
	orr	x0, x13, x8
	mov	x19, x13
	bl	prim_WriteBarrierNoStore
	mov	x12, x20
	ldr	w8, [x19, #20]
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB343_24
.LBB343_32:                             // %B40
	mov	x0, x21
	mov	x1, x24
	mov	x20, x12
	bl	prim_WriteBarrierNoStore
	mov	x12, x20
	b	.LBB343_24
.LBB343_33:                             // %B50
	ldr	x12, [sp]                       // 8-byte Folded Reload
	cbnz	w8, .LBB343_22
.LBB343_34:                             // %B70
	mov	x0, x24
	mov	x1, x22
	mov	w2, w20
	mov	w3, #7                          // =0x7
	str	x12, [sp]                       // 8-byte Folded Spill
	str	x21, [x12], #8
	str	x12, [x23, #48]
	bl	add_property_gc
	cbz	x0, .LBB343_38
// %bb.35:                              // %B74
	str	x21, [x0]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB343_37
// %bb.36:                              // %B76
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
.LBB343_37:                             // %B73
	ldr	x9, [sp, #8]                    // 8-byte Folded Reload
	ldrb	w8, [x9, #4]
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp], #16                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	x19, x9, #5
	br	x1
.LBB343_38:                             // %B71
	ldp	x8, x19, [sp]                   // 16-byte Folded Reload
	sub	x20, x8, #8
.LBB343_39:                             // %B78
	add	sp, sp, #16
	b	.Lexception_spill_top1_asm_h
.Lfunc_end343:
	.size	.Lput_field_1_asm_h, .Lfunc_end343-.Lput_field_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_private_field_1_asm_h
	.type	.Lget_private_field_1_asm_h,@function
.Lget_private_field_1_asm_h:            // @get_private_field_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #48]
	bl	JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	.LBB344_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB344_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end344:
	.size	.Lget_private_field_1_asm_h, .Lfunc_end344-.Lget_private_field_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_private_field_1_asm_h
	.type	.Lput_private_field_1_asm_h,@function
.Lput_private_field_1_asm_h:            // @put_private_field_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x3, x22
	str	x8, [x23, #48]
	bl	JS_SetPrivateField_GC
	tbnz	w0, #31, .LBB345_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB345_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end345:
	.size	.Lput_private_field_1_asm_h, .Lfunc_end345-.Lput_private_field_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_private_field_1_asm_h
	.type	.Ldefine_private_field_1_asm_h,@function
.Ldefine_private_field_1_asm_h:         // @define_private_field_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	add	x8, x20, #8
	mov	x0, x24
	mov	x3, x21
	str	x21, [x20]
	mov	x2, x22
	str	x8, [x23, #48]
	bl	JS_DefinePrivateField_GC
	tbnz	w0, #31, .LBB346_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB346_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end346:
	.size	.Ldefine_private_field_1_asm_h, .Lfunc_end346-.Ldefine_private_field_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_array_el_1_asm_h
	.type	.Lget_array_el_1_asm_h,@function
.Lget_array_el_1_asm_h:                 // @get_array_el_1_asm_h
// %bb.0:                               // %B112
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB347_12
// %bb.1:                               // %B109
	mov	w9, #65534                      // =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	.LBB347_5
// %bb.2:                               // %B1
	cmp	w8, #2
	b.ne	.LBB347_10
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	.LBB347_14
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB347_5:                              // %B69
	cmp	w8, #1
	b.ne	.LBB347_12
// %bb.6:                               // %B72
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB347_12
// %bb.7:                               // %B72
	mov	x9, #2                          // =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	.LBB347_12
// %bb.8:                               // %B101
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, .LBB347_24
// %bb.9:                               // %B104
	ldr	w8, [x1, #8]
	b	.LBB347_25
.LBB347_10:                             // %B30
	sxth	w9, w8
	cmp	w9, #21
	b.lt	.LBB347_12
// %bb.11:                              // %B30
	cmp	w9, #29
	b.le	.LBB347_33
.LBB347_12:                             // %B106
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB347_38
// %bb.13:                              // %B108
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB347_14:                             // %B7
	tbnz	w21, #31, .LBB347_12
// %bb.15:                              // %B9.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB347_16:                             // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB347_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, .LBB347_19
.LBB347_17:                             // %B10
                                        //   Parent Loop BB347_16 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	.LBB347_21
// %bb.18:                              // %B17
                                        //   in Loop: Header=BB347_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB347_17
.LBB347_19:                             // %B24
                                        //   in Loop: Header=BB347_16 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB347_12
// %bb.20:                              // %B21
                                        //   in Loop: Header=BB347_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB347_16
	b	.LBB347_23
.LBB347_21:                             // %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	.LBB347_12
// %bb.22:                              // %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB347_23:                             // %B87
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB347_24:                             // %B102
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
.LBB347_25:                             // %B98
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	.LBB347_12
// %bb.26:                              // %B77
	ldr	x0, [x24, #8]
	bl	prim_get_interned_non_index_atom
	cbz	w0, .LBB347_12
// %bb.27:                              // %B80.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB347_28:                             // %B80
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB347_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB347_31
.LBB347_29:                             // %B83
                                        //   Parent Loop BB347_28 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	.LBB347_39
// %bb.30:                              // %B89
                                        //   in Loop: Header=BB347_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB347_29
.LBB347_31:                             // %B94
                                        //   in Loop: Header=BB347_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB347_12
// %bb.32:                              // %B91
                                        //   in Loop: Header=BB347_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB347_28
	b	.LBB347_23
.LBB347_33:                             // %B32
	ldr	w9, [x22, #48]
	cmp	w21, w9
	b.hs	.LBB347_12
// %bb.34:                              // %B34
	ldr	x9, [x22, #40]
	cmp	w8, #23
	b.ge	.LBB347_41
// %bb.35:                              // %B34
	cmp	w8, #21
	b.eq	.LBB347_42
// %bb.36:                              // %B34
	cmp	w8, #22
	b.ne	.LBB347_12
// %bb.37:                              // %B35
	ldrsb	w8, [x9, w21, sxtw]
	b	.LBB347_54
.LBB347_38:                             // %B107
	b	.Lexception_spill_top1_asm_h
.LBB347_39:                             // %B85
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB347_12
// %bb.40:                              // %B86
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB347_41:                             // %B34
	b.gt	.LBB347_43
.LBB347_42:                             // %B39
	ldrb	w8, [x9, w21, sxtw]
	b	.LBB347_54
.LBB347_43:                             // %B34
	cmp	w8, #25
	b.gt	.LBB347_47
// %bb.44:                              // %B34
	cmp	w8, #24
	b.eq	.LBB347_51
// %bb.45:                              // %B34
	cmp	w8, #25
	b.ne	.LBB347_12
// %bb.46:                              // %B45
	ldrh	w8, [x9, w21, sxtw #1]
	b	.LBB347_54
.LBB347_47:                             // %B34
	cmp	w8, #26
	b.eq	.LBB347_52
// %bb.48:                              // %B34
	cmp	w8, #27
	b.eq	.LBB347_53
// %bb.49:                              // %B34
	cmp	w8, #29
	b.ne	.LBB347_12
// %bb.50:                              // %B62
	ldr	d0, [x9, w21, sxtw #3]
	b	.LBB347_56
.LBB347_51:                             // %B42
	ldrsh	w8, [x9, w21, sxtw #1]
	b	.LBB347_54
.LBB347_52:                             // %B48
	ldr	w8, [x9, w21, sxtw #2]
	b	.LBB347_54
.LBB347_53:                             // %B56
	ldr	w8, [x9, w21, sxtw #2]
	tbnz	w8, #31, .LBB347_55
.LBB347_54:                             // %B57
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB347_55:                             // %B52
	ucvtf	d0, w8
.LBB347_56:                             // %B36
	fmov	x8, d0
	fcmp	d0, d0
	mov	x9, #562949953421312            // =0x2000000000000
	add	x8, x8, x9
	mov	x9, #9221683186994511872        // =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end347:
	.size	.Lget_array_el_1_asm_h, .Lfunc_end347-.Lget_array_el_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_array_el2_1_asm_h
	.type	.Lget_array_el2_1_asm_h,@function
.Lget_array_el2_1_asm_h:                // @get_array_el2_1_asm_h
// %bb.0:                               // %B112
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB348_12
// %bb.1:                               // %B109
	mov	w9, #65534                      // =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	.LBB348_5
// %bb.2:                               // %B1
	cmp	w8, #2
	b.ne	.LBB348_10
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	.LBB348_14
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #8
	add	w8, w8, #494
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB348_5:                              // %B69
	cmp	w8, #1
	b.ne	.LBB348_12
// %bb.6:                               // %B72
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB348_12
// %bb.7:                               // %B72
	mov	x9, #2                          // =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	.LBB348_12
// %bb.8:                               // %B101
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, .LBB348_24
// %bb.9:                               // %B104
	ldr	w8, [x1, #8]
	b	.LBB348_25
.LBB348_10:                             // %B30
	sxth	w9, w8
	cmp	w9, #21
	b.lt	.LBB348_12
// %bb.11:                              // %B30
	cmp	w9, #29
	b.le	.LBB348_33
.LBB348_12:                             // %B106
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB348_38
// %bb.13:                              // %B108
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB348_14:                             // %B7
	tbnz	w21, #31, .LBB348_12
// %bb.15:                              // %B9.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB348_16:                             // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB348_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, .LBB348_19
.LBB348_17:                             // %B10
                                        //   Parent Loop BB348_16 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	.LBB348_21
// %bb.18:                              // %B17
                                        //   in Loop: Header=BB348_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB348_17
.LBB348_19:                             // %B24
                                        //   in Loop: Header=BB348_16 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB348_12
// %bb.20:                              // %B21
                                        //   in Loop: Header=BB348_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB348_16
	b	.LBB348_23
.LBB348_21:                             // %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	.LBB348_12
// %bb.22:                              // %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB348_23:                             // %B87
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB348_24:                             // %B102
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
.LBB348_25:                             // %B98
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	.LBB348_12
// %bb.26:                              // %B77
	ldr	x0, [x24, #8]
	bl	prim_get_interned_non_index_atom
	cbz	w0, .LBB348_12
// %bb.27:                              // %B80.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB348_28:                             // %B80
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB348_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB348_31
.LBB348_29:                             // %B83
                                        //   Parent Loop BB348_28 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	.LBB348_39
// %bb.30:                              // %B89
                                        //   in Loop: Header=BB348_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB348_29
.LBB348_31:                             // %B94
                                        //   in Loop: Header=BB348_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB348_12
// %bb.32:                              // %B91
                                        //   in Loop: Header=BB348_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB348_28
	b	.LBB348_23
.LBB348_33:                             // %B32
	ldr	w9, [x22, #48]
	cmp	w21, w9
	b.hs	.LBB348_12
// %bb.34:                              // %B34
	ldr	x9, [x22, #40]
	cmp	w8, #23
	b.ge	.LBB348_41
// %bb.35:                              // %B34
	cmp	w8, #21
	b.eq	.LBB348_42
// %bb.36:                              // %B34
	cmp	w8, #22
	b.ne	.LBB348_12
// %bb.37:                              // %B35
	ldrsb	w8, [x9, w21, sxtw]
	b	.LBB348_54
.LBB348_38:                             // %B107
	b	.Lexception_spill_top1_asm_h
.LBB348_39:                             // %B85
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB348_12
// %bb.40:                              // %B86
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB348_41:                             // %B34
	b.gt	.LBB348_43
.LBB348_42:                             // %B39
	ldrb	w8, [x9, w21, sxtw]
	b	.LBB348_54
.LBB348_43:                             // %B34
	cmp	w8, #25
	b.gt	.LBB348_47
// %bb.44:                              // %B34
	cmp	w8, #24
	b.eq	.LBB348_51
// %bb.45:                              // %B34
	cmp	w8, #25
	b.ne	.LBB348_12
// %bb.46:                              // %B45
	ldrh	w8, [x9, w21, sxtw #1]
	b	.LBB348_54
.LBB348_47:                             // %B34
	cmp	w8, #26
	b.eq	.LBB348_52
// %bb.48:                              // %B34
	cmp	w8, #27
	b.eq	.LBB348_53
// %bb.49:                              // %B34
	cmp	w8, #29
	b.ne	.LBB348_12
// %bb.50:                              // %B62
	ldr	d0, [x9, w21, sxtw #3]
	b	.LBB348_56
.LBB348_51:                             // %B42
	ldrsh	w8, [x9, w21, sxtw #1]
	b	.LBB348_54
.LBB348_52:                             // %B48
	ldr	w8, [x9, w21, sxtw #2]
	b	.LBB348_54
.LBB348_53:                             // %B56
	ldr	w8, [x9, w21, sxtw #2]
	tbnz	w8, #31, .LBB348_55
.LBB348_54:                             // %B57
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB348_55:                             // %B52
	ucvtf	d0, w8
.LBB348_56:                             // %B36
	fmov	x8, d0
	fcmp	d0, d0
	mov	x9, #562949953421312            // =0x2000000000000
	add	x8, x8, x9
	mov	x9, #9221683186994511872        // =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end348:
	.size	.Lget_array_el2_1_asm_h, .Lfunc_end348-.Lget_array_el2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_array_el_1_asm_h
	.type	.Lput_array_el_1_asm_h,@function
.Lput_array_el_1_asm_h:                 // @put_array_el_1_asm_h
// %bb.0:                               // %B190
	sub	sp, sp, #32
	mov	x21, x22
	ldp	x10, x22, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x10, x8
	b.ne	.LBB349_7
// %bb.1:                               // %B1
	mov	w8, #65534                      // =0xfffe
	ldrh	w9, [x10, #6]
	cmp	x8, x22, lsr #48
	b.ne	.LBB349_10
// %bb.2:                               // %B3
	cmp	w9, #2
	b.ne	.LBB349_15
// %bb.3:                               // %B5
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB349_7
// %bb.4:                               // %B50
	ldr	w8, [x10, #48]
	cmp	w22, w8
	b.hs	.LBB349_22
// %bb.5:                               // %B7
	ldr	x8, [x10, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB349_33
// %bb.6:                               // %B9
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
.LBB349_7:
	stp	x20, x10, [sp, #16]             // 16-byte Folded Spill
.LBB349_8:                              // %B187
	mov	w4, #32768                      // =0x8000
.LBB349_9:                              // %B187
	ldp	x8, x1, [sp, #16]               // 16-byte Folded Reload
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_SetPropertyValue_GC
	tbz	w0, #31, .LBB349_32
	b	.LBB349_63
.LBB349_10:                             // %B100
	cmp	w9, #1
	stp	x20, x10, [sp, #16]             // 16-byte Folded Spill
	b.ne	.LBB349_8
// %bb.11:                              // %B181
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	mov	w4, #32768                      // =0x8000
	ldr	w8, [x8, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB349_9
// %bb.12:                              // %B181
	mov	x9, #2                          // =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	.LBB349_9
// %bb.13:                              // %B103
	and	x1, x22, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, .LBB349_48
// %bb.14:                              // %B180
	ldr	w8, [x1, #8]
	b	.LBB349_49
.LBB349_15:                             // %B55
	sxth	w8, w9
	mov	w4, #32768                      // =0x8000
	stp	x20, x10, [sp, #16]             // 16-byte Folded Spill
	cmp	w8, #21
	b.lt	.LBB349_9
// %bb.16:                              // %B55
	cmp	w8, #29
	b.gt	.LBB349_9
// %bb.17:                              // %B57
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB349_47
// %bb.18:                              // %B59
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	ldr	w8, [x8, #48]
	cmp	w22, w8
	b.hs	.LBB349_47
// %bb.19:                              // %B61
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	sub	w10, w9, #22
	cmp	w10, #2
	ldr	x8, [x8, #40]
	b.hs	.LBB349_34
// %bb.20:                              // %B71
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	.LBB349_47
// %bb.21:                              // %B72
	strb	w21, [x8, w22, sxtw]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #32
	br	x1
.LBB349_22:                             // %B12
	stp	x20, x10, [sp, #16]             // 16-byte Folded Spill
	b.ne	.LBB349_60
// %bb.23:                              // %B40
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	mov	w4, #32768                      // =0x8000
	ldr	w9, [x9, #4]
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	b.ne	.LBB349_9
// %bb.24:                              // %B40
	ubfx	w9, w9, #8, #1
	cbz	w9, .LBB349_9
// %bb.25:                              // %B14
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbz	x9, .LBB349_27
// %bb.26:                              // %B36
	ldr	w9, [x9, #4]
	ubfx	w9, w9, #13, #1
	cmp	w9, #1
	b.ne	.LBB349_9
.LBB349_27:                             // %B32
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	ldr	x9, [x9, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	.LBB349_29
// %bb.28:                              // %B32
	cmp	w9, w10
	b.hi	.LBB349_62
.LBB349_29:                             // %B29
	ldr	x10, [sp, #24]                  // 8-byte Folded Reload
	ldr	w10, [x10, #32]
	cmp	w9, w10
	b.hi	.LBB349_62
// %bb.30:                              // %B25
	ldr	x11, [sp, #24]                  // 8-byte Folded Reload
	ldr	x10, [x11, #40]
	str	w9, [x11, #48]
	str	x21, [x10, w8, sxtw #3]
.LBB349_31:                             // %B133
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB349_64
.LBB349_32:                             // %B132
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #32
	br	x1
.LBB349_33:                             // %B11
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
.LBB349_34:                             // %B61
	cmp	w9, #25
	mov	w4, wzr
	b.gt	.LBB349_38
// %bb.35:                              // %B61
	sub	w10, w9, #24
	cmp	w10, #2
	b.hs	.LBB349_41
// %bb.36:                              // %B77
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	.LBB349_47
// %bb.37:                              // %B78
	strh	w21, [x8, w22, sxtw #1]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #32
	br	x1
.LBB349_38:                             // %B61
	sub	w10, w9, #26
	cmp	w10, #2
	b.hs	.LBB349_44
// %bb.39:                              // %B83
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	.LBB349_47
// %bb.40:                              // %B84
	str	w21, [x8, w22, sxtw #2]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #32
	br	x1
.LBB349_41:                             // %B61
	cmp	w9, #21
	b.ne	.LBB349_9
// %bb.42:                              // %B63
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	.LBB349_47
// %bb.43:                              // %B64
	cmp	w21, #255
	mov	w9, #255                        // =0xff
	csel	w9, w21, w9, lt
	bic	w9, w9, w9, asr #31
	strb	w9, [x8, w22, sxtw]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #32
	br	x1
.LBB349_44:                             // %B61
	cmp	w9, #29
	b.ne	.LBB349_9
// %bb.45:                              // %B89
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	.LBB349_65
// %bb.46:                              // %B90
	scvtf	d0, w21
	str	d0, [x8, w22, sxtw #3]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #32
	br	x1
.LBB349_47:
	mov	w4, wzr
	b	.LBB349_9
.LBB349_48:                             // %B104
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
.LBB349_49:                             // %B176
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	.LBB349_9
// %bb.50:                              // %B105
	ldr	x0, [x24, #8]
	bl	prim_get_interned_non_index_atom
	cbz	w0, .LBB349_8
// %bb.51:                              // %B107
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	str	w0, [sp, #4]                    // 4-byte Folded Spill
	ldr	x8, [x8, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w0, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, .LBB349_54
.LBB349_52:                             // %B110
                                        // =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	.LBB349_68
// %bb.53:                              // %B119
                                        //   in Loop: Header=BB349_52 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, .LBB349_52
.LBB349_54:                             // %B121.preheader
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
.LBB349_55:                             // %B121
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB349_56 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w0, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, .LBB349_58
.LBB349_56:                             // %B157
                                        //   Parent Loop BB349_55 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	.LBB349_69
// %bb.57:                              // %B162
                                        //   in Loop: Header=BB349_56 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB349_56
.LBB349_58:                             // %B122
                                        //   in Loop: Header=BB349_55 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	.LBB349_8
// %bb.59:                              // %B151
                                        //   in Loop: Header=BB349_55 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB349_55
	b	.LBB349_70
.LBB349_60:                             // %B44
	tbnz	w22, #31, .LBB349_8
// %bb.61:                              // %B46
	ldp	x8, x1, [sp, #16]               // 16-byte Folded Reload
	mov	x0, x24
	mov	w2, w22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_SetArrayIntPropertyValue_GC
	tbz	w0, #31, .LBB349_32
	b	.LBB349_63
.LBB349_62:                             // %B20
	ldp	x8, x1, [sp, #16]               // 16-byte Folded Reload
	mov	x0, x24
	mov	x2, x21
	mov	w3, #32768                      // =0x8000
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	add_fast_array_element_gc
	tbz	w0, #31, .LBB349_32
.LBB349_63:                             // %B47
	ldr	x20, [sp, #16]                  // 8-byte Folded Reload
	add	sp, sp, #32
	b	.Lexception_spill_top1_asm_h
.LBB349_64:                             // %B135
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #32
	br	x1
.LBB349_65:                             // %B92
	and	x9, x21, #0xfffe000000000000
	mov	x10, #-562949953421312          // =0xfffe000000000000
	mov	w4, wzr
	cmp	x9, x10
	b.eq	.LBB349_9
// %bb.66:                              // %B92
	cbz	x9, .LBB349_9
// %bb.67:                              // %B93
	mov	x9, #-562949953421312           // =0xfffe000000000000
	add	x9, x21, x9
	str	x9, [x8, w22, sxtw #3]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #32
	br	x1
.LBB349_68:                             // %B112
	mov	w9, #58                         // =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.eq	.LBB349_83
	b	.LBB349_8
.LBB349_69:                             // %B159
	mov	w8, #58                         // =0x3a
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	.LBB349_8
.LBB349_70:                             // %B125
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	ldr	w8, [x8, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	.LBB349_8
// %bb.71:                              // %B144
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	ldr	x8, [x8, #8]
	mov	x20, x8
	ldr	x8, [x8, #40]
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	cbz	x8, .LBB349_76
// %bb.72:                              // %B127
	ldr	x10, [sp, #24]                  // 8-byte Folded Reload
	ldr	x9, [sp, #8]                    // 8-byte Folded Reload
	ldr	w11, [x20, #16]
	ldr	x8, [x10, #16]
	ldr	w9, [x9, #16]
	add	x10, x10, #32
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	.LBB349_74
// %bb.73:                              // %B127
	cbz	w8, .LBB349_84
.LBB349_74:                             // %B137
	ldr	w8, [x20, #48]
	cmp	w8, w0
	b.ne	.LBB349_76
// %bb.75:                              // %B137
	ldrb	w8, [x20, #52]
	cmp	w8, #7
	b.eq	.LBB349_80
.LBB349_76:                             // %B166
	ldr	x0, [x24, #8]
	ldr	w2, [sp, #4]                    // 4-byte Folded Reload
	mov	x1, x20
	mov	w3, #7                          // =0x7
	bl	find_hashed_shape_prop_gc
	cbz	x0, .LBB349_84
// %bb.77:                              // %B148
	ldr	x10, [sp, #24]                  // 8-byte Folded Reload
	ldr	w9, [x0, #16]
	ldr	w11, [x20, #16]
	ldr	x8, [x10, #16]
	add	x10, x10, #32
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	.LBB349_79
// %bb.78:
	str	x0, [sp, #8]                    // 8-byte Folded Spill
	b	.LBB349_80
.LBB349_79:                             // %B148
	str	x0, [sp, #8]                    // 8-byte Folded Spill
	cbz	w8, .LBB349_84
.LBB349_80:                             // %B129
	ldr	x10, [sp, #8]                   // 8-byte Folded Reload
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	ldr	w8, [x10]
	add	x9, x9, #8
	add	w8, w8, #1
	str	w8, [x10]
	ldr	w8, [x20]
	sub	w8, w8, #1
	str	w8, [x20]
	stlr	x10, [x9]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB349_82
// %bb.81:                              // %B136
	ldr	x9, [sp, #8]                    // 8-byte Folded Reload
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	prim_WriteBarrierNoStore
.LBB349_82:                             // %B133
	ldr	x8, [sp, #8]                    // 8-byte Folded Reload
	ldr	w8, [x8, #20]
.LBB349_83:                             // %B133
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	sub	w8, w8, #1
	ldr	x9, [x9, #16]
	str	x21, [x9, w8, sxtw #3]
	b	.LBB349_31
.LBB349_84:                             // %B169
	ldp	x8, x1, [sp, #16]               // 16-byte Folded Reload
	mov	x0, x24
	ldr	w2, [sp, #4]                    // 4-byte Folded Reload
	mov	w3, #7                          // =0x7
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	add_property_gc
	cbz	x0, .LBB349_86
// %bb.85:                              // %B173
	str	x21, [x0]
	b	.LBB349_31
.LBB349_86:                             // %B170
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #32
	b	.Lexception_spill_top1_asm_h
.Lfunc_end349:
	.size	.Lput_array_el_1_asm_h, .Lfunc_end349-.Lput_array_el_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_super_value_1_asm_h
	.type	.Lget_super_value_1_asm_h,@function
.Lget_super_value_1_asm_h:              // @get_super_value_1_asm_h
// %bb.0:                               // %B1
	sub	sp, sp, #16
	mov	x21, x22
	str	x19, [sp, #8]                   // 8-byte Folded Spill
	add	x19, x20, #8
	ldur	x22, [x20, #-8]
	mov	x0, x24
	mov	x1, x21
	str	x21, [x20]
	str	x19, [x23, #48]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB350_3
// %bb.1:                               // %B5
	ldur	x3, [x20, #-16]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	str	x21, [x20]
	str	x19, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB350_3
// %bb.2:                               // %B7
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	stur	x0, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB350_3:                              // %B2
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	add	sp, sp, #16
	b	.Lexception_spill_top1_asm_h
.Lfunc_end350:
	.size	.Lget_super_value_1_asm_h, .Lfunc_end350-.Lget_super_value_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_super_value_1_asm_h
	.type	.Lput_super_value_1_asm_h,@function
.Lput_super_value_1_asm_h:              // @put_super_value_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lput_super_value_0_asm_h
.Lfunc_end351:
	.size	.Lput_super_value_1_asm_h, .Lfunc_end351-.Lput_super_value_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_field_1_asm_h
	.type	.Ldefine_field_1_asm_h,@function
.Ldefine_field_1_asm_h:                 // @define_field_1_asm_h
// %bb.0:                               // %B58
	sub	sp, sp, #32
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	ldr	w2, [x19]
	tst	x22, x8
	b.ne	.LBB352_4
// %bb.1:                               // %B55
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	.LBB352_4
// %bb.2:                               // %B49
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB352_4
// %bb.3:                               // %B52
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.eq	.LBB352_6
.LBB352_4:                              // %B46
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #16391                      // =0x4007
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_DefinePropertyValue_GC
	tbnz	w0, #31, .LBB352_17
.LBB352_5:                              // %B4
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #32
	br	x1
.LBB352_6:                              // %B53
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, .LBB352_9
.LBB352_7:                              // %B35
                                        // =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	.LBB352_18
// %bb.8:                               // %B37
                                        //   in Loop: Header=BB352_7 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, .LBB352_7
.LBB352_9:                              // %B40
	tbnz	w2, #31, .LBB352_4
// %bb.10:                              // %B11
	ldr	x8, [x22, #8]
	str	x8, [sp, #24]                   // 8-byte Folded Spill
	ldr	x8, [x8, #40]
	str	x8, [sp, #16]                   // 8-byte Folded Spill
	cbz	x8, .LBB352_21
// %bb.11:                              // %B15
	ldp	x9, x11, [sp, #16]              // 16-byte Folded Reload
	add	x10, x22, #32
	ldr	x8, [x22, #16]
	ldr	w9, [x9, #16]
	ldr	w11, [x11, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	.LBB352_13
// %bb.12:                              // %B15
	cbz	w8, .LBB352_4
.LBB352_13:                             // %B17
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	ldr	w8, [x8, #48]
	cmp	w8, w2
	b.ne	.LBB352_21
// %bb.14:                              // %B17
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	ldrb	w8, [x8, #52]
	cmp	w8, #7
	b.ne	.LBB352_21
.LBB352_15:                             // %B25
	ldp	x11, x10, [sp, #16]             // 16-byte Folded Reload
	add	x9, x22, #8
	ldr	w8, [x11]
	add	w8, w8, #1
	str	w8, [x11]
	ldr	w8, [x10]
	sub	w8, w8, #1
	str	w8, [x10]
	stlr	x11, [x9]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB352_24
.LBB352_16:                             // %B22
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	ldr	w8, [x8, #20]
	b	.LBB352_19
.LBB352_17:                             // %B47
	add	sp, sp, #32
	b	.Lexception_spill_top1_asm_h
.LBB352_18:                             // %B1
	lsr	w9, w10, #26
	and	w9, w9, #0xfffffff7
	cmp	w9, #7
	b.ne	.LBB352_4
.LBB352_19:                             // %B22
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB352_5
// %bb.20:
	mov	x1, x24
	mov	x0, x21
	bl	prim_WriteBarrierNoStore
	b	.LBB352_5
.LBB352_21:                             // %B43
	ldr	x0, [x24, #8]
	ldr	x1, [sp, #24]                   // 8-byte Folded Reload
	mov	w3, #7                          // =0x7
	str	w2, [sp, #12]                   // 4-byte Folded Spill
	bl	find_hashed_shape_prop_gc
	ldr	w2, [sp, #12]                   // 4-byte Folded Reload
	cbz	x0, .LBB352_4
// %bb.22:                              // %B30
	ldr	x8, [x22, #16]
	ldr	x11, [sp, #24]                  // 8-byte Folded Reload
	add	x10, x22, #32
	ldr	w9, [x0, #16]
	ldr	w11, [x11, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	.LBB352_25
// %bb.23:
	str	x0, [sp, #16]                   // 8-byte Folded Spill
	b	.LBB352_15
.LBB352_24:                             // %B27
	ldr	x9, [sp, #16]                   // 8-byte Folded Reload
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	prim_WriteBarrierNoStore
	b	.LBB352_16
.LBB352_25:                             // %B30
	ldr	w2, [sp, #12]                   // 4-byte Folded Reload
	str	x0, [sp, #16]                   // 8-byte Folded Spill
	cbnz	w8, .LBB352_15
	b	.LBB352_4
.Lfunc_end352:
	.size	.Ldefine_field_1_asm_h, .Lfunc_end352-.Ldefine_field_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_name_1_asm_h
	.type	.Lset_name_1_asm_h,@function
.Lset_name_1_asm_h:                     // @set_name_1_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w3, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_DefineObjectName
	tbnz	w0, #31, .LBB353_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB353_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end353:
	.size	.Lset_name_1_asm_h, .Lfunc_end353-.Lset_name_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_name_computed_1_asm_h
	.type	.Lset_name_computed_1_asm_h,@function
.Lset_name_computed_1_asm_h:            // @set_name_computed_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x1, x21
	mov	w3, #1                          // =0x1
	mov	x2, x22
	str	x21, [x20]
	str	x8, [x23, #48]
	bl	JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, .LBB354_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB354_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end354:
	.size	.Lset_name_computed_1_asm_h, .Lfunc_end354-.Lset_name_computed_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_proto_1_asm_h
	.type	.Lset_proto_1_asm_h,@function
.Lset_proto_1_asm_h:                    // @set_proto_1_asm_h
// %bb.0:                               // %B6
	mov	x8, #2                          // =0x2
	mov	x21, x22
	ldur	x22, [x20, #-8]
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB355_3
// %bb.1:                               // %B6
	cmp	x21, #2
	b.eq	.LBB355_3
.LBB355_2:                              // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB355_3:                              // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_SetPrototypeInternal_GC
	tbz	w0, #31, .LBB355_2
// %bb.4:                               // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end355:
	.size	.Lset_proto_1_asm_h, .Lfunc_end355-.Lset_proto_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_home_object_1_asm_h
	.type	.Lset_home_object_1_asm_h,@function
.Lset_home_object_1_asm_h:              // @set_home_object_1_asm_h
// %bb.0:                               // %B0
	sub	sp, sp, #16
	mov	x9, x20
	mov	x21, x22
	add	x8, x20, #8
	ldr	x22, [x9, #-8]!
	mov	x0, x24
	mov	x1, x21
	str	x9, [sp, #8]                    // 8-byte Folded Spill
	mov	x2, x22
	str	x21, [x20]
	str	x8, [x23, #48]
	bl	js_method_set_home_object_gc
	ldrb	w8, [x19], #1
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
.Lfunc_end356:
	.size	.Lset_home_object_1_asm_h, .Lfunc_end356-.Lset_home_object_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_array_el_1_asm_h
	.type	.Ldefine_array_el_1_asm_h,@function
.Ldefine_array_el_1_asm_h:              // @define_array_el_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	add	x8, x20, #8
	mov	x0, x24
	mov	x3, x21
	mov	w4, #16391                      // =0x4007
	str	x21, [x20]
	mov	x2, x22
	str	x8, [x23, #48]
	bl	JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, .LBB357_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB357_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end357:
	.size	.Ldefine_array_el_1_asm_h, .Lfunc_end357-.Ldefine_array_el_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function append_1_asm_h
	.type	.Lappend_1_asm_h,@function
.Lappend_1_asm_h:                       // @append_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lappend_0_asm_h
.Lfunc_end358:
	.size	.Lappend_1_asm_h, .Lfunc_end358-.Lappend_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function copy_data_properties_1_asm_h
	.type	.Lcopy_data_properties_1_asm_h,@function
.Lcopy_data_properties_1_asm_h:         // @copy_data_properties_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcopy_data_properties_0_asm_h
.Lfunc_end359:
	.size	.Lcopy_data_properties_1_asm_h, .Lfunc_end359-.Lcopy_data_properties_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_method_1_asm_h
	.type	.Ldefine_method_1_asm_h,@function
.Ldefine_method_1_asm_h:                // @define_method_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ldefine_method_0_asm_h
.Lfunc_end360:
	.size	.Ldefine_method_1_asm_h, .Lfunc_end360-.Ldefine_method_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_method_computed_1_asm_h
	.type	.Ldefine_method_computed_1_asm_h,@function
.Ldefine_method_computed_1_asm_h:       // @define_method_computed_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ldefine_method_computed_0_asm_h
.Lfunc_end361:
	.size	.Ldefine_method_computed_1_asm_h, .Lfunc_end361-.Ldefine_method_computed_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_class_1_asm_h
	.type	.Ldefine_class_1_asm_h,@function
.Ldefine_class_1_asm_h:                 // @define_class_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ldefine_class_0_asm_h
.Lfunc_end362:
	.size	.Ldefine_class_1_asm_h, .Lfunc_end362-.Ldefine_class_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc_1_asm_h
	.type	.Lget_loc_1_asm_h,@function
.Lget_loc_1_asm_h:                      // @get_loc_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #494
	ldr	x21, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end363:
	.size	.Lget_loc_1_asm_h, .Lfunc_end363-.Lget_loc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc_1_asm_h
	.type	.Lput_loc_1_asm_h,@function
.Lput_loc_1_asm_h:                      // @put_loc_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end364:
	.size	.Lput_loc_1_asm_h, .Lfunc_end364-.Lput_loc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc_1_asm_h
	.type	.Lset_loc_1_asm_h,@function
.Lset_loc_1_asm_h:                      // @set_loc_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end365:
	.size	.Lset_loc_1_asm_h, .Lfunc_end365-.Lset_loc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg_1_asm_h
	.type	.Lget_arg_1_asm_h,@function
.Lget_arg_1_asm_h:                      // @get_arg_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #494
	ldr	x21, [x28, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end366:
	.size	.Lget_arg_1_asm_h, .Lfunc_end366-.Lget_arg_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg_1_asm_h
	.type	.Lput_arg_1_asm_h,@function
.Lput_arg_1_asm_h:                      // @put_arg_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end367:
	.size	.Lput_arg_1_asm_h, .Lfunc_end367-.Lput_arg_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg_1_asm_h
	.type	.Lset_arg_1_asm_h,@function
.Lset_arg_1_asm_h:                      // @set_arg_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end368:
	.size	.Lset_arg_1_asm_h, .Lfunc_end368-.Lset_arg_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref_1_asm_h
	.type	.Lget_var_ref_1_asm_h,@function
.Lget_var_ref_1_asm_h:                  // @get_var_ref_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x8, [x26, x8, lsl #3]
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x21, [x8]
	br	x1
.Lfunc_end369:
	.size	.Lget_var_ref_1_asm_h, .Lfunc_end369-.Lget_var_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_1_asm_h
	.type	.Lput_var_ref_1_asm_h,@function
.Lput_var_ref_1_asm_h:                  // @put_var_ref_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end370:
	.size	.Lput_var_ref_1_asm_h, .Lfunc_end370-.Lput_var_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref_1_asm_h
	.type	.Lset_var_ref_1_asm_h,@function
.Lset_var_ref_1_asm_h:                  // @set_var_ref_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end371:
	.size	.Lset_var_ref_1_asm_h, .Lfunc_end371-.Lset_var_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc_uninitialized_1_asm_h
	.type	.Lset_loc_uninitialized_1_asm_h,@function
.Lset_loc_uninitialized_1_asm_h:        // @set_loc_uninitialized_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	mov	w9, #34                         // =0x22
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end372:
	.size	.Lset_loc_uninitialized_1_asm_h, .Lfunc_end372-.Lset_loc_uninitialized_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc_check_1_asm_h
	.type	.Lget_loc_check_1_asm_h,@function
.Lget_loc_check_1_asm_h:                // @get_loc_check_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	.LBB373_2
// %bb.1:                               // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB373_2:                              // %B3
	str	x22, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end373:
	.size	.Lget_loc_check_1_asm_h, .Lfunc_end373-.Lget_loc_check_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc_check_1_asm_h
	.type	.Lput_loc_check_1_asm_h,@function
.Lput_loc_check_1_asm_h:                // @put_loc_check_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	.LBB374_2
// %bb.1:                               // %B4
	str	x22, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB374_2:                              // %B3
	str	x22, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end374:
	.size	.Lput_loc_check_1_asm_h, .Lfunc_end374-.Lput_loc_check_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc_check_init_1_asm_h
	.type	.Lput_loc_check_init_1_asm_h,@function
.Lput_loc_check_init_1_asm_h:           // @put_loc_check_init_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	.LBB375_2
// %bb.1:                               // %B4
	str	x22, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB375_2:                              // %B3
	str	x22, [x20], #8
	b	.LThrowThisReferenceError_asm_h
.Lfunc_end375:
	.size	.Lput_loc_check_init_1_asm_h, .Lfunc_end375-.Lput_loc_check_init_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref_check_1_asm_h
	.type	.Lget_var_ref_check_1_asm_h,@function
.Lget_var_ref_check_1_asm_h:            // @get_var_ref_check_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB376_2
// %bb.1:                               // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB376_2:                              // %B3
	str	x22, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end376:
	.size	.Lget_var_ref_check_1_asm_h, .Lfunc_end376-.Lget_var_ref_check_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_check_1_asm_h
	.type	.Lput_var_ref_check_1_asm_h,@function
.Lput_var_ref_check_1_asm_h:            // @put_var_ref_check_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	.LBB377_2
// %bb.1:                               // %B4
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB377_2:                              // %B3
	str	x22, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end377:
	.size	.Lput_var_ref_check_1_asm_h, .Lfunc_end377-.Lput_var_ref_check_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_check_init_1_asm_h
	.type	.Lput_var_ref_check_init_1_asm_h,@function
.Lput_var_ref_check_init_1_asm_h:       // @put_var_ref_check_init_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	.LBB378_2
// %bb.1:                               // %B4
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB378_2:                              // %B3
	str	x22, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end378:
	.size	.Lput_var_ref_check_init_1_asm_h, .Lfunc_end378-.Lput_var_ref_check_init_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function close_loc_1_asm_h
	.type	.Lclose_loc_1_asm_h,@function
.Lclose_loc_1_asm_h:                    // @close_loc_1_asm_h
// %bb.0:                               // %B0
	ldrh	w2, [x19]
	mov	x0, x24
	mov	x1, x23
	bl	close_lexical_var
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end379:
	.size	.Lclose_loc_1_asm_h, .Lfunc_end379-.Lclose_loc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_false_1_asm_h
	.type	.Lif_false_1_asm_h,@function
.Lif_false_1_asm_h:                     // @if_false_1_asm_h
// %bb.0:                               // %B23
	cmp	x22, #5
	b.le	.LBB380_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB380_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB380_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB380_6
	b	.LBB380_7
.LBB380_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB380_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB380_7
.LBB380_6:                              // %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB380_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB380_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB380_10
.LBB380_9:                              // %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB380_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB380_13
// %bb.11:                              // %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB380_6
	b.vs	.LBB380_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB380_9
	b	.LBB380_6
.LBB380_13:                             // %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.Lfunc_end380:
	.size	.Lif_false_1_asm_h, .Lfunc_end380-.Lif_false_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_true_1_asm_h
	.type	.Lif_true_1_asm_h,@function
.Lif_true_1_asm_h:                      // @if_true_1_asm_h
// %bb.0:                               // %B23
	cmp	x22, #5
	b.le	.LBB381_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB381_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB381_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB381_6
	b	.LBB381_7
.LBB381_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB381_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB381_7
.LBB381_6:                              // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB381_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB381_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB381_10
.LBB381_9:                              // %B19
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB381_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB381_13
// %bb.11:                              // %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB381_6
	b.vs	.LBB381_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB381_9
	b	.LBB381_6
.LBB381_13:                             // %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.Lfunc_end381:
	.size	.Lif_true_1_asm_h, .Lfunc_end381-.Lif_true_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function goto_1_asm_h
	.type	.Lgoto_1_asm_h,@function
.Lgoto_1_asm_h:                         // @goto_1_asm_h
// %bb.0:                               // %B0
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end382:
	.size	.Lgoto_1_asm_h, .Lfunc_end382-.Lgoto_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function catch_1_asm_h
	.type	.Lcatch_1_asm_h,@function
.Lcatch_1_asm_h:                        // @catch_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #4]
	ldr	w10, [x19]
	ldr	x8, [x8, #32]
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	mov	w9, #66                         // =0x42
	ldr	x8, [x8, #8]
	sub	x8, x19, x8
	add	x19, x19, #5
	add	x8, x8, x10
	orr	x21, x9, x8, lsl #16
	br	x1
.Lfunc_end383:
	.size	.Lcatch_1_asm_h, .Lfunc_end383-.Lcatch_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gosub_1_asm_h
	.type	.Lgosub_1_asm_h,@function
.Lgosub_1_asm_h:                        // @gosub_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #8]
	ldrsw	x9, [x19]
	ldr	x10, [x8, #32]
	add	x8, x19, x9
	ldrb	w9, [x8], #1
	ldr	w10, [x10, #8]
	add	w9, w9, #494
	sub	w10, w19, w10
	ldr	x1, [x25, w9, uxtw #3]
	mov	x19, x8
	add	w9, w10, #4
	orr	x21, x9, #0xfffe000000000000
	br	x1
.Lfunc_end384:
	.size	.Lgosub_1_asm_h, .Lfunc_end384-.Lgosub_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function ret_1_asm_h
	.type	.Lret_1_asm_h,@function
.Lret_1_asm_h:                          // @ret_1_asm_h
// %bb.0:                               // %B6
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB385_3
// %bb.1:                               // %B1
	ldr	x8, [x23, #8]
	ldr	x8, [x8, #32]
	ldr	w9, [x8, #16]
	cmp	w22, w9
	b.ge	.LBB385_3
// %bb.2:                               // %B5
	ldr	x8, [x8, #8]
	add	x19, x8, w22, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB385_3:                              // %B3
	mov	x8, x20
	adrp	x1, .L__unnamed_14
	add	x1, x1, :lo12:.L__unnamed_14
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	LEPUS_ThrowInternalError
	b	.Lexception_spill_top0_asm_h
.Lfunc_end385:
	.size	.Lret_1_asm_h, .Lfunc_end385-.Lret_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_object_1_asm_h
	.type	.Lto_object_1_asm_h,@function
.Lto_object_1_asm_h:                    // @to_object_1_asm_h
// %bb.0:                               // %B6
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB386_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB386_2:                              // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB386_4
// %bb.3:                               // %B3
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB386_4:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end386:
	.size	.Lto_object_1_asm_h, .Lfunc_end386-.Lto_object_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_propkey_1_asm_h
	.type	.Lto_propkey_1_asm_h,@function
.Lto_propkey_1_asm_h:                   // @to_propkey_1_asm_h
// %bb.0:                               // %B15
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	.LBB387_4
// %bb.1:                               // %B15
	mov	x9, #1                          // =0x1
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	.LBB387_4
// %bb.2:                               // %B15
	cmp	x8, x9
	b.eq	.LBB387_4
// %bb.3:                               // %B15
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB387_5
.LBB387_4:                              // %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB387_5:                              // %B12
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	.LBB387_7
// %bb.6:                               // %B14
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB387_7:                              // %B13
	b	.Lexception_spill_top0_asm_h
.Lfunc_end387:
	.size	.Lto_propkey_1_asm_h, .Lfunc_end387-.Lto_propkey_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_propkey2_1_asm_h
	.type	.Lto_propkey2_1_asm_h,@function
.Lto_propkey2_1_asm_h:                  // @to_propkey2_1_asm_h
// %bb.0:                               // %B18
	mov	x21, x22
	ldur	x22, [x20, #-8]
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	.LBB388_3
// %bb.1:                               // %B19
	mov	x8, x20
	adrp	x1, .L__unnamed_15
	add	x1, x1, :lo12:.L__unnamed_15
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	LEPUS_ThrowTypeError
.LBB388_2:                              // %B16
	b	.Lexception_spill_top1_asm_h
.LBB388_3:                              // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB388_7
// %bb.4:                               // %B2
	mov	x9, #1                          // =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	.LBB388_7
// %bb.5:                               // %B2
	cmp	x8, x9
	b.eq	.LBB388_7
// %bb.6:                               // %B2
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB388_8
.LBB388_7:                              // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB388_8:                              // %B15
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	.LBB388_2
// %bb.9:                               // %B17
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end388:
	.size	.Lto_propkey2_1_asm_h, .Lfunc_end388-.Lto_propkey2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_get_var_1_asm_h
	.type	.Lwith_get_var_1_asm_h,@function
.Lwith_get_var_1_asm_h:                 // @with_get_var_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lwith_get_var_0_asm_h
.Lfunc_end389:
	.size	.Lwith_get_var_1_asm_h, .Lfunc_end389-.Lwith_get_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_put_var_1_asm_h
	.type	.Lwith_put_var_1_asm_h,@function
.Lwith_put_var_1_asm_h:                 // @with_put_var_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lwith_put_var_0_asm_h
.Lfunc_end390:
	.size	.Lwith_put_var_1_asm_h, .Lfunc_end390-.Lwith_put_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_delete_var_1_asm_h
	.type	.Lwith_delete_var_1_asm_h,@function
.Lwith_delete_var_1_asm_h:              // @with_delete_var_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lwith_delete_var_0_asm_h
.Lfunc_end391:
	.size	.Lwith_delete_var_1_asm_h, .Lfunc_end391-.Lwith_delete_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_make_ref_1_asm_h
	.type	.Lwith_make_ref_1_asm_h,@function
.Lwith_make_ref_1_asm_h:                // @with_make_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lwith_make_ref_0_asm_h
.Lfunc_end392:
	.size	.Lwith_make_ref_1_asm_h, .Lfunc_end392-.Lwith_make_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_get_ref_1_asm_h
	.type	.Lwith_get_ref_1_asm_h,@function
.Lwith_get_ref_1_asm_h:                 // @with_get_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lwith_get_ref_0_asm_h
.Lfunc_end393:
	.size	.Lwith_get_ref_1_asm_h, .Lfunc_end393-.Lwith_get_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_get_ref_undef_1_asm_h
	.type	.Lwith_get_ref_undef_1_asm_h,@function
.Lwith_get_ref_undef_1_asm_h:           // @with_get_ref_undef_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lwith_get_ref_undef_0_asm_h
.Lfunc_end394:
	.size	.Lwith_get_ref_undef_1_asm_h, .Lfunc_end394-.Lwith_get_ref_undef_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_loc_ref_1_asm_h
	.type	.Lmake_loc_ref_1_asm_h,@function
.Lmake_loc_ref_1_asm_h:                 // @make_loc_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lmake_loc_ref_0_asm_h
.Lfunc_end395:
	.size	.Lmake_loc_ref_1_asm_h, .Lfunc_end395-.Lmake_loc_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_arg_ref_1_asm_h
	.type	.Lmake_arg_ref_1_asm_h,@function
.Lmake_arg_ref_1_asm_h:                 // @make_arg_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lmake_arg_ref_0_asm_h
.Lfunc_end396:
	.size	.Lmake_arg_ref_1_asm_h, .Lfunc_end396-.Lmake_arg_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_var_ref_ref_1_asm_h
	.type	.Lmake_var_ref_ref_1_asm_h,@function
.Lmake_var_ref_ref_1_asm_h:             // @make_var_ref_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lmake_var_ref_ref_0_asm_h
.Lfunc_end397:
	.size	.Lmake_var_ref_ref_1_asm_h, .Lfunc_end397-.Lmake_var_ref_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_var_ref_1_asm_h
	.type	.Lmake_var_ref_1_asm_h,@function
.Lmake_var_ref_1_asm_h:                 // @make_var_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lmake_var_ref_0_asm_h
.Lfunc_end398:
	.size	.Lmake_var_ref_1_asm_h, .Lfunc_end398-.Lmake_var_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_in_start_1_asm_h
	.type	.Lfor_in_start_1_asm_h,@function
.Lfor_in_start_1_asm_h:                 // @for_in_start_1_asm_h
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	.LBB399_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB399_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end399:
	.size	.Lfor_in_start_1_asm_h, .Lfunc_end399-.Lfor_in_start_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_of_start_1_asm_h
	.type	.Lfor_of_start_1_asm_h,@function
.Lfor_of_start_1_asm_h:                 // @for_of_start_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lfor_of_start_0_asm_h
.Lfunc_end400:
	.size	.Lfor_of_start_1_asm_h, .Lfunc_end400-.Lfor_of_start_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_await_of_start_1_asm_h
	.type	.Lfor_await_of_start_1_asm_h,@function
.Lfor_await_of_start_1_asm_h:           // @for_await_of_start_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lfor_await_of_start_0_asm_h
.Lfunc_end401:
	.size	.Lfor_await_of_start_1_asm_h, .Lfunc_end401-.Lfor_await_of_start_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_in_next_1_asm_h
	.type	.Lfor_in_next_1_asm_h,@function
.Lfor_in_next_1_asm_h:                  // @for_in_next_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lfor_in_next_0_asm_h
.Lfunc_end402:
	.size	.Lfor_in_next_1_asm_h, .Lfunc_end402-.Lfor_in_next_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_of_next_1_asm_h
	.type	.Lfor_of_next_1_asm_h,@function
.Lfor_of_next_1_asm_h:                  // @for_of_next_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lfor_of_next_0_asm_h
.Lfunc_end403:
	.size	.Lfor_of_next_1_asm_h, .Lfunc_end403-.Lfor_of_next_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_await_of_next_1_asm_h
	.type	.Lfor_await_of_next_1_asm_h,@function
.Lfor_await_of_next_1_asm_h:            // @for_await_of_next_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lfor_await_of_next_0_asm_h
.Lfunc_end404:
	.size	.Lfor_await_of_next_1_asm_h, .Lfunc_end404-.Lfor_await_of_next_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_get_value_done_1_asm_h
	.type	.Literator_get_value_done_1_asm_h,@function
.Literator_get_value_done_1_asm_h:      // @iterator_get_value_done_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Literator_get_value_done_0_asm_h
.Lfunc_end405:
	.size	.Literator_get_value_done_1_asm_h, .Lfunc_end405-.Literator_get_value_done_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_close_1_asm_h
	.type	.Literator_close_1_asm_h,@function
.Literator_close_1_asm_h:               // @iterator_close_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Literator_close_0_asm_h
.Lfunc_end406:
	.size	.Literator_close_1_asm_h, .Lfunc_end406-.Literator_close_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_close_return_1_asm_h
	.type	.Literator_close_return_1_asm_h,@function
.Literator_close_return_1_asm_h:        // @iterator_close_return_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Literator_close_return_0_asm_h
.Lfunc_end407:
	.size	.Literator_close_return_1_asm_h, .Lfunc_end407-.Literator_close_return_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_iterator_close_1_asm_h
	.type	.Lasync_iterator_close_1_asm_h,@function
.Lasync_iterator_close_1_asm_h:         // @async_iterator_close_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lasync_iterator_close_0_asm_h
.Lfunc_end408:
	.size	.Lasync_iterator_close_1_asm_h, .Lfunc_end408-.Lasync_iterator_close_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_iterator_next_1_asm_h
	.type	.Lasync_iterator_next_1_asm_h,@function
.Lasync_iterator_next_1_asm_h:          // @async_iterator_next_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lasync_iterator_next_0_asm_h
.Lfunc_end409:
	.size	.Lasync_iterator_next_1_asm_h, .Lfunc_end409-.Lasync_iterator_next_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_iterator_get_1_asm_h
	.type	.Lasync_iterator_get_1_asm_h,@function
.Lasync_iterator_get_1_asm_h:           // @async_iterator_get_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lasync_iterator_get_0_asm_h
.Lfunc_end410:
	.size	.Lasync_iterator_get_1_asm_h, .Lfunc_end410-.Lasync_iterator_get_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function initial_yield_1_asm_h
	.type	.Linitial_yield_1_asm_h,@function
.Linitial_yield_1_asm_h:                // @initial_yield_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Linitial_yield_0_asm_h
.Lfunc_end411:
	.size	.Linitial_yield_1_asm_h, .Lfunc_end411-.Linitial_yield_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function yield_1_asm_h
	.type	.Lyield_1_asm_h,@function
.Lyield_1_asm_h:                        // @yield_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lyield_0_asm_h
.Lfunc_end412:
	.size	.Lyield_1_asm_h, .Lfunc_end412-.Lyield_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function yield_star_1_asm_h
	.type	.Lyield_star_1_asm_h,@function
.Lyield_star_1_asm_h:                   // @yield_star_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lyield_star_0_asm_h
.Lfunc_end413:
	.size	.Lyield_star_1_asm_h, .Lfunc_end413-.Lyield_star_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_yield_star_1_asm_h
	.type	.Lasync_yield_star_1_asm_h,@function
.Lasync_yield_star_1_asm_h:             // @async_yield_star_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lasync_yield_star_0_asm_h
.Lfunc_end414:
	.size	.Lasync_yield_star_1_asm_h, .Lfunc_end414-.Lasync_yield_star_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function await_1_asm_h
	.type	.Lawait_1_asm_h,@function
.Lawait_1_asm_h:                        // @await_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lawait_0_asm_h
.Lfunc_end415:
	.size	.Lawait_1_asm_h, .Lfunc_end415-.Lawait_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function neg_1_asm_h
	.type	.Lneg_1_asm_h,@function
.Lneg_1_asm_h:                          // @neg_1_asm_h
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB416_3
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB416_6
// %bb.2:                               // %B13
	orr	w8, w22, #0x80000000
	mov	w9, #-2147483648                // =0x80000000
	cmp	w8, w9
	b.ne	.LBB416_5
.LBB416_3:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        // =0x8c
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB416_8
// %bb.4:                               // %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB416_5:                              // %B15
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB416_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB416_3
// %bb.7:                               // %B7
	movi	d0, #0000000000000000
	add	x8, x22, x8
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	fsub	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
.LBB416_8:                              // %B17
	b	.Lexception_spill_top0_asm_h
.Lfunc_end416:
	.size	.Lneg_1_asm_h, .Lfunc_end416-.Lneg_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function plus_1_asm_h
	.type	.Lplus_1_asm_h,@function
.Lplus_1_asm_h:                         // @plus_1_asm_h
// %bb.0:                               // %B13
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB417_4
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB417_3
.LBB417_2:                              // %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB417_3:                              // %B3
	tst	x22, #0xfffe000000000000
	b.ne	.LBB417_2
.LBB417_4:                              // %B10
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        // =0x8d
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB417_6
// %bb.5:                               // %B12
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB417_6:                              // %B11
	b	.Lexception_spill_top0_asm_h
.Lfunc_end417:
	.size	.Lplus_1_asm_h, .Lfunc_end417-.Lplus_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dec_1_asm_h
	.type	.Ldec_1_asm_h,@function
.Ldec_1_asm_h:                          // @dec_1_asm_h
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB418_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB418_4
// %bb.2:                               // %B13
	subs	w8, w22, #1
	b.vs	.LBB418_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB418_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB418_6
// %bb.5:                               // %B7
	add	x8, x22, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
.LBB418_6:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        // =0x8e
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB418_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB418_8:                              // %B17
	b	.Lexception_spill_top0_asm_h
.Lfunc_end418:
	.size	.Ldec_1_asm_h, .Lfunc_end418-.Ldec_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_1_asm_h
	.type	.Linc_1_asm_h,@function
.Linc_1_asm_h:                          // @inc_1_asm_h
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB419_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB419_4
// %bb.2:                               // %B13
	adds	w8, w22, #1
	b.vs	.LBB419_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB419_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB419_6
// %bb.5:                               // %B7
	add	x8, x22, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
.LBB419_6:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        // =0x8f
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB419_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB419_8:                              // %B17
	b	.Lexception_spill_top0_asm_h
.Lfunc_end419:
	.size	.Linc_1_asm_h, .Lfunc_end419-.Linc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function post_dec_1_asm_h
	.type	.Lpost_dec_1_asm_h,@function
.Lpost_dec_1_asm_h:                     // @post_dec_1_asm_h
// %bb.0:                               // %B16
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB420_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB420_4
// %bb.2:                               // %B13
	subs	w8, w22, #1
	b.vs	.LBB420_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB420_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB420_6
// %bb.5:                               // %B8
	add	x8, x22, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
.LBB420_6:                              // %B5
	str	x22, [x20], #8
	mov	w0, #144                        // =0x90
	b	.LSlowJSPostInc_asm_h
.Lfunc_end420:
	.size	.Lpost_dec_1_asm_h, .Lfunc_end420-.Lpost_dec_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function post_inc_1_asm_h
	.type	.Lpost_inc_1_asm_h,@function
.Lpost_inc_1_asm_h:                     // @post_inc_1_asm_h
// %bb.0:                               // %B16
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB421_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB421_4
// %bb.2:                               // %B13
	adds	w8, w22, #1
	b.vs	.LBB421_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB421_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB421_6
// %bb.5:                               // %B8
	add	x8, x22, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
.LBB421_6:                              // %B5
	str	x22, [x20], #8
	mov	w0, #145                        // =0x91
	b	.LSlowJSPostInc_asm_h
.Lfunc_end421:
	.size	.Lpost_inc_1_asm_h, .Lfunc_end421-.Lpost_inc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dec_loc_1_asm_h
	.type	.Ldec_loc_1_asm_h,@function
.Ldec_loc_1_asm_h:                      // @dec_loc_1_asm_h
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	.LBB422_6
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB422_4
// %bb.2:                               // %B13
	subs	w9, w1, #1
	b.vs	.LBB422_6
// %bb.3:                               // %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB422_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB422_6
// %bb.5:                               // %B8
	add	x9, x1, x9
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB422_6:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	w2, #142                        // =0x8e
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB422_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB422_8:                              // %B17
	b	.Lexception_spill_top0_asm_h
.Lfunc_end422:
	.size	.Ldec_loc_1_asm_h, .Lfunc_end422-.Ldec_loc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_loc_1_asm_h
	.type	.Linc_loc_1_asm_h,@function
.Linc_loc_1_asm_h:                      // @inc_loc_1_asm_h
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	.LBB423_6
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB423_4
// %bb.2:                               // %B13
	adds	w9, w1, #1
	b.vs	.LBB423_6
// %bb.3:                               // %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB423_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB423_6
// %bb.5:                               // %B8
	add	x9, x1, x9
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB423_6:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	w2, #143                        // =0x8f
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB423_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB423_8:                              // %B17
	b	.Lexception_spill_top0_asm_h
.Lfunc_end423:
	.size	.Linc_loc_1_asm_h, .Lfunc_end423-.Linc_loc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_loc_1_asm_h
	.type	.Ladd_loc_1_asm_h,@function
.Ladd_loc_1_asm_h:                      // @add_loc_1_asm_h
// %bb.0:                               // %B46
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	ccmp	x22, x9, #2, ls
	b.hi	.LBB424_16
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB424_5
// %bb.2:                               // %B26
	cmp	x22, x9
	b.lo	.LBB424_8
// %bb.3:                               // %B36
	adds	w9, w1, w22
	b.vs	.LBB424_11
// %bb.4:                               // %B42
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB424_5:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB424_16
// %bb.6:                               // %B11
	cmp	x22, x9
	b.lo	.LBB424_14
// %bb.7:                               // %B21
	scvtf	d0, w22
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	.LBB424_13
.LBB424_8:                              // %B28
	tst	x22, #0xfffe000000000000
	b.eq	.LBB424_16
// %bb.9:                               // %B31
	scvtf	d0, w1
	add	x9, x22, x9
.LBB424_10:                             // %B31
	fmov	d1, x9
	b	.LBB424_12
.LBB424_11:                             // %B38
	scvtf	d0, w1
	scvtf	d1, w22
.LBB424_12:                             // %B31
	fadd	d0, d0, d1
.LBB424_13:                             // %B31
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB424_14:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB424_16
// %bb.15:                              // %B16
	add	x10, x1, x9
	add	x9, x22, x9
	fmov	d0, x10
	b	.LBB424_10
.LBB424_16:                             // %B7
	and	x8, x22, #0xffff000000000003
	mov	x9, #-281474976710653           // =0xffff000000000003
	mov	x10, #2                         // =0x2
	cmp	x8, x9
	movk	x10, #1, lsl #48
	and	x11, x1, #0xffff000000000003
	ccmp	x8, x10, #4, ne
	cset	w8, eq
	cmp	x11, x10
	ccmp	x11, x9, #4, ne
	ccmp	w8, #0, #4, eq
	add	x8, x20, #8
	b.ne	.LBB424_19
// %bb.17:                              // %B43
	mov	x0, x24
	mov	x2, x22
	stur	x22, [x8, #-8]
	str	x8, [x23, #48]
	bl	prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	.LBB424_20
// %bb.18:                              // %B45
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB424_19:                             // %B8
	mov	x20, x8
	stur	x22, [x8, #-8]
	mov	w0, #1                          // =0x1
	b	.LFastJSConcatString_asm_h
.LBB424_20:                             // %B44
	b	.Lexception_spill_top0_asm_h
.Lfunc_end424:
	.size	.Ladd_loc_1_asm_h, .Lfunc_end424-.Ladd_loc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function not_1_asm_h
	.type	.Lnot_1_asm_h,@function
.Lnot_1_asm_h:                          // @not_1_asm_h
// %bb.0:                               // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB425_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB425_2:                              // %B4
	str	x22, [x20], #8
	mov	x0, x22
	b	.LSlowJSNot_asm_h
.Lfunc_end425:
	.size	.Lnot_1_asm_h, .Lfunc_end425-.Lnot_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lnot_1_asm_h
	.type	.Llnot_1_asm_h,@function
.Llnot_1_asm_h:                         // @lnot_1_asm_h
// %bb.0:                               // %B14
	cmp	x22, #5
	b.le	.LBB426_4
// %bb.1:                               // %B14
	cmp	x22, #6
	b.eq	.LBB426_6
// %bb.2:                               // %B14
	cmp	x22, #7
	b.eq	.LBB426_8
// %bb.3:                               // %B14
	cmp	x22, #18
	b.eq	.LBB426_6
	b	.LBB426_7
.LBB426_4:                              // %B14
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB426_6
// %bb.5:                               // %B14
	cmp	x22, #2
	b.ne	.LBB426_7
.LBB426_6:                              // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB426_7:                              // %B10
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB426_9
.LBB426_8:                              // %B12
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB426_9:                              // %B13
	str	x22, [x20], #8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.Lfunc_end426:
	.size	.Llnot_1_asm_h, .Lfunc_end426-.Llnot_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function typeof_1_asm_h
	.type	.Ltypeof_1_asm_h,@function
.Ltypeof_1_asm_h:                       // @typeof_1_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x22
	bl	js_operator_typeof_gc
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB427_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB427_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end427:
	.size	.Ltypeof_1_asm_h, .Lfunc_end427-.Ltypeof_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function delete_1_asm_h
	.type	.Ldelete_1_asm_h,@function
.Ldelete_1_asm_h:                       // @delete_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #48]
	bl	prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	.LBB428_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB428_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end428:
	.size	.Ldelete_1_asm_h, .Lfunc_end428-.Ldelete_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function delete_var_1_asm_h
	.type	.Ldelete_var_1_asm_h,@function
.Ldelete_var_1_asm_h:                   // @delete_var_1_asm_h
// %bb.0:                               // %B1
	ldr	x1, [x24, #208]
	ldr	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w3, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_DeleteProperty_GC
	tbnz	w0, #31, .LBB429_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x21, x8, ne
	br	x1
.LBB429_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end429:
	.size	.Ldelete_var_1_asm_h, .Lfunc_end429-.Ldelete_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function mul_1_asm_h
	.type	.Lmul_1_asm_h,@function
.Lmul_1_asm_h:                          // @mul_1_asm_h
// %bb.0:                               // %B51
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB430_19
// %bb.1:                               // %B51
	cmp	x21, x8
	b.hi	.LBB430_19
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB430_8
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB430_11
// %bb.4:                               // %B33
	smull	x8, w22, w21
	sub	x20, x20, #8
	cmp	x8, w8, sxtw
	b.ne	.LBB430_15
// %bb.5:                               // %B40
	cbnz	w8, .LBB430_7
// %bb.6:                               // %B40
	orr	w9, w22, w21
	tbnz	w9, #31, .LBB430_16
.LBB430_7:                              // %B47
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB430_8:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB430_19
// %bb.9:                               // %B7
	cmp	x21, x8
	b.lo	.LBB430_17
// %bb.10:                              // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	.LBB430_14
.LBB430_11:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB430_19
// %bb.12:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB430_13:                             // %B28
	fmov	d1, x8
	fmul	d0, d0, d1
.LBB430_14:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB430_15:                             // %B35
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	fmul	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB430_16:                             // %B44
	mov	x22, #-9222809086901354496      // =0x8002000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB430_17:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB430_19
// %bb.18:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB430_13
.LBB430_19:                             // %B48
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        // =0x9a
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB430_21
// %bb.20:                              // %B50
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB430_21:                             // %B49
	b	.Lexception_spill_top1_asm_h
.Lfunc_end430:
	.size	.Lmul_1_asm_h, .Lfunc_end430-.Lmul_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function div_1_asm_h
	.type	.Ldiv_1_asm_h,@function
.Ldiv_1_asm_h:                          // @div_1_asm_h
// %bb.0:                               // %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB431_14
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB431_14
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB431_5
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB431_8
// %bb.4:                               // %B33
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x8, #562949953421312            // =0x2000000000000
	ldrb	w10, [x19], #1
	mov	x12, #9221683186994511872       // =0x7ffa000000000000
	sub	x20, x20, #8
	add	w10, w10, #247
	fdiv	d0, d0, d1
	ldr	x1, [x25, w10, uxtw #3]
	fcvtzs	w9, d0
	fmov	x11, d0
	fcmp	d0, d0
	add	x8, x11, x8
	csel	x8, x8, x12, vc
	cmp	x9, x11
	orr	x9, x9, #0xfffe000000000000
	csel	x22, x8, x9, ne
	br	x1
.LBB431_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB431_14
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB431_12
// %bb.7:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	.LBB431_11
.LBB431_8:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB431_14
// %bb.9:                               // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB431_10:                             // %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
.LBB431_11:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB431_12:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB431_14
// %bb.13:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB431_10
.LBB431_14:                             // %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        // =0x9b
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB431_16
// %bb.15:                              // %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB431_16:                             // %B42
	b	.Lexception_spill_top1_asm_h
.Lfunc_end431:
	.size	.Ldiv_1_asm_h, .Lfunc_end431-.Ldiv_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function mod_1_asm_h
	.type	.Lmod_1_asm_h,@function
.Lmod_1_asm_h:                          // @mod_1_asm_h
// %bb.0:                               // %B39
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB432_16
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB432_16
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB432_7
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB432_10
// %bb.4:                               // %B33
	tbnz	w22, #31, .LBB432_16
// %bb.5:                               // %B33
	cmp	w21, #1
	b.lt	.LBB432_16
// %bb.6:                               // %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB432_7:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB432_16
// %bb.8:                               // %B7
	cmp	x21, x8
	b.lo	.LBB432_14
// %bb.9:                               // %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	.LBB432_13
.LBB432_10:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB432_16
// %bb.11:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB432_12:                             // %B28
	fmov	d1, x8
.LBB432_13:                             // %B28
	bl	fmod
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB432_14:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB432_16
// %bb.15:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB432_12
.LBB432_16:                             // %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        // =0x9c
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB432_18
// %bb.17:                              // %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB432_18:                             // %B37
	b	.Lexception_spill_top1_asm_h
.Lfunc_end432:
	.size	.Lmod_1_asm_h, .Lfunc_end432-.Lmod_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_1_asm_h
	.type	.Ladd_1_asm_h,@function
.Ladd_1_asm_h:                          // @add_1_asm_h
// %bb.0:                               // %B46
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB433_16
// %bb.1:                               // %B46
	cmp	x21, x8
	b.hi	.LBB433_16
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB433_6
// %bb.3:                               // %B26
	cmp	x21, x8
	b.lo	.LBB433_9
// %bb.4:                               // %B36
	adds	w8, w22, w21
	sub	x20, x20, #8
	b.vs	.LBB433_13
// %bb.5:                               // %B42
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB433_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB433_16
// %bb.7:                               // %B11
	cmp	x21, x8
	b.lo	.LBB433_14
// %bb.8:                               // %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	.LBB433_12
.LBB433_9:                              // %B28
	tst	x21, #0xfffe000000000000
	b.eq	.LBB433_16
// %bb.10:                              // %B31
	scvtf	d0, w22
	add	x8, x21, x8
.LBB433_11:                             // %B31
	fmov	d1, x8
	fadd	d0, d0, d1
.LBB433_12:                             // %B31
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB433_13:                             // %B38
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	fadd	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB433_14:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB433_16
// %bb.15:                              // %B16
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB433_11
.LBB433_16:                             // %B7
	and	x8, x21, #0xffff000000000003
	mov	x10, #-281474976710653          // =0xffff000000000003
	mov	x11, #2                         // =0x2
	cmp	x8, x10
	movk	x11, #1, lsl #48
	and	x12, x22, #0xffff000000000003
	ccmp	x8, x11, #4, ne
	add	x8, x20, #8
	cset	w9, eq
	cmp	x12, x11
	ccmp	x12, x10, #4, ne
	b.ne	.LBB433_19
// %bb.17:                              // %B7
	cbz	w9, .LBB433_19
// %bb.18:                              // %B8
	mov	x20, x8
	stur	x21, [x8, #-8]
	mov	x0, xzr
	b	.LFastJSConcatString_asm_h
.LBB433_19:                             // %B43
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stur	x21, [x8, #-8]
	str	x8, [x23, #48]
	bl	prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	.LBB433_21
// %bb.20:                              // %B45
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB433_21:                             // %B44
	b	.Lexception_spill_top1_asm_h
.Lfunc_end433:
	.size	.Ladd_1_asm_h, .Lfunc_end433-.Ladd_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function sub_1_asm_h
	.type	.Lsub_1_asm_h,@function
.Lsub_1_asm_h:                          // @sub_1_asm_h
// %bb.0:                               // %B43
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB434_16
// %bb.1:                               // %B43
	cmp	x21, x8
	b.hi	.LBB434_16
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB434_6
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB434_9
// %bb.4:                               // %B33
	subs	w8, w22, w21
	sub	x20, x20, #8
	b.vs	.LBB434_13
// %bb.5:                               // %B39
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB434_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB434_16
// %bb.7:                               // %B7
	cmp	x21, x8
	b.lo	.LBB434_14
// %bb.8:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	.LBB434_12
.LBB434_9:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB434_16
// %bb.10:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB434_11:                             // %B28
	fmov	d1, x8
	fsub	d0, d0, d1
.LBB434_12:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB434_13:                             // %B35
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	fsub	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB434_14:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB434_16
// %bb.15:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB434_11
.LBB434_16:                             // %B40
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        // =0x9e
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB434_18
// %bb.17:                              // %B42
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB434_18:                             // %B41
	b	.Lexception_spill_top1_asm_h
.Lfunc_end434:
	.size	.Lsub_1_asm_h, .Lfunc_end434-.Lsub_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function pow_1_asm_h
	.type	.Lpow_1_asm_h,@function
.Lpow_1_asm_h:                          // @pow_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	mov	w3, #159                        // =0x9f
	mov	x1, x22
	str	x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB435_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB435_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end435:
	.size	.Lpow_1_asm_h, .Lfunc_end435-.Lpow_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function shl_1_asm_h
	.type	.Lshl_1_asm_h,@function
.Lshl_1_asm_h:                          // @shl_1_asm_h
// %bb.0:                               // %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB436_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB436_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB436_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB436_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB436_5:                              // %B16
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #8
	add	w9, w9, #247
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB436_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB436_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB436_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB436_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB436_5
.LBB436_10:                             // %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        // =0xa0
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB436_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB436_12:                             // %B26
	b	.Lexception_spill_top1_asm_h
.Lfunc_end436:
	.size	.Lshl_1_asm_h, .Lfunc_end436-.Lshl_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function sar_1_asm_h
	.type	.Lsar_1_asm_h,@function
.Lsar_1_asm_h:                          // @sar_1_asm_h
// %bb.0:                               // %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB437_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB437_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB437_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB437_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB437_5:                              // %B16
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #8
	add	w9, w9, #247
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB437_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB437_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB437_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB437_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB437_5
.LBB437_10:                             // %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        // =0xa1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB437_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB437_12:                             // %B26
	b	.Lexception_spill_top1_asm_h
.Lfunc_end437:
	.size	.Lsar_1_asm_h, .Lfunc_end437-.Lsar_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function shr_1_asm_h
	.type	.Lshr_1_asm_h,@function
.Lshr_1_asm_h:                          // @shr_1_asm_h
// %bb.0:                               // %B36
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB438_11
// %bb.1:                               // %B36
	cmp	x21, x8
	b.hi	.LBB438_11
// %bb.2:                               // %B10
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB438_6
// %bb.3:                               // %B27
	cmp	x21, x8
	b.lo	.LBB438_11
// %bb.4:                               // %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, .LBB438_10
.LBB438_5:                              // %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB438_6:                              // %B12
	tst	x22, #0xfffe000000000000
	b.eq	.LBB438_11
// %bb.7:                               // %B12
	cmp	x21, x8
	b.lo	.LBB438_11
// %bb.8:                               // %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB438_11
// %bb.9:                               // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, .LBB438_5
.LBB438_10:                             // %B6
	ucvtf	d0, w8
	mov	x9, #562949953421312            // =0x2000000000000
	fmov	x8, d0
	fcmp	d0, d0
	add	x8, x8, x9
	mov	x9, #9221683186994511872        // =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB438_11:                             // %B33
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	.LBB438_13
// %bb.12:                              // %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB438_13:                             // %B34
	b	.Lexception_spill_top1_asm_h
.Lfunc_end438:
	.size	.Lshr_1_asm_h, .Lfunc_end438-.Lshr_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lt_1_asm_h
	.type	.Llt_1_asm_h,@function
.Llt_1_asm_h:                           // @lt_1_asm_h
// %bb.0:                               // %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB439_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB439_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB439_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB439_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, lt
	br	x1
.LBB439_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB439_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB439_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB439_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB439_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB439_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB439_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB439_12:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        // =0xa3
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB439_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB439_14:                             // %B22
	b	.Lexception_spill_top1_asm_h
.Lfunc_end439:
	.size	.Llt_1_asm_h, .Lfunc_end439-.Llt_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lte_1_asm_h
	.type	.Llte_1_asm_h,@function
.Llte_1_asm_h:                          // @lte_1_asm_h
// %bb.0:                               // %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB440_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB440_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB440_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB440_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, le
	br	x1
.LBB440_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB440_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB440_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB440_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB440_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB440_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB440_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB440_12:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        // =0xa4
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB440_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB440_14:                             // %B22
	b	.Lexception_spill_top1_asm_h
.Lfunc_end440:
	.size	.Llte_1_asm_h, .Lfunc_end440-.Llte_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gt_1_asm_h
	.type	.Lgt_1_asm_h,@function
.Lgt_1_asm_h:                           // @gt_1_asm_h
// %bb.0:                               // %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB441_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB441_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB441_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB441_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB441_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB441_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB441_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB441_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB441_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB441_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB441_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB441_12:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        // =0xa5
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB441_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB441_14:                             // %B22
	b	.Lexception_spill_top1_asm_h
.Lfunc_end441:
	.size	.Lgt_1_asm_h, .Lfunc_end441-.Lgt_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gte_1_asm_h
	.type	.Lgte_1_asm_h,@function
.Lgte_1_asm_h:                          // @gte_1_asm_h
// %bb.0:                               // %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB442_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB442_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB442_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB442_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB442_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB442_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB442_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB442_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB442_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB442_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB442_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #247
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB442_12:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        // =0xa6
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB442_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB442_14:                             // %B22
	b	.Lexception_spill_top1_asm_h
.Lfunc_end442:
	.size	.Lgte_1_asm_h, .Lfunc_end442-.Lgte_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function instanceof_1_asm_h
	.type	.Linstanceof_1_asm_h,@function
.Linstanceof_1_asm_h:                   // @instanceof_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #48]
	bl	prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	.LBB443_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB443_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end443:
	.size	.Linstanceof_1_asm_h, .Lfunc_end443-.Linstanceof_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function in_1_asm_h
	.type	.Lin_1_asm_h,@function
.Lin_1_asm_h:                           // @in_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #48]
	bl	prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	.LBB444_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB444_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end444:
	.size	.Lin_1_asm_h, .Lfunc_end444-.Lin_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function eq_1_asm_h
	.type	.Leq_1_asm_h,@function
.Leq_1_asm_h:                           // @eq_1_asm_h
// %bb.0:                               // %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB445_13
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB445_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB445_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB445_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB445_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB445_13
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB445_11
// %bb.7:                               // %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #247
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB445_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB445_13
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB445_10:                             // %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #247
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB445_11:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB445_13
// %bb.12:                              // %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB445_10
.LBB445_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB445_15
.LBB445_14:                             // %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB445_15:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB445_17
// %bb.16:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB445_14
	b	.LBB445_20
.LBB445_17:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB445_20
// %bb.18:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB445_21
// %bb.19:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB445_21
.LBB445_20:                             // %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB445_21:                             // %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB445_23
// %bb.22:                              // %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB445_23:                             // %B42
	b	.Lexception_spill_top1_asm_h
.Lfunc_end445:
	.size	.Leq_1_asm_h, .Lfunc_end445-.Leq_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function neq_1_asm_h
	.type	.Lneq_1_asm_h,@function
.Lneq_1_asm_h:                          // @neq_1_asm_h
// %bb.0:                               // %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB446_13
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB446_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB446_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB446_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB446_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB446_13
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB446_11
// %bb.7:                               // %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #247
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB446_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB446_13
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB446_10:                             // %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #247
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB446_11:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB446_13
// %bb.12:                              // %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB446_10
.LBB446_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB446_15
.LBB446_14:                             // %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB446_15:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB446_17
// %bb.16:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB446_14
	b	.LBB446_20
.LBB446_17:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB446_20
// %bb.18:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB446_21
// %bb.19:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB446_21
.LBB446_20:                             // %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB446_21:                             // %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB446_23
// %bb.22:                              // %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB446_23:                             // %B42
	b	.Lexception_spill_top1_asm_h
.Lfunc_end446:
	.size	.Lneq_1_asm_h, .Lfunc_end446-.Lneq_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function strict_eq_1_asm_h
	.type	.Lstrict_eq_1_asm_h,@function
.Lstrict_eq_1_asm_h:                    // @strict_eq_1_asm_h
// %bb.0:                               // %B39
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB447_13
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB447_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB447_5
// %bb.3:                               // %B30
	cmp	x21, x8
	b.lo	.LBB447_8
// %bb.4:                               // %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB447_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB447_13
// %bb.6:                               // %B23
	cmp	x21, x8
	b.lo	.LBB447_11
// %bb.7:                               // %B28
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #247
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB447_8:                              // %B32
	tst	x21, #0xfffe000000000000
	b.eq	.LBB447_13
// %bb.9:                               // %B34
	scvtf	d0, w22
	add	x8, x21, x8
.LBB447_10:                             // %B34
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #247
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB447_11:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB447_13
// %bb.12:                              // %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB447_10
.LBB447_13:                             // %B10
	cmp	x22, x21
	b.ne	.LBB447_15
// %bb.14:                              // %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB447_15:                             // %B13
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x10, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w9, eq
	cmp	x10, x11
	ccmp	x10, x12, #4, ne
	cset	w11, eq
	cmp	w9, #1
	b.ne	.LBB447_17
// %bb.16:                              // %B13
	cbnz	w11, .LBB447_22
.LBB447_17:                             // %B16
	mov	x12, #2                         // =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, .LBB447_19
// %bb.18:                              // %B16
	tbnz	w8, #0, .LBB447_23
.LBB447_19:                             // %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x9, x8
	b.ne	.LBB447_21
// %bb.20:                              // %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	.LBB447_25
.LBB447_21:                             // %B21
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB447_22:                             // %B14
	str	x21, [x20], #8
	mov	x0, xzr
	b	.LFastStringEqual_asm_h
.LBB447_23:                             // %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB447_27
// %bb.24:                              // %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB447_25:                             // %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #8
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB447_28
// %bb.26:                              // %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB447_27:                             // %B37
	b	.Lexception_spill_top1_asm_h
.LBB447_28:                             // %B8
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end447:
	.size	.Lstrict_eq_1_asm_h, .Lfunc_end447-.Lstrict_eq_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function strict_neq_1_asm_h
	.type	.Lstrict_neq_1_asm_h,@function
.Lstrict_neq_1_asm_h:                   // @strict_neq_1_asm_h
// %bb.0:                               // %B39
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB448_13
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB448_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB448_5
// %bb.3:                               // %B30
	cmp	x21, x8
	b.lo	.LBB448_8
// %bb.4:                               // %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB448_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB448_13
// %bb.6:                               // %B23
	cmp	x21, x8
	b.lo	.LBB448_11
// %bb.7:                               // %B28
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #247
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB448_8:                              // %B32
	tst	x21, #0xfffe000000000000
	b.eq	.LBB448_13
// %bb.9:                               // %B34
	scvtf	d0, w22
	add	x8, x21, x8
.LBB448_10:                             // %B34
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #247
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB448_11:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB448_13
// %bb.12:                              // %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB448_10
.LBB448_13:                             // %B10
	cmp	x22, x21
	b.ne	.LBB448_15
// %bb.14:                              // %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB448_15:                             // %B13
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x10, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w9, eq
	cmp	x10, x11
	ccmp	x10, x12, #4, ne
	cset	w11, eq
	cmp	w9, #1
	b.ne	.LBB448_17
// %bb.16:                              // %B13
	cbnz	w11, .LBB448_22
.LBB448_17:                             // %B16
	mov	x12, #2                         // =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, .LBB448_19
// %bb.18:                              // %B16
	tbnz	w8, #0, .LBB448_23
.LBB448_19:                             // %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x9, x8
	b.ne	.LBB448_21
// %bb.20:                              // %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	.LBB448_25
.LBB448_21:                             // %B21
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB448_22:                             // %B14
	str	x21, [x20], #8
	mov	w0, #1                          // =0x1
	b	.LFastStringEqual_asm_h
.LBB448_23:                             // %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB448_27
// %bb.24:                              // %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB448_25:                             // %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #8
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB448_28
// %bb.26:                              // %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB448_27:                             // %B37
	b	.Lexception_spill_top1_asm_h
.LBB448_28:                             // %B8
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end448:
	.size	.Lstrict_neq_1_asm_h, .Lfunc_end448-.Lstrict_neq_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function and_1_asm_h
	.type	.Land_1_asm_h,@function
.Land_1_asm_h:                          // @and_1_asm_h
// %bb.0:                               // %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB449_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB449_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB449_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB449_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB449_5:                              // %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	and	w8, w8, w21
	add	w9, w9, #247
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB449_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB449_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB449_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB449_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB449_5
.LBB449_10:                             // %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        // =0xad
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB449_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB449_12:                             // %B26
	b	.Lexception_spill_top1_asm_h
.Lfunc_end449:
	.size	.Land_1_asm_h, .Lfunc_end449-.Land_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function xor_1_asm_h
	.type	.Lxor_1_asm_h,@function
.Lxor_1_asm_h:                          // @xor_1_asm_h
// %bb.0:                               // %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB450_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB450_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB450_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB450_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB450_5:                              // %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	eor	w8, w8, w21
	add	w9, w9, #247
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB450_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB450_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB450_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB450_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB450_5
.LBB450_10:                             // %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        // =0xae
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB450_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB450_12:                             // %B26
	b	.Lexception_spill_top1_asm_h
.Lfunc_end450:
	.size	.Lxor_1_asm_h, .Lfunc_end450-.Lxor_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function or_1_asm_h
	.type	.Lor_1_asm_h,@function
.Lor_1_asm_h:                           // @or_1_asm_h
// %bb.0:                               // %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB451_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB451_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB451_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB451_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB451_5:                              // %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	w8, w8, w21
	add	w9, w9, #247
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB451_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB451_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB451_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB451_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB451_5
.LBB451_10:                             // %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        // =0xaf
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB451_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB451_12:                             // %B26
	b	.Lexception_spill_top1_asm_h
.Lfunc_end451:
	.size	.Lor_1_asm_h, .Lfunc_end451-.Lor_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nop_1_asm_h
	.type	.Lnop_1_asm_h,@function
.Lnop_1_asm_h:                          // @nop_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end452:
	.size	.Lnop_1_asm_h, .Lfunc_end452-.Lnop_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_minus1_1_asm_h
	.type	.Lpush_minus1_1_asm_h,@function
.Lpush_minus1_1_asm_h:                  // @push_minus1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562945658454017          // =0xfffe0000ffffffff
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end453:
	.size	.Lpush_minus1_1_asm_h, .Lfunc_end453-.Lpush_minus1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_0_1_asm_h
	.type	.Lpush_0_1_asm_h,@function
.Lpush_0_1_asm_h:                       // @push_0_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421312          // =0xfffe000000000000
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end454:
	.size	.Lpush_0_1_asm_h, .Lfunc_end454-.Lpush_0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_1_1_asm_h
	.type	.Lpush_1_1_asm_h,@function
.Lpush_1_1_asm_h:                       // @push_1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421311          // =0xfffe000000000001
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end455:
	.size	.Lpush_1_1_asm_h, .Lfunc_end455-.Lpush_1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_2_1_asm_h
	.type	.Lpush_2_1_asm_h,@function
.Lpush_2_1_asm_h:                       // @push_2_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #2                         // =0x2
	movk	x21, #65534, lsl #48
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end456:
	.size	.Lpush_2_1_asm_h, .Lfunc_end456-.Lpush_2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_3_1_asm_h
	.type	.Lpush_3_1_asm_h,@function
.Lpush_3_1_asm_h:                       // @push_3_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421309          // =0xfffe000000000003
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end457:
	.size	.Lpush_3_1_asm_h, .Lfunc_end457-.Lpush_3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_4_1_asm_h
	.type	.Lpush_4_1_asm_h,@function
.Lpush_4_1_asm_h:                       // @push_4_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #4                         // =0x4
	movk	x21, #65534, lsl #48
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end458:
	.size	.Lpush_4_1_asm_h, .Lfunc_end458-.Lpush_4_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_5_1_asm_h
	.type	.Lpush_5_1_asm_h,@function
.Lpush_5_1_asm_h:                       // @push_5_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #5                         // =0x5
	movk	x21, #65534, lsl #48
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end459:
	.size	.Lpush_5_1_asm_h, .Lfunc_end459-.Lpush_5_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_6_1_asm_h
	.type	.Lpush_6_1_asm_h,@function
.Lpush_6_1_asm_h:                       // @push_6_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #6                         // =0x6
	movk	x21, #65534, lsl #48
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end460:
	.size	.Lpush_6_1_asm_h, .Lfunc_end460-.Lpush_6_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_7_1_asm_h
	.type	.Lpush_7_1_asm_h,@function
.Lpush_7_1_asm_h:                       // @push_7_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421305          // =0xfffe000000000007
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end461:
	.size	.Lpush_7_1_asm_h, .Lfunc_end461-.Lpush_7_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i8_1_asm_h
	.type	.Lpush_i8_1_asm_h,@function
.Lpush_i8_1_asm_h:                      // @push_i8_1_asm_h
// %bb.0:                               // %B0
	ldrb	w9, [x19, #1]
	ldrsb	x10, [x19]
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x19, x19, #2
	add	w9, w9, #494
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x8
	br	x1
.Lfunc_end462:
	.size	.Lpush_i8_1_asm_h, .Lfunc_end462-.Lpush_i8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i16_1_asm_h
	.type	.Lpush_i16_1_asm_h,@function
.Lpush_i16_1_asm_h:                     // @push_i16_1_asm_h
// %bb.0:                               // %B0
	ldrb	w9, [x19, #2]
	ldrsh	x10, [x19]
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x19, x19, #3
	add	w9, w9, #494
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x8
	br	x1
.Lfunc_end463:
	.size	.Lpush_i16_1_asm_h, .Lfunc_end463-.Lpush_i16_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_const8_1_asm_h
	.type	.Lpush_const8_1_asm_h,@function
.Lpush_const8_1_asm_h:                  // @push_const8_1_asm_h
// %bb.0:                               // %B0
	ldrb	w9, [x19, #1]
	ldr	x8, [x23, #104]
	ldrb	w10, [x19], #2
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x21, [x8, x10, lsl #3]
	br	x1
.Lfunc_end464:
	.size	.Lpush_const8_1_asm_h, .Lfunc_end464-.Lpush_const8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function fclosure8_1_asm_h
	.type	.Lfclosure8_1_asm_h,@function
.Lfclosure8_1_asm_h:                    // @fclosure8_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lfclosure8_0_asm_h
.Lfunc_end465:
	.size	.Lfclosure8_1_asm_h, .Lfunc_end465-.Lfclosure8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_empty_string_1_asm_h
	.type	.Lpush_empty_string_1_asm_h,@function
.Lpush_empty_string_1_asm_h:            // @push_empty_string_1_asm_h
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	mov	w1, #47                         // =0x2f
	mov	w2, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB466_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB466_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end466:
	.size	.Lpush_empty_string_1_asm_h, .Lfunc_end466-.Lpush_empty_string_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc8_1_asm_h
	.type	.Lget_loc8_1_asm_h,@function
.Lget_loc8_1_asm_h:                     // @get_loc8_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #1]
	ldrb	w9, [x19], #2
	add	w8, w8, #494
	ldr	x21, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end467:
	.size	.Lget_loc8_1_asm_h, .Lfunc_end467-.Lget_loc8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc8_1_asm_h
	.type	.Lput_loc8_1_asm_h,@function
.Lput_loc8_1_asm_h:                     // @put_loc8_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end468:
	.size	.Lput_loc8_1_asm_h, .Lfunc_end468-.Lput_loc8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc8_1_asm_h
	.type	.Lset_loc8_1_asm_h,@function
.Lset_loc8_1_asm_h:                     // @set_loc8_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end469:
	.size	.Lset_loc8_1_asm_h, .Lfunc_end469-.Lset_loc8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc0_1_asm_h
	.type	.Lget_loc0_1_asm_h,@function
.Lget_loc0_1_asm_h:                     // @get_loc0_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27]
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end470:
	.size	.Lget_loc0_1_asm_h, .Lfunc_end470-.Lget_loc0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc1_1_asm_h
	.type	.Lget_loc1_1_asm_h,@function
.Lget_loc1_1_asm_h:                     // @get_loc1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27, #8]
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end471:
	.size	.Lget_loc1_1_asm_h, .Lfunc_end471-.Lget_loc1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc2_1_asm_h
	.type	.Lget_loc2_1_asm_h,@function
.Lget_loc2_1_asm_h:                     // @get_loc2_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27, #16]
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end472:
	.size	.Lget_loc2_1_asm_h, .Lfunc_end472-.Lget_loc2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc3_1_asm_h
	.type	.Lget_loc3_1_asm_h,@function
.Lget_loc3_1_asm_h:                     // @get_loc3_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27, #24]
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end473:
	.size	.Lget_loc3_1_asm_h, .Lfunc_end473-.Lget_loc3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc0_1_asm_h
	.type	.Lput_loc0_1_asm_h,@function
.Lput_loc0_1_asm_h:                     // @put_loc0_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end474:
	.size	.Lput_loc0_1_asm_h, .Lfunc_end474-.Lput_loc0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc1_1_asm_h
	.type	.Lput_loc1_1_asm_h,@function
.Lput_loc1_1_asm_h:                     // @put_loc1_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end475:
	.size	.Lput_loc1_1_asm_h, .Lfunc_end475-.Lput_loc1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc2_1_asm_h
	.type	.Lput_loc2_1_asm_h,@function
.Lput_loc2_1_asm_h:                     // @put_loc2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end476:
	.size	.Lput_loc2_1_asm_h, .Lfunc_end476-.Lput_loc2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc3_1_asm_h
	.type	.Lput_loc3_1_asm_h,@function
.Lput_loc3_1_asm_h:                     // @put_loc3_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end477:
	.size	.Lput_loc3_1_asm_h, .Lfunc_end477-.Lput_loc3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc0_1_asm_h
	.type	.Lset_loc0_1_asm_h,@function
.Lset_loc0_1_asm_h:                     // @set_loc0_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end478:
	.size	.Lset_loc0_1_asm_h, .Lfunc_end478-.Lset_loc0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc1_1_asm_h
	.type	.Lset_loc1_1_asm_h,@function
.Lset_loc1_1_asm_h:                     // @set_loc1_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end479:
	.size	.Lset_loc1_1_asm_h, .Lfunc_end479-.Lset_loc1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc2_1_asm_h
	.type	.Lset_loc2_1_asm_h,@function
.Lset_loc2_1_asm_h:                     // @set_loc2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end480:
	.size	.Lset_loc2_1_asm_h, .Lfunc_end480-.Lset_loc2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc3_1_asm_h
	.type	.Lset_loc3_1_asm_h,@function
.Lset_loc3_1_asm_h:                     // @set_loc3_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end481:
	.size	.Lset_loc3_1_asm_h, .Lfunc_end481-.Lset_loc3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg0_1_asm_h
	.type	.Lget_arg0_1_asm_h,@function
.Lget_arg0_1_asm_h:                     // @get_arg0_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28]
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end482:
	.size	.Lget_arg0_1_asm_h, .Lfunc_end482-.Lget_arg0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg1_1_asm_h
	.type	.Lget_arg1_1_asm_h,@function
.Lget_arg1_1_asm_h:                     // @get_arg1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28, #8]
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end483:
	.size	.Lget_arg1_1_asm_h, .Lfunc_end483-.Lget_arg1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg2_1_asm_h
	.type	.Lget_arg2_1_asm_h,@function
.Lget_arg2_1_asm_h:                     // @get_arg2_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28, #16]
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end484:
	.size	.Lget_arg2_1_asm_h, .Lfunc_end484-.Lget_arg2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg3_1_asm_h
	.type	.Lget_arg3_1_asm_h,@function
.Lget_arg3_1_asm_h:                     // @get_arg3_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28, #24]
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end485:
	.size	.Lget_arg3_1_asm_h, .Lfunc_end485-.Lget_arg3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg0_1_asm_h
	.type	.Lput_arg0_1_asm_h,@function
.Lput_arg0_1_asm_h:                     // @put_arg0_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end486:
	.size	.Lput_arg0_1_asm_h, .Lfunc_end486-.Lput_arg0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg1_1_asm_h
	.type	.Lput_arg1_1_asm_h,@function
.Lput_arg1_1_asm_h:                     // @put_arg1_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end487:
	.size	.Lput_arg1_1_asm_h, .Lfunc_end487-.Lput_arg1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg2_1_asm_h
	.type	.Lput_arg2_1_asm_h,@function
.Lput_arg2_1_asm_h:                     // @put_arg2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end488:
	.size	.Lput_arg2_1_asm_h, .Lfunc_end488-.Lput_arg2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg3_1_asm_h
	.type	.Lput_arg3_1_asm_h,@function
.Lput_arg3_1_asm_h:                     // @put_arg3_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end489:
	.size	.Lput_arg3_1_asm_h, .Lfunc_end489-.Lput_arg3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg0_1_asm_h
	.type	.Lset_arg0_1_asm_h,@function
.Lset_arg0_1_asm_h:                     // @set_arg0_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end490:
	.size	.Lset_arg0_1_asm_h, .Lfunc_end490-.Lset_arg0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg1_1_asm_h
	.type	.Lset_arg1_1_asm_h,@function
.Lset_arg1_1_asm_h:                     // @set_arg1_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end491:
	.size	.Lset_arg1_1_asm_h, .Lfunc_end491-.Lset_arg1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg2_1_asm_h
	.type	.Lset_arg2_1_asm_h,@function
.Lset_arg2_1_asm_h:                     // @set_arg2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end492:
	.size	.Lset_arg2_1_asm_h, .Lfunc_end492-.Lset_arg2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg3_1_asm_h
	.type	.Lset_arg3_1_asm_h,@function
.Lset_arg3_1_asm_h:                     // @set_arg3_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end493:
	.size	.Lset_arg3_1_asm_h, .Lfunc_end493-.Lset_arg3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref0_1_asm_h
	.type	.Lget_var_ref0_1_asm_h,@function
.Lget_var_ref0_1_asm_h:                 // @get_var_ref0_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x21, [x8]
	br	x1
.Lfunc_end494:
	.size	.Lget_var_ref0_1_asm_h, .Lfunc_end494-.Lget_var_ref0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref1_1_asm_h
	.type	.Lget_var_ref1_1_asm_h,@function
.Lget_var_ref1_1_asm_h:                 // @get_var_ref1_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x21, [x8]
	br	x1
.Lfunc_end495:
	.size	.Lget_var_ref1_1_asm_h, .Lfunc_end495-.Lget_var_ref1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref2_1_asm_h
	.type	.Lget_var_ref2_1_asm_h,@function
.Lget_var_ref2_1_asm_h:                 // @get_var_ref2_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x21, [x8]
	br	x1
.Lfunc_end496:
	.size	.Lget_var_ref2_1_asm_h, .Lfunc_end496-.Lget_var_ref2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref3_1_asm_h
	.type	.Lget_var_ref3_1_asm_h,@function
.Lget_var_ref3_1_asm_h:                 // @get_var_ref3_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x21, [x8]
	br	x1
.Lfunc_end497:
	.size	.Lget_var_ref3_1_asm_h, .Lfunc_end497-.Lget_var_ref3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref0_1_asm_h
	.type	.Lput_var_ref0_1_asm_h,@function
.Lput_var_ref0_1_asm_h:                 // @put_var_ref0_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end498:
	.size	.Lput_var_ref0_1_asm_h, .Lfunc_end498-.Lput_var_ref0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref1_1_asm_h
	.type	.Lput_var_ref1_1_asm_h,@function
.Lput_var_ref1_1_asm_h:                 // @put_var_ref1_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end499:
	.size	.Lput_var_ref1_1_asm_h, .Lfunc_end499-.Lput_var_ref1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref2_1_asm_h
	.type	.Lput_var_ref2_1_asm_h,@function
.Lput_var_ref2_1_asm_h:                 // @put_var_ref2_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end500:
	.size	.Lput_var_ref2_1_asm_h, .Lfunc_end500-.Lput_var_ref2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref3_1_asm_h
	.type	.Lput_var_ref3_1_asm_h,@function
.Lput_var_ref3_1_asm_h:                 // @put_var_ref3_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end501:
	.size	.Lput_var_ref3_1_asm_h, .Lfunc_end501-.Lput_var_ref3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref0_1_asm_h
	.type	.Lset_var_ref0_1_asm_h,@function
.Lset_var_ref0_1_asm_h:                 // @set_var_ref0_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end502:
	.size	.Lset_var_ref0_1_asm_h, .Lfunc_end502-.Lset_var_ref0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref1_1_asm_h
	.type	.Lset_var_ref1_1_asm_h,@function
.Lset_var_ref1_1_asm_h:                 // @set_var_ref1_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end503:
	.size	.Lset_var_ref1_1_asm_h, .Lfunc_end503-.Lset_var_ref1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref2_1_asm_h
	.type	.Lset_var_ref2_1_asm_h,@function
.Lset_var_ref2_1_asm_h:                 // @set_var_ref2_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end504:
	.size	.Lset_var_ref2_1_asm_h, .Lfunc_end504-.Lset_var_ref2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref3_1_asm_h
	.type	.Lset_var_ref3_1_asm_h,@function
.Lset_var_ref3_1_asm_h:                 // @set_var_ref3_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end505:
	.size	.Lset_var_ref3_1_asm_h, .Lfunc_end505-.Lset_var_ref3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_length_1_asm_h
	.type	.Lget_length_1_asm_h,@function
.Lget_length_1_asm_h:                   // @get_length_1_asm_h
// %bb.0:                               // %B27
	mov	x9, #2                          // =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	.LBB506_2
// %bb.1:                               // %B27
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB506_3
.LBB506_2:                              // %B28
	and	x8, x22, #0xfffffffffffc
	ldrb	w9, [x19], #1
	ldr	w8, [x8, #4]
	mov	x10, #-562949953421312          // =0xfffe000000000000
	add	w9, w9, #247
	bfxil	x10, x8, #0, #30
	ldr	x1, [x25, w9, uxtw #3]
	mov	x22, x10
	br	x1
.LBB506_3:                              // %B21
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB506_13
// %bb.4:                               // %B22
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB506_5:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB506_6 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w11, #0x30
	ldr	w10, [x13, w10, uxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB506_8
.LBB506_6:                              // %B1
                                        //   Parent Loop BB506_5 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, #48
	b.eq	.LBB506_10
// %bb.7:                               // %B9
                                        //   in Loop: Header=BB506_6 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB506_6
.LBB506_8:                              // %B14
                                        //   in Loop: Header=BB506_5 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB506_13
// %bb.9:                               // %B17
                                        //   in Loop: Header=BB506_5 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB506_5
	b	.LBB506_12
.LBB506_10:                             // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB506_13
// %bb.11:                              // %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB506_12:                             // %B6
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB506_13:                             // %B24
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #48                         // =0x30
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB506_15
// %bb.14:                              // %B26
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB506_15:                             // %B25
	b	.Lexception_spill_top0_asm_h
.Lfunc_end506:
	.size	.Lget_length_1_asm_h, .Lfunc_end506-.Lget_length_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_false8_1_asm_h
	.type	.Lif_false8_1_asm_h,@function
.Lif_false8_1_asm_h:                    // @if_false8_1_asm_h
// %bb.0:                               // %B23
	cmp	x22, #5
	b.le	.LBB507_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB507_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB507_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB507_6
	b	.LBB507_7
.LBB507_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB507_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB507_7
.LBB507_6:                              // %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB507_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB507_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB507_10
.LBB507_9:                              // %B19
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB507_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB507_13
// %bb.11:                              // %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB507_6
	b.vs	.LBB507_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB507_9
	b	.LBB507_6
.LBB507_13:                             // %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.Lfunc_end507:
	.size	.Lif_false8_1_asm_h, .Lfunc_end507-.Lif_false8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_true8_1_asm_h
	.type	.Lif_true8_1_asm_h,@function
.Lif_true8_1_asm_h:                     // @if_true8_1_asm_h
// %bb.0:                               // %B23
	cmp	x22, #5
	b.le	.LBB508_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB508_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB508_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB508_6
	b	.LBB508_7
.LBB508_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB508_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB508_7
.LBB508_6:                              // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB508_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB508_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB508_10
.LBB508_9:                              // %B19
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB508_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB508_13
// %bb.11:                              // %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB508_6
	b.vs	.LBB508_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB508_9
	b	.LBB508_6
.LBB508_13:                             // %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.Lfunc_end508:
	.size	.Lif_true8_1_asm_h, .Lfunc_end508-.Lif_true8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function goto8_1_asm_h
	.type	.Lgoto8_1_asm_h,@function
.Lgoto8_1_asm_h:                        // @goto8_1_asm_h
// %bb.0:                               // %B0
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end509:
	.size	.Lgoto8_1_asm_h, .Lfunc_end509-.Lgoto8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function goto16_1_asm_h
	.type	.Lgoto16_1_asm_h,@function
.Lgoto16_1_asm_h:                       // @goto16_1_asm_h
// %bb.0:                               // %B0
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end510:
	.size	.Lgoto16_1_asm_h, .Lfunc_end510-.Lgoto16_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call0_1_asm_h
	.type	.Lcall0_1_asm_h,@function
.Lcall0_1_asm_h:                        // @call0_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcall0_0_asm_h
.Lfunc_end511:
	.size	.Lcall0_1_asm_h, .Lfunc_end511-.Lcall0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call1_1_asm_h
	.type	.Lcall1_1_asm_h,@function
.Lcall1_1_asm_h:                        // @call1_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcall1_0_asm_h
.Lfunc_end512:
	.size	.Lcall1_1_asm_h, .Lfunc_end512-.Lcall1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call2_1_asm_h
	.type	.Lcall2_1_asm_h,@function
.Lcall2_1_asm_h:                        // @call2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcall2_0_asm_h
.Lfunc_end513:
	.size	.Lcall2_1_asm_h, .Lfunc_end513-.Lcall2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call3_1_asm_h
	.type	.Lcall3_1_asm_h,@function
.Lcall3_1_asm_h:                        // @call3_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcall3_0_asm_h
.Lfunc_end514:
	.size	.Lcall3_1_asm_h, .Lfunc_end514-.Lcall3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_undefined_1_asm_h
	.type	.Lis_undefined_1_asm_h,@function
.Lis_undefined_1_asm_h:                 // @is_undefined_1_asm_h
// %bb.0:                               // %B2
	cmp	x22, #18
	b.ne	.LBB515_2
// %bb.1:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB515_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end515:
	.size	.Lis_undefined_1_asm_h, .Lfunc_end515-.Lis_undefined_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_null_1_asm_h
	.type	.Lis_null_1_asm_h,@function
.Lis_null_1_asm_h:                      // @is_null_1_asm_h
// %bb.0:                               // %B2
	cmp	x22, #2
	b.ne	.LBB516_2
// %bb.1:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB516_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end516:
	.size	.Lis_null_1_asm_h, .Lfunc_end516-.Lis_null_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_function_1_asm_h
	.type	.Lis_function_1_asm_h,@function
.Lis_function_1_asm_h:                  // @is_function_1_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x22
	bl	js_operator_typeof_gc
	cmp	w0, #27
	b.ne	.LBB517_2
// %bb.1:                               // %B2
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB517_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end517:
	.size	.Lis_function_1_asm_h, .Lfunc_end517-.Lis_function_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_coverage_1_asm_h
	.type	.Linc_coverage_1_asm_h,@function
.Linc_coverage_1_asm_h:                 // @inc_coverage_1_asm_h
// %bb.0:                               // %B10
	ldr	x8, [x23, #8]
	ldr	x1, [x8, #32]
	ldr	x8, [x1, #112]
	cbz	x8, .LBB518_3
// %bb.1:                               // %B7
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbnz	x8, .LBB518_4
.LBB518_2:                              // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB518_3:                              // %B11
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	EnsureCoverageCounters
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbz	x8, .LBB518_2
.LBB518_4:                              // %B2
	ldr	w9, [x19]
	ldr	w10, [x10, #104]
	cmp	w9, w10
	b.hs	.LBB518_2
// %bb.5:                               // %B6
	ldr	w10, [x8, w9, sxtw #2]
	add	w10, w10, #1
	str	w10, [x8, w9, sxtw #2]
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end518:
	.size	.Linc_coverage_1_asm_h, .Lfunc_end518-.Linc_coverage_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_global_ref_undef_1_asm_h
	.type	.Lget_global_ref_undef_1_asm_h,@function
.Lget_global_ref_undef_1_asm_h:         // @get_global_ref_undef_1_asm_h
// %bb.0:                               // %B6
	ldr	x8, [x23, #8]
	ldrh	w9, [x19]
	ldr	x8, [x8, #40]
	ldr	x8, [x8, x9, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB519_2
.LBB519_1:                              // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB519_2:                              // %B1
	ldr	x1, [x23, #8]
	ldrh	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w3, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetGlobalRef_GC
	cmp	x0, #130
	mov	x8, x0
	b.ne	.LBB519_1
// %bb.3:                               // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end519:
	.size	.Lget_global_ref_undef_1_asm_h, .Lfunc_end519-.Lget_global_ref_undef_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_global_ref_1_asm_h
	.type	.Lget_global_ref_1_asm_h,@function
.Lget_global_ref_1_asm_h:               // @get_global_ref_1_asm_h
// %bb.0:                               // %B6
	ldr	x8, [x23, #8]
	ldrh	w9, [x19]
	ldr	x8, [x8, #40]
	ldr	x8, [x8, x9, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB520_2
.LBB520_1:                              // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB520_2:                              // %B1
	ldr	x1, [x23, #8]
	ldrh	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetGlobalRef_GC
	cmp	x0, #130
	mov	x8, x0
	b.ne	.LBB520_1
// %bb.3:                               // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end520:
	.size	.Lget_global_ref_1_asm_h, .Lfunc_end520-.Lget_global_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_global_ref_1_asm_h
	.type	.Lput_global_ref_1_asm_h,@function
.Lput_global_ref_1_asm_h:               // @put_global_ref_1_asm_h
// %bb.0:                               // %B10
	ldr	x8, [x23, #8]
	ldrh	w9, [x19]
	ldr	x8, [x8, #40]
	ldr	x8, [x8, x9, lsl #3]
	ldr	x9, [x8]
	and	x8, x9, #0xfffffffffffffffc
	and	w9, w9, #0x2
	ldr	x10, [x8]
	cmp	x10, #34
	ccmp	w9, #0, #0, ne
	b.ne	.LBB521_3
// %bb.1:                               // %B1
	str	x22, [x8]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB521_5
.LBB521_2:                              // %B4
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB521_3:                              // %B7
	ldr	x1, [x23, #8]
	ldrh	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_SetGlobalRef_GC
	tbz	w0, #31, .LBB521_2
// %bb.4:                               // %B8
	b	.Lexception_spill_top0_asm_h
.LBB521_5:                              // %B6
	mov	x0, x22
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end521:
	.size	.Lput_global_ref_1_asm_h, .Lfunc_end521-.Lput_global_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_global_ref_init_1_asm_h
	.type	.Lput_global_ref_init_1_asm_h,@function
.Lput_global_ref_init_1_asm_h:          // @put_global_ref_init_1_asm_h
// %bb.0:                               // %B1
	ldr	x1, [x23, #8]
	ldrh	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x3, x22
	mov	w4, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_SetGlobalRef_GC
	tbnz	w0, #31, .LBB522_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB522_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end522:
	.size	.Lput_global_ref_init_1_asm_h, .Lfunc_end522-.Lput_global_ref_init_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function invalid_2_asm_h
	.type	.Linvalid_2_asm_h,@function
.Linvalid_2_asm_h:                      // @invalid_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #8]
	adrp	x1, .L__unnamed_16
	add	x1, x1, :lo12:.L__unnamed_16
	mov	x0, x24
	mov	w3, wzr
	ldr	x8, [x8, #32]
	ldr	w8, [x8, #8]
	str	x20, [x23, #48]
	mvn	w8, w8
	add	w2, w8, w19
	bl	LEPUS_ThrowInternalError
	b	.Lexception_asm_h
.Lfunc_end523:
	.size	.Linvalid_2_asm_h, .Lfunc_end523-.Linvalid_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i32_2_asm_h
	.type	.Lpush_i32_2_asm_h,@function
.Lpush_i32_2_asm_h:                     // @push_i32_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #4]
	ldr	w9, [x19], #5
	add	w8, w8, #494
	orr	x21, x9, #0xfffe000000000000
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end524:
	.size	.Lpush_i32_2_asm_h, .Lfunc_end524-.Lpush_i32_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_const_2_asm_h
	.type	.Lpush_const_2_asm_h,@function
.Lpush_const_2_asm_h:                   // @push_const_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #4]
	ldr	x9, [x23, #104]
	ldrsw	x10, [x19]
	add	x19, x19, #5
	add	w8, w8, #494
	ldr	x9, [x9, x10, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x9
	br	x1
.Lfunc_end525:
	.size	.Lpush_const_2_asm_h, .Lfunc_end525-.Lpush_const_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function fclosure_2_asm_h
	.type	.Lfclosure_2_asm_h,@function
.Lfclosure_2_asm_h:                     // @fclosure_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lfclosure_0_asm_h
.Lfunc_end526:
	.size	.Lfclosure_2_asm_h, .Lfunc_end526-.Lfclosure_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_atom_value_2_asm_h
	.type	.Lpush_atom_value_2_asm_h,@function
.Lpush_atom_value_2_asm_h:              // @push_atom_value_2_asm_h
// %bb.0:                               // %B13
	str	x22, [x20], #8
	ldr	w1, [x19]
	tbnz	w1, #31, .LBB527_5
// %bb.1:                               // %B1
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, sxtw #3]
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, .LBB527_4
// %bb.2:                               // %B9
	ldr	w9, [x8, #8]
	asr	w9, w9, #30
	cmp	w9, #1
	b.ne	.LBB527_5
.LBB527_3:                              // %B7
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	mov	x9, #2                          // =0x2
	movk	x9, #1, lsl #48
	orr	x21, x8, x9
	br	x1
.LBB527_4:                              // %B2
	ldr	x9, [x8, #8]
	ldr	w9, [x9]
	asr	w9, w9, #30
	cmp	w9, #1
	b.eq	.LBB527_3
.LBB527_5:                              // %B10
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB527_7
// %bb.6:                               // %B12
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB527_7:                              // %B11
	b	.Lexception_spill_top1_asm_h
.Lfunc_end527:
	.size	.Lpush_atom_value_2_asm_h, .Lfunc_end527-.Lpush_atom_value_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function private_symbol_2_asm_h
	.type	.Lprivate_symbol_2_asm_h,@function
.Lprivate_symbol_2_asm_h:               // @private_symbol_2_asm_h
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	mov	w2, #4                          // =0x4
	ldr	w1, [x19]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #48]
	bl	JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	.LBB528_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB528_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end528:
	.size	.Lprivate_symbol_2_asm_h, .Lfunc_end528-.Lprivate_symbol_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function undefined_2_asm_h
	.type	.Lundefined_2_asm_h,@function
.Lundefined_2_asm_h:                    // @undefined_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #18                        // =0x12
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end529:
	.size	.Lundefined_2_asm_h, .Lfunc_end529-.Lundefined_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function null_2_asm_h
	.type	.Lnull_2_asm_h,@function
.Lnull_2_asm_h:                         // @null_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #2                         // =0x2
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end530:
	.size	.Lnull_2_asm_h, .Lfunc_end530-.Lnull_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_this_2_asm_h
	.type	.Lpush_this_2_asm_h,@function
.Lpush_this_2_asm_h:                    // @push_this_2_asm_h
// %bb.0:                               // %B12
	str	x22, [x20], #8
	ldr	w8, [x23, #44]
	ldr	x1, [x23, #80]
	tbnz	w8, #0, .LBB531_2
// %bb.1:                               // %B12
	ldr	x8, [x23, #80]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, .LBB531_3
.LBB531_2:                              // %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x1
	add	w8, w8, #494
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.LBB531_3:                              // %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	.LBB531_5
// %bb.4:                               // %B7
	ldrb	w8, [x19], #1
	ldr	x9, [x24, #208]
	mov	x22, x21
	add	w8, w8, #494
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB531_5:                              // %B9
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB531_7
// %bb.6:                               // %B11
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB531_7:                              // %B10
	b	.Lexception_spill_top1_asm_h
.Lfunc_end531:
	.size	.Lpush_this_2_asm_h, .Lfunc_end531-.Lpush_this_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_false_2_asm_h
	.type	.Lpush_false_2_asm_h,@function
.Lpush_false_2_asm_h:                   // @push_false_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #6                         // =0x6
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end532:
	.size	.Lpush_false_2_asm_h, .Lfunc_end532-.Lpush_false_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_true_2_asm_h
	.type	.Lpush_true_2_asm_h,@function
.Lpush_true_2_asm_h:                    // @push_true_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #7                         // =0x7
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end533:
	.size	.Lpush_true_2_asm_h, .Lfunc_end533-.Lpush_true_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function object_2_asm_h
	.type	.Lobject_2_asm_h,@function
.Lobject_2_asm_h:                       // @object_2_asm_h
// %bb.0:                               // %B16
	sub	sp, sp, #16
	str	x22, [x20], #8
	ldrb	w8, [x24, #355]
	str	x19, [sp, #8]                   // 8-byte Folded Spill
	cbnz	w8, .LBB534_5
// %bb.1:                               // %B1
	ldr	x19, [x24, #392]
	cbz	x19, .LBB534_5
// %bb.2:                               // %B5
	mov	x8, x20
	mov	x0, x24
	mov	w1, #64                         // =0x40
	mov	w2, #2                          // =0x2
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_try_malloc_gc
	mov	x10, x0
	cbz	x10, .LBB534_5
// %bb.3:                               // %B7
	ldr	w8, [x19]
	mov	w9, #1                          // =0x1
	add	w8, w8, #1
	str	w8, [x19]
	add	x8, x10, #8
	str	w9, [x10]
	strb	w9, [x10, #5]
	strh	w9, [x10, #6]
	stlr	x19, [x8]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB534_7
.LBB534_4:                              // %B9
	add	x8, x10, #32
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	mov	x22, x21
	str	x8, [x10, #16]
	mov	x21, x10
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
.LBB534_5:                              // %B13
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	.LBB534_8
// %bb.6:                               // %B15
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	mov	x22, x21
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
.LBB534_7:                              // %B11
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x19, x8
	mov	x19, x10
	bl	prim_WriteBarrierNoStore
	mov	x10, x19
	b	.LBB534_4
.LBB534_8:                              // %B14
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	add	sp, sp, #16
	b	.Lexception_spill_top1_asm_h
.Lfunc_end534:
	.size	.Lobject_2_asm_h, .Lfunc_end534-.Lobject_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function special_object_2_asm_h
	.type	.Lspecial_object_2_asm_h,@function
.Lspecial_object_2_asm_h:               // @special_object_2_asm_h
// %bb.0:                               // %B12
	str	x22, [x20], #8
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	.LBB535_5
// %bb.1:                               // %B12
	cbz	w8, .LBB535_8
// %bb.2:                               // %B12
	cmp	w8, #1
	b.ne	.LBB535_10
// %bb.3:                               // %B2
	ldr	x8, [x23, #8]
	ldr	w1, [x23, #112]
	mov	x9, x20
	mov	x0, x24
	mov	x2, x28
	mov	x3, x23
	ldr	x8, [x8, #32]
	ldrh	w8, [x8, #40]
	str	x21, [x9], #8
	str	x9, [x23, #48]
	cmp	w8, w1
	csel	w4, w8, w1, lt
	bl	js_build_mapped_arguments_gc
	cmp	x0, #130
	b.eq	.LBB535_13
.LBB535_4:
	mov	x8, x0
	b	.LBB535_11
.LBB535_5:                              // %B12
	cmp	w8, #3
	b.eq	.LBB535_9
// %bb.6:                               // %B12
	cmp	w8, #4
	b.ne	.LBB535_12
// %bb.7:                               // %B6
	ldr	x8, [x23, #8]
	mov	w9, #18                         // =0x12
	ldr	x8, [x8, #48]
	cmp	x8, #0
	csel	x8, x9, x8, eq
	b	.LBB535_11
.LBB535_8:                              // %B13
	str	x21, [x20], #8
	b	.LFastBuildArguments_asm_h
.LBB535_9:                              // %B16
	ldr	x8, [x23, #88]
	b	.LBB535_11
.LBB535_10:                             // %B15
	ldr	x8, [x23, #8]
.LBB535_11:                             // %B5
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB535_12:                             // %B9
	mov	x8, x20
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_NewObjectProto_GC
	cmp	x0, #130
	b.ne	.LBB535_4
.LBB535_13:                             // %B10
	b	.Lexception_spill_top1_asm_h
.Lfunc_end535:
	.size	.Lspecial_object_2_asm_h, .Lfunc_end535-.Lspecial_object_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rest_2_asm_h
	.type	.Lrest_2_asm_h,@function
.Lrest_2_asm_h:                         // @rest_2_asm_h
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	mov	x3, x28
	ldrh	w1, [x19]
	ldr	w2, [x23, #112]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #48]
	bl	js_build_rest_gc
	cmp	x0, #130
	b.eq	.LBB536_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB536_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end536:
	.size	.Lrest_2_asm_h, .Lfunc_end536-.Lrest_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function drop_2_asm_h
	.type	.Ldrop_2_asm_h,@function
.Ldrop_2_asm_h:                         // @drop_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end537:
	.size	.Ldrop_2_asm_h, .Lfunc_end537-.Ldrop_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nip_2_asm_h
	.type	.Lnip_2_asm_h,@function
.Lnip_2_asm_h:                          // @nip_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, x21
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end538:
	.size	.Lnip_2_asm_h, .Lfunc_end538-.Lnip_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nip1_2_asm_h
	.type	.Lnip1_2_asm_h,@function
.Lnip1_2_asm_h:                         // @nip1_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end539:
	.size	.Lnip1_2_asm_h, .Lfunc_end539-.Lnip1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup_2_asm_h
	.type	.Ldup_2_asm_h,@function
.Ldup_2_asm_h:                          // @dup_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end540:
	.size	.Ldup_2_asm_h, .Lfunc_end540-.Ldup_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup1_2_asm_h
	.type	.Ldup1_2_asm_h,@function
.Ldup1_2_asm_h:                         // @dup1_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x1, x22
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x22, x1
	add	w8, w8, #494
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.Lfunc_end541:
	.size	.Ldup1_2_asm_h, .Lfunc_end541-.Ldup1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup2_2_asm_h
	.type	.Ldup2_2_asm_h,@function
.Ldup2_2_asm_h:                         // @dup2_2_asm_h
// %bb.0:                               // %B0
	stp	x22, x21, [x20], #16
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end542:
	.size	.Ldup2_2_asm_h, .Lfunc_end542-.Ldup2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup3_2_asm_h
	.type	.Ldup3_2_asm_h,@function
.Ldup3_2_asm_h:                         // @dup3_2_asm_h
// %bb.0:                               // %B0
	ldur	x8, [x20, #-8]
	stp	x22, x21, [x20]
	str	x8, [x20, #16]
	add	x20, x20, #24
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end543:
	.size	.Ldup3_2_asm_h, .Lfunc_end543-.Ldup3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function insert2_2_asm_h
	.type	.Linsert2_2_asm_h,@function
.Linsert2_2_asm_h:                      // @insert2_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20]
	mov	x1, x22
	mov	x22, x21
	str	x21, [x20], #8
	mov	x22, x1
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.Lfunc_end544:
	.size	.Linsert2_2_asm_h, .Lfunc_end544-.Linsert2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function insert3_2_asm_h
	.type	.Linsert3_2_asm_h,@function
.Linsert3_2_asm_h:                      // @insert3_2_asm_h
// %bb.0:                               // %B0
	ldur	x8, [x20, #-8]
	stp	x21, x22, [x20, #-8]
	mov	x1, x22
	mov	x22, x21
	str	x8, [x20], #8
	mov	x22, x1
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.Lfunc_end545:
	.size	.Linsert3_2_asm_h, .Lfunc_end545-.Linsert3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function insert4_2_asm_h
	.type	.Linsert4_2_asm_h,@function
.Linsert4_2_asm_h:                      // @insert4_2_asm_h
// %bb.0:                               // %B0
	ldp	x9, x8, [x20, #-16]
	mov	x1, x22
	stur	x21, [x20, #-16]
	stp	x9, x22, [x20, #-8]
	mov	x22, x21
	str	x8, [x20], #8
	mov	x22, x1
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.Lfunc_end546:
	.size	.Linsert4_2_asm_h, .Lfunc_end546-.Linsert4_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function perm3_2_asm_h
	.type	.Lperm3_2_asm_h,@function
.Lperm3_2_asm_h:                        // @perm3_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end547:
	.size	.Lperm3_2_asm_h, .Lfunc_end547-.Lperm3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function perm4_2_asm_h
	.type	.Lperm4_2_asm_h,@function
.Lperm4_2_asm_h:                        // @perm4_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x22
	ldp	x9, x22, [x20, #-16]
	stp	x8, x9, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end548:
	.size	.Lperm4_2_asm_h, .Lfunc_end548-.Lperm4_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function perm5_2_asm_h
	.type	.Lperm5_2_asm_h,@function
.Lperm5_2_asm_h:                        // @perm5_2_asm_h
// %bb.0:                               // %B0
	ldp	x10, x9, [x20, #-24]
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-24]
	stp	x10, x9, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end549:
	.size	.Lperm5_2_asm_h, .Lfunc_end549-.Lperm5_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function swap_2_asm_h
	.type	.Lswap_2_asm_h,@function
.Lswap_2_asm_h:                         // @swap_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x2, x22
	mov	x22, x21
	mov	x21, x2
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end550:
	.size	.Lswap_2_asm_h, .Lfunc_end550-.Lswap_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function swap2_2_asm_h
	.type	.Lswap2_2_asm_h,@function
.Lswap2_2_asm_h:                        // @swap2_2_asm_h
// %bb.0:                               // %B0
	ldp	x8, x9, [x20, #-16]
	stp	x22, x21, [x20, #-16]
	ldrb	w10, [x19], #1
	add	w10, w10, #494
	mov	x22, x8
	mov	x21, x9
	ldr	x1, [x25, w10, uxtw #3]
	br	x1
.Lfunc_end551:
	.size	.Lswap2_2_asm_h, .Lfunc_end551-.Lswap2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rot3l_2_asm_h
	.type	.Lrot3l_2_asm_h,@function
.Lrot3l_2_asm_h:                        // @rot3l_2_asm_h
// %bb.0:                               // %B0
	ldur	x8, [x20, #-8]
	stur	x22, [x20, #-8]
	mov	x22, x21
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end552:
	.size	.Lrot3l_2_asm_h, .Lfunc_end552-.Lrot3l_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rot3r_2_asm_h
	.type	.Lrot3r_2_asm_h,@function
.Lrot3r_2_asm_h:                        // @rot3r_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x21
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end553:
	.size	.Lrot3r_2_asm_h, .Lfunc_end553-.Lrot3r_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rot4l_2_asm_h
	.type	.Lrot4l_2_asm_h,@function
.Lrot4l_2_asm_h:                        // @rot4l_2_asm_h
// %bb.0:                               // %B0
	ldp	x9, x8, [x20, #-16]
	stp	x8, x22, [x20, #-16]
	mov	x22, x21
	mov	x21, x9
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end554:
	.size	.Lrot4l_2_asm_h, .Lfunc_end554-.Lrot4l_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rot5l_2_asm_h
	.type	.Lrot5l_2_asm_h,@function
.Lrot5l_2_asm_h:                        // @rot5l_2_asm_h
// %bb.0:                               // %B0
	ldp	x8, x9, [x20, #-16]
	ldur	x10, [x20, #-24]
	stur	x22, [x20, #-8]
	mov	x22, x21
	mov	x21, x10
	stp	x8, x9, [x20, #-24]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end555:
	.size	.Lrot5l_2_asm_h, .Lfunc_end555-.Lrot5l_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_constructor_2_asm_h
	.type	.Lcall_constructor_2_asm_h,@function
.Lcall_constructor_2_asm_h:             // @call_constructor_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcall_constructor_0_asm_h
.Lfunc_end556:
	.size	.Lcall_constructor_2_asm_h, .Lfunc_end556-.Lcall_constructor_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_2_asm_h
	.type	.Lcall_2_asm_h,@function
.Lcall_2_asm_h:                         // @call_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcall_0_asm_h
.Lfunc_end557:
	.size	.Lcall_2_asm_h, .Lfunc_end557-.Lcall_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function tail_call_2_asm_h
	.type	.Ltail_call_2_asm_h,@function
.Ltail_call_2_asm_h:                    // @tail_call_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ltail_call_0_asm_h
.Lfunc_end558:
	.size	.Ltail_call_2_asm_h, .Lfunc_end558-.Ltail_call_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_method_2_asm_h
	.type	.Lcall_method_2_asm_h,@function
.Lcall_method_2_asm_h:                  // @call_method_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcall_method_0_asm_h
.Lfunc_end559:
	.size	.Lcall_method_2_asm_h, .Lfunc_end559-.Lcall_method_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function tail_call_method_2_asm_h
	.type	.Ltail_call_method_2_asm_h,@function
.Ltail_call_method_2_asm_h:             // @tail_call_method_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ltail_call_method_0_asm_h
.Lfunc_end560:
	.size	.Ltail_call_method_2_asm_h, .Lfunc_end560-.Ltail_call_method_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function array_from_2_asm_h
	.type	.Larray_from_2_asm_h,@function
.Larray_from_2_asm_h:                   // @array_from_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Larray_from_0_asm_h
.Lfunc_end561:
	.size	.Larray_from_2_asm_h, .Lfunc_end561-.Larray_from_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function apply_2_asm_h
	.type	.Lapply_2_asm_h,@function
.Lapply_2_asm_h:                        // @apply_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lapply_0_asm_h
.Lfunc_end562:
	.size	.Lapply_2_asm_h, .Lfunc_end562-.Lapply_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_2_asm_h
	.type	.Lreturn_2_asm_h,@function
.Lreturn_2_asm_h:                       // @return_2_asm_h
// %bb.0:                               // %B0
	mov	x0, x21
	b	.Lcommon_return_asm_h
.Lfunc_end563:
	.size	.Lreturn_2_asm_h, .Lfunc_end563-.Lreturn_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_undef_2_asm_h
	.type	.Lreturn_undef_2_asm_h,@function
.Lreturn_undef_2_asm_h:                 // @return_undef_2_asm_h
// %bb.0:                               // %B0
	mov	w0, #18                         // =0x12
	b	.Lcommon_return_asm_h
.Lfunc_end564:
	.size	.Lreturn_undef_2_asm_h, .Lfunc_end564-.Lreturn_undef_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_ctor_return_2_asm_h
	.type	.Lcheck_ctor_return_2_asm_h,@function
.Lcheck_ctor_return_2_asm_h:            // @check_ctor_return_2_asm_h
// %bb.0:                               // %B5
	mov	x8, #2                          // =0x2
	str	x22, [x20], #8
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB565_3
// %bb.1:                               // %B2
	cmp	x21, #18
	b.eq	.LBB565_4
// %bb.2:                               // %B3
	mov	x8, x20
	adrp	x1, .L__unnamed_17
	add	x1, x1, :lo12:.L__unnamed_17
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	LEPUS_ThrowTypeError
	b	.Lexception_spill_top1_asm_h
.LBB565_3:                              // %B6
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	w21, #6                         // =0x6
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB565_4:                              // %B4
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	w21, #7                         // =0x7
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end565:
	.size	.Lcheck_ctor_return_2_asm_h, .Lfunc_end565-.Lcheck_ctor_return_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_ctor_2_asm_h
	.type	.Lcheck_ctor_2_asm_h,@function
.Lcheck_ctor_2_asm_h:                   // @check_ctor_2_asm_h
// %bb.0:                               // %B2
	ldr	x8, [x23, #88]
	cmp	x8, #18
	b.ne	.LBB566_2
// %bb.1:                               // %B3
	add	x8, x20, #16
	adrp	x1, .L__unnamed_18
	add	x1, x1, :lo12:.L__unnamed_18
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	LEPUS_ThrowTypeError
	b	.Lexception_spill_top0_top1_asm_h
.LBB566_2:                              // %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end566:
	.size	.Lcheck_ctor_2_asm_h, .Lfunc_end566-.Lcheck_ctor_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_brand_2_asm_h
	.type	.Lcheck_brand_2_asm_h,@function
.Lcheck_brand_2_asm_h:                  // @check_brand_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_CheckBrand_GC
	tbnz	w0, #31, .LBB567_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB567_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end567:
	.size	.Lcheck_brand_2_asm_h, .Lfunc_end567-.Lcheck_brand_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_brand_2_asm_h
	.type	.Ladd_brand_2_asm_h,@function
.Ladd_brand_2_asm_h:                    // @add_brand_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_AddBrand_GC
	tbnz	w0, #31, .LBB568_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB568_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end568:
	.size	.Ladd_brand_2_asm_h, .Lfunc_end568-.Ladd_brand_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_async_2_asm_h
	.type	.Lreturn_async_2_asm_h,@function
.Lreturn_async_2_asm_h:                 // @return_async_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lreturn_async_0_asm_h
.Lfunc_end569:
	.size	.Lreturn_async_2_asm_h, .Lfunc_end569-.Lreturn_async_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function throw_2_asm_h
	.type	.Lthrow_2_asm_h,@function
.Lthrow_2_asm_h:                        // @throw_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lthrow_0_asm_h
.Lfunc_end570:
	.size	.Lthrow_2_asm_h, .Lfunc_end570-.Lthrow_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function throw_var_2_asm_h
	.type	.Lthrow_var_2_asm_h,@function
.Lthrow_var_2_asm_h:                    // @throw_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lthrow_var_0_asm_h
.Lfunc_end571:
	.size	.Lthrow_var_2_asm_h, .Lfunc_end571-.Lthrow_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function eval_2_asm_h
	.type	.Leval_2_asm_h,@function
.Leval_2_asm_h:                         // @eval_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Leval_0_asm_h
.Lfunc_end572:
	.size	.Leval_2_asm_h, .Lfunc_end572-.Leval_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function regexp_2_asm_h
	.type	.Lregexp_2_asm_h,@function
.Lregexp_2_asm_h:                       // @regexp_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	w1, #18                         // =0x12
	mov	x2, x22
	mov	x3, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	.LBB573_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB573_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end573:
	.size	.Lregexp_2_asm_h, .Lfunc_end573-.Lregexp_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_super_ctor_2_asm_h
	.type	.Lget_super_ctor_2_asm_h,@function
.Lget_super_ctor_2_asm_h:               // @get_super_ctor_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	.LBB574_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB574_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end574:
	.size	.Lget_super_ctor_2_asm_h, .Lfunc_end574-.Lget_super_ctor_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_super_2_asm_h
	.type	.Lget_super_2_asm_h,@function
.Lget_super_2_asm_h:                    // @get_super_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_GetPrototype_GC
	cmp	x0, #130
	b.eq	.LBB575_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB575_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end575:
	.size	.Lget_super_2_asm_h, .Lfunc_end575-.Lget_super_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function import_2_asm_h
	.type	.Limport_2_asm_h,@function
.Limport_2_asm_h:                       // @import_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	js_dynamic_import
	cmp	x0, #130
	b.eq	.LBB576_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB576_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end576:
	.size	.Limport_2_asm_h, .Lfunc_end576-.Limport_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_var_2_asm_h
	.type	.Lcheck_var_2_asm_h,@function
.Lcheck_var_2_asm_h:                    // @check_var_2_asm_h
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	ldr	w1, [x19]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #48]
	bl	JS_CheckGlobalVar_GC
	tbnz	w0, #31, .LBB577_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	mov	x22, x21
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x21, x8, ne
	br	x1
.LBB577_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end577:
	.size	.Lcheck_var_2_asm_h, .Lfunc_end577-.Lcheck_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_undef_2_asm_h
	.type	.Lget_var_undef_2_asm_h,@function
.Lget_var_undef_2_asm_h:                // @get_var_undef_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	ldr	x8, [x24, #216]
	ldr	w9, [x19]
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x10, x10, #64
	lsl	w12, w11, #2
	and	w11, w9, w11
	ldr	w11, [x10, w11, sxtw #2]
	add	w12, w12, #4
	add	x10, x10, x12
	cbz	w11, .LBB578_3
.LBB578_1:                              // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	.LBB578_9
// %bb.2:                               // %B15
                                        //   in Loop: Header=BB578_1 Depth=1
	and	w11, w12, #0x3ffffff
	cbnz	w11, .LBB578_1
.LBB578_3:                              // %B18
	ldr	x8, [x24, #208]
	mov	w10, #18                        // =0x12
.LBB578_4:                              // %B36
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB578_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w9, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, .LBB578_7
.LBB578_5:                              // %B25
                                        //   Parent Loop BB578_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w9
	b.eq	.LBB578_10
// %bb.6:                               // %B27
                                        //   in Loop: Header=BB578_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB578_5
.LBB578_7:                              // %B30
                                        //   in Loop: Header=BB578_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	.LBB578_15
// %bb.8:                               // %B33
                                        //   in Loop: Header=BB578_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB578_4
	b	.LBB578_13
.LBB578_9:                              // %B10
	lsr	w9, w12, #26
	b	.LBB578_11
.LBB578_10:                             // %B19
	lsr	w9, w13, #26
.LBB578_11:                             // %B19
	tst	w9, #0x30
	b.ne	.LBB578_15
// %bb.12:                              // %B14.sink.split
	ldr	x8, [x8, #16]
	sub	w9, w11, #1
	ldr	x10, [x8, w9, sxtw #3]
.LBB578_13:                             // %B14
	cmp	x10, #34
	b.eq	.LBB578_17
// %bb.14:                              // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x10
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB578_15:                             // %B7
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB578_18
// %bb.16:                              // %B9
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB578_17:                             // %B3
	str	x21, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.LBB578_18:                             // %B8
	b	.Lexception_spill_top1_asm_h
.Lfunc_end578:
	.size	.Lget_var_undef_2_asm_h, .Lfunc_end578-.Lget_var_undef_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_2_asm_h
	.type	.Lget_var_2_asm_h,@function
.Lget_var_2_asm_h:                      // @get_var_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	ldr	x8, [x24, #216]
	ldr	w9, [x19]
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w9, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB579_3
.LBB579_1:                              // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	.LBB579_9
// %bb.2:                               // %B15
                                        //   in Loop: Header=BB579_1 Depth=1
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB579_1
.LBB579_3:                              // %B18
	ldr	x8, [x24, #208]
.LBB579_4:                              // %B35
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB579_5 Depth 2
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w9, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB579_7
.LBB579_5:                              // %B24
                                        //   Parent Loop BB579_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	.LBB579_9
// %bb.6:                               // %B26
                                        //   in Loop: Header=BB579_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB579_5
.LBB579_7:                              // %B29
                                        //   in Loop: Header=BB579_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB579_12
// %bb.8:                               // %B32
                                        //   in Loop: Header=BB579_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB579_4
	b	.LBB579_12
.LBB579_9:                              // %B19
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	.LBB579_12
// %bb.10:                              // %B14
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	.LBB579_14
// %bb.11:                              // %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB579_12:                             // %B7
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB579_15
// %bb.13:                              // %B9
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB579_14:                             // %B3
	str	x21, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.LBB579_15:                             // %B8
	b	.Lexception_spill_top1_asm_h
.Lfunc_end579:
	.size	.Lget_var_2_asm_h, .Lfunc_end579-.Lget_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_2_asm_h
	.type	.Lput_var_2_asm_h,@function
.Lput_var_2_asm_h:                      // @put_var_2_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_SetGlobalVar_GC
	tbnz	w0, #31, .LBB580_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB580_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end580:
	.size	.Lput_var_2_asm_h, .Lfunc_end580-.Lput_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_init_2_asm_h
	.type	.Lput_var_init_2_asm_h,@function
.Lput_var_init_2_asm_h:                 // @put_var_init_2_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_SetGlobalVar_GC
	tbnz	w0, #31, .LBB581_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB581_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end581:
	.size	.Lput_var_init_2_asm_h, .Lfunc_end581-.Lput_var_init_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_strict_2_asm_h
	.type	.Lput_var_strict_2_asm_h,@function
.Lput_var_strict_2_asm_h:               // @put_var_strict_2_asm_h
// %bb.0:                               // %B5
	cmp	x22, #7
	b.ne	.LBB582_3
// %bb.1:                               // %B1
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          // =0x2
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_SetGlobalVar_GC
	tbnz	w0, #31, .LBB582_4
// %bb.2:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB582_3:                              // %B6
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB582_4:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end582:
	.size	.Lput_var_strict_2_asm_h, .Lfunc_end582-.Lput_var_strict_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_ref_value_2_asm_h
	.type	.Lget_ref_value_2_asm_h,@function
.Lget_ref_value_2_asm_h:                // @get_ref_value_2_asm_h
// %bb.0:                               // %B49
	cmp	x22, #18
	str	x22, [x20], #8
	b.eq	.LBB583_7
// %bb.1:                               // %B1
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB583_5
// %bb.2:                               // %B39
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	.LBB583_5
// %bb.3:                               // %B3
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB583_5
// %bb.4:                               // %B3
	mov	x9, #2                          // =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	.LBB583_10
.LBB583_5:                              // %B43
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB583_9
// %bb.6:                               // %B45
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB583_7:                              // %B46
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB583_9
// %bb.8:                               // %B48
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB583_9:                              // %B47
	b	.Lexception_spill_top1_asm_h
.LBB583_10:                             // %B9
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, .LBB583_22
// %bb.11:                              // %B37
	ldr	w8, [x1, #8]
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	.LBB583_5
.LBB583_12:                             // %B11
	ldr	x0, [x24, #8]
	bl	prim_get_interned_non_index_atom
	cbz	w0, .LBB583_5
// %bb.13:                              // %B14.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB583_14:                             // %B14
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB583_15 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB583_17
.LBB583_15:                             // %B25
                                        //   Parent Loop BB583_14 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	.LBB583_19
// %bb.16:                              // %B30
                                        //   in Loop: Header=BB583_15 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB583_15
.LBB583_17:                             // %B16
                                        //   in Loop: Header=BB583_14 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB583_5
// %bb.18:                              // %B19
                                        //   in Loop: Header=BB583_14 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB583_14
	b	.LBB583_21
.LBB583_19:                             // %B27
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB583_5
// %bb.20:                              // %B28
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB583_21:                             // %B22
	ldrb	w9, [x19], #1
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB583_22:                             // %B10
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
	asr	w8, w8, #30
	cmp	w8, #1
	b.eq	.LBB583_12
	b	.LBB583_5
.Lfunc_end583:
	.size	.Lget_ref_value_2_asm_h, .Lfunc_end583-.Lget_ref_value_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_ref_value_2_asm_h
	.type	.Lput_ref_value_2_asm_h,@function
.Lput_ref_value_2_asm_h:                // @put_ref_value_2_asm_h
// %bb.0:                               // %B103
	sub	sp, sp, #32
	ldur	x1, [x20, #-8]
	cmp	x1, #18
	b.eq	.LBB584_7
// %bb.1:                               // %B1
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x1, x8
	b.ne	.LBB584_5
.LBB584_2:                              // %B89
	ldrh	w8, [x1, #6]
	cmp	w8, #1
	b.ne	.LBB584_5
// %bb.3:                               // %B3
	ldr	w8, [x1, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB584_5
// %bb.4:                               // %B3
	mov	x9, #2                          // =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	.LBB584_9
.LBB584_5:                              // %B93
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_SetPropertyValue_GC
	tbnz	w0, #31, .LBB584_45
// %bb.6:                               // %B95
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
.LBB584_7:                              // %B99
	ldr	w8, [x23, #44]
	tbnz	w8, #0, .LBB584_34
// %bb.8:                               // %B100
	ldr	x1, [x24, #208]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x1, x8
	b.eq	.LBB584_2
	b	.LBB584_5
.LBB584_9:                              // %B9
	and	x8, x22, #0xfffffffffffc
	stp	x1, x20, [sp, #16]              // 16-byte Folded Spill
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, .LBB584_36
// %bb.10:                              // %B87
	ldr	w8, [x8, #8]
	asr	w8, w8, #30
	ldp	x1, x20, [sp, #16]              // 16-byte Folded Reload
	cmp	w8, #1
	b.ne	.LBB584_5
.LBB584_11:                             // %B11
	ldr	x0, [x24, #8]
	and	x1, x22, #0xfffffffffffc
	bl	prim_get_interned_non_index_atom
	ldp	x1, x20, [sp, #16]              // 16-byte Folded Reload
	cbz	w0, .LBB584_5
// %bb.12:                              // %B13
	ldr	x8, [x1, #8]
	str	w0, [sp, #12]                   // 4-byte Folded Spill
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w0, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, .LBB584_15
.LBB584_13:                             // %B16
                                        // =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	.LBB584_21
// %bb.14:                              // %B26
                                        //   in Loop: Header=BB584_13 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, .LBB584_13
.LBB584_15:                             // %B28.preheader
	ldp	x8, x20, [sp, #16]              // 16-byte Folded Reload
	ldr	x1, [sp, #16]                   // 8-byte Folded Reload
.LBB584_16:                             // %B28
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB584_17 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w0, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, .LBB584_19
.LBB584_17:                             // %B64
                                        //   Parent Loop BB584_16 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	.LBB584_24
// %bb.18:                              // %B69
                                        //   in Loop: Header=BB584_17 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB584_17
.LBB584_19:                             // %B29
                                        //   in Loop: Header=BB584_16 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	.LBB584_5
// %bb.20:                              // %B58
                                        //   in Loop: Header=BB584_16 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB584_16
	b	.LBB584_25
.LBB584_21:                             // %B18
	mov	w9, #58                         // =0x3a
	ldp	x1, x20, [sp, #16]              // 16-byte Folded Reload
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	.LBB584_5
// %bb.22:                              // %B22
	ldr	x9, [x1, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB584_43
.LBB584_23:                             // %B39
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #32
	br	x1
.LBB584_24:                             // %B66
	mov	w8, #58                         // =0x3a
	ldp	x1, x20, [sp, #16]              // 16-byte Folded Reload
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	.LBB584_5
.LBB584_25:                             // %B32
	ldr	w8, [x1, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	.LBB584_5
// %bb.26:                              // %B51
	ldr	x20, [x1, #8]
	ldr	x8, [x20, #40]
	str	x8, [sp]                        // 8-byte Folded Spill
	cbz	x8, .LBB584_31
// %bb.27:                              // %B34
	ldr	x10, [sp, #16]                  // 8-byte Folded Reload
	ldr	x9, [sp]                        // 8-byte Folded Reload
	ldr	w11, [x20, #16]
	ldr	x8, [x10, #16]
	ldr	w9, [x9, #16]
	add	x10, x10, #32
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	.LBB584_29
// %bb.28:                              // %B34
	cbz	w8, .LBB584_41
.LBB584_29:                             // %B44
	ldr	w8, [x20, #48]
	cmp	w8, w0
	b.ne	.LBB584_31
// %bb.30:                              // %B44
	ldrb	w8, [x20, #52]
	cmp	w8, #7
	b.eq	.LBB584_38
.LBB584_31:                             // %B73
	ldr	x0, [x24, #8]
	ldr	w2, [sp, #12]                   // 4-byte Folded Reload
	mov	x1, x20
	mov	w3, #7                          // =0x7
	bl	find_hashed_shape_prop_gc
	cbz	x0, .LBB584_41
// %bb.32:                              // %B55
	ldr	x10, [sp, #16]                  // 8-byte Folded Reload
	ldr	w9, [x0, #16]
	ldr	w11, [x20, #16]
	ldr	x8, [x10, #16]
	add	x10, x10, #32
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	.LBB584_37
// %bb.33:
	str	x0, [sp]                        // 8-byte Folded Spill
	b	.LBB584_38
.LBB584_34:                             // %B96
	add	x9, x20, #16
	mov	x0, x24
	mov	x1, x22
	stp	x22, x21, [x20]
	str	x9, [sp, #24]                   // 8-byte Folded Spill
	str	x9, [x23, #48]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB584_45
// %bb.35:                              // %B98
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	mov	w1, w0
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_ThrowReferenceErrorNotDefined_GC
	add	sp, sp, #32
	b	.Lexception_spill_top0_top1_asm_h
.LBB584_36:                             // %B10
	ldr	x8, [x8, #8]
	ldr	w8, [x8]
	asr	w8, w8, #30
	ldp	x1, x20, [sp, #16]              // 16-byte Folded Reload
	cmp	w8, #1
	b.eq	.LBB584_11
	b	.LBB584_5
.LBB584_37:                             // %B55
	str	x0, [sp]                        // 8-byte Folded Spill
	cbz	w8, .LBB584_41
.LBB584_38:                             // %B36
	ldr	x10, [sp]                       // 8-byte Folded Reload
	ldr	x9, [sp, #16]                   // 8-byte Folded Reload
	ldr	w8, [x10]
	add	x9, x9, #8
	add	w8, w8, #1
	str	w8, [x10]
	ldr	w8, [x20]
	sub	w8, w8, #1
	str	w8, [x20]
	stlr	x10, [x9]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB584_40
// %bb.39:                              // %B43
	ldr	x9, [sp]                        // 8-byte Folded Reload
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	prim_WriteBarrierNoStore
.LBB584_40:                             // %B40
	ldr	x8, [sp]                        // 8-byte Folded Reload
	ldr	x9, [sp, #16]                   // 8-byte Folded Reload
	ldr	w8, [x8, #20]
	ldr	x9, [x9, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB584_23
	b	.LBB584_43
.LBB584_41:                             // %B76
	ldp	x1, x9, [sp, #16]               // 16-byte Folded Reload
	mov	x0, x24
	ldr	w2, [sp, #12]                   // 4-byte Folded Reload
	mov	w3, #7                          // =0x7
	add	x8, x9, #16
	stp	x22, x21, [x9]
	str	x8, [x23, #48]
	bl	add_property_gc
	cbz	x0, .LBB584_44
// %bb.42:                              // %B80
	str	x21, [x0]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB584_23
.LBB584_43:                             // %B42
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #32
	br	x1
.LBB584_44:                             // %B77
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	sub	x20, x8, #8
.LBB584_45:                             // %B97
	add	sp, sp, #32
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end584:
	.size	.Lput_ref_value_2_asm_h, .Lfunc_end584-.Lput_ref_value_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_var_2_asm_h
	.type	.Ldefine_var_2_asm_h,@function
.Ldefine_var_2_asm_h:                   // @define_var_2_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_DefineGlobalVar_GC
	tbnz	w0, #31, .LBB585_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB585_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end585:
	.size	.Ldefine_var_2_asm_h, .Lfunc_end585-.Ldefine_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_define_var_2_asm_h
	.type	.Lcheck_define_var_2_asm_h,@function
.Lcheck_define_var_2_asm_h:             // @check_define_var_2_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, .LBB586_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB586_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end586:
	.size	.Lcheck_define_var_2_asm_h, .Lfunc_end586-.Lcheck_define_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_func_2_asm_h
	.type	.Ldefine_func_2_asm_h,@function
.Ldefine_func_2_asm_h:                  // @define_func_2_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w3, [x19, #4]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_DefineGlobalFunction_GC
	tbnz	w0, #31, .LBB587_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB587_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end587:
	.size	.Ldefine_func_2_asm_h, .Lfunc_end587-.Ldefine_func_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_field_2_asm_h
	.type	.Lget_field_2_asm_h,@function
.Lget_field_2_asm_h:                    // @get_field_2_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	.LBB588_10
// %bb.1:                               // %B25
	mov	x9, x21
	mov	w8, #18                         // =0x12
.LBB588_2:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB588_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB588_5
.LBB588_3:                              // %B1
                                        //   Parent Loop BB588_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	.LBB588_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB588_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB588_3
.LBB588_5:                              // %B14
                                        //   in Loop: Header=BB588_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB588_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB588_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB588_2
	b	.LBB588_9
.LBB588_7:                              // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB588_10
// %bb.8:                               // %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB588_9:                              // %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB588_10:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x3, x21
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB588_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB588_12:                             // %B22
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end588:
	.size	.Lget_field_2_asm_h, .Lfunc_end588-.Lget_field_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_field2_2_asm_h
	.type	.Lget_field2_2_asm_h,@function
.Lget_field2_2_asm_h:                   // @get_field2_2_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	str	x22, [x20], #8
	movk	x8, #65535, lsl #48
	ldr	w2, [x19]
	tst	x21, x8
	b.ne	.LBB589_10
// %bb.1:                               // %B25
	mov	x9, x21
	mov	w8, #18                         // =0x12
.LBB589_2:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB589_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB589_5
.LBB589_3:                              // %B1
                                        //   Parent Loop BB589_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	.LBB589_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB589_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB589_3
.LBB589_5:                              // %B14
                                        //   in Loop: Header=BB589_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB589_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB589_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB589_2
	b	.LBB589_9
.LBB589_7:                              // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB589_10
// %bb.8:                               // %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB589_9:                              // %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB589_10:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	mov	x3, x21
	mov	w4, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB589_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB589_12:                             // %B22
	b	.Lexception_spill_top1_asm_h
.Lfunc_end589:
	.size	.Lget_field2_2_asm_h, .Lfunc_end589-.Lget_field2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_field_2_asm_h
	.type	.Lput_field_2_asm_h,@function
.Lput_field_2_asm_h:                    // @put_field_2_asm_h
// %bb.0:                               // %B80
	sub	sp, sp, #32
	mov	x8, #2                          // =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB590_25
// %bb.1:                               // %B81
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, .LBB590_4
.LBB590_2:                              // %B1
                                        // =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	.LBB590_10
// %bb.3:                               // %B12
                                        //   in Loop: Header=BB590_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, .LBB590_2
.LBB590_4:                              // %B17.preheader
	mov	x8, x22
.LBB590_5:                              // %B17
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB590_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w2, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, .LBB590_8
.LBB590_6:                              // %B18
                                        //   Parent Loop BB590_5 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	.LBB590_13
// %bb.7:                               // %B59
                                        //   in Loop: Header=BB590_6 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB590_6
.LBB590_8:                              // %B66
                                        //   in Loop: Header=BB590_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	.LBB590_25
// %bb.9:                               // %B63
                                        //   in Loop: Header=BB590_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB590_5
	b	.LBB590_14
.LBB590_10:                             // %B3
	mov	w9, #58                         // =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	.LBB590_25
// %bb.11:                              // %B7
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB590_26
.LBB590_12:                             // %B79
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
.LBB590_13:                             // %B20
	mov	w8, #58                         // =0x3a
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	.LBB590_25
.LBB590_14:                             // %B23
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	.LBB590_25
// %bb.15:                              // %B25
	ldrh	w8, [x22, #6]
	str	x20, [sp, #24]                  // 8-byte Folded Spill
	cmp	w8, #1
	b.ne	.LBB590_32
// %bb.16:                              // %B25
	tbnz	w2, #31, .LBB590_32
// %bb.17:                              // %B54
	ldr	x12, [x22, #8]
	ldr	x20, [x12, #40]
	cbz	x20, .LBB590_27
// %bb.18:                              // %B32
	ldr	x8, [x22, #16]
	ldr	w9, [x20, #16]
	add	x10, x22, #32
	ldr	w11, [x12, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	.LBB590_20
// %bb.19:                              // %B32
	cbz	w8, .LBB590_32
.LBB590_20:                             // %B42
	ldr	w8, [x12, #48]
	cmp	w8, w2
	b.ne	.LBB590_27
// %bb.21:                              // %B42
	ldrb	w8, [x12, #52]
	cmp	w8, #7
	b.ne	.LBB590_27
.LBB590_22:                             // %B34
	ldr	w8, [x20]
	add	x9, x22, #8
	add	w8, w8, #1
	str	w8, [x20]
	ldr	w8, [x12]
	sub	w8, w8, #1
	str	w8, [x12]
	stlr	x20, [x9]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB590_30
.LBB590_23:                             // %B38
	ldr	w8, [x20, #20]
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB590_34
.LBB590_24:                             // %B37
	ldrb	w8, [x19, #4]
	ldr	x20, [sp, #24]                  // 8-byte Folded Reload
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
.LBB590_25:                             // %B77
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_SetPropertyInternalImpl_GC
	tbz	w0, #31, .LBB590_12
	b	.LBB590_36
.LBB590_26:                             // %B9
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
.LBB590_27:                             // %B47
	ldr	x0, [x24, #8]
	mov	x1, x12
	str	w2, [sp, #4]                    // 4-byte Folded Spill
	mov	w3, #7                          // =0x7
	stp	x19, x12, [sp, #8]              // 16-byte Folded Spill
	bl	find_hashed_shape_prop_gc
	ldp	x19, x11, [sp, #8]              // 16-byte Folded Reload
	ldr	w2, [sp, #4]                    // 4-byte Folded Reload
	cbz	x0, .LBB590_32
// %bb.28:                              // %B50
	ldr	x8, [x22, #16]
	ldr	w9, [x0, #16]
	add	x10, x22, #32
	ldr	w11, [x11, #16]
	mov	x20, x0
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	.LBB590_31
// %bb.29:
	ldp	x19, x12, [sp, #8]              // 16-byte Folded Reload
	b	.LBB590_22
.LBB590_30:                             // %B41
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x20, x8
	bl	prim_WriteBarrierNoStore
	b	.LBB590_23
.LBB590_31:                             // %B50
	ldp	x19, x12, [sp, #8]              // 16-byte Folded Reload
	ldr	w2, [sp, #4]                    // 4-byte Folded Reload
	cbnz	w8, .LBB590_22
.LBB590_32:                             // %B70
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	mov	x0, x24
	mov	x1, x22
	mov	w3, #7                          // =0x7
	add	x8, x9, #16
	stp	x22, x21, [x9]
	str	x8, [x23, #48]
	bl	add_property_gc
	cbz	x0, .LBB590_35
// %bb.33:                              // %B74
	str	x21, [x0]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB590_24
.LBB590_34:                             // %B40
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	ldr	x20, [sp, #24]                  // 8-byte Folded Reload
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
.LBB590_35:                             // %B71
	ldr	x20, [sp, #24]                  // 8-byte Folded Reload
.LBB590_36:                             // %B78
	add	sp, sp, #32
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end590:
	.size	.Lput_field_2_asm_h, .Lfunc_end590-.Lput_field_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_private_field_2_asm_h
	.type	.Lget_private_field_2_asm_h,@function
.Lget_private_field_2_asm_h:            // @get_private_field_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	.LBB591_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB591_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end591:
	.size	.Lget_private_field_2_asm_h, .Lfunc_end591-.Lget_private_field_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_private_field_2_asm_h
	.type	.Lput_private_field_2_asm_h,@function
.Lput_private_field_2_asm_h:            // @put_private_field_2_asm_h
// %bb.0:                               // %B1
	ldur	x1, [x20, #-8]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	x3, x22
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_SetPrivateField_GC
	tbnz	w0, #31, .LBB592_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB592_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end592:
	.size	.Lput_private_field_2_asm_h, .Lfunc_end592-.Lput_private_field_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_private_field_2_asm_h
	.type	.Ldefine_private_field_2_asm_h,@function
.Ldefine_private_field_2_asm_h:         // @define_private_field_2_asm_h
// %bb.0:                               // %B1
	ldur	x1, [x20, #-8]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_DefinePrivateField_GC
	tbnz	w0, #31, .LBB593_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB593_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end593:
	.size	.Ldefine_private_field_2_asm_h, .Lfunc_end593-.Ldefine_private_field_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_array_el_2_asm_h
	.type	.Lget_array_el_2_asm_h,@function
.Lget_array_el_2_asm_h:                 // @get_array_el_2_asm_h
// %bb.0:                               // %B112
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB594_12
// %bb.1:                               // %B109
	mov	w9, #65534                      // =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	.LBB594_5
// %bb.2:                               // %B1
	cmp	w8, #2
	b.ne	.LBB594_10
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	.LBB594_14
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	add	w8, w8, #247
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB594_5:                              // %B69
	cmp	w8, #1
	b.ne	.LBB594_12
// %bb.6:                               // %B72
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB594_12
// %bb.7:                               // %B72
	mov	x9, #2                          // =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	.LBB594_12
// %bb.8:                               // %B101
	and	x8, x21, #0xfffffffffffc
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, .LBB594_24
// %bb.9:                               // %B104
	ldr	w8, [x8, #8]
	b	.LBB594_25
.LBB594_10:                             // %B30
	sxth	w9, w8
	cmp	w9, #21
	b.lt	.LBB594_12
// %bb.11:                              // %B30
	cmp	w9, #29
	b.le	.LBB594_33
.LBB594_12:                             // %B106
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB594_38
// %bb.13:                              // %B108
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB594_14:                             // %B7
	tbnz	w21, #31, .LBB594_12
// %bb.15:                              // %B9.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB594_16:                             // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB594_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, .LBB594_19
.LBB594_17:                             // %B10
                                        //   Parent Loop BB594_16 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	.LBB594_21
// %bb.18:                              // %B17
                                        //   in Loop: Header=BB594_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB594_17
.LBB594_19:                             // %B24
                                        //   in Loop: Header=BB594_16 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB594_12
// %bb.20:                              // %B21
                                        //   in Loop: Header=BB594_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB594_16
	b	.LBB594_23
.LBB594_21:                             // %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	.LBB594_12
// %bb.22:                              // %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB594_23:                             // %B87
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB594_24:                             // %B102
	ldr	x8, [x8, #8]
	ldr	w8, [x8]
.LBB594_25:                             // %B98
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	.LBB594_12
// %bb.26:                              // %B77
	ldr	x0, [x24, #8]
	and	x1, x21, #0xfffffffffffc
	bl	prim_get_interned_non_index_atom
	cbz	w0, .LBB594_12
// %bb.27:                              // %B80.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB594_28:                             // %B80
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB594_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB594_31
.LBB594_29:                             // %B83
                                        //   Parent Loop BB594_28 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	.LBB594_39
// %bb.30:                              // %B89
                                        //   in Loop: Header=BB594_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB594_29
.LBB594_31:                             // %B94
                                        //   in Loop: Header=BB594_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB594_12
// %bb.32:                              // %B91
                                        //   in Loop: Header=BB594_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB594_28
	b	.LBB594_23
.LBB594_33:                             // %B32
	ldr	w9, [x22, #48]
	cmp	w21, w9
	b.hs	.LBB594_12
// %bb.34:                              // %B34
	ldr	x9, [x22, #40]
	cmp	w8, #23
	b.ge	.LBB594_41
// %bb.35:                              // %B34
	cmp	w8, #21
	b.eq	.LBB594_42
// %bb.36:                              // %B34
	cmp	w8, #22
	b.ne	.LBB594_12
// %bb.37:                              // %B35
	ldrsb	w8, [x9, w21, sxtw]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB594_38:                             // %B107
	b	.Lexception_spill_top0_top1_asm_h
.LBB594_39:                             // %B85
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB594_12
// %bb.40:                              // %B86
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB594_41:                             // %B34
	b.gt	.LBB594_43
.LBB594_42:                             // %B39
	ldrb	w8, [x9, w21, sxtw]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB594_43:                             // %B34
	cmp	w8, #25
	b.gt	.LBB594_47
// %bb.44:                              // %B34
	cmp	w8, #24
	b.eq	.LBB594_51
// %bb.45:                              // %B34
	cmp	w8, #25
	b.ne	.LBB594_12
// %bb.46:                              // %B45
	ldrh	w8, [x9, w21, sxtw #1]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB594_47:                             // %B34
	cmp	w8, #26
	b.eq	.LBB594_52
// %bb.48:                              // %B34
	cmp	w8, #27
	b.eq	.LBB594_53
// %bb.49:                              // %B34
	cmp	w8, #29
	b.ne	.LBB594_12
// %bb.50:                              // %B62
	ldr	d0, [x9, w21, sxtw #3]
	b	.LBB594_56
.LBB594_51:                             // %B42
	ldrsh	w8, [x9, w21, sxtw #1]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB594_52:                             // %B48
	ldr	w8, [x9, w21, sxtw #2]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB594_53:                             // %B56
	ldr	w8, [x9, w21, sxtw #2]
	tbnz	w8, #31, .LBB594_55
// %bb.54:                              // %B57
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB594_55:                             // %B52
	ucvtf	d0, w8
.LBB594_56:                             // %B36
	fmov	x8, d0
	fcmp	d0, d0
	mov	x9, #562949953421312            // =0x2000000000000
	add	x8, x8, x9
	mov	x9, #9221683186994511872        // =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end594:
	.size	.Lget_array_el_2_asm_h, .Lfunc_end594-.Lget_array_el_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_array_el2_2_asm_h
	.type	.Lget_array_el2_2_asm_h,@function
.Lget_array_el2_2_asm_h:                // @get_array_el2_2_asm_h
// %bb.0:                               // %B112
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB595_12
// %bb.1:                               // %B109
	mov	w9, #65534                      // =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	.LBB595_5
// %bb.2:                               // %B1
	cmp	w8, #2
	b.ne	.LBB595_10
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	.LBB595_14
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	add	w8, w8, #494
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB595_5:                              // %B69
	cmp	w8, #1
	b.ne	.LBB595_12
// %bb.6:                               // %B72
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB595_12
// %bb.7:                               // %B72
	mov	x9, #2                          // =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	.LBB595_12
// %bb.8:                               // %B101
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, .LBB595_24
// %bb.9:                               // %B104
	ldr	w8, [x1, #8]
	b	.LBB595_25
.LBB595_10:                             // %B30
	sxth	w9, w8
	cmp	w9, #21
	b.lt	.LBB595_12
// %bb.11:                              // %B30
	cmp	w9, #29
	b.le	.LBB595_33
.LBB595_12:                             // %B106
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB595_38
// %bb.13:                              // %B108
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB595_14:                             // %B7
	tbnz	w21, #31, .LBB595_12
// %bb.15:                              // %B9.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB595_16:                             // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB595_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, .LBB595_19
.LBB595_17:                             // %B10
                                        //   Parent Loop BB595_16 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	.LBB595_21
// %bb.18:                              // %B17
                                        //   in Loop: Header=BB595_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB595_17
.LBB595_19:                             // %B24
                                        //   in Loop: Header=BB595_16 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB595_12
// %bb.20:                              // %B21
                                        //   in Loop: Header=BB595_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB595_16
	b	.LBB595_23
.LBB595_21:                             // %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	.LBB595_12
// %bb.22:                              // %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB595_23:                             // %B87
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB595_24:                             // %B102
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
.LBB595_25:                             // %B98
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	.LBB595_12
// %bb.26:                              // %B77
	ldr	x0, [x24, #8]
	bl	prim_get_interned_non_index_atom
	cbz	w0, .LBB595_12
// %bb.27:                              // %B80.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB595_28:                             // %B80
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB595_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB595_31
.LBB595_29:                             // %B83
                                        //   Parent Loop BB595_28 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	.LBB595_39
// %bb.30:                              // %B89
                                        //   in Loop: Header=BB595_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB595_29
.LBB595_31:                             // %B94
                                        //   in Loop: Header=BB595_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB595_12
// %bb.32:                              // %B91
                                        //   in Loop: Header=BB595_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB595_28
	b	.LBB595_23
.LBB595_33:                             // %B32
	ldr	w9, [x22, #48]
	cmp	w21, w9
	b.hs	.LBB595_12
// %bb.34:                              // %B34
	ldr	x9, [x22, #40]
	cmp	w8, #23
	b.ge	.LBB595_41
// %bb.35:                              // %B34
	cmp	w8, #21
	b.eq	.LBB595_42
// %bb.36:                              // %B34
	cmp	w8, #22
	b.ne	.LBB595_12
// %bb.37:                              // %B35
	ldrsb	w8, [x9, w21, sxtw]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB595_38:                             // %B107
	b	.Lexception_spill_top0_top1_asm_h
.LBB595_39:                             // %B85
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB595_12
// %bb.40:                              // %B86
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB595_41:                             // %B34
	b.gt	.LBB595_43
.LBB595_42:                             // %B39
	ldrb	w8, [x9, w21, sxtw]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB595_43:                             // %B34
	cmp	w8, #25
	b.gt	.LBB595_47
// %bb.44:                              // %B34
	cmp	w8, #24
	b.eq	.LBB595_51
// %bb.45:                              // %B34
	cmp	w8, #25
	b.ne	.LBB595_12
// %bb.46:                              // %B45
	ldrh	w8, [x9, w21, sxtw #1]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB595_47:                             // %B34
	cmp	w8, #26
	b.eq	.LBB595_52
// %bb.48:                              // %B34
	cmp	w8, #27
	b.eq	.LBB595_53
// %bb.49:                              // %B34
	cmp	w8, #29
	b.ne	.LBB595_12
// %bb.50:                              // %B62
	ldr	d0, [x9, w21, sxtw #3]
	b	.LBB595_56
.LBB595_51:                             // %B42
	ldrsh	w8, [x9, w21, sxtw #1]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB595_52:                             // %B48
	ldr	w8, [x9, w21, sxtw #2]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB595_53:                             // %B56
	ldr	w8, [x9, w21, sxtw #2]
	tbnz	w8, #31, .LBB595_55
// %bb.54:                              // %B57
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB595_55:                             // %B52
	ucvtf	d0, w8
.LBB595_56:                             // %B36
	fmov	x8, d0
	fcmp	d0, d0
	mov	x9, #562949953421312            // =0x2000000000000
	add	x8, x8, x9
	mov	x9, #9221683186994511872        // =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end595:
	.size	.Lget_array_el2_2_asm_h, .Lfunc_end595-.Lget_array_el2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_array_el_2_asm_h
	.type	.Lput_array_el_2_asm_h,@function
.Lput_array_el_2_asm_h:                 // @put_array_el_2_asm_h
// %bb.0:                               // %B190
	sub	sp, sp, #32
	ldur	x10, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x10, x8
	b.ne	.LBB596_7
// %bb.1:                               // %B1
	mov	w8, #65534                      // =0xfffe
	ldrh	w9, [x10, #6]
	cmp	x8, x22, lsr #48
	b.ne	.LBB596_10
// %bb.2:                               // %B3
	cmp	w9, #2
	b.ne	.LBB596_15
// %bb.3:                               // %B5
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB596_7
// %bb.4:                               // %B50
	ldr	w8, [x10, #48]
	cmp	w22, w8
	b.hs	.LBB596_22
// %bb.5:                               // %B7
	ldr	x8, [x10, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB596_33
.LBB596_6:                              // %B189
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
.LBB596_7:
	stp	x20, x10, [sp, #16]             // 16-byte Folded Spill
.LBB596_8:                              // %B187
	mov	w4, #32768                      // =0x8000
.LBB596_9:                              // %B187
	ldp	x9, x1, [sp, #16]               // 16-byte Folded Reload
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	add	x8, x9, #16
	stp	x22, x21, [x9]
	mov	x20, x9
	str	x8, [x23, #48]
	bl	JS_SetPropertyValue_GC
	tbz	w0, #31, .LBB596_6
	b	.LBB596_87
.LBB596_10:                             // %B100
	cmp	w9, #1
	stp	x20, x10, [sp, #16]             // 16-byte Folded Spill
	b.ne	.LBB596_8
// %bb.11:                              // %B181
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	mov	w4, #32768                      // =0x8000
	ldr	w8, [x8, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB596_9
// %bb.12:                              // %B181
	mov	x9, #2                          // =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	.LBB596_9
// %bb.13:                              // %B103
	and	x8, x22, #0xfffffffffffc
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, .LBB596_48
// %bb.14:                              // %B180
	ldr	w8, [x8, #8]
	b	.LBB596_49
.LBB596_15:                             // %B55
	sxth	w8, w9
	mov	w4, #32768                      // =0x8000
	stp	x20, x10, [sp, #16]             // 16-byte Folded Spill
	cmp	w8, #21
	b.lt	.LBB596_9
// %bb.16:                              // %B55
	cmp	w8, #29
	b.gt	.LBB596_9
// %bb.17:                              // %B57
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB596_47
// %bb.18:                              // %B59
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	ldr	w8, [x8, #48]
	cmp	w22, w8
	b.hs	.LBB596_47
// %bb.19:                              // %B61
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	sub	w10, w9, #22
	cmp	w10, #2
	ldr	x8, [x8, #40]
	b.hs	.LBB596_34
// %bb.20:                              // %B71
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	.LBB596_47
// %bb.21:                              // %B72
	strb	w21, [x8, w22, sxtw]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #32
	br	x1
.LBB596_22:                             // %B12
	stp	x20, x10, [sp, #16]             // 16-byte Folded Spill
	b.ne	.LBB596_60
// %bb.23:                              // %B40
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	mov	w4, #32768                      // =0x8000
	ldr	w9, [x9, #4]
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	b.ne	.LBB596_9
// %bb.24:                              // %B40
	ubfx	w9, w9, #8, #1
	cbz	w9, .LBB596_9
// %bb.25:                              // %B14
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbz	x9, .LBB596_27
// %bb.26:                              // %B36
	ldr	w9, [x9, #4]
	ubfx	w9, w9, #13, #1
	cmp	w9, #1
	b.ne	.LBB596_9
.LBB596_27:                             // %B32
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	ldr	x9, [x9, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	.LBB596_29
// %bb.28:                              // %B32
	cmp	w9, w10
	b.hi	.LBB596_62
.LBB596_29:                             // %B29
	ldr	x10, [sp, #24]                  // 8-byte Folded Reload
	ldr	w10, [x10, #32]
	cmp	w9, w10
	b.hi	.LBB596_62
// %bb.30:                              // %B25
	ldr	x11, [sp, #24]                  // 8-byte Folded Reload
	ldr	x10, [x11, #40]
	str	w9, [x11, #48]
	str	x21, [x10, w8, sxtw #3]
.LBB596_31:                             // %B133
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB596_64
.LBB596_32:                             // %B132
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #32
	br	x1
.LBB596_33:                             // %B11
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
.LBB596_34:                             // %B61
	cmp	w9, #25
	mov	w4, wzr
	b.gt	.LBB596_38
// %bb.35:                              // %B61
	sub	w10, w9, #24
	cmp	w10, #2
	b.hs	.LBB596_41
// %bb.36:                              // %B77
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	.LBB596_47
// %bb.37:                              // %B78
	strh	w21, [x8, w22, sxtw #1]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #32
	br	x1
.LBB596_38:                             // %B61
	sub	w10, w9, #26
	cmp	w10, #2
	b.hs	.LBB596_44
// %bb.39:                              // %B83
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	.LBB596_47
// %bb.40:                              // %B84
	str	w21, [x8, w22, sxtw #2]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #32
	br	x1
.LBB596_41:                             // %B61
	cmp	w9, #21
	b.ne	.LBB596_9
// %bb.42:                              // %B63
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	.LBB596_47
// %bb.43:                              // %B64
	cmp	w21, #255
	mov	w9, #255                        // =0xff
	csel	w9, w21, w9, lt
	bic	w9, w9, w9, asr #31
	strb	w9, [x8, w22, sxtw]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #32
	br	x1
.LBB596_44:                             // %B61
	cmp	w9, #29
	b.ne	.LBB596_9
// %bb.45:                              // %B89
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	.LBB596_65
// %bb.46:                              // %B90
	scvtf	d0, w21
	str	d0, [x8, w22, sxtw #3]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #32
	br	x1
.LBB596_47:
	mov	w4, wzr
	b	.LBB596_9
.LBB596_48:                             // %B104
	ldr	x8, [x8, #8]
	ldr	w8, [x8]
.LBB596_49:                             // %B176
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	.LBB596_9
// %bb.50:                              // %B105
	ldr	x0, [x24, #8]
	and	x1, x22, #0xfffffffffffc
	bl	prim_get_interned_non_index_atom
	cbz	w0, .LBB596_8
// %bb.51:                              // %B107
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	str	w0, [sp, #4]                    // 4-byte Folded Spill
	ldr	x8, [x8, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w0, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, .LBB596_54
.LBB596_52:                             // %B110
                                        // =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	.LBB596_68
// %bb.53:                              // %B119
                                        //   in Loop: Header=BB596_52 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, .LBB596_52
.LBB596_54:                             // %B121.preheader
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
.LBB596_55:                             // %B121
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB596_56 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w0, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, .LBB596_58
.LBB596_56:                             // %B157
                                        //   Parent Loop BB596_55 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	.LBB596_69
// %bb.57:                              // %B162
                                        //   in Loop: Header=BB596_56 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB596_56
.LBB596_58:                             // %B122
                                        //   in Loop: Header=BB596_55 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	.LBB596_8
// %bb.59:                              // %B151
                                        //   in Loop: Header=BB596_55 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB596_55
	b	.LBB596_70
.LBB596_60:                             // %B44
	tbnz	w22, #31, .LBB596_8
// %bb.61:                              // %B46
	ldp	x9, x1, [sp, #16]               // 16-byte Folded Reload
	mov	x0, x24
	mov	w2, w22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	add	x8, x9, #16
	stp	x22, x21, [x9]
	str	x8, [x23, #48]
	bl	JS_SetArrayIntPropertyValue_GC
	tbz	w0, #31, .LBB596_32
	b	.LBB596_63
.LBB596_62:                             // %B20
	ldp	x9, x1, [sp, #16]               // 16-byte Folded Reload
	mov	x0, x24
	mov	x2, x21
	mov	w3, #32768                      // =0x8000
	add	x8, x9, #16
	stp	x22, x21, [x9]
	str	x8, [x23, #48]
	bl	add_fast_array_element_gc
	tbz	w0, #31, .LBB596_32
.LBB596_63:                             // %B47
	ldr	x20, [sp, #16]                  // 8-byte Folded Reload
	add	sp, sp, #32
	b	.Lexception_spill_top0_top1_asm_h
.LBB596_64:                             // %B135
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #32
	br	x1
.LBB596_65:                             // %B92
	and	x9, x21, #0xfffe000000000000
	mov	x10, #-562949953421312          // =0xfffe000000000000
	mov	w4, wzr
	cmp	x9, x10
	b.eq	.LBB596_9
// %bb.66:                              // %B92
	cbz	x9, .LBB596_9
// %bb.67:                              // %B93
	mov	x9, #-562949953421312           // =0xfffe000000000000
	add	x9, x21, x9
	str	x9, [x8, w22, sxtw #3]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #32
	br	x1
.LBB596_68:                             // %B112
	mov	w9, #58                         // =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.eq	.LBB596_83
	b	.LBB596_8
.LBB596_69:                             // %B159
	mov	w8, #58                         // =0x3a
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	.LBB596_8
.LBB596_70:                             // %B125
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	ldr	w8, [x8, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	.LBB596_8
// %bb.71:                              // %B144
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	ldr	x8, [x8, #8]
	mov	x20, x8
	ldr	x8, [x8, #40]
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	cbz	x8, .LBB596_76
// %bb.72:                              // %B127
	ldr	x10, [sp, #24]                  // 8-byte Folded Reload
	ldr	x9, [sp, #8]                    // 8-byte Folded Reload
	ldr	w11, [x20, #16]
	ldr	x8, [x10, #16]
	ldr	w9, [x9, #16]
	add	x10, x10, #32
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	.LBB596_74
// %bb.73:                              // %B127
	cbz	w8, .LBB596_84
.LBB596_74:                             // %B137
	ldr	w8, [x20, #48]
	cmp	w8, w0
	b.ne	.LBB596_76
// %bb.75:                              // %B137
	ldrb	w8, [x20, #52]
	cmp	w8, #7
	b.eq	.LBB596_80
.LBB596_76:                             // %B166
	ldr	x0, [x24, #8]
	ldr	w2, [sp, #4]                    // 4-byte Folded Reload
	mov	x1, x20
	mov	w3, #7                          // =0x7
	bl	find_hashed_shape_prop_gc
	cbz	x0, .LBB596_84
// %bb.77:                              // %B148
	ldr	x10, [sp, #24]                  // 8-byte Folded Reload
	ldr	w9, [x0, #16]
	ldr	w11, [x20, #16]
	ldr	x8, [x10, #16]
	add	x10, x10, #32
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	.LBB596_79
// %bb.78:
	str	x0, [sp, #8]                    // 8-byte Folded Spill
	b	.LBB596_80
.LBB596_79:                             // %B148
	str	x0, [sp, #8]                    // 8-byte Folded Spill
	cbz	w8, .LBB596_84
.LBB596_80:                             // %B129
	ldr	x10, [sp, #8]                   // 8-byte Folded Reload
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	ldr	w8, [x10]
	add	x9, x9, #8
	add	w8, w8, #1
	str	w8, [x10]
	ldr	w8, [x20]
	sub	w8, w8, #1
	str	w8, [x20]
	stlr	x10, [x9]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB596_82
// %bb.81:                              // %B136
	ldr	x9, [sp, #8]                    // 8-byte Folded Reload
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	prim_WriteBarrierNoStore
.LBB596_82:                             // %B133
	ldr	x8, [sp, #8]                    // 8-byte Folded Reload
	ldr	w8, [x8, #20]
.LBB596_83:                             // %B133
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	sub	w8, w8, #1
	ldr	x9, [x9, #16]
	str	x21, [x9, w8, sxtw #3]
	b	.LBB596_31
.LBB596_84:                             // %B169
	ldp	x9, x1, [sp, #16]               // 16-byte Folded Reload
	mov	x0, x24
	ldr	w2, [sp, #4]                    // 4-byte Folded Reload
	mov	w3, #7                          // =0x7
	add	x8, x9, #16
	stp	x22, x21, [x9]
	str	x8, [x23, #48]
	bl	add_property_gc
	cbz	x0, .LBB596_86
// %bb.85:                              // %B173
	str	x21, [x0]
	b	.LBB596_31
.LBB596_86:                             // %B170
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	sub	x20, x8, #8
.LBB596_87:                             // %B188
	add	sp, sp, #32
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end596:
	.size	.Lput_array_el_2_asm_h, .Lfunc_end596-.Lput_array_el_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_super_value_2_asm_h
	.type	.Lget_super_value_2_asm_h,@function
.Lget_super_value_2_asm_h:              // @get_super_value_2_asm_h
// %bb.0:                               // %B1
	sub	sp, sp, #16
	str	x19, [sp, #8]                   // 8-byte Folded Spill
	add	x19, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x19, [x23, #48]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB597_3
// %bb.1:                               // %B5
	ldur	x3, [x20, #-8]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x19, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB597_3
// %bb.2:                               // %B7
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB597_3:                              // %B2
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	add	sp, sp, #16
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end597:
	.size	.Lget_super_value_2_asm_h, .Lfunc_end597-.Lget_super_value_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_super_value_2_asm_h
	.type	.Lput_super_value_2_asm_h,@function
.Lput_super_value_2_asm_h:              // @put_super_value_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lput_super_value_0_asm_h
.Lfunc_end598:
	.size	.Lput_super_value_2_asm_h, .Lfunc_end598-.Lput_super_value_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_field_2_asm_h
	.type	.Ldefine_field_2_asm_h,@function
.Ldefine_field_2_asm_h:                 // @define_field_2_asm_h
// %bb.0:                               // %B58
	sub	sp, sp, #32
	mov	x8, #2                          // =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB599_4
// %bb.1:                               // %B55
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	.LBB599_4
// %bb.2:                               // %B49
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	.LBB599_4
// %bb.3:                               // %B52
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.eq	.LBB599_6
.LBB599_4:                              // %B46
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #16391                      // =0x4007
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_DefinePropertyValue_GC
	tbnz	w0, #31, .LBB599_17
.LBB599_5:                              // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #32
	br	x1
.LBB599_6:                              // %B53
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, .LBB599_9
.LBB599_7:                              // %B35
                                        // =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	.LBB599_18
// %bb.8:                               // %B37
                                        //   in Loop: Header=BB599_7 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, .LBB599_7
.LBB599_9:                              // %B40
	tbnz	w2, #31, .LBB599_4
// %bb.10:                              // %B11
	ldr	x8, [x22, #8]
	str	x8, [sp, #24]                   // 8-byte Folded Spill
	ldr	x8, [x8, #40]
	str	x8, [sp, #16]                   // 8-byte Folded Spill
	cbz	x8, .LBB599_21
// %bb.11:                              // %B15
	ldp	x9, x11, [sp, #16]              // 16-byte Folded Reload
	add	x10, x22, #32
	ldr	x8, [x22, #16]
	ldr	w9, [x9, #16]
	ldr	w11, [x11, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	.LBB599_13
// %bb.12:                              // %B15
	cbz	w8, .LBB599_4
.LBB599_13:                             // %B17
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	ldr	w8, [x8, #48]
	cmp	w8, w2
	b.ne	.LBB599_21
// %bb.14:                              // %B17
	ldr	x8, [sp, #24]                   // 8-byte Folded Reload
	ldrb	w8, [x8, #52]
	cmp	w8, #7
	b.ne	.LBB599_21
.LBB599_15:                             // %B25
	ldp	x11, x10, [sp, #16]             // 16-byte Folded Reload
	add	x9, x22, #8
	ldr	w8, [x11]
	add	w8, w8, #1
	str	w8, [x11]
	ldr	w8, [x10]
	sub	w8, w8, #1
	str	w8, [x10]
	stlr	x11, [x9]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB599_24
.LBB599_16:                             // %B22
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	ldr	w8, [x8, #20]
	b	.LBB599_19
.LBB599_17:                             // %B47
	add	sp, sp, #32
	b	.Lexception_spill_top0_top1_asm_h
.LBB599_18:                             // %B1
	lsr	w9, w10, #26
	and	w9, w9, #0xfffffff7
	cmp	w9, #7
	b.ne	.LBB599_4
.LBB599_19:                             // %B22
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB599_5
// %bb.20:
	mov	x1, x24
	mov	x0, x21
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #32
	br	x1
.LBB599_21:                             // %B43
	ldr	x0, [x24, #8]
	ldr	x1, [sp, #24]                   // 8-byte Folded Reload
	mov	w3, #7                          // =0x7
	str	w2, [sp, #12]                   // 4-byte Folded Spill
	bl	find_hashed_shape_prop_gc
	ldr	w2, [sp, #12]                   // 4-byte Folded Reload
	cbz	x0, .LBB599_4
// %bb.22:                              // %B30
	ldr	x8, [x22, #16]
	ldr	x11, [sp, #24]                  // 8-byte Folded Reload
	add	x10, x22, #32
	ldr	w9, [x0, #16]
	ldr	w11, [x11, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	.LBB599_25
// %bb.23:
	str	x0, [sp, #16]                   // 8-byte Folded Spill
	b	.LBB599_15
.LBB599_24:                             // %B27
	ldr	x9, [sp, #16]                   // 8-byte Folded Reload
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	prim_WriteBarrierNoStore
	b	.LBB599_16
.LBB599_25:                             // %B30
	ldr	w2, [sp, #12]                   // 4-byte Folded Reload
	str	x0, [sp, #16]                   // 8-byte Folded Spill
	cbnz	w8, .LBB599_15
	b	.LBB599_4
.Lfunc_end599:
	.size	.Ldefine_field_2_asm_h, .Lfunc_end599-.Ldefine_field_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_name_2_asm_h
	.type	.Lset_name_2_asm_h,@function
.Lset_name_2_asm_h:                     // @set_name_2_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_DefineObjectName
	tbnz	w0, #31, .LBB600_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB600_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end600:
	.size	.Lset_name_2_asm_h, .Lfunc_end600-.Lset_name_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_name_computed_2_asm_h
	.type	.Lset_name_computed_2_asm_h,@function
.Lset_name_computed_2_asm_h:            // @set_name_computed_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x2, x22
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, .LBB601_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB601_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end601:
	.size	.Lset_name_computed_2_asm_h, .Lfunc_end601-.Lset_name_computed_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_proto_2_asm_h
	.type	.Lset_proto_2_asm_h,@function
.Lset_proto_2_asm_h:                    // @set_proto_2_asm_h
// %bb.0:                               // %B6
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB602_3
// %bb.1:                               // %B6
	cmp	x21, #2
	b.eq	.LBB602_3
.LBB602_2:                              // %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB602_3:                              // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_SetPrototypeInternal_GC
	tbz	w0, #31, .LBB602_2
// %bb.4:                               // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end602:
	.size	.Lset_proto_2_asm_h, .Lfunc_end602-.Lset_proto_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_home_object_2_asm_h
	.type	.Lset_home_object_2_asm_h,@function
.Lset_home_object_2_asm_h:              // @set_home_object_2_asm_h
// %bb.0:                               // %B0
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x2, x22
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	js_method_set_home_object_gc
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end603:
	.size	.Lset_home_object_2_asm_h, .Lfunc_end603-.Lset_home_object_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_array_el_2_asm_h
	.type	.Ldefine_array_el_2_asm_h,@function
.Ldefine_array_el_2_asm_h:              // @define_array_el_2_asm_h
// %bb.0:                               // %B1
	ldur	x1, [x20, #-8]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #16391                      // =0x4007
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, .LBB604_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB604_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end604:
	.size	.Ldefine_array_el_2_asm_h, .Lfunc_end604-.Ldefine_array_el_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function append_2_asm_h
	.type	.Lappend_2_asm_h,@function
.Lappend_2_asm_h:                       // @append_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lappend_0_asm_h
.Lfunc_end605:
	.size	.Lappend_2_asm_h, .Lfunc_end605-.Lappend_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function copy_data_properties_2_asm_h
	.type	.Lcopy_data_properties_2_asm_h,@function
.Lcopy_data_properties_2_asm_h:         // @copy_data_properties_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcopy_data_properties_0_asm_h
.Lfunc_end606:
	.size	.Lcopy_data_properties_2_asm_h, .Lfunc_end606-.Lcopy_data_properties_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_method_2_asm_h
	.type	.Ldefine_method_2_asm_h,@function
.Ldefine_method_2_asm_h:                // @define_method_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ldefine_method_0_asm_h
.Lfunc_end607:
	.size	.Ldefine_method_2_asm_h, .Lfunc_end607-.Ldefine_method_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_method_computed_2_asm_h
	.type	.Ldefine_method_computed_2_asm_h,@function
.Ldefine_method_computed_2_asm_h:       // @define_method_computed_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ldefine_method_computed_0_asm_h
.Lfunc_end608:
	.size	.Ldefine_method_computed_2_asm_h, .Lfunc_end608-.Ldefine_method_computed_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_class_2_asm_h
	.type	.Ldefine_class_2_asm_h,@function
.Ldefine_class_2_asm_h:                 // @define_class_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ldefine_class_0_asm_h
.Lfunc_end609:
	.size	.Ldefine_class_2_asm_h, .Lfunc_end609-.Ldefine_class_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc_2_asm_h
	.type	.Lget_loc_2_asm_h,@function
.Lget_loc_2_asm_h:                      // @get_loc_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #494
	ldr	x9, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x9
	br	x1
.Lfunc_end610:
	.size	.Lget_loc_2_asm_h, .Lfunc_end610-.Lget_loc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc_2_asm_h
	.type	.Lput_loc_2_asm_h,@function
.Lput_loc_2_asm_h:                      // @put_loc_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end611:
	.size	.Lput_loc_2_asm_h, .Lfunc_end611-.Lput_loc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc_2_asm_h
	.type	.Lset_loc_2_asm_h,@function
.Lset_loc_2_asm_h:                      // @set_loc_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end612:
	.size	.Lset_loc_2_asm_h, .Lfunc_end612-.Lset_loc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg_2_asm_h
	.type	.Lget_arg_2_asm_h,@function
.Lget_arg_2_asm_h:                      // @get_arg_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #494
	ldr	x9, [x28, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x9
	br	x1
.Lfunc_end613:
	.size	.Lget_arg_2_asm_h, .Lfunc_end613-.Lget_arg_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg_2_asm_h
	.type	.Lput_arg_2_asm_h,@function
.Lput_arg_2_asm_h:                      // @put_arg_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x21, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end614:
	.size	.Lput_arg_2_asm_h, .Lfunc_end614-.Lput_arg_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg_2_asm_h
	.type	.Lset_arg_2_asm_h,@function
.Lset_arg_2_asm_h:                      // @set_arg_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x21, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end615:
	.size	.Lset_arg_2_asm_h, .Lfunc_end615-.Lset_arg_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref_2_asm_h
	.type	.Lget_var_ref_2_asm_h,@function
.Lget_var_ref_2_asm_h:                  // @get_var_ref_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrh	w8, [x19]
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x8, [x26, x8, lsl #3]
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x8, [x8]
	mov	x21, x8
	br	x1
.Lfunc_end616:
	.size	.Lget_var_ref_2_asm_h, .Lfunc_end616-.Lget_var_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_2_asm_h
	.type	.Lput_var_ref_2_asm_h,@function
.Lput_var_ref_2_asm_h:                  // @put_var_ref_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end617:
	.size	.Lput_var_ref_2_asm_h, .Lfunc_end617-.Lput_var_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref_2_asm_h
	.type	.Lset_var_ref_2_asm_h,@function
.Lset_var_ref_2_asm_h:                  // @set_var_ref_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end618:
	.size	.Lset_var_ref_2_asm_h, .Lfunc_end618-.Lset_var_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc_uninitialized_2_asm_h
	.type	.Lset_loc_uninitialized_2_asm_h,@function
.Lset_loc_uninitialized_2_asm_h:        // @set_loc_uninitialized_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	mov	w9, #34                         // =0x22
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end619:
	.size	.Lset_loc_uninitialized_2_asm_h, .Lfunc_end619-.Lset_loc_uninitialized_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc_check_2_asm_h
	.type	.Lget_loc_check_2_asm_h,@function
.Lget_loc_check_2_asm_h:                // @get_loc_check_2_asm_h
// %bb.0:                               // %B2
	str	x22, [x20], #8
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	.LBB620_2
// %bb.1:                               // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB620_2:                              // %B3
	str	x21, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end620:
	.size	.Lget_loc_check_2_asm_h, .Lfunc_end620-.Lget_loc_check_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc_check_2_asm_h
	.type	.Lput_loc_check_2_asm_h,@function
.Lput_loc_check_2_asm_h:                // @put_loc_check_2_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	.LBB621_2
// %bb.1:                               // %B4
	str	x21, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB621_2:                              // %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end621:
	.size	.Lput_loc_check_2_asm_h, .Lfunc_end621-.Lput_loc_check_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc_check_init_2_asm_h
	.type	.Lput_loc_check_init_2_asm_h,@function
.Lput_loc_check_init_2_asm_h:           // @put_loc_check_init_2_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	.LBB622_2
// %bb.1:                               // %B4
	str	x21, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB622_2:                              // %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.LThrowThisReferenceError_asm_h
.Lfunc_end622:
	.size	.Lput_loc_check_init_2_asm_h, .Lfunc_end622-.Lput_loc_check_init_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref_check_2_asm_h
	.type	.Lget_var_ref_check_2_asm_h,@function
.Lget_var_ref_check_2_asm_h:            // @get_var_ref_check_2_asm_h
// %bb.0:                               // %B2
	str	x22, [x20], #8
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB623_2
// %bb.1:                               // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB623_2:                              // %B3
	str	x21, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end623:
	.size	.Lget_var_ref_check_2_asm_h, .Lfunc_end623-.Lget_var_ref_check_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_check_2_asm_h
	.type	.Lput_var_ref_check_2_asm_h,@function
.Lput_var_ref_check_2_asm_h:            // @put_var_ref_check_2_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	.LBB624_2
// %bb.1:                               // %B4
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB624_2:                              // %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end624:
	.size	.Lput_var_ref_check_2_asm_h, .Lfunc_end624-.Lput_var_ref_check_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_check_init_2_asm_h
	.type	.Lput_var_ref_check_init_2_asm_h,@function
.Lput_var_ref_check_init_2_asm_h:       // @put_var_ref_check_init_2_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	.LBB625_2
// %bb.1:                               // %B4
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB625_2:                              // %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end625:
	.size	.Lput_var_ref_check_init_2_asm_h, .Lfunc_end625-.Lput_var_ref_check_init_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function close_loc_2_asm_h
	.type	.Lclose_loc_2_asm_h,@function
.Lclose_loc_2_asm_h:                    // @close_loc_2_asm_h
// %bb.0:                               // %B0
	ldrh	w2, [x19]
	mov	x0, x24
	mov	x1, x23
	bl	close_lexical_var
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end626:
	.size	.Lclose_loc_2_asm_h, .Lfunc_end626-.Lclose_loc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_false_2_asm_h
	.type	.Lif_false_2_asm_h,@function
.Lif_false_2_asm_h:                     // @if_false_2_asm_h
// %bb.0:                               // %B23
	cmp	x21, #5
	b.le	.LBB627_4
// %bb.1:                               // %B23
	cmp	x21, #6
	b.eq	.LBB627_6
// %bb.2:                               // %B23
	cmp	x21, #7
	b.eq	.LBB627_9
// %bb.3:                               // %B23
	cmp	x21, #18
	b.eq	.LBB627_6
	b	.LBB627_7
.LBB627_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB627_6
// %bb.5:                               // %B23
	cmp	x21, #2
	b.ne	.LBB627_7
.LBB627_6:                              // %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB627_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x21, x8
	b.hs	.LBB627_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB627_10
.LBB627_9:                              // %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB627_10:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB627_13
// %bb.11:                              // %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB627_6
	b.vs	.LBB627_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB627_9
	b	.LBB627_6
.LBB627_13:                             // %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	.LSlowToBoolean_asm_h
.Lfunc_end627:
	.size	.Lif_false_2_asm_h, .Lfunc_end627-.Lif_false_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_true_2_asm_h
	.type	.Lif_true_2_asm_h,@function
.Lif_true_2_asm_h:                      // @if_true_2_asm_h
// %bb.0:                               // %B23
	cmp	x21, #5
	b.le	.LBB628_4
// %bb.1:                               // %B23
	cmp	x21, #6
	b.eq	.LBB628_6
// %bb.2:                               // %B23
	cmp	x21, #7
	b.eq	.LBB628_9
// %bb.3:                               // %B23
	cmp	x21, #18
	b.eq	.LBB628_6
	b	.LBB628_7
.LBB628_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB628_6
// %bb.5:                               // %B23
	cmp	x21, #2
	b.ne	.LBB628_7
.LBB628_6:                              // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB628_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x21, x8
	b.hs	.LBB628_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB628_10
.LBB628_9:                              // %B19
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB628_10:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB628_13
// %bb.11:                              // %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB628_6
	b.vs	.LBB628_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB628_9
	b	.LBB628_6
.LBB628_13:                             // %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	.LSlowToBoolean_asm_h
.Lfunc_end628:
	.size	.Lif_true_2_asm_h, .Lfunc_end628-.Lif_true_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function goto_2_asm_h
	.type	.Lgoto_2_asm_h,@function
.Lgoto_2_asm_h:                         // @goto_2_asm_h
// %bb.0:                               // %B0
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end629:
	.size	.Lgoto_2_asm_h, .Lfunc_end629-.Lgoto_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function catch_2_asm_h
	.type	.Lcatch_2_asm_h,@function
.Lcatch_2_asm_h:                        // @catch_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	w8, #66                         // =0x42
	ldr	x9, [x23, #8]
	ldrb	w10, [x19, #4]
	ldr	w11, [x19]
	mov	x22, x21
	ldr	x9, [x9, #32]
	add	w10, w10, #494
	ldr	x1, [x25, w10, uxtw #3]
	ldr	x9, [x9, #8]
	sub	x9, x19, x9
	add	x19, x19, #5
	add	x9, x9, x11
	orr	x21, x8, x9, lsl #16
	br	x1
.Lfunc_end630:
	.size	.Lcatch_2_asm_h, .Lfunc_end630-.Lcatch_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gosub_2_asm_h
	.type	.Lgosub_2_asm_h,@function
.Lgosub_2_asm_h:                        // @gosub_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrsw	x8, [x19]
	ldr	x9, [x23, #8]
	ldr	x9, [x9, #32]
	add	x8, x19, x8
	ldrb	w10, [x8], #1
	ldr	w9, [x9, #8]
	add	w10, w10, #494
	sub	w9, w19, w9
	ldr	x1, [x25, w10, uxtw #3]
	mov	x19, x8
	add	w9, w9, #4
	orr	x21, x9, #0xfffe000000000000
	br	x1
.Lfunc_end631:
	.size	.Lgosub_2_asm_h, .Lfunc_end631-.Lgosub_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function ret_2_asm_h
	.type	.Lret_2_asm_h,@function
.Lret_2_asm_h:                          // @ret_2_asm_h
// %bb.0:                               // %B6
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB632_3
// %bb.1:                               // %B1
	ldr	x8, [x23, #8]
	ldr	x8, [x8, #32]
	ldr	w9, [x8, #16]
	cmp	w21, w9
	b.ge	.LBB632_3
// %bb.2:                               // %B5
	ldr	x8, [x8, #8]
	add	x19, x8, w21, sxtw
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB632_3:                              // %B3
	add	x8, x20, #16
	adrp	x1, .L__unnamed_19
	add	x1, x1, :lo12:.L__unnamed_19
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	LEPUS_ThrowInternalError
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end632:
	.size	.Lret_2_asm_h, .Lfunc_end632-.Lret_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_object_2_asm_h
	.type	.Lto_object_2_asm_h,@function
.Lto_object_2_asm_h:                    // @to_object_2_asm_h
// %bb.0:                               // %B6
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	.LBB633_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB633_2:                              // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB633_4
// %bb.3:                               // %B3
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB633_4:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end633:
	.size	.Lto_object_2_asm_h, .Lfunc_end633-.Lto_object_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_propkey_2_asm_h
	.type	.Lto_propkey_2_asm_h,@function
.Lto_propkey_2_asm_h:                   // @to_propkey_2_asm_h
// %bb.0:                               // %B15
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB634_4
// %bb.1:                               // %B15
	mov	x9, #1                          // =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	.LBB634_4
// %bb.2:                               // %B15
	cmp	x8, x9
	b.eq	.LBB634_4
// %bb.3:                               // %B15
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB634_5
.LBB634_4:                              // %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB634_5:                              // %B12
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	.LBB634_7
// %bb.6:                               // %B14
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB634_7:                              // %B13
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end634:
	.size	.Lto_propkey_2_asm_h, .Lfunc_end634-.Lto_propkey_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_propkey2_2_asm_h
	.type	.Lto_propkey2_2_asm_h,@function
.Lto_propkey2_2_asm_h:                  // @to_propkey2_2_asm_h
// %bb.0:                               // %B18
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	.LBB635_3
// %bb.1:                               // %B19
	add	x8, x20, #16
	adrp	x1, .L__unnamed_20
	add	x1, x1, :lo12:.L__unnamed_20
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	LEPUS_ThrowTypeError
.LBB635_2:                              // %B16
	b	.Lexception_spill_top0_top1_asm_h
.LBB635_3:                              // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB635_7
// %bb.4:                               // %B2
	mov	x9, #1                          // =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	.LBB635_7
// %bb.5:                               // %B2
	cmp	x8, x9
	b.eq	.LBB635_7
// %bb.6:                               // %B2
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB635_8
.LBB635_7:                              // %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB635_8:                              // %B15
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	.LBB635_2
// %bb.9:                               // %B17
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end635:
	.size	.Lto_propkey2_2_asm_h, .Lfunc_end635-.Lto_propkey2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_get_var_2_asm_h
	.type	.Lwith_get_var_2_asm_h,@function
.Lwith_get_var_2_asm_h:                 // @with_get_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lwith_get_var_0_asm_h
.Lfunc_end636:
	.size	.Lwith_get_var_2_asm_h, .Lfunc_end636-.Lwith_get_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_put_var_2_asm_h
	.type	.Lwith_put_var_2_asm_h,@function
.Lwith_put_var_2_asm_h:                 // @with_put_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lwith_put_var_0_asm_h
.Lfunc_end637:
	.size	.Lwith_put_var_2_asm_h, .Lfunc_end637-.Lwith_put_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_delete_var_2_asm_h
	.type	.Lwith_delete_var_2_asm_h,@function
.Lwith_delete_var_2_asm_h:              // @with_delete_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lwith_delete_var_0_asm_h
.Lfunc_end638:
	.size	.Lwith_delete_var_2_asm_h, .Lfunc_end638-.Lwith_delete_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_make_ref_2_asm_h
	.type	.Lwith_make_ref_2_asm_h,@function
.Lwith_make_ref_2_asm_h:                // @with_make_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lwith_make_ref_0_asm_h
.Lfunc_end639:
	.size	.Lwith_make_ref_2_asm_h, .Lfunc_end639-.Lwith_make_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_get_ref_2_asm_h
	.type	.Lwith_get_ref_2_asm_h,@function
.Lwith_get_ref_2_asm_h:                 // @with_get_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lwith_get_ref_0_asm_h
.Lfunc_end640:
	.size	.Lwith_get_ref_2_asm_h, .Lfunc_end640-.Lwith_get_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_get_ref_undef_2_asm_h
	.type	.Lwith_get_ref_undef_2_asm_h,@function
.Lwith_get_ref_undef_2_asm_h:           // @with_get_ref_undef_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lwith_get_ref_undef_0_asm_h
.Lfunc_end641:
	.size	.Lwith_get_ref_undef_2_asm_h, .Lfunc_end641-.Lwith_get_ref_undef_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_loc_ref_2_asm_h
	.type	.Lmake_loc_ref_2_asm_h,@function
.Lmake_loc_ref_2_asm_h:                 // @make_loc_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lmake_loc_ref_0_asm_h
.Lfunc_end642:
	.size	.Lmake_loc_ref_2_asm_h, .Lfunc_end642-.Lmake_loc_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_arg_ref_2_asm_h
	.type	.Lmake_arg_ref_2_asm_h,@function
.Lmake_arg_ref_2_asm_h:                 // @make_arg_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lmake_arg_ref_0_asm_h
.Lfunc_end643:
	.size	.Lmake_arg_ref_2_asm_h, .Lfunc_end643-.Lmake_arg_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_var_ref_ref_2_asm_h
	.type	.Lmake_var_ref_ref_2_asm_h,@function
.Lmake_var_ref_ref_2_asm_h:             // @make_var_ref_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lmake_var_ref_ref_0_asm_h
.Lfunc_end644:
	.size	.Lmake_var_ref_ref_2_asm_h, .Lfunc_end644-.Lmake_var_ref_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_var_ref_2_asm_h
	.type	.Lmake_var_ref_2_asm_h,@function
.Lmake_var_ref_2_asm_h:                 // @make_var_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lmake_var_ref_0_asm_h
.Lfunc_end645:
	.size	.Lmake_var_ref_2_asm_h, .Lfunc_end645-.Lmake_var_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_in_start_2_asm_h
	.type	.Lfor_in_start_2_asm_h,@function
.Lfor_in_start_2_asm_h:                 // @for_in_start_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	.LBB646_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB646_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end646:
	.size	.Lfor_in_start_2_asm_h, .Lfunc_end646-.Lfor_in_start_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_of_start_2_asm_h
	.type	.Lfor_of_start_2_asm_h,@function
.Lfor_of_start_2_asm_h:                 // @for_of_start_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lfor_of_start_0_asm_h
.Lfunc_end647:
	.size	.Lfor_of_start_2_asm_h, .Lfunc_end647-.Lfor_of_start_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_await_of_start_2_asm_h
	.type	.Lfor_await_of_start_2_asm_h,@function
.Lfor_await_of_start_2_asm_h:           // @for_await_of_start_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lfor_await_of_start_0_asm_h
.Lfunc_end648:
	.size	.Lfor_await_of_start_2_asm_h, .Lfunc_end648-.Lfor_await_of_start_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_in_next_2_asm_h
	.type	.Lfor_in_next_2_asm_h,@function
.Lfor_in_next_2_asm_h:                  // @for_in_next_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lfor_in_next_0_asm_h
.Lfunc_end649:
	.size	.Lfor_in_next_2_asm_h, .Lfunc_end649-.Lfor_in_next_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_of_next_2_asm_h
	.type	.Lfor_of_next_2_asm_h,@function
.Lfor_of_next_2_asm_h:                  // @for_of_next_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lfor_of_next_0_asm_h
.Lfunc_end650:
	.size	.Lfor_of_next_2_asm_h, .Lfunc_end650-.Lfor_of_next_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_await_of_next_2_asm_h
	.type	.Lfor_await_of_next_2_asm_h,@function
.Lfor_await_of_next_2_asm_h:            // @for_await_of_next_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lfor_await_of_next_0_asm_h
.Lfunc_end651:
	.size	.Lfor_await_of_next_2_asm_h, .Lfunc_end651-.Lfor_await_of_next_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_get_value_done_2_asm_h
	.type	.Literator_get_value_done_2_asm_h,@function
.Literator_get_value_done_2_asm_h:      // @iterator_get_value_done_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Literator_get_value_done_0_asm_h
.Lfunc_end652:
	.size	.Literator_get_value_done_2_asm_h, .Lfunc_end652-.Literator_get_value_done_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_close_2_asm_h
	.type	.Literator_close_2_asm_h,@function
.Literator_close_2_asm_h:               // @iterator_close_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Literator_close_0_asm_h
.Lfunc_end653:
	.size	.Literator_close_2_asm_h, .Lfunc_end653-.Literator_close_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_close_return_2_asm_h
	.type	.Literator_close_return_2_asm_h,@function
.Literator_close_return_2_asm_h:        // @iterator_close_return_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Literator_close_return_0_asm_h
.Lfunc_end654:
	.size	.Literator_close_return_2_asm_h, .Lfunc_end654-.Literator_close_return_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_iterator_close_2_asm_h
	.type	.Lasync_iterator_close_2_asm_h,@function
.Lasync_iterator_close_2_asm_h:         // @async_iterator_close_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lasync_iterator_close_0_asm_h
.Lfunc_end655:
	.size	.Lasync_iterator_close_2_asm_h, .Lfunc_end655-.Lasync_iterator_close_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_iterator_next_2_asm_h
	.type	.Lasync_iterator_next_2_asm_h,@function
.Lasync_iterator_next_2_asm_h:          // @async_iterator_next_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lasync_iterator_next_0_asm_h
.Lfunc_end656:
	.size	.Lasync_iterator_next_2_asm_h, .Lfunc_end656-.Lasync_iterator_next_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_iterator_get_2_asm_h
	.type	.Lasync_iterator_get_2_asm_h,@function
.Lasync_iterator_get_2_asm_h:           // @async_iterator_get_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lasync_iterator_get_0_asm_h
.Lfunc_end657:
	.size	.Lasync_iterator_get_2_asm_h, .Lfunc_end657-.Lasync_iterator_get_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function initial_yield_2_asm_h
	.type	.Linitial_yield_2_asm_h,@function
.Linitial_yield_2_asm_h:                // @initial_yield_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Linitial_yield_0_asm_h
.Lfunc_end658:
	.size	.Linitial_yield_2_asm_h, .Lfunc_end658-.Linitial_yield_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function yield_2_asm_h
	.type	.Lyield_2_asm_h,@function
.Lyield_2_asm_h:                        // @yield_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lyield_0_asm_h
.Lfunc_end659:
	.size	.Lyield_2_asm_h, .Lfunc_end659-.Lyield_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function yield_star_2_asm_h
	.type	.Lyield_star_2_asm_h,@function
.Lyield_star_2_asm_h:                   // @yield_star_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lyield_star_0_asm_h
.Lfunc_end660:
	.size	.Lyield_star_2_asm_h, .Lfunc_end660-.Lyield_star_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_yield_star_2_asm_h
	.type	.Lasync_yield_star_2_asm_h,@function
.Lasync_yield_star_2_asm_h:             // @async_yield_star_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lasync_yield_star_0_asm_h
.Lfunc_end661:
	.size	.Lasync_yield_star_2_asm_h, .Lfunc_end661-.Lasync_yield_star_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function await_2_asm_h
	.type	.Lawait_2_asm_h,@function
.Lawait_2_asm_h:                        // @await_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lawait_0_asm_h
.Lfunc_end662:
	.size	.Lawait_2_asm_h, .Lfunc_end662-.Lawait_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function neg_2_asm_h
	.type	.Lneg_2_asm_h,@function
.Lneg_2_asm_h:                          // @neg_2_asm_h
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	.LBB663_3
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB663_6
// %bb.2:                               // %B13
	orr	w8, w21, #0x80000000
	mov	w9, #-2147483648                // =0x80000000
	cmp	w8, w9
	b.ne	.LBB663_5
.LBB663_3:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #140                        // =0x8c
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB663_8
// %bb.4:                               // %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB663_5:                              // %B15
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x1
.LBB663_6:                              // %B3
	tst	x21, #0xfffe000000000000
	b.eq	.LBB663_3
// %bb.7:                               // %B7
	movi	d0, #0000000000000000
	add	x8, x21, x8
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	fsub	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
.LBB663_8:                              // %B17
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end663:
	.size	.Lneg_2_asm_h, .Lfunc_end663-.Lneg_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function plus_2_asm_h
	.type	.Lplus_2_asm_h,@function
.Lplus_2_asm_h:                         // @plus_2_asm_h
// %bb.0:                               // %B13
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	.LBB664_4
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB664_3
.LBB664_2:                              // %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB664_3:                              // %B3
	tst	x21, #0xfffe000000000000
	b.ne	.LBB664_2
.LBB664_4:                              // %B10
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #141                        // =0x8d
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB664_6
// %bb.5:                               // %B12
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB664_6:                              // %B11
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end664:
	.size	.Lplus_2_asm_h, .Lfunc_end664-.Lplus_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dec_2_asm_h
	.type	.Ldec_2_asm_h,@function
.Ldec_2_asm_h:                          // @dec_2_asm_h
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	.LBB665_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB665_4
// %bb.2:                               // %B13
	subs	w8, w21, #1
	b.vs	.LBB665_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB665_4:                              // %B3
	tst	x21, #0xfffe000000000000
	b.eq	.LBB665_6
// %bb.5:                               // %B7
	add	x8, x21, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
.LBB665_6:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #142                        // =0x8e
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB665_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB665_8:                              // %B17
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end665:
	.size	.Ldec_2_asm_h, .Lfunc_end665-.Ldec_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_2_asm_h
	.type	.Linc_2_asm_h,@function
.Linc_2_asm_h:                          // @inc_2_asm_h
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	.LBB666_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB666_4
// %bb.2:                               // %B13
	adds	w8, w21, #1
	b.vs	.LBB666_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB666_4:                              // %B3
	tst	x21, #0xfffe000000000000
	b.eq	.LBB666_6
// %bb.5:                               // %B7
	add	x8, x21, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
.LBB666_6:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #143                        // =0x8f
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB666_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB666_8:                              // %B17
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end666:
	.size	.Linc_2_asm_h, .Lfunc_end666-.Linc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function post_dec_2_asm_h
	.type	.Lpost_dec_2_asm_h,@function
.Lpost_dec_2_asm_h:                     // @post_dec_2_asm_h
// %bb.0:                               // %B16
	mov	x8, #-281474976710656           // =0xffff000000000000
	str	x22, [x20], #8
	cmp	x21, x8
	b.hs	.LBB667_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB667_4
// %bb.2:                               // %B13
	subs	w8, w21, #1
	b.vs	.LBB667_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	mov	x22, x21
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB667_4:                              // %B3
	tst	x21, #0xfffe000000000000
	b.eq	.LBB667_6
// %bb.5:                               // %B8
	add	x8, x21, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	mov	x22, x21
	add	w8, w8, #494
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x8, x9, x10, vc
	mov	x21, x8
	br	x1
.LBB667_6:                              // %B5
	str	x21, [x20], #8
	mov	w0, #144                        // =0x90
	b	.LSlowJSPostInc_asm_h
.Lfunc_end667:
	.size	.Lpost_dec_2_asm_h, .Lfunc_end667-.Lpost_dec_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function post_inc_2_asm_h
	.type	.Lpost_inc_2_asm_h,@function
.Lpost_inc_2_asm_h:                     // @post_inc_2_asm_h
// %bb.0:                               // %B16
	mov	x8, #-281474976710656           // =0xffff000000000000
	str	x22, [x20], #8
	cmp	x21, x8
	b.hs	.LBB668_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB668_4
// %bb.2:                               // %B13
	adds	w8, w21, #1
	b.vs	.LBB668_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	mov	x22, x21
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB668_4:                              // %B3
	tst	x21, #0xfffe000000000000
	b.eq	.LBB668_6
// %bb.5:                               // %B8
	add	x8, x21, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	mov	x22, x21
	add	w8, w8, #494
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x8, x9, x10, vc
	mov	x21, x8
	br	x1
.LBB668_6:                              // %B5
	str	x21, [x20], #8
	mov	w0, #145                        // =0x91
	b	.LSlowJSPostInc_asm_h
.Lfunc_end668:
	.size	.Lpost_inc_2_asm_h, .Lfunc_end668-.Lpost_inc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dec_loc_2_asm_h
	.type	.Ldec_loc_2_asm_h,@function
.Ldec_loc_2_asm_h:                      // @dec_loc_2_asm_h
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	.LBB669_6
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB669_4
// %bb.2:                               // %B13
	subs	w9, w1, #1
	b.vs	.LBB669_6
// %bb.3:                               // %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB669_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB669_6
// %bb.5:                               // %B8
	add	x9, x1, x9
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB669_6:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #142                        // =0x8e
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB669_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB669_8:                              // %B17
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end669:
	.size	.Ldec_loc_2_asm_h, .Lfunc_end669-.Ldec_loc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_loc_2_asm_h
	.type	.Linc_loc_2_asm_h,@function
.Linc_loc_2_asm_h:                      // @inc_loc_2_asm_h
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	.LBB670_6
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB670_4
// %bb.2:                               // %B13
	adds	w9, w1, #1
	b.vs	.LBB670_6
// %bb.3:                               // %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB670_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB670_6
// %bb.5:                               // %B8
	add	x9, x1, x9
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB670_6:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #143                        // =0x8f
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB670_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB670_8:                              // %B17
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end670:
	.size	.Linc_loc_2_asm_h, .Lfunc_end670-.Linc_loc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_loc_2_asm_h
	.type	.Ladd_loc_2_asm_h,@function
.Ladd_loc_2_asm_h:                      // @add_loc_2_asm_h
// %bb.0:                               // %B46
	sub	sp, sp, #16
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	ccmp	x21, x9, #2, ls
	b.hi	.LBB671_17
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB671_6
// %bb.2:                               // %B26
	cmp	x21, x9
	b.lo	.LBB671_9
// %bb.3:                               // %B36
	adds	w9, w1, w21
	b.vs	.LBB671_12
// %bb.4:                               // %B42
	orr	x9, x9, #0xfffe000000000000
.LBB671_5:                              // %B42
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
.LBB671_6:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB671_17
// %bb.7:                               // %B11
	cmp	x21, x9
	b.lo	.LBB671_15
// %bb.8:                               // %B21
	scvtf	d0, w21
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	.LBB671_14
.LBB671_9:                              // %B28
	tst	x21, #0xfffe000000000000
	b.eq	.LBB671_17
// %bb.10:                              // %B31
	scvtf	d0, w1
	add	x9, x21, x9
.LBB671_11:                             // %B31
	fmov	d1, x9
	b	.LBB671_13
.LBB671_12:                             // %B38
	scvtf	d0, w1
	scvtf	d1, w21
.LBB671_13:                             // %B31
	fadd	d0, d0, d1
.LBB671_14:                             // %B31
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x9, x10, vc
	b	.LBB671_5
.LBB671_15:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB671_17
// %bb.16:                              // %B16
	add	x10, x1, x9
	add	x9, x21, x9
	fmov	d0, x10
	b	.LBB671_11
.LBB671_17:                             // %B7
	and	x8, x21, #0xffff000000000003
	mov	x9, #-281474976710653           // =0xffff000000000003
	mov	x10, #2                         // =0x2
	cmp	x8, x9
	movk	x10, #1, lsl #48
	and	x11, x1, #0xffff000000000003
	ccmp	x8, x10, #4, ne
	str	x20, [sp, #8]                   // 8-byte Folded Spill
	add	x20, x20, #16
	cset	w8, eq
	cmp	x11, x10
	ccmp	x11, x9, #4, ne
	ccmp	w8, #0, #4, eq
	b.ne	.LBB671_20
// %bb.18:                              // %B43
	ldr	x8, [sp, #8]                    // 8-byte Folded Reload
	mov	x0, x24
	mov	x2, x21
	stp	x22, x21, [x8]
	str	x20, [x23, #48]
	bl	prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	.LBB671_21
// %bb.19:                              // %B45
	ldrb	w8, [x19]
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
.LBB671_20:                             // %B8
	ldr	x8, [sp, #8]                    // 8-byte Folded Reload
	mov	w0, #1                          // =0x1
	stp	x22, x21, [x8]
	add	sp, sp, #16
	b	.LFastJSConcatString_asm_h
.LBB671_21:                             // %B44
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	add	sp, sp, #16
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end671:
	.size	.Ladd_loc_2_asm_h, .Lfunc_end671-.Ladd_loc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function not_2_asm_h
	.type	.Lnot_2_asm_h,@function
.Lnot_2_asm_h:                          // @not_2_asm_h
// %bb.0:                               // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB672_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x1
.LBB672_2:                              // %B4
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	.LSlowJSNot_asm_h
.Lfunc_end672:
	.size	.Lnot_2_asm_h, .Lfunc_end672-.Lnot_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lnot_2_asm_h
	.type	.Llnot_2_asm_h,@function
.Llnot_2_asm_h:                         // @lnot_2_asm_h
// %bb.0:                               // %B14
	cmp	x21, #5
	b.le	.LBB673_4
// %bb.1:                               // %B14
	cmp	x21, #6
	b.eq	.LBB673_6
// %bb.2:                               // %B14
	cmp	x21, #7
	b.eq	.LBB673_8
// %bb.3:                               // %B14
	cmp	x21, #18
	b.eq	.LBB673_6
	b	.LBB673_7
.LBB673_4:                              // %B14
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB673_6
// %bb.5:                               // %B14
	cmp	x21, #2
	b.ne	.LBB673_7
.LBB673_6:                              // %B3
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB673_7:                              // %B10
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB673_9
.LBB673_8:                              // %B12
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB673_9:                              // %B13
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	.LSlowToBoolean_asm_h
.Lfunc_end673:
	.size	.Llnot_2_asm_h, .Lfunc_end673-.Llnot_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function typeof_2_asm_h
	.type	.Ltypeof_2_asm_h,@function
.Ltypeof_2_asm_h:                       // @typeof_2_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x21
	bl	js_operator_typeof_gc
	mov	w1, w0
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB674_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB674_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end674:
	.size	.Ltypeof_2_asm_h, .Lfunc_end674-.Ltypeof_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function delete_2_asm_h
	.type	.Ldelete_2_asm_h,@function
.Ldelete_2_asm_h:                       // @delete_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	.LBB675_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB675_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end675:
	.size	.Ldelete_2_asm_h, .Lfunc_end675-.Ldelete_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function delete_var_2_asm_h
	.type	.Ldelete_var_2_asm_h,@function
.Ldelete_var_2_asm_h:                   // @delete_var_2_asm_h
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	mov	w3, wzr
	ldr	w2, [x19]
	ldr	x1, [x24, #208]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #48]
	bl	JS_DeleteProperty_GC
	tbnz	w0, #31, .LBB676_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	mov	x22, x21
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x21, x8, ne
	br	x1
.LBB676_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end676:
	.size	.Ldelete_var_2_asm_h, .Lfunc_end676-.Ldelete_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function mul_2_asm_h
	.type	.Lmul_2_asm_h,@function
.Lmul_2_asm_h:                          // @mul_2_asm_h
// %bb.0:                               // %B51
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB677_20
// %bb.1:                               // %B51
	cmp	x21, x8
	b.hi	.LBB677_20
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB677_8
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB677_11
// %bb.4:                               // %B33
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	.LBB677_14
// %bb.5:                               // %B40
	cbnz	w8, .LBB677_7
// %bb.6:                               // %B40
	orr	w9, w22, w21
	tbnz	w9, #31, .LBB677_17
.LBB677_7:                              // %B47
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB677_8:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB677_20
// %bb.9:                               // %B7
	cmp	x21, x8
	b.lo	.LBB677_18
// %bb.10:                              // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	.LBB677_16
.LBB677_11:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB677_20
// %bb.12:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB677_13:                             // %B28
	fmov	d1, x8
	b	.LBB677_15
.LBB677_14:                             // %B35
	scvtf	d0, w22
	scvtf	d1, w21
.LBB677_15:                             // %B28
	fmul	d0, d0, d1
.LBB677_16:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB677_17:                             // %B44
	mov	x22, #-9222809086901354496      // =0x8002000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB677_18:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB677_20
// %bb.19:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB677_13
.LBB677_20:                             // %B48
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        // =0x9a
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB677_22
// %bb.21:                              // %B50
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB677_22:                             // %B49
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end677:
	.size	.Lmul_2_asm_h, .Lfunc_end677-.Lmul_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function div_2_asm_h
	.type	.Ldiv_2_asm_h,@function
.Ldiv_2_asm_h:                          // @div_2_asm_h
// %bb.0:                               // %B44
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB678_14
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB678_14
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB678_5
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB678_8
// %bb.4:                               // %B33
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w9, [x19], #1
	mov	x12, #9221683186994511872       // =0x7ffa000000000000
	add	w9, w9, #247
	fdiv	d0, d0, d1
	ldr	x1, [x25, w9, uxtw #3]
	fcvtzs	w8, d0
	fmov	x11, d0
	fcmp	d0, d0
	add	x10, x11, x10
	csel	x10, x10, x12, vc
	cmp	x8, x11
	orr	x8, x8, #0xfffe000000000000
	csel	x22, x10, x8, ne
	br	x1
.LBB678_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB678_14
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB678_12
// %bb.7:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	.LBB678_11
.LBB678_8:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB678_14
// %bb.9:                               // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB678_10:                             // %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
.LBB678_11:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB678_12:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB678_14
// %bb.13:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB678_10
.LBB678_14:                             // %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        // =0x9b
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB678_16
// %bb.15:                              // %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB678_16:                             // %B42
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end678:
	.size	.Ldiv_2_asm_h, .Lfunc_end678-.Ldiv_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function mod_2_asm_h
	.type	.Lmod_2_asm_h,@function
.Lmod_2_asm_h:                          // @mod_2_asm_h
// %bb.0:                               // %B39
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB679_16
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB679_16
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB679_7
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB679_10
// %bb.4:                               // %B33
	tbnz	w22, #31, .LBB679_16
// %bb.5:                               // %B33
	cmp	w21, #1
	b.lt	.LBB679_16
// %bb.6:                               // %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB679_7:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB679_16
// %bb.8:                               // %B7
	cmp	x21, x8
	b.lo	.LBB679_14
// %bb.9:                               // %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	.LBB679_13
.LBB679_10:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB679_16
// %bb.11:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB679_12:                             // %B28
	fmov	d1, x8
.LBB679_13:                             // %B28
	bl	fmod
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB679_14:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB679_16
// %bb.15:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB679_12
.LBB679_16:                             // %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        // =0x9c
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB679_18
// %bb.17:                              // %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB679_18:                             // %B37
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end679:
	.size	.Lmod_2_asm_h, .Lfunc_end679-.Lmod_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_2_asm_h
	.type	.Ladd_2_asm_h,@function
.Ladd_2_asm_h:                          // @add_2_asm_h
// %bb.0:                               // %B46
	sub	sp, sp, #16
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB680_17
// %bb.1:                               // %B46
	cmp	x21, x8
	b.hi	.LBB680_17
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB680_6
// %bb.3:                               // %B26
	cmp	x21, x8
	b.lo	.LBB680_9
// %bb.4:                               // %B36
	adds	w8, w22, w21
	b.vs	.LBB680_12
// %bb.5:                               // %B42
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	add	sp, sp, #16
	br	x1
.LBB680_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB680_17
// %bb.7:                               // %B11
	cmp	x21, x8
	b.lo	.LBB680_15
// %bb.8:                               // %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	.LBB680_14
.LBB680_9:                              // %B28
	tst	x21, #0xfffe000000000000
	b.eq	.LBB680_17
// %bb.10:                              // %B31
	scvtf	d0, w22
	add	x8, x21, x8
.LBB680_11:                             // %B31
	fmov	d1, x8
	b	.LBB680_13
.LBB680_12:                             // %B38
	scvtf	d0, w22
	scvtf	d1, w21
.LBB680_13:                             // %B31
	fadd	d0, d0, d1
.LBB680_14:                             // %B31
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	w8, w8, #247
	add	x9, x9, x10
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	add	sp, sp, #16
	br	x1
.LBB680_15:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB680_17
// %bb.16:                              // %B16
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB680_11
.LBB680_17:                             // %B7
	and	x8, x21, #0xffff000000000003
	mov	x9, #-281474976710653           // =0xffff000000000003
	mov	x10, #2                         // =0x2
	cmp	x8, x9
	movk	x10, #1, lsl #48
	and	x11, x22, #0xffff000000000003
	ccmp	x8, x10, #4, ne
	str	x20, [sp, #8]                   // 8-byte Folded Spill
	add	x20, x20, #16
	cset	w8, eq
	cmp	x11, x10
	ccmp	x11, x9, #4, ne
	b.ne	.LBB680_20
// %bb.18:                              // %B7
	cbz	w8, .LBB680_20
// %bb.19:                              // %B8
	ldr	x8, [sp, #8]                    // 8-byte Folded Reload
	mov	x0, xzr
	stp	x22, x21, [x8]
	add	sp, sp, #16
	b	.LFastJSConcatString_asm_h
.LBB680_20:                             // %B43
	ldr	x8, [sp, #8]                    // 8-byte Folded Reload
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x8]
	str	x20, [x23, #48]
	bl	prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	.LBB680_22
// %bb.21:                              // %B45
	ldrb	w8, [x19], #1
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
.LBB680_22:                             // %B44
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	add	sp, sp, #16
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end680:
	.size	.Ladd_2_asm_h, .Lfunc_end680-.Ladd_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function sub_2_asm_h
	.type	.Lsub_2_asm_h,@function
.Lsub_2_asm_h:                          // @sub_2_asm_h
// %bb.0:                               // %B43
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB681_17
// %bb.1:                               // %B43
	cmp	x21, x8
	b.hi	.LBB681_17
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB681_6
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB681_9
// %bb.4:                               // %B33
	subs	w8, w22, w21
	b.vs	.LBB681_12
// %bb.5:                               // %B39
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB681_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB681_17
// %bb.7:                               // %B7
	cmp	x21, x8
	b.lo	.LBB681_15
// %bb.8:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	.LBB681_14
.LBB681_9:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB681_17
// %bb.10:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB681_11:                             // %B28
	fmov	d1, x8
	b	.LBB681_13
.LBB681_12:                             // %B35
	scvtf	d0, w22
	scvtf	d1, w21
.LBB681_13:                             // %B28
	fsub	d0, d0, d1
.LBB681_14:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB681_15:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB681_17
// %bb.16:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB681_11
.LBB681_17:                             // %B40
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        // =0x9e
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB681_19
// %bb.18:                              // %B42
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB681_19:                             // %B41
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end681:
	.size	.Lsub_2_asm_h, .Lfunc_end681-.Lsub_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function pow_2_asm_h
	.type	.Lpow_2_asm_h,@function
.Lpow_2_asm_h:                          // @pow_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #159                        // =0x9f
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB682_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB682_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end682:
	.size	.Lpow_2_asm_h, .Lfunc_end682-.Lpow_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function shl_2_asm_h
	.type	.Lshl_2_asm_h,@function
.Lshl_2_asm_h:                          // @shl_2_asm_h
// %bb.0:                               // %B28
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB683_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB683_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB683_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB683_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	add	w9, w9, #247
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB683_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB683_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB683_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB683_9
// %bb.8:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	add	w9, w9, #247
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB683_9:                              // %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        // =0xa0
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB683_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB683_11:                             // %B26
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end683:
	.size	.Lshl_2_asm_h, .Lfunc_end683-.Lshl_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function sar_2_asm_h
	.type	.Lsar_2_asm_h,@function
.Lsar_2_asm_h:                          // @sar_2_asm_h
// %bb.0:                               // %B28
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB684_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB684_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB684_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB684_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	add	w9, w9, #247
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB684_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB684_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB684_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB684_9
// %bb.8:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	add	w9, w9, #247
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB684_9:                              // %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        // =0xa1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB684_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB684_11:                             // %B26
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end684:
	.size	.Lsar_2_asm_h, .Lfunc_end684-.Lsar_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function shr_2_asm_h
	.type	.Lshr_2_asm_h,@function
.Lshr_2_asm_h:                          // @shr_2_asm_h
// %bb.0:                               // %B36
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB685_11
// %bb.1:                               // %B36
	cmp	x21, x8
	b.hi	.LBB685_11
// %bb.2:                               // %B10
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB685_6
// %bb.3:                               // %B27
	cmp	x21, x8
	b.lo	.LBB685_11
// %bb.4:                               // %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, .LBB685_10
.LBB685_5:                              // %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB685_6:                              // %B12
	tst	x22, #0xfffe000000000000
	b.eq	.LBB685_11
// %bb.7:                               // %B12
	cmp	x21, x8
	b.lo	.LBB685_11
// %bb.8:                               // %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB685_11
// %bb.9:                               // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, .LBB685_5
.LBB685_10:                             // %B6
	ucvtf	d0, w8
	mov	x9, #562949953421312            // =0x2000000000000
	fmov	x8, d0
	fcmp	d0, d0
	add	x8, x8, x9
	mov	x9, #9221683186994511872        // =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB685_11:                             // %B33
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	.LBB685_13
// %bb.12:                              // %B35
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB685_13:                             // %B34
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end685:
	.size	.Lshr_2_asm_h, .Lfunc_end685-.Lshr_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lt_2_asm_h
	.type	.Llt_2_asm_h,@function
.Llt_2_asm_h:                           // @lt_2_asm_h
// %bb.0:                               // %B24
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB686_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB686_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB686_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB686_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, lt
	br	x1
.LBB686_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB686_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB686_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB686_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB686_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB686_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB686_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB686_12:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        // =0xa3
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB686_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB686_14:                             // %B22
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end686:
	.size	.Llt_2_asm_h, .Lfunc_end686-.Llt_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lte_2_asm_h
	.type	.Llte_2_asm_h,@function
.Llte_2_asm_h:                          // @lte_2_asm_h
// %bb.0:                               // %B24
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB687_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB687_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB687_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB687_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, le
	br	x1
.LBB687_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB687_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB687_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB687_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB687_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB687_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB687_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB687_12:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        // =0xa4
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB687_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB687_14:                             // %B22
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end687:
	.size	.Llte_2_asm_h, .Lfunc_end687-.Llte_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gt_2_asm_h
	.type	.Lgt_2_asm_h,@function
.Lgt_2_asm_h:                           // @gt_2_asm_h
// %bb.0:                               // %B24
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB688_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB688_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB688_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB688_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB688_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB688_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB688_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB688_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB688_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB688_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB688_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB688_12:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        // =0xa5
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB688_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB688_14:                             // %B22
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end688:
	.size	.Lgt_2_asm_h, .Lfunc_end688-.Lgt_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gte_2_asm_h
	.type	.Lgte_2_asm_h,@function
.Lgte_2_asm_h:                          // @gte_2_asm_h
// %bb.0:                               // %B24
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB689_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB689_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB689_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB689_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB689_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB689_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB689_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB689_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB689_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB689_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB689_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB689_12:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        // =0xa6
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB689_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB689_14:                             // %B22
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end689:
	.size	.Lgte_2_asm_h, .Lfunc_end689-.Lgte_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function instanceof_2_asm_h
	.type	.Linstanceof_2_asm_h,@function
.Linstanceof_2_asm_h:                   // @instanceof_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	.LBB690_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB690_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end690:
	.size	.Linstanceof_2_asm_h, .Lfunc_end690-.Linstanceof_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function in_2_asm_h
	.type	.Lin_2_asm_h,@function
.Lin_2_asm_h:                           // @in_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	.LBB691_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB691_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end691:
	.size	.Lin_2_asm_h, .Lfunc_end691-.Lin_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function eq_2_asm_h
	.type	.Leq_2_asm_h,@function
.Leq_2_asm_h:                           // @eq_2_asm_h
// %bb.0:                               // %B44
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB692_13
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB692_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB692_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB692_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB692_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB692_13
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB692_11
// %bb.7:                               // %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB692_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB692_13
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB692_10:                             // %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB692_11:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB692_13
// %bb.12:                              // %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB692_10
.LBB692_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB692_15
.LBB692_14:                             // %B8
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB692_15:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB692_17
// %bb.16:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB692_14
	b	.LBB692_20
.LBB692_17:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB692_20
// %bb.18:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB692_21
// %bb.19:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB692_21
.LBB692_20:                             // %B15
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB692_21:                             // %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB692_23
// %bb.22:                              // %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB692_23:                             // %B42
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end692:
	.size	.Leq_2_asm_h, .Lfunc_end692-.Leq_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function neq_2_asm_h
	.type	.Lneq_2_asm_h,@function
.Lneq_2_asm_h:                          // @neq_2_asm_h
// %bb.0:                               // %B44
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB693_13
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB693_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB693_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB693_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB693_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB693_13
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB693_11
// %bb.7:                               // %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB693_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB693_13
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB693_10:                             // %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB693_11:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB693_13
// %bb.12:                              // %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB693_10
.LBB693_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB693_15
.LBB693_14:                             // %B8
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB693_15:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB693_17
// %bb.16:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB693_14
	b	.LBB693_20
.LBB693_17:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB693_20
// %bb.18:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB693_21
// %bb.19:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB693_21
.LBB693_20:                             // %B15
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB693_21:                             // %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB693_23
// %bb.22:                              // %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB693_23:                             // %B42
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end693:
	.size	.Lneq_2_asm_h, .Lfunc_end693-.Lneq_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function strict_eq_2_asm_h
	.type	.Lstrict_eq_2_asm_h,@function
.Lstrict_eq_2_asm_h:                    // @strict_eq_2_asm_h
// %bb.0:                               // %B39
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB694_13
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB694_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB694_5
// %bb.3:                               // %B30
	cmp	x21, x8
	b.lo	.LBB694_8
// %bb.4:                               // %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB694_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB694_13
// %bb.6:                               // %B23
	cmp	x21, x8
	b.lo	.LBB694_11
// %bb.7:                               // %B28
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB694_8:                              // %B32
	tst	x21, #0xfffe000000000000
	b.eq	.LBB694_13
// %bb.9:                               // %B34
	scvtf	d0, w22
	add	x8, x21, x8
.LBB694_10:                             // %B34
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB694_11:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB694_13
// %bb.12:                              // %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB694_10
.LBB694_13:                             // %B10
	cmp	x22, x21
	b.ne	.LBB694_15
.LBB694_14:                             // %B11
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB694_15:                             // %B13
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x10, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w9, eq
	cmp	x10, x11
	ccmp	x10, x12, #4, ne
	cset	w11, eq
	cmp	w9, #1
	b.ne	.LBB694_17
// %bb.16:                              // %B13
	cbnz	w11, .LBB694_22
.LBB694_17:                             // %B16
	mov	x12, #2                         // =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, .LBB694_19
// %bb.18:                              // %B16
	tbnz	w8, #0, .LBB694_23
.LBB694_19:                             // %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x9, x8
	b.ne	.LBB694_21
// %bb.20:                              // %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	.LBB694_25
.LBB694_21:                             // %B21
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB694_22:                             // %B14
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, xzr
	stp	x22, x21, [x8]
	b	.LFastStringEqual_asm_h
.LBB694_23:                             // %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB694_27
// %bb.24:                              // %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB694_25:                             // %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB694_14
// %bb.26:                              // %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB694_27:                             // %B37
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end694:
	.size	.Lstrict_eq_2_asm_h, .Lfunc_end694-.Lstrict_eq_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function strict_neq_2_asm_h
	.type	.Lstrict_neq_2_asm_h,@function
.Lstrict_neq_2_asm_h:                   // @strict_neq_2_asm_h
// %bb.0:                               // %B39
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB695_13
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB695_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB695_5
// %bb.3:                               // %B30
	cmp	x21, x8
	b.lo	.LBB695_8
// %bb.4:                               // %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB695_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB695_13
// %bb.6:                               // %B23
	cmp	x21, x8
	b.lo	.LBB695_11
// %bb.7:                               // %B28
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB695_8:                              // %B32
	tst	x21, #0xfffe000000000000
	b.eq	.LBB695_13
// %bb.9:                               // %B34
	scvtf	d0, w22
	add	x8, x21, x8
.LBB695_10:                             // %B34
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB695_11:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB695_13
// %bb.12:                              // %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB695_10
.LBB695_13:                             // %B10
	cmp	x22, x21
	b.ne	.LBB695_15
.LBB695_14:                             // %B11
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB695_15:                             // %B13
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x10, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w9, eq
	cmp	x10, x11
	ccmp	x10, x12, #4, ne
	cset	w11, eq
	cmp	w9, #1
	b.ne	.LBB695_17
// %bb.16:                              // %B13
	cbnz	w11, .LBB695_22
.LBB695_17:                             // %B16
	mov	x12, #2                         // =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, .LBB695_19
// %bb.18:                              // %B16
	tbnz	w8, #0, .LBB695_23
.LBB695_19:                             // %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x9, x8
	b.ne	.LBB695_21
// %bb.20:                              // %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	.LBB695_25
.LBB695_21:                             // %B21
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB695_22:                             // %B14
	mov	x8, x20
	add	x20, x20, #16
	mov	w0, #1                          // =0x1
	stp	x22, x21, [x8]
	b	.LFastStringEqual_asm_h
.LBB695_23:                             // %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB695_27
// %bb.24:                              // %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB695_25:                             // %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB695_14
// %bb.26:                              // %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB695_27:                             // %B37
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end695:
	.size	.Lstrict_neq_2_asm_h, .Lfunc_end695-.Lstrict_neq_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function and_2_asm_h
	.type	.Land_2_asm_h,@function
.Land_2_asm_h:                          // @and_2_asm_h
// %bb.0:                               // %B28
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB696_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB696_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB696_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB696_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	and	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB696_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB696_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB696_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB696_9
// %bb.8:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	and	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB696_9:                              // %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        // =0xad
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB696_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB696_11:                             // %B26
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end696:
	.size	.Land_2_asm_h, .Lfunc_end696-.Land_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function xor_2_asm_h
	.type	.Lxor_2_asm_h,@function
.Lxor_2_asm_h:                          // @xor_2_asm_h
// %bb.0:                               // %B28
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB697_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB697_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB697_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB697_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	eor	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB697_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB697_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB697_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB697_9
// %bb.8:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	eor	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB697_9:                              // %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        // =0xae
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB697_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB697_11:                             // %B26
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end697:
	.size	.Lxor_2_asm_h, .Lfunc_end697-.Lxor_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function or_2_asm_h
	.type	.Lor_2_asm_h,@function
.Lor_2_asm_h:                           // @or_2_asm_h
// %bb.0:                               // %B28
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB698_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB698_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB698_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB698_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	orr	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB698_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB698_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB698_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB698_9
// %bb.8:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	orr	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #247
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB698_9:                              // %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        // =0xaf
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB698_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB698_11:                             // %B26
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end698:
	.size	.Lor_2_asm_h, .Lfunc_end698-.Lor_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nop_2_asm_h
	.type	.Lnop_2_asm_h,@function
.Lnop_2_asm_h:                          // @nop_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end699:
	.size	.Lnop_2_asm_h, .Lfunc_end699-.Lnop_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_minus1_2_asm_h
	.type	.Lpush_minus1_2_asm_h,@function
.Lpush_minus1_2_asm_h:                  // @push_minus1_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562945658454017          // =0xfffe0000ffffffff
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end700:
	.size	.Lpush_minus1_2_asm_h, .Lfunc_end700-.Lpush_minus1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_0_2_asm_h
	.type	.Lpush_0_2_asm_h,@function
.Lpush_0_2_asm_h:                       // @push_0_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421312          // =0xfffe000000000000
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end701:
	.size	.Lpush_0_2_asm_h, .Lfunc_end701-.Lpush_0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_1_2_asm_h
	.type	.Lpush_1_2_asm_h,@function
.Lpush_1_2_asm_h:                       // @push_1_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421311          // =0xfffe000000000001
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end702:
	.size	.Lpush_1_2_asm_h, .Lfunc_end702-.Lpush_1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_2_2_asm_h
	.type	.Lpush_2_2_asm_h,@function
.Lpush_2_2_asm_h:                       // @push_2_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #2                         // =0x2
	movk	x21, #65534, lsl #48
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end703:
	.size	.Lpush_2_2_asm_h, .Lfunc_end703-.Lpush_2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_3_2_asm_h
	.type	.Lpush_3_2_asm_h,@function
.Lpush_3_2_asm_h:                       // @push_3_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421309          // =0xfffe000000000003
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end704:
	.size	.Lpush_3_2_asm_h, .Lfunc_end704-.Lpush_3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_4_2_asm_h
	.type	.Lpush_4_2_asm_h,@function
.Lpush_4_2_asm_h:                       // @push_4_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #4                         // =0x4
	movk	x21, #65534, lsl #48
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end705:
	.size	.Lpush_4_2_asm_h, .Lfunc_end705-.Lpush_4_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_5_2_asm_h
	.type	.Lpush_5_2_asm_h,@function
.Lpush_5_2_asm_h:                       // @push_5_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #5                         // =0x5
	movk	x21, #65534, lsl #48
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end706:
	.size	.Lpush_5_2_asm_h, .Lfunc_end706-.Lpush_5_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_6_2_asm_h
	.type	.Lpush_6_2_asm_h,@function
.Lpush_6_2_asm_h:                       // @push_6_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #6                         // =0x6
	movk	x21, #65534, lsl #48
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end707:
	.size	.Lpush_6_2_asm_h, .Lfunc_end707-.Lpush_6_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_7_2_asm_h
	.type	.Lpush_7_2_asm_h,@function
.Lpush_7_2_asm_h:                       // @push_7_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421305          // =0xfffe000000000007
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end708:
	.size	.Lpush_7_2_asm_h, .Lfunc_end708-.Lpush_7_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i8_2_asm_h
	.type	.Lpush_i8_2_asm_h,@function
.Lpush_i8_2_asm_h:                      // @push_i8_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x8, #-562949953421312           // =0xfffe000000000000
	ldrb	w9, [x19, #1]
	ldrsb	x10, [x19]
	add	x19, x19, #2
	mov	x22, x21
	add	w9, w9, #494
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x8
	br	x1
.Lfunc_end709:
	.size	.Lpush_i8_2_asm_h, .Lfunc_end709-.Lpush_i8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i16_2_asm_h
	.type	.Lpush_i16_2_asm_h,@function
.Lpush_i16_2_asm_h:                     // @push_i16_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x8, #-562949953421312           // =0xfffe000000000000
	ldrb	w9, [x19, #2]
	ldrsh	x10, [x19]
	add	x19, x19, #3
	mov	x22, x21
	add	w9, w9, #494
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x8
	br	x1
.Lfunc_end710:
	.size	.Lpush_i16_2_asm_h, .Lfunc_end710-.Lpush_i16_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_const8_2_asm_h
	.type	.Lpush_const8_2_asm_h,@function
.Lpush_const8_2_asm_h:                  // @push_const8_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #1]
	ldr	x9, [x23, #104]
	ldrb	w10, [x19], #2
	add	w8, w8, #494
	ldr	x9, [x9, x10, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x9
	br	x1
.Lfunc_end711:
	.size	.Lpush_const8_2_asm_h, .Lfunc_end711-.Lpush_const8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function fclosure8_2_asm_h
	.type	.Lfclosure8_2_asm_h,@function
.Lfclosure8_2_asm_h:                    // @fclosure8_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lfclosure8_0_asm_h
.Lfunc_end712:
	.size	.Lfclosure8_2_asm_h, .Lfunc_end712-.Lfclosure8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_empty_string_2_asm_h
	.type	.Lpush_empty_string_2_asm_h,@function
.Lpush_empty_string_2_asm_h:            // @push_empty_string_2_asm_h
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	mov	w1, #47                         // =0x2f
	str	x21, [x20, #8]!
	add	x8, x20, #8
	mov	w2, #1                          // =0x1
	str	x8, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB713_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB713_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end713:
	.size	.Lpush_empty_string_2_asm_h, .Lfunc_end713-.Lpush_empty_string_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc8_2_asm_h
	.type	.Lget_loc8_2_asm_h,@function
.Lget_loc8_2_asm_h:                     // @get_loc8_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #1]
	ldrb	w9, [x19], #2
	add	w8, w8, #494
	ldr	x9, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x9
	br	x1
.Lfunc_end714:
	.size	.Lget_loc8_2_asm_h, .Lfunc_end714-.Lget_loc8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc8_2_asm_h
	.type	.Lput_loc8_2_asm_h,@function
.Lput_loc8_2_asm_h:                     // @put_loc8_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end715:
	.size	.Lput_loc8_2_asm_h, .Lfunc_end715-.Lput_loc8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc8_2_asm_h
	.type	.Lset_loc8_2_asm_h,@function
.Lset_loc8_2_asm_h:                     // @set_loc8_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end716:
	.size	.Lset_loc8_2_asm_h, .Lfunc_end716-.Lset_loc8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc0_2_asm_h
	.type	.Lget_loc0_2_asm_h,@function
.Lget_loc0_2_asm_h:                     // @get_loc0_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x27]
	add	w8, w8, #494
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end717:
	.size	.Lget_loc0_2_asm_h, .Lfunc_end717-.Lget_loc0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc1_2_asm_h
	.type	.Lget_loc1_2_asm_h,@function
.Lget_loc1_2_asm_h:                     // @get_loc1_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x27, #8]
	add	w8, w8, #494
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end718:
	.size	.Lget_loc1_2_asm_h, .Lfunc_end718-.Lget_loc1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc2_2_asm_h
	.type	.Lget_loc2_2_asm_h,@function
.Lget_loc2_2_asm_h:                     // @get_loc2_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x27, #16]
	add	w8, w8, #494
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end719:
	.size	.Lget_loc2_2_asm_h, .Lfunc_end719-.Lget_loc2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc3_2_asm_h
	.type	.Lget_loc3_2_asm_h,@function
.Lget_loc3_2_asm_h:                     // @get_loc3_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x27, #24]
	add	w8, w8, #494
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end720:
	.size	.Lget_loc3_2_asm_h, .Lfunc_end720-.Lget_loc3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc0_2_asm_h
	.type	.Lput_loc0_2_asm_h,@function
.Lput_loc0_2_asm_h:                     // @put_loc0_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end721:
	.size	.Lput_loc0_2_asm_h, .Lfunc_end721-.Lput_loc0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc1_2_asm_h
	.type	.Lput_loc1_2_asm_h,@function
.Lput_loc1_2_asm_h:                     // @put_loc1_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end722:
	.size	.Lput_loc1_2_asm_h, .Lfunc_end722-.Lput_loc1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc2_2_asm_h
	.type	.Lput_loc2_2_asm_h,@function
.Lput_loc2_2_asm_h:                     // @put_loc2_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end723:
	.size	.Lput_loc2_2_asm_h, .Lfunc_end723-.Lput_loc2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc3_2_asm_h
	.type	.Lput_loc3_2_asm_h,@function
.Lput_loc3_2_asm_h:                     // @put_loc3_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end724:
	.size	.Lput_loc3_2_asm_h, .Lfunc_end724-.Lput_loc3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc0_2_asm_h
	.type	.Lset_loc0_2_asm_h,@function
.Lset_loc0_2_asm_h:                     // @set_loc0_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end725:
	.size	.Lset_loc0_2_asm_h, .Lfunc_end725-.Lset_loc0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc1_2_asm_h
	.type	.Lset_loc1_2_asm_h,@function
.Lset_loc1_2_asm_h:                     // @set_loc1_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end726:
	.size	.Lset_loc1_2_asm_h, .Lfunc_end726-.Lset_loc1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc2_2_asm_h
	.type	.Lset_loc2_2_asm_h,@function
.Lset_loc2_2_asm_h:                     // @set_loc2_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end727:
	.size	.Lset_loc2_2_asm_h, .Lfunc_end727-.Lset_loc2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc3_2_asm_h
	.type	.Lset_loc3_2_asm_h,@function
.Lset_loc3_2_asm_h:                     // @set_loc3_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end728:
	.size	.Lset_loc3_2_asm_h, .Lfunc_end728-.Lset_loc3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg0_2_asm_h
	.type	.Lget_arg0_2_asm_h,@function
.Lget_arg0_2_asm_h:                     // @get_arg0_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x28]
	add	w8, w8, #494
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end729:
	.size	.Lget_arg0_2_asm_h, .Lfunc_end729-.Lget_arg0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg1_2_asm_h
	.type	.Lget_arg1_2_asm_h,@function
.Lget_arg1_2_asm_h:                     // @get_arg1_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x28, #8]
	add	w8, w8, #494
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end730:
	.size	.Lget_arg1_2_asm_h, .Lfunc_end730-.Lget_arg1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg2_2_asm_h
	.type	.Lget_arg2_2_asm_h,@function
.Lget_arg2_2_asm_h:                     // @get_arg2_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x28, #16]
	add	w8, w8, #494
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end731:
	.size	.Lget_arg2_2_asm_h, .Lfunc_end731-.Lget_arg2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg3_2_asm_h
	.type	.Lget_arg3_2_asm_h,@function
.Lget_arg3_2_asm_h:                     // @get_arg3_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x28, #24]
	add	w8, w8, #494
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end732:
	.size	.Lget_arg3_2_asm_h, .Lfunc_end732-.Lget_arg3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg0_2_asm_h
	.type	.Lput_arg0_2_asm_h,@function
.Lput_arg0_2_asm_h:                     // @put_arg0_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end733:
	.size	.Lput_arg0_2_asm_h, .Lfunc_end733-.Lput_arg0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg1_2_asm_h
	.type	.Lput_arg1_2_asm_h,@function
.Lput_arg1_2_asm_h:                     // @put_arg1_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end734:
	.size	.Lput_arg1_2_asm_h, .Lfunc_end734-.Lput_arg1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg2_2_asm_h
	.type	.Lput_arg2_2_asm_h,@function
.Lput_arg2_2_asm_h:                     // @put_arg2_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end735:
	.size	.Lput_arg2_2_asm_h, .Lfunc_end735-.Lput_arg2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg3_2_asm_h
	.type	.Lput_arg3_2_asm_h,@function
.Lput_arg3_2_asm_h:                     // @put_arg3_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end736:
	.size	.Lput_arg3_2_asm_h, .Lfunc_end736-.Lput_arg3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg0_2_asm_h
	.type	.Lset_arg0_2_asm_h,@function
.Lset_arg0_2_asm_h:                     // @set_arg0_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end737:
	.size	.Lset_arg0_2_asm_h, .Lfunc_end737-.Lset_arg0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg1_2_asm_h
	.type	.Lset_arg1_2_asm_h,@function
.Lset_arg1_2_asm_h:                     // @set_arg1_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end738:
	.size	.Lset_arg1_2_asm_h, .Lfunc_end738-.Lset_arg1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg2_2_asm_h
	.type	.Lset_arg2_2_asm_h,@function
.Lset_arg2_2_asm_h:                     // @set_arg2_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end739:
	.size	.Lset_arg2_2_asm_h, .Lfunc_end739-.Lset_arg2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg3_2_asm_h
	.type	.Lset_arg3_2_asm_h,@function
.Lset_arg3_2_asm_h:                     // @set_arg3_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end740:
	.size	.Lset_arg3_2_asm_h, .Lfunc_end740-.Lset_arg3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref0_2_asm_h
	.type	.Lget_var_ref0_2_asm_h,@function
.Lget_var_ref0_2_asm_h:                 // @get_var_ref0_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x26]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x8, [x8]
	mov	x21, x8
	br	x1
.Lfunc_end741:
	.size	.Lget_var_ref0_2_asm_h, .Lfunc_end741-.Lget_var_ref0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref1_2_asm_h
	.type	.Lget_var_ref1_2_asm_h,@function
.Lget_var_ref1_2_asm_h:                 // @get_var_ref1_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x26, #8]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x8, [x8]
	mov	x21, x8
	br	x1
.Lfunc_end742:
	.size	.Lget_var_ref1_2_asm_h, .Lfunc_end742-.Lget_var_ref1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref2_2_asm_h
	.type	.Lget_var_ref2_2_asm_h,@function
.Lget_var_ref2_2_asm_h:                 // @get_var_ref2_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x26, #16]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x8, [x8]
	mov	x21, x8
	br	x1
.Lfunc_end743:
	.size	.Lget_var_ref2_2_asm_h, .Lfunc_end743-.Lget_var_ref2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref3_2_asm_h
	.type	.Lget_var_ref3_2_asm_h,@function
.Lget_var_ref3_2_asm_h:                 // @get_var_ref3_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x26, #24]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x8, [x8]
	mov	x21, x8
	br	x1
.Lfunc_end744:
	.size	.Lget_var_ref3_2_asm_h, .Lfunc_end744-.Lget_var_ref3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref0_2_asm_h
	.type	.Lput_var_ref0_2_asm_h,@function
.Lput_var_ref0_2_asm_h:                 // @put_var_ref0_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end745:
	.size	.Lput_var_ref0_2_asm_h, .Lfunc_end745-.Lput_var_ref0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref1_2_asm_h
	.type	.Lput_var_ref1_2_asm_h,@function
.Lput_var_ref1_2_asm_h:                 // @put_var_ref1_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end746:
	.size	.Lput_var_ref1_2_asm_h, .Lfunc_end746-.Lput_var_ref1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref2_2_asm_h
	.type	.Lput_var_ref2_2_asm_h,@function
.Lput_var_ref2_2_asm_h:                 // @put_var_ref2_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end747:
	.size	.Lput_var_ref2_2_asm_h, .Lfunc_end747-.Lput_var_ref2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref3_2_asm_h
	.type	.Lput_var_ref3_2_asm_h,@function
.Lput_var_ref3_2_asm_h:                 // @put_var_ref3_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end748:
	.size	.Lput_var_ref3_2_asm_h, .Lfunc_end748-.Lput_var_ref3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref0_2_asm_h
	.type	.Lset_var_ref0_2_asm_h,@function
.Lset_var_ref0_2_asm_h:                 // @set_var_ref0_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end749:
	.size	.Lset_var_ref0_2_asm_h, .Lfunc_end749-.Lset_var_ref0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref1_2_asm_h
	.type	.Lset_var_ref1_2_asm_h,@function
.Lset_var_ref1_2_asm_h:                 // @set_var_ref1_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end750:
	.size	.Lset_var_ref1_2_asm_h, .Lfunc_end750-.Lset_var_ref1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref2_2_asm_h
	.type	.Lset_var_ref2_2_asm_h,@function
.Lset_var_ref2_2_asm_h:                 // @set_var_ref2_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end751:
	.size	.Lset_var_ref2_2_asm_h, .Lfunc_end751-.Lset_var_ref2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref3_2_asm_h
	.type	.Lset_var_ref3_2_asm_h,@function
.Lset_var_ref3_2_asm_h:                 // @set_var_ref3_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end752:
	.size	.Lset_var_ref3_2_asm_h, .Lfunc_end752-.Lset_var_ref3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_length_2_asm_h
	.type	.Lget_length_2_asm_h,@function
.Lget_length_2_asm_h:                   // @get_length_2_asm_h
// %bb.0:                               // %B27
	mov	x9, #2                          // =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	.LBB753_2
// %bb.1:                               // %B27
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB753_3
.LBB753_2:                              // %B28
	and	x8, x21, #0xfffffffffffc
	ldrb	w9, [x19], #1
	ldr	w8, [x8, #4]
	mov	x10, #-562949953421312          // =0xfffe000000000000
	add	w9, w9, #494
	bfxil	x10, x8, #0, #30
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x10
	br	x1
.LBB753_3:                              // %B21
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	.LBB753_13
// %bb.4:                               // %B22
	mov	x9, x21
	mov	w8, #18                         // =0x12
.LBB753_5:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB753_6 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w11, #0x30
	ldr	w10, [x13, w10, uxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB753_8
.LBB753_6:                              // %B1
                                        //   Parent Loop BB753_5 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, #48
	b.eq	.LBB753_10
// %bb.7:                               // %B9
                                        //   in Loop: Header=BB753_6 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB753_6
.LBB753_8:                              // %B14
                                        //   in Loop: Header=BB753_5 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB753_13
// %bb.9:                               // %B17
                                        //   in Loop: Header=BB753_5 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB753_5
	b	.LBB753_12
.LBB753_10:                             // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB753_13
// %bb.11:                              // %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB753_12:                             // %B6
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB753_13:                             // %B24
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #48                         // =0x30
	mov	x3, x21
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB753_15
// %bb.14:                              // %B26
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB753_15:                             // %B25
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end753:
	.size	.Lget_length_2_asm_h, .Lfunc_end753-.Lget_length_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_false8_2_asm_h
	.type	.Lif_false8_2_asm_h,@function
.Lif_false8_2_asm_h:                    // @if_false8_2_asm_h
// %bb.0:                               // %B23
	cmp	x21, #5
	b.le	.LBB754_4
// %bb.1:                               // %B23
	cmp	x21, #6
	b.eq	.LBB754_6
// %bb.2:                               // %B23
	cmp	x21, #7
	b.eq	.LBB754_9
// %bb.3:                               // %B23
	cmp	x21, #18
	b.eq	.LBB754_6
	b	.LBB754_7
.LBB754_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB754_6
// %bb.5:                               // %B23
	cmp	x21, #2
	b.ne	.LBB754_7
.LBB754_6:                              // %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB754_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x21, x8
	b.hs	.LBB754_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB754_10
.LBB754_9:                              // %B19
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB754_10:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB754_13
// %bb.11:                              // %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB754_6
	b.vs	.LBB754_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB754_9
	b	.LBB754_6
.LBB754_13:                             // %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	.LSlowToBoolean_asm_h
.Lfunc_end754:
	.size	.Lif_false8_2_asm_h, .Lfunc_end754-.Lif_false8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_true8_2_asm_h
	.type	.Lif_true8_2_asm_h,@function
.Lif_true8_2_asm_h:                     // @if_true8_2_asm_h
// %bb.0:                               // %B23
	cmp	x21, #5
	b.le	.LBB755_4
// %bb.1:                               // %B23
	cmp	x21, #6
	b.eq	.LBB755_6
// %bb.2:                               // %B23
	cmp	x21, #7
	b.eq	.LBB755_9
// %bb.3:                               // %B23
	cmp	x21, #18
	b.eq	.LBB755_6
	b	.LBB755_7
.LBB755_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB755_6
// %bb.5:                               // %B23
	cmp	x21, #2
	b.ne	.LBB755_7
.LBB755_6:                              // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB755_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x21, x8
	b.hs	.LBB755_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB755_10
.LBB755_9:                              // %B19
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB755_10:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB755_13
// %bb.11:                              // %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB755_6
	b.vs	.LBB755_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB755_9
	b	.LBB755_6
.LBB755_13:                             // %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	.LSlowToBoolean_asm_h
.Lfunc_end755:
	.size	.Lif_true8_2_asm_h, .Lfunc_end755-.Lif_true8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function goto8_2_asm_h
	.type	.Lgoto8_2_asm_h,@function
.Lgoto8_2_asm_h:                        // @goto8_2_asm_h
// %bb.0:                               // %B0
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end756:
	.size	.Lgoto8_2_asm_h, .Lfunc_end756-.Lgoto8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function goto16_2_asm_h
	.type	.Lgoto16_2_asm_h,@function
.Lgoto16_2_asm_h:                       // @goto16_2_asm_h
// %bb.0:                               // %B0
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end757:
	.size	.Lgoto16_2_asm_h, .Lfunc_end757-.Lgoto16_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call0_2_asm_h
	.type	.Lcall0_2_asm_h,@function
.Lcall0_2_asm_h:                        // @call0_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcall0_0_asm_h
.Lfunc_end758:
	.size	.Lcall0_2_asm_h, .Lfunc_end758-.Lcall0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call1_2_asm_h
	.type	.Lcall1_2_asm_h,@function
.Lcall1_2_asm_h:                        // @call1_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcall1_0_asm_h
.Lfunc_end759:
	.size	.Lcall1_2_asm_h, .Lfunc_end759-.Lcall1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call2_2_asm_h
	.type	.Lcall2_2_asm_h,@function
.Lcall2_2_asm_h:                        // @call2_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcall2_0_asm_h
.Lfunc_end760:
	.size	.Lcall2_2_asm_h, .Lfunc_end760-.Lcall2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call3_2_asm_h
	.type	.Lcall3_2_asm_h,@function
.Lcall3_2_asm_h:                        // @call3_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcall3_0_asm_h
.Lfunc_end761:
	.size	.Lcall3_2_asm_h, .Lfunc_end761-.Lcall3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_undefined_2_asm_h
	.type	.Lis_undefined_2_asm_h,@function
.Lis_undefined_2_asm_h:                 // @is_undefined_2_asm_h
// %bb.0:                               // %B2
	cmp	x21, #18
	b.ne	.LBB762_2
// %bb.1:                               // %B3
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB762_2:                              // %B5
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end762:
	.size	.Lis_undefined_2_asm_h, .Lfunc_end762-.Lis_undefined_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_null_2_asm_h
	.type	.Lis_null_2_asm_h,@function
.Lis_null_2_asm_h:                      // @is_null_2_asm_h
// %bb.0:                               // %B2
	cmp	x21, #2
	b.ne	.LBB763_2
// %bb.1:                               // %B3
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB763_2:                              // %B5
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end763:
	.size	.Lis_null_2_asm_h, .Lfunc_end763-.Lis_null_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_function_2_asm_h
	.type	.Lis_function_2_asm_h,@function
.Lis_function_2_asm_h:                  // @is_function_2_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x21
	bl	js_operator_typeof_gc
	cmp	w0, #27
	b.ne	.LBB764_2
// %bb.1:                               // %B2
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB764_2:                              // %B5
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end764:
	.size	.Lis_function_2_asm_h, .Lfunc_end764-.Lis_function_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_coverage_2_asm_h
	.type	.Linc_coverage_2_asm_h,@function
.Linc_coverage_2_asm_h:                 // @inc_coverage_2_asm_h
// %bb.0:                               // %B10
	ldr	x8, [x23, #8]
	ldr	x1, [x8, #32]
	ldr	x8, [x1, #112]
	cbz	x8, .LBB765_3
// %bb.1:                               // %B7
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbnz	x8, .LBB765_4
.LBB765_2:                              // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB765_3:                              // %B11
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	EnsureCoverageCounters
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbz	x8, .LBB765_2
.LBB765_4:                              // %B2
	ldr	w9, [x19]
	ldr	w10, [x10, #104]
	cmp	w9, w10
	b.hs	.LBB765_2
// %bb.5:                               // %B6
	ldr	w10, [x8, w9, sxtw #2]
	add	w10, w10, #1
	str	w10, [x8, w9, sxtw #2]
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #494
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end765:
	.size	.Linc_coverage_2_asm_h, .Lfunc_end765-.Linc_coverage_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_global_ref_undef_2_asm_h
	.type	.Lget_global_ref_undef_2_asm_h,@function
.Lget_global_ref_undef_2_asm_h:         // @get_global_ref_undef_2_asm_h
// %bb.0:                               // %B6
	str	x22, [x20], #8
	ldr	x8, [x23, #8]
	ldrh	w9, [x19]
	ldr	x8, [x8, #40]
	ldr	x8, [x8, x9, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB766_2
.LBB766_1:                              // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB766_2:                              // %B1
	ldr	x1, [x23, #8]
	ldrh	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetGlobalRef_GC
	cmp	x0, #130
	mov	x8, x0
	b.ne	.LBB766_1
// %bb.3:                               // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end766:
	.size	.Lget_global_ref_undef_2_asm_h, .Lfunc_end766-.Lget_global_ref_undef_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_global_ref_2_asm_h
	.type	.Lget_global_ref_2_asm_h,@function
.Lget_global_ref_2_asm_h:               // @get_global_ref_2_asm_h
// %bb.0:                               // %B6
	str	x22, [x20], #8
	ldr	x8, [x23, #8]
	ldrh	w9, [x19]
	ldr	x8, [x8, #40]
	ldr	x8, [x8, x9, lsl #3]
	ldr	x8, [x8]
	and	x8, x8, #0xfffffffffffffffc
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB767_2
.LBB767_1:                              // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #494
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB767_2:                              // %B1
	ldr	x1, [x23, #8]
	ldrh	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetGlobalRef_GC
	cmp	x0, #130
	mov	x8, x0
	b.ne	.LBB767_1
// %bb.3:                               // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end767:
	.size	.Lget_global_ref_2_asm_h, .Lfunc_end767-.Lget_global_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_global_ref_2_asm_h
	.type	.Lput_global_ref_2_asm_h,@function
.Lput_global_ref_2_asm_h:               // @put_global_ref_2_asm_h
// %bb.0:                               // %B10
	ldr	x8, [x23, #8]
	ldrh	w9, [x19]
	ldr	x8, [x8, #40]
	ldr	x8, [x8, x9, lsl #3]
	ldr	x9, [x8]
	and	x8, x9, #0xfffffffffffffffc
	and	w9, w9, #0x2
	ldr	x10, [x8]
	cmp	x10, #34
	ccmp	w9, #0, #0, ne
	b.ne	.LBB768_3
// %bb.1:                               // %B1
	str	x21, [x8]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB768_5
.LBB768_2:                              // %B4
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB768_3:                              // %B7
	ldr	x1, [x23, #8]
	ldrh	w2, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x3, x21
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_SetGlobalRef_GC
	tbz	w0, #31, .LBB768_2
// %bb.4:                               // %B8
	b	.Lexception_spill_top0_top1_asm_h
.LBB768_5:                              // %B6
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end768:
	.size	.Lput_global_ref_2_asm_h, .Lfunc_end768-.Lput_global_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_global_ref_init_2_asm_h
	.type	.Lput_global_ref_init_2_asm_h,@function
.Lput_global_ref_init_2_asm_h:          // @put_global_ref_init_2_asm_h
// %bb.0:                               // %B1
	ldr	x1, [x23, #8]
	ldrh	w2, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x3, x21
	mov	w4, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_SetGlobalRef_GC
	tbnz	w0, #31, .LBB769_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #247
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB769_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end769:
	.size	.Lput_global_ref_init_2_asm_h, .Lfunc_end769-.Lput_global_ref_init_2_asm_h
                                        // -- End function
	.hidden	_call_stub_entry                // -- Begin function _call_stub_entry
	.globl	_call_stub_entry
	.p2align	2
	.type	_call_stub_entry,@function
_call_stub_entry:                       // @_call_stub_entry
	.cfi_startproc
// %bb.0:                               // %B0
	stp	x28, x27, [sp, #-96]!           // 16-byte Folded Spill
	stp	x26, x25, [sp, #16]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #32]             // 16-byte Folded Spill
	stp	x22, x21, [sp, #48]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #64]             // 16-byte Folded Spill
	stp	x29, x30, [sp, #80]             // 16-byte Folded Spill
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	ldp	x25, x8, [x3]
	mov	w19, w6
	mov	x20, x5
	mov	x21, x0
	mov	w0, w4
	mov	x22, x2
	mov	x27, x1
	mov	x24, x3
	ldr	x23, [x8, #256]
	bl	.Lcommon_call_from_entry_asm_h
	ldp	x29, x30, [sp, #80]             // 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             // 16-byte Folded Reload
	ldp	x22, x21, [sp, #48]             // 16-byte Folded Reload
	ldp	x24, x23, [sp, #32]             // 16-byte Folded Reload
	ldp	x26, x25, [sp, #16]             // 16-byte Folded Reload
	ldp	x28, x27, [sp], #96             // 16-byte Folded Reload
	ret
.Lfunc_end770:
	.size	_call_stub_entry, .Lfunc_end770-_call_stub_entry
	.cfi_endproc
                                        // -- End function
	.type	.L__unnamed_1,@object           // @0
	.section	.rodata,"a",@progbits
	.p2align	3, 0x0
.L__unnamed_1:
	.asciz	"'this' can be initialized only once"
	.size	.L__unnamed_1, 36

	.type	.L__unnamed_2,@object           // @1
	.p2align	3, 0x0
.L__unnamed_2:
	.asciz	"invalid opcode: pc=%u opcode=0x%02x"
	.size	.L__unnamed_2, 36

	.type	.L__unnamed_3,@object           // @2
	.p2align	3, 0x0
.L__unnamed_3:
	.asciz	"derived class constructor must return an object or undefined"
	.size	.L__unnamed_3, 61

	.type	.L__unnamed_4,@object           // @3
	.p2align	3, 0x0
.L__unnamed_4:
	.asciz	"class constructors must be invoked with 'new'"
	.size	.L__unnamed_4, 46

	.type	.L__unnamed_6,@object           // @4
	.p2align	3, 0x0
.L__unnamed_6:
	.asciz	"unsupported reference to 'super'"
	.size	.L__unnamed_6, 33

	.type	.L__unnamed_5,@object           // @5
	.p2align	3, 0x0
.L__unnamed_5:
	.asciz	"iterator does not have a throw method"
	.size	.L__unnamed_5, 38

	.type	.L__unnamed_7,@object           // @6
	.p2align	3, 0x0
.L__unnamed_7:
	.asciz	"invalid throw var type %d"
	.size	.L__unnamed_7, 26

	.type	.L__unnamed_8,@object           // @7
	.p2align	3, 0x0
.L__unnamed_8:
	.asciz	"invalid ret value"
	.size	.L__unnamed_8, 18

	.type	.L__unnamed_9,@object           // @8
	.p2align	3, 0x0
.L__unnamed_9:
	.asciz	"value has no property"
	.size	.L__unnamed_9, 22

	.type	.L__unnamed_10,@object          // @9
	.p2align	3, 0x0
.L__unnamed_10:
	.asciz	"iterator_close_return"
	.size	.L__unnamed_10, 22

	.type	.L__unnamed_11,@object          // @10
	.p2align	3, 0x0
.L__unnamed_11:
	.asciz	"invalid opcode: pc=%u opcode=0x%02x"
	.size	.L__unnamed_11, 36

	.type	.L__unnamed_12,@object          // @11
	.p2align	3, 0x0
.L__unnamed_12:
	.asciz	"derived class constructor must return an object or undefined"
	.size	.L__unnamed_12, 61

	.type	.L__unnamed_13,@object          // @12
	.p2align	3, 0x0
.L__unnamed_13:
	.asciz	"class constructors must be invoked with 'new'"
	.size	.L__unnamed_13, 46

	.type	.L__unnamed_14,@object          // @13
	.p2align	3, 0x0
.L__unnamed_14:
	.asciz	"invalid ret value"
	.size	.L__unnamed_14, 18

	.type	.L__unnamed_15,@object          // @14
	.p2align	3, 0x0
.L__unnamed_15:
	.asciz	"value has no property"
	.size	.L__unnamed_15, 22

	.type	.L__unnamed_16,@object          // @15
	.p2align	3, 0x0
.L__unnamed_16:
	.asciz	"invalid opcode: pc=%u opcode=0x%02x"
	.size	.L__unnamed_16, 36

	.type	.L__unnamed_17,@object          // @16
	.p2align	3, 0x0
.L__unnamed_17:
	.asciz	"derived class constructor must return an object or undefined"
	.size	.L__unnamed_17, 61

	.type	.L__unnamed_18,@object          // @17
	.p2align	3, 0x0
.L__unnamed_18:
	.asciz	"class constructors must be invoked with 'new'"
	.size	.L__unnamed_18, 46

	.type	.L__unnamed_19,@object          // @18
	.p2align	3, 0x0
.L__unnamed_19:
	.asciz	"invalid ret value"
	.size	.L__unnamed_19, 18

	.type	.L__unnamed_20,@object          // @19
	.p2align	3, 0x0
.L__unnamed_20:
	.asciz	"value has no property"
	.size	.L__unnamed_20, 22

	.hidden	primjs_dispatch_table           // @primjs_dispatch_table
	.type	primjs_dispatch_table,@object
	.section	.data.rel.ro,"aw",@progbits
	.globl	primjs_dispatch_table
	.p2align	3, 0x0
primjs_dispatch_table:
	.xword	.Linvalid_0_asm_h
	.xword	.Lpush_i32_0_asm_h
	.xword	.Lpush_const_0_asm_h
	.xword	.Lfclosure_0_asm_h
	.xword	.Lpush_atom_value_0_asm_h
	.xword	.Lprivate_symbol_0_asm_h
	.xword	.Lundefined_0_asm_h
	.xword	.Lnull_0_asm_h
	.xword	.Lpush_this_0_asm_h
	.xword	.Lpush_false_0_asm_h
	.xword	.Lpush_true_0_asm_h
	.xword	.Lobject_0_asm_h
	.xword	.Lspecial_object_0_asm_h
	.xword	.Lrest_0_asm_h
	.xword	.Ldrop_0_asm_h
	.xword	.Lnip_0_asm_h
	.xword	.Lnip1_0_asm_h
	.xword	.Ldup_0_asm_h
	.xword	.Ldup1_0_asm_h
	.xword	.Ldup2_0_asm_h
	.xword	.Ldup3_0_asm_h
	.xword	.Linsert2_0_asm_h
	.xword	.Linsert3_0_asm_h
	.xword	.Linsert4_0_asm_h
	.xword	.Lperm3_0_asm_h
	.xword	.Lperm4_0_asm_h
	.xword	.Lperm5_0_asm_h
	.xword	.Lswap_0_asm_h
	.xword	.Lswap2_0_asm_h
	.xword	.Lrot3l_0_asm_h
	.xword	.Lrot3r_0_asm_h
	.xword	.Lrot4l_0_asm_h
	.xword	.Lrot5l_0_asm_h
	.xword	.Lcall_constructor_0_asm_h
	.xword	.Lcall_0_asm_h
	.xword	.Ltail_call_0_asm_h
	.xword	.Lcall_method_0_asm_h
	.xword	.Ltail_call_method_0_asm_h
	.xword	.Larray_from_0_asm_h
	.xword	.Lapply_0_asm_h
	.xword	.Lreturn_0_asm_h
	.xword	.Lreturn_undef_0_asm_h
	.xword	.Lcheck_ctor_return_0_asm_h
	.xword	.Lcheck_ctor_0_asm_h
	.xword	.Lcheck_brand_0_asm_h
	.xword	.Ladd_brand_0_asm_h
	.xword	.Lreturn_async_0_asm_h
	.xword	.Lthrow_0_asm_h
	.xword	.Lthrow_var_0_asm_h
	.xword	.Leval_0_asm_h
	.xword	.Lregexp_0_asm_h
	.xword	.Lget_super_ctor_0_asm_h
	.xword	.Lget_super_0_asm_h
	.xword	.Limport_0_asm_h
	.xword	.Lcheck_var_0_asm_h
	.xword	.Lget_var_undef_0_asm_h
	.xword	.Lget_var_0_asm_h
	.xword	.Lput_var_0_asm_h
	.xword	.Lput_var_init_0_asm_h
	.xword	.Lput_var_strict_0_asm_h
	.xword	.Lget_ref_value_0_asm_h
	.xword	.Lput_ref_value_0_asm_h
	.xword	.Ldefine_var_0_asm_h
	.xword	.Lcheck_define_var_0_asm_h
	.xword	.Ldefine_func_0_asm_h
	.xword	.Lget_field_0_asm_h
	.xword	.Lget_field2_0_asm_h
	.xword	.Lput_field_0_asm_h
	.xword	.Lget_private_field_0_asm_h
	.xword	.Lput_private_field_0_asm_h
	.xword	.Ldefine_private_field_0_asm_h
	.xword	.Lget_array_el_0_asm_h
	.xword	.Lget_array_el2_0_asm_h
	.xword	.Lput_array_el_0_asm_h
	.xword	.Lget_super_value_0_asm_h
	.xword	.Lput_super_value_0_asm_h
	.xword	.Ldefine_field_0_asm_h
	.xword	.Lset_name_0_asm_h
	.xword	.Lset_name_computed_0_asm_h
	.xword	.Lset_proto_0_asm_h
	.xword	.Lset_home_object_0_asm_h
	.xword	.Ldefine_array_el_0_asm_h
	.xword	.Lappend_0_asm_h
	.xword	.Lcopy_data_properties_0_asm_h
	.xword	.Ldefine_method_0_asm_h
	.xword	.Ldefine_method_computed_0_asm_h
	.xword	.Ldefine_class_0_asm_h
	.xword	.Lget_loc_0_asm_h
	.xword	.Lput_loc_0_asm_h
	.xword	.Lset_loc_0_asm_h
	.xword	.Lget_arg_0_asm_h
	.xword	.Lput_arg_0_asm_h
	.xword	.Lset_arg_0_asm_h
	.xword	.Lget_var_ref_0_asm_h
	.xword	.Lput_var_ref_0_asm_h
	.xword	.Lset_var_ref_0_asm_h
	.xword	.Lset_loc_uninitialized_0_asm_h
	.xword	.Lget_loc_check_0_asm_h
	.xword	.Lput_loc_check_0_asm_h
	.xword	.Lput_loc_check_init_0_asm_h
	.xword	.Lget_var_ref_check_0_asm_h
	.xword	.Lput_var_ref_check_0_asm_h
	.xword	.Lput_var_ref_check_init_0_asm_h
	.xword	.Lclose_loc_0_asm_h
	.xword	.Lif_false_0_asm_h
	.xword	.Lif_true_0_asm_h
	.xword	.Lgoto_0_asm_h
	.xword	.Lcatch_0_asm_h
	.xword	.Lgosub_0_asm_h
	.xword	.Lret_0_asm_h
	.xword	.Lto_object_0_asm_h
	.xword	.Lto_propkey_0_asm_h
	.xword	.Lto_propkey2_0_asm_h
	.xword	.Lwith_get_var_0_asm_h
	.xword	.Lwith_put_var_0_asm_h
	.xword	.Lwith_delete_var_0_asm_h
	.xword	.Lwith_make_ref_0_asm_h
	.xword	.Lwith_get_ref_0_asm_h
	.xword	.Lwith_get_ref_undef_0_asm_h
	.xword	.Lmake_loc_ref_0_asm_h
	.xword	.Lmake_arg_ref_0_asm_h
	.xword	.Lmake_var_ref_ref_0_asm_h
	.xword	.Lmake_var_ref_0_asm_h
	.xword	.Lfor_in_start_0_asm_h
	.xword	.Lfor_of_start_0_asm_h
	.xword	.Lfor_await_of_start_0_asm_h
	.xword	.Lfor_in_next_0_asm_h
	.xword	.Lfor_of_next_0_asm_h
	.xword	.Lfor_await_of_next_0_asm_h
	.xword	.Literator_get_value_done_0_asm_h
	.xword	.Literator_close_0_asm_h
	.xword	.Literator_close_return_0_asm_h
	.xword	.Lasync_iterator_close_0_asm_h
	.xword	.Lasync_iterator_next_0_asm_h
	.xword	.Lasync_iterator_get_0_asm_h
	.xword	.Linitial_yield_0_asm_h
	.xword	.Lyield_0_asm_h
	.xword	.Lyield_star_0_asm_h
	.xword	.Lasync_yield_star_0_asm_h
	.xword	.Lawait_0_asm_h
	.xword	.Lneg_0_asm_h
	.xword	.Lplus_0_asm_h
	.xword	.Ldec_0_asm_h
	.xword	.Linc_0_asm_h
	.xword	.Lpost_dec_0_asm_h
	.xword	.Lpost_inc_0_asm_h
	.xword	.Ldec_loc_0_asm_h
	.xword	.Linc_loc_0_asm_h
	.xword	.Ladd_loc_0_asm_h
	.xword	.Lnot_0_asm_h
	.xword	.Llnot_0_asm_h
	.xword	.Ltypeof_0_asm_h
	.xword	.Ldelete_0_asm_h
	.xword	.Ldelete_var_0_asm_h
	.xword	.Lmul_0_asm_h
	.xword	.Ldiv_0_asm_h
	.xword	.Lmod_0_asm_h
	.xword	.Ladd_0_asm_h
	.xword	.Lsub_0_asm_h
	.xword	.Lpow_0_asm_h
	.xword	.Lshl_0_asm_h
	.xword	.Lsar_0_asm_h
	.xword	.Lshr_0_asm_h
	.xword	.Llt_0_asm_h
	.xword	.Llte_0_asm_h
	.xword	.Lgt_0_asm_h
	.xword	.Lgte_0_asm_h
	.xword	.Linstanceof_0_asm_h
	.xword	.Lin_0_asm_h
	.xword	.Leq_0_asm_h
	.xword	.Lneq_0_asm_h
	.xword	.Lstrict_eq_0_asm_h
	.xword	.Lstrict_neq_0_asm_h
	.xword	.Land_0_asm_h
	.xword	.Lxor_0_asm_h
	.xword	.Lor_0_asm_h
	.xword	.Lnop_0_asm_h
	.xword	.Lpush_minus1_0_asm_h
	.xword	.Lpush_0_0_asm_h
	.xword	.Lpush_1_0_asm_h
	.xword	.Lpush_2_0_asm_h
	.xword	.Lpush_3_0_asm_h
	.xword	.Lpush_4_0_asm_h
	.xword	.Lpush_5_0_asm_h
	.xword	.Lpush_6_0_asm_h
	.xword	.Lpush_7_0_asm_h
	.xword	.Lpush_i8_0_asm_h
	.xword	.Lpush_i16_0_asm_h
	.xword	.Lpush_const8_0_asm_h
	.xword	.Lfclosure8_0_asm_h
	.xword	.Lpush_empty_string_0_asm_h
	.xword	.Lget_loc8_0_asm_h
	.xword	.Lput_loc8_0_asm_h
	.xword	.Lset_loc8_0_asm_h
	.xword	.Lget_loc0_0_asm_h
	.xword	.Lget_loc1_0_asm_h
	.xword	.Lget_loc2_0_asm_h
	.xword	.Lget_loc3_0_asm_h
	.xword	.Lput_loc0_0_asm_h
	.xword	.Lput_loc1_0_asm_h
	.xword	.Lput_loc2_0_asm_h
	.xword	.Lput_loc3_0_asm_h
	.xword	.Lset_loc0_0_asm_h
	.xword	.Lset_loc1_0_asm_h
	.xword	.Lset_loc2_0_asm_h
	.xword	.Lset_loc3_0_asm_h
	.xword	.Lget_arg0_0_asm_h
	.xword	.Lget_arg1_0_asm_h
	.xword	.Lget_arg2_0_asm_h
	.xword	.Lget_arg3_0_asm_h
	.xword	.Lput_arg0_0_asm_h
	.xword	.Lput_arg1_0_asm_h
	.xword	.Lput_arg2_0_asm_h
	.xword	.Lput_arg3_0_asm_h
	.xword	.Lset_arg0_0_asm_h
	.xword	.Lset_arg1_0_asm_h
	.xword	.Lset_arg2_0_asm_h
	.xword	.Lset_arg3_0_asm_h
	.xword	.Lget_var_ref0_0_asm_h
	.xword	.Lget_var_ref1_0_asm_h
	.xword	.Lget_var_ref2_0_asm_h
	.xword	.Lget_var_ref3_0_asm_h
	.xword	.Lput_var_ref0_0_asm_h
	.xword	.Lput_var_ref1_0_asm_h
	.xword	.Lput_var_ref2_0_asm_h
	.xword	.Lput_var_ref3_0_asm_h
	.xword	.Lset_var_ref0_0_asm_h
	.xword	.Lset_var_ref1_0_asm_h
	.xword	.Lset_var_ref2_0_asm_h
	.xword	.Lset_var_ref3_0_asm_h
	.xword	.Lget_length_0_asm_h
	.xword	.Lif_false8_0_asm_h
	.xword	.Lif_true8_0_asm_h
	.xword	.Lgoto8_0_asm_h
	.xword	.Lgoto16_0_asm_h
	.xword	.Lcall0_0_asm_h
	.xword	.Lcall1_0_asm_h
	.xword	.Lcall2_0_asm_h
	.xword	.Lcall3_0_asm_h
	.xword	.Lis_undefined_0_asm_h
	.xword	.Lis_null_0_asm_h
	.xword	.Lis_function_0_asm_h
	.xword	.Linc_coverage_0_asm_h
	.xword	.Lget_global_ref_undef_0_asm_h
	.xword	.Lget_global_ref_0_asm_h
	.xword	.Lput_global_ref_0_asm_h
	.xword	.Lput_global_ref_init_0_asm_h
	.xword	.Linvalid_1_asm_h
	.xword	.Lpush_i32_1_asm_h
	.xword	.Lpush_const_1_asm_h
	.xword	.Lfclosure_1_asm_h
	.xword	.Lpush_atom_value_1_asm_h
	.xword	.Lprivate_symbol_1_asm_h
	.xword	.Lundefined_1_asm_h
	.xword	.Lnull_1_asm_h
	.xword	.Lpush_this_1_asm_h
	.xword	.Lpush_false_1_asm_h
	.xword	.Lpush_true_1_asm_h
	.xword	.Lobject_1_asm_h
	.xword	.Lspecial_object_1_asm_h
	.xword	.Lrest_1_asm_h
	.xword	.Ldrop_1_asm_h
	.xword	.Lnip_1_asm_h
	.xword	.Lnip1_1_asm_h
	.xword	.Ldup_1_asm_h
	.xword	.Ldup1_1_asm_h
	.xword	.Ldup2_1_asm_h
	.xword	.Ldup3_1_asm_h
	.xword	.Linsert2_1_asm_h
	.xword	.Linsert3_1_asm_h
	.xword	.Linsert4_1_asm_h
	.xword	.Lperm3_1_asm_h
	.xword	.Lperm4_1_asm_h
	.xword	.Lperm5_1_asm_h
	.xword	.Lswap_1_asm_h
	.xword	.Lswap2_1_asm_h
	.xword	.Lrot3l_1_asm_h
	.xword	.Lrot3r_1_asm_h
	.xword	.Lrot4l_1_asm_h
	.xword	.Lrot5l_1_asm_h
	.xword	.Lcall_constructor_1_asm_h
	.xword	.Lcall_1_asm_h
	.xword	.Ltail_call_1_asm_h
	.xword	.Lcall_method_1_asm_h
	.xword	.Ltail_call_method_1_asm_h
	.xword	.Larray_from_1_asm_h
	.xword	.Lapply_1_asm_h
	.xword	.Lreturn_1_asm_h
	.xword	.Lreturn_undef_1_asm_h
	.xword	.Lcheck_ctor_return_1_asm_h
	.xword	.Lcheck_ctor_1_asm_h
	.xword	.Lcheck_brand_1_asm_h
	.xword	.Ladd_brand_1_asm_h
	.xword	.Lreturn_async_1_asm_h
	.xword	.Lthrow_1_asm_h
	.xword	.Lthrow_var_1_asm_h
	.xword	.Leval_1_asm_h
	.xword	.Lregexp_1_asm_h
	.xword	.Lget_super_ctor_1_asm_h
	.xword	.Lget_super_1_asm_h
	.xword	.Limport_1_asm_h
	.xword	.Lcheck_var_1_asm_h
	.xword	.Lget_var_undef_1_asm_h
	.xword	.Lget_var_1_asm_h
	.xword	.Lput_var_1_asm_h
	.xword	.Lput_var_init_1_asm_h
	.xword	.Lput_var_strict_1_asm_h
	.xword	.Lget_ref_value_1_asm_h
	.xword	.Lput_ref_value_1_asm_h
	.xword	.Ldefine_var_1_asm_h
	.xword	.Lcheck_define_var_1_asm_h
	.xword	.Ldefine_func_1_asm_h
	.xword	.Lget_field_1_asm_h
	.xword	.Lget_field2_1_asm_h
	.xword	.Lput_field_1_asm_h
	.xword	.Lget_private_field_1_asm_h
	.xword	.Lput_private_field_1_asm_h
	.xword	.Ldefine_private_field_1_asm_h
	.xword	.Lget_array_el_1_asm_h
	.xword	.Lget_array_el2_1_asm_h
	.xword	.Lput_array_el_1_asm_h
	.xword	.Lget_super_value_1_asm_h
	.xword	.Lput_super_value_1_asm_h
	.xword	.Ldefine_field_1_asm_h
	.xword	.Lset_name_1_asm_h
	.xword	.Lset_name_computed_1_asm_h
	.xword	.Lset_proto_1_asm_h
	.xword	.Lset_home_object_1_asm_h
	.xword	.Ldefine_array_el_1_asm_h
	.xword	.Lappend_1_asm_h
	.xword	.Lcopy_data_properties_1_asm_h
	.xword	.Ldefine_method_1_asm_h
	.xword	.Ldefine_method_computed_1_asm_h
	.xword	.Ldefine_class_1_asm_h
	.xword	.Lget_loc_1_asm_h
	.xword	.Lput_loc_1_asm_h
	.xword	.Lset_loc_1_asm_h
	.xword	.Lget_arg_1_asm_h
	.xword	.Lput_arg_1_asm_h
	.xword	.Lset_arg_1_asm_h
	.xword	.Lget_var_ref_1_asm_h
	.xword	.Lput_var_ref_1_asm_h
	.xword	.Lset_var_ref_1_asm_h
	.xword	.Lset_loc_uninitialized_1_asm_h
	.xword	.Lget_loc_check_1_asm_h
	.xword	.Lput_loc_check_1_asm_h
	.xword	.Lput_loc_check_init_1_asm_h
	.xword	.Lget_var_ref_check_1_asm_h
	.xword	.Lput_var_ref_check_1_asm_h
	.xword	.Lput_var_ref_check_init_1_asm_h
	.xword	.Lclose_loc_1_asm_h
	.xword	.Lif_false_1_asm_h
	.xword	.Lif_true_1_asm_h
	.xword	.Lgoto_1_asm_h
	.xword	.Lcatch_1_asm_h
	.xword	.Lgosub_1_asm_h
	.xword	.Lret_1_asm_h
	.xword	.Lto_object_1_asm_h
	.xword	.Lto_propkey_1_asm_h
	.xword	.Lto_propkey2_1_asm_h
	.xword	.Lwith_get_var_1_asm_h
	.xword	.Lwith_put_var_1_asm_h
	.xword	.Lwith_delete_var_1_asm_h
	.xword	.Lwith_make_ref_1_asm_h
	.xword	.Lwith_get_ref_1_asm_h
	.xword	.Lwith_get_ref_undef_1_asm_h
	.xword	.Lmake_loc_ref_1_asm_h
	.xword	.Lmake_arg_ref_1_asm_h
	.xword	.Lmake_var_ref_ref_1_asm_h
	.xword	.Lmake_var_ref_1_asm_h
	.xword	.Lfor_in_start_1_asm_h
	.xword	.Lfor_of_start_1_asm_h
	.xword	.Lfor_await_of_start_1_asm_h
	.xword	.Lfor_in_next_1_asm_h
	.xword	.Lfor_of_next_1_asm_h
	.xword	.Lfor_await_of_next_1_asm_h
	.xword	.Literator_get_value_done_1_asm_h
	.xword	.Literator_close_1_asm_h
	.xword	.Literator_close_return_1_asm_h
	.xword	.Lasync_iterator_close_1_asm_h
	.xword	.Lasync_iterator_next_1_asm_h
	.xword	.Lasync_iterator_get_1_asm_h
	.xword	.Linitial_yield_1_asm_h
	.xword	.Lyield_1_asm_h
	.xword	.Lyield_star_1_asm_h
	.xword	.Lasync_yield_star_1_asm_h
	.xword	.Lawait_1_asm_h
	.xword	.Lneg_1_asm_h
	.xword	.Lplus_1_asm_h
	.xword	.Ldec_1_asm_h
	.xword	.Linc_1_asm_h
	.xword	.Lpost_dec_1_asm_h
	.xword	.Lpost_inc_1_asm_h
	.xword	.Ldec_loc_1_asm_h
	.xword	.Linc_loc_1_asm_h
	.xword	.Ladd_loc_1_asm_h
	.xword	.Lnot_1_asm_h
	.xword	.Llnot_1_asm_h
	.xword	.Ltypeof_1_asm_h
	.xword	.Ldelete_1_asm_h
	.xword	.Ldelete_var_1_asm_h
	.xword	.Lmul_1_asm_h
	.xword	.Ldiv_1_asm_h
	.xword	.Lmod_1_asm_h
	.xword	.Ladd_1_asm_h
	.xword	.Lsub_1_asm_h
	.xword	.Lpow_1_asm_h
	.xword	.Lshl_1_asm_h
	.xword	.Lsar_1_asm_h
	.xword	.Lshr_1_asm_h
	.xword	.Llt_1_asm_h
	.xword	.Llte_1_asm_h
	.xword	.Lgt_1_asm_h
	.xword	.Lgte_1_asm_h
	.xword	.Linstanceof_1_asm_h
	.xword	.Lin_1_asm_h
	.xword	.Leq_1_asm_h
	.xword	.Lneq_1_asm_h
	.xword	.Lstrict_eq_1_asm_h
	.xword	.Lstrict_neq_1_asm_h
	.xword	.Land_1_asm_h
	.xword	.Lxor_1_asm_h
	.xword	.Lor_1_asm_h
	.xword	.Lnop_1_asm_h
	.xword	.Lpush_minus1_1_asm_h
	.xword	.Lpush_0_1_asm_h
	.xword	.Lpush_1_1_asm_h
	.xword	.Lpush_2_1_asm_h
	.xword	.Lpush_3_1_asm_h
	.xword	.Lpush_4_1_asm_h
	.xword	.Lpush_5_1_asm_h
	.xword	.Lpush_6_1_asm_h
	.xword	.Lpush_7_1_asm_h
	.xword	.Lpush_i8_1_asm_h
	.xword	.Lpush_i16_1_asm_h
	.xword	.Lpush_const8_1_asm_h
	.xword	.Lfclosure8_1_asm_h
	.xword	.Lpush_empty_string_1_asm_h
	.xword	.Lget_loc8_1_asm_h
	.xword	.Lput_loc8_1_asm_h
	.xword	.Lset_loc8_1_asm_h
	.xword	.Lget_loc0_1_asm_h
	.xword	.Lget_loc1_1_asm_h
	.xword	.Lget_loc2_1_asm_h
	.xword	.Lget_loc3_1_asm_h
	.xword	.Lput_loc0_1_asm_h
	.xword	.Lput_loc1_1_asm_h
	.xword	.Lput_loc2_1_asm_h
	.xword	.Lput_loc3_1_asm_h
	.xword	.Lset_loc0_1_asm_h
	.xword	.Lset_loc1_1_asm_h
	.xword	.Lset_loc2_1_asm_h
	.xword	.Lset_loc3_1_asm_h
	.xword	.Lget_arg0_1_asm_h
	.xword	.Lget_arg1_1_asm_h
	.xword	.Lget_arg2_1_asm_h
	.xword	.Lget_arg3_1_asm_h
	.xword	.Lput_arg0_1_asm_h
	.xword	.Lput_arg1_1_asm_h
	.xword	.Lput_arg2_1_asm_h
	.xword	.Lput_arg3_1_asm_h
	.xword	.Lset_arg0_1_asm_h
	.xword	.Lset_arg1_1_asm_h
	.xword	.Lset_arg2_1_asm_h
	.xword	.Lset_arg3_1_asm_h
	.xword	.Lget_var_ref0_1_asm_h
	.xword	.Lget_var_ref1_1_asm_h
	.xword	.Lget_var_ref2_1_asm_h
	.xword	.Lget_var_ref3_1_asm_h
	.xword	.Lput_var_ref0_1_asm_h
	.xword	.Lput_var_ref1_1_asm_h
	.xword	.Lput_var_ref2_1_asm_h
	.xword	.Lput_var_ref3_1_asm_h
	.xword	.Lset_var_ref0_1_asm_h
	.xword	.Lset_var_ref1_1_asm_h
	.xword	.Lset_var_ref2_1_asm_h
	.xword	.Lset_var_ref3_1_asm_h
	.xword	.Lget_length_1_asm_h
	.xword	.Lif_false8_1_asm_h
	.xword	.Lif_true8_1_asm_h
	.xword	.Lgoto8_1_asm_h
	.xword	.Lgoto16_1_asm_h
	.xword	.Lcall0_1_asm_h
	.xword	.Lcall1_1_asm_h
	.xword	.Lcall2_1_asm_h
	.xword	.Lcall3_1_asm_h
	.xword	.Lis_undefined_1_asm_h
	.xword	.Lis_null_1_asm_h
	.xword	.Lis_function_1_asm_h
	.xword	.Linc_coverage_1_asm_h
	.xword	.Lget_global_ref_undef_1_asm_h
	.xword	.Lget_global_ref_1_asm_h
	.xword	.Lput_global_ref_1_asm_h
	.xword	.Lput_global_ref_init_1_asm_h
	.xword	.Linvalid_2_asm_h
	.xword	.Lpush_i32_2_asm_h
	.xword	.Lpush_const_2_asm_h
	.xword	.Lfclosure_2_asm_h
	.xword	.Lpush_atom_value_2_asm_h
	.xword	.Lprivate_symbol_2_asm_h
	.xword	.Lundefined_2_asm_h
	.xword	.Lnull_2_asm_h
	.xword	.Lpush_this_2_asm_h
	.xword	.Lpush_false_2_asm_h
	.xword	.Lpush_true_2_asm_h
	.xword	.Lobject_2_asm_h
	.xword	.Lspecial_object_2_asm_h
	.xword	.Lrest_2_asm_h
	.xword	.Ldrop_2_asm_h
	.xword	.Lnip_2_asm_h
	.xword	.Lnip1_2_asm_h
	.xword	.Ldup_2_asm_h
	.xword	.Ldup1_2_asm_h
	.xword	.Ldup2_2_asm_h
	.xword	.Ldup3_2_asm_h
	.xword	.Linsert2_2_asm_h
	.xword	.Linsert3_2_asm_h
	.xword	.Linsert4_2_asm_h
	.xword	.Lperm3_2_asm_h
	.xword	.Lperm4_2_asm_h
	.xword	.Lperm5_2_asm_h
	.xword	.Lswap_2_asm_h
	.xword	.Lswap2_2_asm_h
	.xword	.Lrot3l_2_asm_h
	.xword	.Lrot3r_2_asm_h
	.xword	.Lrot4l_2_asm_h
	.xword	.Lrot5l_2_asm_h
	.xword	.Lcall_constructor_2_asm_h
	.xword	.Lcall_2_asm_h
	.xword	.Ltail_call_2_asm_h
	.xword	.Lcall_method_2_asm_h
	.xword	.Ltail_call_method_2_asm_h
	.xword	.Larray_from_2_asm_h
	.xword	.Lapply_2_asm_h
	.xword	.Lreturn_2_asm_h
	.xword	.Lreturn_undef_2_asm_h
	.xword	.Lcheck_ctor_return_2_asm_h
	.xword	.Lcheck_ctor_2_asm_h
	.xword	.Lcheck_brand_2_asm_h
	.xword	.Ladd_brand_2_asm_h
	.xword	.Lreturn_async_2_asm_h
	.xword	.Lthrow_2_asm_h
	.xword	.Lthrow_var_2_asm_h
	.xword	.Leval_2_asm_h
	.xword	.Lregexp_2_asm_h
	.xword	.Lget_super_ctor_2_asm_h
	.xword	.Lget_super_2_asm_h
	.xword	.Limport_2_asm_h
	.xword	.Lcheck_var_2_asm_h
	.xword	.Lget_var_undef_2_asm_h
	.xword	.Lget_var_2_asm_h
	.xword	.Lput_var_2_asm_h
	.xword	.Lput_var_init_2_asm_h
	.xword	.Lput_var_strict_2_asm_h
	.xword	.Lget_ref_value_2_asm_h
	.xword	.Lput_ref_value_2_asm_h
	.xword	.Ldefine_var_2_asm_h
	.xword	.Lcheck_define_var_2_asm_h
	.xword	.Ldefine_func_2_asm_h
	.xword	.Lget_field_2_asm_h
	.xword	.Lget_field2_2_asm_h
	.xword	.Lput_field_2_asm_h
	.xword	.Lget_private_field_2_asm_h
	.xword	.Lput_private_field_2_asm_h
	.xword	.Ldefine_private_field_2_asm_h
	.xword	.Lget_array_el_2_asm_h
	.xword	.Lget_array_el2_2_asm_h
	.xword	.Lput_array_el_2_asm_h
	.xword	.Lget_super_value_2_asm_h
	.xword	.Lput_super_value_2_asm_h
	.xword	.Ldefine_field_2_asm_h
	.xword	.Lset_name_2_asm_h
	.xword	.Lset_name_computed_2_asm_h
	.xword	.Lset_proto_2_asm_h
	.xword	.Lset_home_object_2_asm_h
	.xword	.Ldefine_array_el_2_asm_h
	.xword	.Lappend_2_asm_h
	.xword	.Lcopy_data_properties_2_asm_h
	.xword	.Ldefine_method_2_asm_h
	.xword	.Ldefine_method_computed_2_asm_h
	.xword	.Ldefine_class_2_asm_h
	.xword	.Lget_loc_2_asm_h
	.xword	.Lput_loc_2_asm_h
	.xword	.Lset_loc_2_asm_h
	.xword	.Lget_arg_2_asm_h
	.xword	.Lput_arg_2_asm_h
	.xword	.Lset_arg_2_asm_h
	.xword	.Lget_var_ref_2_asm_h
	.xword	.Lput_var_ref_2_asm_h
	.xword	.Lset_var_ref_2_asm_h
	.xword	.Lset_loc_uninitialized_2_asm_h
	.xword	.Lget_loc_check_2_asm_h
	.xword	.Lput_loc_check_2_asm_h
	.xword	.Lput_loc_check_init_2_asm_h
	.xword	.Lget_var_ref_check_2_asm_h
	.xword	.Lput_var_ref_check_2_asm_h
	.xword	.Lput_var_ref_check_init_2_asm_h
	.xword	.Lclose_loc_2_asm_h
	.xword	.Lif_false_2_asm_h
	.xword	.Lif_true_2_asm_h
	.xword	.Lgoto_2_asm_h
	.xword	.Lcatch_2_asm_h
	.xword	.Lgosub_2_asm_h
	.xword	.Lret_2_asm_h
	.xword	.Lto_object_2_asm_h
	.xword	.Lto_propkey_2_asm_h
	.xword	.Lto_propkey2_2_asm_h
	.xword	.Lwith_get_var_2_asm_h
	.xword	.Lwith_put_var_2_asm_h
	.xword	.Lwith_delete_var_2_asm_h
	.xword	.Lwith_make_ref_2_asm_h
	.xword	.Lwith_get_ref_2_asm_h
	.xword	.Lwith_get_ref_undef_2_asm_h
	.xword	.Lmake_loc_ref_2_asm_h
	.xword	.Lmake_arg_ref_2_asm_h
	.xword	.Lmake_var_ref_ref_2_asm_h
	.xword	.Lmake_var_ref_2_asm_h
	.xword	.Lfor_in_start_2_asm_h
	.xword	.Lfor_of_start_2_asm_h
	.xword	.Lfor_await_of_start_2_asm_h
	.xword	.Lfor_in_next_2_asm_h
	.xword	.Lfor_of_next_2_asm_h
	.xword	.Lfor_await_of_next_2_asm_h
	.xword	.Literator_get_value_done_2_asm_h
	.xword	.Literator_close_2_asm_h
	.xword	.Literator_close_return_2_asm_h
	.xword	.Lasync_iterator_close_2_asm_h
	.xword	.Lasync_iterator_next_2_asm_h
	.xword	.Lasync_iterator_get_2_asm_h
	.xword	.Linitial_yield_2_asm_h
	.xword	.Lyield_2_asm_h
	.xword	.Lyield_star_2_asm_h
	.xword	.Lasync_yield_star_2_asm_h
	.xword	.Lawait_2_asm_h
	.xword	.Lneg_2_asm_h
	.xword	.Lplus_2_asm_h
	.xword	.Ldec_2_asm_h
	.xword	.Linc_2_asm_h
	.xword	.Lpost_dec_2_asm_h
	.xword	.Lpost_inc_2_asm_h
	.xword	.Ldec_loc_2_asm_h
	.xword	.Linc_loc_2_asm_h
	.xword	.Ladd_loc_2_asm_h
	.xword	.Lnot_2_asm_h
	.xword	.Llnot_2_asm_h
	.xword	.Ltypeof_2_asm_h
	.xword	.Ldelete_2_asm_h
	.xword	.Ldelete_var_2_asm_h
	.xword	.Lmul_2_asm_h
	.xword	.Ldiv_2_asm_h
	.xword	.Lmod_2_asm_h
	.xword	.Ladd_2_asm_h
	.xword	.Lsub_2_asm_h
	.xword	.Lpow_2_asm_h
	.xword	.Lshl_2_asm_h
	.xword	.Lsar_2_asm_h
	.xword	.Lshr_2_asm_h
	.xword	.Llt_2_asm_h
	.xword	.Llte_2_asm_h
	.xword	.Lgt_2_asm_h
	.xword	.Lgte_2_asm_h
	.xword	.Linstanceof_2_asm_h
	.xword	.Lin_2_asm_h
	.xword	.Leq_2_asm_h
	.xword	.Lneq_2_asm_h
	.xword	.Lstrict_eq_2_asm_h
	.xword	.Lstrict_neq_2_asm_h
	.xword	.Land_2_asm_h
	.xword	.Lxor_2_asm_h
	.xword	.Lor_2_asm_h
	.xword	.Lnop_2_asm_h
	.xword	.Lpush_minus1_2_asm_h
	.xword	.Lpush_0_2_asm_h
	.xword	.Lpush_1_2_asm_h
	.xword	.Lpush_2_2_asm_h
	.xword	.Lpush_3_2_asm_h
	.xword	.Lpush_4_2_asm_h
	.xword	.Lpush_5_2_asm_h
	.xword	.Lpush_6_2_asm_h
	.xword	.Lpush_7_2_asm_h
	.xword	.Lpush_i8_2_asm_h
	.xword	.Lpush_i16_2_asm_h
	.xword	.Lpush_const8_2_asm_h
	.xword	.Lfclosure8_2_asm_h
	.xword	.Lpush_empty_string_2_asm_h
	.xword	.Lget_loc8_2_asm_h
	.xword	.Lput_loc8_2_asm_h
	.xword	.Lset_loc8_2_asm_h
	.xword	.Lget_loc0_2_asm_h
	.xword	.Lget_loc1_2_asm_h
	.xword	.Lget_loc2_2_asm_h
	.xword	.Lget_loc3_2_asm_h
	.xword	.Lput_loc0_2_asm_h
	.xword	.Lput_loc1_2_asm_h
	.xword	.Lput_loc2_2_asm_h
	.xword	.Lput_loc3_2_asm_h
	.xword	.Lset_loc0_2_asm_h
	.xword	.Lset_loc1_2_asm_h
	.xword	.Lset_loc2_2_asm_h
	.xword	.Lset_loc3_2_asm_h
	.xword	.Lget_arg0_2_asm_h
	.xword	.Lget_arg1_2_asm_h
	.xword	.Lget_arg2_2_asm_h
	.xword	.Lget_arg3_2_asm_h
	.xword	.Lput_arg0_2_asm_h
	.xword	.Lput_arg1_2_asm_h
	.xword	.Lput_arg2_2_asm_h
	.xword	.Lput_arg3_2_asm_h
	.xword	.Lset_arg0_2_asm_h
	.xword	.Lset_arg1_2_asm_h
	.xword	.Lset_arg2_2_asm_h
	.xword	.Lset_arg3_2_asm_h
	.xword	.Lget_var_ref0_2_asm_h
	.xword	.Lget_var_ref1_2_asm_h
	.xword	.Lget_var_ref2_2_asm_h
	.xword	.Lget_var_ref3_2_asm_h
	.xword	.Lput_var_ref0_2_asm_h
	.xword	.Lput_var_ref1_2_asm_h
	.xword	.Lput_var_ref2_2_asm_h
	.xword	.Lput_var_ref3_2_asm_h
	.xword	.Lset_var_ref0_2_asm_h
	.xword	.Lset_var_ref1_2_asm_h
	.xword	.Lset_var_ref2_2_asm_h
	.xword	.Lset_var_ref3_2_asm_h
	.xword	.Lget_length_2_asm_h
	.xword	.Lif_false8_2_asm_h
	.xword	.Lif_true8_2_asm_h
	.xword	.Lgoto8_2_asm_h
	.xword	.Lgoto16_2_asm_h
	.xword	.Lcall0_2_asm_h
	.xword	.Lcall1_2_asm_h
	.xword	.Lcall2_2_asm_h
	.xword	.Lcall3_2_asm_h
	.xword	.Lis_undefined_2_asm_h
	.xword	.Lis_null_2_asm_h
	.xword	.Lis_function_2_asm_h
	.xword	.Linc_coverage_2_asm_h
	.xword	.Lget_global_ref_undef_2_asm_h
	.xword	.Lget_global_ref_2_asm_h
	.xword	.Lput_global_ref_2_asm_h
	.xword	.Lput_global_ref_init_2_asm_h
	.size	primjs_dispatch_table, 5928

	.section	".note.GNU-stack","",@progbits
#endif
