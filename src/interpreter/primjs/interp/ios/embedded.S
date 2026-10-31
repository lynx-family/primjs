#if defined(__aarch64__) && defined(ENABLE_PRIMJS_SNAPSHOT) && !defined(ENABLE_QUICKJS_DEBUGGER)
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
	sub	x8, x19, #144
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
	str	xzr, [x8, #64]
	str	wzr, [x8, #72]
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
	sub	x8, x10, #144
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
	str	xzr, [x8, #64]
	str	wzr, [x8, #72]
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
; %bb.0:                                ; %B40
	tbz	w19, #2, LBB4_3
; %bb.1:                                ; %B31
	ldr	x8, [x24, #296]
	and	x9, x22, #0xfffffffffffc
	add	x11, x9, #16
	ldr	x8, [x8, #8]
	mov	x23, x11
	stp	x8, x30, [x9, #144]
	ldr	x8, [x24, #8]
	ldr	x10, [x8, #256]
	str	x10, [x9, #16]
	str	x11, [x8, #256]
	ldp	x27, x19, [x9, #40]
	ldr	w8, [x9, #12]
	ldr	x20, [x9, #64]
	ldr	x28, [x9, #32]
	ldr	x26, [x9, #112]
	cbnz	w8, LBB4_11
LBB4_2:                                 ; %B23
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB4_3:                                 ; %B34
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB4_12
; %bb.4:                                ; %B36
	ldrh	w8, [x22, #6]
	cmp	w8, #13
	b.ne	LBB4_13
; %bb.5:                                ; %B1
	ldr	x10, [x22, #32]
	ldr	x11, [x24, #296]
	mov	x12, x23
	ldr	x14, [x24, #296]
	ldrh	w9, [x10, #40]
	ldrh	w8, [x10, #42]
	ldrh	w15, [x10, #46]
	ldr	x13, [x11, #8]
	ldr	x14, [x14]
	cmp	w0, w9
	add	w11, w8, w15
	b.lt	LBB4_14
; %bb.6:                                ; %B28
	add	w9, w11, w0
	lsl	w9, w9, #3
	add	w9, w9, #144
	sub	x9, x13, x9
	cmp	x9, x14
	b.ls	LBB4_21
; %bb.7:                                ; %B30
	ldr	x11, [x24, #296]
	mov	x23, x9
	str	x9, [x11, #8]
	stp	x13, x30, [x9, #128]
	stp	x12, x22, [x9]
	stp	x21, x27, [x9, #80]
	ldr	x13, [x22, #40]
	str	x13, [x9, #96]
	mov	x26, x13
	ldrb	w11, [x10, #5]
	str	w11, [x9, #44]
	add	x11, x9, #144
	ldr	x19, [x10, #8]
	str	w0, [x9, #112]
	ldr	x12, [x10, #48]
	add	x10, x11, w0, uxtw #3
	str	x12, [x9, #104]
	mov	x12, x11
	cmp	x11, x10
	b.ge	LBB4_9
LBB4_8:                                 ; %B25
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x13, [x20], #8
	str	x13, [x12], #8
	cmp	x12, x10
	b.lt	LBB4_8
LBB4_9:                                 ; %B27
	add	w12, w0, w8
	str	w0, [x9, #40]
	add	x20, x10, x8, lsl #3
	stp	x11, x10, [x9, #16]
	mov	w8, #18                         ; =0x12
	mov	x28, x11
	str	xzr, [x9, #64]
	mov	x27, x10
	str	w12, [x9, #72]
	ldr	x12, [x24, #8]
	str	x9, [x12, #256]
	cmp	x10, x20
	b.ge	LBB4_2
LBB4_10:                                ; %B21
                                        ; =>This Inner Loop Header: Depth=1
	str	x8, [x10], #8
	cmp	x10, x20
	b.lt	LBB4_10
	b	LBB4_2
LBB4_11:                                ; %B32
	b	l_exception_asm_h
LBB4_12:                                ; %B39
	b	l_ThrowTypeErrorNotFunction_Return_asm_h
LBB4_13:                                ; %B37
	b	l_call_native_entry_asm_h
LBB4_14:                                ; %B16
	add	w11, w11, w9
	lsl	w11, w11, #3
	add	w11, w11, #144
	sub	x11, x13, x11
	cmp	x11, x14
	b.ls	LBB4_21
; %bb.15:                               ; %B18
	ldr	x14, [x24, #296]
	mov	x23, x11
	str	x11, [x14, #8]
	stp	x13, x30, [x11, #128]
	stp	x12, x22, [x11]
	stp	x21, x27, [x11, #80]
	ldr	x13, [x22, #40]
	str	x13, [x11, #96]
	mov	x26, x13
	ldrb	w12, [x10, #5]
	str	w12, [x11, #44]
	ldr	x19, [x10, #8]
	str	w0, [x11, #112]
	ldr	x12, [x10, #48]
	add	x10, x11, #144
	str	x12, [x11, #104]
	mov	x12, x10
	cmp	w0, w9
	csel	w13, w0, w9, lt
	add	x13, x10, w13, uxtw #3
	cmp	x10, x13
	b.ge	LBB4_17
LBB4_16:                                ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x13, [x20], #8
	str	x13, [x12], #8
	cmp	w0, w9
	csel	w13, w0, w9, lt
	add	x13, x10, w13, uxtw #3
	cmp	x12, x13
	b.lt	LBB4_16
LBB4_17:                                ; %B9.preheader
	add	x12, x10, x9, lsl #3
	mov	w14, #18                        ; =0x12
	cmp	x13, x12
	b.ge	LBB4_19
LBB4_18:                                ; %B10
                                        ; =>This Inner Loop Header: Depth=1
	str	x14, [x13], #8
	cmp	x13, x12
	b.lt	LBB4_18
LBB4_19:                                ; %B11
	str	w9, [x11, #40]
	add	w9, w9, w8
	add	x20, x12, x8, lsl #3
	stp	x10, x12, [x11, #16]
	mov	w8, #18                         ; =0x12
	mov	x28, x10
	str	xzr, [x11, #64]
	mov	x27, x12
	str	w9, [x11, #72]
	ldr	x9, [x24, #8]
	str	x11, [x9, #256]
	cmp	x12, x20
	b.ge	LBB4_2
LBB4_20:                                ; %B14
                                        ; =>This Inner Loop Header: Depth=1
	str	x8, [x12], #8
	cmp	x12, x20
	b.lt	LBB4_20
	b	LBB4_2
LBB4_21:                                ; %B17
	b	l_ThrowStackOverflow_Return_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function exception_asm_h
l_exception_asm_h:                      ; @exception_asm_h
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
	b	l_common_return_asm_h
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
	.p2align	2                               ; -- Begin function common_call_asm_h
l_common_call_asm_h:                    ; @common_call_asm_h
; %bb.0:                                ; %B30
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB6_7
; %bb.1:                                ; %B27
	ldrh	w8, [x22, #6]
	cmp	w8, #13
	b.ne	LBB6_8
; %bb.2:                                ; %B1
	ldr	x11, [x22, #32]
	ldr	x10, [x24, #296]
	mov	x12, x23
	ldr	x14, [x24, #296]
	ldrh	w9, [x11, #40]
	ldrh	w8, [x11, #42]
	ldrh	w15, [x11, #46]
	ldr	x13, [x10, #8]
	ldr	x14, [x14]
	cmp	w0, w9
	add	w10, w8, w15
	b.lt	LBB6_9
; %bb.3:                                ; %B24
	lsl	w9, w10, #3
	add	w9, w9, #144
	sub	x9, x13, x9
	cmp	x9, x14
	b.ls	LBB6_17
; %bb.4:                                ; %B26
	ldr	x10, [x24, #296]
	mov	x23, x9
	mov	x28, x20
	str	x9, [x10, #8]
	stp	x13, x30, [x9, #128]
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
	mov	w11, #18                        ; =0x12
	cmp	x10, x8
	b.ge	LBB6_6
LBB6_5:                                 ; %B21
                                        ; =>This Inner Loop Header: Depth=1
	str	x11, [x10], #8
	cmp	x10, x8
	b.lt	LBB6_5
LBB6_6:                                 ; %B23
	ldrb	w9, [x19], #1
	mov	x20, x8
	ldr	x1, [x25, x9, lsl #3]
	br	x1
LBB6_7:                                 ; %B32
	b	l_ThrowTypeErrorNotFunction_Return_asm_h
LBB6_8:                                 ; %B28
	b	l_call_native_asm_h
LBB6_9:                                 ; %B16
	add	w10, w10, w9
	lsl	w10, w10, #3
	add	w10, w10, #144
	sub	x10, x13, x10
	cmp	x10, x14
	b.ls	LBB6_17
; %bb.10:                               ; %B18
	ldr	x14, [x24, #296]
	mov	x23, x10
	str	x10, [x14, #8]
	stp	x13, x30, [x10, #128]
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
	b.ge	LBB6_12
LBB6_11:                                ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x13, [x20], #8
	str	x13, [x12], #8
	cmp	w0, w9
	csel	w13, w0, w9, lt
	add	x13, x11, w13, uxtw #3
	cmp	x12, x13
	b.lt	LBB6_11
LBB6_12:                                ; %B9.preheader
	add	x12, x11, x9, lsl #3
	mov	w14, #18                        ; =0x12
	cmp	x13, x12
	b.ge	LBB6_14
LBB6_13:                                ; %B10
                                        ; =>This Inner Loop Header: Depth=1
	str	x14, [x13], #8
	cmp	x13, x12
	b.lt	LBB6_13
LBB6_14:                                ; %B11
	str	w9, [x10, #40]
	add	w9, w9, w8
	add	x20, x12, x8, lsl #3
	stp	x11, x12, [x10, #16]
	mov	w8, #18                         ; =0x12
	mov	x28, x11
	str	xzr, [x10, #64]
	mov	x27, x12
	str	w9, [x10, #72]
	ldr	x9, [x24, #8]
	str	x10, [x9, #256]
	cmp	x12, x20
	b.ge	LBB6_16
LBB6_15:                                ; %B14
                                        ; =>This Inner Loop Header: Depth=1
	str	x8, [x12], #8
	cmp	x12, x20
	b.lt	LBB6_15
LBB6_16:                                ; %B15
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB6_17:                                ; %B17
	b	l_ThrowStackOverflow_Return_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function common_return_direct_asm_h
l_common_return_direct_asm_h:           ; @common_return_direct_asm_h
; %bb.0:                                ; %B0
	ldp	x8, x10, [x23, #128]
	ldr	x9, [x24, #296]
	ldr	x11, [x23]
	str	x8, [x9, #8]
	mov	x30, x10
	mov	x23, x11
	ldr	x8, [x24, #8]
	str	x11, [x8, #256]
	ret
                                        ; -- End function
	.p2align	2                               ; -- Begin function common_call_debugger0_asm_h
l_common_call_debugger0_asm_h:          ; @common_call_debugger0_asm_h
; %bb.0:                                ; %B0
	ldurb	w8, [x19, #-1]
	sub	w8, w8, #729
	ldr	x1, [x25, w8, sxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function common_call_debugger1_asm_h
l_common_call_debugger1_asm_h:          ; @common_call_debugger1_asm_h
; %bb.0:                                ; %B0
	ldurb	w8, [x19, #-1]
	sub	w8, w8, #486
	ldr	x1, [x25, w8, sxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function common_call_debugger2_asm_h
l_common_call_debugger2_asm_h:          ; @common_call_debugger2_asm_h
; %bb.0:                                ; %B0
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
	ldr	x8, [x23, #64]
	cbnz	x8, LBB12_3
; %bb.1:                                ; %B1
	ldrb	w8, [x24, #376]
	cbz	w8, LBB12_4
; %bb.2:                                ; %B1
	cbz	x26, LBB12_4
LBB12_3:                                ; %B3
	b	l_SlowCloseVarRefs_asm_h
LBB12_4:                                ; %B5
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
	tbnz	w0, #31, LBB18_2
; %bb.1:                                ; %B3
	cmp	w0, #0
	mov	w8, #6                          ; =0x6
	cinc	x8, x8, ne
	stur	x8, [x20, #-8]
	ldurb	w8, [x19, #-1]
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB18_2:                                ; %B2
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
	tbnz	w0, #31, LBB19_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB19_2:                                ; %B2
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
	b.eq	LBB20_2
; %bb.1:                                ; %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB20_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function FastJSConcatString_asm_h
l_FastJSConcatString_asm_h:             ; @FastJSConcatString_asm_h
; %bb.0:                                ; %B37
	sub	sp, sp, #48
	mov	x22, x0
	str	x19, [sp, #40]                  ; 8-byte Folded Spill
	cbnz	x22, LBB21_13
; %bb.1:                                ; %B40
	ldur	x1, [x20, #-16]
LBB21_2:                                ; %B14
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
	cbnz	w10, LBB21_10
; %bb.3:                                ; %B18
	mov	x10, #-281474976710653          ; =0xffff000000000003
	bics	xzr, x10, x1
	b.eq	LBB21_14
; %bb.4:
	mov	w14, #1                         ; =0x1
	bics	xzr, x10, x2
	stp	x1, x2, [sp, #16]               ; 16-byte Folded Spill
	stp	w12, w11, [sp, #8]              ; 8-byte Folded Spill
	str	w13, [sp, #4]                   ; 4-byte Folded Spill
	b.eq	LBB21_15
LBB21_5:                                ; %B28
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
	cbz	x19, LBB21_10
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
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB21_16
; %bb.7:                                ; %B24
	str	x2, [x19, #24]
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB21_17
LBB21_8:                                ; %B1
	orr	x8, x19, #0xffff000000000003
	cbz	x22, LBB21_18
LBB21_9:                                ; %B2
	ldr	x10, [sp, #40]                  ; 8-byte Folded Reload
	sub	x20, x20, #8
	ldrb	w9, [x10]
	add	x19, x10, #2
	str	x8, [x27, x9, lsl #3]
	ldrb	w8, [x10, #1]
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
LBB21_10:                               ; %B5
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ConcatString_GC
	cmp	x0, #130
	cbnz	x22, LBB21_19
; %bb.11:                               ; %B11
	b.eq	LBB21_21
; %bb.12:                               ; %B13
	ldp	x9, x19, [sp, #32]              ; 16-byte Folded Reload
	stur	x0, [x9, #-16]
	sub	x20, x9, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
LBB21_13:                               ; %B38
	ldrb	w8, [x19]
	ldr	x1, [x27, x8, lsl #3]
	b	LBB21_2
LBB21_14:                               ; %B19
	ldr	w9, [x9, #8]
	add	w14, w9, #1
	bics	xzr, x10, x2
	stp	x1, x2, [sp, #16]               ; 16-byte Folded Spill
	stp	w12, w11, [sp, #8]              ; 8-byte Folded Spill
	str	w13, [sp, #4]                   ; 4-byte Folded Spill
	b.ne	LBB21_5
LBB21_15:                               ; %B33
	ldr	w8, [x8, #8]
	add	w9, w8, #1
	cmp	w14, w9
	csinc	w14, w14, w8, gt
	b	LBB21_5
LBB21_16:                               ; %B27
	mov	x0, x1
	mov	x1, x24
	mov	x20, x2
	bl	_prim_WriteBarrierNoStore
	mov	x2, x20
	ldr	x20, [sp, #32]                  ; 8-byte Folded Reload
	str	x2, [x19, #24]
	ldrb	w8, [x24, #376]
	cbz	w8, LBB21_8
LBB21_17:                               ; %B26
	mov	x0, x2
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldr	x20, [sp, #32]                  ; 8-byte Folded Reload
	orr	x8, x19, #0xffff000000000003
	cbnz	x22, LBB21_9
LBB21_18:                               ; %B4
	ldr	x19, [sp, #40]                  ; 8-byte Folded Reload
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
LBB21_19:                               ; %B7
	b.eq	LBB21_21
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
LBB21_21:                               ; %B12
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
	b.eq	LBB22_3
LBB22_1:                                ; %B15
	mov	w8, #6                          ; =0x6
	bfxil	x8, x0, #0, #1
LBB22_2:                                ; %B16
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB22_3:                                ; %B1
	mov	x8, #-281474976710653           ; =0xffff000000000003
	bics	xzr, x8, x1
	b.eq	LBB22_15
; %bb.4:                                ; %B69
	bics	xzr, x8, x2
	b.eq	LBB22_17
LBB22_5:                                ; %B54
	and	x8, x1, #0xfffffffffffc
	and	x9, x2, #0xfffffffffffc
	cmp	x8, x9
	b.eq	LBB22_19
LBB22_6:                                ; %B57
	ldrb	w10, [x8, #7]
	tbnz	w10, #6, LBB22_20
; %bb.7:                                ; %B60
	ldr	w10, [x8, #8]
	ldrb	w11, [x9, #7]
	tbnz	w11, #6, LBB22_21
LBB22_8:                                ; %B53
	ldr	w11, [x9, #8]
	asr	w10, w10, #30
	cmp	w10, #1
	b.ne	LBB22_10
LBB22_9:                                ; %B49
	asr	w10, w11, #30
	cmp	w10, #1
	b.eq	LBB22_1
LBB22_10:                               ; %B8
	ldr	w10, [x8, #4]
	ldr	w11, [x9, #4]
	add	x8, x8, #16
	add	x9, x9, #16
	tst	w10, #0xbfffffff
	and	w10, w10, #0x3fffffff
	and	w11, w11, #0xbfffffff
	b.lt	LBB22_22
; %bb.11:                               ; %B32
	tbnz	w11, #31, LBB22_26
; %bb.12:                               ; %B46.preheader
	mov	w11, wzr
	cmp	w10, wzr
	b.eq	LBB22_19
LBB22_13:                               ; %B43
                                        ; =>This Inner Loop Header: Depth=1
	ldrb	w12, [x8, w11, sxtw]
	ldrb	w13, [x9, w11, sxtw]
	cmp	w12, w13
	b.ne	LBB22_1
; %bb.14:                               ; %B45
                                        ;   in Loop: Header=BB22_13 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	LBB22_13
	b	LBB22_19
LBB22_15:                               ; %B66
	and	x9, x1, #0xfffffffffffc
	ldr	x10, [x9, #24]
	cmp	x10, #2
	b.ne	LBB22_29
; %bb.16:                               ; %B67
	ldr	x1, [x9, #16]
	bics	xzr, x8, x2
	b.ne	LBB22_5
LBB22_17:                               ; %B3
	and	x8, x2, #0xfffffffffffc
	ldr	x9, [x8, #24]
	cmp	x9, #2
	b.ne	LBB22_29
; %bb.18:                               ; %B4
	ldr	x2, [x8, #16]
	and	x8, x1, #0xfffffffffffc
	and	x9, x2, #0xfffffffffffc
	cmp	x8, x9
	b.ne	LBB22_6
LBB22_19:                               ; %B21
	mvn	w9, w0
	mov	w8, #6                          ; =0x6
	bfxil	x8, x9, #0, #1
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB22_20:                               ; %B58
	ldr	x10, [x8, #8]
	ldr	w10, [x10]
	ldrb	w11, [x9, #7]
	tbz	w11, #6, LBB22_8
LBB22_21:                               ; %B7
	ldr	x11, [x9, #8]
	ldr	w11, [x11]
	asr	w10, w10, #30
	cmp	w10, #1
	b.eq	LBB22_9
	b	LBB22_10
LBB22_22:                               ; %B10
	tbnz	w11, #31, LBB22_31
; %bb.23:                               ; %B28.preheader
	mov	w11, wzr
	cmp	w10, wzr
	b.eq	LBB22_19
LBB22_24:                               ; %B25
                                        ; =>This Inner Loop Header: Depth=1
	ldrh	w12, [x8, w11, sxtw #1]
	ldrb	w13, [x9, w11, sxtw]
	cmp	w12, w13
	b.ne	LBB22_1
; %bb.25:                               ; %B27
                                        ;   in Loop: Header=BB22_24 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	LBB22_24
	b	LBB22_19
LBB22_26:                               ; %B38.preheader
	mov	w11, wzr
	cmp	w10, wzr
	b.eq	LBB22_19
LBB22_27:                               ; %B35
                                        ; =>This Inner Loop Header: Depth=1
	ldrb	w12, [x8, w11, sxtw]
	ldrh	w13, [x9, w11, sxtw #1]
	cmp	w12, w13
	b.ne	LBB22_1
; %bb.28:                               ; %B37
                                        ;   in Loop: Header=BB22_27 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	LBB22_27
	b	LBB22_19
LBB22_29:                               ; %B63
	mov	w3, w0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	mov	x8, x0
	b.ne	LBB22_2
; %bb.30:                               ; %B64
	b	l_exception_asm_h
LBB22_31:                               ; %B19.preheader
	mov	w11, wzr
	cmp	w10, wzr
	b.eq	LBB22_19
LBB22_32:                               ; %B13
                                        ; =>This Inner Loop Header: Depth=1
	ldrh	w12, [x8, w11, sxtw #1]
	ldrh	w13, [x9, w11, sxtw #1]
	cmp	w12, w13
	b.ne	LBB22_1
; %bb.33:                               ; %B18
                                        ;   in Loop: Header=BB22_32 Depth=1
	add	w11, w11, #1
	cmp	w10, w11
	b.ne	LBB22_32
	b	LBB22_19
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
	.p2align	2                               ; -- Begin function FastBuildArguments_asm_h
l_FastBuildArguments_asm_h:             ; @FastBuildArguments_asm_h
; %bb.0:                                ; %B51
	sub	sp, sp, #48
	str	x20, [sp, #40]                  ; 8-byte Folded Spill
	ldrb	w8, [x24, #355]
	ldr	w20, [x23, #112]
	str	x19, [sp, #24]                  ; 8-byte Folded Spill
	cbnz	w8, LBB25_19
; %bb.1:                                ; %B48
	ldr	x8, [x24, #400]
	cbz	x8, LBB25_19
; %bb.2:                                ; %B45
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	str	x20, [sp, #32]                  ; 8-byte Folded Spill
	cbz	w20, LBB25_8
; %bb.3:                                ; %B6
	lsl	x1, x20, #3
	ldr	x8, [sp, #40]                   ; 8-byte Folded Reload
	mov	x0, x24
	mov	w2, #42                         ; =0x2a
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	cbz	x0, LBB25_19
; %bb.4:                                ; %B9.preheader
	mov	x8, x0
	add	x10, x0, x20, lsl #3
	mov	x19, x28
	mov	x20, x8
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	cmp	x8, x10
	b.ge	LBB25_9
LBB25_5:                                ; %B12
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x19]
	str	x8, [x20]
	ldrb	w9, [x24, #376]
	cbnz	w9, LBB25_7
LBB25_6:                                ; %B11
                                        ;   in Loop: Header=BB25_5 Depth=1
	add	x20, x20, #8
	add	x19, x19, #8
	cmp	x20, x10
	b.lt	LBB25_5
	b	LBB25_9
LBB25_7:                                ; %B14
                                        ;   in Loop: Header=BB25_5 Depth=1
	mov	x0, x8
	mov	x1, x24
	str	x10, [sp]                       ; 8-byte Folded Spill
	bl	_prim_WriteBarrierNoStore
	ldr	x10, [sp]                       ; 8-byte Folded Reload
	b	LBB25_6
LBB25_8:
	str	xzr, [sp, #8]                   ; 8-byte Folded Spill
LBB25_9:                                ; %B17
	ldr	x8, [sp, #40]                   ; 8-byte Folded Reload
	mov	x0, x24
	mov	w1, #16                         ; =0x10
	mov	w2, #42                         ; =0x2a
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x20, [sp, #32]                  ; 8-byte Folded Reload
	mov	x9, x0
	cbz	x9, LBB25_19
; %bb.10:                               ; %B40
	ldr	x20, [x24, #192]
	str	x20, [x9]
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB25_17
; %bb.11:                               ; %B37
	str	x20, [x9, #8]
	ldrb	w8, [x24, #376]
	str	x9, [sp]                        ; 8-byte Folded Spill
	cbnz	w8, LBB25_18
LBB25_12:                               ; %B21
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
	cbz	x19, LBB25_19
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
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB25_21
LBB25_14:                               ; %B29
	orr	x8, x20, #0xfffe000000000000
	mov	x9, x19
	str	x8, [x9, #56]!
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	stur	x9, [x9, #-40]
	stur	x8, [x9, #-16]
	stur	w20, [x9, #-8]
	ldr	x8, [x24, #184]
	str	x8, [x9, #8]
	ldrb	w9, [x24, #376]
	cbnz	w9, LBB25_22
; %bb.15:                               ; %B26
	str	x10, [x19, #72]
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB25_23
LBB25_16:                               ; %B4
	ldr	x20, [sp, #40]                  ; 8-byte Folded Reload
	ldr	x9, [sp, #24]                   ; 8-byte Folded Reload
	str	x19, [x20], #8
	add	x19, x9, #2
	ldrb	w8, [x9, #1]
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #48
	br	x1
LBB25_17:                               ; %B42
	mov	x0, x20
	mov	x1, x24
	mov	x19, x9
	bl	_prim_WriteBarrierNoStore
	str	x20, [x19, #8]
	ldrb	w8, [x24, #376]
	str	x19, [sp]                       ; 8-byte Folded Spill
	cbz	w8, LBB25_12
LBB25_18:                               ; %B39
	mov	x0, x20
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB25_12
LBB25_19:                               ; %B1
	ldr	x8, [sp, #40]                   ; 8-byte Folded Reload
	mov	x0, x24
	mov	w1, w20
	mov	x2, x28
	str	x8, [x23, #48]
	bl	_js_build_arguments_gc
	cmp	x0, #130
	mov	x19, x0
	b.ne	LBB25_16
; %bb.20:                               ; %B2
	ldr	x19, [sp, #24]                  ; 8-byte Folded Reload
	ldr	x20, [sp, #40]                  ; 8-byte Folded Reload
	add	sp, sp, #48
	b	l_exception_asm_h
LBB25_21:                               ; %B34
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	_prim_WriteBarrierNoStore
	ldr	x10, [sp]                       ; 8-byte Folded Reload
	b	LBB25_14
LBB25_22:                               ; %B31
	mov	x0, x8
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldr	x10, [sp]                       ; 8-byte Folded Reload
	str	x10, [x19, #72]
	ldrb	w8, [x24, #376]
	cbz	w8, LBB25_16
LBB25_23:                               ; %B28
	mov	x0, x10
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB25_16
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
	b.ne	LBB26_38
; %bb.1:                                ; %B91
	ldrb	w8, [x24, #355]
	cbnz	w8, LBB26_38
; %bb.2:                                ; %B94
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB26_38
; %bb.3:                                ; %B97
	ldr	w8, [sp, #76]                   ; 4-byte Folded Reload
	tst	w8, #0x1
	mov	w8, #6                          ; =0x6
	cinc	w8, w8, eq
	ldr	x10, [x24, w8, uxtw #3]
	cbz	x10, LBB26_38
; %bb.4:                                ; %B9
	ldr	x8, [sp, #80]                   ; 8-byte Folded Reload
	mov	w9, #47                         ; =0x2f
	ldr	w8, [x8, #20]
	cmp	w8, #0
	csel	w8, w9, w8, eq
	tbnz	w8, #31, LBB26_38
; %bb.5:                                ; %B86
	ldr	x9, [x24, #8]
	ldr	x9, [x9, #64]
	ldr	x9, [x9, w8, sxtw #3]
	ldrb	w8, [x9, #7]
	tbnz	w8, #6, LBB26_23
; %bb.6:                                ; %B89
	ldr	w8, [x9, #8]
	asr	w8, w8, #30
	str	x9, [sp, #24]                   ; 8-byte Folded Spill
	cmp	w8, #1
	b.ne	LBB26_38
LBB26_7:                                ; %B19
	ldr	x8, [sp, #80]                   ; 8-byte Folded Reload
	str	x10, [sp, #16]                  ; 8-byte Folded Spill
	ldr	w9, [x8, #60]
	cbz	w9, LBB26_24
; %bb.8:                                ; %B82
	ldr	x8, [x8, #32]
	lsl	x1, x9, #3
	ldr	w19, [x23, #40]
	ldr	x20, [x23, #64]
	mov	x0, x24
	mov	w2, #48                         ; =0x30
	stp	x8, x9, [sp, #56]               ; 16-byte Folded Spill
	str	x14, [x23, #48]
	bl	_prim_try_malloc_gc
	ldp	x11, x10, [sp, #56]             ; 16-byte Folded Reload
	ldr	x14, [sp, #120]                 ; 8-byte Folded Reload
	cbz	x0, LBB26_38
; %bb.9:                                ; %B83
	mov	w12, w19
	mov	w13, wzr
	mov	x15, x0
	mov	w19, wzr
	str	x0, [sp, #8]                    ; 8-byte Folded Spill
	str	w12, [sp, #44]                  ; 4-byte Folded Spill
	b	LBB26_11
LBB26_10:                               ; %B74
                                        ;   in Loop: Header=BB26_11 Depth=1
	add	w19, w19, #1
	add	w13, w13, #8
	cmp	w19, w10
	str	x8, [x15], #8
	b.hs	LBB26_25
LBB26_11:                               ; %B25
                                        ; =>This Inner Loop Header: Depth=1
	add	x8, x11, w13, uxtw
	ldrb	w9, [x8]
	tbz	w9, #0, LBB26_14
; %bb.12:                               ; %B27
                                        ;   in Loop: Header=BB26_11 Depth=1
	ldrh	w16, [x8, #2]
	tst	w9, #0x2
	csel	x17, x27, x28, eq
	add	w8, w12, w16
	csel	w9, w8, w16, eq
	cbz	x20, LBB26_16
; %bb.13:                               ; %B43
                                        ;   in Loop: Header=BB26_11 Depth=1
	ldr	x8, [x20, w9, uxtw #3]
	cbnz	x8, LBB26_10
	b	LBB26_18
LBB26_14:                               ; %B21
                                        ;   in Loop: Header=BB26_11 Depth=1
	cbz	x26, LBB26_38
; %bb.15:                               ; %B23
                                        ;   in Loop: Header=BB26_11 Depth=1
	ldrh	w8, [x8, #2]
	ldr	x8, [x26, x8, lsl #3]
	b	LBB26_10
LBB26_16:                               ; %B29
                                        ;   in Loop: Header=BB26_11 Depth=1
	ldr	w8, [x23, #72]
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
	cbz	x0, LBB26_38
; %bb.17:                               ; %B30
                                        ;   in Loop: Header=BB26_11 Depth=1
	ldr	x16, [sp, #104]                 ; 8-byte Folded Reload
	ldr	w9, [sp, #100]                  ; 4-byte Folded Reload
	mov	w13, w20
	ldr	x17, [sp, #88]                  ; 8-byte Folded Reload
	mov	x20, x0
	str	x0, [x23, #64]
LBB26_18:                               ; %B39
                                        ;   in Loop: Header=BB26_11 Depth=1
	ldr	w8, [x23, #44]
	str	x20, [sp, #48]                  ; 8-byte Folded Spill
	mov	w20, w13
	mov	w1, #16                         ; =0x10
	str	x17, [sp, #88]                  ; 8-byte Folded Spill
	mov	x0, x24
	str	w9, [sp, #100]                  ; 4-byte Folded Spill
	stp	x16, x15, [sp, #104]            ; 16-byte Folded Spill
	str	x14, [x23, #48]
	tbnz	w8, #4, LBB26_22
; %bb.19:                               ; %B32
                                        ;   in Loop: Header=BB26_11 Depth=1
	mov	w2, #16                         ; =0x10
LBB26_20:                               ; %B32
                                        ;   in Loop: Header=BB26_11 Depth=1
	bl	_prim_try_malloc_gc
	ldp	x15, x14, [sp, #112]            ; 16-byte Folded Reload
	mov	w13, w20
	ldp	x11, x10, [sp, #56]             ; 16-byte Folded Reload
	ldr	w12, [sp, #44]                  ; 4-byte Folded Reload
	ldr	x20, [sp, #48]                  ; 8-byte Folded Reload
	cbz	x0, LBB26_38
; %bb.21:                               ;   in Loop: Header=BB26_11 Depth=1
	ldr	x9, [sp, #104]                  ; 8-byte Folded Reload
	ldr	x16, [sp, #88]                  ; 8-byte Folded Reload
	mov	x8, x0
	add	x9, x16, x9, lsl #3
	str	x9, [x8]
	mov	w9, #18                         ; =0x12
	str	x9, [x8, #8]
	ldr	w9, [sp, #100]                  ; 4-byte Folded Reload
	str	x8, [x20, w9, uxtw #3]
	b	LBB26_10
LBB26_22:                               ; %B36
                                        ;   in Loop: Header=BB26_11 Depth=1
	mov	w2, #57                         ; =0x39
	b	LBB26_20
LBB26_23:                               ; %B87
	ldr	x8, [x9, #8]
	ldr	w8, [x8]
	asr	w8, w8, #30
	str	x9, [sp, #24]                   ; 8-byte Folded Spill
	cmp	w8, #1
	b.eq	LBB26_7
	b	LBB26_38
LBB26_24:
	str	xzr, [sp, #8]                   ; 8-byte Folded Spill
LBB26_25:                               ; %B79
	ldr	w8, [sp, #76]                   ; 4-byte Folded Reload
	tbnz	w8, #0, LBB26_32
; %bb.26:                               ; %B67
	mov	x0, x24
	mov	w1, #88                         ; =0x58
	mov	w2, #2                          ; =0x2
	str	x14, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x14, [sp, #120]                 ; 8-byte Folded Reload
	ldr	x11, [sp, #16]                  ; 8-byte Folded Reload
	cbz	x0, LBB26_38
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
	ldrb	w10, [x24, #376]
	cbnz	w10, LBB26_35
LBB26_28:                               ; %B58
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
	tbnz	w11, #0, LBB26_36
LBB26_29:                               ; %B61
	ldr	x19, [sp, #32]                  ; 8-byte Folded Reload
LBB26_30:                               ; %B6
	str	x8, [x14], #8
	ldurb	w8, [x19, #-1]
	cmp	w8, #189
	b.ne	LBB26_37
; %bb.31:                               ; %B7
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	mov	x20, x14
	add	sp, sp, #128
	br	x1
LBB26_32:                               ; %B52
	ldr	x20, [x24, #416]
	cbz	x20, LBB26_38
; %bb.33:                               ; %B55
	mov	x0, x24
	mov	w1, #88                         ; =0x58
	mov	w2, #2                          ; =0x2
	str	x14, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x11, [sp, #16]                  ; 8-byte Folded Reload
	ldr	x14, [sp, #120]                 ; 8-byte Folded Reload
	cbz	x0, LBB26_38
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
	ldrb	w10, [x24, #376]
	cbz	w10, LBB26_28
LBB26_35:                               ; %B58.sink.split
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x11, x8
	bl	_prim_WriteBarrierNoStore
	ldr	x14, [sp, #120]                 ; 8-byte Folded Reload
	mov	x8, x19
	mov	x9, x20
	b	LBB26_28
LBB26_36:                               ; %B60
	str	x9, [x10, #16]
	b	LBB26_29
LBB26_37:                               ; %B8
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	mov	x20, x14
	add	sp, sp, #128
	br	x1
LBB26_38:                               ; %B1
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
	b.ne	LBB26_30
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
	b.eq	LBB27_5
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
	ldr	x26, [x23, #96]
	b.eq	LBB27_6
; %bb.2:                                ; %B1
	mov	x9, #2                          ; =0x2
	ldurh	w8, [x19, #-2]
	movk	x9, #65535, lsl #48
	tst	x0, x9
	b.eq	LBB27_7
; %bb.3:                                ; %B5
	sub	x9, x20, x8, lsl #3
	ldur	x9, [x9, #-8]
LBB27_4:                                ; %B3
	sub	x8, x20, x8, lsl #3
	stur	x9, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19], #1
	ldr	x1, [x25, x9, lsl #3]
	add	sp, sp, #16
	br	x1
LBB27_5:                                ; %B10
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
LBB27_6:                                ; %B7
	add	sp, sp, #16
	b	l_exception_asm_h
LBB27_7:
	mov	x9, x0
	b	LBB27_4
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
	ldr	x26, [x23, #96]
	b.eq	LBB28_2
; %bb.1:                                ; %B4
	ldurh	w8, [x19, #-2]
	sub	x8, x20, x8, lsl #3
	stur	x0, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19], #1
	ldr	x1, [x25, x9, lsl #3]
	br	x1
LBB28_2:                                ; %B3
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
	b.hs	LBB29_4
; %bb.1:                                ; %B21
	ldrh	w9, [x1, #6]
	ldr	x8, [x1, #40]
	cmp	w9, #23
	b.ge	LBB29_6
; %bb.2:                                ; %B21
	cmp	w9, #21
	b.eq	LBB29_7
; %bb.3:                                ; %B21
	cmp	w9, #22
	b.eq	LBB29_21
LBB29_4:                                ; %B18
	mov	x0, x24
	str	x20, [x23, #48]
	str	x10, [sp, #8]                   ; 8-byte Folded Spill
	bl	_JS_GetPropertyValue_GC
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	cmp	x0, #130
	mov	x8, x0
	b.ne	LBB29_9
; %bb.5:                                ; %B19
	add	sp, sp, #16
	b	l_exception_asm_h
LBB29_6:                                ; %B21
	b.gt	LBB29_11
LBB29_7:                                ; %B25
	ldrb	w8, [x8, w2, sxtw]
LBB29_8:                                ; %B1
	orr	x8, x8, #0xfffe000000000000
LBB29_9:                                ; %B1
	tbnz	w10, #0, LBB29_20
LBB29_10:                               ; %B4
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB29_11:                               ; %B21
	cmp	w9, #25
	b.gt	LBB29_15
; %bb.12:                               ; %B21
	cmp	w9, #24
	b.eq	LBB29_22
; %bb.13:                               ; %B21
	cmp	w9, #25
	b.ne	LBB29_4
; %bb.14:                               ; %B31
	ldrh	w8, [x8, w2, sxtw #1]
	b	LBB29_8
LBB29_15:                               ; %B21
	cmp	w9, #26
	b.eq	LBB29_23
; %bb.16:                               ; %B21
	cmp	w9, #27
	b.eq	LBB29_24
; %bb.17:                               ; %B21
	cmp	w9, #29
	b.ne	LBB29_4
; %bb.18:                               ; %B14
	ldr	d0, [x8, w2, sxtw #3]
LBB29_19:                               ; %B1
	fmov	x8, d0
	fcmp	d0, d0
	mov	x9, #562949953421312            ; =0x2000000000000
	add	x8, x8, x9
	mov	x9, #9221683186994511872        ; =0x7ffa000000000000
	csel	x8, x8, x9, vc
	tbz	w10, #0, LBB29_10
LBB29_20:                               ; %B2
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB29_21:                               ; %B22
	ldrsb	w8, [x8, w2, sxtw]
	b	LBB29_8
LBB29_22:                               ; %B28
	ldrsh	w8, [x8, w2, sxtw #1]
	b	LBB29_8
LBB29_23:                               ; %B34
	ldr	w8, [x8, w2, sxtw #2]
	b	LBB29_8
LBB29_24:                               ; %B5
	ldr	w8, [x8, w2, sxtw #2]
	tbz	w8, #31, LBB29_8
; %bb.25:                               ; %B10
	ucvtf	d0, w8
	b	LBB29_19
                                        ; -- End function
	.p2align	2                               ; -- Begin function FastTypedArraySet_asm_h
l_FastTypedArraySet_asm_h:              ; @FastTypedArraySet_asm_h
; %bb.0:                                ; %B43
	ldp	x1, x2, [x20, #-24]
	mov	w8, #65534                      ; =0xfffe
	ldur	x3, [x20, #-8]
	cmp	x8, x2, lsr #48
	b.ne	LBB30_17
; %bb.1:                                ; %B1
	ldr	w8, [x1, #48]
	cmp	w2, w8
	b.hs	LBB30_17
; %bb.2:                                ; %B3
	ldrh	w9, [x1, #6]
	ldr	x8, [x1, #40]
	sub	w10, w9, #22
	cmp	w10, #2
	b.hs	LBB30_6
; %bb.3:                                ; %B14
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x3, lsr #48
	b.ne	LBB30_17
; %bb.4:                                ; %B15
	strb	w3, [x8, w2, sxtw]
LBB30_5:                                ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB30_6:                                ; %B3
	cmp	w9, #25
	b.gt	LBB30_10
; %bb.7:                                ; %B3
	sub	w10, w9, #24
	cmp	w10, #2
	b.hs	LBB30_16
; %bb.8:                                ; %B20
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x3, lsr #48
	b.ne	LBB30_17
; %bb.9:                                ; %B21
	strh	w3, [x8, w2, sxtw #1]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB30_10:                               ; %B3
	sub	w10, w9, #26
	cmp	w10, #2
	b.hs	LBB30_13
; %bb.11:                               ; %B26
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x3, lsr #48
	b.ne	LBB30_17
; %bb.12:                               ; %B27
	str	w3, [x8, w2, sxtw #2]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB30_13:                               ; %B3
	cmp	w9, #29
	b.ne	LBB30_17
; %bb.14:                               ; %B32
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x3, lsr #48
	b.ne	LBB30_21
; %bb.15:                               ; %B33
	scvtf	d0, w3
	str	d0, [x8, w2, sxtw #3]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB30_16:                               ; %B3
	cmp	w9, #21
	b.eq	LBB30_19
LBB30_17:                               ; %B40
	mov	x0, x24
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	_JS_SetPropertyValue_GC
	tbz	w0, #31, LBB30_5
; %bb.18:                               ; %B41
	b	l_exception_asm_h
LBB30_19:                               ; %B5
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x3, lsr #48
	b.ne	LBB30_17
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
LBB30_21:                               ; %B35
	and	x9, x3, #0xfffe000000000000
	mov	x10, #-562949953421312          ; =0xfffe000000000000
	cmp	x9, x10
	b.eq	LBB30_17
; %bb.22:                               ; %B35
	cbz	x9, LBB30_17
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
	b.eq	LBB31_2
; %bb.1:                                ; %B52
	cmp	w13, #67
	b.ne	LBB31_12
LBB31_2:                                ; %B53
	ldur	x1, [x20, #-16]
	cmp	x1, #18
	b.eq	LBB31_13
LBB31_3:                                ; %B42
	ldr	x15, [x1, #8]
	ldur	x14, [x20, #-8]
	ldr	x19, [x15, #40]
	cbz	x19, LBB31_14
LBB31_4:                                ; %B45
	ldr	x8, [x1, #16]
	ldr	w9, [x19, #16]
	add	x10, x1, #32
	ldr	w11, [x15, #16]
	cmp	x8, x10
	ccmp	w9, #5, #0, eq
	cset	w8, lt
	cmp	w11, w9
	b.eq	LBB31_6
; %bb.5:                                ; %B45
	cbz	w8, LBB31_18
LBB31_6:                                ; %B1
	ldr	w8, [x15, #48]
	cmp	w8, w2
	b.ne	LBB31_14
; %bb.7:                                ; %B1
	ldrb	w8, [x15, #52]
	cmp	w8, #7
	b.ne	LBB31_14
LBB31_8:                                ; %B17
	ldr	w8, [x19]
	add	x9, x1, #8
	add	w8, w8, #1
	str	w8, [x19]
	ldr	w8, [x15]
	sub	w8, w8, #1
	str	w8, [x15]
	stlr	x19, [x9]
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB31_23
; %bb.9:                                ; %B14
	ldr	w8, [x19, #20]
	ldr	x9, [x1, #16]
	sub	w8, w8, #1
	str	x14, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB31_24
LBB31_10:                               ; %B8
	cmp	w13, #67
	b.ne	LBB31_21
; %bb.11:                               ; %B9
	ldrb	w8, [x12, #4]
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	add	x19, x12, #5
	add	sp, sp, #64
	br	x1
LBB31_12:
	ldur	x1, [x20, #-24]
	cmp	x1, #18
	b.ne	LBB31_3
LBB31_13:                               ; %B49
	ldr	x1, [x24, #208]
	ldr	x15, [x1, #8]
	ldur	x14, [x20, #-8]
	ldr	x19, [x15, #40]
	cbnz	x19, LBB31_4
LBB31_14:                               ; %B22
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
	cbz	x0, LBB31_18
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
	b.ne	LBB31_17
; %bb.16:
	ldp	x1, x12, [sp, #40]              ; 16-byte Folded Reload
	ldr	w13, [sp, #60]                  ; 4-byte Folded Reload
	ldp	x15, x20, [sp, #16]             ; 16-byte Folded Reload
	ldr	x14, [sp, #8]                   ; 8-byte Folded Reload
	b	LBB31_8
LBB31_17:                               ; %B26
	ldp	x1, x12, [sp, #40]              ; 16-byte Folded Reload
	ldr	w13, [sp, #60]                  ; 4-byte Folded Reload
	ldp	x20, x2, [sp, #24]              ; 16-byte Folded Reload
	ldp	x14, x15, [sp, #8]              ; 16-byte Folded Reload
	cbnz	w8, LBB31_8
LBB31_18:                               ; %B29
	mov	x0, x24
	mov	w3, #7                          ; =0x7
	mov	w19, w13
	str	x12, [sp, #48]                  ; 8-byte Folded Spill
                                        ; kill: def $w2 killed $w2 killed $x2
	str	x20, [sp, #24]                  ; 8-byte Folded Spill
	str	x20, [x23, #48]
	bl	_add_property_gc
	cbz	x0, LBB31_25
; %bb.19:                               ; %B39
	ldr	x20, [sp, #24]                  ; 8-byte Folded Reload
	ldr	x12, [sp, #48]                  ; 8-byte Folded Reload
	mov	w13, w19
	ldur	x8, [x20, #-8]
	str	x8, [x0]
	ldrb	w9, [x24, #376]
	cbz	w9, LBB31_10
; %bb.20:                               ; %B41
	mov	x0, x8
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldr	x20, [sp, #24]                  ; 8-byte Folded Reload
	ldr	x12, [sp, #48]                  ; 8-byte Folded Reload
	mov	w13, w19
	b	LBB31_10
LBB31_21:                               ; %B11
	cmp	w13, #76
	b.ne	LBB31_27
; %bb.22:                               ; %B12
	ldrb	w8, [x12, #4]
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	add	x19, x12, #5
	add	sp, sp, #64
	br	x1
LBB31_23:                               ; %B19
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
	ldrb	w8, [x24, #376]
	cbz	w8, LBB31_10
LBB31_24:                               ; %B16
	mov	x0, x14
	mov	x1, x24
	mov	x19, x12
	str	w13, [sp, #60]                  ; 4-byte Folded Spill
	bl	_prim_WriteBarrierNoStore
	ldr	w13, [sp, #60]                  ; 4-byte Folded Reload
	mov	x12, x19
	b	LBB31_10
LBB31_25:                               ; %B31
	cmp	w19, #67
	b.ne	LBB31_28
; %bb.26:                               ; %B32
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	sub	x20, x8, #16
	ldr	x19, [sp, #48]                  ; 8-byte Folded Reload
	add	sp, sp, #64
	b	l_exception_asm_h
LBB31_27:                               ; %B13
	ldrb	w8, [x12], #1
	sub	x20, x20, #24
	mov	x19, x12
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #64
	br	x1
LBB31_28:                               ; %B34
	cmp	w19, #76
	b.ne	LBB31_30
; %bb.29:                               ; %B35
	ldr	x19, [sp, #48]                  ; 8-byte Folded Reload
	ldr	x20, [sp, #24]                  ; 8-byte Folded Reload
	add	sp, sp, #64
	b	l_exception_asm_h
LBB31_30:                               ; %B36
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
; %bb.0:                                ; %B0
	ldrb	w9, [x19, #4]
	ldr	x8, [x23, #104]
	ldrsw	x10, [x19]
	add	x19, x19, #5
	add	w9, w9, #243
	ldr	x22, [x8, x10, lsl #3]
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function fclosure_0_asm_h
l_fclosure_0_asm_h:                     ; @fclosure_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x23, #104]
	ldrsw	x9, [x19]
	ldr	x0, [x8, x9, lsl #3]
	b	l_FastFclosure_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function push_atom_value_0_asm_h
l_push_atom_value_0_asm_h:              ; @push_atom_value_0_asm_h
; %bb.0:                                ; %B13
	ldr	w1, [x19]
	tbnz	w1, #31, LBB36_5
; %bb.1:                                ; %B1
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, sxtw #3]
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, LBB36_4
; %bb.2:                                ; %B9
	ldr	w9, [x8, #8]
	asr	w9, w9, #30
	cmp	w9, #1
	b.ne	LBB36_5
LBB36_3:                                ; %B7
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	mov	x9, #2                          ; =0x2
	movk	x9, #1, lsl #48
	orr	x22, x8, x9
	br	x1
LBB36_4:                                ; %B2
	ldr	x9, [x8, #8]
	ldr	w9, [x9]
	asr	w9, w9, #30
	cmp	w9, #1
	b.eq	LBB36_3
LBB36_5:                                ; %B10
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB36_7
; %bb.6:                                ; %B12
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB36_7:                                ; %B11
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
	b.eq	LBB37_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB37_2:                                ; %B2
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
	ldr	x1, [x23, #80]
	tbnz	w8, #0, LBB40_2
; %bb.1:                                ; %B12
	ldr	x8, [x23, #80]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, LBB40_3
LBB40_2:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x1
	add	w8, w8, #243
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
LBB40_3:                                ; %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	LBB40_5
; %bb.4:                                ; %B7
	ldrb	w8, [x19], #1
	ldr	x22, [x24, #208]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB40_5:                                ; %B9
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB40_7
; %bb.6:                                ; %B11
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB40_7:                                ; %B10
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
	ldrb	w8, [x24, #355]
	stp	x19, x20, [sp, #-16]!           ; 16-byte Folded Spill
	cbnz	w8, LBB43_5
; %bb.1:                                ; %B1
	ldr	x19, [x24, #392]
	cbz	x19, LBB43_5
; %bb.2:                                ; %B5
	mov	x0, x24
	mov	w1, #64                         ; =0x40
	mov	w2, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x9, x0
	cbz	x9, LBB43_5
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
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB43_7
LBB43_4:                                ; %B9
	add	x8, x9, #32
	ldr	x19, [sp]                       ; 8-byte Folded Reload
	mov	x22, x9
	str	x8, [x9, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB43_5:                                ; %B13
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	LBB43_8
; %bb.6:                                ; %B15
	ldp	x19, x20, [sp]                  ; 16-byte Folded Reload
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB43_7:                                ; %B11
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x19, x8
	mov	x19, x9
	bl	_prim_WriteBarrierNoStore
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x9, x19
	b	LBB43_4
LBB43_8:                                ; %B14
	ldp	x19, x20, [sp], #16             ; 16-byte Folded Reload
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function special_object_0_asm_h
l_special_object_0_asm_h:               ; @special_object_0_asm_h
; %bb.0:                                ; %B12
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	LBB44_5
; %bb.1:                                ; %B12
	cbz	w8, LBB44_8
; %bb.2:                                ; %B12
	cmp	w8, #1
	b.ne	LBB44_10
; %bb.3:                                ; %B2
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
	bl	_js_build_mapped_arguments_gc
	cmp	x0, #130
	b.eq	LBB44_12
LBB44_4:
	mov	x8, x0
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB44_5:                                ; %B12
	cmp	w8, #3
	b.eq	LBB44_9
; %bb.6:                                ; %B12
	cmp	w8, #4
	b.ne	LBB44_11
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
LBB44_8:                                ; %B13
	b	l_FastBuildArguments_asm_h
LBB44_9:                                ; %B16
	ldr	x8, [x23, #88]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB44_10:                               ; %B15
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB44_11:                               ; %B9
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.ne	LBB44_4
LBB44_12:                               ; %B10
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function rest_0_asm_h
l_rest_0_asm_h:                         ; @rest_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x23, #112]
	ldrh	w1, [x19]
	mov	x0, x24
	mov	x3, x28
	str	x20, [x23, #48]
	bl	_js_build_rest_gc
	cmp	x0, #130
	b.eq	LBB45_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB45_2:                                ; %B2
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
	b.ne	LBB65_5
; %bb.1:                                ; %B14
	ldrh	w8, [x1, #6]
	cmp	w8, #13
	b.ne	LBB65_5
; %bb.2:                                ; %B7
	ldrb	w8, [x1, #5]
	tbz	w8, #4, LBB65_5
; %bb.3:                                ; %B9
	ldr	x8, [x1, #32]
	mov	x0, x3
	ldrb	w8, [x8, #6]
	tbnz	w8, #2, LBB65_7
; %bb.4:                                ; %B10
	b	l_FastCallConstructor_asm_h
LBB65_5:                                ; %B2
	add	x8, x19, #2
	mov	x0, x24
	mov	w5, wzr
	str	x8, [x23, #32]
                                        ; kill: def $w3 killed $w3 killed $x3
	str	x20, [x23, #48]
	bl	_JS_CallConstructorInternal_GC
	cmp	x0, #130
	b.eq	LBB65_8
; %bb.6:                                ; %B4
	ldrh	w8, [x19]
	sub	x8, x20, x8, lsl #3
	stur	x0, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x9, lsl #3]
	br	x1
LBB65_7:                                ; %B11
	b	l_FastCallDerivedConstructor_asm_h
LBB65_8:                                ; %B3
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
	ldr	x26, [x23, #96]
	b.eq	LBB66_2
; %bb.1:                                ; %B4
	ldurh	w8, [x19, #-2]
	add	w8, w8, #1
	sub	x20, x20, w8, uxtw #3
	str	x0, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB66_2:                                ; %B3
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
	b.eq	LBB67_2
; %bb.1:                                ; %B4
	ldr	x26, [x23, #96]
	mov	x19, xzr
	mov	x20, xzr
	b	l_common_return_asm_h
LBB67_2:                                ; %B3
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
	ldr	x26, [x23, #96]
	b.eq	LBB68_2
; %bb.1:                                ; %B4
	ldurh	w8, [x19, #-2]
	add	w8, w8, #2
	sub	x20, x20, w8, uxtw #3
	str	x0, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB68_2:                                ; %B3
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
	b.eq	LBB69_2
; %bb.1:                                ; %B4
	ldr	x26, [x23, #96]
	mov	x19, xzr
	mov	x20, xzr
	b	l_common_return_asm_h
LBB69_2:                                ; %B3
	mov	x19, xzr
	mov	x20, xzr
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function array_from_0_asm_h
l_array_from_0_asm_h:                   ; @array_from_0_asm_h
; %bb.0:                                ; %B32
	sub	sp, sp, #64
	ldrh	w1, [x19]
	ldrb	w8, [x24, #355]
	str	x19, [sp, #40]                  ; 8-byte Folded Spill
	str	x20, [sp, #56]                  ; 8-byte Folded Spill
	sub	x9, x20, w1, uxtw #3
	str	x9, [sp, #24]                   ; 8-byte Folded Spill
	cbnz	w8, LBB70_13
; %bb.1:                                ; %B1
	ldr	x8, [x24, #40]
	str	x8, [sp, #32]                   ; 8-byte Folded Spill
	cbz	x8, LBB70_13
; %bb.2:                                ; %B5
	str	x1, [sp, #48]                   ; 8-byte Folded Spill
	cbz	w1, LBB70_8
; %bb.3:                                ; %B10
	ldp	x9, x8, [sp, #48]               ; 16-byte Folded Reload
	mov	x0, x24
	mov	w2, #42                         ; =0x2a
	lsl	x1, x9, #3
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x1, [sp, #48]                   ; 8-byte Folded Reload
	cbz	x0, LBB70_13
; %bb.4:                                ; %B13.preheader
	add	x10, x0, x1, lsl #3
	ldr	x19, [sp, #24]                  ; 8-byte Folded Reload
	mov	x20, x0
	str	x20, [sp, #16]                  ; 8-byte Folded Spill
	cmp	x20, x10
	b.ge	LBB70_9
LBB70_5:                                ; %B15
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x8, [x19]
	str	x8, [x20]
	ldrb	w9, [x24, #376]
	cbnz	w9, LBB70_7
LBB70_6:                                ; %B17
                                        ;   in Loop: Header=BB70_5 Depth=1
	add	x20, x20, #8
	add	x19, x19, #8
	cmp	x20, x10
	b.lt	LBB70_5
	b	LBB70_9
LBB70_7:                                ; %B18
                                        ;   in Loop: Header=BB70_5 Depth=1
	mov	x0, x8
	mov	x1, x24
	str	x10, [sp, #8]                   ; 8-byte Folded Spill
	bl	_prim_WriteBarrierNoStore
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	b	LBB70_6
LBB70_8:
	str	xzr, [sp, #16]                  ; 8-byte Folded Spill
LBB70_9:                                ; %B21
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	mov	x0, x24
	mov	w1, #88                         ; =0x58
	mov	w2, #2                          ; =0x2
	mov	w20, #2                         ; =0x2
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	ldr	x1, [sp, #48]                   ; 8-byte Folded Reload
	mov	x19, x0
	cbz	x19, LBB70_13
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
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB70_15
LBB70_11:                               ; %B25
	orr	x8, x1, #0xfffe000000000000
	mov	x9, x19
	str	x8, [x9, #56]!
	ldr	x8, [sp, #16]                   ; 8-byte Folded Reload
	str	x9, [x19, #16]
	str	x8, [x19, #40]
	str	w1, [x19, #32]
	str	w1, [x19, #48]
LBB70_12:                               ; %B26
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
LBB70_13:                               ; %B29
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	ldr	x2, [sp, #24]                   ; 8-byte Folded Reload
	mov	x0, x24
                                        ; kill: def $w1 killed $w1 killed $x1
	str	x8, [x23, #48]
	bl	_JS_NewArrayWithArgs_GC
	cmp	x0, #130
	mov	x19, x0
	b.ne	LBB70_12
; %bb.14:                               ; %B30
	ldr	x19, [sp, #40]                  ; 8-byte Folded Reload
	ldr	x20, [sp, #56]                  ; 8-byte Folded Reload
	add	sp, sp, #64
	b	l_exception_asm_h
LBB70_15:                               ; %B27
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x9, x8
	bl	_prim_WriteBarrierNoStore
	ldr	x1, [sp, #48]                   ; 8-byte Folded Reload
	b	LBB70_11
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
	b.eq	LBB71_2
; %bb.1:                                ; %B3
	stur	x0, [x20, #-24]
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB71_2:                                ; %B2
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
	b.eq	LBB74_3
; %bb.1:                                ; %B2
	cmp	x22, #18
	b.eq	LBB74_4
; %bb.2:                                ; %B3
Lloh4:
	adrp	x1, l___unnamed_3@PAGE
Lloh5:
	add	x1, x1, l___unnamed_3@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_ThrowTypeError
	b	l_exception_asm_h
LBB74_3:                                ; %B6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w21, #6                         ; =0x6
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB74_4:                                ; %B4
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
	ldr	x8, [x23, #88]
	cmp	x8, #18
	b.ne	LBB75_2
; %bb.1:                                ; %B3
Lloh6:
	adrp	x1, l___unnamed_4@PAGE
Lloh7:
	add	x1, x1, l___unnamed_4@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_ThrowTypeError
	b	l_exception_asm_h
LBB75_2:                                ; %B4
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
	tbnz	w0, #31, LBB76_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB76_2:                                ; %B2
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
	tbnz	w0, #31, LBB77_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB77_2:                                ; %B2
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
	b.le	LBB80_5
; %bb.1:                                ; %B3
	cmp	w8, #2
	b.eq	LBB80_8
; %bb.2:                                ; %B3
	cmp	w8, #3
	b.eq	LBB80_9
; %bb.3:                                ; %B3
	cmp	w8, #4
	b.ne	LBB80_11
; %bb.4:                                ; %B8
Lloh8:
	adrp	x1, l___unnamed_5@PAGE
Lloh9:
	add	x1, x1, l___unnamed_5@PAGEOFF
	mov	x0, x24
	bl	_LEPUS_ThrowTypeError
	add	sp, sp, #16
	b	l_exception_asm_h
LBB80_5:                                ; %B3
	cbz	w8, LBB80_10
; %bb.6:                                ; %B3
	cmp	w8, #1
	b.ne	LBB80_11
; %bb.7:                                ; %B5
	mov	x0, x24
	mov	w1, w2
	bl	_JS_ThrowSyntaxErrorVarRedeclaration_GC
	add	sp, sp, #16
	b	l_exception_asm_h
LBB80_8:                                ; %B6
	mov	x0, x24
	mov	w1, w2
	bl	_JS_ThrowReferenceErrorUninitialized_GC
	add	sp, sp, #16
	b	l_exception_asm_h
LBB80_9:                                ; %B7
Lloh10:
	adrp	x1, l___unnamed_6@PAGE
Lloh11:
	add	x1, x1, l___unnamed_6@PAGEOFF
	mov	x0, x24
	bl	_LEPUS_ThrowReferenceError
	add	sp, sp, #16
	b	l_exception_asm_h
LBB80_10:                               ; %B4
	mov	x0, x24
	mov	w1, #16384                      ; =0x4000
                                        ; kill: def $w2 killed $w2 killed $x2
	bl	_JS_ThrowTypeErrorReadOnly
	add	sp, sp, #16
	b	l_exception_asm_h
LBB80_11:                               ; %B9
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
	b.eq	LBB81_2
; %bb.1:                                ; %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB81_2:                                ; %B2
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
	b.eq	LBB82_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB82_2:                                ; %B2
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
	b.eq	LBB83_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB83_2:                                ; %B2
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
	b.eq	LBB84_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB84_2:                                ; %B2
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
	b.eq	LBB85_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB85_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function check_var_0_asm_h
l_check_var_0_asm_h:                    ; @check_var_0_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_CheckGlobalVar_GC
	tbnz	w0, #31, LBB86_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB86_2:                                ; %B2
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
	cbz	w11, LBB87_3
LBB87_1:                                ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB87_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB87_1 Depth=1
	ldr	w11, [x12]
	and	w11, w11, #0x3ffffff
	cbnz	w11, LBB87_1
LBB87_3:                                ; %B11
	ldr	x8, [x24, #208]
	mov	w10, #18                        ; =0x12
LBB87_4:                                ; %B33
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB87_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w9, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB87_7
LBB87_5:                                ; %B22
                                        ;   Parent Loop BB87_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w9
	b.eq	LBB87_9
; %bb.6:                                ; %B24
                                        ;   in Loop: Header=BB87_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB87_5
LBB87_7:                                ; %B27
                                        ;   in Loop: Header=BB87_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	LBB87_13
; %bb.8:                                ; %B30
                                        ;   in Loop: Header=BB87_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB87_4
	b	LBB87_11
LBB87_9:                                ; %B12
	lsr	w9, w13, #26
	tst	w9, #0x30
	b.ne	LBB87_13
LBB87_10:                               ; %B7.sink.split
	ldr	x8, [x8, #16]
	sub	w9, w11, #1
	ldr	x10, [x8, w9, sxtw #3]
LBB87_11:                               ; %B7
	cmp	x10, #34
	b.eq	LBB87_15
; %bb.12:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x10
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB87_13:                               ; %B17
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB87_16
; %bb.14:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB87_15:                               ; %B3
	b	l_ThrowReferenceErrorUninitialized_asm_h
LBB87_16:                               ; %B18
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
	cbz	w10, LBB88_3
LBB88_1:                                ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB88_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB88_1 Depth=1
	ldr	w10, [x12]
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB88_1
LBB88_3:                                ; %B11
	ldr	x8, [x24, #208]
LBB88_4:                                ; %B32
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB88_5 Depth 2
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w9, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB88_7
LBB88_5:                                ; %B21
                                        ;   Parent Loop BB88_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	LBB88_9
; %bb.6:                                ; %B23
                                        ;   in Loop: Header=BB88_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB88_5
LBB88_7:                                ; %B26
                                        ;   in Loop: Header=BB88_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB88_12
; %bb.8:                                ; %B29
                                        ;   in Loop: Header=BB88_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB88_4
	b	LBB88_12
LBB88_9:                                ; %B12
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	LBB88_12
LBB88_10:                               ; %B7
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	LBB88_14
; %bb.11:                               ; %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB88_12:                               ; %B16
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB88_15
; %bb.13:                               ; %B18
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB88_14:                               ; %B3
	b	l_ThrowReferenceErrorUninitialized_asm_h
LBB88_15:                               ; %B17
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_0_asm_h
l_put_var_0_asm_h:                      ; @put_var_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	mov	w3, wzr
	str	x20, [x23, #48]
	mov	x2, x22
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB89_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB89_2:                                ; %B2
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
	tbnz	w0, #31, LBB90_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB90_2:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_strict_0_asm_h
l_put_var_strict_0_asm_h:               ; @put_var_strict_0_asm_h
; %bb.0:                                ; %B5
	ldp	x22, x21, [x20, #-16]
	cmp	x22, #7
	b.ne	LBB91_3
; %bb.1:                                ; %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB91_4
; %bb.2:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB91_3:                                ; %B6
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB91_4:                                ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_ref_value_0_asm_h
l_get_ref_value_0_asm_h:                ; @get_ref_value_0_asm_h
; %bb.0:                                ; %B49
	ldp	x22, x21, [x20, #-16]
	cmp	x22, #18
	b.eq	LBB92_7
; %bb.1:                                ; %B1
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB92_5
; %bb.2:                                ; %B39
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	LBB92_5
; %bb.3:                                ; %B3
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB92_5
; %bb.4:                                ; %B3
	mov	x9, #2                          ; =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	LBB92_10
LBB92_5:                                ; %B43
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB92_9
; %bb.6:                                ; %B45
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB92_7:                                ; %B46
	mov	x0, x24
	mov	x1, x21
	str	x20, [x23, #48]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB92_9
; %bb.8:                                ; %B48
	mov	w1, w0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB92_9:                                ; %B47
	b	l_exception_asm_h
LBB92_10:                               ; %B9
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB92_22
; %bb.11:                               ; %B37
	ldr	w8, [x1, #8]
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	LBB92_5
LBB92_12:                               ; %B11
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	cbz	w0, LBB92_5
; %bb.13:                               ; %B14.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB92_14:                               ; %B14
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB92_15 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB92_17
LBB92_15:                               ; %B25
                                        ;   Parent Loop BB92_14 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	LBB92_19
; %bb.16:                               ; %B30
                                        ;   in Loop: Header=BB92_15 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB92_15
LBB92_17:                               ; %B16
                                        ;   in Loop: Header=BB92_14 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB92_5
; %bb.18:                               ; %B19
                                        ;   in Loop: Header=BB92_14 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB92_14
	b	LBB92_21
LBB92_19:                               ; %B27
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB92_5
; %bb.20:                               ; %B28
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB92_21:                               ; %B22
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB92_22:                               ; %B10
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
	asr	w8, w8, #30
	cmp	w8, #1
	b.eq	LBB92_12
	b	LBB92_5
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_ref_value_0_asm_h
l_put_ref_value_0_asm_h:                ; @put_ref_value_0_asm_h
; %bb.0:                                ; %B70
	sub	sp, sp, #16
	ldp	x10, x22, [x20, #-24]
	ldur	x21, [x20, #-8]
	cmp	x10, #18
	b.eq	LBB93_7
; %bb.1:                                ; %B1
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x10, x8
	b.ne	LBB93_5
LBB93_2:                                ; %B56
	ldrh	w8, [x10, #6]
	cmp	w8, #1
	b.ne	LBB93_5
; %bb.3:                                ; %B3
	ldr	w8, [x10, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB93_5
; %bb.4:                                ; %B3
	mov	x9, #2                          ; =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.eq	LBB93_9
LBB93_5:                                ; %B60
	mov	x0, x24
	mov	x1, x10
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x20, [x23, #48]
	bl	_JS_SetPropertyValue_GC
	tbnz	w0, #31, LBB93_29
; %bb.6:                                ; %B62
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB93_7:                                ; %B66
	ldr	w8, [x23, #44]
	tbnz	w8, #0, LBB93_27
; %bb.8:                                ; %B67
	ldr	x10, [x24, #208]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x10, x8
	b.eq	LBB93_2
	b	LBB93_5
LBB93_9:                                ; %B9
	and	x1, x22, #0xfffffffffffc
	stp	x10, x20, [sp]                  ; 16-byte Folded Spill
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB93_30
; %bb.10:                               ; %B54
	ldr	w8, [x1, #8]
	asr	w8, w8, #30
	ldp	x10, x20, [sp]                  ; 16-byte Folded Reload
	cmp	w8, #1
	b.ne	LBB93_5
LBB93_11:                               ; %B11
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	ldp	x10, x20, [sp]                  ; 16-byte Folded Reload
	cbz	w0, LBB93_5
; %bb.12:                               ; %B13
	ldr	x8, [x10, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w0, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB93_15
LBB93_13:                               ; %B16
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	LBB93_21
; %bb.14:                               ; %B26
                                        ;   in Loop: Header=BB93_13 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB93_13
LBB93_15:                               ; %B28.preheader
	ldp	x8, x20, [sp]                   ; 16-byte Folded Reload
LBB93_16:                               ; %B28
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB93_17 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w0, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB93_19
LBB93_17:                               ; %B41
                                        ;   Parent Loop BB93_16 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	LBB93_24
; %bb.18:                               ; %B46
                                        ;   in Loop: Header=BB93_17 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB93_17
LBB93_19:                               ; %B29
                                        ;   in Loop: Header=BB93_16 Depth=1
	ldr	w9, [x8, #4]
	ldr	x10, [sp]                       ; 8-byte Folded Reload
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB93_5
; %bb.20:                               ; %B35
                                        ;   in Loop: Header=BB93_16 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB93_16
	b	LBB93_25
LBB93_21:                               ; %B18
	mov	w9, #58                         ; =0x3a
	and	w9, w9, w10, lsr #26
	ldp	x10, x20, [sp]                  ; 16-byte Folded Reload
	cmp	w9, #2
	b.ne	LBB93_5
; %bb.22:                               ; %B22
	ldr	x9, [x10, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB93_31
; %bb.23:                               ; %B20
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #16
	br	x1
LBB93_24:                               ; %B43
	mov	w8, #58                         ; =0x3a
	and	w8, w8, w10, lsr #26
	ldp	x10, x20, [sp]                  ; 16-byte Folded Reload
	cmp	w8, #2
	b.ne	LBB93_5
LBB93_25:                               ; %B32
	ldr	w8, [x10, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	LBB93_5
; %bb.26:                               ; %B33
	mov	w0, w0
	add	sp, sp, #16
	b	l_FastAddNamedProperty_asm_h
LBB93_27:                               ; %B63
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #48]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB93_29
; %bb.28:                               ; %B65
	mov	w1, w0
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB93_29:                               ; %B61
	add	sp, sp, #16
	b	l_exception_asm_h
LBB93_30:                               ; %B10
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
	asr	w8, w8, #30
	ldp	x10, x20, [sp]                  ; 16-byte Folded Reload
	cmp	w8, #1
	b.eq	LBB93_11
	b	LBB93_5
LBB93_31:                               ; %B24
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
	tbnz	w0, #31, LBB94_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB94_2:                                ; %B2
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
	tbnz	w0, #31, LBB95_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB95_2:                                ; %B2
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
	tbnz	w0, #31, LBB96_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	sub	x20, x20, #8
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB96_2:                                ; %B2
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
	b.ne	LBB97_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB97_2:                                ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB97_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB97_5
LBB97_3:                                ; %B1
                                        ;   Parent Loop BB97_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB97_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB97_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB97_3
LBB97_5:                                ; %B14
                                        ;   in Loop: Header=BB97_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB97_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB97_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB97_2
	b	LBB97_9
LBB97_7:                                ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB97_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB97_9:                                ; %B6
	ldrb	w9, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB97_10:                               ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB97_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB97_12:                               ; %B22
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
	b.ne	LBB98_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB98_2:                                ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB98_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB98_5
LBB98_3:                                ; %B1
                                        ;   Parent Loop BB98_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB98_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB98_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB98_3
LBB98_5:                                ; %B14
                                        ;   in Loop: Header=BB98_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB98_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB98_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB98_2
	b	LBB98_9
LBB98_7:                                ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB98_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB98_9:                                ; %B6
	ldrb	w9, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB98_10:                               ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB98_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB98_12:                               ; %B22
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
	b.ne	LBB99_18
; %bb.1:                                ; %B56
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB99_4
LBB99_2:                                ; %B1
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB99_10
; %bb.3:                                ; %B12
                                        ;   in Loop: Header=BB99_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB99_2
LBB99_4:                                ; %B17.preheader
	mov	x8, x22
LBB99_5:                                ; %B17
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB99_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w2, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB99_8
LBB99_6:                                ; %B18
                                        ;   Parent Loop BB99_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB99_13
; %bb.7:                                ; %B34
                                        ;   in Loop: Header=BB99_6 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB99_6
LBB99_8:                                ; %B41
                                        ;   in Loop: Header=BB99_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB99_18
; %bb.9:                                ; %B38
                                        ;   in Loop: Header=BB99_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB99_5
	b	LBB99_14
LBB99_10:                               ; %B3
	mov	w9, #58                         ; =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	LBB99_18
; %bb.11:                               ; %B7
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB99_22
LBB99_12:                               ; %B48
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB99_13:                               ; %B20
	mov	w8, #58                         ; =0x3a
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	LBB99_18
LBB99_14:                               ; %B23
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	LBB99_18
; %bb.15:                               ; %B25
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	LBB99_20
; %bb.16:                               ; %B25
	tbnz	w2, #31, LBB99_20
; %bb.17:                               ; %B31
	mov	x0, x2
	b	l_FastAddNamedProperty_asm_h
LBB99_18:                               ; %B52
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x20, [x23, #48]
                                        ; kill: def $w2 killed $w2 killed $x2
	bl	_JS_SetPropertyInternalImpl_GC
	tbz	w0, #31, LBB99_12
; %bb.19:                               ; %B53
	b	l_exception_asm_h
LBB99_20:                               ; %B45
	mov	x0, x24
	mov	x1, x22
	mov	w3, #7                          ; =0x7
	str	x20, [x23, #48]
                                        ; kill: def $w2 killed $w2 killed $x2
	bl	_add_property_gc
	cbz	x0, LBB99_23
; %bb.21:                               ; %B49
	str	x21, [x0]
	ldrb	w8, [x24, #376]
	cbz	w8, LBB99_12
LBB99_22:                               ; %B51
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB99_23:                               ; %B46
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
	b.eq	LBB100_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB100_2:                               ; %B2
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
	tbnz	w0, #31, LBB101_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB101_2:                               ; %B2
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
	tbnz	w0, #31, LBB102_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB102_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_array_el_0_asm_h
l_get_array_el_0_asm_h:                 ; @get_array_el_0_asm_h
; %bb.0:                                ; %B76
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB103_12
; %bb.1:                                ; %B73
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	LBB103_5
; %bb.2:                                ; %B1
	cmp	w8, #2
	b.ne	LBB103_10
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB103_14
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB103_5:                               ; %B33
	cmp	w8, #1
	b.ne	LBB103_12
; %bb.6:                                ; %B36
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB103_12
; %bb.7:                                ; %B36
	mov	x9, #2                          ; =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB103_12
; %bb.8:                                ; %B65
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB103_24
; %bb.9:                                ; %B68
	ldr	w8, [x1, #8]
	b	LBB103_25
LBB103_10:                              ; %B30
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB103_12
; %bb.11:                               ; %B30
	cmp	w8, #29
	b.le	LBB103_33
LBB103_12:                              ; %B70
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB103_34
; %bb.13:                               ; %B72
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB103_14:                              ; %B7
	tbnz	w21, #31, LBB103_12
; %bb.15:                               ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB103_16:                              ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB103_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB103_19
LBB103_17:                              ; %B10
                                        ;   Parent Loop BB103_16 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB103_21
; %bb.18:                               ; %B17
                                        ;   in Loop: Header=BB103_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB103_17
LBB103_19:                              ; %B24
                                        ;   in Loop: Header=BB103_16 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB103_12
; %bb.20:                               ; %B21
                                        ;   in Loop: Header=BB103_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB103_16
	b	LBB103_23
LBB103_21:                              ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB103_12
; %bb.22:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB103_23:                              ; %B51
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB103_24:                              ; %B66
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
LBB103_25:                              ; %B62
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	LBB103_12
; %bb.26:                               ; %B41
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	cbz	w0, LBB103_12
; %bb.27:                               ; %B44.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB103_28:                              ; %B44
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB103_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB103_31
LBB103_29:                              ; %B47
                                        ;   Parent Loop BB103_28 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	LBB103_35
; %bb.30:                               ; %B53
                                        ;   in Loop: Header=BB103_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB103_29
LBB103_31:                              ; %B58
                                        ;   in Loop: Header=BB103_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB103_12
; %bb.32:                               ; %B55
                                        ;   in Loop: Header=BB103_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB103_28
	b	LBB103_23
LBB103_33:                              ; %B31
	mov	x0, xzr
	b	l_FastTypedArrayGet_asm_h
LBB103_34:                              ; %B71
	b	l_exception_asm_h
LBB103_35:                              ; %B49
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB103_12
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
	b.ne	LBB104_12
; %bb.1:                                ; %B73
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	LBB104_5
; %bb.2:                                ; %B1
	cmp	w8, #2
	b.ne	LBB104_10
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB104_14
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #16
	add	w8, w8, #486
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB104_5:                               ; %B33
	cmp	w8, #1
	b.ne	LBB104_12
; %bb.6:                                ; %B36
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB104_12
; %bb.7:                                ; %B36
	mov	x9, #2                          ; =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB104_12
; %bb.8:                                ; %B65
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB104_24
; %bb.9:                                ; %B68
	ldr	w8, [x1, #8]
	b	LBB104_25
LBB104_10:                              ; %B30
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB104_12
; %bb.11:                               ; %B30
	cmp	w8, #29
	b.le	LBB104_33
LBB104_12:                              ; %B70
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB104_34
; %bb.13:                               ; %B72
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB104_14:                              ; %B7
	tbnz	w21, #31, LBB104_12
; %bb.15:                               ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB104_16:                              ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB104_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB104_19
LBB104_17:                              ; %B10
                                        ;   Parent Loop BB104_16 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB104_21
; %bb.18:                               ; %B17
                                        ;   in Loop: Header=BB104_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB104_17
LBB104_19:                              ; %B24
                                        ;   in Loop: Header=BB104_16 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB104_12
; %bb.20:                               ; %B21
                                        ;   in Loop: Header=BB104_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB104_16
	b	LBB104_23
LBB104_21:                              ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB104_12
; %bb.22:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB104_23:                              ; %B51
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB104_24:                              ; %B66
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
LBB104_25:                              ; %B62
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	LBB104_12
; %bb.26:                               ; %B41
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	cbz	w0, LBB104_12
; %bb.27:                               ; %B44.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB104_28:                              ; %B44
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB104_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB104_31
LBB104_29:                              ; %B47
                                        ;   Parent Loop BB104_28 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	LBB104_35
; %bb.30:                               ; %B53
                                        ;   in Loop: Header=BB104_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB104_29
LBB104_31:                              ; %B58
                                        ;   in Loop: Header=BB104_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB104_12
; %bb.32:                               ; %B55
                                        ;   in Loop: Header=BB104_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB104_28
	b	LBB104_23
LBB104_33:                              ; %B31
	mov	w0, #1                          ; =0x1
	b	l_FastTypedArrayGet_asm_h
LBB104_34:                              ; %B71
	b	l_exception_asm_h
LBB104_35:                              ; %B49
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB104_12
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
	b.ne	LBB105_45
; %bb.1:                                ; %B1
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x11, #6]
	cmp	x9, x22, lsr #48
	b.ne	LBB105_7
; %bb.2:                                ; %B3
	cmp	w8, #2
	b.ne	LBB105_12
; %bb.3:                                ; %B5
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB105_45
; %bb.4:                                ; %B50
	ldr	w8, [x11, #48]
	cmp	w22, w8
	b.hs	LBB105_15
; %bb.5:                                ; %B7
	ldr	x8, [x11, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB105_24
; %bb.6:                                ; %B9
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB105_7:                               ; %B59
	cmp	w8, #1
	b.ne	LBB105_45
; %bb.8:                                ; %B107
	ldr	w8, [x11, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB105_45
; %bb.9:                                ; %B107
	mov	x9, #2                          ; =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB105_45
; %bb.10:                               ; %B62
	and	x1, x22, #0xfffffffffffc
	stp	x11, x20, [sp]                  ; 16-byte Folded Spill
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB105_25
; %bb.11:                               ; %B106
	ldr	w8, [x1, #8]
	b	LBB105_26
LBB105_12:                              ; %B55
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB105_45
; %bb.13:                               ; %B55
	cmp	w8, #29
	b.gt	LBB105_45
; %bb.14:                               ; %B56
	add	sp, sp, #16
	b	l_FastTypedArraySet_asm_h
LBB105_15:                              ; %B12
	mov	x1, x11
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	b.ne	LBB105_37
; %bb.16:                               ; %B40
	ldr	w9, [x1, #4]
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x11, x1
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	b.ne	LBB105_45
; %bb.17:                               ; %B40
	ubfx	w9, w9, #8, #1
	cbz	w9, LBB105_45
; %bb.18:                               ; %B14
	ldr	x9, [x11, #8]
	ldr	x9, [x9, #32]
	cbz	x9, LBB105_20
; %bb.19:                               ; %B36
	ldr	w9, [x9, #4]
	ubfx	w9, w9, #13, #1
	cmp	w9, #1
	b.ne	LBB105_45
LBB105_20:                              ; %B32
	ldr	x9, [x11, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	LBB105_22
; %bb.21:                               ; %B32
	cmp	w9, w10
	b.hi	LBB105_39
LBB105_22:                              ; %B29
	ldr	w10, [x1, #32]
	cmp	w9, w10
	b.hi	LBB105_39
; %bb.23:                               ; %B25
	ldr	x10, [x1, #40]
	str	w9, [x1, #48]
	str	x21, [x10, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, LBB105_46
	b	LBB105_42
LBB105_24:                              ; %B11
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB105_25:                              ; %B63
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
LBB105_26:                              ; %B102
	asr	w8, w8, #30
	ldp	x11, x20, [sp]                  ; 16-byte Folded Reload
	cmp	w8, #1
	b.ne	LBB105_45
; %bb.27:                               ; %B64
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	ldp	x11, x20, [sp]                  ; 16-byte Folded Reload
	cbz	w0, LBB105_45
; %bb.28:                               ; %B66
	ldr	x8, [x11, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w0, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB105_31
LBB105_29:                              ; %B69
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	LBB105_40
; %bb.30:                               ; %B78
                                        ;   in Loop: Header=BB105_29 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB105_29
LBB105_31:                              ; %B80.preheader
	ldp	x8, x20, [sp]                   ; 16-byte Folded Reload
LBB105_32:                              ; %B80
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB105_33 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w0, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB105_35
LBB105_33:                              ; %B93
                                        ;   Parent Loop BB105_32 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	LBB105_43
; %bb.34:                               ; %B98
                                        ;   in Loop: Header=BB105_33 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB105_33
LBB105_35:                              ; %B81
                                        ;   in Loop: Header=BB105_32 Depth=1
	ldr	w9, [x8, #4]
	ldr	x11, [sp]                       ; 8-byte Folded Reload
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB105_45
; %bb.36:                               ; %B87
                                        ;   in Loop: Header=BB105_32 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB105_32
	b	LBB105_44
LBB105_37:                              ; %B44
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x11, x1
	tbnz	w22, #31, LBB105_45
; %bb.38:                               ; %B46
	mov	x0, x24
	mov	x1, x11
	mov	w2, w22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x20, [x23, #48]
	bl	_JS_SetArrayIntPropertyValue_GC
	tbz	w0, #31, LBB105_46
	b	LBB105_48
LBB105_39:                              ; %B20
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, x24
	mov	x2, x21
	mov	w3, #32768                      ; =0x8000
	str	x8, [x23, #48]
	bl	_add_fast_array_element_gc
	tbz	w0, #31, LBB105_46
	b	LBB105_48
LBB105_40:                              ; %B71
	mov	w9, #58                         ; =0x3a
	ldp	x11, x20, [sp]                  ; 16-byte Folded Reload
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	LBB105_45
; %bb.41:                               ; %B74
	ldr	x9, [x11, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, LBB105_46
LBB105_42:                              ; %B76
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #16
	br	x1
LBB105_43:                              ; %B95
	mov	w8, #58                         ; =0x3a
	ldp	x11, x20, [sp]                  ; 16-byte Folded Reload
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	LBB105_45
LBB105_44:                              ; %B84
	ldr	w8, [x11, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.eq	LBB105_47
LBB105_45:                              ; %B113
	mov	x0, x24
	mov	x1, x11
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	str	x20, [x23, #48]
	bl	_JS_SetPropertyValue_GC
	tbnz	w0, #31, LBB105_48
LBB105_46:                              ; %B73
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	sub	x20, x8, #24
	add	sp, sp, #16
	br	x1
LBB105_47:                              ; %B85
	mov	w0, w0
	add	sp, sp, #16
	b	l_FastAddNamedProperty_asm_h
LBB105_48:                              ; %B47
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
	cbz	w0, LBB106_3
; %bb.1:                                ; %B5
	ldur	x3, [x20, #-24]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB106_3
; %bb.2:                                ; %B7
	stur	x0, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB106_3:                               ; %B6
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
	b.eq	LBB107_3
; %bb.1:                                ; %B10
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_JS_ThrowTypeErrorNotAnObject
LBB107_2:                               ; %B6
	add	sp, sp, #16
	b	l_exception_asm_h
LBB107_3:                               ; %B1
	ldur	x1, [x20, #-16]
	mov	x0, x24
	str	x9, [sp, #8]                    ; 8-byte Folded Spill
	str	x20, [x23, #48]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB107_2
; %bb.4:                                ; %B5
	ldur	x3, [x20, #-8]
	ldur	x4, [x20, #-32]
	mov	w2, w0
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, x24
	mov	w5, #32768                      ; =0x8000
	str	x20, [x23, #48]
	bl	_JS_SetPropertyGeneric_GC
	tbnz	w0, #31, LBB107_2
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
	b.ne	LBB108_4
; %bb.1:                                ; %B29
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	LBB108_4
; %bb.2:                                ; %B23
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB108_4
; %bb.3:                                ; %B26
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.eq	LBB108_6
LBB108_4:                               ; %B20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #16391                      ; =0x4007
	str	x20, [x23, #48]
                                        ; kill: def $w2 killed $w2 killed $x2
	bl	_JS_DefinePropertyValue_GC
	tbnz	w0, #31, LBB108_11
LBB108_5:                               ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB108_6:                               ; %B27
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB108_9
LBB108_7:                               ; %B12
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB108_12
; %bb.8:                                ; %B14
                                        ;   in Loop: Header=BB108_7 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB108_7
LBB108_9:                               ; %B17
	tbnz	w2, #31, LBB108_4
; %bb.10:                               ; %B19
	mov	x0, x2
	b	l_FastAddNamedProperty_asm_h
LBB108_11:                              ; %B21
	b	l_exception_asm_h
LBB108_12:                              ; %B1
	lsr	w9, w10, #26
	and	w9, w9, #0xfffffff7
	cmp	w9, #7
	b.ne	LBB108_4
; %bb.13:                               ; %B5
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, LBB108_5
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
	tbnz	w0, #31, LBB109_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB109_2:                               ; %B2
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
	tbnz	w0, #31, LBB110_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB110_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function set_proto_0_asm_h
l_set_proto_0_asm_h:                    ; @set_proto_0_asm_h
; %bb.0:                                ; %B6
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	LBB111_3
; %bb.1:                                ; %B6
	cmp	x21, #2
	b.eq	LBB111_3
LBB111_2:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB111_3:                               ; %B1
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	_JS_SetPrototypeInternal_GC
	tbz	w0, #31, LBB111_2
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
	tbnz	w0, #31, LBB113_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB113_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function append_0_asm_h
l_append_0_asm_h:                       ; @append_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_js_append_enumerate_gc
	tbnz	w0, #31, LBB114_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB114_2:                               ; %B2
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
	tbnz	w0, #31, LBB115_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB115_2:                               ; %B2
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
	b.eq	LBB116_3
; %bb.1:                                ; %B15
	cmp	w8, #1
	b.ne	LBB116_4
; %bb.2:                                ; %B13
	mov	w8, #18                         ; =0x12
	mov	w11, #2048                      ; =0x800
	stp	x12, x8, [sp, #16]              ; 16-byte Folded Spill
	b	LBB116_5
LBB116_3:
	mov	w8, #18                         ; =0x12
	str	x12, [sp, #40]                  ; 8-byte Folded Spill
	mov	w11, #8706                      ; =0x2202
	str	x8, [sp, #24]                   ; 8-byte Folded Spill
	mov	w8, #18                         ; =0x12
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	b	LBB116_6
LBB116_4:                               ; %B14
	mov	w11, #4096                      ; =0x1000
	mov	w8, #18                         ; =0x12
	stp	x8, x12, [sp, #16]              ; 16-byte Folded Spill
LBB116_5:                               ; %B10
	mov	w8, #18                         ; =0x12
	str	x8, [sp, #40]                   ; 8-byte Folded Spill
LBB116_6:                               ; %B10
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
	tbnz	w0, #31, LBB116_9
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
	tbnz	w0, #31, LBB116_9
; %bb.8:                                ; %B7
	ldr	x9, [sp, #48]                   ; 8-byte Folded Reload
	ldrb	w8, [x9, #5]
	add	x19, x9, #6
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #64
	br	x1
LBB116_9:                               ; %B2
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
	cbz	w11, LBB117_11
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
	b.eq	LBB117_4
; %bb.2:                                ; %B11
	cmp	w8, #1
	b.ne	LBB117_5
; %bb.3:                                ; %B19
	mov	w8, #18                         ; =0x12
	mov	w13, #2048                      ; =0x800
	stp	x10, x8, [sp, #16]              ; 16-byte Folded Spill
	b	LBB117_6
LBB117_4:
	mov	w8, #18                         ; =0x12
	str	x10, [sp, #40]                  ; 8-byte Folded Spill
	mov	w13, #8706                      ; =0x2202
	str	x8, [sp, #24]                   ; 8-byte Folded Spill
	mov	w8, #18                         ; =0x12
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	b	LBB117_7
LBB117_5:                               ; %B20
	mov	w13, #4096                      ; =0x1000
	mov	w8, #18                         ; =0x12
	stp	x8, x10, [sp, #16]              ; 16-byte Folded Spill
LBB117_6:                               ; %B16
	mov	w8, #18                         ; =0x12
	str	x8, [sp, #40]                   ; 8-byte Folded Spill
LBB117_7:                               ; %B16
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
	tbnz	w0, #31, LBB117_10
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
	tbnz	w0, #31, LBB117_10
; %bb.9:                                ; %B7
	ldr	x9, [sp, #48]                   ; 8-byte Folded Reload
	ldrb	w8, [x9, #1]
	add	x19, x9, #2
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #64
	br	x1
LBB117_10:                              ; %B2
	ldp	x19, x20, [sp, #48]             ; 16-byte Folded Reload
LBB117_11:                              ; %B9
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
	tbnz	w0, #31, LBB118_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB118_2:                               ; %B2
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
	b.eq	LBB129_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB129_2:                               ; %B3
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc_check_0_asm_h
l_put_loc_check_0_asm_h:                ; @put_loc_check_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	LBB130_2
; %bb.1:                                ; %B4
	str	x22, [x27, w8, uxtw #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB130_2:                               ; %B3
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc_check_init_0_asm_h
l_put_loc_check_init_0_asm_h:           ; @put_loc_check_init_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	LBB131_2
; %bb.1:                                ; %B4
	str	x22, [x27, w8, uxtw #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB131_2:                               ; %B3
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
	.p2align	2                               ; -- Begin function put_var_ref_check_0_asm_h
l_put_var_ref_check_0_asm_h:            ; @put_var_ref_check_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	LBB133_2
; %bb.1:                                ; %B4
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB133_2:                               ; %B3
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
	b.ne	LBB134_2
; %bb.1:                                ; %B4
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB134_2:                               ; %B3
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
; %bb.0:                                ; %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	LBB136_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB136_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB136_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB136_6
	b	LBB136_7
LBB136_4:                               ; %B23
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.eq	LBB136_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB136_7
LBB136_6:                               ; %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB136_7:                               ; %B9
	mov	x9, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x9
	b.hs	LBB136_13
; %bb.8:                                ; %B11
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.lo	LBB136_10
LBB136_9:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB136_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB136_13
; %bb.11:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB136_6
	b.vs	LBB136_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB136_9
	b	LBB136_6
LBB136_13:                              ; %B15
	mov	x20, x8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_true_0_asm_h
l_if_true_0_asm_h:                      ; @if_true_0_asm_h
; %bb.0:                                ; %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	LBB137_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB137_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB137_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB137_6
	b	LBB137_7
LBB137_4:                               ; %B23
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.eq	LBB137_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB137_7
LBB137_6:                               ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB137_7:                               ; %B9
	mov	x9, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x9
	b.hs	LBB137_13
; %bb.8:                                ; %B11
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.lo	LBB137_10
LBB137_9:                               ; %B19
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB137_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB137_13
; %bb.11:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB137_6
	b.vs	LBB137_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB137_9
	b	LBB137_6
LBB137_13:                              ; %B15
	mov	x20, x8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto_0_asm_h
l_goto_0_asm_h:                         ; @goto_0_asm_h
; %bb.0:                                ; %B0
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
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
	b.ne	LBB141_3
; %bb.1:                                ; %B1
	ldr	x8, [x23, #8]
	ldr	x8, [x8, #32]
	ldr	w9, [x8, #16]
	cmp	w22, w9
	b.ge	LBB141_3
; %bb.2:                                ; %B5
	ldr	x8, [x8, #8]
	sub	x20, x20, #8
	add	x19, x8, w22, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB141_3:                               ; %B3
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
	b.ne	LBB142_2
; %bb.1:                                ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB142_2:                               ; %B1
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #48]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB142_4
; %bb.3:                                ; %B3
	mov	x22, x0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB142_4:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function to_propkey_0_asm_h
l_to_propkey_0_asm_h:                   ; @to_propkey_0_asm_h
; %bb.0:                                ; %B15
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	LBB143_4
; %bb.1:                                ; %B15
	mov	x9, #1                          ; =0x1
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB143_4
; %bb.2:                                ; %B15
	cmp	x8, x9
	b.eq	LBB143_4
; %bb.3:                                ; %B15
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB143_5
LBB143_4:                               ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB143_5:                               ; %B12
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB143_7
; %bb.6:                                ; %B14
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB143_7:                               ; %B13
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function to_propkey2_0_asm_h
l_to_propkey2_0_asm_h:                  ; @to_propkey2_0_asm_h
; %bb.0:                                ; %B18
	ldp	x22, x21, [x20, #-16]
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	LBB144_3
; %bb.1:                                ; %B19
Lloh16:
	adrp	x1, l___unnamed_9@PAGE
Lloh17:
	add	x1, x1, l___unnamed_9@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_LEPUS_ThrowTypeError
LBB144_2:                               ; %B16
	b	l_exception_asm_h
LBB144_3:                               ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	LBB144_7
; %bb.4:                                ; %B2
	mov	x9, #1                          ; =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB144_7
; %bb.5:                                ; %B2
	cmp	x8, x9
	b.eq	LBB144_7
; %bb.6:                                ; %B2
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB144_8
LBB144_7:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB144_8:                               ; %B15
	mov	x0, x24
	mov	x1, x21
	str	x20, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB144_2
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
	tbnz	w0, #31, LBB145_4
; %bb.1:                                ; %B4
	cbz	w0, LBB145_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB145_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB145_4:                               ; %B2
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
	tbnz	w0, #31, LBB146_4
; %bb.1:                                ; %B4
	cbz	w0, LBB146_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	sub	x20, x20, #16
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB146_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB146_4:                               ; %B2
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
	tbnz	w0, #31, LBB147_4
; %bb.1:                                ; %B4
	cbz	w0, LBB147_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB147_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB147_4:                               ; %B2
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
	tbnz	w0, #31, LBB148_4
; %bb.1:                                ; %B4
	cbz	w0, LBB148_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
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
	tbnz	w0, #31, LBB149_4
; %bb.1:                                ; %B4
	cbz	w0, LBB149_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
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
	tbnz	w0, #31, LBB150_4
; %bb.1:                                ; %B4
	cbz	w0, LBB150_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
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
	.p2align	2                               ; -- Begin function make_loc_ref_0_asm_h
l_make_loc_ref_0_asm_h:                 ; @make_loc_ref_0_asm_h
; %bb.0:                                ; %B16
	sub	sp, sp, #16
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	LBB151_6
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
	cbz	x8, LBB151_6
; %bb.2:                                ; %B6
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #34                         ; =0x22
	str	x20, [x23, #48]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	bl	_add_property_gc
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	cbz	x0, LBB151_6
; %bb.3:                                ; %B9
	mov	x8, #2                          ; =0x2
	movk	x8, #65533, lsl #48
	orr	x8, x9, x8
	str	x8, [x0]
	ldrb	w9, [x24, #376]
	cbnz	w9, LBB151_7
LBB151_4:                               ; %B13
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB151_6
; %bb.5:                                ; %B15
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB151_6:                               ; %B14
	add	sp, sp, #16
	b	l_exception_asm_h
LBB151_7:                               ; %B12
	mov	x0, x8
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB151_4
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
	b.eq	LBB152_6
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
	cbz	x8, LBB152_6
; %bb.2:                                ; %B6
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #34                         ; =0x22
	str	x20, [x23, #48]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	bl	_add_property_gc
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	cbz	x0, LBB152_6
; %bb.3:                                ; %B9
	mov	x8, #2                          ; =0x2
	movk	x8, #65533, lsl #48
	orr	x8, x9, x8
	str	x8, [x0]
	ldrb	w9, [x24, #376]
	cbnz	w9, LBB152_7
LBB152_4:                               ; %B13
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB152_6
; %bb.5:                                ; %B15
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB152_6:                               ; %B14
	add	sp, sp, #16
	b	l_exception_asm_h
LBB152_7:                               ; %B12
	mov	x0, x8
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB152_4
                                        ; -- End function
	.p2align	2                               ; -- Begin function make_var_ref_ref_0_asm_h
l_make_var_ref_ref_0_asm_h:             ; @make_var_ref_ref_0_asm_h
; %bb.0:                                ; %B12
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x20, [x23, #48]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	LBB153_5
; %bb.1:                                ; %B1
	mov	x1, x0
	mov	w8, #18                         ; =0x12
	mov	x0, x24
	stp	x1, x8, [x20], #16
	mov	w3, #34                         ; =0x22
	ldr	w2, [x19]
	str	x20, [x23, #48]
	bl	_add_property_gc
	cbz	x0, LBB153_5
; %bb.2:                                ; %B4
	ldrh	w8, [x19, #4]
	mov	x9, #2                          ; =0x2
	movk	x9, #65533, lsl #48
	ldr	x8, [x26, x8, lsl #3]
	orr	x8, x8, x9
	str	x8, [x0]
	ldrb	w9, [x24, #376]
	cbnz	w9, LBB153_6
LBB153_3:                               ; %B9
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB153_5
; %bb.4:                                ; %B11
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB153_5:                               ; %B10
	b	l_exception_asm_h
LBB153_6:                               ; %B7
	mov	x0, x8
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB153_3
                                        ; -- End function
	.p2align	2                               ; -- Begin function make_var_ref_0_asm_h
l_make_var_ref_0_asm_h:                 ; @make_var_ref_0_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x20
	str	x20, [x23, #48]
	bl	_JS_GetGlobalVarRef_GC
	tbnz	w0, #31, LBB154_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB154_2:                               ; %B2
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
	b.eq	LBB155_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB155_2:                               ; %B2
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
	tbnz	w0, #31, LBB156_2
; %bb.1:                                ; %B3
	mov	w8, #66                         ; =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB156_2:                               ; %B2
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
	tbnz	w0, #31, LBB157_2
; %bb.1:                                ; %B3
	mov	w8, #66                         ; =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB157_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_in_next_0_asm_h
l_for_in_next_0_asm_h:                  ; @for_in_next_0_asm_h
; %bb.0:                                ; %B65
	ldur	x8, [x20, #-8]
	mov	x11, #2                         ; =0x2
	movk	x11, #65535, lsl #48
	tst	x8, x11
	b.ne	LBB158_4
; %bb.1:                                ; %B62
	ldrh	w9, [x8, #6]
	cmp	w9, #17
	b.ne	LBB158_4
; %bb.2:                                ; %B1
	ldr	x8, [x8, #32]
	cbz	x8, LBB158_4
; %bb.3:                                ; %B9
	ldp	w9, w10, [x8, #8]
	cmp	w9, w10
	b.lo	LBB158_6
LBB158_4:                               ; %B4
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_js_for_in_next_gc
	tbnz	w0, #31, LBB158_27
; %bb.5:                                ; %B6
	ldrb	w8, [x19], #1
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB158_6:                               ; %B11
	ldr	x10, [x8]
	tst	x10, x11
	b.ne	LBB158_4
; %bb.7:                                ; %B13
	ldrb	w11, [x8, #17]
	cbnz	w11, LBB158_21
; %bb.8:                                ; %B37
	ldrb	w11, [x8, #16]
	cbnz	w11, LBB158_4
; %bb.9:                                ; %B40
	ldr	x11, [x8, #24]
	cbz	x11, LBB158_4
; %bb.10:                               ; %B57
	lsl	w12, w9, #3
	add	x11, x11, x12
	ldr	w12, [x11]
	cbz	w12, LBB158_15
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
	cbz	w12, LBB158_14
LBB158_12:                              ; %B52
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w12, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w1
	b.eq	LBB158_16
; %bb.13:                               ; %B54
                                        ;   in Loop: Header=BB158_12 Depth=1
	and	w12, w12, #0x3ffffff
	cbnz	w12, LBB158_12
LBB158_14:                              ; %B46
	ldr	w10, [x10, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB158_4
LBB158_15:                              ; %B49
	add	w9, w9, #1
	str	w9, [x8, #8]
	b	LBB158_4
LBB158_16:                              ; %B43
	lsr	w10, w12, #26
	tst	w10, #0x30
	b.ne	LBB158_4
; %bb.17:                               ; %B44
	add	w9, w9, #1
	str	w9, [x8, #8]
	tbnz	w1, #31, LBB158_25
LBB158_18:                              ; %B18
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, sxtw #3]
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, LBB158_24
; %bb.19:                               ; %B28
	ldr	w9, [x8, #8]
	asr	w9, w9, #30
	cmp	w9, #1
	b.ne	LBB158_25
LBB158_20:                              ; %B26
	mov	x9, #2                          ; =0x2
	movk	x9, #1, lsl #48
	orr	x8, x8, x9
	mov	w9, #6                          ; =0x6
	stp	x8, x9, [x20], #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB158_21:                              ; %B33
	ldr	w11, [x10, #4]
	ubfx	w11, w11, #11, #1
	cmp	w11, #1
	b.ne	LBB158_4
; %bb.22:                               ; %B15
	ldr	w10, [x10, #48]
	cmp	w9, w10
	b.hs	LBB158_4
; %bb.23:                               ; %B16
	add	w10, w9, #1
	orr	w1, w9, #0x80000000
	str	w10, [x8, #8]
	tbz	w1, #31, LBB158_18
	b	LBB158_25
LBB158_24:                              ; %B19
	ldr	x9, [x8, #8]
	ldr	w9, [x9]
	asr	w9, w9, #30
	cmp	w9, #1
	b.eq	LBB158_20
LBB158_25:                              ; %B23
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB158_27
; %bb.26:                               ; %B25
	mov	w8, #6                          ; =0x6
	stp	x0, x8, [x20], #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB158_27:                              ; %B5
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
	tbnz	w0, #31, LBB159_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB159_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function for_await_of_next_0_asm_h
l_for_await_of_next_0_asm_h:            ; @for_await_of_next_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_js_for_await_of_next_gc
	tbnz	w0, #31, LBB160_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB160_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function iterator_get_value_done_0_asm_h
l_iterator_get_value_done_0_asm_h:      ; @iterator_get_value_done_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #48]
	bl	_js_iterator_get_value_done_gc
	tbnz	w0, #31, LBB161_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB161_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function iterator_close_0_asm_h
l_iterator_close_0_asm_h:               ; @iterator_close_0_asm_h
; %bb.0:                                ; %B6
	ldur	x1, [x20, #-24]
	sub	x20, x20, #16
	cmp	x1, #18
	b.eq	LBB162_2
; %bb.1:                                ; %B1
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #48]
	bl	_JS_IteratorClose
	tbnz	w0, #31, LBB162_3
LBB162_2:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB162_3:                               ; %B2
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
	b	LBB163_2
LBB163_1:                               ; %B10
                                        ;   in Loop: Header=BB163_2 Depth=1
	sub	x20, x20, #8
LBB163_2:                               ; %B2
                                        ; =>This Inner Loop Header: Depth=1
	cmp	x20, x9
	b.le	LBB163_5
; %bb.3:                                ; %B4
                                        ;   in Loop: Header=BB163_2 Depth=1
	ldur	x11, [x20, #-8]
	tst	x11, #0xffff000000000000
	b.ne	LBB163_1
; %bb.4:                                ; %B4
                                        ;   in Loop: Header=BB163_2 Depth=1
	and	x11, x11, x10
	cmp	x11, #66
	b.ne	LBB163_1
LBB163_5:                               ; %B7
	add	x9, x9, #24
	cmp	x20, x9
	add	x20, x20, #8
	b.lt	LBB163_7
; %bb.6:                                ; %B9
	ldur	x9, [x20, #-16]
	ldur	q0, [x20, #-32]
	stur	x8, [x20, #-32]
	stur	x9, [x20, #-8]
	stur	q0, [x20, #-24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB163_7:                               ; %B8
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
	tbnz	w0, #31, LBB164_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB164_2:                               ; %B2
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
	b.eq	LBB165_2
; %bb.1:                                ; %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB165_2:                               ; %B2
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
	tbnz	w0, #31, LBB166_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB166_2:                               ; %B2
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
	b.hi	LBB172_3
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB172_6
; %bb.2:                                ; %B13
	orr	w8, w22, #0x80000000
	mov	w9, #-2147483648                ; =0x80000000
	cmp	w8, w9
	b.ne	LBB172_5
LBB172_3:                               ; %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        ; =0x8c
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB172_8
; %bb.4:                                ; %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB172_5:                               ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB172_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB172_3
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
LBB172_8:                               ; %B17
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function plus_0_asm_h
l_plus_0_asm_h:                         ; @plus_0_asm_h
; %bb.0:                                ; %B13
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB173_4
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB173_3
LBB173_2:                               ; %B7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB173_3:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.ne	LBB173_2
LBB173_4:                               ; %B10
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        ; =0x8d
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB173_6
; %bb.5:                                ; %B12
	mov	x22, x0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB173_6:                               ; %B11
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function dec_0_asm_h
l_dec_0_asm_h:                          ; @dec_0_asm_h
; %bb.0:                                ; %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB174_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB174_4
; %bb.2:                                ; %B13
	subs	w8, w22, #1
	b.vs	LBB174_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB174_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB174_6
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
LBB174_6:                               ; %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        ; =0x8e
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB174_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB174_8:                               ; %B17
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function inc_0_asm_h
l_inc_0_asm_h:                          ; @inc_0_asm_h
; %bb.0:                                ; %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB175_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB175_4
; %bb.2:                                ; %B13
	adds	w8, w22, #1
	b.vs	LBB175_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB175_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB175_6
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
LBB175_6:                               ; %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        ; =0x8f
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB175_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB175_8:                               ; %B17
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function post_dec_0_asm_h
l_post_dec_0_asm_h:                     ; @post_dec_0_asm_h
; %bb.0:                                ; %B16
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB176_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB176_4
; %bb.2:                                ; %B13
	subs	w8, w22, #1
	b.vs	LBB176_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB176_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB176_6
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
LBB176_6:                               ; %B5
	mov	w0, #144                        ; =0x90
	b	l_SlowJSPostInc_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function post_inc_0_asm_h
l_post_inc_0_asm_h:                     ; @post_inc_0_asm_h
; %bb.0:                                ; %B16
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB177_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB177_4
; %bb.2:                                ; %B13
	adds	w8, w22, #1
	b.vs	LBB177_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB177_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB177_6
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
LBB177_6:                               ; %B5
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
	b.hi	LBB178_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB178_4
; %bb.2:                                ; %B13
	subs	w9, w1, #1
	b.vs	LBB178_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB178_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB178_6
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
LBB178_6:                               ; %B16
	mov	x0, x24
	mov	w2, #142                        ; =0x8e
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB178_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB178_8:                               ; %B17
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function inc_loc_0_asm_h
l_inc_loc_0_asm_h:                      ; @inc_loc_0_asm_h
; %bb.0:                                ; %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	LBB179_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB179_4
; %bb.2:                                ; %B13
	adds	w9, w1, #1
	b.vs	LBB179_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB179_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB179_6
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
LBB179_6:                               ; %B16
	mov	x0, x24
	mov	w2, #143                        ; =0x8f
	str	x20, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB179_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB179_8:                               ; %B17
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
	b.hi	LBB180_15
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB180_5
; %bb.2:                                ; %B26
	cmp	x22, x9
	b.lo	LBB180_8
; %bb.3:                                ; %B36
	adds	w9, w1, w22
	sub	x20, x20, #8
	b.vs	LBB180_12
; %bb.4:                                ; %B42
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB180_5:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB180_15
; %bb.6:                                ; %B11
	cmp	x22, x9
	b.lo	LBB180_13
; %bb.7:                                ; %B21
	scvtf	d0, w22
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	LBB180_11
LBB180_8:                               ; %B28
	tst	x22, #0xfffe000000000000
	b.eq	LBB180_15
; %bb.9:                                ; %B31
	scvtf	d0, w1
	add	x9, x22, x9
LBB180_10:                              ; %B31
	fmov	d1, x9
	fadd	d0, d0, d1
LBB180_11:                              ; %B31
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
LBB180_12:                              ; %B38
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
LBB180_13:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB180_15
; %bb.14:                               ; %B16
	add	x10, x1, x9
	add	x9, x22, x9
	fmov	d0, x10
	b	LBB180_10
LBB180_15:                              ; %B7
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
	b.ne	LBB180_18
; %bb.16:                               ; %B43
	mov	x0, x24
	mov	x2, x22
	str	x20, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB180_19
; %bb.17:                               ; %B45
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB180_18:                              ; %B8
	mov	w0, #1                          ; =0x1
	b	l_FastJSConcatString_asm_h
LBB180_19:                              ; %B44
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function not_0_asm_h
l_not_0_asm_h:                          ; @not_0_asm_h
; %bb.0:                                ; %B2
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB181_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB181_2:                               ; %B4
	mov	x0, x22
	b	l_SlowJSNot_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lnot_0_asm_h
l_lnot_0_asm_h:                         ; @lnot_0_asm_h
; %bb.0:                                ; %B14
	ldur	x22, [x20, #-8]
	cmp	x22, #5
	b.le	LBB182_4
; %bb.1:                                ; %B14
	cmp	x22, #6
	b.eq	LBB182_6
; %bb.2:                                ; %B14
	cmp	x22, #7
	b.eq	LBB182_8
; %bb.3:                                ; %B14
	cmp	x22, #18
	b.eq	LBB182_6
	b	LBB182_7
LBB182_4:                               ; %B14
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB182_6
; %bb.5:                                ; %B14
	cmp	x22, #2
	b.ne	LBB182_7
LBB182_6:                               ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB182_7:                               ; %B10
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB182_9
LBB182_8:                               ; %B12
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB182_9:                               ; %B13
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
	b.eq	LBB183_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB183_2:                               ; %B2
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
	b.eq	LBB184_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB184_2:                               ; %B2
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
	tbnz	w0, #31, LBB185_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB185_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function mul_0_asm_h
l_mul_0_asm_h:                          ; @mul_0_asm_h
; %bb.0:                                ; %B51
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB186_19
; %bb.1:                                ; %B51
	cmp	x21, x8
	b.hi	LBB186_19
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB186_8
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB186_11
; %bb.4:                                ; %B33
	smull	x8, w22, w21
	sub	x20, x20, #16
	cmp	x8, w8, sxtw
	b.ne	LBB186_15
; %bb.5:                                ; %B40
	cbnz	w8, LBB186_7
; %bb.6:                                ; %B40
	orr	w9, w22, w21
	tbnz	w9, #31, LBB186_16
LBB186_7:                               ; %B47
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB186_8:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB186_19
; %bb.9:                                ; %B7
	cmp	x21, x8
	b.lo	LBB186_17
; %bb.10:                               ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	LBB186_14
LBB186_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB186_19
; %bb.12:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB186_13:                              ; %B28
	fmov	d1, x8
	fmul	d0, d0, d1
LBB186_14:                              ; %B28
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
LBB186_15:                              ; %B35
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
LBB186_16:                              ; %B44
	mov	x22, #-9222809086901354496      ; =0x8002000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB186_17:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB186_19
; %bb.18:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB186_13
LBB186_19:                              ; %B48
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        ; =0x9a
	str	x20, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB186_21
; %bb.20:                               ; %B50
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB186_21:                              ; %B49
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function div_0_asm_h
l_div_0_asm_h:                          ; @div_0_asm_h
; %bb.0:                                ; %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB187_14
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB187_14
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB187_5
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB187_8
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
LBB187_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB187_14
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB187_12
; %bb.7:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	LBB187_11
LBB187_8:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB187_14
; %bb.9:                                ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB187_10:                              ; %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
LBB187_11:                              ; %B28
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
LBB187_12:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB187_14
; %bb.13:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB187_10
LBB187_14:                              ; %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        ; =0x9b
	str	x20, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB187_16
; %bb.15:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB187_16:                              ; %B42
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function mod_0_asm_h
l_mod_0_asm_h:                          ; @mod_0_asm_h
; %bb.0:                                ; %B39
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB188_16
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB188_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB188_7
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB188_10
; %bb.4:                                ; %B33
	tbnz	w22, #31, LBB188_16
; %bb.5:                                ; %B33
	cmp	w21, #1
	b.lt	LBB188_16
; %bb.6:                                ; %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB188_7:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB188_16
; %bb.8:                                ; %B7
	cmp	x21, x8
	b.lo	LBB188_14
; %bb.9:                                ; %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	LBB188_13
LBB188_10:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB188_16
; %bb.11:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB188_12:                              ; %B28
	fmov	d1, x8
LBB188_13:                              ; %B28
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
LBB188_14:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB188_16
; %bb.15:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB188_12
LBB188_16:                              ; %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        ; =0x9c
	str	x20, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB188_18
; %bb.17:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB188_18:                              ; %B37
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function add_0_asm_h
l_add_0_asm_h:                          ; @add_0_asm_h
; %bb.0:                                ; %B46
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB189_16
; %bb.1:                                ; %B46
	cmp	x21, x8
	b.hi	LBB189_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB189_6
; %bb.3:                                ; %B26
	cmp	x21, x8
	b.lo	LBB189_9
; %bb.4:                                ; %B36
	adds	w8, w22, w21
	sub	x20, x20, #16
	b.vs	LBB189_13
; %bb.5:                                ; %B42
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB189_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB189_16
; %bb.7:                                ; %B11
	cmp	x21, x8
	b.lo	LBB189_14
; %bb.8:                                ; %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	LBB189_12
LBB189_9:                               ; %B28
	tst	x21, #0xfffe000000000000
	b.eq	LBB189_16
; %bb.10:                               ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB189_11:                              ; %B31
	fmov	d1, x8
	fadd	d0, d0, d1
LBB189_12:                              ; %B31
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
LBB189_13:                              ; %B38
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
LBB189_14:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB189_16
; %bb.15:                               ; %B16
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB189_11
LBB189_16:                              ; %B7
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
	b.ne	LBB189_19
; %bb.17:                               ; %B7
	cbz	w8, LBB189_19
; %bb.18:                               ; %B8
	mov	x0, xzr
	b	l_FastJSConcatString_asm_h
LBB189_19:                              ; %B43
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB189_21
; %bb.20:                               ; %B45
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB189_21:                              ; %B44
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function sub_0_asm_h
l_sub_0_asm_h:                          ; @sub_0_asm_h
; %bb.0:                                ; %B43
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB190_16
; %bb.1:                                ; %B43
	cmp	x21, x8
	b.hi	LBB190_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB190_6
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB190_9
; %bb.4:                                ; %B33
	subs	w8, w22, w21
	sub	x20, x20, #16
	b.vs	LBB190_13
; %bb.5:                                ; %B39
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB190_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB190_16
; %bb.7:                                ; %B7
	cmp	x21, x8
	b.lo	LBB190_14
; %bb.8:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	LBB190_12
LBB190_9:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB190_16
; %bb.10:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB190_11:                              ; %B28
	fmov	d1, x8
	fsub	d0, d0, d1
LBB190_12:                              ; %B28
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
LBB190_13:                              ; %B35
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
LBB190_14:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB190_16
; %bb.15:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB190_11
LBB190_16:                              ; %B40
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        ; =0x9e
	str	x20, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB190_18
; %bb.17:                               ; %B42
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB190_18:                              ; %B41
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
	b.eq	LBB191_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB191_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function shl_0_asm_h
l_shl_0_asm_h:                          ; @shl_0_asm_h
; %bb.0:                                ; %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB192_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB192_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB192_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB192_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB192_5:                               ; %B16
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #16
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB192_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB192_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB192_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB192_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB192_5
LBB192_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        ; =0xa0
	str	x20, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB192_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB192_12:                              ; %B26
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function sar_0_asm_h
l_sar_0_asm_h:                          ; @sar_0_asm_h
; %bb.0:                                ; %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB193_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB193_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB193_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB193_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB193_5:                               ; %B16
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #16
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB193_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB193_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB193_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB193_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB193_5
LBB193_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        ; =0xa1
	str	x20, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB193_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB193_12:                              ; %B26
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function shr_0_asm_h
l_shr_0_asm_h:                          ; @shr_0_asm_h
; %bb.0:                                ; %B36
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB194_11
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB194_11
; %bb.2:                                ; %B10
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB194_6
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB194_11
; %bb.4:                                ; %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, LBB194_10
LBB194_5:                               ; %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB194_6:                               ; %B12
	tst	x22, #0xfffe000000000000
	b.eq	LBB194_11
; %bb.7:                                ; %B12
	cmp	x21, x8
	b.lo	LBB194_11
; %bb.8:                                ; %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB194_11
; %bb.9:                                ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, LBB194_5
LBB194_10:                              ; %B6
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
LBB194_11:                              ; %B33
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #48]
	bl	_prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	LBB194_13
; %bb.12:                               ; %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB194_13:                              ; %B34
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lt_0_asm_h
l_lt_0_asm_h:                           ; @lt_0_asm_h
; %bb.0:                                ; %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB195_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB195_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB195_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB195_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, lt
	br	x1
LBB195_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB195_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB195_10
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
LBB195_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB195_12
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
LBB195_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB195_12
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
LBB195_12:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        ; =0xa3
	str	x20, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB195_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB195_14:                              ; %B22
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lte_0_asm_h
l_lte_0_asm_h:                          ; @lte_0_asm_h
; %bb.0:                                ; %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB196_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB196_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB196_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB196_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, le
	br	x1
LBB196_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB196_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB196_10
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
LBB196_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB196_12
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
LBB196_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB196_12
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
LBB196_12:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        ; =0xa4
	str	x20, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB196_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB196_14:                              ; %B22
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function gt_0_asm_h
l_gt_0_asm_h:                           ; @gt_0_asm_h
; %bb.0:                                ; %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB197_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB197_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB197_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB197_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB197_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB197_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB197_10
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
LBB197_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB197_12
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
LBB197_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB197_12
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
LBB197_12:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        ; =0xa5
	str	x20, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB197_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB197_14:                              ; %B22
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function gte_0_asm_h
l_gte_0_asm_h:                          ; @gte_0_asm_h
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
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
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
	cinc	x22, x8, ge
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
	cinc	x22, x8, ge
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
	cinc	x22, x8, ge
	br	x1
LBB198_12:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        ; =0xa6
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
	b.eq	LBB199_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB199_2:                               ; %B2
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
	b.eq	LBB200_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB200_2:                               ; %B2
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function eq_0_asm_h
l_eq_0_asm_h:                           ; @eq_0_asm_h
; %bb.0:                                ; %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB201_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB201_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB201_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB201_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB201_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB201_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB201_11
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
LBB201_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB201_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB201_10:                              ; %B39
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
LBB201_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB201_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB201_10
LBB201_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB201_15
LBB201_14:                              ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB201_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB201_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB201_14
	b	LBB201_20
LBB201_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB201_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB201_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB201_21
LBB201_20:                              ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB201_21:                              ; %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB201_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB201_23:                              ; %B42
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function neq_0_asm_h
l_neq_0_asm_h:                          ; @neq_0_asm_h
; %bb.0:                                ; %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB202_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB202_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB202_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB202_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB202_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB202_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB202_11
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
LBB202_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB202_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB202_10:                              ; %B39
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
LBB202_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB202_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB202_10
LBB202_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB202_15
LBB202_14:                              ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB202_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB202_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB202_14
	b	LBB202_20
LBB202_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB202_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB202_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB202_21
LBB202_20:                              ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB202_21:                              ; %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB202_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB202_23:                              ; %B42
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function strict_eq_0_asm_h
l_strict_eq_0_asm_h:                    ; @strict_eq_0_asm_h
; %bb.0:                                ; %B39
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB203_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB203_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB203_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB203_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB203_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB203_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB203_11
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
LBB203_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB203_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB203_10:                              ; %B34
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
LBB203_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB203_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB203_10
LBB203_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB203_15
; %bb.14:                               ; %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB203_15:                              ; %B13
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
	b.ne	LBB203_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB203_22
LBB203_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB203_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB203_23
LBB203_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB203_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB203_25
LBB203_21:                              ; %B21
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB203_22:                              ; %B14
	mov	x0, xzr
	b	l_FastStringEqual_asm_h
LBB203_23:                              ; %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB203_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB203_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #16
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB203_28
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB203_27:                              ; %B37
	b	l_exception_asm_h
LBB203_28:                              ; %B8
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
	b.hi	LBB204_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB204_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB204_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB204_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB204_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB204_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB204_11
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
LBB204_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB204_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB204_10:                              ; %B34
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
LBB204_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB204_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB204_10
LBB204_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB204_15
; %bb.14:                               ; %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB204_15:                              ; %B13
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
	b.ne	LBB204_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB204_22
LBB204_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB204_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB204_23
LBB204_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB204_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB204_25
LBB204_21:                              ; %B21
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB204_22:                              ; %B14
	mov	w0, #1                          ; =0x1
	b	l_FastStringEqual_asm_h
LBB204_23:                              ; %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB204_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB204_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #16
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB204_28
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB204_27:                              ; %B37
	b	l_exception_asm_h
LBB204_28:                              ; %B8
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
	b.hi	LBB205_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB205_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB205_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB205_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB205_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	and	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB205_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB205_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB205_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB205_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB205_5
LBB205_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        ; =0xad
	str	x20, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB205_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB205_12:                              ; %B26
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function xor_0_asm_h
l_xor_0_asm_h:                          ; @xor_0_asm_h
; %bb.0:                                ; %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB206_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB206_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB206_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB206_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB206_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	eor	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB206_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB206_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB206_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB206_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB206_5
LBB206_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        ; =0xae
	str	x20, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB206_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB206_12:                              ; %B26
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function or_0_asm_h
l_or_0_asm_h:                           ; @or_0_asm_h
; %bb.0:                                ; %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB207_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB207_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB207_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB207_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB207_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	orr	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB207_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB207_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB207_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB207_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB207_5
LBB207_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        ; =0xaf
	str	x20, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB207_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB207_12:                              ; %B26
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
; %bb.0:                                ; %B0
	ldrb	w9, [x19, #1]
	ldr	x8, [x23, #104]
	ldrb	w10, [x19], #2
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x22, [x8, x10, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function fclosure8_0_asm_h
l_fclosure8_0_asm_h:                    ; @fclosure8_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x23, #104]
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
	b.eq	LBB222_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB222_2:                               ; %B2
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
	b.ne	LBB262_2
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
LBB262_2:                               ; %B21
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB262_12
; %bb.3:                                ; %B22
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB262_4:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB262_5 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w11, #0x30
	ldr	w10, [x13, w10, uxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB262_7
LBB262_5:                               ; %B1
                                        ;   Parent Loop BB262_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, #48
	b.eq	LBB262_9
; %bb.6:                                ; %B9
                                        ;   in Loop: Header=BB262_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB262_5
LBB262_7:                               ; %B14
                                        ;   in Loop: Header=BB262_4 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB262_12
; %bb.8:                                ; %B17
                                        ;   in Loop: Header=BB262_4 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB262_4
	b	LBB262_11
LBB262_9:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB262_12
; %bb.10:                               ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB262_11:                              ; %B6
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB262_12:                              ; %B24
	mov	x0, x24
	mov	x1, x22
	mov	w2, #48                         ; =0x30
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB262_14
; %bb.13:                               ; %B26
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB262_14:                              ; %B25
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_false8_0_asm_h
l_if_false8_0_asm_h:                    ; @if_false8_0_asm_h
; %bb.0:                                ; %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	LBB263_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB263_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB263_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB263_6
	b	LBB263_7
LBB263_4:                               ; %B23
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.eq	LBB263_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB263_7
LBB263_6:                               ; %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB263_7:                               ; %B9
	mov	x9, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x9
	b.hs	LBB263_13
; %bb.8:                                ; %B11
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.lo	LBB263_10
LBB263_9:                               ; %B19
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB263_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB263_13
; %bb.11:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB263_6
	b.vs	LBB263_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB263_9
	b	LBB263_6
LBB263_13:                              ; %B15
	mov	x20, x8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_true8_0_asm_h
l_if_true8_0_asm_h:                     ; @if_true8_0_asm_h
; %bb.0:                                ; %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	LBB264_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB264_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB264_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB264_6
	b	LBB264_7
LBB264_4:                               ; %B23
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.eq	LBB264_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB264_7
LBB264_6:                               ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB264_7:                               ; %B9
	mov	x9, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x9
	b.hs	LBB264_13
; %bb.8:                                ; %B11
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.lo	LBB264_10
LBB264_9:                               ; %B19
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB264_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB264_13
; %bb.11:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB264_6
	b.vs	LBB264_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB264_9
	b	LBB264_6
LBB264_13:                              ; %B15
	mov	x20, x8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto8_0_asm_h
l_goto8_0_asm_h:                        ; @goto8_0_asm_h
; %bb.0:                                ; %B0
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto16_0_asm_h
l_goto16_0_asm_h:                       ; @goto16_0_asm_h
; %bb.0:                                ; %B0
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
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
	ldr	x26, [x23, #96]
	b.eq	LBB267_2
; %bb.1:                                ; %B4
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB267_2:                               ; %B3
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
	ldr	x26, [x23, #96]
	b.eq	LBB268_2
; %bb.1:                                ; %B4
	stur	x0, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB268_2:                               ; %B3
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
	ldr	x26, [x23, #96]
	b.eq	LBB269_2
; %bb.1:                                ; %B4
	stur	x0, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB269_2:                               ; %B3
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
	ldr	x26, [x23, #96]
	b.eq	LBB270_2
; %bb.1:                                ; %B4
	stur	x0, [x20, #-32]
	sub	x20, x20, #24
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB270_2:                               ; %B3
	b	l_exception_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function is_undefined_0_asm_h
l_is_undefined_0_asm_h:                 ; @is_undefined_0_asm_h
; %bb.0:                                ; %B2
	ldur	x22, [x20, #-8]
	cmp	x22, #18
	b.ne	LBB271_2
; %bb.1:                                ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB271_2:                               ; %B5
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
	b.ne	LBB272_2
; %bb.1:                                ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB272_2:                               ; %B5
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
	b.ne	LBB273_2
; %bb.1:                                ; %B2
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB273_2:                               ; %B5
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
	cbz	x8, LBB274_3
; %bb.1:                                ; %B7
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbnz	x8, LBB274_4
LBB274_2:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB274_3:                               ; %B11
	mov	x0, x24
	str	x20, [x23, #48]
	bl	_EnsureCoverageCounters
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbz	x8, LBB274_2
LBB274_4:                               ; %B2
	ldr	w9, [x19]
	ldr	w10, [x10, #104]
	cmp	w9, w10
	b.hs	LBB274_2
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
; %bb.0:                                ; %B0
	ldrb	w9, [x19, #4]
	ldr	x8, [x23, #104]
	ldrsw	x10, [x19]
	add	x19, x19, #5
	add	w9, w9, #486
	ldr	x21, [x8, x10, lsl #3]
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
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
	tbnz	w1, #31, LBB279_5
; %bb.1:                                ; %B1
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, sxtw #3]
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, LBB279_4
; %bb.2:                                ; %B9
	ldr	w9, [x8, #8]
	asr	w9, w9, #30
	cmp	w9, #1
	b.ne	LBB279_5
LBB279_3:                               ; %B7
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	mov	x9, #2                          ; =0x2
	movk	x9, #1, lsl #48
	orr	x21, x8, x9
	br	x1
LBB279_4:                               ; %B2
	ldr	x9, [x8, #8]
	ldr	w9, [x9]
	asr	w9, w9, #30
	cmp	w9, #1
	b.eq	LBB279_3
LBB279_5:                               ; %B10
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB279_7
; %bb.6:                                ; %B12
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB279_7:                               ; %B11
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
	ldr	x1, [x23, #80]
	tbnz	w8, #0, LBB283_2
; %bb.1:                                ; %B12
	ldr	x8, [x23, #80]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, LBB283_3
LBB283_2:                               ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
LBB283_3:                               ; %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	LBB283_5
; %bb.4:                                ; %B7
	ldrb	w8, [x19], #1
	ldr	x21, [x24, #208]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB283_5:                               ; %B9
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB283_7
; %bb.6:                                ; %B11
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB283_7:                               ; %B10
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
	ldrb	w8, [x24, #355]
	stp	x19, x20, [sp, #-16]!           ; 16-byte Folded Spill
	cbnz	w8, LBB286_5
; %bb.1:                                ; %B1
	ldr	x19, [x24, #392]
	cbz	x19, LBB286_5
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
	cbz	x9, LBB286_5
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
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB286_7
LBB286_4:                               ; %B9
	add	x8, x9, #32
	ldr	x19, [sp]                       ; 8-byte Folded Reload
	mov	x21, x9
	str	x8, [x9, #16]
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB286_5:                               ; %B13
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	LBB286_8
; %bb.6:                                ; %B15
	ldp	x19, x20, [sp]                  ; 16-byte Folded Reload
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB286_7:                               ; %B11
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x19, x8
	mov	x19, x9
	bl	_prim_WriteBarrierNoStore
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x9, x19
	b	LBB286_4
LBB286_8:                               ; %B14
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
	cbz	w11, LBB330_3
LBB330_1:                               ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB330_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB330_1 Depth=1
	ldr	w11, [x12]
	and	w11, w11, #0x3ffffff
	cbnz	w11, LBB330_1
LBB330_3:                               ; %B11
	ldr	x8, [x24, #208]
	mov	w10, #18                        ; =0x12
LBB330_4:                               ; %B33
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB330_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w9, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB330_7
LBB330_5:                               ; %B22
                                        ;   Parent Loop BB330_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w9
	b.eq	LBB330_9
; %bb.6:                                ; %B24
                                        ;   in Loop: Header=BB330_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB330_5
LBB330_7:                               ; %B27
                                        ;   in Loop: Header=BB330_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	LBB330_13
; %bb.8:                                ; %B30
                                        ;   in Loop: Header=BB330_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB330_4
	b	LBB330_11
LBB330_9:                               ; %B12
	lsr	w9, w13, #26
	tst	w9, #0x30
	b.ne	LBB330_13
LBB330_10:                              ; %B7.sink.split
	ldr	x8, [x8, #16]
	sub	w9, w11, #1
	ldr	x10, [x8, w9, sxtw #3]
LBB330_11:                              ; %B7
	cmp	x10, #34
	b.eq	LBB330_15
; %bb.12:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x10
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB330_13:                              ; %B17
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB330_16
; %bb.14:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB330_15:                              ; %B3
	str	x22, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
LBB330_16:                              ; %B18
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
	cbz	w10, LBB331_3
LBB331_1:                               ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB331_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB331_1 Depth=1
	ldr	w10, [x12]
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB331_1
LBB331_3:                               ; %B11
	ldr	x8, [x24, #208]
LBB331_4:                               ; %B32
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB331_5 Depth 2
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w9, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB331_7
LBB331_5:                               ; %B21
                                        ;   Parent Loop BB331_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	LBB331_9
; %bb.6:                                ; %B23
                                        ;   in Loop: Header=BB331_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB331_5
LBB331_7:                               ; %B26
                                        ;   in Loop: Header=BB331_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB331_12
; %bb.8:                                ; %B29
                                        ;   in Loop: Header=BB331_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB331_4
	b	LBB331_12
LBB331_9:                               ; %B12
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	LBB331_12
LBB331_10:                              ; %B7
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	LBB331_14
; %bb.11:                               ; %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB331_12:                              ; %B16
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB331_15
; %bb.13:                               ; %B18
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB331_14:                              ; %B3
	str	x22, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
LBB331_15:                              ; %B17
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_1_asm_h
l_put_var_1_asm_h:                      ; @put_var_1_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	w3, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB332_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB332_2:                               ; %B2
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
	b.ne	LBB340_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB340_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB340_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB340_5
LBB340_3:                               ; %B1
                                        ;   Parent Loop BB340_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB340_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB340_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB340_3
LBB340_5:                               ; %B14
                                        ;   in Loop: Header=BB340_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB340_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB340_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB340_2
	b	LBB340_9
LBB340_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB340_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB340_9:                               ; %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB340_10:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB340_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB340_12:                              ; %B22
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function get_field2_1_asm_h
l_get_field2_1_asm_h:                   ; @get_field2_1_asm_h
; %bb.0:                                ; %B24
	mov	x8, #2                          ; =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB341_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB341_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB341_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB341_5
LBB341_3:                               ; %B1
                                        ;   Parent Loop BB341_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB341_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB341_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB341_3
LBB341_5:                               ; %B14
                                        ;   in Loop: Header=BB341_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB341_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB341_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB341_2
	b	LBB341_9
LBB341_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB341_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB341_9:                               ; %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB341_10:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB341_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB341_12:                              ; %B22
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
	b.ne	LBB342_18
; %bb.1:                                ; %B56
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB342_4
LBB342_2:                               ; %B1
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB342_10
; %bb.3:                                ; %B12
                                        ;   in Loop: Header=BB342_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB342_2
LBB342_4:                               ; %B17.preheader
	mov	x8, x22
LBB342_5:                               ; %B17
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB342_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w2, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB342_8
LBB342_6:                               ; %B18
                                        ;   Parent Loop BB342_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB342_13
; %bb.7:                                ; %B34
                                        ;   in Loop: Header=BB342_6 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB342_6
LBB342_8:                               ; %B41
                                        ;   in Loop: Header=BB342_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB342_18
; %bb.9:                                ; %B38
                                        ;   in Loop: Header=BB342_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB342_5
	b	LBB342_14
LBB342_10:                              ; %B3
	mov	w9, #58                         ; =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	LBB342_18
; %bb.11:                               ; %B7
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB342_22
LBB342_12:                              ; %B48
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB342_13:                              ; %B20
	mov	w8, #58                         ; =0x3a
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	LBB342_18
LBB342_14:                              ; %B23
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	LBB342_18
; %bb.15:                               ; %B25
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	add	x8, x20, #8
	b.ne	LBB342_20
; %bb.16:                               ; %B25
	tbnz	w2, #31, LBB342_20
; %bb.17:                               ; %B31
	mov	x20, x8
	stur	x21, [x8, #-8]
	mov	x0, x2
	b	l_FastAddNamedProperty_asm_h
LBB342_18:                              ; %B52
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
                                        ; kill: def $w2 killed $w2 killed $x2
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_SetPropertyInternalImpl_GC
	tbz	w0, #31, LBB342_12
; %bb.19:                               ; %B53
	b	l_exception_spill_top1_asm_h
LBB342_20:                              ; %B45
	mov	x0, x24
	mov	x1, x22
	mov	w3, #7                          ; =0x7
	stur	x21, [x8, #-8]
                                        ; kill: def $w2 killed $w2 killed $x2
	str	x8, [x23, #48]
	bl	_add_property_gc
	cbz	x0, LBB342_23
; %bb.21:                               ; %B49
	str	x21, [x0]
	ldrb	w8, [x24, #376]
	cbz	w8, LBB342_12
LBB342_22:                              ; %B51
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB342_23:                              ; %B46
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
	b.ne	LBB346_12
; %bb.1:                                ; %B73
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	LBB346_5
; %bb.2:                                ; %B1
	cmp	w8, #2
	b.ne	LBB346_10
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB346_14
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB346_5:                               ; %B33
	cmp	w8, #1
	b.ne	LBB346_12
; %bb.6:                                ; %B36
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB346_12
; %bb.7:                                ; %B36
	mov	x9, #2                          ; =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB346_12
; %bb.8:                                ; %B65
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB346_24
; %bb.9:                                ; %B68
	ldr	w8, [x1, #8]
	b	LBB346_25
LBB346_10:                              ; %B30
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB346_12
; %bb.11:                               ; %B30
	cmp	w8, #29
	b.le	LBB346_33
LBB346_12:                              ; %B70
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB346_34
; %bb.13:                               ; %B72
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB346_14:                              ; %B7
	tbnz	w21, #31, LBB346_12
; %bb.15:                               ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB346_16:                              ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB346_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB346_19
LBB346_17:                              ; %B10
                                        ;   Parent Loop BB346_16 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB346_21
; %bb.18:                               ; %B17
                                        ;   in Loop: Header=BB346_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB346_17
LBB346_19:                              ; %B24
                                        ;   in Loop: Header=BB346_16 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB346_12
; %bb.20:                               ; %B21
                                        ;   in Loop: Header=BB346_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB346_16
	b	LBB346_23
LBB346_21:                              ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB346_12
; %bb.22:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB346_23:                              ; %B51
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB346_24:                              ; %B66
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
LBB346_25:                              ; %B62
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	LBB346_12
; %bb.26:                               ; %B41
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	cbz	w0, LBB346_12
; %bb.27:                               ; %B44.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB346_28:                              ; %B44
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB346_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB346_31
LBB346_29:                              ; %B47
                                        ;   Parent Loop BB346_28 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	LBB346_35
; %bb.30:                               ; %B53
                                        ;   in Loop: Header=BB346_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB346_29
LBB346_31:                              ; %B58
                                        ;   in Loop: Header=BB346_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB346_12
; %bb.32:                               ; %B55
                                        ;   in Loop: Header=BB346_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB346_28
	b	LBB346_23
LBB346_33:                              ; %B31
	str	x21, [x20], #8
	mov	x0, xzr
	b	l_FastTypedArrayGet_asm_h
LBB346_34:                              ; %B71
	b	l_exception_spill_top1_asm_h
LBB346_35:                              ; %B49
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB346_12
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
	b.ne	LBB347_12
; %bb.1:                                ; %B73
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	LBB347_5
; %bb.2:                                ; %B1
	cmp	w8, #2
	b.ne	LBB347_10
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB347_14
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #8
	add	w8, w8, #486
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB347_5:                               ; %B33
	cmp	w8, #1
	b.ne	LBB347_12
; %bb.6:                                ; %B36
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB347_12
; %bb.7:                                ; %B36
	mov	x9, #2                          ; =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB347_12
; %bb.8:                                ; %B65
	and	x1, x21, #0xfffffffffffc
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB347_24
; %bb.9:                                ; %B68
	ldr	w8, [x1, #8]
	b	LBB347_25
LBB347_10:                              ; %B30
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB347_12
; %bb.11:                               ; %B30
	cmp	w8, #29
	b.le	LBB347_33
LBB347_12:                              ; %B70
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB347_34
; %bb.13:                               ; %B72
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB347_14:                              ; %B7
	tbnz	w21, #31, LBB347_12
; %bb.15:                               ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB347_16:                              ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB347_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB347_19
LBB347_17:                              ; %B10
                                        ;   Parent Loop BB347_16 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB347_21
; %bb.18:                               ; %B17
                                        ;   in Loop: Header=BB347_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB347_17
LBB347_19:                              ; %B24
                                        ;   in Loop: Header=BB347_16 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB347_12
; %bb.20:                               ; %B21
                                        ;   in Loop: Header=BB347_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB347_16
	b	LBB347_23
LBB347_21:                              ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB347_12
; %bb.22:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB347_23:                              ; %B51
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB347_24:                              ; %B66
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
LBB347_25:                              ; %B62
	asr	w8, w8, #30
	cmp	w8, #1
	b.ne	LBB347_12
; %bb.26:                               ; %B41
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	cbz	w0, LBB347_12
; %bb.27:                               ; %B44.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB347_28:                              ; %B44
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB347_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB347_31
LBB347_29:                              ; %B47
                                        ;   Parent Loop BB347_28 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	LBB347_35
; %bb.30:                               ; %B53
                                        ;   in Loop: Header=BB347_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB347_29
LBB347_31:                              ; %B58
                                        ;   in Loop: Header=BB347_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB347_12
; %bb.32:                               ; %B55
                                        ;   in Loop: Header=BB347_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB347_28
	b	LBB347_23
LBB347_33:                              ; %B31
	str	x21, [x20], #8
	mov	w0, #1                          ; =0x1
	b	l_FastTypedArrayGet_asm_h
LBB347_34:                              ; %B71
	b	l_exception_spill_top1_asm_h
LBB347_35:                              ; %B49
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB347_12
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
	b.ne	LBB348_45
; %bb.1:                                ; %B1
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x11, #6]
	cmp	x9, x22, lsr #48
	b.ne	LBB348_7
; %bb.2:                                ; %B3
	cmp	w8, #2
	b.ne	LBB348_12
; %bb.3:                                ; %B5
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB348_45
; %bb.4:                                ; %B50
	ldr	w8, [x11, #48]
	cmp	w22, w8
	b.hs	LBB348_15
; %bb.5:                                ; %B7
	ldr	x8, [x11, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB348_24
; %bb.6:                                ; %B9
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB348_7:                               ; %B59
	cmp	w8, #1
	b.ne	LBB348_45
; %bb.8:                                ; %B107
	ldr	w8, [x11, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB348_45
; %bb.9:                                ; %B107
	mov	x9, #2                          ; =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB348_45
; %bb.10:                               ; %B62
	and	x1, x22, #0xfffffffffffc
	stp	x11, x20, [sp]                  ; 16-byte Folded Spill
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB348_25
; %bb.11:                               ; %B106
	ldr	w8, [x1, #8]
	b	LBB348_26
LBB348_12:                              ; %B55
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB348_45
; %bb.13:                               ; %B55
	cmp	w8, #29
	b.gt	LBB348_45
; %bb.14:                               ; %B56
	str	x21, [x20], #8
	add	sp, sp, #16
	b	l_FastTypedArraySet_asm_h
LBB348_15:                              ; %B12
	mov	x1, x11
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	b.ne	LBB348_37
; %bb.16:                               ; %B40
	ldr	w9, [x1, #4]
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x11, x1
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	b.ne	LBB348_45
; %bb.17:                               ; %B40
	ubfx	w9, w9, #8, #1
	cbz	w9, LBB348_45
; %bb.18:                               ; %B14
	ldr	x9, [x11, #8]
	ldr	x9, [x9, #32]
	cbz	x9, LBB348_20
; %bb.19:                               ; %B36
	ldr	w9, [x9, #4]
	ubfx	w9, w9, #13, #1
	cmp	w9, #1
	b.ne	LBB348_45
LBB348_20:                              ; %B32
	ldr	x9, [x11, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	LBB348_22
; %bb.21:                               ; %B32
	cmp	w9, w10
	b.hi	LBB348_39
LBB348_22:                              ; %B29
	ldr	w10, [x1, #32]
	cmp	w9, w10
	b.hi	LBB348_39
; %bb.23:                               ; %B25
	ldr	x10, [x1, #40]
	str	w9, [x1, #48]
	str	x21, [x10, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, LBB348_46
	b	LBB348_42
LBB348_24:                              ; %B11
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB348_25:                              ; %B63
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
LBB348_26:                              ; %B102
	asr	w8, w8, #30
	ldp	x11, x20, [sp]                  ; 16-byte Folded Reload
	cmp	w8, #1
	b.ne	LBB348_45
; %bb.27:                               ; %B64
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	ldp	x11, x20, [sp]                  ; 16-byte Folded Reload
	cbz	w0, LBB348_45
; %bb.28:                               ; %B66
	ldr	x8, [x11, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w0, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB348_31
LBB348_29:                              ; %B69
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	LBB348_40
; %bb.30:                               ; %B78
                                        ;   in Loop: Header=BB348_29 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB348_29
LBB348_31:                              ; %B80.preheader
	ldp	x8, x20, [sp]                   ; 16-byte Folded Reload
LBB348_32:                              ; %B80
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB348_33 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w0, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB348_35
LBB348_33:                              ; %B93
                                        ;   Parent Loop BB348_32 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	LBB348_43
; %bb.34:                               ; %B98
                                        ;   in Loop: Header=BB348_33 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB348_33
LBB348_35:                              ; %B81
                                        ;   in Loop: Header=BB348_32 Depth=1
	ldr	w9, [x8, #4]
	ldr	x11, [sp]                       ; 8-byte Folded Reload
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB348_45
; %bb.36:                               ; %B87
                                        ;   in Loop: Header=BB348_32 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB348_32
	b	LBB348_44
LBB348_37:                              ; %B44
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x11, x1
	tbnz	w22, #31, LBB348_45
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
	tbz	w0, #31, LBB348_46
	b	LBB348_48
LBB348_39:                              ; %B20
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, x24
	mov	x2, x21
	mov	w3, #32768                      ; =0x8000
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_add_fast_array_element_gc
	tbz	w0, #31, LBB348_46
	b	LBB348_48
LBB348_40:                              ; %B71
	mov	w9, #58                         ; =0x3a
	ldp	x11, x20, [sp]                  ; 16-byte Folded Reload
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	LBB348_45
; %bb.41:                               ; %B74
	ldr	x9, [x11, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, LBB348_46
LBB348_42:                              ; %B76
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #16
	br	x1
LBB348_43:                              ; %B95
	mov	w8, #58                         ; =0x3a
	ldp	x11, x20, [sp]                  ; 16-byte Folded Reload
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	LBB348_45
LBB348_44:                              ; %B84
	ldr	w8, [x11, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.eq	LBB348_47
LBB348_45:                              ; %B113
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
	tbnz	w0, #31, LBB348_48
LBB348_46:                              ; %B73
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #16
	br	x1
LBB348_47:                              ; %B85
	str	x21, [x20], #8
	mov	w0, w0
	add	sp, sp, #16
	b	l_FastAddNamedProperty_asm_h
LBB348_48:                              ; %B47
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
	b.eq	LBB372_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB372_2:                               ; %B3
	str	x22, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc_check_1_asm_h
l_put_loc_check_1_asm_h:                ; @put_loc_check_1_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	LBB373_2
; %bb.1:                                ; %B4
	str	x22, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB373_2:                               ; %B3
	str	x22, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc_check_init_1_asm_h
l_put_loc_check_init_1_asm_h:           ; @put_loc_check_init_1_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.ne	LBB374_2
; %bb.1:                                ; %B4
	str	x22, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB374_2:                               ; %B3
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
	.p2align	2                               ; -- Begin function put_var_ref_check_1_asm_h
l_put_var_ref_check_1_asm_h:            ; @put_var_ref_check_1_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	LBB376_2
; %bb.1:                                ; %B4
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB376_2:                               ; %B3
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
	b.ne	LBB377_2
; %bb.1:                                ; %B4
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB377_2:                               ; %B3
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
; %bb.0:                                ; %B23
	cmp	x22, #5
	b.le	LBB379_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB379_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB379_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB379_6
	b	LBB379_7
LBB379_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB379_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB379_7
LBB379_6:                               ; %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB379_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB379_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB379_10
LBB379_9:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB379_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB379_13
; %bb.11:                               ; %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB379_6
	b.vs	LBB379_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB379_9
	b	LBB379_6
LBB379_13:                              ; %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_true_1_asm_h
l_if_true_1_asm_h:                      ; @if_true_1_asm_h
; %bb.0:                                ; %B23
	cmp	x22, #5
	b.le	LBB380_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB380_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB380_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB380_6
	b	LBB380_7
LBB380_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB380_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB380_7
LBB380_6:                               ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB380_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB380_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB380_10
LBB380_9:                               ; %B19
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB380_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB380_13
; %bb.11:                               ; %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB380_6
	b.vs	LBB380_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB380_9
	b	LBB380_6
LBB380_13:                              ; %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto_1_asm_h
l_goto_1_asm_h:                         ; @goto_1_asm_h
; %bb.0:                                ; %B0
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
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
	b.eq	LBB386_4
; %bb.1:                                ; %B15
	mov	x9, #1                          ; =0x1
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB386_4
; %bb.2:                                ; %B15
	cmp	x8, x9
	b.eq	LBB386_4
; %bb.3:                                ; %B15
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB386_5
LBB386_4:                               ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB386_5:                               ; %B12
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB386_7
; %bb.6:                                ; %B14
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB386_7:                               ; %B13
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function to_propkey2_1_asm_h
l_to_propkey2_1_asm_h:                  ; @to_propkey2_1_asm_h
; %bb.0:                                ; %B18
	mov	x21, x22
	ldur	x22, [x20, #-8]
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	LBB387_3
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
LBB387_2:                               ; %B16
	b	l_exception_spill_top1_asm_h
LBB387_3:                               ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	LBB387_7
; %bb.4:                                ; %B2
	mov	x9, #1                          ; =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB387_7
; %bb.5:                                ; %B2
	cmp	x8, x9
	b.eq	LBB387_7
; %bb.6:                                ; %B2
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB387_8
LBB387_7:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB387_8:                               ; %B15
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB387_2
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
	b.hi	LBB415_3
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB415_6
; %bb.2:                                ; %B13
	orr	w8, w22, #0x80000000
	mov	w9, #-2147483648                ; =0x80000000
	cmp	w8, w9
	b.ne	LBB415_5
LBB415_3:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        ; =0x8c
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB415_8
; %bb.4:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB415_5:                               ; %B15
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB415_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB415_3
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
LBB415_8:                               ; %B17
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function plus_1_asm_h
l_plus_1_asm_h:                         ; @plus_1_asm_h
; %bb.0:                                ; %B13
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB416_4
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB416_3
LBB416_2:                               ; %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB416_3:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.ne	LBB416_2
LBB416_4:                               ; %B10
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        ; =0x8d
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB416_6
; %bb.5:                                ; %B12
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB416_6:                               ; %B11
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function dec_1_asm_h
l_dec_1_asm_h:                          ; @dec_1_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB417_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB417_4
; %bb.2:                                ; %B13
	subs	w8, w22, #1
	b.vs	LBB417_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB417_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB417_6
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
LBB417_6:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        ; =0x8e
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB417_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB417_8:                               ; %B17
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function inc_1_asm_h
l_inc_1_asm_h:                          ; @inc_1_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB418_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB418_4
; %bb.2:                                ; %B13
	adds	w8, w22, #1
	b.vs	LBB418_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB418_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB418_6
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
LBB418_6:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        ; =0x8f
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB418_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB418_8:                               ; %B17
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function post_dec_1_asm_h
l_post_dec_1_asm_h:                     ; @post_dec_1_asm_h
; %bb.0:                                ; %B16
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB419_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB419_4
; %bb.2:                                ; %B13
	subs	w8, w22, #1
	b.vs	LBB419_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB419_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB419_6
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
LBB419_6:                               ; %B5
	str	x22, [x20], #8
	mov	w0, #144                        ; =0x90
	b	l_SlowJSPostInc_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function post_inc_1_asm_h
l_post_inc_1_asm_h:                     ; @post_inc_1_asm_h
; %bb.0:                                ; %B16
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB420_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB420_4
; %bb.2:                                ; %B13
	adds	w8, w22, #1
	b.vs	LBB420_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB420_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB420_6
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
LBB420_6:                               ; %B5
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
	b.hi	LBB421_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB421_4
; %bb.2:                                ; %B13
	subs	w9, w1, #1
	b.vs	LBB421_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB421_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB421_6
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
LBB421_6:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	w2, #142                        ; =0x8e
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB421_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB421_8:                               ; %B17
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function inc_loc_1_asm_h
l_inc_loc_1_asm_h:                      ; @inc_loc_1_asm_h
; %bb.0:                                ; %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	LBB422_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB422_4
; %bb.2:                                ; %B13
	adds	w9, w1, #1
	b.vs	LBB422_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB422_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB422_6
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
LBB422_6:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	w2, #143                        ; =0x8f
	str	x22, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB422_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB422_8:                               ; %B17
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
	b.hi	LBB423_16
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB423_5
; %bb.2:                                ; %B26
	cmp	x22, x9
	b.lo	LBB423_8
; %bb.3:                                ; %B36
	adds	w9, w1, w22
	b.vs	LBB423_11
; %bb.4:                                ; %B42
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB423_5:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB423_16
; %bb.6:                                ; %B11
	cmp	x22, x9
	b.lo	LBB423_14
; %bb.7:                                ; %B21
	scvtf	d0, w22
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	LBB423_13
LBB423_8:                               ; %B28
	tst	x22, #0xfffe000000000000
	b.eq	LBB423_16
; %bb.9:                                ; %B31
	scvtf	d0, w1
	add	x9, x22, x9
LBB423_10:                              ; %B31
	fmov	d1, x9
	b	LBB423_12
LBB423_11:                              ; %B38
	scvtf	d0, w1
	scvtf	d1, w22
LBB423_12:                              ; %B31
	fadd	d0, d0, d1
LBB423_13:                              ; %B31
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
LBB423_14:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB423_16
; %bb.15:                               ; %B16
	add	x10, x1, x9
	add	x9, x22, x9
	fmov	d0, x10
	b	LBB423_10
LBB423_16:                              ; %B7
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
	b.ne	LBB423_19
; %bb.17:                               ; %B43
	mov	x0, x24
	mov	x2, x22
	stur	x22, [x8, #-8]
	str	x8, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB423_20
; %bb.18:                               ; %B45
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB423_19:                              ; %B8
	mov	x20, x8
	stur	x22, [x8, #-8]
	mov	w0, #1                          ; =0x1
	b	l_FastJSConcatString_asm_h
LBB423_20:                              ; %B44
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function not_1_asm_h
l_not_1_asm_h:                          ; @not_1_asm_h
; %bb.0:                                ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB424_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB424_2:                               ; %B4
	str	x22, [x20], #8
	mov	x0, x22
	b	l_SlowJSNot_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lnot_1_asm_h
l_lnot_1_asm_h:                         ; @lnot_1_asm_h
; %bb.0:                                ; %B14
	cmp	x22, #5
	b.le	LBB425_4
; %bb.1:                                ; %B14
	cmp	x22, #6
	b.eq	LBB425_6
; %bb.2:                                ; %B14
	cmp	x22, #7
	b.eq	LBB425_8
; %bb.3:                                ; %B14
	cmp	x22, #18
	b.eq	LBB425_6
	b	LBB425_7
LBB425_4:                               ; %B14
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB425_6
; %bb.5:                                ; %B14
	cmp	x22, #2
	b.ne	LBB425_7
LBB425_6:                               ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB425_7:                               ; %B10
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB425_9
LBB425_8:                               ; %B12
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB425_9:                               ; %B13
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
	b.eq	LBB426_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB426_2:                               ; %B2
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
	b.hi	LBB429_19
; %bb.1:                                ; %B51
	cmp	x21, x8
	b.hi	LBB429_19
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB429_8
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB429_11
; %bb.4:                                ; %B33
	smull	x8, w22, w21
	sub	x20, x20, #8
	cmp	x8, w8, sxtw
	b.ne	LBB429_15
; %bb.5:                                ; %B40
	cbnz	w8, LBB429_7
; %bb.6:                                ; %B40
	orr	w9, w22, w21
	tbnz	w9, #31, LBB429_16
LBB429_7:                               ; %B47
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB429_8:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB429_19
; %bb.9:                                ; %B7
	cmp	x21, x8
	b.lo	LBB429_17
; %bb.10:                               ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	LBB429_14
LBB429_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB429_19
; %bb.12:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB429_13:                              ; %B28
	fmov	d1, x8
	fmul	d0, d0, d1
LBB429_14:                              ; %B28
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
LBB429_15:                              ; %B35
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
LBB429_16:                              ; %B44
	mov	x22, #-9222809086901354496      ; =0x8002000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB429_17:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB429_19
; %bb.18:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB429_13
LBB429_19:                              ; %B48
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        ; =0x9a
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB429_21
; %bb.20:                               ; %B50
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB429_21:                              ; %B49
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function div_1_asm_h
l_div_1_asm_h:                          ; @div_1_asm_h
; %bb.0:                                ; %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB430_14
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB430_14
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB430_5
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB430_8
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
LBB430_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB430_14
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB430_12
; %bb.7:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	LBB430_11
LBB430_8:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB430_14
; %bb.9:                                ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB430_10:                              ; %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
LBB430_11:                              ; %B28
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
LBB430_12:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB430_14
; %bb.13:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB430_10
LBB430_14:                              ; %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        ; =0x9b
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB430_16
; %bb.15:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB430_16:                              ; %B42
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function mod_1_asm_h
l_mod_1_asm_h:                          ; @mod_1_asm_h
; %bb.0:                                ; %B39
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB431_16
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB431_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB431_7
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB431_10
; %bb.4:                                ; %B33
	tbnz	w22, #31, LBB431_16
; %bb.5:                                ; %B33
	cmp	w21, #1
	b.lt	LBB431_16
; %bb.6:                                ; %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB431_7:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB431_16
; %bb.8:                                ; %B7
	cmp	x21, x8
	b.lo	LBB431_14
; %bb.9:                                ; %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	LBB431_13
LBB431_10:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB431_16
; %bb.11:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB431_12:                              ; %B28
	fmov	d1, x8
LBB431_13:                              ; %B28
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
LBB431_14:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB431_16
; %bb.15:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB431_12
LBB431_16:                              ; %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        ; =0x9c
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB431_18
; %bb.17:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB431_18:                              ; %B37
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function add_1_asm_h
l_add_1_asm_h:                          ; @add_1_asm_h
; %bb.0:                                ; %B46
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB432_16
; %bb.1:                                ; %B46
	cmp	x21, x8
	b.hi	LBB432_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB432_6
; %bb.3:                                ; %B26
	cmp	x21, x8
	b.lo	LBB432_9
; %bb.4:                                ; %B36
	adds	w8, w22, w21
	sub	x20, x20, #8
	b.vs	LBB432_13
; %bb.5:                                ; %B42
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB432_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB432_16
; %bb.7:                                ; %B11
	cmp	x21, x8
	b.lo	LBB432_14
; %bb.8:                                ; %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	LBB432_12
LBB432_9:                               ; %B28
	tst	x21, #0xfffe000000000000
	b.eq	LBB432_16
; %bb.10:                               ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB432_11:                              ; %B31
	fmov	d1, x8
	fadd	d0, d0, d1
LBB432_12:                              ; %B31
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
LBB432_13:                              ; %B38
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
LBB432_14:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB432_16
; %bb.15:                               ; %B16
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB432_11
LBB432_16:                              ; %B7
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
	b.ne	LBB432_19
; %bb.17:                               ; %B7
	cbz	w9, LBB432_19
; %bb.18:                               ; %B8
	mov	x20, x8
	stur	x21, [x8, #-8]
	mov	x0, xzr
	b	l_FastJSConcatString_asm_h
LBB432_19:                              ; %B43
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stur	x21, [x8, #-8]
	str	x8, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB432_21
; %bb.20:                               ; %B45
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB432_21:                              ; %B44
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function sub_1_asm_h
l_sub_1_asm_h:                          ; @sub_1_asm_h
; %bb.0:                                ; %B43
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB433_16
; %bb.1:                                ; %B43
	cmp	x21, x8
	b.hi	LBB433_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB433_6
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB433_9
; %bb.4:                                ; %B33
	subs	w8, w22, w21
	sub	x20, x20, #8
	b.vs	LBB433_13
; %bb.5:                                ; %B39
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB433_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB433_16
; %bb.7:                                ; %B7
	cmp	x21, x8
	b.lo	LBB433_14
; %bb.8:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	LBB433_12
LBB433_9:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB433_16
; %bb.10:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB433_11:                              ; %B28
	fmov	d1, x8
	fsub	d0, d0, d1
LBB433_12:                              ; %B28
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
LBB433_13:                              ; %B35
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
LBB433_14:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB433_16
; %bb.15:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB433_11
LBB433_16:                              ; %B40
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        ; =0x9e
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB433_18
; %bb.17:                               ; %B42
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB433_18:                              ; %B41
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
	b.eq	LBB434_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB434_2:                               ; %B2
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function shl_1_asm_h
l_shl_1_asm_h:                          ; @shl_1_asm_h
; %bb.0:                                ; %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB435_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB435_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB435_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB435_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB435_5:                               ; %B16
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #8
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB435_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB435_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB435_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB435_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB435_5
LBB435_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        ; =0xa0
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB435_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB435_12:                              ; %B26
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function sar_1_asm_h
l_sar_1_asm_h:                          ; @sar_1_asm_h
; %bb.0:                                ; %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB436_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB436_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB436_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB436_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB436_5:                               ; %B16
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #8
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB436_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB436_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB436_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB436_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB436_5
LBB436_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        ; =0xa1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB436_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB436_12:                              ; %B26
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function shr_1_asm_h
l_shr_1_asm_h:                          ; @shr_1_asm_h
; %bb.0:                                ; %B36
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB437_11
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB437_11
; %bb.2:                                ; %B10
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB437_6
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB437_11
; %bb.4:                                ; %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, LBB437_10
LBB437_5:                               ; %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB437_6:                               ; %B12
	tst	x22, #0xfffe000000000000
	b.eq	LBB437_11
; %bb.7:                                ; %B12
	cmp	x21, x8
	b.lo	LBB437_11
; %bb.8:                                ; %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB437_11
; %bb.9:                                ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, LBB437_5
LBB437_10:                              ; %B6
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
LBB437_11:                              ; %B33
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	LBB437_13
; %bb.12:                               ; %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB437_13:                              ; %B34
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lt_1_asm_h
l_lt_1_asm_h:                           ; @lt_1_asm_h
; %bb.0:                                ; %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB438_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB438_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB438_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB438_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, lt
	br	x1
LBB438_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB438_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB438_10
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
LBB438_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB438_12
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
LBB438_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB438_12
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
LBB438_12:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        ; =0xa3
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB438_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB438_14:                              ; %B22
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lte_1_asm_h
l_lte_1_asm_h:                          ; @lte_1_asm_h
; %bb.0:                                ; %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB439_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB439_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB439_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB439_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, le
	br	x1
LBB439_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB439_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB439_10
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
LBB439_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB439_12
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
LBB439_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB439_12
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
LBB439_12:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        ; =0xa4
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB439_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB439_14:                              ; %B22
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function gt_1_asm_h
l_gt_1_asm_h:                           ; @gt_1_asm_h
; %bb.0:                                ; %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB440_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB440_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB440_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB440_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB440_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB440_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB440_10
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
LBB440_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB440_12
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
LBB440_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB440_12
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
LBB440_12:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        ; =0xa5
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB440_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB440_14:                              ; %B22
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function gte_1_asm_h
l_gte_1_asm_h:                          ; @gte_1_asm_h
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
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
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
	cinc	x22, x8, ge
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
	cinc	x22, x8, ge
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
	cinc	x22, x8, ge
	br	x1
LBB441_12:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        ; =0xa6
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
	b.eq	LBB442_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB442_2:                               ; %B2
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
	b.eq	LBB443_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB443_2:                               ; %B2
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function eq_1_asm_h
l_eq_1_asm_h:                           ; @eq_1_asm_h
; %bb.0:                                ; %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB444_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB444_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB444_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB444_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB444_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB444_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB444_11
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
LBB444_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB444_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB444_10:                              ; %B39
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
LBB444_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB444_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB444_10
LBB444_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB444_15
LBB444_14:                              ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB444_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB444_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB444_14
	b	LBB444_20
LBB444_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB444_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB444_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB444_21
LBB444_20:                              ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB444_21:                              ; %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB444_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB444_23:                              ; %B42
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function neq_1_asm_h
l_neq_1_asm_h:                          ; @neq_1_asm_h
; %bb.0:                                ; %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB445_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB445_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB445_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB445_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB445_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB445_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB445_11
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
LBB445_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB445_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB445_10:                              ; %B39
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
LBB445_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB445_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB445_10
LBB445_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB445_15
LBB445_14:                              ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB445_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB445_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB445_14
	b	LBB445_20
LBB445_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB445_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB445_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB445_21
LBB445_20:                              ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB445_21:                              ; %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB445_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB445_23:                              ; %B42
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function strict_eq_1_asm_h
l_strict_eq_1_asm_h:                    ; @strict_eq_1_asm_h
; %bb.0:                                ; %B39
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB446_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB446_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB446_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB446_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB446_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB446_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB446_11
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
LBB446_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB446_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB446_10:                              ; %B34
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
LBB446_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB446_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB446_10
LBB446_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB446_15
; %bb.14:                               ; %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB446_15:                              ; %B13
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
	b.ne	LBB446_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB446_22
LBB446_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB446_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB446_23
LBB446_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB446_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB446_25
LBB446_21:                              ; %B21
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB446_22:                              ; %B14
	str	x21, [x20], #8
	mov	x0, xzr
	b	l_FastStringEqual_asm_h
LBB446_23:                              ; %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB446_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB446_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #8
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB446_28
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB446_27:                              ; %B37
	b	l_exception_spill_top1_asm_h
LBB446_28:                              ; %B8
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
	b.hi	LBB447_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB447_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB447_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB447_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB447_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB447_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB447_11
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
LBB447_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB447_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB447_10:                              ; %B34
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
LBB447_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB447_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB447_10
LBB447_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB447_15
; %bb.14:                               ; %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB447_15:                              ; %B13
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
	b.ne	LBB447_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB447_22
LBB447_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB447_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB447_23
LBB447_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB447_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB447_25
LBB447_21:                              ; %B21
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB447_22:                              ; %B14
	str	x21, [x20], #8
	mov	w0, #1                          ; =0x1
	b	l_FastStringEqual_asm_h
LBB447_23:                              ; %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB447_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB447_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #8
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB447_28
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB447_27:                              ; %B37
	b	l_exception_spill_top1_asm_h
LBB447_28:                              ; %B8
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
	b.hi	LBB448_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB448_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB448_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB448_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB448_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	and	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB448_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB448_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB448_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB448_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB448_5
LBB448_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        ; =0xad
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB448_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB448_12:                              ; %B26
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function xor_1_asm_h
l_xor_1_asm_h:                          ; @xor_1_asm_h
; %bb.0:                                ; %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB449_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB449_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB449_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB449_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB449_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	eor	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB449_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB449_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB449_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB449_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB449_5
LBB449_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        ; =0xae
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB449_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB449_12:                              ; %B26
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function or_1_asm_h
l_or_1_asm_h:                           ; @or_1_asm_h
; %bb.0:                                ; %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB450_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB450_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB450_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB450_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB450_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB450_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB450_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB450_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB450_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB450_5
LBB450_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        ; =0xaf
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB450_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB450_12:                              ; %B26
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
; %bb.0:                                ; %B0
	ldrb	w9, [x19, #1]
	ldr	x8, [x23, #104]
	ldrb	w10, [x19], #2
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x21, [x8, x10, lsl #3]
	br	x1
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
	b.eq	LBB465_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB465_2:                               ; %B2
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
	b.eq	LBB505_2
; %bb.1:                                ; %B27
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB505_3
LBB505_2:                               ; %B28
	and	x8, x22, #0xfffffffffffc
	ldrb	w9, [x19], #1
	ldr	w8, [x8, #4]
	mov	x10, #-562949953421312          ; =0xfffe000000000000
	add	w9, w9, #243
	bfxil	x10, x8, #0, #30
	ldr	x1, [x25, w9, uxtw #3]
	mov	x22, x10
	br	x1
LBB505_3:                               ; %B21
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB505_13
; %bb.4:                                ; %B22
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB505_5:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB505_6 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w11, #0x30
	ldr	w10, [x13, w10, uxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB505_8
LBB505_6:                               ; %B1
                                        ;   Parent Loop BB505_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, #48
	b.eq	LBB505_10
; %bb.7:                                ; %B9
                                        ;   in Loop: Header=BB505_6 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB505_6
LBB505_8:                               ; %B14
                                        ;   in Loop: Header=BB505_5 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB505_13
; %bb.9:                                ; %B17
                                        ;   in Loop: Header=BB505_5 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB505_5
	b	LBB505_12
LBB505_10:                              ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB505_13
; %bb.11:                               ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB505_12:                              ; %B6
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB505_13:                              ; %B24
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
	b.eq	LBB505_15
; %bb.14:                               ; %B26
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB505_15:                              ; %B25
	b	l_exception_spill_top0_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_false8_1_asm_h
l_if_false8_1_asm_h:                    ; @if_false8_1_asm_h
; %bb.0:                                ; %B23
	cmp	x22, #5
	b.le	LBB506_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB506_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB506_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB506_6
	b	LBB506_7
LBB506_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB506_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB506_7
LBB506_6:                               ; %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB506_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB506_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB506_10
LBB506_9:                               ; %B19
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB506_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB506_13
; %bb.11:                               ; %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB506_6
	b.vs	LBB506_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB506_9
	b	LBB506_6
LBB506_13:                              ; %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_true8_1_asm_h
l_if_true8_1_asm_h:                     ; @if_true8_1_asm_h
; %bb.0:                                ; %B23
	cmp	x22, #5
	b.le	LBB507_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB507_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB507_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB507_6
	b	LBB507_7
LBB507_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB507_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB507_7
LBB507_6:                               ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB507_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB507_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB507_10
LBB507_9:                               ; %B19
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB507_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB507_13
; %bb.11:                               ; %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB507_6
	b.vs	LBB507_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB507_9
	b	LBB507_6
LBB507_13:                              ; %B15
	str	x22, [x20], #8
	mov	x0, x22
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto8_1_asm_h
l_goto8_1_asm_h:                        ; @goto8_1_asm_h
; %bb.0:                                ; %B0
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto16_1_asm_h
l_goto16_1_asm_h:                       ; @goto16_1_asm_h
; %bb.0:                                ; %B0
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
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
	b.ne	LBB514_2
; %bb.1:                                ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB514_2:                               ; %B5
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
	b.ne	LBB515_2
; %bb.1:                                ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB515_2:                               ; %B5
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
	b.ne	LBB516_2
; %bb.1:                                ; %B2
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB516_2:                               ; %B5
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
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #4]
	ldr	x9, [x23, #104]
	ldrsw	x10, [x19]
	add	x19, x19, #5
	add	w8, w8, #486
	ldr	x9, [x9, x10, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x9
	br	x1
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
	tbnz	w1, #31, LBB522_5
; %bb.1:                                ; %B1
	ldr	x8, [x24, #8]
	ldr	x8, [x8, #64]
	ldr	x8, [x8, w1, sxtw #3]
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, LBB522_4
; %bb.2:                                ; %B9
	ldr	w9, [x8, #8]
	asr	w9, w9, #30
	cmp	w9, #1
	b.ne	LBB522_5
LBB522_3:                               ; %B7
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	mov	x9, #2                          ; =0x2
	movk	x9, #1, lsl #48
	orr	x21, x8, x9
	br	x1
LBB522_4:                               ; %B2
	ldr	x9, [x8, #8]
	ldr	w9, [x9]
	asr	w9, w9, #30
	cmp	w9, #1
	b.eq	LBB522_3
LBB522_5:                               ; %B10
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB522_7
; %bb.6:                                ; %B12
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB522_7:                               ; %B11
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
	ldr	x1, [x23, #80]
	tbnz	w8, #0, LBB526_2
; %bb.1:                                ; %B12
	ldr	x8, [x23, #80]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, LBB526_3
LBB526_2:                               ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
LBB526_3:                               ; %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	LBB526_5
; %bb.4:                                ; %B7
	ldrb	w8, [x19], #1
	ldr	x9, [x24, #208]
	mov	x22, x21
	add	w8, w8, #486
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB526_5:                               ; %B9
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB526_7
; %bb.6:                                ; %B11
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB526_7:                               ; %B10
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
	ldrb	w8, [x24, #355]
	str	x19, [sp, #8]                   ; 8-byte Folded Spill
	cbnz	w8, LBB529_5
; %bb.1:                                ; %B1
	ldr	x19, [x24, #392]
	cbz	x19, LBB529_5
; %bb.2:                                ; %B5
	mov	x8, x20
	mov	x0, x24
	mov	w1, #64                         ; =0x40
	mov	w2, #2                          ; =0x2
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_prim_try_malloc_gc
	mov	x9, x0
	cbz	x9, LBB529_5
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
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB529_7
LBB529_4:                               ; %B9
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
LBB529_5:                               ; %B13
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	LBB529_8
; %bb.6:                                ; %B15
	ldr	x19, [sp, #8]                   ; 8-byte Folded Reload
	mov	x22, x21
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB529_7:                               ; %B11
	mov	x8, #-844424930131968           ; =0xfffd000000000000
	mov	x1, x24
	orr	x0, x19, x8
	mov	x19, x9
	bl	_prim_WriteBarrierNoStore
	mov	x9, x19
	b	LBB529_4
LBB529_8:                               ; %B14
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
	cbz	w11, LBB573_3
LBB573_1:                               ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB573_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB573_1 Depth=1
	ldr	w11, [x12]
	and	w11, w11, #0x3ffffff
	cbnz	w11, LBB573_1
LBB573_3:                               ; %B11
	ldr	x8, [x24, #208]
	mov	w10, #18                        ; =0x12
LBB573_4:                               ; %B33
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB573_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w9, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB573_7
LBB573_5:                               ; %B22
                                        ;   Parent Loop BB573_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w9
	b.eq	LBB573_9
; %bb.6:                                ; %B24
                                        ;   in Loop: Header=BB573_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB573_5
LBB573_7:                               ; %B27
                                        ;   in Loop: Header=BB573_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	LBB573_13
; %bb.8:                                ; %B30
                                        ;   in Loop: Header=BB573_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB573_4
	b	LBB573_11
LBB573_9:                               ; %B12
	lsr	w9, w13, #26
	tst	w9, #0x30
	b.ne	LBB573_13
LBB573_10:                              ; %B7.sink.split
	ldr	x8, [x8, #16]
	sub	w9, w11, #1
	ldr	x10, [x8, w9, sxtw #3]
LBB573_11:                              ; %B7
	cmp	x10, #34
	b.eq	LBB573_15
; %bb.12:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x10
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB573_13:                              ; %B17
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB573_16
; %bb.14:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB573_15:                              ; %B3
	str	x21, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
LBB573_16:                              ; %B18
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
	cbz	w10, LBB574_3
LBB574_1:                               ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #4]
	cmp	w13, w9
	b.eq	LBB574_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB574_1 Depth=1
	ldr	w10, [x12]
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB574_1
LBB574_3:                               ; %B11
	ldr	x8, [x24, #208]
LBB574_4:                               ; %B32
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB574_5 Depth 2
	ldr	x10, [x8, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w9, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB574_7
LBB574_5:                               ; %B21
                                        ;   Parent Loop BB574_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w9
	b.eq	LBB574_9
; %bb.6:                                ; %B23
                                        ;   in Loop: Header=BB574_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB574_5
LBB574_7:                               ; %B26
                                        ;   in Loop: Header=BB574_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB574_12
; %bb.8:                                ; %B29
                                        ;   in Loop: Header=BB574_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB574_4
	b	LBB574_12
LBB574_9:                               ; %B12
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	LBB574_12
LBB574_10:                              ; %B7
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	LBB574_14
; %bb.11:                               ; %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB574_12:                              ; %B16
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB574_15
; %bb.13:                               ; %B18
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB574_14:                              ; %B3
	str	x21, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
LBB574_15:                              ; %B17
	b	l_exception_spill_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_var_2_asm_h
l_put_var_2_asm_h:                      ; @put_var_2_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB575_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB575_2:                               ; %B2
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
	b.ne	LBB583_10
; %bb.1:                                ; %B25
	mov	x9, x21
	mov	w8, #18                         ; =0x12
LBB583_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB583_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB583_5
LBB583_3:                               ; %B1
                                        ;   Parent Loop BB583_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB583_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB583_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB583_3
LBB583_5:                               ; %B14
                                        ;   in Loop: Header=BB583_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB583_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB583_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB583_2
	b	LBB583_9
LBB583_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB583_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB583_9:                               ; %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB583_10:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x3, x21
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB583_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB583_12:                              ; %B22
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
	b.ne	LBB584_10
; %bb.1:                                ; %B25
	mov	x9, x21
	mov	w8, #18                         ; =0x12
LBB584_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB584_3 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w2, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB584_5
LBB584_3:                               ; %B1
                                        ;   Parent Loop BB584_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w2
	b.eq	LBB584_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB584_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB584_3
LBB584_5:                               ; %B14
                                        ;   in Loop: Header=BB584_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB584_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB584_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB584_2
	b	LBB584_9
LBB584_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB584_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB584_9:                               ; %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB584_10:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	mov	x3, x21
	mov	w4, wzr
	str	x21, [x8], #8
	str	x8, [x23, #48]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB584_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB584_12:                              ; %B22
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
	b.ne	LBB585_18
; %bb.1:                                ; %B56
	ldr	x8, [x22, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w2, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB585_4
LBB585_2:                               ; %B1
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB585_10
; %bb.3:                                ; %B12
                                        ;   in Loop: Header=BB585_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB585_2
LBB585_4:                               ; %B17.preheader
	mov	x8, x22
LBB585_5:                               ; %B17
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB585_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w2, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB585_8
LBB585_6:                               ; %B18
                                        ;   Parent Loop BB585_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w2
	b.eq	LBB585_13
; %bb.7:                                ; %B34
                                        ;   in Loop: Header=BB585_6 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB585_6
LBB585_8:                               ; %B41
                                        ;   in Loop: Header=BB585_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB585_18
; %bb.9:                                ; %B38
                                        ;   in Loop: Header=BB585_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB585_5
	b	LBB585_14
LBB585_10:                              ; %B3
	mov	w9, #58                         ; =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	LBB585_18
; %bb.11:                               ; %B7
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB585_19
LBB585_12:                              ; %B54
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB585_13:                              ; %B20
	mov	w8, #58                         ; =0x3a
	and	w8, w8, w10, lsr #26
	cmp	w8, #2
	b.ne	LBB585_18
LBB585_14:                              ; %B23
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	LBB585_18
; %bb.15:                               ; %B25
	ldrh	w8, [x22, #6]
	cmp	w8, #1
	b.ne	LBB585_20
; %bb.16:                               ; %B25
	tbnz	w2, #31, LBB585_20
; %bb.17:                               ; %B31
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x2
	stp	x22, x21, [x8]
	add	sp, sp, #16
	b	l_FastAddNamedProperty_asm_h
LBB585_18:                              ; %B52
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
                                        ; kill: def $w2 killed $w2 killed $x2
	bl	_JS_SetPropertyInternalImpl_GC
	tbz	w0, #31, LBB585_12
	b	LBB585_25
LBB585_19:                              ; %B9
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB585_20:                              ; %B45
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	w3, #7                          ; =0x7
	stp	x22, x21, [x20]
                                        ; kill: def $w2 killed $w2 killed $x2
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	str	x8, [x23, #48]
	bl	_add_property_gc
	cbz	x0, LBB585_24
; %bb.21:                               ; %B49
	str	x21, [x0]
	ldrb	w8, [x24, #376]
	cbz	w8, LBB585_23
; %bb.22:                               ; %B51
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
LBB585_23:                              ; %B48
	ldrb	w8, [x19, #4]
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB585_24:                              ; %B46
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
LBB585_25:                              ; %B53
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
	b.ne	LBB589_12
; %bb.1:                                ; %B73
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	LBB589_5
; %bb.2:                                ; %B1
	cmp	w8, #2
	b.ne	LBB589_10
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB589_14
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	add	w8, w8, #243
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB589_5:                               ; %B33
	cmp	w8, #1
	b.ne	LBB589_12
; %bb.6:                                ; %B36
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB589_12
; %bb.7:                                ; %B36
	mov	x9, #2                          ; =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB589_12
; %bb.8:                                ; %B65
	and	x8, x21, #0xfffffffffffc
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, LBB589_24
; %bb.9:                                ; %B68
	ldr	w8, [x8, #8]
	b	LBB589_25
LBB589_10:                              ; %B30
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB589_12
; %bb.11:                               ; %B30
	cmp	w8, #29
	b.le	LBB589_33
LBB589_12:                              ; %B70
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	str	x8, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB589_34
; %bb.13:                               ; %B72
	ldrb	w8, [x19], #1
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB589_14:                              ; %B7
	tbnz	w21, #31, LBB589_12
; %bb.15:                               ; %B9.preheader
	mov	x15, x20
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB589_16:                              ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB589_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB589_19
LBB589_17:                              ; %B10
                                        ;   Parent Loop BB589_16 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB589_21
; %bb.18:                               ; %B17
                                        ;   in Loop: Header=BB589_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB589_17
LBB589_19:                              ; %B24
                                        ;   in Loop: Header=BB589_16 Depth=1
	ldr	w10, [x9, #4]
	mov	x20, x15
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB589_12
; %bb.20:                               ; %B21
                                        ;   in Loop: Header=BB589_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB589_16
	b	LBB589_23
LBB589_21:                              ; %B12
	lsr	w8, w13, #26
	mov	x20, x15
	tst	w8, #0x30
	b.ne	LBB589_12
; %bb.22:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB589_23:                              ; %B14
	ldrb	w9, [x19], #1
	mov	x20, x15
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	mov	x22, x8
	add	sp, sp, #16
	br	x1
LBB589_24:                              ; %B66
	ldr	x8, [x8, #8]
	ldr	w8, [x8]
LBB589_25:                              ; %B62
	asr	w8, w8, #30
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	cmp	w8, #1
	b.ne	LBB589_12
; %bb.26:                               ; %B41
	ldr	x0, [x24, #8]
	and	x1, x21, #0xfffffffffffc
	bl	_prim_get_interned_non_index_atom
	cbz	w0, LBB589_12
; %bb.27:                               ; %B44.preheader
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB589_28:                              ; %B44
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB589_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB589_31
LBB589_29:                              ; %B47
                                        ;   Parent Loop BB589_28 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	LBB589_35
; %bb.30:                               ; %B53
                                        ;   in Loop: Header=BB589_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB589_29
LBB589_31:                              ; %B58
                                        ;   in Loop: Header=BB589_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB589_12
; %bb.32:                               ; %B55
                                        ;   in Loop: Header=BB589_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB589_28
	b	LBB589_37
LBB589_33:                              ; %B31
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, xzr
	stp	x22, x21, [x8]
	add	sp, sp, #16
	b	l_FastTypedArrayGet_asm_h
LBB589_34:                              ; %B71
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	l_exception_spill_top0_top1_asm_h
LBB589_35:                              ; %B49
	lsr	w8, w12, #26
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	tst	w8, #0x30
	b.ne	LBB589_12
; %bb.36:                               ; %B50
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB589_37:                              ; %B51
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
	b.ne	LBB590_12
; %bb.1:                                ; %B73
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x22, #6]
	cmp	x9, x21, lsr #48
	b.ne	LBB590_5
; %bb.2:                                ; %B1
	cmp	w8, #2
	b.ne	LBB590_10
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB590_14
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	add	w8, w8, #486
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB590_5:                               ; %B33
	cmp	w8, #1
	b.ne	LBB590_12
; %bb.6:                                ; %B36
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB590_12
; %bb.7:                                ; %B36
	mov	x9, #2                          ; =0x2
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB590_12
; %bb.8:                                ; %B65
	and	x1, x21, #0xfffffffffffc
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	ldrb	w8, [x1, #7]
	tbnz	w8, #6, LBB590_24
; %bb.9:                                ; %B68
	ldr	w8, [x1, #8]
	b	LBB590_25
LBB590_10:                              ; %B30
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB590_12
; %bb.11:                               ; %B30
	cmp	w8, #29
	b.le	LBB590_33
LBB590_12:                              ; %B70
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x20, [sp, #8]                   ; 8-byte Folded Spill
	str	x8, [x23, #48]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB590_34
; %bb.13:                               ; %B72
	ldrb	w8, [x19], #1
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB590_14:                              ; %B7
	tbnz	w21, #31, LBB590_12
; %bb.15:                               ; %B9.preheader
	mov	x15, x20
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB590_16:                              ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB590_17 Depth 2
	ldr	x11, [x9, #8]
	orr	w10, w21, #0x80000000
	ldr	w12, [x11, #12]
	add	x14, x11, #64
	lsl	w13, w12, #2
	and	w11, w10, w12
	ldr	w11, [x14, w11, sxtw #2]
	add	w12, w13, #4
	add	x12, x14, x12
	cbz	w11, LBB590_19
LBB590_17:                              ; %B10
                                        ;   Parent Loop BB590_16 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13]
	cmp	w14, w10
	b.eq	LBB590_21
; %bb.18:                               ; %B17
                                        ;   in Loop: Header=BB590_17 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB590_17
LBB590_19:                              ; %B24
                                        ;   in Loop: Header=BB590_16 Depth=1
	ldr	w10, [x9, #4]
	mov	x20, x15
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB590_12
; %bb.20:                               ; %B21
                                        ;   in Loop: Header=BB590_16 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB590_16
	b	LBB590_23
LBB590_21:                              ; %B12
	lsr	w8, w13, #26
	mov	x20, x15
	tst	w8, #0x30
	b.ne	LBB590_12
; %bb.22:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB590_23:                              ; %B14
	ldrb	w9, [x19], #1
	mov	x20, x15
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x8
	add	sp, sp, #16
	br	x1
LBB590_24:                              ; %B66
	ldr	x8, [x1, #8]
	ldr	w8, [x8]
LBB590_25:                              ; %B62
	asr	w8, w8, #30
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	cmp	w8, #1
	b.ne	LBB590_12
; %bb.26:                               ; %B41
	ldr	x0, [x24, #8]
	bl	_prim_get_interned_non_index_atom
	cbz	w0, LBB590_12
; %bb.27:                               ; %B44.preheader
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB590_28:                              ; %B44
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB590_29 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w0, w11
	ldr	w10, [x13, w10, sxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB590_31
LBB590_29:                              ; %B47
                                        ;   Parent Loop BB590_28 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, w0
	b.eq	LBB590_35
; %bb.30:                               ; %B53
                                        ;   in Loop: Header=BB590_29 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB590_29
LBB590_31:                              ; %B58
                                        ;   in Loop: Header=BB590_28 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB590_12
; %bb.32:                               ; %B55
                                        ;   in Loop: Header=BB590_28 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB590_28
	b	LBB590_37
LBB590_33:                              ; %B31
	mov	x8, x20
	add	x20, x20, #16
	mov	w0, #1                          ; =0x1
	stp	x22, x21, [x8]
	add	sp, sp, #16
	b	l_FastTypedArrayGet_asm_h
LBB590_34:                              ; %B71
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	l_exception_spill_top0_top1_asm_h
LBB590_35:                              ; %B49
	lsr	w8, w12, #26
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	tst	w8, #0x30
	b.ne	LBB590_12
; %bb.36:                               ; %B50
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB590_37:                              ; %B51
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
	b.ne	LBB591_45
; %bb.1:                                ; %B1
	mov	w9, #65534                      ; =0xfffe
	ldrh	w8, [x20, #6]
	cmp	x9, x22, lsr #48
	b.ne	LBB591_7
; %bb.2:                                ; %B3
	cmp	w8, #2
	b.ne	LBB591_12
; %bb.3:                                ; %B5
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB591_45
; %bb.4:                                ; %B50
	ldr	w8, [x20, #48]
	cmp	w22, w8
	b.hs	LBB591_15
; %bb.5:                                ; %B7
	ldr	x8, [x20, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #376]
	cbnz	w8, LBB591_24
; %bb.6:                                ; %B9
	ldrb	w8, [x19], #1
	sub	x20, x10, #8
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB591_7:                               ; %B59
	cmp	w8, #1
	b.ne	LBB591_45
; %bb.8:                                ; %B107
	ldr	w8, [x20, #4]
	ubfx	w8, w8, #10, #1
	cmp	w8, #1
	b.eq	LBB591_45
; %bb.9:                                ; %B107
	mov	x9, #2                          ; =0x2
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	cmp	x8, x9
	b.ne	LBB591_45
; %bb.10:                               ; %B62
	and	x8, x22, #0xfffffffffffc
	str	x10, [sp, #8]                   ; 8-byte Folded Spill
	ldrb	w9, [x8, #7]
	tbnz	w9, #6, LBB591_25
; %bb.11:                               ; %B106
	ldr	w8, [x8, #8]
	b	LBB591_26
LBB591_12:                              ; %B55
	sxth	w8, w8
	cmp	w8, #21
	b.lt	LBB591_45
; %bb.13:                               ; %B55
	cmp	w8, #29
	b.gt	LBB591_45
; %bb.14:                               ; %B56
	add	x20, x10, #16
	stp	x22, x21, [x10]
	add	sp, sp, #16
	b	l_FastTypedArraySet_asm_h
LBB591_15:                              ; %B12
	str	x10, [sp, #8]                   ; 8-byte Folded Spill
	b.ne	LBB591_37
; %bb.16:                               ; %B40
	ldr	w9, [x20, #4]
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	b.ne	LBB591_45
; %bb.17:                               ; %B40
	ubfx	w9, w9, #8, #1
	cbz	w9, LBB591_45
; %bb.18:                               ; %B14
	ldr	x9, [x20, #8]
	ldr	x9, [x9, #32]
	cbz	x9, LBB591_20
; %bb.19:                               ; %B36
	ldr	w9, [x9, #4]
	ubfx	w9, w9, #13, #1
	cmp	w9, #1
	b.ne	LBB591_45
LBB591_20:                              ; %B32
	ldr	x9, [x20, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	LBB591_22
; %bb.21:                               ; %B32
	cmp	w9, w10
	b.hi	LBB591_39
LBB591_22:                              ; %B29
	ldr	w10, [x20, #32]
	cmp	w9, w10
	b.hi	LBB591_39
; %bb.23:                               ; %B25
	ldr	x10, [x20, #40]
	str	w9, [x20, #48]
	str	x21, [x10, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, LBB591_46
	b	LBB591_42
LBB591_24:                              ; %B11
	mov	x0, x21
	mov	x1, x24
	mov	x20, x10
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB591_25:                              ; %B63
	ldr	x8, [x8, #8]
	ldr	w8, [x8]
LBB591_26:                              ; %B102
	asr	w8, w8, #30
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	cmp	w8, #1
	b.ne	LBB591_45
; %bb.27:                               ; %B64
	ldr	x0, [x24, #8]
	and	x1, x22, #0xfffffffffffc
	bl	_prim_get_interned_non_index_atom
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	cbz	w0, LBB591_45
; %bb.28:                               ; %B66
	ldr	x8, [x20, #8]
	ldr	w9, [x8, #12]
	add	x11, x8, #64
	lsl	w10, w9, #2
	and	w8, w0, w9
	ldr	w8, [x11, w8, sxtw #2]
	add	w9, w10, #4
	add	x9, x11, x9
	cbz	w8, LBB591_31
LBB591_29:                              ; %B69
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	LBB591_40
; %bb.30:                               ; %B78
                                        ;   in Loop: Header=BB591_29 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB591_29
LBB591_31:                              ; %B80.preheader
	mov	x8, x20
LBB591_32:                              ; %B80
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB591_33 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	add	x9, x9, #64
	lsl	w11, w10, #2
	and	w10, w0, w10
	ldr	w10, [x9, w10, sxtw #2]
	add	w11, w11, #4
	add	x9, x9, x11
	cbz	w10, LBB591_35
LBB591_33:                              ; %B93
                                        ;   Parent Loop BB591_32 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10]
	cmp	w11, w0
	b.eq	LBB591_43
; %bb.34:                               ; %B98
                                        ;   in Loop: Header=BB591_33 Depth=2
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB591_33
LBB591_35:                              ; %B81
                                        ;   in Loop: Header=BB591_32 Depth=1
	ldr	w9, [x8, #4]
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB591_45
; %bb.36:                               ; %B87
                                        ;   in Loop: Header=BB591_32 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB591_32
	b	LBB591_44
LBB591_37:                              ; %B44
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	tbnz	w22, #31, LBB591_45
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
	tbz	w0, #31, LBB591_46
	b	LBB591_48
LBB591_39:                              ; %B20
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, x24
	mov	x1, x20
	mov	x2, x21
	mov	w3, #32768                      ; =0x8000
	add	x8, x9, #16
	stp	x22, x21, [x9]
	str	x8, [x23, #48]
	bl	_add_fast_array_element_gc
	tbz	w0, #31, LBB591_46
	b	LBB591_48
LBB591_40:                              ; %B71
	mov	w9, #58                         ; =0x3a
	and	w9, w9, w10, lsr #26
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	cmp	w9, #2
	b.ne	LBB591_45
; %bb.41:                               ; %B74
	ldr	x9, [x20, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
	ldrb	w8, [x24, #376]
	cbz	w8, LBB591_46
LBB591_42:                              ; %B76
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #16
	br	x1
LBB591_43:                              ; %B95
	mov	w8, #58                         ; =0x3a
	and	w8, w8, w10, lsr #26
	ldr	x10, [sp, #8]                   ; 8-byte Folded Reload
	cmp	w8, #2
	b.ne	LBB591_45
LBB591_44:                              ; %B84
	ldr	w8, [x20, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.eq	LBB591_47
LBB591_45:                              ; %B113
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
	tbnz	w0, #31, LBB591_48
LBB591_46:                              ; %B73
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #16
	br	x1
LBB591_47:                              ; %B85
	add	x20, x10, #16
	stp	x22, x21, [x10]
	mov	w0, w0
	add	sp, sp, #16
	b	l_FastAddNamedProperty_asm_h
LBB591_48:                              ; %B47
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
	b.eq	LBB615_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB615_2:                               ; %B3
	str	x21, [x20], #8
	b	l_ThrowReferenceErrorUninitialized_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function put_loc_check_2_asm_h
l_put_loc_check_2_asm_h:                ; @put_loc_check_2_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x9, [x27, x8, lsl #3]
	cmp	x9, #34
	b.eq	LBB616_2
; %bb.1:                                ; %B4
	str	x21, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB616_2:                               ; %B3
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
	b.ne	LBB617_2
; %bb.1:                                ; %B4
	str	x21, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB617_2:                               ; %B3
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
	.p2align	2                               ; -- Begin function put_var_ref_check_2_asm_h
l_put_var_ref_check_2_asm_h:            ; @put_var_ref_check_2_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	LBB619_2
; %bb.1:                                ; %B4
	str	x21, [x8]
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
	.p2align	2                               ; -- Begin function put_var_ref_check_init_2_asm_h
l_put_var_ref_check_init_2_asm_h:       ; @put_var_ref_check_init_2_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8]
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	LBB620_2
; %bb.1:                                ; %B4
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB620_2:                               ; %B3
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
; %bb.0:                                ; %B23
	cmp	x21, #5
	b.le	LBB622_4
; %bb.1:                                ; %B23
	cmp	x21, #6
	b.eq	LBB622_6
; %bb.2:                                ; %B23
	cmp	x21, #7
	b.eq	LBB622_9
; %bb.3:                                ; %B23
	cmp	x21, #18
	b.eq	LBB622_6
	b	LBB622_7
LBB622_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB622_6
; %bb.5:                                ; %B23
	cmp	x21, #2
	b.ne	LBB622_7
LBB622_6:                               ; %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB622_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x21, x8
	b.hs	LBB622_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB622_10
LBB622_9:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB622_10:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB622_13
; %bb.11:                               ; %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB622_6
	b.vs	LBB622_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB622_9
	b	LBB622_6
LBB622_13:                              ; %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_true_2_asm_h
l_if_true_2_asm_h:                      ; @if_true_2_asm_h
; %bb.0:                                ; %B23
	cmp	x21, #5
	b.le	LBB623_4
; %bb.1:                                ; %B23
	cmp	x21, #6
	b.eq	LBB623_6
; %bb.2:                                ; %B23
	cmp	x21, #7
	b.eq	LBB623_9
; %bb.3:                                ; %B23
	cmp	x21, #18
	b.eq	LBB623_6
	b	LBB623_7
LBB623_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB623_6
; %bb.5:                                ; %B23
	cmp	x21, #2
	b.ne	LBB623_7
LBB623_6:                               ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB623_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x21, x8
	b.hs	LBB623_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB623_10
LBB623_9:                               ; %B19
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB623_10:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB623_13
; %bb.11:                               ; %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB623_6
	b.vs	LBB623_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB623_9
	b	LBB623_6
LBB623_13:                              ; %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto_2_asm_h
l_goto_2_asm_h:                         ; @goto_2_asm_h
; %bb.0:                                ; %B0
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
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
	b.eq	LBB629_4
; %bb.1:                                ; %B15
	mov	x9, #1                          ; =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB629_4
; %bb.2:                                ; %B15
	cmp	x8, x9
	b.eq	LBB629_4
; %bb.3:                                ; %B15
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB629_5
LBB629_4:                               ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB629_5:                               ; %B12
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB629_7
; %bb.6:                                ; %B14
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB629_7:                               ; %B13
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function to_propkey2_2_asm_h
l_to_propkey2_2_asm_h:                  ; @to_propkey2_2_asm_h
; %bb.0:                                ; %B18
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	LBB630_3
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
LBB630_2:                               ; %B16
	b	l_exception_spill_top0_top1_asm_h
LBB630_3:                               ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	LBB630_7
; %bb.4:                                ; %B2
	mov	x9, #1                          ; =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB630_7
; %bb.5:                                ; %B2
	cmp	x8, x9
	b.eq	LBB630_7
; %bb.6:                                ; %B2
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB630_8
LBB630_7:                               ; %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB630_8:                               ; %B15
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB630_2
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
	b.hi	LBB658_3
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB658_6
; %bb.2:                                ; %B13
	orr	w8, w21, #0x80000000
	mov	w9, #-2147483648                ; =0x80000000
	cmp	w8, w9
	b.ne	LBB658_5
LBB658_3:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #140                        ; =0x8c
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB658_8
; %bb.4:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB658_5:                               ; %B15
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x1
LBB658_6:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB658_3
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
LBB658_8:                               ; %B17
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function plus_2_asm_h
l_plus_2_asm_h:                         ; @plus_2_asm_h
; %bb.0:                                ; %B13
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	LBB659_4
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB659_3
LBB659_2:                               ; %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB659_3:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.ne	LBB659_2
LBB659_4:                               ; %B10
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #141                        ; =0x8d
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB659_6
; %bb.5:                                ; %B12
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB659_6:                               ; %B11
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function dec_2_asm_h
l_dec_2_asm_h:                          ; @dec_2_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	LBB660_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB660_4
; %bb.2:                                ; %B13
	subs	w8, w21, #1
	b.vs	LBB660_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB660_4:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB660_6
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
LBB660_6:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #142                        ; =0x8e
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB660_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB660_8:                               ; %B17
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function inc_2_asm_h
l_inc_2_asm_h:                          ; @inc_2_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	LBB661_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB661_4
; %bb.2:                                ; %B13
	adds	w8, w21, #1
	b.vs	LBB661_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB661_4:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB661_6
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
LBB661_6:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #143                        ; =0x8f
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB661_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB661_8:                               ; %B17
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function post_dec_2_asm_h
l_post_dec_2_asm_h:                     ; @post_dec_2_asm_h
; %bb.0:                                ; %B16
	mov	x8, #-281474976710656           ; =0xffff000000000000
	str	x22, [x20], #8
	cmp	x21, x8
	b.hs	LBB662_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB662_4
; %bb.2:                                ; %B13
	subs	w8, w21, #1
	b.vs	LBB662_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	mov	x22, x21
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB662_4:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB662_6
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
LBB662_6:                               ; %B5
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
	b.hs	LBB663_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB663_4
; %bb.2:                                ; %B13
	adds	w8, w21, #1
	b.vs	LBB663_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	mov	x22, x21
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB663_4:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB663_6
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
LBB663_6:                               ; %B5
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
	b.hi	LBB664_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB664_4
; %bb.2:                                ; %B13
	subs	w9, w1, #1
	b.vs	LBB664_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB664_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB664_6
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
LBB664_6:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #142                        ; =0x8e
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB664_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB664_8:                               ; %B17
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function inc_loc_2_asm_h
l_inc_loc_2_asm_h:                      ; @inc_loc_2_asm_h
; %bb.0:                                ; %B19
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	b.hi	LBB665_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB665_4
; %bb.2:                                ; %B13
	adds	w9, w1, #1
	b.vs	LBB665_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB665_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB665_6
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
LBB665_6:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #143                        ; =0x8f
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB665_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB665_8:                               ; %B17
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
	b.hi	LBB666_17
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB666_6
; %bb.2:                                ; %B26
	cmp	x21, x9
	b.lo	LBB666_9
; %bb.3:                                ; %B36
	adds	w9, w1, w21
	b.vs	LBB666_12
; %bb.4:                                ; %B42
	orr	x9, x9, #0xfffe000000000000
LBB666_5:                               ; %B42
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB666_6:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB666_17
; %bb.7:                                ; %B11
	cmp	x21, x9
	b.lo	LBB666_15
; %bb.8:                                ; %B21
	scvtf	d0, w21
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	LBB666_14
LBB666_9:                               ; %B28
	tst	x21, #0xfffe000000000000
	b.eq	LBB666_17
; %bb.10:                               ; %B31
	scvtf	d0, w1
	add	x9, x21, x9
LBB666_11:                              ; %B31
	fmov	d1, x9
	b	LBB666_13
LBB666_12:                              ; %B38
	scvtf	d0, w1
	scvtf	d1, w21
LBB666_13:                              ; %B31
	fadd	d0, d0, d1
LBB666_14:                              ; %B31
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	add	x9, x9, x10
	mov	x10, #9221683186994511872       ; =0x7ffa000000000000
	csel	x9, x9, x10, vc
	b	LBB666_5
LBB666_15:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB666_17
; %bb.16:                               ; %B16
	add	x10, x1, x9
	add	x9, x21, x9
	fmov	d0, x10
	b	LBB666_11
LBB666_17:                              ; %B7
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
	b.ne	LBB666_20
; %bb.18:                               ; %B43
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, x24
	mov	x2, x21
	stp	x22, x21, [x8]
	str	x20, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB666_21
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
LBB666_20:                              ; %B8
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	w0, #1                          ; =0x1
	stp	x22, x21, [x8]
	add	sp, sp, #16
	b	l_FastJSConcatString_asm_h
LBB666_21:                              ; %B44
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function not_2_asm_h
l_not_2_asm_h:                          ; @not_2_asm_h
; %bb.0:                                ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	LBB667_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x1
LBB667_2:                               ; %B4
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
	b.le	LBB668_4
; %bb.1:                                ; %B14
	cmp	x21, #6
	b.eq	LBB668_6
; %bb.2:                                ; %B14
	cmp	x21, #7
	b.eq	LBB668_8
; %bb.3:                                ; %B14
	cmp	x21, #18
	b.eq	LBB668_6
	b	LBB668_7
LBB668_4:                               ; %B14
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB668_6
; %bb.5:                                ; %B14
	cmp	x21, #2
	b.ne	LBB668_7
LBB668_6:                               ; %B3
	mov	w21, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB668_7:                               ; %B10
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	LBB668_9
LBB668_8:                               ; %B12
	mov	w21, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB668_9:                               ; %B13
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
	b.eq	LBB669_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB669_2:                               ; %B2
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
	b.hi	LBB672_20
; %bb.1:                                ; %B51
	cmp	x21, x8
	b.hi	LBB672_20
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB672_8
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB672_11
; %bb.4:                                ; %B33
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	LBB672_14
; %bb.5:                                ; %B40
	cbnz	w8, LBB672_7
; %bb.6:                                ; %B40
	orr	w9, w22, w21
	tbnz	w9, #31, LBB672_17
LBB672_7:                               ; %B47
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB672_8:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB672_20
; %bb.9:                                ; %B7
	cmp	x21, x8
	b.lo	LBB672_18
; %bb.10:                               ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	LBB672_16
LBB672_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB672_20
; %bb.12:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB672_13:                              ; %B28
	fmov	d1, x8
	b	LBB672_15
LBB672_14:                              ; %B35
	scvtf	d0, w22
	scvtf	d1, w21
LBB672_15:                              ; %B28
	fmul	d0, d0, d1
LBB672_16:                              ; %B28
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
LBB672_17:                              ; %B44
	mov	x22, #-9222809086901354496      ; =0x8002000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB672_18:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB672_20
; %bb.19:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB672_13
LBB672_20:                              ; %B48
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        ; =0x9a
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB672_22
; %bb.21:                               ; %B50
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB672_22:                              ; %B49
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function div_2_asm_h
l_div_2_asm_h:                          ; @div_2_asm_h
; %bb.0:                                ; %B44
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB673_14
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB673_14
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB673_5
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB673_8
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
LBB673_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB673_14
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB673_12
; %bb.7:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	LBB673_11
LBB673_8:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB673_14
; %bb.9:                                ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB673_10:                              ; %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
LBB673_11:                              ; %B28
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
LBB673_12:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB673_14
; %bb.13:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB673_10
LBB673_14:                              ; %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        ; =0x9b
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB673_16
; %bb.15:                               ; %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB673_16:                              ; %B42
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function mod_2_asm_h
l_mod_2_asm_h:                          ; @mod_2_asm_h
; %bb.0:                                ; %B39
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB674_16
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB674_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB674_7
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB674_10
; %bb.4:                                ; %B33
	tbnz	w22, #31, LBB674_16
; %bb.5:                                ; %B33
	cmp	w21, #1
	b.lt	LBB674_16
; %bb.6:                                ; %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB674_7:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB674_16
; %bb.8:                                ; %B7
	cmp	x21, x8
	b.lo	LBB674_14
; %bb.9:                                ; %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	LBB674_13
LBB674_10:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB674_16
; %bb.11:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB674_12:                              ; %B28
	fmov	d1, x8
LBB674_13:                              ; %B28
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
LBB674_14:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB674_16
; %bb.15:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB674_12
LBB674_16:                              ; %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        ; =0x9c
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB674_18
; %bb.17:                               ; %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB674_18:                              ; %B37
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function add_2_asm_h
l_add_2_asm_h:                          ; @add_2_asm_h
; %bb.0:                                ; %B46
	sub	sp, sp, #16
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB675_17
; %bb.1:                                ; %B46
	cmp	x21, x8
	b.hi	LBB675_17
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB675_6
; %bb.3:                                ; %B26
	cmp	x21, x8
	b.lo	LBB675_9
; %bb.4:                                ; %B36
	adds	w8, w22, w21
	b.vs	LBB675_12
; %bb.5:                                ; %B42
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB675_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB675_17
; %bb.7:                                ; %B11
	cmp	x21, x8
	b.lo	LBB675_15
; %bb.8:                                ; %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	LBB675_14
LBB675_9:                               ; %B28
	tst	x21, #0xfffe000000000000
	b.eq	LBB675_17
; %bb.10:                               ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB675_11:                              ; %B31
	fmov	d1, x8
	b	LBB675_13
LBB675_12:                              ; %B38
	scvtf	d0, w22
	scvtf	d1, w21
LBB675_13:                              ; %B31
	fadd	d0, d0, d1
LBB675_14:                              ; %B31
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
LBB675_15:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB675_17
; %bb.16:                               ; %B16
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB675_11
LBB675_17:                              ; %B7
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
	b.ne	LBB675_20
; %bb.18:                               ; %B7
	cbz	w8, LBB675_20
; %bb.19:                               ; %B8
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, xzr
	stp	x22, x21, [x8]
	add	sp, sp, #16
	b	l_FastJSConcatString_asm_h
LBB675_20:                              ; %B43
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x8]
	str	x20, [x23, #48]
	bl	_prim_js_add_slow_gc
	cmp	x0, #130
	b.eq	LBB675_22
; %bb.21:                               ; %B45
	ldrb	w8, [x19], #1
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	add	sp, sp, #16
	br	x1
LBB675_22:                              ; %B44
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	add	sp, sp, #16
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function sub_2_asm_h
l_sub_2_asm_h:                          ; @sub_2_asm_h
; %bb.0:                                ; %B43
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB676_17
; %bb.1:                                ; %B43
	cmp	x21, x8
	b.hi	LBB676_17
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB676_6
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB676_9
; %bb.4:                                ; %B33
	subs	w8, w22, w21
	b.vs	LBB676_12
; %bb.5:                                ; %B39
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB676_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB676_17
; %bb.7:                                ; %B7
	cmp	x21, x8
	b.lo	LBB676_15
; %bb.8:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	LBB676_14
LBB676_9:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB676_17
; %bb.10:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB676_11:                              ; %B28
	fmov	d1, x8
	b	LBB676_13
LBB676_12:                              ; %B35
	scvtf	d0, w22
	scvtf	d1, w21
LBB676_13:                              ; %B28
	fsub	d0, d0, d1
LBB676_14:                              ; %B28
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
LBB676_15:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB676_17
; %bb.16:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB676_11
LBB676_17:                              ; %B40
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        ; =0x9e
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB676_19
; %bb.18:                               ; %B42
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB676_19:                              ; %B41
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
	b.eq	LBB677_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB677_2:                               ; %B2
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function shl_2_asm_h
l_shl_2_asm_h:                          ; @shl_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB678_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB678_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB678_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB678_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB678_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB678_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB678_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB678_9
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
LBB678_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        ; =0xa0
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB678_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB678_11:                              ; %B26
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function sar_2_asm_h
l_sar_2_asm_h:                          ; @sar_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB679_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB679_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB679_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB679_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB679_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB679_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB679_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB679_9
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
LBB679_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        ; =0xa1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB679_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB679_11:                              ; %B26
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function shr_2_asm_h
l_shr_2_asm_h:                          ; @shr_2_asm_h
; %bb.0:                                ; %B36
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB680_11
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB680_11
; %bb.2:                                ; %B10
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB680_6
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB680_11
; %bb.4:                                ; %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, LBB680_10
LBB680_5:                               ; %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB680_6:                               ; %B12
	tst	x22, #0xfffe000000000000
	b.eq	LBB680_11
; %bb.7:                                ; %B12
	cmp	x21, x8
	b.lo	LBB680_11
; %bb.8:                                ; %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB680_11
; %bb.9:                                ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, LBB680_5
LBB680_10:                              ; %B6
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
LBB680_11:                              ; %B33
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	LBB680_13
; %bb.12:                               ; %B35
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB680_13:                              ; %B34
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lt_2_asm_h
l_lt_2_asm_h:                           ; @lt_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB681_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB681_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB681_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB681_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, lt
	br	x1
LBB681_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB681_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB681_10
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
LBB681_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB681_12
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
LBB681_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB681_12
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
LBB681_12:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        ; =0xa3
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB681_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB681_14:                              ; %B22
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function lte_2_asm_h
l_lte_2_asm_h:                          ; @lte_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB682_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB682_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB682_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB682_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, le
	br	x1
LBB682_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB682_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB682_10
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
LBB682_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB682_12
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
LBB682_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB682_12
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
LBB682_12:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        ; =0xa4
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB682_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB682_14:                              ; %B22
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function gt_2_asm_h
l_gt_2_asm_h:                           ; @gt_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB683_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB683_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB683_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB683_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB683_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB683_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB683_10
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
LBB683_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB683_12
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
LBB683_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB683_12
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
LBB683_12:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        ; =0xa5
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB683_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB683_14:                              ; %B22
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function gte_2_asm_h
l_gte_2_asm_h:                          ; @gte_2_asm_h
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
	cinc	x22, x8, ge
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
	cinc	x22, x8, ge
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
	cinc	x22, x8, ge
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
	cinc	x22, x8, ge
	br	x1
LBB684_12:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        ; =0xa6
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
	b.eq	LBB685_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB685_2:                               ; %B2
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
	b.eq	LBB686_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB686_2:                               ; %B2
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function eq_2_asm_h
l_eq_2_asm_h:                           ; @eq_2_asm_h
; %bb.0:                                ; %B44
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB687_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB687_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB687_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB687_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB687_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB687_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB687_11
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
LBB687_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB687_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB687_10:                              ; %B39
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
LBB687_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB687_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB687_10
LBB687_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB687_15
LBB687_14:                              ; %B8
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB687_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB687_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB687_14
	b	LBB687_20
LBB687_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB687_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB687_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB687_21
LBB687_20:                              ; %B15
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB687_21:                              ; %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB687_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB687_23:                              ; %B42
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function neq_2_asm_h
l_neq_2_asm_h:                          ; @neq_2_asm_h
; %bb.0:                                ; %B44
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB688_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB688_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB688_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB688_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB688_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB688_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB688_11
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
LBB688_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB688_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB688_10:                              ; %B39
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
LBB688_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB688_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB688_10
LBB688_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB688_15
LBB688_14:                              ; %B8
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB688_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB688_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB688_14
	b	LBB688_20
LBB688_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB688_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB688_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB688_21
LBB688_20:                              ; %B15
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB688_21:                              ; %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB688_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB688_23:                              ; %B42
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function strict_eq_2_asm_h
l_strict_eq_2_asm_h:                    ; @strict_eq_2_asm_h
; %bb.0:                                ; %B39
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB689_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB689_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB689_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB689_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB689_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB689_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB689_11
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
LBB689_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB689_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB689_10:                              ; %B34
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
LBB689_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB689_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB689_10
LBB689_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB689_15
LBB689_14:                              ; %B11
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB689_15:                              ; %B13
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
	b.ne	LBB689_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB689_22
LBB689_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB689_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB689_23
LBB689_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB689_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB689_25
LBB689_21:                              ; %B21
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB689_22:                              ; %B14
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, xzr
	stp	x22, x21, [x8]
	b	l_FastStringEqual_asm_h
LBB689_23:                              ; %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB689_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB689_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB689_14
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB689_27:                              ; %B37
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function strict_neq_2_asm_h
l_strict_neq_2_asm_h:                   ; @strict_neq_2_asm_h
; %bb.0:                                ; %B39
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB690_13
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB690_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB690_5
; %bb.3:                                ; %B30
	cmp	x21, x8
	b.lo	LBB690_8
; %bb.4:                                ; %B35
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB690_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB690_13
; %bb.6:                                ; %B23
	cmp	x21, x8
	b.lo	LBB690_11
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
LBB690_8:                               ; %B32
	tst	x21, #0xfffe000000000000
	b.eq	LBB690_13
; %bb.9:                                ; %B34
	scvtf	d0, w22
	add	x8, x21, x8
LBB690_10:                              ; %B34
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
LBB690_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB690_13
; %bb.12:                               ; %B27
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB690_10
LBB690_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB690_15
LBB690_14:                              ; %B11
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB690_15:                              ; %B13
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
	b.ne	LBB690_17
; %bb.16:                               ; %B13
	cbnz	w11, LBB690_22
LBB690_17:                              ; %B16
	mov	x12, #2                         ; =0x2
	movk	x12, #65535, lsl #48
	cmp	x8, x12
	cset	w8, ne
	cmp	x10, x12
	bic	w9, w8, w9
	csinc	w8, w11, wzr, ne
	tbnz	w9, #0, LBB690_19
; %bb.18:                               ; %B16
	tbnz	w8, #0, LBB690_23
LBB690_19:                              ; %B19
	and	x9, x22, #0xffff000000000003
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x9, x8
	b.ne	LBB690_21
; %bb.20:                               ; %B19
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.eq	LBB690_25
LBB690_21:                              ; %B21
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB690_22:                              ; %B14
	mov	x8, x20
	add	x20, x20, #16
	mov	w0, #1                          ; =0x1
	stp	x22, x21, [x8]
	b	l_FastStringEqual_asm_h
LBB690_23:                              ; %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB690_27
; %bb.24:                               ; %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB690_25:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB690_14
; %bb.26:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB690_27:                              ; %B37
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function and_2_asm_h
l_and_2_asm_h:                          ; @and_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB691_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB691_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB691_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB691_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	and	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB691_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB691_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB691_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB691_9
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
LBB691_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        ; =0xad
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB691_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB691_11:                              ; %B26
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function xor_2_asm_h
l_xor_2_asm_h:                          ; @xor_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB692_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB692_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB692_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB692_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	eor	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB692_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB692_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB692_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB692_9
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
LBB692_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        ; =0xae
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB692_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB692_11:                              ; %B26
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function or_2_asm_h
l_or_2_asm_h:                           ; @or_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB693_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB693_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB693_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB693_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	orr	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB693_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB693_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB693_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB693_9
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
LBB693_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        ; =0xaf
	stp	x22, x21, [x20]
	str	x8, [x23, #48]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB693_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB693_11:                              ; %B26
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
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #1]
	ldr	x9, [x23, #104]
	ldrb	w10, [x19], #2
	add	w8, w8, #486
	ldr	x9, [x9, x10, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x9
	br	x1
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
	b.eq	LBB708_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB708_2:                               ; %B2
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
	b.eq	LBB748_2
; %bb.1:                                ; %B27
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB748_3
LBB748_2:                               ; %B28
	and	x8, x21, #0xfffffffffffc
	ldrb	w9, [x19], #1
	ldr	w8, [x8, #4]
	mov	x10, #-562949953421312          ; =0xfffe000000000000
	add	w9, w9, #486
	bfxil	x10, x8, #0, #30
	ldr	x1, [x25, w9, uxtw #3]
	mov	x21, x10
	br	x1
LBB748_3:                               ; %B21
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	LBB748_13
; %bb.4:                                ; %B22
	mov	x9, x21
	mov	w8, #18                         ; =0x12
LBB748_5:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB748_6 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	add	x13, x10, #64
	lsl	w12, w11, #2
	and	w10, w11, #0x30
	ldr	w10, [x13, w10, uxtw #2]
	add	w11, w12, #4
	add	x11, x13, x11
	cbz	w10, LBB748_8
LBB748_6:                               ; %B1
                                        ;   Parent Loop BB748_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12]
	cmp	w13, #48
	b.eq	LBB748_10
; %bb.7:                                ; %B9
                                        ;   in Loop: Header=BB748_6 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB748_6
LBB748_8:                               ; %B14
                                        ;   in Loop: Header=BB748_5 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB748_13
; %bb.9:                                ; %B17
                                        ;   in Loop: Header=BB748_5 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB748_5
	b	LBB748_12
LBB748_10:                              ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB748_13
; %bb.11:                               ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB748_12:                              ; %B6
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB748_13:                              ; %B24
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
	b.eq	LBB748_15
; %bb.14:                               ; %B26
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB748_15:                              ; %B25
	b	l_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_false8_2_asm_h
l_if_false8_2_asm_h:                    ; @if_false8_2_asm_h
; %bb.0:                                ; %B23
	cmp	x21, #5
	b.le	LBB749_4
; %bb.1:                                ; %B23
	cmp	x21, #6
	b.eq	LBB749_6
; %bb.2:                                ; %B23
	cmp	x21, #7
	b.eq	LBB749_9
; %bb.3:                                ; %B23
	cmp	x21, #18
	b.eq	LBB749_6
	b	LBB749_7
LBB749_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB749_6
; %bb.5:                                ; %B23
	cmp	x21, #2
	b.ne	LBB749_7
LBB749_6:                               ; %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB749_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x21, x8
	b.hs	LBB749_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB749_10
LBB749_9:                               ; %B19
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB749_10:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB749_13
; %bb.11:                               ; %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB749_6
	b.vs	LBB749_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB749_9
	b	LBB749_6
LBB749_13:                              ; %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function if_true8_2_asm_h
l_if_true8_2_asm_h:                     ; @if_true8_2_asm_h
; %bb.0:                                ; %B23
	cmp	x21, #5
	b.le	LBB750_4
; %bb.1:                                ; %B23
	cmp	x21, #6
	b.eq	LBB750_6
; %bb.2:                                ; %B23
	cmp	x21, #7
	b.eq	LBB750_9
; %bb.3:                                ; %B23
	cmp	x21, #18
	b.eq	LBB750_6
	b	LBB750_7
LBB750_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB750_6
; %bb.5:                                ; %B23
	cmp	x21, #2
	b.ne	LBB750_7
LBB750_6:                               ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB750_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x21, x8
	b.hs	LBB750_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB750_10
LBB750_9:                               ; %B19
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB750_10:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB750_13
; %bb.11:                               ; %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB750_6
	b.vs	LBB750_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB750_9
	b	LBB750_6
LBB750_13:                              ; %B15
	mov	x8, x20
	add	x20, x20, #16
	mov	x0, x21
	stp	x22, x21, [x8]
	b	l_SlowToBoolean_asm_h
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto8_2_asm_h
l_goto8_2_asm_h:                        ; @goto8_2_asm_h
; %bb.0:                                ; %B0
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
                                        ; -- End function
	.p2align	2                               ; -- Begin function goto16_2_asm_h
l_goto16_2_asm_h:                       ; @goto16_2_asm_h
; %bb.0:                                ; %B0
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
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
	b.ne	LBB757_2
; %bb.1:                                ; %B3
	mov	w21, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB757_2:                               ; %B5
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
	b.ne	LBB758_2
; %bb.1:                                ; %B3
	mov	w21, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB758_2:                               ; %B5
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
	b.ne	LBB759_2
; %bb.1:                                ; %B2
	mov	w21, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB759_2:                               ; %B5
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

.subsections_via_symbols
#endif
