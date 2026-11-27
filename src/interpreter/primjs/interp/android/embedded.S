#if defined(__aarch64__) && defined(ENABLE_PRIMJS_SNAPSHOT) && !defined(ENABLE_QUICKJS_DEBUGGER)
	.file	"primjs"
	.text
	.p2align	7                               // -- Begin function call_native_asm_h
	.type	.Lcall_native_asm_h,@function
.Lcall_native_asm_h:                    // @call_native_asm_h
	.cfi_startproc
// %bb.0:                               // %B29
	stp	x29, x30, [sp, #-16]!           // 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldr	x8, [x24, #8]
	ldrh	w9, [x22, #6]
	mov	w10, #40                        // =0x28
	mov	x3, x0
	ldr	x8, [x8, #80]
	cmp	w9, #12
	umaddl	x8, w9, w10, x8
	ldr	x8, [x8, #24]
	b.ne	.LBB0_26
// %bb.1:                               // %B12
	ldrb	w9, [x22, #40]
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
                                        // kill: def $w3 killed $w3 killed $x3
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
	ldrb	w10, [x9, #8]
	cmp	w3, w10
	b.lt	.LBB0_31
// %bb.28:                              // %B10
	ldr	x8, [x9]
	ldrh	w4, [x9, #10]
	add	x5, x9, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, w3
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
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	x4, x20
	mov	w5, wzr
                                        // kill: def $w3 killed $w3 killed $x3
	blr	x8
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	ret
.LBB0_32:                               // %B3
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	b	.LThrowTypeErrorNotFunction_Return_asm_h
.Lfunc_end0:
	.size	.Lcall_native_asm_h, .Lfunc_end0-.Lcall_native_asm_h
	.cfi_endproc
                                        // -- End function
	.p2align	2                               // -- Begin function common_call_from_entry_asm_h
	.type	.Lcommon_call_from_entry_asm_h,@function
.Lcommon_call_from_entry_asm_h:         // @common_call_from_entry_asm_h
// %bb.0:                               // %B40
	tbnz	w19, #2, .LBB1_9
// %bb.1:                               // %B34
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB1_11
// %bb.2:                               // %B36
	ldrh	w8, [x22, #6]
	cmp	w8, #13
	b.ne	.LBB1_13
// %bb.3:                               // %B1
	ldr	x10, [x22, #32]
	ldr	x11, [x24, #296]
	mov	x12, x23
	mov	x13, sp
	ldrh	w9, [x10, #40]
	ldrh	w8, [x10, #42]
	ldrh	w15, [x10, #46]
	ldr	x14, [x11]
	cmp	w0, w9
	add	w11, w8, w15
	b.lt	.LBB1_14
// %bb.4:                               // %B28
	add	w9, w11, w0
	lsl	w9, w9, #3
	and	w11, w9, #0x8
	add	w9, w9, w11
	add	w9, w9, #144
	sub	x9, x13, x9
	cmp	x9, x14
	b.ls	.LBB1_21
// %bb.5:                               // %B30
	mov	sp, x9
	stp	x13, x30, [x9, #128]
	mov	x23, x9
	stp	x12, x22, [x9]
	ubfiz	x12, x0, #3, #32
	stp	x21, x27, [x9, #80]
	ldr	x13, [x22, #40]
	str	x13, [x9, #96]
	mov	x26, x13
	ldrb	w11, [x10, #5]
	str	w11, [x9, #44]
	add	x11, x9, #144
	ldr	x19, [x10, #8]
	str	w0, [x9, #112]
	ldr	x14, [x10, #48]
	add	x10, x11, x12
	mov	x12, x11
	str	x14, [x9, #104]
	cmp	x11, x10
	b.ge	.LBB1_7
.LBB1_6:                                // %B25
                                        // =>This Inner Loop Header: Depth=1
	ldr	x13, [x20], #8
	str	x13, [x12], #8
	cmp	x12, x10
	b.lt	.LBB1_6
.LBB1_7:                                // %B27
	add	w12, w0, w8
	str	w0, [x9, #40]
	add	x20, x10, w8, uxtw #3
	stp	x11, x10, [x9, #16]
	mov	w8, #18                         // =0x12
	mov	x28, x11
	str	xzr, [x9, #64]
	mov	x27, x10
	str	w12, [x9, #72]
	ldr	x12, [x24, #8]
	str	x9, [x12, #256]
	cmp	x10, x20
	b.ge	.LBB1_10
.LBB1_8:                                // %B21
                                        // =>This Inner Loop Header: Depth=1
	str	x8, [x10], #8
	cmp	x10, x20
	b.lt	.LBB1_8
	b	.LBB1_10
.LBB1_9:                                // %B31
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
	cbnz	w8, .LBB1_12
.LBB1_10:                               // %B23
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB1_11:                               // %B39
	b	.LThrowTypeErrorNotFunction_Return_asm_h
.LBB1_12:                               // %B32
	b	.Lexception_asm_h
.LBB1_13:                               // %B37
	b	.Lcall_native_entry_asm_h
.LBB1_14:                               // %B16
	add	w11, w11, w9
	lsl	w11, w11, #3
	and	w15, w11, #0x8
	add	w11, w11, w15
	add	w11, w11, #144
	sub	x11, x13, x11
	cmp	x11, x14
	b.ls	.LBB1_21
// %bb.15:                              // %B18
	mov	sp, x11
	stp	x13, x30, [x11, #128]
	cmp	w0, w9
	mov	x23, x11
	stp	x12, x22, [x11]
	csel	w13, w0, w9, lt
	stp	x21, x27, [x11, #80]
	ldr	x14, [x22, #40]
	str	x14, [x11, #96]
	mov	x26, x14
	ldrb	w12, [x10, #5]
	str	w12, [x11, #44]
	ldr	x19, [x10, #8]
	str	w0, [x11, #112]
	ldr	x12, [x10, #48]
	add	x10, x11, #144
	add	x13, x10, w13, uxtw #3
	str	x12, [x11, #104]
	mov	x12, x10
	cmp	x10, x13
	b.ge	.LBB1_17
.LBB1_16:                               // %B5
                                        // =>This Inner Loop Header: Depth=1
	ldr	x14, [x20], #8
	str	x14, [x12], #8
	cmp	x12, x13
	b.lt	.LBB1_16
.LBB1_17:                               // %B8.preheader
	add	x12, x10, w9, uxtw #3
	mov	w14, #18                        // =0x12
	cmp	x13, x12
	b.ge	.LBB1_19
.LBB1_18:                               // %B10
                                        // =>This Inner Loop Header: Depth=1
	str	x14, [x13], #8
	cmp	x13, x12
	b.lt	.LBB1_18
.LBB1_19:                               // %B11
	str	w9, [x11, #40]
	add	w9, w9, w8
	add	x20, x12, x8, lsl #3
	stp	x10, x12, [x11, #16]
	mov	w8, #18                         // =0x12
	mov	x28, x10
	str	xzr, [x11, #64]
	mov	x27, x12
	str	w9, [x11, #72]
	ldr	x9, [x24, #8]
	str	x11, [x9, #256]
	cmp	x12, x20
	b.ge	.LBB1_10
.LBB1_20:                               // %B14
                                        // =>This Inner Loop Header: Depth=1
	str	x8, [x12], #8
	cmp	x12, x20
	b.lt	.LBB1_20
	b	.LBB1_10
.LBB1_21:                               // %B17
	b	.LThrowStackOverflow_Return_asm_h
.Lfunc_end1:
	.size	.Lcommon_call_from_entry_asm_h, .Lfunc_end1-.Lcommon_call_from_entry_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function common_call_asm_h
	.type	.Lcommon_call_asm_h,@function
.Lcommon_call_asm_h:                    // @common_call_asm_h
// %bb.0:                               // %B30
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB2_7
// %bb.1:                               // %B27
	ldrh	w8, [x22, #6]
	cmp	w8, #13
	b.ne	.LBB2_8
// %bb.2:                               // %B1
	ldr	x10, [x22, #32]
	ldr	x11, [x24, #296]
	mov	x12, x23
	mov	x13, sp
	ldrh	w9, [x10, #40]
	ldrh	w8, [x10, #42]
	ldrh	w15, [x10, #46]
	ldr	x14, [x11]
	cmp	w0, w9
	add	w11, w8, w15
	b.lt	.LBB2_9
// %bb.3:                               // %B24
	lsl	w9, w11, #3
	and	w11, w9, #0x8
	add	w9, w9, w11
	add	w9, w9, #144
	sub	x9, x13, x9
	cmp	x9, x14
	b.ls	.LBB2_17
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
	ldrb	w11, [x10, #5]
	str	w11, [x9, #44]
	add	w11, w0, w8
	ldr	x19, [x10, #8]
	str	w0, [x9, #112]
	ldr	x10, [x10, #48]
	str	w0, [x9, #40]
	str	xzr, [x9, #64]
	str	x10, [x9, #104]
	add	x10, x9, #144
	stp	x20, x10, [x9, #16]
	add	x8, x10, w8, uxtw #3
	mov	x27, x10
	str	w11, [x9, #72]
	ldr	x11, [x24, #8]
	str	x9, [x11, #256]
	mov	w11, #18                        // =0x12
	cmp	x10, x8
	b.ge	.LBB2_6
.LBB2_5:                                // %B21
                                        // =>This Inner Loop Header: Depth=1
	str	x11, [x10], #8
	cmp	x10, x8
	b.lt	.LBB2_5
.LBB2_6:                                // %B23
	ldrb	w9, [x19], #1
	mov	x20, x8
	ldr	x1, [x25, x9, lsl #3]
	br	x1
.LBB2_7:                                // %B32
	b	.LThrowTypeErrorNotFunction_Return_asm_h
.LBB2_8:                                // %B28
	b	.Lcall_native_asm_h
.LBB2_9:                                // %B16
	add	w11, w11, w9
	lsl	w11, w11, #3
	and	w15, w11, #0x8
	add	w11, w11, w15
	add	w11, w11, #144
	sub	x11, x13, x11
	cmp	x11, x14
	b.ls	.LBB2_17
// %bb.10:                              // %B18
	mov	sp, x11
	stp	x13, x30, [x11, #128]
	cmp	w0, w9
	mov	x23, x11
	stp	x12, x22, [x11]
	csel	w13, w0, w9, lt
	stp	x21, x27, [x11, #80]
	ldr	x14, [x22, #40]
	str	x14, [x11, #96]
	mov	x26, x14
	ldrb	w12, [x10, #5]
	str	w12, [x11, #44]
	ldr	x19, [x10, #8]
	str	w0, [x11, #112]
	ldr	x12, [x10, #48]
	add	x10, x11, #144
	add	x13, x10, w13, uxtw #3
	str	x12, [x11, #104]
	mov	x12, x10
	cmp	x10, x13
	b.ge	.LBB2_12
.LBB2_11:                               // %B5
                                        // =>This Inner Loop Header: Depth=1
	ldr	x14, [x20], #8
	str	x14, [x12], #8
	cmp	x12, x13
	b.lt	.LBB2_11
.LBB2_12:                               // %B8.preheader
	add	x12, x10, w9, uxtw #3
	mov	w14, #18                        // =0x12
	cmp	x13, x12
	b.ge	.LBB2_14
.LBB2_13:                               // %B10
                                        // =>This Inner Loop Header: Depth=1
	str	x14, [x13], #8
	cmp	x13, x12
	b.lt	.LBB2_13
.LBB2_14:                               // %B11
	str	w9, [x11, #40]
	add	w9, w9, w8
	add	x20, x12, x8, lsl #3
	stp	x10, x12, [x11, #16]
	mov	w8, #18                         // =0x12
	mov	x28, x10
	str	xzr, [x11, #64]
	mov	x27, x12
	str	w9, [x11, #72]
	ldr	x9, [x24, #8]
	str	x11, [x9, #256]
	cmp	x12, x20
	b.ge	.LBB2_16
.LBB2_15:                               // %B14
                                        // =>This Inner Loop Header: Depth=1
	str	x8, [x12], #8
	cmp	x12, x20
	b.lt	.LBB2_15
.LBB2_16:                               // %B15
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB2_17:                               // %B17
	b	.LThrowStackOverflow_Return_asm_h
.Lfunc_end2:
	.size	.Lcommon_call_asm_h, .Lfunc_end2-.Lcommon_call_asm_h
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
.Lfunc_end3:
	.size	.Lcommon_return_direct_asm_h, .Lfunc_end3-.Lcommon_return_direct_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function common_return_asm_h
	.type	.Lcommon_return_asm_h,@function
.Lcommon_return_asm_h:                  // @common_return_asm_h
// %bb.0:                               // %B6
	ldr	x8, [x23, #64]
	cbnz	x8, .LBB4_4
// %bb.1:                               // %B1
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB4_3
// %bb.2:                               // %B1
	cbnz	x26, .LBB4_4
.LBB4_3:                                // %B5
	b	.Lcommon_return_direct_asm_h
.LBB4_4:                                // %B3
	b	.LSlowCloseVarRefs_asm_h
.Lfunc_end4:
	.size	.Lcommon_return_asm_h, .Lfunc_end4-.Lcommon_return_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i32_0_asm_h
	.type	.Lpush_i32_0_asm_h,@function
.Lpush_i32_0_asm_h:                     // @push_i32_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #4]
	ldr	w9, [x19], #5
	add	x8, x25, x8, lsl #3
	orr	x22, x9, #0xfffe000000000000
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end5:
	.size	.Lpush_i32_0_asm_h, .Lfunc_end5-.Lpush_i32_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_const_0_asm_h
	.type	.Lpush_const_0_asm_h,@function
.Lpush_const_0_asm_h:                   // @push_const_0_asm_h
// %bb.0:                               // %B0
	ldrb	w9, [x19, #4]
	ldr	x8, [x23, #104]
	ldrsw	x10, [x19]
	add	x19, x19, #5
	add	x9, x25, x9, lsl #3
	ldr	x22, [x8, x10, lsl #3]
	ldr	x1, [x9, #1944]
	br	x1
.Lfunc_end6:
	.size	.Lpush_const_0_asm_h, .Lfunc_end6-.Lpush_const_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function fclosure_0_asm_h
	.type	.Lfclosure_0_asm_h,@function
.Lfclosure_0_asm_h:                     // @fclosure_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #104]
	ldrsw	x9, [x19]
	ldr	x0, [x8, x9, lsl #3]
	b	.LFastFclosure_asm_h
.Lfunc_end7:
	.size	.Lfclosure_0_asm_h, .Lfunc_end7-.Lfclosure_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function undefined_0_asm_h
	.type	.Lundefined_0_asm_h,@function
.Lundefined_0_asm_h:                    // @undefined_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w22, #18                        // =0x12
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end8:
	.size	.Lundefined_0_asm_h, .Lfunc_end8-.Lundefined_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function null_0_asm_h
	.type	.Lnull_0_asm_h,@function
.Lnull_0_asm_h:                         // @null_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w22, #2                         // =0x2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end9:
	.size	.Lnull_0_asm_h, .Lfunc_end9-.Lnull_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_this_0_asm_h
	.type	.Lpush_this_0_asm_h,@function
.Lpush_this_0_asm_h:                    // @push_this_0_asm_h
// %bb.0:                               // %B12
	ldrb	w8, [x23, #44]
	ldr	x1, [x23, #80]
	tbnz	w8, #0, .LBB10_2
// %bb.1:                               // %B12
	and	x8, x1, #0xfffffffffffffffe
	and	x8, x8, #0xffff000000000003
	cbnz	x8, .LBB10_3
.LBB10_2:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x1
	add	x8, x25, x8, lsl #3
	ldr	x2, [x8, #1944]
	br	x2
.LBB10_3:                               // %B6
	orr	x8, x1, #0x10
	cmp	x8, #18
	b.ne	.LBB10_5
// %bb.4:                               // %B7
	ldrb	w8, [x19], #1
	ldr	x22, [x24, #208]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB10_5:                               // %B9
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB10_7
// %bb.6:                               // %B11
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB10_7:                               // %B10
	b	.Lexception_asm_h
.Lfunc_end10:
	.size	.Lpush_this_0_asm_h, .Lfunc_end10-.Lpush_this_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_false_0_asm_h
	.type	.Lpush_false_0_asm_h,@function
.Lpush_false_0_asm_h:                   // @push_false_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end11:
	.size	.Lpush_false_0_asm_h, .Lfunc_end11-.Lpush_false_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_true_0_asm_h
	.type	.Lpush_true_0_asm_h,@function
.Lpush_true_0_asm_h:                    // @push_true_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end12:
	.size	.Lpush_true_0_asm_h, .Lfunc_end12-.Lpush_true_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function object_0_asm_h
	.type	.Lobject_0_asm_h,@function
.Lobject_0_asm_h:                       // @object_0_asm_h
// %bb.0:                               // %B15
	ldrb	w8, [x24, #355]
	cbnz	w8, .LBB13_6
// %bb.1:                               // %B1
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB13_6
// %bb.2:                               // %B5
	ldr	x8, [x24, #392]
	cbz	x8, .LBB13_6
// %bb.3:                               // %B8
	mov	x0, x24
	mov	w1, #64                         // =0x40
	mov	w2, #2                          // =0x2
	str	x20, [x23, #48]
	bl	prim_try_malloc_gc
	cbz	x0, .LBB13_6
// %bb.4:                               // %B9
	ldr	x8, [x24, #392]
	ldr	w9, [x8]
	add	w9, w9, #1
	str	w9, [x8]
	mov	w9, #1                          // =0x1
	str	w9, [x0]
	strb	w9, [x0, #5]
	strh	w9, [x0, #6]
	add	x9, x0, #8
	stlr	x8, [x9]
	add	x8, x0, #32
	str	x8, [x0, #16]
.LBB13_5:                               // %B14
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB13_6:                               // %B12
	mov	x0, x24
	str	x20, [x23, #48]
	bl	PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.ne	.LBB13_5
// %bb.7:                               // %B13
	b	.Lexception_asm_h
.Lfunc_end13:
	.size	.Lobject_0_asm_h, .Lfunc_end13-.Lobject_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function drop_0_asm_h
	.type	.Ldrop_0_asm_h,@function
.Ldrop_0_asm_h:                         // @drop_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end14:
	.size	.Ldrop_0_asm_h, .Lfunc_end14-.Ldrop_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nip_0_asm_h
	.type	.Lnip_0_asm_h,@function
.Lnip_0_asm_h:                          // @nip_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldur	x22, [x20, #-8]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	sub	x8, x20, #16
	mov	x20, x8
	br	x1
.Lfunc_end15:
	.size	.Lnip_0_asm_h, .Lfunc_end15-.Lnip_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup_0_asm_h
	.type	.Ldup_0_asm_h,@function
.Ldup_0_asm_h:                          // @dup_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x20, #-8]!
	add	x8, x25, x8, lsl #3
	mov	x21, x22
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end16:
	.size	.Ldup_0_asm_h, .Lfunc_end16-.Ldup_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup1_0_asm_h
	.type	.Ldup1_0_asm_h,@function
.Ldup1_0_asm_h:                         // @dup1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x20, #-8]!
	ldur	x22, [x20, #-8]
	add	x8, x25, x8, lsl #3
	mov	x1, x22
	mov	x22, x21
	ldr	x2, [x8, #3888]
	mov	x22, x1
	br	x2
.Lfunc_end17:
	.size	.Ldup1_0_asm_h, .Lfunc_end17-.Ldup1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function swap_0_asm_h
	.type	.Lswap_0_asm_h,@function
.Lswap_0_asm_h:                         // @swap_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldp	x22, x21, [x20, #-16]!
	add	x8, x25, x8, lsl #3
	ldr	x2, [x8, #3888]
	mov	x1, x22
	mov	x22, x21
	mov	x21, x1
	br	x2
.Lfunc_end18:
	.size	.Lswap_0_asm_h, .Lfunc_end18-.Lswap_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_constructor_0_asm_h
	.type	.Lcall_constructor_0_asm_h,@function
.Lcall_constructor_0_asm_h:             // @call_constructor_0_asm_h
// %bb.0:                               // %B18
	sub	sp, sp, #16
	ldrh	w3, [x19]
	sub	x4, x20, x3, lsl #3
	ldp	x1, x2, [x4, #-16]
	and	x8, x1, #0xfffffffffffffffe
	cmp	x1, x2
	and	x8, x8, #0xffff000000000003
	ccmp	x8, #0, #0, eq
	b.ne	.LBB19_5
// %bb.1:                               // %B14
	ldrh	w8, [x1, #6]
	cmp	w8, #13
	b.ne	.LBB19_5
// %bb.2:                               // %B7
	ldrb	w8, [x1, #5]
	tbz	w8, #4, .LBB19_5
// %bb.3:                               // %B9
	ldr	x8, [x1, #32]
	mov	x0, x3
	ldrb	w8, [x8, #6]
	add	sp, sp, #16
	tbnz	w8, #2, .LBB19_7
// %bb.4:                               // %B10
	b	.LFastCallConstructor_asm_h
.LBB19_5:                               // %B2
	add	x8, x19, #2
	mov	x0, x24
	mov	w5, wzr
	str	x8, [sp, #8]                    // 8-byte Folded Spill
                                        // kill: def $w3 killed $w3 killed $x3
	str	x8, [x23, #32]
	str	x20, [x23, #48]
	bl	JS_CallConstructorInternal_GC
	cmp	x0, #130
	b.eq	.LBB19_8
// %bb.6:                               // %B4
	ldrh	w8, [x19]
	sub	x8, x20, x8, lsl #3
	stur	x0, [x8, #-16]
	sub	x20, x8, #8
	ldr	x8, [sp, #8]                    // 8-byte Folded Reload
	ldrb	w9, [x19, #2]
	add	x19, x8, #1
	ldr	x1, [x25, x9, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB19_7:                               // %B11
	b	.LFastCallDerivedConstructor_asm_h
.LBB19_8:                               // %B3
	add	sp, sp, #16
	b	.Lexception_asm_h
.Lfunc_end19:
	.size	.Lcall_constructor_0_asm_h, .Lfunc_end19-.Lcall_constructor_0_asm_h
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
	b.eq	.LBB20_2
// %bb.1:                               // %B4
	ldurh	w8, [x19, #-2]
	sub	x20, x20, x8, lsl #3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB20_2:                               // %B3
	b	.Lexception_asm_h
.Lfunc_end20:
	.size	.Lcall_0_asm_h, .Lfunc_end20-.Lcall_0_asm_h
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
	b.eq	.LBB21_2
// %bb.1:                               // %B4
	ldurh	w8, [x19, #-2]
	sub	x8, x20, x8, lsl #3
	stur	x0, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19], #1
	ldr	x1, [x25, x9, lsl #3]
	br	x1
.LBB21_2:                               // %B3
	b	.Lexception_asm_h
.Lfunc_end21:
	.size	.Lcall_method_0_asm_h, .Lfunc_end21-.Lcall_method_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function array_from_0_asm_h
	.type	.Larray_from_0_asm_h,@function
.Larray_from_0_asm_h:                   // @array_from_0_asm_h
// %bb.0:                               // %B35
	sub	sp, sp, #64
	ldrh	w9, [x19]
	ldrb	w8, [x24, #355]
	str	x20, [sp, #56]                  // 8-byte Folded Spill
	stp	x19, x9, [sp, #40]              // 16-byte Folded Spill
	lsl	x19, x9, #3
	sub	x9, x20, x19
	str	x9, [sp, #32]                   // 8-byte Folded Spill
	cbnz	w8, .LBB22_16
// %bb.1:                               // %B1
	ldr	x8, [x24, #40]
	str	x8, [sp, #24]                   // 8-byte Folded Spill
	cbz	x8, .LBB22_16
// %bb.2:                               // %B5
	ldr	x8, [sp, #48]                   // 8-byte Folded Reload
	cbz	w8, .LBB22_11
// %bb.3:                               // %B10
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	mov	x0, x24
	mov	x1, x19
	mov	w2, #42                         // =0x2a
	str	x8, [x23, #48]
	bl	prim_try_malloc_gc
	cbz	x0, .LBB22_16
// %bb.4:                               // %B12.preheader
	add	x10, x19, x0
	ldr	x19, [sp, #32]                  // 8-byte Folded Reload
	mov	x20, x0
	mov	x11, #-562949953421312          // =0xfffe000000000000
	mov	w12, #65534                     // =0xfffe
	mov	x13, #-1688849860263936         // =0xfffa000000000000
	str	x20, [sp, #16]                  // 8-byte Folded Spill
	b	.LBB22_6
.LBB22_5:                               // %B17
                                        //   in Loop: Header=BB22_6 Depth=1
	add	x20, x20, #8
	add	x19, x19, #8
.LBB22_6:                               // %B12
                                        // =>This Inner Loop Header: Depth=1
	cmp	x20, x10
	b.ge	.LBB22_12
// %bb.7:                               // %B19
                                        //   in Loop: Header=BB22_6 Depth=1
	ldr	x8, [x19]
	str	x8, [x20]
	ldrb	w9, [x24, #376]
	cbz	w9, .LBB22_5
// %bb.8:                               // %B15
                                        //   in Loop: Header=BB22_6 Depth=1
	cmp	x12, x8, lsr #48
	b.eq	.LBB22_5
// %bb.9:                               // %B15
                                        //   in Loop: Header=BB22_6 Depth=1
	add	x9, x8, x11
	cmp	x9, x13
	b.lo	.LBB22_5
// %bb.10:                              // %B18
                                        //   in Loop: Header=BB22_6 Depth=1
	mov	x0, x8
	mov	x1, x24
	str	x10, [sp, #8]                   // 8-byte Folded Spill
	bl	prim_WriteBarrierNoStore
	ldr	x10, [sp, #8]                   // 8-byte Folded Reload
	mov	x13, #-1688849860263936         // =0xfffa000000000000
	mov	w12, #65534                     // =0xfffe
	mov	x11, #-562949953421312          // =0xfffe000000000000
	b	.LBB22_5
.LBB22_11:
	str	xzr, [sp, #16]                  // 8-byte Folded Spill
.LBB22_12:                              // %B24
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	mov	x0, x24
	mov	w1, #88                         // =0x58
	mov	w2, #2                          // =0x2
	mov	w20, #2                         // =0x2
	str	x8, [x23, #48]
	bl	prim_try_malloc_gc
	mov	x19, x0
	cbz	x19, .LBB22_16
// %bb.13:                              // %B26
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
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
	cbnz	w8, .LBB22_18
.LBB22_14:                              // %B28
	ldr	x10, [sp, #48]                  // 8-byte Folded Reload
	mov	x9, x19
	orr	x8, x10, #0xfffe000000000000
	str	x8, [x9, #56]!
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
	str	x9, [x19, #16]
	str	x8, [x19, #40]
	str	w10, [x19, #32]
	str	w10, [x19, #48]
.LBB22_15:                              // %B29
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
.LBB22_16:                              // %B32
	ldp	x1, x8, [sp, #48]               // 16-byte Folded Reload
	mov	x0, x24
	ldr	x2, [sp, #32]                   // 8-byte Folded Reload
                                        // kill: def $w1 killed $w1 killed $x1
	str	x8, [x23, #48]
	bl	JS_NewArrayWithArgs_GC
	cmp	x0, #130
	mov	x19, x0
	b.ne	.LBB22_15
// %bb.17:                              // %B33
	ldr	x19, [sp, #40]                  // 8-byte Folded Reload
	ldr	x20, [sp, #56]                  // 8-byte Folded Reload
	add	sp, sp, #64
	b	.Lexception_asm_h
.LBB22_18:                              // %B30
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	prim_WriteBarrierNoStore
	b	.LBB22_14
.Lfunc_end22:
	.size	.Larray_from_0_asm_h, .Lfunc_end22-.Larray_from_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_0_asm_h
	.type	.Lreturn_0_asm_h,@function
.Lreturn_0_asm_h:                       // @return_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	mov	x0, x22
	b	.Lcommon_return_asm_h
.Lfunc_end23:
	.size	.Lreturn_0_asm_h, .Lfunc_end23-.Lreturn_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_undef_0_asm_h
	.type	.Lreturn_undef_0_asm_h,@function
.Lreturn_undef_0_asm_h:                 // @return_undef_0_asm_h
// %bb.0:                               // %B0
	mov	w0, #18                         // =0x12
	b	.Lcommon_return_asm_h
.Lfunc_end24:
	.size	.Lreturn_undef_0_asm_h, .Lfunc_end24-.Lreturn_undef_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_undef_0_asm_h
	.type	.Lget_var_undef_0_asm_h,@function
.Lget_var_undef_0_asm_h:                // @get_var_undef_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x24, #216]
	ldr	w1, [x19]
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w1, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, .LBB25_3
.LBB25_1:                               // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w11, w10, #3
	sub	w11, w11, #8
	ldr	x11, [x9, w11, uxtw]
	lsr	x12, x11, #32
	cmp	w1, w12
	b.eq	.LBB25_10
// %bb.2:                               // %B8
                                        //   in Loop: Header=BB25_1 Depth=1
	and	w10, w11, #0x3ffffff
	cbnz	w10, .LBB25_1
.LBB25_3:                               // %B33
	ldr	x8, [x24, #208]
	mov	w9, #18                         // =0x12
.LBB25_4:                               // %B22
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB25_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w10, [x11, #12]
	add	x13, x11, #64
	lsl	w12, w10, #2
	and	w10, w1, w10
	ldr	w10, [x13, w10, sxtw #2]
	add	w12, w12, #4
	add	x12, x13, x12
	cbz	w10, .LBB25_7
.LBB25_5:                               // %B26
                                        //   Parent Loop BB25_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w10, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w1, w14
	b.eq	.LBB25_9
// %bb.6:                               // %B28
                                        //   in Loop: Header=BB25_5 Depth=2
	and	w10, w13, #0x3ffffff
	cbnz	w10, .LBB25_5
.LBB25_7:                               // %B17
                                        //   in Loop: Header=BB25_4 Depth=1
	ldrb	w8, [x8, #5]
	tbnz	w8, #2, .LBB25_13
// %bb.8:                               // %B20
                                        //   in Loop: Header=BB25_4 Depth=1
	ldr	x8, [x11, #32]
	cbnz	x8, .LBB25_4
	b	.LBB25_11
.LBB25_9:                               // %B9
	lsr	w9, w13, #30
	cbnz	w9, .LBB25_13
.LBB25_10:                              // %B2
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x9, [x8, w9, sxtw #3]
	cmp	x9, #34
	b.eq	.LBB25_12
.LBB25_11:                              // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x9
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB25_12:                              // %B3
	b	.LThrowReferenceErrorUninitialized_asm_h
.LBB25_13:                              // %B14
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB25_15
// %bb.14:                              // %B16
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB25_15:                              // %B15
	b	.Lexception_asm_h
.Lfunc_end25:
	.size	.Lget_var_undef_0_asm_h, .Lfunc_end25-.Lget_var_undef_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_0_asm_h
	.type	.Lget_var_0_asm_h,@function
.Lget_var_0_asm_h:                      // @get_var_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x24, #216]
	ldr	w1, [x19]
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x12, x9, #64
	lsl	w11, w10, #2
	and	w9, w1, w10
	ldr	w9, [x12, w9, sxtw #2]
	add	w10, w11, #4
	add	x10, x12, x10
	cbz	w9, .LBB26_3
.LBB26_1:                               // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	ldr	x11, [x10, w11, uxtw]
	lsr	x12, x11, #32
	cmp	w1, w12
	b.eq	.LBB26_10
// %bb.2:                               // %B8
                                        //   in Loop: Header=BB26_1 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, .LBB26_1
.LBB26_3:                               // %B32
	ldr	x8, [x24, #208]
.LBB26_4:                               // %B21
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB26_5 Depth 2
	ldr	x10, [x8, #8]
	ldr	w9, [x10, #12]
	add	x12, x10, #64
	lsl	w11, w9, #2
	and	w9, w1, w9
	ldr	w9, [x12, w9, sxtw #2]
	add	w11, w11, #4
	add	x11, x12, x11
	cbz	w9, .LBB26_7
.LBB26_5:                               // %B25
                                        //   Parent Loop BB26_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w9, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w1, w13
	b.eq	.LBB26_9
// %bb.6:                               // %B27
                                        //   in Loop: Header=BB26_5 Depth=2
	and	w9, w12, #0x3ffffff
	cbnz	w9, .LBB26_5
.LBB26_7:                               // %B16
                                        //   in Loop: Header=BB26_4 Depth=1
	ldrb	w8, [x8, #5]
	tbnz	w8, #2, .LBB26_13
// %bb.8:                               // %B19
                                        //   in Loop: Header=BB26_4 Depth=1
	ldr	x8, [x10, #32]
	cbnz	x8, .LBB26_4
	b	.LBB26_13
.LBB26_9:                               // %B9
	lsr	w10, w12, #30
	cbnz	w10, .LBB26_13
.LBB26_10:                              // %B2
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	.LBB26_12
// %bb.11:                              // %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB26_12:                              // %B3
	b	.LThrowReferenceErrorUninitialized_asm_h
.LBB26_13:                              // %B13
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x20, [x23, #48]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB26_15
// %bb.14:                              // %B15
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB26_15:                              // %B14
	b	.Lexception_asm_h
.Lfunc_end26:
	.size	.Lget_var_0_asm_h, .Lfunc_end26-.Lget_var_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_0_asm_h
	.type	.Lput_var_0_asm_h,@function
.Lput_var_0_asm_h:                      // @put_var_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x24, #216]
	ldr	w1, [x19]
	ldur	x22, [x20, #-8]
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x12, x9, #64
	lsl	w11, w10, #2
	and	w9, w1, w10
	ldr	w9, [x12, w9, sxtw #2]
	add	w10, w11, #4
	add	x10, x12, x10
	cbz	w9, .LBB27_3
.LBB27_1:                               // %B1
                                        // =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w1, w12
	b.eq	.LBB27_6
// %bb.2:                               // %B19
                                        //   in Loop: Header=BB27_1 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, .LBB27_1
.LBB27_3:                               // %B42
	ldr	x8, [x24, #208]
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x12, x9, #64
	lsl	w11, w10, #2
	and	w9, w1, w10
	ldr	w9, [x12, w9, sxtw #2]
	add	w10, w11, #4
	add	x10, x12, x10
	cbz	w9, .LBB27_15
.LBB27_4:                               // %B32
                                        // =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w1, w12
	b.eq	.LBB27_10
// %bb.5:                               // %B34
                                        //   in Loop: Header=BB27_4 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, .LBB27_4
	b	.LBB27_15
.LBB27_6:                               // %B3
	mov	w10, #-402653184                // =0xe8000000
	and	w10, w11, w10
	mov	w11, #134217728                 // =0x8000000
	cmp	w10, w11
	b.ne	.LBB27_15
// %bb.7:                               // %B14
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	ldr	x10, [x8, w9, sxtw #3]
	cmp	x10, #34
	b.eq	.LBB27_15
// %bb.8:                               // %B23
	str	x22, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB27_12
.LBB27_9:                               // %B8
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB27_10:                              // %B20
	mov	w10, #-402653184                // =0xe8000000
	and	w10, w11, w10
	mov	w11, #134217728                 // =0x8000000
	cmp	w10, w11
	b.ne	.LBB27_15
// %bb.11:                              // %B23
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	str	x22, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB27_9
.LBB27_12:                              // %B26
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	.LBB27_9
// %bb.13:                              // %B26
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x22, x8
	cmp	x8, x9
	b.lo	.LBB27_9
// %bb.14:                              // %B8.sink.split
	mov	x0, x22
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB27_15:                              // %B37
	mov	x0, x24
	mov	x2, x22
	mov	w3, wzr
	str	x20, [x23, #48]
	bl	JS_SetGlobalVar_GC
	tbz	w0, #31, .LBB27_9
// %bb.16:                              // %B38
	b	.Lexception_asm_h
.Lfunc_end27:
	.size	.Lput_var_0_asm_h, .Lfunc_end27-.Lput_var_0_asm_h
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
	b.ne	.LBB28_10
// %bb.1:                               // %B25
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB28_2:                               // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB28_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w11, w2, w11
	ldr	w11, [x13, w11, sxtw #2]
	add	w12, w12, #4
	add	x12, x13, x12
	cbz	w11, .LBB28_5
.LBB28_3:                               // %B1
                                        //   Parent Loop BB28_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w2, w14
	b.eq	.LBB28_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB28_3 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB28_3
.LBB28_5:                               // %B14
                                        //   in Loop: Header=BB28_2 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB28_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB28_2 Depth=1
	ldr	x9, [x10, #32]
	cbnz	x9, .LBB28_2
	b	.LBB28_9
.LBB28_7:                               // %B3
	lsr	w8, w13, #30
	cbnz	w8, .LBB28_10
// %bb.8:                               // %B4
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB28_9:                               // %B6
	ldrb	w9, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x22, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB28_10:                              // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB28_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB28_12:                              // %B22
	b	.Lexception_asm_h
.Lfunc_end28:
	.size	.Lget_field_0_asm_h, .Lfunc_end28-.Lget_field_0_asm_h
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
	b.ne	.LBB29_10
// %bb.1:                               // %B25
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB29_2:                               // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB29_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w11, w2, w11
	ldr	w11, [x13, w11, sxtw #2]
	add	w12, w12, #4
	add	x12, x13, x12
	cbz	w11, .LBB29_5
.LBB29_3:                               // %B1
                                        //   Parent Loop BB29_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w2, w14
	b.eq	.LBB29_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB29_3 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB29_3
.LBB29_5:                               // %B14
                                        //   in Loop: Header=BB29_2 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB29_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB29_2 Depth=1
	ldr	x9, [x10, #32]
	cbnz	x9, .LBB29_2
	b	.LBB29_9
.LBB29_7:                               // %B3
	lsr	w8, w13, #30
	cbnz	w8, .LBB29_10
// %bb.8:                               // %B4
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB29_9:                               // %B6
	ldrb	w9, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x21, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB29_10:                              // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB29_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB29_12:                              // %B22
	b	.Lexception_asm_h
.Lfunc_end29:
	.size	.Lget_field2_0_asm_h, .Lfunc_end29-.Lget_field2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_field_0_asm_h
	.type	.Lput_field_0_asm_h,@function
.Lput_field_0_asm_h:                    // @put_field_0_asm_h
// %bb.0:                               // %B54
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB30_16
// %bb.1:                               // %B55
	ldr	x10, [x22, #8]
	ldr	w8, [x19]
	ldr	w9, [x10, #12]
	add	x12, x10, #64
	lsl	w11, w9, #2
	and	w9, w8, w9
	ldr	w9, [x12, w9, sxtw #2]
	add	w11, w11, #4
	add	x11, x12, x11
	cbz	w9, .LBB30_4
.LBB30_2:                               // %B1
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w9, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w8, w13
	b.eq	.LBB30_12
// %bb.3:                               // %B15
                                        //   in Loop: Header=BB30_2 Depth=1
	and	w9, w12, #0x3ffffff
	cbnz	w9, .LBB30_2
.LBB30_4:                               // %B20
	ldr	w9, [x22, #4]
	tbnz	w9, #10, .LBB30_16
// %bb.5:                               // %B51
	ldr	x10, [x10, #32]
	cbz	x10, .LBB30_11
.LBB30_6:                               // %B49
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB30_7 Depth 2
	ldr	x11, [x10, #8]
	ldr	w12, [x11, #12]
	add	x15, x11, #64
	lsl	w14, w12, #2
	and	w12, w8, w12
	ldr	w13, [x15, w12, sxtw #2]
	add	w12, w14, #4
	add	x12, x15, x12
	cbz	w13, .LBB30_9
.LBB30_7:                               // %B23
                                        //   Parent Loop BB30_6 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w13, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w8, w14
	b.eq	.LBB30_15
// %bb.8:                               // %B39
                                        //   in Loop: Header=BB30_7 Depth=2
	and	w13, w13, #0x3ffffff
	cbnz	w13, .LBB30_7
.LBB30_9:                               // %B44
                                        //   in Loop: Header=BB30_6 Depth=1
	ldrb	w10, [x10, #5]
	tbnz	w10, #2, .LBB30_16
// %bb.10:                              // %B47
                                        //   in Loop: Header=BB30_6 Depth=1
	ldr	x10, [x11, #32]
	cbnz	x10, .LBB30_6
.LBB30_11:                              // %B28
	tbnz	w9, #8, .LBB30_20
	b	.LBB30_16
.LBB30_12:                              // %B3
	mov	w8, #-402653184                 // =0xe8000000
	mov	w10, #134217728                 // =0x8000000
	and	w8, w12, w8
	cmp	w8, w10
	b.ne	.LBB30_16
// %bb.13:                              // %B7
	ldr	x8, [x22, #16]
	sub	w9, w9, #1
	str	x21, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB30_17
.LBB30_14:                              // %B5
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB30_15:                              // %B25
	mov	w10, #-402653184                // =0xe8000000
	mov	w11, #134217728                 // =0x8000000
	and	w12, w9, #0x100
	and	w10, w13, w10
	cmp	w10, w11
	ccmp	w12, #0, #4, eq
	b.ne	.LBB30_20
.LBB30_16:                              // %B14
	mov	x0, xzr
	b	.LSlowPutField_asm_h
.LBB30_17:                              // %B10
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB30_14
// %bb.18:                              // %B10
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x21, x8
	cmp	x8, x9
	b.lo	.LBB30_14
// %bb.19:                              // %B12
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB30_20:                              // %B30
	and	w9, w9, #0xffff0000
	cmp	w9, #16, lsl #12                // =65536
	b.ne	.LBB30_23
// %bb.21:                              // %B30
	tbnz	w8, #31, .LBB30_23
// %bb.22:                              // %B36
	mov	x0, x8
	b	.LFastAddNamedProperty_asm_h
.LBB30_23:                              // %B32
	mov	w0, #1                          // =0x1
	b	.LSlowPutField_asm_h
.Lfunc_end30:
	.size	.Lput_field_0_asm_h, .Lfunc_end30-.Lput_field_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_array_el_0_asm_h
	.type	.Lget_array_el_0_asm_h,@function
.Lget_array_el_0_asm_h:                 // @get_array_el_0_asm_h
// %bb.0:                               // %B36
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB31_6
// %bb.1:                               // %B36
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x8, x9
	b.ne	.LBB31_6
// %bb.2:                               // %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	.LBB31_5
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w8, w21
	b.ls	.LBB31_7
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #16
	add	x8, x25, x8, lsl #3
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x8, #1944]
	br	x1
.LBB31_5:                               // %B30
	sub	w8, w8, #21
	cmp	w8, #8
	b.ls	.LBB31_17
.LBB31_6:                               // %B16
	b	.LSlowGetArrayEl_asm_h
.LBB31_7:                               // %B7
	tbnz	w21, #31, .LBB31_6
// %bb.8:                               // %B9.preheader
	mov	x9, x22
	orr	w10, w21, #0x80000000
	mov	w8, #18                         // =0x12
.LBB31_9:                               // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB31_10 Depth 2
	ldr	x11, [x9, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w12, w10, w12
	ldr	w12, [x14, w12, sxtw #2]
	add	w13, w13, #4
	add	x13, x14, x13
	cbz	w12, .LBB31_12
.LBB31_10:                              // %B10
                                        //   Parent Loop BB31_9 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w14, w12, #3
	sub	w14, w14, #8
	add	x14, x13, x14
	ldp	w14, w15, [x14]
	cmp	w10, w15
	b.eq	.LBB31_14
// %bb.11:                              // %B17
                                        //   in Loop: Header=BB31_10 Depth=2
	and	w12, w14, #0x3ffffff
	cbnz	w12, .LBB31_10
.LBB31_12:                              // %B24
                                        //   in Loop: Header=BB31_9 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB31_6
// %bb.13:                              // %B21
                                        //   in Loop: Header=BB31_9 Depth=1
	ldr	x9, [x11, #32]
	cbnz	x9, .LBB31_9
	b	.LBB31_16
.LBB31_14:                              // %B12
	lsr	w8, w14, #30
	cbnz	w8, .LBB31_6
// %bb.15:                              // %B13
	ldr	x8, [x9, #16]
	sub	w9, w12, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB31_16:                              // %B14
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB31_17:                              // %B31
	mov	x0, xzr
	b	.LFastTypedArrayGet_asm_h
.Lfunc_end31:
	.size	.Lget_array_el_0_asm_h, .Lfunc_end31-.Lget_array_el_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_array_el2_0_asm_h
	.type	.Lget_array_el2_0_asm_h,@function
.Lget_array_el2_0_asm_h:                // @get_array_el2_0_asm_h
// %bb.0:                               // %B36
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB32_6
// %bb.1:                               // %B36
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x8, x9
	b.ne	.LBB32_6
// %bb.2:                               // %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	.LBB32_5
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w8, w21
	b.ls	.LBB32_7
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #16
	add	x8, x25, x8, lsl #3
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x8, #3888]
	br	x1
.LBB32_5:                               // %B30
	sub	w8, w8, #21
	cmp	w8, #8
	b.ls	.LBB32_17
.LBB32_6:                               // %B16
	b	.LSlowGetArrayEl_asm_h
.LBB32_7:                               // %B7
	tbnz	w21, #31, .LBB32_6
// %bb.8:                               // %B9.preheader
	mov	x9, x22
	orr	w10, w21, #0x80000000
	mov	w8, #18                         // =0x12
.LBB32_9:                               // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB32_10 Depth 2
	ldr	x11, [x9, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w12, w10, w12
	ldr	w12, [x14, w12, sxtw #2]
	add	w13, w13, #4
	add	x13, x14, x13
	cbz	w12, .LBB32_12
.LBB32_10:                              // %B10
                                        //   Parent Loop BB32_9 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w14, w12, #3
	sub	w14, w14, #8
	add	x14, x13, x14
	ldp	w14, w15, [x14]
	cmp	w10, w15
	b.eq	.LBB32_14
// %bb.11:                              // %B17
                                        //   in Loop: Header=BB32_10 Depth=2
	and	w12, w14, #0x3ffffff
	cbnz	w12, .LBB32_10
.LBB32_12:                              // %B24
                                        //   in Loop: Header=BB32_9 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB32_6
// %bb.13:                              // %B21
                                        //   in Loop: Header=BB32_9 Depth=1
	ldr	x9, [x11, #32]
	cbnz	x9, .LBB32_9
	b	.LBB32_16
.LBB32_14:                              // %B12
	lsr	w8, w14, #30
	cbnz	w8, .LBB32_6
// %bb.15:                              // %B13
	ldr	x8, [x9, #16]
	sub	w9, w12, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB32_16:                              // %B14
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x21, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB32_17:                              // %B31
	mov	w0, #1                          // =0x1
	b	.LFastTypedArrayGet_asm_h
.Lfunc_end32:
	.size	.Lget_array_el2_0_asm_h, .Lfunc_end32-.Lget_array_el2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_array_el_0_asm_h
	.type	.Lput_array_el_0_asm_h,@function
.Lput_array_el_0_asm_h:                 // @put_array_el_0_asm_h
// %bb.0:                               // %B56
	ldp	x8, x22, [x20, #-24]
	mov	x9, #2                          // =0x2
	movk	x9, #65535, lsl #48
	ldur	x21, [x20, #-8]
	tst	x8, x9
	b.ne	.LBB33_7
// %bb.1:                               // %B1
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x22, lsr #48
	b.ne	.LBB33_7
// %bb.2:                               // %B3
	ldrh	w9, [x8, #6]
	cmp	w9, #2
	b.ne	.LBB33_6
// %bb.3:                               // %B48
	ldr	w9, [x8, #48]
	cmp	w9, w22
	b.ls	.LBB33_8
// %bb.4:                               // %B5
	ldr	x8, [x8, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB33_16
.LBB33_5:                               // %B25
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB33_6:                               // %B52
	sub	w8, w9, #21
	cmp	w8, #8
	b.ls	.LBB33_20
.LBB33_7:                               // %B40
	mov	x0, xzr
	b	.LSlowPutArrayEl_asm_h
.LBB33_8:                               // %B13
	b.ne	.LBB33_21
// %bb.9:                               // %B41
	ldr	w9, [x8, #4]
	mov	w10, #2304                      // =0x900
	bics	wzr, w10, w9
	b.ne	.LBB33_7
// %bb.10:                              // %B15
	ldr	x9, [x8, #8]
	ldr	x9, [x9, #32]
	cbz	x9, .LBB33_12
// %bb.11:                              // %B37
	ldrb	w9, [x9, #5]
	tbz	w9, #5, .LBB33_7
.LBB33_12:                              // %B33
	ldr	x9, [x8, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w22, #1
	b.ne	.LBB33_14
// %bb.13:                              // %B33
	cmp	w9, w10
	b.hi	.LBB33_19
.LBB33_14:                              // %B30
	ldr	w10, [x8, #32]
	cmp	w9, w10
	b.hi	.LBB33_19
// %bb.15:                              // %B23
	ldr	x10, [x8, #40]
	str	w9, [x8, #48]
	str	x21, [x10, w22, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB33_5
.LBB33_16:                              // %B27
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB33_5
// %bb.17:                              // %B27
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x21, x8
	cmp	x8, x9
	b.lo	.LBB33_5
// %bb.18:                              // %B29
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB33_19:                              // %B20
	mov	w0, #1                          // =0x1
	b	.LSlowPutArrayEl_asm_h
.LBB33_20:                              // %B53
	b	.LFastTypedArraySet_asm_h
.LBB33_21:                              // %B45
	tbnz	w22, #31, .LBB33_7
// %bb.22:                              // %B46
	mov	w0, #2                          // =0x2
	b	.LSlowPutArrayEl_asm_h
.Lfunc_end33:
	.size	.Lput_array_el_0_asm_h, .Lfunc_end33-.Lput_array_el_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_false_0_asm_h
	.type	.Lif_false_0_asm_h,@function
.Lif_false_0_asm_h:                     // @if_false_0_asm_h
// %bb.0:                               // %B25
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	sub	x9, x22, #6
	cmp	x9, #2
	b.hs	.LBB34_3
// %bb.1:                               // %B1
	cbz	x9, .LBB34_10
.LBB34_2:                               // %B6
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB34_3:                               // %B7
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x22, lsr #48
	b.ne	.LBB34_5
// %bb.4:                               // %B9
	cbnz	w22, .LBB34_2
	b	.LBB34_10
.LBB34_5:                               // %B13
	and	x9, x22, #0xffffffffffffffef
	cmp	x9, #2
	b.eq	.LBB34_10
// %bb.6:                               // %B16
	mov	x9, #2                          // =0x2
	movk	x9, #65535, lsl #48
	tst	x22, x9
	b.eq	.LBB34_2
// %bb.7:                               // %B19
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	add	x9, x22, x9
	cmp	x9, x10
	b.lo	.LBB34_9
// %bb.8:                               // %B24
	mov	x20, x8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.LBB34_9:                               // %B21
	fmov	d0, x9
	fcmp	d0, #0.0
	b.mi	.LBB34_2
	b.gt	.LBB34_2
.LBB34_10:                              // %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end34:
	.size	.Lif_false_0_asm_h, .Lfunc_end34-.Lif_false_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_true_0_asm_h
	.type	.Lif_true_0_asm_h,@function
.Lif_true_0_asm_h:                      // @if_true_0_asm_h
// %bb.0:                               // %B25
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	sub	x9, x22, #6
	cmp	x9, #2
	b.hs	.LBB35_3
// %bb.1:                               // %B1
	cbz	x9, .LBB35_10
.LBB35_2:                               // %B6
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB35_3:                               // %B7
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x22, lsr #48
	b.ne	.LBB35_5
// %bb.4:                               // %B9
	cbnz	w22, .LBB35_2
	b	.LBB35_10
.LBB35_5:                               // %B13
	and	x9, x22, #0xffffffffffffffef
	cmp	x9, #2
	b.eq	.LBB35_10
// %bb.6:                               // %B16
	mov	x9, #2                          // =0x2
	movk	x9, #65535, lsl #48
	tst	x22, x9
	b.eq	.LBB35_2
// %bb.7:                               // %B19
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	add	x9, x22, x9
	cmp	x9, x10
	b.lo	.LBB35_9
// %bb.8:                               // %B24
	mov	x20, x8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.LBB35_9:                               // %B21
	fmov	d0, x9
	fcmp	d0, #0.0
	b.mi	.LBB35_2
	b.gt	.LBB35_2
.LBB35_10:                              // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end35:
	.size	.Lif_true_0_asm_h, .Lfunc_end35-.Lif_true_0_asm_h
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
.Lfunc_end36:
	.size	.Lgoto_0_asm_h, .Lfunc_end36-.Lgoto_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function neg_0_asm_h
	.type	.Lneg_0_asm_h,@function
.Lneg_0_asm_h:                          // @neg_0_asm_h
// %bb.0:                               // %B16
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB37_3
// %bb.1:                               // %B10
	orr	w8, w22, #0x80000000
	mov	w9, #-2147483648                // =0x80000000
	cmp	w8, w9
	b.eq	.LBB37_5
// %bb.2:                               // %B12
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB37_3:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842625          // =0xfffbffffffffffff
	add	x8, x22, x8
	cmp	x8, x9
	b.hi	.LBB37_5
// %bb.4:                               // %B3
	movi	d0, #0000000000000000
	fmov	d1, x8
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	fsub	d0, d0, d1
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB37_5:                               // %B13
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        // =0x8c
	str	x20, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB37_7
// %bb.6:                               // %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB37_7:                               // %B14
	b	.Lexception_asm_h
.Lfunc_end37:
	.size	.Lneg_0_asm_h, .Lfunc_end37-.Lneg_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dec_0_asm_h
	.type	.Ldec_0_asm_h,@function
.Ldec_0_asm_h:                          // @dec_0_asm_h
// %bb.0:                               // %B16
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB38_3
// %bb.1:                               // %B10
	subs	w8, w22, #1
	b.vs	.LBB38_5
// %bb.2:                               // %B12
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB38_3:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842625          // =0xfffbffffffffffff
	add	x8, x22, x8
	cmp	x8, x9
	b.hi	.LBB38_5
// %bb.4:                               // %B3
	fmov	d0, #-1.00000000
	fmov	d1, x8
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	fadd	d0, d1, d0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB38_5:                               // %B13
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        // =0x8e
	str	x20, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB38_7
// %bb.6:                               // %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB38_7:                               // %B14
	b	.Lexception_asm_h
.Lfunc_end38:
	.size	.Ldec_0_asm_h, .Lfunc_end38-.Ldec_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_0_asm_h
	.type	.Linc_0_asm_h,@function
.Linc_0_asm_h:                          // @inc_0_asm_h
// %bb.0:                               // %B16
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB39_3
// %bb.1:                               // %B10
	adds	w8, w22, #1
	b.vs	.LBB39_5
// %bb.2:                               // %B12
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB39_3:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842625          // =0xfffbffffffffffff
	add	x8, x22, x8
	cmp	x8, x9
	b.hi	.LBB39_5
// %bb.4:                               // %B3
	fmov	d0, #1.00000000
	fmov	d1, x8
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	fadd	d0, d1, d0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB39_5:                               // %B13
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        // =0x8f
	str	x20, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB39_7
// %bb.6:                               // %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB39_7:                               // %B14
	b	.Lexception_asm_h
.Lfunc_end39:
	.size	.Linc_0_asm_h, .Lfunc_end39-.Linc_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function post_dec_0_asm_h
	.type	.Lpost_dec_0_asm_h,@function
.Lpost_dec_0_asm_h:                     // @post_dec_0_asm_h
// %bb.0:                               // %B13
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB40_3
// %bb.1:                               // %B10
	subs	w8, w22, #1
	b.vs	.LBB40_5
// %bb.2:                               // %B12
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB40_3:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842624          // =0xfffc000000000000
	add	x8, x22, x8
	cmp	x8, x9
	b.hs	.LBB40_5
// %bb.4:                               // %B3
	fmov	d0, #-1.00000000
	fmov	d1, x8
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	fadd	d0, d1, d0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x8, x9, vs
	br	x1
.LBB40_5:                               // %B9
	mov	w0, #144                        // =0x90
	b	.LSlowJSPostInc_asm_h
.Lfunc_end40:
	.size	.Lpost_dec_0_asm_h, .Lfunc_end40-.Lpost_dec_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function post_inc_0_asm_h
	.type	.Lpost_inc_0_asm_h,@function
.Lpost_inc_0_asm_h:                     // @post_inc_0_asm_h
// %bb.0:                               // %B13
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB41_3
// %bb.1:                               // %B10
	adds	w8, w22, #1
	b.vs	.LBB41_5
// %bb.2:                               // %B12
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB41_3:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842624          // =0xfffc000000000000
	add	x8, x22, x8
	cmp	x8, x9
	b.hs	.LBB41_5
// %bb.4:                               // %B3
	fmov	d0, #1.00000000
	fmov	d1, x8
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	fadd	d0, d1, d0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x8, x9, vs
	br	x1
.LBB41_5:                               // %B9
	mov	w0, #145                        // =0x91
	b	.LSlowJSPostInc_asm_h
.Lfunc_end41:
	.size	.Lpost_inc_0_asm_h, .Lfunc_end41-.Lpost_inc_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dec_loc_0_asm_h
	.type	.Ldec_loc_0_asm_h,@function
.Ldec_loc_0_asm_h:                      // @dec_loc_0_asm_h
// %bb.0:                               // %B16
	ldrb	w8, [x19]
	mov	w9, #65534                      // =0xfffe
	ldr	x1, [x27, x8, lsl #3]
	cmp	x9, x1, lsr #48
	b.ne	.LBB42_3
// %bb.1:                               // %B10
	subs	w9, w1, #1
	b.vs	.LBB42_5
// %bb.2:                               // %B12
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB42_3:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x9, x1, x9
	cmp	x9, x10
	b.hi	.LBB42_5
// %bb.4:                               // %B4
	fmov	d0, #-1.00000000
	fmov	d1, x9
	mov	x10, #562949953421312           // =0x2000000000000
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x10, x9, vs
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB42_5:                               // %B13
	mov	x0, x24
	mov	w2, #142                        // =0x8e
	str	x20, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB42_7
// %bb.6:                               // %B15
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB42_7:                               // %B14
	b	.Lexception_asm_h
.Lfunc_end42:
	.size	.Ldec_loc_0_asm_h, .Lfunc_end42-.Ldec_loc_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_loc_0_asm_h
	.type	.Linc_loc_0_asm_h,@function
.Linc_loc_0_asm_h:                      // @inc_loc_0_asm_h
// %bb.0:                               // %B16
	ldrb	w8, [x19]
	mov	w9, #65534                      // =0xfffe
	ldr	x1, [x27, x8, lsl #3]
	cmp	x9, x1, lsr #48
	b.ne	.LBB43_3
// %bb.1:                               // %B10
	adds	w9, w1, #1
	b.vs	.LBB43_5
// %bb.2:                               // %B12
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB43_3:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x9, x1, x9
	cmp	x9, x10
	b.hi	.LBB43_5
// %bb.4:                               // %B4
	fmov	d0, #1.00000000
	fmov	d1, x9
	mov	x10, #562949953421312           // =0x2000000000000
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x10, x9, vs
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB43_5:                               // %B13
	mov	x0, x24
	mov	w2, #143                        // =0x8f
	str	x20, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB43_7
// %bb.6:                               // %B15
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB43_7:                               // %B14
	b	.Lexception_asm_h
.Lfunc_end43:
	.size	.Linc_loc_0_asm_h, .Lfunc_end43-.Linc_loc_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_loc_0_asm_h
	.type	.Ladd_loc_0_asm_h,@function
.Ladd_loc_0_asm_h:                      // @add_loc_0_asm_h
// %bb.0:                               // %B30
	ldrb	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x9, [x27, x8, lsl #3]
	eor	x11, x22, #0xfffe000000000000
	eor	x10, x9, #0xfffe000000000000
	orr	x10, x10, x11
	lsr	x10, x10, #48
	cbnz	x10, .LBB44_3
// %bb.1:                               // %B23
	adds	w10, w9, w22
	sub	x20, x20, #8
	b.vs	.LBB44_8
// %bb.2:                               // %B29
	orr	x9, x10, #0xfffe000000000000
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB44_3:                               // %B2
	mov	x10, #-562949953421312          // =0xfffe000000000000
	mov	x12, #-844424930131969          // =0xfffcffffffffffff
	add	x11, x9, x10
	add	x10, x22, x10
	cmp	x11, x12
	mov	x12, #-844424930131968          // =0xfffd000000000000
	ccmp	x10, x12, #2, ls
	b.hs	.LBB44_9
// %bb.4:                               // %B4
	mov	x12, #-1125899906842624         // =0xfffc000000000000
	cmp	x11, x12
	b.hs	.LBB44_10
// %bb.5:                               // %B6
	fmov	d0, x11
	cmp	x10, x12
	b.hs	.LBB44_11
.LBB44_6:                               // %B8
	fmov	d1, x10
.LBB44_7:                               // %B13
	fadd	d0, d0, d1
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x10, x9, vs
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB44_8:                               // %B25
	scvtf	d0, w9
	scvtf	d1, w22
	mov	x10, #562949953421312           // =0x2000000000000
	fadd	d0, d0, d1
	fmov	x9, d0
	add	x9, x9, x10
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB44_9:                               // %B22
	mov	w0, #1                          // =0x1
	b	.LSlowJSAdd_asm_h
.LBB44_10:                              // %B18
	scvtf	d0, w9
	b	.LBB44_6
.LBB44_11:                              // %B13
	scvtf	d1, w22
	b	.LBB44_7
.Lfunc_end44:
	.size	.Ladd_loc_0_asm_h, .Lfunc_end44-.Ladd_loc_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function not_0_asm_h
	.type	.Lnot_0_asm_h,@function
.Lnot_0_asm_h:                          // @not_0_asm_h
// %bb.0:                               // %B2
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB45_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB45_2:                               // %B4
	mov	x0, x22
	b	.LSlowJSNot_asm_h
.Lfunc_end45:
	.size	.Lnot_0_asm_h, .Lfunc_end45-.Lnot_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lnot_0_asm_h
	.type	.Llnot_0_asm_h,@function
.Llnot_0_asm_h:                         // @lnot_0_asm_h
// %bb.0:                               // %B20
	ldur	x22, [x20, #-8]
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB46_3
// %bb.1:                               // %B1
	cbz	x8, .LBB46_5
.LBB46_2:                               // %B7
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB46_3:                               // %B8
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB46_6
// %bb.4:                               // %B10
	cbnz	w22, .LBB46_2
.LBB46_5:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB46_6:                               // %B14
	and	x8, x22, #0xffffffffffffffef
	cmp	x8, #2
	b.eq	.LBB46_5
// %bb.7:                               // %B17
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	.LBB46_2
// %bb.8:                               // %B19
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.Lfunc_end46:
	.size	.Llnot_0_asm_h, .Lfunc_end46-.Llnot_0_asm_h
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
	b.eq	.LBB47_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB47_2:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end47:
	.size	.Ltypeof_0_asm_h, .Lfunc_end47-.Ltypeof_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function mul_0_asm_h
	.type	.Lmul_0_asm_h,@function
.Lmul_0_asm_h:                          // @mul_0_asm_h
// %bb.0:                               // %B41
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB48_5
// %bb.1:                               // %B23
	smull	x8, w22, w21
	sub	x20, x20, #16
	cmp	x8, w8, sxtw
	b.ne	.LBB48_11
// %bb.2:                               // %B30
	cbnz	w8, .LBB48_4
// %bb.3:                               // %B30
	orr	w9, w22, w21
	tbnz	w9, #31, .LBB48_12
.LBB48_4:                               // %B37
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB48_5:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB48_13
// %bb.6:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB48_13
// %bb.7:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB48_15
// %bb.8:                               // %B5
	fmov	d0, x9
	cmp	x8, x10
	b.hs	.LBB48_16
.LBB48_9:                               // %B7
	fmov	d1, x8
.LBB48_10:                              // %B13
	fmul	d0, d0, d1
	ldrb	w8, [x19], #1
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #16
	add	x8, x25, x8, lsl #3
	fmov	x9, d0
	fcmp	d0, d0
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB48_11:                              // %B25
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x9, #562949953421312            // =0x2000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	fmul	d0, d0, d1
	ldr	x1, [x8, #1944]
	fmov	x8, d0
	add	x22, x8, x9
	br	x1
.LBB48_12:                              // %B34
	mov	x22, #-9222809086901354496      // =0x8002000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB48_13:                              // %B38
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        // =0x9a
	str	x20, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB48_17
// %bb.14:                              // %B40
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB48_15:                              // %B18
	scvtf	d0, w22
	b	.LBB48_9
.LBB48_16:                              // %B13
	scvtf	d1, w21
	b	.LBB48_10
.LBB48_17:                              // %B39
	b	.Lexception_asm_h
.Lfunc_end48:
	.size	.Lmul_0_asm_h, .Lfunc_end48-.Lmul_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function div_0_asm_h
	.type	.Ldiv_0_asm_h,@function
.Ldiv_0_asm_h:                          // @div_0_asm_h
// %bb.0:                               // %B34
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB49_2
// %bb.1:                               // %B23
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	mov	x12, #9221683186994511872       // =0x7ffa000000000000
	sub	x20, x20, #16
	add	x8, x25, x8, lsl #3
	fdiv	d0, d0, d1
	ldr	x1, [x8, #1944]
	fcvtzs	w9, d0
	fmov	x11, d0
	fcmp	d0, d0
	add	x10, x11, x10
	csel	x10, x12, x10, vs
	cmp	x9, x11
	orr	x8, x9, #0xfffe000000000000
	csel	x22, x8, x10, eq
	br	x1
.LBB49_2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB49_8
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB49_8
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB49_10
// %bb.5:                               // %B5
	fmov	d0, x9
	cmp	x8, x10
	b.hs	.LBB49_11
.LBB49_6:                               // %B7
	fmov	d1, x8
.LBB49_7:                               // %B13
	fdiv	d0, d0, d1
	ldrb	w8, [x19], #1
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #16
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB49_8:                               // %B31
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        // =0x9b
	str	x20, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB49_12
// %bb.9:                               // %B33
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB49_10:                              // %B18
	scvtf	d0, w22
	b	.LBB49_6
.LBB49_11:                              // %B13
	scvtf	d1, w21
	b	.LBB49_7
.LBB49_12:                              // %B32
	b	.Lexception_asm_h
.Lfunc_end49:
	.size	.Ldiv_0_asm_h, .Lfunc_end49-.Ldiv_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function mod_0_asm_h
	.type	.Lmod_0_asm_h,@function
.Lmod_0_asm_h:                          // @mod_0_asm_h
// %bb.0:                               // %B30
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB50_4
// %bb.1:                               // %B24
	tbnz	w22, #31, .LBB50_10
// %bb.2:                               // %B24
	cmp	w21, #1
	b.lt	.LBB50_10
// %bb.3:                               // %B26
	udiv	w8, w22, w21
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB50_4:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB50_10
// %bb.5:                               // %B1
	add	x8, x21, x8
	cmp	x8, x10
	b.hi	.LBB50_10
// %bb.6:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB50_13
// %bb.7:                               // %B5
	fmov	d0, x9
	cmp	x8, x10
	b.hs	.LBB50_14
.LBB50_8:                               // %B7
	fmov	d1, x8
.LBB50_9:                               // %B13
	bl	fmod
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #16
	add	x8, x25, x8, lsl #3
	add	x9, x9, x10
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x8, x9, vs
	br	x1
.LBB50_10:                              // %B27
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        // =0x9c
	str	x20, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB50_12
// %bb.11:                              // %B29
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB50_12:                              // %B28
	b	.Lexception_asm_h
.LBB50_13:                              // %B18
	scvtf	d0, w22
	b	.LBB50_8
.LBB50_14:                              // %B13
	scvtf	d1, w21
	b	.LBB50_9
.Lfunc_end50:
	.size	.Lmod_0_asm_h, .Lfunc_end50-.Lmod_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_0_asm_h
	.type	.Ladd_0_asm_h,@function
.Ladd_0_asm_h:                          // @add_0_asm_h
// %bb.0:                               // %B30
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB51_3
// %bb.1:                               // %B23
	adds	w8, w22, w21
	sub	x20, x20, #16
	b.vs	.LBB51_9
// %bb.2:                               // %B29
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB51_3:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB51_10
// %bb.4:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB51_10
// %bb.5:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB51_11
// %bb.6:                               // %B5
	fmov	d0, x9
	cmp	x8, x10
	b.hs	.LBB51_12
.LBB51_7:                               // %B7
	fmov	d1, x8
.LBB51_8:                               // %B13
	fadd	d0, d0, d1
	ldrb	w8, [x19], #1
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #16
	add	x8, x25, x8, lsl #3
	fmov	x9, d0
	fcmp	d0, d0
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB51_9:                               // %B25
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x9, #562949953421312            // =0x2000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	fadd	d0, d0, d1
	ldr	x1, [x8, #1944]
	fmov	x8, d0
	add	x22, x8, x9
	br	x1
.LBB51_10:                              // %B22
	mov	x0, xzr
	b	.LSlowJSAdd_asm_h
.LBB51_11:                              // %B18
	scvtf	d0, w22
	b	.LBB51_7
.LBB51_12:                              // %B13
	scvtf	d1, w21
	b	.LBB51_8
.Lfunc_end51:
	.size	.Ladd_0_asm_h, .Lfunc_end51-.Ladd_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function sub_0_asm_h
	.type	.Lsub_0_asm_h,@function
.Lsub_0_asm_h:                          // @sub_0_asm_h
// %bb.0:                               // %B33
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB52_3
// %bb.1:                               // %B23
	subs	w8, w22, w21
	sub	x20, x20, #16
	b.vs	.LBB52_9
// %bb.2:                               // %B29
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB52_3:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB52_10
// %bb.4:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB52_10
// %bb.5:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB52_12
// %bb.6:                               // %B5
	fmov	d0, x9
	cmp	x8, x10
	b.hs	.LBB52_13
.LBB52_7:                               // %B7
	fmov	d1, x8
.LBB52_8:                               // %B13
	fsub	d0, d0, d1
	ldrb	w8, [x19], #1
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #16
	add	x8, x25, x8, lsl #3
	fmov	x9, d0
	fcmp	d0, d0
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB52_9:                               // %B25
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x9, #562949953421312            // =0x2000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	fsub	d0, d0, d1
	ldr	x1, [x8, #1944]
	fmov	x8, d0
	add	x22, x8, x9
	br	x1
.LBB52_10:                              // %B30
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        // =0x9e
	str	x20, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB52_14
// %bb.11:                              // %B32
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB52_12:                              // %B18
	scvtf	d0, w22
	b	.LBB52_7
.LBB52_13:                              // %B13
	scvtf	d1, w21
	b	.LBB52_8
.LBB52_14:                              // %B31
	b	.Lexception_asm_h
.Lfunc_end52:
	.size	.Lsub_0_asm_h, .Lfunc_end52-.Lsub_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function shl_0_asm_h
	.type	.Lshl_0_asm_h,@function
.Lshl_0_asm_h:                          // @shl_0_asm_h
// %bb.0:                               // %B19
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB53_3
// %bb.1:                               // %B20
	mov	w8, w22
.LBB53_2:                               // %B12
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #16
	add	x9, x25, x9, lsl #3
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	br	x1
.LBB53_3:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB53_5
// %bb.4:                               // %B2
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB53_8
.LBB53_5:                               // %B16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        // =0xa0
	str	x20, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB53_7
// %bb.6:                               // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB53_7:                               // %B17
	b	.Lexception_asm_h
.LBB53_8:                               // %B10
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB53_5
// %bb.9:                               // %B11
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB53_2
.Lfunc_end53:
	.size	.Lshl_0_asm_h, .Lfunc_end53-.Lshl_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function sar_0_asm_h
	.type	.Lsar_0_asm_h,@function
.Lsar_0_asm_h:                          // @sar_0_asm_h
// %bb.0:                               // %B19
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB54_3
// %bb.1:                               // %B20
	mov	w8, w22
.LBB54_2:                               // %B12
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #16
	add	x9, x25, x9, lsl #3
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	br	x1
.LBB54_3:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB54_5
// %bb.4:                               // %B2
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB54_8
.LBB54_5:                               // %B16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        // =0xa1
	str	x20, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB54_7
// %bb.6:                               // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB54_7:                               // %B17
	b	.Lexception_asm_h
.LBB54_8:                               // %B10
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB54_5
// %bb.9:                               // %B11
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB54_2
.Lfunc_end54:
	.size	.Lsar_0_asm_h, .Lfunc_end54-.Lsar_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function shr_0_asm_h
	.type	.Lshr_0_asm_h,@function
.Lshr_0_asm_h:                          // @shr_0_asm_h
// %bb.0:                               // %B27
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB55_3
// %bb.1:                               // %B28
	mov	w8, w22
.LBB55_2:                               // %B1
	lsr	w8, w8, w21
	ldrb	w9, [x19], #1
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #16
	ucvtf	d0, w8
	add	x9, x25, x9, lsl #3
	tst	w8, #0x80000000
	orr	x8, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	fmov	x11, d0
	add	x10, x11, x10
	csel	x22, x10, x8, ne
	br	x1
.LBB55_3:                               // %B10
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB55_5
// %bb.4:                               // %B10
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB55_8
.LBB55_5:                               // %B24
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	.LBB55_7
// %bb.6:                               // %B26
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB55_7:                               // %B25
	b	.Lexception_asm_h
.LBB55_8:                               // %B18
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB55_5
// %bb.9:                               // %B19
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB55_2
.Lfunc_end55:
	.size	.Lshr_0_asm_h, .Lfunc_end55-.Lshr_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lt_0_asm_h
	.type	.Llt_0_asm_h,@function
.Llt_0_asm_h:                           // @lt_0_asm_h
// %bb.0:                               // %B14
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB56_2
// %bb.1:                               // %B15
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, lt
	br	x1
.LBB56_2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB56_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB56_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB56_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB56_10
.LBB56_6:                               // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB56_7:                               // %B11
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        // =0xa3
	str	x20, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB56_11
// %bb.8:                               // %B13
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB56_9:                               // %B9
	scvtf	d0, w22
	b	.LBB56_6
.LBB56_10:                              // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB56_11:                              // %B12
	b	.Lexception_asm_h
.Lfunc_end56:
	.size	.Llt_0_asm_h, .Lfunc_end56-.Llt_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lte_0_asm_h
	.type	.Llte_0_asm_h,@function
.Llte_0_asm_h:                          // @lte_0_asm_h
// %bb.0:                               // %B14
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB57_2
// %bb.1:                               // %B15
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, le
	br	x1
.LBB57_2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB57_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB57_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB57_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB57_10
.LBB57_6:                               // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB57_7:                               // %B11
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        // =0xa4
	str	x20, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB57_11
// %bb.8:                               // %B13
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB57_9:                               // %B9
	scvtf	d0, w22
	b	.LBB57_6
.LBB57_10:                              // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB57_11:                              // %B12
	b	.Lexception_asm_h
.Lfunc_end57:
	.size	.Llte_0_asm_h, .Lfunc_end57-.Llte_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gt_0_asm_h
	.type	.Lgt_0_asm_h,@function
.Lgt_0_asm_h:                           // @gt_0_asm_h
// %bb.0:                               // %B14
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB58_2
// %bb.1:                               // %B15
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB58_2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB58_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB58_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB58_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB58_10
.LBB58_6:                               // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB58_7:                               // %B11
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        // =0xa5
	str	x20, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB58_11
// %bb.8:                               // %B13
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB58_9:                               // %B9
	scvtf	d0, w22
	b	.LBB58_6
.LBB58_10:                              // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB58_11:                              // %B12
	b	.Lexception_asm_h
.Lfunc_end58:
	.size	.Lgt_0_asm_h, .Lfunc_end58-.Lgt_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gte_0_asm_h
	.type	.Lgte_0_asm_h,@function
.Lgte_0_asm_h:                          // @gte_0_asm_h
// %bb.0:                               // %B14
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB59_2
// %bb.1:                               // %B15
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB59_2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB59_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB59_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB59_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB59_10
.LBB59_6:                               // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB59_7:                               // %B11
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        // =0xa6
	str	x20, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB59_11
// %bb.8:                               // %B13
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB59_9:                               // %B9
	scvtf	d0, w22
	b	.LBB59_6
.LBB59_10:                              // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB59_11:                              // %B12
	b	.Lexception_asm_h
.Lfunc_end59:
	.size	.Lgte_0_asm_h, .Lfunc_end59-.Lgte_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function eq_0_asm_h
	.type	.Leq_0_asm_h,@function
.Leq_0_asm_h:                           // @eq_0_asm_h
// %bb.0:                               // %B34
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB60_2
// %bb.1:                               // %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB60_2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB60_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB60_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB60_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB60_10
.LBB60_6:                               // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB60_7:                               // %B11
	cmp	x22, x21
	b.ne	.LBB60_11
.LBB60_8:                               // %B12
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB60_9:                               // %B9
	scvtf	d0, w22
	b	.LBB60_6
.LBB60_10:                              // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB60_11:                              // %B14
	and	x8, x21, #0xffffffffffffffef
	cmp	x8, #2
	and	x8, x22, #0xffffffffffffffef
	b.ne	.LBB60_13
// %bb.12:                              // %B16
	cmp	x8, #2
	b.ne	.LBB60_16
	b	.LBB60_8
.LBB60_13:                              // %B21
	cmp	x8, #2
	b.eq	.LBB60_16
// %bb.14:                              // %B24
	and	x8, x21, #0xfffffffffffffffe
	cmp	x8, #6
	b.ne	.LBB60_17
// %bb.15:                              // %B24
	and	x8, x22, #0xfffffffffffffffe
	cmp	x8, #6
	b.ne	.LBB60_17
.LBB60_16:                              // %B19
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB60_17:                              // %B31
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x23, #48]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB60_19
// %bb.18:                              // %B33
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB60_19:                              // %B32
	b	.Lexception_asm_h
.Lfunc_end60:
	.size	.Leq_0_asm_h, .Lfunc_end60-.Leq_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function neq_0_asm_h
	.type	.Lneq_0_asm_h,@function
.Lneq_0_asm_h:                          // @neq_0_asm_h
// %bb.0:                               // %B34
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB61_2
// %bb.1:                               // %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB61_2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB61_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB61_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB61_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB61_10
.LBB61_6:                               // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB61_7:                               // %B11
	cmp	x22, x21
	b.ne	.LBB61_11
.LBB61_8:                               // %B12
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB61_9:                               // %B9
	scvtf	d0, w22
	b	.LBB61_6
.LBB61_10:                              // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB61_11:                              // %B14
	and	x8, x21, #0xffffffffffffffef
	cmp	x8, #2
	and	x8, x22, #0xffffffffffffffef
	b.ne	.LBB61_13
// %bb.12:                              // %B16
	cmp	x8, #2
	b.ne	.LBB61_16
	b	.LBB61_8
.LBB61_13:                              // %B21
	cmp	x8, #2
	b.eq	.LBB61_16
// %bb.14:                              // %B24
	and	x8, x21, #0xfffffffffffffffe
	cmp	x8, #6
	b.ne	.LBB61_17
// %bb.15:                              // %B24
	and	x8, x22, #0xfffffffffffffffe
	cmp	x8, #6
	b.ne	.LBB61_17
.LBB61_16:                              // %B19
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB61_17:                              // %B31
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x20, [x23, #48]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB61_19
// %bb.18:                              // %B33
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB61_19:                              // %B32
	b	.Lexception_asm_h
.Lfunc_end61:
	.size	.Lneq_0_asm_h, .Lfunc_end61-.Lneq_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function strict_eq_0_asm_h
	.type	.Lstrict_eq_0_asm_h,@function
.Lstrict_eq_0_asm_h:                    // @strict_eq_0_asm_h
// %bb.0:                               // %B29
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB62_2
// %bb.1:                               // %B30
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB62_2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB62_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB62_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB62_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB62_10
.LBB62_6:                               // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB62_7:                               // %B11
	cmp	x22, x21
	b.ne	.LBB62_11
// %bb.8:                               // %B12
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB62_9:                               // %B9
	scvtf	d0, w22
	b	.LBB62_6
.LBB62_10:                              // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB62_11:                              // %B14
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x9, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w10, eq
	cmp	x9, x11
	ccmp	x9, x12, #4, ne
	cset	w11, eq
	cmp	w10, #1
	b.ne	.LBB62_13
// %bb.12:                              // %B14
	cbnz	w11, .LBB62_18
.LBB62_13:                              // %B17
	mov	x12, #2                         // =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w13, ne
	cmp	x9, x12
	bic	w12, w13, w10
	csinc	w10, w11, wzr, ne
	tbnz	w12, #0, .LBB62_15
// %bb.14:                              // %B17
	tbnz	w10, #0, .LBB62_19
.LBB62_15:                              // %B20
	mov	x10, #-281474976710656          // =0xffff000000000000
	cmp	x8, x10
	b.ne	.LBB62_17
// %bb.16:                              // %B20
	cmp	x9, x10
	b.eq	.LBB62_21
.LBB62_17:                              // %B25
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB62_18:                              // %B15
	mov	x0, xzr
	b	.LFastStringEqual_asm_h
.LBB62_19:                              // %B26
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x23, #48]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB62_23
// %bb.20:                              // %B28
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB62_21:                              // %B22
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #16
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB62_24
// %bb.22:                              // %B24
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB62_23:                              // %B27
	b	.Lexception_asm_h
.LBB62_24:                              // %B23
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end62:
	.size	.Lstrict_eq_0_asm_h, .Lfunc_end62-.Lstrict_eq_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function strict_neq_0_asm_h
	.type	.Lstrict_neq_0_asm_h,@function
.Lstrict_neq_0_asm_h:                   // @strict_neq_0_asm_h
// %bb.0:                               // %B29
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB63_2
// %bb.1:                               // %B30
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB63_2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB63_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB63_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB63_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB63_10
.LBB63_6:                               // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB63_7:                               // %B11
	cmp	x22, x21
	b.ne	.LBB63_11
// %bb.8:                               // %B12
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB63_9:                               // %B9
	scvtf	d0, w22
	b	.LBB63_6
.LBB63_10:                              // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB63_11:                              // %B14
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x9, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w10, eq
	cmp	x9, x11
	ccmp	x9, x12, #4, ne
	cset	w11, eq
	cmp	w10, #1
	b.ne	.LBB63_13
// %bb.12:                              // %B14
	cbnz	w11, .LBB63_18
.LBB63_13:                              // %B17
	mov	x12, #2                         // =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w13, ne
	cmp	x9, x12
	bic	w12, w13, w10
	csinc	w10, w11, wzr, ne
	tbnz	w12, #0, .LBB63_15
// %bb.14:                              // %B17
	tbnz	w10, #0, .LBB63_19
.LBB63_15:                              // %B20
	mov	x10, #-281474976710656          // =0xffff000000000000
	cmp	x8, x10
	b.ne	.LBB63_17
// %bb.16:                              // %B20
	cmp	x9, x10
	b.eq	.LBB63_21
.LBB63_17:                              // %B25
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB63_18:                              // %B15
	mov	w0, #1                          // =0x1
	b	.LFastStringEqual_asm_h
.LBB63_19:                              // %B26
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x20, [x23, #48]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB63_23
// %bb.20:                              // %B28
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB63_21:                              // %B22
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #16
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB63_24
// %bb.22:                              // %B24
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB63_23:                              // %B27
	b	.Lexception_asm_h
.LBB63_24:                              // %B23
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end63:
	.size	.Lstrict_neq_0_asm_h, .Lfunc_end63-.Lstrict_neq_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function and_0_asm_h
	.type	.Land_0_asm_h,@function
.Land_0_asm_h:                          // @and_0_asm_h
// %bb.0:                               // %B19
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB64_3
// %bb.1:                               // %B20
	mov	w8, w22
.LBB64_2:                               // %B12
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	and	w8, w8, w21
	add	x9, x25, x9, lsl #3
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	br	x1
.LBB64_3:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB64_5
// %bb.4:                               // %B2
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB64_8
.LBB64_5:                               // %B16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        // =0xad
	str	x20, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB64_7
// %bb.6:                               // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB64_7:                               // %B17
	b	.Lexception_asm_h
.LBB64_8:                               // %B10
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB64_5
// %bb.9:                               // %B11
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB64_2
.Lfunc_end64:
	.size	.Land_0_asm_h, .Lfunc_end64-.Land_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function xor_0_asm_h
	.type	.Lxor_0_asm_h,@function
.Lxor_0_asm_h:                          // @xor_0_asm_h
// %bb.0:                               // %B19
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB65_3
// %bb.1:                               // %B20
	mov	w8, w22
.LBB65_2:                               // %B12
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	eor	w8, w8, w21
	add	x9, x25, x9, lsl #3
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	br	x1
.LBB65_3:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB65_5
// %bb.4:                               // %B2
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB65_8
.LBB65_5:                               // %B16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        // =0xae
	str	x20, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB65_7
// %bb.6:                               // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB65_7:                               // %B17
	b	.Lexception_asm_h
.LBB65_8:                               // %B10
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB65_5
// %bb.9:                               // %B11
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB65_2
.Lfunc_end65:
	.size	.Lxor_0_asm_h, .Lfunc_end65-.Lxor_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function or_0_asm_h
	.type	.Lor_0_asm_h,@function
.Lor_0_asm_h:                           // @or_0_asm_h
// %bb.0:                               // %B19
	ldp	x22, x21, [x20, #-16]
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB66_3
// %bb.1:                               // %B20
	mov	w8, w22
.LBB66_2:                               // %B12
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	orr	w8, w8, w21
	add	x9, x25, x9, lsl #3
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	br	x1
.LBB66_3:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB66_5
// %bb.4:                               // %B2
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB66_8
.LBB66_5:                               // %B16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        // =0xaf
	str	x20, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB66_7
// %bb.6:                               // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB66_7:                               // %B17
	b	.Lexception_asm_h
.LBB66_8:                               // %B10
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB66_5
// %bb.9:                               // %B11
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB66_2
.Lfunc_end66:
	.size	.Lor_0_asm_h, .Lfunc_end66-.Lor_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_minus1_0_asm_h
	.type	.Lpush_minus1_0_asm_h,@function
.Lpush_minus1_0_asm_h:                  // @push_minus1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562945658454017          // =0xfffe0000ffffffff
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end67:
	.size	.Lpush_minus1_0_asm_h, .Lfunc_end67-.Lpush_minus1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_0_0_asm_h
	.type	.Lpush_0_0_asm_h,@function
.Lpush_0_0_asm_h:                       // @push_0_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421312          // =0xfffe000000000000
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end68:
	.size	.Lpush_0_0_asm_h, .Lfunc_end68-.Lpush_0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_1_0_asm_h
	.type	.Lpush_1_0_asm_h,@function
.Lpush_1_0_asm_h:                       // @push_1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421311          // =0xfffe000000000001
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end69:
	.size	.Lpush_1_0_asm_h, .Lfunc_end69-.Lpush_1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_2_0_asm_h
	.type	.Lpush_2_0_asm_h,@function
.Lpush_2_0_asm_h:                       // @push_2_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #2                         // =0x2
	movk	x22, #65534, lsl #48
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end70:
	.size	.Lpush_2_0_asm_h, .Lfunc_end70-.Lpush_2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_3_0_asm_h
	.type	.Lpush_3_0_asm_h,@function
.Lpush_3_0_asm_h:                       // @push_3_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421309          // =0xfffe000000000003
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end71:
	.size	.Lpush_3_0_asm_h, .Lfunc_end71-.Lpush_3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_4_0_asm_h
	.type	.Lpush_4_0_asm_h,@function
.Lpush_4_0_asm_h:                       // @push_4_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #4                         // =0x4
	movk	x22, #65534, lsl #48
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end72:
	.size	.Lpush_4_0_asm_h, .Lfunc_end72-.Lpush_4_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_5_0_asm_h
	.type	.Lpush_5_0_asm_h,@function
.Lpush_5_0_asm_h:                       // @push_5_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #5                         // =0x5
	movk	x22, #65534, lsl #48
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end73:
	.size	.Lpush_5_0_asm_h, .Lfunc_end73-.Lpush_5_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_6_0_asm_h
	.type	.Lpush_6_0_asm_h,@function
.Lpush_6_0_asm_h:                       // @push_6_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #6                         // =0x6
	movk	x22, #65534, lsl #48
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end74:
	.size	.Lpush_6_0_asm_h, .Lfunc_end74-.Lpush_6_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_7_0_asm_h
	.type	.Lpush_7_0_asm_h,@function
.Lpush_7_0_asm_h:                       // @push_7_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421305          // =0xfffe000000000007
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end75:
	.size	.Lpush_7_0_asm_h, .Lfunc_end75-.Lpush_7_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i8_0_asm_h
	.type	.Lpush_i8_0_asm_h,@function
.Lpush_i8_0_asm_h:                      // @push_i8_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #1]
	ldrsb	w9, [x19]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	orr	x22, x9, #0xfffe000000000000
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end76:
	.size	.Lpush_i8_0_asm_h, .Lfunc_end76-.Lpush_i8_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i16_0_asm_h
	.type	.Lpush_i16_0_asm_h,@function
.Lpush_i16_0_asm_h:                     // @push_i16_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	ldrsh	w9, [x19]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	orr	x22, x9, #0xfffe000000000000
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end77:
	.size	.Lpush_i16_0_asm_h, .Lfunc_end77-.Lpush_i16_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_const8_0_asm_h
	.type	.Lpush_const8_0_asm_h,@function
.Lpush_const8_0_asm_h:                  // @push_const8_0_asm_h
// %bb.0:                               // %B0
	ldrb	w9, [x19, #1]
	ldr	x8, [x23, #104]
	ldrb	w10, [x19], #2
	add	x9, x25, x9, lsl #3
	ldr	x22, [x8, x10, lsl #3]
	ldr	x1, [x9, #1944]
	br	x1
.Lfunc_end78:
	.size	.Lpush_const8_0_asm_h, .Lfunc_end78-.Lpush_const8_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function fclosure8_0_asm_h
	.type	.Lfclosure8_0_asm_h,@function
.Lfclosure8_0_asm_h:                    // @fclosure8_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #104]
	ldrb	w9, [x19]
	ldr	x0, [x8, x9, lsl #3]
	b	.LFastFclosure_asm_h
.Lfunc_end79:
	.size	.Lfclosure8_0_asm_h, .Lfunc_end79-.Lfclosure8_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc8_0_asm_h
	.type	.Lget_loc8_0_asm_h,@function
.Lget_loc8_0_asm_h:                     // @get_loc8_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #1]
	ldrb	w9, [x19], #2
	add	x8, x25, x8, lsl #3
	ldr	x22, [x27, x9, lsl #3]
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end80:
	.size	.Lget_loc8_0_asm_h, .Lfunc_end80-.Lget_loc8_0_asm_h
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
.Lfunc_end81:
	.size	.Lput_loc8_0_asm_h, .Lfunc_end81-.Lput_loc8_0_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end82:
	.size	.Lset_loc8_0_asm_h, .Lfunc_end82-.Lset_loc8_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc0_0_asm_h
	.type	.Lget_loc0_0_asm_h,@function
.Lget_loc0_0_asm_h:                     // @get_loc0_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end83:
	.size	.Lget_loc0_0_asm_h, .Lfunc_end83-.Lget_loc0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc1_0_asm_h
	.type	.Lget_loc1_0_asm_h,@function
.Lget_loc1_0_asm_h:                     // @get_loc1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27, #8]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end84:
	.size	.Lget_loc1_0_asm_h, .Lfunc_end84-.Lget_loc1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc2_0_asm_h
	.type	.Lget_loc2_0_asm_h,@function
.Lget_loc2_0_asm_h:                     // @get_loc2_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27, #16]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end85:
	.size	.Lget_loc2_0_asm_h, .Lfunc_end85-.Lget_loc2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc3_0_asm_h
	.type	.Lget_loc3_0_asm_h,@function
.Lget_loc3_0_asm_h:                     // @get_loc3_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27, #24]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end86:
	.size	.Lget_loc3_0_asm_h, .Lfunc_end86-.Lget_loc3_0_asm_h
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
.Lfunc_end87:
	.size	.Lput_loc0_0_asm_h, .Lfunc_end87-.Lput_loc0_0_asm_h
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
.Lfunc_end88:
	.size	.Lput_loc1_0_asm_h, .Lfunc_end88-.Lput_loc1_0_asm_h
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
.Lfunc_end89:
	.size	.Lput_loc2_0_asm_h, .Lfunc_end89-.Lput_loc2_0_asm_h
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
.Lfunc_end90:
	.size	.Lput_loc3_0_asm_h, .Lfunc_end90-.Lput_loc3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc0_0_asm_h
	.type	.Lset_loc0_0_asm_h,@function
.Lset_loc0_0_asm_h:                     // @set_loc0_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end91:
	.size	.Lset_loc0_0_asm_h, .Lfunc_end91-.Lset_loc0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc1_0_asm_h
	.type	.Lset_loc1_0_asm_h,@function
.Lset_loc1_0_asm_h:                     // @set_loc1_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end92:
	.size	.Lset_loc1_0_asm_h, .Lfunc_end92-.Lset_loc1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc2_0_asm_h
	.type	.Lset_loc2_0_asm_h,@function
.Lset_loc2_0_asm_h:                     // @set_loc2_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end93:
	.size	.Lset_loc2_0_asm_h, .Lfunc_end93-.Lset_loc2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc3_0_asm_h
	.type	.Lset_loc3_0_asm_h,@function
.Lset_loc3_0_asm_h:                     // @set_loc3_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end94:
	.size	.Lset_loc3_0_asm_h, .Lfunc_end94-.Lset_loc3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg0_0_asm_h
	.type	.Lget_arg0_0_asm_h,@function
.Lget_arg0_0_asm_h:                     // @get_arg0_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end95:
	.size	.Lget_arg0_0_asm_h, .Lfunc_end95-.Lget_arg0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg1_0_asm_h
	.type	.Lget_arg1_0_asm_h,@function
.Lget_arg1_0_asm_h:                     // @get_arg1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28, #8]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end96:
	.size	.Lget_arg1_0_asm_h, .Lfunc_end96-.Lget_arg1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg2_0_asm_h
	.type	.Lget_arg2_0_asm_h,@function
.Lget_arg2_0_asm_h:                     // @get_arg2_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28, #16]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end97:
	.size	.Lget_arg2_0_asm_h, .Lfunc_end97-.Lget_arg2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg3_0_asm_h
	.type	.Lget_arg3_0_asm_h,@function
.Lget_arg3_0_asm_h:                     // @get_arg3_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28, #24]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end98:
	.size	.Lget_arg3_0_asm_h, .Lfunc_end98-.Lget_arg3_0_asm_h
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
.Lfunc_end99:
	.size	.Lput_arg0_0_asm_h, .Lfunc_end99-.Lput_arg0_0_asm_h
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
.Lfunc_end100:
	.size	.Lput_arg1_0_asm_h, .Lfunc_end100-.Lput_arg1_0_asm_h
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
.Lfunc_end101:
	.size	.Lput_arg2_0_asm_h, .Lfunc_end101-.Lput_arg2_0_asm_h
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
.Lfunc_end102:
	.size	.Lput_arg3_0_asm_h, .Lfunc_end102-.Lput_arg3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref0_0_asm_h
	.type	.Lget_var_ref0_0_asm_h,@function
.Lget_var_ref0_0_asm_h:                 // @get_var_ref0_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x9, [x26]
	add	x8, x25, x8, lsl #3
	ldr	x9, [x9]
	ldr	x1, [x8, #1944]
	ldr	x22, [x9]
	br	x1
.Lfunc_end103:
	.size	.Lget_var_ref0_0_asm_h, .Lfunc_end103-.Lget_var_ref0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref1_0_asm_h
	.type	.Lget_var_ref1_0_asm_h,@function
.Lget_var_ref1_0_asm_h:                 // @get_var_ref1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x9, [x26, #8]
	add	x8, x25, x8, lsl #3
	ldr	x9, [x9]
	ldr	x1, [x8, #1944]
	ldr	x22, [x9]
	br	x1
.Lfunc_end104:
	.size	.Lget_var_ref1_0_asm_h, .Lfunc_end104-.Lget_var_ref1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref2_0_asm_h
	.type	.Lget_var_ref2_0_asm_h,@function
.Lget_var_ref2_0_asm_h:                 // @get_var_ref2_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x9, [x26, #16]
	add	x8, x25, x8, lsl #3
	ldr	x9, [x9]
	ldr	x1, [x8, #1944]
	ldr	x22, [x9]
	br	x1
.Lfunc_end105:
	.size	.Lget_var_ref2_0_asm_h, .Lfunc_end105-.Lget_var_ref2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref3_0_asm_h
	.type	.Lget_var_ref3_0_asm_h,@function
.Lget_var_ref3_0_asm_h:                 // @get_var_ref3_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x9, [x26, #24]
	add	x8, x25, x8, lsl #3
	ldr	x9, [x9]
	ldr	x1, [x8, #1944]
	ldr	x22, [x9]
	br	x1
.Lfunc_end106:
	.size	.Lget_var_ref3_0_asm_h, .Lfunc_end106-.Lget_var_ref3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref0_0_asm_h
	.type	.Lput_var_ref0_0_asm_h,@function
.Lput_var_ref0_0_asm_h:                 // @put_var_ref0_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end107:
	.size	.Lput_var_ref0_0_asm_h, .Lfunc_end107-.Lput_var_ref0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref1_0_asm_h
	.type	.Lput_var_ref1_0_asm_h,@function
.Lput_var_ref1_0_asm_h:                 // @put_var_ref1_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end108:
	.size	.Lput_var_ref1_0_asm_h, .Lfunc_end108-.Lput_var_ref1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref2_0_asm_h
	.type	.Lput_var_ref2_0_asm_h,@function
.Lput_var_ref2_0_asm_h:                 // @put_var_ref2_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end109:
	.size	.Lput_var_ref2_0_asm_h, .Lfunc_end109-.Lput_var_ref2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref3_0_asm_h
	.type	.Lput_var_ref3_0_asm_h,@function
.Lput_var_ref3_0_asm_h:                 // @put_var_ref3_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end110:
	.size	.Lput_var_ref3_0_asm_h, .Lfunc_end110-.Lput_var_ref3_0_asm_h
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
	b.ne	.LBB111_2
// %bb.1:                               // %B28
	ldrb	w8, [x19], #1
	and	x9, x22, #0xfffffffffffc
	ldr	w9, [x9, #4]
	mov	x10, #-562949953421312          // =0xfffe000000000000
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	bfxil	x10, x9, #0, #30
	ldr	x1, [x8, #1944]
	mov	x22, x10
	br	x1
.LBB111_2:                              // %B21
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB111_12
// %bb.3:                               // %B22
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB111_4:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB111_5 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	x11, x11, #0x30
	ldr	w11, [x13, x11, lsl #2]
	add	w12, w12, #4
	add	x12, x13, x12
	cbz	w11, .LBB111_7
.LBB111_5:                              // %B1
                                        //   Parent Loop BB111_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	ldr	x13, [x12, w13, uxtw]
	lsr	x14, x13, #32
	cmp	x14, #48
	b.eq	.LBB111_9
// %bb.6:                               // %B9
                                        //   in Loop: Header=BB111_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB111_5
.LBB111_7:                              // %B14
                                        //   in Loop: Header=BB111_4 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB111_12
// %bb.8:                               // %B17
                                        //   in Loop: Header=BB111_4 Depth=1
	ldr	x9, [x10, #32]
	cbnz	x9, .LBB111_4
	b	.LBB111_11
.LBB111_9:                              // %B3
	lsr	w8, w13, #30
	cbnz	w8, .LBB111_12
// %bb.10:                              // %B4
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB111_11:                             // %B6
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB111_12:                             // %B24
	mov	x0, x24
	mov	x1, x22
	mov	w2, #48                         // =0x30
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB111_14
// %bb.13:                              // %B26
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB111_14:                             // %B25
	b	.Lexception_asm_h
.Lfunc_end111:
	.size	.Lget_length_0_asm_h, .Lfunc_end111-.Lget_length_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_false8_0_asm_h
	.type	.Lif_false8_0_asm_h,@function
.Lif_false8_0_asm_h:                    // @if_false8_0_asm_h
// %bb.0:                               // %B25
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	sub	x9, x22, #6
	cmp	x9, #2
	b.hs	.LBB112_3
// %bb.1:                               // %B1
	cbz	x9, .LBB112_10
.LBB112_2:                              // %B6
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB112_3:                              // %B7
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x22, lsr #48
	b.ne	.LBB112_5
// %bb.4:                               // %B9
	cbnz	w22, .LBB112_2
	b	.LBB112_10
.LBB112_5:                              // %B13
	and	x9, x22, #0xffffffffffffffef
	cmp	x9, #2
	b.eq	.LBB112_10
// %bb.6:                               // %B16
	mov	x9, #2                          // =0x2
	movk	x9, #65535, lsl #48
	tst	x22, x9
	b.eq	.LBB112_2
// %bb.7:                               // %B19
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	add	x9, x22, x9
	cmp	x9, x10
	b.lo	.LBB112_9
// %bb.8:                               // %B24
	mov	x20, x8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.LBB112_9:                              // %B21
	fmov	d0, x9
	fcmp	d0, #0.0
	b.mi	.LBB112_2
	b.gt	.LBB112_2
.LBB112_10:                             // %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end112:
	.size	.Lif_false8_0_asm_h, .Lfunc_end112-.Lif_false8_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_true8_0_asm_h
	.type	.Lif_true8_0_asm_h,@function
.Lif_true8_0_asm_h:                     // @if_true8_0_asm_h
// %bb.0:                               // %B25
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	sub	x9, x22, #6
	cmp	x9, #2
	b.hs	.LBB113_3
// %bb.1:                               // %B1
	cbz	x9, .LBB113_10
.LBB113_2:                              // %B6
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB113_3:                              // %B7
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x22, lsr #48
	b.ne	.LBB113_5
// %bb.4:                               // %B9
	cbnz	w22, .LBB113_2
	b	.LBB113_10
.LBB113_5:                              // %B13
	and	x9, x22, #0xffffffffffffffef
	cmp	x9, #2
	b.eq	.LBB113_10
// %bb.6:                               // %B16
	mov	x9, #2                          // =0x2
	movk	x9, #65535, lsl #48
	tst	x22, x9
	b.eq	.LBB113_2
// %bb.7:                               // %B19
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	add	x9, x22, x9
	cmp	x9, x10
	b.lo	.LBB113_9
// %bb.8:                               // %B24
	mov	x20, x8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.LBB113_9:                              // %B21
	fmov	d0, x9
	fcmp	d0, #0.0
	b.mi	.LBB113_2
	b.gt	.LBB113_2
.LBB113_10:                             // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end113:
	.size	.Lif_true8_0_asm_h, .Lfunc_end113-.Lif_true8_0_asm_h
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
.Lfunc_end114:
	.size	.Lgoto8_0_asm_h, .Lfunc_end114-.Lgoto8_0_asm_h
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
.Lfunc_end115:
	.size	.Lgoto16_0_asm_h, .Lfunc_end115-.Lgoto16_0_asm_h
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
	b.eq	.LBB116_2
// %bb.1:                               // %B4
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB116_2:                              // %B3
	b	.Lexception_asm_h
.Lfunc_end116:
	.size	.Lcall0_0_asm_h, .Lfunc_end116-.Lcall0_0_asm_h
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
	b.eq	.LBB117_2
// %bb.1:                               // %B4
	stur	x0, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB117_2:                              // %B3
	b	.Lexception_asm_h
.Lfunc_end117:
	.size	.Lcall1_0_asm_h, .Lfunc_end117-.Lcall1_0_asm_h
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
	b.eq	.LBB118_2
// %bb.1:                               // %B4
	stur	x0, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB118_2:                              // %B3
	b	.Lexception_asm_h
.Lfunc_end118:
	.size	.Lcall2_0_asm_h, .Lfunc_end118-.Lcall2_0_asm_h
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
	b.eq	.LBB119_2
// %bb.1:                               // %B4
	stur	x0, [x20, #-32]
	sub	x20, x20, #24
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB119_2:                              // %B3
	b	.Lexception_asm_h
.Lfunc_end119:
	.size	.Lcall3_0_asm_h, .Lfunc_end119-.Lcall3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_undefined_0_asm_h
	.type	.Lis_undefined_0_asm_h,@function
.Lis_undefined_0_asm_h:                 // @is_undefined_0_asm_h
// %bb.0:                               // %B2
	ldur	x22, [x20, #-8]
	cmp	x22, #18
	b.ne	.LBB120_2
// %bb.1:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB120_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end120:
	.size	.Lis_undefined_0_asm_h, .Lfunc_end120-.Lis_undefined_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_null_0_asm_h
	.type	.Lis_null_0_asm_h,@function
.Lis_null_0_asm_h:                      // @is_null_0_asm_h
// %bb.0:                               // %B2
	ldur	x22, [x20, #-8]
	cmp	x22, #2
	b.ne	.LBB121_2
// %bb.1:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB121_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end121:
	.size	.Lis_null_0_asm_h, .Lfunc_end121-.Lis_null_0_asm_h
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
	b.ne	.LBB122_2
// %bb.1:                               // %B2
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB122_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end122:
	.size	.Lis_function_0_asm_h, .Lfunc_end122-.Lis_function_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i32_1_asm_h
	.type	.Lpush_i32_1_asm_h,@function
.Lpush_i32_1_asm_h:                     // @push_i32_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #4]
	ldr	w9, [x19], #5
	add	x8, x25, x8, lsl #3
	orr	x21, x9, #0xfffe000000000000
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end123:
	.size	.Lpush_i32_1_asm_h, .Lfunc_end123-.Lpush_i32_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_const_1_asm_h
	.type	.Lpush_const_1_asm_h,@function
.Lpush_const_1_asm_h:                   // @push_const_1_asm_h
// %bb.0:                               // %B0
	ldrb	w9, [x19, #4]
	ldr	x8, [x23, #104]
	ldrsw	x10, [x19]
	add	x19, x19, #5
	add	x9, x25, x9, lsl #3
	ldr	x21, [x8, x10, lsl #3]
	ldr	x1, [x9, #3888]
	br	x1
.Lfunc_end124:
	.size	.Lpush_const_1_asm_h, .Lfunc_end124-.Lpush_const_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function fclosure_1_asm_h
	.type	.Lfclosure_1_asm_h,@function
.Lfclosure_1_asm_h:                     // @fclosure_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lfclosure_0_asm_h
.Lfunc_end125:
	.size	.Lfclosure_1_asm_h, .Lfunc_end125-.Lfclosure_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function undefined_1_asm_h
	.type	.Lundefined_1_asm_h,@function
.Lundefined_1_asm_h:                    // @undefined_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w21, #18                        // =0x12
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end126:
	.size	.Lundefined_1_asm_h, .Lfunc_end126-.Lundefined_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function null_1_asm_h
	.type	.Lnull_1_asm_h,@function
.Lnull_1_asm_h:                         // @null_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w21, #2                         // =0x2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end127:
	.size	.Lnull_1_asm_h, .Lfunc_end127-.Lnull_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_this_1_asm_h
	.type	.Lpush_this_1_asm_h,@function
.Lpush_this_1_asm_h:                    // @push_this_1_asm_h
// %bb.0:                               // %B12
	ldrb	w8, [x23, #44]
	ldr	x1, [x23, #80]
	tbnz	w8, #0, .LBB128_2
// %bb.1:                               // %B12
	and	x8, x1, #0xfffffffffffffffe
	and	x8, x8, #0xffff000000000003
	cbnz	x8, .LBB128_3
.LBB128_2:                              // %B3
	ldrb	w8, [x19], #1
	mov	x21, x1
	add	x8, x25, x8, lsl #3
	ldr	x2, [x8, #3888]
	br	x2
.LBB128_3:                              // %B6
	orr	x8, x1, #0x10
	cmp	x8, #18
	b.ne	.LBB128_5
// %bb.4:                               // %B7
	ldrb	w8, [x19], #1
	ldr	x21, [x24, #208]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB128_5:                              // %B9
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB128_7
// %bb.6:                               // %B11
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB128_7:                              // %B10
	b	.Lexception_spill_top0_asm_h
.Lfunc_end128:
	.size	.Lpush_this_1_asm_h, .Lfunc_end128-.Lpush_this_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_false_1_asm_h
	.type	.Lpush_false_1_asm_h,@function
.Lpush_false_1_asm_h:                   // @push_false_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w21, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end129:
	.size	.Lpush_false_1_asm_h, .Lfunc_end129-.Lpush_false_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_true_1_asm_h
	.type	.Lpush_true_1_asm_h,@function
.Lpush_true_1_asm_h:                    // @push_true_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w21, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end130:
	.size	.Lpush_true_1_asm_h, .Lfunc_end130-.Lpush_true_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function object_1_asm_h
	.type	.Lobject_1_asm_h,@function
.Lobject_1_asm_h:                       // @object_1_asm_h
// %bb.0:                               // %B15
	ldrb	w8, [x24, #355]
	cbnz	w8, .LBB131_6
// %bb.1:                               // %B1
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB131_6
// %bb.2:                               // %B5
	ldr	x8, [x24, #392]
	cbz	x8, .LBB131_6
// %bb.3:                               // %B8
	mov	x8, x20
	mov	x0, x24
	mov	w1, #64                         // =0x40
	mov	w2, #2                          // =0x2
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	prim_try_malloc_gc
	cbz	x0, .LBB131_6
// %bb.4:                               // %B9
	ldr	x8, [x24, #392]
	ldr	w9, [x8]
	add	w9, w9, #1
	str	w9, [x8]
	mov	w9, #1                          // =0x1
	str	w9, [x0]
	strb	w9, [x0, #5]
	strh	w9, [x0, #6]
	add	x9, x0, #8
	stlr	x8, [x9]
	add	x8, x0, #32
	str	x8, [x0, #16]
.LBB131_5:                              // %B14
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB131_6:                              // %B12
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.ne	.LBB131_5
// %bb.7:                               // %B13
	b	.Lexception_spill_top0_asm_h
.Lfunc_end131:
	.size	.Lobject_1_asm_h, .Lfunc_end131-.Lobject_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function drop_1_asm_h
	.type	.Ldrop_1_asm_h,@function
.Ldrop_1_asm_h:                         // @drop_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end132:
	.size	.Ldrop_1_asm_h, .Lfunc_end132-.Ldrop_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nip_1_asm_h
	.type	.Lnip_1_asm_h,@function
.Lnip_1_asm_h:                          // @nip_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end133:
	.size	.Lnip_1_asm_h, .Lfunc_end133-.Lnip_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup_1_asm_h
	.type	.Ldup_1_asm_h,@function
.Ldup_1_asm_h:                          // @dup_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end134:
	.size	.Ldup_1_asm_h, .Lfunc_end134-.Ldup_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup1_1_asm_h
	.type	.Ldup1_1_asm_h,@function
.Ldup1_1_asm_h:                         // @dup1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x25, x8, lsl #3
	mov	x1, x22
	mov	x22, x21
	ldr	x2, [x8, #3888]
	mov	x22, x1
	br	x2
.Lfunc_end135:
	.size	.Ldup1_1_asm_h, .Lfunc_end135-.Ldup1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function swap_1_asm_h
	.type	.Lswap_1_asm_h,@function
.Lswap_1_asm_h:                         // @swap_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	add	x8, x25, x8, lsl #3
	mov	x1, x22
	mov	x22, x21
	ldr	x2, [x8, #3888]
	mov	x21, x1
	br	x2
.Lfunc_end136:
	.size	.Lswap_1_asm_h, .Lfunc_end136-.Lswap_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_constructor_1_asm_h
	.type	.Lcall_constructor_1_asm_h,@function
.Lcall_constructor_1_asm_h:             // @call_constructor_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcall_constructor_0_asm_h
.Lfunc_end137:
	.size	.Lcall_constructor_1_asm_h, .Lfunc_end137-.Lcall_constructor_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_1_asm_h
	.type	.Lcall_1_asm_h,@function
.Lcall_1_asm_h:                         // @call_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcall_0_asm_h
.Lfunc_end138:
	.size	.Lcall_1_asm_h, .Lfunc_end138-.Lcall_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_method_1_asm_h
	.type	.Lcall_method_1_asm_h,@function
.Lcall_method_1_asm_h:                  // @call_method_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcall_method_0_asm_h
.Lfunc_end139:
	.size	.Lcall_method_1_asm_h, .Lfunc_end139-.Lcall_method_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function array_from_1_asm_h
	.type	.Larray_from_1_asm_h,@function
.Larray_from_1_asm_h:                   // @array_from_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Larray_from_0_asm_h
.Lfunc_end140:
	.size	.Larray_from_1_asm_h, .Lfunc_end140-.Larray_from_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_1_asm_h
	.type	.Lreturn_1_asm_h,@function
.Lreturn_1_asm_h:                       // @return_1_asm_h
// %bb.0:                               // %B0
	mov	x0, x22
	b	.Lcommon_return_asm_h
.Lfunc_end141:
	.size	.Lreturn_1_asm_h, .Lfunc_end141-.Lreturn_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_undef_1_asm_h
	.type	.Lreturn_undef_1_asm_h,@function
.Lreturn_undef_1_asm_h:                 // @return_undef_1_asm_h
// %bb.0:                               // %B0
	mov	w0, #18                         // =0x12
	b	.Lcommon_return_asm_h
.Lfunc_end142:
	.size	.Lreturn_undef_1_asm_h, .Lfunc_end142-.Lreturn_undef_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_undef_1_asm_h
	.type	.Lget_var_undef_1_asm_h,@function
.Lget_var_undef_1_asm_h:                // @get_var_undef_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x24, #216]
	ldr	w1, [x19]
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w1, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, .LBB143_3
.LBB143_1:                              // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w11, w10, #3
	sub	w11, w11, #8
	ldr	x11, [x9, w11, uxtw]
	lsr	x12, x11, #32
	cmp	w1, w12
	b.eq	.LBB143_10
// %bb.2:                               // %B8
                                        //   in Loop: Header=BB143_1 Depth=1
	and	w10, w11, #0x3ffffff
	cbnz	w10, .LBB143_1
.LBB143_3:                              // %B33
	ldr	x8, [x24, #208]
	mov	w9, #18                         // =0x12
.LBB143_4:                              // %B22
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB143_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w10, [x11, #12]
	add	x13, x11, #64
	lsl	w12, w10, #2
	and	w10, w1, w10
	ldr	w10, [x13, w10, sxtw #2]
	add	w12, w12, #4
	add	x12, x13, x12
	cbz	w10, .LBB143_7
.LBB143_5:                              // %B26
                                        //   Parent Loop BB143_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w10, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w1, w14
	b.eq	.LBB143_9
// %bb.6:                               // %B28
                                        //   in Loop: Header=BB143_5 Depth=2
	and	w10, w13, #0x3ffffff
	cbnz	w10, .LBB143_5
.LBB143_7:                              // %B17
                                        //   in Loop: Header=BB143_4 Depth=1
	ldrb	w8, [x8, #5]
	tbnz	w8, #2, .LBB143_13
// %bb.8:                               // %B20
                                        //   in Loop: Header=BB143_4 Depth=1
	ldr	x8, [x11, #32]
	cbnz	x8, .LBB143_4
	b	.LBB143_11
.LBB143_9:                              // %B9
	lsr	w9, w13, #30
	cbnz	w9, .LBB143_13
.LBB143_10:                             // %B2
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x9, [x8, w9, sxtw #3]
	cmp	x9, #34
	b.eq	.LBB143_12
.LBB143_11:                             // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x9
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB143_12:                             // %B3
	str	x22, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.LBB143_13:                             // %B14
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB143_15
// %bb.14:                              // %B16
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB143_15:                             // %B15
	b	.Lexception_spill_top0_asm_h
.Lfunc_end143:
	.size	.Lget_var_undef_1_asm_h, .Lfunc_end143-.Lget_var_undef_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_1_asm_h
	.type	.Lget_var_1_asm_h,@function
.Lget_var_1_asm_h:                      // @get_var_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x24, #216]
	ldr	w1, [x19]
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x12, x9, #64
	lsl	w11, w10, #2
	and	w9, w1, w10
	ldr	w9, [x12, w9, sxtw #2]
	add	w10, w11, #4
	add	x10, x12, x10
	cbz	w9, .LBB144_3
.LBB144_1:                              // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	ldr	x11, [x10, w11, uxtw]
	lsr	x12, x11, #32
	cmp	w1, w12
	b.eq	.LBB144_10
// %bb.2:                               // %B8
                                        //   in Loop: Header=BB144_1 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, .LBB144_1
.LBB144_3:                              // %B32
	ldr	x8, [x24, #208]
.LBB144_4:                              // %B21
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB144_5 Depth 2
	ldr	x10, [x8, #8]
	ldr	w9, [x10, #12]
	add	x12, x10, #64
	lsl	w11, w9, #2
	and	w9, w1, w9
	ldr	w9, [x12, w9, sxtw #2]
	add	w11, w11, #4
	add	x11, x12, x11
	cbz	w9, .LBB144_7
.LBB144_5:                              // %B25
                                        //   Parent Loop BB144_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w9, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w1, w13
	b.eq	.LBB144_9
// %bb.6:                               // %B27
                                        //   in Loop: Header=BB144_5 Depth=2
	and	w9, w12, #0x3ffffff
	cbnz	w9, .LBB144_5
.LBB144_7:                              // %B16
                                        //   in Loop: Header=BB144_4 Depth=1
	ldrb	w8, [x8, #5]
	tbnz	w8, #2, .LBB144_13
// %bb.8:                               // %B19
                                        //   in Loop: Header=BB144_4 Depth=1
	ldr	x8, [x10, #32]
	cbnz	x8, .LBB144_4
	b	.LBB144_13
.LBB144_9:                              // %B9
	lsr	w10, w12, #30
	cbnz	w10, .LBB144_13
.LBB144_10:                             // %B2
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	.LBB144_12
// %bb.11:                              // %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB144_12:                             // %B3
	str	x22, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.LBB144_13:                             // %B13
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB144_15
// %bb.14:                              // %B15
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB144_15:                             // %B14
	b	.Lexception_spill_top0_asm_h
.Lfunc_end144:
	.size	.Lget_var_1_asm_h, .Lfunc_end144-.Lget_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_1_asm_h
	.type	.Lput_var_1_asm_h,@function
.Lput_var_1_asm_h:                      // @put_var_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x24, #216]
	ldr	w1, [x19]
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x12, x9, #64
	lsl	w11, w10, #2
	and	w9, w1, w10
	ldr	w9, [x12, w9, sxtw #2]
	add	w10, w11, #4
	add	x10, x12, x10
	cbz	w9, .LBB145_3
.LBB145_1:                              // %B1
                                        // =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w1, w12
	b.eq	.LBB145_6
// %bb.2:                               // %B19
                                        //   in Loop: Header=BB145_1 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, .LBB145_1
.LBB145_3:                              // %B42
	ldr	x8, [x24, #208]
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x12, x9, #64
	lsl	w11, w10, #2
	and	w9, w1, w10
	ldr	w9, [x12, w9, sxtw #2]
	add	w10, w11, #4
	add	x10, x12, x10
	cbz	w9, .LBB145_15
.LBB145_4:                              // %B32
                                        // =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w1, w12
	b.eq	.LBB145_10
// %bb.5:                               // %B34
                                        //   in Loop: Header=BB145_4 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, .LBB145_4
	b	.LBB145_15
.LBB145_6:                              // %B3
	mov	w10, #-402653184                // =0xe8000000
	and	w10, w11, w10
	mov	w11, #134217728                 // =0x8000000
	cmp	w10, w11
	b.ne	.LBB145_15
// %bb.7:                               // %B14
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	ldr	x10, [x8, w9, sxtw #3]
	cmp	x10, #34
	b.eq	.LBB145_15
// %bb.8:                               // %B23
	str	x22, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB145_12
.LBB145_9:                              // %B8
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB145_10:                             // %B20
	mov	w10, #-402653184                // =0xe8000000
	and	w10, w11, w10
	mov	w11, #134217728                 // =0x8000000
	cmp	w10, w11
	b.ne	.LBB145_15
// %bb.11:                              // %B23
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	str	x22, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB145_9
.LBB145_12:                             // %B26
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	.LBB145_9
// %bb.13:                              // %B26
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x22, x8
	cmp	x8, x9
	b.lo	.LBB145_9
// %bb.14:                              // %B8.sink.split
	mov	x0, x22
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB145_15:                             // %B37
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	w3, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_SetGlobalVar_GC
	tbz	w0, #31, .LBB145_9
// %bb.16:                              // %B38
	b	.Lexception_spill_top0_asm_h
.Lfunc_end145:
	.size	.Lput_var_1_asm_h, .Lfunc_end145-.Lput_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_field_1_asm_h
	.type	.Lget_field_1_asm_h,@function
.Lget_field_1_asm_h:                    // @get_field_1_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB146_10
// %bb.1:                               // %B25
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB146_2:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB146_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w11, w2, w11
	ldr	w11, [x13, w11, sxtw #2]
	add	w12, w12, #4
	add	x12, x13, x12
	cbz	w11, .LBB146_5
.LBB146_3:                              // %B1
                                        //   Parent Loop BB146_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w2, w14
	b.eq	.LBB146_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB146_3 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB146_3
.LBB146_5:                              // %B14
                                        //   in Loop: Header=BB146_2 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB146_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB146_2 Depth=1
	ldr	x9, [x10, #32]
	cbnz	x9, .LBB146_2
	b	.LBB146_9
.LBB146_7:                              // %B3
	lsr	w8, w13, #30
	cbnz	w8, .LBB146_10
// %bb.8:                               // %B4
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB146_9:                              // %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB146_10:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB146_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB146_12:                             // %B22
	b	.Lexception_spill_top0_asm_h
.Lfunc_end146:
	.size	.Lget_field_1_asm_h, .Lfunc_end146-.Lget_field_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_field2_1_asm_h
	.type	.Lget_field2_1_asm_h,@function
.Lget_field2_1_asm_h:                   // @get_field2_1_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB147_10
// %bb.1:                               // %B25
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB147_2:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB147_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w11, w2, w11
	ldr	w11, [x13, w11, sxtw #2]
	add	w12, w12, #4
	add	x12, x13, x12
	cbz	w11, .LBB147_5
.LBB147_3:                              // %B1
                                        //   Parent Loop BB147_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w2, w14
	b.eq	.LBB147_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB147_3 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB147_3
.LBB147_5:                              // %B14
                                        //   in Loop: Header=BB147_2 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB147_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB147_2 Depth=1
	ldr	x9, [x10, #32]
	cbnz	x9, .LBB147_2
	b	.LBB147_9
.LBB147_7:                              // %B3
	lsr	w8, w13, #30
	cbnz	w8, .LBB147_10
// %bb.8:                               // %B4
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB147_9:                              // %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB147_10:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB147_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB147_12:                             // %B22
	b	.Lexception_spill_top0_asm_h
.Lfunc_end147:
	.size	.Lget_field2_1_asm_h, .Lfunc_end147-.Lget_field2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_field_1_asm_h
	.type	.Lput_field_1_asm_h,@function
.Lput_field_1_asm_h:                    // @put_field_1_asm_h
// %bb.0:                               // %B54
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	mov	x16, x20
	tst	x22, x8
	b.ne	.LBB148_16
// %bb.1:                               // %B55
	ldr	x10, [x22, #8]
	ldr	w8, [x19]
	ldr	w9, [x10, #12]
	add	x12, x10, #64
	lsl	w11, w9, #2
	and	w9, w8, w9
	ldr	w9, [x12, w9, sxtw #2]
	add	w11, w11, #4
	add	x11, x12, x11
	cbz	w9, .LBB148_4
.LBB148_2:                              // %B1
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w9, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w8, w13
	b.eq	.LBB148_12
// %bb.3:                               // %B15
                                        //   in Loop: Header=BB148_2 Depth=1
	and	w9, w12, #0x3ffffff
	cbnz	w9, .LBB148_2
.LBB148_4:                              // %B20
	ldr	w9, [x22, #4]
	tbnz	w9, #10, .LBB148_16
// %bb.5:                               // %B51
	ldr	x10, [x10, #32]
	cbz	x10, .LBB148_11
.LBB148_6:                              // %B49
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB148_7 Depth 2
	ldr	x11, [x10, #8]
	ldr	w12, [x11, #12]
	add	x15, x11, #64
	lsl	w14, w12, #2
	and	w12, w8, w12
	ldr	w13, [x15, w12, sxtw #2]
	add	w12, w14, #4
	add	x12, x15, x12
	cbz	w13, .LBB148_9
.LBB148_7:                              // %B23
                                        //   Parent Loop BB148_6 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w13, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w8, w14
	b.eq	.LBB148_15
// %bb.8:                               // %B39
                                        //   in Loop: Header=BB148_7 Depth=2
	and	w13, w13, #0x3ffffff
	cbnz	w13, .LBB148_7
.LBB148_9:                              // %B44
                                        //   in Loop: Header=BB148_6 Depth=1
	ldrb	w10, [x10, #5]
	tbnz	w10, #2, .LBB148_16
// %bb.10:                              // %B47
                                        //   in Loop: Header=BB148_6 Depth=1
	ldr	x10, [x11, #32]
	cbnz	x10, .LBB148_6
.LBB148_11:                             // %B28
	tbnz	w9, #8, .LBB148_20
	b	.LBB148_16
.LBB148_12:                             // %B3
	mov	w8, #-402653184                 // =0xe8000000
	mov	w10, #134217728                 // =0x8000000
	and	w8, w12, w8
	cmp	w8, w10
	b.ne	.LBB148_16
// %bb.13:                              // %B7
	ldr	x8, [x22, #16]
	sub	w9, w9, #1
	str	x21, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB148_17
.LBB148_14:                             // %B5
	ldrb	w8, [x19, #4]
	sub	x20, x16, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB148_15:                             // %B25
	mov	w10, #-402653184                // =0xe8000000
	mov	w11, #134217728                 // =0x8000000
	and	w12, w9, #0x100
	and	w10, w13, w10
	cmp	w10, w11
	ccmp	w12, #0, #4, eq
	b.ne	.LBB148_20
.LBB148_16:                             // %B14
	str	x21, [x16], #8
	mov	x20, x16
	mov	x0, xzr
	b	.LSlowPutField_asm_h
.LBB148_17:                             // %B10
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB148_14
// %bb.18:                              // %B10
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x21, x8
	cmp	x8, x9
	b.lo	.LBB148_14
// %bb.19:                              // %B12
	mov	x0, x21
	mov	x1, x24
	mov	x20, x16
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB148_20:                             // %B30
	and	w9, w9, #0xffff0000
	cmp	w9, #16, lsl #12                // =65536
	b.ne	.LBB148_23
// %bb.21:                              // %B30
	tbnz	w8, #31, .LBB148_23
// %bb.22:                              // %B36
	add	x20, x16, #8
	stur	x21, [x16]
	mov	x0, x8
	b	.LFastAddNamedProperty_asm_h
.LBB148_23:                             // %B32
	add	x20, x16, #8
	stur	x21, [x16]
	mov	w0, #1                          // =0x1
	b	.LSlowPutField_asm_h
.Lfunc_end148:
	.size	.Lput_field_1_asm_h, .Lfunc_end148-.Lput_field_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_array_el_1_asm_h
	.type	.Lget_array_el_1_asm_h,@function
.Lget_array_el_1_asm_h:                 // @get_array_el_1_asm_h
// %bb.0:                               // %B36
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB149_6
// %bb.1:                               // %B36
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x8, x9
	b.ne	.LBB149_6
// %bb.2:                               // %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	.LBB149_5
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w8, w21
	b.ls	.LBB149_7
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x8, #1944]
	br	x1
.LBB149_5:                              // %B30
	sub	w8, w8, #21
	cmp	w8, #8
	b.ls	.LBB149_17
.LBB149_6:                              // %B16
	str	x21, [x20], #8
	b	.LSlowGetArrayEl_asm_h
.LBB149_7:                              // %B7
	tbnz	w21, #31, .LBB149_6
// %bb.8:                               // %B9.preheader
	mov	x9, x22
	orr	w10, w21, #0x80000000
	mov	w8, #18                         // =0x12
.LBB149_9:                              // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB149_10 Depth 2
	ldr	x11, [x9, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w12, w10, w12
	ldr	w12, [x14, w12, sxtw #2]
	add	w13, w13, #4
	add	x13, x14, x13
	cbz	w12, .LBB149_12
.LBB149_10:                             // %B10
                                        //   Parent Loop BB149_9 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w14, w12, #3
	sub	w14, w14, #8
	add	x14, x13, x14
	ldp	w14, w15, [x14]
	cmp	w10, w15
	b.eq	.LBB149_14
// %bb.11:                              // %B17
                                        //   in Loop: Header=BB149_10 Depth=2
	and	w12, w14, #0x3ffffff
	cbnz	w12, .LBB149_10
.LBB149_12:                             // %B24
                                        //   in Loop: Header=BB149_9 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB149_6
// %bb.13:                              // %B21
                                        //   in Loop: Header=BB149_9 Depth=1
	ldr	x9, [x11, #32]
	cbnz	x9, .LBB149_9
	b	.LBB149_16
.LBB149_14:                             // %B12
	lsr	w8, w14, #30
	cbnz	w8, .LBB149_6
// %bb.15:                              // %B13
	ldr	x8, [x9, #16]
	sub	w9, w12, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB149_16:                             // %B14
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB149_17:                             // %B31
	str	x21, [x20], #8
	mov	x0, xzr
	b	.LFastTypedArrayGet_asm_h
.Lfunc_end149:
	.size	.Lget_array_el_1_asm_h, .Lfunc_end149-.Lget_array_el_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_array_el2_1_asm_h
	.type	.Lget_array_el2_1_asm_h,@function
.Lget_array_el2_1_asm_h:                // @get_array_el2_1_asm_h
// %bb.0:                               // %B36
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB150_6
// %bb.1:                               // %B36
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x8, x9
	b.ne	.LBB150_6
// %bb.2:                               // %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	.LBB150_5
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w8, w21
	b.ls	.LBB150_7
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x8, #3888]
	br	x1
.LBB150_5:                              // %B30
	sub	w8, w8, #21
	cmp	w8, #8
	b.ls	.LBB150_17
.LBB150_6:                              // %B16
	str	x21, [x20], #8
	b	.LSlowGetArrayEl_asm_h
.LBB150_7:                              // %B7
	tbnz	w21, #31, .LBB150_6
// %bb.8:                               // %B9.preheader
	mov	x9, x22
	orr	w10, w21, #0x80000000
	mov	w8, #18                         // =0x12
.LBB150_9:                              // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB150_10 Depth 2
	ldr	x11, [x9, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w12, w10, w12
	ldr	w12, [x14, w12, sxtw #2]
	add	w13, w13, #4
	add	x13, x14, x13
	cbz	w12, .LBB150_12
.LBB150_10:                             // %B10
                                        //   Parent Loop BB150_9 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w14, w12, #3
	sub	w14, w14, #8
	add	x14, x13, x14
	ldp	w14, w15, [x14]
	cmp	w10, w15
	b.eq	.LBB150_14
// %bb.11:                              // %B17
                                        //   in Loop: Header=BB150_10 Depth=2
	and	w12, w14, #0x3ffffff
	cbnz	w12, .LBB150_10
.LBB150_12:                             // %B24
                                        //   in Loop: Header=BB150_9 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB150_6
// %bb.13:                              // %B21
                                        //   in Loop: Header=BB150_9 Depth=1
	ldr	x9, [x11, #32]
	cbnz	x9, .LBB150_9
	b	.LBB150_16
.LBB150_14:                             // %B12
	lsr	w8, w14, #30
	cbnz	w8, .LBB150_6
// %bb.15:                              // %B13
	ldr	x8, [x9, #16]
	sub	w9, w12, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB150_16:                             // %B14
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x21, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB150_17:                             // %B31
	str	x21, [x20], #8
	mov	w0, #1                          // =0x1
	b	.LFastTypedArrayGet_asm_h
.Lfunc_end150:
	.size	.Lget_array_el2_1_asm_h, .Lfunc_end150-.Lget_array_el2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_array_el_1_asm_h
	.type	.Lput_array_el_1_asm_h,@function
.Lput_array_el_1_asm_h:                 // @put_array_el_1_asm_h
// %bb.0:                               // %B56
	mov	x21, x22
	ldp	x8, x22, [x20, #-16]
	mov	x9, #2                          // =0x2
	movk	x9, #65535, lsl #48
	tst	x8, x9
	b.ne	.LBB151_7
// %bb.1:                               // %B1
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x22, lsr #48
	b.ne	.LBB151_7
// %bb.2:                               // %B3
	ldrh	w9, [x8, #6]
	cmp	w9, #2
	b.ne	.LBB151_6
// %bb.3:                               // %B48
	ldr	w9, [x8, #48]
	cmp	w9, w22
	b.ls	.LBB151_8
// %bb.4:                               // %B5
	ldr	x8, [x8, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB151_16
.LBB151_5:                              // %B25
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB151_6:                              // %B52
	sub	w8, w9, #21
	cmp	w8, #8
	b.ls	.LBB151_20
.LBB151_7:                              // %B40
	str	x21, [x20], #8
	mov	x0, xzr
	b	.LSlowPutArrayEl_asm_h
.LBB151_8:                              // %B13
	b.ne	.LBB151_21
// %bb.9:                               // %B41
	ldr	w9, [x8, #4]
	mov	w10, #2304                      // =0x900
	bics	wzr, w10, w9
	b.ne	.LBB151_7
// %bb.10:                              // %B15
	ldr	x9, [x8, #8]
	ldr	x9, [x9, #32]
	cbz	x9, .LBB151_12
// %bb.11:                              // %B37
	ldrb	w9, [x9, #5]
	tbz	w9, #5, .LBB151_7
.LBB151_12:                             // %B33
	ldr	x9, [x8, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w22, #1
	b.ne	.LBB151_14
// %bb.13:                              // %B33
	cmp	w9, w10
	b.hi	.LBB151_19
.LBB151_14:                             // %B30
	ldr	w10, [x8, #32]
	cmp	w9, w10
	b.hi	.LBB151_19
// %bb.15:                              // %B23
	ldr	x10, [x8, #40]
	str	w9, [x8, #48]
	str	x21, [x10, w22, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB151_5
.LBB151_16:                             // %B27
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB151_5
// %bb.17:                              // %B27
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x21, x8
	cmp	x8, x9
	b.lo	.LBB151_5
// %bb.18:                              // %B29
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB151_19:                             // %B20
	str	x21, [x20], #8
	mov	w0, #1                          // =0x1
	b	.LSlowPutArrayEl_asm_h
.LBB151_20:                             // %B53
	str	x21, [x20], #8
	b	.LFastTypedArraySet_asm_h
.LBB151_21:                             // %B45
	tbnz	w22, #31, .LBB151_7
// %bb.22:                              // %B46
	str	x21, [x20], #8
	mov	w0, #2                          // =0x2
	b	.LSlowPutArrayEl_asm_h
.Lfunc_end151:
	.size	.Lput_array_el_1_asm_h, .Lfunc_end151-.Lput_array_el_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_false_1_asm_h
	.type	.Lif_false_1_asm_h,@function
.Lif_false_1_asm_h:                     // @if_false_1_asm_h
// %bb.0:                               // %B25
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB152_3
// %bb.1:                               // %B1
	cbz	x8, .LBB152_10
.LBB152_2:                              // %B6
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB152_3:                              // %B7
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB152_5
// %bb.4:                               // %B9
	cbnz	w22, .LBB152_2
	b	.LBB152_10
.LBB152_5:                              // %B13
	and	x8, x22, #0xffffffffffffffef
	cmp	x8, #2
	b.eq	.LBB152_10
// %bb.6:                               // %B16
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	.LBB152_2
// %bb.7:                               // %B19
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842624          // =0xfffc000000000000
	add	x8, x22, x8
	cmp	x8, x9
	b.lo	.LBB152_9
// %bb.8:                               // %B24
	str	x22, [x20], #8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.LBB152_9:                              // %B21
	fmov	d0, x8
	fcmp	d0, #0.0
	b.mi	.LBB152_2
	b.gt	.LBB152_2
.LBB152_10:                             // %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end152:
	.size	.Lif_false_1_asm_h, .Lfunc_end152-.Lif_false_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_true_1_asm_h
	.type	.Lif_true_1_asm_h,@function
.Lif_true_1_asm_h:                      // @if_true_1_asm_h
// %bb.0:                               // %B25
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB153_3
// %bb.1:                               // %B1
	cbz	x8, .LBB153_10
.LBB153_2:                              // %B6
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB153_3:                              // %B7
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB153_5
// %bb.4:                               // %B9
	cbnz	w22, .LBB153_2
	b	.LBB153_10
.LBB153_5:                              // %B13
	and	x8, x22, #0xffffffffffffffef
	cmp	x8, #2
	b.eq	.LBB153_10
// %bb.6:                               // %B16
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	.LBB153_2
// %bb.7:                               // %B19
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842624          // =0xfffc000000000000
	add	x8, x22, x8
	cmp	x8, x9
	b.lo	.LBB153_9
// %bb.8:                               // %B24
	str	x22, [x20], #8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.LBB153_9:                              // %B21
	fmov	d0, x8
	fcmp	d0, #0.0
	b.mi	.LBB153_2
	b.gt	.LBB153_2
.LBB153_10:                             // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end153:
	.size	.Lif_true_1_asm_h, .Lfunc_end153-.Lif_true_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function goto_1_asm_h
	.type	.Lgoto_1_asm_h,@function
.Lgoto_1_asm_h:                         // @goto_1_asm_h
// %bb.0:                               // %B0
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end154:
	.size	.Lgoto_1_asm_h, .Lfunc_end154-.Lgoto_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function neg_1_asm_h
	.type	.Lneg_1_asm_h,@function
.Lneg_1_asm_h:                          // @neg_1_asm_h
// %bb.0:                               // %B16
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB155_3
// %bb.1:                               // %B10
	orr	w8, w22, #0x80000000
	mov	w9, #-2147483648                // =0x80000000
	cmp	w8, w9
	b.eq	.LBB155_5
// %bb.2:                               // %B12
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB155_3:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842625          // =0xfffbffffffffffff
	add	x8, x22, x8
	cmp	x8, x9
	b.hi	.LBB155_5
// %bb.4:                               // %B3
	movi	d0, #0000000000000000
	fmov	d1, x8
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	fsub	d0, d0, d1
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB155_5:                              // %B13
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        // =0x8c
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB155_7
// %bb.6:                               // %B15
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB155_7:                              // %B14
	b	.Lexception_spill_top0_asm_h
.Lfunc_end155:
	.size	.Lneg_1_asm_h, .Lfunc_end155-.Lneg_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dec_1_asm_h
	.type	.Ldec_1_asm_h,@function
.Ldec_1_asm_h:                          // @dec_1_asm_h
// %bb.0:                               // %B16
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB156_3
// %bb.1:                               // %B10
	subs	w8, w22, #1
	b.vs	.LBB156_5
// %bb.2:                               // %B12
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB156_3:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842625          // =0xfffbffffffffffff
	add	x8, x22, x8
	cmp	x8, x9
	b.hi	.LBB156_5
// %bb.4:                               // %B3
	fmov	d0, #-1.00000000
	fmov	d1, x8
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	fadd	d0, d1, d0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB156_5:                              // %B13
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        // =0x8e
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB156_7
// %bb.6:                               // %B15
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB156_7:                              // %B14
	b	.Lexception_spill_top0_asm_h
.Lfunc_end156:
	.size	.Ldec_1_asm_h, .Lfunc_end156-.Ldec_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_1_asm_h
	.type	.Linc_1_asm_h,@function
.Linc_1_asm_h:                          // @inc_1_asm_h
// %bb.0:                               // %B16
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB157_3
// %bb.1:                               // %B10
	adds	w8, w22, #1
	b.vs	.LBB157_5
// %bb.2:                               // %B12
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB157_3:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842625          // =0xfffbffffffffffff
	add	x8, x22, x8
	cmp	x8, x9
	b.hi	.LBB157_5
// %bb.4:                               // %B3
	fmov	d0, #1.00000000
	fmov	d1, x8
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	fadd	d0, d1, d0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB157_5:                              // %B13
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        // =0x8f
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB157_7
// %bb.6:                               // %B15
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB157_7:                              // %B14
	b	.Lexception_spill_top0_asm_h
.Lfunc_end157:
	.size	.Linc_1_asm_h, .Lfunc_end157-.Linc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function post_dec_1_asm_h
	.type	.Lpost_dec_1_asm_h,@function
.Lpost_dec_1_asm_h:                     // @post_dec_1_asm_h
// %bb.0:                               // %B13
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB158_3
// %bb.1:                               // %B10
	subs	w8, w22, #1
	b.vs	.LBB158_5
// %bb.2:                               // %B12
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB158_3:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842624          // =0xfffc000000000000
	add	x8, x22, x8
	cmp	x8, x9
	b.hs	.LBB158_5
// %bb.4:                               // %B3
	fmov	d0, #-1.00000000
	fmov	d1, x8
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	fadd	d0, d1, d0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x8, x9, vs
	br	x1
.LBB158_5:                              // %B9
	str	x22, [x20], #8
	mov	w0, #144                        // =0x90
	b	.LSlowJSPostInc_asm_h
.Lfunc_end158:
	.size	.Lpost_dec_1_asm_h, .Lfunc_end158-.Lpost_dec_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function post_inc_1_asm_h
	.type	.Lpost_inc_1_asm_h,@function
.Lpost_inc_1_asm_h:                     // @post_inc_1_asm_h
// %bb.0:                               // %B13
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB159_3
// %bb.1:                               // %B10
	adds	w8, w22, #1
	b.vs	.LBB159_5
// %bb.2:                               // %B12
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB159_3:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842624          // =0xfffc000000000000
	add	x8, x22, x8
	cmp	x8, x9
	b.hs	.LBB159_5
// %bb.4:                               // %B3
	fmov	d0, #1.00000000
	fmov	d1, x8
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	fadd	d0, d1, d0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x8, x9, vs
	br	x1
.LBB159_5:                              // %B9
	str	x22, [x20], #8
	mov	w0, #145                        // =0x91
	b	.LSlowJSPostInc_asm_h
.Lfunc_end159:
	.size	.Lpost_inc_1_asm_h, .Lfunc_end159-.Lpost_inc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dec_loc_1_asm_h
	.type	.Ldec_loc_1_asm_h,@function
.Ldec_loc_1_asm_h:                      // @dec_loc_1_asm_h
// %bb.0:                               // %B16
	ldrb	w8, [x19]
	mov	w9, #65534                      // =0xfffe
	ldr	x1, [x27, x8, lsl #3]
	cmp	x9, x1, lsr #48
	b.ne	.LBB160_3
// %bb.1:                               // %B10
	subs	w9, w1, #1
	b.vs	.LBB160_5
// %bb.2:                               // %B12
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB160_3:                              // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x9, x1, x9
	cmp	x9, x10
	b.hi	.LBB160_5
// %bb.4:                               // %B4
	fmov	d0, #-1.00000000
	fmov	d1, x9
	mov	x10, #562949953421312           // =0x2000000000000
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x10, x9, vs
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB160_5:                              // %B13
	mov	x8, x20
	mov	x0, x24
	mov	w2, #142                        // =0x8e
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB160_7
// %bb.6:                               // %B15
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB160_7:                              // %B14
	b	.Lexception_spill_top0_asm_h
.Lfunc_end160:
	.size	.Ldec_loc_1_asm_h, .Lfunc_end160-.Ldec_loc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_loc_1_asm_h
	.type	.Linc_loc_1_asm_h,@function
.Linc_loc_1_asm_h:                      // @inc_loc_1_asm_h
// %bb.0:                               // %B16
	ldrb	w8, [x19]
	mov	w9, #65534                      // =0xfffe
	ldr	x1, [x27, x8, lsl #3]
	cmp	x9, x1, lsr #48
	b.ne	.LBB161_3
// %bb.1:                               // %B10
	adds	w9, w1, #1
	b.vs	.LBB161_5
// %bb.2:                               // %B12
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB161_3:                              // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x9, x1, x9
	cmp	x9, x10
	b.hi	.LBB161_5
// %bb.4:                               // %B4
	fmov	d0, #1.00000000
	fmov	d1, x9
	mov	x10, #562949953421312           // =0x2000000000000
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x10, x9, vs
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB161_5:                              // %B13
	mov	x8, x20
	mov	x0, x24
	mov	w2, #143                        // =0x8f
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB161_7
// %bb.6:                               // %B15
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB161_7:                              // %B14
	b	.Lexception_spill_top0_asm_h
.Lfunc_end161:
	.size	.Linc_loc_1_asm_h, .Lfunc_end161-.Linc_loc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_loc_1_asm_h
	.type	.Ladd_loc_1_asm_h,@function
.Ladd_loc_1_asm_h:                      // @add_loc_1_asm_h
// %bb.0:                               // %B30
	ldrb	w8, [x19]
	eor	x10, x22, #0xfffe000000000000
	ldr	x9, [x27, x8, lsl #3]
	eor	x11, x9, #0xfffe000000000000
	orr	x10, x11, x10
	lsr	x10, x10, #48
	cbnz	x10, .LBB162_3
// %bb.1:                               // %B23
	adds	w10, w9, w22
	b.vs	.LBB162_8
// %bb.2:                               // %B29
	orr	x9, x10, #0xfffe000000000000
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB162_3:                              // %B2
	mov	x10, #-562949953421312          // =0xfffe000000000000
	mov	x12, #-844424930131969          // =0xfffcffffffffffff
	add	x11, x9, x10
	add	x10, x22, x10
	cmp	x11, x12
	mov	x12, #-844424930131968          // =0xfffd000000000000
	ccmp	x10, x12, #2, ls
	b.hs	.LBB162_9
// %bb.4:                               // %B4
	mov	x12, #-1125899906842624         // =0xfffc000000000000
	cmp	x11, x12
	b.hs	.LBB162_10
// %bb.5:                               // %B6
	fmov	d0, x11
	cmp	x10, x12
	b.hs	.LBB162_11
.LBB162_6:                              // %B8
	fmov	d1, x10
.LBB162_7:                              // %B13
	fadd	d0, d0, d1
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x10, x9, vs
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB162_8:                              // %B25
	scvtf	d0, w9
	scvtf	d1, w22
	mov	x10, #562949953421312           // =0x2000000000000
	fadd	d0, d0, d1
	fmov	x9, d0
	add	x9, x9, x10
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB162_9:                              // %B22
	str	x22, [x20], #8
	mov	w0, #1                          // =0x1
	b	.LSlowJSAdd_asm_h
.LBB162_10:                             // %B18
	scvtf	d0, w9
	b	.LBB162_6
.LBB162_11:                             // %B13
	scvtf	d1, w22
	b	.LBB162_7
.Lfunc_end162:
	.size	.Ladd_loc_1_asm_h, .Lfunc_end162-.Ladd_loc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function not_1_asm_h
	.type	.Lnot_1_asm_h,@function
.Lnot_1_asm_h:                          // @not_1_asm_h
// %bb.0:                               // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB163_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB163_2:                              // %B4
	str	x22, [x20], #8
	mov	x0, x22
	b	.LSlowJSNot_asm_h
.Lfunc_end163:
	.size	.Lnot_1_asm_h, .Lfunc_end163-.Lnot_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lnot_1_asm_h
	.type	.Llnot_1_asm_h,@function
.Llnot_1_asm_h:                         // @lnot_1_asm_h
// %bb.0:                               // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB164_3
// %bb.1:                               // %B1
	cbz	x8, .LBB164_5
.LBB164_2:                              // %B7
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB164_3:                              // %B8
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB164_6
// %bb.4:                               // %B10
	cbnz	w22, .LBB164_2
.LBB164_5:                              // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB164_6:                              // %B14
	and	x8, x22, #0xffffffffffffffef
	cmp	x8, #2
	b.eq	.LBB164_5
// %bb.7:                               // %B17
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	.LBB164_2
// %bb.8:                               // %B19
	str	x22, [x20], #8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.Lfunc_end164:
	.size	.Llnot_1_asm_h, .Lfunc_end164-.Llnot_1_asm_h
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
	b.eq	.LBB165_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB165_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end165:
	.size	.Ltypeof_1_asm_h, .Lfunc_end165-.Ltypeof_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function mul_1_asm_h
	.type	.Lmul_1_asm_h,@function
.Lmul_1_asm_h:                          // @mul_1_asm_h
// %bb.0:                               // %B41
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB166_5
// %bb.1:                               // %B23
	smull	x8, w22, w21
	sub	x20, x20, #8
	cmp	x8, w8, sxtw
	b.ne	.LBB166_11
// %bb.2:                               // %B30
	cbnz	w8, .LBB166_4
// %bb.3:                               // %B30
	orr	w9, w22, w21
	tbnz	w9, #31, .LBB166_12
.LBB166_4:                              // %B37
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB166_5:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB166_13
// %bb.6:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB166_13
// %bb.7:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB166_15
// %bb.8:                               // %B5
	fmov	d0, x9
	cmp	x8, x10
	b.hs	.LBB166_16
.LBB166_9:                              // %B7
	fmov	d1, x8
.LBB166_10:                             // %B13
	fmul	d0, d0, d1
	ldrb	w8, [x19], #1
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	fmov	x9, d0
	fcmp	d0, d0
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB166_11:                             // %B25
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x9, #562949953421312            // =0x2000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	fmul	d0, d0, d1
	ldr	x1, [x8, #1944]
	fmov	x8, d0
	add	x22, x8, x9
	br	x1
.LBB166_12:                             // %B34
	mov	x22, #-9222809086901354496      // =0x8002000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB166_13:                             // %B38
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        // =0x9a
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB166_17
// %bb.14:                              // %B40
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB166_15:                             // %B18
	scvtf	d0, w22
	b	.LBB166_9
.LBB166_16:                             // %B13
	scvtf	d1, w21
	b	.LBB166_10
.LBB166_17:                             // %B39
	b	.Lexception_spill_top1_asm_h
.Lfunc_end166:
	.size	.Lmul_1_asm_h, .Lfunc_end166-.Lmul_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function div_1_asm_h
	.type	.Ldiv_1_asm_h,@function
.Ldiv_1_asm_h:                          // @div_1_asm_h
// %bb.0:                               // %B34
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB167_2
// %bb.1:                               // %B23
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	mov	x12, #9221683186994511872       // =0x7ffa000000000000
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	fdiv	d0, d0, d1
	ldr	x1, [x8, #1944]
	fcvtzs	w9, d0
	fmov	x11, d0
	fcmp	d0, d0
	add	x10, x11, x10
	csel	x10, x12, x10, vs
	cmp	x9, x11
	orr	x8, x9, #0xfffe000000000000
	csel	x22, x8, x10, eq
	br	x1
.LBB167_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB167_8
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB167_8
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB167_10
// %bb.5:                               // %B5
	fmov	d0, x9
	cmp	x8, x10
	b.hs	.LBB167_11
.LBB167_6:                              // %B7
	fmov	d1, x8
.LBB167_7:                              // %B13
	fdiv	d0, d0, d1
	ldrb	w8, [x19], #1
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB167_8:                              // %B31
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        // =0x9b
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB167_12
// %bb.9:                               // %B33
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB167_10:                             // %B18
	scvtf	d0, w22
	b	.LBB167_6
.LBB167_11:                             // %B13
	scvtf	d1, w21
	b	.LBB167_7
.LBB167_12:                             // %B32
	b	.Lexception_spill_top1_asm_h
.Lfunc_end167:
	.size	.Ldiv_1_asm_h, .Lfunc_end167-.Ldiv_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function mod_1_asm_h
	.type	.Lmod_1_asm_h,@function
.Lmod_1_asm_h:                          // @mod_1_asm_h
// %bb.0:                               // %B30
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB168_4
// %bb.1:                               // %B24
	tbnz	w22, #31, .LBB168_10
// %bb.2:                               // %B24
	cmp	w21, #1
	b.lt	.LBB168_10
// %bb.3:                               // %B26
	udiv	w8, w22, w21
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB168_4:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB168_10
// %bb.5:                               // %B1
	add	x8, x21, x8
	cmp	x8, x10
	b.hi	.LBB168_10
// %bb.6:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB168_13
// %bb.7:                               // %B5
	fmov	d0, x9
	cmp	x8, x10
	b.hs	.LBB168_14
.LBB168_8:                              // %B7
	fmov	d1, x8
.LBB168_9:                              // %B13
	bl	fmod
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	add	x9, x9, x10
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x8, x9, vs
	br	x1
.LBB168_10:                             // %B27
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        // =0x9c
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB168_12
// %bb.11:                              // %B29
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB168_12:                             // %B28
	b	.Lexception_spill_top1_asm_h
.LBB168_13:                             // %B18
	scvtf	d0, w22
	b	.LBB168_8
.LBB168_14:                             // %B13
	scvtf	d1, w21
	b	.LBB168_9
.Lfunc_end168:
	.size	.Lmod_1_asm_h, .Lfunc_end168-.Lmod_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_1_asm_h
	.type	.Ladd_1_asm_h,@function
.Ladd_1_asm_h:                          // @add_1_asm_h
// %bb.0:                               // %B30
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB169_3
// %bb.1:                               // %B23
	adds	w8, w22, w21
	sub	x20, x20, #8
	b.vs	.LBB169_9
// %bb.2:                               // %B29
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB169_3:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB169_10
// %bb.4:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB169_10
// %bb.5:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB169_11
// %bb.6:                               // %B5
	fmov	d0, x9
	cmp	x8, x10
	b.hs	.LBB169_12
.LBB169_7:                              // %B7
	fmov	d1, x8
.LBB169_8:                              // %B13
	fadd	d0, d0, d1
	ldrb	w8, [x19], #1
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	fmov	x9, d0
	fcmp	d0, d0
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB169_9:                              // %B25
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x9, #562949953421312            // =0x2000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	fadd	d0, d0, d1
	ldr	x1, [x8, #1944]
	fmov	x8, d0
	add	x22, x8, x9
	br	x1
.LBB169_10:                             // %B22
	str	x21, [x20], #8
	mov	x0, xzr
	b	.LSlowJSAdd_asm_h
.LBB169_11:                             // %B18
	scvtf	d0, w22
	b	.LBB169_7
.LBB169_12:                             // %B13
	scvtf	d1, w21
	b	.LBB169_8
.Lfunc_end169:
	.size	.Ladd_1_asm_h, .Lfunc_end169-.Ladd_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function sub_1_asm_h
	.type	.Lsub_1_asm_h,@function
.Lsub_1_asm_h:                          // @sub_1_asm_h
// %bb.0:                               // %B33
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB170_3
// %bb.1:                               // %B23
	subs	w8, w22, w21
	sub	x20, x20, #8
	b.vs	.LBB170_9
// %bb.2:                               // %B29
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB170_3:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB170_10
// %bb.4:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB170_10
// %bb.5:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB170_12
// %bb.6:                               // %B5
	fmov	d0, x9
	cmp	x8, x10
	b.hs	.LBB170_13
.LBB170_7:                              // %B7
	fmov	d1, x8
.LBB170_8:                              // %B13
	fsub	d0, d0, d1
	ldrb	w8, [x19], #1
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	fmov	x9, d0
	fcmp	d0, d0
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB170_9:                              // %B25
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x9, #562949953421312            // =0x2000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	fsub	d0, d0, d1
	ldr	x1, [x8, #1944]
	fmov	x8, d0
	add	x22, x8, x9
	br	x1
.LBB170_10:                             // %B30
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        // =0x9e
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB170_14
// %bb.11:                              // %B32
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB170_12:                             // %B18
	scvtf	d0, w22
	b	.LBB170_7
.LBB170_13:                             // %B13
	scvtf	d1, w21
	b	.LBB170_8
.LBB170_14:                             // %B31
	b	.Lexception_spill_top1_asm_h
.Lfunc_end170:
	.size	.Lsub_1_asm_h, .Lfunc_end170-.Lsub_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function shl_1_asm_h
	.type	.Lshl_1_asm_h,@function
.Lshl_1_asm_h:                          // @shl_1_asm_h
// %bb.0:                               // %B19
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB171_3
// %bb.1:                               // %B20
	mov	w8, w22
.LBB171_2:                              // %B12
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #8
	add	x9, x25, x9, lsl #3
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	br	x1
.LBB171_3:                              // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB171_5
// %bb.4:                               // %B2
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB171_8
.LBB171_5:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        // =0xa0
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB171_7
// %bb.6:                               // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB171_7:                              // %B17
	b	.Lexception_spill_top1_asm_h
.LBB171_8:                              // %B10
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB171_5
// %bb.9:                               // %B11
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB171_2
.Lfunc_end171:
	.size	.Lshl_1_asm_h, .Lfunc_end171-.Lshl_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function sar_1_asm_h
	.type	.Lsar_1_asm_h,@function
.Lsar_1_asm_h:                          // @sar_1_asm_h
// %bb.0:                               // %B19
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB172_3
// %bb.1:                               // %B20
	mov	w8, w22
.LBB172_2:                              // %B12
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #8
	add	x9, x25, x9, lsl #3
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	br	x1
.LBB172_3:                              // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB172_5
// %bb.4:                               // %B2
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB172_8
.LBB172_5:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        // =0xa1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB172_7
// %bb.6:                               // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB172_7:                              // %B17
	b	.Lexception_spill_top1_asm_h
.LBB172_8:                              // %B10
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB172_5
// %bb.9:                               // %B11
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB172_2
.Lfunc_end172:
	.size	.Lsar_1_asm_h, .Lfunc_end172-.Lsar_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function shr_1_asm_h
	.type	.Lshr_1_asm_h,@function
.Lshr_1_asm_h:                          // @shr_1_asm_h
// %bb.0:                               // %B27
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB173_3
// %bb.1:                               // %B28
	mov	w8, w22
.LBB173_2:                              // %B1
	lsr	w8, w8, w21
	ldrb	w9, [x19], #1
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	ucvtf	d0, w8
	add	x9, x25, x9, lsl #3
	tst	w8, #0x80000000
	orr	x8, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	fmov	x11, d0
	add	x10, x11, x10
	csel	x22, x10, x8, ne
	br	x1
.LBB173_3:                              // %B10
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB173_5
// %bb.4:                               // %B10
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB173_8
.LBB173_5:                              // %B24
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	.LBB173_7
// %bb.6:                               // %B26
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB173_7:                              // %B25
	b	.Lexception_spill_top1_asm_h
.LBB173_8:                              // %B18
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB173_5
// %bb.9:                               // %B19
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB173_2
.Lfunc_end173:
	.size	.Lshr_1_asm_h, .Lfunc_end173-.Lshr_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lt_1_asm_h
	.type	.Llt_1_asm_h,@function
.Llt_1_asm_h:                           // @lt_1_asm_h
// %bb.0:                               // %B14
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB174_2
// %bb.1:                               // %B15
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, lt
	br	x1
.LBB174_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB174_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB174_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB174_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB174_10
.LBB174_6:                              // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB174_7:                              // %B11
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        // =0xa3
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB174_11
// %bb.8:                               // %B13
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB174_9:                              // %B9
	scvtf	d0, w22
	b	.LBB174_6
.LBB174_10:                             // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB174_11:                             // %B12
	b	.Lexception_spill_top1_asm_h
.Lfunc_end174:
	.size	.Llt_1_asm_h, .Lfunc_end174-.Llt_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lte_1_asm_h
	.type	.Llte_1_asm_h,@function
.Llte_1_asm_h:                          // @lte_1_asm_h
// %bb.0:                               // %B14
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB175_2
// %bb.1:                               // %B15
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, le
	br	x1
.LBB175_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB175_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB175_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB175_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB175_10
.LBB175_6:                              // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB175_7:                              // %B11
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        // =0xa4
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB175_11
// %bb.8:                               // %B13
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB175_9:                              // %B9
	scvtf	d0, w22
	b	.LBB175_6
.LBB175_10:                             // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB175_11:                             // %B12
	b	.Lexception_spill_top1_asm_h
.Lfunc_end175:
	.size	.Llte_1_asm_h, .Lfunc_end175-.Llte_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gt_1_asm_h
	.type	.Lgt_1_asm_h,@function
.Lgt_1_asm_h:                           // @gt_1_asm_h
// %bb.0:                               // %B14
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB176_2
// %bb.1:                               // %B15
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB176_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB176_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB176_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB176_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB176_10
.LBB176_6:                              // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB176_7:                              // %B11
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        // =0xa5
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB176_11
// %bb.8:                               // %B13
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB176_9:                              // %B9
	scvtf	d0, w22
	b	.LBB176_6
.LBB176_10:                             // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB176_11:                             // %B12
	b	.Lexception_spill_top1_asm_h
.Lfunc_end176:
	.size	.Lgt_1_asm_h, .Lfunc_end176-.Lgt_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gte_1_asm_h
	.type	.Lgte_1_asm_h,@function
.Lgte_1_asm_h:                          // @gte_1_asm_h
// %bb.0:                               // %B14
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB177_2
// %bb.1:                               // %B15
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB177_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB177_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB177_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB177_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB177_10
.LBB177_6:                              // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB177_7:                              // %B11
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        // =0xa6
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB177_11
// %bb.8:                               // %B13
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB177_9:                              // %B9
	scvtf	d0, w22
	b	.LBB177_6
.LBB177_10:                             // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB177_11:                             // %B12
	b	.Lexception_spill_top1_asm_h
.Lfunc_end177:
	.size	.Lgte_1_asm_h, .Lfunc_end177-.Lgte_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function eq_1_asm_h
	.type	.Leq_1_asm_h,@function
.Leq_1_asm_h:                           // @eq_1_asm_h
// %bb.0:                               // %B34
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB178_2
// %bb.1:                               // %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB178_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB178_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB178_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB178_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB178_10
.LBB178_6:                              // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB178_7:                              // %B11
	cmp	x22, x21
	b.ne	.LBB178_11
.LBB178_8:                              // %B12
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB178_9:                              // %B9
	scvtf	d0, w22
	b	.LBB178_6
.LBB178_10:                             // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB178_11:                             // %B14
	and	x8, x21, #0xffffffffffffffef
	cmp	x8, #2
	and	x8, x22, #0xffffffffffffffef
	b.ne	.LBB178_13
// %bb.12:                              // %B16
	cmp	x8, #2
	b.ne	.LBB178_16
	b	.LBB178_8
.LBB178_13:                             // %B21
	cmp	x8, #2
	b.eq	.LBB178_16
// %bb.14:                              // %B24
	and	x8, x21, #0xfffffffffffffffe
	cmp	x8, #6
	b.ne	.LBB178_17
// %bb.15:                              // %B24
	and	x8, x22, #0xfffffffffffffffe
	cmp	x8, #6
	b.ne	.LBB178_17
.LBB178_16:                             // %B19
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB178_17:                             // %B31
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB178_19
// %bb.18:                              // %B33
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB178_19:                             // %B32
	b	.Lexception_spill_top1_asm_h
.Lfunc_end178:
	.size	.Leq_1_asm_h, .Lfunc_end178-.Leq_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function neq_1_asm_h
	.type	.Lneq_1_asm_h,@function
.Lneq_1_asm_h:                          // @neq_1_asm_h
// %bb.0:                               // %B34
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB179_2
// %bb.1:                               // %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB179_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB179_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB179_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB179_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB179_10
.LBB179_6:                              // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB179_7:                              // %B11
	cmp	x22, x21
	b.ne	.LBB179_11
.LBB179_8:                              // %B12
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB179_9:                              // %B9
	scvtf	d0, w22
	b	.LBB179_6
.LBB179_10:                             // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB179_11:                             // %B14
	and	x8, x21, #0xffffffffffffffef
	cmp	x8, #2
	and	x8, x22, #0xffffffffffffffef
	b.ne	.LBB179_13
// %bb.12:                              // %B16
	cmp	x8, #2
	b.ne	.LBB179_16
	b	.LBB179_8
.LBB179_13:                             // %B21
	cmp	x8, #2
	b.eq	.LBB179_16
// %bb.14:                              // %B24
	and	x8, x21, #0xfffffffffffffffe
	cmp	x8, #6
	b.ne	.LBB179_17
// %bb.15:                              // %B24
	and	x8, x22, #0xfffffffffffffffe
	cmp	x8, #6
	b.ne	.LBB179_17
.LBB179_16:                             // %B19
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB179_17:                             // %B31
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB179_19
// %bb.18:                              // %B33
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB179_19:                             // %B32
	b	.Lexception_spill_top1_asm_h
.Lfunc_end179:
	.size	.Lneq_1_asm_h, .Lfunc_end179-.Lneq_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function strict_eq_1_asm_h
	.type	.Lstrict_eq_1_asm_h,@function
.Lstrict_eq_1_asm_h:                    // @strict_eq_1_asm_h
// %bb.0:                               // %B29
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB180_2
// %bb.1:                               // %B30
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB180_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB180_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB180_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB180_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB180_10
.LBB180_6:                              // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB180_7:                              // %B11
	cmp	x22, x21
	b.ne	.LBB180_11
// %bb.8:                               // %B12
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB180_9:                              // %B9
	scvtf	d0, w22
	b	.LBB180_6
.LBB180_10:                             // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB180_11:                             // %B14
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x9, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w10, eq
	cmp	x9, x11
	ccmp	x9, x12, #4, ne
	cset	w11, eq
	cmp	w10, #1
	b.ne	.LBB180_13
// %bb.12:                              // %B14
	cbnz	w11, .LBB180_18
.LBB180_13:                             // %B17
	mov	x12, #2                         // =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w13, ne
	cmp	x9, x12
	bic	w12, w13, w10
	csinc	w10, w11, wzr, ne
	tbnz	w12, #0, .LBB180_15
// %bb.14:                              // %B17
	tbnz	w10, #0, .LBB180_19
.LBB180_15:                             // %B20
	mov	x10, #-281474976710656          // =0xffff000000000000
	cmp	x8, x10
	b.ne	.LBB180_17
// %bb.16:                              // %B20
	cmp	x9, x10
	b.eq	.LBB180_21
.LBB180_17:                             // %B25
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB180_18:                             // %B15
	str	x21, [x20], #8
	mov	x0, xzr
	b	.LFastStringEqual_asm_h
.LBB180_19:                             // %B26
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB180_23
// %bb.20:                              // %B28
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB180_21:                             // %B22
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #8
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB180_24
// %bb.22:                              // %B24
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB180_23:                             // %B27
	b	.Lexception_spill_top1_asm_h
.LBB180_24:                             // %B23
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end180:
	.size	.Lstrict_eq_1_asm_h, .Lfunc_end180-.Lstrict_eq_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function strict_neq_1_asm_h
	.type	.Lstrict_neq_1_asm_h,@function
.Lstrict_neq_1_asm_h:                   // @strict_neq_1_asm_h
// %bb.0:                               // %B29
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB181_2
// %bb.1:                               // %B30
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB181_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB181_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB181_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB181_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB181_10
.LBB181_6:                              // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB181_7:                              // %B11
	cmp	x22, x21
	b.ne	.LBB181_11
// %bb.8:                               // %B12
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB181_9:                              // %B9
	scvtf	d0, w22
	b	.LBB181_6
.LBB181_10:                             // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB181_11:                             // %B14
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x9, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w10, eq
	cmp	x9, x11
	ccmp	x9, x12, #4, ne
	cset	w11, eq
	cmp	w10, #1
	b.ne	.LBB181_13
// %bb.12:                              // %B14
	cbnz	w11, .LBB181_18
.LBB181_13:                             // %B17
	mov	x12, #2                         // =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w13, ne
	cmp	x9, x12
	bic	w12, w13, w10
	csinc	w10, w11, wzr, ne
	tbnz	w12, #0, .LBB181_15
// %bb.14:                              // %B17
	tbnz	w10, #0, .LBB181_19
.LBB181_15:                             // %B20
	mov	x10, #-281474976710656          // =0xffff000000000000
	cmp	x8, x10
	b.ne	.LBB181_17
// %bb.16:                              // %B20
	cmp	x9, x10
	b.eq	.LBB181_21
.LBB181_17:                             // %B25
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB181_18:                             // %B15
	str	x21, [x20], #8
	mov	w0, #1                          // =0x1
	b	.LFastStringEqual_asm_h
.LBB181_19:                             // %B26
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB181_23
// %bb.20:                              // %B28
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB181_21:                             // %B22
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #8
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB181_24
// %bb.22:                              // %B24
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB181_23:                             // %B27
	b	.Lexception_spill_top1_asm_h
.LBB181_24:                             // %B23
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end181:
	.size	.Lstrict_neq_1_asm_h, .Lfunc_end181-.Lstrict_neq_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function and_1_asm_h
	.type	.Land_1_asm_h,@function
.Land_1_asm_h:                          // @and_1_asm_h
// %bb.0:                               // %B19
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB182_3
// %bb.1:                               // %B20
	mov	w8, w22
.LBB182_2:                              // %B12
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	and	w8, w8, w21
	add	x9, x25, x9, lsl #3
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	br	x1
.LBB182_3:                              // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB182_5
// %bb.4:                               // %B2
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB182_8
.LBB182_5:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        // =0xad
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB182_7
// %bb.6:                               // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB182_7:                              // %B17
	b	.Lexception_spill_top1_asm_h
.LBB182_8:                              // %B10
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB182_5
// %bb.9:                               // %B11
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB182_2
.Lfunc_end182:
	.size	.Land_1_asm_h, .Lfunc_end182-.Land_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function xor_1_asm_h
	.type	.Lxor_1_asm_h,@function
.Lxor_1_asm_h:                          // @xor_1_asm_h
// %bb.0:                               // %B19
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB183_3
// %bb.1:                               // %B20
	mov	w8, w22
.LBB183_2:                              // %B12
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	eor	w8, w8, w21
	add	x9, x25, x9, lsl #3
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	br	x1
.LBB183_3:                              // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB183_5
// %bb.4:                               // %B2
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB183_8
.LBB183_5:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        // =0xae
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB183_7
// %bb.6:                               // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB183_7:                              // %B17
	b	.Lexception_spill_top1_asm_h
.LBB183_8:                              // %B10
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB183_5
// %bb.9:                               // %B11
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB183_2
.Lfunc_end183:
	.size	.Lxor_1_asm_h, .Lfunc_end183-.Lxor_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function or_1_asm_h
	.type	.Lor_1_asm_h,@function
.Lor_1_asm_h:                           // @or_1_asm_h
// %bb.0:                               // %B19
	mov	x21, x22
	ldur	x22, [x20, #-8]
	eor	x9, x21, #0xfffe000000000000
	eor	x8, x22, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB184_3
// %bb.1:                               // %B20
	mov	w8, w22
.LBB184_2:                              // %B12
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	w8, w8, w21
	add	x9, x25, x9, lsl #3
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	br	x1
.LBB184_3:                              // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB184_5
// %bb.4:                               // %B2
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB184_8
.LBB184_5:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        // =0xaf
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB184_7
// %bb.6:                               // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB184_7:                              // %B17
	b	.Lexception_spill_top1_asm_h
.LBB184_8:                              // %B10
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB184_5
// %bb.9:                               // %B11
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB184_2
.Lfunc_end184:
	.size	.Lor_1_asm_h, .Lfunc_end184-.Lor_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_minus1_1_asm_h
	.type	.Lpush_minus1_1_asm_h,@function
.Lpush_minus1_1_asm_h:                  // @push_minus1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562945658454017          // =0xfffe0000ffffffff
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end185:
	.size	.Lpush_minus1_1_asm_h, .Lfunc_end185-.Lpush_minus1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_0_1_asm_h
	.type	.Lpush_0_1_asm_h,@function
.Lpush_0_1_asm_h:                       // @push_0_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421312          // =0xfffe000000000000
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end186:
	.size	.Lpush_0_1_asm_h, .Lfunc_end186-.Lpush_0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_1_1_asm_h
	.type	.Lpush_1_1_asm_h,@function
.Lpush_1_1_asm_h:                       // @push_1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421311          // =0xfffe000000000001
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end187:
	.size	.Lpush_1_1_asm_h, .Lfunc_end187-.Lpush_1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_2_1_asm_h
	.type	.Lpush_2_1_asm_h,@function
.Lpush_2_1_asm_h:                       // @push_2_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #2                         // =0x2
	movk	x21, #65534, lsl #48
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end188:
	.size	.Lpush_2_1_asm_h, .Lfunc_end188-.Lpush_2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_3_1_asm_h
	.type	.Lpush_3_1_asm_h,@function
.Lpush_3_1_asm_h:                       // @push_3_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421309          // =0xfffe000000000003
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end189:
	.size	.Lpush_3_1_asm_h, .Lfunc_end189-.Lpush_3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_4_1_asm_h
	.type	.Lpush_4_1_asm_h,@function
.Lpush_4_1_asm_h:                       // @push_4_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #4                         // =0x4
	movk	x21, #65534, lsl #48
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end190:
	.size	.Lpush_4_1_asm_h, .Lfunc_end190-.Lpush_4_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_5_1_asm_h
	.type	.Lpush_5_1_asm_h,@function
.Lpush_5_1_asm_h:                       // @push_5_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #5                         // =0x5
	movk	x21, #65534, lsl #48
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end191:
	.size	.Lpush_5_1_asm_h, .Lfunc_end191-.Lpush_5_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_6_1_asm_h
	.type	.Lpush_6_1_asm_h,@function
.Lpush_6_1_asm_h:                       // @push_6_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #6                         // =0x6
	movk	x21, #65534, lsl #48
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end192:
	.size	.Lpush_6_1_asm_h, .Lfunc_end192-.Lpush_6_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_7_1_asm_h
	.type	.Lpush_7_1_asm_h,@function
.Lpush_7_1_asm_h:                       // @push_7_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421305          // =0xfffe000000000007
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end193:
	.size	.Lpush_7_1_asm_h, .Lfunc_end193-.Lpush_7_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i8_1_asm_h
	.type	.Lpush_i8_1_asm_h,@function
.Lpush_i8_1_asm_h:                      // @push_i8_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #1]
	ldrsb	w9, [x19]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	orr	x21, x9, #0xfffe000000000000
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end194:
	.size	.Lpush_i8_1_asm_h, .Lfunc_end194-.Lpush_i8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i16_1_asm_h
	.type	.Lpush_i16_1_asm_h,@function
.Lpush_i16_1_asm_h:                     // @push_i16_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	ldrsh	w9, [x19]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	orr	x21, x9, #0xfffe000000000000
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end195:
	.size	.Lpush_i16_1_asm_h, .Lfunc_end195-.Lpush_i16_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_const8_1_asm_h
	.type	.Lpush_const8_1_asm_h,@function
.Lpush_const8_1_asm_h:                  // @push_const8_1_asm_h
// %bb.0:                               // %B0
	ldrb	w9, [x19, #1]
	ldr	x8, [x23, #104]
	ldrb	w10, [x19], #2
	add	x9, x25, x9, lsl #3
	ldr	x21, [x8, x10, lsl #3]
	ldr	x1, [x9, #3888]
	br	x1
.Lfunc_end196:
	.size	.Lpush_const8_1_asm_h, .Lfunc_end196-.Lpush_const8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function fclosure8_1_asm_h
	.type	.Lfclosure8_1_asm_h,@function
.Lfclosure8_1_asm_h:                    // @fclosure8_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lfclosure8_0_asm_h
.Lfunc_end197:
	.size	.Lfclosure8_1_asm_h, .Lfunc_end197-.Lfclosure8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc8_1_asm_h
	.type	.Lget_loc8_1_asm_h,@function
.Lget_loc8_1_asm_h:                     // @get_loc8_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #1]
	ldrb	w9, [x19], #2
	add	x8, x25, x8, lsl #3
	ldr	x21, [x27, x9, lsl #3]
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end198:
	.size	.Lget_loc8_1_asm_h, .Lfunc_end198-.Lget_loc8_1_asm_h
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
.Lfunc_end199:
	.size	.Lput_loc8_1_asm_h, .Lfunc_end199-.Lput_loc8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc8_1_asm_h
	.type	.Lset_loc8_1_asm_h,@function
.Lset_loc8_1_asm_h:                     // @set_loc8_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end200:
	.size	.Lset_loc8_1_asm_h, .Lfunc_end200-.Lset_loc8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc0_1_asm_h
	.type	.Lget_loc0_1_asm_h,@function
.Lget_loc0_1_asm_h:                     // @get_loc0_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end201:
	.size	.Lget_loc0_1_asm_h, .Lfunc_end201-.Lget_loc0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc1_1_asm_h
	.type	.Lget_loc1_1_asm_h,@function
.Lget_loc1_1_asm_h:                     // @get_loc1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27, #8]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end202:
	.size	.Lget_loc1_1_asm_h, .Lfunc_end202-.Lget_loc1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc2_1_asm_h
	.type	.Lget_loc2_1_asm_h,@function
.Lget_loc2_1_asm_h:                     // @get_loc2_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27, #16]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end203:
	.size	.Lget_loc2_1_asm_h, .Lfunc_end203-.Lget_loc2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc3_1_asm_h
	.type	.Lget_loc3_1_asm_h,@function
.Lget_loc3_1_asm_h:                     // @get_loc3_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27, #24]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end204:
	.size	.Lget_loc3_1_asm_h, .Lfunc_end204-.Lget_loc3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc0_1_asm_h
	.type	.Lput_loc0_1_asm_h,@function
.Lput_loc0_1_asm_h:                     // @put_loc0_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end205:
	.size	.Lput_loc0_1_asm_h, .Lfunc_end205-.Lput_loc0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc1_1_asm_h
	.type	.Lput_loc1_1_asm_h,@function
.Lput_loc1_1_asm_h:                     // @put_loc1_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end206:
	.size	.Lput_loc1_1_asm_h, .Lfunc_end206-.Lput_loc1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc2_1_asm_h
	.type	.Lput_loc2_1_asm_h,@function
.Lput_loc2_1_asm_h:                     // @put_loc2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end207:
	.size	.Lput_loc2_1_asm_h, .Lfunc_end207-.Lput_loc2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc3_1_asm_h
	.type	.Lput_loc3_1_asm_h,@function
.Lput_loc3_1_asm_h:                     // @put_loc3_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end208:
	.size	.Lput_loc3_1_asm_h, .Lfunc_end208-.Lput_loc3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc0_1_asm_h
	.type	.Lset_loc0_1_asm_h,@function
.Lset_loc0_1_asm_h:                     // @set_loc0_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end209:
	.size	.Lset_loc0_1_asm_h, .Lfunc_end209-.Lset_loc0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc1_1_asm_h
	.type	.Lset_loc1_1_asm_h,@function
.Lset_loc1_1_asm_h:                     // @set_loc1_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end210:
	.size	.Lset_loc1_1_asm_h, .Lfunc_end210-.Lset_loc1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc2_1_asm_h
	.type	.Lset_loc2_1_asm_h,@function
.Lset_loc2_1_asm_h:                     // @set_loc2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end211:
	.size	.Lset_loc2_1_asm_h, .Lfunc_end211-.Lset_loc2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc3_1_asm_h
	.type	.Lset_loc3_1_asm_h,@function
.Lset_loc3_1_asm_h:                     // @set_loc3_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end212:
	.size	.Lset_loc3_1_asm_h, .Lfunc_end212-.Lset_loc3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg0_1_asm_h
	.type	.Lget_arg0_1_asm_h,@function
.Lget_arg0_1_asm_h:                     // @get_arg0_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end213:
	.size	.Lget_arg0_1_asm_h, .Lfunc_end213-.Lget_arg0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg1_1_asm_h
	.type	.Lget_arg1_1_asm_h,@function
.Lget_arg1_1_asm_h:                     // @get_arg1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28, #8]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end214:
	.size	.Lget_arg1_1_asm_h, .Lfunc_end214-.Lget_arg1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg2_1_asm_h
	.type	.Lget_arg2_1_asm_h,@function
.Lget_arg2_1_asm_h:                     // @get_arg2_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28, #16]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end215:
	.size	.Lget_arg2_1_asm_h, .Lfunc_end215-.Lget_arg2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg3_1_asm_h
	.type	.Lget_arg3_1_asm_h,@function
.Lget_arg3_1_asm_h:                     // @get_arg3_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28, #24]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end216:
	.size	.Lget_arg3_1_asm_h, .Lfunc_end216-.Lget_arg3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg0_1_asm_h
	.type	.Lput_arg0_1_asm_h,@function
.Lput_arg0_1_asm_h:                     // @put_arg0_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end217:
	.size	.Lput_arg0_1_asm_h, .Lfunc_end217-.Lput_arg0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg1_1_asm_h
	.type	.Lput_arg1_1_asm_h,@function
.Lput_arg1_1_asm_h:                     // @put_arg1_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end218:
	.size	.Lput_arg1_1_asm_h, .Lfunc_end218-.Lput_arg1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg2_1_asm_h
	.type	.Lput_arg2_1_asm_h,@function
.Lput_arg2_1_asm_h:                     // @put_arg2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end219:
	.size	.Lput_arg2_1_asm_h, .Lfunc_end219-.Lput_arg2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg3_1_asm_h
	.type	.Lput_arg3_1_asm_h,@function
.Lput_arg3_1_asm_h:                     // @put_arg3_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end220:
	.size	.Lput_arg3_1_asm_h, .Lfunc_end220-.Lput_arg3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref0_1_asm_h
	.type	.Lget_var_ref0_1_asm_h,@function
.Lget_var_ref0_1_asm_h:                 // @get_var_ref0_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x9, [x26]
	add	x8, x25, x8, lsl #3
	ldr	x9, [x9]
	ldr	x1, [x8, #3888]
	ldr	x21, [x9]
	br	x1
.Lfunc_end221:
	.size	.Lget_var_ref0_1_asm_h, .Lfunc_end221-.Lget_var_ref0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref1_1_asm_h
	.type	.Lget_var_ref1_1_asm_h,@function
.Lget_var_ref1_1_asm_h:                 // @get_var_ref1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x9, [x26, #8]
	add	x8, x25, x8, lsl #3
	ldr	x9, [x9]
	ldr	x1, [x8, #3888]
	ldr	x21, [x9]
	br	x1
.Lfunc_end222:
	.size	.Lget_var_ref1_1_asm_h, .Lfunc_end222-.Lget_var_ref1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref2_1_asm_h
	.type	.Lget_var_ref2_1_asm_h,@function
.Lget_var_ref2_1_asm_h:                 // @get_var_ref2_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x9, [x26, #16]
	add	x8, x25, x8, lsl #3
	ldr	x9, [x9]
	ldr	x1, [x8, #3888]
	ldr	x21, [x9]
	br	x1
.Lfunc_end223:
	.size	.Lget_var_ref2_1_asm_h, .Lfunc_end223-.Lget_var_ref2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref3_1_asm_h
	.type	.Lget_var_ref3_1_asm_h,@function
.Lget_var_ref3_1_asm_h:                 // @get_var_ref3_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x9, [x26, #24]
	add	x8, x25, x8, lsl #3
	ldr	x9, [x9]
	ldr	x1, [x8, #3888]
	ldr	x21, [x9]
	br	x1
.Lfunc_end224:
	.size	.Lget_var_ref3_1_asm_h, .Lfunc_end224-.Lget_var_ref3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref0_1_asm_h
	.type	.Lput_var_ref0_1_asm_h,@function
.Lput_var_ref0_1_asm_h:                 // @put_var_ref0_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end225:
	.size	.Lput_var_ref0_1_asm_h, .Lfunc_end225-.Lput_var_ref0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref1_1_asm_h
	.type	.Lput_var_ref1_1_asm_h,@function
.Lput_var_ref1_1_asm_h:                 // @put_var_ref1_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end226:
	.size	.Lput_var_ref1_1_asm_h, .Lfunc_end226-.Lput_var_ref1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref2_1_asm_h
	.type	.Lput_var_ref2_1_asm_h,@function
.Lput_var_ref2_1_asm_h:                 // @put_var_ref2_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end227:
	.size	.Lput_var_ref2_1_asm_h, .Lfunc_end227-.Lput_var_ref2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref3_1_asm_h
	.type	.Lput_var_ref3_1_asm_h,@function
.Lput_var_ref3_1_asm_h:                 // @put_var_ref3_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end228:
	.size	.Lput_var_ref3_1_asm_h, .Lfunc_end228-.Lput_var_ref3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_length_1_asm_h
	.type	.Lget_length_1_asm_h,@function
.Lget_length_1_asm_h:                   // @get_length_1_asm_h
// %bb.0:                               // %B27
	mov	x9, #2                          // =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	.LBB229_2
// %bb.1:                               // %B27
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB229_3
.LBB229_2:                              // %B28
	ldrb	w8, [x19], #1
	and	x9, x22, #0xfffffffffffc
	ldr	w9, [x9, #4]
	mov	x10, #-562949953421312          // =0xfffe000000000000
	add	x8, x25, x8, lsl #3
	bfxil	x10, x9, #0, #30
	ldr	x1, [x8, #1944]
	mov	x22, x10
	br	x1
.LBB229_3:                              // %B21
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB229_13
// %bb.4:                               // %B22
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB229_5:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB229_6 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	x11, x11, #0x30
	ldr	w11, [x13, x11, lsl #2]
	add	w12, w12, #4
	add	x12, x13, x12
	cbz	w11, .LBB229_8
.LBB229_6:                              // %B1
                                        //   Parent Loop BB229_5 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	ldr	x13, [x12, w13, uxtw]
	lsr	x14, x13, #32
	cmp	x14, #48
	b.eq	.LBB229_10
// %bb.7:                               // %B9
                                        //   in Loop: Header=BB229_6 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB229_6
.LBB229_8:                              // %B14
                                        //   in Loop: Header=BB229_5 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB229_13
// %bb.9:                               // %B17
                                        //   in Loop: Header=BB229_5 Depth=1
	ldr	x9, [x10, #32]
	cbnz	x9, .LBB229_5
	b	.LBB229_12
.LBB229_10:                             // %B3
	lsr	w8, w13, #30
	cbnz	w8, .LBB229_13
// %bb.11:                              // %B4
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB229_12:                             // %B6
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB229_13:                             // %B24
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
	b.eq	.LBB229_15
// %bb.14:                              // %B26
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB229_15:                             // %B25
	b	.Lexception_spill_top0_asm_h
.Lfunc_end229:
	.size	.Lget_length_1_asm_h, .Lfunc_end229-.Lget_length_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_false8_1_asm_h
	.type	.Lif_false8_1_asm_h,@function
.Lif_false8_1_asm_h:                    // @if_false8_1_asm_h
// %bb.0:                               // %B25
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB230_3
// %bb.1:                               // %B1
	cbz	x8, .LBB230_10
.LBB230_2:                              // %B6
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB230_3:                              // %B7
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB230_5
// %bb.4:                               // %B9
	cbnz	w22, .LBB230_2
	b	.LBB230_10
.LBB230_5:                              // %B13
	and	x8, x22, #0xffffffffffffffef
	cmp	x8, #2
	b.eq	.LBB230_10
// %bb.6:                               // %B16
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	.LBB230_2
// %bb.7:                               // %B19
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842624          // =0xfffc000000000000
	add	x8, x22, x8
	cmp	x8, x9
	b.lo	.LBB230_9
// %bb.8:                               // %B24
	str	x22, [x20], #8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.LBB230_9:                              // %B21
	fmov	d0, x8
	fcmp	d0, #0.0
	b.mi	.LBB230_2
	b.gt	.LBB230_2
.LBB230_10:                             // %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end230:
	.size	.Lif_false8_1_asm_h, .Lfunc_end230-.Lif_false8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_true8_1_asm_h
	.type	.Lif_true8_1_asm_h,@function
.Lif_true8_1_asm_h:                     // @if_true8_1_asm_h
// %bb.0:                               // %B25
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB231_3
// %bb.1:                               // %B1
	cbz	x8, .LBB231_10
.LBB231_2:                              // %B6
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB231_3:                              // %B7
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB231_5
// %bb.4:                               // %B9
	cbnz	w22, .LBB231_2
	b	.LBB231_10
.LBB231_5:                              // %B13
	and	x8, x22, #0xffffffffffffffef
	cmp	x8, #2
	b.eq	.LBB231_10
// %bb.6:                               // %B16
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	.LBB231_2
// %bb.7:                               // %B19
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842624          // =0xfffc000000000000
	add	x8, x22, x8
	cmp	x8, x9
	b.lo	.LBB231_9
// %bb.8:                               // %B24
	str	x22, [x20], #8
	mov	x0, x22
	b	.LSlowToBoolean_asm_h
.LBB231_9:                              // %B21
	fmov	d0, x8
	fcmp	d0, #0.0
	b.mi	.LBB231_2
	b.gt	.LBB231_2
.LBB231_10:                             // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end231:
	.size	.Lif_true8_1_asm_h, .Lfunc_end231-.Lif_true8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function goto8_1_asm_h
	.type	.Lgoto8_1_asm_h,@function
.Lgoto8_1_asm_h:                        // @goto8_1_asm_h
// %bb.0:                               // %B0
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end232:
	.size	.Lgoto8_1_asm_h, .Lfunc_end232-.Lgoto8_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function goto16_1_asm_h
	.type	.Lgoto16_1_asm_h,@function
.Lgoto16_1_asm_h:                       // @goto16_1_asm_h
// %bb.0:                               // %B0
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end233:
	.size	.Lgoto16_1_asm_h, .Lfunc_end233-.Lgoto16_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call0_1_asm_h
	.type	.Lcall0_1_asm_h,@function
.Lcall0_1_asm_h:                        // @call0_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcall0_0_asm_h
.Lfunc_end234:
	.size	.Lcall0_1_asm_h, .Lfunc_end234-.Lcall0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call1_1_asm_h
	.type	.Lcall1_1_asm_h,@function
.Lcall1_1_asm_h:                        // @call1_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcall1_0_asm_h
.Lfunc_end235:
	.size	.Lcall1_1_asm_h, .Lfunc_end235-.Lcall1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call2_1_asm_h
	.type	.Lcall2_1_asm_h,@function
.Lcall2_1_asm_h:                        // @call2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcall2_0_asm_h
.Lfunc_end236:
	.size	.Lcall2_1_asm_h, .Lfunc_end236-.Lcall2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call3_1_asm_h
	.type	.Lcall3_1_asm_h,@function
.Lcall3_1_asm_h:                        // @call3_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcall3_0_asm_h
.Lfunc_end237:
	.size	.Lcall3_1_asm_h, .Lfunc_end237-.Lcall3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_undefined_1_asm_h
	.type	.Lis_undefined_1_asm_h,@function
.Lis_undefined_1_asm_h:                 // @is_undefined_1_asm_h
// %bb.0:                               // %B2
	cmp	x22, #18
	b.ne	.LBB238_2
// %bb.1:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB238_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end238:
	.size	.Lis_undefined_1_asm_h, .Lfunc_end238-.Lis_undefined_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_null_1_asm_h
	.type	.Lis_null_1_asm_h,@function
.Lis_null_1_asm_h:                      // @is_null_1_asm_h
// %bb.0:                               // %B2
	cmp	x22, #2
	b.ne	.LBB239_2
// %bb.1:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB239_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end239:
	.size	.Lis_null_1_asm_h, .Lfunc_end239-.Lis_null_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_function_1_asm_h
	.type	.Lis_function_1_asm_h,@function
.Lis_function_1_asm_h:                  // @is_function_1_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x22
	bl	js_operator_typeof_gc
	cmp	w0, #27
	b.ne	.LBB240_2
// %bb.1:                               // %B2
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB240_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end240:
	.size	.Lis_function_1_asm_h, .Lfunc_end240-.Lis_function_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i32_2_asm_h
	.type	.Lpush_i32_2_asm_h,@function
.Lpush_i32_2_asm_h:                     // @push_i32_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #4]
	ldr	w9, [x19], #5
	add	x8, x25, x8, lsl #3
	orr	x21, x9, #0xfffe000000000000
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end241:
	.size	.Lpush_i32_2_asm_h, .Lfunc_end241-.Lpush_i32_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x9, [x9, x10, lsl #3]
	ldr	x1, [x8, #3888]
	mov	x21, x9
	br	x1
.Lfunc_end242:
	.size	.Lpush_const_2_asm_h, .Lfunc_end242-.Lpush_const_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function fclosure_2_asm_h
	.type	.Lfclosure_2_asm_h,@function
.Lfclosure_2_asm_h:                     // @fclosure_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lfclosure_0_asm_h
.Lfunc_end243:
	.size	.Lfclosure_2_asm_h, .Lfunc_end243-.Lfclosure_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function undefined_2_asm_h
	.type	.Lundefined_2_asm_h,@function
.Lundefined_2_asm_h:                    // @undefined_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #18                        // =0x12
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end244:
	.size	.Lundefined_2_asm_h, .Lfunc_end244-.Lundefined_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function null_2_asm_h
	.type	.Lnull_2_asm_h,@function
.Lnull_2_asm_h:                         // @null_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #2                         // =0x2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end245:
	.size	.Lnull_2_asm_h, .Lfunc_end245-.Lnull_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_this_2_asm_h
	.type	.Lpush_this_2_asm_h,@function
.Lpush_this_2_asm_h:                    // @push_this_2_asm_h
// %bb.0:                               // %B12
	mov	x8, x20
	str	x22, [x20], #8
	ldrb	w9, [x23, #44]
	ldr	x1, [x23, #80]
	tbnz	w9, #0, .LBB246_2
// %bb.1:                               // %B12
	and	x9, x1, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, .LBB246_3
.LBB246_2:                              // %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x1
	add	x8, x25, x8, lsl #3
	ldr	x2, [x8, #3888]
	br	x2
.LBB246_3:                              // %B6
	orr	x9, x1, #0x10
	cmp	x9, #18
	b.ne	.LBB246_5
// %bb.4:                               // %B7
	ldrb	w8, [x19], #1
	ldr	x9, [x24, #208]
	mov	x22, x21
	add	x8, x25, x8, lsl #3
	mov	x21, x9
	ldr	x1, [x8, #3888]
	br	x1
.LBB246_5:                              // %B9
	add	x9, x8, #16
	mov	x0, x24
	str	x21, [x8, #8]
	str	x9, [x23, #48]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB246_7
// %bb.6:                               // %B11
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB246_7:                              // %B10
	b	.Lexception_spill_top1_asm_h
.Lfunc_end246:
	.size	.Lpush_this_2_asm_h, .Lfunc_end246-.Lpush_this_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_false_2_asm_h
	.type	.Lpush_false_2_asm_h,@function
.Lpush_false_2_asm_h:                   // @push_false_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end247:
	.size	.Lpush_false_2_asm_h, .Lfunc_end247-.Lpush_false_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_true_2_asm_h
	.type	.Lpush_true_2_asm_h,@function
.Lpush_true_2_asm_h:                    // @push_true_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end248:
	.size	.Lpush_true_2_asm_h, .Lfunc_end248-.Lpush_true_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function object_2_asm_h
	.type	.Lobject_2_asm_h,@function
.Lobject_2_asm_h:                       // @object_2_asm_h
// %bb.0:                               // %B15
	sub	sp, sp, #16
	mov	x8, x20
	str	x22, [x8], #8
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	ldrb	w8, [x24, #355]
	cbnz	w8, .LBB249_6
// %bb.1:                               // %B1
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB249_6
// %bb.2:                               // %B5
	ldr	x8, [x24, #392]
	cbz	x8, .LBB249_6
// %bb.3:                               // %B8
	add	x8, x20, #16
	mov	x0, x24
	mov	w1, #64                         // =0x40
	mov	w2, #2                          // =0x2
	str	x21, [x20, #8]
	str	x8, [x23, #48]
	bl	prim_try_malloc_gc
	cbz	x0, .LBB249_6
// %bb.4:                               // %B9
	ldr	x8, [x24, #392]
	ldr	w9, [x8]
	add	w9, w9, #1
	str	w9, [x8]
	mov	w9, #1                          // =0x1
	str	w9, [x0]
	strb	w9, [x0, #5]
	strh	w9, [x0, #6]
	add	x9, x0, #8
	stlr	x8, [x9]
	add	x8, x0, #32
	str	x8, [x0, #16]
.LBB249_5:                              // %B14
	ldrb	w8, [x19], #1
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	mov	x22, x21
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	add	sp, sp, #16
	br	x1
.LBB249_6:                              // %B12
	add	x8, x20, #16
	mov	x0, x24
	str	x21, [x20, #8]
	str	x8, [x23, #48]
	bl	PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.ne	.LBB249_5
// %bb.7:                               // %B13
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	add	sp, sp, #16
	b	.Lexception_spill_top1_asm_h
.Lfunc_end249:
	.size	.Lobject_2_asm_h, .Lfunc_end249-.Lobject_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function drop_2_asm_h
	.type	.Ldrop_2_asm_h,@function
.Ldrop_2_asm_h:                         // @drop_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end250:
	.size	.Ldrop_2_asm_h, .Lfunc_end250-.Ldrop_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nip_2_asm_h
	.type	.Lnip_2_asm_h,@function
.Lnip_2_asm_h:                          // @nip_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, x21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end251:
	.size	.Lnip_2_asm_h, .Lfunc_end251-.Lnip_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup_2_asm_h
	.type	.Ldup_2_asm_h,@function
.Ldup_2_asm_h:                          // @dup_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end252:
	.size	.Ldup_2_asm_h, .Lfunc_end252-.Ldup_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x2, [x8, #3888]
	br	x2
.Lfunc_end253:
	.size	.Ldup1_2_asm_h, .Lfunc_end253-.Ldup1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function swap_2_asm_h
	.type	.Lswap_2_asm_h,@function
.Lswap_2_asm_h:                         // @swap_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x2, x22
	mov	x22, x21
	mov	x21, x2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end254:
	.size	.Lswap_2_asm_h, .Lfunc_end254-.Lswap_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_constructor_2_asm_h
	.type	.Lcall_constructor_2_asm_h,@function
.Lcall_constructor_2_asm_h:             // @call_constructor_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcall_constructor_0_asm_h
.Lfunc_end255:
	.size	.Lcall_constructor_2_asm_h, .Lfunc_end255-.Lcall_constructor_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_2_asm_h
	.type	.Lcall_2_asm_h,@function
.Lcall_2_asm_h:                         // @call_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcall_0_asm_h
.Lfunc_end256:
	.size	.Lcall_2_asm_h, .Lfunc_end256-.Lcall_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call_method_2_asm_h
	.type	.Lcall_method_2_asm_h,@function
.Lcall_method_2_asm_h:                  // @call_method_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcall_method_0_asm_h
.Lfunc_end257:
	.size	.Lcall_method_2_asm_h, .Lfunc_end257-.Lcall_method_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function array_from_2_asm_h
	.type	.Larray_from_2_asm_h,@function
.Larray_from_2_asm_h:                   // @array_from_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Larray_from_0_asm_h
.Lfunc_end258:
	.size	.Larray_from_2_asm_h, .Lfunc_end258-.Larray_from_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_2_asm_h
	.type	.Lreturn_2_asm_h,@function
.Lreturn_2_asm_h:                       // @return_2_asm_h
// %bb.0:                               // %B0
	mov	x0, x21
	b	.Lcommon_return_asm_h
.Lfunc_end259:
	.size	.Lreturn_2_asm_h, .Lfunc_end259-.Lreturn_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_undef_2_asm_h
	.type	.Lreturn_undef_2_asm_h,@function
.Lreturn_undef_2_asm_h:                 // @return_undef_2_asm_h
// %bb.0:                               // %B0
	mov	w0, #18                         // =0x12
	b	.Lcommon_return_asm_h
.Lfunc_end260:
	.size	.Lreturn_undef_2_asm_h, .Lfunc_end260-.Lreturn_undef_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_undef_2_asm_h
	.type	.Lget_var_undef_2_asm_h,@function
.Lget_var_undef_2_asm_h:                // @get_var_undef_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	str	x22, [x20], #8
	ldr	x9, [x24, #216]
	ldr	w1, [x19]
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x10, x10, #64
	lsl	w12, w11, #2
	and	w11, w1, w11
	ldr	w11, [x10, w11, sxtw #2]
	add	w12, w12, #4
	add	x10, x10, x12
	cbz	w11, .LBB261_3
.LBB261_1:                              // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	ldr	x12, [x10, w12, uxtw]
	lsr	x13, x12, #32
	cmp	w1, w13
	b.eq	.LBB261_10
// %bb.2:                               // %B8
                                        //   in Loop: Header=BB261_1 Depth=1
	and	w11, w12, #0x3ffffff
	cbnz	w11, .LBB261_1
.LBB261_3:                              // %B33
	ldr	x9, [x24, #208]
	mov	w10, #18                        // =0x12
.LBB261_4:                              // %B22
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB261_5 Depth 2
	ldr	x12, [x9, #8]
	ldr	w11, [x12, #12]
	add	x14, x12, #64
	lsl	w13, w11, #2
	and	w11, w1, w11
	ldr	w11, [x14, w11, sxtw #2]
	add	w13, w13, #4
	add	x13, x14, x13
	cbz	w11, .LBB261_7
.LBB261_5:                              // %B26
                                        //   Parent Loop BB261_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w14, w11, #3
	sub	w14, w14, #8
	add	x14, x13, x14
	ldp	w14, w15, [x14]
	cmp	w1, w15
	b.eq	.LBB261_9
// %bb.6:                               // %B28
                                        //   in Loop: Header=BB261_5 Depth=2
	and	w11, w14, #0x3ffffff
	cbnz	w11, .LBB261_5
.LBB261_7:                              // %B17
                                        //   in Loop: Header=BB261_4 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB261_13
// %bb.8:                               // %B20
                                        //   in Loop: Header=BB261_4 Depth=1
	ldr	x9, [x12, #32]
	cbnz	x9, .LBB261_4
	b	.LBB261_11
.LBB261_9:                              // %B9
	lsr	w10, w14, #30
	cbnz	w10, .LBB261_13
.LBB261_10:                             // %B2
	ldr	x9, [x9, #16]
	sub	w10, w11, #1
	ldr	x10, [x9, w10, sxtw #3]
	cmp	x10, #34
	b.eq	.LBB261_12
.LBB261_11:                             // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x10
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB261_12:                             // %B3
	add	x20, x8, #16
	str	x21, [x8, #8]
	b	.LThrowReferenceErrorUninitialized_asm_h
.LBB261_13:                             // %B14
	add	x9, x8, #16
	mov	x0, x24
	mov	w2, wzr
	str	x21, [x8, #8]
	str	x9, [x23, #48]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB261_15
// %bb.14:                              // %B16
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB261_15:                             // %B15
	b	.Lexception_spill_top1_asm_h
.Lfunc_end261:
	.size	.Lget_var_undef_2_asm_h, .Lfunc_end261-.Lget_var_undef_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_2_asm_h
	.type	.Lget_var_2_asm_h,@function
.Lget_var_2_asm_h:                      // @get_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	str	x22, [x20], #8
	ldr	x9, [x24, #216]
	ldr	w1, [x19]
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w1, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, .LBB262_3
.LBB262_1:                              // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	ldr	x12, [x11, w12, uxtw]
	lsr	x13, x12, #32
	cmp	w1, w13
	b.eq	.LBB262_10
// %bb.2:                               // %B8
                                        //   in Loop: Header=BB262_1 Depth=1
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB262_1
.LBB262_3:                              // %B32
	ldr	x9, [x24, #208]
.LBB262_4:                              // %B21
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB262_5 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	add	x13, x11, #64
	lsl	w12, w10, #2
	and	w10, w1, w10
	ldr	w10, [x13, w10, sxtw #2]
	add	w12, w12, #4
	add	x12, x13, x12
	cbz	w10, .LBB262_7
.LBB262_5:                              // %B25
                                        //   Parent Loop BB262_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w10, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w1, w14
	b.eq	.LBB262_9
// %bb.6:                               // %B27
                                        //   in Loop: Header=BB262_5 Depth=2
	and	w10, w13, #0x3ffffff
	cbnz	w10, .LBB262_5
.LBB262_7:                              // %B16
                                        //   in Loop: Header=BB262_4 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB262_13
// %bb.8:                               // %B19
                                        //   in Loop: Header=BB262_4 Depth=1
	ldr	x9, [x11, #32]
	cbnz	x9, .LBB262_4
	b	.LBB262_13
.LBB262_9:                              // %B9
	lsr	w11, w13, #30
	cbnz	w11, .LBB262_13
.LBB262_10:                             // %B2
	ldr	x9, [x9, #16]
	sub	w10, w10, #1
	ldr	x9, [x9, w10, sxtw #3]
	cmp	x9, #34
	b.eq	.LBB262_12
// %bb.11:                              // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x9
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB262_12:                             // %B3
	add	x20, x8, #16
	str	x21, [x8, #8]
	b	.LThrowReferenceErrorUninitialized_asm_h
.LBB262_13:                             // %B13
	add	x9, x8, #16
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x21, [x8, #8]
	str	x9, [x23, #48]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB262_15
// %bb.14:                              // %B15
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB262_15:                             // %B14
	b	.Lexception_spill_top1_asm_h
.Lfunc_end262:
	.size	.Lget_var_2_asm_h, .Lfunc_end262-.Lget_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_2_asm_h
	.type	.Lput_var_2_asm_h,@function
.Lput_var_2_asm_h:                      // @put_var_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x24, #216]
	ldr	w1, [x19]
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x12, x9, #64
	lsl	w11, w10, #2
	and	w9, w1, w10
	ldr	w9, [x12, w9, sxtw #2]
	add	w10, w11, #4
	add	x10, x12, x10
	cbz	w9, .LBB263_3
.LBB263_1:                              // %B1
                                        // =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w1, w12
	b.eq	.LBB263_6
// %bb.2:                               // %B19
                                        //   in Loop: Header=BB263_1 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, .LBB263_1
.LBB263_3:                              // %B42
	ldr	x8, [x24, #208]
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x12, x9, #64
	lsl	w11, w10, #2
	and	w9, w1, w10
	ldr	w9, [x12, w9, sxtw #2]
	add	w10, w11, #4
	add	x10, x12, x10
	cbz	w9, .LBB263_15
.LBB263_4:                              // %B32
                                        // =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w1, w12
	b.eq	.LBB263_10
// %bb.5:                               // %B34
                                        //   in Loop: Header=BB263_4 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, .LBB263_4
	b	.LBB263_15
.LBB263_6:                              // %B3
	mov	w10, #-402653184                // =0xe8000000
	and	w10, w11, w10
	mov	w11, #134217728                 // =0x8000000
	cmp	w10, w11
	b.ne	.LBB263_15
// %bb.7:                               // %B14
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	ldr	x10, [x8, w9, sxtw #3]
	cmp	x10, #34
	b.eq	.LBB263_15
// %bb.8:                               // %B23
	str	x21, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB263_12
.LBB263_9:                              // %B8
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB263_10:                             // %B20
	mov	w10, #-402653184                // =0xe8000000
	and	w10, w11, w10
	mov	w11, #134217728                 // =0x8000000
	cmp	w10, w11
	b.ne	.LBB263_15
// %bb.11:                              // %B23
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	str	x21, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB263_9
.LBB263_12:                             // %B26
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB263_9
// %bb.13:                              // %B26
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x21, x8
	cmp	x8, x9
	b.lo	.LBB263_9
// %bb.14:                              // %B8.sink.split
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB263_15:                             // %B37
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_SetGlobalVar_GC
	tbz	w0, #31, .LBB263_9
// %bb.16:                              // %B38
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end263:
	.size	.Lput_var_2_asm_h, .Lfunc_end263-.Lput_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_field_2_asm_h
	.type	.Lget_field_2_asm_h,@function
.Lget_field_2_asm_h:                    // @get_field_2_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	.LBB264_10
// %bb.1:                               // %B25
	mov	x9, x21
	mov	w8, #18                         // =0x12
.LBB264_2:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB264_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w11, w2, w11
	ldr	w11, [x13, w11, sxtw #2]
	add	w12, w12, #4
	add	x12, x13, x12
	cbz	w11, .LBB264_5
.LBB264_3:                              // %B1
                                        //   Parent Loop BB264_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w2, w14
	b.eq	.LBB264_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB264_3 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB264_3
.LBB264_5:                              // %B14
                                        //   in Loop: Header=BB264_2 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB264_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB264_2 Depth=1
	ldr	x9, [x10, #32]
	cbnz	x9, .LBB264_2
	b	.LBB264_9
.LBB264_7:                              // %B3
	lsr	w8, w13, #30
	cbnz	w8, .LBB264_10
// %bb.8:                               // %B4
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB264_9:                              // %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB264_10:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x3, x21
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB264_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB264_12:                             // %B22
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end264:
	.size	.Lget_field_2_asm_h, .Lfunc_end264-.Lget_field_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_field2_2_asm_h
	.type	.Lget_field2_2_asm_h,@function
.Lget_field2_2_asm_h:                   // @get_field2_2_asm_h
// %bb.0:                               // %B24
	mov	x8, x20
	mov	x9, #2                          // =0x2
	str	x22, [x20], #8
	movk	x9, #65535, lsl #48
	ldr	w2, [x19]
	tst	x21, x9
	b.ne	.LBB265_10
// %bb.1:                               // %B25
	mov	x10, x21
	mov	w9, #18                         // =0x12
.LBB265_2:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB265_3 Depth 2
	ldr	x11, [x10, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w12, w2, w12
	ldr	w12, [x14, w12, sxtw #2]
	add	w13, w13, #4
	add	x13, x14, x13
	cbz	w12, .LBB265_5
.LBB265_3:                              // %B1
                                        //   Parent Loop BB265_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w14, w12, #3
	sub	w14, w14, #8
	add	x14, x13, x14
	ldp	w14, w15, [x14]
	cmp	w2, w15
	b.eq	.LBB265_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB265_3 Depth=2
	and	w12, w14, #0x3ffffff
	cbnz	w12, .LBB265_3
.LBB265_5:                              // %B14
                                        //   in Loop: Header=BB265_2 Depth=1
	ldrb	w10, [x10, #5]
	tbnz	w10, #2, .LBB265_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB265_2 Depth=1
	ldr	x10, [x11, #32]
	cbnz	x10, .LBB265_2
	b	.LBB265_9
.LBB265_7:                              // %B3
	lsr	w9, w14, #30
	cbnz	w9, .LBB265_10
// %bb.8:                               // %B4
	ldr	x8, [x10, #16]
	sub	w9, w12, #1
	ldr	x9, [x8, w9, sxtw #3]
.LBB265_9:                              // %B6
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x9
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB265_10:                             // %B21
	add	x9, x8, #16
	mov	x0, x24
	mov	x1, x21
	mov	x3, x21
	mov	w4, wzr
	str	x21, [x8, #8]
	str	x9, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB265_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB265_12:                             // %B22
	b	.Lexception_spill_top1_asm_h
.Lfunc_end265:
	.size	.Lget_field2_2_asm_h, .Lfunc_end265-.Lget_field2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_field_2_asm_h
	.type	.Lput_field_2_asm_h,@function
.Lput_field_2_asm_h:                    // @put_field_2_asm_h
// %bb.0:                               // %B54
	mov	x8, #2                          // =0x2
	mov	x16, x20
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB266_16
// %bb.1:                               // %B55
	ldr	x10, [x22, #8]
	ldr	w8, [x19]
	ldr	w9, [x10, #12]
	add	x12, x10, #64
	lsl	w11, w9, #2
	and	w9, w8, w9
	ldr	w9, [x12, w9, sxtw #2]
	add	w11, w11, #4
	add	x11, x12, x11
	cbz	w9, .LBB266_4
.LBB266_2:                              // %B1
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w9, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w8, w13
	b.eq	.LBB266_12
// %bb.3:                               // %B15
                                        //   in Loop: Header=BB266_2 Depth=1
	and	w9, w12, #0x3ffffff
	cbnz	w9, .LBB266_2
.LBB266_4:                              // %B20
	ldr	w9, [x22, #4]
	tbnz	w9, #10, .LBB266_16
// %bb.5:                               // %B51
	ldr	x10, [x10, #32]
	cbz	x10, .LBB266_11
.LBB266_6:                              // %B49
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB266_7 Depth 2
	ldr	x11, [x10, #8]
	ldr	w12, [x11, #12]
	add	x15, x11, #64
	lsl	w14, w12, #2
	and	w12, w8, w12
	ldr	w13, [x15, w12, sxtw #2]
	add	w12, w14, #4
	add	x12, x15, x12
	cbz	w13, .LBB266_9
.LBB266_7:                              // %B23
                                        //   Parent Loop BB266_6 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w13, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w8, w14
	b.eq	.LBB266_15
// %bb.8:                               // %B39
                                        //   in Loop: Header=BB266_7 Depth=2
	and	w13, w13, #0x3ffffff
	cbnz	w13, .LBB266_7
.LBB266_9:                              // %B44
                                        //   in Loop: Header=BB266_6 Depth=1
	ldrb	w10, [x10, #5]
	tbnz	w10, #2, .LBB266_16
// %bb.10:                              // %B47
                                        //   in Loop: Header=BB266_6 Depth=1
	ldr	x10, [x11, #32]
	cbnz	x10, .LBB266_6
.LBB266_11:                             // %B28
	tbnz	w9, #8, .LBB266_20
	b	.LBB266_16
.LBB266_12:                             // %B3
	mov	w8, #-402653184                 // =0xe8000000
	mov	w10, #134217728                 // =0x8000000
	and	w8, w12, w8
	cmp	w8, w10
	b.ne	.LBB266_16
// %bb.13:                              // %B7
	ldr	x8, [x22, #16]
	sub	w9, w9, #1
	str	x21, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB266_17
.LBB266_14:                             // %B5
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x20, x16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB266_15:                             // %B25
	mov	w10, #-402653184                // =0xe8000000
	mov	w11, #134217728                 // =0x8000000
	and	w12, w9, #0x100
	and	w10, w13, w10
	cmp	w10, w11
	ccmp	w12, #0, #4, eq
	b.ne	.LBB266_20
.LBB266_16:                             // %B14
	add	x20, x16, #16
	stp	x22, x21, [x16]
	mov	x0, xzr
	b	.LSlowPutField_asm_h
.LBB266_17:                             // %B10
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB266_14
// %bb.18:                              // %B10
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x21, x8
	cmp	x8, x9
	b.lo	.LBB266_14
// %bb.19:                              // %B12
	mov	x0, x21
	mov	x1, x24
	mov	x20, x16
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB266_20:                             // %B30
	and	w9, w9, #0xffff0000
	cmp	w9, #16, lsl #12                // =65536
	b.ne	.LBB266_23
// %bb.21:                              // %B30
	tbnz	w8, #31, .LBB266_23
// %bb.22:                              // %B36
	add	x20, x16, #16
	stp	x22, x21, [x16]
	mov	x0, x8
	b	.LFastAddNamedProperty_asm_h
.LBB266_23:                             // %B32
	add	x20, x16, #16
	stp	x22, x21, [x16]
	mov	w0, #1                          // =0x1
	b	.LSlowPutField_asm_h
.Lfunc_end266:
	.size	.Lput_field_2_asm_h, .Lfunc_end266-.Lput_field_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_array_el_2_asm_h
	.type	.Lget_array_el_2_asm_h,@function
.Lget_array_el_2_asm_h:                 // @get_array_el_2_asm_h
// %bb.0:                               // %B36
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB267_6
// %bb.1:                               // %B36
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x8, x9
	b.ne	.LBB267_6
// %bb.2:                               // %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	.LBB267_5
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w8, w21
	b.ls	.LBB267_7
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	add	x8, x25, x8, lsl #3
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x8, #1944]
	br	x1
.LBB267_5:                              // %B30
	sub	w8, w8, #21
	cmp	w8, #8
	b.ls	.LBB267_17
.LBB267_6:                              // %B16
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.LSlowGetArrayEl_asm_h
.LBB267_7:                              // %B7
	tbnz	w21, #31, .LBB267_6
// %bb.8:                               // %B9.preheader
	mov	x9, x22
	orr	w10, w21, #0x80000000
	mov	w8, #18                         // =0x12
.LBB267_9:                              // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB267_10 Depth 2
	ldr	x11, [x9, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w12, w10, w12
	ldr	w12, [x14, w12, sxtw #2]
	add	w13, w13, #4
	add	x13, x14, x13
	cbz	w12, .LBB267_12
.LBB267_10:                             // %B10
                                        //   Parent Loop BB267_9 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w14, w12, #3
	sub	w14, w14, #8
	add	x14, x13, x14
	ldp	w14, w15, [x14]
	cmp	w10, w15
	b.eq	.LBB267_14
// %bb.11:                              // %B17
                                        //   in Loop: Header=BB267_10 Depth=2
	and	w12, w14, #0x3ffffff
	cbnz	w12, .LBB267_10
.LBB267_12:                             // %B24
                                        //   in Loop: Header=BB267_9 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB267_6
// %bb.13:                              // %B21
                                        //   in Loop: Header=BB267_9 Depth=1
	ldr	x9, [x11, #32]
	cbnz	x9, .LBB267_9
	b	.LBB267_16
.LBB267_14:                             // %B12
	lsr	w8, w14, #30
	cbnz	w8, .LBB267_6
// %bb.15:                              // %B13
	ldr	x8, [x9, #16]
	sub	w9, w12, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB267_16:                             // %B14
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB267_17:                             // %B31
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, xzr
	stp	x22, x21, [x8]
	b	.LFastTypedArrayGet_asm_h
.Lfunc_end267:
	.size	.Lget_array_el_2_asm_h, .Lfunc_end267-.Lget_array_el_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_array_el2_2_asm_h
	.type	.Lget_array_el2_2_asm_h,@function
.Lget_array_el2_2_asm_h:                // @get_array_el2_2_asm_h
// %bb.0:                               // %B36
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB268_6
// %bb.1:                               // %B36
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x8, x9
	b.ne	.LBB268_6
// %bb.2:                               // %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	.LBB268_5
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w8, w21
	b.ls	.LBB268_7
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	add	x8, x25, x8, lsl #3
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x8, #3888]
	br	x1
.LBB268_5:                              // %B30
	sub	w8, w8, #21
	cmp	w8, #8
	b.ls	.LBB268_17
.LBB268_6:                              // %B16
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.LSlowGetArrayEl_asm_h
.LBB268_7:                              // %B7
	tbnz	w21, #31, .LBB268_6
// %bb.8:                               // %B9.preheader
	mov	x9, x22
	orr	w10, w21, #0x80000000
	mov	w8, #18                         // =0x12
.LBB268_9:                              // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB268_10 Depth 2
	ldr	x11, [x9, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w12, w10, w12
	ldr	w12, [x14, w12, sxtw #2]
	add	w13, w13, #4
	add	x13, x14, x13
	cbz	w12, .LBB268_12
.LBB268_10:                             // %B10
                                        //   Parent Loop BB268_9 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w14, w12, #3
	sub	w14, w14, #8
	add	x14, x13, x14
	ldp	w14, w15, [x14]
	cmp	w10, w15
	b.eq	.LBB268_14
// %bb.11:                              // %B17
                                        //   in Loop: Header=BB268_10 Depth=2
	and	w12, w14, #0x3ffffff
	cbnz	w12, .LBB268_10
.LBB268_12:                             // %B24
                                        //   in Loop: Header=BB268_9 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB268_6
// %bb.13:                              // %B21
                                        //   in Loop: Header=BB268_9 Depth=1
	ldr	x9, [x11, #32]
	cbnz	x9, .LBB268_9
	b	.LBB268_16
.LBB268_14:                             // %B12
	lsr	w8, w14, #30
	cbnz	w8, .LBB268_6
// %bb.15:                              // %B13
	ldr	x8, [x9, #16]
	sub	w9, w12, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB268_16:                             // %B14
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB268_17:                             // %B31
	mov	x8, x20
	add	x20, x20, #16
	mov	w0, #1                          // =0x1
	stp	x22, x21, [x8]
	b	.LFastTypedArrayGet_asm_h
.Lfunc_end268:
	.size	.Lget_array_el2_2_asm_h, .Lfunc_end268-.Lget_array_el2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_array_el_2_asm_h
	.type	.Lput_array_el_2_asm_h,@function
.Lput_array_el_2_asm_h:                 // @put_array_el_2_asm_h
// %bb.0:                               // %B56
	ldur	x8, [x20, #-8]
	mov	x9, #2                          // =0x2
	mov	x11, x20
	movk	x9, #65535, lsl #48
	tst	x8, x9
	b.ne	.LBB269_7
// %bb.1:                               // %B1
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x22, lsr #48
	b.ne	.LBB269_7
// %bb.2:                               // %B3
	ldrh	w9, [x8, #6]
	cmp	w9, #2
	b.ne	.LBB269_6
// %bb.3:                               // %B48
	ldr	w9, [x8, #48]
	cmp	w9, w22
	b.ls	.LBB269_8
// %bb.4:                               // %B5
	ldr	x8, [x8, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB269_16
.LBB269_5:                              // %B25
	ldrb	w8, [x19], #1
	sub	x20, x11, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB269_6:                              // %B52
	sub	w8, w9, #21
	cmp	w8, #8
	b.ls	.LBB269_20
.LBB269_7:                              // %B40
	add	x20, x11, #16
	stp	x22, x21, [x11]
	mov	x0, xzr
	b	.LSlowPutArrayEl_asm_h
.LBB269_8:                              // %B13
	b.ne	.LBB269_21
// %bb.9:                               // %B41
	ldr	w9, [x8, #4]
	mov	w10, #2304                      // =0x900
	bics	wzr, w10, w9
	b.ne	.LBB269_7
// %bb.10:                              // %B15
	ldr	x9, [x8, #8]
	ldr	x9, [x9, #32]
	cbz	x9, .LBB269_12
// %bb.11:                              // %B37
	ldrb	w9, [x9, #5]
	tbz	w9, #5, .LBB269_7
.LBB269_12:                             // %B33
	ldr	x9, [x8, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w22, #1
	b.ne	.LBB269_14
// %bb.13:                              // %B33
	cmp	w9, w10
	b.hi	.LBB269_19
.LBB269_14:                             // %B30
	ldr	w10, [x8, #32]
	cmp	w9, w10
	b.hi	.LBB269_19
// %bb.15:                              // %B23
	ldr	x10, [x8, #40]
	str	w9, [x8, #48]
	str	x21, [x10, w22, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB269_5
.LBB269_16:                             // %B27
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB269_5
// %bb.17:                              // %B27
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x21, x8
	cmp	x8, x9
	b.lo	.LBB269_5
// %bb.18:                              // %B29
	mov	x0, x21
	mov	x1, x24
	mov	x20, x11
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB269_19:                             // %B20
	add	x20, x11, #16
	stp	x22, x21, [x11]
	mov	w0, #1                          // =0x1
	b	.LSlowPutArrayEl_asm_h
.LBB269_20:                             // %B53
	add	x20, x11, #16
	stp	x22, x21, [x11]
	b	.LFastTypedArraySet_asm_h
.LBB269_21:                             // %B45
	tbnz	w22, #31, .LBB269_7
// %bb.22:                              // %B46
	add	x20, x11, #16
	stp	x22, x21, [x11]
	mov	w0, #2                          // =0x2
	b	.LSlowPutArrayEl_asm_h
.Lfunc_end269:
	.size	.Lput_array_el_2_asm_h, .Lfunc_end269-.Lput_array_el_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_false_2_asm_h
	.type	.Lif_false_2_asm_h,@function
.Lif_false_2_asm_h:                     // @if_false_2_asm_h
// %bb.0:                               // %B25
	sub	x8, x21, #6
	cmp	x8, #2
	b.hs	.LBB270_3
// %bb.1:                               // %B1
	cbz	x8, .LBB270_10
.LBB270_2:                              // %B6
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB270_3:                              // %B7
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB270_5
// %bb.4:                               // %B9
	cbnz	w21, .LBB270_2
	b	.LBB270_10
.LBB270_5:                              // %B13
	and	x8, x21, #0xffffffffffffffef
	cmp	x8, #2
	b.eq	.LBB270_10
// %bb.6:                               // %B16
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB270_2
// %bb.7:                               // %B19
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842624          // =0xfffc000000000000
	add	x8, x21, x8
	cmp	x8, x9
	b.lo	.LBB270_9
// %bb.8:                               // %B24
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	.LSlowToBoolean_asm_h
.LBB270_9:                              // %B21
	fmov	d0, x8
	fcmp	d0, #0.0
	b.mi	.LBB270_2
	b.gt	.LBB270_2
.LBB270_10:                             // %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end270:
	.size	.Lif_false_2_asm_h, .Lfunc_end270-.Lif_false_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_true_2_asm_h
	.type	.Lif_true_2_asm_h,@function
.Lif_true_2_asm_h:                      // @if_true_2_asm_h
// %bb.0:                               // %B25
	sub	x8, x21, #6
	cmp	x8, #2
	b.hs	.LBB271_3
// %bb.1:                               // %B1
	cbz	x8, .LBB271_10
.LBB271_2:                              // %B6
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB271_3:                              // %B7
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB271_5
// %bb.4:                               // %B9
	cbnz	w21, .LBB271_2
	b	.LBB271_10
.LBB271_5:                              // %B13
	and	x8, x21, #0xffffffffffffffef
	cmp	x8, #2
	b.eq	.LBB271_10
// %bb.6:                               // %B16
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB271_2
// %bb.7:                               // %B19
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842624          // =0xfffc000000000000
	add	x8, x21, x8
	cmp	x8, x9
	b.lo	.LBB271_9
// %bb.8:                               // %B24
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	.LSlowToBoolean_asm_h
.LBB271_9:                              // %B21
	fmov	d0, x8
	fcmp	d0, #0.0
	b.mi	.LBB271_2
	b.gt	.LBB271_2
.LBB271_10:                             // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end271:
	.size	.Lif_true_2_asm_h, .Lfunc_end271-.Lif_true_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function goto_2_asm_h
	.type	.Lgoto_2_asm_h,@function
.Lgoto_2_asm_h:                         // @goto_2_asm_h
// %bb.0:                               // %B0
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end272:
	.size	.Lgoto_2_asm_h, .Lfunc_end272-.Lgoto_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function neg_2_asm_h
	.type	.Lneg_2_asm_h,@function
.Lneg_2_asm_h:                          // @neg_2_asm_h
// %bb.0:                               // %B16
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB273_3
// %bb.1:                               // %B10
	orr	w8, w21, #0x80000000
	mov	w9, #-2147483648                // =0x80000000
	cmp	w8, w9
	b.eq	.LBB273_5
// %bb.2:                               // %B12
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	neg	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x1
.LBB273_3:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842625          // =0xfffbffffffffffff
	add	x8, x21, x8
	cmp	x8, x9
	b.hi	.LBB273_5
// %bb.4:                               // %B3
	movi	d0, #0000000000000000
	fmov	d1, x8
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	fsub	d0, d0, d1
	ldr	x1, [x8, #3888]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x8, x9, vs
	br	x1
.LBB273_5:                              // %B13
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #140                        // =0x8c
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB273_7
// %bb.6:                               // %B15
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB273_7:                              // %B14
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end273:
	.size	.Lneg_2_asm_h, .Lfunc_end273-.Lneg_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dec_2_asm_h
	.type	.Ldec_2_asm_h,@function
.Ldec_2_asm_h:                          // @dec_2_asm_h
// %bb.0:                               // %B16
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB274_3
// %bb.1:                               // %B10
	subs	w8, w21, #1
	b.vs	.LBB274_5
// %bb.2:                               // %B12
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB274_3:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842625          // =0xfffbffffffffffff
	add	x8, x21, x8
	cmp	x8, x9
	b.hi	.LBB274_5
// %bb.4:                               // %B3
	fmov	d0, #-1.00000000
	fmov	d1, x8
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	fadd	d0, d1, d0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x8, x9, vs
	br	x1
.LBB274_5:                              // %B13
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #142                        // =0x8e
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB274_7
// %bb.6:                               // %B15
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB274_7:                              // %B14
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end274:
	.size	.Ldec_2_asm_h, .Lfunc_end274-.Ldec_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_2_asm_h
	.type	.Linc_2_asm_h,@function
.Linc_2_asm_h:                          // @inc_2_asm_h
// %bb.0:                               // %B16
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB275_3
// %bb.1:                               // %B10
	adds	w8, w21, #1
	b.vs	.LBB275_5
// %bb.2:                               // %B12
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB275_3:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842625          // =0xfffbffffffffffff
	add	x8, x21, x8
	cmp	x8, x9
	b.hi	.LBB275_5
// %bb.4:                               // %B3
	fmov	d0, #1.00000000
	fmov	d1, x8
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	fadd	d0, d1, d0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x8, x9, vs
	br	x1
.LBB275_5:                              // %B13
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #143                        // =0x8f
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB275_7
// %bb.6:                               // %B15
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB275_7:                              // %B14
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end275:
	.size	.Linc_2_asm_h, .Lfunc_end275-.Linc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function post_dec_2_asm_h
	.type	.Lpost_dec_2_asm_h,@function
.Lpost_dec_2_asm_h:                     // @post_dec_2_asm_h
// %bb.0:                               // %B13
	mov	w9, #65534                      // =0xfffe
	mov	x8, x20
	cmp	x9, x21, lsr #48
	str	x22, [x20], #8
	b.ne	.LBB276_3
// %bb.1:                               // %B10
	subs	w9, w21, #1
	b.vs	.LBB276_5
// %bb.2:                               // %B12
	ldrb	w8, [x19], #1
	mov	x22, x21
	orr	x21, x9, #0xfffe000000000000
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB276_3:                              // %B1
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	add	x9, x21, x9
	cmp	x9, x10
	b.hs	.LBB276_5
// %bb.4:                               // %B3
	fmov	d0, #-1.00000000
	fmov	d1, x9
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	mov	x22, x21
	fadd	d0, d1, d0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x8, x10, x9, vs
	mov	x21, x8
	br	x1
.LBB276_5:                              // %B9
	add	x20, x8, #16
	str	x21, [x8, #8]
	mov	w0, #144                        // =0x90
	b	.LSlowJSPostInc_asm_h
.Lfunc_end276:
	.size	.Lpost_dec_2_asm_h, .Lfunc_end276-.Lpost_dec_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function post_inc_2_asm_h
	.type	.Lpost_inc_2_asm_h,@function
.Lpost_inc_2_asm_h:                     // @post_inc_2_asm_h
// %bb.0:                               // %B13
	mov	w9, #65534                      // =0xfffe
	mov	x8, x20
	cmp	x9, x21, lsr #48
	str	x22, [x20], #8
	b.ne	.LBB277_3
// %bb.1:                               // %B10
	adds	w9, w21, #1
	b.vs	.LBB277_5
// %bb.2:                               // %B12
	ldrb	w8, [x19], #1
	mov	x22, x21
	orr	x21, x9, #0xfffe000000000000
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB277_3:                              // %B1
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	add	x9, x21, x9
	cmp	x9, x10
	b.hs	.LBB277_5
// %bb.4:                               // %B3
	fmov	d0, #1.00000000
	fmov	d1, x9
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	mov	x22, x21
	fadd	d0, d1, d0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x8, x10, x9, vs
	mov	x21, x8
	br	x1
.LBB277_5:                              // %B9
	add	x20, x8, #16
	str	x21, [x8, #8]
	mov	w0, #145                        // =0x91
	b	.LSlowJSPostInc_asm_h
.Lfunc_end277:
	.size	.Lpost_inc_2_asm_h, .Lfunc_end277-.Lpost_inc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dec_loc_2_asm_h
	.type	.Ldec_loc_2_asm_h,@function
.Ldec_loc_2_asm_h:                      // @dec_loc_2_asm_h
// %bb.0:                               // %B16
	ldrb	w8, [x19]
	mov	w9, #65534                      // =0xfffe
	ldr	x1, [x27, x8, lsl #3]
	cmp	x9, x1, lsr #48
	b.ne	.LBB278_3
// %bb.1:                               // %B10
	subs	w9, w1, #1
	b.vs	.LBB278_5
// %bb.2:                               // %B12
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB278_3:                              // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x9, x1, x9
	cmp	x9, x10
	b.hi	.LBB278_5
// %bb.4:                               // %B4
	fmov	d0, #-1.00000000
	fmov	d1, x9
	mov	x10, #562949953421312           // =0x2000000000000
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x10, x9, vs
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB278_5:                              // %B13
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #142                        // =0x8e
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB278_7
// %bb.6:                               // %B15
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB278_7:                              // %B14
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end278:
	.size	.Ldec_loc_2_asm_h, .Lfunc_end278-.Ldec_loc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_loc_2_asm_h
	.type	.Linc_loc_2_asm_h,@function
.Linc_loc_2_asm_h:                      // @inc_loc_2_asm_h
// %bb.0:                               // %B16
	ldrb	w8, [x19]
	mov	w9, #65534                      // =0xfffe
	ldr	x1, [x27, x8, lsl #3]
	cmp	x9, x1, lsr #48
	b.ne	.LBB279_3
// %bb.1:                               // %B10
	adds	w9, w1, #1
	b.vs	.LBB279_5
// %bb.2:                               // %B12
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB279_3:                              // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x9, x1, x9
	cmp	x9, x10
	b.hi	.LBB279_5
// %bb.4:                               // %B4
	fmov	d0, #1.00000000
	fmov	d1, x9
	mov	x10, #562949953421312           // =0x2000000000000
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x10, x9, vs
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB279_5:                              // %B13
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #143                        // =0x8f
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB279_7
// %bb.6:                               // %B15
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB279_7:                              // %B14
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end279:
	.size	.Linc_loc_2_asm_h, .Lfunc_end279-.Linc_loc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_loc_2_asm_h
	.type	.Ladd_loc_2_asm_h,@function
.Ladd_loc_2_asm_h:                      // @add_loc_2_asm_h
// %bb.0:                               // %B30
	ldrb	w8, [x19]
	eor	x10, x21, #0xfffe000000000000
	ldr	x9, [x27, x8, lsl #3]
	eor	x11, x9, #0xfffe000000000000
	orr	x10, x11, x10
	lsr	x10, x10, #48
	cbnz	x10, .LBB280_3
// %bb.1:                               // %B23
	adds	w10, w9, w21
	b.vs	.LBB280_8
// %bb.2:                               // %B29
	orr	x9, x10, #0xfffe000000000000
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB280_3:                              // %B2
	mov	x10, #-562949953421312          // =0xfffe000000000000
	mov	x12, #-844424930131969          // =0xfffcffffffffffff
	add	x11, x9, x10
	add	x10, x21, x10
	cmp	x11, x12
	mov	x12, #-844424930131968          // =0xfffd000000000000
	ccmp	x10, x12, #2, ls
	b.hs	.LBB280_9
// %bb.4:                               // %B4
	mov	x12, #-1125899906842624         // =0xfffc000000000000
	cmp	x11, x12
	b.hs	.LBB280_10
// %bb.5:                               // %B6
	fmov	d0, x11
	cmp	x10, x12
	b.hs	.LBB280_11
.LBB280_6:                              // %B8
	fmov	d1, x10
.LBB280_7:                              // %B13
	fadd	d0, d0, d1
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       // =0x7ffa000000000000
	csel	x9, x10, x9, vs
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB280_8:                              // %B25
	scvtf	d0, w9
	scvtf	d1, w21
	mov	x10, #562949953421312           // =0x2000000000000
	fadd	d0, d0, d1
	fmov	x9, d0
	add	x9, x9, x10
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB280_9:                              // %B22
	mov	x8, x20
	add	x20, x20, #16
	mov	w0, #1                          // =0x1
	stp	x22, x21, [x8]
	b	.LSlowJSAdd_asm_h
.LBB280_10:                             // %B18
	scvtf	d0, w9
	b	.LBB280_6
.LBB280_11:                             // %B13
	scvtf	d1, w21
	b	.LBB280_7
.Lfunc_end280:
	.size	.Ladd_loc_2_asm_h, .Lfunc_end280-.Ladd_loc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function not_2_asm_h
	.type	.Lnot_2_asm_h,@function
.Lnot_2_asm_h:                          // @not_2_asm_h
// %bb.0:                               // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB281_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	mvn	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x1
.LBB281_2:                              // %B4
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	.LSlowJSNot_asm_h
.Lfunc_end281:
	.size	.Lnot_2_asm_h, .Lfunc_end281-.Lnot_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lnot_2_asm_h
	.type	.Llnot_2_asm_h,@function
.Llnot_2_asm_h:                         // @lnot_2_asm_h
// %bb.0:                               // %B20
	sub	x8, x21, #6
	cmp	x8, #2
	b.hs	.LBB282_3
// %bb.1:                               // %B1
	cbz	x8, .LBB282_5
.LBB282_2:                              // %B7
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB282_3:                              // %B8
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB282_6
// %bb.4:                               // %B10
	cbnz	w21, .LBB282_2
.LBB282_5:                              // %B3
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB282_6:                              // %B14
	and	x8, x21, #0xffffffffffffffef
	cmp	x8, #2
	b.eq	.LBB282_5
// %bb.7:                               // %B17
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB282_2
// %bb.8:                               // %B19
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	.LSlowToBoolean_asm_h
.Lfunc_end282:
	.size	.Llnot_2_asm_h, .Lfunc_end282-.Llnot_2_asm_h
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
	b.eq	.LBB283_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB283_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end283:
	.size	.Ltypeof_2_asm_h, .Lfunc_end283-.Ltypeof_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function mul_2_asm_h
	.type	.Lmul_2_asm_h,@function
.Lmul_2_asm_h:                          // @mul_2_asm_h
// %bb.0:                               // %B41
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB284_5
// %bb.1:                               // %B23
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	.LBB284_11
// %bb.2:                               // %B30
	cbnz	w8, .LBB284_4
// %bb.3:                               // %B30
	orr	w9, w22, w21
	tbnz	w9, #31, .LBB284_12
.LBB284_4:                              // %B37
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB284_5:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB284_13
// %bb.6:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB284_13
// %bb.7:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB284_15
// %bb.8:                               // %B5
	fmov	d0, x9
	cmp	x8, x10
	b.hs	.LBB284_16
.LBB284_9:                              // %B7
	fmov	d1, x8
.LBB284_10:                             // %B13
	fmul	d0, d0, d1
	ldrb	w8, [x19], #1
	mov	x10, #562949953421312           // =0x2000000000000
	add	x8, x25, x8, lsl #3
	fmov	x9, d0
	fcmp	d0, d0
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB284_11:                             // %B25
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x9, #562949953421312            // =0x2000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	fmul	d0, d0, d1
	ldr	x1, [x8, #1944]
	fmov	x8, d0
	add	x22, x8, x9
	br	x1
.LBB284_12:                             // %B34
	mov	x22, #-9222809086901354496      // =0x8002000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB284_13:                             // %B38
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        // =0x9a
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB284_17
// %bb.14:                              // %B40
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB284_15:                             // %B18
	scvtf	d0, w22
	b	.LBB284_9
.LBB284_16:                             // %B13
	scvtf	d1, w21
	b	.LBB284_10
.LBB284_17:                             // %B39
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end284:
	.size	.Lmul_2_asm_h, .Lfunc_end284-.Lmul_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function div_2_asm_h
	.type	.Ldiv_2_asm_h,@function
.Ldiv_2_asm_h:                          // @div_2_asm_h
// %bb.0:                               // %B34
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB285_2
// %bb.1:                               // %B23
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w8, [x19], #1
	mov	x12, #9221683186994511872       // =0x7ffa000000000000
	add	x8, x25, x8, lsl #3
	fdiv	d0, d0, d1
	ldr	x1, [x8, #1944]
	fcvtzs	w9, d0
	fmov	x11, d0
	fcmp	d0, d0
	add	x10, x11, x10
	csel	x10, x12, x10, vs
	cmp	x9, x11
	orr	x8, x9, #0xfffe000000000000
	csel	x22, x8, x10, eq
	br	x1
.LBB285_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB285_8
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB285_8
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB285_10
// %bb.5:                               // %B5
	fmov	d0, x9
	cmp	x8, x10
	b.hs	.LBB285_11
.LBB285_6:                              // %B7
	fmov	d1, x8
.LBB285_7:                              // %B13
	fdiv	d0, d0, d1
	ldrb	w8, [x19], #1
	mov	x10, #562949953421312           // =0x2000000000000
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB285_8:                              // %B31
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        // =0x9b
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB285_12
// %bb.9:                               // %B33
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB285_10:                             // %B18
	scvtf	d0, w22
	b	.LBB285_6
.LBB285_11:                             // %B13
	scvtf	d1, w21
	b	.LBB285_7
.LBB285_12:                             // %B32
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end285:
	.size	.Ldiv_2_asm_h, .Lfunc_end285-.Ldiv_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function mod_2_asm_h
	.type	.Lmod_2_asm_h,@function
.Lmod_2_asm_h:                          // @mod_2_asm_h
// %bb.0:                               // %B30
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB286_4
// %bb.1:                               // %B24
	tbnz	w22, #31, .LBB286_10
// %bb.2:                               // %B24
	cmp	w21, #1
	b.lt	.LBB286_10
// %bb.3:                               // %B26
	udiv	w8, w22, w21
	ldrb	w9, [x19], #1
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB286_4:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB286_10
// %bb.5:                               // %B1
	add	x8, x21, x8
	cmp	x8, x10
	b.hi	.LBB286_10
// %bb.6:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB286_13
// %bb.7:                               // %B5
	fmov	d0, x9
	cmp	x8, x10
	b.hs	.LBB286_14
.LBB286_8:                              // %B7
	fmov	d1, x8
.LBB286_9:                              // %B13
	bl	fmod
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	x8, x25, x8, lsl #3
	add	x9, x9, x10
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	csel	x22, x8, x9, vs
	br	x1
.LBB286_10:                             // %B27
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        // =0x9c
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB286_12
// %bb.11:                              // %B29
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB286_12:                             // %B28
	b	.Lexception_spill_top0_top1_asm_h
.LBB286_13:                             // %B18
	scvtf	d0, w22
	b	.LBB286_8
.LBB286_14:                             // %B13
	scvtf	d1, w21
	b	.LBB286_9
.Lfunc_end286:
	.size	.Lmod_2_asm_h, .Lfunc_end286-.Lmod_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_2_asm_h
	.type	.Ladd_2_asm_h,@function
.Ladd_2_asm_h:                          // @add_2_asm_h
// %bb.0:                               // %B30
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB287_3
// %bb.1:                               // %B23
	adds	w8, w22, w21
	b.vs	.LBB287_9
// %bb.2:                               // %B29
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB287_3:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB287_10
// %bb.4:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB287_10
// %bb.5:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB287_11
// %bb.6:                               // %B5
	fmov	d0, x9
	cmp	x8, x10
	b.hs	.LBB287_12
.LBB287_7:                              // %B7
	fmov	d1, x8
.LBB287_8:                              // %B13
	fadd	d0, d0, d1
	ldrb	w8, [x19], #1
	mov	x10, #562949953421312           // =0x2000000000000
	add	x8, x25, x8, lsl #3
	fmov	x9, d0
	fcmp	d0, d0
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB287_9:                              // %B25
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x9, #562949953421312            // =0x2000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	fadd	d0, d0, d1
	ldr	x1, [x8, #1944]
	fmov	x8, d0
	add	x22, x8, x9
	br	x1
.LBB287_10:                             // %B22
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, xzr
	stp	x22, x21, [x8]
	b	.LSlowJSAdd_asm_h
.LBB287_11:                             // %B18
	scvtf	d0, w22
	b	.LBB287_7
.LBB287_12:                             // %B13
	scvtf	d1, w21
	b	.LBB287_8
.Lfunc_end287:
	.size	.Ladd_2_asm_h, .Lfunc_end287-.Ladd_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function sub_2_asm_h
	.type	.Lsub_2_asm_h,@function
.Lsub_2_asm_h:                          // @sub_2_asm_h
// %bb.0:                               // %B33
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB288_3
// %bb.1:                               // %B23
	subs	w8, w22, w21
	b.vs	.LBB288_9
// %bb.2:                               // %B29
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB288_3:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB288_10
// %bb.4:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB288_10
// %bb.5:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB288_12
// %bb.6:                               // %B5
	fmov	d0, x9
	cmp	x8, x10
	b.hs	.LBB288_13
.LBB288_7:                              // %B7
	fmov	d1, x8
.LBB288_8:                              // %B13
	fsub	d0, d0, d1
	ldrb	w8, [x19], #1
	mov	x10, #562949953421312           // =0x2000000000000
	add	x8, x25, x8, lsl #3
	fmov	x9, d0
	fcmp	d0, d0
	ldr	x1, [x8, #1944]
	mov	x8, #9221683186994511872        // =0x7ffa000000000000
	add	x9, x9, x10
	csel	x22, x8, x9, vs
	br	x1
.LBB288_9:                              // %B25
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x9, #562949953421312            // =0x2000000000000
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	fsub	d0, d0, d1
	ldr	x1, [x8, #1944]
	fmov	x8, d0
	add	x22, x8, x9
	br	x1
.LBB288_10:                             // %B30
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        // =0x9e
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB288_14
// %bb.11:                              // %B32
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB288_12:                             // %B18
	scvtf	d0, w22
	b	.LBB288_7
.LBB288_13:                             // %B13
	scvtf	d1, w21
	b	.LBB288_8
.LBB288_14:                             // %B31
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end288:
	.size	.Lsub_2_asm_h, .Lfunc_end288-.Lsub_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function shl_2_asm_h
	.type	.Lshl_2_asm_h,@function
.Lshl_2_asm_h:                          // @shl_2_asm_h
// %bb.0:                               // %B19
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB289_2
// %bb.1:                               // %B20
	mov	w8, w22
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	add	x9, x25, x9, lsl #3
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	br	x1
.LBB289_2:                              // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB289_4
// %bb.3:                               // %B2
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB289_7
.LBB289_4:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        // =0xa0
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB289_6
// %bb.5:                               // %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB289_6:                              // %B17
	b	.Lexception_spill_top0_top1_asm_h
.LBB289_7:                              // %B10
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB289_4
// %bb.8:                               // %B11
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	add	x9, x25, x9, lsl #3
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	br	x1
.Lfunc_end289:
	.size	.Lshl_2_asm_h, .Lfunc_end289-.Lshl_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function sar_2_asm_h
	.type	.Lsar_2_asm_h,@function
.Lsar_2_asm_h:                          // @sar_2_asm_h
// %bb.0:                               // %B19
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB290_2
// %bb.1:                               // %B20
	mov	w8, w22
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	add	x9, x25, x9, lsl #3
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	br	x1
.LBB290_2:                              // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB290_4
// %bb.3:                               // %B2
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB290_7
.LBB290_4:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        // =0xa1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB290_6
// %bb.5:                               // %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB290_6:                              // %B17
	b	.Lexception_spill_top0_top1_asm_h
.LBB290_7:                              // %B10
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB290_4
// %bb.8:                               // %B11
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	add	x9, x25, x9, lsl #3
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	br	x1
.Lfunc_end290:
	.size	.Lsar_2_asm_h, .Lfunc_end290-.Lsar_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function shr_2_asm_h
	.type	.Lshr_2_asm_h,@function
.Lshr_2_asm_h:                          // @shr_2_asm_h
// %bb.0:                               // %B27
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB291_3
// %bb.1:                               // %B28
	mov	w8, w22
.LBB291_2:                              // %B1
	lsr	w8, w8, w21
	ldrb	w9, [x19], #1
	mov	x10, #562949953421312           // =0x2000000000000
	ucvtf	d0, w8
	add	x9, x25, x9, lsl #3
	tst	w8, #0x80000000
	orr	x8, x8, #0xfffe000000000000
	ldr	x1, [x9, #1944]
	fmov	x11, d0
	add	x10, x11, x10
	csel	x22, x10, x8, ne
	br	x1
.LBB291_3:                              // %B10
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB291_5
// %bb.4:                               // %B10
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB291_8
.LBB291_5:                              // %B24
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	.LBB291_7
// %bb.6:                               // %B26
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB291_7:                              // %B25
	b	.Lexception_spill_top0_top1_asm_h
.LBB291_8:                              // %B18
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB291_5
// %bb.9:                               // %B19
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB291_2
.Lfunc_end291:
	.size	.Lshr_2_asm_h, .Lfunc_end291-.Lshr_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lt_2_asm_h
	.type	.Llt_2_asm_h,@function
.Llt_2_asm_h:                           // @lt_2_asm_h
// %bb.0:                               // %B14
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB292_2
// %bb.1:                               // %B15
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, lt
	br	x1
.LBB292_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB292_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB292_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB292_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB292_10
.LBB292_6:                              // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB292_7:                              // %B11
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        // =0xa3
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB292_11
// %bb.8:                               // %B13
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB292_9:                              // %B9
	scvtf	d0, w22
	b	.LBB292_6
.LBB292_10:                             // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB292_11:                             // %B12
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end292:
	.size	.Llt_2_asm_h, .Lfunc_end292-.Llt_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function lte_2_asm_h
	.type	.Llte_2_asm_h,@function
.Llte_2_asm_h:                          // @lte_2_asm_h
// %bb.0:                               // %B14
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB293_2
// %bb.1:                               // %B15
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, le
	br	x1
.LBB293_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB293_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB293_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB293_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB293_10
.LBB293_6:                              // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB293_7:                              // %B11
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        // =0xa4
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB293_11
// %bb.8:                               // %B13
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB293_9:                              // %B9
	scvtf	d0, w22
	b	.LBB293_6
.LBB293_10:                             // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB293_11:                             // %B12
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end293:
	.size	.Llte_2_asm_h, .Lfunc_end293-.Llte_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gt_2_asm_h
	.type	.Lgt_2_asm_h,@function
.Lgt_2_asm_h:                           // @gt_2_asm_h
// %bb.0:                               // %B14
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB294_2
// %bb.1:                               // %B15
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB294_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB294_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB294_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB294_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB294_10
.LBB294_6:                              // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB294_7:                              // %B11
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        // =0xa5
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB294_11
// %bb.8:                               // %B13
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB294_9:                              // %B9
	scvtf	d0, w22
	b	.LBB294_6
.LBB294_10:                             // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB294_11:                             // %B12
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end294:
	.size	.Lgt_2_asm_h, .Lfunc_end294-.Lgt_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gte_2_asm_h
	.type	.Lgte_2_asm_h,@function
.Lgte_2_asm_h:                          // @gte_2_asm_h
// %bb.0:                               // %B14
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB295_2
// %bb.1:                               // %B15
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB295_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB295_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB295_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB295_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB295_10
.LBB295_6:                              // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB295_7:                              // %B11
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        // =0xa6
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB295_11
// %bb.8:                               // %B13
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB295_9:                              // %B9
	scvtf	d0, w22
	b	.LBB295_6
.LBB295_10:                             // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB295_11:                             // %B12
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end295:
	.size	.Lgte_2_asm_h, .Lfunc_end295-.Lgte_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function eq_2_asm_h
	.type	.Leq_2_asm_h,@function
.Leq_2_asm_h:                           // @eq_2_asm_h
// %bb.0:                               // %B34
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB296_2
// %bb.1:                               // %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB296_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB296_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB296_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB296_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB296_10
.LBB296_6:                              // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB296_7:                              // %B11
	cmp	x22, x21
	b.ne	.LBB296_11
.LBB296_8:                              // %B12
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB296_9:                              // %B9
	scvtf	d0, w22
	b	.LBB296_6
.LBB296_10:                             // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB296_11:                             // %B14
	and	x8, x21, #0xffffffffffffffef
	cmp	x8, #2
	and	x8, x22, #0xffffffffffffffef
	b.ne	.LBB296_13
// %bb.12:                              // %B16
	cmp	x8, #2
	b.ne	.LBB296_16
	b	.LBB296_8
.LBB296_13:                             // %B21
	cmp	x8, #2
	b.eq	.LBB296_16
// %bb.14:                              // %B24
	and	x8, x21, #0xfffffffffffffffe
	cmp	x8, #6
	b.ne	.LBB296_17
// %bb.15:                              // %B24
	and	x8, x22, #0xfffffffffffffffe
	cmp	x8, #6
	b.ne	.LBB296_17
.LBB296_16:                             // %B19
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB296_17:                             // %B31
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB296_19
// %bb.18:                              // %B33
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB296_19:                             // %B32
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end296:
	.size	.Leq_2_asm_h, .Lfunc_end296-.Leq_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function neq_2_asm_h
	.type	.Lneq_2_asm_h,@function
.Lneq_2_asm_h:                          // @neq_2_asm_h
// %bb.0:                               // %B34
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB297_2
// %bb.1:                               // %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB297_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB297_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB297_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB297_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB297_10
.LBB297_6:                              // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB297_7:                              // %B11
	cmp	x22, x21
	b.ne	.LBB297_11
.LBB297_8:                              // %B12
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB297_9:                              // %B9
	scvtf	d0, w22
	b	.LBB297_6
.LBB297_10:                             // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB297_11:                             // %B14
	and	x8, x21, #0xffffffffffffffef
	cmp	x8, #2
	and	x8, x22, #0xffffffffffffffef
	b.ne	.LBB297_13
// %bb.12:                              // %B16
	cmp	x8, #2
	b.ne	.LBB297_16
	b	.LBB297_8
.LBB297_13:                             // %B21
	cmp	x8, #2
	b.eq	.LBB297_16
// %bb.14:                              // %B24
	and	x8, x21, #0xfffffffffffffffe
	cmp	x8, #6
	b.ne	.LBB297_17
// %bb.15:                              // %B24
	and	x8, x22, #0xfffffffffffffffe
	cmp	x8, #6
	b.ne	.LBB297_17
.LBB297_16:                             // %B19
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB297_17:                             // %B31
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB297_19
// %bb.18:                              // %B33
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB297_19:                             // %B32
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end297:
	.size	.Lneq_2_asm_h, .Lfunc_end297-.Lneq_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function strict_eq_2_asm_h
	.type	.Lstrict_eq_2_asm_h,@function
.Lstrict_eq_2_asm_h:                    // @strict_eq_2_asm_h
// %bb.0:                               // %B29
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB298_2
// %bb.1:                               // %B30
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB298_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB298_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB298_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB298_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB298_10
.LBB298_6:                              // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB298_7:                              // %B11
	cmp	x22, x21
	b.ne	.LBB298_11
// %bb.8:                               // %B12
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB298_9:                              // %B9
	scvtf	d0, w22
	b	.LBB298_6
.LBB298_10:                             // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB298_11:                             // %B14
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x9, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w10, eq
	cmp	x9, x11
	ccmp	x9, x12, #4, ne
	cset	w11, eq
	cmp	w10, #1
	b.ne	.LBB298_13
// %bb.12:                              // %B14
	cbnz	w11, .LBB298_18
.LBB298_13:                             // %B17
	mov	x12, #2                         // =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w13, ne
	cmp	x9, x12
	bic	w12, w13, w10
	csinc	w10, w11, wzr, ne
	tbnz	w12, #0, .LBB298_15
// %bb.14:                              // %B17
	tbnz	w10, #0, .LBB298_19
.LBB298_15:                             // %B20
	mov	x10, #-281474976710656          // =0xffff000000000000
	cmp	x8, x10
	b.ne	.LBB298_17
// %bb.16:                              // %B20
	cmp	x9, x10
	b.eq	.LBB298_21
.LBB298_17:                             // %B25
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB298_18:                             // %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, xzr
	stp	x22, x21, [x8]
	b	.LFastStringEqual_asm_h
.LBB298_19:                             // %B26
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB298_23
// %bb.20:                              // %B28
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB298_21:                             // %B22
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB298_24
// %bb.22:                              // %B24
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB298_23:                             // %B27
	b	.Lexception_spill_top0_top1_asm_h
.LBB298_24:                             // %B23
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end298:
	.size	.Lstrict_eq_2_asm_h, .Lfunc_end298-.Lstrict_eq_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function strict_neq_2_asm_h
	.type	.Lstrict_neq_2_asm_h,@function
.Lstrict_neq_2_asm_h:                   // @strict_neq_2_asm_h
// %bb.0:                               // %B29
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB299_2
// %bb.1:                               // %B30
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB299_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-844424930131969          // =0xfffcffffffffffff
	add	x9, x22, x8
	cmp	x9, x10
	b.hi	.LBB299_7
// %bb.3:                               // %B1
	add	x8, x21, x8
	mov	x10, #-844424930131968          // =0xfffd000000000000
	cmp	x8, x10
	b.hs	.LBB299_7
// %bb.4:                               // %B3
	mov	x10, #-1125899906842624         // =0xfffc000000000000
	cmp	x9, x10
	b.hs	.LBB299_9
// %bb.5:                               // %B5
	fmov	d0, x9
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	cmp	x8, x10
	b.hi	.LBB299_10
.LBB299_6:                              // %B6
	ldrb	w9, [x19], #1
	fmov	d1, x8
	add	x8, x25, x9, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB299_7:                              // %B11
	cmp	x22, x21
	b.ne	.LBB299_11
// %bb.8:                               // %B12
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB299_9:                              // %B9
	scvtf	d0, w22
	b	.LBB299_6
.LBB299_10:                             // %B8
	ldrb	w8, [x19], #1
	scvtf	d1, w21
	add	x8, x25, x8, lsl #3
	fcmp	d0, d1
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB299_11:                             // %B14
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x9, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w10, eq
	cmp	x9, x11
	ccmp	x9, x12, #4, ne
	cset	w11, eq
	cmp	w10, #1
	b.ne	.LBB299_13
// %bb.12:                              // %B14
	cbnz	w11, .LBB299_18
.LBB299_13:                             // %B17
	mov	x12, #2                         // =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w13, ne
	cmp	x9, x12
	bic	w12, w13, w10
	csinc	w10, w11, wzr, ne
	tbnz	w12, #0, .LBB299_15
// %bb.14:                              // %B17
	tbnz	w10, #0, .LBB299_19
.LBB299_15:                             // %B20
	mov	x10, #-281474976710656          // =0xffff000000000000
	cmp	x8, x10
	b.ne	.LBB299_17
// %bb.16:                              // %B20
	cmp	x9, x10
	b.eq	.LBB299_21
.LBB299_17:                             // %B25
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB299_18:                             // %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	w0, #1                          // =0x1
	stp	x22, x21, [x8]
	b	.LFastStringEqual_asm_h
.LBB299_19:                             // %B26
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB299_23
// %bb.20:                              // %B28
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB299_21:                             // %B22
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB299_24
// %bb.22:                              // %B24
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB299_23:                             // %B27
	b	.Lexception_spill_top0_top1_asm_h
.LBB299_24:                             // %B23
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end299:
	.size	.Lstrict_neq_2_asm_h, .Lfunc_end299-.Lstrict_neq_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function and_2_asm_h
	.type	.Land_2_asm_h,@function
.Land_2_asm_h:                          // @and_2_asm_h
// %bb.0:                               // %B19
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB300_2
// %bb.1:                               // %B20
	mov	w8, w22
	ldrb	w9, [x19], #1
	and	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB300_2:                              // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB300_4
// %bb.3:                               // %B2
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB300_7
.LBB300_4:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        // =0xad
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB300_6
// %bb.5:                               // %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB300_6:                              // %B17
	b	.Lexception_spill_top0_top1_asm_h
.LBB300_7:                              // %B10
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB300_4
// %bb.8:                               // %B11
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	and	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.Lfunc_end300:
	.size	.Land_2_asm_h, .Lfunc_end300-.Land_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function xor_2_asm_h
	.type	.Lxor_2_asm_h,@function
.Lxor_2_asm_h:                          // @xor_2_asm_h
// %bb.0:                               // %B19
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB301_2
// %bb.1:                               // %B20
	mov	w8, w22
	ldrb	w9, [x19], #1
	eor	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB301_2:                              // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB301_4
// %bb.3:                               // %B2
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB301_7
.LBB301_4:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        // =0xae
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB301_6
// %bb.5:                               // %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB301_6:                              // %B17
	b	.Lexception_spill_top0_top1_asm_h
.LBB301_7:                              // %B10
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB301_4
// %bb.8:                               // %B11
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	eor	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.Lfunc_end301:
	.size	.Lxor_2_asm_h, .Lfunc_end301-.Lxor_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function or_2_asm_h
	.type	.Lor_2_asm_h,@function
.Lor_2_asm_h:                           // @or_2_asm_h
// %bb.0:                               // %B19
	eor	x8, x22, #0xfffe000000000000
	eor	x9, x21, #0xfffe000000000000
	orr	x8, x8, x9
	lsr	x8, x8, #48
	cbnz	x8, .LBB302_2
// %bb.1:                               // %B20
	mov	w8, w22
	ldrb	w9, [x19], #1
	orr	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB302_2:                              // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1125899906842625         // =0xfffbffffffffffff
	add	x8, x22, x9
	cmp	x8, x10
	b.hi	.LBB302_4
// %bb.3:                               // %B2
	and	x10, x21, #0xffff000000000000
	cmp	x10, x9
	b.eq	.LBB302_7
.LBB302_4:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        // =0xaf
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB302_6
// %bb.5:                               // %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB302_6:                              // %B17
	b	.Lexception_spill_top0_top1_asm_h
.LBB302_7:                              // %B10
	ubfx	x9, x22, #53, #10
	cmp	x9, #526
	b.hi	.LBB302_4
// %bb.8:                               // %B11
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	orr	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.Lfunc_end302:
	.size	.Lor_2_asm_h, .Lfunc_end302-.Lor_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_minus1_2_asm_h
	.type	.Lpush_minus1_2_asm_h,@function
.Lpush_minus1_2_asm_h:                  // @push_minus1_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562945658454017          // =0xfffe0000ffffffff
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end303:
	.size	.Lpush_minus1_2_asm_h, .Lfunc_end303-.Lpush_minus1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_0_2_asm_h
	.type	.Lpush_0_2_asm_h,@function
.Lpush_0_2_asm_h:                       // @push_0_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421312          // =0xfffe000000000000
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end304:
	.size	.Lpush_0_2_asm_h, .Lfunc_end304-.Lpush_0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_1_2_asm_h
	.type	.Lpush_1_2_asm_h,@function
.Lpush_1_2_asm_h:                       // @push_1_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421311          // =0xfffe000000000001
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end305:
	.size	.Lpush_1_2_asm_h, .Lfunc_end305-.Lpush_1_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end306:
	.size	.Lpush_2_2_asm_h, .Lfunc_end306-.Lpush_2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_3_2_asm_h
	.type	.Lpush_3_2_asm_h,@function
.Lpush_3_2_asm_h:                       // @push_3_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421309          // =0xfffe000000000003
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end307:
	.size	.Lpush_3_2_asm_h, .Lfunc_end307-.Lpush_3_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end308:
	.size	.Lpush_4_2_asm_h, .Lfunc_end308-.Lpush_4_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end309:
	.size	.Lpush_5_2_asm_h, .Lfunc_end309-.Lpush_5_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end310:
	.size	.Lpush_6_2_asm_h, .Lfunc_end310-.Lpush_6_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_7_2_asm_h
	.type	.Lpush_7_2_asm_h,@function
.Lpush_7_2_asm_h:                       // @push_7_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421305          // =0xfffe000000000007
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end311:
	.size	.Lpush_7_2_asm_h, .Lfunc_end311-.Lpush_7_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i8_2_asm_h
	.type	.Lpush_i8_2_asm_h,@function
.Lpush_i8_2_asm_h:                      // @push_i8_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #1]
	ldrsb	w9, [x19]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	orr	x21, x9, #0xfffe000000000000
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end312:
	.size	.Lpush_i8_2_asm_h, .Lfunc_end312-.Lpush_i8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_i16_2_asm_h
	.type	.Lpush_i16_2_asm_h,@function
.Lpush_i16_2_asm_h:                     // @push_i16_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #2]
	ldrsh	w9, [x19]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	orr	x21, x9, #0xfffe000000000000
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end313:
	.size	.Lpush_i16_2_asm_h, .Lfunc_end313-.Lpush_i16_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x9, [x9, x10, lsl #3]
	ldr	x1, [x8, #3888]
	mov	x21, x9
	br	x1
.Lfunc_end314:
	.size	.Lpush_const8_2_asm_h, .Lfunc_end314-.Lpush_const8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function fclosure8_2_asm_h
	.type	.Lfclosure8_2_asm_h,@function
.Lfclosure8_2_asm_h:                    // @fclosure8_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lfclosure8_0_asm_h
.Lfunc_end315:
	.size	.Lfclosure8_2_asm_h, .Lfunc_end315-.Lfclosure8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc8_2_asm_h
	.type	.Lget_loc8_2_asm_h,@function
.Lget_loc8_2_asm_h:                     // @get_loc8_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #1]
	ldrb	w9, [x19], #2
	add	x8, x25, x8, lsl #3
	ldr	x9, [x27, x9, lsl #3]
	ldr	x1, [x8, #3888]
	mov	x21, x9
	br	x1
.Lfunc_end316:
	.size	.Lget_loc8_2_asm_h, .Lfunc_end316-.Lget_loc8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc8_2_asm_h
	.type	.Lput_loc8_2_asm_h,@function
.Lput_loc8_2_asm_h:                     // @put_loc8_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end317:
	.size	.Lput_loc8_2_asm_h, .Lfunc_end317-.Lput_loc8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc8_2_asm_h
	.type	.Lset_loc8_2_asm_h,@function
.Lset_loc8_2_asm_h:                     // @set_loc8_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end318:
	.size	.Lset_loc8_2_asm_h, .Lfunc_end318-.Lset_loc8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc0_2_asm_h
	.type	.Lget_loc0_2_asm_h,@function
.Lget_loc0_2_asm_h:                     // @get_loc0_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x27]
	add	x8, x25, x8, lsl #3
	mov	x21, x9
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end319:
	.size	.Lget_loc0_2_asm_h, .Lfunc_end319-.Lget_loc0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc1_2_asm_h
	.type	.Lget_loc1_2_asm_h,@function
.Lget_loc1_2_asm_h:                     // @get_loc1_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x27, #8]
	add	x8, x25, x8, lsl #3
	mov	x21, x9
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end320:
	.size	.Lget_loc1_2_asm_h, .Lfunc_end320-.Lget_loc1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc2_2_asm_h
	.type	.Lget_loc2_2_asm_h,@function
.Lget_loc2_2_asm_h:                     // @get_loc2_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x27, #16]
	add	x8, x25, x8, lsl #3
	mov	x21, x9
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end321:
	.size	.Lget_loc2_2_asm_h, .Lfunc_end321-.Lget_loc2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc3_2_asm_h
	.type	.Lget_loc3_2_asm_h,@function
.Lget_loc3_2_asm_h:                     // @get_loc3_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x27, #24]
	add	x8, x25, x8, lsl #3
	mov	x21, x9
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end322:
	.size	.Lget_loc3_2_asm_h, .Lfunc_end322-.Lget_loc3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc0_2_asm_h
	.type	.Lput_loc0_2_asm_h,@function
.Lput_loc0_2_asm_h:                     // @put_loc0_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end323:
	.size	.Lput_loc0_2_asm_h, .Lfunc_end323-.Lput_loc0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc1_2_asm_h
	.type	.Lput_loc1_2_asm_h,@function
.Lput_loc1_2_asm_h:                     // @put_loc1_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end324:
	.size	.Lput_loc1_2_asm_h, .Lfunc_end324-.Lput_loc1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc2_2_asm_h
	.type	.Lput_loc2_2_asm_h,@function
.Lput_loc2_2_asm_h:                     // @put_loc2_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #16]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end325:
	.size	.Lput_loc2_2_asm_h, .Lfunc_end325-.Lput_loc2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc3_2_asm_h
	.type	.Lput_loc3_2_asm_h,@function
.Lput_loc3_2_asm_h:                     // @put_loc3_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #24]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end326:
	.size	.Lput_loc3_2_asm_h, .Lfunc_end326-.Lput_loc3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc0_2_asm_h
	.type	.Lset_loc0_2_asm_h,@function
.Lset_loc0_2_asm_h:                     // @set_loc0_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end327:
	.size	.Lset_loc0_2_asm_h, .Lfunc_end327-.Lset_loc0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc1_2_asm_h
	.type	.Lset_loc1_2_asm_h,@function
.Lset_loc1_2_asm_h:                     // @set_loc1_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end328:
	.size	.Lset_loc1_2_asm_h, .Lfunc_end328-.Lset_loc1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc2_2_asm_h
	.type	.Lset_loc2_2_asm_h,@function
.Lset_loc2_2_asm_h:                     // @set_loc2_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #16]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end329:
	.size	.Lset_loc2_2_asm_h, .Lfunc_end329-.Lset_loc2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc3_2_asm_h
	.type	.Lset_loc3_2_asm_h,@function
.Lset_loc3_2_asm_h:                     // @set_loc3_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #24]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end330:
	.size	.Lset_loc3_2_asm_h, .Lfunc_end330-.Lset_loc3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg0_2_asm_h
	.type	.Lget_arg0_2_asm_h,@function
.Lget_arg0_2_asm_h:                     // @get_arg0_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x28]
	add	x8, x25, x8, lsl #3
	mov	x21, x9
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end331:
	.size	.Lget_arg0_2_asm_h, .Lfunc_end331-.Lget_arg0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg1_2_asm_h
	.type	.Lget_arg1_2_asm_h,@function
.Lget_arg1_2_asm_h:                     // @get_arg1_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x28, #8]
	add	x8, x25, x8, lsl #3
	mov	x21, x9
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end332:
	.size	.Lget_arg1_2_asm_h, .Lfunc_end332-.Lget_arg1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg2_2_asm_h
	.type	.Lget_arg2_2_asm_h,@function
.Lget_arg2_2_asm_h:                     // @get_arg2_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x28, #16]
	add	x8, x25, x8, lsl #3
	mov	x21, x9
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end333:
	.size	.Lget_arg2_2_asm_h, .Lfunc_end333-.Lget_arg2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg3_2_asm_h
	.type	.Lget_arg3_2_asm_h,@function
.Lget_arg3_2_asm_h:                     // @get_arg3_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x28, #24]
	add	x8, x25, x8, lsl #3
	mov	x21, x9
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end334:
	.size	.Lget_arg3_2_asm_h, .Lfunc_end334-.Lget_arg3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg0_2_asm_h
	.type	.Lput_arg0_2_asm_h,@function
.Lput_arg0_2_asm_h:                     // @put_arg0_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end335:
	.size	.Lput_arg0_2_asm_h, .Lfunc_end335-.Lput_arg0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg1_2_asm_h
	.type	.Lput_arg1_2_asm_h,@function
.Lput_arg1_2_asm_h:                     // @put_arg1_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end336:
	.size	.Lput_arg1_2_asm_h, .Lfunc_end336-.Lput_arg1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg2_2_asm_h
	.type	.Lput_arg2_2_asm_h,@function
.Lput_arg2_2_asm_h:                     // @put_arg2_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #16]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end337:
	.size	.Lput_arg2_2_asm_h, .Lfunc_end337-.Lput_arg2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg3_2_asm_h
	.type	.Lput_arg3_2_asm_h,@function
.Lput_arg3_2_asm_h:                     // @put_arg3_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #24]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end338:
	.size	.Lput_arg3_2_asm_h, .Lfunc_end338-.Lput_arg3_2_asm_h
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
	add	x9, x25, x9, lsl #3
	ldr	x8, [x8]
	ldr	x1, [x9, #3888]
	mov	x21, x8
	br	x1
.Lfunc_end339:
	.size	.Lget_var_ref0_2_asm_h, .Lfunc_end339-.Lget_var_ref0_2_asm_h
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
	add	x9, x25, x9, lsl #3
	ldr	x8, [x8]
	ldr	x1, [x9, #3888]
	mov	x21, x8
	br	x1
.Lfunc_end340:
	.size	.Lget_var_ref1_2_asm_h, .Lfunc_end340-.Lget_var_ref1_2_asm_h
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
	add	x9, x25, x9, lsl #3
	ldr	x8, [x8]
	ldr	x1, [x9, #3888]
	mov	x21, x8
	br	x1
.Lfunc_end341:
	.size	.Lget_var_ref2_2_asm_h, .Lfunc_end341-.Lget_var_ref2_2_asm_h
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
	add	x9, x25, x9, lsl #3
	ldr	x8, [x8]
	ldr	x1, [x9, #3888]
	mov	x21, x8
	br	x1
.Lfunc_end342:
	.size	.Lget_var_ref3_2_asm_h, .Lfunc_end342-.Lget_var_ref3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref0_2_asm_h
	.type	.Lput_var_ref0_2_asm_h,@function
.Lput_var_ref0_2_asm_h:                 // @put_var_ref0_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end343:
	.size	.Lput_var_ref0_2_asm_h, .Lfunc_end343-.Lput_var_ref0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref1_2_asm_h
	.type	.Lput_var_ref1_2_asm_h,@function
.Lput_var_ref1_2_asm_h:                 // @put_var_ref1_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end344:
	.size	.Lput_var_ref1_2_asm_h, .Lfunc_end344-.Lput_var_ref1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref2_2_asm_h
	.type	.Lput_var_ref2_2_asm_h,@function
.Lput_var_ref2_2_asm_h:                 // @put_var_ref2_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end345:
	.size	.Lput_var_ref2_2_asm_h, .Lfunc_end345-.Lput_var_ref2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref3_2_asm_h
	.type	.Lput_var_ref3_2_asm_h,@function
.Lput_var_ref3_2_asm_h:                 // @put_var_ref3_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end346:
	.size	.Lput_var_ref3_2_asm_h, .Lfunc_end346-.Lput_var_ref3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_length_2_asm_h
	.type	.Lget_length_2_asm_h,@function
.Lget_length_2_asm_h:                   // @get_length_2_asm_h
// %bb.0:                               // %B27
	mov	x9, #2                          // =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	.LBB347_2
// %bb.1:                               // %B27
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB347_3
.LBB347_2:                              // %B28
	ldrb	w8, [x19], #1
	and	x9, x21, #0xfffffffffffc
	ldr	w9, [x9, #4]
	mov	x10, #-562949953421312          // =0xfffe000000000000
	add	x8, x25, x8, lsl #3
	bfxil	x10, x9, #0, #30
	ldr	x1, [x8, #3888]
	mov	x21, x10
	br	x1
.LBB347_3:                              // %B21
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	.LBB347_13
// %bb.4:                               // %B22
	mov	x9, x21
	mov	w8, #18                         // =0x12
.LBB347_5:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB347_6 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	x11, x11, #0x30
	ldr	w11, [x13, x11, lsl #2]
	add	w12, w12, #4
	add	x12, x13, x12
	cbz	w11, .LBB347_8
.LBB347_6:                              // %B1
                                        //   Parent Loop BB347_5 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	ldr	x13, [x12, w13, uxtw]
	lsr	x14, x13, #32
	cmp	x14, #48
	b.eq	.LBB347_10
// %bb.7:                               // %B9
                                        //   in Loop: Header=BB347_6 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB347_6
.LBB347_8:                              // %B14
                                        //   in Loop: Header=BB347_5 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB347_13
// %bb.9:                               // %B17
                                        //   in Loop: Header=BB347_5 Depth=1
	ldr	x9, [x10, #32]
	cbnz	x9, .LBB347_5
	b	.LBB347_12
.LBB347_10:                             // %B3
	lsr	w8, w13, #30
	cbnz	w8, .LBB347_13
// %bb.11:                              // %B4
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB347_12:                             // %B6
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB347_13:                             // %B24
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
	b.eq	.LBB347_15
// %bb.14:                              // %B26
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB347_15:                             // %B25
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end347:
	.size	.Lget_length_2_asm_h, .Lfunc_end347-.Lget_length_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_false8_2_asm_h
	.type	.Lif_false8_2_asm_h,@function
.Lif_false8_2_asm_h:                    // @if_false8_2_asm_h
// %bb.0:                               // %B25
	sub	x8, x21, #6
	cmp	x8, #2
	b.hs	.LBB348_3
// %bb.1:                               // %B1
	cbz	x8, .LBB348_10
.LBB348_2:                              // %B6
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB348_3:                              // %B7
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB348_5
// %bb.4:                               // %B9
	cbnz	w21, .LBB348_2
	b	.LBB348_10
.LBB348_5:                              // %B13
	and	x8, x21, #0xffffffffffffffef
	cmp	x8, #2
	b.eq	.LBB348_10
// %bb.6:                               // %B16
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB348_2
// %bb.7:                               // %B19
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842624          // =0xfffc000000000000
	add	x8, x21, x8
	cmp	x8, x9
	b.lo	.LBB348_9
// %bb.8:                               // %B24
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	.LSlowToBoolean_asm_h
.LBB348_9:                              // %B21
	fmov	d0, x8
	fcmp	d0, #0.0
	b.mi	.LBB348_2
	b.gt	.LBB348_2
.LBB348_10:                             // %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end348:
	.size	.Lif_false8_2_asm_h, .Lfunc_end348-.Lif_false8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function if_true8_2_asm_h
	.type	.Lif_true8_2_asm_h,@function
.Lif_true8_2_asm_h:                     // @if_true8_2_asm_h
// %bb.0:                               // %B25
	sub	x8, x21, #6
	cmp	x8, #2
	b.hs	.LBB349_3
// %bb.1:                               // %B1
	cbz	x8, .LBB349_10
.LBB349_2:                              // %B6
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB349_3:                              // %B7
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB349_5
// %bb.4:                               // %B9
	cbnz	w21, .LBB349_2
	b	.LBB349_10
.LBB349_5:                              // %B13
	and	x8, x21, #0xffffffffffffffef
	cmp	x8, #2
	b.eq	.LBB349_10
// %bb.6:                               // %B16
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB349_2
// %bb.7:                               // %B19
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842624          // =0xfffc000000000000
	add	x8, x21, x8
	cmp	x8, x9
	b.lo	.LBB349_9
// %bb.8:                               // %B24
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	.LSlowToBoolean_asm_h
.LBB349_9:                              // %B21
	fmov	d0, x8
	fcmp	d0, #0.0
	b.mi	.LBB349_2
	b.gt	.LBB349_2
.LBB349_10:                             // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end349:
	.size	.Lif_true8_2_asm_h, .Lfunc_end349-.Lif_true8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function goto8_2_asm_h
	.type	.Lgoto8_2_asm_h,@function
.Lgoto8_2_asm_h:                        // @goto8_2_asm_h
// %bb.0:                               // %B0
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end350:
	.size	.Lgoto8_2_asm_h, .Lfunc_end350-.Lgoto8_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function goto16_2_asm_h
	.type	.Lgoto16_2_asm_h,@function
.Lgoto16_2_asm_h:                       // @goto16_2_asm_h
// %bb.0:                               // %B0
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end351:
	.size	.Lgoto16_2_asm_h, .Lfunc_end351-.Lgoto16_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call0_2_asm_h
	.type	.Lcall0_2_asm_h,@function
.Lcall0_2_asm_h:                        // @call0_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcall0_0_asm_h
.Lfunc_end352:
	.size	.Lcall0_2_asm_h, .Lfunc_end352-.Lcall0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call1_2_asm_h
	.type	.Lcall1_2_asm_h,@function
.Lcall1_2_asm_h:                        // @call1_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcall1_0_asm_h
.Lfunc_end353:
	.size	.Lcall1_2_asm_h, .Lfunc_end353-.Lcall1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call2_2_asm_h
	.type	.Lcall2_2_asm_h,@function
.Lcall2_2_asm_h:                        // @call2_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcall2_0_asm_h
.Lfunc_end354:
	.size	.Lcall2_2_asm_h, .Lfunc_end354-.Lcall2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function call3_2_asm_h
	.type	.Lcall3_2_asm_h,@function
.Lcall3_2_asm_h:                        // @call3_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcall3_0_asm_h
.Lfunc_end355:
	.size	.Lcall3_2_asm_h, .Lfunc_end355-.Lcall3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_undefined_2_asm_h
	.type	.Lis_undefined_2_asm_h,@function
.Lis_undefined_2_asm_h:                 // @is_undefined_2_asm_h
// %bb.0:                               // %B2
	cmp	x21, #18
	b.ne	.LBB356_2
// %bb.1:                               // %B3
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB356_2:                              // %B5
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end356:
	.size	.Lis_undefined_2_asm_h, .Lfunc_end356-.Lis_undefined_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_null_2_asm_h
	.type	.Lis_null_2_asm_h,@function
.Lis_null_2_asm_h:                      // @is_null_2_asm_h
// %bb.0:                               // %B2
	cmp	x21, #2
	b.ne	.LBB357_2
// %bb.1:                               // %B3
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB357_2:                              // %B5
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end357:
	.size	.Lis_null_2_asm_h, .Lfunc_end357-.Lis_null_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function is_function_2_asm_h
	.type	.Lis_function_2_asm_h,@function
.Lis_function_2_asm_h:                  // @is_function_2_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x21
	bl	js_operator_typeof_gc
	cmp	w0, #27
	b.ne	.LBB358_2
// %bb.1:                               // %B2
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB358_2:                              // %B5
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end358:
	.size	.Lis_function_2_asm_h, .Lfunc_end358-.Lis_function_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function FastJSConcatString_asm_h
	.type	.LFastJSConcatString_asm_h,@function
.LFastJSConcatString_asm_h:             // @FastJSConcatString_asm_h
// %bb.0:                               // %B43
	sub	sp, sp, #48
	mov	x12, x20
	mov	x22, x0
	str	x19, [sp, #32]                  // 8-byte Folded Spill
	cbnz	x22, .LBB359_15
// %bb.1:                               // %B46
	sub	x8, x12, #16
.LBB359_2:                              // %B14
	sub	x9, x12, #8
	ldr	x1, [x8]
	str	x12, [sp, #40]                  // 8-byte Folded Spill
	ldr	x2, [x9]
	and	x9, x1, #0xfffffffffffc
	and	x8, x2, #0xfffffffffffc
	ldr	w13, [x9, #4]
	ldr	w14, [x8, #4]
	and	w10, w13, #0x3fffffff
	and	w11, w14, #0x3fffffff
	add	w11, w10, w11
	lsr	w10, w11, #30
	cbnz	w10, .LBB359_12
// %bb.3:                               // %B18
	mov	x10, #-281474976710653          // =0xffff000000000003
	bics	xzr, x10, x1
	b.eq	.LBB359_16
// %bb.4:
	mov	w15, #1                         // =0x1
	bics	xzr, x10, x2
	str	x1, [sp, #24]                   // 8-byte Folded Spill
	stp	w13, w11, [sp, #16]             // 8-byte Folded Spill
	str	w14, [sp, #12]                  // 4-byte Folded Spill
	b.eq	.LBB359_17
.LBB359_5:
	str	w15, [sp, #8]                   // 4-byte Folded Spill
	mov	x19, x2
.LBB359_6:                              // %B34
	mov	x0, x24
	mov	w1, #32                         // =0x20
	mov	w2, #20                         // =0x14
	str	x12, [x23, #48]
	bl	prim_try_malloc_gc
	ldp	w8, w10, [sp, #16]              // 8-byte Folded Reload
	ldr	x12, [sp, #40]                  // 8-byte Folded Reload
	ldr	x1, [sp, #24]                   // 8-byte Folded Reload
	mov	x20, x0
	ldr	w9, [sp, #12]                   // 4-byte Folded Reload
	mov	x2, x19
	cbz	x20, .LBB359_12
// %bb.7:                               // %B20
	orr	w8, w8, w9
	ldr	w11, [sp, #8]                   // 4-byte Folded Reload
	mov	w9, #1                          // =0x1
	and	w8, w8, #0x80000000
	str	w9, [x20]
	orr	w8, w10, w8
	str	x1, [x20, #16]
	stp	w8, w11, [x20, #4]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB359_18
.LBB359_8:                              // %B24
	str	x2, [x20, #24]
	ldr	x19, [sp, #32]                  // 8-byte Folded Reload
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB359_21
.LBB359_9:                              // %B1
	orr	x8, x20, #0xffff000000000003
	cbz	x22, .LBB359_11
// %bb.10:                              // %B2
	ldrb	w9, [x19]
	sub	x20, x12, #8
	str	x8, [x27, x9, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
.LBB359_11:                             // %B4
	stur	x8, [x12, #-16]
	sub	x20, x12, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
.LBB359_12:                             // %B5
	mov	x0, x24
	str	x12, [x23, #48]
	bl	JS_ConcatString_GC
	cmp	x0, #130
	cbnz	x22, .LBB359_24
// %bb.13:                              // %B11
	ldr	x19, [sp, #32]                  // 8-byte Folded Reload
	b.eq	.LBB359_27
// %bb.14:                              // %B13
	ldr	x9, [sp, #40]                   // 8-byte Folded Reload
	stur	x0, [x9, #-16]
	sub	x20, x9, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
.LBB359_15:                             // %B44
	ldrb	w8, [x19]
	add	x8, x27, x8, lsl #3
	b	.LBB359_2
.LBB359_16:                             // %B19
	ldr	w9, [x9, #8]
	add	w15, w9, #1
	bics	xzr, x10, x2
	str	x1, [sp, #24]                   // 8-byte Folded Spill
	stp	w13, w11, [sp, #16]             // 8-byte Folded Spill
	str	w14, [sp, #12]                  // 4-byte Folded Spill
	b.ne	.LBB359_5
.LBB359_17:                             // %B39
	ldr	w8, [x8, #8]
	mov	x19, x2
	add	w9, w8, #1
	cmp	w15, w9
	csinc	w15, w15, w8, gt
	str	w15, [sp, #8]                   // 4-byte Folded Spill
	b	.LBB359_6
.LBB359_18:                             // %B31
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x1, lsr #48
	b.eq	.LBB359_8
// %bb.19:                              // %B31
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x1, x8
	cmp	x8, x9
	b.lo	.LBB359_8
// %bb.20:                              // %B33
	mov	x0, x1
	mov	x1, x24
	mov	x19, x2
	bl	prim_WriteBarrierNoStore
	ldr	x12, [sp, #40]                  // 8-byte Folded Reload
	mov	x2, x19
	b	.LBB359_8
.LBB359_21:                             // %B27
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x2, lsr #48
	b.eq	.LBB359_9
// %bb.22:                              // %B27
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x2, x8
	cmp	x8, x9
	b.lo	.LBB359_9
// %bb.23:                              // %B29
	mov	x0, x2
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldr	x12, [sp, #40]                  // 8-byte Folded Reload
	b	.LBB359_9
.LBB359_24:                             // %B7
	b.eq	.LBB359_26
// %bb.25:                              // %B9
	ldr	x9, [sp, #32]                   // 8-byte Folded Reload
	ldrb	w8, [x9]
	add	x19, x9, #2
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x9, #1]
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #40]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #48
	br	x1
.LBB359_26:                             // %B8
	ldr	x19, [sp, #32]                  // 8-byte Folded Reload
.LBB359_27:                             // %B12
	ldr	x20, [sp, #40]                  // 8-byte Folded Reload
	add	sp, sp, #48
	b	.Lexception_asm_h
.Lfunc_end359:
	.size	.LFastJSConcatString_asm_h, .Lfunc_end359-.LFastJSConcatString_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function FastAddNamedProperty_asm_h
	.type	.LFastAddNamedProperty_asm_h,@function
.LFastAddNamedProperty_asm_h:           // @FastAddNamedProperty_asm_h
// %bb.0:                               // %B58
	sub	sp, sp, #48
	ldurb	w14, [x19, #-1]
	mov	x12, x19
	mov	x2, x0
	sub	x13, x20, #24
	cmp	w14, #76
	b.eq	.LBB360_2
// %bb.1:                               // %B58
	cmp	w14, #67
	mov	x8, x13
	b.ne	.LBB360_3
.LBB360_2:                              // %B59
	sub	x8, x20, #16
.LBB360_3:                              // %B54
	ldr	x1, [x8]
	cmp	x1, #18
	b.eq	.LBB360_13
// %bb.4:                               // %B48
	ldr	x16, [x1, #8]
	ldur	x15, [x20, #-8]
	ldr	x19, [x16, #40]
	cbz	x19, .LBB360_14
.LBB360_5:                              // %B51
	ldr	x8, [x1, #16]
	ldr	w9, [x19, #16]
	add	x10, x1, #32
	ldr	w11, [x16, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	.LBB360_7
// %bb.6:                               // %B51
	cbz	w8, .LBB360_17
.LBB360_7:                              // %B1
	ldr	w8, [x16, #48]
	cmp	w8, w2
	b.ne	.LBB360_14
// %bb.8:                               // %B1
	ldrb	w8, [x16, #52]
	cmp	w8, #7
	b.ne	.LBB360_14
.LBB360_9:                              // %B20
	ldr	w8, [x19]
	add	x9, x1, #8
	add	w8, w8, #1
	str	w8, [x19]
	ldr	w8, [x16]
	sub	w8, w8, #1
	str	w8, [x16]
	stlr	x19, [x9]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB360_24
// %bb.10:                              // %B14
	ldr	w8, [x19, #20]
	ldr	x9, [x1, #16]
	sub	w8, w8, #1
	str	x15, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB360_25
.LBB360_11:                             // %B8
	cmp	w14, #67
	b.ne	.LBB360_22
// %bb.12:                              // %B9
	ldrb	w8, [x12, #4]
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	add	x19, x12, #5
	add	sp, sp, #48
	br	x1
.LBB360_13:                             // %B55
	ldr	x1, [x24, #208]
	ldr	x16, [x1, #8]
	ldur	x15, [x20, #-8]
	ldr	x19, [x16, #40]
	cbnz	x19, .LBB360_5
.LBB360_14:                             // %B25
	ldr	x0, [x24, #8]
	stp	x1, x15, [sp, #8]               // 16-byte Folded Spill
	mov	x1, x16
	mov	w3, #7                          // =0x7
	mov	x19, x2
	stp	x13, x12, [sp, #32]             // 16-byte Folded Spill
	str	w14, [sp, #28]                  // 4-byte Folded Spill
	str	x16, [sp]                       // 8-byte Folded Spill
	bl	find_hashed_shape_prop_gc
	ldp	x16, x1, [sp]                   // 16-byte Folded Reload
	mov	x2, x19
	ldp	x13, x12, [sp, #32]             // 16-byte Folded Reload
	ldr	x15, [sp, #16]                  // 8-byte Folded Reload
	ldr	w14, [sp, #28]                  // 4-byte Folded Reload
	cbz	x0, .LBB360_17
// %bb.15:                              // %B29
	ldr	x8, [x1, #16]
	ldr	w9, [x0, #16]
	add	x10, x1, #32
	ldr	w11, [x16, #16]
	mov	x19, x0
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	.LBB360_9
// %bb.16:                              // %B29
	cbnz	w8, .LBB360_9
.LBB360_17:                             // %B32
	mov	x0, x24
	mov	w3, #7                          // =0x7
	mov	w19, w14
	stp	x13, x12, [sp, #32]             // 16-byte Folded Spill
                                        // kill: def $w2 killed $w2 killed $x2
	str	x20, [x23, #48]
	bl	add_property_gc
	cbz	x0, .LBB360_29
// %bb.18:                              // %B45
	ldur	x8, [x20, #-8]
	ldp	x13, x12, [sp, #32]             // 16-byte Folded Reload
	mov	w14, w19
	str	x8, [x0]
	ldrb	w9, [x24, #376]
	cbz	w9, .LBB360_11
// %bb.19:                              // %B41
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x8, lsr #48
	b.eq	.LBB360_11
// %bb.20:                              // %B41
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1688849860263936         // =0xfffa000000000000
	add	x9, x8, x9
	cmp	x9, x10
	b.lo	.LBB360_11
// %bb.21:                              // %B44
	mov	x1, x24
	mov	x0, x8
	b	.LBB360_28
.LBB360_22:                             // %B11
	cmp	w14, #76
	b.ne	.LBB360_32
// %bb.23:                              // %B12
	ldrb	w8, [x12, #4]
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	add	x19, x12, #5
	add	sp, sp, #48
	br	x1
.LBB360_24:                             // %B22
	mov	x8, #-844424930131968           // =0xfffd000000000000
	stp	x1, x15, [sp, #8]               // 16-byte Folded Spill
	mov	x1, x24
	orr	x0, x19, x8
	stp	x13, x12, [sp, #32]             // 16-byte Folded Spill
	str	w14, [sp, #28]                  // 4-byte Folded Spill
	bl	prim_WriteBarrierNoStore
	ldp	x1, x15, [sp, #8]               // 16-byte Folded Reload
	ldr	w14, [sp, #28]                  // 4-byte Folded Reload
	ldp	x13, x12, [sp, #32]             // 16-byte Folded Reload
	ldr	w8, [x19, #20]
	ldr	x9, [x1, #16]
	sub	w8, w8, #1
	str	x15, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB360_11
.LBB360_25:                             // %B17
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x15, lsr #48
	b.eq	.LBB360_11
// %bb.26:                              // %B17
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x15, x8
	cmp	x8, x9
	b.lo	.LBB360_11
// %bb.27:                              // %B19
	mov	x0, x15
	mov	x1, x24
	stp	x13, x12, [sp, #32]             // 16-byte Folded Spill
	mov	w19, w14
.LBB360_28:                             // %B8
	bl	prim_WriteBarrierNoStore
	ldp	x13, x12, [sp, #32]             // 16-byte Folded Reload
	mov	w14, w19
	b	.LBB360_11
.LBB360_29:                             // %B34
	cmp	w19, #67
	b.ne	.LBB360_33
// %bb.30:                              // %B35
	sub	x20, x20, #16
.LBB360_31:                             // %B38
	ldr	x19, [sp, #40]                  // 8-byte Folded Reload
	add	sp, sp, #48
	b	.Lexception_asm_h
.LBB360_32:                             // %B13
	ldrb	w8, [x12], #1
	mov	x19, x12
	mov	x20, x13
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
.LBB360_33:                             // %B37
	cmp	w19, #76
	b.eq	.LBB360_31
// %bb.34:                              // %B39
	ldp	x20, x19, [sp, #32]             // 16-byte Folded Reload
	add	sp, sp, #48
	b	.Lexception_asm_h
.Lfunc_end360:
	.size	.LFastAddNamedProperty_asm_h, .Lfunc_end360-.LFastAddNamedProperty_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function FastStringEqual_asm_h
	.type	.LFastStringEqual_asm_h,@function
.LFastStringEqual_asm_h:                // @FastStringEqual_asm_h
// %bb.0:                               // %B74
	ldp	x1, x2, [x20, #-16]
	and	x9, x1, #0xfffffffffffc
	and	x8, x2, #0xfffffffffffc
	ldr	w10, [x9, #4]
	ldr	w11, [x8, #4]
	eor	w10, w10, w11
	tst	w10, #0x3fffffff
	b.eq	.LBB361_3
.LBB361_1:                              // %B15
	mov	w8, #6                          // =0x6
	bfxil	x8, x0, #0, #1
.LBB361_2:                              // %B16
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB361_3:                              // %B1
	mov	x10, #-281474976710653          // =0xffff000000000003
	bics	xzr, x10, x1
	b.eq	.LBB361_19
// %bb.4:                               // %B69
	bics	xzr, x10, x2
	b.eq	.LBB361_21
.LBB361_5:                              // %B54
	and	x9, x1, #0xfffffffffffc
	cmp	x9, x8
	b.eq	.LBB361_15
.LBB361_6:                              // %B57
	ldr	w11, [x9, #4]
	add	x10, x9, #8
	tbnz	w11, #30, .LBB361_23
// %bb.7:                               // %B6
	ldr	w12, [x8, #4]
	ldr	w13, [x10]
	add	x10, x8, #8
	tbnz	w12, #30, .LBB361_24
.LBB361_8:                              // %B49
	lsr	w13, w13, #30
	cmp	w13, #1
	b.ne	.LBB361_10
.LBB361_9:                              // %B49
	ldr	w10, [x10]
	mov	w13, #1073741824                // =0x40000000
	and	w10, w10, #0xc0000000
	cmp	w10, w13
	b.eq	.LBB361_1
.LBB361_10:                             // %B8
	add	x9, x9, #16
	add	x8, x8, #16
	and	w10, w11, #0x3fffffff
	tbnz	w11, #31, .LBB361_25
// %bb.11:                              // %B32
	mov	w11, wzr
	tbnz	w12, #31, .LBB361_17
// %bb.12:                              // %B42
	cmp	w10, w11
	b.eq	.LBB361_15
.LBB361_13:                             // %B43
                                        // =>This Inner Loop Header: Depth=1
	ldrb	w12, [x9, w11, sxtw]
	ldrb	w13, [x8, w11, sxtw]
	cmp	w12, w13
	b.ne	.LBB361_1
// %bb.14:                              // %B45
                                        //   in Loop: Header=BB361_13 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	.LBB361_13
.LBB361_15:                             // %B21
	mvn	w9, w0
	mov	w8, #6                          // =0x6
	bfxil	x8, x9, #0, #1
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB361_16:                             // %B37
                                        //   in Loop: Header=BB361_17 Depth=1
	add	w11, w11, #1
.LBB361_17:                             // %B34
                                        // =>This Inner Loop Header: Depth=1
	cmp	w10, w11
	b.eq	.LBB361_15
// %bb.18:                              // %B35
                                        //   in Loop: Header=BB361_17 Depth=1
	ldrb	w12, [x9, w11, sxtw]
	ldrh	w13, [x8, w11, sxtw #1]
	cmp	w13, w12
	b.eq	.LBB361_16
	b	.LBB361_1
.LBB361_19:                             // %B66
	ldr	x11, [x9, #24]
	cmp	x11, #2
	b.ne	.LBB361_32
// %bb.20:                              // %B67
	ldr	x1, [x9, #16]
	bics	xzr, x10, x2
	b.ne	.LBB361_5
.LBB361_21:                             // %B3
	ldr	x9, [x8, #24]
	cmp	x9, #2
	b.ne	.LBB361_32
// %bb.22:                              // %B4
	ldr	x8, [x8, #16]
	and	x8, x8, #0xfffffffffffc
	and	x9, x1, #0xfffffffffffc
	cmp	x9, x8
	b.ne	.LBB361_6
	b	.LBB361_15
.LBB361_23:                             // %B58
	ldr	x10, [x10]
	ldr	w12, [x8, #4]
	ldr	w13, [x10]
	add	x10, x8, #8
	tbz	w12, #30, .LBB361_8
.LBB361_24:                             // %B7
	ldr	x10, [x10]
	lsr	w13, w13, #30
	cmp	w13, #1
	b.eq	.LBB361_9
	b	.LBB361_10
.LBB361_25:                             // %B10
	mov	w11, wzr
	tbnz	w12, #31, .LBB361_31
// %bb.26:                              // %B24
	cmp	w10, w11
	b.eq	.LBB361_15
.LBB361_27:                             // %B25
                                        // =>This Inner Loop Header: Depth=1
	ldrh	w12, [x9, w11, sxtw #1]
	ldrb	w13, [x8, w11, sxtw]
	cmp	w12, w13
	b.ne	.LBB361_1
// %bb.28:                              // %B27
                                        //   in Loop: Header=BB361_27 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	.LBB361_27
	b	.LBB361_15
.LBB361_29:                             // %B13
                                        //   in Loop: Header=BB361_31 Depth=1
	ldrh	w12, [x9, w11, sxtw #1]
	ldrh	w13, [x8, w11, sxtw #1]
	cmp	w12, w13
	b.ne	.LBB361_1
// %bb.30:                              // %B18
                                        //   in Loop: Header=BB361_31 Depth=1
	add	w11, w11, #1
.LBB361_31:                             // %B12
                                        // =>This Inner Loop Header: Depth=1
	cmp	w10, w11
	b.ne	.LBB361_29
	b	.LBB361_15
.LBB361_32:                             // %B63
	mov	w3, w0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	mov	x8, x0
	b.ne	.LBB361_2
// %bb.33:                              // %B64
	b	.Lexception_asm_h
.Lfunc_end361:
	.size	.LFastStringEqual_asm_h, .Lfunc_end361-.LFastStringEqual_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function FastFclosure_asm_h
	.type	.LFastFclosure_asm_h,@function
.LFastFclosure_asm_h:                   // @FastFclosure_asm_h
// %bb.0:                               // %B104
	sub	sp, sp, #112
	and	x8, x0, #0xfffffffffffc
	str	x19, [sp, #32]                  // 8-byte Folded Spill
	str	x8, [sp, #64]                   // 8-byte Folded Spill
	ldrb	w8, [x8, #6]
	tst	w8, #0x30
	str	w8, [sp, #60]                   // 4-byte Folded Spill
	b.ne	.LBB362_40
// %bb.1:                               // %B91
	ldrb	w8, [x24, #355]
	cbnz	w8, .LBB362_40
// %bb.2:                               // %B94
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB362_40
// %bb.3:                               // %B97
	ldr	w8, [sp, #60]                   // 4-byte Folded Reload
	mov	w9, #56                         // =0x38
	tst	w8, #0x1
	mov	w8, #48                         // =0x30
	csel	x8, x9, x8, eq
	ldr	x8, [x24, x8]
	cbz	x8, .LBB362_40
// %bb.4:                               // %B9
	str	x8, [sp, #24]                   // 8-byte Folded Spill
	ldr	x8, [sp, #64]                   // 8-byte Folded Reload
	mov	w9, #47                         // =0x2f
	ldr	w8, [x8, #20]
	cmp	w8, #0
	csel	w8, w9, w8, eq
	tbnz	w8, #31, .LBB362_40
// %bb.5:                               // %B86
	ldr	x9, [x24, #8]
	ldr	x9, [x9, #64]
	ldr	x8, [x9, w8, uxtw #3]
	ldrb	w9, [x8, #7]
	str	x8, [sp, #16]                   // 8-byte Folded Spill
	add	x8, x8, #8
	tbnz	w9, #6, .LBB362_33
// %bb.6:                               // %B16
	ldr	w8, [x8]
	ldr	x19, [sp, #64]                  // 8-byte Folded Reload
	lsr	w8, w8, #30
	cmp	w8, #1
	b.ne	.LBB362_34
.LBB362_7:                              // %B19
	ldr	w8, [x19, #60]
	cbz	w8, .LBB362_35
// %bb.8:                               // %B82
	ldr	x9, [x19, #32]
	lsl	x1, x8, #3
	mov	x0, x24
	mov	w2, #48                         // =0x30
	str	x20, [x23, #48]
	stp	x9, x8, [sp, #40]               // 16-byte Folded Spill
	ldr	w9, [x23, #40]
	ldr	x8, [x23, #64]
	str	w9, [sp, #4]                    // 4-byte Folded Spill
	str	x8, [sp, #104]                  // 8-byte Folded Spill
	bl	prim_try_malloc_gc
	cbz	x0, .LBB362_34
// %bb.9:                               // %B83
	ldp	x11, x10, [sp, #40]             // 16-byte Folded Reload
	mov	x12, x0
	ldr	x13, [sp, #104]                 // 8-byte Folded Reload
	str	x20, [sp, #72]                  // 8-byte Folded Spill
	mov	w20, wzr
	mov	w19, wzr
	str	x0, [sp, #8]                    // 8-byte Folded Spill
	b	.LBB362_13
.LBB362_10:                             // %B36
                                        //   in Loop: Header=BB362_13 Depth=1
	mov	w2, #57                         // =0x39
	bl	prim_try_malloc_gc
	cbz	x0, .LBB362_24
.LBB362_11:                             //   in Loop: Header=BB362_13 Depth=1
	ldr	w9, [sp, #92]                   // 4-byte Folded Reload
	ldr	x14, [sp, #80]                  // 8-byte Folded Reload
	mov	x8, x0
	ldp	x12, x13, [sp, #96]             // 16-byte Folded Reload
	add	x9, x14, w9, uxtw #3
	ldp	x11, x10, [sp, #40]             // 16-byte Folded Reload
	str	x9, [x8]
	mov	w9, #18                         // =0x12
	str	x9, [x8, #8]
	ldr	w9, [sp, #88]                   // 4-byte Folded Reload
	str	x8, [x13, w9, uxtw #3]
.LBB362_12:                             // %B74
                                        //   in Loop: Header=BB362_13 Depth=1
	add	w19, w19, #1
	add	w20, w20, #8
	cmp	w19, w10
	str	x8, [x12], #8
	b.hs	.LBB362_25
.LBB362_13:                             // %B76
                                        // =>This Inner Loop Header: Depth=1
	add	x8, x11, w20, uxtw
	ldrb	w9, [x8]
	tbz	w9, #0, .LBB362_17
// %bb.14:                              // %B27
                                        //   in Loop: Header=BB362_13 Depth=1
	ldrh	w14, [x8, #2]
	tbz	w9, #1, .LBB362_19
// %bb.15:                              // %B28
                                        //   in Loop: Header=BB362_13 Depth=1
	mov	x15, x28
	mov	w9, w14
	cbz	x13, .LBB362_20
.LBB362_16:                             // %B43
                                        //   in Loop: Header=BB362_13 Depth=1
	ldr	x8, [x13, w9, uxtw #3]
	cbnz	x8, .LBB362_12
	b	.LBB362_22
.LBB362_17:                             // %B21
                                        //   in Loop: Header=BB362_13 Depth=1
	cbz	x26, .LBB362_24
// %bb.18:                              // %B23
                                        //   in Loop: Header=BB362_13 Depth=1
	ldrh	w8, [x8, #2]
	ldr	x8, [x26, x8, lsl #3]
	b	.LBB362_12
.LBB362_19:                             // %B50
                                        //   in Loop: Header=BB362_13 Depth=1
	ldr	w8, [sp, #4]                    // 4-byte Folded Reload
	mov	x15, x27
	add	w9, w8, w14
	cbnz	x13, .LBB362_16
.LBB362_20:                             // %B29
                                        //   in Loop: Header=BB362_13 Depth=1
	ldr	w8, [x23, #72]
	mov	x0, x24
	mov	w2, #48                         // =0x30
	str	x15, [sp, #80]                  // 8-byte Folded Spill
	lsl	x1, x8, #3
	ldr	x8, [sp, #72]                   // 8-byte Folded Reload
	stp	w9, w14, [sp, #88]              // 8-byte Folded Spill
	str	x12, [sp, #96]                  // 8-byte Folded Spill
	str	x8, [x23, #48]
	bl	prim_try_malloc_gc
	cbz	x0, .LBB362_24
// %bb.21:                              // %B30
                                        //   in Loop: Header=BB362_13 Depth=1
	ldp	w9, w14, [sp, #88]              // 8-byte Folded Reload
	ldr	x12, [sp, #96]                  // 8-byte Folded Reload
	ldr	x15, [sp, #80]                  // 8-byte Folded Reload
	mov	x13, x0
	str	x0, [x23, #64]
.LBB362_22:                             // %B39
                                        //   in Loop: Header=BB362_13 Depth=1
	stp	w9, w14, [sp, #88]              // 8-byte Folded Spill
	ldr	w8, [x23, #44]
	ldr	x9, [sp, #72]                   // 8-byte Folded Reload
	mov	w1, #16                         // =0x10
	str	x15, [sp, #80]                  // 8-byte Folded Spill
	mov	x0, x24
	stp	x12, x13, [sp, #96]             // 16-byte Folded Spill
	str	x9, [x23, #48]
	tbnz	w8, #4, .LBB362_10
// %bb.23:                              // %B32
                                        //   in Loop: Header=BB362_13 Depth=1
	mov	w2, #16                         // =0x10
	bl	prim_try_malloc_gc
	cbnz	x0, .LBB362_11
.LBB362_24:
	ldr	x20, [sp, #72]                  // 8-byte Folded Reload
	b	.LBB362_40
.LBB362_25:
	ldr	x20, [sp, #72]                  // 8-byte Folded Reload
	ldr	w8, [sp, #60]                   // 4-byte Folded Reload
	tbnz	w8, #0, .LBB362_36
.LBB362_26:                             // %B67
	mov	x0, x24
	mov	w1, #88                         // =0x58
	mov	w2, #2                          // =0x2
	str	x20, [x23, #48]
	bl	prim_try_malloc_gc
	mov	x19, x0
	cbz	x19, .LBB362_40
// %bb.27:                              // %B70
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	ldr	w8, [x9]
	add	w8, w8, #1
	str	w8, [x9]
	mov	w8, #1                          // =0x1
	str	w8, [x19]
	strb	w8, [x19, #5]
	mov	w8, #13                         // =0xd
	strh	w8, [x19, #6]
	add	x8, x19, #8
	stlr	x9, [x8]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB362_44
.LBB362_28:                             // %B69
	mov	x12, xzr
.LBB362_29:                             // %B57
	ldp	x10, x11, [sp, #8]              // 16-byte Folded Reload
	add	x8, x19, #56
	ldr	x9, [sp, #64]                   // 8-byte Folded Reload
	str	x8, [x19, #16]
	stp	x9, x10, [x19, #32]
	mov	x10, #2                         // =0x2
	ldrh	w9, [x9, #44]
	movk	x10, #1, lsl #48
	orr	x10, x11, x10
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x19, #56]
	ldr	w9, [sp, #60]                   // 4-byte Folded Reload
	str	x10, [x8, #8]
	tbnz	w9, #0, .LBB362_43
.LBB362_30:                             // %B6
	ldr	x9, [sp, #32]                   // 8-byte Folded Reload
	str	x19, [x20], #8
	ldurb	w8, [x9, #-1]
	cmp	w8, #189
	b.ne	.LBB362_32
// %bb.31:                              // %B7
	ldrb	w8, [x9, #1]
	add	x19, x9, #2
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #112
	br	x1
.LBB362_32:                             // %B8
	ldrb	w8, [x9, #4]
	add	x19, x9, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #112
	br	x1
.LBB362_33:                             // %B87
	ldr	x8, [x8]
	ldr	w8, [x8]
	ldr	x19, [sp, #64]                  // 8-byte Folded Reload
	lsr	w8, w8, #30
	cmp	w8, #1
	b.eq	.LBB362_7
.LBB362_34:
	mov	x1, x24
	b	.LBB362_41
.LBB362_35:
	str	xzr, [sp, #8]                   // 8-byte Folded Spill
	ldr	w8, [sp, #60]                   // 4-byte Folded Reload
	tbz	w8, #0, .LBB362_26
.LBB362_36:                             // %B52
	ldr	x8, [x24, #416]
	str	x8, [sp, #104]                  // 8-byte Folded Spill
	cbz	x8, .LBB362_40
// %bb.37:                              // %B55
	mov	x0, x24
	mov	w1, #88                         // =0x58
	mov	w2, #2                          // =0x2
	str	x20, [x23, #48]
	bl	prim_try_malloc_gc
	mov	x19, x0
	cbz	x19, .LBB362_40
// %bb.38:                              // %B63
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	ldr	w8, [x9]
	add	w8, w8, #1
	str	w8, [x9]
	mov	w8, #1                          // =0x1
	str	w8, [x19]
	mov	w8, #17                         // =0x11
	strb	w8, [x19, #5]
	mov	w8, #13                         // =0xd
	strh	w8, [x19, #6]
	add	x8, x19, #8
	stlr	x9, [x8]
	ldrb	w8, [x24, #376]
	ldr	x12, [sp, #104]                 // 8-byte Folded Reload
	cbz	w8, .LBB362_29
// %bb.39:                              // %B65
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	prim_WriteBarrierNoStore
	ldr	x12, [sp, #104]                 // 8-byte Folded Reload
	b	.LBB362_29
.LBB362_40:
	mov	x1, x24
	ldr	x19, [sp, #64]                  // 8-byte Folded Reload
.LBB362_41:                             // %B1
	mov	x0, x1
	mov	x1, x19
	mov	x2, x26
	mov	x3, x23
	str	x20, [x23, #48]
	bl	js_closure_gc_slowpath
	cmp	x0, #130
	mov	x19, x0
	b.ne	.LBB362_30
// %bb.42:                              // %B2
	ldr	x19, [sp, #32]                  // 8-byte Folded Reload
	add	sp, sp, #112
	b	.Lexception_asm_h
.LBB362_43:                             // %B60
	str	x12, [x8, #16]
	b	.LBB362_30
.LBB362_44:                             // %B72
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	prim_WriteBarrierNoStore
	b	.LBB362_28
.Lfunc_end362:
	.size	.LFastFclosure_asm_h, .Lfunc_end362-.LFastFclosure_asm_h
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
	mov	x8, x0
	cmp	x8, #130
	b.eq	.LBB363_5
// %bb.1:                               // %B6
	ldr	w10, [sp, #4]                   // 4-byte Folded Reload
	ldur	x9, [x20, #-16]
	add	x19, x19, #2
	stur	x8, [x20, #-8]
	mov	x21, x8
	mov	w0, w10
	ldr	x10, [sp, #8]                   // 8-byte Folded Reload
	str	x19, [x23, #32]
	mov	x22, x9
	mov	x27, x9
	str	x10, [x23, #48]
	bl	.Lcommon_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #96]
	b.eq	.LBB363_6
// %bb.2:                               // %B1
	ldurh	w8, [x19, #-2]
	mov	x9, #2                          // =0x2
	movk	x9, #65535, lsl #48
	lsl	x8, x8, #3
	tst	x0, x9
	b.eq	.LBB363_7
// %bb.3:                               // %B5
	sub	x9, x20, x8
	ldur	x9, [x9, #-8]
.LBB363_4:                              // %B3
	sub	x8, x20, x8
	stur	x9, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19], #1
	ldr	x1, [x25, x9, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB363_5:                              // %B10
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
.LBB363_6:                              // %B7
	add	sp, sp, #16
	b	.Lexception_asm_h
.LBB363_7:
	mov	x9, x0
	b	.LBB363_4
.Lfunc_end363:
	.size	.LFastCallConstructor_asm_h, .Lfunc_end363-.LFastCallConstructor_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function FastTypedArrayGet_asm_h
	.type	.LFastTypedArrayGet_asm_h,@function
.LFastTypedArrayGet_asm_h:              // @FastTypedArrayGet_asm_h
// %bb.0:                               // %B43
	sub	sp, sp, #16
	ldp	x1, x2, [x20, #-16]
	mov	x10, x0
	ldr	w8, [x1, #48]
	cmp	w8, w2
	b.ls	.LBB364_14
// %bb.1:                               // %B21
	ldrh	w9, [x1, #6]
	ldr	x8, [x1, #40]
	cmp	w9, #23
	b.lt	.LBB364_8
// %bb.2:                               // %B21
	b.le	.LBB364_9
// %bb.3:                               // %B21
	cmp	w9, #25
	b.le	.LBB364_12
// %bb.4:                               // %B21
	cmp	w9, #26
	b.eq	.LBB364_20
// %bb.5:                               // %B21
	cmp	w9, #27
	b.eq	.LBB364_21
// %bb.6:                               // %B21
	cmp	w9, #29
	b.ne	.LBB364_14
// %bb.7:                               // %B14
	ldr	d0, [x8, w2, sxtw #3]
	mov	x9, #562949953421312            // =0x2000000000000
	fmov	x8, d0
	fcmp	d0, d0
	add	x8, x8, x9
	mov	x9, #9221683186994511872        // =0x7ffa000000000000
	csel	x8, x9, x8, vs
	b	.LBB364_15
.LBB364_8:                              // %B21
	cmp	w9, #21
	b.ne	.LBB364_10
.LBB364_9:                              // %B25
	ldrb	w8, [x8, w2, sxtw]
	orr	x8, x8, #0xfffe000000000000
	b	.LBB364_15
.LBB364_10:                             // %B21
	cmp	w9, #22
	b.ne	.LBB364_14
// %bb.11:                              // %B22
	ldrsb	w8, [x8, w2, sxtw]
	orr	x8, x8, #0xfffe000000000000
	b	.LBB364_15
.LBB364_12:                             // %B21
	cmp	w9, #24
	b.eq	.LBB364_18
// %bb.13:                              // %B21
	cmp	w9, #25
	b.eq	.LBB364_19
.LBB364_14:                             // %B18
	mov	x0, x24
	str	x20, [x23, #48]
	str	x10, [sp, #8]                   // 8-byte Folded Spill
	bl	JS_GetPropertyValue_GC
	ldr	x10, [sp, #8]                   // 8-byte Folded Reload
	cmp	x0, #130
	mov	x8, x0
	b.eq	.LBB364_23
.LBB364_15:                             // %B1
	tbnz	w10, #0, .LBB364_17
// %bb.16:                              // %B4
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB364_17:                             // %B2
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB364_18:                             // %B28
	ldrsh	w8, [x8, w2, sxtw #1]
	orr	x8, x8, #0xfffe000000000000
	b	.LBB364_15
.LBB364_19:                             // %B31
	ldrh	w8, [x8, w2, sxtw #1]
	orr	x8, x8, #0xfffe000000000000
	b	.LBB364_15
.LBB364_20:                             // %B34
	ldr	w8, [x8, w2, sxtw #2]
	orr	x8, x8, #0xfffe000000000000
	b	.LBB364_15
.LBB364_21:                             // %B5
	ldr	w8, [x8, w2, sxtw #2]
	tbnz	w8, #31, .LBB364_24
// %bb.22:                              // %B6
	orr	x8, x8, #0xfffe000000000000
	b	.LBB364_15
.LBB364_23:                             // %B19
	add	sp, sp, #16
	b	.Lexception_asm_h
.LBB364_24:                             // %B10
	ucvtf	d0, w8
	mov	x9, #562949953421312            // =0x2000000000000
	fmov	x8, d0
	add	x8, x8, x9
	b	.LBB364_15
.Lfunc_end364:
	.size	.LFastTypedArrayGet_asm_h, .Lfunc_end364-.LFastTypedArrayGet_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function FastTypedArraySet_asm_h
	.type	.LFastTypedArraySet_asm_h,@function
.LFastTypedArraySet_asm_h:              // @FastTypedArraySet_asm_h
// %bb.0:                               // %B43
	ldp	x1, x2, [x20, #-24]
	mov	w8, #65534                      // =0xfffe
	ldur	x3, [x20, #-8]
	cmp	x8, x2, lsr #48
	b.ne	.LBB365_17
// %bb.1:                               // %B1
	ldr	w8, [x1, #48]
	cmp	w8, w2
	b.ls	.LBB365_17
// %bb.2:                               // %B3
	ldrh	w9, [x1, #6]
	ldr	x8, [x1, #40]
	sub	w10, w9, #22
	cmp	w10, #2
	b.hs	.LBB365_6
// %bb.3:                               // %B14
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x3, lsr #48
	b.ne	.LBB365_17
// %bb.4:                               // %B15
	strb	w3, [x8, w2, sxtw]
.LBB365_5:                              // %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB365_6:                              // %B3
	cmp	w9, #25
	b.gt	.LBB365_10
// %bb.7:                               // %B3
	sub	w10, w9, #24
	cmp	w10, #2
	b.hs	.LBB365_13
// %bb.8:                               // %B20
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x3, lsr #48
	b.ne	.LBB365_17
// %bb.9:                               // %B21
	strh	w3, [x8, w2, sxtw #1]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB365_10:                             // %B3
	sub	w10, w9, #26
	cmp	w10, #2
	b.hs	.LBB365_16
// %bb.11:                              // %B26
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x3, lsr #48
	b.ne	.LBB365_17
// %bb.12:                              // %B27
	str	w3, [x8, w2, sxtw #2]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB365_13:                             // %B3
	cmp	w9, #21
	b.ne	.LBB365_17
// %bb.14:                              // %B5
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x3, lsr #48
	b.ne	.LBB365_17
// %bb.15:                              // %B6
	bic	w9, w3, w3, asr #31
	mov	w10, #255                       // =0xff
	cmp	w9, #255
	csel	w9, w9, w10, lt
	strb	w9, [x8, w2, sxtw]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB365_16:                             // %B3
	cmp	w9, #29
	b.eq	.LBB365_19
.LBB365_17:                             // %B40
	mov	x0, x24
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	JS_SetPropertyValue_GC
	tbz	w0, #31, .LBB365_5
// %bb.18:                              // %B41
	b	.Lexception_asm_h
.LBB365_19:                             // %B32
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x3, lsr #48
	b.ne	.LBB365_21
// %bb.20:                              // %B33
	scvtf	d0, w3
	str	d0, [x8, w2, sxtw #3]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB365_21:                             // %B35
	and	x9, x3, #0xfffe000000000000
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x9, x10
	b.eq	.LBB365_17
// %bb.22:                              // %B35
	cbz	x9, .LBB365_17
// %bb.23:                              // %B36
	mov	x9, #-562949953421312           // =0xfffe000000000000
	add	x9, x3, x9
	str	x9, [x8, w2, sxtw #3]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end365:
	.size	.LFastTypedArraySet_asm_h, .Lfunc_end365-.LFastTypedArraySet_asm_h
                                        // -- End function
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
	ldr	x8, [x24, #8]
	ldrh	w9, [x22, #6]
	mov	w10, #40                        // =0x28
	mov	x3, x0
	ldr	x8, [x8, #80]
	cmp	w9, #12
	umaddl	x8, w9, w10, x8
	ldr	x8, [x8, #24]
	b.ne	.LBB366_26
// %bb.1:                               // %B12
	ldrb	w9, [x22, #40]
	cmp	w3, w9
	b.lt	.LBB366_31
// %bb.2:                               // %B26
	ldr	x8, [x24, #296]
	ldr	x9, [x8]
	sub	x8, sp, #144
	cmp	x8, x9
	b.ls	.LBB366_29
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
	b.gt	.LBB366_8
// %bb.4:                               // %B15
	cmp	w9, #3
	b.gt	.LBB366_12
// %bb.5:                               // %B15
	cbz	w9, .LBB366_19
// %bb.6:                               // %B15
	cmp	w9, #1
	b.ne	.LBB366_24
// %bb.7:                               // %B19
	ldrsh	w4, [x22, #42]
	mov	x1, x21
	mov	x0, x24
	b	.LBB366_15
.LBB366_8:                              // %B15
	cmp	w9, #9
	b.gt	.LBB366_16
// %bb.9:                               // %B15
	cmp	w9, #8
	b.eq	.LBB366_20
// %bb.10:                              // %B15
	cmp	w9, #9
	b.ne	.LBB366_24
// %bb.11:                              // %B22
	ldr	x2, [x20]
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	.LBB366_25
.LBB366_12:                             // %B15
	cmp	w9, #4
	b.eq	.LBB366_21
// %bb.13:                              // %B15
	cmp	w9, #5
	b.ne	.LBB366_24
// %bb.14:                              // %B18
	ldrsh	w4, [x22, #42]
	mov	x0, x24
	mov	w1, #18                         // =0x12
.LBB366_15:                             // %B21
	mov	w2, w3
	mov	x3, x20
	blr	x8
	b	.LBB366_25
.LBB366_16:                             // %B15
	cmp	w9, #10
	b.eq	.LBB366_23
// %bb.17:                              // %B15
	cmp	w9, #11
	b.ne	.LBB366_24
// %bb.18:                              // %B24
	ldr	x2, [x20]
	ldrsh	w3, [x22, #42]
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	.LBB366_25
.LBB366_19:                             // %B17
	mov	x1, x21
	mov	x0, x24
	b	.LBB366_22
.LBB366_20:                             // %B20
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	.LBB366_25
.LBB366_21:                             // %B16
	mov	x0, x24
	mov	w1, #18                         // =0x12
.LBB366_22:                             // %B21
	mov	w2, w3
	mov	x3, x20
	blr	x8
	b	.LBB366_25
.LBB366_23:                             // %B23
	ldrsh	w2, [x22, #42]
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	.LBB366_25
.LBB366_24:                             // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	x4, x20
                                        // kill: def $w3 killed $w3 killed $x3
	bl	prim_call_c_function_default
.LBB366_25:                             // %B21
	ldr	x8, [x24, #8]
	mov	x1, x0
	mov	x30, x28
	mov	x0, x1
	str	x23, [x8, #256]
	mov	sp, x19
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	ret
.LBB366_26:                             // %B29
	cmp	w9, #15
	b.ne	.LBB366_30
// %bb.27:                              // %B8
	ldr	x9, [x22, #32]
	ldrb	w10, [x9, #8]
	cmp	w3, w10
	b.lt	.LBB366_31
// %bb.28:                              // %B10
	ldr	x8, [x9]
	ldrh	w4, [x9, #10]
	add	x5, x9, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, w3
	mov	x3, x20
	blr	x8
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	ret
.LBB366_29:                             // %B27
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	b	.LThrowStackOverflow_Return_asm_h
.LBB366_30:                             // %B2
	cbz	x8, .LBB366_32
.LBB366_31:                             // %B5
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	x4, x20
	mov	w5, w19
                                        // kill: def $w3 killed $w3 killed $x3
	blr	x8
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	ret
.LBB366_32:                             // %B3
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	b	.LThrowTypeErrorNotFunction_Return_asm_h
.Lfunc_end366:
	.size	.Lcall_native_entry_asm_h, .Lfunc_end366-.Lcall_native_entry_asm_h
	.cfi_endproc
                                        // -- End function
	.section	.text.unlikely.,"ax",@progbits
	.p2align	2                               // -- Begin function ThrowTypeErrorNotFunction_Return_asm_h
	.type	.LThrowTypeErrorNotFunction_Return_asm_h,@function
.LThrowTypeErrorNotFunction_Return_asm_h: // @ThrowTypeErrorNotFunction_Return_asm_h
// %bb.0:                               // %B0
	mov	x0, x24
	mov	x22, x30
	bl	JS_ThrowTypeErrorNotFunction
	mov	x30, x22
	ret
.Lfunc_end367:
	.size	.LThrowTypeErrorNotFunction_Return_asm_h, .Lfunc_end367-.LThrowTypeErrorNotFunction_Return_asm_h
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
.Lfunc_end368:
	.size	.LThrowStackOverflow_Return_asm_h, .Lfunc_end368-.LThrowStackOverflow_Return_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function exception_asm_h
	.type	.Lexception_asm_h,@function
.Lexception_asm_h:                      // @exception_asm_h
// %bb.0:                               // %B17
	sub	sp, sp, #32
	ldr	x9, [x24, #8]
	str	x20, [sp, #24]                  // 8-byte Folded Spill
	ldr	w8, [x9, #248]
	ldr	x20, [x9, #240]
	str	x9, [sp, #8]                    // 8-byte Folded Spill
	cbz	w8, .LBB369_2
// %bb.1:                               // %B18
	mov	x0, x24
	mov	x1, x20
	mov	x2, xzr
	mov	x3, xzr
	mov	x4, x19
	mov	w5, wzr
	mov	w6, wzr
	bl	build_backtrace
.LBB369_2:                              // %B2
	mov	x0, x24
	mov	x1, x20
	str	x19, [sp, #16]                  // 8-byte Folded Spill
	bl	JS_IsUncatchableError_GC
	cbz	w0, .LBB369_4
.LBB369_3:                              // %B4
	ldp	x19, x20, [sp, #16]             // 16-byte Folded Reload
	mov	w0, #130                        // =0x82
	add	sp, sp, #32
	b	.Lcommon_return_asm_h
.LBB369_4:                              // %B6
	ldr	x8, [x23, #8]
	mov	x11, #247                       // =0xf7
	ldr	x20, [sp, #24]                  // 8-byte Folded Reload
	movk	x11, #65535, lsl #48
	ldr	x8, [x8, #32]
	str	x8, [sp]                        // 8-byte Folded Spill
	ldrh	w8, [x8, #42]
	add	x19, x27, x8, lsl #3
.LBB369_5:                              // %B16
                                        // =>This Inner Loop Header: Depth=1
	cmp	x20, x19
	b.le	.LBB369_3
// %bb.6:                               // %B12
                                        //   in Loop: Header=BB369_5 Depth=1
	mov	x8, x20
	ldr	x9, [x20, #-8]!
	and	x10, x9, x11
	cmp	x10, #66
	b.ne	.LBB369_5
// %bb.7:                               // %B9
                                        //   in Loop: Header=BB369_5 Depth=1
	lsr	x9, x9, #16
	cbnz	w9, .LBB369_9
// %bb.8:                               // %B10
                                        //   in Loop: Header=BB369_5 Depth=1
	ldur	x1, [x8, #-24]
	mov	x0, x24
	mov	w2, #1                          // =0x1
	sub	x20, x8, #16
	bl	JS_IteratorClose
	mov	x11, #247                       // =0xf7
	movk	x11, #65535, lsl #48
	b	.LBB369_5
.LBB369_9:                              // %B11
	ldr	x12, [sp, #8]                   // 8-byte Folded Reload
	mov	w11, #2                         // =0x2
	mov	x20, x8
	ldr	x10, [x12, #240]
	stur	x10, [x8, #-8]
	ldr	x10, [sp]                       // 8-byte Folded Reload
	str	x11, [x12, #240]
	ldr	x10, [x10, #8]
	add	x19, x10, w9, sxtw
	ldrb	w9, [x19], #1
	ldr	x1, [x25, x9, lsl #3]
	add	sp, sp, #32
	br	x1
.Lfunc_end369:
	.size	.Lexception_asm_h, .Lfunc_end369-.Lexception_asm_h
                                        // -- End function
	.text
	.p2align	2                               // -- Begin function common_call_debugger0_asm_h
	.type	.Lcommon_call_debugger0_asm_h,@function
.Lcommon_call_debugger0_asm_h:          // @common_call_debugger0_asm_h
// %bb.0:                               // %B0
	ldurb	w8, [x19, #-1]
	mov	x9, #-5832                      // =0xffffffffffffe938
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, x9]
	br	x1
.Lfunc_end370:
	.size	.Lcommon_call_debugger0_asm_h, .Lfunc_end370-.Lcommon_call_debugger0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function common_call_debugger1_asm_h
	.type	.Lcommon_call_debugger1_asm_h,@function
.Lcommon_call_debugger1_asm_h:          // @common_call_debugger1_asm_h
// %bb.0:                               // %B0
	ldurb	w8, [x19, #-1]
	add	x8, x25, x8, lsl #3
	sub	x8, x8, #3888
	ldr	x1, [x8]
	br	x1
.Lfunc_end371:
	.size	.Lcommon_call_debugger1_asm_h, .Lfunc_end371-.Lcommon_call_debugger1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function common_call_debugger2_asm_h
	.type	.Lcommon_call_debugger2_asm_h,@function
.Lcommon_call_debugger2_asm_h:          // @common_call_debugger2_asm_h
// %bb.0:                               // %B0
	ldurb	w8, [x19, #-1]
	add	x8, x25, x8, lsl #3
	sub	x8, x8, #1944
	ldr	x1, [x8]
	br	x1
.Lfunc_end372:
	.size	.Lcommon_call_debugger2_asm_h, .Lfunc_end372-.Lcommon_call_debugger2_asm_h
                                        // -- End function
	.section	.text.unlikely.,"ax",@progbits
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
.Lfunc_end373:
	.size	.LSlowCloseVarRefs_asm_h, .Lfunc_end373-.LSlowCloseVarRefs_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function exception_spill_top0_asm_h
	.type	.Lexception_spill_top0_asm_h,@function
.Lexception_spill_top0_asm_h:           // @exception_spill_top0_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lexception_asm_h
.Lfunc_end374:
	.size	.Lexception_spill_top0_asm_h, .Lfunc_end374-.Lexception_spill_top0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function exception_spill_top1_asm_h
	.type	.Lexception_spill_top1_asm_h,@function
.Lexception_spill_top1_asm_h:           // @exception_spill_top1_asm_h
// %bb.0:                               // %B0
	str	x21, [x20], #8
	b	.Lexception_asm_h
.Lfunc_end375:
	.size	.Lexception_spill_top1_asm_h, .Lfunc_end375-.Lexception_spill_top1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function exception_spill_top0_top1_asm_h
	.type	.Lexception_spill_top0_top1_asm_h,@function
.Lexception_spill_top0_top1_asm_h:      // @exception_spill_top0_top1_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lexception_asm_h
.Lfunc_end376:
	.size	.Lexception_spill_top0_top1_asm_h, .Lfunc_end376-.Lexception_spill_top0_top1_asm_h
                                        // -- End function
	.text
	.p2align	2                               // -- Begin function spill_table1_to_table0_asm_h
	.type	.Lspill_table1_to_table0_asm_h,@function
.Lspill_table1_to_table0_asm_h:         // @spill_table1_to_table0_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	ldurb	w8, [x19, #-1]
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end377:
	.size	.Lspill_table1_to_table0_asm_h, .Lfunc_end377-.Lspill_table1_to_table0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function spill_table2_to_table0_asm_h
	.type	.Lspill_table2_to_table0_asm_h,@function
.Lspill_table2_to_table0_asm_h:         // @spill_table2_to_table0_asm_h
// %bb.0:                               // %B0
	stp	x22, x21, [x20], #16
	ldurb	w8, [x19, #-1]
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end378:
	.size	.Lspill_table2_to_table0_asm_h, .Lfunc_end378-.Lspill_table2_to_table0_asm_h
                                        // -- End function
	.section	.text.unlikely.,"ax",@progbits
	.p2align	2                               // -- Begin function SlowToBoolean_asm_h
	.type	.LSlowToBoolean_asm_h,@function
.LSlowToBoolean_asm_h:                  // @SlowToBoolean_asm_h
// %bb.0:                               // %B1
	mov	x1, x0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_ToBoolFree_GC
	tbnz	w0, #31, .LBB379_2
// %bb.1:                               // %B3
	cmp	w0, #0
	mov	w8, #6                          // =0x6
	cinc	x8, x8, ne
	stur	x8, [x20, #-8]
	ldurb	w8, [x19, #-1]
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB379_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end379:
	.size	.LSlowToBoolean_asm_h, .Lfunc_end379-.LSlowToBoolean_asm_h
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
	tbnz	w0, #31, .LBB380_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB380_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end380:
	.size	.LSlowJSPostInc_asm_h, .Lfunc_end380-.LSlowJSPostInc_asm_h
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
	b.eq	.LBB381_2
// %bb.1:                               // %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB381_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end381:
	.size	.LSlowJSNot_asm_h, .Lfunc_end381-.LSlowJSNot_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function SlowJSAdd_asm_h
	.type	.LSlowJSAdd_asm_h,@function
.LSlowJSAdd_asm_h:                      // @SlowJSAdd_asm_h
// %bb.0:                               // %B11
	cbnz	x0, .LBB382_4
// %bb.1:                               // %B14
	sub	x8, x20, #16
.LBB382_2:                              // %B8
	ldur	x2, [x20, #-8]
	ldr	x1, [x8]
	mov	x9, #-281474976710653           // =0xffff000000000003
	mov	x10, #2                         // =0x2
	and	x8, x2, #0xffff000000000003
	movk	x10, #1, lsl #48
	and	x11, x1, #0xffff000000000003
	cmp	x8, x9
	ccmp	x8, x10, #4, ne
	cset	w8, eq
	cmp	x11, x10
	ccmp	x11, x9, #4, ne
	ccmp	w8, #0, #4, eq
	b.eq	.LBB382_5
// %bb.3:                               // %B9
	b	.LFastJSConcatString_asm_h
.LBB382_4:                              // %B12
	ldrb	w8, [x19]
	add	x8, x27, x8, lsl #3
	b	.LBB382_2
.LBB382_5:                              // %B1
	mov	x0, x24
	str	x20, [x23, #48]
	bl	prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	.LBB382_8
// %bb.6:                               // %B4
	ldurb	w8, [x19, #-1]
	cmp	w8, #148
	b.eq	.LBB382_9
// %bb.7:                               // %B7
	stur	x0, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB382_8:                              // %B2
	b	.Lexception_asm_h
.LBB382_9:                              // %B5
	ldrb	w8, [x19]
	sub	x20, x20, #8
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end382:
	.size	.LSlowJSAdd_asm_h, .Lfunc_end382-.LSlowJSAdd_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function SlowPutField_asm_h
	.type	.LSlowPutField_asm_h,@function
.LSlowPutField_asm_h:                   // @SlowPutField_asm_h
// %bb.0:                               // %B15
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	cbnz	x0, .LBB383_3
// %bb.1:                               // %B12
	ldur	x3, [x20, #-8]
	mov	x0, x24
	mov	w4, #32768                      // =0x8000
	str	x20, [x23, #48]
	bl	JS_SetPropertyInternalImpl_GC
	tbnz	w0, #31, .LBB383_8
.LBB383_2:                              // %B14
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB383_3:                              // %B1
	mov	x0, x24
	mov	w3, #7                          // =0x7
	str	x20, [x23, #48]
	bl	add_property_gc
	cbz	x0, .LBB383_9
// %bb.4:                               // %B9
	ldur	x8, [x20, #-8]
	str	x8, [x0]
	ldrb	w9, [x24, #376]
	cbz	w9, .LBB383_2
// %bb.5:                               // %B4
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x8, lsr #48
	b.eq	.LBB383_2
// %bb.6:                               // %B4
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1688849860263936         // =0xfffa000000000000
	add	x9, x8, x9
	cmp	x9, x10
	b.lo	.LBB383_2
// %bb.7:                               // %B8
	mov	x0, x8
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB383_8:                              // %B13
	b	.Lexception_asm_h
.LBB383_9:                              // %B2
	sub	x20, x20, #16
	b	.Lexception_asm_h
.Lfunc_end383:
	.size	.LSlowPutField_asm_h, .Lfunc_end383-.LSlowPutField_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function SlowGetArrayEl_asm_h
	.type	.LSlowGetArrayEl_asm_h,@function
.LSlowGetArrayEl_asm_h:                 // @SlowGetArrayEl_asm_h
// %bb.0:                               // %B47
	ldur	x1, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x1, x8
	b.ne	.LBB384_4
// %bb.1:                               // %B1
	ldrh	w8, [x1, #6]
	cmp	w8, #1
	b.ne	.LBB384_4
// %bb.2:                               // %B13
	ldrb	w8, [x1, #5]
	tbnz	w8, #2, .LBB384_4
// %bb.3:                               // %B13
	ldur	x8, [x20, #-8]
	mov	x10, #2                         // =0x2
	movk	x10, #1, lsl #48
	and	x9, x8, #0xffff000000000003
	cmp	x9, x10
	b.eq	.LBB384_9
.LBB384_4:                              // %B4
	ldur	x2, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	mov	x8, x0
	b.eq	.LBB384_7
.LBB384_5:                              // %B9
	ldurb	w9, [x19, #-1]
	cmp	w9, #72
	b.eq	.LBB384_8
// %bb.6:                               // %B11
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB384_7:                              // %B5
	b	.Lexception_asm_h
.LBB384_8:                              // %B10
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB384_9:                              // %B42
	and	x8, x8, #0xfffffffffffc
	ldrb	w10, [x8, #7]
	add	x9, x8, #8
	tbnz	w10, #6, .LBB384_20
// %bb.10:                              // %B39
	ldr	w9, [x9]
	lsr	w9, w9, #30
	cmp	w9, #1
	b.ne	.LBB384_4
.LBB384_11:                             // %B18
	ldr	x0, [x24, #8]
	mov	x1, x8
	bl	prim_get_interned_non_index_atom
	ldur	x1, [x20, #-16]
	cbz	w0, .LBB384_4
// %bb.12:                              // %B20
	mov	w8, #18                         // =0x12
	mov	x9, x1
.LBB384_13:                             // %B21
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB384_14 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w11, w0, w11
	ldr	w11, [x13, w11, sxtw #2]
	add	w12, w12, #4
	add	x12, x13, x12
	cbz	w11, .LBB384_16
.LBB384_14:                             // %B31
                                        //   Parent Loop BB384_13 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w0, w14
	b.eq	.LBB384_18
// %bb.15:                              // %B36
                                        //   in Loop: Header=BB384_14 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB384_14
.LBB384_16:                             // %B22
                                        //   in Loop: Header=BB384_13 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB384_4
// %bb.17:                              // %B25
                                        //   in Loop: Header=BB384_13 Depth=1
	ldr	x9, [x10, #32]
	cbnz	x9, .LBB384_13
	b	.LBB384_5
.LBB384_18:                             // %B33
	lsr	w8, w13, #30
	cbnz	w8, .LBB384_4
// %bb.19:                              // %B34
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
	b	.LBB384_5
.LBB384_20:                             // %B43
	ldr	x9, [x9]
	ldr	w9, [x9]
	lsr	w9, w9, #30
	cmp	w9, #1
	b.eq	.LBB384_11
	b	.LBB384_4
.Lfunc_end384:
	.size	.LSlowGetArrayEl_asm_h, .Lfunc_end384-.LSlowGetArrayEl_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function SlowPutArrayEl_asm_h
	.type	.LSlowPutArrayEl_asm_h,@function
.LSlowPutArrayEl_asm_h:                 // @SlowPutArrayEl_asm_h
// %bb.0:                               // %B78
	cmp	w0, #1
	b.eq	.LBB385_4
// %bb.1:                               // %B78
	cmp	w0, #2
	b.ne	.LBB385_6
// %bb.2:                               // %B5
	ldur	x1, [x20, #-24]
	ldur	w2, [x20, #-16]
	mov	x0, x24
	ldur	x3, [x20, #-8]
	mov	w4, #32768                      // =0x8000
	str	x20, [x23, #48]
	bl	JS_SetArrayIntPropertyValue_GC
	tbnz	w0, #31, .LBB385_5
.LBB385_3:                              // %B7
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB385_4:                              // %B1
	ldur	x1, [x20, #-24]
	ldur	x2, [x20, #-8]
	mov	x0, x24
	mov	w3, #32768                      // =0x8000
	str	x20, [x23, #48]
	bl	add_fast_array_element_gc
	tbz	w0, #31, .LBB385_3
.LBB385_5:                              // %B6
	b	.Lexception_asm_h
.LBB385_6:                              // %B8
	ldur	x1, [x20, #-24]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x1, x8
	b.ne	.LBB385_10
// %bb.7:                               // %B74
	ldrh	w8, [x1, #6]
	cmp	w8, #1
	b.ne	.LBB385_10
// %bb.8:                               // %B10
	ldrb	w8, [x1, #5]
	tbnz	w8, #2, .LBB385_10
// %bb.9:                               // %B17
	ldur	x8, [x20, #-16]
	mov	x10, #2                         // =0x2
	movk	x10, #1, lsl #48
	and	x9, x8, #0xffff000000000003
	cmp	x9, x10
	b.eq	.LBB385_12
.LBB385_10:                             // %B13
	ldp	x2, x3, [x20, #-16]
	mov	x0, x24
	mov	w4, #32768                      // =0x8000
	str	x20, [x23, #48]
	bl	JS_SetPropertyValue_GC
	tbz	w0, #31, .LBB385_3
// %bb.11:                              // %B14
	b	.Lexception_asm_h
.LBB385_12:                             // %B69
	and	x8, x8, #0xfffffffffffc
	ldrb	w10, [x8, #7]
	add	x9, x8, #8
	tbnz	w10, #6, .LBB385_31
// %bb.13:                              // %B66
	ldr	w9, [x9]
	lsr	w9, w9, #30
	cmp	w9, #1
	b.ne	.LBB385_10
.LBB385_14:                             // %B19
	ldr	x0, [x24, #8]
	mov	x1, x8
	bl	prim_get_interned_non_index_atom
	ldur	x1, [x20, #-24]
	cbz	w0, .LBB385_10
// %bb.15:                              // %B21
	ldr	x9, [x1, #8]
	ldr	w8, [x9, #12]
	add	x12, x9, #64
	lsl	w11, w8, #2
	and	w10, w0, w8
	ldur	x8, [x20, #-8]
	ldr	w10, [x12, w10, sxtw #2]
	add	w11, w11, #4
	add	x11, x12, x11
	cbz	w10, .LBB385_18
.LBB385_16:                             // %B31
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w0, w13
	b.eq	.LBB385_26
// %bb.17:                              // %B36
                                        //   in Loop: Header=BB385_16 Depth=1
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB385_16
.LBB385_18:                             // %B62
	ldr	w8, [x1, #4]
	tbnz	w8, #10, .LBB385_10
// %bb.19:                              // %B38
	ldr	x9, [x9, #32]
	cbz	x9, .LBB385_25
.LBB385_20:                             // %B40
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB385_21 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x14, x10, #64
	lsl	w13, w11, #2
	and	w11, w0, w11
	ldr	w12, [x14, w11, sxtw #2]
	add	w11, w13, #4
	add	x11, x14, x11
	cbz	w12, .LBB385_23
.LBB385_21:                             // %B43
                                        //   Parent Loop BB385_20 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w12, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w0, w13
	b.eq	.LBB385_32
// %bb.22:                              // %B52
                                        //   in Loop: Header=BB385_21 Depth=2
	and	w12, w12, #0x3ffffff
	cbnz	w12, .LBB385_21
.LBB385_23:                             // %B57
                                        //   in Loop: Header=BB385_20 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB385_10
// %bb.24:                              // %B54
                                        //   in Loop: Header=BB385_20 Depth=1
	ldr	x9, [x10, #32]
	cbnz	x9, .LBB385_20
.LBB385_25:                             // %B48
	tbz	w8, #8, .LBB385_10
	b	.LBB385_33
.LBB385_26:                             // %B33
	mov	w9, #-402653184                 // =0xe8000000
	mov	w11, #134217728                 // =0x8000000
	and	w9, w12, w9
	cmp	w9, w11
	b.ne	.LBB385_10
// %bb.27:                              // %B22
	ldr	x9, [x1, #16]
	sub	w10, w10, #1
	str	x8, [x9, w10, sxtw #3]
	ldrb	w9, [x24, #376]
	cbz	w9, .LBB385_3
// %bb.28:                              // %B26
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x8, lsr #48
	b.eq	.LBB385_3
// %bb.29:                              // %B26
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1688849860263936         // =0xfffa000000000000
	add	x9, x8, x9
	cmp	x9, x10
	b.lo	.LBB385_3
// %bb.30:                              // %B28
	mov	x0, x8
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB385_31:                             // %B70
	ldr	x9, [x9]
	ldr	w9, [x9]
	lsr	w9, w9, #30
	cmp	w9, #1
	b.eq	.LBB385_14
	b	.LBB385_10
.LBB385_32:                             // %B45
	mov	w9, #-402653184                 // =0xe8000000
	mov	w10, #134217728                 // =0x8000000
	and	w8, w8, #0x100
	and	w9, w12, w9
	cmp	w9, w10
	ccmp	w8, #0, #4, eq
	b.eq	.LBB385_10
.LBB385_33:                             // %B49
	mov	w0, w0
	b	.LFastAddNamedProperty_asm_h
.Lfunc_end385:
	.size	.LSlowPutArrayEl_asm_h, .Lfunc_end385-.LSlowPutArrayEl_asm_h
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
.Lfunc_end386:
	.size	.LThrowReferenceErrorUninitialized_asm_h, .Lfunc_end386-.LThrowReferenceErrorUninitialized_asm_h
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
.Lfunc_end387:
	.size	.LThrowThisReferenceError_asm_h, .Lfunc_end387-.LThrowThisReferenceError_asm_h
                                        // -- End function
	.text
	.p2align	2                               // -- Begin function FastBuildArguments_asm_h
	.type	.LFastBuildArguments_asm_h,@function
.LFastBuildArguments_asm_h:             // @FastBuildArguments_asm_h
// %bb.0:                               // %B66
	sub	sp, sp, #48
	ldrb	w8, [x24, #355]
	ldr	w9, [x23, #112]
	str	x19, [sp, #24]                  // 8-byte Folded Spill
	stp	x9, x20, [sp, #32]              // 16-byte Folded Spill
	cbnz	w8, .LBB388_20
// %bb.1:                               // %B63
	ldr	x8, [x24, #400]
	str	x8, [sp, #16]                   // 8-byte Folded Spill
	cbz	x8, .LBB388_20
// %bb.2:                               // %B60
	ldr	x8, [sp, #32]                   // 8-byte Folded Reload
	cbz	w8, .LBB388_11
// %bb.3:                               // %B6
	lsl	x20, x8, #3
	ldr	x8, [sp, #40]                   // 8-byte Folded Reload
	mov	x0, x24
	mov	w2, #42                         // =0x2a
	mov	x1, x20
	str	x8, [x23, #48]
	bl	prim_try_malloc_gc
	cbz	x0, .LBB388_20
// %bb.4:                               // %B8.preheader
	mov	x8, x0
	mov	x19, x28
	add	x10, x20, x0
	mov	x11, #-562949953421312          // =0xfffe000000000000
	mov	w12, #65534                     // =0xfffe
	mov	x13, #-1688849860263936         // =0xfffa000000000000
	mov	x20, x8
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	b	.LBB388_6
.LBB388_5:                              // %B13
                                        //   in Loop: Header=BB388_6 Depth=1
	add	x20, x20, #8
	add	x19, x19, #8
.LBB388_6:                              // %B8
                                        // =>This Inner Loop Header: Depth=1
	cmp	x20, x10
	b.ge	.LBB388_12
// %bb.7:                               // %B15
                                        //   in Loop: Header=BB388_6 Depth=1
	ldr	x8, [x19]
	str	x8, [x20]
	ldrb	w9, [x24, #376]
	cbz	w9, .LBB388_5
// %bb.8:                               // %B11
                                        //   in Loop: Header=BB388_6 Depth=1
	cmp	x12, x8, lsr #48
	b.eq	.LBB388_5
// %bb.9:                               // %B11
                                        //   in Loop: Header=BB388_6 Depth=1
	add	x9, x8, x11
	cmp	x9, x13
	b.lo	.LBB388_5
// %bb.10:                              // %B14
                                        //   in Loop: Header=BB388_6 Depth=1
	mov	x0, x8
	mov	x1, x24
	str	x10, [sp]                       // 8-byte Folded Spill
	bl	prim_WriteBarrierNoStore
	ldr	x10, [sp]                       // 8-byte Folded Reload
	mov	x13, #-1688849860263936         // =0xfffa000000000000
	mov	w12, #65534                     // =0xfffe
	mov	x11, #-562949953421312          // =0xfffe000000000000
	b	.LBB388_5
.LBB388_11:
	str	xzr, [sp, #8]                   // 8-byte Folded Spill
.LBB388_12:                             // %B20
	ldr	x8, [sp, #40]                   // 8-byte Folded Reload
	mov	x0, x24
	mov	w1, #16                         // =0x10
	mov	w2, #42                         // =0x2a
	str	x8, [x23, #48]
	bl	prim_try_malloc_gc
	mov	x20, x0
	cbz	x20, .LBB388_20
// %bb.13:                              // %B52
	ldr	x19, [x24, #192]
	str	x19, [x20]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB388_22
.LBB388_14:                             // %B46
	str	x19, [x20, #8]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB388_25
.LBB388_15:                             // %B24
	ldr	x8, [sp, #40]                   // 8-byte Folded Reload
	mov	x0, x24
	mov	w1, #88                         // =0x58
	mov	w2, #2                          // =0x2
	str	x8, [x23, #48]
	bl	prim_try_malloc_gc
	mov	x19, x0
	cbz	x19, .LBB388_20
// %bb.16:                              // %B41
	ldr	x9, [sp, #16]                   // 8-byte Folded Reload
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
	cbnz	w8, .LBB388_28
.LBB388_17:                             // %B38
	ldr	x10, [sp, #32]                  // 8-byte Folded Reload
	mov	x9, x19
	orr	x8, x10, #0xfffe000000000000
	str	x8, [x9, #56]!
	ldr	x8, [sp, #8]                    // 8-byte Folded Reload
	stur	x9, [x9, #-40]
	stur	x8, [x9, #-16]
	stur	w10, [x9, #-8]
	ldr	x8, [x24, #184]
	str	x8, [x9, #8]
	ldrb	w9, [x24, #376]
	cbnz	w9, .LBB388_29
.LBB388_18:                             // %B31
	str	x20, [x19, #72]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB388_32
.LBB388_19:                             // %B4
	ldr	x20, [sp, #40]                  // 8-byte Folded Reload
	ldr	x9, [sp, #24]                   // 8-byte Folded Reload
	str	x19, [x20], #8
	add	x19, x9, #2
	ldrb	w8, [x9, #1]
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
.LBB388_20:                             // %B1
	ldp	x1, x8, [sp, #32]               // 16-byte Folded Reload
	mov	x0, x24
	mov	x2, x28
                                        // kill: def $w1 killed $w1 killed $x1
	str	x8, [x23, #48]
	bl	js_build_arguments_gc
	cmp	x0, #130
	b.eq	.LBB388_35
// %bb.21:
	mov	x19, x0
	b	.LBB388_19
.LBB388_22:                             // %B55
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x19, lsr #48
	b.eq	.LBB388_14
// %bb.23:                              // %B55
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x19, x8
	cmp	x8, x9
	b.lo	.LBB388_14
// %bb.24:                              // %B57
	mov	x0, x19
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	b	.LBB388_14
.LBB388_25:                             // %B49
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x19, lsr #48
	b.eq	.LBB388_15
// %bb.26:                              // %B49
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x19, x8
	cmp	x8, x9
	b.lo	.LBB388_15
// %bb.27:                              // %B51
	mov	x0, x19
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	b	.LBB388_15
.LBB388_28:                             // %B43
	mov	x8, #-844424930131968           // =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	prim_WriteBarrierNoStore
	b	.LBB388_17
.LBB388_29:                             // %B27
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x8, lsr #48
	b.eq	.LBB388_18
// %bb.30:                              // %B27
	mov	x9, #-562949953421312           // =0xfffe000000000000
	mov	x10, #-1688849860263936         // =0xfffa000000000000
	add	x9, x8, x9
	cmp	x9, x10
	b.lo	.LBB388_18
// %bb.31:                              // %B37
	mov	x0, x8
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	b	.LBB388_18
.LBB388_32:                             // %B34
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x20, lsr #48
	b.eq	.LBB388_19
// %bb.33:                              // %B34
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x20, x8
	cmp	x8, x9
	b.lo	.LBB388_19
// %bb.34:                              // %B36
	mov	x0, x20
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	b	.LBB388_19
.LBB388_35:                             // %B2
	ldr	x19, [sp, #24]                  // 8-byte Folded Reload
	ldr	x20, [sp, #40]                  // 8-byte Folded Reload
	add	sp, sp, #48
	b	.Lexception_asm_h
.Lfunc_end388:
	.size	.LFastBuildArguments_asm_h, .Lfunc_end388-.LFastBuildArguments_asm_h
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
	b.eq	.LBB389_2
// %bb.1:                               // %B4
	ldurh	w8, [x19, #-2]
	sub	x8, x20, x8, lsl #3
	stur	x0, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19], #1
	ldr	x1, [x25, x9, lsl #3]
	br	x1
.LBB389_2:                              // %B3
	b	.Lexception_asm_h
.Lfunc_end389:
	.size	.LFastCallDerivedConstructor_asm_h, .Lfunc_end389-.LFastCallDerivedConstructor_asm_h
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
.Lfunc_end390:
	.size	.Linvalid_0_asm_h, .Lfunc_end390-.Linvalid_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_atom_value_0_asm_h
	.type	.Lpush_atom_value_0_asm_h,@function
.Lpush_atom_value_0_asm_h:              // @push_atom_value_0_asm_h
// %bb.0:                               // %B13
	ldr	w1, [x19]
	tbnz	w1, #31, .LBB391_5
// %bb.1:                               // %B1
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, x1, lsl #3]
	ldrb	w10, [x8, #7]
	add	x9, x8, #8
	tbnz	w10, #6, .LBB391_4
// %bb.2:                               // %B4
	ldr	w9, [x9]
	lsr	w9, w9, #30
	cmp	w9, #1
	b.ne	.LBB391_5
.LBB391_3:                              // %B7
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	mov	x9, #2                          // =0x2
	movk	x9, #1, lsl #48
	orr	x22, x8, x9
	br	x1
.LBB391_4:                              // %B2
	ldr	x9, [x9]
	ldr	w9, [x9]
	lsr	w9, w9, #30
	cmp	w9, #1
	b.eq	.LBB391_3
.LBB391_5:                              // %B10
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
                                        // kill: def $w1 killed $w1 killed $x1
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB391_7
// %bb.6:                               // %B12
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB391_7:                              // %B11
	b	.Lexception_asm_h
.Lfunc_end391:
	.size	.Lpush_atom_value_0_asm_h, .Lfunc_end391-.Lpush_atom_value_0_asm_h
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
	b.eq	.LBB392_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB392_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end392:
	.size	.Lprivate_symbol_0_asm_h, .Lfunc_end392-.Lprivate_symbol_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function special_object_0_asm_h
	.type	.Lspecial_object_0_asm_h,@function
.Lspecial_object_0_asm_h:               // @special_object_0_asm_h
// %bb.0:                               // %B12
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	.LBB393_4
// %bb.1:                               // %B12
	cbz	w8, .LBB393_7
// %bb.2:                               // %B12
	cmp	w8, #2
	b.ne	.LBB393_9
// %bb.3:                               // %B15
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB393_4:                              // %B12
	cmp	w8, #3
	b.eq	.LBB393_8
// %bb.5:                               // %B12
	cmp	w8, #4
	b.ne	.LBB393_11
// %bb.6:                               // %B6
	ldr	x8, [x23, #8]
	mov	w9, #18                         // =0x12
	ldr	x8, [x8, #48]
	cmp	x8, #0
	csel	x8, x9, x8, eq
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB393_7:                              // %B13
	b	.LFastBuildArguments_asm_h
.LBB393_8:                              // %B16
	ldr	x8, [x23, #88]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB393_9:                              // %B2
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
	b.eq	.LBB393_12
.LBB393_10:
	mov	x8, x0
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB393_11:                             // %B9
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x23, #48]
	bl	JS_NewObjectProto_GC
	cmp	x0, #130
	b.ne	.LBB393_10
.LBB393_12:                             // %B10
	b	.Lexception_asm_h
.Lfunc_end393:
	.size	.Lspecial_object_0_asm_h, .Lfunc_end393-.Lspecial_object_0_asm_h
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
	b.eq	.LBB394_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB394_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end394:
	.size	.Lrest_0_asm_h, .Lfunc_end394-.Lrest_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nip1_0_asm_h
	.type	.Lnip1_0_asm_h,@function
.Lnip1_0_asm_h:                         // @nip1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldp	x22, x21, [x20, #-16]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	sub	x8, x20, #24
	mov	x20, x8
	br	x1
.Lfunc_end395:
	.size	.Lnip1_0_asm_h, .Lfunc_end395-.Lnip1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup2_0_asm_h
	.type	.Ldup2_0_asm_h,@function
.Ldup2_0_asm_h:                         // @dup2_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldp	x22, x21, [x20, #-16]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end396:
	.size	.Ldup2_0_asm_h, .Lfunc_end396-.Ldup2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup3_0_asm_h
	.type	.Ldup3_0_asm_h,@function
.Ldup3_0_asm_h:                         // @dup3_0_asm_h
// %bb.0:                               // %B0
	ldp	x8, x22, [x20, #-24]
	ldur	x21, [x20, #-8]
	str	x8, [x20], #8
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end397:
	.size	.Ldup3_0_asm_h, .Lfunc_end397-.Ldup3_0_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x2, [x8, #3888]
	br	x2
.Lfunc_end398:
	.size	.Linsert2_0_asm_h, .Lfunc_end398-.Linsert2_0_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end399:
	.size	.Linsert3_0_asm_h, .Lfunc_end399-.Linsert3_0_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x2, [x8, #3888]
	br	x2
.Lfunc_end400:
	.size	.Linsert4_0_asm_h, .Lfunc_end400-.Linsert4_0_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end401:
	.size	.Lperm3_0_asm_h, .Lfunc_end401-.Lperm3_0_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end402:
	.size	.Lperm4_0_asm_h, .Lfunc_end402-.Lperm4_0_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end403:
	.size	.Lperm5_0_asm_h, .Lfunc_end403-.Lperm5_0_asm_h
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
	add	x10, x25, x10, lsl #3
	ldr	x1, [x10, #3888]
	br	x1
.Lfunc_end404:
	.size	.Lswap2_0_asm_h, .Lfunc_end404-.Lswap2_0_asm_h
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
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.Lfunc_end405:
	.size	.Lrot3l_0_asm_h, .Lfunc_end405-.Lrot3l_0_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end406:
	.size	.Lrot3r_0_asm_h, .Lfunc_end406-.Lrot3r_0_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end407:
	.size	.Lrot4l_0_asm_h, .Lfunc_end407-.Lrot4l_0_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end408:
	.size	.Lrot5l_0_asm_h, .Lfunc_end408-.Lrot5l_0_asm_h
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
	b.eq	.LBB409_2
// %bb.1:                               // %B4
	ldr	x26, [x23, #96]
	mov	x19, xzr
	mov	x20, xzr
	b	.Lcommon_return_asm_h
.LBB409_2:                              // %B3
	mov	x19, xzr
	mov	x20, xzr
	b	.Lexception_asm_h
.Lfunc_end409:
	.size	.Ltail_call_0_asm_h, .Lfunc_end409-.Ltail_call_0_asm_h
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
	b.eq	.LBB410_2
// %bb.1:                               // %B4
	ldr	x26, [x23, #96]
	mov	x19, xzr
	mov	x20, xzr
	b	.Lcommon_return_asm_h
.LBB410_2:                              // %B3
	mov	x19, xzr
	mov	x20, xzr
	b	.Lexception_asm_h
.Lfunc_end410:
	.size	.Ltail_call_method_0_asm_h, .Lfunc_end410-.Ltail_call_method_0_asm_h
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
	b.eq	.LBB411_2
// %bb.1:                               // %B3
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB411_2:                              // %B2
	add	sp, sp, #16
	b	.Lexception_asm_h
.Lfunc_end411:
	.size	.Lapply_0_asm_h, .Lfunc_end411-.Lapply_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_ctor_return_0_asm_h
	.type	.Lcheck_ctor_return_0_asm_h,@function
.Lcheck_ctor_return_0_asm_h:            // @check_ctor_return_0_asm_h
// %bb.0:                               // %B5
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	.LBB412_3
// %bb.1:                               // %B2
	cmp	x22, #18
	b.ne	.LBB412_4
// %bb.2:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w21, #7                         // =0x7
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB412_3:                              // %B6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w21, #6                         // =0x6
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB412_4:                              // %B3
	adrp	x1, .L__unnamed_3
	add	x1, x1, :lo12:.L__unnamed_3
	mov	x0, x24
	str	x20, [x23, #48]
	bl	LEPUS_ThrowTypeError
	b	.Lexception_asm_h
.Lfunc_end412:
	.size	.Lcheck_ctor_return_0_asm_h, .Lfunc_end412-.Lcheck_ctor_return_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_ctor_0_asm_h
	.type	.Lcheck_ctor_0_asm_h,@function
.Lcheck_ctor_0_asm_h:                   // @check_ctor_0_asm_h
// %bb.0:                               // %B2
	ldr	x8, [x23, #88]
	cmp	x8, #18
	b.eq	.LBB413_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB413_2:                              // %B3
	adrp	x1, .L__unnamed_4
	add	x1, x1, :lo12:.L__unnamed_4
	mov	x0, x24
	str	x20, [x23, #48]
	bl	LEPUS_ThrowTypeError
	b	.Lexception_asm_h
.Lfunc_end413:
	.size	.Lcheck_ctor_0_asm_h, .Lfunc_end413-.Lcheck_ctor_0_asm_h
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
	tbnz	w0, #31, .LBB414_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB414_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end414:
	.size	.Lcheck_brand_0_asm_h, .Lfunc_end414-.Lcheck_brand_0_asm_h
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
	tbnz	w0, #31, .LBB415_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB415_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end415:
	.size	.Ladd_brand_0_asm_h, .Lfunc_end415-.Ladd_brand_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_async_0_asm_h
	.type	.Lreturn_async_0_asm_h,@function
.Lreturn_async_0_asm_h:                 // @return_async_0_asm_h
// %bb.0:                               // %B0
	str	x19, [x23, #32]
	mov	w0, #18                         // =0x12
	str	x20, [x23, #48]
	b	.Lcommon_return_direct_asm_h
.Lfunc_end416:
	.size	.Lreturn_async_0_asm_h, .Lfunc_end416-.Lreturn_async_0_asm_h
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
.Lfunc_end417:
	.size	.Lthrow_0_asm_h, .Lfunc_end417-.Lthrow_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function throw_var_0_asm_h
	.type	.Lthrow_var_0_asm_h,@function
.Lthrow_var_0_asm_h:                    // @throw_var_0_asm_h
// %bb.0:                               // %B3
	ldrb	w8, [x19, #4]
	ldr	w2, [x19]
	str	x20, [x23, #48]
	cmp	w8, #1
	b.le	.LBB418_5
// %bb.1:                               // %B3
	cmp	w8, #2
	b.eq	.LBB418_8
// %bb.2:                               // %B3
	cmp	w8, #3
	b.eq	.LBB418_9
// %bb.3:                               // %B3
	cmp	w8, #4
	b.ne	.LBB418_11
// %bb.4:                               // %B8
	adrp	x1, .L__unnamed_5
	add	x1, x1, :lo12:.L__unnamed_5
	mov	x0, x24
	bl	LEPUS_ThrowTypeError
	b	.Lexception_asm_h
.LBB418_5:                              // %B3
	cbz	w8, .LBB418_10
// %bb.6:                               // %B3
	cmp	w8, #1
	b.ne	.LBB418_11
// %bb.7:                               // %B5
	mov	x0, x24
	mov	w1, w2
	bl	JS_ThrowSyntaxErrorVarRedeclaration_GC
	b	.Lexception_asm_h
.LBB418_8:                              // %B6
	mov	x0, x24
	mov	w1, w2
	bl	JS_ThrowReferenceErrorUninitialized_GC
	b	.Lexception_asm_h
.LBB418_9:                              // %B7
	adrp	x1, .L__unnamed_6
	add	x1, x1, :lo12:.L__unnamed_6
	mov	x0, x24
	bl	LEPUS_ThrowReferenceError
	b	.Lexception_asm_h
.LBB418_10:                             // %B4
	mov	x0, x24
	mov	w1, #16384                      // =0x4000
	bl	JS_ThrowTypeErrorReadOnly
	b	.Lexception_asm_h
.LBB418_11:                             // %B9
	adrp	x1, .L__unnamed_7
	add	x1, x1, :lo12:.L__unnamed_7
	mov	x0, x24
	bl	LEPUS_ThrowInternalError
	b	.Lexception_asm_h
.Lfunc_end418:
	.size	.Lthrow_var_0_asm_h, .Lfunc_end418-.Lthrow_var_0_asm_h
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
	b.eq	.LBB419_2
// %bb.1:                               // %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB419_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end419:
	.size	.Leval_0_asm_h, .Lfunc_end419-.Leval_0_asm_h
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
	b.eq	.LBB420_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB420_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end420:
	.size	.Lregexp_0_asm_h, .Lfunc_end420-.Lregexp_0_asm_h
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
	b.eq	.LBB421_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB421_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end421:
	.size	.Lget_super_ctor_0_asm_h, .Lfunc_end421-.Lget_super_ctor_0_asm_h
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
	b.eq	.LBB422_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB422_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end422:
	.size	.Lget_super_0_asm_h, .Lfunc_end422-.Lget_super_0_asm_h
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
	b.eq	.LBB423_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB423_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end423:
	.size	.Limport_0_asm_h, .Lfunc_end423-.Limport_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_var_0_asm_h
	.type	.Lcheck_var_0_asm_h,@function
.Lcheck_var_0_asm_h:                    // @check_var_0_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_CheckGlobalVar_GC
	tbnz	w0, #31, .LBB424_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB424_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end424:
	.size	.Lcheck_var_0_asm_h, .Lfunc_end424-.Lcheck_var_0_asm_h
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
	tbnz	w0, #31, .LBB425_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB425_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end425:
	.size	.Lput_var_init_0_asm_h, .Lfunc_end425-.Lput_var_init_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_strict_0_asm_h
	.type	.Lput_var_strict_0_asm_h,@function
.Lput_var_strict_0_asm_h:               // @put_var_strict_0_asm_h
// %bb.0:                               // %B44
	ldp	x22, x21, [x20, #-16]
	ldr	w1, [x19]
	cmp	x22, #7
	b.ne	.LBB426_11
// %bb.1:                               // %B46
	ldr	x8, [x24, #216]
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x12, x9, #64
	lsl	w11, w10, #2
	and	w9, w1, w10
	ldr	w9, [x12, w9, sxtw #2]
	add	w10, w11, #4
	add	x10, x12, x10
	cbz	w9, .LBB426_4
.LBB426_2:                              // %B36
                                        // =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w1, w12
	b.eq	.LBB426_7
// %bb.3:                               // %B38
                                        //   in Loop: Header=BB426_2 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, .LBB426_2
.LBB426_4:                              // %B40
	ldr	x8, [x24, #208]
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x12, x9, #64
	lsl	w11, w10, #2
	and	w9, w1, w10
	ldr	w9, [x12, w9, sxtw #2]
	add	w10, w11, #4
	add	x10, x12, x10
	cbz	w9, .LBB426_17
.LBB426_5:                              // %B29
                                        // =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w1, w12
	b.eq	.LBB426_12
// %bb.6:                               // %B31
                                        //   in Loop: Header=BB426_5 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, .LBB426_5
	b	.LBB426_17
.LBB426_7:                              // %B1
	mov	w10, #-402653184                // =0xe8000000
	and	w10, w11, w10
	mov	w11, #134217728                 // =0x8000000
	cmp	w10, w11
	b.ne	.LBB426_17
// %bb.8:                               // %B12
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	ldr	x10, [x8, w9, sxtw #3]
	cmp	x10, #34
	b.eq	.LBB426_17
// %bb.9:                               // %B17
	str	x21, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, .LBB426_14
.LBB426_10:                             // %B6
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB426_11:                             // %B45
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_ThrowReferenceErrorNotDefined_GC
	b	.Lexception_asm_h
.LBB426_12:                             // %B24
	mov	w10, #-402653184                // =0xe8000000
	and	w10, w11, w10
	mov	w11, #134217728                 // =0x8000000
	cmp	w10, w11
	b.ne	.LBB426_17
// %bb.13:                              // %B17
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	str	x21, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB426_10
.LBB426_14:                             // %B21
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB426_10
// %bb.15:                              // %B21
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x21, x8
	cmp	x8, x9
	b.lo	.LBB426_10
// %bb.16:                              // %B6.sink.split
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB426_17:                             // %B41
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          // =0x2
	str	x20, [x23, #48]
	bl	JS_SetGlobalVar_GC
	tbz	w0, #31, .LBB426_10
// %bb.18:                              // %B42
	b	.Lexception_asm_h
.Lfunc_end426:
	.size	.Lput_var_strict_0_asm_h, .Lfunc_end426-.Lput_var_strict_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_ref_value_0_asm_h
	.type	.Lget_ref_value_0_asm_h,@function
.Lget_ref_value_0_asm_h:                // @get_ref_value_0_asm_h
// %bb.0:                               // %B49
	ldp	x22, x21, [x20, #-16]
	cmp	x22, #18
	b.eq	.LBB427_7
// %bb.1:                               // %B1
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB427_5
// %bb.2:                               // %B39
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	.LBB427_5
// %bb.3:                               // %B3
	ldrb	w8, [x22, #5]
	tbnz	w8, #2, .LBB427_5
// %bb.4:                               // %B3
	mov	x9, #2                          // =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	.LBB427_10
.LBB427_5:                              // %B43
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB427_9
// %bb.6:                               // %B45
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x21
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB427_7:                              // %B46
	mov	x0, x24
	mov	x1, x21
	str	x20, [x23, #48]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB427_9
// %bb.8:                               // %B48
	mov	w1, w0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB427_9:                              // %B47
	b	.Lexception_asm_h
.LBB427_10:                             // %B9
	and	x1, x21, #0xfffffffffffc
	ldrb	w9, [x1, #7]
	add	x8, x1, #8
	tbnz	w9, #6, .LBB427_22
// %bb.11:                              // %B33
	ldr	w8, [x8]
	lsr	w8, w8, #30
	cmp	w8, #1
	b.ne	.LBB427_5
.LBB427_12:                             // %B11
	ldr	x0, [x24, #8]
	bl	prim_get_interned_non_index_atom
	cbz	w0, .LBB427_5
// %bb.13:                              // %B14.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB427_14:                             // %B14
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB427_15 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w11, w0, w11
	ldr	w11, [x13, w11, sxtw #2]
	add	w12, w12, #4
	add	x12, x13, x12
	cbz	w11, .LBB427_17
.LBB427_15:                             // %B25
                                        //   Parent Loop BB427_14 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w0, w14
	b.eq	.LBB427_19
// %bb.16:                              // %B30
                                        //   in Loop: Header=BB427_15 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB427_15
.LBB427_17:                             // %B16
                                        //   in Loop: Header=BB427_14 Depth=1
	ldrb	w9, [x9, #5]
	tbnz	w9, #2, .LBB427_5
// %bb.18:                              // %B19
                                        //   in Loop: Header=BB427_14 Depth=1
	ldr	x9, [x10, #32]
	cbnz	x9, .LBB427_14
	b	.LBB427_21
.LBB427_19:                             // %B27
	lsr	w8, w13, #30
	cbnz	w8, .LBB427_5
// %bb.20:                              // %B28
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
.LBB427_21:                             // %B22
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x21
	mov	x21, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB427_22:                             // %B10
	ldr	x8, [x8]
	ldr	w8, [x8]
	lsr	w8, w8, #30
	cmp	w8, #1
	b.eq	.LBB427_12
	b	.LBB427_5
.Lfunc_end427:
	.size	.Lget_ref_value_0_asm_h, .Lfunc_end427-.Lget_ref_value_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_ref_value_0_asm_h
	.type	.Lput_ref_value_0_asm_h,@function
.Lput_ref_value_0_asm_h:                // @put_ref_value_0_asm_h
// %bb.0:                               // %B79
	sub	sp, sp, #16
	ldp	x13, x22, [x20, #-24]
	ldur	x21, [x20, #-8]
	cmp	x13, #18
	b.eq	.LBB428_7
// %bb.1:                               // %B1
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x13, x8
	b.ne	.LBB428_5
.LBB428_2:                              // %B65
	ldrh	w8, [x13, #6]
	cmp	w8, #1
	b.ne	.LBB428_5
// %bb.3:                               // %B3
	ldrb	w8, [x13, #5]
	tbnz	w8, #2, .LBB428_5
// %bb.4:                               // %B3
	mov	x9, #2                          // =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	.LBB428_10
.LBB428_5:                              // %B69
	mov	x0, x24
	mov	x1, x13
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	str	x20, [x23, #48]
	bl	JS_SetPropertyValue_GC
	tbnz	w0, #31, .LBB428_9
.LBB428_6:                              // %B20
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB428_7:                              // %B75
	ldr	w8, [x23, #44]
	tbnz	w8, #0, .LBB428_30
// %bb.8:                               // %B76
	ldr	x13, [x24, #208]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x13, x8
	b.eq	.LBB428_2
	b	.LBB428_5
.LBB428_9:                              // %B70
	add	sp, sp, #16
	b	.Lexception_asm_h
.LBB428_10:                             // %B9
	and	x1, x22, #0xfffffffffffc
	ldrb	w9, [x1, #7]
	add	x8, x1, #8
	tbnz	w9, #6, .LBB428_32
// %bb.11:                              // %B59
	ldr	w8, [x8]
	lsr	w8, w8, #30
	cmp	w8, #1
	b.ne	.LBB428_5
.LBB428_12:                             // %B11
	ldr	x0, [x24, #8]
	stp	x13, x20, [sp]                  // 16-byte Folded Spill
	bl	prim_get_interned_non_index_atom
	ldp	x13, x20, [sp]                  // 16-byte Folded Reload
	cbz	w0, .LBB428_5
// %bb.13:                              // %B13
	ldr	x9, [x13, #8]
	ldr	w8, [x9, #12]
	add	x11, x9, #64
	lsl	w10, w8, #2
	and	w8, w0, w8
	ldr	w8, [x11, w8, sxtw #2]
	add	w10, w10, #4
	add	x10, x11, x10
	cbz	w8, .LBB428_16
.LBB428_14:                             // %B16
                                        // =>This Inner Loop Header: Depth=1
	lsl	w11, w8, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w0, w12
	b.eq	.LBB428_25
// %bb.15:                              // %B29
                                        //   in Loop: Header=BB428_14 Depth=1
	and	w8, w11, #0x3ffffff
	cbnz	w8, .LBB428_14
.LBB428_16:                             // %B55
	ldr	w8, [x13, #4]
	tbnz	w8, #10, .LBB428_5
// %bb.17:                              // %B31
	ldr	x9, [x9, #32]
	cbz	x9, .LBB428_24
// %bb.18:                              // %B33.preheader
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
.LBB428_19:                             // %B33
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB428_20 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x14, x10, #64
	lsl	w13, w11, #2
	and	w11, w0, w11
	ldr	w12, [x14, w11, sxtw #2]
	add	w11, w13, #4
	add	x11, x14, x11
	cbz	w12, .LBB428_22
.LBB428_20:                             // %B36
                                        //   Parent Loop BB428_19 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w12, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w0, w13
	b.eq	.LBB428_33
// %bb.21:                              // %B45
                                        //   in Loop: Header=BB428_20 Depth=2
	and	w12, w12, #0x3ffffff
	cbnz	w12, .LBB428_20
.LBB428_22:                             // %B50
                                        //   in Loop: Header=BB428_19 Depth=1
	ldrb	w9, [x9, #5]
	ldr	x13, [sp]                       // 8-byte Folded Reload
	tbnz	w9, #2, .LBB428_5
// %bb.23:                              // %B47
                                        //   in Loop: Header=BB428_19 Depth=1
	ldr	x9, [x10, #32]
	cbnz	x9, .LBB428_19
.LBB428_24:                             // %B41
	ldp	x13, x20, [sp]                  // 16-byte Folded Reload
	tbz	w8, #8, .LBB428_5
	b	.LBB428_34
.LBB428_25:                             // %B18
	mov	w9, #-402653184                 // =0xe8000000
	mov	w10, #134217728                 // =0x8000000
	and	w9, w11, w9
	cmp	w9, w10
	b.ne	.LBB428_5
// %bb.26:                              // %B22
	ldr	x9, [x13, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB428_6
// %bb.27:                              // %B25
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB428_6
// %bb.28:                              // %B25
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x21, x8
	cmp	x8, x9
	b.lo	.LBB428_6
// %bb.29:                              // %B27
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB428_30:                             // %B72
	mov	x0, x24
	mov	x1, x22
	str	x20, [sp, #8]                   // 8-byte Folded Spill
	str	x20, [x23, #48]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB428_35
// %bb.31:                              // %B74
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	mov	w1, w0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_ThrowReferenceErrorNotDefined_GC
	add	sp, sp, #16
	b	.Lexception_asm_h
.LBB428_32:                             // %B10
	ldr	x8, [x8]
	ldr	w8, [x8]
	lsr	w8, w8, #30
	cmp	w8, #1
	b.eq	.LBB428_12
	b	.LBB428_5
.LBB428_33:                             // %B38
	mov	w9, #-402653184                 // =0xe8000000
	mov	w10, #134217728                 // =0x8000000
	and	w8, w8, #0x100
	and	w9, w12, w9
	ldp	x13, x20, [sp]                  // 16-byte Folded Reload
	cmp	w9, w10
	ccmp	w8, #0, #4, eq
	b.eq	.LBB428_5
.LBB428_34:                             // %B42
	mov	w0, w0
	add	sp, sp, #16
	b	.LFastAddNamedProperty_asm_h
.LBB428_35:                             // %B73
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	add	sp, sp, #16
	b	.Lexception_asm_h
.Lfunc_end428:
	.size	.Lput_ref_value_0_asm_h, .Lfunc_end428-.Lput_ref_value_0_asm_h
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
	tbnz	w0, #31, .LBB429_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB429_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end429:
	.size	.Ldefine_var_0_asm_h, .Lfunc_end429-.Ldefine_var_0_asm_h
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
	tbnz	w0, #31, .LBB430_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB430_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end430:
	.size	.Lcheck_define_var_0_asm_h, .Lfunc_end430-.Lcheck_define_var_0_asm_h
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
	tbnz	w0, #31, .LBB431_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	sub	x20, x20, #8
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB431_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end431:
	.size	.Ldefine_func_0_asm_h, .Lfunc_end431-.Ldefine_func_0_asm_h
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
	b.eq	.LBB432_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB432_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end432:
	.size	.Lget_private_field_0_asm_h, .Lfunc_end432-.Lget_private_field_0_asm_h
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
	tbnz	w0, #31, .LBB433_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB433_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end433:
	.size	.Lput_private_field_0_asm_h, .Lfunc_end433-.Lput_private_field_0_asm_h
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
	tbnz	w0, #31, .LBB434_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB434_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end434:
	.size	.Ldefine_private_field_0_asm_h, .Lfunc_end434-.Ldefine_private_field_0_asm_h
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
	cbz	w0, .LBB435_3
// %bb.1:                               // %B5
	ldur	x3, [x20, #-24]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB435_3
// %bb.2:                               // %B7
	stur	x0, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB435_3:                              // %B6
	b	.Lexception_asm_h
.Lfunc_end435:
	.size	.Lget_super_value_0_asm_h, .Lfunc_end435-.Lget_super_value_0_asm_h
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
	b.eq	.LBB436_3
// %bb.1:                               // %B10
	mov	x0, x24
	str	x20, [x23, #48]
	bl	JS_ThrowTypeErrorNotAnObject
.LBB436_2:                              // %B6
	add	sp, sp, #16
	b	.Lexception_asm_h
.LBB436_3:                              // %B1
	ldur	x1, [x20, #-16]
	mov	x0, x24
	str	x9, [sp, #8]                    // 8-byte Folded Spill
	str	x20, [x23, #48]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB436_2
// %bb.4:                               // %B5
	ldur	x3, [x20, #-8]
	ldur	x4, [x20, #-32]
	mov	w2, w0
	ldr	x1, [sp, #8]                    // 8-byte Folded Reload
	mov	x0, x24
	mov	w5, #32768                      // =0x8000
	str	x20, [x23, #48]
	bl	JS_SetPropertyGeneric_GC
	tbnz	w0, #31, .LBB436_2
// %bb.5:                               // %B7
	ldrb	w8, [x19], #1
	sub	x20, x20, #32
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.Lfunc_end436:
	.size	.Lput_super_value_0_asm_h, .Lfunc_end436-.Lput_super_value_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_field_0_asm_h
	.type	.Ldefine_field_0_asm_h,@function
.Ldefine_field_0_asm_h:                 // @define_field_0_asm_h
// %bb.0:                               // %B35
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	ldr	w2, [x19]
	tst	x22, x8
	b.ne	.LBB437_3
// %bb.1:                               // %B32
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	.LBB437_3
// %bb.2:                               // %B26
	ldr	w8, [x22, #4]
	mov	w9, #1280                       // =0x500
	and	w8, w8, w9
	cmp	w8, #256
	b.eq	.LBB437_6
.LBB437_3:                              // %B23
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #16391                      // =0x4007
	str	x20, [x23, #48]
                                        // kill: def $w2 killed $w2 killed $x2
	bl	JS_DefinePropertyValue_GC
	tbnz	w0, #31, .LBB437_5
.LBB437_4:                              // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB437_5:                              // %B24
	b	.Lexception_asm_h
.LBB437_6:                              // %B30
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, .LBB437_9
.LBB437_7:                              // %B15
                                        // =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w2, w11
	b.eq	.LBB437_11
// %bb.8:                               // %B17
                                        //   in Loop: Header=BB437_7 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, .LBB437_7
.LBB437_9:                              // %B20
	tbnz	w2, #31, .LBB437_3
// %bb.10:                              // %B22
	mov	x0, x2
	b	.LFastAddNamedProperty_asm_h
.LBB437_11:                             // %B1
	mov	w9, #-603979776                 // =0xdc000000
	and	w9, w10, w9
	mov	w10, #469762048                 // =0x1c000000
	cmp	w9, w10
	b.ne	.LBB437_3
// %bb.12:                              // %B5
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, .LBB437_4
// %bb.13:                              // %B8
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB437_4
// %bb.14:                              // %B8
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1688849860263936          // =0xfffa000000000000
	add	x8, x21, x8
	cmp	x8, x9
	b.lo	.LBB437_4
// %bb.15:                              // %B10
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end437:
	.size	.Ldefine_field_0_asm_h, .Lfunc_end437-.Ldefine_field_0_asm_h
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
	tbnz	w0, #31, .LBB438_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB438_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end438:
	.size	.Lset_name_0_asm_h, .Lfunc_end438-.Lset_name_0_asm_h
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
	tbnz	w0, #31, .LBB439_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB439_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end439:
	.size	.Lset_name_computed_0_asm_h, .Lfunc_end439-.Lset_name_computed_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_proto_0_asm_h
	.type	.Lset_proto_0_asm_h,@function
.Lset_proto_0_asm_h:                    // @set_proto_0_asm_h
// %bb.0:                               // %B6
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB440_3
// %bb.1:                               // %B6
	cmp	x21, #2
	b.eq	.LBB440_3
.LBB440_2:                              // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB440_3:                              // %B1
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x20, [x23, #48]
	bl	JS_SetPrototypeInternal_GC
	tbz	w0, #31, .LBB440_2
// %bb.4:                               // %B2
	b	.Lexception_asm_h
.Lfunc_end440:
	.size	.Lset_proto_0_asm_h, .Lfunc_end440-.Lset_proto_0_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	add	sp, sp, #16
	br	x1
.Lfunc_end441:
	.size	.Lset_home_object_0_asm_h, .Lfunc_end441-.Lset_home_object_0_asm_h
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
	tbnz	w0, #31, .LBB442_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB442_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end442:
	.size	.Ldefine_array_el_0_asm_h, .Lfunc_end442-.Ldefine_array_el_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function append_0_asm_h
	.type	.Lappend_0_asm_h,@function
.Lappend_0_asm_h:                       // @append_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	js_append_enumerate_gc
	tbnz	w0, #31, .LBB443_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB443_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end443:
	.size	.Lappend_0_asm_h, .Lfunc_end443-.Lappend_0_asm_h
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
	tbnz	w0, #31, .LBB444_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB444_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end444:
	.size	.Lcopy_data_properties_0_asm_h, .Lfunc_end444-.Lcopy_data_properties_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_method_0_asm_h
	.type	.Ldefine_method_0_asm_h,@function
.Ldefine_method_0_asm_h:                // @define_method_0_asm_h
// %bb.0:                               // %B15
	sub	sp, sp, #64
	ldrb	w9, [x19, #4]
	ldp	x12, x1, [x20, #-16]
	str	x19, [sp, #48]                  // 8-byte Folded Spill
	ldr	w19, [x19]
	ands	w8, w9, #0x3
	and	w13, w9, #0x4
	b.eq	.LBB445_2
// %bb.1:                               // %B15
	cmp	w8, #1
	mov	w8, #21761                      // =0x5501
	mov	w9, #19713                      // =0x4d01
	mov	w11, #18                        // =0x12
	mov	w10, #18                        // =0x12
	csel	w9, w8, w9, ne
	csel	x8, x1, x11, ne
	str	x8, [sp, #40]                   // 8-byte Folded Spill
	csel	x8, x10, x1, ne
	str	x8, [sp, #24]                   // 8-byte Folded Spill
	csel	x8, x10, x11, ne
	str	x8, [sp, #16]                   // 8-byte Folded Spill
	b	.LBB445_3
.LBB445_2:
	mov	w8, #18                         // =0x12
	mov	w9, #26371                      // =0x6703
	str	x8, [sp, #40]                   // 8-byte Folded Spill
	mov	w8, #18                         // =0x12
	stp	x1, x8, [sp, #16]               // 16-byte Folded Spill
.LBB445_3:                              // %B1
	orr	w3, w13, w9
	mov	x0, x24
	mov	w2, w19
	mov	x4, x12
	str	x20, [x23, #48]
	str	w9, [sp, #36]                   // 4-byte Folded Spill
	str	x20, [sp, #56]                  // 8-byte Folded Spill
	mov	w20, w19
	mov	x19, x12
	str	w13, [sp, #12]                  // 4-byte Folded Spill
	bl	js_method_set_properties_gc
	tbnz	w0, #31, .LBB445_6
// %bb.4:                               // %B5
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	ldr	w9, [sp, #12]                   // 4-byte Folded Reload
	mov	x0, x24
	ldp	x3, x4, [sp, #16]               // 16-byte Folded Reload
	mov	x1, x19
	str	x8, [x23, #48]
	ldr	w8, [sp, #36]                   // 4-byte Folded Reload
	mov	w2, w20
	ldr	x5, [sp, #40]                   // 8-byte Folded Reload
	orr	w6, w9, w8
	bl	JS_DefineProperty_GC
	tbnz	w0, #31, .LBB445_6
// %bb.5:                               // %B7
	ldr	x9, [sp, #48]                   // 8-byte Folded Reload
	ldrb	w8, [x9, #5]
	add	x19, x9, #6
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #64
	br	x1
.LBB445_6:                              // %B2
	ldp	x19, x20, [sp, #48]             // 16-byte Folded Reload
	add	sp, sp, #64
	b	.Lexception_asm_h
.Lfunc_end445:
	.size	.Ldefine_method_0_asm_h, .Lfunc_end445-.Ldefine_method_0_asm_h
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
	mov	w10, w0
	cbz	w10, .LBB446_11
// %bb.1:                               // %B11
	ldrb	w9, [x19]
	ldur	x11, [x20, #-24]
	ldur	x1, [x20, #-8]
	str	x19, [sp, #48]                  // 8-byte Folded Spill
	ands	w8, w9, #0x3
	and	w9, w9, #0x4
	b.eq	.LBB446_4
// %bb.2:                               // %B11
	cmp	w8, #1
	b.ne	.LBB446_5
// %bb.3:                               // %B19
	mov	w12, #18                        // =0x12
	mov	w8, #19713                      // =0x4d01
	stp	x1, x12, [sp, #24]              // 16-byte Folded Spill
	b	.LBB446_6
.LBB446_4:
	mov	w12, #18                        // =0x12
	mov	w8, #26371                      // =0x6703
	str	x12, [sp, #32]                  // 8-byte Folded Spill
	mov	w12, #18                        // =0x12
	stp	x1, x12, [sp, #16]              // 16-byte Folded Spill
	b	.LBB446_7
.LBB446_5:                              // %B20
	mov	w8, #21761                      // =0x5501
	mov	w12, #18                        // =0x12
	stp	x12, x1, [sp, #24]              // 16-byte Folded Spill
.LBB446_6:                              // %B1
	mov	w12, #18                        // =0x12
	str	x12, [sp, #16]                  // 8-byte Folded Spill
.LBB446_7:                              // %B1
	orr	w3, w9, w8
	mov	x0, x24
	mov	w2, w10
	mov	x4, x11
	str	x20, [x23, #48]
	mov	x19, x11
	str	w8, [sp, #44]                   // 4-byte Folded Spill
	str	x20, [sp, #56]                  // 8-byte Folded Spill
	mov	w20, w10
	str	w9, [sp, #12]                   // 4-byte Folded Spill
	bl	js_method_set_properties_gc
	tbnz	w0, #31, .LBB446_10
// %bb.8:                               // %B5
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	ldr	w9, [sp, #12]                   // 4-byte Folded Reload
	mov	x0, x24
	ldp	x3, x4, [sp, #16]               // 16-byte Folded Reload
	mov	x1, x19
	str	x8, [x23, #48]
	ldr	w8, [sp, #44]                   // 4-byte Folded Reload
	mov	w2, w20
	ldr	x5, [sp, #32]                   // 8-byte Folded Reload
	orr	w6, w9, w8
	bl	JS_DefineProperty_GC
	tbnz	w0, #31, .LBB446_10
// %bb.9:                               // %B7
	ldr	x9, [sp, #48]                   // 8-byte Folded Reload
	ldrb	w8, [x9, #1]
	add	x19, x9, #2
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #64
	br	x1
.LBB446_10:                             // %B2
	ldp	x19, x20, [sp, #48]             // 16-byte Folded Reload
.LBB446_11:                             // %B9
	add	sp, sp, #64
	b	.Lexception_asm_h
.Lfunc_end446:
	.size	.Ldefine_method_computed_0_asm_h, .Lfunc_end446-.Ldefine_method_computed_0_asm_h
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
	tbnz	w0, #31, .LBB447_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB447_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end447:
	.size	.Ldefine_class_0_asm_h, .Lfunc_end447-.Ldefine_class_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc_0_asm_h
	.type	.Lget_loc_0_asm_h,@function
.Lget_loc_0_asm_h:                      // @get_loc_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	x8, x25, x8, lsl #3
	ldr	x22, [x27, x9, lsl #3]
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end448:
	.size	.Lget_loc_0_asm_h, .Lfunc_end448-.Lget_loc_0_asm_h
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
.Lfunc_end449:
	.size	.Lput_loc_0_asm_h, .Lfunc_end449-.Lput_loc_0_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end450:
	.size	.Lset_loc_0_asm_h, .Lfunc_end450-.Lset_loc_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg_0_asm_h
	.type	.Lget_arg_0_asm_h,@function
.Lget_arg_0_asm_h:                      // @get_arg_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	x8, x25, x8, lsl #3
	ldr	x22, [x28, x9, lsl #3]
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end451:
	.size	.Lget_arg_0_asm_h, .Lfunc_end451-.Lget_arg_0_asm_h
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
.Lfunc_end452:
	.size	.Lput_arg_0_asm_h, .Lfunc_end452-.Lput_arg_0_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end453:
	.size	.Lset_arg_0_asm_h, .Lfunc_end453-.Lset_arg_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref_0_asm_h
	.type	.Lget_var_ref_0_asm_h,@function
.Lget_var_ref_0_asm_h:                  // @get_var_ref_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x8, [x26, x8, lsl #3]
	add	x9, x25, x9, lsl #3
	ldr	x8, [x8]
	ldr	x1, [x9, #1944]
	ldr	x22, [x8]
	br	x1
.Lfunc_end454:
	.size	.Lget_var_ref_0_asm_h, .Lfunc_end454-.Lget_var_ref_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_0_asm_h
	.type	.Lput_var_ref_0_asm_h,@function
.Lput_var_ref_0_asm_h:                  // @put_var_ref_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end455:
	.size	.Lput_var_ref_0_asm_h, .Lfunc_end455-.Lput_var_ref_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref_0_asm_h
	.type	.Lset_var_ref_0_asm_h,@function
.Lset_var_ref_0_asm_h:                  // @set_var_ref_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end456:
	.size	.Lset_var_ref_0_asm_h, .Lfunc_end456-.Lset_var_ref_0_asm_h
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
.Lfunc_end457:
	.size	.Lset_loc_uninitialized_0_asm_h, .Lfunc_end457-.Lset_loc_uninitialized_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc_check_0_asm_h
	.type	.Lget_loc_check_0_asm_h,@function
.Lget_loc_check_0_asm_h:                // @get_loc_check_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	.LBB458_2
// %bb.1:                               // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB458_2:                              // %B3
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end458:
	.size	.Lget_loc_check_0_asm_h, .Lfunc_end458-.Lget_loc_check_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc_check_0_asm_h
	.type	.Lput_loc_check_0_asm_h,@function
.Lput_loc_check_0_asm_h:                // @put_loc_check_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	.LBB459_2
// %bb.1:                               // %B4
	str	x22, [x27, x8, lsl #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB459_2:                              // %B3
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end459:
	.size	.Lput_loc_check_0_asm_h, .Lfunc_end459-.Lput_loc_check_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc_check_init_0_asm_h
	.type	.Lput_loc_check_init_0_asm_h,@function
.Lput_loc_check_init_0_asm_h:           // @put_loc_check_init_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	.LBB460_2
// %bb.1:                               // %B4
	str	x22, [x27, x8, lsl #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB460_2:                              // %B3
	b	.LThrowThisReferenceError_asm_h
.Lfunc_end460:
	.size	.Lput_loc_check_init_0_asm_h, .Lfunc_end460-.Lput_loc_check_init_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref_check_0_asm_h
	.type	.Lget_var_ref_check_0_asm_h,@function
.Lget_var_ref_check_0_asm_h:            // @get_var_ref_check_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB461_2
// %bb.1:                               // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #1944]
	br	x1
.LBB461_2:                              // %B3
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end461:
	.size	.Lget_var_ref_check_0_asm_h, .Lfunc_end461-.Lget_var_ref_check_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_check_0_asm_h
	.type	.Lput_var_ref_check_0_asm_h,@function
.Lput_var_ref_check_0_asm_h:            // @put_var_ref_check_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	.LBB462_2
// %bb.1:                               // %B4
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB462_2:                              // %B3
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end462:
	.size	.Lput_var_ref_check_0_asm_h, .Lfunc_end462-.Lput_var_ref_check_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_check_init_0_asm_h
	.type	.Lput_var_ref_check_init_0_asm_h,@function
.Lput_var_ref_check_init_0_asm_h:       // @put_var_ref_check_init_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	.LBB463_2
// %bb.1:                               // %B4
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB463_2:                              // %B3
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end463:
	.size	.Lput_var_ref_check_init_0_asm_h, .Lfunc_end463-.Lput_var_ref_check_init_0_asm_h
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
.Lfunc_end464:
	.size	.Lclose_loc_0_asm_h, .Lfunc_end464-.Lclose_loc_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function catch_0_asm_h
	.type	.Lcatch_0_asm_h,@function
.Lcatch_0_asm_h:                        // @catch_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #4]
	ldr	w10, [x19]
	ldr	x8, [x8, #32]
	add	x9, x25, x9, lsl #3
	ldr	x8, [x8, #8]
	ldr	x1, [x9, #1944]
	mov	w9, #66                         // =0x42
	sub	x8, x19, x8
	add	x19, x19, #5
	add	x8, x8, x10
	orr	x22, x9, x8, lsl #16
	br	x1
.Lfunc_end465:
	.size	.Lcatch_0_asm_h, .Lfunc_end465-.Lcatch_0_asm_h
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
	add	x9, x25, x9, lsl #3
	sub	w10, w19, w10
	mov	x19, x8
	ldr	x1, [x9, #1944]
	add	w9, w10, #4
	orr	x22, x9, #0xfffe000000000000
	br	x1
.Lfunc_end466:
	.size	.Lgosub_0_asm_h, .Lfunc_end466-.Lgosub_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function ret_0_asm_h
	.type	.Lret_0_asm_h,@function
.Lret_0_asm_h:                          // @ret_0_asm_h
// %bb.0:                               // %B6
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB467_3
// %bb.1:                               // %B1
	ldr	x8, [x23, #8]
	ldr	x8, [x8, #32]
	ldr	w9, [x8, #16]
	cmp	w9, w22
	b.le	.LBB467_3
// %bb.2:                               // %B5
	ldr	x8, [x8, #8]
	sub	x20, x20, #8
	add	x19, x8, w22, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB467_3:                              // %B3
	adrp	x1, .L__unnamed_8
	add	x1, x1, :lo12:.L__unnamed_8
	mov	x0, x24
	str	x20, [x23, #48]
	bl	LEPUS_ThrowInternalError
	b	.Lexception_asm_h
.Lfunc_end467:
	.size	.Lret_0_asm_h, .Lfunc_end467-.Lret_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_object_0_asm_h
	.type	.Lto_object_0_asm_h,@function
.Lto_object_0_asm_h:                    // @to_object_0_asm_h
// %bb.0:                               // %B6
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB468_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB468_2:                              // %B1
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #48]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB468_4
// %bb.3:                               // %B3
	mov	x22, x0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB468_4:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end468:
	.size	.Lto_object_0_asm_h, .Lfunc_end468-.Lto_object_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_propkey_0_asm_h
	.type	.Lto_propkey_0_asm_h,@function
.Lto_propkey_0_asm_h:                   // @to_propkey_0_asm_h
// %bb.0:                               // %B15
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	.LBB469_3
// %bb.1:                               // %B15
	and	x8, x22, #0xffff000000000003
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	add	x9, x8, x9
	cmp	x9, #2
	b.lo	.LBB469_3
// %bb.2:                               // %B15
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB469_4
.LBB469_3:                              // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB469_4:                              // %B12
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #48]
	bl	JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	.LBB469_6
// %bb.5:                               // %B14
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB469_6:                              // %B13
	b	.Lexception_asm_h
.Lfunc_end469:
	.size	.Lto_propkey_0_asm_h, .Lfunc_end469-.Lto_propkey_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_propkey2_0_asm_h
	.type	.Lto_propkey2_0_asm_h,@function
.Lto_propkey2_0_asm_h:                  // @to_propkey2_0_asm_h
// %bb.0:                               // %B18
	ldp	x22, x21, [x20, #-16]
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB470_5
// %bb.1:                               // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB470_4
// %bb.2:                               // %B2
	and	x8, x21, #0xffff000000000003
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	add	x9, x8, x9
	cmp	x9, #2
	b.lo	.LBB470_4
// %bb.3:                               // %B2
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB470_7
.LBB470_4:                              // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB470_5:                              // %B19
	adrp	x1, .L__unnamed_9
	add	x1, x1, :lo12:.L__unnamed_9
	mov	x0, x24
	str	x20, [x23, #48]
	bl	LEPUS_ThrowTypeError
.LBB470_6:                              // %B16
	b	.Lexception_asm_h
.LBB470_7:                              // %B15
	mov	x0, x24
	mov	x1, x21
	str	x20, [x23, #48]
	bl	JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	.LBB470_6
// %bb.8:                               // %B17
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end470:
	.size	.Lto_propkey2_0_asm_h, .Lfunc_end470-.Lto_propkey2_0_asm_h
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
	tbnz	w0, #31, .LBB471_4
// %bb.1:                               // %B4
	cbz	w0, .LBB471_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB471_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB471_4:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end471:
	.size	.Lwith_get_var_0_asm_h, .Lfunc_end471-.Lwith_get_var_0_asm_h
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
	tbnz	w0, #31, .LBB472_4
// %bb.1:                               // %B4
	cbz	w0, .LBB472_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	sub	x20, x20, #16
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB472_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB472_4:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end472:
	.size	.Lwith_put_var_0_asm_h, .Lfunc_end472-.Lwith_put_var_0_asm_h
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
	tbnz	w0, #31, .LBB473_4
// %bb.1:                               // %B4
	cbz	w0, .LBB473_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB473_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB473_4:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end473:
	.size	.Lwith_delete_var_0_asm_h, .Lfunc_end473-.Lwith_delete_var_0_asm_h
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
	tbnz	w0, #31, .LBB474_4
// %bb.1:                               // %B4
	cbz	w0, .LBB474_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB474_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB474_4:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end474:
	.size	.Lwith_make_ref_0_asm_h, .Lfunc_end474-.Lwith_make_ref_0_asm_h
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
	tbnz	w0, #31, .LBB475_4
// %bb.1:                               // %B4
	cbz	w0, .LBB475_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB475_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB475_4:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end475:
	.size	.Lwith_get_ref_0_asm_h, .Lfunc_end475-.Lwith_get_ref_0_asm_h
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
	tbnz	w0, #31, .LBB476_4
// %bb.1:                               // %B4
	cbz	w0, .LBB476_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB476_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB476_4:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end476:
	.size	.Lwith_get_ref_undef_0_asm_h, .Lfunc_end476-.Lwith_get_ref_undef_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_loc_ref_0_asm_h
	.type	.Lmake_loc_ref_0_asm_h,@function
.Lmake_loc_ref_0_asm_h:                 // @make_loc_ref_0_asm_h
// %bb.0:                               // %B19
	sub	sp, sp, #16
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x23, #48]
	bl	JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	.LBB477_3
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
	cbz	x8, .LBB477_3
// %bb.2:                               // %B10
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #34                         // =0x22
	str	x20, [x23, #48]
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	bl	add_property_gc
	ldr	x9, [sp, #8]                    // 8-byte Folded Reload
	cbnz	x0, .LBB477_4
.LBB477_3:                              // %B17
	add	sp, sp, #16
	b	.Lexception_asm_h
.LBB477_4:                              // %B13
	mov	x8, #2                          // =0x2
	movk	x8, #65533, lsl #48
	orr	x8, x9, x8
	str	x8, [x0]
	ldrb	w9, [x24, #376]
	cbnz	w9, .LBB477_7
.LBB477_5:                              // %B16
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB477_3
// %bb.6:                               // %B18
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB477_7:                              // %B9
	mov	x0, x8
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	b	.LBB477_5
.Lfunc_end477:
	.size	.Lmake_loc_ref_0_asm_h, .Lfunc_end477-.Lmake_loc_ref_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_arg_ref_0_asm_h
	.type	.Lmake_arg_ref_0_asm_h,@function
.Lmake_arg_ref_0_asm_h:                 // @make_arg_ref_0_asm_h
// %bb.0:                               // %B19
	sub	sp, sp, #16
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x23, #48]
	bl	JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	.LBB478_3
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
	cbz	x8, .LBB478_3
// %bb.2:                               // %B10
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #34                         // =0x22
	str	x20, [x23, #48]
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	bl	add_property_gc
	ldr	x9, [sp, #8]                    // 8-byte Folded Reload
	cbnz	x0, .LBB478_4
.LBB478_3:                              // %B17
	add	sp, sp, #16
	b	.Lexception_asm_h
.LBB478_4:                              // %B13
	mov	x8, #2                          // =0x2
	movk	x8, #65533, lsl #48
	orr	x8, x9, x8
	str	x8, [x0]
	ldrb	w9, [x24, #376]
	cbnz	w9, .LBB478_7
.LBB478_5:                              // %B16
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB478_3
// %bb.6:                               // %B18
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB478_7:                              // %B9
	mov	x0, x8
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	b	.LBB478_5
.Lfunc_end478:
	.size	.Lmake_arg_ref_0_asm_h, .Lfunc_end478-.Lmake_arg_ref_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_var_ref_ref_0_asm_h
	.type	.Lmake_var_ref_ref_0_asm_h,@function
.Lmake_var_ref_ref_0_asm_h:             // @make_var_ref_ref_0_asm_h
// %bb.0:                               // %B15
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x23, #48]
	bl	JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	.LBB479_2
// %bb.1:                               // %B1
	mov	x1, x0
	mov	w8, #18                         // =0x12
	mov	x0, x24
	stp	x1, x8, [x20], #16
	mov	w3, #34                         // =0x22
	ldr	w2, [x19]
	str	x20, [x23, #48]
	bl	add_property_gc
	cbnz	x0, .LBB479_3
.LBB479_2:                              // %B13
	b	.Lexception_asm_h
.LBB479_3:                              // %B8
	ldrh	w8, [x19, #4]
	mov	x9, #2                          // =0x2
	movk	x9, #65533, lsl #48
	ldr	x8, [x26, x8, lsl #3]
	orr	x8, x8, x9
	str	x8, [x0]
	ldrb	w9, [x24, #376]
	cbnz	w9, .LBB479_6
.LBB479_4:                              // %B12
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB479_2
// %bb.5:                               // %B14
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB479_6:                              // %B7
	mov	x0, x8
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	b	.LBB479_4
.Lfunc_end479:
	.size	.Lmake_var_ref_ref_0_asm_h, .Lfunc_end479-.Lmake_var_ref_ref_0_asm_h
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
	tbnz	w0, #31, .LBB480_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB480_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end480:
	.size	.Lmake_var_ref_0_asm_h, .Lfunc_end480-.Lmake_var_ref_0_asm_h
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
	b.eq	.LBB481_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB481_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end481:
	.size	.Lfor_in_start_0_asm_h, .Lfunc_end481-.Lfor_in_start_0_asm_h
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
	tbnz	w0, #31, .LBB482_2
// %bb.1:                               // %B3
	mov	w8, #66                         // =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB482_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end482:
	.size	.Lfor_of_start_0_asm_h, .Lfunc_end482-.Lfor_of_start_0_asm_h
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
	tbnz	w0, #31, .LBB483_2
// %bb.1:                               // %B3
	mov	w8, #66                         // =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB483_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end483:
	.size	.Lfor_await_of_start_0_asm_h, .Lfunc_end483-.Lfor_await_of_start_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_in_next_0_asm_h
	.type	.Lfor_in_next_0_asm_h,@function
.Lfor_in_next_0_asm_h:                  // @for_in_next_0_asm_h
// %bb.0:                               // %B65
	ldur	x8, [x20, #-8]
	mov	x11, #2                         // =0x2
	movk	x11, #65535, lsl #48
	tst	x8, x11
	b.ne	.LBB484_4
// %bb.1:                               // %B62
	ldrh	w9, [x8, #6]
	cmp	w9, #17
	b.ne	.LBB484_4
// %bb.2:                               // %B1
	ldr	x8, [x8, #32]
	cbz	x8, .LBB484_4
// %bb.3:                               // %B9
	ldp	w9, w10, [x8, #8]
	cmp	w9, w10
	b.lo	.LBB484_6
.LBB484_4:                              // %B4
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	js_for_in_next_gc
	tbnz	w0, #31, .LBB484_27
// %bb.5:                               // %B6
	ldrb	w8, [x19], #1
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB484_6:                              // %B11
	ldr	x10, [x8]
	tst	x10, x11
	b.ne	.LBB484_4
// %bb.7:                               // %B13
	ldrb	w11, [x8, #17]
	cbnz	w11, .LBB484_21
// %bb.8:                               // %B37
	ldrb	w11, [x8, #16]
	cbnz	w11, .LBB484_4
// %bb.9:                               // %B40
	ldr	x11, [x8, #24]
	cbz	x11, .LBB484_4
// %bb.10:                              // %B57
	lsl	w12, w9, #3
	add	x11, x11, x12
	ldp	w12, w1, [x11]
	cbz	w12, .LBB484_15
// %bb.11:                              // %B59
	ldr	x11, [x10, #8]
	ldr	w12, [x11, #12]
	add	x11, x11, #64
	lsl	w13, w12, #2
	and	w12, w1, w12
	ldr	w12, [x11, w12, sxtw #2]
	add	w13, w13, #4
	add	x11, x11, x13
	cbz	w12, .LBB484_14
.LBB484_12:                             // %B52
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w12, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w1, w13
	b.eq	.LBB484_16
// %bb.13:                              // %B54
                                        //   in Loop: Header=BB484_12 Depth=1
	and	w12, w12, #0x3ffffff
	cbnz	w12, .LBB484_12
.LBB484_14:                             // %B46
	ldrb	w10, [x10, #5]
	tbnz	w10, #2, .LBB484_4
.LBB484_15:                             // %B49
	add	w9, w9, #1
	str	w9, [x8, #8]
	b	.LBB484_4
.LBB484_16:                             // %B43
	lsr	w10, w12, #30
	cbnz	w10, .LBB484_4
// %bb.17:                              // %B29
	add	w9, w9, #1
	str	w9, [x8, #8]
	tbnz	w1, #31, .LBB484_25
// %bb.18:                              // %B18
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, uxtw #3]
	ldrb	w10, [x8, #7]
	add	x9, x8, #8
	tbnz	w10, #6, .LBB484_24
// %bb.19:                              // %B20
	ldr	w9, [x9]
	lsr	w9, w9, #30
	cmp	w9, #1
	b.ne	.LBB484_25
.LBB484_20:                             // %B26
	mov	x9, #2                          // =0x2
	movk	x9, #1, lsl #48
	orr	x8, x8, x9
	mov	w9, #6                          // =0x6
	stp	x8, x9, [x20], #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB484_21:                             // %B33
	ldrb	w11, [x10, #5]
	tbz	w11, #3, .LBB484_4
// %bb.22:                              // %B15
	ldr	w10, [x10, #48]
	cmp	w9, w10
	b.hs	.LBB484_4
// %bb.23:                              // %B29.thread
	add	w10, w9, #1
	orr	w1, w9, #0x80000000
	str	w10, [x8, #8]
	b	.LBB484_25
.LBB484_24:                             // %B19
	ldr	x9, [x9]
	ldr	w9, [x9]
	lsr	w9, w9, #30
	cmp	w9, #1
	b.eq	.LBB484_20
.LBB484_25:                             // %B23
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB484_27
// %bb.26:                              // %B25
	mov	w8, #6                          // =0x6
	stp	x0, x8, [x20], #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB484_27:                             // %B24
	b	.Lexception_asm_h
.Lfunc_end484:
	.size	.Lfor_in_next_0_asm_h, .Lfunc_end484-.Lfor_in_next_0_asm_h
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
	tbnz	w0, #31, .LBB485_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB485_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end485:
	.size	.Lfor_of_next_0_asm_h, .Lfunc_end485-.Lfor_of_next_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_await_of_next_0_asm_h
	.type	.Lfor_await_of_next_0_asm_h,@function
.Lfor_await_of_next_0_asm_h:            // @for_await_of_next_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	js_for_await_of_next_gc
	tbnz	w0, #31, .LBB486_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB486_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end486:
	.size	.Lfor_await_of_next_0_asm_h, .Lfunc_end486-.Lfor_await_of_next_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_get_value_done_0_asm_h
	.type	.Literator_get_value_done_0_asm_h,@function
.Literator_get_value_done_0_asm_h:      // @iterator_get_value_done_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	js_iterator_get_value_done_gc
	tbnz	w0, #31, .LBB487_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB487_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end487:
	.size	.Literator_get_value_done_0_asm_h, .Lfunc_end487-.Literator_get_value_done_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_close_0_asm_h
	.type	.Literator_close_0_asm_h,@function
.Literator_close_0_asm_h:               // @iterator_close_0_asm_h
// %bb.0:                               // %B6
	sub	sp, sp, #16
	ldur	x1, [x20, #-24]
	cmp	x1, #18
	b.ne	.LBB488_2
.LBB488_1:                              // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB488_2:                              // %B1
	sub	x8, x20, #16
	mov	x0, x24
	mov	w2, wzr
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	str	x8, [x23, #48]
	bl	JS_IteratorClose
	tbz	w0, #31, .LBB488_1
// %bb.3:                               // %B2
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	add	sp, sp, #16
	b	.Lexception_asm_h
.Lfunc_end488:
	.size	.Literator_close_0_asm_h, .Lfunc_end488-.Literator_close_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_close_return_0_asm_h
	.type	.Literator_close_return_0_asm_h,@function
.Literator_close_return_0_asm_h:        // @iterator_close_return_0_asm_h
// %bb.0:                               // %B0
	ldr	x10, [x23, #8]
	ldur	x9, [x20, #-8]
	mov	x11, #247                       // =0xf7
	mov	x8, x20
	movk	x11, #65535, lsl #48
	ldr	x10, [x10, #32]
	ldrh	w10, [x10, #42]
	add	x10, x27, x10, lsl #3
.LBB489_1:                              // %B12
                                        // =>This Inner Loop Header: Depth=1
	mov	x20, x8
	sub	x8, x8, #8
	cmp	x10, x8
	b.ge	.LBB489_3
// %bb.2:                               // %B4
                                        //   in Loop: Header=BB489_1 Depth=1
	ldur	x12, [x8, #-8]
	and	x12, x12, x11
	cmp	x12, #66
	b.ne	.LBB489_1
.LBB489_3:                              // %B7
	add	x10, x10, #24
	cmp	x10, x8
	b.gt	.LBB489_5
// %bb.4:                               // %B9
	ldur	x8, [x20, #-16]
	ldur	q0, [x20, #-32]
	stur	x9, [x20, #-32]
	stur	x8, [x20, #-8]
	stur	q0, [x20, #-24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB489_5:                              // %B8
	adrp	x1, .L__unnamed_10
	add	x1, x1, :lo12:.L__unnamed_10
	mov	x0, x24
	str	x20, [x23, #48]
	bl	LEPUS_ThrowInternalError
	b	.Lexception_asm_h
.Lfunc_end489:
	.size	.Literator_close_return_0_asm_h, .Lfunc_end489-.Literator_close_return_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_iterator_close_0_asm_h
	.type	.Lasync_iterator_close_0_asm_h,@function
.Lasync_iterator_close_0_asm_h:         // @async_iterator_close_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	prim_js_async_iterator_close_gc
	tbnz	w0, #31, .LBB490_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB490_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end490:
	.size	.Lasync_iterator_close_0_asm_h, .Lfunc_end490-.Lasync_iterator_close_0_asm_h
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
	b.eq	.LBB491_2
// %bb.1:                               // %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB491_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end491:
	.size	.Lasync_iterator_next_0_asm_h, .Lfunc_end491-.Lasync_iterator_next_0_asm_h
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
	tbnz	w0, #31, .LBB492_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB492_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end492:
	.size	.Lasync_iterator_get_0_asm_h, .Lfunc_end492-.Lasync_iterator_get_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function initial_yield_0_asm_h
	.type	.Linitial_yield_0_asm_h,@function
.Linitial_yield_0_asm_h:                // @initial_yield_0_asm_h
// %bb.0:                               // %B0
	str	x19, [x23, #32]
	mov	w0, #18                         // =0x12
	str	x20, [x23, #48]
	b	.Lcommon_return_direct_asm_h
.Lfunc_end493:
	.size	.Linitial_yield_0_asm_h, .Lfunc_end493-.Linitial_yield_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function yield_0_asm_h
	.type	.Lyield_0_asm_h,@function
.Lyield_0_asm_h:                        // @yield_0_asm_h
// %bb.0:                               // %B0
	str	x19, [x23, #32]
	mov	x0, #-562949953421311           // =0xfffe000000000001
	str	x20, [x23, #48]
	b	.Lcommon_return_direct_asm_h
.Lfunc_end494:
	.size	.Lyield_0_asm_h, .Lfunc_end494-.Lyield_0_asm_h
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
.Lfunc_end495:
	.size	.Lyield_star_0_asm_h, .Lfunc_end495-.Lyield_star_0_asm_h
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
.Lfunc_end496:
	.size	.Lasync_yield_star_0_asm_h, .Lfunc_end496-.Lasync_yield_star_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function await_0_asm_h
	.type	.Lawait_0_asm_h,@function
.Lawait_0_asm_h:                        // @await_0_asm_h
// %bb.0:                               // %B0
	str	x19, [x23, #32]
	mov	x0, #-562949953421312           // =0xfffe000000000000
	str	x20, [x23, #48]
	b	.Lcommon_return_direct_asm_h
.Lfunc_end497:
	.size	.Lawait_0_asm_h, .Lfunc_end497-.Lawait_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function plus_0_asm_h
	.type	.Lplus_0_asm_h,@function
.Lplus_0_asm_h:                         // @plus_0_asm_h
// %bb.0:                               // %B9
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB498_2
.LBB498_1:                              // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB498_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842624          // =0xfffc000000000000
	add	x8, x22, x8
	cmp	x8, x9
	b.lo	.LBB498_1
// %bb.3:                               // %B6
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        // =0x8d
	str	x20, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB498_5
// %bb.4:                               // %B8
	mov	x22, x0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB498_5:                              // %B7
	b	.Lexception_asm_h
.Lfunc_end498:
	.size	.Lplus_0_asm_h, .Lfunc_end498-.Lplus_0_asm_h
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
	b.eq	.LBB499_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB499_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end499:
	.size	.Ldelete_0_asm_h, .Lfunc_end499-.Ldelete_0_asm_h
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
	tbnz	w0, #31, .LBB500_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB500_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end500:
	.size	.Ldelete_var_0_asm_h, .Lfunc_end500-.Ldelete_var_0_asm_h
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
	b.eq	.LBB501_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB501_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end501:
	.size	.Lpow_0_asm_h, .Lfunc_end501-.Lpow_0_asm_h
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
	b.eq	.LBB502_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB502_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end502:
	.size	.Linstanceof_0_asm_h, .Lfunc_end502-.Linstanceof_0_asm_h
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
	b.eq	.LBB503_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB503_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end503:
	.size	.Lin_0_asm_h, .Lfunc_end503-.Lin_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nop_0_asm_h
	.type	.Lnop_0_asm_h,@function
.Lnop_0_asm_h:                          // @nop_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end504:
	.size	.Lnop_0_asm_h, .Lfunc_end504-.Lnop_0_asm_h
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
	b.eq	.LBB505_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB505_2:                              // %B2
	b	.Lexception_asm_h
.Lfunc_end505:
	.size	.Lpush_empty_string_0_asm_h, .Lfunc_end505-.Lpush_empty_string_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg0_0_asm_h
	.type	.Lset_arg0_0_asm_h,@function
.Lset_arg0_0_asm_h:                     // @set_arg0_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end506:
	.size	.Lset_arg0_0_asm_h, .Lfunc_end506-.Lset_arg0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg1_0_asm_h
	.type	.Lset_arg1_0_asm_h,@function
.Lset_arg1_0_asm_h:                     // @set_arg1_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end507:
	.size	.Lset_arg1_0_asm_h, .Lfunc_end507-.Lset_arg1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg2_0_asm_h
	.type	.Lset_arg2_0_asm_h,@function
.Lset_arg2_0_asm_h:                     // @set_arg2_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end508:
	.size	.Lset_arg2_0_asm_h, .Lfunc_end508-.Lset_arg2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg3_0_asm_h
	.type	.Lset_arg3_0_asm_h,@function
.Lset_arg3_0_asm_h:                     // @set_arg3_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end509:
	.size	.Lset_arg3_0_asm_h, .Lfunc_end509-.Lset_arg3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref0_0_asm_h
	.type	.Lset_var_ref0_0_asm_h,@function
.Lset_var_ref0_0_asm_h:                 // @set_var_ref0_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end510:
	.size	.Lset_var_ref0_0_asm_h, .Lfunc_end510-.Lset_var_ref0_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref1_0_asm_h
	.type	.Lset_var_ref1_0_asm_h,@function
.Lset_var_ref1_0_asm_h:                 // @set_var_ref1_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end511:
	.size	.Lset_var_ref1_0_asm_h, .Lfunc_end511-.Lset_var_ref1_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref2_0_asm_h
	.type	.Lset_var_ref2_0_asm_h,@function
.Lset_var_ref2_0_asm_h:                 // @set_var_ref2_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end512:
	.size	.Lset_var_ref2_0_asm_h, .Lfunc_end512-.Lset_var_ref2_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref3_0_asm_h
	.type	.Lset_var_ref3_0_asm_h,@function
.Lset_var_ref3_0_asm_h:                 // @set_var_ref3_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end513:
	.size	.Lset_var_ref3_0_asm_h, .Lfunc_end513-.Lset_var_ref3_0_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_coverage_0_asm_h
	.type	.Linc_coverage_0_asm_h,@function
.Linc_coverage_0_asm_h:                 // @inc_coverage_0_asm_h
// %bb.0:                               // %B10
	ldr	x8, [x23, #8]
	ldr	x1, [x8, #32]
	ldr	x8, [x1, #112]
	cbz	x8, .LBB514_3
// %bb.1:                               // %B7
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbnz	x8, .LBB514_4
.LBB514_2:                              // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB514_3:                              // %B11
	mov	x0, x24
	str	x20, [x23, #48]
	bl	EnsureCoverageCounters
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbz	x8, .LBB514_2
.LBB514_4:                              // %B2
	ldrsw	x9, [x19]
	ldr	w10, [x10, #104]
	cmp	w9, w10
	b.hs	.LBB514_2
// %bb.5:                               // %B6
	ldr	w10, [x8, x9, lsl #2]
	add	w10, w10, #1
	str	w10, [x8, x9, lsl #2]
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end514:
	.size	.Linc_coverage_0_asm_h, .Lfunc_end514-.Linc_coverage_0_asm_h
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
.Lfunc_end515:
	.size	.Linvalid_1_asm_h, .Lfunc_end515-.Linvalid_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_atom_value_1_asm_h
	.type	.Lpush_atom_value_1_asm_h,@function
.Lpush_atom_value_1_asm_h:              // @push_atom_value_1_asm_h
// %bb.0:                               // %B13
	ldr	w1, [x19]
	tbnz	w1, #31, .LBB516_5
// %bb.1:                               // %B1
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, x1, lsl #3]
	ldrb	w10, [x8, #7]
	add	x9, x8, #8
	tbnz	w10, #6, .LBB516_4
// %bb.2:                               // %B4
	ldr	w9, [x9]
	lsr	w9, w9, #30
	cmp	w9, #1
	b.ne	.LBB516_5
.LBB516_3:                              // %B7
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	mov	x9, #2                          // =0x2
	movk	x9, #1, lsl #48
	orr	x21, x8, x9
	br	x1
.LBB516_4:                              // %B2
	ldr	x9, [x9]
	ldr	w9, [x9]
	lsr	w9, w9, #30
	cmp	w9, #1
	b.eq	.LBB516_3
.LBB516_5:                              // %B10
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
                                        // kill: def $w1 killed $w1 killed $x1
	str	x8, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB516_7
// %bb.6:                               // %B12
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB516_7:                              // %B11
	b	.Lexception_spill_top0_asm_h
.Lfunc_end516:
	.size	.Lpush_atom_value_1_asm_h, .Lfunc_end516-.Lpush_atom_value_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function private_symbol_1_asm_h
	.type	.Lprivate_symbol_1_asm_h,@function
.Lprivate_symbol_1_asm_h:               // @private_symbol_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lprivate_symbol_0_asm_h
.Lfunc_end517:
	.size	.Lprivate_symbol_1_asm_h, .Lfunc_end517-.Lprivate_symbol_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function special_object_1_asm_h
	.type	.Lspecial_object_1_asm_h,@function
.Lspecial_object_1_asm_h:               // @special_object_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lspecial_object_0_asm_h
.Lfunc_end518:
	.size	.Lspecial_object_1_asm_h, .Lfunc_end518-.Lspecial_object_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rest_1_asm_h
	.type	.Lrest_1_asm_h,@function
.Lrest_1_asm_h:                         // @rest_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lrest_0_asm_h
.Lfunc_end519:
	.size	.Lrest_1_asm_h, .Lfunc_end519-.Lrest_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nip1_1_asm_h
	.type	.Lnip1_1_asm_h,@function
.Lnip1_1_asm_h:                         // @nip1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	sub	x8, x20, #16
	mov	x20, x8
	br	x1
.Lfunc_end520:
	.size	.Lnip1_1_asm_h, .Lfunc_end520-.Lnip1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup2_1_asm_h
	.type	.Ldup2_1_asm_h,@function
.Ldup2_1_asm_h:                         // @dup2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20]
	mov	x21, x22
	ldrb	w8, [x19], #1
	ldr	x22, [x20], #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end521:
	.size	.Ldup2_1_asm_h, .Lfunc_end521-.Ldup2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup3_1_asm_h
	.type	.Ldup3_1_asm_h,@function
.Ldup3_1_asm_h:                         // @dup3_1_asm_h
// %bb.0:                               // %B0
	ldur	x8, [x20, #-16]
	mov	x21, x22
	stp	x22, x8, [x20], #16
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end522:
	.size	.Ldup3_1_asm_h, .Lfunc_end522-.Ldup3_1_asm_h
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
	add	x8, x25, x8, lsl #3
	mov	x22, x1
	ldr	x2, [x8, #3888]
	br	x2
.Lfunc_end523:
	.size	.Linsert2_1_asm_h, .Lfunc_end523-.Linsert2_1_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end524:
	.size	.Linsert3_1_asm_h, .Lfunc_end524-.Linsert3_1_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x2, [x8, #3888]
	br	x2
.Lfunc_end525:
	.size	.Linsert4_1_asm_h, .Lfunc_end525-.Linsert4_1_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end526:
	.size	.Lperm3_1_asm_h, .Lfunc_end526-.Lperm3_1_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end527:
	.size	.Lperm4_1_asm_h, .Lfunc_end527-.Lperm4_1_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end528:
	.size	.Lperm5_1_asm_h, .Lfunc_end528-.Lperm5_1_asm_h
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
	add	x10, x25, x10, lsl #3
	ldr	x1, [x10, #3888]
	br	x1
.Lfunc_end529:
	.size	.Lswap2_1_asm_h, .Lfunc_end529-.Lswap2_1_asm_h
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
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.Lfunc_end530:
	.size	.Lrot3l_1_asm_h, .Lfunc_end530-.Lrot3l_1_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end531:
	.size	.Lrot3r_1_asm_h, .Lfunc_end531-.Lrot3r_1_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end532:
	.size	.Lrot4l_1_asm_h, .Lfunc_end532-.Lrot4l_1_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end533:
	.size	.Lrot5l_1_asm_h, .Lfunc_end533-.Lrot5l_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function tail_call_1_asm_h
	.type	.Ltail_call_1_asm_h,@function
.Ltail_call_1_asm_h:                    // @tail_call_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ltail_call_0_asm_h
.Lfunc_end534:
	.size	.Ltail_call_1_asm_h, .Lfunc_end534-.Ltail_call_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function tail_call_method_1_asm_h
	.type	.Ltail_call_method_1_asm_h,@function
.Ltail_call_method_1_asm_h:             // @tail_call_method_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ltail_call_method_0_asm_h
.Lfunc_end535:
	.size	.Ltail_call_method_1_asm_h, .Lfunc_end535-.Ltail_call_method_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function apply_1_asm_h
	.type	.Lapply_1_asm_h,@function
.Lapply_1_asm_h:                        // @apply_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lapply_0_asm_h
.Lfunc_end536:
	.size	.Lapply_1_asm_h, .Lfunc_end536-.Lapply_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_ctor_return_1_asm_h
	.type	.Lcheck_ctor_return_1_asm_h,@function
.Lcheck_ctor_return_1_asm_h:            // @check_ctor_return_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcheck_ctor_return_0_asm_h
.Lfunc_end537:
	.size	.Lcheck_ctor_return_1_asm_h, .Lfunc_end537-.Lcheck_ctor_return_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_ctor_1_asm_h
	.type	.Lcheck_ctor_1_asm_h,@function
.Lcheck_ctor_1_asm_h:                   // @check_ctor_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcheck_ctor_0_asm_h
.Lfunc_end538:
	.size	.Lcheck_ctor_1_asm_h, .Lfunc_end538-.Lcheck_ctor_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_brand_1_asm_h
	.type	.Lcheck_brand_1_asm_h,@function
.Lcheck_brand_1_asm_h:                  // @check_brand_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcheck_brand_0_asm_h
.Lfunc_end539:
	.size	.Lcheck_brand_1_asm_h, .Lfunc_end539-.Lcheck_brand_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_brand_1_asm_h
	.type	.Ladd_brand_1_asm_h,@function
.Ladd_brand_1_asm_h:                    // @add_brand_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ladd_brand_0_asm_h
.Lfunc_end540:
	.size	.Ladd_brand_1_asm_h, .Lfunc_end540-.Ladd_brand_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_async_1_asm_h
	.type	.Lreturn_async_1_asm_h,@function
.Lreturn_async_1_asm_h:                 // @return_async_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lreturn_async_0_asm_h
.Lfunc_end541:
	.size	.Lreturn_async_1_asm_h, .Lfunc_end541-.Lreturn_async_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function throw_1_asm_h
	.type	.Lthrow_1_asm_h,@function
.Lthrow_1_asm_h:                        // @throw_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lthrow_0_asm_h
.Lfunc_end542:
	.size	.Lthrow_1_asm_h, .Lfunc_end542-.Lthrow_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function throw_var_1_asm_h
	.type	.Lthrow_var_1_asm_h,@function
.Lthrow_var_1_asm_h:                    // @throw_var_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lthrow_var_0_asm_h
.Lfunc_end543:
	.size	.Lthrow_var_1_asm_h, .Lfunc_end543-.Lthrow_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function eval_1_asm_h
	.type	.Leval_1_asm_h,@function
.Leval_1_asm_h:                         // @eval_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Leval_0_asm_h
.Lfunc_end544:
	.size	.Leval_1_asm_h, .Lfunc_end544-.Leval_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function regexp_1_asm_h
	.type	.Lregexp_1_asm_h,@function
.Lregexp_1_asm_h:                       // @regexp_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lregexp_0_asm_h
.Lfunc_end545:
	.size	.Lregexp_1_asm_h, .Lfunc_end545-.Lregexp_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_super_ctor_1_asm_h
	.type	.Lget_super_ctor_1_asm_h,@function
.Lget_super_ctor_1_asm_h:               // @get_super_ctor_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lget_super_ctor_0_asm_h
.Lfunc_end546:
	.size	.Lget_super_ctor_1_asm_h, .Lfunc_end546-.Lget_super_ctor_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_super_1_asm_h
	.type	.Lget_super_1_asm_h,@function
.Lget_super_1_asm_h:                    // @get_super_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lget_super_0_asm_h
.Lfunc_end547:
	.size	.Lget_super_1_asm_h, .Lfunc_end547-.Lget_super_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function import_1_asm_h
	.type	.Limport_1_asm_h,@function
.Limport_1_asm_h:                       // @import_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Limport_0_asm_h
.Lfunc_end548:
	.size	.Limport_1_asm_h, .Lfunc_end548-.Limport_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_var_1_asm_h
	.type	.Lcheck_var_1_asm_h,@function
.Lcheck_var_1_asm_h:                    // @check_var_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcheck_var_0_asm_h
.Lfunc_end549:
	.size	.Lcheck_var_1_asm_h, .Lfunc_end549-.Lcheck_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_init_1_asm_h
	.type	.Lput_var_init_1_asm_h,@function
.Lput_var_init_1_asm_h:                 // @put_var_init_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lput_var_init_0_asm_h
.Lfunc_end550:
	.size	.Lput_var_init_1_asm_h, .Lfunc_end550-.Lput_var_init_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_strict_1_asm_h
	.type	.Lput_var_strict_1_asm_h,@function
.Lput_var_strict_1_asm_h:               // @put_var_strict_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lput_var_strict_0_asm_h
.Lfunc_end551:
	.size	.Lput_var_strict_1_asm_h, .Lfunc_end551-.Lput_var_strict_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_ref_value_1_asm_h
	.type	.Lget_ref_value_1_asm_h,@function
.Lget_ref_value_1_asm_h:                // @get_ref_value_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lget_ref_value_0_asm_h
.Lfunc_end552:
	.size	.Lget_ref_value_1_asm_h, .Lfunc_end552-.Lget_ref_value_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_ref_value_1_asm_h
	.type	.Lput_ref_value_1_asm_h,@function
.Lput_ref_value_1_asm_h:                // @put_ref_value_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lput_ref_value_0_asm_h
.Lfunc_end553:
	.size	.Lput_ref_value_1_asm_h, .Lfunc_end553-.Lput_ref_value_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_var_1_asm_h
	.type	.Ldefine_var_1_asm_h,@function
.Ldefine_var_1_asm_h:                   // @define_var_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ldefine_var_0_asm_h
.Lfunc_end554:
	.size	.Ldefine_var_1_asm_h, .Lfunc_end554-.Ldefine_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_define_var_1_asm_h
	.type	.Lcheck_define_var_1_asm_h,@function
.Lcheck_define_var_1_asm_h:             // @check_define_var_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcheck_define_var_0_asm_h
.Lfunc_end555:
	.size	.Lcheck_define_var_1_asm_h, .Lfunc_end555-.Lcheck_define_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_func_1_asm_h
	.type	.Ldefine_func_1_asm_h,@function
.Ldefine_func_1_asm_h:                  // @define_func_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ldefine_func_0_asm_h
.Lfunc_end556:
	.size	.Ldefine_func_1_asm_h, .Lfunc_end556-.Ldefine_func_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_private_field_1_asm_h
	.type	.Lget_private_field_1_asm_h,@function
.Lget_private_field_1_asm_h:            // @get_private_field_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lget_private_field_0_asm_h
.Lfunc_end557:
	.size	.Lget_private_field_1_asm_h, .Lfunc_end557-.Lget_private_field_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_private_field_1_asm_h
	.type	.Lput_private_field_1_asm_h,@function
.Lput_private_field_1_asm_h:            // @put_private_field_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lput_private_field_0_asm_h
.Lfunc_end558:
	.size	.Lput_private_field_1_asm_h, .Lfunc_end558-.Lput_private_field_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_private_field_1_asm_h
	.type	.Ldefine_private_field_1_asm_h,@function
.Ldefine_private_field_1_asm_h:         // @define_private_field_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ldefine_private_field_0_asm_h
.Lfunc_end559:
	.size	.Ldefine_private_field_1_asm_h, .Lfunc_end559-.Ldefine_private_field_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_super_value_1_asm_h
	.type	.Lget_super_value_1_asm_h,@function
.Lget_super_value_1_asm_h:              // @get_super_value_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lget_super_value_0_asm_h
.Lfunc_end560:
	.size	.Lget_super_value_1_asm_h, .Lfunc_end560-.Lget_super_value_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_super_value_1_asm_h
	.type	.Lput_super_value_1_asm_h,@function
.Lput_super_value_1_asm_h:              // @put_super_value_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lput_super_value_0_asm_h
.Lfunc_end561:
	.size	.Lput_super_value_1_asm_h, .Lfunc_end561-.Lput_super_value_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_field_1_asm_h
	.type	.Ldefine_field_1_asm_h,@function
.Ldefine_field_1_asm_h:                 // @define_field_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ldefine_field_0_asm_h
.Lfunc_end562:
	.size	.Ldefine_field_1_asm_h, .Lfunc_end562-.Ldefine_field_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_name_1_asm_h
	.type	.Lset_name_1_asm_h,@function
.Lset_name_1_asm_h:                     // @set_name_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lset_name_0_asm_h
.Lfunc_end563:
	.size	.Lset_name_1_asm_h, .Lfunc_end563-.Lset_name_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_name_computed_1_asm_h
	.type	.Lset_name_computed_1_asm_h,@function
.Lset_name_computed_1_asm_h:            // @set_name_computed_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lset_name_computed_0_asm_h
.Lfunc_end564:
	.size	.Lset_name_computed_1_asm_h, .Lfunc_end564-.Lset_name_computed_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_proto_1_asm_h
	.type	.Lset_proto_1_asm_h,@function
.Lset_proto_1_asm_h:                    // @set_proto_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lset_proto_0_asm_h
.Lfunc_end565:
	.size	.Lset_proto_1_asm_h, .Lfunc_end565-.Lset_proto_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_home_object_1_asm_h
	.type	.Lset_home_object_1_asm_h,@function
.Lset_home_object_1_asm_h:              // @set_home_object_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lset_home_object_0_asm_h
.Lfunc_end566:
	.size	.Lset_home_object_1_asm_h, .Lfunc_end566-.Lset_home_object_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_array_el_1_asm_h
	.type	.Ldefine_array_el_1_asm_h,@function
.Ldefine_array_el_1_asm_h:              // @define_array_el_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ldefine_array_el_0_asm_h
.Lfunc_end567:
	.size	.Ldefine_array_el_1_asm_h, .Lfunc_end567-.Ldefine_array_el_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function append_1_asm_h
	.type	.Lappend_1_asm_h,@function
.Lappend_1_asm_h:                       // @append_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lappend_0_asm_h
.Lfunc_end568:
	.size	.Lappend_1_asm_h, .Lfunc_end568-.Lappend_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function copy_data_properties_1_asm_h
	.type	.Lcopy_data_properties_1_asm_h,@function
.Lcopy_data_properties_1_asm_h:         // @copy_data_properties_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcopy_data_properties_0_asm_h
.Lfunc_end569:
	.size	.Lcopy_data_properties_1_asm_h, .Lfunc_end569-.Lcopy_data_properties_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_method_1_asm_h
	.type	.Ldefine_method_1_asm_h,@function
.Ldefine_method_1_asm_h:                // @define_method_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ldefine_method_0_asm_h
.Lfunc_end570:
	.size	.Ldefine_method_1_asm_h, .Lfunc_end570-.Ldefine_method_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_method_computed_1_asm_h
	.type	.Ldefine_method_computed_1_asm_h,@function
.Ldefine_method_computed_1_asm_h:       // @define_method_computed_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ldefine_method_computed_0_asm_h
.Lfunc_end571:
	.size	.Ldefine_method_computed_1_asm_h, .Lfunc_end571-.Ldefine_method_computed_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_class_1_asm_h
	.type	.Ldefine_class_1_asm_h,@function
.Ldefine_class_1_asm_h:                 // @define_class_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ldefine_class_0_asm_h
.Lfunc_end572:
	.size	.Ldefine_class_1_asm_h, .Lfunc_end572-.Ldefine_class_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc_1_asm_h
	.type	.Lget_loc_1_asm_h,@function
.Lget_loc_1_asm_h:                      // @get_loc_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	x8, x25, x8, lsl #3
	ldr	x21, [x27, x9, lsl #3]
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end573:
	.size	.Lget_loc_1_asm_h, .Lfunc_end573-.Lget_loc_1_asm_h
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
.Lfunc_end574:
	.size	.Lput_loc_1_asm_h, .Lfunc_end574-.Lput_loc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc_1_asm_h
	.type	.Lset_loc_1_asm_h,@function
.Lset_loc_1_asm_h:                      // @set_loc_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end575:
	.size	.Lset_loc_1_asm_h, .Lfunc_end575-.Lset_loc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg_1_asm_h
	.type	.Lget_arg_1_asm_h,@function
.Lget_arg_1_asm_h:                      // @get_arg_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	x8, x25, x8, lsl #3
	ldr	x21, [x28, x9, lsl #3]
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end576:
	.size	.Lget_arg_1_asm_h, .Lfunc_end576-.Lget_arg_1_asm_h
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
.Lfunc_end577:
	.size	.Lput_arg_1_asm_h, .Lfunc_end577-.Lput_arg_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg_1_asm_h
	.type	.Lset_arg_1_asm_h,@function
.Lset_arg_1_asm_h:                      // @set_arg_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end578:
	.size	.Lset_arg_1_asm_h, .Lfunc_end578-.Lset_arg_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref_1_asm_h
	.type	.Lget_var_ref_1_asm_h,@function
.Lget_var_ref_1_asm_h:                  // @get_var_ref_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x8, [x26, x8, lsl #3]
	add	x9, x25, x9, lsl #3
	ldr	x8, [x8]
	ldr	x1, [x9, #3888]
	ldr	x21, [x8]
	br	x1
.Lfunc_end579:
	.size	.Lget_var_ref_1_asm_h, .Lfunc_end579-.Lget_var_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_1_asm_h
	.type	.Lput_var_ref_1_asm_h,@function
.Lput_var_ref_1_asm_h:                  // @put_var_ref_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end580:
	.size	.Lput_var_ref_1_asm_h, .Lfunc_end580-.Lput_var_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref_1_asm_h
	.type	.Lset_var_ref_1_asm_h,@function
.Lset_var_ref_1_asm_h:                  // @set_var_ref_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end581:
	.size	.Lset_var_ref_1_asm_h, .Lfunc_end581-.Lset_var_ref_1_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end582:
	.size	.Lset_loc_uninitialized_1_asm_h, .Lfunc_end582-.Lset_loc_uninitialized_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc_check_1_asm_h
	.type	.Lget_loc_check_1_asm_h,@function
.Lget_loc_check_1_asm_h:                // @get_loc_check_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	.LBB583_2
// %bb.1:                               // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x21, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB583_2:                              // %B3
	str	x22, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end583:
	.size	.Lget_loc_check_1_asm_h, .Lfunc_end583-.Lget_loc_check_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc_check_1_asm_h
	.type	.Lput_loc_check_1_asm_h,@function
.Lput_loc_check_1_asm_h:                // @put_loc_check_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	.LBB584_2
// %bb.1:                               // %B4
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB584_2:                              // %B3
	str	x22, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end584:
	.size	.Lput_loc_check_1_asm_h, .Lfunc_end584-.Lput_loc_check_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc_check_init_1_asm_h
	.type	.Lput_loc_check_init_1_asm_h,@function
.Lput_loc_check_init_1_asm_h:           // @put_loc_check_init_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	.LBB585_2
// %bb.1:                               // %B4
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB585_2:                              // %B3
	str	x22, [x20], #8
	b	.LThrowThisReferenceError_asm_h
.Lfunc_end585:
	.size	.Lput_loc_check_init_1_asm_h, .Lfunc_end585-.Lput_loc_check_init_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref_check_1_asm_h
	.type	.Lget_var_ref_check_1_asm_h,@function
.Lget_var_ref_check_1_asm_h:            // @get_var_ref_check_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB586_2
// %bb.1:                               // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x21, x8
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.LBB586_2:                              // %B3
	str	x22, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end586:
	.size	.Lget_var_ref_check_1_asm_h, .Lfunc_end586-.Lget_var_ref_check_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_check_1_asm_h
	.type	.Lput_var_ref_check_1_asm_h,@function
.Lput_var_ref_check_1_asm_h:            // @put_var_ref_check_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	.LBB587_2
// %bb.1:                               // %B4
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB587_2:                              // %B3
	str	x22, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end587:
	.size	.Lput_var_ref_check_1_asm_h, .Lfunc_end587-.Lput_var_ref_check_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_check_init_1_asm_h
	.type	.Lput_var_ref_check_init_1_asm_h,@function
.Lput_var_ref_check_init_1_asm_h:       // @put_var_ref_check_init_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	.LBB588_2
// %bb.1:                               // %B4
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB588_2:                              // %B3
	str	x22, [x20], #8
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end588:
	.size	.Lput_var_ref_check_init_1_asm_h, .Lfunc_end588-.Lput_var_ref_check_init_1_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end589:
	.size	.Lclose_loc_1_asm_h, .Lfunc_end589-.Lclose_loc_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function catch_1_asm_h
	.type	.Lcatch_1_asm_h,@function
.Lcatch_1_asm_h:                        // @catch_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lcatch_0_asm_h
.Lfunc_end590:
	.size	.Lcatch_1_asm_h, .Lfunc_end590-.Lcatch_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gosub_1_asm_h
	.type	.Lgosub_1_asm_h,@function
.Lgosub_1_asm_h:                        // @gosub_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lgosub_0_asm_h
.Lfunc_end591:
	.size	.Lgosub_1_asm_h, .Lfunc_end591-.Lgosub_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function ret_1_asm_h
	.type	.Lret_1_asm_h,@function
.Lret_1_asm_h:                          // @ret_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lret_0_asm_h
.Lfunc_end592:
	.size	.Lret_1_asm_h, .Lfunc_end592-.Lret_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_object_1_asm_h
	.type	.Lto_object_1_asm_h,@function
.Lto_object_1_asm_h:                    // @to_object_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lto_object_0_asm_h
.Lfunc_end593:
	.size	.Lto_object_1_asm_h, .Lfunc_end593-.Lto_object_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_propkey_1_asm_h
	.type	.Lto_propkey_1_asm_h,@function
.Lto_propkey_1_asm_h:                   // @to_propkey_1_asm_h
// %bb.0:                               // %B15
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	.LBB594_3
// %bb.1:                               // %B15
	and	x8, x22, #0xffff000000000003
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	add	x9, x8, x9
	cmp	x9, #2
	b.lo	.LBB594_3
// %bb.2:                               // %B15
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB594_4
.LBB594_3:                              // %B3
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB594_4:                              // %B12
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	.LBB594_6
// %bb.5:                               // %B14
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB594_6:                              // %B13
	b	.Lexception_spill_top0_asm_h
.Lfunc_end594:
	.size	.Lto_propkey_1_asm_h, .Lfunc_end594-.Lto_propkey_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_propkey2_1_asm_h
	.type	.Lto_propkey2_1_asm_h,@function
.Lto_propkey2_1_asm_h:                  // @to_propkey2_1_asm_h
// %bb.0:                               // %B18
	mov	x21, x22
	ldur	x22, [x20, #-8]
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB595_5
// %bb.1:                               // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB595_4
// %bb.2:                               // %B2
	and	x8, x21, #0xffff000000000003
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	add	x9, x8, x9
	cmp	x9, #2
	b.lo	.LBB595_4
// %bb.3:                               // %B2
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB595_7
.LBB595_4:                              // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB595_5:                              // %B19
	mov	x8, x20
	adrp	x1, .L__unnamed_12
	add	x1, x1, :lo12:.L__unnamed_12
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	LEPUS_ThrowTypeError
.LBB595_6:                              // %B16
	b	.Lexception_spill_top1_asm_h
.LBB595_7:                              // %B15
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	.LBB595_6
// %bb.8:                               // %B17
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end595:
	.size	.Lto_propkey2_1_asm_h, .Lfunc_end595-.Lto_propkey2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_get_var_1_asm_h
	.type	.Lwith_get_var_1_asm_h,@function
.Lwith_get_var_1_asm_h:                 // @with_get_var_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lwith_get_var_0_asm_h
.Lfunc_end596:
	.size	.Lwith_get_var_1_asm_h, .Lfunc_end596-.Lwith_get_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_put_var_1_asm_h
	.type	.Lwith_put_var_1_asm_h,@function
.Lwith_put_var_1_asm_h:                 // @with_put_var_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lwith_put_var_0_asm_h
.Lfunc_end597:
	.size	.Lwith_put_var_1_asm_h, .Lfunc_end597-.Lwith_put_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_delete_var_1_asm_h
	.type	.Lwith_delete_var_1_asm_h,@function
.Lwith_delete_var_1_asm_h:              // @with_delete_var_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lwith_delete_var_0_asm_h
.Lfunc_end598:
	.size	.Lwith_delete_var_1_asm_h, .Lfunc_end598-.Lwith_delete_var_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_make_ref_1_asm_h
	.type	.Lwith_make_ref_1_asm_h,@function
.Lwith_make_ref_1_asm_h:                // @with_make_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lwith_make_ref_0_asm_h
.Lfunc_end599:
	.size	.Lwith_make_ref_1_asm_h, .Lfunc_end599-.Lwith_make_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_get_ref_1_asm_h
	.type	.Lwith_get_ref_1_asm_h,@function
.Lwith_get_ref_1_asm_h:                 // @with_get_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lwith_get_ref_0_asm_h
.Lfunc_end600:
	.size	.Lwith_get_ref_1_asm_h, .Lfunc_end600-.Lwith_get_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_get_ref_undef_1_asm_h
	.type	.Lwith_get_ref_undef_1_asm_h,@function
.Lwith_get_ref_undef_1_asm_h:           // @with_get_ref_undef_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lwith_get_ref_undef_0_asm_h
.Lfunc_end601:
	.size	.Lwith_get_ref_undef_1_asm_h, .Lfunc_end601-.Lwith_get_ref_undef_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_loc_ref_1_asm_h
	.type	.Lmake_loc_ref_1_asm_h,@function
.Lmake_loc_ref_1_asm_h:                 // @make_loc_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lmake_loc_ref_0_asm_h
.Lfunc_end602:
	.size	.Lmake_loc_ref_1_asm_h, .Lfunc_end602-.Lmake_loc_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_arg_ref_1_asm_h
	.type	.Lmake_arg_ref_1_asm_h,@function
.Lmake_arg_ref_1_asm_h:                 // @make_arg_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lmake_arg_ref_0_asm_h
.Lfunc_end603:
	.size	.Lmake_arg_ref_1_asm_h, .Lfunc_end603-.Lmake_arg_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_var_ref_ref_1_asm_h
	.type	.Lmake_var_ref_ref_1_asm_h,@function
.Lmake_var_ref_ref_1_asm_h:             // @make_var_ref_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lmake_var_ref_ref_0_asm_h
.Lfunc_end604:
	.size	.Lmake_var_ref_ref_1_asm_h, .Lfunc_end604-.Lmake_var_ref_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_var_ref_1_asm_h
	.type	.Lmake_var_ref_1_asm_h,@function
.Lmake_var_ref_1_asm_h:                 // @make_var_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lmake_var_ref_0_asm_h
.Lfunc_end605:
	.size	.Lmake_var_ref_1_asm_h, .Lfunc_end605-.Lmake_var_ref_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_in_start_1_asm_h
	.type	.Lfor_in_start_1_asm_h,@function
.Lfor_in_start_1_asm_h:                 // @for_in_start_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lfor_in_start_0_asm_h
.Lfunc_end606:
	.size	.Lfor_in_start_1_asm_h, .Lfunc_end606-.Lfor_in_start_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_of_start_1_asm_h
	.type	.Lfor_of_start_1_asm_h,@function
.Lfor_of_start_1_asm_h:                 // @for_of_start_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lfor_of_start_0_asm_h
.Lfunc_end607:
	.size	.Lfor_of_start_1_asm_h, .Lfunc_end607-.Lfor_of_start_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_await_of_start_1_asm_h
	.type	.Lfor_await_of_start_1_asm_h,@function
.Lfor_await_of_start_1_asm_h:           // @for_await_of_start_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lfor_await_of_start_0_asm_h
.Lfunc_end608:
	.size	.Lfor_await_of_start_1_asm_h, .Lfunc_end608-.Lfor_await_of_start_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_in_next_1_asm_h
	.type	.Lfor_in_next_1_asm_h,@function
.Lfor_in_next_1_asm_h:                  // @for_in_next_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lfor_in_next_0_asm_h
.Lfunc_end609:
	.size	.Lfor_in_next_1_asm_h, .Lfunc_end609-.Lfor_in_next_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_of_next_1_asm_h
	.type	.Lfor_of_next_1_asm_h,@function
.Lfor_of_next_1_asm_h:                  // @for_of_next_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lfor_of_next_0_asm_h
.Lfunc_end610:
	.size	.Lfor_of_next_1_asm_h, .Lfunc_end610-.Lfor_of_next_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_await_of_next_1_asm_h
	.type	.Lfor_await_of_next_1_asm_h,@function
.Lfor_await_of_next_1_asm_h:            // @for_await_of_next_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lfor_await_of_next_0_asm_h
.Lfunc_end611:
	.size	.Lfor_await_of_next_1_asm_h, .Lfunc_end611-.Lfor_await_of_next_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_get_value_done_1_asm_h
	.type	.Literator_get_value_done_1_asm_h,@function
.Literator_get_value_done_1_asm_h:      // @iterator_get_value_done_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Literator_get_value_done_0_asm_h
.Lfunc_end612:
	.size	.Literator_get_value_done_1_asm_h, .Lfunc_end612-.Literator_get_value_done_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_close_1_asm_h
	.type	.Literator_close_1_asm_h,@function
.Literator_close_1_asm_h:               // @iterator_close_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Literator_close_0_asm_h
.Lfunc_end613:
	.size	.Literator_close_1_asm_h, .Lfunc_end613-.Literator_close_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_close_return_1_asm_h
	.type	.Literator_close_return_1_asm_h,@function
.Literator_close_return_1_asm_h:        // @iterator_close_return_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Literator_close_return_0_asm_h
.Lfunc_end614:
	.size	.Literator_close_return_1_asm_h, .Lfunc_end614-.Literator_close_return_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_iterator_close_1_asm_h
	.type	.Lasync_iterator_close_1_asm_h,@function
.Lasync_iterator_close_1_asm_h:         // @async_iterator_close_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lasync_iterator_close_0_asm_h
.Lfunc_end615:
	.size	.Lasync_iterator_close_1_asm_h, .Lfunc_end615-.Lasync_iterator_close_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_iterator_next_1_asm_h
	.type	.Lasync_iterator_next_1_asm_h,@function
.Lasync_iterator_next_1_asm_h:          // @async_iterator_next_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lasync_iterator_next_0_asm_h
.Lfunc_end616:
	.size	.Lasync_iterator_next_1_asm_h, .Lfunc_end616-.Lasync_iterator_next_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_iterator_get_1_asm_h
	.type	.Lasync_iterator_get_1_asm_h,@function
.Lasync_iterator_get_1_asm_h:           // @async_iterator_get_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lasync_iterator_get_0_asm_h
.Lfunc_end617:
	.size	.Lasync_iterator_get_1_asm_h, .Lfunc_end617-.Lasync_iterator_get_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function initial_yield_1_asm_h
	.type	.Linitial_yield_1_asm_h,@function
.Linitial_yield_1_asm_h:                // @initial_yield_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Linitial_yield_0_asm_h
.Lfunc_end618:
	.size	.Linitial_yield_1_asm_h, .Lfunc_end618-.Linitial_yield_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function yield_1_asm_h
	.type	.Lyield_1_asm_h,@function
.Lyield_1_asm_h:                        // @yield_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lyield_0_asm_h
.Lfunc_end619:
	.size	.Lyield_1_asm_h, .Lfunc_end619-.Lyield_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function yield_star_1_asm_h
	.type	.Lyield_star_1_asm_h,@function
.Lyield_star_1_asm_h:                   // @yield_star_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lyield_star_0_asm_h
.Lfunc_end620:
	.size	.Lyield_star_1_asm_h, .Lfunc_end620-.Lyield_star_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_yield_star_1_asm_h
	.type	.Lasync_yield_star_1_asm_h,@function
.Lasync_yield_star_1_asm_h:             // @async_yield_star_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lasync_yield_star_0_asm_h
.Lfunc_end621:
	.size	.Lasync_yield_star_1_asm_h, .Lfunc_end621-.Lasync_yield_star_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function await_1_asm_h
	.type	.Lawait_1_asm_h,@function
.Lawait_1_asm_h:                        // @await_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Lawait_0_asm_h
.Lfunc_end622:
	.size	.Lawait_1_asm_h, .Lfunc_end622-.Lawait_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function plus_1_asm_h
	.type	.Lplus_1_asm_h,@function
.Lplus_1_asm_h:                         // @plus_1_asm_h
// %bb.0:                               // %B9
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB623_2
.LBB623_1:                              // %B3
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB623_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842624          // =0xfffc000000000000
	add	x8, x22, x8
	cmp	x8, x9
	b.lo	.LBB623_1
// %bb.3:                               // %B6
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        // =0x8d
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB623_5
// %bb.4:                               // %B8
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB623_5:                              // %B7
	b	.Lexception_spill_top0_asm_h
.Lfunc_end623:
	.size	.Lplus_1_asm_h, .Lfunc_end623-.Lplus_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function delete_1_asm_h
	.type	.Ldelete_1_asm_h,@function
.Ldelete_1_asm_h:                       // @delete_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ldelete_0_asm_h
.Lfunc_end624:
	.size	.Ldelete_1_asm_h, .Lfunc_end624-.Ldelete_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function delete_var_1_asm_h
	.type	.Ldelete_var_1_asm_h,@function
.Ldelete_var_1_asm_h:                   // @delete_var_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Ldelete_var_0_asm_h
.Lfunc_end625:
	.size	.Ldelete_var_1_asm_h, .Lfunc_end625-.Ldelete_var_1_asm_h
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
	b.eq	.LBB626_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB626_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end626:
	.size	.Lpow_1_asm_h, .Lfunc_end626-.Lpow_1_asm_h
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
	b.eq	.LBB627_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB627_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end627:
	.size	.Linstanceof_1_asm_h, .Lfunc_end627-.Linstanceof_1_asm_h
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
	b.eq	.LBB628_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB628_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end628:
	.size	.Lin_1_asm_h, .Lfunc_end628-.Lin_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nop_1_asm_h
	.type	.Lnop_1_asm_h,@function
.Lnop_1_asm_h:                          // @nop_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end629:
	.size	.Lnop_1_asm_h, .Lfunc_end629-.Lnop_1_asm_h
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
	b.eq	.LBB630_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB630_2:                              // %B2
	b	.Lexception_spill_top0_asm_h
.Lfunc_end630:
	.size	.Lpush_empty_string_1_asm_h, .Lfunc_end630-.Lpush_empty_string_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg0_1_asm_h
	.type	.Lset_arg0_1_asm_h,@function
.Lset_arg0_1_asm_h:                     // @set_arg0_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end631:
	.size	.Lset_arg0_1_asm_h, .Lfunc_end631-.Lset_arg0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg1_1_asm_h
	.type	.Lset_arg1_1_asm_h,@function
.Lset_arg1_1_asm_h:                     // @set_arg1_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end632:
	.size	.Lset_arg1_1_asm_h, .Lfunc_end632-.Lset_arg1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg2_1_asm_h
	.type	.Lset_arg2_1_asm_h,@function
.Lset_arg2_1_asm_h:                     // @set_arg2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end633:
	.size	.Lset_arg2_1_asm_h, .Lfunc_end633-.Lset_arg2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg3_1_asm_h
	.type	.Lset_arg3_1_asm_h,@function
.Lset_arg3_1_asm_h:                     // @set_arg3_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end634:
	.size	.Lset_arg3_1_asm_h, .Lfunc_end634-.Lset_arg3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref0_1_asm_h
	.type	.Lset_var_ref0_1_asm_h,@function
.Lset_var_ref0_1_asm_h:                 // @set_var_ref0_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end635:
	.size	.Lset_var_ref0_1_asm_h, .Lfunc_end635-.Lset_var_ref0_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref1_1_asm_h
	.type	.Lset_var_ref1_1_asm_h,@function
.Lset_var_ref1_1_asm_h:                 // @set_var_ref1_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end636:
	.size	.Lset_var_ref1_1_asm_h, .Lfunc_end636-.Lset_var_ref1_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref2_1_asm_h
	.type	.Lset_var_ref2_1_asm_h,@function
.Lset_var_ref2_1_asm_h:                 // @set_var_ref2_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end637:
	.size	.Lset_var_ref2_1_asm_h, .Lfunc_end637-.Lset_var_ref2_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref3_1_asm_h
	.type	.Lset_var_ref3_1_asm_h,@function
.Lset_var_ref3_1_asm_h:                 // @set_var_ref3_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end638:
	.size	.Lset_var_ref3_1_asm_h, .Lfunc_end638-.Lset_var_ref3_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_coverage_1_asm_h
	.type	.Linc_coverage_1_asm_h,@function
.Linc_coverage_1_asm_h:                 // @inc_coverage_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	.Linc_coverage_0_asm_h
.Lfunc_end639:
	.size	.Linc_coverage_1_asm_h, .Lfunc_end639-.Linc_coverage_1_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function invalid_2_asm_h
	.type	.Linvalid_2_asm_h,@function
.Linvalid_2_asm_h:                      // @invalid_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #8]
	adrp	x1, .L__unnamed_13
	add	x1, x1, :lo12:.L__unnamed_13
	mov	x0, x24
	mov	w3, wzr
	ldr	x8, [x8, #32]
	ldr	w8, [x8, #8]
	str	x20, [x23, #48]
	mvn	w8, w8
	add	w2, w8, w19
	bl	LEPUS_ThrowInternalError
	b	.Lexception_asm_h
.Lfunc_end640:
	.size	.Linvalid_2_asm_h, .Lfunc_end640-.Linvalid_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function push_atom_value_2_asm_h
	.type	.Lpush_atom_value_2_asm_h,@function
.Lpush_atom_value_2_asm_h:              // @push_atom_value_2_asm_h
// %bb.0:                               // %B13
	mov	x8, x20
	str	x22, [x20], #8
	ldr	w1, [x19]
	tbnz	w1, #31, .LBB641_5
// %bb.1:                               // %B1
	ldr	x9, [x24, #8]
	ldr	x9, [x9, #64]
	ldr	x9, [x9, x1, lsl #3]
	ldrb	w11, [x9, #7]
	add	x10, x9, #8
	tbnz	w11, #6, .LBB641_4
// %bb.2:                               // %B4
	ldr	w10, [x10]
	lsr	w10, w10, #30
	cmp	w10, #1
	b.ne	.LBB641_5
.LBB641_3:                              // %B7
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	mov	x8, #2                          // =0x2
	movk	x8, #1, lsl #48
	orr	x21, x9, x8
	br	x1
.LBB641_4:                              // %B2
	ldr	x10, [x10]
	ldr	w10, [x10]
	lsr	w10, w10, #30
	cmp	w10, #1
	b.eq	.LBB641_3
.LBB641_5:                              // %B10
	add	x9, x8, #16
	mov	x0, x24
	mov	w2, wzr
	str	x21, [x8, #8]
                                        // kill: def $w1 killed $w1 killed $x1
	str	x9, [x23, #48]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB641_7
// %bb.6:                               // %B12
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB641_7:                              // %B11
	b	.Lexception_spill_top1_asm_h
.Lfunc_end641:
	.size	.Lpush_atom_value_2_asm_h, .Lfunc_end641-.Lpush_atom_value_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function private_symbol_2_asm_h
	.type	.Lprivate_symbol_2_asm_h,@function
.Lprivate_symbol_2_asm_h:               // @private_symbol_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lprivate_symbol_0_asm_h
.Lfunc_end642:
	.size	.Lprivate_symbol_2_asm_h, .Lfunc_end642-.Lprivate_symbol_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function special_object_2_asm_h
	.type	.Lspecial_object_2_asm_h,@function
.Lspecial_object_2_asm_h:               // @special_object_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lspecial_object_0_asm_h
.Lfunc_end643:
	.size	.Lspecial_object_2_asm_h, .Lfunc_end643-.Lspecial_object_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function rest_2_asm_h
	.type	.Lrest_2_asm_h,@function
.Lrest_2_asm_h:                         // @rest_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lrest_0_asm_h
.Lfunc_end644:
	.size	.Lrest_2_asm_h, .Lfunc_end644-.Lrest_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nip1_2_asm_h
	.type	.Lnip1_2_asm_h,@function
.Lnip1_2_asm_h:                         // @nip1_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end645:
	.size	.Lnip1_2_asm_h, .Lfunc_end645-.Lnip1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function dup2_2_asm_h
	.type	.Ldup2_2_asm_h,@function
.Ldup2_2_asm_h:                         // @dup2_2_asm_h
// %bb.0:                               // %B0
	stp	x22, x21, [x20], #16
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end646:
	.size	.Ldup2_2_asm_h, .Lfunc_end646-.Ldup2_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end647:
	.size	.Ldup3_2_asm_h, .Lfunc_end647-.Ldup3_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x2, [x8, #3888]
	br	x2
.Lfunc_end648:
	.size	.Linsert2_2_asm_h, .Lfunc_end648-.Linsert2_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x2, [x8, #3888]
	br	x2
.Lfunc_end649:
	.size	.Linsert3_2_asm_h, .Lfunc_end649-.Linsert3_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x2, [x8, #3888]
	br	x2
.Lfunc_end650:
	.size	.Linsert4_2_asm_h, .Lfunc_end650-.Linsert4_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function perm3_2_asm_h
	.type	.Lperm3_2_asm_h,@function
.Lperm3_2_asm_h:                        // @perm3_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end651:
	.size	.Lperm3_2_asm_h, .Lfunc_end651-.Lperm3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function perm4_2_asm_h
	.type	.Lperm4_2_asm_h,@function
.Lperm4_2_asm_h:                        // @perm4_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x22
	ldp	x9, x22, [x20, #-16]
	stp	x8, x9, [x20, #-16]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end652:
	.size	.Lperm4_2_asm_h, .Lfunc_end652-.Lperm4_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end653:
	.size	.Lperm5_2_asm_h, .Lfunc_end653-.Lperm5_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function swap2_2_asm_h
	.type	.Lswap2_2_asm_h,@function
.Lswap2_2_asm_h:                        // @swap2_2_asm_h
// %bb.0:                               // %B0
	ldp	x8, x9, [x20, #-16]
	stp	x22, x21, [x20, #-16]
	ldrb	w10, [x19], #1
	add	x10, x25, x10, lsl #3
	mov	x22, x8
	mov	x21, x9
	ldr	x1, [x10, #3888]
	br	x1
.Lfunc_end654:
	.size	.Lswap2_2_asm_h, .Lfunc_end654-.Lswap2_2_asm_h
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
	add	x9, x25, x9, lsl #3
	ldr	x1, [x9, #3888]
	br	x1
.Lfunc_end655:
	.size	.Lrot3l_2_asm_h, .Lfunc_end655-.Lrot3l_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end656:
	.size	.Lrot3r_2_asm_h, .Lfunc_end656-.Lrot3r_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end657:
	.size	.Lrot4l_2_asm_h, .Lfunc_end657-.Lrot4l_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end658:
	.size	.Lrot5l_2_asm_h, .Lfunc_end658-.Lrot5l_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function tail_call_2_asm_h
	.type	.Ltail_call_2_asm_h,@function
.Ltail_call_2_asm_h:                    // @tail_call_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ltail_call_0_asm_h
.Lfunc_end659:
	.size	.Ltail_call_2_asm_h, .Lfunc_end659-.Ltail_call_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function tail_call_method_2_asm_h
	.type	.Ltail_call_method_2_asm_h,@function
.Ltail_call_method_2_asm_h:             // @tail_call_method_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ltail_call_method_0_asm_h
.Lfunc_end660:
	.size	.Ltail_call_method_2_asm_h, .Lfunc_end660-.Ltail_call_method_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function apply_2_asm_h
	.type	.Lapply_2_asm_h,@function
.Lapply_2_asm_h:                        // @apply_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lapply_0_asm_h
.Lfunc_end661:
	.size	.Lapply_2_asm_h, .Lfunc_end661-.Lapply_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_ctor_return_2_asm_h
	.type	.Lcheck_ctor_return_2_asm_h,@function
.Lcheck_ctor_return_2_asm_h:            // @check_ctor_return_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcheck_ctor_return_0_asm_h
.Lfunc_end662:
	.size	.Lcheck_ctor_return_2_asm_h, .Lfunc_end662-.Lcheck_ctor_return_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_ctor_2_asm_h
	.type	.Lcheck_ctor_2_asm_h,@function
.Lcheck_ctor_2_asm_h:                   // @check_ctor_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcheck_ctor_0_asm_h
.Lfunc_end663:
	.size	.Lcheck_ctor_2_asm_h, .Lfunc_end663-.Lcheck_ctor_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_brand_2_asm_h
	.type	.Lcheck_brand_2_asm_h,@function
.Lcheck_brand_2_asm_h:                  // @check_brand_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcheck_brand_0_asm_h
.Lfunc_end664:
	.size	.Lcheck_brand_2_asm_h, .Lfunc_end664-.Lcheck_brand_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function add_brand_2_asm_h
	.type	.Ladd_brand_2_asm_h,@function
.Ladd_brand_2_asm_h:                    // @add_brand_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ladd_brand_0_asm_h
.Lfunc_end665:
	.size	.Ladd_brand_2_asm_h, .Lfunc_end665-.Ladd_brand_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function return_async_2_asm_h
	.type	.Lreturn_async_2_asm_h,@function
.Lreturn_async_2_asm_h:                 // @return_async_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lreturn_async_0_asm_h
.Lfunc_end666:
	.size	.Lreturn_async_2_asm_h, .Lfunc_end666-.Lreturn_async_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function throw_2_asm_h
	.type	.Lthrow_2_asm_h,@function
.Lthrow_2_asm_h:                        // @throw_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lthrow_0_asm_h
.Lfunc_end667:
	.size	.Lthrow_2_asm_h, .Lfunc_end667-.Lthrow_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function throw_var_2_asm_h
	.type	.Lthrow_var_2_asm_h,@function
.Lthrow_var_2_asm_h:                    // @throw_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lthrow_var_0_asm_h
.Lfunc_end668:
	.size	.Lthrow_var_2_asm_h, .Lfunc_end668-.Lthrow_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function eval_2_asm_h
	.type	.Leval_2_asm_h,@function
.Leval_2_asm_h:                         // @eval_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Leval_0_asm_h
.Lfunc_end669:
	.size	.Leval_2_asm_h, .Lfunc_end669-.Leval_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function regexp_2_asm_h
	.type	.Lregexp_2_asm_h,@function
.Lregexp_2_asm_h:                       // @regexp_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lregexp_0_asm_h
.Lfunc_end670:
	.size	.Lregexp_2_asm_h, .Lfunc_end670-.Lregexp_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_super_ctor_2_asm_h
	.type	.Lget_super_ctor_2_asm_h,@function
.Lget_super_ctor_2_asm_h:               // @get_super_ctor_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lget_super_ctor_0_asm_h
.Lfunc_end671:
	.size	.Lget_super_ctor_2_asm_h, .Lfunc_end671-.Lget_super_ctor_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_super_2_asm_h
	.type	.Lget_super_2_asm_h,@function
.Lget_super_2_asm_h:                    // @get_super_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lget_super_0_asm_h
.Lfunc_end672:
	.size	.Lget_super_2_asm_h, .Lfunc_end672-.Lget_super_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function import_2_asm_h
	.type	.Limport_2_asm_h,@function
.Limport_2_asm_h:                       // @import_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Limport_0_asm_h
.Lfunc_end673:
	.size	.Limport_2_asm_h, .Lfunc_end673-.Limport_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_var_2_asm_h
	.type	.Lcheck_var_2_asm_h,@function
.Lcheck_var_2_asm_h:                    // @check_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcheck_var_0_asm_h
.Lfunc_end674:
	.size	.Lcheck_var_2_asm_h, .Lfunc_end674-.Lcheck_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_init_2_asm_h
	.type	.Lput_var_init_2_asm_h,@function
.Lput_var_init_2_asm_h:                 // @put_var_init_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lput_var_init_0_asm_h
.Lfunc_end675:
	.size	.Lput_var_init_2_asm_h, .Lfunc_end675-.Lput_var_init_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_strict_2_asm_h
	.type	.Lput_var_strict_2_asm_h,@function
.Lput_var_strict_2_asm_h:               // @put_var_strict_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lput_var_strict_0_asm_h
.Lfunc_end676:
	.size	.Lput_var_strict_2_asm_h, .Lfunc_end676-.Lput_var_strict_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_ref_value_2_asm_h
	.type	.Lget_ref_value_2_asm_h,@function
.Lget_ref_value_2_asm_h:                // @get_ref_value_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lget_ref_value_0_asm_h
.Lfunc_end677:
	.size	.Lget_ref_value_2_asm_h, .Lfunc_end677-.Lget_ref_value_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_ref_value_2_asm_h
	.type	.Lput_ref_value_2_asm_h,@function
.Lput_ref_value_2_asm_h:                // @put_ref_value_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lput_ref_value_0_asm_h
.Lfunc_end678:
	.size	.Lput_ref_value_2_asm_h, .Lfunc_end678-.Lput_ref_value_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_var_2_asm_h
	.type	.Ldefine_var_2_asm_h,@function
.Ldefine_var_2_asm_h:                   // @define_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ldefine_var_0_asm_h
.Lfunc_end679:
	.size	.Ldefine_var_2_asm_h, .Lfunc_end679-.Ldefine_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function check_define_var_2_asm_h
	.type	.Lcheck_define_var_2_asm_h,@function
.Lcheck_define_var_2_asm_h:             // @check_define_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcheck_define_var_0_asm_h
.Lfunc_end680:
	.size	.Lcheck_define_var_2_asm_h, .Lfunc_end680-.Lcheck_define_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_func_2_asm_h
	.type	.Ldefine_func_2_asm_h,@function
.Ldefine_func_2_asm_h:                  // @define_func_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ldefine_func_0_asm_h
.Lfunc_end681:
	.size	.Ldefine_func_2_asm_h, .Lfunc_end681-.Ldefine_func_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_private_field_2_asm_h
	.type	.Lget_private_field_2_asm_h,@function
.Lget_private_field_2_asm_h:            // @get_private_field_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lget_private_field_0_asm_h
.Lfunc_end682:
	.size	.Lget_private_field_2_asm_h, .Lfunc_end682-.Lget_private_field_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_private_field_2_asm_h
	.type	.Lput_private_field_2_asm_h,@function
.Lput_private_field_2_asm_h:            // @put_private_field_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lput_private_field_0_asm_h
.Lfunc_end683:
	.size	.Lput_private_field_2_asm_h, .Lfunc_end683-.Lput_private_field_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_private_field_2_asm_h
	.type	.Ldefine_private_field_2_asm_h,@function
.Ldefine_private_field_2_asm_h:         // @define_private_field_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ldefine_private_field_0_asm_h
.Lfunc_end684:
	.size	.Ldefine_private_field_2_asm_h, .Lfunc_end684-.Ldefine_private_field_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_super_value_2_asm_h
	.type	.Lget_super_value_2_asm_h,@function
.Lget_super_value_2_asm_h:              // @get_super_value_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lget_super_value_0_asm_h
.Lfunc_end685:
	.size	.Lget_super_value_2_asm_h, .Lfunc_end685-.Lget_super_value_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_super_value_2_asm_h
	.type	.Lput_super_value_2_asm_h,@function
.Lput_super_value_2_asm_h:              // @put_super_value_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lput_super_value_0_asm_h
.Lfunc_end686:
	.size	.Lput_super_value_2_asm_h, .Lfunc_end686-.Lput_super_value_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_field_2_asm_h
	.type	.Ldefine_field_2_asm_h,@function
.Ldefine_field_2_asm_h:                 // @define_field_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ldefine_field_0_asm_h
.Lfunc_end687:
	.size	.Ldefine_field_2_asm_h, .Lfunc_end687-.Ldefine_field_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_name_2_asm_h
	.type	.Lset_name_2_asm_h,@function
.Lset_name_2_asm_h:                     // @set_name_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lset_name_0_asm_h
.Lfunc_end688:
	.size	.Lset_name_2_asm_h, .Lfunc_end688-.Lset_name_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_name_computed_2_asm_h
	.type	.Lset_name_computed_2_asm_h,@function
.Lset_name_computed_2_asm_h:            // @set_name_computed_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lset_name_computed_0_asm_h
.Lfunc_end689:
	.size	.Lset_name_computed_2_asm_h, .Lfunc_end689-.Lset_name_computed_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_proto_2_asm_h
	.type	.Lset_proto_2_asm_h,@function
.Lset_proto_2_asm_h:                    // @set_proto_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lset_proto_0_asm_h
.Lfunc_end690:
	.size	.Lset_proto_2_asm_h, .Lfunc_end690-.Lset_proto_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_home_object_2_asm_h
	.type	.Lset_home_object_2_asm_h,@function
.Lset_home_object_2_asm_h:              // @set_home_object_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lset_home_object_0_asm_h
.Lfunc_end691:
	.size	.Lset_home_object_2_asm_h, .Lfunc_end691-.Lset_home_object_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_array_el_2_asm_h
	.type	.Ldefine_array_el_2_asm_h,@function
.Ldefine_array_el_2_asm_h:              // @define_array_el_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ldefine_array_el_0_asm_h
.Lfunc_end692:
	.size	.Ldefine_array_el_2_asm_h, .Lfunc_end692-.Ldefine_array_el_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function append_2_asm_h
	.type	.Lappend_2_asm_h,@function
.Lappend_2_asm_h:                       // @append_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lappend_0_asm_h
.Lfunc_end693:
	.size	.Lappend_2_asm_h, .Lfunc_end693-.Lappend_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function copy_data_properties_2_asm_h
	.type	.Lcopy_data_properties_2_asm_h,@function
.Lcopy_data_properties_2_asm_h:         // @copy_data_properties_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcopy_data_properties_0_asm_h
.Lfunc_end694:
	.size	.Lcopy_data_properties_2_asm_h, .Lfunc_end694-.Lcopy_data_properties_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_method_2_asm_h
	.type	.Ldefine_method_2_asm_h,@function
.Ldefine_method_2_asm_h:                // @define_method_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ldefine_method_0_asm_h
.Lfunc_end695:
	.size	.Ldefine_method_2_asm_h, .Lfunc_end695-.Ldefine_method_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_method_computed_2_asm_h
	.type	.Ldefine_method_computed_2_asm_h,@function
.Ldefine_method_computed_2_asm_h:       // @define_method_computed_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ldefine_method_computed_0_asm_h
.Lfunc_end696:
	.size	.Ldefine_method_computed_2_asm_h, .Lfunc_end696-.Ldefine_method_computed_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function define_class_2_asm_h
	.type	.Ldefine_class_2_asm_h,@function
.Ldefine_class_2_asm_h:                 // @define_class_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ldefine_class_0_asm_h
.Lfunc_end697:
	.size	.Ldefine_class_2_asm_h, .Lfunc_end697-.Ldefine_class_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc_2_asm_h
	.type	.Lget_loc_2_asm_h,@function
.Lget_loc_2_asm_h:                      // @get_loc_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	x8, x25, x8, lsl #3
	ldr	x9, [x27, x9, lsl #3]
	ldr	x1, [x8, #3888]
	mov	x21, x9
	br	x1
.Lfunc_end698:
	.size	.Lget_loc_2_asm_h, .Lfunc_end698-.Lget_loc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc_2_asm_h
	.type	.Lput_loc_2_asm_h,@function
.Lput_loc_2_asm_h:                      // @put_loc_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end699:
	.size	.Lput_loc_2_asm_h, .Lfunc_end699-.Lput_loc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_loc_2_asm_h
	.type	.Lset_loc_2_asm_h,@function
.Lset_loc_2_asm_h:                      // @set_loc_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end700:
	.size	.Lset_loc_2_asm_h, .Lfunc_end700-.Lset_loc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_arg_2_asm_h
	.type	.Lget_arg_2_asm_h,@function
.Lget_arg_2_asm_h:                      // @get_arg_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	x8, x25, x8, lsl #3
	ldr	x9, [x28, x9, lsl #3]
	ldr	x1, [x8, #3888]
	mov	x21, x9
	br	x1
.Lfunc_end701:
	.size	.Lget_arg_2_asm_h, .Lfunc_end701-.Lget_arg_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_arg_2_asm_h
	.type	.Lput_arg_2_asm_h,@function
.Lput_arg_2_asm_h:                      // @put_arg_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x21, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end702:
	.size	.Lput_arg_2_asm_h, .Lfunc_end702-.Lput_arg_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg_2_asm_h
	.type	.Lset_arg_2_asm_h,@function
.Lset_arg_2_asm_h:                      // @set_arg_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x21, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end703:
	.size	.Lset_arg_2_asm_h, .Lfunc_end703-.Lset_arg_2_asm_h
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
	add	x9, x25, x9, lsl #3
	ldr	x8, [x8]
	ldr	x1, [x9, #3888]
	ldr	x8, [x8]
	mov	x21, x8
	br	x1
.Lfunc_end704:
	.size	.Lget_var_ref_2_asm_h, .Lfunc_end704-.Lget_var_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_2_asm_h
	.type	.Lput_var_ref_2_asm_h,@function
.Lput_var_ref_2_asm_h:                  // @put_var_ref_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.Lfunc_end705:
	.size	.Lput_var_ref_2_asm_h, .Lfunc_end705-.Lput_var_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref_2_asm_h
	.type	.Lset_var_ref_2_asm_h,@function
.Lset_var_ref_2_asm_h:                  // @set_var_ref_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end706:
	.size	.Lset_var_ref_2_asm_h, .Lfunc_end706-.Lset_var_ref_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end707:
	.size	.Lset_loc_uninitialized_2_asm_h, .Lfunc_end707-.Lset_loc_uninitialized_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_loc_check_2_asm_h
	.type	.Lget_loc_check_2_asm_h,@function
.Lget_loc_check_2_asm_h:                // @get_loc_check_2_asm_h
// %bb.0:                               // %B2
	mov	x8, x20
	str	x22, [x20], #8
	ldrh	w9, [x19]
	ldr	x9, [x27, x9, lsl #3]
	cmp	x9, #34
	b.eq	.LBB708_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x9
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB708_2:                              // %B3
	add	x20, x8, #16
	str	x21, [x8, #8]
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end708:
	.size	.Lget_loc_check_2_asm_h, .Lfunc_end708-.Lget_loc_check_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc_check_2_asm_h
	.type	.Lput_loc_check_2_asm_h,@function
.Lput_loc_check_2_asm_h:                // @put_loc_check_2_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	.LBB709_2
// %bb.1:                               // %B4
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB709_2:                              // %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end709:
	.size	.Lput_loc_check_2_asm_h, .Lfunc_end709-.Lput_loc_check_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_loc_check_init_2_asm_h
	.type	.Lput_loc_check_init_2_asm_h,@function
.Lput_loc_check_init_2_asm_h:           // @put_loc_check_init_2_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	.LBB710_2
// %bb.1:                               // %B4
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB710_2:                              // %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.LThrowThisReferenceError_asm_h
.Lfunc_end710:
	.size	.Lput_loc_check_init_2_asm_h, .Lfunc_end710-.Lput_loc_check_init_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function get_var_ref_check_2_asm_h
	.type	.Lget_var_ref_check_2_asm_h,@function
.Lget_var_ref_check_2_asm_h:            // @get_var_ref_check_2_asm_h
// %bb.0:                               // %B2
	mov	x8, x20
	str	x22, [x20], #8
	ldrh	w9, [x19]
	ldr	x9, [x26, x9, lsl #3]
	ldr	x9, [x9]
	ldr	x9, [x9]
	cmp	x9, #34
	b.eq	.LBB711_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x9
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB711_2:                              // %B3
	add	x20, x8, #16
	str	x21, [x8, #8]
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end711:
	.size	.Lget_var_ref_check_2_asm_h, .Lfunc_end711-.Lget_var_ref_check_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_check_2_asm_h
	.type	.Lput_var_ref_check_2_asm_h,@function
.Lput_var_ref_check_2_asm_h:            // @put_var_ref_check_2_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	.LBB712_2
// %bb.1:                               // %B4
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB712_2:                              // %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end712:
	.size	.Lput_var_ref_check_2_asm_h, .Lfunc_end712-.Lput_var_ref_check_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function put_var_ref_check_init_2_asm_h
	.type	.Lput_var_ref_check_init_2_asm_h,@function
.Lput_var_ref_check_init_2_asm_h:       // @put_var_ref_check_init_2_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	.LBB713_2
// %bb.1:                               // %B4
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB713_2:                              // %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.LThrowReferenceErrorUninitialized_asm_h
.Lfunc_end713:
	.size	.Lput_var_ref_check_init_2_asm_h, .Lfunc_end713-.Lput_var_ref_check_init_2_asm_h
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
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end714:
	.size	.Lclose_loc_2_asm_h, .Lfunc_end714-.Lclose_loc_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function catch_2_asm_h
	.type	.Lcatch_2_asm_h,@function
.Lcatch_2_asm_h:                        // @catch_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lcatch_0_asm_h
.Lfunc_end715:
	.size	.Lcatch_2_asm_h, .Lfunc_end715-.Lcatch_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function gosub_2_asm_h
	.type	.Lgosub_2_asm_h,@function
.Lgosub_2_asm_h:                        // @gosub_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lgosub_0_asm_h
.Lfunc_end716:
	.size	.Lgosub_2_asm_h, .Lfunc_end716-.Lgosub_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function ret_2_asm_h
	.type	.Lret_2_asm_h,@function
.Lret_2_asm_h:                          // @ret_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lret_0_asm_h
.Lfunc_end717:
	.size	.Lret_2_asm_h, .Lfunc_end717-.Lret_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_object_2_asm_h
	.type	.Lto_object_2_asm_h,@function
.Lto_object_2_asm_h:                    // @to_object_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lto_object_0_asm_h
.Lfunc_end718:
	.size	.Lto_object_2_asm_h, .Lfunc_end718-.Lto_object_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_propkey_2_asm_h
	.type	.Lto_propkey_2_asm_h,@function
.Lto_propkey_2_asm_h:                   // @to_propkey_2_asm_h
// %bb.0:                               // %B15
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB719_3
// %bb.1:                               // %B15
	and	x8, x21, #0xffff000000000003
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	add	x9, x8, x9
	cmp	x9, #2
	b.lo	.LBB719_3
// %bb.2:                               // %B15
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB719_4
.LBB719_3:                              // %B3
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB719_4:                              // %B12
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	.LBB719_6
// %bb.5:                               // %B14
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB719_6:                              // %B13
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end719:
	.size	.Lto_propkey_2_asm_h, .Lfunc_end719-.Lto_propkey_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function to_propkey2_2_asm_h
	.type	.Lto_propkey2_2_asm_h,@function
.Lto_propkey2_2_asm_h:                  // @to_propkey2_2_asm_h
// %bb.0:                               // %B18
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB720_5
// %bb.1:                               // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB720_4
// %bb.2:                               // %B2
	and	x8, x21, #0xffff000000000003
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	add	x9, x8, x9
	cmp	x9, #2
	b.lo	.LBB720_4
// %bb.3:                               // %B2
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB720_7
.LBB720_4:                              // %B4
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB720_5:                              // %B19
	add	x8, x20, #16
	adrp	x1, .L__unnamed_14
	add	x1, x1, :lo12:.L__unnamed_14
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	LEPUS_ThrowTypeError
.LBB720_6:                              // %B16
	b	.Lexception_spill_top0_top1_asm_h
.LBB720_7:                              // %B15
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	.LBB720_6
// %bb.8:                               // %B17
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end720:
	.size	.Lto_propkey2_2_asm_h, .Lfunc_end720-.Lto_propkey2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_get_var_2_asm_h
	.type	.Lwith_get_var_2_asm_h,@function
.Lwith_get_var_2_asm_h:                 // @with_get_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lwith_get_var_0_asm_h
.Lfunc_end721:
	.size	.Lwith_get_var_2_asm_h, .Lfunc_end721-.Lwith_get_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_put_var_2_asm_h
	.type	.Lwith_put_var_2_asm_h,@function
.Lwith_put_var_2_asm_h:                 // @with_put_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lwith_put_var_0_asm_h
.Lfunc_end722:
	.size	.Lwith_put_var_2_asm_h, .Lfunc_end722-.Lwith_put_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_delete_var_2_asm_h
	.type	.Lwith_delete_var_2_asm_h,@function
.Lwith_delete_var_2_asm_h:              // @with_delete_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lwith_delete_var_0_asm_h
.Lfunc_end723:
	.size	.Lwith_delete_var_2_asm_h, .Lfunc_end723-.Lwith_delete_var_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_make_ref_2_asm_h
	.type	.Lwith_make_ref_2_asm_h,@function
.Lwith_make_ref_2_asm_h:                // @with_make_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lwith_make_ref_0_asm_h
.Lfunc_end724:
	.size	.Lwith_make_ref_2_asm_h, .Lfunc_end724-.Lwith_make_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_get_ref_2_asm_h
	.type	.Lwith_get_ref_2_asm_h,@function
.Lwith_get_ref_2_asm_h:                 // @with_get_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lwith_get_ref_0_asm_h
.Lfunc_end725:
	.size	.Lwith_get_ref_2_asm_h, .Lfunc_end725-.Lwith_get_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function with_get_ref_undef_2_asm_h
	.type	.Lwith_get_ref_undef_2_asm_h,@function
.Lwith_get_ref_undef_2_asm_h:           // @with_get_ref_undef_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lwith_get_ref_undef_0_asm_h
.Lfunc_end726:
	.size	.Lwith_get_ref_undef_2_asm_h, .Lfunc_end726-.Lwith_get_ref_undef_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_loc_ref_2_asm_h
	.type	.Lmake_loc_ref_2_asm_h,@function
.Lmake_loc_ref_2_asm_h:                 // @make_loc_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lmake_loc_ref_0_asm_h
.Lfunc_end727:
	.size	.Lmake_loc_ref_2_asm_h, .Lfunc_end727-.Lmake_loc_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_arg_ref_2_asm_h
	.type	.Lmake_arg_ref_2_asm_h,@function
.Lmake_arg_ref_2_asm_h:                 // @make_arg_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lmake_arg_ref_0_asm_h
.Lfunc_end728:
	.size	.Lmake_arg_ref_2_asm_h, .Lfunc_end728-.Lmake_arg_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_var_ref_ref_2_asm_h
	.type	.Lmake_var_ref_ref_2_asm_h,@function
.Lmake_var_ref_ref_2_asm_h:             // @make_var_ref_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lmake_var_ref_ref_0_asm_h
.Lfunc_end729:
	.size	.Lmake_var_ref_ref_2_asm_h, .Lfunc_end729-.Lmake_var_ref_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function make_var_ref_2_asm_h
	.type	.Lmake_var_ref_2_asm_h,@function
.Lmake_var_ref_2_asm_h:                 // @make_var_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lmake_var_ref_0_asm_h
.Lfunc_end730:
	.size	.Lmake_var_ref_2_asm_h, .Lfunc_end730-.Lmake_var_ref_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_in_start_2_asm_h
	.type	.Lfor_in_start_2_asm_h,@function
.Lfor_in_start_2_asm_h:                 // @for_in_start_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lfor_in_start_0_asm_h
.Lfunc_end731:
	.size	.Lfor_in_start_2_asm_h, .Lfunc_end731-.Lfor_in_start_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_of_start_2_asm_h
	.type	.Lfor_of_start_2_asm_h,@function
.Lfor_of_start_2_asm_h:                 // @for_of_start_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lfor_of_start_0_asm_h
.Lfunc_end732:
	.size	.Lfor_of_start_2_asm_h, .Lfunc_end732-.Lfor_of_start_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_await_of_start_2_asm_h
	.type	.Lfor_await_of_start_2_asm_h,@function
.Lfor_await_of_start_2_asm_h:           // @for_await_of_start_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lfor_await_of_start_0_asm_h
.Lfunc_end733:
	.size	.Lfor_await_of_start_2_asm_h, .Lfunc_end733-.Lfor_await_of_start_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_in_next_2_asm_h
	.type	.Lfor_in_next_2_asm_h,@function
.Lfor_in_next_2_asm_h:                  // @for_in_next_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lfor_in_next_0_asm_h
.Lfunc_end734:
	.size	.Lfor_in_next_2_asm_h, .Lfunc_end734-.Lfor_in_next_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_of_next_2_asm_h
	.type	.Lfor_of_next_2_asm_h,@function
.Lfor_of_next_2_asm_h:                  // @for_of_next_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lfor_of_next_0_asm_h
.Lfunc_end735:
	.size	.Lfor_of_next_2_asm_h, .Lfunc_end735-.Lfor_of_next_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function for_await_of_next_2_asm_h
	.type	.Lfor_await_of_next_2_asm_h,@function
.Lfor_await_of_next_2_asm_h:            // @for_await_of_next_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lfor_await_of_next_0_asm_h
.Lfunc_end736:
	.size	.Lfor_await_of_next_2_asm_h, .Lfunc_end736-.Lfor_await_of_next_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_get_value_done_2_asm_h
	.type	.Literator_get_value_done_2_asm_h,@function
.Literator_get_value_done_2_asm_h:      // @iterator_get_value_done_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Literator_get_value_done_0_asm_h
.Lfunc_end737:
	.size	.Literator_get_value_done_2_asm_h, .Lfunc_end737-.Literator_get_value_done_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_close_2_asm_h
	.type	.Literator_close_2_asm_h,@function
.Literator_close_2_asm_h:               // @iterator_close_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Literator_close_0_asm_h
.Lfunc_end738:
	.size	.Literator_close_2_asm_h, .Lfunc_end738-.Literator_close_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function iterator_close_return_2_asm_h
	.type	.Literator_close_return_2_asm_h,@function
.Literator_close_return_2_asm_h:        // @iterator_close_return_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Literator_close_return_0_asm_h
.Lfunc_end739:
	.size	.Literator_close_return_2_asm_h, .Lfunc_end739-.Literator_close_return_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_iterator_close_2_asm_h
	.type	.Lasync_iterator_close_2_asm_h,@function
.Lasync_iterator_close_2_asm_h:         // @async_iterator_close_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lasync_iterator_close_0_asm_h
.Lfunc_end740:
	.size	.Lasync_iterator_close_2_asm_h, .Lfunc_end740-.Lasync_iterator_close_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_iterator_next_2_asm_h
	.type	.Lasync_iterator_next_2_asm_h,@function
.Lasync_iterator_next_2_asm_h:          // @async_iterator_next_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lasync_iterator_next_0_asm_h
.Lfunc_end741:
	.size	.Lasync_iterator_next_2_asm_h, .Lfunc_end741-.Lasync_iterator_next_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_iterator_get_2_asm_h
	.type	.Lasync_iterator_get_2_asm_h,@function
.Lasync_iterator_get_2_asm_h:           // @async_iterator_get_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lasync_iterator_get_0_asm_h
.Lfunc_end742:
	.size	.Lasync_iterator_get_2_asm_h, .Lfunc_end742-.Lasync_iterator_get_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function initial_yield_2_asm_h
	.type	.Linitial_yield_2_asm_h,@function
.Linitial_yield_2_asm_h:                // @initial_yield_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Linitial_yield_0_asm_h
.Lfunc_end743:
	.size	.Linitial_yield_2_asm_h, .Lfunc_end743-.Linitial_yield_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function yield_2_asm_h
	.type	.Lyield_2_asm_h,@function
.Lyield_2_asm_h:                        // @yield_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lyield_0_asm_h
.Lfunc_end744:
	.size	.Lyield_2_asm_h, .Lfunc_end744-.Lyield_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function yield_star_2_asm_h
	.type	.Lyield_star_2_asm_h,@function
.Lyield_star_2_asm_h:                   // @yield_star_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lyield_star_0_asm_h
.Lfunc_end745:
	.size	.Lyield_star_2_asm_h, .Lfunc_end745-.Lyield_star_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function async_yield_star_2_asm_h
	.type	.Lasync_yield_star_2_asm_h,@function
.Lasync_yield_star_2_asm_h:             // @async_yield_star_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lasync_yield_star_0_asm_h
.Lfunc_end746:
	.size	.Lasync_yield_star_2_asm_h, .Lfunc_end746-.Lasync_yield_star_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function await_2_asm_h
	.type	.Lawait_2_asm_h,@function
.Lawait_2_asm_h:                        // @await_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Lawait_0_asm_h
.Lfunc_end747:
	.size	.Lawait_2_asm_h, .Lfunc_end747-.Lawait_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function plus_2_asm_h
	.type	.Lplus_2_asm_h,@function
.Lplus_2_asm_h:                         // @plus_2_asm_h
// %bb.0:                               // %B9
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB748_2
.LBB748_1:                              // %B3
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB748_2:                              // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	mov	x9, #-1125899906842624          // =0xfffc000000000000
	add	x8, x21, x8
	cmp	x8, x9
	b.lo	.LBB748_1
// %bb.3:                               // %B6
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #141                        // =0x8d
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB748_5
// %bb.4:                               // %B8
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB748_5:                              // %B7
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end748:
	.size	.Lplus_2_asm_h, .Lfunc_end748-.Lplus_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function delete_2_asm_h
	.type	.Ldelete_2_asm_h,@function
.Ldelete_2_asm_h:                       // @delete_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ldelete_0_asm_h
.Lfunc_end749:
	.size	.Ldelete_2_asm_h, .Lfunc_end749-.Ldelete_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function delete_var_2_asm_h
	.type	.Ldelete_var_2_asm_h,@function
.Ldelete_var_2_asm_h:                   // @delete_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Ldelete_var_0_asm_h
.Lfunc_end750:
	.size	.Ldelete_var_2_asm_h, .Lfunc_end750-.Ldelete_var_2_asm_h
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
	b.eq	.LBB751_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB751_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end751:
	.size	.Lpow_2_asm_h, .Lfunc_end751-.Lpow_2_asm_h
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
	b.eq	.LBB752_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB752_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end752:
	.size	.Linstanceof_2_asm_h, .Lfunc_end752-.Linstanceof_2_asm_h
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
	b.eq	.LBB753_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #1944]
	br	x1
.LBB753_2:                              // %B2
	b	.Lexception_spill_top0_top1_asm_h
.Lfunc_end753:
	.size	.Lin_2_asm_h, .Lfunc_end753-.Lin_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function nop_2_asm_h
	.type	.Lnop_2_asm_h,@function
.Lnop_2_asm_h:                          // @nop_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end754:
	.size	.Lnop_2_asm_h, .Lfunc_end754-.Lnop_2_asm_h
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
	b.eq	.LBB755_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.LBB755_2:                              // %B2
	b	.Lexception_spill_top1_asm_h
.Lfunc_end755:
	.size	.Lpush_empty_string_2_asm_h, .Lfunc_end755-.Lpush_empty_string_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg0_2_asm_h
	.type	.Lset_arg0_2_asm_h,@function
.Lset_arg0_2_asm_h:                     // @set_arg0_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end756:
	.size	.Lset_arg0_2_asm_h, .Lfunc_end756-.Lset_arg0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg1_2_asm_h
	.type	.Lset_arg1_2_asm_h,@function
.Lset_arg1_2_asm_h:                     // @set_arg1_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end757:
	.size	.Lset_arg1_2_asm_h, .Lfunc_end757-.Lset_arg1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg2_2_asm_h
	.type	.Lset_arg2_2_asm_h,@function
.Lset_arg2_2_asm_h:                     // @set_arg2_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #16]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end758:
	.size	.Lset_arg2_2_asm_h, .Lfunc_end758-.Lset_arg2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_arg3_2_asm_h
	.type	.Lset_arg3_2_asm_h,@function
.Lset_arg3_2_asm_h:                     // @set_arg3_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #24]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end759:
	.size	.Lset_arg3_2_asm_h, .Lfunc_end759-.Lset_arg3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref0_2_asm_h
	.type	.Lset_var_ref0_2_asm_h,@function
.Lset_var_ref0_2_asm_h:                 // @set_var_ref0_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end760:
	.size	.Lset_var_ref0_2_asm_h, .Lfunc_end760-.Lset_var_ref0_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref1_2_asm_h
	.type	.Lset_var_ref1_2_asm_h,@function
.Lset_var_ref1_2_asm_h:                 // @set_var_ref1_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end761:
	.size	.Lset_var_ref1_2_asm_h, .Lfunc_end761-.Lset_var_ref1_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref2_2_asm_h
	.type	.Lset_var_ref2_2_asm_h,@function
.Lset_var_ref2_2_asm_h:                 // @set_var_ref2_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end762:
	.size	.Lset_var_ref2_2_asm_h, .Lfunc_end762-.Lset_var_ref2_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function set_var_ref3_2_asm_h
	.type	.Lset_var_ref3_2_asm_h,@function
.Lset_var_ref3_2_asm_h:                 // @set_var_ref3_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	x8, x25, x8, lsl #3
	ldr	x1, [x8, #3888]
	br	x1
.Lfunc_end763:
	.size	.Lset_var_ref3_2_asm_h, .Lfunc_end763-.Lset_var_ref3_2_asm_h
                                        // -- End function
	.p2align	2                               // -- Begin function inc_coverage_2_asm_h
	.type	.Linc_coverage_2_asm_h,@function
.Linc_coverage_2_asm_h:                 // @inc_coverage_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	.Linc_coverage_0_asm_h
.Lfunc_end764:
	.size	.Linc_coverage_2_asm_h, .Lfunc_end764-.Linc_coverage_2_asm_h
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
.Lfunc_end765:
	.size	_call_stub_entry, .Lfunc_end765-_call_stub_entry
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
	.asciz	"value has no property"
	.size	.L__unnamed_12, 22

	.type	.L__unnamed_13,@object          // @12
	.p2align	3, 0x0
.L__unnamed_13:
	.asciz	"invalid opcode: pc=%u opcode=0x%02x"
	.size	.L__unnamed_13, 36

	.type	.L__unnamed_14,@object          // @13
	.p2align	3, 0x0
.L__unnamed_14:
	.asciz	"value has no property"
	.size	.L__unnamed_14, 22

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
	.size	primjs_dispatch_table, 5832

	.section	".note.GNU-stack","",@progbits
#endif
