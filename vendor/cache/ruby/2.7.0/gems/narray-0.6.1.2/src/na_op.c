/*
  na_op.c
  Automatically generated code
  Numerical Array Extention for Ruby
    (C) Copyright 1999-2008 by Masahiro TANAKA

  This program is free software.
  You can distribute/modify this program
  under the same terms as Ruby itself.
  NO WARRANTY.
*/
#include <ruby.h>
#include "narray.h"
#include "narray_local.h"
/* isalpha(3) etc. */
#include <ctype.h>

const int na_upcast[NA_NTYPES][NA_NTYPES] = {
  {0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 1, 2, 3, 4, 5, 6, 7, 8},
  {0, 2, 2, 3, 4, 5, 6, 7, 8},
  {0, 3, 3, 3, 4, 5, 6, 7, 8},
  {0, 4, 4, 4, 4, 5, 6, 7, 8},
  {0, 5, 5, 5, 5, 5, 7, 7, 8},
  {0, 6, 6, 6, 6, 7, 6, 7, 8},
  {0, 7, 7, 7, 7, 7, 7, 7, 8},
  {0, 8, 8, 8, 8, 8, 8, 8, 8} };

const int na_no_cast[NA_NTYPES] =
 { 0, 1, 2, 3, 4, 5, 6, 7, 8 };
const int na_cast_real[NA_NTYPES] =
 { 0, 1, 2, 3, 4, 5, 4, 5, 8 };
const int na_cast_comp[NA_NTYPES] =
 { 0, 6, 6, 6, 6, 7, 6, 7, 8 };
const int na_cast_round[NA_NTYPES] =
 { 0, 1, 2, 3, 3, 3, 6, 7, 8 };
const int na_cast_byte[NA_NTYPES] =
 { 0, 1, 1, 1, 1, 1, 1, 1, 1 };


static void TpErr(void) {
    rb_raise(rb_eTypeError,"illegal operation with this type");
}
static int TpErrI(void) {
    rb_raise(rb_eTypeError,"illegal operation with this type");
    return 0;
}
static void na_zerodiv() {
    rb_raise(rb_eZeroDivError, "divided by 0");
}

static int notnanF(float *n)
{
  return *n == *n;
}
static int notnanD(double *n)
{
  return *n == *n;
}

/* ------------------------- Set --------------------------- */
static void SetBB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (u_int8_t)*(u_int8_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetBI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (u_int8_t)*(int16_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetBL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (u_int8_t)*(int32_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetBF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (u_int8_t)*(float*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetBD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (u_int8_t)*(double*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetBX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (u_int8_t)((scomplex*)p2)->r;
    p1+=i1; p2+=i2;
  }
}
static void SetBC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (u_int8_t)((dcomplex*)p2)->r;
    p1+=i1; p2+=i2;
  }
}
static void SetBO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (u_int8_t)NUM2INT(*(VALUE*)p2);
    p1+=i1; p2+=i2;
  }
}
static void SetIB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 = (int16_t)*(u_int8_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetII(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 = (int16_t)*(int16_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetIL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 = (int16_t)*(int32_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetIF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 = (int16_t)*(float*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetID(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 = (int16_t)*(double*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetIX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 = (int16_t)((scomplex*)p2)->r;
    p1+=i1; p2+=i2;
  }
}
static void SetIC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 = (int16_t)((dcomplex*)p2)->r;
    p1+=i1; p2+=i2;
  }
}
static void SetIO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 = (int16_t)NUM2INT(*(VALUE*)p2);
    p1+=i1; p2+=i2;
  }
}
static void SetLB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = (int32_t)*(u_int8_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetLI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = (int32_t)*(int16_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetLL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = (int32_t)*(int32_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetLF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = (int32_t)*(float*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetLD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = (int32_t)*(double*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetLX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = (int32_t)((scomplex*)p2)->r;
    p1+=i1; p2+=i2;
  }
}
static void SetLC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = (int32_t)((dcomplex*)p2)->r;
    p1+=i1; p2+=i2;
  }
}
static void SetLO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = (int32_t)NUM2INT(*(VALUE*)p2);
    p1+=i1; p2+=i2;
  }
}
static void SetFB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = (float)*(u_int8_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetFI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = (float)*(int16_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetFL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = (float)*(int32_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetFF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = (float)*(float*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetFD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = (float)*(double*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetFX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = (float)((scomplex*)p2)->r;
    p1+=i1; p2+=i2;
  }
}
static void SetFC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = (float)((dcomplex*)p2)->r;
    p1+=i1; p2+=i2;
  }
}
static void SetFO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = (float)NUM2DBL(*(VALUE*)p2);
    p1+=i1; p2+=i2;
  }
}
static void SetDB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = (double)*(u_int8_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetDI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = (double)*(int16_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetDL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = (double)*(int32_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetDF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = (double)*(float*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetDD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = (double)*(double*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SetDX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = (double)((scomplex*)p2)->r;
    p1+=i1; p2+=i2;
  }
}
static void SetDC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = (double)((dcomplex*)p2)->r;
    p1+=i1; p2+=i2;
  }
}
static void SetDO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = (double)NUM2DBL(*(VALUE*)p2);
    p1+=i1; p2+=i2;
  }
}
static void SetXB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((scomplex*)p1)->r = (float)*(u_int8_t*)p2; ((scomplex*)p1)->i = (float)0;
    p1+=i1; p2+=i2;
  }
}
static void SetXI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((scomplex*)p1)->r = (float)*(int16_t*)p2; ((scomplex*)p1)->i = (float)0;
    p1+=i1; p2+=i2;
  }
}
static void SetXL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((scomplex*)p1)->r = (float)*(int32_t*)p2; ((scomplex*)p1)->i = (float)0;
    p1+=i1; p2+=i2;
  }
}
static void SetXF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((scomplex*)p1)->r = (float)*(float*)p2; ((scomplex*)p1)->i = (float)0;
    p1+=i1; p2+=i2;
  }
}
static void SetXD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((scomplex*)p1)->r = (float)*(double*)p2; ((scomplex*)p1)->i = (float)0;
    p1+=i1; p2+=i2;
  }
}
static void SetXX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((scomplex*)p1)->r = (float)((scomplex*)p2)->r; ((scomplex*)p1)->i = (float)((scomplex*)p2)->i;
    p1+=i1; p2+=i2;
  }
}
static void SetXC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((scomplex*)p1)->r = (float)((dcomplex*)p2)->r; ((scomplex*)p1)->i = (float)((dcomplex*)p2)->i;
    p1+=i1; p2+=i2;
  }
}
static void SetXO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((scomplex*)p1)->r = (float)NUM2REAL(*(VALUE*)p2); ((scomplex*)p1)->i = (float)NUM2IMAG(*(VALUE*)p2);
    p1+=i1; p2+=i2;
  }
}
static void SetCB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r = (double)*(u_int8_t*)p2; ((dcomplex*)p1)->i = (double)0;
    p1+=i1; p2+=i2;
  }
}
static void SetCI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r = (double)*(int16_t*)p2; ((dcomplex*)p1)->i = (double)0;
    p1+=i1; p2+=i2;
  }
}
static void SetCL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r = (double)*(int32_t*)p2; ((dcomplex*)p1)->i = (double)0;
    p1+=i1; p2+=i2;
  }
}
static void SetCF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r = (double)*(float*)p2; ((dcomplex*)p1)->i = (double)0;
    p1+=i1; p2+=i2;
  }
}
static void SetCD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r = (double)*(double*)p2; ((dcomplex*)p1)->i = (double)0;
    p1+=i1; p2+=i2;
  }
}
static void SetCX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r = (double)((scomplex*)p2)->r; ((dcomplex*)p1)->i = (double)((scomplex*)p2)->i;
    p1+=i1; p2+=i2;
  }
}
static void SetCC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r = (double)((dcomplex*)p2)->r; ((dcomplex*)p1)->i = (double)((dcomplex*)p2)->i;
    p1+=i1; p2+=i2;
  }
}
static void SetCO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r = (double)NUM2REAL(*(VALUE*)p2); ((dcomplex*)p1)->i = (double)NUM2IMAG(*(VALUE*)p2);
    p1+=i1; p2+=i2;
  }
}
static void SetOB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = (VALUE)INT2FIX(*(u_int8_t*)p2);
    p1+=i1; p2+=i2;
  }
}
static void SetOI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = (VALUE)INT2FIX(*(int16_t*)p2);
    p1+=i1; p2+=i2;
  }
}
static void SetOL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = (VALUE)INT2NUM(*(int32_t*)p2);
    p1+=i1; p2+=i2;
  }
}
static void SetOF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = (VALUE)rb_float_new(*(float*)p2);
    p1+=i1; p2+=i2;
  }
}
static void SetOD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = (VALUE)rb_float_new(*(double*)p2);
    p1+=i1; p2+=i2;
  }
}
static void SetOX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = (VALUE)rb_complex_new(((scomplex*)p2)->r,((scomplex*)p2)->i);
    p1+=i1; p2+=i2;
  }
}
static void SetOC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = (VALUE)rb_complex_new(((dcomplex*)p2)->r,((dcomplex*)p2)->i);
    p1+=i1; p2+=i2;
  }
}
static void SetOO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = (VALUE)*(VALUE*)p2;
    p1+=i1; p2+=i2;
  }
}

na_setfunc_t SetFuncs = {
  { TpErr, TpErr, TpErr, TpErr, TpErr, TpErr, TpErr, TpErr, TpErr },
  { TpErr, SetBB, SetBI, SetBL, SetBF, SetBD, SetBX, SetBC, SetBO },
  { TpErr, SetIB, SetII, SetIL, SetIF, SetID, SetIX, SetIC, SetIO },
  { TpErr, SetLB, SetLI, SetLL, SetLF, SetLD, SetLX, SetLC, SetLO },
  { TpErr, SetFB, SetFI, SetFL, SetFF, SetFD, SetFX, SetFC, SetFO },
  { TpErr, SetDB, SetDI, SetDL, SetDF, SetDD, SetDX, SetDC, SetDO },
  { TpErr, SetXB, SetXI, SetXL, SetXF, SetXD, SetXX, SetXC, SetXO },
  { TpErr, SetCB, SetCI, SetCL, SetCF, SetCD, SetCX, SetCC, SetCO },
  { TpErr, SetOB, SetOI, SetOL, SetOF, SetOD, SetOX, SetOC, SetOO }
};

/* ------------------------- Swp --------------------------- */
static void SwpB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = *(u_int8_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SwpI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    na_size16_t x;  swap16(x,*(na_size16_t*)p2);   *(na_size16_t*)p1 = x;
    p1+=i1; p2+=i2;
  }
}
static void SwpL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    na_size32_t x;  swap32(x,*(na_size32_t*)p2);   *(na_size32_t*)p1 = x;
    p1+=i1; p2+=i2;
  }
}
static void SwpF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    na_size32_t x;  swap32(x,*(na_size32_t*)p2);   *(na_size32_t*)p1 = x;
    p1+=i1; p2+=i2;
  }
}
static void SwpD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    na_size64_t x;  swap64(x,*(na_size64_t*)p2);   *(na_size64_t*)p1 = x;
    p1+=i1; p2+=i2;
  }
}
static void SwpX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    na_size64_t x;  swap64c(x,*(na_size64_t*)p2);  *(na_size64_t*)p1 = x;
    p1+=i1; p2+=i2;
  }
}
static void SwpC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    na_size128_t x; swap128c(x,*(na_size128_t*)p2); *(na_size128_t*)p1 = x;
    p1+=i1; p2+=i2;
  }
}
static void SwpO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = *(VALUE*)p2;
    p1+=i1; p2+=i2;
  }
}

na_func_t SwpFuncs =
{ TpErr, SwpB, SwpI, SwpL, SwpF, SwpD, SwpX, SwpC, SwpO };

/* ------------------------- H2N --------------------------- */
#ifdef WORDS_BIGENDIAN

na_func_t H2NFuncs =
{ TpErr, SetBB, SetII, SetLL, SetFF, SetDD, SetXX, SetCC, SetOO };

na_func_t H2VFuncs =
{ TpErr, SetBB, SwpI, SwpL, SwpF, SwpD, SwpX, SwpC, SetOO };

#else
#ifdef DYNAMIC_ENDIAN  /* not supported yet */
#else  /* LITTLE ENDIAN */

na_func_t H2NFuncs =
{ TpErr, SetBB, SwpI, SwpL, SwpF, SwpD, SwpX, SwpC, SetOO };

na_func_t H2VFuncs =
{ TpErr, SetBB, SetII, SetLL, SetFF, SetDD, SetXX, SetCC, SetOO };

#endif
#endif

/* ------------------------- Neg --------------------------- */
static void NegB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = -*(u_int8_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void NegI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 = -*(int16_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void NegL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = -*(int32_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void NegF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = -*(float*)p2;
    p1+=i1; p2+=i2;
  }
}
static void NegD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = -*(double*)p2;
    p1+=i1; p2+=i2;
  }
}
static void NegX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((scomplex*)p1)->r = -((scomplex*)p2)->r;
    ((scomplex*)p1)->i = -((scomplex*)p2)->i;
    p1+=i1; p2+=i2;
  }
}
static void NegC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r = -((dcomplex*)p2)->r;
    ((dcomplex*)p1)->i = -((dcomplex*)p2)->i;
    p1+=i1; p2+=i2;
  }
}
static void NegO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p2,na_id_minus,0);
    p1+=i1; p2+=i2;
  }
}

na_func_t NegFuncs =
{ TpErr, NegB, NegI, NegL, NegF, NegD, NegX, NegC, NegO };

/* ------------------------- AddU --------------------------- */
static void AddUB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 += *(u_int8_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void AddUI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 += *(int16_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void AddUL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 += *(int32_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void AddUF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 += *(float*)p2;
    p1+=i1; p2+=i2;
  }
}
static void AddUD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 += *(double*)p2;
    p1+=i1; p2+=i2;
  }
}
static void AddUX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((scomplex*)p1)->r += ((scomplex*)p2)->r;
    ((scomplex*)p1)->i += ((scomplex*)p2)->i;
    p1+=i1; p2+=i2;
  }
}
static void AddUC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r += ((dcomplex*)p2)->r;
    ((dcomplex*)p1)->i += ((dcomplex*)p2)->i;
    p1+=i1; p2+=i2;
  }
}
static void AddUO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p1,'+',1,*(VALUE*)p2);
    p1+=i1; p2+=i2;
  }
}

na_func_t AddUFuncs =
{ TpErr, AddUB, AddUI, AddUL, AddUF, AddUD, AddUX, AddUC, AddUO };

/* ------------------------- SbtU --------------------------- */
static void SbtUB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 -= *(u_int8_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SbtUI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 -= *(int16_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SbtUL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 -= *(int32_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SbtUF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 -= *(float*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SbtUD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 -= *(double*)p2;
    p1+=i1; p2+=i2;
  }
}
static void SbtUX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((scomplex*)p1)->r -= ((scomplex*)p2)->r;
    ((scomplex*)p1)->i -= ((scomplex*)p2)->i;
    p1+=i1; p2+=i2;
  }
}
static void SbtUC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r -= ((dcomplex*)p2)->r;
    ((dcomplex*)p1)->i -= ((dcomplex*)p2)->i;
    p1+=i1; p2+=i2;
  }
}
static void SbtUO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p1,'-',1,*(VALUE*)p2);
    p1+=i1; p2+=i2;
  }
}

na_func_t SbtUFuncs =
{ TpErr, SbtUB, SbtUI, SbtUL, SbtUF, SbtUD, SbtUX, SbtUC, SbtUO };

/* ------------------------- MulU --------------------------- */
static void MulUB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 *= *(u_int8_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void MulUI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 *= *(int16_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void MulUL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 *= *(int32_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void MulUF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 *= *(float*)p2;
    p1+=i1; p2+=i2;
  }
}
static void MulUD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 *= *(double*)p2;
    p1+=i1; p2+=i2;
  }
}
static void MulUX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    scomplex x = *(scomplex*)p1;
    ((scomplex*)p1)->r = x.r*((scomplex*)p2)->r - x.i*((scomplex*)p2)->i;
    ((scomplex*)p1)->i = x.r*((scomplex*)p2)->i + x.i*((scomplex*)p2)->r;
    p1+=i1; p2+=i2;
  }
}
static void MulUC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    dcomplex x = *(dcomplex*)p1;
    ((dcomplex*)p1)->r = x.r*((dcomplex*)p2)->r - x.i*((dcomplex*)p2)->i;
    ((dcomplex*)p1)->i = x.r*((dcomplex*)p2)->i + x.i*((dcomplex*)p2)->r;
    p1+=i1; p2+=i2;
  }
}
static void MulUO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p1,'*',1,*(VALUE*)p2);
    p1+=i1; p2+=i2;
  }
}

na_func_t MulUFuncs =
{ TpErr, MulUB, MulUI, MulUL, MulUF, MulUD, MulUX, MulUC, MulUO };

/* ------------------------- DivU --------------------------- */
static void DivUB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (*(u_int8_t*)p2==0) {na_zerodiv();}
    *(u_int8_t*)p1 /= *(u_int8_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void DivUI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (*(int16_t*)p2==0) {na_zerodiv();}
    *(int16_t*)p1 /= *(int16_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void DivUL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (*(int32_t*)p2==0) {na_zerodiv();}
    *(int32_t*)p1 /= *(int32_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void DivUF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 /= *(float*)p2;
    p1+=i1; p2+=i2;
  }
}
static void DivUD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 /= *(double*)p2;
    p1+=i1; p2+=i2;
  }
}
static void DivUX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    scomplex x = *(scomplex*)p1;
    float a = ((scomplex*)p2)->r*((scomplex*)p2)->r + ((scomplex*)p2)->i*((scomplex*)p2)->i;
    ((scomplex*)p1)->r = (x.r*((scomplex*)p2)->r + x.i*((scomplex*)p2)->i)/a;
    ((scomplex*)p1)->i = (x.i*((scomplex*)p2)->r - x.r*((scomplex*)p2)->i)/a;
    p1+=i1; p2+=i2;
  }
}
static void DivUC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    dcomplex x = *(dcomplex*)p1;
    double a = ((dcomplex*)p2)->r*((dcomplex*)p2)->r + ((dcomplex*)p2)->i*((dcomplex*)p2)->i;
    ((dcomplex*)p1)->r = (x.r*((dcomplex*)p2)->r + x.i*((dcomplex*)p2)->i)/a;
    ((dcomplex*)p1)->i = (x.i*((dcomplex*)p2)->r - x.r*((dcomplex*)p2)->i)/a;
    p1+=i1; p2+=i2;
  }
}
static void DivUO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p1,'/',1,*(VALUE*)p2);
    p1+=i1; p2+=i2;
  }
}

na_func_t DivUFuncs =
{ TpErr, DivUB, DivUI, DivUL, DivUF, DivUD, DivUX, DivUC, DivUO };

/* ------------------------- ModU --------------------------- */
static void ModUB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (*(u_int8_t*)p2==0) {na_zerodiv();}
    *(u_int8_t*)p1 %= *(u_int8_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void ModUI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (*(int16_t*)p2==0) {na_zerodiv();}
    *(int16_t*)p1 %= *(int16_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void ModUL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (*(int32_t*)p2==0) {na_zerodiv();}
    *(int32_t*)p1 %= *(int32_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void ModUF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = fmod(*(float*)p1, *(float*)p2);
    p1+=i1; p2+=i2;
  }
}
static void ModUD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = fmod(*(double*)p1, *(double*)p2);
    p1+=i1; p2+=i2;
  }
}
static void ModUO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p1,'%',1,*(VALUE*)p2);
    p1+=i1; p2+=i2;
  }
}

na_func_t ModUFuncs =
{ TpErr, ModUB, ModUI, ModUL, ModUF, ModUD, TpErr, TpErr, ModUO };

/* ------------------------- ImgSet --------------------------- */
static void ImgSetX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((scomplex*)p1)->i = *(float*)p2;
    p1+=i1; p2+=i2;
  }
}
static void ImgSetC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((dcomplex*)p1)->i = *(double*)p2;
    p1+=i1; p2+=i2;
  }
}

na_func_t ImgSetFuncs =
{ TpErr, TpErr, TpErr, TpErr, TpErr, TpErr, ImgSetX, ImgSetC, TpErr };

/* ------------------------- Floor --------------------------- */
static void FloorF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = (int32_t)floor(*(float*)p2);
    p1+=i1; p2+=i2;
  }
}
static void FloorD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = (int32_t)floor(*(double*)p2);
    p1+=i1; p2+=i2;
  }
}

na_func_t FloorFuncs =
{ TpErr, SetBB, SetII, SetLL, FloorF, FloorD, TpErr, TpErr, TpErr };

/* ------------------------- Ceil --------------------------- */
static void CeilF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = (int32_t)ceil(*(float*)p2);
    p1+=i1; p2+=i2;
  }
}
static void CeilD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = (int32_t)ceil(*(double*)p2);
    p1+=i1; p2+=i2;
  }
}

na_func_t CeilFuncs =
{ TpErr, SetBB, SetII, SetLL, CeilF, CeilD, TpErr, TpErr, TpErr };

/* ------------------------- Round --------------------------- */
static void RoundF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (*(float*)p2 >= 0) *(int32_t*)p1 = (int32_t)floor(*(float*)p2+0.5);
     else *(int32_t*)p1 = (int32_t)ceil(*(float*)p2-0.5);
    p1+=i1; p2+=i2;
  }
}
static void RoundD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (*(double*)p2 >= 0) *(int32_t*)p1 = (int32_t)floor(*(double*)p2+0.5);
     else *(int32_t*)p1 = (int32_t)ceil(*(double*)p2-0.5);
    p1+=i1; p2+=i2;
  }
}

na_func_t RoundFuncs =
{ TpErr, SetBB, SetII, SetLL, RoundF, RoundD, TpErr, TpErr, TpErr };

/* ------------------------- Abs --------------------------- */
static void AbsB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = *(u_int8_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void AbsI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 = (*(int16_t*)p2<0) ? -*(int16_t*)p2 : *(int16_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void AbsL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = (*(int32_t*)p2<0) ? -*(int32_t*)p2 : *(int32_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void AbsF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = (*(float*)p2<0) ? -*(float*)p2 : *(float*)p2;
    p1+=i1; p2+=i2;
  }
}
static void AbsD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = (*(double*)p2<0) ? -*(double*)p2 : *(double*)p2;
    p1+=i1; p2+=i2;
  }
}
static void AbsX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = (float)hypot(((scomplex*)p2)->r, ((scomplex*)p2)->i);
    p1+=i1; p2+=i2;
  }
}
static void AbsC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = (double)hypot(((dcomplex*)p2)->r, ((dcomplex*)p2)->i);
    p1+=i1; p2+=i2;
  }
}
static void AbsO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p2,na_id_abs,0);
    p1+=i1; p2+=i2;
  }
}

na_func_t AbsFuncs =
{ TpErr, AbsB, AbsI, AbsL, AbsF, AbsD, AbsX, AbsC, AbsO };

/* ------------------------- Real --------------------------- */

na_func_t RealFuncs =
{ TpErr, SetBB, SetII, SetLL, SetFF, SetDD, SetFX, SetDC, TpErr };

/* ------------------------- Imag --------------------------- */
static void ImagB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = 0;
    p1+=i1; p2+=i2;
  }
}
static void ImagI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 = 0;
    p1+=i1; p2+=i2;
  }
}
static void ImagL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = 0;
    p1+=i1; p2+=i2;
  }
}
static void ImagF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = 0;
    p1+=i1; p2+=i2;
  }
}
static void ImagD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = 0;
    p1+=i1; p2+=i2;
  }
}
static void ImagX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = ((scomplex*)p2)->i;
    p1+=i1; p2+=i2;
  }
}
static void ImagC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = ((dcomplex*)p2)->i;
    p1+=i1; p2+=i2;
  }
}

na_func_t ImagFuncs =
{ TpErr, ImagB, ImagI, ImagL, ImagF, ImagD, ImagX, ImagC, TpErr };

/* ------------------------- Angl --------------------------- */
static void AnglX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = atan2(((scomplex*)p2)->i,((scomplex*)p2)->r);
    p1+=i1; p2+=i2;
  }
}
static void AnglC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = atan2(((dcomplex*)p2)->i,((dcomplex*)p2)->r);
    p1+=i1; p2+=i2;
  }
}

na_func_t AnglFuncs =
{ TpErr, TpErr, TpErr, TpErr, TpErr, TpErr, AnglX, AnglC, TpErr };

/* ------------------------- ImagMul --------------------------- */
static void ImagMulF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((scomplex*)p1)->r = 0; ((scomplex*)p1)->i = *(float*)p2;
    p1+=i1; p2+=i2;
  }
}
static void ImagMulD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r = 0; ((dcomplex*)p1)->i = *(double*)p2;
    p1+=i1; p2+=i2;
  }
}
static void ImagMulX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((scomplex*)p1)->r = -((scomplex*)p2)->i; ((scomplex*)p1)->i = ((scomplex*)p2)->r;
    p1+=i1; p2+=i2;
  }
}
static void ImagMulC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r = -((dcomplex*)p2)->i; ((dcomplex*)p1)->i = ((dcomplex*)p2)->r;
    p1+=i1; p2+=i2;
  }
}

na_func_t ImagMulFuncs =
{ TpErr, TpErr, TpErr, TpErr, ImagMulF, ImagMulD, ImagMulX, ImagMulC, TpErr };

/* ------------------------- Conj --------------------------- */
static void ConjX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((scomplex*)p1)->r = ((scomplex*)p2)->r; ((scomplex*)p1)->i = -((scomplex*)p2)->i;
    p1+=i1; p2+=i2;
  }
}
static void ConjC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r = ((dcomplex*)p2)->r; ((dcomplex*)p1)->i = -((dcomplex*)p2)->i;
    p1+=i1; p2+=i2;
  }
}

na_func_t ConjFuncs =
{ TpErr, SetBB, SetII, SetLL, SetFF, SetDD, ConjX, ConjC, TpErr };

/* ------------------------- Not --------------------------- */
static void NotB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(u_int8_t*)p2==0) ? 1:0;
    p1+=i1; p2+=i2;
  }
}
static void NotI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(int16_t*)p2==0) ? 1:0;
    p1+=i1; p2+=i2;
  }
}
static void NotL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(int32_t*)p2==0) ? 1:0;
    p1+=i1; p2+=i2;
  }
}
static void NotF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(float*)p2==0) ? 1:0;
    p1+=i1; p2+=i2;
  }
}
static void NotD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(double*)p2==0) ? 1:0;
    p1+=i1; p2+=i2;
  }
}
static void NotX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (((scomplex*)p2)->r==0 && ((scomplex*)p2)->i==0) ? 1:0;
    p1+=i1; p2+=i2;
  }
}
static void NotC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (((dcomplex*)p2)->r==0 && ((dcomplex*)p2)->i==0) ? 1:0;
    p1+=i1; p2+=i2;
  }
}
static void NotO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = RTEST(*(VALUE*)p2) ? 0:1;
    p1+=i1; p2+=i2;
  }
}

na_func_t NotFuncs =
{ TpErr, NotB, NotI, NotL, NotF, NotD, NotX, NotC, NotO };

/* ------------------------- BRv --------------------------- */
static void BRvB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = ~(*(u_int8_t*)p2);
    p1+=i1; p2+=i2;
  }
}
static void BRvI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 = ~(*(int16_t*)p2);
    p1+=i1; p2+=i2;
  }
}
static void BRvL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = ~(*(int32_t*)p2);
    p1+=i1; p2+=i2;
  }
}
static void BRvO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p2,'~',0);
    p1+=i1; p2+=i2;
  }
}

na_func_t BRvFuncs =
{ TpErr, BRvB, BRvI, BRvL, TpErr, TpErr, TpErr, TpErr, BRvO };

/* ------------------------- Min --------------------------- */
static void MinB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (*(u_int8_t*)p1>*(u_int8_t*)p2) *(u_int8_t*)p1=*(u_int8_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void MinI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (*(int16_t*)p1>*(int16_t*)p2) *(int16_t*)p1=*(int16_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void MinL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (*(int32_t*)p1>*(int32_t*)p2) *(int32_t*)p1=*(int32_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void MinF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (notnanF((float*)p2) && *(float*)p1>*(float*)p2) *(float*)p1=*(float*)p2;
    p1+=i1; p2+=i2;
  }
}
static void MinD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (notnanD((double*)p2) && *(double*)p1>*(double*)p2) *(double*)p1=*(double*)p2;
    p1+=i1; p2+=i2;
  }
}
static void MinO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (FIX2INT(rb_funcall(*(VALUE*)p1,na_id_compare,1,*(VALUE*)p2))>0) *(VALUE*)p1=*(VALUE*)p2;
    p1+=i1; p2+=i2;
  }
}

na_func_t MinFuncs =
{ TpErr, MinB, MinI, MinL, MinF, MinD, TpErr, TpErr, MinO };

/* ------------------------- Max --------------------------- */
static void MaxB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (*(u_int8_t*)p1<*(u_int8_t*)p2) *(u_int8_t*)p1=*(u_int8_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void MaxI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (*(int16_t*)p1<*(int16_t*)p2) *(int16_t*)p1=*(int16_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void MaxL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (*(int32_t*)p1<*(int32_t*)p2) *(int32_t*)p1=*(int32_t*)p2;
    p1+=i1; p2+=i2;
  }
}
static void MaxF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (notnanF((float*)p2) && *(float*)p1<*(float*)p2) *(float*)p1=*(float*)p2;
    p1+=i1; p2+=i2;
  }
}
static void MaxD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (notnanD((double*)p2) && *(double*)p1<*(double*)p2) *(double*)p1=*(double*)p2;
    p1+=i1; p2+=i2;
  }
}
static void MaxO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    if (FIX2INT(rb_funcall(*(VALUE*)p1,na_id_compare,1,*(VALUE*)p2))<0) *(VALUE*)p1=*(VALUE*)p2;
    p1+=i1; p2+=i2;
  }
}

na_func_t MaxFuncs =
{ TpErr, MaxB, MaxI, MaxL, MaxF, MaxD, TpErr, TpErr, MaxO };

/* ------------------------- Sort --------------------------- */
static int SortB(const void *p1, const void *p2)
{ if (*(u_int8_t*)p1 > *(u_int8_t*)p2) return 1;
  if (*(u_int8_t*)p1 < *(u_int8_t*)p2) return -1;
  return 0; }
static int SortI(const void *p1, const void *p2)
{ if (*(int16_t*)p1 > *(int16_t*)p2) return 1;
  if (*(int16_t*)p1 < *(int16_t*)p2) return -1;
  return 0; }
static int SortL(const void *p1, const void *p2)
{ if (*(int32_t*)p1 > *(int32_t*)p2) return 1;
  if (*(int32_t*)p1 < *(int32_t*)p2) return -1;
  return 0; }
static int SortF(const void *p1, const void *p2)
{ if (*(float*)p1 > *(float*)p2) return 1;
  if (*(float*)p1 < *(float*)p2) return -1;
  return 0; }
static int SortD(const void *p1, const void *p2)
{ if (*(double*)p1 > *(double*)p2) return 1;
  if (*(double*)p1 < *(double*)p2) return -1;
  return 0; }
static int SortO(const void *p1, const void *p2)
{ VALUE r = rb_funcall(*(VALUE*)p1, na_id_compare, 1, *(VALUE*)p2);
  return NUM2INT(r); }

na_sortfunc_t SortFuncs =
{ (int (*)(const void *, const void *))TpErrI, SortB, SortI, SortL, SortF, SortD, (int (*)(const void *, const void *))TpErrI, (int (*)(const void *, const void *))TpErrI, SortO };

/* ------------------------- SortIdx --------------------------- */
static int SortIdxB(const void *p1, const void *p2)
{ if (**(u_int8_t**)p1 > **(u_int8_t**)p2) return 1;
  if (**(u_int8_t**)p1 < **(u_int8_t**)p2) return -1;
  return 0; }
static int SortIdxI(const void *p1, const void *p2)
{ if (**(int16_t**)p1 > **(int16_t**)p2) return 1;
  if (**(int16_t**)p1 < **(int16_t**)p2) return -1;
  return 0; }
static int SortIdxL(const void *p1, const void *p2)
{ if (**(int32_t**)p1 > **(int32_t**)p2) return 1;
  if (**(int32_t**)p1 < **(int32_t**)p2) return -1;
  return 0; }
static int SortIdxF(const void *p1, const void *p2)
{ if (**(float**)p1 > **(float**)p2) return 1;
  if (**(float**)p1 < **(float**)p2) return -1;
  return 0; }
static int SortIdxD(const void *p1, const void *p2)
{ if (**(double**)p1 > **(double**)p2) return 1;
  if (**(double**)p1 < **(double**)p2) return -1;
  return 0; }
static int SortIdxO(const void *p1, const void *p2)
{ VALUE r = rb_funcall(**(VALUE**)p1, na_id_compare, 1, **(VALUE**)p2);
  return NUM2INT(r); }

na_sortfunc_t SortIdxFuncs =
{ (int (*)(const void *, const void *))TpErrI, SortIdxB, SortIdxI, SortIdxL, SortIdxF, SortIdxD, (int (*)(const void *, const void *))TpErrI, (int (*)(const void *, const void *))TpErrI, SortIdxO };

/* ------------------------- IndGen --------------------------- */
static void IndGenB(int n, char *p1, int i1, int p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (u_int8_t)p2;
    p1+=i1; p2+=i2;
  }
}
static void IndGenI(int n, char *p1, int i1, int p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 = (int16_t)p2;
    p1+=i1; p2+=i2;
  }
}
static void IndGenL(int n, char *p1, int i1, int p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = (int32_t)p2;
    p1+=i1; p2+=i2;
  }
}
static void IndGenF(int n, char *p1, int i1, int p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = (float)p2;
    p1+=i1; p2+=i2;
  }
}
static void IndGenD(int n, char *p1, int i1, int p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = (double)p2;
    p1+=i1; p2+=i2;
  }
}
static void IndGenX(int n, char *p1, int i1, int p2, int i2)
{
  for (; n; --n) {
    ((scomplex*)p1)->r = (float)p2;
   ((scomplex*)p1)->i = 0;
    p1+=i1; p2+=i2;
  }
}
static void IndGenC(int n, char *p1, int i1, int p2, int i2)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r = (double)p2;
   ((dcomplex*)p1)->i = 0;
    p1+=i1; p2+=i2;
  }
}
static void IndGenO(int n, char *p1, int i1, int p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = INT2FIX(p2);
    p1+=i1; p2+=i2;
  }
}

na_func_t IndGenFuncs =
{ TpErr, IndGenB, IndGenI, IndGenL, IndGenF, IndGenD, IndGenX, IndGenC, IndGenO };

/* ------------------------- ToStr --------------------------- */
static void ToStrB(int n, char *p1, int i1, char *p2, int i2)
{
  char buf[22];
  for (; n; --n) {
    sprintf(buf,"%i",(int)*(u_int8_t*)p2);
    *(VALUE*)p1 = rb_str_new2(buf);
    p1+=i1; p2+=i2;
  }
}
static void ToStrI(int n, char *p1, int i1, char *p2, int i2)
{
  char buf[22];
  for (; n; --n) {
    sprintf(buf,"%i",(int)*(int16_t*)p2);
    *(VALUE*)p1 = rb_str_new2(buf);
    p1+=i1; p2+=i2;
  }
}
static void ToStrL(int n, char *p1, int i1, char *p2, int i2)
{
  char buf[22];
  for (; n; --n) {
    sprintf(buf,"%i",(int)*(int32_t*)p2);
    *(VALUE*)p1 = rb_str_new2(buf);
    p1+=i1; p2+=i2;
  }
}
static void ToStrF(int n, char *p1, int i1, char *p2, int i2)
{
  char buf[24];
  for (; n; --n) {
    sprintf(buf,"%.5g",(double)*(float*)p2);
    *(VALUE*)p1 = rb_str_new2(buf);
    p1+=i1; p2+=i2;
  }
}
static void ToStrD(int n, char *p1, int i1, char *p2, int i2)
{
  char buf[24];
  for (; n; --n) {
    sprintf(buf,"%.8g",(double)*(double*)p2);
    *(VALUE*)p1 = rb_str_new2(buf);
    p1+=i1; p2+=i2;
  }
}
static void ToStrX(int n, char *p1, int i1, char *p2, int i2)
{
  char buf[50];
  for (; n; --n) {
    sprintf(buf,"%.5g%+.5gi",(double)((scomplex*)p2)->r,(double)((scomplex*)p2)->i);
    *(VALUE*)p1 = rb_str_new2(buf);
    p1+=i1; p2+=i2;
  }
}
static void ToStrC(int n, char *p1, int i1, char *p2, int i2)
{
  char buf[50];
  for (; n; --n) {
    sprintf(buf,"%.8g%+.8gi",(double)((dcomplex*)p2)->r,(double)((dcomplex*)p2)->i);
    *(VALUE*)p1 = rb_str_new2(buf);
    p1+=i1; p2+=i2;
  }
}
static void ToStrO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_obj_as_string(*(VALUE*)p2);
    p1+=i1; p2+=i2;
  }
}

na_func_t ToStrFuncs =
{ TpErr, ToStrB, ToStrI, ToStrL, ToStrF, ToStrD, ToStrX, ToStrC, ToStrO };

/* from numeric.c */
static void na_str_append_fp(char *buf)
{
  if (buf[0]=='-' || buf[0]=='+') ++buf;
  if (ISALPHA(buf[0])) return; /* NaN or Inf */
  if (strchr(buf, '.') == 0) {
      int   len = strlen(buf);
      char *ind = strchr(buf, 'e');
      if (ind) {
          memmove(ind+2, ind, len-(ind-buf)+1);
          ind[0] = '.';
	  ind[1] = '0';
      } else {
          strcat(buf, ".0");
      }
  }
}

/* ------------------------- Insp --------------------------- */
static void InspB(char *p1, char *p2)
{
  char buf[22];
  sprintf(buf,"%i",(int)*(u_int8_t*)p2);
  *(VALUE*)p1 = rb_str_new2(buf);
}
static void InspI(char *p1, char *p2)
{
  char buf[22];
  sprintf(buf,"%i",(int)*(int16_t*)p2);
  *(VALUE*)p1 = rb_str_new2(buf);
}
static void InspL(char *p1, char *p2)
{
  char buf[22];
  sprintf(buf,"%i",(int)*(int32_t*)p2);
  *(VALUE*)p1 = rb_str_new2(buf);
}
static void InspF(char *p1, char *p2)
{
  char buf[24];
  sprintf(buf,"%g",(double)*(float*)p2);
  na_str_append_fp(buf);
  *(VALUE*)p1 = rb_str_new2(buf);
}
static void InspD(char *p1, char *p2)
{
  char buf[24];
  sprintf(buf,"%g",(double)*(double*)p2);
  na_str_append_fp(buf);
  *(VALUE*)p1 = rb_str_new2(buf);
}
static void InspX(char *p1, char *p2)
{
  char buf[50], *b;
  sprintf(buf,"%g",(double)((scomplex*)p2)->r);
  na_str_append_fp(buf);
  b = buf+strlen(buf);
  sprintf(b,"%+g",(double)((scomplex*)p2)->i);
  na_str_append_fp(b);
  strcat(buf,"i");
  *(VALUE*)p1 = rb_str_new2(buf);
}
static void InspC(char *p1, char *p2)
{
  char buf[50], *b;
  sprintf(buf,"%g",(double)((dcomplex*)p2)->r);
  na_str_append_fp(buf);
  b = buf+strlen(buf);
  sprintf(b,"%+g",(double)((dcomplex*)p2)->i);
  na_str_append_fp(b);
  strcat(buf,"i");
  *(VALUE*)p1 = rb_str_new2(buf);
}
static void InspO(char *p1, char *p2)
{
  *(VALUE*)p1 = rb_inspect(*(VALUE*)p2);
}

na_func_t InspFuncs =
{ TpErr, InspB, InspI, InspL, InspF, InspD, InspX, InspC, InspO };

/* ------------------------- AddB --------------------------- */
static void AddBB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = *(u_int8_t*)p2 + *(u_int8_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void AddBI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int16_t*)p1 = *(int16_t*)p2 + *(int16_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void AddBL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int32_t*)p1 = *(int32_t*)p2 + *(int32_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void AddBF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(float*)p1 = *(float*)p2 + *(float*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void AddBD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 = *(double*)p2 + *(double*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void AddBX(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    ((scomplex*)p1)->r = ((scomplex*)p2)->r + ((scomplex*)p3)->r;
    ((scomplex*)p1)->i = ((scomplex*)p2)->i + ((scomplex*)p3)->i;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void AddBC(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r = ((dcomplex*)p2)->r + ((dcomplex*)p3)->r;
    ((dcomplex*)p1)->i = ((dcomplex*)p2)->i + ((dcomplex*)p3)->i;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void AddBO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p2,'+',1,*(VALUE*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_func_t AddBFuncs =
{ TpErr, AddBB, AddBI, AddBL, AddBF, AddBD, AddBX, AddBC, AddBO };

/* ------------------------- SbtB --------------------------- */
static void SbtBB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = *(u_int8_t*)p2 - *(u_int8_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void SbtBI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int16_t*)p1 = *(int16_t*)p2 - *(int16_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void SbtBL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int32_t*)p1 = *(int32_t*)p2 - *(int32_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void SbtBF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(float*)p1 = *(float*)p2 - *(float*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void SbtBD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 = *(double*)p2 - *(double*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void SbtBX(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    ((scomplex*)p1)->r = ((scomplex*)p2)->r - ((scomplex*)p3)->r;
    ((scomplex*)p1)->i = ((scomplex*)p2)->i - ((scomplex*)p3)->i;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void SbtBC(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    ((dcomplex*)p1)->r = ((dcomplex*)p2)->r - ((dcomplex*)p3)->r;
    ((dcomplex*)p1)->i = ((dcomplex*)p2)->i - ((dcomplex*)p3)->i;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void SbtBO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p2,'-',1,*(VALUE*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_func_t SbtBFuncs =
{ TpErr, SbtBB, SbtBI, SbtBL, SbtBF, SbtBD, SbtBX, SbtBC, SbtBO };

/* ------------------------- MulB --------------------------- */
static void MulBB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = *(u_int8_t*)p2 * *(u_int8_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulBI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int16_t*)p1 = *(int16_t*)p2 * *(int16_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulBL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int32_t*)p1 = *(int32_t*)p2 * *(int32_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulBF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(float*)p1 = *(float*)p2 * *(float*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulBD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 = *(double*)p2 * *(double*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulBX(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    scomplex x = *(scomplex*)p2;
    ((scomplex*)p1)->r = x.r*((scomplex*)p3)->r - x.i*((scomplex*)p3)->i;
    ((scomplex*)p1)->i = x.r*((scomplex*)p3)->i + x.i*((scomplex*)p3)->r;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulBC(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    dcomplex x = *(dcomplex*)p2;
    ((dcomplex*)p1)->r = x.r*((dcomplex*)p3)->r - x.i*((dcomplex*)p3)->i;
    ((dcomplex*)p1)->i = x.r*((dcomplex*)p3)->i + x.i*((dcomplex*)p3)->r;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulBO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p2,'*',1,*(VALUE*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_func_t MulBFuncs =
{ TpErr, MulBB, MulBI, MulBL, MulBF, MulBD, MulBX, MulBC, MulBO };

/* ------------------------- DivB --------------------------- */
static void DivBB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3==0) {na_zerodiv();};
    *(u_int8_t*)p1 = *(u_int8_t*)p2 / *(u_int8_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void DivBI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(int16_t*)p3==0) {na_zerodiv();};
    *(int16_t*)p1 = *(int16_t*)p2 / *(int16_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void DivBL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(int32_t*)p3==0) {na_zerodiv();};
    *(int32_t*)p1 = *(int32_t*)p2 / *(int32_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void DivBF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(float*)p1 = *(float*)p2 / *(float*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void DivBD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 = *(double*)p2 / *(double*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void DivBX(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    scomplex x = *(scomplex*)p2;
    float a = ((scomplex*)p3)->r*((scomplex*)p3)->r + ((scomplex*)p3)->i*((scomplex*)p3)->i;
    ((scomplex*)p1)->r = (x.r*((scomplex*)p3)->r + x.i*((scomplex*)p3)->i)/a;
    ((scomplex*)p1)->i = (x.i*((scomplex*)p3)->r - x.r*((scomplex*)p3)->i)/a;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void DivBC(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    dcomplex x = *(dcomplex*)p2;
    double a = ((dcomplex*)p3)->r*((dcomplex*)p3)->r + ((dcomplex*)p3)->i*((dcomplex*)p3)->i;
    ((dcomplex*)p1)->r = (x.r*((dcomplex*)p3)->r + x.i*((dcomplex*)p3)->i)/a;
    ((dcomplex*)p1)->i = (x.i*((dcomplex*)p3)->r - x.r*((dcomplex*)p3)->i)/a;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void DivBO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p2,'/',1,*(VALUE*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_func_t DivBFuncs =
{ TpErr, DivBB, DivBI, DivBL, DivBF, DivBD, DivBX, DivBC, DivBO };

/* ------------------------- ModB --------------------------- */
static void ModBB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3==0) {na_zerodiv();};
    *(u_int8_t*)p1 = *(u_int8_t*)p2 % *(u_int8_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void ModBI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(int16_t*)p3==0) {na_zerodiv();};
    *(int16_t*)p1 = *(int16_t*)p2 % *(int16_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void ModBL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(int32_t*)p3==0) {na_zerodiv();};
    *(int32_t*)p1 = *(int32_t*)p2 % *(int32_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void ModBF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(float*)p1 = fmod(*(float*)p2, *(float*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void ModBD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 = fmod(*(double*)p2, *(double*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void ModBO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p2,'%',1,*(VALUE*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_func_t ModBFuncs =
{ TpErr, ModBB, ModBI, ModBL, ModBF, ModBD, TpErr, TpErr, ModBO };

/* ------------------------- MulAdd --------------------------- */
static void MulAddB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 += *(u_int8_t*)p2 * *(u_int8_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulAddI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int16_t*)p1 += *(int16_t*)p2 * *(int16_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulAddL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int32_t*)p1 += *(int32_t*)p2 * *(int32_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulAddF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(float*)p1 += *(float*)p2 * *(float*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulAddD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 += *(double*)p2 * *(double*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulAddX(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    scomplex x = *(scomplex*)p2;
    ((scomplex*)p1)->r += x.r*((scomplex*)p3)->r - x.i*((scomplex*)p3)->i;
    ((scomplex*)p1)->i += x.r*((scomplex*)p3)->i + x.i*((scomplex*)p3)->r;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulAddC(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    dcomplex x = *(dcomplex*)p2;
    ((dcomplex*)p1)->r += x.r*((dcomplex*)p3)->r - x.i*((dcomplex*)p3)->i;
    ((dcomplex*)p1)->i += x.r*((dcomplex*)p3)->i + x.i*((dcomplex*)p3)->r;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulAddO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p1,'+',1,
    rb_funcall(*(VALUE*)p2,'*',1,*(VALUE*)p3));
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_func_t MulAddFuncs =
{ TpErr, MulAddB, MulAddI, MulAddL, MulAddF, MulAddD, MulAddX, MulAddC, MulAddO };

/* ------------------------- MulSbt --------------------------- */
static void MulSbtB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 -= *(u_int8_t*)p2 * *(u_int8_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulSbtI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int16_t*)p1 -= *(int16_t*)p2 * *(int16_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulSbtL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int32_t*)p1 -= *(int32_t*)p2 * *(int32_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulSbtF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(float*)p1 -= *(float*)p2 * *(float*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulSbtD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 -= *(double*)p2 * *(double*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulSbtX(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    scomplex x = *(scomplex*)p2;
    ((scomplex*)p1)->r -= x.r*((scomplex*)p3)->r - x.i*((scomplex*)p3)->i;
    ((scomplex*)p1)->i -= x.r*((scomplex*)p3)->i + x.i*((scomplex*)p3)->r;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulSbtC(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    dcomplex x = *(dcomplex*)p2;
    ((dcomplex*)p1)->r -= x.r*((dcomplex*)p3)->r - x.i*((dcomplex*)p3)->i;
    ((dcomplex*)p1)->i -= x.r*((dcomplex*)p3)->i + x.i*((dcomplex*)p3)->r;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void MulSbtO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p1,'-',1,
    rb_funcall(*(VALUE*)p2,'*',1,*(VALUE*)p3));
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_func_t MulSbtFuncs =
{ TpErr, MulSbtB, MulSbtI, MulSbtL, MulSbtF, MulSbtD, MulSbtX, MulSbtC, MulSbtO };

/* ------------------------- BAn --------------------------- */
static void BAnB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = *(u_int8_t*)p2 & *(u_int8_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void BAnI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int16_t*)p1 = *(int16_t*)p2 & *(int16_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void BAnL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int32_t*)p1 = *(int32_t*)p2 & *(int32_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void BAnO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p2,'&',1,*(VALUE*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_func_t BAnFuncs =
{ TpErr, BAnB, BAnI, BAnL, TpErr, TpErr, TpErr, TpErr, BAnO };

/* ------------------------- BOr --------------------------- */
static void BOrB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = *(u_int8_t*)p2 | *(u_int8_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void BOrI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int16_t*)p1 = *(int16_t*)p2 | *(int16_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void BOrL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int32_t*)p1 = *(int32_t*)p2 | *(int32_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void BOrO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p2,'|',1,*(VALUE*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_func_t BOrFuncs =
{ TpErr, BOrB, BOrI, BOrL, TpErr, TpErr, TpErr, TpErr, BOrO };

/* ------------------------- BXo --------------------------- */
static void BXoB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = *(u_int8_t*)p2 ^ *(u_int8_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void BXoI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int16_t*)p1 = *(int16_t*)p2 ^ *(int16_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void BXoL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int32_t*)p1 = *(int32_t*)p2 ^ *(int32_t*)p3;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void BXoO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p2,'^',1,*(VALUE*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_func_t BXoFuncs =
{ TpErr, BXoB, BXoI, BXoL, TpErr, TpErr, TpErr, TpErr, BXoO };

/* ------------------------- Eql --------------------------- */
static void EqlB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(u_int8_t*)p2==*(u_int8_t*)p3) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void EqlI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(int16_t*)p2==*(int16_t*)p3) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void EqlL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(int32_t*)p2==*(int32_t*)p3) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void EqlF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(float*)p2==*(float*)p3) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void EqlD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(double*)p2==*(double*)p3) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void EqlX(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (((scomplex*)p2)->r==((scomplex*)p3)->r) && (((scomplex*)p2)->i==((scomplex*)p3)->i) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void EqlC(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (((dcomplex*)p2)->r==((dcomplex*)p3)->r) && (((dcomplex*)p2)->i==((dcomplex*)p3)->i) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void EqlO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = RTEST(rb_equal(*(VALUE*)p2, *(VALUE*)p3)) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_func_t EqlFuncs =
{ TpErr, EqlB, EqlI, EqlL, EqlF, EqlD, EqlX, EqlC, EqlO };

/* ------------------------- Cmp --------------------------- */
static void CmpB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p2>*(u_int8_t*)p3) *(u_int8_t*)p1=1;
    else if (*(u_int8_t*)p2<*(u_int8_t*)p3) *(u_int8_t*)p1=2;
    else *(u_int8_t*)p1=0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void CmpI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(int16_t*)p2>*(int16_t*)p3) *(u_int8_t*)p1=1;
    else if (*(int16_t*)p2<*(int16_t*)p3) *(u_int8_t*)p1=2;
    else *(u_int8_t*)p1=0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void CmpL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(int32_t*)p2>*(int32_t*)p3) *(u_int8_t*)p1=1;
    else if (*(int32_t*)p2<*(int32_t*)p3) *(u_int8_t*)p1=2;
    else *(u_int8_t*)p1=0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void CmpF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(float*)p2>*(float*)p3) *(u_int8_t*)p1=1;
    else if (*(float*)p2<*(float*)p3) *(u_int8_t*)p1=2;
    else *(u_int8_t*)p1=0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void CmpD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(double*)p2>*(double*)p3) *(u_int8_t*)p1=1;
    else if (*(double*)p2<*(double*)p3) *(u_int8_t*)p1=2;
    else *(u_int8_t*)p1=0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void CmpO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    int v = NUM2INT(rb_funcall(*(VALUE*)p2,na_id_compare,1,*(VALUE*)p3));
    if (v>0) *(u_int8_t*)p1=1; else if (v<0) *(u_int8_t*)p1=2; else *(u_int8_t*)p1=0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_func_t CmpFuncs =
{ TpErr, CmpB, CmpI, CmpL, CmpF, CmpD, TpErr, TpErr, CmpO };

/* ------------------------- And --------------------------- */
static void AndB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(u_int8_t*)p2!=0 && *(u_int8_t*)p3!=0) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void AndI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(int16_t*)p2!=0 && *(int16_t*)p3!=0) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void AndL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(int32_t*)p2!=0 && *(int32_t*)p3!=0) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void AndF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(float*)p2!=0 && *(float*)p3!=0) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void AndD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(double*)p2!=0 && *(double*)p3!=0) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void AndX(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = ((((scomplex*)p2)->r!=0||((scomplex*)p2)->i!=0) && (((scomplex*)p3)->r!=0||((scomplex*)p3)->i!=0)) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void AndC(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = ((((dcomplex*)p2)->r!=0||((dcomplex*)p2)->i!=0) && (((dcomplex*)p3)->r!=0||((dcomplex*)p3)->i!=0)) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void AndO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (RTEST(*(VALUE*)p2) && RTEST(*(VALUE*)p3)) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_func_t AndFuncs =
{ TpErr, AndB, AndI, AndL, AndF, AndD, AndX, AndC, AndO };

/* ------------------------- Or_ --------------------------- */
static void Or_B(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(u_int8_t*)p2!=0 || *(u_int8_t*)p3!=0) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void Or_I(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(int16_t*)p2!=0 || *(int16_t*)p3!=0) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void Or_L(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(int32_t*)p2!=0 || *(int32_t*)p3!=0) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void Or_F(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(float*)p2!=0 || *(float*)p3!=0) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void Or_D(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (*(double*)p2!=0 || *(double*)p3!=0) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void Or_X(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = ((((scomplex*)p2)->r!=0||((scomplex*)p2)->i!=0) || (((scomplex*)p3)->r!=0||((scomplex*)p3)->i!=0)) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void Or_C(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = ((((dcomplex*)p2)->r!=0||((dcomplex*)p2)->i!=0) || (((dcomplex*)p3)->r!=0||((dcomplex*)p3)->i!=0)) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void Or_O(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (RTEST(*(VALUE*)p2) || RTEST(*(VALUE*)p3)) ? 1:0;
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_func_t Or_Funcs =
{ TpErr, Or_B, Or_I, Or_L, Or_F, Or_D, Or_X, Or_C, Or_O };

/* ------------------------- Xor --------------------------- */
static void XorB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = ((*(u_int8_t*)p2!=0) == (*(u_int8_t*)p3!=0)) ? 0:1;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void XorI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = ((*(int16_t*)p2!=0) == (*(int16_t*)p3!=0)) ? 0:1;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void XorL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = ((*(int32_t*)p2!=0) == (*(int32_t*)p3!=0)) ? 0:1;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void XorF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = ((*(float*)p2!=0) == (*(float*)p3!=0)) ? 0:1;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void XorD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = ((*(double*)p2!=0) == (*(double*)p3!=0)) ? 0:1;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void XorX(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = ((((scomplex*)p2)->r!=0||((scomplex*)p2)->i!=0) == (((scomplex*)p3)->r!=0||((scomplex*)p3)->i!=0)) ? 0:1;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void XorC(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = ((((dcomplex*)p2)->r!=0||((dcomplex*)p2)->i!=0) == (((dcomplex*)p3)->r!=0||((dcomplex*)p3)->i!=0)) ? 0:1;
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void XorO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = (RTEST(*(VALUE*)p2) == RTEST(*(VALUE*)p3)) ? 0:1;
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_func_t XorFuncs =
{ TpErr, XorB, XorI, XorL, XorF, XorD, XorX, XorC, XorO };

/* ------------------------- atan2 --------------------------- */
static void atan2F(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(float*)p1 = atan2(*(float*)p2, *(float*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void atan2D(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 = atan2(*(double*)p2, *(double*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_func_t atan2Funcs =
{ TpErr, TpErr, TpErr, TpErr, atan2F, atan2D, TpErr, TpErr, TpErr };

/* ------------------------- RefMask --------------------------- */
static void RefMaskB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3) { *(u_int8_t*)p1=*(u_int8_t*)p2; p1+=i1; }
    p3+=i3; p2+=i2;
  }
}
static void RefMaskI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3) { *(int16_t*)p1=*(int16_t*)p2; p1+=i1; }
    p3+=i3; p2+=i2;
  }
}
static void RefMaskL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3) { *(int32_t*)p1=*(int32_t*)p2; p1+=i1; }
    p3+=i3; p2+=i2;
  }
}
static void RefMaskF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3) { *(float*)p1=*(float*)p2; p1+=i1; }
    p3+=i3; p2+=i2;
  }
}
static void RefMaskD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3) { *(double*)p1=*(double*)p2; p1+=i1; }
    p3+=i3; p2+=i2;
  }
}
static void RefMaskX(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3) { *(scomplex*)p1=*(scomplex*)p2; p1+=i1; }
    p3+=i3; p2+=i2;
  }
}
static void RefMaskC(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3) { *(dcomplex*)p1=*(dcomplex*)p2; p1+=i1; }
    p3+=i3; p2+=i2;
  }
}
static void RefMaskO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3) { *(VALUE*)p1=*(VALUE*)p2; p1+=i1; }
    p3+=i3; p2+=i2;
  }
}

na_func_t RefMaskFuncs =
{ TpErr, RefMaskB, RefMaskI, RefMaskL, RefMaskF, RefMaskD, RefMaskX, RefMaskC, RefMaskO };

/* ------------------------- SetMask --------------------------- */
static void SetMaskB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3) { *(u_int8_t*)p1=*(u_int8_t*)p2; p2+=i2; }
    p3+=i3; p1+=i1;
  }
}
static void SetMaskI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3) { *(int16_t*)p1=*(int16_t*)p2; p2+=i2; }
    p3+=i3; p1+=i1;
  }
}
static void SetMaskL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3) { *(int32_t*)p1=*(int32_t*)p2; p2+=i2; }
    p3+=i3; p1+=i1;
  }
}
static void SetMaskF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3) { *(float*)p1=*(float*)p2; p2+=i2; }
    p3+=i3; p1+=i1;
  }
}
static void SetMaskD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3) { *(double*)p1=*(double*)p2; p2+=i2; }
    p3+=i3; p1+=i1;
  }
}
static void SetMaskX(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3) { *(scomplex*)p1=*(scomplex*)p2; p2+=i2; }
    p3+=i3; p1+=i1;
  }
}
static void SetMaskC(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3) { *(dcomplex*)p1=*(dcomplex*)p2; p2+=i2; }
    p3+=i3; p1+=i1;
  }
}
static void SetMaskO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    if (*(u_int8_t*)p3) { *(VALUE*)p1=*(VALUE*)p2; p2+=i2; }
    p3+=i3; p1+=i1;
  }
}

na_func_t SetMaskFuncs =
{ TpErr, SetMaskB, SetMaskI, SetMaskL, SetMaskF, SetMaskD, SetMaskX, SetMaskC, SetMaskO };
