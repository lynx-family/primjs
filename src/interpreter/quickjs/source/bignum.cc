#include "quickjs/include/bignum.h"

#include <assert.h>

js_limb_t mp_add(js_limb_t *res, const js_limb_t *op1, const js_limb_t *op2,
                 js_limb_t n, js_limb_t carry) {
  int i;
  for (i = 0; i < n; i++) {
    ADDC(res[i], carry, op1[i], op2[i], carry);
  }
  return carry;
}

js_limb_t mp_sub(js_limb_t *res, const js_limb_t *op1, const js_limb_t *op2,
                 int n, js_limb_t carry) {
  int i;
  js_limb_t k, a, v, k1;

  k = carry;
  for (i = 0; i < n; i++) {
    v = op1[i];
    a = v - op2[i];
    k1 = a > v;
    v = a - k;
    k = (v > a) | k1;
    res[i] = v;
  }
  return k;
}

/* compute 0 - op2. carry = 0 or 1. */
js_limb_t mp_neg(js_limb_t *res, const js_limb_t *op2, int n) {
  int i;
  js_limb_t v, carry;

  carry = 1;
  for (i = 0; i < n; i++) {
    v = ~op2[i] + carry;
    carry = v < carry;
    res[i] = v;
  }
  return carry;
}

/* tabr[] = taba[] * b + l. Return the high carry */
js_limb_t mp_mul1(js_limb_t *tabr, const js_limb_t *taba, js_limb_t n,
                  js_limb_t b, js_limb_t l) {
  js_limb_t i;
  js_dlimb_t t;

  for (i = 0; i < n; i++) {
    t = (js_dlimb_t)taba[i] * (js_dlimb_t)b + l;
    tabr[i] = t;
    l = t >> JS_LIMB_BITS;
  }
  return l;
}

js_limb_t mp_div1(js_limb_t *tabr, const js_limb_t *taba, js_limb_t n,
                  js_limb_t b, js_limb_t r) {
  js_slimb_t i;
  js_dlimb_t a1;
  for (i = n - 1; i >= 0; i--) {
    a1 = ((js_dlimb_t)r << JS_LIMB_BITS) | taba[i];
    tabr[i] = a1 / b;
    r = a1 % b;
  }
  return r;
}

/* tabr[] += taba[] * b, return the high word. */
js_limb_t mp_add_mul1(js_limb_t *tabr, const js_limb_t *taba, js_limb_t n,
                      js_limb_t b) {
  js_limb_t i, l;
  js_dlimb_t t;

  l = 0;
  for (i = 0; i < n; i++) {
    t = (js_dlimb_t)taba[i] * (js_dlimb_t)b + l + tabr[i];
    tabr[i] = t;
    l = t >> JS_LIMB_BITS;
  }
  return l;
}

/* size of the result : op1_size + op2_size. */
inline void mp_mul_basecase(js_limb_t *result, const js_limb_t *op1,
                            js_limb_t op1_size, const js_limb_t *op2,
                            js_limb_t op2_size) {
  int i;
  js_limb_t r;

  result[op1_size] = mp_mul1(result, op1, op1_size, op2[0], 0);
  for (i = 1; i < op2_size; i++) {
    r = mp_add_mul1(result + i, op1, op1_size, op2[i]);
    result[i + op1_size] = r;
  }
}

/* tabr[] -= taba[] * b. Return the value to substract to the high
   word. */
inline js_limb_t mp_sub_mul1(js_limb_t *tabr, const js_limb_t *taba,
                             js_limb_t n, js_limb_t b) {
  js_limb_t i, l;
  js_dlimb_t t;

  l = 0;
  for (i = 0; i < n; i++) {
    t = tabr[i] - (js_dlimb_t)taba[i] * (js_dlimb_t)b - l;
    tabr[i] = t;
    l = -(t >> JS_LIMB_BITS);
  }
  return l;
}

/* WARNING: d must be >= 2^(JS_LIMB_BITS-1) */
js_limb_t udiv1norm_init(js_limb_t d) {
  js_limb_t a0, a1;
  a1 = -d - 1;
  a0 = -1;
  return (((js_dlimb_t)a1 << JS_LIMB_BITS) | a0) / d;
}

/* return the quotient and the remainder in '*pr'of 'a1*2^JS_LIMB_BITS+a0
   / d' with 0 <= a1 < d. */
js_limb_t udiv1norm(js_limb_t *pr, js_limb_t a1, js_limb_t a0, js_limb_t d,
                    js_limb_t d_inv) {
  js_limb_t n1m, n_adj, q, r, ah;
  js_dlimb_t a;
  n1m = ((js_slimb_t)a0 >> (JS_LIMB_BITS - 1));
  n_adj = a0 + (n1m & d);
  a = (js_dlimb_t)d_inv * (a1 - n1m) + n_adj;
  q = (a >> JS_LIMB_BITS) + a1;
  /* compute a - q * r and update q so that the remainder is\
     between 0 and d - 1 */
  a = ((js_dlimb_t)a1 << JS_LIMB_BITS) | a0;
  a = a - (js_dlimb_t)q * d - d;
  ah = a >> JS_LIMB_BITS;
  q += 1 + ah;
  r = (js_limb_t)a + (ah & d);
  *pr = r;
  return q;
}

#define UDIV1NORM_THRESHOLD 3

/* b must be >= 1 << (JS_LIMB_BITS - 1) */
js_limb_t mp_div1norm(js_limb_t *tabr, const js_limb_t *taba, js_limb_t n,
                      js_limb_t b, js_limb_t r) {
  js_slimb_t i;

  if (n >= UDIV1NORM_THRESHOLD) {
    js_limb_t b_inv;
    b_inv = udiv1norm_init(b);
    for (i = n - 1; i >= 0; i--) {
      tabr[i] = udiv1norm(&r, r, taba[i], b, b_inv);
    }
  } else {
    js_dlimb_t a1;
    for (i = n - 1; i >= 0; i--) {
      a1 = ((js_dlimb_t)r << JS_LIMB_BITS) | taba[i];
      tabr[i] = a1 / b;
      r = a1 % b;
    }
  }
  return r;
}

/* base case division: divides taba[0..na-1] by tabb[0..nb-1]. tabb[nb
   - 1] must be >= 1 << (JS_LIMB_BITS - 1). na - nb must be >= 0. 'taba'
   is modified and contains the remainder (nb limbs). tabq[0..na-nb]
   contains the quotient with tabq[na - nb] <= 1. */
void mp_divnorm(js_limb_t *tabq, js_limb_t *taba, js_limb_t na,
                const js_limb_t *tabb, js_limb_t nb) {
  js_limb_t r, a, c, q, v, b1, b1_inv, n, dummy_r;
  int i, j;

  b1 = tabb[nb - 1];
  if (nb == 1) {
    taba[0] = mp_div1norm(tabq, taba, na, b1, 0);
    return;
  }
  n = na - nb;

  if (n >= UDIV1NORM_THRESHOLD)
    b1_inv = udiv1norm_init(b1);
  else
    b1_inv = 0;

  /* first iteration: the quotient is only 0 or 1 */
  q = 1;
  for (j = nb - 1; j >= 0; j--) {
    if (taba[n + j] != tabb[j]) {
      if (taba[n + j] < tabb[j]) q = 0;
      break;
    }
  }
  tabq[n] = q;
  if (q) {
    mp_sub(taba + n, taba + n, tabb, nb, 0);
  }

  for (i = n - 1; i >= 0; i--) {
    if (unlikely(taba[i + nb] >= b1)) {
      q = -1;
    } else if (b1_inv) {
      q = udiv1norm(&dummy_r, taba[i + nb], taba[i + nb - 1], b1, b1_inv);
    } else {
      js_dlimb_t al;
      al = ((js_dlimb_t)taba[i + nb] << JS_LIMB_BITS) | taba[i + nb - 1];
      q = al / b1;
      r = al % b1;
    }
    r = mp_sub_mul1(taba + i, tabb, nb, q);

    v = taba[i + nb];
    a = v - r;
    c = (a > v);
    taba[i + nb] = a;

    if (c != 0) {
      /* negative result */
      for (;;) {
        q--;
        c = mp_add(taba + i, taba + i, tabb, nb, 0);
        /* propagate carry and test if positive result */
        if (c != 0) {
          if (++taba[i + nb] == 0) {
            break;
          }
        }
      }
    }
    tabq[i] = q;
  }
}

/* 1 <= shift <= JS_LIMB_BITS - 1 */
js_limb_t mp_shl(js_limb_t *tabr, const js_limb_t *taba, int n, int shift) {
  int i;
  js_limb_t l, v;
  l = 0;
  for (i = 0; i < n; i++) {
    v = taba[i];
    tabr[i] = (v << shift) | l;
    l = v >> (JS_LIMB_BITS - shift);
  }
  return l;
}

/* r = (a + high*B^n) >> shift. Return the remainder r (0 <= r < 2^shift).
   1 <= shift <= LIMB_BITS - 1 */
js_limb_t mp_shr(js_limb_t *tab_r, const js_limb_t *tab, int n, int shift,
                 js_limb_t high) {
  int i;
  js_limb_t l, a;

  l = high;
  for (i = n - 1; i >= 0; i--) {
    a = tab[i];
    tab_r[i] = (a >> shift) | (l << (JS_LIMB_BITS - shift));
    l = a;
  }
  return l & (((js_limb_t)1 << shift) - 1);
}

JSBigInt *js_bigint_new(LEPUSContext *ctx, int len) {
  JSBigInt *r;
  if (len > JS_BIGINT_MAX_SIZE) {
    LEPUS_ThrowRangeError(ctx, "BigInt is too large to allocate");
    return NULL;
  }
  r = (JSBigInt *)lepus_malloc(ctx, sizeof(JSBigInt) + len * sizeof(js_limb_t),
                               ALLOC_TAG_JSBigInt);
  if (!r) return NULL;
  r->header.ref_count = 1;
  r->len = len;
  return r;
}

JSBigInt *js_bigint_set_si(JSBigIntBuf *buf, js_slimb_t a) {
  JSBigInt *r = (JSBigInt *)buf->big_int_buf;
  r->header.ref_count = 0; /* fail safe */
  r->len = 1;
  r->tab[0] = a;
  return r;
}

JSBigInt *js_bigint_set_si64(JSBigIntBuf *buf, int64_t a) {
#if JS_LIMB_BITS == 64
  return js_bigint_set_si(buf, a);
#else
  JSBigInt *r = (JSBigInt *)buf->big_int_buf;
  r->header.ref_count = 0; /* fail safe */
  if (a >= INT32_MIN && a <= INT32_MAX) {
    r->len = 1;
    r->tab[0] = a;
  } else {
    r->len = 2;
    r->tab[0] = a;
    r->tab[1] = a >> JS_LIMB_BITS;
  }
  return r;
#endif
}

/* val must be a short big int */

__maybe_unused void js_bigint_dump1(LEPUSContext *ctx, const char *str,
                                    const js_limb_t *tab, int len) {
  int i;
  printf("%s: ", str);
  for (i = len - 1; i >= 0; i--) {
#if JS_LIMB_BITS == 32
    printf(" %08x", tab[i]);
#else
    printf(" %016" PRIx64, tab[i]);
#endif
  }
  printf("\n");
}

__maybe_unused void js_bigint_dump(LEPUSContext *ctx, const char *str,
                                   const JSBigInt *p) {
  js_bigint_dump1(ctx, str, p->tab, p->len);
}

JSBigInt *js_bigint_new_si(LEPUSContext *ctx, js_slimb_t a) {
  JSBigInt *r;
  r = js_bigint_new(ctx, 1);
  if (!r) return NULL;
  r->tab[0] = a;
  return r;
}

JSBigInt *js_bigint_new_si64(LEPUSContext *ctx, int64_t a) {
#if JS_LIMB_BITS == 64
  return js_bigint_new_si(ctx, a);
#else
  if (a >= INT32_MIN && a <= INT32_MAX) {
    return js_bigint_new_si(ctx, a);
  } else {
    JSBigInt *r;
    r = js_bigint_new(ctx, 2);
    if (!r) return NULL;
    r->tab[0] = a;
    r->tab[1] = a >> 32;
    return r;
  }
#endif
}

JSBigInt *js_bigint_new_ui64(LEPUSContext *ctx, uint64_t a) {
  if (a <= INT64_MAX) {
    return js_bigint_new_si64(ctx, a);
  } else {
    JSBigInt *r;
    r = js_bigint_new(ctx, (65 + JS_LIMB_BITS - 1) / JS_LIMB_BITS);
    if (!r) return NULL;
#if JS_LIMB_BITS == 64
    r->tab[0] = a;
    r->tab[1] = 0;
#else
    r->tab[0] = a;
    r->tab[1] = a >> 32;
    r->tab[2] = 0;
#endif
    return r;
  }
}

JSBigInt *js_bigint_new_di(LEPUSContext *ctx, js_sdlimb_t a) {
  JSBigInt *r;
  if (a == (js_slimb_t)a) {
    r = js_bigint_new(ctx, 1);
    if (!r) return NULL;
    r->tab[0] = a;
  } else {
    r = js_bigint_new(ctx, 2);
    if (!r) return NULL;
    r->tab[0] = a;
    r->tab[1] = a >> JS_LIMB_BITS;
  }
  return r;
}

/* Remove redundant high order limbs. Warning: 'a' may be
   reallocated. Can never fail.
*/
JSBigInt *js_bigint_normalize1(LEPUSContext *ctx, JSBigInt *a, int l) {
  js_limb_t v;

  assert(a->header.ref_count == 1);
  while (l > 1) {
    v = a->tab[l - 1];
    if ((v != 0 && v != -1) ||
        (v & 1) != (a->tab[l - 2] >> (JS_LIMB_BITS - 1))) {
      break;
    }
    l--;
  }
  if (l != a->len) {
    JSBigInt *a1;
    /* realloc to reduce the size */
    a->len = l;
    a1 = (JSBigInt *)lepus_realloc(
        ctx, a, sizeof(JSBigInt) + l * sizeof(js_limb_t), ALLOC_TAG_JSBigInt);
    if (a1) a = a1;
  }
  return a;
}

JSBigInt *js_bigint_normalize(LEPUSContext *ctx, JSBigInt *a) {
  return js_bigint_normalize1(ctx, a, a->len);
}

/* return 0 or 1 depending on the sign */
int js_bigint_sign(const JSBigInt *a) {
  return a->tab[a->len - 1] >> (JS_LIMB_BITS - 1);
}

js_slimb_t js_bigint_get_si_sat(const JSBigInt *a) {
  if (a->len == 1) {
    return a->tab[0];
  } else {
#if JS_LIMB_BITS == 32
    if (js_bigint_sign(a))
      return INT32_MIN;
    else
      return INT32_MAX;
#else
    if (js_bigint_sign(a))
      return INT64_MIN;
    else
      return INT64_MAX;
#endif
  }
}

/* add the op1 limb */
JSBigInt *js_bigint_extend(LEPUSContext *ctx, JSBigInt *r, js_limb_t op1) {
  int n2 = r->len;
  if ((op1 != 0 && op1 != -1) ||
      (op1 & 1) != r->tab[n2 - 1] >> (JS_LIMB_BITS - 1)) {
    JSBigInt *r1;
    r1 = (JSBigInt *)lepus_realloc(
        ctx, r, sizeof(JSBigInt) + (n2 + 1) * sizeof(js_limb_t),
        ALLOC_TAG_JSBigInt);
    if (!r1) {
      if (!ctx->gc_enable) {
        lepus_free(ctx, r);
      }
      return NULL;
    }
    r = r1;
    r->len = n2 + 1;
    r->tab[n2] = op1;
  } else {
    /* otherwise still need to normalize the result */
    r = js_bigint_normalize(ctx, r);
  }
  return r;
}

/* return NULL in case of error. Compute a + b (b_neg = 0) or a - b
   (b_neg = 1) */
/* XXX: optimize */
JSBigInt *js_bigint_add(LEPUSContext *ctx, const JSBigInt *a, const JSBigInt *b,
                        int b_neg) {
  JSBigInt *r;
  int n1, n2, i;
  js_limb_t carry, op1, op2, a_sign, b_sign;

  n2 = max_int(a->len, b->len);
  n1 = min_int(a->len, b->len);
  r = js_bigint_new(ctx, n2);
  if (!r) return NULL;
  /* XXX: optimize */
  /* common part */
  carry = b_neg;
  for (i = 0; i < n1; i++) {
    op1 = a->tab[i];
    op2 = b->tab[i] ^ (-b_neg);
    ADDC(r->tab[i], carry, op1, op2, carry);
  }
  a_sign = -js_bigint_sign(a);
  b_sign = (-js_bigint_sign(b)) ^ (-b_neg);
  /* part with sign extension of one operand  */
  if (a->len > b->len) {
    for (i = n1; i < n2; i++) {
      op1 = a->tab[i];
      ADDC(r->tab[i], carry, op1, b_sign, carry);
    }
  } else if (a->len < b->len) {
    for (i = n1; i < n2; i++) {
      op2 = b->tab[i] ^ (-b_neg);
      ADDC(r->tab[i], carry, a_sign, op2, carry);
    }
  }

  /* part with sign extension for both operands. Extend the result
     if necessary */
  return js_bigint_extend(ctx, r, a_sign + b_sign + carry);
}

/* XXX: optimize */
JSBigInt *js_bigint_neg(LEPUSContext *ctx, const JSBigInt *a) {
  JSBigIntBuf buf;
  JSBigInt *b;
  b = js_bigint_set_si(&buf, 0);
  return js_bigint_add(ctx, b, a, 1);
}

JSBigInt *js_bigint_mul(LEPUSContext *ctx, const JSBigInt *a,
                        const JSBigInt *b) {
  JSBigInt *r;

  r = js_bigint_new(ctx, a->len + b->len);
  if (!r) return NULL;
  mp_mul_basecase(r->tab, a->tab, a->len, b->tab, b->len);
  /* correct the result if negative operands (no overflow is
     possible) */
  if (js_bigint_sign(a))
    mp_sub(r->tab + a->len, r->tab + a->len, b->tab, b->len, 0);
  if (js_bigint_sign(b))
    mp_sub(r->tab + b->len, r->tab + b->len, a->tab, a->len, 0);
  return js_bigint_normalize(ctx, r);
}

/* return the division or the remainder. 'b' must be != 0. return NULL
   in case of exception (division by zero or memory error) */
JSBigInt *js_bigint_divrem(LEPUSContext *ctx, const JSBigInt *a,
                           const JSBigInt *b, BOOL is_rem) {
  JSBigInt *r, *q;
  js_limb_t *tabb, h;
  int na, nb, a_sign, b_sign, shift;

  if (b->len == 1 && b->tab[0] == 0) {
    LEPUS_ThrowRangeError(ctx, "BigInt division by zero");
    return NULL;
  }

  a_sign = js_bigint_sign(a);
  b_sign = js_bigint_sign(b);
  na = a->len;
  nb = b->len;

  r = js_bigint_new(ctx, na + 2);
  if (!r) return NULL;
  if (a_sign) {
    mp_neg(r->tab, a->tab, na);
  } else {
    memcpy(r->tab, a->tab, na * sizeof(a->tab[0]));
  }
  /* normalize */
  while (na > 1 && r->tab[na - 1] == 0) na--;

  tabb = (js_limb_t *)lepus_malloc(ctx, nb * sizeof(tabb[0]), 0);
  if (!tabb) {
    if (!ctx->gc_enable) {
      lepus_free(ctx, r);
    }
    return NULL;
  }
  if (b_sign) {
    mp_neg(tabb, b->tab, nb);
  } else {
    memcpy(tabb, b->tab, nb * sizeof(tabb[0]));
  }
  /* normalize */
  while (nb > 1 && tabb[nb - 1] == 0) nb--;

  /* trivial case if 'a' is small */
  if (na < nb) {
    if (!ctx->gc_enable) {
      lepus_free(ctx, r);
      lepus_free(ctx, tabb);
    }
    if (is_rem) {
      /* r = a */
      r = js_bigint_new(ctx, a->len);
      if (!r) return NULL;
      memcpy(r->tab, a->tab, a->len * sizeof(a->tab[0]));
      return r;
    } else {
      /* q = 0 */
      return js_bigint_new_si(ctx, 0);
    }
  }

  /* normalize 'b' */
  shift = js_limb_clz(tabb[nb - 1]);
  if (shift != 0) {
    mp_shl(tabb, tabb, nb, shift);
    h = mp_shl(r->tab, r->tab, na, shift);
    if (h != 0) r->tab[na++] = h;
  }

  q = js_bigint_new(ctx, na - nb + 2); /* one more limb for the sign */
  if (!q) {
    if (!ctx->gc_enable) {
      lepus_free(ctx, r);
      lepus_free(ctx, tabb);
    }
    return NULL;
  }

  //    js_bigint_dump1(ctx, "a", r->tab, na);
  //    js_bigint_dump1(ctx, "b", tabb, nb);
  mp_divnorm(q->tab, r->tab, na, tabb, nb);
  if (!ctx->gc_enable) lepus_free(ctx, tabb);

  if (is_rem) {
    if (!ctx->gc_enable) lepus_free(ctx, q);
    if (shift != 0) mp_shr(r->tab, r->tab, nb, shift, 0);
    r->tab[nb++] = 0;
    if (a_sign) mp_neg(r->tab, r->tab, nb);
    r = js_bigint_normalize1(ctx, r, nb);
    return r;
  } else {
    if (!ctx->gc_enable) lepus_free(ctx, r);
    q->tab[na - nb + 1] = 0;
    if (a_sign ^ b_sign) {
      mp_neg(q->tab, q->tab, q->len);
    }
    q = js_bigint_normalize(ctx, q);
    return q;
  }
}

/* and, or, xor */
JSBigInt *js_bigint_logic(LEPUSContext *ctx, const JSBigInt *a,
                          const JSBigInt *b, OPCodeEnum op) {
  JSBigInt *r;
  js_limb_t b_sign;
  int a_len, b_len, i;

  if (a->len < b->len) {
    const JSBigInt *tmp;
    tmp = a;
    a = b;
    b = tmp;
  }
  /* a_len >= b_len */
  a_len = a->len;
  b_len = b->len;
  b_sign = -js_bigint_sign(b);

  r = js_bigint_new(ctx, a_len);
  if (!r) return NULL;
  switch (op) {
    case OP_or:
      for (i = 0; i < b_len; i++) {
        r->tab[i] = a->tab[i] | b->tab[i];
      }
      for (i = b_len; i < a_len; i++) {
        r->tab[i] = a->tab[i] | b_sign;
      }
      break;
    case OP_and:
      for (i = 0; i < b_len; i++) {
        r->tab[i] = a->tab[i] & b->tab[i];
      }
      for (i = b_len; i < a_len; i++) {
        r->tab[i] = a->tab[i] & b_sign;
      }
      break;
    case OP_xor:
      for (i = 0; i < b_len; i++) {
        r->tab[i] = a->tab[i] ^ b->tab[i];
      }
      for (i = b_len; i < a_len; i++) {
        r->tab[i] = a->tab[i] ^ b_sign;
      }
      break;
    default:
      abort();
  }
  return js_bigint_normalize(ctx, r);
}

JSBigInt *js_bigint_not(LEPUSContext *ctx, const JSBigInt *a) {
  JSBigInt *r;
  int i;

  r = js_bigint_new(ctx, a->len);
  if (!r) return NULL;
  for (i = 0; i < a->len; i++) {
    r->tab[i] = ~a->tab[i];
  }
  /* no normalization is needed */
  return r;
}

JSBigInt *js_bigint_shl(LEPUSContext *ctx, const JSBigInt *a,
                        unsigned int shift1) {
  int d, i, shift;
  JSBigInt *r;
  js_limb_t l;

  if (a->len == 1 && a->tab[0] == 0)
    return js_bigint_new_si(ctx, 0); /* zero case */
  d = shift1 / JS_LIMB_BITS;
  shift = shift1 % JS_LIMB_BITS;
  r = js_bigint_new(ctx, a->len + d);
  if (!r) return NULL;
  for (i = 0; i < d; i++) r->tab[i] = 0;
  if (shift == 0) {
    for (i = 0; i < a->len; i++) {
      r->tab[i + d] = a->tab[i];
    }
  } else {
    l = mp_shl(r->tab + d, a->tab, a->len, shift);
    if (js_bigint_sign(a)) l |= (js_limb_t)(-1) << shift;
    r = js_bigint_extend(ctx, r, l);
  }
  return r;
}

JSBigInt *js_bigint_shr(LEPUSContext *ctx, const JSBigInt *a,
                        unsigned int shift1) {
  int d, i, shift, a_sign, n1;
  JSBigInt *r;

  d = shift1 / JS_LIMB_BITS;
  shift = shift1 % JS_LIMB_BITS;
  a_sign = js_bigint_sign(a);
  if (d >= a->len) return js_bigint_new_si(ctx, -a_sign);
  n1 = a->len - d;
  r = js_bigint_new(ctx, n1);
  if (!r) return NULL;
  if (shift == 0) {
    for (i = 0; i < n1; i++) {
      r->tab[i] = a->tab[i + d];
    }
    /* no normalization is needed */
  } else {
    mp_shr(r->tab, a->tab + d, n1, shift, -a_sign);
    r = js_bigint_normalize(ctx, r);
  }
  return r;
}

JSBigInt *js_bigint_pow(LEPUSContext *ctx, const JSBigInt *a, JSBigInt *b) {
  uint32_t e;
  int n_bits, i;
  JSBigInt *r, *r1;

  /* b must be >= 0 */
  if (js_bigint_sign(b)) {
    LEPUS_ThrowRangeError(ctx, "BigInt negative exponent");
    return NULL;
  }
  if (b->len == 1 && b->tab[0] == 0) {
    /* a^0 = 1 */
    return js_bigint_new_si(ctx, 1);
  } else if (a->len == 1) {
    js_limb_t v;
    BOOL is_neg;

    v = a->tab[0];
    if (v <= 1)
      return js_bigint_new_si(ctx, v);
    else if (v == -1)
      return js_bigint_new_si(ctx, 1 - 2 * (b->tab[0] & 1));
    is_neg = (js_slimb_t)v < 0;
    if (is_neg) v = -v;
    if ((v & (v - 1)) == 0) {
      uint64_t e1;
      int n;
      /* v = 2^n */
      n = JS_LIMB_BITS - 1 - js_limb_clz(v);
      if (b->len > 1) goto overflow;
      if (b->tab[0] > INT32_MAX) goto overflow;
      e = b->tab[0];
      e1 = (uint64_t)e * n;
      if (e1 > JS_BIGINT_MAX_SIZE * JS_LIMB_BITS) goto overflow;
      e = e1;
      if (is_neg) is_neg = b->tab[0] & 1;
      r = js_bigint_new(ctx, (e + JS_LIMB_BITS + 1 - is_neg) / JS_LIMB_BITS);
      if (!r) return NULL;
      memset(r->tab, 0, sizeof(r->tab[0]) * r->len);
      r->tab[e / JS_LIMB_BITS] = (js_limb_t)(1 - 2 * is_neg)
                                 << (e % JS_LIMB_BITS);
      return r;
    }
  }
  if (b->len > 1) goto overflow;
  if (b->tab[0] > INT32_MAX) goto overflow;
  e = b->tab[0];
  n_bits = 32 - clz32(e);

  r = js_bigint_new(ctx, a->len);
  if (!r) return NULL;
  memcpy(r->tab, a->tab, a->len * sizeof(a->tab[0]));
  for (i = n_bits - 2; i >= 0; i--) {
    r1 = js_bigint_mul(ctx, r, r);
    if (!r1) return NULL;
    if (!ctx->gc_enable) lepus_free(ctx, r);
    r = r1;
    if ((e >> i) & 1) {
      r1 = js_bigint_mul(ctx, r, a);
      if (!r1) return NULL;
      if (!ctx->gc_enable) lepus_free(ctx, r);
      r = r1;
    }
  }
  return r;
overflow:
  LEPUS_ThrowRangeError(ctx, "BigInt is too large");
  return NULL;
}

/* return (mant, exp) so that abs(a) ~ mant*2^(exp - (limb_bits -
   1). a must be != 0. */
uint64_t js_bigint_get_mant_exp(LEPUSContext *ctx, int *pexp,
                                const JSBigInt *a) {
  js_limb_t t[4 - JS_LIMB_BITS / 32], carry, v, low_bits;
  int n1, n2, sgn, shift, i, j, e;
  uint64_t a1, a0;

  n2 = 4 - JS_LIMB_BITS / 32;
  n1 = a->len - n2;
  sgn = js_bigint_sign(a);

  /* low_bits != 0 if there are a non zero low bit in abs(a) */
  low_bits = 0;
  carry = sgn;
  for (i = 0; i < n1; i++) {
    v = (a->tab[i] ^ (-sgn)) + carry;
    carry = v < carry;
    low_bits |= v;
  }
  /* get the n2 high limbs of abs(a) */
  for (j = 0; j < n2; j++) {
    i = j + n1;
    if (i < 0) {
      v = 0;
    } else {
      v = (a->tab[i] ^ (-sgn)) + carry;
      carry = v < carry;
    }
    t[j] = v;
  }

#if JS_LIMB_BITS == 32
  a1 = ((uint64_t)t[2] << 32) | t[1];
  a0 = (uint64_t)t[0] << 32;
#else
  a1 = t[1];
  a0 = t[0];
#endif
  a0 |= (low_bits != 0);
  /* normalize */
  if (a1 == 0) {
    /* JS_LIMB_BITS = 64 bit only */
    shift = 64;
    a1 = a0;
    a0 = 0;
  } else {
    shift = clz64(a1);
    if (shift != 0) {
      a1 = (a1 << shift) | (a0 >> (64 - shift));
      a0 <<= shift;
    }
  }
  a1 |= (a0 != 0); /* keep the bits for the final rounding */
  /* compute the exponent */
  e = a->len * JS_LIMB_BITS - shift - 1;
  *pexp = e;
  return a1;
}

/* shift left with round to nearest, ties to even. n >= 1 */
uint64_t shr_rndn(uint64_t a, int n) {
  uint64_t addend = ((a >> n) & 1) + ((1 << (n - 1)) - 1);
  return (a + addend) >> n;
}

/* convert to float64 with round to nearest, ties to even. Return
   +/-infinity if too large. */
double js_bigint_to_float64(LEPUSContext *ctx, const JSBigInt *a) {
  int sgn, e;
  uint64_t mant;

  if (a->len == 1) {
    /* fast case, including zero */
    return (double)(js_slimb_t)a->tab[0];
  }

  sgn = js_bigint_sign(a);
  mant = js_bigint_get_mant_exp(ctx, &e, a);
  if (e > 1023) {
    /* overflow: return infinity */
    mant = 0;
    e = 1024;
  } else {
    mant = (mant >> 1) | (mant & 1); /* avoid overflow in rounding */
    mant = shr_rndn(mant, 10);
    /* rounding can cause an overflow */
    if (mant >= ((uint64_t)1 << 53)) {
      mant >>= 1;
      e++;
    }
    mant &= (((uint64_t)1 << 52) - 1);
  }
  return uint64_as_float64(((uint64_t)sgn << 63) |
                           ((uint64_t)(e + 1023) << 52) | mant);
}

/* return (1, NULL) if not an integer, (2, NULL) if NaN or Infinity,
   (0, n) if an integer, (0, NULL) in case of memory error */
JSBigInt *js_bigint_from_float64(LEPUSContext *ctx, int *pres, double a1) {
  uint64_t a = float64_as_uint64(a1);
  int sgn, e, shift;
  uint64_t mant;
  JSBigIntBuf buf;
  JSBigInt *r;

  sgn = a >> 63;
  e = (a >> 52) & ((1 << 11) - 1);
  mant = a & (((uint64_t)1 << 52) - 1);
  if (e == 2047) {
    /* NaN, Infinity */
    *pres = 2;
    return NULL;
  }
  if (e == 0 && mant == 0) {
    /* zero */
    *pres = 0;
    return js_bigint_new_si(ctx, 0);
  }
  e -= 1023;
  /* 0 < a < 1 : not an integer */
  if (e < 0) goto not_an_integer;
  mant |= (uint64_t)1 << 52;
  if (e < 52) {
    shift = 52 - e;
    /* check that there is no fractional part */
    if (mant & (((uint64_t)1 << shift) - 1)) {
    not_an_integer:
      *pres = 1;
      return NULL;
    }
    mant >>= shift;
    e = 0;
  } else {
    e -= 52;
  }
  if (sgn) mant = -mant;
  /* the integer is mant*2^e */
  r = js_bigint_set_si64(&buf, (int64_t)mant);
  *pres = 0;
  return js_bigint_shl(ctx, r, e);
}

/* return -1, 0, 1 or (2) (unordered) */
int js_bigint_float64_cmp(LEPUSContext *ctx, const JSBigInt *a, double b) {
  int b_sign, a_sign, e, f;
  uint64_t mant, b1, a_mant;

  b1 = float64_as_uint64(b);
  b_sign = b1 >> 63;
  e = (b1 >> 52) & ((1 << 11) - 1);
  mant = b1 & (((uint64_t)1 << 52) - 1);
  a_sign = js_bigint_sign(a);
  if (e == 2047) {
    if (mant != 0) {
      /* NaN */
      return 2;
    } else {
      /* +/- infinity */
      return 2 * b_sign - 1;
    }
  } else if (e == 0 && mant == 0) {
    /* b = +/-0 */
    if (a->len == 1 && a->tab[0] == 0)
      return 0;
    else
      return 1 - 2 * a_sign;
  } else if (a->len == 1 && a->tab[0] == 0) {
    /* a = 0, b != 0 */
    return 2 * b_sign - 1;
  } else if (a_sign != b_sign) {
    return 1 - 2 * a_sign;
  } else {
    e -= 1023;
    /* Note: handling denormals is not necessary because we
       compare to integers hence f >= 0 */
    /* compute f so that 2^f <= abs(a) < 2^(f+1) */
    a_mant = js_bigint_get_mant_exp(ctx, &f, a);
    if (f != e) {
      if (f < e)
        return -1;
      else
        return 1;
    } else {
      mant = (mant | ((uint64_t)1 << 52)) << 11; /* align to a_mant */
      if (a_mant < mant)
        return 2 * a_sign - 1;
      else if (a_mant > mant)
        return 1 - 2 * a_sign;
      else
        return 0;
    }
  }
}

/* return -1, 0 or 1 */
int js_bigint_cmp(LEPUSContext *ctx, const JSBigInt *a, const JSBigInt *b) {
  int a_sign, b_sign, res, i;
  a_sign = js_bigint_sign(a);
  b_sign = js_bigint_sign(b);
  if (a_sign != b_sign) {
    res = 1 - 2 * a_sign;
  } else {
    /* we assume the numbers are normalized */
    if (a->len != b->len) {
      if (a->len < b->len)
        res = 2 * a_sign - 1;
      else
        res = 1 - 2 * a_sign;
    } else {
      res = 0;
      for (i = a->len - 1; i >= 0; i--) {
        if (a->tab[i] != b->tab[i]) {
          if (a->tab[i] < b->tab[i])
            res = -1;
          else
            res = 1;
          break;
        }
      }
    }
  }
  return res;
}

/* syntax: [-]digits in base radix. Return NULL if memory error. radix
   = 10, 2, 8 or 16. */
JSBigInt *js_bigint_from_string(LEPUSContext *ctx, const char *str, int radix) {
  const char *p = str;
  int is_neg, n_digits, n_limbs, len, log2_radix, n_bits, i;
  JSBigInt *r;
  js_limb_t v, c, h;

  is_neg = 0;
  if (*p == '-') {
    is_neg = 1;
    p++;
  }
  while (*p == '0') p++;
  n_digits = strlen(p);
  log2_radix = 32 - clz32(radix - 1); /* ceil(log2(radix)) */
  /* compute the maximum number of limbs */
  /* XXX: overflow */
  if (radix == 10) {
    n_bits = (n_digits * 27 + 7) / 8; /* >= ceil(n_digits * log2(10)) */
  } else {
    n_bits = n_digits * log2_radix;
  }
  /* we add one extra bit for the sign */
  n_limbs = max_int(1, n_bits / JS_LIMB_BITS + 1);
  r = js_bigint_new(ctx, n_limbs);
  if (!r) return NULL;
  if (radix == 10) {
    int digits_per_limb = JS_LIMB_DIGITS;
    len = 1;
    r->tab[0] = 0;
    for (;;) {
      /* XXX: slow */
      v = 0;
      for (i = 0; i < digits_per_limb; i++) {
        c = to_digit(*p);
        if (c >= radix) break;
        p++;
        v = v * 10 + c;
      }
      if (i == 0) break;
      if (len == 1 && r->tab[0] == 0) {
        r->tab[0] = v;
      } else {
        h = mp_mul1(r->tab, r->tab, len, js_pow_dec[i], v);
        if (h != 0) {
          r->tab[len++] = h;
        }
      }
    }
    /* add one extra limb to have the correct sign*/
    if ((r->tab[len - 1] >> (JS_LIMB_BITS - 1)) != 0) r->tab[len++] = 0;
    r->len = len;
  } else {
    unsigned int bit_pos, shift, pos;

    /* power of two base: no multiplication is needed */
    r->len = n_limbs;
    memset(r->tab, 0, sizeof(r->tab[0]) * n_limbs);
    for (i = 0; i < n_digits; i++) {
      c = to_digit(p[n_digits - 1 - i]);
      assert(c < radix);
      bit_pos = i * log2_radix;
      shift = bit_pos & (JS_LIMB_BITS - 1);
      pos = bit_pos / JS_LIMB_BITS;
      r->tab[pos] |= c << shift;
      /* if log2_radix does not divide JS_LIMB_BITS, needed an
         additional op */
      if (shift + log2_radix > JS_LIMB_BITS) {
        r->tab[pos + 1] |= c >> (JS_LIMB_BITS - shift);
      }
    }
  }
  r = js_bigint_normalize(ctx, r);
  /* XXX: could do it in place */
  if (is_neg) {
    JSBigInt *r1;
    r1 = js_bigint_neg(ctx, r);
    if (!ctx->gc_enable) lepus_free(ctx, r);
    r = r1;
  }
  return r;
}

/* special version going backwards */
/* XXX: use dtoa.c */

char *js_u64toa(char *q, int64_t n, unsigned int base) {
  int digit;
  if (base == 10) {
    /* division by known base uses multiplication */
    do {
      digit = (uint64_t)n % 10;
      n = (uint64_t)n / 10;
      *--q = '0' + digit;
    } while (n != 0);
  } else {
    do {
      digit = (uint64_t)n % base;
      n = (uint64_t)n / base;
      *--q = digits[digit];
    } while (n != 0);
  }
  return q;
}

/* len >= 1. 2 <= radix <= 36 */
char *limb_to_a(char *q, js_limb_t n, unsigned int radix, int len) {
  int digit, i;

  if (radix == 10) {
    /* specific case with constant divisor */
    /* XXX: optimize */
    for (i = 0; i < len; i++) {
      digit = (js_limb_t)n % 10;
      n = (js_limb_t)n / 10;
      *--q = digit + '0';
    }
  } else {
    for (i = 0; i < len; i++) {
      digit = (js_limb_t)n % radix;
      n = (js_limb_t)n / radix;
      *--q = digits[digit];
    }
  }
  return q;
}

/* return an exception in case of memory error. Return JS_NAN if
   invalid syntax */
/* XXX: directly use js_atod() */
LEPUSValue js_atof(LEPUSContext *ctx, const char *str, const char **pp,
                   int radix, int flags) {
  const char *p, *p_start;
  int sep, is_neg;
  BOOL is_float, has_legacy_octal;
  int atod_type = flags & ATOD_TYPE_MASK;
  char buf1[64], *buf;
  int i, j, len;
  BOOL buf_allocated = FALSE;
  LEPUSValue val;
  JSATODTempMem atod_mem;

  /* optional separator between digits */
  sep = (flags & ATOD_ACCEPT_UNDERSCORES) ? '_' : 256;
  has_legacy_octal = FALSE;

  p = str;
  p_start = p;
  is_neg = 0;
  if (p[0] == '+') {
    p++;
    p_start++;
    if (!(flags & ATOD_ACCEPT_PREFIX_AFTER_SIGN)) goto no_radix_prefix;
  } else if (p[0] == '-') {
    p++;
    p_start++;
    is_neg = 1;
    if (!(flags & ATOD_ACCEPT_PREFIX_AFTER_SIGN)) goto no_radix_prefix;
  }
  if (p[0] == '0') {
    if ((p[1] == 'x' || p[1] == 'X') && (radix == 0 || radix == 16)) {
      p += 2;
      radix = 16;
    } else if ((p[1] == 'o' || p[1] == 'O') && radix == 0 &&
               (flags & ATOD_ACCEPT_BIN_OCT)) {
      p += 2;
      radix = 8;
    } else if ((p[1] == 'b' || p[1] == 'B') && radix == 0 &&
               (flags & ATOD_ACCEPT_BIN_OCT)) {
      p += 2;
      radix = 2;
    } else if ((p[1] >= '0' && p[1] <= '9') && radix == 0 &&
               (flags & ATOD_ACCEPT_LEGACY_OCTAL)) {
      int i;
      has_legacy_octal = TRUE;
      sep = 256;
      for (i = 1; (p[i] >= '0' && p[i] <= '7'); i++) continue;
      if (p[i] == '8' || p[i] == '9') goto no_prefix;
      p += 1;
      radix = 8;
    } else {
      goto no_prefix;
    }
    /* there must be a digit after the prefix */
    if (to_digit((uint8_t)*p) >= radix) goto fail;
  no_prefix:;
  } else {
  no_radix_prefix:
    if (!(flags & ATOD_INT_ONLY) && (atod_type == ATOD_TYPE_FLOAT64) &&
        strstart(p, "Infinity", &p)) {
      double d = 1.0 / 0.0;
      if (is_neg) d = -d;
      val = LEPUS_NewFloat64(ctx, d);
      goto done;
    }
  }
  if (radix == 0) radix = 10;
  is_float = FALSE;
  p_start = p;
  while (to_digit((uint8_t)*p) < radix ||
         (*p == sep && (radix != 10 || p != p_start + 1 || p[-1] != '0') &&
          to_digit((uint8_t)p[1]) < radix)) {
    p++;
  }
  if (!(flags & ATOD_INT_ONLY)) {
    if (*p == '.' && (p > p_start || to_digit((uint8_t)p[1]) < radix)) {
      is_float = TRUE;
      p++;
      if (*p == sep) goto fail;
      while (to_digit((uint8_t)*p) < radix ||
             (*p == sep && to_digit((uint8_t)p[1]) < radix))
        p++;
    }
    if (p > p_start && (((*p == 'e' || *p == 'E') && radix == 10) ||
                        ((*p == 'p' || *p == 'P') &&
                         (radix == 2 || radix == 8 || radix == 16)))) {
      const char *p1 = p + 1;
      is_float = TRUE;
      if (*p1 == '+') {
        p1++;
      } else if (*p1 == '-') {
        p1++;
      }
      if (is_digit((uint8_t)*p1)) {
        p = p1 + 1;
        while (is_digit((uint8_t)*p) || (*p == sep && is_digit((uint8_t)p[1])))
          p++;
      }
    }
  }
  if (p == p_start) goto fail;

  buf = buf1;
  buf_allocated = FALSE;
  len = p - p_start;
  if (unlikely((len + 2) > sizeof(buf1))) {
    buf =
        (char *)lepus_malloc_rt(ctx->rt, len + 2, 0); /* no exception raised */
    if (!buf) goto mem_error;
    buf_allocated = TRUE;
  }
  /* remove the separators and the radix prefixes */
  j = 0;
  if (is_neg) buf[j++] = '-';
  for (i = 0; i < len; i++) {
    if (p_start[i] != '_') buf[j++] = p_start[i];
  }
  buf[j] = '\0';

  if (flags & ATOD_ACCEPT_SUFFIX) {
    if (*p == 'n') {
      p++;
      atod_type = ATOD_TYPE_BIG_INT;
    } else {
      if (is_float && radix != 10) goto fail;
    }
  } else {
    if (atod_type == ATOD_TYPE_FLOAT64) {
      if (is_float && radix != 10) goto fail;
    }
  }

  switch (atod_type) {
    case ATOD_TYPE_FLOAT64: {
      double d;
      d = js_atod(buf, NULL, radix, is_float ? 0 : JS_ATOD_INT_ONLY, &atod_mem);
      /* return int or float64 */
      val = LEPUS_NewFloat64(ctx, d);
    } break;
    case ATOD_TYPE_BIG_INT: {
      JSBigInt *r;
      if (has_legacy_octal || is_float) goto fail;
      r = js_bigint_from_string(ctx, buf, radix);
      if (!r) goto mem_error;
      val = JS_CompactBigInt(ctx, r);
    } break;
    default:
      abort();
  }

done:
  if (buf_allocated && !ctx->gc_enable) lepus_free_rt(ctx->rt, buf);
  if (pp) *pp = p;
  return val;
fail:
  val = LEPUS_NAN;
  goto done;
mem_error:
  val = LEPUS_ThrowOutOfMemory(ctx);
  goto done;
}

/* op1 must be a bigint or int. */
static JSBigInt *JS_ToBigIntBuf(LEPUSContext *ctx, JSBigIntBuf *buf1,
                                LEPUSValue op1) {
  JSBigInt *p1;

  switch (LEPUS_VALUE_GET_TAG(op1)) {
    case LEPUS_TAG_INT:
      p1 = js_bigint_set_si(buf1, LEPUS_VALUE_GET_INT(op1));
      break;
    case LEPUS_TAG_BIG_INT:
      p1 = (JSBigInt *)LEPUS_VALUE_GET_PTR(op1);
      break;
    default:
      abort();
  }
  return p1;
}

/* op1 and op2 must be numeric types and at least one must be a
   bigint. No exception is generated. */
int js_compare_bigint(LEPUSContext *ctx, OPCodeEnum op, LEPUSValue op1,
                      LEPUSValue op2) {
  int res, val;
  int64_t tag1, tag2;
  JSBigIntBuf buf1, buf2;
  JSBigInt *p1, *p2;

  tag1 = LEPUS_VALUE_GET_NORM_TAG(op1);
  tag2 = LEPUS_VALUE_GET_NORM_TAG(op2);
  if (tag1 == LEPUS_TAG_INT && tag2 == LEPUS_TAG_INT) {
    /* fast path */
    js_slimb_t v1, v2;
    v1 = LEPUS_VALUE_GET_INT(op1);
    v2 = LEPUS_VALUE_GET_INT(op2);
    val = (v1 > v2) - (v1 < v2);
  } else {
    if (tag1 == LEPUS_TAG_FLOAT64) {
      p2 = JS_ToBigIntBuf(ctx, &buf2, op2);
      val = js_bigint_float64_cmp(ctx, p2, LEPUS_VALUE_GET_FLOAT64(op1));
      if (val == 2) goto unordered;
      val = -val;
    } else if (tag2 == LEPUS_TAG_FLOAT64) {
      p1 = JS_ToBigIntBuf(ctx, &buf1, op1);
      val = js_bigint_float64_cmp(ctx, p1, LEPUS_VALUE_GET_FLOAT64(op2));
      if (val == 2) {
      unordered:
        if (!ctx->gc_enable) {
          LEPUS_FreeValue(ctx, op1);
          LEPUS_FreeValue(ctx, op2);
        }
        return FALSE;
      }
    } else {
      p1 = JS_ToBigIntBuf(ctx, &buf1, op1);
      p2 = JS_ToBigIntBuf(ctx, &buf2, op2);
      val = js_bigint_cmp(ctx, p1, p2);
    }
    if (!ctx->gc_enable) {
      LEPUS_FreeValue(ctx, op1);
      LEPUS_FreeValue(ctx, op2);
    }
  }

  switch (op) {
    case OP_lt:
      res = val < 0;
      break;
    case OP_lte:
      res = val <= 0;
      break;
    case OP_gt:
      res = val > 0;
      break;
    case OP_gte:
      res = val >= 0;
      break;
    case OP_eq:
      res = val == 0;
      break;
    default:
      abort();
  }
  return res;
}

LEPUSValue js_bigint_to_string1(LEPUSContext *ctx, LEPUSValueConst val,
                                int radix) {
  JSBigInt *r, *tmp = NULL;
  char *buf, *q, *buf_end;
  int is_neg, n_bits, log2_radix, n_digits;
  BOOL is_binary_radix;
  LEPUSValue res;

  assert(LEPUS_VALUE_GET_TAG(val) == LEPUS_TAG_BIG_INT);
  r = LEPUS_VALUE_GET_BIGINT(val);
  if (r->len == 1 && r->tab[0] == 0) {
    /* '0' case */
    return js_new_string8_len(ctx, "0", 1);
  }
  is_binary_radix = ((radix & (radix - 1)) == 0);
  is_neg = js_bigint_sign(r);
  if (is_neg) {
    tmp = js_bigint_neg(ctx, r);
    if (!tmp) return LEPUS_EXCEPTION;
    r = tmp;
  } else if (!is_binary_radix) {
    /* need to modify 'r' */
    tmp = js_bigint_new(ctx, r->len);
    if (!tmp) return LEPUS_EXCEPTION;
    memcpy(tmp->tab, r->tab, r->len * sizeof(r->tab[0]));
    r = tmp;
  }
  log2_radix = 31 - clz32(radix); /* floor(log2(radix)) */
  n_bits = r->len * JS_LIMB_BITS - js_limb_safe_clz(r->tab[r->len - 1]);
  /* n_digits is exact only if radix is a power of
     two. Otherwise it is >= the exact number of digits */
  n_digits = (n_bits + log2_radix - 1) / log2_radix;
  /* XXX: could directly build the JSString */
  buf = (char *)lepus_malloc(ctx, n_digits + is_neg + 1, 0);
  if (!buf && !ctx->gc_enable) {
    lepus_free(ctx, tmp);
    return LEPUS_EXCEPTION;
  }
  q = buf + n_digits + is_neg + 1;
  *--q = '\0';
  buf_end = q;
  if (!is_binary_radix) {
    int len;
    js_limb_t radix_base, v;
    radix_base = radix_base_table[radix - 2];
    len = r->len;
    for (;;) {
      /* remove leading zero limbs */
      while (len > 1 && r->tab[len - 1] == 0) len--;
      if (len == 1 && r->tab[0] < radix_base) {
        v = r->tab[0];
        if (v != 0) {
          q = js_u64toa(q, v, radix);
        }
        break;
      } else {
        v = mp_div1(r->tab, r->tab, len, radix_base, 0);
        q = limb_to_a(q, v, radix, digits_per_limb_table[radix - 2]);
      }
    }
  } else {
    int i, shift;
    unsigned int bit_pos, pos, c;

    /* radix is a power of two */
    for (i = 0; i < n_digits; i++) {
      bit_pos = i * log2_radix;
      pos = bit_pos / JS_LIMB_BITS;
      shift = bit_pos % JS_LIMB_BITS;
      if (likely((shift + log2_radix) <= JS_LIMB_BITS)) {
        c = r->tab[pos] >> shift;
      } else {
        c = (r->tab[pos] >> shift) |
            (r->tab[pos + 1] << (JS_LIMB_BITS - shift));
      }
      c &= (radix - 1);
      *--q = digits[c];
    }
  }
  if (is_neg) *--q = '-';
  if (!ctx->gc_enable) lepus_free(ctx, tmp);
  res = js_new_string8_len(ctx, q, buf_end - q);
  if (!ctx->gc_enable) lepus_free(ctx, buf);
  return res;
}

LEPUSValue js_dtoa2(LEPUSContext *ctx, double d, int32_t radix,
                    int32_t n_digits, int32_t flags) {
  char static_buf[128], *buf, *tmp_buf;
  int32_t len, len_max;
  LEPUSValue res;
  JSDTOATempMem dtoa_mem;
  len_max = js_dtoa_max_len(d, radix, n_digits, flags);

  /* longer buffer may be used if radix != 10 */
  if (len_max > sizeof(static_buf) - 1) {
    tmp_buf = (char *)lepus_malloc(ctx, len_max + 1, 0);
    if (!tmp_buf) return LEPUS_EXCEPTION;
    buf = tmp_buf;
  } else {
    tmp_buf = nullptr;
    buf = static_buf;
  }
  len = js_dtoa(buf, d, radix, n_digits, flags, &dtoa_mem);
  res = js_new_string8(ctx, buf, len);
  if (!ctx->gc_enable) lepus_free(ctx, tmp_buf);
  return res;
}

LEPUSValue LEPUS_NewBigInt64(LEPUSContext *ctx, int64_t v) {
  JSBigInt *p;
  p = js_bigint_new_si64(ctx, v);
  if (!p) return LEPUS_EXCEPTION;
  return LEPUS_MKPTR(LEPUS_TAG_BIG_INT, p);
}

LEPUSValue LEPUS_NewBigUint64(LEPUSContext *ctx, uint64_t v) {
  JSBigInt *p;
  p = js_bigint_new_ui64(ctx, v);
  if (!p) return LEPUS_EXCEPTION;
  return LEPUS_MKPTR(LEPUS_TAG_BIG_INT, p);
}
