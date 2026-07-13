#if defined(__aarch64__) && defined(ENABLE_PRIMJS_SNAPSHOT) && !defined(ENABLE_QUICKJS_DEBUGGER)
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
	add	x9, x8, #32
	str	x8, [x24, #304]
	mov	x19, x10
	stp	x23, x22, [x8]
	mov	x28, x20
	mov	x27, xzr
	stp	x9, x9, [x8, #32]
	stp	xzr, xzr, [x8, #64]
	stp	w3, wzr, [x8, #56]
	stp	x20, xzr, [x8, #16]
	str	xzr, [x8, #80]
	str	wzr, [x8, #88]
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
	add	x9, x8, #32
	str	x8, [x24, #304]
	mov	x19, x10
	stp	x23, x22, [x8]
	mov	x28, x20
	mov	x27, xzr
	stp	x9, x9, [x8, #32]
	stp	xzr, xzr, [x8, #64]
	stp	w3, wzr, [x8, #56]
	stp	x20, xzr, [x8, #16]
	str	xzr, [x8, #80]
	str	wzr, [x8, #88]
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
; %bb.0:                                ; %B40
	tbz	w19, #2, LBB4_3
; %bb.1:                                ; %B31
	ldr	x9, [x24, #304]
	and	x8, x22, #0xfffffffffffc
	add	x11, x8, #16
	stp	x9, x30, [x8, #160]
	mov	x23, x11
	ldr	x9, [x24, #8]
	ldr	x10, [x9, #256]
	str	x10, [x8, #16]
	str	x11, [x9, #256]
	ldr	x19, [x8, #64]
	ldr	w9, [x8, #12]
	ldr	x20, [x8, #80]
	ldp	x28, x27, [x8, #32]
	ldr	x26, [x8, #128]
	cbnz	w9, LBB4_11
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
	ldr	x11, [x22, #32]
	ldp	x14, x13, [x24, #296]
	mov	x12, x23
	ldrh	w9, [x11, #40]
	ldrh	w8, [x11, #42]
	ldrh	w10, [x11, #46]
	cmp	w0, w9
	add	w10, w8, w10
	b.lt	LBB4_14
; %bb.6:                                ; %B28
	add	w9, w10, w0
	lsl	w9, w9, #3
	add	w9, w9, #160
	sub	x9, x13, x9
	cmp	x9, x14
	b.ls	LBB4_21
; %bb.7:                                ; %B30
	str	x9, [x24, #304]
	add	x10, x9, #32
	mov	x23, x9
	stp	x13, x30, [x9, #144]
	stp	x12, x22, [x9]
	stp	x21, x27, [x9, #96]
	ldr	x13, [x22, #40]
	stp	x10, x10, [x9, #32]
	str	x13, [x9, #112]
	mov	x26, x13
	ldrb	w10, [x11, #5]
	str	w10, [x9, #60]
	ldr	x19, [x11, #8]
	str	w0, [x9, #128]
	ldr	x12, [x11, #48]
	add	x11, x9, #160
	add	x10, x11, w0, uxtw #3
	str	x12, [x9, #120]
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
	str	w0, [x9, #56]
	add	x20, x10, x8, lsl #3
	stp	x11, x10, [x9, #16]
	mov	w8, #18                         ; =0x12
	mov	x28, x11
	str	xzr, [x9, #80]
	mov	x27, x10
	str	w12, [x9, #88]
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
	b	_exception_asm_h
LBB4_12:                                ; %B39
	b	_ThrowTypeErrorNotFunction_Return_asm_h
LBB4_13:                                ; %B37
	b	_call_native_entry_asm_h
LBB4_14:                                ; %B16
	add	w10, w10, w9
	lsl	w10, w10, #3
	add	w10, w10, #160
	sub	x10, x13, x10
	cmp	x10, x14
	b.ls	LBB4_21
; %bb.15:                               ; %B18
	str	x10, [x24, #304]
	mov	x23, x10
	stp	x13, x30, [x10, #144]
	stp	x12, x22, [x10]
	add	x12, x10, #32
	stp	x21, x27, [x10, #96]
	ldr	x13, [x22, #40]
	stp	x12, x12, [x10, #32]
	str	x13, [x10, #112]
	mov	x26, x13
	ldrb	w12, [x11, #5]
	str	w12, [x10, #60]
	ldr	x19, [x11, #8]
	str	w0, [x10, #128]
	ldr	x12, [x11, #48]
	add	x11, x10, #160
	str	x12, [x10, #120]
	mov	x12, x11
	cmp	w0, w9
	csel	w13, w0, w9, lt
	add	x13, x11, w13, uxtw #3
	cmp	x11, x13
	b.ge	LBB4_17
LBB4_16:                                ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x13, [x20], #8
	str	x13, [x12], #8
	cmp	w0, w9
	csel	w13, w0, w9, lt
	add	x13, x11, w13, uxtw #3
	cmp	x12, x13
	b.lt	LBB4_16
LBB4_17:                                ; %B9.preheader
	add	x12, x11, x9, lsl #3
	mov	w14, #18                        ; =0x12
	cmp	x13, x12
	b.ge	LBB4_19
LBB4_18:                                ; %B10
                                        ; =>This Inner Loop Header: Depth=1
	str	x14, [x13], #8
	cmp	x13, x12
	b.lt	LBB4_18
LBB4_19:                                ; %B11
	str	w9, [x10, #56]
	add	w9, w9, w8
	add	x20, x12, x8, lsl #3
	stp	x11, x12, [x10, #16]
	mov	w8, #18                         ; =0x12
	mov	x28, x11
	str	xzr, [x10, #80]
	mov	x27, x12
	str	w9, [x10, #88]
	ldr	x9, [x24, #8]
	str	x10, [x9, #256]
	cmp	x12, x20
	b.ge	LBB4_2
LBB4_20:                                ; %B14
                                        ; =>This Inner Loop Header: Depth=1
	str	x8, [x12], #8
	cmp	x12, x20
	b.lt	LBB4_20
	b	LBB4_2
LBB4_21:                                ; %B17
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
	ldp	x14, x13, [x24, #296]
	mov	x12, x23
	ldrh	w9, [x11, #40]
	ldrh	w8, [x11, #42]
	ldrh	w10, [x11, #46]
	cmp	w0, w9
	add	w10, w8, w10
	b.lt	LBB6_9
; %bb.3:                                ; %B24
	lsl	w9, w10, #3
	add	w9, w9, #160
	sub	x9, x13, x9
	cmp	x9, x14
	b.ls	LBB6_17
; %bb.4:                                ; %B26
	str	x9, [x24, #304]
	add	x10, x9, #32
	mov	x23, x9
	stp	x13, x30, [x9, #144]
	mov	x28, x20
	stp	x12, x22, [x9]
	stp	x21, x27, [x9, #96]
	ldr	x12, [x22, #40]
	stp	x10, x10, [x9, #32]
	str	x12, [x9, #112]
	mov	x26, x12
	ldrb	w10, [x11, #5]
	str	w10, [x9, #60]
	ldr	x19, [x11, #8]
	str	w0, [x9, #128]
	ldr	x10, [x11, #48]
	add	w11, w0, w8
	str	w0, [x9, #56]
	str	xzr, [x9, #80]
	str	x10, [x9, #120]
	add	x10, x9, #160
	stp	x20, x10, [x9, #16]
	add	x8, x10, x8, lsl #3
	mov	x27, x10
	str	w11, [x9, #88]
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
	b	_ThrowTypeErrorNotFunction_Return_asm_h
LBB6_8:                                 ; %B28
	b	_call_native_asm_h
LBB6_9:                                 ; %B16
	add	w10, w10, w9
	lsl	w10, w10, #3
	add	w10, w10, #160
	sub	x10, x13, x10
	cmp	x10, x14
	b.ls	LBB6_17
; %bb.10:                               ; %B18
	str	x10, [x24, #304]
	mov	x23, x10
	stp	x13, x30, [x10, #144]
	stp	x12, x22, [x10]
	add	x12, x10, #32
	stp	x21, x27, [x10, #96]
	ldr	x13, [x22, #40]
	stp	x12, x12, [x10, #32]
	str	x13, [x10, #112]
	mov	x26, x13
	ldrb	w12, [x11, #5]
	str	w12, [x10, #60]
	ldr	x19, [x11, #8]
	str	w0, [x10, #128]
	ldr	x12, [x11, #48]
	add	x11, x10, #160
	str	x12, [x10, #120]
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
	str	w9, [x10, #56]
	add	w9, w9, w8
	add	x20, x12, x8, lsl #3
	stp	x11, x12, [x10, #16]
	mov	w8, #18                         ; =0x12
	mov	x28, x11
	str	xzr, [x10, #80]
	mov	x27, x12
	str	w9, [x10, #88]
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
	b	_ThrowStackOverflow_Return_asm_h
                                        ; -- End function
	.private_extern	_common_return_direct_asm_h ; -- Begin function common_return_direct_asm_h
	.globl	_common_return_direct_asm_h
	.p2align	2
_common_return_direct_asm_h:            ; @common_return_direct_asm_h
; %bb.0:                                ; %B0
	ldp	x8, x9, [x23, #144]
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
; %bb.0:                                ; %B0
	ldurb	w8, [x19, #-1]
	sub	w8, w8, #729
	ldr	x1, [x25, w8, sxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_common_call_debugger1_asm_h ; -- Begin function common_call_debugger1_asm_h
	.globl	_common_call_debugger1_asm_h
	.p2align	2
_common_call_debugger1_asm_h:           ; @common_call_debugger1_asm_h
; %bb.0:                                ; %B0
	ldurb	w8, [x19, #-1]
	sub	w8, w8, #486
	ldr	x1, [x25, w8, sxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_common_call_debugger2_asm_h ; -- Begin function common_call_debugger2_asm_h
	.globl	_common_call_debugger2_asm_h
	.p2align	2
_common_call_debugger2_asm_h:           ; @common_call_debugger2_asm_h
; %bb.0:                                ; %B0
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
	ldr	x8, [x23, #80]
	cbnz	x8, LBB12_3
; %bb.1:                                ; %B1
	ldrb	w8, [x24, #384]
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
	str	x20, [x23, #64]
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
	str	x20, [x23, #64]
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
	str	x20, [x23, #64]
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
	.private_extern	_ThrowReferenceErrorUninitialized_asm_h ; -- Begin function ThrowReferenceErrorUninitialized_asm_h
	.globl	_ThrowReferenceErrorUninitialized_asm_h
	.p2align	2
_ThrowReferenceErrorUninitialized_asm_h: ; @ThrowReferenceErrorUninitialized_asm_h
; %bb.0:                                ; %B0
	mov	x0, x24
	mov	w1, wzr
	str	x20, [x23, #64]
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
	str	x20, [x23, #64]
	bl	_LEPUS_ThrowReferenceError
	b	_exception_asm_h
	.loh AdrpAdd	Lloh0, Lloh1
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
	str	x20, [x23, #64]
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
; %bb.0:                                ; %B0
	ldrb	w9, [x19, #4]
	ldr	x8, [x23, #120]
	ldrsw	x10, [x19]
	add	x19, x19, #5
	add	w9, w9, #243
	ldr	x22, [x8, x10, lsl #3]
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_fclosure_0_asm_h       ; -- Begin function fclosure_0_asm_h
	.globl	_fclosure_0_asm_h
	.p2align	2
_fclosure_0_asm_h:                      ; @fclosure_0_asm_h
; %bb.0:                                ; %B1
	ldr	x8, [x23, #120]
	ldrsw	x9, [x19]
	mov	x0, x24
	mov	x2, x26
	mov	x3, x23
	ldr	x1, [x8, x9, lsl #3]
	str	x20, [x23, #64]
	bl	_js_closure_gc
	cmp	x0, #130
	b.eq	LBB24_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB24_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_push_atom_value_0_asm_h ; -- Begin function push_atom_value_0_asm_h
	.globl	_push_atom_value_0_asm_h
	.p2align	2
_push_atom_value_0_asm_h:               ; @push_atom_value_0_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #64]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB25_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB25_2:                                ; %B2
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
	str	x20, [x23, #64]
	bl	_JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	LBB26_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB26_2:                                ; %B2
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
	ldr	w8, [x23, #60]
	ldr	x1, [x23, #96]
	tbnz	w8, #0, LBB29_2
; %bb.1:                                ; %B12
	ldr	x8, [x23, #96]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, LBB29_3
LBB29_2:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x1
	add	w8, w8, #243
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
LBB29_3:                                ; %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	LBB29_5
; %bb.4:                                ; %B7
	ldrb	w8, [x19], #1
	ldr	x22, [x24, #208]
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB29_5:                                ; %B9
	mov	x0, x24
	str	x20, [x23, #64]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB29_7
; %bb.6:                                ; %B11
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB29_7:                                ; %B10
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
; %bb.0:                                ; %B1
	mov	x0, x24
	str	x20, [x23, #64]
	bl	_PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	LBB32_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB32_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_special_object_0_asm_h ; -- Begin function special_object_0_asm_h
	.globl	_special_object_0_asm_h
	.p2align	2
_special_object_0_asm_h:                ; @special_object_0_asm_h
; %bb.0:                                ; %B15
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	LBB33_4
; %bb.1:                                ; %B15
	cbz	w8, LBB33_7
; %bb.2:                                ; %B15
	cmp	w8, #1
	b.ne	LBB33_12
; %bb.3:                                ; %B6
	ldr	x8, [x23, #8]
	ldr	w1, [x23, #128]
	mov	x0, x24
	mov	x2, x28
	mov	x3, x23
	ldr	x8, [x8, #32]
	ldrh	w8, [x8, #40]
	str	x20, [x23, #64]
	cmp	w8, w1
	csel	w4, w8, w1, lt
	bl	_js_build_mapped_arguments_gc
	b	LBB33_8
LBB33_4:                                ; %B15
	cmp	w8, #5
	b.eq	LBB33_10
; %bb.5:                                ; %B15
	cmp	w8, #4
	b.ne	LBB33_13
; %bb.6:                                ; %B9
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
LBB33_7:                                ; %B1
	ldr	w1, [x23, #128]
	mov	x0, x24
	mov	x2, x28
	str	x20, [x23, #64]
	bl	_js_build_arguments_gc
LBB33_8:                                ; %B6
	cmp	x0, #130
	b.eq	LBB33_11
LBB33_9:
	mov	x8, x0
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB33_10:                               ; %B12
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x20, [x23, #64]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.ne	LBB33_9
LBB33_11:                               ; %B13
	b	_exception_asm_h
LBB33_12:                               ; %B18
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB33_13:                               ; %B19
	ldr	x8, [x23, #104]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_rest_0_asm_h           ; -- Begin function rest_0_asm_h
	.globl	_rest_0_asm_h
	.p2align	2
_rest_0_asm_h:                          ; @rest_0_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x23, #128]
	ldrh	w1, [x19]
	mov	x0, x24
	mov	x3, x28
	str	x20, [x23, #64]
	bl	_js_build_rest_gc
	cmp	x0, #130
	b.eq	LBB34_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB34_2:                                ; %B2
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
; %bb.0:                                ; %B1
	add	x8, x19, #2
	mov	x0, x24
	mov	w5, wzr
	str	x8, [x23, #48]
	ldrh	w3, [x19]
	sub	x4, x20, w3, uxtw #3
	ldp	x1, x2, [x4, #-16]
	str	x20, [x23, #64]
	bl	_JS_CallConstructorInternal_GC
	cmp	x0, #130
	b.eq	LBB54_2
; %bb.1:                                ; %B3
	ldrh	w8, [x19]
	sub	x8, x20, x8, lsl #3
	stur	x0, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x9, lsl #3]
	br	x1
LBB54_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_call_0_asm_h           ; -- Begin function call_0_asm_h
	.globl	_call_0_asm_h
	.p2align	2
_call_0_asm_h:                          ; @call_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19], #2
	str	x20, [x23, #64]
	str	x19, [x23, #48]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	sub	x20, x20, x8, lsl #3
	mov	x0, x8
	ldur	x22, [x20, #-8]
	bl	_common_call_asm_h
	ldr	x19, [x23, #48]
	ldr	x20, [x23, #64]
	cmp	x0, #130
	ldp	x28, x27, [x23, #16]
	ldr	x26, [x23, #112]
	b.eq	LBB55_2
; %bb.1:                                ; %B4
	ldurh	w8, [x19, #-2]
	add	w8, w8, #1
	sub	x20, x20, w8, uxtw #3
	str	x0, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB55_2:                                ; %B3
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_tail_call_0_asm_h      ; -- Begin function tail_call_0_asm_h
	.globl	_tail_call_0_asm_h
	.p2align	2
_tail_call_0_asm_h:                     ; @tail_call_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19], #2
	str	x20, [x23, #64]
	str	x19, [x23, #48]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	sub	x20, x20, x8, lsl #3
	mov	x0, x8
	ldur	x22, [x20, #-8]
	bl	_common_call_asm_h
	cmp	x0, #130
	b.eq	LBB56_2
; %bb.1:                                ; %B4
	ldr	x26, [x23, #112]
	mov	x19, xzr
	mov	x20, xzr
	b	_common_return_asm_h
LBB56_2:                                ; %B3
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
	str	x20, [x23, #64]
	str	x19, [x23, #48]
	mov	w27, #18                        ; =0x12
	sub	x20, x20, x8, lsl #3
	mov	x0, x8
	ldp	x21, x22, [x20, #-16]
	bl	_common_call_asm_h
	ldr	x19, [x23, #48]
	ldr	x20, [x23, #64]
	cmp	x0, #130
	ldp	x28, x27, [x23, #16]
	ldr	x26, [x23, #112]
	b.eq	LBB57_2
; %bb.1:                                ; %B4
	ldurh	w8, [x19, #-2]
	add	w8, w8, #2
	sub	x20, x20, w8, uxtw #3
	str	x0, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB57_2:                                ; %B3
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_tail_call_method_0_asm_h ; -- Begin function tail_call_method_0_asm_h
	.globl	_tail_call_method_0_asm_h
	.p2align	2
_tail_call_method_0_asm_h:              ; @tail_call_method_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19], #2
	str	x20, [x23, #64]
	str	x19, [x23, #48]
	mov	w27, #18                        ; =0x12
	sub	x20, x20, x8, lsl #3
	mov	x0, x8
	ldp	x21, x22, [x20, #-16]
	bl	_common_call_asm_h
	cmp	x0, #130
	b.eq	LBB58_2
; %bb.1:                                ; %B4
	ldr	x26, [x23, #112]
	mov	x19, xzr
	mov	x20, xzr
	b	_common_return_asm_h
LBB58_2:                                ; %B3
	mov	x19, xzr
	mov	x20, xzr
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_array_from_0_asm_h     ; -- Begin function array_from_0_asm_h
	.globl	_array_from_0_asm_h
	.p2align	2
_array_from_0_asm_h:                    ; @array_from_0_asm_h
; %bb.0:                                ; %B1
	ldrh	w1, [x19]
	mov	x0, x24
	str	x20, [x23, #64]
	sub	x2, x20, w1, uxtw #3
	bl	_JS_NewArrayWithArgs_GC
	cmp	x0, #130
	b.eq	LBB59_2
; %bb.1:                                ; %B3
	ldrh	w8, [x19]
	sub	x20, x20, x8, lsl #3
	str	x0, [x20], #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB59_2:                                ; %B2
	b	_exception_asm_h
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
	str	x20, [x23, #64]
	str	x3, [sp, #8]                    ; 8-byte Folded Spill
	bl	_js_function_apply_gc
	cmp	x0, #130
	b.eq	LBB60_2
; %bb.1:                                ; %B3
	stur	x0, [x20, #-24]
	ldr	x20, [sp, #8]                   ; 8-byte Folded Reload
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB60_2:                                ; %B2
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
	b.eq	LBB63_3
; %bb.1:                                ; %B2
	cmp	x22, #18
	b.eq	LBB63_4
; %bb.2:                                ; %B3
Lloh4:
	adrp	x1, l___unnamed_3@PAGE
Lloh5:
	add	x1, x1, l___unnamed_3@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #64]
	bl	_LEPUS_ThrowTypeError
	b	_exception_asm_h
LBB63_3:                                ; %B6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w21, #6                         ; =0x6
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB63_4:                                ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w21, #7                         ; =0x7
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh4, Lloh5
                                        ; -- End function
	.private_extern	_check_ctor_0_asm_h     ; -- Begin function check_ctor_0_asm_h
	.globl	_check_ctor_0_asm_h
	.p2align	2
_check_ctor_0_asm_h:                    ; @check_ctor_0_asm_h
; %bb.0:                                ; %B2
	ldr	x8, [x23, #104]
	cmp	x8, #18
	b.ne	LBB64_2
; %bb.1:                                ; %B3
Lloh6:
	adrp	x1, l___unnamed_4@PAGE
Lloh7:
	add	x1, x1, l___unnamed_4@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #64]
	bl	_LEPUS_ThrowTypeError
	b	_exception_asm_h
LBB64_2:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
	.loh AdrpAdd	Lloh6, Lloh7
                                        ; -- End function
	.private_extern	_check_brand_0_asm_h    ; -- Begin function check_brand_0_asm_h
	.globl	_check_brand_0_asm_h
	.p2align	2
_check_brand_0_asm_h:                   ; @check_brand_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	mov	x2, x21
	bl	_JS_CheckBrand_GC
	tbnz	w0, #31, LBB65_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB65_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_add_brand_0_asm_h      ; -- Begin function add_brand_0_asm_h
	.globl	_add_brand_0_asm_h
	.p2align	2
_add_brand_0_asm_h:                     ; @add_brand_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	mov	x2, x21
	bl	_JS_AddBrand_GC
	tbnz	w0, #31, LBB66_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB66_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_return_async_0_asm_h   ; -- Begin function return_async_0_asm_h
	.globl	_return_async_0_asm_h
	.p2align	2
_return_async_0_asm_h:                  ; @return_async_0_asm_h
; %bb.0:                                ; %B0
	str	x19, [x23, #48]
	mov	w0, #18                         ; =0x12
	str	x20, [x23, #64]
	b	_common_return_direct_asm_h
                                        ; -- End function
	.private_extern	_throw_0_asm_h          ; -- Begin function throw_0_asm_h
	.globl	_throw_0_asm_h
	.p2align	2
_throw_0_asm_h:                         ; @throw_0_asm_h
; %bb.0:                                ; %B0
	ldr	x1, [x20, #-8]!
	mov	x0, x24
	str	x20, [x23, #64]
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
	str	x20, [x23, #64]
	cmp	w8, #1
	b.le	LBB69_5
; %bb.1:                                ; %B3
	cmp	w8, #2
	b.eq	LBB69_8
; %bb.2:                                ; %B3
	cmp	w8, #3
	b.eq	LBB69_9
; %bb.3:                                ; %B3
	cmp	w8, #4
	b.ne	LBB69_11
; %bb.4:                                ; %B8
Lloh8:
	adrp	x1, l___unnamed_5@PAGE
Lloh9:
	add	x1, x1, l___unnamed_5@PAGEOFF
	mov	x0, x24
	bl	_LEPUS_ThrowTypeError
	add	sp, sp, #16
	b	_exception_asm_h
LBB69_5:                                ; %B3
	cbz	w8, LBB69_10
; %bb.6:                                ; %B3
	cmp	w8, #1
	b.ne	LBB69_11
; %bb.7:                                ; %B5
	mov	x0, x24
	mov	w1, w2
	bl	_JS_ThrowSyntaxErrorVarRedeclaration_GC
	add	sp, sp, #16
	b	_exception_asm_h
LBB69_8:                                ; %B6
	mov	x0, x24
	mov	w1, w2
	bl	_JS_ThrowReferenceErrorUninitialized_GC
	add	sp, sp, #16
	b	_exception_asm_h
LBB69_9:                                ; %B7
Lloh10:
	adrp	x1, l___unnamed_6@PAGE
Lloh11:
	add	x1, x1, l___unnamed_6@PAGEOFF
	mov	x0, x24
	bl	_LEPUS_ThrowReferenceError
	add	sp, sp, #16
	b	_exception_asm_h
LBB69_10:                               ; %B4
	mov	x0, x24
	mov	w1, #16384                      ; =0x4000
                                        ; kill: def $w2 killed $w2 killed $x2
	bl	_JS_ThrowTypeErrorReadOnly
	add	sp, sp, #16
	b	_exception_asm_h
LBB69_11:                               ; %B9
Lloh12:
	adrp	x1, l___unnamed_7@PAGE
Lloh13:
	add	x1, x1, l___unnamed_7@PAGEOFF
	mov	x0, x24
	str	x2, [sp]
	bl	_LEPUS_ThrowInternalError
	add	sp, sp, #16
	b	_exception_asm_h
	.loh AdrpAdd	Lloh8, Lloh9
	.loh AdrpAdd	Lloh10, Lloh11
	.loh AdrpAdd	Lloh12, Lloh13
                                        ; -- End function
	.private_extern	_eval_0_asm_h           ; -- Begin function eval_0_asm_h
	.globl	_eval_0_asm_h
	.p2align	2
_eval_0_asm_h:                          ; @eval_0_asm_h
; %bb.0:                                ; %B1
	ldrh	w8, [x19]
	ldur	x2, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #64]
	sub	w1, w8, #1
	bl	_prim_js_op_eval_gc
	cmp	x0, #130
	b.eq	LBB70_2
; %bb.1:                                ; %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB70_2:                                ; %B2
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
	str	x20, [x23, #64]
	mov	x2, x22
	mov	x3, x21
	bl	_js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	LBB71_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB71_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_super_ctor_0_asm_h ; -- Begin function get_super_ctor_0_asm_h
	.globl	_get_super_ctor_0_asm_h
	.p2align	2
_get_super_ctor_0_asm_h:                ; @get_super_ctor_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	bl	_primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	LBB72_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB72_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_super_0_asm_h      ; -- Begin function get_super_0_asm_h
	.globl	_get_super_0_asm_h
	.p2align	2
_get_super_0_asm_h:                     ; @get_super_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	bl	_JS_GetPrototype_GC
	cmp	x0, #130
	b.eq	LBB73_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB73_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_import_0_asm_h         ; -- Begin function import_0_asm_h
	.globl	_import_0_asm_h
	.p2align	2
_import_0_asm_h:                        ; @import_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	bl	_js_dynamic_import
	cmp	x0, #130
	b.eq	LBB74_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB74_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_check_var_0_asm_h      ; -- Begin function check_var_0_asm_h
	.globl	_check_var_0_asm_h
	.p2align	2
_check_var_0_asm_h:                     ; @check_var_0_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x23, #64]
	bl	_JS_CheckGlobalVar_GC
	tbnz	w0, #31, LBB75_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB75_2:                                ; %B2
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
	and	w11, w9, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, LBB76_3
LBB76_1:                                ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldr	w13, [x12, #44]
	cmp	w13, w9
	b.eq	LBB76_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB76_1 Depth=1
	ldur	w11, [x12, #40]
	and	w11, w11, #0x3ffffff
	cbnz	w11, LBB76_1
LBB76_3:                                ; %B11
	ldr	x8, [x24, #208]
	mov	w10, #18                        ; =0x12
LBB76_4:                                ; %B33
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB76_5 Depth 2
	ldr	x12, [x8, #8]
	ldr	w11, [x12, #12]
	and	w11, w9, w11
	mvn	w11, w11
	ldr	w11, [x12, w11, sxtw #2]
	cbz	w11, LBB76_7
LBB76_5:                                ; %B22
                                        ;   Parent Loop BB76_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w9
	b.eq	LBB76_9
; %bb.6:                                ; %B24
                                        ;   in Loop: Header=BB76_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB76_5
LBB76_7:                                ; %B27
                                        ;   in Loop: Header=BB76_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	LBB76_13
; %bb.8:                                ; %B30
                                        ;   in Loop: Header=BB76_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB76_4
	b	LBB76_11
LBB76_9:                                ; %B12
	lsr	w9, w13, #26
	tst	w9, #0x30
	b.ne	LBB76_13
LBB76_10:                               ; %B7.sink.split
	ldr	x8, [x8, #16]
	sub	w9, w11, #1
	ldr	x10, [x8, w9, sxtw #3]
LBB76_11:                               ; %B7
	cmp	x10, #34
	b.eq	LBB76_15
; %bb.12:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x10
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB76_13:                               ; %B17
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #64]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB76_16
; %bb.14:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB76_15:                               ; %B3
	b	_ThrowReferenceErrorUninitialized_asm_h
LBB76_16:                               ; %B18
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_var_0_asm_h        ; -- Begin function get_var_0_asm_h
	.globl	_get_var_0_asm_h
	.p2align	2
_get_var_0_asm_h:                       ; @get_var_0_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x24, #216]
	ldr	w9, [x19]
	ldr	x11, [x8, #8]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, LBB77_3
LBB77_1:                                ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #44]
	cmp	w13, w9
	b.eq	LBB77_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB77_1 Depth=1
	ldur	w10, [x12, #40]
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB77_1
LBB77_3:                                ; %B11
	ldr	x8, [x24, #208]
LBB77_4:                                ; %B32
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB77_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, LBB77_7
LBB77_5:                                ; %B21
                                        ;   Parent Loop BB77_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w9
	b.eq	LBB77_9
; %bb.6:                                ; %B23
                                        ;   in Loop: Header=BB77_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB77_5
LBB77_7:                                ; %B26
                                        ;   in Loop: Header=BB77_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB77_12
; %bb.8:                                ; %B29
                                        ;   in Loop: Header=BB77_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB77_4
	b	LBB77_12
LBB77_9:                                ; %B12
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	LBB77_12
LBB77_10:                               ; %B7
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	LBB77_14
; %bb.11:                               ; %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB77_12:                               ; %B16
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	str	x20, [x23, #64]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB77_15
; %bb.13:                               ; %B18
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB77_14:                               ; %B3
	b	_ThrowReferenceErrorUninitialized_asm_h
LBB77_15:                               ; %B17
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
	str	x20, [x23, #64]
	mov	x2, x22
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB78_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB78_2:                                ; %B2
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
	str	x20, [x23, #64]
	mov	x2, x22
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB79_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB79_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_put_var_strict_0_asm_h ; -- Begin function put_var_strict_0_asm_h
	.globl	_put_var_strict_0_asm_h
	.p2align	2
_put_var_strict_0_asm_h:                ; @put_var_strict_0_asm_h
; %bb.0:                                ; %B5
	ldp	x22, x21, [x20, #-16]
	cmp	x22, #7
	b.ne	LBB80_3
; %bb.1:                                ; %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          ; =0x2
	str	x20, [x23, #64]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB80_4
; %bb.2:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB80_3:                                ; %B6
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x23, #64]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB80_4:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_ref_value_0_asm_h  ; -- Begin function get_ref_value_0_asm_h
	.globl	_get_ref_value_0_asm_h
	.p2align	2
_get_ref_value_0_asm_h:                 ; @get_ref_value_0_asm_h
; %bb.0:                                ; %B8
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	cmp	x22, #18
	b.eq	LBB81_3
; %bb.1:                                ; %B1
	mov	x1, x22
	mov	x2, x21
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB81_5
; %bb.2:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB81_3:                                ; %B5
	mov	x1, x21
	bl	_js_value_to_atom_gc
	cbz	w0, LBB81_5
; %bb.4:                                ; %B7
	mov	w1, w0
	mov	x0, x24
	str	x20, [x23, #64]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB81_5:                                ; %B6
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
	b.eq	LBB82_3
LBB82_1:                                ; %B1
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x20, [x23, #64]
	bl	_JS_SetPropertyValue_GC
	tbnz	w0, #31, LBB82_7
; %bb.2:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB82_3:                                ; %B8
	ldr	w8, [x23, #60]
	tbnz	w8, #0, LBB82_5
; %bb.4:                                ; %B9
	ldr	x1, [x24, #208]
	b	LBB82_1
LBB82_5:                                ; %B5
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #64]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB82_7
; %bb.6:                                ; %B7
	mov	w1, w0
	mov	x0, x24
	str	x20, [x23, #64]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB82_7:                                ; %B2
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
	str	x20, [x23, #64]
	bl	_JS_DefineGlobalVar_GC
	tbnz	w0, #31, LBB83_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB83_2:                                ; %B2
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
	str	x20, [x23, #64]
	bl	_JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, LBB84_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB84_2:                                ; %B2
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
	str	x20, [x23, #64]
	mov	x2, x22
	bl	_JS_DefineGlobalFunction_GC
	tbnz	w0, #31, LBB85_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	sub	x20, x20, #8
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB85_2:                                ; %B2
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
	b.ne	LBB86_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB86_2:                                ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB86_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, LBB86_5
LBB86_3:                                ; %B1
                                        ;   Parent Loop BB86_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w2
	b.eq	LBB86_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB86_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB86_3
LBB86_5:                                ; %B14
                                        ;   in Loop: Header=BB86_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB86_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB86_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB86_2
	b	LBB86_9
LBB86_7:                                ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB86_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB86_9:                                ; %B6
	ldrb	w9, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB86_10:                               ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #64]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB86_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB86_12:                               ; %B22
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
	b.ne	LBB87_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB87_2:                                ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB87_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, LBB87_5
LBB87_3:                                ; %B1
                                        ;   Parent Loop BB87_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w2
	b.eq	LBB87_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB87_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB87_3
LBB87_5:                                ; %B14
                                        ;   in Loop: Header=BB87_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB87_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB87_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB87_2
	b	LBB87_9
LBB87_7:                                ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB87_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB87_9:                                ; %B6
	ldrb	w9, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB87_10:                               ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #64]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB87_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB87_12:                               ; %B22
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_put_field_0_asm_h      ; -- Begin function put_field_0_asm_h
	.globl	_put_field_0_asm_h
	.p2align	2
_put_field_0_asm_h:                     ; @put_field_0_asm_h
; %bb.0:                                ; %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	ldr	w2, [x19]
	tst	x22, x8
	b.ne	LBB88_17
; %bb.1:                                ; %B45
	ldr	x9, [x22, #8]
	ldr	w8, [x9, #12]
	and	w8, w2, w8
	mvn	w8, w8
	ldr	w8, [x9, w8, sxtw #2]
	cbz	w8, LBB88_4
LBB88_2:                                ; %B1
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10, #40]
	cmp	w11, w2
	b.eq	LBB88_13
; %bb.3:                                ; %B12
                                        ;   in Loop: Header=BB88_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB88_2
LBB88_4:                                ; %B17.preheader
	mov	x8, x22
LBB88_5:                                ; %B17
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB88_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x9, w10, sxtw #2]
	cbz	w10, LBB88_8
LBB88_6:                                ; %B18
                                        ;   Parent Loop BB88_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldr	w11, [x10, #44]
	cmp	w11, w2
	b.eq	LBB88_17
; %bb.7:                                ; %B20
                                        ;   in Loop: Header=BB88_6 Depth=2
	ldur	w10, [x10, #40]
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB88_6
LBB88_8:                                ; %B30
                                        ;   in Loop: Header=BB88_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB88_17
; %bb.9:                                ; %B24
                                        ;   in Loop: Header=BB88_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB88_5
; %bb.10:                               ; %B27
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	LBB88_17
; %bb.11:                               ; %B34
	mov	x0, x24
	mov	x1, x22
	mov	w3, #7                          ; =0x7
	str	x20, [x23, #64]
	bl	_add_property_gc
	cbz	x0, LBB88_19
; %bb.12:                               ; %B38
	str	x21, [x0]
	b	LBB88_15
LBB88_13:                               ; %B3
	mov	w9, #58                         ; =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	LBB88_17
; %bb.14:                               ; %B7
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
LBB88_15:                               ; %B38
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB88_20
LBB88_16:                               ; %B37
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB88_17:                               ; %B41
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x20, [x23, #64]
	bl	_JS_SetPropertyInternalImpl_GC
	tbz	w0, #31, LBB88_16
; %bb.18:                               ; %B42
	b	_exception_asm_h
LBB88_19:                               ; %B35
	sub	x20, x20, #16
	b	_exception_asm_h
LBB88_20:                               ; %B40
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_get_private_field_0_asm_h ; -- Begin function get_private_field_0_asm_h
	.globl	_get_private_field_0_asm_h
	.p2align	2
_get_private_field_0_asm_h:             ; @get_private_field_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	mov	x2, x21
	bl	_JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	LBB89_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB89_2:                                ; %B2
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
	str	x20, [x23, #64]
	mov	x2, x21
	mov	x3, x22
	bl	_JS_SetPrivateField_GC
	tbnz	w0, #31, LBB90_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB90_2:                                ; %B2
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
	str	x20, [x23, #64]
	mov	x2, x22
	mov	x3, x21
	bl	_JS_DefinePrivateField_GC
	tbnz	w0, #31, LBB91_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB91_2:                                ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_array_el_0_asm_h   ; -- Begin function get_array_el_0_asm_h
	.globl	_get_array_el_0_asm_h
	.p2align	2
_get_array_el_0_asm_h:                  ; @get_array_el_0_asm_h
; %bb.0:                                ; %B33
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB92_15
; %bb.1:                                ; %B33
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x8, x9
	b.ne	LBB92_15
; %bb.2:                                ; %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	LBB92_15
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB92_5
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB92_5:                                ; %B7
	tbnz	w21, #31, LBB92_15
; %bb.6:                                ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
	orr	w12, w21, #0x80000000
LBB92_7:                                ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB92_8 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	and	w11, w12, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, LBB92_10
LBB92_8:                                ; %B10
                                        ;   Parent Loop BB92_7 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x10, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w12
	b.eq	LBB92_12
; %bb.9:                                ; %B17
                                        ;   in Loop: Header=BB92_8 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB92_8
LBB92_10:                               ; %B24
                                        ;   in Loop: Header=BB92_7 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB92_15
; %bb.11:                               ; %B21
                                        ;   in Loop: Header=BB92_7 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB92_7
	b	LBB92_14
LBB92_12:                               ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB92_15
; %bb.13:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB92_14:                               ; %B14
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB92_15:                               ; %B30
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #64]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB92_17
; %bb.16:                               ; %B32
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB92_17:                               ; %B31
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_array_el2_0_asm_h  ; -- Begin function get_array_el2_0_asm_h
	.globl	_get_array_el2_0_asm_h
	.p2align	2
_get_array_el2_0_asm_h:                 ; @get_array_el2_0_asm_h
; %bb.0:                                ; %B33
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB93_15
; %bb.1:                                ; %B33
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x8, x9
	b.ne	LBB93_15
; %bb.2:                                ; %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	LBB93_15
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB93_5
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #16
	add	w8, w8, #486
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB93_5:                                ; %B7
	tbnz	w21, #31, LBB93_15
; %bb.6:                                ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
	orr	w12, w21, #0x80000000
LBB93_7:                                ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB93_8 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	and	w11, w12, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, LBB93_10
LBB93_8:                                ; %B10
                                        ;   Parent Loop BB93_7 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x10, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w12
	b.eq	LBB93_12
; %bb.9:                                ; %B17
                                        ;   in Loop: Header=BB93_8 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB93_8
LBB93_10:                               ; %B24
                                        ;   in Loop: Header=BB93_7 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB93_15
; %bb.11:                               ; %B21
                                        ;   in Loop: Header=BB93_7 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB93_7
	b	LBB93_14
LBB93_12:                               ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB93_15
; %bb.13:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB93_14:                               ; %B14
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB93_15:                               ; %B30
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #64]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB93_17
; %bb.16:                               ; %B32
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB93_17:                               ; %B31
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_put_array_el_0_asm_h   ; -- Begin function put_array_el_0_asm_h
	.globl	_put_array_el_0_asm_h
	.p2align	2
_put_array_el_0_asm_h:                  ; @put_array_el_0_asm_h
; %bb.0:                                ; %B63
	ldp	x1, x22, [x20, #-24]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	ldur	x21, [x20, #-8]
	tst	x1, x8
	b.ne	LBB94_16
; %bb.1:                                ; %B57
	ldrsh	w8, [x1, #6]
	cmp	w8, #2
	b.ne	LBB94_6
; %bb.2:                                ; %B1
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB94_16
; %bb.3:                                ; %B50
	ldr	w8, [x1, #48]
	cmp	w22, w8
	b.hs	LBB94_7
; %bb.4:                                ; %B3
	ldr	x8, [x1, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB94_23
LBB94_5:                                ; %B56
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB94_6:                                ; %B60
	cmp	w8, #30
	ccmp	w8, #20, #4, lt
	mov	w8, #32768                      ; =0x8000
	csel	w4, wzr, w8, gt
	b	LBB94_17
LBB94_7:                                ; %B8
	b.ne	LBB94_16
; %bb.8:                                ; %B46
	ldr	w9, [x1, #4]
	mov	w4, #32768                      ; =0x8000
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	b.ne	LBB94_17
; %bb.9:                                ; %B46
	ubfx	w9, w9, #8, #1
	cbz	w9, LBB94_17
; %bb.10:                               ; %B47
	ldr	x9, [x1, #8]
LBB94_11:                               ; %B15
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x10, [x9, #32]
	cbz	x10, LBB94_19
; %bb.12:                               ; %B10
                                        ;   in Loop: Header=BB94_11 Depth=1
	ldrh	w11, [x10, #6]
	ldr	x9, [x10, #8]
	cmp	w11, #2
	b.ne	LBB94_14
; %bb.13:                               ; %B12
                                        ;   in Loop: Header=BB94_11 Depth=1
	ldr	w10, [x10, #4]
	ubfx	w10, w10, #11, #1
	cmp	w10, #1
	b.eq	LBB94_11
	b	LBB94_16
LBB94_14:                               ; %B10
                                        ;   in Loop: Header=BB94_11 Depth=1
	cmp	w11, #1
	b.ne	LBB94_16
; %bb.15:                               ; %B42
                                        ;   in Loop: Header=BB94_11 Depth=1
	ldrb	w10, [x9, #6]
	cbz	w10, LBB94_11
LBB94_16:
	mov	w4, #32768                      ; =0x8000
LBB94_17:                               ; %B54
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	str	x20, [x23, #64]
	bl	_JS_SetPropertyValue_GC
	tbz	w0, #31, LBB94_5
; %bb.18:                               ; %B55
	b	_exception_asm_h
LBB94_19:                               ; %B33
	ldr	x9, [x1, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	LBB94_21
; %bb.20:                               ; %B33
	cmp	w9, w10
	b.hi	LBB94_24
LBB94_21:                               ; %B30
	ldr	w10, [x1, #32]
	cmp	w9, w10
	b.hi	LBB94_24
; %bb.22:                               ; %B26
	ldr	x10, [x1, #40]
	str	w9, [x1, #48]
	str	x21, [x10, w8, sxtw #3]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB94_5
LBB94_23:                               ; %B29
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB94_24:                               ; %B21
	mov	x0, x24
	mov	x2, x21
	mov	w3, #32768                      ; =0x8000
	str	x20, [x23, #64]
	bl	_add_fast_array_element_gc
	tbz	w0, #31, LBB94_5
; %bb.25:                               ; %B22
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_get_super_value_0_asm_h ; -- Begin function get_super_value_0_asm_h
	.globl	_get_super_value_0_asm_h
	.p2align	2
_get_super_value_0_asm_h:               ; @get_super_value_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x21
	bl	_js_value_to_atom_gc
	cbz	w0, LBB95_3
; %bb.1:                                ; %B5
	ldur	x3, [x20, #-24]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	str	x20, [x23, #64]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB95_3
; %bb.2:                                ; %B7
	stur	x0, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB95_3:                                ; %B6
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
	b.eq	LBB96_3
; %bb.1:                                ; %B10
	mov	x0, x24
	str	x20, [x23, #64]
	bl	_JS_ThrowTypeErrorNotAnObject
LBB96_2:                                ; %B6
	add	sp, sp, #16
	b	_exception_asm_h
LBB96_3:                                ; %B1
	ldur	x1, [x20, #-16]
	mov	x0, x24
	str	x9, [sp, #8]                    ; 8-byte Folded Spill
	str	x20, [x23, #64]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB96_2
; %bb.4:                                ; %B5
	ldur	x3, [x20, #-8]
	ldur	x4, [x20, #-32]
	mov	w2, w0
	ldr	x1, [sp, #8]                    ; 8-byte Folded Reload
	mov	x0, x24
	mov	w5, #32768                      ; =0x8000
	str	x20, [x23, #64]
	bl	_JS_SetPropertyGeneric_GC
	tbnz	w0, #31, LBB96_2
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
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldr	w2, [x19]
	mov	w4, #16391                      ; =0x4007
	str	x20, [x23, #64]
	mov	x1, x22
	mov	x3, x21
	bl	_JS_DefinePropertyValue_GC
	tbnz	w0, #31, LBB97_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB97_2:                                ; %B2
	b	_exception_asm_h
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
	str	x20, [x23, #64]
	mov	x1, x22
	bl	_JS_DefineObjectName
	tbnz	w0, #31, LBB98_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB98_2:                                ; %B2
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
	str	x20, [x23, #64]
	mov	x1, x21
	mov	x2, x22
	bl	_JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, LBB99_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB99_2:                                ; %B2
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
	b.eq	LBB100_3
; %bb.1:                                ; %B6
	cmp	x21, #2
	b.eq	LBB100_3
LBB100_2:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB100_3:                               ; %B1
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #64]
	bl	_JS_SetPrototypeInternal_GC
	tbz	w0, #31, LBB100_2
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
	str	x20, [x23, #64]
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
	str	x20, [x23, #64]
	mov	x2, x22
	mov	x3, x21
	bl	_JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, LBB102_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB102_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_append_0_asm_h         ; -- Begin function append_0_asm_h
	.globl	_append_0_asm_h
	.p2align	2
_append_0_asm_h:                        ; @append_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #64]
	bl	_js_append_enumerate_gc
	tbnz	w0, #31, LBB103_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB103_2:                               ; %B2
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
	str	x20, [x23, #64]
	bl	_prim_js_copy_data_properties_gc
	tbnz	w0, #31, LBB104_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB104_2:                               ; %B2
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
	b.eq	LBB105_3
; %bb.1:                                ; %B15
	cmp	w8, #1
	b.ne	LBB105_4
; %bb.2:                                ; %B13
	mov	w8, #18                         ; =0x12
	mov	w11, #2048                      ; =0x800
	stp	x12, x8, [sp, #16]              ; 16-byte Folded Spill
	b	LBB105_5
LBB105_3:
	mov	w8, #18                         ; =0x12
	str	x12, [sp, #40]                  ; 8-byte Folded Spill
	mov	w11, #8706                      ; =0x2202
	str	x8, [sp, #24]                   ; 8-byte Folded Spill
	mov	w8, #18                         ; =0x12
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	b	LBB105_6
LBB105_4:                               ; %B14
	mov	w11, #4096                      ; =0x1000
	mov	w8, #18                         ; =0x12
	stp	x8, x12, [sp, #16]              ; 16-byte Folded Spill
LBB105_5:                               ; %B10
	mov	w8, #18                         ; =0x12
	str	x8, [sp, #40]                   ; 8-byte Folded Spill
LBB105_6:                               ; %B10
	ldur	x1, [x20, #-8]
	orr	w3, w10, w11
	mov	x0, x24
	mov	w2, w19
	mov	x4, x9
	str	x20, [x23, #64]
	str	w11, [sp, #36]                  ; 4-byte Folded Spill
	str	x20, [sp, #56]                  ; 8-byte Folded Spill
	mov	w20, w19
	mov	x19, x9
	str	w10, [sp, #12]                  ; 4-byte Folded Spill
	bl	_js_method_set_properties_gc
	tbnz	w0, #31, LBB105_9
; %bb.7:                                ; %B5
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	ldr	w9, [sp, #12]                   ; 4-byte Folded Reload
	mov	x0, x24
	ldp	x4, x5, [sp, #16]               ; 16-byte Folded Reload
	mov	x1, x19
	str	x8, [x23, #64]
	ldr	w8, [sp, #36]                   ; 4-byte Folded Reload
	mov	w2, w20
	ldr	x3, [sp, #40]                   ; 8-byte Folded Reload
	orr	w6, w9, w8
	bl	_JS_DefineProperty_GC
	tbnz	w0, #31, LBB105_9
; %bb.8:                                ; %B7
	ldr	x9, [sp, #48]                   ; 8-byte Folded Reload
	ldrb	w8, [x9, #5]
	add	x19, x9, #6
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #64
	br	x1
LBB105_9:                               ; %B2
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
	str	x20, [x23, #64]
	bl	_js_value_to_atom_gc
	mov	w11, w0
	cbz	w11, LBB106_11
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
	b.eq	LBB106_4
; %bb.2:                                ; %B11
	cmp	w8, #1
	b.ne	LBB106_5
; %bb.3:                                ; %B19
	mov	w8, #18                         ; =0x12
	mov	w13, #2048                      ; =0x800
	stp	x10, x8, [sp, #16]              ; 16-byte Folded Spill
	b	LBB106_6
LBB106_4:
	mov	w8, #18                         ; =0x12
	str	x10, [sp, #40]                  ; 8-byte Folded Spill
	mov	w13, #8706                      ; =0x2202
	str	x8, [sp, #24]                   ; 8-byte Folded Spill
	mov	w8, #18                         ; =0x12
	str	x8, [sp, #16]                   ; 8-byte Folded Spill
	b	LBB106_7
LBB106_5:                               ; %B20
	mov	w13, #4096                      ; =0x1000
	mov	w8, #18                         ; =0x12
	stp	x8, x10, [sp, #16]              ; 16-byte Folded Spill
LBB106_6:                               ; %B16
	mov	w8, #18                         ; =0x12
	str	x8, [sp, #40]                   ; 8-byte Folded Spill
LBB106_7:                               ; %B16
	ldur	x1, [x20, #-8]
	orr	w3, w9, w13
	mov	x0, x24
	mov	w2, w11
	mov	x4, x12
	str	x20, [x23, #64]
	str	w13, [sp, #36]                  ; 4-byte Folded Spill
	mov	x19, x12
	str	x20, [sp, #56]                  ; 8-byte Folded Spill
	mov	w20, w11
	str	w9, [sp, #12]                   ; 4-byte Folded Spill
	bl	_js_method_set_properties_gc
	tbnz	w0, #31, LBB106_10
; %bb.8:                                ; %B5
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	ldr	w9, [sp, #12]                   ; 4-byte Folded Reload
	mov	x0, x24
	ldp	x4, x5, [sp, #16]               ; 16-byte Folded Reload
	mov	x1, x19
	str	x8, [x23, #64]
	ldr	w8, [sp, #36]                   ; 4-byte Folded Reload
	mov	w2, w20
	ldr	x3, [sp, #40]                   ; 8-byte Folded Reload
	orr	w6, w9, w8
	bl	_JS_DefineProperty_GC
	tbnz	w0, #31, LBB106_10
; %bb.9:                                ; %B7
	ldr	x9, [sp, #48]                   ; 8-byte Folded Reload
	ldrb	w8, [x9, #1]
	add	x19, x9, #2
	ldr	x1, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   ; 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #64
	br	x1
LBB106_10:                              ; %B2
	ldp	x19, x20, [sp, #48]             ; 16-byte Folded Reload
LBB106_11:                              ; %B9
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
	str	x20, [x23, #64]
	bl	_js_op_define_class
	tbnz	w0, #31, LBB107_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB107_2:                               ; %B2
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	b.eq	LBB118_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB118_2:                               ; %B3
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
	b.eq	LBB119_2
; %bb.1:                                ; %B4
	str	x22, [x27, w8, uxtw #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB119_2:                               ; %B3
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
	b.ne	LBB120_2
; %bb.1:                                ; %B4
	str	x22, [x27, w8, uxtw #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB120_2:                               ; %B3
	b	_ThrowThisReferenceError_asm_h
                                        ; -- End function
	.private_extern	_get_var_ref_check_0_asm_h ; -- Begin function get_var_ref_check_0_asm_h
	.globl	_get_var_ref_check_0_asm_h
	.p2align	2
_get_var_ref_check_0_asm_h:             ; @get_var_ref_check_0_asm_h
; %bb.0:                                ; %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	LBB121_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB121_2:                               ; %B3
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
	ldr	x8, [x8, #32]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	LBB122_2
; %bb.1:                                ; %B4
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB122_2:                               ; %B3
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
	ldr	x8, [x8, #32]
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	LBB123_2
; %bb.1:                                ; %B4
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB123_2:                               ; %B3
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
	b.le	LBB125_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB125_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB125_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB125_6
	b	LBB125_7
LBB125_4:                               ; %B23
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.eq	LBB125_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB125_7
LBB125_6:                               ; %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB125_7:                               ; %B9
	mov	x9, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x9
	b.hs	LBB125_13
; %bb.8:                                ; %B11
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.lo	LBB125_10
LBB125_9:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB125_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB125_13
; %bb.11:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB125_6
	b.vs	LBB125_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB125_9
	b	LBB125_6
LBB125_13:                              ; %B15
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
	b.le	LBB126_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB126_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB126_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB126_6
	b	LBB126_7
LBB126_4:                               ; %B23
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.eq	LBB126_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB126_7
LBB126_6:                               ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB126_7:                               ; %B9
	mov	x9, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x9
	b.hs	LBB126_13
; %bb.8:                                ; %B11
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.lo	LBB126_10
LBB126_9:                               ; %B19
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB126_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB126_13
; %bb.11:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB126_6
	b.vs	LBB126_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB126_9
	b	LBB126_6
LBB126_13:                              ; %B15
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
	b.ne	LBB130_3
; %bb.1:                                ; %B1
	ldr	x8, [x23, #8]
	ldr	x8, [x8, #32]
	ldr	w9, [x8, #16]
	cmp	w22, w9
	b.ge	LBB130_3
; %bb.2:                                ; %B5
	ldr	x8, [x8, #8]
	sub	x20, x20, #8
	add	x19, x8, w22, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB130_3:                               ; %B3
Lloh14:
	adrp	x1, l___unnamed_8@PAGE
Lloh15:
	add	x1, x1, l___unnamed_8@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #64]
	bl	_LEPUS_ThrowInternalError
	b	_exception_asm_h
	.loh AdrpAdd	Lloh14, Lloh15
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
	b.ne	LBB131_2
; %bb.1:                                ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB131_2:                               ; %B1
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #64]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB131_4
; %bb.3:                                ; %B3
	mov	x22, x0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB131_4:                               ; %B2
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
	b.eq	LBB132_4
; %bb.1:                                ; %B15
	mov	x9, #1                          ; =0x1
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB132_4
; %bb.2:                                ; %B15
	cmp	x8, x9
	b.eq	LBB132_4
; %bb.3:                                ; %B15
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB132_5
LBB132_4:                               ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB132_5:                               ; %B12
	mov	x0, x24
	mov	x1, x22
	str	x20, [x23, #64]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB132_7
; %bb.6:                                ; %B14
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB132_7:                               ; %B13
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
	b.ne	LBB133_3
; %bb.1:                                ; %B19
Lloh16:
	adrp	x1, l___unnamed_9@PAGE
Lloh17:
	add	x1, x1, l___unnamed_9@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #64]
	bl	_LEPUS_ThrowTypeError
LBB133_2:                               ; %B16
	b	_exception_asm_h
LBB133_3:                               ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	LBB133_7
; %bb.4:                                ; %B2
	mov	x9, #1                          ; =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB133_7
; %bb.5:                                ; %B2
	cmp	x8, x9
	b.eq	LBB133_7
; %bb.6:                                ; %B2
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB133_8
LBB133_7:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB133_8:                               ; %B15
	mov	x0, x24
	mov	x1, x21
	str	x20, [x23, #64]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB133_2
; %bb.9:                                ; %B17
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh16, Lloh17
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
	str	x20, [x23, #64]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB134_4
; %bb.1:                                ; %B4
	cbz	w0, LBB134_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB134_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB134_4:                               ; %B2
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
	str	x20, [x23, #64]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB135_4
; %bb.1:                                ; %B4
	cbz	w0, LBB135_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	sub	x20, x20, #16
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB135_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB135_4:                               ; %B2
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
	str	x20, [x23, #64]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB136_4
; %bb.1:                                ; %B4
	cbz	w0, LBB136_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB136_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB136_4:                               ; %B2
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
	str	x20, [x23, #64]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB137_4
; %bb.1:                                ; %B4
	cbz	w0, LBB137_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB137_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB137_4:                               ; %B2
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
	str	x20, [x23, #64]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB138_4
; %bb.1:                                ; %B4
	cbz	w0, LBB138_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB138_3:                               ; %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB138_4:                               ; %B2
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
	str	x20, [x23, #64]
	bl	_prim_js_with_op_gc
	tbnz	w0, #31, LBB139_4
; %bb.1:                                ; %B4
	cbz	w0, LBB139_3
; %bb.2:                                ; %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
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
	.private_extern	_make_loc_ref_0_asm_h   ; -- Begin function make_loc_ref_0_asm_h
	.globl	_make_loc_ref_0_asm_h
	.p2align	2
_make_loc_ref_0_asm_h:                  ; @make_loc_ref_0_asm_h
; %bb.0:                                ; %B16
	sub	sp, sp, #16
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x20, [x23, #64]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	LBB140_6
; %bb.1:                                ; %B1
	mov	w8, #18                         ; =0x12
	mov	x1, x23
	mov	w3, wzr
	stp	x0, x8, [x20], #16
	mov	x0, x24
	ldrh	w2, [x19, #4]
	str	x20, [x23, #64]
	bl	_get_var_ref
	mov	x8, x0
	cbz	x8, LBB140_6
; %bb.2:                                ; %B6
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #34                         ; =0x22
	str	x20, [x23, #64]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	bl	_add_property_gc
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	cbz	x0, LBB140_6
; %bb.3:                                ; %B9
	str	x9, [x0]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB140_7
LBB140_4:                               ; %B13
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #64]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB140_6
; %bb.5:                                ; %B15
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB140_6:                               ; %B14
	add	sp, sp, #16
	b	_exception_asm_h
LBB140_7:                               ; %B12
	mov	x0, x9
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB140_4
                                        ; -- End function
	.private_extern	_make_arg_ref_0_asm_h   ; -- Begin function make_arg_ref_0_asm_h
	.globl	_make_arg_ref_0_asm_h
	.p2align	2
_make_arg_ref_0_asm_h:                  ; @make_arg_ref_0_asm_h
; %bb.0:                                ; %B16
	sub	sp, sp, #16
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x20, [x23, #64]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	LBB141_6
; %bb.1:                                ; %B1
	mov	w8, #18                         ; =0x12
	mov	x1, x23
	mov	w3, #1                          ; =0x1
	stp	x0, x8, [x20], #16
	mov	x0, x24
	ldrh	w2, [x19, #4]
	str	x20, [x23, #64]
	bl	_get_var_ref
	mov	x8, x0
	cbz	x8, LBB141_6
; %bb.2:                                ; %B6
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #34                         ; =0x22
	str	x20, [x23, #64]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	bl	_add_property_gc
	ldr	x9, [sp, #8]                    ; 8-byte Folded Reload
	cbz	x0, LBB141_6
; %bb.3:                                ; %B9
	str	x9, [x0]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB141_7
LBB141_4:                               ; %B13
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #64]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB141_6
; %bb.5:                                ; %B15
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB141_6:                               ; %B14
	add	sp, sp, #16
	b	_exception_asm_h
LBB141_7:                               ; %B12
	mov	x0, x9
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB141_4
                                        ; -- End function
	.private_extern	_make_var_ref_ref_0_asm_h ; -- Begin function make_var_ref_ref_0_asm_h
	.globl	_make_var_ref_ref_0_asm_h
	.p2align	2
_make_var_ref_ref_0_asm_h:              ; @make_var_ref_ref_0_asm_h
; %bb.0:                                ; %B12
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x20, [x23, #64]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.eq	LBB142_5
; %bb.1:                                ; %B1
	mov	x1, x0
	mov	w8, #18                         ; =0x12
	mov	x0, x24
	stp	x1, x8, [x20], #16
	mov	w3, #34                         ; =0x22
	ldr	w2, [x19]
	str	x20, [x23, #64]
	bl	_add_property_gc
	cbz	x0, LBB142_5
; %bb.2:                                ; %B4
	ldrh	w8, [x19, #4]
	ldr	x8, [x26, x8, lsl #3]
	str	x8, [x0]
	ldrb	w9, [x24, #384]
	cbnz	w9, LBB142_6
LBB142_3:                               ; %B9
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #64]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB142_5
; %bb.4:                                ; %B11
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB142_5:                               ; %B10
	b	_exception_asm_h
LBB142_6:                               ; %B7
	mov	x0, x8
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	b	LBB142_3
                                        ; -- End function
	.private_extern	_make_var_ref_0_asm_h   ; -- Begin function make_var_ref_0_asm_h
	.globl	_make_var_ref_0_asm_h
	.p2align	2
_make_var_ref_0_asm_h:                  ; @make_var_ref_0_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x20
	str	x20, [x23, #64]
	bl	_JS_GetGlobalVarRef_GC
	tbnz	w0, #31, LBB143_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB143_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_for_in_start_0_asm_h   ; -- Begin function for_in_start_0_asm_h
	.globl	_for_in_start_0_asm_h
	.p2align	2
_for_in_start_0_asm_h:                  ; @for_in_start_0_asm_h
; %bb.0:                                ; %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	bl	_prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	LBB144_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB144_2:                               ; %B2
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
	str	x20, [x23, #64]
	bl	_js_for_of_start_gc
	tbnz	w0, #31, LBB145_2
; %bb.1:                                ; %B3
	mov	w8, #66                         ; =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB145_2:                               ; %B2
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
	str	x20, [x23, #64]
	bl	_js_for_of_start_gc
	tbnz	w0, #31, LBB146_2
; %bb.1:                                ; %B3
	mov	w8, #66                         ; =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB146_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_for_in_next_0_asm_h    ; -- Begin function for_in_next_0_asm_h
	.globl	_for_in_next_0_asm_h
	.p2align	2
_for_in_next_0_asm_h:                   ; @for_in_next_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #64]
	bl	_js_for_in_next_gc
	tbnz	w0, #31, LBB147_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB147_2:                               ; %B2
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
	str	x20, [x23, #64]
	sub	w2, w8, w9
	bl	_js_for_of_next_gc
	tbnz	w0, #31, LBB148_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB148_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_for_await_of_next_0_asm_h ; -- Begin function for_await_of_next_0_asm_h
	.globl	_for_await_of_next_0_asm_h
	.p2align	2
_for_await_of_next_0_asm_h:             ; @for_await_of_next_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #64]
	bl	_js_for_await_of_next_gc
	tbnz	w0, #31, LBB149_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB149_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_iterator_get_value_done_0_asm_h ; -- Begin function iterator_get_value_done_0_asm_h
	.globl	_iterator_get_value_done_0_asm_h
	.p2align	2
_iterator_get_value_done_0_asm_h:       ; @iterator_get_value_done_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #64]
	bl	_js_iterator_get_value_done_gc
	tbnz	w0, #31, LBB150_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB150_2:                               ; %B2
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
	b.eq	LBB151_2
; %bb.1:                                ; %B1
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x23, #64]
	bl	_JS_IteratorClose
	tbnz	w0, #31, LBB151_3
LBB151_2:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB151_3:                               ; %B2
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
	b	LBB152_2
LBB152_1:                               ; %B10
                                        ;   in Loop: Header=BB152_2 Depth=1
	sub	x20, x20, #8
LBB152_2:                               ; %B2
                                        ; =>This Inner Loop Header: Depth=1
	cmp	x20, x9
	b.le	LBB152_5
; %bb.3:                                ; %B4
                                        ;   in Loop: Header=BB152_2 Depth=1
	ldur	x11, [x20, #-8]
	tst	x11, #0xffff000000000000
	b.ne	LBB152_1
; %bb.4:                                ; %B4
                                        ;   in Loop: Header=BB152_2 Depth=1
	and	x11, x11, x10
	cmp	x11, #66
	b.ne	LBB152_1
LBB152_5:                               ; %B7
	add	x9, x9, #24
	cmp	x20, x9
	add	x20, x20, #8
	b.lt	LBB152_7
; %bb.6:                                ; %B9
	ldur	x9, [x20, #-16]
	ldur	q0, [x20, #-32]
	stur	x8, [x20, #-32]
	stur	x9, [x20, #-8]
	stur	q0, [x20, #-24]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB152_7:                               ; %B8
Lloh18:
	adrp	x1, l___unnamed_10@PAGE
Lloh19:
	add	x1, x1, l___unnamed_10@PAGEOFF
	mov	x0, x24
	str	x20, [x23, #64]
	bl	_LEPUS_ThrowInternalError
	b	_exception_asm_h
	.loh AdrpAdd	Lloh18, Lloh19
                                        ; -- End function
	.private_extern	_async_iterator_close_0_asm_h ; -- Begin function async_iterator_close_0_asm_h
	.globl	_async_iterator_close_0_asm_h
	.p2align	2
_async_iterator_close_0_asm_h:          ; @async_iterator_close_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x23, #64]
	bl	_prim_js_async_iterator_close_gc
	tbnz	w0, #31, LBB153_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB153_2:                               ; %B2
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
	str	x20, [x23, #64]
	bl	_JS_Call_GC
	cmp	x0, #130
	b.eq	LBB154_2
; %bb.1:                                ; %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB154_2:                               ; %B2
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
	str	x20, [x23, #64]
	bl	_prim_js_async_iterator_get_gc
	tbnz	w0, #31, LBB155_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB155_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_initial_yield_0_asm_h  ; -- Begin function initial_yield_0_asm_h
	.globl	_initial_yield_0_asm_h
	.p2align	2
_initial_yield_0_asm_h:                 ; @initial_yield_0_asm_h
; %bb.0:                                ; %B0
	str	x19, [x23, #48]
	mov	w0, #18                         ; =0x12
	str	x20, [x23, #64]
	b	_common_return_direct_asm_h
                                        ; -- End function
	.private_extern	_yield_0_asm_h          ; -- Begin function yield_0_asm_h
	.globl	_yield_0_asm_h
	.p2align	2
_yield_0_asm_h:                         ; @yield_0_asm_h
; %bb.0:                                ; %B0
	str	x19, [x23, #48]
	mov	x0, #-562949953421311           ; =0xfffe000000000001
	str	x20, [x23, #64]
	b	_common_return_direct_asm_h
                                        ; -- End function
	.private_extern	_yield_star_0_asm_h     ; -- Begin function yield_star_0_asm_h
	.globl	_yield_star_0_asm_h
	.p2align	2
_yield_star_0_asm_h:                    ; @yield_star_0_asm_h
; %bb.0:                                ; %B0
	mov	x0, #2                          ; =0x2
	str	x19, [x23, #48]
	str	x20, [x23, #64]
	movk	x0, #65534, lsl #48
	b	_common_return_direct_asm_h
                                        ; -- End function
	.private_extern	_async_yield_star_0_asm_h ; -- Begin function async_yield_star_0_asm_h
	.globl	_async_yield_star_0_asm_h
	.p2align	2
_async_yield_star_0_asm_h:              ; @async_yield_star_0_asm_h
; %bb.0:                                ; %B0
	mov	x0, #2                          ; =0x2
	str	x19, [x23, #48]
	str	x20, [x23, #64]
	movk	x0, #65534, lsl #48
	b	_common_return_direct_asm_h
                                        ; -- End function
	.private_extern	_await_0_asm_h          ; -- Begin function await_0_asm_h
	.globl	_await_0_asm_h
	.p2align	2
_await_0_asm_h:                         ; @await_0_asm_h
; %bb.0:                                ; %B0
	str	x19, [x23, #48]
	mov	x0, #-562949953421312           ; =0xfffe000000000000
	str	x20, [x23, #64]
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
	b.hi	LBB161_3
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB161_6
; %bb.2:                                ; %B13
	orr	w8, w22, #0x80000000
	mov	w9, #-2147483648                ; =0x80000000
	cmp	w8, w9
	b.ne	LBB161_5
LBB161_3:                               ; %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        ; =0x8c
	str	x20, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB161_8
; %bb.4:                                ; %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB161_5:                               ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB161_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB161_3
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
LBB161_8:                               ; %B17
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
	b.hi	LBB162_4
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB162_3
LBB162_2:                               ; %B7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB162_3:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.ne	LBB162_2
LBB162_4:                               ; %B10
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        ; =0x8d
	str	x20, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB162_6
; %bb.5:                                ; %B12
	mov	x22, x0
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB162_6:                               ; %B11
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
	b.hi	LBB163_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB163_4
; %bb.2:                                ; %B13
	subs	w8, w22, #1
	b.vs	LBB163_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB163_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB163_6
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
LBB163_6:                               ; %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        ; =0x8e
	str	x20, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB163_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB163_8:                               ; %B17
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
	b.hi	LBB164_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB164_4
; %bb.2:                                ; %B13
	adds	w8, w22, #1
	b.vs	LBB164_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB164_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB164_6
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
LBB164_6:                               ; %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        ; =0x8f
	str	x20, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB164_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB164_8:                               ; %B17
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
	b.hs	LBB165_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB165_4
; %bb.2:                                ; %B13
	subs	w8, w22, #1
	b.vs	LBB165_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB165_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB165_6
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
LBB165_6:                               ; %B5
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
	b.hs	LBB166_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB166_4
; %bb.2:                                ; %B13
	adds	w8, w22, #1
	b.vs	LBB166_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB166_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB166_6
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
LBB166_6:                               ; %B5
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
	b.hi	LBB167_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB167_4
; %bb.2:                                ; %B13
	subs	w9, w1, #1
	b.vs	LBB167_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB167_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB167_6
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
LBB167_6:                               ; %B16
	mov	x0, x24
	mov	w2, #142                        ; =0x8e
	str	x20, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB167_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB167_8:                               ; %B17
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
	b.hi	LBB168_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB168_4
; %bb.2:                                ; %B13
	adds	w9, w1, #1
	b.vs	LBB168_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB168_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB168_6
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
LBB168_6:                               ; %B16
	mov	x0, x24
	mov	w2, #143                        ; =0x8f
	str	x20, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB168_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB168_8:                               ; %B17
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_add_loc_0_asm_h        ; -- Begin function add_loc_0_asm_h
	.globl	_add_loc_0_asm_h
	.p2align	2
_add_loc_0_asm_h:                       ; @add_loc_0_asm_h
; %bb.0:                                ; %B45
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldur	x22, [x20, #-8]
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	ccmp	x22, x9, #2, ls
	b.hi	LBB169_14
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB169_5
; %bb.2:                                ; %B26
	cmp	x22, x9
	b.lo	LBB169_8
; %bb.3:                                ; %B36
	adds	w9, w1, w22
	b.vs	LBB169_14
; %bb.4:                                ; %B38
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB169_5:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB169_14
; %bb.6:                                ; %B11
	cmp	x22, x9
	b.lo	LBB169_12
; %bb.7:                                ; %B21
	scvtf	d0, w22
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	LBB169_11
LBB169_8:                               ; %B28
	tst	x22, #0xfffe000000000000
	b.eq	LBB169_14
; %bb.9:                                ; %B31
	scvtf	d0, w1
	add	x9, x22, x9
LBB169_10:                              ; %B31
	fmov	d1, x9
	fadd	d0, d0, d1
LBB169_11:                              ; %B31
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
LBB169_12:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB169_14
; %bb.13:                               ; %B16
	add	x10, x1, x9
	add	x9, x22, x9
	fmov	d0, x10
	b	LBB169_10
LBB169_14:                              ; %B7
	mov	x9, #2                          ; =0x2
	and	x8, x1, #0xffff000000000003
	and	x10, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	mov	x2, x22
	str	x20, [x23, #64]
	cmp	x8, x9
	mov	x0, x24
	ccmp	x10, x9, #0, eq
	b.eq	LBB169_16
; %bb.15:                               ; %B42
	bl	_prim_js_add_slow_gc
	b	LBB169_17
LBB169_16:                              ; %B39
	bl	_JS_ConcatString_GC
LBB169_17:                              ; %B42
	cmp	x0, #130
	b.eq	LBB169_19
; %bb.18:                               ; %B44
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB169_19:                              ; %B43
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
	b.ne	LBB170_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB170_2:                               ; %B4
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
	b.le	LBB171_4
; %bb.1:                                ; %B14
	cmp	x22, #6
	b.eq	LBB171_6
; %bb.2:                                ; %B14
	cmp	x22, #7
	b.eq	LBB171_8
; %bb.3:                                ; %B14
	cmp	x22, #18
	b.eq	LBB171_6
	b	LBB171_7
LBB171_4:                               ; %B14
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB171_6
; %bb.5:                                ; %B14
	cmp	x22, #2
	b.ne	LBB171_7
LBB171_6:                               ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB171_7:                               ; %B10
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB171_9
LBB171_8:                               ; %B12
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB171_9:                               ; %B13
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
	str	x20, [x23, #64]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB172_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB172_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_delete_0_asm_h         ; -- Begin function delete_0_asm_h
	.globl	_delete_0_asm_h
	.p2align	2
_delete_0_asm_h:                        ; @delete_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	mov	x2, x21
	bl	_prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	LBB173_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB173_2:                               ; %B2
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
	str	x20, [x23, #64]
	bl	_JS_DeleteProperty_GC
	tbnz	w0, #31, LBB174_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB174_2:                               ; %B2
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
	b.hi	LBB175_18
; %bb.1:                                ; %B47
	cmp	x21, x8
	b.hi	LBB175_18
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB175_8
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB175_11
; %bb.4:                                ; %B33
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	LBB175_18
; %bb.5:                                ; %B36
	cbnz	w8, LBB175_7
; %bb.6:                                ; %B36
	orr	w9, w22, w21
	tbnz	w9, #31, LBB175_15
LBB175_7:                               ; %B43
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB175_8:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB175_18
; %bb.9:                                ; %B7
	cmp	x21, x8
	b.lo	LBB175_16
; %bb.10:                               ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	LBB175_14
LBB175_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB175_18
; %bb.12:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB175_13:                              ; %B28
	fmov	d1, x8
	fmul	d0, d0, d1
LBB175_14:                              ; %B28
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
LBB175_15:                              ; %B40
	mov	x22, #-9222809086901354496      ; =0x8002000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB175_16:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB175_18
; %bb.17:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB175_13
LBB175_18:                              ; %B44
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        ; =0x9a
	str	x20, [x23, #64]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB175_20
; %bb.19:                               ; %B46
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB175_20:                              ; %B45
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
	b.hi	LBB176_14
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB176_14
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB176_5
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB176_8
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
LBB176_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB176_14
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB176_12
; %bb.7:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	LBB176_11
LBB176_8:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB176_14
; %bb.9:                                ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB176_10:                              ; %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
LBB176_11:                              ; %B28
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
LBB176_12:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB176_14
; %bb.13:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB176_10
LBB176_14:                              ; %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        ; =0x9b
	str	x20, [x23, #64]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB176_16
; %bb.15:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB176_16:                              ; %B42
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
	b.hi	LBB177_16
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB177_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB177_7
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB177_10
; %bb.4:                                ; %B33
	tbnz	w22, #31, LBB177_16
; %bb.5:                                ; %B33
	cmp	w21, #1
	b.lt	LBB177_16
; %bb.6:                                ; %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB177_7:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB177_16
; %bb.8:                                ; %B7
	cmp	x21, x8
	b.lo	LBB177_14
; %bb.9:                                ; %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	LBB177_13
LBB177_10:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB177_16
; %bb.11:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB177_12:                              ; %B28
	fmov	d1, x8
LBB177_13:                              ; %B28
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
LBB177_14:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB177_16
; %bb.15:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB177_12
LBB177_16:                              ; %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        ; =0x9c
	str	x20, [x23, #64]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB177_18
; %bb.17:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB177_18:                              ; %B37
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_add_0_asm_h            ; -- Begin function add_0_asm_h
	.globl	_add_0_asm_h
	.p2align	2
_add_0_asm_h:                           ; @add_0_asm_h
; %bb.0:                                ; %B45
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB178_15
; %bb.1:                                ; %B45
	cmp	x21, x8
	b.hi	LBB178_15
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB178_6
; %bb.3:                                ; %B26
	cmp	x21, x8
	b.lo	LBB178_9
; %bb.4:                                ; %B36
	adds	w8, w22, w21
	b.vs	LBB178_15
; %bb.5:                                ; %B38
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB178_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB178_15
; %bb.7:                                ; %B10
	cmp	x21, x8
	b.lo	LBB178_13
; %bb.8:                                ; %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	LBB178_12
LBB178_9:                               ; %B28
	tst	x21, #0xfffe000000000000
	b.eq	LBB178_15
; %bb.10:                               ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB178_11:                              ; %B31
	fmov	d1, x8
	fadd	d0, d0, d1
LBB178_12:                              ; %B31
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
LBB178_13:                              ; %B12
	tst	x21, #0xfffe000000000000
	b.eq	LBB178_15
; %bb.14:                               ; %B15
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB178_11
LBB178_15:                              ; %B6
	mov	x8, #2                          ; =0x2
	and	x9, x22, #0xffff000000000003
	str	x20, [x23, #64]
	movk	x8, #1, lsl #48
	cmp	x9, x8
	b.ne	LBB178_18
; %bb.16:                               ; %B6
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.ne	LBB178_18
; %bb.17:                               ; %B39
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	_JS_ConcatString_GC
	b	LBB178_19
LBB178_18:                              ; %B42
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	_prim_js_add_slow_gc
LBB178_19:                              ; %B42
	cmp	x0, #130
	b.eq	LBB178_21
; %bb.20:                               ; %B44
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB178_21:                              ; %B43
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
	b.hi	LBB179_15
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB179_15
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB179_6
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB179_9
; %bb.4:                                ; %B33
	subs	w8, w22, w21
	b.vs	LBB179_15
; %bb.5:                                ; %B35
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB179_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB179_15
; %bb.7:                                ; %B7
	cmp	x21, x8
	b.lo	LBB179_13
; %bb.8:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	LBB179_12
LBB179_9:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB179_15
; %bb.10:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB179_11:                              ; %B28
	fmov	d1, x8
	fsub	d0, d0, d1
LBB179_12:                              ; %B28
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
LBB179_13:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB179_15
; %bb.14:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB179_11
LBB179_15:                              ; %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        ; =0x9e
	str	x20, [x23, #64]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB179_17
; %bb.16:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB179_17:                              ; %B37
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
	str	x20, [x23, #64]
	mov	x1, x22
	mov	x2, x21
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB180_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB180_2:                               ; %B2
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
	b.hi	LBB181_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB181_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB181_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB181_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB181_5:                               ; %B16
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #16
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB181_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB181_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB181_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB181_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB181_5
LBB181_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        ; =0xa0
	str	x20, [x23, #64]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB181_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB181_12:                              ; %B26
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
	b.hi	LBB182_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB182_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB182_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB182_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB182_5:                               ; %B16
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #16
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB182_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB182_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB182_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB182_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB182_5
LBB182_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        ; =0xa1
	str	x20, [x23, #64]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB182_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB182_12:                              ; %B26
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
	b.hi	LBB183_11
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB183_11
; %bb.2:                                ; %B10
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB183_6
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB183_11
; %bb.4:                                ; %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, LBB183_10
LBB183_5:                               ; %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB183_6:                               ; %B12
	tst	x22, #0xfffe000000000000
	b.eq	LBB183_11
; %bb.7:                                ; %B12
	cmp	x21, x8
	b.lo	LBB183_11
; %bb.8:                                ; %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB183_11
; %bb.9:                                ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, LBB183_5
LBB183_10:                              ; %B6
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
LBB183_11:                              ; %B33
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x23, #64]
	bl	_prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	LBB183_13
; %bb.12:                               ; %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB183_13:                              ; %B34
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
	b.hi	LBB184_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB184_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB184_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB184_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, lt
	br	x1
LBB184_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB184_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB184_10
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
LBB184_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB184_12
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
LBB184_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB184_12
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
LBB184_12:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        ; =0xa3
	str	x20, [x23, #64]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB184_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB184_14:                              ; %B22
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
	b.hi	LBB185_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB185_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB185_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB185_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, le
	br	x1
LBB185_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB185_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB185_10
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
LBB185_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB185_12
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
LBB185_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB185_12
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
LBB185_12:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        ; =0xa4
	str	x20, [x23, #64]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB185_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB185_14:                              ; %B22
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
	b.hi	LBB186_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB186_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB186_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB186_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB186_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB186_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB186_10
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
LBB186_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB186_12
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
LBB186_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB186_12
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
LBB186_12:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        ; =0xa5
	str	x20, [x23, #64]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB186_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB186_14:                              ; %B22
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
	b.hi	LBB187_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB187_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB187_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB187_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #16
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB187_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB187_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB187_10
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
LBB187_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB187_12
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
LBB187_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB187_12
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
LBB187_12:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        ; =0xa6
	str	x20, [x23, #64]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB187_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB187_14:                              ; %B22
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_instanceof_0_asm_h     ; -- Begin function instanceof_0_asm_h
	.globl	_instanceof_0_asm_h
	.p2align	2
_instanceof_0_asm_h:                    ; @instanceof_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	mov	x2, x21
	bl	_prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	LBB188_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB188_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_in_0_asm_h             ; -- Begin function in_0_asm_h
	.globl	_in_0_asm_h
	.p2align	2
_in_0_asm_h:                            ; @in_0_asm_h
; %bb.0:                                ; %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x23, #64]
	mov	x1, x22
	mov	x2, x21
	bl	_prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	LBB189_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB189_2:                               ; %B2
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
	b.hi	LBB190_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB190_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB190_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB190_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB190_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB190_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB190_11
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
LBB190_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB190_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB190_10:                              ; %B39
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
LBB190_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB190_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB190_10
LBB190_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB190_15
LBB190_14:                              ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB190_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB190_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB190_14
	b	LBB190_20
LBB190_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB190_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB190_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB190_21
LBB190_20:                              ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB190_21:                              ; %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x23, #64]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB190_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB190_23:                              ; %B42
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
	b.hi	LBB191_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB191_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB191_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB191_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB191_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB191_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB191_11
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
LBB191_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB191_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB191_10:                              ; %B39
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
LBB191_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB191_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB191_10
LBB191_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB191_15
LBB191_14:                              ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB191_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB191_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB191_14
	b	LBB191_20
LBB191_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB191_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB191_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB191_21
LBB191_20:                              ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB191_21:                              ; %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #64]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB191_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB191_23:                              ; %B42
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_strict_eq_0_asm_h      ; -- Begin function strict_eq_0_asm_h
	.globl	_strict_eq_0_asm_h
	.p2align	2
_strict_eq_0_asm_h:                     ; @strict_eq_0_asm_h
; %bb.0:                                ; %B36
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB192_13
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB192_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB192_5
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB192_8
; %bb.4:                                ; %B32
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB192_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB192_13
; %bb.6:                                ; %B20
	cmp	x21, x8
	b.lo	LBB192_11
; %bb.7:                                ; %B25
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
LBB192_8:                               ; %B29
	tst	x21, #0xfffe000000000000
	b.eq	LBB192_13
; %bb.9:                                ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB192_10:                              ; %B31
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
LBB192_11:                              ; %B22
	tst	x21, #0xfffe000000000000
	b.eq	LBB192_13
; %bb.12:                               ; %B24
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB192_10
LBB192_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB192_15
; %bb.14:                               ; %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB192_15:                              ; %B13
	and	x8, x21, #0xffff000000000003
	mov	x11, #-281474976710653          ; =0xffff000000000003
	mov	x12, #2                         ; =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	mov	x13, #2                         ; =0x2
	ccmp	x8, x12, #4, ne
	movk	x13, #65535, lsl #48
	and	x9, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w10, eq
	cmp	x9, x13
	ccmp	x9, x12, #4, ne
	ccmp	x9, x11, #4, ne
	b.ne	LBB192_17
; %bb.16:                               ; %B13
	tbnz	w10, #0, LBB192_20
LBB192_17:                              ; %B16
	mov	x10, #-281474976710656          ; =0xffff000000000000
	cmp	x9, x10
	b.ne	LBB192_19
; %bb.18:                               ; %B16
	cmp	x8, x10
	b.eq	LBB192_22
LBB192_19:                              ; %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB192_20:                              ; %B33
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x23, #64]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB192_24
; %bb.21:                               ; %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB192_22:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #16
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB192_25
; %bb.23:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB192_24:                              ; %B34
	b	_exception_asm_h
LBB192_25:                              ; %B8
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
; %bb.0:                                ; %B36
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB193_13
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB193_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB193_5
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB193_8
; %bb.4:                                ; %B32
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #16
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB193_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB193_13
; %bb.6:                                ; %B20
	cmp	x21, x8
	b.lo	LBB193_11
; %bb.7:                                ; %B25
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
LBB193_8:                               ; %B29
	tst	x21, #0xfffe000000000000
	b.eq	LBB193_13
; %bb.9:                                ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB193_10:                              ; %B31
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
LBB193_11:                              ; %B22
	tst	x21, #0xfffe000000000000
	b.eq	LBB193_13
; %bb.12:                               ; %B24
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB193_10
LBB193_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB193_15
; %bb.14:                               ; %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB193_15:                              ; %B13
	and	x8, x21, #0xffff000000000003
	mov	x11, #-281474976710653          ; =0xffff000000000003
	mov	x12, #2                         ; =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	mov	x13, #2                         ; =0x2
	ccmp	x8, x12, #4, ne
	movk	x13, #65535, lsl #48
	and	x9, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w10, eq
	cmp	x9, x13
	ccmp	x9, x12, #4, ne
	ccmp	x9, x11, #4, ne
	b.ne	LBB193_17
; %bb.16:                               ; %B13
	tbnz	w10, #0, LBB193_20
LBB193_17:                              ; %B16
	mov	x10, #-281474976710656          ; =0xffff000000000000
	cmp	x9, x10
	b.ne	LBB193_19
; %bb.18:                               ; %B16
	cmp	x8, x10
	b.eq	LBB193_22
LBB193_19:                              ; %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB193_20:                              ; %B33
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x20, [x23, #64]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB193_24
; %bb.21:                               ; %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB193_22:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #16
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB193_25
; %bb.23:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB193_24:                              ; %B34
	b	_exception_asm_h
LBB193_25:                              ; %B8
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
	b.hi	LBB194_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB194_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB194_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB194_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB194_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #16
	and	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB194_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB194_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB194_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB194_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB194_5
LBB194_10:                              ; %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        ; =0xad
	str	x20, [x23, #64]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB194_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB194_12:                              ; %B26
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
	sub	x20, x20, #16
	eor	w8, w8, w21
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
	mov	w3, #174                        ; =0xae
	str	x20, [x23, #64]
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
	sub	x20, x20, #16
	orr	w8, w8, w21
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
	mov	w3, #175                        ; =0xaf
	str	x20, [x23, #64]
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
; %bb.0:                                ; %B0
	ldrb	w9, [x19, #1]
	ldr	x8, [x23, #120]
	ldrb	w10, [x19], #2
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x22, [x8, x10, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_fclosure8_0_asm_h      ; -- Begin function fclosure8_0_asm_h
	.globl	_fclosure8_0_asm_h
	.p2align	2
_fclosure8_0_asm_h:                     ; @fclosure8_0_asm_h
; %bb.0:                                ; %B1
	ldr	x8, [x23, #120]
	ldrb	w9, [x19]
	mov	x0, x24
	mov	x2, x26
	mov	x3, x23
	ldr	x1, [x8, x9, lsl #3]
	str	x20, [x23, #64]
	bl	_js_closure_gc
	cmp	x0, #130
	b.eq	LBB210_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB210_2:                               ; %B2
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_push_empty_string_0_asm_h ; -- Begin function push_empty_string_0_asm_h
	.globl	_push_empty_string_0_asm_h
	.p2align	2
_push_empty_string_0_asm_h:             ; @push_empty_string_0_asm_h
; %bb.0:                                ; %B1
	mov	x0, x24
	mov	w1, #47                         ; =0x2f
	mov	w2, #1                          ; =0x1
	str	x20, [x23, #64]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB211_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB211_2:                               ; %B2
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
; %bb.0:                                ; %B24
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB251_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB251_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB251_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	mvn	w10, w10
	orr	w10, w10, #0xffffffcf
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, LBB251_5
LBB251_3:                               ; %B1
                                        ;   Parent Loop BB251_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, #48
	b.eq	LBB251_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB251_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB251_3
LBB251_5:                               ; %B14
                                        ;   in Loop: Header=BB251_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB251_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB251_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB251_2
	b	LBB251_9
LBB251_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB251_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB251_9:                               ; %B6
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB251_10:                              ; %B21
	mov	x0, x24
	mov	x1, x22
	mov	w2, #48                         ; =0x30
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x23, #64]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB251_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB251_12:                              ; %B22
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
	b.le	LBB252_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB252_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB252_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB252_6
	b	LBB252_7
LBB252_4:                               ; %B23
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.eq	LBB252_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB252_7
LBB252_6:                               ; %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB252_7:                               ; %B9
	mov	x9, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x9
	b.hs	LBB252_13
; %bb.8:                                ; %B11
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.lo	LBB252_10
LBB252_9:                               ; %B19
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB252_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB252_13
; %bb.11:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB252_6
	b.vs	LBB252_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB252_9
	b	LBB252_6
LBB252_13:                              ; %B15
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
	b.le	LBB253_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB253_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB253_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB253_6
	b	LBB253_7
LBB253_4:                               ; %B23
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.eq	LBB253_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB253_7
LBB253_6:                               ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB253_7:                               ; %B9
	mov	x9, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x9
	b.hs	LBB253_13
; %bb.8:                                ; %B11
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x9
	b.lo	LBB253_10
LBB253_9:                               ; %B19
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB253_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB253_13
; %bb.11:                               ; %B17
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB253_6
	b.vs	LBB253_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB253_9
	b	LBB253_6
LBB253_13:                              ; %B15
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
	str	x19, [x23, #48]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	str	x20, [x23, #64]
	mov	x0, xzr
	ldur	x22, [x20, #-8]
	bl	_common_call_asm_h
	ldr	x19, [x23, #48]
	ldr	x20, [x23, #64]
	cmp	x0, #130
	ldp	x28, x27, [x23, #16]
	ldr	x26, [x23, #112]
	b.eq	LBB256_2
; %bb.1:                                ; %B4
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB256_2:                               ; %B3
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_call1_0_asm_h          ; -- Begin function call1_0_asm_h
	.globl	_call1_0_asm_h
	.p2align	2
_call1_0_asm_h:                         ; @call1_0_asm_h
; %bb.0:                                ; %B2
	str	x19, [x23, #48]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	str	x20, [x23, #64]
	mov	w0, #1                          ; =0x1
	ldur	x22, [x20, #-16]
	sub	x20, x20, #8
	bl	_common_call_asm_h
	ldr	x19, [x23, #48]
	ldr	x20, [x23, #64]
	cmp	x0, #130
	ldp	x28, x27, [x23, #16]
	ldr	x26, [x23, #112]
	b.eq	LBB257_2
; %bb.1:                                ; %B4
	stur	x0, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB257_2:                               ; %B3
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_call2_0_asm_h          ; -- Begin function call2_0_asm_h
	.globl	_call2_0_asm_h
	.p2align	2
_call2_0_asm_h:                         ; @call2_0_asm_h
; %bb.0:                                ; %B2
	str	x19, [x23, #48]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	str	x20, [x23, #64]
	mov	w0, #2                          ; =0x2
	ldur	x22, [x20, #-24]
	sub	x20, x20, #16
	bl	_common_call_asm_h
	ldr	x19, [x23, #48]
	ldr	x20, [x23, #64]
	cmp	x0, #130
	ldp	x28, x27, [x23, #16]
	ldr	x26, [x23, #112]
	b.eq	LBB258_2
; %bb.1:                                ; %B4
	stur	x0, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB258_2:                               ; %B3
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_call3_0_asm_h          ; -- Begin function call3_0_asm_h
	.globl	_call3_0_asm_h
	.p2align	2
_call3_0_asm_h:                         ; @call3_0_asm_h
; %bb.0:                                ; %B2
	str	x19, [x23, #48]
	mov	w27, #18                        ; =0x12
	mov	w21, #18                        ; =0x12
	str	x20, [x23, #64]
	mov	w0, #3                          ; =0x3
	ldur	x22, [x20, #-32]
	sub	x20, x20, #24
	bl	_common_call_asm_h
	ldr	x19, [x23, #48]
	ldr	x20, [x23, #64]
	cmp	x0, #130
	ldp	x28, x27, [x23, #16]
	ldr	x26, [x23, #112]
	b.eq	LBB259_2
; %bb.1:                                ; %B4
	stur	x0, [x20, #-32]
	sub	x20, x20, #24
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB259_2:                               ; %B3
	b	_exception_asm_h
                                        ; -- End function
	.private_extern	_is_undefined_0_asm_h   ; -- Begin function is_undefined_0_asm_h
	.globl	_is_undefined_0_asm_h
	.p2align	2
_is_undefined_0_asm_h:                  ; @is_undefined_0_asm_h
; %bb.0:                                ; %B2
	ldur	x22, [x20, #-8]
	cmp	x22, #18
	b.ne	LBB260_2
; %bb.1:                                ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB260_2:                               ; %B5
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
	b.ne	LBB261_2
; %bb.1:                                ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB261_2:                               ; %B5
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
	b.ne	LBB262_2
; %bb.1:                                ; %B2
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB262_2:                               ; %B5
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
	cbz	x8, LBB263_3
; %bb.1:                                ; %B7
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbnz	x8, LBB263_4
LBB263_2:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB263_3:                               ; %B11
	mov	x0, x24
	str	x20, [x23, #64]
	bl	_EnsureCoverageCounters
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbz	x8, LBB263_2
LBB263_4:                               ; %B2
	ldr	w9, [x19]
	ldr	w10, [x10, #104]
	cmp	w9, w10
	b.hs	LBB263_2
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
Lloh20:
	adrp	x1, l___unnamed_11@PAGE
Lloh21:
	add	x1, x1, l___unnamed_11@PAGEOFF
	ldr	x8, [x8, #32]
	ldr	x8, [x8, #8]
	str	x20, [x23, #64]
	mvn	x8, x8
	add	x8, x8, x19
	stp	x8, xzr, [sp, #-16]!
	bl	_LEPUS_ThrowInternalError
	add	sp, sp, #16
	b	_exception_asm_h
	.loh AdrpAdd	Lloh20, Lloh21
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
; %bb.0:                                ; %B0
	ldrb	w9, [x19, #4]
	ldr	x8, [x23, #120]
	ldrsw	x10, [x19]
	add	x19, x19, #5
	add	w9, w9, #486
	ldr	x21, [x8, x10, lsl #3]
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_fclosure_1_asm_h       ; -- Begin function fclosure_1_asm_h
	.globl	_fclosure_1_asm_h
	.p2align	2
_fclosure_1_asm_h:                      ; @fclosure_1_asm_h
; %bb.0:                                ; %B1
	ldr	x8, [x23, #120]
	ldrsw	x9, [x19]
	mov	x10, x20
	mov	x0, x24
	mov	x2, x26
	mov	x3, x23
	ldr	x1, [x8, x9, lsl #3]
	str	x22, [x10], #8
	str	x10, [x23, #64]
	bl	_js_closure_gc
	cmp	x0, #130
	b.eq	LBB267_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB267_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_push_atom_value_1_asm_h ; -- Begin function push_atom_value_1_asm_h
	.globl	_push_atom_value_1_asm_h
	.p2align	2
_push_atom_value_1_asm_h:               ; @push_atom_value_1_asm_h
; %bb.0:                                ; %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB268_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB268_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	LBB269_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB269_2:                               ; %B2
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
	ldr	w8, [x23, #60]
	ldr	x1, [x23, #96]
	tbnz	w8, #0, LBB272_2
; %bb.1:                                ; %B12
	ldr	x8, [x23, #96]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, LBB272_3
LBB272_2:                               ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
LBB272_3:                               ; %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	LBB272_5
; %bb.4:                                ; %B7
	ldrb	w8, [x19], #1
	ldr	x21, [x24, #208]
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB272_5:                               ; %B9
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB272_7
; %bb.6:                                ; %B11
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB272_7:                               ; %B10
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
; %bb.0:                                ; %B1
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	LBB275_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB275_2:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_special_object_1_asm_h ; -- Begin function special_object_1_asm_h
	.globl	_special_object_1_asm_h
	.p2align	2
_special_object_1_asm_h:                ; @special_object_1_asm_h
; %bb.0:                                ; %B15
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	LBB276_4
; %bb.1:                                ; %B15
	cbz	w8, LBB276_7
; %bb.2:                                ; %B15
	cmp	w8, #1
	b.ne	LBB276_12
; %bb.3:                                ; %B6
	ldr	x8, [x23, #8]
	ldr	w1, [x23, #128]
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
	bl	_js_build_mapped_arguments_gc
	b	LBB276_8
LBB276_4:                               ; %B15
	cmp	w8, #5
	b.eq	LBB276_10
; %bb.5:                                ; %B15
	cmp	w8, #4
	b.ne	LBB276_13
; %bb.6:                                ; %B9
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
LBB276_7:                               ; %B1
	ldr	w1, [x23, #128]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x28
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_js_build_arguments_gc
LBB276_8:                               ; %B6
	cmp	x0, #130
	b.eq	LBB276_11
LBB276_9:
	mov	x8, x0
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB276_10:                              ; %B12
	mov	x8, x20
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.ne	LBB276_9
LBB276_11:                              ; %B13
	b	_exception_spill_top0_asm_h
LBB276_12:                              ; %B18
	ldr	x8, [x23, #8]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB276_13:                              ; %B19
	ldr	x8, [x23, #104]
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
                                        ; -- End function
	.private_extern	_rest_1_asm_h           ; -- Begin function rest_1_asm_h
	.globl	_rest_1_asm_h
	.p2align	2
_rest_1_asm_h:                          ; @rest_1_asm_h
; %bb.0:                                ; %B1
	ldr	w2, [x23, #128]
	ldrh	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x3, x28
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_js_build_rest_gc
	cmp	x0, #130
	b.eq	LBB277_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB277_2:                               ; %B2
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
	b.eq	LBB306_3
; %bb.1:                                ; %B2
	cmp	x22, #18
	b.eq	LBB306_4
; %bb.2:                                ; %B3
	mov	x8, x20
Lloh22:
	adrp	x1, l___unnamed_12@PAGE
Lloh23:
	add	x1, x1, l___unnamed_12@PAGEOFF
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_LEPUS_ThrowTypeError
	b	_exception_spill_top0_asm_h
LBB306_3:                               ; %B6
	ldrb	w8, [x19], #1
	mov	w21, #6                         ; =0x6
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB306_4:                               ; %B4
	ldrb	w8, [x19], #1
	mov	w21, #7                         ; =0x7
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh22, Lloh23
                                        ; -- End function
	.private_extern	_check_ctor_1_asm_h     ; -- Begin function check_ctor_1_asm_h
	.globl	_check_ctor_1_asm_h
	.p2align	2
_check_ctor_1_asm_h:                    ; @check_ctor_1_asm_h
; %bb.0:                                ; %B2
	ldr	x8, [x23, #104]
	cmp	x8, #18
	b.ne	LBB307_2
; %bb.1:                                ; %B3
	mov	x8, x20
Lloh24:
	adrp	x1, l___unnamed_13@PAGE
Lloh25:
	add	x1, x1, l___unnamed_13@PAGEOFF
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_LEPUS_ThrowTypeError
	b	_exception_spill_top0_asm_h
LBB307_2:                               ; %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh24, Lloh25
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
	str	x8, [x23, #64]
	bl	_JS_CheckBrand_GC
	tbnz	w0, #31, LBB308_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB308_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_AddBrand_GC
	tbnz	w0, #31, LBB309_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB309_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	LBB314_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB314_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	LBB315_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB315_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_GetPrototype_GC
	cmp	x0, #130
	b.eq	LBB316_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB316_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_js_dynamic_import
	cmp	x0, #130
	b.eq	LBB317_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB317_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_CheckGlobalVar_GC
	tbnz	w0, #31, LBB318_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x21, x8, ne
	br	x1
LBB318_2:                               ; %B2
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
	and	w11, w9, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, LBB319_3
LBB319_1:                               ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldr	w13, [x12, #44]
	cmp	w13, w9
	b.eq	LBB319_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB319_1 Depth=1
	ldur	w11, [x12, #40]
	and	w11, w11, #0x3ffffff
	cbnz	w11, LBB319_1
LBB319_3:                               ; %B11
	ldr	x8, [x24, #208]
	mov	w10, #18                        ; =0x12
LBB319_4:                               ; %B33
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB319_5 Depth 2
	ldr	x12, [x8, #8]
	ldr	w11, [x12, #12]
	and	w11, w9, w11
	mvn	w11, w11
	ldr	w11, [x12, w11, sxtw #2]
	cbz	w11, LBB319_7
LBB319_5:                               ; %B22
                                        ;   Parent Loop BB319_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w9
	b.eq	LBB319_9
; %bb.6:                                ; %B24
                                        ;   in Loop: Header=BB319_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB319_5
LBB319_7:                               ; %B27
                                        ;   in Loop: Header=BB319_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	LBB319_13
; %bb.8:                                ; %B30
                                        ;   in Loop: Header=BB319_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB319_4
	b	LBB319_11
LBB319_9:                               ; %B12
	lsr	w9, w13, #26
	tst	w9, #0x30
	b.ne	LBB319_13
LBB319_10:                              ; %B7.sink.split
	ldr	x8, [x8, #16]
	sub	w9, w11, #1
	ldr	x10, [x8, w9, sxtw #3]
LBB319_11:                              ; %B7
	cmp	x10, #34
	b.eq	LBB319_15
; %bb.12:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x10
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB319_13:                              ; %B17
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB319_16
; %bb.14:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB319_15:                              ; %B3
	str	x22, [x20], #8
	b	_ThrowReferenceErrorUninitialized_asm_h
LBB319_16:                              ; %B18
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_get_var_1_asm_h        ; -- Begin function get_var_1_asm_h
	.globl	_get_var_1_asm_h
	.p2align	2
_get_var_1_asm_h:                       ; @get_var_1_asm_h
; %bb.0:                                ; %B0
	ldr	x8, [x24, #216]
	ldr	w9, [x19]
	ldr	x11, [x8, #8]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, LBB320_3
LBB320_1:                               ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #44]
	cmp	w13, w9
	b.eq	LBB320_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB320_1 Depth=1
	ldur	w10, [x12, #40]
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB320_1
LBB320_3:                               ; %B11
	ldr	x8, [x24, #208]
LBB320_4:                               ; %B32
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB320_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, LBB320_7
LBB320_5:                               ; %B21
                                        ;   Parent Loop BB320_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w9
	b.eq	LBB320_9
; %bb.6:                                ; %B23
                                        ;   in Loop: Header=BB320_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB320_5
LBB320_7:                               ; %B26
                                        ;   in Loop: Header=BB320_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB320_12
; %bb.8:                                ; %B29
                                        ;   in Loop: Header=BB320_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB320_4
	b	LBB320_12
LBB320_9:                               ; %B12
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	LBB320_12
LBB320_10:                              ; %B7
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	LBB320_14
; %bb.11:                               ; %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB320_12:                              ; %B16
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB320_15
; %bb.13:                               ; %B18
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB320_14:                              ; %B3
	str	x22, [x20], #8
	b	_ThrowReferenceErrorUninitialized_asm_h
LBB320_15:                              ; %B17
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
	str	x8, [x23, #64]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB321_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB321_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB322_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB322_2:                               ; %B2
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
	b.ne	LBB323_3
; %bb.1:                                ; %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          ; =0x2
	stur	x21, [x8, #-8]
	str	x8, [x23, #64]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB323_4
; %bb.2:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB323_3:                               ; %B6
	ldr	w1, [x19]
	mov	x0, x24
	str	x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB323_4:                               ; %B2
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
	str	x8, [x23, #64]
	b.eq	LBB324_3
; %bb.1:                                ; %B1
	mov	x1, x22
	mov	x2, x21
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB324_5
; %bb.2:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB324_3:                               ; %B5
	mov	x1, x21
	bl	_js_value_to_atom_gc
	cbz	w0, LBB324_5
; %bb.4:                                ; %B7
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB324_5:                               ; %B6
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
	b.eq	LBB325_3
LBB325_1:                               ; %B1
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_SetPropertyValue_GC
	tbnz	w0, #31, LBB325_7
; %bb.2:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB325_3:                               ; %B8
	ldrb	w8, [x23, #60]
	tbnz	w8, #0, LBB325_5
; %bb.4:                                ; %B9
	ldr	x1, [x24, #208]
	b	LBB325_1
LBB325_5:                               ; %B5
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB325_7
; %bb.6:                                ; %B7
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB325_7:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_DefineGlobalVar_GC
	tbnz	w0, #31, LBB326_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB326_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, LBB327_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB327_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_DefineGlobalFunction_GC
	tbnz	w0, #31, LBB328_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB328_2:                               ; %B2
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
	b.ne	LBB329_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB329_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB329_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, LBB329_5
LBB329_3:                               ; %B1
                                        ;   Parent Loop BB329_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w2
	b.eq	LBB329_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB329_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB329_3
LBB329_5:                               ; %B14
                                        ;   in Loop: Header=BB329_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB329_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB329_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB329_2
	b	LBB329_9
LBB329_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB329_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB329_9:                               ; %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB329_10:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB329_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB329_12:                              ; %B22
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
	b.ne	LBB330_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB330_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB330_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, LBB330_5
LBB330_3:                               ; %B1
                                        ;   Parent Loop BB330_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w2
	b.eq	LBB330_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB330_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB330_3
LBB330_5:                               ; %B14
                                        ;   in Loop: Header=BB330_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB330_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB330_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB330_2
	b	LBB330_9
LBB330_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB330_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB330_9:                               ; %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB330_10:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB330_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB330_12:                              ; %B22
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_put_field_1_asm_h      ; -- Begin function put_field_1_asm_h
	.globl	_put_field_1_asm_h
	.p2align	2
_put_field_1_asm_h:                     ; @put_field_1_asm_h
; %bb.0:                                ; %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	ldr	w2, [x19]
	tst	x22, x8
	b.ne	LBB331_17
; %bb.1:                                ; %B45
	ldr	x9, [x22, #8]
	ldr	w8, [x9, #12]
	and	w8, w2, w8
	mvn	w8, w8
	ldr	w8, [x9, w8, sxtw #2]
	cbz	w8, LBB331_4
LBB331_2:                               ; %B1
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10, #40]
	cmp	w11, w2
	b.eq	LBB331_13
; %bb.3:                                ; %B12
                                        ;   in Loop: Header=BB331_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB331_2
LBB331_4:                               ; %B17.preheader
	mov	x8, x22
LBB331_5:                               ; %B17
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB331_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x9, w10, sxtw #2]
	cbz	w10, LBB331_8
LBB331_6:                               ; %B18
                                        ;   Parent Loop BB331_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldr	w11, [x10, #44]
	cmp	w11, w2
	b.eq	LBB331_17
; %bb.7:                                ; %B20
                                        ;   in Loop: Header=BB331_6 Depth=2
	ldur	w10, [x10, #40]
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB331_6
LBB331_8:                               ; %B30
                                        ;   in Loop: Header=BB331_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB331_17
; %bb.9:                                ; %B24
                                        ;   in Loop: Header=BB331_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB331_5
; %bb.10:                               ; %B27
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	LBB331_17
; %bb.11:                               ; %B34
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w3, #7                          ; =0x7
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_add_property_gc
	cbz	x0, LBB331_19
; %bb.12:                               ; %B38
	str	x21, [x0]
	b	LBB331_15
LBB331_13:                              ; %B3
	mov	w9, #58                         ; =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	LBB331_17
; %bb.14:                               ; %B7
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
LBB331_15:                              ; %B38
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB331_20
LBB331_16:                              ; %B37
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB331_17:                              ; %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_SetPropertyInternalImpl_GC
	tbz	w0, #31, LBB331_16
; %bb.18:                               ; %B42
	b	_exception_spill_top1_asm_h
LBB331_19:                              ; %B35
	sub	x20, x20, #8
	b	_exception_spill_top1_asm_h
LBB331_20:                              ; %B40
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
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
	str	x8, [x23, #64]
	bl	_JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	LBB332_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB332_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_SetPrivateField_GC
	tbnz	w0, #31, LBB333_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB333_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_DefinePrivateField_GC
	tbnz	w0, #31, LBB334_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB334_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_get_array_el_1_asm_h   ; -- Begin function get_array_el_1_asm_h
	.globl	_get_array_el_1_asm_h
	.p2align	2
_get_array_el_1_asm_h:                  ; @get_array_el_1_asm_h
; %bb.0:                                ; %B33
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB335_15
; %bb.1:                                ; %B33
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x8, x9
	b.ne	LBB335_15
; %bb.2:                                ; %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	LBB335_15
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB335_5
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB335_5:                               ; %B7
	tbnz	w21, #31, LBB335_15
; %bb.6:                                ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
	orr	w12, w21, #0x80000000
LBB335_7:                               ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB335_8 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	and	w11, w12, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, LBB335_10
LBB335_8:                               ; %B10
                                        ;   Parent Loop BB335_7 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x10, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w12
	b.eq	LBB335_12
; %bb.9:                                ; %B17
                                        ;   in Loop: Header=BB335_8 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB335_8
LBB335_10:                              ; %B24
                                        ;   in Loop: Header=BB335_7 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB335_15
; %bb.11:                               ; %B21
                                        ;   in Loop: Header=BB335_7 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB335_7
	b	LBB335_14
LBB335_12:                              ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB335_15
; %bb.13:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB335_14:                              ; %B14
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB335_15:                              ; %B30
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB335_17
; %bb.16:                               ; %B32
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB335_17:                              ; %B31
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_get_array_el2_1_asm_h  ; -- Begin function get_array_el2_1_asm_h
	.globl	_get_array_el2_1_asm_h
	.p2align	2
_get_array_el2_1_asm_h:                 ; @get_array_el2_1_asm_h
; %bb.0:                                ; %B33
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB336_15
; %bb.1:                                ; %B33
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x8, x9
	b.ne	LBB336_15
; %bb.2:                                ; %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	LBB336_15
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB336_5
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	sub	x20, x20, #8
	add	w8, w8, #486
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB336_5:                               ; %B7
	tbnz	w21, #31, LBB336_15
; %bb.6:                                ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
	orr	w12, w21, #0x80000000
LBB336_7:                               ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB336_8 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	and	w11, w12, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, LBB336_10
LBB336_8:                               ; %B10
                                        ;   Parent Loop BB336_7 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x10, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w12
	b.eq	LBB336_12
; %bb.9:                                ; %B17
                                        ;   in Loop: Header=BB336_8 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB336_8
LBB336_10:                              ; %B24
                                        ;   in Loop: Header=BB336_7 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB336_15
; %bb.11:                               ; %B21
                                        ;   in Loop: Header=BB336_7 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB336_7
	b	LBB336_14
LBB336_12:                              ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB336_15
; %bb.13:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB336_14:                              ; %B14
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB336_15:                              ; %B30
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB336_17
; %bb.16:                               ; %B32
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB336_17:                              ; %B31
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_put_array_el_1_asm_h   ; -- Begin function put_array_el_1_asm_h
	.globl	_put_array_el_1_asm_h
	.p2align	2
_put_array_el_1_asm_h:                  ; @put_array_el_1_asm_h
; %bb.0:                                ; %B63
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x1, x8
	b.ne	LBB337_16
; %bb.1:                                ; %B57
	ldrsh	w8, [x1, #6]
	cmp	w8, #2
	b.ne	LBB337_6
; %bb.2:                                ; %B1
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB337_16
; %bb.3:                                ; %B50
	ldr	w8, [x1, #48]
	cmp	w22, w8
	b.hs	LBB337_7
; %bb.4:                                ; %B3
	ldr	x8, [x1, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB337_23
LBB337_5:                               ; %B56
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB337_6:                               ; %B60
	cmp	w8, #30
	ccmp	w8, #20, #4, lt
	mov	w8, #32768                      ; =0x8000
	csel	w4, wzr, w8, gt
	b	LBB337_17
LBB337_7:                               ; %B8
	b.ne	LBB337_16
; %bb.8:                                ; %B46
	ldr	w9, [x1, #4]
	mov	w4, #32768                      ; =0x8000
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	b.ne	LBB337_17
; %bb.9:                                ; %B46
	ubfx	w9, w9, #8, #1
	cbz	w9, LBB337_17
; %bb.10:                               ; %B47
	ldr	x9, [x1, #8]
LBB337_11:                              ; %B15
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x10, [x9, #32]
	cbz	x10, LBB337_19
; %bb.12:                               ; %B10
                                        ;   in Loop: Header=BB337_11 Depth=1
	ldrh	w11, [x10, #6]
	ldr	x9, [x10, #8]
	cmp	w11, #2
	b.ne	LBB337_14
; %bb.13:                               ; %B12
                                        ;   in Loop: Header=BB337_11 Depth=1
	ldr	w10, [x10, #4]
	ubfx	w10, w10, #11, #1
	cmp	w10, #1
	b.eq	LBB337_11
	b	LBB337_16
LBB337_14:                              ; %B10
                                        ;   in Loop: Header=BB337_11 Depth=1
	cmp	w11, #1
	b.ne	LBB337_16
; %bb.15:                               ; %B42
                                        ;   in Loop: Header=BB337_11 Depth=1
	ldrb	w10, [x9, #6]
	cbz	w10, LBB337_11
LBB337_16:
	mov	w4, #32768                      ; =0x8000
LBB337_17:                              ; %B54
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_SetPropertyValue_GC
	tbz	w0, #31, LBB337_5
; %bb.18:                               ; %B55
	b	_exception_spill_top1_asm_h
LBB337_19:                              ; %B33
	ldr	x9, [x1, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	LBB337_21
; %bb.20:                               ; %B33
	cmp	w9, w10
	b.hi	LBB337_24
LBB337_21:                              ; %B30
	ldr	w10, [x1, #32]
	cmp	w9, w10
	b.hi	LBB337_24
; %bb.22:                               ; %B26
	ldr	x10, [x1, #40]
	str	w9, [x1, #48]
	str	x21, [x10, w8, sxtw #3]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB337_5
LBB337_23:                              ; %B29
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB337_24:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x2, x21
	mov	w3, #32768                      ; =0x8000
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_add_fast_array_element_gc
	tbz	w0, #31, LBB337_5
; %bb.25:                               ; %B22
	b	_exception_spill_top1_asm_h
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
	str	x19, [x23, #64]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB338_3
; %bb.1:                                ; %B5
	ldur	x3, [x20, #-16]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	str	x21, [x20]
	str	x19, [x23, #64]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB338_3
; %bb.2:                                ; %B7
	ldr	x19, [sp, #8]                   ; 8-byte Folded Reload
	stur	x0, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB338_3:                               ; %B2
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
; %bb.0:                                ; %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	add	x8, x20, #8
	mov	x0, x24
	mov	x3, x21
	mov	x1, x22
	mov	w4, #16391                      ; =0x4007
	str	x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_DefinePropertyValue_GC
	tbnz	w0, #31, LBB340_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB340_2:                               ; %B2
	b	_exception_spill_top1_asm_h
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
	str	x8, [x23, #64]
	bl	_JS_DefineObjectName
	tbnz	w0, #31, LBB341_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB341_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, LBB342_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB342_2:                               ; %B2
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
	b.eq	LBB343_3
; %bb.1:                                ; %B6
	cmp	x21, #2
	b.eq	LBB343_3
LBB343_2:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB343_3:                               ; %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_SetPrototypeInternal_GC
	tbz	w0, #31, LBB343_2
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
	str	x8, [x23, #64]
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
	str	x8, [x23, #64]
	bl	_JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, LBB345_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB345_2:                               ; %B2
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	b.eq	LBB361_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB361_2:                               ; %B3
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
	b.eq	LBB362_2
; %bb.1:                                ; %B4
	str	x22, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB362_2:                               ; %B3
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
	b.ne	LBB363_2
; %bb.1:                                ; %B4
	str	x22, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB363_2:                               ; %B3
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
	ldr	x8, [x8, #32]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	LBB364_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB364_2:                               ; %B3
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
	ldr	x8, [x8, #32]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	LBB365_2
; %bb.1:                                ; %B4
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB365_2:                               ; %B3
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
	ldr	x8, [x8, #32]
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	LBB366_2
; %bb.1:                                ; %B4
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB366_2:                               ; %B3
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
	b.le	LBB368_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB368_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB368_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB368_6
	b	LBB368_7
LBB368_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB368_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB368_7
LBB368_6:                               ; %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB368_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB368_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB368_10
LBB368_9:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB368_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB368_13
; %bb.11:                               ; %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB368_6
	b.vs	LBB368_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB368_9
	b	LBB368_6
LBB368_13:                              ; %B15
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
	b.le	LBB369_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB369_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB369_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB369_6
	b	LBB369_7
LBB369_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB369_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB369_7
LBB369_6:                               ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB369_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB369_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB369_10
LBB369_9:                               ; %B19
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB369_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB369_13
; %bb.11:                               ; %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB369_6
	b.vs	LBB369_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB369_9
	b	LBB369_6
LBB369_13:                              ; %B15
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
	b.ne	LBB373_3
; %bb.1:                                ; %B1
	ldr	x8, [x23, #8]
	ldr	x8, [x8, #32]
	ldr	w9, [x8, #16]
	cmp	w22, w9
	b.ge	LBB373_3
; %bb.2:                                ; %B5
	ldr	x8, [x8, #8]
	add	x19, x8, w22, sxtw
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB373_3:                               ; %B3
	mov	x8, x20
Lloh26:
	adrp	x1, l___unnamed_14@PAGE
Lloh27:
	add	x1, x1, l___unnamed_14@PAGEOFF
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_LEPUS_ThrowInternalError
	b	_exception_spill_top0_asm_h
	.loh AdrpAdd	Lloh26, Lloh27
                                        ; -- End function
	.private_extern	_to_object_1_asm_h      ; -- Begin function to_object_1_asm_h
	.globl	_to_object_1_asm_h
	.p2align	2
_to_object_1_asm_h:                     ; @to_object_1_asm_h
; %bb.0:                                ; %B6
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB374_2
; %bb.1:                                ; %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB374_2:                               ; %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB374_4
; %bb.3:                                ; %B3
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB374_4:                               ; %B2
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_to_propkey_1_asm_h     ; -- Begin function to_propkey_1_asm_h
	.globl	_to_propkey_1_asm_h
	.p2align	2
_to_propkey_1_asm_h:                    ; @to_propkey_1_asm_h
; %bb.0:                                ; %B15
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	LBB375_4
; %bb.1:                                ; %B15
	mov	x9, #1                          ; =0x1
	and	x8, x22, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB375_4
; %bb.2:                                ; %B15
	cmp	x8, x9
	b.eq	LBB375_4
; %bb.3:                                ; %B15
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB375_5
LBB375_4:                               ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB375_5:                               ; %B12
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB375_7
; %bb.6:                                ; %B14
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB375_7:                               ; %B13
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
	b.ne	LBB376_3
; %bb.1:                                ; %B19
	mov	x8, x20
Lloh28:
	adrp	x1, l___unnamed_15@PAGE
Lloh29:
	add	x1, x1, l___unnamed_15@PAGEOFF
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_LEPUS_ThrowTypeError
LBB376_2:                               ; %B16
	b	_exception_spill_top1_asm_h
LBB376_3:                               ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	LBB376_7
; %bb.4:                                ; %B2
	mov	x9, #1                          ; =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB376_7
; %bb.5:                                ; %B2
	cmp	x8, x9
	b.eq	LBB376_7
; %bb.6:                                ; %B2
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB376_8
LBB376_7:                               ; %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB376_8:                               ; %B15
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB376_2
; %bb.9:                                ; %B17
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh28, Lloh29
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
	str	x8, [x23, #64]
	bl	_prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	LBB387_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB387_2:                               ; %B2
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
	b.hi	LBB404_3
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB404_6
; %bb.2:                                ; %B13
	orr	w8, w22, #0x80000000
	mov	w9, #-2147483648                ; =0x80000000
	cmp	w8, w9
	b.ne	LBB404_5
LBB404_3:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        ; =0x8c
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB404_8
; %bb.4:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB404_5:                               ; %B15
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB404_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB404_3
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
LBB404_8:                               ; %B17
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_plus_1_asm_h           ; -- Begin function plus_1_asm_h
	.globl	_plus_1_asm_h
	.p2align	2
_plus_1_asm_h:                          ; @plus_1_asm_h
; %bb.0:                                ; %B13
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB405_4
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB405_3
LBB405_2:                               ; %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB405_3:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.ne	LBB405_2
LBB405_4:                               ; %B10
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        ; =0x8d
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB405_6
; %bb.5:                                ; %B12
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB405_6:                               ; %B11
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_dec_1_asm_h            ; -- Begin function dec_1_asm_h
	.globl	_dec_1_asm_h
	.p2align	2
_dec_1_asm_h:                           ; @dec_1_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB406_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB406_4
; %bb.2:                                ; %B13
	subs	w8, w22, #1
	b.vs	LBB406_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB406_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB406_6
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
LBB406_6:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        ; =0x8e
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB406_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB406_8:                               ; %B17
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_inc_1_asm_h            ; -- Begin function inc_1_asm_h
	.globl	_inc_1_asm_h
	.p2align	2
_inc_1_asm_h:                           ; @inc_1_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB407_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB407_4
; %bb.2:                                ; %B13
	adds	w8, w22, #1
	b.vs	LBB407_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB407_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB407_6
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
LBB407_6:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        ; =0x8f
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB407_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB407_8:                               ; %B17
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_post_dec_1_asm_h       ; -- Begin function post_dec_1_asm_h
	.globl	_post_dec_1_asm_h
	.p2align	2
_post_dec_1_asm_h:                      ; @post_dec_1_asm_h
; %bb.0:                                ; %B16
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB408_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB408_4
; %bb.2:                                ; %B13
	subs	w8, w22, #1
	b.vs	LBB408_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB408_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB408_6
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
LBB408_6:                               ; %B5
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
	b.hs	LBB409_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB409_4
; %bb.2:                                ; %B13
	adds	w8, w22, #1
	b.vs	LBB409_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB409_4:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB409_6
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
LBB409_6:                               ; %B5
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
	b.hi	LBB410_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB410_4
; %bb.2:                                ; %B13
	subs	w9, w1, #1
	b.vs	LBB410_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB410_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB410_6
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
LBB410_6:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	w2, #142                        ; =0x8e
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB410_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB410_8:                               ; %B17
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
	b.hi	LBB411_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB411_4
; %bb.2:                                ; %B13
	adds	w9, w1, #1
	b.vs	LBB411_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB411_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB411_6
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
LBB411_6:                               ; %B16
	mov	x8, x20
	mov	x0, x24
	mov	w2, #143                        ; =0x8f
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB411_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB411_8:                               ; %B17
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_add_loc_1_asm_h        ; -- Begin function add_loc_1_asm_h
	.globl	_add_loc_1_asm_h
	.p2align	2
_add_loc_1_asm_h:                       ; @add_loc_1_asm_h
; %bb.0:                                ; %B45
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	ccmp	x22, x9, #2, ls
	b.hi	LBB412_14
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB412_5
; %bb.2:                                ; %B26
	cmp	x22, x9
	b.lo	LBB412_8
; %bb.3:                                ; %B36
	adds	w9, w1, w22
	b.vs	LBB412_14
; %bb.4:                                ; %B38
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB412_5:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB412_14
; %bb.6:                                ; %B11
	cmp	x22, x9
	b.lo	LBB412_12
; %bb.7:                                ; %B21
	scvtf	d0, w22
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	LBB412_11
LBB412_8:                               ; %B28
	tst	x22, #0xfffe000000000000
	b.eq	LBB412_14
; %bb.9:                                ; %B31
	scvtf	d0, w1
	add	x9, x22, x9
LBB412_10:                              ; %B31
	fmov	d1, x9
	fadd	d0, d0, d1
LBB412_11:                              ; %B31
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
LBB412_12:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB412_14
; %bb.13:                               ; %B16
	add	x10, x1, x9
	add	x9, x22, x9
	fmov	d0, x10
	b	LBB412_10
LBB412_14:                              ; %B7
	mov	x9, #2                          ; =0x2
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
	b.eq	LBB412_16
; %bb.15:                               ; %B42
	bl	_prim_js_add_slow_gc
	b	LBB412_17
LBB412_16:                              ; %B39
	bl	_JS_ConcatString_GC
LBB412_17:                              ; %B42
	cmp	x0, #130
	b.eq	LBB412_19
; %bb.18:                               ; %B44
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB412_19:                              ; %B43
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_not_1_asm_h            ; -- Begin function not_1_asm_h
	.globl	_not_1_asm_h
	.p2align	2
_not_1_asm_h:                           ; @not_1_asm_h
; %bb.0:                                ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB413_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB413_2:                               ; %B4
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
	b.le	LBB414_4
; %bb.1:                                ; %B14
	cmp	x22, #6
	b.eq	LBB414_6
; %bb.2:                                ; %B14
	cmp	x22, #7
	b.eq	LBB414_8
; %bb.3:                                ; %B14
	cmp	x22, #18
	b.eq	LBB414_6
	b	LBB414_7
LBB414_4:                               ; %B14
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB414_6
; %bb.5:                                ; %B14
	cmp	x22, #2
	b.ne	LBB414_7
LBB414_6:                               ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB414_7:                               ; %B10
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB414_9
LBB414_8:                               ; %B12
	mov	w22, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB414_9:                               ; %B13
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
	str	x8, [x23, #64]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB415_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB415_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	LBB416_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB416_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_DeleteProperty_GC
	tbnz	w0, #31, LBB417_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x21, x8, ne
	br	x1
LBB417_2:                               ; %B2
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
	b.hi	LBB418_18
; %bb.1:                                ; %B47
	cmp	x21, x8
	b.hi	LBB418_18
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB418_8
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB418_11
; %bb.4:                                ; %B33
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	LBB418_18
; %bb.5:                                ; %B36
	cbnz	w8, LBB418_7
; %bb.6:                                ; %B36
	orr	w9, w22, w21
	tbnz	w9, #31, LBB418_15
LBB418_7:                               ; %B43
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB418_8:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB418_18
; %bb.9:                                ; %B7
	cmp	x21, x8
	b.lo	LBB418_16
; %bb.10:                               ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	LBB418_14
LBB418_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB418_18
; %bb.12:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB418_13:                              ; %B28
	fmov	d1, x8
	fmul	d0, d0, d1
LBB418_14:                              ; %B28
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
LBB418_15:                              ; %B40
	mov	x22, #-9222809086901354496      ; =0x8002000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB418_16:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB418_18
; %bb.17:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB418_13
LBB418_18:                              ; %B44
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        ; =0x9a
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB418_20
; %bb.19:                               ; %B46
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB418_20:                              ; %B45
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
	b.hi	LBB419_14
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB419_14
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB419_5
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB419_8
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
LBB419_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB419_14
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB419_12
; %bb.7:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	LBB419_11
LBB419_8:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB419_14
; %bb.9:                                ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB419_10:                              ; %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
LBB419_11:                              ; %B28
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
LBB419_12:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB419_14
; %bb.13:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB419_10
LBB419_14:                              ; %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        ; =0x9b
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB419_16
; %bb.15:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB419_16:                              ; %B42
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
	b.hi	LBB420_16
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB420_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB420_7
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB420_10
; %bb.4:                                ; %B33
	tbnz	w22, #31, LBB420_16
; %bb.5:                                ; %B33
	cmp	w21, #1
	b.lt	LBB420_16
; %bb.6:                                ; %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB420_7:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB420_16
; %bb.8:                                ; %B7
	cmp	x21, x8
	b.lo	LBB420_14
; %bb.9:                                ; %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	LBB420_13
LBB420_10:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB420_16
; %bb.11:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB420_12:                              ; %B28
	fmov	d1, x8
LBB420_13:                              ; %B28
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
LBB420_14:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB420_16
; %bb.15:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB420_12
LBB420_16:                              ; %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        ; =0x9c
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB420_18
; %bb.17:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB420_18:                              ; %B37
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_add_1_asm_h            ; -- Begin function add_1_asm_h
	.globl	_add_1_asm_h
	.p2align	2
_add_1_asm_h:                           ; @add_1_asm_h
; %bb.0:                                ; %B45
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB421_15
; %bb.1:                                ; %B45
	cmp	x21, x8
	b.hi	LBB421_15
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB421_6
; %bb.3:                                ; %B26
	cmp	x21, x8
	b.lo	LBB421_9
; %bb.4:                                ; %B36
	adds	w8, w22, w21
	b.vs	LBB421_15
; %bb.5:                                ; %B38
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB421_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB421_15
; %bb.7:                                ; %B10
	cmp	x21, x8
	b.lo	LBB421_13
; %bb.8:                                ; %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	LBB421_12
LBB421_9:                               ; %B28
	tst	x21, #0xfffe000000000000
	b.eq	LBB421_15
; %bb.10:                               ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB421_11:                              ; %B31
	fmov	d1, x8
	fadd	d0, d0, d1
LBB421_12:                              ; %B31
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
LBB421_13:                              ; %B12
	tst	x21, #0xfffe000000000000
	b.eq	LBB421_15
; %bb.14:                               ; %B15
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB421_11
LBB421_15:                              ; %B6
	mov	x8, #2                          ; =0x2
	and	x9, x22, #0xffff000000000003
	mov	x10, x20
	movk	x8, #1, lsl #48
	str	x21, [x10], #8
	cmp	x9, x8
	str	x10, [x23, #64]
	b.ne	LBB421_18
; %bb.16:                               ; %B6
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.ne	LBB421_18
; %bb.17:                               ; %B39
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	_JS_ConcatString_GC
	b	LBB421_19
LBB421_18:                              ; %B42
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	_prim_js_add_slow_gc
LBB421_19:                              ; %B42
	cmp	x0, #130
	b.eq	LBB421_21
; %bb.20:                               ; %B44
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB421_21:                              ; %B43
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
	b.hi	LBB422_15
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB422_15
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB422_6
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB422_9
; %bb.4:                                ; %B33
	subs	w8, w22, w21
	b.vs	LBB422_15
; %bb.5:                                ; %B35
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB422_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB422_15
; %bb.7:                                ; %B7
	cmp	x21, x8
	b.lo	LBB422_13
; %bb.8:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	LBB422_12
LBB422_9:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB422_15
; %bb.10:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB422_11:                              ; %B28
	fmov	d1, x8
	fsub	d0, d0, d1
LBB422_12:                              ; %B28
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
LBB422_13:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB422_15
; %bb.14:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB422_11
LBB422_15:                              ; %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        ; =0x9e
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB422_17
; %bb.16:                               ; %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB422_17:                              ; %B37
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
	str	x8, [x23, #64]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB423_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB423_2:                               ; %B2
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
	b.hi	LBB424_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB424_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB424_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB424_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB424_5:                               ; %B16
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #8
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB424_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB424_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB424_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB424_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB424_5
LBB424_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        ; =0xa0
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB424_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB424_12:                              ; %B26
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
	b.hi	LBB425_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB425_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB425_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB425_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB425_5:                               ; %B16
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #8
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB425_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB425_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB425_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB425_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB425_5
LBB425_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        ; =0xa1
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB425_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB425_12:                              ; %B26
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
	b.hi	LBB426_11
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB426_11
; %bb.2:                                ; %B10
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB426_6
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB426_11
; %bb.4:                                ; %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, LBB426_10
LBB426_5:                               ; %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB426_6:                               ; %B12
	tst	x22, #0xfffe000000000000
	b.eq	LBB426_11
; %bb.7:                                ; %B12
	cmp	x21, x8
	b.lo	LBB426_11
; %bb.8:                                ; %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB426_11
; %bb.9:                                ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, LBB426_5
LBB426_10:                              ; %B6
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
LBB426_11:                              ; %B33
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	LBB426_13
; %bb.12:                               ; %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB426_13:                              ; %B34
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
	b.hi	LBB427_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB427_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB427_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB427_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, lt
	br	x1
LBB427_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB427_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB427_10
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
LBB427_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB427_12
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
LBB427_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB427_12
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
LBB427_12:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        ; =0xa3
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB427_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB427_14:                              ; %B22
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
	b.hi	LBB428_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB428_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB428_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB428_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, le
	br	x1
LBB428_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB428_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB428_10
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
LBB428_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB428_12
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
LBB428_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB428_12
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
LBB428_12:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        ; =0xa4
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB428_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB428_14:                              ; %B22
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
	b.hi	LBB429_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB429_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB429_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB429_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB429_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB429_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB429_10
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
LBB429_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB429_12
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
LBB429_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB429_12
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
LBB429_12:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        ; =0xa5
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB429_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB429_14:                              ; %B22
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
	b.hi	LBB430_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB430_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB430_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB430_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	sub	x20, x20, #8
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB430_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB430_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB430_10
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
LBB430_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB430_12
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
LBB430_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB430_12
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
LBB430_12:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        ; =0xa6
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB430_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB430_14:                              ; %B22
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
	str	x8, [x23, #64]
	bl	_prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	LBB431_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB431_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	LBB432_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB432_2:                               ; %B2
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
	b.hi	LBB433_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB433_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB433_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB433_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB433_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB433_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB433_11
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
LBB433_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB433_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB433_10:                              ; %B39
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
LBB433_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB433_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB433_10
LBB433_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB433_15
LBB433_14:                              ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB433_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB433_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB433_14
	b	LBB433_20
LBB433_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB433_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB433_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB433_21
LBB433_20:                              ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB433_21:                              ; %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB433_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB433_23:                              ; %B42
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
	b.hi	LBB434_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB434_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB434_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB434_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB434_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB434_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB434_11
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
LBB434_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB434_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB434_10:                              ; %B39
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
LBB434_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB434_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB434_10
LBB434_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB434_15
LBB434_14:                              ; %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB434_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB434_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB434_14
	b	LBB434_20
LBB434_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB434_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB434_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB434_21
LBB434_20:                              ; %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB434_21:                              ; %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB434_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB434_23:                              ; %B42
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_strict_eq_1_asm_h      ; -- Begin function strict_eq_1_asm_h
	.globl	_strict_eq_1_asm_h
	.p2align	2
_strict_eq_1_asm_h:                     ; @strict_eq_1_asm_h
; %bb.0:                                ; %B36
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB435_13
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB435_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB435_5
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB435_8
; %bb.4:                                ; %B32
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB435_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB435_13
; %bb.6:                                ; %B20
	cmp	x21, x8
	b.lo	LBB435_11
; %bb.7:                                ; %B25
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
LBB435_8:                               ; %B29
	tst	x21, #0xfffe000000000000
	b.eq	LBB435_13
; %bb.9:                                ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB435_10:                              ; %B31
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
LBB435_11:                              ; %B22
	tst	x21, #0xfffe000000000000
	b.eq	LBB435_13
; %bb.12:                               ; %B24
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB435_10
LBB435_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB435_15
; %bb.14:                               ; %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB435_15:                              ; %B13
	and	x8, x21, #0xffff000000000003
	mov	x11, #-281474976710653          ; =0xffff000000000003
	mov	x12, #2                         ; =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	mov	x13, #2                         ; =0x2
	ccmp	x8, x12, #4, ne
	movk	x13, #65535, lsl #48
	and	x9, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w10, eq
	cmp	x9, x13
	ccmp	x9, x12, #4, ne
	ccmp	x9, x11, #4, ne
	b.ne	LBB435_17
; %bb.16:                               ; %B13
	tbnz	w10, #0, LBB435_20
LBB435_17:                              ; %B16
	mov	x10, #-281474976710656          ; =0xffff000000000000
	cmp	x9, x10
	b.ne	LBB435_19
; %bb.18:                               ; %B16
	cmp	x8, x10
	b.eq	LBB435_22
LBB435_19:                              ; %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB435_20:                              ; %B33
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB435_24
; %bb.21:                               ; %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB435_22:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #8
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB435_25
; %bb.23:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB435_24:                              ; %B34
	b	_exception_spill_top1_asm_h
LBB435_25:                              ; %B8
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
; %bb.0:                                ; %B36
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB436_13
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB436_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB436_5
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB436_8
; %bb.4:                                ; %B32
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB436_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB436_13
; %bb.6:                                ; %B20
	cmp	x21, x8
	b.lo	LBB436_11
; %bb.7:                                ; %B25
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
LBB436_8:                               ; %B29
	tst	x21, #0xfffe000000000000
	b.eq	LBB436_13
; %bb.9:                                ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB436_10:                              ; %B31
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
LBB436_11:                              ; %B22
	tst	x21, #0xfffe000000000000
	b.eq	LBB436_13
; %bb.12:                               ; %B24
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB436_10
LBB436_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB436_15
; %bb.14:                               ; %B11
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB436_15:                              ; %B13
	and	x8, x21, #0xffff000000000003
	mov	x11, #-281474976710653          ; =0xffff000000000003
	mov	x12, #2                         ; =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	mov	x13, #2                         ; =0x2
	ccmp	x8, x12, #4, ne
	movk	x13, #65535, lsl #48
	and	x9, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w10, eq
	cmp	x9, x13
	ccmp	x9, x12, #4, ne
	ccmp	x9, x11, #4, ne
	b.ne	LBB436_17
; %bb.16:                               ; %B13
	tbnz	w10, #0, LBB436_20
LBB436_17:                              ; %B16
	mov	x10, #-281474976710656          ; =0xffff000000000000
	cmp	x9, x10
	b.ne	LBB436_19
; %bb.18:                               ; %B16
	cmp	x8, x10
	b.eq	LBB436_22
LBB436_19:                              ; %B18
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB436_20:                              ; %B33
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB436_24
; %bb.21:                               ; %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB436_22:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	sub	x20, x20, #8
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB436_25
; %bb.23:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB436_24:                              ; %B34
	b	_exception_spill_top1_asm_h
LBB436_25:                              ; %B8
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
	b.hi	LBB437_10
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB437_10
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB437_6
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB437_10
; %bb.4:                                ; %B24
	mov	w8, w22
LBB437_5:                               ; %B16
	ldrb	w9, [x19], #1
	sub	x20, x20, #8
	and	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB437_6:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB437_10
; %bb.7:                                ; %B4
	cmp	x21, x8
	b.lo	LBB437_10
; %bb.8:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB437_10
; %bb.9:                                ; %B15
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	LBB437_5
LBB437_10:                              ; %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        ; =0xad
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB437_12
; %bb.11:                               ; %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB437_12:                              ; %B26
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
	sub	x20, x20, #8
	eor	w8, w8, w21
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
	mov	w3, #174                        ; =0xae
	str	x21, [x8], #8
	str	x8, [x23, #64]
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
	sub	x20, x20, #8
	orr	w8, w8, w21
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
	mov	w3, #175                        ; =0xaf
	str	x21, [x8], #8
	str	x8, [x23, #64]
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
; %bb.0:                                ; %B0
	ldrb	w9, [x19, #1]
	ldr	x8, [x23, #120]
	ldrb	w10, [x19], #2
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	ldr	x21, [x8, x10, lsl #3]
	br	x1
                                        ; -- End function
	.private_extern	_fclosure8_1_asm_h      ; -- Begin function fclosure8_1_asm_h
	.globl	_fclosure8_1_asm_h
	.p2align	2
_fclosure8_1_asm_h:                     ; @fclosure8_1_asm_h
; %bb.0:                                ; %B1
	ldr	x8, [x23, #120]
	ldrb	w9, [x19]
	mov	x10, x20
	mov	x0, x24
	mov	x2, x26
	mov	x3, x23
	ldr	x1, [x8, x9, lsl #3]
	str	x22, [x10], #8
	str	x10, [x23, #64]
	bl	_js_closure_gc
	cmp	x0, #130
	b.eq	LBB453_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB453_2:                               ; %B2
	b	_exception_spill_top0_asm_h
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
	str	x8, [x23, #64]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB454_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB454_2:                               ; %B2
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
; %bb.0:                                ; %B24
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB494_10
; %bb.1:                                ; %B25
	mov	x9, x22
	mov	w8, #18                         ; =0x12
LBB494_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB494_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	mvn	w10, w10
	orr	w10, w10, #0xffffffcf
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, LBB494_5
LBB494_3:                               ; %B1
                                        ;   Parent Loop BB494_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, #48
	b.eq	LBB494_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB494_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB494_3
LBB494_5:                               ; %B14
                                        ;   in Loop: Header=BB494_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB494_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB494_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB494_2
	b	LBB494_9
LBB494_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB494_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB494_9:                               ; %B6
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB494_10:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #48                         ; =0x30
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB494_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB494_12:                              ; %B22
	b	_exception_spill_top0_asm_h
                                        ; -- End function
	.private_extern	_if_false8_1_asm_h      ; -- Begin function if_false8_1_asm_h
	.globl	_if_false8_1_asm_h
	.p2align	2
_if_false8_1_asm_h:                     ; @if_false8_1_asm_h
; %bb.0:                                ; %B23
	cmp	x22, #5
	b.le	LBB495_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB495_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB495_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB495_6
	b	LBB495_7
LBB495_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB495_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB495_7
LBB495_6:                               ; %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB495_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB495_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB495_10
LBB495_9:                               ; %B19
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB495_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB495_13
; %bb.11:                               ; %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB495_6
	b.vs	LBB495_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB495_9
	b	LBB495_6
LBB495_13:                              ; %B15
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
	b.le	LBB496_4
; %bb.1:                                ; %B23
	cmp	x22, #6
	b.eq	LBB496_6
; %bb.2:                                ; %B23
	cmp	x22, #7
	b.eq	LBB496_9
; %bb.3:                                ; %B23
	cmp	x22, #18
	b.eq	LBB496_6
	b	LBB496_7
LBB496_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.eq	LBB496_6
; %bb.5:                                ; %B23
	cmp	x22, #2
	b.ne	LBB496_7
LBB496_6:                               ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB496_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x22, x8
	b.hs	LBB496_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB496_10
LBB496_9:                               ; %B19
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB496_10:                              ; %B13
	tst	x22, #0xfffe000000000000
	b.eq	LBB496_13
; %bb.11:                               ; %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB496_6
	b.vs	LBB496_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB496_9
	b	LBB496_6
LBB496_13:                              ; %B15
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
	b.ne	LBB503_2
; %bb.1:                                ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB503_2:                               ; %B5
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
	b.ne	LBB504_2
; %bb.1:                                ; %B3
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB504_2:                               ; %B5
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
	b.ne	LBB505_2
; %bb.1:                                ; %B2
	mov	w22, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB505_2:                               ; %B5
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
	cbz	x8, LBB506_3
; %bb.1:                                ; %B7
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbnz	x8, LBB506_4
LBB506_2:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB506_3:                               ; %B11
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x23, #64]
	bl	_EnsureCoverageCounters
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbz	x8, LBB506_2
LBB506_4:                               ; %B2
	ldr	w9, [x19]
	ldr	w10, [x10, #104]
	cmp	w9, w10
	b.hs	LBB506_2
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
Lloh30:
	adrp	x1, l___unnamed_16@PAGE
Lloh31:
	add	x1, x1, l___unnamed_16@PAGEOFF
	ldr	x8, [x8, #32]
	ldr	x8, [x8, #8]
	str	x20, [x23, #64]
	mvn	x8, x8
	add	x8, x8, x19
	stp	x8, xzr, [sp, #-16]!
	bl	_LEPUS_ThrowInternalError
	add	sp, sp, #16
	b	_exception_asm_h
	.loh AdrpAdd	Lloh30, Lloh31
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
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #4]
	ldr	x9, [x23, #120]
	ldrsw	x10, [x19]
	add	x19, x19, #5
	add	w8, w8, #486
	ldr	x9, [x9, x10, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x9
	br	x1
                                        ; -- End function
	.private_extern	_fclosure_2_asm_h       ; -- Begin function fclosure_2_asm_h
	.globl	_fclosure_2_asm_h
	.p2align	2
_fclosure_2_asm_h:                      ; @fclosure_2_asm_h
; %bb.0:                                ; %B1
	str	x22, [x20]
	mov	x0, x24
	mov	x2, x26
	ldr	x8, [x23, #120]
	ldrsw	x9, [x19]
	mov	x3, x23
	ldr	x1, [x8, x9, lsl #3]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #64]
	bl	_js_closure_gc
	cmp	x0, #130
	b.eq	LBB510_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB510_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_push_atom_value_2_asm_h ; -- Begin function push_atom_value_2_asm_h
	.globl	_push_atom_value_2_asm_h
	.p2align	2
_push_atom_value_2_asm_h:               ; @push_atom_value_2_asm_h
; %bb.0:                                ; %B1
	str	x22, [x20]
	mov	x0, x24
	mov	w2, wzr
	ldr	w1, [x19]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #64]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB511_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB511_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	LBB512_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB512_2:                               ; %B2
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
	ldr	w8, [x23, #60]
	ldr	x1, [x23, #96]
	tbnz	w8, #0, LBB515_2
; %bb.1:                                ; %B12
	ldr	x8, [x23, #96]
	and	x9, x8, #0xfffffffffffffffe
	and	x9, x9, #0xffff000000000003
	cbnz	x9, LBB515_3
LBB515_2:                               ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x1
	add	w8, w8, #486
	ldr	x2, [x25, w8, uxtw #3]
	br	x2
LBB515_3:                               ; %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	LBB515_5
; %bb.4:                                ; %B7
	ldrb	w8, [x19], #1
	ldr	x9, [x24, #208]
	mov	x22, x21
	add	w8, w8, #486
	mov	x21, x9
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB515_5:                               ; %B9
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB515_7
; %bb.6:                                ; %B11
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB515_7:                               ; %B10
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
; %bb.0:                                ; %B1
	str	x22, [x20]
	mov	x0, x24
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #64]
	bl	_PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	LBB518_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB518_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_special_object_2_asm_h ; -- Begin function special_object_2_asm_h
	.globl	_special_object_2_asm_h
	.p2align	2
_special_object_2_asm_h:                ; @special_object_2_asm_h
; %bb.0:                                ; %B15
	str	x22, [x20], #8
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	LBB519_4
; %bb.1:                                ; %B15
	cbz	w8, LBB519_7
; %bb.2:                                ; %B15
	cmp	w8, #1
	b.ne	LBB519_12
; %bb.3:                                ; %B6
	ldr	x8, [x23, #8]
	ldr	w1, [x23, #128]
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
	bl	_js_build_mapped_arguments_gc
	b	LBB519_8
LBB519_4:                               ; %B15
	cmp	w8, #5
	b.eq	LBB519_10
; %bb.5:                                ; %B15
	cmp	w8, #4
	b.ne	LBB519_13
; %bb.6:                                ; %B9
	ldr	x8, [x23, #8]
	mov	w9, #18                         ; =0x12
	ldr	x8, [x8, #48]
	cmp	x8, #0
	csel	x8, x9, x8, eq
	b	LBB519_14
LBB519_7:                               ; %B1
	ldr	w1, [x23, #128]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x28
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_js_build_arguments_gc
LBB519_8:                               ; %B6
	cmp	x0, #130
	b.eq	LBB519_11
LBB519_9:
	mov	x8, x0
	b	LBB519_14
LBB519_10:                              ; %B12
	mov	x8, x20
	mov	x0, x24
	mov	w1, #2                          ; =0x2
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_NewObjectProto_GC
	cmp	x0, #130
	b.ne	LBB519_9
LBB519_11:                              ; %B13
	b	_exception_spill_top1_asm_h
LBB519_12:                              ; %B18
	ldr	x8, [x23, #8]
	b	LBB519_14
LBB519_13:                              ; %B19
	ldr	x8, [x23, #104]
LBB519_14:                              ; %B4
	ldrb	w9, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
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
	ldr	w2, [x23, #128]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #64]
	bl	_js_build_rest_gc
	cmp	x0, #130
	b.eq	LBB520_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB520_2:                               ; %B2
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
	b.eq	LBB549_3
; %bb.1:                                ; %B2
	cmp	x21, #18
	b.eq	LBB549_4
; %bb.2:                                ; %B3
	mov	x8, x20
Lloh32:
	adrp	x1, l___unnamed_17@PAGE
Lloh33:
	add	x1, x1, l___unnamed_17@PAGEOFF
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_LEPUS_ThrowTypeError
	b	_exception_spill_top1_asm_h
LBB549_3:                               ; %B6
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	w21, #6                         ; =0x6
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB549_4:                               ; %B4
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	w21, #7                         ; =0x7
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh32, Lloh33
                                        ; -- End function
	.private_extern	_check_ctor_2_asm_h     ; -- Begin function check_ctor_2_asm_h
	.globl	_check_ctor_2_asm_h
	.p2align	2
_check_ctor_2_asm_h:                    ; @check_ctor_2_asm_h
; %bb.0:                                ; %B2
	ldr	x8, [x23, #104]
	cmp	x8, #18
	b.ne	LBB550_2
; %bb.1:                                ; %B3
	add	x8, x20, #16
Lloh34:
	adrp	x1, l___unnamed_18@PAGE
Lloh35:
	add	x1, x1, l___unnamed_18@PAGEOFF
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_LEPUS_ThrowTypeError
	b	_exception_spill_top0_top1_asm_h
LBB550_2:                               ; %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh34, Lloh35
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
	str	x8, [x23, #64]
	bl	_JS_CheckBrand_GC
	tbnz	w0, #31, LBB551_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB551_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_AddBrand_GC
	tbnz	w0, #31, LBB552_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB552_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	LBB557_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB557_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	LBB558_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB558_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_GetPrototype_GC
	cmp	x0, #130
	b.eq	LBB559_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB559_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_js_dynamic_import
	cmp	x0, #130
	b.eq	LBB560_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB560_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_CheckGlobalVar_GC
	tbnz	w0, #31, LBB561_2
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
LBB561_2:                               ; %B2
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
	and	w11, w9, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, LBB562_3
LBB562_1:                               ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w11, #3
	sub	w12, w12, #8
	add	x12, x10, x12
	ldr	w13, [x12, #44]
	cmp	w13, w9
	b.eq	LBB562_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB562_1 Depth=1
	ldur	w11, [x12, #40]
	and	w11, w11, #0x3ffffff
	cbnz	w11, LBB562_1
LBB562_3:                               ; %B11
	ldr	x8, [x24, #208]
	mov	w10, #18                        ; =0x12
LBB562_4:                               ; %B33
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB562_5 Depth 2
	ldr	x12, [x8, #8]
	ldr	w11, [x12, #12]
	and	w11, w9, w11
	mvn	w11, w11
	ldr	w11, [x12, w11, sxtw #2]
	cbz	w11, LBB562_7
LBB562_5:                               ; %B22
                                        ;   Parent Loop BB562_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x12, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w9
	b.eq	LBB562_9
; %bb.6:                                ; %B24
                                        ;   in Loop: Header=BB562_5 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB562_5
LBB562_7:                               ; %B27
                                        ;   in Loop: Header=BB562_4 Depth=1
	ldr	w11, [x8, #4]
	ubfx	w11, w11, #10, #1
	cmp	w11, #1
	b.eq	LBB562_13
; %bb.8:                                ; %B30
                                        ;   in Loop: Header=BB562_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB562_4
	b	LBB562_11
LBB562_9:                               ; %B12
	lsr	w9, w13, #26
	tst	w9, #0x30
	b.ne	LBB562_13
LBB562_10:                              ; %B7.sink.split
	ldr	x8, [x8, #16]
	sub	w9, w11, #1
	ldr	x10, [x8, w9, sxtw #3]
LBB562_11:                              ; %B7
	cmp	x10, #34
	b.eq	LBB562_15
; %bb.12:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x10
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB562_13:                              ; %B17
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB562_16
; %bb.14:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB562_15:                              ; %B3
	str	x21, [x20], #8
	b	_ThrowReferenceErrorUninitialized_asm_h
LBB562_16:                              ; %B18
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
	ldr	x11, [x8, #8]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, LBB563_3
LBB563_1:                               ; %B5
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #44]
	cmp	w13, w9
	b.eq	LBB563_10
; %bb.2:                                ; %B8
                                        ;   in Loop: Header=BB563_1 Depth=1
	ldur	w10, [x12, #40]
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB563_1
LBB563_3:                               ; %B11
	ldr	x8, [x24, #208]
LBB563_4:                               ; %B32
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB563_5 Depth 2
	ldr	x11, [x8, #8]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, LBB563_7
LBB563_5:                               ; %B21
                                        ;   Parent Loop BB563_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w9
	b.eq	LBB563_9
; %bb.6:                                ; %B23
                                        ;   in Loop: Header=BB563_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB563_5
LBB563_7:                               ; %B26
                                        ;   in Loop: Header=BB563_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB563_12
; %bb.8:                                ; %B29
                                        ;   in Loop: Header=BB563_4 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB563_4
	b	LBB563_12
LBB563_9:                               ; %B12
	lsr	w9, w12, #26
	tst	w9, #0x30
	b.ne	LBB563_12
LBB563_10:                              ; %B7
	ldr	x8, [x8, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
	cmp	x8, #34
	b.eq	LBB563_14
; %bb.11:                               ; %B4
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB563_12:                              ; %B16
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          ; =0x1
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.eq	LBB563_15
; %bb.13:                               ; %B18
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB563_14:                              ; %B3
	str	x21, [x20], #8
	b	_ThrowReferenceErrorUninitialized_asm_h
LBB563_15:                              ; %B17
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
	str	x8, [x23, #64]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB564_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB564_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB565_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB565_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_put_var_strict_2_asm_h ; -- Begin function put_var_strict_2_asm_h
	.globl	_put_var_strict_2_asm_h
	.p2align	2
_put_var_strict_2_asm_h:                ; @put_var_strict_2_asm_h
; %bb.0:                                ; %B5
	cmp	x22, #7
	b.ne	LBB566_3
; %bb.1:                                ; %B1
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          ; =0x2
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_SetGlobalVar_GC
	tbnz	w0, #31, LBB566_4
; %bb.2:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB566_3:                               ; %B6
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB566_4:                               ; %B2
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
	str	x8, [x23, #64]
	b.eq	LBB567_3
; %bb.1:                                ; %B1
	mov	x1, x22
	mov	x2, x21
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB567_5
; %bb.2:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB567_3:                               ; %B5
	mov	x1, x21
	bl	_js_value_to_atom_gc
	cbz	w0, LBB567_5
; %bb.4:                                ; %B7
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB567_5:                               ; %B6
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
	b.eq	LBB568_3
LBB568_1:                               ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_SetPropertyValue_GC
	tbnz	w0, #31, LBB568_7
; %bb.2:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB568_3:                               ; %B8
	ldr	w8, [x23, #60]
	tbnz	w8, #0, LBB568_5
; %bb.4:                                ; %B9
	ldr	x1, [x24, #208]
	b	LBB568_1
LBB568_5:                               ; %B5
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	stp	x22, x21, [x20]
	str	x8, [sp, #8]                    ; 8-byte Folded Spill
	str	x8, [x23, #64]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB568_7
; %bb.6:                                ; %B7
	ldr	x8, [sp, #8]                    ; 8-byte Folded Reload
	mov	w1, w0
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_ThrowReferenceErrorNotDefined_GC
LBB568_7:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_DefineGlobalVar_GC
	tbnz	w0, #31, LBB569_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB569_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, LBB570_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB570_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_DefineGlobalFunction_GC
	tbnz	w0, #31, LBB571_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB571_2:                               ; %B2
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
	b.ne	LBB572_10
; %bb.1:                                ; %B25
	mov	x9, x21
	mov	w8, #18                         ; =0x12
LBB572_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB572_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, LBB572_5
LBB572_3:                               ; %B1
                                        ;   Parent Loop BB572_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w2
	b.eq	LBB572_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB572_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB572_3
LBB572_5:                               ; %B14
                                        ;   in Loop: Header=BB572_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB572_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB572_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB572_2
	b	LBB572_9
LBB572_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB572_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB572_9:                               ; %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB572_10:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x3, x21
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB572_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB572_12:                              ; %B22
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
	b.ne	LBB573_10
; %bb.1:                                ; %B25
	mov	x9, x21
	mov	w8, #18                         ; =0x12
LBB573_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB573_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, LBB573_5
LBB573_3:                               ; %B1
                                        ;   Parent Loop BB573_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w2
	b.eq	LBB573_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB573_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB573_3
LBB573_5:                               ; %B14
                                        ;   in Loop: Header=BB573_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB573_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB573_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB573_2
	b	LBB573_9
LBB573_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB573_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB573_9:                               ; %B6
	ldrb	w9, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB573_10:                              ; %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	mov	x3, x21
	mov	w4, wzr
	str	x21, [x8], #8
	str	x8, [x23, #64]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB573_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB573_12:                              ; %B22
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_put_field_2_asm_h      ; -- Begin function put_field_2_asm_h
	.globl	_put_field_2_asm_h
	.p2align	2
_put_field_2_asm_h:                     ; @put_field_2_asm_h
; %bb.0:                                ; %B44
	mov	x8, #2                          ; =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB574_17
; %bb.1:                                ; %B45
	ldr	x9, [x22, #8]
	ldr	w8, [x9, #12]
	and	w8, w2, w8
	mvn	w8, w8
	ldr	w8, [x9, w8, sxtw #2]
	cbz	w8, LBB574_4
LBB574_2:                               ; %B1
                                        ; =>This Inner Loop Header: Depth=1
	lsl	w10, w8, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldp	w10, w11, [x10, #40]
	cmp	w11, w2
	b.eq	LBB574_13
; %bb.3:                                ; %B12
                                        ;   in Loop: Header=BB574_2 Depth=1
	and	w8, w10, #0x3ffffff
	cbnz	w8, LBB574_2
LBB574_4:                               ; %B17.preheader
	mov	x8, x22
LBB574_5:                               ; %B17
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB574_6 Depth 2
	ldr	x9, [x8, #8]
	ldr	w10, [x9, #12]
	and	w10, w2, w10
	mvn	w10, w10
	ldr	w10, [x9, w10, sxtw #2]
	cbz	w10, LBB574_8
LBB574_6:                               ; %B18
                                        ;   Parent Loop BB574_5 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w10, w10, #3
	sub	w10, w10, #8
	add	x10, x9, x10
	ldr	w11, [x10, #44]
	cmp	w11, w2
	b.eq	LBB574_17
; %bb.7:                                ; %B20
                                        ;   in Loop: Header=BB574_6 Depth=2
	ldur	w10, [x10, #40]
	and	w10, w10, #0x3ffffff
	cbnz	w10, LBB574_6
LBB574_8:                               ; %B30
                                        ;   in Loop: Header=BB574_5 Depth=1
	ldr	w9, [x8, #4]
	ubfx	w9, w9, #10, #1
	cmp	w9, #1
	b.eq	LBB574_17
; %bb.9:                                ; %B24
                                        ;   in Loop: Header=BB574_5 Depth=1
	ldr	x8, [x8, #8]
	ldr	x8, [x8, #32]
	cbnz	x8, LBB574_5
; %bb.10:                               ; %B27
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	LBB574_17
; %bb.11:                               ; %B34
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	w3, #7                          ; =0x7
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_add_property_gc
	cbz	x0, LBB574_19
; %bb.12:                               ; %B38
	str	x21, [x0]
	b	LBB574_15
LBB574_13:                              ; %B3
	mov	w9, #58                         ; =0x3a
	and	w9, w9, w10, lsr #26
	cmp	w9, #2
	b.ne	LBB574_17
; %bb.14:                               ; %B7
	ldr	x9, [x22, #16]
	sub	w8, w8, #1
	str	x21, [x9, w8, sxtw #3]
LBB574_15:                              ; %B38
	ldrb	w8, [x24, #384]
	cbz	w8, LBB574_18
; %bb.16:                               ; %B40
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB574_17:                              ; %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #32768                      ; =0x8000
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_SetPropertyInternalImpl_GC
	tbnz	w0, #31, LBB574_19
LBB574_18:                              ; %B37
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB574_19:                              ; %B35
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
	str	x8, [x23, #64]
	bl	_JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	LBB575_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB575_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_SetPrivateField_GC
	tbnz	w0, #31, LBB576_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB576_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_DefinePrivateField_GC
	tbnz	w0, #31, LBB577_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB577_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_get_array_el_2_asm_h   ; -- Begin function get_array_el_2_asm_h
	.globl	_get_array_el_2_asm_h
	.p2align	2
_get_array_el_2_asm_h:                  ; @get_array_el_2_asm_h
; %bb.0:                                ; %B33
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB578_15
; %bb.1:                                ; %B33
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x8, x9
	b.ne	LBB578_15
; %bb.2:                                ; %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	LBB578_15
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB578_5
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	add	w8, w8, #243
	ldr	x22, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB578_5:                               ; %B7
	tbnz	w21, #31, LBB578_15
; %bb.6:                                ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
	orr	w12, w21, #0x80000000
LBB578_7:                               ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB578_8 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	and	w11, w12, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, LBB578_10
LBB578_8:                               ; %B10
                                        ;   Parent Loop BB578_7 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x10, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w12
	b.eq	LBB578_12
; %bb.9:                                ; %B17
                                        ;   in Loop: Header=BB578_8 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB578_8
LBB578_10:                              ; %B24
                                        ;   in Loop: Header=BB578_7 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB578_15
; %bb.11:                               ; %B21
                                        ;   in Loop: Header=BB578_7 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB578_7
	b	LBB578_14
LBB578_12:                              ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB578_15
; %bb.13:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB578_14:                              ; %B14
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB578_15:                              ; %B30
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB578_17
; %bb.16:                               ; %B32
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB578_17:                              ; %B31
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_get_array_el2_2_asm_h  ; -- Begin function get_array_el2_2_asm_h
	.globl	_get_array_el2_2_asm_h
	.p2align	2
_get_array_el2_2_asm_h:                 ; @get_array_el2_2_asm_h
; %bb.0:                                ; %B33
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	LBB579_15
; %bb.1:                                ; %B33
	and	x8, x21, #0xffff000000000000
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x8, x9
	b.ne	LBB579_15
; %bb.2:                                ; %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	LBB579_15
; %bb.3:                                ; %B3
	ldr	w8, [x22, #48]
	cmp	w21, w8
	b.hs	LBB579_5
; %bb.4:                                ; %B4
	ldrb	w8, [x19], #1
	ldr	x9, [x22, #40]
	add	w8, w8, #486
	ldr	x21, [x9, w21, sxtw #3]
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB579_5:                               ; %B7
	tbnz	w21, #31, LBB579_15
; %bb.6:                                ; %B9.preheader
	mov	x9, x22
	mov	w8, #18                         ; =0x12
	orr	w12, w21, #0x80000000
LBB579_7:                               ; %B9
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB579_8 Depth 2
	ldr	x10, [x9, #8]
	ldr	w11, [x10, #12]
	and	w11, w12, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, LBB579_10
LBB579_8:                               ; %B10
                                        ;   Parent Loop BB579_7 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x10, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w12
	b.eq	LBB579_12
; %bb.9:                                ; %B17
                                        ;   in Loop: Header=BB579_8 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, LBB579_8
LBB579_10:                              ; %B24
                                        ;   in Loop: Header=BB579_7 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB579_15
; %bb.11:                               ; %B21
                                        ;   in Loop: Header=BB579_7 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB579_7
	b	LBB579_14
LBB579_12:                              ; %B12
	lsr	w8, w13, #26
	tst	w8, #0x30
	b.ne	LBB579_15
; %bb.13:                               ; %B13
	ldr	x8, [x9, #16]
	sub	w9, w11, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB579_14:                              ; %B14
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB579_15:                              ; %B30
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	LBB579_17
; %bb.16:                               ; %B32
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB579_17:                              ; %B31
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_put_array_el_2_asm_h   ; -- Begin function put_array_el_2_asm_h
	.globl	_put_array_el_2_asm_h
	.p2align	2
_put_array_el_2_asm_h:                  ; @put_array_el_2_asm_h
; %bb.0:                                ; %B63
	ldur	x1, [x20, #-8]
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x1, x8
	b.ne	LBB580_16
; %bb.1:                                ; %B57
	ldrsh	w8, [x1, #6]
	cmp	w8, #2
	b.ne	LBB580_6
; %bb.2:                                ; %B1
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	LBB580_16
; %bb.3:                                ; %B50
	ldr	w8, [x1, #48]
	cmp	w22, w8
	b.hs	LBB580_7
; %bb.4:                                ; %B3
	ldr	x8, [x1, #40]
	str	x21, [x8, w22, sxtw #3]
	ldrb	w8, [x24, #384]
	cbnz	w8, LBB580_23
LBB580_5:                               ; %B56
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB580_6:                               ; %B60
	cmp	w8, #30
	ccmp	w8, #20, #4, lt
	mov	w8, #32768                      ; =0x8000
	csel	w4, wzr, w8, gt
	b	LBB580_17
LBB580_7:                               ; %B8
	b.ne	LBB580_16
; %bb.8:                                ; %B46
	ldr	w9, [x1, #4]
	mov	w4, #32768                      ; =0x8000
	ubfx	w10, w9, #11, #1
	cmp	w10, #1
	b.ne	LBB580_17
; %bb.9:                                ; %B46
	ubfx	w9, w9, #8, #1
	cbz	w9, LBB580_17
; %bb.10:                               ; %B47
	ldr	x9, [x1, #8]
LBB580_11:                              ; %B15
                                        ; =>This Inner Loop Header: Depth=1
	ldr	x10, [x9, #32]
	cbz	x10, LBB580_19
; %bb.12:                               ; %B10
                                        ;   in Loop: Header=BB580_11 Depth=1
	ldrh	w11, [x10, #6]
	ldr	x9, [x10, #8]
	cmp	w11, #2
	b.ne	LBB580_14
; %bb.13:                               ; %B12
                                        ;   in Loop: Header=BB580_11 Depth=1
	ldr	w10, [x10, #4]
	ubfx	w10, w10, #11, #1
	cmp	w10, #1
	b.eq	LBB580_11
	b	LBB580_16
LBB580_14:                              ; %B10
                                        ;   in Loop: Header=BB580_11 Depth=1
	cmp	w11, #1
	b.ne	LBB580_16
; %bb.15:                               ; %B42
                                        ;   in Loop: Header=BB580_11 Depth=1
	ldrb	w10, [x9, #6]
	cbz	w10, LBB580_11
LBB580_16:
	mov	w4, #32768                      ; =0x8000
LBB580_17:                              ; %B54
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_SetPropertyValue_GC
	tbz	w0, #31, LBB580_5
; %bb.18:                               ; %B55
	b	_exception_spill_top0_top1_asm_h
LBB580_19:                              ; %B33
	ldr	x9, [x1, #16]
	ldr	x10, [x9]
	mov	w9, #65534                      ; =0xfffe
	cmp	x9, x10, lsr #48
	add	w9, w8, #1
	b.ne	LBB580_21
; %bb.20:                               ; %B33
	cmp	w9, w10
	b.hi	LBB580_24
LBB580_21:                              ; %B30
	ldr	w10, [x1, #32]
	cmp	w9, w10
	b.hi	LBB580_24
; %bb.22:                               ; %B26
	ldr	x10, [x1, #40]
	str	w9, [x1, #48]
	str	x21, [x10, w8, sxtw #3]
	ldrb	w8, [x24, #384]
	cbz	w8, LBB580_5
LBB580_23:                              ; %B29
	mov	x0, x21
	mov	x1, x24
	bl	_prim_WriteBarrierNoStore
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x1, [x25, x8, lsl #3]
	br	x1
LBB580_24:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, #32768                      ; =0x8000
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_add_fast_array_element_gc
	tbz	w0, #31, LBB580_5
; %bb.25:                               ; %B22
	b	_exception_spill_top0_top1_asm_h
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
	str	x19, [x23, #64]
	bl	_js_value_to_atom_gc
	cbz	w0, LBB581_3
; %bb.1:                                ; %B5
	ldur	x3, [x20, #-8]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x19, [x23, #64]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB581_3
; %bb.2:                                ; %B7
	ldr	x19, [sp, #8]                   ; 8-byte Folded Reload
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x1
LBB581_3:                               ; %B2
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
; %bb.0:                                ; %B1
	ldr	w2, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #16391                      ; =0x4007
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_DefinePropertyValue_GC
	tbnz	w0, #31, LBB583_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB583_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
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
	str	x8, [x23, #64]
	bl	_JS_DefineObjectName
	tbnz	w0, #31, LBB584_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB584_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, LBB585_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB585_2:                               ; %B2
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
	b.eq	LBB586_3
; %bb.1:                                ; %B6
	cmp	x21, #2
	b.eq	LBB586_3
LBB586_2:                               ; %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB586_3:                               ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_SetPrototypeInternal_GC
	tbz	w0, #31, LBB586_2
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
	str	x8, [x23, #64]
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
	str	x8, [x23, #64]
	bl	_JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, LBB588_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB588_2:                               ; %B2
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	b.eq	LBB604_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB604_2:                               ; %B3
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
	b.eq	LBB605_2
; %bb.1:                                ; %B4
	str	x21, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB605_2:                               ; %B3
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
	b.ne	LBB606_2
; %bb.1:                                ; %B4
	str	x21, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB606_2:                               ; %B3
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
	ldr	x8, [x8, #32]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	LBB607_2
; %bb.1:                                ; %B4
	ldrb	w9, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB607_2:                               ; %B3
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
	ldr	x8, [x8, #32]
	ldr	x9, [x8]
	cmp	x9, #34
	b.eq	LBB608_2
; %bb.1:                                ; %B4
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB608_2:                               ; %B3
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
	ldr	x8, [x8, #32]
	ldr	x9, [x8]
	cmp	x9, #34
	b.ne	LBB609_2
; %bb.1:                                ; %B4
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB609_2:                               ; %B3
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
	b.le	LBB611_4
; %bb.1:                                ; %B23
	cmp	x21, #6
	b.eq	LBB611_6
; %bb.2:                                ; %B23
	cmp	x21, #7
	b.eq	LBB611_9
; %bb.3:                                ; %B23
	cmp	x21, #18
	b.eq	LBB611_6
	b	LBB611_7
LBB611_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB611_6
; %bb.5:                                ; %B23
	cmp	x21, #2
	b.ne	LBB611_7
LBB611_6:                               ; %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB611_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x21, x8
	b.hs	LBB611_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB611_10
LBB611_9:                               ; %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB611_10:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB611_13
; %bb.11:                               ; %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB611_6
	b.vs	LBB611_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB611_9
	b	LBB611_6
LBB611_13:                              ; %B15
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
	b.le	LBB612_4
; %bb.1:                                ; %B23
	cmp	x21, #6
	b.eq	LBB612_6
; %bb.2:                                ; %B23
	cmp	x21, #7
	b.eq	LBB612_9
; %bb.3:                                ; %B23
	cmp	x21, #18
	b.eq	LBB612_6
	b	LBB612_7
LBB612_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB612_6
; %bb.5:                                ; %B23
	cmp	x21, #2
	b.ne	LBB612_7
LBB612_6:                               ; %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB612_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x21, x8
	b.hs	LBB612_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB612_10
LBB612_9:                               ; %B19
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB612_10:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB612_13
; %bb.11:                               ; %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB612_6
	b.vs	LBB612_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB612_9
	b	LBB612_6
LBB612_13:                              ; %B15
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
	b.ne	LBB616_3
; %bb.1:                                ; %B1
	ldr	x8, [x23, #8]
	ldr	x8, [x8, #32]
	ldr	w9, [x8, #16]
	cmp	w21, w9
	b.ge	LBB616_3
; %bb.2:                                ; %B5
	ldr	x8, [x8, #8]
	add	x19, x8, w21, sxtw
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB616_3:                               ; %B3
	add	x8, x20, #16
Lloh36:
	adrp	x1, l___unnamed_19@PAGE
Lloh37:
	add	x1, x1, l___unnamed_19@PAGEOFF
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_LEPUS_ThrowInternalError
	b	_exception_spill_top0_top1_asm_h
	.loh AdrpAdd	Lloh36, Lloh37
                                        ; -- End function
	.private_extern	_to_object_2_asm_h      ; -- Begin function to_object_2_asm_h
	.globl	_to_object_2_asm_h
	.p2align	2
_to_object_2_asm_h:                     ; @to_object_2_asm_h
; %bb.0:                                ; %B6
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	LBB617_2
; %bb.1:                                ; %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB617_2:                               ; %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_ToObject_GC
	cmp	x0, #130
	b.eq	LBB617_4
; %bb.3:                                ; %B3
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB617_4:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_to_propkey_2_asm_h     ; -- Begin function to_propkey_2_asm_h
	.globl	_to_propkey_2_asm_h
	.p2align	2
_to_propkey_2_asm_h:                    ; @to_propkey_2_asm_h
; %bb.0:                                ; %B15
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	LBB618_4
; %bb.1:                                ; %B15
	mov	x9, #1                          ; =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB618_4
; %bb.2:                                ; %B15
	cmp	x8, x9
	b.eq	LBB618_4
; %bb.3:                                ; %B15
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB618_5
LBB618_4:                               ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB618_5:                               ; %B12
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB618_7
; %bb.6:                                ; %B14
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB618_7:                               ; %B13
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_to_propkey2_2_asm_h    ; -- Begin function to_propkey2_2_asm_h
	.globl	_to_propkey2_2_asm_h
	.p2align	2
_to_propkey2_2_asm_h:                   ; @to_propkey2_2_asm_h
; %bb.0:                                ; %B18
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	LBB619_3
; %bb.1:                                ; %B19
	add	x8, x20, #16
Lloh38:
	adrp	x1, l___unnamed_20@PAGE
Lloh39:
	add	x1, x1, l___unnamed_20@PAGEOFF
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_LEPUS_ThrowTypeError
LBB619_2:                               ; %B16
	b	_exception_spill_top0_top1_asm_h
LBB619_3:                               ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	LBB619_7
; %bb.4:                                ; %B2
	mov	x9, #1                          ; =0x1
	and	x8, x21, #0xffff000000000003
	movk	x9, #1, lsl #48
	add	x10, x9, #1
	cmp	x8, x10
	b.eq	LBB619_7
; %bb.5:                                ; %B2
	cmp	x8, x9
	b.eq	LBB619_7
; %bb.6:                                ; %B2
	mov	x9, #-281474976710653           ; =0xffff000000000003
	cmp	x8, x9
	b.ne	LBB619_8
LBB619_7:                               ; %B4
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB619_8:                               ; %B15
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_ToPropertyKey_GC
	cmp	x0, #130
	b.eq	LBB619_2
; %bb.9:                                ; %B17
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
	.loh AdrpAdd	Lloh38, Lloh39
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
	str	x8, [x23, #64]
	bl	_prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	LBB630_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB630_2:                               ; %B2
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
	b.hi	LBB647_3
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB647_6
; %bb.2:                                ; %B13
	orr	w8, w21, #0x80000000
	mov	w9, #-2147483648                ; =0x80000000
	cmp	w8, w9
	b.ne	LBB647_5
LBB647_3:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #140                        ; =0x8c
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB647_8
; %bb.4:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB647_5:                               ; %B15
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	neg	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x1
LBB647_6:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB647_3
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
LBB647_8:                               ; %B17
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_plus_2_asm_h           ; -- Begin function plus_2_asm_h
	.globl	_plus_2_asm_h
	.p2align	2
_plus_2_asm_h:                          ; @plus_2_asm_h
; %bb.0:                                ; %B13
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	LBB648_4
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB648_3
LBB648_2:                               ; %B7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB648_3:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.ne	LBB648_2
LBB648_4:                               ; %B10
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #141                        ; =0x8d
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB648_6
; %bb.5:                                ; %B12
	mov	x21, x0
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB648_6:                               ; %B11
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_dec_2_asm_h            ; -- Begin function dec_2_asm_h
	.globl	_dec_2_asm_h
	.p2align	2
_dec_2_asm_h:                           ; @dec_2_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	LBB649_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB649_4
; %bb.2:                                ; %B13
	subs	w8, w21, #1
	b.vs	LBB649_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB649_4:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB649_6
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
LBB649_6:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #142                        ; =0x8e
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB649_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB649_8:                               ; %B17
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_inc_2_asm_h            ; -- Begin function inc_2_asm_h
	.globl	_inc_2_asm_h
	.p2align	2
_inc_2_asm_h:                           ; @inc_2_asm_h
; %bb.0:                                ; %B19
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	LBB650_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB650_4
; %bb.2:                                ; %B13
	adds	w8, w21, #1
	b.vs	LBB650_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB650_4:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB650_6
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
LBB650_6:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #143                        ; =0x8f
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB650_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB650_8:                               ; %B17
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
	b.hs	LBB651_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB651_4
; %bb.2:                                ; %B13
	subs	w8, w21, #1
	b.vs	LBB651_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	mov	x22, x21
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB651_4:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB651_6
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
LBB651_6:                               ; %B5
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
	b.hs	LBB652_6
; %bb.1:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB652_4
; %bb.2:                                ; %B13
	adds	w8, w21, #1
	b.vs	LBB652_6
; %bb.3:                                ; %B15
	ldrb	w9, [x19], #1
	mov	x22, x21
	orr	x21, x8, #0xfffe000000000000
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB652_4:                               ; %B3
	tst	x21, #0xfffe000000000000
	b.eq	LBB652_6
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
LBB652_6:                               ; %B5
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
	b.hi	LBB653_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB653_4
; %bb.2:                                ; %B13
	subs	w9, w1, #1
	b.vs	LBB653_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB653_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB653_6
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
LBB653_6:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #142                        ; =0x8e
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB653_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB653_8:                               ; %B17
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
	b.hi	LBB654_6
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB654_4
; %bb.2:                                ; %B13
	adds	w9, w1, #1
	b.vs	LBB654_6
; %bb.3:                                ; %B15
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB654_4:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB654_6
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
LBB654_6:                               ; %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #143                        ; =0x8f
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB654_8
; %bb.7:                                ; %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB654_8:                               ; %B17
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_add_loc_2_asm_h        ; -- Begin function add_loc_2_asm_h
	.globl	_add_loc_2_asm_h
	.p2align	2
_add_loc_2_asm_h:                       ; @add_loc_2_asm_h
; %bb.0:                                ; %B45
	ldrb	w8, [x19]
	mov	x9, #-281474976710657           ; =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x9
	ccmp	x21, x9, #2, ls
	b.hi	LBB655_14
; %bb.1:                                ; %B2
	mov	x9, #-562949953421312           ; =0xfffe000000000000
	cmp	x1, x9
	b.lo	LBB655_5
; %bb.2:                                ; %B26
	cmp	x21, x9
	b.lo	LBB655_8
; %bb.3:                                ; %B36
	adds	w9, w1, w21
	b.vs	LBB655_14
; %bb.4:                                ; %B38
	orr	x9, x9, #0xfffe000000000000
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB655_5:                               ; %B4
	tst	x1, #0xfffe000000000000
	b.eq	LBB655_14
; %bb.6:                                ; %B11
	cmp	x21, x9
	b.lo	LBB655_12
; %bb.7:                                ; %B21
	scvtf	d0, w21
	add	x9, x1, x9
	fmov	d1, x9
	fadd	d0, d1, d0
	b	LBB655_11
LBB655_8:                               ; %B28
	tst	x21, #0xfffe000000000000
	b.eq	LBB655_14
; %bb.9:                                ; %B31
	scvtf	d0, w1
	add	x9, x21, x9
LBB655_10:                              ; %B31
	fmov	d1, x9
	fadd	d0, d0, d1
LBB655_11:                              ; %B31
	fmov	x9, d0
	fcmp	d0, d0
	mov	x10, #562949953421312           ; =0x2000000000000
	add	x9, x9, x10
	mov	x10, #9221683186994511872       ; =0x7ffa000000000000
	csel	x9, x9, x10, vc
	str	x9, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB655_12:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB655_14
; %bb.13:                               ; %B16
	add	x10, x1, x9
	add	x9, x21, x9
	fmov	d0, x10
	b	LBB655_10
LBB655_14:                              ; %B7
	mov	x8, #2                          ; =0x2
	and	x9, x1, #0xffff000000000003
	add	x10, x20, #16
	movk	x8, #1, lsl #48
	stp	x22, x21, [x20]
	cmp	x9, x8
	str	x10, [x23, #64]
	b.ne	LBB655_17
; %bb.15:                               ; %B7
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.ne	LBB655_17
; %bb.16:                               ; %B39
	mov	x0, x24
	mov	x2, x21
	bl	_JS_ConcatString_GC
	b	LBB655_18
LBB655_17:                              ; %B42
	mov	x0, x24
	mov	x2, x21
	bl	_prim_js_add_slow_gc
LBB655_18:                              ; %B42
	cmp	x0, #130
	b.eq	LBB655_20
; %bb.19:                               ; %B44
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB655_20:                              ; %B43
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_not_2_asm_h            ; -- Begin function not_2_asm_h
	.globl	_not_2_asm_h
	.p2align	2
_not_2_asm_h:                           ; @not_2_asm_h
; %bb.0:                                ; %B2
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	LBB656_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	mvn	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x1
LBB656_2:                               ; %B4
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
	b.le	LBB657_4
; %bb.1:                                ; %B14
	cmp	x21, #6
	b.eq	LBB657_6
; %bb.2:                                ; %B14
	cmp	x21, #7
	b.eq	LBB657_8
; %bb.3:                                ; %B14
	cmp	x21, #18
	b.eq	LBB657_6
	b	LBB657_7
LBB657_4:                               ; %B14
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB657_6
; %bb.5:                                ; %B14
	cmp	x21, #2
	b.ne	LBB657_7
LBB657_6:                               ; %B3
	mov	w21, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB657_7:                               ; %B10
	mov	w8, #65534                      ; =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	LBB657_9
LBB657_8:                               ; %B12
	mov	w21, #6                         ; =0x6
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB657_9:                               ; %B13
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
	str	x8, [x23, #64]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB658_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB658_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	LBB659_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB659_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_JS_DeleteProperty_GC
	tbnz	w0, #31, LBB660_2
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
LBB660_2:                               ; %B2
	b	_exception_spill_top1_asm_h
                                        ; -- End function
	.private_extern	_mul_2_asm_h            ; -- Begin function mul_2_asm_h
	.globl	_mul_2_asm_h
	.p2align	2
_mul_2_asm_h:                           ; @mul_2_asm_h
; %bb.0:                                ; %B47
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB661_18
; %bb.1:                                ; %B47
	cmp	x21, x8
	b.hi	LBB661_18
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB661_8
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB661_11
; %bb.4:                                ; %B33
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	LBB661_18
; %bb.5:                                ; %B36
	cbnz	w8, LBB661_7
; %bb.6:                                ; %B36
	orr	w9, w22, w21
	tbnz	w9, #31, LBB661_15
LBB661_7:                               ; %B43
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB661_8:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB661_18
; %bb.9:                                ; %B7
	cmp	x21, x8
	b.lo	LBB661_16
; %bb.10:                               ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	LBB661_14
LBB661_11:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB661_18
; %bb.12:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB661_13:                              ; %B28
	fmov	d1, x8
	fmul	d0, d0, d1
LBB661_14:                              ; %B28
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
LBB661_15:                              ; %B40
	mov	x22, #-9222809086901354496      ; =0x8002000000000000
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB661_16:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB661_18
; %bb.17:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB661_13
LBB661_18:                              ; %B44
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        ; =0x9a
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB661_20
; %bb.19:                               ; %B46
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB661_20:                              ; %B45
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_div_2_asm_h            ; -- Begin function div_2_asm_h
	.globl	_div_2_asm_h
	.p2align	2
_div_2_asm_h:                           ; @div_2_asm_h
; %bb.0:                                ; %B44
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB662_14
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB662_14
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB662_5
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB662_8
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
LBB662_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB662_14
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB662_12
; %bb.7:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	LBB662_11
LBB662_8:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB662_14
; %bb.9:                                ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB662_10:                              ; %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
LBB662_11:                              ; %B28
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
LBB662_12:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB662_14
; %bb.13:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB662_10
LBB662_14:                              ; %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        ; =0x9b
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB662_16
; %bb.15:                               ; %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB662_16:                              ; %B42
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_mod_2_asm_h            ; -- Begin function mod_2_asm_h
	.globl	_mod_2_asm_h
	.p2align	2
_mod_2_asm_h:                           ; @mod_2_asm_h
; %bb.0:                                ; %B39
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB663_16
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB663_16
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB663_7
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB663_10
; %bb.4:                                ; %B33
	tbnz	w22, #31, LBB663_16
; %bb.5:                                ; %B33
	cmp	w21, #1
	b.lt	LBB663_16
; %bb.6:                                ; %B35
	sdiv	w8, w22, w21
	ldrb	w9, [x19], #1
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x1
LBB663_7:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB663_16
; %bb.8:                                ; %B7
	cmp	x21, x8
	b.lo	LBB663_14
; %bb.9:                                ; %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	LBB663_13
LBB663_10:                              ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB663_16
; %bb.11:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB663_12:                              ; %B28
	fmov	d1, x8
LBB663_13:                              ; %B28
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
LBB663_14:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB663_16
; %bb.15:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB663_12
LBB663_16:                              ; %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        ; =0x9c
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB663_18
; %bb.17:                               ; %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB663_18:                              ; %B37
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_add_2_asm_h            ; -- Begin function add_2_asm_h
	.globl	_add_2_asm_h
	.p2align	2
_add_2_asm_h:                           ; @add_2_asm_h
; %bb.0:                                ; %B45
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB664_15
; %bb.1:                                ; %B45
	cmp	x21, x8
	b.hi	LBB664_15
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB664_6
; %bb.3:                                ; %B26
	cmp	x21, x8
	b.lo	LBB664_9
; %bb.4:                                ; %B36
	adds	w8, w22, w21
	b.vs	LBB664_15
; %bb.5:                                ; %B38
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB664_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB664_15
; %bb.7:                                ; %B10
	cmp	x21, x8
	b.lo	LBB664_13
; %bb.8:                                ; %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	LBB664_12
LBB664_9:                               ; %B28
	tst	x21, #0xfffe000000000000
	b.eq	LBB664_15
; %bb.10:                               ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB664_11:                              ; %B31
	fmov	d1, x8
	fadd	d0, d0, d1
LBB664_12:                              ; %B31
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
LBB664_13:                              ; %B12
	tst	x21, #0xfffe000000000000
	b.eq	LBB664_15
; %bb.14:                               ; %B15
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB664_11
LBB664_15:                              ; %B6
	mov	x8, #2                          ; =0x2
	and	x9, x22, #0xffff000000000003
	add	x10, x20, #16
	movk	x8, #1, lsl #48
	stp	x22, x21, [x20]
	cmp	x9, x8
	str	x10, [x23, #64]
	b.ne	LBB664_18
; %bb.16:                               ; %B6
	and	x9, x21, #0xffff000000000003
	cmp	x9, x8
	b.ne	LBB664_18
; %bb.17:                               ; %B39
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	_JS_ConcatString_GC
	b	LBB664_19
LBB664_18:                              ; %B42
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	_prim_js_add_slow_gc
LBB664_19:                              ; %B42
	cmp	x0, #130
	b.eq	LBB664_21
; %bb.20:                               ; %B44
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB664_21:                              ; %B43
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_sub_2_asm_h            ; -- Begin function sub_2_asm_h
	.globl	_sub_2_asm_h
	.p2align	2
_sub_2_asm_h:                           ; @sub_2_asm_h
; %bb.0:                                ; %B39
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB665_15
; %bb.1:                                ; %B39
	cmp	x21, x8
	b.hi	LBB665_15
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB665_6
; %bb.3:                                ; %B23
	cmp	x21, x8
	b.lo	LBB665_9
; %bb.4:                                ; %B33
	subs	w8, w22, w21
	b.vs	LBB665_15
; %bb.5:                                ; %B35
	ldrb	w9, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB665_6:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB665_15
; %bb.7:                                ; %B7
	cmp	x21, x8
	b.lo	LBB665_13
; %bb.8:                                ; %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	LBB665_12
LBB665_9:                               ; %B25
	tst	x21, #0xfffe000000000000
	b.eq	LBB665_15
; %bb.10:                               ; %B28
	scvtf	d0, w22
	add	x8, x21, x8
LBB665_11:                              ; %B28
	fmov	d1, x8
	fsub	d0, d0, d1
LBB665_12:                              ; %B28
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
LBB665_13:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB665_15
; %bb.14:                               ; %B12
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB665_11
LBB665_15:                              ; %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        ; =0x9e
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB665_17
; %bb.16:                               ; %B38
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB665_17:                              ; %B37
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
	str	x8, [x23, #64]
	bl	_prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	LBB666_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB666_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_shl_2_asm_h            ; -- Begin function shl_2_asm_h
	.globl	_shl_2_asm_h
	.p2align	2
_shl_2_asm_h:                           ; @shl_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB667_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB667_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB667_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB667_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	lsl	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB667_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB667_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB667_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB667_9
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
LBB667_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        ; =0xa0
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB667_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB667_11:                              ; %B26
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_sar_2_asm_h            ; -- Begin function sar_2_asm_h
	.globl	_sar_2_asm_h
	.p2align	2
_sar_2_asm_h:                           ; @sar_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB668_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB668_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB668_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB668_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	asr	w8, w8, w21
	add	w9, w9, #243
	orr	x22, x8, #0xfffe000000000000
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB668_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB668_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB668_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB668_9
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
LBB668_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        ; =0xa1
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB668_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB668_11:                              ; %B26
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_shr_2_asm_h            ; -- Begin function shr_2_asm_h
	.globl	_shr_2_asm_h
	.p2align	2
_shr_2_asm_h:                           ; @shr_2_asm_h
; %bb.0:                                ; %B36
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB669_11
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB669_11
; %bb.2:                                ; %B10
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB669_6
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB669_11
; %bb.4:                                ; %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, LBB669_10
LBB669_5:                               ; %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w9, [x19], #1
	mov	x22, x8
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB669_6:                               ; %B12
	tst	x22, #0xfffe000000000000
	b.eq	LBB669_11
; %bb.7:                                ; %B12
	cmp	x21, x8
	b.lo	LBB669_11
; %bb.8:                                ; %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB669_11
; %bb.9:                                ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, LBB669_5
LBB669_10:                              ; %B6
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
LBB669_11:                              ; %B33
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	LBB669_13
; %bb.12:                               ; %B35
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB669_13:                              ; %B34
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_lt_2_asm_h             ; -- Begin function lt_2_asm_h
	.globl	_lt_2_asm_h
	.p2align	2
_lt_2_asm_h:                            ; @lt_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB670_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB670_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB670_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB670_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, lt
	br	x1
LBB670_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB670_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB670_10
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
LBB670_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB670_12
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
LBB670_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB670_12
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
LBB670_12:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        ; =0xa3
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB670_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB670_14:                              ; %B22
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_lte_2_asm_h            ; -- Begin function lte_2_asm_h
	.globl	_lte_2_asm_h
	.p2align	2
_lte_2_asm_h:                           ; @lte_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB671_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB671_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB671_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB671_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, le
	br	x1
LBB671_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB671_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB671_10
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
LBB671_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB671_12
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
LBB671_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB671_12
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
LBB671_12:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        ; =0xa4
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB671_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB671_14:                              ; %B22
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_gt_2_asm_h             ; -- Begin function gt_2_asm_h
	.globl	_gt_2_asm_h
	.p2align	2
_gt_2_asm_h:                            ; @gt_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB672_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB672_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB672_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB672_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, gt
	br	x1
LBB672_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB672_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB672_10
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
LBB672_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB672_12
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
LBB672_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB672_12
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
LBB672_12:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        ; =0xa5
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB672_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB672_14:                              ; %B22
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_gte_2_asm_h            ; -- Begin function gte_2_asm_h
	.globl	_gte_2_asm_h
	.p2align	2
_gte_2_asm_h:                           ; @gte_2_asm_h
; %bb.0:                                ; %B24
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB673_12
; %bb.1:                                ; %B24
	cmp	x21, x8
	b.hi	LBB673_12
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB673_5
; %bb.3:                                ; %B15
	cmp	x21, x8
	b.lo	LBB673_8
; %bb.4:                                ; %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ge
	br	x1
LBB673_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB673_12
; %bb.6:                                ; %B7
	cmp	x21, x8
	b.lo	LBB673_10
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
LBB673_8:                               ; %B17
	tst	x21, #0xfffe000000000000
	b.eq	LBB673_12
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
LBB673_10:                              ; %B9
	tst	x21, #0xfffe000000000000
	b.eq	LBB673_12
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
LBB673_12:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        ; =0xa6
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	LBB673_14
; %bb.13:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB673_14:                              ; %B22
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
	str	x8, [x23, #64]
	bl	_prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	LBB674_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB674_2:                               ; %B2
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
	str	x8, [x23, #64]
	bl	_prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	LBB675_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB675_2:                               ; %B2
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_eq_2_asm_h             ; -- Begin function eq_2_asm_h
	.globl	_eq_2_asm_h
	.p2align	2
_eq_2_asm_h:                            ; @eq_2_asm_h
; %bb.0:                                ; %B44
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB676_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB676_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB676_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB676_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB676_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB676_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB676_11
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
LBB676_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB676_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB676_10:                              ; %B39
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
LBB676_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB676_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB676_10
LBB676_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB676_15
LBB676_14:                              ; %B8
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB676_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB676_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB676_14
	b	LBB676_20
LBB676_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB676_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB676_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB676_21
LBB676_20:                              ; %B15
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB676_21:                              ; %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB676_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB676_23:                              ; %B42
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_neq_2_asm_h            ; -- Begin function neq_2_asm_h
	.globl	_neq_2_asm_h
	.p2align	2
_neq_2_asm_h:                           ; @neq_2_asm_h
; %bb.0:                                ; %B44
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB677_13
; %bb.1:                                ; %B44
	cmp	x21, x8
	b.hi	LBB677_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB677_5
; %bb.3:                                ; %B35
	cmp	x21, x8
	b.lo	LBB677_8
; %bb.4:                                ; %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB677_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB677_13
; %bb.6:                                ; %B28
	cmp	x21, x8
	b.lo	LBB677_11
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
LBB677_8:                               ; %B37
	tst	x21, #0xfffe000000000000
	b.eq	LBB677_13
; %bb.9:                                ; %B39
	scvtf	d0, w22
	add	x8, x21, x8
LBB677_10:                              ; %B39
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
LBB677_11:                              ; %B30
	tst	x21, #0xfffe000000000000
	b.eq	LBB677_13
; %bb.12:                               ; %B32
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB677_10
LBB677_13:                              ; %B7
	cmp	x22, x21
	b.ne	LBB677_15
LBB677_14:                              ; %B8
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB677_15:                              ; %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	LBB677_17
; %bb.16:                               ; %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB677_14
	b	LBB677_20
LBB677_17:                              ; %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	LBB677_20
; %bb.18:                               ; %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	LBB677_21
; %bb.19:                               ; %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	LBB677_21
LBB677_20:                              ; %B15
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB677_21:                              ; %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB677_23
; %bb.22:                               ; %B43
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB677_23:                              ; %B42
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_strict_eq_2_asm_h      ; -- Begin function strict_eq_2_asm_h
	.globl	_strict_eq_2_asm_h
	.p2align	2
_strict_eq_2_asm_h:                     ; @strict_eq_2_asm_h
; %bb.0:                                ; %B36
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB678_13
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB678_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB678_5
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB678_8
; %bb.4:                                ; %B32
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, eq
	br	x1
LBB678_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB678_13
; %bb.6:                                ; %B20
	cmp	x21, x8
	b.lo	LBB678_11
; %bb.7:                                ; %B25
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
LBB678_8:                               ; %B29
	tst	x21, #0xfffe000000000000
	b.eq	LBB678_13
; %bb.9:                                ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB678_10:                              ; %B31
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
LBB678_11:                              ; %B22
	tst	x21, #0xfffe000000000000
	b.eq	LBB678_13
; %bb.12:                               ; %B24
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB678_10
LBB678_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB678_15
LBB678_14:                              ; %B11
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB678_15:                              ; %B13
	and	x8, x21, #0xffff000000000003
	mov	x11, #-281474976710653          ; =0xffff000000000003
	mov	x12, #2                         ; =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	mov	x13, #2                         ; =0x2
	ccmp	x8, x12, #4, ne
	movk	x13, #65535, lsl #48
	and	x9, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w10, eq
	cmp	x9, x13
	ccmp	x9, x12, #4, ne
	ccmp	x9, x11, #4, ne
	b.ne	LBB678_17
; %bb.16:                               ; %B13
	tbnz	w10, #0, LBB678_20
LBB678_17:                              ; %B16
	mov	x10, #-281474976710656          ; =0xffff000000000000
	cmp	x9, x10
	b.ne	LBB678_19
; %bb.18:                               ; %B16
	cmp	x8, x10
	b.eq	LBB678_22
LBB678_19:                              ; %B18
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB678_20:                              ; %B33
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB678_24
; %bb.21:                               ; %B35
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB678_22:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB678_14
; %bb.23:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB678_24:                              ; %B34
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_strict_neq_2_asm_h     ; -- Begin function strict_neq_2_asm_h
	.globl	_strict_neq_2_asm_h
	.p2align	2
_strict_neq_2_asm_h:                    ; @strict_neq_2_asm_h
; %bb.0:                                ; %B36
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB679_13
; %bb.1:                                ; %B36
	cmp	x21, x8
	b.hi	LBB679_13
; %bb.2:                                ; %B1
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB679_5
; %bb.3:                                ; %B27
	cmp	x21, x8
	b.lo	LBB679_8
; %bb.4:                                ; %B32
	ldrb	w8, [x19], #1
	cmp	w22, w21
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	mov	w8, #6                          ; =0x6
	cinc	x22, x8, ne
	br	x1
LBB679_5:                               ; %B3
	tst	x22, #0xfffe000000000000
	b.eq	LBB679_13
; %bb.6:                                ; %B20
	cmp	x21, x8
	b.lo	LBB679_11
; %bb.7:                                ; %B25
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
LBB679_8:                               ; %B29
	tst	x21, #0xfffe000000000000
	b.eq	LBB679_13
; %bb.9:                                ; %B31
	scvtf	d0, w22
	add	x8, x21, x8
LBB679_10:                              ; %B31
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
LBB679_11:                              ; %B22
	tst	x21, #0xfffe000000000000
	b.eq	LBB679_13
; %bb.12:                               ; %B24
	add	x9, x22, x8
	add	x8, x21, x8
	fmov	d0, x9
	b	LBB679_10
LBB679_13:                              ; %B10
	cmp	x22, x21
	b.ne	LBB679_15
LBB679_14:                              ; %B11
	ldrb	w8, [x19], #1
	mov	w22, #6                         ; =0x6
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB679_15:                              ; %B13
	and	x8, x21, #0xffff000000000003
	mov	x11, #-281474976710653          ; =0xffff000000000003
	mov	x12, #2                         ; =0x2
	cmp	x8, x11
	movk	x12, #1, lsl #48
	mov	x13, #2                         ; =0x2
	ccmp	x8, x12, #4, ne
	movk	x13, #65535, lsl #48
	and	x9, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w10, eq
	cmp	x9, x13
	ccmp	x9, x12, #4, ne
	ccmp	x9, x11, #4, ne
	b.ne	LBB679_17
; %bb.16:                               ; %B13
	tbnz	w10, #0, LBB679_20
LBB679_17:                              ; %B16
	mov	x10, #-281474976710656          ; =0xffff000000000000
	cmp	x9, x10
	b.ne	LBB679_19
; %bb.18:                               ; %B16
	cmp	x8, x10
	b.eq	LBB679_22
LBB679_19:                              ; %B18
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB679_20:                              ; %B33
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          ; =0x1
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	LBB679_24
; %bb.21:                               ; %B35
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB679_22:                              ; %B7
	and	x8, x22, #0xfffffffffffc
	and	x9, x21, #0xfffffffffffc
	ldr	x8, [x8, #8]
	ldr	x9, [x9, #8]
	cmp	x8, x9
	b.eq	LBB679_14
; %bb.23:                               ; %B9
	ldrb	w8, [x19], #1
	mov	w22, #7                         ; =0x7
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB679_24:                              ; %B34
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_and_2_asm_h            ; -- Begin function and_2_asm_h
	.globl	_and_2_asm_h
	.p2align	2
_and_2_asm_h:                           ; @and_2_asm_h
; %bb.0:                                ; %B28
	mov	x8, #-281474976710657           ; =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	LBB680_9
; %bb.1:                                ; %B28
	cmp	x21, x8
	b.hi	LBB680_9
; %bb.2:                                ; %B2
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x22, x8
	b.lo	LBB680_5
; %bb.3:                                ; %B19
	cmp	x21, x8
	b.lo	LBB680_9
; %bb.4:                                ; %B24
	mov	w8, w22
	ldrb	w9, [x19], #1
	and	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB680_5:                               ; %B4
	tst	x22, #0xfffe000000000000
	b.eq	LBB680_9
; %bb.6:                                ; %B4
	cmp	x21, x8
	b.lo	LBB680_9
; %bb.7:                                ; %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	LBB680_9
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
LBB680_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        ; =0xad
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	LBB680_11
; %bb.10:                               ; %B27
	ldrb	w8, [x19], #1
	mov	x22, x0
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB680_11:                              ; %B26
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_xor_2_asm_h            ; -- Begin function xor_2_asm_h
	.globl	_xor_2_asm_h
	.p2align	2
_xor_2_asm_h:                           ; @xor_2_asm_h
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
	eor	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
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
	eor	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB681_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        ; =0xae
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
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
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_or_2_asm_h             ; -- Begin function or_2_asm_h
	.globl	_or_2_asm_h
	.p2align	2
_or_2_asm_h:                            ; @or_2_asm_h
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
	orr	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
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
	orr	w8, w8, w21
	orr	x22, x8, #0xfffe000000000000
	add	w9, w9, #243
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB682_9:                               ; %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        ; =0xaf
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
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
; %bb.0:                                ; %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #1]
	ldr	x9, [x23, #120]
	ldrb	w10, [x19], #2
	add	w8, w8, #486
	ldr	x9, [x9, x10, lsl #3]
	ldr	x1, [x25, w8, uxtw #3]
	mov	x21, x9
	br	x1
                                        ; -- End function
	.private_extern	_fclosure8_2_asm_h      ; -- Begin function fclosure8_2_asm_h
	.globl	_fclosure8_2_asm_h
	.p2align	2
_fclosure8_2_asm_h:                     ; @fclosure8_2_asm_h
; %bb.0:                                ; %B1
	str	x22, [x20]
	mov	x0, x24
	mov	x2, x26
	ldr	x8, [x23, #120]
	ldrb	w9, [x19]
	mov	x3, x23
	ldr	x1, [x8, x9, lsl #3]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x23, #64]
	bl	_js_closure_gc
	cmp	x0, #130
	b.eq	LBB696_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB696_2:                               ; %B2
	b	_exception_spill_top1_asm_h
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
	str	x8, [x23, #64]
	bl	___JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	LBB697_2
; %bb.1:                                ; %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB697_2:                               ; %B2
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
	ldr	x8, [x8, #32]
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
; %bb.0:                                ; %B24
	mov	x8, #2                          ; =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	LBB737_10
; %bb.1:                                ; %B25
	mov	x9, x21
	mov	w8, #18                         ; =0x12
LBB737_2:                               ; %B19
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB737_3 Depth 2
	ldr	x11, [x9, #8]
	ldr	w10, [x11, #12]
	mvn	w10, w10
	orr	w10, w10, #0xffffffcf
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, LBB737_5
LBB737_3:                               ; %B1
                                        ;   Parent Loop BB737_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, #48
	b.eq	LBB737_7
; %bb.4:                                ; %B9
                                        ;   in Loop: Header=BB737_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, LBB737_3
LBB737_5:                               ; %B14
                                        ;   in Loop: Header=BB737_2 Depth=1
	ldr	w10, [x9, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	LBB737_10
; %bb.6:                                ; %B17
                                        ;   in Loop: Header=BB737_2 Depth=1
	ldr	x9, [x9, #8]
	ldr	x9, [x9, #32]
	cbnz	x9, LBB737_2
	b	LBB737_9
LBB737_7:                               ; %B3
	lsr	w8, w12, #26
	tst	w8, #0x30
	b.ne	LBB737_10
; %bb.8:                                ; %B4
	ldr	x8, [x9, #16]
	sub	w9, w10, #1
	ldr	x8, [x8, w9, sxtw #3]
LBB737_9:                               ; %B6
	ldrb	w9, [x19], #1
	mov	x21, x8
	add	w9, w9, #486
	ldr	x1, [x25, w9, uxtw #3]
	br	x1
LBB737_10:                              ; %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #48                         ; =0x30
	mov	x3, x21
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	LBB737_12
; %bb.11:                               ; %B23
	ldrb	w8, [x19], #1
	mov	x21, x0
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB737_12:                              ; %B22
	b	_exception_spill_top0_top1_asm_h
                                        ; -- End function
	.private_extern	_if_false8_2_asm_h      ; -- Begin function if_false8_2_asm_h
	.globl	_if_false8_2_asm_h
	.p2align	2
_if_false8_2_asm_h:                     ; @if_false8_2_asm_h
; %bb.0:                                ; %B23
	cmp	x21, #5
	b.le	LBB738_4
; %bb.1:                                ; %B23
	cmp	x21, #6
	b.eq	LBB738_6
; %bb.2:                                ; %B23
	cmp	x21, #7
	b.eq	LBB738_9
; %bb.3:                                ; %B23
	cmp	x21, #18
	b.eq	LBB738_6
	b	LBB738_7
LBB738_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB738_6
; %bb.5:                                ; %B23
	cmp	x21, #2
	b.ne	LBB738_7
LBB738_6:                               ; %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB738_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x21, x8
	b.hs	LBB738_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB738_10
LBB738_9:                               ; %B19
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB738_10:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB738_13
; %bb.11:                               ; %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB738_6
	b.vs	LBB738_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB738_9
	b	LBB738_6
LBB738_13:                              ; %B15
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
	b.le	LBB739_4
; %bb.1:                                ; %B23
	cmp	x21, #6
	b.eq	LBB739_6
; %bb.2:                                ; %B23
	cmp	x21, #7
	b.eq	LBB739_9
; %bb.3:                                ; %B23
	cmp	x21, #18
	b.eq	LBB739_6
	b	LBB739_7
LBB739_4:                               ; %B23
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.eq	LBB739_6
; %bb.5:                                ; %B23
	cmp	x21, #2
	b.ne	LBB739_7
LBB739_6:                               ; %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB739_7:                               ; %B9
	mov	x8, #-281474976710656           ; =0xffff000000000000
	cmp	x21, x8
	b.hs	LBB739_13
; %bb.8:                                ; %B11
	mov	x8, #-562949953421312           ; =0xfffe000000000000
	cmp	x21, x8
	b.lo	LBB739_10
LBB739_9:                               ; %B19
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	add	w8, w8, #243
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB739_10:                              ; %B13
	tst	x21, #0xfffe000000000000
	b.eq	LBB739_13
; %bb.11:                               ; %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	LBB739_6
	b.vs	LBB739_6
; %bb.12:                               ; %B17
	tbnz	w8, #0, LBB739_9
	b	LBB739_6
LBB739_13:                              ; %B15
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
	b.ne	LBB746_2
; %bb.1:                                ; %B3
	mov	w21, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB746_2:                               ; %B5
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
	b.ne	LBB747_2
; %bb.1:                                ; %B3
	mov	w21, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB747_2:                               ; %B5
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
	b.ne	LBB748_2
; %bb.1:                                ; %B2
	mov	w21, #7                         ; =0x7
	ldrb	w8, [x19], #1
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB748_2:                               ; %B5
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
	cbz	x8, LBB749_3
; %bb.1:                                ; %B7
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbnz	x8, LBB749_4
LBB749_2:                               ; %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	w8, w8, #486
	ldr	x1, [x25, w8, uxtw #3]
	br	x1
LBB749_3:                               ; %B11
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x23, #64]
	bl	_EnsureCoverageCounters
	ldr	x8, [x23, #8]
	ldr	x10, [x8, #32]
	ldr	x8, [x10, #112]
	cbz	x8, LBB749_2
LBB749_4:                               ; %B2
	ldr	w9, [x19]
	ldr	w10, [x10, #104]
	cmp	w9, w10
	b.hs	LBB749_2
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
	.private_extern	_InstallBcHandler       ; -- Begin function InstallBcHandler
	.globl	_InstallBcHandler
	.p2align	2
_InstallBcHandler:                      ; @InstallBcHandler
	.cfi_startproc
; %bb.0:                                ; %B0
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
Lloh40:
	adrp	x8, _invalid_0_asm_h@PAGE
Lloh41:
	add	x8, x8, _invalid_0_asm_h@PAGEOFF
Lloh42:
	adrp	x9, _push_i32_0_asm_h@PAGE
Lloh43:
	add	x9, x9, _push_i32_0_asm_h@PAGEOFF
	stp	x8, x9, [x0]
Lloh44:
	adrp	x8, _push_const_0_asm_h@PAGE
Lloh45:
	add	x8, x8, _push_const_0_asm_h@PAGEOFF
Lloh46:
	adrp	x9, _fclosure_0_asm_h@PAGE
Lloh47:
	add	x9, x9, _fclosure_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #16]
Lloh48:
	adrp	x8, _push_atom_value_0_asm_h@PAGE
Lloh49:
	add	x8, x8, _push_atom_value_0_asm_h@PAGEOFF
Lloh50:
	adrp	x9, _private_symbol_0_asm_h@PAGE
Lloh51:
	add	x9, x9, _private_symbol_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #32]
Lloh52:
	adrp	x8, _undefined_0_asm_h@PAGE
Lloh53:
	add	x8, x8, _undefined_0_asm_h@PAGEOFF
Lloh54:
	adrp	x9, _null_0_asm_h@PAGE
Lloh55:
	add	x9, x9, _null_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #48]
Lloh56:
	adrp	x8, _push_this_0_asm_h@PAGE
Lloh57:
	add	x8, x8, _push_this_0_asm_h@PAGEOFF
Lloh58:
	adrp	x9, _push_false_0_asm_h@PAGE
Lloh59:
	add	x9, x9, _push_false_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #64]
Lloh60:
	adrp	x8, _push_true_0_asm_h@PAGE
Lloh61:
	add	x8, x8, _push_true_0_asm_h@PAGEOFF
Lloh62:
	adrp	x9, _object_0_asm_h@PAGE
Lloh63:
	add	x9, x9, _object_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #80]
Lloh64:
	adrp	x8, _special_object_0_asm_h@PAGE
Lloh65:
	add	x8, x8, _special_object_0_asm_h@PAGEOFF
Lloh66:
	adrp	x9, _rest_0_asm_h@PAGE
Lloh67:
	add	x9, x9, _rest_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #96]
Lloh68:
	adrp	x8, _drop_0_asm_h@PAGE
Lloh69:
	add	x8, x8, _drop_0_asm_h@PAGEOFF
Lloh70:
	adrp	x9, _nip_0_asm_h@PAGE
Lloh71:
	add	x9, x9, _nip_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #112]
Lloh72:
	adrp	x8, _nip1_0_asm_h@PAGE
Lloh73:
	add	x8, x8, _nip1_0_asm_h@PAGEOFF
Lloh74:
	adrp	x9, _dup_0_asm_h@PAGE
Lloh75:
	add	x9, x9, _dup_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #128]
Lloh76:
	adrp	x8, _dup1_0_asm_h@PAGE
Lloh77:
	add	x8, x8, _dup1_0_asm_h@PAGEOFF
Lloh78:
	adrp	x9, _dup2_0_asm_h@PAGE
Lloh79:
	add	x9, x9, _dup2_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #144]
Lloh80:
	adrp	x8, _dup3_0_asm_h@PAGE
Lloh81:
	add	x8, x8, _dup3_0_asm_h@PAGEOFF
Lloh82:
	adrp	x9, _insert2_0_asm_h@PAGE
Lloh83:
	add	x9, x9, _insert2_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #160]
Lloh84:
	adrp	x8, _insert3_0_asm_h@PAGE
Lloh85:
	add	x8, x8, _insert3_0_asm_h@PAGEOFF
Lloh86:
	adrp	x9, _insert4_0_asm_h@PAGE
Lloh87:
	add	x9, x9, _insert4_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #176]
Lloh88:
	adrp	x8, _perm3_0_asm_h@PAGE
Lloh89:
	add	x8, x8, _perm3_0_asm_h@PAGEOFF
Lloh90:
	adrp	x9, _perm4_0_asm_h@PAGE
Lloh91:
	add	x9, x9, _perm4_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #192]
Lloh92:
	adrp	x8, _perm5_0_asm_h@PAGE
Lloh93:
	add	x8, x8, _perm5_0_asm_h@PAGEOFF
Lloh94:
	adrp	x9, _swap_0_asm_h@PAGE
Lloh95:
	add	x9, x9, _swap_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #208]
Lloh96:
	adrp	x8, _swap2_0_asm_h@PAGE
Lloh97:
	add	x8, x8, _swap2_0_asm_h@PAGEOFF
Lloh98:
	adrp	x9, _rot3l_0_asm_h@PAGE
Lloh99:
	add	x9, x9, _rot3l_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #224]
Lloh100:
	adrp	x8, _rot3r_0_asm_h@PAGE
Lloh101:
	add	x8, x8, _rot3r_0_asm_h@PAGEOFF
Lloh102:
	adrp	x9, _rot4l_0_asm_h@PAGE
Lloh103:
	add	x9, x9, _rot4l_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #240]
Lloh104:
	adrp	x8, _rot5l_0_asm_h@PAGE
Lloh105:
	add	x8, x8, _rot5l_0_asm_h@PAGEOFF
Lloh106:
	adrp	x9, _call_constructor_0_asm_h@PAGE
Lloh107:
	add	x9, x9, _call_constructor_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #256]
Lloh108:
	adrp	x8, _call_0_asm_h@PAGE
Lloh109:
	add	x8, x8, _call_0_asm_h@PAGEOFF
Lloh110:
	adrp	x9, _tail_call_0_asm_h@PAGE
Lloh111:
	add	x9, x9, _tail_call_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #272]
Lloh112:
	adrp	x8, _call_method_0_asm_h@PAGE
Lloh113:
	add	x8, x8, _call_method_0_asm_h@PAGEOFF
Lloh114:
	adrp	x9, _tail_call_method_0_asm_h@PAGE
Lloh115:
	add	x9, x9, _tail_call_method_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #288]
Lloh116:
	adrp	x8, _array_from_0_asm_h@PAGE
Lloh117:
	add	x8, x8, _array_from_0_asm_h@PAGEOFF
Lloh118:
	adrp	x9, _apply_0_asm_h@PAGE
Lloh119:
	add	x9, x9, _apply_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #304]
Lloh120:
	adrp	x8, _return_0_asm_h@PAGE
Lloh121:
	add	x8, x8, _return_0_asm_h@PAGEOFF
Lloh122:
	adrp	x9, _return_undef_0_asm_h@PAGE
Lloh123:
	add	x9, x9, _return_undef_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #320]
Lloh124:
	adrp	x8, _check_ctor_return_0_asm_h@PAGE
Lloh125:
	add	x8, x8, _check_ctor_return_0_asm_h@PAGEOFF
Lloh126:
	adrp	x9, _check_ctor_0_asm_h@PAGE
Lloh127:
	add	x9, x9, _check_ctor_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #336]
Lloh128:
	adrp	x8, _check_brand_0_asm_h@PAGE
Lloh129:
	add	x8, x8, _check_brand_0_asm_h@PAGEOFF
Lloh130:
	adrp	x9, _add_brand_0_asm_h@PAGE
Lloh131:
	add	x9, x9, _add_brand_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #352]
Lloh132:
	adrp	x8, _return_async_0_asm_h@PAGE
Lloh133:
	add	x8, x8, _return_async_0_asm_h@PAGEOFF
Lloh134:
	adrp	x9, _throw_0_asm_h@PAGE
Lloh135:
	add	x9, x9, _throw_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #368]
Lloh136:
	adrp	x8, _throw_var_0_asm_h@PAGE
Lloh137:
	add	x8, x8, _throw_var_0_asm_h@PAGEOFF
Lloh138:
	adrp	x9, _eval_0_asm_h@PAGE
Lloh139:
	add	x9, x9, _eval_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #384]
Lloh140:
	adrp	x8, _regexp_0_asm_h@PAGE
Lloh141:
	add	x8, x8, _regexp_0_asm_h@PAGEOFF
Lloh142:
	adrp	x9, _get_super_ctor_0_asm_h@PAGE
Lloh143:
	add	x9, x9, _get_super_ctor_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #400]
Lloh144:
	adrp	x8, _get_super_0_asm_h@PAGE
Lloh145:
	add	x8, x8, _get_super_0_asm_h@PAGEOFF
Lloh146:
	adrp	x9, _import_0_asm_h@PAGE
Lloh147:
	add	x9, x9, _import_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #416]
Lloh148:
	adrp	x8, _check_var_0_asm_h@PAGE
Lloh149:
	add	x8, x8, _check_var_0_asm_h@PAGEOFF
Lloh150:
	adrp	x9, _get_var_undef_0_asm_h@PAGE
Lloh151:
	add	x9, x9, _get_var_undef_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #432]
Lloh152:
	adrp	x8, _get_var_0_asm_h@PAGE
Lloh153:
	add	x8, x8, _get_var_0_asm_h@PAGEOFF
Lloh154:
	adrp	x9, _put_var_0_asm_h@PAGE
Lloh155:
	add	x9, x9, _put_var_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #448]
Lloh156:
	adrp	x8, _put_var_init_0_asm_h@PAGE
Lloh157:
	add	x8, x8, _put_var_init_0_asm_h@PAGEOFF
Lloh158:
	adrp	x9, _put_var_strict_0_asm_h@PAGE
Lloh159:
	add	x9, x9, _put_var_strict_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #464]
Lloh160:
	adrp	x8, _get_ref_value_0_asm_h@PAGE
Lloh161:
	add	x8, x8, _get_ref_value_0_asm_h@PAGEOFF
Lloh162:
	adrp	x9, _put_ref_value_0_asm_h@PAGE
Lloh163:
	add	x9, x9, _put_ref_value_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #480]
Lloh164:
	adrp	x8, _define_var_0_asm_h@PAGE
Lloh165:
	add	x8, x8, _define_var_0_asm_h@PAGEOFF
Lloh166:
	adrp	x9, _check_define_var_0_asm_h@PAGE
Lloh167:
	add	x9, x9, _check_define_var_0_asm_h@PAGEOFF
	stp	x8, x9, [x0, #496]
Lloh168:
	adrp	x8, _define_func_0_asm_h@PAGE
Lloh169:
	add	x8, x8, _define_func_0_asm_h@PAGEOFF
	str	x8, [x0, #512]
Lloh170:
	adrp	x8, _get_field_0_asm_h@PAGE
Lloh171:
	add	x8, x8, _get_field_0_asm_h@PAGEOFF
	str	x8, [x0, #520]
Lloh172:
	adrp	x8, _get_field2_0_asm_h@PAGE
Lloh173:
	add	x8, x8, _get_field2_0_asm_h@PAGEOFF
	str	x8, [x0, #528]
Lloh174:
	adrp	x8, _put_field_0_asm_h@PAGE
Lloh175:
	add	x8, x8, _put_field_0_asm_h@PAGEOFF
	str	x8, [x0, #536]
Lloh176:
	adrp	x8, _get_private_field_0_asm_h@PAGE
Lloh177:
	add	x8, x8, _get_private_field_0_asm_h@PAGEOFF
	str	x8, [x0, #544]
Lloh178:
	adrp	x8, _put_private_field_0_asm_h@PAGE
Lloh179:
	add	x8, x8, _put_private_field_0_asm_h@PAGEOFF
	str	x8, [x0, #552]
Lloh180:
	adrp	x8, _define_private_field_0_asm_h@PAGE
Lloh181:
	add	x8, x8, _define_private_field_0_asm_h@PAGEOFF
	str	x8, [x0, #560]
Lloh182:
	adrp	x8, _get_array_el_0_asm_h@PAGE
Lloh183:
	add	x8, x8, _get_array_el_0_asm_h@PAGEOFF
	str	x8, [x0, #568]
Lloh184:
	adrp	x8, _get_array_el2_0_asm_h@PAGE
Lloh185:
	add	x8, x8, _get_array_el2_0_asm_h@PAGEOFF
	str	x8, [x0, #576]
Lloh186:
	adrp	x8, _put_array_el_0_asm_h@PAGE
Lloh187:
	add	x8, x8, _put_array_el_0_asm_h@PAGEOFF
	str	x8, [x0, #584]
Lloh188:
	adrp	x8, _get_super_value_0_asm_h@PAGE
Lloh189:
	add	x8, x8, _get_super_value_0_asm_h@PAGEOFF
	str	x8, [x0, #592]
Lloh190:
	adrp	x8, _put_super_value_0_asm_h@PAGE
Lloh191:
	add	x8, x8, _put_super_value_0_asm_h@PAGEOFF
	str	x8, [x0, #600]
Lloh192:
	adrp	x8, _define_field_0_asm_h@PAGE
Lloh193:
	add	x8, x8, _define_field_0_asm_h@PAGEOFF
	str	x8, [x0, #608]
Lloh194:
	adrp	x8, _set_name_0_asm_h@PAGE
Lloh195:
	add	x8, x8, _set_name_0_asm_h@PAGEOFF
	str	x8, [x0, #616]
Lloh196:
	adrp	x8, _set_name_computed_0_asm_h@PAGE
Lloh197:
	add	x8, x8, _set_name_computed_0_asm_h@PAGEOFF
	str	x8, [x0, #624]
Lloh198:
	adrp	x8, _set_proto_0_asm_h@PAGE
Lloh199:
	add	x8, x8, _set_proto_0_asm_h@PAGEOFF
	str	x8, [x0, #632]
Lloh200:
	adrp	x8, _set_home_object_0_asm_h@PAGE
Lloh201:
	add	x8, x8, _set_home_object_0_asm_h@PAGEOFF
	str	x8, [x0, #640]
Lloh202:
	adrp	x8, _define_array_el_0_asm_h@PAGE
Lloh203:
	add	x8, x8, _define_array_el_0_asm_h@PAGEOFF
	str	x8, [x0, #648]
Lloh204:
	adrp	x8, _append_0_asm_h@PAGE
Lloh205:
	add	x8, x8, _append_0_asm_h@PAGEOFF
	str	x8, [x0, #656]
Lloh206:
	adrp	x8, _copy_data_properties_0_asm_h@PAGE
Lloh207:
	add	x8, x8, _copy_data_properties_0_asm_h@PAGEOFF
	str	x8, [x0, #664]
Lloh208:
	adrp	x8, _define_method_0_asm_h@PAGE
Lloh209:
	add	x8, x8, _define_method_0_asm_h@PAGEOFF
	str	x8, [x0, #672]
Lloh210:
	adrp	x8, _define_method_computed_0_asm_h@PAGE
Lloh211:
	add	x8, x8, _define_method_computed_0_asm_h@PAGEOFF
	str	x8, [x0, #680]
Lloh212:
	adrp	x8, _define_class_0_asm_h@PAGE
Lloh213:
	add	x8, x8, _define_class_0_asm_h@PAGEOFF
	str	x8, [x0, #688]
Lloh214:
	adrp	x8, _get_loc_0_asm_h@PAGE
Lloh215:
	add	x8, x8, _get_loc_0_asm_h@PAGEOFF
	str	x8, [x0, #696]
Lloh216:
	adrp	x8, _put_loc_0_asm_h@PAGE
Lloh217:
	add	x8, x8, _put_loc_0_asm_h@PAGEOFF
	str	x8, [x0, #704]
Lloh218:
	adrp	x8, _set_loc_0_asm_h@PAGE
Lloh219:
	add	x8, x8, _set_loc_0_asm_h@PAGEOFF
	str	x8, [x0, #712]
Lloh220:
	adrp	x8, _get_arg_0_asm_h@PAGE
Lloh221:
	add	x8, x8, _get_arg_0_asm_h@PAGEOFF
	str	x8, [x0, #720]
Lloh222:
	adrp	x8, _put_arg_0_asm_h@PAGE
Lloh223:
	add	x8, x8, _put_arg_0_asm_h@PAGEOFF
	str	x8, [x0, #728]
Lloh224:
	adrp	x8, _set_arg_0_asm_h@PAGE
Lloh225:
	add	x8, x8, _set_arg_0_asm_h@PAGEOFF
	str	x8, [x0, #736]
Lloh226:
	adrp	x8, _get_var_ref_0_asm_h@PAGE
Lloh227:
	add	x8, x8, _get_var_ref_0_asm_h@PAGEOFF
	str	x8, [x0, #744]
Lloh228:
	adrp	x8, _put_var_ref_0_asm_h@PAGE
Lloh229:
	add	x8, x8, _put_var_ref_0_asm_h@PAGEOFF
	str	x8, [x0, #752]
Lloh230:
	adrp	x8, _set_var_ref_0_asm_h@PAGE
Lloh231:
	add	x8, x8, _set_var_ref_0_asm_h@PAGEOFF
	str	x8, [x0, #760]
Lloh232:
	adrp	x8, _set_loc_uninitialized_0_asm_h@PAGE
Lloh233:
	add	x8, x8, _set_loc_uninitialized_0_asm_h@PAGEOFF
	str	x8, [x0, #768]
Lloh234:
	adrp	x8, _get_loc_check_0_asm_h@PAGE
Lloh235:
	add	x8, x8, _get_loc_check_0_asm_h@PAGEOFF
	str	x8, [x0, #776]
Lloh236:
	adrp	x8, _put_loc_check_0_asm_h@PAGE
Lloh237:
	add	x8, x8, _put_loc_check_0_asm_h@PAGEOFF
	str	x8, [x0, #784]
Lloh238:
	adrp	x8, _put_loc_check_init_0_asm_h@PAGE
Lloh239:
	add	x8, x8, _put_loc_check_init_0_asm_h@PAGEOFF
	str	x8, [x0, #792]
Lloh240:
	adrp	x8, _get_var_ref_check_0_asm_h@PAGE
Lloh241:
	add	x8, x8, _get_var_ref_check_0_asm_h@PAGEOFF
	str	x8, [x0, #800]
Lloh242:
	adrp	x8, _put_var_ref_check_0_asm_h@PAGE
Lloh243:
	add	x8, x8, _put_var_ref_check_0_asm_h@PAGEOFF
	str	x8, [x0, #808]
Lloh244:
	adrp	x8, _put_var_ref_check_init_0_asm_h@PAGE
Lloh245:
	add	x8, x8, _put_var_ref_check_init_0_asm_h@PAGEOFF
	str	x8, [x0, #816]
Lloh246:
	adrp	x8, _close_loc_0_asm_h@PAGE
Lloh247:
	add	x8, x8, _close_loc_0_asm_h@PAGEOFF
	str	x8, [x0, #824]
Lloh248:
	adrp	x8, _if_false_0_asm_h@PAGE
Lloh249:
	add	x8, x8, _if_false_0_asm_h@PAGEOFF
	str	x8, [x0, #832]
Lloh250:
	adrp	x8, _if_true_0_asm_h@PAGE
Lloh251:
	add	x8, x8, _if_true_0_asm_h@PAGEOFF
	str	x8, [x0, #840]
Lloh252:
	adrp	x8, _goto_0_asm_h@PAGE
Lloh253:
	add	x8, x8, _goto_0_asm_h@PAGEOFF
	str	x8, [x0, #848]
Lloh254:
	adrp	x8, _catch_0_asm_h@PAGE
Lloh255:
	add	x8, x8, _catch_0_asm_h@PAGEOFF
	str	x8, [x0, #856]
Lloh256:
	adrp	x8, _gosub_0_asm_h@PAGE
Lloh257:
	add	x8, x8, _gosub_0_asm_h@PAGEOFF
	str	x8, [x0, #864]
Lloh258:
	adrp	x8, _ret_0_asm_h@PAGE
Lloh259:
	add	x8, x8, _ret_0_asm_h@PAGEOFF
	str	x8, [x0, #872]
Lloh260:
	adrp	x8, _to_object_0_asm_h@PAGE
Lloh261:
	add	x8, x8, _to_object_0_asm_h@PAGEOFF
	str	x8, [x0, #880]
Lloh262:
	adrp	x8, _to_propkey_0_asm_h@PAGE
Lloh263:
	add	x8, x8, _to_propkey_0_asm_h@PAGEOFF
	str	x8, [x0, #888]
Lloh264:
	adrp	x8, _to_propkey2_0_asm_h@PAGE
Lloh265:
	add	x8, x8, _to_propkey2_0_asm_h@PAGEOFF
	str	x8, [x0, #896]
Lloh266:
	adrp	x8, _with_get_var_0_asm_h@PAGE
Lloh267:
	add	x8, x8, _with_get_var_0_asm_h@PAGEOFF
	str	x8, [x0, #904]
Lloh268:
	adrp	x8, _with_put_var_0_asm_h@PAGE
Lloh269:
	add	x8, x8, _with_put_var_0_asm_h@PAGEOFF
	str	x8, [x0, #912]
Lloh270:
	adrp	x8, _with_delete_var_0_asm_h@PAGE
Lloh271:
	add	x8, x8, _with_delete_var_0_asm_h@PAGEOFF
	str	x8, [x0, #920]
Lloh272:
	adrp	x8, _with_make_ref_0_asm_h@PAGE
Lloh273:
	add	x8, x8, _with_make_ref_0_asm_h@PAGEOFF
	str	x8, [x0, #928]
Lloh274:
	adrp	x8, _with_get_ref_0_asm_h@PAGE
Lloh275:
	add	x8, x8, _with_get_ref_0_asm_h@PAGEOFF
	str	x8, [x0, #936]
Lloh276:
	adrp	x8, _with_get_ref_undef_0_asm_h@PAGE
Lloh277:
	add	x8, x8, _with_get_ref_undef_0_asm_h@PAGEOFF
	str	x8, [x0, #944]
Lloh278:
	adrp	x8, _make_loc_ref_0_asm_h@PAGE
Lloh279:
	add	x8, x8, _make_loc_ref_0_asm_h@PAGEOFF
	str	x8, [x0, #952]
Lloh280:
	adrp	x8, _make_arg_ref_0_asm_h@PAGE
Lloh281:
	add	x8, x8, _make_arg_ref_0_asm_h@PAGEOFF
	str	x8, [x0, #960]
Lloh282:
	adrp	x8, _make_var_ref_ref_0_asm_h@PAGE
Lloh283:
	add	x8, x8, _make_var_ref_ref_0_asm_h@PAGEOFF
	str	x8, [x0, #968]
Lloh284:
	adrp	x8, _make_var_ref_0_asm_h@PAGE
Lloh285:
	add	x8, x8, _make_var_ref_0_asm_h@PAGEOFF
	str	x8, [x0, #976]
Lloh286:
	adrp	x8, _for_in_start_0_asm_h@PAGE
Lloh287:
	add	x8, x8, _for_in_start_0_asm_h@PAGEOFF
	str	x8, [x0, #984]
Lloh288:
	adrp	x8, _for_of_start_0_asm_h@PAGE
Lloh289:
	add	x8, x8, _for_of_start_0_asm_h@PAGEOFF
	str	x8, [x0, #992]
Lloh290:
	adrp	x8, _for_await_of_start_0_asm_h@PAGE
Lloh291:
	add	x8, x8, _for_await_of_start_0_asm_h@PAGEOFF
	str	x8, [x0, #1000]
Lloh292:
	adrp	x8, _for_in_next_0_asm_h@PAGE
Lloh293:
	add	x8, x8, _for_in_next_0_asm_h@PAGEOFF
	str	x8, [x0, #1008]
Lloh294:
	adrp	x8, _for_of_next_0_asm_h@PAGE
Lloh295:
	add	x8, x8, _for_of_next_0_asm_h@PAGEOFF
	str	x8, [x0, #1016]
Lloh296:
	adrp	x8, _for_await_of_next_0_asm_h@PAGE
Lloh297:
	add	x8, x8, _for_await_of_next_0_asm_h@PAGEOFF
	str	x8, [x0, #1024]
Lloh298:
	adrp	x8, _iterator_get_value_done_0_asm_h@PAGE
Lloh299:
	add	x8, x8, _iterator_get_value_done_0_asm_h@PAGEOFF
	str	x8, [x0, #1032]
Lloh300:
	adrp	x8, _iterator_close_0_asm_h@PAGE
Lloh301:
	add	x8, x8, _iterator_close_0_asm_h@PAGEOFF
	str	x8, [x0, #1040]
Lloh302:
	adrp	x8, _iterator_close_return_0_asm_h@PAGE
Lloh303:
	add	x8, x8, _iterator_close_return_0_asm_h@PAGEOFF
	str	x8, [x0, #1048]
Lloh304:
	adrp	x8, _async_iterator_close_0_asm_h@PAGE
Lloh305:
	add	x8, x8, _async_iterator_close_0_asm_h@PAGEOFF
	str	x8, [x0, #1056]
Lloh306:
	adrp	x8, _async_iterator_next_0_asm_h@PAGE
Lloh307:
	add	x8, x8, _async_iterator_next_0_asm_h@PAGEOFF
	str	x8, [x0, #1064]
Lloh308:
	adrp	x8, _async_iterator_get_0_asm_h@PAGE
Lloh309:
	add	x8, x8, _async_iterator_get_0_asm_h@PAGEOFF
	str	x8, [x0, #1072]
Lloh310:
	adrp	x8, _initial_yield_0_asm_h@PAGE
Lloh311:
	add	x8, x8, _initial_yield_0_asm_h@PAGEOFF
	str	x8, [x0, #1080]
Lloh312:
	adrp	x8, _yield_0_asm_h@PAGE
Lloh313:
	add	x8, x8, _yield_0_asm_h@PAGEOFF
	str	x8, [x0, #1088]
Lloh314:
	adrp	x8, _yield_star_0_asm_h@PAGE
Lloh315:
	add	x8, x8, _yield_star_0_asm_h@PAGEOFF
	str	x8, [x0, #1096]
Lloh316:
	adrp	x8, _async_yield_star_0_asm_h@PAGE
Lloh317:
	add	x8, x8, _async_yield_star_0_asm_h@PAGEOFF
	str	x8, [x0, #1104]
Lloh318:
	adrp	x8, _await_0_asm_h@PAGE
Lloh319:
	add	x8, x8, _await_0_asm_h@PAGEOFF
	str	x8, [x0, #1112]
Lloh320:
	adrp	x8, _neg_0_asm_h@PAGE
Lloh321:
	add	x8, x8, _neg_0_asm_h@PAGEOFF
	str	x8, [x0, #1120]
Lloh322:
	adrp	x8, _plus_0_asm_h@PAGE
Lloh323:
	add	x8, x8, _plus_0_asm_h@PAGEOFF
	str	x8, [x0, #1128]
Lloh324:
	adrp	x8, _dec_0_asm_h@PAGE
Lloh325:
	add	x8, x8, _dec_0_asm_h@PAGEOFF
	str	x8, [x0, #1136]
Lloh326:
	adrp	x8, _inc_0_asm_h@PAGE
Lloh327:
	add	x8, x8, _inc_0_asm_h@PAGEOFF
	str	x8, [x0, #1144]
Lloh328:
	adrp	x8, _post_dec_0_asm_h@PAGE
Lloh329:
	add	x8, x8, _post_dec_0_asm_h@PAGEOFF
	str	x8, [x0, #1152]
Lloh330:
	adrp	x8, _post_inc_0_asm_h@PAGE
Lloh331:
	add	x8, x8, _post_inc_0_asm_h@PAGEOFF
	str	x8, [x0, #1160]
Lloh332:
	adrp	x8, _dec_loc_0_asm_h@PAGE
Lloh333:
	add	x8, x8, _dec_loc_0_asm_h@PAGEOFF
	str	x8, [x0, #1168]
Lloh334:
	adrp	x8, _inc_loc_0_asm_h@PAGE
Lloh335:
	add	x8, x8, _inc_loc_0_asm_h@PAGEOFF
	str	x8, [x0, #1176]
Lloh336:
	adrp	x8, _add_loc_0_asm_h@PAGE
Lloh337:
	add	x8, x8, _add_loc_0_asm_h@PAGEOFF
	str	x8, [x0, #1184]
Lloh338:
	adrp	x8, _not_0_asm_h@PAGE
Lloh339:
	add	x8, x8, _not_0_asm_h@PAGEOFF
	str	x8, [x0, #1192]
Lloh340:
	adrp	x8, _lnot_0_asm_h@PAGE
Lloh341:
	add	x8, x8, _lnot_0_asm_h@PAGEOFF
	str	x8, [x0, #1200]
Lloh342:
	adrp	x8, _typeof_0_asm_h@PAGE
Lloh343:
	add	x8, x8, _typeof_0_asm_h@PAGEOFF
	str	x8, [x0, #1208]
Lloh344:
	adrp	x8, _delete_0_asm_h@PAGE
Lloh345:
	add	x8, x8, _delete_0_asm_h@PAGEOFF
	str	x8, [x0, #1216]
Lloh346:
	adrp	x8, _delete_var_0_asm_h@PAGE
Lloh347:
	add	x8, x8, _delete_var_0_asm_h@PAGEOFF
	str	x8, [x0, #1224]
Lloh348:
	adrp	x8, _mul_0_asm_h@PAGE
Lloh349:
	add	x8, x8, _mul_0_asm_h@PAGEOFF
	str	x8, [x0, #1232]
Lloh350:
	adrp	x8, _div_0_asm_h@PAGE
Lloh351:
	add	x8, x8, _div_0_asm_h@PAGEOFF
	str	x8, [x0, #1240]
Lloh352:
	adrp	x8, _mod_0_asm_h@PAGE
Lloh353:
	add	x8, x8, _mod_0_asm_h@PAGEOFF
	str	x8, [x0, #1248]
Lloh354:
	adrp	x8, _add_0_asm_h@PAGE
Lloh355:
	add	x8, x8, _add_0_asm_h@PAGEOFF
	str	x8, [x0, #1256]
Lloh356:
	adrp	x8, _sub_0_asm_h@PAGE
Lloh357:
	add	x8, x8, _sub_0_asm_h@PAGEOFF
	str	x8, [x0, #1264]
Lloh358:
	adrp	x8, _pow_0_asm_h@PAGE
Lloh359:
	add	x8, x8, _pow_0_asm_h@PAGEOFF
	str	x8, [x0, #1272]
Lloh360:
	adrp	x8, _shl_0_asm_h@PAGE
Lloh361:
	add	x8, x8, _shl_0_asm_h@PAGEOFF
	str	x8, [x0, #1280]
Lloh362:
	adrp	x8, _sar_0_asm_h@PAGE
Lloh363:
	add	x8, x8, _sar_0_asm_h@PAGEOFF
	str	x8, [x0, #1288]
Lloh364:
	adrp	x8, _shr_0_asm_h@PAGE
Lloh365:
	add	x8, x8, _shr_0_asm_h@PAGEOFF
	str	x8, [x0, #1296]
Lloh366:
	adrp	x8, _lt_0_asm_h@PAGE
Lloh367:
	add	x8, x8, _lt_0_asm_h@PAGEOFF
	str	x8, [x0, #1304]
Lloh368:
	adrp	x8, _lte_0_asm_h@PAGE
Lloh369:
	add	x8, x8, _lte_0_asm_h@PAGEOFF
	str	x8, [x0, #1312]
Lloh370:
	adrp	x8, _gt_0_asm_h@PAGE
Lloh371:
	add	x8, x8, _gt_0_asm_h@PAGEOFF
	str	x8, [x0, #1320]
Lloh372:
	adrp	x8, _gte_0_asm_h@PAGE
Lloh373:
	add	x8, x8, _gte_0_asm_h@PAGEOFF
	str	x8, [x0, #1328]
Lloh374:
	adrp	x8, _instanceof_0_asm_h@PAGE
Lloh375:
	add	x8, x8, _instanceof_0_asm_h@PAGEOFF
	str	x8, [x0, #1336]
Lloh376:
	adrp	x8, _in_0_asm_h@PAGE
Lloh377:
	add	x8, x8, _in_0_asm_h@PAGEOFF
	str	x8, [x0, #1344]
Lloh378:
	adrp	x8, _eq_0_asm_h@PAGE
Lloh379:
	add	x8, x8, _eq_0_asm_h@PAGEOFF
	str	x8, [x0, #1352]
Lloh380:
	adrp	x8, _neq_0_asm_h@PAGE
Lloh381:
	add	x8, x8, _neq_0_asm_h@PAGEOFF
	str	x8, [x0, #1360]
Lloh382:
	adrp	x8, _strict_eq_0_asm_h@PAGE
Lloh383:
	add	x8, x8, _strict_eq_0_asm_h@PAGEOFF
	str	x8, [x0, #1368]
Lloh384:
	adrp	x8, _strict_neq_0_asm_h@PAGE
Lloh385:
	add	x8, x8, _strict_neq_0_asm_h@PAGEOFF
	str	x8, [x0, #1376]
Lloh386:
	adrp	x8, _and_0_asm_h@PAGE
Lloh387:
	add	x8, x8, _and_0_asm_h@PAGEOFF
	str	x8, [x0, #1384]
Lloh388:
	adrp	x8, _xor_0_asm_h@PAGE
Lloh389:
	add	x8, x8, _xor_0_asm_h@PAGEOFF
	str	x8, [x0, #1392]
Lloh390:
	adrp	x8, _or_0_asm_h@PAGE
Lloh391:
	add	x8, x8, _or_0_asm_h@PAGEOFF
	str	x8, [x0, #1400]
Lloh392:
	adrp	x8, _nop_0_asm_h@PAGE
Lloh393:
	add	x8, x8, _nop_0_asm_h@PAGEOFF
	str	x8, [x0, #1408]
Lloh394:
	adrp	x8, _push_minus1_0_asm_h@PAGE
Lloh395:
	add	x8, x8, _push_minus1_0_asm_h@PAGEOFF
	str	x8, [x0, #1416]
Lloh396:
	adrp	x8, _push_0_0_asm_h@PAGE
Lloh397:
	add	x8, x8, _push_0_0_asm_h@PAGEOFF
	str	x8, [x0, #1424]
Lloh398:
	adrp	x8, _push_1_0_asm_h@PAGE
Lloh399:
	add	x8, x8, _push_1_0_asm_h@PAGEOFF
	str	x8, [x0, #1432]
Lloh400:
	adrp	x8, _push_2_0_asm_h@PAGE
Lloh401:
	add	x8, x8, _push_2_0_asm_h@PAGEOFF
	str	x8, [x0, #1440]
Lloh402:
	adrp	x8, _push_3_0_asm_h@PAGE
Lloh403:
	add	x8, x8, _push_3_0_asm_h@PAGEOFF
	str	x8, [x0, #1448]
Lloh404:
	adrp	x8, _push_4_0_asm_h@PAGE
Lloh405:
	add	x8, x8, _push_4_0_asm_h@PAGEOFF
	str	x8, [x0, #1456]
Lloh406:
	adrp	x8, _push_5_0_asm_h@PAGE
Lloh407:
	add	x8, x8, _push_5_0_asm_h@PAGEOFF
	str	x8, [x0, #1464]
Lloh408:
	adrp	x8, _push_6_0_asm_h@PAGE
Lloh409:
	add	x8, x8, _push_6_0_asm_h@PAGEOFF
	str	x8, [x0, #1472]
Lloh410:
	adrp	x8, _push_7_0_asm_h@PAGE
Lloh411:
	add	x8, x8, _push_7_0_asm_h@PAGEOFF
	str	x8, [x0, #1480]
Lloh412:
	adrp	x8, _push_i8_0_asm_h@PAGE
Lloh413:
	add	x8, x8, _push_i8_0_asm_h@PAGEOFF
	str	x8, [x0, #1488]
Lloh414:
	adrp	x8, _push_i16_0_asm_h@PAGE
Lloh415:
	add	x8, x8, _push_i16_0_asm_h@PAGEOFF
	str	x8, [x0, #1496]
Lloh416:
	adrp	x8, _push_const8_0_asm_h@PAGE
Lloh417:
	add	x8, x8, _push_const8_0_asm_h@PAGEOFF
	str	x8, [x0, #1504]
Lloh418:
	adrp	x8, _fclosure8_0_asm_h@PAGE
Lloh419:
	add	x8, x8, _fclosure8_0_asm_h@PAGEOFF
	str	x8, [x0, #1512]
Lloh420:
	adrp	x8, _push_empty_string_0_asm_h@PAGE
Lloh421:
	add	x8, x8, _push_empty_string_0_asm_h@PAGEOFF
	str	x8, [x0, #1520]
Lloh422:
	adrp	x8, _get_loc8_0_asm_h@PAGE
Lloh423:
	add	x8, x8, _get_loc8_0_asm_h@PAGEOFF
	str	x8, [x0, #1528]
Lloh424:
	adrp	x8, _put_loc8_0_asm_h@PAGE
Lloh425:
	add	x8, x8, _put_loc8_0_asm_h@PAGEOFF
	str	x8, [x0, #1536]
Lloh426:
	adrp	x8, _set_loc8_0_asm_h@PAGE
Lloh427:
	add	x8, x8, _set_loc8_0_asm_h@PAGEOFF
	str	x8, [x0, #1544]
Lloh428:
	adrp	x8, _get_loc0_0_asm_h@PAGE
Lloh429:
	add	x8, x8, _get_loc0_0_asm_h@PAGEOFF
	str	x8, [x0, #1552]
Lloh430:
	adrp	x8, _get_loc1_0_asm_h@PAGE
Lloh431:
	add	x8, x8, _get_loc1_0_asm_h@PAGEOFF
	str	x8, [x0, #1560]
Lloh432:
	adrp	x8, _get_loc2_0_asm_h@PAGE
Lloh433:
	add	x8, x8, _get_loc2_0_asm_h@PAGEOFF
	str	x8, [x0, #1568]
Lloh434:
	adrp	x8, _get_loc3_0_asm_h@PAGE
Lloh435:
	add	x8, x8, _get_loc3_0_asm_h@PAGEOFF
	str	x8, [x0, #1576]
Lloh436:
	adrp	x8, _put_loc0_0_asm_h@PAGE
Lloh437:
	add	x8, x8, _put_loc0_0_asm_h@PAGEOFF
	str	x8, [x0, #1584]
Lloh438:
	adrp	x8, _put_loc1_0_asm_h@PAGE
Lloh439:
	add	x8, x8, _put_loc1_0_asm_h@PAGEOFF
	str	x8, [x0, #1592]
Lloh440:
	adrp	x8, _put_loc2_0_asm_h@PAGE
Lloh441:
	add	x8, x8, _put_loc2_0_asm_h@PAGEOFF
	str	x8, [x0, #1600]
Lloh442:
	adrp	x8, _put_loc3_0_asm_h@PAGE
Lloh443:
	add	x8, x8, _put_loc3_0_asm_h@PAGEOFF
	str	x8, [x0, #1608]
Lloh444:
	adrp	x8, _set_loc0_0_asm_h@PAGE
Lloh445:
	add	x8, x8, _set_loc0_0_asm_h@PAGEOFF
	str	x8, [x0, #1616]
Lloh446:
	adrp	x8, _set_loc1_0_asm_h@PAGE
Lloh447:
	add	x8, x8, _set_loc1_0_asm_h@PAGEOFF
	str	x8, [x0, #1624]
Lloh448:
	adrp	x8, _set_loc2_0_asm_h@PAGE
Lloh449:
	add	x8, x8, _set_loc2_0_asm_h@PAGEOFF
	str	x8, [x0, #1632]
Lloh450:
	adrp	x8, _set_loc3_0_asm_h@PAGE
Lloh451:
	add	x8, x8, _set_loc3_0_asm_h@PAGEOFF
	str	x8, [x0, #1640]
Lloh452:
	adrp	x8, _get_arg0_0_asm_h@PAGE
Lloh453:
	add	x8, x8, _get_arg0_0_asm_h@PAGEOFF
	str	x8, [x0, #1648]
Lloh454:
	adrp	x8, _get_arg1_0_asm_h@PAGE
Lloh455:
	add	x8, x8, _get_arg1_0_asm_h@PAGEOFF
	str	x8, [x0, #1656]
Lloh456:
	adrp	x8, _get_arg2_0_asm_h@PAGE
Lloh457:
	add	x8, x8, _get_arg2_0_asm_h@PAGEOFF
	str	x8, [x0, #1664]
Lloh458:
	adrp	x8, _get_arg3_0_asm_h@PAGE
Lloh459:
	add	x8, x8, _get_arg3_0_asm_h@PAGEOFF
	str	x8, [x0, #1672]
Lloh460:
	adrp	x8, _put_arg0_0_asm_h@PAGE
Lloh461:
	add	x8, x8, _put_arg0_0_asm_h@PAGEOFF
	str	x8, [x0, #1680]
Lloh462:
	adrp	x8, _put_arg1_0_asm_h@PAGE
Lloh463:
	add	x8, x8, _put_arg1_0_asm_h@PAGEOFF
	str	x8, [x0, #1688]
Lloh464:
	adrp	x8, _put_arg2_0_asm_h@PAGE
Lloh465:
	add	x8, x8, _put_arg2_0_asm_h@PAGEOFF
	str	x8, [x0, #1696]
Lloh466:
	adrp	x8, _put_arg3_0_asm_h@PAGE
Lloh467:
	add	x8, x8, _put_arg3_0_asm_h@PAGEOFF
	str	x8, [x0, #1704]
Lloh468:
	adrp	x8, _set_arg0_0_asm_h@PAGE
Lloh469:
	add	x8, x8, _set_arg0_0_asm_h@PAGEOFF
	str	x8, [x0, #1712]
Lloh470:
	adrp	x8, _set_arg1_0_asm_h@PAGE
Lloh471:
	add	x8, x8, _set_arg1_0_asm_h@PAGEOFF
	str	x8, [x0, #1720]
Lloh472:
	adrp	x8, _set_arg2_0_asm_h@PAGE
Lloh473:
	add	x8, x8, _set_arg2_0_asm_h@PAGEOFF
	str	x8, [x0, #1728]
Lloh474:
	adrp	x8, _set_arg3_0_asm_h@PAGE
Lloh475:
	add	x8, x8, _set_arg3_0_asm_h@PAGEOFF
	str	x8, [x0, #1736]
Lloh476:
	adrp	x8, _get_var_ref0_0_asm_h@PAGE
Lloh477:
	add	x8, x8, _get_var_ref0_0_asm_h@PAGEOFF
	str	x8, [x0, #1744]
Lloh478:
	adrp	x8, _get_var_ref1_0_asm_h@PAGE
Lloh479:
	add	x8, x8, _get_var_ref1_0_asm_h@PAGEOFF
	str	x8, [x0, #1752]
Lloh480:
	adrp	x8, _get_var_ref2_0_asm_h@PAGE
Lloh481:
	add	x8, x8, _get_var_ref2_0_asm_h@PAGEOFF
	str	x8, [x0, #1760]
Lloh482:
	adrp	x8, _get_var_ref3_0_asm_h@PAGE
Lloh483:
	add	x8, x8, _get_var_ref3_0_asm_h@PAGEOFF
	str	x8, [x0, #1768]
Lloh484:
	adrp	x8, _put_var_ref0_0_asm_h@PAGE
Lloh485:
	add	x8, x8, _put_var_ref0_0_asm_h@PAGEOFF
	str	x8, [x0, #1776]
Lloh486:
	adrp	x8, _put_var_ref1_0_asm_h@PAGE
Lloh487:
	add	x8, x8, _put_var_ref1_0_asm_h@PAGEOFF
	str	x8, [x0, #1784]
Lloh488:
	adrp	x8, _put_var_ref2_0_asm_h@PAGE
Lloh489:
	add	x8, x8, _put_var_ref2_0_asm_h@PAGEOFF
	str	x8, [x0, #1792]
Lloh490:
	adrp	x8, _put_var_ref3_0_asm_h@PAGE
Lloh491:
	add	x8, x8, _put_var_ref3_0_asm_h@PAGEOFF
	str	x8, [x0, #1800]
Lloh492:
	adrp	x8, _set_var_ref0_0_asm_h@PAGE
Lloh493:
	add	x8, x8, _set_var_ref0_0_asm_h@PAGEOFF
	str	x8, [x0, #1808]
Lloh494:
	adrp	x8, _set_var_ref1_0_asm_h@PAGE
Lloh495:
	add	x8, x8, _set_var_ref1_0_asm_h@PAGEOFF
	str	x8, [x0, #1816]
Lloh496:
	adrp	x8, _set_var_ref2_0_asm_h@PAGE
Lloh497:
	add	x8, x8, _set_var_ref2_0_asm_h@PAGEOFF
	str	x8, [x0, #1824]
Lloh498:
	adrp	x8, _set_var_ref3_0_asm_h@PAGE
Lloh499:
	add	x8, x8, _set_var_ref3_0_asm_h@PAGEOFF
	str	x8, [x0, #1832]
Lloh500:
	adrp	x8, _get_length_0_asm_h@PAGE
Lloh501:
	add	x8, x8, _get_length_0_asm_h@PAGEOFF
	str	x8, [x0, #1840]
Lloh502:
	adrp	x8, _if_false8_0_asm_h@PAGE
Lloh503:
	add	x8, x8, _if_false8_0_asm_h@PAGEOFF
	str	x8, [x0, #1848]
Lloh504:
	adrp	x8, _if_true8_0_asm_h@PAGE
Lloh505:
	add	x8, x8, _if_true8_0_asm_h@PAGEOFF
	str	x8, [x0, #1856]
Lloh506:
	adrp	x8, _goto8_0_asm_h@PAGE
Lloh507:
	add	x8, x8, _goto8_0_asm_h@PAGEOFF
	str	x8, [x0, #1864]
Lloh508:
	adrp	x8, _goto16_0_asm_h@PAGE
Lloh509:
	add	x8, x8, _goto16_0_asm_h@PAGEOFF
	str	x8, [x0, #1872]
Lloh510:
	adrp	x8, _call0_0_asm_h@PAGE
Lloh511:
	add	x8, x8, _call0_0_asm_h@PAGEOFF
	str	x8, [x0, #1880]
Lloh512:
	adrp	x8, _call1_0_asm_h@PAGE
Lloh513:
	add	x8, x8, _call1_0_asm_h@PAGEOFF
	str	x8, [x0, #1888]
Lloh514:
	adrp	x8, _call2_0_asm_h@PAGE
Lloh515:
	add	x8, x8, _call2_0_asm_h@PAGEOFF
	str	x8, [x0, #1896]
Lloh516:
	adrp	x8, _call3_0_asm_h@PAGE
Lloh517:
	add	x8, x8, _call3_0_asm_h@PAGEOFF
	str	x8, [x0, #1904]
Lloh518:
	adrp	x8, _is_undefined_0_asm_h@PAGE
Lloh519:
	add	x8, x8, _is_undefined_0_asm_h@PAGEOFF
	str	x8, [x0, #1912]
Lloh520:
	adrp	x8, _is_null_0_asm_h@PAGE
Lloh521:
	add	x8, x8, _is_null_0_asm_h@PAGEOFF
	str	x8, [x0, #1920]
Lloh522:
	adrp	x8, _is_function_0_asm_h@PAGE
Lloh523:
	add	x8, x8, _is_function_0_asm_h@PAGEOFF
	str	x8, [x0, #1928]
Lloh524:
	adrp	x8, _inc_coverage_0_asm_h@PAGE
Lloh525:
	add	x8, x8, _inc_coverage_0_asm_h@PAGEOFF
	str	x8, [x0, #1936]
Lloh526:
	adrp	x8, _invalid_1_asm_h@PAGE
Lloh527:
	add	x8, x8, _invalid_1_asm_h@PAGEOFF
	str	x8, [x0, #1944]
Lloh528:
	adrp	x8, _push_i32_1_asm_h@PAGE
Lloh529:
	add	x8, x8, _push_i32_1_asm_h@PAGEOFF
	str	x8, [x0, #1952]
Lloh530:
	adrp	x8, _push_const_1_asm_h@PAGE
Lloh531:
	add	x8, x8, _push_const_1_asm_h@PAGEOFF
	str	x8, [x0, #1960]
Lloh532:
	adrp	x8, _fclosure_1_asm_h@PAGE
Lloh533:
	add	x8, x8, _fclosure_1_asm_h@PAGEOFF
	str	x8, [x0, #1968]
Lloh534:
	adrp	x8, _push_atom_value_1_asm_h@PAGE
Lloh535:
	add	x8, x8, _push_atom_value_1_asm_h@PAGEOFF
	str	x8, [x0, #1976]
Lloh536:
	adrp	x8, _private_symbol_1_asm_h@PAGE
Lloh537:
	add	x8, x8, _private_symbol_1_asm_h@PAGEOFF
	str	x8, [x0, #1984]
Lloh538:
	adrp	x8, _undefined_1_asm_h@PAGE
Lloh539:
	add	x8, x8, _undefined_1_asm_h@PAGEOFF
	str	x8, [x0, #1992]
Lloh540:
	adrp	x8, _null_1_asm_h@PAGE
Lloh541:
	add	x8, x8, _null_1_asm_h@PAGEOFF
	str	x8, [x0, #2000]
Lloh542:
	adrp	x8, _push_this_1_asm_h@PAGE
Lloh543:
	add	x8, x8, _push_this_1_asm_h@PAGEOFF
	str	x8, [x0, #2008]
Lloh544:
	adrp	x8, _push_false_1_asm_h@PAGE
Lloh545:
	add	x8, x8, _push_false_1_asm_h@PAGEOFF
	str	x8, [x0, #2016]
Lloh546:
	adrp	x8, _push_true_1_asm_h@PAGE
Lloh547:
	add	x8, x8, _push_true_1_asm_h@PAGEOFF
	str	x8, [x0, #2024]
Lloh548:
	adrp	x8, _object_1_asm_h@PAGE
Lloh549:
	add	x8, x8, _object_1_asm_h@PAGEOFF
	str	x8, [x0, #2032]
Lloh550:
	adrp	x8, _set_var_ref2_1_asm_h@PAGE
Lloh551:
	add	x8, x8, _set_var_ref2_1_asm_h@PAGEOFF
	str	x8, [x0, #3768]
Lloh552:
	adrp	x8, _set_var_ref1_1_asm_h@PAGE
Lloh553:
	add	x8, x8, _set_var_ref1_1_asm_h@PAGEOFF
	str	x8, [x0, #3760]
Lloh554:
	adrp	x8, _set_var_ref0_1_asm_h@PAGE
Lloh555:
	add	x8, x8, _set_var_ref0_1_asm_h@PAGEOFF
	str	x8, [x0, #3752]
Lloh556:
	adrp	x8, _put_var_ref3_1_asm_h@PAGE
Lloh557:
	add	x8, x8, _put_var_ref3_1_asm_h@PAGEOFF
	str	x8, [x0, #3744]
Lloh558:
	adrp	x8, _put_var_ref2_1_asm_h@PAGE
Lloh559:
	add	x8, x8, _put_var_ref2_1_asm_h@PAGEOFF
	str	x8, [x0, #3736]
Lloh560:
	adrp	x8, _put_var_ref1_1_asm_h@PAGE
Lloh561:
	add	x8, x8, _put_var_ref1_1_asm_h@PAGEOFF
	str	x8, [x0, #3728]
Lloh562:
	adrp	x8, _put_var_ref0_1_asm_h@PAGE
Lloh563:
	add	x8, x8, _put_var_ref0_1_asm_h@PAGEOFF
	str	x8, [x0, #3720]
Lloh564:
	adrp	x8, _get_var_ref3_1_asm_h@PAGE
Lloh565:
	add	x8, x8, _get_var_ref3_1_asm_h@PAGEOFF
	str	x8, [x0, #3712]
Lloh566:
	adrp	x8, _get_var_ref2_1_asm_h@PAGE
Lloh567:
	add	x8, x8, _get_var_ref2_1_asm_h@PAGEOFF
	str	x8, [x0, #3704]
Lloh568:
	adrp	x8, _get_var_ref1_1_asm_h@PAGE
Lloh569:
	add	x8, x8, _get_var_ref1_1_asm_h@PAGEOFF
	str	x8, [x0, #3696]
Lloh570:
	adrp	x8, _get_var_ref0_1_asm_h@PAGE
Lloh571:
	add	x8, x8, _get_var_ref0_1_asm_h@PAGEOFF
	str	x8, [x0, #3688]
Lloh572:
	adrp	x8, _set_arg3_1_asm_h@PAGE
Lloh573:
	add	x8, x8, _set_arg3_1_asm_h@PAGEOFF
	str	x8, [x0, #3680]
Lloh574:
	adrp	x8, _set_arg2_1_asm_h@PAGE
Lloh575:
	add	x8, x8, _set_arg2_1_asm_h@PAGEOFF
	str	x8, [x0, #3672]
Lloh576:
	adrp	x8, _set_arg1_1_asm_h@PAGE
Lloh577:
	add	x8, x8, _set_arg1_1_asm_h@PAGEOFF
	str	x8, [x0, #3664]
Lloh578:
	adrp	x8, _set_arg0_1_asm_h@PAGE
Lloh579:
	add	x8, x8, _set_arg0_1_asm_h@PAGEOFF
	str	x8, [x0, #3656]
Lloh580:
	adrp	x8, _put_arg3_1_asm_h@PAGE
Lloh581:
	add	x8, x8, _put_arg3_1_asm_h@PAGEOFF
	str	x8, [x0, #3648]
Lloh582:
	adrp	x8, _put_arg2_1_asm_h@PAGE
Lloh583:
	add	x8, x8, _put_arg2_1_asm_h@PAGEOFF
	str	x8, [x0, #3640]
Lloh584:
	adrp	x8, _put_arg1_1_asm_h@PAGE
Lloh585:
	add	x8, x8, _put_arg1_1_asm_h@PAGEOFF
	str	x8, [x0, #3632]
Lloh586:
	adrp	x8, _put_arg0_1_asm_h@PAGE
Lloh587:
	add	x8, x8, _put_arg0_1_asm_h@PAGEOFF
	str	x8, [x0, #3624]
Lloh588:
	adrp	x8, _get_arg3_1_asm_h@PAGE
Lloh589:
	add	x8, x8, _get_arg3_1_asm_h@PAGEOFF
	str	x8, [x0, #3616]
Lloh590:
	adrp	x8, _get_arg2_1_asm_h@PAGE
Lloh591:
	add	x8, x8, _get_arg2_1_asm_h@PAGEOFF
	str	x8, [x0, #3608]
Lloh592:
	adrp	x8, _get_arg1_1_asm_h@PAGE
Lloh593:
	add	x8, x8, _get_arg1_1_asm_h@PAGEOFF
	str	x8, [x0, #3600]
Lloh594:
	adrp	x8, _get_arg0_1_asm_h@PAGE
Lloh595:
	add	x8, x8, _get_arg0_1_asm_h@PAGEOFF
	str	x8, [x0, #3592]
Lloh596:
	adrp	x8, _set_loc3_1_asm_h@PAGE
Lloh597:
	add	x8, x8, _set_loc3_1_asm_h@PAGEOFF
	str	x8, [x0, #3584]
Lloh598:
	adrp	x8, _set_loc2_1_asm_h@PAGE
Lloh599:
	add	x8, x8, _set_loc2_1_asm_h@PAGEOFF
	str	x8, [x0, #3576]
Lloh600:
	adrp	x8, _set_loc1_1_asm_h@PAGE
Lloh601:
	add	x8, x8, _set_loc1_1_asm_h@PAGEOFF
	str	x8, [x0, #3568]
Lloh602:
	adrp	x8, _set_loc0_1_asm_h@PAGE
Lloh603:
	add	x8, x8, _set_loc0_1_asm_h@PAGEOFF
	str	x8, [x0, #3560]
Lloh604:
	adrp	x8, _put_loc3_1_asm_h@PAGE
Lloh605:
	add	x8, x8, _put_loc3_1_asm_h@PAGEOFF
	str	x8, [x0, #3552]
Lloh606:
	adrp	x8, _put_loc2_1_asm_h@PAGE
Lloh607:
	add	x8, x8, _put_loc2_1_asm_h@PAGEOFF
	str	x8, [x0, #3544]
Lloh608:
	adrp	x8, _put_loc1_1_asm_h@PAGE
Lloh609:
	add	x8, x8, _put_loc1_1_asm_h@PAGEOFF
	str	x8, [x0, #3536]
Lloh610:
	adrp	x8, _put_loc0_1_asm_h@PAGE
Lloh611:
	add	x8, x8, _put_loc0_1_asm_h@PAGEOFF
	str	x8, [x0, #3528]
Lloh612:
	adrp	x8, _get_loc3_1_asm_h@PAGE
Lloh613:
	add	x8, x8, _get_loc3_1_asm_h@PAGEOFF
	str	x8, [x0, #3520]
Lloh614:
	adrp	x8, _get_loc2_1_asm_h@PAGE
Lloh615:
	add	x8, x8, _get_loc2_1_asm_h@PAGEOFF
	str	x8, [x0, #3512]
Lloh616:
	adrp	x8, _get_loc1_1_asm_h@PAGE
Lloh617:
	add	x8, x8, _get_loc1_1_asm_h@PAGEOFF
	str	x8, [x0, #3504]
Lloh618:
	adrp	x8, _get_loc0_1_asm_h@PAGE
Lloh619:
	add	x8, x8, _get_loc0_1_asm_h@PAGEOFF
	str	x8, [x0, #3496]
Lloh620:
	adrp	x8, _set_loc8_1_asm_h@PAGE
Lloh621:
	add	x8, x8, _set_loc8_1_asm_h@PAGEOFF
	str	x8, [x0, #3488]
Lloh622:
	adrp	x8, _put_loc8_1_asm_h@PAGE
Lloh623:
	add	x8, x8, _put_loc8_1_asm_h@PAGEOFF
	str	x8, [x0, #3480]
Lloh624:
	adrp	x8, _get_loc8_1_asm_h@PAGE
Lloh625:
	add	x8, x8, _get_loc8_1_asm_h@PAGEOFF
	str	x8, [x0, #3472]
Lloh626:
	adrp	x8, _push_empty_string_1_asm_h@PAGE
Lloh627:
	add	x8, x8, _push_empty_string_1_asm_h@PAGEOFF
	str	x8, [x0, #3464]
Lloh628:
	adrp	x8, _fclosure8_1_asm_h@PAGE
Lloh629:
	add	x8, x8, _fclosure8_1_asm_h@PAGEOFF
	str	x8, [x0, #3456]
Lloh630:
	adrp	x8, _push_const8_1_asm_h@PAGE
Lloh631:
	add	x8, x8, _push_const8_1_asm_h@PAGEOFF
	str	x8, [x0, #3448]
Lloh632:
	adrp	x8, _push_i16_1_asm_h@PAGE
Lloh633:
	add	x8, x8, _push_i16_1_asm_h@PAGEOFF
	str	x8, [x0, #3440]
Lloh634:
	adrp	x8, _push_i8_1_asm_h@PAGE
Lloh635:
	add	x8, x8, _push_i8_1_asm_h@PAGEOFF
	str	x8, [x0, #3432]
Lloh636:
	adrp	x8, _push_7_1_asm_h@PAGE
Lloh637:
	add	x8, x8, _push_7_1_asm_h@PAGEOFF
	str	x8, [x0, #3424]
Lloh638:
	adrp	x8, _push_6_1_asm_h@PAGE
Lloh639:
	add	x8, x8, _push_6_1_asm_h@PAGEOFF
	str	x8, [x0, #3416]
Lloh640:
	adrp	x8, _push_5_1_asm_h@PAGE
Lloh641:
	add	x8, x8, _push_5_1_asm_h@PAGEOFF
	str	x8, [x0, #3408]
Lloh642:
	adrp	x8, _push_4_1_asm_h@PAGE
Lloh643:
	add	x8, x8, _push_4_1_asm_h@PAGEOFF
	str	x8, [x0, #3400]
Lloh644:
	adrp	x8, _push_3_1_asm_h@PAGE
Lloh645:
	add	x8, x8, _push_3_1_asm_h@PAGEOFF
	str	x8, [x0, #3392]
Lloh646:
	adrp	x8, _push_2_1_asm_h@PAGE
Lloh647:
	add	x8, x8, _push_2_1_asm_h@PAGEOFF
	str	x8, [x0, #3384]
Lloh648:
	adrp	x8, _push_1_1_asm_h@PAGE
Lloh649:
	add	x8, x8, _push_1_1_asm_h@PAGEOFF
	str	x8, [x0, #3376]
Lloh650:
	adrp	x8, _push_0_1_asm_h@PAGE
Lloh651:
	add	x8, x8, _push_0_1_asm_h@PAGEOFF
	str	x8, [x0, #3368]
Lloh652:
	adrp	x8, _push_minus1_1_asm_h@PAGE
Lloh653:
	add	x8, x8, _push_minus1_1_asm_h@PAGEOFF
	str	x8, [x0, #3360]
Lloh654:
	adrp	x8, _nop_1_asm_h@PAGE
Lloh655:
	add	x8, x8, _nop_1_asm_h@PAGEOFF
	str	x8, [x0, #3352]
Lloh656:
	adrp	x8, _or_1_asm_h@PAGE
Lloh657:
	add	x8, x8, _or_1_asm_h@PAGEOFF
	str	x8, [x0, #3344]
Lloh658:
	adrp	x8, _xor_1_asm_h@PAGE
Lloh659:
	add	x8, x8, _xor_1_asm_h@PAGEOFF
	str	x8, [x0, #3336]
Lloh660:
	adrp	x8, _and_1_asm_h@PAGE
Lloh661:
	add	x8, x8, _and_1_asm_h@PAGEOFF
	str	x8, [x0, #3328]
Lloh662:
	adrp	x8, _strict_neq_1_asm_h@PAGE
Lloh663:
	add	x8, x8, _strict_neq_1_asm_h@PAGEOFF
	str	x8, [x0, #3320]
Lloh664:
	adrp	x8, _strict_eq_1_asm_h@PAGE
Lloh665:
	add	x8, x8, _strict_eq_1_asm_h@PAGEOFF
	str	x8, [x0, #3312]
Lloh666:
	adrp	x8, _neq_1_asm_h@PAGE
Lloh667:
	add	x8, x8, _neq_1_asm_h@PAGEOFF
	str	x8, [x0, #3304]
Lloh668:
	adrp	x8, _eq_1_asm_h@PAGE
Lloh669:
	add	x8, x8, _eq_1_asm_h@PAGEOFF
	str	x8, [x0, #3296]
Lloh670:
	adrp	x8, _in_1_asm_h@PAGE
Lloh671:
	add	x8, x8, _in_1_asm_h@PAGEOFF
	str	x8, [x0, #3288]
Lloh672:
	adrp	x8, _instanceof_1_asm_h@PAGE
Lloh673:
	add	x8, x8, _instanceof_1_asm_h@PAGEOFF
	str	x8, [x0, #3280]
Lloh674:
	adrp	x8, _gte_1_asm_h@PAGE
Lloh675:
	add	x8, x8, _gte_1_asm_h@PAGEOFF
	str	x8, [x0, #3272]
Lloh676:
	adrp	x8, _gt_1_asm_h@PAGE
Lloh677:
	add	x8, x8, _gt_1_asm_h@PAGEOFF
	str	x8, [x0, #3264]
Lloh678:
	adrp	x8, _lte_1_asm_h@PAGE
Lloh679:
	add	x8, x8, _lte_1_asm_h@PAGEOFF
	str	x8, [x0, #3256]
Lloh680:
	adrp	x8, _lt_1_asm_h@PAGE
Lloh681:
	add	x8, x8, _lt_1_asm_h@PAGEOFF
	str	x8, [x0, #3248]
Lloh682:
	adrp	x8, _shr_1_asm_h@PAGE
Lloh683:
	add	x8, x8, _shr_1_asm_h@PAGEOFF
	str	x8, [x0, #3240]
Lloh684:
	adrp	x8, _sar_1_asm_h@PAGE
Lloh685:
	add	x8, x8, _sar_1_asm_h@PAGEOFF
	str	x8, [x0, #3232]
Lloh686:
	adrp	x8, _shl_1_asm_h@PAGE
Lloh687:
	add	x8, x8, _shl_1_asm_h@PAGEOFF
	str	x8, [x0, #3224]
Lloh688:
	adrp	x8, _pow_1_asm_h@PAGE
Lloh689:
	add	x8, x8, _pow_1_asm_h@PAGEOFF
	str	x8, [x0, #3216]
Lloh690:
	adrp	x8, _sub_1_asm_h@PAGE
Lloh691:
	add	x8, x8, _sub_1_asm_h@PAGEOFF
	str	x8, [x0, #3208]
Lloh692:
	adrp	x8, _add_1_asm_h@PAGE
Lloh693:
	add	x8, x8, _add_1_asm_h@PAGEOFF
	str	x8, [x0, #3200]
Lloh694:
	adrp	x8, _mod_1_asm_h@PAGE
Lloh695:
	add	x8, x8, _mod_1_asm_h@PAGEOFF
	str	x8, [x0, #3192]
Lloh696:
	adrp	x8, _div_1_asm_h@PAGE
Lloh697:
	add	x8, x8, _div_1_asm_h@PAGEOFF
	str	x8, [x0, #3184]
Lloh698:
	adrp	x8, _mul_1_asm_h@PAGE
Lloh699:
	add	x8, x8, _mul_1_asm_h@PAGEOFF
	str	x8, [x0, #3176]
Lloh700:
	adrp	x8, _delete_var_1_asm_h@PAGE
Lloh701:
	add	x8, x8, _delete_var_1_asm_h@PAGEOFF
	str	x8, [x0, #3168]
Lloh702:
	adrp	x8, _delete_1_asm_h@PAGE
Lloh703:
	add	x8, x8, _delete_1_asm_h@PAGEOFF
	str	x8, [x0, #3160]
Lloh704:
	adrp	x8, _typeof_1_asm_h@PAGE
Lloh705:
	add	x8, x8, _typeof_1_asm_h@PAGEOFF
	str	x8, [x0, #3152]
Lloh706:
	adrp	x8, _lnot_1_asm_h@PAGE
Lloh707:
	add	x8, x8, _lnot_1_asm_h@PAGEOFF
	str	x8, [x0, #3144]
Lloh708:
	adrp	x8, _not_1_asm_h@PAGE
Lloh709:
	add	x8, x8, _not_1_asm_h@PAGEOFF
	str	x8, [x0, #3136]
Lloh710:
	adrp	x8, _add_loc_1_asm_h@PAGE
Lloh711:
	add	x8, x8, _add_loc_1_asm_h@PAGEOFF
	str	x8, [x0, #3128]
Lloh712:
	adrp	x8, _inc_loc_1_asm_h@PAGE
Lloh713:
	add	x8, x8, _inc_loc_1_asm_h@PAGEOFF
	str	x8, [x0, #3120]
Lloh714:
	adrp	x8, _dec_loc_1_asm_h@PAGE
Lloh715:
	add	x8, x8, _dec_loc_1_asm_h@PAGEOFF
	str	x8, [x0, #3112]
Lloh716:
	adrp	x8, _post_inc_1_asm_h@PAGE
Lloh717:
	add	x8, x8, _post_inc_1_asm_h@PAGEOFF
	str	x8, [x0, #3104]
Lloh718:
	adrp	x8, _post_dec_1_asm_h@PAGE
Lloh719:
	add	x8, x8, _post_dec_1_asm_h@PAGEOFF
	str	x8, [x0, #3096]
Lloh720:
	adrp	x8, _inc_1_asm_h@PAGE
Lloh721:
	add	x8, x8, _inc_1_asm_h@PAGEOFF
	str	x8, [x0, #3088]
Lloh722:
	adrp	x8, _dec_1_asm_h@PAGE
Lloh723:
	add	x8, x8, _dec_1_asm_h@PAGEOFF
	str	x8, [x0, #3080]
Lloh724:
	adrp	x8, _plus_1_asm_h@PAGE
Lloh725:
	add	x8, x8, _plus_1_asm_h@PAGEOFF
	str	x8, [x0, #3072]
Lloh726:
	adrp	x8, _neg_1_asm_h@PAGE
Lloh727:
	add	x8, x8, _neg_1_asm_h@PAGEOFF
	str	x8, [x0, #3064]
Lloh728:
	adrp	x8, _await_1_asm_h@PAGE
Lloh729:
	add	x8, x8, _await_1_asm_h@PAGEOFF
	str	x8, [x0, #3056]
Lloh730:
	adrp	x8, _async_yield_star_1_asm_h@PAGE
Lloh731:
	add	x8, x8, _async_yield_star_1_asm_h@PAGEOFF
	str	x8, [x0, #3048]
Lloh732:
	adrp	x8, _yield_star_1_asm_h@PAGE
Lloh733:
	add	x8, x8, _yield_star_1_asm_h@PAGEOFF
	str	x8, [x0, #3040]
Lloh734:
	adrp	x8, _yield_1_asm_h@PAGE
Lloh735:
	add	x8, x8, _yield_1_asm_h@PAGEOFF
	str	x8, [x0, #3032]
Lloh736:
	adrp	x8, _initial_yield_1_asm_h@PAGE
Lloh737:
	add	x8, x8, _initial_yield_1_asm_h@PAGEOFF
	str	x8, [x0, #3024]
Lloh738:
	adrp	x8, _async_iterator_get_1_asm_h@PAGE
Lloh739:
	add	x8, x8, _async_iterator_get_1_asm_h@PAGEOFF
	str	x8, [x0, #3016]
Lloh740:
	adrp	x8, _async_iterator_next_1_asm_h@PAGE
Lloh741:
	add	x8, x8, _async_iterator_next_1_asm_h@PAGEOFF
	str	x8, [x0, #3008]
Lloh742:
	adrp	x8, _async_iterator_close_1_asm_h@PAGE
Lloh743:
	add	x8, x8, _async_iterator_close_1_asm_h@PAGEOFF
	str	x8, [x0, #3000]
Lloh744:
	adrp	x8, _iterator_close_return_1_asm_h@PAGE
Lloh745:
	add	x8, x8, _iterator_close_return_1_asm_h@PAGEOFF
	str	x8, [x0, #2992]
Lloh746:
	adrp	x8, _iterator_close_1_asm_h@PAGE
Lloh747:
	add	x8, x8, _iterator_close_1_asm_h@PAGEOFF
	str	x8, [x0, #2984]
Lloh748:
	adrp	x8, _iterator_get_value_done_1_asm_h@PAGE
Lloh749:
	add	x8, x8, _iterator_get_value_done_1_asm_h@PAGEOFF
	str	x8, [x0, #2976]
Lloh750:
	adrp	x8, _for_await_of_next_1_asm_h@PAGE
Lloh751:
	add	x8, x8, _for_await_of_next_1_asm_h@PAGEOFF
	str	x8, [x0, #2968]
Lloh752:
	adrp	x8, _for_of_next_1_asm_h@PAGE
Lloh753:
	add	x8, x8, _for_of_next_1_asm_h@PAGEOFF
	str	x8, [x0, #2960]
Lloh754:
	adrp	x8, _for_in_next_1_asm_h@PAGE
Lloh755:
	add	x8, x8, _for_in_next_1_asm_h@PAGEOFF
	str	x8, [x0, #2952]
Lloh756:
	adrp	x8, _for_await_of_start_1_asm_h@PAGE
Lloh757:
	add	x8, x8, _for_await_of_start_1_asm_h@PAGEOFF
	str	x8, [x0, #2944]
Lloh758:
	adrp	x8, _for_of_start_1_asm_h@PAGE
Lloh759:
	add	x8, x8, _for_of_start_1_asm_h@PAGEOFF
	str	x8, [x0, #2936]
Lloh760:
	adrp	x8, _for_in_start_1_asm_h@PAGE
Lloh761:
	add	x8, x8, _for_in_start_1_asm_h@PAGEOFF
	str	x8, [x0, #2928]
Lloh762:
	adrp	x8, _make_var_ref_1_asm_h@PAGE
Lloh763:
	add	x8, x8, _make_var_ref_1_asm_h@PAGEOFF
	str	x8, [x0, #2920]
Lloh764:
	adrp	x8, _make_var_ref_ref_1_asm_h@PAGE
Lloh765:
	add	x8, x8, _make_var_ref_ref_1_asm_h@PAGEOFF
	str	x8, [x0, #2912]
Lloh766:
	adrp	x8, _make_arg_ref_1_asm_h@PAGE
Lloh767:
	add	x8, x8, _make_arg_ref_1_asm_h@PAGEOFF
	str	x8, [x0, #2904]
Lloh768:
	adrp	x8, _make_loc_ref_1_asm_h@PAGE
Lloh769:
	add	x8, x8, _make_loc_ref_1_asm_h@PAGEOFF
	str	x8, [x0, #2896]
Lloh770:
	adrp	x8, _with_get_ref_undef_1_asm_h@PAGE
Lloh771:
	add	x8, x8, _with_get_ref_undef_1_asm_h@PAGEOFF
	str	x8, [x0, #2888]
Lloh772:
	adrp	x8, _with_get_ref_1_asm_h@PAGE
Lloh773:
	add	x8, x8, _with_get_ref_1_asm_h@PAGEOFF
	str	x8, [x0, #2880]
Lloh774:
	adrp	x8, _with_make_ref_1_asm_h@PAGE
Lloh775:
	add	x8, x8, _with_make_ref_1_asm_h@PAGEOFF
	str	x8, [x0, #2872]
Lloh776:
	adrp	x8, _with_delete_var_1_asm_h@PAGE
Lloh777:
	add	x8, x8, _with_delete_var_1_asm_h@PAGEOFF
	str	x8, [x0, #2864]
Lloh778:
	adrp	x8, _with_put_var_1_asm_h@PAGE
Lloh779:
	add	x8, x8, _with_put_var_1_asm_h@PAGEOFF
	str	x8, [x0, #2856]
Lloh780:
	adrp	x8, _with_get_var_1_asm_h@PAGE
Lloh781:
	add	x8, x8, _with_get_var_1_asm_h@PAGEOFF
	str	x8, [x0, #2848]
Lloh782:
	adrp	x8, _to_propkey2_1_asm_h@PAGE
Lloh783:
	add	x8, x8, _to_propkey2_1_asm_h@PAGEOFF
	str	x8, [x0, #2840]
Lloh784:
	adrp	x8, _to_propkey_1_asm_h@PAGE
Lloh785:
	add	x8, x8, _to_propkey_1_asm_h@PAGEOFF
	str	x8, [x0, #2832]
Lloh786:
	adrp	x8, _to_object_1_asm_h@PAGE
Lloh787:
	add	x8, x8, _to_object_1_asm_h@PAGEOFF
	str	x8, [x0, #2824]
Lloh788:
	adrp	x8, _ret_1_asm_h@PAGE
Lloh789:
	add	x8, x8, _ret_1_asm_h@PAGEOFF
	str	x8, [x0, #2816]
Lloh790:
	adrp	x8, _gosub_1_asm_h@PAGE
Lloh791:
	add	x8, x8, _gosub_1_asm_h@PAGEOFF
	str	x8, [x0, #2808]
Lloh792:
	adrp	x8, _catch_1_asm_h@PAGE
Lloh793:
	add	x8, x8, _catch_1_asm_h@PAGEOFF
	str	x8, [x0, #2800]
Lloh794:
	adrp	x8, _goto_1_asm_h@PAGE
Lloh795:
	add	x8, x8, _goto_1_asm_h@PAGEOFF
	str	x8, [x0, #2792]
Lloh796:
	adrp	x8, _if_true_1_asm_h@PAGE
Lloh797:
	add	x8, x8, _if_true_1_asm_h@PAGEOFF
	str	x8, [x0, #2784]
Lloh798:
	adrp	x8, _if_false_1_asm_h@PAGE
Lloh799:
	add	x8, x8, _if_false_1_asm_h@PAGEOFF
	str	x8, [x0, #2776]
Lloh800:
	adrp	x8, _close_loc_1_asm_h@PAGE
Lloh801:
	add	x8, x8, _close_loc_1_asm_h@PAGEOFF
	str	x8, [x0, #2768]
Lloh802:
	adrp	x8, _put_var_ref_check_init_1_asm_h@PAGE
Lloh803:
	add	x8, x8, _put_var_ref_check_init_1_asm_h@PAGEOFF
	str	x8, [x0, #2760]
Lloh804:
	adrp	x8, _put_var_ref_check_1_asm_h@PAGE
Lloh805:
	add	x8, x8, _put_var_ref_check_1_asm_h@PAGEOFF
	str	x8, [x0, #2752]
Lloh806:
	adrp	x8, _get_var_ref_check_1_asm_h@PAGE
Lloh807:
	add	x8, x8, _get_var_ref_check_1_asm_h@PAGEOFF
	str	x8, [x0, #2744]
Lloh808:
	adrp	x8, _put_loc_check_init_1_asm_h@PAGE
Lloh809:
	add	x8, x8, _put_loc_check_init_1_asm_h@PAGEOFF
	str	x8, [x0, #2736]
Lloh810:
	adrp	x8, _put_loc_check_1_asm_h@PAGE
Lloh811:
	add	x8, x8, _put_loc_check_1_asm_h@PAGEOFF
	str	x8, [x0, #2728]
Lloh812:
	adrp	x8, _get_loc_check_1_asm_h@PAGE
Lloh813:
	add	x8, x8, _get_loc_check_1_asm_h@PAGEOFF
	str	x8, [x0, #2720]
Lloh814:
	adrp	x8, _set_loc_uninitialized_1_asm_h@PAGE
Lloh815:
	add	x8, x8, _set_loc_uninitialized_1_asm_h@PAGEOFF
	str	x8, [x0, #2712]
Lloh816:
	adrp	x8, _set_var_ref_1_asm_h@PAGE
Lloh817:
	add	x8, x8, _set_var_ref_1_asm_h@PAGEOFF
	str	x8, [x0, #2704]
Lloh818:
	adrp	x8, _put_var_ref_1_asm_h@PAGE
Lloh819:
	add	x8, x8, _put_var_ref_1_asm_h@PAGEOFF
	str	x8, [x0, #2696]
Lloh820:
	adrp	x8, _get_var_ref_1_asm_h@PAGE
Lloh821:
	add	x8, x8, _get_var_ref_1_asm_h@PAGEOFF
	str	x8, [x0, #2688]
Lloh822:
	adrp	x8, _set_arg_1_asm_h@PAGE
Lloh823:
	add	x8, x8, _set_arg_1_asm_h@PAGEOFF
	str	x8, [x0, #2680]
Lloh824:
	adrp	x8, _put_arg_1_asm_h@PAGE
Lloh825:
	add	x8, x8, _put_arg_1_asm_h@PAGEOFF
	str	x8, [x0, #2672]
Lloh826:
	adrp	x8, _get_arg_1_asm_h@PAGE
Lloh827:
	add	x8, x8, _get_arg_1_asm_h@PAGEOFF
	str	x8, [x0, #2664]
Lloh828:
	adrp	x8, _set_loc_1_asm_h@PAGE
Lloh829:
	add	x8, x8, _set_loc_1_asm_h@PAGEOFF
	str	x8, [x0, #2656]
Lloh830:
	adrp	x8, _put_loc_1_asm_h@PAGE
Lloh831:
	add	x8, x8, _put_loc_1_asm_h@PAGEOFF
	str	x8, [x0, #2648]
Lloh832:
	adrp	x8, _get_loc_1_asm_h@PAGE
Lloh833:
	add	x8, x8, _get_loc_1_asm_h@PAGEOFF
	str	x8, [x0, #2640]
Lloh834:
	adrp	x8, _define_class_1_asm_h@PAGE
Lloh835:
	add	x8, x8, _define_class_1_asm_h@PAGEOFF
	str	x8, [x0, #2632]
Lloh836:
	adrp	x8, _define_method_computed_1_asm_h@PAGE
Lloh837:
	add	x8, x8, _define_method_computed_1_asm_h@PAGEOFF
	str	x8, [x0, #2624]
Lloh838:
	adrp	x8, _define_method_1_asm_h@PAGE
Lloh839:
	add	x8, x8, _define_method_1_asm_h@PAGEOFF
	str	x8, [x0, #2616]
Lloh840:
	adrp	x8, _copy_data_properties_1_asm_h@PAGE
Lloh841:
	add	x8, x8, _copy_data_properties_1_asm_h@PAGEOFF
	str	x8, [x0, #2608]
Lloh842:
	adrp	x8, _append_1_asm_h@PAGE
Lloh843:
	add	x8, x8, _append_1_asm_h@PAGEOFF
	str	x8, [x0, #2600]
Lloh844:
	adrp	x8, _define_array_el_1_asm_h@PAGE
Lloh845:
	add	x8, x8, _define_array_el_1_asm_h@PAGEOFF
	str	x8, [x0, #2592]
Lloh846:
	adrp	x8, _set_home_object_1_asm_h@PAGE
Lloh847:
	add	x8, x8, _set_home_object_1_asm_h@PAGEOFF
	str	x8, [x0, #2584]
Lloh848:
	adrp	x8, _set_proto_1_asm_h@PAGE
Lloh849:
	add	x8, x8, _set_proto_1_asm_h@PAGEOFF
	str	x8, [x0, #2576]
Lloh850:
	adrp	x8, _set_name_computed_1_asm_h@PAGE
Lloh851:
	add	x8, x8, _set_name_computed_1_asm_h@PAGEOFF
	str	x8, [x0, #2568]
Lloh852:
	adrp	x8, _set_name_1_asm_h@PAGE
Lloh853:
	add	x8, x8, _set_name_1_asm_h@PAGEOFF
	str	x8, [x0, #2560]
Lloh854:
	adrp	x8, _define_field_1_asm_h@PAGE
Lloh855:
	add	x8, x8, _define_field_1_asm_h@PAGEOFF
	str	x8, [x0, #2552]
Lloh856:
	adrp	x8, _put_super_value_1_asm_h@PAGE
Lloh857:
	add	x8, x8, _put_super_value_1_asm_h@PAGEOFF
	str	x8, [x0, #2544]
Lloh858:
	adrp	x8, _get_super_value_1_asm_h@PAGE
Lloh859:
	add	x8, x8, _get_super_value_1_asm_h@PAGEOFF
	str	x8, [x0, #2536]
Lloh860:
	adrp	x8, _put_array_el_1_asm_h@PAGE
Lloh861:
	add	x8, x8, _put_array_el_1_asm_h@PAGEOFF
	str	x8, [x0, #2528]
Lloh862:
	adrp	x8, _get_array_el2_1_asm_h@PAGE
Lloh863:
	add	x8, x8, _get_array_el2_1_asm_h@PAGEOFF
	str	x8, [x0, #2520]
Lloh864:
	adrp	x8, _get_array_el_1_asm_h@PAGE
Lloh865:
	add	x8, x8, _get_array_el_1_asm_h@PAGEOFF
	str	x8, [x0, #2512]
Lloh866:
	adrp	x8, _define_private_field_1_asm_h@PAGE
Lloh867:
	add	x8, x8, _define_private_field_1_asm_h@PAGEOFF
	str	x8, [x0, #2504]
Lloh868:
	adrp	x8, _put_private_field_1_asm_h@PAGE
Lloh869:
	add	x8, x8, _put_private_field_1_asm_h@PAGEOFF
	str	x8, [x0, #2496]
Lloh870:
	adrp	x8, _get_private_field_1_asm_h@PAGE
Lloh871:
	add	x8, x8, _get_private_field_1_asm_h@PAGEOFF
	str	x8, [x0, #2488]
Lloh872:
	adrp	x8, _put_field_1_asm_h@PAGE
Lloh873:
	add	x8, x8, _put_field_1_asm_h@PAGEOFF
	str	x8, [x0, #2480]
Lloh874:
	adrp	x8, _get_field2_1_asm_h@PAGE
Lloh875:
	add	x8, x8, _get_field2_1_asm_h@PAGEOFF
	str	x8, [x0, #2472]
Lloh876:
	adrp	x8, _get_field_1_asm_h@PAGE
Lloh877:
	add	x8, x8, _get_field_1_asm_h@PAGEOFF
	str	x8, [x0, #2464]
Lloh878:
	adrp	x8, _define_func_1_asm_h@PAGE
Lloh879:
	add	x8, x8, _define_func_1_asm_h@PAGEOFF
	str	x8, [x0, #2456]
Lloh880:
	adrp	x8, _check_define_var_1_asm_h@PAGE
Lloh881:
	add	x8, x8, _check_define_var_1_asm_h@PAGEOFF
	str	x8, [x0, #2448]
Lloh882:
	adrp	x8, _define_var_1_asm_h@PAGE
Lloh883:
	add	x8, x8, _define_var_1_asm_h@PAGEOFF
	str	x8, [x0, #2440]
Lloh884:
	adrp	x8, _put_ref_value_1_asm_h@PAGE
Lloh885:
	add	x8, x8, _put_ref_value_1_asm_h@PAGEOFF
	str	x8, [x0, #2432]
Lloh886:
	adrp	x8, _get_ref_value_1_asm_h@PAGE
Lloh887:
	add	x8, x8, _get_ref_value_1_asm_h@PAGEOFF
	str	x8, [x0, #2424]
Lloh888:
	adrp	x8, _put_var_strict_1_asm_h@PAGE
Lloh889:
	add	x8, x8, _put_var_strict_1_asm_h@PAGEOFF
	str	x8, [x0, #2416]
Lloh890:
	adrp	x8, _put_var_init_1_asm_h@PAGE
Lloh891:
	add	x8, x8, _put_var_init_1_asm_h@PAGEOFF
	str	x8, [x0, #2408]
Lloh892:
	adrp	x8, _put_var_1_asm_h@PAGE
Lloh893:
	add	x8, x8, _put_var_1_asm_h@PAGEOFF
	str	x8, [x0, #2400]
Lloh894:
	adrp	x8, _get_var_1_asm_h@PAGE
Lloh895:
	add	x8, x8, _get_var_1_asm_h@PAGEOFF
	str	x8, [x0, #2392]
Lloh896:
	adrp	x8, _get_var_undef_1_asm_h@PAGE
Lloh897:
	add	x8, x8, _get_var_undef_1_asm_h@PAGEOFF
	str	x8, [x0, #2384]
Lloh898:
	adrp	x8, _check_var_1_asm_h@PAGE
Lloh899:
	add	x8, x8, _check_var_1_asm_h@PAGEOFF
	str	x8, [x0, #2376]
Lloh900:
	adrp	x8, _import_1_asm_h@PAGE
Lloh901:
	add	x8, x8, _import_1_asm_h@PAGEOFF
	str	x8, [x0, #2368]
Lloh902:
	adrp	x8, _get_super_1_asm_h@PAGE
Lloh903:
	add	x8, x8, _get_super_1_asm_h@PAGEOFF
	str	x8, [x0, #2360]
Lloh904:
	adrp	x8, _get_super_ctor_1_asm_h@PAGE
Lloh905:
	add	x8, x8, _get_super_ctor_1_asm_h@PAGEOFF
	str	x8, [x0, #2352]
Lloh906:
	adrp	x8, _regexp_1_asm_h@PAGE
Lloh907:
	add	x8, x8, _regexp_1_asm_h@PAGEOFF
	str	x8, [x0, #2344]
Lloh908:
	adrp	x8, _eval_1_asm_h@PAGE
Lloh909:
	add	x8, x8, _eval_1_asm_h@PAGEOFF
	str	x8, [x0, #2336]
Lloh910:
	adrp	x8, _throw_var_1_asm_h@PAGE
Lloh911:
	add	x8, x8, _throw_var_1_asm_h@PAGEOFF
	str	x8, [x0, #2328]
Lloh912:
	adrp	x8, _throw_1_asm_h@PAGE
Lloh913:
	add	x8, x8, _throw_1_asm_h@PAGEOFF
	str	x8, [x0, #2320]
Lloh914:
	adrp	x8, _return_async_1_asm_h@PAGE
Lloh915:
	add	x8, x8, _return_async_1_asm_h@PAGEOFF
	str	x8, [x0, #2312]
Lloh916:
	adrp	x8, _add_brand_1_asm_h@PAGE
Lloh917:
	add	x8, x8, _add_brand_1_asm_h@PAGEOFF
	str	x8, [x0, #2304]
Lloh918:
	adrp	x8, _check_brand_1_asm_h@PAGE
Lloh919:
	add	x8, x8, _check_brand_1_asm_h@PAGEOFF
	str	x8, [x0, #2296]
Lloh920:
	adrp	x8, _check_ctor_1_asm_h@PAGE
Lloh921:
	add	x8, x8, _check_ctor_1_asm_h@PAGEOFF
	str	x8, [x0, #2288]
Lloh922:
	adrp	x8, _check_ctor_return_1_asm_h@PAGE
Lloh923:
	add	x8, x8, _check_ctor_return_1_asm_h@PAGEOFF
	str	x8, [x0, #2280]
Lloh924:
	adrp	x8, _return_undef_1_asm_h@PAGE
Lloh925:
	add	x8, x8, _return_undef_1_asm_h@PAGEOFF
	str	x8, [x0, #2272]
Lloh926:
	adrp	x8, _return_1_asm_h@PAGE
Lloh927:
	add	x8, x8, _return_1_asm_h@PAGEOFF
	str	x8, [x0, #2264]
Lloh928:
	adrp	x8, _apply_1_asm_h@PAGE
Lloh929:
	add	x8, x8, _apply_1_asm_h@PAGEOFF
	str	x8, [x0, #2256]
Lloh930:
	adrp	x8, _array_from_1_asm_h@PAGE
Lloh931:
	add	x8, x8, _array_from_1_asm_h@PAGEOFF
	str	x8, [x0, #2248]
Lloh932:
	adrp	x8, _tail_call_method_1_asm_h@PAGE
Lloh933:
	add	x8, x8, _tail_call_method_1_asm_h@PAGEOFF
	str	x8, [x0, #2240]
Lloh934:
	adrp	x8, _call_method_1_asm_h@PAGE
Lloh935:
	add	x8, x8, _call_method_1_asm_h@PAGEOFF
	str	x8, [x0, #2232]
Lloh936:
	adrp	x8, _tail_call_1_asm_h@PAGE
Lloh937:
	add	x8, x8, _tail_call_1_asm_h@PAGEOFF
	str	x8, [x0, #2224]
Lloh938:
	adrp	x8, _call_1_asm_h@PAGE
Lloh939:
	add	x8, x8, _call_1_asm_h@PAGEOFF
	str	x8, [x0, #2216]
Lloh940:
	adrp	x8, _call_constructor_1_asm_h@PAGE
Lloh941:
	add	x8, x8, _call_constructor_1_asm_h@PAGEOFF
	str	x8, [x0, #2208]
Lloh942:
	adrp	x8, _rot5l_1_asm_h@PAGE
Lloh943:
	add	x8, x8, _rot5l_1_asm_h@PAGEOFF
	str	x8, [x0, #2200]
Lloh944:
	adrp	x8, _rot4l_1_asm_h@PAGE
Lloh945:
	add	x8, x8, _rot4l_1_asm_h@PAGEOFF
	str	x8, [x0, #2192]
Lloh946:
	adrp	x8, _rot3r_1_asm_h@PAGE
Lloh947:
	add	x8, x8, _rot3r_1_asm_h@PAGEOFF
	str	x8, [x0, #2184]
Lloh948:
	adrp	x8, _rot3l_1_asm_h@PAGE
Lloh949:
	add	x8, x8, _rot3l_1_asm_h@PAGEOFF
	str	x8, [x0, #2176]
Lloh950:
	adrp	x8, _swap2_1_asm_h@PAGE
Lloh951:
	add	x8, x8, _swap2_1_asm_h@PAGEOFF
	str	x8, [x0, #2168]
Lloh952:
	adrp	x8, _swap_1_asm_h@PAGE
Lloh953:
	add	x8, x8, _swap_1_asm_h@PAGEOFF
	str	x8, [x0, #2160]
Lloh954:
	adrp	x8, _perm5_1_asm_h@PAGE
Lloh955:
	add	x8, x8, _perm5_1_asm_h@PAGEOFF
	str	x8, [x0, #2152]
Lloh956:
	adrp	x8, _perm4_1_asm_h@PAGE
Lloh957:
	add	x8, x8, _perm4_1_asm_h@PAGEOFF
	str	x8, [x0, #2144]
Lloh958:
	adrp	x8, _perm3_1_asm_h@PAGE
Lloh959:
	add	x8, x8, _perm3_1_asm_h@PAGEOFF
	str	x8, [x0, #2136]
Lloh960:
	adrp	x8, _insert4_1_asm_h@PAGE
Lloh961:
	add	x8, x8, _insert4_1_asm_h@PAGEOFF
	str	x8, [x0, #2128]
Lloh962:
	adrp	x8, _insert3_1_asm_h@PAGE
Lloh963:
	add	x8, x8, _insert3_1_asm_h@PAGEOFF
	str	x8, [x0, #2120]
Lloh964:
	adrp	x8, _insert2_1_asm_h@PAGE
Lloh965:
	add	x8, x8, _insert2_1_asm_h@PAGEOFF
	str	x8, [x0, #2112]
Lloh966:
	adrp	x8, _dup3_1_asm_h@PAGE
Lloh967:
	add	x8, x8, _dup3_1_asm_h@PAGEOFF
	str	x8, [x0, #2104]
Lloh968:
	adrp	x8, _dup2_1_asm_h@PAGE
Lloh969:
	add	x8, x8, _dup2_1_asm_h@PAGEOFF
	str	x8, [x0, #2096]
Lloh970:
	adrp	x8, _dup1_1_asm_h@PAGE
Lloh971:
	add	x8, x8, _dup1_1_asm_h@PAGEOFF
	str	x8, [x0, #2088]
Lloh972:
	adrp	x8, _dup_1_asm_h@PAGE
Lloh973:
	add	x8, x8, _dup_1_asm_h@PAGEOFF
	str	x8, [x0, #2080]
Lloh974:
	adrp	x8, _nip1_1_asm_h@PAGE
Lloh975:
	add	x8, x8, _nip1_1_asm_h@PAGEOFF
	str	x8, [x0, #2072]
Lloh976:
	adrp	x8, _nip_1_asm_h@PAGE
Lloh977:
	add	x8, x8, _nip_1_asm_h@PAGEOFF
	str	x8, [x0, #2064]
Lloh978:
	adrp	x8, _drop_1_asm_h@PAGE
Lloh979:
	add	x8, x8, _drop_1_asm_h@PAGEOFF
	str	x8, [x0, #2056]
Lloh980:
	adrp	x8, _rest_1_asm_h@PAGE
Lloh981:
	add	x8, x8, _rest_1_asm_h@PAGEOFF
	str	x8, [x0, #2048]
Lloh982:
	adrp	x8, _special_object_1_asm_h@PAGE
Lloh983:
	add	x8, x8, _special_object_1_asm_h@PAGEOFF
	str	x8, [x0, #2040]
Lloh984:
	adrp	x8, _set_var_ref3_1_asm_h@PAGE
Lloh985:
	add	x8, x8, _set_var_ref3_1_asm_h@PAGEOFF
	str	x8, [x0, #3776]
Lloh986:
	adrp	x8, _get_length_1_asm_h@PAGE
Lloh987:
	add	x8, x8, _get_length_1_asm_h@PAGEOFF
	str	x8, [x0, #3784]
Lloh988:
	adrp	x8, _if_false8_1_asm_h@PAGE
Lloh989:
	add	x8, x8, _if_false8_1_asm_h@PAGEOFF
	str	x8, [x0, #3792]
Lloh990:
	adrp	x8, _if_true8_1_asm_h@PAGE
Lloh991:
	add	x8, x8, _if_true8_1_asm_h@PAGEOFF
	str	x8, [x0, #3800]
Lloh992:
	adrp	x8, _goto8_1_asm_h@PAGE
Lloh993:
	add	x8, x8, _goto8_1_asm_h@PAGEOFF
	str	x8, [x0, #3808]
Lloh994:
	adrp	x8, _goto16_1_asm_h@PAGE
Lloh995:
	add	x8, x8, _goto16_1_asm_h@PAGEOFF
	str	x8, [x0, #3816]
Lloh996:
	adrp	x8, _call0_1_asm_h@PAGE
Lloh997:
	add	x8, x8, _call0_1_asm_h@PAGEOFF
	str	x8, [x0, #3824]
Lloh998:
	adrp	x8, _call1_1_asm_h@PAGE
Lloh999:
	add	x8, x8, _call1_1_asm_h@PAGEOFF
	str	x8, [x0, #3832]
Lloh1000:
	adrp	x8, _call2_1_asm_h@PAGE
Lloh1001:
	add	x8, x8, _call2_1_asm_h@PAGEOFF
	str	x8, [x0, #3840]
Lloh1002:
	adrp	x8, _call3_1_asm_h@PAGE
Lloh1003:
	add	x8, x8, _call3_1_asm_h@PAGEOFF
	str	x8, [x0, #3848]
Lloh1004:
	adrp	x8, _is_undefined_1_asm_h@PAGE
Lloh1005:
	add	x8, x8, _is_undefined_1_asm_h@PAGEOFF
	str	x8, [x0, #3856]
Lloh1006:
	adrp	x8, _is_null_1_asm_h@PAGE
Lloh1007:
	add	x8, x8, _is_null_1_asm_h@PAGEOFF
	str	x8, [x0, #3864]
Lloh1008:
	adrp	x8, _is_function_1_asm_h@PAGE
Lloh1009:
	add	x8, x8, _is_function_1_asm_h@PAGEOFF
	str	x8, [x0, #3872]
Lloh1010:
	adrp	x8, _inc_coverage_1_asm_h@PAGE
Lloh1011:
	add	x8, x8, _inc_coverage_1_asm_h@PAGEOFF
	str	x8, [x0, #3880]
Lloh1012:
	adrp	x8, _invalid_2_asm_h@PAGE
Lloh1013:
	add	x8, x8, _invalid_2_asm_h@PAGEOFF
	str	x8, [x0, #3888]
Lloh1014:
	adrp	x8, _push_i32_2_asm_h@PAGE
Lloh1015:
	add	x8, x8, _push_i32_2_asm_h@PAGEOFF
	str	x8, [x0, #3896]
Lloh1016:
	adrp	x8, _push_const_2_asm_h@PAGE
Lloh1017:
	add	x8, x8, _push_const_2_asm_h@PAGEOFF
	str	x8, [x0, #3904]
Lloh1018:
	adrp	x8, _fclosure_2_asm_h@PAGE
Lloh1019:
	add	x8, x8, _fclosure_2_asm_h@PAGEOFF
	str	x8, [x0, #3912]
Lloh1020:
	adrp	x8, _push_atom_value_2_asm_h@PAGE
Lloh1021:
	add	x8, x8, _push_atom_value_2_asm_h@PAGEOFF
	str	x8, [x0, #3920]
Lloh1022:
	adrp	x8, _private_symbol_2_asm_h@PAGE
Lloh1023:
	add	x8, x8, _private_symbol_2_asm_h@PAGEOFF
	str	x8, [x0, #3928]
Lloh1024:
	adrp	x8, _undefined_2_asm_h@PAGE
Lloh1025:
	add	x8, x8, _undefined_2_asm_h@PAGEOFF
	str	x8, [x0, #3936]
Lloh1026:
	adrp	x8, _null_2_asm_h@PAGE
Lloh1027:
	add	x8, x8, _null_2_asm_h@PAGEOFF
	str	x8, [x0, #3944]
Lloh1028:
	adrp	x8, _push_this_2_asm_h@PAGE
Lloh1029:
	add	x8, x8, _push_this_2_asm_h@PAGEOFF
	str	x8, [x0, #3952]
Lloh1030:
	adrp	x8, _push_false_2_asm_h@PAGE
Lloh1031:
	add	x8, x8, _push_false_2_asm_h@PAGEOFF
	str	x8, [x0, #3960]
Lloh1032:
	adrp	x8, _push_true_2_asm_h@PAGE
Lloh1033:
	add	x8, x8, _push_true_2_asm_h@PAGEOFF
	str	x8, [x0, #3968]
Lloh1034:
	adrp	x8, _object_2_asm_h@PAGE
Lloh1035:
	add	x8, x8, _object_2_asm_h@PAGEOFF
	str	x8, [x0, #3976]
Lloh1036:
	adrp	x8, _special_object_2_asm_h@PAGE
Lloh1037:
	add	x8, x8, _special_object_2_asm_h@PAGEOFF
	str	x8, [x0, #3984]
Lloh1038:
	adrp	x8, _rest_2_asm_h@PAGE
Lloh1039:
	add	x8, x8, _rest_2_asm_h@PAGEOFF
	str	x8, [x0, #3992]
Lloh1040:
	adrp	x8, _drop_2_asm_h@PAGE
Lloh1041:
	add	x8, x8, _drop_2_asm_h@PAGEOFF
	str	x8, [x0, #4000]
Lloh1042:
	adrp	x8, _nip_2_asm_h@PAGE
Lloh1043:
	add	x8, x8, _nip_2_asm_h@PAGEOFF
	str	x8, [x0, #4008]
Lloh1044:
	adrp	x8, _nip1_2_asm_h@PAGE
Lloh1045:
	add	x8, x8, _nip1_2_asm_h@PAGEOFF
	str	x8, [x0, #4016]
Lloh1046:
	adrp	x8, _dup_2_asm_h@PAGE
Lloh1047:
	add	x8, x8, _dup_2_asm_h@PAGEOFF
	str	x8, [x0, #4024]
Lloh1048:
	adrp	x8, _dup1_2_asm_h@PAGE
Lloh1049:
	add	x8, x8, _dup1_2_asm_h@PAGEOFF
	str	x8, [x0, #4032]
Lloh1050:
	adrp	x8, _dup2_2_asm_h@PAGE
Lloh1051:
	add	x8, x8, _dup2_2_asm_h@PAGEOFF
	str	x8, [x0, #4040]
Lloh1052:
	adrp	x8, _dup3_2_asm_h@PAGE
Lloh1053:
	add	x8, x8, _dup3_2_asm_h@PAGEOFF
	str	x8, [x0, #4048]
Lloh1054:
	adrp	x8, _insert2_2_asm_h@PAGE
Lloh1055:
	add	x8, x8, _insert2_2_asm_h@PAGEOFF
	str	x8, [x0, #4056]
Lloh1056:
	adrp	x8, _insert3_2_asm_h@PAGE
Lloh1057:
	add	x8, x8, _insert3_2_asm_h@PAGEOFF
	str	x8, [x0, #4064]
Lloh1058:
	adrp	x8, _insert4_2_asm_h@PAGE
Lloh1059:
	add	x8, x8, _insert4_2_asm_h@PAGEOFF
	str	x8, [x0, #4072]
Lloh1060:
	adrp	x8, _perm3_2_asm_h@PAGE
Lloh1061:
	add	x8, x8, _perm3_2_asm_h@PAGEOFF
	str	x8, [x0, #4080]
Lloh1062:
	adrp	x8, _perm4_2_asm_h@PAGE
Lloh1063:
	add	x8, x8, _perm4_2_asm_h@PAGEOFF
	str	x8, [x0, #4088]
Lloh1064:
	adrp	x8, _perm5_2_asm_h@PAGE
Lloh1065:
	add	x8, x8, _perm5_2_asm_h@PAGEOFF
	str	x8, [x0, #4096]
Lloh1066:
	adrp	x8, _swap_2_asm_h@PAGE
Lloh1067:
	add	x8, x8, _swap_2_asm_h@PAGEOFF
	str	x8, [x0, #4104]
Lloh1068:
	adrp	x8, _swap2_2_asm_h@PAGE
Lloh1069:
	add	x8, x8, _swap2_2_asm_h@PAGEOFF
	str	x8, [x0, #4112]
Lloh1070:
	adrp	x8, _rot3l_2_asm_h@PAGE
Lloh1071:
	add	x8, x8, _rot3l_2_asm_h@PAGEOFF
	str	x8, [x0, #4120]
Lloh1072:
	adrp	x8, _rot3r_2_asm_h@PAGE
Lloh1073:
	add	x8, x8, _rot3r_2_asm_h@PAGEOFF
	str	x8, [x0, #4128]
Lloh1074:
	adrp	x8, _rot4l_2_asm_h@PAGE
Lloh1075:
	add	x8, x8, _rot4l_2_asm_h@PAGEOFF
	str	x8, [x0, #4136]
Lloh1076:
	adrp	x8, _rot5l_2_asm_h@PAGE
Lloh1077:
	add	x8, x8, _rot5l_2_asm_h@PAGEOFF
	str	x8, [x0, #4144]
Lloh1078:
	adrp	x8, _call_constructor_2_asm_h@PAGE
Lloh1079:
	add	x8, x8, _call_constructor_2_asm_h@PAGEOFF
	str	x8, [x0, #4152]
Lloh1080:
	adrp	x8, _call_2_asm_h@PAGE
Lloh1081:
	add	x8, x8, _call_2_asm_h@PAGEOFF
	str	x8, [x0, #4160]
Lloh1082:
	adrp	x8, _tail_call_2_asm_h@PAGE
Lloh1083:
	add	x8, x8, _tail_call_2_asm_h@PAGEOFF
	str	x8, [x0, #4168]
Lloh1084:
	adrp	x8, _call_method_2_asm_h@PAGE
Lloh1085:
	add	x8, x8, _call_method_2_asm_h@PAGEOFF
	str	x8, [x0, #4176]
Lloh1086:
	adrp	x8, _tail_call_method_2_asm_h@PAGE
Lloh1087:
	add	x8, x8, _tail_call_method_2_asm_h@PAGEOFF
	str	x8, [x0, #4184]
Lloh1088:
	adrp	x8, _array_from_2_asm_h@PAGE
Lloh1089:
	add	x8, x8, _array_from_2_asm_h@PAGEOFF
	str	x8, [x0, #4192]
Lloh1090:
	adrp	x8, _apply_2_asm_h@PAGE
Lloh1091:
	add	x8, x8, _apply_2_asm_h@PAGEOFF
	str	x8, [x0, #4200]
Lloh1092:
	adrp	x8, _return_2_asm_h@PAGE
Lloh1093:
	add	x8, x8, _return_2_asm_h@PAGEOFF
	str	x8, [x0, #4208]
Lloh1094:
	adrp	x8, _return_undef_2_asm_h@PAGE
Lloh1095:
	add	x8, x8, _return_undef_2_asm_h@PAGEOFF
	str	x8, [x0, #4216]
Lloh1096:
	adrp	x8, _check_ctor_return_2_asm_h@PAGE
Lloh1097:
	add	x8, x8, _check_ctor_return_2_asm_h@PAGEOFF
	str	x8, [x0, #4224]
Lloh1098:
	adrp	x8, _check_ctor_2_asm_h@PAGE
Lloh1099:
	add	x8, x8, _check_ctor_2_asm_h@PAGEOFF
	str	x8, [x0, #4232]
Lloh1100:
	adrp	x8, _check_brand_2_asm_h@PAGE
Lloh1101:
	add	x8, x8, _check_brand_2_asm_h@PAGEOFF
	str	x8, [x0, #4240]
Lloh1102:
	adrp	x8, _add_brand_2_asm_h@PAGE
Lloh1103:
	add	x8, x8, _add_brand_2_asm_h@PAGEOFF
	str	x8, [x0, #4248]
Lloh1104:
	adrp	x8, _return_async_2_asm_h@PAGE
Lloh1105:
	add	x8, x8, _return_async_2_asm_h@PAGEOFF
	str	x8, [x0, #4256]
Lloh1106:
	adrp	x8, _throw_2_asm_h@PAGE
Lloh1107:
	add	x8, x8, _throw_2_asm_h@PAGEOFF
	str	x8, [x0, #4264]
Lloh1108:
	adrp	x8, _throw_var_2_asm_h@PAGE
Lloh1109:
	add	x8, x8, _throw_var_2_asm_h@PAGEOFF
	str	x8, [x0, #4272]
Lloh1110:
	adrp	x8, _eval_2_asm_h@PAGE
Lloh1111:
	add	x8, x8, _eval_2_asm_h@PAGEOFF
	str	x8, [x0, #4280]
Lloh1112:
	adrp	x8, _regexp_2_asm_h@PAGE
Lloh1113:
	add	x8, x8, _regexp_2_asm_h@PAGEOFF
	str	x8, [x0, #4288]
Lloh1114:
	adrp	x8, _get_super_ctor_2_asm_h@PAGE
Lloh1115:
	add	x8, x8, _get_super_ctor_2_asm_h@PAGEOFF
	str	x8, [x0, #4296]
Lloh1116:
	adrp	x8, _get_super_2_asm_h@PAGE
Lloh1117:
	add	x8, x8, _get_super_2_asm_h@PAGEOFF
	str	x8, [x0, #4304]
Lloh1118:
	adrp	x8, _import_2_asm_h@PAGE
Lloh1119:
	add	x8, x8, _import_2_asm_h@PAGEOFF
	str	x8, [x0, #4312]
Lloh1120:
	adrp	x8, _check_var_2_asm_h@PAGE
Lloh1121:
	add	x8, x8, _check_var_2_asm_h@PAGEOFF
	str	x8, [x0, #4320]
Lloh1122:
	adrp	x8, _get_var_undef_2_asm_h@PAGE
Lloh1123:
	add	x8, x8, _get_var_undef_2_asm_h@PAGEOFF
	str	x8, [x0, #4328]
Lloh1124:
	adrp	x8, _get_var_2_asm_h@PAGE
Lloh1125:
	add	x8, x8, _get_var_2_asm_h@PAGEOFF
	str	x8, [x0, #4336]
Lloh1126:
	adrp	x8, _put_var_2_asm_h@PAGE
Lloh1127:
	add	x8, x8, _put_var_2_asm_h@PAGEOFF
	str	x8, [x0, #4344]
Lloh1128:
	adrp	x8, _put_var_init_2_asm_h@PAGE
Lloh1129:
	add	x8, x8, _put_var_init_2_asm_h@PAGEOFF
	str	x8, [x0, #4352]
Lloh1130:
	adrp	x8, _put_var_strict_2_asm_h@PAGE
Lloh1131:
	add	x8, x8, _put_var_strict_2_asm_h@PAGEOFF
	str	x8, [x0, #4360]
Lloh1132:
	adrp	x8, _get_ref_value_2_asm_h@PAGE
Lloh1133:
	add	x8, x8, _get_ref_value_2_asm_h@PAGEOFF
	str	x8, [x0, #4368]
Lloh1134:
	adrp	x8, _put_ref_value_2_asm_h@PAGE
Lloh1135:
	add	x8, x8, _put_ref_value_2_asm_h@PAGEOFF
	str	x8, [x0, #4376]
Lloh1136:
	adrp	x8, _define_var_2_asm_h@PAGE
Lloh1137:
	add	x8, x8, _define_var_2_asm_h@PAGEOFF
	str	x8, [x0, #4384]
Lloh1138:
	adrp	x8, _check_define_var_2_asm_h@PAGE
Lloh1139:
	add	x8, x8, _check_define_var_2_asm_h@PAGEOFF
	str	x8, [x0, #4392]
Lloh1140:
	adrp	x8, _define_func_2_asm_h@PAGE
Lloh1141:
	add	x8, x8, _define_func_2_asm_h@PAGEOFF
	str	x8, [x0, #4400]
Lloh1142:
	adrp	x8, _get_field_2_asm_h@PAGE
Lloh1143:
	add	x8, x8, _get_field_2_asm_h@PAGEOFF
	str	x8, [x0, #4408]
Lloh1144:
	adrp	x8, _get_field2_2_asm_h@PAGE
Lloh1145:
	add	x8, x8, _get_field2_2_asm_h@PAGEOFF
	str	x8, [x0, #4416]
Lloh1146:
	adrp	x8, _put_field_2_asm_h@PAGE
Lloh1147:
	add	x8, x8, _put_field_2_asm_h@PAGEOFF
	str	x8, [x0, #4424]
Lloh1148:
	adrp	x8, _get_private_field_2_asm_h@PAGE
Lloh1149:
	add	x8, x8, _get_private_field_2_asm_h@PAGEOFF
	str	x8, [x0, #4432]
Lloh1150:
	adrp	x8, _put_private_field_2_asm_h@PAGE
Lloh1151:
	add	x8, x8, _put_private_field_2_asm_h@PAGEOFF
	str	x8, [x0, #4440]
Lloh1152:
	adrp	x8, _define_private_field_2_asm_h@PAGE
Lloh1153:
	add	x8, x8, _define_private_field_2_asm_h@PAGEOFF
	str	x8, [x0, #4448]
Lloh1154:
	adrp	x8, _get_array_el_2_asm_h@PAGE
Lloh1155:
	add	x8, x8, _get_array_el_2_asm_h@PAGEOFF
	str	x8, [x0, #4456]
Lloh1156:
	adrp	x8, _get_array_el2_2_asm_h@PAGE
Lloh1157:
	add	x8, x8, _get_array_el2_2_asm_h@PAGEOFF
	str	x8, [x0, #4464]
Lloh1158:
	adrp	x8, _put_array_el_2_asm_h@PAGE
Lloh1159:
	add	x8, x8, _put_array_el_2_asm_h@PAGEOFF
	str	x8, [x0, #4472]
Lloh1160:
	adrp	x8, _get_super_value_2_asm_h@PAGE
Lloh1161:
	add	x8, x8, _get_super_value_2_asm_h@PAGEOFF
	str	x8, [x0, #4480]
Lloh1162:
	adrp	x8, _put_super_value_2_asm_h@PAGE
Lloh1163:
	add	x8, x8, _put_super_value_2_asm_h@PAGEOFF
	str	x8, [x0, #4488]
Lloh1164:
	adrp	x8, _define_field_2_asm_h@PAGE
Lloh1165:
	add	x8, x8, _define_field_2_asm_h@PAGEOFF
	str	x8, [x0, #4496]
Lloh1166:
	adrp	x8, _set_name_2_asm_h@PAGE
Lloh1167:
	add	x8, x8, _set_name_2_asm_h@PAGEOFF
	str	x8, [x0, #4504]
Lloh1168:
	adrp	x8, _set_name_computed_2_asm_h@PAGE
Lloh1169:
	add	x8, x8, _set_name_computed_2_asm_h@PAGEOFF
	str	x8, [x0, #4512]
Lloh1170:
	adrp	x8, _set_proto_2_asm_h@PAGE
Lloh1171:
	add	x8, x8, _set_proto_2_asm_h@PAGEOFF
	str	x8, [x0, #4520]
Lloh1172:
	adrp	x8, _set_home_object_2_asm_h@PAGE
Lloh1173:
	add	x8, x8, _set_home_object_2_asm_h@PAGEOFF
	str	x8, [x0, #4528]
Lloh1174:
	adrp	x8, _define_array_el_2_asm_h@PAGE
Lloh1175:
	add	x8, x8, _define_array_el_2_asm_h@PAGEOFF
	str	x8, [x0, #4536]
Lloh1176:
	adrp	x8, _append_2_asm_h@PAGE
Lloh1177:
	add	x8, x8, _append_2_asm_h@PAGEOFF
	str	x8, [x0, #4544]
Lloh1178:
	adrp	x8, _copy_data_properties_2_asm_h@PAGE
Lloh1179:
	add	x8, x8, _copy_data_properties_2_asm_h@PAGEOFF
	str	x8, [x0, #4552]
Lloh1180:
	adrp	x8, _define_method_2_asm_h@PAGE
Lloh1181:
	add	x8, x8, _define_method_2_asm_h@PAGEOFF
	str	x8, [x0, #4560]
Lloh1182:
	adrp	x8, _define_method_computed_2_asm_h@PAGE
Lloh1183:
	add	x8, x8, _define_method_computed_2_asm_h@PAGEOFF
	str	x8, [x0, #4568]
Lloh1184:
	adrp	x8, _define_class_2_asm_h@PAGE
Lloh1185:
	add	x8, x8, _define_class_2_asm_h@PAGEOFF
	str	x8, [x0, #4576]
Lloh1186:
	adrp	x8, _get_loc_2_asm_h@PAGE
Lloh1187:
	add	x8, x8, _get_loc_2_asm_h@PAGEOFF
	str	x8, [x0, #4584]
Lloh1188:
	adrp	x8, _put_loc_2_asm_h@PAGE
Lloh1189:
	add	x8, x8, _put_loc_2_asm_h@PAGEOFF
	str	x8, [x0, #4592]
Lloh1190:
	adrp	x8, _set_loc_2_asm_h@PAGE
Lloh1191:
	add	x8, x8, _set_loc_2_asm_h@PAGEOFF
	str	x8, [x0, #4600]
Lloh1192:
	adrp	x8, _get_arg_2_asm_h@PAGE
Lloh1193:
	add	x8, x8, _get_arg_2_asm_h@PAGEOFF
	str	x8, [x0, #4608]
Lloh1194:
	adrp	x8, _put_arg_2_asm_h@PAGE
Lloh1195:
	add	x8, x8, _put_arg_2_asm_h@PAGEOFF
	str	x8, [x0, #4616]
Lloh1196:
	adrp	x8, _set_arg_2_asm_h@PAGE
Lloh1197:
	add	x8, x8, _set_arg_2_asm_h@PAGEOFF
	str	x8, [x0, #4624]
Lloh1198:
	adrp	x8, _get_var_ref_2_asm_h@PAGE
Lloh1199:
	add	x8, x8, _get_var_ref_2_asm_h@PAGEOFF
	str	x8, [x0, #4632]
Lloh1200:
	adrp	x8, _put_var_ref_2_asm_h@PAGE
Lloh1201:
	add	x8, x8, _put_var_ref_2_asm_h@PAGEOFF
	str	x8, [x0, #4640]
Lloh1202:
	adrp	x8, _set_var_ref_2_asm_h@PAGE
Lloh1203:
	add	x8, x8, _set_var_ref_2_asm_h@PAGEOFF
	str	x8, [x0, #4648]
Lloh1204:
	adrp	x8, _set_loc_uninitialized_2_asm_h@PAGE
Lloh1205:
	add	x8, x8, _set_loc_uninitialized_2_asm_h@PAGEOFF
	str	x8, [x0, #4656]
Lloh1206:
	adrp	x8, _get_loc_check_2_asm_h@PAGE
Lloh1207:
	add	x8, x8, _get_loc_check_2_asm_h@PAGEOFF
	str	x8, [x0, #4664]
Lloh1208:
	adrp	x8, _put_loc_check_2_asm_h@PAGE
Lloh1209:
	add	x8, x8, _put_loc_check_2_asm_h@PAGEOFF
	str	x8, [x0, #4672]
Lloh1210:
	adrp	x8, _put_loc_check_init_2_asm_h@PAGE
Lloh1211:
	add	x8, x8, _put_loc_check_init_2_asm_h@PAGEOFF
	str	x8, [x0, #4680]
Lloh1212:
	adrp	x8, _get_var_ref_check_2_asm_h@PAGE
Lloh1213:
	add	x8, x8, _get_var_ref_check_2_asm_h@PAGEOFF
	str	x8, [x0, #4688]
Lloh1214:
	adrp	x8, _put_var_ref_check_2_asm_h@PAGE
Lloh1215:
	add	x8, x8, _put_var_ref_check_2_asm_h@PAGEOFF
	str	x8, [x0, #4696]
Lloh1216:
	adrp	x8, _put_var_ref_check_init_2_asm_h@PAGE
Lloh1217:
	add	x8, x8, _put_var_ref_check_init_2_asm_h@PAGEOFF
	str	x8, [x0, #4704]
Lloh1218:
	adrp	x8, _close_loc_2_asm_h@PAGE
Lloh1219:
	add	x8, x8, _close_loc_2_asm_h@PAGEOFF
	str	x8, [x0, #4712]
Lloh1220:
	adrp	x8, _if_false_2_asm_h@PAGE
Lloh1221:
	add	x8, x8, _if_false_2_asm_h@PAGEOFF
	str	x8, [x0, #4720]
Lloh1222:
	adrp	x8, _if_true_2_asm_h@PAGE
Lloh1223:
	add	x8, x8, _if_true_2_asm_h@PAGEOFF
	str	x8, [x0, #4728]
Lloh1224:
	adrp	x8, _goto_2_asm_h@PAGE
Lloh1225:
	add	x8, x8, _goto_2_asm_h@PAGEOFF
	str	x8, [x0, #4736]
Lloh1226:
	adrp	x8, _catch_2_asm_h@PAGE
Lloh1227:
	add	x8, x8, _catch_2_asm_h@PAGEOFF
	str	x8, [x0, #4744]
Lloh1228:
	adrp	x8, _gosub_2_asm_h@PAGE
Lloh1229:
	add	x8, x8, _gosub_2_asm_h@PAGEOFF
	str	x8, [x0, #4752]
Lloh1230:
	adrp	x8, _ret_2_asm_h@PAGE
Lloh1231:
	add	x8, x8, _ret_2_asm_h@PAGEOFF
	str	x8, [x0, #4760]
Lloh1232:
	adrp	x8, _to_object_2_asm_h@PAGE
Lloh1233:
	add	x8, x8, _to_object_2_asm_h@PAGEOFF
	str	x8, [x0, #4768]
Lloh1234:
	adrp	x8, _to_propkey_2_asm_h@PAGE
Lloh1235:
	add	x8, x8, _to_propkey_2_asm_h@PAGEOFF
	str	x8, [x0, #4776]
Lloh1236:
	adrp	x8, _to_propkey2_2_asm_h@PAGE
Lloh1237:
	add	x8, x8, _to_propkey2_2_asm_h@PAGEOFF
	str	x8, [x0, #4784]
Lloh1238:
	adrp	x8, _with_get_var_2_asm_h@PAGE
Lloh1239:
	add	x8, x8, _with_get_var_2_asm_h@PAGEOFF
	str	x8, [x0, #4792]
Lloh1240:
	adrp	x8, _with_put_var_2_asm_h@PAGE
Lloh1241:
	add	x8, x8, _with_put_var_2_asm_h@PAGEOFF
	str	x8, [x0, #4800]
Lloh1242:
	adrp	x8, _with_delete_var_2_asm_h@PAGE
Lloh1243:
	add	x8, x8, _with_delete_var_2_asm_h@PAGEOFF
	str	x8, [x0, #4808]
Lloh1244:
	adrp	x8, _with_make_ref_2_asm_h@PAGE
Lloh1245:
	add	x8, x8, _with_make_ref_2_asm_h@PAGEOFF
	str	x8, [x0, #4816]
Lloh1246:
	adrp	x8, _with_get_ref_2_asm_h@PAGE
Lloh1247:
	add	x8, x8, _with_get_ref_2_asm_h@PAGEOFF
	str	x8, [x0, #4824]
Lloh1248:
	adrp	x8, _with_get_ref_undef_2_asm_h@PAGE
Lloh1249:
	add	x8, x8, _with_get_ref_undef_2_asm_h@PAGEOFF
	str	x8, [x0, #4832]
Lloh1250:
	adrp	x8, _make_loc_ref_2_asm_h@PAGE
Lloh1251:
	add	x8, x8, _make_loc_ref_2_asm_h@PAGEOFF
	str	x8, [x0, #4840]
Lloh1252:
	adrp	x8, _make_arg_ref_2_asm_h@PAGE
Lloh1253:
	add	x8, x8, _make_arg_ref_2_asm_h@PAGEOFF
	str	x8, [x0, #4848]
Lloh1254:
	adrp	x8, _make_var_ref_ref_2_asm_h@PAGE
Lloh1255:
	add	x8, x8, _make_var_ref_ref_2_asm_h@PAGEOFF
	str	x8, [x0, #4856]
Lloh1256:
	adrp	x8, _make_var_ref_2_asm_h@PAGE
Lloh1257:
	add	x8, x8, _make_var_ref_2_asm_h@PAGEOFF
	str	x8, [x0, #4864]
Lloh1258:
	adrp	x8, _for_in_start_2_asm_h@PAGE
Lloh1259:
	add	x8, x8, _for_in_start_2_asm_h@PAGEOFF
	str	x8, [x0, #4872]
Lloh1260:
	adrp	x8, _for_of_start_2_asm_h@PAGE
Lloh1261:
	add	x8, x8, _for_of_start_2_asm_h@PAGEOFF
	str	x8, [x0, #4880]
Lloh1262:
	adrp	x8, _for_await_of_start_2_asm_h@PAGE
Lloh1263:
	add	x8, x8, _for_await_of_start_2_asm_h@PAGEOFF
	str	x8, [x0, #4888]
Lloh1264:
	adrp	x8, _for_in_next_2_asm_h@PAGE
Lloh1265:
	add	x8, x8, _for_in_next_2_asm_h@PAGEOFF
	str	x8, [x0, #4896]
Lloh1266:
	adrp	x8, _for_of_next_2_asm_h@PAGE
Lloh1267:
	add	x8, x8, _for_of_next_2_asm_h@PAGEOFF
	str	x8, [x0, #4904]
Lloh1268:
	adrp	x8, _for_await_of_next_2_asm_h@PAGE
Lloh1269:
	add	x8, x8, _for_await_of_next_2_asm_h@PAGEOFF
	str	x8, [x0, #4912]
Lloh1270:
	adrp	x8, _iterator_get_value_done_2_asm_h@PAGE
Lloh1271:
	add	x8, x8, _iterator_get_value_done_2_asm_h@PAGEOFF
	str	x8, [x0, #4920]
Lloh1272:
	adrp	x8, _iterator_close_2_asm_h@PAGE
Lloh1273:
	add	x8, x8, _iterator_close_2_asm_h@PAGEOFF
	str	x8, [x0, #4928]
Lloh1274:
	adrp	x8, _iterator_close_return_2_asm_h@PAGE
Lloh1275:
	add	x8, x8, _iterator_close_return_2_asm_h@PAGEOFF
	str	x8, [x0, #4936]
Lloh1276:
	adrp	x8, _async_iterator_close_2_asm_h@PAGE
Lloh1277:
	add	x8, x8, _async_iterator_close_2_asm_h@PAGEOFF
	str	x8, [x0, #4944]
Lloh1278:
	adrp	x8, _async_iterator_next_2_asm_h@PAGE
Lloh1279:
	add	x8, x8, _async_iterator_next_2_asm_h@PAGEOFF
	str	x8, [x0, #4952]
Lloh1280:
	adrp	x8, _async_iterator_get_2_asm_h@PAGE
Lloh1281:
	add	x8, x8, _async_iterator_get_2_asm_h@PAGEOFF
	str	x8, [x0, #4960]
Lloh1282:
	adrp	x8, _initial_yield_2_asm_h@PAGE
Lloh1283:
	add	x8, x8, _initial_yield_2_asm_h@PAGEOFF
	str	x8, [x0, #4968]
Lloh1284:
	adrp	x8, _yield_2_asm_h@PAGE
Lloh1285:
	add	x8, x8, _yield_2_asm_h@PAGEOFF
	str	x8, [x0, #4976]
Lloh1286:
	adrp	x8, _yield_star_2_asm_h@PAGE
Lloh1287:
	add	x8, x8, _yield_star_2_asm_h@PAGEOFF
	str	x8, [x0, #4984]
Lloh1288:
	adrp	x8, _async_yield_star_2_asm_h@PAGE
Lloh1289:
	add	x8, x8, _async_yield_star_2_asm_h@PAGEOFF
	str	x8, [x0, #4992]
Lloh1290:
	adrp	x8, _await_2_asm_h@PAGE
Lloh1291:
	add	x8, x8, _await_2_asm_h@PAGEOFF
	str	x8, [x0, #5000]
Lloh1292:
	adrp	x8, _neg_2_asm_h@PAGE
Lloh1293:
	add	x8, x8, _neg_2_asm_h@PAGEOFF
	str	x8, [x0, #5008]
Lloh1294:
	adrp	x8, _plus_2_asm_h@PAGE
Lloh1295:
	add	x8, x8, _plus_2_asm_h@PAGEOFF
	str	x8, [x0, #5016]
Lloh1296:
	adrp	x8, _dec_2_asm_h@PAGE
Lloh1297:
	add	x8, x8, _dec_2_asm_h@PAGEOFF
	str	x8, [x0, #5024]
Lloh1298:
	adrp	x8, _inc_2_asm_h@PAGE
Lloh1299:
	add	x8, x8, _inc_2_asm_h@PAGEOFF
	str	x8, [x0, #5032]
Lloh1300:
	adrp	x8, _post_dec_2_asm_h@PAGE
Lloh1301:
	add	x8, x8, _post_dec_2_asm_h@PAGEOFF
	str	x8, [x0, #5040]
Lloh1302:
	adrp	x8, _post_inc_2_asm_h@PAGE
Lloh1303:
	add	x8, x8, _post_inc_2_asm_h@PAGEOFF
	str	x8, [x0, #5048]
Lloh1304:
	adrp	x8, _dec_loc_2_asm_h@PAGE
Lloh1305:
	add	x8, x8, _dec_loc_2_asm_h@PAGEOFF
	str	x8, [x0, #5056]
Lloh1306:
	adrp	x8, _inc_loc_2_asm_h@PAGE
Lloh1307:
	add	x8, x8, _inc_loc_2_asm_h@PAGEOFF
	str	x8, [x0, #5064]
Lloh1308:
	adrp	x8, _add_loc_2_asm_h@PAGE
Lloh1309:
	add	x8, x8, _add_loc_2_asm_h@PAGEOFF
	str	x8, [x0, #5072]
Lloh1310:
	adrp	x8, _not_2_asm_h@PAGE
Lloh1311:
	add	x8, x8, _not_2_asm_h@PAGEOFF
	str	x8, [x0, #5080]
Lloh1312:
	adrp	x8, _lnot_2_asm_h@PAGE
Lloh1313:
	add	x8, x8, _lnot_2_asm_h@PAGEOFF
	str	x8, [x0, #5088]
Lloh1314:
	adrp	x8, _typeof_2_asm_h@PAGE
Lloh1315:
	add	x8, x8, _typeof_2_asm_h@PAGEOFF
	str	x8, [x0, #5096]
Lloh1316:
	adrp	x8, _delete_2_asm_h@PAGE
Lloh1317:
	add	x8, x8, _delete_2_asm_h@PAGEOFF
	str	x8, [x0, #5104]
Lloh1318:
	adrp	x8, _delete_var_2_asm_h@PAGE
Lloh1319:
	add	x8, x8, _delete_var_2_asm_h@PAGEOFF
	str	x8, [x0, #5112]
Lloh1320:
	adrp	x8, _mul_2_asm_h@PAGE
Lloh1321:
	add	x8, x8, _mul_2_asm_h@PAGEOFF
	str	x8, [x0, #5120]
Lloh1322:
	adrp	x8, _div_2_asm_h@PAGE
Lloh1323:
	add	x8, x8, _div_2_asm_h@PAGEOFF
	str	x8, [x0, #5128]
Lloh1324:
	adrp	x8, _mod_2_asm_h@PAGE
Lloh1325:
	add	x8, x8, _mod_2_asm_h@PAGEOFF
	str	x8, [x0, #5136]
Lloh1326:
	adrp	x8, _add_2_asm_h@PAGE
Lloh1327:
	add	x8, x8, _add_2_asm_h@PAGEOFF
	str	x8, [x0, #5144]
Lloh1328:
	adrp	x8, _sub_2_asm_h@PAGE
Lloh1329:
	add	x8, x8, _sub_2_asm_h@PAGEOFF
	str	x8, [x0, #5152]
Lloh1330:
	adrp	x8, _pow_2_asm_h@PAGE
Lloh1331:
	add	x8, x8, _pow_2_asm_h@PAGEOFF
	str	x8, [x0, #5160]
Lloh1332:
	adrp	x8, _shl_2_asm_h@PAGE
Lloh1333:
	add	x8, x8, _shl_2_asm_h@PAGEOFF
	str	x8, [x0, #5168]
Lloh1334:
	adrp	x8, _sar_2_asm_h@PAGE
Lloh1335:
	add	x8, x8, _sar_2_asm_h@PAGEOFF
	str	x8, [x0, #5176]
Lloh1336:
	adrp	x8, _shr_2_asm_h@PAGE
Lloh1337:
	add	x8, x8, _shr_2_asm_h@PAGEOFF
	str	x8, [x0, #5184]
Lloh1338:
	adrp	x8, _lt_2_asm_h@PAGE
Lloh1339:
	add	x8, x8, _lt_2_asm_h@PAGEOFF
	str	x8, [x0, #5192]
Lloh1340:
	adrp	x8, _lte_2_asm_h@PAGE
Lloh1341:
	add	x8, x8, _lte_2_asm_h@PAGEOFF
	str	x8, [x0, #5200]
Lloh1342:
	adrp	x8, _gt_2_asm_h@PAGE
Lloh1343:
	add	x8, x8, _gt_2_asm_h@PAGEOFF
	str	x8, [x0, #5208]
Lloh1344:
	adrp	x8, _gte_2_asm_h@PAGE
Lloh1345:
	add	x8, x8, _gte_2_asm_h@PAGEOFF
	str	x8, [x0, #5216]
Lloh1346:
	adrp	x8, _instanceof_2_asm_h@PAGE
Lloh1347:
	add	x8, x8, _instanceof_2_asm_h@PAGEOFF
	str	x8, [x0, #5224]
Lloh1348:
	adrp	x8, _in_2_asm_h@PAGE
Lloh1349:
	add	x8, x8, _in_2_asm_h@PAGEOFF
	str	x8, [x0, #5232]
Lloh1350:
	adrp	x8, _eq_2_asm_h@PAGE
Lloh1351:
	add	x8, x8, _eq_2_asm_h@PAGEOFF
	str	x8, [x0, #5240]
Lloh1352:
	adrp	x8, _neq_2_asm_h@PAGE
Lloh1353:
	add	x8, x8, _neq_2_asm_h@PAGEOFF
	str	x8, [x0, #5248]
Lloh1354:
	adrp	x8, _strict_eq_2_asm_h@PAGE
Lloh1355:
	add	x8, x8, _strict_eq_2_asm_h@PAGEOFF
	str	x8, [x0, #5256]
Lloh1356:
	adrp	x8, _strict_neq_2_asm_h@PAGE
Lloh1357:
	add	x8, x8, _strict_neq_2_asm_h@PAGEOFF
	str	x8, [x0, #5264]
Lloh1358:
	adrp	x8, _and_2_asm_h@PAGE
Lloh1359:
	add	x8, x8, _and_2_asm_h@PAGEOFF
	str	x8, [x0, #5272]
Lloh1360:
	adrp	x8, _xor_2_asm_h@PAGE
Lloh1361:
	add	x8, x8, _xor_2_asm_h@PAGEOFF
	str	x8, [x0, #5280]
Lloh1362:
	adrp	x8, _or_2_asm_h@PAGE
Lloh1363:
	add	x8, x8, _or_2_asm_h@PAGEOFF
	str	x8, [x0, #5288]
Lloh1364:
	adrp	x8, _nop_2_asm_h@PAGE
Lloh1365:
	add	x8, x8, _nop_2_asm_h@PAGEOFF
	str	x8, [x0, #5296]
Lloh1366:
	adrp	x8, _push_minus1_2_asm_h@PAGE
Lloh1367:
	add	x8, x8, _push_minus1_2_asm_h@PAGEOFF
	str	x8, [x0, #5304]
Lloh1368:
	adrp	x8, _push_0_2_asm_h@PAGE
Lloh1369:
	add	x8, x8, _push_0_2_asm_h@PAGEOFF
	str	x8, [x0, #5312]
Lloh1370:
	adrp	x8, _push_1_2_asm_h@PAGE
Lloh1371:
	add	x8, x8, _push_1_2_asm_h@PAGEOFF
	str	x8, [x0, #5320]
Lloh1372:
	adrp	x8, _push_2_2_asm_h@PAGE
Lloh1373:
	add	x8, x8, _push_2_2_asm_h@PAGEOFF
	str	x8, [x0, #5328]
Lloh1374:
	adrp	x8, _push_3_2_asm_h@PAGE
Lloh1375:
	add	x8, x8, _push_3_2_asm_h@PAGEOFF
	str	x8, [x0, #5336]
Lloh1376:
	adrp	x8, _push_4_2_asm_h@PAGE
Lloh1377:
	add	x8, x8, _push_4_2_asm_h@PAGEOFF
	str	x8, [x0, #5344]
Lloh1378:
	adrp	x8, _push_5_2_asm_h@PAGE
Lloh1379:
	add	x8, x8, _push_5_2_asm_h@PAGEOFF
	str	x8, [x0, #5352]
Lloh1380:
	adrp	x8, _push_6_2_asm_h@PAGE
Lloh1381:
	add	x8, x8, _push_6_2_asm_h@PAGEOFF
	str	x8, [x0, #5360]
Lloh1382:
	adrp	x8, _push_7_2_asm_h@PAGE
Lloh1383:
	add	x8, x8, _push_7_2_asm_h@PAGEOFF
	str	x8, [x0, #5368]
Lloh1384:
	adrp	x8, _push_i8_2_asm_h@PAGE
Lloh1385:
	add	x8, x8, _push_i8_2_asm_h@PAGEOFF
	str	x8, [x0, #5376]
Lloh1386:
	adrp	x8, _push_i16_2_asm_h@PAGE
Lloh1387:
	add	x8, x8, _push_i16_2_asm_h@PAGEOFF
	str	x8, [x0, #5384]
Lloh1388:
	adrp	x8, _push_const8_2_asm_h@PAGE
Lloh1389:
	add	x8, x8, _push_const8_2_asm_h@PAGEOFF
	str	x8, [x0, #5392]
Lloh1390:
	adrp	x8, _fclosure8_2_asm_h@PAGE
Lloh1391:
	add	x8, x8, _fclosure8_2_asm_h@PAGEOFF
	str	x8, [x0, #5400]
Lloh1392:
	adrp	x8, _push_empty_string_2_asm_h@PAGE
Lloh1393:
	add	x8, x8, _push_empty_string_2_asm_h@PAGEOFF
	str	x8, [x0, #5408]
Lloh1394:
	adrp	x8, _get_loc8_2_asm_h@PAGE
Lloh1395:
	add	x8, x8, _get_loc8_2_asm_h@PAGEOFF
	str	x8, [x0, #5416]
Lloh1396:
	adrp	x8, _put_loc8_2_asm_h@PAGE
Lloh1397:
	add	x8, x8, _put_loc8_2_asm_h@PAGEOFF
	str	x8, [x0, #5424]
Lloh1398:
	adrp	x8, _set_loc8_2_asm_h@PAGE
Lloh1399:
	add	x8, x8, _set_loc8_2_asm_h@PAGEOFF
	str	x8, [x0, #5432]
Lloh1400:
	adrp	x8, _get_loc0_2_asm_h@PAGE
Lloh1401:
	add	x8, x8, _get_loc0_2_asm_h@PAGEOFF
	str	x8, [x0, #5440]
Lloh1402:
	adrp	x8, _get_loc1_2_asm_h@PAGE
Lloh1403:
	add	x8, x8, _get_loc1_2_asm_h@PAGEOFF
	str	x8, [x0, #5448]
Lloh1404:
	adrp	x8, _get_loc2_2_asm_h@PAGE
Lloh1405:
	add	x8, x8, _get_loc2_2_asm_h@PAGEOFF
	str	x8, [x0, #5456]
Lloh1406:
	adrp	x8, _get_loc3_2_asm_h@PAGE
Lloh1407:
	add	x8, x8, _get_loc3_2_asm_h@PAGEOFF
	str	x8, [x0, #5464]
Lloh1408:
	adrp	x8, _put_loc0_2_asm_h@PAGE
Lloh1409:
	add	x8, x8, _put_loc0_2_asm_h@PAGEOFF
	str	x8, [x0, #5472]
Lloh1410:
	adrp	x8, _put_loc1_2_asm_h@PAGE
Lloh1411:
	add	x8, x8, _put_loc1_2_asm_h@PAGEOFF
	str	x8, [x0, #5480]
Lloh1412:
	adrp	x8, _put_loc2_2_asm_h@PAGE
Lloh1413:
	add	x8, x8, _put_loc2_2_asm_h@PAGEOFF
	str	x8, [x0, #5488]
Lloh1414:
	adrp	x8, _put_loc3_2_asm_h@PAGE
Lloh1415:
	add	x8, x8, _put_loc3_2_asm_h@PAGEOFF
	str	x8, [x0, #5496]
Lloh1416:
	adrp	x8, _set_loc0_2_asm_h@PAGE
Lloh1417:
	add	x8, x8, _set_loc0_2_asm_h@PAGEOFF
	str	x8, [x0, #5504]
Lloh1418:
	adrp	x8, _set_loc1_2_asm_h@PAGE
Lloh1419:
	add	x8, x8, _set_loc1_2_asm_h@PAGEOFF
	str	x8, [x0, #5512]
Lloh1420:
	adrp	x8, _set_loc2_2_asm_h@PAGE
Lloh1421:
	add	x8, x8, _set_loc2_2_asm_h@PAGEOFF
	str	x8, [x0, #5520]
Lloh1422:
	adrp	x8, _set_loc3_2_asm_h@PAGE
Lloh1423:
	add	x8, x8, _set_loc3_2_asm_h@PAGEOFF
	str	x8, [x0, #5528]
Lloh1424:
	adrp	x8, _get_arg0_2_asm_h@PAGE
Lloh1425:
	add	x8, x8, _get_arg0_2_asm_h@PAGEOFF
	str	x8, [x0, #5536]
Lloh1426:
	adrp	x8, _get_arg1_2_asm_h@PAGE
Lloh1427:
	add	x8, x8, _get_arg1_2_asm_h@PAGEOFF
	str	x8, [x0, #5544]
Lloh1428:
	adrp	x8, _get_arg2_2_asm_h@PAGE
Lloh1429:
	add	x8, x8, _get_arg2_2_asm_h@PAGEOFF
	str	x8, [x0, #5552]
Lloh1430:
	adrp	x8, _get_arg3_2_asm_h@PAGE
Lloh1431:
	add	x8, x8, _get_arg3_2_asm_h@PAGEOFF
	str	x8, [x0, #5560]
Lloh1432:
	adrp	x8, _put_arg0_2_asm_h@PAGE
Lloh1433:
	add	x8, x8, _put_arg0_2_asm_h@PAGEOFF
	str	x8, [x0, #5568]
Lloh1434:
	adrp	x8, _put_arg1_2_asm_h@PAGE
Lloh1435:
	add	x8, x8, _put_arg1_2_asm_h@PAGEOFF
	str	x8, [x0, #5576]
Lloh1436:
	adrp	x8, _put_arg2_2_asm_h@PAGE
Lloh1437:
	add	x8, x8, _put_arg2_2_asm_h@PAGEOFF
	str	x8, [x0, #5584]
Lloh1438:
	adrp	x8, _put_arg3_2_asm_h@PAGE
Lloh1439:
	add	x8, x8, _put_arg3_2_asm_h@PAGEOFF
	str	x8, [x0, #5592]
Lloh1440:
	adrp	x8, _set_arg0_2_asm_h@PAGE
Lloh1441:
	add	x8, x8, _set_arg0_2_asm_h@PAGEOFF
	str	x8, [x0, #5600]
Lloh1442:
	adrp	x8, _set_arg1_2_asm_h@PAGE
Lloh1443:
	add	x8, x8, _set_arg1_2_asm_h@PAGEOFF
	str	x8, [x0, #5608]
Lloh1444:
	adrp	x8, _set_arg2_2_asm_h@PAGE
Lloh1445:
	add	x8, x8, _set_arg2_2_asm_h@PAGEOFF
	str	x8, [x0, #5616]
Lloh1446:
	adrp	x8, _set_arg3_2_asm_h@PAGE
Lloh1447:
	add	x8, x8, _set_arg3_2_asm_h@PAGEOFF
	str	x8, [x0, #5624]
Lloh1448:
	adrp	x8, _get_var_ref0_2_asm_h@PAGE
Lloh1449:
	add	x8, x8, _get_var_ref0_2_asm_h@PAGEOFF
	str	x8, [x0, #5632]
Lloh1450:
	adrp	x8, _get_var_ref1_2_asm_h@PAGE
Lloh1451:
	add	x8, x8, _get_var_ref1_2_asm_h@PAGEOFF
	str	x8, [x0, #5640]
Lloh1452:
	adrp	x8, _get_var_ref2_2_asm_h@PAGE
Lloh1453:
	add	x8, x8, _get_var_ref2_2_asm_h@PAGEOFF
	str	x8, [x0, #5648]
Lloh1454:
	adrp	x8, _get_var_ref3_2_asm_h@PAGE
Lloh1455:
	add	x8, x8, _get_var_ref3_2_asm_h@PAGEOFF
	str	x8, [x0, #5656]
Lloh1456:
	adrp	x8, _put_var_ref0_2_asm_h@PAGE
Lloh1457:
	add	x8, x8, _put_var_ref0_2_asm_h@PAGEOFF
	str	x8, [x0, #5664]
Lloh1458:
	adrp	x8, _put_var_ref1_2_asm_h@PAGE
Lloh1459:
	add	x8, x8, _put_var_ref1_2_asm_h@PAGEOFF
	str	x8, [x0, #5672]
Lloh1460:
	adrp	x8, _put_var_ref2_2_asm_h@PAGE
Lloh1461:
	add	x8, x8, _put_var_ref2_2_asm_h@PAGEOFF
	str	x8, [x0, #5680]
Lloh1462:
	adrp	x8, _put_var_ref3_2_asm_h@PAGE
Lloh1463:
	add	x8, x8, _put_var_ref3_2_asm_h@PAGEOFF
	str	x8, [x0, #5688]
Lloh1464:
	adrp	x8, _set_var_ref0_2_asm_h@PAGE
Lloh1465:
	add	x8, x8, _set_var_ref0_2_asm_h@PAGEOFF
	str	x8, [x0, #5696]
Lloh1466:
	adrp	x8, _set_var_ref1_2_asm_h@PAGE
Lloh1467:
	add	x8, x8, _set_var_ref1_2_asm_h@PAGEOFF
	str	x8, [x0, #5704]
Lloh1468:
	adrp	x8, _set_var_ref2_2_asm_h@PAGE
Lloh1469:
	add	x8, x8, _set_var_ref2_2_asm_h@PAGEOFF
	str	x8, [x0, #5712]
Lloh1470:
	adrp	x8, _set_var_ref3_2_asm_h@PAGE
Lloh1471:
	add	x8, x8, _set_var_ref3_2_asm_h@PAGEOFF
	str	x8, [x0, #5720]
Lloh1472:
	adrp	x8, _get_length_2_asm_h@PAGE
Lloh1473:
	add	x8, x8, _get_length_2_asm_h@PAGEOFF
	str	x8, [x0, #5728]
Lloh1474:
	adrp	x8, _if_false8_2_asm_h@PAGE
Lloh1475:
	add	x8, x8, _if_false8_2_asm_h@PAGEOFF
	str	x8, [x0, #5736]
Lloh1476:
	adrp	x8, _if_true8_2_asm_h@PAGE
Lloh1477:
	add	x8, x8, _if_true8_2_asm_h@PAGEOFF
	str	x8, [x0, #5744]
Lloh1478:
	adrp	x8, _goto8_2_asm_h@PAGE
Lloh1479:
	add	x8, x8, _goto8_2_asm_h@PAGEOFF
	str	x8, [x0, #5752]
Lloh1480:
	adrp	x8, _goto16_2_asm_h@PAGE
Lloh1481:
	add	x8, x8, _goto16_2_asm_h@PAGEOFF
	str	x8, [x0, #5760]
Lloh1482:
	adrp	x8, _call0_2_asm_h@PAGE
Lloh1483:
	add	x8, x8, _call0_2_asm_h@PAGEOFF
	str	x8, [x0, #5768]
Lloh1484:
	adrp	x8, _call1_2_asm_h@PAGE
Lloh1485:
	add	x8, x8, _call1_2_asm_h@PAGEOFF
	str	x8, [x0, #5776]
Lloh1486:
	adrp	x8, _call2_2_asm_h@PAGE
Lloh1487:
	add	x8, x8, _call2_2_asm_h@PAGEOFF
	str	x8, [x0, #5784]
Lloh1488:
	adrp	x8, _call3_2_asm_h@PAGE
Lloh1489:
	add	x8, x8, _call3_2_asm_h@PAGEOFF
	str	x8, [x0, #5792]
Lloh1490:
	adrp	x8, _is_undefined_2_asm_h@PAGE
Lloh1491:
	add	x8, x8, _is_undefined_2_asm_h@PAGEOFF
	str	x8, [x0, #5800]
Lloh1492:
	adrp	x8, _is_null_2_asm_h@PAGE
Lloh1493:
	add	x8, x8, _is_null_2_asm_h@PAGEOFF
	str	x8, [x0, #5808]
Lloh1494:
	adrp	x8, _is_function_2_asm_h@PAGE
Lloh1495:
	add	x8, x8, _is_function_2_asm_h@PAGEOFF
	str	x8, [x0, #5816]
Lloh1496:
	adrp	x8, _inc_coverage_2_asm_h@PAGE
Lloh1497:
	add	x8, x8, _inc_coverage_2_asm_h@PAGEOFF
	str	x8, [x0, #5824]
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.loh AdrpAdd	Lloh1496, Lloh1497
	.loh AdrpAdd	Lloh1494, Lloh1495
	.loh AdrpAdd	Lloh1492, Lloh1493
	.loh AdrpAdd	Lloh1490, Lloh1491
	.loh AdrpAdd	Lloh1488, Lloh1489
	.loh AdrpAdd	Lloh1486, Lloh1487
	.loh AdrpAdd	Lloh1484, Lloh1485
	.loh AdrpAdd	Lloh1482, Lloh1483
	.loh AdrpAdd	Lloh1480, Lloh1481
	.loh AdrpAdd	Lloh1478, Lloh1479
	.loh AdrpAdd	Lloh1476, Lloh1477
	.loh AdrpAdd	Lloh1474, Lloh1475
	.loh AdrpAdd	Lloh1472, Lloh1473
	.loh AdrpAdd	Lloh1470, Lloh1471
	.loh AdrpAdd	Lloh1468, Lloh1469
	.loh AdrpAdd	Lloh1466, Lloh1467
	.loh AdrpAdd	Lloh1464, Lloh1465
	.loh AdrpAdd	Lloh1462, Lloh1463
	.loh AdrpAdd	Lloh1460, Lloh1461
	.loh AdrpAdd	Lloh1458, Lloh1459
	.loh AdrpAdd	Lloh1456, Lloh1457
	.loh AdrpAdd	Lloh1454, Lloh1455
	.loh AdrpAdd	Lloh1452, Lloh1453
	.loh AdrpAdd	Lloh1450, Lloh1451
	.loh AdrpAdd	Lloh1448, Lloh1449
	.loh AdrpAdd	Lloh1446, Lloh1447
	.loh AdrpAdd	Lloh1444, Lloh1445
	.loh AdrpAdd	Lloh1442, Lloh1443
	.loh AdrpAdd	Lloh1440, Lloh1441
	.loh AdrpAdd	Lloh1438, Lloh1439
	.loh AdrpAdd	Lloh1436, Lloh1437
	.loh AdrpAdd	Lloh1434, Lloh1435
	.loh AdrpAdd	Lloh1432, Lloh1433
	.loh AdrpAdd	Lloh1430, Lloh1431
	.loh AdrpAdd	Lloh1428, Lloh1429
	.loh AdrpAdd	Lloh1426, Lloh1427
	.loh AdrpAdd	Lloh1424, Lloh1425
	.loh AdrpAdd	Lloh1422, Lloh1423
	.loh AdrpAdd	Lloh1420, Lloh1421
	.loh AdrpAdd	Lloh1418, Lloh1419
	.loh AdrpAdd	Lloh1416, Lloh1417
	.loh AdrpAdd	Lloh1414, Lloh1415
	.loh AdrpAdd	Lloh1412, Lloh1413
	.loh AdrpAdd	Lloh1410, Lloh1411
	.loh AdrpAdd	Lloh1408, Lloh1409
	.loh AdrpAdd	Lloh1406, Lloh1407
	.loh AdrpAdd	Lloh1404, Lloh1405
	.loh AdrpAdd	Lloh1402, Lloh1403
	.loh AdrpAdd	Lloh1400, Lloh1401
	.loh AdrpAdd	Lloh1398, Lloh1399
	.loh AdrpAdd	Lloh1396, Lloh1397
	.loh AdrpAdd	Lloh1394, Lloh1395
	.loh AdrpAdd	Lloh1392, Lloh1393
	.loh AdrpAdd	Lloh1390, Lloh1391
	.loh AdrpAdd	Lloh1388, Lloh1389
	.loh AdrpAdd	Lloh1386, Lloh1387
	.loh AdrpAdd	Lloh1384, Lloh1385
	.loh AdrpAdd	Lloh1382, Lloh1383
	.loh AdrpAdd	Lloh1380, Lloh1381
	.loh AdrpAdd	Lloh1378, Lloh1379
	.loh AdrpAdd	Lloh1376, Lloh1377
	.loh AdrpAdd	Lloh1374, Lloh1375
	.loh AdrpAdd	Lloh1372, Lloh1373
	.loh AdrpAdd	Lloh1370, Lloh1371
	.loh AdrpAdd	Lloh1368, Lloh1369
	.loh AdrpAdd	Lloh1366, Lloh1367
	.loh AdrpAdd	Lloh1364, Lloh1365
	.loh AdrpAdd	Lloh1362, Lloh1363
	.loh AdrpAdd	Lloh1360, Lloh1361
	.loh AdrpAdd	Lloh1358, Lloh1359
	.loh AdrpAdd	Lloh1356, Lloh1357
	.loh AdrpAdd	Lloh1354, Lloh1355
	.loh AdrpAdd	Lloh1352, Lloh1353
	.loh AdrpAdd	Lloh1350, Lloh1351
	.loh AdrpAdd	Lloh1348, Lloh1349
	.loh AdrpAdd	Lloh1346, Lloh1347
	.loh AdrpAdd	Lloh1344, Lloh1345
	.loh AdrpAdd	Lloh1342, Lloh1343
	.loh AdrpAdd	Lloh1340, Lloh1341
	.loh AdrpAdd	Lloh1338, Lloh1339
	.loh AdrpAdd	Lloh1336, Lloh1337
	.loh AdrpAdd	Lloh1334, Lloh1335
	.loh AdrpAdd	Lloh1332, Lloh1333
	.loh AdrpAdd	Lloh1330, Lloh1331
	.loh AdrpAdd	Lloh1328, Lloh1329
	.loh AdrpAdd	Lloh1326, Lloh1327
	.loh AdrpAdd	Lloh1324, Lloh1325
	.loh AdrpAdd	Lloh1322, Lloh1323
	.loh AdrpAdd	Lloh1320, Lloh1321
	.loh AdrpAdd	Lloh1318, Lloh1319
	.loh AdrpAdd	Lloh1316, Lloh1317
	.loh AdrpAdd	Lloh1314, Lloh1315
	.loh AdrpAdd	Lloh1312, Lloh1313
	.loh AdrpAdd	Lloh1310, Lloh1311
	.loh AdrpAdd	Lloh1308, Lloh1309
	.loh AdrpAdd	Lloh1306, Lloh1307
	.loh AdrpAdd	Lloh1304, Lloh1305
	.loh AdrpAdd	Lloh1302, Lloh1303
	.loh AdrpAdd	Lloh1300, Lloh1301
	.loh AdrpAdd	Lloh1298, Lloh1299
	.loh AdrpAdd	Lloh1296, Lloh1297
	.loh AdrpAdd	Lloh1294, Lloh1295
	.loh AdrpAdd	Lloh1292, Lloh1293
	.loh AdrpAdd	Lloh1290, Lloh1291
	.loh AdrpAdd	Lloh1288, Lloh1289
	.loh AdrpAdd	Lloh1286, Lloh1287
	.loh AdrpAdd	Lloh1284, Lloh1285
	.loh AdrpAdd	Lloh1282, Lloh1283
	.loh AdrpAdd	Lloh1280, Lloh1281
	.loh AdrpAdd	Lloh1278, Lloh1279
	.loh AdrpAdd	Lloh1276, Lloh1277
	.loh AdrpAdd	Lloh1274, Lloh1275
	.loh AdrpAdd	Lloh1272, Lloh1273
	.loh AdrpAdd	Lloh1270, Lloh1271
	.loh AdrpAdd	Lloh1268, Lloh1269
	.loh AdrpAdd	Lloh1266, Lloh1267
	.loh AdrpAdd	Lloh1264, Lloh1265
	.loh AdrpAdd	Lloh1262, Lloh1263
	.loh AdrpAdd	Lloh1260, Lloh1261
	.loh AdrpAdd	Lloh1258, Lloh1259
	.loh AdrpAdd	Lloh1256, Lloh1257
	.loh AdrpAdd	Lloh1254, Lloh1255
	.loh AdrpAdd	Lloh1252, Lloh1253
	.loh AdrpAdd	Lloh1250, Lloh1251
	.loh AdrpAdd	Lloh1248, Lloh1249
	.loh AdrpAdd	Lloh1246, Lloh1247
	.loh AdrpAdd	Lloh1244, Lloh1245
	.loh AdrpAdd	Lloh1242, Lloh1243
	.loh AdrpAdd	Lloh1240, Lloh1241
	.loh AdrpAdd	Lloh1238, Lloh1239
	.loh AdrpAdd	Lloh1236, Lloh1237
	.loh AdrpAdd	Lloh1234, Lloh1235
	.loh AdrpAdd	Lloh1232, Lloh1233
	.loh AdrpAdd	Lloh1230, Lloh1231
	.loh AdrpAdd	Lloh1228, Lloh1229
	.loh AdrpAdd	Lloh1226, Lloh1227
	.loh AdrpAdd	Lloh1224, Lloh1225
	.loh AdrpAdd	Lloh1222, Lloh1223
	.loh AdrpAdd	Lloh1220, Lloh1221
	.loh AdrpAdd	Lloh1218, Lloh1219
	.loh AdrpAdd	Lloh1216, Lloh1217
	.loh AdrpAdd	Lloh1214, Lloh1215
	.loh AdrpAdd	Lloh1212, Lloh1213
	.loh AdrpAdd	Lloh1210, Lloh1211
	.loh AdrpAdd	Lloh1208, Lloh1209
	.loh AdrpAdd	Lloh1206, Lloh1207
	.loh AdrpAdd	Lloh1204, Lloh1205
	.loh AdrpAdd	Lloh1202, Lloh1203
	.loh AdrpAdd	Lloh1200, Lloh1201
	.loh AdrpAdd	Lloh1198, Lloh1199
	.loh AdrpAdd	Lloh1196, Lloh1197
	.loh AdrpAdd	Lloh1194, Lloh1195
	.loh AdrpAdd	Lloh1192, Lloh1193
	.loh AdrpAdd	Lloh1190, Lloh1191
	.loh AdrpAdd	Lloh1188, Lloh1189
	.loh AdrpAdd	Lloh1186, Lloh1187
	.loh AdrpAdd	Lloh1184, Lloh1185
	.loh AdrpAdd	Lloh1182, Lloh1183
	.loh AdrpAdd	Lloh1180, Lloh1181
	.loh AdrpAdd	Lloh1178, Lloh1179
	.loh AdrpAdd	Lloh1176, Lloh1177
	.loh AdrpAdd	Lloh1174, Lloh1175
	.loh AdrpAdd	Lloh1172, Lloh1173
	.loh AdrpAdd	Lloh1170, Lloh1171
	.loh AdrpAdd	Lloh1168, Lloh1169
	.loh AdrpAdd	Lloh1166, Lloh1167
	.loh AdrpAdd	Lloh1164, Lloh1165
	.loh AdrpAdd	Lloh1162, Lloh1163
	.loh AdrpAdd	Lloh1160, Lloh1161
	.loh AdrpAdd	Lloh1158, Lloh1159
	.loh AdrpAdd	Lloh1156, Lloh1157
	.loh AdrpAdd	Lloh1154, Lloh1155
	.loh AdrpAdd	Lloh1152, Lloh1153
	.loh AdrpAdd	Lloh1150, Lloh1151
	.loh AdrpAdd	Lloh1148, Lloh1149
	.loh AdrpAdd	Lloh1146, Lloh1147
	.loh AdrpAdd	Lloh1144, Lloh1145
	.loh AdrpAdd	Lloh1142, Lloh1143
	.loh AdrpAdd	Lloh1140, Lloh1141
	.loh AdrpAdd	Lloh1138, Lloh1139
	.loh AdrpAdd	Lloh1136, Lloh1137
	.loh AdrpAdd	Lloh1134, Lloh1135
	.loh AdrpAdd	Lloh1132, Lloh1133
	.loh AdrpAdd	Lloh1130, Lloh1131
	.loh AdrpAdd	Lloh1128, Lloh1129
	.loh AdrpAdd	Lloh1126, Lloh1127
	.loh AdrpAdd	Lloh1124, Lloh1125
	.loh AdrpAdd	Lloh1122, Lloh1123
	.loh AdrpAdd	Lloh1120, Lloh1121
	.loh AdrpAdd	Lloh1118, Lloh1119
	.loh AdrpAdd	Lloh1116, Lloh1117
	.loh AdrpAdd	Lloh1114, Lloh1115
	.loh AdrpAdd	Lloh1112, Lloh1113
	.loh AdrpAdd	Lloh1110, Lloh1111
	.loh AdrpAdd	Lloh1108, Lloh1109
	.loh AdrpAdd	Lloh1106, Lloh1107
	.loh AdrpAdd	Lloh1104, Lloh1105
	.loh AdrpAdd	Lloh1102, Lloh1103
	.loh AdrpAdd	Lloh1100, Lloh1101
	.loh AdrpAdd	Lloh1098, Lloh1099
	.loh AdrpAdd	Lloh1096, Lloh1097
	.loh AdrpAdd	Lloh1094, Lloh1095
	.loh AdrpAdd	Lloh1092, Lloh1093
	.loh AdrpAdd	Lloh1090, Lloh1091
	.loh AdrpAdd	Lloh1088, Lloh1089
	.loh AdrpAdd	Lloh1086, Lloh1087
	.loh AdrpAdd	Lloh1084, Lloh1085
	.loh AdrpAdd	Lloh1082, Lloh1083
	.loh AdrpAdd	Lloh1080, Lloh1081
	.loh AdrpAdd	Lloh1078, Lloh1079
	.loh AdrpAdd	Lloh1076, Lloh1077
	.loh AdrpAdd	Lloh1074, Lloh1075
	.loh AdrpAdd	Lloh1072, Lloh1073
	.loh AdrpAdd	Lloh1070, Lloh1071
	.loh AdrpAdd	Lloh1068, Lloh1069
	.loh AdrpAdd	Lloh1066, Lloh1067
	.loh AdrpAdd	Lloh1064, Lloh1065
	.loh AdrpAdd	Lloh1062, Lloh1063
	.loh AdrpAdd	Lloh1060, Lloh1061
	.loh AdrpAdd	Lloh1058, Lloh1059
	.loh AdrpAdd	Lloh1056, Lloh1057
	.loh AdrpAdd	Lloh1054, Lloh1055
	.loh AdrpAdd	Lloh1052, Lloh1053
	.loh AdrpAdd	Lloh1050, Lloh1051
	.loh AdrpAdd	Lloh1048, Lloh1049
	.loh AdrpAdd	Lloh1046, Lloh1047
	.loh AdrpAdd	Lloh1044, Lloh1045
	.loh AdrpAdd	Lloh1042, Lloh1043
	.loh AdrpAdd	Lloh1040, Lloh1041
	.loh AdrpAdd	Lloh1038, Lloh1039
	.loh AdrpAdd	Lloh1036, Lloh1037
	.loh AdrpAdd	Lloh1034, Lloh1035
	.loh AdrpAdd	Lloh1032, Lloh1033
	.loh AdrpAdd	Lloh1030, Lloh1031
	.loh AdrpAdd	Lloh1028, Lloh1029
	.loh AdrpAdd	Lloh1026, Lloh1027
	.loh AdrpAdd	Lloh1024, Lloh1025
	.loh AdrpAdd	Lloh1022, Lloh1023
	.loh AdrpAdd	Lloh1020, Lloh1021
	.loh AdrpAdd	Lloh1018, Lloh1019
	.loh AdrpAdd	Lloh1016, Lloh1017
	.loh AdrpAdd	Lloh1014, Lloh1015
	.loh AdrpAdd	Lloh1012, Lloh1013
	.loh AdrpAdd	Lloh1010, Lloh1011
	.loh AdrpAdd	Lloh1008, Lloh1009
	.loh AdrpAdd	Lloh1006, Lloh1007
	.loh AdrpAdd	Lloh1004, Lloh1005
	.loh AdrpAdd	Lloh1002, Lloh1003
	.loh AdrpAdd	Lloh1000, Lloh1001
	.loh AdrpAdd	Lloh998, Lloh999
	.loh AdrpAdd	Lloh996, Lloh997
	.loh AdrpAdd	Lloh994, Lloh995
	.loh AdrpAdd	Lloh992, Lloh993
	.loh AdrpAdd	Lloh990, Lloh991
	.loh AdrpAdd	Lloh988, Lloh989
	.loh AdrpAdd	Lloh986, Lloh987
	.loh AdrpAdd	Lloh984, Lloh985
	.loh AdrpAdd	Lloh982, Lloh983
	.loh AdrpAdd	Lloh980, Lloh981
	.loh AdrpAdd	Lloh978, Lloh979
	.loh AdrpAdd	Lloh976, Lloh977
	.loh AdrpAdd	Lloh974, Lloh975
	.loh AdrpAdd	Lloh972, Lloh973
	.loh AdrpAdd	Lloh970, Lloh971
	.loh AdrpAdd	Lloh968, Lloh969
	.loh AdrpAdd	Lloh966, Lloh967
	.loh AdrpAdd	Lloh964, Lloh965
	.loh AdrpAdd	Lloh962, Lloh963
	.loh AdrpAdd	Lloh960, Lloh961
	.loh AdrpAdd	Lloh958, Lloh959
	.loh AdrpAdd	Lloh956, Lloh957
	.loh AdrpAdd	Lloh954, Lloh955
	.loh AdrpAdd	Lloh952, Lloh953
	.loh AdrpAdd	Lloh950, Lloh951
	.loh AdrpAdd	Lloh948, Lloh949
	.loh AdrpAdd	Lloh946, Lloh947
	.loh AdrpAdd	Lloh944, Lloh945
	.loh AdrpAdd	Lloh942, Lloh943
	.loh AdrpAdd	Lloh940, Lloh941
	.loh AdrpAdd	Lloh938, Lloh939
	.loh AdrpAdd	Lloh936, Lloh937
	.loh AdrpAdd	Lloh934, Lloh935
	.loh AdrpAdd	Lloh932, Lloh933
	.loh AdrpAdd	Lloh930, Lloh931
	.loh AdrpAdd	Lloh928, Lloh929
	.loh AdrpAdd	Lloh926, Lloh927
	.loh AdrpAdd	Lloh924, Lloh925
	.loh AdrpAdd	Lloh922, Lloh923
	.loh AdrpAdd	Lloh920, Lloh921
	.loh AdrpAdd	Lloh918, Lloh919
	.loh AdrpAdd	Lloh916, Lloh917
	.loh AdrpAdd	Lloh914, Lloh915
	.loh AdrpAdd	Lloh912, Lloh913
	.loh AdrpAdd	Lloh910, Lloh911
	.loh AdrpAdd	Lloh908, Lloh909
	.loh AdrpAdd	Lloh906, Lloh907
	.loh AdrpAdd	Lloh904, Lloh905
	.loh AdrpAdd	Lloh902, Lloh903
	.loh AdrpAdd	Lloh900, Lloh901
	.loh AdrpAdd	Lloh898, Lloh899
	.loh AdrpAdd	Lloh896, Lloh897
	.loh AdrpAdd	Lloh894, Lloh895
	.loh AdrpAdd	Lloh892, Lloh893
	.loh AdrpAdd	Lloh890, Lloh891
	.loh AdrpAdd	Lloh888, Lloh889
	.loh AdrpAdd	Lloh886, Lloh887
	.loh AdrpAdd	Lloh884, Lloh885
	.loh AdrpAdd	Lloh882, Lloh883
	.loh AdrpAdd	Lloh880, Lloh881
	.loh AdrpAdd	Lloh878, Lloh879
	.loh AdrpAdd	Lloh876, Lloh877
	.loh AdrpAdd	Lloh874, Lloh875
	.loh AdrpAdd	Lloh872, Lloh873
	.loh AdrpAdd	Lloh870, Lloh871
	.loh AdrpAdd	Lloh868, Lloh869
	.loh AdrpAdd	Lloh866, Lloh867
	.loh AdrpAdd	Lloh864, Lloh865
	.loh AdrpAdd	Lloh862, Lloh863
	.loh AdrpAdd	Lloh860, Lloh861
	.loh AdrpAdd	Lloh858, Lloh859
	.loh AdrpAdd	Lloh856, Lloh857
	.loh AdrpAdd	Lloh854, Lloh855
	.loh AdrpAdd	Lloh852, Lloh853
	.loh AdrpAdd	Lloh850, Lloh851
	.loh AdrpAdd	Lloh848, Lloh849
	.loh AdrpAdd	Lloh846, Lloh847
	.loh AdrpAdd	Lloh844, Lloh845
	.loh AdrpAdd	Lloh842, Lloh843
	.loh AdrpAdd	Lloh840, Lloh841
	.loh AdrpAdd	Lloh838, Lloh839
	.loh AdrpAdd	Lloh836, Lloh837
	.loh AdrpAdd	Lloh834, Lloh835
	.loh AdrpAdd	Lloh832, Lloh833
	.loh AdrpAdd	Lloh830, Lloh831
	.loh AdrpAdd	Lloh828, Lloh829
	.loh AdrpAdd	Lloh826, Lloh827
	.loh AdrpAdd	Lloh824, Lloh825
	.loh AdrpAdd	Lloh822, Lloh823
	.loh AdrpAdd	Lloh820, Lloh821
	.loh AdrpAdd	Lloh818, Lloh819
	.loh AdrpAdd	Lloh816, Lloh817
	.loh AdrpAdd	Lloh814, Lloh815
	.loh AdrpAdd	Lloh812, Lloh813
	.loh AdrpAdd	Lloh810, Lloh811
	.loh AdrpAdd	Lloh808, Lloh809
	.loh AdrpAdd	Lloh806, Lloh807
	.loh AdrpAdd	Lloh804, Lloh805
	.loh AdrpAdd	Lloh802, Lloh803
	.loh AdrpAdd	Lloh800, Lloh801
	.loh AdrpAdd	Lloh798, Lloh799
	.loh AdrpAdd	Lloh796, Lloh797
	.loh AdrpAdd	Lloh794, Lloh795
	.loh AdrpAdd	Lloh792, Lloh793
	.loh AdrpAdd	Lloh790, Lloh791
	.loh AdrpAdd	Lloh788, Lloh789
	.loh AdrpAdd	Lloh786, Lloh787
	.loh AdrpAdd	Lloh784, Lloh785
	.loh AdrpAdd	Lloh782, Lloh783
	.loh AdrpAdd	Lloh780, Lloh781
	.loh AdrpAdd	Lloh778, Lloh779
	.loh AdrpAdd	Lloh776, Lloh777
	.loh AdrpAdd	Lloh774, Lloh775
	.loh AdrpAdd	Lloh772, Lloh773
	.loh AdrpAdd	Lloh770, Lloh771
	.loh AdrpAdd	Lloh768, Lloh769
	.loh AdrpAdd	Lloh766, Lloh767
	.loh AdrpAdd	Lloh764, Lloh765
	.loh AdrpAdd	Lloh762, Lloh763
	.loh AdrpAdd	Lloh760, Lloh761
	.loh AdrpAdd	Lloh758, Lloh759
	.loh AdrpAdd	Lloh756, Lloh757
	.loh AdrpAdd	Lloh754, Lloh755
	.loh AdrpAdd	Lloh752, Lloh753
	.loh AdrpAdd	Lloh750, Lloh751
	.loh AdrpAdd	Lloh748, Lloh749
	.loh AdrpAdd	Lloh746, Lloh747
	.loh AdrpAdd	Lloh744, Lloh745
	.loh AdrpAdd	Lloh742, Lloh743
	.loh AdrpAdd	Lloh740, Lloh741
	.loh AdrpAdd	Lloh738, Lloh739
	.loh AdrpAdd	Lloh736, Lloh737
	.loh AdrpAdd	Lloh734, Lloh735
	.loh AdrpAdd	Lloh732, Lloh733
	.loh AdrpAdd	Lloh730, Lloh731
	.loh AdrpAdd	Lloh728, Lloh729
	.loh AdrpAdd	Lloh726, Lloh727
	.loh AdrpAdd	Lloh724, Lloh725
	.loh AdrpAdd	Lloh722, Lloh723
	.loh AdrpAdd	Lloh720, Lloh721
	.loh AdrpAdd	Lloh718, Lloh719
	.loh AdrpAdd	Lloh716, Lloh717
	.loh AdrpAdd	Lloh714, Lloh715
	.loh AdrpAdd	Lloh712, Lloh713
	.loh AdrpAdd	Lloh710, Lloh711
	.loh AdrpAdd	Lloh708, Lloh709
	.loh AdrpAdd	Lloh706, Lloh707
	.loh AdrpAdd	Lloh704, Lloh705
	.loh AdrpAdd	Lloh702, Lloh703
	.loh AdrpAdd	Lloh700, Lloh701
	.loh AdrpAdd	Lloh698, Lloh699
	.loh AdrpAdd	Lloh696, Lloh697
	.loh AdrpAdd	Lloh694, Lloh695
	.loh AdrpAdd	Lloh692, Lloh693
	.loh AdrpAdd	Lloh690, Lloh691
	.loh AdrpAdd	Lloh688, Lloh689
	.loh AdrpAdd	Lloh686, Lloh687
	.loh AdrpAdd	Lloh684, Lloh685
	.loh AdrpAdd	Lloh682, Lloh683
	.loh AdrpAdd	Lloh680, Lloh681
	.loh AdrpAdd	Lloh678, Lloh679
	.loh AdrpAdd	Lloh676, Lloh677
	.loh AdrpAdd	Lloh674, Lloh675
	.loh AdrpAdd	Lloh672, Lloh673
	.loh AdrpAdd	Lloh670, Lloh671
	.loh AdrpAdd	Lloh668, Lloh669
	.loh AdrpAdd	Lloh666, Lloh667
	.loh AdrpAdd	Lloh664, Lloh665
	.loh AdrpAdd	Lloh662, Lloh663
	.loh AdrpAdd	Lloh660, Lloh661
	.loh AdrpAdd	Lloh658, Lloh659
	.loh AdrpAdd	Lloh656, Lloh657
	.loh AdrpAdd	Lloh654, Lloh655
	.loh AdrpAdd	Lloh652, Lloh653
	.loh AdrpAdd	Lloh650, Lloh651
	.loh AdrpAdd	Lloh648, Lloh649
	.loh AdrpAdd	Lloh646, Lloh647
	.loh AdrpAdd	Lloh644, Lloh645
	.loh AdrpAdd	Lloh642, Lloh643
	.loh AdrpAdd	Lloh640, Lloh641
	.loh AdrpAdd	Lloh638, Lloh639
	.loh AdrpAdd	Lloh636, Lloh637
	.loh AdrpAdd	Lloh634, Lloh635
	.loh AdrpAdd	Lloh632, Lloh633
	.loh AdrpAdd	Lloh630, Lloh631
	.loh AdrpAdd	Lloh628, Lloh629
	.loh AdrpAdd	Lloh626, Lloh627
	.loh AdrpAdd	Lloh624, Lloh625
	.loh AdrpAdd	Lloh622, Lloh623
	.loh AdrpAdd	Lloh620, Lloh621
	.loh AdrpAdd	Lloh618, Lloh619
	.loh AdrpAdd	Lloh616, Lloh617
	.loh AdrpAdd	Lloh614, Lloh615
	.loh AdrpAdd	Lloh612, Lloh613
	.loh AdrpAdd	Lloh610, Lloh611
	.loh AdrpAdd	Lloh608, Lloh609
	.loh AdrpAdd	Lloh606, Lloh607
	.loh AdrpAdd	Lloh604, Lloh605
	.loh AdrpAdd	Lloh602, Lloh603
	.loh AdrpAdd	Lloh600, Lloh601
	.loh AdrpAdd	Lloh598, Lloh599
	.loh AdrpAdd	Lloh596, Lloh597
	.loh AdrpAdd	Lloh594, Lloh595
	.loh AdrpAdd	Lloh592, Lloh593
	.loh AdrpAdd	Lloh590, Lloh591
	.loh AdrpAdd	Lloh588, Lloh589
	.loh AdrpAdd	Lloh586, Lloh587
	.loh AdrpAdd	Lloh584, Lloh585
	.loh AdrpAdd	Lloh582, Lloh583
	.loh AdrpAdd	Lloh580, Lloh581
	.loh AdrpAdd	Lloh578, Lloh579
	.loh AdrpAdd	Lloh576, Lloh577
	.loh AdrpAdd	Lloh574, Lloh575
	.loh AdrpAdd	Lloh572, Lloh573
	.loh AdrpAdd	Lloh570, Lloh571
	.loh AdrpAdd	Lloh568, Lloh569
	.loh AdrpAdd	Lloh566, Lloh567
	.loh AdrpAdd	Lloh564, Lloh565
	.loh AdrpAdd	Lloh562, Lloh563
	.loh AdrpAdd	Lloh560, Lloh561
	.loh AdrpAdd	Lloh558, Lloh559
	.loh AdrpAdd	Lloh556, Lloh557
	.loh AdrpAdd	Lloh554, Lloh555
	.loh AdrpAdd	Lloh552, Lloh553
	.loh AdrpAdd	Lloh550, Lloh551
	.loh AdrpAdd	Lloh548, Lloh549
	.loh AdrpAdd	Lloh546, Lloh547
	.loh AdrpAdd	Lloh544, Lloh545
	.loh AdrpAdd	Lloh542, Lloh543
	.loh AdrpAdd	Lloh540, Lloh541
	.loh AdrpAdd	Lloh538, Lloh539
	.loh AdrpAdd	Lloh536, Lloh537
	.loh AdrpAdd	Lloh534, Lloh535
	.loh AdrpAdd	Lloh532, Lloh533
	.loh AdrpAdd	Lloh530, Lloh531
	.loh AdrpAdd	Lloh528, Lloh529
	.loh AdrpAdd	Lloh526, Lloh527
	.loh AdrpAdd	Lloh524, Lloh525
	.loh AdrpAdd	Lloh522, Lloh523
	.loh AdrpAdd	Lloh520, Lloh521
	.loh AdrpAdd	Lloh518, Lloh519
	.loh AdrpAdd	Lloh516, Lloh517
	.loh AdrpAdd	Lloh514, Lloh515
	.loh AdrpAdd	Lloh512, Lloh513
	.loh AdrpAdd	Lloh510, Lloh511
	.loh AdrpAdd	Lloh508, Lloh509
	.loh AdrpAdd	Lloh506, Lloh507
	.loh AdrpAdd	Lloh504, Lloh505
	.loh AdrpAdd	Lloh502, Lloh503
	.loh AdrpAdd	Lloh500, Lloh501
	.loh AdrpAdd	Lloh498, Lloh499
	.loh AdrpAdd	Lloh496, Lloh497
	.loh AdrpAdd	Lloh494, Lloh495
	.loh AdrpAdd	Lloh492, Lloh493
	.loh AdrpAdd	Lloh490, Lloh491
	.loh AdrpAdd	Lloh488, Lloh489
	.loh AdrpAdd	Lloh486, Lloh487
	.loh AdrpAdd	Lloh484, Lloh485
	.loh AdrpAdd	Lloh482, Lloh483
	.loh AdrpAdd	Lloh480, Lloh481
	.loh AdrpAdd	Lloh478, Lloh479
	.loh AdrpAdd	Lloh476, Lloh477
	.loh AdrpAdd	Lloh474, Lloh475
	.loh AdrpAdd	Lloh472, Lloh473
	.loh AdrpAdd	Lloh470, Lloh471
	.loh AdrpAdd	Lloh468, Lloh469
	.loh AdrpAdd	Lloh466, Lloh467
	.loh AdrpAdd	Lloh464, Lloh465
	.loh AdrpAdd	Lloh462, Lloh463
	.loh AdrpAdd	Lloh460, Lloh461
	.loh AdrpAdd	Lloh458, Lloh459
	.loh AdrpAdd	Lloh456, Lloh457
	.loh AdrpAdd	Lloh454, Lloh455
	.loh AdrpAdd	Lloh452, Lloh453
	.loh AdrpAdd	Lloh450, Lloh451
	.loh AdrpAdd	Lloh448, Lloh449
	.loh AdrpAdd	Lloh446, Lloh447
	.loh AdrpAdd	Lloh444, Lloh445
	.loh AdrpAdd	Lloh442, Lloh443
	.loh AdrpAdd	Lloh440, Lloh441
	.loh AdrpAdd	Lloh438, Lloh439
	.loh AdrpAdd	Lloh436, Lloh437
	.loh AdrpAdd	Lloh434, Lloh435
	.loh AdrpAdd	Lloh432, Lloh433
	.loh AdrpAdd	Lloh430, Lloh431
	.loh AdrpAdd	Lloh428, Lloh429
	.loh AdrpAdd	Lloh426, Lloh427
	.loh AdrpAdd	Lloh424, Lloh425
	.loh AdrpAdd	Lloh422, Lloh423
	.loh AdrpAdd	Lloh420, Lloh421
	.loh AdrpAdd	Lloh418, Lloh419
	.loh AdrpAdd	Lloh416, Lloh417
	.loh AdrpAdd	Lloh414, Lloh415
	.loh AdrpAdd	Lloh412, Lloh413
	.loh AdrpAdd	Lloh410, Lloh411
	.loh AdrpAdd	Lloh408, Lloh409
	.loh AdrpAdd	Lloh406, Lloh407
	.loh AdrpAdd	Lloh404, Lloh405
	.loh AdrpAdd	Lloh402, Lloh403
	.loh AdrpAdd	Lloh400, Lloh401
	.loh AdrpAdd	Lloh398, Lloh399
	.loh AdrpAdd	Lloh396, Lloh397
	.loh AdrpAdd	Lloh394, Lloh395
	.loh AdrpAdd	Lloh392, Lloh393
	.loh AdrpAdd	Lloh390, Lloh391
	.loh AdrpAdd	Lloh388, Lloh389
	.loh AdrpAdd	Lloh386, Lloh387
	.loh AdrpAdd	Lloh384, Lloh385
	.loh AdrpAdd	Lloh382, Lloh383
	.loh AdrpAdd	Lloh380, Lloh381
	.loh AdrpAdd	Lloh378, Lloh379
	.loh AdrpAdd	Lloh376, Lloh377
	.loh AdrpAdd	Lloh374, Lloh375
	.loh AdrpAdd	Lloh372, Lloh373
	.loh AdrpAdd	Lloh370, Lloh371
	.loh AdrpAdd	Lloh368, Lloh369
	.loh AdrpAdd	Lloh366, Lloh367
	.loh AdrpAdd	Lloh364, Lloh365
	.loh AdrpAdd	Lloh362, Lloh363
	.loh AdrpAdd	Lloh360, Lloh361
	.loh AdrpAdd	Lloh358, Lloh359
	.loh AdrpAdd	Lloh356, Lloh357
	.loh AdrpAdd	Lloh354, Lloh355
	.loh AdrpAdd	Lloh352, Lloh353
	.loh AdrpAdd	Lloh350, Lloh351
	.loh AdrpAdd	Lloh348, Lloh349
	.loh AdrpAdd	Lloh346, Lloh347
	.loh AdrpAdd	Lloh344, Lloh345
	.loh AdrpAdd	Lloh342, Lloh343
	.loh AdrpAdd	Lloh340, Lloh341
	.loh AdrpAdd	Lloh338, Lloh339
	.loh AdrpAdd	Lloh336, Lloh337
	.loh AdrpAdd	Lloh334, Lloh335
	.loh AdrpAdd	Lloh332, Lloh333
	.loh AdrpAdd	Lloh330, Lloh331
	.loh AdrpAdd	Lloh328, Lloh329
	.loh AdrpAdd	Lloh326, Lloh327
	.loh AdrpAdd	Lloh324, Lloh325
	.loh AdrpAdd	Lloh322, Lloh323
	.loh AdrpAdd	Lloh320, Lloh321
	.loh AdrpAdd	Lloh318, Lloh319
	.loh AdrpAdd	Lloh316, Lloh317
	.loh AdrpAdd	Lloh314, Lloh315
	.loh AdrpAdd	Lloh312, Lloh313
	.loh AdrpAdd	Lloh310, Lloh311
	.loh AdrpAdd	Lloh308, Lloh309
	.loh AdrpAdd	Lloh306, Lloh307
	.loh AdrpAdd	Lloh304, Lloh305
	.loh AdrpAdd	Lloh302, Lloh303
	.loh AdrpAdd	Lloh300, Lloh301
	.loh AdrpAdd	Lloh298, Lloh299
	.loh AdrpAdd	Lloh296, Lloh297
	.loh AdrpAdd	Lloh294, Lloh295
	.loh AdrpAdd	Lloh292, Lloh293
	.loh AdrpAdd	Lloh290, Lloh291
	.loh AdrpAdd	Lloh288, Lloh289
	.loh AdrpAdd	Lloh286, Lloh287
	.loh AdrpAdd	Lloh284, Lloh285
	.loh AdrpAdd	Lloh282, Lloh283
	.loh AdrpAdd	Lloh280, Lloh281
	.loh AdrpAdd	Lloh278, Lloh279
	.loh AdrpAdd	Lloh276, Lloh277
	.loh AdrpAdd	Lloh274, Lloh275
	.loh AdrpAdd	Lloh272, Lloh273
	.loh AdrpAdd	Lloh270, Lloh271
	.loh AdrpAdd	Lloh268, Lloh269
	.loh AdrpAdd	Lloh266, Lloh267
	.loh AdrpAdd	Lloh264, Lloh265
	.loh AdrpAdd	Lloh262, Lloh263
	.loh AdrpAdd	Lloh260, Lloh261
	.loh AdrpAdd	Lloh258, Lloh259
	.loh AdrpAdd	Lloh256, Lloh257
	.loh AdrpAdd	Lloh254, Lloh255
	.loh AdrpAdd	Lloh252, Lloh253
	.loh AdrpAdd	Lloh250, Lloh251
	.loh AdrpAdd	Lloh248, Lloh249
	.loh AdrpAdd	Lloh246, Lloh247
	.loh AdrpAdd	Lloh244, Lloh245
	.loh AdrpAdd	Lloh242, Lloh243
	.loh AdrpAdd	Lloh240, Lloh241
	.loh AdrpAdd	Lloh238, Lloh239
	.loh AdrpAdd	Lloh236, Lloh237
	.loh AdrpAdd	Lloh234, Lloh235
	.loh AdrpAdd	Lloh232, Lloh233
	.loh AdrpAdd	Lloh230, Lloh231
	.loh AdrpAdd	Lloh228, Lloh229
	.loh AdrpAdd	Lloh226, Lloh227
	.loh AdrpAdd	Lloh224, Lloh225
	.loh AdrpAdd	Lloh222, Lloh223
	.loh AdrpAdd	Lloh220, Lloh221
	.loh AdrpAdd	Lloh218, Lloh219
	.loh AdrpAdd	Lloh216, Lloh217
	.loh AdrpAdd	Lloh214, Lloh215
	.loh AdrpAdd	Lloh212, Lloh213
	.loh AdrpAdd	Lloh210, Lloh211
	.loh AdrpAdd	Lloh208, Lloh209
	.loh AdrpAdd	Lloh206, Lloh207
	.loh AdrpAdd	Lloh204, Lloh205
	.loh AdrpAdd	Lloh202, Lloh203
	.loh AdrpAdd	Lloh200, Lloh201
	.loh AdrpAdd	Lloh198, Lloh199
	.loh AdrpAdd	Lloh196, Lloh197
	.loh AdrpAdd	Lloh194, Lloh195
	.loh AdrpAdd	Lloh192, Lloh193
	.loh AdrpAdd	Lloh190, Lloh191
	.loh AdrpAdd	Lloh188, Lloh189
	.loh AdrpAdd	Lloh186, Lloh187
	.loh AdrpAdd	Lloh184, Lloh185
	.loh AdrpAdd	Lloh182, Lloh183
	.loh AdrpAdd	Lloh180, Lloh181
	.loh AdrpAdd	Lloh178, Lloh179
	.loh AdrpAdd	Lloh176, Lloh177
	.loh AdrpAdd	Lloh174, Lloh175
	.loh AdrpAdd	Lloh172, Lloh173
	.loh AdrpAdd	Lloh170, Lloh171
	.loh AdrpAdd	Lloh168, Lloh169
	.loh AdrpAdd	Lloh166, Lloh167
	.loh AdrpAdd	Lloh164, Lloh165
	.loh AdrpAdd	Lloh162, Lloh163
	.loh AdrpAdd	Lloh160, Lloh161
	.loh AdrpAdd	Lloh158, Lloh159
	.loh AdrpAdd	Lloh156, Lloh157
	.loh AdrpAdd	Lloh154, Lloh155
	.loh AdrpAdd	Lloh152, Lloh153
	.loh AdrpAdd	Lloh150, Lloh151
	.loh AdrpAdd	Lloh148, Lloh149
	.loh AdrpAdd	Lloh146, Lloh147
	.loh AdrpAdd	Lloh144, Lloh145
	.loh AdrpAdd	Lloh142, Lloh143
	.loh AdrpAdd	Lloh140, Lloh141
	.loh AdrpAdd	Lloh138, Lloh139
	.loh AdrpAdd	Lloh136, Lloh137
	.loh AdrpAdd	Lloh134, Lloh135
	.loh AdrpAdd	Lloh132, Lloh133
	.loh AdrpAdd	Lloh130, Lloh131
	.loh AdrpAdd	Lloh128, Lloh129
	.loh AdrpAdd	Lloh126, Lloh127
	.loh AdrpAdd	Lloh124, Lloh125
	.loh AdrpAdd	Lloh122, Lloh123
	.loh AdrpAdd	Lloh120, Lloh121
	.loh AdrpAdd	Lloh118, Lloh119
	.loh AdrpAdd	Lloh116, Lloh117
	.loh AdrpAdd	Lloh114, Lloh115
	.loh AdrpAdd	Lloh112, Lloh113
	.loh AdrpAdd	Lloh110, Lloh111
	.loh AdrpAdd	Lloh108, Lloh109
	.loh AdrpAdd	Lloh106, Lloh107
	.loh AdrpAdd	Lloh104, Lloh105
	.loh AdrpAdd	Lloh102, Lloh103
	.loh AdrpAdd	Lloh100, Lloh101
	.loh AdrpAdd	Lloh98, Lloh99
	.loh AdrpAdd	Lloh96, Lloh97
	.loh AdrpAdd	Lloh94, Lloh95
	.loh AdrpAdd	Lloh92, Lloh93
	.loh AdrpAdd	Lloh90, Lloh91
	.loh AdrpAdd	Lloh88, Lloh89
	.loh AdrpAdd	Lloh86, Lloh87
	.loh AdrpAdd	Lloh84, Lloh85
	.loh AdrpAdd	Lloh82, Lloh83
	.loh AdrpAdd	Lloh80, Lloh81
	.loh AdrpAdd	Lloh78, Lloh79
	.loh AdrpAdd	Lloh76, Lloh77
	.loh AdrpAdd	Lloh74, Lloh75
	.loh AdrpAdd	Lloh72, Lloh73
	.loh AdrpAdd	Lloh70, Lloh71
	.loh AdrpAdd	Lloh68, Lloh69
	.loh AdrpAdd	Lloh66, Lloh67
	.loh AdrpAdd	Lloh64, Lloh65
	.loh AdrpAdd	Lloh62, Lloh63
	.loh AdrpAdd	Lloh60, Lloh61
	.loh AdrpAdd	Lloh58, Lloh59
	.loh AdrpAdd	Lloh56, Lloh57
	.loh AdrpAdd	Lloh54, Lloh55
	.loh AdrpAdd	Lloh52, Lloh53
	.loh AdrpAdd	Lloh50, Lloh51
	.loh AdrpAdd	Lloh48, Lloh49
	.loh AdrpAdd	Lloh46, Lloh47
	.loh AdrpAdd	Lloh44, Lloh45
	.loh AdrpAdd	Lloh42, Lloh43
	.loh AdrpAdd	Lloh40, Lloh41
	.cfi_endproc
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

.subsections_via_symbols
#endif
