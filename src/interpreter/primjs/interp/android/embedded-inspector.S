	.file	"primjs"
	.text
	.globl	common_get_property_asm_h       // -- Begin function common_get_property_asm_h
	.p2align	2
	.type	common_get_property_asm_h,@function
common_get_property_asm_h:              // @common_get_property_asm_h
	.cfi_startproc
// %bb.0:                               // %B21
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	.LBB0_10
// %bb.1:                               // %B22
	mov	x8, x21
	mov	w0, #130                        // =0x82
.LBB0_2:                                // %B19
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB0_3 Depth 2
	ldr	x11, [x8, #24]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB0_5
.LBB0_3:                                // %B1
                                        //   Parent Loop BB0_2 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w9
	b.eq	.LBB0_8
// %bb.4:                               // %B9
                                        //   in Loop: Header=BB0_3 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB0_3
.LBB0_5:                                // %B14
                                        //   in Loop: Header=BB0_2 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB0_11
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB0_2 Depth=1
	ldr	x8, [x8, #24]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB0_2
// %bb.7:
	mov	w0, #18                         // =0x12
	ret
.LBB0_8:                                // %B3
	lsr	w11, w12, #26
	tst	w11, #0x30
	b.ne	.LBB0_10
// %bb.9:                               // %B4
	lsl	w10, w10, #1
	ldr	x8, [x8, #32]
	sub	w10, w10, #2
	ldr	x0, [x8, w10, sxtw #3]
	ret
.LBB0_10:
	mov	w0, #130                        // =0x82
.LBB0_11:                               // %common.ret
	ret
.Lfunc_end0:
	.size	common_get_property_asm_h, .Lfunc_end0-common_get_property_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	common_get_property_value_asm_h // -- Begin function common_get_property_value_asm_h
	.p2align	2
	.type	common_get_property_value_asm_h,@function
common_get_property_value_asm_h:        // @common_get_property_value_asm_h
	.cfi_startproc
// %bb.0:                               // %B30
	mov	x8, #2                          // =0x2
	mov	w0, #130                        // =0x82
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB1_14
// %bb.1:                               // %B30
	and	x8, x21, #0xffff000000000000
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x8, x10
	b.ne	.LBB1_14
// %bb.2:                               // %B1
	ldrh	w8, [x22, #6]
	cmp	w8, #2
	b.ne	.LBB1_15
// %bb.3:                               // %B3
	ldr	w8, [x22, #64]
	cmp	w21, w8
	b.hs	.LBB1_5
// %bb.4:                               // %B4
	ldr	x8, [x22, #56]
	ldr	x0, [x8, w21, sxtw #3]
	ret
.LBB1_5:                                // %B7
	tbnz	w21, #31, .LBB1_15
// %bb.6:                               // %B9.preheader
	mov	x8, x22
	mov	w0, #18                         // =0x12
	orr	w12, w21, #0x80000000
.LBB1_7:                                // %B9
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB1_8 Depth 2
	ldr	x10, [x8, #24]
	ldr	w11, [x10, #12]
	and	w11, w12, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, .LBB1_10
.LBB1_8:                                // %B10
                                        //   Parent Loop BB1_7 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w13, w11, #3
	sub	w13, w13, #8
	add	x13, x10, x13
	ldp	w13, w14, [x13, #40]
	cmp	w14, w12
	b.eq	.LBB1_12
// %bb.9:                               // %B17
                                        //   in Loop: Header=BB1_8 Depth=2
	and	w11, w13, #0x3ffffff
	cbnz	w11, .LBB1_8
.LBB1_10:                               // %B24
                                        //   in Loop: Header=BB1_7 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB1_15
// %bb.11:                              // %B21
                                        //   in Loop: Header=BB1_7 Depth=1
	ldr	x8, [x8, #24]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB1_7
	b	.LBB1_14
.LBB1_12:                               // %B12
	lsr	w10, w13, #26
	tst	w10, #0x30
	b.ne	.LBB1_15
// %bb.13:                              // %B13
	lsl	w10, w11, #1
	ldr	x8, [x8, #32]
	sub	w10, w10, #2
	ldr	x0, [x8, w10, sxtw #3]
.LBB1_14:                               // %common.ret
	ret
.LBB1_15:
	mov	w0, #130                        // =0x82
	ret
.Lfunc_end1:
	.size	common_get_property_value_asm_h, .Lfunc_end1-common_get_property_value_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	common_get_var_asm_h            // -- Begin function common_get_var_asm_h
	.p2align	2
	.type	common_get_var_asm_h,@function
common_get_var_asm_h:                   // @common_get_var_asm_h
	.cfi_startproc
// %bb.0:                               // %B0
	ldr	x8, [x24, #232]
	ldr	x11, [x8, #24]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB2_3
.LBB2_1:                                // %B2
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #44]
	cmp	w13, w9
	b.eq	.LBB2_10
// %bb.2:                               // %B4
                                        //   in Loop: Header=BB2_1 Depth=1
	ldur	w10, [x12, #40]
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB2_1
.LBB2_3:                                // %B7
	ldr	x8, [x24, #224]
	mov	w0, #130                        // =0x82
.LBB2_4:                                // %B25
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB2_5 Depth 2
	ldr	x11, [x8, #24]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB2_7
.LBB2_5:                                // %B14
                                        //   Parent Loop BB2_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w9
	b.eq	.LBB2_9
// %bb.6:                               // %B16
                                        //   in Loop: Header=BB2_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB2_5
.LBB2_7:                                // %B19
                                        //   in Loop: Header=BB2_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB2_11
// %bb.8:                               // %B22
                                        //   in Loop: Header=BB2_4 Depth=1
	ldr	x8, [x8, #24]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB2_4
	b	.LBB2_11
.LBB2_9:                                // %B8
	lsr	w11, w12, #26
	tst	w11, #0x30
	b.ne	.LBB2_12
.LBB2_10:                               // %common.ret.sink.split
	lsl	w10, w10, #1
	ldr	x8, [x8, #32]
	sub	w10, w10, #2
	ldr	x0, [x8, w10, sxtw #3]
.LBB2_11:                               // %common.ret
	ret
.LBB2_12:
	mov	w0, #130                        // =0x82
	ret
.Lfunc_end2:
	.size	common_get_var_asm_h, .Lfunc_end2-common_get_var_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	common_get_var_undef_asm_h      // -- Begin function common_get_var_undef_asm_h
	.p2align	2
	.type	common_get_var_undef_asm_h,@function
common_get_var_undef_asm_h:             // @common_get_var_undef_asm_h
	.cfi_startproc
// %bb.0:                               // %B0
	ldr	x8, [x24, #232]
	ldr	x11, [x8, #24]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB3_3
.LBB3_1:                                // %B2
                                        // =>This Inner Loop Header: Depth=1
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldr	w13, [x12, #44]
	cmp	w13, w9
	b.eq	.LBB3_10
// %bb.2:                               // %B4
                                        //   in Loop: Header=BB3_1 Depth=1
	ldur	w10, [x12, #40]
	and	w10, w10, #0x3ffffff
	cbnz	w10, .LBB3_1
.LBB3_3:                                // %B7
	ldr	x8, [x24, #224]
	mov	w0, #18                         // =0x12
.LBB3_4:                                // %B26
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB3_5 Depth 2
	ldr	x11, [x8, #24]
	ldr	w10, [x11, #12]
	and	w10, w9, w10
	mvn	w10, w10
	ldr	w10, [x11, w10, sxtw #2]
	cbz	w10, .LBB3_7
.LBB3_5:                                // %B15
                                        //   Parent Loop BB3_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w12, w10, #3
	sub	w12, w12, #8
	add	x12, x11, x12
	ldp	w12, w13, [x12, #40]
	cmp	w13, w9
	b.eq	.LBB3_9
// %bb.6:                               // %B17
                                        //   in Loop: Header=BB3_5 Depth=2
	and	w10, w12, #0x3ffffff
	cbnz	w10, .LBB3_5
.LBB3_7:                                // %B20
                                        //   in Loop: Header=BB3_4 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB3_12
// %bb.8:                               // %B23
                                        //   in Loop: Header=BB3_4 Depth=1
	ldr	x8, [x8, #24]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB3_4
	b	.LBB3_11
.LBB3_9:                                // %B8
	lsr	w11, w12, #26
	tst	w11, #0x30
	b.ne	.LBB3_12
.LBB3_10:                               // %common.ret.sink.split
	lsl	w10, w10, #1
	ldr	x8, [x8, #32]
	sub	w10, w10, #2
	ldr	x0, [x8, w10, sxtw #3]
.LBB3_11:                               // %common.ret
	ret
.LBB3_12:
	mov	w0, #130                        // =0x82
	ret
.Lfunc_end3:
	.size	common_get_var_undef_asm_h, .Lfunc_end3-common_get_var_undef_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	common_return_direct_asm_h      // -- Begin function common_return_direct_asm_h
	.p2align	2
	.type	common_return_direct_asm_h,@function
common_return_direct_asm_h:             // @common_return_direct_asm_h
	.cfi_startproc
// %bb.0:                               // %B0
	ldr	x8, [x29, #104]
	ldr	x10, [x29]
	ldr	x11, [x24, #40]
	str	x10, [x11, #240]
	mov	x30, x8
	mov	x29, x10
	mov	sp, x10
	ret
.Lfunc_end4:
	.size	common_return_direct_asm_h, .Lfunc_end4-common_return_direct_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	common_set_property_asm_h       // -- Begin function common_set_property_asm_h
	.p2align	2
	.type	common_set_property_asm_h,@function
common_set_property_asm_h:              // @common_set_property_asm_h
	.cfi_startproc
// %bb.0:                               // %B36
	mov	x8, #2                          // =0x2
	ldr	w2, [x19]
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB5_16
// %bb.1:                               // %B37
	ldr	x10, [x22, #24]
	ldr	w8, [x10, #12]
	and	w8, w2, w8
	mvn	w8, w8
	ldr	w8, [x10, w8, sxtw #2]
	cbz	w8, .LBB5_4
.LBB5_2:                                // %B5
                                        // =>This Inner Loop Header: Depth=1
	lsl	w11, w8, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldp	w11, w12, [x11, #40]
	cmp	w12, w2
	b.eq	.LBB5_13
// %bb.3:                               // %B11
                                        //   in Loop: Header=BB5_2 Depth=1
	and	w8, w11, #0x3ffffff
	cbnz	w8, .LBB5_2
.LBB5_4:                                // %B16.preheader
	mov	x8, x22
.LBB5_5:                                // %B16
                                        // =>This Loop Header: Depth=1
                                        //     Child Loop BB5_6 Depth 2
	ldr	x10, [x8, #24]
	ldr	w11, [x10, #12]
	and	w11, w2, w11
	mvn	w11, w11
	ldr	w11, [x10, w11, sxtw #2]
	cbz	w11, .LBB5_8
.LBB5_6:                                // %B17
                                        //   Parent Loop BB5_5 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	lsl	w11, w11, #3
	sub	w11, w11, #8
	add	x11, x10, x11
	ldr	w12, [x11, #44]
	cmp	w12, w2
	b.eq	.LBB5_16
// %bb.7:                               // %B19
                                        //   in Loop: Header=BB5_6 Depth=2
	ldur	w11, [x11, #40]
	and	w11, w11, #0x3ffffff
	cbnz	w11, .LBB5_6
.LBB5_8:                                // %B29
                                        //   in Loop: Header=BB5_5 Depth=1
	ldr	w10, [x8, #4]
	ubfx	w10, w10, #10, #1
	cmp	w10, #1
	b.eq	.LBB5_16
// %bb.9:                               // %B23
                                        //   in Loop: Header=BB5_5 Depth=1
	ldr	x8, [x8, #24]
	ldr	x8, [x8, #32]
	cbnz	x8, .LBB5_5
// %bb.10:                              // %B26
	ldr	w8, [x22, #4]
	ubfx	w8, w8, #8, #1
	cmp	w8, #1
	b.ne	.LBB5_16
// %bb.11:                              // %B33
	mov	x0, x24
	mov	x1, x22
	mov	w3, #7                          // =0x7
	str	x20, [x29, #64]
	bl	add_property_gc
	cbz	x0, .LBB5_17
// %bb.12:                              // %B35
	str	x21, [x0]
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB5_13:                               // %B7
	mov	w10, #58                        // =0x3a
	and	w10, w10, w11, lsr #26
	cmp	w10, #2
	b.ne	.LBB5_16
// %bb.14:                              // %B8
	lsl	w8, w8, #1
	ldr	x10, [x22, #32]
	sub	w8, w8, #2
	str	x21, [x10, w8, sxtw #3]
.LBB5_15:                               // %B4
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB5_16:                               // %B2
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	str	x20, [x29, #64]
	bl	JS_SetPropertyInternalImpl_GC
	tbz	w0, #31, .LBB5_15
	b	.LBB5_18
.LBB5_17:                               // %B34
	sub	x20, x20, #16
.LBB5_18:                               // %B3
	b	exception_asm_h
.Lfunc_end5:
	.size	common_set_property_asm_h, .Lfunc_end5-common_set_property_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	exception_asm_h                 // -- Begin function exception_asm_h
	.p2align	2
	.type	exception_asm_h,@function
exception_asm_h:                        // @exception_asm_h
	.cfi_startproc
// %bb.0:                               // %B17
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	ldr	x10, [x24, #40]
	ldr	w8, [x10, #232]
	stp	x10, x20, [sp, #8]              // 16-byte Folded Spill
	ldr	x20, [x10, #224]
	cbz	w8, .LBB6_2
// %bb.1:                               // %B18
	mov	x0, x24
	mov	x1, x20
	mov	x2, xzr
	mov	x3, xzr
	mov	x4, x19
	mov	w5, wzr
	mov	w6, wzr
	bl	build_backtrace
.LBB6_2:                                // %B2
	mov	x0, x24
	mov	x1, x20
	bl	JS_IsUncatchableError_GC
	cbz	w0, .LBB6_4
.LBB6_3:                                // %B4
	ldr	x20, [sp, #16]                  // 8-byte Folded Reload
	mov	w27, #130                       // =0x82
	add	sp, sp, #32
	b	common_return_asm_h
.LBB6_4:                                // %B6
	ldr	x8, [x29, #8]
	str	x19, [sp, #24]                  // 8-byte Folded Spill
	ldr	x8, [x8, #48]
	str	x8, [sp]                        // 8-byte Folded Spill
	ldrh	w8, [x8, #42]
	add	x20, x27, x8, lsl #3
	ldr	x8, [sp, #16]                   // 8-byte Folded Reload
.LBB6_5:                                // %B7
                                        // =>This Inner Loop Header: Depth=1
	cmp	x8, x20
	b.le	.LBB6_3
// %bb.6:                               // %B12
                                        //   in Loop: Header=BB6_5 Depth=1
	ldr	x10, [x8, #-8]!
	tst	x10, #0xffff000000000000
	b.ne	.LBB6_5
// %bb.7:                               // %B12
                                        //   in Loop: Header=BB6_5 Depth=1
	mov	w11, #247                       // =0xf7
	and	x11, x10, x11
	cmp	x11, #66
	b.ne	.LBB6_5
// %bb.8:                               // %B9
                                        //   in Loop: Header=BB6_5 Depth=1
	lsr	x10, x10, #16
	cbnz	w10, .LBB6_10
// %bb.9:                               // %B10
                                        //   in Loop: Header=BB6_5 Depth=1
	ldur	x1, [x8, #-16]
	mov	x0, x24
	mov	w2, #1                          // =0x1
	sub	x19, x8, #8
	bl	JS_IteratorClose
	mov	x8, x19
	ldr	x19, [sp, #24]                  // 8-byte Folded Reload
	b	.LBB6_5
.LBB6_10:                               // %B11
	ldr	x13, [sp, #8]                   // 8-byte Folded Reload
	mov	w12, #2                         // =0x2
	ldr	x11, [x13, #224]
	str	x11, [x8], #8
	ldr	x11, [sp]                       // 8-byte Folded Reload
	str	x12, [x13, #224]
	mov	x20, x8
	ldr	x11, [x11, #8]
	add	x19, x11, w10, sxtw
	ldrb	w10, [x19], #1
	ldr	x0, [x25, x10, lsl #3]
	add	sp, sp, #32
	br	x0
.Lfunc_end6:
	.size	exception_asm_h, .Lfunc_end6-exception_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	common_set_property_value_asm_h // -- Begin function common_set_property_value_asm_h
	.p2align	2
	.type	common_set_property_value_asm_h,@function
common_set_property_value_asm_h:        // @common_set_property_value_asm_h
	.cfi_startproc
// %bb.0:                               // %B55
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x9, x8
	b.ne	.LBB7_16
// %bb.1:                               // %B49
	ldrsh	w8, [x9, #6]
	cmp	w8, #2
	b.ne	.LBB7_6
// %bb.2:                               // %B8
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB7_16
// %bb.3:                               // %B45
	ldr	w8, [x9, #64]
	cmp	w22, w8
	b.hs	.LBB7_7
// %bb.4:                               // %B46
	ldr	x8, [x9, #56]
	str	x21, [x8, w22, sxtw #3]
.LBB7_5:                                // %B7
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB7_6:                                // %B52
	cmp	w8, #32
	ccmp	w8, #20, #4, lt
	mov	w8, #32768                      // =0x8000
	csel	w4, wzr, w8, gt
	b	.LBB7_17
.LBB7_7:                                // %B10
	b.ne	.LBB7_16
// %bb.8:                               // %B41
	ldr	w10, [x9, #4]
	mov	w4, #32768                      // =0x8000
	ubfx	w11, w10, #11, #1
	cmp	w11, #1
	b.ne	.LBB7_17
// %bb.9:                               // %B41
	ubfx	w10, w10, #8, #1
	cbz	w10, .LBB7_17
// %bb.10:                              // %B42
	ldr	x10, [x9, #24]
.LBB7_11:                               // %B17
                                        // =>This Inner Loop Header: Depth=1
	ldr	x11, [x10, #32]
	cbz	x11, .LBB7_18
// %bb.12:                              // %B12
                                        //   in Loop: Header=BB7_11 Depth=1
	ldrh	w12, [x11, #6]
	ldr	x10, [x11, #24]
	cmp	w12, #2
	b.ne	.LBB7_14
// %bb.13:                              // %B14
                                        //   in Loop: Header=BB7_11 Depth=1
	ldr	w11, [x11, #4]
	ubfx	w11, w11, #11, #1
	cmp	w11, #1
	b.eq	.LBB7_11
	b	.LBB7_16
.LBB7_14:                               // %B12
                                        //   in Loop: Header=BB7_11 Depth=1
	cmp	w12, #1
	b.ne	.LBB7_16
// %bb.15:                              // %B37
                                        //   in Loop: Header=BB7_11 Depth=1
	ldrb	w11, [x10, #6]
	cbz	w11, .LBB7_11
.LBB7_16:
	mov	w4, #32768                      // =0x8000
.LBB7_17:                               // %B5
	mov	x0, x24
	mov	x1, x9
	mov	x2, x22
	mov	x3, x21
	str	x20, [x29, #64]
	bl	JS_SetPropertyValue_GC
	tbz	w0, #31, .LBB7_5
	b	.LBB7_23
.LBB7_18:                               // %B28
	ldr	x10, [x9, #32]
	ldr	x11, [x10]
	mov	w10, #65534                     // =0xfffe
	cmp	x10, x11, lsr #48
	add	w10, w8, #1
	b.ne	.LBB7_20
// %bb.19:                              // %B28
	cmp	w10, w11
	b.hi	.LBB7_22
.LBB7_20:                               // %B25
	ldr	w11, [x9, #48]
	cmp	w10, w11
	b.hi	.LBB7_22
// %bb.21:                              // %B27
	ldr	x11, [x9, #56]
	str	x21, [x11, w8, sxtw #3]
	str	w10, [x9, #64]
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB7_22:                               // %B2
	mov	x0, x24
	mov	x1, x9
	mov	x2, x21
	str	x20, [x29, #64]
	bl	LEPUS_add_fast_array_element
	tbz	w0, #31, .LBB7_5
.LBB7_23:                               // %B6
	b	exception_asm_h
.Lfunc_end7:
	.size	common_set_property_value_asm_h, .Lfunc_end7-common_set_property_value_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	common_call_asm_h               // -- Begin function common_call_asm_h
	.p2align	2
	.type	common_call_asm_h,@function
common_call_asm_h:                      // @common_call_asm_h
	.cfi_startproc
// %bb.0:                               // %B38
	mov	x10, #2                         // =0x2
	mov	x8, x20
	movk	x10, #65535, lsl #48
	tst	x22, x10
	b.ne	.LBB8_9
// %bb.1:                               // %B35
	ldrh	w10, [x22, #6]
	cmp	w10, #13
	b.ne	.LBB8_10
// %bb.2:                               // %B1
	ldr	x13, [x22, #48]
	ldr	x14, [x24, #16]
	mov	x11, sp
	ldrh	w12, [x13, #40]
	ldrh	w10, [x13, #42]
	ldrh	w15, [x13, #46]
	cmp	w9, w12
	add	w15, w10, w15
	b.lt	.LBB8_11
// %bb.3:                               // %B32
	lsl	w12, w15, #3
	add	w12, w12, #160
	and	w15, w12, #0x8
	add	w12, w12, w15
	sub	x11, x11, x12
	cmp	x11, x14
	b.ls	.LBB8_18
// %bb.4:                               // %B34
	mov	sp, x11
	mov	x12, x30
	stp	x29, x22, [x11]
	add	w15, w9, w10
	str	x12, [x11, #104]
	add	x12, x11, #32
	mov	x28, x8
	str	x21, [x11, #80]
	mov	x29, x11
	stp	x21, x27, [x11, #120]
	ldr	x14, [x22, #56]
	stp	x12, x12, [x11, #32]
	str	x14, [x11, #136]
	mov	x26, x14
	ldrb	w12, [x13, #5]
	str	w12, [x11, #60]
	add	x12, x11, #160
	ldr	x19, [x13, #8]
	str	w9, [x11, #152]
	add	x20, x12, x10, lsl #3
	ldr	x13, [x13, #48]
	str	w9, [x11, #56]
	mov	w10, #18                        // =0x12
	stp	x8, x12, [x11, #16]
	mov	x27, x12
	str	x13, [x11, #144]
	mov	x23, x13
	str	xzr, [x11, #88]
	str	w15, [x11, #96]
	ldr	x15, [x24, #40]
	str	x11, [x15, #240]
	cmp	x12, x20
	b.ge	.LBB8_6
.LBB8_5:                                // %B26
                                        // =>This Inner Loop Header: Depth=1
	str	x10, [x12], #8
	cmp	x12, x20
	b.lt	.LBB8_5
.LBB8_6:                                // %B27
	ldr	w8, [x24, #336]
	cbz	w8, .LBB8_8
// %bb.7:                               // %B28
	add	x1, x19, #1
	mov	x0, x24
	str	x20, [x11, #64]
	bl	DebuggerCallEachFunc
.LBB8_8:                                // %B24
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB8_9:                                // %B40
	mov	x20, x8
	b	ThrowTypeErrorNotFunction_Return_asm_h
.LBB8_10:                               // %B36
	mov	x20, x8
	b	call_native_asm_h
.LBB8_11:                               // %B20
	add	w15, w15, w12
	lsl	w15, w15, #3
	add	w15, w15, #160
	and	w16, w15, #0x8
	add	w15, w15, w16
	sub	x11, x11, x15
	cmp	x11, x14
	b.ls	.LBB8_18
// %bb.12:                              // %B22
	mov	sp, x11
	mov	x14, x30
	stp	x29, x22, [x11]
	mov	x29, x11
	str	x14, [x11, #104]
	add	x14, x11, #32
	str	x21, [x11, #80]
	stp	x21, x27, [x11, #120]
	ldr	x15, [x22, #56]
	stp	x14, x14, [x11, #32]
	str	x15, [x11, #136]
	mov	x26, x15
	ldrb	w14, [x13, #5]
	str	w14, [x11, #60]
	ldr	x19, [x13, #8]
	str	w9, [x11, #152]
	ldr	x16, [x13, #48]
	add	x13, x11, #160
	mov	x14, x13
	str	x16, [x11, #144]
	mov	x23, x16
	cmp	w9, w12
	csel	w15, w9, w12, lt
	add	x15, x13, w15, uxtw #3
	cmp	x13, x15
	b.ge	.LBB8_14
.LBB8_13:                               // %B6
                                        // =>This Inner Loop Header: Depth=1
	ldr	x15, [x8], #8
	str	x15, [x14], #8
	cmp	w9, w12
	csel	w15, w9, w12, lt
	add	x15, x13, w15, uxtw #3
	cmp	x14, x15
	b.lt	.LBB8_13
.LBB8_14:                               // %B10.preheader
	add	x8, x13, x12, lsl #3
	mov	w14, #18                        // =0x12
	cmp	x15, x8
	b.ge	.LBB8_16
.LBB8_15:                               // %B11
                                        // =>This Inner Loop Header: Depth=1
	str	x14, [x15], #8
	cmp	x15, x8
	b.lt	.LBB8_15
.LBB8_16:                               // %B12
	str	w12, [x11, #56]
	add	w12, w12, w10
	add	x20, x8, x10, lsl #3
	stp	x13, x8, [x11, #16]
	mov	w10, #18                        // =0x12
	mov	x28, x13
	str	xzr, [x11, #88]
	mov	x27, x8
	str	w12, [x11, #96]
	ldr	x12, [x24, #40]
	str	x11, [x12, #240]
	cmp	x8, x20
	b.ge	.LBB8_6
.LBB8_17:                               // %B18
                                        // =>This Inner Loop Header: Depth=1
	str	x10, [x8], #8
	cmp	x8, x20
	b.lt	.LBB8_17
	b	.LBB8_6
.LBB8_18:                               // %B21
	mov	x20, x8
	b	ThrowStackOverflow_Return_asm_h
.Lfunc_end8:
	.size	common_call_asm_h, .Lfunc_end8-common_call_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	ThrowTypeErrorNotFunction_Return_asm_h // -- Begin function ThrowTypeErrorNotFunction_Return_asm_h
	.p2align	2
	.type	ThrowTypeErrorNotFunction_Return_asm_h,@function
ThrowTypeErrorNotFunction_Return_asm_h: // @ThrowTypeErrorNotFunction_Return_asm_h
	.cfi_startproc
// %bb.0:                               // %B0
	mov	x0, x24
	mov	x22, x30
	bl	JS_ThrowTypeErrorNotFunction
	mov	x30, x22
	mov	x27, x0
	ret
.Lfunc_end9:
	.size	ThrowTypeErrorNotFunction_Return_asm_h, .Lfunc_end9-ThrowTypeErrorNotFunction_Return_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	ThrowStackOverflow_Return_asm_h // -- Begin function ThrowStackOverflow_Return_asm_h
	.p2align	2
	.type	ThrowStackOverflow_Return_asm_h,@function
ThrowStackOverflow_Return_asm_h:        // @ThrowStackOverflow_Return_asm_h
	.cfi_startproc
// %bb.0:                               // %B0
	mov	x0, x24
	mov	x22, x30
	bl	JS_ThrowStackOverflow
	mov	x30, x22
	mov	x27, x0
	ret
.Lfunc_end10:
	.size	ThrowStackOverflow_Return_asm_h, .Lfunc_end10-ThrowStackOverflow_Return_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call_native_asm_h               // -- Begin function call_native_asm_h
	.p2align	2
	.type	call_native_asm_h,@function
call_native_asm_h:                      // @call_native_asm_h
	.cfi_startproc
// %bb.0:                               // %B2
	ldrh	w8, [x22, #6]
	ldr	x10, [x24, #40]
	mov	x4, x20
	add	w8, w8, w8, lsl #2
	ldr	x10, [x10, #80]
	add	w8, w8, #3
	ldr	x8, [x10, w8, uxtw #3]
	cbz	x8, .LBB11_2
// %bb.1:                               // %B4
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, w9
	mov	w5, wzr
	mov	x27, x30
	blr	x8
	mov	x30, x27
	mov	x27, x0
	ret
.LBB11_2:                               // %B3
	mov	x20, x4
	b	ThrowTypeErrorNotFunction_Return_asm_h
.Lfunc_end11:
	.size	call_native_asm_h, .Lfunc_end11-call_native_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call_native_entry_asm_h         // -- Begin function call_native_entry_asm_h
	.p2align	2
	.type	call_native_entry_asm_h,@function
call_native_entry_asm_h:                // @call_native_entry_asm_h
	.cfi_startproc
// %bb.0:                               // %B2
	ldrh	w8, [x22, #6]
	ldr	x10, [x24, #40]
	mov	x4, x20
	mov	x5, x19
	add	w8, w8, w8, lsl #2
	ldr	x10, [x10, #80]
	add	w8, w8, #3
	ldr	x8, [x10, w8, uxtw #3]
	cbz	x8, .LBB12_2
// %bb.1:                               // %B4
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, w9
	mov	x27, x30
                                        // kill: def $w5 killed $w5 killed $x5
	blr	x8
	mov	x30, x27
	mov	x27, x0
	ret
.LBB12_2:                               // %B3
	mov	x19, x5
	mov	x20, x4
	b	ThrowTypeErrorNotFunction_Return_asm_h
.Lfunc_end12:
	.size	call_native_entry_asm_h, .Lfunc_end12-call_native_entry_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	common_call_from_entry_asm_h    // -- Begin function common_call_from_entry_asm_h
	.p2align	2
	.type	common_call_from_entry_asm_h,@function
common_call_from_entry_asm_h:           // @common_call_from_entry_asm_h
	.cfi_startproc
// %bb.0:                               // %B55
	tbz	w19, #2, .LBB13_6
// %bb.1:                               // %B42
	mov	x11, sp
	ldr	x10, [x24, #16]
	sub	x8, x11, #160
	cmp	x8, x10
	b.ls	.LBB13_26
// %bb.2:                               // %B44
	and	x10, x22, #0xfffffffffffc
	add	x12, x10, #16
	mov	sp, x8
	mov	x13, x12
	mov	x14, x8
	cmp	x8, x11
	b.ge	.LBB13_4
.LBB13_3:                               // %B47
                                        // =>This Inner Loop Header: Depth=1
	ldr	x15, [x13], #8
	str	x15, [x14], #8
	cmp	x14, x11
	b.lt	.LBB13_3
.LBB13_4:                               // %B39
	mov	x11, x30
	add	x13, x8, #32
	mov	x29, x8
	stp	x11, x12, [x8, #104]
	ldr	x11, [x24, #40]
	ldr	x12, [x11, #240]
	str	x12, [x8]
	str	x8, [x11, #240]
	ldp	x11, x28, [x8, #8]
	str	x21, [x8, #80]
	stp	x21, x27, [x8, #120]
	ldr	x19, [x8, #48]
	ldr	x20, [x8, #64]
	ldr	x27, [x8, #24]
	ldr	x12, [x11, #56]
	str	x12, [x8, #136]
	mov	x26, x12
	ldr	x11, [x11, #48]
	ldr	x11, [x11, #48]
	str	w9, [x8, #152]
	stp	x13, x13, [x8, #32]
	str	x11, [x8, #144]
	mov	x23, x11
	ldr	w10, [x10, #12]
	cbz	w10, .LBB13_25
// %bb.5:                               // %B40
	b	exception_asm_h
.LBB13_6:                               // %B49
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB13_16
// %bb.7:                               // %B51
	ldrh	w8, [x22, #6]
	cmp	w8, #13
	b.ne	.LBB13_17
// %bb.8:                               // %B1
	ldr	x12, [x22, #48]
	ldr	x13, [x24, #16]
	mov	x10, sp
	ldrh	w11, [x12, #40]
	ldrh	w8, [x12, #42]
	ldrh	w14, [x12, #46]
	cmp	w9, w11
	add	w14, w8, w14
	b.ge	.LBB13_18
// %bb.9:                               // %B20
	add	w14, w14, w11
	lsl	w14, w14, #3
	add	w14, w14, #160
	and	w15, w14, #0x8
	add	w14, w14, w15
	sub	x10, x10, x14
	cmp	x10, x13
	b.ls	.LBB13_26
// %bb.10:                              // %B22
	mov	sp, x10
	mov	x13, x30
	stp	x29, x22, [x10]
	mov	x29, x10
	str	x13, [x10, #104]
	add	x13, x10, #32
	str	x21, [x10, #80]
	stp	x21, x27, [x10, #120]
	ldr	x14, [x22, #56]
	stp	x13, x13, [x10, #32]
	str	x14, [x10, #136]
	mov	x26, x14
	ldrb	w13, [x12, #5]
	str	w13, [x10, #60]
	ldr	x19, [x12, #8]
	str	w9, [x10, #152]
	ldr	x15, [x12, #48]
	add	x12, x10, #160
	mov	x13, x12
	str	x15, [x10, #144]
	mov	x23, x15
	cmp	w9, w11
	csel	w14, w9, w11, lt
	add	x14, x12, w14, uxtw #3
	cmp	x12, x14
	b.ge	.LBB13_12
.LBB13_11:                              // %B6
                                        // =>This Inner Loop Header: Depth=1
	ldr	x14, [x20], #8
	str	x14, [x13], #8
	cmp	w9, w11
	csel	w14, w9, w11, lt
	add	x14, x12, w14, uxtw #3
	cmp	x13, x14
	b.lt	.LBB13_11
.LBB13_12:                              // %B10.preheader
	add	x13, x12, x11, lsl #3
	mov	w15, #18                        // =0x12
	cmp	x14, x13
	b.ge	.LBB13_14
.LBB13_13:                              // %B11
                                        // =>This Inner Loop Header: Depth=1
	str	x15, [x14], #8
	cmp	x14, x13
	b.lt	.LBB13_13
.LBB13_14:                              // %B12
	str	w11, [x10, #56]
	add	w11, w11, w8
	add	x20, x13, x8, lsl #3
	stp	x12, x13, [x10, #16]
	mov	w8, #18                         // =0x12
	mov	x28, x12
	str	xzr, [x10, #88]
	mov	x27, x13
	str	w11, [x10, #96]
	ldr	x11, [x24, #40]
	str	x10, [x11, #240]
	cmp	x13, x20
	b.ge	.LBB13_23
.LBB13_15:                              // %B18
                                        // =>This Inner Loop Header: Depth=1
	str	x8, [x13], #8
	cmp	x13, x20
	b.lt	.LBB13_15
	b	.LBB13_23
.LBB13_16:                              // %B54
	b	ThrowTypeErrorNotFunction_Return_asm_h
.LBB13_17:                              // %B52
	b	call_native_entry_asm_h
.LBB13_18:                              // %B36
	add	w11, w14, w9
	lsl	w11, w11, #3
	add	w11, w11, #160
	and	w14, w11, #0x8
	add	w11, w11, w14
	sub	x10, x10, x11
	cmp	x10, x13
	b.ls	.LBB13_26
// %bb.19:                              // %B38
	mov	sp, x10
	mov	x11, x30
	stp	x29, x22, [x10]
	mov	x29, x10
	str	x11, [x10, #104]
	add	x11, x10, #32
	str	x21, [x10, #80]
	stp	x21, x27, [x10, #120]
	ldr	x14, [x22, #56]
	stp	x11, x11, [x10, #32]
	str	x14, [x10, #136]
	mov	x26, x14
	ldrb	w11, [x12, #5]
	str	w11, [x10, #60]
	ldr	x19, [x12, #8]
	str	w9, [x10, #152]
	ldr	x15, [x12, #48]
	add	x12, x10, #160
	add	x11, x12, w9, uxtw #3
	mov	x13, x12
	str	x15, [x10, #144]
	mov	x23, x15
	cmp	x12, x11
	b.ge	.LBB13_21
.LBB13_20:                              // %B33
                                        // =>This Inner Loop Header: Depth=1
	ldr	x14, [x20], #8
	str	x14, [x13], #8
	cmp	x13, x11
	b.lt	.LBB13_20
.LBB13_21:                              // %B35
	add	w13, w9, w8
	str	w9, [x10, #56]
	add	x20, x11, x8, lsl #3
	stp	x12, x11, [x10, #16]
	mov	w8, #18                         // =0x12
	mov	x28, x12
	str	xzr, [x10, #88]
	mov	x27, x11
	str	w13, [x10, #96]
	ldr	x13, [x24, #40]
	str	x10, [x13, #240]
	cmp	x11, x20
	b.ge	.LBB13_23
.LBB13_22:                              // %B25
                                        // =>This Inner Loop Header: Depth=1
	str	x8, [x11], #8
	cmp	x11, x20
	b.lt	.LBB13_22
.LBB13_23:                              // %B26
	ldr	w8, [x24, #336]
	cbz	w8, .LBB13_25
// %bb.24:                              // %B27
	add	x1, x19, #1
	mov	x0, x24
	str	x20, [x10, #64]
	bl	DebuggerCallEachFunc
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB13_25:                              // %B28
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB13_26:                              // %B21
	b	ThrowStackOverflow_Return_asm_h
.Lfunc_end13:
	.size	common_call_from_entry_asm_h, .Lfunc_end13-common_call_from_entry_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	SlowCloseVarRefs_asm_h          // -- Begin function SlowCloseVarRefs_asm_h
	.p2align	2
	.type	SlowCloseVarRefs_asm_h,@function
SlowCloseVarRefs_asm_h:                 // @SlowCloseVarRefs_asm_h
	.cfi_startproc
// %bb.0:                               // %B0
	mov	x0, x24
	mov	x1, x29
	bl	prim_close_var_refs_gc
	b	common_return_direct_asm_h
.Lfunc_end14:
	.size	SlowCloseVarRefs_asm_h, .Lfunc_end14-SlowCloseVarRefs_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	common_return_asm_h             // -- Begin function common_return_asm_h
	.p2align	2
	.type	common_return_asm_h,@function
common_return_asm_h:                    // @common_return_asm_h
	.cfi_startproc
// %bb.0:                               // %B2
	ldr	x8, [x29, #40]
	add	x10, x29, #32
	cmp	x8, x10
	b.eq	.LBB15_2
// %bb.1:                               // %B4
	b	SlowCloseVarRefs_asm_h
.LBB15_2:                               // %B3
	b	common_return_direct_asm_h
.Lfunc_end15:
	.size	common_return_asm_h, .Lfunc_end15-common_return_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	exception_spill_top0_asm_h      // -- Begin function exception_spill_top0_asm_h
	.p2align	2
	.type	exception_spill_top0_asm_h,@function
exception_spill_top0_asm_h:             // @exception_spill_top0_asm_h
	.cfi_startproc
// %bb.0:                               // %B0
	str	x22, [x20], #8
	b	exception_asm_h
.Lfunc_end16:
	.size	exception_spill_top0_asm_h, .Lfunc_end16-exception_spill_top0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	exception_spill_top1_asm_h      // -- Begin function exception_spill_top1_asm_h
	.p2align	2
	.type	exception_spill_top1_asm_h,@function
exception_spill_top1_asm_h:             // @exception_spill_top1_asm_h
	.cfi_startproc
// %bb.0:                               // %B0
	str	x21, [x20], #8
	b	exception_asm_h
.Lfunc_end17:
	.size	exception_spill_top1_asm_h, .Lfunc_end17-exception_spill_top1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	exception_spill_top0_top1_asm_h // -- Begin function exception_spill_top0_top1_asm_h
	.p2align	2
	.type	exception_spill_top0_top1_asm_h,@function
exception_spill_top0_top1_asm_h:        // @exception_spill_top0_top1_asm_h
	.cfi_startproc
// %bb.0:                               // %B0
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	b	exception_asm_h
.Lfunc_end18:
	.size	exception_spill_top0_top1_asm_h, .Lfunc_end18-exception_spill_top0_top1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	SlowToObject_asm_h              // -- Begin function SlowToObject_asm_h
	.p2align	2
	.type	SlowToObject_asm_h,@function
SlowToObject_asm_h:                     // @SlowToObject_asm_h
	.cfi_startproc
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x9
	str	x20, [x29, #64]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB19_2
// %bb.1:                               // %B3
	stur	x0, [x20, #-8]
	ldurb	w8, [x19, #-1]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB19_2:                               // %B2
	b	exception_asm_h
.Lfunc_end19:
	.size	SlowToObject_asm_h, .Lfunc_end19-SlowToObject_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	SlowToBoolean_asm_h             // -- Begin function SlowToBoolean_asm_h
	.p2align	2
	.type	SlowToBoolean_asm_h,@function
SlowToBoolean_asm_h:                    // @SlowToBoolean_asm_h
	.cfi_startproc
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x9
	str	x20, [x29, #64]
	bl	JS_ToBoolFree_GC
	tbnz	w0, #31, .LBB20_2
// %bb.1:                               // %B3
	cmp	w0, #0
	mov	w8, #6                          // =0x6
	cinc	x8, x8, ne
	stur	x8, [x20, #-8]
	ldurb	w8, [x19, #-1]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB20_2:                               // %B2
	b	exception_asm_h
.Lfunc_end20:
	.size	SlowToBoolean_asm_h, .Lfunc_end20-SlowToBoolean_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	SlowJSPostInc_asm_h             // -- Begin function SlowJSPostInc_asm_h
	.p2align	2
	.type	SlowJSPostInc_asm_h,@function
SlowJSPostInc_asm_h:                    // @SlowJSPostInc_asm_h
	.cfi_startproc
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	mov	w2, w9
	str	x20, [x29, #64]
	bl	js_post_inc_slow_gc
	tbnz	w0, #31, .LBB21_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB21_2:                               // %B2
	b	exception_asm_h
.Lfunc_end21:
	.size	SlowJSPostInc_asm_h, .Lfunc_end21-SlowJSPostInc_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	SlowJSNot_asm_h                 // -- Begin function SlowJSNot_asm_h
	.p2align	2
	.type	SlowJSNot_asm_h,@function
SlowJSNot_asm_h:                        // @SlowJSNot_asm_h
	.cfi_startproc
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x9
	str	x20, [x29, #64]
	bl	prim_js_not_slow_gc
	cmp	x0, #130
	b.eq	.LBB22_2
// %bb.1:                               // %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB22_2:                               // %B2
	b	exception_asm_h
.Lfunc_end22:
	.size	SlowJSNot_asm_h, .Lfunc_end22-SlowJSNot_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	ThrowReferenceErrorUninitialized_asm_h // -- Begin function ThrowReferenceErrorUninitialized_asm_h
	.p2align	2
	.type	ThrowReferenceErrorUninitialized_asm_h,@function
ThrowReferenceErrorUninitialized_asm_h: // @ThrowReferenceErrorUninitialized_asm_h
	.cfi_startproc
// %bb.0:                               // %B0
	mov	x0, x24
	mov	w1, wzr
	str	x20, [x29, #64]
	bl	JS_ThrowReferenceErrorUninitialized_GC
	b	exception_asm_h
.Lfunc_end23:
	.size	ThrowReferenceErrorUninitialized_asm_h, .Lfunc_end23-ThrowReferenceErrorUninitialized_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	ThrowThisReferenceError_asm_h   // -- Begin function ThrowThisReferenceError_asm_h
	.p2align	2
	.type	ThrowThisReferenceError_asm_h,@function
ThrowThisReferenceError_asm_h:          // @ThrowThisReferenceError_asm_h
	.cfi_startproc
// %bb.0:                               // %B0
	adrp	x1, .L__unnamed_1
	add	x1, x1, :lo12:.L__unnamed_1
	mov	x0, x24
	str	x20, [x29, #64]
	bl	LEPUS_ThrowReferenceError
	b	exception_asm_h
.Lfunc_end24:
	.size	ThrowThisReferenceError_asm_h, .Lfunc_end24-ThrowThisReferenceError_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	invalid_0_asm_h                 // -- Begin function invalid_0_asm_h
	.p2align	2
	.type	invalid_0_asm_h,@function
invalid_0_asm_h:                        // @invalid_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B0
	ldr	x8, [x29, #8]
	adrp	x1, .L__unnamed_2
	add	x1, x1, :lo12:.L__unnamed_2
	mov	x0, x24
	mov	w3, wzr
	ldr	x8, [x8, #48]
	ldr	w8, [x8, #8]
	str	x20, [x29, #64]
	mvn	w8, w8
	add	w2, w8, w19
	bl	LEPUS_ThrowInternalError
	b	exception_asm_h
.Lfunc_end25:
	.size	invalid_0_asm_h, .Lfunc_end25-invalid_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_i32_0_asm_h                // -- Begin function push_i32_0_asm_h
	.p2align	2
	.type	push_i32_0_asm_h,@function
push_i32_0_asm_h:                       // @push_i32_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB26_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB26_2:                               // %B1
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	ldr	w10, [x19], #5
	ldr	x0, [x25, x8, lsl #3]
	orr	x22, x10, #0xfffe000000000000
	br	x0
.Lfunc_end26:
	.size	push_i32_0_asm_h, .Lfunc_end26-push_i32_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_const_0_asm_h              // -- Begin function push_const_0_asm_h
	.p2align	2
	.type	push_const_0_asm_h,@function
push_const_0_asm_h:                     // @push_const_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB27_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB27_2:                               // %B4
	ldrsw	x8, [x19]
	ldr	w10, [x24, #336]
	ldr	x11, [x23, x8, lsl #3]
	cbz	w10, .LBB27_4
// %bb.3:                               // %B5
	mov	x0, x24
	mov	x1, x11
	mov	x2, x19
	str	x20, [x29, #64]
	str	x20, [sp, #8]                   // 8-byte Folded Spill
	mov	x20, x11
	bl	DebuggerPause
	mov	x11, x20
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
.LBB27_4:                               // %B2
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x22, x11
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.Lfunc_end27:
	.size	push_const_0_asm_h, .Lfunc_end27-push_const_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	fclosure_0_asm_h                // -- Begin function fclosure_0_asm_h
	.p2align	2
	.type	fclosure_0_asm_h,@function
fclosure_0_asm_h:                       // @fclosure_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB28_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB28_2:                               // %B2
	ldrsw	x8, [x19]
	mov	x0, x24
	mov	x2, x26
	mov	x3, x29
	ldr	x1, [x23, x8, lsl #3]
	str	x20, [x29, #64]
	bl	js_closure_gc
	cmp	x0, #130
	b.eq	.LBB28_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB28_4:                               // %B3
	b	exception_asm_h
.Lfunc_end28:
	.size	fclosure_0_asm_h, .Lfunc_end28-fclosure_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_atom_value_0_asm_h         // -- Begin function push_atom_value_0_asm_h
	.p2align	2
	.type	push_atom_value_0_asm_h,@function
push_atom_value_0_asm_h:                // @push_atom_value_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB29_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB29_2:                               // %B2
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB29_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB29_4:                               // %B3
	b	exception_asm_h
.Lfunc_end29:
	.size	push_atom_value_0_asm_h, .Lfunc_end29-push_atom_value_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	private_symbol_0_asm_h          // -- Begin function private_symbol_0_asm_h
	.p2align	2
	.type	private_symbol_0_asm_h,@function
private_symbol_0_asm_h:                 // @private_symbol_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB30_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB30_2:                               // %B2
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, #4                          // =0x4
	str	x20, [x29, #64]
	bl	JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	.LBB30_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB30_4:                               // %B3
	b	exception_asm_h
.Lfunc_end30:
	.size	private_symbol_0_asm_h, .Lfunc_end30-private_symbol_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	undefined_0_asm_h               // -- Begin function undefined_0_asm_h
	.p2align	2
	.type	undefined_0_asm_h,@function
undefined_0_asm_h:                      // @undefined_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB31_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB31_2:                               // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	w22, #18                        // =0x12
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end31:
	.size	undefined_0_asm_h, .Lfunc_end31-undefined_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	null_0_asm_h                    // -- Begin function null_0_asm_h
	.p2align	2
	.type	null_0_asm_h,@function
null_0_asm_h:                           // @null_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB32_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB32_2:                               // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	w22, #2                         // =0x2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end32:
	.size	null_0_asm_h, .Lfunc_end32-null_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_this_0_asm_h               // -- Begin function push_this_0_asm_h
	.p2align	2
	.type	push_this_0_asm_h,@function
push_this_0_asm_h:                      // @push_this_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB33_2
// %bb.1:                               // %B17
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB33_2:                               // %B13
	ldr	w8, [x29, #60]
	ldr	x1, [x29, #120]
	tbnz	w8, #0, .LBB33_4
// %bb.3:                               // %B13
	ldr	x8, [x29, #120]
	and	x10, x8, #0xfffffffffffffffe
	and	x10, x10, #0xffff000000000003
	cbnz	x10, .LBB33_5
.LBB33_4:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, x1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB33_5:                               // %B7
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	.LBB33_7
// %bb.6:                               // %B8
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x22, [x24, #224]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB33_7:                               // %B10
	mov	x0, x24
	str	x20, [x29, #64]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB33_9
// %bb.8:                               // %B12
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB33_9:                               // %B11
	b	exception_asm_h
.Lfunc_end33:
	.size	push_this_0_asm_h, .Lfunc_end33-push_this_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_false_0_asm_h              // -- Begin function push_false_0_asm_h
	.p2align	2
	.type	push_false_0_asm_h,@function
push_false_0_asm_h:                     // @push_false_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB34_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB34_2:                               // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end34:
	.size	push_false_0_asm_h, .Lfunc_end34-push_false_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_true_0_asm_h               // -- Begin function push_true_0_asm_h
	.p2align	2
	.type	push_true_0_asm_h,@function
push_true_0_asm_h:                      // @push_true_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB35_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB35_2:                               // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end35:
	.size	push_true_0_asm_h, .Lfunc_end35-push_true_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	object_0_asm_h                  // -- Begin function object_0_asm_h
	.p2align	2
	.type	object_0_asm_h,@function
object_0_asm_h:                         // @object_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB36_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB36_2:                               // %B2
	mov	x0, x24
	str	x20, [x29, #64]
	bl	PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	.LBB36_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB36_4:                               // %B3
	b	exception_asm_h
.Lfunc_end36:
	.size	object_0_asm_h, .Lfunc_end36-object_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	special_object_0_asm_h          // -- Begin function special_object_0_asm_h
	.p2align	2
	.type	special_object_0_asm_h,@function
special_object_0_asm_h:                 // @special_object_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B24
	ldr	w8, [x24, #336]
	cbz	w8, .LBB37_2
// %bb.1:                               // %B25
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB37_2:                               // %B16
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	.LBB37_6
// %bb.3:                               // %B16
	cbz	w8, .LBB37_10
// %bb.4:                               // %B16
	cmp	w8, #1
	b.ne	.LBB37_15
// %bb.5:                               // %B7
	ldr	x8, [x29, #8]
	ldr	w1, [x29, #152]
	mov	x0, x24
	mov	x2, x28
	mov	x3, x29
	ldr	x8, [x8, #48]
	ldrh	w8, [x8, #40]
	str	x20, [x29, #64]
	cmp	w8, w1
	csel	w4, w8, w1, lt
	bl	js_build_mapped_arguments_gc
	b	.LBB37_11
.LBB37_6:                               // %B16
	cmp	w8, #5
	b.eq	.LBB37_13
// %bb.7:                               // %B16
	cmp	w8, #4
	b.ne	.LBB37_16
// %bb.8:                               // %B10
	ldr	x8, [x29, #8]
	mov	w10, #18                        // =0x12
	ldr	x8, [x8, #64]
	cmp	x8, #0
	csel	x0, x10, x8, eq
.LBB37_9:                               // %B5
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	add	x19, x19, #2
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB37_10:                              // %B2
	ldr	w1, [x29, #152]
	mov	x0, x24
	mov	x2, x28
	str	x20, [x29, #64]
	bl	js_build_arguments_gc
.LBB37_11:                              // %B7
	cmp	x0, #130
	b.ne	.LBB37_9
// %bb.12:                              // %B8
	b	exception_asm_h
.LBB37_13:                              // %B13
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x29, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.ne	.LBB37_9
// %bb.14:                              // %B14
	b	exception_asm_h
.LBB37_15:                              // %B19
	ldr	x0, [x29, #8]
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	add	x19, x19, #2
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB37_16:                              // %B20
	ldr	x0, [x29, #128]
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	add	x19, x19, #2
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end37:
	.size	special_object_0_asm_h, .Lfunc_end37-special_object_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	rest_0_asm_h                    // -- Begin function rest_0_asm_h
	.p2align	2
	.type	rest_0_asm_h,@function
rest_0_asm_h:                           // @rest_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB38_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB38_2:                               // %B2
	ldrh	w1, [x19]
	ldr	w2, [x29, #152]
	mov	x0, x24
	mov	x3, x28
	str	x20, [x29, #64]
	bl	js_build_rest_gc
	cmp	x0, #130
	b.eq	.LBB38_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #2]
	add	x25, x25, #1936
	add	x19, x19, #3
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB38_4:                               // %B3
	b	exception_asm_h
.Lfunc_end38:
	.size	rest_0_asm_h, .Lfunc_end38-rest_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	drop_0_asm_h                    // -- Begin function drop_0_asm_h
	.p2align	2
	.type	drop_0_asm_h,@function
drop_0_asm_h:                           // @drop_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB39_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB39_2:                               // %B1
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end39:
	.size	drop_0_asm_h, .Lfunc_end39-drop_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	nip_0_asm_h                     // -- Begin function nip_0_asm_h
	.p2align	2
	.type	nip_0_asm_h,@function
nip_0_asm_h:                            // @nip_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB40_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB40_2:                               // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldur	x22, [x20, #-8]
	ldr	x0, [x25, x8, lsl #3]
	sub	x8, x20, #16
	mov	x20, x8
	br	x0
.Lfunc_end40:
	.size	nip_0_asm_h, .Lfunc_end40-nip_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	nip1_0_asm_h                    // -- Begin function nip1_0_asm_h
	.p2align	2
	.type	nip1_0_asm_h,@function
nip1_0_asm_h:                           // @nip1_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB41_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB41_2:                               // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	ldp	x22, x21, [x20, #-16]
	ldr	x0, [x25, x8, lsl #3]
	sub	x8, x20, #24
	mov	x20, x8
	br	x0
.Lfunc_end41:
	.size	nip1_0_asm_h, .Lfunc_end41-nip1_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dup_0_asm_h                     // -- Begin function dup_0_asm_h
	.p2align	2
	.type	dup_0_asm_h,@function
dup_0_asm_h:                            // @dup_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB42_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB42_2:                               // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	ldr	x22, [x20, #-8]!
	ldr	x0, [x25, x8, lsl #3]
	mov	x21, x22
	br	x0
.Lfunc_end42:
	.size	dup_0_asm_h, .Lfunc_end42-dup_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dup1_0_asm_h                    // -- Begin function dup1_0_asm_h
	.p2align	2
	.type	dup1_0_asm_h,@function
dup1_0_asm_h:                           // @dup1_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB43_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB43_2:                               // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	ldr	x21, [x20, #-8]!
	ldur	x22, [x20, #-8]
	ldr	x1, [x25, x8, lsl #3]
	mov	x0, x22
	mov	x22, x21
	mov	x22, x0
	br	x1
.Lfunc_end43:
	.size	dup1_0_asm_h, .Lfunc_end43-dup1_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dup2_0_asm_h                    // -- Begin function dup2_0_asm_h
	.p2align	2
	.type	dup2_0_asm_h,@function
dup2_0_asm_h:                           // @dup2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB44_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB44_2:                               // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	ldp	x22, x21, [x20, #-16]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end44:
	.size	dup2_0_asm_h, .Lfunc_end44-dup2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dup3_0_asm_h                    // -- Begin function dup3_0_asm_h
	.p2align	2
	.type	dup3_0_asm_h,@function
dup3_0_asm_h:                           // @dup3_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB45_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB45_2:                               // %B1
	ldp	x8, x22, [x20, #-24]
	add	x25, x25, #3872
	ldur	x21, [x20, #-8]
	str	x8, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end45:
	.size	dup3_0_asm_h, .Lfunc_end45-dup3_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	insert2_0_asm_h                 // -- Begin function insert2_0_asm_h
	.p2align	2
	.type	insert2_0_asm_h,@function
insert2_0_asm_h:                        // @insert2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB46_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB46_2:                               // %B1
	ldr	x21, [x20, #-8]!
	ldur	x22, [x20, #-8]
	add	x25, x25, #3872
	stur	x21, [x20, #-8]
	mov	x0, x22
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end46:
	.size	insert2_0_asm_h, .Lfunc_end46-insert2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	insert3_0_asm_h                 // -- Begin function insert3_0_asm_h
	.p2align	2
	.type	insert3_0_asm_h,@function
insert3_0_asm_h:                        // @insert3_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB47_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB47_2:                               // %B1
	ldr	x21, [x20, #-8]!
	add	x25, x25, #3872
	ldp	x8, x22, [x20, #-16]
	stp	x21, x8, [x20, #-16]
	mov	x1, x22
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x22, x1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end47:
	.size	insert3_0_asm_h, .Lfunc_end47-insert3_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	insert4_0_asm_h                 // -- Begin function insert4_0_asm_h
	.p2align	2
	.type	insert4_0_asm_h,@function
insert4_0_asm_h:                        // @insert4_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB48_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB48_2:                               // %B1
	ldr	x21, [x20, #-8]!
	ldur	x22, [x20, #-8]
	ldp	x10, x8, [x20, #-24]
	add	x25, x25, #3872
	stur	x21, [x20, #-24]
	mov	x0, x22
	mov	x22, x21
	mov	x22, x0
	stp	x10, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end48:
	.size	insert4_0_asm_h, .Lfunc_end48-insert4_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	perm3_0_asm_h                   // -- Begin function perm3_0_asm_h
	.p2align	2
	.type	perm3_0_asm_h,@function
perm3_0_asm_h:                          // @perm3_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB49_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB49_2:                               // %B1
	ldp	x22, x21, [x20, #-16]!
	add	x25, x25, #3872
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end49:
	.size	perm3_0_asm_h, .Lfunc_end49-perm3_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	perm4_0_asm_h                   // -- Begin function perm4_0_asm_h
	.p2align	2
	.type	perm4_0_asm_h,@function
perm4_0_asm_h:                          // @perm4_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB50_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB50_2:                               // %B1
	ldp	x22, x21, [x20, #-16]!
	add	x25, x25, #3872
	mov	x10, x22
	ldp	x8, x22, [x20, #-16]
	stp	x10, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end50:
	.size	perm4_0_asm_h, .Lfunc_end50-perm4_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	perm5_0_asm_h                   // -- Begin function perm5_0_asm_h
	.p2align	2
	.type	perm5_0_asm_h,@function
perm5_0_asm_h:                          // @perm5_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB51_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB51_2:                               // %B1
	ldr	x22, [x20, #-16]!
	add	x25, x25, #3872
	ldp	x10, x8, [x20, #-24]
	ldr	x21, [x20, #8]
	mov	x11, x22
	ldur	x22, [x20, #-8]
	stur	x11, [x20, #-24]
	stp	x10, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end51:
	.size	perm5_0_asm_h, .Lfunc_end51-perm5_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	swap_0_asm_h                    // -- Begin function swap_0_asm_h
	.p2align	2
	.type	swap_0_asm_h,@function
swap_0_asm_h:                           // @swap_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB52_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB52_2:                               // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	ldp	x22, x21, [x20, #-16]!
	ldr	x1, [x25, x8, lsl #3]
	mov	x0, x22
	mov	x22, x21
	mov	x21, x0
	br	x1
.Lfunc_end52:
	.size	swap_0_asm_h, .Lfunc_end52-swap_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	swap2_0_asm_h                   // -- Begin function swap2_0_asm_h
	.p2align	2
	.type	swap2_0_asm_h,@function
swap2_0_asm_h:                          // @swap2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB53_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB53_2:                               // %B1
	ldp	x22, x21, [x20, #-16]!
	ldp	x8, x10, [x20, #-16]
	add	x25, x25, #3872
	stp	x22, x21, [x20, #-16]
	ldrb	w11, [x19], #1
	mov	x22, x8
	mov	x21, x10
	ldr	x0, [x25, x11, lsl #3]
	br	x0
.Lfunc_end53:
	.size	swap2_0_asm_h, .Lfunc_end53-swap2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	rot3l_0_asm_h                   // -- Begin function rot3l_0_asm_h
	.p2align	2
	.type	rot3l_0_asm_h,@function
rot3l_0_asm_h:                          // @rot3l_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB54_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB54_2:                               // %B1
	ldr	x22, [x20, #-16]!
	ldur	x8, [x20, #-8]
	add	x25, x25, #3872
	ldr	x21, [x20, #8]
	stur	x22, [x20, #-8]
	ldrb	w10, [x19], #1
	mov	x22, x21
	mov	x21, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.Lfunc_end54:
	.size	rot3l_0_asm_h, .Lfunc_end54-rot3l_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	rot3r_0_asm_h                   // -- Begin function rot3r_0_asm_h
	.p2align	2
	.type	rot3r_0_asm_h,@function
rot3r_0_asm_h:                          // @rot3r_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB55_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB55_2:                               // %B1
	ldp	x22, x21, [x20, #-16]!
	add	x25, x25, #3872
	mov	x8, x21
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end55:
	.size	rot3r_0_asm_h, .Lfunc_end55-rot3r_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	rot4l_0_asm_h                   // -- Begin function rot4l_0_asm_h
	.p2align	2
	.type	rot4l_0_asm_h,@function
rot4l_0_asm_h:                          // @rot4l_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB56_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB56_2:                               // %B1
	ldr	x22, [x20, #-16]!
	add	x25, x25, #3872
	ldp	x10, x8, [x20, #-16]
	ldr	x21, [x20, #8]
	stp	x8, x22, [x20, #-16]
	mov	x22, x21
	mov	x21, x10
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end56:
	.size	rot4l_0_asm_h, .Lfunc_end56-rot4l_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	rot5l_0_asm_h                   // -- Begin function rot5l_0_asm_h
	.p2align	2
	.type	rot5l_0_asm_h,@function
rot5l_0_asm_h:                          // @rot5l_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB57_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB57_2:                               // %B1
	ldr	x22, [x20, #-16]!
	ldur	x11, [x20, #-24]
	ldp	x8, x10, [x20, #-16]
	add	x25, x25, #3872
	stur	x22, [x20, #-8]
	ldr	x21, [x20, #8]
	stp	x8, x10, [x20, #-24]
	mov	x22, x21
	mov	x21, x11
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end57:
	.size	rot5l_0_asm_h, .Lfunc_end57-rot5l_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call_constructor_0_asm_h        // -- Begin function call_constructor_0_asm_h
	.p2align	2
	.type	call_constructor_0_asm_h,@function
call_constructor_0_asm_h:               // @call_constructor_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB58_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB58_2:                               // %B2
	mov	x8, x19
	mov	x0, x24
	mov	w5, wzr
	ldrh	w3, [x8], #2
	sub	x4, x20, w3, uxtw #3
	ldp	x1, x2, [x4, #-16]
	str	x8, [x29, #48]
	str	x20, [x29, #64]
	bl	JS_CallConstructorInternal_GC
	cmp	x0, #130
	b.eq	.LBB58_4
// %bb.3:                               // %B4
	ldrh	w8, [x19]
	sub	x8, x20, x8, lsl #3
	stur	x0, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w10, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB58_4:                               // %B3
	b	exception_asm_h
.Lfunc_end58:
	.size	call_constructor_0_asm_h, .Lfunc_end58-call_constructor_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call_0_asm_h                    // -- Begin function call_0_asm_h
	.p2align	2
	.type	call_0_asm_h,@function
call_0_asm_h:                           // @call_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB59_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB59_2:                               // %B3
	ldrh	w10, [x19], #2
	str	x19, [x29, #48]
	str	x20, [x29, #64]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	sub	x8, x20, x10, lsl #3
	mov	x9, x10
	ldur	x22, [x8, #-8]
	mov	x20, x8
	bl	common_call_asm_h
	mov	x8, x27
	ldr	x19, [x29, #48]
	ldr	x20, [x29, #64]
	ldp	x28, x27, [x29, #16]
	cmp	x8, #130
	ldp	x26, x23, [x29, #136]
	b.eq	.LBB59_4
// %bb.3:                               // %B5
	ldurh	w10, [x19, #-2]
	add	w10, w10, #1
	sub	x20, x20, w10, uxtw #3
	str	x8, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB59_4:                               // %B4
	b	exception_asm_h
.Lfunc_end59:
	.size	call_0_asm_h, .Lfunc_end59-call_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	tail_call_0_asm_h               // -- Begin function tail_call_0_asm_h
	.p2align	2
	.type	tail_call_0_asm_h,@function
tail_call_0_asm_h:                      // @tail_call_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB60_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB60_2:                               // %B3
	ldrh	w10, [x19], #2
	str	x19, [x29, #48]
	str	x20, [x29, #64]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	sub	x8, x20, x10, lsl #3
	mov	x9, x10
	ldur	x22, [x8, #-8]
	mov	x20, x8
	bl	common_call_asm_h
	cmp	x27, #130
	b.eq	.LBB60_4
// %bb.3:                               // %B5
	mov	x19, xzr
	mov	x20, xzr
	mov	x9, x27
	b	common_return_asm_h
.LBB60_4:                               // %B4
	mov	x19, xzr
	mov	x20, xzr
	b	exception_asm_h
.Lfunc_end60:
	.size	tail_call_0_asm_h, .Lfunc_end60-tail_call_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call_method_0_asm_h             // -- Begin function call_method_0_asm_h
	.p2align	2
	.type	call_method_0_asm_h,@function
call_method_0_asm_h:                    // @call_method_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB61_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB61_2:                               // %B3
	ldrh	w10, [x19], #2
	str	x19, [x29, #48]
	str	x20, [x29, #64]
	mov	w27, #18                        // =0x12
	sub	x8, x20, x10, lsl #3
	mov	x9, x10
	ldp	x21, x22, [x8, #-16]
	mov	x20, x8
	bl	common_call_asm_h
	mov	x8, x27
	ldr	x19, [x29, #48]
	ldr	x20, [x29, #64]
	ldp	x28, x27, [x29, #16]
	cmp	x8, #130
	ldp	x26, x23, [x29, #136]
	b.eq	.LBB61_4
// %bb.3:                               // %B5
	ldurh	w10, [x19, #-2]
	add	w10, w10, #2
	sub	x20, x20, w10, uxtw #3
	str	x8, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB61_4:                               // %B4
	b	exception_asm_h
.Lfunc_end61:
	.size	call_method_0_asm_h, .Lfunc_end61-call_method_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	tail_call_method_0_asm_h        // -- Begin function tail_call_method_0_asm_h
	.p2align	2
	.type	tail_call_method_0_asm_h,@function
tail_call_method_0_asm_h:               // @tail_call_method_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB62_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB62_2:                               // %B3
	ldrh	w10, [x19], #2
	str	x19, [x29, #48]
	str	x20, [x29, #64]
	mov	w27, #18                        // =0x12
	sub	x8, x20, x10, lsl #3
	mov	x9, x10
	ldp	x21, x22, [x8, #-16]
	mov	x20, x8
	bl	common_call_asm_h
	cmp	x27, #130
	b.eq	.LBB62_4
// %bb.3:                               // %B5
	mov	x19, xzr
	mov	x20, xzr
	mov	x9, x27
	b	common_return_asm_h
.LBB62_4:                               // %B4
	mov	x19, xzr
	mov	x20, xzr
	b	exception_asm_h
.Lfunc_end62:
	.size	tail_call_method_0_asm_h, .Lfunc_end62-tail_call_method_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	array_from_0_asm_h              // -- Begin function array_from_0_asm_h
	.p2align	2
	.type	array_from_0_asm_h,@function
array_from_0_asm_h:                     // @array_from_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB63_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB63_2:                               // %B2
	ldrh	w1, [x19]
	mov	x0, x24
	str	x20, [x29, #64]
	sub	x2, x20, w1, uxtw #3
	bl	LEPUS_NewArrayWithArgs
	cmp	x0, #130
	b.eq	.LBB63_4
// %bb.3:                               // %B4
	ldrh	w8, [x19]
	sub	x20, x20, x8, lsl #3
	str	x0, [x20], #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB63_4:                               // %B3
	b	exception_asm_h
.Lfunc_end63:
	.size	array_from_0_asm_h, .Lfunc_end63-array_from_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	apply_0_asm_h                   // -- Begin function apply_0_asm_h
	.p2align	2
	.type	apply_0_asm_h,@function
apply_0_asm_h:                          // @apply_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB64_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB64_2:                               // %B2
	ldrh	w4, [x19]
	ldur	x1, [x20, #-24]
	sub	x3, x20, #16
	mov	x0, x24
	mov	w2, #2                          // =0x2
	str	x20, [x29, #64]
	str	x3, [sp, #8]                    // 8-byte Folded Spill
	bl	js_function_apply_gc
	cmp	x0, #130
	b.eq	.LBB64_4
// %bb.3:                               // %B4
	stur	x0, [x20, #-24]
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.LBB64_4:                               // %B3
	add	sp, sp, #16
	b	exception_asm_h
.Lfunc_end64:
	.size	apply_0_asm_h, .Lfunc_end64-apply_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	return_0_asm_h                  // -- Begin function return_0_asm_h
	.p2align	2
	.type	return_0_asm_h,@function
return_0_asm_h:                         // @return_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB65_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB65_2:                               // %B1
	ldr	x22, [x20, #-8]!
	mov	x27, x22
	b	common_return_asm_h
.Lfunc_end65:
	.size	return_0_asm_h, .Lfunc_end65-return_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	return_undef_0_asm_h            // -- Begin function return_undef_0_asm_h
	.p2align	2
	.type	return_undef_0_asm_h,@function
return_undef_0_asm_h:                   // @return_undef_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB66_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB66_2:                               // %B1
	mov	w27, #18                        // =0x12
	b	common_return_asm_h
.Lfunc_end66:
	.size	return_undef_0_asm_h, .Lfunc_end66-return_undef_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	check_ctor_return_0_asm_h       // -- Begin function check_ctor_return_0_asm_h
	.p2align	2
	.type	check_ctor_return_0_asm_h,@function
check_ctor_return_0_asm_h:              // @check_ctor_return_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB67_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB67_2:                               // %B6
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	.LBB67_5
// %bb.3:                               // %B3
	cmp	x22, #18
	b.eq	.LBB67_6
// %bb.4:                               // %B4
	adrp	x1, .L__unnamed_3
	add	x1, x1, :lo12:.L__unnamed_3
	mov	x0, x24
	str	x20, [x29, #64]
	bl	LEPUS_ThrowTypeError
	b	exception_asm_h
.LBB67_5:                               // %B7
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #8
	mov	w21, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB67_6:                               // %B5
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #8
	mov	w21, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end67:
	.size	check_ctor_return_0_asm_h, .Lfunc_end67-check_ctor_return_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	check_ctor_0_asm_h              // -- Begin function check_ctor_0_asm_h
	.p2align	2
	.type	check_ctor_0_asm_h,@function
check_ctor_0_asm_h:                     // @check_ctor_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB68_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB68_2:                               // %B3
	ldr	x8, [x29, #128]
	cmp	x8, #18
	b.ne	.LBB68_4
// %bb.3:                               // %B4
	adrp	x1, .L__unnamed_4
	add	x1, x1, :lo12:.L__unnamed_4
	mov	x0, x24
	str	x20, [x29, #64]
	bl	LEPUS_ThrowTypeError
	b	exception_asm_h
.LBB68_4:                               // %B5
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end68:
	.size	check_ctor_0_asm_h, .Lfunc_end68-check_ctor_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	check_brand_0_asm_h             // -- Begin function check_brand_0_asm_h
	.p2align	2
	.type	check_brand_0_asm_h,@function
check_brand_0_asm_h:                    // @check_brand_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB69_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB69_2:                               // %B2
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	mov	x2, x21
	bl	JS_CheckBrand_GC
	tbnz	w0, #31, .LBB69_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB69_4:                               // %B3
	b	exception_asm_h
.Lfunc_end69:
	.size	check_brand_0_asm_h, .Lfunc_end69-check_brand_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	add_brand_0_asm_h               // -- Begin function add_brand_0_asm_h
	.p2align	2
	.type	add_brand_0_asm_h,@function
add_brand_0_asm_h:                      // @add_brand_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB70_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB70_2:                               // %B2
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	mov	x2, x21
	bl	JS_AddBrand_GC
	tbnz	w0, #31, .LBB70_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB70_4:                               // %B3
	b	exception_asm_h
.Lfunc_end70:
	.size	add_brand_0_asm_h, .Lfunc_end70-add_brand_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	return_async_0_asm_h            // -- Begin function return_async_0_asm_h
	.p2align	2
	.type	return_async_0_asm_h,@function
return_async_0_asm_h:                   // @return_async_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	ldr	w8, [x24, #336]
	cbz	w8, .LBB71_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB71_2:                               // %B4
	ldr	x1, [x29, #112]
	add	x10, x29, #32
	str	x19, [x1, #48]
	str	x20, [x1, #64]
	ldr	x8, [x29, #40]
	cmp	x8, x10
	b.eq	.LBB71_4
// %bb.3:                               // %B6
	mov	x0, x29
	bl	prim_copy_var_refs_gc
.LBB71_4:                               // %B2
	mov	w27, #18                        // =0x12
	b	common_return_direct_asm_h
.Lfunc_end71:
	.size	return_async_0_asm_h, .Lfunc_end71-return_async_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	throw_0_asm_h                   // -- Begin function throw_0_asm_h
	.p2align	2
	.type	throw_0_asm_h,@function
throw_0_asm_h:                          // @throw_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB72_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB72_2:                               // %B1
	ldr	x1, [x20, #-8]!
	mov	x0, x24
	str	x20, [x29, #64]
	bl	LEPUS_Throw
	b	exception_asm_h
.Lfunc_end72:
	.size	throw_0_asm_h, .Lfunc_end72-throw_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	throw_var_0_asm_h               // -- Begin function throw_var_0_asm_h
	.p2align	2
	.type	throw_var_0_asm_h,@function
throw_var_0_asm_h:                      // @throw_var_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B11
	ldr	w8, [x24, #336]
	cbz	w8, .LBB73_2
// %bb.1:                               // %B12
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB73_2:                               // %B4
	ldrb	w8, [x19, #4]
	ldr	w2, [x19]
	str	x20, [x29, #64]
	cmp	w8, #1
	b.le	.LBB73_7
// %bb.3:                               // %B4
	cmp	w8, #2
	b.eq	.LBB73_10
// %bb.4:                               // %B4
	cmp	w8, #3
	b.eq	.LBB73_11
// %bb.5:                               // %B4
	cmp	w8, #4
	b.ne	.LBB73_13
// %bb.6:                               // %B9
	adrp	x1, .L__unnamed_5
	add	x1, x1, :lo12:.L__unnamed_5
	mov	x0, x24
	bl	LEPUS_ThrowTypeError
	b	exception_asm_h
.LBB73_7:                               // %B4
	cbz	w8, .LBB73_12
// %bb.8:                               // %B4
	cmp	w8, #1
	b.ne	.LBB73_13
// %bb.9:                               // %B6
	mov	x0, x24
	mov	w1, w2
	bl	JS_ThrowSyntaxErrorVarRedeclaration_GC
	b	exception_asm_h
.LBB73_10:                              // %B7
	mov	x0, x24
	mov	w1, w2
	bl	JS_ThrowReferenceErrorUninitialized_GC
	b	exception_asm_h
.LBB73_11:                              // %B8
	adrp	x1, .L__unnamed_6
	add	x1, x1, :lo12:.L__unnamed_6
	mov	x0, x24
	bl	LEPUS_ThrowReferenceError
	b	exception_asm_h
.LBB73_12:                              // %B5
	mov	x0, x24
	mov	w1, #16384                      // =0x4000
	bl	JS_ThrowTypeErrorReadOnly
	b	exception_asm_h
.LBB73_13:                              // %B10
	adrp	x1, .L__unnamed_7
	add	x1, x1, :lo12:.L__unnamed_7
	mov	x0, x24
	bl	LEPUS_ThrowInternalError
	b	exception_asm_h
.Lfunc_end73:
	.size	throw_var_0_asm_h, .Lfunc_end73-throw_var_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	eval_0_asm_h                    // -- Begin function eval_0_asm_h
	.p2align	2
	.type	eval_0_asm_h,@function
eval_0_asm_h:                           // @eval_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB74_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB74_2:                               // %B2
	ldrh	w8, [x19]
	ldur	x2, [x20, #-8]
	mov	x0, x24
	str	x20, [x29, #64]
	sub	w1, w8, #1
	bl	prim_js_op_eval_gc
	cmp	x0, #130
	b.eq	.LBB74_4
// %bb.3:                               // %B4
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB74_4:                               // %B3
	b	exception_asm_h
.Lfunc_end74:
	.size	eval_0_asm_h, .Lfunc_end74-eval_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	regexp_0_asm_h                  // -- Begin function regexp_0_asm_h
	.p2align	2
	.type	regexp_0_asm_h,@function
regexp_0_asm_h:                         // @regexp_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB75_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB75_2:                               // %B2
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w1, #18                         // =0x12
	str	x20, [x29, #64]
	mov	x2, x22
	mov	x3, x21
	bl	js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	.LBB75_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB75_4:                               // %B3
	b	exception_asm_h
.Lfunc_end75:
	.size	regexp_0_asm_h, .Lfunc_end75-regexp_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_super_ctor_0_asm_h          // -- Begin function get_super_ctor_0_asm_h
	.p2align	2
	.type	get_super_ctor_0_asm_h,@function
get_super_ctor_0_asm_h:                 // @get_super_ctor_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB76_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB76_2:                               // %B2
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	bl	primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	.LBB76_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB76_4:                               // %B3
	b	exception_asm_h
.Lfunc_end76:
	.size	get_super_ctor_0_asm_h, .Lfunc_end76-get_super_ctor_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_super_0_asm_h               // -- Begin function get_super_0_asm_h
	.p2align	2
	.type	get_super_0_asm_h,@function
get_super_0_asm_h:                      // @get_super_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB77_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB77_2:                               // %B2
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	bl	LEPUS_GetPrototype
	cmp	x0, #130
	b.eq	.LBB77_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB77_4:                               // %B3
	b	exception_asm_h
.Lfunc_end77:
	.size	get_super_0_asm_h, .Lfunc_end77-get_super_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	import_0_asm_h                  // -- Begin function import_0_asm_h
	.p2align	2
	.type	import_0_asm_h,@function
import_0_asm_h:                         // @import_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB78_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB78_2:                               // %B2
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	bl	js_dynamic_import
	cmp	x0, #130
	b.eq	.LBB78_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB78_4:                               // %B3
	b	exception_asm_h
.Lfunc_end78:
	.size	import_0_asm_h, .Lfunc_end78-import_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	check_var_0_asm_h               // -- Begin function check_var_0_asm_h
	.p2align	2
	.type	check_var_0_asm_h,@function
check_var_0_asm_h:                      // @check_var_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB79_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB79_2:                               // %B2
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x29, #64]
	bl	JS_CheckGlobalVar_GC
	tbnz	w0, #31, .LBB79_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	cmp	w0, #0
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x0
.LBB79_4:                               // %B3
	b	exception_asm_h
.Lfunc_end79:
	.size	check_var_0_asm_h, .Lfunc_end79-check_var_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_undef_0_asm_h           // -- Begin function get_var_undef_0_asm_h
	.p2align	2
	.type	get_var_undef_0_asm_h,@function
get_var_undef_0_asm_h:                  // @get_var_undef_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B12
	ldr	w8, [x24, #336]
	cbz	w8, .LBB80_2
// %bb.1:                               // %B13
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB80_2:                               // %B2
	ldr	w9, [x19]
	bl	common_get_var_undef_asm_h
	cmp	x0, #130
	b.eq	.LBB80_5
// %bb.3:                               // %B2
	cmp	x0, #34
	b.eq	.LBB80_7
.LBB80_4:                               // %B11
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB80_5:                               // %B4
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x29, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.ne	.LBB80_4
// %bb.6:                               // %B5
	b	exception_asm_h
.LBB80_7:                               // %B10
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end80:
	.size	get_var_undef_0_asm_h, .Lfunc_end80-get_var_undef_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_0_asm_h                 // -- Begin function get_var_0_asm_h
	.p2align	2
	.type	get_var_0_asm_h,@function
get_var_0_asm_h:                        // @get_var_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B12
	ldr	w8, [x24, #336]
	cbz	w8, .LBB81_2
// %bb.1:                               // %B13
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB81_2:                               // %B2
	ldr	w9, [x19]
	bl	common_get_var_asm_h
	cmp	x0, #130
	b.eq	.LBB81_5
// %bb.3:                               // %B2
	cmp	x0, #34
	b.eq	.LBB81_7
.LBB81_4:                               // %B11
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB81_5:                               // %B4
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x20, [x29, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.ne	.LBB81_4
// %bb.6:                               // %B5
	b	exception_asm_h
.LBB81_7:                               // %B10
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end81:
	.size	get_var_0_asm_h, .Lfunc_end81-get_var_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_0_asm_h                 // -- Begin function put_var_0_asm_h
	.p2align	2
	.type	put_var_0_asm_h,@function
put_var_0_asm_h:                        // @put_var_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB82_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB82_2:                               // %B2
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	mov	w3, wzr
	str	x20, [x29, #64]
	mov	x2, x22
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB82_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB82_4:                               // %B3
	b	exception_asm_h
.Lfunc_end82:
	.size	put_var_0_asm_h, .Lfunc_end82-put_var_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_init_0_asm_h            // -- Begin function put_var_init_0_asm_h
	.p2align	2
	.type	put_var_init_0_asm_h,@function
put_var_init_0_asm_h:                   // @put_var_init_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB83_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB83_2:                               // %B2
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x29, #64]
	mov	x2, x22
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB83_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB83_4:                               // %B3
	b	exception_asm_h
.Lfunc_end83:
	.size	put_var_init_0_asm_h, .Lfunc_end83-put_var_init_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_strict_0_asm_h          // -- Begin function put_var_strict_0_asm_h
	.p2align	2
	.type	put_var_strict_0_asm_h,@function
put_var_strict_0_asm_h:                 // @put_var_strict_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB84_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB84_2:                               // %B6
	ldp	x22, x21, [x20, #-16]
	cmp	x22, #7
	b.ne	.LBB84_5
// %bb.3:                               // %B2
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          // =0x2
	str	x20, [x29, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB84_6
// %bb.4:                               // %B4
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB84_5:                               // %B7
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB84_6:                               // %B3
	b	exception_asm_h
.Lfunc_end84:
	.size	put_var_strict_0_asm_h, .Lfunc_end84-put_var_strict_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_ref_value_0_asm_h           // -- Begin function get_ref_value_0_asm_h
	.p2align	2
	.type	get_ref_value_0_asm_h,@function
get_ref_value_0_asm_h:                  // @get_ref_value_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B12
	ldr	w8, [x24, #336]
	cbz	w8, .LBB85_2
// %bb.1:                               // %B13
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB85_2:                               // %B9
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	cmp	x22, #18
	b.eq	.LBB85_5
// %bb.3:                               // %B2
	mov	x1, x22
	mov	x2, x21
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB85_7
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #8
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB85_5:                               // %B6
	mov	x1, x21
	bl	js_value_to_atom_gc
	cbz	w0, .LBB85_7
// %bb.6:                               // %B8
	mov	w1, w0
	mov	x0, x24
	str	x20, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB85_7:                               // %B7
	b	exception_asm_h
.Lfunc_end85:
	.size	get_ref_value_0_asm_h, .Lfunc_end85-get_ref_value_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_ref_value_0_asm_h           // -- Begin function put_ref_value_0_asm_h
	.p2align	2
	.type	put_ref_value_0_asm_h,@function
put_ref_value_0_asm_h:                  // @put_ref_value_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB86_2
// %bb.1:                               // %B17
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB86_2:                               // %B13
	ldp	x1, x22, [x20, #-24]
	ldur	x21, [x20, #-8]
	cmp	x1, #18
	b.eq	.LBB86_5
.LBB86_3:                               // %B2
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	str	x20, [x29, #64]
	bl	JS_SetPropertyValue_GC
	tbnz	w0, #31, .LBB86_9
// %bb.4:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB86_5:                               // %B9
	ldr	w8, [x29, #60]
	tbnz	w8, #0, .LBB86_7
// %bb.6:                               // %B10
	ldr	x1, [x24, #224]
	b	.LBB86_3
.LBB86_7:                               // %B6
	mov	x0, x24
	mov	x1, x22
	str	x20, [x29, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB86_9
// %bb.8:                               // %B8
	mov	w1, w0
	mov	x0, x24
	str	x20, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB86_9:                               // %B3
	b	exception_asm_h
.Lfunc_end86:
	.size	put_ref_value_0_asm_h, .Lfunc_end86-put_ref_value_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_var_0_asm_h              // -- Begin function define_var_0_asm_h
	.p2align	2
	.type	define_var_0_asm_h,@function
define_var_0_asm_h:                     // @define_var_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB87_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB87_2:                               // %B2
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x0, x24
	str	x20, [x29, #64]
	bl	JS_DefineGlobalVar_GC
	tbnz	w0, #31, .LBB87_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB87_4:                               // %B3
	b	exception_asm_h
.Lfunc_end87:
	.size	define_var_0_asm_h, .Lfunc_end87-define_var_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	check_define_var_0_asm_h        // -- Begin function check_define_var_0_asm_h
	.p2align	2
	.type	check_define_var_0_asm_h,@function
check_define_var_0_asm_h:               // @check_define_var_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB88_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB88_2:                               // %B2
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x0, x24
	str	x20, [x29, #64]
	bl	JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, .LBB88_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB88_4:                               // %B3
	b	exception_asm_h
.Lfunc_end88:
	.size	check_define_var_0_asm_h, .Lfunc_end88-check_define_var_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_func_0_asm_h             // -- Begin function define_func_0_asm_h
	.p2align	2
	.type	define_func_0_asm_h,@function
define_func_0_asm_h:                    // @define_func_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB89_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB89_2:                               // %B2
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	ldrb	w3, [x19, #4]
	str	x20, [x29, #64]
	mov	x2, x22
	bl	JS_DefineGlobalFunction_GC
	tbnz	w0, #31, .LBB89_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #5]
	sub	x20, x20, #8
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB89_4:                               // %B3
	b	exception_asm_h
.Lfunc_end89:
	.size	define_func_0_asm_h, .Lfunc_end89-define_func_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_field_0_asm_h               // -- Begin function get_field_0_asm_h
	.p2align	2
	.type	get_field_0_asm_h,@function
get_field_0_asm_h:                      // @get_field_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB90_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB90_2:                               // %B2
	ldur	x22, [x20, #-8]
	ldr	w9, [x19]
	mov	x21, x22
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB90_4
.LBB90_3:                               // %B8
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB90_4:                               // %B4
	ldr	w2, [x19]
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.ne	.LBB90_3
// %bb.5:                               // %B5
	b	exception_asm_h
.Lfunc_end90:
	.size	get_field_0_asm_h, .Lfunc_end90-get_field_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_field2_0_asm_h              // -- Begin function get_field2_0_asm_h
	.p2align	2
	.type	get_field2_0_asm_h,@function
get_field2_0_asm_h:                     // @get_field2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB91_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB91_2:                               // %B2
	ldur	x22, [x20, #-8]
	ldr	w9, [x19]
	mov	x21, x22
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB91_4
.LBB91_3:                               // %B8
	ldrb	w8, [x19, #4]
	add	x25, x25, #3872
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB91_4:                               // %B4
	ldr	w2, [x19]
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.ne	.LBB91_3
// %bb.5:                               // %B5
	b	exception_asm_h
.Lfunc_end91:
	.size	get_field2_0_asm_h, .Lfunc_end91-get_field2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_field_0_asm_h               // -- Begin function put_field_0_asm_h
	.p2align	2
	.type	put_field_0_asm_h,@function
put_field_0_asm_h:                      // @put_field_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB92_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB92_2:                               // %B1
	ldp	x22, x21, [x20, #-16]
	b	common_set_property_asm_h
.Lfunc_end92:
	.size	put_field_0_asm_h, .Lfunc_end92-put_field_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_private_field_0_asm_h       // -- Begin function get_private_field_0_asm_h
	.p2align	2
	.type	get_private_field_0_asm_h,@function
get_private_field_0_asm_h:              // @get_private_field_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB93_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB93_2:                               // %B2
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	mov	x2, x21
	bl	JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	.LBB93_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB93_4:                               // %B3
	b	exception_asm_h
.Lfunc_end93:
	.size	get_private_field_0_asm_h, .Lfunc_end93-get_private_field_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_private_field_0_asm_h       // -- Begin function put_private_field_0_asm_h
	.p2align	2
	.type	put_private_field_0_asm_h,@function
put_private_field_0_asm_h:              // @put_private_field_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB94_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB94_2:                               // %B2
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	str	x20, [x29, #64]
	mov	x2, x21
	mov	x3, x22
	bl	JS_SetPrivateField_GC
	tbnz	w0, #31, .LBB94_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB94_4:                               // %B3
	b	exception_asm_h
.Lfunc_end94:
	.size	put_private_field_0_asm_h, .Lfunc_end94-put_private_field_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_private_field_0_asm_h    // -- Begin function define_private_field_0_asm_h
	.p2align	2
	.type	define_private_field_0_asm_h,@function
define_private_field_0_asm_h:           // @define_private_field_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB95_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB95_2:                               // %B2
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	str	x20, [x29, #64]
	mov	x2, x22
	mov	x3, x21
	bl	JS_DefinePrivateField_GC
	tbnz	w0, #31, .LBB95_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB95_4:                               // %B3
	b	exception_asm_h
.Lfunc_end95:
	.size	define_private_field_0_asm_h, .Lfunc_end95-define_private_field_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_array_el_0_asm_h            // -- Begin function get_array_el_0_asm_h
	.p2align	2
	.type	get_array_el_0_asm_h,@function
get_array_el_0_asm_h:                   // @get_array_el_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB96_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB96_2:                               // %B6
	ldp	x22, x21, [x20, #-16]
	bl	common_get_property_value_asm_h
	cmp	x0, #130
	b.eq	.LBB96_4
.LBB96_3:                               // %B8
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB96_4:                               // %B2
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x29, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.ne	.LBB96_3
// %bb.5:                               // %B3
	b	exception_asm_h
.Lfunc_end96:
	.size	get_array_el_0_asm_h, .Lfunc_end96-get_array_el_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_array_el2_0_asm_h           // -- Begin function get_array_el2_0_asm_h
	.p2align	2
	.type	get_array_el2_0_asm_h,@function
get_array_el2_0_asm_h:                  // @get_array_el2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB97_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB97_2:                               // %B6
	ldp	x22, x21, [x20, #-16]
	bl	common_get_property_value_asm_h
	cmp	x0, #130
	b.eq	.LBB97_4
.LBB97_3:                               // %B8
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #16
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB97_4:                               // %B2
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x29, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.ne	.LBB97_3
// %bb.5:                               // %B3
	b	exception_asm_h
.Lfunc_end97:
	.size	get_array_el2_0_asm_h, .Lfunc_end97-get_array_el2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_array_el_0_asm_h            // -- Begin function put_array_el_0_asm_h
	.p2align	2
	.type	put_array_el_0_asm_h,@function
put_array_el_0_asm_h:                   // @put_array_el_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB98_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB98_2:                               // %B1
	ldp	x22, x21, [x20, #-16]
	ldur	x9, [x20, #-24]
	b	common_set_property_value_asm_h
.Lfunc_end98:
	.size	put_array_el_0_asm_h, .Lfunc_end98-put_array_el_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_super_value_0_asm_h         // -- Begin function get_super_value_0_asm_h
	.p2align	2
	.type	get_super_value_0_asm_h,@function
get_super_value_0_asm_h:                // @get_super_value_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB99_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB99_2:                               // %B2
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x21
	bl	js_value_to_atom_gc
	cbz	w0, .LBB99_5
// %bb.3:                               // %B6
	ldur	x3, [x20, #-24]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	str	x20, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB99_5
// %bb.4:                               // %B8
	stur	x0, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB99_5:                               // %B7
	b	exception_asm_h
.Lfunc_end99:
	.size	get_super_value_0_asm_h, .Lfunc_end99-get_super_value_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_super_value_0_asm_h         // -- Begin function put_super_value_0_asm_h
	.p2align	2
	.type	put_super_value_0_asm_h,@function
put_super_value_0_asm_h:                // @put_super_value_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B12
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB100_2
// %bb.1:                               // %B13
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB100_2:                              // %B9
	str	x19, [sp, #8]                   // 8-byte Folded Spill
	ldur	x19, [x20, #-24]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x19, x8
	b.eq	.LBB100_5
// %bb.3:                               // %B11
	mov	x0, x24
	str	x20, [x29, #64]
	bl	JS_ThrowTypeErrorNotAnObject
.LBB100_4:                              // %B3
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	add	sp, sp, #16
	b	exception_asm_h
.LBB100_5:                              // %B2
	ldur	x1, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB100_4
// %bb.6:                               // %B6
	ldur	x3, [x20, #-8]
	ldur	x4, [x20, #-32]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x19
	mov	w5, #32768                      // =0x8000
	str	x20, [x29, #64]
	bl	JS_SetPropertyGeneric_GC
	tbnz	w0, #31, .LBB100_4
// %bb.7:                               // %B8
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	sub	x20, x20, #32
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.Lfunc_end100:
	.size	put_super_value_0_asm_h, .Lfunc_end100-put_super_value_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_field_0_asm_h            // -- Begin function define_field_0_asm_h
	.p2align	2
	.type	define_field_0_asm_h,@function
define_field_0_asm_h:                   // @define_field_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB101_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB101_2:                              // %B2
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldr	w2, [x19]
	mov	w4, #16391                      // =0x4007
	str	x20, [x29, #64]
	mov	x1, x22
	mov	x3, x21
	bl	LEPUS_DefinePropertyValue
	tbnz	w0, #31, .LBB101_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB101_4:                              // %B3
	b	exception_asm_h
.Lfunc_end101:
	.size	define_field_0_asm_h, .Lfunc_end101-define_field_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_name_0_asm_h                // -- Begin function set_name_0_asm_h
	.p2align	2
	.type	set_name_0_asm_h,@function
set_name_0_asm_h:                       // @set_name_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB102_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB102_2:                              // %B2
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x29, #64]
	mov	x1, x22
	bl	JS_DefineObjectName
	tbnz	w0, #31, .LBB102_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB102_4:                              // %B3
	b	exception_asm_h
.Lfunc_end102:
	.size	set_name_0_asm_h, .Lfunc_end102-set_name_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_name_computed_0_asm_h       // -- Begin function set_name_computed_0_asm_h
	.p2align	2
	.type	set_name_computed_0_asm_h,@function
set_name_computed_0_asm_h:              // @set_name_computed_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB103_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB103_2:                              // %B2
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x29, #64]
	mov	x1, x21
	mov	x2, x22
	bl	JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, .LBB103_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB103_4:                              // %B3
	b	exception_asm_h
.Lfunc_end103:
	.size	set_name_computed_0_asm_h, .Lfunc_end103-set_name_computed_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_proto_0_asm_h               // -- Begin function set_proto_0_asm_h
	.p2align	2
	.type	set_proto_0_asm_h,@function
set_proto_0_asm_h:                      // @set_proto_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B10
	ldr	w8, [x24, #336]
	cbz	w8, .LBB104_2
// %bb.1:                               // %B11
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB104_2:                              // %B7
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB104_5
// %bb.3:                               // %B7
	cmp	x21, #2
	b.eq	.LBB104_5
.LBB104_4:                              // %B5
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB104_5:                              // %B2
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x20, [x29, #64]
	bl	JS_SetPrototypeInternal_GC
	tbz	w0, #31, .LBB104_4
// %bb.6:                               // %B3
	b	exception_asm_h
.Lfunc_end104:
	.size	set_proto_0_asm_h, .Lfunc_end104-set_proto_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_home_object_0_asm_h         // -- Begin function set_home_object_0_asm_h
	.p2align	2
	.type	set_home_object_0_asm_h,@function
set_home_object_0_asm_h:                // @set_home_object_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB105_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB105_2:                              // %B1
	mov	x8, x20
	ldur	x21, [x20, #-8]
	mov	x0, x24
	ldr	x22, [x8, #-16]!
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	mov	x1, x21
	str	x20, [x29, #64]
	mov	x2, x22
	bl	js_method_set_home_object_gc
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.Lfunc_end105:
	.size	set_home_object_0_asm_h, .Lfunc_end105-set_home_object_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_array_el_0_asm_h         // -- Begin function define_array_el_0_asm_h
	.p2align	2
	.type	define_array_el_0_asm_h,@function
define_array_el_0_asm_h:                // @define_array_el_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB106_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB106_2:                              // %B2
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	mov	w4, #16391                      // =0x4007
	str	x20, [x29, #64]
	mov	x2, x22
	mov	x3, x21
	bl	JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, .LBB106_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB106_4:                              // %B3
	b	exception_asm_h
.Lfunc_end106:
	.size	define_array_el_0_asm_h, .Lfunc_end106-define_array_el_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	append_0_asm_h                  // -- Begin function append_0_asm_h
	.p2align	2
	.type	append_0_asm_h,@function
append_0_asm_h:                         // @append_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB107_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB107_2:                              // %B2
	mov	x0, x24
	mov	x1, x20
	str	x20, [x29, #64]
	bl	js_append_enumerate_gc
	tbnz	w0, #31, .LBB107_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB107_4:                              // %B3
	b	exception_asm_h
.Lfunc_end107:
	.size	append_0_asm_h, .Lfunc_end107-append_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	copy_data_properties_0_asm_h    // -- Begin function copy_data_properties_0_asm_h
	.p2align	2
	.type	copy_data_properties_0_asm_h,@function
copy_data_properties_0_asm_h:           // @copy_data_properties_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB108_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB108_2:                              // %B2
	ldrb	w2, [x19]
	mov	x0, x24
	mov	x1, x20
	str	x20, [x29, #64]
	bl	prim_js_copy_data_properties_gc
	tbnz	w0, #31, .LBB108_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB108_4:                              // %B3
	b	exception_asm_h
.Lfunc_end108:
	.size	copy_data_properties_0_asm_h, .Lfunc_end108-copy_data_properties_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_method_0_asm_h           // -- Begin function define_method_0_asm_h
	.p2align	2
	.type	define_method_0_asm_h,@function
define_method_0_asm_h:                  // @define_method_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B20
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	ldr	w8, [x24, #336]
	cbz	w8, .LBB109_2
// %bb.1:                               // %B21
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB109_2:                              // %B16
	ldrb	w8, [x19, #4]
	mov	w10, #17665                     // =0x4501
	mov	w11, #17669                     // =0x4505
	str	x19, [sp, #48]                  // 8-byte Folded Spill
	ldr	w19, [x19]
	tst	w8, #0x4
	csel	w11, w11, w10, ne
	ldp	x10, x12, [x20, #-16]
	ands	w8, w8, #0x3
	b.eq	.LBB109_5
// %bb.3:                               // %B16
	cmp	w8, #1
	b.ne	.LBB109_6
// %bb.4:                               // %B14
	mov	w8, #18                         // =0x12
	mov	w13, #2048                      // =0x800
	stp	x12, x8, [sp, #16]              // 16-byte Folded Spill
	b	.LBB109_7
.LBB109_5:
	mov	w8, #18                         // =0x12
	str	x12, [sp, #40]                  // 8-byte Folded Spill
	mov	w13, #8706                      // =0x2202
	str	x8, [sp, #24]                   // 8-byte Folded Spill
	mov	w8, #18                         // =0x12
	str	x8, [sp, #16]                   // 8-byte Folded Spill
	b	.LBB109_8
.LBB109_6:                              // %B15
	mov	w13, #4096                      // =0x1000
	mov	w8, #18                         // =0x12
	stp	x8, x12, [sp, #16]              // 16-byte Folded Spill
.LBB109_7:                              // %B11
	mov	w8, #18                         // =0x12
	str	x8, [sp, #40]                   // 8-byte Folded Spill
.LBB109_8:                              // %B11
	ldur	x1, [x20, #-8]
	orr	w3, w11, w13
	mov	x0, x24
	mov	w2, w19
	mov	x4, x10
	str	x20, [x29, #64]
	str	w13, [sp, #36]                  // 4-byte Folded Spill
	str	x20, [sp, #56]                  // 8-byte Folded Spill
	mov	w20, w19
	mov	x19, x10
	str	w11, [sp, #12]                  // 4-byte Folded Spill
	bl	js_method_set_properties_gc
	tbnz	w0, #31, .LBB109_11
// %bb.9:                               // %B6
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	ldr	w10, [sp, #12]                  // 4-byte Folded Reload
	mov	x0, x24
	ldp	x4, x5, [sp, #16]               // 16-byte Folded Reload
	mov	x1, x19
	str	x8, [x29, #64]
	ldr	w8, [sp, #36]                   // 4-byte Folded Reload
	mov	w2, w20
	ldr	x3, [sp, #40]                   // 8-byte Folded Reload
	orr	w6, w10, w8
	bl	LEPUS_DefineProperty
	tbnz	w0, #31, .LBB109_11
// %bb.10:                              // %B8
	ldr	x10, [sp, #48]                  // 8-byte Folded Reload
	ldrb	w8, [x10, #5]
	add	x19, x10, #6
	ldr	x0, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #64
	br	x0
.LBB109_11:                             // %B3
	ldp	x19, x20, [sp, #48]             // 16-byte Folded Reload
	add	sp, sp, #64
	b	exception_asm_h
.Lfunc_end109:
	.size	define_method_0_asm_h, .Lfunc_end109-define_method_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_method_computed_0_asm_h  // -- Begin function define_method_computed_0_asm_h
	.p2align	2
	.type	define_method_computed_0_asm_h,@function
define_method_computed_0_asm_h:         // @define_method_computed_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B23
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	ldr	w8, [x24, #336]
	cbz	w8, .LBB110_2
// %bb.1:                               // %B24
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB110_2:                              // %B9
	ldur	x1, [x20, #-16]
	mov	x0, x24
	str	x19, [sp, #56]                  // 8-byte Folded Spill
	str	x20, [x29, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB110_13
// %bb.3:                               // %B12
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	mov	w10, #17665                     // =0x4501
	mov	w11, #17669                     // =0x4505
	ldur	x19, [x20, #-24]
	mov	w12, w0
	ldrb	w8, [x8]
	tst	w8, #0x4
	csel	w10, w11, w10, ne
	ldur	x11, [x20, #-8]
	ands	w8, w8, #0x3
	b.eq	.LBB110_6
// %bb.4:                               // %B12
	cmp	w8, #1
	b.ne	.LBB110_7
// %bb.5:                               // %B20
	mov	w8, #18                         // =0x12
	mov	w13, #2048                      // =0x800
	stp	x11, x8, [sp, #16]              // 16-byte Folded Spill
	b	.LBB110_8
.LBB110_6:
	mov	w8, #18                         // =0x12
	str	x11, [sp, #40]                  // 8-byte Folded Spill
	mov	w13, #8706                      // =0x2202
	str	x8, [sp, #24]                   // 8-byte Folded Spill
	mov	w8, #18                         // =0x12
	str	x8, [sp, #16]                   // 8-byte Folded Spill
	b	.LBB110_9
.LBB110_7:                              // %B21
	mov	w13, #4096                      // =0x1000
	mov	w8, #18                         // =0x12
	stp	x8, x11, [sp, #16]              // 16-byte Folded Spill
.LBB110_8:                              // %B17
	mov	w8, #18                         // =0x12
	str	x8, [sp, #40]                   // 8-byte Folded Spill
.LBB110_9:                              // %B17
	ldur	x1, [x20, #-8]
	orr	w3, w10, w13
	mov	x0, x24
	mov	w2, w12
	mov	x4, x19
	str	x20, [x29, #64]
	str	w13, [sp, #36]                  // 4-byte Folded Spill
	str	x20, [sp, #48]                  // 8-byte Folded Spill
	mov	w20, w12
	str	w10, [sp, #12]                  // 4-byte Folded Spill
	bl	js_method_set_properties_gc
	tbnz	w0, #31, .LBB110_12
// %bb.10:                              // %B6
	ldp	x3, x8, [sp, #40]               // 16-byte Folded Reload
	mov	x0, x24
	ldr	w10, [sp, #12]                  // 4-byte Folded Reload
	ldp	x4, x5, [sp, #16]               // 16-byte Folded Reload
	mov	x1, x19
	mov	w2, w20
	str	x8, [x29, #64]
	ldr	w8, [sp, #36]                   // 4-byte Folded Reload
	orr	w6, w10, w8
	bl	LEPUS_DefineProperty
	tbnz	w0, #31, .LBB110_12
// %bb.11:                              // %B8
	ldr	x10, [sp, #56]                  // 8-byte Folded Reload
	ldrb	w8, [x10, #1]
	add	x19, x10, #2
	ldr	x0, [x25, x8, lsl #3]
	ldr	x8, [sp, #48]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #64
	br	x0
.LBB110_12:                             // %B3
	ldp	x20, x19, [sp, #48]             // 16-byte Folded Reload
	add	sp, sp, #64
	b	exception_asm_h
.LBB110_13:                             // %B10
	ldr	x19, [sp, #56]                  // 8-byte Folded Reload
	add	sp, sp, #64
	b	exception_asm_h
.Lfunc_end110:
	.size	define_method_computed_0_asm_h, .Lfunc_end110-define_method_computed_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_class_0_asm_h            // -- Begin function define_class_0_asm_h
	.p2align	2
	.type	define_class_0_asm_h,@function
define_class_0_asm_h:                   // @define_class_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB111_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB111_2:                              // %B2
	ldr	w2, [x19]
	ldrb	w3, [x19, #4]
	mov	x0, x24
	mov	x1, x20
	mov	x4, x26
	mov	x5, x29
	str	x20, [x29, #64]
	bl	js_op_define_class
	tbnz	w0, #31, .LBB111_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB111_4:                              // %B3
	b	exception_asm_h
.Lfunc_end111:
	.size	define_class_0_asm_h, .Lfunc_end111-define_class_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc_0_asm_h                 // -- Begin function get_loc_0_asm_h
	.p2align	2
	.type	get_loc_0_asm_h,@function
get_loc_0_asm_h:                        // @get_loc_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB112_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB112_2:                              // %B1
	ldrb	w8, [x19, #2]
	ldrh	w10, [x19], #3
	add	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	ldr	x22, [x27, x10, lsl #3]
	br	x0
.Lfunc_end112:
	.size	get_loc_0_asm_h, .Lfunc_end112-get_loc_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc_0_asm_h                 // -- Begin function put_loc_0_asm_h
	.p2align	2
	.type	put_loc_0_asm_h,@function
put_loc_0_asm_h:                        // @put_loc_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB113_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB113_2:                              // %B1
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end113:
	.size	put_loc_0_asm_h, .Lfunc_end113-put_loc_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc_0_asm_h                 // -- Begin function set_loc_0_asm_h
	.p2align	2
	.type	set_loc_0_asm_h,@function
set_loc_0_asm_h:                        // @set_loc_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB114_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB114_2:                              // %B1
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end114:
	.size	set_loc_0_asm_h, .Lfunc_end114-set_loc_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_arg_0_asm_h                 // -- Begin function get_arg_0_asm_h
	.p2align	2
	.type	get_arg_0_asm_h,@function
get_arg_0_asm_h:                        // @get_arg_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB115_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB115_2:                              // %B1
	ldrb	w8, [x19, #2]
	ldrh	w10, [x19], #3
	add	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	ldr	x22, [x28, x10, lsl #3]
	br	x0
.Lfunc_end115:
	.size	get_arg_0_asm_h, .Lfunc_end115-get_arg_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_arg_0_asm_h                 // -- Begin function put_arg_0_asm_h
	.p2align	2
	.type	put_arg_0_asm_h,@function
put_arg_0_asm_h:                        // @put_arg_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB116_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB116_2:                              // %B1
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end116:
	.size	put_arg_0_asm_h, .Lfunc_end116-put_arg_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_arg_0_asm_h                 // -- Begin function set_arg_0_asm_h
	.p2align	2
	.type	set_arg_0_asm_h,@function
set_arg_0_asm_h:                        // @set_arg_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB117_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB117_2:                              // %B1
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end117:
	.size	set_arg_0_asm_h, .Lfunc_end117-set_arg_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref_0_asm_h             // -- Begin function get_var_ref_0_asm_h
	.p2align	2
	.type	get_var_ref_0_asm_h,@function
get_var_ref_0_asm_h:                    // @get_var_ref_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB118_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB118_2:                              // %B1
	ldrh	w8, [x19]
	ldrb	w10, [x19, #2]
	add	x25, x25, #1936
	add	x19, x19, #3
	ldr	x8, [x26, x8, lsl #3]
	ldr	x0, [x25, x10, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x22, [x8]
	br	x0
.Lfunc_end118:
	.size	get_var_ref_0_asm_h, .Lfunc_end118-get_var_ref_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref_0_asm_h             // -- Begin function put_var_ref_0_asm_h
	.p2align	2
	.type	put_var_ref_0_asm_h,@function
put_var_ref_0_asm_h:                    // @put_var_ref_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB119_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB119_2:                              // %B1
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end119:
	.size	put_var_ref_0_asm_h, .Lfunc_end119-put_var_ref_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_var_ref_0_asm_h             // -- Begin function set_var_ref_0_asm_h
	.p2align	2
	.type	set_var_ref_0_asm_h,@function
set_var_ref_0_asm_h:                    // @set_var_ref_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB120_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB120_2:                              // %B1
	ldrh	w8, [x19]
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end120:
	.size	set_var_ref_0_asm_h, .Lfunc_end120-set_var_ref_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc_uninitialized_0_asm_h   // -- Begin function set_loc_uninitialized_0_asm_h
	.p2align	2
	.type	set_loc_uninitialized_0_asm_h,@function
set_loc_uninitialized_0_asm_h:          // @set_loc_uninitialized_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB121_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB121_2:                              // %B1
	ldrh	w8, [x19]
	mov	w10, #34                        // =0x22
	str	x10, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end121:
	.size	set_loc_uninitialized_0_asm_h, .Lfunc_end121-set_loc_uninitialized_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc_check_0_asm_h           // -- Begin function get_loc_check_0_asm_h
	.p2align	2
	.type	get_loc_check_0_asm_h,@function
get_loc_check_0_asm_h:                  // @get_loc_check_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB122_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB122_2:                              // %B3
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	.LBB122_4
// %bb.3:                               // %B5
	ldrb	w10, [x19, #2]
	add	x25, x25, #1936
	add	x19, x19, #3
	mov	x22, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB122_4:                              // %B4
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end122:
	.size	get_loc_check_0_asm_h, .Lfunc_end122-get_loc_check_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc_check_0_asm_h           // -- Begin function put_loc_check_0_asm_h
	.p2align	2
	.type	put_loc_check_0_asm_h,@function
put_loc_check_0_asm_h:                  // @put_loc_check_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB123_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB123_2:                              // %B3
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x10, [x27, x8, lsl #3]
	cmp	x10, #34
	b.eq	.LBB123_4
// %bb.3:                               // %B5
	str	x22, [x27, w8, uxtw #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB123_4:                              // %B4
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end123:
	.size	put_loc_check_0_asm_h, .Lfunc_end123-put_loc_check_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc_check_init_0_asm_h      // -- Begin function put_loc_check_init_0_asm_h
	.p2align	2
	.type	put_loc_check_init_0_asm_h,@function
put_loc_check_init_0_asm_h:             // @put_loc_check_init_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB124_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB124_2:                              // %B3
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x10, [x27, x8, lsl #3]
	cmp	x10, #34
	b.ne	.LBB124_4
// %bb.3:                               // %B5
	str	x22, [x27, w8, uxtw #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB124_4:                              // %B4
	b	ThrowThisReferenceError_asm_h
.Lfunc_end124:
	.size	put_loc_check_init_0_asm_h, .Lfunc_end124-put_loc_check_init_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref_check_0_asm_h       // -- Begin function get_var_ref_check_0_asm_h
	.p2align	2
	.type	get_var_ref_check_0_asm_h,@function
get_var_ref_check_0_asm_h:              // @get_var_ref_check_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB125_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB125_2:                              // %B3
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB125_4
// %bb.3:                               // %B5
	ldrb	w10, [x19, #2]
	add	x25, x25, #1936
	add	x19, x19, #3
	mov	x22, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB125_4:                              // %B4
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end125:
	.size	get_var_ref_check_0_asm_h, .Lfunc_end125-get_var_ref_check_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref_check_0_asm_h       // -- Begin function put_var_ref_check_0_asm_h
	.p2align	2
	.type	put_var_ref_check_0_asm_h,@function
put_var_ref_check_0_asm_h:              // @put_var_ref_check_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB126_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB126_2:                              // %B3
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x10, [x8]
	cmp	x10, #34
	b.eq	.LBB126_4
// %bb.3:                               // %B5
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB126_4:                              // %B4
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end126:
	.size	put_var_ref_check_0_asm_h, .Lfunc_end126-put_var_ref_check_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref_check_init_0_asm_h  // -- Begin function put_var_ref_check_init_0_asm_h
	.p2align	2
	.type	put_var_ref_check_init_0_asm_h,@function
put_var_ref_check_init_0_asm_h:         // @put_var_ref_check_init_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB127_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB127_2:                              // %B3
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x10, [x8]
	cmp	x10, #34
	b.ne	.LBB127_4
// %bb.3:                               // %B5
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB127_4:                              // %B4
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end127:
	.size	put_var_ref_check_init_0_asm_h, .Lfunc_end127-put_var_ref_check_init_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	close_loc_0_asm_h               // -- Begin function close_loc_0_asm_h
	.p2align	2
	.type	close_loc_0_asm_h,@function
close_loc_0_asm_h:                      // @close_loc_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB128_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB128_2:                              // %B1
	ldrh	w2, [x19]
	mov	x0, x24
	mov	x1, x29
	bl	close_lexical_var
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end128:
	.size	close_loc_0_asm_h, .Lfunc_end128-close_loc_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	if_false_0_asm_h                // -- Begin function if_false_0_asm_h
	.p2align	2
	.type	if_false_0_asm_h,@function
if_false_0_asm_h:                       // @if_false_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B27
	ldr	w8, [x24, #336]
	cbz	w8, .LBB129_2
// %bb.1:                               // %B28
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB129_2:                              // %B24
	mov	x10, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	.LBB129_6
// %bb.3:                               // %B24
	cmp	x22, #6
	b.eq	.LBB129_8
// %bb.4:                               // %B24
	cmp	x22, #7
	b.eq	.LBB129_11
// %bb.5:                               // %B24
	cmp	x22, #18
	b.eq	.LBB129_8
	b	.LBB129_9
.LBB129_6:                              // %B24
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB129_8
// %bb.7:                               // %B24
	cmp	x22, #2
	b.ne	.LBB129_9
.LBB129_8:                              // %B4
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB129_9:                              // %B10
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB129_15
// %bb.10:                              // %B12
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB129_12
.LBB129_11:                             // %B20
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB129_12:                             // %B14
	tst	x22, #0xfffe000000000000
	b.eq	.LBB129_15
// %bb.13:                              // %B18
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB129_8
	b.vs	.LBB129_8
// %bb.14:                              // %B18
	tbnz	w8, #0, .LBB129_11
	b	.LBB129_8
.LBB129_15:                             // %B16
	mov	x20, x10
	mov	x9, x22
	b	SlowToBoolean_asm_h
.Lfunc_end129:
	.size	if_false_0_asm_h, .Lfunc_end129-if_false_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	if_true_0_asm_h                 // -- Begin function if_true_0_asm_h
	.p2align	2
	.type	if_true_0_asm_h,@function
if_true_0_asm_h:                        // @if_true_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B27
	ldr	w8, [x24, #336]
	cbz	w8, .LBB130_2
// %bb.1:                               // %B28
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB130_2:                              // %B24
	mov	x10, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	.LBB130_6
// %bb.3:                               // %B24
	cmp	x22, #6
	b.eq	.LBB130_8
// %bb.4:                               // %B24
	cmp	x22, #7
	b.eq	.LBB130_11
// %bb.5:                               // %B24
	cmp	x22, #18
	b.eq	.LBB130_8
	b	.LBB130_9
.LBB130_6:                              // %B24
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB130_8
// %bb.7:                               // %B24
	cmp	x22, #2
	b.ne	.LBB130_9
.LBB130_8:                              // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB130_9:                              // %B10
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB130_15
// %bb.10:                              // %B12
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB130_12
.LBB130_11:                             // %B20
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB130_12:                             // %B14
	tst	x22, #0xfffe000000000000
	b.eq	.LBB130_15
// %bb.13:                              // %B18
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB130_8
	b.vs	.LBB130_8
// %bb.14:                              // %B18
	tbnz	w8, #0, .LBB130_11
	b	.LBB130_8
.LBB130_15:                             // %B16
	mov	x20, x10
	mov	x9, x22
	b	SlowToBoolean_asm_h
.Lfunc_end130:
	.size	if_true_0_asm_h, .Lfunc_end130-if_true_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	goto_0_asm_h                    // -- Begin function goto_0_asm_h
	.p2align	2
	.type	goto_0_asm_h,@function
goto_0_asm_h:                           // @goto_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB131_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB131_2:                              // %B1
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end131:
	.size	goto_0_asm_h, .Lfunc_end131-goto_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	catch_0_asm_h                   // -- Begin function catch_0_asm_h
	.p2align	2
	.type	catch_0_asm_h,@function
catch_0_asm_h:                          // @catch_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB132_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB132_2:                              // %B1
	ldr	x8, [x29, #8]
	ldrb	w11, [x19, #4]
	add	x25, x25, #1936
	ldr	w10, [x19]
	ldr	x8, [x8, #48]
	ldr	x0, [x25, x11, lsl #3]
	ldr	x8, [x8, #8]
	sub	x8, x19, x8
	add	x19, x19, #5
	add	x8, x8, x10
	mov	w10, #66                        // =0x42
	orr	x22, x10, x8, lsl #16
	br	x0
.Lfunc_end132:
	.size	catch_0_asm_h, .Lfunc_end132-catch_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	gosub_0_asm_h                   // -- Begin function gosub_0_asm_h
	.p2align	2
	.type	gosub_0_asm_h,@function
gosub_0_asm_h:                          // @gosub_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB133_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB133_2:                              // %B1
	ldr	x8, [x29, #8]
	ldrsw	x10, [x19]
	add	x25, x25, #1936
	ldr	x11, [x8, #48]
	add	x8, x19, x10
	ldr	w10, [x11, #8]
	ldrb	w11, [x8], #1
	sub	w10, w19, w10
	ldr	x0, [x25, x11, lsl #3]
	mov	x19, x8
	add	w10, w10, #4
	orr	x22, x10, #0xfffe000000000000
	br	x0
.Lfunc_end133:
	.size	gosub_0_asm_h, .Lfunc_end133-gosub_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	ret_0_asm_h                     // -- Begin function ret_0_asm_h
	.p2align	2
	.type	ret_0_asm_h,@function
ret_0_asm_h:                            // @ret_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B10
	ldr	w8, [x24, #336]
	cbz	w8, .LBB134_2
// %bb.1:                               // %B11
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB134_2:                              // %B7
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB134_5
// %bb.3:                               // %B2
	ldr	x8, [x29, #8]
	ldr	x8, [x8, #48]
	ldr	w10, [x8, #16]
	cmp	w22, w10
	b.ge	.LBB134_5
// %bb.4:                               // %B6
	ldr	x8, [x8, #8]
	sub	x20, x20, #8
	add	x19, x8, w22, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB134_5:                              // %B4
	adrp	x1, .L__unnamed_8
	add	x1, x1, :lo12:.L__unnamed_8
	mov	x0, x24
	str	x20, [x29, #64]
	bl	LEPUS_ThrowInternalError
	b	exception_asm_h
.Lfunc_end134:
	.size	ret_0_asm_h, .Lfunc_end134-ret_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	to_object_0_asm_h               // -- Begin function to_object_0_asm_h
	.p2align	2
	.type	to_object_0_asm_h,@function
to_object_0_asm_h:                      // @to_object_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB135_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB135_2:                              // %B3
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB135_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB135_4:                              // %B5
	mov	x9, x22
	b	SlowToObject_asm_h
.Lfunc_end135:
	.size	to_object_0_asm_h, .Lfunc_end135-to_object_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	to_propkey_0_asm_h              // -- Begin function to_propkey_0_asm_h
	.p2align	2
	.type	to_propkey_0_asm_h,@function
to_propkey_0_asm_h:                     // @to_propkey_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B19
	ldr	w8, [x24, #336]
	cbz	w8, .LBB136_2
// %bb.1:                               // %B20
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB136_2:                              // %B16
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	.LBB136_6
// %bb.3:                               // %B16
	mov	x10, #1                         // =0x1
	and	x8, x22, #0xffff000000000003
	movk	x10, #1, lsl #48
	add	x11, x10, #1
	cmp	x8, x11
	b.eq	.LBB136_6
// %bb.4:                               // %B16
	cmp	x8, x10
	b.eq	.LBB136_6
// %bb.5:                               // %B16
	mov	x10, #-281474976710653          // =0xffff000000000003
	cmp	x8, x10
	b.ne	.LBB136_7
.LBB136_6:                              // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB136_7:                              // %B13
	mov	x0, x24
	mov	x1, x22
	str	x20, [x29, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB136_9
// %bb.8:                               // %B15
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB136_9:                              // %B14
	b	exception_asm_h
.Lfunc_end136:
	.size	to_propkey_0_asm_h, .Lfunc_end136-to_propkey_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	to_propkey2_0_asm_h             // -- Begin function to_propkey2_0_asm_h
	.p2align	2
	.type	to_propkey2_0_asm_h,@function
to_propkey2_0_asm_h:                    // @to_propkey2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B22
	ldr	w8, [x24, #336]
	cbz	w8, .LBB137_2
// %bb.1:                               // %B23
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB137_2:                              // %B19
	ldp	x22, x21, [x20, #-16]
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	.LBB137_5
// %bb.3:                               // %B20
	adrp	x1, .L__unnamed_9
	add	x1, x1, :lo12:.L__unnamed_9
	mov	x0, x24
	str	x20, [x29, #64]
	bl	LEPUS_ThrowTypeError
.LBB137_4:                              // %B17
	b	exception_asm_h
.LBB137_5:                              // %B3
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB137_9
// %bb.6:                               // %B3
	mov	x10, #1                         // =0x1
	and	x8, x21, #0xffff000000000003
	movk	x10, #1, lsl #48
	add	x11, x10, #1
	cmp	x8, x11
	b.eq	.LBB137_9
// %bb.7:                               // %B3
	cmp	x8, x10
	b.eq	.LBB137_9
// %bb.8:                               // %B3
	mov	x10, #-281474976710653          // =0xffff000000000003
	cmp	x8, x10
	b.ne	.LBB137_10
.LBB137_9:                              // %B5
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB137_10:                             // %B16
	mov	x0, x24
	mov	x1, x21
	str	x20, [x29, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB137_4
// %bb.11:                              // %B18
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #16
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end137:
	.size	to_propkey2_0_asm_h, .Lfunc_end137-to_propkey2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_get_var_0_asm_h            // -- Begin function with_get_var_0_asm_h
	.p2align	2
	.type	with_get_var_0_asm_h,@function
with_get_var_0_asm_h:                   // @with_get_var_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB138_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB138_2:                              // %B2
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #113                        // =0x71
	str	x20, [x29, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB138_6
// %bb.3:                               // %B5
	cbz	w0, .LBB138_5
// %bb.4:                               // %B8
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB138_5:                              // %B6
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB138_6:                              // %B3
	b	exception_asm_h
.Lfunc_end138:
	.size	with_get_var_0_asm_h, .Lfunc_end138-with_get_var_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_put_var_0_asm_h            // -- Begin function with_put_var_0_asm_h
	.p2align	2
	.type	with_put_var_0_asm_h,@function
with_put_var_0_asm_h:                   // @with_put_var_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB139_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB139_2:                              // %B2
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #114                        // =0x72
	str	x20, [x29, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB139_6
// %bb.3:                               // %B5
	cbz	w0, .LBB139_5
// %bb.4:                               // %B8
	ldr	w8, [x19, #4]
	sub	x20, x20, #16
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB139_5:                              // %B6
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB139_6:                              // %B3
	b	exception_asm_h
.Lfunc_end139:
	.size	with_put_var_0_asm_h, .Lfunc_end139-with_put_var_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_delete_var_0_asm_h         // -- Begin function with_delete_var_0_asm_h
	.p2align	2
	.type	with_delete_var_0_asm_h,@function
with_delete_var_0_asm_h:                // @with_delete_var_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB140_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB140_2:                              // %B2
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #115                        // =0x73
	str	x20, [x29, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB140_6
// %bb.3:                               // %B5
	cbz	w0, .LBB140_5
// %bb.4:                               // %B8
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB140_5:                              // %B6
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB140_6:                              // %B3
	b	exception_asm_h
.Lfunc_end140:
	.size	with_delete_var_0_asm_h, .Lfunc_end140-with_delete_var_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_make_ref_0_asm_h           // -- Begin function with_make_ref_0_asm_h
	.p2align	2
	.type	with_make_ref_0_asm_h,@function
with_make_ref_0_asm_h:                  // @with_make_ref_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB141_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB141_2:                              // %B2
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #116                        // =0x74
	str	x20, [x29, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB141_6
// %bb.3:                               // %B5
	cbz	w0, .LBB141_5
// %bb.4:                               // %B8
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB141_5:                              // %B6
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB141_6:                              // %B3
	b	exception_asm_h
.Lfunc_end141:
	.size	with_make_ref_0_asm_h, .Lfunc_end141-with_make_ref_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_get_ref_0_asm_h            // -- Begin function with_get_ref_0_asm_h
	.p2align	2
	.type	with_get_ref_0_asm_h,@function
with_get_ref_0_asm_h:                   // @with_get_ref_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB142_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB142_2:                              // %B2
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #117                        // =0x75
	str	x20, [x29, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB142_6
// %bb.3:                               // %B5
	cbz	w0, .LBB142_5
// %bb.4:                               // %B8
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB142_5:                              // %B6
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB142_6:                              // %B3
	b	exception_asm_h
.Lfunc_end142:
	.size	with_get_ref_0_asm_h, .Lfunc_end142-with_get_ref_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_get_ref_undef_0_asm_h      // -- Begin function with_get_ref_undef_0_asm_h
	.p2align	2
	.type	with_get_ref_undef_0_asm_h,@function
with_get_ref_undef_0_asm_h:             // @with_get_ref_undef_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB143_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB143_2:                              // %B2
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #118                        // =0x76
	str	x20, [x29, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB143_6
// %bb.3:                               // %B5
	cbz	w0, .LBB143_5
// %bb.4:                               // %B8
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB143_5:                              // %B6
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB143_6:                              // %B3
	b	exception_asm_h
.Lfunc_end143:
	.size	with_get_ref_undef_0_asm_h, .Lfunc_end143-with_get_ref_undef_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	make_loc_ref_0_asm_h            // -- Begin function make_loc_ref_0_asm_h
	.p2align	2
	.type	make_loc_ref_0_asm_h,@function
make_loc_ref_0_asm_h:                   // @make_loc_ref_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B16
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB144_2
// %bb.1:                               // %B17
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB144_2:                              // %B13
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x29, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.eq	.LBB144_7
// %bb.3:                               // %B2
	mov	w8, #18                         // =0x12
	mov	x1, x29
	mov	w3, wzr
	stp	x0, x8, [x20], #16
	mov	x0, x24
	ldrh	w2, [x19, #4]
	str	x20, [x29, #64]
	bl	get_var_ref
	cbz	x0, .LBB144_7
// %bb.4:                               // %B7
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	mov	x8, x0
	mov	x0, x24
	mov	w3, #34                         // =0x22
	str	x20, [x29, #64]
	str	x19, [sp, #8]                   // 8-byte Folded Spill
	mov	x19, x8
	bl	add_property_gc
	mov	x8, x19
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	cbz	x0, .LBB144_7
// %bb.5:                               // %B10
	str	x8, [x0]
	mov	x0, x24
	mov	w2, wzr
	ldr	w1, [x19]
	str	x20, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB144_7
// %bb.6:                               // %B12
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.LBB144_7:                              // %B11
	add	sp, sp, #16
	b	exception_asm_h
.Lfunc_end144:
	.size	make_loc_ref_0_asm_h, .Lfunc_end144-make_loc_ref_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	make_arg_ref_0_asm_h            // -- Begin function make_arg_ref_0_asm_h
	.p2align	2
	.type	make_arg_ref_0_asm_h,@function
make_arg_ref_0_asm_h:                   // @make_arg_ref_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B16
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB145_2
// %bb.1:                               // %B17
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB145_2:                              // %B13
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x29, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.eq	.LBB145_7
// %bb.3:                               // %B2
	mov	w8, #18                         // =0x12
	mov	x1, x29
	mov	w3, #1                          // =0x1
	stp	x0, x8, [x20], #16
	mov	x0, x24
	ldrh	w2, [x19, #4]
	str	x20, [x29, #64]
	bl	get_var_ref
	cbz	x0, .LBB145_7
// %bb.4:                               // %B7
	ldur	x1, [x20, #-16]
	ldr	w2, [x19]
	mov	x8, x0
	mov	x0, x24
	mov	w3, #34                         // =0x22
	str	x20, [x29, #64]
	str	x19, [sp, #8]                   // 8-byte Folded Spill
	mov	x19, x8
	bl	add_property_gc
	mov	x8, x19
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	cbz	x0, .LBB145_7
// %bb.5:                               // %B10
	str	x8, [x0]
	mov	x0, x24
	mov	w2, wzr
	ldr	w1, [x19]
	str	x20, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB145_7
// %bb.6:                               // %B12
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.LBB145_7:                              // %B11
	add	sp, sp, #16
	b	exception_asm_h
.Lfunc_end145:
	.size	make_arg_ref_0_asm_h, .Lfunc_end145-make_arg_ref_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	make_var_ref_ref_0_asm_h        // -- Begin function make_var_ref_ref_0_asm_h
	.p2align	2
	.type	make_var_ref_ref_0_asm_h,@function
make_var_ref_ref_0_asm_h:               // @make_var_ref_ref_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B12
	ldr	w8, [x24, #336]
	cbz	w8, .LBB146_2
// %bb.1:                               // %B13
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB146_2:                              // %B9
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x29, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.eq	.LBB146_6
// %bb.3:                               // %B2
	mov	w8, #18                         // =0x12
	mov	x1, x0
	mov	w3, #34                         // =0x22
	stp	x0, x8, [x20], #16
	mov	x0, x24
	ldr	w2, [x19]
	str	x20, [x29, #64]
	bl	add_property_gc
	cbz	x0, .LBB146_6
// %bb.4:                               // %B6
	ldrh	w8, [x19, #4]
	mov	w2, wzr
	ldr	x8, [x26, x8, lsl #3]
	str	x8, [x0]
	mov	x0, x24
	ldr	w1, [x19]
	str	x20, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB146_6
// %bb.5:                               // %B8
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB146_6:                              // %B7
	b	exception_asm_h
.Lfunc_end146:
	.size	make_var_ref_ref_0_asm_h, .Lfunc_end146-make_var_ref_ref_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	make_var_ref_0_asm_h            // -- Begin function make_var_ref_0_asm_h
	.p2align	2
	.type	make_var_ref_0_asm_h,@function
make_var_ref_0_asm_h:                   // @make_var_ref_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB147_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB147_2:                              // %B2
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x20
	str	x20, [x29, #64]
	bl	JS_GetGlobalVarRef_GC
	tbnz	w0, #31, .LBB147_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB147_4:                              // %B3
	b	exception_asm_h
.Lfunc_end147:
	.size	make_var_ref_0_asm_h, .Lfunc_end147-make_var_ref_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_in_start_0_asm_h            // -- Begin function for_in_start_0_asm_h
	.p2align	2
	.type	for_in_start_0_asm_h,@function
for_in_start_0_asm_h:                   // @for_in_start_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB148_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB148_2:                              // %B2
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	bl	prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	.LBB148_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB148_4:                              // %B3
	b	exception_asm_h
.Lfunc_end148:
	.size	for_in_start_0_asm_h, .Lfunc_end148-for_in_start_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_of_start_0_asm_h            // -- Begin function for_of_start_0_asm_h
	.p2align	2
	.type	for_of_start_0_asm_h,@function
for_of_start_0_asm_h:                   // @for_of_start_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB149_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB149_2:                              // %B2
	mov	x0, x24
	mov	x1, x20
	mov	w2, wzr
	str	x20, [x29, #64]
	bl	js_for_of_start_gc
	tbnz	w0, #31, .LBB149_4
// %bb.3:                               // %B4
	mov	w8, #66                         // =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB149_4:                              // %B3
	b	exception_asm_h
.Lfunc_end149:
	.size	for_of_start_0_asm_h, .Lfunc_end149-for_of_start_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_await_of_start_0_asm_h      // -- Begin function for_await_of_start_0_asm_h
	.p2align	2
	.type	for_await_of_start_0_asm_h,@function
for_await_of_start_0_asm_h:             // @for_await_of_start_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB150_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB150_2:                              // %B2
	mov	x0, x24
	mov	x1, x20
	mov	w2, #1                          // =0x1
	str	x20, [x29, #64]
	bl	js_for_of_start_gc
	tbnz	w0, #31, .LBB150_4
// %bb.3:                               // %B4
	mov	w8, #66                         // =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB150_4:                              // %B3
	b	exception_asm_h
.Lfunc_end150:
	.size	for_await_of_start_0_asm_h, .Lfunc_end150-for_await_of_start_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_in_next_0_asm_h             // -- Begin function for_in_next_0_asm_h
	.p2align	2
	.type	for_in_next_0_asm_h,@function
for_in_next_0_asm_h:                    // @for_in_next_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB151_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB151_2:                              // %B2
	mov	x0, x24
	mov	x1, x20
	str	x20, [x29, #64]
	bl	js_for_in_next_gc
	tbnz	w0, #31, .LBB151_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB151_4:                              // %B3
	b	exception_asm_h
.Lfunc_end151:
	.size	for_in_next_0_asm_h, .Lfunc_end151-for_in_next_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_of_next_0_asm_h             // -- Begin function for_of_next_0_asm_h
	.p2align	2
	.type	for_of_next_0_asm_h,@function
for_of_next_0_asm_h:                    // @for_of_next_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB152_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB152_2:                              // %B2
	ldrb	w8, [x19]
	mov	w10, #-3                        // =0xfffffffd
	mov	x0, x24
	mov	x1, x20
	str	x20, [x29, #64]
	sub	w2, w10, w8
	bl	js_for_of_next_gc
	tbnz	w0, #31, .LBB152_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB152_4:                              // %B3
	b	exception_asm_h
.Lfunc_end152:
	.size	for_of_next_0_asm_h, .Lfunc_end152-for_of_next_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_await_of_next_0_asm_h       // -- Begin function for_await_of_next_0_asm_h
	.p2align	2
	.type	for_await_of_next_0_asm_h,@function
for_await_of_next_0_asm_h:              // @for_await_of_next_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB153_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB153_2:                              // %B2
	mov	x0, x24
	mov	x1, x20
	str	x20, [x29, #64]
	bl	js_for_await_of_next_gc
	tbnz	w0, #31, .LBB153_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB153_4:                              // %B3
	b	exception_asm_h
.Lfunc_end153:
	.size	for_await_of_next_0_asm_h, .Lfunc_end153-for_await_of_next_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	iterator_get_value_done_0_asm_h // -- Begin function iterator_get_value_done_0_asm_h
	.p2align	2
	.type	iterator_get_value_done_0_asm_h,@function
iterator_get_value_done_0_asm_h:        // @iterator_get_value_done_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB154_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB154_2:                              // %B2
	mov	x0, x24
	mov	x1, x20
	str	x20, [x29, #64]
	bl	js_iterator_get_value_done_gc
	tbnz	w0, #31, .LBB154_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB154_4:                              // %B3
	b	exception_asm_h
.Lfunc_end154:
	.size	iterator_get_value_done_0_asm_h, .Lfunc_end154-iterator_get_value_done_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	iterator_close_0_asm_h          // -- Begin function iterator_close_0_asm_h
	.p2align	2
	.type	iterator_close_0_asm_h,@function
iterator_close_0_asm_h:                 // @iterator_close_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B10
	ldr	w8, [x24, #336]
	cbz	w8, .LBB155_2
// %bb.1:                               // %B11
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB155_2:                              // %B7
	ldur	x1, [x20, #-24]
	sub	x20, x20, #16
	cmp	x1, #18
	b.eq	.LBB155_4
// %bb.3:                               // %B2
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x29, #64]
	bl	JS_IteratorClose
	tbnz	w0, #31, .LBB155_5
.LBB155_4:                              // %B5
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB155_5:                              // %B3
	b	exception_asm_h
.Lfunc_end155:
	.size	iterator_close_0_asm_h, .Lfunc_end155-iterator_close_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	iterator_close_return_0_asm_h   // -- Begin function iterator_close_return_0_asm_h
	.p2align	2
	.type	iterator_close_return_0_asm_h,@function
iterator_close_return_0_asm_h:          // @iterator_close_return_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B14
	ldr	w8, [x24, #336]
	cbz	w8, .LBB156_2
// %bb.1:                               // %B15
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB156_2:                              // %B1
	ldr	x8, [x29, #8]
	mov	w11, #247                       // =0xf7
	ldr	x8, [x8, #48]
	ldrh	w10, [x8, #42]
	ldr	x8, [x20, #-8]!
	add	x10, x27, x10, lsl #3
	b	.LBB156_4
.LBB156_3:                              // %B11
                                        //   in Loop: Header=BB156_4 Depth=1
	sub	x20, x20, #8
.LBB156_4:                              // %B3
                                        // =>This Inner Loop Header: Depth=1
	cmp	x20, x10
	b.le	.LBB156_7
// %bb.5:                               // %B5
                                        //   in Loop: Header=BB156_4 Depth=1
	ldur	x12, [x20, #-8]
	tst	x12, #0xffff000000000000
	b.ne	.LBB156_3
// %bb.6:                               // %B5
                                        //   in Loop: Header=BB156_4 Depth=1
	and	x12, x12, x11
	cmp	x12, #66
	b.ne	.LBB156_3
.LBB156_7:                              // %B8
	add	x10, x10, #24
	cmp	x20, x10
	add	x20, x20, #8
	b.lt	.LBB156_9
// %bb.8:                               // %B10
	ldur	x10, [x20, #-16]
	ldur	q0, [x20, #-32]
	stur	x8, [x20, #-32]
	stur	x10, [x20, #-8]
	stur	q0, [x20, #-24]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB156_9:                              // %B9
	adrp	x1, .L__unnamed_10
	add	x1, x1, :lo12:.L__unnamed_10
	mov	x0, x24
	str	x20, [x29, #64]
	bl	LEPUS_ThrowInternalError
	b	exception_asm_h
.Lfunc_end156:
	.size	iterator_close_return_0_asm_h, .Lfunc_end156-iterator_close_return_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	async_iterator_close_0_asm_h    // -- Begin function async_iterator_close_0_asm_h
	.p2align	2
	.type	async_iterator_close_0_asm_h,@function
async_iterator_close_0_asm_h:           // @async_iterator_close_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB157_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB157_2:                              // %B2
	mov	x0, x24
	mov	x1, x20
	str	x20, [x29, #64]
	bl	prim_js_async_iterator_close_gc
	tbnz	w0, #31, .LBB157_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB157_4:                              // %B3
	b	exception_asm_h
.Lfunc_end157:
	.size	async_iterator_close_0_asm_h, .Lfunc_end157-async_iterator_close_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	async_iterator_next_0_asm_h     // -- Begin function async_iterator_next_0_asm_h
	.p2align	2
	.type	async_iterator_next_0_asm_h,@function
async_iterator_next_0_asm_h:            // @async_iterator_next_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB158_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB158_2:                              // %B2
	ldp	x2, x1, [x20, #-32]
	sub	x4, x20, #8
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x29, #64]
	bl	LEPUS_Call
	cmp	x0, #130
	b.eq	.LBB158_4
// %bb.3:                               // %B4
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB158_4:                              // %B3
	b	exception_asm_h
.Lfunc_end158:
	.size	async_iterator_next_0_asm_h, .Lfunc_end158-async_iterator_next_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	async_iterator_get_0_asm_h      // -- Begin function async_iterator_get_0_asm_h
	.p2align	2
	.type	async_iterator_get_0_asm_h,@function
async_iterator_get_0_asm_h:             // @async_iterator_get_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB159_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB159_2:                              // %B2
	ldrb	w2, [x19]
	mov	x0, x24
	mov	x1, x20
	str	x20, [x29, #64]
	bl	prim_js_async_iterator_get_gc
	tbnz	w0, #31, .LBB159_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB159_4:                              // %B3
	b	exception_asm_h
.Lfunc_end159:
	.size	async_iterator_get_0_asm_h, .Lfunc_end159-async_iterator_get_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	initial_yield_0_asm_h           // -- Begin function initial_yield_0_asm_h
	.p2align	2
	.type	initial_yield_0_asm_h,@function
initial_yield_0_asm_h:                  // @initial_yield_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	ldr	w8, [x24, #336]
	cbz	w8, .LBB160_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB160_2:                              // %B4
	ldr	x1, [x29, #112]
	add	x10, x29, #32
	str	x19, [x1, #48]
	str	x20, [x1, #64]
	ldr	x8, [x29, #40]
	cmp	x8, x10
	b.eq	.LBB160_4
// %bb.3:                               // %B6
	mov	x0, x29
	bl	prim_copy_var_refs_gc
.LBB160_4:                              // %B2
	mov	w27, #18                        // =0x12
	b	common_return_direct_asm_h
.Lfunc_end160:
	.size	initial_yield_0_asm_h, .Lfunc_end160-initial_yield_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	yield_0_asm_h                   // -- Begin function yield_0_asm_h
	.p2align	2
	.type	yield_0_asm_h,@function
yield_0_asm_h:                          // @yield_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	ldr	w8, [x24, #336]
	cbz	w8, .LBB161_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB161_2:                              // %B4
	ldr	x1, [x29, #112]
	add	x10, x29, #32
	str	x19, [x1, #48]
	str	x20, [x1, #64]
	ldr	x8, [x29, #40]
	cmp	x8, x10
	b.eq	.LBB161_4
// %bb.3:                               // %B6
	mov	x0, x29
	bl	prim_copy_var_refs_gc
.LBB161_4:                              // %B2
	mov	x27, #-562949953421311          // =0xfffe000000000001
	b	common_return_direct_asm_h
.Lfunc_end161:
	.size	yield_0_asm_h, .Lfunc_end161-yield_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	yield_star_0_asm_h              // -- Begin function yield_star_0_asm_h
	.p2align	2
	.type	yield_star_0_asm_h,@function
yield_star_0_asm_h:                     // @yield_star_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	ldr	w8, [x24, #336]
	cbz	w8, .LBB162_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB162_2:                              // %B4
	ldr	x1, [x29, #112]
	add	x10, x29, #32
	str	x19, [x1, #48]
	str	x20, [x1, #64]
	ldr	x8, [x29, #40]
	cmp	x8, x10
	b.eq	.LBB162_4
// %bb.3:                               // %B6
	mov	x0, x29
	bl	prim_copy_var_refs_gc
.LBB162_4:                              // %B2
	mov	x27, #2                         // =0x2
	movk	x27, #65534, lsl #48
	b	common_return_direct_asm_h
.Lfunc_end162:
	.size	yield_star_0_asm_h, .Lfunc_end162-yield_star_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	async_yield_star_0_asm_h        // -- Begin function async_yield_star_0_asm_h
	.p2align	2
	.type	async_yield_star_0_asm_h,@function
async_yield_star_0_asm_h:               // @async_yield_star_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	ldr	w8, [x24, #336]
	cbz	w8, .LBB163_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB163_2:                              // %B4
	ldr	x1, [x29, #112]
	add	x10, x29, #32
	str	x19, [x1, #48]
	str	x20, [x1, #64]
	ldr	x8, [x29, #40]
	cmp	x8, x10
	b.eq	.LBB163_4
// %bb.3:                               // %B6
	mov	x0, x29
	bl	prim_copy_var_refs_gc
.LBB163_4:                              // %B2
	mov	x27, #2                         // =0x2
	movk	x27, #65534, lsl #48
	b	common_return_direct_asm_h
.Lfunc_end163:
	.size	async_yield_star_0_asm_h, .Lfunc_end163-async_yield_star_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	await_0_asm_h                   // -- Begin function await_0_asm_h
	.p2align	2
	.type	await_0_asm_h,@function
await_0_asm_h:                          // @await_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	ldr	w8, [x24, #336]
	cbz	w8, .LBB164_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB164_2:                              // %B4
	ldr	x1, [x29, #112]
	add	x10, x29, #32
	str	x19, [x1, #48]
	str	x20, [x1, #64]
	ldr	x8, [x29, #40]
	cmp	x8, x10
	b.eq	.LBB164_4
// %bb.3:                               // %B6
	mov	x0, x29
	bl	prim_copy_var_refs_gc
.LBB164_4:                              // %B2
	mov	x27, #-562949953421312          // =0xfffe000000000000
	b	common_return_direct_asm_h
.Lfunc_end164:
	.size	await_0_asm_h, .Lfunc_end164-await_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	neg_0_asm_h                     // -- Begin function neg_0_asm_h
	.p2align	2
	.type	neg_0_asm_h,@function
neg_0_asm_h:                            // @neg_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B23
	ldr	w8, [x24, #336]
	cbz	w8, .LBB165_2
// %bb.1:                               // %B24
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB165_2:                              // %B20
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB165_5
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB165_8
// %bb.4:                               // %B14
	orr	w8, w22, #0x80000000
	mov	w10, #-2147483648               // =0x80000000
	cmp	w8, w10
	b.ne	.LBB165_7
.LBB165_5:                              // %B17
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        // =0x8c
	str	x20, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB165_10
// %bb.6:                               // %B19
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB165_7:                              // %B16
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB165_8:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB165_5
// %bb.9:                               // %B8
	movi	d0, #0000000000000000
	add	x8, x22, x8
	add	x25, x25, #1936
	fmov	d1, x8
	ldrb	w8, [x19], #1
	mov	x11, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fsub	d0, d0, d1
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB165_10:                             // %B18
	b	exception_asm_h
.Lfunc_end165:
	.size	neg_0_asm_h, .Lfunc_end165-neg_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	plus_0_asm_h                    // -- Begin function plus_0_asm_h
	.p2align	2
	.type	plus_0_asm_h,@function
plus_0_asm_h:                           // @plus_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B17
	ldr	w8, [x24, #336]
	cbz	w8, .LBB166_2
// %bb.1:                               // %B18
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB166_2:                              // %B14
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB166_6
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB166_5
.LBB166_4:                              // %B8
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB166_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.ne	.LBB166_4
.LBB166_6:                              // %B11
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        // =0x8d
	str	x20, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB166_8
// %bb.7:                               // %B13
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB166_8:                              // %B12
	b	exception_asm_h
.Lfunc_end166:
	.size	plus_0_asm_h, .Lfunc_end166-plus_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dec_0_asm_h                     // -- Begin function dec_0_asm_h
	.p2align	2
	.type	dec_0_asm_h,@function
dec_0_asm_h:                            // @dec_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B23
	ldr	w8, [x24, #336]
	cbz	w8, .LBB167_2
// %bb.1:                               // %B24
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB167_2:                              // %B20
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB167_8
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB167_6
// %bb.4:                               // %B14
	subs	w8, w22, #1
	b.vs	.LBB167_8
// %bb.5:                               // %B16
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB167_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB167_8
// %bb.7:                               // %B8
	add	x8, x22, x8
	fmov	d0, #-1.00000000
	add	x25, x25, #1936
	fmov	d1, x8
	ldrb	w8, [x19], #1
	mov	x11, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB167_8:                              // %B17
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        // =0x8e
	str	x20, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB167_10
// %bb.9:                               // %B19
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB167_10:                             // %B18
	b	exception_asm_h
.Lfunc_end167:
	.size	dec_0_asm_h, .Lfunc_end167-dec_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	inc_0_asm_h                     // -- Begin function inc_0_asm_h
	.p2align	2
	.type	inc_0_asm_h,@function
inc_0_asm_h:                            // @inc_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B23
	ldr	w8, [x24, #336]
	cbz	w8, .LBB168_2
// %bb.1:                               // %B24
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB168_2:                              // %B20
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB168_8
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB168_6
// %bb.4:                               // %B14
	adds	w8, w22, #1
	b.vs	.LBB168_8
// %bb.5:                               // %B16
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB168_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB168_8
// %bb.7:                               // %B8
	add	x8, x22, x8
	fmov	d0, #1.00000000
	add	x25, x25, #1936
	fmov	d1, x8
	ldrb	w8, [x19], #1
	mov	x11, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB168_8:                              // %B17
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        // =0x8f
	str	x20, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB168_10
// %bb.9:                               // %B19
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB168_10:                             // %B18
	b	exception_asm_h
.Lfunc_end168:
	.size	inc_0_asm_h, .Lfunc_end168-inc_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	post_dec_0_asm_h                // -- Begin function post_dec_0_asm_h
	.p2align	2
	.type	post_dec_0_asm_h,@function
post_dec_0_asm_h:                       // @post_dec_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B20
	ldr	w8, [x24, #336]
	cbz	w8, .LBB169_2
// %bb.1:                               // %B21
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB169_2:                              // %B17
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB169_8
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB169_6
// %bb.4:                               // %B14
	subs	w8, w22, #1
	b.vs	.LBB169_8
// %bb.5:                               // %B16
	ldrb	w10, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB169_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB169_8
// %bb.7:                               // %B9
	add	x8, x22, x8
	fmov	d0, #-1.00000000
	add	x25, x25, #3872
	fmov	d1, x8
	ldrb	w8, [x19], #1
	mov	x11, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	csel	x21, x10, x8, vc
	br	x0
.LBB169_8:                              // %B6
	mov	w9, #144                        // =0x90
	b	SlowJSPostInc_asm_h
.Lfunc_end169:
	.size	post_dec_0_asm_h, .Lfunc_end169-post_dec_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	post_inc_0_asm_h                // -- Begin function post_inc_0_asm_h
	.p2align	2
	.type	post_inc_0_asm_h,@function
post_inc_0_asm_h:                       // @post_inc_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B20
	ldr	w8, [x24, #336]
	cbz	w8, .LBB170_2
// %bb.1:                               // %B21
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB170_2:                              // %B17
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB170_8
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB170_6
// %bb.4:                               // %B14
	adds	w8, w22, #1
	b.vs	.LBB170_8
// %bb.5:                               // %B16
	ldrb	w10, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB170_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB170_8
// %bb.7:                               // %B9
	add	x8, x22, x8
	fmov	d0, #1.00000000
	add	x25, x25, #3872
	fmov	d1, x8
	ldrb	w8, [x19], #1
	mov	x11, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	csel	x21, x10, x8, vc
	br	x0
.LBB170_8:                              // %B6
	mov	w9, #145                        // =0x91
	b	SlowJSPostInc_asm_h
.Lfunc_end170:
	.size	post_inc_0_asm_h, .Lfunc_end170-post_inc_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dec_loc_0_asm_h                 // -- Begin function dec_loc_0_asm_h
	.p2align	2
	.type	dec_loc_0_asm_h,@function
dec_loc_0_asm_h:                        // @dec_loc_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B23
	ldr	w8, [x24, #336]
	cbz	w8, .LBB171_2
// %bb.1:                               // %B24
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB171_2:                              // %B20
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	b.hi	.LBB171_8
// %bb.3:                               // %B3
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB171_6
// %bb.4:                               // %B14
	subs	w10, w1, #1
	b.vs	.LBB171_8
// %bb.5:                               // %B16
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB171_6:                              // %B5
	tst	x1, #0xfffe000000000000
	b.eq	.LBB171_8
// %bb.7:                               // %B9
	add	x10, x1, x10
	fmov	d0, #-1.00000000
	mov	x11, #562949953421312           // =0x2000000000000
	fmov	d1, x10
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	mov	x11, #9221120237041090560       // =0x7ff8000000000000
	csel	x10, x10, x11, vc
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB171_8:                              // %B17
	mov	x0, x24
	mov	w2, #142                        // =0x8e
	str	x20, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB171_10
// %bb.9:                               // %B19
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB171_10:                             // %B18
	b	exception_asm_h
.Lfunc_end171:
	.size	dec_loc_0_asm_h, .Lfunc_end171-dec_loc_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	inc_loc_0_asm_h                 // -- Begin function inc_loc_0_asm_h
	.p2align	2
	.type	inc_loc_0_asm_h,@function
inc_loc_0_asm_h:                        // @inc_loc_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B23
	ldr	w8, [x24, #336]
	cbz	w8, .LBB172_2
// %bb.1:                               // %B24
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB172_2:                              // %B20
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	b.hi	.LBB172_8
// %bb.3:                               // %B3
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB172_6
// %bb.4:                               // %B14
	adds	w10, w1, #1
	b.vs	.LBB172_8
// %bb.5:                               // %B16
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB172_6:                              // %B5
	tst	x1, #0xfffe000000000000
	b.eq	.LBB172_8
// %bb.7:                               // %B9
	add	x10, x1, x10
	fmov	d0, #1.00000000
	mov	x11, #562949953421312           // =0x2000000000000
	fmov	d1, x10
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	mov	x11, #9221120237041090560       // =0x7ff8000000000000
	csel	x10, x10, x11, vc
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB172_8:                              // %B17
	mov	x0, x24
	mov	w2, #143                        // =0x8f
	str	x20, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB172_10
// %bb.9:                               // %B19
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB172_10:                             // %B18
	b	exception_asm_h
.Lfunc_end172:
	.size	inc_loc_0_asm_h, .Lfunc_end172-inc_loc_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	add_loc_0_asm_h                 // -- Begin function add_loc_0_asm_h
	.p2align	2
	.type	add_loc_0_asm_h,@function
add_loc_0_asm_h:                        // @add_loc_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B49
	ldr	w8, [x24, #336]
	cbz	w8, .LBB173_2
// %bb.1:                               // %B50
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB173_2:                              // %B46
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldur	x22, [x20, #-8]
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	b.hi	.LBB173_17
// %bb.3:                               // %B46
	cmp	x22, x10
	b.hi	.LBB173_17
// %bb.4:                               // %B3
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB173_8
// %bb.5:                               // %B27
	cmp	x22, x10
	b.lo	.LBB173_11
// %bb.6:                               // %B37
	adds	w10, w1, w22
	b.vs	.LBB173_17
// %bb.7:                               // %B39
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB173_8:                              // %B5
	tst	x1, #0xfffe000000000000
	b.eq	.LBB173_17
// %bb.9:                               // %B12
	cmp	x22, x10
	b.lo	.LBB173_15
// %bb.10:                              // %B22
	scvtf	d0, w22
	add	x10, x1, x10
	fmov	d1, x10
	fadd	d0, d1, d0
	b	.LBB173_14
.LBB173_11:                             // %B29
	tst	x22, #0xfffe000000000000
	b.eq	.LBB173_17
// %bb.12:                              // %B32
	scvtf	d0, w1
	add	x10, x22, x10
.LBB173_13:                             // %B32
	fmov	d1, x10
	fadd	d0, d0, d1
.LBB173_14:                             // %B32
	fmov	x10, d0
	fcmp	d0, d0
	mov	x11, #562949953421312           // =0x2000000000000
	add	x10, x10, x11
	mov	x11, #9221120237041090560       // =0x7ff8000000000000
	csel	x10, x10, x11, vc
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB173_15:                             // %B14
	tst	x22, #0xfffe000000000000
	b.eq	.LBB173_17
// %bb.16:                              // %B17
	add	x11, x1, x10
	add	x10, x22, x10
	fmov	d0, x11
	b	.LBB173_13
.LBB173_17:                             // %B8
	mov	x8, #2                          // =0x2
	and	x10, x1, #0xffff000000000003
	str	x20, [x29, #64]
	movk	x8, #1, lsl #48
	cmp	x10, x8
	b.ne	.LBB173_20
// %bb.18:                              // %B8
	and	x10, x22, #0xffff000000000003
	cmp	x10, x8
	b.ne	.LBB173_20
// %bb.19:                              // %B40
	mov	x0, x24
	mov	x2, x22
	bl	JS_ConcatString_GC
	b	.LBB173_21
.LBB173_20:                             // %B43
	mov	x0, x24
	mov	x2, x22
	bl	prim_js_add_slow_gc
.LBB173_21:                             // %B43
	cmp	x0, #130
	b.eq	.LBB173_23
// %bb.22:                              // %B45
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB173_23:                             // %B44
	b	exception_asm_h
.Lfunc_end173:
	.size	add_loc_0_asm_h, .Lfunc_end173-add_loc_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	not_0_asm_h                     // -- Begin function not_0_asm_h
	.p2align	2
	.type	not_0_asm_h,@function
not_0_asm_h:                            // @not_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB174_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB174_2:                              // %B3
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB174_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB174_4:                              // %B5
	mov	x9, x22
	b	SlowJSNot_asm_h
.Lfunc_end174:
	.size	not_0_asm_h, .Lfunc_end174-not_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	lnot_0_asm_h                    // -- Begin function lnot_0_asm_h
	.p2align	2
	.type	lnot_0_asm_h,@function
lnot_0_asm_h:                           // @lnot_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B18
	ldr	w8, [x24, #336]
	cbz	w8, .LBB175_2
// %bb.1:                               // %B19
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB175_2:                              // %B15
	ldur	x22, [x20, #-8]
	cmp	x22, #5
	b.le	.LBB175_6
// %bb.3:                               // %B15
	cmp	x22, #6
	b.eq	.LBB175_8
// %bb.4:                               // %B15
	cmp	x22, #7
	b.eq	.LBB175_10
// %bb.5:                               // %B15
	cmp	x22, #18
	b.eq	.LBB175_8
	b	.LBB175_9
.LBB175_6:                              // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB175_8
// %bb.7:                               // %B15
	cmp	x22, #2
	b.ne	.LBB175_9
.LBB175_8:                              // %B4
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB175_9:                              // %B11
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB175_11
.LBB175_10:                             // %B13
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB175_11:                             // %B14
	mov	x9, x22
	b	SlowToBoolean_asm_h
.Lfunc_end175:
	.size	lnot_0_asm_h, .Lfunc_end175-lnot_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	typeof_0_asm_h                  // -- Begin function typeof_0_asm_h
	.p2align	2
	.type	typeof_0_asm_h,@function
typeof_0_asm_h:                         // @typeof_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB176_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB176_2:                              // %B2
	ldur	x22, [x20, #-8]
	mov	x0, x24
	mov	x1, x22
	bl	js_operator_typeof_gc
	mov	w1, w0
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x20, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB176_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB176_4:                              // %B3
	b	exception_asm_h
.Lfunc_end176:
	.size	typeof_0_asm_h, .Lfunc_end176-typeof_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	delete_0_asm_h                  // -- Begin function delete_0_asm_h
	.p2align	2
	.type	delete_0_asm_h,@function
delete_0_asm_h:                         // @delete_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB177_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB177_2:                              // %B2
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	.LBB177_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB177_4:                              // %B3
	b	exception_asm_h
.Lfunc_end177:
	.size	delete_0_asm_h, .Lfunc_end177-delete_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	delete_var_0_asm_h              // -- Begin function delete_var_0_asm_h
	.p2align	2
	.type	delete_var_0_asm_h,@function
delete_var_0_asm_h:                     // @delete_var_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB178_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB178_2:                              // %B2
	ldr	w2, [x19]
	ldr	x1, [x24, #224]
	mov	x0, x24
	mov	w3, wzr
	str	x20, [x29, #64]
	bl	LEPUS_DeleteProperty
	tbnz	w0, #31, .LBB178_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	cmp	w0, #0
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x0
.LBB178_4:                              // %B3
	b	exception_asm_h
.Lfunc_end178:
	.size	delete_var_0_asm_h, .Lfunc_end178-delete_var_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	mul_0_asm_h                     // -- Begin function mul_0_asm_h
	.p2align	2
	.type	mul_0_asm_h,@function
mul_0_asm_h:                            // @mul_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B51
	ldr	w8, [x24, #336]
	cbz	w8, .LBB179_2
// %bb.1:                               // %B52
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB179_2:                              // %B48
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB179_20
// %bb.3:                               // %B48
	cmp	x21, x8
	b.hi	.LBB179_20
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB179_10
// %bb.5:                               // %B24
	cmp	x21, x8
	b.lo	.LBB179_13
// %bb.6:                               // %B34
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	.LBB179_20
// %bb.7:                               // %B37
	cbnz	w8, .LBB179_9
// %bb.8:                               // %B37
	orr	w10, w22, w21
	tbnz	w10, #31, .LBB179_17
.LBB179_9:                              // %B44
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB179_10:                             // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB179_20
// %bb.11:                              // %B8
	cmp	x21, x8
	b.lo	.LBB179_18
// %bb.12:                              // %B19
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	.LBB179_16
.LBB179_13:                             // %B26
	tst	x21, #0xfffe000000000000
	b.eq	.LBB179_20
// %bb.14:                              // %B29
	scvtf	d0, w22
	add	x8, x21, x8
.LBB179_15:                             // %B29
	fmov	d1, x8
	fmul	d0, d0, d1
.LBB179_16:                             // %B29
	ldrb	w8, [x19], #1
	fmov	x10, d0
	fcmp	d0, d0
	add	x25, x25, #1936
	mov	x11, #562949953421312           // =0x2000000000000
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #16
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB179_17:                             // %B41
	mov	x22, #-9222809086901354496      // =0x8002000000000000
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB179_18:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB179_20
// %bb.19:                              // %B13
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB179_15
.LBB179_20:                             // %B45
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        // =0x9a
	str	x20, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB179_22
// %bb.21:                              // %B47
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB179_22:                             // %B46
	b	exception_asm_h
.Lfunc_end179:
	.size	mul_0_asm_h, .Lfunc_end179-mul_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	div_0_asm_h                     // -- Begin function div_0_asm_h
	.p2align	2
	.type	div_0_asm_h,@function
div_0_asm_h:                            // @div_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B48
	ldr	w8, [x24, #336]
	cbz	w8, .LBB180_2
// %bb.1:                               // %B49
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB180_2:                              // %B45
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB180_16
// %bb.3:                               // %B45
	cmp	x21, x8
	b.hi	.LBB180_16
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB180_7
// %bb.5:                               // %B24
	cmp	x21, x8
	b.lo	.LBB180_10
// %bb.6:                               // %B34
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w13, [x19], #1
	add	x25, x25, #1936
	mov	x11, #9221120237041090560       // =0x7ff8000000000000
	sub	x20, x20, #16
	ldr	x0, [x25, x13, lsl #3]
	fdiv	d0, d0, d1
	fcvtzs	w8, d0
	fmov	x12, d0
	fcmp	d0, d0
	add	x10, x12, x10
	csel	x10, x10, x11, vc
	cmp	x8, x12
	orr	x8, x8, #0xfffe000000000000
	csel	x22, x10, x8, ne
	br	x0
.LBB180_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB180_16
// %bb.8:                               // %B8
	cmp	x21, x8
	b.lo	.LBB180_14
// %bb.9:                               // %B19
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	.LBB180_13
.LBB180_10:                             // %B26
	tst	x21, #0xfffe000000000000
	b.eq	.LBB180_16
// %bb.11:                              // %B29
	scvtf	d0, w22
	add	x8, x21, x8
.LBB180_12:                             // %B29
	fmov	d1, x8
	fdiv	d0, d0, d1
.LBB180_13:                             // %B29
	ldrb	w8, [x19], #1
	fmov	x10, d0
	fcmp	d0, d0
	add	x25, x25, #1936
	mov	x11, #562949953421312           // =0x2000000000000
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #16
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB180_14:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB180_16
// %bb.15:                              // %B13
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB180_12
.LBB180_16:                             // %B42
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        // =0x9b
	str	x20, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB180_18
// %bb.17:                              // %B44
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB180_18:                             // %B43
	b	exception_asm_h
.Lfunc_end180:
	.size	div_0_asm_h, .Lfunc_end180-div_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	mod_0_asm_h                     // -- Begin function mod_0_asm_h
	.p2align	2
	.type	mod_0_asm_h,@function
mod_0_asm_h:                            // @mod_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B43
	ldr	w8, [x24, #336]
	cbz	w8, .LBB181_2
// %bb.1:                               // %B44
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB181_2:                              // %B40
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB181_18
// %bb.3:                               // %B40
	cmp	x21, x8
	b.hi	.LBB181_18
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB181_9
// %bb.5:                               // %B24
	cmp	x21, x8
	b.lo	.LBB181_12
// %bb.6:                               // %B34
	tbnz	w22, #31, .LBB181_18
// %bb.7:                               // %B34
	cmp	w21, #1
	b.lt	.LBB181_18
// %bb.8:                               // %B36
	sdiv	w8, w22, w21
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x10, lsl #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB181_9:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB181_18
// %bb.10:                              // %B8
	cmp	x21, x8
	b.lo	.LBB181_16
// %bb.11:                              // %B19
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	.LBB181_15
.LBB181_12:                             // %B26
	tst	x21, #0xfffe000000000000
	b.eq	.LBB181_18
// %bb.13:                              // %B29
	scvtf	d0, w22
	add	x8, x21, x8
.LBB181_14:                             // %B29
	fmov	d1, x8
.LBB181_15:                             // %B29
	bl	fmod
	ldrb	w8, [x19], #1
	fmov	x10, d0
	fcmp	d0, d0
	add	x25, x25, #1936
	mov	x11, #562949953421312           // =0x2000000000000
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #16
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB181_16:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB181_18
// %bb.17:                              // %B13
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB181_14
.LBB181_18:                             // %B37
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        // =0x9c
	str	x20, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB181_20
// %bb.19:                              // %B39
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB181_20:                             // %B38
	b	exception_asm_h
.Lfunc_end181:
	.size	mod_0_asm_h, .Lfunc_end181-mod_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	add_0_asm_h                     // -- Begin function add_0_asm_h
	.p2align	2
	.type	add_0_asm_h,@function
add_0_asm_h:                            // @add_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B49
	ldr	w8, [x24, #336]
	cbz	w8, .LBB182_2
// %bb.1:                               // %B50
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB182_2:                              // %B46
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB182_17
// %bb.3:                               // %B46
	cmp	x21, x8
	b.hi	.LBB182_17
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB182_8
// %bb.5:                               // %B27
	cmp	x21, x8
	b.lo	.LBB182_11
// %bb.6:                               // %B37
	adds	w8, w22, w21
	b.vs	.LBB182_17
// %bb.7:                               // %B39
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB182_8:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB182_17
// %bb.9:                               // %B11
	cmp	x21, x8
	b.lo	.LBB182_15
// %bb.10:                              // %B22
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	.LBB182_14
.LBB182_11:                             // %B29
	tst	x21, #0xfffe000000000000
	b.eq	.LBB182_17
// %bb.12:                              // %B32
	scvtf	d0, w22
	add	x8, x21, x8
.LBB182_13:                             // %B32
	fmov	d1, x8
	fadd	d0, d0, d1
.LBB182_14:                             // %B32
	ldrb	w8, [x19], #1
	fmov	x10, d0
	fcmp	d0, d0
	add	x25, x25, #1936
	mov	x11, #562949953421312           // =0x2000000000000
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #16
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB182_15:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB182_17
// %bb.16:                              // %B16
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB182_13
.LBB182_17:                             // %B7
	mov	x8, #2                          // =0x2
	and	x10, x22, #0xffff000000000003
	str	x20, [x29, #64]
	movk	x8, #1, lsl #48
	cmp	x10, x8
	b.ne	.LBB182_20
// %bb.18:                              // %B7
	and	x10, x21, #0xffff000000000003
	cmp	x10, x8
	b.ne	.LBB182_20
// %bb.19:                              // %B40
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	JS_ConcatString_GC
	b	.LBB182_21
.LBB182_20:                             // %B43
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_add_slow_gc
.LBB182_21:                             // %B43
	cmp	x0, #130
	b.eq	.LBB182_23
// %bb.22:                              // %B45
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB182_23:                             // %B44
	b	exception_asm_h
.Lfunc_end182:
	.size	add_0_asm_h, .Lfunc_end182-add_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	sub_0_asm_h                     // -- Begin function sub_0_asm_h
	.p2align	2
	.type	sub_0_asm_h,@function
sub_0_asm_h:                            // @sub_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B43
	ldr	w8, [x24, #336]
	cbz	w8, .LBB183_2
// %bb.1:                               // %B44
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB183_2:                              // %B40
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB183_17
// %bb.3:                               // %B40
	cmp	x21, x8
	b.hi	.LBB183_17
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB183_8
// %bb.5:                               // %B24
	cmp	x21, x8
	b.lo	.LBB183_11
// %bb.6:                               // %B34
	subs	w8, w22, w21
	b.vs	.LBB183_17
// %bb.7:                               // %B36
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB183_8:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB183_17
// %bb.9:                               // %B8
	cmp	x21, x8
	b.lo	.LBB183_15
// %bb.10:                              // %B19
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	.LBB183_14
.LBB183_11:                             // %B26
	tst	x21, #0xfffe000000000000
	b.eq	.LBB183_17
// %bb.12:                              // %B29
	scvtf	d0, w22
	add	x8, x21, x8
.LBB183_13:                             // %B29
	fmov	d1, x8
	fsub	d0, d0, d1
.LBB183_14:                             // %B29
	ldrb	w8, [x19], #1
	fmov	x10, d0
	fcmp	d0, d0
	add	x25, x25, #1936
	mov	x11, #562949953421312           // =0x2000000000000
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #16
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB183_15:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB183_17
// %bb.16:                              // %B13
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB183_13
.LBB183_17:                             // %B37
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        // =0x9e
	str	x20, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB183_19
// %bb.18:                              // %B39
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB183_19:                             // %B38
	b	exception_asm_h
.Lfunc_end183:
	.size	sub_0_asm_h, .Lfunc_end183-sub_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	pow_0_asm_h                     // -- Begin function pow_0_asm_h
	.p2align	2
	.type	pow_0_asm_h,@function
pow_0_asm_h:                            // @pow_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB184_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB184_2:                              // %B2
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w3, #159                        // =0x9f
	str	x20, [x29, #64]
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB184_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB184_4:                              // %B3
	b	exception_asm_h
.Lfunc_end184:
	.size	pow_0_asm_h, .Lfunc_end184-pow_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	shl_0_asm_h                     // -- Begin function shl_0_asm_h
	.p2align	2
	.type	shl_0_asm_h,@function
shl_0_asm_h:                            // @shl_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B32
	ldr	w8, [x24, #336]
	cbz	w8, .LBB185_2
// %bb.1:                               // %B33
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB185_2:                              // %B29
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB185_12
// %bb.3:                               // %B29
	cmp	x21, x8
	b.hi	.LBB185_12
// %bb.4:                               // %B3
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB185_8
// %bb.5:                               // %B20
	cmp	x21, x8
	b.lo	.LBB185_12
// %bb.6:                               // %B25
	mov	w8, w22
.LBB185_7:                              // %B17
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	lsl	w8, w8, w21
	sub	x20, x20, #16
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB185_8:                              // %B5
	tst	x22, #0xfffe000000000000
	b.eq	.LBB185_12
// %bb.9:                               // %B5
	cmp	x21, x8
	b.lo	.LBB185_12
// %bb.10:                              // %B15
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB185_12
// %bb.11:                              // %B16
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB185_7
.LBB185_12:                             // %B26
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        // =0xa0
	str	x20, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB185_14
// %bb.13:                              // %B28
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB185_14:                             // %B27
	b	exception_asm_h
.Lfunc_end185:
	.size	shl_0_asm_h, .Lfunc_end185-shl_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	sar_0_asm_h                     // -- Begin function sar_0_asm_h
	.p2align	2
	.type	sar_0_asm_h,@function
sar_0_asm_h:                            // @sar_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B32
	ldr	w8, [x24, #336]
	cbz	w8, .LBB186_2
// %bb.1:                               // %B33
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB186_2:                              // %B29
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB186_12
// %bb.3:                               // %B29
	cmp	x21, x8
	b.hi	.LBB186_12
// %bb.4:                               // %B3
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB186_8
// %bb.5:                               // %B20
	cmp	x21, x8
	b.lo	.LBB186_12
// %bb.6:                               // %B25
	mov	w8, w22
.LBB186_7:                              // %B17
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	asr	w8, w8, w21
	sub	x20, x20, #16
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB186_8:                              // %B5
	tst	x22, #0xfffe000000000000
	b.eq	.LBB186_12
// %bb.9:                               // %B5
	cmp	x21, x8
	b.lo	.LBB186_12
// %bb.10:                              // %B15
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB186_12
// %bb.11:                              // %B16
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB186_7
.LBB186_12:                             // %B26
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        // =0xa1
	str	x20, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB186_14
// %bb.13:                              // %B28
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB186_14:                             // %B27
	b	exception_asm_h
.Lfunc_end186:
	.size	sar_0_asm_h, .Lfunc_end186-sar_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	shr_0_asm_h                     // -- Begin function shr_0_asm_h
	.p2align	2
	.type	shr_0_asm_h,@function
shr_0_asm_h:                            // @shr_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B40
	ldr	w8, [x24, #336]
	cbz	w8, .LBB187_2
// %bb.1:                               // %B41
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB187_2:                              // %B37
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB187_13
// %bb.3:                               // %B37
	cmp	x21, x8
	b.hi	.LBB187_13
// %bb.4:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB187_8
// %bb.5:                               // %B28
	cmp	x21, x8
	b.lo	.LBB187_13
// %bb.6:                               // %B33
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, .LBB187_12
.LBB187_7:                              // %B3
	orr	x8, x8, #0xfffe000000000000
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB187_8:                              // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB187_13
// %bb.9:                               // %B13
	cmp	x21, x8
	b.lo	.LBB187_13
// %bb.10:                              // %B23
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB187_13
// %bb.11:                              // %B24
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, .LBB187_7
.LBB187_12:                             // %B7
	ucvtf	d0, w8
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	x8, d0
	fcmp	d0, d0
	add	x8, x8, x10
	mov	x10, #9221120237041090560       // =0x7ff8000000000000
	csel	x8, x8, x10, vc
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB187_13:                             // %B34
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x29, #64]
	bl	prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	.LBB187_15
// %bb.14:                              // %B36
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB187_15:                             // %B35
	b	exception_asm_h
.Lfunc_end187:
	.size	shr_0_asm_h, .Lfunc_end187-shr_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	lt_0_asm_h                      // -- Begin function lt_0_asm_h
	.p2align	2
	.type	lt_0_asm_h,@function
lt_0_asm_h:                             // @lt_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B28
	ldr	w8, [x24, #336]
	cbz	w8, .LBB188_2
// %bb.1:                               // %B29
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB188_2:                              // %B25
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB188_15
// %bb.3:                               // %B25
	cmp	x21, x8
	b.hi	.LBB188_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB188_7
// %bb.5:                               // %B16
	cmp	x21, x8
	b.lo	.LBB188_10
// %bb.6:                               // %B21
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	cmp	w22, w21
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, lt
	br	x0
.LBB188_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB188_15
// %bb.8:                               // %B8
	cmp	x21, x8
	b.lo	.LBB188_13
// %bb.9:                               // %B14
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	add	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x0
.LBB188_10:                             // %B18
	tst	x21, #0xfffe000000000000
	b.eq	.LBB188_15
// %bb.11:                              // %B20
	scvtf	d0, w22
	add	x8, x21, x8
.LBB188_12:                             // %B20
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	add	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x0
.LBB188_13:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB188_15
// %bb.14:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB188_12
.LBB188_15:                             // %B22
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        // =0xa3
	str	x20, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB188_17
// %bb.16:                              // %B24
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB188_17:                             // %B23
	b	exception_asm_h
.Lfunc_end188:
	.size	lt_0_asm_h, .Lfunc_end188-lt_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	lte_0_asm_h                     // -- Begin function lte_0_asm_h
	.p2align	2
	.type	lte_0_asm_h,@function
lte_0_asm_h:                            // @lte_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B28
	ldr	w8, [x24, #336]
	cbz	w8, .LBB189_2
// %bb.1:                               // %B29
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB189_2:                              // %B25
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB189_15
// %bb.3:                               // %B25
	cmp	x21, x8
	b.hi	.LBB189_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB189_7
// %bb.5:                               // %B16
	cmp	x21, x8
	b.lo	.LBB189_10
// %bb.6:                               // %B21
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	cmp	w22, w21
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, le
	br	x0
.LBB189_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB189_15
// %bb.8:                               // %B8
	cmp	x21, x8
	b.lo	.LBB189_13
// %bb.9:                               // %B14
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	add	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x0
.LBB189_10:                             // %B18
	tst	x21, #0xfffe000000000000
	b.eq	.LBB189_15
// %bb.11:                              // %B20
	scvtf	d0, w22
	add	x8, x21, x8
.LBB189_12:                             // %B20
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	add	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x0
.LBB189_13:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB189_15
// %bb.14:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB189_12
.LBB189_15:                             // %B22
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        // =0xa4
	str	x20, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB189_17
// %bb.16:                              // %B24
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB189_17:                             // %B23
	b	exception_asm_h
.Lfunc_end189:
	.size	lte_0_asm_h, .Lfunc_end189-lte_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	gt_0_asm_h                      // -- Begin function gt_0_asm_h
	.p2align	2
	.type	gt_0_asm_h,@function
gt_0_asm_h:                             // @gt_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B28
	ldr	w8, [x24, #336]
	cbz	w8, .LBB190_2
// %bb.1:                               // %B29
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB190_2:                              // %B25
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB190_15
// %bb.3:                               // %B25
	cmp	x21, x8
	b.hi	.LBB190_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB190_7
// %bb.5:                               // %B16
	cmp	x21, x8
	b.lo	.LBB190_10
// %bb.6:                               // %B21
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x0
.LBB190_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB190_15
// %bb.8:                               // %B8
	cmp	x21, x8
	b.lo	.LBB190_13
// %bb.9:                               // %B14
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	add	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x0
.LBB190_10:                             // %B18
	tst	x21, #0xfffe000000000000
	b.eq	.LBB190_15
// %bb.11:                              // %B20
	scvtf	d0, w22
	add	x8, x21, x8
.LBB190_12:                             // %B20
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	add	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x0
.LBB190_13:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB190_15
// %bb.14:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB190_12
.LBB190_15:                             // %B22
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        // =0xa5
	str	x20, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB190_17
// %bb.16:                              // %B24
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB190_17:                             // %B23
	b	exception_asm_h
.Lfunc_end190:
	.size	gt_0_asm_h, .Lfunc_end190-gt_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	gte_0_asm_h                     // -- Begin function gte_0_asm_h
	.p2align	2
	.type	gte_0_asm_h,@function
gte_0_asm_h:                            // @gte_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B28
	ldr	w8, [x24, #336]
	cbz	w8, .LBB191_2
// %bb.1:                               // %B29
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB191_2:                              // %B25
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB191_15
// %bb.3:                               // %B25
	cmp	x21, x8
	b.hi	.LBB191_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB191_7
// %bb.5:                               // %B16
	cmp	x21, x8
	b.lo	.LBB191_10
// %bb.6:                               // %B21
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x0
.LBB191_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB191_15
// %bb.8:                               // %B8
	cmp	x21, x8
	b.lo	.LBB191_13
// %bb.9:                               // %B14
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	add	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x0
.LBB191_10:                             // %B18
	tst	x21, #0xfffe000000000000
	b.eq	.LBB191_15
// %bb.11:                              // %B20
	scvtf	d0, w22
	add	x8, x21, x8
.LBB191_12:                             // %B20
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	add	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x0
.LBB191_13:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB191_15
// %bb.14:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB191_12
.LBB191_15:                             // %B22
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        // =0xa6
	str	x20, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB191_17
// %bb.16:                              // %B24
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB191_17:                             // %B23
	b	exception_asm_h
.Lfunc_end191:
	.size	gte_0_asm_h, .Lfunc_end191-gte_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	instanceof_0_asm_h              // -- Begin function instanceof_0_asm_h
	.p2align	2
	.type	instanceof_0_asm_h,@function
instanceof_0_asm_h:                     // @instanceof_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB192_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB192_2:                              // %B2
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	.LBB192_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB192_4:                              // %B3
	b	exception_asm_h
.Lfunc_end192:
	.size	instanceof_0_asm_h, .Lfunc_end192-instanceof_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	in_0_asm_h                      // -- Begin function in_0_asm_h
	.p2align	2
	.type	in_0_asm_h,@function
in_0_asm_h:                             // @in_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB193_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB193_2:                              // %B2
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	.LBB193_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB193_4:                              // %B3
	b	exception_asm_h
.Lfunc_end193:
	.size	in_0_asm_h, .Lfunc_end193-in_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	eq_0_asm_h                      // -- Begin function eq_0_asm_h
	.p2align	2
	.type	eq_0_asm_h,@function
eq_0_asm_h:                             // @eq_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B48
	ldr	w8, [x24, #336]
	cbz	w8, .LBB194_2
// %bb.1:                               // %B49
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB194_2:                              // %B45
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB194_16
// %bb.3:                               // %B45
	cmp	x21, x8
	b.hi	.LBB194_16
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB194_7
// %bb.5:                               // %B36
	cmp	x21, x8
	b.lo	.LBB194_10
// %bb.6:                               // %B41
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	cmp	w22, w21
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x0
.LBB194_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB194_16
// %bb.8:                               // %B29
	cmp	x21, x8
	b.lo	.LBB194_14
// %bb.9:                               // %B34
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fcmp	d1, d0
	cset	w8, eq
	fcmp	d1, d1
	b	.LBB194_13
.LBB194_10:                             // %B38
	tst	x21, #0xfffe000000000000
	b.eq	.LBB194_16
// %bb.11:                              // %B40
	scvtf	d0, w22
	add	x8, x21, x8
.LBB194_12:                             // %B40
	fmov	d1, x8
	fcmp	d0, d1
	cset	w8, eq
	fcmp	d0, d0
.LBB194_13:                             // %B40
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	csel	w8, wzr, w8, vs
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB194_14:                             // %B31
	tst	x21, #0xfffe000000000000
	b.eq	.LBB194_16
// %bb.15:                              // %B33
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB194_12
.LBB194_16:                             // %B8
	cmp	x22, x21
	b.ne	.LBB194_18
.LBB194_17:                             // %B9
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB194_18:                             // %B11
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB194_20
// %bb.19:                              // %B13
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB194_17
	b	.LBB194_23
.LBB194_20:                             // %B18
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB194_23
// %bb.21:                              // %B21
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB194_24
// %bb.22:                              // %B21
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB194_24
.LBB194_23:                             // %B16
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB194_24:                             // %B42
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x29, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB194_26
// %bb.25:                              // %B44
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB194_26:                             // %B43
	b	exception_asm_h
.Lfunc_end194:
	.size	eq_0_asm_h, .Lfunc_end194-eq_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	neq_0_asm_h                     // -- Begin function neq_0_asm_h
	.p2align	2
	.type	neq_0_asm_h,@function
neq_0_asm_h:                            // @neq_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B48
	ldr	w8, [x24, #336]
	cbz	w8, .LBB195_2
// %bb.1:                               // %B49
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB195_2:                              // %B45
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB195_16
// %bb.3:                               // %B45
	cmp	x21, x8
	b.hi	.LBB195_16
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB195_7
// %bb.5:                               // %B36
	cmp	x21, x8
	b.lo	.LBB195_10
// %bb.6:                               // %B41
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	cmp	w22, w21
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x0
.LBB195_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB195_16
// %bb.8:                               // %B29
	cmp	x21, x8
	b.lo	.LBB195_14
// %bb.9:                               // %B34
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fcmp	d1, d0
	cset	w8, ne
	fcmp	d1, d1
	b	.LBB195_13
.LBB195_10:                             // %B38
	tst	x21, #0xfffe000000000000
	b.eq	.LBB195_16
// %bb.11:                              // %B40
	scvtf	d0, w22
	add	x8, x21, x8
.LBB195_12:                             // %B40
	fmov	d1, x8
	fcmp	d0, d1
	cset	w8, ne
	fcmp	d0, d0
.LBB195_13:                             // %B40
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	csinc	w8, w8, wzr, vc
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB195_14:                             // %B31
	tst	x21, #0xfffe000000000000
	b.eq	.LBB195_16
// %bb.15:                              // %B33
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB195_12
.LBB195_16:                             // %B8
	cmp	x22, x21
	b.ne	.LBB195_18
.LBB195_17:                             // %B9
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB195_18:                             // %B11
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB195_20
// %bb.19:                              // %B13
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB195_17
	b	.LBB195_23
.LBB195_20:                             // %B18
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB195_23
// %bb.21:                              // %B21
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB195_24
// %bb.22:                              // %B21
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB195_24
.LBB195_23:                             // %B16
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB195_24:                             // %B42
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x20, [x29, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB195_26
// %bb.25:                              // %B44
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB195_26:                             // %B43
	b	exception_asm_h
.Lfunc_end195:
	.size	neq_0_asm_h, .Lfunc_end195-neq_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	strict_eq_0_asm_h               // -- Begin function strict_eq_0_asm_h
	.p2align	2
	.type	strict_eq_0_asm_h,@function
strict_eq_0_asm_h:                      // @strict_eq_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B34
	ldr	w8, [x24, #336]
	cbz	w8, .LBB196_2
// %bb.1:                               // %B35
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB196_2:                              // %B31
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB196_16
// %bb.3:                               // %B31
	cmp	x21, x8
	b.hi	.LBB196_16
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB196_7
// %bb.5:                               // %B22
	cmp	x21, x8
	b.lo	.LBB196_10
// %bb.6:                               // %B27
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	cmp	w22, w21
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x0
.LBB196_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB196_16
// %bb.8:                               // %B15
	cmp	x21, x8
	b.lo	.LBB196_14
// %bb.9:                               // %B20
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fcmp	d1, d0
	cset	w8, eq
	fcmp	d1, d1
	b	.LBB196_13
.LBB196_10:                             // %B24
	tst	x21, #0xfffe000000000000
	b.eq	.LBB196_16
// %bb.11:                              // %B26
	scvtf	d0, w22
	add	x8, x21, x8
.LBB196_12:                             // %B26
	fmov	d1, x8
	fcmp	d0, d1
	cset	w8, eq
	fcmp	d0, d0
.LBB196_13:                             // %B26
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	csel	w8, wzr, w8, vs
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB196_14:                             // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB196_16
// %bb.15:                              // %B19
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB196_12
.LBB196_16:                             // %B8
	cmp	x22, x21
	b.ne	.LBB196_18
// %bb.17:                              // %B9
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB196_18:                             // %B11
	and	x8, x21, #0xffff000000000003
	mov	x10, #-281474976710653          // =0xffff000000000003
	mov	x11, #2                         // =0x2
	cmp	x8, x10
	movk	x11, #1, lsl #48
	mov	x12, #2                         // =0x2
	ccmp	x8, x11, #4, ne
	movk	x12, #65535, lsl #48
	mov	x13, #-281474976710656          // =0xffff000000000000
	ccmp	x8, x12, #4, ne
	and	x14, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w8, eq
	cmp	x14, x13
	ccmp	x14, x12, #4, ne
	ccmp	x14, x11, #4, ne
	ccmp	x14, x10, #4, ne
	b.ne	.LBB196_20
// %bb.19:                              // %B11
	tbnz	w8, #0, .LBB196_21
.LBB196_20:                             // %B13
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB196_21:                             // %B28
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x29, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB196_23
// %bb.22:                              // %B30
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB196_23:                             // %B29
	b	exception_asm_h
.Lfunc_end196:
	.size	strict_eq_0_asm_h, .Lfunc_end196-strict_eq_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	strict_neq_0_asm_h              // -- Begin function strict_neq_0_asm_h
	.p2align	2
	.type	strict_neq_0_asm_h,@function
strict_neq_0_asm_h:                     // @strict_neq_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B34
	ldr	w8, [x24, #336]
	cbz	w8, .LBB197_2
// %bb.1:                               // %B35
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB197_2:                              // %B31
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB197_16
// %bb.3:                               // %B31
	cmp	x21, x8
	b.hi	.LBB197_16
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB197_7
// %bb.5:                               // %B22
	cmp	x21, x8
	b.lo	.LBB197_10
// %bb.6:                               // %B27
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	cmp	w22, w21
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x0
.LBB197_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB197_16
// %bb.8:                               // %B15
	cmp	x21, x8
	b.lo	.LBB197_14
// %bb.9:                               // %B20
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fcmp	d1, d0
	cset	w8, ne
	fcmp	d1, d1
	b	.LBB197_13
.LBB197_10:                             // %B24
	tst	x21, #0xfffe000000000000
	b.eq	.LBB197_16
// %bb.11:                              // %B26
	scvtf	d0, w22
	add	x8, x21, x8
.LBB197_12:                             // %B26
	fmov	d1, x8
	fcmp	d0, d1
	cset	w8, ne
	fcmp	d0, d0
.LBB197_13:                             // %B26
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	csinc	w8, w8, wzr, vc
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB197_14:                             // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB197_16
// %bb.15:                              // %B19
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB197_12
.LBB197_16:                             // %B8
	cmp	x22, x21
	b.ne	.LBB197_18
// %bb.17:                              // %B9
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB197_18:                             // %B11
	and	x8, x21, #0xffff000000000003
	mov	x10, #-281474976710653          // =0xffff000000000003
	mov	x11, #2                         // =0x2
	cmp	x8, x10
	movk	x11, #1, lsl #48
	mov	x12, #2                         // =0x2
	ccmp	x8, x11, #4, ne
	movk	x12, #65535, lsl #48
	mov	x13, #-281474976710656          // =0xffff000000000000
	ccmp	x8, x12, #4, ne
	and	x14, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w8, eq
	cmp	x14, x13
	ccmp	x14, x12, #4, ne
	ccmp	x14, x11, #4, ne
	ccmp	x14, x10, #4, ne
	b.ne	.LBB197_20
// %bb.19:                              // %B11
	tbnz	w8, #0, .LBB197_21
.LBB197_20:                             // %B13
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB197_21:                             // %B28
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x20, [x29, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB197_23
// %bb.22:                              // %B30
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB197_23:                             // %B29
	b	exception_asm_h
.Lfunc_end197:
	.size	strict_neq_0_asm_h, .Lfunc_end197-strict_neq_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	and_0_asm_h                     // -- Begin function and_0_asm_h
	.p2align	2
	.type	and_0_asm_h,@function
and_0_asm_h:                            // @and_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B32
	ldr	w8, [x24, #336]
	cbz	w8, .LBB198_2
// %bb.1:                               // %B33
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB198_2:                              // %B29
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB198_12
// %bb.3:                               // %B29
	cmp	x21, x8
	b.hi	.LBB198_12
// %bb.4:                               // %B3
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB198_8
// %bb.5:                               // %B20
	cmp	x21, x8
	b.lo	.LBB198_12
// %bb.6:                               // %B25
	mov	w8, w22
.LBB198_7:                              // %B17
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	and	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB198_8:                              // %B5
	tst	x22, #0xfffe000000000000
	b.eq	.LBB198_12
// %bb.9:                               // %B5
	cmp	x21, x8
	b.lo	.LBB198_12
// %bb.10:                              // %B15
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB198_12
// %bb.11:                              // %B16
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB198_7
.LBB198_12:                             // %B26
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        // =0xad
	str	x20, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB198_14
// %bb.13:                              // %B28
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB198_14:                             // %B27
	b	exception_asm_h
.Lfunc_end198:
	.size	and_0_asm_h, .Lfunc_end198-and_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	xor_0_asm_h                     // -- Begin function xor_0_asm_h
	.p2align	2
	.type	xor_0_asm_h,@function
xor_0_asm_h:                            // @xor_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B32
	ldr	w8, [x24, #336]
	cbz	w8, .LBB199_2
// %bb.1:                               // %B33
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB199_2:                              // %B29
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB199_12
// %bb.3:                               // %B29
	cmp	x21, x8
	b.hi	.LBB199_12
// %bb.4:                               // %B3
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB199_8
// %bb.5:                               // %B20
	cmp	x21, x8
	b.lo	.LBB199_12
// %bb.6:                               // %B25
	mov	w8, w22
.LBB199_7:                              // %B17
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	eor	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB199_8:                              // %B5
	tst	x22, #0xfffe000000000000
	b.eq	.LBB199_12
// %bb.9:                               // %B5
	cmp	x21, x8
	b.lo	.LBB199_12
// %bb.10:                              // %B15
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB199_12
// %bb.11:                              // %B16
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB199_7
.LBB199_12:                             // %B26
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        // =0xae
	str	x20, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB199_14
// %bb.13:                              // %B28
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB199_14:                             // %B27
	b	exception_asm_h
.Lfunc_end199:
	.size	xor_0_asm_h, .Lfunc_end199-xor_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	or_0_asm_h                      // -- Begin function or_0_asm_h
	.p2align	2
	.type	or_0_asm_h,@function
or_0_asm_h:                             // @or_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B32
	ldr	w8, [x24, #336]
	cbz	w8, .LBB200_2
// %bb.1:                               // %B33
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB200_2:                              // %B29
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB200_12
// %bb.3:                               // %B29
	cmp	x21, x8
	b.hi	.LBB200_12
// %bb.4:                               // %B3
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB200_8
// %bb.5:                               // %B20
	cmp	x21, x8
	b.lo	.LBB200_12
// %bb.6:                               // %B25
	mov	w8, w22
.LBB200_7:                              // %B17
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	orr	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB200_8:                              // %B5
	tst	x22, #0xfffe000000000000
	b.eq	.LBB200_12
// %bb.9:                               // %B5
	cmp	x21, x8
	b.lo	.LBB200_12
// %bb.10:                              // %B15
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB200_12
// %bb.11:                              // %B16
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB200_7
.LBB200_12:                             // %B26
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        // =0xaf
	str	x20, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB200_14
// %bb.13:                              // %B28
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB200_14:                             // %B27
	b	exception_asm_h
.Lfunc_end200:
	.size	or_0_asm_h, .Lfunc_end200-or_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	nop_0_asm_h                     // -- Begin function nop_0_asm_h
	.p2align	2
	.type	nop_0_asm_h,@function
nop_0_asm_h:                            // @nop_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB201_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB201_2:                              // %B1
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end201:
	.size	nop_0_asm_h, .Lfunc_end201-nop_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_minus1_0_asm_h             // -- Begin function push_minus1_0_asm_h
	.p2align	2
	.type	push_minus1_0_asm_h,@function
push_minus1_0_asm_h:                    // @push_minus1_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB202_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB202_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, #-562945658454017          // =0xfffe0000ffffffff
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end202:
	.size	push_minus1_0_asm_h, .Lfunc_end202-push_minus1_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_0_0_asm_h                  // -- Begin function push_0_0_asm_h
	.p2align	2
	.type	push_0_0_asm_h,@function
push_0_0_asm_h:                         // @push_0_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB203_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB203_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, #-562949953421312          // =0xfffe000000000000
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end203:
	.size	push_0_0_asm_h, .Lfunc_end203-push_0_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_1_0_asm_h                  // -- Begin function push_1_0_asm_h
	.p2align	2
	.type	push_1_0_asm_h,@function
push_1_0_asm_h:                         // @push_1_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB204_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB204_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, #-562949953421311          // =0xfffe000000000001
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end204:
	.size	push_1_0_asm_h, .Lfunc_end204-push_1_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_2_0_asm_h                  // -- Begin function push_2_0_asm_h
	.p2align	2
	.type	push_2_0_asm_h,@function
push_2_0_asm_h:                         // @push_2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB205_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB205_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, #2                         // =0x2
	ldr	x0, [x25, x8, lsl #3]
	movk	x22, #65534, lsl #48
	br	x0
.Lfunc_end205:
	.size	push_2_0_asm_h, .Lfunc_end205-push_2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_3_0_asm_h                  // -- Begin function push_3_0_asm_h
	.p2align	2
	.type	push_3_0_asm_h,@function
push_3_0_asm_h:                         // @push_3_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB206_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB206_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, #-562949953421309          // =0xfffe000000000003
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end206:
	.size	push_3_0_asm_h, .Lfunc_end206-push_3_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_4_0_asm_h                  // -- Begin function push_4_0_asm_h
	.p2align	2
	.type	push_4_0_asm_h,@function
push_4_0_asm_h:                         // @push_4_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB207_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB207_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, #4                         // =0x4
	ldr	x0, [x25, x8, lsl #3]
	movk	x22, #65534, lsl #48
	br	x0
.Lfunc_end207:
	.size	push_4_0_asm_h, .Lfunc_end207-push_4_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_5_0_asm_h                  // -- Begin function push_5_0_asm_h
	.p2align	2
	.type	push_5_0_asm_h,@function
push_5_0_asm_h:                         // @push_5_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB208_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB208_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, #5                         // =0x5
	ldr	x0, [x25, x8, lsl #3]
	movk	x22, #65534, lsl #48
	br	x0
.Lfunc_end208:
	.size	push_5_0_asm_h, .Lfunc_end208-push_5_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_6_0_asm_h                  // -- Begin function push_6_0_asm_h
	.p2align	2
	.type	push_6_0_asm_h,@function
push_6_0_asm_h:                         // @push_6_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB209_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB209_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	movk	x22, #65534, lsl #48
	br	x0
.Lfunc_end209:
	.size	push_6_0_asm_h, .Lfunc_end209-push_6_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_7_0_asm_h                  // -- Begin function push_7_0_asm_h
	.p2align	2
	.type	push_7_0_asm_h,@function
push_7_0_asm_h:                         // @push_7_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB210_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB210_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, #-562949953421305          // =0xfffe000000000007
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end210:
	.size	push_7_0_asm_h, .Lfunc_end210-push_7_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_i8_0_asm_h                 // -- Begin function push_i8_0_asm_h
	.p2align	2
	.type	push_i8_0_asm_h,@function
push_i8_0_asm_h:                        // @push_i8_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB211_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB211_2:                              // %B1
	ldrsb	x8, [x19]
	ldrb	w10, [x19, #1]
	mov	x11, #-562949953421312          // =0xfffe000000000000
	add	x25, x25, #1936
	add	x19, x19, #2
	bfxil	x11, x8, #0, #32
	ldr	x0, [x25, x10, lsl #3]
	mov	x22, x11
	br	x0
.Lfunc_end211:
	.size	push_i8_0_asm_h, .Lfunc_end211-push_i8_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_i16_0_asm_h                // -- Begin function push_i16_0_asm_h
	.p2align	2
	.type	push_i16_0_asm_h,@function
push_i16_0_asm_h:                       // @push_i16_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB212_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB212_2:                              // %B1
	ldrsh	x8, [x19]
	ldrb	w10, [x19, #2]
	mov	x11, #-562949953421312          // =0xfffe000000000000
	add	x25, x25, #1936
	add	x19, x19, #3
	bfxil	x11, x8, #0, #32
	ldr	x0, [x25, x10, lsl #3]
	mov	x22, x11
	br	x0
.Lfunc_end212:
	.size	push_i16_0_asm_h, .Lfunc_end212-push_i16_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_const8_0_asm_h             // -- Begin function push_const8_0_asm_h
	.p2align	2
	.type	push_const8_0_asm_h,@function
push_const8_0_asm_h:                    // @push_const8_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB213_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB213_2:                              // %B4
	ldrb	w8, [x19]
	ldr	w10, [x24, #336]
	ldr	x11, [x23, x8, lsl #3]
	cbz	w10, .LBB213_4
// %bb.3:                               // %B5
	mov	x0, x24
	mov	x1, x11
	mov	x2, x19
	str	x20, [x29, #64]
	str	x20, [sp, #8]                   // 8-byte Folded Spill
	mov	x20, x11
	bl	DebuggerPause
	mov	x11, x20
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
.LBB213_4:                              // %B2
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	add	x19, x19, #2
	mov	x22, x11
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.Lfunc_end213:
	.size	push_const8_0_asm_h, .Lfunc_end213-push_const8_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	fclosure8_0_asm_h               // -- Begin function fclosure8_0_asm_h
	.p2align	2
	.type	fclosure8_0_asm_h,@function
fclosure8_0_asm_h:                      // @fclosure8_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB214_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB214_2:                              // %B2
	ldrb	w8, [x19]
	mov	x0, x24
	mov	x2, x26
	mov	x3, x29
	ldr	x1, [x23, x8, lsl #3]
	str	x20, [x29, #64]
	bl	js_closure_gc
	cmp	x0, #130
	b.eq	.LBB214_4
// %bb.3:                               // %B4
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	add	x19, x19, #2
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB214_4:                              // %B3
	b	exception_asm_h
.Lfunc_end214:
	.size	fclosure8_0_asm_h, .Lfunc_end214-fclosure8_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_empty_string_0_asm_h       // -- Begin function push_empty_string_0_asm_h
	.p2align	2
	.type	push_empty_string_0_asm_h,@function
push_empty_string_0_asm_h:              // @push_empty_string_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB215_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB215_2:                              // %B2
	mov	x0, x24
	mov	w1, #47                         // =0x2f
	mov	w2, #1                          // =0x1
	str	x20, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB215_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB215_4:                              // %B3
	b	exception_asm_h
.Lfunc_end215:
	.size	push_empty_string_0_asm_h, .Lfunc_end215-push_empty_string_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc8_0_asm_h                // -- Begin function get_loc8_0_asm_h
	.p2align	2
	.type	get_loc8_0_asm_h,@function
get_loc8_0_asm_h:                       // @get_loc8_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB216_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB216_2:                              // %B1
	ldrb	w8, [x19, #1]
	ldrb	w10, [x19], #2
	add	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	ldr	x22, [x27, x10, lsl #3]
	br	x0
.Lfunc_end216:
	.size	get_loc8_0_asm_h, .Lfunc_end216-get_loc8_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc8_0_asm_h                // -- Begin function put_loc8_0_asm_h
	.p2align	2
	.type	put_loc8_0_asm_h,@function
put_loc8_0_asm_h:                       // @put_loc8_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB217_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB217_2:                              // %B1
	ldrb	w8, [x19]
	ldr	x22, [x20, #-8]!
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end217:
	.size	put_loc8_0_asm_h, .Lfunc_end217-put_loc8_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc8_0_asm_h                // -- Begin function set_loc8_0_asm_h
	.p2align	2
	.type	set_loc8_0_asm_h,@function
set_loc8_0_asm_h:                       // @set_loc8_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB218_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB218_2:                              // %B1
	ldrb	w8, [x19]
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end218:
	.size	set_loc8_0_asm_h, .Lfunc_end218-set_loc8_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc0_0_asm_h                // -- Begin function get_loc0_0_asm_h
	.p2align	2
	.type	get_loc0_0_asm_h,@function
get_loc0_0_asm_h:                       // @get_loc0_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB219_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB219_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x22, [x27]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end219:
	.size	get_loc0_0_asm_h, .Lfunc_end219-get_loc0_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc1_0_asm_h                // -- Begin function get_loc1_0_asm_h
	.p2align	2
	.type	get_loc1_0_asm_h,@function
get_loc1_0_asm_h:                       // @get_loc1_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB220_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB220_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x22, [x27, #8]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end220:
	.size	get_loc1_0_asm_h, .Lfunc_end220-get_loc1_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc2_0_asm_h                // -- Begin function get_loc2_0_asm_h
	.p2align	2
	.type	get_loc2_0_asm_h,@function
get_loc2_0_asm_h:                       // @get_loc2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB221_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB221_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x22, [x27, #16]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end221:
	.size	get_loc2_0_asm_h, .Lfunc_end221-get_loc2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc3_0_asm_h                // -- Begin function get_loc3_0_asm_h
	.p2align	2
	.type	get_loc3_0_asm_h,@function
get_loc3_0_asm_h:                       // @get_loc3_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB222_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB222_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x22, [x27, #24]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end222:
	.size	get_loc3_0_asm_h, .Lfunc_end222-get_loc3_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc0_0_asm_h                // -- Begin function put_loc0_0_asm_h
	.p2align	2
	.type	put_loc0_0_asm_h,@function
put_loc0_0_asm_h:                       // @put_loc0_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB223_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB223_2:                              // %B1
	ldr	x22, [x20, #-8]!
	str	x22, [x27]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end223:
	.size	put_loc0_0_asm_h, .Lfunc_end223-put_loc0_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc1_0_asm_h                // -- Begin function put_loc1_0_asm_h
	.p2align	2
	.type	put_loc1_0_asm_h,@function
put_loc1_0_asm_h:                       // @put_loc1_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB224_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB224_2:                              // %B1
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end224:
	.size	put_loc1_0_asm_h, .Lfunc_end224-put_loc1_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc2_0_asm_h                // -- Begin function put_loc2_0_asm_h
	.p2align	2
	.type	put_loc2_0_asm_h,@function
put_loc2_0_asm_h:                       // @put_loc2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB225_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB225_2:                              // %B1
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end225:
	.size	put_loc2_0_asm_h, .Lfunc_end225-put_loc2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc3_0_asm_h                // -- Begin function put_loc3_0_asm_h
	.p2align	2
	.type	put_loc3_0_asm_h,@function
put_loc3_0_asm_h:                       // @put_loc3_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB226_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB226_2:                              // %B1
	ldr	x22, [x20, #-8]!
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end226:
	.size	put_loc3_0_asm_h, .Lfunc_end226-put_loc3_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc0_0_asm_h                // -- Begin function set_loc0_0_asm_h
	.p2align	2
	.type	set_loc0_0_asm_h,@function
set_loc0_0_asm_h:                       // @set_loc0_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB227_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB227_2:                              // %B1
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	str	x22, [x27]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end227:
	.size	set_loc0_0_asm_h, .Lfunc_end227-set_loc0_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc1_0_asm_h                // -- Begin function set_loc1_0_asm_h
	.p2align	2
	.type	set_loc1_0_asm_h,@function
set_loc1_0_asm_h:                       // @set_loc1_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB228_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB228_2:                              // %B1
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end228:
	.size	set_loc1_0_asm_h, .Lfunc_end228-set_loc1_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc2_0_asm_h                // -- Begin function set_loc2_0_asm_h
	.p2align	2
	.type	set_loc2_0_asm_h,@function
set_loc2_0_asm_h:                       // @set_loc2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB229_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB229_2:                              // %B1
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end229:
	.size	set_loc2_0_asm_h, .Lfunc_end229-set_loc2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc3_0_asm_h                // -- Begin function set_loc3_0_asm_h
	.p2align	2
	.type	set_loc3_0_asm_h,@function
set_loc3_0_asm_h:                       // @set_loc3_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB230_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB230_2:                              // %B1
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end230:
	.size	set_loc3_0_asm_h, .Lfunc_end230-set_loc3_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_arg0_0_asm_h                // -- Begin function get_arg0_0_asm_h
	.p2align	2
	.type	get_arg0_0_asm_h,@function
get_arg0_0_asm_h:                       // @get_arg0_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB231_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB231_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x22, [x28]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end231:
	.size	get_arg0_0_asm_h, .Lfunc_end231-get_arg0_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_arg1_0_asm_h                // -- Begin function get_arg1_0_asm_h
	.p2align	2
	.type	get_arg1_0_asm_h,@function
get_arg1_0_asm_h:                       // @get_arg1_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB232_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB232_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x22, [x28, #8]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end232:
	.size	get_arg1_0_asm_h, .Lfunc_end232-get_arg1_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_arg2_0_asm_h                // -- Begin function get_arg2_0_asm_h
	.p2align	2
	.type	get_arg2_0_asm_h,@function
get_arg2_0_asm_h:                       // @get_arg2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB233_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB233_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x22, [x28, #16]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end233:
	.size	get_arg2_0_asm_h, .Lfunc_end233-get_arg2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_arg3_0_asm_h                // -- Begin function get_arg3_0_asm_h
	.p2align	2
	.type	get_arg3_0_asm_h,@function
get_arg3_0_asm_h:                       // @get_arg3_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB234_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB234_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x22, [x28, #24]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end234:
	.size	get_arg3_0_asm_h, .Lfunc_end234-get_arg3_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_arg0_0_asm_h                // -- Begin function put_arg0_0_asm_h
	.p2align	2
	.type	put_arg0_0_asm_h,@function
put_arg0_0_asm_h:                       // @put_arg0_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB235_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB235_2:                              // %B1
	ldr	x22, [x20, #-8]!
	str	x22, [x28]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end235:
	.size	put_arg0_0_asm_h, .Lfunc_end235-put_arg0_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_arg1_0_asm_h                // -- Begin function put_arg1_0_asm_h
	.p2align	2
	.type	put_arg1_0_asm_h,@function
put_arg1_0_asm_h:                       // @put_arg1_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB236_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB236_2:                              // %B1
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end236:
	.size	put_arg1_0_asm_h, .Lfunc_end236-put_arg1_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_arg2_0_asm_h                // -- Begin function put_arg2_0_asm_h
	.p2align	2
	.type	put_arg2_0_asm_h,@function
put_arg2_0_asm_h:                       // @put_arg2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB237_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB237_2:                              // %B1
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end237:
	.size	put_arg2_0_asm_h, .Lfunc_end237-put_arg2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_arg3_0_asm_h                // -- Begin function put_arg3_0_asm_h
	.p2align	2
	.type	put_arg3_0_asm_h,@function
put_arg3_0_asm_h:                       // @put_arg3_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB238_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB238_2:                              // %B1
	ldr	x22, [x20, #-8]!
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end238:
	.size	put_arg3_0_asm_h, .Lfunc_end238-put_arg3_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_arg0_0_asm_h                // -- Begin function set_arg0_0_asm_h
	.p2align	2
	.type	set_arg0_0_asm_h,@function
set_arg0_0_asm_h:                       // @set_arg0_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB239_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB239_2:                              // %B1
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	str	x22, [x28]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end239:
	.size	set_arg0_0_asm_h, .Lfunc_end239-set_arg0_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_arg1_0_asm_h                // -- Begin function set_arg1_0_asm_h
	.p2align	2
	.type	set_arg1_0_asm_h,@function
set_arg1_0_asm_h:                       // @set_arg1_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB240_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB240_2:                              // %B1
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end240:
	.size	set_arg1_0_asm_h, .Lfunc_end240-set_arg1_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_arg2_0_asm_h                // -- Begin function set_arg2_0_asm_h
	.p2align	2
	.type	set_arg2_0_asm_h,@function
set_arg2_0_asm_h:                       // @set_arg2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB241_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB241_2:                              // %B1
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end241:
	.size	set_arg2_0_asm_h, .Lfunc_end241-set_arg2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_arg3_0_asm_h                // -- Begin function set_arg3_0_asm_h
	.p2align	2
	.type	set_arg3_0_asm_h,@function
set_arg3_0_asm_h:                       // @set_arg3_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB242_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB242_2:                              // %B1
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end242:
	.size	set_arg3_0_asm_h, .Lfunc_end242-set_arg3_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref0_0_asm_h            // -- Begin function get_var_ref0_0_asm_h
	.p2align	2
	.type	get_var_ref0_0_asm_h,@function
get_var_ref0_0_asm_h:                   // @get_var_ref0_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB243_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB243_2:                              // %B1
	ldr	x8, [x26]
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	ldr	x8, [x8, #32]
	ldr	x0, [x25, x10, lsl #3]
	ldr	x22, [x8]
	br	x0
.Lfunc_end243:
	.size	get_var_ref0_0_asm_h, .Lfunc_end243-get_var_ref0_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref1_0_asm_h            // -- Begin function get_var_ref1_0_asm_h
	.p2align	2
	.type	get_var_ref1_0_asm_h,@function
get_var_ref1_0_asm_h:                   // @get_var_ref1_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB244_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB244_2:                              // %B1
	ldr	x8, [x26, #8]
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	ldr	x8, [x8, #32]
	ldr	x0, [x25, x10, lsl #3]
	ldr	x22, [x8]
	br	x0
.Lfunc_end244:
	.size	get_var_ref1_0_asm_h, .Lfunc_end244-get_var_ref1_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref2_0_asm_h            // -- Begin function get_var_ref2_0_asm_h
	.p2align	2
	.type	get_var_ref2_0_asm_h,@function
get_var_ref2_0_asm_h:                   // @get_var_ref2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB245_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB245_2:                              // %B1
	ldr	x8, [x26, #16]
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	ldr	x8, [x8, #32]
	ldr	x0, [x25, x10, lsl #3]
	ldr	x22, [x8]
	br	x0
.Lfunc_end245:
	.size	get_var_ref2_0_asm_h, .Lfunc_end245-get_var_ref2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref3_0_asm_h            // -- Begin function get_var_ref3_0_asm_h
	.p2align	2
	.type	get_var_ref3_0_asm_h,@function
get_var_ref3_0_asm_h:                   // @get_var_ref3_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB246_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB246_2:                              // %B1
	ldr	x8, [x26, #24]
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	ldr	x8, [x8, #32]
	ldr	x0, [x25, x10, lsl #3]
	ldr	x22, [x8]
	br	x0
.Lfunc_end246:
	.size	get_var_ref3_0_asm_h, .Lfunc_end246-get_var_ref3_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref0_0_asm_h            // -- Begin function put_var_ref0_0_asm_h
	.p2align	2
	.type	put_var_ref0_0_asm_h,@function
put_var_ref0_0_asm_h:                   // @put_var_ref0_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB247_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB247_2:                              // %B1
	ldr	x8, [x26]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end247:
	.size	put_var_ref0_0_asm_h, .Lfunc_end247-put_var_ref0_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref1_0_asm_h            // -- Begin function put_var_ref1_0_asm_h
	.p2align	2
	.type	put_var_ref1_0_asm_h,@function
put_var_ref1_0_asm_h:                   // @put_var_ref1_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB248_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB248_2:                              // %B1
	ldr	x8, [x26, #8]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end248:
	.size	put_var_ref1_0_asm_h, .Lfunc_end248-put_var_ref1_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref2_0_asm_h            // -- Begin function put_var_ref2_0_asm_h
	.p2align	2
	.type	put_var_ref2_0_asm_h,@function
put_var_ref2_0_asm_h:                   // @put_var_ref2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB249_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB249_2:                              // %B1
	ldr	x8, [x26, #16]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end249:
	.size	put_var_ref2_0_asm_h, .Lfunc_end249-put_var_ref2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref3_0_asm_h            // -- Begin function put_var_ref3_0_asm_h
	.p2align	2
	.type	put_var_ref3_0_asm_h,@function
put_var_ref3_0_asm_h:                   // @put_var_ref3_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB250_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB250_2:                              // %B1
	ldr	x8, [x26, #24]
	ldr	x22, [x20, #-8]!
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end250:
	.size	put_var_ref3_0_asm_h, .Lfunc_end250-put_var_ref3_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_var_ref0_0_asm_h            // -- Begin function set_var_ref0_0_asm_h
	.p2align	2
	.type	set_var_ref0_0_asm_h,@function
set_var_ref0_0_asm_h:                   // @set_var_ref0_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB251_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB251_2:                              // %B1
	ldr	x8, [x26]
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end251:
	.size	set_var_ref0_0_asm_h, .Lfunc_end251-set_var_ref0_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_var_ref1_0_asm_h            // -- Begin function set_var_ref1_0_asm_h
	.p2align	2
	.type	set_var_ref1_0_asm_h,@function
set_var_ref1_0_asm_h:                   // @set_var_ref1_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB252_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB252_2:                              // %B1
	ldr	x8, [x26, #8]
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end252:
	.size	set_var_ref1_0_asm_h, .Lfunc_end252-set_var_ref1_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_var_ref2_0_asm_h            // -- Begin function set_var_ref2_0_asm_h
	.p2align	2
	.type	set_var_ref2_0_asm_h,@function
set_var_ref2_0_asm_h:                   // @set_var_ref2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB253_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB253_2:                              // %B1
	ldr	x8, [x26, #16]
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end253:
	.size	set_var_ref2_0_asm_h, .Lfunc_end253-set_var_ref2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_var_ref3_0_asm_h            // -- Begin function set_var_ref3_0_asm_h
	.p2align	2
	.type	set_var_ref3_0_asm_h,@function
set_var_ref3_0_asm_h:                   // @set_var_ref3_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB254_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB254_2:                              // %B1
	ldr	x8, [x26, #24]
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end254:
	.size	set_var_ref3_0_asm_h, .Lfunc_end254-set_var_ref3_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_length_0_asm_h              // -- Begin function get_length_0_asm_h
	.p2align	2
	.type	get_length_0_asm_h,@function
get_length_0_asm_h:                     // @get_length_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB255_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB255_2:                              // %B2
	ldur	x22, [x20, #-8]
	mov	w9, #48                         // =0x30
	mov	x21, x22
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB255_4
.LBB255_3:                              // %B8
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB255_4:                              // %B4
	mov	x0, x24
	mov	x1, x22
	mov	w2, #48                         // =0x30
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.ne	.LBB255_3
// %bb.5:                               // %B5
	b	exception_asm_h
.Lfunc_end255:
	.size	get_length_0_asm_h, .Lfunc_end255-get_length_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	if_false8_0_asm_h               // -- Begin function if_false8_0_asm_h
	.p2align	2
	.type	if_false8_0_asm_h,@function
if_false8_0_asm_h:                      // @if_false8_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B27
	ldr	w8, [x24, #336]
	cbz	w8, .LBB256_2
// %bb.1:                               // %B28
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB256_2:                              // %B24
	mov	x10, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	.LBB256_6
// %bb.3:                               // %B24
	cmp	x22, #6
	b.eq	.LBB256_8
// %bb.4:                               // %B24
	cmp	x22, #7
	b.eq	.LBB256_11
// %bb.5:                               // %B24
	cmp	x22, #18
	b.eq	.LBB256_8
	b	.LBB256_9
.LBB256_6:                              // %B24
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB256_8
// %bb.7:                               // %B24
	cmp	x22, #2
	b.ne	.LBB256_9
.LBB256_8:                              // %B4
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB256_9:                              // %B10
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB256_15
// %bb.10:                              // %B12
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB256_12
.LBB256_11:                             // %B20
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB256_12:                             // %B14
	tst	x22, #0xfffe000000000000
	b.eq	.LBB256_15
// %bb.13:                              // %B18
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB256_8
	b.vs	.LBB256_8
// %bb.14:                              // %B18
	tbnz	w8, #0, .LBB256_11
	b	.LBB256_8
.LBB256_15:                             // %B16
	mov	x20, x10
	mov	x9, x22
	b	SlowToBoolean_asm_h
.Lfunc_end256:
	.size	if_false8_0_asm_h, .Lfunc_end256-if_false8_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	if_true8_0_asm_h                // -- Begin function if_true8_0_asm_h
	.p2align	2
	.type	if_true8_0_asm_h,@function
if_true8_0_asm_h:                       // @if_true8_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B27
	ldr	w8, [x24, #336]
	cbz	w8, .LBB257_2
// %bb.1:                               // %B28
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB257_2:                              // %B24
	mov	x10, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	.LBB257_6
// %bb.3:                               // %B24
	cmp	x22, #6
	b.eq	.LBB257_8
// %bb.4:                               // %B24
	cmp	x22, #7
	b.eq	.LBB257_11
// %bb.5:                               // %B24
	cmp	x22, #18
	b.eq	.LBB257_8
	b	.LBB257_9
.LBB257_6:                              // %B24
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB257_8
// %bb.7:                               // %B24
	cmp	x22, #2
	b.ne	.LBB257_9
.LBB257_8:                              // %B4
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB257_9:                              // %B10
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB257_15
// %bb.10:                              // %B12
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB257_12
.LBB257_11:                             // %B20
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB257_12:                             // %B14
	tst	x22, #0xfffe000000000000
	b.eq	.LBB257_15
// %bb.13:                              // %B18
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB257_8
	b.vs	.LBB257_8
// %bb.14:                              // %B18
	tbnz	w8, #0, .LBB257_11
	b	.LBB257_8
.LBB257_15:                             // %B16
	mov	x20, x10
	mov	x9, x22
	b	SlowToBoolean_asm_h
.Lfunc_end257:
	.size	if_true8_0_asm_h, .Lfunc_end257-if_true8_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	goto8_0_asm_h                   // -- Begin function goto8_0_asm_h
	.p2align	2
	.type	goto8_0_asm_h,@function
goto8_0_asm_h:                          // @goto8_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB258_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB258_2:                              // %B1
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end258:
	.size	goto8_0_asm_h, .Lfunc_end258-goto8_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	goto16_0_asm_h                  // -- Begin function goto16_0_asm_h
	.p2align	2
	.type	goto16_0_asm_h,@function
goto16_0_asm_h:                         // @goto16_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB259_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB259_2:                              // %B1
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end259:
	.size	goto16_0_asm_h, .Lfunc_end259-goto16_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call0_0_asm_h                   // -- Begin function call0_0_asm_h
	.p2align	2
	.type	call0_0_asm_h,@function
call0_0_asm_h:                          // @call0_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB260_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB260_2:                              // %B3
	str	x19, [x29, #48]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	str	x20, [x29, #64]
	mov	x9, xzr
	ldur	x22, [x20, #-8]
	bl	common_call_asm_h
	mov	x8, x27
	ldr	x19, [x29, #48]
	ldr	x20, [x29, #64]
	ldp	x28, x27, [x29, #16]
	cmp	x8, #130
	ldp	x26, x23, [x29, #136]
	b.eq	.LBB260_4
// %bb.3:                               // %B5
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB260_4:                              // %B4
	b	exception_asm_h
.Lfunc_end260:
	.size	call0_0_asm_h, .Lfunc_end260-call0_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call1_0_asm_h                   // -- Begin function call1_0_asm_h
	.p2align	2
	.type	call1_0_asm_h,@function
call1_0_asm_h:                          // @call1_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB261_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB261_2:                              // %B3
	str	x19, [x29, #48]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	str	x20, [x29, #64]
	mov	w9, #1                          // =0x1
	ldur	x22, [x20, #-16]
	sub	x20, x20, #8
	bl	common_call_asm_h
	mov	x8, x27
	ldr	x19, [x29, #48]
	ldr	x20, [x29, #64]
	ldp	x28, x27, [x29, #16]
	cmp	x8, #130
	ldp	x26, x23, [x29, #136]
	b.eq	.LBB261_4
// %bb.3:                               // %B5
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB261_4:                              // %B4
	b	exception_asm_h
.Lfunc_end261:
	.size	call1_0_asm_h, .Lfunc_end261-call1_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call2_0_asm_h                   // -- Begin function call2_0_asm_h
	.p2align	2
	.type	call2_0_asm_h,@function
call2_0_asm_h:                          // @call2_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB262_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB262_2:                              // %B3
	str	x19, [x29, #48]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	str	x20, [x29, #64]
	mov	w9, #2                          // =0x2
	ldur	x22, [x20, #-24]
	sub	x20, x20, #16
	bl	common_call_asm_h
	mov	x8, x27
	ldr	x19, [x29, #48]
	ldr	x20, [x29, #64]
	ldp	x28, x27, [x29, #16]
	cmp	x8, #130
	ldp	x26, x23, [x29, #136]
	b.eq	.LBB262_4
// %bb.3:                               // %B5
	stur	x8, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB262_4:                              // %B4
	b	exception_asm_h
.Lfunc_end262:
	.size	call2_0_asm_h, .Lfunc_end262-call2_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call3_0_asm_h                   // -- Begin function call3_0_asm_h
	.p2align	2
	.type	call3_0_asm_h,@function
call3_0_asm_h:                          // @call3_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB263_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB263_2:                              // %B3
	str	x19, [x29, #48]
	mov	w27, #18                        // =0x12
	mov	w21, #18                        // =0x12
	str	x20, [x29, #64]
	mov	w9, #3                          // =0x3
	ldur	x22, [x20, #-32]
	sub	x20, x20, #24
	bl	common_call_asm_h
	mov	x8, x27
	ldr	x19, [x29, #48]
	ldr	x20, [x29, #64]
	ldp	x28, x27, [x29, #16]
	cmp	x8, #130
	ldp	x26, x23, [x29, #136]
	b.eq	.LBB263_4
// %bb.3:                               // %B5
	stur	x8, [x20, #-32]
	sub	x20, x20, #24
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB263_4:                              // %B4
	b	exception_asm_h
.Lfunc_end263:
	.size	call3_0_asm_h, .Lfunc_end263-call3_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	is_undefined_0_asm_h            // -- Begin function is_undefined_0_asm_h
	.p2align	2
	.type	is_undefined_0_asm_h,@function
is_undefined_0_asm_h:                   // @is_undefined_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	ldr	w8, [x24, #336]
	cbz	w8, .LBB264_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB264_2:                              // %B3
	ldur	x22, [x20, #-8]
	cmp	x22, #18
	b.ne	.LBB264_4
// %bb.3:                               // %B4
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB264_4:                              // %B6
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end264:
	.size	is_undefined_0_asm_h, .Lfunc_end264-is_undefined_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	is_null_0_asm_h                 // -- Begin function is_null_0_asm_h
	.p2align	2
	.type	is_null_0_asm_h,@function
is_null_0_asm_h:                        // @is_null_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	ldr	w8, [x24, #336]
	cbz	w8, .LBB265_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB265_2:                              // %B3
	ldur	x22, [x20, #-8]
	cmp	x22, #2
	b.ne	.LBB265_4
// %bb.3:                               // %B4
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB265_4:                              // %B6
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end265:
	.size	is_null_0_asm_h, .Lfunc_end265-is_null_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	is_function_0_asm_h             // -- Begin function is_function_0_asm_h
	.p2align	2
	.type	is_function_0_asm_h,@function
is_function_0_asm_h:                    // @is_function_0_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	ldr	w8, [x24, #336]
	cbz	w8, .LBB266_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB266_2:                              // %B2
	ldur	x22, [x20, #-8]
	mov	x0, x24
	mov	x1, x22
	bl	js_operator_typeof_gc
	cmp	w0, #27
	b.ne	.LBB266_4
// %bb.3:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB266_4:                              // %B6
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end266:
	.size	is_function_0_asm_h, .Lfunc_end266-is_function_0_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	invalid_1_asm_h                 // -- Begin function invalid_1_asm_h
	.p2align	2
	.type	invalid_1_asm_h,@function
invalid_1_asm_h:                        // @invalid_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B0
	ldr	x8, [x29, #8]
	adrp	x1, .L__unnamed_11
	add	x1, x1, :lo12:.L__unnamed_11
	mov	x0, x24
	mov	w3, wzr
	ldr	x8, [x8, #48]
	ldr	w8, [x8, #8]
	str	x20, [x29, #64]
	mvn	w8, w8
	add	w2, w8, w19
	bl	LEPUS_ThrowInternalError
	b	exception_asm_h
.Lfunc_end267:
	.size	invalid_1_asm_h, .Lfunc_end267-invalid_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_i32_1_asm_h                // -- Begin function push_i32_1_asm_h
	.p2align	2
	.type	push_i32_1_asm_h,@function
push_i32_1_asm_h:                       // @push_i32_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB268_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB268_2:                              // %B1
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	ldr	w10, [x19], #5
	ldr	x0, [x25, x8, lsl #3]
	orr	x21, x10, #0xfffe000000000000
	br	x0
.Lfunc_end268:
	.size	push_i32_1_asm_h, .Lfunc_end268-push_i32_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_const_1_asm_h              // -- Begin function push_const_1_asm_h
	.p2align	2
	.type	push_const_1_asm_h,@function
push_const_1_asm_h:                     // @push_const_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB269_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB269_2:                              // %B4
	ldrsw	x8, [x19]
	ldr	w10, [x24, #336]
	ldr	x11, [x23, x8, lsl #3]
	cbz	w10, .LBB269_4
// %bb.3:                               // %B5
	mov	x8, x20
	mov	x0, x24
	mov	x1, x11
	mov	x2, x19
	str	x22, [x8], #8
	str	x8, [x29, #64]
	str	x20, [sp, #8]                   // 8-byte Folded Spill
	mov	x20, x11
	bl	DebuggerPause
	mov	x11, x20
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
.LBB269_4:                              // %B2
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x21, x11
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.Lfunc_end269:
	.size	push_const_1_asm_h, .Lfunc_end269-push_const_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	fclosure_1_asm_h                // -- Begin function fclosure_1_asm_h
	.p2align	2
	.type	fclosure_1_asm_h,@function
fclosure_1_asm_h:                       // @fclosure_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB270_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB270_2:                              // %B2
	ldrsw	x8, [x19]
	mov	x10, x20
	mov	x0, x24
	mov	x2, x26
	mov	x3, x29
	ldr	x1, [x23, x8, lsl #3]
	str	x22, [x10], #8
	str	x10, [x29, #64]
	bl	js_closure_gc
	cmp	x0, #130
	b.eq	.LBB270_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB270_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end270:
	.size	fclosure_1_asm_h, .Lfunc_end270-fclosure_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_atom_value_1_asm_h         // -- Begin function push_atom_value_1_asm_h
	.p2align	2
	.type	push_atom_value_1_asm_h,@function
push_atom_value_1_asm_h:                // @push_atom_value_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB271_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB271_2:                              // %B2
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB271_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB271_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end271:
	.size	push_atom_value_1_asm_h, .Lfunc_end271-push_atom_value_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	private_symbol_1_asm_h          // -- Begin function private_symbol_1_asm_h
	.p2align	2
	.type	private_symbol_1_asm_h,@function
private_symbol_1_asm_h:                 // @private_symbol_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB272_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB272_2:                              // %B2
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #4                          // =0x4
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	.LBB272_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB272_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end272:
	.size	private_symbol_1_asm_h, .Lfunc_end272-private_symbol_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	undefined_1_asm_h               // -- Begin function undefined_1_asm_h
	.p2align	2
	.type	undefined_1_asm_h,@function
undefined_1_asm_h:                      // @undefined_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB273_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB273_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	w21, #18                        // =0x12
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end273:
	.size	undefined_1_asm_h, .Lfunc_end273-undefined_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	null_1_asm_h                    // -- Begin function null_1_asm_h
	.p2align	2
	.type	null_1_asm_h,@function
null_1_asm_h:                           // @null_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB274_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB274_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	w21, #2                         // =0x2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end274:
	.size	null_1_asm_h, .Lfunc_end274-null_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_this_1_asm_h               // -- Begin function push_this_1_asm_h
	.p2align	2
	.type	push_this_1_asm_h,@function
push_this_1_asm_h:                      // @push_this_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB275_2
// %bb.1:                               // %B17
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB275_2:                              // %B13
	ldr	w8, [x29, #60]
	ldr	x1, [x29, #120]
	tbnz	w8, #0, .LBB275_4
// %bb.3:                               // %B13
	ldr	x8, [x29, #120]
	and	x10, x8, #0xfffffffffffffffe
	and	x10, x10, #0xffff000000000003
	cbnz	x10, .LBB275_5
.LBB275_4:                              // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, x1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB275_5:                              // %B7
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	.LBB275_7
// %bb.6:                               // %B8
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x21, [x24, #224]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB275_7:                              // %B10
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB275_9
// %bb.8:                               // %B12
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB275_9:                              // %B11
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end275:
	.size	push_this_1_asm_h, .Lfunc_end275-push_this_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_false_1_asm_h              // -- Begin function push_false_1_asm_h
	.p2align	2
	.type	push_false_1_asm_h,@function
push_false_1_asm_h:                     // @push_false_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB276_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB276_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	w21, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end276:
	.size	push_false_1_asm_h, .Lfunc_end276-push_false_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_true_1_asm_h               // -- Begin function push_true_1_asm_h
	.p2align	2
	.type	push_true_1_asm_h,@function
push_true_1_asm_h:                      // @push_true_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB277_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB277_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	w21, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end277:
	.size	push_true_1_asm_h, .Lfunc_end277-push_true_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	object_1_asm_h                  // -- Begin function object_1_asm_h
	.p2align	2
	.type	object_1_asm_h,@function
object_1_asm_h:                         // @object_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB278_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB278_2:                              // %B2
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	.LBB278_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB278_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end278:
	.size	object_1_asm_h, .Lfunc_end278-object_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	special_object_1_asm_h          // -- Begin function special_object_1_asm_h
	.p2align	2
	.type	special_object_1_asm_h,@function
special_object_1_asm_h:                 // @special_object_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B24
	ldr	w8, [x24, #336]
	cbz	w8, .LBB279_2
// %bb.1:                               // %B25
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB279_2:                              // %B16
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	.LBB279_6
// %bb.3:                               // %B16
	cbz	w8, .LBB279_10
// %bb.4:                               // %B16
	cmp	w8, #1
	b.ne	.LBB279_15
// %bb.5:                               // %B7
	ldr	x8, [x29, #8]
	ldr	w1, [x29, #152]
	mov	x10, x20
	mov	x0, x24
	mov	x2, x28
	mov	x3, x29
	ldr	x8, [x8, #48]
	ldrh	w8, [x8, #40]
	str	x22, [x10], #8
	str	x10, [x29, #64]
	cmp	w8, w1
	csel	w4, w8, w1, lt
	bl	js_build_mapped_arguments_gc
	b	.LBB279_11
.LBB279_6:                              // %B16
	cmp	w8, #5
	b.eq	.LBB279_13
// %bb.7:                               // %B16
	cmp	w8, #4
	b.ne	.LBB279_16
// %bb.8:                               // %B10
	ldr	x8, [x29, #8]
	mov	w10, #18                        // =0x12
	ldr	x8, [x8, #64]
	cmp	x8, #0
	csel	x0, x10, x8, eq
.LBB279_9:                              // %B6
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	add	x19, x19, #2
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB279_10:                             // %B2
	ldr	w1, [x29, #152]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x28
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	js_build_arguments_gc
.LBB279_11:                             // %B7
	cmp	x0, #130
	b.ne	.LBB279_9
// %bb.12:                              // %B8
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.LBB279_13:                             // %B13
	mov	x8, x20
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.ne	.LBB279_9
// %bb.14:                              // %B14
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.LBB279_15:                             // %B19
	ldr	x0, [x29, #8]
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	add	x19, x19, #2
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB279_16:                             // %B20
	ldr	x0, [x29, #128]
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	add	x19, x19, #2
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end279:
	.size	special_object_1_asm_h, .Lfunc_end279-special_object_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	rest_1_asm_h                    // -- Begin function rest_1_asm_h
	.p2align	2
	.type	rest_1_asm_h,@function
rest_1_asm_h:                           // @rest_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB280_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB280_2:                              // %B2
	ldrh	w1, [x19]
	ldr	w2, [x29, #152]
	mov	x8, x20
	mov	x0, x24
	mov	x3, x28
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	js_build_rest_gc
	cmp	x0, #130
	b.eq	.LBB280_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #2]
	add	x25, x25, #1936
	add	x19, x19, #3
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB280_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end280:
	.size	rest_1_asm_h, .Lfunc_end280-rest_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	drop_1_asm_h                    // -- Begin function drop_1_asm_h
	.p2align	2
	.type	drop_1_asm_h,@function
drop_1_asm_h:                           // @drop_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB281_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB281_2:                              // %B1
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end281:
	.size	drop_1_asm_h, .Lfunc_end281-drop_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	nip_1_asm_h                     // -- Begin function nip_1_asm_h
	.p2align	2
	.type	nip_1_asm_h,@function
nip_1_asm_h:                            // @nip_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB282_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB282_2:                              // %B1
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end282:
	.size	nip_1_asm_h, .Lfunc_end282-nip_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	nip1_1_asm_h                    // -- Begin function nip1_1_asm_h
	.p2align	2
	.type	nip1_1_asm_h,@function
nip1_1_asm_h:                           // @nip1_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB283_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB283_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, x22
	ldur	x22, [x20, #-8]
	ldr	x0, [x25, x8, lsl #3]
	sub	x8, x20, #16
	mov	x20, x8
	br	x0
.Lfunc_end283:
	.size	nip1_1_asm_h, .Lfunc_end283-nip1_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dup_1_asm_h                     // -- Begin function dup_1_asm_h
	.p2align	2
	.type	dup_1_asm_h,@function
dup_1_asm_h:                            // @dup_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB284_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB284_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, x22
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end284:
	.size	dup_1_asm_h, .Lfunc_end284-dup_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dup1_1_asm_h                    // -- Begin function dup1_1_asm_h
	.p2align	2
	.type	dup1_1_asm_h,@function
dup1_1_asm_h:                           // @dup1_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB285_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB285_2:                              // %B1
	ldrb	w8, [x19], #1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x25, x25, #1936
	ldr	x1, [x25, x8, lsl #3]
	mov	x0, x22
	mov	x22, x21
	mov	x22, x0
	br	x1
.Lfunc_end285:
	.size	dup1_1_asm_h, .Lfunc_end285-dup1_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dup2_1_asm_h                    // -- Begin function dup2_1_asm_h
	.p2align	2
	.type	dup2_1_asm_h,@function
dup2_1_asm_h:                           // @dup2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB286_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB286_2:                              // %B1
	str	x22, [x20]
	add	x25, x25, #1936
	mov	x21, x22
	ldrb	w8, [x19], #1
	ldr	x22, [x20], #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end286:
	.size	dup2_1_asm_h, .Lfunc_end286-dup2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dup3_1_asm_h                    // -- Begin function dup3_1_asm_h
	.p2align	2
	.type	dup3_1_asm_h,@function
dup3_1_asm_h:                           // @dup3_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB287_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB287_2:                              // %B1
	ldur	x8, [x20, #-16]
	add	x25, x25, #1936
	mov	x21, x22
	stp	x22, x8, [x20], #16
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end287:
	.size	dup3_1_asm_h, .Lfunc_end287-dup3_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	insert2_1_asm_h                 // -- Begin function insert2_1_asm_h
	.p2align	2
	.type	insert2_1_asm_h,@function
insert2_1_asm_h:                        // @insert2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB288_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB288_2:                              // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x25, x25, #1936
	stur	x21, [x20, #-8]
	ldrb	w8, [x19], #1
	mov	x0, x22
	mov	x22, x21
	ldr	x1, [x25, x8, lsl #3]
	mov	x22, x0
	br	x1
.Lfunc_end288:
	.size	insert2_1_asm_h, .Lfunc_end288-insert2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	insert3_1_asm_h                 // -- Begin function insert3_1_asm_h
	.p2align	2
	.type	insert3_1_asm_h,@function
insert3_1_asm_h:                        // @insert3_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB289_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB289_2:                              // %B1
	mov	x21, x22
	ldp	x8, x22, [x20, #-16]
	add	x25, x25, #1936
	stp	x21, x8, [x20, #-16]
	mov	x1, x22
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x22, x1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end289:
	.size	insert3_1_asm_h, .Lfunc_end289-insert3_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	insert4_1_asm_h                 // -- Begin function insert4_1_asm_h
	.p2align	2
	.type	insert4_1_asm_h,@function
insert4_1_asm_h:                        // @insert4_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB290_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB290_2:                              // %B1
	ldp	x10, x8, [x20, #-24]
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x21, [x20, #-24]
	add	x25, x25, #1936
	stp	x10, x8, [x20, #-16]
	mov	x0, x22
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end290:
	.size	insert4_1_asm_h, .Lfunc_end290-insert4_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	perm3_1_asm_h                   // -- Begin function perm3_1_asm_h
	.p2align	2
	.type	perm3_1_asm_h,@function
perm3_1_asm_h:                          // @perm3_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB291_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB291_2:                              // %B1
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end291:
	.size	perm3_1_asm_h, .Lfunc_end291-perm3_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	perm4_1_asm_h                   // -- Begin function perm4_1_asm_h
	.p2align	2
	.type	perm4_1_asm_h,@function
perm4_1_asm_h:                          // @perm4_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB292_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB292_2:                              // %B1
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	mov	x10, x22
	ldp	x8, x22, [x20, #-16]
	stp	x10, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end292:
	.size	perm4_1_asm_h, .Lfunc_end292-perm4_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	perm5_1_asm_h                   // -- Begin function perm5_1_asm_h
	.p2align	2
	.type	perm5_1_asm_h,@function
perm5_1_asm_h:                          // @perm5_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB293_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB293_2:                              // %B1
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldp	x10, x8, [x20, #-24]
	add	x25, x25, #1936
	mov	x11, x22
	ldur	x22, [x20, #-8]
	stur	x11, [x20, #-24]
	stp	x10, x8, [x20, #-16]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end293:
	.size	perm5_1_asm_h, .Lfunc_end293-perm5_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	swap_1_asm_h                    // -- Begin function swap_1_asm_h
	.p2align	2
	.type	swap_1_asm_h,@function
swap_1_asm_h:                           // @swap_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB294_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB294_2:                              // %B1
	ldrb	w8, [x19], #1
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	add	x25, x25, #1936
	ldr	x1, [x25, x8, lsl #3]
	mov	x0, x22
	mov	x22, x21
	mov	x21, x0
	br	x1
.Lfunc_end294:
	.size	swap_1_asm_h, .Lfunc_end294-swap_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	swap2_1_asm_h                   // -- Begin function swap2_1_asm_h
	.p2align	2
	.type	swap2_1_asm_h,@function
swap2_1_asm_h:                          // @swap2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB295_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB295_2:                              // %B1
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldp	x8, x10, [x20, #-16]
	add	x25, x25, #1936
	stp	x22, x21, [x20, #-16]
	ldrb	w11, [x19], #1
	mov	x22, x8
	mov	x21, x10
	ldr	x0, [x25, x11, lsl #3]
	br	x0
.Lfunc_end295:
	.size	swap2_1_asm_h, .Lfunc_end295-swap2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	rot3l_1_asm_h                   // -- Begin function rot3l_1_asm_h
	.p2align	2
	.type	rot3l_1_asm_h,@function
rot3l_1_asm_h:                          // @rot3l_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB296_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB296_2:                              // %B1
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldur	x8, [x20, #-8]
	add	x25, x25, #1936
	stur	x22, [x20, #-8]
	mov	x22, x21
	ldrb	w10, [x19], #1
	mov	x21, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.Lfunc_end296:
	.size	rot3l_1_asm_h, .Lfunc_end296-rot3l_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	rot3r_1_asm_h                   // -- Begin function rot3r_1_asm_h
	.p2align	2
	.type	rot3r_1_asm_h,@function
rot3r_1_asm_h:                          // @rot3r_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB297_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB297_2:                              // %B1
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	mov	x8, x21
	add	x25, x25, #1936
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end297:
	.size	rot3r_1_asm_h, .Lfunc_end297-rot3r_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	rot4l_1_asm_h                   // -- Begin function rot4l_1_asm_h
	.p2align	2
	.type	rot4l_1_asm_h,@function
rot4l_1_asm_h:                          // @rot4l_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB298_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB298_2:                              // %B1
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldp	x10, x8, [x20, #-16]
	add	x25, x25, #1936
	stp	x8, x22, [x20, #-16]
	mov	x22, x21
	mov	x21, x10
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end298:
	.size	rot4l_1_asm_h, .Lfunc_end298-rot4l_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	rot5l_1_asm_h                   // -- Begin function rot5l_1_asm_h
	.p2align	2
	.type	rot5l_1_asm_h,@function
rot5l_1_asm_h:                          // @rot5l_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB299_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB299_2:                              // %B1
	mov	x21, x22
	ldr	x22, [x20, #-8]!
	ldp	x8, x10, [x20, #-16]
	ldur	x11, [x20, #-24]
	stur	x22, [x20, #-8]
	add	x25, x25, #1936
	mov	x22, x21
	mov	x21, x11
	stp	x8, x10, [x20, #-24]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end299:
	.size	rot5l_1_asm_h, .Lfunc_end299-rot5l_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call_constructor_1_asm_h        // -- Begin function call_constructor_1_asm_h
	.p2align	2
	.type	call_constructor_1_asm_h,@function
call_constructor_1_asm_h:               // @call_constructor_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB300_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB300_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	call_constructor_0_asm_h
.Lfunc_end300:
	.size	call_constructor_1_asm_h, .Lfunc_end300-call_constructor_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call_1_asm_h                    // -- Begin function call_1_asm_h
	.p2align	2
	.type	call_1_asm_h,@function
call_1_asm_h:                           // @call_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB301_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB301_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	call_0_asm_h
.Lfunc_end301:
	.size	call_1_asm_h, .Lfunc_end301-call_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	tail_call_1_asm_h               // -- Begin function tail_call_1_asm_h
	.p2align	2
	.type	tail_call_1_asm_h,@function
tail_call_1_asm_h:                      // @tail_call_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB302_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB302_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	tail_call_0_asm_h
.Lfunc_end302:
	.size	tail_call_1_asm_h, .Lfunc_end302-tail_call_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call_method_1_asm_h             // -- Begin function call_method_1_asm_h
	.p2align	2
	.type	call_method_1_asm_h,@function
call_method_1_asm_h:                    // @call_method_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB303_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB303_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	call_method_0_asm_h
.Lfunc_end303:
	.size	call_method_1_asm_h, .Lfunc_end303-call_method_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	tail_call_method_1_asm_h        // -- Begin function tail_call_method_1_asm_h
	.p2align	2
	.type	tail_call_method_1_asm_h,@function
tail_call_method_1_asm_h:               // @tail_call_method_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB304_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB304_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	tail_call_method_0_asm_h
.Lfunc_end304:
	.size	tail_call_method_1_asm_h, .Lfunc_end304-tail_call_method_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	array_from_1_asm_h              // -- Begin function array_from_1_asm_h
	.p2align	2
	.type	array_from_1_asm_h,@function
array_from_1_asm_h:                     // @array_from_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB305_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB305_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	array_from_0_asm_h
.Lfunc_end305:
	.size	array_from_1_asm_h, .Lfunc_end305-array_from_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	apply_1_asm_h                   // -- Begin function apply_1_asm_h
	.p2align	2
	.type	apply_1_asm_h,@function
apply_1_asm_h:                          // @apply_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB306_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB306_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	apply_0_asm_h
.Lfunc_end306:
	.size	apply_1_asm_h, .Lfunc_end306-apply_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	return_1_asm_h                  // -- Begin function return_1_asm_h
	.p2align	2
	.type	return_1_asm_h,@function
return_1_asm_h:                         // @return_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB307_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB307_2:                              // %B1
	sub	x25, x25, #1936
	mov	x27, x22
	b	common_return_asm_h
.Lfunc_end307:
	.size	return_1_asm_h, .Lfunc_end307-return_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	return_undef_1_asm_h            // -- Begin function return_undef_1_asm_h
	.p2align	2
	.type	return_undef_1_asm_h,@function
return_undef_1_asm_h:                   // @return_undef_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB308_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB308_2:                              // %B1
	sub	x25, x25, #1936
	mov	w27, #18                        // =0x12
	b	common_return_asm_h
.Lfunc_end308:
	.size	return_undef_1_asm_h, .Lfunc_end308-return_undef_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	check_ctor_return_1_asm_h       // -- Begin function check_ctor_return_1_asm_h
	.p2align	2
	.type	check_ctor_return_1_asm_h,@function
check_ctor_return_1_asm_h:              // @check_ctor_return_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB309_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB309_2:                              // %B6
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	.LBB309_5
// %bb.3:                               // %B3
	cmp	x22, #18
	b.eq	.LBB309_6
// %bb.4:                               // %B4
	mov	x8, x20
	adrp	x1, .L__unnamed_12
	add	x1, x1, :lo12:.L__unnamed_12
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_ThrowTypeError
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.LBB309_5:                              // %B7
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	w21, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB309_6:                              // %B5
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	w21, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end309:
	.size	check_ctor_return_1_asm_h, .Lfunc_end309-check_ctor_return_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	check_ctor_1_asm_h              // -- Begin function check_ctor_1_asm_h
	.p2align	2
	.type	check_ctor_1_asm_h,@function
check_ctor_1_asm_h:                     // @check_ctor_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB310_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB310_2:                              // %B3
	ldr	x8, [x29, #128]
	cmp	x8, #18
	b.ne	.LBB310_4
// %bb.3:                               // %B4
	mov	x8, x20
	adrp	x1, .L__unnamed_13
	add	x1, x1, :lo12:.L__unnamed_13
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_ThrowTypeError
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.LBB310_4:                              // %B5
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end310:
	.size	check_ctor_1_asm_h, .Lfunc_end310-check_ctor_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	check_brand_1_asm_h             // -- Begin function check_brand_1_asm_h
	.p2align	2
	.type	check_brand_1_asm_h,@function
check_brand_1_asm_h:                    // @check_brand_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB311_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB311_2:                              // %B2
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x29, #64]
	bl	JS_CheckBrand_GC
	tbnz	w0, #31, .LBB311_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB311_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end311:
	.size	check_brand_1_asm_h, .Lfunc_end311-check_brand_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	add_brand_1_asm_h               // -- Begin function add_brand_1_asm_h
	.p2align	2
	.type	add_brand_1_asm_h,@function
add_brand_1_asm_h:                      // @add_brand_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB312_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB312_2:                              // %B2
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x29, #64]
	bl	JS_AddBrand_GC
	tbnz	w0, #31, .LBB312_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB312_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end312:
	.size	add_brand_1_asm_h, .Lfunc_end312-add_brand_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	return_async_1_asm_h            // -- Begin function return_async_1_asm_h
	.p2align	2
	.type	return_async_1_asm_h,@function
return_async_1_asm_h:                   // @return_async_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB313_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB313_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	return_async_0_asm_h
.Lfunc_end313:
	.size	return_async_1_asm_h, .Lfunc_end313-return_async_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	throw_1_asm_h                   // -- Begin function throw_1_asm_h
	.p2align	2
	.type	throw_1_asm_h,@function
throw_1_asm_h:                          // @throw_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB314_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB314_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	throw_0_asm_h
.Lfunc_end314:
	.size	throw_1_asm_h, .Lfunc_end314-throw_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	throw_var_1_asm_h               // -- Begin function throw_var_1_asm_h
	.p2align	2
	.type	throw_var_1_asm_h,@function
throw_var_1_asm_h:                      // @throw_var_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB315_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB315_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	throw_var_0_asm_h
.Lfunc_end315:
	.size	throw_var_1_asm_h, .Lfunc_end315-throw_var_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	eval_1_asm_h                    // -- Begin function eval_1_asm_h
	.p2align	2
	.type	eval_1_asm_h,@function
eval_1_asm_h:                           // @eval_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB316_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB316_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	eval_0_asm_h
.Lfunc_end316:
	.size	eval_1_asm_h, .Lfunc_end316-eval_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	regexp_1_asm_h                  // -- Begin function regexp_1_asm_h
	.p2align	2
	.type	regexp_1_asm_h,@function
regexp_1_asm_h:                         // @regexp_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB317_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB317_2:                              // %B2
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	w1, #18                         // =0x12
	mov	x3, x21
	mov	x2, x22
	str	x21, [x20]
	str	x8, [x29, #64]
	bl	js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	.LBB317_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB317_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end317:
	.size	regexp_1_asm_h, .Lfunc_end317-regexp_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_super_ctor_1_asm_h          // -- Begin function get_super_ctor_1_asm_h
	.p2align	2
	.type	get_super_ctor_1_asm_h,@function
get_super_ctor_1_asm_h:                 // @get_super_ctor_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB318_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB318_2:                              // %B2
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	.LBB318_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB318_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end318:
	.size	get_super_ctor_1_asm_h, .Lfunc_end318-get_super_ctor_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_super_1_asm_h               // -- Begin function get_super_1_asm_h
	.p2align	2
	.type	get_super_1_asm_h,@function
get_super_1_asm_h:                      // @get_super_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB319_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB319_2:                              // %B2
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_GetPrototype
	cmp	x0, #130
	b.eq	.LBB319_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB319_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end319:
	.size	get_super_1_asm_h, .Lfunc_end319-get_super_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	import_1_asm_h                  // -- Begin function import_1_asm_h
	.p2align	2
	.type	import_1_asm_h,@function
import_1_asm_h:                         // @import_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB320_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB320_2:                              // %B2
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	js_dynamic_import
	cmp	x0, #130
	b.eq	.LBB320_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB320_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end320:
	.size	import_1_asm_h, .Lfunc_end320-import_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	check_var_1_asm_h               // -- Begin function check_var_1_asm_h
	.p2align	2
	.type	check_var_1_asm_h,@function
check_var_1_asm_h:                      // @check_var_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB321_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB321_2:                              // %B2
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_CheckGlobalVar_GC
	tbnz	w0, #31, .LBB321_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	cmp	w0, #0
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x21, x8, ne
	br	x0
.LBB321_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end321:
	.size	check_var_1_asm_h, .Lfunc_end321-check_var_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_undef_1_asm_h           // -- Begin function get_var_undef_1_asm_h
	.p2align	2
	.type	get_var_undef_1_asm_h,@function
get_var_undef_1_asm_h:                  // @get_var_undef_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B12
	ldr	w8, [x24, #336]
	cbz	w8, .LBB322_2
// %bb.1:                               // %B13
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB322_2:                              // %B2
	ldr	w9, [x19]
	bl	common_get_var_undef_asm_h
	cmp	x0, #130
	b.eq	.LBB322_5
// %bb.3:                               // %B2
	cmp	x0, #34
	b.eq	.LBB322_7
.LBB322_4:                              // %B11
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB322_5:                              // %B4
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.ne	.LBB322_4
// %bb.6:                               // %B5
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.LBB322_7:                              // %B10
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end322:
	.size	get_var_undef_1_asm_h, .Lfunc_end322-get_var_undef_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_1_asm_h                 // -- Begin function get_var_1_asm_h
	.p2align	2
	.type	get_var_1_asm_h,@function
get_var_1_asm_h:                        // @get_var_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B12
	ldr	w8, [x24, #336]
	cbz	w8, .LBB323_2
// %bb.1:                               // %B13
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB323_2:                              // %B2
	ldr	w9, [x19]
	bl	common_get_var_asm_h
	cmp	x0, #130
	b.eq	.LBB323_5
// %bb.3:                               // %B2
	cmp	x0, #34
	b.eq	.LBB323_7
.LBB323_4:                              // %B11
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB323_5:                              // %B4
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.ne	.LBB323_4
// %bb.6:                               // %B5
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.LBB323_7:                              // %B10
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end323:
	.size	get_var_1_asm_h, .Lfunc_end323-get_var_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_1_asm_h                 // -- Begin function put_var_1_asm_h
	.p2align	2
	.type	put_var_1_asm_h,@function
put_var_1_asm_h:                        // @put_var_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB324_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB324_2:                              // %B2
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	w3, wzr
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB324_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB324_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end324:
	.size	put_var_1_asm_h, .Lfunc_end324-put_var_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_init_1_asm_h            // -- Begin function put_var_init_1_asm_h
	.p2align	2
	.type	put_var_init_1_asm_h,@function
put_var_init_1_asm_h:                   // @put_var_init_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB325_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB325_2:                              // %B2
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	w3, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB325_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB325_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end325:
	.size	put_var_init_1_asm_h, .Lfunc_end325-put_var_init_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_strict_1_asm_h          // -- Begin function put_var_strict_1_asm_h
	.p2align	2
	.type	put_var_strict_1_asm_h,@function
put_var_strict_1_asm_h:                 // @put_var_strict_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB326_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB326_2:                              // %B6
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	cmp	x22, #7
	b.ne	.LBB326_5
// %bb.3:                               // %B2
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          // =0x2
	stur	x21, [x8, #-8]
	str	x8, [x29, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB326_6
// %bb.4:                               // %B5
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB326_5:                              // %B7
	ldr	w1, [x19]
	mov	x0, x24
	str	x21, [x20]
	str	x8, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB326_6:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end326:
	.size	put_var_strict_1_asm_h, .Lfunc_end326-put_var_strict_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_ref_value_1_asm_h           // -- Begin function get_ref_value_1_asm_h
	.p2align	2
	.type	get_ref_value_1_asm_h,@function
get_ref_value_1_asm_h:                  // @get_ref_value_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B12
	ldr	w8, [x24, #336]
	cbz	w8, .LBB327_2
// %bb.1:                               // %B13
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB327_2:                              // %B9
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	str	x21, [x20]
	cmp	x22, #18
	str	x8, [x29, #64]
	b.eq	.LBB327_5
// %bb.3:                               // %B2
	mov	x1, x22
	mov	x2, x21
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB327_7
// %bb.4:                               // %B5
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB327_5:                              // %B6
	mov	x1, x21
	bl	js_value_to_atom_gc
	cbz	w0, .LBB327_7
// %bb.6:                               // %B8
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB327_7:                              // %B7
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end327:
	.size	get_ref_value_1_asm_h, .Lfunc_end327-get_ref_value_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_ref_value_1_asm_h           // -- Begin function put_ref_value_1_asm_h
	.p2align	2
	.type	put_ref_value_1_asm_h,@function
put_ref_value_1_asm_h:                  // @put_ref_value_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB328_2
// %bb.1:                               // %B17
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB328_2:                              // %B13
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	cmp	x1, #18
	b.eq	.LBB328_5
.LBB328_3:                              // %B2
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_SetPropertyValue_GC
	tbnz	w0, #31, .LBB328_9
// %bb.4:                               // %B5
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB328_5:                              // %B9
	ldrb	w8, [x29, #60]
	tbnz	w8, #0, .LBB328_7
// %bb.6:                               // %B10
	ldr	x1, [x24, #224]
	b	.LBB328_3
.LBB328_7:                              // %B6
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB328_9
// %bb.8:                               // %B8
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB328_9:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end328:
	.size	put_ref_value_1_asm_h, .Lfunc_end328-put_ref_value_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_var_1_asm_h              // -- Begin function define_var_1_asm_h
	.p2align	2
	.type	define_var_1_asm_h,@function
define_var_1_asm_h:                     // @define_var_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB329_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB329_2:                              // %B2
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_DefineGlobalVar_GC
	tbnz	w0, #31, .LBB329_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB329_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end329:
	.size	define_var_1_asm_h, .Lfunc_end329-define_var_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	check_define_var_1_asm_h        // -- Begin function check_define_var_1_asm_h
	.p2align	2
	.type	check_define_var_1_asm_h,@function
check_define_var_1_asm_h:               // @check_define_var_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB330_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB330_2:                              // %B2
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, .LBB330_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB330_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end330:
	.size	check_define_var_1_asm_h, .Lfunc_end330-check_define_var_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_func_1_asm_h             // -- Begin function define_func_1_asm_h
	.p2align	2
	.type	define_func_1_asm_h,@function
define_func_1_asm_h:                    // @define_func_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB331_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB331_2:                              // %B2
	ldr	w1, [x19]
	ldrb	w3, [x19, #4]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_DefineGlobalFunction_GC
	tbnz	w0, #31, .LBB331_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #5]
	sub	x25, x25, #1936
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB331_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end331:
	.size	define_func_1_asm_h, .Lfunc_end331-define_func_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_field_1_asm_h               // -- Begin function get_field_1_asm_h
	.p2align	2
	.type	get_field_1_asm_h,@function
get_field_1_asm_h:                      // @get_field_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB332_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB332_2:                              // %B2
	ldr	w9, [x19]
	mov	x21, x22
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB332_4
.LBB332_3:                              // %B8
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB332_4:                              // %B4
	ldr	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.ne	.LBB332_3
// %bb.5:                               // %B5
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end332:
	.size	get_field_1_asm_h, .Lfunc_end332-get_field_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_field2_1_asm_h              // -- Begin function get_field2_1_asm_h
	.p2align	2
	.type	get_field2_1_asm_h,@function
get_field2_1_asm_h:                     // @get_field2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB333_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB333_2:                              // %B2
	ldr	w9, [x19]
	mov	x21, x22
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB333_4
.LBB333_3:                              // %B8
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB333_4:                              // %B4
	ldr	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.ne	.LBB333_3
// %bb.5:                               // %B5
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end333:
	.size	get_field2_1_asm_h, .Lfunc_end333-get_field2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_field_1_asm_h               // -- Begin function put_field_1_asm_h
	.p2align	2
	.type	put_field_1_asm_h,@function
put_field_1_asm_h:                      // @put_field_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB334_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB334_2:                              // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, x20
	add	x20, x20, #8
	str	x21, [x8]
	sub	x25, x25, #1936
	b	common_set_property_asm_h
.Lfunc_end334:
	.size	put_field_1_asm_h, .Lfunc_end334-put_field_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_private_field_1_asm_h       // -- Begin function get_private_field_1_asm_h
	.p2align	2
	.type	get_private_field_1_asm_h,@function
get_private_field_1_asm_h:              // @get_private_field_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB335_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB335_2:                              // %B2
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x29, #64]
	bl	JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	.LBB335_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB335_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end335:
	.size	get_private_field_1_asm_h, .Lfunc_end335-get_private_field_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_private_field_1_asm_h       // -- Begin function put_private_field_1_asm_h
	.p2align	2
	.type	put_private_field_1_asm_h,@function
put_private_field_1_asm_h:              // @put_private_field_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB336_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB336_2:                              // %B2
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x3, x22
	str	x8, [x29, #64]
	bl	JS_SetPrivateField_GC
	tbnz	w0, #31, .LBB336_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB336_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end336:
	.size	put_private_field_1_asm_h, .Lfunc_end336-put_private_field_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_private_field_1_asm_h    // -- Begin function define_private_field_1_asm_h
	.p2align	2
	.type	define_private_field_1_asm_h,@function
define_private_field_1_asm_h:           // @define_private_field_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB337_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB337_2:                              // %B2
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	add	x8, x20, #8
	mov	x0, x24
	mov	x3, x21
	str	x21, [x20]
	mov	x2, x22
	str	x8, [x29, #64]
	bl	JS_DefinePrivateField_GC
	tbnz	w0, #31, .LBB337_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB337_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end337:
	.size	define_private_field_1_asm_h, .Lfunc_end337-define_private_field_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_array_el_1_asm_h            // -- Begin function get_array_el_1_asm_h
	.p2align	2
	.type	get_array_el_1_asm_h,@function
get_array_el_1_asm_h:                   // @get_array_el_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB338_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB338_2:                              // %B6
	mov	x21, x22
	ldur	x22, [x20, #-8]
	bl	common_get_property_value_asm_h
	cmp	x0, #130
	b.eq	.LBB338_4
.LBB338_3:                              // %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB338_4:                              // %B2
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.ne	.LBB338_3
// %bb.5:                               // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end338:
	.size	get_array_el_1_asm_h, .Lfunc_end338-get_array_el_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_array_el2_1_asm_h           // -- Begin function get_array_el2_1_asm_h
	.p2align	2
	.type	get_array_el2_1_asm_h,@function
get_array_el2_1_asm_h:                  // @get_array_el2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB339_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB339_2:                              // %B6
	mov	x21, x22
	ldur	x22, [x20, #-8]
	bl	common_get_property_value_asm_h
	cmp	x0, #130
	b.eq	.LBB339_4
.LBB339_3:                              // %B8
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB339_4:                              // %B2
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.ne	.LBB339_3
// %bb.5:                               // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end339:
	.size	get_array_el2_1_asm_h, .Lfunc_end339-get_array_el2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_array_el_1_asm_h            // -- Begin function put_array_el_1_asm_h
	.p2align	2
	.type	put_array_el_1_asm_h,@function
put_array_el_1_asm_h:                   // @put_array_el_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB340_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB340_2:                              // %B1
	mov	x21, x22
	ldp	x9, x22, [x20, #-16]
	mov	x8, x20
	add	x20, x20, #8
	sub	x25, x25, #1936
	str	x21, [x8]
	b	common_set_property_value_asm_h
.Lfunc_end340:
	.size	put_array_el_1_asm_h, .Lfunc_end340-put_array_el_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_super_value_1_asm_h         // -- Begin function get_super_value_1_asm_h
	.p2align	2
	.type	get_super_value_1_asm_h,@function
get_super_value_1_asm_h:                // @get_super_value_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB341_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB341_2:                              // %B2
	mov	x21, x22
	str	x19, [sp, #8]                   // 8-byte Folded Spill
	add	x19, x20, #8
	ldur	x22, [x20, #-8]
	mov	x0, x24
	mov	x1, x21
	str	x21, [x20]
	str	x19, [x29, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB341_5
// %bb.3:                               // %B6
	ldur	x3, [x20, #-16]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	str	x21, [x20]
	str	x19, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB341_5
// %bb.4:                               // %B8
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	stur	x0, [x20, #-16]
	sub	x25, x25, #1936
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.LBB341_5:                              // %B3
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	sub	x25, x25, #1936
	add	sp, sp, #16
	b	exception_spill_top1_asm_h
.Lfunc_end341:
	.size	get_super_value_1_asm_h, .Lfunc_end341-get_super_value_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_super_value_1_asm_h         // -- Begin function put_super_value_1_asm_h
	.p2align	2
	.type	put_super_value_1_asm_h,@function
put_super_value_1_asm_h:                // @put_super_value_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB342_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB342_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	put_super_value_0_asm_h
.Lfunc_end342:
	.size	put_super_value_1_asm_h, .Lfunc_end342-put_super_value_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_field_1_asm_h            // -- Begin function define_field_1_asm_h
	.p2align	2
	.type	define_field_1_asm_h,@function
define_field_1_asm_h:                   // @define_field_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB343_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB343_2:                              // %B2
	mov	x21, x22
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	add	x8, x20, #8
	mov	x0, x24
	mov	x3, x21
	mov	x1, x22
	mov	w4, #16391                      // =0x4007
	str	x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_DefinePropertyValue
	tbnz	w0, #31, .LBB343_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB343_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end343:
	.size	define_field_1_asm_h, .Lfunc_end343-define_field_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_name_1_asm_h                // -- Begin function set_name_1_asm_h
	.p2align	2
	.type	set_name_1_asm_h,@function
set_name_1_asm_h:                       // @set_name_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB344_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB344_2:                              // %B2
	ldr	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w3, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_DefineObjectName
	tbnz	w0, #31, .LBB344_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB344_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end344:
	.size	set_name_1_asm_h, .Lfunc_end344-set_name_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_name_computed_1_asm_h       // -- Begin function set_name_computed_1_asm_h
	.p2align	2
	.type	set_name_computed_1_asm_h,@function
set_name_computed_1_asm_h:              // @set_name_computed_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB345_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB345_2:                              // %B2
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x1, x21
	mov	w3, #1                          // =0x1
	mov	x2, x22
	str	x21, [x20]
	str	x8, [x29, #64]
	bl	JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, .LBB345_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB345_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end345:
	.size	set_name_computed_1_asm_h, .Lfunc_end345-set_name_computed_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_proto_1_asm_h               // -- Begin function set_proto_1_asm_h
	.p2align	2
	.type	set_proto_1_asm_h,@function
set_proto_1_asm_h:                      // @set_proto_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B10
	ldr	w8, [x24, #336]
	cbz	w8, .LBB346_2
// %bb.1:                               // %B11
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB346_2:                              // %B7
	mov	x8, #2                          // =0x2
	mov	x21, x22
	ldur	x22, [x20, #-8]
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB346_5
// %bb.3:                               // %B7
	cmp	x21, #2
	b.eq	.LBB346_5
.LBB346_4:                              // %B6
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB346_5:                              // %B2
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_SetPrototypeInternal_GC
	tbz	w0, #31, .LBB346_4
// %bb.6:                               // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end346:
	.size	set_proto_1_asm_h, .Lfunc_end346-set_proto_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_home_object_1_asm_h         // -- Begin function set_home_object_1_asm_h
	.p2align	2
	.type	set_home_object_1_asm_h,@function
set_home_object_1_asm_h:                // @set_home_object_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB347_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB347_2:                              // %B1
	mov	x10, x20
	mov	x21, x22
	add	x8, x20, #8
	ldr	x22, [x10, #-8]!
	mov	x0, x24
	mov	x1, x21
	str	x10, [sp, #8]                   // 8-byte Folded Spill
	mov	x2, x22
	str	x21, [x20]
	str	x8, [x29, #64]
	bl	js_method_set_home_object_gc
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.Lfunc_end347:
	.size	set_home_object_1_asm_h, .Lfunc_end347-set_home_object_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_array_el_1_asm_h         // -- Begin function define_array_el_1_asm_h
	.p2align	2
	.type	define_array_el_1_asm_h,@function
define_array_el_1_asm_h:                // @define_array_el_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB348_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB348_2:                              // %B2
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	add	x8, x20, #8
	mov	x0, x24
	mov	x3, x21
	mov	w4, #16391                      // =0x4007
	str	x21, [x20]
	mov	x2, x22
	str	x8, [x29, #64]
	bl	JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, .LBB348_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB348_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end348:
	.size	define_array_el_1_asm_h, .Lfunc_end348-define_array_el_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	append_1_asm_h                  // -- Begin function append_1_asm_h
	.p2align	2
	.type	append_1_asm_h,@function
append_1_asm_h:                         // @append_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB349_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB349_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	append_0_asm_h
.Lfunc_end349:
	.size	append_1_asm_h, .Lfunc_end349-append_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	copy_data_properties_1_asm_h    // -- Begin function copy_data_properties_1_asm_h
	.p2align	2
	.type	copy_data_properties_1_asm_h,@function
copy_data_properties_1_asm_h:           // @copy_data_properties_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB350_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB350_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	copy_data_properties_0_asm_h
.Lfunc_end350:
	.size	copy_data_properties_1_asm_h, .Lfunc_end350-copy_data_properties_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_method_1_asm_h           // -- Begin function define_method_1_asm_h
	.p2align	2
	.type	define_method_1_asm_h,@function
define_method_1_asm_h:                  // @define_method_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB351_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB351_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	define_method_0_asm_h
.Lfunc_end351:
	.size	define_method_1_asm_h, .Lfunc_end351-define_method_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_method_computed_1_asm_h  // -- Begin function define_method_computed_1_asm_h
	.p2align	2
	.type	define_method_computed_1_asm_h,@function
define_method_computed_1_asm_h:         // @define_method_computed_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB352_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB352_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	define_method_computed_0_asm_h
.Lfunc_end352:
	.size	define_method_computed_1_asm_h, .Lfunc_end352-define_method_computed_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_class_1_asm_h            // -- Begin function define_class_1_asm_h
	.p2align	2
	.type	define_class_1_asm_h,@function
define_class_1_asm_h:                   // @define_class_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB353_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB353_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	define_class_0_asm_h
.Lfunc_end353:
	.size	define_class_1_asm_h, .Lfunc_end353-define_class_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc_1_asm_h                 // -- Begin function get_loc_1_asm_h
	.p2align	2
	.type	get_loc_1_asm_h,@function
get_loc_1_asm_h:                        // @get_loc_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB354_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB354_2:                              // %B1
	ldrb	w8, [x19, #2]
	ldrh	w10, [x19], #3
	add	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	ldr	x21, [x27, x10, lsl #3]
	br	x0
.Lfunc_end354:
	.size	get_loc_1_asm_h, .Lfunc_end354-get_loc_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc_1_asm_h                 // -- Begin function put_loc_1_asm_h
	.p2align	2
	.type	put_loc_1_asm_h,@function
put_loc_1_asm_h:                        // @put_loc_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB355_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB355_2:                              // %B1
	ldrh	w8, [x19]
	sub	x25, x25, #1936
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end355:
	.size	put_loc_1_asm_h, .Lfunc_end355-put_loc_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc_1_asm_h                 // -- Begin function set_loc_1_asm_h
	.p2align	2
	.type	set_loc_1_asm_h,@function
set_loc_1_asm_h:                        // @set_loc_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB356_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB356_2:                              // %B1
	ldrh	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end356:
	.size	set_loc_1_asm_h, .Lfunc_end356-set_loc_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_arg_1_asm_h                 // -- Begin function get_arg_1_asm_h
	.p2align	2
	.type	get_arg_1_asm_h,@function
get_arg_1_asm_h:                        // @get_arg_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB357_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB357_2:                              // %B1
	ldrb	w8, [x19, #2]
	ldrh	w10, [x19], #3
	add	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	ldr	x21, [x28, x10, lsl #3]
	br	x0
.Lfunc_end357:
	.size	get_arg_1_asm_h, .Lfunc_end357-get_arg_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_arg_1_asm_h                 // -- Begin function put_arg_1_asm_h
	.p2align	2
	.type	put_arg_1_asm_h,@function
put_arg_1_asm_h:                        // @put_arg_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB358_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB358_2:                              // %B1
	ldrh	w8, [x19]
	sub	x25, x25, #1936
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end358:
	.size	put_arg_1_asm_h, .Lfunc_end358-put_arg_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_arg_1_asm_h                 // -- Begin function set_arg_1_asm_h
	.p2align	2
	.type	set_arg_1_asm_h,@function
set_arg_1_asm_h:                        // @set_arg_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB359_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB359_2:                              // %B1
	ldrh	w8, [x19]
	str	x22, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end359:
	.size	set_arg_1_asm_h, .Lfunc_end359-set_arg_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref_1_asm_h             // -- Begin function get_var_ref_1_asm_h
	.p2align	2
	.type	get_var_ref_1_asm_h,@function
get_var_ref_1_asm_h:                    // @get_var_ref_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB360_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB360_2:                              // %B1
	ldrh	w8, [x19]
	ldrb	w10, [x19, #2]
	add	x25, x25, #1936
	add	x19, x19, #3
	ldr	x8, [x26, x8, lsl #3]
	ldr	x0, [x25, x10, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x21, [x8]
	br	x0
.Lfunc_end360:
	.size	get_var_ref_1_asm_h, .Lfunc_end360-get_var_ref_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref_1_asm_h             // -- Begin function put_var_ref_1_asm_h
	.p2align	2
	.type	put_var_ref_1_asm_h,@function
put_var_ref_1_asm_h:                    // @put_var_ref_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB361_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB361_2:                              // %B1
	ldrh	w8, [x19]
	sub	x25, x25, #1936
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end361:
	.size	put_var_ref_1_asm_h, .Lfunc_end361-put_var_ref_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_var_ref_1_asm_h             // -- Begin function set_var_ref_1_asm_h
	.p2align	2
	.type	set_var_ref_1_asm_h,@function
set_var_ref_1_asm_h:                    // @set_var_ref_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB362_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB362_2:                              // %B1
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end362:
	.size	set_var_ref_1_asm_h, .Lfunc_end362-set_var_ref_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc_uninitialized_1_asm_h   // -- Begin function set_loc_uninitialized_1_asm_h
	.p2align	2
	.type	set_loc_uninitialized_1_asm_h,@function
set_loc_uninitialized_1_asm_h:          // @set_loc_uninitialized_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB363_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB363_2:                              // %B1
	ldrh	w8, [x19]
	mov	w10, #34                        // =0x22
	str	x10, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end363:
	.size	set_loc_uninitialized_1_asm_h, .Lfunc_end363-set_loc_uninitialized_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc_check_1_asm_h           // -- Begin function get_loc_check_1_asm_h
	.p2align	2
	.type	get_loc_check_1_asm_h,@function
get_loc_check_1_asm_h:                  // @get_loc_check_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB364_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB364_2:                              // %B3
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	.LBB364_4
// %bb.3:                               // %B5
	ldrb	w10, [x19, #2]
	add	x25, x25, #1936
	add	x19, x19, #3
	mov	x21, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB364_4:                              // %B4
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end364:
	.size	get_loc_check_1_asm_h, .Lfunc_end364-get_loc_check_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc_check_1_asm_h           // -- Begin function put_loc_check_1_asm_h
	.p2align	2
	.type	put_loc_check_1_asm_h,@function
put_loc_check_1_asm_h:                  // @put_loc_check_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB365_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB365_2:                              // %B3
	ldrh	w8, [x19]
	ldr	x10, [x27, x8, lsl #3]
	cmp	x10, #34
	b.eq	.LBB365_4
// %bb.3:                               // %B5
	str	x22, [x27, w8, uxtw #3]
	sub	x25, x25, #1936
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB365_4:                              // %B4
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end365:
	.size	put_loc_check_1_asm_h, .Lfunc_end365-put_loc_check_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc_check_init_1_asm_h      // -- Begin function put_loc_check_init_1_asm_h
	.p2align	2
	.type	put_loc_check_init_1_asm_h,@function
put_loc_check_init_1_asm_h:             // @put_loc_check_init_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB366_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB366_2:                              // %B3
	ldrh	w8, [x19]
	ldr	x10, [x27, x8, lsl #3]
	cmp	x10, #34
	b.ne	.LBB366_4
// %bb.3:                               // %B5
	str	x22, [x27, w8, uxtw #3]
	sub	x25, x25, #1936
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB366_4:                              // %B4
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	ThrowThisReferenceError_asm_h
.Lfunc_end366:
	.size	put_loc_check_init_1_asm_h, .Lfunc_end366-put_loc_check_init_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref_check_1_asm_h       // -- Begin function get_var_ref_check_1_asm_h
	.p2align	2
	.type	get_var_ref_check_1_asm_h,@function
get_var_ref_check_1_asm_h:              // @get_var_ref_check_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB367_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB367_2:                              // %B3
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB367_4
// %bb.3:                               // %B5
	ldrb	w10, [x19, #2]
	add	x25, x25, #1936
	add	x19, x19, #3
	mov	x21, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB367_4:                              // %B4
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end367:
	.size	get_var_ref_check_1_asm_h, .Lfunc_end367-get_var_ref_check_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref_check_1_asm_h       // -- Begin function put_var_ref_check_1_asm_h
	.p2align	2
	.type	put_var_ref_check_1_asm_h,@function
put_var_ref_check_1_asm_h:              // @put_var_ref_check_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB368_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB368_2:                              // %B3
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x10, [x8]
	cmp	x10, #34
	b.eq	.LBB368_4
// %bb.3:                               // %B5
	str	x22, [x8]
	sub	x25, x25, #1936
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB368_4:                              // %B4
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end368:
	.size	put_var_ref_check_1_asm_h, .Lfunc_end368-put_var_ref_check_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref_check_init_1_asm_h  // -- Begin function put_var_ref_check_init_1_asm_h
	.p2align	2
	.type	put_var_ref_check_init_1_asm_h,@function
put_var_ref_check_init_1_asm_h:         // @put_var_ref_check_init_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB369_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB369_2:                              // %B3
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x10, [x8]
	cmp	x10, #34
	b.ne	.LBB369_4
// %bb.3:                               // %B5
	str	x22, [x8]
	sub	x25, x25, #1936
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB369_4:                              // %B4
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end369:
	.size	put_var_ref_check_init_1_asm_h, .Lfunc_end369-put_var_ref_check_init_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	close_loc_1_asm_h               // -- Begin function close_loc_1_asm_h
	.p2align	2
	.type	close_loc_1_asm_h,@function
close_loc_1_asm_h:                      // @close_loc_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB370_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB370_2:                              // %B1
	ldrh	w2, [x19]
	mov	x0, x24
	mov	x1, x29
	bl	close_lexical_var
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end370:
	.size	close_loc_1_asm_h, .Lfunc_end370-close_loc_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	if_false_1_asm_h                // -- Begin function if_false_1_asm_h
	.p2align	2
	.type	if_false_1_asm_h,@function
if_false_1_asm_h:                       // @if_false_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B27
	ldr	w8, [x24, #336]
	cbz	w8, .LBB371_2
// %bb.1:                               // %B28
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB371_2:                              // %B24
	cmp	x22, #5
	b.le	.LBB371_6
// %bb.3:                               // %B24
	cmp	x22, #6
	b.eq	.LBB371_8
// %bb.4:                               // %B24
	cmp	x22, #7
	b.eq	.LBB371_11
// %bb.5:                               // %B24
	cmp	x22, #18
	b.eq	.LBB371_8
	b	.LBB371_9
.LBB371_6:                              // %B24
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB371_8
// %bb.7:                               // %B24
	cmp	x22, #2
	b.ne	.LBB371_9
.LBB371_8:                              // %B4
	ldrsw	x8, [x19]
	sub	x25, x25, #1936
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB371_9:                              // %B10
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB371_15
// %bb.10:                              // %B12
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB371_12
.LBB371_11:                             // %B20
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB371_12:                             // %B14
	tst	x22, #0xfffe000000000000
	b.eq	.LBB371_15
// %bb.13:                              // %B18
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB371_8
	b.vs	.LBB371_8
// %bb.14:                              // %B18
	tbnz	w8, #0, .LBB371_11
	b	.LBB371_8
.LBB371_15:                             // %B16
	str	x22, [x20], #8
	sub	x25, x25, #1936
	mov	x9, x22
	b	SlowToBoolean_asm_h
.Lfunc_end371:
	.size	if_false_1_asm_h, .Lfunc_end371-if_false_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	if_true_1_asm_h                 // -- Begin function if_true_1_asm_h
	.p2align	2
	.type	if_true_1_asm_h,@function
if_true_1_asm_h:                        // @if_true_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B27
	ldr	w8, [x24, #336]
	cbz	w8, .LBB372_2
// %bb.1:                               // %B28
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB372_2:                              // %B24
	cmp	x22, #5
	b.le	.LBB372_6
// %bb.3:                               // %B24
	cmp	x22, #6
	b.eq	.LBB372_8
// %bb.4:                               // %B24
	cmp	x22, #7
	b.eq	.LBB372_11
// %bb.5:                               // %B24
	cmp	x22, #18
	b.eq	.LBB372_8
	b	.LBB372_9
.LBB372_6:                              // %B24
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB372_8
// %bb.7:                               // %B24
	cmp	x22, #2
	b.ne	.LBB372_9
.LBB372_8:                              // %B4
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB372_9:                              // %B10
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB372_15
// %bb.10:                              // %B12
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB372_12
.LBB372_11:                             // %B20
	ldrsw	x8, [x19]
	sub	x25, x25, #1936
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB372_12:                             // %B14
	tst	x22, #0xfffe000000000000
	b.eq	.LBB372_15
// %bb.13:                              // %B18
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB372_8
	b.vs	.LBB372_8
// %bb.14:                              // %B18
	tbnz	w8, #0, .LBB372_11
	b	.LBB372_8
.LBB372_15:                             // %B16
	str	x22, [x20], #8
	sub	x25, x25, #1936
	mov	x9, x22
	b	SlowToBoolean_asm_h
.Lfunc_end372:
	.size	if_true_1_asm_h, .Lfunc_end372-if_true_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	goto_1_asm_h                    // -- Begin function goto_1_asm_h
	.p2align	2
	.type	goto_1_asm_h,@function
goto_1_asm_h:                           // @goto_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB373_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB373_2:                              // %B1
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end373:
	.size	goto_1_asm_h, .Lfunc_end373-goto_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	catch_1_asm_h                   // -- Begin function catch_1_asm_h
	.p2align	2
	.type	catch_1_asm_h,@function
catch_1_asm_h:                          // @catch_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB374_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB374_2:                              // %B1
	ldr	x8, [x29, #8]
	ldrb	w11, [x19, #4]
	add	x25, x25, #1936
	ldr	w10, [x19]
	ldr	x8, [x8, #48]
	ldr	x0, [x25, x11, lsl #3]
	ldr	x8, [x8, #8]
	sub	x8, x19, x8
	add	x19, x19, #5
	add	x8, x8, x10
	mov	w10, #66                        // =0x42
	orr	x21, x10, x8, lsl #16
	br	x0
.Lfunc_end374:
	.size	catch_1_asm_h, .Lfunc_end374-catch_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	gosub_1_asm_h                   // -- Begin function gosub_1_asm_h
	.p2align	2
	.type	gosub_1_asm_h,@function
gosub_1_asm_h:                          // @gosub_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB375_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB375_2:                              // %B1
	ldr	x8, [x29, #8]
	ldrsw	x10, [x19]
	add	x25, x25, #1936
	ldr	x11, [x8, #48]
	add	x8, x19, x10
	ldr	w10, [x11, #8]
	ldrb	w11, [x8], #1
	sub	w10, w19, w10
	ldr	x0, [x25, x11, lsl #3]
	mov	x19, x8
	add	w10, w10, #4
	orr	x21, x10, #0xfffe000000000000
	br	x0
.Lfunc_end375:
	.size	gosub_1_asm_h, .Lfunc_end375-gosub_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	ret_1_asm_h                     // -- Begin function ret_1_asm_h
	.p2align	2
	.type	ret_1_asm_h,@function
ret_1_asm_h:                            // @ret_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B10
	ldr	w8, [x24, #336]
	cbz	w8, .LBB376_2
// %bb.1:                               // %B11
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB376_2:                              // %B7
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB376_5
// %bb.3:                               // %B2
	ldr	x8, [x29, #8]
	ldr	x8, [x8, #48]
	ldr	w10, [x8, #16]
	cmp	w22, w10
	b.ge	.LBB376_5
// %bb.4:                               // %B6
	ldr	x8, [x8, #8]
	sub	x25, x25, #1936
	add	x19, x8, w22, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB376_5:                              // %B4
	mov	x8, x20
	adrp	x1, .L__unnamed_14
	add	x1, x1, :lo12:.L__unnamed_14
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_ThrowInternalError
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end376:
	.size	ret_1_asm_h, .Lfunc_end376-ret_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	to_object_1_asm_h               // -- Begin function to_object_1_asm_h
	.p2align	2
	.type	to_object_1_asm_h,@function
to_object_1_asm_h:                      // @to_object_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB377_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB377_2:                              // %B3
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB377_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB377_4:                              // %B5
	str	x22, [x20], #8
	sub	x25, x25, #1936
	mov	x9, x22
	b	SlowToObject_asm_h
.Lfunc_end377:
	.size	to_object_1_asm_h, .Lfunc_end377-to_object_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	to_propkey_1_asm_h              // -- Begin function to_propkey_1_asm_h
	.p2align	2
	.type	to_propkey_1_asm_h,@function
to_propkey_1_asm_h:                     // @to_propkey_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B19
	ldr	w8, [x24, #336]
	cbz	w8, .LBB378_2
// %bb.1:                               // %B20
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB378_2:                              // %B16
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	.LBB378_6
// %bb.3:                               // %B16
	mov	x10, #1                         // =0x1
	and	x8, x22, #0xffff000000000003
	movk	x10, #1, lsl #48
	add	x11, x10, #1
	cmp	x8, x11
	b.eq	.LBB378_6
// %bb.4:                               // %B16
	cmp	x8, x10
	b.eq	.LBB378_6
// %bb.5:                               // %B16
	mov	x10, #-281474976710653          // =0xffff000000000003
	cmp	x8, x10
	b.ne	.LBB378_7
.LBB378_6:                              // %B4
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB378_7:                              // %B13
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB378_9
// %bb.8:                               // %B15
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB378_9:                              // %B14
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end378:
	.size	to_propkey_1_asm_h, .Lfunc_end378-to_propkey_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	to_propkey2_1_asm_h             // -- Begin function to_propkey2_1_asm_h
	.p2align	2
	.type	to_propkey2_1_asm_h,@function
to_propkey2_1_asm_h:                    // @to_propkey2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B22
	ldr	w8, [x24, #336]
	cbz	w8, .LBB379_2
// %bb.1:                               // %B23
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB379_2:                              // %B19
	mov	x21, x22
	ldur	x22, [x20, #-8]
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	.LBB379_5
// %bb.3:                               // %B20
	mov	x8, x20
	adrp	x1, .L__unnamed_15
	add	x1, x1, :lo12:.L__unnamed_15
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_ThrowTypeError
.LBB379_4:                              // %B17
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.LBB379_5:                              // %B3
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB379_9
// %bb.6:                               // %B3
	mov	x10, #1                         // =0x1
	and	x8, x21, #0xffff000000000003
	movk	x10, #1, lsl #48
	add	x11, x10, #1
	cmp	x8, x11
	b.eq	.LBB379_9
// %bb.7:                               // %B3
	cmp	x8, x10
	b.eq	.LBB379_9
// %bb.8:                               // %B3
	mov	x10, #-281474976710653          // =0xffff000000000003
	cmp	x8, x10
	b.ne	.LBB379_10
.LBB379_9:                              // %B5
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB379_10:                             // %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB379_4
// %bb.11:                              // %B18
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end379:
	.size	to_propkey2_1_asm_h, .Lfunc_end379-to_propkey2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_get_var_1_asm_h            // -- Begin function with_get_var_1_asm_h
	.p2align	2
	.type	with_get_var_1_asm_h,@function
with_get_var_1_asm_h:                   // @with_get_var_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB380_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB380_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	with_get_var_0_asm_h
.Lfunc_end380:
	.size	with_get_var_1_asm_h, .Lfunc_end380-with_get_var_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_put_var_1_asm_h            // -- Begin function with_put_var_1_asm_h
	.p2align	2
	.type	with_put_var_1_asm_h,@function
with_put_var_1_asm_h:                   // @with_put_var_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB381_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB381_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	with_put_var_0_asm_h
.Lfunc_end381:
	.size	with_put_var_1_asm_h, .Lfunc_end381-with_put_var_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_delete_var_1_asm_h         // -- Begin function with_delete_var_1_asm_h
	.p2align	2
	.type	with_delete_var_1_asm_h,@function
with_delete_var_1_asm_h:                // @with_delete_var_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB382_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB382_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	with_delete_var_0_asm_h
.Lfunc_end382:
	.size	with_delete_var_1_asm_h, .Lfunc_end382-with_delete_var_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_make_ref_1_asm_h           // -- Begin function with_make_ref_1_asm_h
	.p2align	2
	.type	with_make_ref_1_asm_h,@function
with_make_ref_1_asm_h:                  // @with_make_ref_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB383_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB383_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	with_make_ref_0_asm_h
.Lfunc_end383:
	.size	with_make_ref_1_asm_h, .Lfunc_end383-with_make_ref_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_get_ref_1_asm_h            // -- Begin function with_get_ref_1_asm_h
	.p2align	2
	.type	with_get_ref_1_asm_h,@function
with_get_ref_1_asm_h:                   // @with_get_ref_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB384_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB384_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	with_get_ref_0_asm_h
.Lfunc_end384:
	.size	with_get_ref_1_asm_h, .Lfunc_end384-with_get_ref_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_get_ref_undef_1_asm_h      // -- Begin function with_get_ref_undef_1_asm_h
	.p2align	2
	.type	with_get_ref_undef_1_asm_h,@function
with_get_ref_undef_1_asm_h:             // @with_get_ref_undef_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB385_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB385_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	with_get_ref_undef_0_asm_h
.Lfunc_end385:
	.size	with_get_ref_undef_1_asm_h, .Lfunc_end385-with_get_ref_undef_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	make_loc_ref_1_asm_h            // -- Begin function make_loc_ref_1_asm_h
	.p2align	2
	.type	make_loc_ref_1_asm_h,@function
make_loc_ref_1_asm_h:                   // @make_loc_ref_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB386_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB386_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	make_loc_ref_0_asm_h
.Lfunc_end386:
	.size	make_loc_ref_1_asm_h, .Lfunc_end386-make_loc_ref_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	make_arg_ref_1_asm_h            // -- Begin function make_arg_ref_1_asm_h
	.p2align	2
	.type	make_arg_ref_1_asm_h,@function
make_arg_ref_1_asm_h:                   // @make_arg_ref_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB387_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB387_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	make_arg_ref_0_asm_h
.Lfunc_end387:
	.size	make_arg_ref_1_asm_h, .Lfunc_end387-make_arg_ref_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	make_var_ref_ref_1_asm_h        // -- Begin function make_var_ref_ref_1_asm_h
	.p2align	2
	.type	make_var_ref_ref_1_asm_h,@function
make_var_ref_ref_1_asm_h:               // @make_var_ref_ref_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB388_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB388_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	make_var_ref_ref_0_asm_h
.Lfunc_end388:
	.size	make_var_ref_ref_1_asm_h, .Lfunc_end388-make_var_ref_ref_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	make_var_ref_1_asm_h            // -- Begin function make_var_ref_1_asm_h
	.p2align	2
	.type	make_var_ref_1_asm_h,@function
make_var_ref_1_asm_h:                   // @make_var_ref_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB389_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB389_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	make_var_ref_0_asm_h
.Lfunc_end389:
	.size	make_var_ref_1_asm_h, .Lfunc_end389-make_var_ref_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_in_start_1_asm_h            // -- Begin function for_in_start_1_asm_h
	.p2align	2
	.type	for_in_start_1_asm_h,@function
for_in_start_1_asm_h:                   // @for_in_start_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB390_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB390_2:                              // %B2
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	.LBB390_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB390_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end390:
	.size	for_in_start_1_asm_h, .Lfunc_end390-for_in_start_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_of_start_1_asm_h            // -- Begin function for_of_start_1_asm_h
	.p2align	2
	.type	for_of_start_1_asm_h,@function
for_of_start_1_asm_h:                   // @for_of_start_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB391_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB391_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	for_of_start_0_asm_h
.Lfunc_end391:
	.size	for_of_start_1_asm_h, .Lfunc_end391-for_of_start_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_await_of_start_1_asm_h      // -- Begin function for_await_of_start_1_asm_h
	.p2align	2
	.type	for_await_of_start_1_asm_h,@function
for_await_of_start_1_asm_h:             // @for_await_of_start_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB392_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB392_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	for_await_of_start_0_asm_h
.Lfunc_end392:
	.size	for_await_of_start_1_asm_h, .Lfunc_end392-for_await_of_start_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_in_next_1_asm_h             // -- Begin function for_in_next_1_asm_h
	.p2align	2
	.type	for_in_next_1_asm_h,@function
for_in_next_1_asm_h:                    // @for_in_next_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB393_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB393_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	for_in_next_0_asm_h
.Lfunc_end393:
	.size	for_in_next_1_asm_h, .Lfunc_end393-for_in_next_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_of_next_1_asm_h             // -- Begin function for_of_next_1_asm_h
	.p2align	2
	.type	for_of_next_1_asm_h,@function
for_of_next_1_asm_h:                    // @for_of_next_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB394_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB394_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	for_of_next_0_asm_h
.Lfunc_end394:
	.size	for_of_next_1_asm_h, .Lfunc_end394-for_of_next_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_await_of_next_1_asm_h       // -- Begin function for_await_of_next_1_asm_h
	.p2align	2
	.type	for_await_of_next_1_asm_h,@function
for_await_of_next_1_asm_h:              // @for_await_of_next_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB395_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB395_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	for_await_of_next_0_asm_h
.Lfunc_end395:
	.size	for_await_of_next_1_asm_h, .Lfunc_end395-for_await_of_next_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	iterator_get_value_done_1_asm_h // -- Begin function iterator_get_value_done_1_asm_h
	.p2align	2
	.type	iterator_get_value_done_1_asm_h,@function
iterator_get_value_done_1_asm_h:        // @iterator_get_value_done_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB396_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB396_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	iterator_get_value_done_0_asm_h
.Lfunc_end396:
	.size	iterator_get_value_done_1_asm_h, .Lfunc_end396-iterator_get_value_done_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	iterator_close_1_asm_h          // -- Begin function iterator_close_1_asm_h
	.p2align	2
	.type	iterator_close_1_asm_h,@function
iterator_close_1_asm_h:                 // @iterator_close_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB397_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB397_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	iterator_close_0_asm_h
.Lfunc_end397:
	.size	iterator_close_1_asm_h, .Lfunc_end397-iterator_close_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	iterator_close_return_1_asm_h   // -- Begin function iterator_close_return_1_asm_h
	.p2align	2
	.type	iterator_close_return_1_asm_h,@function
iterator_close_return_1_asm_h:          // @iterator_close_return_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB398_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB398_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	iterator_close_return_0_asm_h
.Lfunc_end398:
	.size	iterator_close_return_1_asm_h, .Lfunc_end398-iterator_close_return_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	async_iterator_close_1_asm_h    // -- Begin function async_iterator_close_1_asm_h
	.p2align	2
	.type	async_iterator_close_1_asm_h,@function
async_iterator_close_1_asm_h:           // @async_iterator_close_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB399_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB399_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	async_iterator_close_0_asm_h
.Lfunc_end399:
	.size	async_iterator_close_1_asm_h, .Lfunc_end399-async_iterator_close_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	async_iterator_next_1_asm_h     // -- Begin function async_iterator_next_1_asm_h
	.p2align	2
	.type	async_iterator_next_1_asm_h,@function
async_iterator_next_1_asm_h:            // @async_iterator_next_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB400_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB400_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	async_iterator_next_0_asm_h
.Lfunc_end400:
	.size	async_iterator_next_1_asm_h, .Lfunc_end400-async_iterator_next_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	async_iterator_get_1_asm_h      // -- Begin function async_iterator_get_1_asm_h
	.p2align	2
	.type	async_iterator_get_1_asm_h,@function
async_iterator_get_1_asm_h:             // @async_iterator_get_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB401_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB401_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	async_iterator_get_0_asm_h
.Lfunc_end401:
	.size	async_iterator_get_1_asm_h, .Lfunc_end401-async_iterator_get_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	initial_yield_1_asm_h           // -- Begin function initial_yield_1_asm_h
	.p2align	2
	.type	initial_yield_1_asm_h,@function
initial_yield_1_asm_h:                  // @initial_yield_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB402_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB402_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	initial_yield_0_asm_h
.Lfunc_end402:
	.size	initial_yield_1_asm_h, .Lfunc_end402-initial_yield_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	yield_1_asm_h                   // -- Begin function yield_1_asm_h
	.p2align	2
	.type	yield_1_asm_h,@function
yield_1_asm_h:                          // @yield_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB403_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB403_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	yield_0_asm_h
.Lfunc_end403:
	.size	yield_1_asm_h, .Lfunc_end403-yield_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	yield_star_1_asm_h              // -- Begin function yield_star_1_asm_h
	.p2align	2
	.type	yield_star_1_asm_h,@function
yield_star_1_asm_h:                     // @yield_star_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB404_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB404_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	yield_star_0_asm_h
.Lfunc_end404:
	.size	yield_star_1_asm_h, .Lfunc_end404-yield_star_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	async_yield_star_1_asm_h        // -- Begin function async_yield_star_1_asm_h
	.p2align	2
	.type	async_yield_star_1_asm_h,@function
async_yield_star_1_asm_h:               // @async_yield_star_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB405_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB405_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	async_yield_star_0_asm_h
.Lfunc_end405:
	.size	async_yield_star_1_asm_h, .Lfunc_end405-async_yield_star_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	await_1_asm_h                   // -- Begin function await_1_asm_h
	.p2align	2
	.type	await_1_asm_h,@function
await_1_asm_h:                          // @await_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB406_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB406_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	await_0_asm_h
.Lfunc_end406:
	.size	await_1_asm_h, .Lfunc_end406-await_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	neg_1_asm_h                     // -- Begin function neg_1_asm_h
	.p2align	2
	.type	neg_1_asm_h,@function
neg_1_asm_h:                            // @neg_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B23
	ldr	w8, [x24, #336]
	cbz	w8, .LBB407_2
// %bb.1:                               // %B24
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB407_2:                              // %B20
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB407_5
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB407_8
// %bb.4:                               // %B14
	orr	w8, w22, #0x80000000
	mov	w10, #-2147483648               // =0x80000000
	cmp	w8, w10
	b.ne	.LBB407_7
.LBB407_5:                              // %B17
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        // =0x8c
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB407_10
// %bb.6:                               // %B19
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB407_7:                              // %B16
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB407_8:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB407_5
// %bb.9:                               // %B8
	movi	d0, #0000000000000000
	add	x8, x22, x8
	mov	x11, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fsub	d0, d0, d1
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB407_10:                             // %B18
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end407:
	.size	neg_1_asm_h, .Lfunc_end407-neg_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	plus_1_asm_h                    // -- Begin function plus_1_asm_h
	.p2align	2
	.type	plus_1_asm_h,@function
plus_1_asm_h:                           // @plus_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B17
	ldr	w8, [x24, #336]
	cbz	w8, .LBB408_2
// %bb.1:                               // %B18
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB408_2:                              // %B14
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB408_6
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB408_5
.LBB408_4:                              // %B8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB408_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.ne	.LBB408_4
.LBB408_6:                              // %B11
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        // =0x8d
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB408_8
// %bb.7:                               // %B13
	mov	x22, x0
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB408_8:                              // %B12
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end408:
	.size	plus_1_asm_h, .Lfunc_end408-plus_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dec_1_asm_h                     // -- Begin function dec_1_asm_h
	.p2align	2
	.type	dec_1_asm_h,@function
dec_1_asm_h:                            // @dec_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B23
	ldr	w8, [x24, #336]
	cbz	w8, .LBB409_2
// %bb.1:                               // %B24
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB409_2:                              // %B20
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB409_8
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB409_6
// %bb.4:                               // %B14
	subs	w8, w22, #1
	b.vs	.LBB409_8
// %bb.5:                               // %B16
	ldrb	w10, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB409_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB409_8
// %bb.7:                               // %B8
	add	x8, x22, x8
	fmov	d0, #-1.00000000
	mov	x11, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB409_8:                              // %B17
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        // =0x8e
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB409_10
// %bb.9:                               // %B19
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB409_10:                             // %B18
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end409:
	.size	dec_1_asm_h, .Lfunc_end409-dec_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	inc_1_asm_h                     // -- Begin function inc_1_asm_h
	.p2align	2
	.type	inc_1_asm_h,@function
inc_1_asm_h:                            // @inc_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B23
	ldr	w8, [x24, #336]
	cbz	w8, .LBB410_2
// %bb.1:                               // %B24
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB410_2:                              // %B20
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB410_8
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB410_6
// %bb.4:                               // %B14
	adds	w8, w22, #1
	b.vs	.LBB410_8
// %bb.5:                               // %B16
	ldrb	w10, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB410_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB410_8
// %bb.7:                               // %B8
	add	x8, x22, x8
	fmov	d0, #1.00000000
	mov	x11, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB410_8:                              // %B17
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        // =0x8f
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB410_10
// %bb.9:                               // %B19
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB410_10:                             // %B18
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end410:
	.size	inc_1_asm_h, .Lfunc_end410-inc_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	post_dec_1_asm_h                // -- Begin function post_dec_1_asm_h
	.p2align	2
	.type	post_dec_1_asm_h,@function
post_dec_1_asm_h:                       // @post_dec_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B20
	ldr	w8, [x24, #336]
	cbz	w8, .LBB411_2
// %bb.1:                               // %B21
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB411_2:                              // %B17
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB411_8
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB411_6
// %bb.4:                               // %B14
	subs	w8, w22, #1
	b.vs	.LBB411_8
// %bb.5:                               // %B16
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	orr	x21, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB411_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB411_8
// %bb.7:                               // %B9
	add	x8, x22, x8
	fmov	d0, #-1.00000000
	add	x25, x25, #1936
	fmov	d1, x8
	ldrb	w8, [x19], #1
	mov	x11, #562949953421312           // =0x2000000000000
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	csel	x21, x10, x8, vc
	br	x0
.LBB411_8:                              // %B6
	str	x22, [x20], #8
	sub	x25, x25, #1936
	mov	w9, #144                        // =0x90
	b	SlowJSPostInc_asm_h
.Lfunc_end411:
	.size	post_dec_1_asm_h, .Lfunc_end411-post_dec_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	post_inc_1_asm_h                // -- Begin function post_inc_1_asm_h
	.p2align	2
	.type	post_inc_1_asm_h,@function
post_inc_1_asm_h:                       // @post_inc_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B20
	ldr	w8, [x24, #336]
	cbz	w8, .LBB412_2
// %bb.1:                               // %B21
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB412_2:                              // %B17
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB412_8
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB412_6
// %bb.4:                               // %B14
	adds	w8, w22, #1
	b.vs	.LBB412_8
// %bb.5:                               // %B16
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	orr	x21, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB412_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB412_8
// %bb.7:                               // %B9
	add	x8, x22, x8
	fmov	d0, #1.00000000
	add	x25, x25, #1936
	fmov	d1, x8
	ldrb	w8, [x19], #1
	mov	x11, #562949953421312           // =0x2000000000000
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	csel	x21, x10, x8, vc
	br	x0
.LBB412_8:                              // %B6
	str	x22, [x20], #8
	sub	x25, x25, #1936
	mov	w9, #145                        // =0x91
	b	SlowJSPostInc_asm_h
.Lfunc_end412:
	.size	post_inc_1_asm_h, .Lfunc_end412-post_inc_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dec_loc_1_asm_h                 // -- Begin function dec_loc_1_asm_h
	.p2align	2
	.type	dec_loc_1_asm_h,@function
dec_loc_1_asm_h:                        // @dec_loc_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B23
	ldr	w8, [x24, #336]
	cbz	w8, .LBB413_2
// %bb.1:                               // %B24
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB413_2:                              // %B20
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	b.hi	.LBB413_8
// %bb.3:                               // %B3
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB413_6
// %bb.4:                               // %B14
	subs	w10, w1, #1
	b.vs	.LBB413_8
// %bb.5:                               // %B16
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB413_6:                              // %B5
	tst	x1, #0xfffe000000000000
	b.eq	.LBB413_8
// %bb.7:                               // %B9
	add	x10, x1, x10
	fmov	d0, #-1.00000000
	mov	x11, #562949953421312           // =0x2000000000000
	fmov	d1, x10
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	mov	x11, #9221120237041090560       // =0x7ff8000000000000
	csel	x10, x10, x11, vc
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB413_8:                              // %B17
	mov	x8, x20
	mov	x0, x24
	mov	w2, #142                        // =0x8e
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB413_10
// %bb.9:                               // %B19
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB413_10:                             // %B18
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end413:
	.size	dec_loc_1_asm_h, .Lfunc_end413-dec_loc_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	inc_loc_1_asm_h                 // -- Begin function inc_loc_1_asm_h
	.p2align	2
	.type	inc_loc_1_asm_h,@function
inc_loc_1_asm_h:                        // @inc_loc_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B23
	ldr	w8, [x24, #336]
	cbz	w8, .LBB414_2
// %bb.1:                               // %B24
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB414_2:                              // %B20
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	b.hi	.LBB414_8
// %bb.3:                               // %B3
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB414_6
// %bb.4:                               // %B14
	adds	w10, w1, #1
	b.vs	.LBB414_8
// %bb.5:                               // %B16
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB414_6:                              // %B5
	tst	x1, #0xfffe000000000000
	b.eq	.LBB414_8
// %bb.7:                               // %B9
	add	x10, x1, x10
	fmov	d0, #1.00000000
	mov	x11, #562949953421312           // =0x2000000000000
	fmov	d1, x10
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	mov	x11, #9221120237041090560       // =0x7ff8000000000000
	csel	x10, x10, x11, vc
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB414_8:                              // %B17
	mov	x8, x20
	mov	x0, x24
	mov	w2, #143                        // =0x8f
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB414_10
// %bb.9:                               // %B19
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB414_10:                             // %B18
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end414:
	.size	inc_loc_1_asm_h, .Lfunc_end414-inc_loc_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	add_loc_1_asm_h                 // -- Begin function add_loc_1_asm_h
	.p2align	2
	.type	add_loc_1_asm_h,@function
add_loc_1_asm_h:                        // @add_loc_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B49
	ldr	w8, [x24, #336]
	cbz	w8, .LBB415_2
// %bb.1:                               // %B50
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB415_2:                              // %B46
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	b.hi	.LBB415_17
// %bb.3:                               // %B46
	cmp	x22, x10
	b.hi	.LBB415_17
// %bb.4:                               // %B3
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB415_8
// %bb.5:                               // %B27
	cmp	x22, x10
	b.lo	.LBB415_11
// %bb.6:                               // %B37
	adds	w10, w1, w22
	b.vs	.LBB415_17
// %bb.7:                               // %B39
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB415_8:                              // %B5
	tst	x1, #0xfffe000000000000
	b.eq	.LBB415_17
// %bb.9:                               // %B12
	cmp	x22, x10
	b.lo	.LBB415_15
// %bb.10:                              // %B22
	scvtf	d0, w22
	add	x10, x1, x10
	fmov	d1, x10
	fadd	d0, d1, d0
	b	.LBB415_14
.LBB415_11:                             // %B29
	tst	x22, #0xfffe000000000000
	b.eq	.LBB415_17
// %bb.12:                              // %B32
	scvtf	d0, w1
	add	x10, x22, x10
.LBB415_13:                             // %B32
	fmov	d1, x10
	fadd	d0, d0, d1
.LBB415_14:                             // %B32
	fmov	x10, d0
	fcmp	d0, d0
	mov	x11, #562949953421312           // =0x2000000000000
	add	x10, x10, x11
	mov	x11, #9221120237041090560       // =0x7ff8000000000000
	csel	x10, x10, x11, vc
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB415_15:                             // %B14
	tst	x22, #0xfffe000000000000
	b.eq	.LBB415_17
// %bb.16:                              // %B17
	add	x11, x1, x10
	add	x10, x22, x10
	fmov	d0, x11
	b	.LBB415_13
.LBB415_17:                             // %B8
	mov	x8, #2                          // =0x2
	and	x10, x1, #0xffff000000000003
	mov	x11, x20
	movk	x8, #1, lsl #48
	str	x22, [x11], #8
	cmp	x10, x8
	str	x11, [x29, #64]
	b.ne	.LBB415_20
// %bb.18:                              // %B8
	and	x10, x22, #0xffff000000000003
	cmp	x10, x8
	b.ne	.LBB415_20
// %bb.19:                              // %B40
	mov	x0, x24
	mov	x2, x22
	bl	JS_ConcatString_GC
	b	.LBB415_21
.LBB415_20:                             // %B43
	mov	x0, x24
	mov	x2, x22
	bl	prim_js_add_slow_gc
.LBB415_21:                             // %B43
	cmp	x0, #130
	b.eq	.LBB415_23
// %bb.22:                              // %B45
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB415_23:                             // %B44
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end415:
	.size	add_loc_1_asm_h, .Lfunc_end415-add_loc_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	not_1_asm_h                     // -- Begin function not_1_asm_h
	.p2align	2
	.type	not_1_asm_h,@function
not_1_asm_h:                            // @not_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB416_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB416_2:                              // %B3
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB416_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB416_4:                              // %B5
	str	x22, [x20], #8
	sub	x25, x25, #1936
	mov	x9, x22
	b	SlowJSNot_asm_h
.Lfunc_end416:
	.size	not_1_asm_h, .Lfunc_end416-not_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	lnot_1_asm_h                    // -- Begin function lnot_1_asm_h
	.p2align	2
	.type	lnot_1_asm_h,@function
lnot_1_asm_h:                           // @lnot_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B18
	ldr	w8, [x24, #336]
	cbz	w8, .LBB417_2
// %bb.1:                               // %B19
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB417_2:                              // %B15
	cmp	x22, #5
	b.le	.LBB417_6
// %bb.3:                               // %B15
	cmp	x22, #6
	b.eq	.LBB417_8
// %bb.4:                               // %B15
	cmp	x22, #7
	b.eq	.LBB417_10
// %bb.5:                               // %B15
	cmp	x22, #18
	b.eq	.LBB417_8
	b	.LBB417_9
.LBB417_6:                              // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB417_8
// %bb.7:                               // %B15
	cmp	x22, #2
	b.ne	.LBB417_9
.LBB417_8:                              // %B4
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB417_9:                              // %B11
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB417_11
.LBB417_10:                             // %B13
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB417_11:                             // %B14
	str	x22, [x20], #8
	sub	x25, x25, #1936
	mov	x9, x22
	b	SlowToBoolean_asm_h
.Lfunc_end417:
	.size	lnot_1_asm_h, .Lfunc_end417-lnot_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	typeof_1_asm_h                  // -- Begin function typeof_1_asm_h
	.p2align	2
	.type	typeof_1_asm_h,@function
typeof_1_asm_h:                         // @typeof_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB418_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB418_2:                              // %B2
	mov	x0, x24
	mov	x1, x22
	bl	js_operator_typeof_gc
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB418_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB418_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end418:
	.size	typeof_1_asm_h, .Lfunc_end418-typeof_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	delete_1_asm_h                  // -- Begin function delete_1_asm_h
	.p2align	2
	.type	delete_1_asm_h,@function
delete_1_asm_h:                         // @delete_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB419_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB419_2:                              // %B2
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x29, #64]
	bl	prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	.LBB419_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB419_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end419:
	.size	delete_1_asm_h, .Lfunc_end419-delete_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	delete_var_1_asm_h              // -- Begin function delete_var_1_asm_h
	.p2align	2
	.type	delete_var_1_asm_h,@function
delete_var_1_asm_h:                     // @delete_var_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB420_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB420_2:                              // %B2
	ldr	w2, [x19]
	ldr	x1, [x24, #224]
	mov	x8, x20
	mov	x0, x24
	mov	w3, wzr
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_DeleteProperty
	tbnz	w0, #31, .LBB420_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	cmp	w0, #0
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x21, x8, ne
	br	x0
.LBB420_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end420:
	.size	delete_var_1_asm_h, .Lfunc_end420-delete_var_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	mul_1_asm_h                     // -- Begin function mul_1_asm_h
	.p2align	2
	.type	mul_1_asm_h,@function
mul_1_asm_h:                            // @mul_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B51
	ldr	w8, [x24, #336]
	cbz	w8, .LBB421_2
// %bb.1:                               // %B52
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB421_2:                              // %B48
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB421_20
// %bb.3:                               // %B48
	cmp	x21, x8
	b.hi	.LBB421_20
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB421_10
// %bb.5:                               // %B24
	cmp	x21, x8
	b.lo	.LBB421_13
// %bb.6:                               // %B34
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	.LBB421_20
// %bb.7:                               // %B37
	cbnz	w8, .LBB421_9
// %bb.8:                               // %B37
	orr	w10, w22, w21
	tbnz	w10, #31, .LBB421_17
.LBB421_9:                              // %B44
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB421_10:                             // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB421_20
// %bb.11:                              // %B8
	cmp	x21, x8
	b.lo	.LBB421_18
// %bb.12:                              // %B19
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	.LBB421_16
.LBB421_13:                             // %B26
	tst	x21, #0xfffe000000000000
	b.eq	.LBB421_20
// %bb.14:                              // %B29
	scvtf	d0, w22
	add	x8, x21, x8
.LBB421_15:                             // %B29
	fmov	d1, x8
	fmul	d0, d0, d1
.LBB421_16:                             // %B29
	ldrb	w8, [x19], #1
	fmov	x10, d0
	fcmp	d0, d0
	mov	x11, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB421_17:                             // %B41
	mov	x22, #-9222809086901354496      // =0x8002000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB421_18:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB421_20
// %bb.19:                              // %B13
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB421_15
.LBB421_20:                             // %B45
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        // =0x9a
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB421_22
// %bb.21:                              // %B47
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB421_22:                             // %B46
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end421:
	.size	mul_1_asm_h, .Lfunc_end421-mul_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	div_1_asm_h                     // -- Begin function div_1_asm_h
	.p2align	2
	.type	div_1_asm_h,@function
div_1_asm_h:                            // @div_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B48
	ldr	w8, [x24, #336]
	cbz	w8, .LBB422_2
// %bb.1:                               // %B49
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB422_2:                              // %B45
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB422_16
// %bb.3:                               // %B45
	cmp	x21, x8
	b.hi	.LBB422_16
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB422_7
// %bb.5:                               // %B24
	cmp	x21, x8
	b.lo	.LBB422_10
// %bb.6:                               // %B34
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w13, [x19], #1
	mov	x11, #9221120237041090560       // =0x7ff8000000000000
	sub	x20, x20, #8
	ldr	x0, [x25, x13, lsl #3]
	fdiv	d0, d0, d1
	fcvtzs	w8, d0
	fmov	x12, d0
	fcmp	d0, d0
	add	x10, x12, x10
	csel	x10, x10, x11, vc
	cmp	x8, x12
	orr	x8, x8, #0xfffe000000000000
	csel	x22, x10, x8, ne
	br	x0
.LBB422_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB422_16
// %bb.8:                               // %B8
	cmp	x21, x8
	b.lo	.LBB422_14
// %bb.9:                               // %B19
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	.LBB422_13
.LBB422_10:                             // %B26
	tst	x21, #0xfffe000000000000
	b.eq	.LBB422_16
// %bb.11:                              // %B29
	scvtf	d0, w22
	add	x8, x21, x8
.LBB422_12:                             // %B29
	fmov	d1, x8
	fdiv	d0, d0, d1
.LBB422_13:                             // %B29
	ldrb	w8, [x19], #1
	fmov	x10, d0
	fcmp	d0, d0
	mov	x11, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB422_14:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB422_16
// %bb.15:                              // %B13
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB422_12
.LBB422_16:                             // %B42
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        // =0x9b
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB422_18
// %bb.17:                              // %B44
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB422_18:                             // %B43
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end422:
	.size	div_1_asm_h, .Lfunc_end422-div_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	mod_1_asm_h                     // -- Begin function mod_1_asm_h
	.p2align	2
	.type	mod_1_asm_h,@function
mod_1_asm_h:                            // @mod_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B43
	ldr	w8, [x24, #336]
	cbz	w8, .LBB423_2
// %bb.1:                               // %B44
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB423_2:                              // %B40
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB423_18
// %bb.3:                               // %B40
	cmp	x21, x8
	b.hi	.LBB423_18
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB423_9
// %bb.5:                               // %B24
	cmp	x21, x8
	b.lo	.LBB423_12
// %bb.6:                               // %B34
	tbnz	w22, #31, .LBB423_18
// %bb.7:                               // %B34
	cmp	w21, #1
	b.lt	.LBB423_18
// %bb.8:                               // %B36
	sdiv	w8, w22, w21
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x10, lsl #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB423_9:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB423_18
// %bb.10:                              // %B8
	cmp	x21, x8
	b.lo	.LBB423_16
// %bb.11:                              // %B19
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	.LBB423_15
.LBB423_12:                             // %B26
	tst	x21, #0xfffe000000000000
	b.eq	.LBB423_18
// %bb.13:                              // %B29
	scvtf	d0, w22
	add	x8, x21, x8
.LBB423_14:                             // %B29
	fmov	d1, x8
.LBB423_15:                             // %B29
	bl	fmod
	ldrb	w8, [x19], #1
	fmov	x10, d0
	fcmp	d0, d0
	mov	x11, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB423_16:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB423_18
// %bb.17:                              // %B13
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB423_14
.LBB423_18:                             // %B37
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        // =0x9c
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB423_20
// %bb.19:                              // %B39
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB423_20:                             // %B38
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end423:
	.size	mod_1_asm_h, .Lfunc_end423-mod_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	add_1_asm_h                     // -- Begin function add_1_asm_h
	.p2align	2
	.type	add_1_asm_h,@function
add_1_asm_h:                            // @add_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B49
	ldr	w8, [x24, #336]
	cbz	w8, .LBB424_2
// %bb.1:                               // %B50
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB424_2:                              // %B46
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB424_17
// %bb.3:                               // %B46
	cmp	x21, x8
	b.hi	.LBB424_17
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB424_8
// %bb.5:                               // %B27
	cmp	x21, x8
	b.lo	.LBB424_11
// %bb.6:                               // %B37
	adds	w8, w22, w21
	b.vs	.LBB424_17
// %bb.7:                               // %B39
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB424_8:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB424_17
// %bb.9:                               // %B11
	cmp	x21, x8
	b.lo	.LBB424_15
// %bb.10:                              // %B22
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	.LBB424_14
.LBB424_11:                             // %B29
	tst	x21, #0xfffe000000000000
	b.eq	.LBB424_17
// %bb.12:                              // %B32
	scvtf	d0, w22
	add	x8, x21, x8
.LBB424_13:                             // %B32
	fmov	d1, x8
	fadd	d0, d0, d1
.LBB424_14:                             // %B32
	ldrb	w8, [x19], #1
	fmov	x10, d0
	fcmp	d0, d0
	mov	x11, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB424_15:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB424_17
// %bb.16:                              // %B16
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB424_13
.LBB424_17:                             // %B7
	mov	x8, #2                          // =0x2
	and	x10, x22, #0xffff000000000003
	mov	x11, x20
	movk	x8, #1, lsl #48
	str	x21, [x11], #8
	cmp	x10, x8
	str	x11, [x29, #64]
	b.ne	.LBB424_20
// %bb.18:                              // %B7
	and	x10, x21, #0xffff000000000003
	cmp	x10, x8
	b.ne	.LBB424_20
// %bb.19:                              // %B40
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	JS_ConcatString_GC
	b	.LBB424_21
.LBB424_20:                             // %B43
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_add_slow_gc
.LBB424_21:                             // %B43
	cmp	x0, #130
	b.eq	.LBB424_23
// %bb.22:                              // %B45
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB424_23:                             // %B44
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end424:
	.size	add_1_asm_h, .Lfunc_end424-add_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	sub_1_asm_h                     // -- Begin function sub_1_asm_h
	.p2align	2
	.type	sub_1_asm_h,@function
sub_1_asm_h:                            // @sub_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B43
	ldr	w8, [x24, #336]
	cbz	w8, .LBB425_2
// %bb.1:                               // %B44
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB425_2:                              // %B40
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB425_17
// %bb.3:                               // %B40
	cmp	x21, x8
	b.hi	.LBB425_17
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB425_8
// %bb.5:                               // %B24
	cmp	x21, x8
	b.lo	.LBB425_11
// %bb.6:                               // %B34
	subs	w8, w22, w21
	b.vs	.LBB425_17
// %bb.7:                               // %B36
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB425_8:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB425_17
// %bb.9:                               // %B8
	cmp	x21, x8
	b.lo	.LBB425_15
// %bb.10:                              // %B19
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	.LBB425_14
.LBB425_11:                             // %B26
	tst	x21, #0xfffe000000000000
	b.eq	.LBB425_17
// %bb.12:                              // %B29
	scvtf	d0, w22
	add	x8, x21, x8
.LBB425_13:                             // %B29
	fmov	d1, x8
	fsub	d0, d0, d1
.LBB425_14:                             // %B29
	ldrb	w8, [x19], #1
	fmov	x10, d0
	fcmp	d0, d0
	mov	x11, #562949953421312           // =0x2000000000000
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB425_15:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB425_17
// %bb.16:                              // %B13
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB425_13
.LBB425_17:                             // %B37
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        // =0x9e
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB425_19
// %bb.18:                              // %B39
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB425_19:                             // %B38
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end425:
	.size	sub_1_asm_h, .Lfunc_end425-sub_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	pow_1_asm_h                     // -- Begin function pow_1_asm_h
	.p2align	2
	.type	pow_1_asm_h,@function
pow_1_asm_h:                            // @pow_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB426_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB426_2:                              // %B2
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	mov	w3, #159                        // =0x9f
	mov	x1, x22
	str	x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB426_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB426_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end426:
	.size	pow_1_asm_h, .Lfunc_end426-pow_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	shl_1_asm_h                     // -- Begin function shl_1_asm_h
	.p2align	2
	.type	shl_1_asm_h,@function
shl_1_asm_h:                            // @shl_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B32
	ldr	w8, [x24, #336]
	cbz	w8, .LBB427_2
// %bb.1:                               // %B33
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB427_2:                              // %B29
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB427_11
// %bb.3:                               // %B29
	cmp	x21, x8
	b.hi	.LBB427_11
// %bb.4:                               // %B3
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB427_7
// %bb.5:                               // %B20
	cmp	x21, x8
	b.lo	.LBB427_11
// %bb.6:                               // %B25
	mov	w8, w22
	ldrb	w10, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB427_7:                              // %B5
	tst	x22, #0xfffe000000000000
	b.eq	.LBB427_11
// %bb.8:                               // %B5
	cmp	x21, x8
	b.lo	.LBB427_11
// %bb.9:                               // %B15
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB427_11
// %bb.10:                              // %B16
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w10, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB427_11:                             // %B26
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        // =0xa0
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB427_13
// %bb.12:                              // %B28
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB427_13:                             // %B27
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end427:
	.size	shl_1_asm_h, .Lfunc_end427-shl_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	sar_1_asm_h                     // -- Begin function sar_1_asm_h
	.p2align	2
	.type	sar_1_asm_h,@function
sar_1_asm_h:                            // @sar_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B32
	ldr	w8, [x24, #336]
	cbz	w8, .LBB428_2
// %bb.1:                               // %B33
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB428_2:                              // %B29
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB428_11
// %bb.3:                               // %B29
	cmp	x21, x8
	b.hi	.LBB428_11
// %bb.4:                               // %B3
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB428_7
// %bb.5:                               // %B20
	cmp	x21, x8
	b.lo	.LBB428_11
// %bb.6:                               // %B25
	mov	w8, w22
	ldrb	w10, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB428_7:                              // %B5
	tst	x22, #0xfffe000000000000
	b.eq	.LBB428_11
// %bb.8:                               // %B5
	cmp	x21, x8
	b.lo	.LBB428_11
// %bb.9:                               // %B15
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB428_11
// %bb.10:                              // %B16
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w10, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB428_11:                             // %B26
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        // =0xa1
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB428_13
// %bb.12:                              // %B28
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB428_13:                             // %B27
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end428:
	.size	sar_1_asm_h, .Lfunc_end428-sar_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	shr_1_asm_h                     // -- Begin function shr_1_asm_h
	.p2align	2
	.type	shr_1_asm_h,@function
shr_1_asm_h:                            // @shr_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B40
	ldr	w8, [x24, #336]
	cbz	w8, .LBB429_2
// %bb.1:                               // %B41
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB429_2:                              // %B37
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB429_13
// %bb.3:                               // %B37
	cmp	x21, x8
	b.hi	.LBB429_13
// %bb.4:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB429_8
// %bb.5:                               // %B28
	cmp	x21, x8
	b.lo	.LBB429_13
// %bb.6:                               // %B33
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, .LBB429_12
.LBB429_7:                              // %B3
	orr	x8, x8, #0xfffe000000000000
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB429_8:                              // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB429_13
// %bb.9:                               // %B13
	cmp	x21, x8
	b.lo	.LBB429_13
// %bb.10:                              // %B23
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB429_13
// %bb.11:                              // %B24
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, .LBB429_7
.LBB429_12:                             // %B7
	ucvtf	d0, w8
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	x8, d0
	fcmp	d0, d0
	add	x8, x8, x10
	mov	x10, #9221120237041090560       // =0x7ff8000000000000
	csel	x8, x8, x10, vc
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB429_13:                             // %B34
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	.LBB429_15
// %bb.14:                              // %B36
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB429_15:                             // %B35
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end429:
	.size	shr_1_asm_h, .Lfunc_end429-shr_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	lt_1_asm_h                      // -- Begin function lt_1_asm_h
	.p2align	2
	.type	lt_1_asm_h,@function
lt_1_asm_h:                             // @lt_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B28
	ldr	w8, [x24, #336]
	cbz	w8, .LBB430_2
// %bb.1:                               // %B29
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB430_2:                              // %B25
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB430_15
// %bb.3:                               // %B25
	cmp	x21, x8
	b.hi	.LBB430_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB430_7
// %bb.5:                               // %B16
	cmp	x21, x8
	b.lo	.LBB430_10
// %bb.6:                               // %B21
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, lt
	br	x0
.LBB430_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB430_15
// %bb.8:                               // %B8
	cmp	x21, x8
	b.lo	.LBB430_13
// %bb.9:                               // %B14
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x0
.LBB430_10:                             // %B18
	tst	x21, #0xfffe000000000000
	b.eq	.LBB430_15
// %bb.11:                              // %B20
	scvtf	d0, w22
	add	x8, x21, x8
.LBB430_12:                             // %B20
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x0
.LBB430_13:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB430_15
// %bb.14:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB430_12
.LBB430_15:                             // %B22
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        // =0xa3
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB430_17
// %bb.16:                              // %B24
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB430_17:                             // %B23
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end430:
	.size	lt_1_asm_h, .Lfunc_end430-lt_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	lte_1_asm_h                     // -- Begin function lte_1_asm_h
	.p2align	2
	.type	lte_1_asm_h,@function
lte_1_asm_h:                            // @lte_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B28
	ldr	w8, [x24, #336]
	cbz	w8, .LBB431_2
// %bb.1:                               // %B29
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB431_2:                              // %B25
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB431_15
// %bb.3:                               // %B25
	cmp	x21, x8
	b.hi	.LBB431_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB431_7
// %bb.5:                               // %B16
	cmp	x21, x8
	b.lo	.LBB431_10
// %bb.6:                               // %B21
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, le
	br	x0
.LBB431_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB431_15
// %bb.8:                               // %B8
	cmp	x21, x8
	b.lo	.LBB431_13
// %bb.9:                               // %B14
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x0
.LBB431_10:                             // %B18
	tst	x21, #0xfffe000000000000
	b.eq	.LBB431_15
// %bb.11:                              // %B20
	scvtf	d0, w22
	add	x8, x21, x8
.LBB431_12:                             // %B20
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x0
.LBB431_13:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB431_15
// %bb.14:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB431_12
.LBB431_15:                             // %B22
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        // =0xa4
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB431_17
// %bb.16:                              // %B24
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB431_17:                             // %B23
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end431:
	.size	lte_1_asm_h, .Lfunc_end431-lte_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	gt_1_asm_h                      // -- Begin function gt_1_asm_h
	.p2align	2
	.type	gt_1_asm_h,@function
gt_1_asm_h:                             // @gt_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B28
	ldr	w8, [x24, #336]
	cbz	w8, .LBB432_2
// %bb.1:                               // %B29
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB432_2:                              // %B25
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB432_15
// %bb.3:                               // %B25
	cmp	x21, x8
	b.hi	.LBB432_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB432_7
// %bb.5:                               // %B16
	cmp	x21, x8
	b.lo	.LBB432_10
// %bb.6:                               // %B21
	ldrb	w8, [x19], #1
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x0
.LBB432_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB432_15
// %bb.8:                               // %B8
	cmp	x21, x8
	b.lo	.LBB432_13
// %bb.9:                               // %B14
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x0
.LBB432_10:                             // %B18
	tst	x21, #0xfffe000000000000
	b.eq	.LBB432_15
// %bb.11:                              // %B20
	scvtf	d0, w22
	add	x8, x21, x8
.LBB432_12:                             // %B20
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x0
.LBB432_13:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB432_15
// %bb.14:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB432_12
.LBB432_15:                             // %B22
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        // =0xa5
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB432_17
// %bb.16:                              // %B24
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB432_17:                             // %B23
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end432:
	.size	gt_1_asm_h, .Lfunc_end432-gt_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	gte_1_asm_h                     // -- Begin function gte_1_asm_h
	.p2align	2
	.type	gte_1_asm_h,@function
gte_1_asm_h:                            // @gte_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B28
	ldr	w8, [x24, #336]
	cbz	w8, .LBB433_2
// %bb.1:                               // %B29
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB433_2:                              // %B25
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB433_15
// %bb.3:                               // %B25
	cmp	x21, x8
	b.hi	.LBB433_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB433_7
// %bb.5:                               // %B16
	cmp	x21, x8
	b.lo	.LBB433_10
// %bb.6:                               // %B21
	ldrb	w8, [x19], #1
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x0
.LBB433_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB433_15
// %bb.8:                               // %B8
	cmp	x21, x8
	b.lo	.LBB433_13
// %bb.9:                               // %B14
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x0
.LBB433_10:                             // %B18
	tst	x21, #0xfffe000000000000
	b.eq	.LBB433_15
// %bb.11:                              // %B20
	scvtf	d0, w22
	add	x8, x21, x8
.LBB433_12:                             // %B20
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x0
.LBB433_13:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB433_15
// %bb.14:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB433_12
.LBB433_15:                             // %B22
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        // =0xa6
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB433_17
// %bb.16:                              // %B24
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB433_17:                             // %B23
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end433:
	.size	gte_1_asm_h, .Lfunc_end433-gte_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	instanceof_1_asm_h              // -- Begin function instanceof_1_asm_h
	.p2align	2
	.type	instanceof_1_asm_h,@function
instanceof_1_asm_h:                     // @instanceof_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB434_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB434_2:                              // %B2
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x29, #64]
	bl	prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	.LBB434_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB434_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end434:
	.size	instanceof_1_asm_h, .Lfunc_end434-instanceof_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	in_1_asm_h                      // -- Begin function in_1_asm_h
	.p2align	2
	.type	in_1_asm_h,@function
in_1_asm_h:                             // @in_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB435_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB435_2:                              // %B2
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x29, #64]
	bl	prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	.LBB435_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB435_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end435:
	.size	in_1_asm_h, .Lfunc_end435-in_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	eq_1_asm_h                      // -- Begin function eq_1_asm_h
	.p2align	2
	.type	eq_1_asm_h,@function
eq_1_asm_h:                             // @eq_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B48
	ldr	w8, [x24, #336]
	cbz	w8, .LBB436_2
// %bb.1:                               // %B49
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB436_2:                              // %B45
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB436_15
// %bb.3:                               // %B45
	cmp	x21, x8
	b.hi	.LBB436_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB436_7
// %bb.5:                               // %B36
	cmp	x21, x8
	b.lo	.LBB436_10
// %bb.6:                               // %B41
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x0
.LBB436_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB436_15
// %bb.8:                               // %B29
	cmp	x21, x8
	b.lo	.LBB436_13
// %bb.9:                               // %B34
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fcmp	d1, d0
	cset	w8, eq
	fcmp	d1, d1
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	csel	w8, wzr, w8, vs
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB436_10:                             // %B38
	tst	x21, #0xfffe000000000000
	b.eq	.LBB436_15
// %bb.11:                              // %B40
	scvtf	d0, w22
	add	x8, x21, x8
.LBB436_12:                             // %B40
	fmov	d1, x8
	fcmp	d0, d1
	cset	w8, eq
	fcmp	d0, d0
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	csel	w8, wzr, w8, vs
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB436_13:                             // %B31
	tst	x21, #0xfffe000000000000
	b.eq	.LBB436_15
// %bb.14:                              // %B33
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB436_12
.LBB436_15:                             // %B8
	cmp	x22, x21
	b.ne	.LBB436_17
.LBB436_16:                             // %B9
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB436_17:                             // %B11
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB436_19
// %bb.18:                              // %B13
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB436_16
	b	.LBB436_22
.LBB436_19:                             // %B18
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB436_22
// %bb.20:                              // %B21
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB436_23
// %bb.21:                              // %B21
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB436_23
.LBB436_22:                             // %B16
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB436_23:                             // %B42
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB436_25
// %bb.24:                              // %B44
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB436_25:                             // %B43
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end436:
	.size	eq_1_asm_h, .Lfunc_end436-eq_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	neq_1_asm_h                     // -- Begin function neq_1_asm_h
	.p2align	2
	.type	neq_1_asm_h,@function
neq_1_asm_h:                            // @neq_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B48
	ldr	w8, [x24, #336]
	cbz	w8, .LBB437_2
// %bb.1:                               // %B49
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB437_2:                              // %B45
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB437_15
// %bb.3:                               // %B45
	cmp	x21, x8
	b.hi	.LBB437_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB437_7
// %bb.5:                               // %B36
	cmp	x21, x8
	b.lo	.LBB437_10
// %bb.6:                               // %B41
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x0
.LBB437_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB437_15
// %bb.8:                               // %B29
	cmp	x21, x8
	b.lo	.LBB437_13
// %bb.9:                               // %B34
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fcmp	d1, d0
	cset	w8, ne
	fcmp	d1, d1
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	csinc	w8, w8, wzr, vc
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB437_10:                             // %B38
	tst	x21, #0xfffe000000000000
	b.eq	.LBB437_15
// %bb.11:                              // %B40
	scvtf	d0, w22
	add	x8, x21, x8
.LBB437_12:                             // %B40
	fmov	d1, x8
	fcmp	d0, d1
	cset	w8, ne
	fcmp	d0, d0
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	csinc	w8, w8, wzr, vc
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB437_13:                             // %B31
	tst	x21, #0xfffe000000000000
	b.eq	.LBB437_15
// %bb.14:                              // %B33
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB437_12
.LBB437_15:                             // %B8
	cmp	x22, x21
	b.ne	.LBB437_17
.LBB437_16:                             // %B9
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB437_17:                             // %B11
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB437_19
// %bb.18:                              // %B13
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB437_16
	b	.LBB437_22
.LBB437_19:                             // %B18
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB437_22
// %bb.20:                              // %B21
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB437_23
// %bb.21:                              // %B21
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB437_23
.LBB437_22:                             // %B16
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB437_23:                             // %B42
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB437_25
// %bb.24:                              // %B44
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB437_25:                             // %B43
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end437:
	.size	neq_1_asm_h, .Lfunc_end437-neq_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	strict_eq_1_asm_h               // -- Begin function strict_eq_1_asm_h
	.p2align	2
	.type	strict_eq_1_asm_h,@function
strict_eq_1_asm_h:                      // @strict_eq_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B34
	ldr	w8, [x24, #336]
	cbz	w8, .LBB438_2
// %bb.1:                               // %B35
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB438_2:                              // %B31
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB438_15
// %bb.3:                               // %B31
	cmp	x21, x8
	b.hi	.LBB438_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB438_7
// %bb.5:                               // %B22
	cmp	x21, x8
	b.lo	.LBB438_10
// %bb.6:                               // %B27
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x0
.LBB438_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB438_15
// %bb.8:                               // %B15
	cmp	x21, x8
	b.lo	.LBB438_13
// %bb.9:                               // %B20
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fcmp	d1, d0
	cset	w8, eq
	fcmp	d1, d1
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	csel	w8, wzr, w8, vs
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB438_10:                             // %B24
	tst	x21, #0xfffe000000000000
	b.eq	.LBB438_15
// %bb.11:                              // %B26
	scvtf	d0, w22
	add	x8, x21, x8
.LBB438_12:                             // %B26
	fmov	d1, x8
	fcmp	d0, d1
	cset	w8, eq
	fcmp	d0, d0
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	csel	w8, wzr, w8, vs
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB438_13:                             // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB438_15
// %bb.14:                              // %B19
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB438_12
.LBB438_15:                             // %B8
	cmp	x22, x21
	b.ne	.LBB438_17
// %bb.16:                              // %B9
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB438_17:                             // %B11
	and	x8, x21, #0xffff000000000003
	mov	x10, #-281474976710653          // =0xffff000000000003
	mov	x11, #2                         // =0x2
	cmp	x8, x10
	movk	x11, #1, lsl #48
	mov	x12, #2                         // =0x2
	ccmp	x8, x11, #4, ne
	movk	x12, #65535, lsl #48
	mov	x13, #-281474976710656          // =0xffff000000000000
	ccmp	x8, x12, #4, ne
	and	x14, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w8, eq
	cmp	x14, x13
	ccmp	x14, x12, #4, ne
	ccmp	x14, x11, #4, ne
	ccmp	x14, x10, #4, ne
	b.ne	.LBB438_19
// %bb.18:                              // %B11
	tbnz	w8, #0, .LBB438_20
.LBB438_19:                             // %B13
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB438_20:                             // %B28
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB438_22
// %bb.21:                              // %B30
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB438_22:                             // %B29
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end438:
	.size	strict_eq_1_asm_h, .Lfunc_end438-strict_eq_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	strict_neq_1_asm_h              // -- Begin function strict_neq_1_asm_h
	.p2align	2
	.type	strict_neq_1_asm_h,@function
strict_neq_1_asm_h:                     // @strict_neq_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B34
	ldr	w8, [x24, #336]
	cbz	w8, .LBB439_2
// %bb.1:                               // %B35
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB439_2:                              // %B31
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB439_15
// %bb.3:                               // %B31
	cmp	x21, x8
	b.hi	.LBB439_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB439_7
// %bb.5:                               // %B22
	cmp	x21, x8
	b.lo	.LBB439_10
// %bb.6:                               // %B27
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x0
.LBB439_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB439_15
// %bb.8:                               // %B15
	cmp	x21, x8
	b.lo	.LBB439_13
// %bb.9:                               // %B20
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fcmp	d1, d0
	cset	w8, ne
	fcmp	d1, d1
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	csinc	w8, w8, wzr, vc
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB439_10:                             // %B24
	tst	x21, #0xfffe000000000000
	b.eq	.LBB439_15
// %bb.11:                              // %B26
	scvtf	d0, w22
	add	x8, x21, x8
.LBB439_12:                             // %B26
	fmov	d1, x8
	fcmp	d0, d1
	cset	w8, ne
	fcmp	d0, d0
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	csinc	w8, w8, wzr, vc
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB439_13:                             // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB439_15
// %bb.14:                              // %B19
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB439_12
.LBB439_15:                             // %B8
	cmp	x22, x21
	b.ne	.LBB439_17
// %bb.16:                              // %B9
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB439_17:                             // %B11
	and	x8, x21, #0xffff000000000003
	mov	x10, #-281474976710653          // =0xffff000000000003
	mov	x11, #2                         // =0x2
	cmp	x8, x10
	movk	x11, #1, lsl #48
	mov	x12, #2                         // =0x2
	ccmp	x8, x11, #4, ne
	movk	x12, #65535, lsl #48
	mov	x13, #-281474976710656          // =0xffff000000000000
	ccmp	x8, x12, #4, ne
	and	x14, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w8, eq
	cmp	x14, x13
	ccmp	x14, x12, #4, ne
	ccmp	x14, x11, #4, ne
	ccmp	x14, x10, #4, ne
	b.ne	.LBB439_19
// %bb.18:                              // %B11
	tbnz	w8, #0, .LBB439_20
.LBB439_19:                             // %B13
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB439_20:                             // %B28
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB439_22
// %bb.21:                              // %B30
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB439_22:                             // %B29
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end439:
	.size	strict_neq_1_asm_h, .Lfunc_end439-strict_neq_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	and_1_asm_h                     // -- Begin function and_1_asm_h
	.p2align	2
	.type	and_1_asm_h,@function
and_1_asm_h:                            // @and_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B32
	ldr	w8, [x24, #336]
	cbz	w8, .LBB440_2
// %bb.1:                               // %B33
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB440_2:                              // %B29
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB440_11
// %bb.3:                               // %B29
	cmp	x21, x8
	b.hi	.LBB440_11
// %bb.4:                               // %B3
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB440_7
// %bb.5:                               // %B20
	cmp	x21, x8
	b.lo	.LBB440_11
// %bb.6:                               // %B25
	mov	w8, w22
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	and	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB440_7:                              // %B5
	tst	x22, #0xfffe000000000000
	b.eq	.LBB440_11
// %bb.8:                               // %B5
	cmp	x21, x8
	b.lo	.LBB440_11
// %bb.9:                               // %B15
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB440_11
// %bb.10:                              // %B16
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	and	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB440_11:                             // %B26
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        // =0xad
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB440_13
// %bb.12:                              // %B28
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB440_13:                             // %B27
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end440:
	.size	and_1_asm_h, .Lfunc_end440-and_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	xor_1_asm_h                     // -- Begin function xor_1_asm_h
	.p2align	2
	.type	xor_1_asm_h,@function
xor_1_asm_h:                            // @xor_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B32
	ldr	w8, [x24, #336]
	cbz	w8, .LBB441_2
// %bb.1:                               // %B33
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB441_2:                              // %B29
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB441_11
// %bb.3:                               // %B29
	cmp	x21, x8
	b.hi	.LBB441_11
// %bb.4:                               // %B3
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB441_7
// %bb.5:                               // %B20
	cmp	x21, x8
	b.lo	.LBB441_11
// %bb.6:                               // %B25
	mov	w8, w22
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	eor	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB441_7:                              // %B5
	tst	x22, #0xfffe000000000000
	b.eq	.LBB441_11
// %bb.8:                               // %B5
	cmp	x21, x8
	b.lo	.LBB441_11
// %bb.9:                               // %B15
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB441_11
// %bb.10:                              // %B16
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	eor	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB441_11:                             // %B26
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        // =0xae
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB441_13
// %bb.12:                              // %B28
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB441_13:                             // %B27
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end441:
	.size	xor_1_asm_h, .Lfunc_end441-xor_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	or_1_asm_h                      // -- Begin function or_1_asm_h
	.p2align	2
	.type	or_1_asm_h,@function
or_1_asm_h:                             // @or_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B32
	ldr	w8, [x24, #336]
	cbz	w8, .LBB442_2
// %bb.1:                               // %B33
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB442_2:                              // %B29
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB442_11
// %bb.3:                               // %B29
	cmp	x21, x8
	b.hi	.LBB442_11
// %bb.4:                               // %B3
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB442_7
// %bb.5:                               // %B20
	cmp	x21, x8
	b.lo	.LBB442_11
// %bb.6:                               // %B25
	mov	w8, w22
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	orr	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB442_7:                              // %B5
	tst	x22, #0xfffe000000000000
	b.eq	.LBB442_11
// %bb.8:                               // %B5
	cmp	x21, x8
	b.lo	.LBB442_11
// %bb.9:                               // %B15
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB442_11
// %bb.10:                              // %B16
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	orr	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB442_11:                             // %B26
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        // =0xaf
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB442_13
// %bb.12:                              // %B28
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB442_13:                             // %B27
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.Lfunc_end442:
	.size	or_1_asm_h, .Lfunc_end442-or_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	nop_1_asm_h                     // -- Begin function nop_1_asm_h
	.p2align	2
	.type	nop_1_asm_h,@function
nop_1_asm_h:                            // @nop_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB443_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB443_2:                              // %B1
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end443:
	.size	nop_1_asm_h, .Lfunc_end443-nop_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_minus1_1_asm_h             // -- Begin function push_minus1_1_asm_h
	.p2align	2
	.type	push_minus1_1_asm_h,@function
push_minus1_1_asm_h:                    // @push_minus1_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB444_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB444_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, #-562945658454017          // =0xfffe0000ffffffff
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end444:
	.size	push_minus1_1_asm_h, .Lfunc_end444-push_minus1_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_0_1_asm_h                  // -- Begin function push_0_1_asm_h
	.p2align	2
	.type	push_0_1_asm_h,@function
push_0_1_asm_h:                         // @push_0_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB445_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB445_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, #-562949953421312          // =0xfffe000000000000
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end445:
	.size	push_0_1_asm_h, .Lfunc_end445-push_0_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_1_1_asm_h                  // -- Begin function push_1_1_asm_h
	.p2align	2
	.type	push_1_1_asm_h,@function
push_1_1_asm_h:                         // @push_1_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB446_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB446_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, #-562949953421311          // =0xfffe000000000001
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end446:
	.size	push_1_1_asm_h, .Lfunc_end446-push_1_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_2_1_asm_h                  // -- Begin function push_2_1_asm_h
	.p2align	2
	.type	push_2_1_asm_h,@function
push_2_1_asm_h:                         // @push_2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB447_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB447_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, #2                         // =0x2
	ldr	x0, [x25, x8, lsl #3]
	movk	x21, #65534, lsl #48
	br	x0
.Lfunc_end447:
	.size	push_2_1_asm_h, .Lfunc_end447-push_2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_3_1_asm_h                  // -- Begin function push_3_1_asm_h
	.p2align	2
	.type	push_3_1_asm_h,@function
push_3_1_asm_h:                         // @push_3_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB448_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB448_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, #-562949953421309          // =0xfffe000000000003
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end448:
	.size	push_3_1_asm_h, .Lfunc_end448-push_3_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_4_1_asm_h                  // -- Begin function push_4_1_asm_h
	.p2align	2
	.type	push_4_1_asm_h,@function
push_4_1_asm_h:                         // @push_4_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB449_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB449_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, #4                         // =0x4
	ldr	x0, [x25, x8, lsl #3]
	movk	x21, #65534, lsl #48
	br	x0
.Lfunc_end449:
	.size	push_4_1_asm_h, .Lfunc_end449-push_4_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_5_1_asm_h                  // -- Begin function push_5_1_asm_h
	.p2align	2
	.type	push_5_1_asm_h,@function
push_5_1_asm_h:                         // @push_5_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB450_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB450_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, #5                         // =0x5
	ldr	x0, [x25, x8, lsl #3]
	movk	x21, #65534, lsl #48
	br	x0
.Lfunc_end450:
	.size	push_5_1_asm_h, .Lfunc_end450-push_5_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_6_1_asm_h                  // -- Begin function push_6_1_asm_h
	.p2align	2
	.type	push_6_1_asm_h,@function
push_6_1_asm_h:                         // @push_6_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB451_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB451_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	movk	x21, #65534, lsl #48
	br	x0
.Lfunc_end451:
	.size	push_6_1_asm_h, .Lfunc_end451-push_6_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_7_1_asm_h                  // -- Begin function push_7_1_asm_h
	.p2align	2
	.type	push_7_1_asm_h,@function
push_7_1_asm_h:                         // @push_7_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB452_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB452_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, #-562949953421305          // =0xfffe000000000007
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end452:
	.size	push_7_1_asm_h, .Lfunc_end452-push_7_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_i8_1_asm_h                 // -- Begin function push_i8_1_asm_h
	.p2align	2
	.type	push_i8_1_asm_h,@function
push_i8_1_asm_h:                        // @push_i8_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB453_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB453_2:                              // %B1
	ldrsb	x8, [x19]
	ldrb	w10, [x19, #1]
	mov	x11, #-562949953421312          // =0xfffe000000000000
	add	x25, x25, #1936
	add	x19, x19, #2
	bfxil	x11, x8, #0, #32
	ldr	x0, [x25, x10, lsl #3]
	mov	x21, x11
	br	x0
.Lfunc_end453:
	.size	push_i8_1_asm_h, .Lfunc_end453-push_i8_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_i16_1_asm_h                // -- Begin function push_i16_1_asm_h
	.p2align	2
	.type	push_i16_1_asm_h,@function
push_i16_1_asm_h:                       // @push_i16_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB454_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB454_2:                              // %B1
	ldrsh	x8, [x19]
	ldrb	w10, [x19, #2]
	mov	x11, #-562949953421312          // =0xfffe000000000000
	add	x25, x25, #1936
	add	x19, x19, #3
	bfxil	x11, x8, #0, #32
	ldr	x0, [x25, x10, lsl #3]
	mov	x21, x11
	br	x0
.Lfunc_end454:
	.size	push_i16_1_asm_h, .Lfunc_end454-push_i16_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_const8_1_asm_h             // -- Begin function push_const8_1_asm_h
	.p2align	2
	.type	push_const8_1_asm_h,@function
push_const8_1_asm_h:                    // @push_const8_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB455_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB455_2:                              // %B4
	ldrb	w8, [x19]
	ldr	w10, [x24, #336]
	ldr	x11, [x23, x8, lsl #3]
	cbz	w10, .LBB455_4
// %bb.3:                               // %B5
	mov	x8, x20
	mov	x0, x24
	mov	x1, x11
	mov	x2, x19
	str	x22, [x8], #8
	str	x8, [x29, #64]
	str	x20, [sp, #8]                   // 8-byte Folded Spill
	mov	x20, x11
	bl	DebuggerPause
	mov	x11, x20
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
.LBB455_4:                              // %B2
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	add	x19, x19, #2
	mov	x21, x11
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.Lfunc_end455:
	.size	push_const8_1_asm_h, .Lfunc_end455-push_const8_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	fclosure8_1_asm_h               // -- Begin function fclosure8_1_asm_h
	.p2align	2
	.type	fclosure8_1_asm_h,@function
fclosure8_1_asm_h:                      // @fclosure8_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB456_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB456_2:                              // %B2
	ldrb	w8, [x19]
	mov	x10, x20
	mov	x0, x24
	mov	x2, x26
	mov	x3, x29
	ldr	x1, [x23, x8, lsl #3]
	str	x22, [x10], #8
	str	x10, [x29, #64]
	bl	js_closure_gc
	cmp	x0, #130
	b.eq	.LBB456_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	add	x19, x19, #2
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB456_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end456:
	.size	fclosure8_1_asm_h, .Lfunc_end456-fclosure8_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_empty_string_1_asm_h       // -- Begin function push_empty_string_1_asm_h
	.p2align	2
	.type	push_empty_string_1_asm_h,@function
push_empty_string_1_asm_h:              // @push_empty_string_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB457_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB457_2:                              // %B2
	mov	x8, x20
	mov	x0, x24
	mov	w1, #47                         // =0x2f
	mov	w2, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB457_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB457_4:                              // %B3
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end457:
	.size	push_empty_string_1_asm_h, .Lfunc_end457-push_empty_string_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc8_1_asm_h                // -- Begin function get_loc8_1_asm_h
	.p2align	2
	.type	get_loc8_1_asm_h,@function
get_loc8_1_asm_h:                       // @get_loc8_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB458_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB458_2:                              // %B1
	ldrb	w8, [x19, #1]
	ldrb	w10, [x19], #2
	add	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	ldr	x21, [x27, x10, lsl #3]
	br	x0
.Lfunc_end458:
	.size	get_loc8_1_asm_h, .Lfunc_end458-get_loc8_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc8_1_asm_h                // -- Begin function put_loc8_1_asm_h
	.p2align	2
	.type	put_loc8_1_asm_h,@function
put_loc8_1_asm_h:                       // @put_loc8_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB459_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB459_2:                              // %B1
	ldrb	w8, [x19]
	sub	x25, x25, #1936
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end459:
	.size	put_loc8_1_asm_h, .Lfunc_end459-put_loc8_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc8_1_asm_h                // -- Begin function set_loc8_1_asm_h
	.p2align	2
	.type	set_loc8_1_asm_h,@function
set_loc8_1_asm_h:                       // @set_loc8_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB460_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB460_2:                              // %B1
	ldrb	w8, [x19]
	str	x22, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end460:
	.size	set_loc8_1_asm_h, .Lfunc_end460-set_loc8_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc0_1_asm_h                // -- Begin function get_loc0_1_asm_h
	.p2align	2
	.type	get_loc0_1_asm_h,@function
get_loc0_1_asm_h:                       // @get_loc0_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB461_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB461_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x21, [x27]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end461:
	.size	get_loc0_1_asm_h, .Lfunc_end461-get_loc0_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc1_1_asm_h                // -- Begin function get_loc1_1_asm_h
	.p2align	2
	.type	get_loc1_1_asm_h,@function
get_loc1_1_asm_h:                       // @get_loc1_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB462_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB462_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x21, [x27, #8]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end462:
	.size	get_loc1_1_asm_h, .Lfunc_end462-get_loc1_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc2_1_asm_h                // -- Begin function get_loc2_1_asm_h
	.p2align	2
	.type	get_loc2_1_asm_h,@function
get_loc2_1_asm_h:                       // @get_loc2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB463_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB463_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x21, [x27, #16]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end463:
	.size	get_loc2_1_asm_h, .Lfunc_end463-get_loc2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc3_1_asm_h                // -- Begin function get_loc3_1_asm_h
	.p2align	2
	.type	get_loc3_1_asm_h,@function
get_loc3_1_asm_h:                       // @get_loc3_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB464_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB464_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x21, [x27, #24]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end464:
	.size	get_loc3_1_asm_h, .Lfunc_end464-get_loc3_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc0_1_asm_h                // -- Begin function put_loc0_1_asm_h
	.p2align	2
	.type	put_loc0_1_asm_h,@function
put_loc0_1_asm_h:                       // @put_loc0_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB465_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB465_2:                              // %B1
	str	x22, [x27]
	sub	x25, x25, #1936
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end465:
	.size	put_loc0_1_asm_h, .Lfunc_end465-put_loc0_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc1_1_asm_h                // -- Begin function put_loc1_1_asm_h
	.p2align	2
	.type	put_loc1_1_asm_h,@function
put_loc1_1_asm_h:                       // @put_loc1_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB466_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB466_2:                              // %B1
	str	x22, [x27, #8]
	sub	x25, x25, #1936
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end466:
	.size	put_loc1_1_asm_h, .Lfunc_end466-put_loc1_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc2_1_asm_h                // -- Begin function put_loc2_1_asm_h
	.p2align	2
	.type	put_loc2_1_asm_h,@function
put_loc2_1_asm_h:                       // @put_loc2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB467_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB467_2:                              // %B1
	str	x22, [x27, #16]
	sub	x25, x25, #1936
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end467:
	.size	put_loc2_1_asm_h, .Lfunc_end467-put_loc2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc3_1_asm_h                // -- Begin function put_loc3_1_asm_h
	.p2align	2
	.type	put_loc3_1_asm_h,@function
put_loc3_1_asm_h:                       // @put_loc3_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB468_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB468_2:                              // %B1
	str	x22, [x27, #24]
	sub	x25, x25, #1936
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end468:
	.size	put_loc3_1_asm_h, .Lfunc_end468-put_loc3_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc0_1_asm_h                // -- Begin function set_loc0_1_asm_h
	.p2align	2
	.type	set_loc0_1_asm_h,@function
set_loc0_1_asm_h:                       // @set_loc0_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB469_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB469_2:                              // %B1
	str	x22, [x27]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end469:
	.size	set_loc0_1_asm_h, .Lfunc_end469-set_loc0_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc1_1_asm_h                // -- Begin function set_loc1_1_asm_h
	.p2align	2
	.type	set_loc1_1_asm_h,@function
set_loc1_1_asm_h:                       // @set_loc1_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB470_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB470_2:                              // %B1
	str	x22, [x27, #8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end470:
	.size	set_loc1_1_asm_h, .Lfunc_end470-set_loc1_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc2_1_asm_h                // -- Begin function set_loc2_1_asm_h
	.p2align	2
	.type	set_loc2_1_asm_h,@function
set_loc2_1_asm_h:                       // @set_loc2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB471_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB471_2:                              // %B1
	str	x22, [x27, #16]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end471:
	.size	set_loc2_1_asm_h, .Lfunc_end471-set_loc2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc3_1_asm_h                // -- Begin function set_loc3_1_asm_h
	.p2align	2
	.type	set_loc3_1_asm_h,@function
set_loc3_1_asm_h:                       // @set_loc3_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB472_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB472_2:                              // %B1
	str	x22, [x27, #24]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end472:
	.size	set_loc3_1_asm_h, .Lfunc_end472-set_loc3_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_arg0_1_asm_h                // -- Begin function get_arg0_1_asm_h
	.p2align	2
	.type	get_arg0_1_asm_h,@function
get_arg0_1_asm_h:                       // @get_arg0_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB473_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB473_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x21, [x28]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end473:
	.size	get_arg0_1_asm_h, .Lfunc_end473-get_arg0_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_arg1_1_asm_h                // -- Begin function get_arg1_1_asm_h
	.p2align	2
	.type	get_arg1_1_asm_h,@function
get_arg1_1_asm_h:                       // @get_arg1_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB474_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB474_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x21, [x28, #8]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end474:
	.size	get_arg1_1_asm_h, .Lfunc_end474-get_arg1_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_arg2_1_asm_h                // -- Begin function get_arg2_1_asm_h
	.p2align	2
	.type	get_arg2_1_asm_h,@function
get_arg2_1_asm_h:                       // @get_arg2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB475_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB475_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x21, [x28, #16]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end475:
	.size	get_arg2_1_asm_h, .Lfunc_end475-get_arg2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_arg3_1_asm_h                // -- Begin function get_arg3_1_asm_h
	.p2align	2
	.type	get_arg3_1_asm_h,@function
get_arg3_1_asm_h:                       // @get_arg3_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB476_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB476_2:                              // %B1
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x21, [x28, #24]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end476:
	.size	get_arg3_1_asm_h, .Lfunc_end476-get_arg3_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_arg0_1_asm_h                // -- Begin function put_arg0_1_asm_h
	.p2align	2
	.type	put_arg0_1_asm_h,@function
put_arg0_1_asm_h:                       // @put_arg0_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB477_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB477_2:                              // %B1
	str	x22, [x28]
	sub	x25, x25, #1936
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end477:
	.size	put_arg0_1_asm_h, .Lfunc_end477-put_arg0_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_arg1_1_asm_h                // -- Begin function put_arg1_1_asm_h
	.p2align	2
	.type	put_arg1_1_asm_h,@function
put_arg1_1_asm_h:                       // @put_arg1_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB478_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB478_2:                              // %B1
	str	x22, [x28, #8]
	sub	x25, x25, #1936
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end478:
	.size	put_arg1_1_asm_h, .Lfunc_end478-put_arg1_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_arg2_1_asm_h                // -- Begin function put_arg2_1_asm_h
	.p2align	2
	.type	put_arg2_1_asm_h,@function
put_arg2_1_asm_h:                       // @put_arg2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB479_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB479_2:                              // %B1
	str	x22, [x28, #16]
	sub	x25, x25, #1936
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end479:
	.size	put_arg2_1_asm_h, .Lfunc_end479-put_arg2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_arg3_1_asm_h                // -- Begin function put_arg3_1_asm_h
	.p2align	2
	.type	put_arg3_1_asm_h,@function
put_arg3_1_asm_h:                       // @put_arg3_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB480_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB480_2:                              // %B1
	str	x22, [x28, #24]
	sub	x25, x25, #1936
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end480:
	.size	put_arg3_1_asm_h, .Lfunc_end480-put_arg3_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_arg0_1_asm_h                // -- Begin function set_arg0_1_asm_h
	.p2align	2
	.type	set_arg0_1_asm_h,@function
set_arg0_1_asm_h:                       // @set_arg0_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB481_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB481_2:                              // %B1
	str	x22, [x28]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end481:
	.size	set_arg0_1_asm_h, .Lfunc_end481-set_arg0_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_arg1_1_asm_h                // -- Begin function set_arg1_1_asm_h
	.p2align	2
	.type	set_arg1_1_asm_h,@function
set_arg1_1_asm_h:                       // @set_arg1_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB482_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB482_2:                              // %B1
	str	x22, [x28, #8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end482:
	.size	set_arg1_1_asm_h, .Lfunc_end482-set_arg1_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_arg2_1_asm_h                // -- Begin function set_arg2_1_asm_h
	.p2align	2
	.type	set_arg2_1_asm_h,@function
set_arg2_1_asm_h:                       // @set_arg2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB483_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB483_2:                              // %B1
	str	x22, [x28, #16]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end483:
	.size	set_arg2_1_asm_h, .Lfunc_end483-set_arg2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_arg3_1_asm_h                // -- Begin function set_arg3_1_asm_h
	.p2align	2
	.type	set_arg3_1_asm_h,@function
set_arg3_1_asm_h:                       // @set_arg3_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB484_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB484_2:                              // %B1
	str	x22, [x28, #24]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end484:
	.size	set_arg3_1_asm_h, .Lfunc_end484-set_arg3_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref0_1_asm_h            // -- Begin function get_var_ref0_1_asm_h
	.p2align	2
	.type	get_var_ref0_1_asm_h,@function
get_var_ref0_1_asm_h:                   // @get_var_ref0_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB485_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB485_2:                              // %B1
	ldr	x8, [x26]
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	ldr	x8, [x8, #32]
	ldr	x0, [x25, x10, lsl #3]
	ldr	x21, [x8]
	br	x0
.Lfunc_end485:
	.size	get_var_ref0_1_asm_h, .Lfunc_end485-get_var_ref0_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref1_1_asm_h            // -- Begin function get_var_ref1_1_asm_h
	.p2align	2
	.type	get_var_ref1_1_asm_h,@function
get_var_ref1_1_asm_h:                   // @get_var_ref1_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB486_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB486_2:                              // %B1
	ldr	x8, [x26, #8]
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	ldr	x8, [x8, #32]
	ldr	x0, [x25, x10, lsl #3]
	ldr	x21, [x8]
	br	x0
.Lfunc_end486:
	.size	get_var_ref1_1_asm_h, .Lfunc_end486-get_var_ref1_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref2_1_asm_h            // -- Begin function get_var_ref2_1_asm_h
	.p2align	2
	.type	get_var_ref2_1_asm_h,@function
get_var_ref2_1_asm_h:                   // @get_var_ref2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB487_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB487_2:                              // %B1
	ldr	x8, [x26, #16]
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	ldr	x8, [x8, #32]
	ldr	x0, [x25, x10, lsl #3]
	ldr	x21, [x8]
	br	x0
.Lfunc_end487:
	.size	get_var_ref2_1_asm_h, .Lfunc_end487-get_var_ref2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref3_1_asm_h            // -- Begin function get_var_ref3_1_asm_h
	.p2align	2
	.type	get_var_ref3_1_asm_h,@function
get_var_ref3_1_asm_h:                   // @get_var_ref3_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB488_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB488_2:                              // %B1
	ldr	x8, [x26, #24]
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	ldr	x8, [x8, #32]
	ldr	x0, [x25, x10, lsl #3]
	ldr	x21, [x8]
	br	x0
.Lfunc_end488:
	.size	get_var_ref3_1_asm_h, .Lfunc_end488-get_var_ref3_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref0_1_asm_h            // -- Begin function put_var_ref0_1_asm_h
	.p2align	2
	.type	put_var_ref0_1_asm_h,@function
put_var_ref0_1_asm_h:                   // @put_var_ref0_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB489_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB489_2:                              // %B1
	ldr	x8, [x26]
	sub	x25, x25, #1936
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end489:
	.size	put_var_ref0_1_asm_h, .Lfunc_end489-put_var_ref0_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref1_1_asm_h            // -- Begin function put_var_ref1_1_asm_h
	.p2align	2
	.type	put_var_ref1_1_asm_h,@function
put_var_ref1_1_asm_h:                   // @put_var_ref1_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB490_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB490_2:                              // %B1
	ldr	x8, [x26, #8]
	sub	x25, x25, #1936
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end490:
	.size	put_var_ref1_1_asm_h, .Lfunc_end490-put_var_ref1_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref2_1_asm_h            // -- Begin function put_var_ref2_1_asm_h
	.p2align	2
	.type	put_var_ref2_1_asm_h,@function
put_var_ref2_1_asm_h:                   // @put_var_ref2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB491_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB491_2:                              // %B1
	ldr	x8, [x26, #16]
	sub	x25, x25, #1936
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end491:
	.size	put_var_ref2_1_asm_h, .Lfunc_end491-put_var_ref2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref3_1_asm_h            // -- Begin function put_var_ref3_1_asm_h
	.p2align	2
	.type	put_var_ref3_1_asm_h,@function
put_var_ref3_1_asm_h:                   // @put_var_ref3_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB492_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB492_2:                              // %B1
	ldr	x8, [x26, #24]
	sub	x25, x25, #1936
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end492:
	.size	put_var_ref3_1_asm_h, .Lfunc_end492-put_var_ref3_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_var_ref0_1_asm_h            // -- Begin function set_var_ref0_1_asm_h
	.p2align	2
	.type	set_var_ref0_1_asm_h,@function
set_var_ref0_1_asm_h:                   // @set_var_ref0_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB493_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB493_2:                              // %B1
	ldr	x8, [x26]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end493:
	.size	set_var_ref0_1_asm_h, .Lfunc_end493-set_var_ref0_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_var_ref1_1_asm_h            // -- Begin function set_var_ref1_1_asm_h
	.p2align	2
	.type	set_var_ref1_1_asm_h,@function
set_var_ref1_1_asm_h:                   // @set_var_ref1_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB494_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB494_2:                              // %B1
	ldr	x8, [x26, #8]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end494:
	.size	set_var_ref1_1_asm_h, .Lfunc_end494-set_var_ref1_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_var_ref2_1_asm_h            // -- Begin function set_var_ref2_1_asm_h
	.p2align	2
	.type	set_var_ref2_1_asm_h,@function
set_var_ref2_1_asm_h:                   // @set_var_ref2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB495_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB495_2:                              // %B1
	ldr	x8, [x26, #16]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end495:
	.size	set_var_ref2_1_asm_h, .Lfunc_end495-set_var_ref2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_var_ref3_1_asm_h            // -- Begin function set_var_ref3_1_asm_h
	.p2align	2
	.type	set_var_ref3_1_asm_h,@function
set_var_ref3_1_asm_h:                   // @set_var_ref3_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB496_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB496_2:                              // %B1
	ldr	x8, [x26, #24]
	ldr	x8, [x8, #32]
	str	x22, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end496:
	.size	set_var_ref3_1_asm_h, .Lfunc_end496-set_var_ref3_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_length_1_asm_h              // -- Begin function get_length_1_asm_h
	.p2align	2
	.type	get_length_1_asm_h,@function
get_length_1_asm_h:                     // @get_length_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB497_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB497_2:                              // %B2
	mov	x21, x22
	mov	w9, #48                         // =0x30
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB497_4
.LBB497_3:                              // %B8
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB497_4:                              // %B4
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #48                         // =0x30
	mov	x3, x22
	mov	w4, wzr
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.ne	.LBB497_3
// %bb.5:                               // %B5
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.Lfunc_end497:
	.size	get_length_1_asm_h, .Lfunc_end497-get_length_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	if_false8_1_asm_h               // -- Begin function if_false8_1_asm_h
	.p2align	2
	.type	if_false8_1_asm_h,@function
if_false8_1_asm_h:                      // @if_false8_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B27
	ldr	w8, [x24, #336]
	cbz	w8, .LBB498_2
// %bb.1:                               // %B28
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB498_2:                              // %B24
	cmp	x22, #5
	b.le	.LBB498_6
// %bb.3:                               // %B24
	cmp	x22, #6
	b.eq	.LBB498_8
// %bb.4:                               // %B24
	cmp	x22, #7
	b.eq	.LBB498_11
// %bb.5:                               // %B24
	cmp	x22, #18
	b.eq	.LBB498_8
	b	.LBB498_9
.LBB498_6:                              // %B24
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB498_8
// %bb.7:                               // %B24
	cmp	x22, #2
	b.ne	.LBB498_9
.LBB498_8:                              // %B4
	ldrsb	x8, [x19]
	sub	x25, x25, #1936
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB498_9:                              // %B10
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB498_15
// %bb.10:                              // %B12
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB498_12
.LBB498_11:                             // %B20
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB498_12:                             // %B14
	tst	x22, #0xfffe000000000000
	b.eq	.LBB498_15
// %bb.13:                              // %B18
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB498_8
	b.vs	.LBB498_8
// %bb.14:                              // %B18
	tbnz	w8, #0, .LBB498_11
	b	.LBB498_8
.LBB498_15:                             // %B16
	str	x22, [x20], #8
	sub	x25, x25, #1936
	mov	x9, x22
	b	SlowToBoolean_asm_h
.Lfunc_end498:
	.size	if_false8_1_asm_h, .Lfunc_end498-if_false8_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	if_true8_1_asm_h                // -- Begin function if_true8_1_asm_h
	.p2align	2
	.type	if_true8_1_asm_h,@function
if_true8_1_asm_h:                       // @if_true8_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B27
	ldr	w8, [x24, #336]
	cbz	w8, .LBB499_2
// %bb.1:                               // %B28
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB499_2:                              // %B24
	cmp	x22, #5
	b.le	.LBB499_6
// %bb.3:                               // %B24
	cmp	x22, #6
	b.eq	.LBB499_8
// %bb.4:                               // %B24
	cmp	x22, #7
	b.eq	.LBB499_11
// %bb.5:                               // %B24
	cmp	x22, #18
	b.eq	.LBB499_8
	b	.LBB499_9
.LBB499_6:                              // %B24
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB499_8
// %bb.7:                               // %B24
	cmp	x22, #2
	b.ne	.LBB499_9
.LBB499_8:                              // %B4
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB499_9:                              // %B10
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB499_15
// %bb.10:                              // %B12
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB499_12
.LBB499_11:                             // %B20
	ldrsb	x8, [x19]
	sub	x25, x25, #1936
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB499_12:                             // %B14
	tst	x22, #0xfffe000000000000
	b.eq	.LBB499_15
// %bb.13:                              // %B18
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB499_8
	b.vs	.LBB499_8
// %bb.14:                              // %B18
	tbnz	w8, #0, .LBB499_11
	b	.LBB499_8
.LBB499_15:                             // %B16
	str	x22, [x20], #8
	sub	x25, x25, #1936
	mov	x9, x22
	b	SlowToBoolean_asm_h
.Lfunc_end499:
	.size	if_true8_1_asm_h, .Lfunc_end499-if_true8_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	goto8_1_asm_h                   // -- Begin function goto8_1_asm_h
	.p2align	2
	.type	goto8_1_asm_h,@function
goto8_1_asm_h:                          // @goto8_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB500_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB500_2:                              // %B1
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end500:
	.size	goto8_1_asm_h, .Lfunc_end500-goto8_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	goto16_1_asm_h                  // -- Begin function goto16_1_asm_h
	.p2align	2
	.type	goto16_1_asm_h,@function
goto16_1_asm_h:                         // @goto16_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB501_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB501_2:                              // %B1
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end501:
	.size	goto16_1_asm_h, .Lfunc_end501-goto16_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call0_1_asm_h                   // -- Begin function call0_1_asm_h
	.p2align	2
	.type	call0_1_asm_h,@function
call0_1_asm_h:                          // @call0_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB502_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB502_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	call0_0_asm_h
.Lfunc_end502:
	.size	call0_1_asm_h, .Lfunc_end502-call0_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call1_1_asm_h                   // -- Begin function call1_1_asm_h
	.p2align	2
	.type	call1_1_asm_h,@function
call1_1_asm_h:                          // @call1_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB503_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB503_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	call1_0_asm_h
.Lfunc_end503:
	.size	call1_1_asm_h, .Lfunc_end503-call1_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call2_1_asm_h                   // -- Begin function call2_1_asm_h
	.p2align	2
	.type	call2_1_asm_h,@function
call2_1_asm_h:                          // @call2_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB504_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB504_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	call2_0_asm_h
.Lfunc_end504:
	.size	call2_1_asm_h, .Lfunc_end504-call2_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call3_1_asm_h                   // -- Begin function call3_1_asm_h
	.p2align	2
	.type	call3_1_asm_h,@function
call3_1_asm_h:                          // @call3_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB505_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB505_2:                              // %B1
	str	x22, [x20], #8
	sub	x25, x25, #1936
	b	call3_0_asm_h
.Lfunc_end505:
	.size	call3_1_asm_h, .Lfunc_end505-call3_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	is_undefined_1_asm_h            // -- Begin function is_undefined_1_asm_h
	.p2align	2
	.type	is_undefined_1_asm_h,@function
is_undefined_1_asm_h:                   // @is_undefined_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	ldr	w8, [x24, #336]
	cbz	w8, .LBB506_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB506_2:                              // %B3
	cmp	x22, #18
	b.ne	.LBB506_4
// %bb.3:                               // %B4
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB506_4:                              // %B6
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end506:
	.size	is_undefined_1_asm_h, .Lfunc_end506-is_undefined_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	is_null_1_asm_h                 // -- Begin function is_null_1_asm_h
	.p2align	2
	.type	is_null_1_asm_h,@function
is_null_1_asm_h:                        // @is_null_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	ldr	w8, [x24, #336]
	cbz	w8, .LBB507_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB507_2:                              // %B3
	cmp	x22, #2
	b.ne	.LBB507_4
// %bb.3:                               // %B4
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB507_4:                              // %B6
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end507:
	.size	is_null_1_asm_h, .Lfunc_end507-is_null_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	is_function_1_asm_h             // -- Begin function is_function_1_asm_h
	.p2align	2
	.type	is_function_1_asm_h,@function
is_function_1_asm_h:                    // @is_function_1_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	ldr	w8, [x24, #336]
	cbz	w8, .LBB508_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB508_2:                              // %B2
	mov	x0, x24
	mov	x1, x22
	bl	js_operator_typeof_gc
	cmp	w0, #27
	b.ne	.LBB508_4
// %bb.3:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB508_4:                              // %B6
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end508:
	.size	is_function_1_asm_h, .Lfunc_end508-is_function_1_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	invalid_2_asm_h                 // -- Begin function invalid_2_asm_h
	.p2align	2
	.type	invalid_2_asm_h,@function
invalid_2_asm_h:                        // @invalid_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B0
	ldr	x8, [x29, #8]
	adrp	x1, .L__unnamed_16
	add	x1, x1, :lo12:.L__unnamed_16
	mov	x0, x24
	mov	w3, wzr
	ldr	x8, [x8, #48]
	ldr	w8, [x8, #8]
	str	x20, [x29, #64]
	mvn	w8, w8
	add	w2, w8, w19
	bl	LEPUS_ThrowInternalError
	b	exception_asm_h
.Lfunc_end509:
	.size	invalid_2_asm_h, .Lfunc_end509-invalid_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_i32_2_asm_h                // -- Begin function push_i32_2_asm_h
	.p2align	2
	.type	push_i32_2_asm_h,@function
push_i32_2_asm_h:                       // @push_i32_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB510_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB510_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19, #4]
	ldr	w10, [x19], #5
	ldr	x0, [x25, x8, lsl #3]
	orr	x21, x10, #0xfffe000000000000
	br	x0
.Lfunc_end510:
	.size	push_i32_2_asm_h, .Lfunc_end510-push_i32_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_const_2_asm_h              // -- Begin function push_const_2_asm_h
	.p2align	2
	.type	push_const_2_asm_h,@function
push_const_2_asm_h:                     // @push_const_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB511_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB511_2:                              // %B4
	str	x22, [x20], #8
	ldrsw	x8, [x19]
	ldr	w10, [x24, #336]
	ldr	x11, [x23, x8, lsl #3]
	cbz	w10, .LBB511_4
// %bb.3:                               // %B5
	mov	x8, x20
	mov	x0, x24
	mov	x1, x11
	mov	x2, x19
	str	x21, [x8], #8
	str	x8, [x29, #64]
	str	x20, [sp, #8]                   // 8-byte Folded Spill
	mov	x20, x11
	bl	DebuggerPause
	mov	x11, x20
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
.LBB511_4:                              // %B2
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x11
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.Lfunc_end511:
	.size	push_const_2_asm_h, .Lfunc_end511-push_const_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	fclosure_2_asm_h                // -- Begin function fclosure_2_asm_h
	.p2align	2
	.type	fclosure_2_asm_h,@function
fclosure_2_asm_h:                       // @fclosure_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB512_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB512_2:                              // %B2
	str	x22, [x20]
	mov	x0, x24
	mov	x2, x26
	ldrsw	x8, [x19]
	mov	x3, x29
	ldr	x1, [x23, x8, lsl #3]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x29, #64]
	bl	js_closure_gc
	cmp	x0, #130
	b.eq	.LBB512_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB512_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.Lfunc_end512:
	.size	fclosure_2_asm_h, .Lfunc_end512-fclosure_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_atom_value_2_asm_h         // -- Begin function push_atom_value_2_asm_h
	.p2align	2
	.type	push_atom_value_2_asm_h,@function
push_atom_value_2_asm_h:                // @push_atom_value_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB513_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB513_2:                              // %B2
	str	x22, [x20]
	mov	x0, x24
	mov	w2, wzr
	ldr	w1, [x19]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB513_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB513_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.Lfunc_end513:
	.size	push_atom_value_2_asm_h, .Lfunc_end513-push_atom_value_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	private_symbol_2_asm_h          // -- Begin function private_symbol_2_asm_h
	.p2align	2
	.type	private_symbol_2_asm_h,@function
private_symbol_2_asm_h:                 // @private_symbol_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB514_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB514_2:                              // %B2
	str	x22, [x20]
	mov	x0, x24
	mov	w2, #4                          // =0x4
	ldr	w1, [x19]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x29, #64]
	bl	JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	.LBB514_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB514_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.Lfunc_end514:
	.size	private_symbol_2_asm_h, .Lfunc_end514-private_symbol_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	undefined_2_asm_h               // -- Begin function undefined_2_asm_h
	.p2align	2
	.type	undefined_2_asm_h,@function
undefined_2_asm_h:                      // @undefined_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB515_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB515_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #18                        // =0x12
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end515:
	.size	undefined_2_asm_h, .Lfunc_end515-undefined_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	null_2_asm_h                    // -- Begin function null_2_asm_h
	.p2align	2
	.type	null_2_asm_h,@function
null_2_asm_h:                           // @null_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB516_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB516_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #2                         // =0x2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end516:
	.size	null_2_asm_h, .Lfunc_end516-null_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_this_2_asm_h               // -- Begin function push_this_2_asm_h
	.p2align	2
	.type	push_this_2_asm_h,@function
push_this_2_asm_h:                      // @push_this_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB517_2
// %bb.1:                               // %B17
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB517_2:                              // %B13
	str	x22, [x20], #8
	ldr	w8, [x29, #60]
	ldr	x1, [x29, #120]
	tbnz	w8, #0, .LBB517_4
// %bb.3:                               // %B13
	ldr	x8, [x29, #120]
	and	x10, x8, #0xfffffffffffffffe
	and	x10, x10, #0xffff000000000003
	cbnz	x10, .LBB517_5
.LBB517_4:                              // %B4
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB517_5:                              // %B7
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	.LBB517_7
// %bb.6:                               // %B8
	ldrb	w8, [x19], #1
	ldr	x10, [x24, #224]
	mov	x22, x21
	ldr	x0, [x25, x8, lsl #3]
	mov	x21, x10
	br	x0
.LBB517_7:                              // %B10
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB517_9
// %bb.8:                               // %B12
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB517_9:                              // %B11
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.Lfunc_end517:
	.size	push_this_2_asm_h, .Lfunc_end517-push_this_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_false_2_asm_h              // -- Begin function push_false_2_asm_h
	.p2align	2
	.type	push_false_2_asm_h,@function
push_false_2_asm_h:                     // @push_false_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB518_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB518_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end518:
	.size	push_false_2_asm_h, .Lfunc_end518-push_false_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_true_2_asm_h               // -- Begin function push_true_2_asm_h
	.p2align	2
	.type	push_true_2_asm_h,@function
push_true_2_asm_h:                      // @push_true_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB519_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB519_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	w21, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end519:
	.size	push_true_2_asm_h, .Lfunc_end519-push_true_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	object_2_asm_h                  // -- Begin function object_2_asm_h
	.p2align	2
	.type	object_2_asm_h,@function
object_2_asm_h:                         // @object_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB520_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB520_2:                              // %B2
	str	x22, [x20]
	mov	x0, x24
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x29, #64]
	bl	PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	.LBB520_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB520_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.Lfunc_end520:
	.size	object_2_asm_h, .Lfunc_end520-object_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	special_object_2_asm_h          // -- Begin function special_object_2_asm_h
	.p2align	2
	.type	special_object_2_asm_h,@function
special_object_2_asm_h:                 // @special_object_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B24
	ldr	w8, [x24, #336]
	cbz	w8, .LBB521_2
// %bb.1:                               // %B25
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB521_2:                              // %B16
	str	x22, [x20], #8
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	.LBB521_6
// %bb.3:                               // %B16
	cbz	w8, .LBB521_10
// %bb.4:                               // %B16
	cmp	w8, #1
	b.ne	.LBB521_15
// %bb.5:                               // %B7
	ldr	x8, [x29, #8]
	ldr	w1, [x29, #152]
	mov	x10, x20
	mov	x0, x24
	mov	x2, x28
	mov	x3, x29
	ldr	x8, [x8, #48]
	ldrh	w8, [x8, #40]
	str	x21, [x10], #8
	str	x10, [x29, #64]
	cmp	w8, w1
	csel	w4, w8, w1, lt
	bl	js_build_mapped_arguments_gc
	b	.LBB521_11
.LBB521_6:                              // %B16
	cmp	w8, #5
	b.eq	.LBB521_13
// %bb.7:                               // %B16
	cmp	w8, #4
	b.ne	.LBB521_16
// %bb.8:                               // %B10
	ldr	x8, [x29, #8]
	mov	w10, #18                        // =0x12
	ldr	x8, [x8, #64]
	cmp	x8, #0
	csel	x0, x10, x8, eq
.LBB521_9:                              // %B6
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB521_10:                             // %B2
	ldr	w1, [x29, #152]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x28
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	js_build_arguments_gc
.LBB521_11:                             // %B7
	cmp	x0, #130
	b.ne	.LBB521_9
// %bb.12:                              // %B8
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.LBB521_13:                             // %B13
	mov	x8, x20
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.ne	.LBB521_9
// %bb.14:                              // %B14
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.LBB521_15:                             // %B19
	ldr	x0, [x29, #8]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB521_16:                             // %B20
	ldr	x0, [x29, #128]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end521:
	.size	special_object_2_asm_h, .Lfunc_end521-special_object_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	rest_2_asm_h                    // -- Begin function rest_2_asm_h
	.p2align	2
	.type	rest_2_asm_h,@function
rest_2_asm_h:                           // @rest_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB522_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB522_2:                              // %B2
	str	x22, [x20]
	mov	x0, x24
	mov	x3, x28
	ldrh	w1, [x19]
	ldr	w2, [x29, #152]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x29, #64]
	bl	js_build_rest_gc
	cmp	x0, #130
	b.eq	.LBB522_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB522_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.Lfunc_end522:
	.size	rest_2_asm_h, .Lfunc_end522-rest_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	drop_2_asm_h                    // -- Begin function drop_2_asm_h
	.p2align	2
	.type	drop_2_asm_h,@function
drop_2_asm_h:                           // @drop_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB523_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB523_2:                              // %B1
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end523:
	.size	drop_2_asm_h, .Lfunc_end523-drop_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	nip_2_asm_h                     // -- Begin function nip_2_asm_h
	.p2align	2
	.type	nip_2_asm_h,@function
nip_2_asm_h:                            // @nip_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB524_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB524_2:                              // %B1
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x21
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end524:
	.size	nip_2_asm_h, .Lfunc_end524-nip_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	nip1_2_asm_h                    // -- Begin function nip1_2_asm_h
	.p2align	2
	.type	nip1_2_asm_h,@function
nip1_2_asm_h:                           // @nip1_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB525_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB525_2:                              // %B1
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end525:
	.size	nip1_2_asm_h, .Lfunc_end525-nip1_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dup_2_asm_h                     // -- Begin function dup_2_asm_h
	.p2align	2
	.type	dup_2_asm_h,@function
dup_2_asm_h:                            // @dup_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB526_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB526_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end526:
	.size	dup_2_asm_h, .Lfunc_end526-dup_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dup1_2_asm_h                    // -- Begin function dup1_2_asm_h
	.p2align	2
	.type	dup1_2_asm_h,@function
dup1_2_asm_h:                           // @dup1_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB527_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB527_2:                              // %B1
	str	x22, [x20], #8
	mov	x0, x22
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end527:
	.size	dup1_2_asm_h, .Lfunc_end527-dup1_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dup2_2_asm_h                    // -- Begin function dup2_2_asm_h
	.p2align	2
	.type	dup2_2_asm_h,@function
dup2_2_asm_h:                           // @dup2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB528_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB528_2:                              // %B1
	stp	x22, x21, [x20], #16
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end528:
	.size	dup2_2_asm_h, .Lfunc_end528-dup2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dup3_2_asm_h                    // -- Begin function dup3_2_asm_h
	.p2align	2
	.type	dup3_2_asm_h,@function
dup3_2_asm_h:                           // @dup3_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB529_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB529_2:                              // %B1
	ldur	x8, [x20, #-8]
	stp	x22, x21, [x20]
	str	x8, [x20, #16]
	add	x20, x20, #24
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end529:
	.size	dup3_2_asm_h, .Lfunc_end529-dup3_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	insert2_2_asm_h                 // -- Begin function insert2_2_asm_h
	.p2align	2
	.type	insert2_2_asm_h,@function
insert2_2_asm_h:                        // @insert2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB530_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB530_2:                              // %B1
	str	x22, [x20]
	mov	x0, x22
	mov	x22, x21
	str	x21, [x20], #8
	mov	x22, x0
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end530:
	.size	insert2_2_asm_h, .Lfunc_end530-insert2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	insert3_2_asm_h                 // -- Begin function insert3_2_asm_h
	.p2align	2
	.type	insert3_2_asm_h,@function
insert3_2_asm_h:                        // @insert3_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB531_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB531_2:                              // %B1
	ldur	x8, [x20, #-8]
	stp	x21, x22, [x20, #-8]
	mov	x0, x22
	mov	x22, x21
	str	x8, [x20], #8
	mov	x22, x0
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end531:
	.size	insert3_2_asm_h, .Lfunc_end531-insert3_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	insert4_2_asm_h                 // -- Begin function insert4_2_asm_h
	.p2align	2
	.type	insert4_2_asm_h,@function
insert4_2_asm_h:                        // @insert4_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB532_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB532_2:                              // %B1
	ldp	x10, x8, [x20, #-16]
	mov	x0, x22
	stur	x21, [x20, #-16]
	stp	x10, x22, [x20, #-8]
	mov	x22, x21
	str	x8, [x20], #8
	mov	x22, x0
	ldrb	w8, [x19], #1
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end532:
	.size	insert4_2_asm_h, .Lfunc_end532-insert4_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	perm3_2_asm_h                   // -- Begin function perm3_2_asm_h
	.p2align	2
	.type	perm3_2_asm_h,@function
perm3_2_asm_h:                          // @perm3_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB533_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB533_2:                              // %B1
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end533:
	.size	perm3_2_asm_h, .Lfunc_end533-perm3_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	perm4_2_asm_h                   // -- Begin function perm4_2_asm_h
	.p2align	2
	.type	perm4_2_asm_h,@function
perm4_2_asm_h:                          // @perm4_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB534_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB534_2:                              // %B1
	mov	x8, x22
	ldp	x10, x22, [x20, #-16]
	stp	x8, x10, [x20, #-16]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end534:
	.size	perm4_2_asm_h, .Lfunc_end534-perm4_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	perm5_2_asm_h                   // -- Begin function perm5_2_asm_h
	.p2align	2
	.type	perm5_2_asm_h,@function
perm5_2_asm_h:                          // @perm5_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB535_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB535_2:                              // %B1
	ldp	x11, x10, [x20, #-24]
	mov	x8, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-24]
	stp	x11, x10, [x20, #-16]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end535:
	.size	perm5_2_asm_h, .Lfunc_end535-perm5_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	swap_2_asm_h                    // -- Begin function swap_2_asm_h
	.p2align	2
	.type	swap_2_asm_h,@function
swap_2_asm_h:                           // @swap_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB536_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB536_2:                              // %B1
	ldrb	w8, [x19], #1
	mov	x1, x22
	mov	x22, x21
	mov	x21, x1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end536:
	.size	swap_2_asm_h, .Lfunc_end536-swap_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	swap2_2_asm_h                   // -- Begin function swap2_2_asm_h
	.p2align	2
	.type	swap2_2_asm_h,@function
swap2_2_asm_h:                          // @swap2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB537_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB537_2:                              // %B1
	ldp	x8, x10, [x20, #-16]
	stp	x22, x21, [x20, #-16]
	ldrb	w11, [x19], #1
	ldr	x0, [x25, x11, lsl #3]
	mov	x22, x8
	mov	x21, x10
	br	x0
.Lfunc_end537:
	.size	swap2_2_asm_h, .Lfunc_end537-swap2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	rot3l_2_asm_h                   // -- Begin function rot3l_2_asm_h
	.p2align	2
	.type	rot3l_2_asm_h,@function
rot3l_2_asm_h:                          // @rot3l_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB538_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB538_2:                              // %B1
	ldur	x8, [x20, #-8]
	stur	x22, [x20, #-8]
	mov	x22, x21
	ldrb	w10, [x19], #1
	mov	x21, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.Lfunc_end538:
	.size	rot3l_2_asm_h, .Lfunc_end538-rot3l_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	rot3r_2_asm_h                   // -- Begin function rot3r_2_asm_h
	.p2align	2
	.type	rot3r_2_asm_h,@function
rot3r_2_asm_h:                          // @rot3r_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB539_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB539_2:                              // %B1
	mov	x8, x21
	mov	x21, x22
	ldur	x22, [x20, #-8]
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end539:
	.size	rot3r_2_asm_h, .Lfunc_end539-rot3r_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	rot4l_2_asm_h                   // -- Begin function rot4l_2_asm_h
	.p2align	2
	.type	rot4l_2_asm_h,@function
rot4l_2_asm_h:                          // @rot4l_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB540_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB540_2:                              // %B1
	ldp	x10, x8, [x20, #-16]
	stp	x8, x22, [x20, #-16]
	mov	x22, x21
	mov	x21, x10
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end540:
	.size	rot4l_2_asm_h, .Lfunc_end540-rot4l_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	rot5l_2_asm_h                   // -- Begin function rot5l_2_asm_h
	.p2align	2
	.type	rot5l_2_asm_h,@function
rot5l_2_asm_h:                          // @rot5l_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB541_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB541_2:                              // %B1
	ldp	x8, x10, [x20, #-16]
	ldur	x11, [x20, #-24]
	stur	x22, [x20, #-8]
	mov	x22, x21
	mov	x21, x11
	stp	x8, x10, [x20, #-24]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end541:
	.size	rot5l_2_asm_h, .Lfunc_end541-rot5l_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call_constructor_2_asm_h        // -- Begin function call_constructor_2_asm_h
	.p2align	2
	.type	call_constructor_2_asm_h,@function
call_constructor_2_asm_h:               // @call_constructor_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB542_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB542_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	call_constructor_0_asm_h
.Lfunc_end542:
	.size	call_constructor_2_asm_h, .Lfunc_end542-call_constructor_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call_2_asm_h                    // -- Begin function call_2_asm_h
	.p2align	2
	.type	call_2_asm_h,@function
call_2_asm_h:                           // @call_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB543_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB543_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	call_0_asm_h
.Lfunc_end543:
	.size	call_2_asm_h, .Lfunc_end543-call_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	tail_call_2_asm_h               // -- Begin function tail_call_2_asm_h
	.p2align	2
	.type	tail_call_2_asm_h,@function
tail_call_2_asm_h:                      // @tail_call_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB544_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB544_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	tail_call_0_asm_h
.Lfunc_end544:
	.size	tail_call_2_asm_h, .Lfunc_end544-tail_call_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call_method_2_asm_h             // -- Begin function call_method_2_asm_h
	.p2align	2
	.type	call_method_2_asm_h,@function
call_method_2_asm_h:                    // @call_method_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB545_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB545_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	call_method_0_asm_h
.Lfunc_end545:
	.size	call_method_2_asm_h, .Lfunc_end545-call_method_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	tail_call_method_2_asm_h        // -- Begin function tail_call_method_2_asm_h
	.p2align	2
	.type	tail_call_method_2_asm_h,@function
tail_call_method_2_asm_h:               // @tail_call_method_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB546_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB546_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	tail_call_method_0_asm_h
.Lfunc_end546:
	.size	tail_call_method_2_asm_h, .Lfunc_end546-tail_call_method_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	array_from_2_asm_h              // -- Begin function array_from_2_asm_h
	.p2align	2
	.type	array_from_2_asm_h,@function
array_from_2_asm_h:                     // @array_from_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB547_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB547_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	array_from_0_asm_h
.Lfunc_end547:
	.size	array_from_2_asm_h, .Lfunc_end547-array_from_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	apply_2_asm_h                   // -- Begin function apply_2_asm_h
	.p2align	2
	.type	apply_2_asm_h,@function
apply_2_asm_h:                          // @apply_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB548_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB548_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	apply_0_asm_h
.Lfunc_end548:
	.size	apply_2_asm_h, .Lfunc_end548-apply_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	return_2_asm_h                  // -- Begin function return_2_asm_h
	.p2align	2
	.type	return_2_asm_h,@function
return_2_asm_h:                         // @return_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB549_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB549_2:                              // %B1
	sub	x25, x25, #3872
	mov	x27, x21
	b	common_return_asm_h
.Lfunc_end549:
	.size	return_2_asm_h, .Lfunc_end549-return_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	return_undef_2_asm_h            // -- Begin function return_undef_2_asm_h
	.p2align	2
	.type	return_undef_2_asm_h,@function
return_undef_2_asm_h:                   // @return_undef_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB550_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB550_2:                              // %B1
	sub	x25, x25, #3872
	mov	w27, #18                        // =0x12
	b	common_return_asm_h
.Lfunc_end550:
	.size	return_undef_2_asm_h, .Lfunc_end550-return_undef_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	check_ctor_return_2_asm_h       // -- Begin function check_ctor_return_2_asm_h
	.p2align	2
	.type	check_ctor_return_2_asm_h,@function
check_ctor_return_2_asm_h:              // @check_ctor_return_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB551_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB551_2:                              // %B6
	mov	x8, #2                          // =0x2
	str	x22, [x20], #8
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB551_5
// %bb.3:                               // %B3
	cmp	x21, #18
	b.eq	.LBB551_6
// %bb.4:                               // %B4
	mov	x8, x20
	adrp	x1, .L__unnamed_17
	add	x1, x1, :lo12:.L__unnamed_17
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_ThrowTypeError
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.LBB551_5:                              // %B7
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	w21, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB551_6:                              // %B5
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	w21, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end551:
	.size	check_ctor_return_2_asm_h, .Lfunc_end551-check_ctor_return_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	check_ctor_2_asm_h              // -- Begin function check_ctor_2_asm_h
	.p2align	2
	.type	check_ctor_2_asm_h,@function
check_ctor_2_asm_h:                     // @check_ctor_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB552_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB552_2:                              // %B3
	ldr	x8, [x29, #128]
	cmp	x8, #18
	b.ne	.LBB552_4
// %bb.3:                               // %B4
	add	x8, x20, #16
	adrp	x1, .L__unnamed_18
	add	x1, x1, :lo12:.L__unnamed_18
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_ThrowTypeError
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.LBB552_4:                              // %B5
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end552:
	.size	check_ctor_2_asm_h, .Lfunc_end552-check_ctor_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	check_brand_2_asm_h             // -- Begin function check_brand_2_asm_h
	.p2align	2
	.type	check_brand_2_asm_h,@function
check_brand_2_asm_h:                    // @check_brand_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB553_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB553_2:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_CheckBrand_GC
	tbnz	w0, #31, .LBB553_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB553_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end553:
	.size	check_brand_2_asm_h, .Lfunc_end553-check_brand_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	add_brand_2_asm_h               // -- Begin function add_brand_2_asm_h
	.p2align	2
	.type	add_brand_2_asm_h,@function
add_brand_2_asm_h:                      // @add_brand_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB554_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB554_2:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_AddBrand_GC
	tbnz	w0, #31, .LBB554_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x25, x25, #3872
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB554_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end554:
	.size	add_brand_2_asm_h, .Lfunc_end554-add_brand_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	return_async_2_asm_h            // -- Begin function return_async_2_asm_h
	.p2align	2
	.type	return_async_2_asm_h,@function
return_async_2_asm_h:                   // @return_async_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB555_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB555_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	return_async_0_asm_h
.Lfunc_end555:
	.size	return_async_2_asm_h, .Lfunc_end555-return_async_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	throw_2_asm_h                   // -- Begin function throw_2_asm_h
	.p2align	2
	.type	throw_2_asm_h,@function
throw_2_asm_h:                          // @throw_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB556_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB556_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	throw_0_asm_h
.Lfunc_end556:
	.size	throw_2_asm_h, .Lfunc_end556-throw_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	throw_var_2_asm_h               // -- Begin function throw_var_2_asm_h
	.p2align	2
	.type	throw_var_2_asm_h,@function
throw_var_2_asm_h:                      // @throw_var_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB557_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB557_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	throw_var_0_asm_h
.Lfunc_end557:
	.size	throw_var_2_asm_h, .Lfunc_end557-throw_var_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	eval_2_asm_h                    // -- Begin function eval_2_asm_h
	.p2align	2
	.type	eval_2_asm_h,@function
eval_2_asm_h:                           // @eval_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB558_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB558_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	eval_0_asm_h
.Lfunc_end558:
	.size	eval_2_asm_h, .Lfunc_end558-eval_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	regexp_2_asm_h                  // -- Begin function regexp_2_asm_h
	.p2align	2
	.type	regexp_2_asm_h,@function
regexp_2_asm_h:                         // @regexp_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB559_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB559_2:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	w1, #18                         // =0x12
	mov	x2, x22
	mov	x3, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	.LBB559_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB559_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end559:
	.size	regexp_2_asm_h, .Lfunc_end559-regexp_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_super_ctor_2_asm_h          // -- Begin function get_super_ctor_2_asm_h
	.p2align	2
	.type	get_super_ctor_2_asm_h,@function
get_super_ctor_2_asm_h:                 // @get_super_ctor_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB560_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB560_2:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	.LBB560_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB560_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end560:
	.size	get_super_ctor_2_asm_h, .Lfunc_end560-get_super_ctor_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_super_2_asm_h               // -- Begin function get_super_2_asm_h
	.p2align	2
	.type	get_super_2_asm_h,@function
get_super_2_asm_h:                      // @get_super_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB561_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB561_2:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_GetPrototype
	cmp	x0, #130
	b.eq	.LBB561_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB561_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end561:
	.size	get_super_2_asm_h, .Lfunc_end561-get_super_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	import_2_asm_h                  // -- Begin function import_2_asm_h
	.p2align	2
	.type	import_2_asm_h,@function
import_2_asm_h:                         // @import_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB562_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB562_2:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	js_dynamic_import
	cmp	x0, #130
	b.eq	.LBB562_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB562_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end562:
	.size	import_2_asm_h, .Lfunc_end562-import_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	check_var_2_asm_h               // -- Begin function check_var_2_asm_h
	.p2align	2
	.type	check_var_2_asm_h,@function
check_var_2_asm_h:                      // @check_var_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB563_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB563_2:                              // %B2
	str	x22, [x20]
	mov	x0, x24
	ldr	w1, [x19]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x29, #64]
	bl	JS_CheckGlobalVar_GC
	tbnz	w0, #31, .LBB563_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	mov	x22, x21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x21, x8, ne
	br	x0
.LBB563_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.Lfunc_end563:
	.size	check_var_2_asm_h, .Lfunc_end563-check_var_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_undef_2_asm_h           // -- Begin function get_var_undef_2_asm_h
	.p2align	2
	.type	get_var_undef_2_asm_h,@function
get_var_undef_2_asm_h:                  // @get_var_undef_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B12
	ldr	w8, [x24, #336]
	cbz	w8, .LBB564_2
// %bb.1:                               // %B13
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB564_2:                              // %B2
	str	x22, [x20], #8
	ldr	w9, [x19]
	bl	common_get_var_undef_asm_h
	cmp	x0, #130
	b.eq	.LBB564_5
// %bb.3:                               // %B2
	cmp	x0, #34
	b.eq	.LBB564_7
.LBB564_4:                              // %B11
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB564_5:                              // %B4
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.ne	.LBB564_4
// %bb.6:                               // %B5
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.LBB564_7:                              // %B10
	str	x21, [x20], #8
	sub	x25, x25, #3872
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end564:
	.size	get_var_undef_2_asm_h, .Lfunc_end564-get_var_undef_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_2_asm_h                 // -- Begin function get_var_2_asm_h
	.p2align	2
	.type	get_var_2_asm_h,@function
get_var_2_asm_h:                        // @get_var_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B12
	ldr	w8, [x24, #336]
	cbz	w8, .LBB565_2
// %bb.1:                               // %B13
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB565_2:                              // %B2
	str	x22, [x20], #8
	ldr	w9, [x19]
	bl	common_get_var_asm_h
	cmp	x0, #130
	b.eq	.LBB565_5
// %bb.3:                               // %B2
	cmp	x0, #34
	b.eq	.LBB565_7
.LBB565_4:                              // %B11
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB565_5:                              // %B4
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.ne	.LBB565_4
// %bb.6:                               // %B5
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.LBB565_7:                              // %B10
	str	x21, [x20], #8
	sub	x25, x25, #3872
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end565:
	.size	get_var_2_asm_h, .Lfunc_end565-get_var_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_2_asm_h                 // -- Begin function put_var_2_asm_h
	.p2align	2
	.type	put_var_2_asm_h,@function
put_var_2_asm_h:                        // @put_var_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB566_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB566_2:                              // %B2
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB566_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB566_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end566:
	.size	put_var_2_asm_h, .Lfunc_end566-put_var_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_init_2_asm_h            // -- Begin function put_var_init_2_asm_h
	.p2align	2
	.type	put_var_init_2_asm_h,@function
put_var_init_2_asm_h:                   // @put_var_init_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB567_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB567_2:                              // %B2
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB567_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB567_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end567:
	.size	put_var_init_2_asm_h, .Lfunc_end567-put_var_init_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_strict_2_asm_h          // -- Begin function put_var_strict_2_asm_h
	.p2align	2
	.type	put_var_strict_2_asm_h,@function
put_var_strict_2_asm_h:                 // @put_var_strict_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB568_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB568_2:                              // %B6
	cmp	x22, #7
	b.ne	.LBB568_5
// %bb.3:                               // %B2
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          // =0x2
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB568_6
// %bb.4:                               // %B5
	ldrb	w8, [x19, #4]
	sub	x25, x25, #3872
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB568_5:                              // %B7
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB568_6:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end568:
	.size	put_var_strict_2_asm_h, .Lfunc_end568-put_var_strict_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_ref_value_2_asm_h           // -- Begin function get_ref_value_2_asm_h
	.p2align	2
	.type	get_ref_value_2_asm_h,@function
get_ref_value_2_asm_h:                  // @get_ref_value_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B12
	ldr	w8, [x24, #336]
	cbz	w8, .LBB569_2
// %bb.1:                               // %B13
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB569_2:                              // %B9
	str	x22, [x20]
	cmp	x22, #18
	mov	x0, x24
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x29, #64]
	b.eq	.LBB569_5
// %bb.3:                               // %B2
	mov	x1, x22
	mov	x2, x21
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB569_7
// %bb.4:                               // %B5
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB569_5:                              // %B6
	mov	x1, x21
	bl	js_value_to_atom_gc
	cbz	w0, .LBB569_7
// %bb.6:                               // %B8
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB569_7:                              // %B7
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.Lfunc_end569:
	.size	get_ref_value_2_asm_h, .Lfunc_end569-get_ref_value_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_ref_value_2_asm_h           // -- Begin function put_ref_value_2_asm_h
	.p2align	2
	.type	put_ref_value_2_asm_h,@function
put_ref_value_2_asm_h:                  // @put_ref_value_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B16
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB570_2
// %bb.1:                               // %B17
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB570_2:                              // %B13
	ldur	x1, [x20, #-8]
	cmp	x1, #18
	b.eq	.LBB570_5
.LBB570_3:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_SetPropertyValue_GC
	tbnz	w0, #31, .LBB570_9
// %bb.4:                               // %B5
	ldrb	w8, [x19], #1
	sub	x25, x25, #3872
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.LBB570_5:                              // %B9
	ldr	w8, [x29, #60]
	tbnz	w8, #0, .LBB570_7
// %bb.6:                               // %B10
	ldr	x1, [x24, #224]
	b	.LBB570_3
.LBB570_7:                              // %B6
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	stp	x22, x21, [x20]
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	str	x8, [x29, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB570_9
// %bb.8:                               // %B8
	ldr	x8, [sp, #8]                    // 8-byte Folded Reload
	mov	w1, w0
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB570_9:                              // %B7
	sub	x25, x25, #3872
	add	sp, sp, #16
	b	exception_spill_top0_top1_asm_h
.Lfunc_end570:
	.size	put_ref_value_2_asm_h, .Lfunc_end570-put_ref_value_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_var_2_asm_h              // -- Begin function define_var_2_asm_h
	.p2align	2
	.type	define_var_2_asm_h,@function
define_var_2_asm_h:                     // @define_var_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB571_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB571_2:                              // %B2
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_DefineGlobalVar_GC
	tbnz	w0, #31, .LBB571_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB571_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end571:
	.size	define_var_2_asm_h, .Lfunc_end571-define_var_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	check_define_var_2_asm_h        // -- Begin function check_define_var_2_asm_h
	.p2align	2
	.type	check_define_var_2_asm_h,@function
check_define_var_2_asm_h:               // @check_define_var_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB572_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB572_2:                              // %B2
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, .LBB572_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB572_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end572:
	.size	check_define_var_2_asm_h, .Lfunc_end572-check_define_var_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_func_2_asm_h             // -- Begin function define_func_2_asm_h
	.p2align	2
	.type	define_func_2_asm_h,@function
define_func_2_asm_h:                    // @define_func_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB573_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB573_2:                              // %B2
	ldr	w1, [x19]
	ldrb	w3, [x19, #4]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_DefineGlobalFunction_GC
	tbnz	w0, #31, .LBB573_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #5]
	sub	x25, x25, #1936
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB573_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end573:
	.size	define_func_2_asm_h, .Lfunc_end573-define_func_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_field_2_asm_h               // -- Begin function get_field_2_asm_h
	.p2align	2
	.type	get_field_2_asm_h,@function
get_field_2_asm_h:                      // @get_field_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB574_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB574_2:                              // %B2
	ldr	w9, [x19]
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB574_4
.LBB574_3:                              // %B8
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB574_4:                              // %B4
	ldr	w2, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x3, x21
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.ne	.LBB574_3
// %bb.5:                               // %B5
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end574:
	.size	get_field_2_asm_h, .Lfunc_end574-get_field_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_field2_2_asm_h              // -- Begin function get_field2_2_asm_h
	.p2align	2
	.type	get_field2_2_asm_h,@function
get_field2_2_asm_h:                     // @get_field2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB575_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB575_2:                              // %B2
	str	x22, [x20], #8
	ldr	w9, [x19]
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB575_4
.LBB575_3:                              // %B8
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB575_4:                              // %B4
	ldr	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	mov	x3, x21
	mov	w4, wzr
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.ne	.LBB575_3
// %bb.5:                               // %B5
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.Lfunc_end575:
	.size	get_field2_2_asm_h, .Lfunc_end575-get_field2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_field_2_asm_h               // -- Begin function put_field_2_asm_h
	.p2align	2
	.type	put_field_2_asm_h,@function
put_field_2_asm_h:                      // @put_field_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB576_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB576_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	common_set_property_asm_h
.Lfunc_end576:
	.size	put_field_2_asm_h, .Lfunc_end576-put_field_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_private_field_2_asm_h       // -- Begin function get_private_field_2_asm_h
	.p2align	2
	.type	get_private_field_2_asm_h,@function
get_private_field_2_asm_h:              // @get_private_field_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB577_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB577_2:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	.LBB577_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB577_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end577:
	.size	get_private_field_2_asm_h, .Lfunc_end577-get_private_field_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_private_field_2_asm_h       // -- Begin function put_private_field_2_asm_h
	.p2align	2
	.type	put_private_field_2_asm_h,@function
put_private_field_2_asm_h:              // @put_private_field_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB578_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB578_2:                              // %B2
	ldur	x1, [x20, #-8]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	x3, x22
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_SetPrivateField_GC
	tbnz	w0, #31, .LBB578_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x25, x25, #3872
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB578_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end578:
	.size	put_private_field_2_asm_h, .Lfunc_end578-put_private_field_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_private_field_2_asm_h    // -- Begin function define_private_field_2_asm_h
	.p2align	2
	.type	define_private_field_2_asm_h,@function
define_private_field_2_asm_h:           // @define_private_field_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB579_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB579_2:                              // %B2
	ldur	x1, [x20, #-8]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_DefinePrivateField_GC
	tbnz	w0, #31, .LBB579_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x25, x25, #3872
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB579_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end579:
	.size	define_private_field_2_asm_h, .Lfunc_end579-define_private_field_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_array_el_2_asm_h            // -- Begin function get_array_el_2_asm_h
	.p2align	2
	.type	get_array_el_2_asm_h,@function
get_array_el_2_asm_h:                   // @get_array_el_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB580_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB580_2:                              // %B6
	bl	common_get_property_value_asm_h
	cmp	x0, #130
	b.eq	.LBB580_4
.LBB580_3:                              // %B8
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB580_4:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.ne	.LBB580_3
// %bb.5:                               // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end580:
	.size	get_array_el_2_asm_h, .Lfunc_end580-get_array_el_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_array_el2_2_asm_h           // -- Begin function get_array_el2_2_asm_h
	.p2align	2
	.type	get_array_el2_2_asm_h,@function
get_array_el2_2_asm_h:                  // @get_array_el2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB581_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB581_2:                              // %B6
	bl	common_get_property_value_asm_h
	cmp	x0, #130
	b.eq	.LBB581_4
.LBB581_3:                              // %B8
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB581_4:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.ne	.LBB581_3
// %bb.5:                               // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end581:
	.size	get_array_el2_2_asm_h, .Lfunc_end581-get_array_el2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_array_el_2_asm_h            // -- Begin function put_array_el_2_asm_h
	.p2align	2
	.type	put_array_el_2_asm_h,@function
put_array_el_2_asm_h:                   // @put_array_el_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB582_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB582_2:                              // %B1
	ldur	x9, [x20, #-8]
	mov	x8, x20
	add	x20, x20, #16
	stp	x22, x21, [x8]
	sub	x25, x25, #3872
	b	common_set_property_value_asm_h
.Lfunc_end582:
	.size	put_array_el_2_asm_h, .Lfunc_end582-put_array_el_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_super_value_2_asm_h         // -- Begin function get_super_value_2_asm_h
	.p2align	2
	.type	get_super_value_2_asm_h,@function
get_super_value_2_asm_h:                // @get_super_value_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB583_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB583_2:                              // %B2
	str	x19, [sp, #8]                   // 8-byte Folded Spill
	add	x19, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x19, [x29, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB583_5
// %bb.3:                               // %B6
	ldur	x3, [x20, #-8]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x19, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB583_5
// %bb.4:                               // %B8
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	stur	x0, [x20, #-8]
	sub	x25, x25, #3872
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.LBB583_5:                              // %B3
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	sub	x25, x25, #3872
	add	sp, sp, #16
	b	exception_spill_top0_top1_asm_h
.Lfunc_end583:
	.size	get_super_value_2_asm_h, .Lfunc_end583-get_super_value_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_super_value_2_asm_h         // -- Begin function put_super_value_2_asm_h
	.p2align	2
	.type	put_super_value_2_asm_h,@function
put_super_value_2_asm_h:                // @put_super_value_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB584_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB584_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	put_super_value_0_asm_h
.Lfunc_end584:
	.size	put_super_value_2_asm_h, .Lfunc_end584-put_super_value_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_field_2_asm_h            // -- Begin function define_field_2_asm_h
	.p2align	2
	.type	define_field_2_asm_h,@function
define_field_2_asm_h:                   // @define_field_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB585_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB585_2:                              // %B2
	ldr	w2, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #16391                      // =0x4007
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_DefinePropertyValue
	tbnz	w0, #31, .LBB585_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB585_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end585:
	.size	define_field_2_asm_h, .Lfunc_end585-define_field_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_name_2_asm_h                // -- Begin function set_name_2_asm_h
	.p2align	2
	.type	set_name_2_asm_h,@function
set_name_2_asm_h:                       // @set_name_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB586_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB586_2:                              // %B2
	ldr	w2, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_DefineObjectName
	tbnz	w0, #31, .LBB586_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB586_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end586:
	.size	set_name_2_asm_h, .Lfunc_end586-set_name_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_name_computed_2_asm_h       // -- Begin function set_name_computed_2_asm_h
	.p2align	2
	.type	set_name_computed_2_asm_h,@function
set_name_computed_2_asm_h:              // @set_name_computed_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB587_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB587_2:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x2, x22
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, .LBB587_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB587_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end587:
	.size	set_name_computed_2_asm_h, .Lfunc_end587-set_name_computed_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_proto_2_asm_h               // -- Begin function set_proto_2_asm_h
	.p2align	2
	.type	set_proto_2_asm_h,@function
set_proto_2_asm_h:                      // @set_proto_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B10
	ldr	w8, [x24, #336]
	cbz	w8, .LBB588_2
// %bb.1:                               // %B11
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB588_2:                              // %B7
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB588_5
// %bb.3:                               // %B7
	cmp	x21, #2
	b.eq	.LBB588_5
.LBB588_4:                              // %B6
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB588_5:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_SetPrototypeInternal_GC
	tbz	w0, #31, .LBB588_4
// %bb.6:                               // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end588:
	.size	set_proto_2_asm_h, .Lfunc_end588-set_proto_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_home_object_2_asm_h         // -- Begin function set_home_object_2_asm_h
	.p2align	2
	.type	set_home_object_2_asm_h,@function
set_home_object_2_asm_h:                // @set_home_object_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB589_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB589_2:                              // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x2, x22
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	js_method_set_home_object_gc
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end589:
	.size	set_home_object_2_asm_h, .Lfunc_end589-set_home_object_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_array_el_2_asm_h         // -- Begin function define_array_el_2_asm_h
	.p2align	2
	.type	define_array_el_2_asm_h,@function
define_array_el_2_asm_h:                // @define_array_el_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB590_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB590_2:                              // %B2
	ldur	x1, [x20, #-8]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #16391                      // =0x4007
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, .LBB590_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB590_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end590:
	.size	define_array_el_2_asm_h, .Lfunc_end590-define_array_el_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	append_2_asm_h                  // -- Begin function append_2_asm_h
	.p2align	2
	.type	append_2_asm_h,@function
append_2_asm_h:                         // @append_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB591_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB591_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	append_0_asm_h
.Lfunc_end591:
	.size	append_2_asm_h, .Lfunc_end591-append_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	copy_data_properties_2_asm_h    // -- Begin function copy_data_properties_2_asm_h
	.p2align	2
	.type	copy_data_properties_2_asm_h,@function
copy_data_properties_2_asm_h:           // @copy_data_properties_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB592_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB592_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	copy_data_properties_0_asm_h
.Lfunc_end592:
	.size	copy_data_properties_2_asm_h, .Lfunc_end592-copy_data_properties_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_method_2_asm_h           // -- Begin function define_method_2_asm_h
	.p2align	2
	.type	define_method_2_asm_h,@function
define_method_2_asm_h:                  // @define_method_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB593_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB593_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	define_method_0_asm_h
.Lfunc_end593:
	.size	define_method_2_asm_h, .Lfunc_end593-define_method_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_method_computed_2_asm_h  // -- Begin function define_method_computed_2_asm_h
	.p2align	2
	.type	define_method_computed_2_asm_h,@function
define_method_computed_2_asm_h:         // @define_method_computed_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB594_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB594_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	define_method_computed_0_asm_h
.Lfunc_end594:
	.size	define_method_computed_2_asm_h, .Lfunc_end594-define_method_computed_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	define_class_2_asm_h            // -- Begin function define_class_2_asm_h
	.p2align	2
	.type	define_class_2_asm_h,@function
define_class_2_asm_h:                   // @define_class_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB595_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB595_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	define_class_0_asm_h
.Lfunc_end595:
	.size	define_class_2_asm_h, .Lfunc_end595-define_class_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc_2_asm_h                 // -- Begin function get_loc_2_asm_h
	.p2align	2
	.type	get_loc_2_asm_h,@function
get_loc_2_asm_h:                        // @get_loc_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB596_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB596_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrh	w8, [x19]
	ldrb	w10, [x19, #2]
	add	x19, x19, #3
	ldr	x8, [x27, x8, lsl #3]
	ldr	x0, [x25, x10, lsl #3]
	mov	x21, x8
	br	x0
.Lfunc_end596:
	.size	get_loc_2_asm_h, .Lfunc_end596-get_loc_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc_2_asm_h                 // -- Begin function put_loc_2_asm_h
	.p2align	2
	.type	put_loc_2_asm_h,@function
put_loc_2_asm_h:                        // @put_loc_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB597_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB597_2:                              // %B1
	ldrh	w8, [x19]
	sub	x25, x25, #1936
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end597:
	.size	put_loc_2_asm_h, .Lfunc_end597-put_loc_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc_2_asm_h                 // -- Begin function set_loc_2_asm_h
	.p2align	2
	.type	set_loc_2_asm_h,@function
set_loc_2_asm_h:                        // @set_loc_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB598_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB598_2:                              // %B1
	ldrh	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end598:
	.size	set_loc_2_asm_h, .Lfunc_end598-set_loc_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_arg_2_asm_h                 // -- Begin function get_arg_2_asm_h
	.p2align	2
	.type	get_arg_2_asm_h,@function
get_arg_2_asm_h:                        // @get_arg_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB599_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB599_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrh	w8, [x19]
	ldrb	w10, [x19, #2]
	add	x19, x19, #3
	ldr	x8, [x28, x8, lsl #3]
	ldr	x0, [x25, x10, lsl #3]
	mov	x21, x8
	br	x0
.Lfunc_end599:
	.size	get_arg_2_asm_h, .Lfunc_end599-get_arg_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_arg_2_asm_h                 // -- Begin function put_arg_2_asm_h
	.p2align	2
	.type	put_arg_2_asm_h,@function
put_arg_2_asm_h:                        // @put_arg_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB600_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB600_2:                              // %B1
	ldrh	w8, [x19]
	sub	x25, x25, #1936
	str	x21, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end600:
	.size	put_arg_2_asm_h, .Lfunc_end600-put_arg_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_arg_2_asm_h                 // -- Begin function set_arg_2_asm_h
	.p2align	2
	.type	set_arg_2_asm_h,@function
set_arg_2_asm_h:                        // @set_arg_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB601_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB601_2:                              // %B1
	ldrh	w8, [x19]
	str	x21, [x28, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end601:
	.size	set_arg_2_asm_h, .Lfunc_end601-set_arg_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref_2_asm_h             // -- Begin function get_var_ref_2_asm_h
	.p2align	2
	.type	get_var_ref_2_asm_h,@function
get_var_ref_2_asm_h:                    // @get_var_ref_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB602_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB602_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrh	w8, [x19]
	ldrb	w10, [x19, #2]
	add	x19, x19, #3
	ldr	x8, [x26, x8, lsl #3]
	ldr	x0, [x25, x10, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x8, [x8]
	mov	x21, x8
	br	x0
.Lfunc_end602:
	.size	get_var_ref_2_asm_h, .Lfunc_end602-get_var_ref_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref_2_asm_h             // -- Begin function put_var_ref_2_asm_h
	.p2align	2
	.type	put_var_ref_2_asm_h,@function
put_var_ref_2_asm_h:                    // @put_var_ref_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB603_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB603_2:                              // %B1
	ldrh	w8, [x19]
	sub	x25, x25, #1936
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end603:
	.size	put_var_ref_2_asm_h, .Lfunc_end603-put_var_ref_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_var_ref_2_asm_h             // -- Begin function set_var_ref_2_asm_h
	.p2align	2
	.type	set_var_ref_2_asm_h,@function
set_var_ref_2_asm_h:                    // @set_var_ref_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB604_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB604_2:                              // %B1
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end604:
	.size	set_var_ref_2_asm_h, .Lfunc_end604-set_var_ref_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc_uninitialized_2_asm_h   // -- Begin function set_loc_uninitialized_2_asm_h
	.p2align	2
	.type	set_loc_uninitialized_2_asm_h,@function
set_loc_uninitialized_2_asm_h:          // @set_loc_uninitialized_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB605_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB605_2:                              // %B1
	ldrh	w8, [x19]
	mov	w10, #34                        // =0x22
	str	x10, [x27, x8, lsl #3]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end605:
	.size	set_loc_uninitialized_2_asm_h, .Lfunc_end605-set_loc_uninitialized_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc_check_2_asm_h           // -- Begin function get_loc_check_2_asm_h
	.p2align	2
	.type	get_loc_check_2_asm_h,@function
get_loc_check_2_asm_h:                  // @get_loc_check_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB606_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB606_2:                              // %B3
	str	x22, [x20], #8
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	.LBB606_4
// %bb.3:                               // %B5
	ldrb	w10, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB606_4:                              // %B4
	str	x21, [x20], #8
	sub	x25, x25, #3872
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end606:
	.size	get_loc_check_2_asm_h, .Lfunc_end606-get_loc_check_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc_check_2_asm_h           // -- Begin function put_loc_check_2_asm_h
	.p2align	2
	.type	put_loc_check_2_asm_h,@function
put_loc_check_2_asm_h:                  // @put_loc_check_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB607_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB607_2:                              // %B3
	ldrh	w8, [x19]
	ldr	x10, [x27, x8, lsl #3]
	cmp	x10, #34
	b.eq	.LBB607_4
// %bb.3:                               // %B5
	str	x21, [x27, w8, uxtw #3]
	sub	x25, x25, #1936
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB607_4:                              // %B4
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end607:
	.size	put_loc_check_2_asm_h, .Lfunc_end607-put_loc_check_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc_check_init_2_asm_h      // -- Begin function put_loc_check_init_2_asm_h
	.p2align	2
	.type	put_loc_check_init_2_asm_h,@function
put_loc_check_init_2_asm_h:             // @put_loc_check_init_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB608_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB608_2:                              // %B3
	ldrh	w8, [x19]
	ldr	x10, [x27, x8, lsl #3]
	cmp	x10, #34
	b.ne	.LBB608_4
// %bb.3:                               // %B5
	str	x21, [x27, w8, uxtw #3]
	sub	x25, x25, #1936
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB608_4:                              // %B4
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	ThrowThisReferenceError_asm_h
.Lfunc_end608:
	.size	put_loc_check_init_2_asm_h, .Lfunc_end608-put_loc_check_init_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref_check_2_asm_h       // -- Begin function get_var_ref_check_2_asm_h
	.p2align	2
	.type	get_var_ref_check_2_asm_h,@function
get_var_ref_check_2_asm_h:              // @get_var_ref_check_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB609_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB609_2:                              // %B3
	str	x22, [x20], #8
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB609_4
// %bb.3:                               // %B5
	ldrb	w10, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB609_4:                              // %B4
	str	x21, [x20], #8
	sub	x25, x25, #3872
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end609:
	.size	get_var_ref_check_2_asm_h, .Lfunc_end609-get_var_ref_check_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref_check_2_asm_h       // -- Begin function put_var_ref_check_2_asm_h
	.p2align	2
	.type	put_var_ref_check_2_asm_h,@function
put_var_ref_check_2_asm_h:              // @put_var_ref_check_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB610_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB610_2:                              // %B3
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x10, [x8]
	cmp	x10, #34
	b.eq	.LBB610_4
// %bb.3:                               // %B5
	str	x21, [x8]
	sub	x25, x25, #1936
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB610_4:                              // %B4
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end610:
	.size	put_var_ref_check_2_asm_h, .Lfunc_end610-put_var_ref_check_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref_check_init_2_asm_h  // -- Begin function put_var_ref_check_init_2_asm_h
	.p2align	2
	.type	put_var_ref_check_init_2_asm_h,@function
put_var_ref_check_init_2_asm_h:         // @put_var_ref_check_init_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB611_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB611_2:                              // %B3
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x10, [x8]
	cmp	x10, #34
	b.ne	.LBB611_4
// %bb.3:                               // %B5
	str	x21, [x8]
	sub	x25, x25, #1936
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB611_4:                              // %B4
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	ThrowReferenceErrorUninitialized_asm_h
.Lfunc_end611:
	.size	put_var_ref_check_init_2_asm_h, .Lfunc_end611-put_var_ref_check_init_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	close_loc_2_asm_h               // -- Begin function close_loc_2_asm_h
	.p2align	2
	.type	close_loc_2_asm_h,@function
close_loc_2_asm_h:                      // @close_loc_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB612_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB612_2:                              // %B1
	ldrh	w2, [x19]
	mov	x0, x24
	mov	x1, x29
	bl	close_lexical_var
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end612:
	.size	close_loc_2_asm_h, .Lfunc_end612-close_loc_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	if_false_2_asm_h                // -- Begin function if_false_2_asm_h
	.p2align	2
	.type	if_false_2_asm_h,@function
if_false_2_asm_h:                       // @if_false_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B27
	ldr	w8, [x24, #336]
	cbz	w8, .LBB613_2
// %bb.1:                               // %B28
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB613_2:                              // %B24
	cmp	x21, #5
	b.le	.LBB613_6
// %bb.3:                               // %B24
	cmp	x21, #6
	b.eq	.LBB613_8
// %bb.4:                               // %B24
	cmp	x21, #7
	b.eq	.LBB613_11
// %bb.5:                               // %B24
	cmp	x21, #18
	b.eq	.LBB613_8
	b	.LBB613_9
.LBB613_6:                              // %B24
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB613_8
// %bb.7:                               // %B24
	cmp	x21, #2
	b.ne	.LBB613_9
.LBB613_8:                              // %B4
	ldrsw	x8, [x19]
	sub	x25, x25, #1936
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB613_9:                              // %B10
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x21, x8
	b.hs	.LBB613_15
// %bb.10:                              // %B12
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB613_12
.LBB613_11:                             // %B20
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB613_12:                             // %B14
	tst	x21, #0xfffe000000000000
	b.eq	.LBB613_15
// %bb.13:                              // %B18
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB613_8
	b.vs	.LBB613_8
// %bb.14:                              // %B18
	tbnz	w8, #0, .LBB613_11
	b	.LBB613_8
.LBB613_15:                             // %B16
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	mov	x9, x21
	b	SlowToBoolean_asm_h
.Lfunc_end613:
	.size	if_false_2_asm_h, .Lfunc_end613-if_false_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	if_true_2_asm_h                 // -- Begin function if_true_2_asm_h
	.p2align	2
	.type	if_true_2_asm_h,@function
if_true_2_asm_h:                        // @if_true_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B27
	ldr	w8, [x24, #336]
	cbz	w8, .LBB614_2
// %bb.1:                               // %B28
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB614_2:                              // %B24
	cmp	x21, #5
	b.le	.LBB614_6
// %bb.3:                               // %B24
	cmp	x21, #6
	b.eq	.LBB614_8
// %bb.4:                               // %B24
	cmp	x21, #7
	b.eq	.LBB614_11
// %bb.5:                               // %B24
	cmp	x21, #18
	b.eq	.LBB614_8
	b	.LBB614_9
.LBB614_6:                              // %B24
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB614_8
// %bb.7:                               // %B24
	cmp	x21, #2
	b.ne	.LBB614_9
.LBB614_8:                              // %B4
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB614_9:                              // %B10
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x21, x8
	b.hs	.LBB614_15
// %bb.10:                              // %B12
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB614_12
.LBB614_11:                             // %B20
	ldrsw	x8, [x19]
	sub	x25, x25, #1936
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB614_12:                             // %B14
	tst	x21, #0xfffe000000000000
	b.eq	.LBB614_15
// %bb.13:                              // %B18
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB614_8
	b.vs	.LBB614_8
// %bb.14:                              // %B18
	tbnz	w8, #0, .LBB614_11
	b	.LBB614_8
.LBB614_15:                             // %B16
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	mov	x9, x21
	b	SlowToBoolean_asm_h
.Lfunc_end614:
	.size	if_true_2_asm_h, .Lfunc_end614-if_true_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	goto_2_asm_h                    // -- Begin function goto_2_asm_h
	.p2align	2
	.type	goto_2_asm_h,@function
goto_2_asm_h:                           // @goto_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB615_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB615_2:                              // %B1
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end615:
	.size	goto_2_asm_h, .Lfunc_end615-goto_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	catch_2_asm_h                   // -- Begin function catch_2_asm_h
	.p2align	2
	.type	catch_2_asm_h,@function
catch_2_asm_h:                          // @catch_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB616_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB616_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x29, #8]
	ldrb	w11, [x19, #4]
	ldr	w10, [x19]
	ldr	x8, [x8, #48]
	ldr	x0, [x25, x11, lsl #3]
	ldr	x8, [x8, #8]
	sub	x8, x19, x8
	add	x19, x19, #5
	add	x8, x8, x10
	mov	w10, #66                        // =0x42
	orr	x21, x10, x8, lsl #16
	br	x0
.Lfunc_end616:
	.size	catch_2_asm_h, .Lfunc_end616-catch_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	gosub_2_asm_h                   // -- Begin function gosub_2_asm_h
	.p2align	2
	.type	gosub_2_asm_h,@function
gosub_2_asm_h:                          // @gosub_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB617_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB617_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x29, #8]
	ldrsw	x10, [x19]
	ldr	x11, [x8, #48]
	add	x8, x19, x10
	ldr	w10, [x11, #8]
	ldrb	w11, [x8], #1
	sub	w10, w19, w10
	ldr	x0, [x25, x11, lsl #3]
	mov	x19, x8
	add	w10, w10, #4
	orr	x21, x10, #0xfffe000000000000
	br	x0
.Lfunc_end617:
	.size	gosub_2_asm_h, .Lfunc_end617-gosub_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	ret_2_asm_h                     // -- Begin function ret_2_asm_h
	.p2align	2
	.type	ret_2_asm_h,@function
ret_2_asm_h:                            // @ret_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B10
	ldr	w8, [x24, #336]
	cbz	w8, .LBB618_2
// %bb.1:                               // %B11
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB618_2:                              // %B7
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB618_5
// %bb.3:                               // %B2
	ldr	x8, [x29, #8]
	ldr	x8, [x8, #48]
	ldr	w10, [x8, #16]
	cmp	w21, w10
	b.ge	.LBB618_5
// %bb.4:                               // %B6
	ldr	x8, [x8, #8]
	sub	x25, x25, #1936
	add	x19, x8, w21, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB618_5:                              // %B4
	add	x8, x20, #16
	adrp	x1, .L__unnamed_19
	add	x1, x1, :lo12:.L__unnamed_19
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_ThrowInternalError
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end618:
	.size	ret_2_asm_h, .Lfunc_end618-ret_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	to_object_2_asm_h               // -- Begin function to_object_2_asm_h
	.p2align	2
	.type	to_object_2_asm_h,@function
to_object_2_asm_h:                      // @to_object_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB619_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB619_2:                              // %B3
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	.LBB619_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB619_4:                              // %B5
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	mov	x9, x21
	b	SlowToObject_asm_h
.Lfunc_end619:
	.size	to_object_2_asm_h, .Lfunc_end619-to_object_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	to_propkey_2_asm_h              // -- Begin function to_propkey_2_asm_h
	.p2align	2
	.type	to_propkey_2_asm_h,@function
to_propkey_2_asm_h:                     // @to_propkey_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B19
	ldr	w8, [x24, #336]
	cbz	w8, .LBB620_2
// %bb.1:                               // %B20
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB620_2:                              // %B16
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB620_6
// %bb.3:                               // %B16
	mov	x10, #1                         // =0x1
	and	x8, x21, #0xffff000000000003
	movk	x10, #1, lsl #48
	add	x11, x10, #1
	cmp	x8, x11
	b.eq	.LBB620_6
// %bb.4:                               // %B16
	cmp	x8, x10
	b.eq	.LBB620_6
// %bb.5:                               // %B16
	mov	x10, #-281474976710653          // =0xffff000000000003
	cmp	x8, x10
	b.ne	.LBB620_7
.LBB620_6:                              // %B4
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB620_7:                              // %B13
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB620_9
// %bb.8:                               // %B15
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB620_9:                              // %B14
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end620:
	.size	to_propkey_2_asm_h, .Lfunc_end620-to_propkey_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	to_propkey2_2_asm_h             // -- Begin function to_propkey2_2_asm_h
	.p2align	2
	.type	to_propkey2_2_asm_h,@function
to_propkey2_2_asm_h:                    // @to_propkey2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B22
	ldr	w8, [x24, #336]
	cbz	w8, .LBB621_2
// %bb.1:                               // %B23
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB621_2:                              // %B19
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	.LBB621_5
// %bb.3:                               // %B20
	add	x8, x20, #16
	adrp	x1, .L__unnamed_20
	add	x1, x1, :lo12:.L__unnamed_20
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_ThrowTypeError
.LBB621_4:                              // %B17
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.LBB621_5:                              // %B3
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB621_9
// %bb.6:                               // %B3
	mov	x10, #1                         // =0x1
	and	x8, x21, #0xffff000000000003
	movk	x10, #1, lsl #48
	add	x11, x10, #1
	cmp	x8, x11
	b.eq	.LBB621_9
// %bb.7:                               // %B3
	cmp	x8, x10
	b.eq	.LBB621_9
// %bb.8:                               // %B3
	mov	x10, #-281474976710653          // =0xffff000000000003
	cmp	x8, x10
	b.ne	.LBB621_10
.LBB621_9:                              // %B5
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB621_10:                             // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB621_4
// %bb.11:                              // %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.Lfunc_end621:
	.size	to_propkey2_2_asm_h, .Lfunc_end621-to_propkey2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_get_var_2_asm_h            // -- Begin function with_get_var_2_asm_h
	.p2align	2
	.type	with_get_var_2_asm_h,@function
with_get_var_2_asm_h:                   // @with_get_var_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB622_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB622_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	with_get_var_0_asm_h
.Lfunc_end622:
	.size	with_get_var_2_asm_h, .Lfunc_end622-with_get_var_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_put_var_2_asm_h            // -- Begin function with_put_var_2_asm_h
	.p2align	2
	.type	with_put_var_2_asm_h,@function
with_put_var_2_asm_h:                   // @with_put_var_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB623_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB623_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	with_put_var_0_asm_h
.Lfunc_end623:
	.size	with_put_var_2_asm_h, .Lfunc_end623-with_put_var_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_delete_var_2_asm_h         // -- Begin function with_delete_var_2_asm_h
	.p2align	2
	.type	with_delete_var_2_asm_h,@function
with_delete_var_2_asm_h:                // @with_delete_var_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB624_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB624_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	with_delete_var_0_asm_h
.Lfunc_end624:
	.size	with_delete_var_2_asm_h, .Lfunc_end624-with_delete_var_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_make_ref_2_asm_h           // -- Begin function with_make_ref_2_asm_h
	.p2align	2
	.type	with_make_ref_2_asm_h,@function
with_make_ref_2_asm_h:                  // @with_make_ref_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB625_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB625_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	with_make_ref_0_asm_h
.Lfunc_end625:
	.size	with_make_ref_2_asm_h, .Lfunc_end625-with_make_ref_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_get_ref_2_asm_h            // -- Begin function with_get_ref_2_asm_h
	.p2align	2
	.type	with_get_ref_2_asm_h,@function
with_get_ref_2_asm_h:                   // @with_get_ref_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB626_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB626_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	with_get_ref_0_asm_h
.Lfunc_end626:
	.size	with_get_ref_2_asm_h, .Lfunc_end626-with_get_ref_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	with_get_ref_undef_2_asm_h      // -- Begin function with_get_ref_undef_2_asm_h
	.p2align	2
	.type	with_get_ref_undef_2_asm_h,@function
with_get_ref_undef_2_asm_h:             // @with_get_ref_undef_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB627_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB627_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	with_get_ref_undef_0_asm_h
.Lfunc_end627:
	.size	with_get_ref_undef_2_asm_h, .Lfunc_end627-with_get_ref_undef_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	make_loc_ref_2_asm_h            // -- Begin function make_loc_ref_2_asm_h
	.p2align	2
	.type	make_loc_ref_2_asm_h,@function
make_loc_ref_2_asm_h:                   // @make_loc_ref_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB628_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB628_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	make_loc_ref_0_asm_h
.Lfunc_end628:
	.size	make_loc_ref_2_asm_h, .Lfunc_end628-make_loc_ref_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	make_arg_ref_2_asm_h            // -- Begin function make_arg_ref_2_asm_h
	.p2align	2
	.type	make_arg_ref_2_asm_h,@function
make_arg_ref_2_asm_h:                   // @make_arg_ref_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB629_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB629_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	make_arg_ref_0_asm_h
.Lfunc_end629:
	.size	make_arg_ref_2_asm_h, .Lfunc_end629-make_arg_ref_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	make_var_ref_ref_2_asm_h        // -- Begin function make_var_ref_ref_2_asm_h
	.p2align	2
	.type	make_var_ref_ref_2_asm_h,@function
make_var_ref_ref_2_asm_h:               // @make_var_ref_ref_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB630_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB630_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	make_var_ref_ref_0_asm_h
.Lfunc_end630:
	.size	make_var_ref_ref_2_asm_h, .Lfunc_end630-make_var_ref_ref_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	make_var_ref_2_asm_h            // -- Begin function make_var_ref_2_asm_h
	.p2align	2
	.type	make_var_ref_2_asm_h,@function
make_var_ref_2_asm_h:                   // @make_var_ref_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB631_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB631_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	make_var_ref_0_asm_h
.Lfunc_end631:
	.size	make_var_ref_2_asm_h, .Lfunc_end631-make_var_ref_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_in_start_2_asm_h            // -- Begin function for_in_start_2_asm_h
	.p2align	2
	.type	for_in_start_2_asm_h,@function
for_in_start_2_asm_h:                   // @for_in_start_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB632_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB632_2:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	.LBB632_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB632_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end632:
	.size	for_in_start_2_asm_h, .Lfunc_end632-for_in_start_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_of_start_2_asm_h            // -- Begin function for_of_start_2_asm_h
	.p2align	2
	.type	for_of_start_2_asm_h,@function
for_of_start_2_asm_h:                   // @for_of_start_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB633_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB633_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	for_of_start_0_asm_h
.Lfunc_end633:
	.size	for_of_start_2_asm_h, .Lfunc_end633-for_of_start_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_await_of_start_2_asm_h      // -- Begin function for_await_of_start_2_asm_h
	.p2align	2
	.type	for_await_of_start_2_asm_h,@function
for_await_of_start_2_asm_h:             // @for_await_of_start_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB634_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB634_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	for_await_of_start_0_asm_h
.Lfunc_end634:
	.size	for_await_of_start_2_asm_h, .Lfunc_end634-for_await_of_start_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_in_next_2_asm_h             // -- Begin function for_in_next_2_asm_h
	.p2align	2
	.type	for_in_next_2_asm_h,@function
for_in_next_2_asm_h:                    // @for_in_next_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB635_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB635_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	for_in_next_0_asm_h
.Lfunc_end635:
	.size	for_in_next_2_asm_h, .Lfunc_end635-for_in_next_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_of_next_2_asm_h             // -- Begin function for_of_next_2_asm_h
	.p2align	2
	.type	for_of_next_2_asm_h,@function
for_of_next_2_asm_h:                    // @for_of_next_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB636_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB636_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	for_of_next_0_asm_h
.Lfunc_end636:
	.size	for_of_next_2_asm_h, .Lfunc_end636-for_of_next_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	for_await_of_next_2_asm_h       // -- Begin function for_await_of_next_2_asm_h
	.p2align	2
	.type	for_await_of_next_2_asm_h,@function
for_await_of_next_2_asm_h:              // @for_await_of_next_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB637_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB637_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	for_await_of_next_0_asm_h
.Lfunc_end637:
	.size	for_await_of_next_2_asm_h, .Lfunc_end637-for_await_of_next_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	iterator_get_value_done_2_asm_h // -- Begin function iterator_get_value_done_2_asm_h
	.p2align	2
	.type	iterator_get_value_done_2_asm_h,@function
iterator_get_value_done_2_asm_h:        // @iterator_get_value_done_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB638_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB638_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	iterator_get_value_done_0_asm_h
.Lfunc_end638:
	.size	iterator_get_value_done_2_asm_h, .Lfunc_end638-iterator_get_value_done_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	iterator_close_2_asm_h          // -- Begin function iterator_close_2_asm_h
	.p2align	2
	.type	iterator_close_2_asm_h,@function
iterator_close_2_asm_h:                 // @iterator_close_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB639_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB639_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	iterator_close_0_asm_h
.Lfunc_end639:
	.size	iterator_close_2_asm_h, .Lfunc_end639-iterator_close_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	iterator_close_return_2_asm_h   // -- Begin function iterator_close_return_2_asm_h
	.p2align	2
	.type	iterator_close_return_2_asm_h,@function
iterator_close_return_2_asm_h:          // @iterator_close_return_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB640_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB640_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	iterator_close_return_0_asm_h
.Lfunc_end640:
	.size	iterator_close_return_2_asm_h, .Lfunc_end640-iterator_close_return_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	async_iterator_close_2_asm_h    // -- Begin function async_iterator_close_2_asm_h
	.p2align	2
	.type	async_iterator_close_2_asm_h,@function
async_iterator_close_2_asm_h:           // @async_iterator_close_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB641_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB641_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	async_iterator_close_0_asm_h
.Lfunc_end641:
	.size	async_iterator_close_2_asm_h, .Lfunc_end641-async_iterator_close_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	async_iterator_next_2_asm_h     // -- Begin function async_iterator_next_2_asm_h
	.p2align	2
	.type	async_iterator_next_2_asm_h,@function
async_iterator_next_2_asm_h:            // @async_iterator_next_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB642_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB642_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	async_iterator_next_0_asm_h
.Lfunc_end642:
	.size	async_iterator_next_2_asm_h, .Lfunc_end642-async_iterator_next_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	async_iterator_get_2_asm_h      // -- Begin function async_iterator_get_2_asm_h
	.p2align	2
	.type	async_iterator_get_2_asm_h,@function
async_iterator_get_2_asm_h:             // @async_iterator_get_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB643_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB643_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	async_iterator_get_0_asm_h
.Lfunc_end643:
	.size	async_iterator_get_2_asm_h, .Lfunc_end643-async_iterator_get_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	initial_yield_2_asm_h           // -- Begin function initial_yield_2_asm_h
	.p2align	2
	.type	initial_yield_2_asm_h,@function
initial_yield_2_asm_h:                  // @initial_yield_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB644_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB644_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	initial_yield_0_asm_h
.Lfunc_end644:
	.size	initial_yield_2_asm_h, .Lfunc_end644-initial_yield_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	yield_2_asm_h                   // -- Begin function yield_2_asm_h
	.p2align	2
	.type	yield_2_asm_h,@function
yield_2_asm_h:                          // @yield_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB645_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB645_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	yield_0_asm_h
.Lfunc_end645:
	.size	yield_2_asm_h, .Lfunc_end645-yield_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	yield_star_2_asm_h              // -- Begin function yield_star_2_asm_h
	.p2align	2
	.type	yield_star_2_asm_h,@function
yield_star_2_asm_h:                     // @yield_star_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB646_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB646_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	yield_star_0_asm_h
.Lfunc_end646:
	.size	yield_star_2_asm_h, .Lfunc_end646-yield_star_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	async_yield_star_2_asm_h        // -- Begin function async_yield_star_2_asm_h
	.p2align	2
	.type	async_yield_star_2_asm_h,@function
async_yield_star_2_asm_h:               // @async_yield_star_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB647_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB647_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	async_yield_star_0_asm_h
.Lfunc_end647:
	.size	async_yield_star_2_asm_h, .Lfunc_end647-async_yield_star_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	await_2_asm_h                   // -- Begin function await_2_asm_h
	.p2align	2
	.type	await_2_asm_h,@function
await_2_asm_h:                          // @await_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB648_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB648_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	await_0_asm_h
.Lfunc_end648:
	.size	await_2_asm_h, .Lfunc_end648-await_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	neg_2_asm_h                     // -- Begin function neg_2_asm_h
	.p2align	2
	.type	neg_2_asm_h,@function
neg_2_asm_h:                            // @neg_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B23
	ldr	w8, [x24, #336]
	cbz	w8, .LBB649_2
// %bb.1:                               // %B24
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB649_2:                              // %B20
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	.LBB649_5
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB649_8
// %bb.4:                               // %B14
	orr	w8, w21, #0x80000000
	mov	w10, #-2147483648               // =0x80000000
	cmp	w8, w10
	b.ne	.LBB649_7
.LBB649_5:                              // %B17
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #140                        // =0x8c
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB649_10
// %bb.6:                               // %B19
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB649_7:                              // %B16
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	neg	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x0
.LBB649_8:                              // %B4
	tst	x21, #0xfffe000000000000
	b.eq	.LBB649_5
// %bb.9:                               // %B8
	movi	d0, #0000000000000000
	add	x8, x21, x8
	mov	x11, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fsub	d0, d0, d1
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	csel	x21, x10, x8, vc
	br	x0
.LBB649_10:                             // %B18
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end649:
	.size	neg_2_asm_h, .Lfunc_end649-neg_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	plus_2_asm_h                    // -- Begin function plus_2_asm_h
	.p2align	2
	.type	plus_2_asm_h,@function
plus_2_asm_h:                           // @plus_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B17
	ldr	w8, [x24, #336]
	cbz	w8, .LBB650_2
// %bb.1:                               // %B18
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB650_2:                              // %B14
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	.LBB650_6
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB650_5
.LBB650_4:                              // %B8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB650_5:                              // %B4
	tst	x21, #0xfffe000000000000
	b.ne	.LBB650_4
.LBB650_6:                              // %B11
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #141                        // =0x8d
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB650_8
// %bb.7:                               // %B13
	mov	x21, x0
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB650_8:                              // %B12
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end650:
	.size	plus_2_asm_h, .Lfunc_end650-plus_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dec_2_asm_h                     // -- Begin function dec_2_asm_h
	.p2align	2
	.type	dec_2_asm_h,@function
dec_2_asm_h:                            // @dec_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B23
	ldr	w8, [x24, #336]
	cbz	w8, .LBB651_2
// %bb.1:                               // %B24
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB651_2:                              // %B20
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	.LBB651_8
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB651_6
// %bb.4:                               // %B14
	subs	w8, w21, #1
	b.vs	.LBB651_8
// %bb.5:                               // %B16
	ldrb	w10, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB651_6:                              // %B4
	tst	x21, #0xfffe000000000000
	b.eq	.LBB651_8
// %bb.7:                               // %B8
	add	x8, x21, x8
	fmov	d0, #-1.00000000
	mov	x11, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	csel	x21, x10, x8, vc
	br	x0
.LBB651_8:                              // %B17
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #142                        // =0x8e
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB651_10
// %bb.9:                               // %B19
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB651_10:                             // %B18
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end651:
	.size	dec_2_asm_h, .Lfunc_end651-dec_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	inc_2_asm_h                     // -- Begin function inc_2_asm_h
	.p2align	2
	.type	inc_2_asm_h,@function
inc_2_asm_h:                            // @inc_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B23
	ldr	w8, [x24, #336]
	cbz	w8, .LBB652_2
// %bb.1:                               // %B24
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB652_2:                              // %B20
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	.LBB652_8
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB652_6
// %bb.4:                               // %B14
	adds	w8, w21, #1
	b.vs	.LBB652_8
// %bb.5:                               // %B16
	ldrb	w10, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB652_6:                              // %B4
	tst	x21, #0xfffe000000000000
	b.eq	.LBB652_8
// %bb.7:                               // %B8
	add	x8, x21, x8
	fmov	d0, #1.00000000
	mov	x11, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	csel	x21, x10, x8, vc
	br	x0
.LBB652_8:                              // %B17
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #143                        // =0x8f
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB652_10
// %bb.9:                               // %B19
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB652_10:                             // %B18
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end652:
	.size	inc_2_asm_h, .Lfunc_end652-inc_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	post_dec_2_asm_h                // -- Begin function post_dec_2_asm_h
	.p2align	2
	.type	post_dec_2_asm_h,@function
post_dec_2_asm_h:                       // @post_dec_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B20
	ldr	w8, [x24, #336]
	cbz	w8, .LBB653_2
// %bb.1:                               // %B21
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB653_2:                              // %B17
	mov	x8, #-281474976710656           // =0xffff000000000000
	str	x22, [x20], #8
	cmp	x21, x8
	b.hs	.LBB653_8
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB653_6
// %bb.4:                               // %B14
	subs	w8, w21, #1
	b.vs	.LBB653_8
// %bb.5:                               // %B16
	ldrb	w10, [x19], #1
	mov	x22, x21
	orr	x21, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB653_6:                              // %B4
	tst	x21, #0xfffe000000000000
	b.eq	.LBB653_8
// %bb.7:                               // %B9
	add	x8, x21, x8
	fmov	d0, #-1.00000000
	mov	x11, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	mov	x22, x21
	ldr	x0, [x25, x8, lsl #3]
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	mov	x11, #9221120237041090560       // =0x7ff8000000000000
	csel	x8, x10, x11, vc
	mov	x21, x8
	br	x0
.LBB653_8:                              // %B6
	str	x21, [x20], #8
	sub	x25, x25, #3872
	mov	w9, #144                        // =0x90
	b	SlowJSPostInc_asm_h
.Lfunc_end653:
	.size	post_dec_2_asm_h, .Lfunc_end653-post_dec_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	post_inc_2_asm_h                // -- Begin function post_inc_2_asm_h
	.p2align	2
	.type	post_inc_2_asm_h,@function
post_inc_2_asm_h:                       // @post_inc_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B20
	ldr	w8, [x24, #336]
	cbz	w8, .LBB654_2
// %bb.1:                               // %B21
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB654_2:                              // %B17
	mov	x8, #-281474976710656           // =0xffff000000000000
	str	x22, [x20], #8
	cmp	x21, x8
	b.hs	.LBB654_8
// %bb.3:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB654_6
// %bb.4:                               // %B14
	adds	w8, w21, #1
	b.vs	.LBB654_8
// %bb.5:                               // %B16
	ldrb	w10, [x19], #1
	mov	x22, x21
	orr	x21, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB654_6:                              // %B4
	tst	x21, #0xfffe000000000000
	b.eq	.LBB654_8
// %bb.7:                               // %B9
	add	x8, x21, x8
	fmov	d0, #1.00000000
	mov	x11, #562949953421312           // =0x2000000000000
	fmov	d1, x8
	ldrb	w8, [x19], #1
	mov	x22, x21
	ldr	x0, [x25, x8, lsl #3]
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	mov	x11, #9221120237041090560       // =0x7ff8000000000000
	csel	x8, x10, x11, vc
	mov	x21, x8
	br	x0
.LBB654_8:                              // %B6
	str	x21, [x20], #8
	sub	x25, x25, #3872
	mov	w9, #145                        // =0x91
	b	SlowJSPostInc_asm_h
.Lfunc_end654:
	.size	post_inc_2_asm_h, .Lfunc_end654-post_inc_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	dec_loc_2_asm_h                 // -- Begin function dec_loc_2_asm_h
	.p2align	2
	.type	dec_loc_2_asm_h,@function
dec_loc_2_asm_h:                        // @dec_loc_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B23
	ldr	w8, [x24, #336]
	cbz	w8, .LBB655_2
// %bb.1:                               // %B24
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB655_2:                              // %B20
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	b.hi	.LBB655_8
// %bb.3:                               // %B3
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB655_6
// %bb.4:                               // %B14
	subs	w10, w1, #1
	b.vs	.LBB655_8
// %bb.5:                               // %B16
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB655_6:                              // %B5
	tst	x1, #0xfffe000000000000
	b.eq	.LBB655_8
// %bb.7:                               // %B9
	add	x10, x1, x10
	fmov	d0, #-1.00000000
	mov	x11, #562949953421312           // =0x2000000000000
	fmov	d1, x10
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	mov	x11, #9221120237041090560       // =0x7ff8000000000000
	csel	x10, x10, x11, vc
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB655_8:                              // %B17
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #142                        // =0x8e
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB655_10
// %bb.9:                               // %B19
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB655_10:                             // %B18
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end655:
	.size	dec_loc_2_asm_h, .Lfunc_end655-dec_loc_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	inc_loc_2_asm_h                 // -- Begin function inc_loc_2_asm_h
	.p2align	2
	.type	inc_loc_2_asm_h,@function
inc_loc_2_asm_h:                        // @inc_loc_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B23
	ldr	w8, [x24, #336]
	cbz	w8, .LBB656_2
// %bb.1:                               // %B24
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB656_2:                              // %B20
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	b.hi	.LBB656_8
// %bb.3:                               // %B3
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB656_6
// %bb.4:                               // %B14
	adds	w10, w1, #1
	b.vs	.LBB656_8
// %bb.5:                               // %B16
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB656_6:                              // %B5
	tst	x1, #0xfffe000000000000
	b.eq	.LBB656_8
// %bb.7:                               // %B9
	add	x10, x1, x10
	fmov	d0, #1.00000000
	mov	x11, #562949953421312           // =0x2000000000000
	fmov	d1, x10
	fadd	d0, d1, d0
	fmov	x10, d0
	fcmp	d0, d0
	add	x10, x10, x11
	mov	x11, #9221120237041090560       // =0x7ff8000000000000
	csel	x10, x10, x11, vc
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB656_8:                              // %B17
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #143                        // =0x8f
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB656_10
// %bb.9:                               // %B19
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB656_10:                             // %B18
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end656:
	.size	inc_loc_2_asm_h, .Lfunc_end656-inc_loc_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	add_loc_2_asm_h                 // -- Begin function add_loc_2_asm_h
	.p2align	2
	.type	add_loc_2_asm_h,@function
add_loc_2_asm_h:                        // @add_loc_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B49
	ldr	w8, [x24, #336]
	cbz	w8, .LBB657_2
// %bb.1:                               // %B50
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB657_2:                              // %B46
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	b.hi	.LBB657_17
// %bb.3:                               // %B46
	cmp	x21, x10
	b.hi	.LBB657_17
// %bb.4:                               // %B3
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB657_8
// %bb.5:                               // %B27
	cmp	x21, x10
	b.lo	.LBB657_11
// %bb.6:                               // %B37
	adds	w10, w1, w21
	b.vs	.LBB657_17
// %bb.7:                               // %B39
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB657_8:                              // %B5
	tst	x1, #0xfffe000000000000
	b.eq	.LBB657_17
// %bb.9:                               // %B12
	cmp	x21, x10
	b.lo	.LBB657_15
// %bb.10:                              // %B22
	scvtf	d0, w21
	add	x10, x1, x10
	fmov	d1, x10
	fadd	d0, d1, d0
	b	.LBB657_14
.LBB657_11:                             // %B29
	tst	x21, #0xfffe000000000000
	b.eq	.LBB657_17
// %bb.12:                              // %B32
	scvtf	d0, w1
	add	x10, x21, x10
.LBB657_13:                             // %B32
	fmov	d1, x10
	fadd	d0, d0, d1
.LBB657_14:                             // %B32
	fmov	x10, d0
	fcmp	d0, d0
	mov	x11, #562949953421312           // =0x2000000000000
	add	x10, x10, x11
	mov	x11, #9221120237041090560       // =0x7ff8000000000000
	csel	x10, x10, x11, vc
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB657_15:                             // %B14
	tst	x21, #0xfffe000000000000
	b.eq	.LBB657_17
// %bb.16:                              // %B17
	add	x11, x1, x10
	add	x10, x21, x10
	fmov	d0, x11
	b	.LBB657_13
.LBB657_17:                             // %B8
	mov	x8, #2                          // =0x2
	and	x10, x1, #0xffff000000000003
	add	x11, x20, #16
	movk	x8, #1, lsl #48
	stp	x22, x21, [x20]
	cmp	x10, x8
	str	x11, [x29, #64]
	b.ne	.LBB657_20
// %bb.18:                              // %B8
	and	x10, x21, #0xffff000000000003
	cmp	x10, x8
	b.ne	.LBB657_20
// %bb.19:                              // %B40
	mov	x0, x24
	mov	x2, x21
	bl	JS_ConcatString_GC
	b	.LBB657_21
.LBB657_20:                             // %B43
	mov	x0, x24
	mov	x2, x21
	bl	prim_js_add_slow_gc
.LBB657_21:                             // %B43
	cmp	x0, #130
	b.eq	.LBB657_23
// %bb.22:                              // %B45
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB657_23:                             // %B44
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end657:
	.size	add_loc_2_asm_h, .Lfunc_end657-add_loc_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	not_2_asm_h                     // -- Begin function not_2_asm_h
	.p2align	2
	.type	not_2_asm_h,@function
not_2_asm_h:                            // @not_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB658_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB658_2:                              // %B3
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB658_4
// %bb.3:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	mvn	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x0
.LBB658_4:                              // %B5
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	mov	x9, x21
	b	SlowJSNot_asm_h
.Lfunc_end658:
	.size	not_2_asm_h, .Lfunc_end658-not_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	lnot_2_asm_h                    // -- Begin function lnot_2_asm_h
	.p2align	2
	.type	lnot_2_asm_h,@function
lnot_2_asm_h:                           // @lnot_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B18
	ldr	w8, [x24, #336]
	cbz	w8, .LBB659_2
// %bb.1:                               // %B19
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB659_2:                              // %B15
	cmp	x21, #5
	b.le	.LBB659_6
// %bb.3:                               // %B15
	cmp	x21, #6
	b.eq	.LBB659_8
// %bb.4:                               // %B15
	cmp	x21, #7
	b.eq	.LBB659_10
// %bb.5:                               // %B15
	cmp	x21, #18
	b.eq	.LBB659_8
	b	.LBB659_9
.LBB659_6:                              // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB659_8
// %bb.7:                               // %B15
	cmp	x21, #2
	b.ne	.LBB659_9
.LBB659_8:                              // %B4
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB659_9:                              // %B11
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB659_11
.LBB659_10:                             // %B13
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB659_11:                             // %B14
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	mov	x9, x21
	b	SlowToBoolean_asm_h
.Lfunc_end659:
	.size	lnot_2_asm_h, .Lfunc_end659-lnot_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	typeof_2_asm_h                  // -- Begin function typeof_2_asm_h
	.p2align	2
	.type	typeof_2_asm_h,@function
typeof_2_asm_h:                         // @typeof_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB660_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB660_2:                              // %B2
	mov	x0, x24
	mov	x1, x21
	bl	js_operator_typeof_gc
	mov	w1, w0
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB660_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB660_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end660:
	.size	typeof_2_asm_h, .Lfunc_end660-typeof_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	delete_2_asm_h                  // -- Begin function delete_2_asm_h
	.p2align	2
	.type	delete_2_asm_h,@function
delete_2_asm_h:                         // @delete_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB661_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB661_2:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	.LBB661_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB661_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end661:
	.size	delete_2_asm_h, .Lfunc_end661-delete_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	delete_var_2_asm_h              // -- Begin function delete_var_2_asm_h
	.p2align	2
	.type	delete_var_2_asm_h,@function
delete_var_2_asm_h:                     // @delete_var_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB662_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB662_2:                              // %B2
	str	x22, [x20]
	mov	x0, x24
	mov	w3, wzr
	ldr	w2, [x19]
	ldr	x1, [x24, #224]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x29, #64]
	bl	LEPUS_DeleteProperty
	tbnz	w0, #31, .LBB662_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	mov	x22, x21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x21, x8, ne
	br	x0
.LBB662_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.Lfunc_end662:
	.size	delete_var_2_asm_h, .Lfunc_end662-delete_var_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	mul_2_asm_h                     // -- Begin function mul_2_asm_h
	.p2align	2
	.type	mul_2_asm_h,@function
mul_2_asm_h:                            // @mul_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B51
	ldr	w8, [x24, #336]
	cbz	w8, .LBB663_2
// %bb.1:                               // %B52
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB663_2:                              // %B48
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB663_20
// %bb.3:                               // %B48
	cmp	x21, x8
	b.hi	.LBB663_20
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB663_10
// %bb.5:                               // %B24
	cmp	x21, x8
	b.lo	.LBB663_13
// %bb.6:                               // %B34
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	.LBB663_20
// %bb.7:                               // %B37
	cbnz	w8, .LBB663_9
// %bb.8:                               // %B37
	orr	w10, w22, w21
	tbnz	w10, #31, .LBB663_17
.LBB663_9:                              // %B44
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB663_10:                             // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB663_20
// %bb.11:                              // %B8
	cmp	x21, x8
	b.lo	.LBB663_18
// %bb.12:                              // %B19
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	.LBB663_16
.LBB663_13:                             // %B26
	tst	x21, #0xfffe000000000000
	b.eq	.LBB663_20
// %bb.14:                              // %B29
	scvtf	d0, w22
	add	x8, x21, x8
.LBB663_15:                             // %B29
	fmov	d1, x8
	fmul	d0, d0, d1
.LBB663_16:                             // %B29
	ldrb	w8, [x19], #1
	fmov	x10, d0
	fcmp	d0, d0
	sub	x25, x25, #1936
	mov	x11, #562949953421312           // =0x2000000000000
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB663_17:                             // %B41
	mov	x22, #-9222809086901354496      // =0x8002000000000000
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB663_18:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB663_20
// %bb.19:                              // %B13
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB663_15
.LBB663_20:                             // %B45
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        // =0x9a
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB663_22
// %bb.21:                              // %B47
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB663_22:                             // %B46
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end663:
	.size	mul_2_asm_h, .Lfunc_end663-mul_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	div_2_asm_h                     // -- Begin function div_2_asm_h
	.p2align	2
	.type	div_2_asm_h,@function
div_2_asm_h:                            // @div_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B48
	ldr	w8, [x24, #336]
	cbz	w8, .LBB664_2
// %bb.1:                               // %B49
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB664_2:                              // %B45
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB664_16
// %bb.3:                               // %B45
	cmp	x21, x8
	b.hi	.LBB664_16
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB664_7
// %bb.5:                               // %B24
	cmp	x21, x8
	b.lo	.LBB664_10
// %bb.6:                               // %B34
	scvtf	d0, w22
	scvtf	d1, w21
	mov	x10, #562949953421312           // =0x2000000000000
	ldrb	w11, [x19], #1
	sub	x25, x25, #1936
	mov	x13, #9221120237041090560       // =0x7ff8000000000000
	ldr	x0, [x25, x11, lsl #3]
	fdiv	d0, d0, d1
	fcvtzs	w8, d0
	fmov	x12, d0
	fcmp	d0, d0
	add	x10, x12, x10
	csel	x10, x10, x13, vc
	cmp	x8, x12
	orr	x8, x8, #0xfffe000000000000
	csel	x22, x10, x8, ne
	br	x0
.LBB664_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB664_16
// %bb.8:                               // %B8
	cmp	x21, x8
	b.lo	.LBB664_14
// %bb.9:                               // %B19
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	.LBB664_13
.LBB664_10:                             // %B26
	tst	x21, #0xfffe000000000000
	b.eq	.LBB664_16
// %bb.11:                              // %B29
	scvtf	d0, w22
	add	x8, x21, x8
.LBB664_12:                             // %B29
	fmov	d1, x8
	fdiv	d0, d0, d1
.LBB664_13:                             // %B29
	ldrb	w8, [x19], #1
	fmov	x10, d0
	fcmp	d0, d0
	sub	x25, x25, #1936
	mov	x11, #562949953421312           // =0x2000000000000
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB664_14:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB664_16
// %bb.15:                              // %B13
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB664_12
.LBB664_16:                             // %B42
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        // =0x9b
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB664_18
// %bb.17:                              // %B44
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB664_18:                             // %B43
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end664:
	.size	div_2_asm_h, .Lfunc_end664-div_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	mod_2_asm_h                     // -- Begin function mod_2_asm_h
	.p2align	2
	.type	mod_2_asm_h,@function
mod_2_asm_h:                            // @mod_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B43
	ldr	w8, [x24, #336]
	cbz	w8, .LBB665_2
// %bb.1:                               // %B44
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB665_2:                              // %B40
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB665_18
// %bb.3:                               // %B40
	cmp	x21, x8
	b.hi	.LBB665_18
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB665_9
// %bb.5:                               // %B24
	cmp	x21, x8
	b.lo	.LBB665_12
// %bb.6:                               // %B34
	tbnz	w22, #31, .LBB665_18
// %bb.7:                               // %B34
	cmp	w21, #1
	b.lt	.LBB665_18
// %bb.8:                               // %B36
	sdiv	w8, w22, w21
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	ldr	x0, [x25, x10, lsl #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB665_9:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB665_18
// %bb.10:                              // %B8
	cmp	x21, x8
	b.lo	.LBB665_16
// %bb.11:                              // %B19
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	.LBB665_15
.LBB665_12:                             // %B26
	tst	x21, #0xfffe000000000000
	b.eq	.LBB665_18
// %bb.13:                              // %B29
	scvtf	d0, w22
	add	x8, x21, x8
.LBB665_14:                             // %B29
	fmov	d1, x8
.LBB665_15:                             // %B29
	bl	fmod
	ldrb	w8, [x19], #1
	fmov	x10, d0
	fcmp	d0, d0
	sub	x25, x25, #1936
	mov	x11, #562949953421312           // =0x2000000000000
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB665_16:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB665_18
// %bb.17:                              // %B13
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB665_14
.LBB665_18:                             // %B37
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        // =0x9c
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB665_20
// %bb.19:                              // %B39
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB665_20:                             // %B38
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end665:
	.size	mod_2_asm_h, .Lfunc_end665-mod_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	add_2_asm_h                     // -- Begin function add_2_asm_h
	.p2align	2
	.type	add_2_asm_h,@function
add_2_asm_h:                            // @add_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B49
	ldr	w8, [x24, #336]
	cbz	w8, .LBB666_2
// %bb.1:                               // %B50
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB666_2:                              // %B46
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB666_17
// %bb.3:                               // %B46
	cmp	x21, x8
	b.hi	.LBB666_17
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB666_8
// %bb.5:                               // %B27
	cmp	x21, x8
	b.lo	.LBB666_11
// %bb.6:                               // %B37
	adds	w8, w22, w21
	b.vs	.LBB666_17
// %bb.7:                               // %B39
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB666_8:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB666_17
// %bb.9:                               // %B11
	cmp	x21, x8
	b.lo	.LBB666_15
// %bb.10:                              // %B22
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	.LBB666_14
.LBB666_11:                             // %B29
	tst	x21, #0xfffe000000000000
	b.eq	.LBB666_17
// %bb.12:                              // %B32
	scvtf	d0, w22
	add	x8, x21, x8
.LBB666_13:                             // %B32
	fmov	d1, x8
	fadd	d0, d0, d1
.LBB666_14:                             // %B32
	ldrb	w8, [x19], #1
	fmov	x10, d0
	fcmp	d0, d0
	sub	x25, x25, #1936
	mov	x11, #562949953421312           // =0x2000000000000
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB666_15:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB666_17
// %bb.16:                              // %B16
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB666_13
.LBB666_17:                             // %B7
	mov	x8, #2                          // =0x2
	and	x10, x22, #0xffff000000000003
	add	x11, x20, #16
	movk	x8, #1, lsl #48
	stp	x22, x21, [x20]
	cmp	x10, x8
	str	x11, [x29, #64]
	b.ne	.LBB666_20
// %bb.18:                              // %B7
	and	x10, x21, #0xffff000000000003
	cmp	x10, x8
	b.ne	.LBB666_20
// %bb.19:                              // %B40
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	JS_ConcatString_GC
	b	.LBB666_21
.LBB666_20:                             // %B43
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_add_slow_gc
.LBB666_21:                             // %B43
	cmp	x0, #130
	b.eq	.LBB666_23
// %bb.22:                              // %B45
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB666_23:                             // %B44
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end666:
	.size	add_2_asm_h, .Lfunc_end666-add_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	sub_2_asm_h                     // -- Begin function sub_2_asm_h
	.p2align	2
	.type	sub_2_asm_h,@function
sub_2_asm_h:                            // @sub_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B43
	ldr	w8, [x24, #336]
	cbz	w8, .LBB667_2
// %bb.1:                               // %B44
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB667_2:                              // %B40
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB667_17
// %bb.3:                               // %B40
	cmp	x21, x8
	b.hi	.LBB667_17
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB667_8
// %bb.5:                               // %B24
	cmp	x21, x8
	b.lo	.LBB667_11
// %bb.6:                               // %B34
	subs	w8, w22, w21
	b.vs	.LBB667_17
// %bb.7:                               // %B36
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB667_8:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB667_17
// %bb.9:                               // %B8
	cmp	x21, x8
	b.lo	.LBB667_15
// %bb.10:                              // %B19
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	.LBB667_14
.LBB667_11:                             // %B26
	tst	x21, #0xfffe000000000000
	b.eq	.LBB667_17
// %bb.12:                              // %B29
	scvtf	d0, w22
	add	x8, x21, x8
.LBB667_13:                             // %B29
	fmov	d1, x8
	fsub	d0, d0, d1
.LBB667_14:                             // %B29
	ldrb	w8, [x19], #1
	fmov	x10, d0
	fcmp	d0, d0
	sub	x25, x25, #1936
	mov	x11, #562949953421312           // =0x2000000000000
	ldr	x0, [x25, x8, lsl #3]
	mov	x8, #9221120237041090560        // =0x7ff8000000000000
	add	x10, x10, x11
	csel	x22, x10, x8, vc
	br	x0
.LBB667_15:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB667_17
// %bb.16:                              // %B13
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB667_13
.LBB667_17:                             // %B37
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        // =0x9e
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB667_19
// %bb.18:                              // %B39
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB667_19:                             // %B38
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end667:
	.size	sub_2_asm_h, .Lfunc_end667-sub_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	pow_2_asm_h                     // -- Begin function pow_2_asm_h
	.p2align	2
	.type	pow_2_asm_h,@function
pow_2_asm_h:                            // @pow_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB668_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB668_2:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #159                        // =0x9f
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB668_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB668_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end668:
	.size	pow_2_asm_h, .Lfunc_end668-pow_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	shl_2_asm_h                     // -- Begin function shl_2_asm_h
	.p2align	2
	.type	shl_2_asm_h,@function
shl_2_asm_h:                            // @shl_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B32
	ldr	w8, [x24, #336]
	cbz	w8, .LBB669_2
// %bb.1:                               // %B33
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB669_2:                              // %B29
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB669_11
// %bb.3:                               // %B29
	cmp	x21, x8
	b.hi	.LBB669_11
// %bb.4:                               // %B3
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB669_7
// %bb.5:                               // %B20
	cmp	x21, x8
	b.lo	.LBB669_11
// %bb.6:                               // %B25
	mov	w8, w22
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	lsl	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB669_7:                              // %B5
	tst	x22, #0xfffe000000000000
	b.eq	.LBB669_11
// %bb.8:                               // %B5
	cmp	x21, x8
	b.lo	.LBB669_11
// %bb.9:                               // %B15
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB669_11
// %bb.10:                              // %B16
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	lsl	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB669_11:                             // %B26
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        // =0xa0
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB669_13
// %bb.12:                              // %B28
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB669_13:                             // %B27
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end669:
	.size	shl_2_asm_h, .Lfunc_end669-shl_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	sar_2_asm_h                     // -- Begin function sar_2_asm_h
	.p2align	2
	.type	sar_2_asm_h,@function
sar_2_asm_h:                            // @sar_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B32
	ldr	w8, [x24, #336]
	cbz	w8, .LBB670_2
// %bb.1:                               // %B33
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB670_2:                              // %B29
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB670_11
// %bb.3:                               // %B29
	cmp	x21, x8
	b.hi	.LBB670_11
// %bb.4:                               // %B3
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB670_7
// %bb.5:                               // %B20
	cmp	x21, x8
	b.lo	.LBB670_11
// %bb.6:                               // %B25
	mov	w8, w22
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	asr	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB670_7:                              // %B5
	tst	x22, #0xfffe000000000000
	b.eq	.LBB670_11
// %bb.8:                               // %B5
	cmp	x21, x8
	b.lo	.LBB670_11
// %bb.9:                               // %B15
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB670_11
// %bb.10:                              // %B16
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	asr	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB670_11:                             // %B26
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        // =0xa1
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB670_13
// %bb.12:                              // %B28
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB670_13:                             // %B27
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end670:
	.size	sar_2_asm_h, .Lfunc_end670-sar_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	shr_2_asm_h                     // -- Begin function shr_2_asm_h
	.p2align	2
	.type	shr_2_asm_h,@function
shr_2_asm_h:                            // @shr_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B40
	ldr	w8, [x24, #336]
	cbz	w8, .LBB671_2
// %bb.1:                               // %B41
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB671_2:                              // %B37
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB671_13
// %bb.3:                               // %B37
	cmp	x21, x8
	b.hi	.LBB671_13
// %bb.4:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB671_8
// %bb.5:                               // %B28
	cmp	x21, x8
	b.lo	.LBB671_13
// %bb.6:                               // %B33
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, .LBB671_12
.LBB671_7:                              // %B3
	orr	x8, x8, #0xfffe000000000000
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB671_8:                              // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB671_13
// %bb.9:                               // %B13
	cmp	x21, x8
	b.lo	.LBB671_13
// %bb.10:                              // %B23
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB671_13
// %bb.11:                              // %B24
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, .LBB671_7
.LBB671_12:                             // %B7
	ucvtf	d0, w8
	mov	x10, #562949953421312           // =0x2000000000000
	fmov	x8, d0
	fcmp	d0, d0
	add	x8, x8, x10
	mov	x10, #9221120237041090560       // =0x7ff8000000000000
	csel	x8, x8, x10, vc
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB671_13:                             // %B34
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	.LBB671_15
// %bb.14:                              // %B36
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB671_15:                             // %B35
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end671:
	.size	shr_2_asm_h, .Lfunc_end671-shr_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	lt_2_asm_h                      // -- Begin function lt_2_asm_h
	.p2align	2
	.type	lt_2_asm_h,@function
lt_2_asm_h:                             // @lt_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B28
	ldr	w8, [x24, #336]
	cbz	w8, .LBB672_2
// %bb.1:                               // %B29
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB672_2:                              // %B25
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB672_15
// %bb.3:                               // %B25
	cmp	x21, x8
	b.hi	.LBB672_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB672_7
// %bb.5:                               // %B16
	cmp	x21, x8
	b.lo	.LBB672_10
// %bb.6:                               // %B21
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, lt
	br	x0
.LBB672_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB672_15
// %bb.8:                               // %B8
	cmp	x21, x8
	b.lo	.LBB672_13
// %bb.9:                               // %B14
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x0
.LBB672_10:                             // %B18
	tst	x21, #0xfffe000000000000
	b.eq	.LBB672_15
// %bb.11:                              // %B20
	scvtf	d0, w22
	add	x8, x21, x8
.LBB672_12:                             // %B20
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x0
.LBB672_13:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB672_15
// %bb.14:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB672_12
.LBB672_15:                             // %B22
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        // =0xa3
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB672_17
// %bb.16:                              // %B24
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB672_17:                             // %B23
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end672:
	.size	lt_2_asm_h, .Lfunc_end672-lt_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	lte_2_asm_h                     // -- Begin function lte_2_asm_h
	.p2align	2
	.type	lte_2_asm_h,@function
lte_2_asm_h:                            // @lte_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B28
	ldr	w8, [x24, #336]
	cbz	w8, .LBB673_2
// %bb.1:                               // %B29
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB673_2:                              // %B25
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB673_15
// %bb.3:                               // %B25
	cmp	x21, x8
	b.hi	.LBB673_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB673_7
// %bb.5:                               // %B16
	cmp	x21, x8
	b.lo	.LBB673_10
// %bb.6:                               // %B21
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, le
	br	x0
.LBB673_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB673_15
// %bb.8:                               // %B8
	cmp	x21, x8
	b.lo	.LBB673_13
// %bb.9:                               // %B14
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x0
.LBB673_10:                             // %B18
	tst	x21, #0xfffe000000000000
	b.eq	.LBB673_15
// %bb.11:                              // %B20
	scvtf	d0, w22
	add	x8, x21, x8
.LBB673_12:                             // %B20
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x0
.LBB673_13:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB673_15
// %bb.14:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB673_12
.LBB673_15:                             // %B22
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        // =0xa4
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB673_17
// %bb.16:                              // %B24
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB673_17:                             // %B23
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end673:
	.size	lte_2_asm_h, .Lfunc_end673-lte_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	gt_2_asm_h                      // -- Begin function gt_2_asm_h
	.p2align	2
	.type	gt_2_asm_h,@function
gt_2_asm_h:                             // @gt_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B28
	ldr	w8, [x24, #336]
	cbz	w8, .LBB674_2
// %bb.1:                               // %B29
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB674_2:                              // %B25
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB674_15
// %bb.3:                               // %B25
	cmp	x21, x8
	b.hi	.LBB674_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB674_7
// %bb.5:                               // %B16
	cmp	x21, x8
	b.lo	.LBB674_10
// %bb.6:                               // %B21
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x0
.LBB674_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB674_15
// %bb.8:                               // %B8
	cmp	x21, x8
	b.lo	.LBB674_13
// %bb.9:                               // %B14
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x0
.LBB674_10:                             // %B18
	tst	x21, #0xfffe000000000000
	b.eq	.LBB674_15
// %bb.11:                              // %B20
	scvtf	d0, w22
	add	x8, x21, x8
.LBB674_12:                             // %B20
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x0
.LBB674_13:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB674_15
// %bb.14:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB674_12
.LBB674_15:                             // %B22
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        // =0xa5
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB674_17
// %bb.16:                              // %B24
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB674_17:                             // %B23
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end674:
	.size	gt_2_asm_h, .Lfunc_end674-gt_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	gte_2_asm_h                     // -- Begin function gte_2_asm_h
	.p2align	2
	.type	gte_2_asm_h,@function
gte_2_asm_h:                            // @gte_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B28
	ldr	w8, [x24, #336]
	cbz	w8, .LBB675_2
// %bb.1:                               // %B29
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB675_2:                              // %B25
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB675_15
// %bb.3:                               // %B25
	cmp	x21, x8
	b.hi	.LBB675_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB675_7
// %bb.5:                               // %B16
	cmp	x21, x8
	b.lo	.LBB675_10
// %bb.6:                               // %B21
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x0
.LBB675_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB675_15
// %bb.8:                               // %B8
	cmp	x21, x8
	b.lo	.LBB675_13
// %bb.9:                               // %B14
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d1, d0
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x0
.LBB675_10:                             // %B18
	tst	x21, #0xfffe000000000000
	b.eq	.LBB675_15
// %bb.11:                              // %B20
	scvtf	d0, w22
	add	x8, x21, x8
.LBB675_12:                             // %B20
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x0
.LBB675_13:                             // %B10
	tst	x21, #0xfffe000000000000
	b.eq	.LBB675_15
// %bb.14:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB675_12
.LBB675_15:                             // %B22
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        // =0xa6
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB675_17
// %bb.16:                              // %B24
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB675_17:                             // %B23
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end675:
	.size	gte_2_asm_h, .Lfunc_end675-gte_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	instanceof_2_asm_h              // -- Begin function instanceof_2_asm_h
	.p2align	2
	.type	instanceof_2_asm_h,@function
instanceof_2_asm_h:                     // @instanceof_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB676_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB676_2:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	.LBB676_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB676_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end676:
	.size	instanceof_2_asm_h, .Lfunc_end676-instanceof_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	in_2_asm_h                      // -- Begin function in_2_asm_h
	.p2align	2
	.type	in_2_asm_h,@function
in_2_asm_h:                             // @in_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB677_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB677_2:                              // %B2
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	.LBB677_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB677_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end677:
	.size	in_2_asm_h, .Lfunc_end677-in_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	eq_2_asm_h                      // -- Begin function eq_2_asm_h
	.p2align	2
	.type	eq_2_asm_h,@function
eq_2_asm_h:                             // @eq_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B48
	ldr	w8, [x24, #336]
	cbz	w8, .LBB678_2
// %bb.1:                               // %B49
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB678_2:                              // %B45
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB678_15
// %bb.3:                               // %B45
	cmp	x21, x8
	b.hi	.LBB678_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB678_7
// %bb.5:                               // %B36
	cmp	x21, x8
	b.lo	.LBB678_10
// %bb.6:                               // %B41
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x0
.LBB678_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB678_15
// %bb.8:                               // %B29
	cmp	x21, x8
	b.lo	.LBB678_13
// %bb.9:                               // %B34
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fcmp	d1, d0
	cset	w8, eq
	fcmp	d1, d1
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	csel	w8, wzr, w8, vs
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB678_10:                             // %B38
	tst	x21, #0xfffe000000000000
	b.eq	.LBB678_15
// %bb.11:                              // %B40
	scvtf	d0, w22
	add	x8, x21, x8
.LBB678_12:                             // %B40
	fmov	d1, x8
	fcmp	d0, d1
	cset	w8, eq
	fcmp	d0, d0
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	csel	w8, wzr, w8, vs
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB678_13:                             // %B31
	tst	x21, #0xfffe000000000000
	b.eq	.LBB678_15
// %bb.14:                              // %B33
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB678_12
.LBB678_15:                             // %B8
	cmp	x22, x21
	b.ne	.LBB678_17
.LBB678_16:                             // %B9
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB678_17:                             // %B11
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB678_19
// %bb.18:                              // %B13
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB678_16
	b	.LBB678_22
.LBB678_19:                             // %B18
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB678_22
// %bb.20:                              // %B21
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB678_23
// %bb.21:                              // %B21
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB678_23
.LBB678_22:                             // %B16
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB678_23:                             // %B42
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB678_25
// %bb.24:                              // %B44
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB678_25:                             // %B43
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end678:
	.size	eq_2_asm_h, .Lfunc_end678-eq_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	neq_2_asm_h                     // -- Begin function neq_2_asm_h
	.p2align	2
	.type	neq_2_asm_h,@function
neq_2_asm_h:                            // @neq_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B48
	ldr	w8, [x24, #336]
	cbz	w8, .LBB679_2
// %bb.1:                               // %B49
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB679_2:                              // %B45
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB679_15
// %bb.3:                               // %B45
	cmp	x21, x8
	b.hi	.LBB679_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB679_7
// %bb.5:                               // %B36
	cmp	x21, x8
	b.lo	.LBB679_10
// %bb.6:                               // %B41
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x0
.LBB679_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB679_15
// %bb.8:                               // %B29
	cmp	x21, x8
	b.lo	.LBB679_13
// %bb.9:                               // %B34
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fcmp	d1, d0
	cset	w8, ne
	fcmp	d1, d1
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	csinc	w8, w8, wzr, vc
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB679_10:                             // %B38
	tst	x21, #0xfffe000000000000
	b.eq	.LBB679_15
// %bb.11:                              // %B40
	scvtf	d0, w22
	add	x8, x21, x8
.LBB679_12:                             // %B40
	fmov	d1, x8
	fcmp	d0, d1
	cset	w8, ne
	fcmp	d0, d0
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	csinc	w8, w8, wzr, vc
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB679_13:                             // %B31
	tst	x21, #0xfffe000000000000
	b.eq	.LBB679_15
// %bb.14:                              // %B33
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB679_12
.LBB679_15:                             // %B8
	cmp	x22, x21
	b.ne	.LBB679_17
.LBB679_16:                             // %B9
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB679_17:                             // %B11
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB679_19
// %bb.18:                              // %B13
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB679_16
	b	.LBB679_22
.LBB679_19:                             // %B18
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB679_22
// %bb.20:                              // %B21
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB679_23
// %bb.21:                              // %B21
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB679_23
.LBB679_22:                             // %B16
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB679_23:                             // %B42
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB679_25
// %bb.24:                              // %B44
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB679_25:                             // %B43
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end679:
	.size	neq_2_asm_h, .Lfunc_end679-neq_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	strict_eq_2_asm_h               // -- Begin function strict_eq_2_asm_h
	.p2align	2
	.type	strict_eq_2_asm_h,@function
strict_eq_2_asm_h:                      // @strict_eq_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B34
	ldr	w8, [x24, #336]
	cbz	w8, .LBB680_2
// %bb.1:                               // %B35
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB680_2:                              // %B31
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB680_15
// %bb.3:                               // %B31
	cmp	x21, x8
	b.hi	.LBB680_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB680_7
// %bb.5:                               // %B22
	cmp	x21, x8
	b.lo	.LBB680_10
// %bb.6:                               // %B27
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x0
.LBB680_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB680_15
// %bb.8:                               // %B15
	cmp	x21, x8
	b.lo	.LBB680_13
// %bb.9:                               // %B20
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fcmp	d1, d0
	cset	w8, eq
	fcmp	d1, d1
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	csel	w8, wzr, w8, vs
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB680_10:                             // %B24
	tst	x21, #0xfffe000000000000
	b.eq	.LBB680_15
// %bb.11:                              // %B26
	scvtf	d0, w22
	add	x8, x21, x8
.LBB680_12:                             // %B26
	fmov	d1, x8
	fcmp	d0, d1
	cset	w8, eq
	fcmp	d0, d0
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	csel	w8, wzr, w8, vs
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB680_13:                             // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB680_15
// %bb.14:                              // %B19
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB680_12
.LBB680_15:                             // %B8
	cmp	x22, x21
	b.ne	.LBB680_17
// %bb.16:                              // %B9
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB680_17:                             // %B11
	and	x8, x21, #0xffff000000000003
	mov	x10, #-281474976710653          // =0xffff000000000003
	mov	x11, #2                         // =0x2
	cmp	x8, x10
	movk	x11, #1, lsl #48
	mov	x12, #2                         // =0x2
	ccmp	x8, x11, #4, ne
	movk	x12, #65535, lsl #48
	mov	x13, #-281474976710656          // =0xffff000000000000
	ccmp	x8, x12, #4, ne
	and	x14, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w8, eq
	cmp	x14, x13
	ccmp	x14, x12, #4, ne
	ccmp	x14, x11, #4, ne
	ccmp	x14, x10, #4, ne
	b.ne	.LBB680_19
// %bb.18:                              // %B11
	tbnz	w8, #0, .LBB680_20
.LBB680_19:                             // %B13
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB680_20:                             // %B28
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB680_22
// %bb.21:                              // %B30
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB680_22:                             // %B29
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end680:
	.size	strict_eq_2_asm_h, .Lfunc_end680-strict_eq_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	strict_neq_2_asm_h              // -- Begin function strict_neq_2_asm_h
	.p2align	2
	.type	strict_neq_2_asm_h,@function
strict_neq_2_asm_h:                     // @strict_neq_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B34
	ldr	w8, [x24, #336]
	cbz	w8, .LBB681_2
// %bb.1:                               // %B35
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB681_2:                              // %B31
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB681_15
// %bb.3:                               // %B31
	cmp	x21, x8
	b.hi	.LBB681_15
// %bb.4:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB681_7
// %bb.5:                               // %B22
	cmp	x21, x8
	b.lo	.LBB681_10
// %bb.6:                               // %B27
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x0
.LBB681_7:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB681_15
// %bb.8:                               // %B15
	cmp	x21, x8
	b.lo	.LBB681_13
// %bb.9:                               // %B20
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fcmp	d1, d0
	cset	w8, ne
	fcmp	d1, d1
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	csinc	w8, w8, wzr, vc
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB681_10:                             // %B24
	tst	x21, #0xfffe000000000000
	b.eq	.LBB681_15
// %bb.11:                              // %B26
	scvtf	d0, w22
	add	x8, x21, x8
.LBB681_12:                             // %B26
	fmov	d1, x8
	fcmp	d0, d1
	cset	w8, ne
	fcmp	d0, d0
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	csinc	w8, w8, wzr, vc
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB681_13:                             // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB681_15
// %bb.14:                              // %B19
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB681_12
.LBB681_15:                             // %B8
	cmp	x22, x21
	b.ne	.LBB681_17
// %bb.16:                              // %B9
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB681_17:                             // %B11
	and	x8, x21, #0xffff000000000003
	mov	x10, #-281474976710653          // =0xffff000000000003
	mov	x11, #2                         // =0x2
	cmp	x8, x10
	movk	x11, #1, lsl #48
	mov	x12, #2                         // =0x2
	ccmp	x8, x11, #4, ne
	movk	x12, #65535, lsl #48
	mov	x13, #-281474976710656          // =0xffff000000000000
	ccmp	x8, x12, #4, ne
	and	x14, x22, #0xffff000000000003
	ccmp	x8, x13, #4, ne
	cset	w8, eq
	cmp	x14, x13
	ccmp	x14, x12, #4, ne
	ccmp	x14, x11, #4, ne
	ccmp	x14, x10, #4, ne
	b.ne	.LBB681_19
// %bb.18:                              // %B11
	tbnz	w8, #0, .LBB681_20
.LBB681_19:                             // %B13
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB681_20:                             // %B28
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB681_22
// %bb.21:                              // %B30
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB681_22:                             // %B29
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end681:
	.size	strict_neq_2_asm_h, .Lfunc_end681-strict_neq_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	and_2_asm_h                     // -- Begin function and_2_asm_h
	.p2align	2
	.type	and_2_asm_h,@function
and_2_asm_h:                            // @and_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B32
	ldr	w8, [x24, #336]
	cbz	w8, .LBB682_2
// %bb.1:                               // %B33
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB682_2:                              // %B29
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB682_11
// %bb.3:                               // %B29
	cmp	x21, x8
	b.hi	.LBB682_11
// %bb.4:                               // %B3
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB682_7
// %bb.5:                               // %B20
	cmp	x21, x8
	b.lo	.LBB682_11
// %bb.6:                               // %B25
	mov	w8, w22
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	and	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB682_7:                              // %B5
	tst	x22, #0xfffe000000000000
	b.eq	.LBB682_11
// %bb.8:                               // %B5
	cmp	x21, x8
	b.lo	.LBB682_11
// %bb.9:                               // %B15
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB682_11
// %bb.10:                              // %B16
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	and	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB682_11:                             // %B26
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        // =0xad
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB682_13
// %bb.12:                              // %B28
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB682_13:                             // %B27
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end682:
	.size	and_2_asm_h, .Lfunc_end682-and_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	xor_2_asm_h                     // -- Begin function xor_2_asm_h
	.p2align	2
	.type	xor_2_asm_h,@function
xor_2_asm_h:                            // @xor_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B32
	ldr	w8, [x24, #336]
	cbz	w8, .LBB683_2
// %bb.1:                               // %B33
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB683_2:                              // %B29
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB683_11
// %bb.3:                               // %B29
	cmp	x21, x8
	b.hi	.LBB683_11
// %bb.4:                               // %B3
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB683_7
// %bb.5:                               // %B20
	cmp	x21, x8
	b.lo	.LBB683_11
// %bb.6:                               // %B25
	mov	w8, w22
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	eor	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB683_7:                              // %B5
	tst	x22, #0xfffe000000000000
	b.eq	.LBB683_11
// %bb.8:                               // %B5
	cmp	x21, x8
	b.lo	.LBB683_11
// %bb.9:                               // %B15
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB683_11
// %bb.10:                              // %B16
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	eor	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB683_11:                             // %B26
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        // =0xae
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB683_13
// %bb.12:                              // %B28
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB683_13:                             // %B27
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end683:
	.size	xor_2_asm_h, .Lfunc_end683-xor_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	or_2_asm_h                      // -- Begin function or_2_asm_h
	.p2align	2
	.type	or_2_asm_h,@function
or_2_asm_h:                             // @or_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B32
	ldr	w8, [x24, #336]
	cbz	w8, .LBB684_2
// %bb.1:                               // %B33
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB684_2:                              // %B29
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB684_11
// %bb.3:                               // %B29
	cmp	x21, x8
	b.hi	.LBB684_11
// %bb.4:                               // %B3
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB684_7
// %bb.5:                               // %B20
	cmp	x21, x8
	b.lo	.LBB684_11
// %bb.6:                               // %B25
	mov	w8, w22
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	orr	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB684_7:                              // %B5
	tst	x22, #0xfffe000000000000
	b.eq	.LBB684_11
// %bb.8:                               // %B5
	cmp	x21, x8
	b.lo	.LBB684_11
// %bb.9:                               // %B15
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB684_11
// %bb.10:                              // %B16
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	orr	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB684_11:                             // %B26
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        // =0xaf
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB684_13
// %bb.12:                              // %B28
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB684_13:                             // %B27
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end684:
	.size	or_2_asm_h, .Lfunc_end684-or_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	nop_2_asm_h                     // -- Begin function nop_2_asm_h
	.p2align	2
	.type	nop_2_asm_h,@function
nop_2_asm_h:                            // @nop_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB685_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB685_2:                              // %B1
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end685:
	.size	nop_2_asm_h, .Lfunc_end685-nop_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_minus1_2_asm_h             // -- Begin function push_minus1_2_asm_h
	.p2align	2
	.type	push_minus1_2_asm_h,@function
push_minus1_2_asm_h:                    // @push_minus1_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB686_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB686_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562945658454017          // =0xfffe0000ffffffff
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end686:
	.size	push_minus1_2_asm_h, .Lfunc_end686-push_minus1_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_0_2_asm_h                  // -- Begin function push_0_2_asm_h
	.p2align	2
	.type	push_0_2_asm_h,@function
push_0_2_asm_h:                         // @push_0_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB687_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB687_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421312          // =0xfffe000000000000
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end687:
	.size	push_0_2_asm_h, .Lfunc_end687-push_0_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_1_2_asm_h                  // -- Begin function push_1_2_asm_h
	.p2align	2
	.type	push_1_2_asm_h,@function
push_1_2_asm_h:                         // @push_1_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB688_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB688_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421311          // =0xfffe000000000001
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end688:
	.size	push_1_2_asm_h, .Lfunc_end688-push_1_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_2_2_asm_h                  // -- Begin function push_2_2_asm_h
	.p2align	2
	.type	push_2_2_asm_h,@function
push_2_2_asm_h:                         // @push_2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB689_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB689_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #2                         // =0x2
	movk	x21, #65534, lsl #48
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end689:
	.size	push_2_2_asm_h, .Lfunc_end689-push_2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_3_2_asm_h                  // -- Begin function push_3_2_asm_h
	.p2align	2
	.type	push_3_2_asm_h,@function
push_3_2_asm_h:                         // @push_3_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB690_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB690_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421309          // =0xfffe000000000003
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end690:
	.size	push_3_2_asm_h, .Lfunc_end690-push_3_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_4_2_asm_h                  // -- Begin function push_4_2_asm_h
	.p2align	2
	.type	push_4_2_asm_h,@function
push_4_2_asm_h:                         // @push_4_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB691_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB691_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #4                         // =0x4
	movk	x21, #65534, lsl #48
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end691:
	.size	push_4_2_asm_h, .Lfunc_end691-push_4_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_5_2_asm_h                  // -- Begin function push_5_2_asm_h
	.p2align	2
	.type	push_5_2_asm_h,@function
push_5_2_asm_h:                         // @push_5_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB692_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB692_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #5                         // =0x5
	movk	x21, #65534, lsl #48
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end692:
	.size	push_5_2_asm_h, .Lfunc_end692-push_5_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_6_2_asm_h                  // -- Begin function push_6_2_asm_h
	.p2align	2
	.type	push_6_2_asm_h,@function
push_6_2_asm_h:                         // @push_6_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB693_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB693_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #6                         // =0x6
	movk	x21, #65534, lsl #48
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end693:
	.size	push_6_2_asm_h, .Lfunc_end693-push_6_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_7_2_asm_h                  // -- Begin function push_7_2_asm_h
	.p2align	2
	.type	push_7_2_asm_h,@function
push_7_2_asm_h:                         // @push_7_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB694_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB694_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	mov	x21, #-562949953421305          // =0xfffe000000000007
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end694:
	.size	push_7_2_asm_h, .Lfunc_end694-push_7_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_i8_2_asm_h                 // -- Begin function push_i8_2_asm_h
	.p2align	2
	.type	push_i8_2_asm_h,@function
push_i8_2_asm_h:                        // @push_i8_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB695_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB695_2:                              // %B1
	str	x22, [x20], #8
	mov	x11, #-562949953421312          // =0xfffe000000000000
	ldrsb	x8, [x19]
	ldrb	w10, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	bfxil	x11, x8, #0, #32
	ldr	x0, [x25, x10, lsl #3]
	mov	x21, x11
	br	x0
.Lfunc_end695:
	.size	push_i8_2_asm_h, .Lfunc_end695-push_i8_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_i16_2_asm_h                // -- Begin function push_i16_2_asm_h
	.p2align	2
	.type	push_i16_2_asm_h,@function
push_i16_2_asm_h:                       // @push_i16_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB696_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB696_2:                              // %B1
	str	x22, [x20], #8
	mov	x11, #-562949953421312          // =0xfffe000000000000
	ldrsh	x8, [x19]
	ldrb	w10, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	bfxil	x11, x8, #0, #32
	ldr	x0, [x25, x10, lsl #3]
	mov	x21, x11
	br	x0
.Lfunc_end696:
	.size	push_i16_2_asm_h, .Lfunc_end696-push_i16_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_const8_2_asm_h             // -- Begin function push_const8_2_asm_h
	.p2align	2
	.type	push_const8_2_asm_h,@function
push_const8_2_asm_h:                    // @push_const8_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldr	w8, [x24, #336]
	cbz	w8, .LBB697_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB697_2:                              // %B4
	str	x22, [x20], #8
	ldrb	w8, [x19]
	ldr	w10, [x24, #336]
	ldr	x11, [x23, x8, lsl #3]
	cbz	w10, .LBB697_4
// %bb.3:                               // %B5
	mov	x8, x20
	mov	x0, x24
	mov	x1, x11
	mov	x2, x19
	str	x21, [x8], #8
	str	x8, [x29, #64]
	str	x20, [sp, #8]                   // 8-byte Folded Spill
	mov	x20, x11
	bl	DebuggerPause
	mov	x11, x20
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
.LBB697_4:                              // %B2
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x11
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.Lfunc_end697:
	.size	push_const8_2_asm_h, .Lfunc_end697-push_const8_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	fclosure8_2_asm_h               // -- Begin function fclosure8_2_asm_h
	.p2align	2
	.type	fclosure8_2_asm_h,@function
fclosure8_2_asm_h:                      // @fclosure8_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB698_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB698_2:                              // %B2
	str	x22, [x20]
	mov	x0, x24
	mov	x2, x26
	ldrb	w8, [x19]
	mov	x3, x29
	ldr	x1, [x23, x8, lsl #3]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x29, #64]
	bl	js_closure_gc
	cmp	x0, #130
	b.eq	.LBB698_4
// %bb.3:                               // %B5
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB698_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.Lfunc_end698:
	.size	fclosure8_2_asm_h, .Lfunc_end698-fclosure8_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	push_empty_string_2_asm_h       // -- Begin function push_empty_string_2_asm_h
	.p2align	2
	.type	push_empty_string_2_asm_h,@function
push_empty_string_2_asm_h:              // @push_empty_string_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B6
	ldr	w8, [x24, #336]
	cbz	w8, .LBB699_2
// %bb.1:                               // %B7
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB699_2:                              // %B2
	str	x22, [x20]
	mov	x0, x24
	mov	w1, #47                         // =0x2f
	str	x21, [x20, #8]!
	add	x8, x20, #8
	mov	w2, #1                          // =0x1
	str	x8, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB699_4
// %bb.3:                               // %B5
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB699_4:                              // %B3
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.Lfunc_end699:
	.size	push_empty_string_2_asm_h, .Lfunc_end699-push_empty_string_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc8_2_asm_h                // -- Begin function get_loc8_2_asm_h
	.p2align	2
	.type	get_loc8_2_asm_h,@function
get_loc8_2_asm_h:                       // @get_loc8_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB700_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB700_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19]
	ldrb	w10, [x19, #1]
	add	x19, x19, #2
	ldr	x8, [x27, x8, lsl #3]
	ldr	x0, [x25, x10, lsl #3]
	mov	x21, x8
	br	x0
.Lfunc_end700:
	.size	get_loc8_2_asm_h, .Lfunc_end700-get_loc8_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc8_2_asm_h                // -- Begin function put_loc8_2_asm_h
	.p2align	2
	.type	put_loc8_2_asm_h,@function
put_loc8_2_asm_h:                       // @put_loc8_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB701_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB701_2:                              // %B1
	ldrb	w8, [x19]
	sub	x25, x25, #1936
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end701:
	.size	put_loc8_2_asm_h, .Lfunc_end701-put_loc8_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc8_2_asm_h                // -- Begin function set_loc8_2_asm_h
	.p2align	2
	.type	set_loc8_2_asm_h,@function
set_loc8_2_asm_h:                       // @set_loc8_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB702_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB702_2:                              // %B1
	ldrb	w8, [x19]
	str	x21, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end702:
	.size	set_loc8_2_asm_h, .Lfunc_end702-set_loc8_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc0_2_asm_h                // -- Begin function get_loc0_2_asm_h
	.p2align	2
	.type	get_loc0_2_asm_h,@function
get_loc0_2_asm_h:                       // @get_loc0_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB703_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB703_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x10, [x27]
	ldr	x0, [x25, x8, lsl #3]
	mov	x21, x10
	br	x0
.Lfunc_end703:
	.size	get_loc0_2_asm_h, .Lfunc_end703-get_loc0_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc1_2_asm_h                // -- Begin function get_loc1_2_asm_h
	.p2align	2
	.type	get_loc1_2_asm_h,@function
get_loc1_2_asm_h:                       // @get_loc1_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB704_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB704_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x10, [x27, #8]
	ldr	x0, [x25, x8, lsl #3]
	mov	x21, x10
	br	x0
.Lfunc_end704:
	.size	get_loc1_2_asm_h, .Lfunc_end704-get_loc1_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc2_2_asm_h                // -- Begin function get_loc2_2_asm_h
	.p2align	2
	.type	get_loc2_2_asm_h,@function
get_loc2_2_asm_h:                       // @get_loc2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB705_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB705_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x10, [x27, #16]
	ldr	x0, [x25, x8, lsl #3]
	mov	x21, x10
	br	x0
.Lfunc_end705:
	.size	get_loc2_2_asm_h, .Lfunc_end705-get_loc2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_loc3_2_asm_h                // -- Begin function get_loc3_2_asm_h
	.p2align	2
	.type	get_loc3_2_asm_h,@function
get_loc3_2_asm_h:                       // @get_loc3_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB706_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB706_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x10, [x27, #24]
	ldr	x0, [x25, x8, lsl #3]
	mov	x21, x10
	br	x0
.Lfunc_end706:
	.size	get_loc3_2_asm_h, .Lfunc_end706-get_loc3_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc0_2_asm_h                // -- Begin function put_loc0_2_asm_h
	.p2align	2
	.type	put_loc0_2_asm_h,@function
put_loc0_2_asm_h:                       // @put_loc0_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB707_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB707_2:                              // %B1
	str	x21, [x27]
	sub	x25, x25, #1936
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end707:
	.size	put_loc0_2_asm_h, .Lfunc_end707-put_loc0_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc1_2_asm_h                // -- Begin function put_loc1_2_asm_h
	.p2align	2
	.type	put_loc1_2_asm_h,@function
put_loc1_2_asm_h:                       // @put_loc1_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB708_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB708_2:                              // %B1
	str	x21, [x27, #8]
	sub	x25, x25, #1936
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end708:
	.size	put_loc1_2_asm_h, .Lfunc_end708-put_loc1_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc2_2_asm_h                // -- Begin function put_loc2_2_asm_h
	.p2align	2
	.type	put_loc2_2_asm_h,@function
put_loc2_2_asm_h:                       // @put_loc2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB709_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB709_2:                              // %B1
	str	x21, [x27, #16]
	sub	x25, x25, #1936
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end709:
	.size	put_loc2_2_asm_h, .Lfunc_end709-put_loc2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_loc3_2_asm_h                // -- Begin function put_loc3_2_asm_h
	.p2align	2
	.type	put_loc3_2_asm_h,@function
put_loc3_2_asm_h:                       // @put_loc3_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB710_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB710_2:                              // %B1
	str	x21, [x27, #24]
	sub	x25, x25, #1936
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end710:
	.size	put_loc3_2_asm_h, .Lfunc_end710-put_loc3_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc0_2_asm_h                // -- Begin function set_loc0_2_asm_h
	.p2align	2
	.type	set_loc0_2_asm_h,@function
set_loc0_2_asm_h:                       // @set_loc0_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB711_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB711_2:                              // %B1
	str	x21, [x27]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end711:
	.size	set_loc0_2_asm_h, .Lfunc_end711-set_loc0_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc1_2_asm_h                // -- Begin function set_loc1_2_asm_h
	.p2align	2
	.type	set_loc1_2_asm_h,@function
set_loc1_2_asm_h:                       // @set_loc1_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB712_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB712_2:                              // %B1
	str	x21, [x27, #8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end712:
	.size	set_loc1_2_asm_h, .Lfunc_end712-set_loc1_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc2_2_asm_h                // -- Begin function set_loc2_2_asm_h
	.p2align	2
	.type	set_loc2_2_asm_h,@function
set_loc2_2_asm_h:                       // @set_loc2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB713_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB713_2:                              // %B1
	str	x21, [x27, #16]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end713:
	.size	set_loc2_2_asm_h, .Lfunc_end713-set_loc2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_loc3_2_asm_h                // -- Begin function set_loc3_2_asm_h
	.p2align	2
	.type	set_loc3_2_asm_h,@function
set_loc3_2_asm_h:                       // @set_loc3_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB714_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB714_2:                              // %B1
	str	x21, [x27, #24]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end714:
	.size	set_loc3_2_asm_h, .Lfunc_end714-set_loc3_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_arg0_2_asm_h                // -- Begin function get_arg0_2_asm_h
	.p2align	2
	.type	get_arg0_2_asm_h,@function
get_arg0_2_asm_h:                       // @get_arg0_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB715_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB715_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x10, [x28]
	ldr	x0, [x25, x8, lsl #3]
	mov	x21, x10
	br	x0
.Lfunc_end715:
	.size	get_arg0_2_asm_h, .Lfunc_end715-get_arg0_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_arg1_2_asm_h                // -- Begin function get_arg1_2_asm_h
	.p2align	2
	.type	get_arg1_2_asm_h,@function
get_arg1_2_asm_h:                       // @get_arg1_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB716_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB716_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x10, [x28, #8]
	ldr	x0, [x25, x8, lsl #3]
	mov	x21, x10
	br	x0
.Lfunc_end716:
	.size	get_arg1_2_asm_h, .Lfunc_end716-get_arg1_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_arg2_2_asm_h                // -- Begin function get_arg2_2_asm_h
	.p2align	2
	.type	get_arg2_2_asm_h,@function
get_arg2_2_asm_h:                       // @get_arg2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB717_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB717_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x10, [x28, #16]
	ldr	x0, [x25, x8, lsl #3]
	mov	x21, x10
	br	x0
.Lfunc_end717:
	.size	get_arg2_2_asm_h, .Lfunc_end717-get_arg2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_arg3_2_asm_h                // -- Begin function get_arg3_2_asm_h
	.p2align	2
	.type	get_arg3_2_asm_h,@function
get_arg3_2_asm_h:                       // @get_arg3_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB718_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB718_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19], #1
	ldr	x10, [x28, #24]
	ldr	x0, [x25, x8, lsl #3]
	mov	x21, x10
	br	x0
.Lfunc_end718:
	.size	get_arg3_2_asm_h, .Lfunc_end718-get_arg3_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_arg0_2_asm_h                // -- Begin function put_arg0_2_asm_h
	.p2align	2
	.type	put_arg0_2_asm_h,@function
put_arg0_2_asm_h:                       // @put_arg0_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB719_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB719_2:                              // %B1
	str	x21, [x28]
	sub	x25, x25, #1936
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end719:
	.size	put_arg0_2_asm_h, .Lfunc_end719-put_arg0_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_arg1_2_asm_h                // -- Begin function put_arg1_2_asm_h
	.p2align	2
	.type	put_arg1_2_asm_h,@function
put_arg1_2_asm_h:                       // @put_arg1_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB720_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB720_2:                              // %B1
	str	x21, [x28, #8]
	sub	x25, x25, #1936
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end720:
	.size	put_arg1_2_asm_h, .Lfunc_end720-put_arg1_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_arg2_2_asm_h                // -- Begin function put_arg2_2_asm_h
	.p2align	2
	.type	put_arg2_2_asm_h,@function
put_arg2_2_asm_h:                       // @put_arg2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB721_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB721_2:                              // %B1
	str	x21, [x28, #16]
	sub	x25, x25, #1936
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end721:
	.size	put_arg2_2_asm_h, .Lfunc_end721-put_arg2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_arg3_2_asm_h                // -- Begin function put_arg3_2_asm_h
	.p2align	2
	.type	put_arg3_2_asm_h,@function
put_arg3_2_asm_h:                       // @put_arg3_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB722_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB722_2:                              // %B1
	str	x21, [x28, #24]
	sub	x25, x25, #1936
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end722:
	.size	put_arg3_2_asm_h, .Lfunc_end722-put_arg3_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_arg0_2_asm_h                // -- Begin function set_arg0_2_asm_h
	.p2align	2
	.type	set_arg0_2_asm_h,@function
set_arg0_2_asm_h:                       // @set_arg0_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB723_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB723_2:                              // %B1
	str	x21, [x28]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end723:
	.size	set_arg0_2_asm_h, .Lfunc_end723-set_arg0_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_arg1_2_asm_h                // -- Begin function set_arg1_2_asm_h
	.p2align	2
	.type	set_arg1_2_asm_h,@function
set_arg1_2_asm_h:                       // @set_arg1_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB724_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB724_2:                              // %B1
	str	x21, [x28, #8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end724:
	.size	set_arg1_2_asm_h, .Lfunc_end724-set_arg1_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_arg2_2_asm_h                // -- Begin function set_arg2_2_asm_h
	.p2align	2
	.type	set_arg2_2_asm_h,@function
set_arg2_2_asm_h:                       // @set_arg2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB725_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB725_2:                              // %B1
	str	x21, [x28, #16]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end725:
	.size	set_arg2_2_asm_h, .Lfunc_end725-set_arg2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_arg3_2_asm_h                // -- Begin function set_arg3_2_asm_h
	.p2align	2
	.type	set_arg3_2_asm_h,@function
set_arg3_2_asm_h:                       // @set_arg3_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB726_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB726_2:                              // %B1
	str	x21, [x28, #24]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end726:
	.size	set_arg3_2_asm_h, .Lfunc_end726-set_arg3_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref0_2_asm_h            // -- Begin function get_var_ref0_2_asm_h
	.p2align	2
	.type	get_var_ref0_2_asm_h,@function
get_var_ref0_2_asm_h:                   // @get_var_ref0_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB727_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB727_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x26]
	ldrb	w10, [x19], #1
	ldr	x8, [x8, #32]
	ldr	x0, [x25, x10, lsl #3]
	ldr	x8, [x8]
	mov	x21, x8
	br	x0
.Lfunc_end727:
	.size	get_var_ref0_2_asm_h, .Lfunc_end727-get_var_ref0_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref1_2_asm_h            // -- Begin function get_var_ref1_2_asm_h
	.p2align	2
	.type	get_var_ref1_2_asm_h,@function
get_var_ref1_2_asm_h:                   // @get_var_ref1_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB728_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB728_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x26, #8]
	ldrb	w10, [x19], #1
	ldr	x8, [x8, #32]
	ldr	x0, [x25, x10, lsl #3]
	ldr	x8, [x8]
	mov	x21, x8
	br	x0
.Lfunc_end728:
	.size	get_var_ref1_2_asm_h, .Lfunc_end728-get_var_ref1_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref2_2_asm_h            // -- Begin function get_var_ref2_2_asm_h
	.p2align	2
	.type	get_var_ref2_2_asm_h,@function
get_var_ref2_2_asm_h:                   // @get_var_ref2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB729_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB729_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x26, #16]
	ldrb	w10, [x19], #1
	ldr	x8, [x8, #32]
	ldr	x0, [x25, x10, lsl #3]
	ldr	x8, [x8]
	mov	x21, x8
	br	x0
.Lfunc_end729:
	.size	get_var_ref2_2_asm_h, .Lfunc_end729-get_var_ref2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_var_ref3_2_asm_h            // -- Begin function get_var_ref3_2_asm_h
	.p2align	2
	.type	get_var_ref3_2_asm_h,@function
get_var_ref3_2_asm_h:                   // @get_var_ref3_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB730_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB730_2:                              // %B1
	str	x22, [x20], #8
	mov	x22, x21
	ldr	x8, [x26, #24]
	ldrb	w10, [x19], #1
	ldr	x8, [x8, #32]
	ldr	x0, [x25, x10, lsl #3]
	ldr	x8, [x8]
	mov	x21, x8
	br	x0
.Lfunc_end730:
	.size	get_var_ref3_2_asm_h, .Lfunc_end730-get_var_ref3_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref0_2_asm_h            // -- Begin function put_var_ref0_2_asm_h
	.p2align	2
	.type	put_var_ref0_2_asm_h,@function
put_var_ref0_2_asm_h:                   // @put_var_ref0_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB731_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB731_2:                              // %B1
	ldr	x8, [x26]
	sub	x25, x25, #1936
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end731:
	.size	put_var_ref0_2_asm_h, .Lfunc_end731-put_var_ref0_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref1_2_asm_h            // -- Begin function put_var_ref1_2_asm_h
	.p2align	2
	.type	put_var_ref1_2_asm_h,@function
put_var_ref1_2_asm_h:                   // @put_var_ref1_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB732_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB732_2:                              // %B1
	ldr	x8, [x26, #8]
	sub	x25, x25, #1936
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end732:
	.size	put_var_ref1_2_asm_h, .Lfunc_end732-put_var_ref1_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref2_2_asm_h            // -- Begin function put_var_ref2_2_asm_h
	.p2align	2
	.type	put_var_ref2_2_asm_h,@function
put_var_ref2_2_asm_h:                   // @put_var_ref2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB733_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB733_2:                              // %B1
	ldr	x8, [x26, #16]
	sub	x25, x25, #1936
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end733:
	.size	put_var_ref2_2_asm_h, .Lfunc_end733-put_var_ref2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	put_var_ref3_2_asm_h            // -- Begin function put_var_ref3_2_asm_h
	.p2align	2
	.type	put_var_ref3_2_asm_h,@function
put_var_ref3_2_asm_h:                   // @put_var_ref3_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB734_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB734_2:                              // %B1
	ldr	x8, [x26, #24]
	sub	x25, x25, #1936
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end734:
	.size	put_var_ref3_2_asm_h, .Lfunc_end734-put_var_ref3_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_var_ref0_2_asm_h            // -- Begin function set_var_ref0_2_asm_h
	.p2align	2
	.type	set_var_ref0_2_asm_h,@function
set_var_ref0_2_asm_h:                   // @set_var_ref0_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB735_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB735_2:                              // %B1
	ldr	x8, [x26]
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end735:
	.size	set_var_ref0_2_asm_h, .Lfunc_end735-set_var_ref0_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_var_ref1_2_asm_h            // -- Begin function set_var_ref1_2_asm_h
	.p2align	2
	.type	set_var_ref1_2_asm_h,@function
set_var_ref1_2_asm_h:                   // @set_var_ref1_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB736_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB736_2:                              // %B1
	ldr	x8, [x26, #8]
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end736:
	.size	set_var_ref1_2_asm_h, .Lfunc_end736-set_var_ref1_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_var_ref2_2_asm_h            // -- Begin function set_var_ref2_2_asm_h
	.p2align	2
	.type	set_var_ref2_2_asm_h,@function
set_var_ref2_2_asm_h:                   // @set_var_ref2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB737_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB737_2:                              // %B1
	ldr	x8, [x26, #16]
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end737:
	.size	set_var_ref2_2_asm_h, .Lfunc_end737-set_var_ref2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	set_var_ref3_2_asm_h            // -- Begin function set_var_ref3_2_asm_h
	.p2align	2
	.type	set_var_ref3_2_asm_h,@function
set_var_ref3_2_asm_h:                   // @set_var_ref3_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB738_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB738_2:                              // %B1
	ldr	x8, [x26, #24]
	ldr	x8, [x8, #32]
	str	x21, [x8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end738:
	.size	set_var_ref3_2_asm_h, .Lfunc_end738-set_var_ref3_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	get_length_2_asm_h              // -- Begin function get_length_2_asm_h
	.p2align	2
	.type	get_length_2_asm_h,@function
get_length_2_asm_h:                     // @get_length_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B9
	ldr	w8, [x24, #336]
	cbz	w8, .LBB739_2
// %bb.1:                               // %B10
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB739_2:                              // %B2
	mov	w9, #48                         // =0x30
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB739_4
.LBB739_3:                              // %B8
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB739_4:                              // %B4
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #48                         // =0x30
	mov	x3, x21
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.ne	.LBB739_3
// %bb.5:                               // %B5
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.Lfunc_end739:
	.size	get_length_2_asm_h, .Lfunc_end739-get_length_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	if_false8_2_asm_h               // -- Begin function if_false8_2_asm_h
	.p2align	2
	.type	if_false8_2_asm_h,@function
if_false8_2_asm_h:                      // @if_false8_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B27
	ldr	w8, [x24, #336]
	cbz	w8, .LBB740_2
// %bb.1:                               // %B28
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB740_2:                              // %B24
	cmp	x21, #5
	b.le	.LBB740_6
// %bb.3:                               // %B24
	cmp	x21, #6
	b.eq	.LBB740_8
// %bb.4:                               // %B24
	cmp	x21, #7
	b.eq	.LBB740_11
// %bb.5:                               // %B24
	cmp	x21, #18
	b.eq	.LBB740_8
	b	.LBB740_9
.LBB740_6:                              // %B24
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB740_8
// %bb.7:                               // %B24
	cmp	x21, #2
	b.ne	.LBB740_9
.LBB740_8:                              // %B4
	ldrsb	x8, [x19]
	sub	x25, x25, #1936
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB740_9:                              // %B10
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x21, x8
	b.hs	.LBB740_15
// %bb.10:                              // %B12
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB740_12
.LBB740_11:                             // %B20
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB740_12:                             // %B14
	tst	x21, #0xfffe000000000000
	b.eq	.LBB740_15
// %bb.13:                              // %B18
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB740_8
	b.vs	.LBB740_8
// %bb.14:                              // %B18
	tbnz	w8, #0, .LBB740_11
	b	.LBB740_8
.LBB740_15:                             // %B16
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	mov	x9, x21
	b	SlowToBoolean_asm_h
.Lfunc_end740:
	.size	if_false8_2_asm_h, .Lfunc_end740-if_false8_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	if_true8_2_asm_h                // -- Begin function if_true8_2_asm_h
	.p2align	2
	.type	if_true8_2_asm_h,@function
if_true8_2_asm_h:                       // @if_true8_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B27
	ldr	w8, [x24, #336]
	cbz	w8, .LBB741_2
// %bb.1:                               // %B28
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB741_2:                              // %B24
	cmp	x21, #5
	b.le	.LBB741_6
// %bb.3:                               // %B24
	cmp	x21, #6
	b.eq	.LBB741_8
// %bb.4:                               // %B24
	cmp	x21, #7
	b.eq	.LBB741_11
// %bb.5:                               // %B24
	cmp	x21, #18
	b.eq	.LBB741_8
	b	.LBB741_9
.LBB741_6:                              // %B24
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB741_8
// %bb.7:                               // %B24
	cmp	x21, #2
	b.ne	.LBB741_9
.LBB741_8:                              // %B4
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB741_9:                              // %B10
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x21, x8
	b.hs	.LBB741_15
// %bb.10:                              // %B12
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB741_12
.LBB741_11:                             // %B20
	ldrsb	x8, [x19]
	sub	x25, x25, #1936
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB741_12:                             // %B14
	tst	x21, #0xfffe000000000000
	b.eq	.LBB741_15
// %bb.13:                              // %B18
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB741_8
	b.vs	.LBB741_8
// %bb.14:                              // %B18
	tbnz	w8, #0, .LBB741_11
	b	.LBB741_8
.LBB741_15:                             // %B16
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	mov	x9, x21
	b	SlowToBoolean_asm_h
.Lfunc_end741:
	.size	if_true8_2_asm_h, .Lfunc_end741-if_true8_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	goto8_2_asm_h                   // -- Begin function goto8_2_asm_h
	.p2align	2
	.type	goto8_2_asm_h,@function
goto8_2_asm_h:                          // @goto8_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB742_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB742_2:                              // %B1
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end742:
	.size	goto8_2_asm_h, .Lfunc_end742-goto8_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	goto16_2_asm_h                  // -- Begin function goto16_2_asm_h
	.p2align	2
	.type	goto16_2_asm_h,@function
goto16_2_asm_h:                         // @goto16_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB743_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB743_2:                              // %B1
	ldrsh	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end743:
	.size	goto16_2_asm_h, .Lfunc_end743-goto16_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call0_2_asm_h                   // -- Begin function call0_2_asm_h
	.p2align	2
	.type	call0_2_asm_h,@function
call0_2_asm_h:                          // @call0_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB744_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB744_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	call0_0_asm_h
.Lfunc_end744:
	.size	call0_2_asm_h, .Lfunc_end744-call0_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call1_2_asm_h                   // -- Begin function call1_2_asm_h
	.p2align	2
	.type	call1_2_asm_h,@function
call1_2_asm_h:                          // @call1_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB745_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB745_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	call1_0_asm_h
.Lfunc_end745:
	.size	call1_2_asm_h, .Lfunc_end745-call1_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call2_2_asm_h                   // -- Begin function call2_2_asm_h
	.p2align	2
	.type	call2_2_asm_h,@function
call2_2_asm_h:                          // @call2_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB746_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB746_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	call2_0_asm_h
.Lfunc_end746:
	.size	call2_2_asm_h, .Lfunc_end746-call2_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	call3_2_asm_h                   // -- Begin function call3_2_asm_h
	.p2align	2
	.type	call3_2_asm_h,@function
call3_2_asm_h:                          // @call3_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B3
	ldr	w8, [x24, #336]
	cbz	w8, .LBB747_2
// %bb.1:                               // %B4
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB747_2:                              // %B1
	mov	x8, x20
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
	b	call3_0_asm_h
.Lfunc_end747:
	.size	call3_2_asm_h, .Lfunc_end747-call3_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	is_undefined_2_asm_h            // -- Begin function is_undefined_2_asm_h
	.p2align	2
	.type	is_undefined_2_asm_h,@function
is_undefined_2_asm_h:                   // @is_undefined_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	ldr	w8, [x24, #336]
	cbz	w8, .LBB748_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB748_2:                              // %B3
	cmp	x21, #18
	b.ne	.LBB748_4
// %bb.3:                               // %B4
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB748_4:                              // %B6
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end748:
	.size	is_undefined_2_asm_h, .Lfunc_end748-is_undefined_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	is_null_2_asm_h                 // -- Begin function is_null_2_asm_h
	.p2align	2
	.type	is_null_2_asm_h,@function
is_null_2_asm_h:                        // @is_null_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	ldr	w8, [x24, #336]
	cbz	w8, .LBB749_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB749_2:                              // %B3
	cmp	x21, #2
	b.ne	.LBB749_4
// %bb.3:                               // %B4
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB749_4:                              // %B6
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end749:
	.size	is_null_2_asm_h, .Lfunc_end749-is_null_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	is_function_2_asm_h             // -- Begin function is_function_2_asm_h
	.p2align	2
	.type	is_function_2_asm_h,@function
is_function_2_asm_h:                    // @is_function_2_asm_h
	.cfi_startproc
// %bb.0:                               // %B7
	ldr	w8, [x24, #336]
	cbz	w8, .LBB750_2
// %bb.1:                               // %B8
	ldr	x8, [x29, #8]
	mov	x0, x24
	mov	x1, x19
	ldr	x2, [x8, #48]
	str	x20, [x29, #64]
	bl	DebuggerCallEachOp
.LBB750_2:                              // %B2
	mov	x0, x24
	mov	x1, x21
	bl	js_operator_typeof_gc
	cmp	w0, #27
	b.ne	.LBB750_4
// %bb.3:                               // %B3
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB750_4:                              // %B6
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.Lfunc_end750:
	.size	is_function_2_asm_h, .Lfunc_end750-is_function_2_asm_h
	.cfi_endproc
                                        // -- End function
	.globl	InstallBcHandler                // -- Begin function InstallBcHandler
	.p2align	2
	.type	InstallBcHandler,@function
InstallBcHandler:                       // @InstallBcHandler
	.cfi_startproc
// %bb.0:                               // %B0
	adrp	x8, :got:invalid_0_asm_h
	adrp	x10, :got:push_i32_0_asm_h
	adrp	x11, :got:push_const_0_asm_h
	ldr	x8, [x8, :got_lo12:invalid_0_asm_h]
	ldr	x10, [x10, :got_lo12:push_i32_0_asm_h]
	ldr	x11, [x11, :got_lo12:push_const_0_asm_h]
	stp	x8, x10, [x0]
	adrp	x8, :got:fclosure_0_asm_h
	adrp	x10, :got:push_atom_value_0_asm_h
	ldr	x8, [x8, :got_lo12:fclosure_0_asm_h]
	ldr	x10, [x10, :got_lo12:push_atom_value_0_asm_h]
	stp	x11, x8, [x0, #16]
	adrp	x8, :got:private_symbol_0_asm_h
	adrp	x11, :got:undefined_0_asm_h
	ldr	x8, [x8, :got_lo12:private_symbol_0_asm_h]
	ldr	x11, [x11, :got_lo12:undefined_0_asm_h]
	stp	x10, x8, [x0, #32]
	adrp	x8, :got:null_0_asm_h
	adrp	x10, :got:push_this_0_asm_h
	ldr	x8, [x8, :got_lo12:null_0_asm_h]
	ldr	x10, [x10, :got_lo12:push_this_0_asm_h]
	stp	x11, x8, [x0, #48]
	adrp	x8, :got:push_false_0_asm_h
	adrp	x11, :got:push_true_0_asm_h
	ldr	x8, [x8, :got_lo12:push_false_0_asm_h]
	ldr	x11, [x11, :got_lo12:push_true_0_asm_h]
	stp	x10, x8, [x0, #64]
	adrp	x8, :got:object_0_asm_h
	adrp	x10, :got:special_object_0_asm_h
	ldr	x8, [x8, :got_lo12:object_0_asm_h]
	ldr	x10, [x10, :got_lo12:special_object_0_asm_h]
	stp	x11, x8, [x0, #80]
	adrp	x8, :got:rest_0_asm_h
	adrp	x11, :got:drop_0_asm_h
	ldr	x8, [x8, :got_lo12:rest_0_asm_h]
	ldr	x11, [x11, :got_lo12:drop_0_asm_h]
	stp	x10, x8, [x0, #96]
	adrp	x8, :got:nip_0_asm_h
	adrp	x10, :got:nip1_0_asm_h
	ldr	x8, [x8, :got_lo12:nip_0_asm_h]
	ldr	x10, [x10, :got_lo12:nip1_0_asm_h]
	stp	x11, x8, [x0, #112]
	adrp	x8, :got:dup_0_asm_h
	adrp	x11, :got:dup1_0_asm_h
	ldr	x8, [x8, :got_lo12:dup_0_asm_h]
	ldr	x11, [x11, :got_lo12:dup1_0_asm_h]
	stp	x10, x8, [x0, #128]
	adrp	x8, :got:dup2_0_asm_h
	adrp	x10, :got:dup3_0_asm_h
	ldr	x8, [x8, :got_lo12:dup2_0_asm_h]
	ldr	x10, [x10, :got_lo12:dup3_0_asm_h]
	stp	x11, x8, [x0, #144]
	adrp	x8, :got:insert2_0_asm_h
	adrp	x11, :got:insert3_0_asm_h
	ldr	x8, [x8, :got_lo12:insert2_0_asm_h]
	ldr	x11, [x11, :got_lo12:insert3_0_asm_h]
	stp	x10, x8, [x0, #160]
	adrp	x8, :got:insert4_0_asm_h
	adrp	x10, :got:perm3_0_asm_h
	ldr	x8, [x8, :got_lo12:insert4_0_asm_h]
	ldr	x10, [x10, :got_lo12:perm3_0_asm_h]
	stp	x11, x8, [x0, #176]
	adrp	x8, :got:perm4_0_asm_h
	adrp	x11, :got:perm5_0_asm_h
	ldr	x8, [x8, :got_lo12:perm4_0_asm_h]
	ldr	x11, [x11, :got_lo12:perm5_0_asm_h]
	stp	x10, x8, [x0, #192]
	adrp	x8, :got:swap_0_asm_h
	adrp	x10, :got:swap2_0_asm_h
	ldr	x8, [x8, :got_lo12:swap_0_asm_h]
	ldr	x10, [x10, :got_lo12:swap2_0_asm_h]
	stp	x11, x8, [x0, #208]
	adrp	x8, :got:rot3l_0_asm_h
	adrp	x11, :got:rot3r_0_asm_h
	ldr	x8, [x8, :got_lo12:rot3l_0_asm_h]
	ldr	x11, [x11, :got_lo12:rot3r_0_asm_h]
	stp	x10, x8, [x0, #224]
	adrp	x8, :got:rot4l_0_asm_h
	adrp	x10, :got:rot5l_0_asm_h
	ldr	x8, [x8, :got_lo12:rot4l_0_asm_h]
	ldr	x10, [x10, :got_lo12:rot5l_0_asm_h]
	stp	x11, x8, [x0, #240]
	adrp	x8, :got:call_constructor_0_asm_h
	adrp	x11, :got:call_0_asm_h
	ldr	x8, [x8, :got_lo12:call_constructor_0_asm_h]
	ldr	x11, [x11, :got_lo12:call_0_asm_h]
	stp	x10, x8, [x0, #256]
	adrp	x8, :got:tail_call_0_asm_h
	adrp	x10, :got:call_method_0_asm_h
	ldr	x8, [x8, :got_lo12:tail_call_0_asm_h]
	ldr	x10, [x10, :got_lo12:call_method_0_asm_h]
	stp	x11, x8, [x0, #272]
	adrp	x8, :got:tail_call_method_0_asm_h
	adrp	x11, :got:array_from_0_asm_h
	ldr	x8, [x8, :got_lo12:tail_call_method_0_asm_h]
	ldr	x11, [x11, :got_lo12:array_from_0_asm_h]
	stp	x10, x8, [x0, #288]
	adrp	x8, :got:apply_0_asm_h
	adrp	x10, :got:return_0_asm_h
	ldr	x8, [x8, :got_lo12:apply_0_asm_h]
	ldr	x10, [x10, :got_lo12:return_0_asm_h]
	stp	x11, x8, [x0, #304]
	adrp	x8, :got:return_undef_0_asm_h
	adrp	x11, :got:check_ctor_return_0_asm_h
	ldr	x8, [x8, :got_lo12:return_undef_0_asm_h]
	ldr	x11, [x11, :got_lo12:check_ctor_return_0_asm_h]
	stp	x10, x8, [x0, #320]
	adrp	x8, :got:check_ctor_0_asm_h
	adrp	x10, :got:check_brand_0_asm_h
	ldr	x8, [x8, :got_lo12:check_ctor_0_asm_h]
	ldr	x10, [x10, :got_lo12:check_brand_0_asm_h]
	stp	x11, x8, [x0, #336]
	adrp	x8, :got:add_brand_0_asm_h
	adrp	x11, :got:return_async_0_asm_h
	ldr	x8, [x8, :got_lo12:add_brand_0_asm_h]
	ldr	x11, [x11, :got_lo12:return_async_0_asm_h]
	stp	x10, x8, [x0, #352]
	adrp	x8, :got:throw_0_asm_h
	adrp	x10, :got:throw_var_0_asm_h
	ldr	x8, [x8, :got_lo12:throw_0_asm_h]
	ldr	x10, [x10, :got_lo12:throw_var_0_asm_h]
	stp	x11, x8, [x0, #368]
	adrp	x8, :got:eval_0_asm_h
	adrp	x11, :got:regexp_0_asm_h
	ldr	x8, [x8, :got_lo12:eval_0_asm_h]
	ldr	x11, [x11, :got_lo12:regexp_0_asm_h]
	stp	x10, x8, [x0, #384]
	adrp	x8, :got:get_super_ctor_0_asm_h
	adrp	x10, :got:get_super_0_asm_h
	ldr	x8, [x8, :got_lo12:get_super_ctor_0_asm_h]
	ldr	x10, [x10, :got_lo12:get_super_0_asm_h]
	stp	x11, x8, [x0, #400]
	adrp	x8, :got:import_0_asm_h
	adrp	x11, :got:check_var_0_asm_h
	ldr	x8, [x8, :got_lo12:import_0_asm_h]
	ldr	x11, [x11, :got_lo12:check_var_0_asm_h]
	stp	x10, x8, [x0, #416]
	adrp	x8, :got:get_var_undef_0_asm_h
	adrp	x10, :got:get_var_0_asm_h
	ldr	x8, [x8, :got_lo12:get_var_undef_0_asm_h]
	ldr	x10, [x10, :got_lo12:get_var_0_asm_h]
	stp	x11, x8, [x0, #432]
	adrp	x8, :got:put_var_0_asm_h
	adrp	x11, :got:put_var_init_0_asm_h
	ldr	x8, [x8, :got_lo12:put_var_0_asm_h]
	ldr	x11, [x11, :got_lo12:put_var_init_0_asm_h]
	stp	x10, x8, [x0, #448]
	adrp	x8, :got:put_var_strict_0_asm_h
	adrp	x10, :got:get_ref_value_0_asm_h
	ldr	x8, [x8, :got_lo12:put_var_strict_0_asm_h]
	ldr	x10, [x10, :got_lo12:get_ref_value_0_asm_h]
	stp	x11, x8, [x0, #464]
	adrp	x8, :got:put_ref_value_0_asm_h
	adrp	x11, :got:define_var_0_asm_h
	ldr	x8, [x8, :got_lo12:put_ref_value_0_asm_h]
	ldr	x11, [x11, :got_lo12:define_var_0_asm_h]
	stp	x10, x8, [x0, #480]
	adrp	x8, :got:check_define_var_0_asm_h
	adrp	x10, :got:define_func_0_asm_h
	ldr	x8, [x8, :got_lo12:check_define_var_0_asm_h]
	ldr	x10, [x10, :got_lo12:define_func_0_asm_h]
	stp	x11, x8, [x0, #496]
	adrp	x8, :got:get_field_0_asm_h
	ldr	x8, [x8, :got_lo12:get_field_0_asm_h]
	str	x10, [x0, #512]
	adrp	x10, :got:get_field2_0_asm_h
	ldr	x10, [x10, :got_lo12:get_field2_0_asm_h]
	str	x8, [x0, #520]
	adrp	x8, :got:put_field_0_asm_h
	ldr	x8, [x8, :got_lo12:put_field_0_asm_h]
	str	x10, [x0, #528]
	adrp	x10, :got:get_private_field_0_asm_h
	ldr	x10, [x10, :got_lo12:get_private_field_0_asm_h]
	str	x8, [x0, #536]
	adrp	x8, :got:put_private_field_0_asm_h
	ldr	x8, [x8, :got_lo12:put_private_field_0_asm_h]
	str	x10, [x0, #544]
	adrp	x10, :got:define_private_field_0_asm_h
	ldr	x10, [x10, :got_lo12:define_private_field_0_asm_h]
	str	x8, [x0, #552]
	adrp	x8, :got:get_array_el_0_asm_h
	ldr	x8, [x8, :got_lo12:get_array_el_0_asm_h]
	str	x10, [x0, #560]
	adrp	x10, :got:get_array_el2_0_asm_h
	ldr	x10, [x10, :got_lo12:get_array_el2_0_asm_h]
	str	x8, [x0, #568]
	adrp	x8, :got:put_array_el_0_asm_h
	ldr	x8, [x8, :got_lo12:put_array_el_0_asm_h]
	str	x10, [x0, #576]
	adrp	x10, :got:get_super_value_0_asm_h
	ldr	x10, [x10, :got_lo12:get_super_value_0_asm_h]
	str	x8, [x0, #584]
	adrp	x8, :got:put_super_value_0_asm_h
	ldr	x8, [x8, :got_lo12:put_super_value_0_asm_h]
	str	x10, [x0, #592]
	adrp	x10, :got:define_field_0_asm_h
	ldr	x10, [x10, :got_lo12:define_field_0_asm_h]
	str	x8, [x0, #600]
	adrp	x8, :got:set_name_0_asm_h
	ldr	x8, [x8, :got_lo12:set_name_0_asm_h]
	str	x10, [x0, #608]
	adrp	x10, :got:set_name_computed_0_asm_h
	ldr	x10, [x10, :got_lo12:set_name_computed_0_asm_h]
	str	x8, [x0, #616]
	adrp	x8, :got:set_proto_0_asm_h
	ldr	x8, [x8, :got_lo12:set_proto_0_asm_h]
	str	x10, [x0, #624]
	adrp	x10, :got:set_home_object_0_asm_h
	ldr	x10, [x10, :got_lo12:set_home_object_0_asm_h]
	str	x8, [x0, #632]
	adrp	x8, :got:define_array_el_0_asm_h
	ldr	x8, [x8, :got_lo12:define_array_el_0_asm_h]
	str	x10, [x0, #640]
	adrp	x10, :got:append_0_asm_h
	ldr	x10, [x10, :got_lo12:append_0_asm_h]
	str	x8, [x0, #648]
	adrp	x8, :got:copy_data_properties_0_asm_h
	ldr	x8, [x8, :got_lo12:copy_data_properties_0_asm_h]
	str	x10, [x0, #656]
	adrp	x10, :got:define_method_0_asm_h
	ldr	x10, [x10, :got_lo12:define_method_0_asm_h]
	str	x8, [x0, #664]
	adrp	x8, :got:define_method_computed_0_asm_h
	ldr	x8, [x8, :got_lo12:define_method_computed_0_asm_h]
	str	x10, [x0, #672]
	adrp	x10, :got:define_class_0_asm_h
	ldr	x10, [x10, :got_lo12:define_class_0_asm_h]
	str	x8, [x0, #680]
	adrp	x8, :got:get_loc_0_asm_h
	ldr	x8, [x8, :got_lo12:get_loc_0_asm_h]
	str	x10, [x0, #688]
	adrp	x10, :got:put_loc_0_asm_h
	ldr	x10, [x10, :got_lo12:put_loc_0_asm_h]
	str	x8, [x0, #696]
	adrp	x8, :got:set_loc_0_asm_h
	ldr	x8, [x8, :got_lo12:set_loc_0_asm_h]
	str	x10, [x0, #704]
	adrp	x10, :got:get_arg_0_asm_h
	ldr	x10, [x10, :got_lo12:get_arg_0_asm_h]
	str	x8, [x0, #712]
	adrp	x8, :got:put_arg_0_asm_h
	ldr	x8, [x8, :got_lo12:put_arg_0_asm_h]
	str	x10, [x0, #720]
	adrp	x10, :got:set_arg_0_asm_h
	ldr	x10, [x10, :got_lo12:set_arg_0_asm_h]
	str	x8, [x0, #728]
	adrp	x8, :got:get_var_ref_0_asm_h
	ldr	x8, [x8, :got_lo12:get_var_ref_0_asm_h]
	str	x10, [x0, #736]
	adrp	x10, :got:put_var_ref_0_asm_h
	ldr	x10, [x10, :got_lo12:put_var_ref_0_asm_h]
	str	x8, [x0, #744]
	adrp	x8, :got:set_var_ref_0_asm_h
	ldr	x8, [x8, :got_lo12:set_var_ref_0_asm_h]
	str	x10, [x0, #752]
	adrp	x10, :got:set_loc_uninitialized_0_asm_h
	ldr	x10, [x10, :got_lo12:set_loc_uninitialized_0_asm_h]
	str	x8, [x0, #760]
	adrp	x8, :got:get_loc_check_0_asm_h
	ldr	x8, [x8, :got_lo12:get_loc_check_0_asm_h]
	str	x10, [x0, #768]
	adrp	x10, :got:put_loc_check_0_asm_h
	ldr	x10, [x10, :got_lo12:put_loc_check_0_asm_h]
	str	x8, [x0, #776]
	adrp	x8, :got:put_loc_check_init_0_asm_h
	ldr	x8, [x8, :got_lo12:put_loc_check_init_0_asm_h]
	str	x10, [x0, #784]
	adrp	x10, :got:get_var_ref_check_0_asm_h
	ldr	x10, [x10, :got_lo12:get_var_ref_check_0_asm_h]
	str	x8, [x0, #792]
	adrp	x8, :got:put_var_ref_check_0_asm_h
	ldr	x8, [x8, :got_lo12:put_var_ref_check_0_asm_h]
	str	x10, [x0, #800]
	adrp	x10, :got:put_var_ref_check_init_0_asm_h
	ldr	x10, [x10, :got_lo12:put_var_ref_check_init_0_asm_h]
	str	x8, [x0, #808]
	adrp	x8, :got:close_loc_0_asm_h
	ldr	x8, [x8, :got_lo12:close_loc_0_asm_h]
	str	x10, [x0, #816]
	adrp	x10, :got:if_false_0_asm_h
	ldr	x10, [x10, :got_lo12:if_false_0_asm_h]
	str	x8, [x0, #824]
	adrp	x8, :got:if_true_0_asm_h
	ldr	x8, [x8, :got_lo12:if_true_0_asm_h]
	str	x10, [x0, #832]
	adrp	x10, :got:goto_0_asm_h
	ldr	x10, [x10, :got_lo12:goto_0_asm_h]
	str	x8, [x0, #840]
	adrp	x8, :got:catch_0_asm_h
	ldr	x8, [x8, :got_lo12:catch_0_asm_h]
	str	x10, [x0, #848]
	adrp	x10, :got:gosub_0_asm_h
	ldr	x10, [x10, :got_lo12:gosub_0_asm_h]
	str	x8, [x0, #856]
	adrp	x8, :got:ret_0_asm_h
	ldr	x8, [x8, :got_lo12:ret_0_asm_h]
	str	x10, [x0, #864]
	adrp	x10, :got:to_object_0_asm_h
	ldr	x10, [x10, :got_lo12:to_object_0_asm_h]
	str	x8, [x0, #872]
	adrp	x8, :got:to_propkey_0_asm_h
	ldr	x8, [x8, :got_lo12:to_propkey_0_asm_h]
	str	x10, [x0, #880]
	adrp	x10, :got:to_propkey2_0_asm_h
	ldr	x10, [x10, :got_lo12:to_propkey2_0_asm_h]
	str	x8, [x0, #888]
	adrp	x8, :got:with_get_var_0_asm_h
	ldr	x8, [x8, :got_lo12:with_get_var_0_asm_h]
	str	x10, [x0, #896]
	adrp	x10, :got:with_put_var_0_asm_h
	ldr	x10, [x10, :got_lo12:with_put_var_0_asm_h]
	str	x8, [x0, #904]
	adrp	x8, :got:with_delete_var_0_asm_h
	ldr	x8, [x8, :got_lo12:with_delete_var_0_asm_h]
	str	x10, [x0, #912]
	adrp	x10, :got:with_make_ref_0_asm_h
	ldr	x10, [x10, :got_lo12:with_make_ref_0_asm_h]
	str	x8, [x0, #920]
	adrp	x8, :got:with_get_ref_0_asm_h
	ldr	x8, [x8, :got_lo12:with_get_ref_0_asm_h]
	str	x10, [x0, #928]
	adrp	x10, :got:with_get_ref_undef_0_asm_h
	ldr	x10, [x10, :got_lo12:with_get_ref_undef_0_asm_h]
	str	x8, [x0, #936]
	adrp	x8, :got:make_loc_ref_0_asm_h
	ldr	x8, [x8, :got_lo12:make_loc_ref_0_asm_h]
	str	x10, [x0, #944]
	adrp	x10, :got:make_arg_ref_0_asm_h
	ldr	x10, [x10, :got_lo12:make_arg_ref_0_asm_h]
	str	x8, [x0, #952]
	adrp	x8, :got:make_var_ref_ref_0_asm_h
	ldr	x8, [x8, :got_lo12:make_var_ref_ref_0_asm_h]
	str	x10, [x0, #960]
	adrp	x10, :got:make_var_ref_0_asm_h
	ldr	x10, [x10, :got_lo12:make_var_ref_0_asm_h]
	str	x8, [x0, #968]
	adrp	x8, :got:for_in_start_0_asm_h
	ldr	x8, [x8, :got_lo12:for_in_start_0_asm_h]
	str	x10, [x0, #976]
	adrp	x10, :got:for_of_start_0_asm_h
	ldr	x10, [x10, :got_lo12:for_of_start_0_asm_h]
	str	x8, [x0, #984]
	adrp	x8, :got:for_await_of_start_0_asm_h
	ldr	x8, [x8, :got_lo12:for_await_of_start_0_asm_h]
	str	x10, [x0, #992]
	adrp	x10, :got:for_in_next_0_asm_h
	ldr	x10, [x10, :got_lo12:for_in_next_0_asm_h]
	str	x8, [x0, #1000]
	adrp	x8, :got:for_of_next_0_asm_h
	ldr	x8, [x8, :got_lo12:for_of_next_0_asm_h]
	str	x10, [x0, #1008]
	adrp	x10, :got:for_await_of_next_0_asm_h
	ldr	x10, [x10, :got_lo12:for_await_of_next_0_asm_h]
	str	x8, [x0, #1016]
	adrp	x8, :got:iterator_get_value_done_0_asm_h
	ldr	x8, [x8, :got_lo12:iterator_get_value_done_0_asm_h]
	str	x10, [x0, #1024]
	adrp	x10, :got:iterator_close_0_asm_h
	ldr	x10, [x10, :got_lo12:iterator_close_0_asm_h]
	str	x8, [x0, #1032]
	adrp	x8, :got:iterator_close_return_0_asm_h
	ldr	x8, [x8, :got_lo12:iterator_close_return_0_asm_h]
	str	x10, [x0, #1040]
	adrp	x10, :got:async_iterator_close_0_asm_h
	ldr	x10, [x10, :got_lo12:async_iterator_close_0_asm_h]
	str	x8, [x0, #1048]
	adrp	x8, :got:async_iterator_next_0_asm_h
	ldr	x8, [x8, :got_lo12:async_iterator_next_0_asm_h]
	str	x10, [x0, #1056]
	adrp	x10, :got:async_iterator_get_0_asm_h
	ldr	x10, [x10, :got_lo12:async_iterator_get_0_asm_h]
	str	x8, [x0, #1064]
	adrp	x8, :got:initial_yield_0_asm_h
	ldr	x8, [x8, :got_lo12:initial_yield_0_asm_h]
	str	x10, [x0, #1072]
	adrp	x10, :got:yield_0_asm_h
	ldr	x10, [x10, :got_lo12:yield_0_asm_h]
	str	x8, [x0, #1080]
	adrp	x8, :got:yield_star_0_asm_h
	ldr	x8, [x8, :got_lo12:yield_star_0_asm_h]
	str	x10, [x0, #1088]
	adrp	x10, :got:async_yield_star_0_asm_h
	ldr	x10, [x10, :got_lo12:async_yield_star_0_asm_h]
	str	x8, [x0, #1096]
	adrp	x8, :got:await_0_asm_h
	ldr	x8, [x8, :got_lo12:await_0_asm_h]
	str	x10, [x0, #1104]
	adrp	x10, :got:neg_0_asm_h
	ldr	x10, [x10, :got_lo12:neg_0_asm_h]
	str	x8, [x0, #1112]
	adrp	x8, :got:plus_0_asm_h
	ldr	x8, [x8, :got_lo12:plus_0_asm_h]
	str	x10, [x0, #1120]
	adrp	x10, :got:dec_0_asm_h
	ldr	x10, [x10, :got_lo12:dec_0_asm_h]
	str	x8, [x0, #1128]
	adrp	x8, :got:inc_0_asm_h
	ldr	x8, [x8, :got_lo12:inc_0_asm_h]
	str	x10, [x0, #1136]
	adrp	x10, :got:post_dec_0_asm_h
	ldr	x10, [x10, :got_lo12:post_dec_0_asm_h]
	str	x8, [x0, #1144]
	adrp	x8, :got:post_inc_0_asm_h
	ldr	x8, [x8, :got_lo12:post_inc_0_asm_h]
	str	x10, [x0, #1152]
	adrp	x10, :got:dec_loc_0_asm_h
	ldr	x10, [x10, :got_lo12:dec_loc_0_asm_h]
	str	x8, [x0, #1160]
	adrp	x8, :got:inc_loc_0_asm_h
	ldr	x8, [x8, :got_lo12:inc_loc_0_asm_h]
	str	x10, [x0, #1168]
	adrp	x10, :got:add_loc_0_asm_h
	ldr	x10, [x10, :got_lo12:add_loc_0_asm_h]
	str	x8, [x0, #1176]
	adrp	x8, :got:not_0_asm_h
	ldr	x8, [x8, :got_lo12:not_0_asm_h]
	str	x10, [x0, #1184]
	adrp	x10, :got:lnot_0_asm_h
	ldr	x10, [x10, :got_lo12:lnot_0_asm_h]
	str	x8, [x0, #1192]
	adrp	x8, :got:typeof_0_asm_h
	ldr	x8, [x8, :got_lo12:typeof_0_asm_h]
	str	x10, [x0, #1200]
	adrp	x10, :got:delete_0_asm_h
	ldr	x10, [x10, :got_lo12:delete_0_asm_h]
	str	x8, [x0, #1208]
	adrp	x8, :got:delete_var_0_asm_h
	ldr	x8, [x8, :got_lo12:delete_var_0_asm_h]
	str	x10, [x0, #1216]
	adrp	x10, :got:mul_0_asm_h
	ldr	x10, [x10, :got_lo12:mul_0_asm_h]
	str	x8, [x0, #1224]
	adrp	x8, :got:div_0_asm_h
	ldr	x8, [x8, :got_lo12:div_0_asm_h]
	str	x10, [x0, #1232]
	adrp	x10, :got:mod_0_asm_h
	ldr	x10, [x10, :got_lo12:mod_0_asm_h]
	str	x8, [x0, #1240]
	adrp	x8, :got:add_0_asm_h
	ldr	x8, [x8, :got_lo12:add_0_asm_h]
	str	x10, [x0, #1248]
	adrp	x10, :got:sub_0_asm_h
	ldr	x10, [x10, :got_lo12:sub_0_asm_h]
	str	x8, [x0, #1256]
	adrp	x8, :got:pow_0_asm_h
	ldr	x8, [x8, :got_lo12:pow_0_asm_h]
	str	x10, [x0, #1264]
	adrp	x10, :got:shl_0_asm_h
	ldr	x10, [x10, :got_lo12:shl_0_asm_h]
	str	x8, [x0, #1272]
	adrp	x8, :got:sar_0_asm_h
	ldr	x8, [x8, :got_lo12:sar_0_asm_h]
	str	x10, [x0, #1280]
	adrp	x10, :got:shr_0_asm_h
	ldr	x10, [x10, :got_lo12:shr_0_asm_h]
	str	x8, [x0, #1288]
	adrp	x8, :got:lt_0_asm_h
	ldr	x8, [x8, :got_lo12:lt_0_asm_h]
	str	x10, [x0, #1296]
	adrp	x10, :got:lte_0_asm_h
	ldr	x10, [x10, :got_lo12:lte_0_asm_h]
	str	x8, [x0, #1304]
	adrp	x8, :got:gt_0_asm_h
	ldr	x8, [x8, :got_lo12:gt_0_asm_h]
	str	x10, [x0, #1312]
	adrp	x10, :got:gte_0_asm_h
	ldr	x10, [x10, :got_lo12:gte_0_asm_h]
	str	x8, [x0, #1320]
	adrp	x8, :got:instanceof_0_asm_h
	ldr	x8, [x8, :got_lo12:instanceof_0_asm_h]
	str	x10, [x0, #1328]
	adrp	x10, :got:in_0_asm_h
	ldr	x10, [x10, :got_lo12:in_0_asm_h]
	str	x8, [x0, #1336]
	adrp	x8, :got:eq_0_asm_h
	ldr	x8, [x8, :got_lo12:eq_0_asm_h]
	str	x10, [x0, #1344]
	adrp	x10, :got:neq_0_asm_h
	ldr	x10, [x10, :got_lo12:neq_0_asm_h]
	str	x8, [x0, #1352]
	adrp	x8, :got:strict_eq_0_asm_h
	ldr	x8, [x8, :got_lo12:strict_eq_0_asm_h]
	str	x10, [x0, #1360]
	adrp	x10, :got:strict_neq_0_asm_h
	ldr	x10, [x10, :got_lo12:strict_neq_0_asm_h]
	str	x8, [x0, #1368]
	adrp	x8, :got:and_0_asm_h
	ldr	x8, [x8, :got_lo12:and_0_asm_h]
	str	x10, [x0, #1376]
	adrp	x10, :got:xor_0_asm_h
	ldr	x10, [x10, :got_lo12:xor_0_asm_h]
	str	x8, [x0, #1384]
	adrp	x8, :got:or_0_asm_h
	ldr	x8, [x8, :got_lo12:or_0_asm_h]
	str	x10, [x0, #1392]
	adrp	x10, :got:nop_0_asm_h
	ldr	x10, [x10, :got_lo12:nop_0_asm_h]
	str	x8, [x0, #1400]
	adrp	x8, :got:push_minus1_0_asm_h
	ldr	x8, [x8, :got_lo12:push_minus1_0_asm_h]
	str	x10, [x0, #1408]
	adrp	x10, :got:push_0_0_asm_h
	ldr	x10, [x10, :got_lo12:push_0_0_asm_h]
	str	x8, [x0, #1416]
	adrp	x8, :got:push_1_0_asm_h
	ldr	x8, [x8, :got_lo12:push_1_0_asm_h]
	str	x10, [x0, #1424]
	adrp	x10, :got:push_2_0_asm_h
	ldr	x10, [x10, :got_lo12:push_2_0_asm_h]
	str	x8, [x0, #1432]
	adrp	x8, :got:push_3_0_asm_h
	ldr	x8, [x8, :got_lo12:push_3_0_asm_h]
	str	x10, [x0, #1440]
	adrp	x10, :got:push_4_0_asm_h
	ldr	x10, [x10, :got_lo12:push_4_0_asm_h]
	str	x8, [x0, #1448]
	adrp	x8, :got:push_5_0_asm_h
	ldr	x8, [x8, :got_lo12:push_5_0_asm_h]
	str	x10, [x0, #1456]
	adrp	x10, :got:push_6_0_asm_h
	ldr	x10, [x10, :got_lo12:push_6_0_asm_h]
	str	x8, [x0, #1464]
	adrp	x8, :got:push_7_0_asm_h
	ldr	x8, [x8, :got_lo12:push_7_0_asm_h]
	str	x10, [x0, #1472]
	adrp	x10, :got:push_i8_0_asm_h
	ldr	x10, [x10, :got_lo12:push_i8_0_asm_h]
	str	x8, [x0, #1480]
	adrp	x8, :got:push_i16_0_asm_h
	ldr	x8, [x8, :got_lo12:push_i16_0_asm_h]
	str	x10, [x0, #1488]
	adrp	x10, :got:push_const8_0_asm_h
	ldr	x10, [x10, :got_lo12:push_const8_0_asm_h]
	str	x8, [x0, #1496]
	adrp	x8, :got:fclosure8_0_asm_h
	ldr	x8, [x8, :got_lo12:fclosure8_0_asm_h]
	str	x10, [x0, #1504]
	adrp	x10, :got:push_empty_string_0_asm_h
	ldr	x10, [x10, :got_lo12:push_empty_string_0_asm_h]
	str	x8, [x0, #1512]
	adrp	x8, :got:get_loc8_0_asm_h
	ldr	x8, [x8, :got_lo12:get_loc8_0_asm_h]
	str	x10, [x0, #1520]
	adrp	x10, :got:put_loc8_0_asm_h
	ldr	x10, [x10, :got_lo12:put_loc8_0_asm_h]
	str	x8, [x0, #1528]
	adrp	x8, :got:set_loc8_0_asm_h
	ldr	x8, [x8, :got_lo12:set_loc8_0_asm_h]
	str	x10, [x0, #1536]
	adrp	x10, :got:get_loc0_0_asm_h
	ldr	x10, [x10, :got_lo12:get_loc0_0_asm_h]
	str	x8, [x0, #1544]
	adrp	x8, :got:get_loc1_0_asm_h
	ldr	x8, [x8, :got_lo12:get_loc1_0_asm_h]
	str	x10, [x0, #1552]
	adrp	x10, :got:get_loc2_0_asm_h
	ldr	x10, [x10, :got_lo12:get_loc2_0_asm_h]
	str	x8, [x0, #1560]
	adrp	x8, :got:get_loc3_0_asm_h
	ldr	x8, [x8, :got_lo12:get_loc3_0_asm_h]
	str	x10, [x0, #1568]
	adrp	x10, :got:put_loc0_0_asm_h
	ldr	x10, [x10, :got_lo12:put_loc0_0_asm_h]
	str	x8, [x0, #1576]
	adrp	x8, :got:put_loc1_0_asm_h
	ldr	x8, [x8, :got_lo12:put_loc1_0_asm_h]
	str	x10, [x0, #1584]
	adrp	x10, :got:put_loc2_0_asm_h
	ldr	x10, [x10, :got_lo12:put_loc2_0_asm_h]
	str	x8, [x0, #1592]
	adrp	x8, :got:put_loc3_0_asm_h
	ldr	x8, [x8, :got_lo12:put_loc3_0_asm_h]
	str	x10, [x0, #1600]
	adrp	x10, :got:set_loc0_0_asm_h
	ldr	x10, [x10, :got_lo12:set_loc0_0_asm_h]
	str	x8, [x0, #1608]
	adrp	x8, :got:set_loc1_0_asm_h
	ldr	x8, [x8, :got_lo12:set_loc1_0_asm_h]
	str	x10, [x0, #1616]
	adrp	x10, :got:set_loc2_0_asm_h
	ldr	x10, [x10, :got_lo12:set_loc2_0_asm_h]
	str	x8, [x0, #1624]
	adrp	x8, :got:set_loc3_0_asm_h
	ldr	x8, [x8, :got_lo12:set_loc3_0_asm_h]
	str	x10, [x0, #1632]
	adrp	x10, :got:get_arg0_0_asm_h
	ldr	x10, [x10, :got_lo12:get_arg0_0_asm_h]
	str	x8, [x0, #1640]
	adrp	x8, :got:get_arg1_0_asm_h
	ldr	x8, [x8, :got_lo12:get_arg1_0_asm_h]
	str	x10, [x0, #1648]
	adrp	x10, :got:get_arg2_0_asm_h
	ldr	x10, [x10, :got_lo12:get_arg2_0_asm_h]
	str	x8, [x0, #1656]
	adrp	x8, :got:get_arg3_0_asm_h
	ldr	x8, [x8, :got_lo12:get_arg3_0_asm_h]
	str	x10, [x0, #1664]
	adrp	x10, :got:put_arg0_0_asm_h
	ldr	x10, [x10, :got_lo12:put_arg0_0_asm_h]
	str	x8, [x0, #1672]
	adrp	x8, :got:put_arg1_0_asm_h
	ldr	x8, [x8, :got_lo12:put_arg1_0_asm_h]
	str	x10, [x0, #1680]
	adrp	x10, :got:put_arg2_0_asm_h
	ldr	x10, [x10, :got_lo12:put_arg2_0_asm_h]
	str	x8, [x0, #1688]
	adrp	x8, :got:put_arg3_0_asm_h
	ldr	x8, [x8, :got_lo12:put_arg3_0_asm_h]
	str	x10, [x0, #1696]
	adrp	x10, :got:set_arg0_0_asm_h
	ldr	x10, [x10, :got_lo12:set_arg0_0_asm_h]
	str	x8, [x0, #1704]
	adrp	x8, :got:set_arg1_0_asm_h
	ldr	x8, [x8, :got_lo12:set_arg1_0_asm_h]
	str	x10, [x0, #1712]
	adrp	x10, :got:set_arg2_0_asm_h
	ldr	x10, [x10, :got_lo12:set_arg2_0_asm_h]
	str	x8, [x0, #1720]
	adrp	x8, :got:set_arg3_0_asm_h
	ldr	x8, [x8, :got_lo12:set_arg3_0_asm_h]
	str	x10, [x0, #1728]
	adrp	x10, :got:get_var_ref0_0_asm_h
	ldr	x10, [x10, :got_lo12:get_var_ref0_0_asm_h]
	str	x8, [x0, #1736]
	adrp	x8, :got:get_var_ref1_0_asm_h
	ldr	x8, [x8, :got_lo12:get_var_ref1_0_asm_h]
	str	x10, [x0, #1744]
	adrp	x10, :got:get_var_ref2_0_asm_h
	ldr	x10, [x10, :got_lo12:get_var_ref2_0_asm_h]
	str	x8, [x0, #1752]
	adrp	x8, :got:get_var_ref3_0_asm_h
	ldr	x8, [x8, :got_lo12:get_var_ref3_0_asm_h]
	str	x10, [x0, #1760]
	adrp	x10, :got:put_var_ref0_0_asm_h
	ldr	x10, [x10, :got_lo12:put_var_ref0_0_asm_h]
	str	x8, [x0, #1768]
	adrp	x8, :got:put_var_ref1_0_asm_h
	ldr	x8, [x8, :got_lo12:put_var_ref1_0_asm_h]
	str	x10, [x0, #1776]
	adrp	x10, :got:put_var_ref2_0_asm_h
	ldr	x10, [x10, :got_lo12:put_var_ref2_0_asm_h]
	str	x8, [x0, #1784]
	adrp	x8, :got:put_var_ref3_0_asm_h
	ldr	x8, [x8, :got_lo12:put_var_ref3_0_asm_h]
	str	x10, [x0, #1792]
	adrp	x10, :got:set_var_ref0_0_asm_h
	ldr	x10, [x10, :got_lo12:set_var_ref0_0_asm_h]
	str	x8, [x0, #1800]
	adrp	x8, :got:set_var_ref1_0_asm_h
	ldr	x8, [x8, :got_lo12:set_var_ref1_0_asm_h]
	str	x10, [x0, #1808]
	adrp	x10, :got:set_var_ref2_0_asm_h
	ldr	x10, [x10, :got_lo12:set_var_ref2_0_asm_h]
	str	x8, [x0, #1816]
	adrp	x8, :got:set_var_ref3_0_asm_h
	ldr	x8, [x8, :got_lo12:set_var_ref3_0_asm_h]
	str	x10, [x0, #1824]
	adrp	x10, :got:get_length_0_asm_h
	ldr	x10, [x10, :got_lo12:get_length_0_asm_h]
	str	x8, [x0, #1832]
	adrp	x8, :got:if_false8_0_asm_h
	ldr	x8, [x8, :got_lo12:if_false8_0_asm_h]
	str	x10, [x0, #1840]
	adrp	x10, :got:if_true8_0_asm_h
	ldr	x10, [x10, :got_lo12:if_true8_0_asm_h]
	str	x8, [x0, #1848]
	adrp	x8, :got:goto8_0_asm_h
	ldr	x8, [x8, :got_lo12:goto8_0_asm_h]
	str	x10, [x0, #1856]
	adrp	x10, :got:goto16_0_asm_h
	ldr	x10, [x10, :got_lo12:goto16_0_asm_h]
	str	x8, [x0, #1864]
	adrp	x8, :got:call0_0_asm_h
	ldr	x8, [x8, :got_lo12:call0_0_asm_h]
	str	x10, [x0, #1872]
	adrp	x10, :got:call1_0_asm_h
	ldr	x10, [x10, :got_lo12:call1_0_asm_h]
	str	x8, [x0, #1880]
	adrp	x8, :got:call2_0_asm_h
	ldr	x8, [x8, :got_lo12:call2_0_asm_h]
	str	x10, [x0, #1888]
	adrp	x10, :got:call3_0_asm_h
	ldr	x10, [x10, :got_lo12:call3_0_asm_h]
	str	x8, [x0, #1896]
	adrp	x8, :got:is_undefined_0_asm_h
	ldr	x8, [x8, :got_lo12:is_undefined_0_asm_h]
	str	x10, [x0, #1904]
	adrp	x10, :got:is_null_0_asm_h
	ldr	x10, [x10, :got_lo12:is_null_0_asm_h]
	str	x8, [x0, #1912]
	adrp	x8, :got:is_function_0_asm_h
	ldr	x8, [x8, :got_lo12:is_function_0_asm_h]
	str	x10, [x0, #1920]
	adrp	x10, :got:invalid_1_asm_h
	ldr	x10, [x10, :got_lo12:invalid_1_asm_h]
	str	x8, [x0, #1928]
	adrp	x8, :got:push_i32_1_asm_h
	ldr	x8, [x8, :got_lo12:push_i32_1_asm_h]
	str	x10, [x0, #1936]
	adrp	x10, :got:push_const_1_asm_h
	ldr	x10, [x10, :got_lo12:push_const_1_asm_h]
	str	x8, [x0, #1944]
	adrp	x8, :got:fclosure_1_asm_h
	ldr	x8, [x8, :got_lo12:fclosure_1_asm_h]
	str	x10, [x0, #1952]
	adrp	x10, :got:push_atom_value_1_asm_h
	ldr	x10, [x10, :got_lo12:push_atom_value_1_asm_h]
	str	x8, [x0, #1960]
	adrp	x8, :got:private_symbol_1_asm_h
	ldr	x8, [x8, :got_lo12:private_symbol_1_asm_h]
	str	x10, [x0, #1968]
	adrp	x10, :got:undefined_1_asm_h
	ldr	x10, [x10, :got_lo12:undefined_1_asm_h]
	str	x8, [x0, #1976]
	adrp	x8, :got:null_1_asm_h
	ldr	x8, [x8, :got_lo12:null_1_asm_h]
	str	x10, [x0, #1984]
	adrp	x10, :got:push_this_1_asm_h
	ldr	x10, [x10, :got_lo12:push_this_1_asm_h]
	str	x8, [x0, #1992]
	adrp	x8, :got:push_false_1_asm_h
	ldr	x8, [x8, :got_lo12:push_false_1_asm_h]
	str	x10, [x0, #2000]
	adrp	x10, :got:push_true_1_asm_h
	ldr	x10, [x10, :got_lo12:push_true_1_asm_h]
	str	x8, [x0, #2008]
	adrp	x8, :got:object_1_asm_h
	ldr	x8, [x8, :got_lo12:object_1_asm_h]
	str	x10, [x0, #2016]
	adrp	x10, :got:put_var_ref3_1_asm_h
	ldr	x10, [x10, :got_lo12:put_var_ref3_1_asm_h]
	str	x8, [x0, #2024]
	adrp	x8, :got:put_var_ref2_1_asm_h
	ldr	x8, [x8, :got_lo12:put_var_ref2_1_asm_h]
	str	x10, [x0, #3736]
	adrp	x10, :got:put_var_ref1_1_asm_h
	ldr	x10, [x10, :got_lo12:put_var_ref1_1_asm_h]
	str	x8, [x0, #3728]
	adrp	x8, :got:put_var_ref0_1_asm_h
	ldr	x8, [x8, :got_lo12:put_var_ref0_1_asm_h]
	str	x10, [x0, #3720]
	adrp	x10, :got:get_var_ref3_1_asm_h
	ldr	x10, [x10, :got_lo12:get_var_ref3_1_asm_h]
	str	x8, [x0, #3712]
	adrp	x8, :got:get_var_ref2_1_asm_h
	ldr	x8, [x8, :got_lo12:get_var_ref2_1_asm_h]
	str	x10, [x0, #3704]
	adrp	x10, :got:get_var_ref1_1_asm_h
	ldr	x10, [x10, :got_lo12:get_var_ref1_1_asm_h]
	str	x8, [x0, #3696]
	adrp	x8, :got:get_var_ref0_1_asm_h
	ldr	x8, [x8, :got_lo12:get_var_ref0_1_asm_h]
	str	x10, [x0, #3688]
	adrp	x10, :got:set_arg3_1_asm_h
	ldr	x10, [x10, :got_lo12:set_arg3_1_asm_h]
	str	x8, [x0, #3680]
	adrp	x8, :got:set_arg2_1_asm_h
	ldr	x8, [x8, :got_lo12:set_arg2_1_asm_h]
	str	x10, [x0, #3672]
	adrp	x10, :got:set_arg1_1_asm_h
	ldr	x10, [x10, :got_lo12:set_arg1_1_asm_h]
	str	x8, [x0, #3664]
	adrp	x8, :got:set_arg0_1_asm_h
	ldr	x8, [x8, :got_lo12:set_arg0_1_asm_h]
	str	x10, [x0, #3656]
	adrp	x10, :got:put_arg3_1_asm_h
	ldr	x10, [x10, :got_lo12:put_arg3_1_asm_h]
	str	x8, [x0, #3648]
	adrp	x8, :got:put_arg2_1_asm_h
	ldr	x8, [x8, :got_lo12:put_arg2_1_asm_h]
	str	x10, [x0, #3640]
	adrp	x10, :got:put_arg1_1_asm_h
	ldr	x10, [x10, :got_lo12:put_arg1_1_asm_h]
	str	x8, [x0, #3632]
	adrp	x8, :got:put_arg0_1_asm_h
	ldr	x8, [x8, :got_lo12:put_arg0_1_asm_h]
	str	x10, [x0, #3624]
	adrp	x10, :got:get_arg3_1_asm_h
	ldr	x10, [x10, :got_lo12:get_arg3_1_asm_h]
	str	x8, [x0, #3616]
	adrp	x8, :got:get_arg2_1_asm_h
	ldr	x8, [x8, :got_lo12:get_arg2_1_asm_h]
	str	x10, [x0, #3608]
	adrp	x10, :got:get_arg1_1_asm_h
	ldr	x10, [x10, :got_lo12:get_arg1_1_asm_h]
	str	x8, [x0, #3600]
	adrp	x8, :got:get_arg0_1_asm_h
	ldr	x8, [x8, :got_lo12:get_arg0_1_asm_h]
	str	x10, [x0, #3592]
	adrp	x10, :got:set_loc3_1_asm_h
	ldr	x10, [x10, :got_lo12:set_loc3_1_asm_h]
	str	x8, [x0, #3584]
	adrp	x8, :got:set_loc2_1_asm_h
	ldr	x8, [x8, :got_lo12:set_loc2_1_asm_h]
	str	x10, [x0, #3576]
	adrp	x10, :got:set_loc1_1_asm_h
	ldr	x10, [x10, :got_lo12:set_loc1_1_asm_h]
	str	x8, [x0, #3568]
	adrp	x8, :got:set_loc0_1_asm_h
	ldr	x8, [x8, :got_lo12:set_loc0_1_asm_h]
	str	x10, [x0, #3560]
	adrp	x10, :got:put_loc3_1_asm_h
	ldr	x10, [x10, :got_lo12:put_loc3_1_asm_h]
	str	x8, [x0, #3552]
	adrp	x8, :got:put_loc2_1_asm_h
	ldr	x8, [x8, :got_lo12:put_loc2_1_asm_h]
	str	x10, [x0, #3544]
	adrp	x10, :got:put_loc1_1_asm_h
	ldr	x10, [x10, :got_lo12:put_loc1_1_asm_h]
	str	x8, [x0, #3536]
	adrp	x8, :got:put_loc0_1_asm_h
	ldr	x8, [x8, :got_lo12:put_loc0_1_asm_h]
	str	x10, [x0, #3528]
	adrp	x10, :got:get_loc3_1_asm_h
	ldr	x10, [x10, :got_lo12:get_loc3_1_asm_h]
	str	x8, [x0, #3520]
	adrp	x8, :got:get_loc2_1_asm_h
	ldr	x8, [x8, :got_lo12:get_loc2_1_asm_h]
	str	x10, [x0, #3512]
	adrp	x10, :got:get_loc1_1_asm_h
	ldr	x10, [x10, :got_lo12:get_loc1_1_asm_h]
	str	x8, [x0, #3504]
	adrp	x8, :got:get_loc0_1_asm_h
	ldr	x8, [x8, :got_lo12:get_loc0_1_asm_h]
	str	x10, [x0, #3496]
	adrp	x10, :got:set_loc8_1_asm_h
	ldr	x10, [x10, :got_lo12:set_loc8_1_asm_h]
	str	x8, [x0, #3488]
	adrp	x8, :got:put_loc8_1_asm_h
	ldr	x8, [x8, :got_lo12:put_loc8_1_asm_h]
	str	x10, [x0, #3480]
	adrp	x10, :got:get_loc8_1_asm_h
	ldr	x10, [x10, :got_lo12:get_loc8_1_asm_h]
	str	x8, [x0, #3472]
	adrp	x8, :got:push_empty_string_1_asm_h
	ldr	x8, [x8, :got_lo12:push_empty_string_1_asm_h]
	str	x10, [x0, #3464]
	adrp	x10, :got:fclosure8_1_asm_h
	ldr	x10, [x10, :got_lo12:fclosure8_1_asm_h]
	str	x8, [x0, #3456]
	adrp	x8, :got:push_const8_1_asm_h
	ldr	x8, [x8, :got_lo12:push_const8_1_asm_h]
	str	x10, [x0, #3448]
	adrp	x10, :got:push_i16_1_asm_h
	ldr	x10, [x10, :got_lo12:push_i16_1_asm_h]
	str	x8, [x0, #3440]
	adrp	x8, :got:push_i8_1_asm_h
	ldr	x8, [x8, :got_lo12:push_i8_1_asm_h]
	str	x10, [x0, #3432]
	adrp	x10, :got:push_7_1_asm_h
	ldr	x10, [x10, :got_lo12:push_7_1_asm_h]
	str	x8, [x0, #3424]
	adrp	x8, :got:push_6_1_asm_h
	ldr	x8, [x8, :got_lo12:push_6_1_asm_h]
	str	x10, [x0, #3416]
	adrp	x10, :got:push_5_1_asm_h
	ldr	x10, [x10, :got_lo12:push_5_1_asm_h]
	str	x8, [x0, #3408]
	adrp	x8, :got:push_4_1_asm_h
	ldr	x8, [x8, :got_lo12:push_4_1_asm_h]
	str	x10, [x0, #3400]
	adrp	x10, :got:push_3_1_asm_h
	ldr	x10, [x10, :got_lo12:push_3_1_asm_h]
	str	x8, [x0, #3392]
	adrp	x8, :got:push_2_1_asm_h
	ldr	x8, [x8, :got_lo12:push_2_1_asm_h]
	str	x10, [x0, #3384]
	adrp	x10, :got:push_1_1_asm_h
	ldr	x10, [x10, :got_lo12:push_1_1_asm_h]
	str	x8, [x0, #3376]
	adrp	x8, :got:push_0_1_asm_h
	ldr	x8, [x8, :got_lo12:push_0_1_asm_h]
	str	x10, [x0, #3368]
	adrp	x10, :got:push_minus1_1_asm_h
	ldr	x10, [x10, :got_lo12:push_minus1_1_asm_h]
	str	x8, [x0, #3360]
	adrp	x8, :got:nop_1_asm_h
	ldr	x8, [x8, :got_lo12:nop_1_asm_h]
	str	x10, [x0, #3352]
	adrp	x10, :got:or_1_asm_h
	ldr	x10, [x10, :got_lo12:or_1_asm_h]
	str	x8, [x0, #3344]
	adrp	x8, :got:xor_1_asm_h
	ldr	x8, [x8, :got_lo12:xor_1_asm_h]
	str	x10, [x0, #3336]
	adrp	x10, :got:and_1_asm_h
	ldr	x10, [x10, :got_lo12:and_1_asm_h]
	str	x8, [x0, #3328]
	adrp	x8, :got:strict_neq_1_asm_h
	ldr	x8, [x8, :got_lo12:strict_neq_1_asm_h]
	str	x10, [x0, #3320]
	adrp	x10, :got:strict_eq_1_asm_h
	ldr	x10, [x10, :got_lo12:strict_eq_1_asm_h]
	str	x8, [x0, #3312]
	adrp	x8, :got:neq_1_asm_h
	ldr	x8, [x8, :got_lo12:neq_1_asm_h]
	str	x10, [x0, #3304]
	adrp	x10, :got:eq_1_asm_h
	ldr	x10, [x10, :got_lo12:eq_1_asm_h]
	str	x8, [x0, #3296]
	adrp	x8, :got:in_1_asm_h
	ldr	x8, [x8, :got_lo12:in_1_asm_h]
	str	x10, [x0, #3288]
	adrp	x10, :got:instanceof_1_asm_h
	ldr	x10, [x10, :got_lo12:instanceof_1_asm_h]
	str	x8, [x0, #3280]
	adrp	x8, :got:gte_1_asm_h
	ldr	x8, [x8, :got_lo12:gte_1_asm_h]
	str	x10, [x0, #3272]
	adrp	x10, :got:gt_1_asm_h
	ldr	x10, [x10, :got_lo12:gt_1_asm_h]
	str	x8, [x0, #3264]
	adrp	x8, :got:lte_1_asm_h
	ldr	x8, [x8, :got_lo12:lte_1_asm_h]
	str	x10, [x0, #3256]
	adrp	x10, :got:lt_1_asm_h
	ldr	x10, [x10, :got_lo12:lt_1_asm_h]
	str	x8, [x0, #3248]
	adrp	x8, :got:shr_1_asm_h
	ldr	x8, [x8, :got_lo12:shr_1_asm_h]
	str	x10, [x0, #3240]
	adrp	x10, :got:sar_1_asm_h
	ldr	x10, [x10, :got_lo12:sar_1_asm_h]
	str	x8, [x0, #3232]
	adrp	x8, :got:shl_1_asm_h
	ldr	x8, [x8, :got_lo12:shl_1_asm_h]
	str	x10, [x0, #3224]
	adrp	x10, :got:pow_1_asm_h
	ldr	x10, [x10, :got_lo12:pow_1_asm_h]
	str	x8, [x0, #3216]
	adrp	x8, :got:sub_1_asm_h
	ldr	x8, [x8, :got_lo12:sub_1_asm_h]
	str	x10, [x0, #3208]
	adrp	x10, :got:add_1_asm_h
	ldr	x10, [x10, :got_lo12:add_1_asm_h]
	str	x8, [x0, #3200]
	adrp	x8, :got:mod_1_asm_h
	ldr	x8, [x8, :got_lo12:mod_1_asm_h]
	str	x10, [x0, #3192]
	adrp	x10, :got:div_1_asm_h
	ldr	x10, [x10, :got_lo12:div_1_asm_h]
	str	x8, [x0, #3184]
	adrp	x8, :got:mul_1_asm_h
	ldr	x8, [x8, :got_lo12:mul_1_asm_h]
	str	x10, [x0, #3176]
	adrp	x10, :got:delete_var_1_asm_h
	ldr	x10, [x10, :got_lo12:delete_var_1_asm_h]
	str	x8, [x0, #3168]
	adrp	x8, :got:delete_1_asm_h
	ldr	x8, [x8, :got_lo12:delete_1_asm_h]
	str	x10, [x0, #3160]
	adrp	x10, :got:typeof_1_asm_h
	ldr	x10, [x10, :got_lo12:typeof_1_asm_h]
	str	x8, [x0, #3152]
	adrp	x8, :got:lnot_1_asm_h
	ldr	x8, [x8, :got_lo12:lnot_1_asm_h]
	str	x10, [x0, #3144]
	adrp	x10, :got:not_1_asm_h
	ldr	x10, [x10, :got_lo12:not_1_asm_h]
	str	x8, [x0, #3136]
	adrp	x8, :got:add_loc_1_asm_h
	ldr	x8, [x8, :got_lo12:add_loc_1_asm_h]
	str	x10, [x0, #3128]
	adrp	x10, :got:inc_loc_1_asm_h
	ldr	x10, [x10, :got_lo12:inc_loc_1_asm_h]
	str	x8, [x0, #3120]
	adrp	x8, :got:dec_loc_1_asm_h
	ldr	x8, [x8, :got_lo12:dec_loc_1_asm_h]
	str	x10, [x0, #3112]
	adrp	x10, :got:post_inc_1_asm_h
	ldr	x10, [x10, :got_lo12:post_inc_1_asm_h]
	str	x8, [x0, #3104]
	adrp	x8, :got:post_dec_1_asm_h
	ldr	x8, [x8, :got_lo12:post_dec_1_asm_h]
	str	x10, [x0, #3096]
	adrp	x10, :got:inc_1_asm_h
	ldr	x10, [x10, :got_lo12:inc_1_asm_h]
	str	x8, [x0, #3088]
	adrp	x8, :got:dec_1_asm_h
	ldr	x8, [x8, :got_lo12:dec_1_asm_h]
	str	x10, [x0, #3080]
	adrp	x10, :got:plus_1_asm_h
	ldr	x10, [x10, :got_lo12:plus_1_asm_h]
	str	x8, [x0, #3072]
	adrp	x8, :got:neg_1_asm_h
	ldr	x8, [x8, :got_lo12:neg_1_asm_h]
	str	x10, [x0, #3064]
	adrp	x10, :got:await_1_asm_h
	ldr	x10, [x10, :got_lo12:await_1_asm_h]
	str	x8, [x0, #3056]
	adrp	x8, :got:async_yield_star_1_asm_h
	ldr	x8, [x8, :got_lo12:async_yield_star_1_asm_h]
	str	x10, [x0, #3048]
	adrp	x10, :got:yield_star_1_asm_h
	ldr	x10, [x10, :got_lo12:yield_star_1_asm_h]
	str	x8, [x0, #3040]
	adrp	x8, :got:yield_1_asm_h
	ldr	x8, [x8, :got_lo12:yield_1_asm_h]
	str	x10, [x0, #3032]
	adrp	x10, :got:initial_yield_1_asm_h
	ldr	x10, [x10, :got_lo12:initial_yield_1_asm_h]
	str	x8, [x0, #3024]
	adrp	x8, :got:async_iterator_get_1_asm_h
	ldr	x8, [x8, :got_lo12:async_iterator_get_1_asm_h]
	str	x10, [x0, #3016]
	adrp	x10, :got:async_iterator_next_1_asm_h
	ldr	x10, [x10, :got_lo12:async_iterator_next_1_asm_h]
	str	x8, [x0, #3008]
	adrp	x8, :got:async_iterator_close_1_asm_h
	ldr	x8, [x8, :got_lo12:async_iterator_close_1_asm_h]
	str	x10, [x0, #3000]
	adrp	x10, :got:iterator_close_return_1_asm_h
	ldr	x10, [x10, :got_lo12:iterator_close_return_1_asm_h]
	str	x8, [x0, #2992]
	adrp	x8, :got:iterator_close_1_asm_h
	ldr	x8, [x8, :got_lo12:iterator_close_1_asm_h]
	str	x10, [x0, #2984]
	adrp	x10, :got:iterator_get_value_done_1_asm_h
	ldr	x10, [x10, :got_lo12:iterator_get_value_done_1_asm_h]
	str	x8, [x0, #2976]
	adrp	x8, :got:for_await_of_next_1_asm_h
	ldr	x8, [x8, :got_lo12:for_await_of_next_1_asm_h]
	str	x10, [x0, #2968]
	adrp	x10, :got:for_of_next_1_asm_h
	ldr	x10, [x10, :got_lo12:for_of_next_1_asm_h]
	str	x8, [x0, #2960]
	adrp	x8, :got:for_in_next_1_asm_h
	ldr	x8, [x8, :got_lo12:for_in_next_1_asm_h]
	str	x10, [x0, #2952]
	adrp	x10, :got:for_await_of_start_1_asm_h
	ldr	x10, [x10, :got_lo12:for_await_of_start_1_asm_h]
	str	x8, [x0, #2944]
	adrp	x8, :got:for_of_start_1_asm_h
	ldr	x8, [x8, :got_lo12:for_of_start_1_asm_h]
	str	x10, [x0, #2936]
	adrp	x10, :got:for_in_start_1_asm_h
	ldr	x10, [x10, :got_lo12:for_in_start_1_asm_h]
	str	x8, [x0, #2928]
	adrp	x8, :got:make_var_ref_1_asm_h
	ldr	x8, [x8, :got_lo12:make_var_ref_1_asm_h]
	str	x10, [x0, #2920]
	adrp	x10, :got:make_var_ref_ref_1_asm_h
	ldr	x10, [x10, :got_lo12:make_var_ref_ref_1_asm_h]
	str	x8, [x0, #2912]
	adrp	x8, :got:make_arg_ref_1_asm_h
	ldr	x8, [x8, :got_lo12:make_arg_ref_1_asm_h]
	str	x10, [x0, #2904]
	adrp	x10, :got:make_loc_ref_1_asm_h
	ldr	x10, [x10, :got_lo12:make_loc_ref_1_asm_h]
	str	x8, [x0, #2896]
	adrp	x8, :got:with_get_ref_undef_1_asm_h
	ldr	x8, [x8, :got_lo12:with_get_ref_undef_1_asm_h]
	str	x10, [x0, #2888]
	adrp	x10, :got:with_get_ref_1_asm_h
	ldr	x10, [x10, :got_lo12:with_get_ref_1_asm_h]
	str	x8, [x0, #2880]
	adrp	x8, :got:with_make_ref_1_asm_h
	ldr	x8, [x8, :got_lo12:with_make_ref_1_asm_h]
	str	x10, [x0, #2872]
	adrp	x10, :got:with_delete_var_1_asm_h
	ldr	x10, [x10, :got_lo12:with_delete_var_1_asm_h]
	str	x8, [x0, #2864]
	adrp	x8, :got:with_put_var_1_asm_h
	ldr	x8, [x8, :got_lo12:with_put_var_1_asm_h]
	str	x10, [x0, #2856]
	adrp	x10, :got:with_get_var_1_asm_h
	ldr	x10, [x10, :got_lo12:with_get_var_1_asm_h]
	str	x8, [x0, #2848]
	adrp	x8, :got:to_propkey2_1_asm_h
	ldr	x8, [x8, :got_lo12:to_propkey2_1_asm_h]
	str	x10, [x0, #2840]
	adrp	x10, :got:to_propkey_1_asm_h
	ldr	x10, [x10, :got_lo12:to_propkey_1_asm_h]
	str	x8, [x0, #2832]
	adrp	x8, :got:to_object_1_asm_h
	ldr	x8, [x8, :got_lo12:to_object_1_asm_h]
	str	x10, [x0, #2824]
	adrp	x10, :got:ret_1_asm_h
	ldr	x10, [x10, :got_lo12:ret_1_asm_h]
	str	x8, [x0, #2816]
	adrp	x8, :got:gosub_1_asm_h
	ldr	x8, [x8, :got_lo12:gosub_1_asm_h]
	str	x10, [x0, #2808]
	adrp	x10, :got:catch_1_asm_h
	ldr	x10, [x10, :got_lo12:catch_1_asm_h]
	str	x8, [x0, #2800]
	adrp	x8, :got:goto_1_asm_h
	ldr	x8, [x8, :got_lo12:goto_1_asm_h]
	str	x10, [x0, #2792]
	adrp	x10, :got:if_true_1_asm_h
	ldr	x10, [x10, :got_lo12:if_true_1_asm_h]
	str	x8, [x0, #2784]
	adrp	x8, :got:if_false_1_asm_h
	ldr	x8, [x8, :got_lo12:if_false_1_asm_h]
	str	x10, [x0, #2776]
	adrp	x10, :got:close_loc_1_asm_h
	ldr	x10, [x10, :got_lo12:close_loc_1_asm_h]
	str	x8, [x0, #2768]
	adrp	x8, :got:put_var_ref_check_init_1_asm_h
	ldr	x8, [x8, :got_lo12:put_var_ref_check_init_1_asm_h]
	str	x10, [x0, #2760]
	adrp	x10, :got:put_var_ref_check_1_asm_h
	ldr	x10, [x10, :got_lo12:put_var_ref_check_1_asm_h]
	str	x8, [x0, #2752]
	adrp	x8, :got:get_var_ref_check_1_asm_h
	ldr	x8, [x8, :got_lo12:get_var_ref_check_1_asm_h]
	str	x10, [x0, #2744]
	adrp	x10, :got:put_loc_check_init_1_asm_h
	ldr	x10, [x10, :got_lo12:put_loc_check_init_1_asm_h]
	str	x8, [x0, #2736]
	adrp	x8, :got:put_loc_check_1_asm_h
	ldr	x8, [x8, :got_lo12:put_loc_check_1_asm_h]
	str	x10, [x0, #2728]
	adrp	x10, :got:get_loc_check_1_asm_h
	ldr	x10, [x10, :got_lo12:get_loc_check_1_asm_h]
	str	x8, [x0, #2720]
	adrp	x8, :got:set_loc_uninitialized_1_asm_h
	ldr	x8, [x8, :got_lo12:set_loc_uninitialized_1_asm_h]
	str	x10, [x0, #2712]
	adrp	x10, :got:set_var_ref_1_asm_h
	ldr	x10, [x10, :got_lo12:set_var_ref_1_asm_h]
	str	x8, [x0, #2704]
	adrp	x8, :got:put_var_ref_1_asm_h
	ldr	x8, [x8, :got_lo12:put_var_ref_1_asm_h]
	str	x10, [x0, #2696]
	adrp	x10, :got:get_var_ref_1_asm_h
	ldr	x10, [x10, :got_lo12:get_var_ref_1_asm_h]
	str	x8, [x0, #2688]
	adrp	x8, :got:set_arg_1_asm_h
	ldr	x8, [x8, :got_lo12:set_arg_1_asm_h]
	str	x10, [x0, #2680]
	adrp	x10, :got:put_arg_1_asm_h
	ldr	x10, [x10, :got_lo12:put_arg_1_asm_h]
	str	x8, [x0, #2672]
	adrp	x8, :got:get_arg_1_asm_h
	ldr	x8, [x8, :got_lo12:get_arg_1_asm_h]
	str	x10, [x0, #2664]
	adrp	x10, :got:set_loc_1_asm_h
	ldr	x10, [x10, :got_lo12:set_loc_1_asm_h]
	str	x8, [x0, #2656]
	adrp	x8, :got:put_loc_1_asm_h
	ldr	x8, [x8, :got_lo12:put_loc_1_asm_h]
	str	x10, [x0, #2648]
	adrp	x10, :got:get_loc_1_asm_h
	ldr	x10, [x10, :got_lo12:get_loc_1_asm_h]
	str	x8, [x0, #2640]
	adrp	x8, :got:define_class_1_asm_h
	ldr	x8, [x8, :got_lo12:define_class_1_asm_h]
	str	x10, [x0, #2632]
	adrp	x10, :got:define_method_computed_1_asm_h
	ldr	x10, [x10, :got_lo12:define_method_computed_1_asm_h]
	str	x8, [x0, #2624]
	adrp	x8, :got:define_method_1_asm_h
	ldr	x8, [x8, :got_lo12:define_method_1_asm_h]
	str	x10, [x0, #2616]
	adrp	x10, :got:copy_data_properties_1_asm_h
	ldr	x10, [x10, :got_lo12:copy_data_properties_1_asm_h]
	str	x8, [x0, #2608]
	adrp	x8, :got:append_1_asm_h
	ldr	x8, [x8, :got_lo12:append_1_asm_h]
	str	x10, [x0, #2600]
	adrp	x10, :got:define_array_el_1_asm_h
	ldr	x10, [x10, :got_lo12:define_array_el_1_asm_h]
	str	x8, [x0, #2592]
	adrp	x8, :got:set_home_object_1_asm_h
	ldr	x8, [x8, :got_lo12:set_home_object_1_asm_h]
	str	x10, [x0, #2584]
	adrp	x10, :got:set_proto_1_asm_h
	ldr	x10, [x10, :got_lo12:set_proto_1_asm_h]
	str	x8, [x0, #2576]
	adrp	x8, :got:set_name_computed_1_asm_h
	ldr	x8, [x8, :got_lo12:set_name_computed_1_asm_h]
	str	x10, [x0, #2568]
	adrp	x10, :got:set_name_1_asm_h
	ldr	x10, [x10, :got_lo12:set_name_1_asm_h]
	str	x8, [x0, #2560]
	adrp	x8, :got:define_field_1_asm_h
	ldr	x8, [x8, :got_lo12:define_field_1_asm_h]
	str	x10, [x0, #2552]
	adrp	x10, :got:put_super_value_1_asm_h
	ldr	x10, [x10, :got_lo12:put_super_value_1_asm_h]
	str	x8, [x0, #2544]
	adrp	x8, :got:get_super_value_1_asm_h
	ldr	x8, [x8, :got_lo12:get_super_value_1_asm_h]
	str	x10, [x0, #2536]
	adrp	x10, :got:put_array_el_1_asm_h
	ldr	x10, [x10, :got_lo12:put_array_el_1_asm_h]
	str	x8, [x0, #2528]
	adrp	x8, :got:get_array_el2_1_asm_h
	ldr	x8, [x8, :got_lo12:get_array_el2_1_asm_h]
	str	x10, [x0, #2520]
	adrp	x10, :got:get_array_el_1_asm_h
	ldr	x10, [x10, :got_lo12:get_array_el_1_asm_h]
	str	x8, [x0, #2512]
	adrp	x8, :got:define_private_field_1_asm_h
	ldr	x8, [x8, :got_lo12:define_private_field_1_asm_h]
	str	x10, [x0, #2504]
	adrp	x10, :got:put_private_field_1_asm_h
	ldr	x10, [x10, :got_lo12:put_private_field_1_asm_h]
	str	x8, [x0, #2496]
	adrp	x8, :got:get_private_field_1_asm_h
	ldr	x8, [x8, :got_lo12:get_private_field_1_asm_h]
	str	x10, [x0, #2488]
	adrp	x10, :got:put_field_1_asm_h
	ldr	x10, [x10, :got_lo12:put_field_1_asm_h]
	str	x8, [x0, #2480]
	adrp	x8, :got:get_field2_1_asm_h
	ldr	x8, [x8, :got_lo12:get_field2_1_asm_h]
	str	x10, [x0, #2472]
	adrp	x10, :got:get_field_1_asm_h
	ldr	x10, [x10, :got_lo12:get_field_1_asm_h]
	str	x8, [x0, #2464]
	adrp	x8, :got:define_func_1_asm_h
	ldr	x8, [x8, :got_lo12:define_func_1_asm_h]
	str	x10, [x0, #2456]
	adrp	x10, :got:check_define_var_1_asm_h
	ldr	x10, [x10, :got_lo12:check_define_var_1_asm_h]
	str	x8, [x0, #2448]
	adrp	x8, :got:define_var_1_asm_h
	ldr	x8, [x8, :got_lo12:define_var_1_asm_h]
	str	x10, [x0, #2440]
	adrp	x10, :got:put_ref_value_1_asm_h
	ldr	x10, [x10, :got_lo12:put_ref_value_1_asm_h]
	str	x8, [x0, #2432]
	adrp	x8, :got:get_ref_value_1_asm_h
	ldr	x8, [x8, :got_lo12:get_ref_value_1_asm_h]
	str	x10, [x0, #2424]
	adrp	x10, :got:put_var_strict_1_asm_h
	ldr	x10, [x10, :got_lo12:put_var_strict_1_asm_h]
	str	x8, [x0, #2416]
	adrp	x8, :got:put_var_init_1_asm_h
	ldr	x8, [x8, :got_lo12:put_var_init_1_asm_h]
	str	x10, [x0, #2408]
	adrp	x10, :got:put_var_1_asm_h
	ldr	x10, [x10, :got_lo12:put_var_1_asm_h]
	str	x8, [x0, #2400]
	adrp	x8, :got:get_var_1_asm_h
	ldr	x8, [x8, :got_lo12:get_var_1_asm_h]
	str	x10, [x0, #2392]
	adrp	x10, :got:get_var_undef_1_asm_h
	ldr	x10, [x10, :got_lo12:get_var_undef_1_asm_h]
	str	x8, [x0, #2384]
	adrp	x8, :got:check_var_1_asm_h
	ldr	x8, [x8, :got_lo12:check_var_1_asm_h]
	str	x10, [x0, #2376]
	adrp	x10, :got:import_1_asm_h
	ldr	x10, [x10, :got_lo12:import_1_asm_h]
	str	x8, [x0, #2368]
	adrp	x8, :got:get_super_1_asm_h
	ldr	x8, [x8, :got_lo12:get_super_1_asm_h]
	str	x10, [x0, #2360]
	adrp	x10, :got:get_super_ctor_1_asm_h
	ldr	x10, [x10, :got_lo12:get_super_ctor_1_asm_h]
	str	x8, [x0, #2352]
	adrp	x8, :got:regexp_1_asm_h
	ldr	x8, [x8, :got_lo12:regexp_1_asm_h]
	str	x10, [x0, #2344]
	adrp	x10, :got:eval_1_asm_h
	ldr	x10, [x10, :got_lo12:eval_1_asm_h]
	str	x8, [x0, #2336]
	adrp	x8, :got:throw_var_1_asm_h
	ldr	x8, [x8, :got_lo12:throw_var_1_asm_h]
	str	x10, [x0, #2328]
	adrp	x10, :got:throw_1_asm_h
	ldr	x10, [x10, :got_lo12:throw_1_asm_h]
	str	x8, [x0, #2320]
	adrp	x8, :got:return_async_1_asm_h
	ldr	x8, [x8, :got_lo12:return_async_1_asm_h]
	str	x10, [x0, #2312]
	adrp	x10, :got:add_brand_1_asm_h
	ldr	x10, [x10, :got_lo12:add_brand_1_asm_h]
	str	x8, [x0, #2304]
	adrp	x8, :got:check_brand_1_asm_h
	ldr	x8, [x8, :got_lo12:check_brand_1_asm_h]
	str	x10, [x0, #2296]
	adrp	x10, :got:check_ctor_1_asm_h
	ldr	x10, [x10, :got_lo12:check_ctor_1_asm_h]
	str	x8, [x0, #2288]
	adrp	x8, :got:check_ctor_return_1_asm_h
	ldr	x8, [x8, :got_lo12:check_ctor_return_1_asm_h]
	str	x10, [x0, #2280]
	adrp	x10, :got:return_undef_1_asm_h
	ldr	x10, [x10, :got_lo12:return_undef_1_asm_h]
	str	x8, [x0, #2272]
	adrp	x8, :got:return_1_asm_h
	ldr	x8, [x8, :got_lo12:return_1_asm_h]
	str	x10, [x0, #2264]
	adrp	x10, :got:apply_1_asm_h
	ldr	x10, [x10, :got_lo12:apply_1_asm_h]
	str	x8, [x0, #2256]
	adrp	x8, :got:array_from_1_asm_h
	ldr	x8, [x8, :got_lo12:array_from_1_asm_h]
	str	x10, [x0, #2248]
	adrp	x10, :got:tail_call_method_1_asm_h
	ldr	x10, [x10, :got_lo12:tail_call_method_1_asm_h]
	str	x8, [x0, #2240]
	adrp	x8, :got:call_method_1_asm_h
	ldr	x8, [x8, :got_lo12:call_method_1_asm_h]
	str	x10, [x0, #2232]
	adrp	x10, :got:tail_call_1_asm_h
	ldr	x10, [x10, :got_lo12:tail_call_1_asm_h]
	str	x8, [x0, #2224]
	adrp	x8, :got:call_1_asm_h
	ldr	x8, [x8, :got_lo12:call_1_asm_h]
	str	x10, [x0, #2216]
	adrp	x10, :got:call_constructor_1_asm_h
	ldr	x10, [x10, :got_lo12:call_constructor_1_asm_h]
	str	x8, [x0, #2208]
	adrp	x8, :got:rot5l_1_asm_h
	ldr	x8, [x8, :got_lo12:rot5l_1_asm_h]
	str	x10, [x0, #2200]
	adrp	x10, :got:rot4l_1_asm_h
	ldr	x10, [x10, :got_lo12:rot4l_1_asm_h]
	str	x8, [x0, #2192]
	adrp	x8, :got:rot3r_1_asm_h
	ldr	x8, [x8, :got_lo12:rot3r_1_asm_h]
	str	x10, [x0, #2184]
	adrp	x10, :got:rot3l_1_asm_h
	ldr	x10, [x10, :got_lo12:rot3l_1_asm_h]
	str	x8, [x0, #2176]
	adrp	x8, :got:swap2_1_asm_h
	ldr	x8, [x8, :got_lo12:swap2_1_asm_h]
	str	x10, [x0, #2168]
	adrp	x10, :got:swap_1_asm_h
	ldr	x10, [x10, :got_lo12:swap_1_asm_h]
	str	x8, [x0, #2160]
	adrp	x8, :got:perm5_1_asm_h
	ldr	x8, [x8, :got_lo12:perm5_1_asm_h]
	str	x10, [x0, #2152]
	adrp	x10, :got:perm4_1_asm_h
	ldr	x10, [x10, :got_lo12:perm4_1_asm_h]
	str	x8, [x0, #2144]
	adrp	x8, :got:perm3_1_asm_h
	ldr	x8, [x8, :got_lo12:perm3_1_asm_h]
	str	x10, [x0, #2136]
	adrp	x10, :got:insert4_1_asm_h
	ldr	x10, [x10, :got_lo12:insert4_1_asm_h]
	str	x8, [x0, #2128]
	adrp	x8, :got:insert3_1_asm_h
	ldr	x8, [x8, :got_lo12:insert3_1_asm_h]
	str	x10, [x0, #2120]
	adrp	x10, :got:insert2_1_asm_h
	ldr	x10, [x10, :got_lo12:insert2_1_asm_h]
	str	x8, [x0, #2112]
	adrp	x8, :got:dup3_1_asm_h
	ldr	x8, [x8, :got_lo12:dup3_1_asm_h]
	str	x10, [x0, #2104]
	adrp	x10, :got:dup2_1_asm_h
	ldr	x10, [x10, :got_lo12:dup2_1_asm_h]
	str	x8, [x0, #2096]
	adrp	x8, :got:dup1_1_asm_h
	ldr	x8, [x8, :got_lo12:dup1_1_asm_h]
	str	x10, [x0, #2088]
	adrp	x10, :got:dup_1_asm_h
	ldr	x10, [x10, :got_lo12:dup_1_asm_h]
	str	x8, [x0, #2080]
	adrp	x8, :got:nip1_1_asm_h
	ldr	x8, [x8, :got_lo12:nip1_1_asm_h]
	str	x10, [x0, #2072]
	adrp	x10, :got:nip_1_asm_h
	ldr	x10, [x10, :got_lo12:nip_1_asm_h]
	str	x8, [x0, #2064]
	adrp	x8, :got:drop_1_asm_h
	ldr	x8, [x8, :got_lo12:drop_1_asm_h]
	str	x10, [x0, #2056]
	adrp	x10, :got:rest_1_asm_h
	ldr	x10, [x10, :got_lo12:rest_1_asm_h]
	str	x8, [x0, #2048]
	adrp	x8, :got:special_object_1_asm_h
	ldr	x8, [x8, :got_lo12:special_object_1_asm_h]
	str	x10, [x0, #2040]
	adrp	x10, :got:set_var_ref0_1_asm_h
	ldr	x10, [x10, :got_lo12:set_var_ref0_1_asm_h]
	str	x8, [x0, #2032]
	adrp	x8, :got:set_var_ref1_1_asm_h
	ldr	x8, [x8, :got_lo12:set_var_ref1_1_asm_h]
	str	x10, [x0, #3744]
	adrp	x10, :got:set_var_ref2_1_asm_h
	ldr	x10, [x10, :got_lo12:set_var_ref2_1_asm_h]
	str	x8, [x0, #3752]
	adrp	x8, :got:set_var_ref3_1_asm_h
	ldr	x8, [x8, :got_lo12:set_var_ref3_1_asm_h]
	str	x10, [x0, #3760]
	adrp	x10, :got:get_length_1_asm_h
	ldr	x10, [x10, :got_lo12:get_length_1_asm_h]
	str	x8, [x0, #3768]
	adrp	x8, :got:if_false8_1_asm_h
	ldr	x8, [x8, :got_lo12:if_false8_1_asm_h]
	str	x10, [x0, #3776]
	adrp	x10, :got:if_true8_1_asm_h
	ldr	x10, [x10, :got_lo12:if_true8_1_asm_h]
	str	x8, [x0, #3784]
	adrp	x8, :got:goto8_1_asm_h
	ldr	x8, [x8, :got_lo12:goto8_1_asm_h]
	str	x10, [x0, #3792]
	adrp	x10, :got:goto16_1_asm_h
	ldr	x10, [x10, :got_lo12:goto16_1_asm_h]
	str	x8, [x0, #3800]
	adrp	x8, :got:call0_1_asm_h
	ldr	x8, [x8, :got_lo12:call0_1_asm_h]
	str	x10, [x0, #3808]
	adrp	x10, :got:call1_1_asm_h
	ldr	x10, [x10, :got_lo12:call1_1_asm_h]
	str	x8, [x0, #3816]
	adrp	x8, :got:call2_1_asm_h
	ldr	x8, [x8, :got_lo12:call2_1_asm_h]
	str	x10, [x0, #3824]
	adrp	x10, :got:call3_1_asm_h
	ldr	x10, [x10, :got_lo12:call3_1_asm_h]
	str	x8, [x0, #3832]
	adrp	x8, :got:is_undefined_1_asm_h
	ldr	x8, [x8, :got_lo12:is_undefined_1_asm_h]
	str	x10, [x0, #3840]
	adrp	x10, :got:is_null_1_asm_h
	ldr	x10, [x10, :got_lo12:is_null_1_asm_h]
	str	x8, [x0, #3848]
	adrp	x8, :got:is_function_1_asm_h
	ldr	x8, [x8, :got_lo12:is_function_1_asm_h]
	str	x10, [x0, #3856]
	adrp	x10, :got:invalid_2_asm_h
	ldr	x10, [x10, :got_lo12:invalid_2_asm_h]
	str	x8, [x0, #3864]
	adrp	x8, :got:push_i32_2_asm_h
	ldr	x8, [x8, :got_lo12:push_i32_2_asm_h]
	str	x10, [x0, #3872]
	adrp	x10, :got:push_const_2_asm_h
	ldr	x10, [x10, :got_lo12:push_const_2_asm_h]
	str	x8, [x0, #3880]
	adrp	x8, :got:fclosure_2_asm_h
	ldr	x8, [x8, :got_lo12:fclosure_2_asm_h]
	str	x10, [x0, #3888]
	adrp	x10, :got:push_atom_value_2_asm_h
	ldr	x10, [x10, :got_lo12:push_atom_value_2_asm_h]
	str	x8, [x0, #3896]
	adrp	x8, :got:private_symbol_2_asm_h
	ldr	x8, [x8, :got_lo12:private_symbol_2_asm_h]
	str	x10, [x0, #3904]
	adrp	x10, :got:undefined_2_asm_h
	ldr	x10, [x10, :got_lo12:undefined_2_asm_h]
	str	x8, [x0, #3912]
	adrp	x8, :got:null_2_asm_h
	ldr	x8, [x8, :got_lo12:null_2_asm_h]
	str	x10, [x0, #3920]
	adrp	x10, :got:push_this_2_asm_h
	ldr	x10, [x10, :got_lo12:push_this_2_asm_h]
	str	x8, [x0, #3928]
	adrp	x8, :got:push_false_2_asm_h
	ldr	x8, [x8, :got_lo12:push_false_2_asm_h]
	str	x10, [x0, #3936]
	adrp	x10, :got:push_true_2_asm_h
	ldr	x10, [x10, :got_lo12:push_true_2_asm_h]
	str	x8, [x0, #3944]
	adrp	x8, :got:object_2_asm_h
	ldr	x8, [x8, :got_lo12:object_2_asm_h]
	str	x10, [x0, #3952]
	adrp	x10, :got:special_object_2_asm_h
	ldr	x10, [x10, :got_lo12:special_object_2_asm_h]
	str	x8, [x0, #3960]
	adrp	x8, :got:rest_2_asm_h
	ldr	x8, [x8, :got_lo12:rest_2_asm_h]
	str	x10, [x0, #3968]
	adrp	x10, :got:drop_2_asm_h
	ldr	x10, [x10, :got_lo12:drop_2_asm_h]
	str	x8, [x0, #3976]
	adrp	x8, :got:nip_2_asm_h
	ldr	x8, [x8, :got_lo12:nip_2_asm_h]
	str	x10, [x0, #3984]
	adrp	x10, :got:nip1_2_asm_h
	ldr	x10, [x10, :got_lo12:nip1_2_asm_h]
	str	x8, [x0, #3992]
	adrp	x8, :got:dup_2_asm_h
	ldr	x8, [x8, :got_lo12:dup_2_asm_h]
	str	x10, [x0, #4000]
	adrp	x10, :got:dup1_2_asm_h
	ldr	x10, [x10, :got_lo12:dup1_2_asm_h]
	str	x8, [x0, #4008]
	adrp	x8, :got:dup2_2_asm_h
	ldr	x8, [x8, :got_lo12:dup2_2_asm_h]
	str	x10, [x0, #4016]
	adrp	x10, :got:dup3_2_asm_h
	ldr	x10, [x10, :got_lo12:dup3_2_asm_h]
	str	x8, [x0, #4024]
	adrp	x8, :got:insert2_2_asm_h
	ldr	x8, [x8, :got_lo12:insert2_2_asm_h]
	str	x10, [x0, #4032]
	adrp	x10, :got:insert3_2_asm_h
	ldr	x10, [x10, :got_lo12:insert3_2_asm_h]
	str	x8, [x0, #4040]
	adrp	x8, :got:insert4_2_asm_h
	ldr	x8, [x8, :got_lo12:insert4_2_asm_h]
	str	x10, [x0, #4048]
	adrp	x10, :got:perm3_2_asm_h
	ldr	x10, [x10, :got_lo12:perm3_2_asm_h]
	str	x8, [x0, #4056]
	adrp	x8, :got:perm4_2_asm_h
	ldr	x8, [x8, :got_lo12:perm4_2_asm_h]
	str	x10, [x0, #4064]
	adrp	x10, :got:perm5_2_asm_h
	ldr	x10, [x10, :got_lo12:perm5_2_asm_h]
	str	x8, [x0, #4072]
	adrp	x8, :got:swap_2_asm_h
	ldr	x8, [x8, :got_lo12:swap_2_asm_h]
	str	x10, [x0, #4080]
	adrp	x10, :got:swap2_2_asm_h
	ldr	x10, [x10, :got_lo12:swap2_2_asm_h]
	str	x8, [x0, #4088]
	adrp	x8, :got:rot3l_2_asm_h
	ldr	x8, [x8, :got_lo12:rot3l_2_asm_h]
	str	x10, [x0, #4096]
	adrp	x10, :got:rot3r_2_asm_h
	ldr	x10, [x10, :got_lo12:rot3r_2_asm_h]
	str	x8, [x0, #4104]
	adrp	x8, :got:rot4l_2_asm_h
	ldr	x8, [x8, :got_lo12:rot4l_2_asm_h]
	str	x10, [x0, #4112]
	adrp	x10, :got:rot5l_2_asm_h
	ldr	x10, [x10, :got_lo12:rot5l_2_asm_h]
	str	x8, [x0, #4120]
	adrp	x8, :got:call_constructor_2_asm_h
	ldr	x8, [x8, :got_lo12:call_constructor_2_asm_h]
	str	x10, [x0, #4128]
	adrp	x10, :got:call_2_asm_h
	ldr	x10, [x10, :got_lo12:call_2_asm_h]
	str	x8, [x0, #4136]
	adrp	x8, :got:tail_call_2_asm_h
	ldr	x8, [x8, :got_lo12:tail_call_2_asm_h]
	str	x10, [x0, #4144]
	adrp	x10, :got:call_method_2_asm_h
	ldr	x10, [x10, :got_lo12:call_method_2_asm_h]
	str	x8, [x0, #4152]
	adrp	x8, :got:tail_call_method_2_asm_h
	ldr	x8, [x8, :got_lo12:tail_call_method_2_asm_h]
	str	x10, [x0, #4160]
	adrp	x10, :got:array_from_2_asm_h
	ldr	x10, [x10, :got_lo12:array_from_2_asm_h]
	str	x8, [x0, #4168]
	adrp	x8, :got:apply_2_asm_h
	ldr	x8, [x8, :got_lo12:apply_2_asm_h]
	str	x10, [x0, #4176]
	adrp	x10, :got:return_2_asm_h
	ldr	x10, [x10, :got_lo12:return_2_asm_h]
	str	x8, [x0, #4184]
	adrp	x8, :got:return_undef_2_asm_h
	ldr	x8, [x8, :got_lo12:return_undef_2_asm_h]
	str	x10, [x0, #4192]
	adrp	x10, :got:check_ctor_return_2_asm_h
	ldr	x10, [x10, :got_lo12:check_ctor_return_2_asm_h]
	str	x8, [x0, #4200]
	adrp	x8, :got:check_ctor_2_asm_h
	ldr	x8, [x8, :got_lo12:check_ctor_2_asm_h]
	str	x10, [x0, #4208]
	adrp	x10, :got:check_brand_2_asm_h
	ldr	x10, [x10, :got_lo12:check_brand_2_asm_h]
	str	x8, [x0, #4216]
	adrp	x8, :got:add_brand_2_asm_h
	ldr	x8, [x8, :got_lo12:add_brand_2_asm_h]
	str	x10, [x0, #4224]
	adrp	x10, :got:return_async_2_asm_h
	ldr	x10, [x10, :got_lo12:return_async_2_asm_h]
	str	x8, [x0, #4232]
	adrp	x8, :got:throw_2_asm_h
	ldr	x8, [x8, :got_lo12:throw_2_asm_h]
	str	x10, [x0, #4240]
	adrp	x10, :got:throw_var_2_asm_h
	ldr	x10, [x10, :got_lo12:throw_var_2_asm_h]
	str	x8, [x0, #4248]
	adrp	x8, :got:eval_2_asm_h
	ldr	x8, [x8, :got_lo12:eval_2_asm_h]
	str	x10, [x0, #4256]
	adrp	x10, :got:regexp_2_asm_h
	ldr	x10, [x10, :got_lo12:regexp_2_asm_h]
	str	x8, [x0, #4264]
	adrp	x8, :got:get_super_ctor_2_asm_h
	ldr	x8, [x8, :got_lo12:get_super_ctor_2_asm_h]
	str	x10, [x0, #4272]
	adrp	x10, :got:get_super_2_asm_h
	ldr	x10, [x10, :got_lo12:get_super_2_asm_h]
	str	x8, [x0, #4280]
	adrp	x8, :got:import_2_asm_h
	ldr	x8, [x8, :got_lo12:import_2_asm_h]
	str	x10, [x0, #4288]
	adrp	x10, :got:check_var_2_asm_h
	ldr	x10, [x10, :got_lo12:check_var_2_asm_h]
	str	x8, [x0, #4296]
	adrp	x8, :got:get_var_undef_2_asm_h
	ldr	x8, [x8, :got_lo12:get_var_undef_2_asm_h]
	str	x10, [x0, #4304]
	adrp	x10, :got:get_var_2_asm_h
	ldr	x10, [x10, :got_lo12:get_var_2_asm_h]
	str	x8, [x0, #4312]
	adrp	x8, :got:put_var_2_asm_h
	ldr	x8, [x8, :got_lo12:put_var_2_asm_h]
	str	x10, [x0, #4320]
	adrp	x10, :got:put_var_init_2_asm_h
	ldr	x10, [x10, :got_lo12:put_var_init_2_asm_h]
	str	x8, [x0, #4328]
	adrp	x8, :got:put_var_strict_2_asm_h
	ldr	x8, [x8, :got_lo12:put_var_strict_2_asm_h]
	str	x10, [x0, #4336]
	adrp	x10, :got:get_ref_value_2_asm_h
	ldr	x10, [x10, :got_lo12:get_ref_value_2_asm_h]
	str	x8, [x0, #4344]
	adrp	x8, :got:put_ref_value_2_asm_h
	ldr	x8, [x8, :got_lo12:put_ref_value_2_asm_h]
	str	x10, [x0, #4352]
	adrp	x10, :got:define_var_2_asm_h
	ldr	x10, [x10, :got_lo12:define_var_2_asm_h]
	str	x8, [x0, #4360]
	adrp	x8, :got:check_define_var_2_asm_h
	ldr	x8, [x8, :got_lo12:check_define_var_2_asm_h]
	str	x10, [x0, #4368]
	adrp	x10, :got:define_func_2_asm_h
	ldr	x10, [x10, :got_lo12:define_func_2_asm_h]
	str	x8, [x0, #4376]
	adrp	x8, :got:get_field_2_asm_h
	ldr	x8, [x8, :got_lo12:get_field_2_asm_h]
	str	x10, [x0, #4384]
	adrp	x10, :got:get_field2_2_asm_h
	ldr	x10, [x10, :got_lo12:get_field2_2_asm_h]
	str	x8, [x0, #4392]
	adrp	x8, :got:put_field_2_asm_h
	ldr	x8, [x8, :got_lo12:put_field_2_asm_h]
	str	x10, [x0, #4400]
	adrp	x10, :got:get_private_field_2_asm_h
	ldr	x10, [x10, :got_lo12:get_private_field_2_asm_h]
	str	x8, [x0, #4408]
	adrp	x8, :got:put_private_field_2_asm_h
	ldr	x8, [x8, :got_lo12:put_private_field_2_asm_h]
	str	x10, [x0, #4416]
	adrp	x10, :got:define_private_field_2_asm_h
	ldr	x10, [x10, :got_lo12:define_private_field_2_asm_h]
	str	x8, [x0, #4424]
	adrp	x8, :got:get_array_el_2_asm_h
	ldr	x8, [x8, :got_lo12:get_array_el_2_asm_h]
	str	x10, [x0, #4432]
	adrp	x10, :got:get_array_el2_2_asm_h
	ldr	x10, [x10, :got_lo12:get_array_el2_2_asm_h]
	str	x8, [x0, #4440]
	adrp	x8, :got:put_array_el_2_asm_h
	ldr	x8, [x8, :got_lo12:put_array_el_2_asm_h]
	str	x10, [x0, #4448]
	adrp	x10, :got:get_super_value_2_asm_h
	ldr	x10, [x10, :got_lo12:get_super_value_2_asm_h]
	str	x8, [x0, #4456]
	adrp	x8, :got:put_super_value_2_asm_h
	ldr	x8, [x8, :got_lo12:put_super_value_2_asm_h]
	str	x10, [x0, #4464]
	adrp	x10, :got:define_field_2_asm_h
	ldr	x10, [x10, :got_lo12:define_field_2_asm_h]
	str	x8, [x0, #4472]
	adrp	x8, :got:set_name_2_asm_h
	ldr	x8, [x8, :got_lo12:set_name_2_asm_h]
	str	x10, [x0, #4480]
	adrp	x10, :got:set_name_computed_2_asm_h
	ldr	x10, [x10, :got_lo12:set_name_computed_2_asm_h]
	str	x8, [x0, #4488]
	adrp	x8, :got:set_proto_2_asm_h
	ldr	x8, [x8, :got_lo12:set_proto_2_asm_h]
	str	x10, [x0, #4496]
	adrp	x10, :got:set_home_object_2_asm_h
	ldr	x10, [x10, :got_lo12:set_home_object_2_asm_h]
	str	x8, [x0, #4504]
	adrp	x8, :got:define_array_el_2_asm_h
	ldr	x8, [x8, :got_lo12:define_array_el_2_asm_h]
	str	x10, [x0, #4512]
	adrp	x10, :got:append_2_asm_h
	ldr	x10, [x10, :got_lo12:append_2_asm_h]
	str	x8, [x0, #4520]
	adrp	x8, :got:copy_data_properties_2_asm_h
	ldr	x8, [x8, :got_lo12:copy_data_properties_2_asm_h]
	str	x10, [x0, #4528]
	adrp	x10, :got:define_method_2_asm_h
	ldr	x10, [x10, :got_lo12:define_method_2_asm_h]
	str	x8, [x0, #4536]
	adrp	x8, :got:define_method_computed_2_asm_h
	ldr	x8, [x8, :got_lo12:define_method_computed_2_asm_h]
	str	x10, [x0, #4544]
	adrp	x10, :got:define_class_2_asm_h
	ldr	x10, [x10, :got_lo12:define_class_2_asm_h]
	str	x8, [x0, #4552]
	adrp	x8, :got:get_loc_2_asm_h
	ldr	x8, [x8, :got_lo12:get_loc_2_asm_h]
	str	x10, [x0, #4560]
	adrp	x10, :got:put_loc_2_asm_h
	ldr	x10, [x10, :got_lo12:put_loc_2_asm_h]
	str	x8, [x0, #4568]
	adrp	x8, :got:set_loc_2_asm_h
	ldr	x8, [x8, :got_lo12:set_loc_2_asm_h]
	str	x10, [x0, #4576]
	adrp	x10, :got:get_arg_2_asm_h
	ldr	x10, [x10, :got_lo12:get_arg_2_asm_h]
	str	x8, [x0, #4584]
	adrp	x8, :got:put_arg_2_asm_h
	ldr	x8, [x8, :got_lo12:put_arg_2_asm_h]
	str	x10, [x0, #4592]
	adrp	x10, :got:set_arg_2_asm_h
	ldr	x10, [x10, :got_lo12:set_arg_2_asm_h]
	str	x8, [x0, #4600]
	adrp	x8, :got:get_var_ref_2_asm_h
	ldr	x8, [x8, :got_lo12:get_var_ref_2_asm_h]
	str	x10, [x0, #4608]
	adrp	x10, :got:put_var_ref_2_asm_h
	ldr	x10, [x10, :got_lo12:put_var_ref_2_asm_h]
	str	x8, [x0, #4616]
	adrp	x8, :got:set_var_ref_2_asm_h
	ldr	x8, [x8, :got_lo12:set_var_ref_2_asm_h]
	str	x10, [x0, #4624]
	adrp	x10, :got:set_loc_uninitialized_2_asm_h
	ldr	x10, [x10, :got_lo12:set_loc_uninitialized_2_asm_h]
	str	x8, [x0, #4632]
	adrp	x8, :got:get_loc_check_2_asm_h
	ldr	x8, [x8, :got_lo12:get_loc_check_2_asm_h]
	str	x10, [x0, #4640]
	adrp	x10, :got:put_loc_check_2_asm_h
	ldr	x10, [x10, :got_lo12:put_loc_check_2_asm_h]
	str	x8, [x0, #4648]
	adrp	x8, :got:put_loc_check_init_2_asm_h
	ldr	x8, [x8, :got_lo12:put_loc_check_init_2_asm_h]
	str	x10, [x0, #4656]
	adrp	x10, :got:get_var_ref_check_2_asm_h
	ldr	x10, [x10, :got_lo12:get_var_ref_check_2_asm_h]
	str	x8, [x0, #4664]
	adrp	x8, :got:put_var_ref_check_2_asm_h
	ldr	x8, [x8, :got_lo12:put_var_ref_check_2_asm_h]
	str	x10, [x0, #4672]
	adrp	x10, :got:put_var_ref_check_init_2_asm_h
	ldr	x10, [x10, :got_lo12:put_var_ref_check_init_2_asm_h]
	str	x8, [x0, #4680]
	adrp	x8, :got:close_loc_2_asm_h
	ldr	x8, [x8, :got_lo12:close_loc_2_asm_h]
	str	x10, [x0, #4688]
	adrp	x10, :got:if_false_2_asm_h
	ldr	x10, [x10, :got_lo12:if_false_2_asm_h]
	str	x8, [x0, #4696]
	adrp	x8, :got:if_true_2_asm_h
	ldr	x8, [x8, :got_lo12:if_true_2_asm_h]
	str	x10, [x0, #4704]
	adrp	x10, :got:goto_2_asm_h
	ldr	x10, [x10, :got_lo12:goto_2_asm_h]
	str	x8, [x0, #4712]
	adrp	x8, :got:catch_2_asm_h
	ldr	x8, [x8, :got_lo12:catch_2_asm_h]
	str	x10, [x0, #4720]
	adrp	x10, :got:gosub_2_asm_h
	ldr	x10, [x10, :got_lo12:gosub_2_asm_h]
	str	x8, [x0, #4728]
	adrp	x8, :got:ret_2_asm_h
	ldr	x8, [x8, :got_lo12:ret_2_asm_h]
	str	x10, [x0, #4736]
	adrp	x10, :got:to_object_2_asm_h
	ldr	x10, [x10, :got_lo12:to_object_2_asm_h]
	str	x8, [x0, #4744]
	adrp	x8, :got:to_propkey_2_asm_h
	ldr	x8, [x8, :got_lo12:to_propkey_2_asm_h]
	str	x10, [x0, #4752]
	adrp	x10, :got:to_propkey2_2_asm_h
	ldr	x10, [x10, :got_lo12:to_propkey2_2_asm_h]
	str	x8, [x0, #4760]
	adrp	x8, :got:with_get_var_2_asm_h
	ldr	x8, [x8, :got_lo12:with_get_var_2_asm_h]
	str	x10, [x0, #4768]
	adrp	x10, :got:with_put_var_2_asm_h
	ldr	x10, [x10, :got_lo12:with_put_var_2_asm_h]
	str	x8, [x0, #4776]
	adrp	x8, :got:with_delete_var_2_asm_h
	ldr	x8, [x8, :got_lo12:with_delete_var_2_asm_h]
	str	x10, [x0, #4784]
	adrp	x10, :got:with_make_ref_2_asm_h
	ldr	x10, [x10, :got_lo12:with_make_ref_2_asm_h]
	str	x8, [x0, #4792]
	adrp	x8, :got:with_get_ref_2_asm_h
	ldr	x8, [x8, :got_lo12:with_get_ref_2_asm_h]
	str	x10, [x0, #4800]
	adrp	x10, :got:with_get_ref_undef_2_asm_h
	ldr	x10, [x10, :got_lo12:with_get_ref_undef_2_asm_h]
	str	x8, [x0, #4808]
	adrp	x8, :got:make_loc_ref_2_asm_h
	ldr	x8, [x8, :got_lo12:make_loc_ref_2_asm_h]
	str	x10, [x0, #4816]
	adrp	x10, :got:make_arg_ref_2_asm_h
	ldr	x10, [x10, :got_lo12:make_arg_ref_2_asm_h]
	str	x8, [x0, #4824]
	adrp	x8, :got:make_var_ref_ref_2_asm_h
	ldr	x8, [x8, :got_lo12:make_var_ref_ref_2_asm_h]
	str	x10, [x0, #4832]
	adrp	x10, :got:make_var_ref_2_asm_h
	ldr	x10, [x10, :got_lo12:make_var_ref_2_asm_h]
	str	x8, [x0, #4840]
	adrp	x8, :got:for_in_start_2_asm_h
	ldr	x8, [x8, :got_lo12:for_in_start_2_asm_h]
	str	x10, [x0, #4848]
	adrp	x10, :got:for_of_start_2_asm_h
	ldr	x10, [x10, :got_lo12:for_of_start_2_asm_h]
	str	x8, [x0, #4856]
	adrp	x8, :got:for_await_of_start_2_asm_h
	ldr	x8, [x8, :got_lo12:for_await_of_start_2_asm_h]
	str	x10, [x0, #4864]
	adrp	x10, :got:for_in_next_2_asm_h
	ldr	x10, [x10, :got_lo12:for_in_next_2_asm_h]
	str	x8, [x0, #4872]
	adrp	x8, :got:for_of_next_2_asm_h
	ldr	x8, [x8, :got_lo12:for_of_next_2_asm_h]
	str	x10, [x0, #4880]
	adrp	x10, :got:for_await_of_next_2_asm_h
	ldr	x10, [x10, :got_lo12:for_await_of_next_2_asm_h]
	str	x8, [x0, #4888]
	adrp	x8, :got:iterator_get_value_done_2_asm_h
	ldr	x8, [x8, :got_lo12:iterator_get_value_done_2_asm_h]
	str	x10, [x0, #4896]
	adrp	x10, :got:iterator_close_2_asm_h
	ldr	x10, [x10, :got_lo12:iterator_close_2_asm_h]
	str	x8, [x0, #4904]
	adrp	x8, :got:iterator_close_return_2_asm_h
	ldr	x8, [x8, :got_lo12:iterator_close_return_2_asm_h]
	str	x10, [x0, #4912]
	adrp	x10, :got:async_iterator_close_2_asm_h
	ldr	x10, [x10, :got_lo12:async_iterator_close_2_asm_h]
	str	x8, [x0, #4920]
	adrp	x8, :got:async_iterator_next_2_asm_h
	ldr	x8, [x8, :got_lo12:async_iterator_next_2_asm_h]
	str	x10, [x0, #4928]
	adrp	x10, :got:async_iterator_get_2_asm_h
	ldr	x10, [x10, :got_lo12:async_iterator_get_2_asm_h]
	str	x8, [x0, #4936]
	adrp	x8, :got:initial_yield_2_asm_h
	ldr	x8, [x8, :got_lo12:initial_yield_2_asm_h]
	str	x10, [x0, #4944]
	adrp	x10, :got:yield_2_asm_h
	ldr	x10, [x10, :got_lo12:yield_2_asm_h]
	str	x8, [x0, #4952]
	adrp	x8, :got:yield_star_2_asm_h
	ldr	x8, [x8, :got_lo12:yield_star_2_asm_h]
	str	x10, [x0, #4960]
	adrp	x10, :got:async_yield_star_2_asm_h
	ldr	x10, [x10, :got_lo12:async_yield_star_2_asm_h]
	str	x8, [x0, #4968]
	adrp	x8, :got:await_2_asm_h
	ldr	x8, [x8, :got_lo12:await_2_asm_h]
	str	x10, [x0, #4976]
	adrp	x10, :got:neg_2_asm_h
	ldr	x10, [x10, :got_lo12:neg_2_asm_h]
	str	x8, [x0, #4984]
	adrp	x8, :got:plus_2_asm_h
	ldr	x8, [x8, :got_lo12:plus_2_asm_h]
	str	x10, [x0, #4992]
	adrp	x10, :got:dec_2_asm_h
	ldr	x10, [x10, :got_lo12:dec_2_asm_h]
	str	x8, [x0, #5000]
	adrp	x8, :got:inc_2_asm_h
	ldr	x8, [x8, :got_lo12:inc_2_asm_h]
	str	x10, [x0, #5008]
	adrp	x10, :got:post_dec_2_asm_h
	ldr	x10, [x10, :got_lo12:post_dec_2_asm_h]
	str	x8, [x0, #5016]
	adrp	x8, :got:post_inc_2_asm_h
	ldr	x8, [x8, :got_lo12:post_inc_2_asm_h]
	str	x10, [x0, #5024]
	adrp	x10, :got:dec_loc_2_asm_h
	ldr	x10, [x10, :got_lo12:dec_loc_2_asm_h]
	str	x8, [x0, #5032]
	adrp	x8, :got:inc_loc_2_asm_h
	ldr	x8, [x8, :got_lo12:inc_loc_2_asm_h]
	str	x10, [x0, #5040]
	adrp	x10, :got:add_loc_2_asm_h
	ldr	x10, [x10, :got_lo12:add_loc_2_asm_h]
	str	x8, [x0, #5048]
	adrp	x8, :got:not_2_asm_h
	ldr	x8, [x8, :got_lo12:not_2_asm_h]
	str	x10, [x0, #5056]
	adrp	x10, :got:lnot_2_asm_h
	ldr	x10, [x10, :got_lo12:lnot_2_asm_h]
	str	x8, [x0, #5064]
	adrp	x8, :got:typeof_2_asm_h
	ldr	x8, [x8, :got_lo12:typeof_2_asm_h]
	str	x10, [x0, #5072]
	adrp	x10, :got:delete_2_asm_h
	ldr	x10, [x10, :got_lo12:delete_2_asm_h]
	str	x8, [x0, #5080]
	adrp	x8, :got:delete_var_2_asm_h
	ldr	x8, [x8, :got_lo12:delete_var_2_asm_h]
	str	x10, [x0, #5088]
	adrp	x10, :got:mul_2_asm_h
	ldr	x10, [x10, :got_lo12:mul_2_asm_h]
	str	x8, [x0, #5096]
	adrp	x8, :got:div_2_asm_h
	ldr	x8, [x8, :got_lo12:div_2_asm_h]
	str	x10, [x0, #5104]
	adrp	x10, :got:mod_2_asm_h
	ldr	x10, [x10, :got_lo12:mod_2_asm_h]
	str	x8, [x0, #5112]
	adrp	x8, :got:add_2_asm_h
	ldr	x8, [x8, :got_lo12:add_2_asm_h]
	str	x10, [x0, #5120]
	adrp	x10, :got:sub_2_asm_h
	ldr	x10, [x10, :got_lo12:sub_2_asm_h]
	str	x8, [x0, #5128]
	adrp	x8, :got:pow_2_asm_h
	ldr	x8, [x8, :got_lo12:pow_2_asm_h]
	str	x10, [x0, #5136]
	adrp	x10, :got:shl_2_asm_h
	ldr	x10, [x10, :got_lo12:shl_2_asm_h]
	str	x8, [x0, #5144]
	adrp	x8, :got:sar_2_asm_h
	ldr	x8, [x8, :got_lo12:sar_2_asm_h]
	str	x10, [x0, #5152]
	adrp	x10, :got:shr_2_asm_h
	ldr	x10, [x10, :got_lo12:shr_2_asm_h]
	str	x8, [x0, #5160]
	adrp	x8, :got:lt_2_asm_h
	ldr	x8, [x8, :got_lo12:lt_2_asm_h]
	str	x10, [x0, #5168]
	adrp	x10, :got:lte_2_asm_h
	ldr	x10, [x10, :got_lo12:lte_2_asm_h]
	str	x8, [x0, #5176]
	adrp	x8, :got:gt_2_asm_h
	ldr	x8, [x8, :got_lo12:gt_2_asm_h]
	str	x10, [x0, #5184]
	adrp	x10, :got:gte_2_asm_h
	ldr	x10, [x10, :got_lo12:gte_2_asm_h]
	str	x8, [x0, #5192]
	adrp	x8, :got:instanceof_2_asm_h
	ldr	x8, [x8, :got_lo12:instanceof_2_asm_h]
	str	x10, [x0, #5200]
	adrp	x10, :got:in_2_asm_h
	ldr	x10, [x10, :got_lo12:in_2_asm_h]
	str	x8, [x0, #5208]
	adrp	x8, :got:eq_2_asm_h
	ldr	x8, [x8, :got_lo12:eq_2_asm_h]
	str	x10, [x0, #5216]
	adrp	x10, :got:neq_2_asm_h
	ldr	x10, [x10, :got_lo12:neq_2_asm_h]
	str	x8, [x0, #5224]
	adrp	x8, :got:strict_eq_2_asm_h
	ldr	x8, [x8, :got_lo12:strict_eq_2_asm_h]
	str	x10, [x0, #5232]
	adrp	x10, :got:strict_neq_2_asm_h
	ldr	x10, [x10, :got_lo12:strict_neq_2_asm_h]
	str	x8, [x0, #5240]
	adrp	x8, :got:and_2_asm_h
	ldr	x8, [x8, :got_lo12:and_2_asm_h]
	str	x10, [x0, #5248]
	adrp	x10, :got:xor_2_asm_h
	ldr	x10, [x10, :got_lo12:xor_2_asm_h]
	str	x8, [x0, #5256]
	adrp	x8, :got:or_2_asm_h
	ldr	x8, [x8, :got_lo12:or_2_asm_h]
	str	x10, [x0, #5264]
	adrp	x10, :got:nop_2_asm_h
	ldr	x10, [x10, :got_lo12:nop_2_asm_h]
	str	x8, [x0, #5272]
	adrp	x8, :got:push_minus1_2_asm_h
	ldr	x8, [x8, :got_lo12:push_minus1_2_asm_h]
	str	x10, [x0, #5280]
	adrp	x10, :got:push_0_2_asm_h
	ldr	x10, [x10, :got_lo12:push_0_2_asm_h]
	str	x8, [x0, #5288]
	adrp	x8, :got:push_1_2_asm_h
	ldr	x8, [x8, :got_lo12:push_1_2_asm_h]
	str	x10, [x0, #5296]
	adrp	x10, :got:push_2_2_asm_h
	ldr	x10, [x10, :got_lo12:push_2_2_asm_h]
	str	x8, [x0, #5304]
	adrp	x8, :got:push_3_2_asm_h
	ldr	x8, [x8, :got_lo12:push_3_2_asm_h]
	str	x10, [x0, #5312]
	adrp	x10, :got:push_4_2_asm_h
	ldr	x10, [x10, :got_lo12:push_4_2_asm_h]
	str	x8, [x0, #5320]
	adrp	x8, :got:push_5_2_asm_h
	ldr	x8, [x8, :got_lo12:push_5_2_asm_h]
	str	x10, [x0, #5328]
	adrp	x10, :got:push_6_2_asm_h
	ldr	x10, [x10, :got_lo12:push_6_2_asm_h]
	str	x8, [x0, #5336]
	adrp	x8, :got:push_7_2_asm_h
	ldr	x8, [x8, :got_lo12:push_7_2_asm_h]
	str	x10, [x0, #5344]
	adrp	x10, :got:push_i8_2_asm_h
	ldr	x10, [x10, :got_lo12:push_i8_2_asm_h]
	str	x8, [x0, #5352]
	adrp	x8, :got:push_i16_2_asm_h
	ldr	x8, [x8, :got_lo12:push_i16_2_asm_h]
	str	x10, [x0, #5360]
	adrp	x10, :got:push_const8_2_asm_h
	ldr	x10, [x10, :got_lo12:push_const8_2_asm_h]
	str	x8, [x0, #5368]
	adrp	x8, :got:fclosure8_2_asm_h
	ldr	x8, [x8, :got_lo12:fclosure8_2_asm_h]
	str	x10, [x0, #5376]
	adrp	x10, :got:push_empty_string_2_asm_h
	ldr	x10, [x10, :got_lo12:push_empty_string_2_asm_h]
	str	x8, [x0, #5384]
	adrp	x8, :got:get_loc8_2_asm_h
	ldr	x8, [x8, :got_lo12:get_loc8_2_asm_h]
	str	x10, [x0, #5392]
	adrp	x10, :got:put_loc8_2_asm_h
	ldr	x10, [x10, :got_lo12:put_loc8_2_asm_h]
	str	x8, [x0, #5400]
	adrp	x8, :got:set_loc8_2_asm_h
	ldr	x8, [x8, :got_lo12:set_loc8_2_asm_h]
	str	x10, [x0, #5408]
	adrp	x10, :got:get_loc0_2_asm_h
	ldr	x10, [x10, :got_lo12:get_loc0_2_asm_h]
	str	x8, [x0, #5416]
	adrp	x8, :got:get_loc1_2_asm_h
	ldr	x8, [x8, :got_lo12:get_loc1_2_asm_h]
	str	x10, [x0, #5424]
	adrp	x10, :got:get_loc2_2_asm_h
	ldr	x10, [x10, :got_lo12:get_loc2_2_asm_h]
	str	x8, [x0, #5432]
	adrp	x8, :got:get_loc3_2_asm_h
	ldr	x8, [x8, :got_lo12:get_loc3_2_asm_h]
	str	x10, [x0, #5440]
	adrp	x10, :got:put_loc0_2_asm_h
	ldr	x10, [x10, :got_lo12:put_loc0_2_asm_h]
	str	x8, [x0, #5448]
	adrp	x8, :got:put_loc1_2_asm_h
	ldr	x8, [x8, :got_lo12:put_loc1_2_asm_h]
	str	x10, [x0, #5456]
	adrp	x10, :got:put_loc2_2_asm_h
	ldr	x10, [x10, :got_lo12:put_loc2_2_asm_h]
	str	x8, [x0, #5464]
	adrp	x8, :got:put_loc3_2_asm_h
	ldr	x8, [x8, :got_lo12:put_loc3_2_asm_h]
	str	x10, [x0, #5472]
	adrp	x10, :got:set_loc0_2_asm_h
	ldr	x10, [x10, :got_lo12:set_loc0_2_asm_h]
	str	x8, [x0, #5480]
	adrp	x8, :got:set_loc1_2_asm_h
	ldr	x8, [x8, :got_lo12:set_loc1_2_asm_h]
	str	x10, [x0, #5488]
	adrp	x10, :got:set_loc2_2_asm_h
	ldr	x10, [x10, :got_lo12:set_loc2_2_asm_h]
	str	x8, [x0, #5496]
	adrp	x8, :got:set_loc3_2_asm_h
	ldr	x8, [x8, :got_lo12:set_loc3_2_asm_h]
	str	x10, [x0, #5504]
	adrp	x10, :got:get_arg0_2_asm_h
	ldr	x10, [x10, :got_lo12:get_arg0_2_asm_h]
	str	x8, [x0, #5512]
	adrp	x8, :got:get_arg1_2_asm_h
	ldr	x8, [x8, :got_lo12:get_arg1_2_asm_h]
	str	x10, [x0, #5520]
	adrp	x10, :got:get_arg2_2_asm_h
	ldr	x10, [x10, :got_lo12:get_arg2_2_asm_h]
	str	x8, [x0, #5528]
	adrp	x8, :got:get_arg3_2_asm_h
	ldr	x8, [x8, :got_lo12:get_arg3_2_asm_h]
	str	x10, [x0, #5536]
	adrp	x10, :got:put_arg0_2_asm_h
	ldr	x10, [x10, :got_lo12:put_arg0_2_asm_h]
	str	x8, [x0, #5544]
	adrp	x8, :got:put_arg1_2_asm_h
	ldr	x8, [x8, :got_lo12:put_arg1_2_asm_h]
	str	x10, [x0, #5552]
	adrp	x10, :got:put_arg2_2_asm_h
	ldr	x10, [x10, :got_lo12:put_arg2_2_asm_h]
	str	x8, [x0, #5560]
	adrp	x8, :got:put_arg3_2_asm_h
	ldr	x8, [x8, :got_lo12:put_arg3_2_asm_h]
	str	x10, [x0, #5568]
	adrp	x10, :got:set_arg0_2_asm_h
	ldr	x10, [x10, :got_lo12:set_arg0_2_asm_h]
	str	x8, [x0, #5576]
	adrp	x8, :got:set_arg1_2_asm_h
	ldr	x8, [x8, :got_lo12:set_arg1_2_asm_h]
	str	x10, [x0, #5584]
	adrp	x10, :got:set_arg2_2_asm_h
	ldr	x10, [x10, :got_lo12:set_arg2_2_asm_h]
	str	x8, [x0, #5592]
	adrp	x8, :got:set_arg3_2_asm_h
	ldr	x8, [x8, :got_lo12:set_arg3_2_asm_h]
	str	x10, [x0, #5600]
	adrp	x10, :got:get_var_ref0_2_asm_h
	ldr	x10, [x10, :got_lo12:get_var_ref0_2_asm_h]
	str	x8, [x0, #5608]
	adrp	x8, :got:get_var_ref1_2_asm_h
	ldr	x8, [x8, :got_lo12:get_var_ref1_2_asm_h]
	str	x10, [x0, #5616]
	adrp	x10, :got:get_var_ref2_2_asm_h
	ldr	x10, [x10, :got_lo12:get_var_ref2_2_asm_h]
	str	x8, [x0, #5624]
	adrp	x8, :got:get_var_ref3_2_asm_h
	ldr	x8, [x8, :got_lo12:get_var_ref3_2_asm_h]
	str	x10, [x0, #5632]
	adrp	x10, :got:put_var_ref0_2_asm_h
	ldr	x10, [x10, :got_lo12:put_var_ref0_2_asm_h]
	str	x8, [x0, #5640]
	adrp	x8, :got:put_var_ref1_2_asm_h
	ldr	x8, [x8, :got_lo12:put_var_ref1_2_asm_h]
	str	x10, [x0, #5648]
	adrp	x10, :got:put_var_ref2_2_asm_h
	ldr	x10, [x10, :got_lo12:put_var_ref2_2_asm_h]
	str	x8, [x0, #5656]
	adrp	x8, :got:put_var_ref3_2_asm_h
	ldr	x8, [x8, :got_lo12:put_var_ref3_2_asm_h]
	str	x10, [x0, #5664]
	adrp	x10, :got:set_var_ref0_2_asm_h
	ldr	x10, [x10, :got_lo12:set_var_ref0_2_asm_h]
	str	x8, [x0, #5672]
	adrp	x8, :got:set_var_ref1_2_asm_h
	ldr	x8, [x8, :got_lo12:set_var_ref1_2_asm_h]
	str	x10, [x0, #5680]
	adrp	x10, :got:set_var_ref2_2_asm_h
	ldr	x10, [x10, :got_lo12:set_var_ref2_2_asm_h]
	str	x8, [x0, #5688]
	adrp	x8, :got:set_var_ref3_2_asm_h
	ldr	x8, [x8, :got_lo12:set_var_ref3_2_asm_h]
	str	x10, [x0, #5696]
	adrp	x10, :got:get_length_2_asm_h
	ldr	x10, [x10, :got_lo12:get_length_2_asm_h]
	str	x8, [x0, #5704]
	adrp	x8, :got:if_false8_2_asm_h
	ldr	x8, [x8, :got_lo12:if_false8_2_asm_h]
	str	x10, [x0, #5712]
	adrp	x10, :got:if_true8_2_asm_h
	ldr	x10, [x10, :got_lo12:if_true8_2_asm_h]
	str	x8, [x0, #5720]
	adrp	x8, :got:goto8_2_asm_h
	ldr	x8, [x8, :got_lo12:goto8_2_asm_h]
	str	x10, [x0, #5728]
	adrp	x10, :got:goto16_2_asm_h
	ldr	x10, [x10, :got_lo12:goto16_2_asm_h]
	str	x8, [x0, #5736]
	adrp	x8, :got:call0_2_asm_h
	ldr	x8, [x8, :got_lo12:call0_2_asm_h]
	str	x10, [x0, #5744]
	adrp	x10, :got:call1_2_asm_h
	ldr	x10, [x10, :got_lo12:call1_2_asm_h]
	str	x8, [x0, #5752]
	adrp	x8, :got:call2_2_asm_h
	ldr	x8, [x8, :got_lo12:call2_2_asm_h]
	str	x10, [x0, #5760]
	adrp	x10, :got:call3_2_asm_h
	ldr	x10, [x10, :got_lo12:call3_2_asm_h]
	str	x8, [x0, #5768]
	adrp	x8, :got:is_undefined_2_asm_h
	ldr	x8, [x8, :got_lo12:is_undefined_2_asm_h]
	str	x10, [x0, #5776]
	adrp	x10, :got:is_null_2_asm_h
	ldr	x10, [x10, :got_lo12:is_null_2_asm_h]
	str	x8, [x0, #5784]
	adrp	x8, :got:is_function_2_asm_h
	ldr	x8, [x8, :got_lo12:is_function_2_asm_h]
	str	x10, [x0, #5792]
	str	x8, [x0, #5800]
	ret
.Lfunc_end751:
	.size	InstallBcHandler, .Lfunc_end751-InstallBcHandler
	.cfi_endproc
                                        // -- End function
	.globl	_call_stub_entry                // -- Begin function _call_stub_entry
	.p2align	2
	.type	_call_stub_entry,@function
_call_stub_entry:                       // @_call_stub_entry
	.cfi_startproc
// %bb.0:                               // %B0
	stp	d15, d14, [sp, #-160]!          // 16-byte Folded Spill
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	stp	x29, x30, [sp, #64]             // 16-byte Folded Spill
	stp	x28, x27, [sp, #80]             // 16-byte Folded Spill
	stp	x26, x25, [sp, #96]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #112]            // 16-byte Folded Spill
	stp	x22, x21, [sp, #128]            // 16-byte Folded Spill
	stp	x20, x19, [sp, #144]            // 16-byte Folded Spill
	.cfi_def_cfa_offset 160
	.cfi_offset w19, -8
	.cfi_offset w20, -16
	.cfi_offset w21, -24
	.cfi_offset w22, -32
	.cfi_offset w23, -40
	.cfi_offset w24, -48
	.cfi_offset w25, -56
	.cfi_offset w26, -64
	.cfi_offset w27, -72
	.cfi_offset w28, -80
	.cfi_offset w30, -88
	.cfi_offset w29, -96
	.cfi_offset b8, -104
	.cfi_offset b9, -112
	.cfi_offset b10, -120
	.cfi_offset b11, -128
	.cfi_offset b12, -136
	.cfi_offset b13, -144
	.cfi_offset b14, -152
	.cfi_offset b15, -160
	mov	x24, x3
	ldr	x10, [x3, #40]
	mov	x8, sp
	ldr	x11, [x24, #8]
	ldr	x25, [x3]
	mov	w9, w4
	ldr	x29, [x10, #240]
	mov	x22, x2
	mov	x27, x1
	str	x11, [x8, #-16]!
	mov	x21, x0
	mov	sp, x8
	mov	x8, sp
	mov	w19, w6
	mov	x20, x5
	str	x8, [x24, #8]
	bl	common_call_from_entry_asm_h
	ldr	x8, [x24, #8]
	mov	sp, x8
	mov	x8, sp
	ldr	x10, [x8], #16
	mov	sp, x8
	mov	x0, x27
	str	x10, [x24, #8]
	ldp	x20, x19, [sp, #144]            // 16-byte Folded Reload
	ldp	x22, x21, [sp, #128]            // 16-byte Folded Reload
	ldp	x24, x23, [sp, #112]            // 16-byte Folded Reload
	ldp	x26, x25, [sp, #96]             // 16-byte Folded Reload
	ldp	x28, x27, [sp, #80]             // 16-byte Folded Reload
	ldp	x29, x30, [sp, #64]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldp	d15, d14, [sp], #160            // 16-byte Folded Reload
	ret
.Lfunc_end752:
	.size	_call_stub_entry, .Lfunc_end752-_call_stub_entry
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
