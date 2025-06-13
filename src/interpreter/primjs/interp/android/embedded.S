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
	ldr	x8, [x29, #96]
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
// %bb.0:                               // %B30
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB8_7
// %bb.1:                               // %B27
	ldrh	w8, [x22, #6]
	cmp	w8, #13
	b.ne	.LBB8_8
// %bb.2:                               // %B1
	ldr	x12, [x22, #48]
	ldr	x13, [x24, #16]
	mov	x11, sp
	ldrh	w10, [x12, #40]
	ldrh	w8, [x12, #42]
	ldrh	w14, [x12, #46]
	cmp	w9, w10
	add	w14, w8, w14
	b.lt	.LBB8_9
// %bb.3:                               // %B24
	lsl	w10, w14, #3
	add	w10, w10, #160
	and	w14, w10, #0x8
	add	w10, w10, w14
	sub	x10, x11, x10
	cmp	x10, x13
	b.ls	.LBB8_17
// %bb.4:                               // %B26
	mov	sp, x10
	stp	x29, x22, [x10]
	add	x11, x10, #32
	mov	x29, x10
	str	x30, [x10, #96]
	mov	x28, x20
	stp	x21, x27, [x10, #112]
	ldr	x13, [x22, #56]
	stp	x11, x11, [x10, #32]
	str	x13, [x10, #128]
	mov	x26, x13
	ldrb	w11, [x12, #5]
	str	w11, [x10, #60]
	add	x11, x10, #160
	ldr	x19, [x12, #8]
	str	w9, [x10, #144]
	mov	x27, x11
	ldr	x14, [x12, #48]
	add	w12, w9, w8
	str	w9, [x10, #56]
	stp	x20, x11, [x10, #16]
	add	x8, x11, x8, lsl #3
	str	x14, [x10, #136]
	mov	x23, x14
	str	xzr, [x10, #80]
	str	w12, [x10, #88]
	ldr	x12, [x24, #40]
	str	x10, [x12, #240]
	mov	w12, #18                        // =0x12
	cmp	x11, x8
	b.ge	.LBB8_6
.LBB8_5:                                // %B21
                                        // =>This Inner Loop Header: Depth=1
	str	x12, [x11], #8
	cmp	x11, x8
	b.lt	.LBB8_5
.LBB8_6:                                // %B23
	ldrb	w10, [x19], #1
	mov	x20, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB8_7:                                // %B32
	b	ThrowTypeErrorNotFunction_Return_asm_h
.LBB8_8:                                // %B28
	b	call_native_asm_h
.LBB8_9:                                // %B16
	add	w14, w14, w10
	lsl	w14, w14, #3
	add	w14, w14, #160
	and	w15, w14, #0x8
	add	w14, w14, w15
	sub	x11, x11, x14
	cmp	x11, x13
	b.ls	.LBB8_17
// %bb.10:                              // %B18
	mov	sp, x11
	stp	x29, x22, [x11]
	add	x13, x11, #32
	mov	x29, x11
	str	x30, [x11, #96]
	stp	x21, x27, [x11, #112]
	ldr	x14, [x22, #56]
	stp	x13, x13, [x11, #32]
	str	x14, [x11, #128]
	mov	x26, x14
	ldrb	w13, [x12, #5]
	str	w13, [x11, #60]
	ldr	x19, [x12, #8]
	str	w9, [x11, #144]
	ldr	x15, [x12, #48]
	add	x12, x11, #160
	mov	x13, x12
	str	x15, [x11, #136]
	mov	x23, x15
	cmp	w9, w10
	csel	w14, w9, w10, lt
	add	x14, x12, w14, uxtw #3
	cmp	x12, x14
	b.ge	.LBB8_12
.LBB8_11:                               // %B5
                                        // =>This Inner Loop Header: Depth=1
	ldr	x14, [x20], #8
	str	x14, [x13], #8
	cmp	w9, w10
	csel	w14, w9, w10, lt
	add	x14, x12, w14, uxtw #3
	cmp	x13, x14
	b.lt	.LBB8_11
.LBB8_12:                               // %B9.preheader
	add	x13, x12, x10, lsl #3
	mov	w15, #18                        // =0x12
	cmp	x14, x13
	b.ge	.LBB8_14
.LBB8_13:                               // %B10
                                        // =>This Inner Loop Header: Depth=1
	str	x15, [x14], #8
	cmp	x14, x13
	b.lt	.LBB8_13
.LBB8_14:                               // %B11
	str	w10, [x11, #56]
	add	w10, w10, w8
	add	x20, x13, x8, lsl #3
	stp	x12, x13, [x11, #16]
	mov	w8, #18                         // =0x12
	mov	x28, x12
	str	xzr, [x11, #80]
	mov	x27, x13
	str	w10, [x11, #88]
	ldr	x10, [x24, #40]
	str	x11, [x10, #240]
	cmp	x13, x20
	b.ge	.LBB8_16
.LBB8_15:                               // %B14
                                        // =>This Inner Loop Header: Depth=1
	str	x8, [x13], #8
	cmp	x13, x20
	b.lt	.LBB8_15
.LBB8_16:                               // %B15
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB8_17:                               // %B17
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
// %bb.0:                               // %B47
	tbz	w19, #2, .LBB13_6
// %bb.1:                               // %B34
	mov	x11, sp
	ldr	x10, [x24, #16]
	sub	x8, x11, #160
	cmp	x8, x10
	b.ls	.LBB13_24
// %bb.2:                               // %B36
	and	x10, x22, #0xfffffffffffc
	add	x12, x10, #16
	mov	sp, x8
	mov	x13, x12
	mov	x14, x8
	cmp	x8, x11
	b.ge	.LBB13_4
.LBB13_3:                               // %B39
                                        // =>This Inner Loop Header: Depth=1
	ldr	x15, [x13], #8
	str	x15, [x14], #8
	cmp	x14, x11
	b.lt	.LBB13_3
.LBB13_4:                               // %B31
	stp	x30, x12, [x8, #96]
	add	x13, x8, #32
	mov	x29, x8
	ldr	x11, [x24, #40]
	ldr	x12, [x11, #240]
	str	x12, [x8]
	str	x8, [x11, #240]
	ldp	x11, x28, [x8, #8]
	stp	x21, x27, [x8, #112]
	ldr	x19, [x8, #48]
	ldr	x20, [x8, #64]
	ldr	x27, [x8, #24]
	ldr	x12, [x11, #56]
	str	x12, [x8, #128]
	mov	x26, x12
	ldr	x11, [x11, #48]
	ldr	x11, [x11, #48]
	str	w9, [x8, #144]
	stp	x13, x13, [x8, #32]
	str	x11, [x8, #136]
	mov	x23, x11
	ldr	w10, [x10, #12]
	cbnz	w10, .LBB13_16
.LBB13_5:                               // %B23
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB13_6:                               // %B41
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB13_17
// %bb.7:                               // %B43
	ldrh	w8, [x22, #6]
	cmp	w8, #13
	b.ne	.LBB13_18
// %bb.8:                               // %B1
	ldr	x12, [x22, #48]
	ldr	x13, [x24, #16]
	mov	x11, sp
	ldrh	w10, [x12, #40]
	ldrh	w8, [x12, #42]
	ldrh	w14, [x12, #46]
	cmp	w9, w10
	add	w14, w8, w14
	b.ge	.LBB13_19
// %bb.9:                               // %B16
	add	w14, w14, w10
	lsl	w14, w14, #3
	add	w14, w14, #160
	and	w15, w14, #0x8
	add	w14, w14, w15
	sub	x11, x11, x14
	cmp	x11, x13
	b.ls	.LBB13_24
// %bb.10:                              // %B18
	mov	sp, x11
	stp	x29, x22, [x11]
	add	x13, x11, #32
	mov	x29, x11
	str	x30, [x11, #96]
	stp	x21, x27, [x11, #112]
	ldr	x14, [x22, #56]
	stp	x13, x13, [x11, #32]
	str	x14, [x11, #128]
	mov	x26, x14
	ldrb	w13, [x12, #5]
	str	w13, [x11, #60]
	ldr	x19, [x12, #8]
	str	w9, [x11, #144]
	ldr	x15, [x12, #48]
	add	x12, x11, #160
	mov	x13, x12
	str	x15, [x11, #136]
	mov	x23, x15
	cmp	w9, w10
	csel	w14, w9, w10, lt
	add	x14, x12, w14, uxtw #3
	cmp	x12, x14
	b.ge	.LBB13_12
.LBB13_11:                              // %B5
                                        // =>This Inner Loop Header: Depth=1
	ldr	x14, [x20], #8
	str	x14, [x13], #8
	cmp	w9, w10
	csel	w14, w9, w10, lt
	add	x14, x12, w14, uxtw #3
	cmp	x13, x14
	b.lt	.LBB13_11
.LBB13_12:                              // %B9.preheader
	add	x13, x12, x10, lsl #3
	mov	w15, #18                        // =0x12
	cmp	x14, x13
	b.ge	.LBB13_14
.LBB13_13:                              // %B10
                                        // =>This Inner Loop Header: Depth=1
	str	x15, [x14], #8
	cmp	x14, x13
	b.lt	.LBB13_13
.LBB13_14:                              // %B11
	str	w10, [x11, #56]
	add	w10, w10, w8
	add	x20, x13, x8, lsl #3
	stp	x12, x13, [x11, #16]
	mov	w8, #18                         // =0x12
	mov	x28, x12
	str	xzr, [x11, #80]
	mov	x27, x13
	str	w10, [x11, #88]
	ldr	x10, [x24, #40]
	str	x11, [x10, #240]
	cmp	x13, x20
	b.ge	.LBB13_5
.LBB13_15:                              // %B14
                                        // =>This Inner Loop Header: Depth=1
	str	x8, [x13], #8
	cmp	x13, x20
	b.lt	.LBB13_15
	b	.LBB13_5
.LBB13_16:                              // %B32
	b	exception_asm_h
.LBB13_17:                              // %B46
	b	ThrowTypeErrorNotFunction_Return_asm_h
.LBB13_18:                              // %B44
	b	call_native_entry_asm_h
.LBB13_19:                              // %B28
	add	w10, w14, w9
	lsl	w10, w10, #3
	add	w10, w10, #160
	and	w14, w10, #0x8
	add	w10, w10, w14
	sub	x10, x11, x10
	cmp	x10, x13
	b.ls	.LBB13_24
// %bb.20:                              // %B30
	mov	sp, x10
	stp	x29, x22, [x10]
	add	x11, x10, #32
	mov	x29, x10
	str	x30, [x10, #96]
	stp	x21, x27, [x10, #112]
	ldr	x14, [x22, #56]
	stp	x11, x11, [x10, #32]
	str	x14, [x10, #128]
	mov	x26, x14
	ldrb	w11, [x12, #5]
	str	w11, [x10, #60]
	ldr	x19, [x12, #8]
	str	w9, [x10, #144]
	ldr	x15, [x12, #48]
	add	x12, x10, #160
	add	x11, x12, w9, uxtw #3
	mov	x13, x12
	str	x15, [x10, #136]
	mov	x23, x15
	cmp	x12, x11
	b.ge	.LBB13_22
.LBB13_21:                              // %B25
                                        // =>This Inner Loop Header: Depth=1
	ldr	x14, [x20], #8
	str	x14, [x13], #8
	cmp	x13, x11
	b.lt	.LBB13_21
.LBB13_22:                              // %B27
	add	w13, w9, w8
	str	w9, [x10, #56]
	add	x20, x11, x8, lsl #3
	stp	x12, x11, [x10, #16]
	mov	w8, #18                         // =0x12
	mov	x28, x12
	str	xzr, [x10, #80]
	mov	x27, x11
	str	w13, [x10, #88]
	ldr	x13, [x24, #40]
	str	x10, [x13, #240]
	cmp	x11, x20
	b.ge	.LBB13_5
.LBB13_23:                              // %B21
                                        // =>This Inner Loop Header: Depth=1
	str	x8, [x11], #8
	cmp	x11, x20
	b.lt	.LBB13_23
	b	.LBB13_5
.LBB13_24:                              // %B17
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	ldrsw	x10, [x19]
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	ldr	x22, [x23, x10, lsl #3]
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
// %bb.0:                               // %B1
	ldrsw	x8, [x19]
	mov	x0, x24
	mov	x2, x26
	mov	x3, x29
	ldr	x1, [x23, x8, lsl #3]
	str	x20, [x29, #64]
	bl	js_closure_gc
	cmp	x0, #130
	b.eq	.LBB28_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB28_2:                               // %B2
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB29_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB29_2:                               // %B2
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, #4                          // =0x4
	str	x20, [x29, #64]
	bl	JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	.LBB30_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB30_2:                               // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B12
	ldr	w8, [x29, #60]
	ldr	x1, [x29, #112]
	tbnz	w8, #0, .LBB33_2
// %bb.1:                               // %B12
	ldr	x8, [x29, #112]
	and	x10, x8, #0xfffffffffffffffe
	and	x10, x10, #0xffff000000000003
	cbnz	x10, .LBB33_3
.LBB33_2:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, x1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB33_3:                               // %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	.LBB33_5
// %bb.4:                               // %B7
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x22, [x24, #224]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB33_5:                               // %B9
	mov	x0, x24
	str	x20, [x29, #64]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB33_7
// %bb.6:                               // %B11
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB33_7:                               // %B10
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
	mov	x0, x24
	str	x20, [x29, #64]
	bl	PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	.LBB36_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB36_2:                               // %B2
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
// %bb.0:                               // %B15
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	.LBB37_4
// %bb.1:                               // %B15
	cbz	w8, .LBB37_8
// %bb.2:                               // %B15
	cmp	w8, #1
	b.ne	.LBB37_13
// %bb.3:                               // %B6
	ldr	x8, [x29, #8]
	ldr	w1, [x29, #144]
	mov	x0, x24
	mov	x2, x28
	mov	x3, x29
	ldr	x8, [x8, #48]
	ldrh	w8, [x8, #40]
	str	x20, [x29, #64]
	cmp	w8, w1
	csel	w4, w8, w1, lt
	bl	js_build_mapped_arguments_gc
	b	.LBB37_9
.LBB37_4:                               // %B15
	cmp	w8, #5
	b.eq	.LBB37_11
// %bb.5:                               // %B15
	cmp	w8, #4
	b.ne	.LBB37_14
// %bb.6:                               // %B9
	ldr	x8, [x29, #8]
	mov	w10, #18                        // =0x12
	ldr	x8, [x8, #64]
	cmp	x8, #0
	csel	x0, x10, x8, eq
.LBB37_7:                               // %B4
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	add	x19, x19, #2
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB37_8:                               // %B1
	ldr	w1, [x29, #144]
	mov	x0, x24
	mov	x2, x28
	str	x20, [x29, #64]
	bl	js_build_arguments_gc
.LBB37_9:                               // %B6
	cmp	x0, #130
	b.ne	.LBB37_7
// %bb.10:                              // %B7
	b	exception_asm_h
.LBB37_11:                              // %B12
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x29, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.ne	.LBB37_7
// %bb.12:                              // %B13
	b	exception_asm_h
.LBB37_13:                              // %B18
	ldr	x0, [x29, #8]
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	add	x19, x19, #2
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB37_14:                              // %B19
	ldr	x0, [x29, #120]
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
// %bb.0:                               // %B1
	ldr	w2, [x29, #144]
	ldrh	w1, [x19]
	mov	x0, x24
	mov	x3, x28
	str	x20, [x29, #64]
	bl	js_build_rest_gc
	cmp	x0, #130
	b.eq	.LBB38_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #2]
	add	x25, x25, #1936
	add	x19, x19, #3
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB38_2:                               // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
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
	b.eq	.LBB58_2
// %bb.1:                               // %B3
	ldrh	w8, [x19]
	sub	x8, x20, x8, lsl #3
	stur	x0, [x8, #-16]
	sub	x20, x8, #8
	ldrb	w10, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB58_2:                               // %B2
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
// %bb.0:                               // %B2
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
	ldp	x26, x23, [x29, #128]
	b.eq	.LBB59_2
// %bb.1:                               // %B4
	ldurh	w10, [x19, #-2]
	add	w10, w10, #1
	sub	x20, x20, w10, uxtw #3
	str	x8, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB59_2:                               // %B3
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
// %bb.0:                               // %B2
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
	b.eq	.LBB60_2
// %bb.1:                               // %B4
	mov	x19, xzr
	mov	x20, xzr
	mov	x9, x27
	b	common_return_asm_h
.LBB60_2:                               // %B3
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
// %bb.0:                               // %B2
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
	ldp	x26, x23, [x29, #128]
	b.eq	.LBB61_2
// %bb.1:                               // %B4
	ldurh	w10, [x19, #-2]
	add	w10, w10, #2
	sub	x20, x20, w10, uxtw #3
	str	x8, [x20], #8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB61_2:                               // %B3
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
// %bb.0:                               // %B2
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
	b.eq	.LBB62_2
// %bb.1:                               // %B4
	mov	x19, xzr
	mov	x20, xzr
	mov	x9, x27
	b	common_return_asm_h
.LBB62_2:                               // %B3
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
// %bb.0:                               // %B1
	ldrh	w1, [x19]
	mov	x0, x24
	str	x20, [x29, #64]
	sub	x2, x20, w1, uxtw #3
	bl	LEPUS_NewArrayWithArgs
	cmp	x0, #130
	b.eq	.LBB63_2
// %bb.1:                               // %B3
	ldrh	w8, [x19]
	sub	x20, x20, x8, lsl #3
	str	x0, [x20], #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB63_2:                               // %B2
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
// %bb.0:                               // %B1
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldrh	w4, [x19]
	ldur	x1, [x20, #-24]
	sub	x3, x20, #16
	mov	x0, x24
	mov	w2, #2                          // =0x2
	str	x20, [x29, #64]
	str	x3, [sp, #8]                    // 8-byte Folded Spill
	bl	js_function_apply_gc
	cmp	x0, #130
	b.eq	.LBB64_2
// %bb.1:                               // %B3
	stur	x0, [x20, #-24]
	ldr	x20, [sp, #8]                   // 8-byte Folded Reload
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.LBB64_2:                               // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B5
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	.LBB67_3
// %bb.1:                               // %B2
	cmp	x22, #18
	b.eq	.LBB67_4
// %bb.2:                               // %B3
	adrp	x1, .L__unnamed_3
	add	x1, x1, :lo12:.L__unnamed_3
	mov	x0, x24
	str	x20, [x29, #64]
	bl	LEPUS_ThrowTypeError
	b	exception_asm_h
.LBB67_3:                               // %B6
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #8
	mov	w21, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB67_4:                               // %B4
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
// %bb.0:                               // %B2
	ldr	x8, [x29, #120]
	cmp	x8, #18
	b.ne	.LBB68_2
// %bb.1:                               // %B3
	adrp	x1, .L__unnamed_4
	add	x1, x1, :lo12:.L__unnamed_4
	mov	x0, x24
	str	x20, [x29, #64]
	bl	LEPUS_ThrowTypeError
	b	exception_asm_h
.LBB68_2:                               // %B4
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
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	mov	x2, x21
	bl	JS_CheckBrand_GC
	tbnz	w0, #31, .LBB69_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB69_2:                               // %B2
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
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	mov	x2, x21
	bl	JS_AddBrand_GC
	tbnz	w0, #31, .LBB70_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB70_2:                               // %B2
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
// %bb.0:                               // %B3
	ldr	x1, [x29, #104]
	add	x10, x29, #32
	str	x19, [x1, #48]
	str	x20, [x1, #64]
	ldr	x8, [x29, #40]
	cmp	x8, x10
	b.eq	.LBB71_2
// %bb.1:                               // %B5
	mov	x0, x29
	bl	prim_copy_var_refs_gc
.LBB71_2:                               // %B1
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B3
	ldrb	w8, [x19, #4]
	ldr	w2, [x19]
	str	x20, [x29, #64]
	cmp	w8, #1
	b.le	.LBB73_5
// %bb.1:                               // %B3
	cmp	w8, #2
	b.eq	.LBB73_8
// %bb.2:                               // %B3
	cmp	w8, #3
	b.eq	.LBB73_9
// %bb.3:                               // %B3
	cmp	w8, #4
	b.ne	.LBB73_11
// %bb.4:                               // %B8
	adrp	x1, .L__unnamed_5
	add	x1, x1, :lo12:.L__unnamed_5
	mov	x0, x24
	bl	LEPUS_ThrowTypeError
	b	exception_asm_h
.LBB73_5:                               // %B3
	cbz	w8, .LBB73_10
// %bb.6:                               // %B3
	cmp	w8, #1
	b.ne	.LBB73_11
// %bb.7:                               // %B5
	mov	x0, x24
	mov	w1, w2
	bl	JS_ThrowSyntaxErrorVarRedeclaration_GC
	b	exception_asm_h
.LBB73_8:                               // %B6
	mov	x0, x24
	mov	w1, w2
	bl	JS_ThrowReferenceErrorUninitialized_GC
	b	exception_asm_h
.LBB73_9:                               // %B7
	adrp	x1, .L__unnamed_6
	add	x1, x1, :lo12:.L__unnamed_6
	mov	x0, x24
	bl	LEPUS_ThrowReferenceError
	b	exception_asm_h
.LBB73_10:                              // %B4
	mov	x0, x24
	mov	w1, #16384                      // =0x4000
	bl	JS_ThrowTypeErrorReadOnly
	b	exception_asm_h
.LBB73_11:                              // %B9
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
// %bb.0:                               // %B1
	ldrh	w8, [x19]
	ldur	x2, [x20, #-8]
	mov	x0, x24
	str	x20, [x29, #64]
	sub	w1, w8, #1
	bl	prim_js_op_eval_gc
	cmp	x0, #130
	b.eq	.LBB74_2
// %bb.1:                               // %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB74_2:                               // %B2
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
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w1, #18                         // =0x12
	str	x20, [x29, #64]
	mov	x2, x22
	mov	x3, x21
	bl	js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	.LBB75_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB75_2:                               // %B2
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
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	bl	primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	.LBB76_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB76_2:                               // %B2
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
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	bl	LEPUS_GetPrototype
	cmp	x0, #130
	b.eq	.LBB77_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB77_2:                               // %B2
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
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	bl	js_dynamic_import
	cmp	x0, #130
	b.eq	.LBB78_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB78_2:                               // %B2
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x29, #64]
	bl	JS_CheckGlobalVar_GC
	tbnz	w0, #31, .LBB79_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	cmp	w0, #0
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x0
.LBB79_2:                               // %B2
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
// %bb.0:                               // %B1
	ldr	w9, [x19]
	bl	common_get_var_undef_asm_h
	cmp	x0, #130
	b.eq	.LBB80_3
// %bb.1:                               // %B1
	cmp	x0, #34
	b.eq	.LBB80_5
.LBB80_2:                               // %B10
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB80_3:                               // %B3
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x29, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.ne	.LBB80_2
// %bb.4:                               // %B4
	b	exception_asm_h
.LBB80_5:                               // %B9
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
// %bb.0:                               // %B1
	ldr	w9, [x19]
	bl	common_get_var_asm_h
	cmp	x0, #130
	b.eq	.LBB81_3
// %bb.1:                               // %B1
	cmp	x0, #34
	b.eq	.LBB81_5
.LBB81_2:                               // %B10
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB81_3:                               // %B3
	ldr	w1, [x19]
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x20, [x29, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.ne	.LBB81_2
// %bb.4:                               // %B4
	b	exception_asm_h
.LBB81_5:                               // %B9
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
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	mov	w3, wzr
	str	x20, [x29, #64]
	mov	x2, x22
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB82_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB82_2:                               // %B2
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
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x29, #64]
	mov	x2, x22
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB83_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB83_2:                               // %B2
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
// %bb.0:                               // %B5
	ldp	x22, x21, [x20, #-16]
	cmp	x22, #7
	b.ne	.LBB84_3
// %bb.1:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          // =0x2
	str	x20, [x29, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB84_4
// %bb.2:                               // %B3
	ldrb	w8, [x19, #4]
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB84_3:                               // %B6
	ldr	w1, [x19]
	mov	x0, x24
	str	x20, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB84_4:                               // %B2
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
// %bb.0:                               // %B8
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	cmp	x22, #18
	b.eq	.LBB85_3
// %bb.1:                               // %B1
	mov	x1, x22
	mov	x2, x21
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB85_5
// %bb.2:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #8
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB85_3:                               // %B5
	mov	x1, x21
	bl	js_value_to_atom_gc
	cbz	w0, .LBB85_5
// %bb.4:                               // %B7
	mov	w1, w0
	mov	x0, x24
	str	x20, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB85_5:                               // %B6
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
// %bb.0:                               // %B12
	ldp	x1, x22, [x20, #-24]
	ldur	x21, [x20, #-8]
	cmp	x1, #18
	b.eq	.LBB86_3
.LBB86_1:                               // %B1
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	str	x20, [x29, #64]
	bl	JS_SetPropertyValue_GC
	tbnz	w0, #31, .LBB86_7
// %bb.2:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB86_3:                               // %B8
	ldr	w8, [x29, #60]
	tbnz	w8, #0, .LBB86_5
// %bb.4:                               // %B9
	ldr	x1, [x24, #224]
	b	.LBB86_1
.LBB86_5:                               // %B5
	mov	x0, x24
	mov	x1, x22
	str	x20, [x29, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB86_7
// %bb.6:                               // %B7
	mov	w1, w0
	mov	x0, x24
	str	x20, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB86_7:                               // %B2
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x0, x24
	str	x20, [x29, #64]
	bl	JS_DefineGlobalVar_GC
	tbnz	w0, #31, .LBB87_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB87_2:                               // %B2
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x0, x24
	str	x20, [x29, #64]
	bl	JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, .LBB88_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB88_2:                               // %B2
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
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	ldr	w1, [x19]
	mov	x0, x24
	ldrb	w3, [x19, #4]
	str	x20, [x29, #64]
	mov	x2, x22
	bl	JS_DefineGlobalFunction_GC
	tbnz	w0, #31, .LBB89_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	sub	x20, x20, #8
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB89_2:                               // %B2
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
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	ldr	w9, [x19]
	mov	x21, x22
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB90_2
.LBB90_1:                               // %B7
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB90_2:                               // %B3
	ldr	w2, [x19]
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.ne	.LBB90_1
// %bb.3:                               // %B4
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
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	ldr	w9, [x19]
	mov	x21, x22
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB91_2
.LBB91_1:                               // %B7
	ldrb	w8, [x19, #4]
	add	x25, x25, #3872
	sub	x20, x20, #8
	add	x19, x19, #5
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB91_2:                               // %B3
	ldr	w2, [x19]
	mov	x0, x24
	mov	x1, x22
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.ne	.LBB91_1
// %bb.3:                               // %B4
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	mov	x2, x21
	bl	JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	.LBB93_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB93_2:                               // %B2
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
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	str	x20, [x29, #64]
	mov	x2, x21
	mov	x3, x22
	bl	JS_SetPrivateField_GC
	tbnz	w0, #31, .LBB94_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #24
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB94_2:                               // %B2
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
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	str	x20, [x29, #64]
	mov	x2, x22
	mov	x3, x21
	bl	JS_DefinePrivateField_GC
	tbnz	w0, #31, .LBB95_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB95_2:                               // %B2
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
// %bb.0:                               // %B5
	ldp	x22, x21, [x20, #-16]
	bl	common_get_property_value_asm_h
	cmp	x0, #130
	b.eq	.LBB96_2
.LBB96_1:                               // %B7
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB96_2:                               // %B1
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x29, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.ne	.LBB96_1
// %bb.3:                               // %B2
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
// %bb.0:                               // %B5
	ldp	x22, x21, [x20, #-16]
	bl	common_get_property_value_asm_h
	cmp	x0, #130
	b.eq	.LBB97_2
.LBB97_1:                               // %B7
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #16
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB97_2:                               // %B1
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x29, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.ne	.LBB97_1
// %bb.3:                               // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x21
	bl	js_value_to_atom_gc
	cbz	w0, .LBB99_3
// %bb.1:                               // %B5
	ldur	x3, [x20, #-24]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	str	x20, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB99_3
// %bb.2:                               // %B7
	stur	x0, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB99_3:                               // %B6
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
// %bb.0:                               // %B8
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldur	x10, [x20, #-24]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x10, x8
	b.eq	.LBB100_3
// %bb.1:                               // %B10
	mov	x0, x24
	str	x20, [x29, #64]
	bl	JS_ThrowTypeErrorNotAnObject
.LBB100_2:                              // %B6
	add	sp, sp, #16
	b	exception_asm_h
.LBB100_3:                              // %B1
	ldur	x1, [x20, #-16]
	mov	x0, x24
	str	x10, [sp, #8]                   // 8-byte Folded Spill
	str	x20, [x29, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB100_2
// %bb.4:                               // %B5
	ldur	x3, [x20, #-8]
	ldur	x4, [x20, #-32]
	mov	w2, w0
	ldr	x1, [sp, #8]                    // 8-byte Folded Reload
	mov	x0, x24
	mov	w5, #32768                      // =0x8000
	str	x20, [x29, #64]
	bl	JS_SetPropertyGeneric_GC
	tbnz	w0, #31, .LBB100_2
// %bb.5:                               // %B7
	ldrb	w8, [x19], #1
	sub	x20, x20, #32
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
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldr	w2, [x19]
	mov	w4, #16391                      // =0x4007
	str	x20, [x29, #64]
	mov	x1, x22
	mov	x3, x21
	bl	LEPUS_DefinePropertyValue
	tbnz	w0, #31, .LBB101_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	sub	x20, x20, #16
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB101_2:                              // %B2
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
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x29, #64]
	mov	x1, x22
	bl	JS_DefineObjectName
	tbnz	w0, #31, .LBB102_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB102_2:                              // %B2
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
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x29, #64]
	mov	x1, x21
	mov	x2, x22
	bl	JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, .LBB103_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB103_2:                              // %B2
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
// %bb.0:                               // %B6
	ldp	x22, x21, [x20, #-16]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB104_3
// %bb.1:                               // %B6
	cmp	x21, #2
	b.eq	.LBB104_3
.LBB104_2:                              // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB104_3:                              // %B1
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x20, [x29, #64]
	bl	JS_SetPrototypeInternal_GC
	tbz	w0, #31, .LBB104_2
// %bb.4:                               // %B2
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
// %bb.0:                               // %B0
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
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
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	ldur	x1, [x20, #-24]
	mov	w4, #16391                      // =0x4007
	str	x20, [x29, #64]
	mov	x2, x22
	mov	x3, x21
	bl	JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, .LBB106_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB106_2:                              // %B2
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
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x29, #64]
	bl	js_append_enumerate_gc
	tbnz	w0, #31, .LBB107_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB107_2:                              // %B2
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
// %bb.0:                               // %B1
	ldrb	w2, [x19]
	mov	x0, x24
	mov	x1, x20
	str	x20, [x29, #64]
	bl	prim_js_copy_data_properties_gc
	tbnz	w0, #31, .LBB108_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB108_2:                              // %B2
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
// %bb.0:                               // %B15
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	ldrb	w8, [x19, #4]
	mov	w10, #17665                     // =0x4501
	mov	w11, #17669                     // =0x4505
	mov	x12, x19
	ldr	w19, [x19]
	tst	w8, #0x4
	str	x12, [sp, #48]                  // 8-byte Folded Spill
	csel	w11, w11, w10, ne
	ldp	x10, x13, [x20, #-16]
	ands	w8, w8, #0x3
	b.eq	.LBB109_3
// %bb.1:                               // %B15
	cmp	w8, #1
	b.ne	.LBB109_4
// %bb.2:                               // %B13
	mov	w8, #18                         // =0x12
	mov	w12, #2048                      // =0x800
	stp	x13, x8, [sp, #16]              // 16-byte Folded Spill
	b	.LBB109_5
.LBB109_3:
	mov	w8, #18                         // =0x12
	str	x13, [sp, #40]                  // 8-byte Folded Spill
	mov	w12, #8706                      // =0x2202
	str	x8, [sp, #24]                   // 8-byte Folded Spill
	mov	w8, #18                         // =0x12
	str	x8, [sp, #16]                   // 8-byte Folded Spill
	b	.LBB109_6
.LBB109_4:                              // %B14
	mov	w12, #4096                      // =0x1000
	mov	w8, #18                         // =0x12
	stp	x8, x13, [sp, #16]              // 16-byte Folded Spill
.LBB109_5:                              // %B10
	mov	w8, #18                         // =0x12
	str	x8, [sp, #40]                   // 8-byte Folded Spill
.LBB109_6:                              // %B10
	ldur	x1, [x20, #-8]
	orr	w3, w11, w12
	mov	x0, x24
	mov	w2, w19
	mov	x4, x10
	str	x20, [x29, #64]
	str	w12, [sp, #36]                  // 4-byte Folded Spill
	str	x20, [sp, #56]                  // 8-byte Folded Spill
	mov	w20, w19
	mov	x19, x10
	str	w11, [sp, #12]                  // 4-byte Folded Spill
	bl	js_method_set_properties_gc
	tbnz	w0, #31, .LBB109_9
// %bb.7:                               // %B5
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
	tbnz	w0, #31, .LBB109_9
// %bb.8:                               // %B7
	ldr	x10, [sp, #48]                  // 8-byte Folded Reload
	ldrb	w8, [x10, #5]
	add	x19, x10, #6
	ldr	x0, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	sub	x20, x8, #8
	add	sp, sp, #64
	br	x0
.LBB109_9:                              // %B2
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
// %bb.0:                               // %B8
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	ldur	x1, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB110_11
// %bb.1:                               // %B11
	ldrb	w8, [x19]
	mov	w10, #17665                     // =0x4501
	mov	w11, #17669                     // =0x4505
	ldur	x13, [x20, #-24]
	mov	w12, w0
	str	x19, [sp, #48]                  // 8-byte Folded Spill
	tst	w8, #0x4
	csel	w10, w11, w10, ne
	ldur	x11, [x20, #-8]
	ands	w8, w8, #0x3
	b.eq	.LBB110_4
// %bb.2:                               // %B11
	cmp	w8, #1
	b.ne	.LBB110_5
// %bb.3:                               // %B19
	mov	w8, #18                         // =0x12
	mov	w14, #2048                      // =0x800
	stp	x11, x8, [sp, #16]              // 16-byte Folded Spill
	b	.LBB110_6
.LBB110_4:
	mov	w8, #18                         // =0x12
	str	x11, [sp, #40]                  // 8-byte Folded Spill
	mov	w14, #8706                      // =0x2202
	str	x8, [sp, #24]                   // 8-byte Folded Spill
	mov	w8, #18                         // =0x12
	str	x8, [sp, #16]                   // 8-byte Folded Spill
	b	.LBB110_7
.LBB110_5:                              // %B20
	mov	w14, #4096                      // =0x1000
	mov	w8, #18                         // =0x12
	stp	x8, x11, [sp, #16]              // 16-byte Folded Spill
.LBB110_6:                              // %B16
	mov	w8, #18                         // =0x12
	str	x8, [sp, #40]                   // 8-byte Folded Spill
.LBB110_7:                              // %B16
	ldur	x1, [x20, #-8]
	orr	w3, w10, w14
	mov	x0, x24
	mov	w2, w12
	mov	x4, x13
	str	x20, [x29, #64]
	str	w14, [sp, #36]                  // 4-byte Folded Spill
	mov	x19, x13
	str	x20, [sp, #56]                  // 8-byte Folded Spill
	mov	w20, w12
	str	w10, [sp, #12]                  // 4-byte Folded Spill
	bl	js_method_set_properties_gc
	tbnz	w0, #31, .LBB110_10
// %bb.8:                               // %B5
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
	tbnz	w0, #31, .LBB110_10
// %bb.9:                               // %B7
	ldr	x10, [sp, #48]                  // 8-byte Folded Reload
	ldrb	w8, [x10, #1]
	add	x19, x10, #2
	ldr	x0, [x25, x8, lsl #3]
	ldr	x8, [sp, #56]                   // 8-byte Folded Reload
	sub	x20, x8, #16
	add	sp, sp, #64
	br	x0
.LBB110_10:                             // %B2
	ldp	x19, x20, [sp, #48]             // 16-byte Folded Reload
.LBB110_11:                             // %B9
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
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #4]
	mov	x0, x24
	mov	x1, x20
	mov	x4, x26
	mov	x5, x29
	str	x20, [x29, #64]
	bl	js_op_define_class
	tbnz	w0, #31, .LBB111_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB111_2:                              // %B2
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
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	add	x25, x25, #1936
	ldrh	w10, [x19], #3
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	add	x25, x25, #1936
	ldrh	w10, [x19], #3
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	.LBB122_2
// %bb.1:                               // %B4
	ldrb	w10, [x19, #2]
	add	x25, x25, #1936
	add	x19, x19, #3
	mov	x22, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB122_2:                              // %B3
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
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x10, [x27, x8, lsl #3]
	cmp	x10, #34
	b.eq	.LBB123_2
// %bb.1:                               // %B4
	str	x22, [x27, w8, uxtw #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB123_2:                              // %B3
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
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x10, [x27, x8, lsl #3]
	cmp	x10, #34
	b.ne	.LBB124_2
// %bb.1:                               // %B4
	str	x22, [x27, w8, uxtw #3]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB124_2:                              // %B3
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
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB125_2
// %bb.1:                               // %B4
	ldrb	w10, [x19, #2]
	add	x25, x25, #1936
	add	x19, x19, #3
	mov	x22, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB125_2:                              // %B3
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
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x10, [x8]
	cmp	x10, #34
	b.eq	.LBB126_2
// %bb.1:                               // %B4
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB126_2:                              // %B3
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
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldur	x22, [x20, #-8]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x10, [x8]
	cmp	x10, #34
	b.ne	.LBB127_2
// %bb.1:                               // %B4
	str	x22, [x8]
	sub	x20, x20, #8
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB127_2:                              // %B3
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	.LBB129_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB129_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB129_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB129_6
	b	.LBB129_7
.LBB129_4:                              // %B23
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x22, x10
	b.eq	.LBB129_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB129_7
.LBB129_6:                              // %B3
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB129_7:                              // %B9
	mov	x10, #-281474976710656          // =0xffff000000000000
	cmp	x22, x10
	b.hs	.LBB129_13
// %bb.8:                               // %B11
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x22, x10
	b.lo	.LBB129_10
.LBB129_9:                              // %B19
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB129_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB129_13
// %bb.11:                              // %B17
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB129_6
	b.vs	.LBB129_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB129_9
	b	.LBB129_6
.LBB129_13:                             // %B15
	mov	x20, x8
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
// %bb.0:                               // %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	.LBB130_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB130_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB130_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB130_6
	b	.LBB130_7
.LBB130_4:                              // %B23
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x22, x10
	b.eq	.LBB130_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB130_7
.LBB130_6:                              // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB130_7:                              // %B9
	mov	x10, #-281474976710656          // =0xffff000000000000
	cmp	x22, x10
	b.hs	.LBB130_13
// %bb.8:                               // %B11
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x22, x10
	b.lo	.LBB130_10
.LBB130_9:                              // %B19
	ldrsw	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB130_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB130_13
// %bb.11:                              // %B17
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB130_6
	b.vs	.LBB130_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB130_9
	b	.LBB130_6
.LBB130_13:                             // %B15
	mov	x20, x8
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B6
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB134_3
// %bb.1:                               // %B1
	ldr	x8, [x29, #8]
	ldr	x8, [x8, #48]
	ldr	w10, [x8, #16]
	cmp	w22, w10
	b.ge	.LBB134_3
// %bb.2:                               // %B5
	ldr	x8, [x8, #8]
	sub	x20, x20, #8
	add	x19, x8, w22, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB134_3:                              // %B3
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
// %bb.0:                               // %B2
	ldur	x22, [x20, #-8]
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB135_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB135_2:                              // %B4
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
// %bb.0:                               // %B15
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	.LBB136_4
// %bb.1:                               // %B15
	mov	x10, #1                         // =0x1
	and	x8, x22, #0xffff000000000003
	movk	x10, #1, lsl #48
	add	x11, x10, #1
	cmp	x8, x11
	b.eq	.LBB136_4
// %bb.2:                               // %B15
	cmp	x8, x10
	b.eq	.LBB136_4
// %bb.3:                               // %B15
	mov	x10, #-281474976710653          // =0xffff000000000003
	cmp	x8, x10
	b.ne	.LBB136_5
.LBB136_4:                              // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB136_5:                              // %B12
	mov	x0, x24
	mov	x1, x22
	str	x20, [x29, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB136_7
// %bb.6:                               // %B14
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB136_7:                              // %B13
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
// %bb.0:                               // %B18
	ldp	x22, x21, [x20, #-16]
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	.LBB137_3
// %bb.1:                               // %B19
	adrp	x1, .L__unnamed_9
	add	x1, x1, :lo12:.L__unnamed_9
	mov	x0, x24
	str	x20, [x29, #64]
	bl	LEPUS_ThrowTypeError
.LBB137_2:                              // %B16
	b	exception_asm_h
.LBB137_3:                              // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB137_7
// %bb.4:                               // %B2
	mov	x10, #1                         // =0x1
	and	x8, x21, #0xffff000000000003
	movk	x10, #1, lsl #48
	add	x11, x10, #1
	cmp	x8, x11
	b.eq	.LBB137_7
// %bb.5:                               // %B2
	cmp	x8, x10
	b.eq	.LBB137_7
// %bb.6:                               // %B2
	mov	x10, #-281474976710653          // =0xffff000000000003
	cmp	x8, x10
	b.ne	.LBB137_8
.LBB137_7:                              // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB137_8:                              // %B15
	mov	x0, x24
	mov	x1, x21
	str	x20, [x29, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB137_2
// %bb.9:                               // %B17
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
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #113                        // =0x71
	str	x20, [x29, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB138_4
// %bb.1:                               // %B4
	cbz	w0, .LBB138_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB138_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB138_4:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #114                        // =0x72
	str	x20, [x29, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB139_4
// %bb.1:                               // %B4
	cbz	w0, .LBB139_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	sub	x20, x20, #16
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB139_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB139_4:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #115                        // =0x73
	str	x20, [x29, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB140_4
// %bb.1:                               // %B4
	cbz	w0, .LBB140_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB140_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB140_4:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #116                        // =0x74
	str	x20, [x29, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB141_4
// %bb.1:                               // %B4
	cbz	w0, .LBB141_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB141_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB141_4:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #117                        // =0x75
	str	x20, [x29, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB142_4
// %bb.1:                               // %B4
	cbz	w0, .LBB142_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB142_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB142_4:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w2, [x19]
	ldrb	w3, [x19, #8]
	mov	x0, x24
	mov	x1, x20
	mov	w4, #118                        // =0x76
	str	x20, [x29, #64]
	bl	prim_js_with_op_gc
	tbnz	w0, #31, .LBB143_4
// %bb.1:                               // %B4
	cbz	w0, .LBB143_3
// %bb.2:                               // %B7
	ldr	w8, [x19, #4]
	add	x20, x20, #8
	add	w8, w8, #4
	add	x19, x19, w8, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB143_3:                              // %B5
	ldrb	w8, [x19, #9]
	sub	x20, x20, #8
	add	x19, x19, #10
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB143_4:                              // %B2
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
// %bb.0:                               // %B12
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x29, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.eq	.LBB144_6
// %bb.1:                               // %B1
	mov	w8, #18                         // =0x12
	mov	x1, x29
	mov	w3, wzr
	stp	x0, x8, [x20], #16
	mov	x0, x24
	ldrh	w2, [x19, #4]
	str	x19, [sp, #8]                   // 8-byte Folded Spill
	str	x20, [x29, #64]
	bl	get_var_ref
	cbz	x0, .LBB144_5
// %bb.2:                               // %B6
	ldr	x8, [sp, #8]                    // 8-byte Folded Reload
	ldur	x1, [x20, #-16]
	mov	x19, x0
	mov	x0, x24
	mov	w3, #34                         // =0x22
	ldr	w2, [x8]
	str	x20, [x29, #64]
	bl	add_property_gc
	cbz	x0, .LBB144_5
// %bb.3:                               // %B9
	str	x19, [x0]
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	mov	x0, x24
	mov	w2, wzr
	ldr	w1, [x19]
	str	x20, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB144_6
// %bb.4:                               // %B11
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.LBB144_5:                              // %B3
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
.LBB144_6:                              // %B10
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
// %bb.0:                               // %B12
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x29, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.eq	.LBB145_6
// %bb.1:                               // %B1
	mov	w8, #18                         // =0x12
	mov	x1, x29
	mov	w3, #1                          // =0x1
	stp	x0, x8, [x20], #16
	mov	x0, x24
	ldrh	w2, [x19, #4]
	str	x19, [sp, #8]                   // 8-byte Folded Spill
	str	x20, [x29, #64]
	bl	get_var_ref
	cbz	x0, .LBB145_5
// %bb.2:                               // %B6
	ldr	x8, [sp, #8]                    // 8-byte Folded Reload
	ldur	x1, [x20, #-16]
	mov	x19, x0
	mov	x0, x24
	mov	w3, #34                         // =0x22
	ldr	w2, [x8]
	str	x20, [x29, #64]
	bl	add_property_gc
	cbz	x0, .LBB145_5
// %bb.3:                               // %B9
	str	x19, [x0]
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	mov	x0, x24
	mov	w2, wzr
	ldr	w1, [x19]
	str	x20, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB145_6
// %bb.4:                               // %B11
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.LBB145_5:                              // %B3
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
.LBB145_6:                              // %B10
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
// %bb.0:                               // %B8
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x20, [x29, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.eq	.LBB146_4
// %bb.1:                               // %B1
	mov	w8, #18                         // =0x12
	mov	x1, x0
	mov	w3, #34                         // =0x22
	stp	x0, x8, [x20], #16
	mov	x0, x24
	ldr	w2, [x19]
	str	x20, [x29, #64]
	bl	add_property_gc
	cbz	x0, .LBB146_4
// %bb.2:                               // %B5
	ldrh	w8, [x19, #4]
	mov	w2, wzr
	ldr	x8, [x26, x8, lsl #3]
	str	x8, [x0]
	mov	x0, x24
	ldr	w1, [x19]
	str	x20, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB146_4
// %bb.3:                               // %B7
	stur	x0, [x20, #-8]
	ldrb	w8, [x19, #6]
	add	x19, x19, #7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB146_4:                              // %B6
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x20
	str	x20, [x29, #64]
	bl	JS_GetGlobalVarRef_GC
	tbnz	w0, #31, .LBB147_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	add	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB147_2:                              // %B2
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
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	bl	prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	.LBB148_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB148_2:                              // %B2
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
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	mov	w2, wzr
	str	x20, [x29, #64]
	bl	js_for_of_start_gc
	tbnz	w0, #31, .LBB149_2
// %bb.1:                               // %B3
	mov	w8, #66                         // =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB149_2:                              // %B2
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
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	mov	w2, #1                          // =0x1
	str	x20, [x29, #64]
	bl	js_for_of_start_gc
	tbnz	w0, #31, .LBB150_2
// %bb.1:                               // %B3
	mov	w8, #66                         // =0x42
	str	x8, [x20, #8]
	add	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB150_2:                              // %B2
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
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x29, #64]
	bl	js_for_in_next_gc
	tbnz	w0, #31, .LBB151_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB151_2:                              // %B2
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
// %bb.0:                               // %B1
	ldrb	w10, [x19]
	mov	w8, #-3                         // =0xfffffffd
	mov	x0, x24
	mov	x1, x20
	str	x20, [x29, #64]
	sub	w2, w8, w10
	bl	js_for_of_next_gc
	tbnz	w0, #31, .LBB152_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB152_2:                              // %B2
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
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x29, #64]
	bl	js_for_await_of_next_gc
	tbnz	w0, #31, .LBB153_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB153_2:                              // %B2
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
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x29, #64]
	bl	js_iterator_get_value_done_gc
	tbnz	w0, #31, .LBB154_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB154_2:                              // %B2
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
// %bb.0:                               // %B6
	ldur	x1, [x20, #-24]
	sub	x20, x20, #16
	cmp	x1, #18
	b.eq	.LBB155_2
// %bb.1:                               // %B1
	mov	x0, x24
	mov	w2, wzr
	str	x20, [x29, #64]
	bl	JS_IteratorClose
	tbnz	w0, #31, .LBB155_3
.LBB155_2:                              // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB155_3:                              // %B2
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
// %bb.0:                               // %B0
	ldr	x10, [x29, #8]
	ldr	x8, [x20, #-8]!
	mov	w11, #247                       // =0xf7
	ldr	x10, [x10, #48]
	ldrh	w10, [x10, #42]
	add	x10, x27, x10, lsl #3
	b	.LBB156_2
.LBB156_1:                              // %B10
                                        //   in Loop: Header=BB156_2 Depth=1
	sub	x20, x20, #8
.LBB156_2:                              // %B2
                                        // =>This Inner Loop Header: Depth=1
	cmp	x20, x10
	b.le	.LBB156_5
// %bb.3:                               // %B4
                                        //   in Loop: Header=BB156_2 Depth=1
	ldur	x12, [x20, #-8]
	tst	x12, #0xffff000000000000
	b.ne	.LBB156_1
// %bb.4:                               // %B4
                                        //   in Loop: Header=BB156_2 Depth=1
	and	x12, x12, x11
	cmp	x12, #66
	b.ne	.LBB156_1
.LBB156_5:                              // %B7
	add	x10, x10, #24
	cmp	x20, x10
	add	x20, x20, #8
	b.lt	.LBB156_7
// %bb.6:                               // %B9
	ldur	x10, [x20, #-16]
	ldur	q0, [x20, #-32]
	stur	x8, [x20, #-32]
	stur	x10, [x20, #-8]
	stur	q0, [x20, #-24]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB156_7:                              // %B8
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
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x20
	str	x20, [x29, #64]
	bl	prim_js_async_iterator_close_gc
	tbnz	w0, #31, .LBB157_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB157_2:                              // %B2
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
// %bb.0:                               // %B1
	ldp	x2, x1, [x20, #-32]
	sub	x4, x20, #8
	mov	x0, x24
	mov	w3, #1                          // =0x1
	str	x20, [x29, #64]
	bl	LEPUS_Call
	cmp	x0, #130
	b.eq	.LBB158_2
// %bb.1:                               // %B3
	stur	x0, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB158_2:                              // %B2
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
// %bb.0:                               // %B1
	ldrb	w2, [x19]
	mov	x0, x24
	mov	x1, x20
	str	x20, [x29, #64]
	bl	prim_js_async_iterator_get_gc
	tbnz	w0, #31, .LBB159_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	add	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB159_2:                              // %B2
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
// %bb.0:                               // %B3
	ldr	x1, [x29, #104]
	add	x10, x29, #32
	str	x19, [x1, #48]
	str	x20, [x1, #64]
	ldr	x8, [x29, #40]
	cmp	x8, x10
	b.eq	.LBB160_2
// %bb.1:                               // %B5
	mov	x0, x29
	bl	prim_copy_var_refs_gc
.LBB160_2:                              // %B1
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
// %bb.0:                               // %B3
	ldr	x1, [x29, #104]
	add	x10, x29, #32
	str	x19, [x1, #48]
	str	x20, [x1, #64]
	ldr	x8, [x29, #40]
	cmp	x8, x10
	b.eq	.LBB161_2
// %bb.1:                               // %B5
	mov	x0, x29
	bl	prim_copy_var_refs_gc
.LBB161_2:                              // %B1
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
// %bb.0:                               // %B3
	ldr	x1, [x29, #104]
	add	x10, x29, #32
	str	x19, [x1, #48]
	str	x20, [x1, #64]
	ldr	x8, [x29, #40]
	cmp	x8, x10
	b.eq	.LBB162_2
// %bb.1:                               // %B5
	mov	x0, x29
	bl	prim_copy_var_refs_gc
.LBB162_2:                              // %B1
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
// %bb.0:                               // %B3
	ldr	x1, [x29, #104]
	add	x10, x29, #32
	str	x19, [x1, #48]
	str	x20, [x1, #64]
	ldr	x8, [x29, #40]
	cmp	x8, x10
	b.eq	.LBB163_2
// %bb.1:                               // %B5
	mov	x0, x29
	bl	prim_copy_var_refs_gc
.LBB163_2:                              // %B1
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
// %bb.0:                               // %B3
	ldr	x1, [x29, #104]
	add	x10, x29, #32
	str	x19, [x1, #48]
	str	x20, [x1, #64]
	ldr	x8, [x29, #40]
	cmp	x8, x10
	b.eq	.LBB164_2
// %bb.1:                               // %B5
	mov	x0, x29
	bl	prim_copy_var_refs_gc
.LBB164_2:                              // %B1
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
// %bb.0:                               // %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB165_3
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB165_6
// %bb.2:                               // %B13
	orr	w8, w22, #0x80000000
	mov	w10, #-2147483648               // =0x80000000
	cmp	w8, w10
	b.ne	.LBB165_5
.LBB165_3:                              // %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        // =0x8c
	str	x20, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB165_8
// %bb.4:                               // %B18
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB165_5:                              // %B15
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB165_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB165_3
// %bb.7:                               // %B7
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
.LBB165_8:                              // %B17
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
// %bb.0:                               // %B13
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB166_4
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB166_3
.LBB166_2:                              // %B7
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB166_3:                              // %B3
	tst	x22, #0xfffe000000000000
	b.ne	.LBB166_2
.LBB166_4:                              // %B10
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        // =0x8d
	str	x20, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB166_6
// %bb.5:                               // %B12
	mov	x22, x0
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB166_6:                              // %B11
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
// %bb.0:                               // %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB167_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB167_4
// %bb.2:                               // %B13
	subs	w8, w22, #1
	b.vs	.LBB167_6
// %bb.3:                               // %B15
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB167_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB167_6
// %bb.5:                               // %B7
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
.LBB167_6:                              // %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        // =0x8e
	str	x20, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB167_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB167_8:                              // %B17
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
// %bb.0:                               // %B19
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB168_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB168_4
// %bb.2:                               // %B13
	adds	w8, w22, #1
	b.vs	.LBB168_6
// %bb.3:                               // %B15
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB168_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB168_6
// %bb.5:                               // %B7
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
.LBB168_6:                              // %B16
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        // =0x8f
	str	x20, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB168_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB168_8:                              // %B17
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
// %bb.0:                               // %B16
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB169_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB169_4
// %bb.2:                               // %B13
	subs	w8, w22, #1
	b.vs	.LBB169_6
// %bb.3:                               // %B15
	ldrb	w10, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB169_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB169_6
// %bb.5:                               // %B8
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
.LBB169_6:                              // %B5
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
// %bb.0:                               // %B16
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB170_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB170_4
// %bb.2:                               // %B13
	adds	w8, w22, #1
	b.vs	.LBB170_6
// %bb.3:                               // %B15
	ldrb	w10, [x19], #1
	add	x25, x25, #3872
	sub	x20, x20, #8
	orr	x21, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB170_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB170_6
// %bb.5:                               // %B8
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
.LBB170_6:                              // %B5
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
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	b.hi	.LBB171_6
// %bb.1:                               // %B2
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB171_4
// %bb.2:                               // %B13
	subs	w10, w1, #1
	b.vs	.LBB171_6
// %bb.3:                               // %B15
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB171_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB171_6
// %bb.5:                               // %B8
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
.LBB171_6:                              // %B16
	mov	x0, x24
	mov	w2, #142                        // =0x8e
	str	x20, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB171_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB171_8:                              // %B17
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
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	b.hi	.LBB172_6
// %bb.1:                               // %B2
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB172_4
// %bb.2:                               // %B13
	adds	w10, w1, #1
	b.vs	.LBB172_6
// %bb.3:                               // %B15
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB172_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB172_6
// %bb.5:                               // %B8
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
.LBB172_6:                              // %B16
	mov	x0, x24
	mov	w2, #143                        // =0x8f
	str	x20, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB172_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB172_8:                              // %B17
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
// %bb.0:                               // %B45
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldur	x22, [x20, #-8]
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	ccmp	x22, x10, #2, ls
	b.hi	.LBB173_14
// %bb.1:                               // %B2
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB173_5
// %bb.2:                               // %B26
	cmp	x22, x10
	b.lo	.LBB173_8
// %bb.3:                               // %B36
	adds	w10, w1, w22
	b.vs	.LBB173_14
// %bb.4:                               // %B38
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB173_5:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB173_14
// %bb.6:                               // %B11
	cmp	x22, x10
	b.lo	.LBB173_12
// %bb.7:                               // %B21
	scvtf	d0, w22
	add	x10, x1, x10
	fmov	d1, x10
	fadd	d0, d1, d0
	b	.LBB173_11
.LBB173_8:                              // %B28
	tst	x22, #0xfffe000000000000
	b.eq	.LBB173_14
// %bb.9:                               // %B31
	scvtf	d0, w1
	add	x10, x22, x10
.LBB173_10:                             // %B31
	fmov	d1, x10
	fadd	d0, d0, d1
.LBB173_11:                             // %B31
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
.LBB173_12:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB173_14
// %bb.13:                              // %B16
	add	x11, x1, x10
	add	x10, x22, x10
	fmov	d0, x11
	b	.LBB173_10
.LBB173_14:                             // %B7
	mov	x10, #2                         // =0x2
	and	x8, x1, #0xffff000000000003
	and	x11, x22, #0xffff000000000003
	movk	x10, #1, lsl #48
	mov	x0, x24
	mov	x2, x22
	cmp	x8, x10
	str	x20, [x29, #64]
	ccmp	x11, x10, #0, eq
	b.eq	.LBB173_16
// %bb.15:                              // %B42
	bl	prim_js_add_slow_gc
	b	.LBB173_17
.LBB173_16:                             // %B39
	bl	JS_ConcatString_GC
.LBB173_17:                             // %B42
	cmp	x0, #130
	b.eq	.LBB173_19
// %bb.18:                              // %B44
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	sub	x20, x20, #8
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB173_19:                             // %B43
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
// %bb.0:                               // %B2
	ldur	x22, [x20, #-8]
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB174_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB174_2:                              // %B4
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
// %bb.0:                               // %B14
	ldur	x22, [x20, #-8]
	cmp	x22, #5
	b.le	.LBB175_4
// %bb.1:                               // %B14
	cmp	x22, #6
	b.eq	.LBB175_6
// %bb.2:                               // %B14
	cmp	x22, #7
	b.eq	.LBB175_8
// %bb.3:                               // %B14
	cmp	x22, #18
	b.eq	.LBB175_6
	b	.LBB175_7
.LBB175_4:                              // %B14
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB175_6
// %bb.5:                               // %B14
	cmp	x22, #2
	b.ne	.LBB175_7
.LBB175_6:                              // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB175_7:                              // %B10
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB175_9
.LBB175_8:                              // %B12
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB175_9:                              // %B13
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
// %bb.0:                               // %B1
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
	b.eq	.LBB176_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB176_2:                              // %B2
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
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	.LBB177_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB177_2:                              // %B2
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
// %bb.0:                               // %B1
	ldr	x1, [x24, #224]
	ldr	w2, [x19]
	mov	x0, x24
	mov	w3, wzr
	str	x20, [x29, #64]
	bl	LEPUS_DeleteProperty
	tbnz	w0, #31, .LBB178_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	cmp	w0, #0
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x0
.LBB178_2:                              // %B2
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
// %bb.0:                               // %B47
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB179_18
// %bb.1:                               // %B47
	cmp	x21, x8
	b.hi	.LBB179_18
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB179_8
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB179_11
// %bb.4:                               // %B33
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	.LBB179_18
// %bb.5:                               // %B36
	cbnz	w8, .LBB179_7
// %bb.6:                               // %B36
	orr	w10, w22, w21
	tbnz	w10, #31, .LBB179_15
.LBB179_7:                              // %B43
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB179_8:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB179_18
// %bb.9:                               // %B7
	cmp	x21, x8
	b.lo	.LBB179_16
// %bb.10:                              // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	.LBB179_14
.LBB179_11:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB179_18
// %bb.12:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB179_13:                             // %B28
	fmov	d1, x8
	fmul	d0, d0, d1
.LBB179_14:                             // %B28
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
.LBB179_15:                             // %B40
	mov	x22, #-9222809086901354496      // =0x8002000000000000
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB179_16:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB179_18
// %bb.17:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB179_13
.LBB179_18:                             // %B44
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        // =0x9a
	str	x20, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB179_20
// %bb.19:                              // %B46
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB179_20:                             // %B45
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
// %bb.0:                               // %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB180_14
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB180_14
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB180_5
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB180_8
// %bb.4:                               // %B33
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
.LBB180_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB180_14
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB180_12
// %bb.7:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	.LBB180_11
.LBB180_8:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB180_14
// %bb.9:                               // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB180_10:                             // %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
.LBB180_11:                             // %B28
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
.LBB180_12:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB180_14
// %bb.13:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB180_10
.LBB180_14:                             // %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        // =0x9b
	str	x20, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB180_16
// %bb.15:                              // %B43
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB180_16:                             // %B42
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
// %bb.0:                               // %B39
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB181_16
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB181_16
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB181_7
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB181_10
// %bb.4:                               // %B33
	tbnz	w22, #31, .LBB181_16
// %bb.5:                               // %B33
	cmp	w21, #1
	b.lt	.LBB181_16
// %bb.6:                               // %B35
	sdiv	w8, w22, w21
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x10, lsl #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB181_7:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB181_16
// %bb.8:                               // %B7
	cmp	x21, x8
	b.lo	.LBB181_14
// %bb.9:                               // %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	.LBB181_13
.LBB181_10:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB181_16
// %bb.11:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB181_12:                             // %B28
	fmov	d1, x8
.LBB181_13:                             // %B28
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
.LBB181_14:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB181_16
// %bb.15:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB181_12
.LBB181_16:                             // %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        // =0x9c
	str	x20, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB181_18
// %bb.17:                              // %B38
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB181_18:                             // %B37
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
// %bb.0:                               // %B45
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB182_15
// %bb.1:                               // %B45
	cmp	x21, x8
	b.hi	.LBB182_15
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB182_6
// %bb.3:                               // %B26
	cmp	x21, x8
	b.lo	.LBB182_9
// %bb.4:                               // %B36
	adds	w8, w22, w21
	b.vs	.LBB182_15
// %bb.5:                               // %B38
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB182_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB182_15
// %bb.7:                               // %B10
	cmp	x21, x8
	b.lo	.LBB182_13
// %bb.8:                               // %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	.LBB182_12
.LBB182_9:                              // %B28
	tst	x21, #0xfffe000000000000
	b.eq	.LBB182_15
// %bb.10:                              // %B31
	scvtf	d0, w22
	add	x8, x21, x8
.LBB182_11:                             // %B31
	fmov	d1, x8
	fadd	d0, d0, d1
.LBB182_12:                             // %B31
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
.LBB182_13:                             // %B12
	tst	x21, #0xfffe000000000000
	b.eq	.LBB182_15
// %bb.14:                              // %B15
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB182_11
.LBB182_15:                             // %B6
	mov	x8, #2                          // =0x2
	and	x10, x22, #0xffff000000000003
	str	x20, [x29, #64]
	movk	x8, #1, lsl #48
	cmp	x10, x8
	b.ne	.LBB182_18
// %bb.16:                              // %B6
	and	x10, x21, #0xffff000000000003
	cmp	x10, x8
	b.ne	.LBB182_18
// %bb.17:                              // %B39
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	JS_ConcatString_GC
	b	.LBB182_19
.LBB182_18:                             // %B42
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_add_slow_gc
.LBB182_19:                             // %B42
	cmp	x0, #130
	b.eq	.LBB182_21
// %bb.20:                              // %B44
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB182_21:                             // %B43
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
// %bb.0:                               // %B39
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB183_15
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB183_15
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB183_6
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB183_9
// %bb.4:                               // %B33
	subs	w8, w22, w21
	b.vs	.LBB183_15
// %bb.5:                               // %B35
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB183_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB183_15
// %bb.7:                               // %B7
	cmp	x21, x8
	b.lo	.LBB183_13
// %bb.8:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	.LBB183_12
.LBB183_9:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB183_15
// %bb.10:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB183_11:                             // %B28
	fmov	d1, x8
	fsub	d0, d0, d1
.LBB183_12:                             // %B28
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
.LBB183_13:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB183_15
// %bb.14:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB183_11
.LBB183_15:                             // %B36
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        // =0x9e
	str	x20, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB183_17
// %bb.16:                              // %B38
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB183_17:                             // %B37
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
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	mov	w3, #159                        // =0x9f
	str	x20, [x29, #64]
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB184_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB184_2:                              // %B2
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
// %bb.0:                               // %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB185_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB185_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB185_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB185_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB185_5:                              // %B16
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	lsl	w8, w8, w21
	sub	x20, x20, #16
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB185_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB185_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB185_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB185_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB185_5
.LBB185_10:                             // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        // =0xa0
	str	x20, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB185_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB185_12:                             // %B26
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
// %bb.0:                               // %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB186_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB186_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB186_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB186_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB186_5:                              // %B16
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	asr	w8, w8, w21
	sub	x20, x20, #16
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB186_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB186_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB186_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB186_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB186_5
.LBB186_10:                             // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        // =0xa1
	str	x20, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB186_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB186_12:                             // %B26
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
// %bb.0:                               // %B36
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB187_11
// %bb.1:                               // %B36
	cmp	x21, x8
	b.hi	.LBB187_11
// %bb.2:                               // %B10
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB187_6
// %bb.3:                               // %B27
	cmp	x21, x8
	b.lo	.LBB187_11
// %bb.4:                               // %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, .LBB187_10
.LBB187_5:                              // %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB187_6:                              // %B12
	tst	x22, #0xfffe000000000000
	b.eq	.LBB187_11
// %bb.7:                               // %B12
	cmp	x21, x8
	b.lo	.LBB187_11
// %bb.8:                               // %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB187_11
// %bb.9:                               // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, .LBB187_5
.LBB187_10:                             // %B6
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
.LBB187_11:                             // %B33
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x20, [x29, #64]
	bl	prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	.LBB187_13
// %bb.12:                              // %B35
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB187_13:                             // %B34
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
// %bb.0:                               // %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB188_13
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB188_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB188_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB188_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	cmp	w22, w21
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, lt
	br	x0
.LBB188_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB188_13
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB188_11
// %bb.7:                               // %B13
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
.LBB188_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB188_13
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
.LBB188_10:                             // %B19
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	add	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x0
.LBB188_11:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB188_13
// %bb.12:                              // %B11
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB188_10
.LBB188_13:                             // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        // =0xa3
	str	x20, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB188_15
// %bb.14:                              // %B23
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB188_15:                             // %B22
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
// %bb.0:                               // %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB189_13
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB189_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB189_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB189_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	cmp	w22, w21
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, le
	br	x0
.LBB189_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB189_13
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB189_11
// %bb.7:                               // %B13
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
.LBB189_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB189_13
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
.LBB189_10:                             // %B19
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	add	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x0
.LBB189_11:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB189_13
// %bb.12:                              // %B11
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB189_10
.LBB189_13:                             // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        // =0xa4
	str	x20, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB189_15
// %bb.14:                              // %B23
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB189_15:                             // %B22
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
// %bb.0:                               // %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB190_13
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB190_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB190_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB190_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x0
.LBB190_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB190_13
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB190_11
// %bb.7:                               // %B13
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
.LBB190_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB190_13
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
.LBB190_10:                             // %B19
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	add	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x0
.LBB190_11:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB190_13
// %bb.12:                              // %B11
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB190_10
.LBB190_13:                             // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        // =0xa5
	str	x20, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB190_15
// %bb.14:                              // %B23
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB190_15:                             // %B22
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
// %bb.0:                               // %B24
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB191_13
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB191_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB191_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB191_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x0
.LBB191_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB191_13
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB191_11
// %bb.7:                               // %B13
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
.LBB191_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB191_13
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
.LBB191_10:                             // %B19
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	add	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #16
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x0
.LBB191_11:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB191_13
// %bb.12:                              // %B11
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB191_10
.LBB191_13:                             // %B21
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        // =0xa6
	str	x20, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB191_15
// %bb.14:                              // %B23
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB191_15:                             // %B22
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
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	.LBB192_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB192_2:                              // %B2
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
// %bb.0:                               // %B1
	ldp	x22, x21, [x20, #-16]
	mov	x0, x24
	str	x20, [x29, #64]
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	.LBB193_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB193_2:                              // %B2
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
// %bb.0:                               // %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB194_14
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB194_14
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB194_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB194_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	cmp	w22, w21
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x0
.LBB194_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB194_14
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB194_12
// %bb.7:                               // %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fcmp	d1, d0
	cset	w8, eq
	fcmp	d1, d1
	b	.LBB194_11
.LBB194_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB194_14
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB194_10:                             // %B39
	fmov	d1, x8
	fcmp	d0, d1
	cset	w8, eq
	fcmp	d0, d0
.LBB194_11:                             // %B39
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	csel	w8, wzr, w8, vs
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB194_12:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB194_14
// %bb.13:                              // %B32
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB194_10
.LBB194_14:                             // %B7
	cmp	x22, x21
	b.ne	.LBB194_16
.LBB194_15:                             // %B8
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB194_16:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB194_18
// %bb.17:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB194_15
	b	.LBB194_21
.LBB194_18:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB194_21
// %bb.19:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB194_22
// %bb.20:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB194_22
.LBB194_21:                             // %B15
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB194_22:                             // %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x29, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB194_24
// %bb.23:                              // %B43
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB194_24:                             // %B42
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
// %bb.0:                               // %B44
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB195_14
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB195_14
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB195_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB195_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	cmp	w22, w21
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x0
.LBB195_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB195_14
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB195_12
// %bb.7:                               // %B33
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fcmp	d1, d0
	cset	w8, ne
	fcmp	d1, d1
	b	.LBB195_11
.LBB195_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB195_14
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB195_10:                             // %B39
	fmov	d1, x8
	fcmp	d0, d1
	cset	w8, ne
	fcmp	d0, d0
.LBB195_11:                             // %B39
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	csinc	w8, w8, wzr, vc
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB195_12:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB195_14
// %bb.13:                              // %B32
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB195_10
.LBB195_14:                             // %B7
	cmp	x22, x21
	b.ne	.LBB195_16
.LBB195_15:                             // %B8
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB195_16:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB195_18
// %bb.17:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB195_15
	b	.LBB195_21
.LBB195_18:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB195_21
// %bb.19:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB195_22
// %bb.20:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB195_22
.LBB195_21:                             // %B15
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB195_22:                             // %B41
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x20, [x29, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB195_24
// %bb.23:                              // %B43
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB195_24:                             // %B42
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
// %bb.0:                               // %B30
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB196_14
// %bb.1:                               // %B30
	cmp	x21, x8
	b.hi	.LBB196_14
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB196_5
// %bb.3:                               // %B21
	cmp	x21, x8
	b.lo	.LBB196_8
// %bb.4:                               // %B26
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	cmp	w22, w21
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x0
.LBB196_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB196_14
// %bb.6:                               // %B14
	cmp	x21, x8
	b.lo	.LBB196_12
// %bb.7:                               // %B19
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fcmp	d1, d0
	cset	w8, eq
	fcmp	d1, d1
	b	.LBB196_11
.LBB196_8:                              // %B23
	tst	x21, #0xfffe000000000000
	b.eq	.LBB196_14
// %bb.9:                               // %B25
	scvtf	d0, w22
	add	x8, x21, x8
.LBB196_10:                             // %B25
	fmov	d1, x8
	fcmp	d0, d1
	cset	w8, eq
	fcmp	d0, d0
.LBB196_11:                             // %B25
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	csel	w8, wzr, w8, vs
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB196_12:                             // %B16
	tst	x21, #0xfffe000000000000
	b.eq	.LBB196_14
// %bb.13:                              // %B18
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB196_10
.LBB196_14:                             // %B7
	cmp	x22, x21
	b.ne	.LBB196_16
// %bb.15:                              // %B8
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB196_16:                             // %B10
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
	b.ne	.LBB196_18
// %bb.17:                              // %B10
	tbnz	w8, #0, .LBB196_19
.LBB196_18:                             // %B12
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB196_19:                             // %B27
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x20, [x29, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB196_21
// %bb.20:                              // %B29
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB196_21:                             // %B28
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
// %bb.0:                               // %B30
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB197_14
// %bb.1:                               // %B30
	cmp	x21, x8
	b.hi	.LBB197_14
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB197_5
// %bb.3:                               // %B21
	cmp	x21, x8
	b.lo	.LBB197_8
// %bb.4:                               // %B26
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	cmp	w22, w21
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x0
.LBB197_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB197_14
// %bb.6:                               // %B14
	cmp	x21, x8
	b.lo	.LBB197_12
// %bb.7:                               // %B19
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fcmp	d1, d0
	cset	w8, ne
	fcmp	d1, d1
	b	.LBB197_11
.LBB197_8:                              // %B23
	tst	x21, #0xfffe000000000000
	b.eq	.LBB197_14
// %bb.9:                               // %B25
	scvtf	d0, w22
	add	x8, x21, x8
.LBB197_10:                             // %B25
	fmov	d1, x8
	fcmp	d0, d1
	cset	w8, ne
	fcmp	d0, d0
.LBB197_11:                             // %B25
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	csinc	w8, w8, wzr, vc
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0x6
	br	x0
.LBB197_12:                             // %B16
	tst	x21, #0xfffe000000000000
	b.eq	.LBB197_14
// %bb.13:                              // %B18
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB197_10
.LBB197_14:                             // %B7
	cmp	x22, x21
	b.ne	.LBB197_16
// %bb.15:                              // %B8
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB197_16:                             // %B10
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
	b.ne	.LBB197_18
// %bb.17:                              // %B10
	tbnz	w8, #0, .LBB197_19
.LBB197_18:                             // %B12
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB197_19:                             // %B27
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x20, [x29, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB197_21
// %bb.20:                              // %B29
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB197_21:                             // %B28
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
// %bb.0:                               // %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB198_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB198_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB198_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB198_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB198_5:                              // %B16
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	and	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB198_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB198_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB198_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB198_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB198_5
.LBB198_10:                             // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        // =0xad
	str	x20, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB198_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB198_12:                             // %B26
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
// %bb.0:                               // %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB199_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB199_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB199_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB199_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB199_5:                              // %B16
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	eor	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB199_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB199_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB199_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB199_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB199_5
.LBB199_10:                             // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        // =0xae
	str	x20, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB199_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB199_12:                             // %B26
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
// %bb.0:                               // %B28
	ldp	x22, x21, [x20, #-16]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB200_10
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB200_10
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB200_6
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB200_10
// %bb.4:                               // %B24
	mov	w8, w22
.LBB200_5:                              // %B16
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	orr	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB200_6:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB200_10
// %bb.7:                               // %B4
	cmp	x21, x8
	b.lo	.LBB200_10
// %bb.8:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB200_10
// %bb.9:                               // %B15
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	b	.LBB200_5
.LBB200_10:                             // %B25
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        // =0xaf
	str	x20, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB200_12
// %bb.11:                              // %B27
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #16
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB200_12:                             // %B26
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	ldrb	w10, [x19], #2
	ldr	x0, [x25, x8, lsl #3]
	ldr	x22, [x23, x10, lsl #3]
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
// %bb.0:                               // %B1
	ldrb	w8, [x19]
	mov	x0, x24
	mov	x2, x26
	mov	x3, x29
	ldr	x1, [x23, x8, lsl #3]
	str	x20, [x29, #64]
	bl	js_closure_gc
	cmp	x0, #130
	b.eq	.LBB214_2
// %bb.1:                               // %B3
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	add	x19, x19, #2
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB214_2:                              // %B2
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
// %bb.0:                               // %B1
	mov	x0, x24
	mov	w1, #47                         // =0x2f
	mov	w2, #1                          // =0x1
	str	x20, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB215_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB215_2:                              // %B2
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
// %bb.0:                               // %B0
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	ldrb	w10, [x19], #2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	w9, #48                         // =0x30
	mov	x21, x22
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB255_2
.LBB255_1:                              // %B7
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB255_2:                              // %B3
	mov	x0, x24
	mov	x1, x22
	mov	w2, #48                         // =0x30
	mov	x3, x22
	mov	w4, wzr
	str	x20, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.ne	.LBB255_1
// %bb.3:                               // %B4
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
// %bb.0:                               // %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	.LBB256_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB256_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB256_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB256_6
	b	.LBB256_7
.LBB256_4:                              // %B23
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x22, x10
	b.eq	.LBB256_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB256_7
.LBB256_6:                              // %B3
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB256_7:                              // %B9
	mov	x10, #-281474976710656          // =0xffff000000000000
	cmp	x22, x10
	b.hs	.LBB256_13
// %bb.8:                               // %B11
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x22, x10
	b.lo	.LBB256_10
.LBB256_9:                              // %B19
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB256_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB256_13
// %bb.11:                              // %B17
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB256_6
	b.vs	.LBB256_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB256_9
	b	.LBB256_6
.LBB256_13:                             // %B15
	mov	x20, x8
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
// %bb.0:                               // %B23
	mov	x8, x20
	ldr	x22, [x20, #-8]!
	cmp	x22, #5
	b.le	.LBB257_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB257_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB257_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB257_6
	b	.LBB257_7
.LBB257_4:                              // %B23
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x22, x10
	b.eq	.LBB257_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB257_7
.LBB257_6:                              // %B3
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB257_7:                              // %B9
	mov	x10, #-281474976710656          // =0xffff000000000000
	cmp	x22, x10
	b.hs	.LBB257_13
// %bb.8:                               // %B11
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x22, x10
	b.lo	.LBB257_10
.LBB257_9:                              // %B19
	ldrsb	x8, [x19]
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB257_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB257_13
// %bb.11:                              // %B17
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB257_6
	b.vs	.LBB257_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB257_9
	b	.LBB257_6
.LBB257_13:                             // %B15
	mov	x20, x8
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B2
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
	ldp	x26, x23, [x29, #128]
	b.eq	.LBB260_2
// %bb.1:                               // %B4
	stur	x8, [x20, #-8]
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB260_2:                              // %B3
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
// %bb.0:                               // %B2
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
	ldp	x26, x23, [x29, #128]
	b.eq	.LBB261_2
// %bb.1:                               // %B4
	stur	x8, [x20, #-16]
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB261_2:                              // %B3
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
// %bb.0:                               // %B2
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
	ldp	x26, x23, [x29, #128]
	b.eq	.LBB262_2
// %bb.1:                               // %B4
	stur	x8, [x20, #-24]
	sub	x20, x20, #16
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB262_2:                              // %B3
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
// %bb.0:                               // %B2
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
	ldp	x26, x23, [x29, #128]
	b.eq	.LBB263_2
// %bb.1:                               // %B4
	stur	x8, [x20, #-32]
	sub	x20, x20, #24
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB263_2:                              // %B3
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
// %bb.0:                               // %B2
	ldur	x22, [x20, #-8]
	cmp	x22, #18
	b.ne	.LBB264_2
// %bb.1:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB264_2:                              // %B5
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
// %bb.0:                               // %B2
	ldur	x22, [x20, #-8]
	cmp	x22, #2
	b.ne	.LBB265_2
// %bb.1:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB265_2:                              // %B5
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
// %bb.0:                               // %B1
	ldur	x22, [x20, #-8]
	mov	x0, x24
	mov	x1, x22
	bl	js_operator_typeof_gc
	cmp	w0, #27
	b.ne	.LBB266_2
// %bb.1:                               // %B2
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB266_2:                              // %B5
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	ldrsw	x10, [x19]
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	ldr	x21, [x23, x10, lsl #3]
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
// %bb.0:                               // %B1
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
	b.eq	.LBB270_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB270_2:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB271_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB271_2:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #4                          // =0x4
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	.LBB272_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB272_2:                              // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B12
	ldr	w8, [x29, #60]
	ldr	x1, [x29, #112]
	tbnz	w8, #0, .LBB275_2
// %bb.1:                               // %B12
	ldr	x8, [x29, #112]
	and	x10, x8, #0xfffffffffffffffe
	and	x10, x10, #0xffff000000000003
	cbnz	x10, .LBB275_3
.LBB275_2:                              // %B3
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, x1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB275_3:                              // %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	.LBB275_5
// %bb.4:                               // %B7
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	ldr	x21, [x24, #224]
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB275_5:                              // %B9
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB275_7
// %bb.6:                               // %B11
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB275_7:                              // %B10
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	.LBB278_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB278_2:                              // %B2
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
// %bb.0:                               // %B15
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	.LBB279_4
// %bb.1:                               // %B15
	cbz	w8, .LBB279_8
// %bb.2:                               // %B15
	cmp	w8, #1
	b.ne	.LBB279_13
// %bb.3:                               // %B6
	ldr	x8, [x29, #8]
	ldr	w1, [x29, #144]
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
	b	.LBB279_9
.LBB279_4:                              // %B15
	cmp	w8, #5
	b.eq	.LBB279_11
// %bb.5:                               // %B15
	cmp	w8, #4
	b.ne	.LBB279_14
// %bb.6:                               // %B9
	ldr	x8, [x29, #8]
	mov	w10, #18                        // =0x12
	ldr	x8, [x8, #64]
	cmp	x8, #0
	csel	x0, x10, x8, eq
.LBB279_7:                              // %B5
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	add	x19, x19, #2
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB279_8:                              // %B1
	ldr	w1, [x29, #144]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x28
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	js_build_arguments_gc
.LBB279_9:                              // %B6
	cmp	x0, #130
	b.ne	.LBB279_7
// %bb.10:                              // %B7
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.LBB279_11:                             // %B12
	mov	x8, x20
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.ne	.LBB279_7
// %bb.12:                              // %B13
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.LBB279_13:                             // %B18
	ldr	x0, [x29, #8]
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	add	x19, x19, #2
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB279_14:                             // %B19
	ldr	x0, [x29, #120]
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
// %bb.0:                               // %B1
	ldr	w2, [x29, #144]
	ldrh	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x3, x28
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	js_build_rest_gc
	cmp	x0, #130
	b.eq	.LBB280_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #2]
	add	x25, x25, #1936
	add	x19, x19, #3
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB280_2:                              // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B5
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.eq	.LBB309_3
// %bb.1:                               // %B2
	cmp	x22, #18
	b.eq	.LBB309_4
// %bb.2:                               // %B3
	mov	x8, x20
	adrp	x1, .L__unnamed_12
	add	x1, x1, :lo12:.L__unnamed_12
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_ThrowTypeError
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.LBB309_3:                              // %B6
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	w21, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB309_4:                              // %B4
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
// %bb.0:                               // %B2
	ldr	x8, [x29, #120]
	cmp	x8, #18
	b.ne	.LBB310_2
// %bb.1:                               // %B3
	mov	x8, x20
	adrp	x1, .L__unnamed_13
	add	x1, x1, :lo12:.L__unnamed_13
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_ThrowTypeError
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.LBB310_2:                              // %B4
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
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x29, #64]
	bl	JS_CheckBrand_GC
	tbnz	w0, #31, .LBB311_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB311_2:                              // %B2
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
// %bb.0:                               // %B1
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x1, x22
	str	x8, [x29, #64]
	bl	JS_AddBrand_GC
	tbnz	w0, #31, .LBB312_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB312_2:                              // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
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
	b.eq	.LBB317_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB317_2:                              // %B2
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
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	.LBB318_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB318_2:                              // %B2
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
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_GetPrototype
	cmp	x0, #130
	b.eq	.LBB319_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB319_2:                              // %B2
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
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	js_dynamic_import
	cmp	x0, #130
	b.eq	.LBB320_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB320_2:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_CheckGlobalVar_GC
	tbnz	w0, #31, .LBB321_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	cmp	w0, #0
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x21, x8, ne
	br	x0
.LBB321_2:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w9, [x19]
	bl	common_get_var_undef_asm_h
	cmp	x0, #130
	b.eq	.LBB322_3
// %bb.1:                               // %B1
	cmp	x0, #34
	b.eq	.LBB322_5
.LBB322_2:                              // %B10
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB322_3:                              // %B3
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.ne	.LBB322_2
// %bb.4:                               // %B4
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.LBB322_5:                              // %B9
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
// %bb.0:                               // %B1
	ldr	w9, [x19]
	bl	common_get_var_asm_h
	cmp	x0, #130
	b.eq	.LBB323_3
// %bb.1:                               // %B1
	cmp	x0, #34
	b.eq	.LBB323_5
.LBB323_2:                              // %B10
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB323_3:                              // %B3
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.ne	.LBB323_2
// %bb.4:                               // %B4
	sub	x25, x25, #1936
	b	exception_spill_top0_asm_h
.LBB323_5:                              // %B9
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	w3, wzr
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB324_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB324_2:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	w3, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB325_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB325_2:                              // %B2
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
// %bb.0:                               // %B5
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	cmp	x22, #7
	b.ne	.LBB326_3
// %bb.1:                               // %B1
	ldr	w1, [x19]
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          // =0x2
	stur	x21, [x8, #-8]
	str	x8, [x29, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB326_4
// %bb.2:                               // %B4
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB326_3:                              // %B6
	ldr	w1, [x19]
	mov	x0, x24
	str	x21, [x20]
	str	x8, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB326_4:                              // %B2
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
// %bb.0:                               // %B8
	mov	x21, x22
	ldur	x22, [x20, #-8]
	add	x8, x20, #8
	mov	x0, x24
	str	x21, [x20]
	cmp	x22, #18
	str	x8, [x29, #64]
	b.eq	.LBB327_3
// %bb.1:                               // %B1
	mov	x1, x22
	mov	x2, x21
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB327_5
// %bb.2:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB327_3:                              // %B5
	mov	x1, x21
	bl	js_value_to_atom_gc
	cbz	w0, .LBB327_5
// %bb.4:                               // %B7
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB327_5:                              // %B6
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
// %bb.0:                               // %B12
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	cmp	x1, #18
	b.eq	.LBB328_3
.LBB328_1:                              // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_SetPropertyValue_GC
	tbnz	w0, #31, .LBB328_7
// %bb.2:                               // %B4
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB328_3:                              // %B8
	ldrb	w8, [x29, #60]
	tbnz	w8, #0, .LBB328_5
// %bb.4:                               // %B9
	ldr	x1, [x24, #224]
	b	.LBB328_1
.LBB328_5:                              // %B5
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB328_7
// %bb.6:                               // %B7
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB328_7:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_DefineGlobalVar_GC
	tbnz	w0, #31, .LBB329_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB329_2:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	mov	x8, x20
	mov	x0, x24
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, .LBB330_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB330_2:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w3, [x19, #4]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x22
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_DefineGlobalFunction_GC
	tbnz	w0, #31, .LBB331_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #5]
	sub	x25, x25, #1936
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB331_2:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w9, [x19]
	mov	x21, x22
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB332_2
.LBB332_1:                              // %B7
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB332_2:                              // %B3
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
	b.ne	.LBB332_1
// %bb.3:                               // %B4
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
// %bb.0:                               // %B1
	ldr	w9, [x19]
	mov	x21, x22
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB333_2
.LBB333_1:                              // %B7
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	add	x19, x19, #5
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB333_2:                              // %B3
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
	b.ne	.LBB333_1
// %bb.3:                               // %B4
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
// %bb.0:                               // %B0
	mov	x8, x20
	mov	x21, x22
	ldur	x22, [x20, #-8]
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
// %bb.0:                               // %B1
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
	b.eq	.LBB335_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB335_2:                              // %B2
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
// %bb.0:                               // %B1
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	add	x8, x20, #8
	mov	x0, x24
	mov	x2, x21
	str	x21, [x20]
	mov	x3, x22
	str	x8, [x29, #64]
	bl	JS_SetPrivateField_GC
	tbnz	w0, #31, .LBB336_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	sub	x20, x20, #16
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB336_2:                              // %B2
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
// %bb.0:                               // %B1
	mov	x21, x22
	ldp	x1, x22, [x20, #-16]
	add	x8, x20, #8
	mov	x0, x24
	mov	x3, x21
	str	x21, [x20]
	mov	x2, x22
	str	x8, [x29, #64]
	bl	JS_DefinePrivateField_GC
	tbnz	w0, #31, .LBB337_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB337_2:                              // %B2
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
// %bb.0:                               // %B5
	mov	x21, x22
	ldur	x22, [x20, #-8]
	bl	common_get_property_value_asm_h
	cmp	x0, #130
	b.eq	.LBB338_2
.LBB338_1:                              // %B7
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB338_2:                              // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.ne	.LBB338_1
// %bb.3:                               // %B2
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
// %bb.0:                               // %B5
	mov	x21, x22
	ldur	x22, [x20, #-8]
	bl	common_get_property_value_asm_h
	cmp	x0, #130
	b.eq	.LBB339_2
.LBB339_1:                              // %B7
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB339_2:                              // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.ne	.LBB339_1
// %bb.3:                               // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	mov	x21, x22
	str	x19, [sp, #8]                   // 8-byte Folded Spill
	add	x19, x20, #8
	ldur	x22, [x20, #-8]
	mov	x0, x24
	mov	x1, x21
	str	x21, [x20]
	str	x19, [x29, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB341_3
// %bb.1:                               // %B5
	ldur	x3, [x20, #-16]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	str	x21, [x20]
	str	x19, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB341_3
// %bb.2:                               // %B7
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	stur	x0, [x20, #-16]
	sub	x25, x25, #1936
	sub	x20, x20, #8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.LBB341_3:                              // %B2
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
// %bb.0:                               // %B0
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
	str	x8, [x29, #64]
	bl	LEPUS_DefinePropertyValue
	tbnz	w0, #31, .LBB343_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	sub	x20, x20, #8
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB343_2:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w3, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	JS_DefineObjectName
	tbnz	w0, #31, .LBB344_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB344_2:                              // %B2
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
// %bb.0:                               // %B1
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
	tbnz	w0, #31, .LBB345_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB345_2:                              // %B2
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
// %bb.0:                               // %B6
	mov	x8, #2                          // =0x2
	mov	x21, x22
	ldur	x22, [x20, #-8]
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB346_3
// %bb.1:                               // %B6
	cmp	x21, #2
	b.eq	.LBB346_3
.LBB346_2:                              // %B5
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB346_3:                              // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_SetPrototypeInternal_GC
	tbz	w0, #31, .LBB346_2
// %bb.4:                               // %B2
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
// %bb.0:                               // %B0
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
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
// %bb.0:                               // %B1
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
	tbnz	w0, #31, .LBB348_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB348_2:                              // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	add	x25, x25, #1936
	ldrh	w10, [x19], #3
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
	ldrb	w8, [x19, #2]
	add	x25, x25, #1936
	ldrh	w10, [x19], #3
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	.LBB364_2
// %bb.1:                               // %B4
	ldrb	w10, [x19, #2]
	add	x25, x25, #1936
	add	x19, x19, #3
	mov	x21, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB364_2:                              // %B3
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
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x10, [x27, x8, lsl #3]
	cmp	x10, #34
	b.eq	.LBB365_2
// %bb.1:                               // %B4
	str	x22, [x27, w8, uxtw #3]
	sub	x25, x25, #1936
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB365_2:                              // %B3
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
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x10, [x27, x8, lsl #3]
	cmp	x10, #34
	b.ne	.LBB366_2
// %bb.1:                               // %B4
	str	x22, [x27, w8, uxtw #3]
	sub	x25, x25, #1936
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB366_2:                              // %B3
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
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB367_2
// %bb.1:                               // %B4
	ldrb	w10, [x19, #2]
	add	x25, x25, #1936
	add	x19, x19, #3
	mov	x21, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB367_2:                              // %B3
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
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x10, [x8]
	cmp	x10, #34
	b.eq	.LBB368_2
// %bb.1:                               // %B4
	str	x22, [x8]
	sub	x25, x25, #1936
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB368_2:                              // %B3
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
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x10, [x8]
	cmp	x10, #34
	b.ne	.LBB369_2
// %bb.1:                               // %B4
	str	x22, [x8]
	sub	x25, x25, #1936
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB369_2:                              // %B3
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B23
	cmp	x22, #5
	b.le	.LBB371_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB371_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB371_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB371_6
	b	.LBB371_7
.LBB371_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB371_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB371_7
.LBB371_6:                              // %B3
	ldrsw	x8, [x19]
	sub	x25, x25, #1936
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB371_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB371_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB371_10
.LBB371_9:                              // %B19
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB371_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB371_13
// %bb.11:                              // %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB371_6
	b.vs	.LBB371_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB371_9
	b	.LBB371_6
.LBB371_13:                             // %B15
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
// %bb.0:                               // %B23
	cmp	x22, #5
	b.le	.LBB372_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB372_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB372_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB372_6
	b	.LBB372_7
.LBB372_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB372_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB372_7
.LBB372_6:                              // %B3
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB372_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB372_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB372_10
.LBB372_9:                              // %B19
	ldrsw	x8, [x19]
	sub	x25, x25, #1936
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB372_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB372_13
// %bb.11:                              // %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB372_6
	b.vs	.LBB372_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB372_9
	b	.LBB372_6
.LBB372_13:                             // %B15
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B6
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB376_3
// %bb.1:                               // %B1
	ldr	x8, [x29, #8]
	ldr	x8, [x8, #48]
	ldr	w10, [x8, #16]
	cmp	w22, w10
	b.ge	.LBB376_3
// %bb.2:                               // %B5
	ldr	x8, [x8, #8]
	sub	x25, x25, #1936
	add	x19, x8, w22, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB376_3:                              // %B3
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
// %bb.0:                               // %B2
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x22, x8
	b.ne	.LBB377_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB377_2:                              // %B4
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
// %bb.0:                               // %B15
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.eq	.LBB378_4
// %bb.1:                               // %B15
	mov	x10, #1                         // =0x1
	and	x8, x22, #0xffff000000000003
	movk	x10, #1, lsl #48
	add	x11, x10, #1
	cmp	x8, x11
	b.eq	.LBB378_4
// %bb.2:                               // %B15
	cmp	x8, x10
	b.eq	.LBB378_4
// %bb.3:                               // %B15
	mov	x10, #-281474976710653          // =0xffff000000000003
	cmp	x8, x10
	b.ne	.LBB378_5
.LBB378_4:                              // %B3
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB378_5:                              // %B12
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB378_7
// %bb.6:                               // %B14
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB378_7:                              // %B13
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
// %bb.0:                               // %B18
	mov	x21, x22
	ldur	x22, [x20, #-8]
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	.LBB379_3
// %bb.1:                               // %B19
	mov	x8, x20
	adrp	x1, .L__unnamed_15
	add	x1, x1, :lo12:.L__unnamed_15
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_ThrowTypeError
.LBB379_2:                              // %B16
	sub	x25, x25, #1936
	b	exception_spill_top1_asm_h
.LBB379_3:                              // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB379_7
// %bb.4:                               // %B2
	mov	x10, #1                         // =0x1
	and	x8, x21, #0xffff000000000003
	movk	x10, #1, lsl #48
	add	x11, x10, #1
	cmp	x8, x11
	b.eq	.LBB379_7
// %bb.5:                               // %B2
	cmp	x8, x10
	b.eq	.LBB379_7
// %bb.6:                               // %B2
	mov	x10, #-281474976710653          // =0xffff000000000003
	cmp	x8, x10
	b.ne	.LBB379_8
.LBB379_7:                              // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB379_8:                              // %B15
	mov	x8, x20
	mov	x0, x24
	mov	x1, x21
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB379_2
// %bb.9:                               // %B17
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	.LBB390_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB390_2:                              // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB407_3
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB407_6
// %bb.2:                               // %B13
	orr	w8, w22, #0x80000000
	mov	w10, #-2147483648               // =0x80000000
	cmp	w8, w10
	b.ne	.LBB407_5
.LBB407_3:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #140                        // =0x8c
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB407_8
// %bb.4:                               // %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB407_5:                              // %B15
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	neg	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB407_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB407_3
// %bb.7:                               // %B7
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
.LBB407_8:                              // %B17
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
// %bb.0:                               // %B13
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB408_4
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB408_3
.LBB408_2:                              // %B7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB408_3:                              // %B3
	tst	x22, #0xfffe000000000000
	b.ne	.LBB408_2
.LBB408_4:                              // %B10
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #141                        // =0x8d
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB408_6
// %bb.5:                               // %B12
	mov	x22, x0
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB408_6:                              // %B11
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
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB409_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB409_4
// %bb.2:                               // %B13
	subs	w8, w22, #1
	b.vs	.LBB409_6
// %bb.3:                               // %B15
	ldrb	w10, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB409_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB409_6
// %bb.5:                               // %B7
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
.LBB409_6:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #142                        // =0x8e
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB409_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB409_8:                              // %B17
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
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB410_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB410_4
// %bb.2:                               // %B13
	adds	w8, w22, #1
	b.vs	.LBB410_6
// %bb.3:                               // %B15
	ldrb	w10, [x19], #1
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB410_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB410_6
// %bb.5:                               // %B7
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
.LBB410_6:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	w2, #143                        // =0x8f
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB410_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB410_8:                              // %B17
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
// %bb.0:                               // %B16
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB411_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB411_4
// %bb.2:                               // %B13
	subs	w8, w22, #1
	b.vs	.LBB411_6
// %bb.3:                               // %B15
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	orr	x21, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB411_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB411_6
// %bb.5:                               // %B8
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
.LBB411_6:                              // %B5
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
// %bb.0:                               // %B16
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB412_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB412_4
// %bb.2:                               // %B13
	adds	w8, w22, #1
	b.vs	.LBB412_6
// %bb.3:                               // %B15
	ldrb	w10, [x19], #1
	add	x25, x25, #1936
	orr	x21, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB412_4:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB412_6
// %bb.5:                               // %B8
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
.LBB412_6:                              // %B5
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
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	b.hi	.LBB413_6
// %bb.1:                               // %B2
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB413_4
// %bb.2:                               // %B13
	subs	w10, w1, #1
	b.vs	.LBB413_6
// %bb.3:                               // %B15
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB413_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB413_6
// %bb.5:                               // %B8
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
.LBB413_6:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	w2, #142                        // =0x8e
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB413_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB413_8:                              // %B17
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
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	b.hi	.LBB414_6
// %bb.1:                               // %B2
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB414_4
// %bb.2:                               // %B13
	adds	w10, w1, #1
	b.vs	.LBB414_6
// %bb.3:                               // %B15
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB414_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB414_6
// %bb.5:                               // %B8
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
.LBB414_6:                              // %B16
	mov	x8, x20
	mov	x0, x24
	mov	w2, #143                        // =0x8f
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB414_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB414_8:                              // %B17
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
// %bb.0:                               // %B45
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	ccmp	x22, x10, #2, ls
	b.hi	.LBB415_14
// %bb.1:                               // %B2
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB415_5
// %bb.2:                               // %B26
	cmp	x22, x10
	b.lo	.LBB415_8
// %bb.3:                               // %B36
	adds	w10, w1, w22
	b.vs	.LBB415_14
// %bb.4:                               // %B38
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB415_5:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB415_14
// %bb.6:                               // %B11
	cmp	x22, x10
	b.lo	.LBB415_12
// %bb.7:                               // %B21
	scvtf	d0, w22
	add	x10, x1, x10
	fmov	d1, x10
	fadd	d0, d1, d0
	b	.LBB415_11
.LBB415_8:                              // %B28
	tst	x22, #0xfffe000000000000
	b.eq	.LBB415_14
// %bb.9:                               // %B31
	scvtf	d0, w1
	add	x10, x22, x10
.LBB415_10:                             // %B31
	fmov	d1, x10
	fadd	d0, d0, d1
.LBB415_11:                             // %B31
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
.LBB415_12:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB415_14
// %bb.13:                              // %B16
	add	x11, x1, x10
	add	x10, x22, x10
	fmov	d0, x11
	b	.LBB415_10
.LBB415_14:                             // %B7
	mov	x10, #2                         // =0x2
	and	x8, x1, #0xffff000000000003
	and	x11, x22, #0xffff000000000003
	movk	x10, #1, lsl #48
	mov	x12, x20
	mov	x0, x24
	cmp	x8, x10
	mov	x2, x22
	ccmp	x11, x10, #0, eq
	str	x22, [x12], #8
	str	x12, [x29, #64]
	b.eq	.LBB415_16
// %bb.15:                              // %B42
	bl	prim_js_add_slow_gc
	b	.LBB415_17
.LBB415_16:                             // %B39
	bl	JS_ConcatString_GC
.LBB415_17:                             // %B42
	cmp	x0, #130
	b.eq	.LBB415_19
// %bb.18:                              // %B44
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB415_19:                             // %B43
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
// %bb.0:                               // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB416_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	mvn	w8, w22
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB416_2:                              // %B4
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
// %bb.0:                               // %B14
	cmp	x22, #5
	b.le	.LBB417_4
// %bb.1:                               // %B14
	cmp	x22, #6
	b.eq	.LBB417_6
// %bb.2:                               // %B14
	cmp	x22, #7
	b.eq	.LBB417_8
// %bb.3:                               // %B14
	cmp	x22, #18
	b.eq	.LBB417_6
	b	.LBB417_7
.LBB417_4:                              // %B14
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB417_6
// %bb.5:                               // %B14
	cmp	x22, #2
	b.ne	.LBB417_7
.LBB417_6:                              // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB417_7:                              // %B10
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x22, lsr #48
	b.ne	.LBB417_9
.LBB417_8:                              // %B12
	mov	w22, #6                         // =0x6
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB417_9:                              // %B13
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
// %bb.0:                               // %B1
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
	b.eq	.LBB418_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB418_2:                              // %B2
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
// %bb.0:                               // %B1
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
	b.eq	.LBB419_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB419_2:                              // %B2
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
// %bb.0:                               // %B1
	ldr	x1, [x24, #224]
	ldr	w2, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w3, wzr
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_DeleteProperty
	tbnz	w0, #31, .LBB420_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	add	x25, x25, #1936
	cmp	w0, #0
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x21, x8, ne
	br	x0
.LBB420_2:                              // %B2
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
// %bb.0:                               // %B47
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB421_18
// %bb.1:                               // %B47
	cmp	x21, x8
	b.hi	.LBB421_18
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB421_8
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB421_11
// %bb.4:                               // %B33
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	.LBB421_18
// %bb.5:                               // %B36
	cbnz	w8, .LBB421_7
// %bb.6:                               // %B36
	orr	w10, w22, w21
	tbnz	w10, #31, .LBB421_15
.LBB421_7:                              // %B43
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB421_8:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB421_18
// %bb.9:                               // %B7
	cmp	x21, x8
	b.lo	.LBB421_16
// %bb.10:                              // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	.LBB421_14
.LBB421_11:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB421_18
// %bb.12:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB421_13:                             // %B28
	fmov	d1, x8
	fmul	d0, d0, d1
.LBB421_14:                             // %B28
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
.LBB421_15:                             // %B40
	mov	x22, #-9222809086901354496      // =0x8002000000000000
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB421_16:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB421_18
// %bb.17:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB421_13
.LBB421_18:                             // %B44
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        // =0x9a
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB421_20
// %bb.19:                              // %B46
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB421_20:                             // %B45
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
// %bb.0:                               // %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB422_14
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB422_14
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB422_5
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB422_8
// %bb.4:                               // %B33
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
.LBB422_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB422_14
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB422_12
// %bb.7:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	.LBB422_11
.LBB422_8:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB422_14
// %bb.9:                               // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB422_10:                             // %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
.LBB422_11:                             // %B28
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
.LBB422_12:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB422_14
// %bb.13:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB422_10
.LBB422_14:                             // %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        // =0x9b
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB422_16
// %bb.15:                              // %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB422_16:                             // %B42
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
// %bb.0:                               // %B39
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB423_16
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB423_16
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB423_7
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB423_10
// %bb.4:                               // %B33
	tbnz	w22, #31, .LBB423_16
// %bb.5:                               // %B33
	cmp	w21, #1
	b.lt	.LBB423_16
// %bb.6:                               // %B35
	sdiv	w8, w22, w21
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	ldr	x0, [x25, x10, lsl #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB423_7:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB423_16
// %bb.8:                               // %B7
	cmp	x21, x8
	b.lo	.LBB423_14
// %bb.9:                               // %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	.LBB423_13
.LBB423_10:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB423_16
// %bb.11:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB423_12:                             // %B28
	fmov	d1, x8
.LBB423_13:                             // %B28
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
.LBB423_14:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB423_16
// %bb.15:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB423_12
.LBB423_16:                             // %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        // =0x9c
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB423_18
// %bb.17:                              // %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB423_18:                             // %B37
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
// %bb.0:                               // %B45
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB424_15
// %bb.1:                               // %B45
	cmp	x21, x8
	b.hi	.LBB424_15
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB424_6
// %bb.3:                               // %B26
	cmp	x21, x8
	b.lo	.LBB424_9
// %bb.4:                               // %B36
	adds	w8, w22, w21
	b.vs	.LBB424_15
// %bb.5:                               // %B38
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB424_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB424_15
// %bb.7:                               // %B10
	cmp	x21, x8
	b.lo	.LBB424_13
// %bb.8:                               // %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	.LBB424_12
.LBB424_9:                              // %B28
	tst	x21, #0xfffe000000000000
	b.eq	.LBB424_15
// %bb.10:                              // %B31
	scvtf	d0, w22
	add	x8, x21, x8
.LBB424_11:                             // %B31
	fmov	d1, x8
	fadd	d0, d0, d1
.LBB424_12:                             // %B31
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
.LBB424_13:                             // %B12
	tst	x21, #0xfffe000000000000
	b.eq	.LBB424_15
// %bb.14:                              // %B15
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB424_11
.LBB424_15:                             // %B6
	mov	x8, #2                          // =0x2
	and	x10, x22, #0xffff000000000003
	mov	x11, x20
	movk	x8, #1, lsl #48
	str	x21, [x11], #8
	cmp	x10, x8
	str	x11, [x29, #64]
	b.ne	.LBB424_18
// %bb.16:                              // %B6
	and	x10, x21, #0xffff000000000003
	cmp	x10, x8
	b.ne	.LBB424_18
// %bb.17:                              // %B39
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	JS_ConcatString_GC
	b	.LBB424_19
.LBB424_18:                             // %B42
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_add_slow_gc
.LBB424_19:                             // %B42
	cmp	x0, #130
	b.eq	.LBB424_21
// %bb.20:                              // %B44
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB424_21:                             // %B43
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
// %bb.0:                               // %B39
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB425_15
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB425_15
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB425_6
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB425_9
// %bb.4:                               // %B33
	subs	w8, w22, w21
	b.vs	.LBB425_15
// %bb.5:                               // %B35
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB425_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB425_15
// %bb.7:                               // %B7
	cmp	x21, x8
	b.lo	.LBB425_13
// %bb.8:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	.LBB425_12
.LBB425_9:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB425_15
// %bb.10:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB425_11:                             // %B28
	fmov	d1, x8
	fsub	d0, d0, d1
.LBB425_12:                             // %B28
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
.LBB425_13:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB425_15
// %bb.14:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB425_11
.LBB425_15:                             // %B36
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        // =0x9e
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB425_17
// %bb.16:                              // %B38
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB425_17:                             // %B37
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
// %bb.0:                               // %B1
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
	b.eq	.LBB426_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB426_2:                              // %B2
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
// %bb.0:                               // %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB427_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB427_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB427_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB427_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w10, [x19], #1
	lsl	w8, w8, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB427_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB427_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB427_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB427_9
// %bb.8:                               // %B15
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
.LBB427_9:                              // %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        // =0xa0
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB427_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB427_11:                             // %B26
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
// %bb.0:                               // %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB428_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB428_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB428_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB428_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w10, [x19], #1
	asr	w8, w8, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB428_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB428_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB428_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB428_9
// %bb.8:                               // %B15
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
.LBB428_9:                              // %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        // =0xa1
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB428_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB428_11:                             // %B26
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
// %bb.0:                               // %B36
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB429_11
// %bb.1:                               // %B36
	cmp	x21, x8
	b.hi	.LBB429_11
// %bb.2:                               // %B10
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB429_6
// %bb.3:                               // %B27
	cmp	x21, x8
	b.lo	.LBB429_11
// %bb.4:                               // %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, .LBB429_10
.LBB429_5:                              // %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	mov	x22, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB429_6:                              // %B12
	tst	x22, #0xfffe000000000000
	b.eq	.LBB429_11
// %bb.7:                               // %B12
	cmp	x21, x8
	b.lo	.LBB429_11
// %bb.8:                               // %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB429_11
// %bb.9:                               // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, .LBB429_5
.LBB429_10:                             // %B6
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
.LBB429_11:                             // %B33
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	.LBB429_13
// %bb.12:                              // %B35
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB429_13:                             // %B34
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
// %bb.0:                               // %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB430_13
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB430_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB430_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB430_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, lt
	br	x0
.LBB430_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB430_13
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB430_11
// %bb.7:                               // %B13
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
.LBB430_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB430_13
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
.LBB430_10:                             // %B19
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x0
.LBB430_11:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB430_13
// %bb.12:                              // %B11
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB430_10
.LBB430_13:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        // =0xa3
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB430_15
// %bb.14:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB430_15:                             // %B22
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
// %bb.0:                               // %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB431_13
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB431_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB431_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB431_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, le
	br	x0
.LBB431_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB431_13
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB431_11
// %bb.7:                               // %B13
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
.LBB431_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB431_13
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
.LBB431_10:                             // %B19
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x0
.LBB431_11:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB431_13
// %bb.12:                              // %B11
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB431_10
.LBB431_13:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        // =0xa4
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB431_15
// %bb.14:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB431_15:                             // %B22
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
// %bb.0:                               // %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB432_13
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB432_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB432_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB432_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x0
.LBB432_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB432_13
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB432_11
// %bb.7:                               // %B13
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
.LBB432_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB432_13
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
.LBB432_10:                             // %B19
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x0
.LBB432_11:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB432_13
// %bb.12:                              // %B11
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB432_10
.LBB432_13:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        // =0xa5
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB432_15
// %bb.14:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB432_15:                             // %B22
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
// %bb.0:                               // %B24
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB433_13
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB433_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB433_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB433_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x0
.LBB433_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB433_13
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB433_11
// %bb.7:                               // %B13
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
.LBB433_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB433_13
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
.LBB433_10:                             // %B19
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	ldr	x0, [x25, x8, lsl #3]
	sub	x20, x20, #8
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x0
.LBB433_11:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB433_13
// %bb.12:                              // %B11
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB433_10
.LBB433_13:                             // %B21
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        // =0xa6
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB433_15
// %bb.14:                              // %B23
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB433_15:                             // %B22
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
// %bb.0:                               // %B1
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
	b.eq	.LBB434_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB434_2:                              // %B2
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
// %bb.0:                               // %B1
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
	b.eq	.LBB435_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB435_2:                              // %B2
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
// %bb.0:                               // %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB436_13
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB436_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB436_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB436_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x0
.LBB436_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB436_13
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB436_11
// %bb.7:                               // %B33
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
.LBB436_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB436_13
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB436_10:                             // %B39
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
.LBB436_11:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB436_13
// %bb.12:                              // %B32
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB436_10
.LBB436_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB436_15
.LBB436_14:                             // %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB436_15:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB436_17
// %bb.16:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB436_14
	b	.LBB436_20
.LBB436_17:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB436_20
// %bb.18:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB436_21
// %bb.19:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB436_21
.LBB436_20:                             // %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB436_21:                             // %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB436_23
// %bb.22:                              // %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB436_23:                             // %B42
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
// %bb.0:                               // %B44
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB437_13
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB437_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB437_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB437_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x0
.LBB437_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB437_13
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB437_11
// %bb.7:                               // %B33
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
.LBB437_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB437_13
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB437_10:                             // %B39
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
.LBB437_11:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB437_13
// %bb.12:                              // %B32
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB437_10
.LBB437_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB437_15
.LBB437_14:                             // %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB437_15:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB437_17
// %bb.16:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB437_14
	b	.LBB437_20
.LBB437_17:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB437_20
// %bb.18:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB437_21
// %bb.19:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB437_21
.LBB437_20:                             // %B15
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB437_21:                             // %B41
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB437_23
// %bb.22:                              // %B43
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB437_23:                             // %B42
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
// %bb.0:                               // %B30
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB438_13
// %bb.1:                               // %B30
	cmp	x21, x8
	b.hi	.LBB438_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB438_5
// %bb.3:                               // %B21
	cmp	x21, x8
	b.lo	.LBB438_8
// %bb.4:                               // %B26
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x0
.LBB438_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB438_13
// %bb.6:                               // %B14
	cmp	x21, x8
	b.lo	.LBB438_11
// %bb.7:                               // %B19
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
.LBB438_8:                              // %B23
	tst	x21, #0xfffe000000000000
	b.eq	.LBB438_13
// %bb.9:                               // %B25
	scvtf	d0, w22
	add	x8, x21, x8
.LBB438_10:                             // %B25
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
.LBB438_11:                             // %B16
	tst	x21, #0xfffe000000000000
	b.eq	.LBB438_13
// %bb.12:                              // %B18
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB438_10
.LBB438_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB438_15
// %bb.14:                              // %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB438_15:                             // %B10
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
	b.ne	.LBB438_17
// %bb.16:                              // %B10
	tbnz	w8, #0, .LBB438_18
.LBB438_17:                             // %B12
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB438_18:                             // %B27
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB438_20
// %bb.19:                              // %B29
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB438_20:                             // %B28
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
// %bb.0:                               // %B30
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB439_13
// %bb.1:                               // %B30
	cmp	x21, x8
	b.hi	.LBB439_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB439_5
// %bb.3:                               // %B21
	cmp	x21, x8
	b.lo	.LBB439_8
// %bb.4:                               // %B26
	ldrb	w8, [x19], #1
	cmp	w22, w21
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x0
.LBB439_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB439_13
// %bb.6:                               // %B14
	cmp	x21, x8
	b.lo	.LBB439_11
// %bb.7:                               // %B19
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
.LBB439_8:                              // %B23
	tst	x21, #0xfffe000000000000
	b.eq	.LBB439_13
// %bb.9:                               // %B25
	scvtf	d0, w22
	add	x8, x21, x8
.LBB439_10:                             // %B25
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
.LBB439_11:                             // %B16
	tst	x21, #0xfffe000000000000
	b.eq	.LBB439_13
// %bb.12:                              // %B18
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB439_10
.LBB439_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB439_15
// %bb.14:                              // %B8
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB439_15:                             // %B10
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
	b.ne	.LBB439_17
// %bb.16:                              // %B10
	tbnz	w8, #0, .LBB439_18
.LBB439_17:                             // %B12
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB439_18:                             // %B27
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB439_20
// %bb.19:                              // %B29
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB439_20:                             // %B28
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
// %bb.0:                               // %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB440_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB440_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB440_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB440_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	and	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB440_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB440_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB440_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB440_9
// %bb.8:                               // %B15
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
.LBB440_9:                              // %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        // =0xad
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB440_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB440_11:                             // %B26
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
// %bb.0:                               // %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB441_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB441_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB441_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB441_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	eor	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB441_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB441_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB441_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB441_9
// %bb.8:                               // %B15
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
.LBB441_9:                              // %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        // =0xae
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB441_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB441_11:                             // %B26
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
// %bb.0:                               // %B28
	mov	x21, x22
	ldur	x22, [x20, #-8]
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB442_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB442_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB442_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB442_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w10, [x19], #1
	sub	x20, x20, #8
	orr	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB442_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB442_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB442_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB442_9
// %bb.8:                               // %B15
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
.LBB442_9:                              // %B25
	mov	x8, x20
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        // =0xaf
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB442_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	sub	x20, x20, #8
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB442_11:                             // %B26
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	ldrb	w10, [x19], #2
	ldr	x0, [x25, x8, lsl #3]
	ldr	x21, [x23, x10, lsl #3]
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
// %bb.0:                               // %B1
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
	b.eq	.LBB456_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	add	x19, x19, #2
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB456_2:                              // %B2
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
// %bb.0:                               // %B1
	mov	x8, x20
	mov	x0, x24
	mov	w1, #47                         // =0x2f
	mov	w2, #1                          // =0x1
	str	x22, [x8], #8
	str	x8, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB457_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	add	x25, x25, #1936
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB457_2:                              // %B2
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
// %bb.0:                               // %B0
	ldrb	w8, [x19, #1]
	add	x25, x25, #1936
	ldrb	w10, [x19], #2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
	mov	x21, x22
	mov	w9, #48                         // =0x30
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB497_2
.LBB497_1:                              // %B7
	ldrb	w8, [x19], #1
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB497_2:                              // %B3
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
	b.ne	.LBB497_1
// %bb.3:                               // %B4
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
// %bb.0:                               // %B23
	cmp	x22, #5
	b.le	.LBB498_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB498_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB498_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB498_6
	b	.LBB498_7
.LBB498_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB498_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB498_7
.LBB498_6:                              // %B3
	ldrsb	x8, [x19]
	sub	x25, x25, #1936
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB498_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB498_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB498_10
.LBB498_9:                              // %B19
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB498_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB498_13
// %bb.11:                              // %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB498_6
	b.vs	.LBB498_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB498_9
	b	.LBB498_6
.LBB498_13:                             // %B15
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
// %bb.0:                               // %B23
	cmp	x22, #5
	b.le	.LBB499_4
// %bb.1:                               // %B23
	cmp	x22, #6
	b.eq	.LBB499_6
// %bb.2:                               // %B23
	cmp	x22, #7
	b.eq	.LBB499_9
// %bb.3:                               // %B23
	cmp	x22, #18
	b.eq	.LBB499_6
	b	.LBB499_7
.LBB499_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.eq	.LBB499_6
// %bb.5:                               // %B23
	cmp	x22, #2
	b.ne	.LBB499_7
.LBB499_6:                              // %B3
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB499_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x22, x8
	b.hs	.LBB499_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB499_10
.LBB499_9:                              // %B19
	ldrsb	x8, [x19]
	sub	x25, x25, #1936
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB499_10:                             // %B13
	tst	x22, #0xfffe000000000000
	b.eq	.LBB499_13
// %bb.11:                              // %B17
	add	x8, x22, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB499_6
	b.vs	.LBB499_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB499_9
	b	.LBB499_6
.LBB499_13:                             // %B15
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B2
	cmp	x22, #18
	b.ne	.LBB506_2
// %bb.1:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB506_2:                              // %B5
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
// %bb.0:                               // %B2
	cmp	x22, #2
	b.ne	.LBB507_2
// %bb.1:                               // %B3
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB507_2:                              // %B5
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
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x22
	bl	js_operator_typeof_gc
	cmp	w0, #27
	b.ne	.LBB508_2
// %bb.1:                               // %B2
	mov	w22, #7                         // =0x7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB508_2:                              // %B5
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrsw	x8, [x19]
	ldrb	w10, [x19, #4]
	add	x19, x19, #5
	ldr	x8, [x23, x8, lsl #3]
	ldr	x0, [x25, x10, lsl #3]
	mov	x21, x8
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
// %bb.0:                               // %B1
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
	b.eq	.LBB512_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB512_2:                              // %B2
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
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	mov	w2, wzr
	ldr	w1, [x19]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB513_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB513_2:                              // %B2
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
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	mov	w2, #4                          // =0x4
	ldr	w1, [x19]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x29, #64]
	bl	JS_NewSymbolFromAtom_GC
	cmp	x0, #130
	b.eq	.LBB514_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB514_2:                              // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B12
	str	x22, [x20], #8
	ldr	w8, [x29, #60]
	ldr	x1, [x29, #112]
	tbnz	w8, #0, .LBB517_2
// %bb.1:                               // %B12
	ldr	x8, [x29, #112]
	and	x10, x8, #0xfffffffffffffffe
	and	x10, x10, #0xffff000000000003
	cbnz	x10, .LBB517_3
.LBB517_2:                              // %B3
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB517_3:                              // %B6
	orr	x8, x8, #0x10
	cmp	x8, #18
	b.ne	.LBB517_5
// %bb.4:                               // %B7
	ldrb	w8, [x19], #1
	ldr	x10, [x24, #224]
	mov	x22, x21
	ldr	x0, [x25, x8, lsl #3]
	mov	x21, x10
	br	x0
.LBB517_5:                              // %B9
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_ToObject_GC
	cmp	x0, #130
	b.eq	.LBB517_7
// %bb.6:                               // %B11
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB517_7:                              // %B10
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x29, #64]
	bl	PRIM_JS_NewObject_GC
	cmp	x0, #130
	b.eq	.LBB520_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB520_2:                              // %B2
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
// %bb.0:                               // %B15
	str	x22, [x20], #8
	ldrb	w8, [x19]
	cmp	w8, #2
	b.gt	.LBB521_4
// %bb.1:                               // %B15
	cbz	w8, .LBB521_8
// %bb.2:                               // %B15
	cmp	w8, #1
	b.ne	.LBB521_13
// %bb.3:                               // %B6
	ldr	x8, [x29, #8]
	ldr	w1, [x29, #144]
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
	b	.LBB521_9
.LBB521_4:                              // %B15
	cmp	w8, #5
	b.eq	.LBB521_11
// %bb.5:                               // %B15
	cmp	w8, #4
	b.ne	.LBB521_14
// %bb.6:                               // %B9
	ldr	x8, [x29, #8]
	mov	w10, #18                        // =0x12
	ldr	x8, [x8, #64]
	cmp	x8, #0
	csel	x0, x10, x8, eq
.LBB521_7:                              // %B5
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB521_8:                              // %B1
	ldr	w1, [x29, #144]
	mov	x8, x20
	mov	x0, x24
	mov	x2, x28
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	js_build_arguments_gc
.LBB521_9:                              // %B6
	cmp	x0, #130
	b.ne	.LBB521_7
// %bb.10:                              // %B7
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.LBB521_11:                             // %B12
	mov	x8, x20
	mov	x0, x24
	mov	w1, #2                          // =0x2
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_NewObjectProto
	cmp	x0, #130
	b.ne	.LBB521_7
// %bb.12:                              // %B13
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.LBB521_13:                             // %B18
	ldr	x0, [x29, #8]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB521_14:                             // %B19
	ldr	x0, [x29, #120]
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
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	mov	x3, x28
	ldrh	w1, [x19]
	ldr	w2, [x29, #144]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x29, #64]
	bl	js_build_rest_gc
	cmp	x0, #130
	b.eq	.LBB522_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB522_2:                              // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B5
	mov	x8, #2                          // =0x2
	str	x22, [x20], #8
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB551_3
// %bb.1:                               // %B2
	cmp	x21, #18
	b.eq	.LBB551_4
// %bb.2:                               // %B3
	mov	x8, x20
	adrp	x1, .L__unnamed_17
	add	x1, x1, :lo12:.L__unnamed_17
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	LEPUS_ThrowTypeError
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.LBB551_3:                              // %B6
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	w21, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB551_4:                              // %B4
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
// %bb.0:                               // %B2
	ldr	x8, [x29, #120]
	cmp	x8, #18
	b.ne	.LBB552_2
// %bb.1:                               // %B3
	add	x8, x20, #16
	adrp	x1, .L__unnamed_18
	add	x1, x1, :lo12:.L__unnamed_18
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_ThrowTypeError
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.LBB552_2:                              // %B4
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
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_CheckBrand_GC
	tbnz	w0, #31, .LBB553_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB553_2:                              // %B2
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
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_AddBrand_GC
	tbnz	w0, #31, .LBB554_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x25, x25, #3872
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB554_2:                              // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	w1, #18                         // =0x12
	mov	x2, x22
	mov	x3, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	js_regexp_constructor_internal_gc
	cmp	x0, #130
	b.eq	.LBB559_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB559_2:                              // %B2
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
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	primjs_get_super_ctor_gc
	cmp	x0, #130
	b.eq	.LBB560_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB560_2:                              // %B2
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
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_GetPrototype
	cmp	x0, #130
	b.eq	.LBB561_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB561_2:                              // %B2
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
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	js_dynamic_import
	cmp	x0, #130
	b.eq	.LBB562_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB562_2:                              // %B2
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
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	ldr	w1, [x19]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x29, #64]
	bl	JS_CheckGlobalVar_GC
	tbnz	w0, #31, .LBB563_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	mov	x22, x21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x21, x8, ne
	br	x0
.LBB563_2:                              // %B2
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
// %bb.0:                               // %B1
	str	x22, [x20], #8
	ldr	w9, [x19]
	bl	common_get_var_undef_asm_h
	cmp	x0, #130
	b.eq	.LBB564_3
// %bb.1:                               // %B1
	cmp	x0, #34
	b.eq	.LBB564_5
.LBB564_2:                              // %B10
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB564_3:                              // %B3
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, wzr
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.ne	.LBB564_2
// %bb.4:                               // %B4
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.LBB564_5:                              // %B9
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
// %bb.0:                               // %B1
	str	x22, [x20], #8
	ldr	w9, [x19]
	bl	common_get_var_asm_h
	cmp	x0, #130
	b.eq	.LBB565_3
// %bb.1:                               // %B1
	cmp	x0, #34
	b.eq	.LBB565_5
.LBB565_2:                              // %B10
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB565_3:                              // %B3
	ldr	w1, [x19]
	mov	x8, x20
	mov	x0, x24
	mov	w2, #1                          // =0x1
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_GetGlobalVarImpl_GC
	cmp	x0, #130
	b.ne	.LBB565_2
// %bb.4:                               // %B4
	sub	x25, x25, #3872
	b	exception_spill_top1_asm_h
.LBB565_5:                              // %B9
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB566_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB566_2:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB567_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB567_2:                              // %B2
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
// %bb.0:                               // %B5
	cmp	x22, #7
	b.ne	.LBB568_3
// %bb.1:                               // %B1
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	w3, #2                          // =0x2
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_SetGlobalVar
	tbnz	w0, #31, .LBB568_4
// %bb.2:                               // %B4
	ldrb	w8, [x19, #4]
	sub	x25, x25, #3872
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB568_3:                              // %B6
	ldr	w1, [x19]
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB568_4:                              // %B2
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
// %bb.0:                               // %B8
	cmp	x22, #18
	str	x22, [x20]
	mov	x0, x24
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x29, #64]
	b.eq	.LBB569_3
// %bb.1:                               // %B1
	mov	x1, x22
	mov	x2, x21
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.eq	.LBB569_5
// %bb.2:                               // %B4
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB569_3:                              // %B5
	mov	x1, x21
	bl	js_value_to_atom_gc
	cbz	w0, .LBB569_5
// %bb.4:                               // %B7
	mov	w1, w0
	mov	x8, x20
	mov	x0, x24
	str	x21, [x8], #8
	str	x8, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB569_5:                              // %B6
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
// %bb.0:                               // %B12
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	ldur	x1, [x20, #-8]
	cmp	x1, #18
	b.eq	.LBB570_3
.LBB570_1:                              // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #32768                      // =0x8000
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_SetPropertyValue_GC
	tbnz	w0, #31, .LBB570_7
// %bb.2:                               // %B4
	ldrb	w8, [x19], #1
	sub	x25, x25, #3872
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.LBB570_3:                              // %B8
	ldr	w8, [x29, #60]
	tbnz	w8, #0, .LBB570_5
// %bb.4:                               // %B9
	ldr	x1, [x24, #224]
	b	.LBB570_1
.LBB570_5:                              // %B5
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	stp	x22, x21, [x20]
	str	x8, [sp, #8]                    // 8-byte Folded Spill
	str	x8, [x29, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB570_7
// %bb.6:                               // %B7
	ldr	x8, [sp, #8]                    // 8-byte Folded Reload
	mov	w1, w0
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_ThrowReferenceErrorNotDefined_GC
.LBB570_7:                              // %B6
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_DefineGlobalVar_GC
	tbnz	w0, #31, .LBB571_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB571_2:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w2, [x19, #4]
	add	x8, x20, #16
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_CheckDefineGlobalVar_GC
	tbnz	w0, #31, .LBB572_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #5]
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB572_2:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w1, [x19]
	ldrb	w3, [x19, #4]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_DefineGlobalFunction_GC
	tbnz	w0, #31, .LBB573_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #5]
	sub	x25, x25, #1936
	add	x19, x19, #6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB573_2:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w9, [x19]
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB574_2
.LBB574_1:                              // %B7
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB574_2:                              // %B3
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
	b.ne	.LBB574_1
// %bb.3:                               // %B4
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
// %bb.0:                               // %B1
	str	x22, [x20], #8
	ldr	w9, [x19]
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB575_2
.LBB575_1:                              // %B7
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB575_2:                              // %B3
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
	b.ne	.LBB575_1
// %bb.3:                               // %B4
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_GetPrivateField_GC
	cmp	x0, #130
	b.eq	.LBB577_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB577_2:                              // %B2
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
// %bb.0:                               // %B1
	ldur	x1, [x20, #-8]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x21
	mov	x3, x22
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_SetPrivateField_GC
	tbnz	w0, #31, .LBB578_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x25, x25, #3872
	sub	x20, x20, #8
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB578_2:                              // %B2
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
// %bb.0:                               // %B1
	ldur	x1, [x20, #-8]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_DefinePrivateField_GC
	tbnz	w0, #31, .LBB579_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x25, x25, #3872
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB579_2:                              // %B2
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
// %bb.0:                               // %B5
	bl	common_get_property_value_asm_h
	cmp	x0, #130
	b.eq	.LBB580_2
.LBB580_1:                              // %B7
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB580_2:                              // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.ne	.LBB580_1
// %bb.3:                               // %B2
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
// %bb.0:                               // %B5
	bl	common_get_property_value_asm_h
	cmp	x0, #130
	b.eq	.LBB581_2
.LBB581_1:                              // %B7
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB581_2:                              // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_GetPropertyValue_GC
	cmp	x0, #130
	b.ne	.LBB581_1
// %bb.3:                               // %B2
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
// %bb.0:                               // %B0
	mov	x8, x20
	ldur	x9, [x20, #-8]
	add	x20, x20, #16
	sub	x25, x25, #3872
	stp	x22, x21, [x8]
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
// %bb.0:                               // %B1
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x19, [sp, #8]                   // 8-byte Folded Spill
	add	x19, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x19, [x29, #64]
	bl	js_value_to_atom_gc
	cbz	w0, .LBB583_3
// %bb.1:                               // %B5
	ldur	x3, [x20, #-8]
	mov	w2, w0
	mov	x0, x24
	mov	x1, x22
	mov	w4, wzr
	stp	x22, x21, [x20]
	str	x19, [x29, #64]
	bl	JS_GetPropertyInternalImpl_GC
	cmp	x0, #130
	b.eq	.LBB583_3
// %bb.2:                               // %B7
	ldr	x19, [sp, #8]                   // 8-byte Folded Reload
	stur	x0, [x20, #-8]
	sub	x25, x25, #3872
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	add	sp, sp, #16
	br	x0
.LBB583_3:                              // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
	ldr	w2, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x3, x21
	mov	w4, #16391                      // =0x4007
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_DefinePropertyValue
	tbnz	w0, #31, .LBB585_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB585_2:                              // %B2
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
// %bb.0:                               // %B1
	ldr	w2, [x19]
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_DefineObjectName
	tbnz	w0, #31, .LBB586_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB586_2:                              // %B2
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
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	x2, x22
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_DefineObjectNameComputed_GC
	tbnz	w0, #31, .LBB587_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB587_2:                              // %B2
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
// %bb.0:                               // %B6
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.eq	.LBB588_3
// %bb.1:                               // %B6
	cmp	x21, #2
	b.eq	.LBB588_3
.LBB588_2:                              // %B5
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB588_3:                              // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_SetPrototypeInternal_GC
	tbz	w0, #31, .LBB588_2
// %bb.4:                               // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
	ldur	x1, [x20, #-8]
	add	x8, x20, #16
	mov	x0, x24
	mov	x2, x22
	mov	x3, x21
	mov	w4, #16391                      // =0x4007
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	JS_DefinePropertyValueValue_GC
	tbnz	w0, #31, .LBB590_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB590_2:                              // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B2
	str	x22, [x20], #8
	ldrh	w8, [x19]
	ldr	x8, [x27, x8, lsl #3]
	cmp	x8, #34
	b.eq	.LBB606_2
// %bb.1:                               // %B4
	ldrb	w10, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB606_2:                              // %B3
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
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x10, [x27, x8, lsl #3]
	cmp	x10, #34
	b.eq	.LBB607_2
// %bb.1:                               // %B4
	str	x21, [x27, w8, uxtw #3]
	sub	x25, x25, #1936
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB607_2:                              // %B3
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
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x10, [x27, x8, lsl #3]
	cmp	x10, #34
	b.ne	.LBB608_2
// %bb.1:                               // %B4
	str	x21, [x27, w8, uxtw #3]
	sub	x25, x25, #1936
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB608_2:                              // %B3
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
// %bb.0:                               // %B2
	str	x22, [x20], #8
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x8, [x8]
	cmp	x8, #34
	b.eq	.LBB609_2
// %bb.1:                               // %B4
	ldrb	w10, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	mov	x21, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB609_2:                              // %B3
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
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x10, [x8]
	cmp	x10, #34
	b.eq	.LBB610_2
// %bb.1:                               // %B4
	str	x21, [x8]
	sub	x25, x25, #1936
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB610_2:                              // %B3
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
// %bb.0:                               // %B2
	ldrh	w8, [x19]
	ldr	x8, [x26, x8, lsl #3]
	ldr	x8, [x8, #32]
	ldr	x10, [x8]
	cmp	x10, #34
	b.ne	.LBB611_2
// %bb.1:                               // %B4
	str	x21, [x8]
	sub	x25, x25, #1936
	ldrb	w8, [x19, #2]
	add	x19, x19, #3
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB611_2:                              // %B3
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B23
	cmp	x21, #5
	b.le	.LBB613_4
// %bb.1:                               // %B23
	cmp	x21, #6
	b.eq	.LBB613_6
// %bb.2:                               // %B23
	cmp	x21, #7
	b.eq	.LBB613_9
// %bb.3:                               // %B23
	cmp	x21, #18
	b.eq	.LBB613_6
	b	.LBB613_7
.LBB613_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB613_6
// %bb.5:                               // %B23
	cmp	x21, #2
	b.ne	.LBB613_7
.LBB613_6:                              // %B3
	ldrsw	x8, [x19]
	sub	x25, x25, #1936
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB613_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x21, x8
	b.hs	.LBB613_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB613_10
.LBB613_9:                              // %B19
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB613_10:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB613_13
// %bb.11:                              // %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB613_6
	b.vs	.LBB613_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB613_9
	b	.LBB613_6
.LBB613_13:                             // %B15
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
// %bb.0:                               // %B23
	cmp	x21, #5
	b.le	.LBB614_4
// %bb.1:                               // %B23
	cmp	x21, #6
	b.eq	.LBB614_6
// %bb.2:                               // %B23
	cmp	x21, #7
	b.eq	.LBB614_9
// %bb.3:                               // %B23
	cmp	x21, #18
	b.eq	.LBB614_6
	b	.LBB614_7
.LBB614_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB614_6
// %bb.5:                               // %B23
	cmp	x21, #2
	b.ne	.LBB614_7
.LBB614_6:                              // %B3
	ldrb	w8, [x19, #4]
	sub	x25, x25, #1936
	add	x19, x19, #5
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB614_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x21, x8
	b.hs	.LBB614_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB614_10
.LBB614_9:                              // %B19
	ldrsw	x8, [x19]
	sub	x25, x25, #1936
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB614_10:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB614_13
// %bb.11:                              // %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB614_6
	b.vs	.LBB614_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB614_9
	b	.LBB614_6
.LBB614_13:                             // %B15
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	w8, #66                         // =0x42
	ldr	x10, [x29, #8]
	ldrb	w11, [x19, #4]
	ldr	w12, [x19]
	mov	x22, x21
	ldr	x10, [x10, #48]
	ldr	x0, [x25, x11, lsl #3]
	ldr	x10, [x10, #8]
	sub	x10, x19, x10
	add	x19, x19, #5
	add	x10, x10, x12
	orr	x21, x8, x10, lsl #16
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B6
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB618_3
// %bb.1:                               // %B1
	ldr	x8, [x29, #8]
	ldr	x8, [x8, #48]
	ldr	w10, [x8, #16]
	cmp	w21, w10
	b.ge	.LBB618_3
// %bb.2:                               // %B5
	ldr	x8, [x8, #8]
	sub	x25, x25, #1936
	add	x19, x8, w21, sxtw
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB618_3:                              // %B3
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
// %bb.0:                               // %B2
	mov	x8, #2                          // =0x2
	movk	x8, #65535, lsl #48
	tst	x21, x8
	b.ne	.LBB619_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB619_2:                              // %B4
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
// %bb.0:                               // %B15
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB620_4
// %bb.1:                               // %B15
	mov	x10, #1                         // =0x1
	and	x8, x21, #0xffff000000000003
	movk	x10, #1, lsl #48
	add	x11, x10, #1
	cmp	x8, x11
	b.eq	.LBB620_4
// %bb.2:                               // %B15
	cmp	x8, x10
	b.eq	.LBB620_4
// %bb.3:                               // %B15
	mov	x10, #-281474976710653          // =0xffff000000000003
	cmp	x8, x10
	b.ne	.LBB620_5
.LBB620_4:                              // %B3
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB620_5:                              // %B12
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB620_7
// %bb.6:                               // %B14
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB620_7:                              // %B13
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
// %bb.0:                               // %B18
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.ne	.LBB621_3
// %bb.1:                               // %B19
	add	x8, x20, #16
	adrp	x1, .L__unnamed_20
	add	x1, x1, :lo12:.L__unnamed_20
	mov	x0, x24
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_ThrowTypeError
.LBB621_2:                              // %B16
	sub	x25, x25, #3872
	b	exception_spill_top0_top1_asm_h
.LBB621_3:                              // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.eq	.LBB621_7
// %bb.4:                               // %B2
	mov	x10, #1                         // =0x1
	and	x8, x21, #0xffff000000000003
	movk	x10, #1, lsl #48
	add	x11, x10, #1
	cmp	x8, x11
	b.eq	.LBB621_7
// %bb.5:                               // %B2
	cmp	x8, x10
	b.eq	.LBB621_7
// %bb.6:                               // %B2
	mov	x10, #-281474976710653          // =0xffff000000000003
	cmp	x8, x10
	b.ne	.LBB621_8
.LBB621_7:                              // %B4
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB621_8:                              // %B15
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	LEPUS_ToPropertyKey
	cmp	x0, #130
	b.eq	.LBB621_2
// %bb.9:                               // %B17
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_for_in_start_gc
	cmp	x0, #130
	b.eq	.LBB632_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB632_2:                              // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	.LBB649_3
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB649_6
// %bb.2:                               // %B13
	orr	w8, w21, #0x80000000
	mov	w10, #-2147483648               // =0x80000000
	cmp	w8, w10
	b.ne	.LBB649_5
.LBB649_3:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #140                        // =0x8c
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB649_8
// %bb.4:                               // %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB649_5:                              // %B15
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	neg	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x0
.LBB649_6:                              // %B3
	tst	x21, #0xfffe000000000000
	b.eq	.LBB649_3
// %bb.7:                               // %B7
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
.LBB649_8:                              // %B17
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
// %bb.0:                               // %B13
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	.LBB650_4
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB650_3
.LBB650_2:                              // %B7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB650_3:                              // %B3
	tst	x21, #0xfffe000000000000
	b.ne	.LBB650_2
.LBB650_4:                              // %B10
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #141                        // =0x8d
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB650_6
// %bb.5:                               // %B12
	mov	x21, x0
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB650_6:                              // %B11
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
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	.LBB651_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB651_4
// %bb.2:                               // %B13
	subs	w8, w21, #1
	b.vs	.LBB651_6
// %bb.3:                               // %B15
	ldrb	w10, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB651_4:                              // %B3
	tst	x21, #0xfffe000000000000
	b.eq	.LBB651_6
// %bb.5:                               // %B7
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
.LBB651_6:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #142                        // =0x8e
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB651_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB651_8:                              // %B17
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
// %bb.0:                               // %B19
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x21, x8
	b.hi	.LBB652_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB652_4
// %bb.2:                               // %B13
	adds	w8, w21, #1
	b.vs	.LBB652_6
// %bb.3:                               // %B15
	ldrb	w10, [x19], #1
	orr	x21, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB652_4:                              // %B3
	tst	x21, #0xfffe000000000000
	b.eq	.LBB652_6
// %bb.5:                               // %B7
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
.LBB652_6:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x21
	mov	w2, #143                        // =0x8f
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB652_8
// %bb.7:                               // %B18
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB652_8:                              // %B17
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
// %bb.0:                               // %B16
	mov	x8, #-281474976710656           // =0xffff000000000000
	str	x22, [x20], #8
	cmp	x21, x8
	b.hs	.LBB653_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB653_4
// %bb.2:                               // %B13
	subs	w8, w21, #1
	b.vs	.LBB653_6
// %bb.3:                               // %B15
	ldrb	w10, [x19], #1
	mov	x22, x21
	orr	x21, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB653_4:                              // %B3
	tst	x21, #0xfffe000000000000
	b.eq	.LBB653_6
// %bb.5:                               // %B8
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
.LBB653_6:                              // %B5
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
// %bb.0:                               // %B16
	mov	x8, #-281474976710656           // =0xffff000000000000
	str	x22, [x20], #8
	cmp	x21, x8
	b.hs	.LBB654_6
// %bb.1:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB654_4
// %bb.2:                               // %B13
	adds	w8, w21, #1
	b.vs	.LBB654_6
// %bb.3:                               // %B15
	ldrb	w10, [x19], #1
	mov	x22, x21
	orr	x21, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB654_4:                              // %B3
	tst	x21, #0xfffe000000000000
	b.eq	.LBB654_6
// %bb.5:                               // %B8
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
.LBB654_6:                              // %B5
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
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	b.hi	.LBB655_6
// %bb.1:                               // %B2
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB655_4
// %bb.2:                               // %B13
	subs	w10, w1, #1
	b.vs	.LBB655_6
// %bb.3:                               // %B15
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB655_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB655_6
// %bb.5:                               // %B8
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
.LBB655_6:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #142                        // =0x8e
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB655_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB655_8:                              // %B17
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
// %bb.0:                               // %B19
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	b.hi	.LBB656_6
// %bb.1:                               // %B2
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB656_4
// %bb.2:                               // %B13
	adds	w10, w1, #1
	b.vs	.LBB656_6
// %bb.3:                               // %B15
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB656_4:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB656_6
// %bb.5:                               // %B8
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
.LBB656_6:                              // %B16
	add	x8, x20, #16
	mov	x0, x24
	mov	w2, #143                        // =0x8f
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_unary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB656_8
// %bb.7:                               // %B18
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB656_8:                              // %B17
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
// %bb.0:                               // %B45
	ldrb	w8, [x19]
	mov	x10, #-281474976710657          // =0xfffeffffffffffff
	ldr	x1, [x27, x8, lsl #3]
	cmp	x1, x10
	ccmp	x21, x10, #2, ls
	b.hi	.LBB657_14
// %bb.1:                               // %B2
	mov	x10, #-562949953421312          // =0xfffe000000000000
	cmp	x1, x10
	b.lo	.LBB657_5
// %bb.2:                               // %B26
	cmp	x21, x10
	b.lo	.LBB657_8
// %bb.3:                               // %B36
	adds	w10, w1, w21
	b.vs	.LBB657_14
// %bb.4:                               // %B38
	orr	x10, x10, #0xfffe000000000000
	str	x10, [x27, w8, uxtw #3]
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB657_5:                              // %B4
	tst	x1, #0xfffe000000000000
	b.eq	.LBB657_14
// %bb.6:                               // %B11
	cmp	x21, x10
	b.lo	.LBB657_12
// %bb.7:                               // %B21
	scvtf	d0, w21
	add	x10, x1, x10
	fmov	d1, x10
	fadd	d0, d1, d0
	b	.LBB657_11
.LBB657_8:                              // %B28
	tst	x21, #0xfffe000000000000
	b.eq	.LBB657_14
// %bb.9:                               // %B31
	scvtf	d0, w1
	add	x10, x21, x10
.LBB657_10:                             // %B31
	fmov	d1, x10
	fadd	d0, d0, d1
.LBB657_11:                             // %B31
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
.LBB657_12:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB657_14
// %bb.13:                              // %B16
	add	x11, x1, x10
	add	x10, x21, x10
	fmov	d0, x11
	b	.LBB657_10
.LBB657_14:                             // %B7
	mov	x8, #2                          // =0x2
	and	x10, x1, #0xffff000000000003
	add	x11, x20, #16
	movk	x8, #1, lsl #48
	stp	x22, x21, [x20]
	cmp	x10, x8
	str	x11, [x29, #64]
	b.ne	.LBB657_17
// %bb.15:                              // %B7
	and	x10, x21, #0xffff000000000003
	cmp	x10, x8
	b.ne	.LBB657_17
// %bb.16:                              // %B39
	mov	x0, x24
	mov	x2, x21
	bl	JS_ConcatString_GC
	b	.LBB657_18
.LBB657_17:                             // %B42
	mov	x0, x24
	mov	x2, x21
	bl	prim_js_add_slow_gc
.LBB657_18:                             // %B42
	cmp	x0, #130
	b.eq	.LBB657_20
// %bb.19:                              // %B44
	ldrb	w8, [x19]
	str	x0, [x27, x8, lsl #3]
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB657_20:                             // %B43
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
// %bb.0:                               // %B2
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB658_2
// %bb.1:                               // %B3
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	mvn	w8, w21
	orr	x21, x8, #0xfffe000000000000
	br	x0
.LBB658_2:                              // %B4
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
// %bb.0:                               // %B14
	cmp	x21, #5
	b.le	.LBB659_4
// %bb.1:                               // %B14
	cmp	x21, #6
	b.eq	.LBB659_6
// %bb.2:                               // %B14
	cmp	x21, #7
	b.eq	.LBB659_8
// %bb.3:                               // %B14
	cmp	x21, #18
	b.eq	.LBB659_6
	b	.LBB659_7
.LBB659_4:                              // %B14
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB659_6
// %bb.5:                               // %B14
	cmp	x21, #2
	b.ne	.LBB659_7
.LBB659_6:                              // %B3
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB659_7:                              // %B10
	mov	w8, #65534                      // =0xfffe
	cmp	x8, x21, lsr #48
	b.ne	.LBB659_9
.LBB659_8:                              // %B12
	mov	w21, #6                         // =0x6
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB659_9:                              // %B13
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
// %bb.0:                               // %B1
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
	b.eq	.LBB660_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB660_2:                              // %B2
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
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_operator_delete_gc
	cmp	x0, #130
	b.eq	.LBB661_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB661_2:                              // %B2
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
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	mov	w3, wzr
	ldr	w2, [x19]
	ldr	x1, [x24, #224]
	str	x21, [x20, #8]!
	add	x8, x20, #8
	str	x8, [x29, #64]
	bl	LEPUS_DeleteProperty
	tbnz	w0, #31, .LBB662_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #4]
	cmp	w0, #0
	add	x19, x19, #5
	mov	x22, x21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x21, x8, ne
	br	x0
.LBB662_2:                              // %B2
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
// %bb.0:                               // %B47
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB663_18
// %bb.1:                               // %B47
	cmp	x21, x8
	b.hi	.LBB663_18
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB663_8
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB663_11
// %bb.4:                               // %B33
	smull	x8, w22, w21
	cmp	x8, w8, sxtw
	b.ne	.LBB663_18
// %bb.5:                               // %B36
	cbnz	w8, .LBB663_7
// %bb.6:                               // %B36
	orr	w10, w22, w21
	tbnz	w10, #31, .LBB663_15
.LBB663_7:                              // %B43
	mov	w8, w8
	orr	x22, x8, #0xfffe000000000000
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB663_8:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB663_18
// %bb.9:                               // %B7
	cmp	x21, x8
	b.lo	.LBB663_16
// %bb.10:                              // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fmul	d0, d1, d0
	b	.LBB663_14
.LBB663_11:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB663_18
// %bb.12:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB663_13:                             // %B28
	fmov	d1, x8
	fmul	d0, d0, d1
.LBB663_14:                             // %B28
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
.LBB663_15:                             // %B40
	mov	x22, #-9222809086901354496      // =0x8002000000000000
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB663_16:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB663_18
// %bb.17:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB663_13
.LBB663_18:                             // %B44
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #154                        // =0x9a
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB663_20
// %bb.19:                              // %B46
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB663_20:                             // %B45
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
// %bb.0:                               // %B44
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB664_14
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB664_14
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB664_5
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB664_8
// %bb.4:                               // %B33
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
.LBB664_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB664_14
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB664_12
// %bb.7:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fdiv	d0, d1, d0
	b	.LBB664_11
.LBB664_8:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB664_14
// %bb.9:                               // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB664_10:                             // %B28
	fmov	d1, x8
	fdiv	d0, d0, d1
.LBB664_11:                             // %B28
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
.LBB664_12:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB664_14
// %bb.13:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB664_10
.LBB664_14:                             // %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #155                        // =0x9b
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB664_16
// %bb.15:                              // %B43
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB664_16:                             // %B42
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
// %bb.0:                               // %B39
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB665_16
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB665_16
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB665_7
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB665_10
// %bb.4:                               // %B33
	tbnz	w22, #31, .LBB665_16
// %bb.5:                               // %B33
	cmp	w21, #1
	b.lt	.LBB665_16
// %bb.6:                               // %B35
	sdiv	w8, w22, w21
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	ldr	x0, [x25, x10, lsl #3]
	msub	w8, w8, w21, w22
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB665_7:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB665_16
// %bb.8:                               // %B7
	cmp	x21, x8
	b.lo	.LBB665_14
// %bb.9:                               // %B18
	add	x8, x22, x8
	scvtf	d1, w21
	fmov	d0, x8
	b	.LBB665_13
.LBB665_10:                             // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB665_16
// %bb.11:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB665_12:                             // %B28
	fmov	d1, x8
.LBB665_13:                             // %B28
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
.LBB665_14:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB665_16
// %bb.15:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB665_12
.LBB665_16:                             // %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #156                        // =0x9c
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB665_18
// %bb.17:                              // %B38
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB665_18:                             // %B37
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
// %bb.0:                               // %B45
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB666_15
// %bb.1:                               // %B45
	cmp	x21, x8
	b.hi	.LBB666_15
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB666_6
// %bb.3:                               // %B26
	cmp	x21, x8
	b.lo	.LBB666_9
// %bb.4:                               // %B36
	adds	w8, w22, w21
	b.vs	.LBB666_15
// %bb.5:                               // %B38
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB666_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB666_15
// %bb.7:                               // %B10
	cmp	x21, x8
	b.lo	.LBB666_13
// %bb.8:                               // %B21
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fadd	d0, d1, d0
	b	.LBB666_12
.LBB666_9:                              // %B28
	tst	x21, #0xfffe000000000000
	b.eq	.LBB666_15
// %bb.10:                              // %B31
	scvtf	d0, w22
	add	x8, x21, x8
.LBB666_11:                             // %B31
	fmov	d1, x8
	fadd	d0, d0, d1
.LBB666_12:                             // %B31
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
.LBB666_13:                             // %B12
	tst	x21, #0xfffe000000000000
	b.eq	.LBB666_15
// %bb.14:                              // %B15
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB666_11
.LBB666_15:                             // %B6
	mov	x8, #2                          // =0x2
	and	x10, x22, #0xffff000000000003
	add	x11, x20, #16
	movk	x8, #1, lsl #48
	stp	x22, x21, [x20]
	cmp	x10, x8
	str	x11, [x29, #64]
	b.ne	.LBB666_18
// %bb.16:                              // %B6
	and	x10, x21, #0xffff000000000003
	cmp	x10, x8
	b.ne	.LBB666_18
// %bb.17:                              // %B39
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	JS_ConcatString_GC
	b	.LBB666_19
.LBB666_18:                             // %B42
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	bl	prim_js_add_slow_gc
.LBB666_19:                             // %B42
	cmp	x0, #130
	b.eq	.LBB666_21
// %bb.20:                              // %B44
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB666_21:                             // %B43
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
// %bb.0:                               // %B39
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB667_15
// %bb.1:                               // %B39
	cmp	x21, x8
	b.hi	.LBB667_15
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB667_6
// %bb.3:                               // %B23
	cmp	x21, x8
	b.lo	.LBB667_9
// %bb.4:                               // %B33
	subs	w8, w22, w21
	b.vs	.LBB667_15
// %bb.5:                               // %B35
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	orr	x22, x8, #0xfffe000000000000
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB667_6:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB667_15
// %bb.7:                               // %B7
	cmp	x21, x8
	b.lo	.LBB667_13
// %bb.8:                               // %B18
	scvtf	d0, w21
	add	x8, x22, x8
	fmov	d1, x8
	fsub	d0, d1, d0
	b	.LBB667_12
.LBB667_9:                              // %B25
	tst	x21, #0xfffe000000000000
	b.eq	.LBB667_15
// %bb.10:                              // %B28
	scvtf	d0, w22
	add	x8, x21, x8
.LBB667_11:                             // %B28
	fmov	d1, x8
	fsub	d0, d0, d1
.LBB667_12:                             // %B28
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
.LBB667_13:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB667_15
// %bb.14:                              // %B12
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB667_11
.LBB667_15:                             // %B36
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #158                        // =0x9e
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB667_17
// %bb.16:                              // %B38
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB667_17:                             // %B37
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
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #159                        // =0x9f
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_arith_slow_gc
	cmp	x0, #130
	b.eq	.LBB668_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB668_2:                              // %B2
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
// %bb.0:                               // %B28
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB669_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB669_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB669_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB669_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	lsl	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB669_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB669_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB669_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB669_9
// %bb.8:                               // %B15
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
.LBB669_9:                              // %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #160                        // =0xa0
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB669_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB669_11:                             // %B26
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
// %bb.0:                               // %B28
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB670_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB670_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB670_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB670_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	asr	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB670_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB670_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB670_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB670_9
// %bb.8:                               // %B15
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
.LBB670_9:                              // %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #161                        // =0xa1
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB670_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB670_11:                             // %B26
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
// %bb.0:                               // %B36
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB671_11
// %bb.1:                               // %B36
	cmp	x21, x8
	b.hi	.LBB671_11
// %bb.2:                               // %B10
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB671_6
// %bb.3:                               // %B27
	cmp	x21, x8
	b.lo	.LBB671_11
// %bb.4:                               // %B32
	mov	w8, w22
	lsr	w8, w8, w21
	tbnz	w8, #31, .LBB671_10
.LBB671_5:                              // %B2
	orr	x8, x8, #0xfffe000000000000
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x8
	ldr	x0, [x25, x10, lsl #3]
	br	x0
.LBB671_6:                              // %B12
	tst	x22, #0xfffe000000000000
	b.eq	.LBB671_11
// %bb.7:                               // %B12
	cmp	x21, x8
	b.lo	.LBB671_11
// %bb.8:                               // %B22
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB671_11
// %bb.9:                               // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	add	x8, x22, x8
	fmov	d0, x8
	fcvtzs	w8, d0
	lsr	w8, w8, w21
	tbz	w8, #31, .LBB671_5
.LBB671_10:                             // %B6
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
.LBB671_11:                             // %B33
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_shr_slow_gc
	cmp	x0, #130
	b.eq	.LBB671_13
// %bb.12:                              // %B35
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB671_13:                             // %B34
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
// %bb.0:                               // %B24
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB672_13
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB672_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB672_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB672_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, lt
	br	x0
.LBB672_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB672_13
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB672_11
// %bb.7:                               // %B13
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
.LBB672_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB672_13
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
.LBB672_10:                             // %B19
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, mi
	br	x0
.LBB672_11:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB672_13
// %bb.12:                              // %B11
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB672_10
.LBB672_13:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #163                        // =0xa3
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB672_15
// %bb.14:                              // %B23
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB672_15:                             // %B22
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
// %bb.0:                               // %B24
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB673_13
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB673_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB673_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB673_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, le
	br	x0
.LBB673_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB673_13
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB673_11
// %bb.7:                               // %B13
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
.LBB673_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB673_13
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
.LBB673_10:                             // %B19
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ls
	br	x0
.LBB673_11:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB673_13
// %bb.12:                              // %B11
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB673_10
.LBB673_13:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #164                        // =0xa4
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB673_15
// %bb.14:                              // %B23
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB673_15:                             // %B22
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
// %bb.0:                               // %B24
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB674_13
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB674_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB674_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB674_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x0
.LBB674_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB674_13
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB674_11
// %bb.7:                               // %B13
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
.LBB674_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB674_13
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
.LBB674_10:                             // %B19
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, gt
	br	x0
.LBB674_11:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB674_13
// %bb.12:                              // %B11
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB674_10
.LBB674_13:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #165                        // =0xa5
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB674_15
// %bb.14:                              // %B23
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB674_15:                             // %B22
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
// %bb.0:                               // %B24
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB675_13
// %bb.1:                               // %B24
	cmp	x21, x8
	b.hi	.LBB675_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB675_5
// %bb.3:                               // %B15
	cmp	x21, x8
	b.lo	.LBB675_8
// %bb.4:                               // %B20
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x0
.LBB675_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB675_13
// %bb.6:                               // %B7
	cmp	x21, x8
	b.lo	.LBB675_11
// %bb.7:                               // %B13
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
.LBB675_8:                              // %B17
	tst	x21, #0xfffe000000000000
	b.eq	.LBB675_13
// %bb.9:                               // %B19
	scvtf	d0, w22
	add	x8, x21, x8
.LBB675_10:                             // %B19
	fmov	d1, x8
	ldrb	w8, [x19], #1
	fcmp	d0, d1
	sub	x25, x25, #1936
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ge
	br	x0
.LBB675_11:                             // %B9
	tst	x21, #0xfffe000000000000
	b.eq	.LBB675_13
// %bb.12:                              // %B11
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB675_10
.LBB675_13:                             // %B21
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #166                        // =0xa6
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_relation_slow_gc
	cmp	x0, #130
	b.eq	.LBB675_15
// %bb.14:                              // %B23
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB675_15:                             // %B22
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
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_operator_instanceof_gc
	cmp	x0, #130
	b.eq	.LBB676_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB676_2:                              // %B2
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
// %bb.0:                               // %B1
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_operator_in_gc
	cmp	x0, #130
	b.eq	.LBB677_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB677_2:                              // %B2
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
// %bb.0:                               // %B44
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB678_13
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB678_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB678_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB678_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x0
.LBB678_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB678_13
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB678_11
// %bb.7:                               // %B33
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
.LBB678_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB678_13
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB678_10:                             // %B39
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
.LBB678_11:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB678_13
// %bb.12:                              // %B32
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB678_10
.LBB678_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB678_15
.LBB678_14:                             // %B8
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB678_15:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB678_17
// %bb.16:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB678_14
	b	.LBB678_20
.LBB678_17:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB678_20
// %bb.18:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB678_21
// %bb.19:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB678_21
.LBB678_20:                             // %B15
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB678_21:                             // %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB678_23
// %bb.22:                              // %B43
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB678_23:                             // %B42
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
// %bb.0:                               // %B44
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB679_13
// %bb.1:                               // %B44
	cmp	x21, x8
	b.hi	.LBB679_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB679_5
// %bb.3:                               // %B35
	cmp	x21, x8
	b.lo	.LBB679_8
// %bb.4:                               // %B40
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x0
.LBB679_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB679_13
// %bb.6:                               // %B28
	cmp	x21, x8
	b.lo	.LBB679_11
// %bb.7:                               // %B33
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
.LBB679_8:                              // %B37
	tst	x21, #0xfffe000000000000
	b.eq	.LBB679_13
// %bb.9:                               // %B39
	scvtf	d0, w22
	add	x8, x21, x8
.LBB679_10:                             // %B39
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
.LBB679_11:                             // %B30
	tst	x21, #0xfffe000000000000
	b.eq	.LBB679_13
// %bb.12:                              // %B32
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB679_10
.LBB679_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB679_15
.LBB679_14:                             // %B8
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB679_15:                             // %B10
	orr	x8, x21, #0x10
	cmp	x8, #18
	b.ne	.LBB679_17
// %bb.16:                              // %B12
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB679_14
	b	.LBB679_20
.LBB679_17:                             // %B17
	orr	x8, x22, #0x10
	cmp	x8, #18
	b.eq	.LBB679_20
// %bb.18:                              // %B20
	sub	x8, x21, #6
	cmp	x8, #1
	b.hi	.LBB679_21
// %bb.19:                              // %B20
	sub	x8, x22, #6
	cmp	x8, #2
	b.hs	.LBB679_21
.LBB679_20:                             // %B15
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB679_21:                             // %B41
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB679_23
// %bb.22:                              // %B43
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB679_23:                             // %B42
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
// %bb.0:                               // %B30
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB680_13
// %bb.1:                               // %B30
	cmp	x21, x8
	b.hi	.LBB680_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB680_5
// %bb.3:                               // %B21
	cmp	x21, x8
	b.lo	.LBB680_8
// %bb.4:                               // %B26
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, eq
	br	x0
.LBB680_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB680_13
// %bb.6:                               // %B14
	cmp	x21, x8
	b.lo	.LBB680_11
// %bb.7:                               // %B19
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
.LBB680_8:                              // %B23
	tst	x21, #0xfffe000000000000
	b.eq	.LBB680_13
// %bb.9:                               // %B25
	scvtf	d0, w22
	add	x8, x21, x8
.LBB680_10:                             // %B25
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
.LBB680_11:                             // %B16
	tst	x21, #0xfffe000000000000
	b.eq	.LBB680_13
// %bb.12:                              // %B18
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB680_10
.LBB680_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB680_15
// %bb.14:                              // %B8
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB680_15:                             // %B10
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
	b.ne	.LBB680_17
// %bb.16:                              // %B10
	tbnz	w8, #0, .LBB680_18
.LBB680_17:                             // %B12
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB680_18:                             // %B27
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, wzr
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB680_20
// %bb.19:                              // %B29
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB680_20:                             // %B28
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
// %bb.0:                               // %B30
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB681_13
// %bb.1:                               // %B30
	cmp	x21, x8
	b.hi	.LBB681_13
// %bb.2:                               // %B1
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB681_5
// %bb.3:                               // %B21
	cmp	x21, x8
	b.lo	.LBB681_8
// %bb.4:                               // %B26
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	cmp	w22, w21
	ldr	x0, [x25, x8, lsl #3]
	mov	w8, #6                          // =0x6
	cinc	x22, x8, ne
	br	x0
.LBB681_5:                              // %B3
	tst	x22, #0xfffe000000000000
	b.eq	.LBB681_13
// %bb.6:                               // %B14
	cmp	x21, x8
	b.lo	.LBB681_11
// %bb.7:                               // %B19
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
.LBB681_8:                              // %B23
	tst	x21, #0xfffe000000000000
	b.eq	.LBB681_13
// %bb.9:                               // %B25
	scvtf	d0, w22
	add	x8, x21, x8
.LBB681_10:                             // %B25
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
.LBB681_11:                             // %B16
	tst	x21, #0xfffe000000000000
	b.eq	.LBB681_13
// %bb.12:                              // %B18
	add	x10, x22, x8
	add	x8, x21, x8
	fmov	d0, x10
	b	.LBB681_10
.LBB681_13:                             // %B7
	cmp	x22, x21
	b.ne	.LBB681_15
// %bb.14:                              // %B8
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	w22, #6                         // =0x6
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB681_15:                             // %B10
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
	b.ne	.LBB681_17
// %bb.16:                              // %B10
	tbnz	w8, #0, .LBB681_18
.LBB681_17:                             // %B12
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	w22, #7                         // =0x7
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB681_18:                             // %B27
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #1                          // =0x1
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_strict_eq_slow_gc
	cmp	x0, #130
	b.eq	.LBB681_20
// %bb.19:                              // %B29
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB681_20:                             // %B28
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
// %bb.0:                               // %B28
	mov	x8, #-281474976710657           // =0xfffeffffffffffff
	cmp	x22, x8
	b.hi	.LBB682_9
// %bb.1:                               // %B28
	cmp	x21, x8
	b.hi	.LBB682_9
// %bb.2:                               // %B2
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x22, x8
	b.lo	.LBB682_5
// %bb.3:                               // %B19
	cmp	x21, x8
	b.lo	.LBB682_9
// %bb.4:                               // %B24
	mov	w8, w22
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	and	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB682_5:                              // %B4
	tst	x22, #0xfffe000000000000
	b.eq	.LBB682_9
// %bb.6:                               // %B4
	cmp	x21, x8
	b.lo	.LBB682_9
// %bb.7:                               // %B14
	ubfx	x8, x22, #52, #11
	cmp	x8, #1053
	b.gt	.LBB682_9
// %bb.8:                               // %B15
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
.LBB682_9:                              // %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #173                        // =0xad
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB682_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB682_11:                             // %B26
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
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	eor	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
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
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	eor	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB683_9:                              // %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #174                        // =0xae
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB683_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB683_11:                             // %B26
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
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	orr	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
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
	ldrb	w10, [x19], #1
	sub	x25, x25, #1936
	orr	w8, w8, w21
	ldr	x0, [x25, x10, lsl #3]
	orr	x22, x8, #0xfffe000000000000
	br	x0
.LBB684_9:                              // %B25
	add	x8, x20, #16
	mov	x0, x24
	mov	x1, x22
	mov	x2, x21
	mov	w3, #175                        // =0xaf
	stp	x22, x21, [x20]
	str	x8, [x29, #64]
	bl	prim_js_binary_logic_slow_gc
	cmp	x0, #130
	b.eq	.LBB684_11
// %bb.10:                              // %B27
	ldrb	w8, [x19], #1
	sub	x25, x25, #1936
	mov	x22, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB684_11:                             // %B26
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x8, #-562949953421312           // =0xfffe000000000000
	ldrsb	x10, [x19]
	ldrb	w11, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	bfxil	x8, x10, #0, #32
	ldr	x0, [x25, x11, lsl #3]
	mov	x21, x8
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
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x8, #-562949953421312           // =0xfffe000000000000
	ldrsh	x10, [x19]
	ldrb	w11, [x19, #2]
	add	x19, x19, #3
	mov	x22, x21
	bfxil	x8, x10, #0, #32
	ldr	x0, [x25, x11, lsl #3]
	mov	x21, x8
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
// %bb.0:                               // %B0
	str	x22, [x20], #8
	mov	x22, x21
	ldrb	w8, [x19]
	ldrb	w10, [x19, #1]
	add	x19, x19, #2
	ldr	x8, [x23, x8, lsl #3]
	ldr	x0, [x25, x10, lsl #3]
	mov	x21, x8
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
// %bb.0:                               // %B1
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
	b.eq	.LBB698_2
// %bb.1:                               // %B4
	ldrb	w8, [x19, #1]
	add	x19, x19, #2
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB698_2:                              // %B2
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
// %bb.0:                               // %B1
	str	x22, [x20]
	mov	x0, x24
	mov	w1, #47                         // =0x2f
	str	x21, [x20, #8]!
	add	x8, x20, #8
	mov	w2, #1                          // =0x1
	str	x8, [x29, #64]
	bl	__JS_AtomToValue_GC
	cmp	x0, #130
	b.eq	.LBB699_2
// %bb.1:                               // %B4
	ldrb	w8, [x19], #1
	mov	x22, x21
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB699_2:                              // %B2
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B1
	mov	w9, #48                         // =0x30
	bl	common_get_property_asm_h
	cmp	x0, #130
	b.eq	.LBB739_2
.LBB739_1:                              // %B7
	ldrb	w8, [x19], #1
	mov	x21, x0
	ldr	x1, [x25, x8, lsl #3]
	br	x1
.LBB739_2:                              // %B3
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
	b.ne	.LBB739_1
// %bb.3:                               // %B4
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
// %bb.0:                               // %B23
	cmp	x21, #5
	b.le	.LBB740_4
// %bb.1:                               // %B23
	cmp	x21, #6
	b.eq	.LBB740_6
// %bb.2:                               // %B23
	cmp	x21, #7
	b.eq	.LBB740_9
// %bb.3:                               // %B23
	cmp	x21, #18
	b.eq	.LBB740_6
	b	.LBB740_7
.LBB740_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB740_6
// %bb.5:                               // %B23
	cmp	x21, #2
	b.ne	.LBB740_7
.LBB740_6:                              // %B3
	ldrsb	x8, [x19]
	sub	x25, x25, #1936
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB740_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x21, x8
	b.hs	.LBB740_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB740_10
.LBB740_9:                              // %B19
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB740_10:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB740_13
// %bb.11:                              // %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB740_6
	b.vs	.LBB740_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB740_9
	b	.LBB740_6
.LBB740_13:                             // %B15
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
// %bb.0:                               // %B23
	cmp	x21, #5
	b.le	.LBB741_4
// %bb.1:                               // %B23
	cmp	x21, #6
	b.eq	.LBB741_6
// %bb.2:                               // %B23
	cmp	x21, #7
	b.eq	.LBB741_9
// %bb.3:                               // %B23
	cmp	x21, #18
	b.eq	.LBB741_6
	b	.LBB741_7
.LBB741_4:                              // %B23
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.eq	.LBB741_6
// %bb.5:                               // %B23
	cmp	x21, #2
	b.ne	.LBB741_7
.LBB741_6:                              // %B3
	ldrb	w8, [x19, #1]
	sub	x25, x25, #1936
	add	x19, x19, #2
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB741_7:                              // %B9
	mov	x8, #-281474976710656           // =0xffff000000000000
	cmp	x21, x8
	b.hs	.LBB741_13
// %bb.8:                               // %B11
	mov	x8, #-562949953421312           // =0xfffe000000000000
	cmp	x21, x8
	b.lo	.LBB741_10
.LBB741_9:                              // %B19
	ldrsb	x8, [x19]
	sub	x25, x25, #1936
	add	x19, x19, x8
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB741_10:                             // %B13
	tst	x21, #0xfffe000000000000
	b.eq	.LBB741_13
// %bb.11:                              // %B17
	add	x8, x21, x8
	fmov	d0, x8
	fcmp	d0, d0
	cset	w8, vc
	fcmp	d0, #0.0
	b.eq	.LBB741_6
	b.vs	.LBB741_6
// %bb.12:                              // %B17
	tbnz	w8, #0, .LBB741_9
	b	.LBB741_6
.LBB741_13:                             // %B15
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B0
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
// %bb.0:                               // %B2
	cmp	x21, #18
	b.ne	.LBB748_2
// %bb.1:                               // %B3
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB748_2:                              // %B5
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
// %bb.0:                               // %B2
	cmp	x21, #2
	b.ne	.LBB749_2
// %bb.1:                               // %B3
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB749_2:                              // %B5
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
// %bb.0:                               // %B1
	mov	x0, x24
	mov	x1, x21
	bl	js_operator_typeof_gc
	cmp	w0, #27
	b.ne	.LBB750_2
// %bb.1:                               // %B2
	mov	w21, #7                         // =0x7
	ldrb	w8, [x19], #1
	ldr	x0, [x25, x8, lsl #3]
	br	x0
.LBB750_2:                              // %B5
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
