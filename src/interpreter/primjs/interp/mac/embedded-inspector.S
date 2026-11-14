#if defined(__aarch64__) && defined(ENABLE_PRIMJS_SNAPSHOT) && defined(ENABLE_QUICKJS_DEBUGGER)
	.section	__TEXT,__text,regular,pure_instructions
	.p2align	7                               ; -- Begin function call_native_entry_asm_h
l_call_native_entry_asm_h:              ; @call_native_entry_asm_h
	.cfi_startproc
; %bb.0:                                ; %B29
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	ldrh	w9, [x22, #6]
	ldr	x8, [x24, #8]
	mov	x5, x19
	add	w10, w9, w9, lsl #2
	ldr	x8, [x8, #80]
	cmp	w9, #12
	add	w10, w10, #3
	ldr	x8, [x8, w10, uxtw #3]
	b.ne	LBB0_26
; %bb.1:                                ; %B12
	ldrb	w9, [x22, #40]
	mov	w3, w0
	cmp	w3, w9
	b.lt	LBB0_31
; %bb.2:                                ; %B26
	ldr	x8, [x24, #296]
	ldr	x9, [x24, #296]
	ldr	x19, [x8, #8]
	ldr	x9, [x9]
	sub	x8, x19, #160
	cmp	x8, x9
	b.ls	LBB0_29
; %bb.3:                                ; %B15
	ldr	x9, [x24, #296]
	mov	x28, x20
	mov	x27, xzr
	str	x8, [x9, #8]
	stp	x23, x22, [x8]
	stp	xzr, xzr, [x8, #48]
	stp	w3, wzr, [x8, #40]
	stp	x20, xzr, [x8, #16]
	stp	x21, xzr, [x8, #64]
	str	wzr, [x8, #80]
	ldr	x9, [x24, #8]
	str	x8, [x9, #256]
	ldrb	w9, [x22, #41]
	ldr	x8, [x22, #32]
	cmp	w9, #7
	b.gt	LBB0_8
; %bb.4:                                ; %B15
	cmp	w9, #3
	b.gt	LBB0_12
; %bb.5:                                ; %B15
	cbz	w9, LBB0_19
; %bb.6:                                ; %B15
	cmp	w9, #1
	b.ne	LBB0_24
; %bb.7:                                ; %B19
	ldrsh	w4, [x22, #42]
	mov	x1, x21
	mov	x0, x24
	b	LBB0_15
LBB0_8:                                 ; %B15
	cmp	w9, #9
	b.gt	LBB0_16
; %bb.9:                                ; %B15
	cmp	w9, #8
	b.eq	LBB0_20
; %bb.10:                               ; %B15
	cmp	w9, #9
	b.ne	LBB0_24
; %bb.11:                               ; %B22
	ldr	x2, [x20]
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	LBB0_25
LBB0_12:                                ; %B15
	cmp	w9, #4
	b.eq	LBB0_21
; %bb.13:                               ; %B15
	cmp	w9, #5
	b.ne	LBB0_24
; %bb.14:                               ; %B18
	ldrsh	w4, [x22, #42]
	mov	x0, x24
	mov	w1, #18                         ; =0x12
LBB0_15:                                ; %B21
	mov	w2, w3
	mov	x3, x20
	blr	x8
	b	LBB0_25
LBB0_16:                                ; %B15
	cmp	w9, #10
	b.eq	LBB0_23
; %bb.17:                               ; %B15
	cmp	w9, #11
	b.ne	LBB0_24
; %bb.18:                               ; %B24
	ldr	x2, [x20]
	ldrsh	w3, [x22, #42]
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	LBB0_25
LBB0_19:                                ; %B17
	mov	x1, x21
	mov	x0, x24
	b	LBB0_22
LBB0_20:                                ; %B20
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	LBB0_25
LBB0_21:                                ; %B16
	mov	x0, x24
	mov	w1, #18                         ; =0x12
LBB0_22:                                ; %B21
	mov	w2, w3
	mov	x3, x20
	blr	x8
	b	LBB0_25
LBB0_23:                                ; %B23
	ldrsh	w2, [x22, #42]
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	LBB0_25
LBB0_24:                                ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	x4, x20
	bl	_prim_call_c_function_default
LBB0_25:                                ; %B21
	ldr	x8, [x24, #8]
	mov	x1, x0
	mov	x30, x28
	mov	x0, x1
	str	x23, [x8, #256]
	ldr	x8, [x24, #296]
	str	x19, [x8, #8]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
LBB0_26:                                ; %B29
	cmp	w9, #15
	b.ne	LBB0_30
; %bb.27:                               ; %B8
	ldr	x9, [x22, #32]
	mov	w2, w0
	ldrb	w10, [x9, #8]
	cmp	w2, w10
	b.lt	LBB0_31
; %bb.28:                               ; %B10
	ldr	x8, [x9]
	ldrh	w4, [x9, #10]
	add	x5, x9, #16
	mov	x0, x24
	mov	x1, x21
	mov	x3, x20
	blr	x8
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
LBB0_29:                                ; %B27
	mov	x19, x5
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	b	l_ThrowStackOverflow_Return_asm_h
LBB0_30:                                ; %B2
	cbz	x8, LBB0_32
LBB0_31:                                ; %B5
	mov	x3, x0
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	x4, x20
                                        ; kill: def $w3 killed $w3 killed $x3
                                        ; kill: def $w5 killed $w5 killed $x5
	blr	x8
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
LBB0_32:                                ; %B3
	mov	x19, x5
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	b	l_ThrowTypeErrorNotFunction_Return_asm_h
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function ThrowTypeErrorNotFunction_Return_asm_h
l_ThrowTypeErrorNotFunction_Return_asm_h: ; @ThrowTypeErrorNotFunction_Return_asm_h
; %bb.0:                                ; %B0
	mov	x0, x24
	mov	x22, x30
	bl	_JS_ThrowTypeErrorNotFunction
	mov	x30, x22
	ret
                                        ; -- End function
	.p2align	2                               ; -- Begin function ThrowStackOverflow_Return_asm_h
l_ThrowStackOverflow_Return_asm_h:      ; @ThrowStackOverflow_Return_asm_h
; %bb.0:                                ; %B0
	mov	x0, x24
	mov	x22, x30
	bl	_JS_ThrowStackOverflow
	mov	x30, x22
	ret
                                        ; -- End function
	.p2align	2                               ; -- Begin function call_native_asm_h
l_call_native_asm_h:                    ; @call_native_asm_h
	.cfi_startproc
; %bb.0:                                ; %B29
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
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
	b.ne	LBB3_26
; %bb.1:                                ; %B12
	ldrb	w9, [x22, #40]
	mov	w3, w0
	cmp	w3, w9
	b.lt	LBB3_31
; %bb.2:                                ; %B26
	ldr	x8, [x24, #296]
	ldr	x9, [x24, #296]
	ldr	x10, [x8, #8]
	ldr	x9, [x9]
	sub	x8, x10, #160
	cmp	x8, x9
	b.ls	LBB3_29
; %bb.3:                                ; %B15
	ldr	x9, [x24, #296]
	mov	x19, x10
	mov	x28, x20
	mov	x27, xzr
	str	x8, [x9, #8]
	stp	x23, x22, [x8]
	stp	xzr, xzr, [x8, #48]
	stp	w3, wzr, [x8, #40]
	stp	x20, xzr, [x8, #16]
	stp	x21, xzr, [x8, #64]
	str	wzr, [x8, #80]
	ldr	x9, [x24, #8]
	str	x8, [x9, #256]
	ldrb	w9, [x22, #41]
	ldr	x8, [x22, #32]
	cmp	w9, #7
	b.gt	LBB3_8
; %bb.4:                                ; %B15
	cmp	w9, #3
	b.gt	LBB3_12
; %bb.5:                                ; %B15
	cbz	w9, LBB3_19
; %bb.6:                                ; %B15
	cmp	w9, #1
	b.ne	LBB3_24
; %bb.7:                                ; %B19
	ldrsh	w4, [x22, #42]
	mov	x1, x21
	mov	x0, x24
	b	LBB3_15
LBB3_8:                                 ; %B15
	cmp	w9, #9
	b.gt	LBB3_16
; %bb.9:                                ; %B15
	cmp	w9, #8
	b.eq	LBB3_20
; %bb.10:                               ; %B15
	cmp	w9, #9
	b.ne	LBB3_24
; %bb.11:                               ; %B22
	ldr	x2, [x20]
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	LBB3_25
LBB3_12:                                ; %B15
	cmp	w9, #4
	b.eq	LBB3_21
; %bb.13:                               ; %B15
	cmp	w9, #5
	b.ne	LBB3_24
; %bb.14:                               ; %B18
	ldrsh	w4, [x22, #42]
	mov	x0, x24
	mov	w1, #18                         ; =0x12
LBB3_15:                                ; %B21
	mov	w2, w3
	mov	x3, x20
	blr	x8
	b	LBB3_25
LBB3_16:                                ; %B15
	cmp	w9, #10
	b.eq	LBB3_23
; %bb.17:                               ; %B15
	cmp	w9, #11
	b.ne	LBB3_24
; %bb.18:                               ; %B24
	ldr	x2, [x20]
	ldrsh	w3, [x22, #42]
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	LBB3_25
LBB3_19:                                ; %B17
	mov	x1, x21
	mov	x0, x24
	b	LBB3_22
LBB3_20:                                ; %B20
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	LBB3_25
LBB3_21:                                ; %B16
	mov	x0, x24
	mov	w1, #18                         ; =0x12
LBB3_22:                                ; %B21
	mov	w2, w3
	mov	x3, x20
	blr	x8
	b	LBB3_25
LBB3_23:                                ; %B23
	ldrsh	w2, [x22, #42]
	mov	x0, x24
	mov	x1, x21
	blr	x8
	b	LBB3_25
LBB3_24:                                ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	x4, x20
	bl	_prim_call_c_function_default
LBB3_25:                                ; %B21
	ldr	x8, [x24, #8]
	mov	x1, x0
	mov	x30, x28
	mov	x0, x1
	str	x23, [x8, #256]
	ldr	x8, [x24, #296]
	str	x19, [x8, #8]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
LBB3_26:                                ; %B29
	cmp	w9, #15
	b.ne	LBB3_30
; %bb.27:                               ; %B8
	ldr	x9, [x22, #32]
	mov	w2, w0
	ldrb	w10, [x9, #8]
	cmp	w2, w10
	b.lt	LBB3_31
; %bb.28:                               ; %B10
	ldr	x8, [x9]
	ldrh	w4, [x9, #10]
	add	x5, x9, #16
	mov	x0, x24
	mov	x1, x21
	mov	x3, x20
	blr	x8
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
LBB3_29:                                ; %B27
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	b	l_ThrowStackOverflow_Return_asm_h
LBB3_30:                                ; %B2
	cbz	x8, LBB3_32
LBB3_31:                                ; %B5
	mov	x3, x0
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	x4, x20
	mov	w5, wzr
                                        ; kill: def $w3 killed $w3 killed $x3
	blr	x8
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
LBB3_32:                                ; %B3
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	b	l_ThrowTypeErrorNotFunction_Return_asm_h
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function common_call_from_entry_asm_h
l_common_call_from_entry_asm_h:         ; @common_call_from_entry_asm_h
; %bb.0:                                ; %B54
	tbz	w19, #2, LBB4_3
; %bb.1:                                ; %B45
	ldr	x9, [x24, #296]
	mov	x8, x30
	and	x10, x22, #0xfffffffffffc
	add	x11, x10, #16
	ldr	x9, [x9, #8]
	mov	x23, x11
	stp	x9, x8, [x10, #152]
	ldr	x8, [x24, #8]
	ldr	x9, [x8, #256]
	str	x9, [x10, #16]
	str	x11, [x8, #256]
	ldp	x27, x19, [x10, #40]
	ldr	w8, [x10, #12]
	ldr	x20, [x10, #64]
	ldr	x28, [x10, #32]
	ldr	x26, [x10, #120]
	cbz	w8, LBB4_14
; %bb.2:                                ; %B46
	b	l_exception_asm_h
LBB4_3:                                 ; %B48
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB4_15
; %bb.4:                                ; %B50
	ldrh	w8, [x22, #6]
	cmp	w8, #13
	b.ne	LBB4_16
; %bb.5:                                ; %B1
	ldr	x11, [x22, #32]
	ldr	x9, [x24, #296]
	mov	x12, x23
	ldr	x14, [x24, #296]
	ldrh	w10, [x11, #40]
	ldrh	w8, [x11, #42]
	ldrh	w15, [x11, #46]
	ldr	x13, [x9, #8]
	ldr	x14, [x14]
	cmp	w0, w10
	add	w9, w8, w15
	b.lt	LBB4_17
; %bb.6:                                ; %B42
	add	w9, w9, w0
	lsl	w9, w9, #3
	add	w9, w9, #160
	sub	x9, x13, x9
	cmp	x9, x14
	b.ls	LBB4_28
; %bb.7:                                ; %B44
	ldr	x14, [x24, #296]
	mov	x10, x30
	mov	x23, x9
	str	x9, [x14, #8]
	stp	x13, x10, [x9, #136]
	stp	x12, x22, [x9]
	str	x21, [x9, #64]
	stp	x21, x27, [x9, #88]
	ldr	x13, [x22, #40]
	str	x13, [x9, #104]
	mov	x26, x13
	ldrb	w10, [x11, #5]
	str	w10, [x9, #44]
	ldr	x19, [x11, #8]
	str	w0, [x9, #120]
	ldr	x12, [x11, #48]
	add	x11, x9, #160
	add	x10, x11, w0, uxtw #3
	str	x12, [x9, #112]
	mov	x12, x11
	cmp	x11, x10
	b.ge	LBB4_9
LBB4_8:                                 ; %B39
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x13, [x20], #8
	str	x13, [x12], #8
	cmp	x12, x10
	b.lt	LBB4_8
LBB4_9:                                 ; %B41
	add	w12, w0, w8
	str	w0, [x9, #40]
	add	x20, x10, x8, lsl #3
	stp	x11, x10, [x9, #16]
	mov	w8, #18                         ; =0x12
	mov	x28, x11
	str	xzr, [x9, #72]
	mov	x27, x10
	str	w12, [x9, #80]
	ldr	x12, [x24, #8]
	str	x9, [x12, #256]
	cmp	x10, x20
	b.ge	LBB4_11
LBB4_10:                                ; %B28
                                        ; =>This Inner Loop Header: Depth=1
	str	x8, [x10], #8
	cmp	x10, x20
	b.lt	LBB4_10
LBB4_11:                                ; %B29
	ldr	w8, [x24, #328]
	cbz	w8, LBB4_13
; %bb.12:                               ; %B30
	add	x1, x19, #1
	mov	x0, x24
	str	x20, [x9, #48]
	bl	_DebuggerCallEachFunc
LBB4_13:                                ; %B32
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.mi	LBB4_27
LBB4_14:                                ; %B34
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB4_15:                                ; %B53
	b	l_ThrowTypeErrorNotFunction_Return_asm_h
LBB4_16:                                ; %B51
	b	l_call_native_entry_asm_h
LBB4_17:                                ; %B23
	add	w9, w9, w10
	lsl	w9, w9, #3
	add	w9, w9, #160
	sub	x9, x13, x9
	cmp	x9, x14
	b.ls	LBB4_28
; %bb.18:                               ; %B25
	ldr	x15, [x24, #296]
	mov	x14, x30
	mov	x23, x9
	str	x9, [x15, #8]
	stp	x13, x14, [x9, #136]
	stp	x12, x22, [x9]
	str	x21, [x9, #64]
	stp	x21, x27, [x9, #88]
	ldr	x13, [x22, #40]
	str	x13, [x9, #104]
	mov	x26, x13
	ldrb	w12, [x11, #5]
	str	w12, [x9, #44]
	ldr	x19, [x11, #8]
	str	w0, [x9, #120]
	ldr	x12, [x11, #48]
	add	x11, x9, #160
	str	x12, [x9, #112]
	mov	x12, x11
	cmp	w0, w10
	csel	w13, w0, w10, lt
	add	x13, x11, w13, uxtw #3
	cmp	x11, x13
	b.ge	LBB4_20
LBB4_19:                                ; %B9
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x13, [x20], #8
	str	x13, [x12], #8
	cmp	w0, w10
	csel	w13, w0, w10, lt
	add	x13, x11, w13, uxtw #3
	cmp	x12, x13
	b.lt	LBB4_19
LBB4_20:                                ; %B13.preheader
	add	x12, x11, x10, lsl #3
	mov	w14, #18                        ; =0x12
	cmp	x13, x12
	b.ge	LBB4_22
LBB4_21:                                ; %B14
                                        ; =>This Inner Loop Header: Depth=1
	str	x14, [x13], #8
	cmp	x13, x12
	b.lt	LBB4_21
LBB4_22:                                ; %B15
	str	w10, [x9, #40]
	add	w10, w10, w8
	add	x20, x12, x8, lsl #3
	stp	x11, x12, [x9, #16]
	mov	w8, #18                         ; =0x12
	mov	x28, x11
	str	xzr, [x9, #72]
	mov	x27, x12
	str	w10, [x9, #80]
	ldr	x10, [x24, #8]
	str	x9, [x10, #256]
	cmp	x12, x20
	b.ge	LBB4_24
LBB4_23:                                ; %B21
                                        ; =>This Inner Loop Header: Depth=1
	str	x8, [x12], #8
	cmp	x12, x20
	b.lt	LBB4_23
LBB4_24:                                ; %B17
	ldr	w8, [x24, #328]
	cbz	w8, LBB4_26
; %bb.25:                               ; %B18
	add	x1, x19, #1
	mov	x0, x24
	str	x20, [x9, #48]
	bl	_DebuggerCallEachFunc
LBB4_26:                                ; %B5
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB4_14
LBB4_27:                                ; %B6
	add	x19, x19, #1
	b	l_PollInterrupts_asm_h
LBB4_28:                                ; %B43
	b	l_ThrowStackOverflow_Return_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function PollInterrupts_asm_h
l_PollInterrupts_asm_h:                 ; @PollInterrupts_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_js_poll_interrupts_slow_gc
	tbnz	w0, #31, LBB5_2
; %bb.1:                                ; %B3
	ldurb	w8, [x19, #-1]
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB5_2:                                 ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function exception_asm_h
l_exception_asm_h:                      ; @exception_asm_h
; %bb.0:                                ; %B17
	sub	sp, sp, #32
	ldr	x9, [x24, #8]
	ldr	w8, [x9, #248]
	stp	x9, x20, [sp, #8]               ; 16-byte Folded Spill
	ldr	x20, [x9, #240]
	cbz	w8, LBB6_2
; %bb.1:                                ; %B18
	mov	x0, x24
	mov	x1, x20
	mov	x2, xzr
	mov	x3, xzr
	mov	x4, x19
	mov	w5, wzr
	mov	w6, wzr
	bl	_build_backtrace
LBB6_2:                                 ; %B2
	mov	x0, x24
	mov	x1, x20
	bl	_JS_IsUncatchableError_GC
	cbz	w0, LBB6_4
LBB6_3:                                 ; %B4
	ldr	x20, [sp, #16]                  ; 8-byte Folded Reload
	mov	w0, #130                        ; =0x82
	add	sp, sp, #32
	b	l_common_return_asm_h
LBB6_4:                                 ; %B6
	ldr	x8, [x23, #8]
	str	x19, [sp, #24]                  ; 8-byte Folded Spill
	ldr	x8, [x8, #32]
	str	x8, [sp]                        ; 8-byte Folded Spill
	ldrh	w8, [x8, #42]
	add	x20, x27, x8, lsl #3
	ldr	x8, [sp, #16]                   ; 8-byte Folded Reload
LBB6_5:                                 ; %B7
                                        ; =>This Inner Loop Header: Depth=1
	cmp	x8, x20
	b.le	LBB6_3
; %bb.6:                                ; %B12
                                        ;   in Loop: Header=BB6_5 Depth=1
	ldr	x9, [x8, #-8]!
	tst	x9, #0xffff000000000000
	b.ne	LBB6_5
; %bb.7:                                ; %B12
                                        ;   in Loop: Header=BB6_5 Depth=1
	mov	w10, #247                       ; =0xf7
	and	x10, x9, x10
	cmp	x10, #66
	b.ne	LBB6_5
; %bb.8:                                ; %B9
                                        ;   in Loop: Header=BB6_5 Depth=1
	lsr	x9, x9, #16
	cbnz	w9, LBB6_10
; %bb.9:                                ; %B10
                                        ;   in Loop: Header=BB6_5 Depth=1
	ldur	x1, [x8, #-16]
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	sub	x19, x8, #8
	bl	_JS_IteratorClose
	mov	x8, x19
	ldr	x19, [sp, #24]                  ; 8-byte Folded Reload
	b	LBB6_5
LBB6_10:                                ; %B11
	ldr	x11, [sp, #8]                   ; 8-byte Folded Reload
	ldr	x10, [x11, #240]
	str	x10, [x8], #8
	mov	w10, #2                         ; =0x2
	str	x10, [x11, #240]
	ldr	x10, [sp]                       ; 8-byte Folded Reload
	mov	x20, x8
	ldr	x10, [x10, #8]
	add	x19, x10, w9, sxtw
	ldrb	w9, [x19], #1
	ldr	x1, [x25, x9, lsl #3]
	add	sp, sp, #32
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function common_call_asm_h
l_common_call_asm_h:                    ; @common_call_asm_h
; %bb.0:                                ; %B44
	mov	x9, #2                          ; =0x2
	mov	x8, x20
	movk	x9, #65535, lsl #48
	tst	x22, x9
	b.ne	LBB7_10
; %bb.1:                                ; %B41
	ldrh	w9, [x22, #6]
	cmp	w9, #13
	b.ne	LBB7_11
; %bb.2:                                ; %B1
	ldr	x12, [x22, #32]
	ldr	x10, [x24, #296]
	mov	x13, x23
	ldr	x15, [x24, #296]
	ldrh	w11, [x12, #40]
	ldrh	w9, [x12, #42]
	ldrh	w16, [x12, #46]
	ldr	x14, [x10, #8]
	ldr	x15, [x15]
	cmp	w0, w11
	add	w10, w9, w16
	b.lt	LBB7_12
; %bb.3:                                ; %B38
	lsl	w10, w10, #3
	add	w10, w10, #160
	sub	x10, x14, x10
	cmp	x10, x15
	b.ls	LBB7_23
; %bb.4:                                ; %B40
	ldr	x15, [x24, #296]
	mov	x11, x30
	mov	x23, x10
	mov	x28, x8
	str	x10, [x15, #8]
	stp	x14, x11, [x10, #136]
	stp	x13, x22, [x10]
	str	x21, [x10, #64]
	stp	x21, x27, [x10, #88]
	ldr	x13, [x22, #40]
	str	x13, [x10, #104]
	mov	x26, x13
	ldrb	w11, [x12, #5]
	str	w11, [x10, #44]
	ldr	x19, [x12, #8]
	str	w0, [x10, #120]
	ldr	x11, [x12, #48]
	add	w12, w0, w9
	str	w0, [x10, #40]
	str	xzr, [x10, #72]
	str	x11, [x10, #112]
	add	x11, x10, #160
	stp	x8, x11, [x10, #16]
	add	x20, x11, x9, lsl #3
	mov	w9, #18                         ; =0x12
	str	w12, [x10, #80]
	mov	x27, x11
	ldr	x12, [x24, #8]
	str	x10, [x12, #256]
	cmp	x11, x20
	b.ge	LBB7_6
LBB7_5:                                 ; %B32
                                        ; =>This Inner Loop Header: Depth=1
	str	x9, [x11], #8
	cmp	x11, x20
	b.lt	LBB7_5
LBB7_6:                                 ; %B33
	ldr	w8, [x24, #328]
	cbz	w8, LBB7_8
; %bb.7:                                ; %B34
	add	x1, x19, #1
	mov	x0, x24
	str	x20, [x10, #48]
	bl	_DebuggerCallEachFunc
LBB7_8:                                 ; %B28
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.mi	LBB7_22
LBB7_9:                                 ; %B30
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB7_10:                                ; %B46
	mov	x20, x8
	b	l_ThrowTypeErrorNotFunction_Return_asm_h
LBB7_11:                                ; %B42
	mov	x20, x8
	b	l_call_native_asm_h
LBB7_12:                                ; %B23
	add	w10, w10, w11
	lsl	w10, w10, #3
	add	w10, w10, #160
	sub	x10, x14, x10
	cmp	x10, x15
	b.ls	LBB7_23
; %bb.13:                               ; %B25
	ldr	x16, [x24, #296]
	mov	x15, x30
	mov	x23, x10
	str	x10, [x16, #8]
	stp	x14, x15, [x10, #136]
	stp	x13, x22, [x10]
	str	x21, [x10, #64]
	stp	x21, x27, [x10, #88]
	ldr	x14, [x22, #40]
	str	x14, [x10, #104]
	mov	x26, x14
	ldrb	w13, [x12, #5]
	str	w13, [x10, #44]
	ldr	x19, [x12, #8]
	str	w0, [x10, #120]
	ldr	x13, [x12, #48]
	add	x12, x10, #160
	str	x13, [x10, #112]
	mov	x13, x12
	cmp	w0, w11
	csel	w14, w0, w11, lt
	add	x14, x12, w14, uxtw #3
	cmp	x12, x14
	b.ge	LBB7_15
LBB7_14:                                ; %B9
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x14, [x8], #8
	str	x14, [x13], #8
	cmp	w0, w11
	csel	w14, w0, w11, lt
	add	x14, x12, w14, uxtw #3
	cmp	x13, x14
	b.lt	LBB7_14
LBB7_15:                                ; %B13.preheader
	add	x8, x12, x11, lsl #3
	mov	w13, #18                        ; =0x12
	cmp	x14, x8
	b.ge	LBB7_17
LBB7_16:                                ; %B14
                                        ; =>This Inner Loop Header: Depth=1
	str	x13, [x14], #8
	cmp	x14, x8
	b.lt	LBB7_16
LBB7_17:                                ; %B15
	str	w11, [x10, #40]
	add	w11, w11, w9
	add	x20, x8, x9, lsl #3
	stp	x12, x8, [x10, #16]
	mov	w9, #18                         ; =0x12
	mov	x28, x12
	str	xzr, [x10, #72]
	mov	x27, x8
	str	w11, [x10, #80]
	ldr	x11, [x24, #8]
	str	x10, [x11, #256]
	cmp	x8, x20
	b.ge	LBB7_19
LBB7_18:                                ; %B21
                                        ; =>This Inner Loop Header: Depth=1
	str	x9, [x8], #8
	cmp	x8, x20
	b.lt	LBB7_18
LBB7_19:                                ; %B17
	ldr	w8, [x24, #328]
	cbz	w8, LBB7_21
; %bb.20:                               ; %B18
	add	x1, x19, #1
	mov	x0, x24
	str	x20, [x10, #48]
	bl	_DebuggerCallEachFunc
LBB7_21:                                ; %B5
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB7_9
LBB7_22:                                ; %B6
	add	x19, x19, #1
	b	l_PollInterrupts_asm_h
LBB7_23:                                ; %B39
	mov	x20, x8
	b	l_ThrowStackOverflow_Return_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function common_return_direct_asm_h
l_common_return_direct_asm_h:           ; @common_return_direct_asm_h
; %bb.0:                                ; %B0
	ldp	x8, x10, [x23, #136]
	ldr	x9, [x24, #296]
	ldr	x11, [x23]
	str	x8, [x9, #8]
	mov	x30, x10
	mov	x23, x11
	ldr	x8, [x24, #8]
	str	x11, [x8, #256]
	ret
                                        ; -- End function
	.private_extern	_common_call_debugger0_asm_h ; -- Begin function common_call_debugger0_asm_h
	.globl	_common_call_debugger0_asm_h
	.p2align	2
_common_call_debugger0_asm_h:           ; @common_call_debugger0_asm_h
; %bb.0:                                ; %B3
	ldr	w8, [x24, #328]
	cbz	w8, LBB9_2
; %bb.1:                                ; %B4
	ldr	x8, [x23, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #32]
	str	x20, [x23, #48]
	bl	_DebuggerCallEachOp
LBB9_2:                                 ; %B1
	ldurb	w8, [x19, #-1]
	sub	w8, w8, #729
	ldr	x1, [x25, w8, sxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_common_call_debugger1_asm_h ; -- Begin function common_call_debugger1_asm_h
	.globl	_common_call_debugger1_asm_h
	.p2align	2
_common_call_debugger1_asm_h:           ; @common_call_debugger1_asm_h
; %bb.0:                                ; %B3
	ldr	w8, [x24, #328]
	cbz	w8, LBB10_2
; %bb.1:                                ; %B4
	ldr	x8, [x23, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #32]
	str	x20, [x23, #48]
	bl	_DebuggerCallEachOp
LBB10_2:                                ; %B1
	ldurb	w8, [x19, #-1]
	sub	w8, w8, #486
	ldr	x1, [x25, w8, sxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_common_call_debugger2_asm_h ; -- Begin function common_call_debugger2_asm_h
	.globl	_common_call_debugger2_asm_h
	.p2align	2
_common_call_debugger2_asm_h:           ; @common_call_debugger2_asm_h
; %bb.0:                                ; %B3
	ldr	w8, [x24, #328]
	cbz	w8, LBB11_2
; %bb.1:                                ; %B4
	ldr	x8, [x23, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #32]
	str	x20, [x23, #48]
	bl	_DebuggerCallEachOp
LBB11_2:                                ; %B1
	ldurb	w8, [x19, #-1]
	sub	w8, w8, #243
	ldr	x1, [x25, w8, sxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function SlowCloseVarRefs_asm_h
l_SlowCloseVarRefs_asm_h:               ; @SlowCloseVarRefs_asm_h
; %bb.0:                                ; %B0
	mov	x22, x0
	mov	x0, x24
	mov	x1, x23
	bl	_prim_close_var_refs_gc
	mov	x0, x22
	b	l_common_return_direct_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function common_return_asm_h
l_common_return_asm_h:                  ; @common_return_asm_h
; %bb.0:                                ; %B6
	ldr	x8, [x23, #72]
	cbnz	x8, LBB13_3
; %bb.1:                                ; %B1
	ldrb	w8, [x24, #384]
	cbz	w8, LBB13_4
; %bb.2:                                ; %B1
	cbz	x26, LBB13_4
LBB13_3:                                ; %B3
	b	l_SlowCloseVarRefs_asm_h
LBB13_4:                                ; %B5
	b	l_common_return_direct_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function exception_spill_top0_asm_h
l_exception_spill_top0_asm_h:           ; @exception_spill_top0_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function exception_spill_top1_asm_h
l_exception_spill_top1_asm_h:           ; @exception_spill_top1_asm_h
; %bb.0:                                ; %B0
	str	x21, [x20], #8
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function exception_spill_top0_top1_asm_h
l_exception_spill_top0_top1_asm_h:      ; @exception_spill_top0_top1_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function spill_table1_to_table0_asm_h
l_spill_table1_to_table0_asm_h:         ; @spill_table1_to_table0_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	ldurb	w8, [x19, #-1]
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function spill_table2_to_table0_asm_h
l_spill_table2_to_table0_asm_h:         ; @spill_table2_to_table0_asm_h
; %bb.0:                                ; %B0
	stp	x22, x21, [x20], #16
	ldurb	w8, [x19, #-1]
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function SlowToBoolean_asm_h
l_SlowToBoolean_asm_h:                  ; @SlowToBoolean_asm_h
; %bb.0:                                ; %B1
	mov	x1, x0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ToBoolFree_GC
	tbnz	w0, #31, LBB19_2
; %bb.1:                                ; %B3
	cmp	w0, #0
	mov	w8, #6                          ; =0x6
	cinc	x8, x8, ne
	stur	x8, [x20, #-8]
	ldurb	w8, [x19, #-1]
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB19_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function SlowJSPostInc_asm_h
l_SlowJSPostInc_asm_h:                  ; @SlowJSPostInc_asm_h
; %bb.0:                                ; %B1
	mov	w2, w0
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_js_post_inc_slow_gc
	tbnz	w0, #31, LBB20_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB20_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function SlowJSNot_asm_h
l_SlowJSNot_asm_h:                      ; @SlowJSNot_asm_h
; %bb.0:                                ; %B1
	mov	x1, x0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_prim_js_not_slow_gc
	cmp	x0, #130
	b.eq	LBB21_2
; %bb.1:                                ; %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB21_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function FastJSConcatString_asm_h
l_FastJSConcatString_asm_h:             ; @FastJSConcatString_asm_h
; %bb.0:                                ; %B37
	sub	sp, sp, #48
	mov	x22, x0
	str	x19, [sp, #40]                  ; 8-byte Folded Spill
	cbnz	x22, LBB22_13
; %bb.1:                                ; %B40
	ldur	x1, [x20, #-16]
LBB22_2:                                ; %B14
	ldur	x2, [x20, #-8]
	and	x9, x1, #0xfffffffffffc
	str	x20, [sp, #32]                  ; 8-byte Folded Spill
	ldr	w12, [x9, #4]
	and	x8, x2, #0xfffffffffffc
	ldr	w13, [x8, #4]
	and	w10, w12, #0x3fffffff
	and	w11, w13, #0x3fffffff
	add	w11, w10, w11
	lsr	w10, w11, #30
	cbnz	w10, LBB22_10
; %bb.3:                                ; %B18
	mov	x10, #-281474976710653          ; =0xffff000000000003
	bics	xzr, x10, x1
	b.eq	LBB22_14
; %bb.4:
	mov	w14, #1                         ; =0x1
	bics	xzr, x10, x2
	stp	x1, x2, [sp, #16]               ; 16-byte Folded Spill
	stp	w12, w11, [sp, #8]              ; 8-byte Folded Spill
	str	w13, [sp, #4]                   ; 4-byte Folded Spill
	b.eq	LBB22_15
LBB22_5:                                ; %B28
	mov	x0, x24
	mov	w1, #32                         ; =0x20
	mov	w2, #20                         ; =0x14
	str	w14, [sp]                       ; 4-byte Folded Spill
	str	x20, [x23, #48]
	bl	_prim_try_malloc_gc
	ldp	x2, x20, [sp, #24]              ; 16-byte Folded Reload
	mov	x19, x0
	ldp	w8, w10, [sp, #8]               ; 8-byte Folded Reload
	ldr	x1, [sp, #16]                   ; 8-byte Folded Reload
	ldr	w9, [sp, #4]                    ; 4-byte Folded Reload
	cbz	x19, LBB22_10
; %bb.6:                                ; %B20
	and	w8, w8, #0xbfffffff
	and	w9, w9, #0xbfffffff
	ldr	w11, [sp]                       ; 4-byte Folded Reload
	orr	w8, w8, w9
	mov	w9, #1                          ; =0x1
	str	x1, [x19, #16]
	and	w8, w8, #0x80000000
	str	w9, [x19]
	orr	w8, w10, w8
	stp	w8, w11, [x19, #4]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB22_16
; %bb.7:                                ; %B24
	str	x2, [x19, #24]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB22_17
LBB22_8:                                ; %B1
	orr	x8, x19, #0xffff000000000003
	cbz	x22, LBB22_18
LBB22_9:                                ; %B2
	ldr	x10, [sp, #40]                  ; 8-byte Folded Reload
	sub	x20, x20, #8
	ldrb	w9, [x10]
	add	x19, x10, #2
	str	x8, [x27, x9, lsl #3]
	ldrb	w8, [x10, #1]
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
LBB22_10:                               ; %B5
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ConcatString_GC
	cmp	x0, #130
	cbnz	x22, LBB22_19
; %bb.11:                               ; %B11
	b.eq	LBB22_21
; %bb.12:                               ; %B13
	ldp	x9, x19, [sp, #32]              ; 16-byte Folded Reload
	stur	x0, [x9, #-16]
	sub	x20, x9, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
LBB22_13:                               ; %B38
	ldrb	w8, [x19]
	ldr	x1, [x27, x8, lsl #3]
	b	LBB22_2
LBB22_14:                               ; %B19
	ldr	w9, [x9, #8]
	add	w14, w9, #1
	bics	xzr, x10, x2
	stp	x1, x2, [sp, #16]               ; 16-byte Folded Spill
	stp	w12, w11, [sp, #8]              ; 8-byte Folded Spill
	str	w13, [sp, #4]                   ; 4-byte Folded Spill
	b.ne	LBB22_5
LBB22_15:                               ; %B33
	ldr	w8, [x8, #8]
	add	w9, w8, #1
	cmp	w14, w9
	csinc	w14, w14, w8, gt
	b	LBB22_5
LBB22_16:                               ; %B27
	mov	x0, x1
	mov	x1, x24
	mov	x20, x2
	bl	_prim_WriteBarrierNoStore
	mov	x2, x20
	ldr	x20, [sp, #32]                  ; 8-byte Folded Reload
	str	x2, [x19, #24]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB22_8
LBB22_17:                               ; %B26
	mov	x0, x2
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldr	x20, [sp, #32]                  ; 8-byte Folded Reload
	orr	x8, x19, #0xffff000000000003
	cbnz	x22, LBB22_9
LBB22_18:                               ; %B4
	ldr	x19, [sp, #40]                  ; 8-byte Folded Reload
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
LBB22_19:                               ; %B7
	b.eq	LBB22_21
; %bb.20:                               ; %B9
	ldr	x9, [sp, #40]                   ; 8-byte Folded Reload
	ldrb	w8, [x9]
	add	x19, x9, #2
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x9, #1]
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #48
	br	x1
LBB22_21:                               ; %B12
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function FastStringEqual_asm_h
l_FastStringEqual_asm_h:                ; @FastStringEqual_asm_h
; %bb.0:                                ; %B74
	ldp	x1, x2, [x20, #-16]
	and	x8, x1, #0xfffffffffffc
	and	x9, x2, #0xfffffffffffc
	ldr	w8, [x8, #4]
	ldr	w9, [x9, #4]
	and	w8, w8, #0x3fffffff
	and	w9, w9, #0x3fffffff
	cmp	w8, w9
	b.eq	LBB23_3
LBB23_1:                                ; %B15
	mov	w8, #6                          ; =0x6
	bfxil	x8, x0, #0, #1
LBB23_2:                                ; %B16
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB23_3:                                ; %B1
	mov	x8, #-281474976710653           ; =0xffff000000000003
	bics	xzr, x8, x1
	b.eq	LBB23_15
; %bb.4:                                ; %B69
	bics	xzr, x8, x2
	b.eq	LBB23_17
LBB23_5:                                ; %B54
	and	x8, x1, #0xfffffffffffc
	and	x9, x2, #0xfffffffffffc
	cmp	x8, x9
	b.eq	LBB23_19
LBB23_6:                                ; %B57
	ldrb	w10, [x8, #7]
	tbnz	w10, #6, LBB23_20
; %bb.7:                                ; %B60
	ldr	w10, [x8, #8]
	ldrb	w11, [x9, #7]
	tbnz	w11, #6, LBB23_21
LBB23_8:                                ; %B53
	ldr	w11, [x9, #8]
	asr	w10, w10, #30
	cmp	w10, #1
	b.ne	LBB23_10
LBB23_9:                                ; %B49
	asr	w10, w11, #30
	cmp	w10, #1
	b.eq	LBB23_1
LBB23_10:                               ; %B8
	ldr	w10, [x8, #4]
	ldr	w11, [x9, #4]
	add	x8, x8, #16
	add	x9, x9, #16
	tst	w10, #0xbfffffff
	and	w10, w10, #0x3fffffff
	and	w11, w11, #0xbfffffff
	b.lt	LBB23_22
; %bb.11:                               ; %B32
	tbnz	w11, #31, LBB23_26
; %bb.12:                               ; %B46.preheader
	mov	w11, wzr
	cmp	w10, wzr
	b.eq	LBB23_19
LBB23_13:                               ; %B43
                                        ; =>This Inner Loop Header: Depth=1
	ldrb	w12, [x8, w11, sxtw]
	ldrb	w13, [x9, w11, sxtw]
	cmp	w12, w13
	b.ne	LBB23_1
; %bb.14:                               ; %B45
                                        ;   in Loop: Header=BB23_13 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	LBB23_13
	b	LBB23_19
LBB23_15:                               ; %B66
	and	x9, x1, #0xfffffffffffc
	ldr	x10, [x9, #24]
	cmp	x10, #2
	b.ne	LBB23_29
; %bb.16:                               ; %B67
	ldr	x1, [x9, #16]
	bics	xzr, x8, x2
	b.ne	LBB23_5
LBB23_17:                               ; %B3
	and	x8, x2, #0xfffffffffffc
	ldr	x9, [x8, #24]
	cmp	x9, #2
	b.ne	LBB23_29
; %bb.18:                               ; %B4
	ldr	x2, [x8, #16]
	and	x8, x1, #0xfffffffffffc
	and	x9, x2, #0xfffffffffffc
	cmp	x8, x9
	b.ne	LBB23_6
LBB23_19:                               ; %B21
	mvn	w9, w0
	mov	w8, #6                          ; =0x6
	bfxil	x8, x9, #0, #1
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB23_20:                               ; %B58
	ldr	x10, [x8, #8]
	ldr	w10, [x10]
	ldrb	w11, [x9, #7]
	tbz	w11, #6, LBB23_8
LBB23_21:                               ; %B7
	ldr	x11, [x9, #8]
	ldr	w11, [x11]
	asr	w10, w10, #30
	cmp	w10, #1
	b.eq	LBB23_9
	b	LBB23_10
LBB23_22:                               ; %B10
	tbnz	w11, #31, LBB23_31
; %bb.23:                               ; %B28.preheader
	mov	w11, wzr
	cmp	w10, wzr
	b.eq	LBB23_19
LBB23_24:                               ; %B25
                                        ; =>This Inner Loop Header: Depth=1
	ldrh	w12, [x8, w11, sxtw #1]
	ldrb	w13, [x9, w11, sxtw]
	cmp	w12, w13
	b.ne	LBB23_1
; %bb.25:                               ; %B27
                                        ;   in Loop: Header=BB23_24 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	LBB23_24
	b	LBB23_19
LBB23_26:                               ; %B38.preheader
	mov	w11, wzr
	cmp	w10, wzr
	b.eq	LBB23_19
LBB23_27:                               ; %B35
                                        ; =>This Inner Loop Header: Depth=1
	ldrb	w12, [x8, w11, sxtw]
	ldrh	w13, [x9, w11, sxtw #1]
	cmp	w12, w13
	b.ne	LBB23_1
; %bb.28:                               ; %B37
                                        ;   in Loop: Header=BB23_27 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	LBB23_27
	b	LBB23_19
LBB23_29:                               ; %B63
	mov	w3, w0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	mov	x8, x0
	b.ne	LBB23_2
; %bb.30:                               ; %B64
	b	l_exception_asm_h
LBB23_31:                               ; %B19.preheader
	mov	w11, wzr
	cmp	w10, wzr
	b.eq	LBB23_19
LBB23_32:                               ; %B13
                                        ; =>This Inner Loop Header: Depth=1
	ldrh	w12, [x8, w11, sxtw #1]
	ldrh	w13, [x9, w11, sxtw #1]
	cmp	w12, w13
	b.ne	LBB23_1
; %bb.33:                               ; %B18
                                        ;   in Loop: Header=BB23_32 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	LBB23_32
	b	LBB23_19
                                        ; -- End function
	.p2align	2                               ; -- Begin function ThrowReferenceErrorUninitialized_asm_h
l_ThrowReferenceErrorUninitialized_asm_h: ; @ThrowReferenceErrorUninitialized_asm_h
; %bb.0:                                ; %B0
	mov	x0, x24
	mov	w1, wzr
	str	x20, [x23, #48]
	bl	_JS_ThrowReferenceErrorUninitialized_GC
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function ThrowThisReferenceError_asm_h
l_ThrowThisReferenceError_asm_h:        ; @ThrowThisReferenceError_asm_h
; %bb.0:                                ; %B0
Lloh0:
	adrp	x1, l___unnamed_1@PAGE
Lloh1:
	add	x1, x1, l___unnamed_1@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_ThrowReferenceError
	b	l_exception_asm_h
	.loh AdrpAdd	Lloh0, Lloh1
                                        ; -- End function
	.p2align	2                               ; -- Begin function PollInterrupts_spill_top0_asm_h
l_PollInterrupts_spill_top0_asm_h:      ; @PollInterrupts_spill_top0_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_PollInterrupts_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function PollInterrupts_spill_top0_top1_asm_h
l_PollInterrupts_spill_top0_top1_asm_h: ; @PollInterrupts_spill_top0_top1_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_PollInterrupts_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function FastBuildArguments_asm_h
l_FastBuildArguments_asm_h:             ; @FastBuildArguments_asm_h
; %bb.0:                                ; %B51
	sub	sp, sp, #48
	str	x20, [sp, #40]                  ; 8-byte Folded Spill
	ldrb	w8, [x24, #363]
	ldr	w20, [x23, #120]
	str	x19, [sp, #24]                  ; 8-byte Folded Spill
	cbnz	w8, LBB28_19
; %bb.1:                                ; %B48
	ldr	x8, [x24, #408]
	cbz	x8, LBB28_19
; %bb.2:                                ; %B45
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	str	x20, [sp, #32]                  ; 8-byte Folded Spill
	cbz	w20, LBB28_8
; %bb.3:                                ; %B6
	lsl	x1, x20, #3
	ldr	x8, [sp, #40]                   ; 8-byte Folded Reload
	mov	x0, x24
	mov	w2, #42                         ; =0x2a
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	cbz	x0, LBB28_19
; %bb.4:                                ; %B9.preheader
	mov	x8, x0
	add	x10, x0, x20, lsl #3
	mov	x19, x28
	mov	x20, x8
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	cmp	x8, x10
	b.ge	LBB28_9
LBB28_5:                                ; %B12
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x19]
	str	x8, [x20]
	ldrb	w9, [x24, #384]
	cbnz	w9, LBB28_7
LBB28_6:                                ; %B11
                                        ;   in Loop: Header=BB28_5 Depth=1
	add	x20, x20, #8
	add	x19, x19, #8
	cmp	x20, x10
	b.lt	LBB28_5
	b	LBB28_9
LBB28_7:                                ; %B14
                                        ;   in Loop: Header=BB28_5 Depth=1
	mov	x0, x8
	mov	x1, x24
	str	x10, [sp]                       ; 8-byte Folded Spill
	bl	_prim_WriteBarrierNoStore
	ldr	x10, [sp]                       ; 8-byte Folded Reload
	b	LBB28_6
LBB28_8:
	str	xzr, [sp, #8]                   ; 8-byte Folded Spill
LBB28_9:                                ; %B17
	ldr	x8, [sp, #40]                   ; 8-byte Folded Reload
	mov	x0, x24
	mov	w1, #16                         ; =0x10
	mov	w2, #42                         ; =0x2a
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x20, [sp, #32]                  ; 8-byte Folded Reload
	mov	x9, x0
	cbz	x9, LBB28_19
; %bb.10:                               ; %B40
	ldr	x20, [x24, #192]
	str	x20, [x9]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB28_17
; %bb.11:                               ; %B37
	str	x20, [x9, #8]
	ldrb	w8, [x24, #384]
	str	x9, [sp]                        ; 8-byte Folded Spill
	cbnz	w8, LBB28_18
LBB28_12:                               ; %B21
	ldr	x8, [sp, #40]                   ; 8-byte Folded Reload
	mov	x0, x24
	mov	w1, #88                         ; =0x58
	mov	w2, #2                          ; =0x2
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x20, [sp, #32]                  ; 8-byte Folded Reload
	ldr	x9, [sp, #16]                   ; 8-byte Folded Reload
	mov	x19, x0
	ldr	x10, [sp]                       ; 8-byte Folded Reload
	cbz	x19, LBB28_19
; %bb.13:                               ; %B32
	ldr	w8, [x9]
	add	w8, w8, #1
	str	w8, [x9]
	mov	w8, #1                          ; =0x1
	str	w8, [x19]
	mov	w8, #13                         ; =0xd
	strb	w8, [x19, #5]
	mov	w8, #8                          ; =0x8
	strh	w8, [x19, #6]
	add	x8, x19, #8
	stlr	x9, [x8]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB28_21
LBB28_14:                               ; %B29
	orr	x8, x20, #0xfffe000000000000
	mov	x9, x19
	str	x8, [x9, #56]!
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	stur	x9, [x9, #-40]
	stur	x8, [x9, #-16]
	stur	w20, [x9, #-8]
	ldr	x8, [x24, #184]
	str	x8, [x9, #8]
	ldrb	w9, [x24, #384]
	cbnz	w9, LBB28_22
; %bb.15:                               ; %B26
	str	x10, [x19, #72]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB28_23
LBB28_16:                               ; %B4
	ldr	x20, [sp, #40]                  ; 8-byte Folded Reload
	ldr	x9, [sp, #24]                   ; 8-byte Folded Reload
	str	x19, [x20], #8
	add	x19, x9, #2
	ldrb	w8, [x9, #1]
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
LBB28_17:                               ; %B42
	mov	x0, x20
	mov	x1, x24
	mov	x19, x9
	bl	_prim_WriteBarrierNoStore
	str	x20, [x19, #8]
	ldrb	w8, [x24, #384]
	str	x19, [sp]                       ; 8-byte Folded Spill
	cbz	w8, LBB28_12
LBB28_18:                               ; %B39
	mov	x0, x20
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB28_12
LBB28_19:                               ; %B1
	ldr	x8, [sp, #40]                   ; 8-byte Folded Reload
	mov	x0, x24
	mov	w1, w20
	mov	x2, x28
	str	x8, [x23, #48]
	bl	_js_build_arguments_gc
	cmp	x0, #130
	mov	x19, x0
	b.ne	LBB28_16
; %bb.20:                               ; %B2
	ldr	x19, [sp, #24]                  ; 8-byte Folded Reload
	ldr	x20, [sp, #40]                  ; 8-byte Folded Reload
	add	sp, sp, #48
	b	l_exception_asm_h
LBB28_21:                               ; %B34
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	_prim_WriteBarrierNoStore
	ldr	x10, [sp]                       ; 8-byte Folded Reload
	b	LBB28_14
LBB28_22:                               ; %B31
	mov	x0, x8
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldr	x10, [sp]                       ; 8-byte Folded Reload
	str	x10, [x19, #72]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB28_16
LBB28_23:                               ; %B28
	mov	x0, x10
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB28_16
                                        ; -- End function
	.p2align	2                               ; -- Begin function FastFclosure_asm_h
l_FastFclosure_asm_h:                   ; @FastFclosure_asm_h
; %bb.0:                                ; %B104
	sub	sp, sp, #128
	and	x8, x0, #0xfffffffffffc
	mov	x14, x20
	str	x19, [sp, #32]                  ; 8-byte Folded Spill
	str	x8, [sp, #80]                   ; 8-byte Folded Spill
	ldrb	w8, [x8, #6]
	str	x20, [sp, #120]                 ; 8-byte Folded Spill
	tst	w8, #0x30
	str	w8, [sp, #76]                   ; 4-byte Folded Spill
	b.ne	LBB29_38
; %bb.1:                                ; %B91
	ldrb	w8, [x24, #363]
	cbnz	w8, LBB29_38
; %bb.2:                                ; %B94
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB29_38
; %bb.3:                                ; %B97
	ldr	w8, [sp, #76]                   ; 4-byte Folded Reload
	tst	w8, #0x1
	mov	w8, #6                          ; =0x6
	cinc	w8, w8, eq
	ldr	x10, [x24, w8, uxtw #3]
	cbz	x10, LBB29_38
; %bb.4:                                ; %B9
	ldr	x8, [sp, #80]                   ; 8-byte Folded Reload
	mov	w9, #47                         ; =0x2f
	ldr	w8, [x8, #20]
	cmp	w8, #0
	csel	w8, w9, w8, eq
	tbnz	w8, #31, LBB29_38
; %bb.5:                                ; %B86
	ldr	x9, [x24, #8]
	ldr	x9, [x9, #64]
	ldr	x9, [x9, w8, sxtw #3]
	ldrb	w8, [x9, #7]
	tbnz	w8, #6, LBB29_23
; %bb.6:                                ; %B89
	ldr	w8, [x9, #8]
	asr	w8, w8, #30
	str	x9, [sp, #24]                   ; 8-byte Folded Spill
	cmp	w8, #1
	b.ne	LBB29_38
LBB29_7:                                ; %B19
	ldr	x8, [sp, #80]                   ; 8-byte Folded Reload
	str	x10, [sp, #16]                  ; 8-byte Folded Spill
	ldr	w9, [x8, #60]
	cbz	w9, LBB29_24
; %bb.8:                                ; %B82
	ldr	x8, [x8, #32]
	lsl	x1, x9, #3
	ldr	w19, [x23, #40]
	ldr	x20, [x23, #72]
	mov	x0, x24
	mov	w2, #48                         ; =0x30
	stp	x8, x9, [sp, #56]               ; 16-byte Folded Spill
	str	x14, [x23, #48]
	bl	_prim_try_malloc_gc
	ldp	x11, x10, [sp, #56]             ; 16-byte Folded Reload
	ldr	x14, [sp, #120]                 ; 8-byte Folded Reload
	cbz	x0, LBB29_38
; %bb.9:                                ; %B83
	mov	w12, w19
	mov	w13, wzr
	mov	x15, x0
	mov	w19, wzr
	str	x0, [sp, #8]                    ; 8-byte Folded Spill
	str	w12, [sp, #44]                  ; 4-byte Folded Spill
	b	LBB29_11
LBB29_10:                               ; %B74
                                        ;   in Loop: Header=BB29_11 Depth=1
	add	w19, w19, #1
	add	w13, w13, #8
	cmp	w19, w10
	str	x8, [x15], #8
	b.hs	LBB29_25
LBB29_11:                               ; %B25
                                        ; =>This Inner Loop Header: Depth=1
	add	x8, x11, w13, uxtw
	ldrb	w9, [x8]
	tbz	w9, #0, LBB29_14
; %bb.12:                               ; %B27
                                        ;   in Loop: Header=BB29_11 Depth=1
	ldrh	w16, [x8, #2]
	tst	w9, #0x2
	csel	x17, x27, x28, eq
	add	w8, w12, w16
	csel	w9, w8, w16, eq
	cbz	x20, LBB29_16
; %bb.13:                               ; %B43
                                        ;   in Loop: Header=BB29_11 Depth=1
	ldr	x8, [x20, w9, uxtw #3]
	cbnz	x8, LBB29_10
	b	LBB29_18
LBB29_14:                               ; %B21
                                        ;   in Loop: Header=BB29_11 Depth=1
	cbz	x26, LBB29_38
; %bb.15:                               ; %B23
                                        ;   in Loop: Header=BB29_11 Depth=1
	ldrh	w8, [x8, #2]
	ldr	x8, [x26, x8, lsl #3]
	b	LBB29_10
LBB29_16:                               ; %B29
                                        ;   in Loop: Header=BB29_11 Depth=1
	ldr	w8, [x23, #80]
	mov	x0, x24
	mov	w2, #48                         ; =0x30
	str	x17, [sp, #88]                  ; 8-byte Folded Spill
	mov	w20, w13
	lsl	x1, x8, #3
	str	w9, [sp, #100]                  ; 4-byte Folded Spill
	stp	x16, x15, [sp, #104]            ; 16-byte Folded Spill
	str	x14, [x23, #48]
	bl	_prim_try_malloc_gc
	ldp	x15, x14, [sp, #112]            ; 16-byte Folded Reload
	cbz	x0, LBB29_38
; %bb.17:                               ; %B30
                                        ;   in Loop: Header=BB29_11 Depth=1
	ldr	x16, [sp, #104]                 ; 8-byte Folded Reload
	ldr	w9, [sp, #100]                  ; 4-byte Folded Reload
	mov	w13, w20
	ldr	x17, [sp, #88]                  ; 8-byte Folded Reload
	mov	x20, x0
	str	x0, [x23, #72]
LBB29_18:                               ; %B39
                                        ;   in Loop: Header=BB29_11 Depth=1
	ldr	w8, [x23, #44]
	str	x20, [sp, #48]                  ; 8-byte Folded Spill
	mov	w20, w13
	mov	w1, #16                         ; =0x10
	str	x17, [sp, #88]                  ; 8-byte Folded Spill
	mov	x0, x24
	str	w9, [sp, #100]                  ; 4-byte Folded Spill
	stp	x16, x15, [sp, #104]            ; 16-byte Folded Spill
	str	x14, [x23, #48]
	tbnz	w8, #4, LBB29_22
; %bb.19:                               ; %B32
                                        ;   in Loop: Header=BB29_11 Depth=1
	mov	w2, #16                         ; =0x10
LBB29_20:                               ; %B32
                                        ;   in Loop: Header=BB29_11 Depth=1
	bl	_prim_try_malloc_gc
	ldp	x15, x14, [sp, #112]            ; 16-byte Folded Reload
	mov	w13, w20
	ldp	x11, x10, [sp, #56]             ; 16-byte Folded Reload
	ldr	w12, [sp, #44]                  ; 4-byte Folded Reload
	ldr	x20, [sp, #48]                  ; 8-byte Folded Reload
	cbz	x0, LBB29_38
; %bb.21:                               ;   in Loop: Header=BB29_11 Depth=1
	ldr	x9, [sp, #104]                  ; 8-byte Folded Reload
	ldr	x16, [sp, #88]                  ; 8-byte Folded Reload
	mov	x8, x0
	add	x9, x16, x9, lsl #3
	str	x9, [x8]
	mov	w9, #18                         ; =0x12
	str	x9, [x8, #8]
	ldr	w9, [sp, #100]                  ; 4-byte Folded Reload
	str	x8, [x20, w9, uxtw #3]
	b	LBB29_10
LBB29_22:                               ; %B36
                                        ;   in Loop: Header=BB29_11 Depth=1
	mov	w2, #57                         ; =0x39
	b	LBB29_20
LBB29_23:                               ; %B87
	ldr	x8, [x9, #8]
	ldr	w8, [x8]
	asr	w8, w8, #30
	str	x9, [sp, #24]                   ; 8-byte Folded Spill
	cmp	w8, #1
	b.eq	LBB29_7
	b	LBB29_38
LBB29_24:
	str	xzr, [sp, #8]                   ; 8-byte Folded Spill
LBB29_25:                               ; %B79
	ldr	w8, [sp, #76]                   ; 4-byte Folded Reload
	tbnz	w8, #0, LBB29_32
; %bb.26:                               ; %B67
	mov	x0, x24
	mov	w1, #88                         ; =0x58
	mov	w2, #2                          ; =0x2
	str	x14, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x14, [sp, #120]                 ; 8-byte Folded Reload
	ldr	x11, [sp, #16]                  ; 8-byte Folded Reload
	cbz	x0, LBB29_38
; %bb.27:                               ; %B70
	ldr	w9, [x11]
	mov	w10, #1                         ; =0x1
	mov	x19, x0
	mov	x20, xzr
	mov	x8, x0
	add	w9, w9, #1
	str	w9, [x11]
	mov	w9, #13                         ; =0xd
	str	w10, [x0]
	strb	w10, [x0, #5]
	add	x10, x0, #8
	strh	w9, [x0, #6]
	mov	x9, xzr
	stlr	x11, [x10]
	ldrb	w10, [x24, #384]
	cbnz	w10, LBB29_35
LBB29_28:                               ; %B58
	ldr	x11, [sp, #80]                  ; 8-byte Folded Reload
	ldr	x12, [sp, #8]                   ; 8-byte Folded Reload
	add	x10, x8, #56
	str	x10, [x8, #16]
	ldr	x13, [sp, #24]                  ; 8-byte Folded Reload
	stp	x11, x12, [x8, #32]
	mov	x12, #2                         ; =0x2
	ldrh	w11, [x11, #44]
	movk	x12, #1, lsl #48
	orr	x12, x13, x12
	orr	x11, x11, #0xfffe000000000000
	stp	x11, x12, [x8, #56]
	ldr	w11, [sp, #76]                  ; 4-byte Folded Reload
	tbnz	w11, #0, LBB29_36
LBB29_29:                               ; %B61
	ldr	x19, [sp, #32]                  ; 8-byte Folded Reload
LBB29_30:                               ; %B6
	str	x8, [x14], #8
	ldurb	w8, [x19, #-1]
	cmp	w8, #189
	b.ne	LBB29_37
; %bb.31:                               ; %B7
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	mov	x20, x14
	add	sp, sp, #128
	br	x1
LBB29_32:                               ; %B52
	ldr	x20, [x24, #424]
	cbz	x20, LBB29_38
; %bb.33:                               ; %B55
	mov	x0, x24
	mov	w1, #88                         ; =0x58
	mov	w2, #2                          ; =0x2
	str	x14, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x11, [sp, #16]                  ; 8-byte Folded Reload
	ldr	x14, [sp, #120]                 ; 8-byte Folded Reload
	cbz	x0, LBB29_38
; %bb.34:                               ; %B63
	ldr	w9, [x11]
	mov	w10, #1                         ; =0x1
	mov	x19, x0
	mov	x8, x0
	add	w9, w9, #1
	str	w9, [x11]
	mov	w9, #17                         ; =0x11
	str	w10, [x0]
	mov	w10, #13                        ; =0xd
	strb	w9, [x0, #5]
	add	x9, x0, #8
	strh	w10, [x0, #6]
	stlr	x11, [x9]
	mov	x9, x20
	ldrb	w10, [x24, #384]
	cbz	w10, LBB29_28
LBB29_35:                               ; %B58.sink.split
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x11, x8
	bl	_prim_WriteBarrierNoStore
	ldr	x14, [sp, #120]                 ; 8-byte Folded Reload
	mov	x8, x19
	mov	x9, x20
	b	LBB29_28
LBB29_36:                               ; %B60
	str	x9, [x10, #16]
	b	LBB29_29
LBB29_37:                               ; %B8
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	mov	x20, x14
	add	sp, sp, #128
	br	x1
LBB29_38:                               ; %B1
	ldr	x1, [sp, #80]                   ; 8-byte Folded Reload
	mov	x0, x24
	mov	x2, x26
	mov	x3, x23
	str	x14, [x23, #48]
	bl	_js_closure_gc_slowpath
	ldr	x14, [sp, #120]                 ; 8-byte Folded Reload
	ldr	x19, [sp, #32]                  ; 8-byte Folded Reload
	cmp	x0, #130
	mov	x8, x0
	b.ne	LBB29_30
; %bb.39:                               ; %B2
	mov	x20, x14
	add	sp, sp, #128
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function FastCallConstructor_asm_h
l_FastCallConstructor_asm_h:            ; @FastCallConstructor_asm_h
; %bb.0:                                ; %B9
	sub	sp, sp, #16
	mov	w8, w0
	mov	x0, x24
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	str	w8, [sp, #4]                    ; 4-byte Folded Spill
	sub	x8, x20, w8, uxtw #3
	str	x20, [x23, #48]
	mov	x1, x8
	mov	x20, x8
	bl	_js_create_ordinary_constructor_this_GC
	cmp	x0, #130
	b.eq	LBB30_5
; %bb.1:                                ; %B6
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	stur	x0, [x20, #-8]
	add	x19, x19, #2
	ldur	x8, [x20, #-16]
	mov	x21, x0
	str	x19, [x23, #32]
	str	x9, [x23, #48]
	ldr	w9, [sp, #4]                    ; 4-byte Folded Reload
	mov	x22, x8
	mov	x27, x8
	mov	w0, w9
	bl	l_common_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #104]
	b.eq	LBB30_6
; %bb.2:                                ; %B1
	mov	x9, #2                          ; =0x2
	ldurh	w8, [x19, #-2]
	movk	x9, #65535, lsl #48
	tst	x0, x9
	b.eq	LBB30_7
; %bb.3:                                ; %B5
	sub	x9, x20, x8, lsl #3
	ldur	x9, [x9, #-8]
LBB30_4:                                ; %B3
	sub	x8, x20, x8, lsl #3
	stur	x9, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19], #1
	ldr	x1, [x25, x9, lsl #3]
	add	sp, sp, #16
	br	x1
LBB30_5:                                ; %B10
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
LBB30_6:                                ; %B7
	add	sp, sp, #16
	b	l_exception_asm_h
LBB30_7:
	mov	x9, x0
	b	LBB30_4
                                        ; -- End function
	.p2align	2                               ; -- Begin function FastCallDerivedConstructor_asm_h
l_FastCallDerivedConstructor_asm_h:     ; @FastCallDerivedConstructor_asm_h
; %bb.0:                                ; %B2
	mov	w9, w0
	add	x19, x19, #2
	mov	w21, #18                        ; =0x12
	sub	x8, x20, w9, uxtw #3
	mov	w0, w9
	ldur	x10, [x8, #-16]
	str	x20, [x23, #48]
	mov	x20, x8
	str	x19, [x23, #32]
	mov	x22, x10
	mov	x27, x10
	bl	l_common_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #104]
	b.eq	LBB31_2
; %bb.1:                                ; %B4
	ldurh	w8, [x19, #-2]
	sub	x8, x20, x8, lsl #3
	stur	x0, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19], #1
	ldr	x1, [x25, x9, lsl #3]
	br	x1
LBB31_2:                                ; %B3
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function FastTypedArrayGet_asm_h
l_FastTypedArrayGet_asm_h:              ; @FastTypedArrayGet_asm_h
; %bb.0:                                ; %B43
	sub	sp, sp, #16
	ldp	x1, x2, [x20, #-16]
	mov	x10, x0
	ldr	w8, [x1, #48]
	cmp	w2, w8
	b.hs	LBB32_4
; %bb.1:                                ; %B21
	ldrh	w9, [x1, #6]
	ldr	x8, [x1, #40]
	cmp	w9, #23
	b.ge	LBB32_6
; %bb.2:                                ; %B21
	cmp	w9, #21
	b.eq	LBB32_7
; %bb.3:                                ; %B21
	cmp	w9, #22
	b.eq	LBB32_21
LBB32_4:                                ; %B18
	mov	x0, x24
	str	x20, [x23, #48]
	str	x10, [sp, #8]                   ; 8-byte Folded Spill
	bl	_JS_GetPropertyValue_GC
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	cmp	x0, #130
	mov	x8, x0
	b.ne	LBB32_9
; %bb.5:                                ; %B19
	add	sp, sp, #16
	b	l_exception_asm_h
LBB32_6:                                ; %B21
	b.gt	LBB32_11
LBB32_7:                                ; %B25
	ldrb	w8, [x8, w2, sxtw]
LBB32_8:                                ; %B1
	orr	x8, x8, #0xfffe000000000000
LBB32_9:                                ; %B1
	tbnz	w10, #0, LBB32_20
LBB32_10:                               ; %B4
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB32_11:                               ; %B21
	cmp	w9, #25
	b.gt	LBB32_15
; %bb.12:                               ; %B21
	cmp	w9, #24
	b.eq	LBB32_22
; %bb.13:                               ; %B21
	cmp	w9, #25
	b.ne	LBB32_4
; %bb.14:                               ; %B31
	ldrh	w8, [x8, w2, sxtw #1]
	b	LBB32_8
LBB32_15:                               ; %B21
	cmp	w9, #26
	b.eq	LBB32_23
; %bb.16:                               ; %B21
	cmp	w9, #27
	b.eq	LBB32_24
; %bb.17:                               ; %B21
	cmp	w9, #29
	b.ne	LBB32_4
; %bb.18:                               ; %B14
	ldr	d0, [x8, w2, sxtw #3]
LBB32_19:                               ; %B1
	fmov	x8, d0
	fcmp	d0, d0
	mov	x9, #562949953421312            ; =0x2000000000000
	add	x8, x8, x9
	mov	x9, #9221683186994511872        ; =0x7ffa000000000000
	csel	x8, x8, x9, vc
	tbz	w10, #0, LBB32_10
LBB32_20:                               ; %B2
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB32_21:                               ; %B22
	ldrsb	w8, [x8, w2, sxtw]
	b	LBB32_8
LBB32_22:                               ; %B28
	ldrsh	w8, [x8, w2, sxtw #1]
	b	LBB32_8
LBB32_23:                               ; %B34
	ldr	w8, [x8, w2, sxtw #2]
	b	LBB32_8
LBB32_24:                               ; %B5
	ldr	w8, [x8, w2, sxtw #2]
	tbz	w8, #31, LBB32_8
; %bb.25:                               ; %B10
	ucvtf	d0, w8
	b	LBB32_19
                                        ; -- End function
	.p2align	2                               ; -- Begin function FastTypedArraySet_asm_h
l_FastTypedArraySet_asm_h:              ; @FastTypedArraySet_asm_h
; %bb.0:                                ; %B43
	ldp	x1, x2, [x20, #-24]
	mov	w8, #65534                      ; =0xfffe
	ldur	x3, [x20, #-8]
	cmp	x8, x2, lsr #48
	b.ne	LBB33_17
; %bb.1:                                ; %B1
	ldr	w8, [x1, #48]
	cmp	w2, w8
	b.hs	LBB33_17
; %bb.2:                                ; %B3
	ldrh	w9, [x1, #6]
	ldr	x8, [x1, #40]
	sub	w10, w9, #22
	cmp	w10, #2
	b.hs	LBB33_6
; %bb.3:                                ; %B14
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x3, lsr #48
	b.ne	LBB33_17
; %bb.4:                                ; %B15
	strb	w3, [x8, w2, sxtw]
LBB33_5:                                ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB33_6:                                ; %B3
	cmp	w9, #25
	b.gt	LBB33_10
; %bb.7:                                ; %B3
	sub	w10, w9, #24
	cmp	w10, #2
	b.hs	LBB33_16
; %bb.8:                                ; %B20
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x3, lsr #48
	b.ne	LBB33_17
; %bb.9:                                ; %B21
	strh	w3, [x8, w2, sxtw #1]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB33_10:                               ; %B3
	sub	w10, w9, #26
	cmp	w10, #2
	b.hs	LBB33_13
; %bb.11:                               ; %B26
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x3, lsr #48
	b.ne	LBB33_17
; %bb.12:                               ; %B27
	str	w3, [x8, w2, sxtw #2]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB33_13:                               ; %B3
	cmp	w9, #29
	b.ne	LBB33_17
; %bb.14:                               ; %B32
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x3, lsr #48
	b.ne	LBB33_21
; %bb.15:                               ; %B33
	scvtf	d0, w3
	str	d0, [x8, w2, sxtw #3]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB33_16:                               ; %B3
	cmp	w9, #21
	b.eq	LBB33_19
LBB33_17:                               ; %B40
	mov	x0, x24
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	_JS_SetPropertyValue_GC
	tbz	w0, #31, LBB33_5
; %bb.18:                               ; %B41
	b	l_exception_asm_h
LBB33_19:                               ; %B5
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x3, lsr #48
	b.ne	LBB33_17
; %bb.20:                               ; %B6
	cmp	w3, #255
	mov	w9, #255                        ; =0xff
	csel	w9, w3, w9, lt
	bic	w9, w9, w9, asr #31
	strb	w9, [x8, w2, sxtw]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB33_21:                               ; %B35
	and	x9, x3, #0xfffe000000000000
	mov	x10, #-562949953421312          ; =0xfffe000000000000
	cmp	x9, x10
	b.eq	LBB33_17
; %bb.22:                               ; %B35
	cbz	x9, LBB33_17
; %bb.23:                               ; %B36
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	add	x9, x3, x9
	str	x9, [x8, w2, sxtw #3]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function FastAddNamedProperty_asm_h
l_FastAddNamedProperty_asm_h:           ; @FastAddNamedProperty_asm_h
; %bb.0:                                ; %B52
	sub	sp, sp, #64
	ldurb	w13, [x19, #-1]
	mov	x12, x19
	mov	x2, x0
	cmp	w13, #76
	b.eq	LBB34_2
; %bb.1:                                ; %B52
	cmp	w13, #67
	b.ne	LBB34_12
LBB34_2:                                ; %B53
	ldur	x1, [x20, #-16]
	cmp	x1, #18
	b.eq	LBB34_13
LBB34_3:                                ; %B42
	ldr	x15, [x1, #8]
	ldur	x14, [x20, #-8]
	ldr	x19, [x15, #40]
	cbz	x19, LBB34_14
LBB34_4:                                ; %B45
	ldr	x8, [x1, #16]
	ldr	w9, [x19, #16]
	add	x10, x1, #32
	ldr	w11, [x15, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	LBB34_6
; %bb.5:                                ; %B45
	cbz	w8, LBB34_18
LBB34_6:                                ; %B1
	ldr	w8, [x15, #48]
	cmp	w8, w2
	b.ne	LBB34_14
; %bb.7:                                ; %B1
	ldrb	w8, [x15, #52]
	cmp	w8, #7
	b.ne	LBB34_14
LBB34_8:                                ; %B17
	ldr	w8, [x19]
	add	x9, x1, #8
	add	w8, w8, #1
	str	w8, [x19]
	ldr	w8, [x15]
	sub	w8, w8, #1
	str	w8, [x15]
	stlr	x19, [x9]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB34_23
; %bb.9:                                ; %B14
	ldr	w8, [x19, #20]
	ldr	x9, [x1, #16]
	sub	w8, w8, #1
	str	x14, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB34_24
LBB34_10:                               ; %B8
	cmp	w13, #67
	b.ne	LBB34_21
; %bb.11:                               ; %B9
	ldrb	w8, [x12, #4]
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	add	x19, x12, #5
	add	sp, sp, #64
	br	x1
LBB34_12:
	ldur	x1, [x20, #-24]
	cmp	x1, #18
	b.ne	LBB34_3
LBB34_13:                               ; %B49
	ldr	x1, [x24, #208]
	ldr	x15, [x1, #8]
	ldur	x14, [x20, #-8]
	ldr	x19, [x15, #40]
	cbnz	x19, LBB34_4
LBB34_14:                               ; %B22
	ldr	x0, [x24, #8]
	stp	x2, x1, [sp, #32]               ; 16-byte Folded Spill
	mov	x1, x15
	mov	w3, #7                          ; =0x7
                                        ; kill: def $w2 killed $w2 killed $x2
	str	x12, [sp, #48]                  ; 8-byte Folded Spill
	stp	x15, x20, [sp, #16]             ; 16-byte Folded Spill
	str	w13, [sp, #60]                  ; 4-byte Folded Spill
	str	x14, [sp, #8]                   ; 8-byte Folded Spill
	bl	_find_hashed_shape_prop_gc
	ldp	x11, x20, [sp, #16]             ; 16-byte Folded Reload
	ldr	w13, [sp, #60]                  ; 4-byte Folded Reload
	ldp	x2, x1, [sp, #32]               ; 16-byte Folded Reload
	ldr	x12, [sp, #48]                  ; 8-byte Folded Reload
	cbz	x0, LBB34_18
; %bb.15:                               ; %B26
	ldr	x8, [x1, #16]
	ldr	w9, [x0, #16]
	add	x10, x1, #32
	ldr	w11, [x11, #16]
	mov	x19, x0
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	LBB34_17
; %bb.16:
	ldp	x1, x12, [sp, #40]              ; 16-byte Folded Reload
	ldr	w13, [sp, #60]                  ; 4-byte Folded Reload
	ldp	x15, x20, [sp, #16]             ; 16-byte Folded Reload
	ldr	x14, [sp, #8]                   ; 8-byte Folded Reload
	b	LBB34_8
LBB34_17:                               ; %B26
	ldp	x1, x12, [sp, #40]              ; 16-byte Folded Reload
	ldr	w13, [sp, #60]                  ; 4-byte Folded Reload
	ldp	x20, x2, [sp, #24]              ; 16-byte Folded Reload
	ldp	x14, x15, [sp, #8]              ; 16-byte Folded Reload
	cbnz	w8, LBB34_8
LBB34_18:                               ; %B29
	mov	x0, x24
	mov	w3, #7                          ; =0x7
	mov	w19, w13
	str	x12, [sp, #48]                  ; 8-byte Folded Spill
                                        ; kill: def $w2 killed $w2 killed $x2
	str	x20, [sp, #24]                  ; 8-byte Folded Spill
	str	x20, [x23, #48]
	bl	_add_property_gc
	cbz	x0, LBB34_25
; %bb.19:                               ; %B39
	ldr	x20, [sp, #24]                  ; 8-byte Folded Reload
	ldr	x12, [sp, #48]                  ; 8-byte Folded Reload
	mov	w13, w19
	ldur	x8, [x20, #-8]
	str	x8, [x0]
	ldrb	w9, [x24, #384]
	cbz	w9, LBB34_10
; %bb.20:                               ; %B41
	mov	x0, x8
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldr	x20, [sp, #24]                  ; 8-byte Folded Reload
	ldr	x12, [sp, #48]                  ; 8-byte Folded Reload
	mov	w13, w19
	b	LBB34_10
LBB34_21:                               ; %B11
	cmp	w13, #76
	b.ne	LBB34_27
; %bb.22:                               ; %B12
	ldrb	w8, [x12, #4]
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	add	x19, x12, #5
	add	sp, sp, #64
	br	x1
LBB34_23:                               ; %B19
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	stp	x1, x12, [sp, #40]              ; 16-byte Folded Spill
	mov	x1, x24
	orr	x0, x19, x8
	str	w13, [sp, #60]                  ; 4-byte Folded Spill
	str	x14, [sp, #8]                   ; 8-byte Folded Spill
	bl	_prim_WriteBarrierNoStore
	ldp	x1, x12, [sp, #40]              ; 16-byte Folded Reload
	ldr	x14, [sp, #8]                   ; 8-byte Folded Reload
	ldr	w13, [sp, #60]                  ; 4-byte Folded Reload
	ldr	w8, [x19, #20]
	ldr	x9, [x1, #16]
	sub	w8, w8, #1
	str	x14, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB34_10
LBB34_24:                               ; %B16
	mov	x0, x14
	mov	x1, x24
	mov	x19, x12
	str	w13, [sp, #60]                  ; 4-byte Folded Spill
	bl	_prim_WriteBarrierNoStore
	ldr	w13, [sp, #60]                  ; 4-byte Folded Reload
	mov	x12, x19
	b	LBB34_10
LBB34_25:                               ; %B31
	cmp	w19, #67
	b.ne	LBB34_28
; %bb.26:                               ; %B32
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	sub	x20, x8, #16
	ldr	x19, [sp, #48]                  ; 8-byte Folded Reload
	add	sp, sp, #64
	b	l_exception_asm_h
LBB34_27:                               ; %B13
	ldrb	w8, [x12], #1
	sub	x20, x20, #24
	mov	x19, x12
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #64
	br	x1
LBB34_28:                               ; %B34
	cmp	w19, #76
	b.ne	LBB34_30
; %bb.29:                               ; %B35
	ldr	x19, [sp, #48]                  ; 8-byte Folded Reload
	ldr	x20, [sp, #24]                  ; 8-byte Folded Reload
	add	sp, sp, #64
	b	l_exception_asm_h
LBB34_30:                               ; %B36
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	sub	x20, x8, #24
	ldr	x19, [sp, #48]                  ; 8-byte Folded Reload
	add	sp, sp, #64
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function invalid_0_asm_h
l_invalid_0_asm_h:                      ; @invalid_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x23, #8]
	mov	x0, x24
Lloh2:
	adrp	x1, l___unnamed_2@PAGE
Lloh3:
	add	x1, x1, l___unnamed_2@PAGEOFF
	ldr	x8, [x8, #32]
	ldr	x8, [x8, #8]
	str	x20, [x23, #48]
	mvn	x8, x8
	add	x8, x8, x19
	stp	x8, xzr, [sp, #-16]!
	bl	_LEPUS_ThrowInternalError
	add	sp, sp, #16
	b	l_exception_asm_h
	.loh AdrpAdd	Lloh2, Lloh3
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_i32_0_asm_h
l_push_i32_0_asm_h:                     ; @push_i32_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19, #4]
	ldr	w9, [x19], #5
	add	w8, w8, #243
	orr	x22, x9, #0xfffe000000000000
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_const_0_asm_h
l_push_const_0_asm_h:                   ; @push_const_0_asm_h
; %bb.0:                                ; %B3
	sub	sp, sp, #16
	ldr	x8, [x23, #112]
	ldrsw	x9, [x19]
	ldr	w10, [x24, #328]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, LBB37_2
; %bb.1:                                ; %B4
	mov	x0, x24
	mov	x2, x19
	str	x20, [x23, #48]
	str	x1, [sp, #8]                    ; 8-byte Folded Spill
	bl	_DebuggerPause
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
LBB37_2:                                ; %B1
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x1
	add	w8, w8, #243
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function fclosure_0_asm_h
l_fclosure_0_asm_h:                     ; @fclosure_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x23, #112]
	ldrsw	x9, [x19]
	ldr	x0, [x8, x9, lsl #3]
	b	l_FastFclosure_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_atom_value_0_asm_h
l_push_atom_value_0_asm_h:              ; @push_atom_value_0_asm_h
; %bb.0:                                ; %B13
	ldr	w1, [x19]
	tbnz	w1, #31, LBB39_5
; %bb.1:                                ; %B1
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, sxtw #3]
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, LBB39_4
; %bb.2:                                ; %B9
	ldr	w9, [x8, #8]
	asr	w9, w9, #30
	cmp	w9, #1
	b.ne	LBB39_5
LBB39_3:                                ; %B7
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	mov	x9, #2                          ; =0x2
	movk	x9, #1, lsl #48
	orr	x22, x8, x9
	br	x1
LBB39_4:                                ; %B2
	ldr	x9, [x8, #8]
	ldr	w9, [x9]
	asr	w9, w9, #30
	cmp	w9, #1
	b.eq	LBB39_3
LBB39_5:                                ; %B10
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB39_7
; %bb.6:                                ; %B12
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB39_7:                                ; %B11
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function private_symbol_0_asm_h
l_private_symbol_0_asm_h:               ; @private_symbol_0_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, #4                          ; =0x4
	str	x20, [x23, #48]
	bl	_JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	LBB40_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB40_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function undefined_0_asm_h
l_undefined_0_asm_h:                    ; @undefined_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	w22, #18                        ; =0x12
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function null_0_asm_h
l_null_0_asm_h:                         ; @null_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	w22, #2                         ; =0x2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_this_0_asm_h
l_push_this_0_asm_h:                    ; @push_this_0_asm_h
; %bb.0:                                ; %B12
	ldr	w8, [x23, #44]
	ldr	x1, [x23, #88]
	tbnz	w8, #0, LBB43_2
; %bb.1:                                ; %B12
	ldr	x8, [x23, #88]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, LBB43_3
LBB43_2:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x1
	add	w8, w8, #243
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
LBB43_3:                                ; %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	LBB43_5
; %bb.4:                                ; %B7
	ldrb	w8, [x19], #1
	ldr	x22, [x24, #208]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB43_5:                                ; %B9
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB43_7
; %bb.6:                                ; %B11
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB43_7:                                ; %B10
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_false_0_asm_h
l_push_false_0_asm_h:                   ; @push_false_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_true_0_asm_h
l_push_true_0_asm_h:                    ; @push_true_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function object_0_asm_h
l_object_0_asm_h:                       ; @object_0_asm_h
; %bb.0:                                ; %B16
	ldrb	w8, [x24, #363]
	stp	x19, x20, [sp, #-16]!           ; 16-byte Folded Spill
	cbnz	w8, LBB46_5
; %bb.1:                                ; %B1
	ldr	x19, [x24, #400]
	cbz	x19, LBB46_5
; %bb.2:                                ; %B5
	mov	x0, x24
	mov	w1, #64                         ; =0x40
	mov	w2, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x9, x0
	cbz	x9, LBB46_5
; %bb.3:                                ; %B7
	ldr	w8, [x19]
	add	w8, w8, #1
	str	w8, [x19]
	mov	w8, #1                          ; =0x1
	str	w8, [x9]
	strb	w8, [x9, #5]
	strh	w8, [x9, #6]
	add	x8, x9, #8
	stlr	x19, [x8]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB46_7
LBB46_4:                                ; %B9
	add	x8, x9, #32
	ldr	x19, [sp]                       ; 8-byte Folded Reload
	mov	x22, x9
	str	x8, [x9, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB46_5:                                ; %B13
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	LBB46_8
; %bb.6:                                ; %B15
	ldp	x19, x20, [sp]                  ; 16-byte Folded Reload
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB46_7:                                ; %B11
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x19, x8
	mov	x19, x9
	bl	_prim_WriteBarrierNoStore
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x9, x19
	b	LBB46_4
LBB46_8:                                ; %B14
	ldp	x19, x20, [sp], #16             ; 16-byte Folded Reload
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function special_object_0_asm_h
l_special_object_0_asm_h:               ; @special_object_0_asm_h
; %bb.0:                                ; %B12
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	LBB47_5
; %bb.1:                                ; %B12
	cbz	w8, LBB47_8
; %bb.2:                                ; %B12
	cmp	w8, #1
	b.ne	LBB47_10
; %bb.3:                                ; %B2
	ldr	x8, [x23, #8]
	ldr	w1, [x23, #120]
	mov	x0, x24
	mov	x2, x28
	mov	x3, x23
	ldr	x8, [x8, #32]
	ldrh	w8, [x8, #40]
	str	x20, [x23, #48]
	cmp	w8, w1
	csel	w4, w8, w1, lt
	bl	_js_build_mapped_arguments_gc
	cmp	x0, #130
	b.eq	LBB47_12
LBB47_4:
	mov	x8, x0
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB47_5:                                ; %B12
	cmp	w8, #3
	b.eq	LBB47_9
; %bb.6:                                ; %B12
	cmp	w8, #4
	b.ne	LBB47_11
; %bb.7:                                ; %B6
	ldr	x8, [x23, #8]
	mov	w9, #18                         ; =0x12
	ldr	x8, [x8, #48]
	cmp	x8, #0
	csel	x8, x9, x8, eq
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB47_8:                                ; %B13
	b	l_FastBuildArguments_asm_h
LBB47_9:                                ; %B16
	ldr	x8, [x23, #96]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB47_10:                               ; %B15
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB47_11:                               ; %B9
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.ne	LBB47_4
LBB47_12:                               ; %B10
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function rest_0_asm_h
l_rest_0_asm_h:                         ; @rest_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x23, #120]
	ldrh	w1, [x19]
	mov	x0, x24
	mov	x3, x28
	str	x20, [x23, #48]
	bl	_js_build_rest_gc
	cmp	x0, #130
	b.eq	LBB48_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB48_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function drop_0_asm_h
l_drop_0_asm_h:                         ; @drop_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function nip_0_asm_h
l_nip_0_asm_h:                          ; @nip_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldur	x22, [x20, #-8]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x8, x20, #16
	mov	x20, x8
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function nip1_0_asm_h
l_nip1_0_asm_h:                         ; @nip1_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldp	x22, x21, [x20, #-16]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	sub	x8, x20, #24
	mov	x20, x8
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function dup_0_asm_h
l_dup_0_asm_h:                          ; @dup_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x20, #-8]!
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x22
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function dup1_0_asm_h
l_dup1_0_asm_h:                         ; @dup1_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x20, #-8]!
	ldur	x22, [x20, #-8]
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	mov	x1, x22
	mov	x22, x21
	mov	x22, x1
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function dup2_0_asm_h
l_dup2_0_asm_h:                         ; @dup2_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldp	x22, x21, [x20, #-16]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function dup3_0_asm_h
l_dup3_0_asm_h:                         ; @dup3_0_asm_h
; %bb.0:                                ; %B0
	ldp	x8, x22, [x20, #-24]
	ldur	x21, [x20, #-8]
	str	x8, [x20], #8
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function insert2_0_asm_h
l_insert2_0_asm_h:                      ; @insert2_0_asm_h
; %bb.0:                                ; %B0
	ldr	x21, [x20, #-8]!
	ldur	x22, [x20, #-8]
	stur	x21, [x20, #-8]
	mov	x1, x22
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x22, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function insert3_0_asm_h
l_insert3_0_asm_h:                      ; @insert3_0_asm_h
; %bb.0:                                ; %B0
	ldr	x21, [x20, #-8]!
	ldp	x8, x22, [x20, #-16]
	stp	x21, x8, [x20, #-16]
	mov	x2, x22
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x22, x2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function insert4_0_asm_h
l_insert4_0_asm_h:                      ; @insert4_0_asm_h
; %bb.0:                                ; %B0
	ldr	x21, [x20, #-8]!
	ldur	x22, [x20, #-8]
	ldp	x9, x8, [x20, #-24]
	stur	x21, [x20, #-24]
	mov	x1, x22
	mov	x22, x21
	mov	x22, x1
	stp	x9, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function perm3_0_asm_h
l_perm3_0_asm_h:                        ; @perm3_0_asm_h
; %bb.0:                                ; %B0
	ldp	x22, x21, [x20, #-16]!
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function perm4_0_asm_h
l_perm4_0_asm_h:                        ; @perm4_0_asm_h
; %bb.0:                                ; %B0
	ldp	x22, x21, [x20, #-16]!
	mov	x9, x22
	ldp	x8, x22, [x20, #-16]
	stp	x9, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function perm5_0_asm_h
l_perm5_0_asm_h:                        ; @perm5_0_asm_h
; %bb.0:                                ; %B0
	ldp	x22, x21, [x20, #-16]!
	ldp	x9, x8, [x20, #-24]
	mov	x10, x22
	ldur	x22, [x20, #-8]
	stur	x10, [x20, #-24]
	stp	x9, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function swap_0_asm_h
l_swap_0_asm_h:                         ; @swap_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldp	x22, x21, [x20, #-16]!
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	mov	x1, x22
	mov	x22, x21
	mov	x21, x1
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function swap2_0_asm_h
l_swap2_0_asm_h:                        ; @swap2_0_asm_h
; %bb.0:                                ; %B0
	ldp	x22, x21, [x20, #-16]!
	ldp	x8, x9, [x20, #-16]
	stp	x22, x21, [x20, #-16]
	ldrb	w10, [x19], #1
	mov	x22, x8
	mov	x21, x9
	add	w10, w10, #486
	ldr	x1, [x25, w10, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function rot3l_0_asm_h
l_rot3l_0_asm_h:                        ; @rot3l_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-16]!
	ldur	x8, [x20, #-8]
	ldr	x21, [x20, #8]
	stur	x22, [x20, #-8]
	ldrb	w9, [x19], #1
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function rot3r_0_asm_h
l_rot3r_0_asm_h:                        ; @rot3r_0_asm_h
; %bb.0:                                ; %B0
	ldp	x22, x21, [x20, #-16]!
	mov	x8, x21
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function rot4l_0_asm_h
l_rot4l_0_asm_h:                        ; @rot4l_0_asm_h
; %bb.0:                                ; %B0
	ldp	x22, x21, [x20, #-16]!
	ldp	x9, x8, [x20, #-16]
	stp	x8, x22, [x20, #-16]
	mov	x22, x21
	mov	x21, x9
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function rot5l_0_asm_h
l_rot5l_0_asm_h:                        ; @rot5l_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-16]!
	ldur	x10, [x20, #-24]
	ldp	x8, x9, [x20, #-16]
	ldr	x21, [x20, #8]
	stur	x22, [x20, #-8]
	mov	x22, x21
	mov	x21, x10
	stp	x8, x9, [x20, #-24]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function call_constructor_0_asm_h
l_call_constructor_0_asm_h:             ; @call_constructor_0_asm_h
; %bb.0:                                ; %B18
	ldrh	w3, [x19]
	sub	x4, x20, w3, uxtw #3
	ldp	x1, x2, [x4, #-16]
	and	x8, x1, #0xfffffffffffffffe
	cmp	x1, x2
	and	x8, x8, #0xffff000000000003
	ccmp	x8, #0, #0, eq
	b.ne	LBB68_5
; %bb.1:                                ; %B14
	ldrh	w8, [x1, #6]
	cmp	w8, #13
	b.ne	LBB68_5
; %bb.2:                                ; %B7
	ldrb	w8, [x1, #5]
	tbz	w8, #4, LBB68_5
; %bb.3:                                ; %B9
	ldr	x8, [x1, #32]
	mov	x0, x3
	ldrb	w8, [x8, #6]
	tbnz	w8, #2, LBB68_7
; %bb.4:                                ; %B10
	b	l_FastCallConstructor_asm_h
LBB68_5:                                ; %B2
	add	x8, x19, #2
	mov	x0, x24
	mov	w5, wzr
	str	x8, [x23, #32]
                                        ; kill: def $w3 killed $w3 killed $x3
	str	x20, [x23, #48]
	bl	_JS_CallConstructorInternal_GC
	cmp	x0, #130
	b.eq	LBB68_8
; %bb.6:                                ; %B4
	ldrh	w8, [x19]
	sub	x8, x20, x8, lsl #3
	stur	x0, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x9, lsl #3]
	br	x1
LBB68_7:                                ; %B11
	b	l_FastCallDerivedConstructor_asm_h
LBB68_8:                                ; %B3
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call_0_asm_h
l_call_0_asm_h:                         ; @call_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19], #2
	str	x20, [x23, #48]
	str	x19, [x23, #32]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	sub	x20, x20, x8, lsl #3
	mov	x0, x8
	ldur	x22, [x20, #-8]
	bl	l_common_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #104]
	b.eq	LBB69_2
; %bb.1:                                ; %B4
	ldurh	w8, [x19, #-2]
	add	w8, w8, #1
	sub	x20, x20, w8, uxtw #3
	str	x0, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB69_2:                                ; %B3
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function tail_call_0_asm_h
l_tail_call_0_asm_h:                    ; @tail_call_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19], #2
	str	x20, [x23, #48]
	str	x19, [x23, #32]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	sub	x20, x20, x8, lsl #3
	mov	x0, x8
	ldur	x22, [x20, #-8]
	bl	l_common_call_asm_h
	cmp	x0, #130
	b.eq	LBB70_2
; %bb.1:                                ; %B4
	ldr	x26, [x23, #104]
	mov	x19, xzr
	mov	x20, xzr
	b	l_common_return_asm_h
LBB70_2:                                ; %B3
	mov	x19, xzr
	mov	x20, xzr
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call_method_0_asm_h
l_call_method_0_asm_h:                  ; @call_method_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19], #2
	str	x20, [x23, #48]
	str	x19, [x23, #32]
	mov	w27, #18                        ; =0x12
	sub	x20, x20, x8, lsl #3
	mov	x0, x8
	ldp	x21, x22, [x20, #-16]
	bl	l_common_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #104]
	b.eq	LBB71_2
; %bb.1:                                ; %B4
	ldurh	w8, [x19, #-2]
	add	w8, w8, #2
	sub	x20, x20, w8, uxtw #3
	str	x0, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB71_2:                                ; %B3
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function tail_call_method_0_asm_h
l_tail_call_method_0_asm_h:             ; @tail_call_method_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19], #2
	str	x20, [x23, #48]
	str	x19, [x23, #32]
	mov	w27, #18                        ; =0x12
	sub	x20, x20, x8, lsl #3
	mov	x0, x8
	ldp	x21, x22, [x20, #-16]
	bl	l_common_call_asm_h
	cmp	x0, #130
	b.eq	LBB72_2
; %bb.1:                                ; %B4
	ldr	x26, [x23, #104]
	mov	x19, xzr
	mov	x20, xzr
	b	l_common_return_asm_h
LBB72_2:                                ; %B3
	mov	x19, xzr
	mov	x20, xzr
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function array_from_0_asm_h
l_array_from_0_asm_h:                   ; @array_from_0_asm_h
; %bb.0:                                ; %B32
	sub	sp, sp, #64
	ldrh	w1, [x19]
	ldrb	w8, [x24, #363]
	str	x19, [sp, #40]                  ; 8-byte Folded Spill
	str	x20, [sp, #56]                  ; 8-byte Folded Spill
	sub	x9, x20, w1, uxtw #3
	str	x9, [sp, #24]                   ; 8-byte Folded Spill
	cbnz	w8, LBB73_13
; %bb.1:                                ; %B1
	ldr	x8, [x24, #40]
	str	x8, [sp, #32]                   ; 8-byte Folded Spill
	cbz	x8, LBB73_13
; %bb.2:                                ; %B5
	str	x1, [sp, #48]                   ; 8-byte Folded Spill
	cbz	w1, LBB73_8
; %bb.3:                                ; %B10
	ldp	x9, x8, [sp, #48]               ; 16-byte Folded Reload
	mov	x0, x24
	mov	w2, #42                         ; =0x2a
	lsl	x1, x9, #3
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x1, [sp, #48]                   ; 8-byte Folded Reload
	cbz	x0, LBB73_13
; %bb.4:                                ; %B13.preheader
	add	x10, x0, x1, lsl #3
	ldr	x19, [sp, #24]                  ; 8-byte Folded Reload
	mov	x20, x0
	str	x20, [sp, #16]                  ; 8-byte Folded Spill
	cmp	x20, x10
	b.ge	LBB73_9
LBB73_5:                                ; %B15
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x19]
	str	x8, [x20]
	ldrb	w9, [x24, #384]
	cbnz	w9, LBB73_7
LBB73_6:                                ; %B17
                                        ;   in Loop: Header=BB73_5 Depth=1
	add	x20, x20, #8
	add	x19, x19, #8
	cmp	x20, x10
	b.lt	LBB73_5
	b	LBB73_9
LBB73_7:                                ; %B18
                                        ;   in Loop: Header=BB73_5 Depth=1
	mov	x0, x8
	mov	x1, x24
	str	x10, [sp, #8]                   ; 8-byte Folded Spill
	bl	_prim_WriteBarrierNoStore
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	b	LBB73_6
LBB73_8:
	str	xzr, [sp, #16]                  ; 8-byte Folded Spill
LBB73_9:                                ; %B21
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	mov	x0, x24
	mov	w1, #88                         ; =0x58
	mov	w2, #2                          ; =0x2
	mov	w20, #2                         ; =0x2
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x1, [sp, #48]                   ; 8-byte Folded Reload
	mov	x19, x0
	cbz	x19, LBB73_13
; %bb.10:                               ; %B23
	ldr	x9, [sp, #32]                   ; 8-byte Folded Reload
	ldr	w8, [x9]
	add	w8, w8, #1
	str	w8, [x9]
	mov	w8, #1                          ; =0x1
	str	w8, [x19]
	mov	w8, #13                         ; =0xd
	strb	w8, [x19, #5]
	add	x8, x19, #8
	strh	w20, [x19, #6]
	stlr	x9, [x8]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB73_15
LBB73_11:                               ; %B25
	orr	x8, x1, #0xfffe000000000000
	mov	x9, x19
	str	x8, [x9, #56]!
	ldr	x8, [sp, #16]                   ; 8-byte Folded Reload
	str	x9, [x19, #16]
	str	x8, [x19, #40]
	str	w1, [x19, #32]
	str	w1, [x19, #48]
LBB73_12:                               ; %B26
	ldr	x9, [sp, #40]                   ; 8-byte Folded Reload
	ldr	x10, [sp, #56]                  ; 8-byte Folded Reload
	ldrh	w8, [x9]
	sub	x20, x10, x8, lsl #3
	str	x19, [x20], #8
	add	x19, x9, #3
	ldrb	w8, [x9, #2]
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #64
	br	x1
LBB73_13:                               ; %B29
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	ldr	x2, [sp, #24]                   ; 8-byte Folded Reload
	mov	x0, x24
                                        ; kill: def $w1 killed $w1 killed $x1
	str	x8, [x23, #48]
	bl	_JS_NewArrayWithArgs_GC
	cmp	x0, #130
	mov	x19, x0
	b.ne	LBB73_12
; %bb.14:                               ; %B30
	ldr	x19, [sp, #40]                  ; 8-byte Folded Reload
	ldr	x20, [sp, #56]                  ; 8-byte Folded Reload
	add	sp, sp, #64
	b	l_exception_asm_h
LBB73_15:                               ; %B27
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	_prim_WriteBarrierNoStore
	ldr	x1, [sp, #48]                   ; 8-byte Folded Reload
	b	LBB73_11
                                        ; -- End function
	.p2align	2                               ; -- Begin function apply_0_asm_h
l_apply_0_asm_h:                        ; @apply_0_asm_h
; %bb.0:                                ; %B1
	sub	sp, sp, #16
	ldrh	w4, [x19]
	ldur	x1, [x20, #-24]
	sub	x3, x20, #16
	mov	x0, x24
	mov	w2, #2                          ; =0x2
	str	x20, [x23, #48]
	str	x3, [sp, #8]                    ; 8-byte Folded Spill
	bl	_js_function_apply_gc
	cmp	x0, #130
	b.eq	LBB74_2
; %bb.1:                                ; %B3
	stur	x0, [x20, #-24]
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB74_2:                                ; %B2
	add	sp, sp, #16
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function return_0_asm_h
l_return_0_asm_h:                       ; @return_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	mov	x0, x22
	b	l_common_return_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function return_undef_0_asm_h
l_return_undef_0_asm_h:                 ; @return_undef_0_asm_h
; %bb.0:                                ; %B0
	mov	w0, #18                         ; =0x12
	b	l_common_return_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function check_ctor_return_0_asm_h
l_check_ctor_return_0_asm_h:            ; @check_ctor_return_0_asm_h
; %bb.0:                                ; %B5
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	LBB77_3
; %bb.1:                                ; %B2
	cmp	x22, #18
	b.eq	LBB77_4
; %bb.2:                                ; %B3
Lloh4:
	adrp	x1, l___unnamed_3@PAGE
Lloh5:
	add	x1, x1, l___unnamed_3@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_ThrowTypeError
	b	l_exception_asm_h
LBB77_3:                                ; %B6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w21, #6                         ; =0x6
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB77_4:                                ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w21, #7                         ; =0x7
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh4, Lloh5
                                        ; -- End function
	.p2align	2                               ; -- Begin function check_ctor_0_asm_h
l_check_ctor_0_asm_h:                   ; @check_ctor_0_asm_h
; %bb.0:                                ; %B2
	ldr	x8, [x23, #96]
	cmp	x8, #18
	b.ne	LBB78_2
; %bb.1:                                ; %B3
Lloh6:
	adrp	x1, l___unnamed_4@PAGE
Lloh7:
	add	x1, x1, l___unnamed_4@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_ThrowTypeError
	b	l_exception_asm_h
LBB78_2:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
	.loh AdrpAdd	Lloh6, Lloh7
                                        ; -- End function
	.p2align	2                               ; -- Begin function check_brand_0_asm_h
l_check_brand_0_asm_h:                  ; @check_brand_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	_JS_CheckBrand_GC
	tbnz	w0, #31, LBB79_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB79_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function add_brand_0_asm_h
l_add_brand_0_asm_h:                    ; @add_brand_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	_JS_AddBrand_GC
	tbnz	w0, #31, LBB80_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB80_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function return_async_0_asm_h
l_return_async_0_asm_h:                 ; @return_async_0_asm_h
; %bb.0:                                ; %B0
	str	x19, [x23, #32]
	mov	w0, #18                         ; =0x12
	str	x20, [x23, #48]
	b	l_common_return_direct_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function throw_0_asm_h
l_throw_0_asm_h:                        ; @throw_0_asm_h
; %bb.0:                                ; %B0
	ldr	x1, [x20, #-8]!
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_Throw
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function throw_var_0_asm_h
l_throw_var_0_asm_h:                    ; @throw_var_0_asm_h
; %bb.0:                                ; %B3
	sub	sp, sp, #16
	ldrb	w8, [x19, #4]
	ldr	w2, [x19]
	str	x20, [x23, #48]
	cmp	w8, #1
	b.le	LBB83_5
; %bb.1:                                ; %B3
	cmp	w8, #2
	b.eq	LBB83_8
; %bb.2:                                ; %B3
	cmp	w8, #3
	b.eq	LBB83_9
; %bb.3:                                ; %B3
	cmp	w8, #4
	b.ne	LBB83_11
; %bb.4:                                ; %B8
Lloh8:
	adrp	x1, l___unnamed_5@PAGE
Lloh9:
	add	x1, x1, l___unnamed_5@PAGEOFF
	mov	x0, x24
	bl	_LEPUS_ThrowTypeError
	add	sp, sp, #16
	b	l_exception_asm_h
LBB83_5:                                ; %B3
	cbz	w8, LBB83_10
; %bb.6:                                ; %B3
	cmp	w8, #1
	b.ne	LBB83_11
; %bb.7:                                ; %B5
	mov	x0, x24
	mov	w1, w2
	bl	_JS_ThrowSyntaxErrorVarRedeclaration_GC
	add	sp, sp, #16
	b	l_exception_asm_h
LBB83_8:                                ; %B6
	mov	x0, x24
	mov	w1, w2
	bl	_JS_ThrowReferenceErrorUninitialized_GC
	add	sp, sp, #16
	b	l_exception_asm_h
LBB83_9:                                ; %B7
Lloh10:
	adrp	x1, l___unnamed_6@PAGE
Lloh11:
	add	x1, x1, l___unnamed_6@PAGEOFF
	mov	x0, x24
	bl	_LEPUS_ThrowReferenceError
	add	sp, sp, #16
	b	l_exception_asm_h
LBB83_10:                               ; %B4
	mov	x0, x24
	mov	w1, #16384                      ; =0x4000
                                        ; kill: def $w2 killed $w2 killed $x2
	bl	_JS_ThrowTypeErrorReadOnly
	add	sp, sp, #16
	b	l_exception_asm_h
LBB83_11:                               ; %B9
Lloh12:
	adrp	x1, l___unnamed_7@PAGE
Lloh13:
	add	x1, x1, l___unnamed_7@PAGEOFF
	mov	x0, x24
	str	x2, [sp]
	bl	_LEPUS_ThrowInternalError
	add	sp, sp, #16
	b	l_exception_asm_h
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpAdd	Lloh12, Lloh13
                                        ; -- End function
	.p2align	2                               ; -- Begin function eval_0_asm_h
l_eval_0_asm_h:                         ; @eval_0_asm_h
; %bb.0:                                ; %B1
	ldrh	w8, [x19]
	ldur	x2, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #48]
	sub	w1, w8, #1
	bl	_prim_js_op_eval_gc
	cmp	x0, #130
	b.eq	LBB84_2
; %bb.1:                                ; %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB84_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function regexp_0_asm_h
l_regexp_0_asm_h:                       ; @regexp_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w1, #18                         ; =0x12
	str	x20, [x23, #48]
	mov	x2, x22
	mov	x3, x21
	bl	_js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	LBB85_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB85_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_super_ctor_0_asm_h
l_get_super_ctor_0_asm_h:               ; @get_super_ctor_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	bl	_primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	LBB86_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB86_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_super_0_asm_h
l_get_super_0_asm_h:                    ; @get_super_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	bl	_JS_GetPrototype_GC
	cmp	x0, #130
	b.eq	LBB87_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB87_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function import_0_asm_h
l_import_0_asm_h:                       ; @import_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	bl	_js_dynamic_import
	cmp	x0, #130
	b.eq	LBB88_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB88_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function check_var_0_asm_h
l_check_var_0_asm_h:                    ; @check_var_0_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_CheckGlobalVar_GC
	tbnz	w0, #31, LBB89_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB89_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_undef_0_asm_h
l_get_var_undef_0_asm_h:                ; @get_var_undef_0_asm_h
; %bb.0:                                ; %B0
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
	cbz	w11, LBB90_3
LBB90_1:                                ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB90_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB90_1 Depth=1
	ldr	w11, [x12]
	and	w11, w11, #0x3ffffff
	cbnz	w11, LBB90_1
LBB90_3:                                ; %B11
	ldr	x8, [x24, #208]
	mov	w10, #18                        ; =0x12
LBB90_4:                                ; %B33
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB90_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w9, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB90_7
LBB90_5:                                ; %B22
                                        ;   Parent Loop BB90_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w9
	b.eq	LBB90_9
; %bb.6:                                ; %B24
                                        ;   in Loop: Header=BB90_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB90_5
LBB90_7:                                ; %B27
                                        ;   in Loop: Header=BB90_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	LBB90_13
; %bb.8:                                ; %B30
                                        ;   in Loop: Header=BB90_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB90_4
	b	LBB90_11
LBB90_9:                                ; %B12
	lsr	w9, w13, #26
	tst	w9, #0x30
	b.ne	LBB90_13
LBB90_10:                               ; %B7.sink.split
	ldr	x8, [x8, #16]
	sub	w9, w11, #1
	ldr	x10, [x8, w9, sxtw #3]
LBB90_11:                               ; %B7
	cmp	x10, #34
	b.eq	LBB90_15
; %bb.12:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x10
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB90_13:                               ; %B17
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB90_16
; %bb.14:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB90_15:                               ; %B3
	b	l_ThrowReferenceErrorUninitialized_asm_h
LBB90_16:                               ; %B18
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_0_asm_h
l_get_var_0_asm_h:                      ; @get_var_0_asm_h
; %bb.0:                                ; %B0
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
	cbz	w10, LBB91_3
LBB91_1:                                ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB91_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB91_1 Depth=1
	ldr	w10, [x12]
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB91_1
LBB91_3:                                ; %B11
	ldr	x8, [x24, #208]
LBB91_4:                                ; %B32
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB91_5 Depth 2
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w9, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB91_7
LBB91_5:                                ; %B21
                                        ;   Parent Loop BB91_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	LBB91_9
; %bb.6:                                ; %B23
                                        ;   in Loop: Header=BB91_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB91_5
LBB91_7:                                ; %B26
                                        ;   in Loop: Header=BB91_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB91_12
; %bb.8:                                ; %B29
                                        ;   in Loop: Header=BB91_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB91_4
	b	LBB91_12
LBB91_9:                                ; %B12
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	LBB91_12
LBB91_10:                               ; %B7
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	LBB91_14
; %bb.11:                               ; %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB91_12:                               ; %B16
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB91_15
; %bb.13:                               ; %B18
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB91_14:                               ; %B3
	b	l_ThrowReferenceErrorUninitialized_asm_h
LBB91_15:                               ; %B17
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_0_asm_h
l_put_var_0_asm_h:                      ; @put_var_0_asm_h
; %bb.0:                                ; %B0
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
	cbz	w9, LBB92_3
LBB92_1:                                ; %B1
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w12, w1
	b.eq	LBB92_6
; %bb.2:                                ; %B16
                                        ;   in Loop: Header=BB92_1 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, LBB92_1
LBB92_3:                                ; %B19
	ldr	x8, [x24, #208]
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x12, x9, #64
	lsl	w11, w10, #2
	and	w9, w1, w10
	ldr	w9, [x12, w9, sxtw #2]
	add	w10, w11, #4
	add	x10, x12, x10
	cbz	w9, LBB92_13
LBB92_4:                                ; %B26
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w12, w1
	b.eq	LBB92_10
; %bb.5:                                ; %B31
                                        ;   in Loop: Header=BB92_4 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, LBB92_4
	b	LBB92_13
LBB92_6:                                ; %B13
	mov	w10, #58                        ; =0x3a
	and	w10, w10, w11, lsr #26
	cmp	w10, #2
	b.ne	LBB92_13
; %bb.7:                                ; %B3
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	ldr	x10, [x8, w9, sxtw #3]
	cmp	x10, #34
	b.eq	LBB92_13
; %bb.8:                                ; %B20
	str	x22, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB92_12
LBB92_9:                                ; %B8
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB92_10:                               ; %B28
	mov	w10, #58                        ; =0x3a
	and	w10, w10, w11, lsr #26
	cmp	w10, #2
	b.ne	LBB92_13
; %bb.11:                               ; %B20
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	str	x22, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB92_9
LBB92_12:
	mov	x1, x24
	mov	x0, x22
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB92_13:                               ; %B34
	mov	x0, x24
	mov	x2, x22
	mov	w3, wzr
	str	x20, [x23, #48]
	bl	_JS_SetGlobalVar_GC
	tbz	w0, #31, LBB92_9
; %bb.14:                               ; %B35
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_init_0_asm_h
l_put_var_init_0_asm_h:                 ; @put_var_init_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	mov	x2, x22
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB93_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB93_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_strict_0_asm_h
l_put_var_strict_0_asm_h:               ; @put_var_strict_0_asm_h
; %bb.0:                                ; %B38
	ldp	x22, x21, [x20, #-16]
	cmp	x22, #7
	b.ne	LBB94_16
; %bb.1:                                ; %B40
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
	cbz	w9, LBB94_4
LBB94_2:                                ; %B30
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w12, w1
	b.eq	LBB94_7
; %bb.3:                                ; %B32
                                        ;   in Loop: Header=BB94_2 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, LBB94_2
LBB94_4:                                ; %B34
	ldr	x8, [x24, #208]
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x12, x9, #64
	lsl	w11, w10, #2
	and	w9, w1, w10
	ldr	w9, [x12, w9, sxtw #2]
	add	w10, w11, #4
	add	x10, x12, x10
	cbz	w9, LBB94_14
LBB94_5:                                ; %B23
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w12, w1
	b.eq	LBB94_11
; %bb.6:                                ; %B25
                                        ;   in Loop: Header=BB94_5 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, LBB94_5
	b	LBB94_14
LBB94_7:                                ; %B1
	mov	w10, #58                        ; =0x3a
	and	w10, w10, w11, lsr #26
	cmp	w10, #2
	b.ne	LBB94_14
; %bb.8:                                ; %B9
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	ldr	x10, [x8, w9, sxtw #3]
	cmp	x10, #34
	b.eq	LBB94_14
; %bb.9:                                ; %B14
	str	x21, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB94_13
LBB94_10:                               ; %B6
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB94_11:                               ; %B18
	mov	w10, #58                        ; =0x3a
	and	w10, w10, w11, lsr #26
	cmp	w10, #2
	b.ne	LBB94_14
; %bb.12:                               ; %B14
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	str	x21, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB94_10
LBB94_13:
	mov	x1, x24
	mov	x0, x21
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB94_14:                               ; %B35
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_JS_SetGlobalVar_GC
	tbz	w0, #31, LBB94_10
; %bb.15:                               ; %B36
	b	l_exception_asm_h
LBB94_16:                               ; %B39
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_ref_value_0_asm_h
l_get_ref_value_0_asm_h:                ; @get_ref_value_0_asm_h
; %bb.0:                                ; %B49
	ldp	x22, x21, [x20, #-16]
	cmp	x22, #18
	b.eq	LBB95_7
; %bb.1:                                ; %B1
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB95_5
; %bb.2:                                ; %B39
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	LBB95_5
; %bb.3:                                ; %B3
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB95_5
; %bb.4:                                ; %B3
	mov	x9, #2                          ; =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	LBB95_10
LBB95_5:                                ; %B43
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB95_9
; %bb.6:                                ; %B45
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB95_7:                                ; %B46
	mov	x0, x24
	mov	x1, x21
	str	x20, [x23, #48]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB95_9
; %bb.8:                                ; %B48
	mov	w1, w0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB95_9:                                ; %B47
	b	l_exception_asm_h
LBB95_10:                               ; %B9
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB95_22
; %bb.11:                               ; %B37
	ldr	w8, [x1, #8]
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	LBB95_5
LBB95_12:                               ; %B11
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	cbz	w0, LBB95_5
; %bb.13:                               ; %B14.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB95_14:                               ; %B14
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB95_15 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB95_17
LBB95_15:                               ; %B25
                                        ;   Parent Loop BB95_14 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	LBB95_19
; %bb.16:                               ; %B30
                                        ;   in Loop: Header=BB95_15 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB95_15
LBB95_17:                               ; %B16
                                        ;   in Loop: Header=BB95_14 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB95_5
; %bb.18:                               ; %B19
                                        ;   in Loop: Header=BB95_14 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB95_14
	b	LBB95_21
LBB95_19:                               ; %B27
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB95_5
; %bb.20:                               ; %B28
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB95_21:                               ; %B22
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB95_22:                               ; %B10
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
	asr	w8, w8, #30
	cmp	w8, #1
	b.eq	LBB95_12
	b	LBB95_5
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_ref_value_0_asm_h
l_put_ref_value_0_asm_h:                ; @put_ref_value_0_asm_h
; %bb.0:                                ; %B70
	sub	sp, sp, #16
	ldp	x10, x22, [x20, #-24]
	ldur	x21, [x20, #-8]
	cmp	x10, #18
	b.eq	LBB96_7
; %bb.1:                                ; %B1
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x10, x8
	b.ne	LBB96_5
LBB96_2:                                ; %B56
	ldrh	w8, [x10, #6]
	cmp	w8, #1
	b.ne	LBB96_5
; %bb.3:                                ; %B3
	ldr	w8, [x10, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB96_5
; %bb.4:                                ; %B3
	mov	x9, #2                          ; =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	LBB96_9
LBB96_5:                                ; %B60
	mov	x0, x24
	mov	x1, x10
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x20, [x23, #48]
	bl	_JS_SetPropertyValue_GC
	tbnz	w0, #31, LBB96_29
; %bb.6:                                ; %B62
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB96_7:                                ; %B66
	ldr	w8, [x23, #44]
	tbnz	w8, #0, LBB96_27
; %bb.8:                                ; %B67
	ldr	x10, [x24, #208]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x10, x8
	b.eq	LBB96_2
	b	LBB96_5
LBB96_9:                                ; %B9
	and	x1, x22, #0xfffffffffffc
	stp	x10, x20, [sp]                  ; 16-byte Folded Spill
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB96_30
; %bb.10:                               ; %B54
	ldr	w8, [x1, #8]
	asr	w8, w8, #30
	ldp	x10, x20, [sp]                  ; 16-byte Folded Reload
	cmp	w8, #1
	b.ne	LBB96_5
LBB96_11:                               ; %B11
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	ldp	x10, x20, [sp]                  ; 16-byte Folded Reload
	cbz	w0, LBB96_5
; %bb.12:                               ; %B13
	ldr	x8, [x10, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w0, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB96_15
LBB96_13:                               ; %B16
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	LBB96_21
; %bb.14:                               ; %B26
                                        ;   in Loop: Header=BB96_13 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB96_13
LBB96_15:                               ; %B28.preheader
	ldp	x8, x20, [sp]                   ; 16-byte Folded Reload
LBB96_16:                               ; %B28
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB96_17 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w0, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB96_19
LBB96_17:                               ; %B41
                                        ;   Parent Loop BB96_16 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	LBB96_24
; %bb.18:                               ; %B46
                                        ;   in Loop: Header=BB96_17 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB96_17
LBB96_19:                               ; %B29
                                        ;   in Loop: Header=BB96_16 Depth=1
	ldr	w9, [x8, #4]
	ldr	x10, [sp]                       ; 8-byte Folded Reload
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB96_5
; %bb.20:                               ; %B35
                                        ;   in Loop: Header=BB96_16 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB96_16
	b	LBB96_25
LBB96_21:                               ; %B18
	mov	w9, #58                         ; =0x3a
	and	w9, w9, w10, lsr #26
	ldp	x10, x20, [sp]                  ; 16-byte Folded Reload
	cmp	w9, #2
	b.ne	LBB96_5
; %bb.22:                               ; %B22
	ldr	x9, [x10, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB96_31
; %bb.23:                               ; %B20
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #16
	br	x1
LBB96_24:                               ; %B43
	mov	w8, #58                         ; =0x3a
	and	w8, w8, w10, lsr #26
	ldp	x10, x20, [sp]                  ; 16-byte Folded Reload
	cmp	w8, #2
	b.ne	LBB96_5
LBB96_25:                               ; %B32
	ldr	w8, [x10, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	LBB96_5
; %bb.26:                               ; %B33
	mov	w0, w0
	add	sp, sp, #16
	b	l_FastAddNamedProperty_asm_h
LBB96_27:                               ; %B63
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #48]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB96_29
; %bb.28:                               ; %B65
	mov	w1, w0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB96_29:                               ; %B61
	add	sp, sp, #16
	b	l_exception_asm_h
LBB96_30:                               ; %B10
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
	asr	w8, w8, #30
	ldp	x10, x20, [sp]                  ; 16-byte Folded Reload
	cmp	w8, #1
	b.eq	LBB96_11
	b	LBB96_5
LBB96_31:                               ; %B24
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #16
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_var_0_asm_h
l_define_var_0_asm_h:                   ; @define_var_0_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_DefineGlobalVar_GC
	tbnz	w0, #31, LBB97_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB97_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function check_define_var_0_asm_h
l_check_define_var_0_asm_h:             ; @check_define_var_0_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, LBB98_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB98_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_func_0_asm_h
l_define_func_0_asm_h:                  ; @define_func_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	ldrb	w3, [x19, #4]
	str	x20, [x23, #48]
	mov	x2, x22
	bl	_JS_DefineGlobalFunction_GC
	tbnz	w0, #31, LBB99_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	sub	x20, x20, #8
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB99_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_field_0_asm_h
l_get_field_0_asm_h:                    ; @get_field_0_asm_h
; %bb.0:                                ; %B24
	mov	x8, #2                          ; =0x2
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB100_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB100_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB100_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB100_5
LBB100_3:                               ; %B1
                                        ;   Parent Loop BB100_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB100_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB100_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB100_3
LBB100_5:                               ; %B14
                                        ;   in Loop: Header=BB100_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB100_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB100_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB100_2
	b	LBB100_9
LBB100_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB100_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB100_9:                               ; %B6
	ldrb	w9, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB100_10:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB100_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB100_12:                              ; %B22
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_field2_0_asm_h
l_get_field2_0_asm_h:                   ; @get_field2_0_asm_h
; %bb.0:                                ; %B24
	mov	x8, #2                          ; =0x2
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB101_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB101_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB101_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB101_5
LBB101_3:                               ; %B1
                                        ;   Parent Loop BB101_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB101_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB101_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB101_3
LBB101_5:                               ; %B14
                                        ;   in Loop: Header=BB101_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB101_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB101_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB101_2
	b	LBB101_9
LBB101_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB101_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB101_9:                               ; %B6
	ldrb	w9, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB101_10:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB101_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB101_12:                              ; %B22
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_field_0_asm_h
l_put_field_0_asm_h:                    ; @put_field_0_asm_h
; %bb.0:                                ; %B55
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	ldr	w2, [x19]
	tst	x22, x8
	b.ne	LBB102_18
; %bb.1:                                ; %B56
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB102_4
LBB102_2:                               ; %B1
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB102_10
; %bb.3:                                ; %B12
                                        ;   in Loop: Header=BB102_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB102_2
LBB102_4:                               ; %B17.preheader
	mov	x8, x22
LBB102_5:                               ; %B17
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB102_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w2, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB102_8
LBB102_6:                               ; %B18
                                        ;   Parent Loop BB102_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB102_13
; %bb.7:                                ; %B34
                                        ;   in Loop: Header=BB102_6 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB102_6
LBB102_8:                               ; %B41
                                        ;   in Loop: Header=BB102_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB102_18
; %bb.9:                                ; %B38
                                        ;   in Loop: Header=BB102_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB102_5
	b	LBB102_14
LBB102_10:                              ; %B3
	mov	w9, #58                         ; =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	LBB102_18
; %bb.11:                               ; %B7
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB102_22
LBB102_12:                              ; %B48
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB102_13:                              ; %B20
	mov	w8, #58                         ; =0x3a
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	LBB102_18
LBB102_14:                              ; %B23
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	LBB102_18
; %bb.15:                               ; %B25
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	LBB102_20
; %bb.16:                               ; %B25
	tbnz	w2, #31, LBB102_20
; %bb.17:                               ; %B31
	mov	x0, x2
	b	l_FastAddNamedProperty_asm_h
LBB102_18:                              ; %B52
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x20, [x23, #48]
                                        ; kill: def $w2 killed $w2 killed $x2
	bl	_JS_SetPropertyInternalImpl_GC
	tbz	w0, #31, LBB102_12
; %bb.19:                               ; %B53
	b	l_exception_asm_h
LBB102_20:                              ; %B45
	mov	x0, x24
	mov	x1, x22
	mov	w3, #7                          ; =0x7
	str	x20, [x23, #48]
                                        ; kill: def $w2 killed $w2 killed $x2
	bl	_add_property_gc
	cbz	x0, LBB102_23
; %bb.21:                               ; %B49
	str	x21, [x0]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB102_12
LBB102_22:                              ; %B51
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB102_23:                              ; %B46
	sub	x20, x20, #16
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_private_field_0_asm_h
l_get_private_field_0_asm_h:            ; @get_private_field_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	_JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	LBB103_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB103_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_private_field_0_asm_h
l_put_private_field_0_asm_h:            ; @put_private_field_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	str	x20, [x23, #48]
	mov	x2, x21
	mov	x3, x22
	bl	_JS_SetPrivateField_GC
	tbnz	w0, #31, LBB104_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB104_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_private_field_0_asm_h
l_define_private_field_0_asm_h:         ; @define_private_field_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	str	x20, [x23, #48]
	mov	x2, x22
	mov	x3, x21
	bl	_JS_DefinePrivateField_GC
	tbnz	w0, #31, LBB105_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB105_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_array_el_0_asm_h
l_get_array_el_0_asm_h:                 ; @get_array_el_0_asm_h
; %bb.0:                                ; %B76
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB106_12
; %bb.1:                                ; %B73
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	LBB106_5
; %bb.2:                                ; %B1
	cmp	w8, #2
	b.ne	LBB106_10
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB106_14
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB106_5:                               ; %B33
	cmp	w8, #1
	b.ne	LBB106_12
; %bb.6:                                ; %B36
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB106_12
; %bb.7:                                ; %B36
	mov	x9, #2                          ; =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB106_12
; %bb.8:                                ; %B65
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB106_24
; %bb.9:                                ; %B68
	ldr	w8, [x1, #8]
	b	LBB106_25
LBB106_10:                              ; %B30
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB106_12
; %bb.11:                               ; %B30
	cmp	w8, #29
	b.le	LBB106_33
LBB106_12:                              ; %B70
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB106_34
; %bb.13:                               ; %B72
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB106_14:                              ; %B7
	tbnz	w21, #31, LBB106_12
; %bb.15:                               ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB106_16:                              ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB106_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB106_19
LBB106_17:                              ; %B10
                                        ;   Parent Loop BB106_16 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB106_21
; %bb.18:                               ; %B17
                                        ;   in Loop: Header=BB106_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB106_17
LBB106_19:                              ; %B24
                                        ;   in Loop: Header=BB106_16 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB106_12
; %bb.20:                               ; %B21
                                        ;   in Loop: Header=BB106_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB106_16
	b	LBB106_23
LBB106_21:                              ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB106_12
; %bb.22:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB106_23:                              ; %B51
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB106_24:                              ; %B66
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
LBB106_25:                              ; %B62
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	LBB106_12
; %bb.26:                               ; %B41
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	cbz	w0, LBB106_12
; %bb.27:                               ; %B44.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB106_28:                              ; %B44
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB106_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB106_31
LBB106_29:                              ; %B47
                                        ;   Parent Loop BB106_28 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	LBB106_35
; %bb.30:                               ; %B53
                                        ;   in Loop: Header=BB106_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB106_29
LBB106_31:                              ; %B58
                                        ;   in Loop: Header=BB106_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB106_12
; %bb.32:                               ; %B55
                                        ;   in Loop: Header=BB106_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB106_28
	b	LBB106_23
LBB106_33:                              ; %B31
	mov	x0, xzr
	b	l_FastTypedArrayGet_asm_h
LBB106_34:                              ; %B71
	b	l_exception_asm_h
LBB106_35:                              ; %B49
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB106_12
; %bb.36:                               ; %B50
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_array_el2_0_asm_h
l_get_array_el2_0_asm_h:                ; @get_array_el2_0_asm_h
; %bb.0:                                ; %B76
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB107_12
; %bb.1:                                ; %B73
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	LBB107_5
; %bb.2:                                ; %B1
	cmp	w8, #2
	b.ne	LBB107_10
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB107_14
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #16
	add	w8, w8, #486
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB107_5:                               ; %B33
	cmp	w8, #1
	b.ne	LBB107_12
; %bb.6:                                ; %B36
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB107_12
; %bb.7:                                ; %B36
	mov	x9, #2                          ; =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB107_12
; %bb.8:                                ; %B65
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB107_24
; %bb.9:                                ; %B68
	ldr	w8, [x1, #8]
	b	LBB107_25
LBB107_10:                              ; %B30
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB107_12
; %bb.11:                               ; %B30
	cmp	w8, #29
	b.le	LBB107_33
LBB107_12:                              ; %B70
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB107_34
; %bb.13:                               ; %B72
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB107_14:                              ; %B7
	tbnz	w21, #31, LBB107_12
; %bb.15:                               ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB107_16:                              ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB107_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB107_19
LBB107_17:                              ; %B10
                                        ;   Parent Loop BB107_16 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB107_21
; %bb.18:                               ; %B17
                                        ;   in Loop: Header=BB107_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB107_17
LBB107_19:                              ; %B24
                                        ;   in Loop: Header=BB107_16 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB107_12
; %bb.20:                               ; %B21
                                        ;   in Loop: Header=BB107_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB107_16
	b	LBB107_23
LBB107_21:                              ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB107_12
; %bb.22:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB107_23:                              ; %B51
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB107_24:                              ; %B66
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
LBB107_25:                              ; %B62
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	LBB107_12
; %bb.26:                               ; %B41
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	cbz	w0, LBB107_12
; %bb.27:                               ; %B44.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB107_28:                              ; %B44
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB107_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB107_31
LBB107_29:                              ; %B47
                                        ;   Parent Loop BB107_28 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	LBB107_35
; %bb.30:                               ; %B53
                                        ;   in Loop: Header=BB107_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB107_29
LBB107_31:                              ; %B58
                                        ;   in Loop: Header=BB107_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB107_12
; %bb.32:                               ; %B55
                                        ;   in Loop: Header=BB107_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB107_28
	b	LBB107_23
LBB107_33:                              ; %B31
	mov	w0, #1                          ; =0x1
	b	l_FastTypedArrayGet_asm_h
LBB107_34:                              ; %B71
	b	l_exception_asm_h
LBB107_35:                              ; %B49
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB107_12
; %bb.36:                               ; %B50
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_array_el_0_asm_h
l_put_array_el_0_asm_h:                 ; @put_array_el_0_asm_h
; %bb.0:                                ; %B116
	sub	sp, sp, #16
	ldp	x11, x22, [x20, #-24]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	ldur	x21, [x20, #-8]
	tst	x11, x8
	b.ne	LBB108_45
; %bb.1:                                ; %B1
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x11, #6]
	cmp	x9, x22, lsr #48
	b.ne	LBB108_7
; %bb.2:                                ; %B3
	cmp	w8, #2
	b.ne	LBB108_12
; %bb.3:                                ; %B5
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB108_45
; %bb.4:                                ; %B50
	ldr	w8, [x11, #48]
	cmp	w22, w8
	b.hs	LBB108_15
; %bb.5:                                ; %B7
	ldr	x8, [x11, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB108_24
; %bb.6:                                ; %B9
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB108_7:                               ; %B59
	cmp	w8, #1
	b.ne	LBB108_45
; %bb.8:                                ; %B107
	ldr	w8, [x11, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB108_45
; %bb.9:                                ; %B107
	mov	x9, #2                          ; =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB108_45
; %bb.10:                               ; %B62
	and	x1, x22, #0xfffffffffffc
	stp	x11, x20, [sp]                  ; 16-byte Folded Spill
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB108_25
; %bb.11:                               ; %B106
	ldr	w8, [x1, #8]
	b	LBB108_26
LBB108_12:                              ; %B55
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB108_45
; %bb.13:                               ; %B55
	cmp	w8, #29
	b.gt	LBB108_45
; %bb.14:                               ; %B56
	add	sp, sp, #16
	b	l_FastTypedArraySet_asm_h
LBB108_15:                              ; %B12
	mov	x1, x11
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	b.ne	LBB108_37
; %bb.16:                               ; %B40
	ldr	w9, [x1, #4]
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x11, x1
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	b.ne	LBB108_45
; %bb.17:                               ; %B40
	ubfx	w9, w9, #8, #1
	cbz	w9, LBB108_45
; %bb.18:                               ; %B14
	ldr	x9, [x11, #8]
	ldr	x9, [x9, #32]
	cbz	x9, LBB108_20
; %bb.19:                               ; %B36
	ldr	w9, [x9, #4]
	ubfx	w9, w9, #13, #1
	cmp	w9, #1
	b.ne	LBB108_45
LBB108_20:                              ; %B32
	ldr	x9, [x11, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	LBB108_22
; %bb.21:                               ; %B32
	cmp	w9, w10
	b.hi	LBB108_39
LBB108_22:                              ; %B29
	ldr	w10, [x1, #32]
	cmp	w9, w10
	b.hi	LBB108_39
; %bb.23:                               ; %B25
	ldr	x10, [x1, #40]
	str	w9, [x1, #48]
	str	x21, [x10, w8, sxtw #3]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB108_46
	b	LBB108_42
LBB108_24:                              ; %B11
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB108_25:                              ; %B63
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
LBB108_26:                              ; %B102
	asr	w8, w8, #30
	ldp	x11, x20, [sp]                  ; 16-byte Folded Reload
	cmp	w8, #1
	b.ne	LBB108_45
; %bb.27:                               ; %B64
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	ldp	x11, x20, [sp]                  ; 16-byte Folded Reload
	cbz	w0, LBB108_45
; %bb.28:                               ; %B66
	ldr	x8, [x11, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w0, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB108_31
LBB108_29:                              ; %B69
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	LBB108_40
; %bb.30:                               ; %B78
                                        ;   in Loop: Header=BB108_29 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB108_29
LBB108_31:                              ; %B80.preheader
	ldp	x8, x20, [sp]                   ; 16-byte Folded Reload
LBB108_32:                              ; %B80
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB108_33 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w0, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB108_35
LBB108_33:                              ; %B93
                                        ;   Parent Loop BB108_32 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	LBB108_43
; %bb.34:                               ; %B98
                                        ;   in Loop: Header=BB108_33 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB108_33
LBB108_35:                              ; %B81
                                        ;   in Loop: Header=BB108_32 Depth=1
	ldr	w9, [x8, #4]
	ldr	x11, [sp]                       ; 8-byte Folded Reload
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB108_45
; %bb.36:                               ; %B87
                                        ;   in Loop: Header=BB108_32 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB108_32
	b	LBB108_44
LBB108_37:                              ; %B44
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x11, x1
	tbnz	w22, #31, LBB108_45
; %bb.38:                               ; %B46
	mov	x0, x24
	mov	x1, x11
	mov	w2, w22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x20, [x23, #48]
	bl	_JS_SetArrayIntPropertyValue_GC
	tbz	w0, #31, LBB108_46
	b	LBB108_48
LBB108_39:                              ; %B20
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, x24
	mov	x2, x21
	mov	w3, #32768                      ; =0x8000
	str	x8, [x23, #48]
	bl	_add_fast_array_element_gc
	tbz	w0, #31, LBB108_46
	b	LBB108_48
LBB108_40:                              ; %B71
	mov	w9, #58                         ; =0x3a
	ldp	x11, x20, [sp]                  ; 16-byte Folded Reload
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	LBB108_45
; %bb.41:                               ; %B74
	ldr	x9, [x11, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB108_46
LBB108_42:                              ; %B76
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #16
	br	x1
LBB108_43:                              ; %B95
	mov	w8, #58                         ; =0x3a
	ldp	x11, x20, [sp]                  ; 16-byte Folded Reload
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	LBB108_45
LBB108_44:                              ; %B84
	ldr	w8, [x11, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.eq	LBB108_47
LBB108_45:                              ; %B113
	mov	x0, x24
	mov	x1, x11
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	str	x20, [x23, #48]
	bl	_JS_SetPropertyValue_GC
	tbnz	w0, #31, LBB108_48
LBB108_46:                              ; %B73
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #16
	br	x1
LBB108_47:                              ; %B85
	mov	w0, w0
	add	sp, sp, #16
	b	l_FastAddNamedProperty_asm_h
LBB108_48:                              ; %B47
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_super_value_0_asm_h
l_get_super_value_0_asm_h:              ; @get_super_value_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x21
	bl	_js_value_to_atom_gc
	cbz	w0, LBB109_3
; %bb.1:                                ; %B5
	ldur	x3, [x20, #-24]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB109_3
; %bb.2:                                ; %B7
	stur	x0, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB109_3:                               ; %B6
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_super_value_0_asm_h
l_put_super_value_0_asm_h:              ; @put_super_value_0_asm_h
; %bb.0:                                ; %B8
	sub	sp, sp, #16
	ldur	x9, [x20, #-24]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x9, x8
	b.eq	LBB110_3
; %bb.1:                                ; %B10
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ThrowTypeErrorNotAnObject
LBB110_2:                               ; %B6
	add	sp, sp, #16
	b	l_exception_asm_h
LBB110_3:                               ; %B1
	ldur	x1, [x20, #-16]
	mov	x0, x24
	str	x9, [sp, #8]                    ; 8-byte Folded Spill
	str	x20, [x23, #48]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB110_2
; %bb.4:                                ; %B5
	ldur	x3, [x20, #-8]
	ldur	x4, [x20, #-32]
	mov	w2, w0
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, x24
	mov	w5, #32768                      ; =0x8000
	str	x20, [x23, #48]
	bl	_JS_SetPropertyGeneric_GC
	tbnz	w0, #31, LBB110_2
; %bb.5:                                ; %B7
	ldrb	w8, [x19], #1
	sub	x20, x20, #32
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_field_0_asm_h
l_define_field_0_asm_h:                 ; @define_field_0_asm_h
; %bb.0:                                ; %B32
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	ldr	w2, [x19]
	tst	x22, x8
	b.ne	LBB111_4
; %bb.1:                                ; %B29
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	LBB111_4
; %bb.2:                                ; %B23
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB111_4
; %bb.3:                                ; %B26
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.eq	LBB111_6
LBB111_4:                               ; %B20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #16391                      ; =0x4007
	str	x20, [x23, #48]
                                        ; kill: def $w2 killed $w2 killed $x2
	bl	_JS_DefinePropertyValue_GC
	tbnz	w0, #31, LBB111_11
LBB111_5:                               ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB111_6:                               ; %B27
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB111_9
LBB111_7:                               ; %B12
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB111_12
; %bb.8:                                ; %B14
                                        ;   in Loop: Header=BB111_7 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB111_7
LBB111_9:                               ; %B17
	tbnz	w2, #31, LBB111_4
; %bb.10:                               ; %B19
	mov	x0, x2
	b	l_FastAddNamedProperty_asm_h
LBB111_11:                              ; %B21
	b	l_exception_asm_h
LBB111_12:                              ; %B1
	lsr	w9, w10, #26
	and	w9, w9, #0xfffffff7
	cmp	w9, #7
	b.ne	LBB111_4
; %bb.13:                               ; %B5
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB111_5
; %bb.14:                               ; %B7
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_name_0_asm_h
l_set_name_0_asm_h:                     ; @set_name_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	mov	x1, x22
	bl	_JS_DefineObjectName
	tbnz	w0, #31, LBB112_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB112_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_name_computed_0_asm_h
l_set_name_computed_0_asm_h:            ; @set_name_computed_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	mov	x1, x21
	mov	x2, x22
	bl	_JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, LBB113_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB113_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_proto_0_asm_h
l_set_proto_0_asm_h:                    ; @set_proto_0_asm_h
; %bb.0:                                ; %B6
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	LBB114_3
; %bb.1:                                ; %B6
	cmp	x21, #2
	b.eq	LBB114_3
LBB114_2:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB114_3:                               ; %B1
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	_JS_SetPrototypeInternal_GC
	tbz	w0, #31, LBB114_2
; %bb.4:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_home_object_0_asm_h
l_set_home_object_0_asm_h:              ; @set_home_object_0_asm_h
; %bb.0:                                ; %B0
	sub	sp, sp, #16
	mov	x8, x20
	ldur	x21, [x20, #-8]
	mov	x0, x24
	ldr	x22, [x8, #-16]!
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	mov	x1, x21
	str	x20, [x23, #48]
	mov	x2, x22
	bl	_js_method_set_home_object_gc
	ldrb	w8, [x19], #1
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_array_el_0_asm_h
l_define_array_el_0_asm_h:              ; @define_array_el_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	mov	w4, #16391                      ; =0x4007
	str	x20, [x23, #48]
	mov	x2, x22
	mov	x3, x21
	bl	_JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, LBB116_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB116_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function append_0_asm_h
l_append_0_asm_h:                       ; @append_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_js_append_enumerate_gc
	tbnz	w0, #31, LBB117_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB117_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function copy_data_properties_0_asm_h
l_copy_data_properties_0_asm_h:         ; @copy_data_properties_0_asm_h
; %bb.0:                                ; %B1
	ldrb	w2, [x19]
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_prim_js_copy_data_properties_gc
	tbnz	w0, #31, LBB118_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB118_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_method_0_asm_h
l_define_method_0_asm_h:                ; @define_method_0_asm_h
; %bb.0:                                ; %B15
	sub	sp, sp, #64
	ldrb	w8, [x19, #4]
	mov	w9, #17665                      ; =0x4501
	mov	w10, #17669                     ; =0x4505
	mov	x11, x19
	ldr	w19, [x19]
	tst	w8, #0x4
	str	x11, [sp, #48]                  ; 8-byte Folded Spill
	csel	w10, w10, w9, ne
	ldp	x9, x12, [x20, #-16]
	ands	w8, w8, #0x3
	b.eq	LBB119_3
; %bb.1:                                ; %B15
	cmp	w8, #1
	b.ne	LBB119_4
; %bb.2:                                ; %B13
	mov	w8, #18                         ; =0x12
	mov	w11, #2048                      ; =0x800
	stp	x12, x8, [sp, #16]              ; 16-byte Folded Spill
	b	LBB119_5
LBB119_3:
	mov	w8, #18                         ; =0x12
	str	x12, [sp, #40]                  ; 8-byte Folded Spill
	mov	w11, #8706                      ; =0x2202
	str	x8, [sp, #24]                   ; 8-byte Folded Spill
	mov	w8, #18                         ; =0x12
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	b	LBB119_6
LBB119_4:                               ; %B14
	mov	w11, #4096                      ; =0x1000
	mov	w8, #18                         ; =0x12
	stp	x8, x12, [sp, #16]              ; 16-byte Folded Spill
LBB119_5:                               ; %B10
	mov	w8, #18                         ; =0x12
	str	x8, [sp, #40]                   ; 8-byte Folded Spill
LBB119_6:                               ; %B10
	ldur	x1, [x20, #-8]
	orr	w3, w10, w11
	mov	x0, x24
	mov	w2, w19
	mov	x4, x9
	str	x20, [x23, #48]
	str	w11, [sp, #36]                  ; 4-byte Folded Spill
	str	x20, [sp, #56]                  ; 8-byte Folded Spill
	mov	w20, w19
	mov	x19, x9
	str	w10, [sp, #12]                  ; 4-byte Folded Spill
	bl	_js_method_set_properties_gc
	tbnz	w0, #31, LBB119_9
; %bb.7:                                ; %B5
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	ldr	w9, [sp, #12]                   ; 4-byte Folded Reload
	mov	x0, x24
	ldp	x4, x5, [sp, #16]               ; 16-byte Folded Reload
	mov	x1, x19
	str	x8, [x23, #48]
	ldr	w8, [sp, #36]                   ; 4-byte Folded Reload
	mov	w2, w20
	ldr	x3, [sp, #40]                   ; 8-byte Folded Reload
	orr	w6, w9, w8
	bl	_JS_DefineProperty_GC
	tbnz	w0, #31, LBB119_9
; %bb.8:                                ; %B7
	ldr	x9, [sp, #48]                   ; 8-byte Folded Reload
	ldrb	w8, [x9, #5]
	add	x19, x9, #6
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #64
	br	x1
LBB119_9:                               ; %B2
	ldp	x19, x20, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #64
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_method_computed_0_asm_h
l_define_method_computed_0_asm_h:       ; @define_method_computed_0_asm_h
; %bb.0:                                ; %B8
	sub	sp, sp, #64
	ldur	x1, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_js_value_to_atom_gc
	mov	w11, w0
	cbz	w11, LBB120_11
; %bb.1:                                ; %B11
	ldrb	w8, [x19]
	mov	w9, #17665                      ; =0x4501
	mov	w10, #17669                     ; =0x4505
	ldur	x12, [x20, #-24]
	str	x19, [sp, #48]                  ; 8-byte Folded Spill
	tst	w8, #0x4
	csel	w9, w10, w9, ne
	ldur	x10, [x20, #-8]
	ands	w8, w8, #0x3
	b.eq	LBB120_4
; %bb.2:                                ; %B11
	cmp	w8, #1
	b.ne	LBB120_5
; %bb.3:                                ; %B19
	mov	w8, #18                         ; =0x12
	mov	w13, #2048                      ; =0x800
	stp	x10, x8, [sp, #16]              ; 16-byte Folded Spill
	b	LBB120_6
LBB120_4:
	mov	w8, #18                         ; =0x12
	str	x10, [sp, #40]                  ; 8-byte Folded Spill
	mov	w13, #8706                      ; =0x2202
	str	x8, [sp, #24]                   ; 8-byte Folded Spill
	mov	w8, #18                         ; =0x12
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	b	LBB120_7
LBB120_5:                               ; %B20
	mov	w13, #4096                      ; =0x1000
	mov	w8, #18                         ; =0x12
	stp	x8, x10, [sp, #16]              ; 16-byte Folded Spill
LBB120_6:                               ; %B16
	mov	w8, #18                         ; =0x12
	str	x8, [sp, #40]                   ; 8-byte Folded Spill
LBB120_7:                               ; %B16
	ldur	x1, [x20, #-8]
	orr	w3, w9, w13
	mov	x0, x24
	mov	w2, w11
	mov	x4, x12
	str	x20, [x23, #48]
	str	w13, [sp, #36]                  ; 4-byte Folded Spill
	mov	x19, x12
	str	x20, [sp, #56]                  ; 8-byte Folded Spill
	mov	w20, w11
	str	w9, [sp, #12]                   ; 4-byte Folded Spill
	bl	_js_method_set_properties_gc
	tbnz	w0, #31, LBB120_10
; %bb.8:                                ; %B5
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	ldr	w9, [sp, #12]                   ; 4-byte Folded Reload
	mov	x0, x24
	ldp	x4, x5, [sp, #16]               ; 16-byte Folded Reload
	mov	x1, x19
	str	x8, [x23, #48]
	ldr	w8, [sp, #36]                   ; 4-byte Folded Reload
	mov	w2, w20
	ldr	x3, [sp, #40]                   ; 8-byte Folded Reload
	orr	w6, w9, w8
	bl	_JS_DefineProperty_GC
	tbnz	w0, #31, LBB120_10
; %bb.9:                                ; %B7
	ldr	x9, [sp, #48]                   ; 8-byte Folded Reload
	ldrb	w8, [x9, #1]
	add	x19, x9, #2
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #64
	br	x1
LBB120_10:                              ; %B2
	ldp	x19, x20, [sp, #48]             ; 16-byte Folded Reload
LBB120_11:                              ; %B9
	add	sp, sp, #64
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_class_0_asm_h
l_define_class_0_asm_h:                 ; @define_class_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #4]
	mov	x0, x24
	mov	x1, x20
	mov	x4, x26
	mov	x5, x23
	str	x20, [x23, #48]
	bl	_js_op_define_class
	tbnz	w0, #31, LBB121_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB121_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc_0_asm_h
l_get_loc_0_asm_h:                      ; @get_loc_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #243
	ldr	x22, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc_0_asm_h
l_put_loc_0_asm_h:                      ; @put_loc_0_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc_0_asm_h
l_set_loc_0_asm_h:                      ; @set_loc_0_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_arg_0_asm_h
l_get_arg_0_asm_h:                      ; @get_arg_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #243
	ldr	x22, [x28, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_arg_0_asm_h
l_put_arg_0_asm_h:                      ; @put_arg_0_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_arg_0_asm_h
l_set_arg_0_asm_h:                      ; @set_arg_0_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref_0_asm_h
l_get_var_ref_0_asm_h:                  ; @get_var_ref_0_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x8, [x26, x8, lsl #3]
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8]
	ldr	x22, [x8]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref_0_asm_h
l_put_var_ref_0_asm_h:                  ; @put_var_ref_0_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_var_ref_0_asm_h
l_set_var_ref_0_asm_h:                  ; @set_var_ref_0_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc_uninitialized_0_asm_h
l_set_loc_uninitialized_0_asm_h:        ; @set_loc_uninitialized_0_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	mov	w9, #34                         ; =0x22
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc_check_0_asm_h
l_get_loc_check_0_asm_h:                ; @get_loc_check_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	LBB132_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB132_2:                               ; %B3
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc_check_0_asm_h
l_put_loc_check_0_asm_h:                ; @put_loc_check_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	LBB133_2
; %bb.1:                                ; %B4
	str	x22, [x27, w8, uxtw #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB133_2:                               ; %B3
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc_check_init_0_asm_h
l_put_loc_check_init_0_asm_h:           ; @put_loc_check_init_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	LBB134_2
; %bb.1:                                ; %B4
	str	x22, [x27, w8, uxtw #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB134_2:                               ; %B3
	b	l_ThrowThisReferenceError_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref_check_0_asm_h
l_get_var_ref_check_0_asm_h:            ; @get_var_ref_check_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	LBB135_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB135_2:                               ; %B3
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref_check_0_asm_h
l_put_var_ref_check_0_asm_h:            ; @put_var_ref_check_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	LBB136_2
; %bb.1:                                ; %B4
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB136_2:                               ; %B3
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref_check_init_0_asm_h
l_put_var_ref_check_init_0_asm_h:       ; @put_var_ref_check_init_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	LBB137_2
; %bb.1:                                ; %B4
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB137_2:                               ; %B3
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function close_loc_0_asm_h
l_close_loc_0_asm_h:                    ; @close_loc_0_asm_h
; %bb.0:                                ; %B0
	ldrh	w2, [x19]
	mov	x0, x24
	mov	x1, x23
	bl	_close_lexical_var
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_false_0_asm_h
l_if_false_0_asm_h:                     ; @if_false_0_asm_h
; %bb.0:                                ; %B29
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	LBB139_4
; %bb.1:                                ; %B29
	cmp	x22, #6
	b.eq	LBB139_6
; %bb.2:                                ; %B29
	cmp	x22, #7
	b.eq	LBB139_10
; %bb.3:                                ; %B29
	cmp	x22, #18
	b.eq	LBB139_6
	b	LBB139_8
LBB139_4:                               ; %B29
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.eq	LBB139_6
; %bb.5:                                ; %B29
	cmp	x22, #2
	b.ne	LBB139_8
LBB139_6:                               ; %B8
	ldrsw	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB139_11
LBB139_7:                               ; %B10
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB139_8:                               ; %B15
	mov	x9, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x9
	b.hs	LBB139_16
; %bb.9:                                ; %B17
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.lo	LBB139_13
LBB139_10:                              ; %B25
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB139_11:                              ; %B5
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB139_7
; %bb.12:                               ; %B6
	add	x19, x19, #1
	b	l_PollInterrupts_asm_h
LBB139_13:                              ; %B19
	tst	x22, #0xfffe000000000000
	b.eq	LBB139_16
; %bb.14:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB139_6
	b.vs	LBB139_6
; %bb.15:                               ; %B23
	tbnz	w8, #0, LBB139_10
	b	LBB139_6
LBB139_16:                              ; %B21
	mov	x20, x8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_true_0_asm_h
l_if_true_0_asm_h:                      ; @if_true_0_asm_h
; %bb.0:                                ; %B29
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	LBB140_4
; %bb.1:                                ; %B29
	cmp	x22, #6
	b.eq	LBB140_6
; %bb.2:                                ; %B29
	cmp	x22, #7
	b.eq	LBB140_9
; %bb.3:                                ; %B29
	cmp	x22, #18
	b.eq	LBB140_6
	b	LBB140_7
LBB140_4:                               ; %B29
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.eq	LBB140_6
; %bb.5:                                ; %B29
	cmp	x22, #2
	b.ne	LBB140_7
LBB140_6:                               ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB140_7:                               ; %B9
	mov	x9, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x9
	b.hs	LBB140_16
; %bb.8:                                ; %B11
	mov	x9, #-562949953421313           ; =0xfffdffffffffffff
	cmp	x22, x9
	b.ls	LBB140_13
LBB140_9:                               ; %B23
	ldrsw	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB140_11
LBB140_10:                              ; %B25
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB140_11:                              ; %B20
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB140_10
; %bb.12:                               ; %B21
	add	x19, x19, #1
	b	l_PollInterrupts_asm_h
LBB140_13:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB140_16
; %bb.14:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB140_6
	b.vs	LBB140_6
; %bb.15:                               ; %B17
	tbnz	w8, #0, LBB140_9
	b	LBB140_6
LBB140_16:                              ; %B15
	mov	x20, x8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto_0_asm_h
l_goto_0_asm_h:                         ; @goto_0_asm_h
; %bb.0:                                ; %B5
	ldrsw	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB141_2
LBB141_1:                               ; %B7
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB141_2:                               ; %B2
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB141_1
; %bb.3:                                ; %B3
	add	x19, x19, #1
	b	l_PollInterrupts_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function catch_0_asm_h
l_catch_0_asm_h:                        ; @catch_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #4]
	ldr	w10, [x19]
	ldr	x8, [x8, #32]
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	mov	w9, #66                         ; =0x42
	ldr	x8, [x8, #8]
	sub	x8, x19, x8
	add	x19, x19, #5
	add	x8, x8, x10
	orr	x22, x9, x8, lsl #16
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function gosub_0_asm_h
l_gosub_0_asm_h:                        ; @gosub_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x23, #8]
	ldrsw	x9, [x19]
	ldr	x10, [x8, #32]
	add	x8, x19, x9
	ldrb	w9, [x8], #1
	ldr	w10, [x10, #8]
	add	w9, w9, #243
	sub	w10, w19, w10
	ldr	x1, [x25, w9, uxtw #3]
	mov	x19, x8
	add	w9, w10, #4
	orr	x22, x9, #0xfffe000000000000
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function ret_0_asm_h
l_ret_0_asm_h:                          ; @ret_0_asm_h
; %bb.0:                                ; %B6
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB144_3
; %bb.1:                                ; %B1
	ldr	x8, [x23, #8]
	ldr	x8, [x8, #32]
	ldr	w9, [x8, #16]
	cmp	w22, w9
	b.ge	LBB144_3
; %bb.2:                                ; %B5
	ldr	x8, [x8, #8]
	sub	x20, x20, #8
	add	x19, x8, w22, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB144_3:                               ; %B3
Lloh14:
	adrp	x1, l___unnamed_8@PAGE
Lloh15:
	add	x1, x1, l___unnamed_8@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_ThrowInternalError
	b	l_exception_asm_h
	.loh AdrpAdd	Lloh14, Lloh15
                                        ; -- End function
	.p2align	2                               ; -- Begin function to_object_0_asm_h
l_to_object_0_asm_h:                    ; @to_object_0_asm_h
; %bb.0:                                ; %B6
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB145_2
; %bb.1:                                ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB145_2:                               ; %B1
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #48]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB145_4
; %bb.3:                                ; %B3
	mov	x22, x0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB145_4:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function to_propkey_0_asm_h
l_to_propkey_0_asm_h:                   ; @to_propkey_0_asm_h
; %bb.0:                                ; %B15
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	LBB146_4
; %bb.1:                                ; %B15
	mov	x9, #1                          ; =0x1
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB146_4
; %bb.2:                                ; %B15
	cmp	x8, x9
	b.eq	LBB146_4
; %bb.3:                                ; %B15
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB146_5
LBB146_4:                               ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB146_5:                               ; %B12
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB146_7
; %bb.6:                                ; %B14
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB146_7:                               ; %B13
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function to_propkey2_0_asm_h
l_to_propkey2_0_asm_h:                  ; @to_propkey2_0_asm_h
; %bb.0:                                ; %B18
	ldp	x22, x21, [x20, #-16]
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	LBB147_3
; %bb.1:                                ; %B19
Lloh16:
	adrp	x1, l___unnamed_9@PAGE
Lloh17:
	add	x1, x1, l___unnamed_9@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_ThrowTypeError
LBB147_2:                               ; %B16
	b	l_exception_asm_h
LBB147_3:                               ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	LBB147_7
; %bb.4:                                ; %B2
	mov	x9, #1                          ; =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB147_7
; %bb.5:                                ; %B2
	cmp	x8, x9
	b.eq	LBB147_7
; %bb.6:                                ; %B2
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB147_8
LBB147_7:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB147_8:                               ; %B15
	mov	x0, x24
	mov	x1, x21
	str	x20, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB147_2
; %bb.9:                                ; %B17
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh16, Lloh17
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_get_var_0_asm_h
l_with_get_var_0_asm_h:                 ; @with_get_var_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #113                        ; =0x71
	str	x20, [x23, #48]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB148_4
; %bb.1:                                ; %B4
	cbz	w0, LBB148_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB148_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB148_4:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_put_var_0_asm_h
l_with_put_var_0_asm_h:                 ; @with_put_var_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #114                        ; =0x72
	str	x20, [x23, #48]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB149_4
; %bb.1:                                ; %B4
	cbz	w0, LBB149_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	sub	x20, x20, #16
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB149_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB149_4:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_delete_var_0_asm_h
l_with_delete_var_0_asm_h:              ; @with_delete_var_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #115                        ; =0x73
	str	x20, [x23, #48]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB150_4
; %bb.1:                                ; %B4
	cbz	w0, LBB150_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB150_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB150_4:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_make_ref_0_asm_h
l_with_make_ref_0_asm_h:                ; @with_make_ref_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #116                        ; =0x74
	str	x20, [x23, #48]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB151_4
; %bb.1:                                ; %B4
	cbz	w0, LBB151_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB151_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB151_4:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_get_ref_0_asm_h
l_with_get_ref_0_asm_h:                 ; @with_get_ref_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #117                        ; =0x75
	str	x20, [x23, #48]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB152_4
; %bb.1:                                ; %B4
	cbz	w0, LBB152_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB152_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB152_4:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_get_ref_undef_0_asm_h
l_with_get_ref_undef_0_asm_h:           ; @with_get_ref_undef_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #118                        ; =0x76
	str	x20, [x23, #48]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB153_4
; %bb.1:                                ; %B4
	cbz	w0, LBB153_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB153_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB153_4:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function make_loc_ref_0_asm_h
l_make_loc_ref_0_asm_h:                 ; @make_loc_ref_0_asm_h
; %bb.0:                                ; %B16
	sub	sp, sp, #16
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	LBB154_6
; %bb.1:                                ; %B1
	mov	w8, #18                         ; =0x12
	mov	x1, x23
	mov	w3, wzr
	stp	x0, x8, [x20], #16
	mov	x0, x24
	ldrh	w2, [x19, #4]
	str	x20, [x23, #48]
	bl	_get_var_ref_gc
	mov	x8, x0
	cbz	x8, LBB154_6
; %bb.2:                                ; %B6
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #34                         ; =0x22
	str	x20, [x23, #48]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	bl	_add_property_gc
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	cbz	x0, LBB154_6
; %bb.3:                                ; %B9
	mov	x8, #2                          ; =0x2
	movk	x8, #65533, lsl #48
	orr	x8, x9, x8
	str	x8, [x0]
	ldrb	w9, [x24, #384]
	cbnz	w9, LBB154_7
LBB154_4:                               ; %B13
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB154_6
; %bb.5:                                ; %B15
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB154_6:                               ; %B14
	add	sp, sp, #16
	b	l_exception_asm_h
LBB154_7:                               ; %B12
	mov	x0, x8
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB154_4
                                        ; -- End function
	.p2align	2                               ; -- Begin function make_arg_ref_0_asm_h
l_make_arg_ref_0_asm_h:                 ; @make_arg_ref_0_asm_h
; %bb.0:                                ; %B16
	sub	sp, sp, #16
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	LBB155_6
; %bb.1:                                ; %B1
	mov	w8, #18                         ; =0x12
	mov	x1, x23
	mov	w3, #1                          ; =0x1
	stp	x0, x8, [x20], #16
	mov	x0, x24
	ldrh	w2, [x19, #4]
	str	x20, [x23, #48]
	bl	_get_var_ref_gc
	mov	x8, x0
	cbz	x8, LBB155_6
; %bb.2:                                ; %B6
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #34                         ; =0x22
	str	x20, [x23, #48]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	bl	_add_property_gc
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	cbz	x0, LBB155_6
; %bb.3:                                ; %B9
	mov	x8, #2                          ; =0x2
	movk	x8, #65533, lsl #48
	orr	x8, x9, x8
	str	x8, [x0]
	ldrb	w9, [x24, #384]
	cbnz	w9, LBB155_7
LBB155_4:                               ; %B13
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB155_6
; %bb.5:                                ; %B15
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB155_6:                               ; %B14
	add	sp, sp, #16
	b	l_exception_asm_h
LBB155_7:                               ; %B12
	mov	x0, x8
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB155_4
                                        ; -- End function
	.p2align	2                               ; -- Begin function make_var_ref_ref_0_asm_h
l_make_var_ref_ref_0_asm_h:             ; @make_var_ref_ref_0_asm_h
; %bb.0:                                ; %B12
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	LBB156_5
; %bb.1:                                ; %B1
	mov	x1, x0
	mov	w8, #18                         ; =0x12
	mov	x0, x24
	stp	x1, x8, [x20], #16
	mov	w3, #34                         ; =0x22
	ldr	w2, [x19]
	str	x20, [x23, #48]
	bl	_add_property_gc
	cbz	x0, LBB156_5
; %bb.2:                                ; %B4
	ldrh	w8, [x19, #4]
	mov	x9, #2                          ; =0x2
	movk	x9, #65533, lsl #48
	ldr	x8, [x26, x8, lsl #3]
	orr	x8, x8, x9
	str	x8, [x0]
	ldrb	w9, [x24, #384]
	cbnz	w9, LBB156_6
LBB156_3:                               ; %B9
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB156_5
; %bb.4:                                ; %B11
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB156_5:                               ; %B10
	b	l_exception_asm_h
LBB156_6:                               ; %B7
	mov	x0, x8
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB156_3
                                        ; -- End function
	.p2align	2                               ; -- Begin function make_var_ref_0_asm_h
l_make_var_ref_0_asm_h:                 ; @make_var_ref_0_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x20
	str	x20, [x23, #48]
	bl	_JS_GetGlobalVarRef_GC
	tbnz	w0, #31, LBB157_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB157_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_in_start_0_asm_h
l_for_in_start_0_asm_h:                 ; @for_in_start_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	bl	_prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	LBB158_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB158_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_of_start_0_asm_h
l_for_of_start_0_asm_h:                 ; @for_of_start_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	_js_for_of_start_gc
	tbnz	w0, #31, LBB159_2
; %bb.1:                                ; %B3
	mov	w8, #66                         ; =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB159_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_await_of_start_0_asm_h
l_for_await_of_start_0_asm_h:           ; @for_await_of_start_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	mov	w2, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	_js_for_of_start_gc
	tbnz	w0, #31, LBB160_2
; %bb.1:                                ; %B3
	mov	w8, #66                         ; =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB160_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_in_next_0_asm_h
l_for_in_next_0_asm_h:                  ; @for_in_next_0_asm_h
; %bb.0:                                ; %B65
	ldur	x8, [x20, #-8]
	mov	x11, #2                         ; =0x2
	movk	x11, #65535, lsl #48
	tst	x8, x11
	b.ne	LBB161_4
; %bb.1:                                ; %B62
	ldrh	w9, [x8, #6]
	cmp	w9, #17
	b.ne	LBB161_4
; %bb.2:                                ; %B1
	ldr	x8, [x8, #32]
	cbz	x8, LBB161_4
; %bb.3:                                ; %B9
	ldp	w9, w10, [x8, #8]
	cmp	w9, w10
	b.lo	LBB161_6
LBB161_4:                               ; %B4
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_js_for_in_next_gc
	tbnz	w0, #31, LBB161_27
; %bb.5:                                ; %B6
	ldrb	w8, [x19], #1
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB161_6:                               ; %B11
	ldr	x10, [x8]
	tst	x10, x11
	b.ne	LBB161_4
; %bb.7:                                ; %B13
	ldrb	w11, [x8, #17]
	cbnz	w11, LBB161_21
; %bb.8:                                ; %B37
	ldrb	w11, [x8, #16]
	cbnz	w11, LBB161_4
; %bb.9:                                ; %B40
	ldr	x11, [x8, #24]
	cbz	x11, LBB161_4
; %bb.10:                               ; %B57
	lsl	w12, w9, #3
	add	x11, x11, x12
	ldr	w12, [x11]
	cbz	w12, LBB161_15
; %bb.11:                               ; %B59
	ldr	x12, [x10, #8]
	ldr	w1, [x11, #4]
	ldr	w13, [x12, #12]
	add	x14, x12, #64
	lsl	w11, w13, #2
	and	w12, w1, w13
	ldr	w12, [x14, w12, sxtw #2]
	add	w11, w11, #4
	add	x11, x14, x11
	cbz	w12, LBB161_14
LBB161_12:                              ; %B52
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w12, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w1
	b.eq	LBB161_16
; %bb.13:                               ; %B54
                                        ;   in Loop: Header=BB161_12 Depth=1
	and	w12, w12, #0x3ffffff
	cbnz	w12, LBB161_12
LBB161_14:                              ; %B46
	ldr	w10, [x10, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB161_4
LBB161_15:                              ; %B49
	add	w9, w9, #1
	str	w9, [x8, #8]
	b	LBB161_4
LBB161_16:                              ; %B43
	lsr	w10, w12, #26
	tst	w10, #0x30
	b.ne	LBB161_4
; %bb.17:                               ; %B44
	add	w9, w9, #1
	str	w9, [x8, #8]
	tbnz	w1, #31, LBB161_25
LBB161_18:                              ; %B18
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, sxtw #3]
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, LBB161_24
; %bb.19:                               ; %B28
	ldr	w9, [x8, #8]
	asr	w9, w9, #30
	cmp	w9, #1
	b.ne	LBB161_25
LBB161_20:                              ; %B26
	mov	x9, #2                          ; =0x2
	movk	x9, #1, lsl #48
	orr	x8, x8, x9
	mov	w9, #6                          ; =0x6
	stp	x8, x9, [x20], #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB161_21:                              ; %B33
	ldr	w11, [x10, #4]
	ubfx	w11, w11, #11, #1
	cmp	w11, #1
	b.ne	LBB161_4
; %bb.22:                               ; %B15
	ldr	w10, [x10, #48]
	cmp	w9, w10
	b.hs	LBB161_4
; %bb.23:                               ; %B16
	add	w10, w9, #1
	orr	w1, w9, #0x80000000
	str	w10, [x8, #8]
	tbz	w1, #31, LBB161_18
	b	LBB161_25
LBB161_24:                              ; %B19
	ldr	x9, [x8, #8]
	ldr	w9, [x9]
	asr	w9, w9, #30
	cmp	w9, #1
	b.eq	LBB161_20
LBB161_25:                              ; %B23
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB161_27
; %bb.26:                               ; %B25
	mov	w8, #6                          ; =0x6
	stp	x0, x8, [x20], #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB161_27:                              ; %B5
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_of_next_0_asm_h
l_for_of_next_0_asm_h:                  ; @for_of_next_0_asm_h
; %bb.0:                                ; %B1
	ldrb	w9, [x19]
	mov	w8, #-3                         ; =0xfffffffd
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	sub	w2, w8, w9
	bl	_js_for_of_next_gc
	tbnz	w0, #31, LBB162_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB162_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_await_of_next_0_asm_h
l_for_await_of_next_0_asm_h:            ; @for_await_of_next_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_js_for_await_of_next_gc
	tbnz	w0, #31, LBB163_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB163_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function iterator_get_value_done_0_asm_h
l_iterator_get_value_done_0_asm_h:      ; @iterator_get_value_done_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_js_iterator_get_value_done_gc
	tbnz	w0, #31, LBB164_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB164_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function iterator_close_0_asm_h
l_iterator_close_0_asm_h:               ; @iterator_close_0_asm_h
; %bb.0:                                ; %B6
	ldur	x1, [x20, #-24]
	sub	x20, x20, #16
	cmp	x1, #18
	b.eq	LBB165_2
; %bb.1:                                ; %B1
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	_JS_IteratorClose
	tbnz	w0, #31, LBB165_3
LBB165_2:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB165_3:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function iterator_close_return_0_asm_h
l_iterator_close_return_0_asm_h:        ; @iterator_close_return_0_asm_h
; %bb.0:                                ; %B0
	ldr	x9, [x23, #8]
	ldr	x8, [x20, #-8]!
	mov	w10, #247                       ; =0xf7
	ldr	x9, [x9, #32]
	ldrh	w9, [x9, #42]
	add	x9, x27, x9, lsl #3
	b	LBB166_2
LBB166_1:                               ; %B10
                                        ;   in Loop: Header=BB166_2 Depth=1
	sub	x20, x20, #8
LBB166_2:                               ; %B2
                                        ; =>This Inner Loop Header: Depth=1
	cmp	x20, x9
	b.le	LBB166_5
; %bb.3:                                ; %B4
                                        ;   in Loop: Header=BB166_2 Depth=1
	ldur	x11, [x20, #-8]
	tst	x11, #0xffff000000000000
	b.ne	LBB166_1
; %bb.4:                                ; %B4
                                        ;   in Loop: Header=BB166_2 Depth=1
	and	x11, x11, x10
	cmp	x11, #66
	b.ne	LBB166_1
LBB166_5:                               ; %B7
	add	x9, x9, #24
	cmp	x20, x9
	add	x20, x20, #8
	b.lt	LBB166_7
; %bb.6:                                ; %B9
	ldur	x9, [x20, #-16]
	ldur	q0, [x20, #-32]
	stur	x8, [x20, #-32]
	stur	x9, [x20, #-8]
	stur	q0, [x20, #-24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB166_7:                               ; %B8
Lloh18:
	adrp	x1, l___unnamed_10@PAGE
Lloh19:
	add	x1, x1, l___unnamed_10@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_ThrowInternalError
	b	l_exception_asm_h
	.loh AdrpAdd	Lloh18, Lloh19
                                        ; -- End function
	.p2align	2                               ; -- Begin function async_iterator_close_0_asm_h
l_async_iterator_close_0_asm_h:         ; @async_iterator_close_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_prim_js_async_iterator_close_gc
	tbnz	w0, #31, LBB167_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB167_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function async_iterator_next_0_asm_h
l_async_iterator_next_0_asm_h:          ; @async_iterator_next_0_asm_h
; %bb.0:                                ; %B1
	ldp	x2, x1, [x20, #-32]
	sub	x4, x20, #8
	mov	x0, x24
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	_JS_Call_GC
	cmp	x0, #130
	b.eq	LBB168_2
; %bb.1:                                ; %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB168_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function async_iterator_get_0_asm_h
l_async_iterator_get_0_asm_h:           ; @async_iterator_get_0_asm_h
; %bb.0:                                ; %B1
	ldrb	w2, [x19]
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_prim_js_async_iterator_get_gc
	tbnz	w0, #31, LBB169_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB169_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function initial_yield_0_asm_h
l_initial_yield_0_asm_h:                ; @initial_yield_0_asm_h
; %bb.0:                                ; %B0
	str	x19, [x23, #32]
	mov	w0, #18                         ; =0x12
	str	x20, [x23, #48]
	b	l_common_return_direct_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function yield_0_asm_h
l_yield_0_asm_h:                        ; @yield_0_asm_h
; %bb.0:                                ; %B0
	str	x19, [x23, #32]
	mov	x0, #-562949953421311           ; =0xfffe000000000001
	str	x20, [x23, #48]
	b	l_common_return_direct_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function yield_star_0_asm_h
l_yield_star_0_asm_h:                   ; @yield_star_0_asm_h
; %bb.0:                                ; %B0
	mov	x0, #2                          ; =0x2
	str	x19, [x23, #32]
	str	x20, [x23, #48]
	movk	x0, #65534, lsl #48
	b	l_common_return_direct_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function async_yield_star_0_asm_h
l_async_yield_star_0_asm_h:             ; @async_yield_star_0_asm_h
; %bb.0:                                ; %B0
	mov	x0, #2                          ; =0x2
	str	x19, [x23, #32]
	str	x20, [x23, #48]
	movk	x0, #65534, lsl #48
	b	l_common_return_direct_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function await_0_asm_h
l_await_0_asm_h:                        ; @await_0_asm_h
; %bb.0:                                ; %B0
	str	x19, [x23, #32]
	mov	x0, #-562949953421312           ; =0xfffe000000000000
	str	x20, [x23, #48]
	b	l_common_return_direct_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function neg_0_asm_h
l_neg_0_asm_h:                          ; @neg_0_asm_h
; %bb.0:                                ; %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB175_3
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB175_6
; %bb.2:                                ; %B13
	orr	w8, w22, #0x80000000
	mov	w9, #-2147483648                ; =0x80000000
	cmp	w8, w9
	b.ne	LBB175_5
LBB175_3:                               ; %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        ; =0x8c
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB175_8
; %bb.4:                                ; %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB175_5:                               ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB175_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB175_3
; %bb.7:                                ; %B7
	movi	d0, #0000000000000000
	add	x8, x22, x8
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	fsub	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
LBB175_8:                               ; %B17
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function plus_0_asm_h
l_plus_0_asm_h:                         ; @plus_0_asm_h
; %bb.0:                                ; %B13
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB176_4
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB176_3
LBB176_2:                               ; %B7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB176_3:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.ne	LBB176_2
LBB176_4:                               ; %B10
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        ; =0x8d
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB176_6
; %bb.5:                                ; %B12
	mov	x22, x0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB176_6:                               ; %B11
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function dec_0_asm_h
l_dec_0_asm_h:                          ; @dec_0_asm_h
; %bb.0:                                ; %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB177_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB177_4
; %bb.2:                                ; %B13
	subs	w8, w22, #1
	b.vs	LBB177_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB177_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB177_6
; %bb.5:                                ; %B7
	add	x8, x22, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
LBB177_6:                               ; %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        ; =0x8e
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB177_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB177_8:                               ; %B17
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function inc_0_asm_h
l_inc_0_asm_h:                          ; @inc_0_asm_h
; %bb.0:                                ; %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB178_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB178_4
; %bb.2:                                ; %B13
	adds	w8, w22, #1
	b.vs	LBB178_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB178_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB178_6
; %bb.5:                                ; %B7
	add	x8, x22, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
LBB178_6:                               ; %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        ; =0x8f
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB178_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB178_8:                               ; %B17
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function post_dec_0_asm_h
l_post_dec_0_asm_h:                     ; @post_dec_0_asm_h
; %bb.0:                                ; %B16
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB179_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB179_4
; %bb.2:                                ; %B13
	subs	w8, w22, #1
	b.vs	LBB179_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB179_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB179_6
; %bb.5:                                ; %B8
	add	x8, x22, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #486
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
LBB179_6:                               ; %B5
	mov	w0, #144                        ; =0x90
	b	l_SlowJSPostInc_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function post_inc_0_asm_h
l_post_inc_0_asm_h:                     ; @post_inc_0_asm_h
; %bb.0:                                ; %B16
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB180_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB180_4
; %bb.2:                                ; %B13
	adds	w8, w22, #1
	b.vs	LBB180_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB180_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB180_6
; %bb.5:                                ; %B8
	add	x8, x22, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #486
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
LBB180_6:                               ; %B5
	mov	w0, #145                        ; =0x91
	b	l_SlowJSPostInc_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function dec_loc_0_asm_h
l_dec_loc_0_asm_h:                      ; @dec_loc_0_asm_h
; %bb.0:                                ; %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	LBB181_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB181_4
; %bb.2:                                ; %B13
	subs	w9, w1, #1
	b.vs	LBB181_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB181_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB181_6
; %bb.5:                                ; %B8
	add	x9, x1, x9
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       ; =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB181_6:                               ; %B16
	mov	x0, x24
	mov	w2, #142                        ; =0x8e
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB181_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB181_8:                               ; %B17
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function inc_loc_0_asm_h
l_inc_loc_0_asm_h:                      ; @inc_loc_0_asm_h
; %bb.0:                                ; %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	LBB182_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB182_4
; %bb.2:                                ; %B13
	adds	w9, w1, #1
	b.vs	LBB182_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB182_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB182_6
; %bb.5:                                ; %B8
	add	x9, x1, x9
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       ; =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB182_6:                               ; %B16
	mov	x0, x24
	mov	w2, #143                        ; =0x8f
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB182_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB182_8:                               ; %B17
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function add_loc_0_asm_h
l_add_loc_0_asm_h:                      ; @add_loc_0_asm_h
; %bb.0:                                ; %B46
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldur	x22, [x20, #-8]
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	ccmp	x22, x9, #2, ls
	b.hi	LBB183_15
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB183_5
; %bb.2:                                ; %B26
	cmp	x22, x9
	b.lo	LBB183_8
; %bb.3:                                ; %B36
	adds	w9, w1, w22
	sub	x20, x20, #8
	b.vs	LBB183_12
; %bb.4:                                ; %B42
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB183_5:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB183_15
; %bb.6:                                ; %B11
	cmp	x22, x9
	b.lo	LBB183_13
; %bb.7:                                ; %B21
	scvtf	d0, w22
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	LBB183_11
LBB183_8:                               ; %B28
	tst	x22, #0xfffe000000000000
	b.eq	LBB183_15
; %bb.9:                                ; %B31
	scvtf	d0, w1
	add	x9, x22, x9
LBB183_10:                              ; %B31
	fmov	d1, x9
	fadd	d0, d0, d1
LBB183_11:                              ; %B31
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	add	x9, x9, x10
	mov	x10, #9221683186994511872       ; =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB183_12:                              ; %B38
	scvtf	d0, w1
	scvtf	d1, w22
	mov	x10, #562949953421312           ; =0x2000000000000
	fadd	d0, d0, d1
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       ; =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB183_13:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB183_15
; %bb.14:                               ; %B16
	add	x10, x1, x9
	add	x9, x22, x9
	fmov	d0, x10
	b	LBB183_10
LBB183_15:                              ; %B7
	and	x8, x22, #0xffff000000000003
	mov	x9, #-281474976710653           ; =0xffff000000000003
	mov	x10, #2                         ; =0x2
	cmp	x8, x9
	movk	x10, #1, lsl #48
	and	x11, x1, #0xffff000000000003
	ccmp	x8, x10, #4, ne
	cset	w8, eq
	cmp	x11, x10
	ccmp	x11, x9, #4, ne
	ccmp	w8, #0, #4, eq
	b.ne	LBB183_18
; %bb.16:                               ; %B43
	mov	x0, x24
	mov	x2, x22
	str	x20, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB183_19
; %bb.17:                               ; %B45
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB183_18:                              ; %B8
	mov	w0, #1                          ; =0x1
	b	l_FastJSConcatString_asm_h
LBB183_19:                              ; %B44
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function not_0_asm_h
l_not_0_asm_h:                          ; @not_0_asm_h
; %bb.0:                                ; %B2
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB184_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB184_2:                               ; %B4
	mov	x0, x22
	b	l_SlowJSNot_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lnot_0_asm_h
l_lnot_0_asm_h:                         ; @lnot_0_asm_h
; %bb.0:                                ; %B14
	ldur	x22, [x20, #-8]
	cmp	x22, #5
	b.le	LBB185_4
; %bb.1:                                ; %B14
	cmp	x22, #6
	b.eq	LBB185_6
; %bb.2:                                ; %B14
	cmp	x22, #7
	b.eq	LBB185_8
; %bb.3:                                ; %B14
	cmp	x22, #18
	b.eq	LBB185_6
	b	LBB185_7
LBB185_4:                               ; %B14
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB185_6
; %bb.5:                                ; %B14
	cmp	x22, #2
	b.ne	LBB185_7
LBB185_6:                               ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB185_7:                               ; %B10
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB185_9
LBB185_8:                               ; %B12
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB185_9:                               ; %B13
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function typeof_0_asm_h
l_typeof_0_asm_h:                       ; @typeof_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	mov	x1, x22
	bl	_js_operator_typeof_gc
	mov	w1, w0
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB186_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB186_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function delete_0_asm_h
l_delete_0_asm_h:                       ; @delete_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	_prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	LBB187_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB187_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function delete_var_0_asm_h
l_delete_var_0_asm_h:                   ; @delete_var_0_asm_h
; %bb.0:                                ; %B1
	ldr	x1, [x24, #208]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, wzr
	str	x20, [x23, #48]
	bl	_JS_DeleteProperty_GC
	tbnz	w0, #31, LBB188_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB188_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function mul_0_asm_h
l_mul_0_asm_h:                          ; @mul_0_asm_h
; %bb.0:                                ; %B51
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB189_19
; %bb.1:                                ; %B51
	cmp	x21, x8
	b.hi	LBB189_19
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB189_8
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB189_11
; %bb.4:                                ; %B33
	smull	x8, w22, w21
	sub	x20, x20, #16
	cmp	x8, w8, sxtw
	b.ne	LBB189_15
; %bb.5:                                ; %B40
	cbnz	w8, LBB189_7
; %bb.6:                                ; %B40
	orr	w9, w22, w21
	tbnz	w9, #31, LBB189_16
LBB189_7:                               ; %B47
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB189_8:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB189_19
; %bb.9:                                ; %B7
	cmp	x21, x8
	b.lo	LBB189_17
; %bb.10:                               ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	LBB189_14
LBB189_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB189_19
; %bb.12:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB189_13:                              ; %B28
	fmov	d1, x8
	fmul	d0, d0, d1
LBB189_14:                              ; %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB189_15:                              ; %B35
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           ; =0x2000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	fmul	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB189_16:                              ; %B44
	mov	x22, #-9222809086901354496      ; =0x8002000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB189_17:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB189_19
; %bb.18:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB189_13
LBB189_19:                              ; %B48
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        ; =0x9a
	str	x20, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB189_21
; %bb.20:                               ; %B50
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB189_21:                              ; %B49
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function div_0_asm_h
l_div_0_asm_h:                          ; @div_0_asm_h
; %bb.0:                                ; %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB190_14
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB190_14
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB190_5
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB190_8
; %bb.4:                                ; %B33
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x8, #562949953421312            ; =0x2000000000000
	ldrb	w10, [x19], #1
	mov	x12, #9221683186994511872       ; =0x7ffa000000000000
	sub	x20, x20, #16
	add	w10, w10, #243
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
LBB190_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB190_14
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB190_12
; %bb.7:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	LBB190_11
LBB190_8:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB190_14
; %bb.9:                                ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB190_10:                              ; %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
LBB190_11:                              ; %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB190_12:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB190_14
; %bb.13:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB190_10
LBB190_14:                              ; %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        ; =0x9b
	str	x20, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB190_16
; %bb.15:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB190_16:                              ; %B42
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function mod_0_asm_h
l_mod_0_asm_h:                          ; @mod_0_asm_h
; %bb.0:                                ; %B39
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB191_16
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB191_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB191_7
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB191_10
; %bb.4:                                ; %B33
	tbnz	w22, #31, LBB191_16
; %bb.5:                                ; %B33
	cmp	w21, #1
	b.lt	LBB191_16
; %bb.6:                                ; %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB191_7:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB191_16
; %bb.8:                                ; %B7
	cmp	x21, x8
	b.lo	LBB191_14
; %bb.9:                                ; %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	LBB191_13
LBB191_10:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB191_16
; %bb.11:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB191_12:                              ; %B28
	fmov	d1, x8
LBB191_13:                              ; %B28
	bl	_fmod
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB191_14:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB191_16
; %bb.15:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB191_12
LBB191_16:                              ; %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        ; =0x9c
	str	x20, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB191_18
; %bb.17:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB191_18:                              ; %B37
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function add_0_asm_h
l_add_0_asm_h:                          ; @add_0_asm_h
; %bb.0:                                ; %B46
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB192_16
; %bb.1:                                ; %B46
	cmp	x21, x8
	b.hi	LBB192_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB192_6
; %bb.3:                                ; %B26
	cmp	x21, x8
	b.lo	LBB192_9
; %bb.4:                                ; %B36
	adds	w8, w22, w21
	sub	x20, x20, #16
	b.vs	LBB192_13
; %bb.5:                                ; %B42
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB192_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB192_16
; %bb.7:                                ; %B11
	cmp	x21, x8
	b.lo	LBB192_14
; %bb.8:                                ; %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	LBB192_12
LBB192_9:                               ; %B28
	tst	x21, #0xfffe000000000000
	b.eq	LBB192_16
; %bb.10:                               ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB192_11:                              ; %B31
	fmov	d1, x8
	fadd	d0, d0, d1
LBB192_12:                              ; %B31
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB192_13:                              ; %B38
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           ; =0x2000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	fadd	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB192_14:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB192_16
; %bb.15:                               ; %B16
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB192_11
LBB192_16:                              ; %B7
	and	x8, x21, #0xffff000000000003
	mov	x9, #-281474976710653           ; =0xffff000000000003
	mov	x10, #2                         ; =0x2
	cmp	x8, x9
	movk	x10, #1, lsl #48
	and	x11, x22, #0xffff000000000003
	ccmp	x8, x10, #4, ne
	cset	w8, eq
	cmp	x11, x10
	ccmp	x11, x9, #4, ne
	b.ne	LBB192_19
; %bb.17:                               ; %B7
	cbz	w8, LBB192_19
; %bb.18:                               ; %B8
	mov	x0, xzr
	b	l_FastJSConcatString_asm_h
LBB192_19:                              ; %B43
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB192_21
; %bb.20:                               ; %B45
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB192_21:                              ; %B44
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function sub_0_asm_h
l_sub_0_asm_h:                          ; @sub_0_asm_h
; %bb.0:                                ; %B43
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB193_16
; %bb.1:                                ; %B43
	cmp	x21, x8
	b.hi	LBB193_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB193_6
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB193_9
; %bb.4:                                ; %B33
	subs	w8, w22, w21
	sub	x20, x20, #16
	b.vs	LBB193_13
; %bb.5:                                ; %B39
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB193_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB193_16
; %bb.7:                                ; %B7
	cmp	x21, x8
	b.lo	LBB193_14
; %bb.8:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	LBB193_12
LBB193_9:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB193_16
; %bb.10:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB193_11:                              ; %B28
	fmov	d1, x8
	fsub	d0, d0, d1
LBB193_12:                              ; %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB193_13:                              ; %B35
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           ; =0x2000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	fsub	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB193_14:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB193_16
; %bb.15:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB193_11
LBB193_16:                              ; %B40
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        ; =0x9e
	str	x20, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB193_18
; %bb.17:                               ; %B42
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB193_18:                              ; %B41
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function pow_0_asm_h
l_pow_0_asm_h:                          ; @pow_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w3, #159                        ; =0x9f
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB194_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB194_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function shl_0_asm_h
l_shl_0_asm_h:                          ; @shl_0_asm_h
; %bb.0:                                ; %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB195_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB195_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB195_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB195_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB195_5:                               ; %B16
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #16
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB195_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB195_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB195_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB195_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB195_5
LBB195_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        ; =0xa0
	str	x20, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB195_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB195_12:                              ; %B26
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function sar_0_asm_h
l_sar_0_asm_h:                          ; @sar_0_asm_h
; %bb.0:                                ; %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB196_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB196_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB196_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB196_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB196_5:                               ; %B16
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #16
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB196_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB196_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB196_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB196_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB196_5
LBB196_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        ; =0xa1
	str	x20, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB196_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB196_12:                              ; %B26
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function shr_0_asm_h
l_shr_0_asm_h:                          ; @shr_0_asm_h
; %bb.0:                                ; %B36
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB197_11
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB197_11
; %bb.2:                                ; %B10
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB197_6
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB197_11
; %bb.4:                                ; %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, LBB197_10
LBB197_5:                               ; %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB197_6:                               ; %B12
	tst	x22, #0xfffe000000000000
	b.eq	LBB197_11
; %bb.7:                                ; %B12
	cmp	x21, x8
	b.lo	LBB197_11
; %bb.8:                                ; %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB197_11
; %bb.9:                                ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, LBB197_5
LBB197_10:                              ; %B6
	ucvtf	d0, w8
	mov	x9, #562949953421312            ; =0x2000000000000
	fmov	x8, d0
	fcmp	d0, d0
	add	x8, x8, x9
	mov	x9, #9221683186994511872        ; =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB197_11:                              ; %B33
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	_prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	LBB197_13
; %bb.12:                               ; %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB197_13:                              ; %B34
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lt_0_asm_h
l_lt_0_asm_h:                           ; @lt_0_asm_h
; %bb.0:                                ; %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB198_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB198_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB198_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB198_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, lt
	br	x1
LBB198_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB198_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB198_10
; %bb.7:                                ; %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, mi
	br	x1
LBB198_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB198_12
; %bb.9:                                ; %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, mi
	br	x1
LBB198_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB198_12
; %bb.11:                               ; %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, mi
	br	x1
LBB198_12:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        ; =0xa3
	str	x20, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB198_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB198_14:                              ; %B22
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lte_0_asm_h
l_lte_0_asm_h:                          ; @lte_0_asm_h
; %bb.0:                                ; %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB199_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB199_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB199_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB199_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, le
	br	x1
LBB199_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB199_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB199_10
; %bb.7:                                ; %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ls
	br	x1
LBB199_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB199_12
; %bb.9:                                ; %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ls
	br	x1
LBB199_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB199_12
; %bb.11:                               ; %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ls
	br	x1
LBB199_12:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        ; =0xa4
	str	x20, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB199_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB199_14:                              ; %B22
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function gt_0_asm_h
l_gt_0_asm_h:                           ; @gt_0_asm_h
; %bb.0:                                ; %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB200_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB200_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB200_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB200_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB200_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB200_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB200_10
; %bb.7:                                ; %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB200_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB200_12
; %bb.9:                                ; %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB200_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB200_12
; %bb.11:                               ; %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB200_12:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        ; =0xa5
	str	x20, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB200_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB200_14:                              ; %B22
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function gte_0_asm_h
l_gte_0_asm_h:                          ; @gte_0_asm_h
; %bb.0:                                ; %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB201_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB201_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB201_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB201_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB201_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB201_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB201_10
; %bb.7:                                ; %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB201_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB201_12
; %bb.9:                                ; %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB201_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB201_12
; %bb.11:                               ; %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB201_12:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        ; =0xa6
	str	x20, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB201_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB201_14:                              ; %B22
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function instanceof_0_asm_h
l_instanceof_0_asm_h:                   ; @instanceof_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	_prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	LBB202_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB202_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function in_0_asm_h
l_in_0_asm_h:                           ; @in_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	_prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	LBB203_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB203_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function eq_0_asm_h
l_eq_0_asm_h:                           ; @eq_0_asm_h
; %bb.0:                                ; %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB204_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB204_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB204_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB204_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB204_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB204_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB204_11
; %bb.7:                                ; %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #243
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
LBB204_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB204_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB204_10:                              ; %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #243
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
LBB204_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB204_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB204_10
LBB204_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB204_15
LBB204_14:                              ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB204_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB204_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB204_14
	b	LBB204_20
LBB204_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB204_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB204_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB204_21
LBB204_20:                              ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB204_21:                              ; %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB204_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB204_23:                              ; %B42
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function neq_0_asm_h
l_neq_0_asm_h:                          ; @neq_0_asm_h
; %bb.0:                                ; %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB205_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB205_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB205_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB205_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB205_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB205_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB205_11
; %bb.7:                                ; %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #243
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
LBB205_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB205_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB205_10:                              ; %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #243
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
LBB205_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB205_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB205_10
LBB205_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB205_15
LBB205_14:                              ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB205_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB205_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB205_14
	b	LBB205_20
LBB205_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB205_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB205_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB205_21
LBB205_20:                              ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB205_21:                              ; %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB205_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB205_23:                              ; %B42
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function strict_eq_0_asm_h
l_strict_eq_0_asm_h:                    ; @strict_eq_0_asm_h
; %bb.0:                                ; %B39
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB206_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB206_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB206_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB206_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB206_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB206_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB206_11
; %bb.7:                                ; %B28
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #243
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
LBB206_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB206_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB206_10:                              ; %B34
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #243
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
LBB206_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB206_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB206_10
LBB206_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB206_15
; %bb.14:                               ; %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB206_15:                              ; %B13
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          ; =0xffff000000000003
	mov	x12, #2                         ; =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x10, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w9, eq
	cmp	x10, x11
	ccmp	x10, x12, #4, ne
	cset	w11, eq
	cmp	w9, #1
	b.ne	LBB206_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB206_22
LBB206_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB206_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB206_23
LBB206_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB206_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB206_25
LBB206_21:                              ; %B21
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB206_22:                              ; %B14
	mov	x0, xzr
	b	l_FastStringEqual_asm_h
LBB206_23:                              ; %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB206_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB206_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #16
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB206_28
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB206_27:                              ; %B37
	b	l_exception_asm_h
LBB206_28:                              ; %B8
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function strict_neq_0_asm_h
l_strict_neq_0_asm_h:                   ; @strict_neq_0_asm_h
; %bb.0:                                ; %B39
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB207_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB207_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB207_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB207_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB207_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB207_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB207_11
; %bb.7:                                ; %B28
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #243
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
LBB207_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB207_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB207_10:                              ; %B34
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #243
	sub	x20, x20, #16
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
LBB207_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB207_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB207_10
LBB207_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB207_15
; %bb.14:                               ; %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB207_15:                              ; %B13
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          ; =0xffff000000000003
	mov	x12, #2                         ; =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x10, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w9, eq
	cmp	x10, x11
	ccmp	x10, x12, #4, ne
	cset	w11, eq
	cmp	w9, #1
	b.ne	LBB207_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB207_22
LBB207_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB207_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB207_23
LBB207_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB207_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB207_25
LBB207_21:                              ; %B21
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB207_22:                              ; %B14
	mov	w0, #1                          ; =0x1
	b	l_FastStringEqual_asm_h
LBB207_23:                              ; %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB207_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB207_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #16
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB207_28
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB207_27:                              ; %B37
	b	l_exception_asm_h
LBB207_28:                              ; %B8
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function and_0_asm_h
l_and_0_asm_h:                          ; @and_0_asm_h
; %bb.0:                                ; %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB208_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB208_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB208_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB208_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB208_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	and	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB208_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB208_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB208_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB208_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB208_5
LBB208_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        ; =0xad
	str	x20, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB208_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB208_12:                              ; %B26
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function xor_0_asm_h
l_xor_0_asm_h:                          ; @xor_0_asm_h
; %bb.0:                                ; %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB209_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB209_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB209_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB209_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB209_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	eor	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB209_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB209_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB209_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB209_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB209_5
LBB209_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        ; =0xae
	str	x20, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB209_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB209_12:                              ; %B26
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function or_0_asm_h
l_or_0_asm_h:                           ; @or_0_asm_h
; %bb.0:                                ; %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB210_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB210_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB210_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB210_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB210_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	orr	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB210_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB210_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB210_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB210_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB210_5
LBB210_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        ; =0xaf
	str	x20, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB210_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB210_12:                              ; %B26
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function nop_0_asm_h
l_nop_0_asm_h:                          ; @nop_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_minus1_0_asm_h
l_push_minus1_0_asm_h:                  ; @push_minus1_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562945658454017          ; =0xfffe0000ffffffff
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_0_0_asm_h
l_push_0_0_asm_h:                       ; @push_0_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421312          ; =0xfffe000000000000
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_1_0_asm_h
l_push_1_0_asm_h:                       ; @push_1_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421311          ; =0xfffe000000000001
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_2_0_asm_h
l_push_2_0_asm_h:                       ; @push_2_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #2                         ; =0x2
	movk	x22, #65534, lsl #48
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_3_0_asm_h
l_push_3_0_asm_h:                       ; @push_3_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421309          ; =0xfffe000000000003
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_4_0_asm_h
l_push_4_0_asm_h:                       ; @push_4_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #4                         ; =0x4
	movk	x22, #65534, lsl #48
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_5_0_asm_h
l_push_5_0_asm_h:                       ; @push_5_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #5                         ; =0x5
	movk	x22, #65534, lsl #48
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_6_0_asm_h
l_push_6_0_asm_h:                       ; @push_6_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #6                         ; =0x6
	movk	x22, #65534, lsl #48
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_7_0_asm_h
l_push_7_0_asm_h:                       ; @push_7_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421305          ; =0xfffe000000000007
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_i8_0_asm_h
l_push_i8_0_asm_h:                      ; @push_i8_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w9, [x19, #1]
	ldrsb	x10, [x19]
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x19, x19, #2
	add	w9, w9, #243
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x22, x8
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_i16_0_asm_h
l_push_i16_0_asm_h:                     ; @push_i16_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w9, [x19, #2]
	ldrsh	x10, [x19]
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x19, x19, #3
	add	w9, w9, #243
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x22, x8
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_const8_0_asm_h
l_push_const8_0_asm_h:                  ; @push_const8_0_asm_h
; %bb.0:                                ; %B3
	sub	sp, sp, #16
	ldr	x8, [x23, #112]
	ldrb	w9, [x19]
	ldr	w10, [x24, #328]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, LBB223_2
; %bb.1:                                ; %B4
	mov	x0, x24
	mov	x2, x19
	str	x20, [x23, #48]
	str	x1, [sp, #8]                    ; 8-byte Folded Spill
	bl	_DebuggerPause
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
LBB223_2:                               ; %B1
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x1
	add	w8, w8, #243
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function fclosure8_0_asm_h
l_fclosure8_0_asm_h:                    ; @fclosure8_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x23, #112]
	ldrb	w9, [x19]
	ldr	x0, [x8, x9, lsl #3]
	b	l_FastFclosure_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_empty_string_0_asm_h
l_push_empty_string_0_asm_h:            ; @push_empty_string_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	w1, #47                         ; =0x2f
	mov	w2, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB225_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB225_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc8_0_asm_h
l_get_loc8_0_asm_h:                     ; @get_loc8_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19, #1]
	ldrb	w9, [x19], #2
	add	w8, w8, #243
	ldr	x22, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc8_0_asm_h
l_put_loc8_0_asm_h:                     ; @put_loc8_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc8_0_asm_h
l_set_loc8_0_asm_h:                     ; @set_loc8_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc0_0_asm_h
l_get_loc0_0_asm_h:                     ; @get_loc0_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc1_0_asm_h
l_get_loc1_0_asm_h:                     ; @get_loc1_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27, #8]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc2_0_asm_h
l_get_loc2_0_asm_h:                     ; @get_loc2_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27, #16]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc3_0_asm_h
l_get_loc3_0_asm_h:                     ; @get_loc3_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27, #24]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc0_0_asm_h
l_put_loc0_0_asm_h:                     ; @put_loc0_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc1_0_asm_h
l_put_loc1_0_asm_h:                     ; @put_loc1_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc2_0_asm_h
l_put_loc2_0_asm_h:                     ; @put_loc2_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc3_0_asm_h
l_put_loc3_0_asm_h:                     ; @put_loc3_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc0_0_asm_h
l_set_loc0_0_asm_h:                     ; @set_loc0_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc1_0_asm_h
l_set_loc1_0_asm_h:                     ; @set_loc1_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc2_0_asm_h
l_set_loc2_0_asm_h:                     ; @set_loc2_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc3_0_asm_h
l_set_loc3_0_asm_h:                     ; @set_loc3_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_arg0_0_asm_h
l_get_arg0_0_asm_h:                     ; @get_arg0_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_arg1_0_asm_h
l_get_arg1_0_asm_h:                     ; @get_arg1_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28, #8]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_arg2_0_asm_h
l_get_arg2_0_asm_h:                     ; @get_arg2_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28, #16]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_arg3_0_asm_h
l_get_arg3_0_asm_h:                     ; @get_arg3_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28, #24]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_arg0_0_asm_h
l_put_arg0_0_asm_h:                     ; @put_arg0_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_arg1_0_asm_h
l_put_arg1_0_asm_h:                     ; @put_arg1_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_arg2_0_asm_h
l_put_arg2_0_asm_h:                     ; @put_arg2_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_arg3_0_asm_h
l_put_arg3_0_asm_h:                     ; @put_arg3_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_arg0_0_asm_h
l_set_arg0_0_asm_h:                     ; @set_arg0_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_arg1_0_asm_h
l_set_arg1_0_asm_h:                     ; @set_arg1_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_arg2_0_asm_h
l_set_arg2_0_asm_h:                     ; @set_arg2_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_arg3_0_asm_h
l_set_arg3_0_asm_h:                     ; @set_arg3_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref0_0_asm_h
l_get_var_ref0_0_asm_h:                 ; @get_var_ref0_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x22, [x8]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref1_0_asm_h
l_get_var_ref1_0_asm_h:                 ; @get_var_ref1_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #8]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x22, [x8]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref2_0_asm_h
l_get_var_ref2_0_asm_h:                 ; @get_var_ref2_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #16]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x22, [x8]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref3_0_asm_h
l_get_var_ref3_0_asm_h:                 ; @get_var_ref3_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #24]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x22, [x8]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref0_0_asm_h
l_put_var_ref0_0_asm_h:                 ; @put_var_ref0_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref1_0_asm_h
l_put_var_ref1_0_asm_h:                 ; @put_var_ref1_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #8]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref2_0_asm_h
l_put_var_ref2_0_asm_h:                 ; @put_var_ref2_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #16]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref3_0_asm_h
l_put_var_ref3_0_asm_h:                 ; @put_var_ref3_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #24]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_var_ref0_0_asm_h
l_set_var_ref0_0_asm_h:                 ; @set_var_ref0_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_var_ref1_0_asm_h
l_set_var_ref1_0_asm_h:                 ; @set_var_ref1_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #8]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_var_ref2_0_asm_h
l_set_var_ref2_0_asm_h:                 ; @set_var_ref2_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #16]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_var_ref3_0_asm_h
l_set_var_ref3_0_asm_h:                 ; @set_var_ref3_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #24]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_length_0_asm_h
l_get_length_0_asm_h:                   ; @get_length_0_asm_h
; %bb.0:                                ; %B27
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #1, lsl #48
	and	x9, x22, #0xffff000000000003
	cmp	x9, x8
	mov	x8, #-281474976710653           ; =0xffff000000000003
	ccmp	x9, x8, #4, ne
	b.ne	LBB265_2
; %bb.1:                                ; %B28
	and	x8, x22, #0xfffffffffffc
	ldrb	w9, [x19], #1
	ldr	w8, [x8, #4]
	mov	x10, #-562949953421312          ; =0xfffe000000000000
	sub	x20, x20, #8
	add	w9, w9, #243
	bfxil	x10, x8, #0, #30
	ldr	x1, [x25, w9, uxtw #3]
	mov	x22, x10
	br	x1
LBB265_2:                               ; %B21
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB265_12
; %bb.3:                                ; %B22
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB265_4:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB265_5 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w11, #0x30
	ldr	w10, [x13, w10, uxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB265_7
LBB265_5:                               ; %B1
                                        ;   Parent Loop BB265_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, #48
	b.eq	LBB265_9
; %bb.6:                                ; %B9
                                        ;   in Loop: Header=BB265_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB265_5
LBB265_7:                               ; %B14
                                        ;   in Loop: Header=BB265_4 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB265_12
; %bb.8:                                ; %B17
                                        ;   in Loop: Header=BB265_4 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB265_4
	b	LBB265_11
LBB265_9:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB265_12
; %bb.10:                               ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB265_11:                              ; %B6
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB265_12:                              ; %B24
	mov	x0, x24
	mov	x1, x22
	mov	w2, #48                         ; =0x30
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB265_14
; %bb.13:                               ; %B26
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB265_14:                              ; %B25
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_false8_0_asm_h
l_if_false8_0_asm_h:                    ; @if_false8_0_asm_h
; %bb.0:                                ; %B29
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	LBB266_4
; %bb.1:                                ; %B29
	cmp	x22, #6
	b.eq	LBB266_6
; %bb.2:                                ; %B29
	cmp	x22, #7
	b.eq	LBB266_10
; %bb.3:                                ; %B29
	cmp	x22, #18
	b.eq	LBB266_6
	b	LBB266_8
LBB266_4:                               ; %B29
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.eq	LBB266_6
; %bb.5:                                ; %B29
	cmp	x22, #2
	b.ne	LBB266_8
LBB266_6:                               ; %B8
	ldrsb	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB266_11
LBB266_7:                               ; %B10
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB266_8:                               ; %B15
	mov	x9, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x9
	b.hs	LBB266_16
; %bb.9:                                ; %B17
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.lo	LBB266_13
LBB266_10:                              ; %B25
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB266_11:                              ; %B5
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB266_7
; %bb.12:                               ; %B6
	add	x19, x19, #1
	b	l_PollInterrupts_asm_h
LBB266_13:                              ; %B19
	tst	x22, #0xfffe000000000000
	b.eq	LBB266_16
; %bb.14:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB266_6
	b.vs	LBB266_6
; %bb.15:                               ; %B23
	tbnz	w8, #0, LBB266_10
	b	LBB266_6
LBB266_16:                              ; %B21
	mov	x20, x8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_true8_0_asm_h
l_if_true8_0_asm_h:                     ; @if_true8_0_asm_h
; %bb.0:                                ; %B29
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	LBB267_4
; %bb.1:                                ; %B29
	cmp	x22, #6
	b.eq	LBB267_6
; %bb.2:                                ; %B29
	cmp	x22, #7
	b.eq	LBB267_9
; %bb.3:                                ; %B29
	cmp	x22, #18
	b.eq	LBB267_6
	b	LBB267_7
LBB267_4:                               ; %B29
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.eq	LBB267_6
; %bb.5:                                ; %B29
	cmp	x22, #2
	b.ne	LBB267_7
LBB267_6:                               ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB267_7:                               ; %B9
	mov	x9, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x9
	b.hs	LBB267_16
; %bb.8:                                ; %B11
	mov	x9, #-562949953421313           ; =0xfffdffffffffffff
	cmp	x22, x9
	b.ls	LBB267_13
LBB267_9:                               ; %B23
	ldrsb	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB267_11
LBB267_10:                              ; %B25
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB267_11:                              ; %B20
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB267_10
; %bb.12:                               ; %B21
	add	x19, x19, #1
	b	l_PollInterrupts_asm_h
LBB267_13:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB267_16
; %bb.14:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB267_6
	b.vs	LBB267_6
; %bb.15:                               ; %B17
	tbnz	w8, #0, LBB267_9
	b	LBB267_6
LBB267_16:                              ; %B15
	mov	x20, x8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto8_0_asm_h
l_goto8_0_asm_h:                        ; @goto8_0_asm_h
; %bb.0:                                ; %B5
	ldrsb	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB268_2
LBB268_1:                               ; %B7
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB268_2:                               ; %B2
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB268_1
; %bb.3:                                ; %B3
	add	x19, x19, #1
	b	l_PollInterrupts_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto16_0_asm_h
l_goto16_0_asm_h:                       ; @goto16_0_asm_h
; %bb.0:                                ; %B5
	ldrsh	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB269_2
LBB269_1:                               ; %B7
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB269_2:                               ; %B2
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB269_1
; %bb.3:                                ; %B3
	add	x19, x19, #1
	b	l_PollInterrupts_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call0_0_asm_h
l_call0_0_asm_h:                        ; @call0_0_asm_h
; %bb.0:                                ; %B2
	str	x19, [x23, #32]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	str	x20, [x23, #48]
	mov	x0, xzr
	ldur	x22, [x20, #-8]
	bl	l_common_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #104]
	b.eq	LBB270_2
; %bb.1:                                ; %B4
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB270_2:                               ; %B3
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call1_0_asm_h
l_call1_0_asm_h:                        ; @call1_0_asm_h
; %bb.0:                                ; %B2
	str	x19, [x23, #32]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	str	x20, [x23, #48]
	mov	w0, #1                          ; =0x1
	ldur	x22, [x20, #-16]
	sub	x20, x20, #8
	bl	l_common_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #104]
	b.eq	LBB271_2
; %bb.1:                                ; %B4
	stur	x0, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB271_2:                               ; %B3
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call2_0_asm_h
l_call2_0_asm_h:                        ; @call2_0_asm_h
; %bb.0:                                ; %B2
	str	x19, [x23, #32]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	str	x20, [x23, #48]
	mov	w0, #2                          ; =0x2
	ldur	x22, [x20, #-24]
	sub	x20, x20, #16
	bl	l_common_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #104]
	b.eq	LBB272_2
; %bb.1:                                ; %B4
	stur	x0, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB272_2:                               ; %B3
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call3_0_asm_h
l_call3_0_asm_h:                        ; @call3_0_asm_h
; %bb.0:                                ; %B2
	str	x19, [x23, #32]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	str	x20, [x23, #48]
	mov	w0, #3                          ; =0x3
	ldur	x22, [x20, #-32]
	sub	x20, x20, #24
	bl	l_common_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #104]
	b.eq	LBB273_2
; %bb.1:                                ; %B4
	stur	x0, [x20, #-32]
	sub	x20, x20, #24
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB273_2:                               ; %B3
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function is_undefined_0_asm_h
l_is_undefined_0_asm_h:                 ; @is_undefined_0_asm_h
; %bb.0:                                ; %B2
	ldur	x22, [x20, #-8]
	cmp	x22, #18
	b.ne	LBB274_2
; %bb.1:                                ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB274_2:                               ; %B5
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function is_null_0_asm_h
l_is_null_0_asm_h:                      ; @is_null_0_asm_h
; %bb.0:                                ; %B2
	ldur	x22, [x20, #-8]
	cmp	x22, #2
	b.ne	LBB275_2
; %bb.1:                                ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB275_2:                               ; %B5
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function is_function_0_asm_h
l_is_function_0_asm_h:                  ; @is_function_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	mov	x1, x22
	bl	_js_operator_typeof_gc
	cmp	w0, #27
	b.ne	LBB276_2
; %bb.1:                                ; %B2
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB276_2:                               ; %B5
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function inc_coverage_0_asm_h
l_inc_coverage_0_asm_h:                 ; @inc_coverage_0_asm_h
; %bb.0:                                ; %B10
	ldr	x8, [x23, #8]
	ldr	x1, [x8, #32]
	ldr	x8, [x1, #112]
	cbz	x8, LBB277_3
; %bb.1:                                ; %B7
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbnz	x8, LBB277_4
LBB277_2:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB277_3:                               ; %B11
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_EnsureCoverageCounters
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbz	x8, LBB277_2
LBB277_4:                               ; %B2
	ldr	w9, [x19]
	ldr	w10, [x10, #104]
	cmp	w9, w10
	b.hs	LBB277_2
; %bb.5:                                ; %B6
	ldr	w10, [x8, w9, sxtw #2]
	add	w10, w10, #1
	str	w10, [x8, w9, sxtw #2]
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function invalid_1_asm_h
l_invalid_1_asm_h:                      ; @invalid_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x23, #8]
	mov	x0, x24
Lloh20:
	adrp	x1, l___unnamed_11@PAGE
Lloh21:
	add	x1, x1, l___unnamed_11@PAGEOFF
	ldr	x8, [x8, #32]
	ldr	x8, [x8, #8]
	str	x20, [x23, #48]
	mvn	x8, x8
	add	x8, x8, x19
	stp	x8, xzr, [sp, #-16]!
	bl	_LEPUS_ThrowInternalError
	add	sp, sp, #16
	b	l_exception_asm_h
	.loh AdrpAdd	Lloh20, Lloh21
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_i32_1_asm_h
l_push_i32_1_asm_h:                     ; @push_i32_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19, #4]
	ldr	w9, [x19], #5
	add	w8, w8, #486
	orr	x21, x9, #0xfffe000000000000
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_const_1_asm_h
l_push_const_1_asm_h:                   ; @push_const_1_asm_h
; %bb.0:                                ; %B3
	sub	sp, sp, #16
	ldr	x8, [x23, #112]
	ldrsw	x9, [x19]
	ldr	w10, [x24, #328]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, LBB280_2
; %bb.1:                                ; %B4
	mov	x8, x20
	mov	x0, x24
	mov	x2, x19
	str	x22, [x8], #8
	str	x8, [x23, #48]
	str	x1, [sp, #8]                    ; 8-byte Folded Spill
	bl	_DebuggerPause
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
LBB280_2:                               ; %B1
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function fclosure_1_asm_h
l_fclosure_1_asm_h:                     ; @fclosure_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_fclosure_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_atom_value_1_asm_h
l_push_atom_value_1_asm_h:              ; @push_atom_value_1_asm_h
; %bb.0:                                ; %B13
	ldr	w1, [x19]
	tbnz	w1, #31, LBB282_5
; %bb.1:                                ; %B1
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, sxtw #3]
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, LBB282_4
; %bb.2:                                ; %B9
	ldr	w9, [x8, #8]
	asr	w9, w9, #30
	cmp	w9, #1
	b.ne	LBB282_5
LBB282_3:                               ; %B7
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	mov	x9, #2                          ; =0x2
	movk	x9, #1, lsl #48
	orr	x21, x8, x9
	br	x1
LBB282_4:                               ; %B2
	ldr	x9, [x8, #8]
	ldr	w9, [x9]
	asr	w9, w9, #30
	cmp	w9, #1
	b.eq	LBB282_3
LBB282_5:                               ; %B10
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB282_7
; %bb.6:                                ; %B12
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB282_7:                               ; %B11
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function private_symbol_1_asm_h
l_private_symbol_1_asm_h:               ; @private_symbol_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_private_symbol_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function undefined_1_asm_h
l_undefined_1_asm_h:                    ; @undefined_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	w21, #18                        ; =0x12
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function null_1_asm_h
l_null_1_asm_h:                         ; @null_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	w21, #2                         ; =0x2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_this_1_asm_h
l_push_this_1_asm_h:                    ; @push_this_1_asm_h
; %bb.0:                                ; %B12
	ldr	w8, [x23, #44]
	ldr	x1, [x23, #88]
	tbnz	w8, #0, LBB286_2
; %bb.1:                                ; %B12
	ldr	x8, [x23, #88]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, LBB286_3
LBB286_2:                               ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
LBB286_3:                               ; %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	LBB286_5
; %bb.4:                                ; %B7
	ldrb	w8, [x19], #1
	ldr	x21, [x24, #208]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB286_5:                               ; %B9
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB286_7
; %bb.6:                                ; %B11
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB286_7:                               ; %B10
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_false_1_asm_h
l_push_false_1_asm_h:                   ; @push_false_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	w21, #6                         ; =0x6
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_true_1_asm_h
l_push_true_1_asm_h:                    ; @push_true_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	w21, #7                         ; =0x7
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function object_1_asm_h
l_object_1_asm_h:                       ; @object_1_asm_h
; %bb.0:                                ; %B16
	ldrb	w8, [x24, #363]
	stp	x19, x20, [sp, #-16]!           ; 16-byte Folded Spill
	cbnz	w8, LBB289_5
; %bb.1:                                ; %B1
	ldr	x19, [x24, #400]
	cbz	x19, LBB289_5
; %bb.2:                                ; %B5
	mov	x8, x20
	mov	x0, x24
	mov	w1, #64                         ; =0x40
	mov	w2, #2                          ; =0x2
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x9, x0
	cbz	x9, LBB289_5
; %bb.3:                                ; %B7
	ldr	w8, [x19]
	add	w8, w8, #1
	str	w8, [x19]
	mov	w8, #1                          ; =0x1
	str	w8, [x9]
	strb	w8, [x9, #5]
	strh	w8, [x9, #6]
	add	x8, x9, #8
	stlr	x19, [x8]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB289_7
LBB289_4:                               ; %B9
	add	x8, x9, #32
	ldr	x19, [sp]                       ; 8-byte Folded Reload
	mov	x21, x9
	str	x8, [x9, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB289_5:                               ; %B13
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	LBB289_8
; %bb.6:                                ; %B15
	ldp	x19, x20, [sp]                  ; 16-byte Folded Reload
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB289_7:                               ; %B11
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x19, x8
	mov	x19, x9
	bl	_prim_WriteBarrierNoStore
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x9, x19
	b	LBB289_4
LBB289_8:                               ; %B14
	ldp	x19, x20, [sp], #16             ; 16-byte Folded Reload
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function special_object_1_asm_h
l_special_object_1_asm_h:               ; @special_object_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_special_object_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function rest_1_asm_h
l_rest_1_asm_h:                         ; @rest_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_rest_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function drop_1_asm_h
l_drop_1_asm_h:                         ; @drop_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function nip_1_asm_h
l_nip_1_asm_h:                          ; @nip_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function nip1_1_asm_h
l_nip1_1_asm_h:                         ; @nip1_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	sub	x8, x20, #16
	mov	x20, x8
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function dup_1_asm_h
l_dup_1_asm_h:                          ; @dup_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function dup1_1_asm_h
l_dup1_1_asm_h:                         ; @dup1_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	mov	x1, x22
	mov	x22, x21
	mov	x22, x1
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function dup2_1_asm_h
l_dup2_1_asm_h:                         ; @dup2_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20]
	mov	x21, x22
	ldrb	w8, [x19], #1
	ldr	x22, [x20], #8
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function dup3_1_asm_h
l_dup3_1_asm_h:                         ; @dup3_1_asm_h
; %bb.0:                                ; %B0
	ldur	x8, [x20, #-16]
	mov	x21, x22
	stp	x22, x8, [x20], #16
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function insert2_1_asm_h
l_insert2_1_asm_h:                      ; @insert2_1_asm_h
; %bb.0:                                ; %B0
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x21, [x20, #-8]
	ldrb	w8, [x19], #1
	mov	x1, x22
	mov	x22, x21
	add	w8, w8, #486
	mov	x22, x1
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function insert3_1_asm_h
l_insert3_1_asm_h:                      ; @insert3_1_asm_h
; %bb.0:                                ; %B0
	mov	x21, x22
	ldp	x8, x22, [x20, #-16]
	stp	x21, x8, [x20, #-16]
	mov	x2, x22
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x22, x2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function insert4_1_asm_h
l_insert4_1_asm_h:                      ; @insert4_1_asm_h
; %bb.0:                                ; %B0
	ldp	x9, x8, [x20, #-24]
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x21, [x20, #-24]
	stp	x9, x8, [x20, #-16]
	mov	x1, x22
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x22, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function perm3_1_asm_h
l_perm3_1_asm_h:                        ; @perm3_1_asm_h
; %bb.0:                                ; %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function perm4_1_asm_h
l_perm4_1_asm_h:                        ; @perm4_1_asm_h
; %bb.0:                                ; %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	mov	x9, x22
	ldp	x8, x22, [x20, #-16]
	stp	x9, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function perm5_1_asm_h
l_perm5_1_asm_h:                        ; @perm5_1_asm_h
; %bb.0:                                ; %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldp	x9, x8, [x20, #-24]
	mov	x10, x22
	ldur	x22, [x20, #-8]
	stur	x10, [x20, #-24]
	stp	x9, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function swap_1_asm_h
l_swap_1_asm_h:                         ; @swap_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	mov	x1, x22
	mov	x22, x21
	mov	x21, x1
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function swap2_1_asm_h
l_swap2_1_asm_h:                        ; @swap2_1_asm_h
; %bb.0:                                ; %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldp	x8, x9, [x20, #-16]
	stp	x22, x21, [x20, #-16]
	ldrb	w10, [x19], #1
	mov	x22, x8
	mov	x21, x9
	add	w10, w10, #486
	ldr	x1, [x25, w10, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function rot3l_1_asm_h
l_rot3l_1_asm_h:                        ; @rot3l_1_asm_h
; %bb.0:                                ; %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldur	x8, [x20, #-8]
	stur	x22, [x20, #-8]
	mov	x22, x21
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function rot3r_1_asm_h
l_rot3r_1_asm_h:                        ; @rot3r_1_asm_h
; %bb.0:                                ; %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	mov	x8, x21
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function rot4l_1_asm_h
l_rot4l_1_asm_h:                        ; @rot4l_1_asm_h
; %bb.0:                                ; %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldp	x9, x8, [x20, #-16]
	stp	x8, x22, [x20, #-16]
	mov	x22, x21
	mov	x21, x9
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function rot5l_1_asm_h
l_rot5l_1_asm_h:                        ; @rot5l_1_asm_h
; %bb.0:                                ; %B0
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldp	x8, x9, [x20, #-16]
	ldur	x10, [x20, #-24]
	stur	x22, [x20, #-8]
	mov	x22, x21
	mov	x21, x10
	stp	x8, x9, [x20, #-24]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function call_constructor_1_asm_h
l_call_constructor_1_asm_h:             ; @call_constructor_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_call_constructor_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call_1_asm_h
l_call_1_asm_h:                         ; @call_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_call_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function tail_call_1_asm_h
l_tail_call_1_asm_h:                    ; @tail_call_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_tail_call_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call_method_1_asm_h
l_call_method_1_asm_h:                  ; @call_method_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_call_method_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function tail_call_method_1_asm_h
l_tail_call_method_1_asm_h:             ; @tail_call_method_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_tail_call_method_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function array_from_1_asm_h
l_array_from_1_asm_h:                   ; @array_from_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_array_from_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function apply_1_asm_h
l_apply_1_asm_h:                        ; @apply_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_apply_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function return_1_asm_h
l_return_1_asm_h:                       ; @return_1_asm_h
; %bb.0:                                ; %B0
	mov	x0, x22
	b	l_common_return_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function return_undef_1_asm_h
l_return_undef_1_asm_h:                 ; @return_undef_1_asm_h
; %bb.0:                                ; %B0
	mov	w0, #18                         ; =0x12
	b	l_common_return_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function check_ctor_return_1_asm_h
l_check_ctor_return_1_asm_h:            ; @check_ctor_return_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_check_ctor_return_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function check_ctor_1_asm_h
l_check_ctor_1_asm_h:                   ; @check_ctor_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_check_ctor_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function check_brand_1_asm_h
l_check_brand_1_asm_h:                  ; @check_brand_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_check_brand_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function add_brand_1_asm_h
l_add_brand_1_asm_h:                    ; @add_brand_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_add_brand_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function return_async_1_asm_h
l_return_async_1_asm_h:                 ; @return_async_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_return_async_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function throw_1_asm_h
l_throw_1_asm_h:                        ; @throw_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_throw_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function throw_var_1_asm_h
l_throw_var_1_asm_h:                    ; @throw_var_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_throw_var_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function eval_1_asm_h
l_eval_1_asm_h:                         ; @eval_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_eval_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function regexp_1_asm_h
l_regexp_1_asm_h:                       ; @regexp_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_regexp_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_super_ctor_1_asm_h
l_get_super_ctor_1_asm_h:               ; @get_super_ctor_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_get_super_ctor_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_super_1_asm_h
l_get_super_1_asm_h:                    ; @get_super_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_get_super_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function import_1_asm_h
l_import_1_asm_h:                       ; @import_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_import_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function check_var_1_asm_h
l_check_var_1_asm_h:                    ; @check_var_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_check_var_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_undef_1_asm_h
l_get_var_undef_1_asm_h:                ; @get_var_undef_1_asm_h
; %bb.0:                                ; %B0
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
	cbz	w11, LBB333_3
LBB333_1:                               ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB333_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB333_1 Depth=1
	ldr	w11, [x12]
	and	w11, w11, #0x3ffffff
	cbnz	w11, LBB333_1
LBB333_3:                               ; %B11
	ldr	x8, [x24, #208]
	mov	w10, #18                        ; =0x12
LBB333_4:                               ; %B33
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB333_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w9, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB333_7
LBB333_5:                               ; %B22
                                        ;   Parent Loop BB333_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w9
	b.eq	LBB333_9
; %bb.6:                                ; %B24
                                        ;   in Loop: Header=BB333_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB333_5
LBB333_7:                               ; %B27
                                        ;   in Loop: Header=BB333_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	LBB333_13
; %bb.8:                                ; %B30
                                        ;   in Loop: Header=BB333_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB333_4
	b	LBB333_11
LBB333_9:                               ; %B12
	lsr	w9, w13, #26
	tst	w9, #0x30
	b.ne	LBB333_13
LBB333_10:                              ; %B7.sink.split
	ldr	x8, [x8, #16]
	sub	w9, w11, #1
	ldr	x10, [x8, w9, sxtw #3]
LBB333_11:                              ; %B7
	cmp	x10, #34
	b.eq	LBB333_15
; %bb.12:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x10
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB333_13:                              ; %B17
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB333_16
; %bb.14:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB333_15:                              ; %B3
	str	x22, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
LBB333_16:                              ; %B18
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_1_asm_h
l_get_var_1_asm_h:                      ; @get_var_1_asm_h
; %bb.0:                                ; %B0
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
	cbz	w10, LBB334_3
LBB334_1:                               ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB334_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB334_1 Depth=1
	ldr	w10, [x12]
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB334_1
LBB334_3:                               ; %B11
	ldr	x8, [x24, #208]
LBB334_4:                               ; %B32
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB334_5 Depth 2
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w9, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB334_7
LBB334_5:                               ; %B21
                                        ;   Parent Loop BB334_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	LBB334_9
; %bb.6:                                ; %B23
                                        ;   in Loop: Header=BB334_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB334_5
LBB334_7:                               ; %B26
                                        ;   in Loop: Header=BB334_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB334_12
; %bb.8:                                ; %B29
                                        ;   in Loop: Header=BB334_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB334_4
	b	LBB334_12
LBB334_9:                               ; %B12
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	LBB334_12
LBB334_10:                              ; %B7
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	LBB334_14
; %bb.11:                               ; %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB334_12:                              ; %B16
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB334_15
; %bb.13:                               ; %B18
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB334_14:                              ; %B3
	str	x22, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
LBB334_15:                              ; %B17
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_1_asm_h
l_put_var_1_asm_h:                      ; @put_var_1_asm_h
; %bb.0:                                ; %B0
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
	cbz	w9, LBB335_3
LBB335_1:                               ; %B1
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w12, w1
	b.eq	LBB335_6
; %bb.2:                                ; %B16
                                        ;   in Loop: Header=BB335_1 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, LBB335_1
LBB335_3:                               ; %B19
	ldr	x8, [x24, #208]
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x12, x9, #64
	lsl	w11, w10, #2
	and	w9, w1, w10
	ldr	w9, [x12, w9, sxtw #2]
	add	w10, w11, #4
	add	x10, x12, x10
	cbz	w9, LBB335_13
LBB335_4:                               ; %B26
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w12, w1
	b.eq	LBB335_10
; %bb.5:                                ; %B31
                                        ;   in Loop: Header=BB335_4 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, LBB335_4
	b	LBB335_13
LBB335_6:                               ; %B13
	mov	w10, #58                        ; =0x3a
	and	w10, w10, w11, lsr #26
	cmp	w10, #2
	b.ne	LBB335_13
; %bb.7:                                ; %B3
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	ldr	x10, [x8, w9, sxtw #3]
	cmp	x10, #34
	b.eq	LBB335_13
; %bb.8:                                ; %B20
	str	x22, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB335_12
LBB335_9:                               ; %B8
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB335_10:                              ; %B28
	mov	w10, #58                        ; =0x3a
	and	w10, w10, w11, lsr #26
	cmp	w10, #2
	b.ne	LBB335_13
; %bb.11:                               ; %B20
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	str	x22, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB335_9
LBB335_12:
	mov	x1, x24
	mov	x0, x22
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB335_13:                              ; %B34
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	w3, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_SetGlobalVar_GC
	tbz	w0, #31, LBB335_9
; %bb.14:                               ; %B35
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_init_1_asm_h
l_put_var_init_1_asm_h:                 ; @put_var_init_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_put_var_init_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_strict_1_asm_h
l_put_var_strict_1_asm_h:               ; @put_var_strict_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_put_var_strict_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_ref_value_1_asm_h
l_get_ref_value_1_asm_h:                ; @get_ref_value_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_get_ref_value_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_ref_value_1_asm_h
l_put_ref_value_1_asm_h:                ; @put_ref_value_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_put_ref_value_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_var_1_asm_h
l_define_var_1_asm_h:                   ; @define_var_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_define_var_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function check_define_var_1_asm_h
l_check_define_var_1_asm_h:             ; @check_define_var_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_check_define_var_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_func_1_asm_h
l_define_func_1_asm_h:                  ; @define_func_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_define_func_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_field_1_asm_h
l_get_field_1_asm_h:                    ; @get_field_1_asm_h
; %bb.0:                                ; %B24
	mov	x8, #2                          ; =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB343_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB343_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB343_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB343_5
LBB343_3:                               ; %B1
                                        ;   Parent Loop BB343_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB343_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB343_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB343_3
LBB343_5:                               ; %B14
                                        ;   in Loop: Header=BB343_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB343_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB343_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB343_2
	b	LBB343_9
LBB343_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB343_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB343_9:                               ; %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB343_10:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB343_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB343_12:                              ; %B22
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_field2_1_asm_h
l_get_field2_1_asm_h:                   ; @get_field2_1_asm_h
; %bb.0:                                ; %B24
	mov	x8, #2                          ; =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB344_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB344_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB344_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB344_5
LBB344_3:                               ; %B1
                                        ;   Parent Loop BB344_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB344_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB344_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB344_3
LBB344_5:                               ; %B14
                                        ;   in Loop: Header=BB344_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB344_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB344_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB344_2
	b	LBB344_9
LBB344_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB344_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB344_9:                               ; %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB344_10:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB344_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB344_12:                              ; %B22
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_field_1_asm_h
l_put_field_1_asm_h:                    ; @put_field_1_asm_h
; %bb.0:                                ; %B55
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	ldr	w2, [x19]
	tst	x22, x8
	b.ne	LBB345_18
; %bb.1:                                ; %B56
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB345_4
LBB345_2:                               ; %B1
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB345_10
; %bb.3:                                ; %B12
                                        ;   in Loop: Header=BB345_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB345_2
LBB345_4:                               ; %B17.preheader
	mov	x8, x22
LBB345_5:                               ; %B17
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB345_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w2, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB345_8
LBB345_6:                               ; %B18
                                        ;   Parent Loop BB345_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB345_13
; %bb.7:                                ; %B34
                                        ;   in Loop: Header=BB345_6 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB345_6
LBB345_8:                               ; %B41
                                        ;   in Loop: Header=BB345_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB345_18
; %bb.9:                                ; %B38
                                        ;   in Loop: Header=BB345_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB345_5
	b	LBB345_14
LBB345_10:                              ; %B3
	mov	w9, #58                         ; =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	LBB345_18
; %bb.11:                               ; %B7
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB345_22
LBB345_12:                              ; %B48
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB345_13:                              ; %B20
	mov	w8, #58                         ; =0x3a
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	LBB345_18
LBB345_14:                              ; %B23
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	LBB345_18
; %bb.15:                               ; %B25
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	add	x8, x20, #8
	b.ne	LBB345_20
; %bb.16:                               ; %B25
	tbnz	w2, #31, LBB345_20
; %bb.17:                               ; %B31
	mov	x20, x8
	stur	x21, [x8, #-8]
	mov	x0, x2
	b	l_FastAddNamedProperty_asm_h
LBB345_18:                              ; %B52
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
                                        ; kill: def $w2 killed $w2 killed $x2
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_SetPropertyInternalImpl_GC
	tbz	w0, #31, LBB345_12
; %bb.19:                               ; %B53
	b	l_exception_spill_top1_asm_h
LBB345_20:                              ; %B45
	mov	x0, x24
	mov	x1, x22
	mov	w3, #7                          ; =0x7
	stur	x21, [x8, #-8]
                                        ; kill: def $w2 killed $w2 killed $x2
	str	x8, [x23, #48]
	bl	_add_property_gc
	cbz	x0, LBB345_23
; %bb.21:                               ; %B49
	str	x21, [x0]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB345_12
LBB345_22:                              ; %B51
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB345_23:                              ; %B46
	sub	x20, x20, #8
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_private_field_1_asm_h
l_get_private_field_1_asm_h:            ; @get_private_field_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_get_private_field_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_private_field_1_asm_h
l_put_private_field_1_asm_h:            ; @put_private_field_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_put_private_field_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_private_field_1_asm_h
l_define_private_field_1_asm_h:         ; @define_private_field_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_define_private_field_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_array_el_1_asm_h
l_get_array_el_1_asm_h:                 ; @get_array_el_1_asm_h
; %bb.0:                                ; %B76
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB349_12
; %bb.1:                                ; %B73
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	LBB349_5
; %bb.2:                                ; %B1
	cmp	w8, #2
	b.ne	LBB349_10
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB349_14
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB349_5:                               ; %B33
	cmp	w8, #1
	b.ne	LBB349_12
; %bb.6:                                ; %B36
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB349_12
; %bb.7:                                ; %B36
	mov	x9, #2                          ; =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB349_12
; %bb.8:                                ; %B65
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB349_24
; %bb.9:                                ; %B68
	ldr	w8, [x1, #8]
	b	LBB349_25
LBB349_10:                              ; %B30
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB349_12
; %bb.11:                               ; %B30
	cmp	w8, #29
	b.le	LBB349_33
LBB349_12:                              ; %B70
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB349_34
; %bb.13:                               ; %B72
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB349_14:                              ; %B7
	tbnz	w21, #31, LBB349_12
; %bb.15:                               ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB349_16:                              ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB349_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB349_19
LBB349_17:                              ; %B10
                                        ;   Parent Loop BB349_16 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB349_21
; %bb.18:                               ; %B17
                                        ;   in Loop: Header=BB349_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB349_17
LBB349_19:                              ; %B24
                                        ;   in Loop: Header=BB349_16 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB349_12
; %bb.20:                               ; %B21
                                        ;   in Loop: Header=BB349_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB349_16
	b	LBB349_23
LBB349_21:                              ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB349_12
; %bb.22:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB349_23:                              ; %B51
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB349_24:                              ; %B66
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
LBB349_25:                              ; %B62
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	LBB349_12
; %bb.26:                               ; %B41
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	cbz	w0, LBB349_12
; %bb.27:                               ; %B44.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB349_28:                              ; %B44
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB349_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB349_31
LBB349_29:                              ; %B47
                                        ;   Parent Loop BB349_28 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	LBB349_35
; %bb.30:                               ; %B53
                                        ;   in Loop: Header=BB349_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB349_29
LBB349_31:                              ; %B58
                                        ;   in Loop: Header=BB349_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB349_12
; %bb.32:                               ; %B55
                                        ;   in Loop: Header=BB349_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB349_28
	b	LBB349_23
LBB349_33:                              ; %B31
	str	x21, [x20], #8
	mov	x0, xzr
	b	l_FastTypedArrayGet_asm_h
LBB349_34:                              ; %B71
	b	l_exception_spill_top1_asm_h
LBB349_35:                              ; %B49
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB349_12
; %bb.36:                               ; %B50
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_array_el2_1_asm_h
l_get_array_el2_1_asm_h:                ; @get_array_el2_1_asm_h
; %bb.0:                                ; %B76
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB350_12
; %bb.1:                                ; %B73
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	LBB350_5
; %bb.2:                                ; %B1
	cmp	w8, #2
	b.ne	LBB350_10
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB350_14
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #8
	add	w8, w8, #486
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB350_5:                               ; %B33
	cmp	w8, #1
	b.ne	LBB350_12
; %bb.6:                                ; %B36
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB350_12
; %bb.7:                                ; %B36
	mov	x9, #2                          ; =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB350_12
; %bb.8:                                ; %B65
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB350_24
; %bb.9:                                ; %B68
	ldr	w8, [x1, #8]
	b	LBB350_25
LBB350_10:                              ; %B30
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB350_12
; %bb.11:                               ; %B30
	cmp	w8, #29
	b.le	LBB350_33
LBB350_12:                              ; %B70
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB350_34
; %bb.13:                               ; %B72
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB350_14:                              ; %B7
	tbnz	w21, #31, LBB350_12
; %bb.15:                               ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB350_16:                              ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB350_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB350_19
LBB350_17:                              ; %B10
                                        ;   Parent Loop BB350_16 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB350_21
; %bb.18:                               ; %B17
                                        ;   in Loop: Header=BB350_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB350_17
LBB350_19:                              ; %B24
                                        ;   in Loop: Header=BB350_16 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB350_12
; %bb.20:                               ; %B21
                                        ;   in Loop: Header=BB350_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB350_16
	b	LBB350_23
LBB350_21:                              ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB350_12
; %bb.22:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB350_23:                              ; %B51
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB350_24:                              ; %B66
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
LBB350_25:                              ; %B62
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	LBB350_12
; %bb.26:                               ; %B41
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	cbz	w0, LBB350_12
; %bb.27:                               ; %B44.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB350_28:                              ; %B44
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB350_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB350_31
LBB350_29:                              ; %B47
                                        ;   Parent Loop BB350_28 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	LBB350_35
; %bb.30:                               ; %B53
                                        ;   in Loop: Header=BB350_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB350_29
LBB350_31:                              ; %B58
                                        ;   in Loop: Header=BB350_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB350_12
; %bb.32:                               ; %B55
                                        ;   in Loop: Header=BB350_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB350_28
	b	LBB350_23
LBB350_33:                              ; %B31
	str	x21, [x20], #8
	mov	w0, #1                          ; =0x1
	b	l_FastTypedArrayGet_asm_h
LBB350_34:                              ; %B71
	b	l_exception_spill_top1_asm_h
LBB350_35:                              ; %B49
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB350_12
; %bb.36:                               ; %B50
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_array_el_1_asm_h
l_put_array_el_1_asm_h:                 ; @put_array_el_1_asm_h
; %bb.0:                                ; %B116
	sub	sp, sp, #16
	mov	x21, x22
	ldp	x11, x22, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x11, x8
	b.ne	LBB351_45
; %bb.1:                                ; %B1
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x11, #6]
	cmp	x9, x22, lsr #48
	b.ne	LBB351_7
; %bb.2:                                ; %B3
	cmp	w8, #2
	b.ne	LBB351_12
; %bb.3:                                ; %B5
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB351_45
; %bb.4:                                ; %B50
	ldr	w8, [x11, #48]
	cmp	w22, w8
	b.hs	LBB351_15
; %bb.5:                                ; %B7
	ldr	x8, [x11, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB351_24
; %bb.6:                                ; %B9
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB351_7:                               ; %B59
	cmp	w8, #1
	b.ne	LBB351_45
; %bb.8:                                ; %B107
	ldr	w8, [x11, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB351_45
; %bb.9:                                ; %B107
	mov	x9, #2                          ; =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB351_45
; %bb.10:                               ; %B62
	and	x1, x22, #0xfffffffffffc
	stp	x11, x20, [sp]                  ; 16-byte Folded Spill
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB351_25
; %bb.11:                               ; %B106
	ldr	w8, [x1, #8]
	b	LBB351_26
LBB351_12:                              ; %B55
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB351_45
; %bb.13:                               ; %B55
	cmp	w8, #29
	b.gt	LBB351_45
; %bb.14:                               ; %B56
	str	x21, [x20], #8
	add	sp, sp, #16
	b	l_FastTypedArraySet_asm_h
LBB351_15:                              ; %B12
	mov	x1, x11
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	b.ne	LBB351_37
; %bb.16:                               ; %B40
	ldr	w9, [x1, #4]
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x11, x1
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	b.ne	LBB351_45
; %bb.17:                               ; %B40
	ubfx	w9, w9, #8, #1
	cbz	w9, LBB351_45
; %bb.18:                               ; %B14
	ldr	x9, [x11, #8]
	ldr	x9, [x9, #32]
	cbz	x9, LBB351_20
; %bb.19:                               ; %B36
	ldr	w9, [x9, #4]
	ubfx	w9, w9, #13, #1
	cmp	w9, #1
	b.ne	LBB351_45
LBB351_20:                              ; %B32
	ldr	x9, [x11, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	LBB351_22
; %bb.21:                               ; %B32
	cmp	w9, w10
	b.hi	LBB351_39
LBB351_22:                              ; %B29
	ldr	w10, [x1, #32]
	cmp	w9, w10
	b.hi	LBB351_39
; %bb.23:                               ; %B25
	ldr	x10, [x1, #40]
	str	w9, [x1, #48]
	str	x21, [x10, w8, sxtw #3]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB351_46
	b	LBB351_42
LBB351_24:                              ; %B11
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB351_25:                              ; %B63
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
LBB351_26:                              ; %B102
	asr	w8, w8, #30
	ldp	x11, x20, [sp]                  ; 16-byte Folded Reload
	cmp	w8, #1
	b.ne	LBB351_45
; %bb.27:                               ; %B64
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	ldp	x11, x20, [sp]                  ; 16-byte Folded Reload
	cbz	w0, LBB351_45
; %bb.28:                               ; %B66
	ldr	x8, [x11, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w0, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB351_31
LBB351_29:                              ; %B69
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	LBB351_40
; %bb.30:                               ; %B78
                                        ;   in Loop: Header=BB351_29 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB351_29
LBB351_31:                              ; %B80.preheader
	ldp	x8, x20, [sp]                   ; 16-byte Folded Reload
LBB351_32:                              ; %B80
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB351_33 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w0, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB351_35
LBB351_33:                              ; %B93
                                        ;   Parent Loop BB351_32 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	LBB351_43
; %bb.34:                               ; %B98
                                        ;   in Loop: Header=BB351_33 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB351_33
LBB351_35:                              ; %B81
                                        ;   in Loop: Header=BB351_32 Depth=1
	ldr	w9, [x8, #4]
	ldr	x11, [sp]                       ; 8-byte Folded Reload
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB351_45
; %bb.36:                               ; %B87
                                        ;   in Loop: Header=BB351_32 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB351_32
	b	LBB351_44
LBB351_37:                              ; %B44
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x11, x1
	tbnz	w22, #31, LBB351_45
; %bb.38:                               ; %B46
	mov	x8, x20
	mov	x0, x24
	mov	x1, x11
	mov	w2, w22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_SetArrayIntPropertyValue_GC
	tbz	w0, #31, LBB351_46
	b	LBB351_48
LBB351_39:                              ; %B20
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, x24
	mov	x2, x21
	mov	w3, #32768                      ; =0x8000
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_add_fast_array_element_gc
	tbz	w0, #31, LBB351_46
	b	LBB351_48
LBB351_40:                              ; %B71
	mov	w9, #58                         ; =0x3a
	ldp	x11, x20, [sp]                  ; 16-byte Folded Reload
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	LBB351_45
; %bb.41:                               ; %B74
	ldr	x9, [x11, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB351_46
LBB351_42:                              ; %B76
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #16
	br	x1
LBB351_43:                              ; %B95
	mov	w8, #58                         ; =0x3a
	ldp	x11, x20, [sp]                  ; 16-byte Folded Reload
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	LBB351_45
LBB351_44:                              ; %B84
	ldr	w8, [x11, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.eq	LBB351_47
LBB351_45:                              ; %B113
	mov	x8, x20
	mov	x0, x24
	mov	x1, x11
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_SetPropertyValue_GC
	tbnz	w0, #31, LBB351_48
LBB351_46:                              ; %B73
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #16
	br	x1
LBB351_47:                              ; %B85
	str	x21, [x20], #8
	mov	w0, w0
	add	sp, sp, #16
	b	l_FastAddNamedProperty_asm_h
LBB351_48:                              ; %B47
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_super_value_1_asm_h
l_get_super_value_1_asm_h:              ; @get_super_value_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_get_super_value_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_super_value_1_asm_h
l_put_super_value_1_asm_h:              ; @put_super_value_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_put_super_value_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_field_1_asm_h
l_define_field_1_asm_h:                 ; @define_field_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_define_field_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_name_1_asm_h
l_set_name_1_asm_h:                     ; @set_name_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_set_name_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_name_computed_1_asm_h
l_set_name_computed_1_asm_h:            ; @set_name_computed_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_set_name_computed_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_proto_1_asm_h
l_set_proto_1_asm_h:                    ; @set_proto_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_set_proto_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_home_object_1_asm_h
l_set_home_object_1_asm_h:              ; @set_home_object_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_set_home_object_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_array_el_1_asm_h
l_define_array_el_1_asm_h:              ; @define_array_el_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_define_array_el_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function append_1_asm_h
l_append_1_asm_h:                       ; @append_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_append_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function copy_data_properties_1_asm_h
l_copy_data_properties_1_asm_h:         ; @copy_data_properties_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_copy_data_properties_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_method_1_asm_h
l_define_method_1_asm_h:                ; @define_method_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_define_method_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_method_computed_1_asm_h
l_define_method_computed_1_asm_h:       ; @define_method_computed_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_define_method_computed_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_class_1_asm_h
l_define_class_1_asm_h:                 ; @define_class_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_define_class_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc_1_asm_h
l_get_loc_1_asm_h:                      ; @get_loc_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #486
	ldr	x21, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc_1_asm_h
l_put_loc_1_asm_h:                      ; @put_loc_1_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc_1_asm_h
l_set_loc_1_asm_h:                      ; @set_loc_1_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_arg_1_asm_h
l_get_arg_1_asm_h:                      ; @get_arg_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #486
	ldr	x21, [x28, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_arg_1_asm_h
l_put_arg_1_asm_h:                      ; @put_arg_1_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_arg_1_asm_h
l_set_arg_1_asm_h:                      ; @set_arg_1_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref_1_asm_h
l_get_var_ref_1_asm_h:                  ; @get_var_ref_1_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x8, [x26, x8, lsl #3]
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8]
	ldr	x21, [x8]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref_1_asm_h
l_put_var_ref_1_asm_h:                  ; @put_var_ref_1_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_var_ref_1_asm_h
l_set_var_ref_1_asm_h:                  ; @set_var_ref_1_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc_uninitialized_1_asm_h
l_set_loc_uninitialized_1_asm_h:        ; @set_loc_uninitialized_1_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	mov	w9, #34                         ; =0x22
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc_check_1_asm_h
l_get_loc_check_1_asm_h:                ; @get_loc_check_1_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	LBB375_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB375_2:                               ; %B3
	str	x22, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc_check_1_asm_h
l_put_loc_check_1_asm_h:                ; @put_loc_check_1_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	LBB376_2
; %bb.1:                                ; %B4
	str	x22, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB376_2:                               ; %B3
	str	x22, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc_check_init_1_asm_h
l_put_loc_check_init_1_asm_h:           ; @put_loc_check_init_1_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	LBB377_2
; %bb.1:                                ; %B4
	str	x22, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB377_2:                               ; %B3
	str	x22, [x20], #8
	b	l_ThrowThisReferenceError_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref_check_1_asm_h
l_get_var_ref_check_1_asm_h:            ; @get_var_ref_check_1_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	LBB378_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB378_2:                               ; %B3
	str	x22, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref_check_1_asm_h
l_put_var_ref_check_1_asm_h:            ; @put_var_ref_check_1_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	LBB379_2
; %bb.1:                                ; %B4
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB379_2:                               ; %B3
	str	x22, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref_check_init_1_asm_h
l_put_var_ref_check_init_1_asm_h:       ; @put_var_ref_check_init_1_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	LBB380_2
; %bb.1:                                ; %B4
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB380_2:                               ; %B3
	str	x22, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function close_loc_1_asm_h
l_close_loc_1_asm_h:                    ; @close_loc_1_asm_h
; %bb.0:                                ; %B0
	ldrh	w2, [x19]
	mov	x0, x24
	mov	x1, x23
	bl	_close_lexical_var
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_false_1_asm_h
l_if_false_1_asm_h:                     ; @if_false_1_asm_h
; %bb.0:                                ; %B29
	cmp	x22, #5
	b.le	LBB382_4
; %bb.1:                                ; %B29
	cmp	x22, #6
	b.eq	LBB382_6
; %bb.2:                                ; %B29
	cmp	x22, #7
	b.eq	LBB382_10
; %bb.3:                                ; %B29
	cmp	x22, #18
	b.eq	LBB382_6
	b	LBB382_8
LBB382_4:                               ; %B29
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB382_6
; %bb.5:                                ; %B29
	cmp	x22, #2
	b.ne	LBB382_8
LBB382_6:                               ; %B8
	ldrsw	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB382_11
LBB382_7:                               ; %B10
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB382_8:                               ; %B15
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB382_16
; %bb.9:                                ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB382_13
LBB382_10:                              ; %B25
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB382_11:                              ; %B5
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB382_7
; %bb.12:                               ; %B6
	add	x19, x19, #1
	b	l_PollInterrupts_asm_h
LBB382_13:                              ; %B19
	tst	x22, #0xfffe000000000000
	b.eq	LBB382_16
; %bb.14:                               ; %B23
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB382_6
	b.vs	LBB382_6
; %bb.15:                               ; %B23
	tbnz	w8, #0, LBB382_10
	b	LBB382_6
LBB382_16:                              ; %B21
	str	x22, [x20], #8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_true_1_asm_h
l_if_true_1_asm_h:                      ; @if_true_1_asm_h
; %bb.0:                                ; %B29
	cmp	x22, #5
	b.le	LBB383_4
; %bb.1:                                ; %B29
	cmp	x22, #6
	b.eq	LBB383_6
; %bb.2:                                ; %B29
	cmp	x22, #7
	b.eq	LBB383_9
; %bb.3:                                ; %B29
	cmp	x22, #18
	b.eq	LBB383_6
	b	LBB383_7
LBB383_4:                               ; %B29
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB383_6
; %bb.5:                                ; %B29
	cmp	x22, #2
	b.ne	LBB383_7
LBB383_6:                               ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB383_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB383_16
; %bb.8:                                ; %B11
	mov	x8, #-562949953421313           ; =0xfffdffffffffffff
	cmp	x22, x8
	b.ls	LBB383_13
LBB383_9:                               ; %B23
	ldrsw	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB383_11
LBB383_10:                              ; %B25
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB383_11:                              ; %B20
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB383_10
; %bb.12:                               ; %B21
	add	x19, x19, #1
	b	l_PollInterrupts_asm_h
LBB383_13:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB383_16
; %bb.14:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB383_6
	b.vs	LBB383_6
; %bb.15:                               ; %B17
	tbnz	w8, #0, LBB383_9
	b	LBB383_6
LBB383_16:                              ; %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto_1_asm_h
l_goto_1_asm_h:                         ; @goto_1_asm_h
; %bb.0:                                ; %B5
	ldrsw	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB384_2
LBB384_1:                               ; %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB384_2:                               ; %B2
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB384_1
; %bb.3:                                ; %B3
	add	x19, x19, #1
	b	l_PollInterrupts_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function catch_1_asm_h
l_catch_1_asm_h:                        ; @catch_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_catch_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function gosub_1_asm_h
l_gosub_1_asm_h:                        ; @gosub_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_gosub_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function ret_1_asm_h
l_ret_1_asm_h:                          ; @ret_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_ret_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function to_object_1_asm_h
l_to_object_1_asm_h:                    ; @to_object_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_to_object_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function to_propkey_1_asm_h
l_to_propkey_1_asm_h:                   ; @to_propkey_1_asm_h
; %bb.0:                                ; %B15
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	LBB389_4
; %bb.1:                                ; %B15
	mov	x9, #1                          ; =0x1
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB389_4
; %bb.2:                                ; %B15
	cmp	x8, x9
	b.eq	LBB389_4
; %bb.3:                                ; %B15
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB389_5
LBB389_4:                               ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB389_5:                               ; %B12
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB389_7
; %bb.6:                                ; %B14
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB389_7:                               ; %B13
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function to_propkey2_1_asm_h
l_to_propkey2_1_asm_h:                  ; @to_propkey2_1_asm_h
; %bb.0:                                ; %B18
	mov	x21, x22
	ldur	x22, [x20, #-8]
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	LBB390_3
; %bb.1:                                ; %B19
	mov	x8, x20
Lloh22:
	adrp	x1, l___unnamed_12@PAGE
Lloh23:
	add	x1, x1, l___unnamed_12@PAGEOFF
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_LEPUS_ThrowTypeError
LBB390_2:                               ; %B16
	b	l_exception_spill_top1_asm_h
LBB390_3:                               ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	LBB390_7
; %bb.4:                                ; %B2
	mov	x9, #1                          ; =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB390_7
; %bb.5:                                ; %B2
	cmp	x8, x9
	b.eq	LBB390_7
; %bb.6:                                ; %B2
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB390_8
LBB390_7:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB390_8:                               ; %B15
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB390_2
; %bb.9:                                ; %B17
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh22, Lloh23
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_get_var_1_asm_h
l_with_get_var_1_asm_h:                 ; @with_get_var_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_with_get_var_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_put_var_1_asm_h
l_with_put_var_1_asm_h:                 ; @with_put_var_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_with_put_var_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_delete_var_1_asm_h
l_with_delete_var_1_asm_h:              ; @with_delete_var_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_with_delete_var_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_make_ref_1_asm_h
l_with_make_ref_1_asm_h:                ; @with_make_ref_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_with_make_ref_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_get_ref_1_asm_h
l_with_get_ref_1_asm_h:                 ; @with_get_ref_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_with_get_ref_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_get_ref_undef_1_asm_h
l_with_get_ref_undef_1_asm_h:           ; @with_get_ref_undef_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_with_get_ref_undef_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function make_loc_ref_1_asm_h
l_make_loc_ref_1_asm_h:                 ; @make_loc_ref_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_make_loc_ref_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function make_arg_ref_1_asm_h
l_make_arg_ref_1_asm_h:                 ; @make_arg_ref_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_make_arg_ref_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function make_var_ref_ref_1_asm_h
l_make_var_ref_ref_1_asm_h:             ; @make_var_ref_ref_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_make_var_ref_ref_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function make_var_ref_1_asm_h
l_make_var_ref_1_asm_h:                 ; @make_var_ref_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_make_var_ref_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_in_start_1_asm_h
l_for_in_start_1_asm_h:                 ; @for_in_start_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_for_in_start_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_of_start_1_asm_h
l_for_of_start_1_asm_h:                 ; @for_of_start_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_for_of_start_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_await_of_start_1_asm_h
l_for_await_of_start_1_asm_h:           ; @for_await_of_start_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_for_await_of_start_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_in_next_1_asm_h
l_for_in_next_1_asm_h:                  ; @for_in_next_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_for_in_next_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_of_next_1_asm_h
l_for_of_next_1_asm_h:                  ; @for_of_next_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_for_of_next_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_await_of_next_1_asm_h
l_for_await_of_next_1_asm_h:            ; @for_await_of_next_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_for_await_of_next_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function iterator_get_value_done_1_asm_h
l_iterator_get_value_done_1_asm_h:      ; @iterator_get_value_done_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_iterator_get_value_done_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function iterator_close_1_asm_h
l_iterator_close_1_asm_h:               ; @iterator_close_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_iterator_close_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function iterator_close_return_1_asm_h
l_iterator_close_return_1_asm_h:        ; @iterator_close_return_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_iterator_close_return_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function async_iterator_close_1_asm_h
l_async_iterator_close_1_asm_h:         ; @async_iterator_close_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_async_iterator_close_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function async_iterator_next_1_asm_h
l_async_iterator_next_1_asm_h:          ; @async_iterator_next_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_async_iterator_next_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function async_iterator_get_1_asm_h
l_async_iterator_get_1_asm_h:           ; @async_iterator_get_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_async_iterator_get_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function initial_yield_1_asm_h
l_initial_yield_1_asm_h:                ; @initial_yield_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_initial_yield_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function yield_1_asm_h
l_yield_1_asm_h:                        ; @yield_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_yield_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function yield_star_1_asm_h
l_yield_star_1_asm_h:                   ; @yield_star_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_yield_star_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function async_yield_star_1_asm_h
l_async_yield_star_1_asm_h:             ; @async_yield_star_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_async_yield_star_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function await_1_asm_h
l_await_1_asm_h:                        ; @await_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_await_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function neg_1_asm_h
l_neg_1_asm_h:                          ; @neg_1_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB418_3
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB418_6
; %bb.2:                                ; %B13
	orr	w8, w22, #0x80000000
	mov	w9, #-2147483648                ; =0x80000000
	cmp	w8, w9
	b.ne	LBB418_5
LBB418_3:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        ; =0x8c
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB418_8
; %bb.4:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB418_5:                               ; %B15
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB418_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB418_3
; %bb.7:                                ; %B7
	movi	d0, #0000000000000000
	add	x8, x22, x8
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	fsub	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
LBB418_8:                               ; %B17
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function plus_1_asm_h
l_plus_1_asm_h:                         ; @plus_1_asm_h
; %bb.0:                                ; %B13
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB419_4
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB419_3
LBB419_2:                               ; %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB419_3:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.ne	LBB419_2
LBB419_4:                               ; %B10
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        ; =0x8d
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB419_6
; %bb.5:                                ; %B12
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB419_6:                               ; %B11
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function dec_1_asm_h
l_dec_1_asm_h:                          ; @dec_1_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB420_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB420_4
; %bb.2:                                ; %B13
	subs	w8, w22, #1
	b.vs	LBB420_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB420_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB420_6
; %bb.5:                                ; %B7
	add	x8, x22, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
LBB420_6:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        ; =0x8e
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB420_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB420_8:                               ; %B17
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function inc_1_asm_h
l_inc_1_asm_h:                          ; @inc_1_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB421_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB421_4
; %bb.2:                                ; %B13
	adds	w8, w22, #1
	b.vs	LBB421_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB421_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB421_6
; %bb.5:                                ; %B7
	add	x8, x22, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x22, x9, x8, vc
	br	x1
LBB421_6:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        ; =0x8f
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB421_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB421_8:                               ; %B17
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function post_dec_1_asm_h
l_post_dec_1_asm_h:                     ; @post_dec_1_asm_h
; %bb.0:                                ; %B16
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB422_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB422_4
; %bb.2:                                ; %B13
	subs	w8, w22, #1
	b.vs	LBB422_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB422_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB422_6
; %bb.5:                                ; %B8
	add	x8, x22, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
LBB422_6:                               ; %B5
	str	x22, [x20], #8
	mov	w0, #144                        ; =0x90
	b	l_SlowJSPostInc_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function post_inc_1_asm_h
l_post_inc_1_asm_h:                     ; @post_inc_1_asm_h
; %bb.0:                                ; %B16
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB423_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB423_4
; %bb.2:                                ; %B13
	adds	w8, w22, #1
	b.vs	LBB423_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB423_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB423_6
; %bb.5:                                ; %B8
	add	x8, x22, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
LBB423_6:                               ; %B5
	str	x22, [x20], #8
	mov	w0, #145                        ; =0x91
	b	l_SlowJSPostInc_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function dec_loc_1_asm_h
l_dec_loc_1_asm_h:                      ; @dec_loc_1_asm_h
; %bb.0:                                ; %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	LBB424_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB424_4
; %bb.2:                                ; %B13
	subs	w9, w1, #1
	b.vs	LBB424_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB424_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB424_6
; %bb.5:                                ; %B8
	add	x9, x1, x9
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       ; =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB424_6:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	w2, #142                        ; =0x8e
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB424_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB424_8:                               ; %B17
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function inc_loc_1_asm_h
l_inc_loc_1_asm_h:                      ; @inc_loc_1_asm_h
; %bb.0:                                ; %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	LBB425_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB425_4
; %bb.2:                                ; %B13
	adds	w9, w1, #1
	b.vs	LBB425_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB425_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB425_6
; %bb.5:                                ; %B8
	add	x9, x1, x9
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       ; =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB425_6:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	w2, #143                        ; =0x8f
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB425_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB425_8:                               ; %B17
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function add_loc_1_asm_h
l_add_loc_1_asm_h:                      ; @add_loc_1_asm_h
; %bb.0:                                ; %B46
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	ccmp	x22, x9, #2, ls
	b.hi	LBB426_16
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB426_5
; %bb.2:                                ; %B26
	cmp	x22, x9
	b.lo	LBB426_8
; %bb.3:                                ; %B36
	adds	w9, w1, w22
	b.vs	LBB426_11
; %bb.4:                                ; %B42
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB426_5:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB426_16
; %bb.6:                                ; %B11
	cmp	x22, x9
	b.lo	LBB426_14
; %bb.7:                                ; %B21
	scvtf	d0, w22
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	LBB426_13
LBB426_8:                               ; %B28
	tst	x22, #0xfffe000000000000
	b.eq	LBB426_16
; %bb.9:                                ; %B31
	scvtf	d0, w1
	add	x9, x22, x9
LBB426_10:                              ; %B31
	fmov	d1, x9
	b	LBB426_12
LBB426_11:                              ; %B38
	scvtf	d0, w1
	scvtf	d1, w22
LBB426_12:                              ; %B31
	fadd	d0, d0, d1
LBB426_13:                              ; %B31
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	add	x9, x9, x10
	mov	x10, #9221683186994511872       ; =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB426_14:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB426_16
; %bb.15:                               ; %B16
	add	x10, x1, x9
	add	x9, x22, x9
	fmov	d0, x10
	b	LBB426_10
LBB426_16:                              ; %B7
	and	x8, x22, #0xffff000000000003
	mov	x9, #-281474976710653           ; =0xffff000000000003
	mov	x10, #2                         ; =0x2
	cmp	x8, x9
	movk	x10, #1, lsl #48
	and	x11, x1, #0xffff000000000003
	ccmp	x8, x10, #4, ne
	cset	w8, eq
	cmp	x11, x10
	ccmp	x11, x9, #4, ne
	ccmp	w8, #0, #4, eq
	add	x8, x20, #8
	b.ne	LBB426_19
; %bb.17:                               ; %B43
	mov	x0, x24
	mov	x2, x22
	stur	x22, [x8, #-8]
	str	x8, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB426_20
; %bb.18:                               ; %B45
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB426_19:                              ; %B8
	mov	x20, x8
	stur	x22, [x8, #-8]
	mov	w0, #1                          ; =0x1
	b	l_FastJSConcatString_asm_h
LBB426_20:                              ; %B44
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function not_1_asm_h
l_not_1_asm_h:                          ; @not_1_asm_h
; %bb.0:                                ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB427_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB427_2:                               ; %B4
	str	x22, [x20], #8
	mov	x0, x22
	b	l_SlowJSNot_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lnot_1_asm_h
l_lnot_1_asm_h:                         ; @lnot_1_asm_h
; %bb.0:                                ; %B14
	cmp	x22, #5
	b.le	LBB428_4
; %bb.1:                                ; %B14
	cmp	x22, #6
	b.eq	LBB428_6
; %bb.2:                                ; %B14
	cmp	x22, #7
	b.eq	LBB428_8
; %bb.3:                                ; %B14
	cmp	x22, #18
	b.eq	LBB428_6
	b	LBB428_7
LBB428_4:                               ; %B14
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB428_6
; %bb.5:                                ; %B14
	cmp	x22, #2
	b.ne	LBB428_7
LBB428_6:                               ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB428_7:                               ; %B10
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB428_9
LBB428_8:                               ; %B12
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB428_9:                               ; %B13
	str	x22, [x20], #8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function typeof_1_asm_h
l_typeof_1_asm_h:                       ; @typeof_1_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x22
	bl	_js_operator_typeof_gc
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB429_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB429_2:                               ; %B2
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function delete_1_asm_h
l_delete_1_asm_h:                       ; @delete_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_delete_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function delete_var_1_asm_h
l_delete_var_1_asm_h:                   ; @delete_var_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_delete_var_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function mul_1_asm_h
l_mul_1_asm_h:                          ; @mul_1_asm_h
; %bb.0:                                ; %B51
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB432_19
; %bb.1:                                ; %B51
	cmp	x21, x8
	b.hi	LBB432_19
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB432_8
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB432_11
; %bb.4:                                ; %B33
	smull	x8, w22, w21
	sub	x20, x20, #8
	cmp	x8, w8, sxtw
	b.ne	LBB432_15
; %bb.5:                                ; %B40
	cbnz	w8, LBB432_7
; %bb.6:                                ; %B40
	orr	w9, w22, w21
	tbnz	w9, #31, LBB432_16
LBB432_7:                               ; %B47
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB432_8:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB432_19
; %bb.9:                                ; %B7
	cmp	x21, x8
	b.lo	LBB432_17
; %bb.10:                               ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	LBB432_14
LBB432_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB432_19
; %bb.12:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB432_13:                              ; %B28
	fmov	d1, x8
	fmul	d0, d0, d1
LBB432_14:                              ; %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB432_15:                              ; %B35
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           ; =0x2000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	fmul	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB432_16:                              ; %B44
	mov	x22, #-9222809086901354496      ; =0x8002000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB432_17:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB432_19
; %bb.18:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB432_13
LBB432_19:                              ; %B48
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        ; =0x9a
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB432_21
; %bb.20:                               ; %B50
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB432_21:                              ; %B49
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function div_1_asm_h
l_div_1_asm_h:                          ; @div_1_asm_h
; %bb.0:                                ; %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB433_14
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB433_14
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB433_5
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB433_8
; %bb.4:                                ; %B33
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x8, #562949953421312            ; =0x2000000000000
	ldrb	w10, [x19], #1
	mov	x12, #9221683186994511872       ; =0x7ffa000000000000
	sub	x20, x20, #8
	add	w10, w10, #243
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
LBB433_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB433_14
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB433_12
; %bb.7:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	LBB433_11
LBB433_8:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB433_14
; %bb.9:                                ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB433_10:                              ; %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
LBB433_11:                              ; %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB433_12:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB433_14
; %bb.13:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB433_10
LBB433_14:                              ; %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        ; =0x9b
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB433_16
; %bb.15:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB433_16:                              ; %B42
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function mod_1_asm_h
l_mod_1_asm_h:                          ; @mod_1_asm_h
; %bb.0:                                ; %B39
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB434_16
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB434_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB434_7
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB434_10
; %bb.4:                                ; %B33
	tbnz	w22, #31, LBB434_16
; %bb.5:                                ; %B33
	cmp	w21, #1
	b.lt	LBB434_16
; %bb.6:                                ; %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB434_7:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB434_16
; %bb.8:                                ; %B7
	cmp	x21, x8
	b.lo	LBB434_14
; %bb.9:                                ; %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	LBB434_13
LBB434_10:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB434_16
; %bb.11:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB434_12:                              ; %B28
	fmov	d1, x8
LBB434_13:                              ; %B28
	bl	_fmod
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB434_14:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB434_16
; %bb.15:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB434_12
LBB434_16:                              ; %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        ; =0x9c
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB434_18
; %bb.17:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB434_18:                              ; %B37
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function add_1_asm_h
l_add_1_asm_h:                          ; @add_1_asm_h
; %bb.0:                                ; %B46
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB435_16
; %bb.1:                                ; %B46
	cmp	x21, x8
	b.hi	LBB435_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB435_6
; %bb.3:                                ; %B26
	cmp	x21, x8
	b.lo	LBB435_9
; %bb.4:                                ; %B36
	adds	w8, w22, w21
	sub	x20, x20, #8
	b.vs	LBB435_13
; %bb.5:                                ; %B42
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB435_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB435_16
; %bb.7:                                ; %B11
	cmp	x21, x8
	b.lo	LBB435_14
; %bb.8:                                ; %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	LBB435_12
LBB435_9:                               ; %B28
	tst	x21, #0xfffe000000000000
	b.eq	LBB435_16
; %bb.10:                               ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB435_11:                              ; %B31
	fmov	d1, x8
	fadd	d0, d0, d1
LBB435_12:                              ; %B31
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB435_13:                              ; %B38
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           ; =0x2000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	fadd	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB435_14:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB435_16
; %bb.15:                               ; %B16
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB435_11
LBB435_16:                              ; %B7
	and	x8, x21, #0xffff000000000003
	mov	x10, #-281474976710653          ; =0xffff000000000003
	mov	x11, #2                         ; =0x2
	cmp	x8, x10
	movk	x11, #1, lsl #48
	and	x12, x22, #0xffff000000000003
	ccmp	x8, x11, #4, ne
	add	x8, x20, #8
	cset	w9, eq
	cmp	x12, x11
	ccmp	x12, x10, #4, ne
	b.ne	LBB435_19
; %bb.17:                               ; %B7
	cbz	w9, LBB435_19
; %bb.18:                               ; %B8
	mov	x20, x8
	stur	x21, [x8, #-8]
	mov	x0, xzr
	b	l_FastJSConcatString_asm_h
LBB435_19:                              ; %B43
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stur	x21, [x8, #-8]
	str	x8, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB435_21
; %bb.20:                               ; %B45
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB435_21:                              ; %B44
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function sub_1_asm_h
l_sub_1_asm_h:                          ; @sub_1_asm_h
; %bb.0:                                ; %B43
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB436_16
; %bb.1:                                ; %B43
	cmp	x21, x8
	b.hi	LBB436_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB436_6
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB436_9
; %bb.4:                                ; %B33
	subs	w8, w22, w21
	sub	x20, x20, #8
	b.vs	LBB436_13
; %bb.5:                                ; %B39
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB436_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB436_16
; %bb.7:                                ; %B7
	cmp	x21, x8
	b.lo	LBB436_14
; %bb.8:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	LBB436_12
LBB436_9:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB436_16
; %bb.10:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB436_11:                              ; %B28
	fmov	d1, x8
	fsub	d0, d0, d1
LBB436_12:                              ; %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB436_13:                              ; %B35
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           ; =0x2000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	fsub	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB436_14:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB436_16
; %bb.15:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB436_11
LBB436_16:                              ; %B40
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        ; =0x9e
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB436_18
; %bb.17:                               ; %B42
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB436_18:                              ; %B41
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function pow_1_asm_h
l_pow_1_asm_h:                          ; @pow_1_asm_h
; %bb.0:                                ; %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	mov	w3, #159                        ; =0x9f
	mov	x1, x22
	str	x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB437_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB437_2:                               ; %B2
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function shl_1_asm_h
l_shl_1_asm_h:                          ; @shl_1_asm_h
; %bb.0:                                ; %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB438_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB438_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB438_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB438_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB438_5:                               ; %B16
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #8
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB438_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB438_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB438_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB438_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB438_5
LBB438_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        ; =0xa0
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB438_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB438_12:                              ; %B26
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function sar_1_asm_h
l_sar_1_asm_h:                          ; @sar_1_asm_h
; %bb.0:                                ; %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB439_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB439_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB439_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB439_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB439_5:                               ; %B16
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #8
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB439_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB439_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB439_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB439_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB439_5
LBB439_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        ; =0xa1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB439_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB439_12:                              ; %B26
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function shr_1_asm_h
l_shr_1_asm_h:                          ; @shr_1_asm_h
; %bb.0:                                ; %B36
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB440_11
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB440_11
; %bb.2:                                ; %B10
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB440_6
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB440_11
; %bb.4:                                ; %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, LBB440_10
LBB440_5:                               ; %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB440_6:                               ; %B12
	tst	x22, #0xfffe000000000000
	b.eq	LBB440_11
; %bb.7:                                ; %B12
	cmp	x21, x8
	b.lo	LBB440_11
; %bb.8:                                ; %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB440_11
; %bb.9:                                ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, LBB440_5
LBB440_10:                              ; %B6
	ucvtf	d0, w8
	mov	x9, #562949953421312            ; =0x2000000000000
	fmov	x8, d0
	fcmp	d0, d0
	add	x8, x8, x9
	mov	x9, #9221683186994511872        ; =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB440_11:                              ; %B33
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	LBB440_13
; %bb.12:                               ; %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB440_13:                              ; %B34
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lt_1_asm_h
l_lt_1_asm_h:                           ; @lt_1_asm_h
; %bb.0:                                ; %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB441_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB441_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB441_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB441_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, lt
	br	x1
LBB441_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB441_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB441_10
; %bb.7:                                ; %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, mi
	br	x1
LBB441_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB441_12
; %bb.9:                                ; %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, mi
	br	x1
LBB441_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB441_12
; %bb.11:                               ; %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, mi
	br	x1
LBB441_12:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        ; =0xa3
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB441_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB441_14:                              ; %B22
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lte_1_asm_h
l_lte_1_asm_h:                          ; @lte_1_asm_h
; %bb.0:                                ; %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB442_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB442_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB442_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB442_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, le
	br	x1
LBB442_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB442_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB442_10
; %bb.7:                                ; %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ls
	br	x1
LBB442_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB442_12
; %bb.9:                                ; %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ls
	br	x1
LBB442_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB442_12
; %bb.11:                               ; %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ls
	br	x1
LBB442_12:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        ; =0xa4
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB442_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB442_14:                              ; %B22
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function gt_1_asm_h
l_gt_1_asm_h:                           ; @gt_1_asm_h
; %bb.0:                                ; %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB443_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB443_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB443_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB443_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB443_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB443_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB443_10
; %bb.7:                                ; %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB443_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB443_12
; %bb.9:                                ; %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB443_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB443_12
; %bb.11:                               ; %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB443_12:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        ; =0xa5
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB443_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB443_14:                              ; %B22
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function gte_1_asm_h
l_gte_1_asm_h:                          ; @gte_1_asm_h
; %bb.0:                                ; %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB444_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB444_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB444_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB444_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB444_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB444_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB444_10
; %bb.7:                                ; %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB444_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB444_12
; %bb.9:                                ; %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB444_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB444_12
; %bb.11:                               ; %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB444_12:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        ; =0xa6
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB444_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB444_14:                              ; %B22
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function instanceof_1_asm_h
l_instanceof_1_asm_h:                   ; @instanceof_1_asm_h
; %bb.0:                                ; %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #48]
	bl	_prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	LBB445_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB445_2:                               ; %B2
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function in_1_asm_h
l_in_1_asm_h:                           ; @in_1_asm_h
; %bb.0:                                ; %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #48]
	bl	_prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	LBB446_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB446_2:                               ; %B2
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function eq_1_asm_h
l_eq_1_asm_h:                           ; @eq_1_asm_h
; %bb.0:                                ; %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB447_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB447_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB447_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB447_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB447_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB447_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB447_11
; %bb.7:                                ; %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #243
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
LBB447_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB447_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB447_10:                              ; %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #243
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
LBB447_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB447_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB447_10
LBB447_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB447_15
LBB447_14:                              ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB447_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB447_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB447_14
	b	LBB447_20
LBB447_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB447_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB447_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB447_21
LBB447_20:                              ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB447_21:                              ; %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB447_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB447_23:                              ; %B42
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function neq_1_asm_h
l_neq_1_asm_h:                          ; @neq_1_asm_h
; %bb.0:                                ; %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB448_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB448_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB448_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB448_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB448_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB448_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB448_11
; %bb.7:                                ; %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #243
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
LBB448_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB448_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB448_10:                              ; %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #243
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
LBB448_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB448_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB448_10
LBB448_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB448_15
LBB448_14:                              ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB448_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB448_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB448_14
	b	LBB448_20
LBB448_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB448_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB448_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB448_21
LBB448_20:                              ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB448_21:                              ; %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB448_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB448_23:                              ; %B42
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function strict_eq_1_asm_h
l_strict_eq_1_asm_h:                    ; @strict_eq_1_asm_h
; %bb.0:                                ; %B39
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB449_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB449_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB449_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB449_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB449_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB449_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB449_11
; %bb.7:                                ; %B28
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #243
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
LBB449_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB449_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB449_10:                              ; %B34
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #243
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
LBB449_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB449_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB449_10
LBB449_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB449_15
; %bb.14:                               ; %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB449_15:                              ; %B13
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          ; =0xffff000000000003
	mov	x12, #2                         ; =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x10, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w9, eq
	cmp	x10, x11
	ccmp	x10, x12, #4, ne
	cset	w11, eq
	cmp	w9, #1
	b.ne	LBB449_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB449_22
LBB449_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB449_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB449_23
LBB449_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB449_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB449_25
LBB449_21:                              ; %B21
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB449_22:                              ; %B14
	str	x21, [x20], #8
	mov	x0, xzr
	b	l_FastStringEqual_asm_h
LBB449_23:                              ; %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB449_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB449_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #8
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB449_28
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB449_27:                              ; %B37
	b	l_exception_spill_top1_asm_h
LBB449_28:                              ; %B8
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function strict_neq_1_asm_h
l_strict_neq_1_asm_h:                   ; @strict_neq_1_asm_h
; %bb.0:                                ; %B39
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB450_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB450_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB450_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB450_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB450_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB450_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB450_11
; %bb.7:                                ; %B28
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #243
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
LBB450_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB450_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB450_10:                              ; %B34
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #243
	sub	x20, x20, #8
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
LBB450_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB450_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB450_10
LBB450_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB450_15
; %bb.14:                               ; %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB450_15:                              ; %B13
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          ; =0xffff000000000003
	mov	x12, #2                         ; =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x10, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w9, eq
	cmp	x10, x11
	ccmp	x10, x12, #4, ne
	cset	w11, eq
	cmp	w9, #1
	b.ne	LBB450_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB450_22
LBB450_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB450_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB450_23
LBB450_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB450_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB450_25
LBB450_21:                              ; %B21
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB450_22:                              ; %B14
	str	x21, [x20], #8
	mov	w0, #1                          ; =0x1
	b	l_FastStringEqual_asm_h
LBB450_23:                              ; %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB450_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB450_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #8
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB450_28
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB450_27:                              ; %B37
	b	l_exception_spill_top1_asm_h
LBB450_28:                              ; %B8
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function and_1_asm_h
l_and_1_asm_h:                          ; @and_1_asm_h
; %bb.0:                                ; %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB451_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB451_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB451_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB451_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB451_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	and	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB451_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB451_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB451_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB451_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB451_5
LBB451_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        ; =0xad
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB451_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB451_12:                              ; %B26
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function xor_1_asm_h
l_xor_1_asm_h:                          ; @xor_1_asm_h
; %bb.0:                                ; %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB452_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB452_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB452_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB452_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB452_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	eor	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB452_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB452_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB452_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB452_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB452_5
LBB452_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        ; =0xae
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB452_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB452_12:                              ; %B26
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function or_1_asm_h
l_or_1_asm_h:                           ; @or_1_asm_h
; %bb.0:                                ; %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB453_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB453_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB453_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB453_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB453_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB453_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB453_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB453_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB453_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB453_5
LBB453_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        ; =0xaf
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB453_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB453_12:                              ; %B26
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function nop_1_asm_h
l_nop_1_asm_h:                          ; @nop_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_minus1_1_asm_h
l_push_minus1_1_asm_h:                  ; @push_minus1_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562945658454017          ; =0xfffe0000ffffffff
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_0_1_asm_h
l_push_0_1_asm_h:                       ; @push_0_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421312          ; =0xfffe000000000000
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_1_1_asm_h
l_push_1_1_asm_h:                       ; @push_1_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421311          ; =0xfffe000000000001
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_2_1_asm_h
l_push_2_1_asm_h:                       ; @push_2_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #2                         ; =0x2
	movk	x21, #65534, lsl #48
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_3_1_asm_h
l_push_3_1_asm_h:                       ; @push_3_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421309          ; =0xfffe000000000003
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_4_1_asm_h
l_push_4_1_asm_h:                       ; @push_4_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #4                         ; =0x4
	movk	x21, #65534, lsl #48
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_5_1_asm_h
l_push_5_1_asm_h:                       ; @push_5_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #5                         ; =0x5
	movk	x21, #65534, lsl #48
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_6_1_asm_h
l_push_6_1_asm_h:                       ; @push_6_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #6                         ; =0x6
	movk	x21, #65534, lsl #48
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_7_1_asm_h
l_push_7_1_asm_h:                       ; @push_7_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421305          ; =0xfffe000000000007
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_i8_1_asm_h
l_push_i8_1_asm_h:                      ; @push_i8_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w9, [x19, #1]
	ldrsb	x10, [x19]
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x19, x19, #2
	add	w9, w9, #486
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x8
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_i16_1_asm_h
l_push_i16_1_asm_h:                     ; @push_i16_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w9, [x19, #2]
	ldrsh	x10, [x19]
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x19, x19, #3
	add	w9, w9, #486
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x8
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_const8_1_asm_h
l_push_const8_1_asm_h:                  ; @push_const8_1_asm_h
; %bb.0:                                ; %B3
	sub	sp, sp, #16
	ldr	x8, [x23, #112]
	ldrb	w9, [x19]
	ldr	w10, [x24, #328]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, LBB466_2
; %bb.1:                                ; %B4
	mov	x8, x20
	mov	x0, x24
	mov	x2, x19
	str	x22, [x8], #8
	str	x8, [x23, #48]
	str	x1, [sp, #8]                    ; 8-byte Folded Spill
	bl	_DebuggerPause
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
LBB466_2:                               ; %B1
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x21, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function fclosure8_1_asm_h
l_fclosure8_1_asm_h:                    ; @fclosure8_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_fclosure8_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_empty_string_1_asm_h
l_push_empty_string_1_asm_h:            ; @push_empty_string_1_asm_h
; %bb.0:                                ; %B1
	mov	x8, x20
	mov	x0, x24
	mov	w1, #47                         ; =0x2f
	mov	w2, #1                          ; =0x1
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB468_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB468_2:                               ; %B2
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc8_1_asm_h
l_get_loc8_1_asm_h:                     ; @get_loc8_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19, #1]
	ldrb	w9, [x19], #2
	add	w8, w8, #486
	ldr	x21, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc8_1_asm_h
l_put_loc8_1_asm_h:                     ; @put_loc8_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc8_1_asm_h
l_set_loc8_1_asm_h:                     ; @set_loc8_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc0_1_asm_h
l_get_loc0_1_asm_h:                     ; @get_loc0_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc1_1_asm_h
l_get_loc1_1_asm_h:                     ; @get_loc1_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27, #8]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc2_1_asm_h
l_get_loc2_1_asm_h:                     ; @get_loc2_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27, #16]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc3_1_asm_h
l_get_loc3_1_asm_h:                     ; @get_loc3_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27, #24]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc0_1_asm_h
l_put_loc0_1_asm_h:                     ; @put_loc0_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x27]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc1_1_asm_h
l_put_loc1_1_asm_h:                     ; @put_loc1_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc2_1_asm_h
l_put_loc2_1_asm_h:                     ; @put_loc2_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc3_1_asm_h
l_put_loc3_1_asm_h:                     ; @put_loc3_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc0_1_asm_h
l_set_loc0_1_asm_h:                     ; @set_loc0_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x27]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc1_1_asm_h
l_set_loc1_1_asm_h:                     ; @set_loc1_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc2_1_asm_h
l_set_loc2_1_asm_h:                     ; @set_loc2_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc3_1_asm_h
l_set_loc3_1_asm_h:                     ; @set_loc3_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_arg0_1_asm_h
l_get_arg0_1_asm_h:                     ; @get_arg0_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_arg1_1_asm_h
l_get_arg1_1_asm_h:                     ; @get_arg1_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28, #8]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_arg2_1_asm_h
l_get_arg2_1_asm_h:                     ; @get_arg2_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28, #16]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_arg3_1_asm_h
l_get_arg3_1_asm_h:                     ; @get_arg3_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28, #24]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_arg0_1_asm_h
l_put_arg0_1_asm_h:                     ; @put_arg0_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x28]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_arg1_1_asm_h
l_put_arg1_1_asm_h:                     ; @put_arg1_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_arg2_1_asm_h
l_put_arg2_1_asm_h:                     ; @put_arg2_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_arg3_1_asm_h
l_put_arg3_1_asm_h:                     ; @put_arg3_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_arg0_1_asm_h
l_set_arg0_1_asm_h:                     ; @set_arg0_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x28]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_arg1_1_asm_h
l_set_arg1_1_asm_h:                     ; @set_arg1_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_arg2_1_asm_h
l_set_arg2_1_asm_h:                     ; @set_arg2_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_arg3_1_asm_h
l_set_arg3_1_asm_h:                     ; @set_arg3_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref0_1_asm_h
l_get_var_ref0_1_asm_h:                 ; @get_var_ref0_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x21, [x8]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref1_1_asm_h
l_get_var_ref1_1_asm_h:                 ; @get_var_ref1_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #8]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x21, [x8]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref2_1_asm_h
l_get_var_ref2_1_asm_h:                 ; @get_var_ref2_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #16]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x21, [x8]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref3_1_asm_h
l_get_var_ref3_1_asm_h:                 ; @get_var_ref3_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #24]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x21, [x8]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref0_1_asm_h
l_put_var_ref0_1_asm_h:                 ; @put_var_ref0_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref1_1_asm_h
l_put_var_ref1_1_asm_h:                 ; @put_var_ref1_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref2_1_asm_h
l_put_var_ref2_1_asm_h:                 ; @put_var_ref2_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref3_1_asm_h
l_put_var_ref3_1_asm_h:                 ; @put_var_ref3_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_var_ref0_1_asm_h
l_set_var_ref0_1_asm_h:                 ; @set_var_ref0_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_var_ref1_1_asm_h
l_set_var_ref1_1_asm_h:                 ; @set_var_ref1_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_var_ref2_1_asm_h
l_set_var_ref2_1_asm_h:                 ; @set_var_ref2_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_var_ref3_1_asm_h
l_set_var_ref3_1_asm_h:                 ; @set_var_ref3_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_length_1_asm_h
l_get_length_1_asm_h:                   ; @get_length_1_asm_h
; %bb.0:                                ; %B27
	mov	x9, #2                          ; =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	LBB508_2
; %bb.1:                                ; %B27
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB508_3
LBB508_2:                               ; %B28
	and	x8, x22, #0xfffffffffffc
	ldrb	w9, [x19], #1
	ldr	w8, [x8, #4]
	mov	x10, #-562949953421312          ; =0xfffe000000000000
	add	w9, w9, #243
	bfxil	x10, x8, #0, #30
	ldr	x1, [x25, w9, uxtw #3]
	mov	x22, x10
	br	x1
LBB508_3:                               ; %B21
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB508_13
; %bb.4:                                ; %B22
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB508_5:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB508_6 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w11, #0x30
	ldr	w10, [x13, w10, uxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB508_8
LBB508_6:                               ; %B1
                                        ;   Parent Loop BB508_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, #48
	b.eq	LBB508_10
; %bb.7:                                ; %B9
                                        ;   in Loop: Header=BB508_6 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB508_6
LBB508_8:                               ; %B14
                                        ;   in Loop: Header=BB508_5 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB508_13
; %bb.9:                                ; %B17
                                        ;   in Loop: Header=BB508_5 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB508_5
	b	LBB508_12
LBB508_10:                              ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB508_13
; %bb.11:                               ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB508_12:                              ; %B6
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB508_13:                              ; %B24
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #48                         ; =0x30
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB508_15
; %bb.14:                               ; %B26
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB508_15:                              ; %B25
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_false8_1_asm_h
l_if_false8_1_asm_h:                    ; @if_false8_1_asm_h
; %bb.0:                                ; %B29
	cmp	x22, #5
	b.le	LBB509_4
; %bb.1:                                ; %B29
	cmp	x22, #6
	b.eq	LBB509_6
; %bb.2:                                ; %B29
	cmp	x22, #7
	b.eq	LBB509_10
; %bb.3:                                ; %B29
	cmp	x22, #18
	b.eq	LBB509_6
	b	LBB509_8
LBB509_4:                               ; %B29
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB509_6
; %bb.5:                                ; %B29
	cmp	x22, #2
	b.ne	LBB509_8
LBB509_6:                               ; %B8
	ldrsb	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB509_11
LBB509_7:                               ; %B10
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB509_8:                               ; %B15
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB509_16
; %bb.9:                                ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB509_13
LBB509_10:                              ; %B25
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB509_11:                              ; %B5
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB509_7
; %bb.12:                               ; %B6
	add	x19, x19, #1
	b	l_PollInterrupts_asm_h
LBB509_13:                              ; %B19
	tst	x22, #0xfffe000000000000
	b.eq	LBB509_16
; %bb.14:                               ; %B23
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB509_6
	b.vs	LBB509_6
; %bb.15:                               ; %B23
	tbnz	w8, #0, LBB509_10
	b	LBB509_6
LBB509_16:                              ; %B21
	str	x22, [x20], #8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_true8_1_asm_h
l_if_true8_1_asm_h:                     ; @if_true8_1_asm_h
; %bb.0:                                ; %B29
	cmp	x22, #5
	b.le	LBB510_4
; %bb.1:                                ; %B29
	cmp	x22, #6
	b.eq	LBB510_6
; %bb.2:                                ; %B29
	cmp	x22, #7
	b.eq	LBB510_9
; %bb.3:                                ; %B29
	cmp	x22, #18
	b.eq	LBB510_6
	b	LBB510_7
LBB510_4:                               ; %B29
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB510_6
; %bb.5:                                ; %B29
	cmp	x22, #2
	b.ne	LBB510_7
LBB510_6:                               ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB510_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB510_16
; %bb.8:                                ; %B11
	mov	x8, #-562949953421313           ; =0xfffdffffffffffff
	cmp	x22, x8
	b.ls	LBB510_13
LBB510_9:                               ; %B23
	ldrsb	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB510_11
LBB510_10:                              ; %B25
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB510_11:                              ; %B20
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB510_10
; %bb.12:                               ; %B21
	add	x19, x19, #1
	b	l_PollInterrupts_asm_h
LBB510_13:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB510_16
; %bb.14:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB510_6
	b.vs	LBB510_6
; %bb.15:                               ; %B17
	tbnz	w8, #0, LBB510_9
	b	LBB510_6
LBB510_16:                              ; %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto8_1_asm_h
l_goto8_1_asm_h:                        ; @goto8_1_asm_h
; %bb.0:                                ; %B5
	ldrsb	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB511_2
LBB511_1:                               ; %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB511_2:                               ; %B2
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB511_1
; %bb.3:                                ; %B3
	add	x19, x19, #1
	b	l_PollInterrupts_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto16_1_asm_h
l_goto16_1_asm_h:                       ; @goto16_1_asm_h
; %bb.0:                                ; %B5
	ldrsh	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB512_2
LBB512_1:                               ; %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB512_2:                               ; %B2
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB512_1
; %bb.3:                                ; %B3
	add	x19, x19, #1
	b	l_PollInterrupts_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call0_1_asm_h
l_call0_1_asm_h:                        ; @call0_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_call0_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call1_1_asm_h
l_call1_1_asm_h:                        ; @call1_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_call1_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call2_1_asm_h
l_call2_1_asm_h:                        ; @call2_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_call2_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call3_1_asm_h
l_call3_1_asm_h:                        ; @call3_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_call3_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function is_undefined_1_asm_h
l_is_undefined_1_asm_h:                 ; @is_undefined_1_asm_h
; %bb.0:                                ; %B2
	cmp	x22, #18
	b.ne	LBB517_2
; %bb.1:                                ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB517_2:                               ; %B5
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function is_null_1_asm_h
l_is_null_1_asm_h:                      ; @is_null_1_asm_h
; %bb.0:                                ; %B2
	cmp	x22, #2
	b.ne	LBB518_2
; %bb.1:                                ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB518_2:                               ; %B5
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function is_function_1_asm_h
l_is_function_1_asm_h:                  ; @is_function_1_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x22
	bl	_js_operator_typeof_gc
	cmp	w0, #27
	b.ne	LBB519_2
; %bb.1:                                ; %B2
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB519_2:                               ; %B5
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function inc_coverage_1_asm_h
l_inc_coverage_1_asm_h:                 ; @inc_coverage_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	l_inc_coverage_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function invalid_2_asm_h
l_invalid_2_asm_h:                      ; @invalid_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x23, #8]
	mov	x0, x24
Lloh24:
	adrp	x1, l___unnamed_13@PAGE
Lloh25:
	add	x1, x1, l___unnamed_13@PAGEOFF
	ldr	x8, [x8, #32]
	ldr	x8, [x8, #8]
	str	x20, [x23, #48]
	mvn	x8, x8
	add	x8, x8, x19
	stp	x8, xzr, [sp, #-16]!
	bl	_LEPUS_ThrowInternalError
	add	sp, sp, #16
	b	l_exception_asm_h
	.loh AdrpAdd	Lloh24, Lloh25
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_i32_2_asm_h
l_push_i32_2_asm_h:                     ; @push_i32_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #4]
	ldr	w9, [x19], #5
	add	w8, w8, #486
	orr	x21, x9, #0xfffe000000000000
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_const_2_asm_h
l_push_const_2_asm_h:                   ; @push_const_2_asm_h
; %bb.0:                                ; %B3
	sub	sp, sp, #16
	str	x22, [x20], #8
	ldr	x8, [x23, #112]
	ldrsw	x9, [x19]
	ldr	w10, [x24, #328]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, LBB523_2
; %bb.1:                                ; %B4
	mov	x8, x20
	mov	x0, x24
	mov	x2, x19
	str	x21, [x8], #8
	str	x8, [x23, #48]
	str	x1, [sp, #8]                    ; 8-byte Folded Spill
	bl	_DebuggerPause
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
LBB523_2:                               ; %B1
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function fclosure_2_asm_h
l_fclosure_2_asm_h:                     ; @fclosure_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_fclosure_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_atom_value_2_asm_h
l_push_atom_value_2_asm_h:              ; @push_atom_value_2_asm_h
; %bb.0:                                ; %B13
	str	x22, [x20], #8
	ldr	w1, [x19]
	tbnz	w1, #31, LBB525_5
; %bb.1:                                ; %B1
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, sxtw #3]
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, LBB525_4
; %bb.2:                                ; %B9
	ldr	w9, [x8, #8]
	asr	w9, w9, #30
	cmp	w9, #1
	b.ne	LBB525_5
LBB525_3:                               ; %B7
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	mov	x9, #2                          ; =0x2
	movk	x9, #1, lsl #48
	orr	x21, x8, x9
	br	x1
LBB525_4:                               ; %B2
	ldr	x9, [x8, #8]
	ldr	w9, [x9]
	asr	w9, w9, #30
	cmp	w9, #1
	b.eq	LBB525_3
LBB525_5:                               ; %B10
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB525_7
; %bb.6:                                ; %B12
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB525_7:                               ; %B11
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function private_symbol_2_asm_h
l_private_symbol_2_asm_h:               ; @private_symbol_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_private_symbol_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function undefined_2_asm_h
l_undefined_2_asm_h:                    ; @undefined_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #18                        ; =0x12
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function null_2_asm_h
l_null_2_asm_h:                         ; @null_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #2                         ; =0x2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_this_2_asm_h
l_push_this_2_asm_h:                    ; @push_this_2_asm_h
; %bb.0:                                ; %B12
	str	x22, [x20], #8
	ldr	w8, [x23, #44]
	ldr	x1, [x23, #88]
	tbnz	w8, #0, LBB529_2
; %bb.1:                                ; %B12
	ldr	x8, [x23, #88]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, LBB529_3
LBB529_2:                               ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
LBB529_3:                               ; %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	LBB529_5
; %bb.4:                                ; %B7
	ldrb	w8, [x19], #1
	ldr	x9, [x24, #208]
	mov	x22, x21
	add	w8, w8, #486
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB529_5:                               ; %B9
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB529_7
; %bb.6:                                ; %B11
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB529_7:                               ; %B10
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_false_2_asm_h
l_push_false_2_asm_h:                   ; @push_false_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #6                         ; =0x6
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_true_2_asm_h
l_push_true_2_asm_h:                    ; @push_true_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #7                         ; =0x7
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function object_2_asm_h
l_object_2_asm_h:                       ; @object_2_asm_h
; %bb.0:                                ; %B16
	sub	sp, sp, #16
	str	x22, [x20], #8
	ldrb	w8, [x24, #363]
	str	x19, [sp, #8]                   ; 8-byte Folded Spill
	cbnz	w8, LBB532_5
; %bb.1:                                ; %B1
	ldr	x19, [x24, #400]
	cbz	x19, LBB532_5
; %bb.2:                                ; %B5
	mov	x8, x20
	mov	x0, x24
	mov	w1, #64                         ; =0x40
	mov	w2, #2                          ; =0x2
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	mov	x9, x0
	cbz	x9, LBB532_5
; %bb.3:                                ; %B7
	ldr	w8, [x19]
	add	w8, w8, #1
	str	w8, [x19]
	mov	w8, #1                          ; =0x1
	str	w8, [x9]
	strb	w8, [x9, #5]
	strh	w8, [x9, #6]
	add	x8, x9, #8
	stlr	x19, [x8]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB532_7
LBB532_4:                               ; %B9
	add	x8, x9, #32
	ldr	x19, [sp, #8]                   ; 8-byte Folded Reload
	mov	x22, x21
	str	x8, [x9, #16]
	mov	x21, x9
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB532_5:                               ; %B13
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	LBB532_8
; %bb.6:                                ; %B15
	ldr	x19, [sp, #8]                   ; 8-byte Folded Reload
	mov	x22, x21
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB532_7:                               ; %B11
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x19, x8
	mov	x19, x9
	bl	_prim_WriteBarrierNoStore
	mov	x9, x19
	b	LBB532_4
LBB532_8:                               ; %B14
	ldr	x19, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function special_object_2_asm_h
l_special_object_2_asm_h:               ; @special_object_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_special_object_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function rest_2_asm_h
l_rest_2_asm_h:                         ; @rest_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_rest_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function drop_2_asm_h
l_drop_2_asm_h:                         ; @drop_2_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function nip_2_asm_h
l_nip_2_asm_h:                          ; @nip_2_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, x21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function nip1_2_asm_h
l_nip1_2_asm_h:                         ; @nip1_2_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function dup_2_asm_h
l_dup_2_asm_h:                          ; @dup_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function dup1_2_asm_h
l_dup1_2_asm_h:                         ; @dup1_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x1, x22
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x22, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function dup2_2_asm_h
l_dup2_2_asm_h:                         ; @dup2_2_asm_h
; %bb.0:                                ; %B0
	stp	x22, x21, [x20], #16
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function dup3_2_asm_h
l_dup3_2_asm_h:                         ; @dup3_2_asm_h
; %bb.0:                                ; %B0
	ldur	x8, [x20, #-8]
	stp	x22, x21, [x20]
	str	x8, [x20, #16]
	add	x20, x20, #24
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function insert2_2_asm_h
l_insert2_2_asm_h:                      ; @insert2_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20]
	mov	x1, x22
	mov	x22, x21
	str	x21, [x20], #8
	mov	x22, x1
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function insert3_2_asm_h
l_insert3_2_asm_h:                      ; @insert3_2_asm_h
; %bb.0:                                ; %B0
	ldur	x8, [x20, #-8]
	stp	x21, x22, [x20, #-8]
	mov	x1, x22
	mov	x22, x21
	str	x8, [x20], #8
	mov	x22, x1
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function insert4_2_asm_h
l_insert4_2_asm_h:                      ; @insert4_2_asm_h
; %bb.0:                                ; %B0
	ldp	x9, x8, [x20, #-16]
	mov	x1, x22
	stur	x21, [x20, #-16]
	stp	x9, x22, [x20, #-8]
	mov	x22, x21
	str	x8, [x20], #8
	mov	x22, x1
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function perm3_2_asm_h
l_perm3_2_asm_h:                        ; @perm3_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function perm4_2_asm_h
l_perm4_2_asm_h:                        ; @perm4_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x22
	ldp	x9, x22, [x20, #-16]
	stp	x8, x9, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function perm5_2_asm_h
l_perm5_2_asm_h:                        ; @perm5_2_asm_h
; %bb.0:                                ; %B0
	ldp	x10, x9, [x20, #-24]
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-24]
	stp	x10, x9, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function swap_2_asm_h
l_swap_2_asm_h:                         ; @swap_2_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x2, x22
	mov	x22, x21
	mov	x21, x2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function swap2_2_asm_h
l_swap2_2_asm_h:                        ; @swap2_2_asm_h
; %bb.0:                                ; %B0
	ldp	x8, x9, [x20, #-16]
	stp	x22, x21, [x20, #-16]
	ldrb	w10, [x19], #1
	add	w10, w10, #486
	mov	x22, x8
	mov	x21, x9
	ldr	x1, [x25, w10, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function rot3l_2_asm_h
l_rot3l_2_asm_h:                        ; @rot3l_2_asm_h
; %bb.0:                                ; %B0
	ldur	x8, [x20, #-8]
	stur	x22, [x20, #-8]
	mov	x22, x21
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function rot3r_2_asm_h
l_rot3r_2_asm_h:                        ; @rot3r_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x21
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function rot4l_2_asm_h
l_rot4l_2_asm_h:                        ; @rot4l_2_asm_h
; %bb.0:                                ; %B0
	ldp	x9, x8, [x20, #-16]
	stp	x8, x22, [x20, #-16]
	mov	x22, x21
	mov	x21, x9
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function rot5l_2_asm_h
l_rot5l_2_asm_h:                        ; @rot5l_2_asm_h
; %bb.0:                                ; %B0
	ldp	x8, x9, [x20, #-16]
	ldur	x10, [x20, #-24]
	stur	x22, [x20, #-8]
	mov	x22, x21
	mov	x21, x10
	stp	x8, x9, [x20, #-24]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function call_constructor_2_asm_h
l_call_constructor_2_asm_h:             ; @call_constructor_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_call_constructor_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call_2_asm_h
l_call_2_asm_h:                         ; @call_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_call_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function tail_call_2_asm_h
l_tail_call_2_asm_h:                    ; @tail_call_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_tail_call_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call_method_2_asm_h
l_call_method_2_asm_h:                  ; @call_method_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_call_method_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function tail_call_method_2_asm_h
l_tail_call_method_2_asm_h:             ; @tail_call_method_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_tail_call_method_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function array_from_2_asm_h
l_array_from_2_asm_h:                   ; @array_from_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_array_from_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function apply_2_asm_h
l_apply_2_asm_h:                        ; @apply_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_apply_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function return_2_asm_h
l_return_2_asm_h:                       ; @return_2_asm_h
; %bb.0:                                ; %B0
	mov	x0, x21
	b	l_common_return_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function return_undef_2_asm_h
l_return_undef_2_asm_h:                 ; @return_undef_2_asm_h
; %bb.0:                                ; %B0
	mov	w0, #18                         ; =0x12
	b	l_common_return_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function check_ctor_return_2_asm_h
l_check_ctor_return_2_asm_h:            ; @check_ctor_return_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_check_ctor_return_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function check_ctor_2_asm_h
l_check_ctor_2_asm_h:                   ; @check_ctor_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_check_ctor_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function check_brand_2_asm_h
l_check_brand_2_asm_h:                  ; @check_brand_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_check_brand_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function add_brand_2_asm_h
l_add_brand_2_asm_h:                    ; @add_brand_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_add_brand_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function return_async_2_asm_h
l_return_async_2_asm_h:                 ; @return_async_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_return_async_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function throw_2_asm_h
l_throw_2_asm_h:                        ; @throw_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_throw_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function throw_var_2_asm_h
l_throw_var_2_asm_h:                    ; @throw_var_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_throw_var_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function eval_2_asm_h
l_eval_2_asm_h:                         ; @eval_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_eval_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function regexp_2_asm_h
l_regexp_2_asm_h:                       ; @regexp_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_regexp_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_super_ctor_2_asm_h
l_get_super_ctor_2_asm_h:               ; @get_super_ctor_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_get_super_ctor_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_super_2_asm_h
l_get_super_2_asm_h:                    ; @get_super_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_get_super_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function import_2_asm_h
l_import_2_asm_h:                       ; @import_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_import_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function check_var_2_asm_h
l_check_var_2_asm_h:                    ; @check_var_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_check_var_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_undef_2_asm_h
l_get_var_undef_2_asm_h:                ; @get_var_undef_2_asm_h
; %bb.0:                                ; %B0
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
	cbz	w11, LBB576_3
LBB576_1:                               ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB576_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB576_1 Depth=1
	ldr	w11, [x12]
	and	w11, w11, #0x3ffffff
	cbnz	w11, LBB576_1
LBB576_3:                               ; %B11
	ldr	x8, [x24, #208]
	mov	w10, #18                        ; =0x12
LBB576_4:                               ; %B33
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB576_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w9, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB576_7
LBB576_5:                               ; %B22
                                        ;   Parent Loop BB576_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w9
	b.eq	LBB576_9
; %bb.6:                                ; %B24
                                        ;   in Loop: Header=BB576_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB576_5
LBB576_7:                               ; %B27
                                        ;   in Loop: Header=BB576_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	LBB576_13
; %bb.8:                                ; %B30
                                        ;   in Loop: Header=BB576_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB576_4
	b	LBB576_11
LBB576_9:                               ; %B12
	lsr	w9, w13, #26
	tst	w9, #0x30
	b.ne	LBB576_13
LBB576_10:                              ; %B7.sink.split
	ldr	x8, [x8, #16]
	sub	w9, w11, #1
	ldr	x10, [x8, w9, sxtw #3]
LBB576_11:                              ; %B7
	cmp	x10, #34
	b.eq	LBB576_15
; %bb.12:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x10
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB576_13:                              ; %B17
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB576_16
; %bb.14:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB576_15:                              ; %B3
	str	x21, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
LBB576_16:                              ; %B18
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_2_asm_h
l_get_var_2_asm_h:                      ; @get_var_2_asm_h
; %bb.0:                                ; %B0
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
	cbz	w10, LBB577_3
LBB577_1:                               ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB577_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB577_1 Depth=1
	ldr	w10, [x12]
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB577_1
LBB577_3:                               ; %B11
	ldr	x8, [x24, #208]
LBB577_4:                               ; %B32
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB577_5 Depth 2
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w9, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB577_7
LBB577_5:                               ; %B21
                                        ;   Parent Loop BB577_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	LBB577_9
; %bb.6:                                ; %B23
                                        ;   in Loop: Header=BB577_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB577_5
LBB577_7:                               ; %B26
                                        ;   in Loop: Header=BB577_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB577_12
; %bb.8:                                ; %B29
                                        ;   in Loop: Header=BB577_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB577_4
	b	LBB577_12
LBB577_9:                               ; %B12
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	LBB577_12
LBB577_10:                              ; %B7
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	LBB577_14
; %bb.11:                               ; %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB577_12:                              ; %B16
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB577_15
; %bb.13:                               ; %B18
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB577_14:                              ; %B3
	str	x21, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
LBB577_15:                              ; %B17
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_2_asm_h
l_put_var_2_asm_h:                      ; @put_var_2_asm_h
; %bb.0:                                ; %B0
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
	cbz	w9, LBB578_3
LBB578_1:                               ; %B1
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w12, w1
	b.eq	LBB578_6
; %bb.2:                                ; %B16
                                        ;   in Loop: Header=BB578_1 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, LBB578_1
LBB578_3:                               ; %B19
	ldr	x8, [x24, #208]
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x12, x9, #64
	lsl	w11, w10, #2
	and	w9, w1, w10
	ldr	w9, [x12, w9, sxtw #2]
	add	w10, w11, #4
	add	x10, x12, x10
	cbz	w9, LBB578_13
LBB578_4:                               ; %B26
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w11, w9, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11]
	cmp	w12, w1
	b.eq	LBB578_10
; %bb.5:                                ; %B31
                                        ;   in Loop: Header=BB578_4 Depth=1
	and	w9, w11, #0x3ffffff
	cbnz	w9, LBB578_4
	b	LBB578_13
LBB578_6:                               ; %B13
	mov	w10, #58                        ; =0x3a
	and	w10, w10, w11, lsr #26
	cmp	w10, #2
	b.ne	LBB578_13
; %bb.7:                                ; %B3
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	ldr	x10, [x8, w9, sxtw #3]
	cmp	x10, #34
	b.eq	LBB578_13
; %bb.8:                                ; %B20
	str	x21, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB578_12
LBB578_9:                               ; %B8
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB578_10:                              ; %B28
	mov	w10, #58                        ; =0x3a
	and	w10, w10, w11, lsr #26
	cmp	w10, #2
	b.ne	LBB578_13
; %bb.11:                               ; %B20
	ldr	x8, [x8, #16]
	sub	w9, w9, #1
	str	x21, [x8, w9, sxtw #3]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB578_9
LBB578_12:
	mov	x1, x24
	mov	x0, x21
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB578_13:                              ; %B34
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_SetGlobalVar_GC
	tbz	w0, #31, LBB578_9
; %bb.14:                               ; %B35
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_init_2_asm_h
l_put_var_init_2_asm_h:                 ; @put_var_init_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_put_var_init_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_strict_2_asm_h
l_put_var_strict_2_asm_h:               ; @put_var_strict_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_put_var_strict_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_ref_value_2_asm_h
l_get_ref_value_2_asm_h:                ; @get_ref_value_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_get_ref_value_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_ref_value_2_asm_h
l_put_ref_value_2_asm_h:                ; @put_ref_value_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_put_ref_value_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_var_2_asm_h
l_define_var_2_asm_h:                   ; @define_var_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_define_var_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function check_define_var_2_asm_h
l_check_define_var_2_asm_h:             ; @check_define_var_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_check_define_var_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_func_2_asm_h
l_define_func_2_asm_h:                  ; @define_func_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_define_func_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_field_2_asm_h
l_get_field_2_asm_h:                    ; @get_field_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #2                          ; =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	LBB586_10
; %bb.1:                                ; %B25
	mov	x9, x21
	mov	w8, #18                         ; =0x12
LBB586_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB586_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB586_5
LBB586_3:                               ; %B1
                                        ;   Parent Loop BB586_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB586_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB586_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB586_3
LBB586_5:                               ; %B14
                                        ;   in Loop: Header=BB586_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB586_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB586_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB586_2
	b	LBB586_9
LBB586_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB586_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB586_9:                               ; %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB586_10:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x3, x21
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB586_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB586_12:                              ; %B22
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_field2_2_asm_h
l_get_field2_2_asm_h:                   ; @get_field2_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #2                          ; =0x2
	str	x22, [x20], #8
	movk	x8, #65535, lsl #48
	ldr	w2, [x19]
	tst	x21, x8
	b.ne	LBB587_10
; %bb.1:                                ; %B25
	mov	x9, x21
	mov	w8, #18                         ; =0x12
LBB587_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB587_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB587_5
LBB587_3:                               ; %B1
                                        ;   Parent Loop BB587_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB587_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB587_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB587_3
LBB587_5:                               ; %B14
                                        ;   in Loop: Header=BB587_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB587_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB587_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB587_2
	b	LBB587_9
LBB587_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB587_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB587_9:                               ; %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB587_10:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	mov	x3, x21
	mov	w4, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB587_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB587_12:                              ; %B22
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_field_2_asm_h
l_put_field_2_asm_h:                    ; @put_field_2_asm_h
; %bb.0:                                ; %B55
	sub	sp, sp, #16
	mov	x8, #2                          ; =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB588_18
; %bb.1:                                ; %B56
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB588_4
LBB588_2:                               ; %B1
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB588_10
; %bb.3:                                ; %B12
                                        ;   in Loop: Header=BB588_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB588_2
LBB588_4:                               ; %B17.preheader
	mov	x8, x22
LBB588_5:                               ; %B17
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB588_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w2, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB588_8
LBB588_6:                               ; %B18
                                        ;   Parent Loop BB588_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB588_13
; %bb.7:                                ; %B34
                                        ;   in Loop: Header=BB588_6 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB588_6
LBB588_8:                               ; %B41
                                        ;   in Loop: Header=BB588_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB588_18
; %bb.9:                                ; %B38
                                        ;   in Loop: Header=BB588_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB588_5
	b	LBB588_14
LBB588_10:                              ; %B3
	mov	w9, #58                         ; =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	LBB588_18
; %bb.11:                               ; %B7
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB588_19
LBB588_12:                              ; %B54
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB588_13:                              ; %B20
	mov	w8, #58                         ; =0x3a
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	LBB588_18
LBB588_14:                              ; %B23
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	LBB588_18
; %bb.15:                               ; %B25
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	LBB588_20
; %bb.16:                               ; %B25
	tbnz	w2, #31, LBB588_20
; %bb.17:                               ; %B31
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x2
	stp	x22, x21, [x8]
	add	sp, sp, #16
	b	l_FastAddNamedProperty_asm_h
LBB588_18:                              ; %B52
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
                                        ; kill: def $w2 killed $w2 killed $x2
	bl	_JS_SetPropertyInternalImpl_GC
	tbz	w0, #31, LBB588_12
	b	LBB588_25
LBB588_19:                              ; %B9
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB588_20:                              ; %B45
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	w3, #7                          ; =0x7
	stp	x22, x21, [x20]
                                        ; kill: def $w2 killed $w2 killed $x2
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	str	x8, [x23, #48]
	bl	_add_property_gc
	cbz	x0, LBB588_24
; %bb.21:                               ; %B49
	str	x21, [x0]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB588_23
; %bb.22:                               ; %B51
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
LBB588_23:                              ; %B48
	ldrb	w8, [x19, #4]
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB588_24:                              ; %B46
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
LBB588_25:                              ; %B53
	add	sp, sp, #16
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_private_field_2_asm_h
l_get_private_field_2_asm_h:            ; @get_private_field_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_get_private_field_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_private_field_2_asm_h
l_put_private_field_2_asm_h:            ; @put_private_field_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_put_private_field_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_private_field_2_asm_h
l_define_private_field_2_asm_h:         ; @define_private_field_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_define_private_field_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_array_el_2_asm_h
l_get_array_el_2_asm_h:                 ; @get_array_el_2_asm_h
; %bb.0:                                ; %B76
	sub	sp, sp, #16
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB592_12
; %bb.1:                                ; %B73
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	LBB592_5
; %bb.2:                                ; %B1
	cmp	w8, #2
	b.ne	LBB592_10
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB592_14
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	add	w8, w8, #243
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB592_5:                               ; %B33
	cmp	w8, #1
	b.ne	LBB592_12
; %bb.6:                                ; %B36
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB592_12
; %bb.7:                                ; %B36
	mov	x9, #2                          ; =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB592_12
; %bb.8:                                ; %B65
	and	x8, x21, #0xfffffffffffc
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, LBB592_24
; %bb.9:                                ; %B68
	ldr	w8, [x8, #8]
	b	LBB592_25
LBB592_10:                              ; %B30
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB592_12
; %bb.11:                               ; %B30
	cmp	w8, #29
	b.le	LBB592_33
LBB592_12:                              ; %B70
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	str	x8, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB592_34
; %bb.13:                               ; %B72
	ldrb	w8, [x19], #1
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB592_14:                              ; %B7
	tbnz	w21, #31, LBB592_12
; %bb.15:                               ; %B9.preheader
	mov	x15, x20
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB592_16:                              ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB592_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB592_19
LBB592_17:                              ; %B10
                                        ;   Parent Loop BB592_16 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB592_21
; %bb.18:                               ; %B17
                                        ;   in Loop: Header=BB592_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB592_17
LBB592_19:                              ; %B24
                                        ;   in Loop: Header=BB592_16 Depth=1
	ldr	w10, [x9, #4]
	mov	x20, x15
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB592_12
; %bb.20:                               ; %B21
                                        ;   in Loop: Header=BB592_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB592_16
	b	LBB592_23
LBB592_21:                              ; %B12
	lsr	w8, w13, #26
	mov	x20, x15
	tst	w8, #0x30
	b.ne	LBB592_12
; %bb.22:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB592_23:                              ; %B14
	ldrb	w9, [x19], #1
	mov	x20, x15
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	mov	x22, x8
	add	sp, sp, #16
	br	x1
LBB592_24:                              ; %B66
	ldr	x8, [x8, #8]
	ldr	w8, [x8]
LBB592_25:                              ; %B62
	asr	w8, w8, #30
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	cmp	w8, #1
	b.ne	LBB592_12
; %bb.26:                               ; %B41
	ldr	x0, [x24, #8]
	and	x1, x21, #0xfffffffffffc
	bl	_prim_get_interned_non_index_atom
	cbz	w0, LBB592_12
; %bb.27:                               ; %B44.preheader
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB592_28:                              ; %B44
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB592_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB592_31
LBB592_29:                              ; %B47
                                        ;   Parent Loop BB592_28 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	LBB592_35
; %bb.30:                               ; %B53
                                        ;   in Loop: Header=BB592_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB592_29
LBB592_31:                              ; %B58
                                        ;   in Loop: Header=BB592_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB592_12
; %bb.32:                               ; %B55
                                        ;   in Loop: Header=BB592_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB592_28
	b	LBB592_37
LBB592_33:                              ; %B31
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, xzr
	stp	x22, x21, [x8]
	add	sp, sp, #16
	b	l_FastTypedArrayGet_asm_h
LBB592_34:                              ; %B71
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	l_exception_spill_top0_top1_asm_h
LBB592_35:                              ; %B49
	lsr	w8, w12, #26
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	tst	w8, #0x30
	b.ne	LBB592_12
; %bb.36:                               ; %B50
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB592_37:                              ; %B51
	ldrb	w9, [x19], #1
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	mov	x22, x8
	add	sp, sp, #16
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_array_el2_2_asm_h
l_get_array_el2_2_asm_h:                ; @get_array_el2_2_asm_h
; %bb.0:                                ; %B76
	sub	sp, sp, #16
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB593_12
; %bb.1:                                ; %B73
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	LBB593_5
; %bb.2:                                ; %B1
	cmp	w8, #2
	b.ne	LBB593_10
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB593_14
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	add	w8, w8, #486
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB593_5:                               ; %B33
	cmp	w8, #1
	b.ne	LBB593_12
; %bb.6:                                ; %B36
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB593_12
; %bb.7:                                ; %B36
	mov	x9, #2                          ; =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB593_12
; %bb.8:                                ; %B65
	and	x1, x21, #0xfffffffffffc
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB593_24
; %bb.9:                                ; %B68
	ldr	w8, [x1, #8]
	b	LBB593_25
LBB593_10:                              ; %B30
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB593_12
; %bb.11:                               ; %B30
	cmp	w8, #29
	b.le	LBB593_33
LBB593_12:                              ; %B70
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	str	x8, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB593_34
; %bb.13:                               ; %B72
	ldrb	w8, [x19], #1
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB593_14:                              ; %B7
	tbnz	w21, #31, LBB593_12
; %bb.15:                               ; %B9.preheader
	mov	x15, x20
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB593_16:                              ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB593_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB593_19
LBB593_17:                              ; %B10
                                        ;   Parent Loop BB593_16 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB593_21
; %bb.18:                               ; %B17
                                        ;   in Loop: Header=BB593_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB593_17
LBB593_19:                              ; %B24
                                        ;   in Loop: Header=BB593_16 Depth=1
	ldr	w10, [x9, #4]
	mov	x20, x15
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB593_12
; %bb.20:                               ; %B21
                                        ;   in Loop: Header=BB593_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB593_16
	b	LBB593_23
LBB593_21:                              ; %B12
	lsr	w8, w13, #26
	mov	x20, x15
	tst	w8, #0x30
	b.ne	LBB593_12
; %bb.22:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB593_23:                              ; %B14
	ldrb	w9, [x19], #1
	mov	x20, x15
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x8
	add	sp, sp, #16
	br	x1
LBB593_24:                              ; %B66
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
LBB593_25:                              ; %B62
	asr	w8, w8, #30
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	cmp	w8, #1
	b.ne	LBB593_12
; %bb.26:                               ; %B41
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	cbz	w0, LBB593_12
; %bb.27:                               ; %B44.preheader
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB593_28:                              ; %B44
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB593_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB593_31
LBB593_29:                              ; %B47
                                        ;   Parent Loop BB593_28 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	LBB593_35
; %bb.30:                               ; %B53
                                        ;   in Loop: Header=BB593_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB593_29
LBB593_31:                              ; %B58
                                        ;   in Loop: Header=BB593_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB593_12
; %bb.32:                               ; %B55
                                        ;   in Loop: Header=BB593_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB593_28
	b	LBB593_37
LBB593_33:                              ; %B31
	mov	x8, x20
	add	x20, x20, #16
	mov	w0, #1                          ; =0x1
	stp	x22, x21, [x8]
	add	sp, sp, #16
	b	l_FastTypedArrayGet_asm_h
LBB593_34:                              ; %B71
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	l_exception_spill_top0_top1_asm_h
LBB593_35:                              ; %B49
	lsr	w8, w12, #26
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	tst	w8, #0x30
	b.ne	LBB593_12
; %bb.36:                               ; %B50
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB593_37:                              ; %B51
	ldrb	w9, [x19], #1
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x8
	add	sp, sp, #16
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_array_el_2_asm_h
l_put_array_el_2_asm_h:                 ; @put_array_el_2_asm_h
; %bb.0:                                ; %B116
	sub	sp, sp, #16
	mov	x10, x20
	ldur	x20, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x20, x8
	b.ne	LBB594_45
; %bb.1:                                ; %B1
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x20, #6]
	cmp	x9, x22, lsr #48
	b.ne	LBB594_7
; %bb.2:                                ; %B3
	cmp	w8, #2
	b.ne	LBB594_12
; %bb.3:                                ; %B5
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB594_45
; %bb.4:                                ; %B50
	ldr	w8, [x20, #48]
	cmp	w22, w8
	b.hs	LBB594_15
; %bb.5:                                ; %B7
	ldr	x8, [x20, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB594_24
; %bb.6:                                ; %B9
	ldrb	w8, [x19], #1
	sub	x20, x10, #8
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB594_7:                               ; %B59
	cmp	w8, #1
	b.ne	LBB594_45
; %bb.8:                                ; %B107
	ldr	w8, [x20, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB594_45
; %bb.9:                                ; %B107
	mov	x9, #2                          ; =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB594_45
; %bb.10:                               ; %B62
	and	x8, x22, #0xfffffffffffc
	str	x10, [sp, #8]                   ; 8-byte Folded Spill
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, LBB594_25
; %bb.11:                               ; %B106
	ldr	w8, [x8, #8]
	b	LBB594_26
LBB594_12:                              ; %B55
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB594_45
; %bb.13:                               ; %B55
	cmp	w8, #29
	b.gt	LBB594_45
; %bb.14:                               ; %B56
	add	x20, x10, #16
	stp	x22, x21, [x10]
	add	sp, sp, #16
	b	l_FastTypedArraySet_asm_h
LBB594_15:                              ; %B12
	str	x10, [sp, #8]                   ; 8-byte Folded Spill
	b.ne	LBB594_37
; %bb.16:                               ; %B40
	ldr	w9, [x20, #4]
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	b.ne	LBB594_45
; %bb.17:                               ; %B40
	ubfx	w9, w9, #8, #1
	cbz	w9, LBB594_45
; %bb.18:                               ; %B14
	ldr	x9, [x20, #8]
	ldr	x9, [x9, #32]
	cbz	x9, LBB594_20
; %bb.19:                               ; %B36
	ldr	w9, [x9, #4]
	ubfx	w9, w9, #13, #1
	cmp	w9, #1
	b.ne	LBB594_45
LBB594_20:                              ; %B32
	ldr	x9, [x20, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	LBB594_22
; %bb.21:                               ; %B32
	cmp	w9, w10
	b.hi	LBB594_39
LBB594_22:                              ; %B29
	ldr	w10, [x20, #32]
	cmp	w9, w10
	b.hi	LBB594_39
; %bb.23:                               ; %B25
	ldr	x10, [x20, #40]
	str	w9, [x20, #48]
	str	x21, [x10, w8, sxtw #3]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB594_46
	b	LBB594_42
LBB594_24:                              ; %B11
	mov	x0, x21
	mov	x1, x24
	mov	x20, x10
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB594_25:                              ; %B63
	ldr	x8, [x8, #8]
	ldr	w8, [x8]
LBB594_26:                              ; %B102
	asr	w8, w8, #30
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	cmp	w8, #1
	b.ne	LBB594_45
; %bb.27:                               ; %B64
	ldr	x0, [x24, #8]
	and	x1, x22, #0xfffffffffffc
	bl	_prim_get_interned_non_index_atom
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	cbz	w0, LBB594_45
; %bb.28:                               ; %B66
	ldr	x8, [x20, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w0, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB594_31
LBB594_29:                              ; %B69
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	LBB594_40
; %bb.30:                               ; %B78
                                        ;   in Loop: Header=BB594_29 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB594_29
LBB594_31:                              ; %B80.preheader
	mov	x8, x20
LBB594_32:                              ; %B80
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB594_33 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w0, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB594_35
LBB594_33:                              ; %B93
                                        ;   Parent Loop BB594_32 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	LBB594_43
; %bb.34:                               ; %B98
                                        ;   in Loop: Header=BB594_33 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB594_33
LBB594_35:                              ; %B81
                                        ;   in Loop: Header=BB594_32 Depth=1
	ldr	w9, [x8, #4]
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB594_45
; %bb.36:                               ; %B87
                                        ;   in Loop: Header=BB594_32 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB594_32
	b	LBB594_44
LBB594_37:                              ; %B44
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	tbnz	w22, #31, LBB594_45
; %bb.38:                               ; %B46
	add	x8, x10, #16
	mov	x0, x24
	mov	x1, x20
	mov	w2, w22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	stp	x22, x21, [x10]
	str	x8, [x23, #48]
	bl	_JS_SetArrayIntPropertyValue_GC
	tbz	w0, #31, LBB594_46
	b	LBB594_48
LBB594_39:                              ; %B20
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, x24
	mov	x1, x20
	mov	x2, x21
	mov	w3, #32768                      ; =0x8000
	add	x8, x9, #16
	stp	x22, x21, [x9]
	str	x8, [x23, #48]
	bl	_add_fast_array_element_gc
	tbz	w0, #31, LBB594_46
	b	LBB594_48
LBB594_40:                              ; %B71
	mov	w9, #58                         ; =0x3a
	and	w9, w9, w10, lsr #26
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	cmp	w9, #2
	b.ne	LBB594_45
; %bb.41:                               ; %B74
	ldr	x9, [x20, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB594_46
LBB594_42:                              ; %B76
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #16
	br	x1
LBB594_43:                              ; %B95
	mov	w8, #58                         ; =0x3a
	and	w8, w8, w10, lsr #26
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	cmp	w8, #2
	b.ne	LBB594_45
LBB594_44:                              ; %B84
	ldr	w8, [x20, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.eq	LBB594_47
LBB594_45:                              ; %B113
	add	x8, x10, #16
	mov	x0, x24
	mov	x1, x20
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	stp	x22, x21, [x10]
	str	x10, [sp, #8]                   ; 8-byte Folded Spill
	str	x8, [x23, #48]
	bl	_JS_SetPropertyValue_GC
	tbnz	w0, #31, LBB594_48
LBB594_46:                              ; %B73
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #16
	br	x1
LBB594_47:                              ; %B85
	add	x20, x10, #16
	stp	x22, x21, [x10]
	mov	w0, w0
	add	sp, sp, #16
	b	l_FastAddNamedProperty_asm_h
LBB594_48:                              ; %B47
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_super_value_2_asm_h
l_get_super_value_2_asm_h:              ; @get_super_value_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_get_super_value_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_super_value_2_asm_h
l_put_super_value_2_asm_h:              ; @put_super_value_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_put_super_value_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_field_2_asm_h
l_define_field_2_asm_h:                 ; @define_field_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_define_field_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_name_2_asm_h
l_set_name_2_asm_h:                     ; @set_name_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_set_name_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_name_computed_2_asm_h
l_set_name_computed_2_asm_h:            ; @set_name_computed_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_set_name_computed_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_proto_2_asm_h
l_set_proto_2_asm_h:                    ; @set_proto_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_set_proto_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_home_object_2_asm_h
l_set_home_object_2_asm_h:              ; @set_home_object_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_set_home_object_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_array_el_2_asm_h
l_define_array_el_2_asm_h:              ; @define_array_el_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_define_array_el_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function append_2_asm_h
l_append_2_asm_h:                       ; @append_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_append_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function copy_data_properties_2_asm_h
l_copy_data_properties_2_asm_h:         ; @copy_data_properties_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_copy_data_properties_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_method_2_asm_h
l_define_method_2_asm_h:                ; @define_method_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_define_method_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_method_computed_2_asm_h
l_define_method_computed_2_asm_h:       ; @define_method_computed_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_define_method_computed_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function define_class_2_asm_h
l_define_class_2_asm_h:                 ; @define_class_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_define_class_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc_2_asm_h
l_get_loc_2_asm_h:                      ; @get_loc_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #486
	ldr	x9, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x9
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc_2_asm_h
l_put_loc_2_asm_h:                      ; @put_loc_2_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc_2_asm_h
l_set_loc_2_asm_h:                      ; @set_loc_2_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_arg_2_asm_h
l_get_arg_2_asm_h:                      ; @get_arg_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #486
	ldr	x9, [x28, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x9
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_arg_2_asm_h
l_put_arg_2_asm_h:                      ; @put_arg_2_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	str	x21, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_arg_2_asm_h
l_set_arg_2_asm_h:                      ; @set_arg_2_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	str	x21, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref_2_asm_h
l_get_var_ref_2_asm_h:                  ; @get_var_ref_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrh	w8, [x19]
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x8, [x26, x8, lsl #3]
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8]
	ldr	x8, [x8]
	mov	x21, x8
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref_2_asm_h
l_put_var_ref_2_asm_h:                  ; @put_var_ref_2_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_var_ref_2_asm_h
l_set_var_ref_2_asm_h:                  ; @set_var_ref_2_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc_uninitialized_2_asm_h
l_set_loc_uninitialized_2_asm_h:        ; @set_loc_uninitialized_2_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	mov	w9, #34                         ; =0x22
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc_check_2_asm_h
l_get_loc_check_2_asm_h:                ; @get_loc_check_2_asm_h
; %bb.0:                                ; %B2
	str	x22, [x20], #8
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	LBB618_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB618_2:                               ; %B3
	str	x21, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc_check_2_asm_h
l_put_loc_check_2_asm_h:                ; @put_loc_check_2_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	LBB619_2
; %bb.1:                                ; %B4
	str	x21, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB619_2:                               ; %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc_check_init_2_asm_h
l_put_loc_check_init_2_asm_h:           ; @put_loc_check_init_2_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	LBB620_2
; %bb.1:                                ; %B4
	str	x21, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB620_2:                               ; %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_ThrowThisReferenceError_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref_check_2_asm_h
l_get_var_ref_check_2_asm_h:            ; @get_var_ref_check_2_asm_h
; %bb.0:                                ; %B2
	str	x22, [x20], #8
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	LBB621_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB621_2:                               ; %B3
	str	x21, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref_check_2_asm_h
l_put_var_ref_check_2_asm_h:            ; @put_var_ref_check_2_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	LBB622_2
; %bb.1:                                ; %B4
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB622_2:                               ; %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref_check_init_2_asm_h
l_put_var_ref_check_init_2_asm_h:       ; @put_var_ref_check_init_2_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	LBB623_2
; %bb.1:                                ; %B4
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB623_2:                               ; %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function close_loc_2_asm_h
l_close_loc_2_asm_h:                    ; @close_loc_2_asm_h
; %bb.0:                                ; %B0
	ldrh	w2, [x19]
	mov	x0, x24
	mov	x1, x23
	bl	_close_lexical_var
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_false_2_asm_h
l_if_false_2_asm_h:                     ; @if_false_2_asm_h
; %bb.0:                                ; %B29
	cmp	x21, #5
	b.le	LBB625_4
; %bb.1:                                ; %B29
	cmp	x21, #6
	b.eq	LBB625_6
; %bb.2:                                ; %B29
	cmp	x21, #7
	b.eq	LBB625_10
; %bb.3:                                ; %B29
	cmp	x21, #18
	b.eq	LBB625_6
	b	LBB625_8
LBB625_4:                               ; %B29
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB625_6
; %bb.5:                                ; %B29
	cmp	x21, #2
	b.ne	LBB625_8
LBB625_6:                               ; %B8
	ldrsw	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB625_11
LBB625_7:                               ; %B10
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB625_8:                               ; %B15
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x21, x8
	b.hs	LBB625_16
; %bb.9:                                ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB625_13
LBB625_10:                              ; %B25
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB625_11:                              ; %B5
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB625_7
; %bb.12:                               ; %B6
	add	x19, x19, #1
	b	l_PollInterrupts_spill_top0_asm_h
LBB625_13:                              ; %B19
	tst	x21, #0xfffe000000000000
	b.eq	LBB625_16
; %bb.14:                               ; %B23
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB625_6
	b.vs	LBB625_6
; %bb.15:                               ; %B23
	tbnz	w8, #0, LBB625_10
	b	LBB625_6
LBB625_16:                              ; %B21
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_true_2_asm_h
l_if_true_2_asm_h:                      ; @if_true_2_asm_h
; %bb.0:                                ; %B29
	cmp	x21, #5
	b.le	LBB626_4
; %bb.1:                                ; %B29
	cmp	x21, #6
	b.eq	LBB626_6
; %bb.2:                                ; %B29
	cmp	x21, #7
	b.eq	LBB626_9
; %bb.3:                                ; %B29
	cmp	x21, #18
	b.eq	LBB626_6
	b	LBB626_7
LBB626_4:                               ; %B29
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB626_6
; %bb.5:                                ; %B29
	cmp	x21, #2
	b.ne	LBB626_7
LBB626_6:                               ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB626_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x21, x8
	b.hs	LBB626_16
; %bb.8:                                ; %B11
	mov	x8, #-562949953421313           ; =0xfffdffffffffffff
	cmp	x21, x8
	b.ls	LBB626_13
LBB626_9:                               ; %B23
	ldrsw	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB626_11
LBB626_10:                              ; %B25
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB626_11:                              ; %B20
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB626_10
; %bb.12:                               ; %B21
	add	x19, x19, #1
	b	l_PollInterrupts_spill_top0_asm_h
LBB626_13:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB626_16
; %bb.14:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB626_6
	b.vs	LBB626_6
; %bb.15:                               ; %B17
	tbnz	w8, #0, LBB626_9
	b	LBB626_6
LBB626_16:                              ; %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto_2_asm_h
l_goto_2_asm_h:                         ; @goto_2_asm_h
; %bb.0:                                ; %B5
	ldrsw	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB627_2
LBB627_1:                               ; %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB627_2:                               ; %B2
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB627_1
; %bb.3:                                ; %B3
	add	x19, x19, #1
	b	l_PollInterrupts_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function catch_2_asm_h
l_catch_2_asm_h:                        ; @catch_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_catch_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function gosub_2_asm_h
l_gosub_2_asm_h:                        ; @gosub_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_gosub_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function ret_2_asm_h
l_ret_2_asm_h:                          ; @ret_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_ret_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function to_object_2_asm_h
l_to_object_2_asm_h:                    ; @to_object_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_to_object_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function to_propkey_2_asm_h
l_to_propkey_2_asm_h:                   ; @to_propkey_2_asm_h
; %bb.0:                                ; %B15
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	LBB632_4
; %bb.1:                                ; %B15
	mov	x9, #1                          ; =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB632_4
; %bb.2:                                ; %B15
	cmp	x8, x9
	b.eq	LBB632_4
; %bb.3:                                ; %B15
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB632_5
LBB632_4:                               ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB632_5:                               ; %B12
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB632_7
; %bb.6:                                ; %B14
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB632_7:                               ; %B13
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function to_propkey2_2_asm_h
l_to_propkey2_2_asm_h:                  ; @to_propkey2_2_asm_h
; %bb.0:                                ; %B18
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	LBB633_3
; %bb.1:                                ; %B19
	add	x8, x20, #16
Lloh26:
	adrp	x1, l___unnamed_14@PAGE
Lloh27:
	add	x1, x1, l___unnamed_14@PAGEOFF
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_LEPUS_ThrowTypeError
LBB633_2:                               ; %B16
	b	l_exception_spill_top0_top1_asm_h
LBB633_3:                               ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	LBB633_7
; %bb.4:                                ; %B2
	mov	x9, #1                          ; =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB633_7
; %bb.5:                                ; %B2
	cmp	x8, x9
	b.eq	LBB633_7
; %bb.6:                                ; %B2
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB633_8
LBB633_7:                               ; %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB633_8:                               ; %B15
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB633_2
; %bb.9:                                ; %B17
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh26, Lloh27
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_get_var_2_asm_h
l_with_get_var_2_asm_h:                 ; @with_get_var_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_with_get_var_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_put_var_2_asm_h
l_with_put_var_2_asm_h:                 ; @with_put_var_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_with_put_var_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_delete_var_2_asm_h
l_with_delete_var_2_asm_h:              ; @with_delete_var_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_with_delete_var_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_make_ref_2_asm_h
l_with_make_ref_2_asm_h:                ; @with_make_ref_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_with_make_ref_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_get_ref_2_asm_h
l_with_get_ref_2_asm_h:                 ; @with_get_ref_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_with_get_ref_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function with_get_ref_undef_2_asm_h
l_with_get_ref_undef_2_asm_h:           ; @with_get_ref_undef_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_with_get_ref_undef_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function make_loc_ref_2_asm_h
l_make_loc_ref_2_asm_h:                 ; @make_loc_ref_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_make_loc_ref_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function make_arg_ref_2_asm_h
l_make_arg_ref_2_asm_h:                 ; @make_arg_ref_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_make_arg_ref_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function make_var_ref_ref_2_asm_h
l_make_var_ref_ref_2_asm_h:             ; @make_var_ref_ref_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_make_var_ref_ref_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function make_var_ref_2_asm_h
l_make_var_ref_2_asm_h:                 ; @make_var_ref_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_make_var_ref_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_in_start_2_asm_h
l_for_in_start_2_asm_h:                 ; @for_in_start_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_for_in_start_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_of_start_2_asm_h
l_for_of_start_2_asm_h:                 ; @for_of_start_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_for_of_start_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_await_of_start_2_asm_h
l_for_await_of_start_2_asm_h:           ; @for_await_of_start_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_for_await_of_start_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_in_next_2_asm_h
l_for_in_next_2_asm_h:                  ; @for_in_next_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_for_in_next_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_of_next_2_asm_h
l_for_of_next_2_asm_h:                  ; @for_of_next_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_for_of_next_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_await_of_next_2_asm_h
l_for_await_of_next_2_asm_h:            ; @for_await_of_next_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_for_await_of_next_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function iterator_get_value_done_2_asm_h
l_iterator_get_value_done_2_asm_h:      ; @iterator_get_value_done_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_iterator_get_value_done_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function iterator_close_2_asm_h
l_iterator_close_2_asm_h:               ; @iterator_close_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_iterator_close_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function iterator_close_return_2_asm_h
l_iterator_close_return_2_asm_h:        ; @iterator_close_return_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_iterator_close_return_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function async_iterator_close_2_asm_h
l_async_iterator_close_2_asm_h:         ; @async_iterator_close_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_async_iterator_close_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function async_iterator_next_2_asm_h
l_async_iterator_next_2_asm_h:          ; @async_iterator_next_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_async_iterator_next_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function async_iterator_get_2_asm_h
l_async_iterator_get_2_asm_h:           ; @async_iterator_get_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_async_iterator_get_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function initial_yield_2_asm_h
l_initial_yield_2_asm_h:                ; @initial_yield_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_initial_yield_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function yield_2_asm_h
l_yield_2_asm_h:                        ; @yield_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_yield_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function yield_star_2_asm_h
l_yield_star_2_asm_h:                   ; @yield_star_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_yield_star_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function async_yield_star_2_asm_h
l_async_yield_star_2_asm_h:             ; @async_yield_star_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_async_yield_star_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function await_2_asm_h
l_await_2_asm_h:                        ; @await_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_await_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function neg_2_asm_h
l_neg_2_asm_h:                          ; @neg_2_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	LBB661_3
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB661_6
; %bb.2:                                ; %B13
	orr	w8, w21, #0x80000000
	mov	w9, #-2147483648                ; =0x80000000
	cmp	w8, w9
	b.ne	LBB661_5
LBB661_3:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #140                        ; =0x8c
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB661_8
; %bb.4:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB661_5:                               ; %B15
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x1
LBB661_6:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB661_3
; %bb.7:                                ; %B7
	movi	d0, #0000000000000000
	add	x8, x21, x8
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	fsub	d0, d0, d1
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
LBB661_8:                               ; %B17
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function plus_2_asm_h
l_plus_2_asm_h:                         ; @plus_2_asm_h
; %bb.0:                                ; %B13
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	LBB662_4
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB662_3
LBB662_2:                               ; %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB662_3:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.ne	LBB662_2
LBB662_4:                               ; %B10
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #141                        ; =0x8d
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB662_6
; %bb.5:                                ; %B12
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB662_6:                               ; %B11
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function dec_2_asm_h
l_dec_2_asm_h:                          ; @dec_2_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	LBB663_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB663_4
; %bb.2:                                ; %B13
	subs	w8, w21, #1
	b.vs	LBB663_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB663_4:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB663_6
; %bb.5:                                ; %B7
	add	x8, x21, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
LBB663_6:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #142                        ; =0x8e
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB663_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB663_8:                               ; %B17
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function inc_2_asm_h
l_inc_2_asm_h:                          ; @inc_2_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	LBB664_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB664_4
; %bb.2:                                ; %B13
	adds	w8, w21, #1
	b.vs	LBB664_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB664_4:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB664_6
; %bb.5:                                ; %B7
	add	x8, x21, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	csel	x21, x9, x8, vc
	br	x1
LBB664_6:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #143                        ; =0x8f
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB664_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB664_8:                               ; %B17
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function post_dec_2_asm_h
l_post_dec_2_asm_h:                     ; @post_dec_2_asm_h
; %bb.0:                                ; %B16
	mov	x8, #-281474976710656           ; =0xffff000000000000
	str	x22, [x20], #8
	cmp	x21, x8
	b.hs	LBB665_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB665_4
; %bb.2:                                ; %B13
	subs	w8, w21, #1
	b.vs	LBB665_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	mov	x22, x21
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB665_4:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB665_6
; %bb.5:                                ; %B8
	add	x8, x21, x8
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	mov	x22, x21
	add	w8, w8, #486
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       ; =0x7ffa000000000000
	csel	x8, x9, x10, vc
	mov	x21, x8
	br	x1
LBB665_6:                               ; %B5
	str	x21, [x20], #8
	mov	w0, #144                        ; =0x90
	b	l_SlowJSPostInc_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function post_inc_2_asm_h
l_post_inc_2_asm_h:                     ; @post_inc_2_asm_h
; %bb.0:                                ; %B16
	mov	x8, #-281474976710656           ; =0xffff000000000000
	str	x22, [x20], #8
	cmp	x21, x8
	b.hs	LBB666_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB666_4
; %bb.2:                                ; %B13
	adds	w8, w21, #1
	b.vs	LBB666_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	mov	x22, x21
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB666_4:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB666_6
; %bb.5:                                ; %B8
	add	x8, x21, x8
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	mov	x22, x21
	add	w8, w8, #486
	fadd	d0, d1, d0
	ldr	x1, [x25, w8, uxtw #3]
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       ; =0x7ffa000000000000
	csel	x8, x9, x10, vc
	mov	x21, x8
	br	x1
LBB666_6:                               ; %B5
	str	x21, [x20], #8
	mov	w0, #145                        ; =0x91
	b	l_SlowJSPostInc_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function dec_loc_2_asm_h
l_dec_loc_2_asm_h:                      ; @dec_loc_2_asm_h
; %bb.0:                                ; %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	LBB667_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB667_4
; %bb.2:                                ; %B13
	subs	w9, w1, #1
	b.vs	LBB667_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB667_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB667_6
; %bb.5:                                ; %B8
	add	x9, x1, x9
	fmov	d0, #-1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       ; =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB667_6:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #142                        ; =0x8e
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB667_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB667_8:                               ; %B17
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function inc_loc_2_asm_h
l_inc_loc_2_asm_h:                      ; @inc_loc_2_asm_h
; %bb.0:                                ; %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	LBB668_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB668_4
; %bb.2:                                ; %B13
	adds	w9, w1, #1
	b.vs	LBB668_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB668_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB668_6
; %bb.5:                                ; %B8
	add	x9, x1, x9
	fmov	d0, #1.00000000
	mov	x10, #562949953421312           ; =0x2000000000000
	fmov	d1, x9
	fadd	d0, d1, d0
	fmov	x9, d0
	fcmp	d0, d0
	add	x9, x9, x10
	mov	x10, #9221683186994511872       ; =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB668_6:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #143                        ; =0x8f
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB668_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB668_8:                               ; %B17
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function add_loc_2_asm_h
l_add_loc_2_asm_h:                      ; @add_loc_2_asm_h
; %bb.0:                                ; %B46
	sub	sp, sp, #16
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	ccmp	x21, x9, #2, ls
	b.hi	LBB669_17
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB669_6
; %bb.2:                                ; %B26
	cmp	x21, x9
	b.lo	LBB669_9
; %bb.3:                                ; %B36
	adds	w9, w1, w21
	b.vs	LBB669_12
; %bb.4:                                ; %B42
	orr	x9, x9, #0xfffe000000000000
LBB669_5:                               ; %B42
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB669_6:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB669_17
; %bb.7:                                ; %B11
	cmp	x21, x9
	b.lo	LBB669_15
; %bb.8:                                ; %B21
	scvtf	d0, w21
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	LBB669_14
LBB669_9:                               ; %B28
	tst	x21, #0xfffe000000000000
	b.eq	LBB669_17
; %bb.10:                               ; %B31
	scvtf	d0, w1
	add	x9, x21, x9
LBB669_11:                              ; %B31
	fmov	d1, x9
	b	LBB669_13
LBB669_12:                              ; %B38
	scvtf	d0, w1
	scvtf	d1, w21
LBB669_13:                              ; %B31
	fadd	d0, d0, d1
LBB669_14:                              ; %B31
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	add	x9, x9, x10
	mov	x10, #9221683186994511872       ; =0x7ffa000000000000
	csel	x9, x9, x10, vc
	b	LBB669_5
LBB669_15:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB669_17
; %bb.16:                               ; %B16
	add	x10, x1, x9
	add	x9, x21, x9
	fmov	d0, x10
	b	LBB669_11
LBB669_17:                              ; %B7
	and	x8, x21, #0xffff000000000003
	mov	x9, #-281474976710653           ; =0xffff000000000003
	mov	x10, #2                         ; =0x2
	cmp	x8, x9
	movk	x10, #1, lsl #48
	and	x11, x1, #0xffff000000000003
	ccmp	x8, x10, #4, ne
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	add	x20, x20, #16
	cset	w8, eq
	cmp	x11, x10
	ccmp	x11, x9, #4, ne
	ccmp	w8, #0, #4, eq
	b.ne	LBB669_20
; %bb.18:                               ; %B43
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, x24
	mov	x2, x21
	stp	x22, x21, [x8]
	str	x20, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB669_21
; %bb.19:                               ; %B45
	ldrb	w8, [x19]
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB669_20:                              ; %B8
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	w0, #1                          ; =0x1
	stp	x22, x21, [x8]
	add	sp, sp, #16
	b	l_FastJSConcatString_asm_h
LBB669_21:                              ; %B44
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function not_2_asm_h
l_not_2_asm_h:                          ; @not_2_asm_h
; %bb.0:                                ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	LBB670_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x1
LBB670_2:                               ; %B4
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	l_SlowJSNot_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lnot_2_asm_h
l_lnot_2_asm_h:                         ; @lnot_2_asm_h
; %bb.0:                                ; %B14
	cmp	x21, #5
	b.le	LBB671_4
; %bb.1:                                ; %B14
	cmp	x21, #6
	b.eq	LBB671_6
; %bb.2:                                ; %B14
	cmp	x21, #7
	b.eq	LBB671_8
; %bb.3:                                ; %B14
	cmp	x21, #18
	b.eq	LBB671_6
	b	LBB671_7
LBB671_4:                               ; %B14
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB671_6
; %bb.5:                                ; %B14
	cmp	x21, #2
	b.ne	LBB671_7
LBB671_6:                               ; %B3
	mov	w21, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB671_7:                               ; %B10
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	LBB671_9
LBB671_8:                               ; %B12
	mov	w21, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB671_9:                               ; %B13
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function typeof_2_asm_h
l_typeof_2_asm_h:                       ; @typeof_2_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x21
	bl	_js_operator_typeof_gc
	mov	w1, w0
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB672_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB672_2:                               ; %B2
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function delete_2_asm_h
l_delete_2_asm_h:                       ; @delete_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_delete_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function delete_var_2_asm_h
l_delete_var_2_asm_h:                   ; @delete_var_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_delete_var_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function mul_2_asm_h
l_mul_2_asm_h:                          ; @mul_2_asm_h
; %bb.0:                                ; %B51
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB675_20
; %bb.1:                                ; %B51
	cmp	x21, x8
	b.hi	LBB675_20
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB675_8
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB675_11
; %bb.4:                                ; %B33
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	LBB675_14
; %bb.5:                                ; %B40
	cbnz	w8, LBB675_7
; %bb.6:                                ; %B40
	orr	w9, w22, w21
	tbnz	w9, #31, LBB675_17
LBB675_7:                               ; %B47
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB675_8:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB675_20
; %bb.9:                                ; %B7
	cmp	x21, x8
	b.lo	LBB675_18
; %bb.10:                               ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	LBB675_16
LBB675_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB675_20
; %bb.12:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB675_13:                              ; %B28
	fmov	d1, x8
	b	LBB675_15
LBB675_14:                              ; %B35
	scvtf	d0, w22
	scvtf	d1, w21
LBB675_15:                              ; %B28
	fmul	d0, d0, d1
LBB675_16:                              ; %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB675_17:                              ; %B44
	mov	x22, #-9222809086901354496      ; =0x8002000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB675_18:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB675_20
; %bb.19:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB675_13
LBB675_20:                              ; %B48
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        ; =0x9a
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB675_22
; %bb.21:                               ; %B50
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB675_22:                              ; %B49
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function div_2_asm_h
l_div_2_asm_h:                          ; @div_2_asm_h
; %bb.0:                                ; %B44
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB676_14
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB676_14
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB676_5
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB676_8
; %bb.4:                                ; %B33
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           ; =0x2000000000000
	ldrb	w9, [x19], #1
	mov	x12, #9221683186994511872       ; =0x7ffa000000000000
	add	w9, w9, #243
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
LBB676_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB676_14
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB676_12
; %bb.7:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	LBB676_11
LBB676_8:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB676_14
; %bb.9:                                ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB676_10:                              ; %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
LBB676_11:                              ; %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB676_12:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB676_14
; %bb.13:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB676_10
LBB676_14:                              ; %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        ; =0x9b
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB676_16
; %bb.15:                               ; %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB676_16:                              ; %B42
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function mod_2_asm_h
l_mod_2_asm_h:                          ; @mod_2_asm_h
; %bb.0:                                ; %B39
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB677_16
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB677_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB677_7
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB677_10
; %bb.4:                                ; %B33
	tbnz	w22, #31, LBB677_16
; %bb.5:                                ; %B33
	cmp	w21, #1
	b.lt	LBB677_16
; %bb.6:                                ; %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB677_7:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB677_16
; %bb.8:                                ; %B7
	cmp	x21, x8
	b.lo	LBB677_14
; %bb.9:                                ; %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	LBB677_13
LBB677_10:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB677_16
; %bb.11:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB677_12:                              ; %B28
	fmov	d1, x8
LBB677_13:                              ; %B28
	bl	_fmod
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB677_14:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB677_16
; %bb.15:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB677_12
LBB677_16:                              ; %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        ; =0x9c
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB677_18
; %bb.17:                               ; %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB677_18:                              ; %B37
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function add_2_asm_h
l_add_2_asm_h:                          ; @add_2_asm_h
; %bb.0:                                ; %B46
	sub	sp, sp, #16
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB678_17
; %bb.1:                                ; %B46
	cmp	x21, x8
	b.hi	LBB678_17
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB678_6
; %bb.3:                                ; %B26
	cmp	x21, x8
	b.lo	LBB678_9
; %bb.4:                                ; %B36
	adds	w8, w22, w21
	b.vs	LBB678_12
; %bb.5:                                ; %B42
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB678_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB678_17
; %bb.7:                                ; %B11
	cmp	x21, x8
	b.lo	LBB678_15
; %bb.8:                                ; %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	LBB678_14
LBB678_9:                               ; %B28
	tst	x21, #0xfffe000000000000
	b.eq	LBB678_17
; %bb.10:                               ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB678_11:                              ; %B31
	fmov	d1, x8
	b	LBB678_13
LBB678_12:                              ; %B38
	scvtf	d0, w22
	scvtf	d1, w21
LBB678_13:                              ; %B31
	fadd	d0, d0, d1
LBB678_14:                              ; %B31
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	add	w8, w8, #243
	add	x9, x9, x10
	ldr	x1, [x25, w8, uxtw #3]
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	add	sp, sp, #16
	br	x1
LBB678_15:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB678_17
; %bb.16:                               ; %B16
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB678_11
LBB678_17:                              ; %B7
	and	x8, x21, #0xffff000000000003
	mov	x9, #-281474976710653           ; =0xffff000000000003
	mov	x10, #2                         ; =0x2
	cmp	x8, x9
	movk	x10, #1, lsl #48
	and	x11, x22, #0xffff000000000003
	ccmp	x8, x10, #4, ne
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	add	x20, x20, #16
	cset	w8, eq
	cmp	x11, x10
	ccmp	x11, x9, #4, ne
	b.ne	LBB678_20
; %bb.18:                               ; %B7
	cbz	w8, LBB678_20
; %bb.19:                               ; %B8
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, xzr
	stp	x22, x21, [x8]
	add	sp, sp, #16
	b	l_FastJSConcatString_asm_h
LBB678_20:                              ; %B43
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x8]
	str	x20, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB678_22
; %bb.21:                               ; %B45
	ldrb	w8, [x19], #1
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB678_22:                              ; %B44
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function sub_2_asm_h
l_sub_2_asm_h:                          ; @sub_2_asm_h
; %bb.0:                                ; %B43
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB679_17
; %bb.1:                                ; %B43
	cmp	x21, x8
	b.hi	LBB679_17
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB679_6
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB679_9
; %bb.4:                                ; %B33
	subs	w8, w22, w21
	b.vs	LBB679_12
; %bb.5:                                ; %B39
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB679_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB679_17
; %bb.7:                                ; %B7
	cmp	x21, x8
	b.lo	LBB679_15
; %bb.8:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	LBB679_14
LBB679_9:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB679_17
; %bb.10:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB679_11:                              ; %B28
	fmov	d1, x8
	b	LBB679_13
LBB679_12:                              ; %B35
	scvtf	d0, w22
	scvtf	d1, w21
LBB679_13:                              ; %B28
	fsub	d0, d0, d1
LBB679_14:                              ; %B28
	ldrb	w8, [x19], #1
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	x9, x9, x10
	mov	x8, #9221683186994511872        ; =0x7ffa000000000000
	csel	x22, x9, x8, vc
	br	x1
LBB679_15:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB679_17
; %bb.16:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB679_11
LBB679_17:                              ; %B40
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        ; =0x9e
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB679_19
; %bb.18:                               ; %B42
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB679_19:                              ; %B41
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function pow_2_asm_h
l_pow_2_asm_h:                          ; @pow_2_asm_h
; %bb.0:                                ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #159                        ; =0x9f
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB680_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB680_2:                               ; %B2
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function shl_2_asm_h
l_shl_2_asm_h:                          ; @shl_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB681_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB681_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB681_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB681_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB681_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB681_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB681_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB681_9
; %bb.8:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB681_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        ; =0xa0
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB681_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB681_11:                              ; %B26
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function sar_2_asm_h
l_sar_2_asm_h:                          ; @sar_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB682_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB682_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB682_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB682_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB682_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB682_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB682_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB682_9
; %bb.8:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB682_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        ; =0xa1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB682_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB682_11:                              ; %B26
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function shr_2_asm_h
l_shr_2_asm_h:                          ; @shr_2_asm_h
; %bb.0:                                ; %B36
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB683_11
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB683_11
; %bb.2:                                ; %B10
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB683_6
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB683_11
; %bb.4:                                ; %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, LBB683_10
LBB683_5:                               ; %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB683_6:                               ; %B12
	tst	x22, #0xfffe000000000000
	b.eq	LBB683_11
; %bb.7:                                ; %B12
	cmp	x21, x8
	b.lo	LBB683_11
; %bb.8:                                ; %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB683_11
; %bb.9:                                ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, LBB683_5
LBB683_10:                              ; %B6
	ucvtf	d0, w8
	mov	x9, #562949953421312            ; =0x2000000000000
	fmov	x8, d0
	fcmp	d0, d0
	add	x8, x8, x9
	mov	x9, #9221683186994511872        ; =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB683_11:                              ; %B33
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	LBB683_13
; %bb.12:                               ; %B35
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB683_13:                              ; %B34
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lt_2_asm_h
l_lt_2_asm_h:                           ; @lt_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB684_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB684_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB684_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB684_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, lt
	br	x1
LBB684_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB684_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB684_10
; %bb.7:                                ; %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, mi
	br	x1
LBB684_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB684_12
; %bb.9:                                ; %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, mi
	br	x1
LBB684_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB684_12
; %bb.11:                               ; %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, mi
	br	x1
LBB684_12:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        ; =0xa3
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB684_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB684_14:                              ; %B22
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lte_2_asm_h
l_lte_2_asm_h:                          ; @lte_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB685_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB685_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB685_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB685_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, le
	br	x1
LBB685_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB685_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB685_10
; %bb.7:                                ; %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ls
	br	x1
LBB685_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB685_12
; %bb.9:                                ; %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ls
	br	x1
LBB685_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB685_12
; %bb.11:                               ; %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ls
	br	x1
LBB685_12:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        ; =0xa4
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB685_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB685_14:                              ; %B22
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function gt_2_asm_h
l_gt_2_asm_h:                           ; @gt_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB686_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB686_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB686_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB686_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB686_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB686_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB686_10
; %bb.7:                                ; %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB686_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB686_12
; %bb.9:                                ; %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB686_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB686_12
; %bb.11:                               ; %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB686_12:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        ; =0xa5
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB686_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB686_14:                              ; %B22
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function gte_2_asm_h
l_gte_2_asm_h:                          ; @gte_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB687_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB687_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB687_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB687_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB687_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB687_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB687_10
; %bb.7:                                ; %B13
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d1, d0
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB687_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB687_12
; %bb.9:                                ; %B19
	scvtf	d0, w22
	add	x8, x21, x8
	fmov	d1, x8
	ldrb	w9, [x19], #1
	fcmp	d0, d1
	add	w8, w9, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB687_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB687_12
; %bb.11:                               ; %B11
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	fmov	d1, x8
	ldrb	w10, [x19], #1
	fcmp	d0, d1
	add	w8, w10, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB687_12:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        ; =0xa6
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB687_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB687_14:                              ; %B22
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function instanceof_2_asm_h
l_instanceof_2_asm_h:                   ; @instanceof_2_asm_h
; %bb.0:                                ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	LBB688_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB688_2:                               ; %B2
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function in_2_asm_h
l_in_2_asm_h:                           ; @in_2_asm_h
; %bb.0:                                ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	LBB689_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB689_2:                               ; %B2
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function eq_2_asm_h
l_eq_2_asm_h:                           ; @eq_2_asm_h
; %bb.0:                                ; %B44
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB690_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB690_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB690_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB690_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB690_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB690_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB690_11
; %bb.7:                                ; %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
LBB690_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB690_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB690_10:                              ; %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
LBB690_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB690_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB690_10
LBB690_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB690_15
LBB690_14:                              ; %B8
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB690_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB690_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB690_14
	b	LBB690_20
LBB690_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB690_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB690_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB690_21
LBB690_20:                              ; %B15
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB690_21:                              ; %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB690_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB690_23:                              ; %B42
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function neq_2_asm_h
l_neq_2_asm_h:                          ; @neq_2_asm_h
; %bb.0:                                ; %B44
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB691_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB691_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB691_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB691_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB691_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB691_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB691_11
; %bb.7:                                ; %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
LBB691_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB691_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB691_10:                              ; %B39
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
LBB691_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB691_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB691_10
LBB691_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB691_15
LBB691_14:                              ; %B8
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB691_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB691_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB691_14
	b	LBB691_20
LBB691_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB691_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB691_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB691_21
LBB691_20:                              ; %B15
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB691_21:                              ; %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB691_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB691_23:                              ; %B42
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function strict_eq_2_asm_h
l_strict_eq_2_asm_h:                    ; @strict_eq_2_asm_h
; %bb.0:                                ; %B39
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB692_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB692_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB692_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB692_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB692_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB692_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB692_11
; %bb.7:                                ; %B28
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, eq
	fcmp	d1, d1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
LBB692_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB692_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB692_10:                              ; %B34
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, eq
	fcmp	d0, d0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	csel	w8, wzr, w9, vs
	orr	x22, x8, #0x6
	br	x1
LBB692_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB692_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB692_10
LBB692_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB692_15
LBB692_14:                              ; %B11
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB692_15:                              ; %B13
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          ; =0xffff000000000003
	mov	x12, #2                         ; =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x10, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w9, eq
	cmp	x10, x11
	ccmp	x10, x12, #4, ne
	cset	w11, eq
	cmp	w9, #1
	b.ne	LBB692_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB692_22
LBB692_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB692_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB692_23
LBB692_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB692_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB692_25
LBB692_21:                              ; %B21
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB692_22:                              ; %B14
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, xzr
	stp	x22, x21, [x8]
	b	l_FastStringEqual_asm_h
LBB692_23:                              ; %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB692_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB692_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB692_14
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB692_27:                              ; %B37
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function strict_neq_2_asm_h
l_strict_neq_2_asm_h:                   ; @strict_neq_2_asm_h
; %bb.0:                                ; %B39
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB693_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB693_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB693_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB693_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB693_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB693_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB693_11
; %bb.7:                                ; %B28
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	cset	w9, ne
	fcmp	d1, d1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
LBB693_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB693_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB693_10:                              ; %B34
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	cset	w9, ne
	fcmp	d0, d0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	csinc	w8, w9, wzr, vc
	orr	x22, x8, #0x6
	br	x1
LBB693_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB693_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB693_10
LBB693_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB693_15
LBB693_14:                              ; %B11
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB693_15:                              ; %B13
	and	x8, x22, #0xffff000000000003
	mov	x11, #-281474976710653          ; =0xffff000000000003
	mov	x12, #2                         ; =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	and	x10, x21, #0xffff000000000003
	ccmp	x8, x12, #4, ne
	cset	w9, eq
	cmp	x10, x11
	ccmp	x10, x12, #4, ne
	cset	w11, eq
	cmp	w9, #1
	b.ne	LBB693_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB693_22
LBB693_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB693_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB693_23
LBB693_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB693_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB693_25
LBB693_21:                              ; %B21
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB693_22:                              ; %B14
	mov	x8, x20
	add	x20, x20, #16
	mov	w0, #1                          ; =0x1
	stp	x22, x21, [x8]
	b	l_FastStringEqual_asm_h
LBB693_23:                              ; %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB693_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB693_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB693_14
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB693_27:                              ; %B37
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function and_2_asm_h
l_and_2_asm_h:                          ; @and_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB694_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB694_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB694_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB694_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	and	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB694_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB694_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB694_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB694_9
; %bb.8:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	and	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB694_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        ; =0xad
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB694_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB694_11:                              ; %B26
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function xor_2_asm_h
l_xor_2_asm_h:                          ; @xor_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB695_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB695_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB695_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB695_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	eor	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB695_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB695_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB695_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB695_9
; %bb.8:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	eor	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB695_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        ; =0xae
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB695_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB695_11:                              ; %B26
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function or_2_asm_h
l_or_2_asm_h:                           ; @or_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB696_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB696_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB696_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB696_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	orr	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB696_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB696_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB696_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB696_9
; %bb.8:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w9, [x19], #1
	orr	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB696_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        ; =0xaf
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB696_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB696_11:                              ; %B26
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function nop_2_asm_h
l_nop_2_asm_h:                          ; @nop_2_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_minus1_2_asm_h
l_push_minus1_2_asm_h:                  ; @push_minus1_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562945658454017          ; =0xfffe0000ffffffff
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_0_2_asm_h
l_push_0_2_asm_h:                       ; @push_0_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421312          ; =0xfffe000000000000
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_1_2_asm_h
l_push_1_2_asm_h:                       ; @push_1_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421311          ; =0xfffe000000000001
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_2_2_asm_h
l_push_2_2_asm_h:                       ; @push_2_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #2                         ; =0x2
	movk	x21, #65534, lsl #48
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_3_2_asm_h
l_push_3_2_asm_h:                       ; @push_3_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421309          ; =0xfffe000000000003
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_4_2_asm_h
l_push_4_2_asm_h:                       ; @push_4_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #4                         ; =0x4
	movk	x21, #65534, lsl #48
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_5_2_asm_h
l_push_5_2_asm_h:                       ; @push_5_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #5                         ; =0x5
	movk	x21, #65534, lsl #48
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_6_2_asm_h
l_push_6_2_asm_h:                       ; @push_6_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #6                         ; =0x6
	movk	x21, #65534, lsl #48
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_7_2_asm_h
l_push_7_2_asm_h:                       ; @push_7_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421305          ; =0xfffe000000000007
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_i8_2_asm_h
l_push_i8_2_asm_h:                      ; @push_i8_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	ldrb	w9, [x19, #1]
	ldrsb	x10, [x19]
	add	x19, x19, #2
	mov	x22, x21
	add	w9, w9, #486
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x8
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_i16_2_asm_h
l_push_i16_2_asm_h:                     ; @push_i16_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	ldrb	w9, [x19, #2]
	ldrsh	x10, [x19]
	add	x19, x19, #3
	mov	x22, x21
	add	w9, w9, #486
	bfxil	x8, x10, #0, #32
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x8
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_const8_2_asm_h
l_push_const8_2_asm_h:                  ; @push_const8_2_asm_h
; %bb.0:                                ; %B3
	sub	sp, sp, #16
	str	x22, [x20], #8
	ldr	x8, [x23, #112]
	ldrb	w9, [x19]
	ldr	w10, [x24, #328]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, LBB709_2
; %bb.1:                                ; %B4
	mov	x8, x20
	mov	x0, x24
	mov	x2, x19
	str	x21, [x8], #8
	str	x8, [x23, #48]
	str	x1, [sp, #8]                    ; 8-byte Folded Spill
	bl	_DebuggerPause
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
LBB709_2:                               ; %B1
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
                                        ; -- End function
	.p2align	2                               ; -- Begin function fclosure8_2_asm_h
l_fclosure8_2_asm_h:                    ; @fclosure8_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_fclosure8_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_empty_string_2_asm_h
l_push_empty_string_2_asm_h:            ; @push_empty_string_2_asm_h
; %bb.0:                                ; %B1
	str	x22, [x20]
	mov	x0, x24
	mov	w1, #47                         ; =0x2f
	str	x21, [x20, #8]!
	add	x8, x20, #8
	mov	w2, #1                          ; =0x1
	str	x8, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB711_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB711_2:                               ; %B2
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc8_2_asm_h
l_get_loc8_2_asm_h:                     ; @get_loc8_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #1]
	ldrb	w9, [x19], #2
	add	w8, w8, #486
	ldr	x9, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x9
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc8_2_asm_h
l_put_loc8_2_asm_h:                     ; @put_loc8_2_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc8_2_asm_h
l_set_loc8_2_asm_h:                     ; @set_loc8_2_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc0_2_asm_h
l_get_loc0_2_asm_h:                     ; @get_loc0_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x27]
	add	w8, w8, #486
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc1_2_asm_h
l_get_loc1_2_asm_h:                     ; @get_loc1_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x27, #8]
	add	w8, w8, #486
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc2_2_asm_h
l_get_loc2_2_asm_h:                     ; @get_loc2_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x27, #16]
	add	w8, w8, #486
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_loc3_2_asm_h
l_get_loc3_2_asm_h:                     ; @get_loc3_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x27, #24]
	add	w8, w8, #486
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc0_2_asm_h
l_put_loc0_2_asm_h:                     ; @put_loc0_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x27]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc1_2_asm_h
l_put_loc1_2_asm_h:                     ; @put_loc1_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x27, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc2_2_asm_h
l_put_loc2_2_asm_h:                     ; @put_loc2_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x27, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc3_2_asm_h
l_put_loc3_2_asm_h:                     ; @put_loc3_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x27, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc0_2_asm_h
l_set_loc0_2_asm_h:                     ; @set_loc0_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x27]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc1_2_asm_h
l_set_loc1_2_asm_h:                     ; @set_loc1_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x27, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc2_2_asm_h
l_set_loc2_2_asm_h:                     ; @set_loc2_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x27, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_loc3_2_asm_h
l_set_loc3_2_asm_h:                     ; @set_loc3_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x27, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_arg0_2_asm_h
l_get_arg0_2_asm_h:                     ; @get_arg0_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x28]
	add	w8, w8, #486
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_arg1_2_asm_h
l_get_arg1_2_asm_h:                     ; @get_arg1_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x28, #8]
	add	w8, w8, #486
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_arg2_2_asm_h
l_get_arg2_2_asm_h:                     ; @get_arg2_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x28, #16]
	add	w8, w8, #486
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_arg3_2_asm_h
l_get_arg3_2_asm_h:                     ; @get_arg3_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x9, [x28, #24]
	add	w8, w8, #486
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_arg0_2_asm_h
l_put_arg0_2_asm_h:                     ; @put_arg0_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x28]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_arg1_2_asm_h
l_put_arg1_2_asm_h:                     ; @put_arg1_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x28, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_arg2_2_asm_h
l_put_arg2_2_asm_h:                     ; @put_arg2_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x28, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_arg3_2_asm_h
l_put_arg3_2_asm_h:                     ; @put_arg3_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x28, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_arg0_2_asm_h
l_set_arg0_2_asm_h:                     ; @set_arg0_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x28]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_arg1_2_asm_h
l_set_arg1_2_asm_h:                     ; @set_arg1_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x28, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_arg2_2_asm_h
l_set_arg2_2_asm_h:                     ; @set_arg2_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x28, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_arg3_2_asm_h
l_set_arg3_2_asm_h:                     ; @set_arg3_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x28, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref0_2_asm_h
l_get_var_ref0_2_asm_h:                 ; @get_var_ref0_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x26]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8]
	mov	x21, x8
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref1_2_asm_h
l_get_var_ref1_2_asm_h:                 ; @get_var_ref1_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x26, #8]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8]
	mov	x21, x8
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref2_2_asm_h
l_get_var_ref2_2_asm_h:                 ; @get_var_ref2_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x26, #16]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8]
	mov	x21, x8
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_var_ref3_2_asm_h
l_get_var_ref3_2_asm_h:                 ; @get_var_ref3_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x26, #24]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x8, [x8]
	mov	x21, x8
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref0_2_asm_h
l_put_var_ref0_2_asm_h:                 ; @put_var_ref0_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref1_2_asm_h
l_put_var_ref1_2_asm_h:                 ; @put_var_ref1_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref2_2_asm_h
l_put_var_ref2_2_asm_h:                 ; @put_var_ref2_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_ref3_2_asm_h
l_put_var_ref3_2_asm_h:                 ; @put_var_ref3_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_var_ref0_2_asm_h
l_set_var_ref0_2_asm_h:                 ; @set_var_ref0_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_var_ref1_2_asm_h
l_set_var_ref1_2_asm_h:                 ; @set_var_ref1_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_var_ref2_2_asm_h
l_set_var_ref2_2_asm_h:                 ; @set_var_ref2_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_var_ref3_2_asm_h
l_set_var_ref3_2_asm_h:                 ; @set_var_ref3_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_length_2_asm_h
l_get_length_2_asm_h:                   ; @get_length_2_asm_h
; %bb.0:                                ; %B27
	mov	x9, #2                          ; =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	LBB751_2
; %bb.1:                                ; %B27
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB751_3
LBB751_2:                               ; %B28
	and	x8, x21, #0xfffffffffffc
	ldrb	w9, [x19], #1
	ldr	w8, [x8, #4]
	mov	x10, #-562949953421312          ; =0xfffe000000000000
	add	w9, w9, #486
	bfxil	x10, x8, #0, #30
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x10
	br	x1
LBB751_3:                               ; %B21
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	LBB751_13
; %bb.4:                                ; %B22
	mov	x9, x21
	mov	w8, #18                         ; =0x12
LBB751_5:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB751_6 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w11, #0x30
	ldr	w10, [x13, w10, uxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB751_8
LBB751_6:                               ; %B1
                                        ;   Parent Loop BB751_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, #48
	b.eq	LBB751_10
; %bb.7:                                ; %B9
                                        ;   in Loop: Header=BB751_6 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB751_6
LBB751_8:                               ; %B14
                                        ;   in Loop: Header=BB751_5 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB751_13
; %bb.9:                                ; %B17
                                        ;   in Loop: Header=BB751_5 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB751_5
	b	LBB751_12
LBB751_10:                              ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB751_13
; %bb.11:                               ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB751_12:                              ; %B6
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB751_13:                              ; %B24
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #48                         ; =0x30
	mov	x3, x21
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB751_15
; %bb.14:                               ; %B26
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB751_15:                              ; %B25
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_false8_2_asm_h
l_if_false8_2_asm_h:                    ; @if_false8_2_asm_h
; %bb.0:                                ; %B29
	cmp	x21, #5
	b.le	LBB752_4
; %bb.1:                                ; %B29
	cmp	x21, #6
	b.eq	LBB752_6
; %bb.2:                                ; %B29
	cmp	x21, #7
	b.eq	LBB752_10
; %bb.3:                                ; %B29
	cmp	x21, #18
	b.eq	LBB752_6
	b	LBB752_8
LBB752_4:                               ; %B29
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB752_6
; %bb.5:                                ; %B29
	cmp	x21, #2
	b.ne	LBB752_8
LBB752_6:                               ; %B8
	ldrsb	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB752_11
LBB752_7:                               ; %B10
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB752_8:                               ; %B15
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x21, x8
	b.hs	LBB752_16
; %bb.9:                                ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB752_13
LBB752_10:                              ; %B25
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB752_11:                              ; %B5
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB752_7
; %bb.12:                               ; %B6
	add	x19, x19, #1
	b	l_PollInterrupts_spill_top0_asm_h
LBB752_13:                              ; %B19
	tst	x21, #0xfffe000000000000
	b.eq	LBB752_16
; %bb.14:                               ; %B23
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB752_6
	b.vs	LBB752_6
; %bb.15:                               ; %B23
	tbnz	w8, #0, LBB752_10
	b	LBB752_6
LBB752_16:                              ; %B21
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_true8_2_asm_h
l_if_true8_2_asm_h:                     ; @if_true8_2_asm_h
; %bb.0:                                ; %B29
	cmp	x21, #5
	b.le	LBB753_4
; %bb.1:                                ; %B29
	cmp	x21, #6
	b.eq	LBB753_6
; %bb.2:                                ; %B29
	cmp	x21, #7
	b.eq	LBB753_9
; %bb.3:                                ; %B29
	cmp	x21, #18
	b.eq	LBB753_6
	b	LBB753_7
LBB753_4:                               ; %B29
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB753_6
; %bb.5:                                ; %B29
	cmp	x21, #2
	b.ne	LBB753_7
LBB753_6:                               ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB753_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x21, x8
	b.hs	LBB753_16
; %bb.8:                                ; %B11
	mov	x8, #-562949953421313           ; =0xfffdffffffffffff
	cmp	x21, x8
	b.ls	LBB753_13
LBB753_9:                               ; %B23
	ldrsb	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB753_11
LBB753_10:                              ; %B25
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB753_11:                              ; %B20
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB753_10
; %bb.12:                               ; %B21
	add	x19, x19, #1
	b	l_PollInterrupts_spill_top0_asm_h
LBB753_13:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB753_16
; %bb.14:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB753_6
	b.vs	LBB753_6
; %bb.15:                               ; %B17
	tbnz	w8, #0, LBB753_9
	b	LBB753_6
LBB753_16:                              ; %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto8_2_asm_h
l_goto8_2_asm_h:                        ; @goto8_2_asm_h
; %bb.0:                                ; %B5
	ldrsb	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB754_2
LBB754_1:                               ; %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB754_2:                               ; %B2
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB754_1
; %bb.3:                                ; %B3
	add	x19, x19, #1
	b	l_PollInterrupts_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto16_2_asm_h
l_goto16_2_asm_h:                       ; @goto16_2_asm_h
; %bb.0:                                ; %B5
	ldrsh	x8, [x19]
	add	x19, x19, x8
	tbnz	x8, #63, LBB755_2
LBB755_1:                               ; %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB755_2:                               ; %B2
	ldr	w8, [x24, #232]
	subs	w8, w8, #1
	str	w8, [x24, #232]
	b.pl	LBB755_1
; %bb.3:                                ; %B3
	add	x19, x19, #1
	b	l_PollInterrupts_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call0_2_asm_h
l_call0_2_asm_h:                        ; @call0_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_call0_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call1_2_asm_h
l_call1_2_asm_h:                        ; @call1_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_call1_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call2_2_asm_h
l_call2_2_asm_h:                        ; @call2_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_call2_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function call3_2_asm_h
l_call3_2_asm_h:                        ; @call3_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_call3_0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function is_undefined_2_asm_h
l_is_undefined_2_asm_h:                 ; @is_undefined_2_asm_h
; %bb.0:                                ; %B2
	cmp	x21, #18
	b.ne	LBB760_2
; %bb.1:                                ; %B3
	mov	w21, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB760_2:                               ; %B5
	mov	w21, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function is_null_2_asm_h
l_is_null_2_asm_h:                      ; @is_null_2_asm_h
; %bb.0:                                ; %B2
	cmp	x21, #2
	b.ne	LBB761_2
; %bb.1:                                ; %B3
	mov	w21, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB761_2:                               ; %B5
	mov	w21, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function is_function_2_asm_h
l_is_function_2_asm_h:                  ; @is_function_2_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x21
	bl	_js_operator_typeof_gc
	cmp	w0, #27
	b.ne	LBB762_2
; %bb.1:                                ; %B2
	mov	w21, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB762_2:                               ; %B5
	mov	w21, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function inc_coverage_2_asm_h
l_inc_coverage_2_asm_h:                 ; @inc_coverage_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	l_inc_coverage_0_asm_h
                                        ; -- End function
	.private_extern	__call_stub_entry       ; -- Begin function _call_stub_entry
	.globl	__call_stub_entry
	.p2align	2
__call_stub_entry:                      ; @_call_stub_entry
	.cfi_startproc
; %bb.0:                                ; %B0
	stp	x28, x27, [sp, #-96]!           ; 16-byte Folded Spill
	stp	x26, x25, [sp, #16]             ; 16-byte Folded Spill
	stp	x24, x23, [sp, #32]             ; 16-byte Folded Spill
	stp	x22, x21, [sp, #48]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #64]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #80]             ; 16-byte Folded Spill
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
	bl	l_common_call_from_entry_asm_h
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #48]             ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #32]             ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #16]             ; 16-byte Folded Reload
	ldp	x28, x27, [sp], #96             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__const
	.p2align	3, 0x0                          ; @0
l___unnamed_1:
	.asciz	"'this' can be initialized only once"

	.p2align	3, 0x0                          ; @1
l___unnamed_2:
	.asciz	"invalid opcode: pc=%u opcode=0x%02x"

	.p2align	3, 0x0                          ; @2
l___unnamed_3:
	.asciz	"derived class constructor must return an object or undefined"

	.p2align	3, 0x0                          ; @3
l___unnamed_4:
	.asciz	"class constructors must be invoked with 'new'"

	.p2align	3, 0x0                          ; @4
l___unnamed_6:
	.asciz	"unsupported reference to 'super'"

	.p2align	3, 0x0                          ; @5
l___unnamed_5:
	.asciz	"iterator does not have a throw method"

	.p2align	3, 0x0                          ; @6
l___unnamed_7:
	.asciz	"invalid throw var type %d"

	.p2align	3, 0x0                          ; @7
l___unnamed_8:
	.asciz	"invalid ret value"

	.p2align	3, 0x0                          ; @8
l___unnamed_9:
	.asciz	"value has no property"

	.p2align	3, 0x0                          ; @9
l___unnamed_10:
	.asciz	"iterator_close_return"

	.p2align	3, 0x0                          ; @10
l___unnamed_11:
	.asciz	"invalid opcode: pc=%u opcode=0x%02x"

	.p2align	3, 0x0                          ; @11
l___unnamed_12:
	.asciz	"value has no property"

	.p2align	3, 0x0                          ; @12
l___unnamed_13:
	.asciz	"invalid opcode: pc=%u opcode=0x%02x"

	.p2align	3, 0x0                          ; @13
l___unnamed_14:
	.asciz	"value has no property"

	.private_extern	_primjs_dispatch_table  ; @primjs_dispatch_table
	.section	__DATA,__const
	.globl	_primjs_dispatch_table
	.p2align	3, 0x0
_primjs_dispatch_table:
	.quad	l_invalid_0_asm_h
	.quad	l_push_i32_0_asm_h
	.quad	l_push_const_0_asm_h
	.quad	l_fclosure_0_asm_h
	.quad	l_push_atom_value_0_asm_h
	.quad	l_private_symbol_0_asm_h
	.quad	l_undefined_0_asm_h
	.quad	l_null_0_asm_h
	.quad	l_push_this_0_asm_h
	.quad	l_push_false_0_asm_h
	.quad	l_push_true_0_asm_h
	.quad	l_object_0_asm_h
	.quad	l_special_object_0_asm_h
	.quad	l_rest_0_asm_h
	.quad	l_drop_0_asm_h
	.quad	l_nip_0_asm_h
	.quad	l_nip1_0_asm_h
	.quad	l_dup_0_asm_h
	.quad	l_dup1_0_asm_h
	.quad	l_dup2_0_asm_h
	.quad	l_dup3_0_asm_h
	.quad	l_insert2_0_asm_h
	.quad	l_insert3_0_asm_h
	.quad	l_insert4_0_asm_h
	.quad	l_perm3_0_asm_h
	.quad	l_perm4_0_asm_h
	.quad	l_perm5_0_asm_h
	.quad	l_swap_0_asm_h
	.quad	l_swap2_0_asm_h
	.quad	l_rot3l_0_asm_h
	.quad	l_rot3r_0_asm_h
	.quad	l_rot4l_0_asm_h
	.quad	l_rot5l_0_asm_h
	.quad	l_call_constructor_0_asm_h
	.quad	l_call_0_asm_h
	.quad	l_tail_call_0_asm_h
	.quad	l_call_method_0_asm_h
	.quad	l_tail_call_method_0_asm_h
	.quad	l_array_from_0_asm_h
	.quad	l_apply_0_asm_h
	.quad	l_return_0_asm_h
	.quad	l_return_undef_0_asm_h
	.quad	l_check_ctor_return_0_asm_h
	.quad	l_check_ctor_0_asm_h
	.quad	l_check_brand_0_asm_h
	.quad	l_add_brand_0_asm_h
	.quad	l_return_async_0_asm_h
	.quad	l_throw_0_asm_h
	.quad	l_throw_var_0_asm_h
	.quad	l_eval_0_asm_h
	.quad	l_regexp_0_asm_h
	.quad	l_get_super_ctor_0_asm_h
	.quad	l_get_super_0_asm_h
	.quad	l_import_0_asm_h
	.quad	l_check_var_0_asm_h
	.quad	l_get_var_undef_0_asm_h
	.quad	l_get_var_0_asm_h
	.quad	l_put_var_0_asm_h
	.quad	l_put_var_init_0_asm_h
	.quad	l_put_var_strict_0_asm_h
	.quad	l_get_ref_value_0_asm_h
	.quad	l_put_ref_value_0_asm_h
	.quad	l_define_var_0_asm_h
	.quad	l_check_define_var_0_asm_h
	.quad	l_define_func_0_asm_h
	.quad	l_get_field_0_asm_h
	.quad	l_get_field2_0_asm_h
	.quad	l_put_field_0_asm_h
	.quad	l_get_private_field_0_asm_h
	.quad	l_put_private_field_0_asm_h
	.quad	l_define_private_field_0_asm_h
	.quad	l_get_array_el_0_asm_h
	.quad	l_get_array_el2_0_asm_h
	.quad	l_put_array_el_0_asm_h
	.quad	l_get_super_value_0_asm_h
	.quad	l_put_super_value_0_asm_h
	.quad	l_define_field_0_asm_h
	.quad	l_set_name_0_asm_h
	.quad	l_set_name_computed_0_asm_h
	.quad	l_set_proto_0_asm_h
	.quad	l_set_home_object_0_asm_h
	.quad	l_define_array_el_0_asm_h
	.quad	l_append_0_asm_h
	.quad	l_copy_data_properties_0_asm_h
	.quad	l_define_method_0_asm_h
	.quad	l_define_method_computed_0_asm_h
	.quad	l_define_class_0_asm_h
	.quad	l_get_loc_0_asm_h
	.quad	l_put_loc_0_asm_h
	.quad	l_set_loc_0_asm_h
	.quad	l_get_arg_0_asm_h
	.quad	l_put_arg_0_asm_h
	.quad	l_set_arg_0_asm_h
	.quad	l_get_var_ref_0_asm_h
	.quad	l_put_var_ref_0_asm_h
	.quad	l_set_var_ref_0_asm_h
	.quad	l_set_loc_uninitialized_0_asm_h
	.quad	l_get_loc_check_0_asm_h
	.quad	l_put_loc_check_0_asm_h
	.quad	l_put_loc_check_init_0_asm_h
	.quad	l_get_var_ref_check_0_asm_h
	.quad	l_put_var_ref_check_0_asm_h
	.quad	l_put_var_ref_check_init_0_asm_h
	.quad	l_close_loc_0_asm_h
	.quad	l_if_false_0_asm_h
	.quad	l_if_true_0_asm_h
	.quad	l_goto_0_asm_h
	.quad	l_catch_0_asm_h
	.quad	l_gosub_0_asm_h
	.quad	l_ret_0_asm_h
	.quad	l_to_object_0_asm_h
	.quad	l_to_propkey_0_asm_h
	.quad	l_to_propkey2_0_asm_h
	.quad	l_with_get_var_0_asm_h
	.quad	l_with_put_var_0_asm_h
	.quad	l_with_delete_var_0_asm_h
	.quad	l_with_make_ref_0_asm_h
	.quad	l_with_get_ref_0_asm_h
	.quad	l_with_get_ref_undef_0_asm_h
	.quad	l_make_loc_ref_0_asm_h
	.quad	l_make_arg_ref_0_asm_h
	.quad	l_make_var_ref_ref_0_asm_h
	.quad	l_make_var_ref_0_asm_h
	.quad	l_for_in_start_0_asm_h
	.quad	l_for_of_start_0_asm_h
	.quad	l_for_await_of_start_0_asm_h
	.quad	l_for_in_next_0_asm_h
	.quad	l_for_of_next_0_asm_h
	.quad	l_for_await_of_next_0_asm_h
	.quad	l_iterator_get_value_done_0_asm_h
	.quad	l_iterator_close_0_asm_h
	.quad	l_iterator_close_return_0_asm_h
	.quad	l_async_iterator_close_0_asm_h
	.quad	l_async_iterator_next_0_asm_h
	.quad	l_async_iterator_get_0_asm_h
	.quad	l_initial_yield_0_asm_h
	.quad	l_yield_0_asm_h
	.quad	l_yield_star_0_asm_h
	.quad	l_async_yield_star_0_asm_h
	.quad	l_await_0_asm_h
	.quad	l_neg_0_asm_h
	.quad	l_plus_0_asm_h
	.quad	l_dec_0_asm_h
	.quad	l_inc_0_asm_h
	.quad	l_post_dec_0_asm_h
	.quad	l_post_inc_0_asm_h
	.quad	l_dec_loc_0_asm_h
	.quad	l_inc_loc_0_asm_h
	.quad	l_add_loc_0_asm_h
	.quad	l_not_0_asm_h
	.quad	l_lnot_0_asm_h
	.quad	l_typeof_0_asm_h
	.quad	l_delete_0_asm_h
	.quad	l_delete_var_0_asm_h
	.quad	l_mul_0_asm_h
	.quad	l_div_0_asm_h
	.quad	l_mod_0_asm_h
	.quad	l_add_0_asm_h
	.quad	l_sub_0_asm_h
	.quad	l_pow_0_asm_h
	.quad	l_shl_0_asm_h
	.quad	l_sar_0_asm_h
	.quad	l_shr_0_asm_h
	.quad	l_lt_0_asm_h
	.quad	l_lte_0_asm_h
	.quad	l_gt_0_asm_h
	.quad	l_gte_0_asm_h
	.quad	l_instanceof_0_asm_h
	.quad	l_in_0_asm_h
	.quad	l_eq_0_asm_h
	.quad	l_neq_0_asm_h
	.quad	l_strict_eq_0_asm_h
	.quad	l_strict_neq_0_asm_h
	.quad	l_and_0_asm_h
	.quad	l_xor_0_asm_h
	.quad	l_or_0_asm_h
	.quad	l_nop_0_asm_h
	.quad	l_push_minus1_0_asm_h
	.quad	l_push_0_0_asm_h
	.quad	l_push_1_0_asm_h
	.quad	l_push_2_0_asm_h
	.quad	l_push_3_0_asm_h
	.quad	l_push_4_0_asm_h
	.quad	l_push_5_0_asm_h
	.quad	l_push_6_0_asm_h
	.quad	l_push_7_0_asm_h
	.quad	l_push_i8_0_asm_h
	.quad	l_push_i16_0_asm_h
	.quad	l_push_const8_0_asm_h
	.quad	l_fclosure8_0_asm_h
	.quad	l_push_empty_string_0_asm_h
	.quad	l_get_loc8_0_asm_h
	.quad	l_put_loc8_0_asm_h
	.quad	l_set_loc8_0_asm_h
	.quad	l_get_loc0_0_asm_h
	.quad	l_get_loc1_0_asm_h
	.quad	l_get_loc2_0_asm_h
	.quad	l_get_loc3_0_asm_h
	.quad	l_put_loc0_0_asm_h
	.quad	l_put_loc1_0_asm_h
	.quad	l_put_loc2_0_asm_h
	.quad	l_put_loc3_0_asm_h
	.quad	l_set_loc0_0_asm_h
	.quad	l_set_loc1_0_asm_h
	.quad	l_set_loc2_0_asm_h
	.quad	l_set_loc3_0_asm_h
	.quad	l_get_arg0_0_asm_h
	.quad	l_get_arg1_0_asm_h
	.quad	l_get_arg2_0_asm_h
	.quad	l_get_arg3_0_asm_h
	.quad	l_put_arg0_0_asm_h
	.quad	l_put_arg1_0_asm_h
	.quad	l_put_arg2_0_asm_h
	.quad	l_put_arg3_0_asm_h
	.quad	l_set_arg0_0_asm_h
	.quad	l_set_arg1_0_asm_h
	.quad	l_set_arg2_0_asm_h
	.quad	l_set_arg3_0_asm_h
	.quad	l_get_var_ref0_0_asm_h
	.quad	l_get_var_ref1_0_asm_h
	.quad	l_get_var_ref2_0_asm_h
	.quad	l_get_var_ref3_0_asm_h
	.quad	l_put_var_ref0_0_asm_h
	.quad	l_put_var_ref1_0_asm_h
	.quad	l_put_var_ref2_0_asm_h
	.quad	l_put_var_ref3_0_asm_h
	.quad	l_set_var_ref0_0_asm_h
	.quad	l_set_var_ref1_0_asm_h
	.quad	l_set_var_ref2_0_asm_h
	.quad	l_set_var_ref3_0_asm_h
	.quad	l_get_length_0_asm_h
	.quad	l_if_false8_0_asm_h
	.quad	l_if_true8_0_asm_h
	.quad	l_goto8_0_asm_h
	.quad	l_goto16_0_asm_h
	.quad	l_call0_0_asm_h
	.quad	l_call1_0_asm_h
	.quad	l_call2_0_asm_h
	.quad	l_call3_0_asm_h
	.quad	l_is_undefined_0_asm_h
	.quad	l_is_null_0_asm_h
	.quad	l_is_function_0_asm_h
	.quad	l_inc_coverage_0_asm_h
	.quad	l_invalid_1_asm_h
	.quad	l_push_i32_1_asm_h
	.quad	l_push_const_1_asm_h
	.quad	l_fclosure_1_asm_h
	.quad	l_push_atom_value_1_asm_h
	.quad	l_private_symbol_1_asm_h
	.quad	l_undefined_1_asm_h
	.quad	l_null_1_asm_h
	.quad	l_push_this_1_asm_h
	.quad	l_push_false_1_asm_h
	.quad	l_push_true_1_asm_h
	.quad	l_object_1_asm_h
	.quad	l_special_object_1_asm_h
	.quad	l_rest_1_asm_h
	.quad	l_drop_1_asm_h
	.quad	l_nip_1_asm_h
	.quad	l_nip1_1_asm_h
	.quad	l_dup_1_asm_h
	.quad	l_dup1_1_asm_h
	.quad	l_dup2_1_asm_h
	.quad	l_dup3_1_asm_h
	.quad	l_insert2_1_asm_h
	.quad	l_insert3_1_asm_h
	.quad	l_insert4_1_asm_h
	.quad	l_perm3_1_asm_h
	.quad	l_perm4_1_asm_h
	.quad	l_perm5_1_asm_h
	.quad	l_swap_1_asm_h
	.quad	l_swap2_1_asm_h
	.quad	l_rot3l_1_asm_h
	.quad	l_rot3r_1_asm_h
	.quad	l_rot4l_1_asm_h
	.quad	l_rot5l_1_asm_h
	.quad	l_call_constructor_1_asm_h
	.quad	l_call_1_asm_h
	.quad	l_tail_call_1_asm_h
	.quad	l_call_method_1_asm_h
	.quad	l_tail_call_method_1_asm_h
	.quad	l_array_from_1_asm_h
	.quad	l_apply_1_asm_h
	.quad	l_return_1_asm_h
	.quad	l_return_undef_1_asm_h
	.quad	l_check_ctor_return_1_asm_h
	.quad	l_check_ctor_1_asm_h
	.quad	l_check_brand_1_asm_h
	.quad	l_add_brand_1_asm_h
	.quad	l_return_async_1_asm_h
	.quad	l_throw_1_asm_h
	.quad	l_throw_var_1_asm_h
	.quad	l_eval_1_asm_h
	.quad	l_regexp_1_asm_h
	.quad	l_get_super_ctor_1_asm_h
	.quad	l_get_super_1_asm_h
	.quad	l_import_1_asm_h
	.quad	l_check_var_1_asm_h
	.quad	l_get_var_undef_1_asm_h
	.quad	l_get_var_1_asm_h
	.quad	l_put_var_1_asm_h
	.quad	l_put_var_init_1_asm_h
	.quad	l_put_var_strict_1_asm_h
	.quad	l_get_ref_value_1_asm_h
	.quad	l_put_ref_value_1_asm_h
	.quad	l_define_var_1_asm_h
	.quad	l_check_define_var_1_asm_h
	.quad	l_define_func_1_asm_h
	.quad	l_get_field_1_asm_h
	.quad	l_get_field2_1_asm_h
	.quad	l_put_field_1_asm_h
	.quad	l_get_private_field_1_asm_h
	.quad	l_put_private_field_1_asm_h
	.quad	l_define_private_field_1_asm_h
	.quad	l_get_array_el_1_asm_h
	.quad	l_get_array_el2_1_asm_h
	.quad	l_put_array_el_1_asm_h
	.quad	l_get_super_value_1_asm_h
	.quad	l_put_super_value_1_asm_h
	.quad	l_define_field_1_asm_h
	.quad	l_set_name_1_asm_h
	.quad	l_set_name_computed_1_asm_h
	.quad	l_set_proto_1_asm_h
	.quad	l_set_home_object_1_asm_h
	.quad	l_define_array_el_1_asm_h
	.quad	l_append_1_asm_h
	.quad	l_copy_data_properties_1_asm_h
	.quad	l_define_method_1_asm_h
	.quad	l_define_method_computed_1_asm_h
	.quad	l_define_class_1_asm_h
	.quad	l_get_loc_1_asm_h
	.quad	l_put_loc_1_asm_h
	.quad	l_set_loc_1_asm_h
	.quad	l_get_arg_1_asm_h
	.quad	l_put_arg_1_asm_h
	.quad	l_set_arg_1_asm_h
	.quad	l_get_var_ref_1_asm_h
	.quad	l_put_var_ref_1_asm_h
	.quad	l_set_var_ref_1_asm_h
	.quad	l_set_loc_uninitialized_1_asm_h
	.quad	l_get_loc_check_1_asm_h
	.quad	l_put_loc_check_1_asm_h
	.quad	l_put_loc_check_init_1_asm_h
	.quad	l_get_var_ref_check_1_asm_h
	.quad	l_put_var_ref_check_1_asm_h
	.quad	l_put_var_ref_check_init_1_asm_h
	.quad	l_close_loc_1_asm_h
	.quad	l_if_false_1_asm_h
	.quad	l_if_true_1_asm_h
	.quad	l_goto_1_asm_h
	.quad	l_catch_1_asm_h
	.quad	l_gosub_1_asm_h
	.quad	l_ret_1_asm_h
	.quad	l_to_object_1_asm_h
	.quad	l_to_propkey_1_asm_h
	.quad	l_to_propkey2_1_asm_h
	.quad	l_with_get_var_1_asm_h
	.quad	l_with_put_var_1_asm_h
	.quad	l_with_delete_var_1_asm_h
	.quad	l_with_make_ref_1_asm_h
	.quad	l_with_get_ref_1_asm_h
	.quad	l_with_get_ref_undef_1_asm_h
	.quad	l_make_loc_ref_1_asm_h
	.quad	l_make_arg_ref_1_asm_h
	.quad	l_make_var_ref_ref_1_asm_h
	.quad	l_make_var_ref_1_asm_h
	.quad	l_for_in_start_1_asm_h
	.quad	l_for_of_start_1_asm_h
	.quad	l_for_await_of_start_1_asm_h
	.quad	l_for_in_next_1_asm_h
	.quad	l_for_of_next_1_asm_h
	.quad	l_for_await_of_next_1_asm_h
	.quad	l_iterator_get_value_done_1_asm_h
	.quad	l_iterator_close_1_asm_h
	.quad	l_iterator_close_return_1_asm_h
	.quad	l_async_iterator_close_1_asm_h
	.quad	l_async_iterator_next_1_asm_h
	.quad	l_async_iterator_get_1_asm_h
	.quad	l_initial_yield_1_asm_h
	.quad	l_yield_1_asm_h
	.quad	l_yield_star_1_asm_h
	.quad	l_async_yield_star_1_asm_h
	.quad	l_await_1_asm_h
	.quad	l_neg_1_asm_h
	.quad	l_plus_1_asm_h
	.quad	l_dec_1_asm_h
	.quad	l_inc_1_asm_h
	.quad	l_post_dec_1_asm_h
	.quad	l_post_inc_1_asm_h
	.quad	l_dec_loc_1_asm_h
	.quad	l_inc_loc_1_asm_h
	.quad	l_add_loc_1_asm_h
	.quad	l_not_1_asm_h
	.quad	l_lnot_1_asm_h
	.quad	l_typeof_1_asm_h
	.quad	l_delete_1_asm_h
	.quad	l_delete_var_1_asm_h
	.quad	l_mul_1_asm_h
	.quad	l_div_1_asm_h
	.quad	l_mod_1_asm_h
	.quad	l_add_1_asm_h
	.quad	l_sub_1_asm_h
	.quad	l_pow_1_asm_h
	.quad	l_shl_1_asm_h
	.quad	l_sar_1_asm_h
	.quad	l_shr_1_asm_h
	.quad	l_lt_1_asm_h
	.quad	l_lte_1_asm_h
	.quad	l_gt_1_asm_h
	.quad	l_gte_1_asm_h
	.quad	l_instanceof_1_asm_h
	.quad	l_in_1_asm_h
	.quad	l_eq_1_asm_h
	.quad	l_neq_1_asm_h
	.quad	l_strict_eq_1_asm_h
	.quad	l_strict_neq_1_asm_h
	.quad	l_and_1_asm_h
	.quad	l_xor_1_asm_h
	.quad	l_or_1_asm_h
	.quad	l_nop_1_asm_h
	.quad	l_push_minus1_1_asm_h
	.quad	l_push_0_1_asm_h
	.quad	l_push_1_1_asm_h
	.quad	l_push_2_1_asm_h
	.quad	l_push_3_1_asm_h
	.quad	l_push_4_1_asm_h
	.quad	l_push_5_1_asm_h
	.quad	l_push_6_1_asm_h
	.quad	l_push_7_1_asm_h
	.quad	l_push_i8_1_asm_h
	.quad	l_push_i16_1_asm_h
	.quad	l_push_const8_1_asm_h
	.quad	l_fclosure8_1_asm_h
	.quad	l_push_empty_string_1_asm_h
	.quad	l_get_loc8_1_asm_h
	.quad	l_put_loc8_1_asm_h
	.quad	l_set_loc8_1_asm_h
	.quad	l_get_loc0_1_asm_h
	.quad	l_get_loc1_1_asm_h
	.quad	l_get_loc2_1_asm_h
	.quad	l_get_loc3_1_asm_h
	.quad	l_put_loc0_1_asm_h
	.quad	l_put_loc1_1_asm_h
	.quad	l_put_loc2_1_asm_h
	.quad	l_put_loc3_1_asm_h
	.quad	l_set_loc0_1_asm_h
	.quad	l_set_loc1_1_asm_h
	.quad	l_set_loc2_1_asm_h
	.quad	l_set_loc3_1_asm_h
	.quad	l_get_arg0_1_asm_h
	.quad	l_get_arg1_1_asm_h
	.quad	l_get_arg2_1_asm_h
	.quad	l_get_arg3_1_asm_h
	.quad	l_put_arg0_1_asm_h
	.quad	l_put_arg1_1_asm_h
	.quad	l_put_arg2_1_asm_h
	.quad	l_put_arg3_1_asm_h
	.quad	l_set_arg0_1_asm_h
	.quad	l_set_arg1_1_asm_h
	.quad	l_set_arg2_1_asm_h
	.quad	l_set_arg3_1_asm_h
	.quad	l_get_var_ref0_1_asm_h
	.quad	l_get_var_ref1_1_asm_h
	.quad	l_get_var_ref2_1_asm_h
	.quad	l_get_var_ref3_1_asm_h
	.quad	l_put_var_ref0_1_asm_h
	.quad	l_put_var_ref1_1_asm_h
	.quad	l_put_var_ref2_1_asm_h
	.quad	l_put_var_ref3_1_asm_h
	.quad	l_set_var_ref0_1_asm_h
	.quad	l_set_var_ref1_1_asm_h
	.quad	l_set_var_ref2_1_asm_h
	.quad	l_set_var_ref3_1_asm_h
	.quad	l_get_length_1_asm_h
	.quad	l_if_false8_1_asm_h
	.quad	l_if_true8_1_asm_h
	.quad	l_goto8_1_asm_h
	.quad	l_goto16_1_asm_h
	.quad	l_call0_1_asm_h
	.quad	l_call1_1_asm_h
	.quad	l_call2_1_asm_h
	.quad	l_call3_1_asm_h
	.quad	l_is_undefined_1_asm_h
	.quad	l_is_null_1_asm_h
	.quad	l_is_function_1_asm_h
	.quad	l_inc_coverage_1_asm_h
	.quad	l_invalid_2_asm_h
	.quad	l_push_i32_2_asm_h
	.quad	l_push_const_2_asm_h
	.quad	l_fclosure_2_asm_h
	.quad	l_push_atom_value_2_asm_h
	.quad	l_private_symbol_2_asm_h
	.quad	l_undefined_2_asm_h
	.quad	l_null_2_asm_h
	.quad	l_push_this_2_asm_h
	.quad	l_push_false_2_asm_h
	.quad	l_push_true_2_asm_h
	.quad	l_object_2_asm_h
	.quad	l_special_object_2_asm_h
	.quad	l_rest_2_asm_h
	.quad	l_drop_2_asm_h
	.quad	l_nip_2_asm_h
	.quad	l_nip1_2_asm_h
	.quad	l_dup_2_asm_h
	.quad	l_dup1_2_asm_h
	.quad	l_dup2_2_asm_h
	.quad	l_dup3_2_asm_h
	.quad	l_insert2_2_asm_h
	.quad	l_insert3_2_asm_h
	.quad	l_insert4_2_asm_h
	.quad	l_perm3_2_asm_h
	.quad	l_perm4_2_asm_h
	.quad	l_perm5_2_asm_h
	.quad	l_swap_2_asm_h
	.quad	l_swap2_2_asm_h
	.quad	l_rot3l_2_asm_h
	.quad	l_rot3r_2_asm_h
	.quad	l_rot4l_2_asm_h
	.quad	l_rot5l_2_asm_h
	.quad	l_call_constructor_2_asm_h
	.quad	l_call_2_asm_h
	.quad	l_tail_call_2_asm_h
	.quad	l_call_method_2_asm_h
	.quad	l_tail_call_method_2_asm_h
	.quad	l_array_from_2_asm_h
	.quad	l_apply_2_asm_h
	.quad	l_return_2_asm_h
	.quad	l_return_undef_2_asm_h
	.quad	l_check_ctor_return_2_asm_h
	.quad	l_check_ctor_2_asm_h
	.quad	l_check_brand_2_asm_h
	.quad	l_add_brand_2_asm_h
	.quad	l_return_async_2_asm_h
	.quad	l_throw_2_asm_h
	.quad	l_throw_var_2_asm_h
	.quad	l_eval_2_asm_h
	.quad	l_regexp_2_asm_h
	.quad	l_get_super_ctor_2_asm_h
	.quad	l_get_super_2_asm_h
	.quad	l_import_2_asm_h
	.quad	l_check_var_2_asm_h
	.quad	l_get_var_undef_2_asm_h
	.quad	l_get_var_2_asm_h
	.quad	l_put_var_2_asm_h
	.quad	l_put_var_init_2_asm_h
	.quad	l_put_var_strict_2_asm_h
	.quad	l_get_ref_value_2_asm_h
	.quad	l_put_ref_value_2_asm_h
	.quad	l_define_var_2_asm_h
	.quad	l_check_define_var_2_asm_h
	.quad	l_define_func_2_asm_h
	.quad	l_get_field_2_asm_h
	.quad	l_get_field2_2_asm_h
	.quad	l_put_field_2_asm_h
	.quad	l_get_private_field_2_asm_h
	.quad	l_put_private_field_2_asm_h
	.quad	l_define_private_field_2_asm_h
	.quad	l_get_array_el_2_asm_h
	.quad	l_get_array_el2_2_asm_h
	.quad	l_put_array_el_2_asm_h
	.quad	l_get_super_value_2_asm_h
	.quad	l_put_super_value_2_asm_h
	.quad	l_define_field_2_asm_h
	.quad	l_set_name_2_asm_h
	.quad	l_set_name_computed_2_asm_h
	.quad	l_set_proto_2_asm_h
	.quad	l_set_home_object_2_asm_h
	.quad	l_define_array_el_2_asm_h
	.quad	l_append_2_asm_h
	.quad	l_copy_data_properties_2_asm_h
	.quad	l_define_method_2_asm_h
	.quad	l_define_method_computed_2_asm_h
	.quad	l_define_class_2_asm_h
	.quad	l_get_loc_2_asm_h
	.quad	l_put_loc_2_asm_h
	.quad	l_set_loc_2_asm_h
	.quad	l_get_arg_2_asm_h
	.quad	l_put_arg_2_asm_h
	.quad	l_set_arg_2_asm_h
	.quad	l_get_var_ref_2_asm_h
	.quad	l_put_var_ref_2_asm_h
	.quad	l_set_var_ref_2_asm_h
	.quad	l_set_loc_uninitialized_2_asm_h
	.quad	l_get_loc_check_2_asm_h
	.quad	l_put_loc_check_2_asm_h
	.quad	l_put_loc_check_init_2_asm_h
	.quad	l_get_var_ref_check_2_asm_h
	.quad	l_put_var_ref_check_2_asm_h
	.quad	l_put_var_ref_check_init_2_asm_h
	.quad	l_close_loc_2_asm_h
	.quad	l_if_false_2_asm_h
	.quad	l_if_true_2_asm_h
	.quad	l_goto_2_asm_h
	.quad	l_catch_2_asm_h
	.quad	l_gosub_2_asm_h
	.quad	l_ret_2_asm_h
	.quad	l_to_object_2_asm_h
	.quad	l_to_propkey_2_asm_h
	.quad	l_to_propkey2_2_asm_h
	.quad	l_with_get_var_2_asm_h
	.quad	l_with_put_var_2_asm_h
	.quad	l_with_delete_var_2_asm_h
	.quad	l_with_make_ref_2_asm_h
	.quad	l_with_get_ref_2_asm_h
	.quad	l_with_get_ref_undef_2_asm_h
	.quad	l_make_loc_ref_2_asm_h
	.quad	l_make_arg_ref_2_asm_h
	.quad	l_make_var_ref_ref_2_asm_h
	.quad	l_make_var_ref_2_asm_h
	.quad	l_for_in_start_2_asm_h
	.quad	l_for_of_start_2_asm_h
	.quad	l_for_await_of_start_2_asm_h
	.quad	l_for_in_next_2_asm_h
	.quad	l_for_of_next_2_asm_h
	.quad	l_for_await_of_next_2_asm_h
	.quad	l_iterator_get_value_done_2_asm_h
	.quad	l_iterator_close_2_asm_h
	.quad	l_iterator_close_return_2_asm_h
	.quad	l_async_iterator_close_2_asm_h
	.quad	l_async_iterator_next_2_asm_h
	.quad	l_async_iterator_get_2_asm_h
	.quad	l_initial_yield_2_asm_h
	.quad	l_yield_2_asm_h
	.quad	l_yield_star_2_asm_h
	.quad	l_async_yield_star_2_asm_h
	.quad	l_await_2_asm_h
	.quad	l_neg_2_asm_h
	.quad	l_plus_2_asm_h
	.quad	l_dec_2_asm_h
	.quad	l_inc_2_asm_h
	.quad	l_post_dec_2_asm_h
	.quad	l_post_inc_2_asm_h
	.quad	l_dec_loc_2_asm_h
	.quad	l_inc_loc_2_asm_h
	.quad	l_add_loc_2_asm_h
	.quad	l_not_2_asm_h
	.quad	l_lnot_2_asm_h
	.quad	l_typeof_2_asm_h
	.quad	l_delete_2_asm_h
	.quad	l_delete_var_2_asm_h
	.quad	l_mul_2_asm_h
	.quad	l_div_2_asm_h
	.quad	l_mod_2_asm_h
	.quad	l_add_2_asm_h
	.quad	l_sub_2_asm_h
	.quad	l_pow_2_asm_h
	.quad	l_shl_2_asm_h
	.quad	l_sar_2_asm_h
	.quad	l_shr_2_asm_h
	.quad	l_lt_2_asm_h
	.quad	l_lte_2_asm_h
	.quad	l_gt_2_asm_h
	.quad	l_gte_2_asm_h
	.quad	l_instanceof_2_asm_h
	.quad	l_in_2_asm_h
	.quad	l_eq_2_asm_h
	.quad	l_neq_2_asm_h
	.quad	l_strict_eq_2_asm_h
	.quad	l_strict_neq_2_asm_h
	.quad	l_and_2_asm_h
	.quad	l_xor_2_asm_h
	.quad	l_or_2_asm_h
	.quad	l_nop_2_asm_h
	.quad	l_push_minus1_2_asm_h
	.quad	l_push_0_2_asm_h
	.quad	l_push_1_2_asm_h
	.quad	l_push_2_2_asm_h
	.quad	l_push_3_2_asm_h
	.quad	l_push_4_2_asm_h
	.quad	l_push_5_2_asm_h
	.quad	l_push_6_2_asm_h
	.quad	l_push_7_2_asm_h
	.quad	l_push_i8_2_asm_h
	.quad	l_push_i16_2_asm_h
	.quad	l_push_const8_2_asm_h
	.quad	l_fclosure8_2_asm_h
	.quad	l_push_empty_string_2_asm_h
	.quad	l_get_loc8_2_asm_h
	.quad	l_put_loc8_2_asm_h
	.quad	l_set_loc8_2_asm_h
	.quad	l_get_loc0_2_asm_h
	.quad	l_get_loc1_2_asm_h
	.quad	l_get_loc2_2_asm_h
	.quad	l_get_loc3_2_asm_h
	.quad	l_put_loc0_2_asm_h
	.quad	l_put_loc1_2_asm_h
	.quad	l_put_loc2_2_asm_h
	.quad	l_put_loc3_2_asm_h
	.quad	l_set_loc0_2_asm_h
	.quad	l_set_loc1_2_asm_h
	.quad	l_set_loc2_2_asm_h
	.quad	l_set_loc3_2_asm_h
	.quad	l_get_arg0_2_asm_h
	.quad	l_get_arg1_2_asm_h
	.quad	l_get_arg2_2_asm_h
	.quad	l_get_arg3_2_asm_h
	.quad	l_put_arg0_2_asm_h
	.quad	l_put_arg1_2_asm_h
	.quad	l_put_arg2_2_asm_h
	.quad	l_put_arg3_2_asm_h
	.quad	l_set_arg0_2_asm_h
	.quad	l_set_arg1_2_asm_h
	.quad	l_set_arg2_2_asm_h
	.quad	l_set_arg3_2_asm_h
	.quad	l_get_var_ref0_2_asm_h
	.quad	l_get_var_ref1_2_asm_h
	.quad	l_get_var_ref2_2_asm_h
	.quad	l_get_var_ref3_2_asm_h
	.quad	l_put_var_ref0_2_asm_h
	.quad	l_put_var_ref1_2_asm_h
	.quad	l_put_var_ref2_2_asm_h
	.quad	l_put_var_ref3_2_asm_h
	.quad	l_set_var_ref0_2_asm_h
	.quad	l_set_var_ref1_2_asm_h
	.quad	l_set_var_ref2_2_asm_h
	.quad	l_set_var_ref3_2_asm_h
	.quad	l_get_length_2_asm_h
	.quad	l_if_false8_2_asm_h
	.quad	l_if_true8_2_asm_h
	.quad	l_goto8_2_asm_h
	.quad	l_goto16_2_asm_h
	.quad	l_call0_2_asm_h
	.quad	l_call1_2_asm_h
	.quad	l_call2_2_asm_h
	.quad	l_call3_2_asm_h
	.quad	l_is_undefined_2_asm_h
	.quad	l_is_null_2_asm_h
	.quad	l_is_function_2_asm_h
	.quad	l_inc_coverage_2_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger0_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger1_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h
	.quad	_common_call_debugger2_asm_h

.subsections_via_symbols
#endif
