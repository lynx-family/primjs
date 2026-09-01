#if defined(__aarch64__) && defined(ENABLE_PRIMJS_SNAPSHOT) && defined(ENABLE_QUICKJS_DEBUGGER)
	.section	__TEXT,__text,regular,pure_instructions
	.private_extern	_call_native_entry_asm_h ; -- Begin function call_native_entry_asm_h
	.globl	_call_native_entry_asm_h
	.p2align	2
_call_native_entry_asm_h:               ; @call_native_entry_asm_h
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
	b.ne	LBB0_26
; %bb.1:                                ; %B12
	ldrb	w9, [x22, #40]
	mov	w3, w0
	cmp	w3, w9
	b.lt	LBB0_31
; %bb.2:                                ; %B26
	ldp	x9, x10, [x24, #296]
	sub	x8, x10, #160
	cmp	x8, x9
	b.ls	LBB0_29
; %bb.3:                                ; %B15
	str	x8, [x24, #304]
	mov	x19, x10
	mov	x28, x20
	stp	x23, x22, [x8]
	mov	x27, xzr
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
	str	x19, [x24, #304]
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
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	b	_ThrowStackOverflow_Return_asm_h
LBB0_30:                                ; %B2
	cbz	x8, LBB0_32
LBB0_31:                                ; %B5
	mov	x3, x0
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	x4, x20
	mov	w5, w19
                                        ; kill: def $w3 killed $w3 killed $x3
	blr	x8
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
LBB0_32:                                ; %B3
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	b	_ThrowTypeErrorNotFunction_Return_asm_h
	.cfi_endproc
                                        ; -- End function
	.private_extern	_ThrowTypeErrorNotFunction_Return_asm_h ; -- Begin function ThrowTypeErrorNotFunction_Return_asm_h
	.globl	_ThrowTypeErrorNotFunction_Return_asm_h
	.p2align	2
_ThrowTypeErrorNotFunction_Return_asm_h: ; @ThrowTypeErrorNotFunction_Return_asm_h
; %bb.0:                                ; %B0
	mov	x0, x24
	mov	x22, x30
	bl	_JS_ThrowTypeErrorNotFunction
	mov	x30, x22
	ret
                                        ; -- End function
	.private_extern	_ThrowStackOverflow_Return_asm_h ; -- Begin function ThrowStackOverflow_Return_asm_h
	.globl	_ThrowStackOverflow_Return_asm_h
	.p2align	2
_ThrowStackOverflow_Return_asm_h:       ; @ThrowStackOverflow_Return_asm_h
; %bb.0:                                ; %B0
	mov	x0, x24
	mov	x22, x30
	bl	_JS_ThrowStackOverflow
	mov	x30, x22
	ret
                                        ; -- End function
	.private_extern	_call_native_asm_h      ; -- Begin function call_native_asm_h
	.globl	_call_native_asm_h
	.p2align	2
_call_native_asm_h:                     ; @call_native_asm_h
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
	ldp	x9, x10, [x24, #296]
	sub	x8, x10, #160
	cmp	x8, x9
	b.ls	LBB3_29
; %bb.3:                                ; %B15
	str	x8, [x24, #304]
	mov	x19, x10
	mov	x28, x20
	stp	x23, x22, [x8]
	mov	x27, xzr
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
	str	x19, [x24, #304]
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
	b	_ThrowStackOverflow_Return_asm_h
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
	b	_ThrowTypeErrorNotFunction_Return_asm_h
	.cfi_endproc
                                        ; -- End function
	.private_extern	_common_call_from_entry_asm_h ; -- Begin function common_call_from_entry_asm_h
	.globl	_common_call_from_entry_asm_h
	.p2align	2
_common_call_from_entry_asm_h:          ; @common_call_from_entry_asm_h
; %bb.0:                                ; %B48
	tbz	w19, #2, LBB4_3
; %bb.1:                                ; %B39
	ldr	x10, [x24, #304]
	mov	x8, x30
	and	x9, x22, #0xfffffffffffc
	add	x11, x9, #16
	stp	x10, x8, [x9, #152]
	mov	x23, x11
	ldr	x8, [x24, #8]
	ldr	x10, [x8, #256]
	str	x10, [x9, #16]
	str	x11, [x8, #256]
	ldp	x27, x19, [x9, #40]
	ldr	w8, [x9, #12]
	ldr	x20, [x9, #64]
	ldr	x28, [x9, #32]
	ldr	x26, [x9, #120]
	cbnz	w8, LBB4_13
LBB4_2:                                 ; %B28
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB4_3:                                 ; %B42
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB4_14
; %bb.4:                                ; %B44
	ldrh	w8, [x22, #6]
	cmp	w8, #13
	b.ne	LBB4_15
; %bb.5:                                ; %B1
	ldr	x11, [x22, #32]
	ldp	x14, x13, [x24, #296]
	mov	x12, x23
	ldrh	w10, [x11, #40]
	ldrh	w8, [x11, #42]
	ldrh	w9, [x11, #46]
	cmp	w0, w10
	add	w9, w8, w9
	b.lt	LBB4_16
; %bb.6:                                ; %B36
	add	w9, w9, w0
	lsl	w9, w9, #3
	add	w9, w9, #160
	sub	x9, x13, x9
	cmp	x9, x14
	b.ls	LBB4_23
; %bb.7:                                ; %B38
	mov	x10, x30
	str	x9, [x24, #304]
	mov	x23, x9
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
LBB4_8:                                 ; %B33
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x13, [x20], #8
	str	x13, [x12], #8
	cmp	x12, x10
	b.lt	LBB4_8
LBB4_9:                                 ; %B35
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
LBB4_10:                                ; %B25
                                        ; =>This Inner Loop Header: Depth=1
	str	x8, [x10], #8
	cmp	x10, x20
	b.lt	LBB4_10
LBB4_11:                                ; %B26
	ldr	w8, [x24, #336]
	cbz	w8, LBB4_2
; %bb.12:                               ; %B27
	add	x1, x19, #1
	mov	x0, x24
	str	x20, [x9, #48]
	bl	_DebuggerCallEachFunc
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB4_13:                                ; %B40
	b	_exception_asm_h
LBB4_14:                                ; %B47
	b	_ThrowTypeErrorNotFunction_Return_asm_h
LBB4_15:                                ; %B45
	b	_call_native_entry_asm_h
LBB4_16:                                ; %B20
	add	w9, w9, w10
	lsl	w9, w9, #3
	add	w9, w9, #160
	sub	x9, x13, x9
	cmp	x9, x14
	b.ls	LBB4_23
; %bb.17:                               ; %B22
	mov	x14, x30
	str	x9, [x24, #304]
	mov	x23, x9
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
	b.ge	LBB4_19
LBB4_18:                                ; %B6
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x13, [x20], #8
	str	x13, [x12], #8
	cmp	w0, w10
	csel	w13, w0, w10, lt
	add	x13, x11, w13, uxtw #3
	cmp	x12, x13
	b.lt	LBB4_18
LBB4_19:                                ; %B10.preheader
	add	x12, x11, x10, lsl #3
	mov	w14, #18                        ; =0x12
	cmp	x13, x12
	b.ge	LBB4_21
LBB4_20:                                ; %B11
                                        ; =>This Inner Loop Header: Depth=1
	str	x14, [x13], #8
	cmp	x13, x12
	b.lt	LBB4_20
LBB4_21:                                ; %B12
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
	b.ge	LBB4_11
LBB4_22:                                ; %B18
                                        ; =>This Inner Loop Header: Depth=1
	str	x8, [x12], #8
	cmp	x12, x20
	b.lt	LBB4_22
	b	LBB4_11
LBB4_23:                                ; %B21
	b	_ThrowStackOverflow_Return_asm_h
                                        ; -- End function
	.private_extern	_exception_asm_h        ; -- Begin function exception_asm_h
	.globl	_exception_asm_h
	.p2align	2
_exception_asm_h:                       ; @exception_asm_h
; %bb.0:                                ; %B17
	sub	sp, sp, #32
	ldr	x9, [x24, #8]
	ldr	w8, [x9, #248]
	stp	x9, x20, [sp, #8]               ; 16-byte Folded Spill
	ldr	x20, [x9, #240]
	cbz	w8, LBB5_2
; %bb.1:                                ; %B18
	mov	x0, x24
	mov	x1, x20
	mov	x2, xzr
	mov	x3, xzr
	mov	x4, x19
	mov	w5, wzr
	mov	w6, wzr
	bl	_build_backtrace
LBB5_2:                                 ; %B2
	mov	x0, x24
	mov	x1, x20
	bl	_JS_IsUncatchableError_GC
	cbz	w0, LBB5_4
LBB5_3:                                 ; %B4
	ldr	x20, [sp, #16]                  ; 8-byte Folded Reload
	mov	w0, #130                        ; =0x82
	add	sp, sp, #32
	b	_common_return_asm_h
LBB5_4:                                 ; %B6
	ldr	x8, [x23, #8]
	str	x19, [sp, #24]                  ; 8-byte Folded Spill
	ldr	x8, [x8, #32]
	str	x8, [sp]                        ; 8-byte Folded Spill
	ldrh	w8, [x8, #42]
	add	x20, x27, x8, lsl #3
	ldr	x8, [sp, #16]                   ; 8-byte Folded Reload
LBB5_5:                                 ; %B7
                                        ; =>This Inner Loop Header: Depth=1
	cmp	x8, x20
	b.le	LBB5_3
; %bb.6:                                ; %B12
                                        ;   in Loop: Header=BB5_5 Depth=1
	ldr	x9, [x8, #-8]!
	tst	x9, #0xffff000000000000
	b.ne	LBB5_5
; %bb.7:                                ; %B12
                                        ;   in Loop: Header=BB5_5 Depth=1
	mov	w10, #247                       ; =0xf7
	and	x10, x9, x10
	cmp	x10, #66
	b.ne	LBB5_5
; %bb.8:                                ; %B9
                                        ;   in Loop: Header=BB5_5 Depth=1
	lsr	x9, x9, #16
	cbnz	w9, LBB5_10
; %bb.9:                                ; %B10
                                        ;   in Loop: Header=BB5_5 Depth=1
	ldur	x1, [x8, #-16]
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	sub	x19, x8, #8
	bl	_JS_IteratorClose
	mov	x8, x19
	ldr	x19, [sp, #24]                  ; 8-byte Folded Reload
	b	LBB5_5
LBB5_10:                                ; %B11
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
	.private_extern	_common_call_asm_h      ; -- Begin function common_call_asm_h
	.globl	_common_call_asm_h
	.p2align	2
_common_call_asm_h:                     ; @common_call_asm_h
; %bb.0:                                ; %B38
	mov	x9, #2                          ; =0x2
	mov	x8, x20
	movk	x9, #65535, lsl #48
	tst	x22, x9
	b.ne	LBB6_9
; %bb.1:                                ; %B35
	ldrh	w9, [x22, #6]
	cmp	w9, #13
	b.ne	LBB6_10
; %bb.2:                                ; %B1
	ldr	x12, [x22, #32]
	ldp	x15, x14, [x24, #296]
	mov	x13, x23
	ldrh	w11, [x12, #40]
	ldrh	w9, [x12, #42]
	ldrh	w10, [x12, #46]
	cmp	w0, w11
	add	w10, w9, w10
	b.lt	LBB6_11
; %bb.3:                                ; %B32
	lsl	w10, w10, #3
	add	w10, w10, #160
	sub	x10, x14, x10
	cmp	x10, x15
	b.ls	LBB6_18
; %bb.4:                                ; %B34
	mov	x11, x30
	str	x10, [x24, #304]
	mov	x23, x10
	stp	x14, x11, [x10, #136]
	mov	x28, x8
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
	b.ge	LBB6_6
LBB6_5:                                 ; %B26
                                        ; =>This Inner Loop Header: Depth=1
	str	x9, [x11], #8
	cmp	x11, x20
	b.lt	LBB6_5
LBB6_6:                                 ; %B27
	ldr	w8, [x24, #336]
	cbz	w8, LBB6_8
; %bb.7:                                ; %B28
	add	x1, x19, #1
	mov	x0, x24
	str	x20, [x10, #48]
	bl	_DebuggerCallEachFunc
LBB6_8:                                 ; %B24
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB6_9:                                 ; %B40
	mov	x20, x8
	b	_ThrowTypeErrorNotFunction_Return_asm_h
LBB6_10:                                ; %B36
	mov	x20, x8
	b	_call_native_asm_h
LBB6_11:                                ; %B20
	add	w10, w10, w11
	lsl	w10, w10, #3
	add	w10, w10, #160
	sub	x10, x14, x10
	cmp	x10, x15
	b.ls	LBB6_18
; %bb.12:                               ; %B22
	mov	x15, x30
	str	x10, [x24, #304]
	mov	x23, x10
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
	b.ge	LBB6_14
LBB6_13:                                ; %B6
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x14, [x8], #8
	str	x14, [x13], #8
	cmp	w0, w11
	csel	w14, w0, w11, lt
	add	x14, x12, w14, uxtw #3
	cmp	x13, x14
	b.lt	LBB6_13
LBB6_14:                                ; %B10.preheader
	add	x8, x12, x11, lsl #3
	mov	w13, #18                        ; =0x12
	cmp	x14, x8
	b.ge	LBB6_16
LBB6_15:                                ; %B11
                                        ; =>This Inner Loop Header: Depth=1
	str	x13, [x14], #8
	cmp	x14, x8
	b.lt	LBB6_15
LBB6_16:                                ; %B12
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
	b.ge	LBB6_6
LBB6_17:                                ; %B18
                                        ; =>This Inner Loop Header: Depth=1
	str	x9, [x8], #8
	cmp	x8, x20
	b.lt	LBB6_17
	b	LBB6_6
LBB6_18:                                ; %B21
	mov	x20, x8
	b	_ThrowStackOverflow_Return_asm_h
                                        ; -- End function
	.private_extern	_common_return_direct_asm_h ; -- Begin function common_return_direct_asm_h
	.globl	_common_return_direct_asm_h
	.p2align	2
_common_return_direct_asm_h:            ; @common_return_direct_asm_h
; %bb.0:                                ; %B0
	ldp	x8, x9, [x23, #136]
	ldr	x10, [x23]
	ldr	x11, [x24, #8]
	mov	x23, x10
	mov	x30, x9
	str	x8, [x24, #304]
	str	x10, [x11, #256]
	ret
                                        ; -- End function
	.private_extern	_common_call_debugger0_asm_h ; -- Begin function common_call_debugger0_asm_h
	.globl	_common_call_debugger0_asm_h
	.p2align	2
_common_call_debugger0_asm_h:           ; @common_call_debugger0_asm_h
; %bb.0:                                ; %B3
	ldr	w8, [x24, #336]
	cbz	w8, LBB8_2
; %bb.1:                                ; %B4
	ldr	x8, [x23, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #32]
	str	x20, [x23, #48]
	bl	_DebuggerCallEachOp
LBB8_2:                                 ; %B1
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
	ldr	w8, [x24, #336]
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
	sub	w8, w8, #486
	ldr	x1, [x25, w8, sxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_common_call_debugger2_asm_h ; -- Begin function common_call_debugger2_asm_h
	.globl	_common_call_debugger2_asm_h
	.p2align	2
_common_call_debugger2_asm_h:           ; @common_call_debugger2_asm_h
; %bb.0:                                ; %B3
	ldr	w8, [x24, #336]
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
	sub	w8, w8, #243
	ldr	x1, [x25, w8, sxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_SlowCloseVarRefs_asm_h ; -- Begin function SlowCloseVarRefs_asm_h
	.globl	_SlowCloseVarRefs_asm_h
	.p2align	2
_SlowCloseVarRefs_asm_h:                ; @SlowCloseVarRefs_asm_h
; %bb.0:                                ; %B0
	mov	x22, x0
	mov	x0, x24
	mov	x1, x23
	bl	_prim_close_var_refs_gc
	mov	x0, x22
	b	_common_return_direct_asm_h
                                        ; -- End function
	.private_extern	_common_return_asm_h    ; -- Begin function common_return_asm_h
	.globl	_common_return_asm_h
	.p2align	2
_common_return_asm_h:                   ; @common_return_asm_h
; %bb.0:                                ; %B6
	ldr	x8, [x23, #72]
	cbnz	x8, LBB12_3
; %bb.1:                                ; %B1
	ldrb	w8, [x24, #392]
	cbz	w8, LBB12_4
; %bb.2:                                ; %B1
	cbz	x26, LBB12_4
LBB12_3:                                ; %B3
	b	_SlowCloseVarRefs_asm_h
LBB12_4:                                ; %B5
	b	_common_return_direct_asm_h
                                        ; -- End function
	.private_extern	_exception_spill_top0_asm_h ; -- Begin function exception_spill_top0_asm_h
	.globl	_exception_spill_top0_asm_h
	.p2align	2
_exception_spill_top0_asm_h:            ; @exception_spill_top0_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_exception_spill_top1_asm_h ; -- Begin function exception_spill_top1_asm_h
	.globl	_exception_spill_top1_asm_h
	.p2align	2
_exception_spill_top1_asm_h:            ; @exception_spill_top1_asm_h
; %bb.0:                                ; %B0
	str	x21, [x20], #8
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_exception_spill_top0_top1_asm_h ; -- Begin function exception_spill_top0_top1_asm_h
	.globl	_exception_spill_top0_top1_asm_h
	.p2align	2
_exception_spill_top0_top1_asm_h:       ; @exception_spill_top0_top1_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_SlowToBoolean_asm_h    ; -- Begin function SlowToBoolean_asm_h
	.globl	_SlowToBoolean_asm_h
	.p2align	2
_SlowToBoolean_asm_h:                   ; @SlowToBoolean_asm_h
; %bb.0:                                ; %B1
	mov	x1, x0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ToBoolFree_GC
	tbnz	w0, #31, LBB16_2
; %bb.1:                                ; %B3
	cmp	w0, #0
	mov	w8, #6                          ; =0x6
	cinc	x8, x8, ne
	stur	x8, [x20, #-8]
	ldurb	w8, [x19, #-1]
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB16_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_SlowJSPostInc_asm_h    ; -- Begin function SlowJSPostInc_asm_h
	.globl	_SlowJSPostInc_asm_h
	.p2align	2
_SlowJSPostInc_asm_h:                   ; @SlowJSPostInc_asm_h
; %bb.0:                                ; %B1
	mov	w2, w0
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_js_post_inc_slow_gc
	tbnz	w0, #31, LBB17_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB17_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_SlowJSNot_asm_h        ; -- Begin function SlowJSNot_asm_h
	.globl	_SlowJSNot_asm_h
	.p2align	2
_SlowJSNot_asm_h:                       ; @SlowJSNot_asm_h
; %bb.0:                                ; %B1
	mov	x1, x0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_prim_js_not_slow_gc
	cmp	x0, #130
	b.eq	LBB18_2
; %bb.1:                                ; %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB18_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_FastJSConcatString_asm_h ; -- Begin function FastJSConcatString_asm_h
	.globl	_FastJSConcatString_asm_h
	.p2align	2
_FastJSConcatString_asm_h:              ; @FastJSConcatString_asm_h
; %bb.0:                                ; %B33
	sub	sp, sp, #48
	mov	x22, x0
	cbnz	x22, LBB19_8
; %bb.1:                                ; %B36
	ldp	x12, x11, [x20, #-16]
	mov	x9, #-281474976710653           ; =0xffff000000000003
	and	x8, x12, #0xfffffffffffc
	bics	xzr, x9, x12
	b.eq	LBB19_9
LBB19_2:
	mov	w13, #1                         ; =0x1
	bics	xzr, x9, x11
	and	x9, x11, #0xfffffffffffc
	str	x19, [sp, #40]                  ; 8-byte Folded Spill
	stp	x12, x11, [sp, #16]             ; 16-byte Folded Spill
	b.eq	LBB19_10
LBB19_3:                                ; %B22
	ldr	w19, [x8, #4]
	ldr	w8, [x9, #4]
	mov	x0, x24
	mov	w1, #32                         ; =0x20
	mov	w2, #20                         ; =0x14
	str	x20, [sp, #32]                  ; 8-byte Folded Spill
	stp	w8, w13, [sp, #8]               ; 8-byte Folded Spill
	str	x20, [x23, #48]
	bl	_prim_try_malloc_gc
	mov	x20, x0
	cbz	x20, LBB19_11
; %bb.4:                                ; %B14
	ldr	w11, [sp, #8]                   ; 4-byte Folded Reload
	and	w9, w19, #0x3fffffff
	mov	w8, #1                          ; =0x1
	str	w8, [x20]
	orr	w10, w19, w11
	and	w11, w11, #0x3fffffff
	add	w9, w9, w11
	and	w10, w10, #0x80000000
	ldr	w11, [sp, #12]                  ; 4-byte Folded Reload
	orr	w9, w9, w10
	stp	w9, w11, [x20, #4]
	ldr	x9, [sp, #16]                   ; 8-byte Folded Reload
	str	x9, [x20, #16]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB19_14
; %bb.5:                                ; %B18
	ldr	x9, [sp, #24]                   ; 8-byte Folded Reload
	ldr	x19, [sp, #40]                  ; 8-byte Folded Reload
	str	x9, [x20, #24]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB19_15
LBB19_6:                                ; %B1
	orr	x8, x20, #0xffff000000000003
	cbz	x22, LBB19_16
LBB19_7:                                ; %B2
	ldrb	w9, [x19]
	str	x8, [x27, x9, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #32]                   ; 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #48
	br	x1
LBB19_8:                                ; %B34
	ldrb	w8, [x19]
	ldr	x12, [x27, x8, lsl #3]
	ldur	x11, [x20, #-8]
	mov	x9, #-281474976710653           ; =0xffff000000000003
	and	x8, x12, #0xfffffffffffc
	bics	xzr, x9, x12
	b.ne	LBB19_2
LBB19_9:                                ; %B30
	ldr	w10, [x8, #8]
	add	w13, w10, #1
	bics	xzr, x9, x11
	and	x9, x11, #0xfffffffffffc
	str	x19, [sp, #40]                  ; 8-byte Folded Spill
	stp	x12, x11, [sp, #16]             ; 16-byte Folded Spill
	b.ne	LBB19_3
LBB19_10:                               ; %B26
	ldr	w10, [x9, #8]
	add	w11, w10, #1
	cmp	w13, w11
	csinc	w13, w13, w10, gt
	b	LBB19_3
LBB19_11:                               ; %B5
	ldp	x2, x8, [sp, #24]               ; 16-byte Folded Reload
	mov	x0, x24
	ldr	x1, [sp, #16]                   ; 8-byte Folded Reload
	str	x8, [x23, #48]
	bl	_JS_ConcatString_GC
	cmp	x0, #130
	cbnz	x22, LBB19_17
; %bb.12:                               ; %B11
	b.eq	LBB19_19
; %bb.13:                               ; %B13
	ldp	x9, x19, [sp, #32]              ; 16-byte Folded Reload
	stur	x0, [x9, #-16]
	ldrb	w8, [x19], #1
	sub	x20, x9, #8
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
LBB19_14:                               ; %B21
	mov	x0, x9
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldr	x9, [sp, #24]                   ; 8-byte Folded Reload
	ldr	x19, [sp, #40]                  ; 8-byte Folded Reload
	str	x9, [x20, #24]
	ldrb	w8, [x24, #392]
	cbz	w8, LBB19_6
LBB19_15:                               ; %B20
	mov	x0, x9
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	orr	x8, x20, #0xffff000000000003
	cbnz	x22, LBB19_7
LBB19_16:                               ; %B4
	ldr	x9, [sp, #32]                   ; 8-byte Folded Reload
	stur	x8, [x9, #-16]
	ldrb	w8, [x19], #1
	sub	x20, x9, #8
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
LBB19_17:                               ; %B7
	b.eq	LBB19_19
; %bb.18:                               ; %B9
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
LBB19_19:                               ; %B12
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_FastStringEqual_asm_h  ; -- Begin function FastStringEqual_asm_h
	.globl	_FastStringEqual_asm_h
	.p2align	2
_FastStringEqual_asm_h:                 ; @FastStringEqual_asm_h
; %bb.0:                                ; %B74
	ldp	x1, x2, [x20, #-16]
	and	x8, x1, #0xfffffffffffc
	and	x9, x2, #0xfffffffffffc
	ldr	w8, [x8, #4]
	ldr	w9, [x9, #4]
	and	w8, w8, #0x3fffffff
	and	w9, w9, #0x3fffffff
	cmp	w8, w9
	b.eq	LBB20_3
LBB20_1:                                ; %B15
	mov	w8, #6                          ; =0x6
	bfxil	x8, x0, #0, #1
LBB20_2:                                ; %B16
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB20_3:                                ; %B1
	mov	x8, #-281474976710653           ; =0xffff000000000003
	bics	xzr, x8, x1
	b.eq	LBB20_15
; %bb.4:                                ; %B69
	bics	xzr, x8, x2
	b.eq	LBB20_17
LBB20_5:                                ; %B54
	and	x8, x1, #0xfffffffffffc
	and	x9, x2, #0xfffffffffffc
	cmp	x8, x9
	b.eq	LBB20_19
LBB20_6:                                ; %B57
	ldrb	w10, [x8, #7]
	tbnz	w10, #6, LBB20_20
; %bb.7:                                ; %B60
	ldr	w10, [x8, #8]
	ldrb	w11, [x9, #7]
	tbnz	w11, #6, LBB20_21
LBB20_8:                                ; %B53
	ldr	w11, [x9, #8]
	asr	w10, w10, #30
	cmp	w10, #1
	b.ne	LBB20_10
LBB20_9:                                ; %B49
	asr	w10, w11, #30
	cmp	w10, #1
	b.eq	LBB20_1
LBB20_10:                               ; %B8
	ldr	w10, [x8, #4]
	ldr	w11, [x9, #4]
	add	x8, x8, #16
	add	x9, x9, #16
	tst	w10, #0xbfffffff
	and	w10, w10, #0x3fffffff
	and	w11, w11, #0xbfffffff
	b.lt	LBB20_22
; %bb.11:                               ; %B32
	tbnz	w11, #31, LBB20_26
; %bb.12:                               ; %B46.preheader
	mov	w11, wzr
	cmp	w10, wzr
	b.eq	LBB20_19
LBB20_13:                               ; %B43
                                        ; =>This Inner Loop Header: Depth=1
	ldrb	w12, [x8, w11, sxtw]
	ldrb	w13, [x9, w11, sxtw]
	cmp	w12, w13
	b.ne	LBB20_1
; %bb.14:                               ; %B45
                                        ;   in Loop: Header=BB20_13 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	LBB20_13
	b	LBB20_19
LBB20_15:                               ; %B66
	and	x9, x1, #0xfffffffffffc
	ldr	x10, [x9, #24]
	cmp	x10, #2
	b.ne	LBB20_29
; %bb.16:                               ; %B67
	ldr	x1, [x9, #16]
	bics	xzr, x8, x2
	b.ne	LBB20_5
LBB20_17:                               ; %B3
	and	x8, x2, #0xfffffffffffc
	ldr	x9, [x8, #24]
	cmp	x9, #2
	b.ne	LBB20_29
; %bb.18:                               ; %B4
	ldr	x2, [x8, #16]
	and	x8, x1, #0xfffffffffffc
	and	x9, x2, #0xfffffffffffc
	cmp	x8, x9
	b.ne	LBB20_6
LBB20_19:                               ; %B21
	mvn	w9, w0
	mov	w8, #6                          ; =0x6
	bfxil	x8, x9, #0, #1
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB20_20:                               ; %B58
	ldr	x10, [x8, #8]
	ldr	w10, [x10]
	ldrb	w11, [x9, #7]
	tbz	w11, #6, LBB20_8
LBB20_21:                               ; %B7
	ldr	x11, [x9, #8]
	ldr	w11, [x11]
	asr	w10, w10, #30
	cmp	w10, #1
	b.eq	LBB20_9
	b	LBB20_10
LBB20_22:                               ; %B10
	tbnz	w11, #31, LBB20_31
; %bb.23:                               ; %B28.preheader
	mov	w11, wzr
	cmp	w10, wzr
	b.eq	LBB20_19
LBB20_24:                               ; %B25
                                        ; =>This Inner Loop Header: Depth=1
	ldrh	w12, [x8, w11, sxtw #1]
	ldrb	w13, [x9, w11, sxtw]
	cmp	w12, w13
	b.ne	LBB20_1
; %bb.25:                               ; %B27
                                        ;   in Loop: Header=BB20_24 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	LBB20_24
	b	LBB20_19
LBB20_26:                               ; %B38.preheader
	mov	w11, wzr
	cmp	w10, wzr
	b.eq	LBB20_19
LBB20_27:                               ; %B35
                                        ; =>This Inner Loop Header: Depth=1
	ldrb	w12, [x8, w11, sxtw]
	ldrh	w13, [x9, w11, sxtw #1]
	cmp	w12, w13
	b.ne	LBB20_1
; %bb.28:                               ; %B37
                                        ;   in Loop: Header=BB20_27 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	LBB20_27
	b	LBB20_19
LBB20_29:                               ; %B63
	mov	w3, w0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	mov	x8, x0
	b.ne	LBB20_2
; %bb.30:                               ; %B64
	b	_exception_asm_h
LBB20_31:                               ; %B19.preheader
	mov	w11, wzr
	cmp	w10, wzr
	b.eq	LBB20_19
LBB20_32:                               ; %B13
                                        ; =>This Inner Loop Header: Depth=1
	ldrh	w12, [x8, w11, sxtw #1]
	ldrh	w13, [x9, w11, sxtw #1]
	cmp	w12, w13
	b.ne	LBB20_1
; %bb.33:                               ; %B18
                                        ;   in Loop: Header=BB20_32 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	LBB20_32
	b	LBB20_19
                                        ; -- End function
	.private_extern	_ThrowReferenceErrorUninitialized_asm_h ; -- Begin function ThrowReferenceErrorUninitialized_asm_h
	.globl	_ThrowReferenceErrorUninitialized_asm_h
	.p2align	2
_ThrowReferenceErrorUninitialized_asm_h: ; @ThrowReferenceErrorUninitialized_asm_h
; %bb.0:                                ; %B0
	mov	x0, x24
	mov	w1, wzr
	str	x20, [x23, #48]
	bl	_JS_ThrowReferenceErrorUninitialized_GC
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_ThrowThisReferenceError_asm_h ; -- Begin function ThrowThisReferenceError_asm_h
	.globl	_ThrowThisReferenceError_asm_h
	.p2align	2
_ThrowThisReferenceError_asm_h:         ; @ThrowThisReferenceError_asm_h
; %bb.0:                                ; %B0
Lloh0:
	adrp	x1, l___unnamed_1@PAGE
Lloh1:
	add	x1, x1, l___unnamed_1@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_ThrowReferenceError
	b	_exception_asm_h
	.loh AdrpAdd	Lloh0, Lloh1
                                        ; -- End function
	.private_extern	_FastBuildArguments_asm_h ; -- Begin function FastBuildArguments_asm_h
	.globl	_FastBuildArguments_asm_h
	.p2align	2
_FastBuildArguments_asm_h:              ; @FastBuildArguments_asm_h
; %bb.0:                                ; %B51
	sub	sp, sp, #48
	str	x20, [sp, #40]                  ; 8-byte Folded Spill
	ldrb	w8, [x24, #371]
	ldr	w20, [x23, #120]
	str	x19, [sp, #24]                  ; 8-byte Folded Spill
	cbnz	w8, LBB23_19
; %bb.1:                                ; %B48
	ldr	x8, [x24, #424]
	cbz	x8, LBB23_19
; %bb.2:                                ; %B45
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	str	x20, [sp, #32]                  ; 8-byte Folded Spill
	cbz	w20, LBB23_8
; %bb.3:                                ; %B6
	lsl	x1, x20, #3
	ldr	x8, [sp, #40]                   ; 8-byte Folded Reload
	mov	x0, x24
	mov	w2, #42                         ; =0x2a
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	cbz	x0, LBB23_19
; %bb.4:                                ; %B9.preheader
	mov	x8, x0
	add	x10, x0, x20, lsl #3
	mov	x19, x28
	mov	x20, x8
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	cmp	x8, x10
	b.ge	LBB23_9
LBB23_5:                                ; %B12
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x19]
	str	x8, [x20]
	ldrb	w9, [x24, #392]
	cbnz	w9, LBB23_7
LBB23_6:                                ; %B11
                                        ;   in Loop: Header=BB23_5 Depth=1
	add	x20, x20, #8
	add	x19, x19, #8
	cmp	x20, x10
	b.lt	LBB23_5
	b	LBB23_9
LBB23_7:                                ; %B14
                                        ;   in Loop: Header=BB23_5 Depth=1
	mov	x0, x8
	mov	x1, x24
	str	x10, [sp]                       ; 8-byte Folded Spill
	bl	_prim_WriteBarrierNoStore
	ldr	x10, [sp]                       ; 8-byte Folded Reload
	b	LBB23_6
LBB23_8:
	str	xzr, [sp, #8]                   ; 8-byte Folded Spill
LBB23_9:                                ; %B17
	ldr	x8, [sp, #40]                   ; 8-byte Folded Reload
	mov	x0, x24
	mov	w1, #16                         ; =0x10
	mov	w2, #42                         ; =0x2a
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x20, [sp, #32]                  ; 8-byte Folded Reload
	mov	x9, x0
	cbz	x9, LBB23_19
; %bb.10:                               ; %B40
	ldr	x20, [x24, #192]
	str	x20, [x9]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB23_17
; %bb.11:                               ; %B37
	str	x20, [x9, #8]
	ldrb	w8, [x24, #392]
	str	x9, [sp]                        ; 8-byte Folded Spill
	cbnz	w8, LBB23_18
LBB23_12:                               ; %B21
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
	cbz	x19, LBB23_19
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
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB23_21
LBB23_14:                               ; %B29
	orr	x8, x20, #0xfffe000000000000
	mov	x9, x19
	str	x8, [x9, #56]!
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	stur	x9, [x9, #-40]
	stur	x8, [x9, #-16]
	stur	w20, [x9, #-8]
	ldr	x8, [x24, #184]
	str	x8, [x9, #8]
	ldrb	w9, [x24, #392]
	cbnz	w9, LBB23_22
; %bb.15:                               ; %B26
	str	x10, [x19, #72]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB23_23
LBB23_16:                               ; %B4
	ldr	x20, [sp, #40]                  ; 8-byte Folded Reload
	ldr	x9, [sp, #24]                   ; 8-byte Folded Reload
	str	x19, [x20], #8
	add	x19, x9, #2
	ldrb	w8, [x9, #1]
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
LBB23_17:                               ; %B42
	mov	x0, x20
	mov	x1, x24
	mov	x19, x9
	bl	_prim_WriteBarrierNoStore
	str	x20, [x19, #8]
	ldrb	w8, [x24, #392]
	str	x19, [sp]                       ; 8-byte Folded Spill
	cbz	w8, LBB23_12
LBB23_18:                               ; %B39
	mov	x0, x20
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB23_12
LBB23_19:                               ; %B1
	ldr	x8, [sp, #40]                   ; 8-byte Folded Reload
	mov	x0, x24
	mov	w1, w20
	mov	x2, x28
	str	x8, [x23, #48]
	bl	_js_build_arguments_gc
	cmp	x0, #130
	mov	x19, x0
	b.ne	LBB23_16
; %bb.20:                               ; %B2
	ldr	x19, [sp, #24]                  ; 8-byte Folded Reload
	ldr	x20, [sp, #40]                  ; 8-byte Folded Reload
	add	sp, sp, #48
	b	_exception_asm_h
LBB23_21:                               ; %B34
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	_prim_WriteBarrierNoStore
	ldr	x10, [sp]                       ; 8-byte Folded Reload
	b	LBB23_14
LBB23_22:                               ; %B31
	mov	x0, x8
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldr	x10, [sp]                       ; 8-byte Folded Reload
	str	x10, [x19, #72]
	ldrb	w8, [x24, #392]
	cbz	w8, LBB23_16
LBB23_23:                               ; %B28
	mov	x0, x10
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB23_16
                                        ; -- End function
	.private_extern	_FastCallConstructor_asm_h ; -- Begin function FastCallConstructor_asm_h
	.globl	_FastCallConstructor_asm_h
	.p2align	2
_FastCallConstructor_asm_h:             ; @FastCallConstructor_asm_h
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
	b.eq	LBB24_5
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
	bl	_common_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #104]
	b.eq	LBB24_6
; %bb.2:                                ; %B1
	mov	x9, #2                          ; =0x2
	ldurh	w8, [x19, #-2]
	movk	x9, #65535, lsl #48
	tst	x0, x9
	b.eq	LBB24_7
; %bb.3:                                ; %B5
	sub	x9, x20, x8, lsl #3
	ldur	x9, [x9, #-8]
LBB24_4:                                ; %B3
	sub	x8, x20, x8, lsl #3
	stur	x9, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19], #1
	ldr	x1, [x25, x9, lsl #3]
	add	sp, sp, #16
	br	x1
LBB24_5:                                ; %B10
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
LBB24_6:                                ; %B7
	add	sp, sp, #16
	b	_exception_asm_h
LBB24_7:
	mov	x9, x0
	b	LBB24_4
                                        ; -- End function
	.private_extern	_FastCallDerivedConstructor_asm_h ; -- Begin function FastCallDerivedConstructor_asm_h
	.globl	_FastCallDerivedConstructor_asm_h
	.p2align	2
_FastCallDerivedConstructor_asm_h:      ; @FastCallDerivedConstructor_asm_h
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
	bl	_common_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #104]
	b.eq	LBB25_2
; %bb.1:                                ; %B4
	ldurh	w8, [x19, #-2]
	sub	x8, x20, x8, lsl #3
	stur	x0, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19], #1
	ldr	x1, [x25, x9, lsl #3]
	br	x1
LBB25_2:                                ; %B3
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_invalid_0_asm_h        ; -- Begin function invalid_0_asm_h
	.globl	_invalid_0_asm_h
	.p2align	2
_invalid_0_asm_h:                       ; @invalid_0_asm_h
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
	b	_exception_asm_h
	.loh AdrpAdd	Lloh2, Lloh3
                                        ; -- End function
	.private_extern	_push_i32_0_asm_h       ; -- Begin function push_i32_0_asm_h
	.globl	_push_i32_0_asm_h
	.p2align	2
_push_i32_0_asm_h:                      ; @push_i32_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19, #4]
	ldr	w9, [x19], #5
	add	w8, w8, #243
	orr	x22, x9, #0xfffe000000000000
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_const_0_asm_h     ; -- Begin function push_const_0_asm_h
	.globl	_push_const_0_asm_h
	.p2align	2
_push_const_0_asm_h:                    ; @push_const_0_asm_h
; %bb.0:                                ; %B3
	sub	sp, sp, #16
	ldr	x8, [x23, #112]
	ldrsw	x9, [x19]
	ldr	w10, [x24, #336]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, LBB28_2
; %bb.1:                                ; %B4
	mov	x0, x24
	mov	x2, x19
	str	x20, [x23, #48]
	str	x1, [sp, #8]                    ; 8-byte Folded Spill
	bl	_DebuggerPause
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
LBB28_2:                                ; %B1
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x1
	add	w8, w8, #243
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
                                        ; -- End function
	.private_extern	_fclosure_0_asm_h       ; -- Begin function fclosure_0_asm_h
	.globl	_fclosure_0_asm_h
	.p2align	2
_fclosure_0_asm_h:                      ; @fclosure_0_asm_h
; %bb.0:                                ; %B124
	sub	sp, sp, #96
	ldr	x8, [x23, #112]
	ldrsw	x9, [x19]
	mov	x2, x20
	str	x19, [sp, #64]                  ; 8-byte Folded Spill
	ldr	x8, [x8, x9, lsl #3]
	and	x8, x8, #0xfffffffffffc
	stp	x20, x8, [sp, #80]              ; 16-byte Folded Spill
	ldrb	w8, [x8, #6]
	tst	w8, #0x30
	str	w8, [sp, #76]                   ; 4-byte Folded Spill
	b.ne	LBB29_40
; %bb.1:                                ; %B111
	ldrb	w8, [x24, #371]
	cbnz	w8, LBB29_40
; %bb.2:                                ; %B114
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB29_40
; %bb.3:                                ; %B117
	ldr	w8, [sp, #76]                   ; 4-byte Folded Reload
	tst	w8, #0x1
	mov	w8, #6                          ; =0x6
	cinc	w8, w8, eq
	ldr	x8, [x24, w8, uxtw #3]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	cbz	x8, LBB29_40
; %bb.4:                                ; %B1
	ldr	x8, [sp, #88]                   ; 8-byte Folded Reload
	mov	w9, #47                         ; =0x2f
	ldr	w8, [x8, #20]
	cmp	w8, #0
	csel	w8, w9, w8, eq
	tbnz	w8, #31, LBB29_40
; %bb.5:                                ; %B103
	ldr	x9, [x24, #8]
	ldr	x9, [x9, #64]
	ldr	x9, [x9, w8, sxtw #3]
	ldrb	w8, [x9, #7]
	str	x9, [sp, #16]                   ; 8-byte Folded Spill
	tbnz	w8, #6, LBB29_34
; %bb.6:                                ; %B106
	ldr	w8, [x9, #8]
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	LBB29_40
LBB29_7:                                ; %B100
	ldr	x8, [sp, #88]                   ; 8-byte Folded Reload
	ldr	w15, [x23, #40]
	ldr	x16, [x23, #72]
	ldr	w13, [x8, #60]
	ldr	x14, [x8, #32]
	str	w15, [sp, #44]                  ; 4-byte Folded Spill
	stp	x14, x13, [sp, #48]             ; 16-byte Folded Spill
	cbz	w13, LBB29_35
; %bb.8:                                ; %B15.preheader
	mov	w17, wzr
	mov	w19, wzr
LBB29_9:                                ; %B15
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB29_16 Depth 2
	lsl	w8, w19, #3
	add	x9, x14, x8
	ldrb	w8, [x9]
	tbz	w8, #0, LBB29_13
; %bb.10:                               ; %B17
                                        ;   in Loop: Header=BB29_9 Depth=1
	ldrh	w9, [x9, #2]
	tst	w8, #0x2
	ubfiz	x10, x9, #3, #32
	add	w12, w15, w9
	csel	w20, w12, w9, eq
	add	x11, x27, x10
	add	x10, x28, x10
	csel	x10, x11, x10, eq
	cbz	x16, LBB29_14
; %bb.11:                               ; %B37
                                        ;   in Loop: Header=BB29_9 Depth=1
	ldr	x8, [x16, w20, uxtw #3]
	cbz	x8, LBB29_22
LBB29_12:                               ; %B96
                                        ;   in Loop: Header=BB29_9 Depth=1
	add	w19, w19, #1
	cmp	w19, w13
	b.lo	LBB29_9
	b	LBB29_24
LBB29_13:                               ; %B11
                                        ;   in Loop: Header=BB29_9 Depth=1
	cbnz	x26, LBB29_12
	b	LBB29_40
LBB29_14:                               ; %B19
                                        ;   in Loop: Header=BB29_9 Depth=1
	ldr	w8, [x23, #80]
	str	x2, [x23, #48]
	mov	x0, x24
	mov	w2, #48                         ; =0x30
	str	w20, [sp, #4]                   ; 4-byte Folded Spill
	lsl	x1, x8, #3
	mov	x20, x8
	str	x10, [sp, #24]                  ; 8-byte Folded Spill
	bl	_prim_try_malloc_gc
	ldr	x10, [sp, #24]                  ; 8-byte Folded Reload
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	cbz	x0, LBB29_40
; %bb.15:                               ; %B32.preheader
                                        ;   in Loop: Header=BB29_9 Depth=1
	mov	x8, x0
	mov	w9, wzr
LBB29_16:                               ; %B32
                                        ;   Parent Loop BB29_9 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	w9, w9, #1
	str	xzr, [x8], #8
	cmp	w9, w20
	b.lo	LBB29_16
; %bb.17:                               ; %B34
                                        ;   in Loop: Header=BB29_9 Depth=1
	mov	x16, x0
	mov	w17, #1                         ; =0x1
	str	x0, [x23, #72]
LBB29_18:                               ; %B22
                                        ;   in Loop: Header=BB29_9 Depth=1
	ldr	w8, [x23, #44]
	mov	w1, #16                         ; =0x10
	stp	x10, x16, [sp, #24]             ; 16-byte Folded Spill
	str	w17, [sp]                       ; 4-byte Folded Spill
	mov	x0, x24
	str	x2, [x23, #48]
	tbnz	w8, #4, LBB29_23
; %bb.19:                               ; %B29
                                        ;   in Loop: Header=BB29_9 Depth=1
	mov	w2, #16                         ; =0x10
LBB29_20:                               ; %B29
                                        ;   in Loop: Header=BB29_9 Depth=1
	bl	_prim_try_malloc_gc
	ldp	x14, x13, [sp, #48]             ; 16-byte Folded Reload
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	ldp	x9, x16, [sp, #24]              ; 16-byte Folded Reload
	ldr	w15, [sp, #44]                  ; 4-byte Folded Reload
	ldr	w17, [sp]                       ; 4-byte Folded Reload
	cbz	x0, LBB29_40
; %bb.21:                               ;   in Loop: Header=BB29_9 Depth=1
	mov	x8, x0
	str	x9, [x8]
	mov	w9, #18                         ; =0x12
	str	x9, [x8, #8]
	ldr	w9, [sp, #4]                    ; 4-byte Folded Reload
	str	x8, [x16, w9, uxtw #3]
	b	LBB29_12
LBB29_22:                               ; %B39
                                        ;   in Loop: Header=BB29_9 Depth=1
	cmp	w17, #1
	str	w20, [sp, #4]                   ; 4-byte Folded Spill
	b.ne	LBB29_40
	b	LBB29_18
LBB29_23:                               ; %B24
                                        ;   in Loop: Header=BB29_9 Depth=1
	mov	w2, #57                         ; =0x39
	b	LBB29_20
LBB29_24:                               ; %B49
	lsl	x1, x13, #3
	str	x2, [x23, #48]
	mov	x0, x24
	mov	w2, #48                         ; =0x30
	mov	x19, x16
	bl	_prim_try_malloc_gc
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	mov	x16, x19
	mov	x19, x0
	cbz	x0, LBB29_40
; %bb.25:                               ; %B52
	ldr	w8, [sp, #76]                   ; 4-byte Folded Reload
	str	x16, [sp, #32]                  ; 8-byte Folded Spill
	str	x2, [x23, #48]
	tbnz	w8, #0, LBB29_36
LBB29_26:                               ; %B88
	mov	x0, x24
	mov	w1, #88                         ; =0x58
	mov	w2, #2                          ; =0x2
	bl	_prim_try_malloc_gc
	ldp	x16, x15, [sp, #48]             ; 16-byte Folded Reload
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	ldr	w17, [sp, #44]                  ; 4-byte Folded Reload
	ldr	x1, [sp, #32]                   ; 8-byte Folded Reload
	cbz	x0, LBB29_40
; %bb.27:                               ; %B91
	ldr	x11, [sp, #8]                   ; 8-byte Folded Reload
	mov	w10, #1                         ; =0x1
	mov	x12, x0
	mov	x20, xzr
	mov	x8, x0
	ldr	w9, [x11]
	add	w9, w9, #1
	str	w9, [x11]
	mov	w9, #13                         ; =0xd
	str	w10, [x0]
	strb	w10, [x0, #5]
	add	x10, x0, #8
	strh	w9, [x0, #6]
	mov	x9, xzr
	stlr	x11, [x10]
	ldrb	w10, [x24, #392]
	cbnz	w10, LBB29_39
LBB29_28:                               ; %B59
	ldr	x11, [sp, #88]                  ; 8-byte Folded Reload
	add	x10, x8, #56
	mov	x12, #2                         ; =0x2
	str	x10, [x8, #16]
	ldr	x13, [sp, #16]                  ; 8-byte Folded Reload
	movk	x12, #1, lsl #48
	stp	x11, x19, [x8, #32]
	ldrh	w11, [x11, #44]
	orr	x12, x13, x12
	orr	x11, x11, #0xfffe000000000000
	stp	x11, x12, [x8, #56]
	ldr	w11, [sp, #76]                  ; 4-byte Folded Reload
	tbnz	w11, #0, LBB29_42
; %bb.29:                               ; %B78
	ldr	x14, [sp, #64]                  ; 8-byte Folded Reload
	cbz	w15, LBB29_41
LBB29_30:                               ; %B60.preheader
	mov	w9, wzr
	mov	w10, wzr
LBB29_31:                               ; %B60
                                        ; =>This Inner Loop Header: Depth=1
	add	x11, x16, w9, uxtw
	ldrb	w12, [x11]
	ldrh	w11, [x11, #2]
	tbz	w12, #0, LBB29_33
; %bb.32:                               ; %B62
                                        ;   in Loop: Header=BB29_31 Depth=1
	add	w13, w17, w11
	tst	w12, #0x2
	csel	w11, w11, w13, ne
	ldr	x11, [x1, w11, sxtw #3]
	add	w10, w10, #1
	add	w9, w9, #8
	cmp	w10, w15
	str	x11, [x19], #8
	b.lo	LBB29_31
	b	LBB29_41
LBB29_33:                               ; %B74
                                        ;   in Loop: Header=BB29_31 Depth=1
	ldr	x11, [x26, w11, uxtw #3]
	add	w10, w10, #1
	add	w9, w9, #8
	cmp	w10, w15
	str	x11, [x19], #8
	b.lo	LBB29_31
	b	LBB29_41
LBB29_34:                               ; %B104
	ldr	x8, [x9, #8]
	ldr	w8, [x8]
	asr	w8, w8, #30
	cmp	w8, #1
	b.eq	LBB29_7
	b	LBB29_40
LBB29_35:
	mov	x19, xzr
	ldr	w8, [sp, #76]                   ; 4-byte Folded Reload
	str	x16, [sp, #32]                  ; 8-byte Folded Spill
	str	x2, [x23, #48]
	tbz	w8, #0, LBB29_26
LBB29_36:                               ; %B54
	mov	x0, x24
	mov	w1, #16                         ; =0x10
	mov	w2, #1                          ; =0x1
	bl	_prim_try_malloc_gc
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	mov	x20, x0
	cbz	x20, LBB29_40
; %bb.37:                               ; %B56
	str	x2, [x23, #48]
	mov	x0, x24
	mov	w1, #88                         ; =0x58
	mov	w2, #2                          ; =0x2
	bl	_prim_try_malloc_gc
	ldp	x16, x15, [sp, #48]             ; 16-byte Folded Reload
	ldr	x1, [sp, #32]                   ; 8-byte Folded Reload
	ldr	w17, [sp, #44]                  ; 4-byte Folded Reload
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	cbz	x0, LBB29_40
; %bb.38:                               ; %B82
	ldr	x11, [sp, #8]                   ; 8-byte Folded Reload
	mov	w10, #1                         ; =0x1
	mov	x12, x0
	mov	x8, x0
	ldr	w9, [x11]
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
	ldrb	w10, [x24, #392]
	cbz	w10, LBB29_28
LBB29_39:                               ; %B59.sink.split
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	str	x12, [sp, #24]                  ; 8-byte Folded Spill
	orr	x0, x11, x8
	bl	_prim_WriteBarrierNoStore
	ldp	x8, x1, [sp, #24]               ; 16-byte Folded Reload
	mov	x9, x20
	ldp	x16, x15, [sp, #48]             ; 16-byte Folded Reload
	ldr	w17, [sp, #44]                  ; 4-byte Folded Reload
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	b	LBB29_28
LBB29_40:                               ; %B108
	ldr	x1, [sp, #88]                   ; 8-byte Folded Reload
	str	x2, [x23, #48]
	mov	x0, x24
	mov	x2, x26
	mov	x3, x23
	bl	_js_closure_gc_slowpath
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	ldr	x14, [sp, #64]                  ; 8-byte Folded Reload
	cmp	x0, #130
	mov	x8, x0
	b.eq	LBB29_43
LBB29_41:                               ; %B71
	str	x8, [x2], #8
	add	x19, x14, #5
	ldrb	w8, [x14, #4]
	mov	x20, x2
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #96
	br	x1
LBB29_42:                               ; %B76
Lloh4:
	adrp	x11, _js_instantiate_prototype_gc@GOTPAGE
Lloh5:
	ldr	x11, [x11, _js_instantiate_prototype_gc@GOTPAGEOFF]
	stp	x11, xzr, [x9]
	str	x9, [x10, #16]
	ldr	x14, [sp, #64]                  ; 8-byte Folded Reload
	cbnz	w15, LBB29_30
	b	LBB29_41
LBB29_43:                               ; %B109
	mov	x19, x14
	mov	x20, x2
	add	sp, sp, #96
	b	_exception_asm_h
	.loh AdrpLdrGot	Lloh4, Lloh5
                                        ; -- End function
	.private_extern	_push_atom_value_0_asm_h ; -- Begin function push_atom_value_0_asm_h
	.globl	_push_atom_value_0_asm_h
	.p2align	2
_push_atom_value_0_asm_h:               ; @push_atom_value_0_asm_h
; %bb.0:                                ; %B13
	ldr	w1, [x19]
	tbnz	w1, #31, LBB30_5
; %bb.1:                                ; %B1
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, sxtw #3]
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, LBB30_4
; %bb.2:                                ; %B9
	ldr	w9, [x8, #8]
	asr	w9, w9, #30
	cmp	w9, #1
	b.ne	LBB30_5
LBB30_3:                                ; %B7
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	mov	x9, #2                          ; =0x2
	movk	x9, #1, lsl #48
	orr	x22, x8, x9
	br	x1
LBB30_4:                                ; %B2
	ldr	x9, [x8, #8]
	ldr	w9, [x9]
	asr	w9, w9, #30
	cmp	w9, #1
	b.eq	LBB30_3
LBB30_5:                                ; %B10
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB30_7
; %bb.6:                                ; %B12
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB30_7:                                ; %B11
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_private_symbol_0_asm_h ; -- Begin function private_symbol_0_asm_h
	.globl	_private_symbol_0_asm_h
	.p2align	2
_private_symbol_0_asm_h:                ; @private_symbol_0_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, #4                          ; =0x4
	str	x20, [x23, #48]
	bl	_JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	LBB31_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB31_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_undefined_0_asm_h      ; -- Begin function undefined_0_asm_h
	.globl	_undefined_0_asm_h
	.p2align	2
_undefined_0_asm_h:                     ; @undefined_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	w22, #18                        ; =0x12
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_null_0_asm_h           ; -- Begin function null_0_asm_h
	.globl	_null_0_asm_h
	.p2align	2
_null_0_asm_h:                          ; @null_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	w22, #2                         ; =0x2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_this_0_asm_h      ; -- Begin function push_this_0_asm_h
	.globl	_push_this_0_asm_h
	.p2align	2
_push_this_0_asm_h:                     ; @push_this_0_asm_h
; %bb.0:                                ; %B12
	ldr	w8, [x23, #44]
	ldr	x1, [x23, #88]
	tbnz	w8, #0, LBB34_2
; %bb.1:                                ; %B12
	ldr	x8, [x23, #88]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, LBB34_3
LBB34_2:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x1
	add	w8, w8, #243
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
LBB34_3:                                ; %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	LBB34_5
; %bb.4:                                ; %B7
	ldrb	w8, [x19], #1
	ldr	x22, [x24, #208]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB34_5:                                ; %B9
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB34_7
; %bb.6:                                ; %B11
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB34_7:                                ; %B10
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_push_false_0_asm_h     ; -- Begin function push_false_0_asm_h
	.globl	_push_false_0_asm_h
	.p2align	2
_push_false_0_asm_h:                    ; @push_false_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_true_0_asm_h      ; -- Begin function push_true_0_asm_h
	.globl	_push_true_0_asm_h
	.p2align	2
_push_true_0_asm_h:                     ; @push_true_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_object_0_asm_h         ; -- Begin function object_0_asm_h
	.globl	_object_0_asm_h
	.p2align	2
_object_0_asm_h:                        ; @object_0_asm_h
; %bb.0:                                ; %B16
	ldrb	w8, [x24, #371]
	stp	x19, x20, [sp, #-16]!           ; 16-byte Folded Spill
	cbnz	w8, LBB37_5
; %bb.1:                                ; %B1
	ldr	x19, [x24, #408]
	cbz	x19, LBB37_5
; %bb.2:                                ; %B5
	mov	x0, x24
	mov	w1, #64                         ; =0x40
	mov	w2, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x9, x0
	cbz	x9, LBB37_5
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
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB37_7
LBB37_4:                                ; %B9
	add	x8, x9, #32
	ldr	x19, [sp]                       ; 8-byte Folded Reload
	mov	x22, x9
	str	x8, [x9, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB37_5:                                ; %B13
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	LBB37_8
; %bb.6:                                ; %B15
	ldp	x19, x20, [sp]                  ; 16-byte Folded Reload
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB37_7:                                ; %B11
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x19, x8
	mov	x19, x9
	bl	_prim_WriteBarrierNoStore
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x9, x19
	b	LBB37_4
LBB37_8:                                ; %B14
	ldp	x19, x20, [sp], #16             ; 16-byte Folded Reload
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_special_object_0_asm_h ; -- Begin function special_object_0_asm_h
	.globl	_special_object_0_asm_h
	.p2align	2
_special_object_0_asm_h:                ; @special_object_0_asm_h
; %bb.0:                                ; %B12
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	LBB38_5
; %bb.1:                                ; %B12
	cbz	w8, LBB38_8
; %bb.2:                                ; %B12
	cmp	w8, #1
	b.ne	LBB38_10
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
	b.eq	LBB38_12
LBB38_4:
	mov	x8, x0
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB38_5:                                ; %B12
	cmp	w8, #3
	b.eq	LBB38_9
; %bb.6:                                ; %B12
	cmp	w8, #4
	b.ne	LBB38_11
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
LBB38_8:                                ; %B13
	b	_FastBuildArguments_asm_h
LBB38_9:                                ; %B16
	ldr	x8, [x23, #96]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB38_10:                               ; %B15
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB38_11:                               ; %B9
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.ne	LBB38_4
LBB38_12:                               ; %B10
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_rest_0_asm_h           ; -- Begin function rest_0_asm_h
	.globl	_rest_0_asm_h
	.p2align	2
_rest_0_asm_h:                          ; @rest_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x23, #120]
	ldrh	w1, [x19]
	mov	x0, x24
	mov	x3, x28
	str	x20, [x23, #48]
	bl	_js_build_rest_gc
	cmp	x0, #130
	b.eq	LBB39_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB39_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_drop_0_asm_h           ; -- Begin function drop_0_asm_h
	.globl	_drop_0_asm_h
	.p2align	2
_drop_0_asm_h:                          ; @drop_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_nip_0_asm_h            ; -- Begin function nip_0_asm_h
	.globl	_nip_0_asm_h
	.p2align	2
_nip_0_asm_h:                           ; @nip_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldur	x22, [x20, #-8]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x8, x20, #16
	mov	x20, x8
	br	x1
                                        ; -- End function
	.private_extern	_nip1_0_asm_h           ; -- Begin function nip1_0_asm_h
	.globl	_nip1_0_asm_h
	.p2align	2
_nip1_0_asm_h:                          ; @nip1_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldp	x22, x21, [x20, #-16]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	sub	x8, x20, #24
	mov	x20, x8
	br	x1
                                        ; -- End function
	.private_extern	_dup_0_asm_h            ; -- Begin function dup_0_asm_h
	.globl	_dup_0_asm_h
	.p2align	2
_dup_0_asm_h:                           ; @dup_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x20, #-8]!
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x22
	br	x1
                                        ; -- End function
	.private_extern	_dup1_0_asm_h           ; -- Begin function dup1_0_asm_h
	.globl	_dup1_0_asm_h
	.p2align	2
_dup1_0_asm_h:                          ; @dup1_0_asm_h
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
	.private_extern	_dup2_0_asm_h           ; -- Begin function dup2_0_asm_h
	.globl	_dup2_0_asm_h
	.p2align	2
_dup2_0_asm_h:                          ; @dup2_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldp	x22, x21, [x20, #-16]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_dup3_0_asm_h           ; -- Begin function dup3_0_asm_h
	.globl	_dup3_0_asm_h
	.p2align	2
_dup3_0_asm_h:                          ; @dup3_0_asm_h
; %bb.0:                                ; %B0
	ldp	x8, x22, [x20, #-24]
	ldur	x21, [x20, #-8]
	str	x8, [x20], #8
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_insert2_0_asm_h        ; -- Begin function insert2_0_asm_h
	.globl	_insert2_0_asm_h
	.p2align	2
_insert2_0_asm_h:                       ; @insert2_0_asm_h
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
	.private_extern	_insert3_0_asm_h        ; -- Begin function insert3_0_asm_h
	.globl	_insert3_0_asm_h
	.p2align	2
_insert3_0_asm_h:                       ; @insert3_0_asm_h
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
	.private_extern	_insert4_0_asm_h        ; -- Begin function insert4_0_asm_h
	.globl	_insert4_0_asm_h
	.p2align	2
_insert4_0_asm_h:                       ; @insert4_0_asm_h
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
	.private_extern	_perm3_0_asm_h          ; -- Begin function perm3_0_asm_h
	.globl	_perm3_0_asm_h
	.p2align	2
_perm3_0_asm_h:                         ; @perm3_0_asm_h
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
	.private_extern	_perm4_0_asm_h          ; -- Begin function perm4_0_asm_h
	.globl	_perm4_0_asm_h
	.p2align	2
_perm4_0_asm_h:                         ; @perm4_0_asm_h
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
	.private_extern	_perm5_0_asm_h          ; -- Begin function perm5_0_asm_h
	.globl	_perm5_0_asm_h
	.p2align	2
_perm5_0_asm_h:                         ; @perm5_0_asm_h
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
	.private_extern	_swap_0_asm_h           ; -- Begin function swap_0_asm_h
	.globl	_swap_0_asm_h
	.p2align	2
_swap_0_asm_h:                          ; @swap_0_asm_h
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
	.private_extern	_swap2_0_asm_h          ; -- Begin function swap2_0_asm_h
	.globl	_swap2_0_asm_h
	.p2align	2
_swap2_0_asm_h:                         ; @swap2_0_asm_h
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
	.private_extern	_rot3l_0_asm_h          ; -- Begin function rot3l_0_asm_h
	.globl	_rot3l_0_asm_h
	.p2align	2
_rot3l_0_asm_h:                         ; @rot3l_0_asm_h
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
	.private_extern	_rot3r_0_asm_h          ; -- Begin function rot3r_0_asm_h
	.globl	_rot3r_0_asm_h
	.p2align	2
_rot3r_0_asm_h:                         ; @rot3r_0_asm_h
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
	.private_extern	_rot4l_0_asm_h          ; -- Begin function rot4l_0_asm_h
	.globl	_rot4l_0_asm_h
	.p2align	2
_rot4l_0_asm_h:                         ; @rot4l_0_asm_h
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
	.private_extern	_rot5l_0_asm_h          ; -- Begin function rot5l_0_asm_h
	.globl	_rot5l_0_asm_h
	.p2align	2
_rot5l_0_asm_h:                         ; @rot5l_0_asm_h
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
	.private_extern	_call_constructor_0_asm_h ; -- Begin function call_constructor_0_asm_h
	.globl	_call_constructor_0_asm_h
	.p2align	2
_call_constructor_0_asm_h:              ; @call_constructor_0_asm_h
; %bb.0:                                ; %B18
	ldrh	w3, [x19]
	sub	x4, x20, w3, uxtw #3
	ldp	x1, x2, [x4, #-16]
	and	x8, x1, #0xfffffffffffffffe
	cmp	x1, x2
	and	x8, x8, #0xffff000000000003
	ccmp	x8, #0, #0, eq
	b.ne	LBB59_5
; %bb.1:                                ; %B14
	ldrh	w8, [x1, #6]
	cmp	w8, #13
	b.ne	LBB59_5
; %bb.2:                                ; %B7
	ldrb	w8, [x1, #5]
	tbz	w8, #4, LBB59_5
; %bb.3:                                ; %B9
	ldr	x8, [x1, #32]
	mov	x0, x3
	ldrb	w8, [x8, #6]
	tbnz	w8, #2, LBB59_7
; %bb.4:                                ; %B10
	b	_FastCallConstructor_asm_h
LBB59_5:                                ; %B2
	add	x8, x19, #2
	mov	x0, x24
	mov	w5, wzr
	str	x8, [x23, #32]
                                        ; kill: def $w3 killed $w3 killed $x3
	str	x20, [x23, #48]
	bl	_JS_CallConstructorInternal_GC
	cmp	x0, #130
	b.eq	LBB59_8
; %bb.6:                                ; %B4
	ldrh	w8, [x19]
	sub	x8, x20, x8, lsl #3
	stur	x0, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x9, lsl #3]
	br	x1
LBB59_7:                                ; %B11
	b	_FastCallDerivedConstructor_asm_h
LBB59_8:                                ; %B3
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_call_0_asm_h           ; -- Begin function call_0_asm_h
	.globl	_call_0_asm_h
	.p2align	2
_call_0_asm_h:                          ; @call_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19], #2
	str	x20, [x23, #48]
	str	x19, [x23, #32]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	sub	x20, x20, x8, lsl #3
	mov	x0, x8
	ldur	x22, [x20, #-8]
	bl	_common_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #104]
	b.eq	LBB60_2
; %bb.1:                                ; %B4
	ldurh	w8, [x19, #-2]
	add	w8, w8, #1
	sub	x20, x20, w8, uxtw #3
	str	x0, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB60_2:                                ; %B3
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_tail_call_0_asm_h      ; -- Begin function tail_call_0_asm_h
	.globl	_tail_call_0_asm_h
	.p2align	2
_tail_call_0_asm_h:                     ; @tail_call_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19], #2
	str	x20, [x23, #48]
	str	x19, [x23, #32]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	sub	x20, x20, x8, lsl #3
	mov	x0, x8
	ldur	x22, [x20, #-8]
	bl	_common_call_asm_h
	cmp	x0, #130
	b.eq	LBB61_2
; %bb.1:                                ; %B4
	ldr	x26, [x23, #104]
	mov	x19, xzr
	mov	x20, xzr
	b	_common_return_asm_h
LBB61_2:                                ; %B3
	mov	x19, xzr
	mov	x20, xzr
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_call_method_0_asm_h    ; -- Begin function call_method_0_asm_h
	.globl	_call_method_0_asm_h
	.p2align	2
_call_method_0_asm_h:                   ; @call_method_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19], #2
	str	x20, [x23, #48]
	str	x19, [x23, #32]
	mov	w27, #18                        ; =0x12
	sub	x20, x20, x8, lsl #3
	mov	x0, x8
	ldp	x21, x22, [x20, #-16]
	bl	_common_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #104]
	b.eq	LBB62_2
; %bb.1:                                ; %B4
	ldurh	w8, [x19, #-2]
	add	w8, w8, #2
	sub	x20, x20, w8, uxtw #3
	str	x0, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB62_2:                                ; %B3
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_tail_call_method_0_asm_h ; -- Begin function tail_call_method_0_asm_h
	.globl	_tail_call_method_0_asm_h
	.p2align	2
_tail_call_method_0_asm_h:              ; @tail_call_method_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19], #2
	str	x20, [x23, #48]
	str	x19, [x23, #32]
	mov	w27, #18                        ; =0x12
	sub	x20, x20, x8, lsl #3
	mov	x0, x8
	ldp	x21, x22, [x20, #-16]
	bl	_common_call_asm_h
	cmp	x0, #130
	b.eq	LBB63_2
; %bb.1:                                ; %B4
	ldr	x26, [x23, #104]
	mov	x19, xzr
	mov	x20, xzr
	b	_common_return_asm_h
LBB63_2:                                ; %B3
	mov	x19, xzr
	mov	x20, xzr
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_array_from_0_asm_h     ; -- Begin function array_from_0_asm_h
	.globl	_array_from_0_asm_h
	.p2align	2
_array_from_0_asm_h:                    ; @array_from_0_asm_h
; %bb.0:                                ; %B32
	sub	sp, sp, #64
	ldrh	w1, [x19]
	ldrb	w8, [x24, #371]
	str	x19, [sp, #40]                  ; 8-byte Folded Spill
	str	x20, [sp, #56]                  ; 8-byte Folded Spill
	sub	x9, x20, w1, uxtw #3
	str	x9, [sp, #24]                   ; 8-byte Folded Spill
	cbnz	w8, LBB64_13
; %bb.1:                                ; %B1
	ldr	x8, [x24, #40]
	str	x8, [sp, #32]                   ; 8-byte Folded Spill
	cbz	x8, LBB64_13
; %bb.2:                                ; %B5
	str	x1, [sp, #48]                   ; 8-byte Folded Spill
	cbz	w1, LBB64_8
; %bb.3:                                ; %B10
	ldp	x9, x8, [sp, #48]               ; 16-byte Folded Reload
	mov	x0, x24
	mov	w2, #42                         ; =0x2a
	lsl	x1, x9, #3
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x1, [sp, #48]                   ; 8-byte Folded Reload
	cbz	x0, LBB64_13
; %bb.4:                                ; %B13.preheader
	add	x10, x0, x1, lsl #3
	ldr	x19, [sp, #24]                  ; 8-byte Folded Reload
	mov	x20, x0
	str	x20, [sp, #16]                  ; 8-byte Folded Spill
	cmp	x20, x10
	b.ge	LBB64_9
LBB64_5:                                ; %B15
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x19]
	str	x8, [x20]
	ldrb	w9, [x24, #392]
	cbnz	w9, LBB64_7
LBB64_6:                                ; %B17
                                        ;   in Loop: Header=BB64_5 Depth=1
	add	x20, x20, #8
	add	x19, x19, #8
	cmp	x20, x10
	b.lt	LBB64_5
	b	LBB64_9
LBB64_7:                                ; %B18
                                        ;   in Loop: Header=BB64_5 Depth=1
	mov	x0, x8
	mov	x1, x24
	str	x10, [sp, #8]                   ; 8-byte Folded Spill
	bl	_prim_WriteBarrierNoStore
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	b	LBB64_6
LBB64_8:
	str	xzr, [sp, #16]                  ; 8-byte Folded Spill
LBB64_9:                                ; %B21
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	mov	x0, x24
	mov	w1, #88                         ; =0x58
	mov	w2, #2                          ; =0x2
	mov	w20, #2                         ; =0x2
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x1, [sp, #48]                   ; 8-byte Folded Reload
	mov	x19, x0
	cbz	x19, LBB64_13
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
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB64_15
LBB64_11:                               ; %B25
	orr	x8, x1, #0xfffe000000000000
	mov	x9, x19
	str	x8, [x9, #56]!
	ldr	x8, [sp, #16]                   ; 8-byte Folded Reload
	str	x9, [x19, #16]
	str	x8, [x19, #40]
	str	w1, [x19, #32]
	str	w1, [x19, #48]
LBB64_12:                               ; %B26
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
LBB64_13:                               ; %B29
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	ldr	x2, [sp, #24]                   ; 8-byte Folded Reload
	mov	x0, x24
                                        ; kill: def $w1 killed $w1 killed $x1
	str	x8, [x23, #48]
	bl	_JS_NewArrayWithArgs_GC
	cmp	x0, #130
	mov	x19, x0
	b.ne	LBB64_12
; %bb.14:                               ; %B30
	ldr	x19, [sp, #40]                  ; 8-byte Folded Reload
	ldr	x20, [sp, #56]                  ; 8-byte Folded Reload
	add	sp, sp, #64
	b	_exception_asm_h
LBB64_15:                               ; %B27
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	_prim_WriteBarrierNoStore
	ldr	x1, [sp, #48]                   ; 8-byte Folded Reload
	b	LBB64_11
                                        ; -- End function
	.private_extern	_apply_0_asm_h          ; -- Begin function apply_0_asm_h
	.globl	_apply_0_asm_h
	.p2align	2
_apply_0_asm_h:                         ; @apply_0_asm_h
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
	b.eq	LBB65_2
; %bb.1:                                ; %B3
	stur	x0, [x20, #-24]
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB65_2:                                ; %B2
	add	sp, sp, #16
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_return_0_asm_h         ; -- Begin function return_0_asm_h
	.globl	_return_0_asm_h
	.p2align	2
_return_0_asm_h:                        ; @return_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	mov	x0, x22
	b	_common_return_asm_h
                                        ; -- End function
	.private_extern	_return_undef_0_asm_h   ; -- Begin function return_undef_0_asm_h
	.globl	_return_undef_0_asm_h
	.p2align	2
_return_undef_0_asm_h:                  ; @return_undef_0_asm_h
; %bb.0:                                ; %B0
	mov	w0, #18                         ; =0x12
	b	_common_return_asm_h
                                        ; -- End function
	.private_extern	_check_ctor_return_0_asm_h ; -- Begin function check_ctor_return_0_asm_h
	.globl	_check_ctor_return_0_asm_h
	.p2align	2
_check_ctor_return_0_asm_h:             ; @check_ctor_return_0_asm_h
; %bb.0:                                ; %B5
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	LBB68_3
; %bb.1:                                ; %B2
	cmp	x22, #18
	b.eq	LBB68_4
; %bb.2:                                ; %B3
Lloh6:
	adrp	x1, l___unnamed_3@PAGE
Lloh7:
	add	x1, x1, l___unnamed_3@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_ThrowTypeError
	b	_exception_asm_h
LBB68_3:                                ; %B6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w21, #6                         ; =0x6
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB68_4:                                ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w21, #7                         ; =0x7
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh6, Lloh7
                                        ; -- End function
	.private_extern	_check_ctor_0_asm_h     ; -- Begin function check_ctor_0_asm_h
	.globl	_check_ctor_0_asm_h
	.p2align	2
_check_ctor_0_asm_h:                    ; @check_ctor_0_asm_h
; %bb.0:                                ; %B2
	ldr	x8, [x23, #96]
	cmp	x8, #18
	b.ne	LBB69_2
; %bb.1:                                ; %B3
Lloh8:
	adrp	x1, l___unnamed_4@PAGE
Lloh9:
	add	x1, x1, l___unnamed_4@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_ThrowTypeError
	b	_exception_asm_h
LBB69_2:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
	.loh AdrpAdd	Lloh8, Lloh9
                                        ; -- End function
	.private_extern	_check_brand_0_asm_h    ; -- Begin function check_brand_0_asm_h
	.globl	_check_brand_0_asm_h
	.p2align	2
_check_brand_0_asm_h:                   ; @check_brand_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	_JS_CheckBrand_GC
	tbnz	w0, #31, LBB70_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB70_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_add_brand_0_asm_h      ; -- Begin function add_brand_0_asm_h
	.globl	_add_brand_0_asm_h
	.p2align	2
_add_brand_0_asm_h:                     ; @add_brand_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	_JS_AddBrand_GC
	tbnz	w0, #31, LBB71_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB71_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_return_async_0_asm_h   ; -- Begin function return_async_0_asm_h
	.globl	_return_async_0_asm_h
	.p2align	2
_return_async_0_asm_h:                  ; @return_async_0_asm_h
; %bb.0:                                ; %B0
	str	x19, [x23, #32]
	mov	w0, #18                         ; =0x12
	str	x20, [x23, #48]
	b	_common_return_direct_asm_h
                                        ; -- End function
	.private_extern	_throw_0_asm_h          ; -- Begin function throw_0_asm_h
	.globl	_throw_0_asm_h
	.p2align	2
_throw_0_asm_h:                         ; @throw_0_asm_h
; %bb.0:                                ; %B0
	ldr	x1, [x20, #-8]!
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_Throw
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_throw_var_0_asm_h      ; -- Begin function throw_var_0_asm_h
	.globl	_throw_var_0_asm_h
	.p2align	2
_throw_var_0_asm_h:                     ; @throw_var_0_asm_h
; %bb.0:                                ; %B3
	sub	sp, sp, #16
	ldrb	w8, [x19, #4]
	ldr	w2, [x19]
	str	x20, [x23, #48]
	cmp	w8, #1
	b.le	LBB74_5
; %bb.1:                                ; %B3
	cmp	w8, #2
	b.eq	LBB74_8
; %bb.2:                                ; %B3
	cmp	w8, #3
	b.eq	LBB74_9
; %bb.3:                                ; %B3
	cmp	w8, #4
	b.ne	LBB74_11
; %bb.4:                                ; %B8
Lloh10:
	adrp	x1, l___unnamed_5@PAGE
Lloh11:
	add	x1, x1, l___unnamed_5@PAGEOFF
	mov	x0, x24
	bl	_LEPUS_ThrowTypeError
	add	sp, sp, #16
	b	_exception_asm_h
LBB74_5:                                ; %B3
	cbz	w8, LBB74_10
; %bb.6:                                ; %B3
	cmp	w8, #1
	b.ne	LBB74_11
; %bb.7:                                ; %B5
	mov	x0, x24
	mov	w1, w2
	bl	_JS_ThrowSyntaxErrorVarRedeclaration_GC
	add	sp, sp, #16
	b	_exception_asm_h
LBB74_8:                                ; %B6
	mov	x0, x24
	mov	w1, w2
	bl	_JS_ThrowReferenceErrorUninitialized_GC
	add	sp, sp, #16
	b	_exception_asm_h
LBB74_9:                                ; %B7
Lloh12:
	adrp	x1, l___unnamed_6@PAGE
Lloh13:
	add	x1, x1, l___unnamed_6@PAGEOFF
	mov	x0, x24
	bl	_LEPUS_ThrowReferenceError
	add	sp, sp, #16
	b	_exception_asm_h
LBB74_10:                               ; %B4
	mov	x0, x24
	mov	w1, #16384                      ; =0x4000
                                        ; kill: def $w2 killed $w2 killed $x2
	bl	_JS_ThrowTypeErrorReadOnly
	add	sp, sp, #16
	b	_exception_asm_h
LBB74_11:                               ; %B9
Lloh14:
	adrp	x1, l___unnamed_7@PAGE
Lloh15:
	add	x1, x1, l___unnamed_7@PAGEOFF
	mov	x0, x24
	str	x2, [sp]
	bl	_LEPUS_ThrowInternalError
	add	sp, sp, #16
	b	_exception_asm_h
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpAdd	Lloh12, Lloh13
	.loh AdrpAdd	Lloh14, Lloh15
                                        ; -- End function
	.private_extern	_eval_0_asm_h           ; -- Begin function eval_0_asm_h
	.globl	_eval_0_asm_h
	.p2align	2
_eval_0_asm_h:                          ; @eval_0_asm_h
; %bb.0:                                ; %B1
	ldrh	w8, [x19]
	ldur	x2, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #48]
	sub	w1, w8, #1
	bl	_prim_js_op_eval_gc
	cmp	x0, #130
	b.eq	LBB75_2
; %bb.1:                                ; %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB75_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_regexp_0_asm_h         ; -- Begin function regexp_0_asm_h
	.globl	_regexp_0_asm_h
	.p2align	2
_regexp_0_asm_h:                        ; @regexp_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w1, #18                         ; =0x12
	str	x20, [x23, #48]
	mov	x2, x22
	mov	x3, x21
	bl	_js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	LBB76_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB76_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_super_ctor_0_asm_h ; -- Begin function get_super_ctor_0_asm_h
	.globl	_get_super_ctor_0_asm_h
	.p2align	2
_get_super_ctor_0_asm_h:                ; @get_super_ctor_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	bl	_primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	LBB77_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB77_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_super_0_asm_h      ; -- Begin function get_super_0_asm_h
	.globl	_get_super_0_asm_h
	.p2align	2
_get_super_0_asm_h:                     ; @get_super_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	bl	_JS_GetPrototype_GC
	cmp	x0, #130
	b.eq	LBB78_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB78_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_import_0_asm_h         ; -- Begin function import_0_asm_h
	.globl	_import_0_asm_h
	.p2align	2
_import_0_asm_h:                        ; @import_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	bl	_js_dynamic_import
	cmp	x0, #130
	b.eq	LBB79_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB79_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_check_var_0_asm_h      ; -- Begin function check_var_0_asm_h
	.globl	_check_var_0_asm_h
	.p2align	2
_check_var_0_asm_h:                     ; @check_var_0_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_CheckGlobalVar_GC
	tbnz	w0, #31, LBB80_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB80_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_var_undef_0_asm_h  ; -- Begin function get_var_undef_0_asm_h
	.globl	_get_var_undef_0_asm_h
	.p2align	2
_get_var_undef_0_asm_h:                 ; @get_var_undef_0_asm_h
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
	cbz	w11, LBB81_3
LBB81_1:                                ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB81_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB81_1 Depth=1
	ldr	w11, [x12]
	and	w11, w11, #0x3ffffff
	cbnz	w11, LBB81_1
LBB81_3:                                ; %B11
	ldr	x8, [x24, #208]
	mov	w10, #18                        ; =0x12
LBB81_4:                                ; %B33
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB81_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w9, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB81_7
LBB81_5:                                ; %B22
                                        ;   Parent Loop BB81_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w9
	b.eq	LBB81_9
; %bb.6:                                ; %B24
                                        ;   in Loop: Header=BB81_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB81_5
LBB81_7:                                ; %B27
                                        ;   in Loop: Header=BB81_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	LBB81_13
; %bb.8:                                ; %B30
                                        ;   in Loop: Header=BB81_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB81_4
	b	LBB81_11
LBB81_9:                                ; %B12
	lsr	w9, w13, #26
	tst	w9, #0x30
	b.ne	LBB81_13
LBB81_10:                               ; %B7.sink.split
	ldr	x8, [x8, #16]
	sub	w9, w11, #1
	ldr	x10, [x8, w9, sxtw #3]
LBB81_11:                               ; %B7
	cmp	x10, #34
	b.eq	LBB81_15
; %bb.12:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x10
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB81_13:                               ; %B17
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB81_16
; %bb.14:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB81_15:                               ; %B3
	b	_ThrowReferenceErrorUninitialized_asm_h
LBB81_16:                               ; %B18
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_var_0_asm_h        ; -- Begin function get_var_0_asm_h
	.globl	_get_var_0_asm_h
	.p2align	2
_get_var_0_asm_h:                       ; @get_var_0_asm_h
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
	cbz	w10, LBB82_3
LBB82_1:                                ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB82_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB82_1 Depth=1
	ldr	w10, [x12]
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB82_1
LBB82_3:                                ; %B11
	ldr	x8, [x24, #208]
LBB82_4:                                ; %B32
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB82_5 Depth 2
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w9, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB82_7
LBB82_5:                                ; %B21
                                        ;   Parent Loop BB82_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	LBB82_9
; %bb.6:                                ; %B23
                                        ;   in Loop: Header=BB82_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB82_5
LBB82_7:                                ; %B26
                                        ;   in Loop: Header=BB82_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB82_12
; %bb.8:                                ; %B29
                                        ;   in Loop: Header=BB82_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB82_4
	b	LBB82_12
LBB82_9:                                ; %B12
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	LBB82_12
LBB82_10:                               ; %B7
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	LBB82_14
; %bb.11:                               ; %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB82_12:                               ; %B16
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB82_15
; %bb.13:                               ; %B18
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB82_14:                               ; %B3
	b	_ThrowReferenceErrorUninitialized_asm_h
LBB82_15:                               ; %B17
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_put_var_0_asm_h        ; -- Begin function put_var_0_asm_h
	.globl	_put_var_0_asm_h
	.p2align	2
_put_var_0_asm_h:                       ; @put_var_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	mov	w3, wzr
	str	x20, [x23, #48]
	mov	x2, x22
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB83_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB83_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_put_var_init_0_asm_h   ; -- Begin function put_var_init_0_asm_h
	.globl	_put_var_init_0_asm_h
	.p2align	2
_put_var_init_0_asm_h:                  ; @put_var_init_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	mov	x2, x22
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB84_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB84_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_put_var_strict_0_asm_h ; -- Begin function put_var_strict_0_asm_h
	.globl	_put_var_strict_0_asm_h
	.p2align	2
_put_var_strict_0_asm_h:                ; @put_var_strict_0_asm_h
; %bb.0:                                ; %B5
	ldp	x22, x21, [x20, #-16]
	cmp	x22, #7
	b.ne	LBB85_3
; %bb.1:                                ; %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB85_4
; %bb.2:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB85_3:                                ; %B6
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB85_4:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_ref_value_0_asm_h  ; -- Begin function get_ref_value_0_asm_h
	.globl	_get_ref_value_0_asm_h
	.p2align	2
_get_ref_value_0_asm_h:                 ; @get_ref_value_0_asm_h
; %bb.0:                                ; %B8
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	cmp	x22, #18
	b.eq	LBB86_3
; %bb.1:                                ; %B1
	mov	x1, x22
	mov	x2, x21
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB86_5
; %bb.2:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB86_3:                                ; %B5
	mov	x1, x21
	bl	_js_value_to_atom_gc
	cbz	w0, LBB86_5
; %bb.4:                                ; %B7
	mov	w1, w0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB86_5:                                ; %B6
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_put_ref_value_0_asm_h  ; -- Begin function put_ref_value_0_asm_h
	.globl	_put_ref_value_0_asm_h
	.p2align	2
_put_ref_value_0_asm_h:                 ; @put_ref_value_0_asm_h
; %bb.0:                                ; %B12
	ldp	x1, x22, [x20, #-24]
	ldur	x21, [x20, #-8]
	cmp	x1, #18
	b.eq	LBB87_3
LBB87_1:                                ; %B1
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x20, [x23, #48]
	bl	_JS_SetPropertyValue_GC
	tbnz	w0, #31, LBB87_7
; %bb.2:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB87_3:                                ; %B8
	ldr	w8, [x23, #44]
	tbnz	w8, #0, LBB87_5
; %bb.4:                                ; %B9
	ldr	x1, [x24, #208]
	b	LBB87_1
LBB87_5:                                ; %B5
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #48]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB87_7
; %bb.6:                                ; %B7
	mov	w1, w0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB87_7:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_define_var_0_asm_h     ; -- Begin function define_var_0_asm_h
	.globl	_define_var_0_asm_h
	.p2align	2
_define_var_0_asm_h:                    ; @define_var_0_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_DefineGlobalVar_GC
	tbnz	w0, #31, LBB88_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB88_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_check_define_var_0_asm_h ; -- Begin function check_define_var_0_asm_h
	.globl	_check_define_var_0_asm_h
	.p2align	2
_check_define_var_0_asm_h:              ; @check_define_var_0_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, LBB89_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB89_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_define_func_0_asm_h    ; -- Begin function define_func_0_asm_h
	.globl	_define_func_0_asm_h
	.p2align	2
_define_func_0_asm_h:                   ; @define_func_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	ldrb	w3, [x19, #4]
	str	x20, [x23, #48]
	mov	x2, x22
	bl	_JS_DefineGlobalFunction_GC
	tbnz	w0, #31, LBB90_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	sub	x20, x20, #8
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB90_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_field_0_asm_h      ; -- Begin function get_field_0_asm_h
	.globl	_get_field_0_asm_h
	.p2align	2
_get_field_0_asm_h:                     ; @get_field_0_asm_h
; %bb.0:                                ; %B24
	mov	x8, #2                          ; =0x2
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB91_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB91_2:                                ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB91_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB91_5
LBB91_3:                                ; %B1
                                        ;   Parent Loop BB91_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB91_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB91_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB91_3
LBB91_5:                                ; %B14
                                        ;   in Loop: Header=BB91_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB91_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB91_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB91_2
	b	LBB91_9
LBB91_7:                                ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB91_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB91_9:                                ; %B6
	ldrb	w9, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB91_10:                               ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB91_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB91_12:                               ; %B22
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_field2_0_asm_h     ; -- Begin function get_field2_0_asm_h
	.globl	_get_field2_0_asm_h
	.p2align	2
_get_field2_0_asm_h:                    ; @get_field2_0_asm_h
; %bb.0:                                ; %B24
	mov	x8, #2                          ; =0x2
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB92_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB92_2:                                ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB92_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB92_5
LBB92_3:                                ; %B1
                                        ;   Parent Loop BB92_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB92_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB92_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB92_3
LBB92_5:                                ; %B14
                                        ;   in Loop: Header=BB92_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB92_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB92_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB92_2
	b	LBB92_9
LBB92_7:                                ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB92_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB92_9:                                ; %B6
	ldrb	w9, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB92_10:                               ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB92_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB92_12:                               ; %B22
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_put_field_0_asm_h      ; -- Begin function put_field_0_asm_h
	.globl	_put_field_0_asm_h
	.p2align	2
_put_field_0_asm_h:                     ; @put_field_0_asm_h
; %bb.0:                                ; %B80
	sub	sp, sp, #32
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          ; =0x2
	mov	x12, x19
	movk	x8, #65535, lsl #48
	ldr	w19, [x19]
	tst	x22, x8
	b.ne	LBB93_25
; %bb.1:                                ; %B81
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w19, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB93_4
LBB93_2:                                ; %B1
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w19
	b.eq	LBB93_10
; %bb.3:                                ; %B12
                                        ;   in Loop: Header=BB93_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB93_2
LBB93_4:                                ; %B17.preheader
	mov	x8, x22
LBB93_5:                                ; %B17
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB93_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w19, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB93_8
LBB93_6:                                ; %B18
                                        ;   Parent Loop BB93_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w19
	b.eq	LBB93_13
; %bb.7:                                ; %B59
                                        ;   in Loop: Header=BB93_6 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB93_6
LBB93_8:                                ; %B66
                                        ;   in Loop: Header=BB93_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB93_25
; %bb.9:                                ; %B63
                                        ;   in Loop: Header=BB93_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB93_5
	b	LBB93_14
LBB93_10:                               ; %B3
	mov	w9, #58                         ; =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	LBB93_25
; %bb.11:                               ; %B38
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB93_24
LBB93_12:                               ; %B37
	ldrb	w8, [x12, #4]
	sub	x20, x20, #16
	add	x19, x12, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
LBB93_13:                               ; %B20
	mov	w8, #58                         ; =0x3a
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	LBB93_25
LBB93_14:                               ; %B23
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	LBB93_25
; %bb.15:                               ; %B25
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	LBB93_32
; %bb.16:                               ; %B25
	tbnz	w19, #31, LBB93_32
; %bb.17:                               ; %B54
	ldr	x13, [x22, #8]
	ldr	x14, [x13, #40]
	cbz	x14, LBB93_27
; %bb.18:                               ; %B32
	ldr	x8, [x22, #16]
	ldr	w9, [x14, #16]
	add	x10, x22, #32
	ldr	w11, [x13, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	LBB93_20
; %bb.19:                               ; %B32
	cbz	w8, LBB93_32
LBB93_20:                               ; %B42
	ldr	w8, [x13, #48]
	cmp	w8, w19
	b.ne	LBB93_27
; %bb.21:                               ; %B42
	ldrb	w8, [x13, #52]
	cmp	w8, #7
	b.ne	LBB93_27
LBB93_22:                               ; %B34
	ldr	w8, [x14]
	add	x9, x22, #8
	add	w8, w8, #1
	str	w8, [x14]
	ldr	w8, [x13]
	sub	w8, w8, #1
	str	w8, [x13]
	stlr	x14, [x9]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB93_30
LBB93_23:                               ; %B38
	ldr	w8, [x14, #20]
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #392]
	cbz	w8, LBB93_12
LBB93_24:                               ; %B40
	mov	x0, x21
	mov	x1, x24
	mov	x19, x12
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
LBB93_25:                               ; %B77
	mov	x0, x24
	mov	x1, x22
	mov	w2, w19
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x12, [sp, #24]                  ; 8-byte Folded Spill
	str	x20, [x23, #48]
	bl	_JS_SetPropertyInternalImpl_GC
	tbnz	w0, #31, LBB93_37
; %bb.26:                               ; %B79
	ldr	x19, [sp, #24]                  ; 8-byte Folded Reload
	sub	x20, x20, #16
	ldrb	w8, [x19, #4]
	ldr	x1, [x25, x8, lsl #3]
	add	x19, x19, #5
	add	sp, sp, #32
	br	x1
LBB93_27:                               ; %B47
	ldr	x0, [x24, #8]
	mov	x1, x13
	mov	w2, w19
	mov	w3, #7                          ; =0x7
	stp	x13, x20, [sp, #8]              ; 16-byte Folded Spill
	str	x12, [sp, #24]                  ; 8-byte Folded Spill
	bl	_find_hashed_shape_prop_gc
	ldp	x11, x20, [sp, #8]              ; 16-byte Folded Reload
	ldr	x12, [sp, #24]                  ; 8-byte Folded Reload
	cbz	x0, LBB93_32
; %bb.28:                               ; %B50
	ldr	x8, [x22, #16]
	ldr	w9, [x0, #16]
	add	x10, x22, #32
	ldr	w11, [x11, #16]
	mov	x14, x0
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	LBB93_31
; %bb.29:
	ldp	x20, x12, [sp, #16]             ; 16-byte Folded Reload
	ldr	x13, [sp, #8]                   ; 8-byte Folded Reload
	b	LBB93_22
LBB93_30:                               ; %B41
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	mov	x19, x12
	orr	x0, x14, x8
	str	x14, [sp, #16]                  ; 8-byte Folded Spill
	bl	_prim_WriteBarrierNoStore
	ldr	x14, [sp, #16]                  ; 8-byte Folded Reload
	mov	x12, x19
	b	LBB93_23
LBB93_31:                               ; %B50
	ldp	x20, x12, [sp, #16]             ; 16-byte Folded Reload
	ldr	x13, [sp, #8]                   ; 8-byte Folded Reload
	cbnz	w8, LBB93_22
LBB93_32:                               ; %B70
	mov	x0, x24
	mov	x1, x22
	mov	w2, w19
	mov	w3, #7                          ; =0x7
	stp	x20, x12, [sp, #16]             ; 16-byte Folded Spill
	str	x20, [x23, #48]
	bl	_add_property_gc
	cbz	x0, LBB93_36
; %bb.33:                               ; %B74
	str	x21, [x0]
	ldrb	w8, [x24, #392]
	cbz	w8, LBB93_35
; %bb.34:                               ; %B76
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
LBB93_35:                               ; %B73
	ldr	x19, [sp, #24]                  ; 8-byte Folded Reload
	ldrb	w8, [x19, #4]
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #16]                   ; 8-byte Folded Reload
	sub	x20, x8, #16
	add	x19, x19, #5
	add	sp, sp, #32
	br	x1
LBB93_36:                               ; %B71
	ldr	x8, [sp, #16]                   ; 8-byte Folded Reload
	sub	x20, x8, #16
LBB93_37:                               ; %B78
	ldr	x19, [sp, #24]                  ; 8-byte Folded Reload
	add	sp, sp, #32
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_private_field_0_asm_h ; -- Begin function get_private_field_0_asm_h
	.globl	_get_private_field_0_asm_h
	.p2align	2
_get_private_field_0_asm_h:             ; @get_private_field_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	_JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	LBB94_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB94_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_put_private_field_0_asm_h ; -- Begin function put_private_field_0_asm_h
	.globl	_put_private_field_0_asm_h
	.p2align	2
_put_private_field_0_asm_h:             ; @put_private_field_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	str	x20, [x23, #48]
	mov	x2, x21
	mov	x3, x22
	bl	_JS_SetPrivateField_GC
	tbnz	w0, #31, LBB95_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB95_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_define_private_field_0_asm_h ; -- Begin function define_private_field_0_asm_h
	.globl	_define_private_field_0_asm_h
	.p2align	2
_define_private_field_0_asm_h:          ; @define_private_field_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	str	x20, [x23, #48]
	mov	x2, x22
	mov	x3, x21
	bl	_JS_DefinePrivateField_GC
	tbnz	w0, #31, LBB96_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB96_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_array_el_0_asm_h   ; -- Begin function get_array_el_0_asm_h
	.globl	_get_array_el_0_asm_h
	.p2align	2
_get_array_el_0_asm_h:                  ; @get_array_el_0_asm_h
; %bb.0:                                ; %B72
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB97_7
; %bb.1:                                ; %B72
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x8, x9
	b.ne	LBB97_7
; %bb.2:                                ; %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	LBB97_5
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB97_9
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB97_5:                                ; %B30
	sxth	w9, w8
	cmp	w9, #21
	b.lt	LBB97_7
; %bb.6:                                ; %B30
	cmp	w9, #29
	b.le	LBB97_19
LBB97_7:                                ; %B69
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB97_24
; %bb.8:                                ; %B71
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB97_9:                                ; %B7
	tbnz	w21, #31, LBB97_7
; %bb.10:                               ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB97_11:                               ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB97_12 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB97_14
LBB97_12:                               ; %B10
                                        ;   Parent Loop BB97_11 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB97_16
; %bb.13:                               ; %B17
                                        ;   in Loop: Header=BB97_12 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB97_12
LBB97_14:                               ; %B24
                                        ;   in Loop: Header=BB97_11 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB97_7
; %bb.15:                               ; %B21
                                        ;   in Loop: Header=BB97_11 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB97_11
	b	LBB97_18
LBB97_16:                               ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB97_7
; %bb.17:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB97_18:                               ; %B36
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB97_19:                               ; %B32
	ldr	w9, [x22, #48]
	cmp	w21, w9
	b.hs	LBB97_7
; %bb.20:                               ; %B34
	ldr	x9, [x22, #40]
	cmp	w8, #23
	b.ge	LBB97_25
; %bb.21:                               ; %B34
	cmp	w8, #21
	b.eq	LBB97_26
; %bb.22:                               ; %B34
	cmp	w8, #22
	b.ne	LBB97_7
; %bb.23:                               ; %B35
	ldrsb	w8, [x9, w21, sxtw]
	b	LBB97_38
LBB97_24:                               ; %B70
	b	_exception_asm_h
LBB97_25:                               ; %B34
	b.gt	LBB97_27
LBB97_26:                               ; %B39
	ldrb	w8, [x9, w21, sxtw]
	b	LBB97_38
LBB97_27:                               ; %B34
	cmp	w8, #25
	b.gt	LBB97_31
; %bb.28:                               ; %B34
	cmp	w8, #24
	b.eq	LBB97_35
; %bb.29:                               ; %B34
	cmp	w8, #25
	b.ne	LBB97_7
; %bb.30:                               ; %B45
	ldrh	w8, [x9, w21, sxtw #1]
	b	LBB97_38
LBB97_31:                               ; %B34
	cmp	w8, #26
	b.eq	LBB97_36
; %bb.32:                               ; %B34
	cmp	w8, #27
	b.eq	LBB97_37
; %bb.33:                               ; %B34
	cmp	w8, #29
	b.ne	LBB97_7
; %bb.34:                               ; %B62
	ldr	d0, [x9, w21, sxtw #3]
	b	LBB97_40
LBB97_35:                               ; %B42
	ldrsh	w8, [x9, w21, sxtw #1]
	b	LBB97_38
LBB97_36:                               ; %B48
	ldr	w8, [x9, w21, sxtw #2]
	b	LBB97_38
LBB97_37:                               ; %B56
	ldr	w8, [x9, w21, sxtw #2]
	tbnz	w8, #31, LBB97_39
LBB97_38:                               ; %B36
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB97_39:                               ; %B52
	ucvtf	d0, w8
LBB97_40:                               ; %B36
	fmov	x8, d0
	fcmp	d0, d0
	mov	x9, #562949953421312            ; =0x2000000000000
	add	x8, x8, x9
	mov	x9, #9221683186994511872        ; =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_array_el2_0_asm_h  ; -- Begin function get_array_el2_0_asm_h
	.globl	_get_array_el2_0_asm_h
	.p2align	2
_get_array_el2_0_asm_h:                 ; @get_array_el2_0_asm_h
; %bb.0:                                ; %B72
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB98_7
; %bb.1:                                ; %B72
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x8, x9
	b.ne	LBB98_7
; %bb.2:                                ; %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	LBB98_5
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB98_9
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #16
	add	w8, w8, #486
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB98_5:                                ; %B30
	sxth	w9, w8
	cmp	w9, #21
	b.lt	LBB98_7
; %bb.6:                                ; %B30
	cmp	w9, #29
	b.le	LBB98_19
LBB98_7:                                ; %B69
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB98_24
; %bb.8:                                ; %B71
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB98_9:                                ; %B7
	tbnz	w21, #31, LBB98_7
; %bb.10:                               ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB98_11:                               ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB98_12 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB98_14
LBB98_12:                               ; %B10
                                        ;   Parent Loop BB98_11 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB98_16
; %bb.13:                               ; %B17
                                        ;   in Loop: Header=BB98_12 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB98_12
LBB98_14:                               ; %B24
                                        ;   in Loop: Header=BB98_11 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB98_7
; %bb.15:                               ; %B21
                                        ;   in Loop: Header=BB98_11 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB98_11
	b	LBB98_18
LBB98_16:                               ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB98_7
; %bb.17:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB98_18:                               ; %B36
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB98_19:                               ; %B32
	ldr	w9, [x22, #48]
	cmp	w21, w9
	b.hs	LBB98_7
; %bb.20:                               ; %B34
	ldr	x9, [x22, #40]
	cmp	w8, #23
	b.ge	LBB98_25
; %bb.21:                               ; %B34
	cmp	w8, #21
	b.eq	LBB98_26
; %bb.22:                               ; %B34
	cmp	w8, #22
	b.ne	LBB98_7
; %bb.23:                               ; %B35
	ldrsb	w8, [x9, w21, sxtw]
	b	LBB98_38
LBB98_24:                               ; %B70
	b	_exception_asm_h
LBB98_25:                               ; %B34
	b.gt	LBB98_27
LBB98_26:                               ; %B39
	ldrb	w8, [x9, w21, sxtw]
	b	LBB98_38
LBB98_27:                               ; %B34
	cmp	w8, #25
	b.gt	LBB98_31
; %bb.28:                               ; %B34
	cmp	w8, #24
	b.eq	LBB98_35
; %bb.29:                               ; %B34
	cmp	w8, #25
	b.ne	LBB98_7
; %bb.30:                               ; %B45
	ldrh	w8, [x9, w21, sxtw #1]
	b	LBB98_38
LBB98_31:                               ; %B34
	cmp	w8, #26
	b.eq	LBB98_36
; %bb.32:                               ; %B34
	cmp	w8, #27
	b.eq	LBB98_37
; %bb.33:                               ; %B34
	cmp	w8, #29
	b.ne	LBB98_7
; %bb.34:                               ; %B62
	ldr	d0, [x9, w21, sxtw #3]
	b	LBB98_40
LBB98_35:                               ; %B42
	ldrsh	w8, [x9, w21, sxtw #1]
	b	LBB98_38
LBB98_36:                               ; %B48
	ldr	w8, [x9, w21, sxtw #2]
	b	LBB98_38
LBB98_37:                               ; %B56
	ldr	w8, [x9, w21, sxtw #2]
	tbnz	w8, #31, LBB98_39
LBB98_38:                               ; %B36
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB98_39:                               ; %B52
	ucvtf	d0, w8
LBB98_40:                               ; %B36
	fmov	x8, d0
	fcmp	d0, d0
	mov	x9, #562949953421312            ; =0x2000000000000
	add	x8, x8, x9
	mov	x9, #9221683186994511872        ; =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_array_el_0_asm_h   ; -- Begin function put_array_el_0_asm_h
	.globl	_put_array_el_0_asm_h
	.p2align	2
_put_array_el_0_asm_h:                  ; @put_array_el_0_asm_h
; %bb.0:                                ; %B100
	ldp	x1, x22, [x20, #-24]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	ldur	x21, [x20, #-8]
	tst	x1, x8
	b.ne	LBB99_40
; %bb.1:                                ; %B94
	ldrh	w9, [x1, #6]
	cmp	w9, #2
	b.ne	LBB99_6
; %bb.2:                                ; %B1
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB99_40
; %bb.3:                                ; %B46
	ldr	w8, [x1, #48]
	cmp	w22, w8
	b.hs	LBB99_13
; %bb.4:                                ; %B3
	ldr	x8, [x1, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB99_22
LBB99_5:                                ; %B58
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB99_6:                                ; %B97
	sxth	w8, w9
	mov	w4, #32768                      ; =0x8000
	cmp	w8, #21
	b.lt	LBB99_41
; %bb.7:                                ; %B97
	cmp	w8, #29
	b.gt	LBB99_41
; %bb.8:                                ; %B50
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB99_36
; %bb.9:                                ; %B52
	ldr	w8, [x1, #48]
	cmp	w22, w8
	b.hs	LBB99_36
; %bb.10:                               ; %B54
	sub	w10, w9, #22
	ldr	x8, [x1, #40]
	cmp	w10, #2
	b.hs	LBB99_23
; %bb.11:                               ; %B64
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	LBB99_36
; %bb.12:                               ; %B65
	strb	w21, [x8, w22, sxtw]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB99_13:                               ; %B8
	b.ne	LBB99_37
; %bb.14:                               ; %B36
	ldr	w9, [x1, #4]
	mov	w4, #32768                      ; =0x8000
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	b.ne	LBB99_41
; %bb.15:                               ; %B36
	ubfx	w9, w9, #8, #1
	cbz	w9, LBB99_41
; %bb.16:                               ; %B10
	ldr	x9, [x1, #8]
	ldr	x9, [x9, #32]
	cbz	x9, LBB99_18
; %bb.17:                               ; %B32
	ldr	w9, [x9, #4]
	ubfx	w9, w9, #13, #1
	cmp	w9, #1
	b.ne	LBB99_41
LBB99_18:                               ; %B28
	ldr	x9, [x1, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	LBB99_20
; %bb.19:                               ; %B28
	cmp	w9, w10
	b.hi	LBB99_43
LBB99_20:                               ; %B25
	ldr	w10, [x1, #32]
	cmp	w9, w10
	b.hi	LBB99_43
; %bb.21:                               ; %B21
	ldr	x10, [x1, #40]
	str	w9, [x1, #48]
	str	x21, [x10, w8, sxtw #3]
	ldrb	w8, [x24, #392]
	cbz	w8, LBB99_5
LBB99_22:                               ; %B24
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB99_23:                               ; %B54
	cmp	w9, #25
	mov	w4, wzr
	b.gt	LBB99_27
; %bb.24:                               ; %B54
	sub	w10, w9, #24
	cmp	w10, #2
	b.hs	LBB99_30
; %bb.25:                               ; %B70
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	LBB99_36
; %bb.26:                               ; %B71
	strh	w21, [x8, w22, sxtw #1]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB99_27:                               ; %B54
	sub	w10, w9, #26
	cmp	w10, #2
	b.hs	LBB99_33
; %bb.28:                               ; %B76
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	LBB99_36
; %bb.29:                               ; %B77
	str	w21, [x8, w22, sxtw #2]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB99_30:                               ; %B54
	cmp	w9, #21
	b.ne	LBB99_41
; %bb.31:                               ; %B56
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	LBB99_36
; %bb.32:                               ; %B57
	cmp	w21, #255
	mov	w9, #255                        ; =0xff
	csel	w9, w21, w9, lt
	bic	w9, w9, w9, asr #31
	strb	w9, [x8, w22, sxtw]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB99_33:                               ; %B54
	cmp	w9, #29
	b.ne	LBB99_41
; %bb.34:                               ; %B82
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	LBB99_45
; %bb.35:                               ; %B83
	scvtf	d0, w21
	str	d0, [x8, w22, sxtw #3]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB99_36:
	mov	w4, wzr
	b	LBB99_41
LBB99_37:                               ; %B40
	tbnz	w22, #31, LBB99_40
; %bb.38:                               ; %B42
	mov	x0, x24
	mov	w2, w22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x20, [x23, #48]
	bl	_JS_SetArrayIntPropertyValue_GC
	tbz	w0, #31, LBB99_5
; %bb.39:                               ; %B43
	b	_exception_asm_h
LBB99_40:
	mov	w4, #32768                      ; =0x8000
LBB99_41:                               ; %B91
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	str	x20, [x23, #48]
	bl	_JS_SetPropertyValue_GC
	tbz	w0, #31, LBB99_5
; %bb.42:                               ; %B92
	b	_exception_asm_h
LBB99_43:                               ; %B16
	mov	x0, x24
	mov	x2, x21
	mov	w3, #32768                      ; =0x8000
	str	x20, [x23, #48]
	bl	_add_fast_array_element_gc
	tbz	w0, #31, LBB99_5
; %bb.44:                               ; %B17
	b	_exception_asm_h
LBB99_45:                               ; %B85
	and	x9, x21, #0xfffe000000000000
	mov	x10, #-562949953421312          ; =0xfffe000000000000
	mov	w4, wzr
	cmp	x9, x10
	b.eq	LBB99_41
; %bb.46:                               ; %B85
	cbz	x9, LBB99_41
; %bb.47:                               ; %B86
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	add	x9, x21, x9
	str	x9, [x8, w22, sxtw #3]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_super_value_0_asm_h ; -- Begin function get_super_value_0_asm_h
	.globl	_get_super_value_0_asm_h
	.p2align	2
_get_super_value_0_asm_h:               ; @get_super_value_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x21
	bl	_js_value_to_atom_gc
	cbz	w0, LBB100_3
; %bb.1:                                ; %B5
	ldur	x3, [x20, #-24]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB100_3
; %bb.2:                                ; %B7
	stur	x0, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB100_3:                               ; %B6
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_put_super_value_0_asm_h ; -- Begin function put_super_value_0_asm_h
	.globl	_put_super_value_0_asm_h
	.p2align	2
_put_super_value_0_asm_h:               ; @put_super_value_0_asm_h
; %bb.0:                                ; %B8
	sub	sp, sp, #16
	ldur	x9, [x20, #-24]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x9, x8
	b.eq	LBB101_3
; %bb.1:                                ; %B10
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ThrowTypeErrorNotAnObject
LBB101_2:                               ; %B6
	add	sp, sp, #16
	b	_exception_asm_h
LBB101_3:                               ; %B1
	ldur	x1, [x20, #-16]
	mov	x0, x24
	str	x9, [sp, #8]                    ; 8-byte Folded Spill
	str	x20, [x23, #48]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB101_2
; %bb.4:                                ; %B5
	ldur	x3, [x20, #-8]
	ldur	x4, [x20, #-32]
	mov	w2, w0
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, x24
	mov	w5, #32768                      ; =0x8000
	str	x20, [x23, #48]
	bl	_JS_SetPropertyGeneric_GC
	tbnz	w0, #31, LBB101_2
; %bb.5:                                ; %B7
	ldrb	w8, [x19], #1
	sub	x20, x20, #32
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
                                        ; -- End function
	.private_extern	_define_field_0_asm_h   ; -- Begin function define_field_0_asm_h
	.globl	_define_field_0_asm_h
	.p2align	2
_define_field_0_asm_h:                  ; @define_field_0_asm_h
; %bb.0:                                ; %B58
	sub	sp, sp, #32
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	ldr	w2, [x19]
	tst	x22, x8
	b.ne	LBB102_4
; %bb.1:                                ; %B55
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	LBB102_4
; %bb.2:                                ; %B49
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB102_4
; %bb.3:                                ; %B52
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.eq	LBB102_6
LBB102_4:                               ; %B46
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #16391                      ; =0x4007
	str	x20, [x23, #48]
	bl	_JS_DefinePropertyValue_GC
	tbnz	w0, #31, LBB102_17
LBB102_5:                               ; %B4
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #32
	br	x1
LBB102_6:                               ; %B53
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB102_9
LBB102_7:                               ; %B35
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB102_18
; %bb.8:                                ; %B37
                                        ;   in Loop: Header=BB102_7 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB102_7
LBB102_9:                               ; %B40
	tbnz	w2, #31, LBB102_4
; %bb.10:                               ; %B11
	ldr	x8, [x22, #8]
	str	x8, [sp, #24]                   ; 8-byte Folded Spill
	ldr	x8, [x8, #40]
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	cbz	x8, LBB102_21
; %bb.11:                               ; %B15
	ldp	x9, x11, [sp, #16]              ; 16-byte Folded Reload
	add	x10, x22, #32
	ldr	x8, [x22, #16]
	ldr	w9, [x9, #16]
	ldr	w11, [x11, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	LBB102_13
; %bb.12:                               ; %B15
	cbz	w8, LBB102_4
LBB102_13:                              ; %B17
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	ldr	w8, [x8, #48]
	cmp	w8, w2
	b.ne	LBB102_21
; %bb.14:                               ; %B17
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	ldrb	w8, [x8, #52]
	cmp	w8, #7
	b.ne	LBB102_21
LBB102_15:                              ; %B25
	ldp	x11, x10, [sp, #16]             ; 16-byte Folded Reload
	add	x9, x22, #8
	ldr	w8, [x11]
	add	w8, w8, #1
	str	w8, [x11]
	ldr	w8, [x10]
	sub	w8, w8, #1
	str	w8, [x10]
	stlr	x11, [x9]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB102_24
LBB102_16:                              ; %B22
	ldr	x8, [sp, #16]                   ; 8-byte Folded Reload
	ldr	w8, [x8, #20]
	b	LBB102_19
LBB102_17:                              ; %B47
	add	sp, sp, #32
	b	_exception_asm_h
LBB102_18:                              ; %B1
	lsr	w9, w10, #26
	and	w9, w9, #0xfffffff7
	cmp	w9, #7
	b.ne	LBB102_4
LBB102_19:                              ; %B22
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #392]
	cbz	w8, LBB102_5
; %bb.20:
	mov	x1, x24
	mov	x0, x21
	bl	_prim_WriteBarrierNoStore
	b	LBB102_5
LBB102_21:                              ; %B43
	ldr	x0, [x24, #8]
	ldr	x1, [sp, #24]                   ; 8-byte Folded Reload
	mov	w3, #7                          ; =0x7
	str	w2, [sp, #12]                   ; 4-byte Folded Spill
	bl	_find_hashed_shape_prop_gc
	ldr	w2, [sp, #12]                   ; 4-byte Folded Reload
	cbz	x0, LBB102_4
; %bb.22:                               ; %B30
	ldr	x8, [x22, #16]
	ldr	x11, [sp, #24]                  ; 8-byte Folded Reload
	add	x10, x22, #32
	ldr	w9, [x0, #16]
	ldr	w11, [x11, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	LBB102_25
; %bb.23:
	str	x0, [sp, #16]                   ; 8-byte Folded Spill
	b	LBB102_15
LBB102_24:                              ; %B27
	ldr	x9, [sp, #16]                   ; 8-byte Folded Reload
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	_prim_WriteBarrierNoStore
	b	LBB102_16
LBB102_25:                              ; %B30
	ldr	w2, [sp, #12]                   ; 4-byte Folded Reload
	str	x0, [sp, #16]                   ; 8-byte Folded Spill
	cbnz	w8, LBB102_15
	b	LBB102_4
                                        ; -- End function
	.private_extern	_set_name_0_asm_h       ; -- Begin function set_name_0_asm_h
	.globl	_set_name_0_asm_h
	.p2align	2
_set_name_0_asm_h:                      ; @set_name_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	mov	x1, x22
	bl	_JS_DefineObjectName
	tbnz	w0, #31, LBB103_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB103_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_set_name_computed_0_asm_h ; -- Begin function set_name_computed_0_asm_h
	.globl	_set_name_computed_0_asm_h
	.p2align	2
_set_name_computed_0_asm_h:             ; @set_name_computed_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	mov	x1, x21
	mov	x2, x22
	bl	_JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, LBB104_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB104_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_set_proto_0_asm_h      ; -- Begin function set_proto_0_asm_h
	.globl	_set_proto_0_asm_h
	.p2align	2
_set_proto_0_asm_h:                     ; @set_proto_0_asm_h
; %bb.0:                                ; %B6
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	LBB105_3
; %bb.1:                                ; %B6
	cmp	x21, #2
	b.eq	LBB105_3
LBB105_2:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB105_3:                               ; %B1
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	_JS_SetPrototypeInternal_GC
	tbz	w0, #31, LBB105_2
; %bb.4:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_set_home_object_0_asm_h ; -- Begin function set_home_object_0_asm_h
	.globl	_set_home_object_0_asm_h
	.p2align	2
_set_home_object_0_asm_h:               ; @set_home_object_0_asm_h
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
	.private_extern	_define_array_el_0_asm_h ; -- Begin function define_array_el_0_asm_h
	.globl	_define_array_el_0_asm_h
	.p2align	2
_define_array_el_0_asm_h:               ; @define_array_el_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	mov	w4, #16391                      ; =0x4007
	str	x20, [x23, #48]
	mov	x2, x22
	mov	x3, x21
	bl	_JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, LBB107_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB107_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_append_0_asm_h         ; -- Begin function append_0_asm_h
	.globl	_append_0_asm_h
	.p2align	2
_append_0_asm_h:                        ; @append_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_js_append_enumerate_gc
	tbnz	w0, #31, LBB108_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB108_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_copy_data_properties_0_asm_h ; -- Begin function copy_data_properties_0_asm_h
	.globl	_copy_data_properties_0_asm_h
	.p2align	2
_copy_data_properties_0_asm_h:          ; @copy_data_properties_0_asm_h
; %bb.0:                                ; %B1
	ldrb	w2, [x19]
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_prim_js_copy_data_properties_gc
	tbnz	w0, #31, LBB109_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB109_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_define_method_0_asm_h  ; -- Begin function define_method_0_asm_h
	.globl	_define_method_0_asm_h
	.p2align	2
_define_method_0_asm_h:                 ; @define_method_0_asm_h
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
	b.eq	LBB110_3
; %bb.1:                                ; %B15
	cmp	w8, #1
	b.ne	LBB110_4
; %bb.2:                                ; %B13
	mov	w8, #18                         ; =0x12
	mov	w11, #2048                      ; =0x800
	stp	x12, x8, [sp, #16]              ; 16-byte Folded Spill
	b	LBB110_5
LBB110_3:
	mov	w8, #18                         ; =0x12
	str	x12, [sp, #40]                  ; 8-byte Folded Spill
	mov	w11, #8706                      ; =0x2202
	str	x8, [sp, #24]                   ; 8-byte Folded Spill
	mov	w8, #18                         ; =0x12
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	b	LBB110_6
LBB110_4:                               ; %B14
	mov	w11, #4096                      ; =0x1000
	mov	w8, #18                         ; =0x12
	stp	x8, x12, [sp, #16]              ; 16-byte Folded Spill
LBB110_5:                               ; %B10
	mov	w8, #18                         ; =0x12
	str	x8, [sp, #40]                   ; 8-byte Folded Spill
LBB110_6:                               ; %B10
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
	tbnz	w0, #31, LBB110_9
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
	tbnz	w0, #31, LBB110_9
; %bb.8:                                ; %B7
	ldr	x9, [sp, #48]                   ; 8-byte Folded Reload
	ldrb	w8, [x9, #5]
	add	x19, x9, #6
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #64
	br	x1
LBB110_9:                               ; %B2
	ldp	x19, x20, [sp, #48]             ; 16-byte Folded Reload
	add	sp, sp, #64
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_define_method_computed_0_asm_h ; -- Begin function define_method_computed_0_asm_h
	.globl	_define_method_computed_0_asm_h
	.p2align	2
_define_method_computed_0_asm_h:        ; @define_method_computed_0_asm_h
; %bb.0:                                ; %B8
	sub	sp, sp, #64
	ldur	x1, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_js_value_to_atom_gc
	mov	w11, w0
	cbz	w11, LBB111_11
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
	b.eq	LBB111_4
; %bb.2:                                ; %B11
	cmp	w8, #1
	b.ne	LBB111_5
; %bb.3:                                ; %B19
	mov	w8, #18                         ; =0x12
	mov	w13, #2048                      ; =0x800
	stp	x10, x8, [sp, #16]              ; 16-byte Folded Spill
	b	LBB111_6
LBB111_4:
	mov	w8, #18                         ; =0x12
	str	x10, [sp, #40]                  ; 8-byte Folded Spill
	mov	w13, #8706                      ; =0x2202
	str	x8, [sp, #24]                   ; 8-byte Folded Spill
	mov	w8, #18                         ; =0x12
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	b	LBB111_7
LBB111_5:                               ; %B20
	mov	w13, #4096                      ; =0x1000
	mov	w8, #18                         ; =0x12
	stp	x8, x10, [sp, #16]              ; 16-byte Folded Spill
LBB111_6:                               ; %B16
	mov	w8, #18                         ; =0x12
	str	x8, [sp, #40]                   ; 8-byte Folded Spill
LBB111_7:                               ; %B16
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
	tbnz	w0, #31, LBB111_10
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
	tbnz	w0, #31, LBB111_10
; %bb.9:                                ; %B7
	ldr	x9, [sp, #48]                   ; 8-byte Folded Reload
	ldrb	w8, [x9, #1]
	add	x19, x9, #2
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #64
	br	x1
LBB111_10:                              ; %B2
	ldp	x19, x20, [sp, #48]             ; 16-byte Folded Reload
LBB111_11:                              ; %B9
	add	sp, sp, #64
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_define_class_0_asm_h   ; -- Begin function define_class_0_asm_h
	.globl	_define_class_0_asm_h
	.p2align	2
_define_class_0_asm_h:                  ; @define_class_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #4]
	mov	x0, x24
	mov	x1, x20
	mov	x4, x26
	mov	x5, x23
	str	x20, [x23, #48]
	bl	_js_op_define_class
	tbnz	w0, #31, LBB112_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB112_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_loc_0_asm_h        ; -- Begin function get_loc_0_asm_h
	.globl	_get_loc_0_asm_h
	.p2align	2
_get_loc_0_asm_h:                       ; @get_loc_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #243
	ldr	x22, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_loc_0_asm_h        ; -- Begin function put_loc_0_asm_h
	.globl	_put_loc_0_asm_h
	.p2align	2
_put_loc_0_asm_h:                       ; @put_loc_0_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc_0_asm_h        ; -- Begin function set_loc_0_asm_h
	.globl	_set_loc_0_asm_h
	.p2align	2
_set_loc_0_asm_h:                       ; @set_loc_0_asm_h
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
	.private_extern	_get_arg_0_asm_h        ; -- Begin function get_arg_0_asm_h
	.globl	_get_arg_0_asm_h
	.p2align	2
_get_arg_0_asm_h:                       ; @get_arg_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #243
	ldr	x22, [x28, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_arg_0_asm_h        ; -- Begin function put_arg_0_asm_h
	.globl	_put_arg_0_asm_h
	.p2align	2
_put_arg_0_asm_h:                       ; @put_arg_0_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_arg_0_asm_h        ; -- Begin function set_arg_0_asm_h
	.globl	_set_arg_0_asm_h
	.p2align	2
_set_arg_0_asm_h:                       ; @set_arg_0_asm_h
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
	.private_extern	_get_var_ref_0_asm_h    ; -- Begin function get_var_ref_0_asm_h
	.globl	_get_var_ref_0_asm_h
	.p2align	2
_get_var_ref_0_asm_h:                   ; @get_var_ref_0_asm_h
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
	.private_extern	_put_var_ref_0_asm_h    ; -- Begin function put_var_ref_0_asm_h
	.globl	_put_var_ref_0_asm_h
	.p2align	2
_put_var_ref_0_asm_h:                   ; @put_var_ref_0_asm_h
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
	.private_extern	_set_var_ref_0_asm_h    ; -- Begin function set_var_ref_0_asm_h
	.globl	_set_var_ref_0_asm_h
	.p2align	2
_set_var_ref_0_asm_h:                   ; @set_var_ref_0_asm_h
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
	.private_extern	_set_loc_uninitialized_0_asm_h ; -- Begin function set_loc_uninitialized_0_asm_h
	.globl	_set_loc_uninitialized_0_asm_h
	.p2align	2
_set_loc_uninitialized_0_asm_h:         ; @set_loc_uninitialized_0_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	mov	w9, #34                         ; =0x22
	str	x9, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_loc_check_0_asm_h  ; -- Begin function get_loc_check_0_asm_h
	.globl	_get_loc_check_0_asm_h
	.p2align	2
_get_loc_check_0_asm_h:                 ; @get_loc_check_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	LBB123_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB123_2:                               ; %B3
	b	_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.private_extern	_put_loc_check_0_asm_h  ; -- Begin function put_loc_check_0_asm_h
	.globl	_put_loc_check_0_asm_h
	.p2align	2
_put_loc_check_0_asm_h:                 ; @put_loc_check_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	LBB124_2
; %bb.1:                                ; %B4
	str	x22, [x27, w8, uxtw #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB124_2:                               ; %B3
	b	_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.private_extern	_put_loc_check_init_0_asm_h ; -- Begin function put_loc_check_init_0_asm_h
	.globl	_put_loc_check_init_0_asm_h
	.p2align	2
_put_loc_check_init_0_asm_h:            ; @put_loc_check_init_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	LBB125_2
; %bb.1:                                ; %B4
	str	x22, [x27, w8, uxtw #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB125_2:                               ; %B3
	b	_ThrowThisReferenceError_asm_h
                                        ; -- End function
	.private_extern	_get_var_ref_check_0_asm_h ; -- Begin function get_var_ref_check_0_asm_h
	.globl	_get_var_ref_check_0_asm_h
	.p2align	2
_get_var_ref_check_0_asm_h:             ; @get_var_ref_check_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	LBB126_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB126_2:                               ; %B3
	b	_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.private_extern	_put_var_ref_check_0_asm_h ; -- Begin function put_var_ref_check_0_asm_h
	.globl	_put_var_ref_check_0_asm_h
	.p2align	2
_put_var_ref_check_0_asm_h:             ; @put_var_ref_check_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	LBB127_2
; %bb.1:                                ; %B4
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB127_2:                               ; %B3
	b	_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.private_extern	_put_var_ref_check_init_0_asm_h ; -- Begin function put_var_ref_check_init_0_asm_h
	.globl	_put_var_ref_check_init_0_asm_h
	.p2align	2
_put_var_ref_check_init_0_asm_h:        ; @put_var_ref_check_init_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	LBB128_2
; %bb.1:                                ; %B4
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB128_2:                               ; %B3
	b	_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.private_extern	_close_loc_0_asm_h      ; -- Begin function close_loc_0_asm_h
	.globl	_close_loc_0_asm_h
	.p2align	2
_close_loc_0_asm_h:                     ; @close_loc_0_asm_h
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
	.private_extern	_if_false_0_asm_h       ; -- Begin function if_false_0_asm_h
	.globl	_if_false_0_asm_h
	.p2align	2
_if_false_0_asm_h:                      ; @if_false_0_asm_h
; %bb.0:                                ; %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	LBB130_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB130_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB130_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB130_6
	b	LBB130_7
LBB130_4:                               ; %B23
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.eq	LBB130_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB130_7
LBB130_6:                               ; %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB130_7:                               ; %B9
	mov	x9, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x9
	b.hs	LBB130_13
; %bb.8:                                ; %B11
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.lo	LBB130_10
LBB130_9:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB130_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB130_13
; %bb.11:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB130_6
	b.vs	LBB130_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB130_9
	b	LBB130_6
LBB130_13:                              ; %B15
	mov	x20, x8
	mov	x0, x22
	b	_SlowToBoolean_asm_h
                                        ; -- End function
	.private_extern	_if_true_0_asm_h        ; -- Begin function if_true_0_asm_h
	.globl	_if_true_0_asm_h
	.p2align	2
_if_true_0_asm_h:                       ; @if_true_0_asm_h
; %bb.0:                                ; %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	LBB131_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB131_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB131_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB131_6
	b	LBB131_7
LBB131_4:                               ; %B23
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.eq	LBB131_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB131_7
LBB131_6:                               ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB131_7:                               ; %B9
	mov	x9, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x9
	b.hs	LBB131_13
; %bb.8:                                ; %B11
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.lo	LBB131_10
LBB131_9:                               ; %B19
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB131_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB131_13
; %bb.11:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB131_6
	b.vs	LBB131_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB131_9
	b	LBB131_6
LBB131_13:                              ; %B15
	mov	x20, x8
	mov	x0, x22
	b	_SlowToBoolean_asm_h
                                        ; -- End function
	.private_extern	_goto_0_asm_h           ; -- Begin function goto_0_asm_h
	.globl	_goto_0_asm_h
	.p2align	2
_goto_0_asm_h:                          ; @goto_0_asm_h
; %bb.0:                                ; %B0
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_catch_0_asm_h          ; -- Begin function catch_0_asm_h
	.globl	_catch_0_asm_h
	.p2align	2
_catch_0_asm_h:                         ; @catch_0_asm_h
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
	.private_extern	_gosub_0_asm_h          ; -- Begin function gosub_0_asm_h
	.globl	_gosub_0_asm_h
	.p2align	2
_gosub_0_asm_h:                         ; @gosub_0_asm_h
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
	.private_extern	_ret_0_asm_h            ; -- Begin function ret_0_asm_h
	.globl	_ret_0_asm_h
	.p2align	2
_ret_0_asm_h:                           ; @ret_0_asm_h
; %bb.0:                                ; %B6
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB135_3
; %bb.1:                                ; %B1
	ldr	x8, [x23, #8]
	ldr	x8, [x8, #32]
	ldr	w9, [x8, #16]
	cmp	w22, w9
	b.ge	LBB135_3
; %bb.2:                                ; %B5
	ldr	x8, [x8, #8]
	sub	x20, x20, #8
	add	x19, x8, w22, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB135_3:                               ; %B3
Lloh16:
	adrp	x1, l___unnamed_8@PAGE
Lloh17:
	add	x1, x1, l___unnamed_8@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_ThrowInternalError
	b	_exception_asm_h
	.loh AdrpAdd	Lloh16, Lloh17
                                        ; -- End function
	.private_extern	_to_object_0_asm_h      ; -- Begin function to_object_0_asm_h
	.globl	_to_object_0_asm_h
	.p2align	2
_to_object_0_asm_h:                     ; @to_object_0_asm_h
; %bb.0:                                ; %B6
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB136_2
; %bb.1:                                ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB136_2:                               ; %B1
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #48]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB136_4
; %bb.3:                                ; %B3
	mov	x22, x0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB136_4:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_to_propkey_0_asm_h     ; -- Begin function to_propkey_0_asm_h
	.globl	_to_propkey_0_asm_h
	.p2align	2
_to_propkey_0_asm_h:                    ; @to_propkey_0_asm_h
; %bb.0:                                ; %B15
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	LBB137_4
; %bb.1:                                ; %B15
	mov	x9, #1                          ; =0x1
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB137_4
; %bb.2:                                ; %B15
	cmp	x8, x9
	b.eq	LBB137_4
; %bb.3:                                ; %B15
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB137_5
LBB137_4:                               ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB137_5:                               ; %B12
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB137_7
; %bb.6:                                ; %B14
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB137_7:                               ; %B13
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_to_propkey2_0_asm_h    ; -- Begin function to_propkey2_0_asm_h
	.globl	_to_propkey2_0_asm_h
	.p2align	2
_to_propkey2_0_asm_h:                   ; @to_propkey2_0_asm_h
; %bb.0:                                ; %B18
	ldp	x22, x21, [x20, #-16]
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	LBB138_3
; %bb.1:                                ; %B19
Lloh18:
	adrp	x1, l___unnamed_9@PAGE
Lloh19:
	add	x1, x1, l___unnamed_9@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_ThrowTypeError
LBB138_2:                               ; %B16
	b	_exception_asm_h
LBB138_3:                               ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	LBB138_7
; %bb.4:                                ; %B2
	mov	x9, #1                          ; =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB138_7
; %bb.5:                                ; %B2
	cmp	x8, x9
	b.eq	LBB138_7
; %bb.6:                                ; %B2
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB138_8
LBB138_7:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB138_8:                               ; %B15
	mov	x0, x24
	mov	x1, x21
	str	x20, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB138_2
; %bb.9:                                ; %B17
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh18, Lloh19
                                        ; -- End function
	.private_extern	_with_get_var_0_asm_h   ; -- Begin function with_get_var_0_asm_h
	.globl	_with_get_var_0_asm_h
	.p2align	2
_with_get_var_0_asm_h:                  ; @with_get_var_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #113                        ; =0x71
	str	x20, [x23, #48]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB139_4
; %bb.1:                                ; %B4
	cbz	w0, LBB139_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB139_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB139_4:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_with_put_var_0_asm_h   ; -- Begin function with_put_var_0_asm_h
	.globl	_with_put_var_0_asm_h
	.p2align	2
_with_put_var_0_asm_h:                  ; @with_put_var_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #114                        ; =0x72
	str	x20, [x23, #48]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB140_4
; %bb.1:                                ; %B4
	cbz	w0, LBB140_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	sub	x20, x20, #16
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB140_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB140_4:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_with_delete_var_0_asm_h ; -- Begin function with_delete_var_0_asm_h
	.globl	_with_delete_var_0_asm_h
	.p2align	2
_with_delete_var_0_asm_h:               ; @with_delete_var_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #115                        ; =0x73
	str	x20, [x23, #48]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB141_4
; %bb.1:                                ; %B4
	cbz	w0, LBB141_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB141_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB141_4:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_with_make_ref_0_asm_h  ; -- Begin function with_make_ref_0_asm_h
	.globl	_with_make_ref_0_asm_h
	.p2align	2
_with_make_ref_0_asm_h:                 ; @with_make_ref_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #116                        ; =0x74
	str	x20, [x23, #48]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB142_4
; %bb.1:                                ; %B4
	cbz	w0, LBB142_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB142_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB142_4:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_with_get_ref_0_asm_h   ; -- Begin function with_get_ref_0_asm_h
	.globl	_with_get_ref_0_asm_h
	.p2align	2
_with_get_ref_0_asm_h:                  ; @with_get_ref_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #117                        ; =0x75
	str	x20, [x23, #48]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB143_4
; %bb.1:                                ; %B4
	cbz	w0, LBB143_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB143_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB143_4:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_with_get_ref_undef_0_asm_h ; -- Begin function with_get_ref_undef_0_asm_h
	.globl	_with_get_ref_undef_0_asm_h
	.p2align	2
_with_get_ref_undef_0_asm_h:            ; @with_get_ref_undef_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #118                        ; =0x76
	str	x20, [x23, #48]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB144_4
; %bb.1:                                ; %B4
	cbz	w0, LBB144_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB144_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB144_4:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_make_loc_ref_0_asm_h   ; -- Begin function make_loc_ref_0_asm_h
	.globl	_make_loc_ref_0_asm_h
	.p2align	2
_make_loc_ref_0_asm_h:                  ; @make_loc_ref_0_asm_h
; %bb.0:                                ; %B16
	sub	sp, sp, #16
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	LBB145_6
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
	cbz	x8, LBB145_6
; %bb.2:                                ; %B6
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #34                         ; =0x22
	str	x20, [x23, #48]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	bl	_add_property_gc
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	cbz	x0, LBB145_6
; %bb.3:                                ; %B9
	mov	x8, #2                          ; =0x2
	movk	x8, #65533, lsl #48
	orr	x8, x9, x8
	str	x8, [x0]
	ldrb	w9, [x24, #392]
	cbnz	w9, LBB145_7
LBB145_4:                               ; %B13
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB145_6
; %bb.5:                                ; %B15
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB145_6:                               ; %B14
	add	sp, sp, #16
	b	_exception_asm_h
LBB145_7:                               ; %B12
	mov	x0, x8
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB145_4
                                        ; -- End function
	.private_extern	_make_arg_ref_0_asm_h   ; -- Begin function make_arg_ref_0_asm_h
	.globl	_make_arg_ref_0_asm_h
	.p2align	2
_make_arg_ref_0_asm_h:                  ; @make_arg_ref_0_asm_h
; %bb.0:                                ; %B16
	sub	sp, sp, #16
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	LBB146_6
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
	cbz	x8, LBB146_6
; %bb.2:                                ; %B6
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #34                         ; =0x22
	str	x20, [x23, #48]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	bl	_add_property_gc
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	cbz	x0, LBB146_6
; %bb.3:                                ; %B9
	mov	x8, #2                          ; =0x2
	movk	x8, #65533, lsl #48
	orr	x8, x9, x8
	str	x8, [x0]
	ldrb	w9, [x24, #392]
	cbnz	w9, LBB146_7
LBB146_4:                               ; %B13
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB146_6
; %bb.5:                                ; %B15
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB146_6:                               ; %B14
	add	sp, sp, #16
	b	_exception_asm_h
LBB146_7:                               ; %B12
	mov	x0, x8
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB146_4
                                        ; -- End function
	.private_extern	_make_var_ref_ref_0_asm_h ; -- Begin function make_var_ref_ref_0_asm_h
	.globl	_make_var_ref_ref_0_asm_h
	.p2align	2
_make_var_ref_ref_0_asm_h:              ; @make_var_ref_ref_0_asm_h
; %bb.0:                                ; %B12
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	LBB147_5
; %bb.1:                                ; %B1
	mov	x1, x0
	mov	w8, #18                         ; =0x12
	mov	x0, x24
	stp	x1, x8, [x20], #16
	mov	w3, #34                         ; =0x22
	ldr	w2, [x19]
	str	x20, [x23, #48]
	bl	_add_property_gc
	cbz	x0, LBB147_5
; %bb.2:                                ; %B4
	ldrh	w8, [x19, #4]
	mov	x9, #2                          ; =0x2
	movk	x9, #65533, lsl #48
	ldr	x8, [x26, x8, lsl #3]
	orr	x8, x8, x9
	str	x8, [x0]
	ldrb	w9, [x24, #392]
	cbnz	w9, LBB147_6
LBB147_3:                               ; %B9
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB147_5
; %bb.4:                                ; %B11
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB147_5:                               ; %B10
	b	_exception_asm_h
LBB147_6:                               ; %B7
	mov	x0, x8
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB147_3
                                        ; -- End function
	.private_extern	_make_var_ref_0_asm_h   ; -- Begin function make_var_ref_0_asm_h
	.globl	_make_var_ref_0_asm_h
	.p2align	2
_make_var_ref_0_asm_h:                  ; @make_var_ref_0_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x20
	str	x20, [x23, #48]
	bl	_JS_GetGlobalVarRef_GC
	tbnz	w0, #31, LBB148_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB148_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_for_in_start_0_asm_h   ; -- Begin function for_in_start_0_asm_h
	.globl	_for_in_start_0_asm_h
	.p2align	2
_for_in_start_0_asm_h:                  ; @for_in_start_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	bl	_prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	LBB149_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB149_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_for_of_start_0_asm_h   ; -- Begin function for_of_start_0_asm_h
	.globl	_for_of_start_0_asm_h
	.p2align	2
_for_of_start_0_asm_h:                  ; @for_of_start_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	_js_for_of_start_gc
	tbnz	w0, #31, LBB150_2
; %bb.1:                                ; %B3
	mov	w8, #66                         ; =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB150_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_for_await_of_start_0_asm_h ; -- Begin function for_await_of_start_0_asm_h
	.globl	_for_await_of_start_0_asm_h
	.p2align	2
_for_await_of_start_0_asm_h:            ; @for_await_of_start_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	mov	w2, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	_js_for_of_start_gc
	tbnz	w0, #31, LBB151_2
; %bb.1:                                ; %B3
	mov	w8, #66                         ; =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB151_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_for_in_next_0_asm_h    ; -- Begin function for_in_next_0_asm_h
	.globl	_for_in_next_0_asm_h
	.p2align	2
_for_in_next_0_asm_h:                   ; @for_in_next_0_asm_h
; %bb.0:                                ; %B65
	ldur	x8, [x20, #-8]
	mov	x11, #2                         ; =0x2
	movk	x11, #65535, lsl #48
	tst	x8, x11
	b.ne	LBB152_4
; %bb.1:                                ; %B62
	ldrh	w9, [x8, #6]
	cmp	w9, #17
	b.ne	LBB152_4
; %bb.2:                                ; %B1
	ldr	x8, [x8, #32]
	cbz	x8, LBB152_4
; %bb.3:                                ; %B9
	ldp	w9, w10, [x8, #8]
	cmp	w9, w10
	b.lo	LBB152_6
LBB152_4:                               ; %B4
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_js_for_in_next_gc
	tbnz	w0, #31, LBB152_27
; %bb.5:                                ; %B6
	ldrb	w8, [x19], #1
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB152_6:                               ; %B11
	ldr	x10, [x8]
	tst	x10, x11
	b.ne	LBB152_4
; %bb.7:                                ; %B13
	ldrb	w11, [x8, #17]
	cbnz	w11, LBB152_21
; %bb.8:                                ; %B37
	ldrb	w11, [x8, #16]
	cbnz	w11, LBB152_4
; %bb.9:                                ; %B40
	ldr	x11, [x8, #24]
	cbz	x11, LBB152_4
; %bb.10:                               ; %B57
	lsl	w12, w9, #3
	add	x11, x11, x12
	ldr	w12, [x11]
	cbz	w12, LBB152_15
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
	cbz	w12, LBB152_14
LBB152_12:                              ; %B52
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w12, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w1
	b.eq	LBB152_16
; %bb.13:                               ; %B54
                                        ;   in Loop: Header=BB152_12 Depth=1
	and	w12, w12, #0x3ffffff
	cbnz	w12, LBB152_12
LBB152_14:                              ; %B46
	ldr	w10, [x10, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB152_4
LBB152_15:                              ; %B49
	add	w9, w9, #1
	str	w9, [x8, #8]
	b	LBB152_4
LBB152_16:                              ; %B43
	lsr	w10, w12, #26
	tst	w10, #0x30
	b.ne	LBB152_4
; %bb.17:                               ; %B44
	add	w9, w9, #1
	str	w9, [x8, #8]
	tbnz	w1, #31, LBB152_25
LBB152_18:                              ; %B18
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, sxtw #3]
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, LBB152_24
; %bb.19:                               ; %B28
	ldr	w9, [x8, #8]
	asr	w9, w9, #30
	cmp	w9, #1
	b.ne	LBB152_25
LBB152_20:                              ; %B26
	mov	x9, #2                          ; =0x2
	movk	x9, #1, lsl #48
	orr	x8, x8, x9
	mov	w9, #6                          ; =0x6
	stp	x8, x9, [x20], #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB152_21:                              ; %B33
	ldr	w11, [x10, #4]
	ubfx	w11, w11, #11, #1
	cmp	w11, #1
	b.ne	LBB152_4
; %bb.22:                               ; %B15
	ldr	w10, [x10, #48]
	cmp	w9, w10
	b.hs	LBB152_4
; %bb.23:                               ; %B16
	add	w10, w9, #1
	orr	w1, w9, #0x80000000
	str	w10, [x8, #8]
	tbz	w1, #31, LBB152_18
	b	LBB152_25
LBB152_24:                              ; %B19
	ldr	x9, [x8, #8]
	ldr	w9, [x9]
	asr	w9, w9, #30
	cmp	w9, #1
	b.eq	LBB152_20
LBB152_25:                              ; %B23
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB152_27
; %bb.26:                               ; %B25
	mov	w8, #6                          ; =0x6
	stp	x0, x8, [x20], #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB152_27:                              ; %B5
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_for_of_next_0_asm_h    ; -- Begin function for_of_next_0_asm_h
	.globl	_for_of_next_0_asm_h
	.p2align	2
_for_of_next_0_asm_h:                   ; @for_of_next_0_asm_h
; %bb.0:                                ; %B1
	ldrb	w9, [x19]
	mov	w8, #-3                         ; =0xfffffffd
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	sub	w2, w8, w9
	bl	_js_for_of_next_gc
	tbnz	w0, #31, LBB153_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB153_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_for_await_of_next_0_asm_h ; -- Begin function for_await_of_next_0_asm_h
	.globl	_for_await_of_next_0_asm_h
	.p2align	2
_for_await_of_next_0_asm_h:             ; @for_await_of_next_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_js_for_await_of_next_gc
	tbnz	w0, #31, LBB154_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB154_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_iterator_get_value_done_0_asm_h ; -- Begin function iterator_get_value_done_0_asm_h
	.globl	_iterator_get_value_done_0_asm_h
	.p2align	2
_iterator_get_value_done_0_asm_h:       ; @iterator_get_value_done_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_js_iterator_get_value_done_gc
	tbnz	w0, #31, LBB155_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB155_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_iterator_close_0_asm_h ; -- Begin function iterator_close_0_asm_h
	.globl	_iterator_close_0_asm_h
	.p2align	2
_iterator_close_0_asm_h:                ; @iterator_close_0_asm_h
; %bb.0:                                ; %B6
	ldur	x1, [x20, #-24]
	sub	x20, x20, #16
	cmp	x1, #18
	b.eq	LBB156_2
; %bb.1:                                ; %B1
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	_JS_IteratorClose
	tbnz	w0, #31, LBB156_3
LBB156_2:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB156_3:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_iterator_close_return_0_asm_h ; -- Begin function iterator_close_return_0_asm_h
	.globl	_iterator_close_return_0_asm_h
	.p2align	2
_iterator_close_return_0_asm_h:         ; @iterator_close_return_0_asm_h
; %bb.0:                                ; %B0
	ldr	x9, [x23, #8]
	ldr	x8, [x20, #-8]!
	mov	w10, #247                       ; =0xf7
	ldr	x9, [x9, #32]
	ldrh	w9, [x9, #42]
	add	x9, x27, x9, lsl #3
	b	LBB157_2
LBB157_1:                               ; %B10
                                        ;   in Loop: Header=BB157_2 Depth=1
	sub	x20, x20, #8
LBB157_2:                               ; %B2
                                        ; =>This Inner Loop Header: Depth=1
	cmp	x20, x9
	b.le	LBB157_5
; %bb.3:                                ; %B4
                                        ;   in Loop: Header=BB157_2 Depth=1
	ldur	x11, [x20, #-8]
	tst	x11, #0xffff000000000000
	b.ne	LBB157_1
; %bb.4:                                ; %B4
                                        ;   in Loop: Header=BB157_2 Depth=1
	and	x11, x11, x10
	cmp	x11, #66
	b.ne	LBB157_1
LBB157_5:                               ; %B7
	add	x9, x9, #24
	cmp	x20, x9
	add	x20, x20, #8
	b.lt	LBB157_7
; %bb.6:                                ; %B9
	ldur	x9, [x20, #-16]
	ldur	q0, [x20, #-32]
	stur	x8, [x20, #-32]
	stur	x9, [x20, #-8]
	stur	q0, [x20, #-24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB157_7:                               ; %B8
Lloh20:
	adrp	x1, l___unnamed_10@PAGE
Lloh21:
	add	x1, x1, l___unnamed_10@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_ThrowInternalError
	b	_exception_asm_h
	.loh AdrpAdd	Lloh20, Lloh21
                                        ; -- End function
	.private_extern	_async_iterator_close_0_asm_h ; -- Begin function async_iterator_close_0_asm_h
	.globl	_async_iterator_close_0_asm_h
	.p2align	2
_async_iterator_close_0_asm_h:          ; @async_iterator_close_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_prim_js_async_iterator_close_gc
	tbnz	w0, #31, LBB158_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB158_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_async_iterator_next_0_asm_h ; -- Begin function async_iterator_next_0_asm_h
	.globl	_async_iterator_next_0_asm_h
	.p2align	2
_async_iterator_next_0_asm_h:           ; @async_iterator_next_0_asm_h
; %bb.0:                                ; %B1
	ldp	x2, x1, [x20, #-32]
	sub	x4, x20, #8
	mov	x0, x24
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	_JS_Call_GC
	cmp	x0, #130
	b.eq	LBB159_2
; %bb.1:                                ; %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB159_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_async_iterator_get_0_asm_h ; -- Begin function async_iterator_get_0_asm_h
	.globl	_async_iterator_get_0_asm_h
	.p2align	2
_async_iterator_get_0_asm_h:            ; @async_iterator_get_0_asm_h
; %bb.0:                                ; %B1
	ldrb	w2, [x19]
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_prim_js_async_iterator_get_gc
	tbnz	w0, #31, LBB160_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB160_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_initial_yield_0_asm_h  ; -- Begin function initial_yield_0_asm_h
	.globl	_initial_yield_0_asm_h
	.p2align	2
_initial_yield_0_asm_h:                 ; @initial_yield_0_asm_h
; %bb.0:                                ; %B0
	str	x19, [x23, #32]
	mov	w0, #18                         ; =0x12
	str	x20, [x23, #48]
	b	_common_return_direct_asm_h
                                        ; -- End function
	.private_extern	_yield_0_asm_h          ; -- Begin function yield_0_asm_h
	.globl	_yield_0_asm_h
	.p2align	2
_yield_0_asm_h:                         ; @yield_0_asm_h
; %bb.0:                                ; %B0
	str	x19, [x23, #32]
	mov	x0, #-562949953421311           ; =0xfffe000000000001
	str	x20, [x23, #48]
	b	_common_return_direct_asm_h
                                        ; -- End function
	.private_extern	_yield_star_0_asm_h     ; -- Begin function yield_star_0_asm_h
	.globl	_yield_star_0_asm_h
	.p2align	2
_yield_star_0_asm_h:                    ; @yield_star_0_asm_h
; %bb.0:                                ; %B0
	mov	x0, #2                          ; =0x2
	str	x19, [x23, #32]
	str	x20, [x23, #48]
	movk	x0, #65534, lsl #48
	b	_common_return_direct_asm_h
                                        ; -- End function
	.private_extern	_async_yield_star_0_asm_h ; -- Begin function async_yield_star_0_asm_h
	.globl	_async_yield_star_0_asm_h
	.p2align	2
_async_yield_star_0_asm_h:              ; @async_yield_star_0_asm_h
; %bb.0:                                ; %B0
	mov	x0, #2                          ; =0x2
	str	x19, [x23, #32]
	str	x20, [x23, #48]
	movk	x0, #65534, lsl #48
	b	_common_return_direct_asm_h
                                        ; -- End function
	.private_extern	_await_0_asm_h          ; -- Begin function await_0_asm_h
	.globl	_await_0_asm_h
	.p2align	2
_await_0_asm_h:                         ; @await_0_asm_h
; %bb.0:                                ; %B0
	str	x19, [x23, #32]
	mov	x0, #-562949953421312           ; =0xfffe000000000000
	str	x20, [x23, #48]
	b	_common_return_direct_asm_h
                                        ; -- End function
	.private_extern	_neg_0_asm_h            ; -- Begin function neg_0_asm_h
	.globl	_neg_0_asm_h
	.p2align	2
_neg_0_asm_h:                           ; @neg_0_asm_h
; %bb.0:                                ; %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB166_3
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB166_6
; %bb.2:                                ; %B13
	orr	w8, w22, #0x80000000
	mov	w9, #-2147483648                ; =0x80000000
	cmp	w8, w9
	b.ne	LBB166_5
LBB166_3:                               ; %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        ; =0x8c
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB166_8
; %bb.4:                                ; %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB166_5:                               ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB166_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB166_3
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
LBB166_8:                               ; %B17
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_plus_0_asm_h           ; -- Begin function plus_0_asm_h
	.globl	_plus_0_asm_h
	.p2align	2
_plus_0_asm_h:                          ; @plus_0_asm_h
; %bb.0:                                ; %B13
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB167_4
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB167_3
LBB167_2:                               ; %B7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB167_3:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.ne	LBB167_2
LBB167_4:                               ; %B10
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        ; =0x8d
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB167_6
; %bb.5:                                ; %B12
	mov	x22, x0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB167_6:                               ; %B11
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_dec_0_asm_h            ; -- Begin function dec_0_asm_h
	.globl	_dec_0_asm_h
	.p2align	2
_dec_0_asm_h:                           ; @dec_0_asm_h
; %bb.0:                                ; %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB168_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB168_4
; %bb.2:                                ; %B13
	subs	w8, w22, #1
	b.vs	LBB168_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB168_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB168_6
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
LBB168_6:                               ; %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        ; =0x8e
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB168_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB168_8:                               ; %B17
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_inc_0_asm_h            ; -- Begin function inc_0_asm_h
	.globl	_inc_0_asm_h
	.p2align	2
_inc_0_asm_h:                           ; @inc_0_asm_h
; %bb.0:                                ; %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB169_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB169_4
; %bb.2:                                ; %B13
	adds	w8, w22, #1
	b.vs	LBB169_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB169_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB169_6
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
LBB169_6:                               ; %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        ; =0x8f
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB169_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB169_8:                               ; %B17
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_post_dec_0_asm_h       ; -- Begin function post_dec_0_asm_h
	.globl	_post_dec_0_asm_h
	.p2align	2
_post_dec_0_asm_h:                      ; @post_dec_0_asm_h
; %bb.0:                                ; %B16
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB170_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB170_4
; %bb.2:                                ; %B13
	subs	w8, w22, #1
	b.vs	LBB170_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB170_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB170_6
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
LBB170_6:                               ; %B5
	mov	w0, #144                        ; =0x90
	b	_SlowJSPostInc_asm_h
                                        ; -- End function
	.private_extern	_post_inc_0_asm_h       ; -- Begin function post_inc_0_asm_h
	.globl	_post_inc_0_asm_h
	.p2align	2
_post_inc_0_asm_h:                      ; @post_inc_0_asm_h
; %bb.0:                                ; %B16
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB171_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB171_4
; %bb.2:                                ; %B13
	adds	w8, w22, #1
	b.vs	LBB171_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB171_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB171_6
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
LBB171_6:                               ; %B5
	mov	w0, #145                        ; =0x91
	b	_SlowJSPostInc_asm_h
                                        ; -- End function
	.private_extern	_dec_loc_0_asm_h        ; -- Begin function dec_loc_0_asm_h
	.globl	_dec_loc_0_asm_h
	.p2align	2
_dec_loc_0_asm_h:                       ; @dec_loc_0_asm_h
; %bb.0:                                ; %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	LBB172_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB172_4
; %bb.2:                                ; %B13
	subs	w9, w1, #1
	b.vs	LBB172_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB172_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB172_6
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
LBB172_6:                               ; %B16
	mov	x0, x24
	mov	w2, #142                        ; =0x8e
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB172_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB172_8:                               ; %B17
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_inc_loc_0_asm_h        ; -- Begin function inc_loc_0_asm_h
	.globl	_inc_loc_0_asm_h
	.p2align	2
_inc_loc_0_asm_h:                       ; @inc_loc_0_asm_h
; %bb.0:                                ; %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	LBB173_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB173_4
; %bb.2:                                ; %B13
	adds	w9, w1, #1
	b.vs	LBB173_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB173_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB173_6
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
LBB173_6:                               ; %B16
	mov	x0, x24
	mov	w2, #143                        ; =0x8f
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB173_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB173_8:                               ; %B17
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_add_loc_0_asm_h        ; -- Begin function add_loc_0_asm_h
	.globl	_add_loc_0_asm_h
	.p2align	2
_add_loc_0_asm_h:                       ; @add_loc_0_asm_h
; %bb.0:                                ; %B42
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldur	x22, [x20, #-8]
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	ccmp	x22, x9, #2, ls
	b.hi	LBB174_14
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB174_5
; %bb.2:                                ; %B26
	cmp	x22, x9
	b.lo	LBB174_8
; %bb.3:                                ; %B36
	adds	w9, w1, w22
	b.vs	LBB174_14
; %bb.4:                                ; %B38
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB174_5:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB174_14
; %bb.6:                                ; %B11
	cmp	x22, x9
	b.lo	LBB174_12
; %bb.7:                                ; %B21
	scvtf	d0, w22
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	LBB174_11
LBB174_8:                               ; %B28
	tst	x22, #0xfffe000000000000
	b.eq	LBB174_14
; %bb.9:                                ; %B31
	scvtf	d0, w1
	add	x9, x22, x9
LBB174_10:                              ; %B31
	fmov	d1, x9
	fadd	d0, d0, d1
LBB174_11:                              ; %B31
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
LBB174_12:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB174_14
; %bb.13:                               ; %B16
	add	x10, x1, x9
	add	x9, x22, x9
	fmov	d0, x10
	b	LBB174_10
LBB174_14:                              ; %B7
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
	b.ne	LBB174_17
; %bb.15:                               ; %B39
	mov	x0, x24
	mov	x2, x22
	str	x20, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB174_18
; %bb.16:                               ; %B41
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB174_17:                              ; %B8
	mov	w0, #1                          ; =0x1
	b	_FastJSConcatString_asm_h
LBB174_18:                              ; %B40
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_not_0_asm_h            ; -- Begin function not_0_asm_h
	.globl	_not_0_asm_h
	.p2align	2
_not_0_asm_h:                           ; @not_0_asm_h
; %bb.0:                                ; %B2
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB175_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB175_2:                               ; %B4
	mov	x0, x22
	b	_SlowJSNot_asm_h
                                        ; -- End function
	.private_extern	_lnot_0_asm_h           ; -- Begin function lnot_0_asm_h
	.globl	_lnot_0_asm_h
	.p2align	2
_lnot_0_asm_h:                          ; @lnot_0_asm_h
; %bb.0:                                ; %B14
	ldur	x22, [x20, #-8]
	cmp	x22, #5
	b.le	LBB176_4
; %bb.1:                                ; %B14
	cmp	x22, #6
	b.eq	LBB176_6
; %bb.2:                                ; %B14
	cmp	x22, #7
	b.eq	LBB176_8
; %bb.3:                                ; %B14
	cmp	x22, #18
	b.eq	LBB176_6
	b	LBB176_7
LBB176_4:                               ; %B14
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB176_6
; %bb.5:                                ; %B14
	cmp	x22, #2
	b.ne	LBB176_7
LBB176_6:                               ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB176_7:                               ; %B10
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB176_9
LBB176_8:                               ; %B12
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB176_9:                               ; %B13
	mov	x0, x22
	b	_SlowToBoolean_asm_h
                                        ; -- End function
	.private_extern	_typeof_0_asm_h         ; -- Begin function typeof_0_asm_h
	.globl	_typeof_0_asm_h
	.p2align	2
_typeof_0_asm_h:                        ; @typeof_0_asm_h
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
	b.eq	LBB177_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB177_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_delete_0_asm_h         ; -- Begin function delete_0_asm_h
	.globl	_delete_0_asm_h
	.p2align	2
_delete_0_asm_h:                        ; @delete_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	_prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	LBB178_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB178_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_delete_var_0_asm_h     ; -- Begin function delete_var_0_asm_h
	.globl	_delete_var_0_asm_h
	.p2align	2
_delete_var_0_asm_h:                    ; @delete_var_0_asm_h
; %bb.0:                                ; %B1
	ldr	x1, [x24, #208]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, wzr
	str	x20, [x23, #48]
	bl	_JS_DeleteProperty_GC
	tbnz	w0, #31, LBB179_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB179_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_mul_0_asm_h            ; -- Begin function mul_0_asm_h
	.globl	_mul_0_asm_h
	.p2align	2
_mul_0_asm_h:                           ; @mul_0_asm_h
; %bb.0:                                ; %B47
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB180_18
; %bb.1:                                ; %B47
	cmp	x21, x8
	b.hi	LBB180_18
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB180_8
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB180_11
; %bb.4:                                ; %B33
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	LBB180_18
; %bb.5:                                ; %B36
	cbnz	w8, LBB180_7
; %bb.6:                                ; %B36
	orr	w9, w22, w21
	tbnz	w9, #31, LBB180_15
LBB180_7:                               ; %B43
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB180_8:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB180_18
; %bb.9:                                ; %B7
	cmp	x21, x8
	b.lo	LBB180_16
; %bb.10:                               ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	LBB180_14
LBB180_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB180_18
; %bb.12:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB180_13:                              ; %B28
	fmov	d1, x8
	fmul	d0, d0, d1
LBB180_14:                              ; %B28
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
LBB180_15:                              ; %B40
	mov	x22, #-9222809086901354496      ; =0x8002000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB180_16:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB180_18
; %bb.17:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB180_13
LBB180_18:                              ; %B44
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        ; =0x9a
	str	x20, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB180_20
; %bb.19:                               ; %B46
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB180_20:                              ; %B45
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_div_0_asm_h            ; -- Begin function div_0_asm_h
	.globl	_div_0_asm_h
	.p2align	2
_div_0_asm_h:                           ; @div_0_asm_h
; %bb.0:                                ; %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB181_14
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB181_14
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB181_5
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB181_8
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
LBB181_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB181_14
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB181_12
; %bb.7:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	LBB181_11
LBB181_8:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB181_14
; %bb.9:                                ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB181_10:                              ; %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
LBB181_11:                              ; %B28
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
LBB181_12:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB181_14
; %bb.13:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB181_10
LBB181_14:                              ; %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        ; =0x9b
	str	x20, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB181_16
; %bb.15:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB181_16:                              ; %B42
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_mod_0_asm_h            ; -- Begin function mod_0_asm_h
	.globl	_mod_0_asm_h
	.p2align	2
_mod_0_asm_h:                           ; @mod_0_asm_h
; %bb.0:                                ; %B39
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB182_16
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB182_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB182_7
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB182_10
; %bb.4:                                ; %B33
	tbnz	w22, #31, LBB182_16
; %bb.5:                                ; %B33
	cmp	w21, #1
	b.lt	LBB182_16
; %bb.6:                                ; %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB182_7:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB182_16
; %bb.8:                                ; %B7
	cmp	x21, x8
	b.lo	LBB182_14
; %bb.9:                                ; %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	LBB182_13
LBB182_10:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB182_16
; %bb.11:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB182_12:                              ; %B28
	fmov	d1, x8
LBB182_13:                              ; %B28
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
LBB182_14:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB182_16
; %bb.15:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB182_12
LBB182_16:                              ; %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        ; =0x9c
	str	x20, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB182_18
; %bb.17:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB182_18:                              ; %B37
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_add_0_asm_h            ; -- Begin function add_0_asm_h
	.globl	_add_0_asm_h
	.p2align	2
_add_0_asm_h:                           ; @add_0_asm_h
; %bb.0:                                ; %B42
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB183_15
; %bb.1:                                ; %B42
	cmp	x21, x8
	b.hi	LBB183_15
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB183_6
; %bb.3:                                ; %B26
	cmp	x21, x8
	b.lo	LBB183_9
; %bb.4:                                ; %B36
	adds	w8, w22, w21
	b.vs	LBB183_15
; %bb.5:                                ; %B38
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB183_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB183_15
; %bb.7:                                ; %B11
	cmp	x21, x8
	b.lo	LBB183_13
; %bb.8:                                ; %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	LBB183_12
LBB183_9:                               ; %B28
	tst	x21, #0xfffe000000000000
	b.eq	LBB183_15
; %bb.10:                               ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB183_11:                              ; %B31
	fmov	d1, x8
	fadd	d0, d0, d1
LBB183_12:                              ; %B31
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
LBB183_13:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB183_15
; %bb.14:                               ; %B16
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB183_11
LBB183_15:                              ; %B7
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
	b.ne	LBB183_18
; %bb.16:                               ; %B7
	cbz	w8, LBB183_18
; %bb.17:                               ; %B8
	mov	x0, xzr
	b	_FastJSConcatString_asm_h
LBB183_18:                              ; %B39
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB183_20
; %bb.19:                               ; %B41
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB183_20:                              ; %B40
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_sub_0_asm_h            ; -- Begin function sub_0_asm_h
	.globl	_sub_0_asm_h
	.p2align	2
_sub_0_asm_h:                           ; @sub_0_asm_h
; %bb.0:                                ; %B39
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB184_15
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB184_15
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB184_6
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB184_9
; %bb.4:                                ; %B33
	subs	w8, w22, w21
	b.vs	LBB184_15
; %bb.5:                                ; %B35
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB184_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB184_15
; %bb.7:                                ; %B7
	cmp	x21, x8
	b.lo	LBB184_13
; %bb.8:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	LBB184_12
LBB184_9:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB184_15
; %bb.10:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB184_11:                              ; %B28
	fmov	d1, x8
	fsub	d0, d0, d1
LBB184_12:                              ; %B28
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
LBB184_13:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB184_15
; %bb.14:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB184_11
LBB184_15:                              ; %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        ; =0x9e
	str	x20, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB184_17
; %bb.16:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB184_17:                              ; %B37
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_pow_0_asm_h            ; -- Begin function pow_0_asm_h
	.globl	_pow_0_asm_h
	.p2align	2
_pow_0_asm_h:                           ; @pow_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w3, #159                        ; =0x9f
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB185_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB185_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_shl_0_asm_h            ; -- Begin function shl_0_asm_h
	.globl	_shl_0_asm_h
	.p2align	2
_shl_0_asm_h:                           ; @shl_0_asm_h
; %bb.0:                                ; %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB186_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB186_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB186_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB186_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB186_5:                               ; %B16
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #16
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB186_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB186_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB186_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB186_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB186_5
LBB186_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        ; =0xa0
	str	x20, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB186_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB186_12:                              ; %B26
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_sar_0_asm_h            ; -- Begin function sar_0_asm_h
	.globl	_sar_0_asm_h
	.p2align	2
_sar_0_asm_h:                           ; @sar_0_asm_h
; %bb.0:                                ; %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB187_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB187_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB187_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB187_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB187_5:                               ; %B16
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #16
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB187_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB187_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB187_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB187_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB187_5
LBB187_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        ; =0xa1
	str	x20, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB187_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB187_12:                              ; %B26
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_shr_0_asm_h            ; -- Begin function shr_0_asm_h
	.globl	_shr_0_asm_h
	.p2align	2
_shr_0_asm_h:                           ; @shr_0_asm_h
; %bb.0:                                ; %B36
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB188_11
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB188_11
; %bb.2:                                ; %B10
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB188_6
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB188_11
; %bb.4:                                ; %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, LBB188_10
LBB188_5:                               ; %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB188_6:                               ; %B12
	tst	x22, #0xfffe000000000000
	b.eq	LBB188_11
; %bb.7:                                ; %B12
	cmp	x21, x8
	b.lo	LBB188_11
; %bb.8:                                ; %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB188_11
; %bb.9:                                ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, LBB188_5
LBB188_10:                              ; %B6
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
LBB188_11:                              ; %B33
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	_prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	LBB188_13
; %bb.12:                               ; %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB188_13:                              ; %B34
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_lt_0_asm_h             ; -- Begin function lt_0_asm_h
	.globl	_lt_0_asm_h
	.p2align	2
_lt_0_asm_h:                            ; @lt_0_asm_h
; %bb.0:                                ; %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB189_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB189_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB189_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB189_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, lt
	br	x1
LBB189_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB189_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB189_10
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
LBB189_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB189_12
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
LBB189_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB189_12
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
LBB189_12:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        ; =0xa3
	str	x20, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB189_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB189_14:                              ; %B22
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_lte_0_asm_h            ; -- Begin function lte_0_asm_h
	.globl	_lte_0_asm_h
	.p2align	2
_lte_0_asm_h:                           ; @lte_0_asm_h
; %bb.0:                                ; %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB190_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB190_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB190_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB190_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, le
	br	x1
LBB190_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB190_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB190_10
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
LBB190_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB190_12
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
LBB190_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB190_12
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
LBB190_12:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        ; =0xa4
	str	x20, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB190_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB190_14:                              ; %B22
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_gt_0_asm_h             ; -- Begin function gt_0_asm_h
	.globl	_gt_0_asm_h
	.p2align	2
_gt_0_asm_h:                            ; @gt_0_asm_h
; %bb.0:                                ; %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB191_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB191_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB191_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB191_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB191_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB191_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB191_10
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
LBB191_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB191_12
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
LBB191_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB191_12
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
LBB191_12:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        ; =0xa5
	str	x20, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB191_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB191_14:                              ; %B22
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_gte_0_asm_h            ; -- Begin function gte_0_asm_h
	.globl	_gte_0_asm_h
	.p2align	2
_gte_0_asm_h:                           ; @gte_0_asm_h
; %bb.0:                                ; %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB192_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB192_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB192_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB192_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB192_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB192_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB192_10
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
LBB192_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB192_12
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
LBB192_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB192_12
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
LBB192_12:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        ; =0xa6
	str	x20, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB192_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB192_14:                              ; %B22
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_instanceof_0_asm_h     ; -- Begin function instanceof_0_asm_h
	.globl	_instanceof_0_asm_h
	.p2align	2
_instanceof_0_asm_h:                    ; @instanceof_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	_prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	LBB193_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB193_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_in_0_asm_h             ; -- Begin function in_0_asm_h
	.globl	_in_0_asm_h
	.p2align	2
_in_0_asm_h:                            ; @in_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #48]
	mov	x1, x22
	mov	x2, x21
	bl	_prim_js_operator_in_gc
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
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_eq_0_asm_h             ; -- Begin function eq_0_asm_h
	.globl	_eq_0_asm_h
	.p2align	2
_eq_0_asm_h:                            ; @eq_0_asm_h
; %bb.0:                                ; %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB195_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB195_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB195_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB195_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB195_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB195_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB195_11
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
LBB195_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB195_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB195_10:                              ; %B39
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
LBB195_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB195_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB195_10
LBB195_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB195_15
LBB195_14:                              ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB195_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB195_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB195_14
	b	LBB195_20
LBB195_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB195_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB195_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB195_21
LBB195_20:                              ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB195_21:                              ; %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB195_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB195_23:                              ; %B42
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_neq_0_asm_h            ; -- Begin function neq_0_asm_h
	.globl	_neq_0_asm_h
	.p2align	2
_neq_0_asm_h:                           ; @neq_0_asm_h
; %bb.0:                                ; %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB196_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB196_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB196_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB196_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB196_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB196_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB196_11
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
LBB196_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB196_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB196_10:                              ; %B39
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
LBB196_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB196_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB196_10
LBB196_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB196_15
LBB196_14:                              ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB196_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB196_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB196_14
	b	LBB196_20
LBB196_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB196_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB196_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB196_21
LBB196_20:                              ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB196_21:                              ; %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB196_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB196_23:                              ; %B42
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_strict_eq_0_asm_h      ; -- Begin function strict_eq_0_asm_h
	.globl	_strict_eq_0_asm_h
	.p2align	2
_strict_eq_0_asm_h:                     ; @strict_eq_0_asm_h
; %bb.0:                                ; %B39
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB197_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB197_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB197_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB197_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB197_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB197_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB197_11
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
LBB197_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB197_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB197_10:                              ; %B34
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
LBB197_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB197_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB197_10
LBB197_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB197_15
; %bb.14:                               ; %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB197_15:                              ; %B13
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
	b.ne	LBB197_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB197_22
LBB197_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB197_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB197_23
LBB197_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB197_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB197_25
LBB197_21:                              ; %B21
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB197_22:                              ; %B14
	mov	x0, xzr
	b	_FastStringEqual_asm_h
LBB197_23:                              ; %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB197_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB197_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #16
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB197_28
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB197_27:                              ; %B37
	b	_exception_asm_h
LBB197_28:                              ; %B8
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_strict_neq_0_asm_h     ; -- Begin function strict_neq_0_asm_h
	.globl	_strict_neq_0_asm_h
	.p2align	2
_strict_neq_0_asm_h:                    ; @strict_neq_0_asm_h
; %bb.0:                                ; %B39
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB198_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB198_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB198_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB198_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB198_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB198_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB198_11
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
LBB198_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB198_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB198_10:                              ; %B34
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
LBB198_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB198_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB198_10
LBB198_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB198_15
; %bb.14:                               ; %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB198_15:                              ; %B13
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
	b.ne	LBB198_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB198_22
LBB198_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB198_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB198_23
LBB198_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB198_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB198_25
LBB198_21:                              ; %B21
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB198_22:                              ; %B14
	mov	w0, #1                          ; =0x1
	b	_FastStringEqual_asm_h
LBB198_23:                              ; %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB198_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB198_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #16
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB198_28
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB198_27:                              ; %B37
	b	_exception_asm_h
LBB198_28:                              ; %B8
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_and_0_asm_h            ; -- Begin function and_0_asm_h
	.globl	_and_0_asm_h
	.p2align	2
_and_0_asm_h:                           ; @and_0_asm_h
; %bb.0:                                ; %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB199_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB199_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB199_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB199_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB199_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	and	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB199_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB199_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB199_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB199_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB199_5
LBB199_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        ; =0xad
	str	x20, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB199_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB199_12:                              ; %B26
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_xor_0_asm_h            ; -- Begin function xor_0_asm_h
	.globl	_xor_0_asm_h
	.p2align	2
_xor_0_asm_h:                           ; @xor_0_asm_h
; %bb.0:                                ; %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB200_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB200_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB200_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB200_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB200_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	eor	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB200_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB200_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB200_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB200_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB200_5
LBB200_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        ; =0xae
	str	x20, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB200_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB200_12:                              ; %B26
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_or_0_asm_h             ; -- Begin function or_0_asm_h
	.globl	_or_0_asm_h
	.p2align	2
_or_0_asm_h:                            ; @or_0_asm_h
; %bb.0:                                ; %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB201_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB201_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB201_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB201_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB201_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	orr	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB201_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB201_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB201_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB201_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB201_5
LBB201_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        ; =0xaf
	str	x20, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB201_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB201_12:                              ; %B26
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_nop_0_asm_h            ; -- Begin function nop_0_asm_h
	.globl	_nop_0_asm_h
	.p2align	2
_nop_0_asm_h:                           ; @nop_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_minus1_0_asm_h    ; -- Begin function push_minus1_0_asm_h
	.globl	_push_minus1_0_asm_h
	.p2align	2
_push_minus1_0_asm_h:                   ; @push_minus1_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562945658454017          ; =0xfffe0000ffffffff
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_0_0_asm_h         ; -- Begin function push_0_0_asm_h
	.globl	_push_0_0_asm_h
	.p2align	2
_push_0_0_asm_h:                        ; @push_0_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421312          ; =0xfffe000000000000
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_1_0_asm_h         ; -- Begin function push_1_0_asm_h
	.globl	_push_1_0_asm_h
	.p2align	2
_push_1_0_asm_h:                        ; @push_1_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421311          ; =0xfffe000000000001
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_2_0_asm_h         ; -- Begin function push_2_0_asm_h
	.globl	_push_2_0_asm_h
	.p2align	2
_push_2_0_asm_h:                        ; @push_2_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #2                         ; =0x2
	movk	x22, #65534, lsl #48
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_3_0_asm_h         ; -- Begin function push_3_0_asm_h
	.globl	_push_3_0_asm_h
	.p2align	2
_push_3_0_asm_h:                        ; @push_3_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421309          ; =0xfffe000000000003
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_4_0_asm_h         ; -- Begin function push_4_0_asm_h
	.globl	_push_4_0_asm_h
	.p2align	2
_push_4_0_asm_h:                        ; @push_4_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #4                         ; =0x4
	movk	x22, #65534, lsl #48
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_5_0_asm_h         ; -- Begin function push_5_0_asm_h
	.globl	_push_5_0_asm_h
	.p2align	2
_push_5_0_asm_h:                        ; @push_5_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #5                         ; =0x5
	movk	x22, #65534, lsl #48
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_6_0_asm_h         ; -- Begin function push_6_0_asm_h
	.globl	_push_6_0_asm_h
	.p2align	2
_push_6_0_asm_h:                        ; @push_6_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #6                         ; =0x6
	movk	x22, #65534, lsl #48
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_7_0_asm_h         ; -- Begin function push_7_0_asm_h
	.globl	_push_7_0_asm_h
	.p2align	2
_push_7_0_asm_h:                        ; @push_7_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, #-562949953421305          ; =0xfffe000000000007
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_i8_0_asm_h        ; -- Begin function push_i8_0_asm_h
	.globl	_push_i8_0_asm_h
	.p2align	2
_push_i8_0_asm_h:                       ; @push_i8_0_asm_h
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
	.private_extern	_push_i16_0_asm_h       ; -- Begin function push_i16_0_asm_h
	.globl	_push_i16_0_asm_h
	.p2align	2
_push_i16_0_asm_h:                      ; @push_i16_0_asm_h
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
	.private_extern	_push_const8_0_asm_h    ; -- Begin function push_const8_0_asm_h
	.globl	_push_const8_0_asm_h
	.p2align	2
_push_const8_0_asm_h:                   ; @push_const8_0_asm_h
; %bb.0:                                ; %B3
	sub	sp, sp, #16
	ldr	x8, [x23, #112]
	ldrb	w9, [x19]
	ldr	w10, [x24, #336]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, LBB214_2
; %bb.1:                                ; %B4
	mov	x0, x24
	mov	x2, x19
	str	x20, [x23, #48]
	str	x1, [sp, #8]                    ; 8-byte Folded Spill
	bl	_DebuggerPause
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
LBB214_2:                               ; %B1
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x1
	add	w8, w8, #243
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
                                        ; -- End function
	.private_extern	_fclosure8_0_asm_h      ; -- Begin function fclosure8_0_asm_h
	.globl	_fclosure8_0_asm_h
	.p2align	2
_fclosure8_0_asm_h:                     ; @fclosure8_0_asm_h
; %bb.0:                                ; %B124
	sub	sp, sp, #96
	ldr	x8, [x23, #112]
	ldrb	w9, [x19]
	mov	x2, x20
	str	x19, [sp, #64]                  ; 8-byte Folded Spill
	ldr	x8, [x8, x9, lsl #3]
	and	x8, x8, #0xfffffffffffc
	stp	x20, x8, [sp, #80]              ; 16-byte Folded Spill
	ldrb	w8, [x8, #6]
	tst	w8, #0x30
	str	w8, [sp, #76]                   ; 4-byte Folded Spill
	b.ne	LBB215_40
; %bb.1:                                ; %B111
	ldrb	w8, [x24, #371]
	cbnz	w8, LBB215_40
; %bb.2:                                ; %B114
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB215_40
; %bb.3:                                ; %B117
	ldr	w8, [sp, #76]                   ; 4-byte Folded Reload
	tst	w8, #0x1
	mov	w8, #6                          ; =0x6
	cinc	w8, w8, eq
	ldr	x8, [x24, w8, uxtw #3]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	cbz	x8, LBB215_40
; %bb.4:                                ; %B1
	ldr	x8, [sp, #88]                   ; 8-byte Folded Reload
	mov	w9, #47                         ; =0x2f
	ldr	w8, [x8, #20]
	cmp	w8, #0
	csel	w8, w9, w8, eq
	tbnz	w8, #31, LBB215_40
; %bb.5:                                ; %B103
	ldr	x9, [x24, #8]
	ldr	x9, [x9, #64]
	ldr	x9, [x9, w8, sxtw #3]
	ldrb	w8, [x9, #7]
	str	x9, [sp, #16]                   ; 8-byte Folded Spill
	tbnz	w8, #6, LBB215_34
; %bb.6:                                ; %B106
	ldr	w8, [x9, #8]
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	LBB215_40
LBB215_7:                               ; %B100
	ldr	x8, [sp, #88]                   ; 8-byte Folded Reload
	ldr	w15, [x23, #40]
	ldr	x16, [x23, #72]
	ldr	w13, [x8, #60]
	ldr	x14, [x8, #32]
	str	w15, [sp, #44]                  ; 4-byte Folded Spill
	stp	x14, x13, [sp, #48]             ; 16-byte Folded Spill
	cbz	w13, LBB215_35
; %bb.8:                                ; %B15.preheader
	mov	w17, wzr
	mov	w19, wzr
LBB215_9:                               ; %B15
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB215_16 Depth 2
	lsl	w8, w19, #3
	add	x9, x14, x8
	ldrb	w8, [x9]
	tbz	w8, #0, LBB215_13
; %bb.10:                               ; %B17
                                        ;   in Loop: Header=BB215_9 Depth=1
	ldrh	w9, [x9, #2]
	tst	w8, #0x2
	ubfiz	x10, x9, #3, #32
	add	w12, w15, w9
	csel	w20, w12, w9, eq
	add	x11, x27, x10
	add	x10, x28, x10
	csel	x10, x11, x10, eq
	cbz	x16, LBB215_14
; %bb.11:                               ; %B37
                                        ;   in Loop: Header=BB215_9 Depth=1
	ldr	x8, [x16, w20, uxtw #3]
	cbz	x8, LBB215_22
LBB215_12:                              ; %B96
                                        ;   in Loop: Header=BB215_9 Depth=1
	add	w19, w19, #1
	cmp	w19, w13
	b.lo	LBB215_9
	b	LBB215_24
LBB215_13:                              ; %B11
                                        ;   in Loop: Header=BB215_9 Depth=1
	cbnz	x26, LBB215_12
	b	LBB215_40
LBB215_14:                              ; %B19
                                        ;   in Loop: Header=BB215_9 Depth=1
	ldr	w8, [x23, #80]
	str	x2, [x23, #48]
	mov	x0, x24
	mov	w2, #48                         ; =0x30
	str	w20, [sp, #4]                   ; 4-byte Folded Spill
	lsl	x1, x8, #3
	mov	x20, x8
	str	x10, [sp, #24]                  ; 8-byte Folded Spill
	bl	_prim_try_malloc_gc
	ldr	x10, [sp, #24]                  ; 8-byte Folded Reload
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	cbz	x0, LBB215_40
; %bb.15:                               ; %B32.preheader
                                        ;   in Loop: Header=BB215_9 Depth=1
	mov	x8, x0
	mov	w9, wzr
LBB215_16:                              ; %B32
                                        ;   Parent Loop BB215_9 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	w9, w9, #1
	str	xzr, [x8], #8
	cmp	w9, w20
	b.lo	LBB215_16
; %bb.17:                               ; %B34
                                        ;   in Loop: Header=BB215_9 Depth=1
	mov	x16, x0
	mov	w17, #1                         ; =0x1
	str	x0, [x23, #72]
LBB215_18:                              ; %B22
                                        ;   in Loop: Header=BB215_9 Depth=1
	ldr	w8, [x23, #44]
	mov	w1, #16                         ; =0x10
	stp	x10, x16, [sp, #24]             ; 16-byte Folded Spill
	str	w17, [sp]                       ; 4-byte Folded Spill
	mov	x0, x24
	str	x2, [x23, #48]
	tbnz	w8, #4, LBB215_23
; %bb.19:                               ; %B29
                                        ;   in Loop: Header=BB215_9 Depth=1
	mov	w2, #16                         ; =0x10
LBB215_20:                              ; %B29
                                        ;   in Loop: Header=BB215_9 Depth=1
	bl	_prim_try_malloc_gc
	ldp	x14, x13, [sp, #48]             ; 16-byte Folded Reload
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	ldp	x9, x16, [sp, #24]              ; 16-byte Folded Reload
	ldr	w15, [sp, #44]                  ; 4-byte Folded Reload
	ldr	w17, [sp]                       ; 4-byte Folded Reload
	cbz	x0, LBB215_40
; %bb.21:                               ;   in Loop: Header=BB215_9 Depth=1
	mov	x8, x0
	str	x9, [x8]
	mov	w9, #18                         ; =0x12
	str	x9, [x8, #8]
	ldr	w9, [sp, #4]                    ; 4-byte Folded Reload
	str	x8, [x16, w9, uxtw #3]
	b	LBB215_12
LBB215_22:                              ; %B39
                                        ;   in Loop: Header=BB215_9 Depth=1
	cmp	w17, #1
	str	w20, [sp, #4]                   ; 4-byte Folded Spill
	b.ne	LBB215_40
	b	LBB215_18
LBB215_23:                              ; %B24
                                        ;   in Loop: Header=BB215_9 Depth=1
	mov	w2, #57                         ; =0x39
	b	LBB215_20
LBB215_24:                              ; %B49
	lsl	x1, x13, #3
	str	x2, [x23, #48]
	mov	x0, x24
	mov	w2, #48                         ; =0x30
	mov	x19, x16
	bl	_prim_try_malloc_gc
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	mov	x16, x19
	mov	x19, x0
	cbz	x0, LBB215_40
; %bb.25:                               ; %B52
	ldr	w8, [sp, #76]                   ; 4-byte Folded Reload
	str	x16, [sp, #32]                  ; 8-byte Folded Spill
	str	x2, [x23, #48]
	tbnz	w8, #0, LBB215_36
LBB215_26:                              ; %B88
	mov	x0, x24
	mov	w1, #88                         ; =0x58
	mov	w2, #2                          ; =0x2
	bl	_prim_try_malloc_gc
	ldp	x16, x15, [sp, #48]             ; 16-byte Folded Reload
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	ldr	w17, [sp, #44]                  ; 4-byte Folded Reload
	ldr	x1, [sp, #32]                   ; 8-byte Folded Reload
	cbz	x0, LBB215_40
; %bb.27:                               ; %B91
	ldr	x11, [sp, #8]                   ; 8-byte Folded Reload
	mov	w10, #1                         ; =0x1
	mov	x12, x0
	mov	x20, xzr
	mov	x8, x0
	ldr	w9, [x11]
	add	w9, w9, #1
	str	w9, [x11]
	mov	w9, #13                         ; =0xd
	str	w10, [x0]
	strb	w10, [x0, #5]
	add	x10, x0, #8
	strh	w9, [x0, #6]
	mov	x9, xzr
	stlr	x11, [x10]
	ldrb	w10, [x24, #392]
	cbnz	w10, LBB215_39
LBB215_28:                              ; %B59
	ldr	x11, [sp, #88]                  ; 8-byte Folded Reload
	add	x10, x8, #56
	mov	x12, #2                         ; =0x2
	str	x10, [x8, #16]
	ldr	x13, [sp, #16]                  ; 8-byte Folded Reload
	movk	x12, #1, lsl #48
	stp	x11, x19, [x8, #32]
	ldrh	w11, [x11, #44]
	orr	x12, x13, x12
	orr	x11, x11, #0xfffe000000000000
	stp	x11, x12, [x8, #56]
	ldr	w11, [sp, #76]                  ; 4-byte Folded Reload
	tbnz	w11, #0, LBB215_42
; %bb.29:                               ; %B78
	ldr	x14, [sp, #64]                  ; 8-byte Folded Reload
	cbz	w15, LBB215_41
LBB215_30:                              ; %B60.preheader
	mov	w9, wzr
	mov	w10, wzr
LBB215_31:                              ; %B60
                                        ; =>This Inner Loop Header: Depth=1
	add	x11, x16, w9, uxtw
	ldrb	w12, [x11]
	ldrh	w11, [x11, #2]
	tbz	w12, #0, LBB215_33
; %bb.32:                               ; %B62
                                        ;   in Loop: Header=BB215_31 Depth=1
	add	w13, w17, w11
	tst	w12, #0x2
	csel	w11, w11, w13, ne
	ldr	x11, [x1, w11, sxtw #3]
	add	w10, w10, #1
	add	w9, w9, #8
	cmp	w10, w15
	str	x11, [x19], #8
	b.lo	LBB215_31
	b	LBB215_41
LBB215_33:                              ; %B74
                                        ;   in Loop: Header=BB215_31 Depth=1
	ldr	x11, [x26, w11, uxtw #3]
	add	w10, w10, #1
	add	w9, w9, #8
	cmp	w10, w15
	str	x11, [x19], #8
	b.lo	LBB215_31
	b	LBB215_41
LBB215_34:                              ; %B104
	ldr	x8, [x9, #8]
	ldr	w8, [x8]
	asr	w8, w8, #30
	cmp	w8, #1
	b.eq	LBB215_7
	b	LBB215_40
LBB215_35:
	mov	x19, xzr
	ldr	w8, [sp, #76]                   ; 4-byte Folded Reload
	str	x16, [sp, #32]                  ; 8-byte Folded Spill
	str	x2, [x23, #48]
	tbz	w8, #0, LBB215_26
LBB215_36:                              ; %B54
	mov	x0, x24
	mov	w1, #16                         ; =0x10
	mov	w2, #1                          ; =0x1
	bl	_prim_try_malloc_gc
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	mov	x20, x0
	cbz	x20, LBB215_40
; %bb.37:                               ; %B56
	str	x2, [x23, #48]
	mov	x0, x24
	mov	w1, #88                         ; =0x58
	mov	w2, #2                          ; =0x2
	bl	_prim_try_malloc_gc
	ldp	x16, x15, [sp, #48]             ; 16-byte Folded Reload
	ldr	x1, [sp, #32]                   ; 8-byte Folded Reload
	ldr	w17, [sp, #44]                  ; 4-byte Folded Reload
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	cbz	x0, LBB215_40
; %bb.38:                               ; %B82
	ldr	x11, [sp, #8]                   ; 8-byte Folded Reload
	mov	w10, #1                         ; =0x1
	mov	x12, x0
	mov	x8, x0
	ldr	w9, [x11]
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
	ldrb	w10, [x24, #392]
	cbz	w10, LBB215_28
LBB215_39:                              ; %B59.sink.split
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	str	x12, [sp, #24]                  ; 8-byte Folded Spill
	orr	x0, x11, x8
	bl	_prim_WriteBarrierNoStore
	ldp	x8, x1, [sp, #24]               ; 16-byte Folded Reload
	mov	x9, x20
	ldp	x16, x15, [sp, #48]             ; 16-byte Folded Reload
	ldr	w17, [sp, #44]                  ; 4-byte Folded Reload
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	b	LBB215_28
LBB215_40:                              ; %B108
	ldr	x1, [sp, #88]                   ; 8-byte Folded Reload
	str	x2, [x23, #48]
	mov	x0, x24
	mov	x2, x26
	mov	x3, x23
	bl	_js_closure_gc_slowpath
	ldr	x2, [sp, #80]                   ; 8-byte Folded Reload
	ldr	x14, [sp, #64]                  ; 8-byte Folded Reload
	cmp	x0, #130
	mov	x8, x0
	b.eq	LBB215_43
LBB215_41:                              ; %B71
	str	x8, [x2], #8
	add	x19, x14, #2
	ldrb	w8, [x14, #1]
	mov	x20, x2
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #96
	br	x1
LBB215_42:                              ; %B76
Lloh22:
	adrp	x11, _js_instantiate_prototype_gc@GOTPAGE
Lloh23:
	ldr	x11, [x11, _js_instantiate_prototype_gc@GOTPAGEOFF]
	stp	x11, xzr, [x9]
	str	x9, [x10, #16]
	ldr	x14, [sp, #64]                  ; 8-byte Folded Reload
	cbnz	w15, LBB215_30
	b	LBB215_41
LBB215_43:                              ; %B109
	mov	x19, x14
	mov	x20, x2
	add	sp, sp, #96
	b	_exception_asm_h
	.loh AdrpLdrGot	Lloh22, Lloh23
                                        ; -- End function
	.private_extern	_push_empty_string_0_asm_h ; -- Begin function push_empty_string_0_asm_h
	.globl	_push_empty_string_0_asm_h
	.p2align	2
_push_empty_string_0_asm_h:             ; @push_empty_string_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	w1, #47                         ; =0x2f
	mov	w2, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB216_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB216_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_loc8_0_asm_h       ; -- Begin function get_loc8_0_asm_h
	.globl	_get_loc8_0_asm_h
	.p2align	2
_get_loc8_0_asm_h:                      ; @get_loc8_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19, #1]
	ldrb	w9, [x19], #2
	add	w8, w8, #243
	ldr	x22, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_loc8_0_asm_h       ; -- Begin function put_loc8_0_asm_h
	.globl	_put_loc8_0_asm_h
	.p2align	2
_put_loc8_0_asm_h:                      ; @put_loc8_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc8_0_asm_h       ; -- Begin function set_loc8_0_asm_h
	.globl	_set_loc8_0_asm_h
	.p2align	2
_set_loc8_0_asm_h:                      ; @set_loc8_0_asm_h
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
	.private_extern	_get_loc0_0_asm_h       ; -- Begin function get_loc0_0_asm_h
	.globl	_get_loc0_0_asm_h
	.p2align	2
_get_loc0_0_asm_h:                      ; @get_loc0_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_loc1_0_asm_h       ; -- Begin function get_loc1_0_asm_h
	.globl	_get_loc1_0_asm_h
	.p2align	2
_get_loc1_0_asm_h:                      ; @get_loc1_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27, #8]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_loc2_0_asm_h       ; -- Begin function get_loc2_0_asm_h
	.globl	_get_loc2_0_asm_h
	.p2align	2
_get_loc2_0_asm_h:                      ; @get_loc2_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27, #16]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_loc3_0_asm_h       ; -- Begin function get_loc3_0_asm_h
	.globl	_get_loc3_0_asm_h
	.p2align	2
_get_loc3_0_asm_h:                      ; @get_loc3_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x27, #24]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_loc0_0_asm_h       ; -- Begin function put_loc0_0_asm_h
	.globl	_put_loc0_0_asm_h
	.p2align	2
_put_loc0_0_asm_h:                      ; @put_loc0_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_loc1_0_asm_h       ; -- Begin function put_loc1_0_asm_h
	.globl	_put_loc1_0_asm_h
	.p2align	2
_put_loc1_0_asm_h:                      ; @put_loc1_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_loc2_0_asm_h       ; -- Begin function put_loc2_0_asm_h
	.globl	_put_loc2_0_asm_h
	.p2align	2
_put_loc2_0_asm_h:                      ; @put_loc2_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_loc3_0_asm_h       ; -- Begin function put_loc3_0_asm_h
	.globl	_put_loc3_0_asm_h
	.p2align	2
_put_loc3_0_asm_h:                      ; @put_loc3_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc0_0_asm_h       ; -- Begin function set_loc0_0_asm_h
	.globl	_set_loc0_0_asm_h
	.p2align	2
_set_loc0_0_asm_h:                      ; @set_loc0_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc1_0_asm_h       ; -- Begin function set_loc1_0_asm_h
	.globl	_set_loc1_0_asm_h
	.p2align	2
_set_loc1_0_asm_h:                      ; @set_loc1_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc2_0_asm_h       ; -- Begin function set_loc2_0_asm_h
	.globl	_set_loc2_0_asm_h
	.p2align	2
_set_loc2_0_asm_h:                      ; @set_loc2_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc3_0_asm_h       ; -- Begin function set_loc3_0_asm_h
	.globl	_set_loc3_0_asm_h
	.p2align	2
_set_loc3_0_asm_h:                      ; @set_loc3_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_arg0_0_asm_h       ; -- Begin function get_arg0_0_asm_h
	.globl	_get_arg0_0_asm_h
	.p2align	2
_get_arg0_0_asm_h:                      ; @get_arg0_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_arg1_0_asm_h       ; -- Begin function get_arg1_0_asm_h
	.globl	_get_arg1_0_asm_h
	.p2align	2
_get_arg1_0_asm_h:                      ; @get_arg1_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28, #8]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_arg2_0_asm_h       ; -- Begin function get_arg2_0_asm_h
	.globl	_get_arg2_0_asm_h
	.p2align	2
_get_arg2_0_asm_h:                      ; @get_arg2_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28, #16]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_arg3_0_asm_h       ; -- Begin function get_arg3_0_asm_h
	.globl	_get_arg3_0_asm_h
	.p2align	2
_get_arg3_0_asm_h:                      ; @get_arg3_0_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x22, [x28, #24]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_arg0_0_asm_h       ; -- Begin function put_arg0_0_asm_h
	.globl	_put_arg0_0_asm_h
	.p2align	2
_put_arg0_0_asm_h:                      ; @put_arg0_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_arg1_0_asm_h       ; -- Begin function put_arg1_0_asm_h
	.globl	_put_arg1_0_asm_h
	.p2align	2
_put_arg1_0_asm_h:                      ; @put_arg1_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_arg2_0_asm_h       ; -- Begin function put_arg2_0_asm_h
	.globl	_put_arg2_0_asm_h
	.p2align	2
_put_arg2_0_asm_h:                      ; @put_arg2_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_arg3_0_asm_h       ; -- Begin function put_arg3_0_asm_h
	.globl	_put_arg3_0_asm_h
	.p2align	2
_put_arg3_0_asm_h:                      ; @put_arg3_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_arg0_0_asm_h       ; -- Begin function set_arg0_0_asm_h
	.globl	_set_arg0_0_asm_h
	.p2align	2
_set_arg0_0_asm_h:                      ; @set_arg0_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_arg1_0_asm_h       ; -- Begin function set_arg1_0_asm_h
	.globl	_set_arg1_0_asm_h
	.p2align	2
_set_arg1_0_asm_h:                      ; @set_arg1_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_arg2_0_asm_h       ; -- Begin function set_arg2_0_asm_h
	.globl	_set_arg2_0_asm_h
	.p2align	2
_set_arg2_0_asm_h:                      ; @set_arg2_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_arg3_0_asm_h       ; -- Begin function set_arg3_0_asm_h
	.globl	_set_arg3_0_asm_h
	.p2align	2
_set_arg3_0_asm_h:                      ; @set_arg3_0_asm_h
; %bb.0:                                ; %B0
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_var_ref0_0_asm_h   ; -- Begin function get_var_ref0_0_asm_h
	.globl	_get_var_ref0_0_asm_h
	.p2align	2
_get_var_ref0_0_asm_h:                  ; @get_var_ref0_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x22, [x8]
	br	x1
                                        ; -- End function
	.private_extern	_get_var_ref1_0_asm_h   ; -- Begin function get_var_ref1_0_asm_h
	.globl	_get_var_ref1_0_asm_h
	.p2align	2
_get_var_ref1_0_asm_h:                  ; @get_var_ref1_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #8]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x22, [x8]
	br	x1
                                        ; -- End function
	.private_extern	_get_var_ref2_0_asm_h   ; -- Begin function get_var_ref2_0_asm_h
	.globl	_get_var_ref2_0_asm_h
	.p2align	2
_get_var_ref2_0_asm_h:                  ; @get_var_ref2_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #16]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x22, [x8]
	br	x1
                                        ; -- End function
	.private_extern	_get_var_ref3_0_asm_h   ; -- Begin function get_var_ref3_0_asm_h
	.globl	_get_var_ref3_0_asm_h
	.p2align	2
_get_var_ref3_0_asm_h:                  ; @get_var_ref3_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #24]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x22, [x8]
	br	x1
                                        ; -- End function
	.private_extern	_put_var_ref0_0_asm_h   ; -- Begin function put_var_ref0_0_asm_h
	.globl	_put_var_ref0_0_asm_h
	.p2align	2
_put_var_ref0_0_asm_h:                  ; @put_var_ref0_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_var_ref1_0_asm_h   ; -- Begin function put_var_ref1_0_asm_h
	.globl	_put_var_ref1_0_asm_h
	.p2align	2
_put_var_ref1_0_asm_h:                  ; @put_var_ref1_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #8]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_var_ref2_0_asm_h   ; -- Begin function put_var_ref2_0_asm_h
	.globl	_put_var_ref2_0_asm_h
	.p2align	2
_put_var_ref2_0_asm_h:                  ; @put_var_ref2_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #16]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_var_ref3_0_asm_h   ; -- Begin function put_var_ref3_0_asm_h
	.globl	_put_var_ref3_0_asm_h
	.p2align	2
_put_var_ref3_0_asm_h:                  ; @put_var_ref3_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #24]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_var_ref0_0_asm_h   ; -- Begin function set_var_ref0_0_asm_h
	.globl	_set_var_ref0_0_asm_h
	.p2align	2
_set_var_ref0_0_asm_h:                  ; @set_var_ref0_0_asm_h
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
	.private_extern	_set_var_ref1_0_asm_h   ; -- Begin function set_var_ref1_0_asm_h
	.globl	_set_var_ref1_0_asm_h
	.p2align	2
_set_var_ref1_0_asm_h:                  ; @set_var_ref1_0_asm_h
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
	.private_extern	_set_var_ref2_0_asm_h   ; -- Begin function set_var_ref2_0_asm_h
	.globl	_set_var_ref2_0_asm_h
	.p2align	2
_set_var_ref2_0_asm_h:                  ; @set_var_ref2_0_asm_h
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
	.private_extern	_set_var_ref3_0_asm_h   ; -- Begin function set_var_ref3_0_asm_h
	.globl	_set_var_ref3_0_asm_h
	.p2align	2
_set_var_ref3_0_asm_h:                  ; @set_var_ref3_0_asm_h
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
	.private_extern	_get_length_0_asm_h     ; -- Begin function get_length_0_asm_h
	.globl	_get_length_0_asm_h
	.p2align	2
_get_length_0_asm_h:                    ; @get_length_0_asm_h
; %bb.0:                                ; %B27
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #1, lsl #48
	and	x9, x22, #0xffff000000000003
	cmp	x9, x8
	mov	x8, #-281474976710653           ; =0xffff000000000003
	ccmp	x9, x8, #4, ne
	b.ne	LBB256_2
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
LBB256_2:                               ; %B21
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB256_12
; %bb.3:                                ; %B22
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB256_4:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB256_5 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w11, #0x30
	ldr	w10, [x13, w10, uxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB256_7
LBB256_5:                               ; %B1
                                        ;   Parent Loop BB256_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, #48
	b.eq	LBB256_9
; %bb.6:                                ; %B9
                                        ;   in Loop: Header=BB256_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB256_5
LBB256_7:                               ; %B14
                                        ;   in Loop: Header=BB256_4 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB256_12
; %bb.8:                                ; %B17
                                        ;   in Loop: Header=BB256_4 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB256_4
	b	LBB256_11
LBB256_9:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB256_12
; %bb.10:                               ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB256_11:                              ; %B6
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB256_12:                              ; %B24
	mov	x0, x24
	mov	x1, x22
	mov	w2, #48                         ; =0x30
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB256_14
; %bb.13:                               ; %B26
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB256_14:                              ; %B25
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_if_false8_0_asm_h      ; -- Begin function if_false8_0_asm_h
	.globl	_if_false8_0_asm_h
	.p2align	2
_if_false8_0_asm_h:                     ; @if_false8_0_asm_h
; %bb.0:                                ; %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	LBB257_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB257_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB257_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB257_6
	b	LBB257_7
LBB257_4:                               ; %B23
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.eq	LBB257_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB257_7
LBB257_6:                               ; %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB257_7:                               ; %B9
	mov	x9, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x9
	b.hs	LBB257_13
; %bb.8:                                ; %B11
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.lo	LBB257_10
LBB257_9:                               ; %B19
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB257_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB257_13
; %bb.11:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB257_6
	b.vs	LBB257_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB257_9
	b	LBB257_6
LBB257_13:                              ; %B15
	mov	x20, x8
	mov	x0, x22
	b	_SlowToBoolean_asm_h
                                        ; -- End function
	.private_extern	_if_true8_0_asm_h       ; -- Begin function if_true8_0_asm_h
	.globl	_if_true8_0_asm_h
	.p2align	2
_if_true8_0_asm_h:                      ; @if_true8_0_asm_h
; %bb.0:                                ; %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	LBB258_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB258_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB258_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB258_6
	b	LBB258_7
LBB258_4:                               ; %B23
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.eq	LBB258_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB258_7
LBB258_6:                               ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB258_7:                               ; %B9
	mov	x9, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x9
	b.hs	LBB258_13
; %bb.8:                                ; %B11
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.lo	LBB258_10
LBB258_9:                               ; %B19
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB258_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB258_13
; %bb.11:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB258_6
	b.vs	LBB258_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB258_9
	b	LBB258_6
LBB258_13:                              ; %B15
	mov	x20, x8
	mov	x0, x22
	b	_SlowToBoolean_asm_h
                                        ; -- End function
	.private_extern	_goto8_0_asm_h          ; -- Begin function goto8_0_asm_h
	.globl	_goto8_0_asm_h
	.p2align	2
_goto8_0_asm_h:                         ; @goto8_0_asm_h
; %bb.0:                                ; %B0
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_goto16_0_asm_h         ; -- Begin function goto16_0_asm_h
	.globl	_goto16_0_asm_h
	.p2align	2
_goto16_0_asm_h:                        ; @goto16_0_asm_h
; %bb.0:                                ; %B0
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_call0_0_asm_h          ; -- Begin function call0_0_asm_h
	.globl	_call0_0_asm_h
	.p2align	2
_call0_0_asm_h:                         ; @call0_0_asm_h
; %bb.0:                                ; %B2
	str	x19, [x23, #32]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	str	x20, [x23, #48]
	mov	x0, xzr
	ldur	x22, [x20, #-8]
	bl	_common_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #104]
	b.eq	LBB261_2
; %bb.1:                                ; %B4
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB261_2:                               ; %B3
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_call1_0_asm_h          ; -- Begin function call1_0_asm_h
	.globl	_call1_0_asm_h
	.p2align	2
_call1_0_asm_h:                         ; @call1_0_asm_h
; %bb.0:                                ; %B2
	str	x19, [x23, #32]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	str	x20, [x23, #48]
	mov	w0, #1                          ; =0x1
	ldur	x22, [x20, #-16]
	sub	x20, x20, #8
	bl	_common_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #104]
	b.eq	LBB262_2
; %bb.1:                                ; %B4
	stur	x0, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB262_2:                               ; %B3
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_call2_0_asm_h          ; -- Begin function call2_0_asm_h
	.globl	_call2_0_asm_h
	.p2align	2
_call2_0_asm_h:                         ; @call2_0_asm_h
; %bb.0:                                ; %B2
	str	x19, [x23, #32]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	str	x20, [x23, #48]
	mov	w0, #2                          ; =0x2
	ldur	x22, [x20, #-24]
	sub	x20, x20, #16
	bl	_common_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #104]
	b.eq	LBB263_2
; %bb.1:                                ; %B4
	stur	x0, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB263_2:                               ; %B3
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_call3_0_asm_h          ; -- Begin function call3_0_asm_h
	.globl	_call3_0_asm_h
	.p2align	2
_call3_0_asm_h:                         ; @call3_0_asm_h
; %bb.0:                                ; %B2
	str	x19, [x23, #32]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	str	x20, [x23, #48]
	mov	w0, #3                          ; =0x3
	ldur	x22, [x20, #-32]
	sub	x20, x20, #24
	bl	_common_call_asm_h
	ldp	x27, x19, [x23, #24]
	cmp	x0, #130
	ldr	x20, [x23, #48]
	ldr	x28, [x23, #16]
	ldr	x26, [x23, #104]
	b.eq	LBB264_2
; %bb.1:                                ; %B4
	stur	x0, [x20, #-32]
	sub	x20, x20, #24
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB264_2:                               ; %B3
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_is_undefined_0_asm_h   ; -- Begin function is_undefined_0_asm_h
	.globl	_is_undefined_0_asm_h
	.p2align	2
_is_undefined_0_asm_h:                  ; @is_undefined_0_asm_h
; %bb.0:                                ; %B2
	ldur	x22, [x20, #-8]
	cmp	x22, #18
	b.ne	LBB265_2
; %bb.1:                                ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB265_2:                               ; %B5
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_is_null_0_asm_h        ; -- Begin function is_null_0_asm_h
	.globl	_is_null_0_asm_h
	.p2align	2
_is_null_0_asm_h:                       ; @is_null_0_asm_h
; %bb.0:                                ; %B2
	ldur	x22, [x20, #-8]
	cmp	x22, #2
	b.ne	LBB266_2
; %bb.1:                                ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB266_2:                               ; %B5
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_is_function_0_asm_h    ; -- Begin function is_function_0_asm_h
	.globl	_is_function_0_asm_h
	.p2align	2
_is_function_0_asm_h:                   ; @is_function_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	mov	x1, x22
	bl	_js_operator_typeof_gc
	cmp	w0, #27
	b.ne	LBB267_2
; %bb.1:                                ; %B2
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB267_2:                               ; %B5
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_inc_coverage_0_asm_h   ; -- Begin function inc_coverage_0_asm_h
	.globl	_inc_coverage_0_asm_h
	.p2align	2
_inc_coverage_0_asm_h:                  ; @inc_coverage_0_asm_h
; %bb.0:                                ; %B10
	ldr	x8, [x23, #8]
	ldr	x1, [x8, #32]
	ldr	x8, [x1, #112]
	cbz	x8, LBB268_3
; %bb.1:                                ; %B7
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbnz	x8, LBB268_4
LBB268_2:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB268_3:                               ; %B11
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_EnsureCoverageCounters
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbz	x8, LBB268_2
LBB268_4:                               ; %B2
	ldr	w9, [x19]
	ldr	w10, [x10, #104]
	cmp	w9, w10
	b.hs	LBB268_2
; %bb.5:                                ; %B6
	ldr	w10, [x8, w9, sxtw #2]
	add	w10, w10, #1
	str	w10, [x8, w9, sxtw #2]
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_invalid_1_asm_h        ; -- Begin function invalid_1_asm_h
	.globl	_invalid_1_asm_h
	.p2align	2
_invalid_1_asm_h:                       ; @invalid_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x23, #8]
	mov	x0, x24
Lloh24:
	adrp	x1, l___unnamed_11@PAGE
Lloh25:
	add	x1, x1, l___unnamed_11@PAGEOFF
	ldr	x8, [x8, #32]
	ldr	x8, [x8, #8]
	str	x20, [x23, #48]
	mvn	x8, x8
	add	x8, x8, x19
	stp	x8, xzr, [sp, #-16]!
	bl	_LEPUS_ThrowInternalError
	add	sp, sp, #16
	b	_exception_asm_h
	.loh AdrpAdd	Lloh24, Lloh25
                                        ; -- End function
	.private_extern	_push_i32_1_asm_h       ; -- Begin function push_i32_1_asm_h
	.globl	_push_i32_1_asm_h
	.p2align	2
_push_i32_1_asm_h:                      ; @push_i32_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19, #4]
	ldr	w9, [x19], #5
	add	w8, w8, #486
	orr	x21, x9, #0xfffe000000000000
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_const_1_asm_h     ; -- Begin function push_const_1_asm_h
	.globl	_push_const_1_asm_h
	.p2align	2
_push_const_1_asm_h:                    ; @push_const_1_asm_h
; %bb.0:                                ; %B3
	sub	sp, sp, #16
	ldr	x8, [x23, #112]
	ldrsw	x9, [x19]
	ldr	w10, [x24, #336]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, LBB271_2
; %bb.1:                                ; %B4
	mov	x8, x20
	mov	x0, x24
	mov	x2, x19
	str	x22, [x8], #8
	str	x8, [x23, #48]
	str	x1, [sp, #8]                    ; 8-byte Folded Spill
	bl	_DebuggerPause
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
LBB271_2:                               ; %B1
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
                                        ; -- End function
	.private_extern	_fclosure_1_asm_h       ; -- Begin function fclosure_1_asm_h
	.globl	_fclosure_1_asm_h
	.p2align	2
_fclosure_1_asm_h:                      ; @fclosure_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_fclosure_0_asm_h
                                        ; -- End function
	.private_extern	_push_atom_value_1_asm_h ; -- Begin function push_atom_value_1_asm_h
	.globl	_push_atom_value_1_asm_h
	.p2align	2
_push_atom_value_1_asm_h:               ; @push_atom_value_1_asm_h
; %bb.0:                                ; %B13
	ldr	w1, [x19]
	tbnz	w1, #31, LBB273_5
; %bb.1:                                ; %B1
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, sxtw #3]
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, LBB273_4
; %bb.2:                                ; %B9
	ldr	w9, [x8, #8]
	asr	w9, w9, #30
	cmp	w9, #1
	b.ne	LBB273_5
LBB273_3:                               ; %B7
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	mov	x9, #2                          ; =0x2
	movk	x9, #1, lsl #48
	orr	x21, x8, x9
	br	x1
LBB273_4:                               ; %B2
	ldr	x9, [x8, #8]
	ldr	w9, [x9]
	asr	w9, w9, #30
	cmp	w9, #1
	b.eq	LBB273_3
LBB273_5:                               ; %B10
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB273_7
; %bb.6:                                ; %B12
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB273_7:                               ; %B11
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_private_symbol_1_asm_h ; -- Begin function private_symbol_1_asm_h
	.globl	_private_symbol_1_asm_h
	.p2align	2
_private_symbol_1_asm_h:                ; @private_symbol_1_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #4                          ; =0x4
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	LBB274_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB274_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_undefined_1_asm_h      ; -- Begin function undefined_1_asm_h
	.globl	_undefined_1_asm_h
	.p2align	2
_undefined_1_asm_h:                     ; @undefined_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	w21, #18                        ; =0x12
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_null_1_asm_h           ; -- Begin function null_1_asm_h
	.globl	_null_1_asm_h
	.p2align	2
_null_1_asm_h:                          ; @null_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	w21, #2                         ; =0x2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_this_1_asm_h      ; -- Begin function push_this_1_asm_h
	.globl	_push_this_1_asm_h
	.p2align	2
_push_this_1_asm_h:                     ; @push_this_1_asm_h
; %bb.0:                                ; %B12
	ldr	w8, [x23, #44]
	ldr	x1, [x23, #88]
	tbnz	w8, #0, LBB277_2
; %bb.1:                                ; %B12
	ldr	x8, [x23, #88]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, LBB277_3
LBB277_2:                               ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
LBB277_3:                               ; %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	LBB277_5
; %bb.4:                                ; %B7
	ldrb	w8, [x19], #1
	ldr	x21, [x24, #208]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB277_5:                               ; %B9
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB277_7
; %bb.6:                                ; %B11
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB277_7:                               ; %B10
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_push_false_1_asm_h     ; -- Begin function push_false_1_asm_h
	.globl	_push_false_1_asm_h
	.p2align	2
_push_false_1_asm_h:                    ; @push_false_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	w21, #6                         ; =0x6
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_true_1_asm_h      ; -- Begin function push_true_1_asm_h
	.globl	_push_true_1_asm_h
	.p2align	2
_push_true_1_asm_h:                     ; @push_true_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	w21, #7                         ; =0x7
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_object_1_asm_h         ; -- Begin function object_1_asm_h
	.globl	_object_1_asm_h
	.p2align	2
_object_1_asm_h:                        ; @object_1_asm_h
; %bb.0:                                ; %B16
	ldrb	w8, [x24, #371]
	stp	x19, x20, [sp, #-16]!           ; 16-byte Folded Spill
	cbnz	w8, LBB280_5
; %bb.1:                                ; %B1
	ldr	x19, [x24, #408]
	cbz	x19, LBB280_5
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
	cbz	x9, LBB280_5
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
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB280_7
LBB280_4:                               ; %B9
	add	x8, x9, #32
	ldr	x19, [sp]                       ; 8-byte Folded Reload
	mov	x21, x9
	str	x8, [x9, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB280_5:                               ; %B13
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	LBB280_8
; %bb.6:                                ; %B15
	ldp	x19, x20, [sp]                  ; 16-byte Folded Reload
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB280_7:                               ; %B11
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x19, x8
	mov	x19, x9
	bl	_prim_WriteBarrierNoStore
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x9, x19
	b	LBB280_4
LBB280_8:                               ; %B14
	ldp	x19, x20, [sp], #16             ; 16-byte Folded Reload
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_special_object_1_asm_h ; -- Begin function special_object_1_asm_h
	.globl	_special_object_1_asm_h
	.p2align	2
_special_object_1_asm_h:                ; @special_object_1_asm_h
; %bb.0:                                ; %B12
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	LBB281_5
; %bb.1:                                ; %B12
	cbz	w8, LBB281_8
; %bb.2:                                ; %B12
	cmp	w8, #1
	b.ne	LBB281_10
; %bb.3:                                ; %B2
	ldr	x8, [x23, #8]
	ldr	w1, [x23, #120]
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
	bl	_js_build_mapped_arguments_gc
	cmp	x0, #130
	b.eq	LBB281_12
LBB281_4:
	mov	x8, x0
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB281_5:                               ; %B12
	cmp	w8, #3
	b.eq	LBB281_9
; %bb.6:                                ; %B12
	cmp	w8, #4
	b.ne	LBB281_11
; %bb.7:                                ; %B6
	ldr	x8, [x23, #8]
	mov	w9, #18                         ; =0x12
	ldr	x8, [x8, #48]
	cmp	x8, #0
	csel	x8, x9, x8, eq
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB281_8:                               ; %B13
	str	x22, [x20], #8
	b	_FastBuildArguments_asm_h
LBB281_9:                               ; %B16
	ldr	x8, [x23, #96]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB281_10:                              ; %B15
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB281_11:                              ; %B9
	mov	x8, x20
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.ne	LBB281_4
LBB281_12:                              ; %B10
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_rest_1_asm_h           ; -- Begin function rest_1_asm_h
	.globl	_rest_1_asm_h
	.p2align	2
_rest_1_asm_h:                          ; @rest_1_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x23, #120]
	ldrh	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x3, x28
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_js_build_rest_gc
	cmp	x0, #130
	b.eq	LBB282_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB282_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_drop_1_asm_h           ; -- Begin function drop_1_asm_h
	.globl	_drop_1_asm_h
	.p2align	2
_drop_1_asm_h:                          ; @drop_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_nip_1_asm_h            ; -- Begin function nip_1_asm_h
	.globl	_nip_1_asm_h
	.p2align	2
_nip_1_asm_h:                           ; @nip_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_nip1_1_asm_h           ; -- Begin function nip1_1_asm_h
	.globl	_nip1_1_asm_h
	.p2align	2
_nip1_1_asm_h:                          ; @nip1_1_asm_h
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
	.private_extern	_dup_1_asm_h            ; -- Begin function dup_1_asm_h
	.globl	_dup_1_asm_h
	.p2align	2
_dup_1_asm_h:                           ; @dup_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, x22
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_dup1_1_asm_h           ; -- Begin function dup1_1_asm_h
	.globl	_dup1_1_asm_h
	.p2align	2
_dup1_1_asm_h:                          ; @dup1_1_asm_h
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
	.private_extern	_dup2_1_asm_h           ; -- Begin function dup2_1_asm_h
	.globl	_dup2_1_asm_h
	.p2align	2
_dup2_1_asm_h:                          ; @dup2_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20]
	mov	x21, x22
	ldrb	w8, [x19], #1
	ldr	x22, [x20], #8
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_dup3_1_asm_h           ; -- Begin function dup3_1_asm_h
	.globl	_dup3_1_asm_h
	.p2align	2
_dup3_1_asm_h:                          ; @dup3_1_asm_h
; %bb.0:                                ; %B0
	ldur	x8, [x20, #-16]
	mov	x21, x22
	stp	x22, x8, [x20], #16
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_insert2_1_asm_h        ; -- Begin function insert2_1_asm_h
	.globl	_insert2_1_asm_h
	.p2align	2
_insert2_1_asm_h:                       ; @insert2_1_asm_h
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
	.private_extern	_insert3_1_asm_h        ; -- Begin function insert3_1_asm_h
	.globl	_insert3_1_asm_h
	.p2align	2
_insert3_1_asm_h:                       ; @insert3_1_asm_h
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
	.private_extern	_insert4_1_asm_h        ; -- Begin function insert4_1_asm_h
	.globl	_insert4_1_asm_h
	.p2align	2
_insert4_1_asm_h:                       ; @insert4_1_asm_h
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
	.private_extern	_perm3_1_asm_h          ; -- Begin function perm3_1_asm_h
	.globl	_perm3_1_asm_h
	.p2align	2
_perm3_1_asm_h:                         ; @perm3_1_asm_h
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
	.private_extern	_perm4_1_asm_h          ; -- Begin function perm4_1_asm_h
	.globl	_perm4_1_asm_h
	.p2align	2
_perm4_1_asm_h:                         ; @perm4_1_asm_h
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
	.private_extern	_perm5_1_asm_h          ; -- Begin function perm5_1_asm_h
	.globl	_perm5_1_asm_h
	.p2align	2
_perm5_1_asm_h:                         ; @perm5_1_asm_h
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
	.private_extern	_swap_1_asm_h           ; -- Begin function swap_1_asm_h
	.globl	_swap_1_asm_h
	.p2align	2
_swap_1_asm_h:                          ; @swap_1_asm_h
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
	.private_extern	_swap2_1_asm_h          ; -- Begin function swap2_1_asm_h
	.globl	_swap2_1_asm_h
	.p2align	2
_swap2_1_asm_h:                         ; @swap2_1_asm_h
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
	.private_extern	_rot3l_1_asm_h          ; -- Begin function rot3l_1_asm_h
	.globl	_rot3l_1_asm_h
	.p2align	2
_rot3l_1_asm_h:                         ; @rot3l_1_asm_h
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
	.private_extern	_rot3r_1_asm_h          ; -- Begin function rot3r_1_asm_h
	.globl	_rot3r_1_asm_h
	.p2align	2
_rot3r_1_asm_h:                         ; @rot3r_1_asm_h
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
	.private_extern	_rot4l_1_asm_h          ; -- Begin function rot4l_1_asm_h
	.globl	_rot4l_1_asm_h
	.p2align	2
_rot4l_1_asm_h:                         ; @rot4l_1_asm_h
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
	.private_extern	_rot5l_1_asm_h          ; -- Begin function rot5l_1_asm_h
	.globl	_rot5l_1_asm_h
	.p2align	2
_rot5l_1_asm_h:                         ; @rot5l_1_asm_h
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
	.private_extern	_call_constructor_1_asm_h ; -- Begin function call_constructor_1_asm_h
	.globl	_call_constructor_1_asm_h
	.p2align	2
_call_constructor_1_asm_h:              ; @call_constructor_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_call_constructor_0_asm_h
                                        ; -- End function
	.private_extern	_call_1_asm_h           ; -- Begin function call_1_asm_h
	.globl	_call_1_asm_h
	.p2align	2
_call_1_asm_h:                          ; @call_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_call_0_asm_h
                                        ; -- End function
	.private_extern	_tail_call_1_asm_h      ; -- Begin function tail_call_1_asm_h
	.globl	_tail_call_1_asm_h
	.p2align	2
_tail_call_1_asm_h:                     ; @tail_call_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_tail_call_0_asm_h
                                        ; -- End function
	.private_extern	_call_method_1_asm_h    ; -- Begin function call_method_1_asm_h
	.globl	_call_method_1_asm_h
	.p2align	2
_call_method_1_asm_h:                   ; @call_method_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_call_method_0_asm_h
                                        ; -- End function
	.private_extern	_tail_call_method_1_asm_h ; -- Begin function tail_call_method_1_asm_h
	.globl	_tail_call_method_1_asm_h
	.p2align	2
_tail_call_method_1_asm_h:              ; @tail_call_method_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_tail_call_method_0_asm_h
                                        ; -- End function
	.private_extern	_array_from_1_asm_h     ; -- Begin function array_from_1_asm_h
	.globl	_array_from_1_asm_h
	.p2align	2
_array_from_1_asm_h:                    ; @array_from_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_array_from_0_asm_h
                                        ; -- End function
	.private_extern	_apply_1_asm_h          ; -- Begin function apply_1_asm_h
	.globl	_apply_1_asm_h
	.p2align	2
_apply_1_asm_h:                         ; @apply_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_apply_0_asm_h
                                        ; -- End function
	.private_extern	_return_1_asm_h         ; -- Begin function return_1_asm_h
	.globl	_return_1_asm_h
	.p2align	2
_return_1_asm_h:                        ; @return_1_asm_h
; %bb.0:                                ; %B0
	mov	x0, x22
	b	_common_return_asm_h
                                        ; -- End function
	.private_extern	_return_undef_1_asm_h   ; -- Begin function return_undef_1_asm_h
	.globl	_return_undef_1_asm_h
	.p2align	2
_return_undef_1_asm_h:                  ; @return_undef_1_asm_h
; %bb.0:                                ; %B0
	mov	w0, #18                         ; =0x12
	b	_common_return_asm_h
                                        ; -- End function
	.private_extern	_check_ctor_return_1_asm_h ; -- Begin function check_ctor_return_1_asm_h
	.globl	_check_ctor_return_1_asm_h
	.p2align	2
_check_ctor_return_1_asm_h:             ; @check_ctor_return_1_asm_h
; %bb.0:                                ; %B5
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	LBB311_3
; %bb.1:                                ; %B2
	cmp	x22, #18
	b.eq	LBB311_4
; %bb.2:                                ; %B3
	mov	x8, x20
Lloh26:
	adrp	x1, l___unnamed_12@PAGE
Lloh27:
	add	x1, x1, l___unnamed_12@PAGEOFF
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_LEPUS_ThrowTypeError
	b	_exception_spill_top0_asm_h
LBB311_3:                               ; %B6
	ldrb	w8, [x19], #1
	mov	w21, #6                         ; =0x6
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB311_4:                               ; %B4
	ldrb	w8, [x19], #1
	mov	w21, #7                         ; =0x7
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh26, Lloh27
                                        ; -- End function
	.private_extern	_check_ctor_1_asm_h     ; -- Begin function check_ctor_1_asm_h
	.globl	_check_ctor_1_asm_h
	.p2align	2
_check_ctor_1_asm_h:                    ; @check_ctor_1_asm_h
; %bb.0:                                ; %B2
	ldr	x8, [x23, #96]
	cmp	x8, #18
	b.ne	LBB312_2
; %bb.1:                                ; %B3
	mov	x8, x20
Lloh28:
	adrp	x1, l___unnamed_13@PAGE
Lloh29:
	add	x1, x1, l___unnamed_13@PAGEOFF
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_LEPUS_ThrowTypeError
	b	_exception_spill_top0_asm_h
LBB312_2:                               ; %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh28, Lloh29
                                        ; -- End function
	.private_extern	_check_brand_1_asm_h    ; -- Begin function check_brand_1_asm_h
	.globl	_check_brand_1_asm_h
	.p2align	2
_check_brand_1_asm_h:                   ; @check_brand_1_asm_h
; %bb.0:                                ; %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #48]
	bl	_JS_CheckBrand_GC
	tbnz	w0, #31, LBB313_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB313_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_add_brand_1_asm_h      ; -- Begin function add_brand_1_asm_h
	.globl	_add_brand_1_asm_h
	.p2align	2
_add_brand_1_asm_h:                     ; @add_brand_1_asm_h
; %bb.0:                                ; %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #48]
	bl	_JS_AddBrand_GC
	tbnz	w0, #31, LBB314_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB314_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_return_async_1_asm_h   ; -- Begin function return_async_1_asm_h
	.globl	_return_async_1_asm_h
	.p2align	2
_return_async_1_asm_h:                  ; @return_async_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_return_async_0_asm_h
                                        ; -- End function
	.private_extern	_throw_1_asm_h          ; -- Begin function throw_1_asm_h
	.globl	_throw_1_asm_h
	.p2align	2
_throw_1_asm_h:                         ; @throw_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_throw_0_asm_h
                                        ; -- End function
	.private_extern	_throw_var_1_asm_h      ; -- Begin function throw_var_1_asm_h
	.globl	_throw_var_1_asm_h
	.p2align	2
_throw_var_1_asm_h:                     ; @throw_var_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_throw_var_0_asm_h
                                        ; -- End function
	.private_extern	_eval_1_asm_h           ; -- Begin function eval_1_asm_h
	.globl	_eval_1_asm_h
	.p2align	2
_eval_1_asm_h:                          ; @eval_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_eval_0_asm_h
                                        ; -- End function
	.private_extern	_regexp_1_asm_h         ; -- Begin function regexp_1_asm_h
	.globl	_regexp_1_asm_h
	.p2align	2
_regexp_1_asm_h:                        ; @regexp_1_asm_h
; %bb.0:                                ; %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	w1, #18                         ; =0x12
	mov	x3, x21
	mov	x2, x22
	str	x21, [x20]
	str	x8, [x23, #48]
	bl	_js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	LBB319_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB319_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_get_super_ctor_1_asm_h ; -- Begin function get_super_ctor_1_asm_h
	.globl	_get_super_ctor_1_asm_h
	.p2align	2
_get_super_ctor_1_asm_h:                ; @get_super_ctor_1_asm_h
; %bb.0:                                ; %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	LBB320_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB320_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_get_super_1_asm_h      ; -- Begin function get_super_1_asm_h
	.globl	_get_super_1_asm_h
	.p2align	2
_get_super_1_asm_h:                     ; @get_super_1_asm_h
; %bb.0:                                ; %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPrototype_GC
	cmp	x0, #130
	b.eq	LBB321_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB321_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_import_1_asm_h         ; -- Begin function import_1_asm_h
	.globl	_import_1_asm_h
	.p2align	2
_import_1_asm_h:                        ; @import_1_asm_h
; %bb.0:                                ; %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_js_dynamic_import
	cmp	x0, #130
	b.eq	LBB322_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB322_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_check_var_1_asm_h      ; -- Begin function check_var_1_asm_h
	.globl	_check_var_1_asm_h
	.p2align	2
_check_var_1_asm_h:                     ; @check_var_1_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_CheckGlobalVar_GC
	tbnz	w0, #31, LBB323_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x21, x8, ne
	br	x1
LBB323_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_get_var_undef_1_asm_h  ; -- Begin function get_var_undef_1_asm_h
	.globl	_get_var_undef_1_asm_h
	.p2align	2
_get_var_undef_1_asm_h:                 ; @get_var_undef_1_asm_h
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
	cbz	w11, LBB324_3
LBB324_1:                               ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB324_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB324_1 Depth=1
	ldr	w11, [x12]
	and	w11, w11, #0x3ffffff
	cbnz	w11, LBB324_1
LBB324_3:                               ; %B11
	ldr	x8, [x24, #208]
	mov	w10, #18                        ; =0x12
LBB324_4:                               ; %B33
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB324_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w9, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB324_7
LBB324_5:                               ; %B22
                                        ;   Parent Loop BB324_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w9
	b.eq	LBB324_9
; %bb.6:                                ; %B24
                                        ;   in Loop: Header=BB324_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB324_5
LBB324_7:                               ; %B27
                                        ;   in Loop: Header=BB324_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	LBB324_13
; %bb.8:                                ; %B30
                                        ;   in Loop: Header=BB324_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB324_4
	b	LBB324_11
LBB324_9:                               ; %B12
	lsr	w9, w13, #26
	tst	w9, #0x30
	b.ne	LBB324_13
LBB324_10:                              ; %B7.sink.split
	ldr	x8, [x8, #16]
	sub	w9, w11, #1
	ldr	x10, [x8, w9, sxtw #3]
LBB324_11:                              ; %B7
	cmp	x10, #34
	b.eq	LBB324_15
; %bb.12:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x10
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB324_13:                              ; %B17
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB324_16
; %bb.14:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB324_15:                              ; %B3
	str	x22, [x20], #8
	b	_ThrowReferenceErrorUninitialized_asm_h
LBB324_16:                              ; %B18
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_get_var_1_asm_h        ; -- Begin function get_var_1_asm_h
	.globl	_get_var_1_asm_h
	.p2align	2
_get_var_1_asm_h:                       ; @get_var_1_asm_h
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
	cbz	w10, LBB325_3
LBB325_1:                               ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB325_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB325_1 Depth=1
	ldr	w10, [x12]
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB325_1
LBB325_3:                               ; %B11
	ldr	x8, [x24, #208]
LBB325_4:                               ; %B32
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB325_5 Depth 2
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w9, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB325_7
LBB325_5:                               ; %B21
                                        ;   Parent Loop BB325_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	LBB325_9
; %bb.6:                                ; %B23
                                        ;   in Loop: Header=BB325_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB325_5
LBB325_7:                               ; %B26
                                        ;   in Loop: Header=BB325_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB325_12
; %bb.8:                                ; %B29
                                        ;   in Loop: Header=BB325_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB325_4
	b	LBB325_12
LBB325_9:                               ; %B12
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	LBB325_12
LBB325_10:                              ; %B7
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	LBB325_14
; %bb.11:                               ; %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB325_12:                              ; %B16
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB325_15
; %bb.13:                               ; %B18
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB325_14:                              ; %B3
	str	x22, [x20], #8
	b	_ThrowReferenceErrorUninitialized_asm_h
LBB325_15:                              ; %B17
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_put_var_1_asm_h        ; -- Begin function put_var_1_asm_h
	.globl	_put_var_1_asm_h
	.p2align	2
_put_var_1_asm_h:                       ; @put_var_1_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	w3, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB326_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB326_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_put_var_init_1_asm_h   ; -- Begin function put_var_init_1_asm_h
	.globl	_put_var_init_1_asm_h
	.p2align	2
_put_var_init_1_asm_h:                  ; @put_var_init_1_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	w3, #1                          ; =0x1
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB327_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB327_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_put_var_strict_1_asm_h ; -- Begin function put_var_strict_1_asm_h
	.globl	_put_var_strict_1_asm_h
	.p2align	2
_put_var_strict_1_asm_h:                ; @put_var_strict_1_asm_h
; %bb.0:                                ; %B5
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	cmp	x22, #7
	b.ne	LBB328_3
; %bb.1:                                ; %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          ; =0x2
	stur	x21, [x8, #-8]
	str	x8, [x23, #48]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB328_4
; %bb.2:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB328_3:                               ; %B6
	ldr	w1, [x19]
	mov	x0, x24
	str	x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB328_4:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_get_ref_value_1_asm_h  ; -- Begin function get_ref_value_1_asm_h
	.globl	_get_ref_value_1_asm_h
	.p2align	2
_get_ref_value_1_asm_h:                 ; @get_ref_value_1_asm_h
; %bb.0:                                ; %B8
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	str	x21, [x20]
	mov	x0, x24
	cmp	x22, #18
	str	x8, [x23, #48]
	b.eq	LBB329_3
; %bb.1:                                ; %B1
	mov	x1, x22
	mov	x2, x21
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB329_5
; %bb.2:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB329_3:                               ; %B5
	mov	x1, x21
	bl	_js_value_to_atom_gc
	cbz	w0, LBB329_5
; %bb.4:                                ; %B7
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB329_5:                               ; %B6
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_put_ref_value_1_asm_h  ; -- Begin function put_ref_value_1_asm_h
	.globl	_put_ref_value_1_asm_h
	.p2align	2
_put_ref_value_1_asm_h:                 ; @put_ref_value_1_asm_h
; %bb.0:                                ; %B12
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	cmp	x1, #18
	b.eq	LBB330_3
LBB330_1:                               ; %B1
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_SetPropertyValue_GC
	tbnz	w0, #31, LBB330_7
; %bb.2:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB330_3:                               ; %B8
	ldrb	w8, [x23, #44]
	tbnz	w8, #0, LBB330_5
; %bb.4:                                ; %B9
	ldr	x1, [x24, #208]
	b	LBB330_1
LBB330_5:                               ; %B5
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB330_7
; %bb.6:                                ; %B7
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB330_7:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_define_var_1_asm_h     ; -- Begin function define_var_1_asm_h
	.globl	_define_var_1_asm_h
	.p2align	2
_define_var_1_asm_h:                    ; @define_var_1_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_DefineGlobalVar_GC
	tbnz	w0, #31, LBB331_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB331_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_check_define_var_1_asm_h ; -- Begin function check_define_var_1_asm_h
	.globl	_check_define_var_1_asm_h
	.p2align	2
_check_define_var_1_asm_h:              ; @check_define_var_1_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, LBB332_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB332_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_define_func_1_asm_h    ; -- Begin function define_func_1_asm_h
	.globl	_define_func_1_asm_h
	.p2align	2
_define_func_1_asm_h:                   ; @define_func_1_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	ldrb	w3, [x19, #4]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_DefineGlobalFunction_GC
	tbnz	w0, #31, LBB333_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB333_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_get_field_1_asm_h      ; -- Begin function get_field_1_asm_h
	.globl	_get_field_1_asm_h
	.p2align	2
_get_field_1_asm_h:                     ; @get_field_1_asm_h
; %bb.0:                                ; %B24
	mov	x8, #2                          ; =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB334_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB334_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB334_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB334_5
LBB334_3:                               ; %B1
                                        ;   Parent Loop BB334_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB334_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB334_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB334_3
LBB334_5:                               ; %B14
                                        ;   in Loop: Header=BB334_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB334_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB334_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB334_2
	b	LBB334_9
LBB334_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB334_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB334_9:                               ; %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB334_10:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB334_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB334_12:                              ; %B22
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_get_field2_1_asm_h     ; -- Begin function get_field2_1_asm_h
	.globl	_get_field2_1_asm_h
	.p2align	2
_get_field2_1_asm_h:                    ; @get_field2_1_asm_h
; %bb.0:                                ; %B24
	mov	x8, #2                          ; =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB335_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB335_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB335_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB335_5
LBB335_3:                               ; %B1
                                        ;   Parent Loop BB335_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB335_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB335_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB335_3
LBB335_5:                               ; %B14
                                        ;   in Loop: Header=BB335_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB335_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB335_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB335_2
	b	LBB335_9
LBB335_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB335_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB335_9:                               ; %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB335_10:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB335_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB335_12:                              ; %B22
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_put_field_1_asm_h      ; -- Begin function put_field_1_asm_h
	.globl	_put_field_1_asm_h
	.p2align	2
_put_field_1_asm_h:                     ; @put_field_1_asm_h
; %bb.0:                                ; %B80
	sub	sp, sp, #16
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	mov	x12, x20
	movk	x8, #65535, lsl #48
	ldr	w20, [x19]
	tst	x22, x8
	b.ne	LBB336_25
; %bb.1:                                ; %B81
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w20, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB336_4
LBB336_2:                               ; %B1
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w20
	b.eq	LBB336_10
; %bb.3:                                ; %B12
                                        ;   in Loop: Header=BB336_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB336_2
LBB336_4:                               ; %B17.preheader
	mov	x8, x22
LBB336_5:                               ; %B17
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB336_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w20, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB336_8
LBB336_6:                               ; %B18
                                        ;   Parent Loop BB336_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w20
	b.eq	LBB336_13
; %bb.7:                                ; %B59
                                        ;   in Loop: Header=BB336_6 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB336_6
LBB336_8:                               ; %B66
                                        ;   in Loop: Header=BB336_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB336_25
; %bb.9:                                ; %B63
                                        ;   in Loop: Header=BB336_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB336_5
	b	LBB336_14
LBB336_10:                              ; %B3
	mov	w9, #58                         ; =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	LBB336_25
; %bb.11:                               ; %B7
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB336_27
; %bb.12:                               ; %B5
	ldrb	w8, [x19, #4]
	sub	x20, x12, #8
	ldr	x1, [x25, x8, lsl #3]
	add	x19, x19, #5
	add	sp, sp, #16
	br	x1
LBB336_13:                              ; %B20
	mov	w8, #58                         ; =0x3a
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	LBB336_25
LBB336_14:                              ; %B23
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	LBB336_25
; %bb.15:                               ; %B25
	ldrh	w8, [x22, #6]
	str	x19, [sp, #8]                   ; 8-byte Folded Spill
	cmp	w8, #1
	b.ne	LBB336_34
; %bb.16:                               ; %B25
	tbnz	w20, #31, LBB336_34
; %bb.17:                               ; %B54
	ldr	x19, [x22, #8]
	ldr	x13, [x19, #40]
	cbz	x13, LBB336_28
; %bb.18:                               ; %B32
	ldr	x8, [x22, #16]
	ldr	w9, [x13, #16]
	add	x10, x22, #32
	ldr	w11, [x19, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	LBB336_20
; %bb.19:                               ; %B32
	cbz	w8, LBB336_34
LBB336_20:                              ; %B42
	ldr	w8, [x19, #48]
	cmp	w8, w20
	b.ne	LBB336_28
; %bb.21:                               ; %B42
	ldrb	w8, [x19, #52]
	cmp	w8, #7
	b.ne	LBB336_28
LBB336_22:                              ; %B34
	ldr	w8, [x13]
	add	x9, x22, #8
	add	w8, w8, #1
	str	w8, [x13]
	ldr	w8, [x19]
	sub	w8, w8, #1
	str	w8, [x19]
	stlr	x13, [x9]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB336_31
; %bb.23:                               ; %B38
	ldr	w8, [x13, #20]
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB336_32
LBB336_24:                              ; %B37
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	sub	x20, x12, #8
	ldrb	w8, [x9, #4]
	ldr	x1, [x25, x8, lsl #3]
	add	x19, x9, #5
	add	sp, sp, #16
	br	x1
LBB336_25:                              ; %B77
	mov	x8, x12
	mov	x0, x24
	mov	x1, x22
	mov	w2, w20
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x21, [x8], #8
	mov	x20, x12
	str	x8, [x23, #48]
	bl	_JS_SetPropertyInternalImpl_GC
	tbnz	w0, #31, LBB336_39
; %bb.26:                               ; %B79
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	add	x19, x19, #5
	add	sp, sp, #16
	br	x1
LBB336_27:                              ; %B9
	mov	x0, x21
	mov	x1, x24
	mov	x20, x12
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	add	x19, x19, #5
	add	sp, sp, #16
	br	x1
LBB336_28:                              ; %B47
	ldr	x0, [x24, #8]
	mov	x1, x19
	mov	w2, w20
	mov	w3, #7                          ; =0x7
	str	x12, [sp]                       ; 8-byte Folded Spill
	bl	_find_hashed_shape_prop_gc
	ldr	x12, [sp]                       ; 8-byte Folded Reload
	cbz	x0, LBB336_34
; %bb.29:                               ; %B50
	ldr	x8, [x22, #16]
	ldr	w9, [x0, #16]
	add	x10, x22, #32
	ldr	w11, [x19, #16]
	mov	x13, x0
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	LBB336_33
; %bb.30:
	ldr	x12, [sp]                       ; 8-byte Folded Reload
	b	LBB336_22
LBB336_31:                              ; %B41
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	mov	x20, x12
	orr	x0, x13, x8
	mov	x19, x13
	bl	_prim_WriteBarrierNoStore
	mov	x12, x20
	ldr	w8, [x19, #20]
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #392]
	cbz	w8, LBB336_24
LBB336_32:                              ; %B40
	mov	x0, x21
	mov	x1, x24
	mov	x20, x12
	bl	_prim_WriteBarrierNoStore
	mov	x12, x20
	b	LBB336_24
LBB336_33:                              ; %B50
	ldr	x12, [sp]                       ; 8-byte Folded Reload
	cbnz	w8, LBB336_22
LBB336_34:                              ; %B70
	mov	x0, x24
	mov	x1, x22
	mov	w2, w20
	mov	w3, #7                          ; =0x7
	str	x12, [sp]                       ; 8-byte Folded Spill
	str	x21, [x12], #8
	str	x12, [x23, #48]
	bl	_add_property_gc
	cbz	x0, LBB336_38
; %bb.35:                               ; %B74
	str	x21, [x0]
	ldrb	w8, [x24, #392]
	cbz	w8, LBB336_37
; %bb.36:                               ; %B76
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
LBB336_37:                              ; %B73
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	ldrb	w8, [x9, #4]
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp], #16                   ; 8-byte Folded Reload
	sub	x20, x8, #8
	add	x19, x9, #5
	br	x1
LBB336_38:                              ; %B71
	ldp	x8, x19, [sp]                   ; 16-byte Folded Reload
	sub	x20, x8, #8
LBB336_39:                              ; %B78
	add	sp, sp, #16
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_get_private_field_1_asm_h ; -- Begin function get_private_field_1_asm_h
	.globl	_get_private_field_1_asm_h
	.p2align	2
_get_private_field_1_asm_h:             ; @get_private_field_1_asm_h
; %bb.0:                                ; %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #48]
	bl	_JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	LBB337_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB337_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_put_private_field_1_asm_h ; -- Begin function put_private_field_1_asm_h
	.globl	_put_private_field_1_asm_h
	.p2align	2
_put_private_field_1_asm_h:             ; @put_private_field_1_asm_h
; %bb.0:                                ; %B1
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x3, x22
	str	x8, [x23, #48]
	bl	_JS_SetPrivateField_GC
	tbnz	w0, #31, LBB338_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB338_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_define_private_field_1_asm_h ; -- Begin function define_private_field_1_asm_h
	.globl	_define_private_field_1_asm_h
	.p2align	2
_define_private_field_1_asm_h:          ; @define_private_field_1_asm_h
; %bb.0:                                ; %B1
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	add	x8, x20, #8
	mov	x0, x24
	mov	x3, x21
	str	x21, [x20]
	mov	x2, x22
	str	x8, [x23, #48]
	bl	_JS_DefinePrivateField_GC
	tbnz	w0, #31, LBB339_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB339_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_get_array_el_1_asm_h   ; -- Begin function get_array_el_1_asm_h
	.globl	_get_array_el_1_asm_h
	.p2align	2
_get_array_el_1_asm_h:                  ; @get_array_el_1_asm_h
; %bb.0:                                ; %B72
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB340_7
; %bb.1:                                ; %B72
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x8, x9
	b.ne	LBB340_7
; %bb.2:                                ; %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	LBB340_5
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB340_9
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB340_5:                               ; %B30
	sxth	w9, w8
	cmp	w9, #21
	b.lt	LBB340_7
; %bb.6:                                ; %B30
	cmp	w9, #29
	b.le	LBB340_19
LBB340_7:                               ; %B69
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB340_24
; %bb.8:                                ; %B71
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB340_9:                               ; %B7
	tbnz	w21, #31, LBB340_7
; %bb.10:                               ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB340_11:                              ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB340_12 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB340_14
LBB340_12:                              ; %B10
                                        ;   Parent Loop BB340_11 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB340_16
; %bb.13:                               ; %B17
                                        ;   in Loop: Header=BB340_12 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB340_12
LBB340_14:                              ; %B24
                                        ;   in Loop: Header=BB340_11 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB340_7
; %bb.15:                               ; %B21
                                        ;   in Loop: Header=BB340_11 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB340_11
	b	LBB340_18
LBB340_16:                              ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB340_7
; %bb.17:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB340_18:                              ; %B36
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB340_19:                              ; %B32
	ldr	w9, [x22, #48]
	cmp	w21, w9
	b.hs	LBB340_7
; %bb.20:                               ; %B34
	ldr	x9, [x22, #40]
	cmp	w8, #23
	b.ge	LBB340_25
; %bb.21:                               ; %B34
	cmp	w8, #21
	b.eq	LBB340_26
; %bb.22:                               ; %B34
	cmp	w8, #22
	b.ne	LBB340_7
; %bb.23:                               ; %B35
	ldrsb	w8, [x9, w21, sxtw]
	b	LBB340_38
LBB340_24:                              ; %B70
	b	_exception_spill_top1_asm_h
LBB340_25:                              ; %B34
	b.gt	LBB340_27
LBB340_26:                              ; %B39
	ldrb	w8, [x9, w21, sxtw]
	b	LBB340_38
LBB340_27:                              ; %B34
	cmp	w8, #25
	b.gt	LBB340_31
; %bb.28:                               ; %B34
	cmp	w8, #24
	b.eq	LBB340_35
; %bb.29:                               ; %B34
	cmp	w8, #25
	b.ne	LBB340_7
; %bb.30:                               ; %B45
	ldrh	w8, [x9, w21, sxtw #1]
	b	LBB340_38
LBB340_31:                              ; %B34
	cmp	w8, #26
	b.eq	LBB340_36
; %bb.32:                               ; %B34
	cmp	w8, #27
	b.eq	LBB340_37
; %bb.33:                               ; %B34
	cmp	w8, #29
	b.ne	LBB340_7
; %bb.34:                               ; %B62
	ldr	d0, [x9, w21, sxtw #3]
	b	LBB340_40
LBB340_35:                              ; %B42
	ldrsh	w8, [x9, w21, sxtw #1]
	b	LBB340_38
LBB340_36:                              ; %B48
	ldr	w8, [x9, w21, sxtw #2]
	b	LBB340_38
LBB340_37:                              ; %B56
	ldr	w8, [x9, w21, sxtw #2]
	tbnz	w8, #31, LBB340_39
LBB340_38:                              ; %B36
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB340_39:                              ; %B52
	ucvtf	d0, w8
LBB340_40:                              ; %B36
	fmov	x8, d0
	fcmp	d0, d0
	mov	x9, #562949953421312            ; =0x2000000000000
	add	x8, x8, x9
	mov	x9, #9221683186994511872        ; =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_array_el2_1_asm_h  ; -- Begin function get_array_el2_1_asm_h
	.globl	_get_array_el2_1_asm_h
	.p2align	2
_get_array_el2_1_asm_h:                 ; @get_array_el2_1_asm_h
; %bb.0:                                ; %B72
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB341_7
; %bb.1:                                ; %B72
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x8, x9
	b.ne	LBB341_7
; %bb.2:                                ; %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	LBB341_5
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB341_9
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #8
	add	w8, w8, #486
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB341_5:                               ; %B30
	sxth	w9, w8
	cmp	w9, #21
	b.lt	LBB341_7
; %bb.6:                                ; %B30
	cmp	w9, #29
	b.le	LBB341_19
LBB341_7:                               ; %B69
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB341_24
; %bb.8:                                ; %B71
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB341_9:                               ; %B7
	tbnz	w21, #31, LBB341_7
; %bb.10:                               ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB341_11:                              ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB341_12 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB341_14
LBB341_12:                              ; %B10
                                        ;   Parent Loop BB341_11 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB341_16
; %bb.13:                               ; %B17
                                        ;   in Loop: Header=BB341_12 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB341_12
LBB341_14:                              ; %B24
                                        ;   in Loop: Header=BB341_11 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB341_7
; %bb.15:                               ; %B21
                                        ;   in Loop: Header=BB341_11 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB341_11
	b	LBB341_18
LBB341_16:                              ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB341_7
; %bb.17:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB341_18:                              ; %B36
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB341_19:                              ; %B32
	ldr	w9, [x22, #48]
	cmp	w21, w9
	b.hs	LBB341_7
; %bb.20:                               ; %B34
	ldr	x9, [x22, #40]
	cmp	w8, #23
	b.ge	LBB341_25
; %bb.21:                               ; %B34
	cmp	w8, #21
	b.eq	LBB341_26
; %bb.22:                               ; %B34
	cmp	w8, #22
	b.ne	LBB341_7
; %bb.23:                               ; %B35
	ldrsb	w8, [x9, w21, sxtw]
	b	LBB341_38
LBB341_24:                              ; %B70
	b	_exception_spill_top1_asm_h
LBB341_25:                              ; %B34
	b.gt	LBB341_27
LBB341_26:                              ; %B39
	ldrb	w8, [x9, w21, sxtw]
	b	LBB341_38
LBB341_27:                              ; %B34
	cmp	w8, #25
	b.gt	LBB341_31
; %bb.28:                               ; %B34
	cmp	w8, #24
	b.eq	LBB341_35
; %bb.29:                               ; %B34
	cmp	w8, #25
	b.ne	LBB341_7
; %bb.30:                               ; %B45
	ldrh	w8, [x9, w21, sxtw #1]
	b	LBB341_38
LBB341_31:                              ; %B34
	cmp	w8, #26
	b.eq	LBB341_36
; %bb.32:                               ; %B34
	cmp	w8, #27
	b.eq	LBB341_37
; %bb.33:                               ; %B34
	cmp	w8, #29
	b.ne	LBB341_7
; %bb.34:                               ; %B62
	ldr	d0, [x9, w21, sxtw #3]
	b	LBB341_40
LBB341_35:                              ; %B42
	ldrsh	w8, [x9, w21, sxtw #1]
	b	LBB341_38
LBB341_36:                              ; %B48
	ldr	w8, [x9, w21, sxtw #2]
	b	LBB341_38
LBB341_37:                              ; %B56
	ldr	w8, [x9, w21, sxtw #2]
	tbnz	w8, #31, LBB341_39
LBB341_38:                              ; %B36
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB341_39:                              ; %B52
	ucvtf	d0, w8
LBB341_40:                              ; %B36
	fmov	x8, d0
	fcmp	d0, d0
	mov	x9, #562949953421312            ; =0x2000000000000
	add	x8, x8, x9
	mov	x9, #9221683186994511872        ; =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_array_el_1_asm_h   ; -- Begin function put_array_el_1_asm_h
	.globl	_put_array_el_1_asm_h
	.p2align	2
_put_array_el_1_asm_h:                  ; @put_array_el_1_asm_h
; %bb.0:                                ; %B100
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x1, x8
	b.ne	LBB342_40
; %bb.1:                                ; %B94
	ldrh	w9, [x1, #6]
	cmp	w9, #2
	b.ne	LBB342_6
; %bb.2:                                ; %B1
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB342_40
; %bb.3:                                ; %B46
	ldr	w8, [x1, #48]
	cmp	w22, w8
	b.hs	LBB342_13
; %bb.4:                                ; %B3
	ldr	x8, [x1, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB342_22
LBB342_5:                               ; %B58
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB342_6:                               ; %B97
	sxth	w8, w9
	mov	w4, #32768                      ; =0x8000
	cmp	w8, #21
	b.lt	LBB342_41
; %bb.7:                                ; %B97
	cmp	w8, #29
	b.gt	LBB342_41
; %bb.8:                                ; %B50
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB342_36
; %bb.9:                                ; %B52
	ldr	w8, [x1, #48]
	cmp	w22, w8
	b.hs	LBB342_36
; %bb.10:                               ; %B54
	sub	w10, w9, #22
	ldr	x8, [x1, #40]
	cmp	w10, #2
	b.hs	LBB342_23
; %bb.11:                               ; %B64
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	LBB342_36
; %bb.12:                               ; %B65
	strb	w21, [x8, w22, sxtw]
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB342_13:                              ; %B8
	b.ne	LBB342_37
; %bb.14:                               ; %B36
	ldr	w9, [x1, #4]
	mov	w4, #32768                      ; =0x8000
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	b.ne	LBB342_41
; %bb.15:                               ; %B36
	ubfx	w9, w9, #8, #1
	cbz	w9, LBB342_41
; %bb.16:                               ; %B10
	ldr	x9, [x1, #8]
	ldr	x9, [x9, #32]
	cbz	x9, LBB342_18
; %bb.17:                               ; %B32
	ldr	w9, [x9, #4]
	ubfx	w9, w9, #13, #1
	cmp	w9, #1
	b.ne	LBB342_41
LBB342_18:                              ; %B28
	ldr	x9, [x1, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	LBB342_20
; %bb.19:                               ; %B28
	cmp	w9, w10
	b.hi	LBB342_43
LBB342_20:                              ; %B25
	ldr	w10, [x1, #32]
	cmp	w9, w10
	b.hi	LBB342_43
; %bb.21:                               ; %B21
	ldr	x10, [x1, #40]
	str	w9, [x1, #48]
	str	x21, [x10, w8, sxtw #3]
	ldrb	w8, [x24, #392]
	cbz	w8, LBB342_5
LBB342_22:                              ; %B24
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB342_23:                              ; %B54
	cmp	w9, #25
	mov	w4, wzr
	b.gt	LBB342_27
; %bb.24:                               ; %B54
	sub	w10, w9, #24
	cmp	w10, #2
	b.hs	LBB342_30
; %bb.25:                               ; %B70
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	LBB342_36
; %bb.26:                               ; %B71
	strh	w21, [x8, w22, sxtw #1]
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB342_27:                              ; %B54
	sub	w10, w9, #26
	cmp	w10, #2
	b.hs	LBB342_33
; %bb.28:                               ; %B76
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	LBB342_36
; %bb.29:                               ; %B77
	str	w21, [x8, w22, sxtw #2]
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB342_30:                              ; %B54
	cmp	w9, #21
	b.ne	LBB342_41
; %bb.31:                               ; %B56
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	LBB342_36
; %bb.32:                               ; %B57
	cmp	w21, #255
	mov	w9, #255                        ; =0xff
	csel	w9, w21, w9, lt
	bic	w9, w9, w9, asr #31
	strb	w9, [x8, w22, sxtw]
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB342_33:                              ; %B54
	cmp	w9, #29
	b.ne	LBB342_41
; %bb.34:                               ; %B82
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	LBB342_45
; %bb.35:                               ; %B83
	scvtf	d0, w21
	str	d0, [x8, w22, sxtw #3]
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB342_36:
	mov	w4, wzr
	b	LBB342_41
LBB342_37:                              ; %B40
	tbnz	w22, #31, LBB342_40
; %bb.38:                               ; %B42
	mov	x8, x20
	mov	x0, x24
	mov	w2, w22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_SetArrayIntPropertyValue_GC
	tbz	w0, #31, LBB342_5
; %bb.39:                               ; %B43
	b	_exception_spill_top1_asm_h
LBB342_40:
	mov	w4, #32768                      ; =0x8000
LBB342_41:                              ; %B91
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_SetPropertyValue_GC
	tbz	w0, #31, LBB342_5
; %bb.42:                               ; %B92
	b	_exception_spill_top1_asm_h
LBB342_43:                              ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	x2, x21
	mov	w3, #32768                      ; =0x8000
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_add_fast_array_element_gc
	tbz	w0, #31, LBB342_5
; %bb.44:                               ; %B17
	b	_exception_spill_top1_asm_h
LBB342_45:                              ; %B85
	and	x9, x21, #0xfffe000000000000
	mov	x10, #-562949953421312          ; =0xfffe000000000000
	mov	w4, wzr
	cmp	x9, x10
	b.eq	LBB342_41
; %bb.46:                               ; %B85
	cbz	x9, LBB342_41
; %bb.47:                               ; %B86
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	add	x9, x21, x9
	str	x9, [x8, w22, sxtw #3]
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_super_value_1_asm_h ; -- Begin function get_super_value_1_asm_h
	.globl	_get_super_value_1_asm_h
	.p2align	2
_get_super_value_1_asm_h:               ; @get_super_value_1_asm_h
; %bb.0:                                ; %B1
	sub	sp, sp, #16
	mov	x21, x22
	str	x19, [sp, #8]                   ; 8-byte Folded Spill
	add	x19, x20, #8
	ldur	x22, [x20, #-8]
	mov	x0, x24
	mov	x1, x21
	str	x21, [x20]
	str	x19, [x23, #48]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB343_3
; %bb.1:                                ; %B5
	ldur	x3, [x20, #-16]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	str	x21, [x20]
	str	x19, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB343_3
; %bb.2:                                ; %B7
	ldr	x19, [sp, #8]                   ; 8-byte Folded Reload
	stur	x0, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB343_3:                               ; %B2
	ldr	x19, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_put_super_value_1_asm_h ; -- Begin function put_super_value_1_asm_h
	.globl	_put_super_value_1_asm_h
	.p2align	2
_put_super_value_1_asm_h:               ; @put_super_value_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_put_super_value_0_asm_h
                                        ; -- End function
	.private_extern	_define_field_1_asm_h   ; -- Begin function define_field_1_asm_h
	.globl	_define_field_1_asm_h
	.p2align	2
_define_field_1_asm_h:                  ; @define_field_1_asm_h
; %bb.0:                                ; %B58
	sub	sp, sp, #32
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	ldr	w2, [x19]
	tst	x22, x8
	b.ne	LBB345_4
; %bb.1:                                ; %B55
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	LBB345_4
; %bb.2:                                ; %B49
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB345_4
; %bb.3:                                ; %B52
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.eq	LBB345_6
LBB345_4:                               ; %B46
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #16391                      ; =0x4007
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_DefinePropertyValue_GC
	tbnz	w0, #31, LBB345_17
LBB345_5:                               ; %B4
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #32
	br	x1
LBB345_6:                               ; %B53
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB345_9
LBB345_7:                               ; %B35
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB345_18
; %bb.8:                                ; %B37
                                        ;   in Loop: Header=BB345_7 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB345_7
LBB345_9:                               ; %B40
	tbnz	w2, #31, LBB345_4
; %bb.10:                               ; %B11
	ldr	x8, [x22, #8]
	str	x8, [sp, #24]                   ; 8-byte Folded Spill
	ldr	x8, [x8, #40]
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	cbz	x8, LBB345_21
; %bb.11:                               ; %B15
	ldp	x9, x11, [sp, #16]              ; 16-byte Folded Reload
	add	x10, x22, #32
	ldr	x8, [x22, #16]
	ldr	w9, [x9, #16]
	ldr	w11, [x11, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	LBB345_13
; %bb.12:                               ; %B15
	cbz	w8, LBB345_4
LBB345_13:                              ; %B17
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	ldr	w8, [x8, #48]
	cmp	w8, w2
	b.ne	LBB345_21
; %bb.14:                               ; %B17
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	ldrb	w8, [x8, #52]
	cmp	w8, #7
	b.ne	LBB345_21
LBB345_15:                              ; %B25
	ldp	x11, x10, [sp, #16]             ; 16-byte Folded Reload
	add	x9, x22, #8
	ldr	w8, [x11]
	add	w8, w8, #1
	str	w8, [x11]
	ldr	w8, [x10]
	sub	w8, w8, #1
	str	w8, [x10]
	stlr	x11, [x9]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB345_24
LBB345_16:                              ; %B22
	ldr	x8, [sp, #16]                   ; 8-byte Folded Reload
	ldr	w8, [x8, #20]
	b	LBB345_19
LBB345_17:                              ; %B47
	add	sp, sp, #32
	b	_exception_spill_top1_asm_h
LBB345_18:                              ; %B1
	lsr	w9, w10, #26
	and	w9, w9, #0xfffffff7
	cmp	w9, #7
	b.ne	LBB345_4
LBB345_19:                              ; %B22
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #392]
	cbz	w8, LBB345_5
; %bb.20:
	mov	x1, x24
	mov	x0, x21
	bl	_prim_WriteBarrierNoStore
	b	LBB345_5
LBB345_21:                              ; %B43
	ldr	x0, [x24, #8]
	ldr	x1, [sp, #24]                   ; 8-byte Folded Reload
	mov	w3, #7                          ; =0x7
	str	w2, [sp, #12]                   ; 4-byte Folded Spill
	bl	_find_hashed_shape_prop_gc
	ldr	w2, [sp, #12]                   ; 4-byte Folded Reload
	cbz	x0, LBB345_4
; %bb.22:                               ; %B30
	ldr	x8, [x22, #16]
	ldr	x11, [sp, #24]                  ; 8-byte Folded Reload
	add	x10, x22, #32
	ldr	w9, [x0, #16]
	ldr	w11, [x11, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	LBB345_25
; %bb.23:
	str	x0, [sp, #16]                   ; 8-byte Folded Spill
	b	LBB345_15
LBB345_24:                              ; %B27
	ldr	x9, [sp, #16]                   ; 8-byte Folded Reload
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	_prim_WriteBarrierNoStore
	b	LBB345_16
LBB345_25:                              ; %B30
	ldr	w2, [sp, #12]                   ; 4-byte Folded Reload
	str	x0, [sp, #16]                   ; 8-byte Folded Spill
	cbnz	w8, LBB345_15
	b	LBB345_4
                                        ; -- End function
	.private_extern	_set_name_1_asm_h       ; -- Begin function set_name_1_asm_h
	.globl	_set_name_1_asm_h
	.p2align	2
_set_name_1_asm_h:                      ; @set_name_1_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w3, #1                          ; =0x1
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_DefineObjectName
	tbnz	w0, #31, LBB346_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB346_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_set_name_computed_1_asm_h ; -- Begin function set_name_computed_1_asm_h
	.globl	_set_name_computed_1_asm_h
	.p2align	2
_set_name_computed_1_asm_h:             ; @set_name_computed_1_asm_h
; %bb.0:                                ; %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x1, x21
	mov	w3, #1                          ; =0x1
	mov	x2, x22
	str	x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, LBB347_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB347_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_set_proto_1_asm_h      ; -- Begin function set_proto_1_asm_h
	.globl	_set_proto_1_asm_h
	.p2align	2
_set_proto_1_asm_h:                     ; @set_proto_1_asm_h
; %bb.0:                                ; %B6
	mov	x8, #2                          ; =0x2
	mov	x21, x22
	ldur	x22, [x20, #-8]
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	LBB348_3
; %bb.1:                                ; %B6
	cmp	x21, #2
	b.eq	LBB348_3
LBB348_2:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB348_3:                               ; %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_SetPrototypeInternal_GC
	tbz	w0, #31, LBB348_2
; %bb.4:                                ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_set_home_object_1_asm_h ; -- Begin function set_home_object_1_asm_h
	.globl	_set_home_object_1_asm_h
	.p2align	2
_set_home_object_1_asm_h:               ; @set_home_object_1_asm_h
; %bb.0:                                ; %B0
	sub	sp, sp, #16
	mov	x9, x20
	mov	x21, x22
	add	x8, x20, #8
	ldr	x22, [x9, #-8]!
	mov	x0, x24
	mov	x1, x21
	str	x9, [sp, #8]                    ; 8-byte Folded Spill
	mov	x2, x22
	str	x21, [x20]
	str	x8, [x23, #48]
	bl	_js_method_set_home_object_gc
	ldrb	w8, [x19], #1
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
                                        ; -- End function
	.private_extern	_define_array_el_1_asm_h ; -- Begin function define_array_el_1_asm_h
	.globl	_define_array_el_1_asm_h
	.p2align	2
_define_array_el_1_asm_h:               ; @define_array_el_1_asm_h
; %bb.0:                                ; %B1
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	add	x8, x20, #8
	mov	x0, x24
	mov	x3, x21
	mov	w4, #16391                      ; =0x4007
	str	x21, [x20]
	mov	x2, x22
	str	x8, [x23, #48]
	bl	_JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, LBB350_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB350_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_append_1_asm_h         ; -- Begin function append_1_asm_h
	.globl	_append_1_asm_h
	.p2align	2
_append_1_asm_h:                        ; @append_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_append_0_asm_h
                                        ; -- End function
	.private_extern	_copy_data_properties_1_asm_h ; -- Begin function copy_data_properties_1_asm_h
	.globl	_copy_data_properties_1_asm_h
	.p2align	2
_copy_data_properties_1_asm_h:          ; @copy_data_properties_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_copy_data_properties_0_asm_h
                                        ; -- End function
	.private_extern	_define_method_1_asm_h  ; -- Begin function define_method_1_asm_h
	.globl	_define_method_1_asm_h
	.p2align	2
_define_method_1_asm_h:                 ; @define_method_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_define_method_0_asm_h
                                        ; -- End function
	.private_extern	_define_method_computed_1_asm_h ; -- Begin function define_method_computed_1_asm_h
	.globl	_define_method_computed_1_asm_h
	.p2align	2
_define_method_computed_1_asm_h:        ; @define_method_computed_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_define_method_computed_0_asm_h
                                        ; -- End function
	.private_extern	_define_class_1_asm_h   ; -- Begin function define_class_1_asm_h
	.globl	_define_class_1_asm_h
	.p2align	2
_define_class_1_asm_h:                  ; @define_class_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_define_class_0_asm_h
                                        ; -- End function
	.private_extern	_get_loc_1_asm_h        ; -- Begin function get_loc_1_asm_h
	.globl	_get_loc_1_asm_h
	.p2align	2
_get_loc_1_asm_h:                       ; @get_loc_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #486
	ldr	x21, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_loc_1_asm_h        ; -- Begin function put_loc_1_asm_h
	.globl	_put_loc_1_asm_h
	.p2align	2
_put_loc_1_asm_h:                       ; @put_loc_1_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc_1_asm_h        ; -- Begin function set_loc_1_asm_h
	.globl	_set_loc_1_asm_h
	.p2align	2
_set_loc_1_asm_h:                       ; @set_loc_1_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_arg_1_asm_h        ; -- Begin function get_arg_1_asm_h
	.globl	_get_arg_1_asm_h
	.p2align	2
_get_arg_1_asm_h:                       ; @get_arg_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19, #2]
	ldrh	w9, [x19], #3
	add	w8, w8, #486
	ldr	x21, [x28, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_arg_1_asm_h        ; -- Begin function put_arg_1_asm_h
	.globl	_put_arg_1_asm_h
	.p2align	2
_put_arg_1_asm_h:                       ; @put_arg_1_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_arg_1_asm_h        ; -- Begin function set_arg_1_asm_h
	.globl	_set_arg_1_asm_h
	.p2align	2
_set_arg_1_asm_h:                       ; @set_arg_1_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_var_ref_1_asm_h    ; -- Begin function get_var_ref_1_asm_h
	.globl	_get_var_ref_1_asm_h
	.p2align	2
_get_var_ref_1_asm_h:                   ; @get_var_ref_1_asm_h
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
	.private_extern	_put_var_ref_1_asm_h    ; -- Begin function put_var_ref_1_asm_h
	.globl	_put_var_ref_1_asm_h
	.p2align	2
_put_var_ref_1_asm_h:                   ; @put_var_ref_1_asm_h
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
	.private_extern	_set_var_ref_1_asm_h    ; -- Begin function set_var_ref_1_asm_h
	.globl	_set_var_ref_1_asm_h
	.p2align	2
_set_var_ref_1_asm_h:                   ; @set_var_ref_1_asm_h
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
	.private_extern	_set_loc_uninitialized_1_asm_h ; -- Begin function set_loc_uninitialized_1_asm_h
	.globl	_set_loc_uninitialized_1_asm_h
	.p2align	2
_set_loc_uninitialized_1_asm_h:         ; @set_loc_uninitialized_1_asm_h
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
	.private_extern	_get_loc_check_1_asm_h  ; -- Begin function get_loc_check_1_asm_h
	.globl	_get_loc_check_1_asm_h
	.p2align	2
_get_loc_check_1_asm_h:                 ; @get_loc_check_1_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	LBB366_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB366_2:                               ; %B3
	str	x22, [x20], #8
	b	_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.private_extern	_put_loc_check_1_asm_h  ; -- Begin function put_loc_check_1_asm_h
	.globl	_put_loc_check_1_asm_h
	.p2align	2
_put_loc_check_1_asm_h:                 ; @put_loc_check_1_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	LBB367_2
; %bb.1:                                ; %B4
	str	x22, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB367_2:                               ; %B3
	str	x22, [x20], #8
	b	_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.private_extern	_put_loc_check_init_1_asm_h ; -- Begin function put_loc_check_init_1_asm_h
	.globl	_put_loc_check_init_1_asm_h
	.p2align	2
_put_loc_check_init_1_asm_h:            ; @put_loc_check_init_1_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	LBB368_2
; %bb.1:                                ; %B4
	str	x22, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB368_2:                               ; %B3
	str	x22, [x20], #8
	b	_ThrowThisReferenceError_asm_h
                                        ; -- End function
	.private_extern	_get_var_ref_check_1_asm_h ; -- Begin function get_var_ref_check_1_asm_h
	.globl	_get_var_ref_check_1_asm_h
	.p2align	2
_get_var_ref_check_1_asm_h:             ; @get_var_ref_check_1_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	LBB369_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB369_2:                               ; %B3
	str	x22, [x20], #8
	b	_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.private_extern	_put_var_ref_check_1_asm_h ; -- Begin function put_var_ref_check_1_asm_h
	.globl	_put_var_ref_check_1_asm_h
	.p2align	2
_put_var_ref_check_1_asm_h:             ; @put_var_ref_check_1_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	LBB370_2
; %bb.1:                                ; %B4
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB370_2:                               ; %B3
	str	x22, [x20], #8
	b	_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.private_extern	_put_var_ref_check_init_1_asm_h ; -- Begin function put_var_ref_check_init_1_asm_h
	.globl	_put_var_ref_check_init_1_asm_h
	.p2align	2
_put_var_ref_check_init_1_asm_h:        ; @put_var_ref_check_init_1_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	LBB371_2
; %bb.1:                                ; %B4
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB371_2:                               ; %B3
	str	x22, [x20], #8
	b	_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.private_extern	_close_loc_1_asm_h      ; -- Begin function close_loc_1_asm_h
	.globl	_close_loc_1_asm_h
	.p2align	2
_close_loc_1_asm_h:                     ; @close_loc_1_asm_h
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
	.private_extern	_if_false_1_asm_h       ; -- Begin function if_false_1_asm_h
	.globl	_if_false_1_asm_h
	.p2align	2
_if_false_1_asm_h:                      ; @if_false_1_asm_h
; %bb.0:                                ; %B23
	cmp	x22, #5
	b.le	LBB373_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB373_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB373_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB373_6
	b	LBB373_7
LBB373_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB373_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB373_7
LBB373_6:                               ; %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB373_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB373_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB373_10
LBB373_9:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB373_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB373_13
; %bb.11:                               ; %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB373_6
	b.vs	LBB373_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB373_9
	b	LBB373_6
LBB373_13:                              ; %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	_SlowToBoolean_asm_h
                                        ; -- End function
	.private_extern	_if_true_1_asm_h        ; -- Begin function if_true_1_asm_h
	.globl	_if_true_1_asm_h
	.p2align	2
_if_true_1_asm_h:                       ; @if_true_1_asm_h
; %bb.0:                                ; %B23
	cmp	x22, #5
	b.le	LBB374_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB374_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB374_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB374_6
	b	LBB374_7
LBB374_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB374_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB374_7
LBB374_6:                               ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB374_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB374_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB374_10
LBB374_9:                               ; %B19
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB374_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB374_13
; %bb.11:                               ; %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB374_6
	b.vs	LBB374_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB374_9
	b	LBB374_6
LBB374_13:                              ; %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	_SlowToBoolean_asm_h
                                        ; -- End function
	.private_extern	_goto_1_asm_h           ; -- Begin function goto_1_asm_h
	.globl	_goto_1_asm_h
	.p2align	2
_goto_1_asm_h:                          ; @goto_1_asm_h
; %bb.0:                                ; %B0
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_catch_1_asm_h          ; -- Begin function catch_1_asm_h
	.globl	_catch_1_asm_h
	.p2align	2
_catch_1_asm_h:                         ; @catch_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #4]
	ldr	w10, [x19]
	ldr	x8, [x8, #32]
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	mov	w9, #66                         ; =0x42
	ldr	x8, [x8, #8]
	sub	x8, x19, x8
	add	x19, x19, #5
	add	x8, x8, x10
	orr	x21, x9, x8, lsl #16
	br	x1
                                        ; -- End function
	.private_extern	_gosub_1_asm_h          ; -- Begin function gosub_1_asm_h
	.globl	_gosub_1_asm_h
	.p2align	2
_gosub_1_asm_h:                         ; @gosub_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x23, #8]
	ldrsw	x9, [x19]
	ldr	x10, [x8, #32]
	add	x8, x19, x9
	ldrb	w9, [x8], #1
	ldr	w10, [x10, #8]
	add	w9, w9, #486
	sub	w10, w19, w10
	ldr	x1, [x25, w9, uxtw #3]
	mov	x19, x8
	add	w9, w10, #4
	orr	x21, x9, #0xfffe000000000000
	br	x1
                                        ; -- End function
	.private_extern	_ret_1_asm_h            ; -- Begin function ret_1_asm_h
	.globl	_ret_1_asm_h
	.p2align	2
_ret_1_asm_h:                           ; @ret_1_asm_h
; %bb.0:                                ; %B6
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB378_3
; %bb.1:                                ; %B1
	ldr	x8, [x23, #8]
	ldr	x8, [x8, #32]
	ldr	w9, [x8, #16]
	cmp	w22, w9
	b.ge	LBB378_3
; %bb.2:                                ; %B5
	ldr	x8, [x8, #8]
	add	x19, x8, w22, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB378_3:                               ; %B3
	mov	x8, x20
Lloh30:
	adrp	x1, l___unnamed_14@PAGE
Lloh31:
	add	x1, x1, l___unnamed_14@PAGEOFF
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_LEPUS_ThrowInternalError
	b	_exception_spill_top0_asm_h
	.loh AdrpAdd	Lloh30, Lloh31
                                        ; -- End function
	.private_extern	_to_object_1_asm_h      ; -- Begin function to_object_1_asm_h
	.globl	_to_object_1_asm_h
	.p2align	2
_to_object_1_asm_h:                     ; @to_object_1_asm_h
; %bb.0:                                ; %B6
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB379_2
; %bb.1:                                ; %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB379_2:                               ; %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB379_4
; %bb.3:                                ; %B3
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB379_4:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_to_propkey_1_asm_h     ; -- Begin function to_propkey_1_asm_h
	.globl	_to_propkey_1_asm_h
	.p2align	2
_to_propkey_1_asm_h:                    ; @to_propkey_1_asm_h
; %bb.0:                                ; %B15
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	LBB380_4
; %bb.1:                                ; %B15
	mov	x9, #1                          ; =0x1
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB380_4
; %bb.2:                                ; %B15
	cmp	x8, x9
	b.eq	LBB380_4
; %bb.3:                                ; %B15
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB380_5
LBB380_4:                               ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB380_5:                               ; %B12
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB380_7
; %bb.6:                                ; %B14
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB380_7:                               ; %B13
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_to_propkey2_1_asm_h    ; -- Begin function to_propkey2_1_asm_h
	.globl	_to_propkey2_1_asm_h
	.p2align	2
_to_propkey2_1_asm_h:                   ; @to_propkey2_1_asm_h
; %bb.0:                                ; %B18
	mov	x21, x22
	ldur	x22, [x20, #-8]
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	LBB381_3
; %bb.1:                                ; %B19
	mov	x8, x20
Lloh32:
	adrp	x1, l___unnamed_15@PAGE
Lloh33:
	add	x1, x1, l___unnamed_15@PAGEOFF
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_LEPUS_ThrowTypeError
LBB381_2:                               ; %B16
	b	_exception_spill_top1_asm_h
LBB381_3:                               ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	LBB381_7
; %bb.4:                                ; %B2
	mov	x9, #1                          ; =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB381_7
; %bb.5:                                ; %B2
	cmp	x8, x9
	b.eq	LBB381_7
; %bb.6:                                ; %B2
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB381_8
LBB381_7:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB381_8:                               ; %B15
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB381_2
; %bb.9:                                ; %B17
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh32, Lloh33
                                        ; -- End function
	.private_extern	_with_get_var_1_asm_h   ; -- Begin function with_get_var_1_asm_h
	.globl	_with_get_var_1_asm_h
	.p2align	2
_with_get_var_1_asm_h:                  ; @with_get_var_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_with_get_var_0_asm_h
                                        ; -- End function
	.private_extern	_with_put_var_1_asm_h   ; -- Begin function with_put_var_1_asm_h
	.globl	_with_put_var_1_asm_h
	.p2align	2
_with_put_var_1_asm_h:                  ; @with_put_var_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_with_put_var_0_asm_h
                                        ; -- End function
	.private_extern	_with_delete_var_1_asm_h ; -- Begin function with_delete_var_1_asm_h
	.globl	_with_delete_var_1_asm_h
	.p2align	2
_with_delete_var_1_asm_h:               ; @with_delete_var_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_with_delete_var_0_asm_h
                                        ; -- End function
	.private_extern	_with_make_ref_1_asm_h  ; -- Begin function with_make_ref_1_asm_h
	.globl	_with_make_ref_1_asm_h
	.p2align	2
_with_make_ref_1_asm_h:                 ; @with_make_ref_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_with_make_ref_0_asm_h
                                        ; -- End function
	.private_extern	_with_get_ref_1_asm_h   ; -- Begin function with_get_ref_1_asm_h
	.globl	_with_get_ref_1_asm_h
	.p2align	2
_with_get_ref_1_asm_h:                  ; @with_get_ref_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_with_get_ref_0_asm_h
                                        ; -- End function
	.private_extern	_with_get_ref_undef_1_asm_h ; -- Begin function with_get_ref_undef_1_asm_h
	.globl	_with_get_ref_undef_1_asm_h
	.p2align	2
_with_get_ref_undef_1_asm_h:            ; @with_get_ref_undef_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_with_get_ref_undef_0_asm_h
                                        ; -- End function
	.private_extern	_make_loc_ref_1_asm_h   ; -- Begin function make_loc_ref_1_asm_h
	.globl	_make_loc_ref_1_asm_h
	.p2align	2
_make_loc_ref_1_asm_h:                  ; @make_loc_ref_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_make_loc_ref_0_asm_h
                                        ; -- End function
	.private_extern	_make_arg_ref_1_asm_h   ; -- Begin function make_arg_ref_1_asm_h
	.globl	_make_arg_ref_1_asm_h
	.p2align	2
_make_arg_ref_1_asm_h:                  ; @make_arg_ref_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_make_arg_ref_0_asm_h
                                        ; -- End function
	.private_extern	_make_var_ref_ref_1_asm_h ; -- Begin function make_var_ref_ref_1_asm_h
	.globl	_make_var_ref_ref_1_asm_h
	.p2align	2
_make_var_ref_ref_1_asm_h:              ; @make_var_ref_ref_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_make_var_ref_ref_0_asm_h
                                        ; -- End function
	.private_extern	_make_var_ref_1_asm_h   ; -- Begin function make_var_ref_1_asm_h
	.globl	_make_var_ref_1_asm_h
	.p2align	2
_make_var_ref_1_asm_h:                  ; @make_var_ref_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_make_var_ref_0_asm_h
                                        ; -- End function
	.private_extern	_for_in_start_1_asm_h   ; -- Begin function for_in_start_1_asm_h
	.globl	_for_in_start_1_asm_h
	.p2align	2
_for_in_start_1_asm_h:                  ; @for_in_start_1_asm_h
; %bb.0:                                ; %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	LBB392_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB392_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_for_of_start_1_asm_h   ; -- Begin function for_of_start_1_asm_h
	.globl	_for_of_start_1_asm_h
	.p2align	2
_for_of_start_1_asm_h:                  ; @for_of_start_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_for_of_start_0_asm_h
                                        ; -- End function
	.private_extern	_for_await_of_start_1_asm_h ; -- Begin function for_await_of_start_1_asm_h
	.globl	_for_await_of_start_1_asm_h
	.p2align	2
_for_await_of_start_1_asm_h:            ; @for_await_of_start_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_for_await_of_start_0_asm_h
                                        ; -- End function
	.private_extern	_for_in_next_1_asm_h    ; -- Begin function for_in_next_1_asm_h
	.globl	_for_in_next_1_asm_h
	.p2align	2
_for_in_next_1_asm_h:                   ; @for_in_next_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_for_in_next_0_asm_h
                                        ; -- End function
	.private_extern	_for_of_next_1_asm_h    ; -- Begin function for_of_next_1_asm_h
	.globl	_for_of_next_1_asm_h
	.p2align	2
_for_of_next_1_asm_h:                   ; @for_of_next_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_for_of_next_0_asm_h
                                        ; -- End function
	.private_extern	_for_await_of_next_1_asm_h ; -- Begin function for_await_of_next_1_asm_h
	.globl	_for_await_of_next_1_asm_h
	.p2align	2
_for_await_of_next_1_asm_h:             ; @for_await_of_next_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_for_await_of_next_0_asm_h
                                        ; -- End function
	.private_extern	_iterator_get_value_done_1_asm_h ; -- Begin function iterator_get_value_done_1_asm_h
	.globl	_iterator_get_value_done_1_asm_h
	.p2align	2
_iterator_get_value_done_1_asm_h:       ; @iterator_get_value_done_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_iterator_get_value_done_0_asm_h
                                        ; -- End function
	.private_extern	_iterator_close_1_asm_h ; -- Begin function iterator_close_1_asm_h
	.globl	_iterator_close_1_asm_h
	.p2align	2
_iterator_close_1_asm_h:                ; @iterator_close_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_iterator_close_0_asm_h
                                        ; -- End function
	.private_extern	_iterator_close_return_1_asm_h ; -- Begin function iterator_close_return_1_asm_h
	.globl	_iterator_close_return_1_asm_h
	.p2align	2
_iterator_close_return_1_asm_h:         ; @iterator_close_return_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_iterator_close_return_0_asm_h
                                        ; -- End function
	.private_extern	_async_iterator_close_1_asm_h ; -- Begin function async_iterator_close_1_asm_h
	.globl	_async_iterator_close_1_asm_h
	.p2align	2
_async_iterator_close_1_asm_h:          ; @async_iterator_close_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_async_iterator_close_0_asm_h
                                        ; -- End function
	.private_extern	_async_iterator_next_1_asm_h ; -- Begin function async_iterator_next_1_asm_h
	.globl	_async_iterator_next_1_asm_h
	.p2align	2
_async_iterator_next_1_asm_h:           ; @async_iterator_next_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_async_iterator_next_0_asm_h
                                        ; -- End function
	.private_extern	_async_iterator_get_1_asm_h ; -- Begin function async_iterator_get_1_asm_h
	.globl	_async_iterator_get_1_asm_h
	.p2align	2
_async_iterator_get_1_asm_h:            ; @async_iterator_get_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_async_iterator_get_0_asm_h
                                        ; -- End function
	.private_extern	_initial_yield_1_asm_h  ; -- Begin function initial_yield_1_asm_h
	.globl	_initial_yield_1_asm_h
	.p2align	2
_initial_yield_1_asm_h:                 ; @initial_yield_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_initial_yield_0_asm_h
                                        ; -- End function
	.private_extern	_yield_1_asm_h          ; -- Begin function yield_1_asm_h
	.globl	_yield_1_asm_h
	.p2align	2
_yield_1_asm_h:                         ; @yield_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_yield_0_asm_h
                                        ; -- End function
	.private_extern	_yield_star_1_asm_h     ; -- Begin function yield_star_1_asm_h
	.globl	_yield_star_1_asm_h
	.p2align	2
_yield_star_1_asm_h:                    ; @yield_star_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_yield_star_0_asm_h
                                        ; -- End function
	.private_extern	_async_yield_star_1_asm_h ; -- Begin function async_yield_star_1_asm_h
	.globl	_async_yield_star_1_asm_h
	.p2align	2
_async_yield_star_1_asm_h:              ; @async_yield_star_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_async_yield_star_0_asm_h
                                        ; -- End function
	.private_extern	_await_1_asm_h          ; -- Begin function await_1_asm_h
	.globl	_await_1_asm_h
	.p2align	2
_await_1_asm_h:                         ; @await_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_await_0_asm_h
                                        ; -- End function
	.private_extern	_neg_1_asm_h            ; -- Begin function neg_1_asm_h
	.globl	_neg_1_asm_h
	.p2align	2
_neg_1_asm_h:                           ; @neg_1_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB409_3
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB409_6
; %bb.2:                                ; %B13
	orr	w8, w22, #0x80000000
	mov	w9, #-2147483648                ; =0x80000000
	cmp	w8, w9
	b.ne	LBB409_5
LBB409_3:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        ; =0x8c
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB409_8
; %bb.4:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB409_5:                               ; %B15
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB409_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB409_3
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
LBB409_8:                               ; %B17
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_plus_1_asm_h           ; -- Begin function plus_1_asm_h
	.globl	_plus_1_asm_h
	.p2align	2
_plus_1_asm_h:                          ; @plus_1_asm_h
; %bb.0:                                ; %B13
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB410_4
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB410_3
LBB410_2:                               ; %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB410_3:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.ne	LBB410_2
LBB410_4:                               ; %B10
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        ; =0x8d
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB410_6
; %bb.5:                                ; %B12
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB410_6:                               ; %B11
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_dec_1_asm_h            ; -- Begin function dec_1_asm_h
	.globl	_dec_1_asm_h
	.p2align	2
_dec_1_asm_h:                           ; @dec_1_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB411_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB411_4
; %bb.2:                                ; %B13
	subs	w8, w22, #1
	b.vs	LBB411_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB411_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB411_6
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
LBB411_6:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        ; =0x8e
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB411_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB411_8:                               ; %B17
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_inc_1_asm_h            ; -- Begin function inc_1_asm_h
	.globl	_inc_1_asm_h
	.p2align	2
_inc_1_asm_h:                           ; @inc_1_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB412_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB412_4
; %bb.2:                                ; %B13
	adds	w8, w22, #1
	b.vs	LBB412_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB412_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB412_6
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
LBB412_6:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        ; =0x8f
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB412_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB412_8:                               ; %B17
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_post_dec_1_asm_h       ; -- Begin function post_dec_1_asm_h
	.globl	_post_dec_1_asm_h
	.p2align	2
_post_dec_1_asm_h:                      ; @post_dec_1_asm_h
; %bb.0:                                ; %B16
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB413_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB413_4
; %bb.2:                                ; %B13
	subs	w8, w22, #1
	b.vs	LBB413_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB413_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB413_6
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
LBB413_6:                               ; %B5
	str	x22, [x20], #8
	mov	w0, #144                        ; =0x90
	b	_SlowJSPostInc_asm_h
                                        ; -- End function
	.private_extern	_post_inc_1_asm_h       ; -- Begin function post_inc_1_asm_h
	.globl	_post_inc_1_asm_h
	.p2align	2
_post_inc_1_asm_h:                      ; @post_inc_1_asm_h
; %bb.0:                                ; %B16
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB414_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB414_4
; %bb.2:                                ; %B13
	adds	w8, w22, #1
	b.vs	LBB414_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB414_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB414_6
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
LBB414_6:                               ; %B5
	str	x22, [x20], #8
	mov	w0, #145                        ; =0x91
	b	_SlowJSPostInc_asm_h
                                        ; -- End function
	.private_extern	_dec_loc_1_asm_h        ; -- Begin function dec_loc_1_asm_h
	.globl	_dec_loc_1_asm_h
	.p2align	2
_dec_loc_1_asm_h:                       ; @dec_loc_1_asm_h
; %bb.0:                                ; %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	LBB415_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB415_4
; %bb.2:                                ; %B13
	subs	w9, w1, #1
	b.vs	LBB415_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB415_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB415_6
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
LBB415_6:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	w2, #142                        ; =0x8e
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB415_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB415_8:                               ; %B17
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_inc_loc_1_asm_h        ; -- Begin function inc_loc_1_asm_h
	.globl	_inc_loc_1_asm_h
	.p2align	2
_inc_loc_1_asm_h:                       ; @inc_loc_1_asm_h
; %bb.0:                                ; %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	LBB416_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB416_4
; %bb.2:                                ; %B13
	adds	w9, w1, #1
	b.vs	LBB416_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB416_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB416_6
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
LBB416_6:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	w2, #143                        ; =0x8f
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB416_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB416_8:                               ; %B17
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_add_loc_1_asm_h        ; -- Begin function add_loc_1_asm_h
	.globl	_add_loc_1_asm_h
	.p2align	2
_add_loc_1_asm_h:                       ; @add_loc_1_asm_h
; %bb.0:                                ; %B42
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	ccmp	x22, x9, #2, ls
	b.hi	LBB417_14
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB417_5
; %bb.2:                                ; %B26
	cmp	x22, x9
	b.lo	LBB417_8
; %bb.3:                                ; %B36
	adds	w9, w1, w22
	b.vs	LBB417_14
; %bb.4:                                ; %B38
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB417_5:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB417_14
; %bb.6:                                ; %B11
	cmp	x22, x9
	b.lo	LBB417_12
; %bb.7:                                ; %B21
	scvtf	d0, w22
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	LBB417_11
LBB417_8:                               ; %B28
	tst	x22, #0xfffe000000000000
	b.eq	LBB417_14
; %bb.9:                                ; %B31
	scvtf	d0, w1
	add	x9, x22, x9
LBB417_10:                              ; %B31
	fmov	d1, x9
	fadd	d0, d0, d1
LBB417_11:                              ; %B31
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
LBB417_12:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB417_14
; %bb.13:                               ; %B16
	add	x10, x1, x9
	add	x9, x22, x9
	fmov	d0, x10
	b	LBB417_10
LBB417_14:                              ; %B7
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
	b.ne	LBB417_17
; %bb.15:                               ; %B39
	mov	x0, x24
	mov	x2, x22
	stur	x22, [x8, #-8]
	str	x8, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB417_18
; %bb.16:                               ; %B41
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB417_17:                              ; %B8
	mov	x20, x8
	stur	x22, [x8, #-8]
	mov	w0, #1                          ; =0x1
	b	_FastJSConcatString_asm_h
LBB417_18:                              ; %B40
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_not_1_asm_h            ; -- Begin function not_1_asm_h
	.globl	_not_1_asm_h
	.p2align	2
_not_1_asm_h:                           ; @not_1_asm_h
; %bb.0:                                ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB418_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB418_2:                               ; %B4
	str	x22, [x20], #8
	mov	x0, x22
	b	_SlowJSNot_asm_h
                                        ; -- End function
	.private_extern	_lnot_1_asm_h           ; -- Begin function lnot_1_asm_h
	.globl	_lnot_1_asm_h
	.p2align	2
_lnot_1_asm_h:                          ; @lnot_1_asm_h
; %bb.0:                                ; %B14
	cmp	x22, #5
	b.le	LBB419_4
; %bb.1:                                ; %B14
	cmp	x22, #6
	b.eq	LBB419_6
; %bb.2:                                ; %B14
	cmp	x22, #7
	b.eq	LBB419_8
; %bb.3:                                ; %B14
	cmp	x22, #18
	b.eq	LBB419_6
	b	LBB419_7
LBB419_4:                               ; %B14
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB419_6
; %bb.5:                                ; %B14
	cmp	x22, #2
	b.ne	LBB419_7
LBB419_6:                               ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB419_7:                               ; %B10
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB419_9
LBB419_8:                               ; %B12
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB419_9:                               ; %B13
	str	x22, [x20], #8
	mov	x0, x22
	b	_SlowToBoolean_asm_h
                                        ; -- End function
	.private_extern	_typeof_1_asm_h         ; -- Begin function typeof_1_asm_h
	.globl	_typeof_1_asm_h
	.p2align	2
_typeof_1_asm_h:                        ; @typeof_1_asm_h
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
	b.eq	LBB420_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB420_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_delete_1_asm_h         ; -- Begin function delete_1_asm_h
	.globl	_delete_1_asm_h
	.p2align	2
_delete_1_asm_h:                        ; @delete_1_asm_h
; %bb.0:                                ; %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x23, #48]
	bl	_prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	LBB421_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB421_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_delete_var_1_asm_h     ; -- Begin function delete_var_1_asm_h
	.globl	_delete_var_1_asm_h
	.p2align	2
_delete_var_1_asm_h:                    ; @delete_var_1_asm_h
; %bb.0:                                ; %B1
	ldr	x1, [x24, #208]
	ldr	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w3, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_DeleteProperty_GC
	tbnz	w0, #31, LBB422_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x21, x8, ne
	br	x1
LBB422_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_mul_1_asm_h            ; -- Begin function mul_1_asm_h
	.globl	_mul_1_asm_h
	.p2align	2
_mul_1_asm_h:                           ; @mul_1_asm_h
; %bb.0:                                ; %B47
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB423_18
; %bb.1:                                ; %B47
	cmp	x21, x8
	b.hi	LBB423_18
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB423_8
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB423_11
; %bb.4:                                ; %B33
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	LBB423_18
; %bb.5:                                ; %B36
	cbnz	w8, LBB423_7
; %bb.6:                                ; %B36
	orr	w9, w22, w21
	tbnz	w9, #31, LBB423_15
LBB423_7:                               ; %B43
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB423_8:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB423_18
; %bb.9:                                ; %B7
	cmp	x21, x8
	b.lo	LBB423_16
; %bb.10:                               ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	LBB423_14
LBB423_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB423_18
; %bb.12:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB423_13:                              ; %B28
	fmov	d1, x8
	fmul	d0, d0, d1
LBB423_14:                              ; %B28
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
LBB423_15:                              ; %B40
	mov	x22, #-9222809086901354496      ; =0x8002000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB423_16:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB423_18
; %bb.17:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB423_13
LBB423_18:                              ; %B44
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        ; =0x9a
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB423_20
; %bb.19:                               ; %B46
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB423_20:                              ; %B45
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_div_1_asm_h            ; -- Begin function div_1_asm_h
	.globl	_div_1_asm_h
	.p2align	2
_div_1_asm_h:                           ; @div_1_asm_h
; %bb.0:                                ; %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB424_14
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB424_14
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB424_5
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB424_8
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
LBB424_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB424_14
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB424_12
; %bb.7:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	LBB424_11
LBB424_8:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB424_14
; %bb.9:                                ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB424_10:                              ; %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
LBB424_11:                              ; %B28
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
LBB424_12:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB424_14
; %bb.13:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB424_10
LBB424_14:                              ; %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        ; =0x9b
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB424_16
; %bb.15:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB424_16:                              ; %B42
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_mod_1_asm_h            ; -- Begin function mod_1_asm_h
	.globl	_mod_1_asm_h
	.p2align	2
_mod_1_asm_h:                           ; @mod_1_asm_h
; %bb.0:                                ; %B39
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB425_16
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB425_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB425_7
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB425_10
; %bb.4:                                ; %B33
	tbnz	w22, #31, LBB425_16
; %bb.5:                                ; %B33
	cmp	w21, #1
	b.lt	LBB425_16
; %bb.6:                                ; %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB425_7:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB425_16
; %bb.8:                                ; %B7
	cmp	x21, x8
	b.lo	LBB425_14
; %bb.9:                                ; %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	LBB425_13
LBB425_10:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB425_16
; %bb.11:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB425_12:                              ; %B28
	fmov	d1, x8
LBB425_13:                              ; %B28
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
LBB425_14:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB425_16
; %bb.15:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB425_12
LBB425_16:                              ; %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        ; =0x9c
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB425_18
; %bb.17:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB425_18:                              ; %B37
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_add_1_asm_h            ; -- Begin function add_1_asm_h
	.globl	_add_1_asm_h
	.p2align	2
_add_1_asm_h:                           ; @add_1_asm_h
; %bb.0:                                ; %B42
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB426_15
; %bb.1:                                ; %B42
	cmp	x21, x8
	b.hi	LBB426_15
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB426_6
; %bb.3:                                ; %B26
	cmp	x21, x8
	b.lo	LBB426_9
; %bb.4:                                ; %B36
	adds	w8, w22, w21
	b.vs	LBB426_15
; %bb.5:                                ; %B38
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB426_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB426_15
; %bb.7:                                ; %B11
	cmp	x21, x8
	b.lo	LBB426_13
; %bb.8:                                ; %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	LBB426_12
LBB426_9:                               ; %B28
	tst	x21, #0xfffe000000000000
	b.eq	LBB426_15
; %bb.10:                               ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB426_11:                              ; %B31
	fmov	d1, x8
	fadd	d0, d0, d1
LBB426_12:                              ; %B31
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
LBB426_13:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB426_15
; %bb.14:                               ; %B16
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB426_11
LBB426_15:                              ; %B7
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
	b.ne	LBB426_18
; %bb.16:                               ; %B7
	cbz	w9, LBB426_18
; %bb.17:                               ; %B8
	mov	x20, x8
	stur	x21, [x8, #-8]
	mov	x0, xzr
	b	_FastJSConcatString_asm_h
LBB426_18:                              ; %B39
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stur	x21, [x8, #-8]
	str	x8, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB426_20
; %bb.19:                               ; %B41
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB426_20:                              ; %B40
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_sub_1_asm_h            ; -- Begin function sub_1_asm_h
	.globl	_sub_1_asm_h
	.p2align	2
_sub_1_asm_h:                           ; @sub_1_asm_h
; %bb.0:                                ; %B39
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB427_15
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB427_15
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB427_6
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB427_9
; %bb.4:                                ; %B33
	subs	w8, w22, w21
	b.vs	LBB427_15
; %bb.5:                                ; %B35
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB427_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB427_15
; %bb.7:                                ; %B7
	cmp	x21, x8
	b.lo	LBB427_13
; %bb.8:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	LBB427_12
LBB427_9:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB427_15
; %bb.10:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB427_11:                              ; %B28
	fmov	d1, x8
	fsub	d0, d0, d1
LBB427_12:                              ; %B28
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
LBB427_13:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB427_15
; %bb.14:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB427_11
LBB427_15:                              ; %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        ; =0x9e
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB427_17
; %bb.16:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB427_17:                              ; %B37
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_pow_1_asm_h            ; -- Begin function pow_1_asm_h
	.globl	_pow_1_asm_h
	.p2align	2
_pow_1_asm_h:                           ; @pow_1_asm_h
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
	b.eq	LBB428_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB428_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_shl_1_asm_h            ; -- Begin function shl_1_asm_h
	.globl	_shl_1_asm_h
	.p2align	2
_shl_1_asm_h:                           ; @shl_1_asm_h
; %bb.0:                                ; %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB429_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB429_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB429_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB429_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB429_5:                               ; %B16
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #8
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB429_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB429_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB429_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB429_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB429_5
LBB429_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        ; =0xa0
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB429_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB429_12:                              ; %B26
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_sar_1_asm_h            ; -- Begin function sar_1_asm_h
	.globl	_sar_1_asm_h
	.p2align	2
_sar_1_asm_h:                           ; @sar_1_asm_h
; %bb.0:                                ; %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB430_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB430_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB430_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB430_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB430_5:                               ; %B16
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #8
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB430_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB430_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB430_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB430_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB430_5
LBB430_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        ; =0xa1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB430_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB430_12:                              ; %B26
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_shr_1_asm_h            ; -- Begin function shr_1_asm_h
	.globl	_shr_1_asm_h
	.p2align	2
_shr_1_asm_h:                           ; @shr_1_asm_h
; %bb.0:                                ; %B36
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB431_11
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB431_11
; %bb.2:                                ; %B10
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB431_6
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB431_11
; %bb.4:                                ; %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, LBB431_10
LBB431_5:                               ; %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB431_6:                               ; %B12
	tst	x22, #0xfffe000000000000
	b.eq	LBB431_11
; %bb.7:                                ; %B12
	cmp	x21, x8
	b.lo	LBB431_11
; %bb.8:                                ; %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB431_11
; %bb.9:                                ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, LBB431_5
LBB431_10:                              ; %B6
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
LBB431_11:                              ; %B33
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	LBB431_13
; %bb.12:                               ; %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB431_13:                              ; %B34
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_lt_1_asm_h             ; -- Begin function lt_1_asm_h
	.globl	_lt_1_asm_h
	.p2align	2
_lt_1_asm_h:                            ; @lt_1_asm_h
; %bb.0:                                ; %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB432_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB432_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB432_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB432_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, lt
	br	x1
LBB432_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB432_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB432_10
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
LBB432_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB432_12
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
LBB432_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB432_12
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
LBB432_12:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        ; =0xa3
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB432_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB432_14:                              ; %B22
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_lte_1_asm_h            ; -- Begin function lte_1_asm_h
	.globl	_lte_1_asm_h
	.p2align	2
_lte_1_asm_h:                           ; @lte_1_asm_h
; %bb.0:                                ; %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB433_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB433_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB433_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB433_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, le
	br	x1
LBB433_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB433_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB433_10
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
LBB433_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB433_12
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
LBB433_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB433_12
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
LBB433_12:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        ; =0xa4
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB433_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB433_14:                              ; %B22
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_gt_1_asm_h             ; -- Begin function gt_1_asm_h
	.globl	_gt_1_asm_h
	.p2align	2
_gt_1_asm_h:                            ; @gt_1_asm_h
; %bb.0:                                ; %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB434_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB434_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB434_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB434_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB434_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB434_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB434_10
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
LBB434_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB434_12
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
LBB434_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB434_12
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
LBB434_12:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        ; =0xa5
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB434_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB434_14:                              ; %B22
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_gte_1_asm_h            ; -- Begin function gte_1_asm_h
	.globl	_gte_1_asm_h
	.p2align	2
_gte_1_asm_h:                           ; @gte_1_asm_h
; %bb.0:                                ; %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB435_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB435_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB435_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB435_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB435_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB435_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB435_10
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
LBB435_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB435_12
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
LBB435_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB435_12
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
LBB435_12:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        ; =0xa6
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB435_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB435_14:                              ; %B22
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_instanceof_1_asm_h     ; -- Begin function instanceof_1_asm_h
	.globl	_instanceof_1_asm_h
	.p2align	2
_instanceof_1_asm_h:                    ; @instanceof_1_asm_h
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
	b.eq	LBB436_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB436_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_in_1_asm_h             ; -- Begin function in_1_asm_h
	.globl	_in_1_asm_h
	.p2align	2
_in_1_asm_h:                            ; @in_1_asm_h
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
	b.eq	LBB437_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB437_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_eq_1_asm_h             ; -- Begin function eq_1_asm_h
	.globl	_eq_1_asm_h
	.p2align	2
_eq_1_asm_h:                            ; @eq_1_asm_h
; %bb.0:                                ; %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB438_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB438_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB438_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB438_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB438_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB438_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB438_11
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
LBB438_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB438_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB438_10:                              ; %B39
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
LBB438_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB438_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB438_10
LBB438_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB438_15
LBB438_14:                              ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB438_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB438_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB438_14
	b	LBB438_20
LBB438_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB438_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB438_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB438_21
LBB438_20:                              ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB438_21:                              ; %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB438_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB438_23:                              ; %B42
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_neq_1_asm_h            ; -- Begin function neq_1_asm_h
	.globl	_neq_1_asm_h
	.p2align	2
_neq_1_asm_h:                           ; @neq_1_asm_h
; %bb.0:                                ; %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB439_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB439_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB439_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB439_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB439_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB439_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB439_11
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
LBB439_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB439_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB439_10:                              ; %B39
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
LBB439_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB439_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB439_10
LBB439_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB439_15
LBB439_14:                              ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB439_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB439_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB439_14
	b	LBB439_20
LBB439_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB439_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB439_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB439_21
LBB439_20:                              ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB439_21:                              ; %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB439_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB439_23:                              ; %B42
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_strict_eq_1_asm_h      ; -- Begin function strict_eq_1_asm_h
	.globl	_strict_eq_1_asm_h
	.p2align	2
_strict_eq_1_asm_h:                     ; @strict_eq_1_asm_h
; %bb.0:                                ; %B39
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB440_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB440_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB440_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB440_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB440_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB440_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB440_11
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
LBB440_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB440_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB440_10:                              ; %B34
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
LBB440_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB440_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB440_10
LBB440_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB440_15
; %bb.14:                               ; %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB440_15:                              ; %B13
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
	b.ne	LBB440_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB440_22
LBB440_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB440_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB440_23
LBB440_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB440_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB440_25
LBB440_21:                              ; %B21
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB440_22:                              ; %B14
	str	x21, [x20], #8
	mov	x0, xzr
	b	_FastStringEqual_asm_h
LBB440_23:                              ; %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB440_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB440_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #8
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB440_28
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB440_27:                              ; %B37
	b	_exception_spill_top1_asm_h
LBB440_28:                              ; %B8
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_strict_neq_1_asm_h     ; -- Begin function strict_neq_1_asm_h
	.globl	_strict_neq_1_asm_h
	.p2align	2
_strict_neq_1_asm_h:                    ; @strict_neq_1_asm_h
; %bb.0:                                ; %B39
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB441_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB441_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB441_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB441_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB441_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB441_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB441_11
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
LBB441_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB441_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB441_10:                              ; %B34
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
LBB441_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB441_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB441_10
LBB441_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB441_15
; %bb.14:                               ; %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB441_15:                              ; %B13
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
	b.ne	LBB441_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB441_22
LBB441_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB441_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB441_23
LBB441_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB441_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB441_25
LBB441_21:                              ; %B21
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB441_22:                              ; %B14
	str	x21, [x20], #8
	mov	w0, #1                          ; =0x1
	b	_FastStringEqual_asm_h
LBB441_23:                              ; %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB441_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB441_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #8
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB441_28
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB441_27:                              ; %B37
	b	_exception_spill_top1_asm_h
LBB441_28:                              ; %B8
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_and_1_asm_h            ; -- Begin function and_1_asm_h
	.globl	_and_1_asm_h
	.p2align	2
_and_1_asm_h:                           ; @and_1_asm_h
; %bb.0:                                ; %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB442_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB442_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB442_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB442_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB442_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	and	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB442_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB442_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB442_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB442_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB442_5
LBB442_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        ; =0xad
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB442_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB442_12:                              ; %B26
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_xor_1_asm_h            ; -- Begin function xor_1_asm_h
	.globl	_xor_1_asm_h
	.p2align	2
_xor_1_asm_h:                           ; @xor_1_asm_h
; %bb.0:                                ; %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB443_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB443_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB443_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB443_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB443_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	eor	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB443_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB443_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB443_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB443_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB443_5
LBB443_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        ; =0xae
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB443_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB443_12:                              ; %B26
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_or_1_asm_h             ; -- Begin function or_1_asm_h
	.globl	_or_1_asm_h
	.p2align	2
_or_1_asm_h:                            ; @or_1_asm_h
; %bb.0:                                ; %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB444_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB444_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB444_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB444_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB444_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB444_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB444_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB444_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB444_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB444_5
LBB444_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        ; =0xaf
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB444_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB444_12:                              ; %B26
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_nop_1_asm_h            ; -- Begin function nop_1_asm_h
	.globl	_nop_1_asm_h
	.p2align	2
_nop_1_asm_h:                           ; @nop_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_minus1_1_asm_h    ; -- Begin function push_minus1_1_asm_h
	.globl	_push_minus1_1_asm_h
	.p2align	2
_push_minus1_1_asm_h:                   ; @push_minus1_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562945658454017          ; =0xfffe0000ffffffff
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_0_1_asm_h         ; -- Begin function push_0_1_asm_h
	.globl	_push_0_1_asm_h
	.p2align	2
_push_0_1_asm_h:                        ; @push_0_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421312          ; =0xfffe000000000000
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_1_1_asm_h         ; -- Begin function push_1_1_asm_h
	.globl	_push_1_1_asm_h
	.p2align	2
_push_1_1_asm_h:                        ; @push_1_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421311          ; =0xfffe000000000001
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_2_1_asm_h         ; -- Begin function push_2_1_asm_h
	.globl	_push_2_1_asm_h
	.p2align	2
_push_2_1_asm_h:                        ; @push_2_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #2                         ; =0x2
	movk	x21, #65534, lsl #48
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_3_1_asm_h         ; -- Begin function push_3_1_asm_h
	.globl	_push_3_1_asm_h
	.p2align	2
_push_3_1_asm_h:                        ; @push_3_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421309          ; =0xfffe000000000003
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_4_1_asm_h         ; -- Begin function push_4_1_asm_h
	.globl	_push_4_1_asm_h
	.p2align	2
_push_4_1_asm_h:                        ; @push_4_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #4                         ; =0x4
	movk	x21, #65534, lsl #48
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_5_1_asm_h         ; -- Begin function push_5_1_asm_h
	.globl	_push_5_1_asm_h
	.p2align	2
_push_5_1_asm_h:                        ; @push_5_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #5                         ; =0x5
	movk	x21, #65534, lsl #48
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_6_1_asm_h         ; -- Begin function push_6_1_asm_h
	.globl	_push_6_1_asm_h
	.p2align	2
_push_6_1_asm_h:                        ; @push_6_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #6                         ; =0x6
	movk	x21, #65534, lsl #48
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_7_1_asm_h         ; -- Begin function push_7_1_asm_h
	.globl	_push_7_1_asm_h
	.p2align	2
_push_7_1_asm_h:                        ; @push_7_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421305          ; =0xfffe000000000007
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_i8_1_asm_h        ; -- Begin function push_i8_1_asm_h
	.globl	_push_i8_1_asm_h
	.p2align	2
_push_i8_1_asm_h:                       ; @push_i8_1_asm_h
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
	.private_extern	_push_i16_1_asm_h       ; -- Begin function push_i16_1_asm_h
	.globl	_push_i16_1_asm_h
	.p2align	2
_push_i16_1_asm_h:                      ; @push_i16_1_asm_h
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
	.private_extern	_push_const8_1_asm_h    ; -- Begin function push_const8_1_asm_h
	.globl	_push_const8_1_asm_h
	.p2align	2
_push_const8_1_asm_h:                   ; @push_const8_1_asm_h
; %bb.0:                                ; %B3
	sub	sp, sp, #16
	ldr	x8, [x23, #112]
	ldrb	w9, [x19]
	ldr	w10, [x24, #336]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, LBB457_2
; %bb.1:                                ; %B4
	mov	x8, x20
	mov	x0, x24
	mov	x2, x19
	str	x22, [x8], #8
	str	x8, [x23, #48]
	str	x1, [sp, #8]                    ; 8-byte Folded Spill
	bl	_DebuggerPause
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
LBB457_2:                               ; %B1
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x21, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
                                        ; -- End function
	.private_extern	_fclosure8_1_asm_h      ; -- Begin function fclosure8_1_asm_h
	.globl	_fclosure8_1_asm_h
	.p2align	2
_fclosure8_1_asm_h:                     ; @fclosure8_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_fclosure8_0_asm_h
                                        ; -- End function
	.private_extern	_push_empty_string_1_asm_h ; -- Begin function push_empty_string_1_asm_h
	.globl	_push_empty_string_1_asm_h
	.p2align	2
_push_empty_string_1_asm_h:             ; @push_empty_string_1_asm_h
; %bb.0:                                ; %B1
	mov	x8, x20
	mov	x0, x24
	mov	w1, #47                         ; =0x2f
	mov	w2, #1                          ; =0x1
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB459_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB459_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_get_loc8_1_asm_h       ; -- Begin function get_loc8_1_asm_h
	.globl	_get_loc8_1_asm_h
	.p2align	2
_get_loc8_1_asm_h:                      ; @get_loc8_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19, #1]
	ldrb	w9, [x19], #2
	add	w8, w8, #486
	ldr	x21, [x27, x9, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_loc8_1_asm_h       ; -- Begin function put_loc8_1_asm_h
	.globl	_put_loc8_1_asm_h
	.p2align	2
_put_loc8_1_asm_h:                      ; @put_loc8_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc8_1_asm_h       ; -- Begin function set_loc8_1_asm_h
	.globl	_set_loc8_1_asm_h
	.p2align	2
_set_loc8_1_asm_h:                      ; @set_loc8_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_loc0_1_asm_h       ; -- Begin function get_loc0_1_asm_h
	.globl	_get_loc0_1_asm_h
	.p2align	2
_get_loc0_1_asm_h:                      ; @get_loc0_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_loc1_1_asm_h       ; -- Begin function get_loc1_1_asm_h
	.globl	_get_loc1_1_asm_h
	.p2align	2
_get_loc1_1_asm_h:                      ; @get_loc1_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27, #8]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_loc2_1_asm_h       ; -- Begin function get_loc2_1_asm_h
	.globl	_get_loc2_1_asm_h
	.p2align	2
_get_loc2_1_asm_h:                      ; @get_loc2_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27, #16]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_loc3_1_asm_h       ; -- Begin function get_loc3_1_asm_h
	.globl	_get_loc3_1_asm_h
	.p2align	2
_get_loc3_1_asm_h:                      ; @get_loc3_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x27, #24]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_loc0_1_asm_h       ; -- Begin function put_loc0_1_asm_h
	.globl	_put_loc0_1_asm_h
	.p2align	2
_put_loc0_1_asm_h:                      ; @put_loc0_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x27]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_loc1_1_asm_h       ; -- Begin function put_loc1_1_asm_h
	.globl	_put_loc1_1_asm_h
	.p2align	2
_put_loc1_1_asm_h:                      ; @put_loc1_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_loc2_1_asm_h       ; -- Begin function put_loc2_1_asm_h
	.globl	_put_loc2_1_asm_h
	.p2align	2
_put_loc2_1_asm_h:                      ; @put_loc2_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_loc3_1_asm_h       ; -- Begin function put_loc3_1_asm_h
	.globl	_put_loc3_1_asm_h
	.p2align	2
_put_loc3_1_asm_h:                      ; @put_loc3_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc0_1_asm_h       ; -- Begin function set_loc0_1_asm_h
	.globl	_set_loc0_1_asm_h
	.p2align	2
_set_loc0_1_asm_h:                      ; @set_loc0_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x27]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc1_1_asm_h       ; -- Begin function set_loc1_1_asm_h
	.globl	_set_loc1_1_asm_h
	.p2align	2
_set_loc1_1_asm_h:                      ; @set_loc1_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc2_1_asm_h       ; -- Begin function set_loc2_1_asm_h
	.globl	_set_loc2_1_asm_h
	.p2align	2
_set_loc2_1_asm_h:                      ; @set_loc2_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc3_1_asm_h       ; -- Begin function set_loc3_1_asm_h
	.globl	_set_loc3_1_asm_h
	.p2align	2
_set_loc3_1_asm_h:                      ; @set_loc3_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_arg0_1_asm_h       ; -- Begin function get_arg0_1_asm_h
	.globl	_get_arg0_1_asm_h
	.p2align	2
_get_arg0_1_asm_h:                      ; @get_arg0_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_arg1_1_asm_h       ; -- Begin function get_arg1_1_asm_h
	.globl	_get_arg1_1_asm_h
	.p2align	2
_get_arg1_1_asm_h:                      ; @get_arg1_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28, #8]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_arg2_1_asm_h       ; -- Begin function get_arg2_1_asm_h
	.globl	_get_arg2_1_asm_h
	.p2align	2
_get_arg2_1_asm_h:                      ; @get_arg2_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28, #16]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_arg3_1_asm_h       ; -- Begin function get_arg3_1_asm_h
	.globl	_get_arg3_1_asm_h
	.p2align	2
_get_arg3_1_asm_h:                      ; @get_arg3_1_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	ldr	x21, [x28, #24]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_arg0_1_asm_h       ; -- Begin function put_arg0_1_asm_h
	.globl	_put_arg0_1_asm_h
	.p2align	2
_put_arg0_1_asm_h:                      ; @put_arg0_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x28]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_arg1_1_asm_h       ; -- Begin function put_arg1_1_asm_h
	.globl	_put_arg1_1_asm_h
	.p2align	2
_put_arg1_1_asm_h:                      ; @put_arg1_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_arg2_1_asm_h       ; -- Begin function put_arg2_1_asm_h
	.globl	_put_arg2_1_asm_h
	.p2align	2
_put_arg2_1_asm_h:                      ; @put_arg2_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_arg3_1_asm_h       ; -- Begin function put_arg3_1_asm_h
	.globl	_put_arg3_1_asm_h
	.p2align	2
_put_arg3_1_asm_h:                      ; @put_arg3_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_arg0_1_asm_h       ; -- Begin function set_arg0_1_asm_h
	.globl	_set_arg0_1_asm_h
	.p2align	2
_set_arg0_1_asm_h:                      ; @set_arg0_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x28]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_arg1_1_asm_h       ; -- Begin function set_arg1_1_asm_h
	.globl	_set_arg1_1_asm_h
	.p2align	2
_set_arg1_1_asm_h:                      ; @set_arg1_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_arg2_1_asm_h       ; -- Begin function set_arg2_1_asm_h
	.globl	_set_arg2_1_asm_h
	.p2align	2
_set_arg2_1_asm_h:                      ; @set_arg2_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_arg3_1_asm_h       ; -- Begin function set_arg3_1_asm_h
	.globl	_set_arg3_1_asm_h
	.p2align	2
_set_arg3_1_asm_h:                      ; @set_arg3_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_var_ref0_1_asm_h   ; -- Begin function get_var_ref0_1_asm_h
	.globl	_get_var_ref0_1_asm_h
	.p2align	2
_get_var_ref0_1_asm_h:                  ; @get_var_ref0_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x21, [x8]
	br	x1
                                        ; -- End function
	.private_extern	_get_var_ref1_1_asm_h   ; -- Begin function get_var_ref1_1_asm_h
	.globl	_get_var_ref1_1_asm_h
	.p2align	2
_get_var_ref1_1_asm_h:                  ; @get_var_ref1_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #8]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x21, [x8]
	br	x1
                                        ; -- End function
	.private_extern	_get_var_ref2_1_asm_h   ; -- Begin function get_var_ref2_1_asm_h
	.globl	_get_var_ref2_1_asm_h
	.p2align	2
_get_var_ref2_1_asm_h:                  ; @get_var_ref2_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #16]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x21, [x8]
	br	x1
                                        ; -- End function
	.private_extern	_get_var_ref3_1_asm_h   ; -- Begin function get_var_ref3_1_asm_h
	.globl	_get_var_ref3_1_asm_h
	.p2align	2
_get_var_ref3_1_asm_h:                  ; @get_var_ref3_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #24]
	ldrb	w9, [x19], #1
	ldr	x8, [x8]
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x21, [x8]
	br	x1
                                        ; -- End function
	.private_extern	_put_var_ref0_1_asm_h   ; -- Begin function put_var_ref0_1_asm_h
	.globl	_put_var_ref0_1_asm_h
	.p2align	2
_put_var_ref0_1_asm_h:                  ; @put_var_ref0_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_var_ref1_1_asm_h   ; -- Begin function put_var_ref1_1_asm_h
	.globl	_put_var_ref1_1_asm_h
	.p2align	2
_put_var_ref1_1_asm_h:                  ; @put_var_ref1_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_var_ref2_1_asm_h   ; -- Begin function put_var_ref2_1_asm_h
	.globl	_put_var_ref2_1_asm_h
	.p2align	2
_put_var_ref2_1_asm_h:                  ; @put_var_ref2_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_var_ref3_1_asm_h   ; -- Begin function put_var_ref3_1_asm_h
	.globl	_put_var_ref3_1_asm_h
	.p2align	2
_put_var_ref3_1_asm_h:                  ; @put_var_ref3_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_var_ref0_1_asm_h   ; -- Begin function set_var_ref0_1_asm_h
	.globl	_set_var_ref0_1_asm_h
	.p2align	2
_set_var_ref0_1_asm_h:                  ; @set_var_ref0_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_var_ref1_1_asm_h   ; -- Begin function set_var_ref1_1_asm_h
	.globl	_set_var_ref1_1_asm_h
	.p2align	2
_set_var_ref1_1_asm_h:                  ; @set_var_ref1_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_var_ref2_1_asm_h   ; -- Begin function set_var_ref2_1_asm_h
	.globl	_set_var_ref2_1_asm_h
	.p2align	2
_set_var_ref2_1_asm_h:                  ; @set_var_ref2_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_var_ref3_1_asm_h   ; -- Begin function set_var_ref3_1_asm_h
	.globl	_set_var_ref3_1_asm_h
	.p2align	2
_set_var_ref3_1_asm_h:                  ; @set_var_ref3_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_length_1_asm_h     ; -- Begin function get_length_1_asm_h
	.globl	_get_length_1_asm_h
	.p2align	2
_get_length_1_asm_h:                    ; @get_length_1_asm_h
; %bb.0:                                ; %B27
	mov	x9, #2                          ; =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	LBB499_2
; %bb.1:                                ; %B27
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB499_3
LBB499_2:                               ; %B28
	and	x8, x22, #0xfffffffffffc
	ldrb	w9, [x19], #1
	ldr	w8, [x8, #4]
	mov	x10, #-562949953421312          ; =0xfffe000000000000
	add	w9, w9, #243
	bfxil	x10, x8, #0, #30
	ldr	x1, [x25, w9, uxtw #3]
	mov	x22, x10
	br	x1
LBB499_3:                               ; %B21
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB499_13
; %bb.4:                                ; %B22
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB499_5:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB499_6 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w11, #0x30
	ldr	w10, [x13, w10, uxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB499_8
LBB499_6:                               ; %B1
                                        ;   Parent Loop BB499_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, #48
	b.eq	LBB499_10
; %bb.7:                                ; %B9
                                        ;   in Loop: Header=BB499_6 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB499_6
LBB499_8:                               ; %B14
                                        ;   in Loop: Header=BB499_5 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB499_13
; %bb.9:                                ; %B17
                                        ;   in Loop: Header=BB499_5 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB499_5
	b	LBB499_12
LBB499_10:                              ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB499_13
; %bb.11:                               ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB499_12:                              ; %B6
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB499_13:                              ; %B24
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
	b.eq	LBB499_15
; %bb.14:                               ; %B26
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB499_15:                              ; %B25
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_if_false8_1_asm_h      ; -- Begin function if_false8_1_asm_h
	.globl	_if_false8_1_asm_h
	.p2align	2
_if_false8_1_asm_h:                     ; @if_false8_1_asm_h
; %bb.0:                                ; %B23
	cmp	x22, #5
	b.le	LBB500_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB500_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB500_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB500_6
	b	LBB500_7
LBB500_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB500_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB500_7
LBB500_6:                               ; %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB500_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB500_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB500_10
LBB500_9:                               ; %B19
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB500_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB500_13
; %bb.11:                               ; %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB500_6
	b.vs	LBB500_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB500_9
	b	LBB500_6
LBB500_13:                              ; %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	_SlowToBoolean_asm_h
                                        ; -- End function
	.private_extern	_if_true8_1_asm_h       ; -- Begin function if_true8_1_asm_h
	.globl	_if_true8_1_asm_h
	.p2align	2
_if_true8_1_asm_h:                      ; @if_true8_1_asm_h
; %bb.0:                                ; %B23
	cmp	x22, #5
	b.le	LBB501_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB501_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB501_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB501_6
	b	LBB501_7
LBB501_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB501_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB501_7
LBB501_6:                               ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB501_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB501_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB501_10
LBB501_9:                               ; %B19
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB501_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB501_13
; %bb.11:                               ; %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB501_6
	b.vs	LBB501_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB501_9
	b	LBB501_6
LBB501_13:                              ; %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	_SlowToBoolean_asm_h
                                        ; -- End function
	.private_extern	_goto8_1_asm_h          ; -- Begin function goto8_1_asm_h
	.globl	_goto8_1_asm_h
	.p2align	2
_goto8_1_asm_h:                         ; @goto8_1_asm_h
; %bb.0:                                ; %B0
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_goto16_1_asm_h         ; -- Begin function goto16_1_asm_h
	.globl	_goto16_1_asm_h
	.p2align	2
_goto16_1_asm_h:                        ; @goto16_1_asm_h
; %bb.0:                                ; %B0
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_call0_1_asm_h          ; -- Begin function call0_1_asm_h
	.globl	_call0_1_asm_h
	.p2align	2
_call0_1_asm_h:                         ; @call0_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_call0_0_asm_h
                                        ; -- End function
	.private_extern	_call1_1_asm_h          ; -- Begin function call1_1_asm_h
	.globl	_call1_1_asm_h
	.p2align	2
_call1_1_asm_h:                         ; @call1_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_call1_0_asm_h
                                        ; -- End function
	.private_extern	_call2_1_asm_h          ; -- Begin function call2_1_asm_h
	.globl	_call2_1_asm_h
	.p2align	2
_call2_1_asm_h:                         ; @call2_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_call2_0_asm_h
                                        ; -- End function
	.private_extern	_call3_1_asm_h          ; -- Begin function call3_1_asm_h
	.globl	_call3_1_asm_h
	.p2align	2
_call3_1_asm_h:                         ; @call3_1_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	b	_call3_0_asm_h
                                        ; -- End function
	.private_extern	_is_undefined_1_asm_h   ; -- Begin function is_undefined_1_asm_h
	.globl	_is_undefined_1_asm_h
	.p2align	2
_is_undefined_1_asm_h:                  ; @is_undefined_1_asm_h
; %bb.0:                                ; %B2
	cmp	x22, #18
	b.ne	LBB508_2
; %bb.1:                                ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB508_2:                               ; %B5
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_is_null_1_asm_h        ; -- Begin function is_null_1_asm_h
	.globl	_is_null_1_asm_h
	.p2align	2
_is_null_1_asm_h:                       ; @is_null_1_asm_h
; %bb.0:                                ; %B2
	cmp	x22, #2
	b.ne	LBB509_2
; %bb.1:                                ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB509_2:                               ; %B5
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_is_function_1_asm_h    ; -- Begin function is_function_1_asm_h
	.globl	_is_function_1_asm_h
	.p2align	2
_is_function_1_asm_h:                   ; @is_function_1_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x22
	bl	_js_operator_typeof_gc
	cmp	w0, #27
	b.ne	LBB510_2
; %bb.1:                                ; %B2
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB510_2:                               ; %B5
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_inc_coverage_1_asm_h   ; -- Begin function inc_coverage_1_asm_h
	.globl	_inc_coverage_1_asm_h
	.p2align	2
_inc_coverage_1_asm_h:                  ; @inc_coverage_1_asm_h
; %bb.0:                                ; %B10
	ldr	x8, [x23, #8]
	ldr	x1, [x8, #32]
	ldr	x8, [x1, #112]
	cbz	x8, LBB511_3
; %bb.1:                                ; %B7
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbnz	x8, LBB511_4
LBB511_2:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB511_3:                               ; %B11
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_EnsureCoverageCounters
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbz	x8, LBB511_2
LBB511_4:                               ; %B2
	ldr	w9, [x19]
	ldr	w10, [x10, #104]
	cmp	w9, w10
	b.hs	LBB511_2
; %bb.5:                                ; %B6
	ldr	w10, [x8, w9, sxtw #2]
	add	w10, w10, #1
	str	w10, [x8, w9, sxtw #2]
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_invalid_2_asm_h        ; -- Begin function invalid_2_asm_h
	.globl	_invalid_2_asm_h
	.p2align	2
_invalid_2_asm_h:                       ; @invalid_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x23, #8]
	mov	x0, x24
Lloh34:
	adrp	x1, l___unnamed_16@PAGE
Lloh35:
	add	x1, x1, l___unnamed_16@PAGEOFF
	ldr	x8, [x8, #32]
	ldr	x8, [x8, #8]
	str	x20, [x23, #48]
	mvn	x8, x8
	add	x8, x8, x19
	stp	x8, xzr, [sp, #-16]!
	bl	_LEPUS_ThrowInternalError
	add	sp, sp, #16
	b	_exception_asm_h
	.loh AdrpAdd	Lloh34, Lloh35
                                        ; -- End function
	.private_extern	_push_i32_2_asm_h       ; -- Begin function push_i32_2_asm_h
	.globl	_push_i32_2_asm_h
	.p2align	2
_push_i32_2_asm_h:                      ; @push_i32_2_asm_h
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
	.private_extern	_push_const_2_asm_h     ; -- Begin function push_const_2_asm_h
	.globl	_push_const_2_asm_h
	.p2align	2
_push_const_2_asm_h:                    ; @push_const_2_asm_h
; %bb.0:                                ; %B3
	sub	sp, sp, #16
	str	x22, [x20], #8
	ldr	x8, [x23, #112]
	ldrsw	x9, [x19]
	ldr	w10, [x24, #336]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, LBB514_2
; %bb.1:                                ; %B4
	mov	x8, x20
	mov	x0, x24
	mov	x2, x19
	str	x21, [x8], #8
	str	x8, [x23, #48]
	str	x1, [sp, #8]                    ; 8-byte Folded Spill
	bl	_DebuggerPause
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
LBB514_2:                               ; %B1
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
                                        ; -- End function
	.private_extern	_fclosure_2_asm_h       ; -- Begin function fclosure_2_asm_h
	.globl	_fclosure_2_asm_h
	.p2align	2
_fclosure_2_asm_h:                      ; @fclosure_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_fclosure_0_asm_h
                                        ; -- End function
	.private_extern	_push_atom_value_2_asm_h ; -- Begin function push_atom_value_2_asm_h
	.globl	_push_atom_value_2_asm_h
	.p2align	2
_push_atom_value_2_asm_h:               ; @push_atom_value_2_asm_h
; %bb.0:                                ; %B13
	str	x22, [x20], #8
	ldr	w1, [x19]
	tbnz	w1, #31, LBB516_5
; %bb.1:                                ; %B1
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, sxtw #3]
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, LBB516_4
; %bb.2:                                ; %B9
	ldr	w9, [x8, #8]
	asr	w9, w9, #30
	cmp	w9, #1
	b.ne	LBB516_5
LBB516_3:                               ; %B7
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	mov	x9, #2                          ; =0x2
	movk	x9, #1, lsl #48
	orr	x21, x8, x9
	br	x1
LBB516_4:                               ; %B2
	ldr	x9, [x8, #8]
	ldr	w9, [x9]
	asr	w9, w9, #30
	cmp	w9, #1
	b.eq	LBB516_3
LBB516_5:                               ; %B10
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB516_7
; %bb.6:                                ; %B12
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB516_7:                               ; %B11
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_private_symbol_2_asm_h ; -- Begin function private_symbol_2_asm_h
	.globl	_private_symbol_2_asm_h
	.p2align	2
_private_symbol_2_asm_h:                ; @private_symbol_2_asm_h
; %bb.0:                                ; %B1
	str	x22, [x20]
	mov	x0, x24
	mov	w2, #4                          ; =0x4
	ldr	w1, [x19]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #48]
	bl	_JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	LBB517_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB517_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_undefined_2_asm_h      ; -- Begin function undefined_2_asm_h
	.globl	_undefined_2_asm_h
	.p2align	2
_undefined_2_asm_h:                     ; @undefined_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #18                        ; =0x12
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_null_2_asm_h           ; -- Begin function null_2_asm_h
	.globl	_null_2_asm_h
	.p2align	2
_null_2_asm_h:                          ; @null_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #2                         ; =0x2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_this_2_asm_h      ; -- Begin function push_this_2_asm_h
	.globl	_push_this_2_asm_h
	.p2align	2
_push_this_2_asm_h:                     ; @push_this_2_asm_h
; %bb.0:                                ; %B12
	str	x22, [x20], #8
	ldr	w8, [x23, #44]
	ldr	x1, [x23, #88]
	tbnz	w8, #0, LBB520_2
; %bb.1:                                ; %B12
	ldr	x8, [x23, #88]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, LBB520_3
LBB520_2:                               ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
LBB520_3:                               ; %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	LBB520_5
; %bb.4:                                ; %B7
	ldrb	w8, [x19], #1
	ldr	x9, [x24, #208]
	mov	x22, x21
	add	w8, w8, #486
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB520_5:                               ; %B9
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB520_7
; %bb.6:                                ; %B11
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB520_7:                               ; %B10
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_push_false_2_asm_h     ; -- Begin function push_false_2_asm_h
	.globl	_push_false_2_asm_h
	.p2align	2
_push_false_2_asm_h:                    ; @push_false_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #6                         ; =0x6
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_true_2_asm_h      ; -- Begin function push_true_2_asm_h
	.globl	_push_true_2_asm_h
	.p2align	2
_push_true_2_asm_h:                     ; @push_true_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #7                         ; =0x7
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_object_2_asm_h         ; -- Begin function object_2_asm_h
	.globl	_object_2_asm_h
	.p2align	2
_object_2_asm_h:                        ; @object_2_asm_h
; %bb.0:                                ; %B16
	sub	sp, sp, #16
	str	x22, [x20], #8
	ldrb	w8, [x24, #371]
	str	x19, [sp, #8]                   ; 8-byte Folded Spill
	cbnz	w8, LBB523_5
; %bb.1:                                ; %B1
	ldr	x19, [x24, #408]
	cbz	x19, LBB523_5
; %bb.2:                                ; %B5
	mov	x8, x20
	mov	x0, x24
	mov	w1, #64                         ; =0x40
	mov	w2, #2                          ; =0x2
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	mov	x9, x0
	cbz	x9, LBB523_5
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
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB523_7
LBB523_4:                               ; %B9
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
LBB523_5:                               ; %B13
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	LBB523_8
; %bb.6:                                ; %B15
	ldr	x19, [sp, #8]                   ; 8-byte Folded Reload
	mov	x22, x21
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB523_7:                               ; %B11
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x19, x8
	mov	x19, x9
	bl	_prim_WriteBarrierNoStore
	mov	x9, x19
	b	LBB523_4
LBB523_8:                               ; %B14
	ldr	x19, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_special_object_2_asm_h ; -- Begin function special_object_2_asm_h
	.globl	_special_object_2_asm_h
	.p2align	2
_special_object_2_asm_h:                ; @special_object_2_asm_h
; %bb.0:                                ; %B12
	str	x22, [x20], #8
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	LBB524_5
; %bb.1:                                ; %B12
	cbz	w8, LBB524_8
; %bb.2:                                ; %B12
	cmp	w8, #1
	b.ne	LBB524_10
; %bb.3:                                ; %B2
	ldr	x8, [x23, #8]
	ldr	w1, [x23, #120]
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
	bl	_js_build_mapped_arguments_gc
	cmp	x0, #130
	b.eq	LBB524_13
LBB524_4:
	mov	x8, x0
	b	LBB524_11
LBB524_5:                               ; %B12
	cmp	w8, #3
	b.eq	LBB524_9
; %bb.6:                                ; %B12
	cmp	w8, #4
	b.ne	LBB524_12
; %bb.7:                                ; %B6
	ldr	x8, [x23, #8]
	mov	w9, #18                         ; =0x12
	ldr	x8, [x8, #48]
	cmp	x8, #0
	csel	x8, x9, x8, eq
	b	LBB524_11
LBB524_8:                               ; %B13
	str	x21, [x20], #8
	b	_FastBuildArguments_asm_h
LBB524_9:                               ; %B16
	ldr	x8, [x23, #96]
	b	LBB524_11
LBB524_10:                              ; %B15
	ldr	x8, [x23, #8]
LBB524_11:                              ; %B5
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB524_12:                              ; %B9
	mov	x8, x20
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.ne	LBB524_4
LBB524_13:                              ; %B10
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_rest_2_asm_h           ; -- Begin function rest_2_asm_h
	.globl	_rest_2_asm_h
	.p2align	2
_rest_2_asm_h:                          ; @rest_2_asm_h
; %bb.0:                                ; %B1
	str	x22, [x20]
	mov	x0, x24
	mov	x3, x28
	ldrh	w1, [x19]
	ldr	w2, [x23, #120]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #48]
	bl	_js_build_rest_gc
	cmp	x0, #130
	b.eq	LBB525_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB525_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_drop_2_asm_h           ; -- Begin function drop_2_asm_h
	.globl	_drop_2_asm_h
	.p2align	2
_drop_2_asm_h:                          ; @drop_2_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_nip_2_asm_h            ; -- Begin function nip_2_asm_h
	.globl	_nip_2_asm_h
	.p2align	2
_nip_2_asm_h:                           ; @nip_2_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x22, x21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_nip1_2_asm_h           ; -- Begin function nip1_2_asm_h
	.globl	_nip1_2_asm_h
	.p2align	2
_nip1_2_asm_h:                          ; @nip1_2_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_dup_2_asm_h            ; -- Begin function dup_2_asm_h
	.globl	_dup_2_asm_h
	.p2align	2
_dup_2_asm_h:                           ; @dup_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_dup1_2_asm_h           ; -- Begin function dup1_2_asm_h
	.globl	_dup1_2_asm_h
	.p2align	2
_dup1_2_asm_h:                          ; @dup1_2_asm_h
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
	.private_extern	_dup2_2_asm_h           ; -- Begin function dup2_2_asm_h
	.globl	_dup2_2_asm_h
	.p2align	2
_dup2_2_asm_h:                          ; @dup2_2_asm_h
; %bb.0:                                ; %B0
	stp	x22, x21, [x20], #16
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_dup3_2_asm_h           ; -- Begin function dup3_2_asm_h
	.globl	_dup3_2_asm_h
	.p2align	2
_dup3_2_asm_h:                          ; @dup3_2_asm_h
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
	.private_extern	_insert2_2_asm_h        ; -- Begin function insert2_2_asm_h
	.globl	_insert2_2_asm_h
	.p2align	2
_insert2_2_asm_h:                       ; @insert2_2_asm_h
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
	.private_extern	_insert3_2_asm_h        ; -- Begin function insert3_2_asm_h
	.globl	_insert3_2_asm_h
	.p2align	2
_insert3_2_asm_h:                       ; @insert3_2_asm_h
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
	.private_extern	_insert4_2_asm_h        ; -- Begin function insert4_2_asm_h
	.globl	_insert4_2_asm_h
	.p2align	2
_insert4_2_asm_h:                       ; @insert4_2_asm_h
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
	.private_extern	_perm3_2_asm_h          ; -- Begin function perm3_2_asm_h
	.globl	_perm3_2_asm_h
	.p2align	2
_perm3_2_asm_h:                         ; @perm3_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_perm4_2_asm_h          ; -- Begin function perm4_2_asm_h
	.globl	_perm4_2_asm_h
	.p2align	2
_perm4_2_asm_h:                         ; @perm4_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x22
	ldp	x9, x22, [x20, #-16]
	stp	x8, x9, [x20, #-16]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_perm5_2_asm_h          ; -- Begin function perm5_2_asm_h
	.globl	_perm5_2_asm_h
	.p2align	2
_perm5_2_asm_h:                         ; @perm5_2_asm_h
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
	.private_extern	_swap_2_asm_h           ; -- Begin function swap_2_asm_h
	.globl	_swap_2_asm_h
	.p2align	2
_swap_2_asm_h:                          ; @swap_2_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	mov	x2, x22
	mov	x22, x21
	mov	x21, x2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_swap2_2_asm_h          ; -- Begin function swap2_2_asm_h
	.globl	_swap2_2_asm_h
	.p2align	2
_swap2_2_asm_h:                         ; @swap2_2_asm_h
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
	.private_extern	_rot3l_2_asm_h          ; -- Begin function rot3l_2_asm_h
	.globl	_rot3l_2_asm_h
	.p2align	2
_rot3l_2_asm_h:                         ; @rot3l_2_asm_h
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
	.private_extern	_rot3r_2_asm_h          ; -- Begin function rot3r_2_asm_h
	.globl	_rot3r_2_asm_h
	.p2align	2
_rot3r_2_asm_h:                         ; @rot3r_2_asm_h
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
	.private_extern	_rot4l_2_asm_h          ; -- Begin function rot4l_2_asm_h
	.globl	_rot4l_2_asm_h
	.p2align	2
_rot4l_2_asm_h:                         ; @rot4l_2_asm_h
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
	.private_extern	_rot5l_2_asm_h          ; -- Begin function rot5l_2_asm_h
	.globl	_rot5l_2_asm_h
	.p2align	2
_rot5l_2_asm_h:                         ; @rot5l_2_asm_h
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
	.private_extern	_call_constructor_2_asm_h ; -- Begin function call_constructor_2_asm_h
	.globl	_call_constructor_2_asm_h
	.p2align	2
_call_constructor_2_asm_h:              ; @call_constructor_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_call_constructor_0_asm_h
                                        ; -- End function
	.private_extern	_call_2_asm_h           ; -- Begin function call_2_asm_h
	.globl	_call_2_asm_h
	.p2align	2
_call_2_asm_h:                          ; @call_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_call_0_asm_h
                                        ; -- End function
	.private_extern	_tail_call_2_asm_h      ; -- Begin function tail_call_2_asm_h
	.globl	_tail_call_2_asm_h
	.p2align	2
_tail_call_2_asm_h:                     ; @tail_call_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_tail_call_0_asm_h
                                        ; -- End function
	.private_extern	_call_method_2_asm_h    ; -- Begin function call_method_2_asm_h
	.globl	_call_method_2_asm_h
	.p2align	2
_call_method_2_asm_h:                   ; @call_method_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_call_method_0_asm_h
                                        ; -- End function
	.private_extern	_tail_call_method_2_asm_h ; -- Begin function tail_call_method_2_asm_h
	.globl	_tail_call_method_2_asm_h
	.p2align	2
_tail_call_method_2_asm_h:              ; @tail_call_method_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_tail_call_method_0_asm_h
                                        ; -- End function
	.private_extern	_array_from_2_asm_h     ; -- Begin function array_from_2_asm_h
	.globl	_array_from_2_asm_h
	.p2align	2
_array_from_2_asm_h:                    ; @array_from_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_array_from_0_asm_h
                                        ; -- End function
	.private_extern	_apply_2_asm_h          ; -- Begin function apply_2_asm_h
	.globl	_apply_2_asm_h
	.p2align	2
_apply_2_asm_h:                         ; @apply_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_apply_0_asm_h
                                        ; -- End function
	.private_extern	_return_2_asm_h         ; -- Begin function return_2_asm_h
	.globl	_return_2_asm_h
	.p2align	2
_return_2_asm_h:                        ; @return_2_asm_h
; %bb.0:                                ; %B0
	mov	x0, x21
	b	_common_return_asm_h
                                        ; -- End function
	.private_extern	_return_undef_2_asm_h   ; -- Begin function return_undef_2_asm_h
	.globl	_return_undef_2_asm_h
	.p2align	2
_return_undef_2_asm_h:                  ; @return_undef_2_asm_h
; %bb.0:                                ; %B0
	mov	w0, #18                         ; =0x12
	b	_common_return_asm_h
                                        ; -- End function
	.private_extern	_check_ctor_return_2_asm_h ; -- Begin function check_ctor_return_2_asm_h
	.globl	_check_ctor_return_2_asm_h
	.p2align	2
_check_ctor_return_2_asm_h:             ; @check_ctor_return_2_asm_h
; %bb.0:                                ; %B5
	mov	x8, #2                          ; =0x2
	str	x22, [x20], #8
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	LBB554_3
; %bb.1:                                ; %B2
	cmp	x21, #18
	b.eq	LBB554_4
; %bb.2:                                ; %B3
	mov	x8, x20
Lloh36:
	adrp	x1, l___unnamed_17@PAGE
Lloh37:
	add	x1, x1, l___unnamed_17@PAGEOFF
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_LEPUS_ThrowTypeError
	b	_exception_spill_top1_asm_h
LBB554_3:                               ; %B6
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	w21, #6                         ; =0x6
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB554_4:                               ; %B4
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	w21, #7                         ; =0x7
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh36, Lloh37
                                        ; -- End function
	.private_extern	_check_ctor_2_asm_h     ; -- Begin function check_ctor_2_asm_h
	.globl	_check_ctor_2_asm_h
	.p2align	2
_check_ctor_2_asm_h:                    ; @check_ctor_2_asm_h
; %bb.0:                                ; %B2
	ldr	x8, [x23, #96]
	cmp	x8, #18
	b.ne	LBB555_2
; %bb.1:                                ; %B3
	add	x8, x20, #16
Lloh38:
	adrp	x1, l___unnamed_18@PAGE
Lloh39:
	add	x1, x1, l___unnamed_18@PAGEOFF
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_LEPUS_ThrowTypeError
	b	_exception_spill_top0_top1_asm_h
LBB555_2:                               ; %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh38, Lloh39
                                        ; -- End function
	.private_extern	_check_brand_2_asm_h    ; -- Begin function check_brand_2_asm_h
	.globl	_check_brand_2_asm_h
	.p2align	2
_check_brand_2_asm_h:                   ; @check_brand_2_asm_h
; %bb.0:                                ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_CheckBrand_GC
	tbnz	w0, #31, LBB556_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB556_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_add_brand_2_asm_h      ; -- Begin function add_brand_2_asm_h
	.globl	_add_brand_2_asm_h
	.p2align	2
_add_brand_2_asm_h:                     ; @add_brand_2_asm_h
; %bb.0:                                ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_AddBrand_GC
	tbnz	w0, #31, LBB557_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB557_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_return_async_2_asm_h   ; -- Begin function return_async_2_asm_h
	.globl	_return_async_2_asm_h
	.p2align	2
_return_async_2_asm_h:                  ; @return_async_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_return_async_0_asm_h
                                        ; -- End function
	.private_extern	_throw_2_asm_h          ; -- Begin function throw_2_asm_h
	.globl	_throw_2_asm_h
	.p2align	2
_throw_2_asm_h:                         ; @throw_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_throw_0_asm_h
                                        ; -- End function
	.private_extern	_throw_var_2_asm_h      ; -- Begin function throw_var_2_asm_h
	.globl	_throw_var_2_asm_h
	.p2align	2
_throw_var_2_asm_h:                     ; @throw_var_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_throw_var_0_asm_h
                                        ; -- End function
	.private_extern	_eval_2_asm_h           ; -- Begin function eval_2_asm_h
	.globl	_eval_2_asm_h
	.p2align	2
_eval_2_asm_h:                          ; @eval_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_eval_0_asm_h
                                        ; -- End function
	.private_extern	_regexp_2_asm_h         ; -- Begin function regexp_2_asm_h
	.globl	_regexp_2_asm_h
	.p2align	2
_regexp_2_asm_h:                        ; @regexp_2_asm_h
; %bb.0:                                ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	w1, #18                         ; =0x12
	mov	x2, x22
	mov	x3, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	LBB562_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB562_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_get_super_ctor_2_asm_h ; -- Begin function get_super_ctor_2_asm_h
	.globl	_get_super_ctor_2_asm_h
	.p2align	2
_get_super_ctor_2_asm_h:                ; @get_super_ctor_2_asm_h
; %bb.0:                                ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	LBB563_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB563_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_get_super_2_asm_h      ; -- Begin function get_super_2_asm_h
	.globl	_get_super_2_asm_h
	.p2align	2
_get_super_2_asm_h:                     ; @get_super_2_asm_h
; %bb.0:                                ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_GetPrototype_GC
	cmp	x0, #130
	b.eq	LBB564_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB564_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_import_2_asm_h         ; -- Begin function import_2_asm_h
	.globl	_import_2_asm_h
	.p2align	2
_import_2_asm_h:                        ; @import_2_asm_h
; %bb.0:                                ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_js_dynamic_import
	cmp	x0, #130
	b.eq	LBB565_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB565_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_check_var_2_asm_h      ; -- Begin function check_var_2_asm_h
	.globl	_check_var_2_asm_h
	.p2align	2
_check_var_2_asm_h:                     ; @check_var_2_asm_h
; %bb.0:                                ; %B1
	str	x22, [x20]
	mov	x0, x24
	ldr	w1, [x19]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #48]
	bl	_JS_CheckGlobalVar_GC
	tbnz	w0, #31, LBB566_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	mov	x22, x21
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x21, x8, ne
	br	x1
LBB566_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_get_var_undef_2_asm_h  ; -- Begin function get_var_undef_2_asm_h
	.globl	_get_var_undef_2_asm_h
	.p2align	2
_get_var_undef_2_asm_h:                 ; @get_var_undef_2_asm_h
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
	cbz	w11, LBB567_3
LBB567_1:                               ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB567_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB567_1 Depth=1
	ldr	w11, [x12]
	and	w11, w11, #0x3ffffff
	cbnz	w11, LBB567_1
LBB567_3:                               ; %B11
	ldr	x8, [x24, #208]
	mov	w10, #18                        ; =0x12
LBB567_4:                               ; %B33
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB567_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w9, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB567_7
LBB567_5:                               ; %B22
                                        ;   Parent Loop BB567_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w9
	b.eq	LBB567_9
; %bb.6:                                ; %B24
                                        ;   in Loop: Header=BB567_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB567_5
LBB567_7:                               ; %B27
                                        ;   in Loop: Header=BB567_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	LBB567_13
; %bb.8:                                ; %B30
                                        ;   in Loop: Header=BB567_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB567_4
	b	LBB567_11
LBB567_9:                               ; %B12
	lsr	w9, w13, #26
	tst	w9, #0x30
	b.ne	LBB567_13
LBB567_10:                              ; %B7.sink.split
	ldr	x8, [x8, #16]
	sub	w9, w11, #1
	ldr	x10, [x8, w9, sxtw #3]
LBB567_11:                              ; %B7
	cmp	x10, #34
	b.eq	LBB567_15
; %bb.12:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x10
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB567_13:                              ; %B17
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB567_16
; %bb.14:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB567_15:                              ; %B3
	str	x21, [x20], #8
	b	_ThrowReferenceErrorUninitialized_asm_h
LBB567_16:                              ; %B18
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_get_var_2_asm_h        ; -- Begin function get_var_2_asm_h
	.globl	_get_var_2_asm_h
	.p2align	2
_get_var_2_asm_h:                       ; @get_var_2_asm_h
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
	cbz	w10, LBB568_3
LBB568_1:                               ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB568_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB568_1 Depth=1
	ldr	w10, [x12]
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB568_1
LBB568_3:                               ; %B11
	ldr	x8, [x24, #208]
LBB568_4:                               ; %B32
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB568_5 Depth 2
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w9, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB568_7
LBB568_5:                               ; %B21
                                        ;   Parent Loop BB568_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	LBB568_9
; %bb.6:                                ; %B23
                                        ;   in Loop: Header=BB568_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB568_5
LBB568_7:                               ; %B26
                                        ;   in Loop: Header=BB568_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB568_12
; %bb.8:                                ; %B29
                                        ;   in Loop: Header=BB568_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB568_4
	b	LBB568_12
LBB568_9:                               ; %B12
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	LBB568_12
LBB568_10:                              ; %B7
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	LBB568_14
; %bb.11:                               ; %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB568_12:                              ; %B16
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB568_15
; %bb.13:                               ; %B18
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB568_14:                              ; %B3
	str	x21, [x20], #8
	b	_ThrowReferenceErrorUninitialized_asm_h
LBB568_15:                              ; %B17
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_put_var_2_asm_h        ; -- Begin function put_var_2_asm_h
	.globl	_put_var_2_asm_h
	.p2align	2
_put_var_2_asm_h:                       ; @put_var_2_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB569_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB569_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_put_var_init_2_asm_h   ; -- Begin function put_var_init_2_asm_h
	.globl	_put_var_init_2_asm_h
	.p2align	2
_put_var_init_2_asm_h:                  ; @put_var_init_2_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB570_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB570_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_put_var_strict_2_asm_h ; -- Begin function put_var_strict_2_asm_h
	.globl	_put_var_strict_2_asm_h
	.p2align	2
_put_var_strict_2_asm_h:                ; @put_var_strict_2_asm_h
; %bb.0:                                ; %B5
	cmp	x22, #7
	b.ne	LBB571_3
; %bb.1:                                ; %B1
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          ; =0x2
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB571_4
; %bb.2:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB571_3:                               ; %B6
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB571_4:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_get_ref_value_2_asm_h  ; -- Begin function get_ref_value_2_asm_h
	.globl	_get_ref_value_2_asm_h
	.p2align	2
_get_ref_value_2_asm_h:                 ; @get_ref_value_2_asm_h
; %bb.0:                                ; %B8
	cmp	x22, #18
	str	x22, [x20]
	mov	x0, x24
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #48]
	b.eq	LBB572_3
; %bb.1:                                ; %B1
	mov	x1, x22
	mov	x2, x21
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB572_5
; %bb.2:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB572_3:                               ; %B5
	mov	x1, x21
	bl	_js_value_to_atom_gc
	cbz	w0, LBB572_5
; %bb.4:                                ; %B7
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB572_5:                               ; %B6
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_put_ref_value_2_asm_h  ; -- Begin function put_ref_value_2_asm_h
	.globl	_put_ref_value_2_asm_h
	.p2align	2
_put_ref_value_2_asm_h:                 ; @put_ref_value_2_asm_h
; %bb.0:                                ; %B12
	sub	sp, sp, #16
	ldur	x1, [x20, #-8]
	cmp	x1, #18
	b.eq	LBB573_3
LBB573_1:                               ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_SetPropertyValue_GC
	tbnz	w0, #31, LBB573_7
; %bb.2:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB573_3:                               ; %B8
	ldr	w8, [x23, #44]
	tbnz	w8, #0, LBB573_5
; %bb.4:                                ; %B9
	ldr	x1, [x24, #208]
	b	LBB573_1
LBB573_5:                               ; %B5
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	stp	x22, x21, [x20]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	str	x8, [x23, #48]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB573_7
; %bb.6:                                ; %B7
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	w1, w0
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB573_7:                               ; %B2
	add	sp, sp, #16
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_define_var_2_asm_h     ; -- Begin function define_var_2_asm_h
	.globl	_define_var_2_asm_h
	.p2align	2
_define_var_2_asm_h:                    ; @define_var_2_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_DefineGlobalVar_GC
	tbnz	w0, #31, LBB574_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB574_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_check_define_var_2_asm_h ; -- Begin function check_define_var_2_asm_h
	.globl	_check_define_var_2_asm_h
	.p2align	2
_check_define_var_2_asm_h:              ; @check_define_var_2_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, LBB575_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB575_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_define_func_2_asm_h    ; -- Begin function define_func_2_asm_h
	.globl	_define_func_2_asm_h
	.p2align	2
_define_func_2_asm_h:                   ; @define_func_2_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	ldrb	w3, [x19, #4]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_DefineGlobalFunction_GC
	tbnz	w0, #31, LBB576_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB576_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_get_field_2_asm_h      ; -- Begin function get_field_2_asm_h
	.globl	_get_field_2_asm_h
	.p2align	2
_get_field_2_asm_h:                     ; @get_field_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #2                          ; =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	LBB577_10
; %bb.1:                                ; %B25
	mov	x9, x21
	mov	w8, #18                         ; =0x12
LBB577_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB577_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB577_5
LBB577_3:                               ; %B1
                                        ;   Parent Loop BB577_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB577_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB577_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB577_3
LBB577_5:                               ; %B14
                                        ;   in Loop: Header=BB577_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB577_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB577_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB577_2
	b	LBB577_9
LBB577_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB577_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB577_9:                               ; %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB577_10:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x3, x21
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB577_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB577_12:                              ; %B22
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_get_field2_2_asm_h     ; -- Begin function get_field2_2_asm_h
	.globl	_get_field2_2_asm_h
	.p2align	2
_get_field2_2_asm_h:                    ; @get_field2_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #2                          ; =0x2
	str	x22, [x20], #8
	movk	x8, #65535, lsl #48
	ldr	w2, [x19]
	tst	x21, x8
	b.ne	LBB578_10
; %bb.1:                                ; %B25
	mov	x9, x21
	mov	w8, #18                         ; =0x12
LBB578_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB578_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB578_5
LBB578_3:                               ; %B1
                                        ;   Parent Loop BB578_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB578_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB578_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB578_3
LBB578_5:                               ; %B14
                                        ;   in Loop: Header=BB578_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB578_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB578_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB578_2
	b	LBB578_9
LBB578_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB578_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB578_9:                               ; %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB578_10:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	mov	x3, x21
	mov	w4, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB578_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB578_12:                              ; %B22
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_put_field_2_asm_h      ; -- Begin function put_field_2_asm_h
	.globl	_put_field_2_asm_h
	.p2align	2
_put_field_2_asm_h:                     ; @put_field_2_asm_h
; %bb.0:                                ; %B80
	sub	sp, sp, #32
	mov	x8, #2                          ; =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB579_25
; %bb.1:                                ; %B81
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB579_4
LBB579_2:                               ; %B1
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB579_10
; %bb.3:                                ; %B12
                                        ;   in Loop: Header=BB579_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB579_2
LBB579_4:                               ; %B17.preheader
	mov	x8, x22
LBB579_5:                               ; %B17
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB579_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w2, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB579_8
LBB579_6:                               ; %B18
                                        ;   Parent Loop BB579_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB579_13
; %bb.7:                                ; %B59
                                        ;   in Loop: Header=BB579_6 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB579_6
LBB579_8:                               ; %B66
                                        ;   in Loop: Header=BB579_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB579_25
; %bb.9:                                ; %B63
                                        ;   in Loop: Header=BB579_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB579_5
	b	LBB579_14
LBB579_10:                              ; %B3
	mov	w9, #58                         ; =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	LBB579_25
; %bb.11:                               ; %B7
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB579_26
LBB579_12:                              ; %B79
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
LBB579_13:                              ; %B20
	mov	w8, #58                         ; =0x3a
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	LBB579_25
LBB579_14:                              ; %B23
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	LBB579_25
; %bb.15:                               ; %B25
	ldrh	w8, [x22, #6]
	str	x20, [sp, #24]                  ; 8-byte Folded Spill
	cmp	w8, #1
	b.ne	LBB579_32
; %bb.16:                               ; %B25
	tbnz	w2, #31, LBB579_32
; %bb.17:                               ; %B54
	ldr	x12, [x22, #8]
	ldr	x20, [x12, #40]
	cbz	x20, LBB579_27
; %bb.18:                               ; %B32
	ldr	x8, [x22, #16]
	ldr	w9, [x20, #16]
	add	x10, x22, #32
	ldr	w11, [x12, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	LBB579_20
; %bb.19:                               ; %B32
	cbz	w8, LBB579_32
LBB579_20:                              ; %B42
	ldr	w8, [x12, #48]
	cmp	w8, w2
	b.ne	LBB579_27
; %bb.21:                               ; %B42
	ldrb	w8, [x12, #52]
	cmp	w8, #7
	b.ne	LBB579_27
LBB579_22:                              ; %B34
	ldr	w8, [x20]
	add	x9, x22, #8
	add	w8, w8, #1
	str	w8, [x20]
	ldr	w8, [x12]
	sub	w8, w8, #1
	str	w8, [x12]
	stlr	x20, [x9]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB579_30
LBB579_23:                              ; %B38
	ldr	w8, [x20, #20]
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB579_34
LBB579_24:                              ; %B37
	ldrb	w8, [x19, #4]
	ldr	x20, [sp, #24]                  ; 8-byte Folded Reload
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
LBB579_25:                              ; %B77
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_SetPropertyInternalImpl_GC
	tbz	w0, #31, LBB579_12
	b	LBB579_36
LBB579_26:                              ; %B9
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
LBB579_27:                              ; %B47
	ldr	x0, [x24, #8]
	mov	x1, x12
	str	w2, [sp, #4]                    ; 4-byte Folded Spill
	mov	w3, #7                          ; =0x7
	stp	x19, x12, [sp, #8]              ; 16-byte Folded Spill
	bl	_find_hashed_shape_prop_gc
	ldp	x19, x11, [sp, #8]              ; 16-byte Folded Reload
	ldr	w2, [sp, #4]                    ; 4-byte Folded Reload
	cbz	x0, LBB579_32
; %bb.28:                               ; %B50
	ldr	x8, [x22, #16]
	ldr	w9, [x0, #16]
	add	x10, x22, #32
	ldr	w11, [x11, #16]
	mov	x20, x0
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	LBB579_31
; %bb.29:
	ldp	x19, x12, [sp, #8]              ; 16-byte Folded Reload
	b	LBB579_22
LBB579_30:                              ; %B41
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x20, x8
	bl	_prim_WriteBarrierNoStore
	b	LBB579_23
LBB579_31:                              ; %B50
	ldp	x19, x12, [sp, #8]              ; 16-byte Folded Reload
	ldr	w2, [sp, #4]                    ; 4-byte Folded Reload
	cbnz	w8, LBB579_22
LBB579_32:                              ; %B70
	ldr	x9, [sp, #24]                   ; 8-byte Folded Reload
	mov	x0, x24
	mov	x1, x22
	mov	w3, #7                          ; =0x7
	add	x8, x9, #16
	stp	x22, x21, [x9]
	str	x8, [x23, #48]
	bl	_add_property_gc
	cbz	x0, LBB579_35
; %bb.33:                               ; %B74
	str	x21, [x0]
	ldrb	w8, [x24, #392]
	cbz	w8, LBB579_24
LBB579_34:                              ; %B40
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	ldr	x20, [sp, #24]                  ; 8-byte Folded Reload
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #32
	br	x1
LBB579_35:                              ; %B71
	ldr	x20, [sp, #24]                  ; 8-byte Folded Reload
LBB579_36:                              ; %B78
	add	sp, sp, #32
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_get_private_field_2_asm_h ; -- Begin function get_private_field_2_asm_h
	.globl	_get_private_field_2_asm_h
	.p2align	2
_get_private_field_2_asm_h:             ; @get_private_field_2_asm_h
; %bb.0:                                ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	LBB580_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB580_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_put_private_field_2_asm_h ; -- Begin function put_private_field_2_asm_h
	.globl	_put_private_field_2_asm_h
	.p2align	2
_put_private_field_2_asm_h:             ; @put_private_field_2_asm_h
; %bb.0:                                ; %B1
	ldur	x1, [x20, #-8]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	x3, x22
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_SetPrivateField_GC
	tbnz	w0, #31, LBB581_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB581_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_define_private_field_2_asm_h ; -- Begin function define_private_field_2_asm_h
	.globl	_define_private_field_2_asm_h
	.p2align	2
_define_private_field_2_asm_h:          ; @define_private_field_2_asm_h
; %bb.0:                                ; %B1
	ldur	x1, [x20, #-8]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_DefinePrivateField_GC
	tbnz	w0, #31, LBB582_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB582_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_get_array_el_2_asm_h   ; -- Begin function get_array_el_2_asm_h
	.globl	_get_array_el_2_asm_h
	.p2align	2
_get_array_el_2_asm_h:                  ; @get_array_el_2_asm_h
; %bb.0:                                ; %B72
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB583_7
; %bb.1:                                ; %B72
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x8, x9
	b.ne	LBB583_7
; %bb.2:                                ; %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	LBB583_5
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB583_9
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	add	w8, w8, #243
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB583_5:                               ; %B30
	sxth	w9, w8
	cmp	w9, #21
	b.lt	LBB583_7
; %bb.6:                                ; %B30
	cmp	w9, #29
	b.le	LBB583_19
LBB583_7:                               ; %B69
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB583_24
; %bb.8:                                ; %B71
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB583_9:                               ; %B7
	tbnz	w21, #31, LBB583_7
; %bb.10:                               ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB583_11:                              ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB583_12 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB583_14
LBB583_12:                              ; %B10
                                        ;   Parent Loop BB583_11 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB583_16
; %bb.13:                               ; %B17
                                        ;   in Loop: Header=BB583_12 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB583_12
LBB583_14:                              ; %B24
                                        ;   in Loop: Header=BB583_11 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB583_7
; %bb.15:                               ; %B21
                                        ;   in Loop: Header=BB583_11 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB583_11
	b	LBB583_18
LBB583_16:                              ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB583_7
; %bb.17:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB583_18:                              ; %B36
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB583_19:                              ; %B32
	ldr	w9, [x22, #48]
	cmp	w21, w9
	b.hs	LBB583_7
; %bb.20:                               ; %B34
	ldr	x9, [x22, #40]
	cmp	w8, #23
	b.ge	LBB583_25
; %bb.21:                               ; %B34
	cmp	w8, #21
	b.eq	LBB583_26
; %bb.22:                               ; %B34
	cmp	w8, #22
	b.ne	LBB583_7
; %bb.23:                               ; %B35
	ldrsb	w8, [x9, w21, sxtw]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB583_24:                              ; %B70
	b	_exception_spill_top0_top1_asm_h
LBB583_25:                              ; %B34
	b.gt	LBB583_27
LBB583_26:                              ; %B39
	ldrb	w8, [x9, w21, sxtw]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB583_27:                              ; %B34
	cmp	w8, #25
	b.gt	LBB583_31
; %bb.28:                               ; %B34
	cmp	w8, #24
	b.eq	LBB583_35
; %bb.29:                               ; %B34
	cmp	w8, #25
	b.ne	LBB583_7
; %bb.30:                               ; %B45
	ldrh	w8, [x9, w21, sxtw #1]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB583_31:                              ; %B34
	cmp	w8, #26
	b.eq	LBB583_36
; %bb.32:                               ; %B34
	cmp	w8, #27
	b.eq	LBB583_37
; %bb.33:                               ; %B34
	cmp	w8, #29
	b.ne	LBB583_7
; %bb.34:                               ; %B62
	ldr	d0, [x9, w21, sxtw #3]
	b	LBB583_40
LBB583_35:                              ; %B42
	ldrsh	w8, [x9, w21, sxtw #1]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB583_36:                              ; %B48
	ldr	w8, [x9, w21, sxtw #2]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB583_37:                              ; %B56
	ldr	w8, [x9, w21, sxtw #2]
	tbnz	w8, #31, LBB583_39
; %bb.38:                               ; %B36
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB583_39:                              ; %B52
	ucvtf	d0, w8
LBB583_40:                              ; %B36
	fmov	x8, d0
	fcmp	d0, d0
	mov	x9, #562949953421312            ; =0x2000000000000
	add	x8, x8, x9
	mov	x9, #9221683186994511872        ; =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_array_el2_2_asm_h  ; -- Begin function get_array_el2_2_asm_h
	.globl	_get_array_el2_2_asm_h
	.p2align	2
_get_array_el2_2_asm_h:                 ; @get_array_el2_2_asm_h
; %bb.0:                                ; %B72
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB584_7
; %bb.1:                                ; %B72
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x8, x9
	b.ne	LBB584_7
; %bb.2:                                ; %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	LBB584_5
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB584_9
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	add	w8, w8, #486
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB584_5:                               ; %B30
	sxth	w9, w8
	cmp	w9, #21
	b.lt	LBB584_7
; %bb.6:                                ; %B30
	cmp	w9, #29
	b.le	LBB584_19
LBB584_7:                               ; %B69
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB584_24
; %bb.8:                                ; %B71
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB584_9:                               ; %B7
	tbnz	w21, #31, LBB584_7
; %bb.10:                               ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB584_11:                              ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB584_12 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB584_14
LBB584_12:                              ; %B10
                                        ;   Parent Loop BB584_11 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB584_16
; %bb.13:                               ; %B17
                                        ;   in Loop: Header=BB584_12 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB584_12
LBB584_14:                              ; %B24
                                        ;   in Loop: Header=BB584_11 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB584_7
; %bb.15:                               ; %B21
                                        ;   in Loop: Header=BB584_11 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB584_11
	b	LBB584_18
LBB584_16:                              ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB584_7
; %bb.17:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB584_18:                              ; %B36
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB584_19:                              ; %B32
	ldr	w9, [x22, #48]
	cmp	w21, w9
	b.hs	LBB584_7
; %bb.20:                               ; %B34
	ldr	x9, [x22, #40]
	cmp	w8, #23
	b.ge	LBB584_25
; %bb.21:                               ; %B34
	cmp	w8, #21
	b.eq	LBB584_26
; %bb.22:                               ; %B34
	cmp	w8, #22
	b.ne	LBB584_7
; %bb.23:                               ; %B35
	ldrsb	w8, [x9, w21, sxtw]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB584_24:                              ; %B70
	b	_exception_spill_top0_top1_asm_h
LBB584_25:                              ; %B34
	b.gt	LBB584_27
LBB584_26:                              ; %B39
	ldrb	w8, [x9, w21, sxtw]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB584_27:                              ; %B34
	cmp	w8, #25
	b.gt	LBB584_31
; %bb.28:                               ; %B34
	cmp	w8, #24
	b.eq	LBB584_35
; %bb.29:                               ; %B34
	cmp	w8, #25
	b.ne	LBB584_7
; %bb.30:                               ; %B45
	ldrh	w8, [x9, w21, sxtw #1]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB584_31:                              ; %B34
	cmp	w8, #26
	b.eq	LBB584_36
; %bb.32:                               ; %B34
	cmp	w8, #27
	b.eq	LBB584_37
; %bb.33:                               ; %B34
	cmp	w8, #29
	b.ne	LBB584_7
; %bb.34:                               ; %B62
	ldr	d0, [x9, w21, sxtw #3]
	b	LBB584_40
LBB584_35:                              ; %B42
	ldrsh	w8, [x9, w21, sxtw #1]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB584_36:                              ; %B48
	ldr	w8, [x9, w21, sxtw #2]
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB584_37:                              ; %B56
	ldr	w8, [x9, w21, sxtw #2]
	tbnz	w8, #31, LBB584_39
; %bb.38:                               ; %B36
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB584_39:                              ; %B52
	ucvtf	d0, w8
LBB584_40:                              ; %B36
	fmov	x8, d0
	fcmp	d0, d0
	mov	x9, #562949953421312            ; =0x2000000000000
	add	x8, x8, x9
	mov	x9, #9221683186994511872        ; =0x7ffa000000000000
	csel	x8, x8, x9, vc
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_array_el_2_asm_h   ; -- Begin function put_array_el_2_asm_h
	.globl	_put_array_el_2_asm_h
	.p2align	2
_put_array_el_2_asm_h:                  ; @put_array_el_2_asm_h
; %bb.0:                                ; %B100
	ldur	x1, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x1, x8
	b.ne	LBB585_40
; %bb.1:                                ; %B94
	ldrh	w9, [x1, #6]
	cmp	w9, #2
	b.ne	LBB585_6
; %bb.2:                                ; %B1
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB585_40
; %bb.3:                                ; %B46
	ldr	w8, [x1, #48]
	cmp	w22, w8
	b.hs	LBB585_13
; %bb.4:                                ; %B3
	ldr	x8, [x1, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB585_22
LBB585_5:                               ; %B58
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB585_6:                               ; %B97
	sxth	w8, w9
	mov	w4, #32768                      ; =0x8000
	cmp	w8, #21
	b.lt	LBB585_41
; %bb.7:                                ; %B97
	cmp	w8, #29
	b.gt	LBB585_41
; %bb.8:                                ; %B50
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB585_36
; %bb.9:                                ; %B52
	ldr	w8, [x1, #48]
	cmp	w22, w8
	b.hs	LBB585_36
; %bb.10:                               ; %B54
	sub	w10, w9, #22
	ldr	x8, [x1, #40]
	cmp	w10, #2
	b.hs	LBB585_23
; %bb.11:                               ; %B64
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	LBB585_36
; %bb.12:                               ; %B65
	strb	w21, [x8, w22, sxtw]
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB585_13:                              ; %B8
	b.ne	LBB585_37
; %bb.14:                               ; %B36
	ldr	w9, [x1, #4]
	mov	w4, #32768                      ; =0x8000
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	b.ne	LBB585_41
; %bb.15:                               ; %B36
	ubfx	w9, w9, #8, #1
	cbz	w9, LBB585_41
; %bb.16:                               ; %B10
	ldr	x9, [x1, #8]
	ldr	x9, [x9, #32]
	cbz	x9, LBB585_18
; %bb.17:                               ; %B32
	ldr	w9, [x9, #4]
	ubfx	w9, w9, #13, #1
	cmp	w9, #1
	b.ne	LBB585_41
LBB585_18:                              ; %B28
	ldr	x9, [x1, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	LBB585_20
; %bb.19:                               ; %B28
	cmp	w9, w10
	b.hi	LBB585_43
LBB585_20:                              ; %B25
	ldr	w10, [x1, #32]
	cmp	w9, w10
	b.hi	LBB585_43
; %bb.21:                               ; %B21
	ldr	x10, [x1, #40]
	str	w9, [x1, #48]
	str	x21, [x10, w8, sxtw #3]
	ldrb	w8, [x24, #392]
	cbz	w8, LBB585_5
LBB585_22:                              ; %B24
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB585_23:                              ; %B54
	cmp	w9, #25
	mov	w4, wzr
	b.gt	LBB585_27
; %bb.24:                               ; %B54
	sub	w10, w9, #24
	cmp	w10, #2
	b.hs	LBB585_30
; %bb.25:                               ; %B70
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	LBB585_36
; %bb.26:                               ; %B71
	strh	w21, [x8, w22, sxtw #1]
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB585_27:                              ; %B54
	sub	w10, w9, #26
	cmp	w10, #2
	b.hs	LBB585_33
; %bb.28:                               ; %B76
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	LBB585_36
; %bb.29:                               ; %B77
	str	w21, [x8, w22, sxtw #2]
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB585_30:                              ; %B54
	cmp	w9, #21
	b.ne	LBB585_41
; %bb.31:                               ; %B56
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	LBB585_36
; %bb.32:                               ; %B57
	cmp	w21, #255
	mov	w9, #255                        ; =0xff
	csel	w9, w21, w9, lt
	bic	w9, w9, w9, asr #31
	strb	w9, [x8, w22, sxtw]
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB585_33:                              ; %B54
	cmp	w9, #29
	b.ne	LBB585_41
; %bb.34:                               ; %B82
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x21, lsr #48
	b.ne	LBB585_45
; %bb.35:                               ; %B83
	scvtf	d0, w21
	str	d0, [x8, w22, sxtw #3]
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB585_36:
	mov	w4, wzr
	b	LBB585_41
LBB585_37:                              ; %B40
	tbnz	w22, #31, LBB585_40
; %bb.38:                               ; %B42
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, w22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_SetArrayIntPropertyValue_GC
	tbz	w0, #31, LBB585_5
; %bb.39:                               ; %B43
	b	_exception_spill_top0_top1_asm_h
LBB585_40:
	mov	w4, #32768                      ; =0x8000
LBB585_41:                              ; %B91
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_SetPropertyValue_GC
	tbz	w0, #31, LBB585_5
; %bb.42:                               ; %B92
	b	_exception_spill_top0_top1_asm_h
LBB585_43:                              ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, #32768                      ; =0x8000
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_add_fast_array_element_gc
	tbz	w0, #31, LBB585_5
; %bb.44:                               ; %B17
	b	_exception_spill_top0_top1_asm_h
LBB585_45:                              ; %B85
	and	x9, x21, #0xfffe000000000000
	mov	x10, #-562949953421312          ; =0xfffe000000000000
	mov	w4, wzr
	cmp	x9, x10
	b.eq	LBB585_41
; %bb.46:                               ; %B85
	cbz	x9, LBB585_41
; %bb.47:                               ; %B86
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	add	x9, x21, x9
	str	x9, [x8, w22, sxtw #3]
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_super_value_2_asm_h ; -- Begin function get_super_value_2_asm_h
	.globl	_get_super_value_2_asm_h
	.p2align	2
_get_super_value_2_asm_h:               ; @get_super_value_2_asm_h
; %bb.0:                                ; %B1
	sub	sp, sp, #16
	str	x19, [sp, #8]                   ; 8-byte Folded Spill
	add	x19, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x19, [x23, #48]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB586_3
; %bb.1:                                ; %B5
	ldur	x3, [x20, #-8]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x19, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB586_3
; %bb.2:                                ; %B7
	ldr	x19, [sp, #8]                   ; 8-byte Folded Reload
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB586_3:                               ; %B2
	ldr	x19, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_put_super_value_2_asm_h ; -- Begin function put_super_value_2_asm_h
	.globl	_put_super_value_2_asm_h
	.p2align	2
_put_super_value_2_asm_h:               ; @put_super_value_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_put_super_value_0_asm_h
                                        ; -- End function
	.private_extern	_define_field_2_asm_h   ; -- Begin function define_field_2_asm_h
	.globl	_define_field_2_asm_h
	.p2align	2
_define_field_2_asm_h:                  ; @define_field_2_asm_h
; %bb.0:                                ; %B58
	sub	sp, sp, #32
	mov	x8, #2                          ; =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB588_4
; %bb.1:                                ; %B55
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	LBB588_4
; %bb.2:                                ; %B49
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB588_4
; %bb.3:                                ; %B52
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.eq	LBB588_6
LBB588_4:                               ; %B46
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #16391                      ; =0x4007
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_DefinePropertyValue_GC
	tbnz	w0, #31, LBB588_17
LBB588_5:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #32
	br	x1
LBB588_6:                               ; %B53
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB588_9
LBB588_7:                               ; %B35
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB588_18
; %bb.8:                                ; %B37
                                        ;   in Loop: Header=BB588_7 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB588_7
LBB588_9:                               ; %B40
	tbnz	w2, #31, LBB588_4
; %bb.10:                               ; %B11
	ldr	x8, [x22, #8]
	str	x8, [sp, #24]                   ; 8-byte Folded Spill
	ldr	x8, [x8, #40]
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	cbz	x8, LBB588_21
; %bb.11:                               ; %B15
	ldp	x9, x11, [sp, #16]              ; 16-byte Folded Reload
	add	x10, x22, #32
	ldr	x8, [x22, #16]
	ldr	w9, [x9, #16]
	ldr	w11, [x11, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	LBB588_13
; %bb.12:                               ; %B15
	cbz	w8, LBB588_4
LBB588_13:                              ; %B17
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	ldr	w8, [x8, #48]
	cmp	w8, w2
	b.ne	LBB588_21
; %bb.14:                               ; %B17
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	ldrb	w8, [x8, #52]
	cmp	w8, #7
	b.ne	LBB588_21
LBB588_15:                              ; %B25
	ldp	x11, x10, [sp, #16]             ; 16-byte Folded Reload
	add	x9, x22, #8
	ldr	w8, [x11]
	add	w8, w8, #1
	str	w8, [x11]
	ldr	w8, [x10]
	sub	w8, w8, #1
	str	w8, [x10]
	stlr	x11, [x9]
	ldrb	w8, [x24, #392]
	cbnz	w8, LBB588_24
LBB588_16:                              ; %B22
	ldr	x8, [sp, #16]                   ; 8-byte Folded Reload
	ldr	w8, [x8, #20]
	b	LBB588_19
LBB588_17:                              ; %B47
	add	sp, sp, #32
	b	_exception_spill_top0_top1_asm_h
LBB588_18:                              ; %B1
	lsr	w9, w10, #26
	and	w9, w9, #0xfffffff7
	cmp	w9, #7
	b.ne	LBB588_4
LBB588_19:                              ; %B22
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #392]
	cbz	w8, LBB588_5
; %bb.20:
	mov	x1, x24
	mov	x0, x21
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #32
	br	x1
LBB588_21:                              ; %B43
	ldr	x0, [x24, #8]
	ldr	x1, [sp, #24]                   ; 8-byte Folded Reload
	mov	w3, #7                          ; =0x7
	str	w2, [sp, #12]                   ; 4-byte Folded Spill
	bl	_find_hashed_shape_prop_gc
	ldr	w2, [sp, #12]                   ; 4-byte Folded Reload
	cbz	x0, LBB588_4
; %bb.22:                               ; %B30
	ldr	x8, [x22, #16]
	ldr	x11, [sp, #24]                  ; 8-byte Folded Reload
	add	x10, x22, #32
	ldr	w9, [x0, #16]
	ldr	w11, [x11, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.ne	LBB588_25
; %bb.23:
	str	x0, [sp, #16]                   ; 8-byte Folded Spill
	b	LBB588_15
LBB588_24:                              ; %B27
	ldr	x9, [sp, #16]                   ; 8-byte Folded Reload
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	_prim_WriteBarrierNoStore
	b	LBB588_16
LBB588_25:                              ; %B30
	ldr	w2, [sp, #12]                   ; 4-byte Folded Reload
	str	x0, [sp, #16]                   ; 8-byte Folded Spill
	cbnz	w8, LBB588_15
	b	LBB588_4
                                        ; -- End function
	.private_extern	_set_name_2_asm_h       ; -- Begin function set_name_2_asm_h
	.globl	_set_name_2_asm_h
	.p2align	2
_set_name_2_asm_h:                      ; @set_name_2_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w3, #1                          ; =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_DefineObjectName
	tbnz	w0, #31, LBB589_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB589_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_set_name_computed_2_asm_h ; -- Begin function set_name_computed_2_asm_h
	.globl	_set_name_computed_2_asm_h
	.p2align	2
_set_name_computed_2_asm_h:             ; @set_name_computed_2_asm_h
; %bb.0:                                ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x2, x22
	mov	w3, #1                          ; =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, LBB590_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB590_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_set_proto_2_asm_h      ; -- Begin function set_proto_2_asm_h
	.globl	_set_proto_2_asm_h
	.p2align	2
_set_proto_2_asm_h:                     ; @set_proto_2_asm_h
; %bb.0:                                ; %B6
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	LBB591_3
; %bb.1:                                ; %B6
	cmp	x21, #2
	b.eq	LBB591_3
LBB591_2:                               ; %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB591_3:                               ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_SetPrototypeInternal_GC
	tbz	w0, #31, LBB591_2
; %bb.4:                                ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_set_home_object_2_asm_h ; -- Begin function set_home_object_2_asm_h
	.globl	_set_home_object_2_asm_h
	.p2align	2
_set_home_object_2_asm_h:               ; @set_home_object_2_asm_h
; %bb.0:                                ; %B0
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x2, x22
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_js_method_set_home_object_gc
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_define_array_el_2_asm_h ; -- Begin function define_array_el_2_asm_h
	.globl	_define_array_el_2_asm_h
	.p2align	2
_define_array_el_2_asm_h:               ; @define_array_el_2_asm_h
; %bb.0:                                ; %B1
	ldur	x1, [x20, #-8]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #16391                      ; =0x4007
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, LBB593_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB593_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_append_2_asm_h         ; -- Begin function append_2_asm_h
	.globl	_append_2_asm_h
	.p2align	2
_append_2_asm_h:                        ; @append_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_append_0_asm_h
                                        ; -- End function
	.private_extern	_copy_data_properties_2_asm_h ; -- Begin function copy_data_properties_2_asm_h
	.globl	_copy_data_properties_2_asm_h
	.p2align	2
_copy_data_properties_2_asm_h:          ; @copy_data_properties_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_copy_data_properties_0_asm_h
                                        ; -- End function
	.private_extern	_define_method_2_asm_h  ; -- Begin function define_method_2_asm_h
	.globl	_define_method_2_asm_h
	.p2align	2
_define_method_2_asm_h:                 ; @define_method_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_define_method_0_asm_h
                                        ; -- End function
	.private_extern	_define_method_computed_2_asm_h ; -- Begin function define_method_computed_2_asm_h
	.globl	_define_method_computed_2_asm_h
	.p2align	2
_define_method_computed_2_asm_h:        ; @define_method_computed_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_define_method_computed_0_asm_h
                                        ; -- End function
	.private_extern	_define_class_2_asm_h   ; -- Begin function define_class_2_asm_h
	.globl	_define_class_2_asm_h
	.p2align	2
_define_class_2_asm_h:                  ; @define_class_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_define_class_0_asm_h
                                        ; -- End function
	.private_extern	_get_loc_2_asm_h        ; -- Begin function get_loc_2_asm_h
	.globl	_get_loc_2_asm_h
	.p2align	2
_get_loc_2_asm_h:                       ; @get_loc_2_asm_h
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
	.private_extern	_put_loc_2_asm_h        ; -- Begin function put_loc_2_asm_h
	.globl	_put_loc_2_asm_h
	.p2align	2
_put_loc_2_asm_h:                       ; @put_loc_2_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc_2_asm_h        ; -- Begin function set_loc_2_asm_h
	.globl	_set_loc_2_asm_h
	.p2align	2
_set_loc_2_asm_h:                       ; @set_loc_2_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_arg_2_asm_h        ; -- Begin function get_arg_2_asm_h
	.globl	_get_arg_2_asm_h
	.p2align	2
_get_arg_2_asm_h:                       ; @get_arg_2_asm_h
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
	.private_extern	_put_arg_2_asm_h        ; -- Begin function put_arg_2_asm_h
	.globl	_put_arg_2_asm_h
	.p2align	2
_put_arg_2_asm_h:                       ; @put_arg_2_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	str	x21, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_arg_2_asm_h        ; -- Begin function set_arg_2_asm_h
	.globl	_set_arg_2_asm_h
	.p2align	2
_set_arg_2_asm_h:                       ; @set_arg_2_asm_h
; %bb.0:                                ; %B0
	ldrh	w8, [x19]
	str	x21, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_var_ref_2_asm_h    ; -- Begin function get_var_ref_2_asm_h
	.globl	_get_var_ref_2_asm_h
	.p2align	2
_get_var_ref_2_asm_h:                   ; @get_var_ref_2_asm_h
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
	.private_extern	_put_var_ref_2_asm_h    ; -- Begin function put_var_ref_2_asm_h
	.globl	_put_var_ref_2_asm_h
	.p2align	2
_put_var_ref_2_asm_h:                   ; @put_var_ref_2_asm_h
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
	.private_extern	_set_var_ref_2_asm_h    ; -- Begin function set_var_ref_2_asm_h
	.globl	_set_var_ref_2_asm_h
	.p2align	2
_set_var_ref_2_asm_h:                   ; @set_var_ref_2_asm_h
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
	.private_extern	_set_loc_uninitialized_2_asm_h ; -- Begin function set_loc_uninitialized_2_asm_h
	.globl	_set_loc_uninitialized_2_asm_h
	.p2align	2
_set_loc_uninitialized_2_asm_h:         ; @set_loc_uninitialized_2_asm_h
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
	.private_extern	_get_loc_check_2_asm_h  ; -- Begin function get_loc_check_2_asm_h
	.globl	_get_loc_check_2_asm_h
	.p2align	2
_get_loc_check_2_asm_h:                 ; @get_loc_check_2_asm_h
; %bb.0:                                ; %B2
	str	x22, [x20], #8
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	LBB609_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB609_2:                               ; %B3
	str	x21, [x20], #8
	b	_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.private_extern	_put_loc_check_2_asm_h  ; -- Begin function put_loc_check_2_asm_h
	.globl	_put_loc_check_2_asm_h
	.p2align	2
_put_loc_check_2_asm_h:                 ; @put_loc_check_2_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	LBB610_2
; %bb.1:                                ; %B4
	str	x21, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB610_2:                               ; %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.private_extern	_put_loc_check_init_2_asm_h ; -- Begin function put_loc_check_init_2_asm_h
	.globl	_put_loc_check_init_2_asm_h
	.p2align	2
_put_loc_check_init_2_asm_h:            ; @put_loc_check_init_2_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	LBB611_2
; %bb.1:                                ; %B4
	str	x21, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB611_2:                               ; %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_ThrowThisReferenceError_asm_h
                                        ; -- End function
	.private_extern	_get_var_ref_check_2_asm_h ; -- Begin function get_var_ref_check_2_asm_h
	.globl	_get_var_ref_check_2_asm_h
	.p2align	2
_get_var_ref_check_2_asm_h:             ; @get_var_ref_check_2_asm_h
; %bb.0:                                ; %B2
	str	x22, [x20], #8
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	LBB612_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB612_2:                               ; %B3
	str	x21, [x20], #8
	b	_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.private_extern	_put_var_ref_check_2_asm_h ; -- Begin function put_var_ref_check_2_asm_h
	.globl	_put_var_ref_check_2_asm_h
	.p2align	2
_put_var_ref_check_2_asm_h:             ; @put_var_ref_check_2_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	LBB613_2
; %bb.1:                                ; %B4
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB613_2:                               ; %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.private_extern	_put_var_ref_check_init_2_asm_h ; -- Begin function put_var_ref_check_init_2_asm_h
	.globl	_put_var_ref_check_init_2_asm_h
	.p2align	2
_put_var_ref_check_init_2_asm_h:        ; @put_var_ref_check_init_2_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	LBB614_2
; %bb.1:                                ; %B4
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB614_2:                               ; %B3
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.private_extern	_close_loc_2_asm_h      ; -- Begin function close_loc_2_asm_h
	.globl	_close_loc_2_asm_h
	.p2align	2
_close_loc_2_asm_h:                     ; @close_loc_2_asm_h
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
	.private_extern	_if_false_2_asm_h       ; -- Begin function if_false_2_asm_h
	.globl	_if_false_2_asm_h
	.p2align	2
_if_false_2_asm_h:                      ; @if_false_2_asm_h
; %bb.0:                                ; %B23
	cmp	x21, #5
	b.le	LBB616_4
; %bb.1:                                ; %B23
	cmp	x21, #6
	b.eq	LBB616_6
; %bb.2:                                ; %B23
	cmp	x21, #7
	b.eq	LBB616_9
; %bb.3:                                ; %B23
	cmp	x21, #18
	b.eq	LBB616_6
	b	LBB616_7
LBB616_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB616_6
; %bb.5:                                ; %B23
	cmp	x21, #2
	b.ne	LBB616_7
LBB616_6:                               ; %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB616_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x21, x8
	b.hs	LBB616_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB616_10
LBB616_9:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB616_10:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB616_13
; %bb.11:                               ; %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB616_6
	b.vs	LBB616_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB616_9
	b	LBB616_6
LBB616_13:                              ; %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	_SlowToBoolean_asm_h
                                        ; -- End function
	.private_extern	_if_true_2_asm_h        ; -- Begin function if_true_2_asm_h
	.globl	_if_true_2_asm_h
	.p2align	2
_if_true_2_asm_h:                       ; @if_true_2_asm_h
; %bb.0:                                ; %B23
	cmp	x21, #5
	b.le	LBB617_4
; %bb.1:                                ; %B23
	cmp	x21, #6
	b.eq	LBB617_6
; %bb.2:                                ; %B23
	cmp	x21, #7
	b.eq	LBB617_9
; %bb.3:                                ; %B23
	cmp	x21, #18
	b.eq	LBB617_6
	b	LBB617_7
LBB617_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB617_6
; %bb.5:                                ; %B23
	cmp	x21, #2
	b.ne	LBB617_7
LBB617_6:                               ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB617_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x21, x8
	b.hs	LBB617_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB617_10
LBB617_9:                               ; %B19
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB617_10:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB617_13
; %bb.11:                               ; %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB617_6
	b.vs	LBB617_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB617_9
	b	LBB617_6
LBB617_13:                              ; %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	_SlowToBoolean_asm_h
                                        ; -- End function
	.private_extern	_goto_2_asm_h           ; -- Begin function goto_2_asm_h
	.globl	_goto_2_asm_h
	.p2align	2
_goto_2_asm_h:                          ; @goto_2_asm_h
; %bb.0:                                ; %B0
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_catch_2_asm_h          ; -- Begin function catch_2_asm_h
	.globl	_catch_2_asm_h
	.p2align	2
_catch_2_asm_h:                         ; @catch_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	w8, #66                         ; =0x42
	ldr	x9, [x23, #8]
	ldrb	w10, [x19, #4]
	ldr	w11, [x19]
	mov	x22, x21
	ldr	x9, [x9, #32]
	add	w10, w10, #486
	ldr	x1, [x25, w10, uxtw #3]
	ldr	x9, [x9, #8]
	sub	x9, x19, x9
	add	x19, x19, #5
	add	x9, x9, x11
	orr	x21, x8, x9, lsl #16
	br	x1
                                        ; -- End function
	.private_extern	_gosub_2_asm_h          ; -- Begin function gosub_2_asm_h
	.globl	_gosub_2_asm_h
	.p2align	2
_gosub_2_asm_h:                         ; @gosub_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrsw	x8, [x19]
	ldr	x9, [x23, #8]
	ldr	x9, [x9, #32]
	add	x8, x19, x8
	ldrb	w10, [x8], #1
	ldr	w9, [x9, #8]
	add	w10, w10, #486
	sub	w9, w19, w9
	ldr	x1, [x25, w10, uxtw #3]
	mov	x19, x8
	add	w9, w9, #4
	orr	x21, x9, #0xfffe000000000000
	br	x1
                                        ; -- End function
	.private_extern	_ret_2_asm_h            ; -- Begin function ret_2_asm_h
	.globl	_ret_2_asm_h
	.p2align	2
_ret_2_asm_h:                           ; @ret_2_asm_h
; %bb.0:                                ; %B6
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	LBB621_3
; %bb.1:                                ; %B1
	ldr	x8, [x23, #8]
	ldr	x8, [x8, #32]
	ldr	w9, [x8, #16]
	cmp	w21, w9
	b.ge	LBB621_3
; %bb.2:                                ; %B5
	ldr	x8, [x8, #8]
	add	x19, x8, w21, sxtw
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB621_3:                               ; %B3
	add	x8, x20, #16
Lloh40:
	adrp	x1, l___unnamed_19@PAGE
Lloh41:
	add	x1, x1, l___unnamed_19@PAGEOFF
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_LEPUS_ThrowInternalError
	b	_exception_spill_top0_top1_asm_h
	.loh AdrpAdd	Lloh40, Lloh41
                                        ; -- End function
	.private_extern	_to_object_2_asm_h      ; -- Begin function to_object_2_asm_h
	.globl	_to_object_2_asm_h
	.p2align	2
_to_object_2_asm_h:                     ; @to_object_2_asm_h
; %bb.0:                                ; %B6
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	LBB622_2
; %bb.1:                                ; %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB622_2:                               ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB622_4
; %bb.3:                                ; %B3
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB622_4:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_to_propkey_2_asm_h     ; -- Begin function to_propkey_2_asm_h
	.globl	_to_propkey_2_asm_h
	.p2align	2
_to_propkey_2_asm_h:                    ; @to_propkey_2_asm_h
; %bb.0:                                ; %B15
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	LBB623_4
; %bb.1:                                ; %B15
	mov	x9, #1                          ; =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB623_4
; %bb.2:                                ; %B15
	cmp	x8, x9
	b.eq	LBB623_4
; %bb.3:                                ; %B15
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB623_5
LBB623_4:                               ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB623_5:                               ; %B12
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB623_7
; %bb.6:                                ; %B14
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB623_7:                               ; %B13
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_to_propkey2_2_asm_h    ; -- Begin function to_propkey2_2_asm_h
	.globl	_to_propkey2_2_asm_h
	.p2align	2
_to_propkey2_2_asm_h:                   ; @to_propkey2_2_asm_h
; %bb.0:                                ; %B18
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	LBB624_3
; %bb.1:                                ; %B19
	add	x8, x20, #16
Lloh42:
	adrp	x1, l___unnamed_20@PAGE
Lloh43:
	add	x1, x1, l___unnamed_20@PAGEOFF
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_LEPUS_ThrowTypeError
LBB624_2:                               ; %B16
	b	_exception_spill_top0_top1_asm_h
LBB624_3:                               ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	LBB624_7
; %bb.4:                                ; %B2
	mov	x9, #1                          ; =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB624_7
; %bb.5:                                ; %B2
	cmp	x8, x9
	b.eq	LBB624_7
; %bb.6:                                ; %B2
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB624_8
LBB624_7:                               ; %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB624_8:                               ; %B15
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB624_2
; %bb.9:                                ; %B17
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh42, Lloh43
                                        ; -- End function
	.private_extern	_with_get_var_2_asm_h   ; -- Begin function with_get_var_2_asm_h
	.globl	_with_get_var_2_asm_h
	.p2align	2
_with_get_var_2_asm_h:                  ; @with_get_var_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_with_get_var_0_asm_h
                                        ; -- End function
	.private_extern	_with_put_var_2_asm_h   ; -- Begin function with_put_var_2_asm_h
	.globl	_with_put_var_2_asm_h
	.p2align	2
_with_put_var_2_asm_h:                  ; @with_put_var_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_with_put_var_0_asm_h
                                        ; -- End function
	.private_extern	_with_delete_var_2_asm_h ; -- Begin function with_delete_var_2_asm_h
	.globl	_with_delete_var_2_asm_h
	.p2align	2
_with_delete_var_2_asm_h:               ; @with_delete_var_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_with_delete_var_0_asm_h
                                        ; -- End function
	.private_extern	_with_make_ref_2_asm_h  ; -- Begin function with_make_ref_2_asm_h
	.globl	_with_make_ref_2_asm_h
	.p2align	2
_with_make_ref_2_asm_h:                 ; @with_make_ref_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_with_make_ref_0_asm_h
                                        ; -- End function
	.private_extern	_with_get_ref_2_asm_h   ; -- Begin function with_get_ref_2_asm_h
	.globl	_with_get_ref_2_asm_h
	.p2align	2
_with_get_ref_2_asm_h:                  ; @with_get_ref_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_with_get_ref_0_asm_h
                                        ; -- End function
	.private_extern	_with_get_ref_undef_2_asm_h ; -- Begin function with_get_ref_undef_2_asm_h
	.globl	_with_get_ref_undef_2_asm_h
	.p2align	2
_with_get_ref_undef_2_asm_h:            ; @with_get_ref_undef_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_with_get_ref_undef_0_asm_h
                                        ; -- End function
	.private_extern	_make_loc_ref_2_asm_h   ; -- Begin function make_loc_ref_2_asm_h
	.globl	_make_loc_ref_2_asm_h
	.p2align	2
_make_loc_ref_2_asm_h:                  ; @make_loc_ref_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_make_loc_ref_0_asm_h
                                        ; -- End function
	.private_extern	_make_arg_ref_2_asm_h   ; -- Begin function make_arg_ref_2_asm_h
	.globl	_make_arg_ref_2_asm_h
	.p2align	2
_make_arg_ref_2_asm_h:                  ; @make_arg_ref_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_make_arg_ref_0_asm_h
                                        ; -- End function
	.private_extern	_make_var_ref_ref_2_asm_h ; -- Begin function make_var_ref_ref_2_asm_h
	.globl	_make_var_ref_ref_2_asm_h
	.p2align	2
_make_var_ref_ref_2_asm_h:              ; @make_var_ref_ref_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_make_var_ref_ref_0_asm_h
                                        ; -- End function
	.private_extern	_make_var_ref_2_asm_h   ; -- Begin function make_var_ref_2_asm_h
	.globl	_make_var_ref_2_asm_h
	.p2align	2
_make_var_ref_2_asm_h:                  ; @make_var_ref_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_make_var_ref_0_asm_h
                                        ; -- End function
	.private_extern	_for_in_start_2_asm_h   ; -- Begin function for_in_start_2_asm_h
	.globl	_for_in_start_2_asm_h
	.p2align	2
_for_in_start_2_asm_h:                  ; @for_in_start_2_asm_h
; %bb.0:                                ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	LBB635_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB635_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_for_of_start_2_asm_h   ; -- Begin function for_of_start_2_asm_h
	.globl	_for_of_start_2_asm_h
	.p2align	2
_for_of_start_2_asm_h:                  ; @for_of_start_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_for_of_start_0_asm_h
                                        ; -- End function
	.private_extern	_for_await_of_start_2_asm_h ; -- Begin function for_await_of_start_2_asm_h
	.globl	_for_await_of_start_2_asm_h
	.p2align	2
_for_await_of_start_2_asm_h:            ; @for_await_of_start_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_for_await_of_start_0_asm_h
                                        ; -- End function
	.private_extern	_for_in_next_2_asm_h    ; -- Begin function for_in_next_2_asm_h
	.globl	_for_in_next_2_asm_h
	.p2align	2
_for_in_next_2_asm_h:                   ; @for_in_next_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_for_in_next_0_asm_h
                                        ; -- End function
	.private_extern	_for_of_next_2_asm_h    ; -- Begin function for_of_next_2_asm_h
	.globl	_for_of_next_2_asm_h
	.p2align	2
_for_of_next_2_asm_h:                   ; @for_of_next_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_for_of_next_0_asm_h
                                        ; -- End function
	.private_extern	_for_await_of_next_2_asm_h ; -- Begin function for_await_of_next_2_asm_h
	.globl	_for_await_of_next_2_asm_h
	.p2align	2
_for_await_of_next_2_asm_h:             ; @for_await_of_next_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_for_await_of_next_0_asm_h
                                        ; -- End function
	.private_extern	_iterator_get_value_done_2_asm_h ; -- Begin function iterator_get_value_done_2_asm_h
	.globl	_iterator_get_value_done_2_asm_h
	.p2align	2
_iterator_get_value_done_2_asm_h:       ; @iterator_get_value_done_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_iterator_get_value_done_0_asm_h
                                        ; -- End function
	.private_extern	_iterator_close_2_asm_h ; -- Begin function iterator_close_2_asm_h
	.globl	_iterator_close_2_asm_h
	.p2align	2
_iterator_close_2_asm_h:                ; @iterator_close_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_iterator_close_0_asm_h
                                        ; -- End function
	.private_extern	_iterator_close_return_2_asm_h ; -- Begin function iterator_close_return_2_asm_h
	.globl	_iterator_close_return_2_asm_h
	.p2align	2
_iterator_close_return_2_asm_h:         ; @iterator_close_return_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_iterator_close_return_0_asm_h
                                        ; -- End function
	.private_extern	_async_iterator_close_2_asm_h ; -- Begin function async_iterator_close_2_asm_h
	.globl	_async_iterator_close_2_asm_h
	.p2align	2
_async_iterator_close_2_asm_h:          ; @async_iterator_close_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_async_iterator_close_0_asm_h
                                        ; -- End function
	.private_extern	_async_iterator_next_2_asm_h ; -- Begin function async_iterator_next_2_asm_h
	.globl	_async_iterator_next_2_asm_h
	.p2align	2
_async_iterator_next_2_asm_h:           ; @async_iterator_next_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_async_iterator_next_0_asm_h
                                        ; -- End function
	.private_extern	_async_iterator_get_2_asm_h ; -- Begin function async_iterator_get_2_asm_h
	.globl	_async_iterator_get_2_asm_h
	.p2align	2
_async_iterator_get_2_asm_h:            ; @async_iterator_get_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_async_iterator_get_0_asm_h
                                        ; -- End function
	.private_extern	_initial_yield_2_asm_h  ; -- Begin function initial_yield_2_asm_h
	.globl	_initial_yield_2_asm_h
	.p2align	2
_initial_yield_2_asm_h:                 ; @initial_yield_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_initial_yield_0_asm_h
                                        ; -- End function
	.private_extern	_yield_2_asm_h          ; -- Begin function yield_2_asm_h
	.globl	_yield_2_asm_h
	.p2align	2
_yield_2_asm_h:                         ; @yield_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_yield_0_asm_h
                                        ; -- End function
	.private_extern	_yield_star_2_asm_h     ; -- Begin function yield_star_2_asm_h
	.globl	_yield_star_2_asm_h
	.p2align	2
_yield_star_2_asm_h:                    ; @yield_star_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_yield_star_0_asm_h
                                        ; -- End function
	.private_extern	_async_yield_star_2_asm_h ; -- Begin function async_yield_star_2_asm_h
	.globl	_async_yield_star_2_asm_h
	.p2align	2
_async_yield_star_2_asm_h:              ; @async_yield_star_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_async_yield_star_0_asm_h
                                        ; -- End function
	.private_extern	_await_2_asm_h          ; -- Begin function await_2_asm_h
	.globl	_await_2_asm_h
	.p2align	2
_await_2_asm_h:                         ; @await_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_await_0_asm_h
                                        ; -- End function
	.private_extern	_neg_2_asm_h            ; -- Begin function neg_2_asm_h
	.globl	_neg_2_asm_h
	.p2align	2
_neg_2_asm_h:                           ; @neg_2_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	LBB652_3
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB652_6
; %bb.2:                                ; %B13
	orr	w8, w21, #0x80000000
	mov	w9, #-2147483648                ; =0x80000000
	cmp	w8, w9
	b.ne	LBB652_5
LBB652_3:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #140                        ; =0x8c
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB652_8
; %bb.4:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB652_5:                               ; %B15
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x1
LBB652_6:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB652_3
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
LBB652_8:                               ; %B17
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_plus_2_asm_h           ; -- Begin function plus_2_asm_h
	.globl	_plus_2_asm_h
	.p2align	2
_plus_2_asm_h:                          ; @plus_2_asm_h
; %bb.0:                                ; %B13
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	LBB653_4
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB653_3
LBB653_2:                               ; %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB653_3:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.ne	LBB653_2
LBB653_4:                               ; %B10
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #141                        ; =0x8d
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB653_6
; %bb.5:                                ; %B12
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB653_6:                               ; %B11
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_dec_2_asm_h            ; -- Begin function dec_2_asm_h
	.globl	_dec_2_asm_h
	.p2align	2
_dec_2_asm_h:                           ; @dec_2_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	LBB654_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB654_4
; %bb.2:                                ; %B13
	subs	w8, w21, #1
	b.vs	LBB654_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB654_4:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB654_6
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
LBB654_6:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #142                        ; =0x8e
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB654_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB654_8:                               ; %B17
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_inc_2_asm_h            ; -- Begin function inc_2_asm_h
	.globl	_inc_2_asm_h
	.p2align	2
_inc_2_asm_h:                           ; @inc_2_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	LBB655_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB655_4
; %bb.2:                                ; %B13
	adds	w8, w21, #1
	b.vs	LBB655_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB655_4:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB655_6
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
LBB655_6:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #143                        ; =0x8f
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB655_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB655_8:                               ; %B17
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_post_dec_2_asm_h       ; -- Begin function post_dec_2_asm_h
	.globl	_post_dec_2_asm_h
	.p2align	2
_post_dec_2_asm_h:                      ; @post_dec_2_asm_h
; %bb.0:                                ; %B16
	mov	x8, #-281474976710656           ; =0xffff000000000000
	str	x22, [x20], #8
	cmp	x21, x8
	b.hs	LBB656_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB656_4
; %bb.2:                                ; %B13
	subs	w8, w21, #1
	b.vs	LBB656_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	mov	x22, x21
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB656_4:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB656_6
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
LBB656_6:                               ; %B5
	str	x21, [x20], #8
	mov	w0, #144                        ; =0x90
	b	_SlowJSPostInc_asm_h
                                        ; -- End function
	.private_extern	_post_inc_2_asm_h       ; -- Begin function post_inc_2_asm_h
	.globl	_post_inc_2_asm_h
	.p2align	2
_post_inc_2_asm_h:                      ; @post_inc_2_asm_h
; %bb.0:                                ; %B16
	mov	x8, #-281474976710656           ; =0xffff000000000000
	str	x22, [x20], #8
	cmp	x21, x8
	b.hs	LBB657_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB657_4
; %bb.2:                                ; %B13
	adds	w8, w21, #1
	b.vs	LBB657_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	mov	x22, x21
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB657_4:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB657_6
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
LBB657_6:                               ; %B5
	str	x21, [x20], #8
	mov	w0, #145                        ; =0x91
	b	_SlowJSPostInc_asm_h
                                        ; -- End function
	.private_extern	_dec_loc_2_asm_h        ; -- Begin function dec_loc_2_asm_h
	.globl	_dec_loc_2_asm_h
	.p2align	2
_dec_loc_2_asm_h:                       ; @dec_loc_2_asm_h
; %bb.0:                                ; %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	LBB658_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB658_4
; %bb.2:                                ; %B13
	subs	w9, w1, #1
	b.vs	LBB658_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB658_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB658_6
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
LBB658_6:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #142                        ; =0x8e
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB658_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB658_8:                               ; %B17
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_inc_loc_2_asm_h        ; -- Begin function inc_loc_2_asm_h
	.globl	_inc_loc_2_asm_h
	.p2align	2
_inc_loc_2_asm_h:                       ; @inc_loc_2_asm_h
; %bb.0:                                ; %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	LBB659_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB659_4
; %bb.2:                                ; %B13
	adds	w9, w1, #1
	b.vs	LBB659_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB659_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB659_6
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
LBB659_6:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #143                        ; =0x8f
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB659_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB659_8:                               ; %B17
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_add_loc_2_asm_h        ; -- Begin function add_loc_2_asm_h
	.globl	_add_loc_2_asm_h
	.p2align	2
_add_loc_2_asm_h:                       ; @add_loc_2_asm_h
; %bb.0:                                ; %B42
	sub	sp, sp, #16
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	ccmp	x21, x9, #2, ls
	b.hi	LBB660_15
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB660_6
; %bb.2:                                ; %B26
	cmp	x21, x9
	b.lo	LBB660_9
; %bb.3:                                ; %B36
	adds	w9, w1, w21
	b.vs	LBB660_15
; %bb.4:                                ; %B38
	orr	x9, x9, #0xfffe000000000000
LBB660_5:                               ; %B38
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB660_6:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB660_15
; %bb.7:                                ; %B11
	cmp	x21, x9
	b.lo	LBB660_13
; %bb.8:                                ; %B21
	scvtf	d0, w21
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	LBB660_12
LBB660_9:                               ; %B28
	tst	x21, #0xfffe000000000000
	b.eq	LBB660_15
; %bb.10:                               ; %B31
	scvtf	d0, w1
	add	x9, x21, x9
LBB660_11:                              ; %B31
	fmov	d1, x9
	fadd	d0, d0, d1
LBB660_12:                              ; %B31
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	add	x9, x9, x10
	mov	x10, #9221683186994511872       ; =0x7ffa000000000000
	csel	x9, x9, x10, vc
	b	LBB660_5
LBB660_13:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB660_15
; %bb.14:                               ; %B16
	add	x10, x1, x9
	add	x9, x21, x9
	fmov	d0, x10
	b	LBB660_11
LBB660_15:                              ; %B7
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
	b.ne	LBB660_18
; %bb.16:                               ; %B39
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, x24
	mov	x2, x21
	stp	x22, x21, [x8]
	str	x20, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB660_19
; %bb.17:                               ; %B41
	ldrb	w8, [x19]
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB660_18:                              ; %B8
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	w0, #1                          ; =0x1
	stp	x22, x21, [x8]
	add	sp, sp, #16
	b	_FastJSConcatString_asm_h
LBB660_19:                              ; %B40
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_not_2_asm_h            ; -- Begin function not_2_asm_h
	.globl	_not_2_asm_h
	.p2align	2
_not_2_asm_h:                           ; @not_2_asm_h
; %bb.0:                                ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	LBB661_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x1
LBB661_2:                               ; %B4
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	_SlowJSNot_asm_h
                                        ; -- End function
	.private_extern	_lnot_2_asm_h           ; -- Begin function lnot_2_asm_h
	.globl	_lnot_2_asm_h
	.p2align	2
_lnot_2_asm_h:                          ; @lnot_2_asm_h
; %bb.0:                                ; %B14
	cmp	x21, #5
	b.le	LBB662_4
; %bb.1:                                ; %B14
	cmp	x21, #6
	b.eq	LBB662_6
; %bb.2:                                ; %B14
	cmp	x21, #7
	b.eq	LBB662_8
; %bb.3:                                ; %B14
	cmp	x21, #18
	b.eq	LBB662_6
	b	LBB662_7
LBB662_4:                               ; %B14
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB662_6
; %bb.5:                                ; %B14
	cmp	x21, #2
	b.ne	LBB662_7
LBB662_6:                               ; %B3
	mov	w21, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB662_7:                               ; %B10
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	LBB662_9
LBB662_8:                               ; %B12
	mov	w21, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB662_9:                               ; %B13
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	_SlowToBoolean_asm_h
                                        ; -- End function
	.private_extern	_typeof_2_asm_h         ; -- Begin function typeof_2_asm_h
	.globl	_typeof_2_asm_h
	.p2align	2
_typeof_2_asm_h:                        ; @typeof_2_asm_h
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
	b.eq	LBB663_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB663_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_delete_2_asm_h         ; -- Begin function delete_2_asm_h
	.globl	_delete_2_asm_h
	.p2align	2
_delete_2_asm_h:                        ; @delete_2_asm_h
; %bb.0:                                ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	LBB664_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB664_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_delete_var_2_asm_h     ; -- Begin function delete_var_2_asm_h
	.globl	_delete_var_2_asm_h
	.p2align	2
_delete_var_2_asm_h:                    ; @delete_var_2_asm_h
; %bb.0:                                ; %B1
	str	x22, [x20]
	mov	x0, x24
	mov	w3, wzr
	ldr	w2, [x19]
	ldr	x1, [x24, #208]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #48]
	bl	_JS_DeleteProperty_GC
	tbnz	w0, #31, LBB665_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	mov	x22, x21
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x21, x8, ne
	br	x1
LBB665_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_mul_2_asm_h            ; -- Begin function mul_2_asm_h
	.globl	_mul_2_asm_h
	.p2align	2
_mul_2_asm_h:                           ; @mul_2_asm_h
; %bb.0:                                ; %B47
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB666_18
; %bb.1:                                ; %B47
	cmp	x21, x8
	b.hi	LBB666_18
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB666_8
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB666_11
; %bb.4:                                ; %B33
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	LBB666_18
; %bb.5:                                ; %B36
	cbnz	w8, LBB666_7
; %bb.6:                                ; %B36
	orr	w9, w22, w21
	tbnz	w9, #31, LBB666_15
LBB666_7:                               ; %B43
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB666_8:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB666_18
; %bb.9:                                ; %B7
	cmp	x21, x8
	b.lo	LBB666_16
; %bb.10:                               ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	LBB666_14
LBB666_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB666_18
; %bb.12:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB666_13:                              ; %B28
	fmov	d1, x8
	fmul	d0, d0, d1
LBB666_14:                              ; %B28
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
LBB666_15:                              ; %B40
	mov	x22, #-9222809086901354496      ; =0x8002000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB666_16:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB666_18
; %bb.17:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB666_13
LBB666_18:                              ; %B44
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        ; =0x9a
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB666_20
; %bb.19:                               ; %B46
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB666_20:                              ; %B45
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_div_2_asm_h            ; -- Begin function div_2_asm_h
	.globl	_div_2_asm_h
	.p2align	2
_div_2_asm_h:                           ; @div_2_asm_h
; %bb.0:                                ; %B44
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB667_14
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB667_14
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB667_5
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB667_8
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
LBB667_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB667_14
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB667_12
; %bb.7:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	LBB667_11
LBB667_8:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB667_14
; %bb.9:                                ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB667_10:                              ; %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
LBB667_11:                              ; %B28
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
LBB667_12:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB667_14
; %bb.13:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB667_10
LBB667_14:                              ; %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        ; =0x9b
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB667_16
; %bb.15:                               ; %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB667_16:                              ; %B42
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_mod_2_asm_h            ; -- Begin function mod_2_asm_h
	.globl	_mod_2_asm_h
	.p2align	2
_mod_2_asm_h:                           ; @mod_2_asm_h
; %bb.0:                                ; %B39
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB668_16
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB668_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB668_7
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB668_10
; %bb.4:                                ; %B33
	tbnz	w22, #31, LBB668_16
; %bb.5:                                ; %B33
	cmp	w21, #1
	b.lt	LBB668_16
; %bb.6:                                ; %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB668_7:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB668_16
; %bb.8:                                ; %B7
	cmp	x21, x8
	b.lo	LBB668_14
; %bb.9:                                ; %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	LBB668_13
LBB668_10:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB668_16
; %bb.11:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB668_12:                              ; %B28
	fmov	d1, x8
LBB668_13:                              ; %B28
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
LBB668_14:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB668_16
; %bb.15:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB668_12
LBB668_16:                              ; %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        ; =0x9c
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB668_18
; %bb.17:                               ; %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB668_18:                              ; %B37
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_add_2_asm_h            ; -- Begin function add_2_asm_h
	.globl	_add_2_asm_h
	.p2align	2
_add_2_asm_h:                           ; @add_2_asm_h
; %bb.0:                                ; %B42
	sub	sp, sp, #16
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB669_15
; %bb.1:                                ; %B42
	cmp	x21, x8
	b.hi	LBB669_15
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB669_6
; %bb.3:                                ; %B26
	cmp	x21, x8
	b.lo	LBB669_9
; %bb.4:                                ; %B36
	adds	w8, w22, w21
	b.vs	LBB669_15
; %bb.5:                                ; %B38
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB669_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB669_15
; %bb.7:                                ; %B11
	cmp	x21, x8
	b.lo	LBB669_13
; %bb.8:                                ; %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	LBB669_12
LBB669_9:                               ; %B28
	tst	x21, #0xfffe000000000000
	b.eq	LBB669_15
; %bb.10:                               ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB669_11:                              ; %B31
	fmov	d1, x8
	fadd	d0, d0, d1
LBB669_12:                              ; %B31
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
LBB669_13:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB669_15
; %bb.14:                               ; %B16
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB669_11
LBB669_15:                              ; %B7
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
	b.ne	LBB669_18
; %bb.16:                               ; %B7
	cbz	w8, LBB669_18
; %bb.17:                               ; %B8
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, xzr
	stp	x22, x21, [x8]
	add	sp, sp, #16
	b	_FastJSConcatString_asm_h
LBB669_18:                              ; %B39
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x8]
	str	x20, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB669_20
; %bb.19:                               ; %B41
	ldrb	w8, [x19], #1
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB669_20:                              ; %B40
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_sub_2_asm_h            ; -- Begin function sub_2_asm_h
	.globl	_sub_2_asm_h
	.p2align	2
_sub_2_asm_h:                           ; @sub_2_asm_h
; %bb.0:                                ; %B39
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB670_15
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB670_15
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB670_6
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB670_9
; %bb.4:                                ; %B33
	subs	w8, w22, w21
	b.vs	LBB670_15
; %bb.5:                                ; %B35
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB670_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB670_15
; %bb.7:                                ; %B7
	cmp	x21, x8
	b.lo	LBB670_13
; %bb.8:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	LBB670_12
LBB670_9:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB670_15
; %bb.10:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB670_11:                              ; %B28
	fmov	d1, x8
	fsub	d0, d0, d1
LBB670_12:                              ; %B28
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
LBB670_13:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB670_15
; %bb.14:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB670_11
LBB670_15:                              ; %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        ; =0x9e
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB670_17
; %bb.16:                               ; %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB670_17:                              ; %B37
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_pow_2_asm_h            ; -- Begin function pow_2_asm_h
	.globl	_pow_2_asm_h
	.p2align	2
_pow_2_asm_h:                           ; @pow_2_asm_h
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
	b.eq	LBB671_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB671_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_shl_2_asm_h            ; -- Begin function shl_2_asm_h
	.globl	_shl_2_asm_h
	.p2align	2
_shl_2_asm_h:                           ; @shl_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB672_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB672_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB672_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB672_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB672_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB672_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB672_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB672_9
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
LBB672_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        ; =0xa0
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB672_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB672_11:                              ; %B26
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_sar_2_asm_h            ; -- Begin function sar_2_asm_h
	.globl	_sar_2_asm_h
	.p2align	2
_sar_2_asm_h:                           ; @sar_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB673_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB673_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB673_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB673_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB673_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB673_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB673_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB673_9
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
LBB673_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        ; =0xa1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB673_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB673_11:                              ; %B26
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_shr_2_asm_h            ; -- Begin function shr_2_asm_h
	.globl	_shr_2_asm_h
	.p2align	2
_shr_2_asm_h:                           ; @shr_2_asm_h
; %bb.0:                                ; %B36
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB674_11
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB674_11
; %bb.2:                                ; %B10
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB674_6
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB674_11
; %bb.4:                                ; %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, LBB674_10
LBB674_5:                               ; %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB674_6:                               ; %B12
	tst	x22, #0xfffe000000000000
	b.eq	LBB674_11
; %bb.7:                                ; %B12
	cmp	x21, x8
	b.lo	LBB674_11
; %bb.8:                                ; %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB674_11
; %bb.9:                                ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, LBB674_5
LBB674_10:                              ; %B6
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
LBB674_11:                              ; %B33
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	LBB674_13
; %bb.12:                               ; %B35
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB674_13:                              ; %B34
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_lt_2_asm_h             ; -- Begin function lt_2_asm_h
	.globl	_lt_2_asm_h
	.p2align	2
_lt_2_asm_h:                            ; @lt_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB675_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB675_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB675_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB675_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, lt
	br	x1
LBB675_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB675_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB675_10
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
LBB675_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB675_12
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
LBB675_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB675_12
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
LBB675_12:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        ; =0xa3
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB675_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB675_14:                              ; %B22
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_lte_2_asm_h            ; -- Begin function lte_2_asm_h
	.globl	_lte_2_asm_h
	.p2align	2
_lte_2_asm_h:                           ; @lte_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB676_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB676_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB676_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB676_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, le
	br	x1
LBB676_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB676_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB676_10
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
LBB676_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB676_12
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
LBB676_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB676_12
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
LBB676_12:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        ; =0xa4
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB676_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB676_14:                              ; %B22
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_gt_2_asm_h             ; -- Begin function gt_2_asm_h
	.globl	_gt_2_asm_h
	.p2align	2
_gt_2_asm_h:                            ; @gt_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB677_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB677_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB677_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB677_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB677_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB677_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB677_10
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
LBB677_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB677_12
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
LBB677_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB677_12
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
LBB677_12:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        ; =0xa5
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB677_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB677_14:                              ; %B22
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_gte_2_asm_h            ; -- Begin function gte_2_asm_h
	.globl	_gte_2_asm_h
	.p2align	2
_gte_2_asm_h:                           ; @gte_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB678_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB678_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB678_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB678_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB678_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB678_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB678_10
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
LBB678_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB678_12
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
LBB678_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB678_12
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
LBB678_12:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        ; =0xa6
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB678_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB678_14:                              ; %B22
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_instanceof_2_asm_h     ; -- Begin function instanceof_2_asm_h
	.globl	_instanceof_2_asm_h
	.p2align	2
_instanceof_2_asm_h:                    ; @instanceof_2_asm_h
; %bb.0:                                ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	LBB679_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB679_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_in_2_asm_h             ; -- Begin function in_2_asm_h
	.globl	_in_2_asm_h
	.p2align	2
_in_2_asm_h:                            ; @in_2_asm_h
; %bb.0:                                ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	LBB680_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB680_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_eq_2_asm_h             ; -- Begin function eq_2_asm_h
	.globl	_eq_2_asm_h
	.p2align	2
_eq_2_asm_h:                            ; @eq_2_asm_h
; %bb.0:                                ; %B44
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB681_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB681_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB681_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB681_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB681_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB681_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB681_11
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
LBB681_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB681_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB681_10:                              ; %B39
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
LBB681_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB681_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB681_10
LBB681_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB681_15
LBB681_14:                              ; %B8
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB681_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB681_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB681_14
	b	LBB681_20
LBB681_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB681_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB681_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB681_21
LBB681_20:                              ; %B15
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB681_21:                              ; %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB681_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB681_23:                              ; %B42
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_neq_2_asm_h            ; -- Begin function neq_2_asm_h
	.globl	_neq_2_asm_h
	.p2align	2
_neq_2_asm_h:                           ; @neq_2_asm_h
; %bb.0:                                ; %B44
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB682_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB682_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB682_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB682_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB682_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB682_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB682_11
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
LBB682_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB682_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB682_10:                              ; %B39
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
LBB682_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB682_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB682_10
LBB682_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB682_15
LBB682_14:                              ; %B8
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB682_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB682_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB682_14
	b	LBB682_20
LBB682_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB682_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB682_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB682_21
LBB682_20:                              ; %B15
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB682_21:                              ; %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB682_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB682_23:                              ; %B42
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_strict_eq_2_asm_h      ; -- Begin function strict_eq_2_asm_h
	.globl	_strict_eq_2_asm_h
	.p2align	2
_strict_eq_2_asm_h:                     ; @strict_eq_2_asm_h
; %bb.0:                                ; %B39
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB683_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB683_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB683_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB683_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB683_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB683_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB683_11
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
LBB683_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB683_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB683_10:                              ; %B34
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
LBB683_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB683_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB683_10
LBB683_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB683_15
LBB683_14:                              ; %B11
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB683_15:                              ; %B13
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
	b.ne	LBB683_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB683_22
LBB683_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB683_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB683_23
LBB683_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB683_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB683_25
LBB683_21:                              ; %B21
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB683_22:                              ; %B14
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, xzr
	stp	x22, x21, [x8]
	b	_FastStringEqual_asm_h
LBB683_23:                              ; %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB683_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB683_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB683_14
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB683_27:                              ; %B37
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_strict_neq_2_asm_h     ; -- Begin function strict_neq_2_asm_h
	.globl	_strict_neq_2_asm_h
	.p2align	2
_strict_neq_2_asm_h:                    ; @strict_neq_2_asm_h
; %bb.0:                                ; %B39
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB684_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB684_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB684_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB684_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB684_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB684_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB684_11
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
LBB684_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB684_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB684_10:                              ; %B34
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
LBB684_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB684_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB684_10
LBB684_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB684_15
LBB684_14:                              ; %B11
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB684_15:                              ; %B13
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
	b.ne	LBB684_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB684_22
LBB684_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB684_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB684_23
LBB684_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB684_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB684_25
LBB684_21:                              ; %B21
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB684_22:                              ; %B14
	mov	x8, x20
	add	x20, x20, #16
	mov	w0, #1                          ; =0x1
	stp	x22, x21, [x8]
	b	_FastStringEqual_asm_h
LBB684_23:                              ; %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB684_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB684_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB684_14
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB684_27:                              ; %B37
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_and_2_asm_h            ; -- Begin function and_2_asm_h
	.globl	_and_2_asm_h
	.p2align	2
_and_2_asm_h:                           ; @and_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB685_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB685_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB685_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB685_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	and	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB685_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB685_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB685_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB685_9
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
LBB685_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        ; =0xad
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB685_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB685_11:                              ; %B26
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_xor_2_asm_h            ; -- Begin function xor_2_asm_h
	.globl	_xor_2_asm_h
	.p2align	2
_xor_2_asm_h:                           ; @xor_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB686_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB686_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB686_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB686_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	eor	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB686_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB686_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB686_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB686_9
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
LBB686_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        ; =0xae
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB686_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB686_11:                              ; %B26
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_or_2_asm_h             ; -- Begin function or_2_asm_h
	.globl	_or_2_asm_h
	.p2align	2
_or_2_asm_h:                            ; @or_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB687_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB687_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB687_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB687_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	orr	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB687_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB687_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB687_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB687_9
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
LBB687_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        ; =0xaf
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB687_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB687_11:                              ; %B26
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_nop_2_asm_h            ; -- Begin function nop_2_asm_h
	.globl	_nop_2_asm_h
	.p2align	2
_nop_2_asm_h:                           ; @nop_2_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_minus1_2_asm_h    ; -- Begin function push_minus1_2_asm_h
	.globl	_push_minus1_2_asm_h
	.p2align	2
_push_minus1_2_asm_h:                   ; @push_minus1_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562945658454017          ; =0xfffe0000ffffffff
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_0_2_asm_h         ; -- Begin function push_0_2_asm_h
	.globl	_push_0_2_asm_h
	.p2align	2
_push_0_2_asm_h:                        ; @push_0_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421312          ; =0xfffe000000000000
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_1_2_asm_h         ; -- Begin function push_1_2_asm_h
	.globl	_push_1_2_asm_h
	.p2align	2
_push_1_2_asm_h:                        ; @push_1_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421311          ; =0xfffe000000000001
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_2_2_asm_h         ; -- Begin function push_2_2_asm_h
	.globl	_push_2_2_asm_h
	.p2align	2
_push_2_2_asm_h:                        ; @push_2_2_asm_h
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
	.private_extern	_push_3_2_asm_h         ; -- Begin function push_3_2_asm_h
	.globl	_push_3_2_asm_h
	.p2align	2
_push_3_2_asm_h:                        ; @push_3_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421309          ; =0xfffe000000000003
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_4_2_asm_h         ; -- Begin function push_4_2_asm_h
	.globl	_push_4_2_asm_h
	.p2align	2
_push_4_2_asm_h:                        ; @push_4_2_asm_h
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
	.private_extern	_push_5_2_asm_h         ; -- Begin function push_5_2_asm_h
	.globl	_push_5_2_asm_h
	.p2align	2
_push_5_2_asm_h:                        ; @push_5_2_asm_h
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
	.private_extern	_push_6_2_asm_h         ; -- Begin function push_6_2_asm_h
	.globl	_push_6_2_asm_h
	.p2align	2
_push_6_2_asm_h:                        ; @push_6_2_asm_h
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
	.private_extern	_push_7_2_asm_h         ; -- Begin function push_7_2_asm_h
	.globl	_push_7_2_asm_h
	.p2align	2
_push_7_2_asm_h:                        ; @push_7_2_asm_h
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421305          ; =0xfffe000000000007
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_push_i8_2_asm_h        ; -- Begin function push_i8_2_asm_h
	.globl	_push_i8_2_asm_h
	.p2align	2
_push_i8_2_asm_h:                       ; @push_i8_2_asm_h
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
	.private_extern	_push_i16_2_asm_h       ; -- Begin function push_i16_2_asm_h
	.globl	_push_i16_2_asm_h
	.p2align	2
_push_i16_2_asm_h:                      ; @push_i16_2_asm_h
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
	.private_extern	_push_const8_2_asm_h    ; -- Begin function push_const8_2_asm_h
	.globl	_push_const8_2_asm_h
	.p2align	2
_push_const8_2_asm_h:                   ; @push_const8_2_asm_h
; %bb.0:                                ; %B3
	sub	sp, sp, #16
	str	x22, [x20], #8
	ldr	x8, [x23, #112]
	ldrb	w9, [x19]
	ldr	w10, [x24, #336]
	ldr	x1, [x8, x9, lsl #3]
	cbz	w10, LBB700_2
; %bb.1:                                ; %B4
	mov	x8, x20
	mov	x0, x24
	mov	x2, x19
	str	x21, [x8], #8
	str	x8, [x23, #48]
	str	x1, [sp, #8]                    ; 8-byte Folded Spill
	bl	_DebuggerPause
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
LBB700_2:                               ; %B1
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x2
                                        ; -- End function
	.private_extern	_fclosure8_2_asm_h      ; -- Begin function fclosure8_2_asm_h
	.globl	_fclosure8_2_asm_h
	.p2align	2
_fclosure8_2_asm_h:                     ; @fclosure8_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_fclosure8_0_asm_h
                                        ; -- End function
	.private_extern	_push_empty_string_2_asm_h ; -- Begin function push_empty_string_2_asm_h
	.globl	_push_empty_string_2_asm_h
	.p2align	2
_push_empty_string_2_asm_h:             ; @push_empty_string_2_asm_h
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
	b.eq	LBB702_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB702_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_get_loc8_2_asm_h       ; -- Begin function get_loc8_2_asm_h
	.globl	_get_loc8_2_asm_h
	.p2align	2
_get_loc8_2_asm_h:                      ; @get_loc8_2_asm_h
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
	.private_extern	_put_loc8_2_asm_h       ; -- Begin function put_loc8_2_asm_h
	.globl	_put_loc8_2_asm_h
	.p2align	2
_put_loc8_2_asm_h:                      ; @put_loc8_2_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc8_2_asm_h       ; -- Begin function set_loc8_2_asm_h
	.globl	_set_loc8_2_asm_h
	.p2align	2
_set_loc8_2_asm_h:                      ; @set_loc8_2_asm_h
; %bb.0:                                ; %B0
	ldrb	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_loc0_2_asm_h       ; -- Begin function get_loc0_2_asm_h
	.globl	_get_loc0_2_asm_h
	.p2align	2
_get_loc0_2_asm_h:                      ; @get_loc0_2_asm_h
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
	.private_extern	_get_loc1_2_asm_h       ; -- Begin function get_loc1_2_asm_h
	.globl	_get_loc1_2_asm_h
	.p2align	2
_get_loc1_2_asm_h:                      ; @get_loc1_2_asm_h
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
	.private_extern	_get_loc2_2_asm_h       ; -- Begin function get_loc2_2_asm_h
	.globl	_get_loc2_2_asm_h
	.p2align	2
_get_loc2_2_asm_h:                      ; @get_loc2_2_asm_h
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
	.private_extern	_get_loc3_2_asm_h       ; -- Begin function get_loc3_2_asm_h
	.globl	_get_loc3_2_asm_h
	.p2align	2
_get_loc3_2_asm_h:                      ; @get_loc3_2_asm_h
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
	.private_extern	_put_loc0_2_asm_h       ; -- Begin function put_loc0_2_asm_h
	.globl	_put_loc0_2_asm_h
	.p2align	2
_put_loc0_2_asm_h:                      ; @put_loc0_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x27]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_loc1_2_asm_h       ; -- Begin function put_loc1_2_asm_h
	.globl	_put_loc1_2_asm_h
	.p2align	2
_put_loc1_2_asm_h:                      ; @put_loc1_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x27, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_loc2_2_asm_h       ; -- Begin function put_loc2_2_asm_h
	.globl	_put_loc2_2_asm_h
	.p2align	2
_put_loc2_2_asm_h:                      ; @put_loc2_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x27, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_loc3_2_asm_h       ; -- Begin function put_loc3_2_asm_h
	.globl	_put_loc3_2_asm_h
	.p2align	2
_put_loc3_2_asm_h:                      ; @put_loc3_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x27, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc0_2_asm_h       ; -- Begin function set_loc0_2_asm_h
	.globl	_set_loc0_2_asm_h
	.p2align	2
_set_loc0_2_asm_h:                      ; @set_loc0_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x27]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc1_2_asm_h       ; -- Begin function set_loc1_2_asm_h
	.globl	_set_loc1_2_asm_h
	.p2align	2
_set_loc1_2_asm_h:                      ; @set_loc1_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x27, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc2_2_asm_h       ; -- Begin function set_loc2_2_asm_h
	.globl	_set_loc2_2_asm_h
	.p2align	2
_set_loc2_2_asm_h:                      ; @set_loc2_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x27, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_loc3_2_asm_h       ; -- Begin function set_loc3_2_asm_h
	.globl	_set_loc3_2_asm_h
	.p2align	2
_set_loc3_2_asm_h:                      ; @set_loc3_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x27, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_arg0_2_asm_h       ; -- Begin function get_arg0_2_asm_h
	.globl	_get_arg0_2_asm_h
	.p2align	2
_get_arg0_2_asm_h:                      ; @get_arg0_2_asm_h
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
	.private_extern	_get_arg1_2_asm_h       ; -- Begin function get_arg1_2_asm_h
	.globl	_get_arg1_2_asm_h
	.p2align	2
_get_arg1_2_asm_h:                      ; @get_arg1_2_asm_h
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
	.private_extern	_get_arg2_2_asm_h       ; -- Begin function get_arg2_2_asm_h
	.globl	_get_arg2_2_asm_h
	.p2align	2
_get_arg2_2_asm_h:                      ; @get_arg2_2_asm_h
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
	.private_extern	_get_arg3_2_asm_h       ; -- Begin function get_arg3_2_asm_h
	.globl	_get_arg3_2_asm_h
	.p2align	2
_get_arg3_2_asm_h:                      ; @get_arg3_2_asm_h
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
	.private_extern	_put_arg0_2_asm_h       ; -- Begin function put_arg0_2_asm_h
	.globl	_put_arg0_2_asm_h
	.p2align	2
_put_arg0_2_asm_h:                      ; @put_arg0_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x28]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_arg1_2_asm_h       ; -- Begin function put_arg1_2_asm_h
	.globl	_put_arg1_2_asm_h
	.p2align	2
_put_arg1_2_asm_h:                      ; @put_arg1_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x28, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_arg2_2_asm_h       ; -- Begin function put_arg2_2_asm_h
	.globl	_put_arg2_2_asm_h
	.p2align	2
_put_arg2_2_asm_h:                      ; @put_arg2_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x28, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_arg3_2_asm_h       ; -- Begin function put_arg3_2_asm_h
	.globl	_put_arg3_2_asm_h
	.p2align	2
_put_arg3_2_asm_h:                      ; @put_arg3_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x28, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_arg0_2_asm_h       ; -- Begin function set_arg0_2_asm_h
	.globl	_set_arg0_2_asm_h
	.p2align	2
_set_arg0_2_asm_h:                      ; @set_arg0_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x28]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_arg1_2_asm_h       ; -- Begin function set_arg1_2_asm_h
	.globl	_set_arg1_2_asm_h
	.p2align	2
_set_arg1_2_asm_h:                      ; @set_arg1_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x28, #8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_arg2_2_asm_h       ; -- Begin function set_arg2_2_asm_h
	.globl	_set_arg2_2_asm_h
	.p2align	2
_set_arg2_2_asm_h:                      ; @set_arg2_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x28, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_arg3_2_asm_h       ; -- Begin function set_arg3_2_asm_h
	.globl	_set_arg3_2_asm_h
	.p2align	2
_set_arg3_2_asm_h:                      ; @set_arg3_2_asm_h
; %bb.0:                                ; %B0
	str	x21, [x28, #24]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_var_ref0_2_asm_h   ; -- Begin function get_var_ref0_2_asm_h
	.globl	_get_var_ref0_2_asm_h
	.p2align	2
_get_var_ref0_2_asm_h:                  ; @get_var_ref0_2_asm_h
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
	.private_extern	_get_var_ref1_2_asm_h   ; -- Begin function get_var_ref1_2_asm_h
	.globl	_get_var_ref1_2_asm_h
	.p2align	2
_get_var_ref1_2_asm_h:                  ; @get_var_ref1_2_asm_h
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
	.private_extern	_get_var_ref2_2_asm_h   ; -- Begin function get_var_ref2_2_asm_h
	.globl	_get_var_ref2_2_asm_h
	.p2align	2
_get_var_ref2_2_asm_h:                  ; @get_var_ref2_2_asm_h
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
	.private_extern	_get_var_ref3_2_asm_h   ; -- Begin function get_var_ref3_2_asm_h
	.globl	_get_var_ref3_2_asm_h
	.p2align	2
_get_var_ref3_2_asm_h:                  ; @get_var_ref3_2_asm_h
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
	.private_extern	_put_var_ref0_2_asm_h   ; -- Begin function put_var_ref0_2_asm_h
	.globl	_put_var_ref0_2_asm_h
	.p2align	2
_put_var_ref0_2_asm_h:                  ; @put_var_ref0_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_var_ref1_2_asm_h   ; -- Begin function put_var_ref1_2_asm_h
	.globl	_put_var_ref1_2_asm_h
	.p2align	2
_put_var_ref1_2_asm_h:                  ; @put_var_ref1_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_var_ref2_2_asm_h   ; -- Begin function put_var_ref2_2_asm_h
	.globl	_put_var_ref2_2_asm_h
	.p2align	2
_put_var_ref2_2_asm_h:                  ; @put_var_ref2_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_put_var_ref3_2_asm_h   ; -- Begin function put_var_ref3_2_asm_h
	.globl	_put_var_ref3_2_asm_h
	.p2align	2
_put_var_ref3_2_asm_h:                  ; @put_var_ref3_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_var_ref0_2_asm_h   ; -- Begin function set_var_ref0_2_asm_h
	.globl	_set_var_ref0_2_asm_h
	.p2align	2
_set_var_ref0_2_asm_h:                  ; @set_var_ref0_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_var_ref1_2_asm_h   ; -- Begin function set_var_ref1_2_asm_h
	.globl	_set_var_ref1_2_asm_h
	.p2align	2
_set_var_ref1_2_asm_h:                  ; @set_var_ref1_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #8]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_var_ref2_2_asm_h   ; -- Begin function set_var_ref2_2_asm_h
	.globl	_set_var_ref2_2_asm_h
	.p2align	2
_set_var_ref2_2_asm_h:                  ; @set_var_ref2_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #16]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_set_var_ref3_2_asm_h   ; -- Begin function set_var_ref3_2_asm_h
	.globl	_set_var_ref3_2_asm_h
	.p2align	2
_set_var_ref3_2_asm_h:                  ; @set_var_ref3_2_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x26, #24]
	ldr	x8, [x8]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_length_2_asm_h     ; -- Begin function get_length_2_asm_h
	.globl	_get_length_2_asm_h
	.p2align	2
_get_length_2_asm_h:                    ; @get_length_2_asm_h
; %bb.0:                                ; %B27
	mov	x9, #2                          ; =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	LBB742_2
; %bb.1:                                ; %B27
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB742_3
LBB742_2:                               ; %B28
	and	x8, x21, #0xfffffffffffc
	ldrb	w9, [x19], #1
	ldr	w8, [x8, #4]
	mov	x10, #-562949953421312          ; =0xfffe000000000000
	add	w9, w9, #486
	bfxil	x10, x8, #0, #30
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x10
	br	x1
LBB742_3:                               ; %B21
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	LBB742_13
; %bb.4:                                ; %B22
	mov	x9, x21
	mov	w8, #18                         ; =0x12
LBB742_5:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB742_6 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w11, #0x30
	ldr	w10, [x13, w10, uxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB742_8
LBB742_6:                               ; %B1
                                        ;   Parent Loop BB742_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, #48
	b.eq	LBB742_10
; %bb.7:                                ; %B9
                                        ;   in Loop: Header=BB742_6 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB742_6
LBB742_8:                               ; %B14
                                        ;   in Loop: Header=BB742_5 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB742_13
; %bb.9:                                ; %B17
                                        ;   in Loop: Header=BB742_5 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB742_5
	b	LBB742_12
LBB742_10:                              ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB742_13
; %bb.11:                               ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB742_12:                              ; %B6
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB742_13:                              ; %B24
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
	b.eq	LBB742_15
; %bb.14:                               ; %B26
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB742_15:                              ; %B25
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_if_false8_2_asm_h      ; -- Begin function if_false8_2_asm_h
	.globl	_if_false8_2_asm_h
	.p2align	2
_if_false8_2_asm_h:                     ; @if_false8_2_asm_h
; %bb.0:                                ; %B23
	cmp	x21, #5
	b.le	LBB743_4
; %bb.1:                                ; %B23
	cmp	x21, #6
	b.eq	LBB743_6
; %bb.2:                                ; %B23
	cmp	x21, #7
	b.eq	LBB743_9
; %bb.3:                                ; %B23
	cmp	x21, #18
	b.eq	LBB743_6
	b	LBB743_7
LBB743_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB743_6
; %bb.5:                                ; %B23
	cmp	x21, #2
	b.ne	LBB743_7
LBB743_6:                               ; %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB743_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x21, x8
	b.hs	LBB743_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB743_10
LBB743_9:                               ; %B19
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB743_10:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB743_13
; %bb.11:                               ; %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB743_6
	b.vs	LBB743_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB743_9
	b	LBB743_6
LBB743_13:                              ; %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	_SlowToBoolean_asm_h
                                        ; -- End function
	.private_extern	_if_true8_2_asm_h       ; -- Begin function if_true8_2_asm_h
	.globl	_if_true8_2_asm_h
	.p2align	2
_if_true8_2_asm_h:                      ; @if_true8_2_asm_h
; %bb.0:                                ; %B23
	cmp	x21, #5
	b.le	LBB744_4
; %bb.1:                                ; %B23
	cmp	x21, #6
	b.eq	LBB744_6
; %bb.2:                                ; %B23
	cmp	x21, #7
	b.eq	LBB744_9
; %bb.3:                                ; %B23
	cmp	x21, #18
	b.eq	LBB744_6
	b	LBB744_7
LBB744_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB744_6
; %bb.5:                                ; %B23
	cmp	x21, #2
	b.ne	LBB744_7
LBB744_6:                               ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB744_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x21, x8
	b.hs	LBB744_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB744_10
LBB744_9:                               ; %B19
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB744_10:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB744_13
; %bb.11:                               ; %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB744_6
	b.vs	LBB744_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB744_9
	b	LBB744_6
LBB744_13:                              ; %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	_SlowToBoolean_asm_h
                                        ; -- End function
	.private_extern	_goto8_2_asm_h          ; -- Begin function goto8_2_asm_h
	.globl	_goto8_2_asm_h
	.p2align	2
_goto8_2_asm_h:                         ; @goto8_2_asm_h
; %bb.0:                                ; %B0
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_goto16_2_asm_h         ; -- Begin function goto16_2_asm_h
	.globl	_goto16_2_asm_h
	.p2align	2
_goto16_2_asm_h:                        ; @goto16_2_asm_h
; %bb.0:                                ; %B0
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_call0_2_asm_h          ; -- Begin function call0_2_asm_h
	.globl	_call0_2_asm_h
	.p2align	2
_call0_2_asm_h:                         ; @call0_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_call0_0_asm_h
                                        ; -- End function
	.private_extern	_call1_2_asm_h          ; -- Begin function call1_2_asm_h
	.globl	_call1_2_asm_h
	.p2align	2
_call1_2_asm_h:                         ; @call1_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_call1_0_asm_h
                                        ; -- End function
	.private_extern	_call2_2_asm_h          ; -- Begin function call2_2_asm_h
	.globl	_call2_2_asm_h
	.p2align	2
_call2_2_asm_h:                         ; @call2_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_call2_0_asm_h
                                        ; -- End function
	.private_extern	_call3_2_asm_h          ; -- Begin function call3_2_asm_h
	.globl	_call3_2_asm_h
	.p2align	2
_call3_2_asm_h:                         ; @call3_2_asm_h
; %bb.0:                                ; %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	_call3_0_asm_h
                                        ; -- End function
	.private_extern	_is_undefined_2_asm_h   ; -- Begin function is_undefined_2_asm_h
	.globl	_is_undefined_2_asm_h
	.p2align	2
_is_undefined_2_asm_h:                  ; @is_undefined_2_asm_h
; %bb.0:                                ; %B2
	cmp	x21, #18
	b.ne	LBB751_2
; %bb.1:                                ; %B3
	mov	w21, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB751_2:                               ; %B5
	mov	w21, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_is_null_2_asm_h        ; -- Begin function is_null_2_asm_h
	.globl	_is_null_2_asm_h
	.p2align	2
_is_null_2_asm_h:                       ; @is_null_2_asm_h
; %bb.0:                                ; %B2
	cmp	x21, #2
	b.ne	LBB752_2
; %bb.1:                                ; %B3
	mov	w21, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB752_2:                               ; %B5
	mov	w21, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_is_function_2_asm_h    ; -- Begin function is_function_2_asm_h
	.globl	_is_function_2_asm_h
	.p2align	2
_is_function_2_asm_h:                   ; @is_function_2_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x21
	bl	_js_operator_typeof_gc
	cmp	w0, #27
	b.ne	LBB753_2
; %bb.1:                                ; %B2
	mov	w21, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB753_2:                               ; %B5
	mov	w21, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_inc_coverage_2_asm_h   ; -- Begin function inc_coverage_2_asm_h
	.globl	_inc_coverage_2_asm_h
	.p2align	2
_inc_coverage_2_asm_h:                  ; @inc_coverage_2_asm_h
; %bb.0:                                ; %B10
	ldr	x8, [x23, #8]
	ldr	x1, [x8, #32]
	ldr	x8, [x1, #112]
	cbz	x8, LBB754_3
; %bb.1:                                ; %B7
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbnz	x8, LBB754_4
LBB754_2:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB754_3:                               ; %B11
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_EnsureCoverageCounters
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbz	x8, LBB754_2
LBB754_4:                               ; %B2
	ldr	w9, [x19]
	ldr	w10, [x10, #104]
	cmp	w9, w10
	b.hs	LBB754_2
; %bb.5:                                ; %B6
	ldr	w10, [x8, w9, sxtw #2]
	add	w10, w10, #1
	str	w10, [x8, w9, sxtw #2]
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
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
	bl	_common_call_from_entry_asm_h
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
	.asciz	"derived class constructor must return an object or undefined"

	.p2align	3, 0x0                          ; @12
l___unnamed_13:
	.asciz	"class constructors must be invoked with 'new'"

	.p2align	3, 0x0                          ; @13
l___unnamed_14:
	.asciz	"invalid ret value"

	.p2align	3, 0x0                          ; @14
l___unnamed_15:
	.asciz	"value has no property"

	.p2align	3, 0x0                          ; @15
l___unnamed_16:
	.asciz	"invalid opcode: pc=%u opcode=0x%02x"

	.p2align	3, 0x0                          ; @16
l___unnamed_17:
	.asciz	"derived class constructor must return an object or undefined"

	.p2align	3, 0x0                          ; @17
l___unnamed_18:
	.asciz	"class constructors must be invoked with 'new'"

	.p2align	3, 0x0                          ; @18
l___unnamed_19:
	.asciz	"invalid ret value"

	.p2align	3, 0x0                          ; @19
l___unnamed_20:
	.asciz	"value has no property"

	.private_extern	_primjs_dispatch_table  ; @primjs_dispatch_table
	.section	__DATA,__const
	.globl	_primjs_dispatch_table
	.p2align	3, 0x0
_primjs_dispatch_table:
	.quad	_invalid_0_asm_h
	.quad	_push_i32_0_asm_h
	.quad	_push_const_0_asm_h
	.quad	_fclosure_0_asm_h
	.quad	_push_atom_value_0_asm_h
	.quad	_private_symbol_0_asm_h
	.quad	_undefined_0_asm_h
	.quad	_null_0_asm_h
	.quad	_push_this_0_asm_h
	.quad	_push_false_0_asm_h
	.quad	_push_true_0_asm_h
	.quad	_object_0_asm_h
	.quad	_special_object_0_asm_h
	.quad	_rest_0_asm_h
	.quad	_drop_0_asm_h
	.quad	_nip_0_asm_h
	.quad	_nip1_0_asm_h
	.quad	_dup_0_asm_h
	.quad	_dup1_0_asm_h
	.quad	_dup2_0_asm_h
	.quad	_dup3_0_asm_h
	.quad	_insert2_0_asm_h
	.quad	_insert3_0_asm_h
	.quad	_insert4_0_asm_h
	.quad	_perm3_0_asm_h
	.quad	_perm4_0_asm_h
	.quad	_perm5_0_asm_h
	.quad	_swap_0_asm_h
	.quad	_swap2_0_asm_h
	.quad	_rot3l_0_asm_h
	.quad	_rot3r_0_asm_h
	.quad	_rot4l_0_asm_h
	.quad	_rot5l_0_asm_h
	.quad	_call_constructor_0_asm_h
	.quad	_call_0_asm_h
	.quad	_tail_call_0_asm_h
	.quad	_call_method_0_asm_h
	.quad	_tail_call_method_0_asm_h
	.quad	_array_from_0_asm_h
	.quad	_apply_0_asm_h
	.quad	_return_0_asm_h
	.quad	_return_undef_0_asm_h
	.quad	_check_ctor_return_0_asm_h
	.quad	_check_ctor_0_asm_h
	.quad	_check_brand_0_asm_h
	.quad	_add_brand_0_asm_h
	.quad	_return_async_0_asm_h
	.quad	_throw_0_asm_h
	.quad	_throw_var_0_asm_h
	.quad	_eval_0_asm_h
	.quad	_regexp_0_asm_h
	.quad	_get_super_ctor_0_asm_h
	.quad	_get_super_0_asm_h
	.quad	_import_0_asm_h
	.quad	_check_var_0_asm_h
	.quad	_get_var_undef_0_asm_h
	.quad	_get_var_0_asm_h
	.quad	_put_var_0_asm_h
	.quad	_put_var_init_0_asm_h
	.quad	_put_var_strict_0_asm_h
	.quad	_get_ref_value_0_asm_h
	.quad	_put_ref_value_0_asm_h
	.quad	_define_var_0_asm_h
	.quad	_check_define_var_0_asm_h
	.quad	_define_func_0_asm_h
	.quad	_get_field_0_asm_h
	.quad	_get_field2_0_asm_h
	.quad	_put_field_0_asm_h
	.quad	_get_private_field_0_asm_h
	.quad	_put_private_field_0_asm_h
	.quad	_define_private_field_0_asm_h
	.quad	_get_array_el_0_asm_h
	.quad	_get_array_el2_0_asm_h
	.quad	_put_array_el_0_asm_h
	.quad	_get_super_value_0_asm_h
	.quad	_put_super_value_0_asm_h
	.quad	_define_field_0_asm_h
	.quad	_set_name_0_asm_h
	.quad	_set_name_computed_0_asm_h
	.quad	_set_proto_0_asm_h
	.quad	_set_home_object_0_asm_h
	.quad	_define_array_el_0_asm_h
	.quad	_append_0_asm_h
	.quad	_copy_data_properties_0_asm_h
	.quad	_define_method_0_asm_h
	.quad	_define_method_computed_0_asm_h
	.quad	_define_class_0_asm_h
	.quad	_get_loc_0_asm_h
	.quad	_put_loc_0_asm_h
	.quad	_set_loc_0_asm_h
	.quad	_get_arg_0_asm_h
	.quad	_put_arg_0_asm_h
	.quad	_set_arg_0_asm_h
	.quad	_get_var_ref_0_asm_h
	.quad	_put_var_ref_0_asm_h
	.quad	_set_var_ref_0_asm_h
	.quad	_set_loc_uninitialized_0_asm_h
	.quad	_get_loc_check_0_asm_h
	.quad	_put_loc_check_0_asm_h
	.quad	_put_loc_check_init_0_asm_h
	.quad	_get_var_ref_check_0_asm_h
	.quad	_put_var_ref_check_0_asm_h
	.quad	_put_var_ref_check_init_0_asm_h
	.quad	_close_loc_0_asm_h
	.quad	_if_false_0_asm_h
	.quad	_if_true_0_asm_h
	.quad	_goto_0_asm_h
	.quad	_catch_0_asm_h
	.quad	_gosub_0_asm_h
	.quad	_ret_0_asm_h
	.quad	_to_object_0_asm_h
	.quad	_to_propkey_0_asm_h
	.quad	_to_propkey2_0_asm_h
	.quad	_with_get_var_0_asm_h
	.quad	_with_put_var_0_asm_h
	.quad	_with_delete_var_0_asm_h
	.quad	_with_make_ref_0_asm_h
	.quad	_with_get_ref_0_asm_h
	.quad	_with_get_ref_undef_0_asm_h
	.quad	_make_loc_ref_0_asm_h
	.quad	_make_arg_ref_0_asm_h
	.quad	_make_var_ref_ref_0_asm_h
	.quad	_make_var_ref_0_asm_h
	.quad	_for_in_start_0_asm_h
	.quad	_for_of_start_0_asm_h
	.quad	_for_await_of_start_0_asm_h
	.quad	_for_in_next_0_asm_h
	.quad	_for_of_next_0_asm_h
	.quad	_for_await_of_next_0_asm_h
	.quad	_iterator_get_value_done_0_asm_h
	.quad	_iterator_close_0_asm_h
	.quad	_iterator_close_return_0_asm_h
	.quad	_async_iterator_close_0_asm_h
	.quad	_async_iterator_next_0_asm_h
	.quad	_async_iterator_get_0_asm_h
	.quad	_initial_yield_0_asm_h
	.quad	_yield_0_asm_h
	.quad	_yield_star_0_asm_h
	.quad	_async_yield_star_0_asm_h
	.quad	_await_0_asm_h
	.quad	_neg_0_asm_h
	.quad	_plus_0_asm_h
	.quad	_dec_0_asm_h
	.quad	_inc_0_asm_h
	.quad	_post_dec_0_asm_h
	.quad	_post_inc_0_asm_h
	.quad	_dec_loc_0_asm_h
	.quad	_inc_loc_0_asm_h
	.quad	_add_loc_0_asm_h
	.quad	_not_0_asm_h
	.quad	_lnot_0_asm_h
	.quad	_typeof_0_asm_h
	.quad	_delete_0_asm_h
	.quad	_delete_var_0_asm_h
	.quad	_mul_0_asm_h
	.quad	_div_0_asm_h
	.quad	_mod_0_asm_h
	.quad	_add_0_asm_h
	.quad	_sub_0_asm_h
	.quad	_pow_0_asm_h
	.quad	_shl_0_asm_h
	.quad	_sar_0_asm_h
	.quad	_shr_0_asm_h
	.quad	_lt_0_asm_h
	.quad	_lte_0_asm_h
	.quad	_gt_0_asm_h
	.quad	_gte_0_asm_h
	.quad	_instanceof_0_asm_h
	.quad	_in_0_asm_h
	.quad	_eq_0_asm_h
	.quad	_neq_0_asm_h
	.quad	_strict_eq_0_asm_h
	.quad	_strict_neq_0_asm_h
	.quad	_and_0_asm_h
	.quad	_xor_0_asm_h
	.quad	_or_0_asm_h
	.quad	_nop_0_asm_h
	.quad	_push_minus1_0_asm_h
	.quad	_push_0_0_asm_h
	.quad	_push_1_0_asm_h
	.quad	_push_2_0_asm_h
	.quad	_push_3_0_asm_h
	.quad	_push_4_0_asm_h
	.quad	_push_5_0_asm_h
	.quad	_push_6_0_asm_h
	.quad	_push_7_0_asm_h
	.quad	_push_i8_0_asm_h
	.quad	_push_i16_0_asm_h
	.quad	_push_const8_0_asm_h
	.quad	_fclosure8_0_asm_h
	.quad	_push_empty_string_0_asm_h
	.quad	_get_loc8_0_asm_h
	.quad	_put_loc8_0_asm_h
	.quad	_set_loc8_0_asm_h
	.quad	_get_loc0_0_asm_h
	.quad	_get_loc1_0_asm_h
	.quad	_get_loc2_0_asm_h
	.quad	_get_loc3_0_asm_h
	.quad	_put_loc0_0_asm_h
	.quad	_put_loc1_0_asm_h
	.quad	_put_loc2_0_asm_h
	.quad	_put_loc3_0_asm_h
	.quad	_set_loc0_0_asm_h
	.quad	_set_loc1_0_asm_h
	.quad	_set_loc2_0_asm_h
	.quad	_set_loc3_0_asm_h
	.quad	_get_arg0_0_asm_h
	.quad	_get_arg1_0_asm_h
	.quad	_get_arg2_0_asm_h
	.quad	_get_arg3_0_asm_h
	.quad	_put_arg0_0_asm_h
	.quad	_put_arg1_0_asm_h
	.quad	_put_arg2_0_asm_h
	.quad	_put_arg3_0_asm_h
	.quad	_set_arg0_0_asm_h
	.quad	_set_arg1_0_asm_h
	.quad	_set_arg2_0_asm_h
	.quad	_set_arg3_0_asm_h
	.quad	_get_var_ref0_0_asm_h
	.quad	_get_var_ref1_0_asm_h
	.quad	_get_var_ref2_0_asm_h
	.quad	_get_var_ref3_0_asm_h
	.quad	_put_var_ref0_0_asm_h
	.quad	_put_var_ref1_0_asm_h
	.quad	_put_var_ref2_0_asm_h
	.quad	_put_var_ref3_0_asm_h
	.quad	_set_var_ref0_0_asm_h
	.quad	_set_var_ref1_0_asm_h
	.quad	_set_var_ref2_0_asm_h
	.quad	_set_var_ref3_0_asm_h
	.quad	_get_length_0_asm_h
	.quad	_if_false8_0_asm_h
	.quad	_if_true8_0_asm_h
	.quad	_goto8_0_asm_h
	.quad	_goto16_0_asm_h
	.quad	_call0_0_asm_h
	.quad	_call1_0_asm_h
	.quad	_call2_0_asm_h
	.quad	_call3_0_asm_h
	.quad	_is_undefined_0_asm_h
	.quad	_is_null_0_asm_h
	.quad	_is_function_0_asm_h
	.quad	_inc_coverage_0_asm_h
	.quad	_invalid_1_asm_h
	.quad	_push_i32_1_asm_h
	.quad	_push_const_1_asm_h
	.quad	_fclosure_1_asm_h
	.quad	_push_atom_value_1_asm_h
	.quad	_private_symbol_1_asm_h
	.quad	_undefined_1_asm_h
	.quad	_null_1_asm_h
	.quad	_push_this_1_asm_h
	.quad	_push_false_1_asm_h
	.quad	_push_true_1_asm_h
	.quad	_object_1_asm_h
	.quad	_special_object_1_asm_h
	.quad	_rest_1_asm_h
	.quad	_drop_1_asm_h
	.quad	_nip_1_asm_h
	.quad	_nip1_1_asm_h
	.quad	_dup_1_asm_h
	.quad	_dup1_1_asm_h
	.quad	_dup2_1_asm_h
	.quad	_dup3_1_asm_h
	.quad	_insert2_1_asm_h
	.quad	_insert3_1_asm_h
	.quad	_insert4_1_asm_h
	.quad	_perm3_1_asm_h
	.quad	_perm4_1_asm_h
	.quad	_perm5_1_asm_h
	.quad	_swap_1_asm_h
	.quad	_swap2_1_asm_h
	.quad	_rot3l_1_asm_h
	.quad	_rot3r_1_asm_h
	.quad	_rot4l_1_asm_h
	.quad	_rot5l_1_asm_h
	.quad	_call_constructor_1_asm_h
	.quad	_call_1_asm_h
	.quad	_tail_call_1_asm_h
	.quad	_call_method_1_asm_h
	.quad	_tail_call_method_1_asm_h
	.quad	_array_from_1_asm_h
	.quad	_apply_1_asm_h
	.quad	_return_1_asm_h
	.quad	_return_undef_1_asm_h
	.quad	_check_ctor_return_1_asm_h
	.quad	_check_ctor_1_asm_h
	.quad	_check_brand_1_asm_h
	.quad	_add_brand_1_asm_h
	.quad	_return_async_1_asm_h
	.quad	_throw_1_asm_h
	.quad	_throw_var_1_asm_h
	.quad	_eval_1_asm_h
	.quad	_regexp_1_asm_h
	.quad	_get_super_ctor_1_asm_h
	.quad	_get_super_1_asm_h
	.quad	_import_1_asm_h
	.quad	_check_var_1_asm_h
	.quad	_get_var_undef_1_asm_h
	.quad	_get_var_1_asm_h
	.quad	_put_var_1_asm_h
	.quad	_put_var_init_1_asm_h
	.quad	_put_var_strict_1_asm_h
	.quad	_get_ref_value_1_asm_h
	.quad	_put_ref_value_1_asm_h
	.quad	_define_var_1_asm_h
	.quad	_check_define_var_1_asm_h
	.quad	_define_func_1_asm_h
	.quad	_get_field_1_asm_h
	.quad	_get_field2_1_asm_h
	.quad	_put_field_1_asm_h
	.quad	_get_private_field_1_asm_h
	.quad	_put_private_field_1_asm_h
	.quad	_define_private_field_1_asm_h
	.quad	_get_array_el_1_asm_h
	.quad	_get_array_el2_1_asm_h
	.quad	_put_array_el_1_asm_h
	.quad	_get_super_value_1_asm_h
	.quad	_put_super_value_1_asm_h
	.quad	_define_field_1_asm_h
	.quad	_set_name_1_asm_h
	.quad	_set_name_computed_1_asm_h
	.quad	_set_proto_1_asm_h
	.quad	_set_home_object_1_asm_h
	.quad	_define_array_el_1_asm_h
	.quad	_append_1_asm_h
	.quad	_copy_data_properties_1_asm_h
	.quad	_define_method_1_asm_h
	.quad	_define_method_computed_1_asm_h
	.quad	_define_class_1_asm_h
	.quad	_get_loc_1_asm_h
	.quad	_put_loc_1_asm_h
	.quad	_set_loc_1_asm_h
	.quad	_get_arg_1_asm_h
	.quad	_put_arg_1_asm_h
	.quad	_set_arg_1_asm_h
	.quad	_get_var_ref_1_asm_h
	.quad	_put_var_ref_1_asm_h
	.quad	_set_var_ref_1_asm_h
	.quad	_set_loc_uninitialized_1_asm_h
	.quad	_get_loc_check_1_asm_h
	.quad	_put_loc_check_1_asm_h
	.quad	_put_loc_check_init_1_asm_h
	.quad	_get_var_ref_check_1_asm_h
	.quad	_put_var_ref_check_1_asm_h
	.quad	_put_var_ref_check_init_1_asm_h
	.quad	_close_loc_1_asm_h
	.quad	_if_false_1_asm_h
	.quad	_if_true_1_asm_h
	.quad	_goto_1_asm_h
	.quad	_catch_1_asm_h
	.quad	_gosub_1_asm_h
	.quad	_ret_1_asm_h
	.quad	_to_object_1_asm_h
	.quad	_to_propkey_1_asm_h
	.quad	_to_propkey2_1_asm_h
	.quad	_with_get_var_1_asm_h
	.quad	_with_put_var_1_asm_h
	.quad	_with_delete_var_1_asm_h
	.quad	_with_make_ref_1_asm_h
	.quad	_with_get_ref_1_asm_h
	.quad	_with_get_ref_undef_1_asm_h
	.quad	_make_loc_ref_1_asm_h
	.quad	_make_arg_ref_1_asm_h
	.quad	_make_var_ref_ref_1_asm_h
	.quad	_make_var_ref_1_asm_h
	.quad	_for_in_start_1_asm_h
	.quad	_for_of_start_1_asm_h
	.quad	_for_await_of_start_1_asm_h
	.quad	_for_in_next_1_asm_h
	.quad	_for_of_next_1_asm_h
	.quad	_for_await_of_next_1_asm_h
	.quad	_iterator_get_value_done_1_asm_h
	.quad	_iterator_close_1_asm_h
	.quad	_iterator_close_return_1_asm_h
	.quad	_async_iterator_close_1_asm_h
	.quad	_async_iterator_next_1_asm_h
	.quad	_async_iterator_get_1_asm_h
	.quad	_initial_yield_1_asm_h
	.quad	_yield_1_asm_h
	.quad	_yield_star_1_asm_h
	.quad	_async_yield_star_1_asm_h
	.quad	_await_1_asm_h
	.quad	_neg_1_asm_h
	.quad	_plus_1_asm_h
	.quad	_dec_1_asm_h
	.quad	_inc_1_asm_h
	.quad	_post_dec_1_asm_h
	.quad	_post_inc_1_asm_h
	.quad	_dec_loc_1_asm_h
	.quad	_inc_loc_1_asm_h
	.quad	_add_loc_1_asm_h
	.quad	_not_1_asm_h
	.quad	_lnot_1_asm_h
	.quad	_typeof_1_asm_h
	.quad	_delete_1_asm_h
	.quad	_delete_var_1_asm_h
	.quad	_mul_1_asm_h
	.quad	_div_1_asm_h
	.quad	_mod_1_asm_h
	.quad	_add_1_asm_h
	.quad	_sub_1_asm_h
	.quad	_pow_1_asm_h
	.quad	_shl_1_asm_h
	.quad	_sar_1_asm_h
	.quad	_shr_1_asm_h
	.quad	_lt_1_asm_h
	.quad	_lte_1_asm_h
	.quad	_gt_1_asm_h
	.quad	_gte_1_asm_h
	.quad	_instanceof_1_asm_h
	.quad	_in_1_asm_h
	.quad	_eq_1_asm_h
	.quad	_neq_1_asm_h
	.quad	_strict_eq_1_asm_h
	.quad	_strict_neq_1_asm_h
	.quad	_and_1_asm_h
	.quad	_xor_1_asm_h
	.quad	_or_1_asm_h
	.quad	_nop_1_asm_h
	.quad	_push_minus1_1_asm_h
	.quad	_push_0_1_asm_h
	.quad	_push_1_1_asm_h
	.quad	_push_2_1_asm_h
	.quad	_push_3_1_asm_h
	.quad	_push_4_1_asm_h
	.quad	_push_5_1_asm_h
	.quad	_push_6_1_asm_h
	.quad	_push_7_1_asm_h
	.quad	_push_i8_1_asm_h
	.quad	_push_i16_1_asm_h
	.quad	_push_const8_1_asm_h
	.quad	_fclosure8_1_asm_h
	.quad	_push_empty_string_1_asm_h
	.quad	_get_loc8_1_asm_h
	.quad	_put_loc8_1_asm_h
	.quad	_set_loc8_1_asm_h
	.quad	_get_loc0_1_asm_h
	.quad	_get_loc1_1_asm_h
	.quad	_get_loc2_1_asm_h
	.quad	_get_loc3_1_asm_h
	.quad	_put_loc0_1_asm_h
	.quad	_put_loc1_1_asm_h
	.quad	_put_loc2_1_asm_h
	.quad	_put_loc3_1_asm_h
	.quad	_set_loc0_1_asm_h
	.quad	_set_loc1_1_asm_h
	.quad	_set_loc2_1_asm_h
	.quad	_set_loc3_1_asm_h
	.quad	_get_arg0_1_asm_h
	.quad	_get_arg1_1_asm_h
	.quad	_get_arg2_1_asm_h
	.quad	_get_arg3_1_asm_h
	.quad	_put_arg0_1_asm_h
	.quad	_put_arg1_1_asm_h
	.quad	_put_arg2_1_asm_h
	.quad	_put_arg3_1_asm_h
	.quad	_set_arg0_1_asm_h
	.quad	_set_arg1_1_asm_h
	.quad	_set_arg2_1_asm_h
	.quad	_set_arg3_1_asm_h
	.quad	_get_var_ref0_1_asm_h
	.quad	_get_var_ref1_1_asm_h
	.quad	_get_var_ref2_1_asm_h
	.quad	_get_var_ref3_1_asm_h
	.quad	_put_var_ref0_1_asm_h
	.quad	_put_var_ref1_1_asm_h
	.quad	_put_var_ref2_1_asm_h
	.quad	_put_var_ref3_1_asm_h
	.quad	_set_var_ref0_1_asm_h
	.quad	_set_var_ref1_1_asm_h
	.quad	_set_var_ref2_1_asm_h
	.quad	_set_var_ref3_1_asm_h
	.quad	_get_length_1_asm_h
	.quad	_if_false8_1_asm_h
	.quad	_if_true8_1_asm_h
	.quad	_goto8_1_asm_h
	.quad	_goto16_1_asm_h
	.quad	_call0_1_asm_h
	.quad	_call1_1_asm_h
	.quad	_call2_1_asm_h
	.quad	_call3_1_asm_h
	.quad	_is_undefined_1_asm_h
	.quad	_is_null_1_asm_h
	.quad	_is_function_1_asm_h
	.quad	_inc_coverage_1_asm_h
	.quad	_invalid_2_asm_h
	.quad	_push_i32_2_asm_h
	.quad	_push_const_2_asm_h
	.quad	_fclosure_2_asm_h
	.quad	_push_atom_value_2_asm_h
	.quad	_private_symbol_2_asm_h
	.quad	_undefined_2_asm_h
	.quad	_null_2_asm_h
	.quad	_push_this_2_asm_h
	.quad	_push_false_2_asm_h
	.quad	_push_true_2_asm_h
	.quad	_object_2_asm_h
	.quad	_special_object_2_asm_h
	.quad	_rest_2_asm_h
	.quad	_drop_2_asm_h
	.quad	_nip_2_asm_h
	.quad	_nip1_2_asm_h
	.quad	_dup_2_asm_h
	.quad	_dup1_2_asm_h
	.quad	_dup2_2_asm_h
	.quad	_dup3_2_asm_h
	.quad	_insert2_2_asm_h
	.quad	_insert3_2_asm_h
	.quad	_insert4_2_asm_h
	.quad	_perm3_2_asm_h
	.quad	_perm4_2_asm_h
	.quad	_perm5_2_asm_h
	.quad	_swap_2_asm_h
	.quad	_swap2_2_asm_h
	.quad	_rot3l_2_asm_h
	.quad	_rot3r_2_asm_h
	.quad	_rot4l_2_asm_h
	.quad	_rot5l_2_asm_h
	.quad	_call_constructor_2_asm_h
	.quad	_call_2_asm_h
	.quad	_tail_call_2_asm_h
	.quad	_call_method_2_asm_h
	.quad	_tail_call_method_2_asm_h
	.quad	_array_from_2_asm_h
	.quad	_apply_2_asm_h
	.quad	_return_2_asm_h
	.quad	_return_undef_2_asm_h
	.quad	_check_ctor_return_2_asm_h
	.quad	_check_ctor_2_asm_h
	.quad	_check_brand_2_asm_h
	.quad	_add_brand_2_asm_h
	.quad	_return_async_2_asm_h
	.quad	_throw_2_asm_h
	.quad	_throw_var_2_asm_h
	.quad	_eval_2_asm_h
	.quad	_regexp_2_asm_h
	.quad	_get_super_ctor_2_asm_h
	.quad	_get_super_2_asm_h
	.quad	_import_2_asm_h
	.quad	_check_var_2_asm_h
	.quad	_get_var_undef_2_asm_h
	.quad	_get_var_2_asm_h
	.quad	_put_var_2_asm_h
	.quad	_put_var_init_2_asm_h
	.quad	_put_var_strict_2_asm_h
	.quad	_get_ref_value_2_asm_h
	.quad	_put_ref_value_2_asm_h
	.quad	_define_var_2_asm_h
	.quad	_check_define_var_2_asm_h
	.quad	_define_func_2_asm_h
	.quad	_get_field_2_asm_h
	.quad	_get_field2_2_asm_h
	.quad	_put_field_2_asm_h
	.quad	_get_private_field_2_asm_h
	.quad	_put_private_field_2_asm_h
	.quad	_define_private_field_2_asm_h
	.quad	_get_array_el_2_asm_h
	.quad	_get_array_el2_2_asm_h
	.quad	_put_array_el_2_asm_h
	.quad	_get_super_value_2_asm_h
	.quad	_put_super_value_2_asm_h
	.quad	_define_field_2_asm_h
	.quad	_set_name_2_asm_h
	.quad	_set_name_computed_2_asm_h
	.quad	_set_proto_2_asm_h
	.quad	_set_home_object_2_asm_h
	.quad	_define_array_el_2_asm_h
	.quad	_append_2_asm_h
	.quad	_copy_data_properties_2_asm_h
	.quad	_define_method_2_asm_h
	.quad	_define_method_computed_2_asm_h
	.quad	_define_class_2_asm_h
	.quad	_get_loc_2_asm_h
	.quad	_put_loc_2_asm_h
	.quad	_set_loc_2_asm_h
	.quad	_get_arg_2_asm_h
	.quad	_put_arg_2_asm_h
	.quad	_set_arg_2_asm_h
	.quad	_get_var_ref_2_asm_h
	.quad	_put_var_ref_2_asm_h
	.quad	_set_var_ref_2_asm_h
	.quad	_set_loc_uninitialized_2_asm_h
	.quad	_get_loc_check_2_asm_h
	.quad	_put_loc_check_2_asm_h
	.quad	_put_loc_check_init_2_asm_h
	.quad	_get_var_ref_check_2_asm_h
	.quad	_put_var_ref_check_2_asm_h
	.quad	_put_var_ref_check_init_2_asm_h
	.quad	_close_loc_2_asm_h
	.quad	_if_false_2_asm_h
	.quad	_if_true_2_asm_h
	.quad	_goto_2_asm_h
	.quad	_catch_2_asm_h
	.quad	_gosub_2_asm_h
	.quad	_ret_2_asm_h
	.quad	_to_object_2_asm_h
	.quad	_to_propkey_2_asm_h
	.quad	_to_propkey2_2_asm_h
	.quad	_with_get_var_2_asm_h
	.quad	_with_put_var_2_asm_h
	.quad	_with_delete_var_2_asm_h
	.quad	_with_make_ref_2_asm_h
	.quad	_with_get_ref_2_asm_h
	.quad	_with_get_ref_undef_2_asm_h
	.quad	_make_loc_ref_2_asm_h
	.quad	_make_arg_ref_2_asm_h
	.quad	_make_var_ref_ref_2_asm_h
	.quad	_make_var_ref_2_asm_h
	.quad	_for_in_start_2_asm_h
	.quad	_for_of_start_2_asm_h
	.quad	_for_await_of_start_2_asm_h
	.quad	_for_in_next_2_asm_h
	.quad	_for_of_next_2_asm_h
	.quad	_for_await_of_next_2_asm_h
	.quad	_iterator_get_value_done_2_asm_h
	.quad	_iterator_close_2_asm_h
	.quad	_iterator_close_return_2_asm_h
	.quad	_async_iterator_close_2_asm_h
	.quad	_async_iterator_next_2_asm_h
	.quad	_async_iterator_get_2_asm_h
	.quad	_initial_yield_2_asm_h
	.quad	_yield_2_asm_h
	.quad	_yield_star_2_asm_h
	.quad	_async_yield_star_2_asm_h
	.quad	_await_2_asm_h
	.quad	_neg_2_asm_h
	.quad	_plus_2_asm_h
	.quad	_dec_2_asm_h
	.quad	_inc_2_asm_h
	.quad	_post_dec_2_asm_h
	.quad	_post_inc_2_asm_h
	.quad	_dec_loc_2_asm_h
	.quad	_inc_loc_2_asm_h
	.quad	_add_loc_2_asm_h
	.quad	_not_2_asm_h
	.quad	_lnot_2_asm_h
	.quad	_typeof_2_asm_h
	.quad	_delete_2_asm_h
	.quad	_delete_var_2_asm_h
	.quad	_mul_2_asm_h
	.quad	_div_2_asm_h
	.quad	_mod_2_asm_h
	.quad	_add_2_asm_h
	.quad	_sub_2_asm_h
	.quad	_pow_2_asm_h
	.quad	_shl_2_asm_h
	.quad	_sar_2_asm_h
	.quad	_shr_2_asm_h
	.quad	_lt_2_asm_h
	.quad	_lte_2_asm_h
	.quad	_gt_2_asm_h
	.quad	_gte_2_asm_h
	.quad	_instanceof_2_asm_h
	.quad	_in_2_asm_h
	.quad	_eq_2_asm_h
	.quad	_neq_2_asm_h
	.quad	_strict_eq_2_asm_h
	.quad	_strict_neq_2_asm_h
	.quad	_and_2_asm_h
	.quad	_xor_2_asm_h
	.quad	_or_2_asm_h
	.quad	_nop_2_asm_h
	.quad	_push_minus1_2_asm_h
	.quad	_push_0_2_asm_h
	.quad	_push_1_2_asm_h
	.quad	_push_2_2_asm_h
	.quad	_push_3_2_asm_h
	.quad	_push_4_2_asm_h
	.quad	_push_5_2_asm_h
	.quad	_push_6_2_asm_h
	.quad	_push_7_2_asm_h
	.quad	_push_i8_2_asm_h
	.quad	_push_i16_2_asm_h
	.quad	_push_const8_2_asm_h
	.quad	_fclosure8_2_asm_h
	.quad	_push_empty_string_2_asm_h
	.quad	_get_loc8_2_asm_h
	.quad	_put_loc8_2_asm_h
	.quad	_set_loc8_2_asm_h
	.quad	_get_loc0_2_asm_h
	.quad	_get_loc1_2_asm_h
	.quad	_get_loc2_2_asm_h
	.quad	_get_loc3_2_asm_h
	.quad	_put_loc0_2_asm_h
	.quad	_put_loc1_2_asm_h
	.quad	_put_loc2_2_asm_h
	.quad	_put_loc3_2_asm_h
	.quad	_set_loc0_2_asm_h
	.quad	_set_loc1_2_asm_h
	.quad	_set_loc2_2_asm_h
	.quad	_set_loc3_2_asm_h
	.quad	_get_arg0_2_asm_h
	.quad	_get_arg1_2_asm_h
	.quad	_get_arg2_2_asm_h
	.quad	_get_arg3_2_asm_h
	.quad	_put_arg0_2_asm_h
	.quad	_put_arg1_2_asm_h
	.quad	_put_arg2_2_asm_h
	.quad	_put_arg3_2_asm_h
	.quad	_set_arg0_2_asm_h
	.quad	_set_arg1_2_asm_h
	.quad	_set_arg2_2_asm_h
	.quad	_set_arg3_2_asm_h
	.quad	_get_var_ref0_2_asm_h
	.quad	_get_var_ref1_2_asm_h
	.quad	_get_var_ref2_2_asm_h
	.quad	_get_var_ref3_2_asm_h
	.quad	_put_var_ref0_2_asm_h
	.quad	_put_var_ref1_2_asm_h
	.quad	_put_var_ref2_2_asm_h
	.quad	_put_var_ref3_2_asm_h
	.quad	_set_var_ref0_2_asm_h
	.quad	_set_var_ref1_2_asm_h
	.quad	_set_var_ref2_2_asm_h
	.quad	_set_var_ref3_2_asm_h
	.quad	_get_length_2_asm_h
	.quad	_if_false8_2_asm_h
	.quad	_if_true8_2_asm_h
	.quad	_goto8_2_asm_h
	.quad	_goto16_2_asm_h
	.quad	_call0_2_asm_h
	.quad	_call1_2_asm_h
	.quad	_call2_2_asm_h
	.quad	_call3_2_asm_h
	.quad	_is_undefined_2_asm_h
	.quad	_is_null_2_asm_h
	.quad	_is_function_2_asm_h
	.quad	_inc_coverage_2_asm_h
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
