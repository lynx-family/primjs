#if defined(__aarch64__) && defined(ENABLE_PRIMJS_SNAPSHOT) && defined(ENABLE_QUICKJS_DEBUGGER)
	.file	"primjs"
	.text
	.hidden	call_native_entry_asm_h         // -- Begin function call_native_entry_asm_h
	.globl	call_native_entry_asm_h
	.p2align	2
	.type	call_native_entry_asm_h,@function
call_native_entry_asm_h:                // @call_native_entry_asm_h
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
	ldr	x9, [x24, #296]
	sub	x8, sp, #176
	cmp	x8, x9
	b.ls	.LBB0_29
// %bb.3:                               // %B15
	mov	x19, sp
	mov	sp, x8
	add	x9, x8, #32
	stp	x23, x22, [x8]
	mov	x28, x20
	stp	x9, x9, [x8, #32]
	mov	x27, xzr
	stp	xzr, xzr, [x8, #64]
	stp	w3, wzr, [x8, #56]
	stp	x20, xzr, [x8, #16]
	stp	x21, xzr, [x8, #80]
	str	wzr, [x8, #96]
	ldr	x9, [x24, #8]
	str	x8, [x9, #240]
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
	str	x23, [x8, #240]
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
	b	ThrowStackOverflow_Return_asm_h
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
	b	ThrowTypeErrorNotFunction_Return_asm_h
.Lfunc_end0:
	.size	call_native_entry_asm_h, .Lfunc_end0-call_native_entry_asm_h
	.cfi_endproc
                                        // -- End function
	.hidden	ThrowTypeErrorNotFunction_Return_asm_h // -- Begin function ThrowTypeErrorNotFunction_Return_asm_h
	.globl	ThrowTypeErrorNotFunction_Return_asm_h
	.p2align	2
	.type	ThrowTypeErrorNotFunction_Return_asm_h,@function
ThrowTypeErrorNotFunction_Return_asm_h: // @ThrowTypeErrorNotFunction_Return_asm_h
// %bb.0:                               // %B0
	mov	x0, x24
	mov	x22, x30
	bl	JS_ThrowTypeErrorNotFunction
	mov	x30, x22
	ret
.Lfunc_end1:
	.size	ThrowTypeErrorNotFunction_Return_asm_h, .Lfunc_end1-ThrowTypeErrorNotFunction_Return_asm_h
                                        // -- End function
	.hidden	ThrowStackOverflow_Return_asm_h // -- Begin function ThrowStackOverflow_Return_asm_h
	.globl	ThrowStackOverflow_Return_asm_h
	.p2align	2
	.type	ThrowStackOverflow_Return_asm_h,@function
ThrowStackOverflow_Return_asm_h:        // @ThrowStackOverflow_Return_asm_h
// %bb.0:                               // %B0
	mov	x0, x24
	mov	x22, x30
	bl	JS_ThrowStackOverflow
	mov	x30, x22
	ret
.Lfunc_end2:
	.size	ThrowStackOverflow_Return_asm_h, .Lfunc_end2-ThrowStackOverflow_Return_asm_h
                                        // -- End function
	.hidden	call_native_asm_h               // -- Begin function call_native_asm_h
	.globl	call_native_asm_h
	.p2align	2
	.type	call_native_asm_h,@function
call_native_asm_h:                      // @call_native_asm_h
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
	ldr	x9, [x24, #296]
	sub	x8, sp, #176
	cmp	x8, x9
	b.ls	.LBB3_29
// %bb.3:                               // %B15
	mov	x19, sp
	mov	sp, x8
	add	x9, x8, #32
	stp	x23, x22, [x8]
	mov	x28, x20
	stp	x9, x9, [x8, #32]
	mov	x27, xzr
	stp	xzr, xzr, [x8, #64]
	stp	w3, wzr, [x8, #56]
	stp	x20, xzr, [x8, #16]
	stp	x21, xzr, [x8, #80]
	str	wzr, [x8, #96]
	ldr	x9, [x24, #8]
	str	x8, [x9, #240]
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
	str	x23, [x8, #240]
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
	b	ThrowStackOverflow_Return_asm_h
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
	b	ThrowTypeErrorNotFunction_Return_asm_h
.Lfunc_end3:
	.size	call_native_asm_h, .Lfunc_end3-call_native_asm_h
	.cfi_endproc
                                        // -- End function
	.hidden	common_call_from_entry_asm_h    // -- Begin function common_call_from_entry_asm_h
	.globl	common_call_from_entry_asm_h
	.p2align	2
	.type	common_call_from_entry_asm_h,@function
common_call_from_entry_asm_h:           // @common_call_from_entry_asm_h
// %bb.0:                               // %B48
	tbz	w19, #2, .LBB4_3
// %bb.1:                               // %B39
	mov	x8, x30
	mov	x9, sp
	and	x10, x22, #0xfffffffffffc
	stp	x9, x8, [x10, #168]
	add	x11, x10, #16
	ldr	x8, [x24, #8]
	mov	x23, x11
	ldr	x9, [x8, #240]
	str	x9, [x10, #16]
	str	x11, [x8, #240]
	ldr	x19, [x10, #64]
	ldr	w8, [x10, #12]
	ldr	x20, [x10, #80]
	ldp	x28, x27, [x10, #32]
	ldr	x26, [x10, #136]
	cbnz	w8, .LBB4_13
.LBB4_2:                                // %B28
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB4_3:                                // %B42
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB4_14
// %bb.4:                               // %B44
	ldrh	w8, [x22, #6]
	cmp	w8, #13
	b.ne	.LBB4_15
// %bb.5:                               // %B1
	ldr	x11, [x22, #32]
	ldr	x14, [x24, #296]
	mov	x12, x23
	mov	x13, sp
	ldrh	w10, [x11, #40]
	ldrh	w8, [x11, #42]
	ldrh	w9, [x11, #46]
	cmp	w0, w10
	add	w9, w8, w9
	b.lt	.LBB4_16
// %bb.6:                               // %B36
	add	w9, w9, w0
	lsl	w9, w9, #3
	add	w9, w9, #176
	and	w10, w9, #0x8
	add	w9, w9, w10
	sub	x9, x13, x9
	cmp	x9, x14
	b.ls	.LBB4_23
// %bb.7:                               // %B38
	mov	sp, x9
	mov	x10, x30
	stp	x12, x22, [x9]
	mov	x23, x9
	stp	x13, x10, [x9, #152]
	add	x10, x9, #32
	str	x21, [x9, #80]
	stp	x21, x27, [x9, #104]
	ldr	x13, [x22, #40]
	stp	x10, x10, [x9, #32]
	str	x13, [x9, #120]
	mov	x26, x13
	ldrb	w10, [x11, #5]
	str	w10, [x9, #60]
	ldr	x19, [x11, #8]
	str	w0, [x9, #136]
	ldr	x12, [x11, #48]
	add	x11, x9, #176
	add	x10, x11, w0, uxtw #3
	str	x12, [x9, #128]
	mov	x12, x11
	cmp	x11, x10
	b.ge	.LBB4_9
.LBB4_8:                                // %B33
                                        // =>This Inner Loop Header: Depth=1
	ldr	x13, [x20], #8
	str	x13, [x12], #8
	cmp	x12, x10
	b.lt	.LBB4_8
.LBB4_9:                                // %B35
	add	w12, w0, w8
	str	w0, [x9, #56]
	add	x20, x10, x8, lsl #3
	stp	x11, x10, [x9, #16]
	mov	w8, #18                         // =0x12
	mov	x28, x11
	str	xzr, [x9, #88]
	mov	x27, x10
	str	w12, [x9, #96]
	ldr	x12, [x24, #8]
	str	x9, [x12, #240]
	cmp	x10, x20
	b.ge	.LBB4_11
.LBB4_10:                               // %B25
                                        // =>This Inner Loop Header: Depth=1
	str	x8, [x10], #8
	cmp	x10, x20
	b.lt	.LBB4_10
.LBB4_11:                               // %B26
	ldr	w8, [x24, #336]
	cbz	w8, .LBB4_2
// %bb.12:                              // %B27
	add	x1, x19, #1
	mov	x0, x24
	str	x20, [x9, #64]
	bl	DebuggerCallEachFunc
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB4_13:                               // %B40
	b	exception_asm_h
.LBB4_14:                               // %B47
	b	ThrowTypeErrorNotFunction_Return_asm_h
.LBB4_15:                               // %B45
	b	call_native_entry_asm_h
.LBB4_16:                               // %B20
	add	w9, w9, w10
	lsl	w9, w9, #3
	add	w9, w9, #176
	and	w15, w9, #0x8
	add	w9, w9, w15
	sub	x9, x13, x9
	cmp	x9, x14
	b.ls	.LBB4_23
// %bb.17:                              // %B22
	mov	sp, x9
	mov	x14, x30
	stp	x12, x22, [x9]
	add	x12, x9, #32
	stp	x13, x14, [x9, #152]
	mov	x23, x9
	str	x21, [x9, #80]
	stp	x21, x27, [x9, #104]
	ldr	x13, [x22, #40]
	stp	x12, x12, [x9, #32]
	str	x13, [x9, #120]
	mov	x26, x13
	ldrb	w12, [x11, #5]
	str	w12, [x9, #60]
	ldr	x19, [x11, #8]
	str	w0, [x9, #136]
	ldr	x12, [x11, #48]
	add	x11, x9, #176
	str	x12, [x9, #128]
	mov	x12, x11
	cmp	w0, w10
	csel	w13, w0, w10, lt
	add	x13, x11, w13, uxtw #3
	cmp	x11, x13
	b.ge	.LBB4_19
.LBB4_18:                               // %B6
                                        // =>This Inner Loop Header: Depth=1
	ldr	x13, [x20], #8
	str	x13, [x12], #8
	cmp	w0, w10
	csel	w13, w0, w10, lt
	add	x13, x11, w13, uxtw #3
	cmp	x12, x13
	b.lt	.LBB4_18
.LBB4_19:                               // %B10.preheader
	add	x12, x11, x10, lsl #3
	mov	w14, #18                        // =0x12
	cmp	x13, x12
	b.ge	.LBB4_21
.LBB4_20:                               // %B11
                                        // =>This Inner Loop Header: Depth=1
	str	x14, [x13], #8
	cmp	x13, x12
	b.lt	.LBB4_20
.LBB4_21:                               // %B12
	str	w10, [x9, #56]
	add	w10, w10, w8
	add	x20, x12, x8, lsl #3
	stp	x11, x12, [x9, #16]
	mov	w8, #18                         // =0x12
	mov	x28, x11
	str	xzr, [x9, #88]
	mov	x27, x12
	str	w10, [x9, #96]
	ldr	x10, [x24, #8]
	str	x9, [x10, #240]
	cmp	x12, x20
	b.ge	.LBB4_11
.LBB4_22:                               // %B18
                                        // =>This Inner Loop Header: Depth=1
	str	x8, [x12], #8
	cmp	x12, x20
	b.lt	.LBB4_22
	b	.LBB4_11
.LBB4_23:                               // %B21
	b	ThrowStackOverflow_Return_asm_h
.Lfunc_end4:
	.size	common_call_from_entry_asm_h, .Lfunc_end4-common_call_from_entry_asm_h
                                        // -- End function
	.hidden	exception_asm_h                 // -- Begin function exception_asm_h
	.globl	exception_asm_h
	.p2align	2
	.type	exception_asm_h,@function
exception_asm_h:                        // @exception_asm_h
// %bb.0:                               // %B17
	sub	sp, sp, #32
	ldr	x9, [x24, #8]
	ldr	w8, [x9, #232]
	stp	x9, x20, [sp, #8]               // 16-byte Folded Spill
	ldr	x20, [x9, #224]
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
	b	common_return_asm_h
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
	ldr	x10, [x12, #224]
	str	x10, [x8], #8
	ldr	x10, [sp]                       // 8-byte Folded Reload
	str	x11, [x12, #224]
	mov	x20, x8
	ldr	x10, [x10, #8]
	add	x19, x10, w9, sxtw
	ldrb	w9, [x19], #1
	ldr	x1, [x25, x9, lsl #3]
	add	sp, sp, #32
	br	x1
.Lfunc_end5:
	.size	exception_asm_h, .Lfunc_end5-exception_asm_h
                                        // -- End function
	.hidden	common_call_asm_h               // -- Begin function common_call_asm_h
	.globl	common_call_asm_h
	.p2align	2
	.type	common_call_asm_h,@function
common_call_asm_h:                      // @common_call_asm_h
// %bb.0:                               // %B38
	mov	x9, #2                          // =0x2
	mov	x8, x20
	movk	x9, #65535, lsl #48
	tst	x22, x9
	b.ne	.LBB6_9
// %bb.1:                               // %B35
	ldrh	w9, [x22, #6]
	cmp	w9, #13
	b.ne	.LBB6_10
// %bb.2:                               // %B1
	ldr	x12, [x22, #32]
	ldr	x15, [x24, #296]
	mov	x13, x23
	mov	x14, sp
	ldrh	w11, [x12, #40]
	ldrh	w9, [x12, #42]
	ldrh	w10, [x12, #46]
	cmp	w0, w11
	add	w10, w9, w10
	b.lt	.LBB6_11
// %bb.3:                               // %B32
	lsl	w10, w10, #3
	add	w10, w10, #176
	and	w11, w10, #0x8
	add	w10, w10, w11
	sub	x10, x14, x10
	cmp	x10, x15
	b.ls	.LBB6_18
// %bb.4:                               // %B34
	mov	sp, x10
	mov	x11, x30
	stp	x13, x22, [x10]
	mov	x23, x10
	stp	x14, x11, [x10, #152]
	add	x11, x10, #32
	mov	x28, x8
	str	x21, [x10, #80]
	stp	x21, x27, [x10, #104]
	ldr	x13, [x22, #40]
	stp	x11, x11, [x10, #32]
	str	x13, [x10, #120]
	mov	x26, x13
	ldrb	w11, [x12, #5]
	str	w11, [x10, #60]
	ldr	x19, [x12, #8]
	str	w0, [x10, #136]
	ldr	x11, [x12, #48]
	add	w12, w0, w9
	str	w0, [x10, #56]
	str	xzr, [x10, #88]
	str	x11, [x10, #128]
	add	x11, x10, #176
	stp	x8, x11, [x10, #16]
	add	x20, x11, x9, lsl #3
	mov	w9, #18                         // =0x12
	str	w12, [x10, #96]
	mov	x27, x11
	ldr	x12, [x24, #8]
	str	x10, [x12, #240]
	cmp	x11, x20
	b.ge	.LBB6_6
.LBB6_5:                                // %B26
                                        // =>This Inner Loop Header: Depth=1
	str	x9, [x11], #8
	cmp	x11, x20
	b.lt	.LBB6_5
.LBB6_6:                                // %B27
	ldr	w8, [x24, #336]
	cbz	w8, .LBB6_8
// %bb.7:                               // %B28
	add	x1, x19, #1
	mov	x0, x24
	str	x20, [x10, #64]
	bl	DebuggerCallEachFunc
.LBB6_8:                                // %B24
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB6_9:                                // %B40
	mov	x20, x8
	b	ThrowTypeErrorNotFunction_Return_asm_h
.LBB6_10:                               // %B36
	mov	x20, x8
	b	call_native_asm_h
.LBB6_11:                               // %B20
	add	w10, w10, w11
	lsl	w10, w10, #3
	add	w10, w10, #176
	and	w16, w10, #0x8
	add	w10, w10, w16
	sub	x10, x14, x10
	cmp	x10, x15
	b.ls	.LBB6_18
// %bb.12:                              // %B22
	mov	sp, x10
	mov	x15, x30
	stp	x13, x22, [x10]
	add	x13, x10, #32
	stp	x14, x15, [x10, #152]
	mov	x23, x10
	str	x21, [x10, #80]
	stp	x21, x27, [x10, #104]
	ldr	x14, [x22, #40]
	stp	x13, x13, [x10, #32]
	str	x14, [x10, #120]
	mov	x26, x14
	ldrb	w13, [x12, #5]
	str	w13, [x10, #60]
	ldr	x19, [x12, #8]
	str	w0, [x10, #136]
	ldr	x13, [x12, #48]
	add	x12, x10, #176
	str	x13, [x10, #128]
	mov	x13, x12
	cmp	w0, w11
	csel	w14, w0, w11, lt
	add	x14, x12, w14, uxtw #3
	cmp	x12, x14
	b.ge	.LBB6_14
.LBB6_13:                               // %B6
                                        // =>This Inner Loop Header: Depth=1
	ldr	x14, [x8], #8
	str	x14, [x13], #8
	cmp	w0, w11
	csel	w14, w0, w11, lt
	add	x14, x12, w14, uxtw #3
	cmp	x13, x14
	b.lt	.LBB6_13
.LBB6_14:                               // %B10.preheader
	add	x8, x12, x11, lsl #3
	mov	w13, #18                        // =0x12
	cmp	x14, x8
	b.ge	.LBB6_16
.LBB6_15:                               // %B11
                                        // =>This Inner Loop Header: Depth=1
	str	x13, [x14], #8
	cmp	x14, x8
	b.lt	.LBB6_15
.LBB6_16:                               // %B12
	str	w11, [x10, #56]
	add	w11, w11, w9
	add	x20, x8, x9, lsl #3
	stp	x12, x8, [x10, #16]
	mov	w9, #18                         // =0x12
	mov	x28, x12
	str	xzr, [x10, #88]
	mov	x27, x8
	str	w11, [x10, #96]
	ldr	x11, [x24, #8]
	str	x10, [x11, #240]
	cmp	x8, x20
	b.ge	.LBB6_6
.LBB6_17:                               // %B18
                                        // =>This Inner Loop Header: Depth=1
	str	x9, [x8], #8
	cmp	x8, x20
	b.lt	.LBB6_17
	b	.LBB6_6
.LBB6_18:                               // %B21
	mov	x20, x8
	b	ThrowStackOverflow_Return_asm_h
.Lfunc_end6:
	.size	common_call_asm_h, .Lfunc_end6-common_call_asm_h
                                        // -- End function
	.hidden	common_return_direct_asm_h      // -- Begin function common_return_direct_asm_h
	.globl	common_return_direct_asm_h
	.p2align	2
	.type	common_return_direct_asm_h,@function
common_return_direct_asm_h:             // @common_return_direct_asm_h
// %bb.0:                               // %B0
	ldp	x9, x8, [x23, #152]
	ldr	x10, [x23]
	mov	x30, x8
	mov	sp, x9
	ldr	x8, [x24, #8]
	mov	x23, x10
	str	x10, [x8, #240]
	ret
.Lfunc_end7:
	.size	common_return_direct_asm_h, .Lfunc_end7-common_return_direct_asm_h
                                        // -- End function
	.hidden	common_call_debugger0_asm_h     // -- Begin function common_call_debugger0_asm_h
	.globl	common_call_debugger0_asm_h
	.p2align	2
	.type	common_call_debugger0_asm_h,@function
common_call_debugger0_asm_h:            // @common_call_debugger0_asm_h
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB8_2
// %bb.1:                               // %B4
	ldr	x8, [x23, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #32]
	str	x20, [x23, #64]
	bl	DebuggerCallEachOp
.LBB8_2:                                // %B1
	ldurb	w8, [x19, #-1]
	sub	w8, w8, #726
	ldr	x1, [x25, w8, sxtw #3]
	br	x1
.Lfunc_end8:
	.size	common_call_debugger0_asm_h, .Lfunc_end8-common_call_debugger0_asm_h
                                        // -- End function
	.hidden	common_call_debugger1_asm_h     // -- Begin function common_call_debugger1_asm_h
	.globl	common_call_debugger1_asm_h
	.p2align	2
	.type	common_call_debugger1_asm_h,@function
common_call_debugger1_asm_h:            // @common_call_debugger1_asm_h
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB9_2
// %bb.1:                               // %B4
	ldr	x8, [x23, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #32]
	str	x20, [x23, #64]
	bl	DebuggerCallEachOp
.LBB9_2:                                // %B1
	ldurb	w8, [x19, #-1]
	sub	w8, w8, #484
	ldr	x1, [x25, w8, sxtw #3]
	br	x1
.Lfunc_end9:
	.size	common_call_debugger1_asm_h, .Lfunc_end9-common_call_debugger1_asm_h
                                        // -- End function
	.hidden	common_call_debugger2_asm_h     // -- Begin function common_call_debugger2_asm_h
	.globl	common_call_debugger2_asm_h
	.p2align	2
	.type	common_call_debugger2_asm_h,@function
common_call_debugger2_asm_h:            // @common_call_debugger2_asm_h
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB10_2
// %bb.1:                               // %B4
	ldr	x8, [x23, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #32]
	str	x20, [x23, #64]
	bl	DebuggerCallEachOp
.LBB10_2:                               // %B1
	ldurb	w8, [x19, #-1]
	sub	w8, w8, #242
	ldr	x1, [x25, w8, sxtw #3]
	br	x1
.Lfunc_end10:
	.size	common_call_debugger2_asm_h, .Lfunc_end10-common_call_debugger2_asm_h
                                        // -- End function
	.hidden	SlowCloseVarRefs_asm_h          // -- Begin function SlowCloseVarRefs_asm_h
	.globl	SlowCloseVarRefs_asm_h
	.p2align	2
	.type	SlowCloseVarRefs_asm_h,@function
SlowCloseVarRefs_asm_h:                 // @SlowCloseVarRefs_asm_h
// %bb.0:                               // %B0
	mov	x22, x0
	mov	x0, x24
	mov	x1, x23
	bl	prim_close_var_refs_gc
	mov	x0, x22
	b	common_return_direct_asm_h
.Lfunc_end11:
	.size	SlowCloseVarRefs_asm_h, .Lfunc_end11-SlowCloseVarRefs_asm_h
                                        // -- End function
	.hidden	common_return_asm_h             // -- Begin function common_return_asm_h
	.globl	common_return_asm_h
	.p2align	2
	.type	common_return_asm_h,@function
common_return_asm_h:                    // @common_return_asm_h
// %bb.0:                               // %B6
	ldr	x8, [x23, #88]
	cbnz	x8, .LBB12_3
// %bb.1:                               // %B1
	ldrb	w8, [x24, #392]
	cbz	w8, .LBB12_4
// %bb.2:                               // %B1
	cbz	x26, .LBB12_4
.LBB12_3:                               // %B3
	b	SlowCloseVarRefs_asm_h
.LBB12_4:                               // %B5
	b	common_return_direct_asm_h
.Lfunc_end12:
	.size	common_return_asm_h, .Lfunc_end12-common_return_asm_h
                                        // -- End function
	.hidden	exception_spill_top0_asm_h      // -- Begin function exception_spill_top0_asm_h
	.globl	exception_spill_top0_asm_h
	.p2align	2
	.type	exception_spill_top0_asm_h,@function
exception_spill_top0_asm_h:             // @exception_spill_top0_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	exception_asm_h
.Lfunc_end13:
	.size	exception_spill_top0_asm_h, .Lfunc_end13-exception_spill_top0_asm_h
                                        // -- End function
	.hidden	exception_spill_top1_asm_h      // -- Begin function exception_spill_top1_asm_h
	.globl	exception_spill_top1_asm_h
	.p2align	2
	.type	exception_spill_top1_asm_h,@function
exception_spill_top1_asm_h:             // @exception_spill_top1_asm_h
// %bb.0:                               // %B0
	str	x21, [x20], #8
	b	exception_asm_h
.Lfunc_end14:
	.size	exception_spill_top1_asm_h, .Lfunc_end14-exception_spill_top1_asm_h
                                        // -- End function
	.hidden	exception_spill_top0_top1_asm_h // -- Begin function exception_spill_top0_top1_asm_h
	.globl	exception_spill_top0_top1_asm_h
	.p2align	2
	.type	exception_spill_top0_top1_asm_h,@function
exception_spill_top0_top1_asm_h:        // @exception_spill_top0_top1_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	exception_asm_h
.Lfunc_end15:
	.size	exception_spill_top0_top1_asm_h, .Lfunc_end15-exception_spill_top0_top1_asm_h
                                        // -- End function
	.hidden	SlowToBoolean_asm_h             // -- Begin function SlowToBoolean_asm_h
	.globl	SlowToBoolean_asm_h
	.p2align	2
	.type	SlowToBoolean_asm_h,@function
SlowToBoolean_asm_h:                    // @SlowToBoolean_asm_h
// %bb.0:                               // %B1
	mov	x1, x0
	mov	x0, x24
	str	x20, [x23, #64]
	bl	JS_ToBoolFree_GC
	tbnz	w0, #31, .LBB16_2
// %bb.1:                               // %B3
	cmp	w0, #0
	mov	w8, #6                          // =0x6
	cinc	x8, x8, ne
	stur	x8, [x20, #-8]
	ldurb	w8, [x19, #-1]
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB16_2:                               // %B2
	b	exception_asm_h
.Lfunc_end16:
	.size	SlowToBoolean_asm_h, .Lfunc_end16-SlowToBoolean_asm_h
                                        // -- End function
	.hidden	SlowJSPostInc_asm_h             // -- Begin function SlowJSPostInc_asm_h
	.globl	SlowJSPostInc_asm_h
	.p2align	2
	.type	SlowJSPostInc_asm_h,@function
SlowJSPostInc_asm_h:                    // @SlowJSPostInc_asm_h
// %bb.0:                               // %B1
	mov	w2, w0
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #64]
	bl	js_post_inc_slow_gc
	tbnz	w0, #31, .LBB17_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB17_2:                               // %B2
	b	exception_asm_h
.Lfunc_end17:
	.size	SlowJSPostInc_asm_h, .Lfunc_end17-SlowJSPostInc_asm_h
                                        // -- End function
	.hidden	SlowJSNot_asm_h                 // -- Begin function SlowJSNot_asm_h
	.globl	SlowJSNot_asm_h
	.p2align	2
	.type	SlowJSNot_asm_h,@function
SlowJSNot_asm_h:                        // @SlowJSNot_asm_h
// %bb.0:                               // %B1
	mov	x1, x0
	mov	x0, x24
	str	x20, [x23, #64]
	bl	prim_js_not_slow_gc
	cmp	x0, #130
	b.eq	.LBB18_2
// %bb.1:                               // %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB18_2:                               // %B2
	b	exception_asm_h
.Lfunc_end18:
	.size	SlowJSNot_asm_h, .Lfunc_end18-SlowJSNot_asm_h
                                        // -- End function
	.hidden	ThrowReferenceErrorUninitialized_asm_h // -- Begin function ThrowReferenceErrorUninitialized_asm_h
	.globl	ThrowReferenceErrorUninitialized_asm_h
	.p2align	2
	.type	ThrowReferenceErrorUninitialized_asm_h,@function
ThrowReferenceErrorUninitialized_asm_h: // @ThrowReferenceErrorUninitialized_asm_h
// %bb.0:                               // %B0
	mov	x0, x24
	mov	w1, wzr
	str	x20, [x23, #64]
	bl	JS_ThrowReferenceErrorUninitialized_GC
	b	exception_asm_h
.Lfunc_end19:
	.size	ThrowReferenceErrorUninitialized_asm_h, .Lfunc_end19-ThrowReferenceErrorUninitialized_asm_h
                                        // -- End function
	.hidden	ThrowThisReferenceError_asm_h   // -- Begin function ThrowThisReferenceError_asm_h
	.globl	ThrowThisReferenceError_asm_h
	.p2align	2
	.type	ThrowThisReferenceError_asm_h,@function
ThrowThisReferenceError_asm_h:          // @ThrowThisReferenceError_asm_h
// %bb.0:                               // %B0
	adrp	x1, .L__unnamed_1
	add	x1, x1, :lo12:.L__unnamed_1
	mov	x0, x24
	str	x20, [x23, #64]
	bl	LEPUS_ThrowReferenceError
	b	exception_asm_h
.Lfunc_end20:
	.size	ThrowThisReferenceError_asm_h, .Lfunc_end20-ThrowThisReferenceError_asm_h
                                        // -- End function
	.hidden	invalid_0_asm_h                 // -- Begin function invalid_0_asm_h
	.globl	invalid_0_asm_h
	.p2align	2
	.type	invalid_0_asm_h,@function
invalid_0_asm_h:                        // @invalid_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #8]
	adrp	x1, .L__unnamed_2
	add	x1, x1, :lo12:.L__unnamed_2
	mov	x0, x24
	mov	w3, wzr
	ldr	x8, [x8, #32]
	ldr	w8, [x8, #8]
	str	x20, [x23, #64]
	mvn	w8, w8
	add	w2, w8, w19
	bl	LEPUS_ThrowInternalError
	b	exception_asm_h
.Lfunc_end21:
	.size	invalid_0_asm_h, .Lfunc_end21-invalid_0_asm_h
                                        // -- End function
	.hidden	push_i32_0_asm_h                // -- Begin function push_i32_0_asm_h
	.globl	push_i32_0_asm_h
	.p2align	2
	.type	push_i32_0_asm_h,@function
push_i32_0_asm_h:                       // @push_i32_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #4]
	ldr	w9, [x19], #5
	add	w8, w8, #242
	orr	x22, x9, #0xfffe000000000000
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end22:
	.size	push_i32_0_asm_h, .Lfunc_end22-push_i32_0_asm_h
                                        // -- End function
	.hidden	push_const_0_asm_h              // -- Begin function push_const_0_asm_h
	.globl	push_const_0_asm_h
	.p2align	2
	.type	push_const_0_asm_h,@function
push_const_0_asm_h:                     // @push_const_0_asm_h
// %bb.0:                               // %B3
	sub	sp, sp, #16
	ldr	x8, [x23, #128]
	ldrsw	x9, [x19]
	ldr	w10, [x24, #336]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, .LBB23_2
// %bb.1:                               // %B4
	mov	x0, x24
	mov	x2, x19
	str	x20, [x23, #64]
	str	x1, [sp, #8]                    // 8-byte Folded Spill
	bl	DebuggerPause
	ldr	x1, [sp, #8]                    // 8-byte Folded Reload
.LBB23_2:                               // %B1
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x1
	add	w8, w8, #242
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
.Lfunc_end23:
	.size	push_const_0_asm_h, .Lfunc_end23-push_const_0_asm_h
                                        // -- End function
	.hidden	fclosure_0_asm_h                // -- Begin function fclosure_0_asm_h
	.globl	fclosure_0_asm_h
	.p2align	2
	.type	fclosure_0_asm_h,@function
fclosure_0_asm_h:                       // @fclosure_0_asm_h
// %bb.0:                               // %B1
	ldr	x8, [x23, #128]
	ldrsw	x9, [x19]
	mov	x0, x24
	mov	x2, x26
	mov	x3, x23
	ldr	x1, [x8, x9, lsl #3]
	str	x20, [x23, #64]
	bl	js_closure_gc
	cmp	x0, #130
	b.eq	.LBB24_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB24_2:                               // %B2
	b	exception_asm_h
.Lfunc_end24:
	.size	fclosure_0_asm_h, .Lfunc_end24-fclosure_0_asm_h
                                        // -- End function
	.hidden	push_atom_value_0_asm_h         // -- Begin function push_atom_value_0_asm_h
	.globl	push_atom_value_0_asm_h
	.p2align	2
	.type	push_atom_value_0_asm_h,@function
push_atom_value_0_asm_h:                // @push_atom_value_0_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB25_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB25_2:                               // %B2
	b	exception_asm_h
.Lfunc_end25:
	.size	push_atom_value_0_asm_h, .Lfunc_end25-push_atom_value_0_asm_h
                                        // -- End function
	.hidden	private_symbol_0_asm_h          // -- Begin function private_symbol_0_asm_h
	.globl	private_symbol_0_asm_h
	.p2align	2
	.type	private_symbol_0_asm_h,@function
private_symbol_0_asm_h:                 // @private_symbol_0_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, #4                          // =0x4
	str	x20, [x23, #64]
	bl	JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	.LBB26_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB26_2:                               // %B2
	b	exception_asm_h
.Lfunc_end26:
	.size	private_symbol_0_asm_h, .Lfunc_end26-private_symbol_0_asm_h
                                        // -- End function
	.hidden	undefined_0_asm_h               // -- Begin function undefined_0_asm_h
	.globl	undefined_0_asm_h
	.p2align	2
	.type	undefined_0_asm_h,@function
undefined_0_asm_h:                      // @undefined_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w22, #18                        // =0x12
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end27:
	.size	undefined_0_asm_h, .Lfunc_end27-undefined_0_asm_h
                                        // -- End function
	.hidden	null_0_asm_h                    // -- Begin function null_0_asm_h
	.globl	null_0_asm_h
	.p2align	2
	.type	null_0_asm_h,@function
null_0_asm_h:                           // @null_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w22, #2                         // =0x2
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end28:
	.size	null_0_asm_h, .Lfunc_end28-null_0_asm_h
                                        // -- End function
	.hidden	push_this_0_asm_h               // -- Begin function push_this_0_asm_h
	.globl	push_this_0_asm_h
	.p2align	2
	.type	push_this_0_asm_h,@function
push_this_0_asm_h:                      // @push_this_0_asm_h
// %bb.0:                               // %B12
	ldr	w8, [x23, #60]
	ldr	x1, [x23, #104]
	tbnz	w8, #0, .LBB29_2
// %bb.1:                               // %B12
	ldr	x8, [x23, #104]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, .LBB29_3
.LBB29_2:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x1
	add	w8, w8, #242
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.LBB29_3:                               // %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	.LBB29_5
// %bb.4:                               // %B7
	ldrb	w8, [x19], #1
	ldr	x22, [x24, #208]
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB29_5:                               // %B9
	mov	x0, x24
	str	x20, [x23, #64]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB29_7
// %bb.6:                               // %B11
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB29_7:                               // %B10
	b	exception_asm_h
.Lfunc_end29:
	.size	push_this_0_asm_h, .Lfunc_end29-push_this_0_asm_h
                                        // -- End function
	.hidden	push_false_0_asm_h              // -- Begin function push_false_0_asm_h
	.globl	push_false_0_asm_h
	.p2align	2
	.type	push_false_0_asm_h,@function
push_false_0_asm_h:                     // @push_false_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end30:
	.size	push_false_0_asm_h, .Lfunc_end30-push_false_0_asm_h
                                        // -- End function
	.hidden	push_true_0_asm_h               // -- Begin function push_true_0_asm_h
	.globl	push_true_0_asm_h
	.p2align	2
	.type	push_true_0_asm_h,@function
push_true_0_asm_h:                      // @push_true_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end31:
	.size	push_true_0_asm_h, .Lfunc_end31-push_true_0_asm_h
                                        // -- End function
	.hidden	object_0_asm_h                  // -- Begin function object_0_asm_h
	.globl	object_0_asm_h
	.p2align	2
	.type	object_0_asm_h,@function
object_0_asm_h:                         // @object_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	str	x20, [x23, #64]
	bl	PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	.LBB32_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB32_2:                               // %B2
	b	exception_asm_h
.Lfunc_end32:
	.size	object_0_asm_h, .Lfunc_end32-object_0_asm_h
                                        // -- End function
	.hidden	special_object_0_asm_h          // -- Begin function special_object_0_asm_h
	.globl	special_object_0_asm_h
	.p2align	2
	.type	special_object_0_asm_h,@function
special_object_0_asm_h:                 // @special_object_0_asm_h
// %bb.0:                               // %B15
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	.LBB33_4
// %bb.1:                               // %B15
	cbz	w8, .LBB33_7
// %bb.2:                               // %B15
	cmp	w8, #1
	b.ne	.LBB33_12
// %bb.3:                               // %B6
	ldr	x8, [x23, #8]
	ldr	w1, [x23, #136]
	mov	x0, x24
	mov	x2, x28
	mov	x3, x23
	ldr	x8, [x8, #32]
	ldrh	w8, [x8, #40]
	str	x20, [x23, #64]
	cmp	w8, w1
	csel	w4, w8, w1, lt
	bl	js_build_mapped_arguments_gc
	b	.LBB33_8
.LBB33_4:                               // %B15
	cmp	w8, #5
	b.eq	.LBB33_10
// %bb.5:                               // %B15
	cmp	w8, #4
	b.ne	.LBB33_13
// %bb.6:                               // %B9
	ldr	x8, [x23, #8]
	mov	w9, #18                         // =0x12
	ldr	x8, [x8, #48]
	cmp	x8, #0
	csel	x8, x9, x8, eq
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB33_7:                               // %B1
	ldr	w1, [x23, #136]
	mov	x0, x24
	mov	x2, x28
	str	x20, [x23, #64]
	bl	js_build_arguments_gc
.LBB33_8:                               // %B6
	cmp	x0, #130
	b.eq	.LBB33_11
.LBB33_9:
	mov	x8, x0
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB33_10:                              // %B12
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x23, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.ne	.LBB33_9
.LBB33_11:                              // %B13
	b	exception_asm_h
.LBB33_12:                              // %B18
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB33_13:                              // %B19
	ldr	x8, [x23, #112]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end33:
	.size	special_object_0_asm_h, .Lfunc_end33-special_object_0_asm_h
                                        // -- End function
	.hidden	rest_0_asm_h                    // -- Begin function rest_0_asm_h
	.globl	rest_0_asm_h
	.p2align	2
	.type	rest_0_asm_h,@function
rest_0_asm_h:                           // @rest_0_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x23, #136]
	ldrh	w1, [x19]
	mov	x0, x24
	mov	x3, x28
	str	x20, [x23, #64]
	bl	js_build_rest_gc
	cmp	x0, #130
	b.eq	.LBB34_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB34_2:                               // %B2
	b	exception_asm_h
.Lfunc_end34:
	.size	rest_0_asm_h, .Lfunc_end34-rest_0_asm_h
                                        // -- End function
	.hidden	drop_0_asm_h                    // -- Begin function drop_0_asm_h
	.globl	drop_0_asm_h
	.p2align	2
	.type	drop_0_asm_h,@function
drop_0_asm_h:                           // @drop_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end35:
	.size	drop_0_asm_h, .Lfunc_end35-drop_0_asm_h
                                        // -- End function
	.hidden	nip_0_asm_h                     // -- Begin function nip_0_asm_h
	.globl	nip_0_asm_h
	.p2align	2
	.type	nip_0_asm_h,@function
nip_0_asm_h:                            // @nip_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldur	x22, [x20, #-8]
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x8, x20, #16
	mov	x20, x8
	br	x1
.Lfunc_end36:
	.size	nip_0_asm_h, .Lfunc_end36-nip_0_asm_h
                                        // -- End function
	.hidden	nip1_0_asm_h                    // -- Begin function nip1_0_asm_h
	.globl	nip1_0_asm_h
	.p2align	2
	.type	nip1_0_asm_h,@function
nip1_0_asm_h:                           // @nip1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldp	x22, x21, [x20, #-16]
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	sub	x8, x20, #24
	mov	x20, x8
	br	x1
.Lfunc_end37:
	.size	nip1_0_asm_h, .Lfunc_end37-nip1_0_asm_h
                                        // -- End function
	.hidden	dup_0_asm_h                     // -- Begin function dup_0_asm_h
	.globl	dup_0_asm_h
	.p2align	2
	.type	dup_0_asm_h,@function
dup_0_asm_h:                            // @dup_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x20, #-8]!
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x22
	br	x1
.Lfunc_end38:
	.size	dup_0_asm_h, .Lfunc_end38-dup_0_asm_h
                                        // -- End function
	.hidden	dup1_0_asm_h                    // -- Begin function dup1_0_asm_h
	.globl	dup1_0_asm_h
	.p2align	2
	.type	dup1_0_asm_h,@function
dup1_0_asm_h:                           // @dup1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x20, #-8]!
	ldur	x22, [x20, #-8]
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	mov	x1, x22
	mov	x22, x21
	mov	x22, x1
	br	x2
.Lfunc_end39:
	.size	dup1_0_asm_h, .Lfunc_end39-dup1_0_asm_h
                                        // -- End function
	.hidden	dup2_0_asm_h                    // -- Begin function dup2_0_asm_h
	.globl	dup2_0_asm_h
	.p2align	2
	.type	dup2_0_asm_h,@function
dup2_0_asm_h:                           // @dup2_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldp	x22, x21, [x20, #-16]
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end40:
	.size	dup2_0_asm_h, .Lfunc_end40-dup2_0_asm_h
                                        // -- End function
	.hidden	dup3_0_asm_h                    // -- Begin function dup3_0_asm_h
	.globl	dup3_0_asm_h
	.p2align	2
	.type	dup3_0_asm_h,@function
dup3_0_asm_h:                           // @dup3_0_asm_h
// %bb.0:                               // %B0
	ldp	x8, x22, [x20, #-24]
	ldur	x21, [x20, #-8]
	str	x8, [x20], #8
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end41:
	.size	dup3_0_asm_h, .Lfunc_end41-dup3_0_asm_h
                                        // -- End function
	.hidden	insert2_0_asm_h                 // -- Begin function insert2_0_asm_h
	.globl	insert2_0_asm_h
	.p2align	2
	.type	insert2_0_asm_h,@function
insert2_0_asm_h:                        // @insert2_0_asm_h
// %bb.0:                               // %B0
	ldr	x21, [x20, #-8]!
	ldur	x22, [x20, #-8]
	stur	x21, [x20, #-8]
	mov	x1, x22
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x22, x1
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.Lfunc_end42:
	.size	insert2_0_asm_h, .Lfunc_end42-insert2_0_asm_h
                                        // -- End function
	.hidden	insert3_0_asm_h                 // -- Begin function insert3_0_asm_h
	.globl	insert3_0_asm_h
	.p2align	2
	.type	insert3_0_asm_h,@function
insert3_0_asm_h:                        // @insert3_0_asm_h
// %bb.0:                               // %B0
	ldr	x21, [x20, #-8]!
	ldp	x8, x22, [x20, #-16]
	stp	x21, x8, [x20, #-16]
	mov	x2, x22
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x22, x2
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end43:
	.size	insert3_0_asm_h, .Lfunc_end43-insert3_0_asm_h
                                        // -- End function
	.hidden	insert4_0_asm_h                 // -- Begin function insert4_0_asm_h
	.globl	insert4_0_asm_h
	.p2align	2
	.type	insert4_0_asm_h,@function
insert4_0_asm_h:                        // @insert4_0_asm_h
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
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.Lfunc_end44:
	.size	insert4_0_asm_h, .Lfunc_end44-insert4_0_asm_h
                                        // -- End function
	.hidden	perm3_0_asm_h                   // -- Begin function perm3_0_asm_h
	.globl	perm3_0_asm_h
	.p2align	2
	.type	perm3_0_asm_h,@function
perm3_0_asm_h:                          // @perm3_0_asm_h
// %bb.0:                               // %B0
	ldp	x22, x21, [x20, #-16]!
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end45:
	.size	perm3_0_asm_h, .Lfunc_end45-perm3_0_asm_h
                                        // -- End function
	.hidden	perm4_0_asm_h                   // -- Begin function perm4_0_asm_h
	.globl	perm4_0_asm_h
	.p2align	2
	.type	perm4_0_asm_h,@function
perm4_0_asm_h:                          // @perm4_0_asm_h
// %bb.0:                               // %B0
	ldp	x22, x21, [x20, #-16]!
	mov	x9, x22
	ldp	x8, x22, [x20, #-16]
	stp	x9, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end46:
	.size	perm4_0_asm_h, .Lfunc_end46-perm4_0_asm_h
                                        // -- End function
	.hidden	perm5_0_asm_h                   // -- Begin function perm5_0_asm_h
	.globl	perm5_0_asm_h
	.p2align	2
	.type	perm5_0_asm_h,@function
perm5_0_asm_h:                          // @perm5_0_asm_h
// %bb.0:                               // %B0
	ldp	x22, x21, [x20, #-16]!
	ldp	x9, x8, [x20, #-24]
	mov	x10, x22
	ldur	x22, [x20, #-8]
	stur	x10, [x20, #-24]
	stp	x9, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end47:
	.size	perm5_0_asm_h, .Lfunc_end47-perm5_0_asm_h
                                        // -- End function
	.hidden	swap_0_asm_h                    // -- Begin function swap_0_asm_h
	.globl	swap_0_asm_h
	.p2align	2
	.type	swap_0_asm_h,@function
swap_0_asm_h:                           // @swap_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldp	x22, x21, [x20, #-16]!
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	mov	x1, x22
	mov	x22, x21
	mov	x21, x1
	br	x2
.Lfunc_end48:
	.size	swap_0_asm_h, .Lfunc_end48-swap_0_asm_h
                                        // -- End function
	.hidden	swap2_0_asm_h                   // -- Begin function swap2_0_asm_h
	.globl	swap2_0_asm_h
	.p2align	2
	.type	swap2_0_asm_h,@function
swap2_0_asm_h:                          // @swap2_0_asm_h
// %bb.0:                               // %B0
	ldp	x22, x21, [x20, #-16]!
	ldp	x8, x9, [x20, #-16]
	stp	x22, x21, [x20, #-16]
	ldrb	w10, [x19], #1
	mov	x22, x8
	mov	x21, x9
	add	w10, w10, #484
	ldr	x1, [x25, w10, uxtw #3]
	br	x1
.Lfunc_end49:
	.size	swap2_0_asm_h, .Lfunc_end49-swap2_0_asm_h
                                        // -- End function
	.hidden	rot3l_0_asm_h                   // -- Begin function rot3l_0_asm_h
	.globl	rot3l_0_asm_h
	.p2align	2
	.type	rot3l_0_asm_h,@function
rot3l_0_asm_h:                          // @rot3l_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-16]!
	ldur	x8, [x20, #-8]
	ldr	x21, [x20, #8]
	stur	x22, [x20, #-8]
	ldrb	w9, [x19], #1
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end50:
	.size	rot3l_0_asm_h, .Lfunc_end50-rot3l_0_asm_h
                                        // -- End function
	.hidden	rot3r_0_asm_h                   // -- Begin function rot3r_0_asm_h
	.globl	rot3r_0_asm_h
	.p2align	2
	.type	rot3r_0_asm_h,@function
rot3r_0_asm_h:                          // @rot3r_0_asm_h
// %bb.0:                               // %B0
	ldp	x22, x21, [x20, #-16]!
	mov	x8, x21
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end51:
	.size	rot3r_0_asm_h, .Lfunc_end51-rot3r_0_asm_h
                                        // -- End function
	.hidden	rot4l_0_asm_h                   // -- Begin function rot4l_0_asm_h
	.globl	rot4l_0_asm_h
	.p2align	2
	.type	rot4l_0_asm_h,@function
rot4l_0_asm_h:                          // @rot4l_0_asm_h
// %bb.0:                               // %B0
	ldp	x22, x21, [x20, #-16]!
	ldp	x9, x8, [x20, #-16]
	stp	x8, x22, [x20, #-16]
	mov	x22, x21
	mov	x21, x9
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end52:
	.size	rot4l_0_asm_h, .Lfunc_end52-rot4l_0_asm_h
                                        // -- End function
	.hidden	rot5l_0_asm_h                   // -- Begin function rot5l_0_asm_h
	.globl	rot5l_0_asm_h
	.p2align	2
	.type	rot5l_0_asm_h,@function
rot5l_0_asm_h:                          // @rot5l_0_asm_h
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
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end53:
	.size	rot5l_0_asm_h, .Lfunc_end53-rot5l_0_asm_h
                                        // -- End function
	.hidden	call_constructor_0_asm_h        // -- Begin function call_constructor_0_asm_h
	.globl	call_constructor_0_asm_h
	.p2align	2
	.type	call_constructor_0_asm_h,@function
call_constructor_0_asm_h:               // @call_constructor_0_asm_h
// %bb.0:                               // %B1
	add	x8, x19, #2
	mov	x0, x24
	mov	w5, wzr
	str	x8, [x23, #48]
	ldrh	w3, [x19]
	sub	x4, x20, w3, uxtw #3
	ldp	x1, x2, [x4, #-16]
	str	x20, [x23, #64]
	bl	JS_CallConstructorInternal_GC
	cmp	x0, #130
	b.eq	.LBB54_2
// %bb.1:                               // %B3
	ldrh	w8, [x19]
	sub	x8, x20, x8, lsl #3
	stur	x0, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x9, lsl #3]
	br	x1
.LBB54_2:                               // %B2
	b	exception_asm_h
.Lfunc_end54:
	.size	call_constructor_0_asm_h, .Lfunc_end54-call_constructor_0_asm_h
                                        // -- End function
	.hidden	call_0_asm_h                    // -- Begin function call_0_asm_h
	.globl	call_0_asm_h
	.p2align	2
	.type	call_0_asm_h,@function
call_0_asm_h:                           // @call_0_asm_h
// %bb.0:                               // %B2
	ldrh	w9, [x19], #2
	str	x19, [x23, #48]
	str	x20, [x23, #64]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	sub	x8, x20, x9, lsl #3
	mov	x0, x9
	ldur	x22, [x8, #-8]
	mov	x20, x8
	bl	common_call_asm_h
	ldr	x19, [x23, #48]
	ldr	x20, [x23, #64]
	cmp	x0, #130
	ldp	x28, x27, [x23, #16]
	ldr	x26, [x23, #120]
	b.eq	.LBB55_2
// %bb.1:                               // %B4
	ldurh	w8, [x19, #-2]
	add	w8, w8, #1
	sub	x20, x20, w8, uxtw #3
	str	x0, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB55_2:                               // %B3
	b	exception_asm_h
.Lfunc_end55:
	.size	call_0_asm_h, .Lfunc_end55-call_0_asm_h
                                        // -- End function
	.hidden	tail_call_0_asm_h               // -- Begin function tail_call_0_asm_h
	.globl	tail_call_0_asm_h
	.p2align	2
	.type	tail_call_0_asm_h,@function
tail_call_0_asm_h:                      // @tail_call_0_asm_h
// %bb.0:                               // %B2
	ldrh	w9, [x19], #2
	str	x19, [x23, #48]
	str	x20, [x23, #64]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	sub	x8, x20, x9, lsl #3
	mov	x0, x9
	ldur	x22, [x8, #-8]
	mov	x20, x8
	bl	common_call_asm_h
	cmp	x0, #130
	b.eq	.LBB56_2
// %bb.1:                               // %B4
	ldr	x26, [x23, #120]
	mov	x19, xzr
	mov	x20, xzr
	b	common_return_asm_h
.LBB56_2:                               // %B3
	mov	x19, xzr
	mov	x20, xzr
	b	exception_asm_h
.Lfunc_end56:
	.size	tail_call_0_asm_h, .Lfunc_end56-tail_call_0_asm_h
                                        // -- End function
	.hidden	call_method_0_asm_h             // -- Begin function call_method_0_asm_h
	.globl	call_method_0_asm_h
	.p2align	2
	.type	call_method_0_asm_h,@function
call_method_0_asm_h:                    // @call_method_0_asm_h
// %bb.0:                               // %B2
	ldrh	w9, [x19], #2
	str	x19, [x23, #48]
	str	x20, [x23, #64]
	mov	w27, #18                        // =0x12
	sub	x8, x20, x9, lsl #3
	mov	x0, x9
	ldp	x21, x22, [x8, #-16]
	mov	x20, x8
	bl	common_call_asm_h
	ldr	x19, [x23, #48]
	ldr	x20, [x23, #64]
	cmp	x0, #130
	ldp	x28, x27, [x23, #16]
	ldr	x26, [x23, #120]
	b.eq	.LBB57_2
// %bb.1:                               // %B4
	ldurh	w8, [x19, #-2]
	add	w8, w8, #2
	sub	x20, x20, w8, uxtw #3
	str	x0, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB57_2:                               // %B3
	b	exception_asm_h
.Lfunc_end57:
	.size	call_method_0_asm_h, .Lfunc_end57-call_method_0_asm_h
                                        // -- End function
	.hidden	tail_call_method_0_asm_h        // -- Begin function tail_call_method_0_asm_h
	.globl	tail_call_method_0_asm_h
	.p2align	2
	.type	tail_call_method_0_asm_h,@function
tail_call_method_0_asm_h:               // @tail_call_method_0_asm_h
// %bb.0:                               // %B2
	ldrh	w9, [x19], #2
	str	x19, [x23, #48]
	str	x20, [x23, #64]
	mov	w27, #18                        // =0x12
	sub	x8, x20, x9, lsl #3
	mov	x0, x9
	ldp	x21, x22, [x8, #-16]
	mov	x20, x8
	bl	common_call_asm_h
	cmp	x0, #130
	b.eq	.LBB58_2
// %bb.1:                               // %B4
	ldr	x26, [x23, #120]
	mov	x19, xzr
	mov	x20, xzr
	b	common_return_asm_h
.LBB58_2:                               // %B3
	mov	x19, xzr
	mov	x20, xzr
	b	exception_asm_h
.Lfunc_end58:
	.size	tail_call_method_0_asm_h, .Lfunc_end58-tail_call_method_0_asm_h
                                        // -- End function
	.hidden	array_from_0_asm_h              // -- Begin function array_from_0_asm_h
	.globl	array_from_0_asm_h
	.p2align	2
	.type	array_from_0_asm_h,@function
array_from_0_asm_h:                     // @array_from_0_asm_h
// %bb.0:                               // %B1
	ldrh	w1, [x19]
	mov	x0, x24
	str	x20, [x23, #64]
	sub	x2, x20, w1, uxtw #3
	bl	LEPUS_NewArrayWithArgs
	cmp	x0, #130
	b.eq	.LBB59_2
// %bb.1:                               // %B3
	ldrh	w8, [x19]
	sub	x20, x20, x8, lsl #3
	str	x0, [x20], #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB59_2:                               // %B2
	b	exception_asm_h
.Lfunc_end59:
	.size	array_from_0_asm_h, .Lfunc_end59-array_from_0_asm_h
                                        // -- End function
	.hidden	apply_0_asm_h                   // -- Begin function apply_0_asm_h
	.globl	apply_0_asm_h
	.p2align	2
	.type	apply_0_asm_h,@function
apply_0_asm_h:                          // @apply_0_asm_h
// %bb.0:                               // %B1
	sub	sp, sp, #16
	ldrh	w4, [x19]
	ldur	x1, [x20, #-24]
	sub	x3, x20, #16
	mov	x0, x24
	mov	w2, #2                          // =0x2
	str	x20, [x23, #64]
	str	x3, [sp, #8]                    // 8-byte Folded Spill
	bl	js_function_apply_gc
	cmp	x0, #130
	b.eq	.LBB60_2
// %bb.1:                               // %B3
	stur	x0, [x20, #-24]
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB60_2:                               // %B2
	add	sp, sp, #16
	b	exception_asm_h
.Lfunc_end60:
	.size	apply_0_asm_h, .Lfunc_end60-apply_0_asm_h
                                        // -- End function
	.hidden	return_0_asm_h                  // -- Begin function return_0_asm_h
	.globl	return_0_asm_h
	.p2align	2
	.type	return_0_asm_h,@function
return_0_asm_h:                         // @return_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	mov	x0, x22
	b	common_return_asm_h
.Lfunc_end61:
	.size	return_0_asm_h, .Lfunc_end61-return_0_asm_h
                                        // -- End function
	.hidden	return_undef_0_asm_h            // -- Begin function return_undef_0_asm_h
	.globl	return_undef_0_asm_h
	.p2align	2
	.type	return_undef_0_asm_h,@function
return_undef_0_asm_h:                   // @return_undef_0_asm_h
// %bb.0:                               // %B0
	mov	w0, #18                         // =0x12
	b	common_return_asm_h
.Lfunc_end62:
	.size	return_undef_0_asm_h, .Lfunc_end62-return_undef_0_asm_h
                                        // -- End function
	.hidden	check_ctor_return_0_asm_h       // -- Begin function check_ctor_return_0_asm_h
	.globl	check_ctor_return_0_asm_h
	.p2align	2
	.type	check_ctor_return_0_asm_h,@function
check_ctor_return_0_asm_h:              // @check_ctor_return_0_asm_h
// %bb.0:                               // %B5
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	.LBB63_3
// %bb.1:                               // %B2
	cmp	x22, #18
	b.eq	.LBB63_4
// %bb.2:                               // %B3
	adrp	x1, .L__unnamed_3
	add	x1, x1, :lo12:.L__unnamed_3
	mov	x0, x24
	str	x20, [x23, #64]
	bl	LEPUS_ThrowTypeError
	b	exception_asm_h
.LBB63_3:                               // %B6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w21, #6                         // =0x6
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB63_4:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w21, #7                         // =0x7
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end63:
	.size	check_ctor_return_0_asm_h, .Lfunc_end63-check_ctor_return_0_asm_h
                                        // -- End function
	.hidden	check_ctor_0_asm_h              // -- Begin function check_ctor_0_asm_h
	.globl	check_ctor_0_asm_h
	.p2align	2
	.type	check_ctor_0_asm_h,@function
check_ctor_0_asm_h:                     // @check_ctor_0_asm_h
// %bb.0:                               // %B2
	ldr	x8, [x23, #112]
	cmp	x8, #18
	b.ne	.LBB64_2
// %bb.1:                               // %B3
	adrp	x1, .L__unnamed_4
	add	x1, x1, :lo12:.L__unnamed_4
	mov	x0, x24
	str	x20, [x23, #64]
	bl	LEPUS_ThrowTypeError
	b	exception_asm_h
.LBB64_2:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end64:
	.size	check_ctor_0_asm_h, .Lfunc_end64-check_ctor_0_asm_h
                                        // -- End function
	.hidden	check_brand_0_asm_h             // -- Begin function check_brand_0_asm_h
	.globl	check_brand_0_asm_h
	.p2align	2
	.type	check_brand_0_asm_h,@function
check_brand_0_asm_h:                    // @check_brand_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	mov	x2, x21
	bl	JS_CheckBrand_GC
	tbnz	w0, #31, .LBB65_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB65_2:                               // %B2
	b	exception_asm_h
.Lfunc_end65:
	.size	check_brand_0_asm_h, .Lfunc_end65-check_brand_0_asm_h
                                        // -- End function
	.hidden	add_brand_0_asm_h               // -- Begin function add_brand_0_asm_h
	.globl	add_brand_0_asm_h
	.p2align	2
	.type	add_brand_0_asm_h,@function
add_brand_0_asm_h:                      // @add_brand_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	mov	x2, x21
	bl	JS_AddBrand_GC
	tbnz	w0, #31, .LBB66_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB66_2:                               // %B2
	b	exception_asm_h
.Lfunc_end66:
	.size	add_brand_0_asm_h, .Lfunc_end66-add_brand_0_asm_h
                                        // -- End function
	.hidden	return_async_0_asm_h            // -- Begin function return_async_0_asm_h
	.globl	return_async_0_asm_h
	.p2align	2
	.type	return_async_0_asm_h,@function
return_async_0_asm_h:                   // @return_async_0_asm_h
// %bb.0:                               // %B0
	str	x19, [x23, #48]
	mov	w0, #18                         // =0x12
	str	x20, [x23, #64]
	b	common_return_direct_asm_h
.Lfunc_end67:
	.size	return_async_0_asm_h, .Lfunc_end67-return_async_0_asm_h
                                        // -- End function
	.hidden	throw_0_asm_h                   // -- Begin function throw_0_asm_h
	.globl	throw_0_asm_h
	.p2align	2
	.type	throw_0_asm_h,@function
throw_0_asm_h:                          // @throw_0_asm_h
// %bb.0:                               // %B0
	ldr	x1, [x20, #-8]!
	mov	x0, x24
	str	x20, [x23, #64]
	bl	LEPUS_Throw
	b	exception_asm_h
.Lfunc_end68:
	.size	throw_0_asm_h, .Lfunc_end68-throw_0_asm_h
                                        // -- End function
	.hidden	throw_var_0_asm_h               // -- Begin function throw_var_0_asm_h
	.globl	throw_var_0_asm_h
	.p2align	2
	.type	throw_var_0_asm_h,@function
throw_var_0_asm_h:                      // @throw_var_0_asm_h
// %bb.0:                               // %B3
	ldrb	w8, [x19, #4]
	ldr	w2, [x19]
	str	x20, [x23, #64]
	cmp	w8, #1
	b.le	.LBB69_5
// %bb.1:                               // %B3
	cmp	w8, #2
	b.eq	.LBB69_8
// %bb.2:                               // %B3
	cmp	w8, #3
	b.eq	.LBB69_9
// %bb.3:                               // %B3
	cmp	w8, #4
	b.ne	.LBB69_11
// %bb.4:                               // %B8
	adrp	x1, .L__unnamed_5
	add	x1, x1, :lo12:.L__unnamed_5
	mov	x0, x24
	bl	LEPUS_ThrowTypeError
	b	exception_asm_h
.LBB69_5:                               // %B3
	cbz	w8, .LBB69_10
// %bb.6:                               // %B3
	cmp	w8, #1
	b.ne	.LBB69_11
// %bb.7:                               // %B5
	mov	x0, x24
	mov	w1, w2
	bl	JS_ThrowSyntaxErrorVarRedeclaration_GC
	b	exception_asm_h
.LBB69_8:                               // %B6
	mov	x0, x24
	mov	w1, w2
	bl	JS_ThrowReferenceErrorUninitialized_GC
	b	exception_asm_h
.LBB69_9:                               // %B7
	adrp	x1, .L__unnamed_6
	add	x1, x1, :lo12:.L__unnamed_6
	mov	x0, x24
	bl	LEPUS_ThrowReferenceError
	b	exception_asm_h
.LBB69_10:                              // %B4
	mov	x0, x24
	mov	w1, #16384                      // =0x4000
	bl	JS_ThrowTypeErrorReadOnly
	b	exception_asm_h
.LBB69_11:                              // %B9
	adrp	x1, .L__unnamed_7
	add	x1, x1, :lo12:.L__unnamed_7
	mov	x0, x24
	bl	LEPUS_ThrowInternalError
	b	exception_asm_h
.Lfunc_end69:
	.size	throw_var_0_asm_h, .Lfunc_end69-throw_var_0_asm_h
                                        // -- End function
	.hidden	eval_0_asm_h                    // -- Begin function eval_0_asm_h
	.globl	eval_0_asm_h
	.p2align	2
	.type	eval_0_asm_h,@function
eval_0_asm_h:                           // @eval_0_asm_h
// %bb.0:                               // %B1
	ldrh	w8, [x19]
	ldur	x2, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #64]
	sub	w1, w8, #1
	bl	prim_js_op_eval_gc
	cmp	x0, #130
	b.eq	.LBB70_2
// %bb.1:                               // %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB70_2:                               // %B2
	b	exception_asm_h
.Lfunc_end70:
	.size	eval_0_asm_h, .Lfunc_end70-eval_0_asm_h
                                        // -- End function
	.hidden	regexp_0_asm_h                  // -- Begin function regexp_0_asm_h
	.globl	regexp_0_asm_h
	.p2align	2
	.type	regexp_0_asm_h,@function
regexp_0_asm_h:                         // @regexp_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w1, #18                         // =0x12
	str	x20, [x23, #64]
	mov	x2, x22
	mov	x3, x21
	bl	js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	.LBB71_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB71_2:                               // %B2
	b	exception_asm_h
.Lfunc_end71:
	.size	regexp_0_asm_h, .Lfunc_end71-regexp_0_asm_h
                                        // -- End function
	.hidden	get_super_ctor_0_asm_h          // -- Begin function get_super_ctor_0_asm_h
	.globl	get_super_ctor_0_asm_h
	.p2align	2
	.type	get_super_ctor_0_asm_h,@function
get_super_ctor_0_asm_h:                 // @get_super_ctor_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	bl	primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	.LBB72_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB72_2:                               // %B2
	b	exception_asm_h
.Lfunc_end72:
	.size	get_super_ctor_0_asm_h, .Lfunc_end72-get_super_ctor_0_asm_h
                                        // -- End function
	.hidden	get_super_0_asm_h               // -- Begin function get_super_0_asm_h
	.globl	get_super_0_asm_h
	.p2align	2
	.type	get_super_0_asm_h,@function
get_super_0_asm_h:                      // @get_super_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	bl	LEPUS_GetPrototype
	cmp	x0, #130
	b.eq	.LBB73_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB73_2:                               // %B2
	b	exception_asm_h
.Lfunc_end73:
	.size	get_super_0_asm_h, .Lfunc_end73-get_super_0_asm_h
                                        // -- End function
	.hidden	import_0_asm_h                  // -- Begin function import_0_asm_h
	.globl	import_0_asm_h
	.p2align	2
	.type	import_0_asm_h,@function
import_0_asm_h:                         // @import_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	bl	js_dynamic_import
	cmp	x0, #130
	b.eq	.LBB74_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB74_2:                               // %B2
	b	exception_asm_h
.Lfunc_end74:
	.size	import_0_asm_h, .Lfunc_end74-import_0_asm_h
                                        // -- End function
	.hidden	check_var_0_asm_h               // -- Begin function check_var_0_asm_h
	.globl	check_var_0_asm_h
	.p2align	2
	.type	check_var_0_asm_h,@function
check_var_0_asm_h:                      // @check_var_0_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x23, #64]
	bl	JS_CheckGlobalVar_GC
	tbnz	w0, #31, .LBB75_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB75_2:                               // %B2
	b	exception_asm_h
.Lfunc_end75:
	.size	check_var_0_asm_h, .Lfunc_end75-check_var_0_asm_h
                                        // -- End function
	.hidden	get_var_undef_0_asm_h           // -- Begin function get_var_undef_0_asm_h
	.globl	get_var_undef_0_asm_h
	.p2align	2
	.type	get_var_undef_0_asm_h,@function
get_var_undef_0_asm_h:                  // @get_var_undef_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x24, #216]
	ldr	w9, [x19]
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	and	w11, w9, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, .LBB76_3
.LBB76_1:                               // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldr	w13, [x12, #44]
	cmp	w13, w9
	b.eq	.LBB76_10
// %bb.2:                               // %B8
                                        //   in Loop: Header=BB76_1 Depth=1
	ldur	w11, [x12, #40]
	and	w11, w11, #0x3ffffff
	cbnz	w11, .LBB76_1
.LBB76_3:                               // %B11
	ldr	x8, [x24, #208]
	mov	w10, #18                        // =0x12
.LBB76_4:                               // %B33
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB76_5 Depth 2
	ldr	x12, [x8, #8]
	ldr	w11, [x12, #12]
	and	w11, w9, w11
	mvn	w11, w11
	ldr	w11, [x12, w11, sxtw #2]
	cbz	w11, .LBB76_7
.LBB76_5:                               // %B22
                                        //   Parent Loop BB76_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w9
	b.eq	.LBB76_9
// %bb.6:                               // %B24
                                        //   in Loop: Header=BB76_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB76_5
.LBB76_7:                               // %B27
                                        //   in Loop: Header=BB76_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	.LBB76_13
// %bb.8:                               // %B30
                                        //   in Loop: Header=BB76_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB76_4
	b	.LBB76_11
.LBB76_9:                               // %B12
	lsr	w9, w13, #26
	tst	w9, #0x30
	b.ne	.LBB76_13
.LBB76_10:                              // %B7.sink.split
	lsl	w9, w11, #1
	ldr	x8, [x8, #16]
	sub	w9, w9, #2
	ldr	x10, [x8, w9, sxtw #3]
.LBB76_11:                              // %B7
	cmp	x10, #34
	b.eq	.LBB76_15
// %bb.12:                              // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x10
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB76_13:                              // %B17
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB76_16
// %bb.14:                              // %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB76_15:                              // %B3
	b	ThrowReferenceErrorUninitialized_asm_h
.LBB76_16:                              // %B18
	b	exception_asm_h
.Lfunc_end76:
	.size	get_var_undef_0_asm_h, .Lfunc_end76-get_var_undef_0_asm_h
                                        // -- End function
	.hidden	get_var_0_asm_h                 // -- Begin function get_var_0_asm_h
	.globl	get_var_0_asm_h
	.p2align	2
	.type	get_var_0_asm_h,@function
get_var_0_asm_h:                        // @get_var_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x24, #216]
	ldr	w9, [x19]
	ldr	x11, [x8, #8]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB77_3
.LBB77_1:                               // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #44]
	cmp	w13, w9
	b.eq	.LBB77_10
// %bb.2:                               // %B8
                                        //   in Loop: Header=BB77_1 Depth=1
	ldur	w10, [x12, #40]
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB77_1
.LBB77_3:                               // %B11
	ldr	x8, [x24, #208]
.LBB77_4:                               // %B32
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB77_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB77_7
.LBB77_5:                               // %B21
                                        //   Parent Loop BB77_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w9
	b.eq	.LBB77_9
// %bb.6:                               // %B23
                                        //   in Loop: Header=BB77_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB77_5
.LBB77_7:                               // %B26
                                        //   in Loop: Header=BB77_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB77_12
// %bb.8:                               // %B29
                                        //   in Loop: Header=BB77_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB77_4
	b	.LBB77_12
.LBB77_9:                               // %B12
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	.LBB77_12
.LBB77_10:                              // %B7
	lsl	w9, w10, #1
	ldr	x8, [x8, #16]
	sub	w9, w9, #2
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	.LBB77_14
// %bb.11:                              // %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB77_12:                              // %B16
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x20, [x23, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB77_15
// %bb.13:                              // %B18
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB77_14:                              // %B3
	b	ThrowReferenceErrorUninitialized_asm_h
.LBB77_15:                              // %B17
	b	exception_asm_h
.Lfunc_end77:
	.size	get_var_0_asm_h, .Lfunc_end77-get_var_0_asm_h
                                        // -- End function
	.hidden	put_var_0_asm_h                 // -- Begin function put_var_0_asm_h
	.globl	put_var_0_asm_h
	.p2align	2
	.type	put_var_0_asm_h,@function
put_var_0_asm_h:                        // @put_var_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	mov	w3, wzr
	str	x20, [x23, #64]
	mov	x2, x22
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB78_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB78_2:                               // %B2
	b	exception_asm_h
.Lfunc_end78:
	.size	put_var_0_asm_h, .Lfunc_end78-put_var_0_asm_h
                                        // -- End function
	.hidden	put_var_init_0_asm_h            // -- Begin function put_var_init_0_asm_h
	.globl	put_var_init_0_asm_h
	.p2align	2
	.type	put_var_init_0_asm_h,@function
put_var_init_0_asm_h:                   // @put_var_init_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x23, #64]
	mov	x2, x22
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB79_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB79_2:                               // %B2
	b	exception_asm_h
.Lfunc_end79:
	.size	put_var_init_0_asm_h, .Lfunc_end79-put_var_init_0_asm_h
                                        // -- End function
	.hidden	put_var_strict_0_asm_h          // -- Begin function put_var_strict_0_asm_h
	.globl	put_var_strict_0_asm_h
	.p2align	2
	.type	put_var_strict_0_asm_h,@function
put_var_strict_0_asm_h:                 // @put_var_strict_0_asm_h
// %bb.0:                               // %B5
	ldp	x22, x21, [x20, #-16]
	cmp	x22, #7
	b.ne	.LBB80_3
// %bb.1:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          // =0x2
	str	x20, [x23, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB80_4
// %bb.2:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB80_3:                               // %B6
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x23, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB80_4:                               // %B2
	b	exception_asm_h
.Lfunc_end80:
	.size	put_var_strict_0_asm_h, .Lfunc_end80-put_var_strict_0_asm_h
                                        // -- End function
	.hidden	get_ref_value_0_asm_h           // -- Begin function get_ref_value_0_asm_h
	.globl	get_ref_value_0_asm_h
	.p2align	2
	.type	get_ref_value_0_asm_h,@function
get_ref_value_0_asm_h:                  // @get_ref_value_0_asm_h
// %bb.0:                               // %B8
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	cmp	x22, #18
	b.eq	.LBB81_3
// %bb.1:                               // %B1
	mov	x1, x22
	mov	x2, x21
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB81_5
// %bb.2:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB81_3:                               // %B5
	mov	x1, x21
	bl	js_value_to_atom_gc
	cbz	w0, .LBB81_5
// %bb.4:                               // %B7
	mov	w1, w0
	mov	x0, x24
	str	x20, [x23, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB81_5:                               // %B6
	b	exception_asm_h
.Lfunc_end81:
	.size	get_ref_value_0_asm_h, .Lfunc_end81-get_ref_value_0_asm_h
                                        // -- End function
	.hidden	put_ref_value_0_asm_h           // -- Begin function put_ref_value_0_asm_h
	.globl	put_ref_value_0_asm_h
	.p2align	2
	.type	put_ref_value_0_asm_h,@function
put_ref_value_0_asm_h:                  // @put_ref_value_0_asm_h
// %bb.0:                               // %B12
	ldp	x1, x22, [x20, #-24]
	ldur	x21, [x20, #-8]
	cmp	x1, #18
	b.eq	.LBB82_3
.LBB82_1:                               // %B1
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	str	x20, [x23, #64]
	bl	JS_SetPropertyValue_GC
	tbnz	w0, #31, .LBB82_7
// %bb.2:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB82_3:                               // %B8
	ldr	w8, [x23, #60]
	tbnz	w8, #0, .LBB82_5
// %bb.4:                               // %B9
	ldr	x1, [x24, #208]
	b	.LBB82_1
.LBB82_5:                               // %B5
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB82_7
// %bb.6:                               // %B7
	mov	w1, w0
	mov	x0, x24
	str	x20, [x23, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB82_7:                               // %B2
	b	exception_asm_h
.Lfunc_end82:
	.size	put_ref_value_0_asm_h, .Lfunc_end82-put_ref_value_0_asm_h
                                        // -- End function
	.hidden	define_var_0_asm_h              // -- Begin function define_var_0_asm_h
	.globl	define_var_0_asm_h
	.p2align	2
	.type	define_var_0_asm_h,@function
define_var_0_asm_h:                     // @define_var_0_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x0, x24
	str	x20, [x23, #64]
	bl	JS_DefineGlobalVar_GC
	tbnz	w0, #31, .LBB83_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB83_2:                               // %B2
	b	exception_asm_h
.Lfunc_end83:
	.size	define_var_0_asm_h, .Lfunc_end83-define_var_0_asm_h
                                        // -- End function
	.hidden	check_define_var_0_asm_h        // -- Begin function check_define_var_0_asm_h
	.globl	check_define_var_0_asm_h
	.p2align	2
	.type	check_define_var_0_asm_h,@function
check_define_var_0_asm_h:               // @check_define_var_0_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x0, x24
	str	x20, [x23, #64]
	bl	JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, .LBB84_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB84_2:                               // %B2
	b	exception_asm_h
.Lfunc_end84:
	.size	check_define_var_0_asm_h, .Lfunc_end84-check_define_var_0_asm_h
                                        // -- End function
	.hidden	define_func_0_asm_h             // -- Begin function define_func_0_asm_h
	.globl	define_func_0_asm_h
	.p2align	2
	.type	define_func_0_asm_h,@function
define_func_0_asm_h:                    // @define_func_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	ldrb	w3, [x19, #4]
	str	x20, [x23, #64]
	mov	x2, x22
	bl	JS_DefineGlobalFunction_GC
	tbnz	w0, #31, .LBB85_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	sub	x20, x20, #8
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB85_2:                               // %B2
	b	exception_asm_h
.Lfunc_end85:
	.size	define_func_0_asm_h, .Lfunc_end85-define_func_0_asm_h
                                        // -- End function
	.hidden	get_field_0_asm_h               // -- Begin function get_field_0_asm_h
	.globl	get_field_0_asm_h
	.p2align	2
	.type	get_field_0_asm_h,@function
get_field_0_asm_h:                      // @get_field_0_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB86_10
// %bb.1:                               // %B25
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB86_2:                               // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB86_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB86_5
.LBB86_3:                               // %B1
                                        //   Parent Loop BB86_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w2
	b.eq	.LBB86_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB86_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB86_3
.LBB86_5:                               // %B14
                                        //   in Loop: Header=BB86_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB86_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB86_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB86_2
	b	.LBB86_9
.LBB86_7:                               // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB86_10
// %bb.8:                               // %B4
	lsl	w8, w10, #1
	ldr	x9, [x9, #16]
	sub	w8, w8, #2
	ldr	x8, [x9, w8, sxtw #3]
.LBB86_9:                               // %B6
	ldrb	w9, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB86_10:                              // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB86_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB86_12:                              // %B22
	b	exception_asm_h
.Lfunc_end86:
	.size	get_field_0_asm_h, .Lfunc_end86-get_field_0_asm_h
                                        // -- End function
	.hidden	get_field2_0_asm_h              // -- Begin function get_field2_0_asm_h
	.globl	get_field2_0_asm_h
	.p2align	2
	.type	get_field2_0_asm_h,@function
get_field2_0_asm_h:                     // @get_field2_0_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB87_10
// %bb.1:                               // %B25
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB87_2:                               // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB87_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB87_5
.LBB87_3:                               // %B1
                                        //   Parent Loop BB87_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w2
	b.eq	.LBB87_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB87_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB87_3
.LBB87_5:                               // %B14
                                        //   in Loop: Header=BB87_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB87_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB87_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB87_2
	b	.LBB87_9
.LBB87_7:                               // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB87_10
// %bb.8:                               // %B4
	lsl	w8, w10, #1
	ldr	x9, [x9, #16]
	sub	w8, w8, #2
	ldr	x8, [x9, w8, sxtw #3]
.LBB87_9:                               // %B6
	ldrb	w9, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB87_10:                              // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB87_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB87_12:                              // %B22
	b	exception_asm_h
.Lfunc_end87:
	.size	get_field2_0_asm_h, .Lfunc_end87-get_field2_0_asm_h
                                        // -- End function
	.hidden	put_field_0_asm_h               // -- Begin function put_field_0_asm_h
	.globl	put_field_0_asm_h
	.p2align	2
	.type	put_field_0_asm_h,@function
put_field_0_asm_h:                      // @put_field_0_asm_h
// %bb.0:                               // %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	ldr	w2, [x19]
	tst	x22, x8
	b.ne	.LBB88_17
// %bb.1:                               // %B45
	ldr	x9, [x22, #8]
	ldr	w8, [x9, #12]
	and	w8, w2, w8
	mvn	w8, w8
	ldr	w8, [x9, w8, sxtw #2]
	cbz	w8, .LBB88_4
.LBB88_2:                               // %B1
                                        // =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10, #40]
	cmp	w11, w2
	b.eq	.LBB88_13
// %bb.3:                               // %B12
                                        //   in Loop: Header=BB88_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, .LBB88_2
.LBB88_4:                               // %B17.preheader
	mov	x8, x22
.LBB88_5:                               // %B17
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB88_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x9, w10, sxtw #2]
	cbz	w10, .LBB88_8
.LBB88_6:                               // %B18
                                        //   Parent Loop BB88_5 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldr	w11, [x10, #44]
	cmp	w11, w2
	b.eq	.LBB88_17
// %bb.7:                               // %B20
                                        //   in Loop: Header=BB88_6 Depth=2
	ldur	w10, [x10, #40]
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB88_6
.LBB88_8:                               // %B30
                                        //   in Loop: Header=BB88_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	.LBB88_17
// %bb.9:                               // %B24
                                        //   in Loop: Header=BB88_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB88_5
// %bb.10:                              // %B27
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	.LBB88_17
// %bb.11:                              // %B34
	mov	x0, x24
	mov	x1, x22
	mov	w3, #7                          // =0x7
	str	x20, [x23, #64]
	bl	add_property_gc
	cbz	x0, .LBB88_19
// %bb.12:                              // %B38
	str	x21, [x0]
	b	.LBB88_15
.LBB88_13:                              // %B3
	mov	w9, #58                         // =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	.LBB88_17
// %bb.14:                              // %B7
	lsl	w8, w8, #1
	ldr	x9, [x22, #16]
	sub	w8, w8, #2
	str	x21, [x9, w8, sxtw #3]
.LBB88_15:                              // %B38
	ldrb	w8, [x24, #392]
	cbnz	w8, .LBB88_20
.LBB88_16:                              // %B37
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB88_17:                              // %B41
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	str	x20, [x23, #64]
	bl	JS_SetPropertyInternalImpl_GC
	tbz	w0, #31, .LBB88_16
// %bb.18:                              // %B42
	b	exception_asm_h
.LBB88_19:                              // %B35
	sub	x20, x20, #16
	b	exception_asm_h
.LBB88_20:                              // %B40
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end88:
	.size	put_field_0_asm_h, .Lfunc_end88-put_field_0_asm_h
                                        // -- End function
	.hidden	get_private_field_0_asm_h       // -- Begin function get_private_field_0_asm_h
	.globl	get_private_field_0_asm_h
	.p2align	2
	.type	get_private_field_0_asm_h,@function
get_private_field_0_asm_h:              // @get_private_field_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	mov	x2, x21
	bl	JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	.LBB89_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB89_2:                               // %B2
	b	exception_asm_h
.Lfunc_end89:
	.size	get_private_field_0_asm_h, .Lfunc_end89-get_private_field_0_asm_h
                                        // -- End function
	.hidden	put_private_field_0_asm_h       // -- Begin function put_private_field_0_asm_h
	.globl	put_private_field_0_asm_h
	.p2align	2
	.type	put_private_field_0_asm_h,@function
put_private_field_0_asm_h:              // @put_private_field_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	str	x20, [x23, #64]
	mov	x2, x21
	mov	x3, x22
	bl	JS_SetPrivateField_GC
	tbnz	w0, #31, .LBB90_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB90_2:                               // %B2
	b	exception_asm_h
.Lfunc_end90:
	.size	put_private_field_0_asm_h, .Lfunc_end90-put_private_field_0_asm_h
                                        // -- End function
	.hidden	define_private_field_0_asm_h    // -- Begin function define_private_field_0_asm_h
	.globl	define_private_field_0_asm_h
	.p2align	2
	.type	define_private_field_0_asm_h,@function
define_private_field_0_asm_h:           // @define_private_field_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	str	x20, [x23, #64]
	mov	x2, x22
	mov	x3, x21
	bl	JS_DefinePrivateField_GC
	tbnz	w0, #31, .LBB91_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB91_2:                               // %B2
	b	exception_asm_h
.Lfunc_end91:
	.size	define_private_field_0_asm_h, .Lfunc_end91-define_private_field_0_asm_h
                                        // -- End function
	.hidden	get_array_el_0_asm_h            // -- Begin function get_array_el_0_asm_h
	.globl	get_array_el_0_asm_h
	.p2align	2
	.type	get_array_el_0_asm_h,@function
get_array_el_0_asm_h:                   // @get_array_el_0_asm_h
// %bb.0:                               // %B33
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB92_15
// %bb.1:                               // %B33
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x8, x9
	b.ne	.LBB92_15
// %bb.2:                               // %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	.LBB92_15
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	.LBB92_5
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #16
	add	w8, w8, #242
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB92_5:                               // %B7
	tbnz	w21, #31, .LBB92_15
// %bb.6:                               // %B9.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
	orr	w12, w21, #0x80000000
.LBB92_7:                               // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB92_8 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	and	w11, w12, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, .LBB92_10
.LBB92_8:                               // %B10
                                        //   Parent Loop BB92_7 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x10, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w12
	b.eq	.LBB92_12
// %bb.9:                               // %B17
                                        //   in Loop: Header=BB92_8 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB92_8
.LBB92_10:                              // %B24
                                        //   in Loop: Header=BB92_7 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB92_15
// %bb.11:                              // %B21
                                        //   in Loop: Header=BB92_7 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB92_7
	b	.LBB92_14
.LBB92_12:                              // %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	.LBB92_15
// %bb.13:                              // %B13
	lsl	w8, w11, #1
	ldr	x9, [x9, #16]
	sub	w8, w8, #2
	ldr	x8, [x9, w8, sxtw #3]
.LBB92_14:                              // %B14
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB92_15:                              // %B30
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB92_17
// %bb.16:                              // %B32
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB92_17:                              // %B31
	b	exception_asm_h
.Lfunc_end92:
	.size	get_array_el_0_asm_h, .Lfunc_end92-get_array_el_0_asm_h
                                        // -- End function
	.hidden	get_array_el2_0_asm_h           // -- Begin function get_array_el2_0_asm_h
	.globl	get_array_el2_0_asm_h
	.p2align	2
	.type	get_array_el2_0_asm_h,@function
get_array_el2_0_asm_h:                  // @get_array_el2_0_asm_h
// %bb.0:                               // %B33
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB93_15
// %bb.1:                               // %B33
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x8, x9
	b.ne	.LBB93_15
// %bb.2:                               // %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	.LBB93_15
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	.LBB93_5
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #16
	add	w8, w8, #484
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB93_5:                               // %B7
	tbnz	w21, #31, .LBB93_15
// %bb.6:                               // %B9.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
	orr	w12, w21, #0x80000000
.LBB93_7:                               // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB93_8 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	and	w11, w12, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, .LBB93_10
.LBB93_8:                               // %B10
                                        //   Parent Loop BB93_7 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x10, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w12
	b.eq	.LBB93_12
// %bb.9:                               // %B17
                                        //   in Loop: Header=BB93_8 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB93_8
.LBB93_10:                              // %B24
                                        //   in Loop: Header=BB93_7 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB93_15
// %bb.11:                              // %B21
                                        //   in Loop: Header=BB93_7 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB93_7
	b	.LBB93_14
.LBB93_12:                              // %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	.LBB93_15
// %bb.13:                              // %B13
	lsl	w8, w11, #1
	ldr	x9, [x9, #16]
	sub	w8, w8, #2
	ldr	x8, [x9, w8, sxtw #3]
.LBB93_14:                              // %B14
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB93_15:                              // %B30
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB93_17
// %bb.16:                              // %B32
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB93_17:                              // %B31
	b	exception_asm_h
.Lfunc_end93:
	.size	get_array_el2_0_asm_h, .Lfunc_end93-get_array_el2_0_asm_h
                                        // -- End function
	.hidden	put_array_el_0_asm_h            // -- Begin function put_array_el_0_asm_h
	.globl	put_array_el_0_asm_h
	.p2align	2
	.type	put_array_el_0_asm_h,@function
put_array_el_0_asm_h:                   // @put_array_el_0_asm_h
// %bb.0:                               // %B63
	ldp	x1, x22, [x20, #-24]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	ldur	x21, [x20, #-8]
	tst	x1, x8
	b.ne	.LBB94_16
// %bb.1:                               // %B57
	ldrsh	w8, [x1, #6]
	cmp	w8, #2
	b.ne	.LBB94_6
// %bb.2:                               // %B1
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB94_16
// %bb.3:                               // %B50
	ldr	w8, [x1, #48]
	cmp	w22, w8
	b.hs	.LBB94_7
// %bb.4:                               // %B3
	ldr	x8, [x1, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #392]
	cbnz	w8, .LBB94_23
.LBB94_5:                               // %B56
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB94_6:                               // %B60
	cmp	w8, #30
	ccmp	w8, #20, #4, lt
	mov	w8, #32768                      // =0x8000
	csel	w4, wzr, w8, gt
	b	.LBB94_17
.LBB94_7:                               // %B8
	b.ne	.LBB94_16
// %bb.8:                               // %B46
	ldr	w9, [x1, #4]
	mov	w4, #32768                      // =0x8000
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	b.ne	.LBB94_17
// %bb.9:                               // %B46
	ubfx	w9, w9, #8, #1
	cbz	w9, .LBB94_17
// %bb.10:                              // %B47
	ldr	x9, [x1, #8]
.LBB94_11:                              // %B15
                                        // =>This Inner Loop Header: Depth=1
	ldr	x10, [x9, #32]
	cbz	x10, .LBB94_19
// %bb.12:                              // %B10
                                        //   in Loop: Header=BB94_11 Depth=1
	ldrh	w11, [x10, #6]
	ldr	x9, [x10, #8]
	cmp	w11, #2
	b.ne	.LBB94_14
// %bb.13:                              // %B12
                                        //   in Loop: Header=BB94_11 Depth=1
	ldr	w10, [x10, #4]
	ubfx	w10, w10, #11, #1
	cmp	w10, #1
	b.eq	.LBB94_11
	b	.LBB94_16
.LBB94_14:                              // %B10
                                        //   in Loop: Header=BB94_11 Depth=1
	cmp	w11, #1
	b.ne	.LBB94_16
// %bb.15:                              // %B42
                                        //   in Loop: Header=BB94_11 Depth=1
	ldrb	w10, [x9, #6]
	cbz	w10, .LBB94_11
.LBB94_16:
	mov	w4, #32768                      // =0x8000
.LBB94_17:                              // %B54
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	str	x20, [x23, #64]
	bl	JS_SetPropertyValue_GC
	tbz	w0, #31, .LBB94_5
// %bb.18:                              // %B55
	b	exception_asm_h
.LBB94_19:                              // %B33
	ldr	x9, [x1, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	.LBB94_21
// %bb.20:                              // %B33
	cmp	w9, w10
	b.hi	.LBB94_24
.LBB94_21:                              // %B30
	ldr	w10, [x1, #32]
	cmp	w9, w10
	b.hi	.LBB94_24
// %bb.22:                              // %B26
	ldr	x10, [x1, #40]
	str	w9, [x1, #48]
	str	x21, [x10, w8, sxtw #3]
	ldrb	w8, [x24, #392]
	cbz	w8, .LBB94_5
.LBB94_23:                              // %B29
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB94_24:                              // %B21
	mov	x0, x24
	mov	x2, x21
	mov	w3, #32768                      // =0x8000
	str	x20, [x23, #64]
	bl	add_fast_array_element_gc
	tbz	w0, #31, .LBB94_5
// %bb.25:                              // %B22
	b	exception_asm_h
.Lfunc_end94:
	.size	put_array_el_0_asm_h, .Lfunc_end94-put_array_el_0_asm_h
                                        // -- End function
	.hidden	get_super_value_0_asm_h         // -- Begin function get_super_value_0_asm_h
	.globl	get_super_value_0_asm_h
	.p2align	2
	.type	get_super_value_0_asm_h,@function
get_super_value_0_asm_h:                // @get_super_value_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x21
	bl	js_value_to_atom_gc
	cbz	w0, .LBB95_3
// %bb.1:                               // %B5
	ldur	x3, [x20, #-24]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	str	x20, [x23, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB95_3
// %bb.2:                               // %B7
	stur	x0, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB95_3:                               // %B6
	b	exception_asm_h
.Lfunc_end95:
	.size	get_super_value_0_asm_h, .Lfunc_end95-get_super_value_0_asm_h
                                        // -- End function
	.hidden	put_super_value_0_asm_h         // -- Begin function put_super_value_0_asm_h
	.globl	put_super_value_0_asm_h
	.p2align	2
	.type	put_super_value_0_asm_h,@function
put_super_value_0_asm_h:                // @put_super_value_0_asm_h
// %bb.0:                               // %B8
	sub	sp, sp, #16
	ldur	x9, [x20, #-24]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x9, x8
	b.eq	.LBB96_3
// %bb.1:                               // %B10
	mov	x0, x24
	str	x20, [x23, #64]
	bl	JS_ThrowTypeErrorNotAnObject
.LBB96_2:                               // %B6
	add	sp, sp, #16
	b	exception_asm_h
.LBB96_3:                               // %B1
	ldur	x1, [x20, #-16]
	mov	x0, x24
	str	x9, [sp, #8]                    // 8-byte Folded Spill
	str	x20, [x23, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB96_2
// %bb.4:                               // %B5
	ldur	x3, [x20, #-8]
	ldur	x4, [x20, #-32]
	mov	w2, w0
	ldr	x1, [sp, #8]                    // 8-byte Folded Reload
	mov	x0, x24
	mov	w5, #32768                      // =0x8000
	str	x20, [x23, #64]
	bl	JS_SetPropertyGeneric_GC
	tbnz	w0, #31, .LBB96_2
// %bb.5:                               // %B7
	ldrb	w8, [x19], #1
	sub	x20, x20, #32
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.Lfunc_end96:
	.size	put_super_value_0_asm_h, .Lfunc_end96-put_super_value_0_asm_h
                                        // -- End function
	.hidden	define_field_0_asm_h            // -- Begin function define_field_0_asm_h
	.globl	define_field_0_asm_h
	.p2align	2
	.type	define_field_0_asm_h,@function
define_field_0_asm_h:                   // @define_field_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldr	w2, [x19]
	mov	w4, #16391                      // =0x4007
	str	x20, [x23, #64]
	mov	x1, x22
	mov	x3, x21
	bl	LEPUS_DefinePropertyValue
	tbnz	w0, #31, .LBB97_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB97_2:                               // %B2
	b	exception_asm_h
.Lfunc_end97:
	.size	define_field_0_asm_h, .Lfunc_end97-define_field_0_asm_h
                                        // -- End function
	.hidden	set_name_0_asm_h                // -- Begin function set_name_0_asm_h
	.globl	set_name_0_asm_h
	.p2align	2
	.type	set_name_0_asm_h,@function
set_name_0_asm_h:                       // @set_name_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x23, #64]
	mov	x1, x22
	bl	JS_DefineObjectName
	tbnz	w0, #31, .LBB98_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB98_2:                               // %B2
	b	exception_asm_h
.Lfunc_end98:
	.size	set_name_0_asm_h, .Lfunc_end98-set_name_0_asm_h
                                        // -- End function
	.hidden	set_name_computed_0_asm_h       // -- Begin function set_name_computed_0_asm_h
	.globl	set_name_computed_0_asm_h
	.p2align	2
	.type	set_name_computed_0_asm_h,@function
set_name_computed_0_asm_h:              // @set_name_computed_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x23, #64]
	mov	x1, x21
	mov	x2, x22
	bl	JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, .LBB99_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB99_2:                               // %B2
	b	exception_asm_h
.Lfunc_end99:
	.size	set_name_computed_0_asm_h, .Lfunc_end99-set_name_computed_0_asm_h
                                        // -- End function
	.hidden	set_proto_0_asm_h               // -- Begin function set_proto_0_asm_h
	.globl	set_proto_0_asm_h
	.p2align	2
	.type	set_proto_0_asm_h,@function
set_proto_0_asm_h:                      // @set_proto_0_asm_h
// %bb.0:                               // %B6
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB100_3
// %bb.1:                               // %B6
	cmp	x21, #2
	b.eq	.LBB100_3
.LBB100_2:                              // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB100_3:                              // %B1
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x20, [x23, #64]
	bl	JS_SetPrototypeInternal_GC
	tbz	w0, #31, .LBB100_2
// %bb.4:                               // %B2
	b	exception_asm_h
.Lfunc_end100:
	.size	set_proto_0_asm_h, .Lfunc_end100-set_proto_0_asm_h
                                        // -- End function
	.hidden	set_home_object_0_asm_h         // -- Begin function set_home_object_0_asm_h
	.globl	set_home_object_0_asm_h
	.p2align	2
	.type	set_home_object_0_asm_h,@function
set_home_object_0_asm_h:                // @set_home_object_0_asm_h
// %bb.0:                               // %B0
	sub	sp, sp, #16
	mov	x8, x20
	ldur	x21, [x20, #-8]
	mov	x0, x24
	ldr	x22, [x8, #-16]!
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	mov	x1, x21
	str	x20, [x23, #64]
	mov	x2, x22
	bl	js_method_set_home_object_gc
	ldrb	w8, [x19], #1
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
.Lfunc_end101:
	.size	set_home_object_0_asm_h, .Lfunc_end101-set_home_object_0_asm_h
                                        // -- End function
	.hidden	define_array_el_0_asm_h         // -- Begin function define_array_el_0_asm_h
	.globl	define_array_el_0_asm_h
	.p2align	2
	.type	define_array_el_0_asm_h,@function
define_array_el_0_asm_h:                // @define_array_el_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	mov	w4, #16391                      // =0x4007
	str	x20, [x23, #64]
	mov	x2, x22
	mov	x3, x21
	bl	JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, .LBB102_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB102_2:                              // %B2
	b	exception_asm_h
.Lfunc_end102:
	.size	define_array_el_0_asm_h, .Lfunc_end102-define_array_el_0_asm_h
                                        // -- End function
	.hidden	append_0_asm_h                  // -- Begin function append_0_asm_h
	.globl	append_0_asm_h
	.p2align	2
	.type	append_0_asm_h,@function
append_0_asm_h:                         // @append_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #64]
	bl	js_append_enumerate_gc
	tbnz	w0, #31, .LBB103_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB103_2:                              // %B2
	b	exception_asm_h
.Lfunc_end103:
	.size	append_0_asm_h, .Lfunc_end103-append_0_asm_h
                                        // -- End function
	.hidden	copy_data_properties_0_asm_h    // -- Begin function copy_data_properties_0_asm_h
	.globl	copy_data_properties_0_asm_h
	.p2align	2
	.type	copy_data_properties_0_asm_h,@function
copy_data_properties_0_asm_h:           // @copy_data_properties_0_asm_h
// %bb.0:                               // %B1
	ldrb	w2, [x19]
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #64]
	bl	prim_js_copy_data_properties_gc
	tbnz	w0, #31, .LBB104_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB104_2:                              // %B2
	b	exception_asm_h
.Lfunc_end104:
	.size	copy_data_properties_0_asm_h, .Lfunc_end104-copy_data_properties_0_asm_h
                                        // -- End function
	.hidden	define_method_0_asm_h           // -- Begin function define_method_0_asm_h
	.globl	define_method_0_asm_h
	.p2align	2
	.type	define_method_0_asm_h,@function
define_method_0_asm_h:                  // @define_method_0_asm_h
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
	b.eq	.LBB105_3
// %bb.1:                               // %B15
	cmp	w8, #1
	b.ne	.LBB105_4
// %bb.2:                               // %B13
	mov	w8, #18                         // =0x12
	mov	w11, #2048                      // =0x800
	stp	x12, x8, [sp, #16]              // 16-byte Folded Spill
	b	.LBB105_5
.LBB105_3:
	mov	w8, #18                         // =0x12
	str	x12, [sp, #40]                  // 8-byte Folded Spill
	mov	w11, #8706                      // =0x2202
	str	x8, [sp, #24]                   // 8-byte Folded Spill
	mov	w8, #18                         // =0x12
	str	x8, [sp, #16]                   // 8-byte Folded Spill
	b	.LBB105_6
.LBB105_4:                              // %B14
	mov	w11, #4096                      // =0x1000
	mov	w8, #18                         // =0x12
	stp	x8, x12, [sp, #16]              // 16-byte Folded Spill
.LBB105_5:                              // %B10
	mov	w8, #18                         // =0x12
	str	x8, [sp, #40]                   // 8-byte Folded Spill
.LBB105_6:                              // %B10
	ldur	x1, [x20, #-8]
	orr	w3, w10, w11
	mov	x0, x24
	mov	w2, w19
	mov	x4, x9
	str	x20, [x23, #64]
	str	w11, [sp, #36]                  // 4-byte Folded Spill
	str	x20, [sp, #56]                  // 8-byte Folded Spill
	mov	w20, w19
	mov	x19, x9
	str	w10, [sp, #12]                  // 4-byte Folded Spill
	bl	js_method_set_properties_gc
	tbnz	w0, #31, .LBB105_9
// %bb.7:                               // %B5
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	ldr	w9, [sp, #12]                   // 4-byte Folded Reload
	mov	x0, x24
	ldp	x4, x5, [sp, #16]               // 16-byte Folded Reload
	mov	x1, x19
	str	x8, [x23, #64]
	ldr	w8, [sp, #36]                   // 4-byte Folded Reload
	mov	w2, w20
	ldr	x3, [sp, #40]                   // 8-byte Folded Reload
	orr	w6, w9, w8
	bl	LEPUS_DefineProperty
	tbnz	w0, #31, .LBB105_9
// %bb.8:                               // %B7
	ldr	x9, [sp, #48]                   // 8-byte Folded Reload
	ldrb	w8, [x9, #5]
	add	x19, x9, #6
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #64
	br	x1
.LBB105_9:                              // %B2
	ldp	x19, x20, [sp, #48]             // 16-byte Folded Reload
	add	sp, sp, #64
	b	exception_asm_h
.Lfunc_end105:
	.size	define_method_0_asm_h, .Lfunc_end105-define_method_0_asm_h
                                        // -- End function
	.hidden	define_method_computed_0_asm_h  // -- Begin function define_method_computed_0_asm_h
	.globl	define_method_computed_0_asm_h
	.p2align	2
	.type	define_method_computed_0_asm_h,@function
define_method_computed_0_asm_h:         // @define_method_computed_0_asm_h
// %bb.0:                               // %B8
	sub	sp, sp, #64
	ldur	x1, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	bl	js_value_to_atom_gc
	mov	w11, w0
	cbz	w11, .LBB106_11
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
	b.eq	.LBB106_4
// %bb.2:                               // %B11
	cmp	w8, #1
	b.ne	.LBB106_5
// %bb.3:                               // %B19
	mov	w8, #18                         // =0x12
	mov	w13, #2048                      // =0x800
	stp	x10, x8, [sp, #16]              // 16-byte Folded Spill
	b	.LBB106_6
.LBB106_4:
	mov	w8, #18                         // =0x12
	str	x10, [sp, #40]                  // 8-byte Folded Spill
	mov	w13, #8706                      // =0x2202
	str	x8, [sp, #24]                   // 8-byte Folded Spill
	mov	w8, #18                         // =0x12
	str	x8, [sp, #16]                   // 8-byte Folded Spill
	b	.LBB106_7
.LBB106_5:                              // %B20
	mov	w13, #4096                      // =0x1000
	mov	w8, #18                         // =0x12
	stp	x8, x10, [sp, #16]              // 16-byte Folded Spill
.LBB106_6:                              // %B16
	mov	w8, #18                         // =0x12
	str	x8, [sp, #40]                   // 8-byte Folded Spill
.LBB106_7:                              // %B16
	ldur	x1, [x20, #-8]
	orr	w3, w9, w13
	mov	x0, x24
	mov	w2, w11
	mov	x4, x12
	str	x20, [x23, #64]
	str	w13, [sp, #36]                  // 4-byte Folded Spill
	mov	x19, x12
	str	x20, [sp, #56]                  // 8-byte Folded Spill
	mov	w20, w11
	str	w9, [sp, #12]                   // 4-byte Folded Spill
	bl	js_method_set_properties_gc
	tbnz	w0, #31, .LBB106_10
// %bb.8:                               // %B5
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	ldr	w9, [sp, #12]                   // 4-byte Folded Reload
	mov	x0, x24
	ldp	x4, x5, [sp, #16]               // 16-byte Folded Reload
	mov	x1, x19
	str	x8, [x23, #64]
	ldr	w8, [sp, #36]                   // 4-byte Folded Reload
	mov	w2, w20
	ldr	x3, [sp, #40]                   // 8-byte Folded Reload
	orr	w6, w9, w8
	bl	LEPUS_DefineProperty
	tbnz	w0, #31, .LBB106_10
// %bb.9:                               // %B7
	ldr	x9, [sp, #48]                   // 8-byte Folded Reload
	ldrb	w8, [x9, #1]
	add	x19, x9, #2
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #64
	br	x1
.LBB106_10:                             // %B2
	ldp	x19, x20, [sp, #48]             // 16-byte Folded Reload
.LBB106_11:                             // %B9
	add	sp, sp, #64
	b	exception_asm_h
.Lfunc_end106:
	.size	define_method_computed_0_asm_h, .Lfunc_end106-define_method_computed_0_asm_h
                                        // -- End function
	.hidden	define_class_0_asm_h            // -- Begin function define_class_0_asm_h
	.globl	define_class_0_asm_h
	.p2align	2
	.type	define_class_0_asm_h,@function
define_class_0_asm_h:                   // @define_class_0_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #4]
	mov	x0, x24
	mov	x1, x20
	mov	x4, x26
	mov	x5, x23
	str	x20, [x23, #64]
	bl	js_op_define_class
	tbnz	w0, #31, .LBB107_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB107_2:                              // %B2
	b	exception_asm_h
.Lfunc_end107:
	.size	define_class_0_asm_h, .Lfunc_end107-define_class_0_asm_h
                                        // -- End function
	.hidden	get_loc_0_asm_h                 // -- Begin function get_loc_0_asm_h
	.globl	get_loc_0_asm_h
	.p2align	2
	.type	get_loc_0_asm_h,@function
get_loc_0_asm_h:                        // @get_loc_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #242
	ldr	x22, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end108:
	.size	get_loc_0_asm_h, .Lfunc_end108-get_loc_0_asm_h
                                        // -- End function
	.hidden	put_loc_0_asm_h                 // -- Begin function put_loc_0_asm_h
	.globl	put_loc_0_asm_h
	.p2align	2
	.type	put_loc_0_asm_h,@function
put_loc_0_asm_h:                        // @put_loc_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end109:
	.size	put_loc_0_asm_h, .Lfunc_end109-put_loc_0_asm_h
                                        // -- End function
	.hidden	set_loc_0_asm_h                 // -- Begin function set_loc_0_asm_h
	.globl	set_loc_0_asm_h
	.p2align	2
	.type	set_loc_0_asm_h,@function
set_loc_0_asm_h:                        // @set_loc_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end110:
	.size	set_loc_0_asm_h, .Lfunc_end110-set_loc_0_asm_h
                                        // -- End function
	.hidden	get_arg_0_asm_h                 // -- Begin function get_arg_0_asm_h
	.globl	get_arg_0_asm_h
	.p2align	2
	.type	get_arg_0_asm_h,@function
get_arg_0_asm_h:                        // @get_arg_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #242
	ldr	x22, [x28, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end111:
	.size	get_arg_0_asm_h, .Lfunc_end111-get_arg_0_asm_h
                                        // -- End function
	.hidden	put_arg_0_asm_h                 // -- Begin function put_arg_0_asm_h
	.globl	put_arg_0_asm_h
	.p2align	2
	.type	put_arg_0_asm_h,@function
put_arg_0_asm_h:                        // @put_arg_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end112:
	.size	put_arg_0_asm_h, .Lfunc_end112-put_arg_0_asm_h
                                        // -- End function
	.hidden	set_arg_0_asm_h                 // -- Begin function set_arg_0_asm_h
	.globl	set_arg_0_asm_h
	.p2align	2
	.type	set_arg_0_asm_h,@function
set_arg_0_asm_h:                        // @set_arg_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end113:
	.size	set_arg_0_asm_h, .Lfunc_end113-set_arg_0_asm_h
                                        // -- End function
	.hidden	get_var_ref_0_asm_h             // -- Begin function get_var_ref_0_asm_h
	.globl	get_var_ref_0_asm_h
	.p2align	2
	.type	get_var_ref_0_asm_h,@function
get_var_ref_0_asm_h:                    // @get_var_ref_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x8, [x26, x8, lsl #3]
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8, #32]
	ldr	x22, [x8]
	br	x1
.Lfunc_end114:
	.size	get_var_ref_0_asm_h, .Lfunc_end114-get_var_ref_0_asm_h
                                        // -- End function
	.hidden	put_var_ref_0_asm_h             // -- Begin function put_var_ref_0_asm_h
	.globl	put_var_ref_0_asm_h
	.p2align	2
	.type	put_var_ref_0_asm_h,@function
put_var_ref_0_asm_h:                    // @put_var_ref_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end115:
	.size	put_var_ref_0_asm_h, .Lfunc_end115-put_var_ref_0_asm_h
                                        // -- End function
	.hidden	set_var_ref_0_asm_h             // -- Begin function set_var_ref_0_asm_h
	.globl	set_var_ref_0_asm_h
	.p2align	2
	.type	set_var_ref_0_asm_h,@function
set_var_ref_0_asm_h:                    // @set_var_ref_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end116:
	.size	set_var_ref_0_asm_h, .Lfunc_end116-set_var_ref_0_asm_h
                                        // -- End function
	.hidden	set_loc_uninitialized_0_asm_h   // -- Begin function set_loc_uninitialized_0_asm_h
	.globl	set_loc_uninitialized_0_asm_h
	.p2align	2
	.type	set_loc_uninitialized_0_asm_h,@function
set_loc_uninitialized_0_asm_h:          // @set_loc_uninitialized_0_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	mov	w9, #34                         // =0x22
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end117:
	.size	set_loc_uninitialized_0_asm_h, .Lfunc_end117-set_loc_uninitialized_0_asm_h
                                        // -- End function
	.hidden	get_loc_check_0_asm_h           // -- Begin function get_loc_check_0_asm_h
	.globl	get_loc_check_0_asm_h
	.p2align	2
	.type	get_loc_check_0_asm_h,@function
get_loc_check_0_asm_h:                  // @get_loc_check_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	.LBB118_2
// %bb.1:                               // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB118_2:                              // %B3
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end118:
	.size	get_loc_check_0_asm_h, .Lfunc_end118-get_loc_check_0_asm_h
                                        // -- End function
	.hidden	put_loc_check_0_asm_h           // -- Begin function put_loc_check_0_asm_h
	.globl	put_loc_check_0_asm_h
	.p2align	2
	.type	put_loc_check_0_asm_h,@function
put_loc_check_0_asm_h:                  // @put_loc_check_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	.LBB119_2
// %bb.1:                               // %B4
	str	x22, [x27, w8, uxtw #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB119_2:                              // %B3
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end119:
	.size	put_loc_check_0_asm_h, .Lfunc_end119-put_loc_check_0_asm_h
                                        // -- End function
	.hidden	put_loc_check_init_0_asm_h      // -- Begin function put_loc_check_init_0_asm_h
	.globl	put_loc_check_init_0_asm_h
	.p2align	2
	.type	put_loc_check_init_0_asm_h,@function
put_loc_check_init_0_asm_h:             // @put_loc_check_init_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	.LBB120_2
// %bb.1:                               // %B4
	str	x22, [x27, w8, uxtw #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB120_2:                              // %B3
	b	ThrowThisReferenceError_asm_h
.Lfunc_end120:
	.size	put_loc_check_init_0_asm_h, .Lfunc_end120-put_loc_check_init_0_asm_h
                                        // -- End function
	.hidden	get_var_ref_check_0_asm_h       // -- Begin function get_var_ref_check_0_asm_h
	.globl	get_var_ref_check_0_asm_h
	.p2align	2
	.type	get_var_ref_check_0_asm_h,@function
get_var_ref_check_0_asm_h:              // @get_var_ref_check_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB121_2
// %bb.1:                               // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB121_2:                              // %B3
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end121:
	.size	get_var_ref_check_0_asm_h, .Lfunc_end121-get_var_ref_check_0_asm_h
                                        // -- End function
	.hidden	put_var_ref_check_0_asm_h       // -- Begin function put_var_ref_check_0_asm_h
	.globl	put_var_ref_check_0_asm_h
	.p2align	2
	.type	put_var_ref_check_0_asm_h,@function
put_var_ref_check_0_asm_h:              // @put_var_ref_check_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	.LBB122_2
// %bb.1:                               // %B4
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB122_2:                              // %B3
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end122:
	.size	put_var_ref_check_0_asm_h, .Lfunc_end122-put_var_ref_check_0_asm_h
                                        // -- End function
	.hidden	put_var_ref_check_init_0_asm_h  // -- Begin function put_var_ref_check_init_0_asm_h
	.globl	put_var_ref_check_init_0_asm_h
	.p2align	2
	.type	put_var_ref_check_init_0_asm_h,@function
put_var_ref_check_init_0_asm_h:         // @put_var_ref_check_init_0_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	.LBB123_2
// %bb.1:                               // %B4
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB123_2:                              // %B3
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end123:
	.size	put_var_ref_check_init_0_asm_h, .Lfunc_end123-put_var_ref_check_init_0_asm_h
                                        // -- End function
	.hidden	close_loc_0_asm_h               // -- Begin function close_loc_0_asm_h
	.globl	close_loc_0_asm_h
	.p2align	2
	.type	close_loc_0_asm_h,@function
close_loc_0_asm_h:                      // @close_loc_0_asm_h
// %bb.0:                               // %B0
	ldrh	w2, [x19]
	mov	x0, x24
	mov	x1, x23
	bl	close_lexical_var
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end124:
	.size	close_loc_0_asm_h, .Lfunc_end124-close_loc_0_asm_h
                                        // -- End function
	.hidden	if_false_0_asm_h                // -- Begin function if_false_0_asm_h
	.globl	if_false_0_asm_h
	.p2align	2
	.type	if_false_0_asm_h,@function
if_false_0_asm_h:                       // @if_false_0_asm_h
// %bb.0:                               // %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	.LBB125_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB125_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB125_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB125_6
	b	.LBB125_7
.LBB125_4:                              // %B23
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x9
	b.eq	.LBB125_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB125_7
.LBB125_6:                              // %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB125_7:                              // %B9
	mov	x9, #-281474976710656           // =0xffff000000000000
	cmp	x22, x9
	b.hs	.LBB125_13
// %bb.8:                               // %B11
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x9
	b.lo	.LBB125_10
.LBB125_9:                              // %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB125_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB125_13
// %bb.11:                              // %B17
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB125_6
	b.vs	.LBB125_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB125_9
	b	.LBB125_6
.LBB125_13:                             // %B15
	mov	x20, x8
	mov	x0, x22
	b	SlowToBoolean_asm_h
.Lfunc_end125:
	.size	if_false_0_asm_h, .Lfunc_end125-if_false_0_asm_h
                                        // -- End function
	.hidden	if_true_0_asm_h                 // -- Begin function if_true_0_asm_h
	.globl	if_true_0_asm_h
	.p2align	2
	.type	if_true_0_asm_h,@function
if_true_0_asm_h:                        // @if_true_0_asm_h
// %bb.0:                               // %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	.LBB126_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB126_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB126_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB126_6
	b	.LBB126_7
.LBB126_4:                              // %B23
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x9
	b.eq	.LBB126_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB126_7
.LBB126_6:                              // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB126_7:                              // %B9
	mov	x9, #-281474976710656           // =0xffff000000000000
	cmp	x22, x9
	b.hs	.LBB126_13
// %bb.8:                               // %B11
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x9
	b.lo	.LBB126_10
.LBB126_9:                              // %B19
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB126_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB126_13
// %bb.11:                              // %B17
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB126_6
	b.vs	.LBB126_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB126_9
	b	.LBB126_6
.LBB126_13:                             // %B15
	mov	x20, x8
	mov	x0, x22
	b	SlowToBoolean_asm_h
.Lfunc_end126:
	.size	if_true_0_asm_h, .Lfunc_end126-if_true_0_asm_h
                                        // -- End function
	.hidden	goto_0_asm_h                    // -- Begin function goto_0_asm_h
	.globl	goto_0_asm_h
	.p2align	2
	.type	goto_0_asm_h,@function
goto_0_asm_h:                           // @goto_0_asm_h
// %bb.0:                               // %B0
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end127:
	.size	goto_0_asm_h, .Lfunc_end127-goto_0_asm_h
                                        // -- End function
	.hidden	catch_0_asm_h                   // -- Begin function catch_0_asm_h
	.globl	catch_0_asm_h
	.p2align	2
	.type	catch_0_asm_h,@function
catch_0_asm_h:                          // @catch_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #4]
	ldr	w10, [x19]
	ldr	x8, [x8, #32]
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	mov	w9, #66                         // =0x42
	ldr	x8, [x8, #8]
	sub	x8, x19, x8
	add	x19, x19, #5
	add	x8, x8, x10
	orr	x22, x9, x8, lsl #16
	br	x1
.Lfunc_end128:
	.size	catch_0_asm_h, .Lfunc_end128-catch_0_asm_h
                                        // -- End function
	.hidden	gosub_0_asm_h                   // -- Begin function gosub_0_asm_h
	.globl	gosub_0_asm_h
	.p2align	2
	.type	gosub_0_asm_h,@function
gosub_0_asm_h:                          // @gosub_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #8]
	ldrsw	x9, [x19]
	ldr	x10, [x8, #32]
	add	x8, x19, x9
	ldrb	w9, [x8], #1
	ldr	w10, [x10, #8]
	add	w9, w9, #242
	sub	w10, w19, w10
	ldr	x1, [x25, w9, uxtw #3]
	mov	x19, x8
	add	w9, w10, #4
	orr	x22, x9, #0xfffe000000000000
	br	x1
.Lfunc_end129:
	.size	gosub_0_asm_h, .Lfunc_end129-gosub_0_asm_h
                                        // -- End function
	.hidden	ret_0_asm_h                     // -- Begin function ret_0_asm_h
	.globl	ret_0_asm_h
	.p2align	2
	.type	ret_0_asm_h,@function
ret_0_asm_h:                            // @ret_0_asm_h
// %bb.0:                               // %B6
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB130_3
// %bb.1:                               // %B1
	ldr	x8, [x23, #8]
	ldr	x8, [x8, #32]
	ldr	w9, [x8, #16]
	cmp	w22, w9
	b.ge	.LBB130_3
// %bb.2:                               // %B5
	ldr	x8, [x8, #8]
	sub	x20, x20, #8
	add	x19, x8, w22, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB130_3:                              // %B3
	adrp	x1, .L__unnamed_8
	add	x1, x1, :lo12:.L__unnamed_8
	mov	x0, x24
	str	x20, [x23, #64]
	bl	LEPUS_ThrowInternalError
	b	exception_asm_h
.Lfunc_end130:
	.size	ret_0_asm_h, .Lfunc_end130-ret_0_asm_h
                                        // -- End function
	.hidden	to_object_0_asm_h               // -- Begin function to_object_0_asm_h
	.globl	to_object_0_asm_h
	.p2align	2
	.type	to_object_0_asm_h,@function
to_object_0_asm_h:                      // @to_object_0_asm_h
// %bb.0:                               // %B6
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB131_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB131_2:                              // %B1
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #64]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB131_4
// %bb.3:                               // %B3
	mov	x22, x0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB131_4:                              // %B2
	b	exception_asm_h
.Lfunc_end131:
	.size	to_object_0_asm_h, .Lfunc_end131-to_object_0_asm_h
                                        // -- End function
	.hidden	to_propkey_0_asm_h              // -- Begin function to_propkey_0_asm_h
	.globl	to_propkey_0_asm_h
	.p2align	2
	.type	to_propkey_0_asm_h,@function
to_propkey_0_asm_h:                     // @to_propkey_0_asm_h
// %bb.0:                               // %B15
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	.LBB132_4
// %bb.1:                               // %B15
	mov	x9, #1                          // =0x1
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	.LBB132_4
// %bb.2:                               // %B15
	cmp	x8, x9
	b.eq	.LBB132_4
// %bb.3:                               // %B15
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB132_5
.LBB132_4:                              // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB132_5:                              // %B12
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB132_7
// %bb.6:                               // %B14
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB132_7:                              // %B13
	b	exception_asm_h
.Lfunc_end132:
	.size	to_propkey_0_asm_h, .Lfunc_end132-to_propkey_0_asm_h
                                        // -- End function
	.hidden	to_propkey2_0_asm_h             // -- Begin function to_propkey2_0_asm_h
	.globl	to_propkey2_0_asm_h
	.p2align	2
	.type	to_propkey2_0_asm_h,@function
to_propkey2_0_asm_h:                    // @to_propkey2_0_asm_h
// %bb.0:                               // %B18
	ldp	x22, x21, [x20, #-16]
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	.LBB133_3
// %bb.1:                               // %B19
	adrp	x1, .L__unnamed_9
	add	x1, x1, :lo12:.L__unnamed_9
	mov	x0, x24
	str	x20, [x23, #64]
	bl	LEPUS_ThrowTypeError
.LBB133_2:                              // %B16
	b	exception_asm_h
.LBB133_3:                              // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB133_7
// %bb.4:                               // %B2
	mov	x9, #1                          // =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	.LBB133_7
// %bb.5:                               // %B2
	cmp	x8, x9
	b.eq	.LBB133_7
// %bb.6:                               // %B2
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB133_8
.LBB133_7:                              // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB133_8:                              // %B15
	mov	x0, x24
	mov	x1, x21
	str	x20, [x23, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB133_2
// %bb.9:                               // %B17
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end133:
	.size	to_propkey2_0_asm_h, .Lfunc_end133-to_propkey2_0_asm_h
                                        // -- End function
	.hidden	with_get_var_0_asm_h            // -- Begin function with_get_var_0_asm_h
	.globl	with_get_var_0_asm_h
	.p2align	2
	.type	with_get_var_0_asm_h,@function
with_get_var_0_asm_h:                   // @with_get_var_0_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #113                        // =0x71
	str	x20, [x23, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB134_4
// %bb.1:                               // %B4
	cbz	w0, .LBB134_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB134_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB134_4:                              // %B2
	b	exception_asm_h
.Lfunc_end134:
	.size	with_get_var_0_asm_h, .Lfunc_end134-with_get_var_0_asm_h
                                        // -- End function
	.hidden	with_put_var_0_asm_h            // -- Begin function with_put_var_0_asm_h
	.globl	with_put_var_0_asm_h
	.p2align	2
	.type	with_put_var_0_asm_h,@function
with_put_var_0_asm_h:                   // @with_put_var_0_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #114                        // =0x72
	str	x20, [x23, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB135_4
// %bb.1:                               // %B4
	cbz	w0, .LBB135_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	sub	x20, x20, #16
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB135_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB135_4:                              // %B2
	b	exception_asm_h
.Lfunc_end135:
	.size	with_put_var_0_asm_h, .Lfunc_end135-with_put_var_0_asm_h
                                        // -- End function
	.hidden	with_delete_var_0_asm_h         // -- Begin function with_delete_var_0_asm_h
	.globl	with_delete_var_0_asm_h
	.p2align	2
	.type	with_delete_var_0_asm_h,@function
with_delete_var_0_asm_h:                // @with_delete_var_0_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #115                        // =0x73
	str	x20, [x23, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB136_4
// %bb.1:                               // %B4
	cbz	w0, .LBB136_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB136_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB136_4:                              // %B2
	b	exception_asm_h
.Lfunc_end136:
	.size	with_delete_var_0_asm_h, .Lfunc_end136-with_delete_var_0_asm_h
                                        // -- End function
	.hidden	with_make_ref_0_asm_h           // -- Begin function with_make_ref_0_asm_h
	.globl	with_make_ref_0_asm_h
	.p2align	2
	.type	with_make_ref_0_asm_h,@function
with_make_ref_0_asm_h:                  // @with_make_ref_0_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #116                        // =0x74
	str	x20, [x23, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB137_4
// %bb.1:                               // %B4
	cbz	w0, .LBB137_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB137_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB137_4:                              // %B2
	b	exception_asm_h
.Lfunc_end137:
	.size	with_make_ref_0_asm_h, .Lfunc_end137-with_make_ref_0_asm_h
                                        // -- End function
	.hidden	with_get_ref_0_asm_h            // -- Begin function with_get_ref_0_asm_h
	.globl	with_get_ref_0_asm_h
	.p2align	2
	.type	with_get_ref_0_asm_h,@function
with_get_ref_0_asm_h:                   // @with_get_ref_0_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #117                        // =0x75
	str	x20, [x23, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB138_4
// %bb.1:                               // %B4
	cbz	w0, .LBB138_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB138_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB138_4:                              // %B2
	b	exception_asm_h
.Lfunc_end138:
	.size	with_get_ref_0_asm_h, .Lfunc_end138-with_get_ref_0_asm_h
                                        // -- End function
	.hidden	with_get_ref_undef_0_asm_h      // -- Begin function with_get_ref_undef_0_asm_h
	.globl	with_get_ref_undef_0_asm_h
	.p2align	2
	.type	with_get_ref_undef_0_asm_h,@function
with_get_ref_undef_0_asm_h:             // @with_get_ref_undef_0_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #118                        // =0x76
	str	x20, [x23, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB139_4
// %bb.1:                               // %B4
	cbz	w0, .LBB139_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB139_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB139_4:                              // %B2
	b	exception_asm_h
.Lfunc_end139:
	.size	with_get_ref_undef_0_asm_h, .Lfunc_end139-with_get_ref_undef_0_asm_h
                                        // -- End function
	.hidden	make_loc_ref_0_asm_h            // -- Begin function make_loc_ref_0_asm_h
	.globl	make_loc_ref_0_asm_h
	.p2align	2
	.type	make_loc_ref_0_asm_h,@function
make_loc_ref_0_asm_h:                   // @make_loc_ref_0_asm_h
// %bb.0:                               // %B16
	sub	sp, sp, #16
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x23, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.eq	.LBB140_6
// %bb.1:                               // %B1
	mov	w8, #18                         // =0x12
	mov	x1, x23
	mov	w3, wzr
	stp	x0, x8, [x20], #16
	mov	x0, x24
	ldrh	w2, [x19, #4]
	str	x20, [x23, #64]
	bl	get_var_ref
	mov	x8, x0
	cbz	x8, .LBB140_6
// %bb.2:                               // %B6
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #34                         // =0x22
	str	x20, [x23, #64]
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	bl	add_property_gc
	ldr	x9, [sp, #8]                    // 8-byte Folded Reload
	cbz	x0, .LBB140_6
// %bb.3:                               // %B9
	str	x9, [x0]
	ldrb	w8, [x24, #392]
	cbnz	w8, .LBB140_7
.LBB140_4:                              // %B13
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB140_6
// %bb.5:                               // %B15
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB140_6:                              // %B14
	add	sp, sp, #16
	b	exception_asm_h
.LBB140_7:                              // %B12
	mov	x0, x9
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	b	.LBB140_4
.Lfunc_end140:
	.size	make_loc_ref_0_asm_h, .Lfunc_end140-make_loc_ref_0_asm_h
                                        // -- End function
	.hidden	make_arg_ref_0_asm_h            // -- Begin function make_arg_ref_0_asm_h
	.globl	make_arg_ref_0_asm_h
	.p2align	2
	.type	make_arg_ref_0_asm_h,@function
make_arg_ref_0_asm_h:                   // @make_arg_ref_0_asm_h
// %bb.0:                               // %B16
	sub	sp, sp, #16
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x23, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.eq	.LBB141_6
// %bb.1:                               // %B1
	mov	w8, #18                         // =0x12
	mov	x1, x23
	mov	w3, #1                          // =0x1
	stp	x0, x8, [x20], #16
	mov	x0, x24
	ldrh	w2, [x19, #4]
	str	x20, [x23, #64]
	bl	get_var_ref
	mov	x8, x0
	cbz	x8, .LBB141_6
// %bb.2:                               // %B6
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #34                         // =0x22
	str	x20, [x23, #64]
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	bl	add_property_gc
	ldr	x9, [sp, #8]                    // 8-byte Folded Reload
	cbz	x0, .LBB141_6
// %bb.3:                               // %B9
	str	x9, [x0]
	ldrb	w8, [x24, #392]
	cbnz	w8, .LBB141_7
.LBB141_4:                              // %B13
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB141_6
// %bb.5:                               // %B15
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB141_6:                              // %B14
	add	sp, sp, #16
	b	exception_asm_h
.LBB141_7:                              // %B12
	mov	x0, x9
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	b	.LBB141_4
.Lfunc_end141:
	.size	make_arg_ref_0_asm_h, .Lfunc_end141-make_arg_ref_0_asm_h
                                        // -- End function
	.hidden	make_var_ref_ref_0_asm_h        // -- Begin function make_var_ref_ref_0_asm_h
	.globl	make_var_ref_ref_0_asm_h
	.p2align	2
	.type	make_var_ref_ref_0_asm_h,@function
make_var_ref_ref_0_asm_h:               // @make_var_ref_ref_0_asm_h
// %bb.0:                               // %B12
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x23, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.eq	.LBB142_5
// %bb.1:                               // %B1
	mov	x1, x0
	mov	w8, #18                         // =0x12
	mov	x0, x24
	stp	x1, x8, [x20], #16
	mov	w3, #34                         // =0x22
	ldr	w2, [x19]
	str	x20, [x23, #64]
	bl	add_property_gc
	cbz	x0, .LBB142_5
// %bb.2:                               // %B4
	ldrh	w8, [x19, #4]
	ldr	x8, [x26, x8, lsl #3]
	str	x8, [x0]
	ldrb	w9, [x24, #392]
	cbnz	w9, .LBB142_6
.LBB142_3:                              // %B9
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB142_5
// %bb.4:                               // %B11
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB142_5:                              // %B10
	b	exception_asm_h
.LBB142_6:                              // %B7
	mov	x0, x8
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	b	.LBB142_3
.Lfunc_end142:
	.size	make_var_ref_ref_0_asm_h, .Lfunc_end142-make_var_ref_ref_0_asm_h
                                        // -- End function
	.hidden	make_var_ref_0_asm_h            // -- Begin function make_var_ref_0_asm_h
	.globl	make_var_ref_0_asm_h
	.p2align	2
	.type	make_var_ref_0_asm_h,@function
make_var_ref_0_asm_h:                   // @make_var_ref_0_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x20
	str	x20, [x23, #64]
	bl	JS_GetGlobalVarRef_GC
	tbnz	w0, #31, .LBB143_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB143_2:                              // %B2
	b	exception_asm_h
.Lfunc_end143:
	.size	make_var_ref_0_asm_h, .Lfunc_end143-make_var_ref_0_asm_h
                                        // -- End function
	.hidden	for_in_start_0_asm_h            // -- Begin function for_in_start_0_asm_h
	.globl	for_in_start_0_asm_h
	.p2align	2
	.type	for_in_start_0_asm_h,@function
for_in_start_0_asm_h:                   // @for_in_start_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	bl	prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	.LBB144_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB144_2:                              // %B2
	b	exception_asm_h
.Lfunc_end144:
	.size	for_in_start_0_asm_h, .Lfunc_end144-for_in_start_0_asm_h
                                        // -- End function
	.hidden	for_of_start_0_asm_h            // -- Begin function for_of_start_0_asm_h
	.globl	for_of_start_0_asm_h
	.p2align	2
	.type	for_of_start_0_asm_h,@function
for_of_start_0_asm_h:                   // @for_of_start_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	mov	w2, wzr
	str	x20, [x23, #64]
	bl	js_for_of_start_gc
	tbnz	w0, #31, .LBB145_2
// %bb.1:                               // %B3
	mov	w8, #66                         // =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB145_2:                              // %B2
	b	exception_asm_h
.Lfunc_end145:
	.size	for_of_start_0_asm_h, .Lfunc_end145-for_of_start_0_asm_h
                                        // -- End function
	.hidden	for_await_of_start_0_asm_h      // -- Begin function for_await_of_start_0_asm_h
	.globl	for_await_of_start_0_asm_h
	.p2align	2
	.type	for_await_of_start_0_asm_h,@function
for_await_of_start_0_asm_h:             // @for_await_of_start_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	mov	w2, #1                          // =0x1
	str	x20, [x23, #64]
	bl	js_for_of_start_gc
	tbnz	w0, #31, .LBB146_2
// %bb.1:                               // %B3
	mov	w8, #66                         // =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB146_2:                              // %B2
	b	exception_asm_h
.Lfunc_end146:
	.size	for_await_of_start_0_asm_h, .Lfunc_end146-for_await_of_start_0_asm_h
                                        // -- End function
	.hidden	for_in_next_0_asm_h             // -- Begin function for_in_next_0_asm_h
	.globl	for_in_next_0_asm_h
	.p2align	2
	.type	for_in_next_0_asm_h,@function
for_in_next_0_asm_h:                    // @for_in_next_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #64]
	bl	js_for_in_next_gc
	tbnz	w0, #31, .LBB147_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB147_2:                              // %B2
	b	exception_asm_h
.Lfunc_end147:
	.size	for_in_next_0_asm_h, .Lfunc_end147-for_in_next_0_asm_h
                                        // -- End function
	.hidden	for_of_next_0_asm_h             // -- Begin function for_of_next_0_asm_h
	.globl	for_of_next_0_asm_h
	.p2align	2
	.type	for_of_next_0_asm_h,@function
for_of_next_0_asm_h:                    // @for_of_next_0_asm_h
// %bb.0:                               // %B1
	ldrb	w9, [x19]
	mov	w8, #-3                         // =0xfffffffd
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #64]
	sub	w2, w8, w9
	bl	js_for_of_next_gc
	tbnz	w0, #31, .LBB148_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB148_2:                              // %B2
	b	exception_asm_h
.Lfunc_end148:
	.size	for_of_next_0_asm_h, .Lfunc_end148-for_of_next_0_asm_h
                                        // -- End function
	.hidden	for_await_of_next_0_asm_h       // -- Begin function for_await_of_next_0_asm_h
	.globl	for_await_of_next_0_asm_h
	.p2align	2
	.type	for_await_of_next_0_asm_h,@function
for_await_of_next_0_asm_h:              // @for_await_of_next_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #64]
	bl	js_for_await_of_next_gc
	tbnz	w0, #31, .LBB149_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB149_2:                              // %B2
	b	exception_asm_h
.Lfunc_end149:
	.size	for_await_of_next_0_asm_h, .Lfunc_end149-for_await_of_next_0_asm_h
                                        // -- End function
	.hidden	iterator_get_value_done_0_asm_h // -- Begin function iterator_get_value_done_0_asm_h
	.globl	iterator_get_value_done_0_asm_h
	.p2align	2
	.type	iterator_get_value_done_0_asm_h,@function
iterator_get_value_done_0_asm_h:        // @iterator_get_value_done_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #64]
	bl	js_iterator_get_value_done_gc
	tbnz	w0, #31, .LBB150_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB150_2:                              // %B2
	b	exception_asm_h
.Lfunc_end150:
	.size	iterator_get_value_done_0_asm_h, .Lfunc_end150-iterator_get_value_done_0_asm_h
                                        // -- End function
	.hidden	iterator_close_0_asm_h          // -- Begin function iterator_close_0_asm_h
	.globl	iterator_close_0_asm_h
	.p2align	2
	.type	iterator_close_0_asm_h,@function
iterator_close_0_asm_h:                 // @iterator_close_0_asm_h
// %bb.0:                               // %B6
	ldur	x1, [x20, #-24]
	sub	x20, x20, #16
	cmp	x1, #18
	b.eq	.LBB151_2
// %bb.1:                               // %B1
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #64]
	bl	JS_IteratorClose
	tbnz	w0, #31, .LBB151_3
.LBB151_2:                              // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB151_3:                              // %B2
	b	exception_asm_h
.Lfunc_end151:
	.size	iterator_close_0_asm_h, .Lfunc_end151-iterator_close_0_asm_h
                                        // -- End function
	.hidden	iterator_close_return_0_asm_h   // -- Begin function iterator_close_return_0_asm_h
	.globl	iterator_close_return_0_asm_h
	.p2align	2
	.type	iterator_close_return_0_asm_h,@function
iterator_close_return_0_asm_h:          // @iterator_close_return_0_asm_h
// %bb.0:                               // %B0
	ldr	x9, [x23, #8]
	ldr	x8, [x20, #-8]!
	mov	w10, #247                       // =0xf7
	ldr	x9, [x9, #32]
	ldrh	w9, [x9, #42]
	add	x9, x27, x9, lsl #3
	b	.LBB152_2
.LBB152_1:                              // %B10
                                        //   in Loop: Header=BB152_2 Depth=1
	sub	x20, x20, #8
.LBB152_2:                              // %B2
                                        // =>This Inner Loop Header: Depth=1
	cmp	x20, x9
	b.le	.LBB152_5
// %bb.3:                               // %B4
                                        //   in Loop: Header=BB152_2 Depth=1
	ldur	x11, [x20, #-8]
	tst	x11, #0xffff000000000000
	b.ne	.LBB152_1
// %bb.4:                               // %B4
                                        //   in Loop: Header=BB152_2 Depth=1
	and	x11, x11, x10
	cmp	x11, #66
	b.ne	.LBB152_1
.LBB152_5:                              // %B7
	add	x9, x9, #24
	cmp	x20, x9
	add	x20, x20, #8
	b.lt	.LBB152_7
// %bb.6:                               // %B9
	ldur	x9, [x20, #-16]
	ldur	q0, [x20, #-32]
	stur	x8, [x20, #-32]
	stur	x9, [x20, #-8]
	stur	q0, [x20, #-24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB152_7:                              // %B8
	adrp	x1, .L__unnamed_10
	add	x1, x1, :lo12:.L__unnamed_10
	mov	x0, x24
	str	x20, [x23, #64]
	bl	LEPUS_ThrowInternalError
	b	exception_asm_h
.Lfunc_end152:
	.size	iterator_close_return_0_asm_h, .Lfunc_end152-iterator_close_return_0_asm_h
                                        // -- End function
	.hidden	async_iterator_close_0_asm_h    // -- Begin function async_iterator_close_0_asm_h
	.globl	async_iterator_close_0_asm_h
	.p2align	2
	.type	async_iterator_close_0_asm_h,@function
async_iterator_close_0_asm_h:           // @async_iterator_close_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #64]
	bl	prim_js_async_iterator_close_gc
	tbnz	w0, #31, .LBB153_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB153_2:                              // %B2
	b	exception_asm_h
.Lfunc_end153:
	.size	async_iterator_close_0_asm_h, .Lfunc_end153-async_iterator_close_0_asm_h
                                        // -- End function
	.hidden	async_iterator_next_0_asm_h     // -- Begin function async_iterator_next_0_asm_h
	.globl	async_iterator_next_0_asm_h
	.p2align	2
	.type	async_iterator_next_0_asm_h,@function
async_iterator_next_0_asm_h:            // @async_iterator_next_0_asm_h
// %bb.0:                               // %B1
	ldp	x2, x1, [x20, #-32]
	sub	x4, x20, #8
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x23, #64]
	bl	LEPUS_Call
	cmp	x0, #130
	b.eq	.LBB154_2
// %bb.1:                               // %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB154_2:                              // %B2
	b	exception_asm_h
.Lfunc_end154:
	.size	async_iterator_next_0_asm_h, .Lfunc_end154-async_iterator_next_0_asm_h
                                        // -- End function
	.hidden	async_iterator_get_0_asm_h      // -- Begin function async_iterator_get_0_asm_h
	.globl	async_iterator_get_0_asm_h
	.p2align	2
	.type	async_iterator_get_0_asm_h,@function
async_iterator_get_0_asm_h:             // @async_iterator_get_0_asm_h
// %bb.0:                               // %B1
	ldrb	w2, [x19]
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #64]
	bl	prim_js_async_iterator_get_gc
	tbnz	w0, #31, .LBB155_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB155_2:                              // %B2
	b	exception_asm_h
.Lfunc_end155:
	.size	async_iterator_get_0_asm_h, .Lfunc_end155-async_iterator_get_0_asm_h
                                        // -- End function
	.hidden	initial_yield_0_asm_h           // -- Begin function initial_yield_0_asm_h
	.globl	initial_yield_0_asm_h
	.p2align	2
	.type	initial_yield_0_asm_h,@function
initial_yield_0_asm_h:                  // @initial_yield_0_asm_h
// %bb.0:                               // %B0
	str	x19, [x23, #48]
	mov	w0, #18                         // =0x12
	str	x20, [x23, #64]
	b	common_return_direct_asm_h
.Lfunc_end156:
	.size	initial_yield_0_asm_h, .Lfunc_end156-initial_yield_0_asm_h
                                        // -- End function
	.hidden	yield_0_asm_h                   // -- Begin function yield_0_asm_h
	.globl	yield_0_asm_h
	.p2align	2
	.type	yield_0_asm_h,@function
yield_0_asm_h:                          // @yield_0_asm_h
// %bb.0:                               // %B0
	str	x19, [x23, #48]
	mov	x0, #-562949953421311           // =0xfffe000000000001
	str	x20, [x23, #64]
	b	common_return_direct_asm_h
.Lfunc_end157:
	.size	yield_0_asm_h, .Lfunc_end157-yield_0_asm_h
                                        // -- End function
	.hidden	yield_star_0_asm_h              // -- Begin function yield_star_0_asm_h
	.globl	yield_star_0_asm_h
	.p2align	2
	.type	yield_star_0_asm_h,@function
yield_star_0_asm_h:                     // @yield_star_0_asm_h
// %bb.0:                               // %B0
	mov	x0, #2                          // =0x2
	str	x19, [x23, #48]
	str	x20, [x23, #64]
	movk	x0, #65534, lsl #48
	b	common_return_direct_asm_h
.Lfunc_end158:
	.size	yield_star_0_asm_h, .Lfunc_end158-yield_star_0_asm_h
                                        // -- End function
	.hidden	async_yield_star_0_asm_h        // -- Begin function async_yield_star_0_asm_h
	.globl	async_yield_star_0_asm_h
	.p2align	2
	.type	async_yield_star_0_asm_h,@function
async_yield_star_0_asm_h:               // @async_yield_star_0_asm_h
// %bb.0:                               // %B0
	mov	x0, #2                          // =0x2
	str	x19, [x23, #48]
	str	x20, [x23, #64]
	movk	x0, #65534, lsl #48
	b	common_return_direct_asm_h
.Lfunc_end159:
	.size	async_yield_star_0_asm_h, .Lfunc_end159-async_yield_star_0_asm_h
                                        // -- End function
	.hidden	await_0_asm_h                   // -- Begin function await_0_asm_h
	.globl	await_0_asm_h
	.p2align	2
	.type	await_0_asm_h,@function
await_0_asm_h:                          // @await_0_asm_h
// %bb.0:                               // %B0
	str	x19, [x23, #48]
	mov	x0, #-562949953421312           // =0xfffe000000000000
	str	x20, [x23, #64]
	b	common_return_direct_asm_h
.Lfunc_end160:
	.size	await_0_asm_h, .Lfunc_end160-await_0_asm_h
                                        // -- End function
	.hidden	neg_0_asm_h                     // -- Begin function neg_0_asm_h
	.globl	neg_0_asm_h
	.p2align	2
	.type	neg_0_asm_h,@function
neg_0_asm_h:                            // @neg_0_asm_h
// %bb.0:                               // %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB161_3
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB161_6
// %bb.2:                               // %B13
	orr	w8, w22, #0x80000000
	mov	w9, #-2147483648                // =0x80000000
	cmp	w8, w9
	b.ne	.LBB161_5
.LBB161_3:                              // %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        // =0x8c
	str	x20, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB161_8
// %bb.4:                               // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB161_5:                              // %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB161_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB161_3
// %bb.7:                               // %B7
	movi	d0, #0000000000000000
	add	x8, x22, x8
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	fsub	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
.LBB161_8:                              // %B17
	b	exception_asm_h
.Lfunc_end161:
	.size	neg_0_asm_h, .Lfunc_end161-neg_0_asm_h
                                        // -- End function
	.hidden	plus_0_asm_h                    // -- Begin function plus_0_asm_h
	.globl	plus_0_asm_h
	.p2align	2
	.type	plus_0_asm_h,@function
plus_0_asm_h:                           // @plus_0_asm_h
// %bb.0:                               // %B13
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB162_4
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB162_3
.LBB162_2:                              // %B7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB162_3:                              // %B3
	tst	x22, #0xfffe000000000000
	b.ne	.LBB162_2
.LBB162_4:                              // %B10
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        // =0x8d
	str	x20, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB162_6
// %bb.5:                               // %B12
	mov	x22, x0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB162_6:                              // %B11
	b	exception_asm_h
.Lfunc_end162:
	.size	plus_0_asm_h, .Lfunc_end162-plus_0_asm_h
                                        // -- End function
	.hidden	dec_0_asm_h                     // -- Begin function dec_0_asm_h
	.globl	dec_0_asm_h
	.p2align	2
	.type	dec_0_asm_h,@function
dec_0_asm_h:                            // @dec_0_asm_h
// %bb.0:                               // %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB163_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB163_4
// %bb.2:                               // %B13
	subs	w8, w22, #1
	b.vs	.LBB163_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB163_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB163_6
// %bb.5:                               // %B7
	add	x8, x22, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
.LBB163_6:                              // %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        // =0x8e
	str	x20, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB163_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB163_8:                              // %B17
	b	exception_asm_h
.Lfunc_end163:
	.size	dec_0_asm_h, .Lfunc_end163-dec_0_asm_h
                                        // -- End function
	.hidden	inc_0_asm_h                     // -- Begin function inc_0_asm_h
	.globl	inc_0_asm_h
	.p2align	2
	.type	inc_0_asm_h,@function
inc_0_asm_h:                            // @inc_0_asm_h
// %bb.0:                               // %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB164_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB164_4
// %bb.2:                               // %B13
	adds	w8, w22, #1
	b.vs	.LBB164_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB164_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB164_6
// %bb.5:                               // %B7
	add	x8, x22, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
.LBB164_6:                              // %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        // =0x8f
	str	x20, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB164_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB164_8:                              // %B17
	b	exception_asm_h
.Lfunc_end164:
	.size	inc_0_asm_h, .Lfunc_end164-inc_0_asm_h
                                        // -- End function
	.hidden	post_dec_0_asm_h                // -- Begin function post_dec_0_asm_h
	.globl	post_dec_0_asm_h
	.p2align	2
	.type	post_dec_0_asm_h,@function
post_dec_0_asm_h:                       // @post_dec_0_asm_h
// %bb.0:                               // %B16
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB165_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB165_4
// %bb.2:                               // %B13
	subs	w8, w22, #1
	b.vs	.LBB165_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB165_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB165_6
// %bb.5:                               // %B8
	add	x8, x22, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #484
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
.LBB165_6:                              // %B5
	mov	w0, #144                        // =0x90
	b	SlowJSPostInc_asm_h
.Lfunc_end165:
	.size	post_dec_0_asm_h, .Lfunc_end165-post_dec_0_asm_h
                                        // -- End function
	.hidden	post_inc_0_asm_h                // -- Begin function post_inc_0_asm_h
	.globl	post_inc_0_asm_h
	.p2align	2
	.type	post_inc_0_asm_h,@function
post_inc_0_asm_h:                       // @post_inc_0_asm_h
// %bb.0:                               // %B16
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB166_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB166_4
// %bb.2:                               // %B13
	adds	w8, w22, #1
	b.vs	.LBB166_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB166_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB166_6
// %bb.5:                               // %B8
	add	x8, x22, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #484
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
.LBB166_6:                              // %B5
	mov	w0, #145                        // =0x91
	b	SlowJSPostInc_asm_h
.Lfunc_end166:
	.size	post_inc_0_asm_h, .Lfunc_end166-post_inc_0_asm_h
                                        // -- End function
	.hidden	dec_loc_0_asm_h                 // -- Begin function dec_loc_0_asm_h
	.globl	dec_loc_0_asm_h
	.p2align	2
	.type	dec_loc_0_asm_h,@function
dec_loc_0_asm_h:                        // @dec_loc_0_asm_h
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	.LBB167_6
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB167_4
// %bb.2:                               // %B13
	subs	w9, w1, #1
	b.vs	.LBB167_6
// %bb.3:                               // %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB167_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB167_6
// %bb.5:                               // %B8
	add	x9, x1, x9
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221120237041090560       // =0x7ff8000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB167_6:                              // %B16
	mov	x0, x24
	mov	w2, #142                        // =0x8e
	str	x20, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB167_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB167_8:                              // %B17
	b	exception_asm_h
.Lfunc_end167:
	.size	dec_loc_0_asm_h, .Lfunc_end167-dec_loc_0_asm_h
                                        // -- End function
	.hidden	inc_loc_0_asm_h                 // -- Begin function inc_loc_0_asm_h
	.globl	inc_loc_0_asm_h
	.p2align	2
	.type	inc_loc_0_asm_h,@function
inc_loc_0_asm_h:                        // @inc_loc_0_asm_h
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	.LBB168_6
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB168_4
// %bb.2:                               // %B13
	adds	w9, w1, #1
	b.vs	.LBB168_6
// %bb.3:                               // %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB168_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB168_6
// %bb.5:                               // %B8
	add	x9, x1, x9
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221120237041090560       // =0x7ff8000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB168_6:                              // %B16
	mov	x0, x24
	mov	w2, #143                        // =0x8f
	str	x20, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB168_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB168_8:                              // %B17
	b	exception_asm_h
.Lfunc_end168:
	.size	inc_loc_0_asm_h, .Lfunc_end168-inc_loc_0_asm_h
                                        // -- End function
	.hidden	add_loc_0_asm_h                 // -- Begin function add_loc_0_asm_h
	.globl	add_loc_0_asm_h
	.p2align	2
	.type	add_loc_0_asm_h,@function
add_loc_0_asm_h:                        // @add_loc_0_asm_h
// %bb.0:                               // %B45
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldur	x22, [x20, #-8]
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	ccmp	x22, x9, #2, ls
	b.hi	.LBB169_14
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB169_5
// %bb.2:                               // %B26
	cmp	x22, x9
	b.lo	.LBB169_8
// %bb.3:                               // %B36
	adds	w9, w1, w22
	b.vs	.LBB169_14
// %bb.4:                               // %B38
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB169_5:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB169_14
// %bb.6:                               // %B11
	cmp	x22, x9
	b.lo	.LBB169_12
// %bb.7:                               // %B21
	scvtf	d0, w22
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	.LBB169_11
.LBB169_8:                              // %B28
	tst	x22, #0xfffe000000000000
	b.eq	.LBB169_14
// %bb.9:                               // %B31
	scvtf	d0, w1
	add	x9, x22, x9
.LBB169_10:                             // %B31
	fmov	d1, x9
	fadd	d0, d0, d1
.LBB169_11:                             // %B31
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	x9, x9, x10
	mov	x10, #9221120237041090560       // =0x7ff8000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB169_12:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB169_14
// %bb.13:                              // %B16
	add	x10, x1, x9
	add	x9, x22, x9
	fmov	d0, x10
	b	.LBB169_10
.LBB169_14:                             // %B7
	mov	x9, #2                          // =0x2
	and	x8, x1, #0xffff000000000003
	and	x10, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	mov	x2, x22
	str	x20, [x23, #64]
	cmp	x8, x9
	mov	x0, x24
	ccmp	x10, x9, #0, eq
	b.eq	.LBB169_16
// %bb.15:                              // %B42
	bl	prim_js_add_slow_gc
	b	.LBB169_17
.LBB169_16:                             // %B39
	bl	JS_ConcatString_GC
.LBB169_17:                             // %B42
	cmp	x0, #130
	b.eq	.LBB169_19
// %bb.18:                              // %B44
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB169_19:                             // %B43
	b	exception_asm_h
.Lfunc_end169:
	.size	add_loc_0_asm_h, .Lfunc_end169-add_loc_0_asm_h
                                        // -- End function
	.hidden	not_0_asm_h                     // -- Begin function not_0_asm_h
	.globl	not_0_asm_h
	.p2align	2
	.type	not_0_asm_h,@function
not_0_asm_h:                            // @not_0_asm_h
// %bb.0:                               // %B2
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB170_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB170_2:                              // %B4
	mov	x0, x22
	b	SlowJSNot_asm_h
.Lfunc_end170:
	.size	not_0_asm_h, .Lfunc_end170-not_0_asm_h
                                        // -- End function
	.hidden	lnot_0_asm_h                    // -- Begin function lnot_0_asm_h
	.globl	lnot_0_asm_h
	.p2align	2
	.type	lnot_0_asm_h,@function
lnot_0_asm_h:                           // @lnot_0_asm_h
// %bb.0:                               // %B14
	ldur	x22, [x20, #-8]
	cmp	x22, #5
	b.le	.LBB171_4
// %bb.1:                               // %B14
	cmp	x22, #6
	b.eq	.LBB171_6
// %bb.2:                               // %B14
	cmp	x22, #7
	b.eq	.LBB171_8
// %bb.3:                               // %B14
	cmp	x22, #18
	b.eq	.LBB171_6
	b	.LBB171_7
.LBB171_4:                              // %B14
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB171_6
// %bb.5:                               // %B14
	cmp	x22, #2
	b.ne	.LBB171_7
.LBB171_6:                              // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB171_7:                              // %B10
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB171_9
.LBB171_8:                              // %B12
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB171_9:                              // %B13
	mov	x0, x22
	b	SlowToBoolean_asm_h
.Lfunc_end171:
	.size	lnot_0_asm_h, .Lfunc_end171-lnot_0_asm_h
                                        // -- End function
	.hidden	typeof_0_asm_h                  // -- Begin function typeof_0_asm_h
	.globl	typeof_0_asm_h
	.p2align	2
	.type	typeof_0_asm_h,@function
typeof_0_asm_h:                         // @typeof_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	mov	x1, x22
	bl	js_operator_typeof_gc
	mov	w1, w0
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x20, [x23, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB172_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB172_2:                              // %B2
	b	exception_asm_h
.Lfunc_end172:
	.size	typeof_0_asm_h, .Lfunc_end172-typeof_0_asm_h
                                        // -- End function
	.hidden	delete_0_asm_h                  // -- Begin function delete_0_asm_h
	.globl	delete_0_asm_h
	.p2align	2
	.type	delete_0_asm_h,@function
delete_0_asm_h:                         // @delete_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	.LBB173_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB173_2:                              // %B2
	b	exception_asm_h
.Lfunc_end173:
	.size	delete_0_asm_h, .Lfunc_end173-delete_0_asm_h
                                        // -- End function
	.hidden	delete_var_0_asm_h              // -- Begin function delete_var_0_asm_h
	.globl	delete_var_0_asm_h
	.p2align	2
	.type	delete_var_0_asm_h,@function
delete_var_0_asm_h:                     // @delete_var_0_asm_h
// %bb.0:                               // %B1
	ldr	x1, [x24, #208]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, wzr
	str	x20, [x23, #64]
	bl	LEPUS_DeleteProperty
	tbnz	w0, #31, .LBB174_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB174_2:                              // %B2
	b	exception_asm_h
.Lfunc_end174:
	.size	delete_var_0_asm_h, .Lfunc_end174-delete_var_0_asm_h
                                        // -- End function
	.hidden	mul_0_asm_h                     // -- Begin function mul_0_asm_h
	.globl	mul_0_asm_h
	.p2align	2
	.type	mul_0_asm_h,@function
mul_0_asm_h:                            // @mul_0_asm_h
// %bb.0:                               // %B47
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB175_18
// %bb.1:                               // %B47
	cmp	x21, x8
	b.hi	.LBB175_18
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB175_8
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB175_11
// %bb.4:                               // %B33
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	.LBB175_18
// %bb.5:                               // %B36
	cbnz	w8, .LBB175_7
// %bb.6:                               // %B36
	orr	w9, w22, w21
	tbnz	w9, #31, .LBB175_15
.LBB175_7:                              // %B43
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB175_8:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB175_18
// %bb.9:                               // %B7
	cmp	x21, x8
	b.lo	.LBB175_16
// %bb.10:                              // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	.LBB175_14
.LBB175_11:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB175_18
// %bb.12:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB175_13:                             // %B28
	fmov	d1, x8
	fmul	d0, d0, d1
.LBB175_14:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #16
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB175_15:                             // %B40
	mov	x22, #-9222809086901354496      // =0x8002000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB175_16:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB175_18
// %bb.17:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB175_13
.LBB175_18:                             // %B44
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        // =0x9a
	str	x20, [x23, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB175_20
// %bb.19:                              // %B46
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB175_20:                             // %B45
	b	exception_asm_h
.Lfunc_end175:
	.size	mul_0_asm_h, .Lfunc_end175-mul_0_asm_h
                                        // -- End function
	.hidden	div_0_asm_h                     // -- Begin function div_0_asm_h
	.globl	div_0_asm_h
	.p2align	2
	.type	div_0_asm_h,@function
div_0_asm_h:                            // @div_0_asm_h
// %bb.0:                               // %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB176_14
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB176_14
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB176_5
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB176_8
// %bb.4:                               // %B33
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x8, #562949953421312            // =0x2000000000000
	ldrb	w10, [x19], #1
	mov	x12, #9221120237041090560       // =0x7ff8000000000000
	sub	x20, x20, #16
	add	w10, w10, #242
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
.LBB176_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB176_14
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB176_12
// %bb.7:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	.LBB176_11
.LBB176_8:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB176_14
// %bb.9:                               // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB176_10:                             // %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
.LBB176_11:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #16
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB176_12:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB176_14
// %bb.13:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB176_10
.LBB176_14:                             // %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        // =0x9b
	str	x20, [x23, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB176_16
// %bb.15:                              // %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB176_16:                             // %B42
	b	exception_asm_h
.Lfunc_end176:
	.size	div_0_asm_h, .Lfunc_end176-div_0_asm_h
                                        // -- End function
	.hidden	mod_0_asm_h                     // -- Begin function mod_0_asm_h
	.globl	mod_0_asm_h
	.p2align	2
	.type	mod_0_asm_h,@function
mod_0_asm_h:                            // @mod_0_asm_h
// %bb.0:                               // %B39
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB177_16
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB177_16
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB177_7
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB177_10
// %bb.4:                               // %B33
	tbnz	w22, #31, .LBB177_16
// %bb.5:                               // %B33
	cmp	w21, #1
	b.lt	.LBB177_16
// %bb.6:                               // %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB177_7:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB177_16
// %bb.8:                               // %B7
	cmp	x21, x8
	b.lo	.LBB177_14
// %bb.9:                               // %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	.LBB177_13
.LBB177_10:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB177_16
// %bb.11:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB177_12:                             // %B28
	fmov	d1, x8
.LBB177_13:                             // %B28
	bl	fmod
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #16
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB177_14:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB177_16
// %bb.15:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB177_12
.LBB177_16:                             // %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        // =0x9c
	str	x20, [x23, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB177_18
// %bb.17:                              // %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB177_18:                             // %B37
	b	exception_asm_h
.Lfunc_end177:
	.size	mod_0_asm_h, .Lfunc_end177-mod_0_asm_h
                                        // -- End function
	.hidden	add_0_asm_h                     // -- Begin function add_0_asm_h
	.globl	add_0_asm_h
	.p2align	2
	.type	add_0_asm_h,@function
add_0_asm_h:                            // @add_0_asm_h
// %bb.0:                               // %B45
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB178_15
// %bb.1:                               // %B45
	cmp	x21, x8
	b.hi	.LBB178_15
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB178_6
// %bb.3:                               // %B26
	cmp	x21, x8
	b.lo	.LBB178_9
// %bb.4:                               // %B36
	adds	w8, w22, w21
	b.vs	.LBB178_15
// %bb.5:                               // %B38
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB178_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB178_15
// %bb.7:                               // %B10
	cmp	x21, x8
	b.lo	.LBB178_13
// %bb.8:                               // %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	.LBB178_12
.LBB178_9:                              // %B28
	tst	x21, #0xfffe000000000000
	b.eq	.LBB178_15
// %bb.10:                              // %B31
	scvtf	d0, w22
	add	x8, x21, x8
.LBB178_11:                             // %B31
	fmov	d1, x8
	fadd	d0, d0, d1
.LBB178_12:                             // %B31
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #16
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB178_13:                             // %B12
	tst	x21, #0xfffe000000000000
	b.eq	.LBB178_15
// %bb.14:                              // %B15
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB178_11
.LBB178_15:                             // %B6
	mov	x8, #2                          // =0x2
	and	x9, x22, #0xffff000000000003
	str	x20, [x23, #64]
	movk	x8, #1, lsl #48
	cmp	x9, x8
	b.ne	.LBB178_18
// %bb.16:                              // %B6
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.ne	.LBB178_18
// %bb.17:                              // %B39
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	JS_ConcatString_GC
	b	.LBB178_19
.LBB178_18:                             // %B42
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_add_slow_gc
.LBB178_19:                             // %B42
	cmp	x0, #130
	b.eq	.LBB178_21
// %bb.20:                              // %B44
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB178_21:                             // %B43
	b	exception_asm_h
.Lfunc_end178:
	.size	add_0_asm_h, .Lfunc_end178-add_0_asm_h
                                        // -- End function
	.hidden	sub_0_asm_h                     // -- Begin function sub_0_asm_h
	.globl	sub_0_asm_h
	.p2align	2
	.type	sub_0_asm_h,@function
sub_0_asm_h:                            // @sub_0_asm_h
// %bb.0:                               // %B39
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB179_15
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB179_15
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB179_6
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB179_9
// %bb.4:                               // %B33
	subs	w8, w22, w21
	b.vs	.LBB179_15
// %bb.5:                               // %B35
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB179_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB179_15
// %bb.7:                               // %B7
	cmp	x21, x8
	b.lo	.LBB179_13
// %bb.8:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	.LBB179_12
.LBB179_9:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB179_15
// %bb.10:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB179_11:                             // %B28
	fmov	d1, x8
	fsub	d0, d0, d1
.LBB179_12:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #16
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB179_13:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB179_15
// %bb.14:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB179_11
.LBB179_15:                             // %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        // =0x9e
	str	x20, [x23, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB179_17
// %bb.16:                              // %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB179_17:                             // %B37
	b	exception_asm_h
.Lfunc_end179:
	.size	sub_0_asm_h, .Lfunc_end179-sub_0_asm_h
                                        // -- End function
	.hidden	pow_0_asm_h                     // -- Begin function pow_0_asm_h
	.globl	pow_0_asm_h
	.p2align	2
	.type	pow_0_asm_h,@function
pow_0_asm_h:                            // @pow_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w3, #159                        // =0x9f
	str	x20, [x23, #64]
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB180_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB180_2:                              // %B2
	b	exception_asm_h
.Lfunc_end180:
	.size	pow_0_asm_h, .Lfunc_end180-pow_0_asm_h
                                        // -- End function
	.hidden	shl_0_asm_h                     // -- Begin function shl_0_asm_h
	.globl	shl_0_asm_h
	.p2align	2
	.type	shl_0_asm_h,@function
shl_0_asm_h:                            // @shl_0_asm_h
// %bb.0:                               // %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB181_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB181_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB181_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB181_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB181_5:                              // %B16
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #16
	add	w9, w9, #242
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB181_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB181_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB181_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB181_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB181_5
.LBB181_10:                             // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        // =0xa0
	str	x20, [x23, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB181_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB181_12:                             // %B26
	b	exception_asm_h
.Lfunc_end181:
	.size	shl_0_asm_h, .Lfunc_end181-shl_0_asm_h
                                        // -- End function
	.hidden	sar_0_asm_h                     // -- Begin function sar_0_asm_h
	.globl	sar_0_asm_h
	.p2align	2
	.type	sar_0_asm_h,@function
sar_0_asm_h:                            // @sar_0_asm_h
// %bb.0:                               // %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB182_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB182_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB182_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB182_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB182_5:                              // %B16
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #16
	add	w9, w9, #242
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB182_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB182_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB182_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB182_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB182_5
.LBB182_10:                             // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        // =0xa1
	str	x20, [x23, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB182_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB182_12:                             // %B26
	b	exception_asm_h
.Lfunc_end182:
	.size	sar_0_asm_h, .Lfunc_end182-sar_0_asm_h
                                        // -- End function
	.hidden	shr_0_asm_h                     // -- Begin function shr_0_asm_h
	.globl	shr_0_asm_h
	.p2align	2
	.type	shr_0_asm_h,@function
shr_0_asm_h:                            // @shr_0_asm_h
// %bb.0:                               // %B36
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB183_11
// %bb.1:                               // %B36
	cmp	x21, x8
	b.hi	.LBB183_11
// %bb.2:                               // %B10
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB183_6
// %bb.3:                               // %B27
	cmp	x21, x8
	b.lo	.LBB183_11
// %bb.4:                               // %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, .LBB183_10
.LBB183_5:                              // %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB183_6:                              // %B12
	tst	x22, #0xfffe000000000000
	b.eq	.LBB183_11
// %bb.7:                               // %B12
	cmp	x21, x8
	b.lo	.LBB183_11
// %bb.8:                               // %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB183_11
// %bb.9:                               // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, .LBB183_5
.LBB183_10:                             // %B6
	ucvtf	d0, w8
	mov	x9, #562949953421312            // =0x2000000000000
	fmov	x8, d0
	fcmp	d0, d0
	add	x8, x8, x9
	mov	x9, #9221120237041090560        // =0x7ff8000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB183_11:                             // %B33
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #64]
	bl	prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	.LBB183_13
// %bb.12:                              // %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB183_13:                             // %B34
	b	exception_asm_h
.Lfunc_end183:
	.size	shr_0_asm_h, .Lfunc_end183-shr_0_asm_h
                                        // -- End function
	.hidden	lt_0_asm_h                      // -- Begin function lt_0_asm_h
	.globl	lt_0_asm_h
	.p2align	2
	.type	lt_0_asm_h,@function
lt_0_asm_h:                             // @lt_0_asm_h
// %bb.0:                               // %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB184_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB184_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB184_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB184_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, lt
	br	x1
.LBB184_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB184_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB184_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB184_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB184_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB184_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB184_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB184_12:                             // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        // =0xa3
	str	x20, [x23, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB184_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB184_14:                             // %B22
	b	exception_asm_h
.Lfunc_end184:
	.size	lt_0_asm_h, .Lfunc_end184-lt_0_asm_h
                                        // -- End function
	.hidden	lte_0_asm_h                     // -- Begin function lte_0_asm_h
	.globl	lte_0_asm_h
	.p2align	2
	.type	lte_0_asm_h,@function
lte_0_asm_h:                            // @lte_0_asm_h
// %bb.0:                               // %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB185_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB185_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB185_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB185_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, le
	br	x1
.LBB185_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB185_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB185_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB185_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB185_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB185_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB185_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB185_12:                             // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        // =0xa4
	str	x20, [x23, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB185_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB185_14:                             // %B22
	b	exception_asm_h
.Lfunc_end185:
	.size	lte_0_asm_h, .Lfunc_end185-lte_0_asm_h
                                        // -- End function
	.hidden	gt_0_asm_h                      // -- Begin function gt_0_asm_h
	.globl	gt_0_asm_h
	.p2align	2
	.type	gt_0_asm_h,@function
gt_0_asm_h:                             // @gt_0_asm_h
// %bb.0:                               // %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB186_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB186_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB186_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB186_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB186_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB186_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB186_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB186_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB186_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB186_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB186_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB186_12:                             // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        // =0xa5
	str	x20, [x23, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB186_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB186_14:                             // %B22
	b	exception_asm_h
.Lfunc_end186:
	.size	gt_0_asm_h, .Lfunc_end186-gt_0_asm_h
                                        // -- End function
	.hidden	gte_0_asm_h                     // -- Begin function gte_0_asm_h
	.globl	gte_0_asm_h
	.p2align	2
	.type	gte_0_asm_h,@function
gte_0_asm_h:                            // @gte_0_asm_h
// %bb.0:                               // %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB187_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB187_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB187_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB187_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB187_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB187_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB187_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB187_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB187_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB187_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB187_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB187_12:                             // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        // =0xa6
	str	x20, [x23, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB187_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB187_14:                             // %B22
	b	exception_asm_h
.Lfunc_end187:
	.size	gte_0_asm_h, .Lfunc_end187-gte_0_asm_h
                                        // -- End function
	.hidden	instanceof_0_asm_h              // -- Begin function instanceof_0_asm_h
	.globl	instanceof_0_asm_h
	.p2align	2
	.type	instanceof_0_asm_h,@function
instanceof_0_asm_h:                     // @instanceof_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	.LBB188_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB188_2:                              // %B2
	b	exception_asm_h
.Lfunc_end188:
	.size	instanceof_0_asm_h, .Lfunc_end188-instanceof_0_asm_h
                                        // -- End function
	.hidden	in_0_asm_h                      // -- Begin function in_0_asm_h
	.globl	in_0_asm_h
	.p2align	2
	.type	in_0_asm_h,@function
in_0_asm_h:                             // @in_0_asm_h
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	.LBB189_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB189_2:                              // %B2
	b	exception_asm_h
.Lfunc_end189:
	.size	in_0_asm_h, .Lfunc_end189-in_0_asm_h
                                        // -- End function
	.hidden	eq_0_asm_h                      // -- Begin function eq_0_asm_h
	.globl	eq_0_asm_h
	.p2align	2
	.type	eq_0_asm_h,@function
eq_0_asm_h:                             // @eq_0_asm_h
// %bb.0:                               // %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB190_13
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB190_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB190_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB190_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB190_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB190_13
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB190_11
// %bb.7:                               // %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #242
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB190_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB190_13
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB190_10:                             // %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #242
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB190_11:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB190_13
// %bb.12:                              // %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB190_10
.LBB190_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB190_15
.LBB190_14:                             // %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB190_15:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB190_17
// %bb.16:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB190_14
	b	.LBB190_20
.LBB190_17:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB190_20
// %bb.18:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB190_21
// %bb.19:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB190_21
.LBB190_20:                             // %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB190_21:                             // %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x23, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB190_23
// %bb.22:                              // %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB190_23:                             // %B42
	b	exception_asm_h
.Lfunc_end190:
	.size	eq_0_asm_h, .Lfunc_end190-eq_0_asm_h
                                        // -- End function
	.hidden	neq_0_asm_h                     // -- Begin function neq_0_asm_h
	.globl	neq_0_asm_h
	.p2align	2
	.type	neq_0_asm_h,@function
neq_0_asm_h:                            // @neq_0_asm_h
// %bb.0:                               // %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB191_13
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB191_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB191_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB191_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB191_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB191_13
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB191_11
// %bb.7:                               // %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #242
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB191_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB191_13
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB191_10:                             // %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #242
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB191_11:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB191_13
// %bb.12:                              // %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB191_10
.LBB191_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB191_15
.LBB191_14:                             // %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB191_15:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB191_17
// %bb.16:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB191_14
	b	.LBB191_20
.LBB191_17:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB191_20
// %bb.18:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB191_21
// %bb.19:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB191_21
.LBB191_20:                             // %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB191_21:                             // %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x20, [x23, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB191_23
// %bb.22:                              // %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB191_23:                             // %B42
	b	exception_asm_h
.Lfunc_end191:
	.size	neq_0_asm_h, .Lfunc_end191-neq_0_asm_h
                                        // -- End function
	.hidden	strict_eq_0_asm_h               // -- Begin function strict_eq_0_asm_h
	.globl	strict_eq_0_asm_h
	.p2align	2
	.type	strict_eq_0_asm_h,@function
strict_eq_0_asm_h:                      // @strict_eq_0_asm_h
// %bb.0:                               // %B36
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB192_13
// %bb.1:                               // %B36
	cmp	x21, x8
	b.hi	.LBB192_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB192_5
// %bb.3:                               // %B27
	cmp	x21, x8
	b.lo	.LBB192_8
// %bb.4:                               // %B32
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB192_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB192_13
// %bb.6:                               // %B20
	cmp	x21, x8
	b.lo	.LBB192_11
// %bb.7:                               // %B25
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #242
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB192_8:                              // %B29
	tst	x21, #0xfffe000000000000
	b.eq	.LBB192_13
// %bb.9:                               // %B31
	scvtf	d0, w22
	add	x8, x21, x8
.LBB192_10:                             // %B31
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #242
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB192_11:                             // %B22
	tst	x21, #0xfffe000000000000
	b.eq	.LBB192_13
// %bb.12:                              // %B24
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB192_10
.LBB192_13:                             // %B10
	cmp	x22, x21
	b.ne	.LBB192_15
// %bb.14:                              // %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB192_15:                             // %B13
	and	x8, x21, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	mov	x13, #2                         // =0x2
	ccmp	x8, x12, #4, ne
	movk	x13, #65535, lsl #48
	and	x9, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w10, eq
	cmp	x9, x13
	ccmp	x9, x12, #4, ne
	ccmp	x9, x11, #4, ne
	b.ne	.LBB192_17
// %bb.16:                              // %B13
	tbnz	w10, #0, .LBB192_20
.LBB192_17:                             // %B16
	mov	x10, #-281474976710656          // =0xffff000000000000
	cmp	x9, x10
	b.ne	.LBB192_19
// %bb.18:                              // %B16
	cmp	x8, x10
	b.eq	.LBB192_22
.LBB192_19:                             // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB192_20:                             // %B33
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x23, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB192_24
// %bb.21:                              // %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB192_22:                             // %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #16
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB192_25
// %bb.23:                              // %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB192_24:                             // %B34
	b	exception_asm_h
.LBB192_25:                             // %B8
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end192:
	.size	strict_eq_0_asm_h, .Lfunc_end192-strict_eq_0_asm_h
                                        // -- End function
	.hidden	strict_neq_0_asm_h              // -- Begin function strict_neq_0_asm_h
	.globl	strict_neq_0_asm_h
	.p2align	2
	.type	strict_neq_0_asm_h,@function
strict_neq_0_asm_h:                     // @strict_neq_0_asm_h
// %bb.0:                               // %B36
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB193_13
// %bb.1:                               // %B36
	cmp	x21, x8
	b.hi	.LBB193_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB193_5
// %bb.3:                               // %B27
	cmp	x21, x8
	b.lo	.LBB193_8
// %bb.4:                               // %B32
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB193_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB193_13
// %bb.6:                               // %B20
	cmp	x21, x8
	b.lo	.LBB193_11
// %bb.7:                               // %B25
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #242
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB193_8:                              // %B29
	tst	x21, #0xfffe000000000000
	b.eq	.LBB193_13
// %bb.9:                               // %B31
	scvtf	d0, w22
	add	x8, x21, x8
.LBB193_10:                             // %B31
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #242
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB193_11:                             // %B22
	tst	x21, #0xfffe000000000000
	b.eq	.LBB193_13
// %bb.12:                              // %B24
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB193_10
.LBB193_13:                             // %B10
	cmp	x22, x21
	b.ne	.LBB193_15
// %bb.14:                              // %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB193_15:                             // %B13
	and	x8, x21, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	mov	x13, #2                         // =0x2
	ccmp	x8, x12, #4, ne
	movk	x13, #65535, lsl #48
	and	x9, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w10, eq
	cmp	x9, x13
	ccmp	x9, x12, #4, ne
	ccmp	x9, x11, #4, ne
	b.ne	.LBB193_17
// %bb.16:                              // %B13
	tbnz	w10, #0, .LBB193_20
.LBB193_17:                             // %B16
	mov	x10, #-281474976710656          // =0xffff000000000000
	cmp	x9, x10
	b.ne	.LBB193_19
// %bb.18:                              // %B16
	cmp	x8, x10
	b.eq	.LBB193_22
.LBB193_19:                             // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB193_20:                             // %B33
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x20, [x23, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB193_24
// %bb.21:                              // %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB193_22:                             // %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #16
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB193_25
// %bb.23:                              // %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB193_24:                             // %B34
	b	exception_asm_h
.LBB193_25:                             // %B8
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end193:
	.size	strict_neq_0_asm_h, .Lfunc_end193-strict_neq_0_asm_h
                                        // -- End function
	.hidden	and_0_asm_h                     // -- Begin function and_0_asm_h
	.globl	and_0_asm_h
	.p2align	2
	.type	and_0_asm_h,@function
and_0_asm_h:                            // @and_0_asm_h
// %bb.0:                               // %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB194_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB194_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB194_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB194_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB194_5:                              // %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	and	w8, w8, w21
	add	w9, w9, #242
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB194_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB194_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB194_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB194_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB194_5
.LBB194_10:                             // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        // =0xad
	str	x20, [x23, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB194_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB194_12:                             // %B26
	b	exception_asm_h
.Lfunc_end194:
	.size	and_0_asm_h, .Lfunc_end194-and_0_asm_h
                                        // -- End function
	.hidden	xor_0_asm_h                     // -- Begin function xor_0_asm_h
	.globl	xor_0_asm_h
	.p2align	2
	.type	xor_0_asm_h,@function
xor_0_asm_h:                            // @xor_0_asm_h
// %bb.0:                               // %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB195_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB195_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB195_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB195_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB195_5:                              // %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	eor	w8, w8, w21
	add	w9, w9, #242
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB195_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB195_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB195_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB195_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB195_5
.LBB195_10:                             // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        // =0xae
	str	x20, [x23, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB195_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB195_12:                             // %B26
	b	exception_asm_h
.Lfunc_end195:
	.size	xor_0_asm_h, .Lfunc_end195-xor_0_asm_h
                                        // -- End function
	.hidden	or_0_asm_h                      // -- Begin function or_0_asm_h
	.globl	or_0_asm_h
	.p2align	2
	.type	or_0_asm_h,@function
or_0_asm_h:                             // @or_0_asm_h
// %bb.0:                               // %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB196_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB196_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB196_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB196_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB196_5:                              // %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	orr	w8, w8, w21
	add	w9, w9, #242
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB196_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB196_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB196_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB196_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB196_5
.LBB196_10:                             // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        // =0xaf
	str	x20, [x23, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB196_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB196_12:                             // %B26
	b	exception_asm_h
.Lfunc_end196:
	.size	or_0_asm_h, .Lfunc_end196-or_0_asm_h
                                        // -- End function
	.hidden	nop_0_asm_h                     // -- Begin function nop_0_asm_h
	.globl	nop_0_asm_h
	.p2align	2
	.type	nop_0_asm_h,@function
nop_0_asm_h:                            // @nop_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end197:
	.size	nop_0_asm_h, .Lfunc_end197-nop_0_asm_h
                                        // -- End function
	.hidden	push_minus1_0_asm_h             // -- Begin function push_minus1_0_asm_h
	.globl	push_minus1_0_asm_h
	.p2align	2
	.type	push_minus1_0_asm_h,@function
push_minus1_0_asm_h:                    // @push_minus1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562945658454017          // =0xfffe0000ffffffff
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end198:
	.size	push_minus1_0_asm_h, .Lfunc_end198-push_minus1_0_asm_h
                                        // -- End function
	.hidden	push_0_0_asm_h                  // -- Begin function push_0_0_asm_h
	.globl	push_0_0_asm_h
	.p2align	2
	.type	push_0_0_asm_h,@function
push_0_0_asm_h:                         // @push_0_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421312          // =0xfffe000000000000
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end199:
	.size	push_0_0_asm_h, .Lfunc_end199-push_0_0_asm_h
                                        // -- End function
	.hidden	push_1_0_asm_h                  // -- Begin function push_1_0_asm_h
	.globl	push_1_0_asm_h
	.p2align	2
	.type	push_1_0_asm_h,@function
push_1_0_asm_h:                         // @push_1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421311          // =0xfffe000000000001
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end200:
	.size	push_1_0_asm_h, .Lfunc_end200-push_1_0_asm_h
                                        // -- End function
	.hidden	push_2_0_asm_h                  // -- Begin function push_2_0_asm_h
	.globl	push_2_0_asm_h
	.p2align	2
	.type	push_2_0_asm_h,@function
push_2_0_asm_h:                         // @push_2_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #2                         // =0x2
	movk	x22, #65534, lsl #48
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end201:
	.size	push_2_0_asm_h, .Lfunc_end201-push_2_0_asm_h
                                        // -- End function
	.hidden	push_3_0_asm_h                  // -- Begin function push_3_0_asm_h
	.globl	push_3_0_asm_h
	.p2align	2
	.type	push_3_0_asm_h,@function
push_3_0_asm_h:                         // @push_3_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421309          // =0xfffe000000000003
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end202:
	.size	push_3_0_asm_h, .Lfunc_end202-push_3_0_asm_h
                                        // -- End function
	.hidden	push_4_0_asm_h                  // -- Begin function push_4_0_asm_h
	.globl	push_4_0_asm_h
	.p2align	2
	.type	push_4_0_asm_h,@function
push_4_0_asm_h:                         // @push_4_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #4                         // =0x4
	movk	x22, #65534, lsl #48
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end203:
	.size	push_4_0_asm_h, .Lfunc_end203-push_4_0_asm_h
                                        // -- End function
	.hidden	push_5_0_asm_h                  // -- Begin function push_5_0_asm_h
	.globl	push_5_0_asm_h
	.p2align	2
	.type	push_5_0_asm_h,@function
push_5_0_asm_h:                         // @push_5_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #5                         // =0x5
	movk	x22, #65534, lsl #48
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end204:
	.size	push_5_0_asm_h, .Lfunc_end204-push_5_0_asm_h
                                        // -- End function
	.hidden	push_6_0_asm_h                  // -- Begin function push_6_0_asm_h
	.globl	push_6_0_asm_h
	.p2align	2
	.type	push_6_0_asm_h,@function
push_6_0_asm_h:                         // @push_6_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #6                         // =0x6
	movk	x22, #65534, lsl #48
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end205:
	.size	push_6_0_asm_h, .Lfunc_end205-push_6_0_asm_h
                                        // -- End function
	.hidden	push_7_0_asm_h                  // -- Begin function push_7_0_asm_h
	.globl	push_7_0_asm_h
	.p2align	2
	.type	push_7_0_asm_h,@function
push_7_0_asm_h:                         // @push_7_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421305          // =0xfffe000000000007
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end206:
	.size	push_7_0_asm_h, .Lfunc_end206-push_7_0_asm_h
                                        // -- End function
	.hidden	push_i8_0_asm_h                 // -- Begin function push_i8_0_asm_h
	.globl	push_i8_0_asm_h
	.p2align	2
	.type	push_i8_0_asm_h,@function
push_i8_0_asm_h:                        // @push_i8_0_asm_h
// %bb.0:                               // %B0
	ldrb	w9, [x19, #1]
	ldrsb	x10, [x19]
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x19, x19, #2
	add	w9, w9, #242
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x22, x8
	br	x1
.Lfunc_end207:
	.size	push_i8_0_asm_h, .Lfunc_end207-push_i8_0_asm_h
                                        // -- End function
	.hidden	push_i16_0_asm_h                // -- Begin function push_i16_0_asm_h
	.globl	push_i16_0_asm_h
	.p2align	2
	.type	push_i16_0_asm_h,@function
push_i16_0_asm_h:                       // @push_i16_0_asm_h
// %bb.0:                               // %B0
	ldrb	w9, [x19, #2]
	ldrsh	x10, [x19]
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x19, x19, #3
	add	w9, w9, #242
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x22, x8
	br	x1
.Lfunc_end208:
	.size	push_i16_0_asm_h, .Lfunc_end208-push_i16_0_asm_h
                                        // -- End function
	.hidden	push_const8_0_asm_h             // -- Begin function push_const8_0_asm_h
	.globl	push_const8_0_asm_h
	.p2align	2
	.type	push_const8_0_asm_h,@function
push_const8_0_asm_h:                    // @push_const8_0_asm_h
// %bb.0:                               // %B3
	sub	sp, sp, #16
	ldr	x8, [x23, #128]
	ldrb	w9, [x19]
	ldr	w10, [x24, #336]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, .LBB209_2
// %bb.1:                               // %B4
	mov	x0, x24
	mov	x2, x19
	str	x20, [x23, #64]
	str	x1, [sp, #8]                    // 8-byte Folded Spill
	bl	DebuggerPause
	ldr	x1, [sp, #8]                    // 8-byte Folded Reload
.LBB209_2:                              // %B1
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x1
	add	w8, w8, #242
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
.Lfunc_end209:
	.size	push_const8_0_asm_h, .Lfunc_end209-push_const8_0_asm_h
                                        // -- End function
	.hidden	fclosure8_0_asm_h               // -- Begin function fclosure8_0_asm_h
	.globl	fclosure8_0_asm_h
	.p2align	2
	.type	fclosure8_0_asm_h,@function
fclosure8_0_asm_h:                      // @fclosure8_0_asm_h
// %bb.0:                               // %B1
	ldr	x8, [x23, #128]
	ldrb	w9, [x19]
	mov	x0, x24
	mov	x2, x26
	mov	x3, x23
	ldr	x1, [x8, x9, lsl #3]
	str	x20, [x23, #64]
	bl	js_closure_gc
	cmp	x0, #130
	b.eq	.LBB210_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB210_2:                              // %B2
	b	exception_asm_h
.Lfunc_end210:
	.size	fclosure8_0_asm_h, .Lfunc_end210-fclosure8_0_asm_h
                                        // -- End function
	.hidden	push_empty_string_0_asm_h       // -- Begin function push_empty_string_0_asm_h
	.globl	push_empty_string_0_asm_h
	.p2align	2
	.type	push_empty_string_0_asm_h,@function
push_empty_string_0_asm_h:              // @push_empty_string_0_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	w1, #47                         // =0x2f
	mov	w2, #1                          // =0x1
	str	x20, [x23, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB211_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB211_2:                              // %B2
	b	exception_asm_h
.Lfunc_end211:
	.size	push_empty_string_0_asm_h, .Lfunc_end211-push_empty_string_0_asm_h
                                        // -- End function
	.hidden	get_loc8_0_asm_h                // -- Begin function get_loc8_0_asm_h
	.globl	get_loc8_0_asm_h
	.p2align	2
	.type	get_loc8_0_asm_h,@function
get_loc8_0_asm_h:                       // @get_loc8_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #1]
	ldrb	w9, [x19], #2
	add	w8, w8, #242
	ldr	x22, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end212:
	.size	get_loc8_0_asm_h, .Lfunc_end212-get_loc8_0_asm_h
                                        // -- End function
	.hidden	put_loc8_0_asm_h                // -- Begin function put_loc8_0_asm_h
	.globl	put_loc8_0_asm_h
	.p2align	2
	.type	put_loc8_0_asm_h,@function
put_loc8_0_asm_h:                       // @put_loc8_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end213:
	.size	put_loc8_0_asm_h, .Lfunc_end213-put_loc8_0_asm_h
                                        // -- End function
	.hidden	set_loc8_0_asm_h                // -- Begin function set_loc8_0_asm_h
	.globl	set_loc8_0_asm_h
	.p2align	2
	.type	set_loc8_0_asm_h,@function
set_loc8_0_asm_h:                       // @set_loc8_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end214:
	.size	set_loc8_0_asm_h, .Lfunc_end214-set_loc8_0_asm_h
                                        // -- End function
	.hidden	get_loc0_0_asm_h                // -- Begin function get_loc0_0_asm_h
	.globl	get_loc0_0_asm_h
	.p2align	2
	.type	get_loc0_0_asm_h,@function
get_loc0_0_asm_h:                       // @get_loc0_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27]
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end215:
	.size	get_loc0_0_asm_h, .Lfunc_end215-get_loc0_0_asm_h
                                        // -- End function
	.hidden	get_loc1_0_asm_h                // -- Begin function get_loc1_0_asm_h
	.globl	get_loc1_0_asm_h
	.p2align	2
	.type	get_loc1_0_asm_h,@function
get_loc1_0_asm_h:                       // @get_loc1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27, #8]
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end216:
	.size	get_loc1_0_asm_h, .Lfunc_end216-get_loc1_0_asm_h
                                        // -- End function
	.hidden	get_loc2_0_asm_h                // -- Begin function get_loc2_0_asm_h
	.globl	get_loc2_0_asm_h
	.p2align	2
	.type	get_loc2_0_asm_h,@function
get_loc2_0_asm_h:                       // @get_loc2_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27, #16]
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end217:
	.size	get_loc2_0_asm_h, .Lfunc_end217-get_loc2_0_asm_h
                                        // -- End function
	.hidden	get_loc3_0_asm_h                // -- Begin function get_loc3_0_asm_h
	.globl	get_loc3_0_asm_h
	.p2align	2
	.type	get_loc3_0_asm_h,@function
get_loc3_0_asm_h:                       // @get_loc3_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27, #24]
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end218:
	.size	get_loc3_0_asm_h, .Lfunc_end218-get_loc3_0_asm_h
                                        // -- End function
	.hidden	put_loc0_0_asm_h                // -- Begin function put_loc0_0_asm_h
	.globl	put_loc0_0_asm_h
	.p2align	2
	.type	put_loc0_0_asm_h,@function
put_loc0_0_asm_h:                       // @put_loc0_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end219:
	.size	put_loc0_0_asm_h, .Lfunc_end219-put_loc0_0_asm_h
                                        // -- End function
	.hidden	put_loc1_0_asm_h                // -- Begin function put_loc1_0_asm_h
	.globl	put_loc1_0_asm_h
	.p2align	2
	.type	put_loc1_0_asm_h,@function
put_loc1_0_asm_h:                       // @put_loc1_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end220:
	.size	put_loc1_0_asm_h, .Lfunc_end220-put_loc1_0_asm_h
                                        // -- End function
	.hidden	put_loc2_0_asm_h                // -- Begin function put_loc2_0_asm_h
	.globl	put_loc2_0_asm_h
	.p2align	2
	.type	put_loc2_0_asm_h,@function
put_loc2_0_asm_h:                       // @put_loc2_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end221:
	.size	put_loc2_0_asm_h, .Lfunc_end221-put_loc2_0_asm_h
                                        // -- End function
	.hidden	put_loc3_0_asm_h                // -- Begin function put_loc3_0_asm_h
	.globl	put_loc3_0_asm_h
	.p2align	2
	.type	put_loc3_0_asm_h,@function
put_loc3_0_asm_h:                       // @put_loc3_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end222:
	.size	put_loc3_0_asm_h, .Lfunc_end222-put_loc3_0_asm_h
                                        // -- End function
	.hidden	set_loc0_0_asm_h                // -- Begin function set_loc0_0_asm_h
	.globl	set_loc0_0_asm_h
	.p2align	2
	.type	set_loc0_0_asm_h,@function
set_loc0_0_asm_h:                       // @set_loc0_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end223:
	.size	set_loc0_0_asm_h, .Lfunc_end223-set_loc0_0_asm_h
                                        // -- End function
	.hidden	set_loc1_0_asm_h                // -- Begin function set_loc1_0_asm_h
	.globl	set_loc1_0_asm_h
	.p2align	2
	.type	set_loc1_0_asm_h,@function
set_loc1_0_asm_h:                       // @set_loc1_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end224:
	.size	set_loc1_0_asm_h, .Lfunc_end224-set_loc1_0_asm_h
                                        // -- End function
	.hidden	set_loc2_0_asm_h                // -- Begin function set_loc2_0_asm_h
	.globl	set_loc2_0_asm_h
	.p2align	2
	.type	set_loc2_0_asm_h,@function
set_loc2_0_asm_h:                       // @set_loc2_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end225:
	.size	set_loc2_0_asm_h, .Lfunc_end225-set_loc2_0_asm_h
                                        // -- End function
	.hidden	set_loc3_0_asm_h                // -- Begin function set_loc3_0_asm_h
	.globl	set_loc3_0_asm_h
	.p2align	2
	.type	set_loc3_0_asm_h,@function
set_loc3_0_asm_h:                       // @set_loc3_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end226:
	.size	set_loc3_0_asm_h, .Lfunc_end226-set_loc3_0_asm_h
                                        // -- End function
	.hidden	get_arg0_0_asm_h                // -- Begin function get_arg0_0_asm_h
	.globl	get_arg0_0_asm_h
	.p2align	2
	.type	get_arg0_0_asm_h,@function
get_arg0_0_asm_h:                       // @get_arg0_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28]
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end227:
	.size	get_arg0_0_asm_h, .Lfunc_end227-get_arg0_0_asm_h
                                        // -- End function
	.hidden	get_arg1_0_asm_h                // -- Begin function get_arg1_0_asm_h
	.globl	get_arg1_0_asm_h
	.p2align	2
	.type	get_arg1_0_asm_h,@function
get_arg1_0_asm_h:                       // @get_arg1_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28, #8]
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end228:
	.size	get_arg1_0_asm_h, .Lfunc_end228-get_arg1_0_asm_h
                                        // -- End function
	.hidden	get_arg2_0_asm_h                // -- Begin function get_arg2_0_asm_h
	.globl	get_arg2_0_asm_h
	.p2align	2
	.type	get_arg2_0_asm_h,@function
get_arg2_0_asm_h:                       // @get_arg2_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28, #16]
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end229:
	.size	get_arg2_0_asm_h, .Lfunc_end229-get_arg2_0_asm_h
                                        // -- End function
	.hidden	get_arg3_0_asm_h                // -- Begin function get_arg3_0_asm_h
	.globl	get_arg3_0_asm_h
	.p2align	2
	.type	get_arg3_0_asm_h,@function
get_arg3_0_asm_h:                       // @get_arg3_0_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28, #24]
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end230:
	.size	get_arg3_0_asm_h, .Lfunc_end230-get_arg3_0_asm_h
                                        // -- End function
	.hidden	put_arg0_0_asm_h                // -- Begin function put_arg0_0_asm_h
	.globl	put_arg0_0_asm_h
	.p2align	2
	.type	put_arg0_0_asm_h,@function
put_arg0_0_asm_h:                       // @put_arg0_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end231:
	.size	put_arg0_0_asm_h, .Lfunc_end231-put_arg0_0_asm_h
                                        // -- End function
	.hidden	put_arg1_0_asm_h                // -- Begin function put_arg1_0_asm_h
	.globl	put_arg1_0_asm_h
	.p2align	2
	.type	put_arg1_0_asm_h,@function
put_arg1_0_asm_h:                       // @put_arg1_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end232:
	.size	put_arg1_0_asm_h, .Lfunc_end232-put_arg1_0_asm_h
                                        // -- End function
	.hidden	put_arg2_0_asm_h                // -- Begin function put_arg2_0_asm_h
	.globl	put_arg2_0_asm_h
	.p2align	2
	.type	put_arg2_0_asm_h,@function
put_arg2_0_asm_h:                       // @put_arg2_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end233:
	.size	put_arg2_0_asm_h, .Lfunc_end233-put_arg2_0_asm_h
                                        // -- End function
	.hidden	put_arg3_0_asm_h                // -- Begin function put_arg3_0_asm_h
	.globl	put_arg3_0_asm_h
	.p2align	2
	.type	put_arg3_0_asm_h,@function
put_arg3_0_asm_h:                       // @put_arg3_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end234:
	.size	put_arg3_0_asm_h, .Lfunc_end234-put_arg3_0_asm_h
                                        // -- End function
	.hidden	set_arg0_0_asm_h                // -- Begin function set_arg0_0_asm_h
	.globl	set_arg0_0_asm_h
	.p2align	2
	.type	set_arg0_0_asm_h,@function
set_arg0_0_asm_h:                       // @set_arg0_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end235:
	.size	set_arg0_0_asm_h, .Lfunc_end235-set_arg0_0_asm_h
                                        // -- End function
	.hidden	set_arg1_0_asm_h                // -- Begin function set_arg1_0_asm_h
	.globl	set_arg1_0_asm_h
	.p2align	2
	.type	set_arg1_0_asm_h,@function
set_arg1_0_asm_h:                       // @set_arg1_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end236:
	.size	set_arg1_0_asm_h, .Lfunc_end236-set_arg1_0_asm_h
                                        // -- End function
	.hidden	set_arg2_0_asm_h                // -- Begin function set_arg2_0_asm_h
	.globl	set_arg2_0_asm_h
	.p2align	2
	.type	set_arg2_0_asm_h,@function
set_arg2_0_asm_h:                       // @set_arg2_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end237:
	.size	set_arg2_0_asm_h, .Lfunc_end237-set_arg2_0_asm_h
                                        // -- End function
	.hidden	set_arg3_0_asm_h                // -- Begin function set_arg3_0_asm_h
	.globl	set_arg3_0_asm_h
	.p2align	2
	.type	set_arg3_0_asm_h,@function
set_arg3_0_asm_h:                       // @set_arg3_0_asm_h
// %bb.0:                               // %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end238:
	.size	set_arg3_0_asm_h, .Lfunc_end238-set_arg3_0_asm_h
                                        // -- End function
	.hidden	get_var_ref0_0_asm_h            // -- Begin function get_var_ref0_0_asm_h
	.globl	get_var_ref0_0_asm_h
	.p2align	2
	.type	get_var_ref0_0_asm_h,@function
get_var_ref0_0_asm_h:                   // @get_var_ref0_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldrb	w9, [x19], #1
	ldr	x8, [x8, #32]
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x22, [x8]
	br	x1
.Lfunc_end239:
	.size	get_var_ref0_0_asm_h, .Lfunc_end239-get_var_ref0_0_asm_h
                                        // -- End function
	.hidden	get_var_ref1_0_asm_h            // -- Begin function get_var_ref1_0_asm_h
	.globl	get_var_ref1_0_asm_h
	.p2align	2
	.type	get_var_ref1_0_asm_h,@function
get_var_ref1_0_asm_h:                   // @get_var_ref1_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldrb	w9, [x19], #1
	ldr	x8, [x8, #32]
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x22, [x8]
	br	x1
.Lfunc_end240:
	.size	get_var_ref1_0_asm_h, .Lfunc_end240-get_var_ref1_0_asm_h
                                        // -- End function
	.hidden	get_var_ref2_0_asm_h            // -- Begin function get_var_ref2_0_asm_h
	.globl	get_var_ref2_0_asm_h
	.p2align	2
	.type	get_var_ref2_0_asm_h,@function
get_var_ref2_0_asm_h:                   // @get_var_ref2_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldrb	w9, [x19], #1
	ldr	x8, [x8, #32]
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x22, [x8]
	br	x1
.Lfunc_end241:
	.size	get_var_ref2_0_asm_h, .Lfunc_end241-get_var_ref2_0_asm_h
                                        // -- End function
	.hidden	get_var_ref3_0_asm_h            // -- Begin function get_var_ref3_0_asm_h
	.globl	get_var_ref3_0_asm_h
	.p2align	2
	.type	get_var_ref3_0_asm_h,@function
get_var_ref3_0_asm_h:                   // @get_var_ref3_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldrb	w9, [x19], #1
	ldr	x8, [x8, #32]
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x22, [x8]
	br	x1
.Lfunc_end242:
	.size	get_var_ref3_0_asm_h, .Lfunc_end242-get_var_ref3_0_asm_h
                                        // -- End function
	.hidden	put_var_ref0_0_asm_h            // -- Begin function put_var_ref0_0_asm_h
	.globl	put_var_ref0_0_asm_h
	.p2align	2
	.type	put_var_ref0_0_asm_h,@function
put_var_ref0_0_asm_h:                   // @put_var_ref0_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end243:
	.size	put_var_ref0_0_asm_h, .Lfunc_end243-put_var_ref0_0_asm_h
                                        // -- End function
	.hidden	put_var_ref1_0_asm_h            // -- Begin function put_var_ref1_0_asm_h
	.globl	put_var_ref1_0_asm_h
	.p2align	2
	.type	put_var_ref1_0_asm_h,@function
put_var_ref1_0_asm_h:                   // @put_var_ref1_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end244:
	.size	put_var_ref1_0_asm_h, .Lfunc_end244-put_var_ref1_0_asm_h
                                        // -- End function
	.hidden	put_var_ref2_0_asm_h            // -- Begin function put_var_ref2_0_asm_h
	.globl	put_var_ref2_0_asm_h
	.p2align	2
	.type	put_var_ref2_0_asm_h,@function
put_var_ref2_0_asm_h:                   // @put_var_ref2_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end245:
	.size	put_var_ref2_0_asm_h, .Lfunc_end245-put_var_ref2_0_asm_h
                                        // -- End function
	.hidden	put_var_ref3_0_asm_h            // -- Begin function put_var_ref3_0_asm_h
	.globl	put_var_ref3_0_asm_h
	.p2align	2
	.type	put_var_ref3_0_asm_h,@function
put_var_ref3_0_asm_h:                   // @put_var_ref3_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end246:
	.size	put_var_ref3_0_asm_h, .Lfunc_end246-put_var_ref3_0_asm_h
                                        // -- End function
	.hidden	set_var_ref0_0_asm_h            // -- Begin function set_var_ref0_0_asm_h
	.globl	set_var_ref0_0_asm_h
	.p2align	2
	.type	set_var_ref0_0_asm_h,@function
set_var_ref0_0_asm_h:                   // @set_var_ref0_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end247:
	.size	set_var_ref0_0_asm_h, .Lfunc_end247-set_var_ref0_0_asm_h
                                        // -- End function
	.hidden	set_var_ref1_0_asm_h            // -- Begin function set_var_ref1_0_asm_h
	.globl	set_var_ref1_0_asm_h
	.p2align	2
	.type	set_var_ref1_0_asm_h,@function
set_var_ref1_0_asm_h:                   // @set_var_ref1_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end248:
	.size	set_var_ref1_0_asm_h, .Lfunc_end248-set_var_ref1_0_asm_h
                                        // -- End function
	.hidden	set_var_ref2_0_asm_h            // -- Begin function set_var_ref2_0_asm_h
	.globl	set_var_ref2_0_asm_h
	.p2align	2
	.type	set_var_ref2_0_asm_h,@function
set_var_ref2_0_asm_h:                   // @set_var_ref2_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end249:
	.size	set_var_ref2_0_asm_h, .Lfunc_end249-set_var_ref2_0_asm_h
                                        // -- End function
	.hidden	set_var_ref3_0_asm_h            // -- Begin function set_var_ref3_0_asm_h
	.globl	set_var_ref3_0_asm_h
	.p2align	2
	.type	set_var_ref3_0_asm_h,@function
set_var_ref3_0_asm_h:                   // @set_var_ref3_0_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end250:
	.size	set_var_ref3_0_asm_h, .Lfunc_end250-set_var_ref3_0_asm_h
                                        // -- End function
	.hidden	get_length_0_asm_h              // -- Begin function get_length_0_asm_h
	.globl	get_length_0_asm_h
	.p2align	2
	.type	get_length_0_asm_h,@function
get_length_0_asm_h:                     // @get_length_0_asm_h
// %bb.0:                               // %B24
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB251_10
// %bb.1:                               // %B25
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB251_2:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB251_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	mvn	w10, w10
	orr	w10, w10, #0xffffffcf
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB251_5
.LBB251_3:                              // %B1
                                        //   Parent Loop BB251_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, #48
	b.eq	.LBB251_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB251_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB251_3
.LBB251_5:                              // %B14
                                        //   in Loop: Header=BB251_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB251_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB251_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB251_2
	b	.LBB251_9
.LBB251_7:                              // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB251_10
// %bb.8:                               // %B4
	lsl	w8, w10, #1
	ldr	x9, [x9, #16]
	sub	w8, w8, #2
	ldr	x8, [x9, w8, sxtw #3]
.LBB251_9:                              // %B6
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB251_10:                             // %B21
	mov	x0, x24
	mov	x1, x22
	mov	w2, #48                         // =0x30
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB251_12
// %bb.11:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB251_12:                             // %B22
	b	exception_asm_h
.Lfunc_end251:
	.size	get_length_0_asm_h, .Lfunc_end251-get_length_0_asm_h
                                        // -- End function
	.hidden	if_false8_0_asm_h               // -- Begin function if_false8_0_asm_h
	.globl	if_false8_0_asm_h
	.p2align	2
	.type	if_false8_0_asm_h,@function
if_false8_0_asm_h:                      // @if_false8_0_asm_h
// %bb.0:                               // %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	.LBB252_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB252_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB252_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB252_6
	b	.LBB252_7
.LBB252_4:                              // %B23
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x9
	b.eq	.LBB252_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB252_7
.LBB252_6:                              // %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB252_7:                              // %B9
	mov	x9, #-281474976710656           // =0xffff000000000000
	cmp	x22, x9
	b.hs	.LBB252_13
// %bb.8:                               // %B11
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x9
	b.lo	.LBB252_10
.LBB252_9:                              // %B19
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB252_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB252_13
// %bb.11:                              // %B17
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB252_6
	b.vs	.LBB252_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB252_9
	b	.LBB252_6
.LBB252_13:                             // %B15
	mov	x20, x8
	mov	x0, x22
	b	SlowToBoolean_asm_h
.Lfunc_end252:
	.size	if_false8_0_asm_h, .Lfunc_end252-if_false8_0_asm_h
                                        // -- End function
	.hidden	if_true8_0_asm_h                // -- Begin function if_true8_0_asm_h
	.globl	if_true8_0_asm_h
	.p2align	2
	.type	if_true8_0_asm_h,@function
if_true8_0_asm_h:                       // @if_true8_0_asm_h
// %bb.0:                               // %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	.LBB253_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB253_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB253_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB253_6
	b	.LBB253_7
.LBB253_4:                              // %B23
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x9
	b.eq	.LBB253_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB253_7
.LBB253_6:                              // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB253_7:                              // %B9
	mov	x9, #-281474976710656           // =0xffff000000000000
	cmp	x22, x9
	b.hs	.LBB253_13
// %bb.8:                               // %B11
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x9
	b.lo	.LBB253_10
.LBB253_9:                              // %B19
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB253_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB253_13
// %bb.11:                              // %B17
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB253_6
	b.vs	.LBB253_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB253_9
	b	.LBB253_6
.LBB253_13:                             // %B15
	mov	x20, x8
	mov	x0, x22
	b	SlowToBoolean_asm_h
.Lfunc_end253:
	.size	if_true8_0_asm_h, .Lfunc_end253-if_true8_0_asm_h
                                        // -- End function
	.hidden	goto8_0_asm_h                   // -- Begin function goto8_0_asm_h
	.globl	goto8_0_asm_h
	.p2align	2
	.type	goto8_0_asm_h,@function
goto8_0_asm_h:                          // @goto8_0_asm_h
// %bb.0:                               // %B0
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end254:
	.size	goto8_0_asm_h, .Lfunc_end254-goto8_0_asm_h
                                        // -- End function
	.hidden	goto16_0_asm_h                  // -- Begin function goto16_0_asm_h
	.globl	goto16_0_asm_h
	.p2align	2
	.type	goto16_0_asm_h,@function
goto16_0_asm_h:                         // @goto16_0_asm_h
// %bb.0:                               // %B0
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end255:
	.size	goto16_0_asm_h, .Lfunc_end255-goto16_0_asm_h
                                        // -- End function
	.hidden	call0_0_asm_h                   // -- Begin function call0_0_asm_h
	.globl	call0_0_asm_h
	.p2align	2
	.type	call0_0_asm_h,@function
call0_0_asm_h:                          // @call0_0_asm_h
// %bb.0:                               // %B2
	str	x19, [x23, #48]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	str	x20, [x23, #64]
	mov	x0, xzr
	ldur	x22, [x20, #-8]
	bl	common_call_asm_h
	ldr	x19, [x23, #48]
	ldr	x20, [x23, #64]
	cmp	x0, #130
	ldp	x28, x27, [x23, #16]
	ldr	x26, [x23, #120]
	b.eq	.LBB256_2
// %bb.1:                               // %B4
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB256_2:                              // %B3
	b	exception_asm_h
.Lfunc_end256:
	.size	call0_0_asm_h, .Lfunc_end256-call0_0_asm_h
                                        // -- End function
	.hidden	call1_0_asm_h                   // -- Begin function call1_0_asm_h
	.globl	call1_0_asm_h
	.p2align	2
	.type	call1_0_asm_h,@function
call1_0_asm_h:                          // @call1_0_asm_h
// %bb.0:                               // %B2
	str	x19, [x23, #48]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	str	x20, [x23, #64]
	mov	w0, #1                          // =0x1
	ldur	x22, [x20, #-16]
	sub	x20, x20, #8
	bl	common_call_asm_h
	ldr	x19, [x23, #48]
	ldr	x20, [x23, #64]
	cmp	x0, #130
	ldp	x28, x27, [x23, #16]
	ldr	x26, [x23, #120]
	b.eq	.LBB257_2
// %bb.1:                               // %B4
	stur	x0, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB257_2:                              // %B3
	b	exception_asm_h
.Lfunc_end257:
	.size	call1_0_asm_h, .Lfunc_end257-call1_0_asm_h
                                        // -- End function
	.hidden	call2_0_asm_h                   // -- Begin function call2_0_asm_h
	.globl	call2_0_asm_h
	.p2align	2
	.type	call2_0_asm_h,@function
call2_0_asm_h:                          // @call2_0_asm_h
// %bb.0:                               // %B2
	str	x19, [x23, #48]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	str	x20, [x23, #64]
	mov	w0, #2                          // =0x2
	ldur	x22, [x20, #-24]
	sub	x20, x20, #16
	bl	common_call_asm_h
	ldr	x19, [x23, #48]
	ldr	x20, [x23, #64]
	cmp	x0, #130
	ldp	x28, x27, [x23, #16]
	ldr	x26, [x23, #120]
	b.eq	.LBB258_2
// %bb.1:                               // %B4
	stur	x0, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB258_2:                              // %B3
	b	exception_asm_h
.Lfunc_end258:
	.size	call2_0_asm_h, .Lfunc_end258-call2_0_asm_h
                                        // -- End function
	.hidden	call3_0_asm_h                   // -- Begin function call3_0_asm_h
	.globl	call3_0_asm_h
	.p2align	2
	.type	call3_0_asm_h,@function
call3_0_asm_h:                          // @call3_0_asm_h
// %bb.0:                               // %B2
	str	x19, [x23, #48]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	str	x20, [x23, #64]
	mov	w0, #3                          // =0x3
	ldur	x22, [x20, #-32]
	sub	x20, x20, #24
	bl	common_call_asm_h
	ldr	x19, [x23, #48]
	ldr	x20, [x23, #64]
	cmp	x0, #130
	ldp	x28, x27, [x23, #16]
	ldr	x26, [x23, #120]
	b.eq	.LBB259_2
// %bb.1:                               // %B4
	stur	x0, [x20, #-32]
	sub	x20, x20, #24
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB259_2:                              // %B3
	b	exception_asm_h
.Lfunc_end259:
	.size	call3_0_asm_h, .Lfunc_end259-call3_0_asm_h
                                        // -- End function
	.hidden	is_undefined_0_asm_h            // -- Begin function is_undefined_0_asm_h
	.globl	is_undefined_0_asm_h
	.p2align	2
	.type	is_undefined_0_asm_h,@function
is_undefined_0_asm_h:                   // @is_undefined_0_asm_h
// %bb.0:                               // %B2
	ldur	x22, [x20, #-8]
	cmp	x22, #18
	b.ne	.LBB260_2
// %bb.1:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB260_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end260:
	.size	is_undefined_0_asm_h, .Lfunc_end260-is_undefined_0_asm_h
                                        // -- End function
	.hidden	is_null_0_asm_h                 // -- Begin function is_null_0_asm_h
	.globl	is_null_0_asm_h
	.p2align	2
	.type	is_null_0_asm_h,@function
is_null_0_asm_h:                        // @is_null_0_asm_h
// %bb.0:                               // %B2
	ldur	x22, [x20, #-8]
	cmp	x22, #2
	b.ne	.LBB261_2
// %bb.1:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB261_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end261:
	.size	is_null_0_asm_h, .Lfunc_end261-is_null_0_asm_h
                                        // -- End function
	.hidden	is_function_0_asm_h             // -- Begin function is_function_0_asm_h
	.globl	is_function_0_asm_h
	.p2align	2
	.type	is_function_0_asm_h,@function
is_function_0_asm_h:                    // @is_function_0_asm_h
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	mov	x1, x22
	bl	js_operator_typeof_gc
	cmp	w0, #27
	b.ne	.LBB262_2
// %bb.1:                               // %B2
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB262_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end262:
	.size	is_function_0_asm_h, .Lfunc_end262-is_function_0_asm_h
                                        // -- End function
	.hidden	invalid_1_asm_h                 // -- Begin function invalid_1_asm_h
	.globl	invalid_1_asm_h
	.p2align	2
	.type	invalid_1_asm_h,@function
invalid_1_asm_h:                        // @invalid_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #8]
	adrp	x1, .L__unnamed_11
	add	x1, x1, :lo12:.L__unnamed_11
	mov	x0, x24
	mov	w3, wzr
	ldr	x8, [x8, #32]
	ldr	w8, [x8, #8]
	str	x20, [x23, #64]
	mvn	w8, w8
	add	w2, w8, w19
	bl	LEPUS_ThrowInternalError
	b	exception_asm_h
.Lfunc_end263:
	.size	invalid_1_asm_h, .Lfunc_end263-invalid_1_asm_h
                                        // -- End function
	.hidden	push_i32_1_asm_h                // -- Begin function push_i32_1_asm_h
	.globl	push_i32_1_asm_h
	.p2align	2
	.type	push_i32_1_asm_h,@function
push_i32_1_asm_h:                       // @push_i32_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #4]
	ldr	w9, [x19], #5
	add	w8, w8, #484
	orr	x21, x9, #0xfffe000000000000
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end264:
	.size	push_i32_1_asm_h, .Lfunc_end264-push_i32_1_asm_h
                                        // -- End function
	.hidden	push_const_1_asm_h              // -- Begin function push_const_1_asm_h
	.globl	push_const_1_asm_h
	.p2align	2
	.type	push_const_1_asm_h,@function
push_const_1_asm_h:                     // @push_const_1_asm_h
// %bb.0:                               // %B3
	sub	sp, sp, #16
	ldr	x8, [x23, #128]
	ldrsw	x9, [x19]
	ldr	w10, [x24, #336]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, .LBB265_2
// %bb.1:                               // %B4
	mov	x8, x20
	mov	x0, x24
	mov	x2, x19
	str	x22, [x8], #8
	str	x8, [x23, #64]
	str	x1, [sp, #8]                    // 8-byte Folded Spill
	bl	DebuggerPause
	ldr	x1, [sp, #8]                    // 8-byte Folded Reload
.LBB265_2:                              // %B1
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x1
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
.Lfunc_end265:
	.size	push_const_1_asm_h, .Lfunc_end265-push_const_1_asm_h
                                        // -- End function
	.hidden	fclosure_1_asm_h                // -- Begin function fclosure_1_asm_h
	.globl	fclosure_1_asm_h
	.p2align	2
	.type	fclosure_1_asm_h,@function
fclosure_1_asm_h:                       // @fclosure_1_asm_h
// %bb.0:                               // %B1
	ldr	x8, [x23, #128]
	ldrsw	x9, [x19]
	mov	x10, x20
	mov	x0, x24
	mov	x2, x26
	mov	x3, x23
	ldr	x1, [x8, x9, lsl #3]
	str	x22, [x10], #8
	str	x10, [x23, #64]
	bl	js_closure_gc
	cmp	x0, #130
	b.eq	.LBB266_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB266_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end266:
	.size	fclosure_1_asm_h, .Lfunc_end266-fclosure_1_asm_h
                                        // -- End function
	.hidden	push_atom_value_1_asm_h         // -- Begin function push_atom_value_1_asm_h
	.globl	push_atom_value_1_asm_h
	.p2align	2
	.type	push_atom_value_1_asm_h,@function
push_atom_value_1_asm_h:                // @push_atom_value_1_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB267_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB267_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end267:
	.size	push_atom_value_1_asm_h, .Lfunc_end267-push_atom_value_1_asm_h
                                        // -- End function
	.hidden	private_symbol_1_asm_h          // -- Begin function private_symbol_1_asm_h
	.globl	private_symbol_1_asm_h
	.p2align	2
	.type	private_symbol_1_asm_h,@function
private_symbol_1_asm_h:                 // @private_symbol_1_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #4                          // =0x4
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	.LBB268_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB268_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end268:
	.size	private_symbol_1_asm_h, .Lfunc_end268-private_symbol_1_asm_h
                                        // -- End function
	.hidden	undefined_1_asm_h               // -- Begin function undefined_1_asm_h
	.globl	undefined_1_asm_h
	.p2align	2
	.type	undefined_1_asm_h,@function
undefined_1_asm_h:                      // @undefined_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w21, #18                        // =0x12
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end269:
	.size	undefined_1_asm_h, .Lfunc_end269-undefined_1_asm_h
                                        // -- End function
	.hidden	null_1_asm_h                    // -- Begin function null_1_asm_h
	.globl	null_1_asm_h
	.p2align	2
	.type	null_1_asm_h,@function
null_1_asm_h:                           // @null_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w21, #2                         // =0x2
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end270:
	.size	null_1_asm_h, .Lfunc_end270-null_1_asm_h
                                        // -- End function
	.hidden	push_this_1_asm_h               // -- Begin function push_this_1_asm_h
	.globl	push_this_1_asm_h
	.p2align	2
	.type	push_this_1_asm_h,@function
push_this_1_asm_h:                      // @push_this_1_asm_h
// %bb.0:                               // %B12
	ldr	w8, [x23, #60]
	ldr	x1, [x23, #104]
	tbnz	w8, #0, .LBB271_2
// %bb.1:                               // %B12
	ldr	x8, [x23, #104]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, .LBB271_3
.LBB271_2:                              // %B3
	ldrb	w8, [x19], #1
	mov	x21, x1
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.LBB271_3:                              // %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	.LBB271_5
// %bb.4:                               // %B7
	ldrb	w8, [x19], #1
	ldr	x21, [x24, #208]
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB271_5:                              // %B9
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB271_7
// %bb.6:                               // %B11
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB271_7:                              // %B10
	b	exception_spill_top0_asm_h
.Lfunc_end271:
	.size	push_this_1_asm_h, .Lfunc_end271-push_this_1_asm_h
                                        // -- End function
	.hidden	push_false_1_asm_h              // -- Begin function push_false_1_asm_h
	.globl	push_false_1_asm_h
	.p2align	2
	.type	push_false_1_asm_h,@function
push_false_1_asm_h:                     // @push_false_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w21, #6                         // =0x6
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end272:
	.size	push_false_1_asm_h, .Lfunc_end272-push_false_1_asm_h
                                        // -- End function
	.hidden	push_true_1_asm_h               // -- Begin function push_true_1_asm_h
	.globl	push_true_1_asm_h
	.p2align	2
	.type	push_true_1_asm_h,@function
push_true_1_asm_h:                      // @push_true_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	w21, #7                         // =0x7
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end273:
	.size	push_true_1_asm_h, .Lfunc_end273-push_true_1_asm_h
                                        // -- End function
	.hidden	object_1_asm_h                  // -- Begin function object_1_asm_h
	.globl	object_1_asm_h
	.p2align	2
	.type	object_1_asm_h,@function
object_1_asm_h:                         // @object_1_asm_h
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	.LBB274_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB274_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end274:
	.size	object_1_asm_h, .Lfunc_end274-object_1_asm_h
                                        // -- End function
	.hidden	special_object_1_asm_h          // -- Begin function special_object_1_asm_h
	.globl	special_object_1_asm_h
	.p2align	2
	.type	special_object_1_asm_h,@function
special_object_1_asm_h:                 // @special_object_1_asm_h
// %bb.0:                               // %B15
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	.LBB275_4
// %bb.1:                               // %B15
	cbz	w8, .LBB275_7
// %bb.2:                               // %B15
	cmp	w8, #1
	b.ne	.LBB275_12
// %bb.3:                               // %B6
	ldr	x8, [x23, #8]
	ldr	w1, [x23, #136]
	mov	x9, x20
	mov	x0, x24
	mov	x2, x28
	mov	x3, x23
	ldr	x8, [x8, #32]
	ldrh	w8, [x8, #40]
	str	x22, [x9], #8
	str	x9, [x23, #64]
	cmp	w8, w1
	csel	w4, w8, w1, lt
	bl	js_build_mapped_arguments_gc
	b	.LBB275_8
.LBB275_4:                              // %B15
	cmp	w8, #5
	b.eq	.LBB275_10
// %bb.5:                               // %B15
	cmp	w8, #4
	b.ne	.LBB275_13
// %bb.6:                               // %B9
	ldr	x8, [x23, #8]
	mov	w9, #18                         // =0x12
	ldr	x8, [x8, #48]
	cmp	x8, #0
	csel	x8, x9, x8, eq
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB275_7:                              // %B1
	ldr	w1, [x23, #136]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x28
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	js_build_arguments_gc
.LBB275_8:                              // %B6
	cmp	x0, #130
	b.eq	.LBB275_11
.LBB275_9:
	mov	x8, x0
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB275_10:                             // %B12
	mov	x8, x20
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.ne	.LBB275_9
.LBB275_11:                             // %B13
	b	exception_spill_top0_asm_h
.LBB275_12:                             // %B18
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB275_13:                             // %B19
	ldr	x8, [x23, #112]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end275:
	.size	special_object_1_asm_h, .Lfunc_end275-special_object_1_asm_h
                                        // -- End function
	.hidden	rest_1_asm_h                    // -- Begin function rest_1_asm_h
	.globl	rest_1_asm_h
	.p2align	2
	.type	rest_1_asm_h,@function
rest_1_asm_h:                           // @rest_1_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x23, #136]
	ldrh	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x3, x28
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	js_build_rest_gc
	cmp	x0, #130
	b.eq	.LBB276_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB276_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end276:
	.size	rest_1_asm_h, .Lfunc_end276-rest_1_asm_h
                                        // -- End function
	.hidden	drop_1_asm_h                    // -- Begin function drop_1_asm_h
	.globl	drop_1_asm_h
	.p2align	2
	.type	drop_1_asm_h,@function
drop_1_asm_h:                           // @drop_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end277:
	.size	drop_1_asm_h, .Lfunc_end277-drop_1_asm_h
                                        // -- End function
	.hidden	nip_1_asm_h                     // -- Begin function nip_1_asm_h
	.globl	nip_1_asm_h
	.p2align	2
	.type	nip_1_asm_h,@function
nip_1_asm_h:                            // @nip_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end278:
	.size	nip_1_asm_h, .Lfunc_end278-nip_1_asm_h
                                        // -- End function
	.hidden	nip1_1_asm_h                    // -- Begin function nip1_1_asm_h
	.globl	nip1_1_asm_h
	.p2align	2
	.type	nip1_1_asm_h,@function
nip1_1_asm_h:                           // @nip1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	sub	x8, x20, #16
	mov	x20, x8
	br	x1
.Lfunc_end279:
	.size	nip1_1_asm_h, .Lfunc_end279-nip1_1_asm_h
                                        // -- End function
	.hidden	dup_1_asm_h                     // -- Begin function dup_1_asm_h
	.globl	dup_1_asm_h
	.p2align	2
	.type	dup_1_asm_h,@function
dup_1_asm_h:                            // @dup_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end280:
	.size	dup_1_asm_h, .Lfunc_end280-dup_1_asm_h
                                        // -- End function
	.hidden	dup1_1_asm_h                    // -- Begin function dup1_1_asm_h
	.globl	dup1_1_asm_h
	.p2align	2
	.type	dup1_1_asm_h,@function
dup1_1_asm_h:                           // @dup1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	mov	x1, x22
	mov	x22, x21
	mov	x22, x1
	br	x2
.Lfunc_end281:
	.size	dup1_1_asm_h, .Lfunc_end281-dup1_1_asm_h
                                        // -- End function
	.hidden	dup2_1_asm_h                    // -- Begin function dup2_1_asm_h
	.globl	dup2_1_asm_h
	.p2align	2
	.type	dup2_1_asm_h,@function
dup2_1_asm_h:                           // @dup2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20]
	mov	x21, x22
	ldrb	w8, [x19], #1
	ldr	x22, [x20], #8
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end282:
	.size	dup2_1_asm_h, .Lfunc_end282-dup2_1_asm_h
                                        // -- End function
	.hidden	dup3_1_asm_h                    // -- Begin function dup3_1_asm_h
	.globl	dup3_1_asm_h
	.p2align	2
	.type	dup3_1_asm_h,@function
dup3_1_asm_h:                           // @dup3_1_asm_h
// %bb.0:                               // %B0
	ldur	x8, [x20, #-16]
	mov	x21, x22
	stp	x22, x8, [x20], #16
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end283:
	.size	dup3_1_asm_h, .Lfunc_end283-dup3_1_asm_h
                                        // -- End function
	.hidden	insert2_1_asm_h                 // -- Begin function insert2_1_asm_h
	.globl	insert2_1_asm_h
	.p2align	2
	.type	insert2_1_asm_h,@function
insert2_1_asm_h:                        // @insert2_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x21, [x20, #-8]
	ldrb	w8, [x19], #1
	mov	x1, x22
	mov	x22, x21
	add	w8, w8, #484
	mov	x22, x1
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.Lfunc_end284:
	.size	insert2_1_asm_h, .Lfunc_end284-insert2_1_asm_h
                                        // -- End function
	.hidden	insert3_1_asm_h                 // -- Begin function insert3_1_asm_h
	.globl	insert3_1_asm_h
	.p2align	2
	.type	insert3_1_asm_h,@function
insert3_1_asm_h:                        // @insert3_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldp	x8, x22, [x20, #-16]
	stp	x21, x8, [x20, #-16]
	mov	x2, x22
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x22, x2
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end285:
	.size	insert3_1_asm_h, .Lfunc_end285-insert3_1_asm_h
                                        // -- End function
	.hidden	insert4_1_asm_h                 // -- Begin function insert4_1_asm_h
	.globl	insert4_1_asm_h
	.p2align	2
	.type	insert4_1_asm_h,@function
insert4_1_asm_h:                        // @insert4_1_asm_h
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
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.Lfunc_end286:
	.size	insert4_1_asm_h, .Lfunc_end286-insert4_1_asm_h
                                        // -- End function
	.hidden	perm3_1_asm_h                   // -- Begin function perm3_1_asm_h
	.globl	perm3_1_asm_h
	.p2align	2
	.type	perm3_1_asm_h,@function
perm3_1_asm_h:                          // @perm3_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end287:
	.size	perm3_1_asm_h, .Lfunc_end287-perm3_1_asm_h
                                        // -- End function
	.hidden	perm4_1_asm_h                   // -- Begin function perm4_1_asm_h
	.globl	perm4_1_asm_h
	.p2align	2
	.type	perm4_1_asm_h,@function
perm4_1_asm_h:                          // @perm4_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	mov	x9, x22
	ldp	x8, x22, [x20, #-16]
	stp	x9, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end288:
	.size	perm4_1_asm_h, .Lfunc_end288-perm4_1_asm_h
                                        // -- End function
	.hidden	perm5_1_asm_h                   // -- Begin function perm5_1_asm_h
	.globl	perm5_1_asm_h
	.p2align	2
	.type	perm5_1_asm_h,@function
perm5_1_asm_h:                          // @perm5_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldp	x9, x8, [x20, #-24]
	mov	x10, x22
	ldur	x22, [x20, #-8]
	stur	x10, [x20, #-24]
	stp	x9, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end289:
	.size	perm5_1_asm_h, .Lfunc_end289-perm5_1_asm_h
                                        // -- End function
	.hidden	swap_1_asm_h                    // -- Begin function swap_1_asm_h
	.globl	swap_1_asm_h
	.p2align	2
	.type	swap_1_asm_h,@function
swap_1_asm_h:                           // @swap_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	mov	x1, x22
	mov	x22, x21
	mov	x21, x1
	br	x2
.Lfunc_end290:
	.size	swap_1_asm_h, .Lfunc_end290-swap_1_asm_h
                                        // -- End function
	.hidden	swap2_1_asm_h                   // -- Begin function swap2_1_asm_h
	.globl	swap2_1_asm_h
	.p2align	2
	.type	swap2_1_asm_h,@function
swap2_1_asm_h:                          // @swap2_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldp	x8, x9, [x20, #-16]
	stp	x22, x21, [x20, #-16]
	ldrb	w10, [x19], #1
	mov	x22, x8
	mov	x21, x9
	add	w10, w10, #484
	ldr	x1, [x25, w10, uxtw #3]
	br	x1
.Lfunc_end291:
	.size	swap2_1_asm_h, .Lfunc_end291-swap2_1_asm_h
                                        // -- End function
	.hidden	rot3l_1_asm_h                   // -- Begin function rot3l_1_asm_h
	.globl	rot3l_1_asm_h
	.p2align	2
	.type	rot3l_1_asm_h,@function
rot3l_1_asm_h:                          // @rot3l_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldur	x8, [x20, #-8]
	stur	x22, [x20, #-8]
	mov	x22, x21
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end292:
	.size	rot3l_1_asm_h, .Lfunc_end292-rot3l_1_asm_h
                                        // -- End function
	.hidden	rot3r_1_asm_h                   // -- Begin function rot3r_1_asm_h
	.globl	rot3r_1_asm_h
	.p2align	2
	.type	rot3r_1_asm_h,@function
rot3r_1_asm_h:                          // @rot3r_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	mov	x8, x21
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end293:
	.size	rot3r_1_asm_h, .Lfunc_end293-rot3r_1_asm_h
                                        // -- End function
	.hidden	rot4l_1_asm_h                   // -- Begin function rot4l_1_asm_h
	.globl	rot4l_1_asm_h
	.p2align	2
	.type	rot4l_1_asm_h,@function
rot4l_1_asm_h:                          // @rot4l_1_asm_h
// %bb.0:                               // %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldp	x9, x8, [x20, #-16]
	stp	x8, x22, [x20, #-16]
	mov	x22, x21
	mov	x21, x9
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end294:
	.size	rot4l_1_asm_h, .Lfunc_end294-rot4l_1_asm_h
                                        // -- End function
	.hidden	rot5l_1_asm_h                   // -- Begin function rot5l_1_asm_h
	.globl	rot5l_1_asm_h
	.p2align	2
	.type	rot5l_1_asm_h,@function
rot5l_1_asm_h:                          // @rot5l_1_asm_h
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
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end295:
	.size	rot5l_1_asm_h, .Lfunc_end295-rot5l_1_asm_h
                                        // -- End function
	.hidden	call_constructor_1_asm_h        // -- Begin function call_constructor_1_asm_h
	.globl	call_constructor_1_asm_h
	.p2align	2
	.type	call_constructor_1_asm_h,@function
call_constructor_1_asm_h:               // @call_constructor_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	call_constructor_0_asm_h
.Lfunc_end296:
	.size	call_constructor_1_asm_h, .Lfunc_end296-call_constructor_1_asm_h
                                        // -- End function
	.hidden	call_1_asm_h                    // -- Begin function call_1_asm_h
	.globl	call_1_asm_h
	.p2align	2
	.type	call_1_asm_h,@function
call_1_asm_h:                           // @call_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	call_0_asm_h
.Lfunc_end297:
	.size	call_1_asm_h, .Lfunc_end297-call_1_asm_h
                                        // -- End function
	.hidden	tail_call_1_asm_h               // -- Begin function tail_call_1_asm_h
	.globl	tail_call_1_asm_h
	.p2align	2
	.type	tail_call_1_asm_h,@function
tail_call_1_asm_h:                      // @tail_call_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	tail_call_0_asm_h
.Lfunc_end298:
	.size	tail_call_1_asm_h, .Lfunc_end298-tail_call_1_asm_h
                                        // -- End function
	.hidden	call_method_1_asm_h             // -- Begin function call_method_1_asm_h
	.globl	call_method_1_asm_h
	.p2align	2
	.type	call_method_1_asm_h,@function
call_method_1_asm_h:                    // @call_method_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	call_method_0_asm_h
.Lfunc_end299:
	.size	call_method_1_asm_h, .Lfunc_end299-call_method_1_asm_h
                                        // -- End function
	.hidden	tail_call_method_1_asm_h        // -- Begin function tail_call_method_1_asm_h
	.globl	tail_call_method_1_asm_h
	.p2align	2
	.type	tail_call_method_1_asm_h,@function
tail_call_method_1_asm_h:               // @tail_call_method_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	tail_call_method_0_asm_h
.Lfunc_end300:
	.size	tail_call_method_1_asm_h, .Lfunc_end300-tail_call_method_1_asm_h
                                        // -- End function
	.hidden	array_from_1_asm_h              // -- Begin function array_from_1_asm_h
	.globl	array_from_1_asm_h
	.p2align	2
	.type	array_from_1_asm_h,@function
array_from_1_asm_h:                     // @array_from_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	array_from_0_asm_h
.Lfunc_end301:
	.size	array_from_1_asm_h, .Lfunc_end301-array_from_1_asm_h
                                        // -- End function
	.hidden	apply_1_asm_h                   // -- Begin function apply_1_asm_h
	.globl	apply_1_asm_h
	.p2align	2
	.type	apply_1_asm_h,@function
apply_1_asm_h:                          // @apply_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	apply_0_asm_h
.Lfunc_end302:
	.size	apply_1_asm_h, .Lfunc_end302-apply_1_asm_h
                                        // -- End function
	.hidden	return_1_asm_h                  // -- Begin function return_1_asm_h
	.globl	return_1_asm_h
	.p2align	2
	.type	return_1_asm_h,@function
return_1_asm_h:                         // @return_1_asm_h
// %bb.0:                               // %B0
	mov	x0, x22
	b	common_return_asm_h
.Lfunc_end303:
	.size	return_1_asm_h, .Lfunc_end303-return_1_asm_h
                                        // -- End function
	.hidden	return_undef_1_asm_h            // -- Begin function return_undef_1_asm_h
	.globl	return_undef_1_asm_h
	.p2align	2
	.type	return_undef_1_asm_h,@function
return_undef_1_asm_h:                   // @return_undef_1_asm_h
// %bb.0:                               // %B0
	mov	w0, #18                         // =0x12
	b	common_return_asm_h
.Lfunc_end304:
	.size	return_undef_1_asm_h, .Lfunc_end304-return_undef_1_asm_h
                                        // -- End function
	.hidden	check_ctor_return_1_asm_h       // -- Begin function check_ctor_return_1_asm_h
	.globl	check_ctor_return_1_asm_h
	.p2align	2
	.type	check_ctor_return_1_asm_h,@function
check_ctor_return_1_asm_h:              // @check_ctor_return_1_asm_h
// %bb.0:                               // %B5
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	.LBB305_3
// %bb.1:                               // %B2
	cmp	x22, #18
	b.eq	.LBB305_4
// %bb.2:                               // %B3
	mov	x8, x20
	adrp	x1, .L__unnamed_12
	add	x1, x1, :lo12:.L__unnamed_12
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	LEPUS_ThrowTypeError
	b	exception_spill_top0_asm_h
.LBB305_3:                              // %B6
	ldrb	w8, [x19], #1
	mov	w21, #6                         // =0x6
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB305_4:                              // %B4
	ldrb	w8, [x19], #1
	mov	w21, #7                         // =0x7
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end305:
	.size	check_ctor_return_1_asm_h, .Lfunc_end305-check_ctor_return_1_asm_h
                                        // -- End function
	.hidden	check_ctor_1_asm_h              // -- Begin function check_ctor_1_asm_h
	.globl	check_ctor_1_asm_h
	.p2align	2
	.type	check_ctor_1_asm_h,@function
check_ctor_1_asm_h:                     // @check_ctor_1_asm_h
// %bb.0:                               // %B2
	ldr	x8, [x23, #112]
	cmp	x8, #18
	b.ne	.LBB306_2
// %bb.1:                               // %B3
	mov	x8, x20
	adrp	x1, .L__unnamed_13
	add	x1, x1, :lo12:.L__unnamed_13
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	LEPUS_ThrowTypeError
	b	exception_spill_top0_asm_h
.LBB306_2:                              // %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end306:
	.size	check_ctor_1_asm_h, .Lfunc_end306-check_ctor_1_asm_h
                                        // -- End function
	.hidden	check_brand_1_asm_h             // -- Begin function check_brand_1_asm_h
	.globl	check_brand_1_asm_h
	.p2align	2
	.type	check_brand_1_asm_h,@function
check_brand_1_asm_h:                    // @check_brand_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #64]
	bl	JS_CheckBrand_GC
	tbnz	w0, #31, .LBB307_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB307_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end307:
	.size	check_brand_1_asm_h, .Lfunc_end307-check_brand_1_asm_h
                                        // -- End function
	.hidden	add_brand_1_asm_h               // -- Begin function add_brand_1_asm_h
	.globl	add_brand_1_asm_h
	.p2align	2
	.type	add_brand_1_asm_h,@function
add_brand_1_asm_h:                      // @add_brand_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #64]
	bl	JS_AddBrand_GC
	tbnz	w0, #31, .LBB308_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB308_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end308:
	.size	add_brand_1_asm_h, .Lfunc_end308-add_brand_1_asm_h
                                        // -- End function
	.hidden	return_async_1_asm_h            // -- Begin function return_async_1_asm_h
	.globl	return_async_1_asm_h
	.p2align	2
	.type	return_async_1_asm_h,@function
return_async_1_asm_h:                   // @return_async_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	return_async_0_asm_h
.Lfunc_end309:
	.size	return_async_1_asm_h, .Lfunc_end309-return_async_1_asm_h
                                        // -- End function
	.hidden	throw_1_asm_h                   // -- Begin function throw_1_asm_h
	.globl	throw_1_asm_h
	.p2align	2
	.type	throw_1_asm_h,@function
throw_1_asm_h:                          // @throw_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	throw_0_asm_h
.Lfunc_end310:
	.size	throw_1_asm_h, .Lfunc_end310-throw_1_asm_h
                                        // -- End function
	.hidden	throw_var_1_asm_h               // -- Begin function throw_var_1_asm_h
	.globl	throw_var_1_asm_h
	.p2align	2
	.type	throw_var_1_asm_h,@function
throw_var_1_asm_h:                      // @throw_var_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	throw_var_0_asm_h
.Lfunc_end311:
	.size	throw_var_1_asm_h, .Lfunc_end311-throw_var_1_asm_h
                                        // -- End function
	.hidden	eval_1_asm_h                    // -- Begin function eval_1_asm_h
	.globl	eval_1_asm_h
	.p2align	2
	.type	eval_1_asm_h,@function
eval_1_asm_h:                           // @eval_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	eval_0_asm_h
.Lfunc_end312:
	.size	eval_1_asm_h, .Lfunc_end312-eval_1_asm_h
                                        // -- End function
	.hidden	regexp_1_asm_h                  // -- Begin function regexp_1_asm_h
	.globl	regexp_1_asm_h
	.p2align	2
	.type	regexp_1_asm_h,@function
regexp_1_asm_h:                         // @regexp_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	w1, #18                         // =0x12
	mov	x3, x21
	mov	x2, x22
	str	x21, [x20]
	str	x8, [x23, #64]
	bl	js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	.LBB313_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB313_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end313:
	.size	regexp_1_asm_h, .Lfunc_end313-regexp_1_asm_h
                                        // -- End function
	.hidden	get_super_ctor_1_asm_h          // -- Begin function get_super_ctor_1_asm_h
	.globl	get_super_ctor_1_asm_h
	.p2align	2
	.type	get_super_ctor_1_asm_h,@function
get_super_ctor_1_asm_h:                 // @get_super_ctor_1_asm_h
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	.LBB314_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB314_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end314:
	.size	get_super_ctor_1_asm_h, .Lfunc_end314-get_super_ctor_1_asm_h
                                        // -- End function
	.hidden	get_super_1_asm_h               // -- Begin function get_super_1_asm_h
	.globl	get_super_1_asm_h
	.p2align	2
	.type	get_super_1_asm_h,@function
get_super_1_asm_h:                      // @get_super_1_asm_h
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	LEPUS_GetPrototype
	cmp	x0, #130
	b.eq	.LBB315_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB315_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end315:
	.size	get_super_1_asm_h, .Lfunc_end315-get_super_1_asm_h
                                        // -- End function
	.hidden	import_1_asm_h                  // -- Begin function import_1_asm_h
	.globl	import_1_asm_h
	.p2align	2
	.type	import_1_asm_h,@function
import_1_asm_h:                         // @import_1_asm_h
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	js_dynamic_import
	cmp	x0, #130
	b.eq	.LBB316_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB316_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end316:
	.size	import_1_asm_h, .Lfunc_end316-import_1_asm_h
                                        // -- End function
	.hidden	check_var_1_asm_h               // -- Begin function check_var_1_asm_h
	.globl	check_var_1_asm_h
	.p2align	2
	.type	check_var_1_asm_h,@function
check_var_1_asm_h:                      // @check_var_1_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	JS_CheckGlobalVar_GC
	tbnz	w0, #31, .LBB317_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x21, x8, ne
	br	x1
.LBB317_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end317:
	.size	check_var_1_asm_h, .Lfunc_end317-check_var_1_asm_h
                                        // -- End function
	.hidden	get_var_undef_1_asm_h           // -- Begin function get_var_undef_1_asm_h
	.globl	get_var_undef_1_asm_h
	.p2align	2
	.type	get_var_undef_1_asm_h,@function
get_var_undef_1_asm_h:                  // @get_var_undef_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x24, #216]
	ldr	w9, [x19]
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	and	w11, w9, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, .LBB318_3
.LBB318_1:                              // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldr	w13, [x12, #44]
	cmp	w13, w9
	b.eq	.LBB318_10
// %bb.2:                               // %B8
                                        //   in Loop: Header=BB318_1 Depth=1
	ldur	w11, [x12, #40]
	and	w11, w11, #0x3ffffff
	cbnz	w11, .LBB318_1
.LBB318_3:                              // %B11
	ldr	x8, [x24, #208]
	mov	w10, #18                        // =0x12
.LBB318_4:                              // %B33
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB318_5 Depth 2
	ldr	x12, [x8, #8]
	ldr	w11, [x12, #12]
	and	w11, w9, w11
	mvn	w11, w11
	ldr	w11, [x12, w11, sxtw #2]
	cbz	w11, .LBB318_7
.LBB318_5:                              // %B22
                                        //   Parent Loop BB318_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w9
	b.eq	.LBB318_9
// %bb.6:                               // %B24
                                        //   in Loop: Header=BB318_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB318_5
.LBB318_7:                              // %B27
                                        //   in Loop: Header=BB318_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	.LBB318_13
// %bb.8:                               // %B30
                                        //   in Loop: Header=BB318_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB318_4
	b	.LBB318_11
.LBB318_9:                              // %B12
	lsr	w9, w13, #26
	tst	w9, #0x30
	b.ne	.LBB318_13
.LBB318_10:                             // %B7.sink.split
	lsl	w9, w11, #1
	ldr	x8, [x8, #16]
	sub	w9, w9, #2
	ldr	x10, [x8, w9, sxtw #3]
.LBB318_11:                             // %B7
	cmp	x10, #34
	b.eq	.LBB318_15
// %bb.12:                              // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x10
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB318_13:                             // %B17
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB318_16
// %bb.14:                              // %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB318_15:                             // %B3
	str	x22, [x20], #8
	b	ThrowReferenceErrorUninitialized_asm_h
.LBB318_16:                             // %B18
	b	exception_spill_top0_asm_h
.Lfunc_end318:
	.size	get_var_undef_1_asm_h, .Lfunc_end318-get_var_undef_1_asm_h
                                        // -- End function
	.hidden	get_var_1_asm_h                 // -- Begin function get_var_1_asm_h
	.globl	get_var_1_asm_h
	.p2align	2
	.type	get_var_1_asm_h,@function
get_var_1_asm_h:                        // @get_var_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x24, #216]
	ldr	w9, [x19]
	ldr	x11, [x8, #8]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB319_3
.LBB319_1:                              // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #44]
	cmp	w13, w9
	b.eq	.LBB319_10
// %bb.2:                               // %B8
                                        //   in Loop: Header=BB319_1 Depth=1
	ldur	w10, [x12, #40]
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB319_1
.LBB319_3:                              // %B11
	ldr	x8, [x24, #208]
.LBB319_4:                              // %B32
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB319_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB319_7
.LBB319_5:                              // %B21
                                        //   Parent Loop BB319_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w9
	b.eq	.LBB319_9
// %bb.6:                               // %B23
                                        //   in Loop: Header=BB319_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB319_5
.LBB319_7:                              // %B26
                                        //   in Loop: Header=BB319_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB319_12
// %bb.8:                               // %B29
                                        //   in Loop: Header=BB319_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB319_4
	b	.LBB319_12
.LBB319_9:                              // %B12
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	.LBB319_12
.LBB319_10:                             // %B7
	lsl	w9, w10, #1
	ldr	x8, [x8, #16]
	sub	w9, w9, #2
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	.LBB319_14
// %bb.11:                              // %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB319_12:                             // %B16
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB319_15
// %bb.13:                              // %B18
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB319_14:                             // %B3
	str	x22, [x20], #8
	b	ThrowReferenceErrorUninitialized_asm_h
.LBB319_15:                             // %B17
	b	exception_spill_top0_asm_h
.Lfunc_end319:
	.size	get_var_1_asm_h, .Lfunc_end319-get_var_1_asm_h
                                        // -- End function
	.hidden	put_var_1_asm_h                 // -- Begin function put_var_1_asm_h
	.globl	put_var_1_asm_h
	.p2align	2
	.type	put_var_1_asm_h,@function
put_var_1_asm_h:                        // @put_var_1_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	w3, wzr
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB320_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB320_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end320:
	.size	put_var_1_asm_h, .Lfunc_end320-put_var_1_asm_h
                                        // -- End function
	.hidden	put_var_init_1_asm_h            // -- Begin function put_var_init_1_asm_h
	.globl	put_var_init_1_asm_h
	.p2align	2
	.type	put_var_init_1_asm_h,@function
put_var_init_1_asm_h:                   // @put_var_init_1_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	w3, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB321_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB321_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end321:
	.size	put_var_init_1_asm_h, .Lfunc_end321-put_var_init_1_asm_h
                                        // -- End function
	.hidden	put_var_strict_1_asm_h          // -- Begin function put_var_strict_1_asm_h
	.globl	put_var_strict_1_asm_h
	.p2align	2
	.type	put_var_strict_1_asm_h,@function
put_var_strict_1_asm_h:                 // @put_var_strict_1_asm_h
// %bb.0:                               // %B5
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	cmp	x22, #7
	b.ne	.LBB322_3
// %bb.1:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          // =0x2
	stur	x21, [x8, #-8]
	str	x8, [x23, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB322_4
// %bb.2:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB322_3:                              // %B6
	ldr	w1, [x19]
	mov	x0, x24
	str	x21, [x20]
	str	x8, [x23, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB322_4:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end322:
	.size	put_var_strict_1_asm_h, .Lfunc_end322-put_var_strict_1_asm_h
                                        // -- End function
	.hidden	get_ref_value_1_asm_h           // -- Begin function get_ref_value_1_asm_h
	.globl	get_ref_value_1_asm_h
	.p2align	2
	.type	get_ref_value_1_asm_h,@function
get_ref_value_1_asm_h:                  // @get_ref_value_1_asm_h
// %bb.0:                               // %B8
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	str	x21, [x20]
	mov	x0, x24
	cmp	x22, #18
	str	x8, [x23, #64]
	b.eq	.LBB323_3
// %bb.1:                               // %B1
	mov	x1, x22
	mov	x2, x21
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB323_5
// %bb.2:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB323_3:                              // %B5
	mov	x1, x21
	bl	js_value_to_atom_gc
	cbz	w0, .LBB323_5
// %bb.4:                               // %B7
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB323_5:                              // %B6
	b	exception_spill_top1_asm_h
.Lfunc_end323:
	.size	get_ref_value_1_asm_h, .Lfunc_end323-get_ref_value_1_asm_h
                                        // -- End function
	.hidden	put_ref_value_1_asm_h           // -- Begin function put_ref_value_1_asm_h
	.globl	put_ref_value_1_asm_h
	.p2align	2
	.type	put_ref_value_1_asm_h,@function
put_ref_value_1_asm_h:                  // @put_ref_value_1_asm_h
// %bb.0:                               // %B12
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	cmp	x1, #18
	b.eq	.LBB324_3
.LBB324_1:                              // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	JS_SetPropertyValue_GC
	tbnz	w0, #31, .LBB324_7
// %bb.2:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB324_3:                              // %B8
	ldrb	w8, [x23, #60]
	tbnz	w8, #0, .LBB324_5
// %bb.4:                               // %B9
	ldr	x1, [x24, #208]
	b	.LBB324_1
.LBB324_5:                              // %B5
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB324_7
// %bb.6:                               // %B7
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB324_7:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end324:
	.size	put_ref_value_1_asm_h, .Lfunc_end324-put_ref_value_1_asm_h
                                        // -- End function
	.hidden	define_var_1_asm_h              // -- Begin function define_var_1_asm_h
	.globl	define_var_1_asm_h
	.p2align	2
	.type	define_var_1_asm_h,@function
define_var_1_asm_h:                     // @define_var_1_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	JS_DefineGlobalVar_GC
	tbnz	w0, #31, .LBB325_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB325_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end325:
	.size	define_var_1_asm_h, .Lfunc_end325-define_var_1_asm_h
                                        // -- End function
	.hidden	check_define_var_1_asm_h        // -- Begin function check_define_var_1_asm_h
	.globl	check_define_var_1_asm_h
	.p2align	2
	.type	check_define_var_1_asm_h,@function
check_define_var_1_asm_h:               // @check_define_var_1_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, .LBB326_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB326_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end326:
	.size	check_define_var_1_asm_h, .Lfunc_end326-check_define_var_1_asm_h
                                        // -- End function
	.hidden	define_func_1_asm_h             // -- Begin function define_func_1_asm_h
	.globl	define_func_1_asm_h
	.p2align	2
	.type	define_func_1_asm_h,@function
define_func_1_asm_h:                    // @define_func_1_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w3, [x19, #4]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	JS_DefineGlobalFunction_GC
	tbnz	w0, #31, .LBB327_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB327_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end327:
	.size	define_func_1_asm_h, .Lfunc_end327-define_func_1_asm_h
                                        // -- End function
	.hidden	get_field_1_asm_h               // -- Begin function get_field_1_asm_h
	.globl	get_field_1_asm_h
	.p2align	2
	.type	get_field_1_asm_h,@function
get_field_1_asm_h:                      // @get_field_1_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB328_10
// %bb.1:                               // %B25
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB328_2:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB328_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB328_5
.LBB328_3:                              // %B1
                                        //   Parent Loop BB328_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w2
	b.eq	.LBB328_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB328_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB328_3
.LBB328_5:                              // %B14
                                        //   in Loop: Header=BB328_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB328_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB328_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB328_2
	b	.LBB328_9
.LBB328_7:                              // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB328_10
// %bb.8:                               // %B4
	lsl	w8, w10, #1
	ldr	x9, [x9, #16]
	sub	w8, w8, #2
	ldr	x8, [x9, w8, sxtw #3]
.LBB328_9:                              // %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB328_10:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB328_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB328_12:                             // %B22
	b	exception_spill_top0_asm_h
.Lfunc_end328:
	.size	get_field_1_asm_h, .Lfunc_end328-get_field_1_asm_h
                                        // -- End function
	.hidden	get_field2_1_asm_h              // -- Begin function get_field2_1_asm_h
	.globl	get_field2_1_asm_h
	.p2align	2
	.type	get_field2_1_asm_h,@function
get_field2_1_asm_h:                     // @get_field2_1_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB329_10
// %bb.1:                               // %B25
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB329_2:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB329_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB329_5
.LBB329_3:                              // %B1
                                        //   Parent Loop BB329_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w2
	b.eq	.LBB329_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB329_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB329_3
.LBB329_5:                              // %B14
                                        //   in Loop: Header=BB329_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB329_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB329_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB329_2
	b	.LBB329_9
.LBB329_7:                              // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB329_10
// %bb.8:                               // %B4
	lsl	w8, w10, #1
	ldr	x9, [x9, #16]
	sub	w8, w8, #2
	ldr	x8, [x9, w8, sxtw #3]
.LBB329_9:                              // %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB329_10:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB329_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB329_12:                             // %B22
	b	exception_spill_top0_asm_h
.Lfunc_end329:
	.size	get_field2_1_asm_h, .Lfunc_end329-get_field2_1_asm_h
                                        // -- End function
	.hidden	put_field_1_asm_h               // -- Begin function put_field_1_asm_h
	.globl	put_field_1_asm_h
	.p2align	2
	.type	put_field_1_asm_h,@function
put_field_1_asm_h:                      // @put_field_1_asm_h
// %bb.0:                               // %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	ldr	w2, [x19]
	tst	x22, x8
	b.ne	.LBB330_17
// %bb.1:                               // %B45
	ldr	x9, [x22, #8]
	ldr	w8, [x9, #12]
	and	w8, w2, w8
	mvn	w8, w8
	ldr	w8, [x9, w8, sxtw #2]
	cbz	w8, .LBB330_4
.LBB330_2:                              // %B1
                                        // =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10, #40]
	cmp	w11, w2
	b.eq	.LBB330_13
// %bb.3:                               // %B12
                                        //   in Loop: Header=BB330_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, .LBB330_2
.LBB330_4:                              // %B17.preheader
	mov	x8, x22
.LBB330_5:                              // %B17
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB330_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x9, w10, sxtw #2]
	cbz	w10, .LBB330_8
.LBB330_6:                              // %B18
                                        //   Parent Loop BB330_5 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldr	w11, [x10, #44]
	cmp	w11, w2
	b.eq	.LBB330_17
// %bb.7:                               // %B20
                                        //   in Loop: Header=BB330_6 Depth=2
	ldur	w10, [x10, #40]
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB330_6
.LBB330_8:                              // %B30
                                        //   in Loop: Header=BB330_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	.LBB330_17
// %bb.9:                               // %B24
                                        //   in Loop: Header=BB330_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB330_5
// %bb.10:                              // %B27
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	.LBB330_17
// %bb.11:                              // %B34
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w3, #7                          // =0x7
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	add_property_gc
	cbz	x0, .LBB330_19
// %bb.12:                              // %B38
	str	x21, [x0]
	b	.LBB330_15
.LBB330_13:                             // %B3
	mov	w9, #58                         // =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	.LBB330_17
// %bb.14:                              // %B7
	lsl	w8, w8, #1
	ldr	x9, [x22, #16]
	sub	w8, w8, #2
	str	x21, [x9, w8, sxtw #3]
.LBB330_15:                             // %B38
	ldrb	w8, [x24, #392]
	cbnz	w8, .LBB330_20
.LBB330_16:                             // %B37
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB330_17:                             // %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	JS_SetPropertyInternalImpl_GC
	tbz	w0, #31, .LBB330_16
// %bb.18:                              // %B42
	b	exception_spill_top1_asm_h
.LBB330_19:                             // %B35
	sub	x20, x20, #8
	b	exception_spill_top1_asm_h
.LBB330_20:                             // %B40
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end330:
	.size	put_field_1_asm_h, .Lfunc_end330-put_field_1_asm_h
                                        // -- End function
	.hidden	get_private_field_1_asm_h       // -- Begin function get_private_field_1_asm_h
	.globl	get_private_field_1_asm_h
	.p2align	2
	.type	get_private_field_1_asm_h,@function
get_private_field_1_asm_h:              // @get_private_field_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #64]
	bl	JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	.LBB331_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB331_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end331:
	.size	get_private_field_1_asm_h, .Lfunc_end331-get_private_field_1_asm_h
                                        // -- End function
	.hidden	put_private_field_1_asm_h       // -- Begin function put_private_field_1_asm_h
	.globl	put_private_field_1_asm_h
	.p2align	2
	.type	put_private_field_1_asm_h,@function
put_private_field_1_asm_h:              // @put_private_field_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x3, x22
	str	x8, [x23, #64]
	bl	JS_SetPrivateField_GC
	tbnz	w0, #31, .LBB332_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB332_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end332:
	.size	put_private_field_1_asm_h, .Lfunc_end332-put_private_field_1_asm_h
                                        // -- End function
	.hidden	define_private_field_1_asm_h    // -- Begin function define_private_field_1_asm_h
	.globl	define_private_field_1_asm_h
	.p2align	2
	.type	define_private_field_1_asm_h,@function
define_private_field_1_asm_h:           // @define_private_field_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	add	x8, x20, #8
	mov	x0, x24
	mov	x3, x21
	str	x21, [x20]
	mov	x2, x22
	str	x8, [x23, #64]
	bl	JS_DefinePrivateField_GC
	tbnz	w0, #31, .LBB333_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB333_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end333:
	.size	define_private_field_1_asm_h, .Lfunc_end333-define_private_field_1_asm_h
                                        // -- End function
	.hidden	get_array_el_1_asm_h            // -- Begin function get_array_el_1_asm_h
	.globl	get_array_el_1_asm_h
	.p2align	2
	.type	get_array_el_1_asm_h,@function
get_array_el_1_asm_h:                   // @get_array_el_1_asm_h
// %bb.0:                               // %B33
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB334_15
// %bb.1:                               // %B33
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x8, x9
	b.ne	.LBB334_15
// %bb.2:                               // %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	.LBB334_15
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	.LBB334_5
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB334_5:                              // %B7
	tbnz	w21, #31, .LBB334_15
// %bb.6:                               // %B9.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
	orr	w12, w21, #0x80000000
.LBB334_7:                              // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB334_8 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	and	w11, w12, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, .LBB334_10
.LBB334_8:                              // %B10
                                        //   Parent Loop BB334_7 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x10, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w12
	b.eq	.LBB334_12
// %bb.9:                               // %B17
                                        //   in Loop: Header=BB334_8 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB334_8
.LBB334_10:                             // %B24
                                        //   in Loop: Header=BB334_7 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB334_15
// %bb.11:                              // %B21
                                        //   in Loop: Header=BB334_7 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB334_7
	b	.LBB334_14
.LBB334_12:                             // %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	.LBB334_15
// %bb.13:                              // %B13
	lsl	w8, w11, #1
	ldr	x9, [x9, #16]
	sub	w8, w8, #2
	ldr	x8, [x9, w8, sxtw #3]
.LBB334_14:                             // %B14
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB334_15:                             // %B30
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB334_17
// %bb.16:                              // %B32
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB334_17:                             // %B31
	b	exception_spill_top1_asm_h
.Lfunc_end334:
	.size	get_array_el_1_asm_h, .Lfunc_end334-get_array_el_1_asm_h
                                        // -- End function
	.hidden	get_array_el2_1_asm_h           // -- Begin function get_array_el2_1_asm_h
	.globl	get_array_el2_1_asm_h
	.p2align	2
	.type	get_array_el2_1_asm_h,@function
get_array_el2_1_asm_h:                  // @get_array_el2_1_asm_h
// %bb.0:                               // %B33
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB335_15
// %bb.1:                               // %B33
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x8, x9
	b.ne	.LBB335_15
// %bb.2:                               // %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	.LBB335_15
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	.LBB335_5
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #8
	add	w8, w8, #484
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB335_5:                              // %B7
	tbnz	w21, #31, .LBB335_15
// %bb.6:                               // %B9.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
	orr	w12, w21, #0x80000000
.LBB335_7:                              // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB335_8 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	and	w11, w12, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, .LBB335_10
.LBB335_8:                              // %B10
                                        //   Parent Loop BB335_7 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x10, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w12
	b.eq	.LBB335_12
// %bb.9:                               // %B17
                                        //   in Loop: Header=BB335_8 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB335_8
.LBB335_10:                             // %B24
                                        //   in Loop: Header=BB335_7 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB335_15
// %bb.11:                              // %B21
                                        //   in Loop: Header=BB335_7 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB335_7
	b	.LBB335_14
.LBB335_12:                             // %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	.LBB335_15
// %bb.13:                              // %B13
	lsl	w8, w11, #1
	ldr	x9, [x9, #16]
	sub	w8, w8, #2
	ldr	x8, [x9, w8, sxtw #3]
.LBB335_14:                             // %B14
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB335_15:                             // %B30
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB335_17
// %bb.16:                              // %B32
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB335_17:                             // %B31
	b	exception_spill_top1_asm_h
.Lfunc_end335:
	.size	get_array_el2_1_asm_h, .Lfunc_end335-get_array_el2_1_asm_h
                                        // -- End function
	.hidden	put_array_el_1_asm_h            // -- Begin function put_array_el_1_asm_h
	.globl	put_array_el_1_asm_h
	.p2align	2
	.type	put_array_el_1_asm_h,@function
put_array_el_1_asm_h:                   // @put_array_el_1_asm_h
// %bb.0:                               // %B63
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x1, x8
	b.ne	.LBB336_16
// %bb.1:                               // %B57
	ldrsh	w8, [x1, #6]
	cmp	w8, #2
	b.ne	.LBB336_6
// %bb.2:                               // %B1
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB336_16
// %bb.3:                               // %B50
	ldr	w8, [x1, #48]
	cmp	w22, w8
	b.hs	.LBB336_7
// %bb.4:                               // %B3
	ldr	x8, [x1, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #392]
	cbnz	w8, .LBB336_23
.LBB336_5:                              // %B56
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB336_6:                              // %B60
	cmp	w8, #30
	ccmp	w8, #20, #4, lt
	mov	w8, #32768                      // =0x8000
	csel	w4, wzr, w8, gt
	b	.LBB336_17
.LBB336_7:                              // %B8
	b.ne	.LBB336_16
// %bb.8:                               // %B46
	ldr	w9, [x1, #4]
	mov	w4, #32768                      // =0x8000
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	b.ne	.LBB336_17
// %bb.9:                               // %B46
	ubfx	w9, w9, #8, #1
	cbz	w9, .LBB336_17
// %bb.10:                              // %B47
	ldr	x9, [x1, #8]
.LBB336_11:                             // %B15
                                        // =>This Inner Loop Header: Depth=1
	ldr	x10, [x9, #32]
	cbz	x10, .LBB336_19
// %bb.12:                              // %B10
                                        //   in Loop: Header=BB336_11 Depth=1
	ldrh	w11, [x10, #6]
	ldr	x9, [x10, #8]
	cmp	w11, #2
	b.ne	.LBB336_14
// %bb.13:                              // %B12
                                        //   in Loop: Header=BB336_11 Depth=1
	ldr	w10, [x10, #4]
	ubfx	w10, w10, #11, #1
	cmp	w10, #1
	b.eq	.LBB336_11
	b	.LBB336_16
.LBB336_14:                             // %B10
                                        //   in Loop: Header=BB336_11 Depth=1
	cmp	w11, #1
	b.ne	.LBB336_16
// %bb.15:                              // %B42
                                        //   in Loop: Header=BB336_11 Depth=1
	ldrb	w10, [x9, #6]
	cbz	w10, .LBB336_11
.LBB336_16:
	mov	w4, #32768                      // =0x8000
.LBB336_17:                             // %B54
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	JS_SetPropertyValue_GC
	tbz	w0, #31, .LBB336_5
// %bb.18:                              // %B55
	b	exception_spill_top1_asm_h
.LBB336_19:                             // %B33
	ldr	x9, [x1, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	.LBB336_21
// %bb.20:                              // %B33
	cmp	w9, w10
	b.hi	.LBB336_24
.LBB336_21:                             // %B30
	ldr	w10, [x1, #32]
	cmp	w9, w10
	b.hi	.LBB336_24
// %bb.22:                              // %B26
	ldr	x10, [x1, #40]
	str	w9, [x1, #48]
	str	x21, [x10, w8, sxtw #3]
	ldrb	w8, [x24, #392]
	cbz	w8, .LBB336_5
.LBB336_23:                             // %B29
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB336_24:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x2, x21
	mov	w3, #32768                      // =0x8000
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	add_fast_array_element_gc
	tbz	w0, #31, .LBB336_5
// %bb.25:                              // %B22
	b	exception_spill_top1_asm_h
.Lfunc_end336:
	.size	put_array_el_1_asm_h, .Lfunc_end336-put_array_el_1_asm_h
                                        // -- End function
	.hidden	get_super_value_1_asm_h         // -- Begin function get_super_value_1_asm_h
	.globl	get_super_value_1_asm_h
	.p2align	2
	.type	get_super_value_1_asm_h,@function
get_super_value_1_asm_h:                // @get_super_value_1_asm_h
// %bb.0:                               // %B1
	sub	sp, sp, #16
	mov	x21, x22
	str	x19, [sp, #8]                   // 8-byte Folded Spill
	add	x19, x20, #8
	ldur	x22, [x20, #-8]
	mov	x0, x24
	mov	x1, x21
	str	x21, [x20]
	str	x19, [x23, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB337_3
// %bb.1:                               // %B5
	ldur	x3, [x20, #-16]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	str	x21, [x20]
	str	x19, [x23, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB337_3
// %bb.2:                               // %B7
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	stur	x0, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB337_3:                              // %B2
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	add	sp, sp, #16
	b	exception_spill_top1_asm_h
.Lfunc_end337:
	.size	get_super_value_1_asm_h, .Lfunc_end337-get_super_value_1_asm_h
                                        // -- End function
	.hidden	put_super_value_1_asm_h         // -- Begin function put_super_value_1_asm_h
	.globl	put_super_value_1_asm_h
	.p2align	2
	.type	put_super_value_1_asm_h,@function
put_super_value_1_asm_h:                // @put_super_value_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	put_super_value_0_asm_h
.Lfunc_end338:
	.size	put_super_value_1_asm_h, .Lfunc_end338-put_super_value_1_asm_h
                                        // -- End function
	.hidden	define_field_1_asm_h            // -- Begin function define_field_1_asm_h
	.globl	define_field_1_asm_h
	.p2align	2
	.type	define_field_1_asm_h,@function
define_field_1_asm_h:                   // @define_field_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	add	x8, x20, #8
	mov	x0, x24
	mov	x3, x21
	mov	x1, x22
	mov	w4, #16391                      // =0x4007
	str	x21, [x20]
	str	x8, [x23, #64]
	bl	LEPUS_DefinePropertyValue
	tbnz	w0, #31, .LBB339_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB339_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end339:
	.size	define_field_1_asm_h, .Lfunc_end339-define_field_1_asm_h
                                        // -- End function
	.hidden	set_name_1_asm_h                // -- Begin function set_name_1_asm_h
	.globl	set_name_1_asm_h
	.p2align	2
	.type	set_name_1_asm_h,@function
set_name_1_asm_h:                       // @set_name_1_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w3, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	JS_DefineObjectName
	tbnz	w0, #31, .LBB340_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB340_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end340:
	.size	set_name_1_asm_h, .Lfunc_end340-set_name_1_asm_h
                                        // -- End function
	.hidden	set_name_computed_1_asm_h       // -- Begin function set_name_computed_1_asm_h
	.globl	set_name_computed_1_asm_h
	.p2align	2
	.type	set_name_computed_1_asm_h,@function
set_name_computed_1_asm_h:              // @set_name_computed_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x1, x21
	mov	w3, #1                          // =0x1
	mov	x2, x22
	str	x21, [x20]
	str	x8, [x23, #64]
	bl	JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, .LBB341_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB341_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end341:
	.size	set_name_computed_1_asm_h, .Lfunc_end341-set_name_computed_1_asm_h
                                        // -- End function
	.hidden	set_proto_1_asm_h               // -- Begin function set_proto_1_asm_h
	.globl	set_proto_1_asm_h
	.p2align	2
	.type	set_proto_1_asm_h,@function
set_proto_1_asm_h:                      // @set_proto_1_asm_h
// %bb.0:                               // %B6
	mov	x8, #2                          // =0x2
	mov	x21, x22
	ldur	x22, [x20, #-8]
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB342_3
// %bb.1:                               // %B6
	cmp	x21, #2
	b.eq	.LBB342_3
.LBB342_2:                              // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB342_3:                              // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	JS_SetPrototypeInternal_GC
	tbz	w0, #31, .LBB342_2
// %bb.4:                               // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end342:
	.size	set_proto_1_asm_h, .Lfunc_end342-set_proto_1_asm_h
                                        // -- End function
	.hidden	set_home_object_1_asm_h         // -- Begin function set_home_object_1_asm_h
	.globl	set_home_object_1_asm_h
	.p2align	2
	.type	set_home_object_1_asm_h,@function
set_home_object_1_asm_h:                // @set_home_object_1_asm_h
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
	str	x8, [x23, #64]
	bl	js_method_set_home_object_gc
	ldrb	w8, [x19], #1
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
.Lfunc_end343:
	.size	set_home_object_1_asm_h, .Lfunc_end343-set_home_object_1_asm_h
                                        // -- End function
	.hidden	define_array_el_1_asm_h         // -- Begin function define_array_el_1_asm_h
	.globl	define_array_el_1_asm_h
	.p2align	2
	.type	define_array_el_1_asm_h,@function
define_array_el_1_asm_h:                // @define_array_el_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	add	x8, x20, #8
	mov	x0, x24
	mov	x3, x21
	mov	w4, #16391                      // =0x4007
	str	x21, [x20]
	mov	x2, x22
	str	x8, [x23, #64]
	bl	JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, .LBB344_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB344_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end344:
	.size	define_array_el_1_asm_h, .Lfunc_end344-define_array_el_1_asm_h
                                        // -- End function
	.hidden	append_1_asm_h                  // -- Begin function append_1_asm_h
	.globl	append_1_asm_h
	.p2align	2
	.type	append_1_asm_h,@function
append_1_asm_h:                         // @append_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	append_0_asm_h
.Lfunc_end345:
	.size	append_1_asm_h, .Lfunc_end345-append_1_asm_h
                                        // -- End function
	.hidden	copy_data_properties_1_asm_h    // -- Begin function copy_data_properties_1_asm_h
	.globl	copy_data_properties_1_asm_h
	.p2align	2
	.type	copy_data_properties_1_asm_h,@function
copy_data_properties_1_asm_h:           // @copy_data_properties_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	copy_data_properties_0_asm_h
.Lfunc_end346:
	.size	copy_data_properties_1_asm_h, .Lfunc_end346-copy_data_properties_1_asm_h
                                        // -- End function
	.hidden	define_method_1_asm_h           // -- Begin function define_method_1_asm_h
	.globl	define_method_1_asm_h
	.p2align	2
	.type	define_method_1_asm_h,@function
define_method_1_asm_h:                  // @define_method_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	define_method_0_asm_h
.Lfunc_end347:
	.size	define_method_1_asm_h, .Lfunc_end347-define_method_1_asm_h
                                        // -- End function
	.hidden	define_method_computed_1_asm_h  // -- Begin function define_method_computed_1_asm_h
	.globl	define_method_computed_1_asm_h
	.p2align	2
	.type	define_method_computed_1_asm_h,@function
define_method_computed_1_asm_h:         // @define_method_computed_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	define_method_computed_0_asm_h
.Lfunc_end348:
	.size	define_method_computed_1_asm_h, .Lfunc_end348-define_method_computed_1_asm_h
                                        // -- End function
	.hidden	define_class_1_asm_h            // -- Begin function define_class_1_asm_h
	.globl	define_class_1_asm_h
	.p2align	2
	.type	define_class_1_asm_h,@function
define_class_1_asm_h:                   // @define_class_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	define_class_0_asm_h
.Lfunc_end349:
	.size	define_class_1_asm_h, .Lfunc_end349-define_class_1_asm_h
                                        // -- End function
	.hidden	get_loc_1_asm_h                 // -- Begin function get_loc_1_asm_h
	.globl	get_loc_1_asm_h
	.p2align	2
	.type	get_loc_1_asm_h,@function
get_loc_1_asm_h:                        // @get_loc_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #484
	ldr	x21, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end350:
	.size	get_loc_1_asm_h, .Lfunc_end350-get_loc_1_asm_h
                                        // -- End function
	.hidden	put_loc_1_asm_h                 // -- Begin function put_loc_1_asm_h
	.globl	put_loc_1_asm_h
	.p2align	2
	.type	put_loc_1_asm_h,@function
put_loc_1_asm_h:                        // @put_loc_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end351:
	.size	put_loc_1_asm_h, .Lfunc_end351-put_loc_1_asm_h
                                        // -- End function
	.hidden	set_loc_1_asm_h                 // -- Begin function set_loc_1_asm_h
	.globl	set_loc_1_asm_h
	.p2align	2
	.type	set_loc_1_asm_h,@function
set_loc_1_asm_h:                        // @set_loc_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end352:
	.size	set_loc_1_asm_h, .Lfunc_end352-set_loc_1_asm_h
                                        // -- End function
	.hidden	get_arg_1_asm_h                 // -- Begin function get_arg_1_asm_h
	.globl	get_arg_1_asm_h
	.p2align	2
	.type	get_arg_1_asm_h,@function
get_arg_1_asm_h:                        // @get_arg_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #484
	ldr	x21, [x28, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end353:
	.size	get_arg_1_asm_h, .Lfunc_end353-get_arg_1_asm_h
                                        // -- End function
	.hidden	put_arg_1_asm_h                 // -- Begin function put_arg_1_asm_h
	.globl	put_arg_1_asm_h
	.p2align	2
	.type	put_arg_1_asm_h,@function
put_arg_1_asm_h:                        // @put_arg_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end354:
	.size	put_arg_1_asm_h, .Lfunc_end354-put_arg_1_asm_h
                                        // -- End function
	.hidden	set_arg_1_asm_h                 // -- Begin function set_arg_1_asm_h
	.globl	set_arg_1_asm_h
	.p2align	2
	.type	set_arg_1_asm_h,@function
set_arg_1_asm_h:                        // @set_arg_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end355:
	.size	set_arg_1_asm_h, .Lfunc_end355-set_arg_1_asm_h
                                        // -- End function
	.hidden	get_var_ref_1_asm_h             // -- Begin function get_var_ref_1_asm_h
	.globl	get_var_ref_1_asm_h
	.p2align	2
	.type	get_var_ref_1_asm_h,@function
get_var_ref_1_asm_h:                    // @get_var_ref_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x8, [x26, x8, lsl #3]
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8, #32]
	ldr	x21, [x8]
	br	x1
.Lfunc_end356:
	.size	get_var_ref_1_asm_h, .Lfunc_end356-get_var_ref_1_asm_h
                                        // -- End function
	.hidden	put_var_ref_1_asm_h             // -- Begin function put_var_ref_1_asm_h
	.globl	put_var_ref_1_asm_h
	.p2align	2
	.type	put_var_ref_1_asm_h,@function
put_var_ref_1_asm_h:                    // @put_var_ref_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end357:
	.size	put_var_ref_1_asm_h, .Lfunc_end357-put_var_ref_1_asm_h
                                        // -- End function
	.hidden	set_var_ref_1_asm_h             // -- Begin function set_var_ref_1_asm_h
	.globl	set_var_ref_1_asm_h
	.p2align	2
	.type	set_var_ref_1_asm_h,@function
set_var_ref_1_asm_h:                    // @set_var_ref_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end358:
	.size	set_var_ref_1_asm_h, .Lfunc_end358-set_var_ref_1_asm_h
                                        // -- End function
	.hidden	set_loc_uninitialized_1_asm_h   // -- Begin function set_loc_uninitialized_1_asm_h
	.globl	set_loc_uninitialized_1_asm_h
	.p2align	2
	.type	set_loc_uninitialized_1_asm_h,@function
set_loc_uninitialized_1_asm_h:          // @set_loc_uninitialized_1_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	mov	w9, #34                         // =0x22
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end359:
	.size	set_loc_uninitialized_1_asm_h, .Lfunc_end359-set_loc_uninitialized_1_asm_h
                                        // -- End function
	.hidden	get_loc_check_1_asm_h           // -- Begin function get_loc_check_1_asm_h
	.globl	get_loc_check_1_asm_h
	.p2align	2
	.type	get_loc_check_1_asm_h,@function
get_loc_check_1_asm_h:                  // @get_loc_check_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	.LBB360_2
// %bb.1:                               // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB360_2:                              // %B3
	str	x22, [x20], #8
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end360:
	.size	get_loc_check_1_asm_h, .Lfunc_end360-get_loc_check_1_asm_h
                                        // -- End function
	.hidden	put_loc_check_1_asm_h           // -- Begin function put_loc_check_1_asm_h
	.globl	put_loc_check_1_asm_h
	.p2align	2
	.type	put_loc_check_1_asm_h,@function
put_loc_check_1_asm_h:                  // @put_loc_check_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	.LBB361_2
// %bb.1:                               // %B4
	str	x22, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB361_2:                              // %B3
	str	x22, [x20], #8
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end361:
	.size	put_loc_check_1_asm_h, .Lfunc_end361-put_loc_check_1_asm_h
                                        // -- End function
	.hidden	put_loc_check_init_1_asm_h      // -- Begin function put_loc_check_init_1_asm_h
	.globl	put_loc_check_init_1_asm_h
	.p2align	2
	.type	put_loc_check_init_1_asm_h,@function
put_loc_check_init_1_asm_h:             // @put_loc_check_init_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	.LBB362_2
// %bb.1:                               // %B4
	str	x22, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB362_2:                              // %B3
	str	x22, [x20], #8
	b	ThrowThisReferenceError_asm_h
.Lfunc_end362:
	.size	put_loc_check_init_1_asm_h, .Lfunc_end362-put_loc_check_init_1_asm_h
                                        // -- End function
	.hidden	get_var_ref_check_1_asm_h       // -- Begin function get_var_ref_check_1_asm_h
	.globl	get_var_ref_check_1_asm_h
	.p2align	2
	.type	get_var_ref_check_1_asm_h,@function
get_var_ref_check_1_asm_h:              // @get_var_ref_check_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB363_2
// %bb.1:                               // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB363_2:                              // %B3
	str	x22, [x20], #8
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end363:
	.size	get_var_ref_check_1_asm_h, .Lfunc_end363-get_var_ref_check_1_asm_h
                                        // -- End function
	.hidden	put_var_ref_check_1_asm_h       // -- Begin function put_var_ref_check_1_asm_h
	.globl	put_var_ref_check_1_asm_h
	.p2align	2
	.type	put_var_ref_check_1_asm_h,@function
put_var_ref_check_1_asm_h:              // @put_var_ref_check_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	.LBB364_2
// %bb.1:                               // %B4
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB364_2:                              // %B3
	str	x22, [x20], #8
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end364:
	.size	put_var_ref_check_1_asm_h, .Lfunc_end364-put_var_ref_check_1_asm_h
                                        // -- End function
	.hidden	put_var_ref_check_init_1_asm_h  // -- Begin function put_var_ref_check_init_1_asm_h
	.globl	put_var_ref_check_init_1_asm_h
	.p2align	2
	.type	put_var_ref_check_init_1_asm_h,@function
put_var_ref_check_init_1_asm_h:         // @put_var_ref_check_init_1_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	.LBB365_2
// %bb.1:                               // %B4
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB365_2:                              // %B3
	str	x22, [x20], #8
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end365:
	.size	put_var_ref_check_init_1_asm_h, .Lfunc_end365-put_var_ref_check_init_1_asm_h
                                        // -- End function
	.hidden	close_loc_1_asm_h               // -- Begin function close_loc_1_asm_h
	.globl	close_loc_1_asm_h
	.p2align	2
	.type	close_loc_1_asm_h,@function
close_loc_1_asm_h:                      // @close_loc_1_asm_h
// %bb.0:                               // %B0
	ldrh	w2, [x19]
	mov	x0, x24
	mov	x1, x23
	bl	close_lexical_var
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end366:
	.size	close_loc_1_asm_h, .Lfunc_end366-close_loc_1_asm_h
                                        // -- End function
	.hidden	if_false_1_asm_h                // -- Begin function if_false_1_asm_h
	.globl	if_false_1_asm_h
	.p2align	2
	.type	if_false_1_asm_h,@function
if_false_1_asm_h:                       // @if_false_1_asm_h
// %bb.0:                               // %B23
	cmp	x22, #5
	b.le	.LBB367_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB367_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB367_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB367_6
	b	.LBB367_7
.LBB367_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB367_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB367_7
.LBB367_6:                              // %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB367_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB367_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB367_10
.LBB367_9:                              // %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB367_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB367_13
// %bb.11:                              // %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB367_6
	b.vs	.LBB367_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB367_9
	b	.LBB367_6
.LBB367_13:                             // %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	SlowToBoolean_asm_h
.Lfunc_end367:
	.size	if_false_1_asm_h, .Lfunc_end367-if_false_1_asm_h
                                        // -- End function
	.hidden	if_true_1_asm_h                 // -- Begin function if_true_1_asm_h
	.globl	if_true_1_asm_h
	.p2align	2
	.type	if_true_1_asm_h,@function
if_true_1_asm_h:                        // @if_true_1_asm_h
// %bb.0:                               // %B23
	cmp	x22, #5
	b.le	.LBB368_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB368_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB368_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB368_6
	b	.LBB368_7
.LBB368_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB368_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB368_7
.LBB368_6:                              // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB368_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB368_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB368_10
.LBB368_9:                              // %B19
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB368_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB368_13
// %bb.11:                              // %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB368_6
	b.vs	.LBB368_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB368_9
	b	.LBB368_6
.LBB368_13:                             // %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	SlowToBoolean_asm_h
.Lfunc_end368:
	.size	if_true_1_asm_h, .Lfunc_end368-if_true_1_asm_h
                                        // -- End function
	.hidden	goto_1_asm_h                    // -- Begin function goto_1_asm_h
	.globl	goto_1_asm_h
	.p2align	2
	.type	goto_1_asm_h,@function
goto_1_asm_h:                           // @goto_1_asm_h
// %bb.0:                               // %B0
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end369:
	.size	goto_1_asm_h, .Lfunc_end369-goto_1_asm_h
                                        // -- End function
	.hidden	catch_1_asm_h                   // -- Begin function catch_1_asm_h
	.globl	catch_1_asm_h
	.p2align	2
	.type	catch_1_asm_h,@function
catch_1_asm_h:                          // @catch_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #4]
	ldr	w10, [x19]
	ldr	x8, [x8, #32]
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	mov	w9, #66                         // =0x42
	ldr	x8, [x8, #8]
	sub	x8, x19, x8
	add	x19, x19, #5
	add	x8, x8, x10
	orr	x21, x9, x8, lsl #16
	br	x1
.Lfunc_end370:
	.size	catch_1_asm_h, .Lfunc_end370-catch_1_asm_h
                                        // -- End function
	.hidden	gosub_1_asm_h                   // -- Begin function gosub_1_asm_h
	.globl	gosub_1_asm_h
	.p2align	2
	.type	gosub_1_asm_h,@function
gosub_1_asm_h:                          // @gosub_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #8]
	ldrsw	x9, [x19]
	ldr	x10, [x8, #32]
	add	x8, x19, x9
	ldrb	w9, [x8], #1
	ldr	w10, [x10, #8]
	add	w9, w9, #484
	sub	w10, w19, w10
	ldr	x1, [x25, w9, uxtw #3]
	mov	x19, x8
	add	w9, w10, #4
	orr	x21, x9, #0xfffe000000000000
	br	x1
.Lfunc_end371:
	.size	gosub_1_asm_h, .Lfunc_end371-gosub_1_asm_h
                                        // -- End function
	.hidden	ret_1_asm_h                     // -- Begin function ret_1_asm_h
	.globl	ret_1_asm_h
	.p2align	2
	.type	ret_1_asm_h,@function
ret_1_asm_h:                            // @ret_1_asm_h
// %bb.0:                               // %B6
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB372_3
// %bb.1:                               // %B1
	ldr	x8, [x23, #8]
	ldr	x8, [x8, #32]
	ldr	w9, [x8, #16]
	cmp	w22, w9
	b.ge	.LBB372_3
// %bb.2:                               // %B5
	ldr	x8, [x8, #8]
	add	x19, x8, w22, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB372_3:                              // %B3
	mov	x8, x20
	adrp	x1, .L__unnamed_14
	add	x1, x1, :lo12:.L__unnamed_14
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	LEPUS_ThrowInternalError
	b	exception_spill_top0_asm_h
.Lfunc_end372:
	.size	ret_1_asm_h, .Lfunc_end372-ret_1_asm_h
                                        // -- End function
	.hidden	to_object_1_asm_h               // -- Begin function to_object_1_asm_h
	.globl	to_object_1_asm_h
	.p2align	2
	.type	to_object_1_asm_h,@function
to_object_1_asm_h:                      // @to_object_1_asm_h
// %bb.0:                               // %B6
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB373_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB373_2:                              // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB373_4
// %bb.3:                               // %B3
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB373_4:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end373:
	.size	to_object_1_asm_h, .Lfunc_end373-to_object_1_asm_h
                                        // -- End function
	.hidden	to_propkey_1_asm_h              // -- Begin function to_propkey_1_asm_h
	.globl	to_propkey_1_asm_h
	.p2align	2
	.type	to_propkey_1_asm_h,@function
to_propkey_1_asm_h:                     // @to_propkey_1_asm_h
// %bb.0:                               // %B15
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	.LBB374_4
// %bb.1:                               // %B15
	mov	x9, #1                          // =0x1
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	.LBB374_4
// %bb.2:                               // %B15
	cmp	x8, x9
	b.eq	.LBB374_4
// %bb.3:                               // %B15
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB374_5
.LBB374_4:                              // %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB374_5:                              // %B12
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB374_7
// %bb.6:                               // %B14
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB374_7:                              // %B13
	b	exception_spill_top0_asm_h
.Lfunc_end374:
	.size	to_propkey_1_asm_h, .Lfunc_end374-to_propkey_1_asm_h
                                        // -- End function
	.hidden	to_propkey2_1_asm_h             // -- Begin function to_propkey2_1_asm_h
	.globl	to_propkey2_1_asm_h
	.p2align	2
	.type	to_propkey2_1_asm_h,@function
to_propkey2_1_asm_h:                    // @to_propkey2_1_asm_h
// %bb.0:                               // %B18
	mov	x21, x22
	ldur	x22, [x20, #-8]
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	.LBB375_3
// %bb.1:                               // %B19
	mov	x8, x20
	adrp	x1, .L__unnamed_15
	add	x1, x1, :lo12:.L__unnamed_15
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	LEPUS_ThrowTypeError
.LBB375_2:                              // %B16
	b	exception_spill_top1_asm_h
.LBB375_3:                              // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB375_7
// %bb.4:                               // %B2
	mov	x9, #1                          // =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	.LBB375_7
// %bb.5:                               // %B2
	cmp	x8, x9
	b.eq	.LBB375_7
// %bb.6:                               // %B2
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB375_8
.LBB375_7:                              // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB375_8:                              // %B15
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB375_2
// %bb.9:                               // %B17
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end375:
	.size	to_propkey2_1_asm_h, .Lfunc_end375-to_propkey2_1_asm_h
                                        // -- End function
	.hidden	with_get_var_1_asm_h            // -- Begin function with_get_var_1_asm_h
	.globl	with_get_var_1_asm_h
	.p2align	2
	.type	with_get_var_1_asm_h,@function
with_get_var_1_asm_h:                   // @with_get_var_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	with_get_var_0_asm_h
.Lfunc_end376:
	.size	with_get_var_1_asm_h, .Lfunc_end376-with_get_var_1_asm_h
                                        // -- End function
	.hidden	with_put_var_1_asm_h            // -- Begin function with_put_var_1_asm_h
	.globl	with_put_var_1_asm_h
	.p2align	2
	.type	with_put_var_1_asm_h,@function
with_put_var_1_asm_h:                   // @with_put_var_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	with_put_var_0_asm_h
.Lfunc_end377:
	.size	with_put_var_1_asm_h, .Lfunc_end377-with_put_var_1_asm_h
                                        // -- End function
	.hidden	with_delete_var_1_asm_h         // -- Begin function with_delete_var_1_asm_h
	.globl	with_delete_var_1_asm_h
	.p2align	2
	.type	with_delete_var_1_asm_h,@function
with_delete_var_1_asm_h:                // @with_delete_var_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	with_delete_var_0_asm_h
.Lfunc_end378:
	.size	with_delete_var_1_asm_h, .Lfunc_end378-with_delete_var_1_asm_h
                                        // -- End function
	.hidden	with_make_ref_1_asm_h           // -- Begin function with_make_ref_1_asm_h
	.globl	with_make_ref_1_asm_h
	.p2align	2
	.type	with_make_ref_1_asm_h,@function
with_make_ref_1_asm_h:                  // @with_make_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	with_make_ref_0_asm_h
.Lfunc_end379:
	.size	with_make_ref_1_asm_h, .Lfunc_end379-with_make_ref_1_asm_h
                                        // -- End function
	.hidden	with_get_ref_1_asm_h            // -- Begin function with_get_ref_1_asm_h
	.globl	with_get_ref_1_asm_h
	.p2align	2
	.type	with_get_ref_1_asm_h,@function
with_get_ref_1_asm_h:                   // @with_get_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	with_get_ref_0_asm_h
.Lfunc_end380:
	.size	with_get_ref_1_asm_h, .Lfunc_end380-with_get_ref_1_asm_h
                                        // -- End function
	.hidden	with_get_ref_undef_1_asm_h      // -- Begin function with_get_ref_undef_1_asm_h
	.globl	with_get_ref_undef_1_asm_h
	.p2align	2
	.type	with_get_ref_undef_1_asm_h,@function
with_get_ref_undef_1_asm_h:             // @with_get_ref_undef_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	with_get_ref_undef_0_asm_h
.Lfunc_end381:
	.size	with_get_ref_undef_1_asm_h, .Lfunc_end381-with_get_ref_undef_1_asm_h
                                        // -- End function
	.hidden	make_loc_ref_1_asm_h            // -- Begin function make_loc_ref_1_asm_h
	.globl	make_loc_ref_1_asm_h
	.p2align	2
	.type	make_loc_ref_1_asm_h,@function
make_loc_ref_1_asm_h:                   // @make_loc_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	make_loc_ref_0_asm_h
.Lfunc_end382:
	.size	make_loc_ref_1_asm_h, .Lfunc_end382-make_loc_ref_1_asm_h
                                        // -- End function
	.hidden	make_arg_ref_1_asm_h            // -- Begin function make_arg_ref_1_asm_h
	.globl	make_arg_ref_1_asm_h
	.p2align	2
	.type	make_arg_ref_1_asm_h,@function
make_arg_ref_1_asm_h:                   // @make_arg_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	make_arg_ref_0_asm_h
.Lfunc_end383:
	.size	make_arg_ref_1_asm_h, .Lfunc_end383-make_arg_ref_1_asm_h
                                        // -- End function
	.hidden	make_var_ref_ref_1_asm_h        // -- Begin function make_var_ref_ref_1_asm_h
	.globl	make_var_ref_ref_1_asm_h
	.p2align	2
	.type	make_var_ref_ref_1_asm_h,@function
make_var_ref_ref_1_asm_h:               // @make_var_ref_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	make_var_ref_ref_0_asm_h
.Lfunc_end384:
	.size	make_var_ref_ref_1_asm_h, .Lfunc_end384-make_var_ref_ref_1_asm_h
                                        // -- End function
	.hidden	make_var_ref_1_asm_h            // -- Begin function make_var_ref_1_asm_h
	.globl	make_var_ref_1_asm_h
	.p2align	2
	.type	make_var_ref_1_asm_h,@function
make_var_ref_1_asm_h:                   // @make_var_ref_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	make_var_ref_0_asm_h
.Lfunc_end385:
	.size	make_var_ref_1_asm_h, .Lfunc_end385-make_var_ref_1_asm_h
                                        // -- End function
	.hidden	for_in_start_1_asm_h            // -- Begin function for_in_start_1_asm_h
	.globl	for_in_start_1_asm_h
	.p2align	2
	.type	for_in_start_1_asm_h,@function
for_in_start_1_asm_h:                   // @for_in_start_1_asm_h
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	.LBB386_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB386_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end386:
	.size	for_in_start_1_asm_h, .Lfunc_end386-for_in_start_1_asm_h
                                        // -- End function
	.hidden	for_of_start_1_asm_h            // -- Begin function for_of_start_1_asm_h
	.globl	for_of_start_1_asm_h
	.p2align	2
	.type	for_of_start_1_asm_h,@function
for_of_start_1_asm_h:                   // @for_of_start_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	for_of_start_0_asm_h
.Lfunc_end387:
	.size	for_of_start_1_asm_h, .Lfunc_end387-for_of_start_1_asm_h
                                        // -- End function
	.hidden	for_await_of_start_1_asm_h      // -- Begin function for_await_of_start_1_asm_h
	.globl	for_await_of_start_1_asm_h
	.p2align	2
	.type	for_await_of_start_1_asm_h,@function
for_await_of_start_1_asm_h:             // @for_await_of_start_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	for_await_of_start_0_asm_h
.Lfunc_end388:
	.size	for_await_of_start_1_asm_h, .Lfunc_end388-for_await_of_start_1_asm_h
                                        // -- End function
	.hidden	for_in_next_1_asm_h             // -- Begin function for_in_next_1_asm_h
	.globl	for_in_next_1_asm_h
	.p2align	2
	.type	for_in_next_1_asm_h,@function
for_in_next_1_asm_h:                    // @for_in_next_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	for_in_next_0_asm_h
.Lfunc_end389:
	.size	for_in_next_1_asm_h, .Lfunc_end389-for_in_next_1_asm_h
                                        // -- End function
	.hidden	for_of_next_1_asm_h             // -- Begin function for_of_next_1_asm_h
	.globl	for_of_next_1_asm_h
	.p2align	2
	.type	for_of_next_1_asm_h,@function
for_of_next_1_asm_h:                    // @for_of_next_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	for_of_next_0_asm_h
.Lfunc_end390:
	.size	for_of_next_1_asm_h, .Lfunc_end390-for_of_next_1_asm_h
                                        // -- End function
	.hidden	for_await_of_next_1_asm_h       // -- Begin function for_await_of_next_1_asm_h
	.globl	for_await_of_next_1_asm_h
	.p2align	2
	.type	for_await_of_next_1_asm_h,@function
for_await_of_next_1_asm_h:              // @for_await_of_next_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	for_await_of_next_0_asm_h
.Lfunc_end391:
	.size	for_await_of_next_1_asm_h, .Lfunc_end391-for_await_of_next_1_asm_h
                                        // -- End function
	.hidden	iterator_get_value_done_1_asm_h // -- Begin function iterator_get_value_done_1_asm_h
	.globl	iterator_get_value_done_1_asm_h
	.p2align	2
	.type	iterator_get_value_done_1_asm_h,@function
iterator_get_value_done_1_asm_h:        // @iterator_get_value_done_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	iterator_get_value_done_0_asm_h
.Lfunc_end392:
	.size	iterator_get_value_done_1_asm_h, .Lfunc_end392-iterator_get_value_done_1_asm_h
                                        // -- End function
	.hidden	iterator_close_1_asm_h          // -- Begin function iterator_close_1_asm_h
	.globl	iterator_close_1_asm_h
	.p2align	2
	.type	iterator_close_1_asm_h,@function
iterator_close_1_asm_h:                 // @iterator_close_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	iterator_close_0_asm_h
.Lfunc_end393:
	.size	iterator_close_1_asm_h, .Lfunc_end393-iterator_close_1_asm_h
                                        // -- End function
	.hidden	iterator_close_return_1_asm_h   // -- Begin function iterator_close_return_1_asm_h
	.globl	iterator_close_return_1_asm_h
	.p2align	2
	.type	iterator_close_return_1_asm_h,@function
iterator_close_return_1_asm_h:          // @iterator_close_return_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	iterator_close_return_0_asm_h
.Lfunc_end394:
	.size	iterator_close_return_1_asm_h, .Lfunc_end394-iterator_close_return_1_asm_h
                                        // -- End function
	.hidden	async_iterator_close_1_asm_h    // -- Begin function async_iterator_close_1_asm_h
	.globl	async_iterator_close_1_asm_h
	.p2align	2
	.type	async_iterator_close_1_asm_h,@function
async_iterator_close_1_asm_h:           // @async_iterator_close_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	async_iterator_close_0_asm_h
.Lfunc_end395:
	.size	async_iterator_close_1_asm_h, .Lfunc_end395-async_iterator_close_1_asm_h
                                        // -- End function
	.hidden	async_iterator_next_1_asm_h     // -- Begin function async_iterator_next_1_asm_h
	.globl	async_iterator_next_1_asm_h
	.p2align	2
	.type	async_iterator_next_1_asm_h,@function
async_iterator_next_1_asm_h:            // @async_iterator_next_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	async_iterator_next_0_asm_h
.Lfunc_end396:
	.size	async_iterator_next_1_asm_h, .Lfunc_end396-async_iterator_next_1_asm_h
                                        // -- End function
	.hidden	async_iterator_get_1_asm_h      // -- Begin function async_iterator_get_1_asm_h
	.globl	async_iterator_get_1_asm_h
	.p2align	2
	.type	async_iterator_get_1_asm_h,@function
async_iterator_get_1_asm_h:             // @async_iterator_get_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	async_iterator_get_0_asm_h
.Lfunc_end397:
	.size	async_iterator_get_1_asm_h, .Lfunc_end397-async_iterator_get_1_asm_h
                                        // -- End function
	.hidden	initial_yield_1_asm_h           // -- Begin function initial_yield_1_asm_h
	.globl	initial_yield_1_asm_h
	.p2align	2
	.type	initial_yield_1_asm_h,@function
initial_yield_1_asm_h:                  // @initial_yield_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	initial_yield_0_asm_h
.Lfunc_end398:
	.size	initial_yield_1_asm_h, .Lfunc_end398-initial_yield_1_asm_h
                                        // -- End function
	.hidden	yield_1_asm_h                   // -- Begin function yield_1_asm_h
	.globl	yield_1_asm_h
	.p2align	2
	.type	yield_1_asm_h,@function
yield_1_asm_h:                          // @yield_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	yield_0_asm_h
.Lfunc_end399:
	.size	yield_1_asm_h, .Lfunc_end399-yield_1_asm_h
                                        // -- End function
	.hidden	yield_star_1_asm_h              // -- Begin function yield_star_1_asm_h
	.globl	yield_star_1_asm_h
	.p2align	2
	.type	yield_star_1_asm_h,@function
yield_star_1_asm_h:                     // @yield_star_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	yield_star_0_asm_h
.Lfunc_end400:
	.size	yield_star_1_asm_h, .Lfunc_end400-yield_star_1_asm_h
                                        // -- End function
	.hidden	async_yield_star_1_asm_h        // -- Begin function async_yield_star_1_asm_h
	.globl	async_yield_star_1_asm_h
	.p2align	2
	.type	async_yield_star_1_asm_h,@function
async_yield_star_1_asm_h:               // @async_yield_star_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	async_yield_star_0_asm_h
.Lfunc_end401:
	.size	async_yield_star_1_asm_h, .Lfunc_end401-async_yield_star_1_asm_h
                                        // -- End function
	.hidden	await_1_asm_h                   // -- Begin function await_1_asm_h
	.globl	await_1_asm_h
	.p2align	2
	.type	await_1_asm_h,@function
await_1_asm_h:                          // @await_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	await_0_asm_h
.Lfunc_end402:
	.size	await_1_asm_h, .Lfunc_end402-await_1_asm_h
                                        // -- End function
	.hidden	neg_1_asm_h                     // -- Begin function neg_1_asm_h
	.globl	neg_1_asm_h
	.p2align	2
	.type	neg_1_asm_h,@function
neg_1_asm_h:                            // @neg_1_asm_h
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB403_3
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB403_6
// %bb.2:                               // %B13
	orr	w8, w22, #0x80000000
	mov	w9, #-2147483648                // =0x80000000
	cmp	w8, w9
	b.ne	.LBB403_5
.LBB403_3:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        // =0x8c
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB403_8
// %bb.4:                               // %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB403_5:                              // %B15
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB403_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB403_3
// %bb.7:                               // %B7
	movi	d0, #0000000000000000
	add	x8, x22, x8
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	fsub	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
.LBB403_8:                              // %B17
	b	exception_spill_top0_asm_h
.Lfunc_end403:
	.size	neg_1_asm_h, .Lfunc_end403-neg_1_asm_h
                                        // -- End function
	.hidden	plus_1_asm_h                    // -- Begin function plus_1_asm_h
	.globl	plus_1_asm_h
	.p2align	2
	.type	plus_1_asm_h,@function
plus_1_asm_h:                           // @plus_1_asm_h
// %bb.0:                               // %B13
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB404_4
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB404_3
.LBB404_2:                              // %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB404_3:                              // %B3
	tst	x22, #0xfffe000000000000
	b.ne	.LBB404_2
.LBB404_4:                              // %B10
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        // =0x8d
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB404_6
// %bb.5:                               // %B12
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB404_6:                              // %B11
	b	exception_spill_top0_asm_h
.Lfunc_end404:
	.size	plus_1_asm_h, .Lfunc_end404-plus_1_asm_h
                                        // -- End function
	.hidden	dec_1_asm_h                     // -- Begin function dec_1_asm_h
	.globl	dec_1_asm_h
	.p2align	2
	.type	dec_1_asm_h,@function
dec_1_asm_h:                            // @dec_1_asm_h
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB405_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB405_4
// %bb.2:                               // %B13
	subs	w8, w22, #1
	b.vs	.LBB405_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB405_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB405_6
// %bb.5:                               // %B7
	add	x8, x22, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
.LBB405_6:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        // =0x8e
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB405_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB405_8:                              // %B17
	b	exception_spill_top0_asm_h
.Lfunc_end405:
	.size	dec_1_asm_h, .Lfunc_end405-dec_1_asm_h
                                        // -- End function
	.hidden	inc_1_asm_h                     // -- Begin function inc_1_asm_h
	.globl	inc_1_asm_h
	.p2align	2
	.type	inc_1_asm_h,@function
inc_1_asm_h:                            // @inc_1_asm_h
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB406_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB406_4
// %bb.2:                               // %B13
	adds	w8, w22, #1
	b.vs	.LBB406_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB406_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB406_6
// %bb.5:                               // %B7
	add	x8, x22, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
.LBB406_6:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        // =0x8f
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB406_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB406_8:                              // %B17
	b	exception_spill_top0_asm_h
.Lfunc_end406:
	.size	inc_1_asm_h, .Lfunc_end406-inc_1_asm_h
                                        // -- End function
	.hidden	post_dec_1_asm_h                // -- Begin function post_dec_1_asm_h
	.globl	post_dec_1_asm_h
	.p2align	2
	.type	post_dec_1_asm_h,@function
post_dec_1_asm_h:                       // @post_dec_1_asm_h
// %bb.0:                               // %B16
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB407_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB407_4
// %bb.2:                               // %B13
	subs	w8, w22, #1
	b.vs	.LBB407_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB407_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB407_6
// %bb.5:                               // %B8
	add	x8, x22, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
.LBB407_6:                              // %B5
	str	x22, [x20], #8
	mov	w0, #144                        // =0x90
	b	SlowJSPostInc_asm_h
.Lfunc_end407:
	.size	post_dec_1_asm_h, .Lfunc_end407-post_dec_1_asm_h
                                        // -- End function
	.hidden	post_inc_1_asm_h                // -- Begin function post_inc_1_asm_h
	.globl	post_inc_1_asm_h
	.p2align	2
	.type	post_inc_1_asm_h,@function
post_inc_1_asm_h:                       // @post_inc_1_asm_h
// %bb.0:                               // %B16
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB408_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB408_4
// %bb.2:                               // %B13
	adds	w8, w22, #1
	b.vs	.LBB408_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB408_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB408_6
// %bb.5:                               // %B8
	add	x8, x22, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
.LBB408_6:                              // %B5
	str	x22, [x20], #8
	mov	w0, #145                        // =0x91
	b	SlowJSPostInc_asm_h
.Lfunc_end408:
	.size	post_inc_1_asm_h, .Lfunc_end408-post_inc_1_asm_h
                                        // -- End function
	.hidden	dec_loc_1_asm_h                 // -- Begin function dec_loc_1_asm_h
	.globl	dec_loc_1_asm_h
	.p2align	2
	.type	dec_loc_1_asm_h,@function
dec_loc_1_asm_h:                        // @dec_loc_1_asm_h
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	.LBB409_6
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB409_4
// %bb.2:                               // %B13
	subs	w9, w1, #1
	b.vs	.LBB409_6
// %bb.3:                               // %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB409_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB409_6
// %bb.5:                               // %B8
	add	x9, x1, x9
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221120237041090560       // =0x7ff8000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB409_6:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	w2, #142                        // =0x8e
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB409_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB409_8:                              // %B17
	b	exception_spill_top0_asm_h
.Lfunc_end409:
	.size	dec_loc_1_asm_h, .Lfunc_end409-dec_loc_1_asm_h
                                        // -- End function
	.hidden	inc_loc_1_asm_h                 // -- Begin function inc_loc_1_asm_h
	.globl	inc_loc_1_asm_h
	.p2align	2
	.type	inc_loc_1_asm_h,@function
inc_loc_1_asm_h:                        // @inc_loc_1_asm_h
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	.LBB410_6
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB410_4
// %bb.2:                               // %B13
	adds	w9, w1, #1
	b.vs	.LBB410_6
// %bb.3:                               // %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB410_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB410_6
// %bb.5:                               // %B8
	add	x9, x1, x9
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221120237041090560       // =0x7ff8000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB410_6:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	w2, #143                        // =0x8f
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB410_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB410_8:                              // %B17
	b	exception_spill_top0_asm_h
.Lfunc_end410:
	.size	inc_loc_1_asm_h, .Lfunc_end410-inc_loc_1_asm_h
                                        // -- End function
	.hidden	add_loc_1_asm_h                 // -- Begin function add_loc_1_asm_h
	.globl	add_loc_1_asm_h
	.p2align	2
	.type	add_loc_1_asm_h,@function
add_loc_1_asm_h:                        // @add_loc_1_asm_h
// %bb.0:                               // %B45
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	ccmp	x22, x9, #2, ls
	b.hi	.LBB411_14
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB411_5
// %bb.2:                               // %B26
	cmp	x22, x9
	b.lo	.LBB411_8
// %bb.3:                               // %B36
	adds	w9, w1, w22
	b.vs	.LBB411_14
// %bb.4:                               // %B38
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB411_5:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB411_14
// %bb.6:                               // %B11
	cmp	x22, x9
	b.lo	.LBB411_12
// %bb.7:                               // %B21
	scvtf	d0, w22
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	.LBB411_11
.LBB411_8:                              // %B28
	tst	x22, #0xfffe000000000000
	b.eq	.LBB411_14
// %bb.9:                               // %B31
	scvtf	d0, w1
	add	x9, x22, x9
.LBB411_10:                             // %B31
	fmov	d1, x9
	fadd	d0, d0, d1
.LBB411_11:                             // %B31
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	x9, x9, x10
	mov	x10, #9221120237041090560       // =0x7ff8000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB411_12:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB411_14
// %bb.13:                              // %B16
	add	x10, x1, x9
	add	x9, x22, x9
	fmov	d0, x10
	b	.LBB411_10
.LBB411_14:                             // %B7
	mov	x9, #2                          // =0x2
	and	x8, x1, #0xffff000000000003
	and	x10, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	mov	x11, x20
	mov	x2, x22
	cmp	x8, x9
	str	x22, [x11], #8
	ccmp	x10, x9, #0, eq
	str	x11, [x23, #64]
	mov	x0, x24
	b.eq	.LBB411_16
// %bb.15:                              // %B42
	bl	prim_js_add_slow_gc
	b	.LBB411_17
.LBB411_16:                             // %B39
	bl	JS_ConcatString_GC
.LBB411_17:                             // %B42
	cmp	x0, #130
	b.eq	.LBB411_19
// %bb.18:                              // %B44
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB411_19:                             // %B43
	b	exception_spill_top0_asm_h
.Lfunc_end411:
	.size	add_loc_1_asm_h, .Lfunc_end411-add_loc_1_asm_h
                                        // -- End function
	.hidden	not_1_asm_h                     // -- Begin function not_1_asm_h
	.globl	not_1_asm_h
	.p2align	2
	.type	not_1_asm_h,@function
not_1_asm_h:                            // @not_1_asm_h
// %bb.0:                               // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB412_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB412_2:                              // %B4
	str	x22, [x20], #8
	mov	x0, x22
	b	SlowJSNot_asm_h
.Lfunc_end412:
	.size	not_1_asm_h, .Lfunc_end412-not_1_asm_h
                                        // -- End function
	.hidden	lnot_1_asm_h                    // -- Begin function lnot_1_asm_h
	.globl	lnot_1_asm_h
	.p2align	2
	.type	lnot_1_asm_h,@function
lnot_1_asm_h:                           // @lnot_1_asm_h
// %bb.0:                               // %B14
	cmp	x22, #5
	b.le	.LBB413_4
// %bb.1:                               // %B14
	cmp	x22, #6
	b.eq	.LBB413_6
// %bb.2:                               // %B14
	cmp	x22, #7
	b.eq	.LBB413_8
// %bb.3:                               // %B14
	cmp	x22, #18
	b.eq	.LBB413_6
	b	.LBB413_7
.LBB413_4:                              // %B14
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB413_6
// %bb.5:                               // %B14
	cmp	x22, #2
	b.ne	.LBB413_7
.LBB413_6:                              // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB413_7:                              // %B10
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB413_9
.LBB413_8:                              // %B12
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB413_9:                              // %B13
	str	x22, [x20], #8
	mov	x0, x22
	b	SlowToBoolean_asm_h
.Lfunc_end413:
	.size	lnot_1_asm_h, .Lfunc_end413-lnot_1_asm_h
                                        // -- End function
	.hidden	typeof_1_asm_h                  // -- Begin function typeof_1_asm_h
	.globl	typeof_1_asm_h
	.p2align	2
	.type	typeof_1_asm_h,@function
typeof_1_asm_h:                         // @typeof_1_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x22
	bl	js_operator_typeof_gc
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB414_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB414_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end414:
	.size	typeof_1_asm_h, .Lfunc_end414-typeof_1_asm_h
                                        // -- End function
	.hidden	delete_1_asm_h                  // -- Begin function delete_1_asm_h
	.globl	delete_1_asm_h
	.p2align	2
	.type	delete_1_asm_h,@function
delete_1_asm_h:                         // @delete_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #64]
	bl	prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	.LBB415_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB415_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end415:
	.size	delete_1_asm_h, .Lfunc_end415-delete_1_asm_h
                                        // -- End function
	.hidden	delete_var_1_asm_h              // -- Begin function delete_var_1_asm_h
	.globl	delete_var_1_asm_h
	.p2align	2
	.type	delete_var_1_asm_h,@function
delete_var_1_asm_h:                     // @delete_var_1_asm_h
// %bb.0:                               // %B1
	ldr	x1, [x24, #208]
	ldr	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w3, wzr
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	LEPUS_DeleteProperty
	tbnz	w0, #31, .LBB416_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x21, x8, ne
	br	x1
.LBB416_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end416:
	.size	delete_var_1_asm_h, .Lfunc_end416-delete_var_1_asm_h
                                        // -- End function
	.hidden	mul_1_asm_h                     // -- Begin function mul_1_asm_h
	.globl	mul_1_asm_h
	.p2align	2
	.type	mul_1_asm_h,@function
mul_1_asm_h:                            // @mul_1_asm_h
// %bb.0:                               // %B47
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB417_18
// %bb.1:                               // %B47
	cmp	x21, x8
	b.hi	.LBB417_18
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB417_8
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB417_11
// %bb.4:                               // %B33
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	.LBB417_18
// %bb.5:                               // %B36
	cbnz	w8, .LBB417_7
// %bb.6:                               // %B36
	orr	w9, w22, w21
	tbnz	w9, #31, .LBB417_15
.LBB417_7:                              // %B43
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB417_8:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB417_18
// %bb.9:                               // %B7
	cmp	x21, x8
	b.lo	.LBB417_16
// %bb.10:                              // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	.LBB417_14
.LBB417_11:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB417_18
// %bb.12:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB417_13:                             // %B28
	fmov	d1, x8
	fmul	d0, d0, d1
.LBB417_14:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB417_15:                             // %B40
	mov	x22, #-9222809086901354496      // =0x8002000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB417_16:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB417_18
// %bb.17:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB417_13
.LBB417_18:                             // %B44
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        // =0x9a
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB417_20
// %bb.19:                              // %B46
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB417_20:                             // %B45
	b	exception_spill_top1_asm_h
.Lfunc_end417:
	.size	mul_1_asm_h, .Lfunc_end417-mul_1_asm_h
                                        // -- End function
	.hidden	div_1_asm_h                     // -- Begin function div_1_asm_h
	.globl	div_1_asm_h
	.p2align	2
	.type	div_1_asm_h,@function
div_1_asm_h:                            // @div_1_asm_h
// %bb.0:                               // %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB418_14
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB418_14
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB418_5
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB418_8
// %bb.4:                               // %B33
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x8, #562949953421312            // =0x2000000000000
	ldrb	w10, [x19], #1
	mov	x12, #9221120237041090560       // =0x7ff8000000000000
	sub	x20, x20, #8
	add	w10, w10, #242
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
.LBB418_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB418_14
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB418_12
// %bb.7:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	.LBB418_11
.LBB418_8:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB418_14
// %bb.9:                               // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB418_10:                             // %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
.LBB418_11:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB418_12:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB418_14
// %bb.13:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB418_10
.LBB418_14:                             // %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        // =0x9b
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB418_16
// %bb.15:                              // %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB418_16:                             // %B42
	b	exception_spill_top1_asm_h
.Lfunc_end418:
	.size	div_1_asm_h, .Lfunc_end418-div_1_asm_h
                                        // -- End function
	.hidden	mod_1_asm_h                     // -- Begin function mod_1_asm_h
	.globl	mod_1_asm_h
	.p2align	2
	.type	mod_1_asm_h,@function
mod_1_asm_h:                            // @mod_1_asm_h
// %bb.0:                               // %B39
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB419_16
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB419_16
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB419_7
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB419_10
// %bb.4:                               // %B33
	tbnz	w22, #31, .LBB419_16
// %bb.5:                               // %B33
	cmp	w21, #1
	b.lt	.LBB419_16
// %bb.6:                               // %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB419_7:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB419_16
// %bb.8:                               // %B7
	cmp	x21, x8
	b.lo	.LBB419_14
// %bb.9:                               // %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	.LBB419_13
.LBB419_10:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB419_16
// %bb.11:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB419_12:                             // %B28
	fmov	d1, x8
.LBB419_13:                             // %B28
	bl	fmod
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB419_14:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB419_16
// %bb.15:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB419_12
.LBB419_16:                             // %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        // =0x9c
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB419_18
// %bb.17:                              // %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB419_18:                             // %B37
	b	exception_spill_top1_asm_h
.Lfunc_end419:
	.size	mod_1_asm_h, .Lfunc_end419-mod_1_asm_h
                                        // -- End function
	.hidden	add_1_asm_h                     // -- Begin function add_1_asm_h
	.globl	add_1_asm_h
	.p2align	2
	.type	add_1_asm_h,@function
add_1_asm_h:                            // @add_1_asm_h
// %bb.0:                               // %B45
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB420_15
// %bb.1:                               // %B45
	cmp	x21, x8
	b.hi	.LBB420_15
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB420_6
// %bb.3:                               // %B26
	cmp	x21, x8
	b.lo	.LBB420_9
// %bb.4:                               // %B36
	adds	w8, w22, w21
	b.vs	.LBB420_15
// %bb.5:                               // %B38
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB420_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB420_15
// %bb.7:                               // %B10
	cmp	x21, x8
	b.lo	.LBB420_13
// %bb.8:                               // %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	.LBB420_12
.LBB420_9:                              // %B28
	tst	x21, #0xfffe000000000000
	b.eq	.LBB420_15
// %bb.10:                              // %B31
	scvtf	d0, w22
	add	x8, x21, x8
.LBB420_11:                             // %B31
	fmov	d1, x8
	fadd	d0, d0, d1
.LBB420_12:                             // %B31
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB420_13:                             // %B12
	tst	x21, #0xfffe000000000000
	b.eq	.LBB420_15
// %bb.14:                              // %B15
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB420_11
.LBB420_15:                             // %B6
	mov	x8, #2                          // =0x2
	and	x9, x22, #0xffff000000000003
	mov	x10, x20
	movk	x8, #1, lsl #48
	str	x21, [x10], #8
	cmp	x9, x8
	str	x10, [x23, #64]
	b.ne	.LBB420_18
// %bb.16:                              // %B6
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.ne	.LBB420_18
// %bb.17:                              // %B39
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	JS_ConcatString_GC
	b	.LBB420_19
.LBB420_18:                             // %B42
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_add_slow_gc
.LBB420_19:                             // %B42
	cmp	x0, #130
	b.eq	.LBB420_21
// %bb.20:                              // %B44
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB420_21:                             // %B43
	b	exception_spill_top1_asm_h
.Lfunc_end420:
	.size	add_1_asm_h, .Lfunc_end420-add_1_asm_h
                                        // -- End function
	.hidden	sub_1_asm_h                     // -- Begin function sub_1_asm_h
	.globl	sub_1_asm_h
	.p2align	2
	.type	sub_1_asm_h,@function
sub_1_asm_h:                            // @sub_1_asm_h
// %bb.0:                               // %B39
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB421_15
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB421_15
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB421_6
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB421_9
// %bb.4:                               // %B33
	subs	w8, w22, w21
	b.vs	.LBB421_15
// %bb.5:                               // %B35
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB421_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB421_15
// %bb.7:                               // %B7
	cmp	x21, x8
	b.lo	.LBB421_13
// %bb.8:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	.LBB421_12
.LBB421_9:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB421_15
// %bb.10:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB421_11:                             // %B28
	fmov	d1, x8
	fsub	d0, d0, d1
.LBB421_12:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB421_13:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB421_15
// %bb.14:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB421_11
.LBB421_15:                             // %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        // =0x9e
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB421_17
// %bb.16:                              // %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB421_17:                             // %B37
	b	exception_spill_top1_asm_h
.Lfunc_end421:
	.size	sub_1_asm_h, .Lfunc_end421-sub_1_asm_h
                                        // -- End function
	.hidden	pow_1_asm_h                     // -- Begin function pow_1_asm_h
	.globl	pow_1_asm_h
	.p2align	2
	.type	pow_1_asm_h,@function
pow_1_asm_h:                            // @pow_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	mov	w3, #159                        // =0x9f
	mov	x1, x22
	str	x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB422_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB422_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end422:
	.size	pow_1_asm_h, .Lfunc_end422-pow_1_asm_h
                                        // -- End function
	.hidden	shl_1_asm_h                     // -- Begin function shl_1_asm_h
	.globl	shl_1_asm_h
	.p2align	2
	.type	shl_1_asm_h,@function
shl_1_asm_h:                            // @shl_1_asm_h
// %bb.0:                               // %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB423_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB423_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB423_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB423_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB423_5:                              // %B16
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #8
	add	w9, w9, #242
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB423_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB423_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB423_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB423_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB423_5
.LBB423_10:                             // %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        // =0xa0
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB423_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB423_12:                             // %B26
	b	exception_spill_top1_asm_h
.Lfunc_end423:
	.size	shl_1_asm_h, .Lfunc_end423-shl_1_asm_h
                                        // -- End function
	.hidden	sar_1_asm_h                     // -- Begin function sar_1_asm_h
	.globl	sar_1_asm_h
	.p2align	2
	.type	sar_1_asm_h,@function
sar_1_asm_h:                            // @sar_1_asm_h
// %bb.0:                               // %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB424_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB424_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB424_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB424_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB424_5:                              // %B16
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #8
	add	w9, w9, #242
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB424_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB424_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB424_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB424_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB424_5
.LBB424_10:                             // %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        // =0xa1
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB424_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB424_12:                             // %B26
	b	exception_spill_top1_asm_h
.Lfunc_end424:
	.size	sar_1_asm_h, .Lfunc_end424-sar_1_asm_h
                                        // -- End function
	.hidden	shr_1_asm_h                     // -- Begin function shr_1_asm_h
	.globl	shr_1_asm_h
	.p2align	2
	.type	shr_1_asm_h,@function
shr_1_asm_h:                            // @shr_1_asm_h
// %bb.0:                               // %B36
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB425_11
// %bb.1:                               // %B36
	cmp	x21, x8
	b.hi	.LBB425_11
// %bb.2:                               // %B10
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB425_6
// %bb.3:                               // %B27
	cmp	x21, x8
	b.lo	.LBB425_11
// %bb.4:                               // %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, .LBB425_10
.LBB425_5:                              // %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB425_6:                              // %B12
	tst	x22, #0xfffe000000000000
	b.eq	.LBB425_11
// %bb.7:                               // %B12
	cmp	x21, x8
	b.lo	.LBB425_11
// %bb.8:                               // %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB425_11
// %bb.9:                               // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, .LBB425_5
.LBB425_10:                             // %B6
	ucvtf	d0, w8
	mov	x9, #562949953421312            // =0x2000000000000
	fmov	x8, d0
	fcmp	d0, d0
	add	x8, x8, x9
	mov	x9, #9221120237041090560        // =0x7ff8000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB425_11:                             // %B33
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	.LBB425_13
// %bb.12:                              // %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB425_13:                             // %B34
	b	exception_spill_top1_asm_h
.Lfunc_end425:
	.size	shr_1_asm_h, .Lfunc_end425-shr_1_asm_h
                                        // -- End function
	.hidden	lt_1_asm_h                      // -- Begin function lt_1_asm_h
	.globl	lt_1_asm_h
	.p2align	2
	.type	lt_1_asm_h,@function
lt_1_asm_h:                             // @lt_1_asm_h
// %bb.0:                               // %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB426_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB426_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB426_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB426_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, lt
	br	x1
.LBB426_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB426_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB426_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB426_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB426_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB426_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB426_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB426_12:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        // =0xa3
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB426_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB426_14:                             // %B22
	b	exception_spill_top1_asm_h
.Lfunc_end426:
	.size	lt_1_asm_h, .Lfunc_end426-lt_1_asm_h
                                        // -- End function
	.hidden	lte_1_asm_h                     // -- Begin function lte_1_asm_h
	.globl	lte_1_asm_h
	.p2align	2
	.type	lte_1_asm_h,@function
lte_1_asm_h:                            // @lte_1_asm_h
// %bb.0:                               // %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB427_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB427_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB427_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB427_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, le
	br	x1
.LBB427_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB427_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB427_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB427_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB427_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB427_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB427_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB427_12:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        // =0xa4
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB427_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB427_14:                             // %B22
	b	exception_spill_top1_asm_h
.Lfunc_end427:
	.size	lte_1_asm_h, .Lfunc_end427-lte_1_asm_h
                                        // -- End function
	.hidden	gt_1_asm_h                      // -- Begin function gt_1_asm_h
	.globl	gt_1_asm_h
	.p2align	2
	.type	gt_1_asm_h,@function
gt_1_asm_h:                             // @gt_1_asm_h
// %bb.0:                               // %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB428_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB428_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB428_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB428_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB428_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB428_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB428_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB428_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB428_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB428_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB428_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB428_12:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        // =0xa5
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB428_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB428_14:                             // %B22
	b	exception_spill_top1_asm_h
.Lfunc_end428:
	.size	gt_1_asm_h, .Lfunc_end428-gt_1_asm_h
                                        // -- End function
	.hidden	gte_1_asm_h                     // -- Begin function gte_1_asm_h
	.globl	gte_1_asm_h
	.p2align	2
	.type	gte_1_asm_h,@function
gte_1_asm_h:                            // @gte_1_asm_h
// %bb.0:                               // %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB429_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB429_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB429_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB429_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB429_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB429_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB429_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB429_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB429_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB429_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB429_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #242
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB429_12:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        // =0xa6
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB429_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB429_14:                             // %B22
	b	exception_spill_top1_asm_h
.Lfunc_end429:
	.size	gte_1_asm_h, .Lfunc_end429-gte_1_asm_h
                                        // -- End function
	.hidden	instanceof_1_asm_h              // -- Begin function instanceof_1_asm_h
	.globl	instanceof_1_asm_h
	.p2align	2
	.type	instanceof_1_asm_h,@function
instanceof_1_asm_h:                     // @instanceof_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #64]
	bl	prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	.LBB430_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB430_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end430:
	.size	instanceof_1_asm_h, .Lfunc_end430-instanceof_1_asm_h
                                        // -- End function
	.hidden	in_1_asm_h                      // -- Begin function in_1_asm_h
	.globl	in_1_asm_h
	.p2align	2
	.type	in_1_asm_h,@function
in_1_asm_h:                             // @in_1_asm_h
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #64]
	bl	prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	.LBB431_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB431_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end431:
	.size	in_1_asm_h, .Lfunc_end431-in_1_asm_h
                                        // -- End function
	.hidden	eq_1_asm_h                      // -- Begin function eq_1_asm_h
	.globl	eq_1_asm_h
	.p2align	2
	.type	eq_1_asm_h,@function
eq_1_asm_h:                             // @eq_1_asm_h
// %bb.0:                               // %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB432_13
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB432_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB432_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB432_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB432_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB432_13
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB432_11
// %bb.7:                               // %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #242
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB432_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB432_13
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB432_10:                             // %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #242
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB432_11:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB432_13
// %bb.12:                              // %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB432_10
.LBB432_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB432_15
.LBB432_14:                             // %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB432_15:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB432_17
// %bb.16:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB432_14
	b	.LBB432_20
.LBB432_17:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB432_20
// %bb.18:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB432_21
// %bb.19:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB432_21
.LBB432_20:                             // %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB432_21:                             // %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB432_23
// %bb.22:                              // %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB432_23:                             // %B42
	b	exception_spill_top1_asm_h
.Lfunc_end432:
	.size	eq_1_asm_h, .Lfunc_end432-eq_1_asm_h
                                        // -- End function
	.hidden	neq_1_asm_h                     // -- Begin function neq_1_asm_h
	.globl	neq_1_asm_h
	.p2align	2
	.type	neq_1_asm_h,@function
neq_1_asm_h:                            // @neq_1_asm_h
// %bb.0:                               // %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB433_13
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB433_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB433_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB433_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB433_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB433_13
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB433_11
// %bb.7:                               // %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #242
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB433_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB433_13
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB433_10:                             // %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #242
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB433_11:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB433_13
// %bb.12:                              // %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB433_10
.LBB433_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB433_15
.LBB433_14:                             // %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB433_15:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB433_17
// %bb.16:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB433_14
	b	.LBB433_20
.LBB433_17:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB433_20
// %bb.18:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB433_21
// %bb.19:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB433_21
.LBB433_20:                             // %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB433_21:                             // %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB433_23
// %bb.22:                              // %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB433_23:                             // %B42
	b	exception_spill_top1_asm_h
.Lfunc_end433:
	.size	neq_1_asm_h, .Lfunc_end433-neq_1_asm_h
                                        // -- End function
	.hidden	strict_eq_1_asm_h               // -- Begin function strict_eq_1_asm_h
	.globl	strict_eq_1_asm_h
	.p2align	2
	.type	strict_eq_1_asm_h,@function
strict_eq_1_asm_h:                      // @strict_eq_1_asm_h
// %bb.0:                               // %B36
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB434_13
// %bb.1:                               // %B36
	cmp	x21, x8
	b.hi	.LBB434_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB434_5
// %bb.3:                               // %B27
	cmp	x21, x8
	b.lo	.LBB434_8
// %bb.4:                               // %B32
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB434_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB434_13
// %bb.6:                               // %B20
	cmp	x21, x8
	b.lo	.LBB434_11
// %bb.7:                               // %B25
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #242
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB434_8:                              // %B29
	tst	x21, #0xfffe000000000000
	b.eq	.LBB434_13
// %bb.9:                               // %B31
	scvtf	d0, w22
	add	x8, x21, x8
.LBB434_10:                             // %B31
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #242
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB434_11:                             // %B22
	tst	x21, #0xfffe000000000000
	b.eq	.LBB434_13
// %bb.12:                              // %B24
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB434_10
.LBB434_13:                             // %B10
	cmp	x22, x21
	b.ne	.LBB434_15
// %bb.14:                              // %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB434_15:                             // %B13
	and	x8, x21, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	mov	x13, #2                         // =0x2
	ccmp	x8, x12, #4, ne
	movk	x13, #65535, lsl #48
	and	x9, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w10, eq
	cmp	x9, x13
	ccmp	x9, x12, #4, ne
	ccmp	x9, x11, #4, ne
	b.ne	.LBB434_17
// %bb.16:                              // %B13
	tbnz	w10, #0, .LBB434_20
.LBB434_17:                             // %B16
	mov	x10, #-281474976710656          // =0xffff000000000000
	cmp	x9, x10
	b.ne	.LBB434_19
// %bb.18:                              // %B16
	cmp	x8, x10
	b.eq	.LBB434_22
.LBB434_19:                             // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB434_20:                             // %B33
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB434_24
// %bb.21:                              // %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB434_22:                             // %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #8
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB434_25
// %bb.23:                              // %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB434_24:                             // %B34
	b	exception_spill_top1_asm_h
.LBB434_25:                             // %B8
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end434:
	.size	strict_eq_1_asm_h, .Lfunc_end434-strict_eq_1_asm_h
                                        // -- End function
	.hidden	strict_neq_1_asm_h              // -- Begin function strict_neq_1_asm_h
	.globl	strict_neq_1_asm_h
	.p2align	2
	.type	strict_neq_1_asm_h,@function
strict_neq_1_asm_h:                     // @strict_neq_1_asm_h
// %bb.0:                               // %B36
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB435_13
// %bb.1:                               // %B36
	cmp	x21, x8
	b.hi	.LBB435_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB435_5
// %bb.3:                               // %B27
	cmp	x21, x8
	b.lo	.LBB435_8
// %bb.4:                               // %B32
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB435_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB435_13
// %bb.6:                               // %B20
	cmp	x21, x8
	b.lo	.LBB435_11
// %bb.7:                               // %B25
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #242
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB435_8:                              // %B29
	tst	x21, #0xfffe000000000000
	b.eq	.LBB435_13
// %bb.9:                               // %B31
	scvtf	d0, w22
	add	x8, x21, x8
.LBB435_10:                             // %B31
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #242
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB435_11:                             // %B22
	tst	x21, #0xfffe000000000000
	b.eq	.LBB435_13
// %bb.12:                              // %B24
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB435_10
.LBB435_13:                             // %B10
	cmp	x22, x21
	b.ne	.LBB435_15
// %bb.14:                              // %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB435_15:                             // %B13
	and	x8, x21, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	mov	x13, #2                         // =0x2
	ccmp	x8, x12, #4, ne
	movk	x13, #65535, lsl #48
	and	x9, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w10, eq
	cmp	x9, x13
	ccmp	x9, x12, #4, ne
	ccmp	x9, x11, #4, ne
	b.ne	.LBB435_17
// %bb.16:                              // %B13
	tbnz	w10, #0, .LBB435_20
.LBB435_17:                             // %B16
	mov	x10, #-281474976710656          // =0xffff000000000000
	cmp	x9, x10
	b.ne	.LBB435_19
// %bb.18:                              // %B16
	cmp	x8, x10
	b.eq	.LBB435_22
.LBB435_19:                             // %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB435_20:                             // %B33
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB435_24
// %bb.21:                              // %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB435_22:                             // %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #8
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB435_25
// %bb.23:                              // %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB435_24:                             // %B34
	b	exception_spill_top1_asm_h
.LBB435_25:                             // %B8
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end435:
	.size	strict_neq_1_asm_h, .Lfunc_end435-strict_neq_1_asm_h
                                        // -- End function
	.hidden	and_1_asm_h                     // -- Begin function and_1_asm_h
	.globl	and_1_asm_h
	.p2align	2
	.type	and_1_asm_h,@function
and_1_asm_h:                            // @and_1_asm_h
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
	sub	x20, x20, #8
	and	w8, w8, w21
	add	w9, w9, #242
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
	mov	w3, #173                        // =0xad
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB436_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB436_12:                             // %B26
	b	exception_spill_top1_asm_h
.Lfunc_end436:
	.size	and_1_asm_h, .Lfunc_end436-and_1_asm_h
                                        // -- End function
	.hidden	xor_1_asm_h                     // -- Begin function xor_1_asm_h
	.globl	xor_1_asm_h
	.p2align	2
	.type	xor_1_asm_h,@function
xor_1_asm_h:                            // @xor_1_asm_h
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
	sub	x20, x20, #8
	eor	w8, w8, w21
	add	w9, w9, #242
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
	mov	w3, #174                        // =0xae
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB437_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB437_12:                             // %B26
	b	exception_spill_top1_asm_h
.Lfunc_end437:
	.size	xor_1_asm_h, .Lfunc_end437-xor_1_asm_h
                                        // -- End function
	.hidden	or_1_asm_h                      // -- Begin function or_1_asm_h
	.globl	or_1_asm_h
	.p2align	2
	.type	or_1_asm_h,@function
or_1_asm_h:                             // @or_1_asm_h
// %bb.0:                               // %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB438_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB438_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB438_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB438_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB438_5:                              // %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	w8, w8, w21
	add	w9, w9, #242
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB438_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB438_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB438_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB438_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB438_5
.LBB438_10:                             // %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        // =0xaf
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB438_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB438_12:                             // %B26
	b	exception_spill_top1_asm_h
.Lfunc_end438:
	.size	or_1_asm_h, .Lfunc_end438-or_1_asm_h
                                        // -- End function
	.hidden	nop_1_asm_h                     // -- Begin function nop_1_asm_h
	.globl	nop_1_asm_h
	.p2align	2
	.type	nop_1_asm_h,@function
nop_1_asm_h:                            // @nop_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end439:
	.size	nop_1_asm_h, .Lfunc_end439-nop_1_asm_h
                                        // -- End function
	.hidden	push_minus1_1_asm_h             // -- Begin function push_minus1_1_asm_h
	.globl	push_minus1_1_asm_h
	.p2align	2
	.type	push_minus1_1_asm_h,@function
push_minus1_1_asm_h:                    // @push_minus1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562945658454017          // =0xfffe0000ffffffff
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end440:
	.size	push_minus1_1_asm_h, .Lfunc_end440-push_minus1_1_asm_h
                                        // -- End function
	.hidden	push_0_1_asm_h                  // -- Begin function push_0_1_asm_h
	.globl	push_0_1_asm_h
	.p2align	2
	.type	push_0_1_asm_h,@function
push_0_1_asm_h:                         // @push_0_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421312          // =0xfffe000000000000
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end441:
	.size	push_0_1_asm_h, .Lfunc_end441-push_0_1_asm_h
                                        // -- End function
	.hidden	push_1_1_asm_h                  // -- Begin function push_1_1_asm_h
	.globl	push_1_1_asm_h
	.p2align	2
	.type	push_1_1_asm_h,@function
push_1_1_asm_h:                         // @push_1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421311          // =0xfffe000000000001
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end442:
	.size	push_1_1_asm_h, .Lfunc_end442-push_1_1_asm_h
                                        // -- End function
	.hidden	push_2_1_asm_h                  // -- Begin function push_2_1_asm_h
	.globl	push_2_1_asm_h
	.p2align	2
	.type	push_2_1_asm_h,@function
push_2_1_asm_h:                         // @push_2_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #2                         // =0x2
	movk	x21, #65534, lsl #48
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end443:
	.size	push_2_1_asm_h, .Lfunc_end443-push_2_1_asm_h
                                        // -- End function
	.hidden	push_3_1_asm_h                  // -- Begin function push_3_1_asm_h
	.globl	push_3_1_asm_h
	.p2align	2
	.type	push_3_1_asm_h,@function
push_3_1_asm_h:                         // @push_3_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421309          // =0xfffe000000000003
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end444:
	.size	push_3_1_asm_h, .Lfunc_end444-push_3_1_asm_h
                                        // -- End function
	.hidden	push_4_1_asm_h                  // -- Begin function push_4_1_asm_h
	.globl	push_4_1_asm_h
	.p2align	2
	.type	push_4_1_asm_h,@function
push_4_1_asm_h:                         // @push_4_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #4                         // =0x4
	movk	x21, #65534, lsl #48
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end445:
	.size	push_4_1_asm_h, .Lfunc_end445-push_4_1_asm_h
                                        // -- End function
	.hidden	push_5_1_asm_h                  // -- Begin function push_5_1_asm_h
	.globl	push_5_1_asm_h
	.p2align	2
	.type	push_5_1_asm_h,@function
push_5_1_asm_h:                         // @push_5_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #5                         // =0x5
	movk	x21, #65534, lsl #48
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end446:
	.size	push_5_1_asm_h, .Lfunc_end446-push_5_1_asm_h
                                        // -- End function
	.hidden	push_6_1_asm_h                  // -- Begin function push_6_1_asm_h
	.globl	push_6_1_asm_h
	.p2align	2
	.type	push_6_1_asm_h,@function
push_6_1_asm_h:                         // @push_6_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #6                         // =0x6
	movk	x21, #65534, lsl #48
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end447:
	.size	push_6_1_asm_h, .Lfunc_end447-push_6_1_asm_h
                                        // -- End function
	.hidden	push_7_1_asm_h                  // -- Begin function push_7_1_asm_h
	.globl	push_7_1_asm_h
	.p2align	2
	.type	push_7_1_asm_h,@function
push_7_1_asm_h:                         // @push_7_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421305          // =0xfffe000000000007
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end448:
	.size	push_7_1_asm_h, .Lfunc_end448-push_7_1_asm_h
                                        // -- End function
	.hidden	push_i8_1_asm_h                 // -- Begin function push_i8_1_asm_h
	.globl	push_i8_1_asm_h
	.p2align	2
	.type	push_i8_1_asm_h,@function
push_i8_1_asm_h:                        // @push_i8_1_asm_h
// %bb.0:                               // %B0
	ldrb	w9, [x19, #1]
	ldrsb	x10, [x19]
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x19, x19, #2
	add	w9, w9, #484
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x8
	br	x1
.Lfunc_end449:
	.size	push_i8_1_asm_h, .Lfunc_end449-push_i8_1_asm_h
                                        // -- End function
	.hidden	push_i16_1_asm_h                // -- Begin function push_i16_1_asm_h
	.globl	push_i16_1_asm_h
	.p2align	2
	.type	push_i16_1_asm_h,@function
push_i16_1_asm_h:                       // @push_i16_1_asm_h
// %bb.0:                               // %B0
	ldrb	w9, [x19, #2]
	ldrsh	x10, [x19]
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x19, x19, #3
	add	w9, w9, #484
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x8
	br	x1
.Lfunc_end450:
	.size	push_i16_1_asm_h, .Lfunc_end450-push_i16_1_asm_h
                                        // -- End function
	.hidden	push_const8_1_asm_h             // -- Begin function push_const8_1_asm_h
	.globl	push_const8_1_asm_h
	.p2align	2
	.type	push_const8_1_asm_h,@function
push_const8_1_asm_h:                    // @push_const8_1_asm_h
// %bb.0:                               // %B3
	sub	sp, sp, #16
	ldr	x8, [x23, #128]
	ldrb	w9, [x19]
	ldr	w10, [x24, #336]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, .LBB451_2
// %bb.1:                               // %B4
	mov	x8, x20
	mov	x0, x24
	mov	x2, x19
	str	x22, [x8], #8
	str	x8, [x23, #64]
	str	x1, [sp, #8]                    // 8-byte Folded Spill
	bl	DebuggerPause
	ldr	x1, [sp, #8]                    // 8-byte Folded Reload
.LBB451_2:                              // %B1
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x21, x1
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
.Lfunc_end451:
	.size	push_const8_1_asm_h, .Lfunc_end451-push_const8_1_asm_h
                                        // -- End function
	.hidden	fclosure8_1_asm_h               // -- Begin function fclosure8_1_asm_h
	.globl	fclosure8_1_asm_h
	.p2align	2
	.type	fclosure8_1_asm_h,@function
fclosure8_1_asm_h:                      // @fclosure8_1_asm_h
// %bb.0:                               // %B1
	ldr	x8, [x23, #128]
	ldrb	w9, [x19]
	mov	x10, x20
	mov	x0, x24
	mov	x2, x26
	mov	x3, x23
	ldr	x1, [x8, x9, lsl #3]
	str	x22, [x10], #8
	str	x10, [x23, #64]
	bl	js_closure_gc
	cmp	x0, #130
	b.eq	.LBB452_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB452_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end452:
	.size	fclosure8_1_asm_h, .Lfunc_end452-fclosure8_1_asm_h
                                        // -- End function
	.hidden	push_empty_string_1_asm_h       // -- Begin function push_empty_string_1_asm_h
	.globl	push_empty_string_1_asm_h
	.p2align	2
	.type	push_empty_string_1_asm_h,@function
push_empty_string_1_asm_h:              // @push_empty_string_1_asm_h
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	mov	w1, #47                         // =0x2f
	mov	w2, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB453_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB453_2:                              // %B2
	b	exception_spill_top0_asm_h
.Lfunc_end453:
	.size	push_empty_string_1_asm_h, .Lfunc_end453-push_empty_string_1_asm_h
                                        // -- End function
	.hidden	get_loc8_1_asm_h                // -- Begin function get_loc8_1_asm_h
	.globl	get_loc8_1_asm_h
	.p2align	2
	.type	get_loc8_1_asm_h,@function
get_loc8_1_asm_h:                       // @get_loc8_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19, #1]
	ldrb	w9, [x19], #2
	add	w8, w8, #484
	ldr	x21, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end454:
	.size	get_loc8_1_asm_h, .Lfunc_end454-get_loc8_1_asm_h
                                        // -- End function
	.hidden	put_loc8_1_asm_h                // -- Begin function put_loc8_1_asm_h
	.globl	put_loc8_1_asm_h
	.p2align	2
	.type	put_loc8_1_asm_h,@function
put_loc8_1_asm_h:                       // @put_loc8_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end455:
	.size	put_loc8_1_asm_h, .Lfunc_end455-put_loc8_1_asm_h
                                        // -- End function
	.hidden	set_loc8_1_asm_h                // -- Begin function set_loc8_1_asm_h
	.globl	set_loc8_1_asm_h
	.p2align	2
	.type	set_loc8_1_asm_h,@function
set_loc8_1_asm_h:                       // @set_loc8_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end456:
	.size	set_loc8_1_asm_h, .Lfunc_end456-set_loc8_1_asm_h
                                        // -- End function
	.hidden	get_loc0_1_asm_h                // -- Begin function get_loc0_1_asm_h
	.globl	get_loc0_1_asm_h
	.p2align	2
	.type	get_loc0_1_asm_h,@function
get_loc0_1_asm_h:                       // @get_loc0_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27]
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end457:
	.size	get_loc0_1_asm_h, .Lfunc_end457-get_loc0_1_asm_h
                                        // -- End function
	.hidden	get_loc1_1_asm_h                // -- Begin function get_loc1_1_asm_h
	.globl	get_loc1_1_asm_h
	.p2align	2
	.type	get_loc1_1_asm_h,@function
get_loc1_1_asm_h:                       // @get_loc1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27, #8]
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end458:
	.size	get_loc1_1_asm_h, .Lfunc_end458-get_loc1_1_asm_h
                                        // -- End function
	.hidden	get_loc2_1_asm_h                // -- Begin function get_loc2_1_asm_h
	.globl	get_loc2_1_asm_h
	.p2align	2
	.type	get_loc2_1_asm_h,@function
get_loc2_1_asm_h:                       // @get_loc2_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27, #16]
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end459:
	.size	get_loc2_1_asm_h, .Lfunc_end459-get_loc2_1_asm_h
                                        // -- End function
	.hidden	get_loc3_1_asm_h                // -- Begin function get_loc3_1_asm_h
	.globl	get_loc3_1_asm_h
	.p2align	2
	.type	get_loc3_1_asm_h,@function
get_loc3_1_asm_h:                       // @get_loc3_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27, #24]
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end460:
	.size	get_loc3_1_asm_h, .Lfunc_end460-get_loc3_1_asm_h
                                        // -- End function
	.hidden	put_loc0_1_asm_h                // -- Begin function put_loc0_1_asm_h
	.globl	put_loc0_1_asm_h
	.p2align	2
	.type	put_loc0_1_asm_h,@function
put_loc0_1_asm_h:                       // @put_loc0_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end461:
	.size	put_loc0_1_asm_h, .Lfunc_end461-put_loc0_1_asm_h
                                        // -- End function
	.hidden	put_loc1_1_asm_h                // -- Begin function put_loc1_1_asm_h
	.globl	put_loc1_1_asm_h
	.p2align	2
	.type	put_loc1_1_asm_h,@function
put_loc1_1_asm_h:                       // @put_loc1_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end462:
	.size	put_loc1_1_asm_h, .Lfunc_end462-put_loc1_1_asm_h
                                        // -- End function
	.hidden	put_loc2_1_asm_h                // -- Begin function put_loc2_1_asm_h
	.globl	put_loc2_1_asm_h
	.p2align	2
	.type	put_loc2_1_asm_h,@function
put_loc2_1_asm_h:                       // @put_loc2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end463:
	.size	put_loc2_1_asm_h, .Lfunc_end463-put_loc2_1_asm_h
                                        // -- End function
	.hidden	put_loc3_1_asm_h                // -- Begin function put_loc3_1_asm_h
	.globl	put_loc3_1_asm_h
	.p2align	2
	.type	put_loc3_1_asm_h,@function
put_loc3_1_asm_h:                       // @put_loc3_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end464:
	.size	put_loc3_1_asm_h, .Lfunc_end464-put_loc3_1_asm_h
                                        // -- End function
	.hidden	set_loc0_1_asm_h                // -- Begin function set_loc0_1_asm_h
	.globl	set_loc0_1_asm_h
	.p2align	2
	.type	set_loc0_1_asm_h,@function
set_loc0_1_asm_h:                       // @set_loc0_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end465:
	.size	set_loc0_1_asm_h, .Lfunc_end465-set_loc0_1_asm_h
                                        // -- End function
	.hidden	set_loc1_1_asm_h                // -- Begin function set_loc1_1_asm_h
	.globl	set_loc1_1_asm_h
	.p2align	2
	.type	set_loc1_1_asm_h,@function
set_loc1_1_asm_h:                       // @set_loc1_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end466:
	.size	set_loc1_1_asm_h, .Lfunc_end466-set_loc1_1_asm_h
                                        // -- End function
	.hidden	set_loc2_1_asm_h                // -- Begin function set_loc2_1_asm_h
	.globl	set_loc2_1_asm_h
	.p2align	2
	.type	set_loc2_1_asm_h,@function
set_loc2_1_asm_h:                       // @set_loc2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end467:
	.size	set_loc2_1_asm_h, .Lfunc_end467-set_loc2_1_asm_h
                                        // -- End function
	.hidden	set_loc3_1_asm_h                // -- Begin function set_loc3_1_asm_h
	.globl	set_loc3_1_asm_h
	.p2align	2
	.type	set_loc3_1_asm_h,@function
set_loc3_1_asm_h:                       // @set_loc3_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end468:
	.size	set_loc3_1_asm_h, .Lfunc_end468-set_loc3_1_asm_h
                                        // -- End function
	.hidden	get_arg0_1_asm_h                // -- Begin function get_arg0_1_asm_h
	.globl	get_arg0_1_asm_h
	.p2align	2
	.type	get_arg0_1_asm_h,@function
get_arg0_1_asm_h:                       // @get_arg0_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28]
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end469:
	.size	get_arg0_1_asm_h, .Lfunc_end469-get_arg0_1_asm_h
                                        // -- End function
	.hidden	get_arg1_1_asm_h                // -- Begin function get_arg1_1_asm_h
	.globl	get_arg1_1_asm_h
	.p2align	2
	.type	get_arg1_1_asm_h,@function
get_arg1_1_asm_h:                       // @get_arg1_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28, #8]
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end470:
	.size	get_arg1_1_asm_h, .Lfunc_end470-get_arg1_1_asm_h
                                        // -- End function
	.hidden	get_arg2_1_asm_h                // -- Begin function get_arg2_1_asm_h
	.globl	get_arg2_1_asm_h
	.p2align	2
	.type	get_arg2_1_asm_h,@function
get_arg2_1_asm_h:                       // @get_arg2_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28, #16]
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end471:
	.size	get_arg2_1_asm_h, .Lfunc_end471-get_arg2_1_asm_h
                                        // -- End function
	.hidden	get_arg3_1_asm_h                // -- Begin function get_arg3_1_asm_h
	.globl	get_arg3_1_asm_h
	.p2align	2
	.type	get_arg3_1_asm_h,@function
get_arg3_1_asm_h:                       // @get_arg3_1_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28, #24]
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end472:
	.size	get_arg3_1_asm_h, .Lfunc_end472-get_arg3_1_asm_h
                                        // -- End function
	.hidden	put_arg0_1_asm_h                // -- Begin function put_arg0_1_asm_h
	.globl	put_arg0_1_asm_h
	.p2align	2
	.type	put_arg0_1_asm_h,@function
put_arg0_1_asm_h:                       // @put_arg0_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end473:
	.size	put_arg0_1_asm_h, .Lfunc_end473-put_arg0_1_asm_h
                                        // -- End function
	.hidden	put_arg1_1_asm_h                // -- Begin function put_arg1_1_asm_h
	.globl	put_arg1_1_asm_h
	.p2align	2
	.type	put_arg1_1_asm_h,@function
put_arg1_1_asm_h:                       // @put_arg1_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end474:
	.size	put_arg1_1_asm_h, .Lfunc_end474-put_arg1_1_asm_h
                                        // -- End function
	.hidden	put_arg2_1_asm_h                // -- Begin function put_arg2_1_asm_h
	.globl	put_arg2_1_asm_h
	.p2align	2
	.type	put_arg2_1_asm_h,@function
put_arg2_1_asm_h:                       // @put_arg2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end475:
	.size	put_arg2_1_asm_h, .Lfunc_end475-put_arg2_1_asm_h
                                        // -- End function
	.hidden	put_arg3_1_asm_h                // -- Begin function put_arg3_1_asm_h
	.globl	put_arg3_1_asm_h
	.p2align	2
	.type	put_arg3_1_asm_h,@function
put_arg3_1_asm_h:                       // @put_arg3_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end476:
	.size	put_arg3_1_asm_h, .Lfunc_end476-put_arg3_1_asm_h
                                        // -- End function
	.hidden	set_arg0_1_asm_h                // -- Begin function set_arg0_1_asm_h
	.globl	set_arg0_1_asm_h
	.p2align	2
	.type	set_arg0_1_asm_h,@function
set_arg0_1_asm_h:                       // @set_arg0_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end477:
	.size	set_arg0_1_asm_h, .Lfunc_end477-set_arg0_1_asm_h
                                        // -- End function
	.hidden	set_arg1_1_asm_h                // -- Begin function set_arg1_1_asm_h
	.globl	set_arg1_1_asm_h
	.p2align	2
	.type	set_arg1_1_asm_h,@function
set_arg1_1_asm_h:                       // @set_arg1_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end478:
	.size	set_arg1_1_asm_h, .Lfunc_end478-set_arg1_1_asm_h
                                        // -- End function
	.hidden	set_arg2_1_asm_h                // -- Begin function set_arg2_1_asm_h
	.globl	set_arg2_1_asm_h
	.p2align	2
	.type	set_arg2_1_asm_h,@function
set_arg2_1_asm_h:                       // @set_arg2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end479:
	.size	set_arg2_1_asm_h, .Lfunc_end479-set_arg2_1_asm_h
                                        // -- End function
	.hidden	set_arg3_1_asm_h                // -- Begin function set_arg3_1_asm_h
	.globl	set_arg3_1_asm_h
	.p2align	2
	.type	set_arg3_1_asm_h,@function
set_arg3_1_asm_h:                       // @set_arg3_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end480:
	.size	set_arg3_1_asm_h, .Lfunc_end480-set_arg3_1_asm_h
                                        // -- End function
	.hidden	get_var_ref0_1_asm_h            // -- Begin function get_var_ref0_1_asm_h
	.globl	get_var_ref0_1_asm_h
	.p2align	2
	.type	get_var_ref0_1_asm_h,@function
get_var_ref0_1_asm_h:                   // @get_var_ref0_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldrb	w9, [x19], #1
	ldr	x8, [x8, #32]
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x21, [x8]
	br	x1
.Lfunc_end481:
	.size	get_var_ref0_1_asm_h, .Lfunc_end481-get_var_ref0_1_asm_h
                                        // -- End function
	.hidden	get_var_ref1_1_asm_h            // -- Begin function get_var_ref1_1_asm_h
	.globl	get_var_ref1_1_asm_h
	.p2align	2
	.type	get_var_ref1_1_asm_h,@function
get_var_ref1_1_asm_h:                   // @get_var_ref1_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldrb	w9, [x19], #1
	ldr	x8, [x8, #32]
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x21, [x8]
	br	x1
.Lfunc_end482:
	.size	get_var_ref1_1_asm_h, .Lfunc_end482-get_var_ref1_1_asm_h
                                        // -- End function
	.hidden	get_var_ref2_1_asm_h            // -- Begin function get_var_ref2_1_asm_h
	.globl	get_var_ref2_1_asm_h
	.p2align	2
	.type	get_var_ref2_1_asm_h,@function
get_var_ref2_1_asm_h:                   // @get_var_ref2_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldrb	w9, [x19], #1
	ldr	x8, [x8, #32]
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x21, [x8]
	br	x1
.Lfunc_end483:
	.size	get_var_ref2_1_asm_h, .Lfunc_end483-get_var_ref2_1_asm_h
                                        // -- End function
	.hidden	get_var_ref3_1_asm_h            // -- Begin function get_var_ref3_1_asm_h
	.globl	get_var_ref3_1_asm_h
	.p2align	2
	.type	get_var_ref3_1_asm_h,@function
get_var_ref3_1_asm_h:                   // @get_var_ref3_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldrb	w9, [x19], #1
	ldr	x8, [x8, #32]
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x21, [x8]
	br	x1
.Lfunc_end484:
	.size	get_var_ref3_1_asm_h, .Lfunc_end484-get_var_ref3_1_asm_h
                                        // -- End function
	.hidden	put_var_ref0_1_asm_h            // -- Begin function put_var_ref0_1_asm_h
	.globl	put_var_ref0_1_asm_h
	.p2align	2
	.type	put_var_ref0_1_asm_h,@function
put_var_ref0_1_asm_h:                   // @put_var_ref0_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end485:
	.size	put_var_ref0_1_asm_h, .Lfunc_end485-put_var_ref0_1_asm_h
                                        // -- End function
	.hidden	put_var_ref1_1_asm_h            // -- Begin function put_var_ref1_1_asm_h
	.globl	put_var_ref1_1_asm_h
	.p2align	2
	.type	put_var_ref1_1_asm_h,@function
put_var_ref1_1_asm_h:                   // @put_var_ref1_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end486:
	.size	put_var_ref1_1_asm_h, .Lfunc_end486-put_var_ref1_1_asm_h
                                        // -- End function
	.hidden	put_var_ref2_1_asm_h            // -- Begin function put_var_ref2_1_asm_h
	.globl	put_var_ref2_1_asm_h
	.p2align	2
	.type	put_var_ref2_1_asm_h,@function
put_var_ref2_1_asm_h:                   // @put_var_ref2_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end487:
	.size	put_var_ref2_1_asm_h, .Lfunc_end487-put_var_ref2_1_asm_h
                                        // -- End function
	.hidden	put_var_ref3_1_asm_h            // -- Begin function put_var_ref3_1_asm_h
	.globl	put_var_ref3_1_asm_h
	.p2align	2
	.type	put_var_ref3_1_asm_h,@function
put_var_ref3_1_asm_h:                   // @put_var_ref3_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end488:
	.size	put_var_ref3_1_asm_h, .Lfunc_end488-put_var_ref3_1_asm_h
                                        // -- End function
	.hidden	set_var_ref0_1_asm_h            // -- Begin function set_var_ref0_1_asm_h
	.globl	set_var_ref0_1_asm_h
	.p2align	2
	.type	set_var_ref0_1_asm_h,@function
set_var_ref0_1_asm_h:                   // @set_var_ref0_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end489:
	.size	set_var_ref0_1_asm_h, .Lfunc_end489-set_var_ref0_1_asm_h
                                        // -- End function
	.hidden	set_var_ref1_1_asm_h            // -- Begin function set_var_ref1_1_asm_h
	.globl	set_var_ref1_1_asm_h
	.p2align	2
	.type	set_var_ref1_1_asm_h,@function
set_var_ref1_1_asm_h:                   // @set_var_ref1_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end490:
	.size	set_var_ref1_1_asm_h, .Lfunc_end490-set_var_ref1_1_asm_h
                                        // -- End function
	.hidden	set_var_ref2_1_asm_h            // -- Begin function set_var_ref2_1_asm_h
	.globl	set_var_ref2_1_asm_h
	.p2align	2
	.type	set_var_ref2_1_asm_h,@function
set_var_ref2_1_asm_h:                   // @set_var_ref2_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end491:
	.size	set_var_ref2_1_asm_h, .Lfunc_end491-set_var_ref2_1_asm_h
                                        // -- End function
	.hidden	set_var_ref3_1_asm_h            // -- Begin function set_var_ref3_1_asm_h
	.globl	set_var_ref3_1_asm_h
	.p2align	2
	.type	set_var_ref3_1_asm_h,@function
set_var_ref3_1_asm_h:                   // @set_var_ref3_1_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end492:
	.size	set_var_ref3_1_asm_h, .Lfunc_end492-set_var_ref3_1_asm_h
                                        // -- End function
	.hidden	get_length_1_asm_h              // -- Begin function get_length_1_asm_h
	.globl	get_length_1_asm_h
	.p2align	2
	.type	get_length_1_asm_h,@function
get_length_1_asm_h:                     // @get_length_1_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB493_10
// %bb.1:                               // %B25
	mov	x9, x22
	mov	w8, #18                         // =0x12
.LBB493_2:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB493_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	mvn	w10, w10
	orr	w10, w10, #0xffffffcf
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB493_5
.LBB493_3:                              // %B1
                                        //   Parent Loop BB493_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, #48
	b.eq	.LBB493_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB493_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB493_3
.LBB493_5:                              // %B14
                                        //   in Loop: Header=BB493_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB493_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB493_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB493_2
	b	.LBB493_9
.LBB493_7:                              // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB493_10
// %bb.8:                               // %B4
	lsl	w8, w10, #1
	ldr	x9, [x9, #16]
	sub	w8, w8, #2
	ldr	x8, [x9, w8, sxtw #3]
.LBB493_9:                              // %B6
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB493_10:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #48                         // =0x30
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB493_12
// %bb.11:                              // %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB493_12:                             // %B22
	b	exception_spill_top0_asm_h
.Lfunc_end493:
	.size	get_length_1_asm_h, .Lfunc_end493-get_length_1_asm_h
                                        // -- End function
	.hidden	if_false8_1_asm_h               // -- Begin function if_false8_1_asm_h
	.globl	if_false8_1_asm_h
	.p2align	2
	.type	if_false8_1_asm_h,@function
if_false8_1_asm_h:                      // @if_false8_1_asm_h
// %bb.0:                               // %B23
	cmp	x22, #5
	b.le	.LBB494_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB494_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB494_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB494_6
	b	.LBB494_7
.LBB494_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB494_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB494_7
.LBB494_6:                              // %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB494_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB494_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB494_10
.LBB494_9:                              // %B19
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB494_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB494_13
// %bb.11:                              // %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB494_6
	b.vs	.LBB494_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB494_9
	b	.LBB494_6
.LBB494_13:                             // %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	SlowToBoolean_asm_h
.Lfunc_end494:
	.size	if_false8_1_asm_h, .Lfunc_end494-if_false8_1_asm_h
                                        // -- End function
	.hidden	if_true8_1_asm_h                // -- Begin function if_true8_1_asm_h
	.globl	if_true8_1_asm_h
	.p2align	2
	.type	if_true8_1_asm_h,@function
if_true8_1_asm_h:                       // @if_true8_1_asm_h
// %bb.0:                               // %B23
	cmp	x22, #5
	b.le	.LBB495_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB495_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB495_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB495_6
	b	.LBB495_7
.LBB495_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB495_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB495_7
.LBB495_6:                              // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB495_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB495_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB495_10
.LBB495_9:                              // %B19
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB495_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB495_13
// %bb.11:                              // %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB495_6
	b.vs	.LBB495_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB495_9
	b	.LBB495_6
.LBB495_13:                             // %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	SlowToBoolean_asm_h
.Lfunc_end495:
	.size	if_true8_1_asm_h, .Lfunc_end495-if_true8_1_asm_h
                                        // -- End function
	.hidden	goto8_1_asm_h                   // -- Begin function goto8_1_asm_h
	.globl	goto8_1_asm_h
	.p2align	2
	.type	goto8_1_asm_h,@function
goto8_1_asm_h:                          // @goto8_1_asm_h
// %bb.0:                               // %B0
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end496:
	.size	goto8_1_asm_h, .Lfunc_end496-goto8_1_asm_h
                                        // -- End function
	.hidden	goto16_1_asm_h                  // -- Begin function goto16_1_asm_h
	.globl	goto16_1_asm_h
	.p2align	2
	.type	goto16_1_asm_h,@function
goto16_1_asm_h:                         // @goto16_1_asm_h
// %bb.0:                               // %B0
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end497:
	.size	goto16_1_asm_h, .Lfunc_end497-goto16_1_asm_h
                                        // -- End function
	.hidden	call0_1_asm_h                   // -- Begin function call0_1_asm_h
	.globl	call0_1_asm_h
	.p2align	2
	.type	call0_1_asm_h,@function
call0_1_asm_h:                          // @call0_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	call0_0_asm_h
.Lfunc_end498:
	.size	call0_1_asm_h, .Lfunc_end498-call0_1_asm_h
                                        // -- End function
	.hidden	call1_1_asm_h                   // -- Begin function call1_1_asm_h
	.globl	call1_1_asm_h
	.p2align	2
	.type	call1_1_asm_h,@function
call1_1_asm_h:                          // @call1_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	call1_0_asm_h
.Lfunc_end499:
	.size	call1_1_asm_h, .Lfunc_end499-call1_1_asm_h
                                        // -- End function
	.hidden	call2_1_asm_h                   // -- Begin function call2_1_asm_h
	.globl	call2_1_asm_h
	.p2align	2
	.type	call2_1_asm_h,@function
call2_1_asm_h:                          // @call2_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	call2_0_asm_h
.Lfunc_end500:
	.size	call2_1_asm_h, .Lfunc_end500-call2_1_asm_h
                                        // -- End function
	.hidden	call3_1_asm_h                   // -- Begin function call3_1_asm_h
	.globl	call3_1_asm_h
	.p2align	2
	.type	call3_1_asm_h,@function
call3_1_asm_h:                          // @call3_1_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	call3_0_asm_h
.Lfunc_end501:
	.size	call3_1_asm_h, .Lfunc_end501-call3_1_asm_h
                                        // -- End function
	.hidden	is_undefined_1_asm_h            // -- Begin function is_undefined_1_asm_h
	.globl	is_undefined_1_asm_h
	.p2align	2
	.type	is_undefined_1_asm_h,@function
is_undefined_1_asm_h:                   // @is_undefined_1_asm_h
// %bb.0:                               // %B2
	cmp	x22, #18
	b.ne	.LBB502_2
// %bb.1:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB502_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end502:
	.size	is_undefined_1_asm_h, .Lfunc_end502-is_undefined_1_asm_h
                                        // -- End function
	.hidden	is_null_1_asm_h                 // -- Begin function is_null_1_asm_h
	.globl	is_null_1_asm_h
	.p2align	2
	.type	is_null_1_asm_h,@function
is_null_1_asm_h:                        // @is_null_1_asm_h
// %bb.0:                               // %B2
	cmp	x22, #2
	b.ne	.LBB503_2
// %bb.1:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB503_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end503:
	.size	is_null_1_asm_h, .Lfunc_end503-is_null_1_asm_h
                                        // -- End function
	.hidden	is_function_1_asm_h             // -- Begin function is_function_1_asm_h
	.globl	is_function_1_asm_h
	.p2align	2
	.type	is_function_1_asm_h,@function
is_function_1_asm_h:                    // @is_function_1_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x22
	bl	js_operator_typeof_gc
	cmp	w0, #27
	b.ne	.LBB504_2
// %bb.1:                               // %B2
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB504_2:                              // %B5
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end504:
	.size	is_function_1_asm_h, .Lfunc_end504-is_function_1_asm_h
                                        // -- End function
	.hidden	invalid_2_asm_h                 // -- Begin function invalid_2_asm_h
	.globl	invalid_2_asm_h
	.p2align	2
	.type	invalid_2_asm_h,@function
invalid_2_asm_h:                        // @invalid_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x23, #8]
	adrp	x1, .L__unnamed_16
	add	x1, x1, :lo12:.L__unnamed_16
	mov	x0, x24
	mov	w3, wzr
	ldr	x8, [x8, #32]
	ldr	w8, [x8, #8]
	str	x20, [x23, #64]
	mvn	w8, w8
	add	w2, w8, w19
	bl	LEPUS_ThrowInternalError
	b	exception_asm_h
.Lfunc_end505:
	.size	invalid_2_asm_h, .Lfunc_end505-invalid_2_asm_h
                                        // -- End function
	.hidden	push_i32_2_asm_h                // -- Begin function push_i32_2_asm_h
	.globl	push_i32_2_asm_h
	.p2align	2
	.type	push_i32_2_asm_h,@function
push_i32_2_asm_h:                       // @push_i32_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #4]
	ldr	w9, [x19], #5
	add	w8, w8, #484
	orr	x21, x9, #0xfffe000000000000
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end506:
	.size	push_i32_2_asm_h, .Lfunc_end506-push_i32_2_asm_h
                                        // -- End function
	.hidden	push_const_2_asm_h              // -- Begin function push_const_2_asm_h
	.globl	push_const_2_asm_h
	.p2align	2
	.type	push_const_2_asm_h,@function
push_const_2_asm_h:                     // @push_const_2_asm_h
// %bb.0:                               // %B3
	sub	sp, sp, #16
	str	x22, [x20], #8
	ldr	x8, [x23, #128]
	ldrsw	x9, [x19]
	ldr	w10, [x24, #336]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, .LBB507_2
// %bb.1:                               // %B4
	mov	x8, x20
	mov	x0, x24
	mov	x2, x19
	str	x21, [x8], #8
	str	x8, [x23, #64]
	str	x1, [sp, #8]                    // 8-byte Folded Spill
	bl	DebuggerPause
	ldr	x1, [sp, #8]                    // 8-byte Folded Reload
.LBB507_2:                              // %B1
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x1
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
.Lfunc_end507:
	.size	push_const_2_asm_h, .Lfunc_end507-push_const_2_asm_h
                                        // -- End function
	.hidden	fclosure_2_asm_h                // -- Begin function fclosure_2_asm_h
	.globl	fclosure_2_asm_h
	.p2align	2
	.type	fclosure_2_asm_h,@function
fclosure_2_asm_h:                       // @fclosure_2_asm_h
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	mov	x2, x26
	ldr	x8, [x23, #128]
	ldrsw	x9, [x19]
	mov	x3, x23
	ldr	x1, [x8, x9, lsl #3]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #64]
	bl	js_closure_gc
	cmp	x0, #130
	b.eq	.LBB508_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB508_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end508:
	.size	fclosure_2_asm_h, .Lfunc_end508-fclosure_2_asm_h
                                        // -- End function
	.hidden	push_atom_value_2_asm_h         // -- Begin function push_atom_value_2_asm_h
	.globl	push_atom_value_2_asm_h
	.p2align	2
	.type	push_atom_value_2_asm_h,@function
push_atom_value_2_asm_h:                // @push_atom_value_2_asm_h
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	mov	w2, wzr
	ldr	w1, [x19]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB509_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB509_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end509:
	.size	push_atom_value_2_asm_h, .Lfunc_end509-push_atom_value_2_asm_h
                                        // -- End function
	.hidden	private_symbol_2_asm_h          // -- Begin function private_symbol_2_asm_h
	.globl	private_symbol_2_asm_h
	.p2align	2
	.type	private_symbol_2_asm_h,@function
private_symbol_2_asm_h:                 // @private_symbol_2_asm_h
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	mov	w2, #4                          // =0x4
	ldr	w1, [x19]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #64]
	bl	JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	.LBB510_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB510_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end510:
	.size	private_symbol_2_asm_h, .Lfunc_end510-private_symbol_2_asm_h
                                        // -- End function
	.hidden	undefined_2_asm_h               // -- Begin function undefined_2_asm_h
	.globl	undefined_2_asm_h
	.p2align	2
	.type	undefined_2_asm_h,@function
undefined_2_asm_h:                      // @undefined_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #18                        // =0x12
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end511:
	.size	undefined_2_asm_h, .Lfunc_end511-undefined_2_asm_h
                                        // -- End function
	.hidden	null_2_asm_h                    // -- Begin function null_2_asm_h
	.globl	null_2_asm_h
	.p2align	2
	.type	null_2_asm_h,@function
null_2_asm_h:                           // @null_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #2                         // =0x2
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end512:
	.size	null_2_asm_h, .Lfunc_end512-null_2_asm_h
                                        // -- End function
	.hidden	push_this_2_asm_h               // -- Begin function push_this_2_asm_h
	.globl	push_this_2_asm_h
	.p2align	2
	.type	push_this_2_asm_h,@function
push_this_2_asm_h:                      // @push_this_2_asm_h
// %bb.0:                               // %B12
	str	x22, [x20], #8
	ldr	w8, [x23, #60]
	ldr	x1, [x23, #104]
	tbnz	w8, #0, .LBB513_2
// %bb.1:                               // %B12
	ldr	x8, [x23, #104]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, .LBB513_3
.LBB513_2:                              // %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x1
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.LBB513_3:                              // %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	.LBB513_5
// %bb.4:                               // %B7
	ldrb	w8, [x19], #1
	ldr	x9, [x24, #208]
	mov	x22, x21
	add	w8, w8, #484
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB513_5:                              // %B9
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB513_7
// %bb.6:                               // %B11
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB513_7:                              // %B10
	b	exception_spill_top1_asm_h
.Lfunc_end513:
	.size	push_this_2_asm_h, .Lfunc_end513-push_this_2_asm_h
                                        // -- End function
	.hidden	push_false_2_asm_h              // -- Begin function push_false_2_asm_h
	.globl	push_false_2_asm_h
	.p2align	2
	.type	push_false_2_asm_h,@function
push_false_2_asm_h:                     // @push_false_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #6                         // =0x6
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end514:
	.size	push_false_2_asm_h, .Lfunc_end514-push_false_2_asm_h
                                        // -- End function
	.hidden	push_true_2_asm_h               // -- Begin function push_true_2_asm_h
	.globl	push_true_2_asm_h
	.p2align	2
	.type	push_true_2_asm_h,@function
push_true_2_asm_h:                      // @push_true_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #7                         // =0x7
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end515:
	.size	push_true_2_asm_h, .Lfunc_end515-push_true_2_asm_h
                                        // -- End function
	.hidden	object_2_asm_h                  // -- Begin function object_2_asm_h
	.globl	object_2_asm_h
	.p2align	2
	.type	object_2_asm_h,@function
object_2_asm_h:                         // @object_2_asm_h
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #64]
	bl	PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	.LBB516_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB516_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end516:
	.size	object_2_asm_h, .Lfunc_end516-object_2_asm_h
                                        // -- End function
	.hidden	special_object_2_asm_h          // -- Begin function special_object_2_asm_h
	.globl	special_object_2_asm_h
	.p2align	2
	.type	special_object_2_asm_h,@function
special_object_2_asm_h:                 // @special_object_2_asm_h
// %bb.0:                               // %B15
	str	x22, [x20], #8
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	.LBB517_4
// %bb.1:                               // %B15
	cbz	w8, .LBB517_7
// %bb.2:                               // %B15
	cmp	w8, #1
	b.ne	.LBB517_12
// %bb.3:                               // %B6
	ldr	x8, [x23, #8]
	ldr	w1, [x23, #136]
	mov	x9, x20
	mov	x0, x24
	mov	x2, x28
	mov	x3, x23
	ldr	x8, [x8, #32]
	ldrh	w8, [x8, #40]
	str	x21, [x9], #8
	str	x9, [x23, #64]
	cmp	w8, w1
	csel	w4, w8, w1, lt
	bl	js_build_mapped_arguments_gc
	b	.LBB517_8
.LBB517_4:                              // %B15
	cmp	w8, #5
	b.eq	.LBB517_10
// %bb.5:                               // %B15
	cmp	w8, #4
	b.ne	.LBB517_13
// %bb.6:                               // %B9
	ldr	x8, [x23, #8]
	mov	w9, #18                         // =0x12
	ldr	x8, [x8, #48]
	cmp	x8, #0
	csel	x8, x9, x8, eq
	b	.LBB517_14
.LBB517_7:                              // %B1
	ldr	w1, [x23, #136]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x28
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	js_build_arguments_gc
.LBB517_8:                              // %B6
	cmp	x0, #130
	b.eq	.LBB517_11
.LBB517_9:
	mov	x8, x0
	b	.LBB517_14
.LBB517_10:                             // %B12
	mov	x8, x20
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.ne	.LBB517_9
.LBB517_11:                             // %B13
	b	exception_spill_top1_asm_h
.LBB517_12:                             // %B18
	ldr	x8, [x23, #8]
	b	.LBB517_14
.LBB517_13:                             // %B19
	ldr	x8, [x23, #112]
.LBB517_14:                             // %B4
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end517:
	.size	special_object_2_asm_h, .Lfunc_end517-special_object_2_asm_h
                                        // -- End function
	.hidden	rest_2_asm_h                    // -- Begin function rest_2_asm_h
	.globl	rest_2_asm_h
	.p2align	2
	.type	rest_2_asm_h,@function
rest_2_asm_h:                           // @rest_2_asm_h
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	mov	x3, x28
	ldrh	w1, [x19]
	ldr	w2, [x23, #136]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #64]
	bl	js_build_rest_gc
	cmp	x0, #130
	b.eq	.LBB518_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB518_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end518:
	.size	rest_2_asm_h, .Lfunc_end518-rest_2_asm_h
                                        // -- End function
	.hidden	drop_2_asm_h                    // -- Begin function drop_2_asm_h
	.globl	drop_2_asm_h
	.p2align	2
	.type	drop_2_asm_h,@function
drop_2_asm_h:                           // @drop_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end519:
	.size	drop_2_asm_h, .Lfunc_end519-drop_2_asm_h
                                        // -- End function
	.hidden	nip_2_asm_h                     // -- Begin function nip_2_asm_h
	.globl	nip_2_asm_h
	.p2align	2
	.type	nip_2_asm_h,@function
nip_2_asm_h:                            // @nip_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x22, x21
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end520:
	.size	nip_2_asm_h, .Lfunc_end520-nip_2_asm_h
                                        // -- End function
	.hidden	nip1_2_asm_h                    // -- Begin function nip1_2_asm_h
	.globl	nip1_2_asm_h
	.p2align	2
	.type	nip1_2_asm_h,@function
nip1_2_asm_h:                           // @nip1_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end521:
	.size	nip1_2_asm_h, .Lfunc_end521-nip1_2_asm_h
                                        // -- End function
	.hidden	dup_2_asm_h                     // -- Begin function dup_2_asm_h
	.globl	dup_2_asm_h
	.p2align	2
	.type	dup_2_asm_h,@function
dup_2_asm_h:                            // @dup_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end522:
	.size	dup_2_asm_h, .Lfunc_end522-dup_2_asm_h
                                        // -- End function
	.hidden	dup1_2_asm_h                    // -- Begin function dup1_2_asm_h
	.globl	dup1_2_asm_h
	.p2align	2
	.type	dup1_2_asm_h,@function
dup1_2_asm_h:                           // @dup1_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x1, x22
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x22, x1
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.Lfunc_end523:
	.size	dup1_2_asm_h, .Lfunc_end523-dup1_2_asm_h
                                        // -- End function
	.hidden	dup2_2_asm_h                    // -- Begin function dup2_2_asm_h
	.globl	dup2_2_asm_h
	.p2align	2
	.type	dup2_2_asm_h,@function
dup2_2_asm_h:                           // @dup2_2_asm_h
// %bb.0:                               // %B0
	stp	x22, x21, [x20], #16
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end524:
	.size	dup2_2_asm_h, .Lfunc_end524-dup2_2_asm_h
                                        // -- End function
	.hidden	dup3_2_asm_h                    // -- Begin function dup3_2_asm_h
	.globl	dup3_2_asm_h
	.p2align	2
	.type	dup3_2_asm_h,@function
dup3_2_asm_h:                           // @dup3_2_asm_h
// %bb.0:                               // %B0
	ldur	x8, [x20, #-8]
	stp	x22, x21, [x20]
	str	x8, [x20, #16]
	add	x20, x20, #24
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end525:
	.size	dup3_2_asm_h, .Lfunc_end525-dup3_2_asm_h
                                        // -- End function
	.hidden	insert2_2_asm_h                 // -- Begin function insert2_2_asm_h
	.globl	insert2_2_asm_h
	.p2align	2
	.type	insert2_2_asm_h,@function
insert2_2_asm_h:                        // @insert2_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20]
	mov	x1, x22
	mov	x22, x21
	str	x21, [x20], #8
	mov	x22, x1
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.Lfunc_end526:
	.size	insert2_2_asm_h, .Lfunc_end526-insert2_2_asm_h
                                        // -- End function
	.hidden	insert3_2_asm_h                 // -- Begin function insert3_2_asm_h
	.globl	insert3_2_asm_h
	.p2align	2
	.type	insert3_2_asm_h,@function
insert3_2_asm_h:                        // @insert3_2_asm_h
// %bb.0:                               // %B0
	ldur	x8, [x20, #-8]
	stp	x21, x22, [x20, #-8]
	mov	x1, x22
	mov	x22, x21
	str	x8, [x20], #8
	mov	x22, x1
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.Lfunc_end527:
	.size	insert3_2_asm_h, .Lfunc_end527-insert3_2_asm_h
                                        // -- End function
	.hidden	insert4_2_asm_h                 // -- Begin function insert4_2_asm_h
	.globl	insert4_2_asm_h
	.p2align	2
	.type	insert4_2_asm_h,@function
insert4_2_asm_h:                        // @insert4_2_asm_h
// %bb.0:                               // %B0
	ldp	x9, x8, [x20, #-16]
	mov	x1, x22
	stur	x21, [x20, #-16]
	stp	x9, x22, [x20, #-8]
	mov	x22, x21
	str	x8, [x20], #8
	mov	x22, x1
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
.Lfunc_end528:
	.size	insert4_2_asm_h, .Lfunc_end528-insert4_2_asm_h
                                        // -- End function
	.hidden	perm3_2_asm_h                   // -- Begin function perm3_2_asm_h
	.globl	perm3_2_asm_h
	.p2align	2
	.type	perm3_2_asm_h,@function
perm3_2_asm_h:                          // @perm3_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end529:
	.size	perm3_2_asm_h, .Lfunc_end529-perm3_2_asm_h
                                        // -- End function
	.hidden	perm4_2_asm_h                   // -- Begin function perm4_2_asm_h
	.globl	perm4_2_asm_h
	.p2align	2
	.type	perm4_2_asm_h,@function
perm4_2_asm_h:                          // @perm4_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x22
	ldp	x9, x22, [x20, #-16]
	stp	x8, x9, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end530:
	.size	perm4_2_asm_h, .Lfunc_end530-perm4_2_asm_h
                                        // -- End function
	.hidden	perm5_2_asm_h                   // -- Begin function perm5_2_asm_h
	.globl	perm5_2_asm_h
	.p2align	2
	.type	perm5_2_asm_h,@function
perm5_2_asm_h:                          // @perm5_2_asm_h
// %bb.0:                               // %B0
	ldp	x10, x9, [x20, #-24]
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-24]
	stp	x10, x9, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end531:
	.size	perm5_2_asm_h, .Lfunc_end531-perm5_2_asm_h
                                        // -- End function
	.hidden	swap_2_asm_h                    // -- Begin function swap_2_asm_h
	.globl	swap_2_asm_h
	.p2align	2
	.type	swap_2_asm_h,@function
swap_2_asm_h:                           // @swap_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	mov	x2, x22
	mov	x22, x21
	mov	x21, x2
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end532:
	.size	swap_2_asm_h, .Lfunc_end532-swap_2_asm_h
                                        // -- End function
	.hidden	swap2_2_asm_h                   // -- Begin function swap2_2_asm_h
	.globl	swap2_2_asm_h
	.p2align	2
	.type	swap2_2_asm_h,@function
swap2_2_asm_h:                          // @swap2_2_asm_h
// %bb.0:                               // %B0
	ldp	x8, x9, [x20, #-16]
	stp	x22, x21, [x20, #-16]
	ldrb	w10, [x19], #1
	add	w10, w10, #484
	mov	x22, x8
	mov	x21, x9
	ldr	x1, [x25, w10, uxtw #3]
	br	x1
.Lfunc_end533:
	.size	swap2_2_asm_h, .Lfunc_end533-swap2_2_asm_h
                                        // -- End function
	.hidden	rot3l_2_asm_h                   // -- Begin function rot3l_2_asm_h
	.globl	rot3l_2_asm_h
	.p2align	2
	.type	rot3l_2_asm_h,@function
rot3l_2_asm_h:                          // @rot3l_2_asm_h
// %bb.0:                               // %B0
	ldur	x8, [x20, #-8]
	stur	x22, [x20, #-8]
	mov	x22, x21
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.Lfunc_end534:
	.size	rot3l_2_asm_h, .Lfunc_end534-rot3l_2_asm_h
                                        // -- End function
	.hidden	rot3r_2_asm_h                   // -- Begin function rot3r_2_asm_h
	.globl	rot3r_2_asm_h
	.p2align	2
	.type	rot3r_2_asm_h,@function
rot3r_2_asm_h:                          // @rot3r_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x21
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end535:
	.size	rot3r_2_asm_h, .Lfunc_end535-rot3r_2_asm_h
                                        // -- End function
	.hidden	rot4l_2_asm_h                   // -- Begin function rot4l_2_asm_h
	.globl	rot4l_2_asm_h
	.p2align	2
	.type	rot4l_2_asm_h,@function
rot4l_2_asm_h:                          // @rot4l_2_asm_h
// %bb.0:                               // %B0
	ldp	x9, x8, [x20, #-16]
	stp	x8, x22, [x20, #-16]
	mov	x22, x21
	mov	x21, x9
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end536:
	.size	rot4l_2_asm_h, .Lfunc_end536-rot4l_2_asm_h
                                        // -- End function
	.hidden	rot5l_2_asm_h                   // -- Begin function rot5l_2_asm_h
	.globl	rot5l_2_asm_h
	.p2align	2
	.type	rot5l_2_asm_h,@function
rot5l_2_asm_h:                          // @rot5l_2_asm_h
// %bb.0:                               // %B0
	ldp	x8, x9, [x20, #-16]
	ldur	x10, [x20, #-24]
	stur	x22, [x20, #-8]
	mov	x22, x21
	mov	x21, x10
	stp	x8, x9, [x20, #-24]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end537:
	.size	rot5l_2_asm_h, .Lfunc_end537-rot5l_2_asm_h
                                        // -- End function
	.hidden	call_constructor_2_asm_h        // -- Begin function call_constructor_2_asm_h
	.globl	call_constructor_2_asm_h
	.p2align	2
	.type	call_constructor_2_asm_h,@function
call_constructor_2_asm_h:               // @call_constructor_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	call_constructor_0_asm_h
.Lfunc_end538:
	.size	call_constructor_2_asm_h, .Lfunc_end538-call_constructor_2_asm_h
                                        // -- End function
	.hidden	call_2_asm_h                    // -- Begin function call_2_asm_h
	.globl	call_2_asm_h
	.p2align	2
	.type	call_2_asm_h,@function
call_2_asm_h:                           // @call_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	call_0_asm_h
.Lfunc_end539:
	.size	call_2_asm_h, .Lfunc_end539-call_2_asm_h
                                        // -- End function
	.hidden	tail_call_2_asm_h               // -- Begin function tail_call_2_asm_h
	.globl	tail_call_2_asm_h
	.p2align	2
	.type	tail_call_2_asm_h,@function
tail_call_2_asm_h:                      // @tail_call_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	tail_call_0_asm_h
.Lfunc_end540:
	.size	tail_call_2_asm_h, .Lfunc_end540-tail_call_2_asm_h
                                        // -- End function
	.hidden	call_method_2_asm_h             // -- Begin function call_method_2_asm_h
	.globl	call_method_2_asm_h
	.p2align	2
	.type	call_method_2_asm_h,@function
call_method_2_asm_h:                    // @call_method_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	call_method_0_asm_h
.Lfunc_end541:
	.size	call_method_2_asm_h, .Lfunc_end541-call_method_2_asm_h
                                        // -- End function
	.hidden	tail_call_method_2_asm_h        // -- Begin function tail_call_method_2_asm_h
	.globl	tail_call_method_2_asm_h
	.p2align	2
	.type	tail_call_method_2_asm_h,@function
tail_call_method_2_asm_h:               // @tail_call_method_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	tail_call_method_0_asm_h
.Lfunc_end542:
	.size	tail_call_method_2_asm_h, .Lfunc_end542-tail_call_method_2_asm_h
                                        // -- End function
	.hidden	array_from_2_asm_h              // -- Begin function array_from_2_asm_h
	.globl	array_from_2_asm_h
	.p2align	2
	.type	array_from_2_asm_h,@function
array_from_2_asm_h:                     // @array_from_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	array_from_0_asm_h
.Lfunc_end543:
	.size	array_from_2_asm_h, .Lfunc_end543-array_from_2_asm_h
                                        // -- End function
	.hidden	apply_2_asm_h                   // -- Begin function apply_2_asm_h
	.globl	apply_2_asm_h
	.p2align	2
	.type	apply_2_asm_h,@function
apply_2_asm_h:                          // @apply_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	apply_0_asm_h
.Lfunc_end544:
	.size	apply_2_asm_h, .Lfunc_end544-apply_2_asm_h
                                        // -- End function
	.hidden	return_2_asm_h                  // -- Begin function return_2_asm_h
	.globl	return_2_asm_h
	.p2align	2
	.type	return_2_asm_h,@function
return_2_asm_h:                         // @return_2_asm_h
// %bb.0:                               // %B0
	mov	x0, x21
	b	common_return_asm_h
.Lfunc_end545:
	.size	return_2_asm_h, .Lfunc_end545-return_2_asm_h
                                        // -- End function
	.hidden	return_undef_2_asm_h            // -- Begin function return_undef_2_asm_h
	.globl	return_undef_2_asm_h
	.p2align	2
	.type	return_undef_2_asm_h,@function
return_undef_2_asm_h:                   // @return_undef_2_asm_h
// %bb.0:                               // %B0
	mov	w0, #18                         // =0x12
	b	common_return_asm_h
.Lfunc_end546:
	.size	return_undef_2_asm_h, .Lfunc_end546-return_undef_2_asm_h
                                        // -- End function
	.hidden	check_ctor_return_2_asm_h       // -- Begin function check_ctor_return_2_asm_h
	.globl	check_ctor_return_2_asm_h
	.p2align	2
	.type	check_ctor_return_2_asm_h,@function
check_ctor_return_2_asm_h:              // @check_ctor_return_2_asm_h
// %bb.0:                               // %B5
	mov	x8, #2                          // =0x2
	str	x22, [x20], #8
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB547_3
// %bb.1:                               // %B2
	cmp	x21, #18
	b.eq	.LBB547_4
// %bb.2:                               // %B3
	mov	x8, x20
	adrp	x1, .L__unnamed_17
	add	x1, x1, :lo12:.L__unnamed_17
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	LEPUS_ThrowTypeError
	b	exception_spill_top1_asm_h
.LBB547_3:                              // %B6
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	w21, #6                         // =0x6
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB547_4:                              // %B4
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	w21, #7                         // =0x7
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end547:
	.size	check_ctor_return_2_asm_h, .Lfunc_end547-check_ctor_return_2_asm_h
                                        // -- End function
	.hidden	check_ctor_2_asm_h              // -- Begin function check_ctor_2_asm_h
	.globl	check_ctor_2_asm_h
	.p2align	2
	.type	check_ctor_2_asm_h,@function
check_ctor_2_asm_h:                     // @check_ctor_2_asm_h
// %bb.0:                               // %B2
	ldr	x8, [x23, #112]
	cmp	x8, #18
	b.ne	.LBB548_2
// %bb.1:                               // %B3
	add	x8, x20, #16
	adrp	x1, .L__unnamed_18
	add	x1, x1, :lo12:.L__unnamed_18
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	LEPUS_ThrowTypeError
	b	exception_spill_top0_top1_asm_h
.LBB548_2:                              // %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end548:
	.size	check_ctor_2_asm_h, .Lfunc_end548-check_ctor_2_asm_h
                                        // -- End function
	.hidden	check_brand_2_asm_h             // -- Begin function check_brand_2_asm_h
	.globl	check_brand_2_asm_h
	.p2align	2
	.type	check_brand_2_asm_h,@function
check_brand_2_asm_h:                    // @check_brand_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_CheckBrand_GC
	tbnz	w0, #31, .LBB549_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB549_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end549:
	.size	check_brand_2_asm_h, .Lfunc_end549-check_brand_2_asm_h
                                        // -- End function
	.hidden	add_brand_2_asm_h               // -- Begin function add_brand_2_asm_h
	.globl	add_brand_2_asm_h
	.p2align	2
	.type	add_brand_2_asm_h,@function
add_brand_2_asm_h:                      // @add_brand_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_AddBrand_GC
	tbnz	w0, #31, .LBB550_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB550_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end550:
	.size	add_brand_2_asm_h, .Lfunc_end550-add_brand_2_asm_h
                                        // -- End function
	.hidden	return_async_2_asm_h            // -- Begin function return_async_2_asm_h
	.globl	return_async_2_asm_h
	.p2align	2
	.type	return_async_2_asm_h,@function
return_async_2_asm_h:                   // @return_async_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	return_async_0_asm_h
.Lfunc_end551:
	.size	return_async_2_asm_h, .Lfunc_end551-return_async_2_asm_h
                                        // -- End function
	.hidden	throw_2_asm_h                   // -- Begin function throw_2_asm_h
	.globl	throw_2_asm_h
	.p2align	2
	.type	throw_2_asm_h,@function
throw_2_asm_h:                          // @throw_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	throw_0_asm_h
.Lfunc_end552:
	.size	throw_2_asm_h, .Lfunc_end552-throw_2_asm_h
                                        // -- End function
	.hidden	throw_var_2_asm_h               // -- Begin function throw_var_2_asm_h
	.globl	throw_var_2_asm_h
	.p2align	2
	.type	throw_var_2_asm_h,@function
throw_var_2_asm_h:                      // @throw_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	throw_var_0_asm_h
.Lfunc_end553:
	.size	throw_var_2_asm_h, .Lfunc_end553-throw_var_2_asm_h
                                        // -- End function
	.hidden	eval_2_asm_h                    // -- Begin function eval_2_asm_h
	.globl	eval_2_asm_h
	.p2align	2
	.type	eval_2_asm_h,@function
eval_2_asm_h:                           // @eval_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	eval_0_asm_h
.Lfunc_end554:
	.size	eval_2_asm_h, .Lfunc_end554-eval_2_asm_h
                                        // -- End function
	.hidden	regexp_2_asm_h                  // -- Begin function regexp_2_asm_h
	.globl	regexp_2_asm_h
	.p2align	2
	.type	regexp_2_asm_h,@function
regexp_2_asm_h:                         // @regexp_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	w1, #18                         // =0x12
	mov	x2, x22
	mov	x3, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	.LBB555_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB555_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end555:
	.size	regexp_2_asm_h, .Lfunc_end555-regexp_2_asm_h
                                        // -- End function
	.hidden	get_super_ctor_2_asm_h          // -- Begin function get_super_ctor_2_asm_h
	.globl	get_super_ctor_2_asm_h
	.p2align	2
	.type	get_super_ctor_2_asm_h,@function
get_super_ctor_2_asm_h:                 // @get_super_ctor_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	.LBB556_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB556_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end556:
	.size	get_super_ctor_2_asm_h, .Lfunc_end556-get_super_ctor_2_asm_h
                                        // -- End function
	.hidden	get_super_2_asm_h               // -- Begin function get_super_2_asm_h
	.globl	get_super_2_asm_h
	.p2align	2
	.type	get_super_2_asm_h,@function
get_super_2_asm_h:                      // @get_super_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	LEPUS_GetPrototype
	cmp	x0, #130
	b.eq	.LBB557_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB557_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end557:
	.size	get_super_2_asm_h, .Lfunc_end557-get_super_2_asm_h
                                        // -- End function
	.hidden	import_2_asm_h                  // -- Begin function import_2_asm_h
	.globl	import_2_asm_h
	.p2align	2
	.type	import_2_asm_h,@function
import_2_asm_h:                         // @import_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	js_dynamic_import
	cmp	x0, #130
	b.eq	.LBB558_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB558_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end558:
	.size	import_2_asm_h, .Lfunc_end558-import_2_asm_h
                                        // -- End function
	.hidden	check_var_2_asm_h               // -- Begin function check_var_2_asm_h
	.globl	check_var_2_asm_h
	.p2align	2
	.type	check_var_2_asm_h,@function
check_var_2_asm_h:                      // @check_var_2_asm_h
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	ldr	w1, [x19]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #64]
	bl	JS_CheckGlobalVar_GC
	tbnz	w0, #31, .LBB559_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	mov	x22, x21
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x21, x8, ne
	br	x1
.LBB559_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end559:
	.size	check_var_2_asm_h, .Lfunc_end559-check_var_2_asm_h
                                        // -- End function
	.hidden	get_var_undef_2_asm_h           // -- Begin function get_var_undef_2_asm_h
	.globl	get_var_undef_2_asm_h
	.p2align	2
	.type	get_var_undef_2_asm_h,@function
get_var_undef_2_asm_h:                  // @get_var_undef_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	ldr	x8, [x24, #216]
	ldr	w9, [x19]
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	and	w11, w9, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, .LBB560_3
.LBB560_1:                              // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldr	w13, [x12, #44]
	cmp	w13, w9
	b.eq	.LBB560_10
// %bb.2:                               // %B8
                                        //   in Loop: Header=BB560_1 Depth=1
	ldur	w11, [x12, #40]
	and	w11, w11, #0x3ffffff
	cbnz	w11, .LBB560_1
.LBB560_3:                              // %B11
	ldr	x8, [x24, #208]
	mov	w10, #18                        // =0x12
.LBB560_4:                              // %B33
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB560_5 Depth 2
	ldr	x12, [x8, #8]
	ldr	w11, [x12, #12]
	and	w11, w9, w11
	mvn	w11, w11
	ldr	w11, [x12, w11, sxtw #2]
	cbz	w11, .LBB560_7
.LBB560_5:                              // %B22
                                        //   Parent Loop BB560_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w9
	b.eq	.LBB560_9
// %bb.6:                               // %B24
                                        //   in Loop: Header=BB560_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB560_5
.LBB560_7:                              // %B27
                                        //   in Loop: Header=BB560_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	.LBB560_13
// %bb.8:                               // %B30
                                        //   in Loop: Header=BB560_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB560_4
	b	.LBB560_11
.LBB560_9:                              // %B12
	lsr	w9, w13, #26
	tst	w9, #0x30
	b.ne	.LBB560_13
.LBB560_10:                             // %B7.sink.split
	lsl	w9, w11, #1
	ldr	x8, [x8, #16]
	sub	w9, w9, #2
	ldr	x10, [x8, w9, sxtw #3]
.LBB560_11:                             // %B7
	cmp	x10, #34
	b.eq	.LBB560_15
// %bb.12:                              // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x10
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB560_13:                             // %B17
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB560_16
// %bb.14:                              // %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB560_15:                             // %B3
	str	x21, [x20], #8
	b	ThrowReferenceErrorUninitialized_asm_h
.LBB560_16:                             // %B18
	b	exception_spill_top1_asm_h
.Lfunc_end560:
	.size	get_var_undef_2_asm_h, .Lfunc_end560-get_var_undef_2_asm_h
                                        // -- End function
	.hidden	get_var_2_asm_h                 // -- Begin function get_var_2_asm_h
	.globl	get_var_2_asm_h
	.p2align	2
	.type	get_var_2_asm_h,@function
get_var_2_asm_h:                        // @get_var_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	ldr	x8, [x24, #216]
	ldr	w9, [x19]
	ldr	x11, [x8, #8]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB561_3
.LBB561_1:                              // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #44]
	cmp	w13, w9
	b.eq	.LBB561_10
// %bb.2:                               // %B8
                                        //   in Loop: Header=BB561_1 Depth=1
	ldur	w10, [x12, #40]
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB561_1
.LBB561_3:                              // %B11
	ldr	x8, [x24, #208]
.LBB561_4:                              // %B32
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB561_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB561_7
.LBB561_5:                              // %B21
                                        //   Parent Loop BB561_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w9
	b.eq	.LBB561_9
// %bb.6:                               // %B23
                                        //   in Loop: Header=BB561_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB561_5
.LBB561_7:                              // %B26
                                        //   in Loop: Header=BB561_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB561_12
// %bb.8:                               // %B29
                                        //   in Loop: Header=BB561_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB561_4
	b	.LBB561_12
.LBB561_9:                              // %B12
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	.LBB561_12
.LBB561_10:                             // %B7
	lsl	w9, w10, #1
	ldr	x8, [x8, #16]
	sub	w9, w9, #2
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	.LBB561_14
// %bb.11:                              // %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB561_12:                             // %B16
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	.LBB561_15
// %bb.13:                              // %B18
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB561_14:                             // %B3
	str	x21, [x20], #8
	b	ThrowReferenceErrorUninitialized_asm_h
.LBB561_15:                             // %B17
	b	exception_spill_top1_asm_h
.Lfunc_end561:
	.size	get_var_2_asm_h, .Lfunc_end561-get_var_2_asm_h
                                        // -- End function
	.hidden	put_var_2_asm_h                 // -- Begin function put_var_2_asm_h
	.globl	put_var_2_asm_h
	.p2align	2
	.type	put_var_2_asm_h,@function
put_var_2_asm_h:                        // @put_var_2_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB562_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB562_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end562:
	.size	put_var_2_asm_h, .Lfunc_end562-put_var_2_asm_h
                                        // -- End function
	.hidden	put_var_init_2_asm_h            // -- Begin function put_var_init_2_asm_h
	.globl	put_var_init_2_asm_h
	.p2align	2
	.type	put_var_init_2_asm_h,@function
put_var_init_2_asm_h:                   // @put_var_init_2_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB563_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB563_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end563:
	.size	put_var_init_2_asm_h, .Lfunc_end563-put_var_init_2_asm_h
                                        // -- End function
	.hidden	put_var_strict_2_asm_h          // -- Begin function put_var_strict_2_asm_h
	.globl	put_var_strict_2_asm_h
	.p2align	2
	.type	put_var_strict_2_asm_h,@function
put_var_strict_2_asm_h:                 // @put_var_strict_2_asm_h
// %bb.0:                               // %B5
	cmp	x22, #7
	b.ne	.LBB564_3
// %bb.1:                               // %B1
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          // =0x2
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB564_4
// %bb.2:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB564_3:                              // %B6
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB564_4:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end564:
	.size	put_var_strict_2_asm_h, .Lfunc_end564-put_var_strict_2_asm_h
                                        // -- End function
	.hidden	get_ref_value_2_asm_h           // -- Begin function get_ref_value_2_asm_h
	.globl	get_ref_value_2_asm_h
	.p2align	2
	.type	get_ref_value_2_asm_h,@function
get_ref_value_2_asm_h:                  // @get_ref_value_2_asm_h
// %bb.0:                               // %B8
	cmp	x22, #18
	str	x22, [x20]
	mov	x0, x24
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #64]
	b.eq	.LBB565_3
// %bb.1:                               // %B1
	mov	x1, x22
	mov	x2, x21
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB565_5
// %bb.2:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB565_3:                              // %B5
	mov	x1, x21
	bl	js_value_to_atom_gc
	cbz	w0, .LBB565_5
// %bb.4:                               // %B7
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB565_5:                              // %B6
	b	exception_spill_top1_asm_h
.Lfunc_end565:
	.size	get_ref_value_2_asm_h, .Lfunc_end565-get_ref_value_2_asm_h
                                        // -- End function
	.hidden	put_ref_value_2_asm_h           // -- Begin function put_ref_value_2_asm_h
	.globl	put_ref_value_2_asm_h
	.p2align	2
	.type	put_ref_value_2_asm_h,@function
put_ref_value_2_asm_h:                  // @put_ref_value_2_asm_h
// %bb.0:                               // %B12
	sub	sp, sp, #16
	ldur	x1, [x20, #-8]
	cmp	x1, #18
	b.eq	.LBB566_3
.LBB566_1:                              // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_SetPropertyValue_GC
	tbnz	w0, #31, .LBB566_7
// %bb.2:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB566_3:                              // %B8
	ldr	w8, [x23, #60]
	tbnz	w8, #0, .LBB566_5
// %bb.4:                               // %B9
	ldr	x1, [x24, #208]
	b	.LBB566_1
.LBB566_5:                              // %B5
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	stp	x22, x21, [x20]
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	str	x8, [x23, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB566_7
// %bb.6:                               // %B7
	ldr	x8, [sp, #8]                    // 8-byte Folded Reload
	mov	w1, w0
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB566_7:                              // %B2
	add	sp, sp, #16
	b	exception_spill_top0_top1_asm_h
.Lfunc_end566:
	.size	put_ref_value_2_asm_h, .Lfunc_end566-put_ref_value_2_asm_h
                                        // -- End function
	.hidden	define_var_2_asm_h              // -- Begin function define_var_2_asm_h
	.globl	define_var_2_asm_h
	.p2align	2
	.type	define_var_2_asm_h,@function
define_var_2_asm_h:                     // @define_var_2_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_DefineGlobalVar_GC
	tbnz	w0, #31, .LBB567_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB567_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end567:
	.size	define_var_2_asm_h, .Lfunc_end567-define_var_2_asm_h
                                        // -- End function
	.hidden	check_define_var_2_asm_h        // -- Begin function check_define_var_2_asm_h
	.globl	check_define_var_2_asm_h
	.p2align	2
	.type	check_define_var_2_asm_h,@function
check_define_var_2_asm_h:               // @check_define_var_2_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, .LBB568_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB568_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end568:
	.size	check_define_var_2_asm_h, .Lfunc_end568-check_define_var_2_asm_h
                                        // -- End function
	.hidden	define_func_2_asm_h             // -- Begin function define_func_2_asm_h
	.globl	define_func_2_asm_h
	.p2align	2
	.type	define_func_2_asm_h,@function
define_func_2_asm_h:                    // @define_func_2_asm_h
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w3, [x19, #4]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_DefineGlobalFunction_GC
	tbnz	w0, #31, .LBB569_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB569_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end569:
	.size	define_func_2_asm_h, .Lfunc_end569-define_func_2_asm_h
                                        // -- End function
	.hidden	get_field_2_asm_h               // -- Begin function get_field_2_asm_h
	.globl	get_field_2_asm_h
	.p2align	2
	.type	get_field_2_asm_h,@function
get_field_2_asm_h:                      // @get_field_2_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	.LBB570_10
// %bb.1:                               // %B25
	mov	x9, x21
	mov	w8, #18                         // =0x12
.LBB570_2:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB570_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB570_5
.LBB570_3:                              // %B1
                                        //   Parent Loop BB570_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w2
	b.eq	.LBB570_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB570_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB570_3
.LBB570_5:                              // %B14
                                        //   in Loop: Header=BB570_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB570_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB570_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB570_2
	b	.LBB570_9
.LBB570_7:                              // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB570_10
// %bb.8:                               // %B4
	lsl	w8, w10, #1
	ldr	x9, [x9, #16]
	sub	w8, w8, #2
	ldr	x8, [x9, w8, sxtw #3]
.LBB570_9:                              // %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB570_10:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x3, x21
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB570_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB570_12:                             // %B22
	b	exception_spill_top0_top1_asm_h
.Lfunc_end570:
	.size	get_field_2_asm_h, .Lfunc_end570-get_field_2_asm_h
                                        // -- End function
	.hidden	get_field2_2_asm_h              // -- Begin function get_field2_2_asm_h
	.globl	get_field2_2_asm_h
	.p2align	2
	.type	get_field2_2_asm_h,@function
get_field2_2_asm_h:                     // @get_field2_2_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	str	x22, [x20], #8
	movk	x8, #65535, lsl #48
	ldr	w2, [x19]
	tst	x21, x8
	b.ne	.LBB571_10
// %bb.1:                               // %B25
	mov	x9, x21
	mov	w8, #18                         // =0x12
.LBB571_2:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB571_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB571_5
.LBB571_3:                              // %B1
                                        //   Parent Loop BB571_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w2
	b.eq	.LBB571_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB571_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB571_3
.LBB571_5:                              // %B14
                                        //   in Loop: Header=BB571_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB571_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB571_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB571_2
	b	.LBB571_9
.LBB571_7:                              // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB571_10
// %bb.8:                               // %B4
	lsl	w8, w10, #1
	ldr	x9, [x9, #16]
	sub	w8, w8, #2
	ldr	x8, [x9, w8, sxtw #3]
.LBB571_9:                              // %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB571_10:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	mov	x3, x21
	mov	w4, wzr
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB571_12
// %bb.11:                              // %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB571_12:                             // %B22
	b	exception_spill_top1_asm_h
.Lfunc_end571:
	.size	get_field2_2_asm_h, .Lfunc_end571-get_field2_2_asm_h
                                        // -- End function
	.hidden	put_field_2_asm_h               // -- Begin function put_field_2_asm_h
	.globl	put_field_2_asm_h
	.p2align	2
	.type	put_field_2_asm_h,@function
put_field_2_asm_h:                      // @put_field_2_asm_h
// %bb.0:                               // %B44
	mov	x8, #2                          // =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB572_17
// %bb.1:                               // %B45
	ldr	x9, [x22, #8]
	ldr	w8, [x9, #12]
	and	w8, w2, w8
	mvn	w8, w8
	ldr	w8, [x9, w8, sxtw #2]
	cbz	w8, .LBB572_4
.LBB572_2:                              // %B1
                                        // =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10, #40]
	cmp	w11, w2
	b.eq	.LBB572_13
// %bb.3:                               // %B12
                                        //   in Loop: Header=BB572_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, .LBB572_2
.LBB572_4:                              // %B17.preheader
	mov	x8, x22
.LBB572_5:                              // %B17
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB572_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x9, w10, sxtw #2]
	cbz	w10, .LBB572_8
.LBB572_6:                              // %B18
                                        //   Parent Loop BB572_5 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldr	w11, [x10, #44]
	cmp	w11, w2
	b.eq	.LBB572_17
// %bb.7:                               // %B20
                                        //   in Loop: Header=BB572_6 Depth=2
	ldur	w10, [x10, #40]
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB572_6
.LBB572_8:                              // %B30
                                        //   in Loop: Header=BB572_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	.LBB572_17
// %bb.9:                               // %B24
                                        //   in Loop: Header=BB572_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB572_5
// %bb.10:                              // %B27
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	.LBB572_17
// %bb.11:                              // %B34
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	w3, #7                          // =0x7
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	add_property_gc
	cbz	x0, .LBB572_19
// %bb.12:                              // %B38
	str	x21, [x0]
	b	.LBB572_15
.LBB572_13:                             // %B3
	mov	w9, #58                         // =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	.LBB572_17
// %bb.14:                              // %B7
	lsl	w8, w8, #1
	ldr	x9, [x22, #16]
	sub	w8, w8, #2
	str	x21, [x9, w8, sxtw #3]
.LBB572_15:                             // %B38
	ldrb	w8, [x24, #392]
	cbz	w8, .LBB572_18
// %bb.16:                              // %B40
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB572_17:                             // %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_SetPropertyInternalImpl_GC
	tbnz	w0, #31, .LBB572_19
.LBB572_18:                             // %B37
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB572_19:                             // %B35
	b	exception_spill_top0_top1_asm_h
.Lfunc_end572:
	.size	put_field_2_asm_h, .Lfunc_end572-put_field_2_asm_h
                                        // -- End function
	.hidden	get_private_field_2_asm_h       // -- Begin function get_private_field_2_asm_h
	.globl	get_private_field_2_asm_h
	.p2align	2
	.type	get_private_field_2_asm_h,@function
get_private_field_2_asm_h:              // @get_private_field_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	.LBB573_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB573_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end573:
	.size	get_private_field_2_asm_h, .Lfunc_end573-get_private_field_2_asm_h
                                        // -- End function
	.hidden	put_private_field_2_asm_h       // -- Begin function put_private_field_2_asm_h
	.globl	put_private_field_2_asm_h
	.p2align	2
	.type	put_private_field_2_asm_h,@function
put_private_field_2_asm_h:              // @put_private_field_2_asm_h
// %bb.0:                               // %B1
	ldur	x1, [x20, #-8]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	x3, x22
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_SetPrivateField_GC
	tbnz	w0, #31, .LBB574_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB574_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end574:
	.size	put_private_field_2_asm_h, .Lfunc_end574-put_private_field_2_asm_h
                                        // -- End function
	.hidden	define_private_field_2_asm_h    // -- Begin function define_private_field_2_asm_h
	.globl	define_private_field_2_asm_h
	.p2align	2
	.type	define_private_field_2_asm_h,@function
define_private_field_2_asm_h:           // @define_private_field_2_asm_h
// %bb.0:                               // %B1
	ldur	x1, [x20, #-8]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_DefinePrivateField_GC
	tbnz	w0, #31, .LBB575_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB575_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end575:
	.size	define_private_field_2_asm_h, .Lfunc_end575-define_private_field_2_asm_h
                                        // -- End function
	.hidden	get_array_el_2_asm_h            // -- Begin function get_array_el_2_asm_h
	.globl	get_array_el_2_asm_h
	.p2align	2
	.type	get_array_el_2_asm_h,@function
get_array_el_2_asm_h:                   // @get_array_el_2_asm_h
// %bb.0:                               // %B33
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB576_15
// %bb.1:                               // %B33
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x8, x9
	b.ne	.LBB576_15
// %bb.2:                               // %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	.LBB576_15
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	.LBB576_5
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	add	w8, w8, #242
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB576_5:                              // %B7
	tbnz	w21, #31, .LBB576_15
// %bb.6:                               // %B9.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
	orr	w12, w21, #0x80000000
.LBB576_7:                              // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB576_8 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	and	w11, w12, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, .LBB576_10
.LBB576_8:                              // %B10
                                        //   Parent Loop BB576_7 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x10, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w12
	b.eq	.LBB576_12
// %bb.9:                               // %B17
                                        //   in Loop: Header=BB576_8 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB576_8
.LBB576_10:                             // %B24
                                        //   in Loop: Header=BB576_7 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB576_15
// %bb.11:                              // %B21
                                        //   in Loop: Header=BB576_7 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB576_7
	b	.LBB576_14
.LBB576_12:                             // %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	.LBB576_15
// %bb.13:                              // %B13
	lsl	w8, w11, #1
	ldr	x9, [x9, #16]
	sub	w8, w8, #2
	ldr	x8, [x9, w8, sxtw #3]
.LBB576_14:                             // %B14
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB576_15:                             // %B30
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB576_17
// %bb.16:                              // %B32
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB576_17:                             // %B31
	b	exception_spill_top0_top1_asm_h
.Lfunc_end576:
	.size	get_array_el_2_asm_h, .Lfunc_end576-get_array_el_2_asm_h
                                        // -- End function
	.hidden	get_array_el2_2_asm_h           // -- Begin function get_array_el2_2_asm_h
	.globl	get_array_el2_2_asm_h
	.p2align	2
	.type	get_array_el2_2_asm_h,@function
get_array_el2_2_asm_h:                  // @get_array_el2_2_asm_h
// %bb.0:                               // %B33
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB577_15
// %bb.1:                               // %B33
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x8, x9
	b.ne	.LBB577_15
// %bb.2:                               // %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	.LBB577_15
// %bb.3:                               // %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	.LBB577_5
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	add	w8, w8, #484
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB577_5:                              // %B7
	tbnz	w21, #31, .LBB577_15
// %bb.6:                               // %B9.preheader
	mov	x9, x22
	mov	w8, #18                         // =0x12
	orr	w12, w21, #0x80000000
.LBB577_7:                              // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB577_8 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	and	w11, w12, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, .LBB577_10
.LBB577_8:                              // %B10
                                        //   Parent Loop BB577_7 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x10, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w12
	b.eq	.LBB577_12
// %bb.9:                               // %B17
                                        //   in Loop: Header=BB577_8 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB577_8
.LBB577_10:                             // %B24
                                        //   in Loop: Header=BB577_7 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB577_15
// %bb.11:                              // %B21
                                        //   in Loop: Header=BB577_7 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB577_7
	b	.LBB577_14
.LBB577_12:                             // %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	.LBB577_15
// %bb.13:                              // %B13
	lsl	w8, w11, #1
	ldr	x9, [x9, #16]
	sub	w8, w8, #2
	ldr	x8, [x9, w8, sxtw #3]
.LBB577_14:                             // %B14
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB577_15:                             // %B30
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB577_17
// %bb.16:                              // %B32
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB577_17:                             // %B31
	b	exception_spill_top0_top1_asm_h
.Lfunc_end577:
	.size	get_array_el2_2_asm_h, .Lfunc_end577-get_array_el2_2_asm_h
                                        // -- End function
	.hidden	put_array_el_2_asm_h            // -- Begin function put_array_el_2_asm_h
	.globl	put_array_el_2_asm_h
	.p2align	2
	.type	put_array_el_2_asm_h,@function
put_array_el_2_asm_h:                   // @put_array_el_2_asm_h
// %bb.0:                               // %B63
	ldur	x1, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x1, x8
	b.ne	.LBB578_16
// %bb.1:                               // %B57
	ldrsh	w8, [x1, #6]
	cmp	w8, #2
	b.ne	.LBB578_6
// %bb.2:                               // %B1
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB578_16
// %bb.3:                               // %B50
	ldr	w8, [x1, #48]
	cmp	w22, w8
	b.hs	.LBB578_7
// %bb.4:                               // %B3
	ldr	x8, [x1, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #392]
	cbnz	w8, .LBB578_23
.LBB578_5:                              // %B56
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB578_6:                              // %B60
	cmp	w8, #30
	ccmp	w8, #20, #4, lt
	mov	w8, #32768                      // =0x8000
	csel	w4, wzr, w8, gt
	b	.LBB578_17
.LBB578_7:                              // %B8
	b.ne	.LBB578_16
// %bb.8:                               // %B46
	ldr	w9, [x1, #4]
	mov	w4, #32768                      // =0x8000
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	b.ne	.LBB578_17
// %bb.9:                               // %B46
	ubfx	w9, w9, #8, #1
	cbz	w9, .LBB578_17
// %bb.10:                              // %B47
	ldr	x9, [x1, #8]
.LBB578_11:                             // %B15
                                        // =>This Inner Loop Header: Depth=1
	ldr	x10, [x9, #32]
	cbz	x10, .LBB578_19
// %bb.12:                              // %B10
                                        //   in Loop: Header=BB578_11 Depth=1
	ldrh	w11, [x10, #6]
	ldr	x9, [x10, #8]
	cmp	w11, #2
	b.ne	.LBB578_14
// %bb.13:                              // %B12
                                        //   in Loop: Header=BB578_11 Depth=1
	ldr	w10, [x10, #4]
	ubfx	w10, w10, #11, #1
	cmp	w10, #1
	b.eq	.LBB578_11
	b	.LBB578_16
.LBB578_14:                             // %B10
                                        //   in Loop: Header=BB578_11 Depth=1
	cmp	w11, #1
	b.ne	.LBB578_16
// %bb.15:                              // %B42
                                        //   in Loop: Header=BB578_11 Depth=1
	ldrb	w10, [x9, #6]
	cbz	w10, .LBB578_11
.LBB578_16:
	mov	w4, #32768                      // =0x8000
.LBB578_17:                             // %B54
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_SetPropertyValue_GC
	tbz	w0, #31, .LBB578_5
// %bb.18:                              // %B55
	b	exception_spill_top0_top1_asm_h
.LBB578_19:                             // %B33
	ldr	x9, [x1, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      // =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	.LBB578_21
// %bb.20:                              // %B33
	cmp	w9, w10
	b.hi	.LBB578_24
.LBB578_21:                             // %B30
	ldr	w10, [x1, #32]
	cmp	w9, w10
	b.hi	.LBB578_24
// %bb.22:                              // %B26
	ldr	x10, [x1, #40]
	str	w9, [x1, #48]
	str	x21, [x10, w8, sxtw #3]
	ldrb	w8, [x24, #392]
	cbz	w8, .LBB578_5
.LBB578_23:                             // %B29
	mov	x0, x21
	mov	x1, x24
	bl	prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB578_24:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, #32768                      // =0x8000
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	add_fast_array_element_gc
	tbz	w0, #31, .LBB578_5
// %bb.25:                              // %B22
	b	exception_spill_top0_top1_asm_h
.Lfunc_end578:
	.size	put_array_el_2_asm_h, .Lfunc_end578-put_array_el_2_asm_h
                                        // -- End function
	.hidden	get_super_value_2_asm_h         // -- Begin function get_super_value_2_asm_h
	.globl	get_super_value_2_asm_h
	.p2align	2
	.type	get_super_value_2_asm_h,@function
get_super_value_2_asm_h:                // @get_super_value_2_asm_h
// %bb.0:                               // %B1
	sub	sp, sp, #16
	str	x19, [sp, #8]                   // 8-byte Folded Spill
	add	x19, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x19, [x23, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB579_3
// %bb.1:                               // %B5
	ldur	x3, [x20, #-8]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x19, [x23, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB579_3
// %bb.2:                               // %B7
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
.LBB579_3:                              // %B2
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	add	sp, sp, #16
	b	exception_spill_top0_top1_asm_h
.Lfunc_end579:
	.size	get_super_value_2_asm_h, .Lfunc_end579-get_super_value_2_asm_h
                                        // -- End function
	.hidden	put_super_value_2_asm_h         // -- Begin function put_super_value_2_asm_h
	.globl	put_super_value_2_asm_h
	.p2align	2
	.type	put_super_value_2_asm_h,@function
put_super_value_2_asm_h:                // @put_super_value_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	put_super_value_0_asm_h
.Lfunc_end580:
	.size	put_super_value_2_asm_h, .Lfunc_end580-put_super_value_2_asm_h
                                        // -- End function
	.hidden	define_field_2_asm_h            // -- Begin function define_field_2_asm_h
	.globl	define_field_2_asm_h
	.p2align	2
	.type	define_field_2_asm_h,@function
define_field_2_asm_h:                   // @define_field_2_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #16391                      // =0x4007
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	LEPUS_DefinePropertyValue
	tbnz	w0, #31, .LBB581_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB581_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end581:
	.size	define_field_2_asm_h, .Lfunc_end581-define_field_2_asm_h
                                        // -- End function
	.hidden	set_name_2_asm_h                // -- Begin function set_name_2_asm_h
	.globl	set_name_2_asm_h
	.p2align	2
	.type	set_name_2_asm_h,@function
set_name_2_asm_h:                       // @set_name_2_asm_h
// %bb.0:                               // %B1
	ldr	w2, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_DefineObjectName
	tbnz	w0, #31, .LBB582_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB582_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end582:
	.size	set_name_2_asm_h, .Lfunc_end582-set_name_2_asm_h
                                        // -- End function
	.hidden	set_name_computed_2_asm_h       // -- Begin function set_name_computed_2_asm_h
	.globl	set_name_computed_2_asm_h
	.p2align	2
	.type	set_name_computed_2_asm_h,@function
set_name_computed_2_asm_h:              // @set_name_computed_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x2, x22
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, .LBB583_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB583_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end583:
	.size	set_name_computed_2_asm_h, .Lfunc_end583-set_name_computed_2_asm_h
                                        // -- End function
	.hidden	set_proto_2_asm_h               // -- Begin function set_proto_2_asm_h
	.globl	set_proto_2_asm_h
	.p2align	2
	.type	set_proto_2_asm_h,@function
set_proto_2_asm_h:                      // @set_proto_2_asm_h
// %bb.0:                               // %B6
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB584_3
// %bb.1:                               // %B6
	cmp	x21, #2
	b.eq	.LBB584_3
.LBB584_2:                              // %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB584_3:                              // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_SetPrototypeInternal_GC
	tbz	w0, #31, .LBB584_2
// %bb.4:                               // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end584:
	.size	set_proto_2_asm_h, .Lfunc_end584-set_proto_2_asm_h
                                        // -- End function
	.hidden	set_home_object_2_asm_h         // -- Begin function set_home_object_2_asm_h
	.globl	set_home_object_2_asm_h
	.p2align	2
	.type	set_home_object_2_asm_h,@function
set_home_object_2_asm_h:                // @set_home_object_2_asm_h
// %bb.0:                               // %B0
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x2, x22
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	js_method_set_home_object_gc
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end585:
	.size	set_home_object_2_asm_h, .Lfunc_end585-set_home_object_2_asm_h
                                        // -- End function
	.hidden	define_array_el_2_asm_h         // -- Begin function define_array_el_2_asm_h
	.globl	define_array_el_2_asm_h
	.p2align	2
	.type	define_array_el_2_asm_h,@function
define_array_el_2_asm_h:                // @define_array_el_2_asm_h
// %bb.0:                               // %B1
	ldur	x1, [x20, #-8]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #16391                      // =0x4007
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, .LBB586_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB586_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end586:
	.size	define_array_el_2_asm_h, .Lfunc_end586-define_array_el_2_asm_h
                                        // -- End function
	.hidden	append_2_asm_h                  // -- Begin function append_2_asm_h
	.globl	append_2_asm_h
	.p2align	2
	.type	append_2_asm_h,@function
append_2_asm_h:                         // @append_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	append_0_asm_h
.Lfunc_end587:
	.size	append_2_asm_h, .Lfunc_end587-append_2_asm_h
                                        // -- End function
	.hidden	copy_data_properties_2_asm_h    // -- Begin function copy_data_properties_2_asm_h
	.globl	copy_data_properties_2_asm_h
	.p2align	2
	.type	copy_data_properties_2_asm_h,@function
copy_data_properties_2_asm_h:           // @copy_data_properties_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	copy_data_properties_0_asm_h
.Lfunc_end588:
	.size	copy_data_properties_2_asm_h, .Lfunc_end588-copy_data_properties_2_asm_h
                                        // -- End function
	.hidden	define_method_2_asm_h           // -- Begin function define_method_2_asm_h
	.globl	define_method_2_asm_h
	.p2align	2
	.type	define_method_2_asm_h,@function
define_method_2_asm_h:                  // @define_method_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	define_method_0_asm_h
.Lfunc_end589:
	.size	define_method_2_asm_h, .Lfunc_end589-define_method_2_asm_h
                                        // -- End function
	.hidden	define_method_computed_2_asm_h  // -- Begin function define_method_computed_2_asm_h
	.globl	define_method_computed_2_asm_h
	.p2align	2
	.type	define_method_computed_2_asm_h,@function
define_method_computed_2_asm_h:         // @define_method_computed_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	define_method_computed_0_asm_h
.Lfunc_end590:
	.size	define_method_computed_2_asm_h, .Lfunc_end590-define_method_computed_2_asm_h
                                        // -- End function
	.hidden	define_class_2_asm_h            // -- Begin function define_class_2_asm_h
	.globl	define_class_2_asm_h
	.p2align	2
	.type	define_class_2_asm_h,@function
define_class_2_asm_h:                   // @define_class_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	define_class_0_asm_h
.Lfunc_end591:
	.size	define_class_2_asm_h, .Lfunc_end591-define_class_2_asm_h
                                        // -- End function
	.hidden	get_loc_2_asm_h                 // -- Begin function get_loc_2_asm_h
	.globl	get_loc_2_asm_h
	.p2align	2
	.type	get_loc_2_asm_h,@function
get_loc_2_asm_h:                        // @get_loc_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #484
	ldr	x9, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x9
	br	x1
.Lfunc_end592:
	.size	get_loc_2_asm_h, .Lfunc_end592-get_loc_2_asm_h
                                        // -- End function
	.hidden	put_loc_2_asm_h                 // -- Begin function put_loc_2_asm_h
	.globl	put_loc_2_asm_h
	.p2align	2
	.type	put_loc_2_asm_h,@function
put_loc_2_asm_h:                        // @put_loc_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end593:
	.size	put_loc_2_asm_h, .Lfunc_end593-put_loc_2_asm_h
                                        // -- End function
	.hidden	set_loc_2_asm_h                 // -- Begin function set_loc_2_asm_h
	.globl	set_loc_2_asm_h
	.p2align	2
	.type	set_loc_2_asm_h,@function
set_loc_2_asm_h:                        // @set_loc_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end594:
	.size	set_loc_2_asm_h, .Lfunc_end594-set_loc_2_asm_h
                                        // -- End function
	.hidden	get_arg_2_asm_h                 // -- Begin function get_arg_2_asm_h
	.globl	get_arg_2_asm_h
	.p2align	2
	.type	get_arg_2_asm_h,@function
get_arg_2_asm_h:                        // @get_arg_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #484
	ldr	x9, [x28, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x9
	br	x1
.Lfunc_end595:
	.size	get_arg_2_asm_h, .Lfunc_end595-get_arg_2_asm_h
                                        // -- End function
	.hidden	put_arg_2_asm_h                 // -- Begin function put_arg_2_asm_h
	.globl	put_arg_2_asm_h
	.p2align	2
	.type	put_arg_2_asm_h,@function
put_arg_2_asm_h:                        // @put_arg_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x21, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end596:
	.size	put_arg_2_asm_h, .Lfunc_end596-put_arg_2_asm_h
                                        // -- End function
	.hidden	set_arg_2_asm_h                 // -- Begin function set_arg_2_asm_h
	.globl	set_arg_2_asm_h
	.p2align	2
	.type	set_arg_2_asm_h,@function
set_arg_2_asm_h:                        // @set_arg_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	str	x21, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end597:
	.size	set_arg_2_asm_h, .Lfunc_end597-set_arg_2_asm_h
                                        // -- End function
	.hidden	get_var_ref_2_asm_h             // -- Begin function get_var_ref_2_asm_h
	.globl	get_var_ref_2_asm_h
	.p2align	2
	.type	get_var_ref_2_asm_h,@function
get_var_ref_2_asm_h:                    // @get_var_ref_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrh	w8, [x19]
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x8, [x26, x8, lsl #3]
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8, #32]
	ldr	x8, [x8]
	mov	x21, x8
	br	x1
.Lfunc_end598:
	.size	get_var_ref_2_asm_h, .Lfunc_end598-get_var_ref_2_asm_h
                                        // -- End function
	.hidden	put_var_ref_2_asm_h             // -- Begin function put_var_ref_2_asm_h
	.globl	put_var_ref_2_asm_h
	.p2align	2
	.type	put_var_ref_2_asm_h,@function
put_var_ref_2_asm_h:                    // @put_var_ref_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end599:
	.size	put_var_ref_2_asm_h, .Lfunc_end599-put_var_ref_2_asm_h
                                        // -- End function
	.hidden	set_var_ref_2_asm_h             // -- Begin function set_var_ref_2_asm_h
	.globl	set_var_ref_2_asm_h
	.p2align	2
	.type	set_var_ref_2_asm_h,@function
set_var_ref_2_asm_h:                    // @set_var_ref_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end600:
	.size	set_var_ref_2_asm_h, .Lfunc_end600-set_var_ref_2_asm_h
                                        // -- End function
	.hidden	set_loc_uninitialized_2_asm_h   // -- Begin function set_loc_uninitialized_2_asm_h
	.globl	set_loc_uninitialized_2_asm_h
	.p2align	2
	.type	set_loc_uninitialized_2_asm_h,@function
set_loc_uninitialized_2_asm_h:          // @set_loc_uninitialized_2_asm_h
// %bb.0:                               // %B0
	ldrh	w8, [x19]
	mov	w9, #34                         // =0x22
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end601:
	.size	set_loc_uninitialized_2_asm_h, .Lfunc_end601-set_loc_uninitialized_2_asm_h
                                        // -- End function
	.hidden	get_loc_check_2_asm_h           // -- Begin function get_loc_check_2_asm_h
	.globl	get_loc_check_2_asm_h
	.p2align	2
	.type	get_loc_check_2_asm_h,@function
get_loc_check_2_asm_h:                  // @get_loc_check_2_asm_h
// %bb.0:                               // %B2
	str	x22, [x20], #8
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	.LBB602_2
// %bb.1:                               // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB602_2:                              // %B3
	str	x21, [x20], #8
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end602:
	.size	get_loc_check_2_asm_h, .Lfunc_end602-get_loc_check_2_asm_h
                                        // -- End function
	.hidden	put_loc_check_2_asm_h           // -- Begin function put_loc_check_2_asm_h
	.globl	put_loc_check_2_asm_h
	.p2align	2
	.type	put_loc_check_2_asm_h,@function
put_loc_check_2_asm_h:                  // @put_loc_check_2_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	.LBB603_2
// %bb.1:                               // %B4
	str	x21, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB603_2:                              // %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end603:
	.size	put_loc_check_2_asm_h, .Lfunc_end603-put_loc_check_2_asm_h
                                        // -- End function
	.hidden	put_loc_check_init_2_asm_h      // -- Begin function put_loc_check_init_2_asm_h
	.globl	put_loc_check_init_2_asm_h
	.p2align	2
	.type	put_loc_check_init_2_asm_h,@function
put_loc_check_init_2_asm_h:             // @put_loc_check_init_2_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	.LBB604_2
// %bb.1:                               // %B4
	str	x21, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB604_2:                              // %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	ThrowThisReferenceError_asm_h
.Lfunc_end604:
	.size	put_loc_check_init_2_asm_h, .Lfunc_end604-put_loc_check_init_2_asm_h
                                        // -- End function
	.hidden	get_var_ref_check_2_asm_h       // -- Begin function get_var_ref_check_2_asm_h
	.globl	get_var_ref_check_2_asm_h
	.p2align	2
	.type	get_var_ref_check_2_asm_h,@function
get_var_ref_check_2_asm_h:              // @get_var_ref_check_2_asm_h
// %bb.0:                               // %B2
	str	x22, [x20], #8
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB605_2
// %bb.1:                               // %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB605_2:                              // %B3
	str	x21, [x20], #8
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end605:
	.size	get_var_ref_check_2_asm_h, .Lfunc_end605-get_var_ref_check_2_asm_h
                                        // -- End function
	.hidden	put_var_ref_check_2_asm_h       // -- Begin function put_var_ref_check_2_asm_h
	.globl	put_var_ref_check_2_asm_h
	.p2align	2
	.type	put_var_ref_check_2_asm_h,@function
put_var_ref_check_2_asm_h:              // @put_var_ref_check_2_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	.LBB606_2
// %bb.1:                               // %B4
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB606_2:                              // %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end606:
	.size	put_var_ref_check_2_asm_h, .Lfunc_end606-put_var_ref_check_2_asm_h
                                        // -- End function
	.hidden	put_var_ref_check_init_2_asm_h  // -- Begin function put_var_ref_check_init_2_asm_h
	.globl	put_var_ref_check_init_2_asm_h
	.p2align	2
	.type	put_var_ref_check_init_2_asm_h,@function
put_var_ref_check_init_2_asm_h:         // @put_var_ref_check_init_2_asm_h
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	.LBB607_2
// %bb.1:                               // %B4
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB607_2:                              // %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end607:
	.size	put_var_ref_check_init_2_asm_h, .Lfunc_end607-put_var_ref_check_init_2_asm_h
                                        // -- End function
	.hidden	close_loc_2_asm_h               // -- Begin function close_loc_2_asm_h
	.globl	close_loc_2_asm_h
	.p2align	2
	.type	close_loc_2_asm_h,@function
close_loc_2_asm_h:                      // @close_loc_2_asm_h
// %bb.0:                               // %B0
	ldrh	w2, [x19]
	mov	x0, x24
	mov	x1, x23
	bl	close_lexical_var
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end608:
	.size	close_loc_2_asm_h, .Lfunc_end608-close_loc_2_asm_h
                                        // -- End function
	.hidden	if_false_2_asm_h                // -- Begin function if_false_2_asm_h
	.globl	if_false_2_asm_h
	.p2align	2
	.type	if_false_2_asm_h,@function
if_false_2_asm_h:                       // @if_false_2_asm_h
// %bb.0:                               // %B23
	cmp	x21, #5
	b.le	.LBB609_4
// %bb.1:                               // %B23
	cmp	x21, #6
	b.eq	.LBB609_6
// %bb.2:                               // %B23
	cmp	x21, #7
	b.eq	.LBB609_9
// %bb.3:                               // %B23
	cmp	x21, #18
	b.eq	.LBB609_6
	b	.LBB609_7
.LBB609_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB609_6
// %bb.5:                               // %B23
	cmp	x21, #2
	b.ne	.LBB609_7
.LBB609_6:                              // %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB609_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x21, x8
	b.hs	.LBB609_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB609_10
.LBB609_9:                              // %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB609_10:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB609_13
// %bb.11:                              // %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB609_6
	b.vs	.LBB609_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB609_9
	b	.LBB609_6
.LBB609_13:                             // %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	SlowToBoolean_asm_h
.Lfunc_end609:
	.size	if_false_2_asm_h, .Lfunc_end609-if_false_2_asm_h
                                        // -- End function
	.hidden	if_true_2_asm_h                 // -- Begin function if_true_2_asm_h
	.globl	if_true_2_asm_h
	.p2align	2
	.type	if_true_2_asm_h,@function
if_true_2_asm_h:                        // @if_true_2_asm_h
// %bb.0:                               // %B23
	cmp	x21, #5
	b.le	.LBB610_4
// %bb.1:                               // %B23
	cmp	x21, #6
	b.eq	.LBB610_6
// %bb.2:                               // %B23
	cmp	x21, #7
	b.eq	.LBB610_9
// %bb.3:                               // %B23
	cmp	x21, #18
	b.eq	.LBB610_6
	b	.LBB610_7
.LBB610_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB610_6
// %bb.5:                               // %B23
	cmp	x21, #2
	b.ne	.LBB610_7
.LBB610_6:                              // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB610_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x21, x8
	b.hs	.LBB610_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB610_10
.LBB610_9:                              // %B19
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB610_10:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB610_13
// %bb.11:                              // %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB610_6
	b.vs	.LBB610_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB610_9
	b	.LBB610_6
.LBB610_13:                             // %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	SlowToBoolean_asm_h
.Lfunc_end610:
	.size	if_true_2_asm_h, .Lfunc_end610-if_true_2_asm_h
                                        // -- End function
	.hidden	goto_2_asm_h                    // -- Begin function goto_2_asm_h
	.globl	goto_2_asm_h
	.p2align	2
	.type	goto_2_asm_h,@function
goto_2_asm_h:                           // @goto_2_asm_h
// %bb.0:                               // %B0
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end611:
	.size	goto_2_asm_h, .Lfunc_end611-goto_2_asm_h
                                        // -- End function
	.hidden	catch_2_asm_h                   // -- Begin function catch_2_asm_h
	.globl	catch_2_asm_h
	.p2align	2
	.type	catch_2_asm_h,@function
catch_2_asm_h:                          // @catch_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	w8, #66                         // =0x42
	ldr	x9, [x23, #8]
	ldrb	w10, [x19, #4]
	ldr	w11, [x19]
	mov	x22, x21
	ldr	x9, [x9, #32]
	add	w10, w10, #484
	ldr	x1, [x25, w10, uxtw #3]
	ldr	x9, [x9, #8]
	sub	x9, x19, x9
	add	x19, x19, #5
	add	x9, x9, x11
	orr	x21, x8, x9, lsl #16
	br	x1
.Lfunc_end612:
	.size	catch_2_asm_h, .Lfunc_end612-catch_2_asm_h
                                        // -- End function
	.hidden	gosub_2_asm_h                   // -- Begin function gosub_2_asm_h
	.globl	gosub_2_asm_h
	.p2align	2
	.type	gosub_2_asm_h,@function
gosub_2_asm_h:                          // @gosub_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrsw	x8, [x19]
	ldr	x9, [x23, #8]
	ldr	x9, [x9, #32]
	add	x8, x19, x8
	ldrb	w10, [x8], #1
	ldr	w9, [x9, #8]
	add	w10, w10, #484
	sub	w9, w19, w9
	ldr	x1, [x25, w10, uxtw #3]
	mov	x19, x8
	add	w9, w9, #4
	orr	x21, x9, #0xfffe000000000000
	br	x1
.Lfunc_end613:
	.size	gosub_2_asm_h, .Lfunc_end613-gosub_2_asm_h
                                        // -- End function
	.hidden	ret_2_asm_h                     // -- Begin function ret_2_asm_h
	.globl	ret_2_asm_h
	.p2align	2
	.type	ret_2_asm_h,@function
ret_2_asm_h:                            // @ret_2_asm_h
// %bb.0:                               // %B6
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB614_3
// %bb.1:                               // %B1
	ldr	x8, [x23, #8]
	ldr	x8, [x8, #32]
	ldr	w9, [x8, #16]
	cmp	w21, w9
	b.ge	.LBB614_3
// %bb.2:                               // %B5
	ldr	x8, [x8, #8]
	add	x19, x8, w21, sxtw
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB614_3:                              // %B3
	add	x8, x20, #16
	adrp	x1, .L__unnamed_19
	add	x1, x1, :lo12:.L__unnamed_19
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	LEPUS_ThrowInternalError
	b	exception_spill_top0_top1_asm_h
.Lfunc_end614:
	.size	ret_2_asm_h, .Lfunc_end614-ret_2_asm_h
                                        // -- End function
	.hidden	to_object_2_asm_h               // -- Begin function to_object_2_asm_h
	.globl	to_object_2_asm_h
	.p2align	2
	.type	to_object_2_asm_h,@function
to_object_2_asm_h:                      // @to_object_2_asm_h
// %bb.0:                               // %B6
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	.LBB615_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB615_2:                              // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB615_4
// %bb.3:                               // %B3
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB615_4:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end615:
	.size	to_object_2_asm_h, .Lfunc_end615-to_object_2_asm_h
                                        // -- End function
	.hidden	to_propkey_2_asm_h              // -- Begin function to_propkey_2_asm_h
	.globl	to_propkey_2_asm_h
	.p2align	2
	.type	to_propkey_2_asm_h,@function
to_propkey_2_asm_h:                     // @to_propkey_2_asm_h
// %bb.0:                               // %B15
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB616_4
// %bb.1:                               // %B15
	mov	x9, #1                          // =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	.LBB616_4
// %bb.2:                               // %B15
	cmp	x8, x9
	b.eq	.LBB616_4
// %bb.3:                               // %B15
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB616_5
.LBB616_4:                              // %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB616_5:                              // %B12
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB616_7
// %bb.6:                               // %B14
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB616_7:                              // %B13
	b	exception_spill_top0_top1_asm_h
.Lfunc_end616:
	.size	to_propkey_2_asm_h, .Lfunc_end616-to_propkey_2_asm_h
                                        // -- End function
	.hidden	to_propkey2_2_asm_h             // -- Begin function to_propkey2_2_asm_h
	.globl	to_propkey2_2_asm_h
	.p2align	2
	.type	to_propkey2_2_asm_h,@function
to_propkey2_2_asm_h:                    // @to_propkey2_2_asm_h
// %bb.0:                               // %B18
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	.LBB617_3
// %bb.1:                               // %B19
	add	x8, x20, #16
	adrp	x1, .L__unnamed_20
	add	x1, x1, :lo12:.L__unnamed_20
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	LEPUS_ThrowTypeError
.LBB617_2:                              // %B16
	b	exception_spill_top0_top1_asm_h
.LBB617_3:                              // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB617_7
// %bb.4:                               // %B2
	mov	x9, #1                          // =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	.LBB617_7
// %bb.5:                               // %B2
	cmp	x8, x9
	b.eq	.LBB617_7
// %bb.6:                               // %B2
	mov	x9, #-281474976710653           // =0xffff000000000003
	cmp	x8, x9
	b.ne	.LBB617_8
.LBB617_7:                              // %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB617_8:                              // %B15
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB617_2
// %bb.9:                               // %B17
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end617:
	.size	to_propkey2_2_asm_h, .Lfunc_end617-to_propkey2_2_asm_h
                                        // -- End function
	.hidden	with_get_var_2_asm_h            // -- Begin function with_get_var_2_asm_h
	.globl	with_get_var_2_asm_h
	.p2align	2
	.type	with_get_var_2_asm_h,@function
with_get_var_2_asm_h:                   // @with_get_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	with_get_var_0_asm_h
.Lfunc_end618:
	.size	with_get_var_2_asm_h, .Lfunc_end618-with_get_var_2_asm_h
                                        // -- End function
	.hidden	with_put_var_2_asm_h            // -- Begin function with_put_var_2_asm_h
	.globl	with_put_var_2_asm_h
	.p2align	2
	.type	with_put_var_2_asm_h,@function
with_put_var_2_asm_h:                   // @with_put_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	with_put_var_0_asm_h
.Lfunc_end619:
	.size	with_put_var_2_asm_h, .Lfunc_end619-with_put_var_2_asm_h
                                        // -- End function
	.hidden	with_delete_var_2_asm_h         // -- Begin function with_delete_var_2_asm_h
	.globl	with_delete_var_2_asm_h
	.p2align	2
	.type	with_delete_var_2_asm_h,@function
with_delete_var_2_asm_h:                // @with_delete_var_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	with_delete_var_0_asm_h
.Lfunc_end620:
	.size	with_delete_var_2_asm_h, .Lfunc_end620-with_delete_var_2_asm_h
                                        // -- End function
	.hidden	with_make_ref_2_asm_h           // -- Begin function with_make_ref_2_asm_h
	.globl	with_make_ref_2_asm_h
	.p2align	2
	.type	with_make_ref_2_asm_h,@function
with_make_ref_2_asm_h:                  // @with_make_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	with_make_ref_0_asm_h
.Lfunc_end621:
	.size	with_make_ref_2_asm_h, .Lfunc_end621-with_make_ref_2_asm_h
                                        // -- End function
	.hidden	with_get_ref_2_asm_h            // -- Begin function with_get_ref_2_asm_h
	.globl	with_get_ref_2_asm_h
	.p2align	2
	.type	with_get_ref_2_asm_h,@function
with_get_ref_2_asm_h:                   // @with_get_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	with_get_ref_0_asm_h
.Lfunc_end622:
	.size	with_get_ref_2_asm_h, .Lfunc_end622-with_get_ref_2_asm_h
                                        // -- End function
	.hidden	with_get_ref_undef_2_asm_h      // -- Begin function with_get_ref_undef_2_asm_h
	.globl	with_get_ref_undef_2_asm_h
	.p2align	2
	.type	with_get_ref_undef_2_asm_h,@function
with_get_ref_undef_2_asm_h:             // @with_get_ref_undef_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	with_get_ref_undef_0_asm_h
.Lfunc_end623:
	.size	with_get_ref_undef_2_asm_h, .Lfunc_end623-with_get_ref_undef_2_asm_h
                                        // -- End function
	.hidden	make_loc_ref_2_asm_h            // -- Begin function make_loc_ref_2_asm_h
	.globl	make_loc_ref_2_asm_h
	.p2align	2
	.type	make_loc_ref_2_asm_h,@function
make_loc_ref_2_asm_h:                   // @make_loc_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	make_loc_ref_0_asm_h
.Lfunc_end624:
	.size	make_loc_ref_2_asm_h, .Lfunc_end624-make_loc_ref_2_asm_h
                                        // -- End function
	.hidden	make_arg_ref_2_asm_h            // -- Begin function make_arg_ref_2_asm_h
	.globl	make_arg_ref_2_asm_h
	.p2align	2
	.type	make_arg_ref_2_asm_h,@function
make_arg_ref_2_asm_h:                   // @make_arg_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	make_arg_ref_0_asm_h
.Lfunc_end625:
	.size	make_arg_ref_2_asm_h, .Lfunc_end625-make_arg_ref_2_asm_h
                                        // -- End function
	.hidden	make_var_ref_ref_2_asm_h        // -- Begin function make_var_ref_ref_2_asm_h
	.globl	make_var_ref_ref_2_asm_h
	.p2align	2
	.type	make_var_ref_ref_2_asm_h,@function
make_var_ref_ref_2_asm_h:               // @make_var_ref_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	make_var_ref_ref_0_asm_h
.Lfunc_end626:
	.size	make_var_ref_ref_2_asm_h, .Lfunc_end626-make_var_ref_ref_2_asm_h
                                        // -- End function
	.hidden	make_var_ref_2_asm_h            // -- Begin function make_var_ref_2_asm_h
	.globl	make_var_ref_2_asm_h
	.p2align	2
	.type	make_var_ref_2_asm_h,@function
make_var_ref_2_asm_h:                   // @make_var_ref_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	make_var_ref_0_asm_h
.Lfunc_end627:
	.size	make_var_ref_2_asm_h, .Lfunc_end627-make_var_ref_2_asm_h
                                        // -- End function
	.hidden	for_in_start_2_asm_h            // -- Begin function for_in_start_2_asm_h
	.globl	for_in_start_2_asm_h
	.p2align	2
	.type	for_in_start_2_asm_h,@function
for_in_start_2_asm_h:                   // @for_in_start_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	.LBB628_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB628_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end628:
	.size	for_in_start_2_asm_h, .Lfunc_end628-for_in_start_2_asm_h
                                        // -- End function
	.hidden	for_of_start_2_asm_h            // -- Begin function for_of_start_2_asm_h
	.globl	for_of_start_2_asm_h
	.p2align	2
	.type	for_of_start_2_asm_h,@function
for_of_start_2_asm_h:                   // @for_of_start_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	for_of_start_0_asm_h
.Lfunc_end629:
	.size	for_of_start_2_asm_h, .Lfunc_end629-for_of_start_2_asm_h
                                        // -- End function
	.hidden	for_await_of_start_2_asm_h      // -- Begin function for_await_of_start_2_asm_h
	.globl	for_await_of_start_2_asm_h
	.p2align	2
	.type	for_await_of_start_2_asm_h,@function
for_await_of_start_2_asm_h:             // @for_await_of_start_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	for_await_of_start_0_asm_h
.Lfunc_end630:
	.size	for_await_of_start_2_asm_h, .Lfunc_end630-for_await_of_start_2_asm_h
                                        // -- End function
	.hidden	for_in_next_2_asm_h             // -- Begin function for_in_next_2_asm_h
	.globl	for_in_next_2_asm_h
	.p2align	2
	.type	for_in_next_2_asm_h,@function
for_in_next_2_asm_h:                    // @for_in_next_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	for_in_next_0_asm_h
.Lfunc_end631:
	.size	for_in_next_2_asm_h, .Lfunc_end631-for_in_next_2_asm_h
                                        // -- End function
	.hidden	for_of_next_2_asm_h             // -- Begin function for_of_next_2_asm_h
	.globl	for_of_next_2_asm_h
	.p2align	2
	.type	for_of_next_2_asm_h,@function
for_of_next_2_asm_h:                    // @for_of_next_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	for_of_next_0_asm_h
.Lfunc_end632:
	.size	for_of_next_2_asm_h, .Lfunc_end632-for_of_next_2_asm_h
                                        // -- End function
	.hidden	for_await_of_next_2_asm_h       // -- Begin function for_await_of_next_2_asm_h
	.globl	for_await_of_next_2_asm_h
	.p2align	2
	.type	for_await_of_next_2_asm_h,@function
for_await_of_next_2_asm_h:              // @for_await_of_next_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	for_await_of_next_0_asm_h
.Lfunc_end633:
	.size	for_await_of_next_2_asm_h, .Lfunc_end633-for_await_of_next_2_asm_h
                                        // -- End function
	.hidden	iterator_get_value_done_2_asm_h // -- Begin function iterator_get_value_done_2_asm_h
	.globl	iterator_get_value_done_2_asm_h
	.p2align	2
	.type	iterator_get_value_done_2_asm_h,@function
iterator_get_value_done_2_asm_h:        // @iterator_get_value_done_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	iterator_get_value_done_0_asm_h
.Lfunc_end634:
	.size	iterator_get_value_done_2_asm_h, .Lfunc_end634-iterator_get_value_done_2_asm_h
                                        // -- End function
	.hidden	iterator_close_2_asm_h          // -- Begin function iterator_close_2_asm_h
	.globl	iterator_close_2_asm_h
	.p2align	2
	.type	iterator_close_2_asm_h,@function
iterator_close_2_asm_h:                 // @iterator_close_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	iterator_close_0_asm_h
.Lfunc_end635:
	.size	iterator_close_2_asm_h, .Lfunc_end635-iterator_close_2_asm_h
                                        // -- End function
	.hidden	iterator_close_return_2_asm_h   // -- Begin function iterator_close_return_2_asm_h
	.globl	iterator_close_return_2_asm_h
	.p2align	2
	.type	iterator_close_return_2_asm_h,@function
iterator_close_return_2_asm_h:          // @iterator_close_return_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	iterator_close_return_0_asm_h
.Lfunc_end636:
	.size	iterator_close_return_2_asm_h, .Lfunc_end636-iterator_close_return_2_asm_h
                                        // -- End function
	.hidden	async_iterator_close_2_asm_h    // -- Begin function async_iterator_close_2_asm_h
	.globl	async_iterator_close_2_asm_h
	.p2align	2
	.type	async_iterator_close_2_asm_h,@function
async_iterator_close_2_asm_h:           // @async_iterator_close_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	async_iterator_close_0_asm_h
.Lfunc_end637:
	.size	async_iterator_close_2_asm_h, .Lfunc_end637-async_iterator_close_2_asm_h
                                        // -- End function
	.hidden	async_iterator_next_2_asm_h     // -- Begin function async_iterator_next_2_asm_h
	.globl	async_iterator_next_2_asm_h
	.p2align	2
	.type	async_iterator_next_2_asm_h,@function
async_iterator_next_2_asm_h:            // @async_iterator_next_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	async_iterator_next_0_asm_h
.Lfunc_end638:
	.size	async_iterator_next_2_asm_h, .Lfunc_end638-async_iterator_next_2_asm_h
                                        // -- End function
	.hidden	async_iterator_get_2_asm_h      // -- Begin function async_iterator_get_2_asm_h
	.globl	async_iterator_get_2_asm_h
	.p2align	2
	.type	async_iterator_get_2_asm_h,@function
async_iterator_get_2_asm_h:             // @async_iterator_get_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	async_iterator_get_0_asm_h
.Lfunc_end639:
	.size	async_iterator_get_2_asm_h, .Lfunc_end639-async_iterator_get_2_asm_h
                                        // -- End function
	.hidden	initial_yield_2_asm_h           // -- Begin function initial_yield_2_asm_h
	.globl	initial_yield_2_asm_h
	.p2align	2
	.type	initial_yield_2_asm_h,@function
initial_yield_2_asm_h:                  // @initial_yield_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	initial_yield_0_asm_h
.Lfunc_end640:
	.size	initial_yield_2_asm_h, .Lfunc_end640-initial_yield_2_asm_h
                                        // -- End function
	.hidden	yield_2_asm_h                   // -- Begin function yield_2_asm_h
	.globl	yield_2_asm_h
	.p2align	2
	.type	yield_2_asm_h,@function
yield_2_asm_h:                          // @yield_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	yield_0_asm_h
.Lfunc_end641:
	.size	yield_2_asm_h, .Lfunc_end641-yield_2_asm_h
                                        // -- End function
	.hidden	yield_star_2_asm_h              // -- Begin function yield_star_2_asm_h
	.globl	yield_star_2_asm_h
	.p2align	2
	.type	yield_star_2_asm_h,@function
yield_star_2_asm_h:                     // @yield_star_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	yield_star_0_asm_h
.Lfunc_end642:
	.size	yield_star_2_asm_h, .Lfunc_end642-yield_star_2_asm_h
                                        // -- End function
	.hidden	async_yield_star_2_asm_h        // -- Begin function async_yield_star_2_asm_h
	.globl	async_yield_star_2_asm_h
	.p2align	2
	.type	async_yield_star_2_asm_h,@function
async_yield_star_2_asm_h:               // @async_yield_star_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	async_yield_star_0_asm_h
.Lfunc_end643:
	.size	async_yield_star_2_asm_h, .Lfunc_end643-async_yield_star_2_asm_h
                                        // -- End function
	.hidden	await_2_asm_h                   // -- Begin function await_2_asm_h
	.globl	await_2_asm_h
	.p2align	2
	.type	await_2_asm_h,@function
await_2_asm_h:                          // @await_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	await_0_asm_h
.Lfunc_end644:
	.size	await_2_asm_h, .Lfunc_end644-await_2_asm_h
                                        // -- End function
	.hidden	neg_2_asm_h                     // -- Begin function neg_2_asm_h
	.globl	neg_2_asm_h
	.p2align	2
	.type	neg_2_asm_h,@function
neg_2_asm_h:                            // @neg_2_asm_h
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	.LBB645_3
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB645_6
// %bb.2:                               // %B13
	orr	w8, w21, #0x80000000
	mov	w9, #-2147483648                // =0x80000000
	cmp	w8, w9
	b.ne	.LBB645_5
.LBB645_3:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #140                        // =0x8c
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB645_8
// %bb.4:                               // %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB645_5:                              // %B15
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x1
.LBB645_6:                              // %B3
	tst	x21, #0xfffe000000000000
	b.eq	.LBB645_3
// %bb.7:                               // %B7
	movi	d0, #0000000000000000
	add	x8, x21, x8
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	fsub	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
.LBB645_8:                              // %B17
	b	exception_spill_top0_top1_asm_h
.Lfunc_end645:
	.size	neg_2_asm_h, .Lfunc_end645-neg_2_asm_h
                                        // -- End function
	.hidden	plus_2_asm_h                    // -- Begin function plus_2_asm_h
	.globl	plus_2_asm_h
	.p2align	2
	.type	plus_2_asm_h,@function
plus_2_asm_h:                           // @plus_2_asm_h
// %bb.0:                               // %B13
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	.LBB646_4
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB646_3
.LBB646_2:                              // %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB646_3:                              // %B3
	tst	x21, #0xfffe000000000000
	b.ne	.LBB646_2
.LBB646_4:                              // %B10
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #141                        // =0x8d
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB646_6
// %bb.5:                               // %B12
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB646_6:                              // %B11
	b	exception_spill_top0_top1_asm_h
.Lfunc_end646:
	.size	plus_2_asm_h, .Lfunc_end646-plus_2_asm_h
                                        // -- End function
	.hidden	dec_2_asm_h                     // -- Begin function dec_2_asm_h
	.globl	dec_2_asm_h
	.p2align	2
	.type	dec_2_asm_h,@function
dec_2_asm_h:                            // @dec_2_asm_h
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	.LBB647_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB647_4
// %bb.2:                               // %B13
	subs	w8, w21, #1
	b.vs	.LBB647_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB647_4:                              // %B3
	tst	x21, #0xfffe000000000000
	b.eq	.LBB647_6
// %bb.5:                               // %B7
	add	x8, x21, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
.LBB647_6:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #142                        // =0x8e
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB647_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB647_8:                              // %B17
	b	exception_spill_top0_top1_asm_h
.Lfunc_end647:
	.size	dec_2_asm_h, .Lfunc_end647-dec_2_asm_h
                                        // -- End function
	.hidden	inc_2_asm_h                     // -- Begin function inc_2_asm_h
	.globl	inc_2_asm_h
	.p2align	2
	.type	inc_2_asm_h,@function
inc_2_asm_h:                            // @inc_2_asm_h
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	.LBB648_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB648_4
// %bb.2:                               // %B13
	adds	w8, w21, #1
	b.vs	.LBB648_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB648_4:                              // %B3
	tst	x21, #0xfffe000000000000
	b.eq	.LBB648_6
// %bb.5:                               // %B7
	add	x8, x21, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
.LBB648_6:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #143                        // =0x8f
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB648_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB648_8:                              // %B17
	b	exception_spill_top0_top1_asm_h
.Lfunc_end648:
	.size	inc_2_asm_h, .Lfunc_end648-inc_2_asm_h
                                        // -- End function
	.hidden	post_dec_2_asm_h                // -- Begin function post_dec_2_asm_h
	.globl	post_dec_2_asm_h
	.p2align	2
	.type	post_dec_2_asm_h,@function
post_dec_2_asm_h:                       // @post_dec_2_asm_h
// %bb.0:                               // %B16
	mov	x8, #-281474976710656           // =0xffff000000000000
	str	x22, [x20], #8
	cmp	x21, x8
	b.hs	.LBB649_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB649_4
// %bb.2:                               // %B13
	subs	w8, w21, #1
	b.vs	.LBB649_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	mov	x22, x21
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB649_4:                              // %B3
	tst	x21, #0xfffe000000000000
	b.eq	.LBB649_6
// %bb.5:                               // %B8
	add	x8, x21, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	mov	x22, x21
	add	w8, w8, #484
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221120237041090560       // =0x7ff8000000000000
	csel	x8, x9, x10, vc
	mov	x21, x8
	br	x1
.LBB649_6:                              // %B5
	str	x21, [x20], #8
	mov	w0, #144                        // =0x90
	b	SlowJSPostInc_asm_h
.Lfunc_end649:
	.size	post_dec_2_asm_h, .Lfunc_end649-post_dec_2_asm_h
                                        // -- End function
	.hidden	post_inc_2_asm_h                // -- Begin function post_inc_2_asm_h
	.globl	post_inc_2_asm_h
	.p2align	2
	.type	post_inc_2_asm_h,@function
post_inc_2_asm_h:                       // @post_inc_2_asm_h
// %bb.0:                               // %B16
	mov	x8, #-281474976710656           // =0xffff000000000000
	str	x22, [x20], #8
	cmp	x21, x8
	b.hs	.LBB650_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB650_4
// %bb.2:                               // %B13
	adds	w8, w21, #1
	b.vs	.LBB650_6
// %bb.3:                               // %B15
	ldrb	w9, [x19], #1
	mov	x22, x21
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB650_4:                              // %B3
	tst	x21, #0xfffe000000000000
	b.eq	.LBB650_6
// %bb.5:                               // %B8
	add	x8, x21, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	mov	x22, x21
	add	w8, w8, #484
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221120237041090560       // =0x7ff8000000000000
	csel	x8, x9, x10, vc
	mov	x21, x8
	br	x1
.LBB650_6:                              // %B5
	str	x21, [x20], #8
	mov	w0, #145                        // =0x91
	b	SlowJSPostInc_asm_h
.Lfunc_end650:
	.size	post_inc_2_asm_h, .Lfunc_end650-post_inc_2_asm_h
                                        // -- End function
	.hidden	dec_loc_2_asm_h                 // -- Begin function dec_loc_2_asm_h
	.globl	dec_loc_2_asm_h
	.p2align	2
	.type	dec_loc_2_asm_h,@function
dec_loc_2_asm_h:                        // @dec_loc_2_asm_h
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	.LBB651_6
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB651_4
// %bb.2:                               // %B13
	subs	w9, w1, #1
	b.vs	.LBB651_6
// %bb.3:                               // %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB651_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB651_6
// %bb.5:                               // %B8
	add	x9, x1, x9
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221120237041090560       // =0x7ff8000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB651_6:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #142                        // =0x8e
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB651_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB651_8:                              // %B17
	b	exception_spill_top0_top1_asm_h
.Lfunc_end651:
	.size	dec_loc_2_asm_h, .Lfunc_end651-dec_loc_2_asm_h
                                        // -- End function
	.hidden	inc_loc_2_asm_h                 // -- Begin function inc_loc_2_asm_h
	.globl	inc_loc_2_asm_h
	.p2align	2
	.type	inc_loc_2_asm_h,@function
inc_loc_2_asm_h:                        // @inc_loc_2_asm_h
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	.LBB652_6
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB652_4
// %bb.2:                               // %B13
	adds	w9, w1, #1
	b.vs	.LBB652_6
// %bb.3:                               // %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB652_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB652_6
// %bb.5:                               // %B8
	add	x9, x1, x9
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221120237041090560       // =0x7ff8000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB652_6:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #143                        // =0x8f
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB652_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB652_8:                              // %B17
	b	exception_spill_top0_top1_asm_h
.Lfunc_end652:
	.size	inc_loc_2_asm_h, .Lfunc_end652-inc_loc_2_asm_h
                                        // -- End function
	.hidden	add_loc_2_asm_h                 // -- Begin function add_loc_2_asm_h
	.globl	add_loc_2_asm_h
	.p2align	2
	.type	add_loc_2_asm_h,@function
add_loc_2_asm_h:                        // @add_loc_2_asm_h
// %bb.0:                               // %B45
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	ccmp	x21, x9, #2, ls
	b.hi	.LBB653_14
// %bb.1:                               // %B2
	mov	x9, #-562949953421312           // =0xfffe000000000000
	cmp	x1, x9
	b.lo	.LBB653_5
// %bb.2:                               // %B26
	cmp	x21, x9
	b.lo	.LBB653_8
// %bb.3:                               // %B36
	adds	w9, w1, w21
	b.vs	.LBB653_14
// %bb.4:                               // %B38
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB653_5:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB653_14
// %bb.6:                               // %B11
	cmp	x21, x9
	b.lo	.LBB653_12
// %bb.7:                               // %B21
	scvtf	d0, w21
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	.LBB653_11
.LBB653_8:                              // %B28
	tst	x21, #0xfffe000000000000
	b.eq	.LBB653_14
// %bb.9:                               // %B31
	scvtf	d0, w1
	add	x9, x21, x9
.LBB653_10:                             // %B31
	fmov	d1, x9
	fadd	d0, d0, d1
.LBB653_11:                             // %B31
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	x9, x9, x10
	mov	x10, #9221120237041090560       // =0x7ff8000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB653_12:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB653_14
// %bb.13:                              // %B16
	add	x10, x1, x9
	add	x9, x21, x9
	fmov	d0, x10
	b	.LBB653_10
.LBB653_14:                             // %B7
	mov	x8, #2                          // =0x2
	and	x9, x1, #0xffff000000000003
	add	x10, x20, #16
	movk	x8, #1, lsl #48
	stp	x22, x21, [x20]
	cmp	x9, x8
	str	x10, [x23, #64]
	b.ne	.LBB653_17
// %bb.15:                              // %B7
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.ne	.LBB653_17
// %bb.16:                              // %B39
	mov	x0, x24
	mov	x2, x21
	bl	JS_ConcatString_GC
	b	.LBB653_18
.LBB653_17:                             // %B42
	mov	x0, x24
	mov	x2, x21
	bl	prim_js_add_slow_gc
.LBB653_18:                             // %B42
	cmp	x0, #130
	b.eq	.LBB653_20
// %bb.19:                              // %B44
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB653_20:                             // %B43
	b	exception_spill_top0_top1_asm_h
.Lfunc_end653:
	.size	add_loc_2_asm_h, .Lfunc_end653-add_loc_2_asm_h
                                        // -- End function
	.hidden	not_2_asm_h                     // -- Begin function not_2_asm_h
	.globl	not_2_asm_h
	.p2align	2
	.type	not_2_asm_h,@function
not_2_asm_h:                            // @not_2_asm_h
// %bb.0:                               // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB654_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x1
.LBB654_2:                              // %B4
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	SlowJSNot_asm_h
.Lfunc_end654:
	.size	not_2_asm_h, .Lfunc_end654-not_2_asm_h
                                        // -- End function
	.hidden	lnot_2_asm_h                    // -- Begin function lnot_2_asm_h
	.globl	lnot_2_asm_h
	.p2align	2
	.type	lnot_2_asm_h,@function
lnot_2_asm_h:                           // @lnot_2_asm_h
// %bb.0:                               // %B14
	cmp	x21, #5
	b.le	.LBB655_4
// %bb.1:                               // %B14
	cmp	x21, #6
	b.eq	.LBB655_6
// %bb.2:                               // %B14
	cmp	x21, #7
	b.eq	.LBB655_8
// %bb.3:                               // %B14
	cmp	x21, #18
	b.eq	.LBB655_6
	b	.LBB655_7
.LBB655_4:                              // %B14
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB655_6
// %bb.5:                               // %B14
	cmp	x21, #2
	b.ne	.LBB655_7
.LBB655_6:                              // %B3
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB655_7:                              // %B10
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB655_9
.LBB655_8:                              // %B12
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB655_9:                              // %B13
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	SlowToBoolean_asm_h
.Lfunc_end655:
	.size	lnot_2_asm_h, .Lfunc_end655-lnot_2_asm_h
                                        // -- End function
	.hidden	typeof_2_asm_h                  // -- Begin function typeof_2_asm_h
	.globl	typeof_2_asm_h
	.p2align	2
	.type	typeof_2_asm_h,@function
typeof_2_asm_h:                         // @typeof_2_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x21
	bl	js_operator_typeof_gc
	mov	w1, w0
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB656_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB656_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end656:
	.size	typeof_2_asm_h, .Lfunc_end656-typeof_2_asm_h
                                        // -- End function
	.hidden	delete_2_asm_h                  // -- Begin function delete_2_asm_h
	.globl	delete_2_asm_h
	.p2align	2
	.type	delete_2_asm_h,@function
delete_2_asm_h:                         // @delete_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	.LBB657_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB657_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end657:
	.size	delete_2_asm_h, .Lfunc_end657-delete_2_asm_h
                                        // -- End function
	.hidden	delete_var_2_asm_h              // -- Begin function delete_var_2_asm_h
	.globl	delete_var_2_asm_h
	.p2align	2
	.type	delete_var_2_asm_h,@function
delete_var_2_asm_h:                     // @delete_var_2_asm_h
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	mov	w3, wzr
	ldr	w2, [x19]
	ldr	x1, [x24, #208]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #64]
	bl	LEPUS_DeleteProperty
	tbnz	w0, #31, .LBB658_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	mov	x22, x21
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x21, x8, ne
	br	x1
.LBB658_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end658:
	.size	delete_var_2_asm_h, .Lfunc_end658-delete_var_2_asm_h
                                        // -- End function
	.hidden	mul_2_asm_h                     // -- Begin function mul_2_asm_h
	.globl	mul_2_asm_h
	.p2align	2
	.type	mul_2_asm_h,@function
mul_2_asm_h:                            // @mul_2_asm_h
// %bb.0:                               // %B47
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB659_18
// %bb.1:                               // %B47
	cmp	x21, x8
	b.hi	.LBB659_18
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB659_8
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB659_11
// %bb.4:                               // %B33
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	.LBB659_18
// %bb.5:                               // %B36
	cbnz	w8, .LBB659_7
// %bb.6:                               // %B36
	orr	w9, w22, w21
	tbnz	w9, #31, .LBB659_15
.LBB659_7:                              // %B43
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB659_8:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB659_18
// %bb.9:                               // %B7
	cmp	x21, x8
	b.lo	.LBB659_16
// %bb.10:                              // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	.LBB659_14
.LBB659_11:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB659_18
// %bb.12:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB659_13:                             // %B28
	fmov	d1, x8
	fmul	d0, d0, d1
.LBB659_14:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB659_15:                             // %B40
	mov	x22, #-9222809086901354496      // =0x8002000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB659_16:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB659_18
// %bb.17:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB659_13
.LBB659_18:                             // %B44
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        // =0x9a
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB659_20
// %bb.19:                              // %B46
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB659_20:                             // %B45
	b	exception_spill_top0_top1_asm_h
.Lfunc_end659:
	.size	mul_2_asm_h, .Lfunc_end659-mul_2_asm_h
                                        // -- End function
	.hidden	div_2_asm_h                     // -- Begin function div_2_asm_h
	.globl	div_2_asm_h
	.p2align	2
	.type	div_2_asm_h,@function
div_2_asm_h:                            // @div_2_asm_h
// %bb.0:                               // %B44
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB660_14
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB660_14
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB660_5
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB660_8
// %bb.4:                               // %B33
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w9, [x19], #1
	mov	x12, #9221120237041090560       // =0x7ff8000000000000
	add	w9, w9, #242
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
.LBB660_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB660_14
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB660_12
// %bb.7:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	.LBB660_11
.LBB660_8:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB660_14
// %bb.9:                               // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB660_10:                             // %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
.LBB660_11:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB660_12:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB660_14
// %bb.13:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB660_10
.LBB660_14:                             // %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        // =0x9b
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB660_16
// %bb.15:                              // %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB660_16:                             // %B42
	b	exception_spill_top0_top1_asm_h
.Lfunc_end660:
	.size	div_2_asm_h, .Lfunc_end660-div_2_asm_h
                                        // -- End function
	.hidden	mod_2_asm_h                     // -- Begin function mod_2_asm_h
	.globl	mod_2_asm_h
	.p2align	2
	.type	mod_2_asm_h,@function
mod_2_asm_h:                            // @mod_2_asm_h
// %bb.0:                               // %B39
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB661_16
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB661_16
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB661_7
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB661_10
// %bb.4:                               // %B33
	tbnz	w22, #31, .LBB661_16
// %bb.5:                               // %B33
	cmp	w21, #1
	b.lt	.LBB661_16
// %bb.6:                               // %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
.LBB661_7:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB661_16
// %bb.8:                               // %B7
	cmp	x21, x8
	b.lo	.LBB661_14
// %bb.9:                               // %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	.LBB661_13
.LBB661_10:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB661_16
// %bb.11:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB661_12:                             // %B28
	fmov	d1, x8
.LBB661_13:                             // %B28
	bl	fmod
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB661_14:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB661_16
// %bb.15:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB661_12
.LBB661_16:                             // %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        // =0x9c
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB661_18
// %bb.17:                              // %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB661_18:                             // %B37
	b	exception_spill_top0_top1_asm_h
.Lfunc_end661:
	.size	mod_2_asm_h, .Lfunc_end661-mod_2_asm_h
                                        // -- End function
	.hidden	add_2_asm_h                     // -- Begin function add_2_asm_h
	.globl	add_2_asm_h
	.p2align	2
	.type	add_2_asm_h,@function
add_2_asm_h:                            // @add_2_asm_h
// %bb.0:                               // %B45
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB662_15
// %bb.1:                               // %B45
	cmp	x21, x8
	b.hi	.LBB662_15
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB662_6
// %bb.3:                               // %B26
	cmp	x21, x8
	b.lo	.LBB662_9
// %bb.4:                               // %B36
	adds	w8, w22, w21
	b.vs	.LBB662_15
// %bb.5:                               // %B38
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB662_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB662_15
// %bb.7:                               // %B10
	cmp	x21, x8
	b.lo	.LBB662_13
// %bb.8:                               // %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	.LBB662_12
.LBB662_9:                              // %B28
	tst	x21, #0xfffe000000000000
	b.eq	.LBB662_15
// %bb.10:                              // %B31
	scvtf	d0, w22
	add	x8, x21, x8
.LBB662_11:                             // %B31
	fmov	d1, x8
	fadd	d0, d0, d1
.LBB662_12:                             // %B31
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB662_13:                             // %B12
	tst	x21, #0xfffe000000000000
	b.eq	.LBB662_15
// %bb.14:                              // %B15
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB662_11
.LBB662_15:                             // %B6
	mov	x8, #2                          // =0x2
	and	x9, x22, #0xffff000000000003
	add	x10, x20, #16
	movk	x8, #1, lsl #48
	stp	x22, x21, [x20]
	cmp	x9, x8
	str	x10, [x23, #64]
	b.ne	.LBB662_18
// %bb.16:                              // %B6
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.ne	.LBB662_18
// %bb.17:                              // %B39
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	JS_ConcatString_GC
	b	.LBB662_19
.LBB662_18:                             // %B42
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_add_slow_gc
.LBB662_19:                             // %B42
	cmp	x0, #130
	b.eq	.LBB662_21
// %bb.20:                              // %B44
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB662_21:                             // %B43
	b	exception_spill_top0_top1_asm_h
.Lfunc_end662:
	.size	add_2_asm_h, .Lfunc_end662-add_2_asm_h
                                        // -- End function
	.hidden	sub_2_asm_h                     // -- Begin function sub_2_asm_h
	.globl	sub_2_asm_h
	.p2align	2
	.type	sub_2_asm_h,@function
sub_2_asm_h:                            // @sub_2_asm_h
// %bb.0:                               // %B39
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB663_15
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB663_15
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB663_6
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB663_9
// %bb.4:                               // %B33
	subs	w8, w22, w21
	b.vs	.LBB663_15
// %bb.5:                               // %B35
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB663_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB663_15
// %bb.7:                               // %B7
	cmp	x21, x8
	b.lo	.LBB663_13
// %bb.8:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	.LBB663_12
.LBB663_9:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB663_15
// %bb.10:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB663_11:                             // %B28
	fmov	d1, x8
	fsub	d0, d0, d1
.LBB663_12:                             // %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           // =0x2000000000000
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	csel	x22, x9, x8, vc
	br	x1
.LBB663_13:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB663_15
// %bb.14:                              // %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB663_11
.LBB663_15:                             // %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        // =0x9e
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB663_17
// %bb.16:                              // %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB663_17:                             // %B37
	b	exception_spill_top0_top1_asm_h
.Lfunc_end663:
	.size	sub_2_asm_h, .Lfunc_end663-sub_2_asm_h
                                        // -- End function
	.hidden	pow_2_asm_h                     // -- Begin function pow_2_asm_h
	.globl	pow_2_asm_h
	.p2align	2
	.type	pow_2_asm_h,@function
pow_2_asm_h:                            // @pow_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #159                        // =0x9f
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB664_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB664_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end664:
	.size	pow_2_asm_h, .Lfunc_end664-pow_2_asm_h
                                        // -- End function
	.hidden	shl_2_asm_h                     // -- Begin function shl_2_asm_h
	.globl	shl_2_asm_h
	.p2align	2
	.type	shl_2_asm_h,@function
shl_2_asm_h:                            // @shl_2_asm_h
// %bb.0:                               // %B28
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB665_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB665_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB665_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB665_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	add	w9, w9, #242
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB665_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB665_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB665_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB665_9
// %bb.8:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	add	w9, w9, #242
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB665_9:                              // %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        // =0xa0
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB665_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB665_11:                             // %B26
	b	exception_spill_top0_top1_asm_h
.Lfunc_end665:
	.size	shl_2_asm_h, .Lfunc_end665-shl_2_asm_h
                                        // -- End function
	.hidden	sar_2_asm_h                     // -- Begin function sar_2_asm_h
	.globl	sar_2_asm_h
	.p2align	2
	.type	sar_2_asm_h,@function
sar_2_asm_h:                            // @sar_2_asm_h
// %bb.0:                               // %B28
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB666_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB666_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB666_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB666_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	add	w9, w9, #242
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB666_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB666_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB666_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB666_9
// %bb.8:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	add	w9, w9, #242
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB666_9:                              // %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        // =0xa1
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB666_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB666_11:                             // %B26
	b	exception_spill_top0_top1_asm_h
.Lfunc_end666:
	.size	sar_2_asm_h, .Lfunc_end666-sar_2_asm_h
                                        // -- End function
	.hidden	shr_2_asm_h                     // -- Begin function shr_2_asm_h
	.globl	shr_2_asm_h
	.p2align	2
	.type	shr_2_asm_h,@function
shr_2_asm_h:                            // @shr_2_asm_h
// %bb.0:                               // %B36
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB667_11
// %bb.1:                               // %B36
	cmp	x21, x8
	b.hi	.LBB667_11
// %bb.2:                               // %B10
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB667_6
// %bb.3:                               // %B27
	cmp	x21, x8
	b.lo	.LBB667_11
// %bb.4:                               // %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, .LBB667_10
.LBB667_5:                              // %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB667_6:                              // %B12
	tst	x22, #0xfffe000000000000
	b.eq	.LBB667_11
// %bb.7:                               // %B12
	cmp	x21, x8
	b.lo	.LBB667_11
// %bb.8:                               // %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB667_11
// %bb.9:                               // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, .LBB667_5
.LBB667_10:                             // %B6
	ucvtf	d0, w8
	mov	x9, #562949953421312            // =0x2000000000000
	fmov	x8, d0
	fcmp	d0, d0
	add	x8, x8, x9
	mov	x9, #9221120237041090560        // =0x7ff8000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB667_11:                             // %B33
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	.LBB667_13
// %bb.12:                              // %B35
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB667_13:                             // %B34
	b	exception_spill_top0_top1_asm_h
.Lfunc_end667:
	.size	shr_2_asm_h, .Lfunc_end667-shr_2_asm_h
                                        // -- End function
	.hidden	lt_2_asm_h                      // -- Begin function lt_2_asm_h
	.globl	lt_2_asm_h
	.p2align	2
	.type	lt_2_asm_h,@function
lt_2_asm_h:                             // @lt_2_asm_h
// %bb.0:                               // %B24
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB668_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB668_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB668_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB668_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, lt
	br	x1
.LBB668_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB668_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB668_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB668_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB668_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB668_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB668_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x1
.LBB668_12:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        // =0xa3
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB668_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB668_14:                             // %B22
	b	exception_spill_top0_top1_asm_h
.Lfunc_end668:
	.size	lt_2_asm_h, .Lfunc_end668-lt_2_asm_h
                                        // -- End function
	.hidden	lte_2_asm_h                     // -- Begin function lte_2_asm_h
	.globl	lte_2_asm_h
	.p2align	2
	.type	lte_2_asm_h,@function
lte_2_asm_h:                            // @lte_2_asm_h
// %bb.0:                               // %B24
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB669_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB669_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB669_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB669_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, le
	br	x1
.LBB669_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB669_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB669_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB669_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB669_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB669_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB669_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x1
.LBB669_12:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        // =0xa4
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB669_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB669_14:                             // %B22
	b	exception_spill_top0_top1_asm_h
.Lfunc_end669:
	.size	lte_2_asm_h, .Lfunc_end669-lte_2_asm_h
                                        // -- End function
	.hidden	gt_2_asm_h                      // -- Begin function gt_2_asm_h
	.globl	gt_2_asm_h
	.p2align	2
	.type	gt_2_asm_h,@function
gt_2_asm_h:                             // @gt_2_asm_h
// %bb.0:                               // %B24
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB670_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB670_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB670_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB670_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB670_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB670_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB670_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB670_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB670_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB670_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB670_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x1
.LBB670_12:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        // =0xa5
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB670_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB670_14:                             // %B22
	b	exception_spill_top0_top1_asm_h
.Lfunc_end670:
	.size	gt_2_asm_h, .Lfunc_end670-gt_2_asm_h
                                        // -- End function
	.hidden	gte_2_asm_h                     // -- Begin function gte_2_asm_h
	.globl	gte_2_asm_h
	.p2align	2
	.type	gte_2_asm_h,@function
gte_2_asm_h:                            // @gte_2_asm_h
// %bb.0:                               // %B24
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB671_12
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB671_12
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB671_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB671_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB671_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB671_12
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB671_10
// %bb.7:                               // %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB671_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB671_12
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB671_10:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB671_12
// %bb.11:                              // %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x1
.LBB671_12:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        // =0xa6
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB671_14
// %bb.13:                              // %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB671_14:                             // %B22
	b	exception_spill_top0_top1_asm_h
.Lfunc_end671:
	.size	gte_2_asm_h, .Lfunc_end671-gte_2_asm_h
                                        // -- End function
	.hidden	instanceof_2_asm_h              // -- Begin function instanceof_2_asm_h
	.globl	instanceof_2_asm_h
	.p2align	2
	.type	instanceof_2_asm_h,@function
instanceof_2_asm_h:                     // @instanceof_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	.LBB672_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB672_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end672:
	.size	instanceof_2_asm_h, .Lfunc_end672-instanceof_2_asm_h
                                        // -- End function
	.hidden	in_2_asm_h                      // -- Begin function in_2_asm_h
	.globl	in_2_asm_h
	.p2align	2
	.type	in_2_asm_h,@function
in_2_asm_h:                             // @in_2_asm_h
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	.LBB673_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB673_2:                              // %B2
	b	exception_spill_top0_top1_asm_h
.Lfunc_end673:
	.size	in_2_asm_h, .Lfunc_end673-in_2_asm_h
                                        // -- End function
	.hidden	eq_2_asm_h                      // -- Begin function eq_2_asm_h
	.globl	eq_2_asm_h
	.p2align	2
	.type	eq_2_asm_h,@function
eq_2_asm_h:                             // @eq_2_asm_h
// %bb.0:                               // %B44
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB674_13
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB674_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB674_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB674_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB674_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB674_13
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB674_11
// %bb.7:                               // %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB674_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB674_13
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB674_10:                             // %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB674_11:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB674_13
// %bb.12:                              // %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB674_10
.LBB674_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB674_15
.LBB674_14:                             // %B8
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB674_15:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB674_17
// %bb.16:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB674_14
	b	.LBB674_20
.LBB674_17:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB674_20
// %bb.18:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB674_21
// %bb.19:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB674_21
.LBB674_20:                             // %B15
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB674_21:                             // %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB674_23
// %bb.22:                              // %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB674_23:                             // %B42
	b	exception_spill_top0_top1_asm_h
.Lfunc_end674:
	.size	eq_2_asm_h, .Lfunc_end674-eq_2_asm_h
                                        // -- End function
	.hidden	neq_2_asm_h                     // -- Begin function neq_2_asm_h
	.globl	neq_2_asm_h
	.p2align	2
	.type	neq_2_asm_h,@function
neq_2_asm_h:                            // @neq_2_asm_h
// %bb.0:                               // %B44
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB675_13
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB675_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB675_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB675_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB675_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB675_13
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB675_11
// %bb.7:                               // %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB675_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB675_13
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB675_10:                             // %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB675_11:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB675_13
// %bb.12:                              // %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB675_10
.LBB675_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB675_15
.LBB675_14:                             // %B8
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB675_15:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB675_17
// %bb.16:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB675_14
	b	.LBB675_20
.LBB675_17:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB675_20
// %bb.18:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB675_21
// %bb.19:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB675_21
.LBB675_20:                             // %B15
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB675_21:                             // %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB675_23
// %bb.22:                              // %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB675_23:                             // %B42
	b	exception_spill_top0_top1_asm_h
.Lfunc_end675:
	.size	neq_2_asm_h, .Lfunc_end675-neq_2_asm_h
                                        // -- End function
	.hidden	strict_eq_2_asm_h               // -- Begin function strict_eq_2_asm_h
	.globl	strict_eq_2_asm_h
	.p2align	2
	.type	strict_eq_2_asm_h,@function
strict_eq_2_asm_h:                      // @strict_eq_2_asm_h
// %bb.0:                               // %B36
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB676_13
// %bb.1:                               // %B36
	cmp	x21, x8
	b.hi	.LBB676_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB676_5
// %bb.3:                               // %B27
	cmp	x21, x8
	b.lo	.LBB676_8
// %bb.4:                               // %B32
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x1
.LBB676_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB676_13
// %bb.6:                               // %B20
	cmp	x21, x8
	b.lo	.LBB676_11
// %bb.7:                               // %B25
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB676_8:                              // %B29
	tst	x21, #0xfffe000000000000
	b.eq	.LBB676_13
// %bb.9:                               // %B31
	scvtf	d0, w22
	add	x8, x21, x8
.LBB676_10:                             // %B31
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
.LBB676_11:                             // %B22
	tst	x21, #0xfffe000000000000
	b.eq	.LBB676_13
// %bb.12:                              // %B24
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB676_10
.LBB676_13:                             // %B10
	cmp	x22, x21
	b.ne	.LBB676_15
.LBB676_14:                             // %B11
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB676_15:                             // %B13
	and	x8, x21, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	mov	x13, #2                         // =0x2
	ccmp	x8, x12, #4, ne
	movk	x13, #65535, lsl #48
	and	x9, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w10, eq
	cmp	x9, x13
	ccmp	x9, x12, #4, ne
	ccmp	x9, x11, #4, ne
	b.ne	.LBB676_17
// %bb.16:                              // %B13
	tbnz	w10, #0, .LBB676_20
.LBB676_17:                             // %B16
	mov	x10, #-281474976710656          // =0xffff000000000000
	cmp	x9, x10
	b.ne	.LBB676_19
// %bb.18:                              // %B16
	cmp	x8, x10
	b.eq	.LBB676_22
.LBB676_19:                             // %B18
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB676_20:                             // %B33
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB676_24
// %bb.21:                              // %B35
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB676_22:                             // %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB676_14
// %bb.23:                              // %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB676_24:                             // %B34
	b	exception_spill_top0_top1_asm_h
.Lfunc_end676:
	.size	strict_eq_2_asm_h, .Lfunc_end676-strict_eq_2_asm_h
                                        // -- End function
	.hidden	strict_neq_2_asm_h              // -- Begin function strict_neq_2_asm_h
	.globl	strict_neq_2_asm_h
	.p2align	2
	.type	strict_neq_2_asm_h,@function
strict_neq_2_asm_h:                     // @strict_neq_2_asm_h
// %bb.0:                               // %B36
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB677_13
// %bb.1:                               // %B36
	cmp	x21, x8
	b.hi	.LBB677_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB677_5
// %bb.3:                               // %B27
	cmp	x21, x8
	b.lo	.LBB677_8
// %bb.4:                               // %B32
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x1
.LBB677_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB677_13
// %bb.6:                               // %B20
	cmp	x21, x8
	b.lo	.LBB677_11
// %bb.7:                               // %B25
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB677_8:                              // %B29
	tst	x21, #0xfffe000000000000
	b.eq	.LBB677_13
// %bb.9:                               // %B31
	scvtf	d0, w22
	add	x8, x21, x8
.LBB677_10:                             // %B31
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
.LBB677_11:                             // %B22
	tst	x21, #0xfffe000000000000
	b.eq	.LBB677_13
// %bb.12:                              // %B24
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	.LBB677_10
.LBB677_13:                             // %B10
	cmp	x22, x21
	b.ne	.LBB677_15
.LBB677_14:                             // %B11
	ldrb	w8, [x19], #1
	mov	w22, #6                         // =0x6
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB677_15:                             // %B13
	and	x8, x21, #0xffff000000000003
	mov	x11, #-281474976710653          // =0xffff000000000003
	mov	x12, #2                         // =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	mov	x13, #2                         // =0x2
	ccmp	x8, x12, #4, ne
	movk	x13, #65535, lsl #48
	and	x9, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w10, eq
	cmp	x9, x13
	ccmp	x9, x12, #4, ne
	ccmp	x9, x11, #4, ne
	b.ne	.LBB677_17
// %bb.16:                              // %B13
	tbnz	w10, #0, .LBB677_20
.LBB677_17:                             // %B16
	mov	x10, #-281474976710656          // =0xffff000000000000
	cmp	x9, x10
	b.ne	.LBB677_19
// %bb.18:                              // %B16
	cmp	x8, x10
	b.eq	.LBB677_22
.LBB677_19:                             // %B18
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB677_20:                             // %B33
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB677_24
// %bb.21:                              // %B35
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB677_22:                             // %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	.LBB677_14
// %bb.23:                              // %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         // =0x7
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB677_24:                             // %B34
	b	exception_spill_top0_top1_asm_h
.Lfunc_end677:
	.size	strict_neq_2_asm_h, .Lfunc_end677-strict_neq_2_asm_h
                                        // -- End function
	.hidden	and_2_asm_h                     // -- Begin function and_2_asm_h
	.globl	and_2_asm_h
	.p2align	2
	.type	and_2_asm_h,@function
and_2_asm_h:                            // @and_2_asm_h
// %bb.0:                               // %B28
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB678_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB678_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB678_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB678_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	and	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB678_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB678_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB678_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB678_9
// %bb.8:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	and	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB678_9:                              // %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        // =0xad
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB678_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB678_11:                             // %B26
	b	exception_spill_top0_top1_asm_h
.Lfunc_end678:
	.size	and_2_asm_h, .Lfunc_end678-and_2_asm_h
                                        // -- End function
	.hidden	xor_2_asm_h                     // -- Begin function xor_2_asm_h
	.globl	xor_2_asm_h
	.p2align	2
	.type	xor_2_asm_h,@function
xor_2_asm_h:                            // @xor_2_asm_h
// %bb.0:                               // %B28
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB679_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB679_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB679_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB679_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	eor	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB679_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB679_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB679_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB679_9
// %bb.8:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	eor	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB679_9:                              // %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        // =0xae
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB679_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB679_11:                             // %B26
	b	exception_spill_top0_top1_asm_h
.Lfunc_end679:
	.size	xor_2_asm_h, .Lfunc_end679-xor_2_asm_h
                                        // -- End function
	.hidden	or_2_asm_h                      // -- Begin function or_2_asm_h
	.globl	or_2_asm_h
	.p2align	2
	.type	or_2_asm_h,@function
or_2_asm_h:                             // @or_2_asm_h
// %bb.0:                               // %B28
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB680_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB680_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB680_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB680_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	orr	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB680_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB680_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB680_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB680_9
// %bb.8:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	orr	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #242
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB680_9:                              // %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        // =0xaf
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB680_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB680_11:                             // %B26
	b	exception_spill_top0_top1_asm_h
.Lfunc_end680:
	.size	or_2_asm_h, .Lfunc_end680-or_2_asm_h
                                        // -- End function
	.hidden	nop_2_asm_h                     // -- Begin function nop_2_asm_h
	.globl	nop_2_asm_h
	.p2align	2
	.type	nop_2_asm_h,@function
nop_2_asm_h:                            // @nop_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end681:
	.size	nop_2_asm_h, .Lfunc_end681-nop_2_asm_h
                                        // -- End function
	.hidden	push_minus1_2_asm_h             // -- Begin function push_minus1_2_asm_h
	.globl	push_minus1_2_asm_h
	.p2align	2
	.type	push_minus1_2_asm_h,@function
push_minus1_2_asm_h:                    // @push_minus1_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562945658454017          // =0xfffe0000ffffffff
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end682:
	.size	push_minus1_2_asm_h, .Lfunc_end682-push_minus1_2_asm_h
                                        // -- End function
	.hidden	push_0_2_asm_h                  // -- Begin function push_0_2_asm_h
	.globl	push_0_2_asm_h
	.p2align	2
	.type	push_0_2_asm_h,@function
push_0_2_asm_h:                         // @push_0_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421312          // =0xfffe000000000000
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end683:
	.size	push_0_2_asm_h, .Lfunc_end683-push_0_2_asm_h
                                        // -- End function
	.hidden	push_1_2_asm_h                  // -- Begin function push_1_2_asm_h
	.globl	push_1_2_asm_h
	.p2align	2
	.type	push_1_2_asm_h,@function
push_1_2_asm_h:                         // @push_1_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421311          // =0xfffe000000000001
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end684:
	.size	push_1_2_asm_h, .Lfunc_end684-push_1_2_asm_h
                                        // -- End function
	.hidden	push_2_2_asm_h                  // -- Begin function push_2_2_asm_h
	.globl	push_2_2_asm_h
	.p2align	2
	.type	push_2_2_asm_h,@function
push_2_2_asm_h:                         // @push_2_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #2                         // =0x2
	movk	x21, #65534, lsl #48
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end685:
	.size	push_2_2_asm_h, .Lfunc_end685-push_2_2_asm_h
                                        // -- End function
	.hidden	push_3_2_asm_h                  // -- Begin function push_3_2_asm_h
	.globl	push_3_2_asm_h
	.p2align	2
	.type	push_3_2_asm_h,@function
push_3_2_asm_h:                         // @push_3_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421309          // =0xfffe000000000003
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end686:
	.size	push_3_2_asm_h, .Lfunc_end686-push_3_2_asm_h
                                        // -- End function
	.hidden	push_4_2_asm_h                  // -- Begin function push_4_2_asm_h
	.globl	push_4_2_asm_h
	.p2align	2
	.type	push_4_2_asm_h,@function
push_4_2_asm_h:                         // @push_4_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #4                         // =0x4
	movk	x21, #65534, lsl #48
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end687:
	.size	push_4_2_asm_h, .Lfunc_end687-push_4_2_asm_h
                                        // -- End function
	.hidden	push_5_2_asm_h                  // -- Begin function push_5_2_asm_h
	.globl	push_5_2_asm_h
	.p2align	2
	.type	push_5_2_asm_h,@function
push_5_2_asm_h:                         // @push_5_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #5                         // =0x5
	movk	x21, #65534, lsl #48
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end688:
	.size	push_5_2_asm_h, .Lfunc_end688-push_5_2_asm_h
                                        // -- End function
	.hidden	push_6_2_asm_h                  // -- Begin function push_6_2_asm_h
	.globl	push_6_2_asm_h
	.p2align	2
	.type	push_6_2_asm_h,@function
push_6_2_asm_h:                         // @push_6_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #6                         // =0x6
	movk	x21, #65534, lsl #48
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end689:
	.size	push_6_2_asm_h, .Lfunc_end689-push_6_2_asm_h
                                        // -- End function
	.hidden	push_7_2_asm_h                  // -- Begin function push_7_2_asm_h
	.globl	push_7_2_asm_h
	.p2align	2
	.type	push_7_2_asm_h,@function
push_7_2_asm_h:                         // @push_7_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421305          // =0xfffe000000000007
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end690:
	.size	push_7_2_asm_h, .Lfunc_end690-push_7_2_asm_h
                                        // -- End function
	.hidden	push_i8_2_asm_h                 // -- Begin function push_i8_2_asm_h
	.globl	push_i8_2_asm_h
	.p2align	2
	.type	push_i8_2_asm_h,@function
push_i8_2_asm_h:                        // @push_i8_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x8, #-562949953421312           // =0xfffe000000000000
	ldrb	w9, [x19, #1]
	ldrsb	x10, [x19]
	add	x19, x19, #2
	mov	x22, x21
	add	w9, w9, #484
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x8
	br	x1
.Lfunc_end691:
	.size	push_i8_2_asm_h, .Lfunc_end691-push_i8_2_asm_h
                                        // -- End function
	.hidden	push_i16_2_asm_h                // -- Begin function push_i16_2_asm_h
	.globl	push_i16_2_asm_h
	.p2align	2
	.type	push_i16_2_asm_h,@function
push_i16_2_asm_h:                       // @push_i16_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x8, #-562949953421312           // =0xfffe000000000000
	ldrb	w9, [x19, #2]
	ldrsh	x10, [x19]
	add	x19, x19, #3
	mov	x22, x21
	add	w9, w9, #484
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x8
	br	x1
.Lfunc_end692:
	.size	push_i16_2_asm_h, .Lfunc_end692-push_i16_2_asm_h
                                        // -- End function
	.hidden	push_const8_2_asm_h             // -- Begin function push_const8_2_asm_h
	.globl	push_const8_2_asm_h
	.p2align	2
	.type	push_const8_2_asm_h,@function
push_const8_2_asm_h:                    // @push_const8_2_asm_h
// %bb.0:                               // %B3
	sub	sp, sp, #16
	str	x22, [x20], #8
	ldr	x8, [x23, #128]
	ldrb	w9, [x19]
	ldr	w10, [x24, #336]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, .LBB693_2
// %bb.1:                               // %B4
	mov	x8, x20
	mov	x0, x24
	mov	x2, x19
	str	x21, [x8], #8
	str	x8, [x23, #64]
	str	x1, [sp, #8]                    // 8-byte Folded Spill
	bl	DebuggerPause
	ldr	x1, [sp, #8]                    // 8-byte Folded Reload
.LBB693_2:                              // %B1
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x1
	add	w8, w8, #484
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
.Lfunc_end693:
	.size	push_const8_2_asm_h, .Lfunc_end693-push_const8_2_asm_h
                                        // -- End function
	.hidden	fclosure8_2_asm_h               // -- Begin function fclosure8_2_asm_h
	.globl	fclosure8_2_asm_h
	.p2align	2
	.type	fclosure8_2_asm_h,@function
fclosure8_2_asm_h:                      // @fclosure8_2_asm_h
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	mov	x2, x26
	ldr	x8, [x23, #128]
	ldrb	w9, [x19]
	mov	x3, x23
	ldr	x1, [x8, x9, lsl #3]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #64]
	bl	js_closure_gc
	cmp	x0, #130
	b.eq	.LBB694_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB694_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end694:
	.size	fclosure8_2_asm_h, .Lfunc_end694-fclosure8_2_asm_h
                                        // -- End function
	.hidden	push_empty_string_2_asm_h       // -- Begin function push_empty_string_2_asm_h
	.globl	push_empty_string_2_asm_h
	.p2align	2
	.type	push_empty_string_2_asm_h,@function
push_empty_string_2_asm_h:              // @push_empty_string_2_asm_h
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	mov	w1, #47                         // =0x2f
	str	x21, [x20, #8]!
	add	x8, x20, #8
	mov	w2, #1                          // =0x1
	str	x8, [x23, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB695_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB695_2:                              // %B2
	b	exception_spill_top1_asm_h
.Lfunc_end695:
	.size	push_empty_string_2_asm_h, .Lfunc_end695-push_empty_string_2_asm_h
                                        // -- End function
	.hidden	get_loc8_2_asm_h                // -- Begin function get_loc8_2_asm_h
	.globl	get_loc8_2_asm_h
	.p2align	2
	.type	get_loc8_2_asm_h,@function
get_loc8_2_asm_h:                       // @get_loc8_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #1]
	ldrb	w9, [x19], #2
	add	w8, w8, #484
	ldr	x9, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x9
	br	x1
.Lfunc_end696:
	.size	get_loc8_2_asm_h, .Lfunc_end696-get_loc8_2_asm_h
                                        // -- End function
	.hidden	put_loc8_2_asm_h                // -- Begin function put_loc8_2_asm_h
	.globl	put_loc8_2_asm_h
	.p2align	2
	.type	put_loc8_2_asm_h,@function
put_loc8_2_asm_h:                       // @put_loc8_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end697:
	.size	put_loc8_2_asm_h, .Lfunc_end697-put_loc8_2_asm_h
                                        // -- End function
	.hidden	set_loc8_2_asm_h                // -- Begin function set_loc8_2_asm_h
	.globl	set_loc8_2_asm_h
	.p2align	2
	.type	set_loc8_2_asm_h,@function
set_loc8_2_asm_h:                       // @set_loc8_2_asm_h
// %bb.0:                               // %B0
	ldrb	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end698:
	.size	set_loc8_2_asm_h, .Lfunc_end698-set_loc8_2_asm_h
                                        // -- End function
	.hidden	get_loc0_2_asm_h                // -- Begin function get_loc0_2_asm_h
	.globl	get_loc0_2_asm_h
	.p2align	2
	.type	get_loc0_2_asm_h,@function
get_loc0_2_asm_h:                       // @get_loc0_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x27]
	add	w8, w8, #484
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end699:
	.size	get_loc0_2_asm_h, .Lfunc_end699-get_loc0_2_asm_h
                                        // -- End function
	.hidden	get_loc1_2_asm_h                // -- Begin function get_loc1_2_asm_h
	.globl	get_loc1_2_asm_h
	.p2align	2
	.type	get_loc1_2_asm_h,@function
get_loc1_2_asm_h:                       // @get_loc1_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x27, #8]
	add	w8, w8, #484
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end700:
	.size	get_loc1_2_asm_h, .Lfunc_end700-get_loc1_2_asm_h
                                        // -- End function
	.hidden	get_loc2_2_asm_h                // -- Begin function get_loc2_2_asm_h
	.globl	get_loc2_2_asm_h
	.p2align	2
	.type	get_loc2_2_asm_h,@function
get_loc2_2_asm_h:                       // @get_loc2_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x27, #16]
	add	w8, w8, #484
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end701:
	.size	get_loc2_2_asm_h, .Lfunc_end701-get_loc2_2_asm_h
                                        // -- End function
	.hidden	get_loc3_2_asm_h                // -- Begin function get_loc3_2_asm_h
	.globl	get_loc3_2_asm_h
	.p2align	2
	.type	get_loc3_2_asm_h,@function
get_loc3_2_asm_h:                       // @get_loc3_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x27, #24]
	add	w8, w8, #484
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end702:
	.size	get_loc3_2_asm_h, .Lfunc_end702-get_loc3_2_asm_h
                                        // -- End function
	.hidden	put_loc0_2_asm_h                // -- Begin function put_loc0_2_asm_h
	.globl	put_loc0_2_asm_h
	.p2align	2
	.type	put_loc0_2_asm_h,@function
put_loc0_2_asm_h:                       // @put_loc0_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end703:
	.size	put_loc0_2_asm_h, .Lfunc_end703-put_loc0_2_asm_h
                                        // -- End function
	.hidden	put_loc1_2_asm_h                // -- Begin function put_loc1_2_asm_h
	.globl	put_loc1_2_asm_h
	.p2align	2
	.type	put_loc1_2_asm_h,@function
put_loc1_2_asm_h:                       // @put_loc1_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end704:
	.size	put_loc1_2_asm_h, .Lfunc_end704-put_loc1_2_asm_h
                                        // -- End function
	.hidden	put_loc2_2_asm_h                // -- Begin function put_loc2_2_asm_h
	.globl	put_loc2_2_asm_h
	.p2align	2
	.type	put_loc2_2_asm_h,@function
put_loc2_2_asm_h:                       // @put_loc2_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end705:
	.size	put_loc2_2_asm_h, .Lfunc_end705-put_loc2_2_asm_h
                                        // -- End function
	.hidden	put_loc3_2_asm_h                // -- Begin function put_loc3_2_asm_h
	.globl	put_loc3_2_asm_h
	.p2align	2
	.type	put_loc3_2_asm_h,@function
put_loc3_2_asm_h:                       // @put_loc3_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end706:
	.size	put_loc3_2_asm_h, .Lfunc_end706-put_loc3_2_asm_h
                                        // -- End function
	.hidden	set_loc0_2_asm_h                // -- Begin function set_loc0_2_asm_h
	.globl	set_loc0_2_asm_h
	.p2align	2
	.type	set_loc0_2_asm_h,@function
set_loc0_2_asm_h:                       // @set_loc0_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end707:
	.size	set_loc0_2_asm_h, .Lfunc_end707-set_loc0_2_asm_h
                                        // -- End function
	.hidden	set_loc1_2_asm_h                // -- Begin function set_loc1_2_asm_h
	.globl	set_loc1_2_asm_h
	.p2align	2
	.type	set_loc1_2_asm_h,@function
set_loc1_2_asm_h:                       // @set_loc1_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end708:
	.size	set_loc1_2_asm_h, .Lfunc_end708-set_loc1_2_asm_h
                                        // -- End function
	.hidden	set_loc2_2_asm_h                // -- Begin function set_loc2_2_asm_h
	.globl	set_loc2_2_asm_h
	.p2align	2
	.type	set_loc2_2_asm_h,@function
set_loc2_2_asm_h:                       // @set_loc2_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end709:
	.size	set_loc2_2_asm_h, .Lfunc_end709-set_loc2_2_asm_h
                                        // -- End function
	.hidden	set_loc3_2_asm_h                // -- Begin function set_loc3_2_asm_h
	.globl	set_loc3_2_asm_h
	.p2align	2
	.type	set_loc3_2_asm_h,@function
set_loc3_2_asm_h:                       // @set_loc3_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x27, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end710:
	.size	set_loc3_2_asm_h, .Lfunc_end710-set_loc3_2_asm_h
                                        // -- End function
	.hidden	get_arg0_2_asm_h                // -- Begin function get_arg0_2_asm_h
	.globl	get_arg0_2_asm_h
	.p2align	2
	.type	get_arg0_2_asm_h,@function
get_arg0_2_asm_h:                       // @get_arg0_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x28]
	add	w8, w8, #484
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end711:
	.size	get_arg0_2_asm_h, .Lfunc_end711-get_arg0_2_asm_h
                                        // -- End function
	.hidden	get_arg1_2_asm_h                // -- Begin function get_arg1_2_asm_h
	.globl	get_arg1_2_asm_h
	.p2align	2
	.type	get_arg1_2_asm_h,@function
get_arg1_2_asm_h:                       // @get_arg1_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x28, #8]
	add	w8, w8, #484
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end712:
	.size	get_arg1_2_asm_h, .Lfunc_end712-get_arg1_2_asm_h
                                        // -- End function
	.hidden	get_arg2_2_asm_h                // -- Begin function get_arg2_2_asm_h
	.globl	get_arg2_2_asm_h
	.p2align	2
	.type	get_arg2_2_asm_h,@function
get_arg2_2_asm_h:                       // @get_arg2_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x28, #16]
	add	w8, w8, #484
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end713:
	.size	get_arg2_2_asm_h, .Lfunc_end713-get_arg2_2_asm_h
                                        // -- End function
	.hidden	get_arg3_2_asm_h                // -- Begin function get_arg3_2_asm_h
	.globl	get_arg3_2_asm_h
	.p2align	2
	.type	get_arg3_2_asm_h,@function
get_arg3_2_asm_h:                       // @get_arg3_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x28, #24]
	add	w8, w8, #484
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end714:
	.size	get_arg3_2_asm_h, .Lfunc_end714-get_arg3_2_asm_h
                                        // -- End function
	.hidden	put_arg0_2_asm_h                // -- Begin function put_arg0_2_asm_h
	.globl	put_arg0_2_asm_h
	.p2align	2
	.type	put_arg0_2_asm_h,@function
put_arg0_2_asm_h:                       // @put_arg0_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end715:
	.size	put_arg0_2_asm_h, .Lfunc_end715-put_arg0_2_asm_h
                                        // -- End function
	.hidden	put_arg1_2_asm_h                // -- Begin function put_arg1_2_asm_h
	.globl	put_arg1_2_asm_h
	.p2align	2
	.type	put_arg1_2_asm_h,@function
put_arg1_2_asm_h:                       // @put_arg1_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end716:
	.size	put_arg1_2_asm_h, .Lfunc_end716-put_arg1_2_asm_h
                                        // -- End function
	.hidden	put_arg2_2_asm_h                // -- Begin function put_arg2_2_asm_h
	.globl	put_arg2_2_asm_h
	.p2align	2
	.type	put_arg2_2_asm_h,@function
put_arg2_2_asm_h:                       // @put_arg2_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end717:
	.size	put_arg2_2_asm_h, .Lfunc_end717-put_arg2_2_asm_h
                                        // -- End function
	.hidden	put_arg3_2_asm_h                // -- Begin function put_arg3_2_asm_h
	.globl	put_arg3_2_asm_h
	.p2align	2
	.type	put_arg3_2_asm_h,@function
put_arg3_2_asm_h:                       // @put_arg3_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end718:
	.size	put_arg3_2_asm_h, .Lfunc_end718-put_arg3_2_asm_h
                                        // -- End function
	.hidden	set_arg0_2_asm_h                // -- Begin function set_arg0_2_asm_h
	.globl	set_arg0_2_asm_h
	.p2align	2
	.type	set_arg0_2_asm_h,@function
set_arg0_2_asm_h:                       // @set_arg0_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end719:
	.size	set_arg0_2_asm_h, .Lfunc_end719-set_arg0_2_asm_h
                                        // -- End function
	.hidden	set_arg1_2_asm_h                // -- Begin function set_arg1_2_asm_h
	.globl	set_arg1_2_asm_h
	.p2align	2
	.type	set_arg1_2_asm_h,@function
set_arg1_2_asm_h:                       // @set_arg1_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end720:
	.size	set_arg1_2_asm_h, .Lfunc_end720-set_arg1_2_asm_h
                                        // -- End function
	.hidden	set_arg2_2_asm_h                // -- Begin function set_arg2_2_asm_h
	.globl	set_arg2_2_asm_h
	.p2align	2
	.type	set_arg2_2_asm_h,@function
set_arg2_2_asm_h:                       // @set_arg2_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end721:
	.size	set_arg2_2_asm_h, .Lfunc_end721-set_arg2_2_asm_h
                                        // -- End function
	.hidden	set_arg3_2_asm_h                // -- Begin function set_arg3_2_asm_h
	.globl	set_arg3_2_asm_h
	.p2align	2
	.type	set_arg3_2_asm_h,@function
set_arg3_2_asm_h:                       // @set_arg3_2_asm_h
// %bb.0:                               // %B0
	str	x21, [x28, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end722:
	.size	set_arg3_2_asm_h, .Lfunc_end722-set_arg3_2_asm_h
                                        // -- End function
	.hidden	get_var_ref0_2_asm_h            // -- Begin function get_var_ref0_2_asm_h
	.globl	get_var_ref0_2_asm_h
	.p2align	2
	.type	get_var_ref0_2_asm_h,@function
get_var_ref0_2_asm_h:                   // @get_var_ref0_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x26]
	ldrb	w9, [x19], #1
	ldr	x8, [x8, #32]
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8]
	mov	x21, x8
	br	x1
.Lfunc_end723:
	.size	get_var_ref0_2_asm_h, .Lfunc_end723-get_var_ref0_2_asm_h
                                        // -- End function
	.hidden	get_var_ref1_2_asm_h            // -- Begin function get_var_ref1_2_asm_h
	.globl	get_var_ref1_2_asm_h
	.p2align	2
	.type	get_var_ref1_2_asm_h,@function
get_var_ref1_2_asm_h:                   // @get_var_ref1_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x26, #8]
	ldrb	w9, [x19], #1
	ldr	x8, [x8, #32]
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8]
	mov	x21, x8
	br	x1
.Lfunc_end724:
	.size	get_var_ref1_2_asm_h, .Lfunc_end724-get_var_ref1_2_asm_h
                                        // -- End function
	.hidden	get_var_ref2_2_asm_h            // -- Begin function get_var_ref2_2_asm_h
	.globl	get_var_ref2_2_asm_h
	.p2align	2
	.type	get_var_ref2_2_asm_h,@function
get_var_ref2_2_asm_h:                   // @get_var_ref2_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x26, #16]
	ldrb	w9, [x19], #1
	ldr	x8, [x8, #32]
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8]
	mov	x21, x8
	br	x1
.Lfunc_end725:
	.size	get_var_ref2_2_asm_h, .Lfunc_end725-get_var_ref2_2_asm_h
                                        // -- End function
	.hidden	get_var_ref3_2_asm_h            // -- Begin function get_var_ref3_2_asm_h
	.globl	get_var_ref3_2_asm_h
	.p2align	2
	.type	get_var_ref3_2_asm_h,@function
get_var_ref3_2_asm_h:                   // @get_var_ref3_2_asm_h
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x26, #24]
	ldrb	w9, [x19], #1
	ldr	x8, [x8, #32]
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8]
	mov	x21, x8
	br	x1
.Lfunc_end726:
	.size	get_var_ref3_2_asm_h, .Lfunc_end726-get_var_ref3_2_asm_h
                                        // -- End function
	.hidden	put_var_ref0_2_asm_h            // -- Begin function put_var_ref0_2_asm_h
	.globl	put_var_ref0_2_asm_h
	.p2align	2
	.type	put_var_ref0_2_asm_h,@function
put_var_ref0_2_asm_h:                   // @put_var_ref0_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end727:
	.size	put_var_ref0_2_asm_h, .Lfunc_end727-put_var_ref0_2_asm_h
                                        // -- End function
	.hidden	put_var_ref1_2_asm_h            // -- Begin function put_var_ref1_2_asm_h
	.globl	put_var_ref1_2_asm_h
	.p2align	2
	.type	put_var_ref1_2_asm_h,@function
put_var_ref1_2_asm_h:                   // @put_var_ref1_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end728:
	.size	put_var_ref1_2_asm_h, .Lfunc_end728-put_var_ref1_2_asm_h
                                        // -- End function
	.hidden	put_var_ref2_2_asm_h            // -- Begin function put_var_ref2_2_asm_h
	.globl	put_var_ref2_2_asm_h
	.p2align	2
	.type	put_var_ref2_2_asm_h,@function
put_var_ref2_2_asm_h:                   // @put_var_ref2_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end729:
	.size	put_var_ref2_2_asm_h, .Lfunc_end729-put_var_ref2_2_asm_h
                                        // -- End function
	.hidden	put_var_ref3_2_asm_h            // -- Begin function put_var_ref3_2_asm_h
	.globl	put_var_ref3_2_asm_h
	.p2align	2
	.type	put_var_ref3_2_asm_h,@function
put_var_ref3_2_asm_h:                   // @put_var_ref3_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end730:
	.size	put_var_ref3_2_asm_h, .Lfunc_end730-put_var_ref3_2_asm_h
                                        // -- End function
	.hidden	set_var_ref0_2_asm_h            // -- Begin function set_var_ref0_2_asm_h
	.globl	set_var_ref0_2_asm_h
	.p2align	2
	.type	set_var_ref0_2_asm_h,@function
set_var_ref0_2_asm_h:                   // @set_var_ref0_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26]
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end731:
	.size	set_var_ref0_2_asm_h, .Lfunc_end731-set_var_ref0_2_asm_h
                                        // -- End function
	.hidden	set_var_ref1_2_asm_h            // -- Begin function set_var_ref1_2_asm_h
	.globl	set_var_ref1_2_asm_h
	.p2align	2
	.type	set_var_ref1_2_asm_h,@function
set_var_ref1_2_asm_h:                   // @set_var_ref1_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end732:
	.size	set_var_ref1_2_asm_h, .Lfunc_end732-set_var_ref1_2_asm_h
                                        // -- End function
	.hidden	set_var_ref2_2_asm_h            // -- Begin function set_var_ref2_2_asm_h
	.globl	set_var_ref2_2_asm_h
	.p2align	2
	.type	set_var_ref2_2_asm_h,@function
set_var_ref2_2_asm_h:                   // @set_var_ref2_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end733:
	.size	set_var_ref2_2_asm_h, .Lfunc_end733-set_var_ref2_2_asm_h
                                        // -- End function
	.hidden	set_var_ref3_2_asm_h            // -- Begin function set_var_ref3_2_asm_h
	.globl	set_var_ref3_2_asm_h
	.p2align	2
	.type	set_var_ref3_2_asm_h,@function
set_var_ref3_2_asm_h:                   // @set_var_ref3_2_asm_h
// %bb.0:                               // %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end734:
	.size	set_var_ref3_2_asm_h, .Lfunc_end734-set_var_ref3_2_asm_h
                                        // -- End function
	.hidden	get_length_2_asm_h              // -- Begin function get_length_2_asm_h
	.globl	get_length_2_asm_h
	.p2align	2
	.type	get_length_2_asm_h,@function
get_length_2_asm_h:                     // @get_length_2_asm_h
// %bb.0:                               // %B24
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	.LBB735_10
// %bb.1:                               // %B25
	mov	x9, x21
	mov	w8, #18                         // =0x12
.LBB735_2:                              // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB735_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	mvn	w10, w10
	orr	w10, w10, #0xffffffcf
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB735_5
.LBB735_3:                              // %B1
                                        //   Parent Loop BB735_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, #48
	b.eq	.LBB735_7
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB735_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB735_3
.LBB735_5:                              // %B14
                                        //   in Loop: Header=BB735_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB735_10
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB735_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, .LBB735_2
	b	.LBB735_9
.LBB735_7:                              // %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	.LBB735_10
// %bb.8:                               // %B4
	lsl	w8, w10, #1
	ldr	x9, [x9, #16]
	sub	w8, w8, #2
	ldr	x8, [x9, w8, sxtw #3]
.LBB735_9:                              // %B6
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #484
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
.LBB735_10:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #48                         // =0x30
	mov	x3, x21
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB735_12
// %bb.11:                              // %B23
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB735_12:                             // %B22
	b	exception_spill_top0_top1_asm_h
.Lfunc_end735:
	.size	get_length_2_asm_h, .Lfunc_end735-get_length_2_asm_h
                                        // -- End function
	.hidden	if_false8_2_asm_h               // -- Begin function if_false8_2_asm_h
	.globl	if_false8_2_asm_h
	.p2align	2
	.type	if_false8_2_asm_h,@function
if_false8_2_asm_h:                      // @if_false8_2_asm_h
// %bb.0:                               // %B23
	cmp	x21, #5
	b.le	.LBB736_4
// %bb.1:                               // %B23
	cmp	x21, #6
	b.eq	.LBB736_6
// %bb.2:                               // %B23
	cmp	x21, #7
	b.eq	.LBB736_9
// %bb.3:                               // %B23
	cmp	x21, #18
	b.eq	.LBB736_6
	b	.LBB736_7
.LBB736_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB736_6
// %bb.5:                               // %B23
	cmp	x21, #2
	b.ne	.LBB736_7
.LBB736_6:                              // %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB736_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x21, x8
	b.hs	.LBB736_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB736_10
.LBB736_9:                              // %B19
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB736_10:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB736_13
// %bb.11:                              // %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB736_6
	b.vs	.LBB736_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB736_9
	b	.LBB736_6
.LBB736_13:                             // %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	SlowToBoolean_asm_h
.Lfunc_end736:
	.size	if_false8_2_asm_h, .Lfunc_end736-if_false8_2_asm_h
                                        // -- End function
	.hidden	if_true8_2_asm_h                // -- Begin function if_true8_2_asm_h
	.globl	if_true8_2_asm_h
	.p2align	2
	.type	if_true8_2_asm_h,@function
if_true8_2_asm_h:                       // @if_true8_2_asm_h
// %bb.0:                               // %B23
	cmp	x21, #5
	b.le	.LBB737_4
// %bb.1:                               // %B23
	cmp	x21, #6
	b.eq	.LBB737_6
// %bb.2:                               // %B23
	cmp	x21, #7
	b.eq	.LBB737_9
// %bb.3:                               // %B23
	cmp	x21, #18
	b.eq	.LBB737_6
	b	.LBB737_7
.LBB737_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB737_6
// %bb.5:                               // %B23
	cmp	x21, #2
	b.ne	.LBB737_7
.LBB737_6:                              // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB737_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x21, x8
	b.hs	.LBB737_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB737_10
.LBB737_9:                              // %B19
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #242
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB737_10:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB737_13
// %bb.11:                              // %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB737_6
	b.vs	.LBB737_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB737_9
	b	.LBB737_6
.LBB737_13:                             // %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	SlowToBoolean_asm_h
.Lfunc_end737:
	.size	if_true8_2_asm_h, .Lfunc_end737-if_true8_2_asm_h
                                        // -- End function
	.hidden	goto8_2_asm_h                   // -- Begin function goto8_2_asm_h
	.globl	goto8_2_asm_h
	.p2align	2
	.type	goto8_2_asm_h,@function
goto8_2_asm_h:                          // @goto8_2_asm_h
// %bb.0:                               // %B0
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end738:
	.size	goto8_2_asm_h, .Lfunc_end738-goto8_2_asm_h
                                        // -- End function
	.hidden	goto16_2_asm_h                  // -- Begin function goto16_2_asm_h
	.globl	goto16_2_asm_h
	.p2align	2
	.type	goto16_2_asm_h,@function
goto16_2_asm_h:                         // @goto16_2_asm_h
// %bb.0:                               // %B0
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end739:
	.size	goto16_2_asm_h, .Lfunc_end739-goto16_2_asm_h
                                        // -- End function
	.hidden	call0_2_asm_h                   // -- Begin function call0_2_asm_h
	.globl	call0_2_asm_h
	.p2align	2
	.type	call0_2_asm_h,@function
call0_2_asm_h:                          // @call0_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	call0_0_asm_h
.Lfunc_end740:
	.size	call0_2_asm_h, .Lfunc_end740-call0_2_asm_h
                                        // -- End function
	.hidden	call1_2_asm_h                   // -- Begin function call1_2_asm_h
	.globl	call1_2_asm_h
	.p2align	2
	.type	call1_2_asm_h,@function
call1_2_asm_h:                          // @call1_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	call1_0_asm_h
.Lfunc_end741:
	.size	call1_2_asm_h, .Lfunc_end741-call1_2_asm_h
                                        // -- End function
	.hidden	call2_2_asm_h                   // -- Begin function call2_2_asm_h
	.globl	call2_2_asm_h
	.p2align	2
	.type	call2_2_asm_h,@function
call2_2_asm_h:                          // @call2_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	call2_0_asm_h
.Lfunc_end742:
	.size	call2_2_asm_h, .Lfunc_end742-call2_2_asm_h
                                        // -- End function
	.hidden	call3_2_asm_h                   // -- Begin function call3_2_asm_h
	.globl	call3_2_asm_h
	.p2align	2
	.type	call3_2_asm_h,@function
call3_2_asm_h:                          // @call3_2_asm_h
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	call3_0_asm_h
.Lfunc_end743:
	.size	call3_2_asm_h, .Lfunc_end743-call3_2_asm_h
                                        // -- End function
	.hidden	is_undefined_2_asm_h            // -- Begin function is_undefined_2_asm_h
	.globl	is_undefined_2_asm_h
	.p2align	2
	.type	is_undefined_2_asm_h,@function
is_undefined_2_asm_h:                   // @is_undefined_2_asm_h
// %bb.0:                               // %B2
	cmp	x21, #18
	b.ne	.LBB744_2
// %bb.1:                               // %B3
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB744_2:                              // %B5
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end744:
	.size	is_undefined_2_asm_h, .Lfunc_end744-is_undefined_2_asm_h
                                        // -- End function
	.hidden	is_null_2_asm_h                 // -- Begin function is_null_2_asm_h
	.globl	is_null_2_asm_h
	.p2align	2
	.type	is_null_2_asm_h,@function
is_null_2_asm_h:                        // @is_null_2_asm_h
// %bb.0:                               // %B2
	cmp	x21, #2
	b.ne	.LBB745_2
// %bb.1:                               // %B3
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB745_2:                              // %B5
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end745:
	.size	is_null_2_asm_h, .Lfunc_end745-is_null_2_asm_h
                                        // -- End function
	.hidden	is_function_2_asm_h             // -- Begin function is_function_2_asm_h
	.globl	is_function_2_asm_h
	.p2align	2
	.type	is_function_2_asm_h,@function
is_function_2_asm_h:                    // @is_function_2_asm_h
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x21
	bl	js_operator_typeof_gc
	cmp	w0, #27
	b.ne	.LBB746_2
// %bb.1:                               // %B2
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.LBB746_2:                              // %B5
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #484
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
.Lfunc_end746:
	.size	is_function_2_asm_h, .Lfunc_end746-is_function_2_asm_h
                                        // -- End function
	.hidden	InstallBcHandler                // -- Begin function InstallBcHandler
	.globl	InstallBcHandler
	.p2align	2
	.type	InstallBcHandler,@function
InstallBcHandler:                       // @InstallBcHandler
	.cfi_startproc
// %bb.0:                               // %B0
	stp	x29, x30, [sp, #-16]!           // 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	adrp	x8, invalid_0_asm_h
	add	x8, x8, :lo12:invalid_0_asm_h
	adrp	x9, push_i32_0_asm_h
	add	x9, x9, :lo12:push_i32_0_asm_h
	stp	x8, x9, [x0]
	adrp	x8, push_const_0_asm_h
	add	x8, x8, :lo12:push_const_0_asm_h
	adrp	x9, fclosure_0_asm_h
	add	x9, x9, :lo12:fclosure_0_asm_h
	stp	x8, x9, [x0, #16]
	adrp	x8, push_atom_value_0_asm_h
	add	x8, x8, :lo12:push_atom_value_0_asm_h
	adrp	x9, private_symbol_0_asm_h
	add	x9, x9, :lo12:private_symbol_0_asm_h
	stp	x8, x9, [x0, #32]
	adrp	x8, undefined_0_asm_h
	add	x8, x8, :lo12:undefined_0_asm_h
	adrp	x9, null_0_asm_h
	add	x9, x9, :lo12:null_0_asm_h
	stp	x8, x9, [x0, #48]
	adrp	x8, push_this_0_asm_h
	add	x8, x8, :lo12:push_this_0_asm_h
	adrp	x9, push_false_0_asm_h
	add	x9, x9, :lo12:push_false_0_asm_h
	stp	x8, x9, [x0, #64]
	adrp	x8, push_true_0_asm_h
	add	x8, x8, :lo12:push_true_0_asm_h
	adrp	x9, object_0_asm_h
	add	x9, x9, :lo12:object_0_asm_h
	stp	x8, x9, [x0, #80]
	adrp	x8, special_object_0_asm_h
	add	x8, x8, :lo12:special_object_0_asm_h
	adrp	x9, rest_0_asm_h
	add	x9, x9, :lo12:rest_0_asm_h
	stp	x8, x9, [x0, #96]
	adrp	x8, drop_0_asm_h
	add	x8, x8, :lo12:drop_0_asm_h
	adrp	x9, nip_0_asm_h
	add	x9, x9, :lo12:nip_0_asm_h
	stp	x8, x9, [x0, #112]
	adrp	x8, nip1_0_asm_h
	add	x8, x8, :lo12:nip1_0_asm_h
	adrp	x9, dup_0_asm_h
	add	x9, x9, :lo12:dup_0_asm_h
	stp	x8, x9, [x0, #128]
	adrp	x8, dup1_0_asm_h
	add	x8, x8, :lo12:dup1_0_asm_h
	adrp	x9, dup2_0_asm_h
	add	x9, x9, :lo12:dup2_0_asm_h
	stp	x8, x9, [x0, #144]
	adrp	x8, dup3_0_asm_h
	add	x8, x8, :lo12:dup3_0_asm_h
	adrp	x9, insert2_0_asm_h
	add	x9, x9, :lo12:insert2_0_asm_h
	stp	x8, x9, [x0, #160]
	adrp	x8, insert3_0_asm_h
	add	x8, x8, :lo12:insert3_0_asm_h
	adrp	x9, insert4_0_asm_h
	add	x9, x9, :lo12:insert4_0_asm_h
	stp	x8, x9, [x0, #176]
	adrp	x8, perm3_0_asm_h
	add	x8, x8, :lo12:perm3_0_asm_h
	adrp	x9, perm4_0_asm_h
	add	x9, x9, :lo12:perm4_0_asm_h
	stp	x8, x9, [x0, #192]
	adrp	x8, perm5_0_asm_h
	add	x8, x8, :lo12:perm5_0_asm_h
	adrp	x9, swap_0_asm_h
	add	x9, x9, :lo12:swap_0_asm_h
	stp	x8, x9, [x0, #208]
	adrp	x8, swap2_0_asm_h
	add	x8, x8, :lo12:swap2_0_asm_h
	adrp	x9, rot3l_0_asm_h
	add	x9, x9, :lo12:rot3l_0_asm_h
	stp	x8, x9, [x0, #224]
	adrp	x8, rot3r_0_asm_h
	add	x8, x8, :lo12:rot3r_0_asm_h
	adrp	x9, rot4l_0_asm_h
	add	x9, x9, :lo12:rot4l_0_asm_h
	stp	x8, x9, [x0, #240]
	adrp	x8, rot5l_0_asm_h
	add	x8, x8, :lo12:rot5l_0_asm_h
	adrp	x9, call_constructor_0_asm_h
	add	x9, x9, :lo12:call_constructor_0_asm_h
	stp	x8, x9, [x0, #256]
	adrp	x8, call_0_asm_h
	add	x8, x8, :lo12:call_0_asm_h
	adrp	x9, tail_call_0_asm_h
	add	x9, x9, :lo12:tail_call_0_asm_h
	stp	x8, x9, [x0, #272]
	adrp	x8, call_method_0_asm_h
	add	x8, x8, :lo12:call_method_0_asm_h
	adrp	x9, tail_call_method_0_asm_h
	add	x9, x9, :lo12:tail_call_method_0_asm_h
	stp	x8, x9, [x0, #288]
	adrp	x8, array_from_0_asm_h
	add	x8, x8, :lo12:array_from_0_asm_h
	adrp	x9, apply_0_asm_h
	add	x9, x9, :lo12:apply_0_asm_h
	stp	x8, x9, [x0, #304]
	adrp	x8, return_0_asm_h
	add	x8, x8, :lo12:return_0_asm_h
	adrp	x9, return_undef_0_asm_h
	add	x9, x9, :lo12:return_undef_0_asm_h
	stp	x8, x9, [x0, #320]
	adrp	x8, check_ctor_return_0_asm_h
	add	x8, x8, :lo12:check_ctor_return_0_asm_h
	adrp	x9, check_ctor_0_asm_h
	add	x9, x9, :lo12:check_ctor_0_asm_h
	stp	x8, x9, [x0, #336]
	adrp	x8, check_brand_0_asm_h
	add	x8, x8, :lo12:check_brand_0_asm_h
	adrp	x9, add_brand_0_asm_h
	add	x9, x9, :lo12:add_brand_0_asm_h
	stp	x8, x9, [x0, #352]
	adrp	x8, return_async_0_asm_h
	add	x8, x8, :lo12:return_async_0_asm_h
	adrp	x9, throw_0_asm_h
	add	x9, x9, :lo12:throw_0_asm_h
	stp	x8, x9, [x0, #368]
	adrp	x8, throw_var_0_asm_h
	add	x8, x8, :lo12:throw_var_0_asm_h
	adrp	x9, eval_0_asm_h
	add	x9, x9, :lo12:eval_0_asm_h
	stp	x8, x9, [x0, #384]
	adrp	x8, regexp_0_asm_h
	add	x8, x8, :lo12:regexp_0_asm_h
	adrp	x9, get_super_ctor_0_asm_h
	add	x9, x9, :lo12:get_super_ctor_0_asm_h
	stp	x8, x9, [x0, #400]
	adrp	x8, get_super_0_asm_h
	add	x8, x8, :lo12:get_super_0_asm_h
	adrp	x9, import_0_asm_h
	add	x9, x9, :lo12:import_0_asm_h
	stp	x8, x9, [x0, #416]
	adrp	x8, check_var_0_asm_h
	add	x8, x8, :lo12:check_var_0_asm_h
	adrp	x9, get_var_undef_0_asm_h
	add	x9, x9, :lo12:get_var_undef_0_asm_h
	stp	x8, x9, [x0, #432]
	adrp	x8, get_var_0_asm_h
	add	x8, x8, :lo12:get_var_0_asm_h
	adrp	x9, put_var_0_asm_h
	add	x9, x9, :lo12:put_var_0_asm_h
	stp	x8, x9, [x0, #448]
	adrp	x8, put_var_init_0_asm_h
	add	x8, x8, :lo12:put_var_init_0_asm_h
	adrp	x9, put_var_strict_0_asm_h
	add	x9, x9, :lo12:put_var_strict_0_asm_h
	stp	x8, x9, [x0, #464]
	adrp	x8, get_ref_value_0_asm_h
	add	x8, x8, :lo12:get_ref_value_0_asm_h
	adrp	x9, put_ref_value_0_asm_h
	add	x9, x9, :lo12:put_ref_value_0_asm_h
	stp	x8, x9, [x0, #480]
	adrp	x8, define_var_0_asm_h
	add	x8, x8, :lo12:define_var_0_asm_h
	adrp	x9, check_define_var_0_asm_h
	add	x9, x9, :lo12:check_define_var_0_asm_h
	stp	x8, x9, [x0, #496]
	adrp	x8, define_func_0_asm_h
	add	x8, x8, :lo12:define_func_0_asm_h
	str	x8, [x0, #512]
	adrp	x8, get_field_0_asm_h
	add	x8, x8, :lo12:get_field_0_asm_h
	str	x8, [x0, #520]
	adrp	x8, get_field2_0_asm_h
	add	x8, x8, :lo12:get_field2_0_asm_h
	str	x8, [x0, #528]
	adrp	x8, put_field_0_asm_h
	add	x8, x8, :lo12:put_field_0_asm_h
	str	x8, [x0, #536]
	adrp	x8, get_private_field_0_asm_h
	add	x8, x8, :lo12:get_private_field_0_asm_h
	str	x8, [x0, #544]
	adrp	x8, put_private_field_0_asm_h
	add	x8, x8, :lo12:put_private_field_0_asm_h
	str	x8, [x0, #552]
	adrp	x8, define_private_field_0_asm_h
	add	x8, x8, :lo12:define_private_field_0_asm_h
	str	x8, [x0, #560]
	adrp	x8, get_array_el_0_asm_h
	add	x8, x8, :lo12:get_array_el_0_asm_h
	str	x8, [x0, #568]
	adrp	x8, get_array_el2_0_asm_h
	add	x8, x8, :lo12:get_array_el2_0_asm_h
	str	x8, [x0, #576]
	adrp	x8, put_array_el_0_asm_h
	add	x8, x8, :lo12:put_array_el_0_asm_h
	str	x8, [x0, #584]
	adrp	x8, get_super_value_0_asm_h
	add	x8, x8, :lo12:get_super_value_0_asm_h
	str	x8, [x0, #592]
	adrp	x8, put_super_value_0_asm_h
	add	x8, x8, :lo12:put_super_value_0_asm_h
	str	x8, [x0, #600]
	adrp	x8, define_field_0_asm_h
	add	x8, x8, :lo12:define_field_0_asm_h
	str	x8, [x0, #608]
	adrp	x8, set_name_0_asm_h
	add	x8, x8, :lo12:set_name_0_asm_h
	str	x8, [x0, #616]
	adrp	x8, set_name_computed_0_asm_h
	add	x8, x8, :lo12:set_name_computed_0_asm_h
	str	x8, [x0, #624]
	adrp	x8, set_proto_0_asm_h
	add	x8, x8, :lo12:set_proto_0_asm_h
	str	x8, [x0, #632]
	adrp	x8, set_home_object_0_asm_h
	add	x8, x8, :lo12:set_home_object_0_asm_h
	str	x8, [x0, #640]
	adrp	x8, define_array_el_0_asm_h
	add	x8, x8, :lo12:define_array_el_0_asm_h
	str	x8, [x0, #648]
	adrp	x8, append_0_asm_h
	add	x8, x8, :lo12:append_0_asm_h
	str	x8, [x0, #656]
	adrp	x8, copy_data_properties_0_asm_h
	add	x8, x8, :lo12:copy_data_properties_0_asm_h
	str	x8, [x0, #664]
	adrp	x8, define_method_0_asm_h
	add	x8, x8, :lo12:define_method_0_asm_h
	str	x8, [x0, #672]
	adrp	x8, define_method_computed_0_asm_h
	add	x8, x8, :lo12:define_method_computed_0_asm_h
	str	x8, [x0, #680]
	adrp	x8, define_class_0_asm_h
	add	x8, x8, :lo12:define_class_0_asm_h
	str	x8, [x0, #688]
	adrp	x8, get_loc_0_asm_h
	add	x8, x8, :lo12:get_loc_0_asm_h
	str	x8, [x0, #696]
	adrp	x8, put_loc_0_asm_h
	add	x8, x8, :lo12:put_loc_0_asm_h
	str	x8, [x0, #704]
	adrp	x8, set_loc_0_asm_h
	add	x8, x8, :lo12:set_loc_0_asm_h
	str	x8, [x0, #712]
	adrp	x8, get_arg_0_asm_h
	add	x8, x8, :lo12:get_arg_0_asm_h
	str	x8, [x0, #720]
	adrp	x8, put_arg_0_asm_h
	add	x8, x8, :lo12:put_arg_0_asm_h
	str	x8, [x0, #728]
	adrp	x8, set_arg_0_asm_h
	add	x8, x8, :lo12:set_arg_0_asm_h
	str	x8, [x0, #736]
	adrp	x8, get_var_ref_0_asm_h
	add	x8, x8, :lo12:get_var_ref_0_asm_h
	str	x8, [x0, #744]
	adrp	x8, put_var_ref_0_asm_h
	add	x8, x8, :lo12:put_var_ref_0_asm_h
	str	x8, [x0, #752]
	adrp	x8, set_var_ref_0_asm_h
	add	x8, x8, :lo12:set_var_ref_0_asm_h
	str	x8, [x0, #760]
	adrp	x8, set_loc_uninitialized_0_asm_h
	add	x8, x8, :lo12:set_loc_uninitialized_0_asm_h
	str	x8, [x0, #768]
	adrp	x8, get_loc_check_0_asm_h
	add	x8, x8, :lo12:get_loc_check_0_asm_h
	str	x8, [x0, #776]
	adrp	x8, put_loc_check_0_asm_h
	add	x8, x8, :lo12:put_loc_check_0_asm_h
	str	x8, [x0, #784]
	adrp	x8, put_loc_check_init_0_asm_h
	add	x8, x8, :lo12:put_loc_check_init_0_asm_h
	str	x8, [x0, #792]
	adrp	x8, get_var_ref_check_0_asm_h
	add	x8, x8, :lo12:get_var_ref_check_0_asm_h
	str	x8, [x0, #800]
	adrp	x8, put_var_ref_check_0_asm_h
	add	x8, x8, :lo12:put_var_ref_check_0_asm_h
	str	x8, [x0, #808]
	adrp	x8, put_var_ref_check_init_0_asm_h
	add	x8, x8, :lo12:put_var_ref_check_init_0_asm_h
	str	x8, [x0, #816]
	adrp	x8, close_loc_0_asm_h
	add	x8, x8, :lo12:close_loc_0_asm_h
	str	x8, [x0, #824]
	adrp	x8, if_false_0_asm_h
	add	x8, x8, :lo12:if_false_0_asm_h
	str	x8, [x0, #832]
	adrp	x8, if_true_0_asm_h
	add	x8, x8, :lo12:if_true_0_asm_h
	str	x8, [x0, #840]
	adrp	x8, goto_0_asm_h
	add	x8, x8, :lo12:goto_0_asm_h
	str	x8, [x0, #848]
	adrp	x8, catch_0_asm_h
	add	x8, x8, :lo12:catch_0_asm_h
	str	x8, [x0, #856]
	adrp	x8, gosub_0_asm_h
	add	x8, x8, :lo12:gosub_0_asm_h
	str	x8, [x0, #864]
	adrp	x8, ret_0_asm_h
	add	x8, x8, :lo12:ret_0_asm_h
	str	x8, [x0, #872]
	adrp	x8, to_object_0_asm_h
	add	x8, x8, :lo12:to_object_0_asm_h
	str	x8, [x0, #880]
	adrp	x8, to_propkey_0_asm_h
	add	x8, x8, :lo12:to_propkey_0_asm_h
	str	x8, [x0, #888]
	adrp	x8, to_propkey2_0_asm_h
	add	x8, x8, :lo12:to_propkey2_0_asm_h
	str	x8, [x0, #896]
	adrp	x8, with_get_var_0_asm_h
	add	x8, x8, :lo12:with_get_var_0_asm_h
	str	x8, [x0, #904]
	adrp	x8, with_put_var_0_asm_h
	add	x8, x8, :lo12:with_put_var_0_asm_h
	str	x8, [x0, #912]
	adrp	x8, with_delete_var_0_asm_h
	add	x8, x8, :lo12:with_delete_var_0_asm_h
	str	x8, [x0, #920]
	adrp	x8, with_make_ref_0_asm_h
	add	x8, x8, :lo12:with_make_ref_0_asm_h
	str	x8, [x0, #928]
	adrp	x8, with_get_ref_0_asm_h
	add	x8, x8, :lo12:with_get_ref_0_asm_h
	str	x8, [x0, #936]
	adrp	x8, with_get_ref_undef_0_asm_h
	add	x8, x8, :lo12:with_get_ref_undef_0_asm_h
	str	x8, [x0, #944]
	adrp	x8, make_loc_ref_0_asm_h
	add	x8, x8, :lo12:make_loc_ref_0_asm_h
	str	x8, [x0, #952]
	adrp	x8, make_arg_ref_0_asm_h
	add	x8, x8, :lo12:make_arg_ref_0_asm_h
	str	x8, [x0, #960]
	adrp	x8, make_var_ref_ref_0_asm_h
	add	x8, x8, :lo12:make_var_ref_ref_0_asm_h
	str	x8, [x0, #968]
	adrp	x8, make_var_ref_0_asm_h
	add	x8, x8, :lo12:make_var_ref_0_asm_h
	str	x8, [x0, #976]
	adrp	x8, for_in_start_0_asm_h
	add	x8, x8, :lo12:for_in_start_0_asm_h
	str	x8, [x0, #984]
	adrp	x8, for_of_start_0_asm_h
	add	x8, x8, :lo12:for_of_start_0_asm_h
	str	x8, [x0, #992]
	adrp	x8, for_await_of_start_0_asm_h
	add	x8, x8, :lo12:for_await_of_start_0_asm_h
	str	x8, [x0, #1000]
	adrp	x8, for_in_next_0_asm_h
	add	x8, x8, :lo12:for_in_next_0_asm_h
	str	x8, [x0, #1008]
	adrp	x8, for_of_next_0_asm_h
	add	x8, x8, :lo12:for_of_next_0_asm_h
	str	x8, [x0, #1016]
	adrp	x8, for_await_of_next_0_asm_h
	add	x8, x8, :lo12:for_await_of_next_0_asm_h
	str	x8, [x0, #1024]
	adrp	x8, iterator_get_value_done_0_asm_h
	add	x8, x8, :lo12:iterator_get_value_done_0_asm_h
	str	x8, [x0, #1032]
	adrp	x8, iterator_close_0_asm_h
	add	x8, x8, :lo12:iterator_close_0_asm_h
	str	x8, [x0, #1040]
	adrp	x8, iterator_close_return_0_asm_h
	add	x8, x8, :lo12:iterator_close_return_0_asm_h
	str	x8, [x0, #1048]
	adrp	x8, async_iterator_close_0_asm_h
	add	x8, x8, :lo12:async_iterator_close_0_asm_h
	str	x8, [x0, #1056]
	adrp	x8, async_iterator_next_0_asm_h
	add	x8, x8, :lo12:async_iterator_next_0_asm_h
	str	x8, [x0, #1064]
	adrp	x8, async_iterator_get_0_asm_h
	add	x8, x8, :lo12:async_iterator_get_0_asm_h
	str	x8, [x0, #1072]
	adrp	x8, initial_yield_0_asm_h
	add	x8, x8, :lo12:initial_yield_0_asm_h
	str	x8, [x0, #1080]
	adrp	x8, yield_0_asm_h
	add	x8, x8, :lo12:yield_0_asm_h
	str	x8, [x0, #1088]
	adrp	x8, yield_star_0_asm_h
	add	x8, x8, :lo12:yield_star_0_asm_h
	str	x8, [x0, #1096]
	adrp	x8, async_yield_star_0_asm_h
	add	x8, x8, :lo12:async_yield_star_0_asm_h
	str	x8, [x0, #1104]
	adrp	x8, await_0_asm_h
	add	x8, x8, :lo12:await_0_asm_h
	str	x8, [x0, #1112]
	adrp	x8, neg_0_asm_h
	add	x8, x8, :lo12:neg_0_asm_h
	str	x8, [x0, #1120]
	adrp	x8, plus_0_asm_h
	add	x8, x8, :lo12:plus_0_asm_h
	str	x8, [x0, #1128]
	adrp	x8, dec_0_asm_h
	add	x8, x8, :lo12:dec_0_asm_h
	str	x8, [x0, #1136]
	adrp	x8, inc_0_asm_h
	add	x8, x8, :lo12:inc_0_asm_h
	str	x8, [x0, #1144]
	adrp	x8, post_dec_0_asm_h
	add	x8, x8, :lo12:post_dec_0_asm_h
	str	x8, [x0, #1152]
	adrp	x8, post_inc_0_asm_h
	add	x8, x8, :lo12:post_inc_0_asm_h
	str	x8, [x0, #1160]
	adrp	x8, dec_loc_0_asm_h
	add	x8, x8, :lo12:dec_loc_0_asm_h
	str	x8, [x0, #1168]
	adrp	x8, inc_loc_0_asm_h
	add	x8, x8, :lo12:inc_loc_0_asm_h
	str	x8, [x0, #1176]
	adrp	x8, add_loc_0_asm_h
	add	x8, x8, :lo12:add_loc_0_asm_h
	str	x8, [x0, #1184]
	adrp	x8, not_0_asm_h
	add	x8, x8, :lo12:not_0_asm_h
	str	x8, [x0, #1192]
	adrp	x8, lnot_0_asm_h
	add	x8, x8, :lo12:lnot_0_asm_h
	str	x8, [x0, #1200]
	adrp	x8, typeof_0_asm_h
	add	x8, x8, :lo12:typeof_0_asm_h
	str	x8, [x0, #1208]
	adrp	x8, delete_0_asm_h
	add	x8, x8, :lo12:delete_0_asm_h
	str	x8, [x0, #1216]
	adrp	x8, delete_var_0_asm_h
	add	x8, x8, :lo12:delete_var_0_asm_h
	str	x8, [x0, #1224]
	adrp	x8, mul_0_asm_h
	add	x8, x8, :lo12:mul_0_asm_h
	str	x8, [x0, #1232]
	adrp	x8, div_0_asm_h
	add	x8, x8, :lo12:div_0_asm_h
	str	x8, [x0, #1240]
	adrp	x8, mod_0_asm_h
	add	x8, x8, :lo12:mod_0_asm_h
	str	x8, [x0, #1248]
	adrp	x8, add_0_asm_h
	add	x8, x8, :lo12:add_0_asm_h
	str	x8, [x0, #1256]
	adrp	x8, sub_0_asm_h
	add	x8, x8, :lo12:sub_0_asm_h
	str	x8, [x0, #1264]
	adrp	x8, pow_0_asm_h
	add	x8, x8, :lo12:pow_0_asm_h
	str	x8, [x0, #1272]
	adrp	x8, shl_0_asm_h
	add	x8, x8, :lo12:shl_0_asm_h
	str	x8, [x0, #1280]
	adrp	x8, sar_0_asm_h
	add	x8, x8, :lo12:sar_0_asm_h
	str	x8, [x0, #1288]
	adrp	x8, shr_0_asm_h
	add	x8, x8, :lo12:shr_0_asm_h
	str	x8, [x0, #1296]
	adrp	x8, lt_0_asm_h
	add	x8, x8, :lo12:lt_0_asm_h
	str	x8, [x0, #1304]
	adrp	x8, lte_0_asm_h
	add	x8, x8, :lo12:lte_0_asm_h
	str	x8, [x0, #1312]
	adrp	x8, gt_0_asm_h
	add	x8, x8, :lo12:gt_0_asm_h
	str	x8, [x0, #1320]
	adrp	x8, gte_0_asm_h
	add	x8, x8, :lo12:gte_0_asm_h
	str	x8, [x0, #1328]
	adrp	x8, instanceof_0_asm_h
	add	x8, x8, :lo12:instanceof_0_asm_h
	str	x8, [x0, #1336]
	adrp	x8, in_0_asm_h
	add	x8, x8, :lo12:in_0_asm_h
	str	x8, [x0, #1344]
	adrp	x8, eq_0_asm_h
	add	x8, x8, :lo12:eq_0_asm_h
	str	x8, [x0, #1352]
	adrp	x8, neq_0_asm_h
	add	x8, x8, :lo12:neq_0_asm_h
	str	x8, [x0, #1360]
	adrp	x8, strict_eq_0_asm_h
	add	x8, x8, :lo12:strict_eq_0_asm_h
	str	x8, [x0, #1368]
	adrp	x8, strict_neq_0_asm_h
	add	x8, x8, :lo12:strict_neq_0_asm_h
	str	x8, [x0, #1376]
	adrp	x8, and_0_asm_h
	add	x8, x8, :lo12:and_0_asm_h
	str	x8, [x0, #1384]
	adrp	x8, xor_0_asm_h
	add	x8, x8, :lo12:xor_0_asm_h
	str	x8, [x0, #1392]
	adrp	x8, or_0_asm_h
	add	x8, x8, :lo12:or_0_asm_h
	str	x8, [x0, #1400]
	adrp	x8, nop_0_asm_h
	add	x8, x8, :lo12:nop_0_asm_h
	str	x8, [x0, #1408]
	adrp	x8, push_minus1_0_asm_h
	add	x8, x8, :lo12:push_minus1_0_asm_h
	str	x8, [x0, #1416]
	adrp	x8, push_0_0_asm_h
	add	x8, x8, :lo12:push_0_0_asm_h
	str	x8, [x0, #1424]
	adrp	x8, push_1_0_asm_h
	add	x8, x8, :lo12:push_1_0_asm_h
	str	x8, [x0, #1432]
	adrp	x8, push_2_0_asm_h
	add	x8, x8, :lo12:push_2_0_asm_h
	str	x8, [x0, #1440]
	adrp	x8, push_3_0_asm_h
	add	x8, x8, :lo12:push_3_0_asm_h
	str	x8, [x0, #1448]
	adrp	x8, push_4_0_asm_h
	add	x8, x8, :lo12:push_4_0_asm_h
	str	x8, [x0, #1456]
	adrp	x8, push_5_0_asm_h
	add	x8, x8, :lo12:push_5_0_asm_h
	str	x8, [x0, #1464]
	adrp	x8, push_6_0_asm_h
	add	x8, x8, :lo12:push_6_0_asm_h
	str	x8, [x0, #1472]
	adrp	x8, push_7_0_asm_h
	add	x8, x8, :lo12:push_7_0_asm_h
	str	x8, [x0, #1480]
	adrp	x8, push_i8_0_asm_h
	add	x8, x8, :lo12:push_i8_0_asm_h
	str	x8, [x0, #1488]
	adrp	x8, push_i16_0_asm_h
	add	x8, x8, :lo12:push_i16_0_asm_h
	str	x8, [x0, #1496]
	adrp	x8, push_const8_0_asm_h
	add	x8, x8, :lo12:push_const8_0_asm_h
	str	x8, [x0, #1504]
	adrp	x8, fclosure8_0_asm_h
	add	x8, x8, :lo12:fclosure8_0_asm_h
	str	x8, [x0, #1512]
	adrp	x8, push_empty_string_0_asm_h
	add	x8, x8, :lo12:push_empty_string_0_asm_h
	str	x8, [x0, #1520]
	adrp	x8, get_loc8_0_asm_h
	add	x8, x8, :lo12:get_loc8_0_asm_h
	str	x8, [x0, #1528]
	adrp	x8, put_loc8_0_asm_h
	add	x8, x8, :lo12:put_loc8_0_asm_h
	str	x8, [x0, #1536]
	adrp	x8, set_loc8_0_asm_h
	add	x8, x8, :lo12:set_loc8_0_asm_h
	str	x8, [x0, #1544]
	adrp	x8, get_loc0_0_asm_h
	add	x8, x8, :lo12:get_loc0_0_asm_h
	str	x8, [x0, #1552]
	adrp	x8, get_loc1_0_asm_h
	add	x8, x8, :lo12:get_loc1_0_asm_h
	str	x8, [x0, #1560]
	adrp	x8, get_loc2_0_asm_h
	add	x8, x8, :lo12:get_loc2_0_asm_h
	str	x8, [x0, #1568]
	adrp	x8, get_loc3_0_asm_h
	add	x8, x8, :lo12:get_loc3_0_asm_h
	str	x8, [x0, #1576]
	adrp	x8, put_loc0_0_asm_h
	add	x8, x8, :lo12:put_loc0_0_asm_h
	str	x8, [x0, #1584]
	adrp	x8, put_loc1_0_asm_h
	add	x8, x8, :lo12:put_loc1_0_asm_h
	str	x8, [x0, #1592]
	adrp	x8, put_loc2_0_asm_h
	add	x8, x8, :lo12:put_loc2_0_asm_h
	str	x8, [x0, #1600]
	adrp	x8, put_loc3_0_asm_h
	add	x8, x8, :lo12:put_loc3_0_asm_h
	str	x8, [x0, #1608]
	adrp	x8, set_loc0_0_asm_h
	add	x8, x8, :lo12:set_loc0_0_asm_h
	str	x8, [x0, #1616]
	adrp	x8, set_loc1_0_asm_h
	add	x8, x8, :lo12:set_loc1_0_asm_h
	str	x8, [x0, #1624]
	adrp	x8, set_loc2_0_asm_h
	add	x8, x8, :lo12:set_loc2_0_asm_h
	str	x8, [x0, #1632]
	adrp	x8, set_loc3_0_asm_h
	add	x8, x8, :lo12:set_loc3_0_asm_h
	str	x8, [x0, #1640]
	adrp	x8, get_arg0_0_asm_h
	add	x8, x8, :lo12:get_arg0_0_asm_h
	str	x8, [x0, #1648]
	adrp	x8, get_arg1_0_asm_h
	add	x8, x8, :lo12:get_arg1_0_asm_h
	str	x8, [x0, #1656]
	adrp	x8, get_arg2_0_asm_h
	add	x8, x8, :lo12:get_arg2_0_asm_h
	str	x8, [x0, #1664]
	adrp	x8, get_arg3_0_asm_h
	add	x8, x8, :lo12:get_arg3_0_asm_h
	str	x8, [x0, #1672]
	adrp	x8, put_arg0_0_asm_h
	add	x8, x8, :lo12:put_arg0_0_asm_h
	str	x8, [x0, #1680]
	adrp	x8, put_arg1_0_asm_h
	add	x8, x8, :lo12:put_arg1_0_asm_h
	str	x8, [x0, #1688]
	adrp	x8, put_arg2_0_asm_h
	add	x8, x8, :lo12:put_arg2_0_asm_h
	str	x8, [x0, #1696]
	adrp	x8, put_arg3_0_asm_h
	add	x8, x8, :lo12:put_arg3_0_asm_h
	str	x8, [x0, #1704]
	adrp	x8, set_arg0_0_asm_h
	add	x8, x8, :lo12:set_arg0_0_asm_h
	str	x8, [x0, #1712]
	adrp	x8, set_arg1_0_asm_h
	add	x8, x8, :lo12:set_arg1_0_asm_h
	str	x8, [x0, #1720]
	adrp	x8, set_arg2_0_asm_h
	add	x8, x8, :lo12:set_arg2_0_asm_h
	str	x8, [x0, #1728]
	adrp	x8, set_arg3_0_asm_h
	add	x8, x8, :lo12:set_arg3_0_asm_h
	str	x8, [x0, #1736]
	adrp	x8, get_var_ref0_0_asm_h
	add	x8, x8, :lo12:get_var_ref0_0_asm_h
	str	x8, [x0, #1744]
	adrp	x8, get_var_ref1_0_asm_h
	add	x8, x8, :lo12:get_var_ref1_0_asm_h
	str	x8, [x0, #1752]
	adrp	x8, get_var_ref2_0_asm_h
	add	x8, x8, :lo12:get_var_ref2_0_asm_h
	str	x8, [x0, #1760]
	adrp	x8, get_var_ref3_0_asm_h
	add	x8, x8, :lo12:get_var_ref3_0_asm_h
	str	x8, [x0, #1768]
	adrp	x8, put_var_ref0_0_asm_h
	add	x8, x8, :lo12:put_var_ref0_0_asm_h
	str	x8, [x0, #1776]
	adrp	x8, put_var_ref1_0_asm_h
	add	x8, x8, :lo12:put_var_ref1_0_asm_h
	str	x8, [x0, #1784]
	adrp	x8, put_var_ref2_0_asm_h
	add	x8, x8, :lo12:put_var_ref2_0_asm_h
	str	x8, [x0, #1792]
	adrp	x8, put_var_ref3_0_asm_h
	add	x8, x8, :lo12:put_var_ref3_0_asm_h
	str	x8, [x0, #1800]
	adrp	x8, set_var_ref0_0_asm_h
	add	x8, x8, :lo12:set_var_ref0_0_asm_h
	str	x8, [x0, #1808]
	adrp	x8, set_var_ref1_0_asm_h
	add	x8, x8, :lo12:set_var_ref1_0_asm_h
	str	x8, [x0, #1816]
	adrp	x8, set_var_ref2_0_asm_h
	add	x8, x8, :lo12:set_var_ref2_0_asm_h
	str	x8, [x0, #1824]
	adrp	x8, set_var_ref3_0_asm_h
	add	x8, x8, :lo12:set_var_ref3_0_asm_h
	str	x8, [x0, #1832]
	adrp	x8, get_length_0_asm_h
	add	x8, x8, :lo12:get_length_0_asm_h
	str	x8, [x0, #1840]
	adrp	x8, if_false8_0_asm_h
	add	x8, x8, :lo12:if_false8_0_asm_h
	str	x8, [x0, #1848]
	adrp	x8, if_true8_0_asm_h
	add	x8, x8, :lo12:if_true8_0_asm_h
	str	x8, [x0, #1856]
	adrp	x8, goto8_0_asm_h
	add	x8, x8, :lo12:goto8_0_asm_h
	str	x8, [x0, #1864]
	adrp	x8, goto16_0_asm_h
	add	x8, x8, :lo12:goto16_0_asm_h
	str	x8, [x0, #1872]
	adrp	x8, call0_0_asm_h
	add	x8, x8, :lo12:call0_0_asm_h
	str	x8, [x0, #1880]
	adrp	x8, call1_0_asm_h
	add	x8, x8, :lo12:call1_0_asm_h
	str	x8, [x0, #1888]
	adrp	x8, call2_0_asm_h
	add	x8, x8, :lo12:call2_0_asm_h
	str	x8, [x0, #1896]
	adrp	x8, call3_0_asm_h
	add	x8, x8, :lo12:call3_0_asm_h
	str	x8, [x0, #1904]
	adrp	x8, is_undefined_0_asm_h
	add	x8, x8, :lo12:is_undefined_0_asm_h
	str	x8, [x0, #1912]
	adrp	x8, is_null_0_asm_h
	add	x8, x8, :lo12:is_null_0_asm_h
	str	x8, [x0, #1920]
	adrp	x8, is_function_0_asm_h
	add	x8, x8, :lo12:is_function_0_asm_h
	str	x8, [x0, #1928]
	adrp	x8, invalid_1_asm_h
	add	x8, x8, :lo12:invalid_1_asm_h
	str	x8, [x0, #1936]
	adrp	x8, push_i32_1_asm_h
	add	x8, x8, :lo12:push_i32_1_asm_h
	str	x8, [x0, #1944]
	adrp	x8, push_const_1_asm_h
	add	x8, x8, :lo12:push_const_1_asm_h
	str	x8, [x0, #1952]
	adrp	x8, fclosure_1_asm_h
	add	x8, x8, :lo12:fclosure_1_asm_h
	str	x8, [x0, #1960]
	adrp	x8, push_atom_value_1_asm_h
	add	x8, x8, :lo12:push_atom_value_1_asm_h
	str	x8, [x0, #1968]
	adrp	x8, private_symbol_1_asm_h
	add	x8, x8, :lo12:private_symbol_1_asm_h
	str	x8, [x0, #1976]
	adrp	x8, undefined_1_asm_h
	add	x8, x8, :lo12:undefined_1_asm_h
	str	x8, [x0, #1984]
	adrp	x8, null_1_asm_h
	add	x8, x8, :lo12:null_1_asm_h
	str	x8, [x0, #1992]
	adrp	x8, push_this_1_asm_h
	add	x8, x8, :lo12:push_this_1_asm_h
	str	x8, [x0, #2000]
	adrp	x8, push_false_1_asm_h
	add	x8, x8, :lo12:push_false_1_asm_h
	str	x8, [x0, #2008]
	adrp	x8, push_true_1_asm_h
	add	x8, x8, :lo12:push_true_1_asm_h
	str	x8, [x0, #2016]
	adrp	x8, object_1_asm_h
	add	x8, x8, :lo12:object_1_asm_h
	str	x8, [x0, #2024]
	adrp	x8, special_object_1_asm_h
	add	x8, x8, :lo12:special_object_1_asm_h
	str	x8, [x0, #2032]
	adrp	x8, set_var_ref0_1_asm_h
	add	x8, x8, :lo12:set_var_ref0_1_asm_h
	str	x8, [x0, #3744]
	adrp	x8, put_var_ref3_1_asm_h
	add	x8, x8, :lo12:put_var_ref3_1_asm_h
	str	x8, [x0, #3736]
	adrp	x8, put_var_ref2_1_asm_h
	add	x8, x8, :lo12:put_var_ref2_1_asm_h
	str	x8, [x0, #3728]
	adrp	x8, put_var_ref1_1_asm_h
	add	x8, x8, :lo12:put_var_ref1_1_asm_h
	str	x8, [x0, #3720]
	adrp	x8, put_var_ref0_1_asm_h
	add	x8, x8, :lo12:put_var_ref0_1_asm_h
	str	x8, [x0, #3712]
	adrp	x8, get_var_ref3_1_asm_h
	add	x8, x8, :lo12:get_var_ref3_1_asm_h
	str	x8, [x0, #3704]
	adrp	x8, get_var_ref2_1_asm_h
	add	x8, x8, :lo12:get_var_ref2_1_asm_h
	str	x8, [x0, #3696]
	adrp	x8, get_var_ref1_1_asm_h
	add	x8, x8, :lo12:get_var_ref1_1_asm_h
	str	x8, [x0, #3688]
	adrp	x8, get_var_ref0_1_asm_h
	add	x8, x8, :lo12:get_var_ref0_1_asm_h
	str	x8, [x0, #3680]
	adrp	x8, set_arg3_1_asm_h
	add	x8, x8, :lo12:set_arg3_1_asm_h
	str	x8, [x0, #3672]
	adrp	x8, set_arg2_1_asm_h
	add	x8, x8, :lo12:set_arg2_1_asm_h
	str	x8, [x0, #3664]
	adrp	x8, set_arg1_1_asm_h
	add	x8, x8, :lo12:set_arg1_1_asm_h
	str	x8, [x0, #3656]
	adrp	x8, set_arg0_1_asm_h
	add	x8, x8, :lo12:set_arg0_1_asm_h
	str	x8, [x0, #3648]
	adrp	x8, put_arg3_1_asm_h
	add	x8, x8, :lo12:put_arg3_1_asm_h
	str	x8, [x0, #3640]
	adrp	x8, put_arg2_1_asm_h
	add	x8, x8, :lo12:put_arg2_1_asm_h
	str	x8, [x0, #3632]
	adrp	x8, put_arg1_1_asm_h
	add	x8, x8, :lo12:put_arg1_1_asm_h
	str	x8, [x0, #3624]
	adrp	x8, put_arg0_1_asm_h
	add	x8, x8, :lo12:put_arg0_1_asm_h
	str	x8, [x0, #3616]
	adrp	x8, get_arg3_1_asm_h
	add	x8, x8, :lo12:get_arg3_1_asm_h
	str	x8, [x0, #3608]
	adrp	x8, get_arg2_1_asm_h
	add	x8, x8, :lo12:get_arg2_1_asm_h
	str	x8, [x0, #3600]
	adrp	x8, get_arg1_1_asm_h
	add	x8, x8, :lo12:get_arg1_1_asm_h
	str	x8, [x0, #3592]
	adrp	x8, get_arg0_1_asm_h
	add	x8, x8, :lo12:get_arg0_1_asm_h
	str	x8, [x0, #3584]
	adrp	x8, set_loc3_1_asm_h
	add	x8, x8, :lo12:set_loc3_1_asm_h
	str	x8, [x0, #3576]
	adrp	x8, set_loc2_1_asm_h
	add	x8, x8, :lo12:set_loc2_1_asm_h
	str	x8, [x0, #3568]
	adrp	x8, set_loc1_1_asm_h
	add	x8, x8, :lo12:set_loc1_1_asm_h
	str	x8, [x0, #3560]
	adrp	x8, set_loc0_1_asm_h
	add	x8, x8, :lo12:set_loc0_1_asm_h
	str	x8, [x0, #3552]
	adrp	x8, put_loc3_1_asm_h
	add	x8, x8, :lo12:put_loc3_1_asm_h
	str	x8, [x0, #3544]
	adrp	x8, put_loc2_1_asm_h
	add	x8, x8, :lo12:put_loc2_1_asm_h
	str	x8, [x0, #3536]
	adrp	x8, put_loc1_1_asm_h
	add	x8, x8, :lo12:put_loc1_1_asm_h
	str	x8, [x0, #3528]
	adrp	x8, put_loc0_1_asm_h
	add	x8, x8, :lo12:put_loc0_1_asm_h
	str	x8, [x0, #3520]
	adrp	x8, get_loc3_1_asm_h
	add	x8, x8, :lo12:get_loc3_1_asm_h
	str	x8, [x0, #3512]
	adrp	x8, get_loc2_1_asm_h
	add	x8, x8, :lo12:get_loc2_1_asm_h
	str	x8, [x0, #3504]
	adrp	x8, get_loc1_1_asm_h
	add	x8, x8, :lo12:get_loc1_1_asm_h
	str	x8, [x0, #3496]
	adrp	x8, get_loc0_1_asm_h
	add	x8, x8, :lo12:get_loc0_1_asm_h
	str	x8, [x0, #3488]
	adrp	x8, set_loc8_1_asm_h
	add	x8, x8, :lo12:set_loc8_1_asm_h
	str	x8, [x0, #3480]
	adrp	x8, put_loc8_1_asm_h
	add	x8, x8, :lo12:put_loc8_1_asm_h
	str	x8, [x0, #3472]
	adrp	x8, get_loc8_1_asm_h
	add	x8, x8, :lo12:get_loc8_1_asm_h
	str	x8, [x0, #3464]
	adrp	x8, push_empty_string_1_asm_h
	add	x8, x8, :lo12:push_empty_string_1_asm_h
	str	x8, [x0, #3456]
	adrp	x8, fclosure8_1_asm_h
	add	x8, x8, :lo12:fclosure8_1_asm_h
	str	x8, [x0, #3448]
	adrp	x8, push_const8_1_asm_h
	add	x8, x8, :lo12:push_const8_1_asm_h
	str	x8, [x0, #3440]
	adrp	x8, push_i16_1_asm_h
	add	x8, x8, :lo12:push_i16_1_asm_h
	str	x8, [x0, #3432]
	adrp	x8, push_i8_1_asm_h
	add	x8, x8, :lo12:push_i8_1_asm_h
	str	x8, [x0, #3424]
	adrp	x8, push_7_1_asm_h
	add	x8, x8, :lo12:push_7_1_asm_h
	str	x8, [x0, #3416]
	adrp	x8, push_6_1_asm_h
	add	x8, x8, :lo12:push_6_1_asm_h
	str	x8, [x0, #3408]
	adrp	x8, push_5_1_asm_h
	add	x8, x8, :lo12:push_5_1_asm_h
	str	x8, [x0, #3400]
	adrp	x8, push_4_1_asm_h
	add	x8, x8, :lo12:push_4_1_asm_h
	str	x8, [x0, #3392]
	adrp	x8, push_3_1_asm_h
	add	x8, x8, :lo12:push_3_1_asm_h
	str	x8, [x0, #3384]
	adrp	x8, push_2_1_asm_h
	add	x8, x8, :lo12:push_2_1_asm_h
	str	x8, [x0, #3376]
	adrp	x8, push_1_1_asm_h
	add	x8, x8, :lo12:push_1_1_asm_h
	str	x8, [x0, #3368]
	adrp	x8, push_0_1_asm_h
	add	x8, x8, :lo12:push_0_1_asm_h
	str	x8, [x0, #3360]
	adrp	x8, push_minus1_1_asm_h
	add	x8, x8, :lo12:push_minus1_1_asm_h
	str	x8, [x0, #3352]
	adrp	x8, nop_1_asm_h
	add	x8, x8, :lo12:nop_1_asm_h
	str	x8, [x0, #3344]
	adrp	x8, or_1_asm_h
	add	x8, x8, :lo12:or_1_asm_h
	str	x8, [x0, #3336]
	adrp	x8, xor_1_asm_h
	add	x8, x8, :lo12:xor_1_asm_h
	str	x8, [x0, #3328]
	adrp	x8, and_1_asm_h
	add	x8, x8, :lo12:and_1_asm_h
	str	x8, [x0, #3320]
	adrp	x8, strict_neq_1_asm_h
	add	x8, x8, :lo12:strict_neq_1_asm_h
	str	x8, [x0, #3312]
	adrp	x8, strict_eq_1_asm_h
	add	x8, x8, :lo12:strict_eq_1_asm_h
	str	x8, [x0, #3304]
	adrp	x8, neq_1_asm_h
	add	x8, x8, :lo12:neq_1_asm_h
	str	x8, [x0, #3296]
	adrp	x8, eq_1_asm_h
	add	x8, x8, :lo12:eq_1_asm_h
	str	x8, [x0, #3288]
	adrp	x8, in_1_asm_h
	add	x8, x8, :lo12:in_1_asm_h
	str	x8, [x0, #3280]
	adrp	x8, instanceof_1_asm_h
	add	x8, x8, :lo12:instanceof_1_asm_h
	str	x8, [x0, #3272]
	adrp	x8, gte_1_asm_h
	add	x8, x8, :lo12:gte_1_asm_h
	str	x8, [x0, #3264]
	adrp	x8, gt_1_asm_h
	add	x8, x8, :lo12:gt_1_asm_h
	str	x8, [x0, #3256]
	adrp	x8, lte_1_asm_h
	add	x8, x8, :lo12:lte_1_asm_h
	str	x8, [x0, #3248]
	adrp	x8, lt_1_asm_h
	add	x8, x8, :lo12:lt_1_asm_h
	str	x8, [x0, #3240]
	adrp	x8, shr_1_asm_h
	add	x8, x8, :lo12:shr_1_asm_h
	str	x8, [x0, #3232]
	adrp	x8, sar_1_asm_h
	add	x8, x8, :lo12:sar_1_asm_h
	str	x8, [x0, #3224]
	adrp	x8, shl_1_asm_h
	add	x8, x8, :lo12:shl_1_asm_h
	str	x8, [x0, #3216]
	adrp	x8, pow_1_asm_h
	add	x8, x8, :lo12:pow_1_asm_h
	str	x8, [x0, #3208]
	adrp	x8, sub_1_asm_h
	add	x8, x8, :lo12:sub_1_asm_h
	str	x8, [x0, #3200]
	adrp	x8, add_1_asm_h
	add	x8, x8, :lo12:add_1_asm_h
	str	x8, [x0, #3192]
	adrp	x8, mod_1_asm_h
	add	x8, x8, :lo12:mod_1_asm_h
	str	x8, [x0, #3184]
	adrp	x8, div_1_asm_h
	add	x8, x8, :lo12:div_1_asm_h
	str	x8, [x0, #3176]
	adrp	x8, mul_1_asm_h
	add	x8, x8, :lo12:mul_1_asm_h
	str	x8, [x0, #3168]
	adrp	x8, delete_var_1_asm_h
	add	x8, x8, :lo12:delete_var_1_asm_h
	str	x8, [x0, #3160]
	adrp	x8, delete_1_asm_h
	add	x8, x8, :lo12:delete_1_asm_h
	str	x8, [x0, #3152]
	adrp	x8, typeof_1_asm_h
	add	x8, x8, :lo12:typeof_1_asm_h
	str	x8, [x0, #3144]
	adrp	x8, lnot_1_asm_h
	add	x8, x8, :lo12:lnot_1_asm_h
	str	x8, [x0, #3136]
	adrp	x8, not_1_asm_h
	add	x8, x8, :lo12:not_1_asm_h
	str	x8, [x0, #3128]
	adrp	x8, add_loc_1_asm_h
	add	x8, x8, :lo12:add_loc_1_asm_h
	str	x8, [x0, #3120]
	adrp	x8, inc_loc_1_asm_h
	add	x8, x8, :lo12:inc_loc_1_asm_h
	str	x8, [x0, #3112]
	adrp	x8, dec_loc_1_asm_h
	add	x8, x8, :lo12:dec_loc_1_asm_h
	str	x8, [x0, #3104]
	adrp	x8, post_inc_1_asm_h
	add	x8, x8, :lo12:post_inc_1_asm_h
	str	x8, [x0, #3096]
	adrp	x8, post_dec_1_asm_h
	add	x8, x8, :lo12:post_dec_1_asm_h
	str	x8, [x0, #3088]
	adrp	x8, inc_1_asm_h
	add	x8, x8, :lo12:inc_1_asm_h
	str	x8, [x0, #3080]
	adrp	x8, dec_1_asm_h
	add	x8, x8, :lo12:dec_1_asm_h
	str	x8, [x0, #3072]
	adrp	x8, plus_1_asm_h
	add	x8, x8, :lo12:plus_1_asm_h
	str	x8, [x0, #3064]
	adrp	x8, neg_1_asm_h
	add	x8, x8, :lo12:neg_1_asm_h
	str	x8, [x0, #3056]
	adrp	x8, await_1_asm_h
	add	x8, x8, :lo12:await_1_asm_h
	str	x8, [x0, #3048]
	adrp	x8, async_yield_star_1_asm_h
	add	x8, x8, :lo12:async_yield_star_1_asm_h
	str	x8, [x0, #3040]
	adrp	x8, yield_star_1_asm_h
	add	x8, x8, :lo12:yield_star_1_asm_h
	str	x8, [x0, #3032]
	adrp	x8, yield_1_asm_h
	add	x8, x8, :lo12:yield_1_asm_h
	str	x8, [x0, #3024]
	adrp	x8, initial_yield_1_asm_h
	add	x8, x8, :lo12:initial_yield_1_asm_h
	str	x8, [x0, #3016]
	adrp	x8, async_iterator_get_1_asm_h
	add	x8, x8, :lo12:async_iterator_get_1_asm_h
	str	x8, [x0, #3008]
	adrp	x8, async_iterator_next_1_asm_h
	add	x8, x8, :lo12:async_iterator_next_1_asm_h
	str	x8, [x0, #3000]
	adrp	x8, async_iterator_close_1_asm_h
	add	x8, x8, :lo12:async_iterator_close_1_asm_h
	str	x8, [x0, #2992]
	adrp	x8, iterator_close_return_1_asm_h
	add	x8, x8, :lo12:iterator_close_return_1_asm_h
	str	x8, [x0, #2984]
	adrp	x8, iterator_close_1_asm_h
	add	x8, x8, :lo12:iterator_close_1_asm_h
	str	x8, [x0, #2976]
	adrp	x8, iterator_get_value_done_1_asm_h
	add	x8, x8, :lo12:iterator_get_value_done_1_asm_h
	str	x8, [x0, #2968]
	adrp	x8, for_await_of_next_1_asm_h
	add	x8, x8, :lo12:for_await_of_next_1_asm_h
	str	x8, [x0, #2960]
	adrp	x8, for_of_next_1_asm_h
	add	x8, x8, :lo12:for_of_next_1_asm_h
	str	x8, [x0, #2952]
	adrp	x8, for_in_next_1_asm_h
	add	x8, x8, :lo12:for_in_next_1_asm_h
	str	x8, [x0, #2944]
	adrp	x8, for_await_of_start_1_asm_h
	add	x8, x8, :lo12:for_await_of_start_1_asm_h
	str	x8, [x0, #2936]
	adrp	x8, for_of_start_1_asm_h
	add	x8, x8, :lo12:for_of_start_1_asm_h
	str	x8, [x0, #2928]
	adrp	x8, for_in_start_1_asm_h
	add	x8, x8, :lo12:for_in_start_1_asm_h
	str	x8, [x0, #2920]
	adrp	x8, make_var_ref_1_asm_h
	add	x8, x8, :lo12:make_var_ref_1_asm_h
	str	x8, [x0, #2912]
	adrp	x8, make_var_ref_ref_1_asm_h
	add	x8, x8, :lo12:make_var_ref_ref_1_asm_h
	str	x8, [x0, #2904]
	adrp	x8, make_arg_ref_1_asm_h
	add	x8, x8, :lo12:make_arg_ref_1_asm_h
	str	x8, [x0, #2896]
	adrp	x8, make_loc_ref_1_asm_h
	add	x8, x8, :lo12:make_loc_ref_1_asm_h
	str	x8, [x0, #2888]
	adrp	x8, with_get_ref_undef_1_asm_h
	add	x8, x8, :lo12:with_get_ref_undef_1_asm_h
	str	x8, [x0, #2880]
	adrp	x8, with_get_ref_1_asm_h
	add	x8, x8, :lo12:with_get_ref_1_asm_h
	str	x8, [x0, #2872]
	adrp	x8, with_make_ref_1_asm_h
	add	x8, x8, :lo12:with_make_ref_1_asm_h
	str	x8, [x0, #2864]
	adrp	x8, with_delete_var_1_asm_h
	add	x8, x8, :lo12:with_delete_var_1_asm_h
	str	x8, [x0, #2856]
	adrp	x8, with_put_var_1_asm_h
	add	x8, x8, :lo12:with_put_var_1_asm_h
	str	x8, [x0, #2848]
	adrp	x8, with_get_var_1_asm_h
	add	x8, x8, :lo12:with_get_var_1_asm_h
	str	x8, [x0, #2840]
	adrp	x8, to_propkey2_1_asm_h
	add	x8, x8, :lo12:to_propkey2_1_asm_h
	str	x8, [x0, #2832]
	adrp	x8, to_propkey_1_asm_h
	add	x8, x8, :lo12:to_propkey_1_asm_h
	str	x8, [x0, #2824]
	adrp	x8, to_object_1_asm_h
	add	x8, x8, :lo12:to_object_1_asm_h
	str	x8, [x0, #2816]
	adrp	x8, ret_1_asm_h
	add	x8, x8, :lo12:ret_1_asm_h
	str	x8, [x0, #2808]
	adrp	x8, gosub_1_asm_h
	add	x8, x8, :lo12:gosub_1_asm_h
	str	x8, [x0, #2800]
	adrp	x8, catch_1_asm_h
	add	x8, x8, :lo12:catch_1_asm_h
	str	x8, [x0, #2792]
	adrp	x8, goto_1_asm_h
	add	x8, x8, :lo12:goto_1_asm_h
	str	x8, [x0, #2784]
	adrp	x8, if_true_1_asm_h
	add	x8, x8, :lo12:if_true_1_asm_h
	str	x8, [x0, #2776]
	adrp	x8, if_false_1_asm_h
	add	x8, x8, :lo12:if_false_1_asm_h
	str	x8, [x0, #2768]
	adrp	x8, close_loc_1_asm_h
	add	x8, x8, :lo12:close_loc_1_asm_h
	str	x8, [x0, #2760]
	adrp	x8, put_var_ref_check_init_1_asm_h
	add	x8, x8, :lo12:put_var_ref_check_init_1_asm_h
	str	x8, [x0, #2752]
	adrp	x8, put_var_ref_check_1_asm_h
	add	x8, x8, :lo12:put_var_ref_check_1_asm_h
	str	x8, [x0, #2744]
	adrp	x8, get_var_ref_check_1_asm_h
	add	x8, x8, :lo12:get_var_ref_check_1_asm_h
	str	x8, [x0, #2736]
	adrp	x8, put_loc_check_init_1_asm_h
	add	x8, x8, :lo12:put_loc_check_init_1_asm_h
	str	x8, [x0, #2728]
	adrp	x8, put_loc_check_1_asm_h
	add	x8, x8, :lo12:put_loc_check_1_asm_h
	str	x8, [x0, #2720]
	adrp	x8, get_loc_check_1_asm_h
	add	x8, x8, :lo12:get_loc_check_1_asm_h
	str	x8, [x0, #2712]
	adrp	x8, set_loc_uninitialized_1_asm_h
	add	x8, x8, :lo12:set_loc_uninitialized_1_asm_h
	str	x8, [x0, #2704]
	adrp	x8, set_var_ref_1_asm_h
	add	x8, x8, :lo12:set_var_ref_1_asm_h
	str	x8, [x0, #2696]
	adrp	x8, put_var_ref_1_asm_h
	add	x8, x8, :lo12:put_var_ref_1_asm_h
	str	x8, [x0, #2688]
	adrp	x8, get_var_ref_1_asm_h
	add	x8, x8, :lo12:get_var_ref_1_asm_h
	str	x8, [x0, #2680]
	adrp	x8, set_arg_1_asm_h
	add	x8, x8, :lo12:set_arg_1_asm_h
	str	x8, [x0, #2672]
	adrp	x8, put_arg_1_asm_h
	add	x8, x8, :lo12:put_arg_1_asm_h
	str	x8, [x0, #2664]
	adrp	x8, get_arg_1_asm_h
	add	x8, x8, :lo12:get_arg_1_asm_h
	str	x8, [x0, #2656]
	adrp	x8, set_loc_1_asm_h
	add	x8, x8, :lo12:set_loc_1_asm_h
	str	x8, [x0, #2648]
	adrp	x8, put_loc_1_asm_h
	add	x8, x8, :lo12:put_loc_1_asm_h
	str	x8, [x0, #2640]
	adrp	x8, get_loc_1_asm_h
	add	x8, x8, :lo12:get_loc_1_asm_h
	str	x8, [x0, #2632]
	adrp	x8, define_class_1_asm_h
	add	x8, x8, :lo12:define_class_1_asm_h
	str	x8, [x0, #2624]
	adrp	x8, define_method_computed_1_asm_h
	add	x8, x8, :lo12:define_method_computed_1_asm_h
	str	x8, [x0, #2616]
	adrp	x8, define_method_1_asm_h
	add	x8, x8, :lo12:define_method_1_asm_h
	str	x8, [x0, #2608]
	adrp	x8, copy_data_properties_1_asm_h
	add	x8, x8, :lo12:copy_data_properties_1_asm_h
	str	x8, [x0, #2600]
	adrp	x8, append_1_asm_h
	add	x8, x8, :lo12:append_1_asm_h
	str	x8, [x0, #2592]
	adrp	x8, define_array_el_1_asm_h
	add	x8, x8, :lo12:define_array_el_1_asm_h
	str	x8, [x0, #2584]
	adrp	x8, set_home_object_1_asm_h
	add	x8, x8, :lo12:set_home_object_1_asm_h
	str	x8, [x0, #2576]
	adrp	x8, set_proto_1_asm_h
	add	x8, x8, :lo12:set_proto_1_asm_h
	str	x8, [x0, #2568]
	adrp	x8, set_name_computed_1_asm_h
	add	x8, x8, :lo12:set_name_computed_1_asm_h
	str	x8, [x0, #2560]
	adrp	x8, set_name_1_asm_h
	add	x8, x8, :lo12:set_name_1_asm_h
	str	x8, [x0, #2552]
	adrp	x8, define_field_1_asm_h
	add	x8, x8, :lo12:define_field_1_asm_h
	str	x8, [x0, #2544]
	adrp	x8, put_super_value_1_asm_h
	add	x8, x8, :lo12:put_super_value_1_asm_h
	str	x8, [x0, #2536]
	adrp	x8, get_super_value_1_asm_h
	add	x8, x8, :lo12:get_super_value_1_asm_h
	str	x8, [x0, #2528]
	adrp	x8, put_array_el_1_asm_h
	add	x8, x8, :lo12:put_array_el_1_asm_h
	str	x8, [x0, #2520]
	adrp	x8, get_array_el2_1_asm_h
	add	x8, x8, :lo12:get_array_el2_1_asm_h
	str	x8, [x0, #2512]
	adrp	x8, get_array_el_1_asm_h
	add	x8, x8, :lo12:get_array_el_1_asm_h
	str	x8, [x0, #2504]
	adrp	x8, define_private_field_1_asm_h
	add	x8, x8, :lo12:define_private_field_1_asm_h
	str	x8, [x0, #2496]
	adrp	x8, put_private_field_1_asm_h
	add	x8, x8, :lo12:put_private_field_1_asm_h
	str	x8, [x0, #2488]
	adrp	x8, get_private_field_1_asm_h
	add	x8, x8, :lo12:get_private_field_1_asm_h
	str	x8, [x0, #2480]
	adrp	x8, put_field_1_asm_h
	add	x8, x8, :lo12:put_field_1_asm_h
	str	x8, [x0, #2472]
	adrp	x8, get_field2_1_asm_h
	add	x8, x8, :lo12:get_field2_1_asm_h
	str	x8, [x0, #2464]
	adrp	x8, get_field_1_asm_h
	add	x8, x8, :lo12:get_field_1_asm_h
	str	x8, [x0, #2456]
	adrp	x8, define_func_1_asm_h
	add	x8, x8, :lo12:define_func_1_asm_h
	str	x8, [x0, #2448]
	adrp	x8, check_define_var_1_asm_h
	add	x8, x8, :lo12:check_define_var_1_asm_h
	str	x8, [x0, #2440]
	adrp	x8, define_var_1_asm_h
	add	x8, x8, :lo12:define_var_1_asm_h
	str	x8, [x0, #2432]
	adrp	x8, put_ref_value_1_asm_h
	add	x8, x8, :lo12:put_ref_value_1_asm_h
	str	x8, [x0, #2424]
	adrp	x8, get_ref_value_1_asm_h
	add	x8, x8, :lo12:get_ref_value_1_asm_h
	str	x8, [x0, #2416]
	adrp	x8, put_var_strict_1_asm_h
	add	x8, x8, :lo12:put_var_strict_1_asm_h
	str	x8, [x0, #2408]
	adrp	x8, put_var_init_1_asm_h
	add	x8, x8, :lo12:put_var_init_1_asm_h
	str	x8, [x0, #2400]
	adrp	x8, put_var_1_asm_h
	add	x8, x8, :lo12:put_var_1_asm_h
	str	x8, [x0, #2392]
	adrp	x8, get_var_1_asm_h
	add	x8, x8, :lo12:get_var_1_asm_h
	str	x8, [x0, #2384]
	adrp	x8, get_var_undef_1_asm_h
	add	x8, x8, :lo12:get_var_undef_1_asm_h
	str	x8, [x0, #2376]
	adrp	x8, check_var_1_asm_h
	add	x8, x8, :lo12:check_var_1_asm_h
	str	x8, [x0, #2368]
	adrp	x8, import_1_asm_h
	add	x8, x8, :lo12:import_1_asm_h
	str	x8, [x0, #2360]
	adrp	x8, get_super_1_asm_h
	add	x8, x8, :lo12:get_super_1_asm_h
	str	x8, [x0, #2352]
	adrp	x8, get_super_ctor_1_asm_h
	add	x8, x8, :lo12:get_super_ctor_1_asm_h
	str	x8, [x0, #2344]
	adrp	x8, regexp_1_asm_h
	add	x8, x8, :lo12:regexp_1_asm_h
	str	x8, [x0, #2336]
	adrp	x8, eval_1_asm_h
	add	x8, x8, :lo12:eval_1_asm_h
	str	x8, [x0, #2328]
	adrp	x8, throw_var_1_asm_h
	add	x8, x8, :lo12:throw_var_1_asm_h
	str	x8, [x0, #2320]
	adrp	x8, throw_1_asm_h
	add	x8, x8, :lo12:throw_1_asm_h
	str	x8, [x0, #2312]
	adrp	x8, return_async_1_asm_h
	add	x8, x8, :lo12:return_async_1_asm_h
	str	x8, [x0, #2304]
	adrp	x8, add_brand_1_asm_h
	add	x8, x8, :lo12:add_brand_1_asm_h
	str	x8, [x0, #2296]
	adrp	x8, check_brand_1_asm_h
	add	x8, x8, :lo12:check_brand_1_asm_h
	str	x8, [x0, #2288]
	adrp	x8, check_ctor_1_asm_h
	add	x8, x8, :lo12:check_ctor_1_asm_h
	str	x8, [x0, #2280]
	adrp	x8, check_ctor_return_1_asm_h
	add	x8, x8, :lo12:check_ctor_return_1_asm_h
	str	x8, [x0, #2272]
	adrp	x8, return_undef_1_asm_h
	add	x8, x8, :lo12:return_undef_1_asm_h
	str	x8, [x0, #2264]
	adrp	x8, return_1_asm_h
	add	x8, x8, :lo12:return_1_asm_h
	str	x8, [x0, #2256]
	adrp	x8, apply_1_asm_h
	add	x8, x8, :lo12:apply_1_asm_h
	str	x8, [x0, #2248]
	adrp	x8, array_from_1_asm_h
	add	x8, x8, :lo12:array_from_1_asm_h
	str	x8, [x0, #2240]
	adrp	x8, tail_call_method_1_asm_h
	add	x8, x8, :lo12:tail_call_method_1_asm_h
	str	x8, [x0, #2232]
	adrp	x8, call_method_1_asm_h
	add	x8, x8, :lo12:call_method_1_asm_h
	str	x8, [x0, #2224]
	adrp	x8, tail_call_1_asm_h
	add	x8, x8, :lo12:tail_call_1_asm_h
	str	x8, [x0, #2216]
	adrp	x8, call_1_asm_h
	add	x8, x8, :lo12:call_1_asm_h
	str	x8, [x0, #2208]
	adrp	x8, call_constructor_1_asm_h
	add	x8, x8, :lo12:call_constructor_1_asm_h
	str	x8, [x0, #2200]
	adrp	x8, rot5l_1_asm_h
	add	x8, x8, :lo12:rot5l_1_asm_h
	str	x8, [x0, #2192]
	adrp	x8, rot4l_1_asm_h
	add	x8, x8, :lo12:rot4l_1_asm_h
	str	x8, [x0, #2184]
	adrp	x8, rot3r_1_asm_h
	add	x8, x8, :lo12:rot3r_1_asm_h
	str	x8, [x0, #2176]
	adrp	x8, rot3l_1_asm_h
	add	x8, x8, :lo12:rot3l_1_asm_h
	str	x8, [x0, #2168]
	adrp	x8, swap2_1_asm_h
	add	x8, x8, :lo12:swap2_1_asm_h
	str	x8, [x0, #2160]
	adrp	x8, swap_1_asm_h
	add	x8, x8, :lo12:swap_1_asm_h
	str	x8, [x0, #2152]
	adrp	x8, perm5_1_asm_h
	add	x8, x8, :lo12:perm5_1_asm_h
	str	x8, [x0, #2144]
	adrp	x8, perm4_1_asm_h
	add	x8, x8, :lo12:perm4_1_asm_h
	str	x8, [x0, #2136]
	adrp	x8, perm3_1_asm_h
	add	x8, x8, :lo12:perm3_1_asm_h
	str	x8, [x0, #2128]
	adrp	x8, insert4_1_asm_h
	add	x8, x8, :lo12:insert4_1_asm_h
	str	x8, [x0, #2120]
	adrp	x8, insert3_1_asm_h
	add	x8, x8, :lo12:insert3_1_asm_h
	str	x8, [x0, #2112]
	adrp	x8, insert2_1_asm_h
	add	x8, x8, :lo12:insert2_1_asm_h
	str	x8, [x0, #2104]
	adrp	x8, dup3_1_asm_h
	add	x8, x8, :lo12:dup3_1_asm_h
	str	x8, [x0, #2096]
	adrp	x8, dup2_1_asm_h
	add	x8, x8, :lo12:dup2_1_asm_h
	str	x8, [x0, #2088]
	adrp	x8, dup1_1_asm_h
	add	x8, x8, :lo12:dup1_1_asm_h
	str	x8, [x0, #2080]
	adrp	x8, dup_1_asm_h
	add	x8, x8, :lo12:dup_1_asm_h
	str	x8, [x0, #2072]
	adrp	x8, nip1_1_asm_h
	add	x8, x8, :lo12:nip1_1_asm_h
	str	x8, [x0, #2064]
	adrp	x8, nip_1_asm_h
	add	x8, x8, :lo12:nip_1_asm_h
	str	x8, [x0, #2056]
	adrp	x8, drop_1_asm_h
	add	x8, x8, :lo12:drop_1_asm_h
	str	x8, [x0, #2048]
	adrp	x8, rest_1_asm_h
	add	x8, x8, :lo12:rest_1_asm_h
	str	x8, [x0, #2040]
	adrp	x8, set_var_ref1_1_asm_h
	add	x8, x8, :lo12:set_var_ref1_1_asm_h
	str	x8, [x0, #3752]
	adrp	x8, set_var_ref2_1_asm_h
	add	x8, x8, :lo12:set_var_ref2_1_asm_h
	str	x8, [x0, #3760]
	adrp	x8, set_var_ref3_1_asm_h
	add	x8, x8, :lo12:set_var_ref3_1_asm_h
	str	x8, [x0, #3768]
	adrp	x8, get_length_1_asm_h
	add	x8, x8, :lo12:get_length_1_asm_h
	str	x8, [x0, #3776]
	adrp	x8, if_false8_1_asm_h
	add	x8, x8, :lo12:if_false8_1_asm_h
	str	x8, [x0, #3784]
	adrp	x8, if_true8_1_asm_h
	add	x8, x8, :lo12:if_true8_1_asm_h
	str	x8, [x0, #3792]
	adrp	x8, goto8_1_asm_h
	add	x8, x8, :lo12:goto8_1_asm_h
	str	x8, [x0, #3800]
	adrp	x8, goto16_1_asm_h
	add	x8, x8, :lo12:goto16_1_asm_h
	str	x8, [x0, #3808]
	adrp	x8, call0_1_asm_h
	add	x8, x8, :lo12:call0_1_asm_h
	str	x8, [x0, #3816]
	adrp	x8, call1_1_asm_h
	add	x8, x8, :lo12:call1_1_asm_h
	str	x8, [x0, #3824]
	adrp	x8, call2_1_asm_h
	add	x8, x8, :lo12:call2_1_asm_h
	str	x8, [x0, #3832]
	adrp	x8, call3_1_asm_h
	add	x8, x8, :lo12:call3_1_asm_h
	str	x8, [x0, #3840]
	adrp	x8, is_undefined_1_asm_h
	add	x8, x8, :lo12:is_undefined_1_asm_h
	str	x8, [x0, #3848]
	adrp	x8, is_null_1_asm_h
	add	x8, x8, :lo12:is_null_1_asm_h
	str	x8, [x0, #3856]
	adrp	x8, is_function_1_asm_h
	add	x8, x8, :lo12:is_function_1_asm_h
	str	x8, [x0, #3864]
	adrp	x8, invalid_2_asm_h
	add	x8, x8, :lo12:invalid_2_asm_h
	str	x8, [x0, #3872]
	adrp	x8, push_i32_2_asm_h
	add	x8, x8, :lo12:push_i32_2_asm_h
	str	x8, [x0, #3880]
	adrp	x8, push_const_2_asm_h
	add	x8, x8, :lo12:push_const_2_asm_h
	str	x8, [x0, #3888]
	adrp	x8, fclosure_2_asm_h
	add	x8, x8, :lo12:fclosure_2_asm_h
	str	x8, [x0, #3896]
	adrp	x8, push_atom_value_2_asm_h
	add	x8, x8, :lo12:push_atom_value_2_asm_h
	str	x8, [x0, #3904]
	adrp	x8, private_symbol_2_asm_h
	add	x8, x8, :lo12:private_symbol_2_asm_h
	str	x8, [x0, #3912]
	adrp	x8, undefined_2_asm_h
	add	x8, x8, :lo12:undefined_2_asm_h
	str	x8, [x0, #3920]
	adrp	x8, null_2_asm_h
	add	x8, x8, :lo12:null_2_asm_h
	str	x8, [x0, #3928]
	adrp	x8, push_this_2_asm_h
	add	x8, x8, :lo12:push_this_2_asm_h
	str	x8, [x0, #3936]
	adrp	x8, push_false_2_asm_h
	add	x8, x8, :lo12:push_false_2_asm_h
	str	x8, [x0, #3944]
	adrp	x8, push_true_2_asm_h
	add	x8, x8, :lo12:push_true_2_asm_h
	str	x8, [x0, #3952]
	adrp	x8, object_2_asm_h
	add	x8, x8, :lo12:object_2_asm_h
	str	x8, [x0, #3960]
	adrp	x8, special_object_2_asm_h
	add	x8, x8, :lo12:special_object_2_asm_h
	str	x8, [x0, #3968]
	adrp	x8, rest_2_asm_h
	add	x8, x8, :lo12:rest_2_asm_h
	str	x8, [x0, #3976]
	adrp	x8, drop_2_asm_h
	add	x8, x8, :lo12:drop_2_asm_h
	str	x8, [x0, #3984]
	adrp	x8, nip_2_asm_h
	add	x8, x8, :lo12:nip_2_asm_h
	str	x8, [x0, #3992]
	adrp	x8, nip1_2_asm_h
	add	x8, x8, :lo12:nip1_2_asm_h
	str	x8, [x0, #4000]
	adrp	x8, dup_2_asm_h
	add	x8, x8, :lo12:dup_2_asm_h
	str	x8, [x0, #4008]
	adrp	x8, dup1_2_asm_h
	add	x8, x8, :lo12:dup1_2_asm_h
	str	x8, [x0, #4016]
	adrp	x8, dup2_2_asm_h
	add	x8, x8, :lo12:dup2_2_asm_h
	str	x8, [x0, #4024]
	adrp	x8, dup3_2_asm_h
	add	x8, x8, :lo12:dup3_2_asm_h
	str	x8, [x0, #4032]
	adrp	x8, insert2_2_asm_h
	add	x8, x8, :lo12:insert2_2_asm_h
	str	x8, [x0, #4040]
	adrp	x8, insert3_2_asm_h
	add	x8, x8, :lo12:insert3_2_asm_h
	str	x8, [x0, #4048]
	adrp	x8, insert4_2_asm_h
	add	x8, x8, :lo12:insert4_2_asm_h
	str	x8, [x0, #4056]
	adrp	x8, perm3_2_asm_h
	add	x8, x8, :lo12:perm3_2_asm_h
	str	x8, [x0, #4064]
	adrp	x8, perm4_2_asm_h
	add	x8, x8, :lo12:perm4_2_asm_h
	str	x8, [x0, #4072]
	adrp	x8, perm5_2_asm_h
	add	x8, x8, :lo12:perm5_2_asm_h
	str	x8, [x0, #4080]
	adrp	x8, swap_2_asm_h
	add	x8, x8, :lo12:swap_2_asm_h
	str	x8, [x0, #4088]
	adrp	x8, swap2_2_asm_h
	add	x8, x8, :lo12:swap2_2_asm_h
	str	x8, [x0, #4096]
	adrp	x8, rot3l_2_asm_h
	add	x8, x8, :lo12:rot3l_2_asm_h
	str	x8, [x0, #4104]
	adrp	x8, rot3r_2_asm_h
	add	x8, x8, :lo12:rot3r_2_asm_h
	str	x8, [x0, #4112]
	adrp	x8, rot4l_2_asm_h
	add	x8, x8, :lo12:rot4l_2_asm_h
	str	x8, [x0, #4120]
	adrp	x8, rot5l_2_asm_h
	add	x8, x8, :lo12:rot5l_2_asm_h
	str	x8, [x0, #4128]
	adrp	x8, call_constructor_2_asm_h
	add	x8, x8, :lo12:call_constructor_2_asm_h
	str	x8, [x0, #4136]
	adrp	x8, call_2_asm_h
	add	x8, x8, :lo12:call_2_asm_h
	str	x8, [x0, #4144]
	adrp	x8, tail_call_2_asm_h
	add	x8, x8, :lo12:tail_call_2_asm_h
	str	x8, [x0, #4152]
	adrp	x8, call_method_2_asm_h
	add	x8, x8, :lo12:call_method_2_asm_h
	str	x8, [x0, #4160]
	adrp	x8, tail_call_method_2_asm_h
	add	x8, x8, :lo12:tail_call_method_2_asm_h
	str	x8, [x0, #4168]
	adrp	x8, array_from_2_asm_h
	add	x8, x8, :lo12:array_from_2_asm_h
	str	x8, [x0, #4176]
	adrp	x8, apply_2_asm_h
	add	x8, x8, :lo12:apply_2_asm_h
	str	x8, [x0, #4184]
	adrp	x8, return_2_asm_h
	add	x8, x8, :lo12:return_2_asm_h
	str	x8, [x0, #4192]
	adrp	x8, return_undef_2_asm_h
	add	x8, x8, :lo12:return_undef_2_asm_h
	str	x8, [x0, #4200]
	adrp	x8, check_ctor_return_2_asm_h
	add	x8, x8, :lo12:check_ctor_return_2_asm_h
	str	x8, [x0, #4208]
	adrp	x8, check_ctor_2_asm_h
	add	x8, x8, :lo12:check_ctor_2_asm_h
	str	x8, [x0, #4216]
	adrp	x8, check_brand_2_asm_h
	add	x8, x8, :lo12:check_brand_2_asm_h
	str	x8, [x0, #4224]
	adrp	x8, add_brand_2_asm_h
	add	x8, x8, :lo12:add_brand_2_asm_h
	str	x8, [x0, #4232]
	adrp	x8, return_async_2_asm_h
	add	x8, x8, :lo12:return_async_2_asm_h
	str	x8, [x0, #4240]
	adrp	x8, throw_2_asm_h
	add	x8, x8, :lo12:throw_2_asm_h
	str	x8, [x0, #4248]
	adrp	x8, throw_var_2_asm_h
	add	x8, x8, :lo12:throw_var_2_asm_h
	str	x8, [x0, #4256]
	adrp	x8, eval_2_asm_h
	add	x8, x8, :lo12:eval_2_asm_h
	str	x8, [x0, #4264]
	adrp	x8, regexp_2_asm_h
	add	x8, x8, :lo12:regexp_2_asm_h
	str	x8, [x0, #4272]
	adrp	x8, get_super_ctor_2_asm_h
	add	x8, x8, :lo12:get_super_ctor_2_asm_h
	str	x8, [x0, #4280]
	adrp	x8, get_super_2_asm_h
	add	x8, x8, :lo12:get_super_2_asm_h
	str	x8, [x0, #4288]
	adrp	x8, import_2_asm_h
	add	x8, x8, :lo12:import_2_asm_h
	str	x8, [x0, #4296]
	adrp	x8, check_var_2_asm_h
	add	x8, x8, :lo12:check_var_2_asm_h
	str	x8, [x0, #4304]
	adrp	x8, get_var_undef_2_asm_h
	add	x8, x8, :lo12:get_var_undef_2_asm_h
	str	x8, [x0, #4312]
	adrp	x8, get_var_2_asm_h
	add	x8, x8, :lo12:get_var_2_asm_h
	str	x8, [x0, #4320]
	adrp	x8, put_var_2_asm_h
	add	x8, x8, :lo12:put_var_2_asm_h
	str	x8, [x0, #4328]
	adrp	x8, put_var_init_2_asm_h
	add	x8, x8, :lo12:put_var_init_2_asm_h
	str	x8, [x0, #4336]
	adrp	x8, put_var_strict_2_asm_h
	add	x8, x8, :lo12:put_var_strict_2_asm_h
	str	x8, [x0, #4344]
	adrp	x8, get_ref_value_2_asm_h
	add	x8, x8, :lo12:get_ref_value_2_asm_h
	str	x8, [x0, #4352]
	adrp	x8, put_ref_value_2_asm_h
	add	x8, x8, :lo12:put_ref_value_2_asm_h
	str	x8, [x0, #4360]
	adrp	x8, define_var_2_asm_h
	add	x8, x8, :lo12:define_var_2_asm_h
	str	x8, [x0, #4368]
	adrp	x8, check_define_var_2_asm_h
	add	x8, x8, :lo12:check_define_var_2_asm_h
	str	x8, [x0, #4376]
	adrp	x8, define_func_2_asm_h
	add	x8, x8, :lo12:define_func_2_asm_h
	str	x8, [x0, #4384]
	adrp	x8, get_field_2_asm_h
	add	x8, x8, :lo12:get_field_2_asm_h
	str	x8, [x0, #4392]
	adrp	x8, get_field2_2_asm_h
	add	x8, x8, :lo12:get_field2_2_asm_h
	str	x8, [x0, #4400]
	adrp	x8, put_field_2_asm_h
	add	x8, x8, :lo12:put_field_2_asm_h
	str	x8, [x0, #4408]
	adrp	x8, get_private_field_2_asm_h
	add	x8, x8, :lo12:get_private_field_2_asm_h
	str	x8, [x0, #4416]
	adrp	x8, put_private_field_2_asm_h
	add	x8, x8, :lo12:put_private_field_2_asm_h
	str	x8, [x0, #4424]
	adrp	x8, define_private_field_2_asm_h
	add	x8, x8, :lo12:define_private_field_2_asm_h
	str	x8, [x0, #4432]
	adrp	x8, get_array_el_2_asm_h
	add	x8, x8, :lo12:get_array_el_2_asm_h
	str	x8, [x0, #4440]
	adrp	x8, get_array_el2_2_asm_h
	add	x8, x8, :lo12:get_array_el2_2_asm_h
	str	x8, [x0, #4448]
	adrp	x8, put_array_el_2_asm_h
	add	x8, x8, :lo12:put_array_el_2_asm_h
	str	x8, [x0, #4456]
	adrp	x8, get_super_value_2_asm_h
	add	x8, x8, :lo12:get_super_value_2_asm_h
	str	x8, [x0, #4464]
	adrp	x8, put_super_value_2_asm_h
	add	x8, x8, :lo12:put_super_value_2_asm_h
	str	x8, [x0, #4472]
	adrp	x8, define_field_2_asm_h
	add	x8, x8, :lo12:define_field_2_asm_h
	str	x8, [x0, #4480]
	adrp	x8, set_name_2_asm_h
	add	x8, x8, :lo12:set_name_2_asm_h
	str	x8, [x0, #4488]
	adrp	x8, set_name_computed_2_asm_h
	add	x8, x8, :lo12:set_name_computed_2_asm_h
	str	x8, [x0, #4496]
	adrp	x8, set_proto_2_asm_h
	add	x8, x8, :lo12:set_proto_2_asm_h
	str	x8, [x0, #4504]
	adrp	x8, set_home_object_2_asm_h
	add	x8, x8, :lo12:set_home_object_2_asm_h
	str	x8, [x0, #4512]
	adrp	x8, define_array_el_2_asm_h
	add	x8, x8, :lo12:define_array_el_2_asm_h
	str	x8, [x0, #4520]
	adrp	x8, append_2_asm_h
	add	x8, x8, :lo12:append_2_asm_h
	str	x8, [x0, #4528]
	adrp	x8, copy_data_properties_2_asm_h
	add	x8, x8, :lo12:copy_data_properties_2_asm_h
	str	x8, [x0, #4536]
	adrp	x8, define_method_2_asm_h
	add	x8, x8, :lo12:define_method_2_asm_h
	str	x8, [x0, #4544]
	adrp	x8, define_method_computed_2_asm_h
	add	x8, x8, :lo12:define_method_computed_2_asm_h
	str	x8, [x0, #4552]
	adrp	x8, define_class_2_asm_h
	add	x8, x8, :lo12:define_class_2_asm_h
	str	x8, [x0, #4560]
	adrp	x8, get_loc_2_asm_h
	add	x8, x8, :lo12:get_loc_2_asm_h
	str	x8, [x0, #4568]
	adrp	x8, put_loc_2_asm_h
	add	x8, x8, :lo12:put_loc_2_asm_h
	str	x8, [x0, #4576]
	adrp	x8, set_loc_2_asm_h
	add	x8, x8, :lo12:set_loc_2_asm_h
	str	x8, [x0, #4584]
	adrp	x8, get_arg_2_asm_h
	add	x8, x8, :lo12:get_arg_2_asm_h
	str	x8, [x0, #4592]
	adrp	x8, put_arg_2_asm_h
	add	x8, x8, :lo12:put_arg_2_asm_h
	str	x8, [x0, #4600]
	adrp	x8, set_arg_2_asm_h
	add	x8, x8, :lo12:set_arg_2_asm_h
	str	x8, [x0, #4608]
	adrp	x8, get_var_ref_2_asm_h
	add	x8, x8, :lo12:get_var_ref_2_asm_h
	str	x8, [x0, #4616]
	adrp	x8, put_var_ref_2_asm_h
	add	x8, x8, :lo12:put_var_ref_2_asm_h
	str	x8, [x0, #4624]
	adrp	x8, set_var_ref_2_asm_h
	add	x8, x8, :lo12:set_var_ref_2_asm_h
	str	x8, [x0, #4632]
	adrp	x8, set_loc_uninitialized_2_asm_h
	add	x8, x8, :lo12:set_loc_uninitialized_2_asm_h
	str	x8, [x0, #4640]
	adrp	x8, get_loc_check_2_asm_h
	add	x8, x8, :lo12:get_loc_check_2_asm_h
	str	x8, [x0, #4648]
	adrp	x8, put_loc_check_2_asm_h
	add	x8, x8, :lo12:put_loc_check_2_asm_h
	str	x8, [x0, #4656]
	adrp	x8, put_loc_check_init_2_asm_h
	add	x8, x8, :lo12:put_loc_check_init_2_asm_h
	str	x8, [x0, #4664]
	adrp	x8, get_var_ref_check_2_asm_h
	add	x8, x8, :lo12:get_var_ref_check_2_asm_h
	str	x8, [x0, #4672]
	adrp	x8, put_var_ref_check_2_asm_h
	add	x8, x8, :lo12:put_var_ref_check_2_asm_h
	str	x8, [x0, #4680]
	adrp	x8, put_var_ref_check_init_2_asm_h
	add	x8, x8, :lo12:put_var_ref_check_init_2_asm_h
	str	x8, [x0, #4688]
	adrp	x8, close_loc_2_asm_h
	add	x8, x8, :lo12:close_loc_2_asm_h
	str	x8, [x0, #4696]
	adrp	x8, if_false_2_asm_h
	add	x8, x8, :lo12:if_false_2_asm_h
	str	x8, [x0, #4704]
	adrp	x8, if_true_2_asm_h
	add	x8, x8, :lo12:if_true_2_asm_h
	str	x8, [x0, #4712]
	adrp	x8, goto_2_asm_h
	add	x8, x8, :lo12:goto_2_asm_h
	str	x8, [x0, #4720]
	adrp	x8, catch_2_asm_h
	add	x8, x8, :lo12:catch_2_asm_h
	str	x8, [x0, #4728]
	adrp	x8, gosub_2_asm_h
	add	x8, x8, :lo12:gosub_2_asm_h
	str	x8, [x0, #4736]
	adrp	x8, ret_2_asm_h
	add	x8, x8, :lo12:ret_2_asm_h
	str	x8, [x0, #4744]
	adrp	x8, to_object_2_asm_h
	add	x8, x8, :lo12:to_object_2_asm_h
	str	x8, [x0, #4752]
	adrp	x8, to_propkey_2_asm_h
	add	x8, x8, :lo12:to_propkey_2_asm_h
	str	x8, [x0, #4760]
	adrp	x8, to_propkey2_2_asm_h
	add	x8, x8, :lo12:to_propkey2_2_asm_h
	str	x8, [x0, #4768]
	adrp	x8, with_get_var_2_asm_h
	add	x8, x8, :lo12:with_get_var_2_asm_h
	str	x8, [x0, #4776]
	adrp	x8, with_put_var_2_asm_h
	add	x8, x8, :lo12:with_put_var_2_asm_h
	str	x8, [x0, #4784]
	adrp	x8, with_delete_var_2_asm_h
	add	x8, x8, :lo12:with_delete_var_2_asm_h
	str	x8, [x0, #4792]
	adrp	x8, with_make_ref_2_asm_h
	add	x8, x8, :lo12:with_make_ref_2_asm_h
	str	x8, [x0, #4800]
	adrp	x8, with_get_ref_2_asm_h
	add	x8, x8, :lo12:with_get_ref_2_asm_h
	str	x8, [x0, #4808]
	adrp	x8, with_get_ref_undef_2_asm_h
	add	x8, x8, :lo12:with_get_ref_undef_2_asm_h
	str	x8, [x0, #4816]
	adrp	x8, make_loc_ref_2_asm_h
	add	x8, x8, :lo12:make_loc_ref_2_asm_h
	str	x8, [x0, #4824]
	adrp	x8, make_arg_ref_2_asm_h
	add	x8, x8, :lo12:make_arg_ref_2_asm_h
	str	x8, [x0, #4832]
	adrp	x8, make_var_ref_ref_2_asm_h
	add	x8, x8, :lo12:make_var_ref_ref_2_asm_h
	str	x8, [x0, #4840]
	adrp	x8, make_var_ref_2_asm_h
	add	x8, x8, :lo12:make_var_ref_2_asm_h
	str	x8, [x0, #4848]
	adrp	x8, for_in_start_2_asm_h
	add	x8, x8, :lo12:for_in_start_2_asm_h
	str	x8, [x0, #4856]
	adrp	x8, for_of_start_2_asm_h
	add	x8, x8, :lo12:for_of_start_2_asm_h
	str	x8, [x0, #4864]
	adrp	x8, for_await_of_start_2_asm_h
	add	x8, x8, :lo12:for_await_of_start_2_asm_h
	str	x8, [x0, #4872]
	adrp	x8, for_in_next_2_asm_h
	add	x8, x8, :lo12:for_in_next_2_asm_h
	str	x8, [x0, #4880]
	adrp	x8, for_of_next_2_asm_h
	add	x8, x8, :lo12:for_of_next_2_asm_h
	str	x8, [x0, #4888]
	adrp	x8, for_await_of_next_2_asm_h
	add	x8, x8, :lo12:for_await_of_next_2_asm_h
	str	x8, [x0, #4896]
	adrp	x8, iterator_get_value_done_2_asm_h
	add	x8, x8, :lo12:iterator_get_value_done_2_asm_h
	str	x8, [x0, #4904]
	adrp	x8, iterator_close_2_asm_h
	add	x8, x8, :lo12:iterator_close_2_asm_h
	str	x8, [x0, #4912]
	adrp	x8, iterator_close_return_2_asm_h
	add	x8, x8, :lo12:iterator_close_return_2_asm_h
	str	x8, [x0, #4920]
	adrp	x8, async_iterator_close_2_asm_h
	add	x8, x8, :lo12:async_iterator_close_2_asm_h
	str	x8, [x0, #4928]
	adrp	x8, async_iterator_next_2_asm_h
	add	x8, x8, :lo12:async_iterator_next_2_asm_h
	str	x8, [x0, #4936]
	adrp	x8, async_iterator_get_2_asm_h
	add	x8, x8, :lo12:async_iterator_get_2_asm_h
	str	x8, [x0, #4944]
	adrp	x8, initial_yield_2_asm_h
	add	x8, x8, :lo12:initial_yield_2_asm_h
	str	x8, [x0, #4952]
	adrp	x8, yield_2_asm_h
	add	x8, x8, :lo12:yield_2_asm_h
	str	x8, [x0, #4960]
	adrp	x8, yield_star_2_asm_h
	add	x8, x8, :lo12:yield_star_2_asm_h
	str	x8, [x0, #4968]
	adrp	x8, async_yield_star_2_asm_h
	add	x8, x8, :lo12:async_yield_star_2_asm_h
	str	x8, [x0, #4976]
	adrp	x8, await_2_asm_h
	add	x8, x8, :lo12:await_2_asm_h
	str	x8, [x0, #4984]
	adrp	x8, neg_2_asm_h
	add	x8, x8, :lo12:neg_2_asm_h
	str	x8, [x0, #4992]
	adrp	x8, plus_2_asm_h
	add	x8, x8, :lo12:plus_2_asm_h
	str	x8, [x0, #5000]
	adrp	x8, dec_2_asm_h
	add	x8, x8, :lo12:dec_2_asm_h
	str	x8, [x0, #5008]
	adrp	x8, inc_2_asm_h
	add	x8, x8, :lo12:inc_2_asm_h
	str	x8, [x0, #5016]
	adrp	x8, post_dec_2_asm_h
	add	x8, x8, :lo12:post_dec_2_asm_h
	str	x8, [x0, #5024]
	adrp	x8, post_inc_2_asm_h
	add	x8, x8, :lo12:post_inc_2_asm_h
	str	x8, [x0, #5032]
	adrp	x8, dec_loc_2_asm_h
	add	x8, x8, :lo12:dec_loc_2_asm_h
	str	x8, [x0, #5040]
	adrp	x8, inc_loc_2_asm_h
	add	x8, x8, :lo12:inc_loc_2_asm_h
	str	x8, [x0, #5048]
	adrp	x8, add_loc_2_asm_h
	add	x8, x8, :lo12:add_loc_2_asm_h
	str	x8, [x0, #5056]
	adrp	x8, not_2_asm_h
	add	x8, x8, :lo12:not_2_asm_h
	str	x8, [x0, #5064]
	adrp	x8, lnot_2_asm_h
	add	x8, x8, :lo12:lnot_2_asm_h
	str	x8, [x0, #5072]
	adrp	x8, typeof_2_asm_h
	add	x8, x8, :lo12:typeof_2_asm_h
	str	x8, [x0, #5080]
	adrp	x8, delete_2_asm_h
	add	x8, x8, :lo12:delete_2_asm_h
	str	x8, [x0, #5088]
	adrp	x8, delete_var_2_asm_h
	add	x8, x8, :lo12:delete_var_2_asm_h
	str	x8, [x0, #5096]
	adrp	x8, mul_2_asm_h
	add	x8, x8, :lo12:mul_2_asm_h
	str	x8, [x0, #5104]
	adrp	x8, div_2_asm_h
	add	x8, x8, :lo12:div_2_asm_h
	str	x8, [x0, #5112]
	adrp	x8, mod_2_asm_h
	add	x8, x8, :lo12:mod_2_asm_h
	str	x8, [x0, #5120]
	adrp	x8, add_2_asm_h
	add	x8, x8, :lo12:add_2_asm_h
	str	x8, [x0, #5128]
	adrp	x8, sub_2_asm_h
	add	x8, x8, :lo12:sub_2_asm_h
	str	x8, [x0, #5136]
	adrp	x8, pow_2_asm_h
	add	x8, x8, :lo12:pow_2_asm_h
	str	x8, [x0, #5144]
	adrp	x8, shl_2_asm_h
	add	x8, x8, :lo12:shl_2_asm_h
	str	x8, [x0, #5152]
	adrp	x8, sar_2_asm_h
	add	x8, x8, :lo12:sar_2_asm_h
	str	x8, [x0, #5160]
	adrp	x8, shr_2_asm_h
	add	x8, x8, :lo12:shr_2_asm_h
	str	x8, [x0, #5168]
	adrp	x8, lt_2_asm_h
	add	x8, x8, :lo12:lt_2_asm_h
	str	x8, [x0, #5176]
	adrp	x8, lte_2_asm_h
	add	x8, x8, :lo12:lte_2_asm_h
	str	x8, [x0, #5184]
	adrp	x8, gt_2_asm_h
	add	x8, x8, :lo12:gt_2_asm_h
	str	x8, [x0, #5192]
	adrp	x8, gte_2_asm_h
	add	x8, x8, :lo12:gte_2_asm_h
	str	x8, [x0, #5200]
	adrp	x8, instanceof_2_asm_h
	add	x8, x8, :lo12:instanceof_2_asm_h
	str	x8, [x0, #5208]
	adrp	x8, in_2_asm_h
	add	x8, x8, :lo12:in_2_asm_h
	str	x8, [x0, #5216]
	adrp	x8, eq_2_asm_h
	add	x8, x8, :lo12:eq_2_asm_h
	str	x8, [x0, #5224]
	adrp	x8, neq_2_asm_h
	add	x8, x8, :lo12:neq_2_asm_h
	str	x8, [x0, #5232]
	adrp	x8, strict_eq_2_asm_h
	add	x8, x8, :lo12:strict_eq_2_asm_h
	str	x8, [x0, #5240]
	adrp	x8, strict_neq_2_asm_h
	add	x8, x8, :lo12:strict_neq_2_asm_h
	str	x8, [x0, #5248]
	adrp	x8, and_2_asm_h
	add	x8, x8, :lo12:and_2_asm_h
	str	x8, [x0, #5256]
	adrp	x8, xor_2_asm_h
	add	x8, x8, :lo12:xor_2_asm_h
	str	x8, [x0, #5264]
	adrp	x8, or_2_asm_h
	add	x8, x8, :lo12:or_2_asm_h
	str	x8, [x0, #5272]
	adrp	x8, nop_2_asm_h
	add	x8, x8, :lo12:nop_2_asm_h
	str	x8, [x0, #5280]
	adrp	x8, push_minus1_2_asm_h
	add	x8, x8, :lo12:push_minus1_2_asm_h
	str	x8, [x0, #5288]
	adrp	x8, push_0_2_asm_h
	add	x8, x8, :lo12:push_0_2_asm_h
	str	x8, [x0, #5296]
	adrp	x8, push_1_2_asm_h
	add	x8, x8, :lo12:push_1_2_asm_h
	str	x8, [x0, #5304]
	adrp	x8, push_2_2_asm_h
	add	x8, x8, :lo12:push_2_2_asm_h
	str	x8, [x0, #5312]
	adrp	x8, push_3_2_asm_h
	add	x8, x8, :lo12:push_3_2_asm_h
	str	x8, [x0, #5320]
	adrp	x8, push_4_2_asm_h
	add	x8, x8, :lo12:push_4_2_asm_h
	str	x8, [x0, #5328]
	adrp	x8, push_5_2_asm_h
	add	x8, x8, :lo12:push_5_2_asm_h
	str	x8, [x0, #5336]
	adrp	x8, push_6_2_asm_h
	add	x8, x8, :lo12:push_6_2_asm_h
	str	x8, [x0, #5344]
	adrp	x8, push_7_2_asm_h
	add	x8, x8, :lo12:push_7_2_asm_h
	str	x8, [x0, #5352]
	adrp	x8, push_i8_2_asm_h
	add	x8, x8, :lo12:push_i8_2_asm_h
	str	x8, [x0, #5360]
	adrp	x8, push_i16_2_asm_h
	add	x8, x8, :lo12:push_i16_2_asm_h
	str	x8, [x0, #5368]
	adrp	x8, push_const8_2_asm_h
	add	x8, x8, :lo12:push_const8_2_asm_h
	str	x8, [x0, #5376]
	adrp	x8, fclosure8_2_asm_h
	add	x8, x8, :lo12:fclosure8_2_asm_h
	str	x8, [x0, #5384]
	adrp	x8, push_empty_string_2_asm_h
	add	x8, x8, :lo12:push_empty_string_2_asm_h
	str	x8, [x0, #5392]
	adrp	x8, get_loc8_2_asm_h
	add	x8, x8, :lo12:get_loc8_2_asm_h
	str	x8, [x0, #5400]
	adrp	x8, put_loc8_2_asm_h
	add	x8, x8, :lo12:put_loc8_2_asm_h
	str	x8, [x0, #5408]
	adrp	x8, set_loc8_2_asm_h
	add	x8, x8, :lo12:set_loc8_2_asm_h
	str	x8, [x0, #5416]
	adrp	x8, get_loc0_2_asm_h
	add	x8, x8, :lo12:get_loc0_2_asm_h
	str	x8, [x0, #5424]
	adrp	x8, get_loc1_2_asm_h
	add	x8, x8, :lo12:get_loc1_2_asm_h
	str	x8, [x0, #5432]
	adrp	x8, get_loc2_2_asm_h
	add	x8, x8, :lo12:get_loc2_2_asm_h
	str	x8, [x0, #5440]
	adrp	x8, get_loc3_2_asm_h
	add	x8, x8, :lo12:get_loc3_2_asm_h
	str	x8, [x0, #5448]
	adrp	x8, put_loc0_2_asm_h
	add	x8, x8, :lo12:put_loc0_2_asm_h
	str	x8, [x0, #5456]
	adrp	x8, put_loc1_2_asm_h
	add	x8, x8, :lo12:put_loc1_2_asm_h
	str	x8, [x0, #5464]
	adrp	x8, put_loc2_2_asm_h
	add	x8, x8, :lo12:put_loc2_2_asm_h
	str	x8, [x0, #5472]
	adrp	x8, put_loc3_2_asm_h
	add	x8, x8, :lo12:put_loc3_2_asm_h
	str	x8, [x0, #5480]
	adrp	x8, set_loc0_2_asm_h
	add	x8, x8, :lo12:set_loc0_2_asm_h
	str	x8, [x0, #5488]
	adrp	x8, set_loc1_2_asm_h
	add	x8, x8, :lo12:set_loc1_2_asm_h
	str	x8, [x0, #5496]
	adrp	x8, set_loc2_2_asm_h
	add	x8, x8, :lo12:set_loc2_2_asm_h
	str	x8, [x0, #5504]
	adrp	x8, set_loc3_2_asm_h
	add	x8, x8, :lo12:set_loc3_2_asm_h
	str	x8, [x0, #5512]
	adrp	x8, get_arg0_2_asm_h
	add	x8, x8, :lo12:get_arg0_2_asm_h
	str	x8, [x0, #5520]
	adrp	x8, get_arg1_2_asm_h
	add	x8, x8, :lo12:get_arg1_2_asm_h
	str	x8, [x0, #5528]
	adrp	x8, get_arg2_2_asm_h
	add	x8, x8, :lo12:get_arg2_2_asm_h
	str	x8, [x0, #5536]
	adrp	x8, get_arg3_2_asm_h
	add	x8, x8, :lo12:get_arg3_2_asm_h
	str	x8, [x0, #5544]
	adrp	x8, put_arg0_2_asm_h
	add	x8, x8, :lo12:put_arg0_2_asm_h
	str	x8, [x0, #5552]
	adrp	x8, put_arg1_2_asm_h
	add	x8, x8, :lo12:put_arg1_2_asm_h
	str	x8, [x0, #5560]
	adrp	x8, put_arg2_2_asm_h
	add	x8, x8, :lo12:put_arg2_2_asm_h
	str	x8, [x0, #5568]
	adrp	x8, put_arg3_2_asm_h
	add	x8, x8, :lo12:put_arg3_2_asm_h
	str	x8, [x0, #5576]
	adrp	x8, set_arg0_2_asm_h
	add	x8, x8, :lo12:set_arg0_2_asm_h
	str	x8, [x0, #5584]
	adrp	x8, set_arg1_2_asm_h
	add	x8, x8, :lo12:set_arg1_2_asm_h
	str	x8, [x0, #5592]
	adrp	x8, set_arg2_2_asm_h
	add	x8, x8, :lo12:set_arg2_2_asm_h
	str	x8, [x0, #5600]
	adrp	x8, set_arg3_2_asm_h
	add	x8, x8, :lo12:set_arg3_2_asm_h
	str	x8, [x0, #5608]
	adrp	x8, get_var_ref0_2_asm_h
	add	x8, x8, :lo12:get_var_ref0_2_asm_h
	str	x8, [x0, #5616]
	adrp	x8, get_var_ref1_2_asm_h
	add	x8, x8, :lo12:get_var_ref1_2_asm_h
	str	x8, [x0, #5624]
	adrp	x8, get_var_ref2_2_asm_h
	add	x8, x8, :lo12:get_var_ref2_2_asm_h
	str	x8, [x0, #5632]
	adrp	x8, get_var_ref3_2_asm_h
	add	x8, x8, :lo12:get_var_ref3_2_asm_h
	str	x8, [x0, #5640]
	adrp	x8, put_var_ref0_2_asm_h
	add	x8, x8, :lo12:put_var_ref0_2_asm_h
	str	x8, [x0, #5648]
	adrp	x8, put_var_ref1_2_asm_h
	add	x8, x8, :lo12:put_var_ref1_2_asm_h
	str	x8, [x0, #5656]
	adrp	x8, put_var_ref2_2_asm_h
	add	x8, x8, :lo12:put_var_ref2_2_asm_h
	str	x8, [x0, #5664]
	adrp	x8, put_var_ref3_2_asm_h
	add	x8, x8, :lo12:put_var_ref3_2_asm_h
	str	x8, [x0, #5672]
	adrp	x8, set_var_ref0_2_asm_h
	add	x8, x8, :lo12:set_var_ref0_2_asm_h
	str	x8, [x0, #5680]
	adrp	x8, set_var_ref1_2_asm_h
	add	x8, x8, :lo12:set_var_ref1_2_asm_h
	str	x8, [x0, #5688]
	adrp	x8, set_var_ref2_2_asm_h
	add	x8, x8, :lo12:set_var_ref2_2_asm_h
	str	x8, [x0, #5696]
	adrp	x8, set_var_ref3_2_asm_h
	add	x8, x8, :lo12:set_var_ref3_2_asm_h
	str	x8, [x0, #5704]
	adrp	x8, get_length_2_asm_h
	add	x8, x8, :lo12:get_length_2_asm_h
	str	x8, [x0, #5712]
	adrp	x8, if_false8_2_asm_h
	add	x8, x8, :lo12:if_false8_2_asm_h
	str	x8, [x0, #5720]
	adrp	x8, if_true8_2_asm_h
	add	x8, x8, :lo12:if_true8_2_asm_h
	str	x8, [x0, #5728]
	adrp	x8, goto8_2_asm_h
	add	x8, x8, :lo12:goto8_2_asm_h
	str	x8, [x0, #5736]
	adrp	x8, goto16_2_asm_h
	add	x8, x8, :lo12:goto16_2_asm_h
	str	x8, [x0, #5744]
	adrp	x8, call0_2_asm_h
	add	x8, x8, :lo12:call0_2_asm_h
	str	x8, [x0, #5752]
	adrp	x8, call1_2_asm_h
	add	x8, x8, :lo12:call1_2_asm_h
	str	x8, [x0, #5760]
	adrp	x8, call2_2_asm_h
	add	x8, x8, :lo12:call2_2_asm_h
	str	x8, [x0, #5768]
	adrp	x8, call3_2_asm_h
	add	x8, x8, :lo12:call3_2_asm_h
	str	x8, [x0, #5776]
	adrp	x8, is_undefined_2_asm_h
	add	x8, x8, :lo12:is_undefined_2_asm_h
	str	x8, [x0, #5784]
	adrp	x8, is_null_2_asm_h
	add	x8, x8, :lo12:is_null_2_asm_h
	str	x8, [x0, #5792]
	adrp	x8, is_function_2_asm_h
	add	x8, x8, :lo12:is_function_2_asm_h
	str	x8, [x0, #5800]
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	ret
.Lfunc_end747:
	.size	InstallBcHandler, .Lfunc_end747-InstallBcHandler
	.cfi_endproc
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
	ldr	x23, [x8, #240]
	bl	common_call_from_entry_asm_h
	ldp	x29, x30, [sp, #80]             // 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             // 16-byte Folded Reload
	ldp	x22, x21, [sp, #48]             // 16-byte Folded Reload
	ldp	x24, x23, [sp, #32]             // 16-byte Folded Reload
	ldp	x26, x25, [sp, #16]             // 16-byte Folded Reload
	ldp	x28, x27, [sp], #96             // 16-byte Folded Reload
	ret
.Lfunc_end748:
	.size	_call_stub_entry, .Lfunc_end748-_call_stub_entry
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

	.section	".note.GNU-stack","",@progbits
#endif
