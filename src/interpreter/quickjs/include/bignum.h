/*
 * QuickJS Javascript Engine
 *
 * Copyright (c) 2017-2019 Fabrice Bellard
 * Copyright (c) 2017-2019 Charlie Gordon
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_INTERPRETER_QUICKJS_INCLUDE_BIGNUM_H_
#define SRC_INTERPRETER_QUICKJS_INCLUDE_BIGNUM_H_

#include "quickjs/include/quickjs-inner.h"

#if defined(__SIZEOF_INT128__) && (INTPTR_MAX >= INT64_MAX) && !defined(WIN32)
#define JS_LIMB_BITS 64
#else
#define JS_LIMB_BITS 32
#endif

#define JS_SHORT_BIG_INT_BITS JS_LIMB_BITS

#if JS_LIMB_BITS == 32

typedef int32_t js_slimb_t;
typedef uint32_t js_limb_t;
typedef int64_t js_sdlimb_t;
typedef uint64_t js_dlimb_t;

#define JS_LIMB_DIGITS 9

#else
typedef __int128 int128_t;
typedef unsigned __int128 uint128_t;
typedef int64_t js_slimb_t;
typedef uint64_t js_limb_t;
typedef int128_t js_sdlimb_t;
typedef uint128_t js_dlimb_t;

#define JS_LIMB_DIGITS 19

#endif

typedef struct JSBigInt {
  LEPUSRefCountHeader header; /* must come first, 32-bit */
  uint32_t len;               /* number of limbs, >= 1 */
  js_limb_t tab[];            /* two's complement representation, always
                                 normalized so that 'len' is the minimum
                                 possible length >= 1 */
} JSBigInt;

/* this bigint structure can hold a 64 bit integer */
typedef struct {
  js_limb_t
      big_int_buf[sizeof(JSBigInt) / sizeof(js_limb_t)]; /* for JSBigInt */
  /* must come just after */
  js_limb_t tab[(64 + JS_LIMB_BITS - 1) / JS_LIMB_BITS];
} JSBigIntBuf;

inline int to_digit(int c) {
  if (c >= '0' && c <= '9')
    return c - '0';
  else if (c >= 'A' && c <= 'Z')
    return c - 'A' + 10;
  else if (c >= 'a' && c <= 'z')
    return c - 'a' + 10;
  else
    return 36;
}

/* bigint support */

#define JS_BIGINT_MAX_SIZE ((1024 * 1024) / JS_LIMB_BITS) /* in limbs */

#define ADDC(res, carry_out, op1, op2, carry_in) \
  do {                                           \
    js_limb_t __v, __a, __k, __k1;               \
    __v = (op1);                                 \
    __a = __v + (op2);                           \
    __k1 = __a < __v;                            \
    __k = (carry_in);                            \
    __a = __a + __k;                             \
    carry_out = (__a < __k) | __k1;              \
    res = __a;                                   \
  } while (0)

#if JS_LIMB_BITS == 32
/* a != 0 */
inline js_limb_t js_limb_clz(js_limb_t a) { return clz32(a); }
#else
inline js_limb_t js_limb_clz(js_limb_t a) { return clz64(a); }
#endif

/* handle a = 0 too */
inline js_limb_t js_limb_safe_clz(js_limb_t a) {
  if (a == 0)
    return JS_LIMB_BITS;
  else
    return js_limb_clz(a);
}

js_limb_t mp_add(js_limb_t *res, const js_limb_t *op1, const js_limb_t *op2,
                 js_limb_t n, js_limb_t carry);

js_limb_t mp_sub(js_limb_t *res, const js_limb_t *op1, const js_limb_t *op2,
                 int n, js_limb_t carry);

/* compute 0 - op2. carry = 0 or 1. */
js_limb_t mp_neg(js_limb_t *res, const js_limb_t *op2, int n);

/* tabr[] = taba[] * b + l. Return the high carry */
js_limb_t mp_mul1(js_limb_t *tabr, const js_limb_t *taba, js_limb_t n,
                  js_limb_t b, js_limb_t l);

js_limb_t mp_div1(js_limb_t *tabr, const js_limb_t *taba, js_limb_t n,
                  js_limb_t b, js_limb_t r);
/* tabr[] += taba[] * b, return the high word. */
js_limb_t mp_add_mul1(js_limb_t *tabr, const js_limb_t *taba, js_limb_t n,
                      js_limb_t b);

/* size of the result : op1_size + op2_size. */
void mp_mul_basecase(js_limb_t *result, const js_limb_t *op1,
                     js_limb_t op1_size, const js_limb_t *op2,
                     js_limb_t op2_size);

/* tabr[] -= taba[] * b. Return the value to substract to the high
   word. */
js_limb_t mp_sub_mul1(js_limb_t *tabr, const js_limb_t *taba, js_limb_t n,
                      js_limb_t b);

/* WARNING: d must be >= 2^(JS_LIMB_BITS-1) */
js_limb_t udiv1norm_init(js_limb_t d);

/* return the quotient and the remainder in '*pr'of 'a1*2^JS_LIMB_BITS+a0
   / d' with 0 <= a1 < d. */
js_limb_t udiv1norm(js_limb_t *pr, js_limb_t a1, js_limb_t a0, js_limb_t d,
                    js_limb_t d_inv);
#define UDIV1NORM_THRESHOLD 3

/* b must be >= 1 << (JS_LIMB_BITS - 1) */
js_limb_t mp_div1norm(js_limb_t *tabr, const js_limb_t *taba, js_limb_t n,
                      js_limb_t b, js_limb_t r);

/* base case division: divides taba[0..na-1] by tabb[0..nb-1]. tabb[nb
   - 1] must be >= 1 << (JS_LIMB_BITS - 1). na - nb must be >= 0. 'taba'
   is modified and contains the remainder (nb limbs). tabq[0..na-nb]
   contains the quotient with tabq[na - nb] <= 1. */
void mp_divnorm(js_limb_t *tabq, js_limb_t *taba, js_limb_t na,
                const js_limb_t *tabb, js_limb_t nb);

/* 1 <= shift <= JS_LIMB_BITS - 1 */
js_limb_t mp_shl(js_limb_t *tabr, const js_limb_t *taba, int n, int shift);

/* r = (a + high*B^n) >> shift. Return the remainder r (0 <= r < 2^shift).
   1 <= shift <= LIMB_BITS - 1 */
js_limb_t mp_shr(js_limb_t *tab_r, const js_limb_t *tab, int n, int shift,
                 js_limb_t high);

JSBigInt *js_bigint_new(LEPUSContext *ctx, int len);

JSBigInt *js_bigint_set_si(JSBigIntBuf *buf, js_slimb_t a);

JSBigInt *js_bigint_set_si64(JSBigIntBuf *buf, int64_t a);
/* val must be a short big int */

__maybe_unused void js_bigint_dump1(LEPUSContext *ctx, const char *str,
                                    const js_limb_t *tab, int len);

__maybe_unused void js_bigint_dump(LEPUSContext *ctx, const char *str,
                                   const JSBigInt *p);

JSBigInt *js_bigint_new_si(LEPUSContext *ctx, js_slimb_t a);

JSBigInt *js_bigint_new_si64(LEPUSContext *ctx, int64_t a);
JSBigInt *js_bigint_new_ui64(LEPUSContext *ctx, uint64_t a);

JSBigInt *js_bigint_new_di(LEPUSContext *ctx, js_sdlimb_t a);

/* Remove redundant high order limbs. Warning: 'a' may be
   reallocated. Can never fail.
*/
JSBigInt *js_bigint_normalize1(LEPUSContext *ctx, JSBigInt *a, int l);
JSBigInt *js_bigint_normalize(LEPUSContext *ctx, JSBigInt *a);

/* return 0 or 1 depending on the sign */
int js_bigint_sign(const JSBigInt *a);

js_slimb_t js_bigint_get_si_sat(const JSBigInt *a);

/* add the op1 limb */
JSBigInt *js_bigint_extend(LEPUSContext *ctx, JSBigInt *r, js_limb_t op1);

/* return NULL in case of error. Compute a + b (b_neg = 0) or a - b
   (b_neg = 1) */
/* XXX: optimize */
JSBigInt *js_bigint_add(LEPUSContext *ctx, const JSBigInt *a, const JSBigInt *b,
                        int b_neg);

/* XXX: optimize */
JSBigInt *js_bigint_neg(LEPUSContext *ctx, const JSBigInt *a);

JSBigInt *js_bigint_mul(LEPUSContext *ctx, const JSBigInt *a,
                        const JSBigInt *b);

/* return the division or the remainder. 'b' must be != 0. return NULL
   in case of exception (division by zero or memory error) */
JSBigInt *js_bigint_divrem(LEPUSContext *ctx, const JSBigInt *a,
                           const JSBigInt *b, BOOL is_rem);
JSBigInt *js_bigint_logic(LEPUSContext *ctx, const JSBigInt *a,
                          const JSBigInt *b, OPCodeEnum op);
JSBigInt *js_bigint_not(LEPUSContext *ctx, const JSBigInt *a);

JSBigInt *js_bigint_shl(LEPUSContext *ctx, const JSBigInt *a,
                        unsigned int shift1);

JSBigInt *js_bigint_shr(LEPUSContext *ctx, const JSBigInt *a,
                        unsigned int shift1);

JSBigInt *js_bigint_pow(LEPUSContext *ctx, const JSBigInt *a, JSBigInt *b);

/* return (mant, exp) so that abs(a) ~ mant*2^(exp - (limb_bits -
   1). a must be != 0. */
uint64_t js_bigint_get_mant_exp(LEPUSContext *ctx, int *pexp,
                                const JSBigInt *a);

/* shift left with round to nearest, ties to even. n >= 1 */
uint64_t shr_rndn(uint64_t a, int n);

/* convert to float64 with round to nearest, ties to even. Return
   +/-infinity if too large. */
double js_bigint_to_float64(LEPUSContext *ctx, const JSBigInt *a);

/* return (1, NULL) if not an integer, (2, NULL) if NaN or Infinity,
   (0, n) if an integer, (0, NULL) in case of memory error */
JSBigInt *js_bigint_from_float64(LEPUSContext *ctx, int *pres, double a1);

/* return -1, 0, 1 or (2) (unordered) */
int js_bigint_float64_cmp(LEPUSContext *ctx, const JSBigInt *a, double b);
/* return -1, 0 or 1 */
int js_bigint_cmp(LEPUSContext *ctx, const JSBigInt *a, const JSBigInt *b);
/* contains 10^i */
inline const js_limb_t js_pow_dec[JS_LIMB_DIGITS + 1] = {
    1U,
    10U,
    100U,
    1000U,
    10000U,
    100000U,
    1000000U,
    10000000U,
    100000000U,
    1000000000U,
#if JS_LIMB_BITS == 64
    10000000000U,
    100000000000U,
    1000000000000U,
    10000000000000U,
    100000000000000U,
    1000000000000000U,
    10000000000000000U,
    100000000000000000U,
    1000000000000000000U,
    10000000000000000000U,
#endif
};

/* syntax: [-]digits in base radix. Return NULL if memory error. radix
   = 10, 2, 8 or 16. */
JSBigInt *js_bigint_from_string(LEPUSContext *ctx, const char *str, int radix);

/* 2 <= base <= 36 */
inline char const digits[36] = {'0', '1', '2', '3', '4', '5', '6', '7', '8',
                                '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
                                'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q',
                                'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
/* special version going backwards */
/* XXX: use dtoa.c */
char *js_u64toa(char *q, int64_t n, unsigned int base);

/* len >= 1. 2 <= radix <= 36 */
char *limb_to_a(char *q, js_limb_t n, unsigned int radix, int len);

#define JS_RADIX_MAX 36

inline const uint8_t digits_per_limb_table[JS_RADIX_MAX - 1] = {
#if JS_LIMB_BITS == 32
    32, 20, 16, 13, 12, 11, 10, 10, 9, 9, 8, 8, 8, 8, 8, 7, 7, 7,
    7,  7,  7,  7,  6,  6,  6,  6,  6, 6, 6, 6, 6, 6, 6, 6, 6,
#else
    64, 40, 32, 27, 24, 22, 21, 20, 19, 18, 17, 17, 16, 16, 16, 15, 15, 15,
    14, 14, 14, 14, 13, 13, 13, 13, 13, 13, 13, 12, 12, 12, 12, 12, 12,
#endif
};

inline const js_limb_t radix_base_table[JS_RADIX_MAX - 1] = {
#if JS_LIMB_BITS == 32
    0x00000000, 0xcfd41b91, 0x00000000, 0x48c27395, 0x81bf1000, 0x75db9c97,
    0x40000000, 0xcfd41b91, 0x3b9aca00, 0x8c8b6d2b, 0x19a10000, 0x309f1021,
    0x57f6c100, 0x98c29b81, 0x00000000, 0x18754571, 0x247dbc80, 0x3547667b,
    0x4c4b4000, 0x6b5a6e1d, 0x94ace180, 0xcaf18367, 0x0b640000, 0x0e8d4a51,
    0x1269ae40, 0x17179149, 0x1cb91000, 0x23744899, 0x2b73a840, 0x34e63b41,
    0x40000000, 0x4cfa3cc1, 0x5c13d840, 0x6d91b519, 0x81bf1000,
#else
    0x0000000000000000, 0xa8b8b452291fe821, 0x0000000000000000,
    0x6765c793fa10079d, 0x41c21cb8e1000000, 0x3642798750226111,
    0x8000000000000000, 0xa8b8b452291fe821, 0x8ac7230489e80000,
    0x4d28cb56c33fa539, 0x1eca170c00000000, 0x780c7372621bd74d,
    0x1e39a5057d810000, 0x5b27ac993df97701, 0x0000000000000000,
    0x27b95e997e21d9f1, 0x5da0e1e53c5c8000, 0xd2ae3299c1c4aedb,
    0x16bcc41e90000000, 0x2d04b7fdd9c0ef49, 0x5658597bcaa24000,
    0xa0e2073737609371, 0x0c29e98000000000, 0x14adf4b7320334b9,
    0x226ed36478bfa000, 0x383d9170b85ff80b, 0x5a3c23e39c000000,
    0x8e65137388122bcd, 0xdd41bb36d259e000, 0x0aee5720ee830681,
    0x1000000000000000, 0x172588ad4f5f0981, 0x211e44f7d02c1000,
    0x2ee56725f06e5c71, 0x41c21cb8e1000000,
#endif
};

#define ATOD_INT_ONLY (1 << 0)
#define ATOD_INT_ONLY (1 << 0)
/* accept Oo and Ob prefixes in addition to 0x prefix if radix = 0 */
#define ATOD_ACCEPT_BIN_OCT (1 << 2)
/* accept O prefix as octal if radix == 0 and properly formed (Annex B) */
#define ATOD_ACCEPT_LEGACY_OCTAL (1 << 4)
/* accept _ between digits as a digit separator */
#define ATOD_ACCEPT_UNDERSCORES (1 << 5)
/* allow a suffix to override the type */
#define ATOD_ACCEPT_SUFFIX (1 << 6)
/* default type */
#define ATOD_TYPE_MASK (3 << 7)
#define ATOD_TYPE_FLOAT64 (0 << 7)
#define ATOD_TYPE_BIG_INT (1 << 7)
/* accept -0x1 */
#define ATOD_ACCEPT_PREFIX_AFTER_SIGN (1 << 10)

inline int is_digit(int c) { return c >= '0' && c <= '9'; }

/* if possible transform a BigInt to short big and free it, otherwise
   return a normal bigint */
inline LEPUSValue JS_CompactBigInt(LEPUSContext *ctx, JSBigInt *p) {
  return LEPUS_MKPTR(LEPUS_TAG_BIG_INT, p);
}

LEPUSValue js_bigint_to_string1(LEPUSContext *ctx, LEPUSValueConst val,
                                int32_t radix);

inline LEPUSValue js_bigint_to_string(LEPUSContext *ctx, LEPUSValueConst val) {
  return js_bigint_to_string1(ctx, val, 10);
}

LEPUSValue js_atof(LEPUSContext *ctx, const char *str, const char **pp,
                   int radix, int flags);

LEPUSValue js_dtoa2(LEPUSContext *ctx, double d, int32_t radix,
                    int32_t n_digits, int32_t flags);
int js_compare_bigint(LEPUSContext *ctx, OPCodeEnum op, LEPUSValue op1,
                      LEPUSValue op2);

#endif
