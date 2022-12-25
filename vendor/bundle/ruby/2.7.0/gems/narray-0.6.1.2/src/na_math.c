/*
  na_math.c
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

#ifndef M_LOG2E
#define M_LOG2E         1.4426950408889634074
#endif
#ifndef M_LOG10E
#define M_LOG10E        0.43429448190325182765
#endif

VALUE rb_mNMath;

static void TpErr(void) {
    rb_raise(rb_eTypeError,"illegal operation with this type");
}

#if 0
void sincos(double x, double *s, double *c)
{
  *s=sin(x); *c=cos(x);
}

#ifndef HAVE_ACOSH
static double rb_log1p (const double x)
{
  double y;
  y = 1+x;

  if (y==1)
     return x;
  else
     return log(y)*(x/(y-1));
}

static double zero=0;

static double acosh(double x)
{
   /* acosh(x) = log(x+sqrt(x*x-1)) */
   if (x>2) {
      return log(2*x-1/(sqrt(x*x-1)+x));
   } else if (x>=1) {
      x-=1;
      return rb_log1p(x+sqrt(2*x+x*x));
   }
   return zero/(x-x); /* x<1: NaN */
}

static double asinh(double x)
{
   double a, x2;
   int neg;

   /* asinh(x) = log(x+sqrt(x*x+1)) */
   neg = x<0;
   if (neg) {x=-x;}
   x2 = x*x;

   if (x>2) {
      a = log(2*x+1/(x+sqrt(x2+1)));
   } else {
      a = rb_log1p(x+x2/(1+sqrt(x2+1)));
   }
   if (neg) {a=-a;}
   return a;
}

static double atanh(double x)
{
   double a, x2;
   int neg;

   /* atanh(x) = 0.5*log((1+x)/(1-x)) */
   neg = x<0;
   if (neg) {x=-x;}
   x2 = x*2;

   if (x<0.5) {
      a = 0.5*rb_log1p(x2+x2*x/(1-x));
   } else if (x<1) {
      a = 0.5*rb_log1p(x2/(1-x));
   } else if (x==1) {
      a = 1/zero;        /* Infinity */
   } else {
      return zero/(x-x); /* x>1: NaN */
   }
   if (neg) {a=-a;}
   return a;
}
#endif
#endif

static void squareX(scomplex *x) {
  float r=x->r;
  x->r = r*r - x->i*x->i;
  x->i = 2*r*x->i;
}

static void squareC(dcomplex *x) {
  double r=x->r;
  x->r = r*r - x->i*x->i;
  x->i = 2*r*x->i;
}


static void mulX(scomplex *x, scomplex *y) {
  scomplex z=*x;
  x->r = z.r*y->r - z.i*y->i;
  x->i = z.r*y->i + z.i*y->r;
}

static void mulC(dcomplex *x, dcomplex *y) {
  dcomplex z=*x;
  x->r = z.r*y->r - z.i*y->i;
  x->i = z.r*y->i + z.i*y->r;
}


static void divX(scomplex *p1, scomplex *p2) {
  scomplex x = *p1;
  float    a = p2->r*p2->r + p2->i*p2->i;
  p1->r = (x.r*p2->r + x.i*p2->i)/a;
  p1->i = (x.i*p2->r - x.r*p2->i)/a;
}

static void divC(dcomplex *p1, dcomplex *p2) {
  dcomplex x = *p1;
  double   a = p2->r*p2->r + p2->i*p2->i;
  p1->r = (x.r*p2->r + x.i*p2->i)/a;
  p1->i = (x.i*p2->r - x.r*p2->i)/a;
}


static scomplex recipX(scomplex *z)
{
  scomplex r;
  float    n;

  if ( (z->r<0 ? -z->r:z->r) > (z->i<0 ? -z->i:z->i) ) {
    r.i  = z->i/z->r;
    n    = (1+r.i*r.i)*z->r;
    r.r  = 1/n;
    r.i /= -n;
  } else {
    r.r  = z->r/z->i;
    n    = (1+r.r*r.r)*z->i;
    r.r /= n;
    r.i  = -1/n;
  }
  return r;
}

static dcomplex recipC(dcomplex *z)
{
  dcomplex r;
  double   n;

  if ( (z->r<0 ? -z->r:z->r) > (z->i<0 ? -z->i:z->i) ) {
    r.i  = z->i/z->r;
    n    = (1+r.i*r.i)*z->r;
    r.r  = 1/n;
    r.i /= -n;
  } else {
    r.r  = z->r/z->i;
    n    = (1+r.r*r.r)*z->i;
    r.r /= n;
    r.i  = -1/n;
  }
  return r;
}


static int powInt(int x, int p)
{
  int r=1;

  switch(p) {
  case 2: return x*x;
  case 3: return x*x*x;
  case 1: return x;
  case 0: return 1;
  }
  if (p<0)  return 0;
  /* if(p>3) */	
  while (p) {
    if ( (p%2) == 1 ) r *= x;
    x *= x;
    p /= 2;
  }
  return r;
}


static float powFi(float x, int p)
{
  float r=1;

  switch(p) {
  case 2: return x*x;
  case 3: return x*x*x;
  case 1: return x;
  case 0: return 1;
  }
  if (p<0)  return 1/powFi(x,-p);
  /* if(p>3) */	
  while (p) {
    if ( (p%2) == 1 ) r *= x;
    x *= x;
    p /= 2;
  }
  return r;
}


static double powDi(double x, int p)
{
  double r=1;

  switch(p) {
  case 2: return x*x;
  case 3: return x*x*x;
  case 1: return x;
  case 0: return 1;
  }
  if (p<0)  return 1/powDi(x,-p);
  /* if(p>3) */	
  while (p) {
    if ( (p%2) == 1 ) r *= x;
    x *= x;
    p /= 2;
  }
  return r;
}


static scomplex powXi(scomplex *x, int p)
{
  scomplex y=*x, r={1,0};

  if (p==2) { squareX(&y); return y; }
  if (p==1) { return y; }
  if (p==0) { return r; }
  if (p<0) {
    y = powXi(x,-p);
    return recipX(&y);
  }
  /* if (p>2) */
  while (p) {
    if ( (p%2) == 1 ) mulX(&r,&y);
    squareX(&y);
    p /= 2;
  }
  return r;
}

static dcomplex powCi(dcomplex *x, int p)
{
  dcomplex y=*x, r={1,0};

  if (p==2) { squareC(&y); return y; }
  if (p==1) { return y; }
  if (p==0) { return r; }
  if (p<0) {
    y = powCi(x,-p);
    return recipC(&y);
  }
  /* if (p>2) */
  while (p) {
    if ( (p%2) == 1 ) mulC(&r,&y);
    squareC(&y);
    p /= 2;
  }
  return r;
}



/* ------------------------- sqrt --------------------------- */
static void sqrtF(void *p1, void *p2){ *(float*)p1 = sqrt(*(float*)p2); }
static void sqrtD(void *p1, void *p2){ *(double*)p1 = sqrt(*(double*)p2); }
static void sqrtX(void *p1, void *p2){
  float xr=((scomplex*)p2)->r/2, xi=((scomplex*)p2)->i/2, r=hypot(xr,xi);
  if (xr>0) {
    ((scomplex*)p1)->r = sqrt(r+xr);
    ((scomplex*)p1)->i = xi/((scomplex*)p1)->r;
  } else if ( (r-=xr) ) {
    ((scomplex*)p1)->i = (xi>=0) ? sqrt(r):-sqrt(r);
    ((scomplex*)p1)->r = xi/((scomplex*)p1)->i;
  } else {
    ((scomplex*)p1)->r = ((scomplex*)p1)->i = 0;
  }
}
static void sqrtC(void *p1, void *p2){
  double xr=((dcomplex*)p2)->r/2, xi=((dcomplex*)p2)->i/2, r=hypot(xr,xi);
  if (xr>0) {
    ((dcomplex*)p1)->r = sqrt(r+xr);
    ((dcomplex*)p1)->i = xi/((dcomplex*)p1)->r;
  } else if ( (r-=xr) ) {
    ((dcomplex*)p1)->i = (xi>=0) ? sqrt(r):-sqrt(r);
    ((dcomplex*)p1)->r = xi/((dcomplex*)p1)->i;
  } else {
    ((dcomplex*)p1)->r = ((dcomplex*)p1)->i = 0;
  }
}

na_mathfunc_t sqrtFuncs =
{ TpErr, TpErr, TpErr, TpErr, sqrtF, sqrtD, sqrtX, sqrtC, TpErr };

/* ------------------------- sin --------------------------- */
static void sinF(void *p1, void *p2){ *(float*)p1 = sin(*(float*)p2); }
static void sinD(void *p1, void *p2){ *(double*)p1 = sin(*(double*)p2); }
static void sinX(void *p1, void *p2){
  ((scomplex*)p1)->r = sin(((scomplex*)p2)->r)*cosh(((scomplex*)p2)->i);
  ((scomplex*)p1)->i = cos(((scomplex*)p2)->r)*sinh(((scomplex*)p2)->i); }
static void sinC(void *p1, void *p2){
  ((dcomplex*)p1)->r = sin(((dcomplex*)p2)->r)*cosh(((dcomplex*)p2)->i);
  ((dcomplex*)p1)->i = cos(((dcomplex*)p2)->r)*sinh(((dcomplex*)p2)->i); }

na_mathfunc_t sinFuncs =
{ TpErr, TpErr, TpErr, TpErr, sinF, sinD, sinX, sinC, TpErr };

/* ------------------------- cos --------------------------- */
static void cosF(void *p1, void *p2){ *(float*)p1 = cos(*(float*)p2); }
static void cosD(void *p1, void *p2){ *(double*)p1 = cos(*(double*)p2); }
static void cosX(void *p1, void *p2){
  ((scomplex*)p1)->r = cos(((scomplex*)p2)->r)*cosh(((scomplex*)p2)->i);
  ((scomplex*)p1)->i = -sin(((scomplex*)p2)->r)*sinh(((scomplex*)p2)->i); }
static void cosC(void *p1, void *p2){
  ((dcomplex*)p1)->r = cos(((dcomplex*)p2)->r)*cosh(((dcomplex*)p2)->i);
  ((dcomplex*)p1)->i = -sin(((dcomplex*)p2)->r)*sinh(((dcomplex*)p2)->i); }

na_mathfunc_t cosFuncs =
{ TpErr, TpErr, TpErr, TpErr, cosF, cosD, cosX, cosC, TpErr };

/* ------------------------- tan --------------------------- */
static void tanF(void *p1, void *p2){ *(float*)p1 = tan(*(float*)p2); }
static void tanD(void *p1, void *p2){ *(double*)p1 = tan(*(double*)p2); }
static void tanX(void *p1, void *p2){
  float d, th;
  ((scomplex*)p1)->i = th = tanh(2*((scomplex*)p2)->i);
  ((scomplex*)p1)->r = sqrt(1-th*th); /* sech */
  d  = 1 + cos(2*((scomplex*)p2)->r) * ((scomplex*)p1)->r;
  ((scomplex*)p1)->r *= sin(2*((scomplex*)p2)->r)/d;
  ((scomplex*)p1)->i /= d;
}
static void tanC(void *p1, void *p2){
  double d, th;
  ((dcomplex*)p1)->i = th = tanh(2*((dcomplex*)p2)->i);
  ((dcomplex*)p1)->r = sqrt(1-th*th); /* sech */
  d  = 1 + cos(2*((dcomplex*)p2)->r) * ((dcomplex*)p1)->r;
  ((dcomplex*)p1)->r *= sin(2*((dcomplex*)p2)->r)/d;
  ((dcomplex*)p1)->i /= d;
}

na_mathfunc_t tanFuncs =
{ TpErr, TpErr, TpErr, TpErr, tanF, tanD, tanX, tanC, TpErr };

/* ------------------------- sinh --------------------------- */
static void sinhF(void *p1, void *p2){ *(float*)p1 = sinh(*(float*)p2); }
static void sinhD(void *p1, void *p2){ *(double*)p1 = sinh(*(double*)p2); }
static void sinhX(void *p1, void *p2){
  ((scomplex*)p1)->r = sinh(((scomplex*)p2)->r)*cos(((scomplex*)p2)->i);
  ((scomplex*)p1)->i = cosh(((scomplex*)p2)->r)*sin(((scomplex*)p2)->i);
}
static void sinhC(void *p1, void *p2){
  ((dcomplex*)p1)->r = sinh(((dcomplex*)p2)->r)*cos(((dcomplex*)p2)->i);
  ((dcomplex*)p1)->i = cosh(((dcomplex*)p2)->r)*sin(((dcomplex*)p2)->i);
}

na_mathfunc_t sinhFuncs =
{ TpErr, TpErr, TpErr, TpErr, sinhF, sinhD, sinhX, sinhC, TpErr };

/* ------------------------- cosh --------------------------- */
static void coshF(void *p1, void *p2){ *(float*)p1 = cosh(*(float*)p2); }
static void coshD(void *p1, void *p2){ *(double*)p1 = cosh(*(double*)p2); }
static void coshX(void *p1, void *p2){
  ((scomplex*)p1)->r = cosh(((scomplex*)p2)->r)*cos(((scomplex*)p2)->i);
  ((scomplex*)p1)->i = sinh(((scomplex*)p2)->r)*sin(((scomplex*)p2)->i);
}
static void coshC(void *p1, void *p2){
  ((dcomplex*)p1)->r = cosh(((dcomplex*)p2)->r)*cos(((dcomplex*)p2)->i);
  ((dcomplex*)p1)->i = sinh(((dcomplex*)p2)->r)*sin(((dcomplex*)p2)->i);
}

na_mathfunc_t coshFuncs =
{ TpErr, TpErr, TpErr, TpErr, coshF, coshD, coshX, coshC, TpErr };

/* ------------------------- tanh --------------------------- */
static void tanhF(void *p1, void *p2){ *(float*)p1 = tanh(*(float*)p2); }
static void tanhD(void *p1, void *p2){ *(double*)p1 = tanh(*(double*)p2); }
static void tanhX(void *p1, void *p2){
  float d, th;
  ((scomplex*)p1)->r = th = tanh(2*((scomplex*)p2)->r);
  ((scomplex*)p1)->i = sqrt(1-th*th); /* sech */
  d  = 1 + cos(2*((scomplex*)p2)->i) * ((scomplex*)p1)->i;
  ((scomplex*)p1)->r /= d;
  ((scomplex*)p1)->i *= sin(2*((scomplex*)p2)->i)/d;
}
static void tanhC(void *p1, void *p2){
  double d, th;
  ((dcomplex*)p1)->r = th = tanh(2*((dcomplex*)p2)->r);
  ((dcomplex*)p1)->i = sqrt(1-th*th); /* sech */
  d  = 1 + cos(2*((dcomplex*)p2)->i) * ((dcomplex*)p1)->i;
  ((dcomplex*)p1)->r /= d;
  ((dcomplex*)p1)->i *= sin(2*((dcomplex*)p2)->i)/d;
}

na_mathfunc_t tanhFuncs =
{ TpErr, TpErr, TpErr, TpErr, tanhF, tanhD, tanhX, tanhC, TpErr };

/* ------------------------- exp --------------------------- */
static void expF(void *p1, void *p2){ *(float*)p1 = exp(*(float*)p2); }
static void expD(void *p1, void *p2){ *(double*)p1 = exp(*(double*)p2); }
static void expX(void *p1, void *p2){
  float a = exp(((scomplex*)p2)->r);
  ((scomplex*)p1)->r = a*cos(((scomplex*)p2)->i);
  ((scomplex*)p1)->i = a*sin(((scomplex*)p2)->i);
}
static void expC(void *p1, void *p2){
  double a = exp(((dcomplex*)p2)->r);
  ((dcomplex*)p1)->r = a*cos(((dcomplex*)p2)->i);
  ((dcomplex*)p1)->i = a*sin(((dcomplex*)p2)->i);
}

na_mathfunc_t expFuncs =
{ TpErr, TpErr, TpErr, TpErr, expF, expD, expX, expC, TpErr };

/* ------------------------- log --------------------------- */
static void logF(void *p1, void *p2){ *(float*)p1 = log(*(float*)p2); }
static void logD(void *p1, void *p2){ *(double*)p1 = log(*(double*)p2); }
static void logX(void *p1, void *p2){
  scomplex x = *(scomplex*)p2;
  ((scomplex*)p1)->r = log(hypot(x.r, x.i));
  ((scomplex*)p1)->i = atan2(x.i, x.r);
}
static void logC(void *p1, void *p2){
  dcomplex x = *(dcomplex*)p2;
  ((dcomplex*)p1)->r = log(hypot(x.r, x.i));
  ((dcomplex*)p1)->i = atan2(x.i, x.r);
}

na_mathfunc_t logFuncs =
{ TpErr, TpErr, TpErr, TpErr, logF, logD, logX, logC, TpErr };

/* ------------------------- log10 --------------------------- */
static void log10F(void *p1, void *p2){ *(float*)p1 = log10(*(float*)p2); }
static void log10D(void *p1, void *p2){ *(double*)p1 = log10(*(double*)p2); }
static void log10X(void *p1, void *p2){
  logX(p1,p2);
  ((scomplex*)p1)->r *= (float)M_LOG10E;
  ((scomplex*)p1)->i *= (float)M_LOG10E;
}
static void log10C(void *p1, void *p2){
  logC(p1,p2);
  ((dcomplex*)p1)->r *= (double)M_LOG10E;
  ((dcomplex*)p1)->i *= (double)M_LOG10E;
}

na_mathfunc_t log10Funcs =
{ TpErr, TpErr, TpErr, TpErr, log10F, log10D, log10X, log10C, TpErr };

/* ------------------------- log2 --------------------------- */
static void log2F(void *p1, void *p2){ *(float*)p1 = log(*(float*)p2)*M_LOG2E; }
static void log2D(void *p1, void *p2){ *(double*)p1 = log(*(double*)p2)*M_LOG2E; }
static void log2X(void *p1, void *p2){
  logX(p1,p2);
  ((scomplex*)p1)->r *= (float)M_LOG2E;
  ((scomplex*)p1)->i *= (float)M_LOG2E;
}
static void log2C(void *p1, void *p2){
  logC(p1,p2);
  ((dcomplex*)p1)->r *= (double)M_LOG2E;
  ((dcomplex*)p1)->i *= (double)M_LOG2E;
}

na_mathfunc_t log2Funcs =
{ TpErr, TpErr, TpErr, TpErr, log2F, log2D, log2X, log2C, TpErr };

/* ------------------------- asin --------------------------- */
static void asinF(void *p1, void *p2){ *(float*)p1 = asin(*(float*)p2); }
static void asinD(void *p1, void *p2){ *(double*)p1 = asin(*(double*)p2); }
static void asinX(void *p1, void *p2){
  scomplex x = *(scomplex*)p2;
  squareX(&x);
  x.r = 1 - x.r;
  x.i =   - x.i;
  sqrtX(&x,&x);
  x.r -= ((scomplex*)p2)->i;
  x.i += ((scomplex*)p2)->r;
  logX(&x,&x);
  ((scomplex*)p1)->r =  x.i;
  ((scomplex*)p1)->i = -x.r;
}
static void asinC(void *p1, void *p2){
  dcomplex x = *(dcomplex*)p2;
  squareC(&x);
  x.r = 1 - x.r;
  x.i =   - x.i;
  sqrtC(&x,&x);
  x.r -= ((dcomplex*)p2)->i;
  x.i += ((dcomplex*)p2)->r;
  logC(&x,&x);
  ((dcomplex*)p1)->r =  x.i;
  ((dcomplex*)p1)->i = -x.r;
}

na_mathfunc_t asinFuncs =
{ TpErr, TpErr, TpErr, TpErr, asinF, asinD, asinX, asinC, TpErr };

/* ------------------------- asinh --------------------------- */
static void asinhF(void *p1, void *p2){ *(float*)p1 = asinh(*(float*)p2); }
static void asinhD(void *p1, void *p2){ *(double*)p1 = asinh(*(double*)p2); }
static void asinhX(void *p1, void *p2){
  scomplex x = *(scomplex*)p2;
  squareX(&x);
  x.r += 1;
  sqrtX(&x,&x);
  x.r += ((scomplex*)p2)->r;
  x.i += ((scomplex*)p2)->i;
  logX(p1,&x);
}
static void asinhC(void *p1, void *p2){
  dcomplex x = *(dcomplex*)p2;
  squareC(&x);
  x.r += 1;
  sqrtC(&x,&x);
  x.r += ((dcomplex*)p2)->r;
  x.i += ((dcomplex*)p2)->i;
  logC(p1,&x);
}

na_mathfunc_t asinhFuncs =
{ TpErr, TpErr, TpErr, TpErr, asinhF, asinhD, asinhX, asinhC, TpErr };

/* ------------------------- acos --------------------------- */
static void acosF(void *p1, void *p2){ *(float*)p1 = acos(*(float*)p2); }
static void acosD(void *p1, void *p2){ *(double*)p1 = acos(*(double*)p2); }
static void acosX(void *p1, void *p2){
  scomplex x = *(scomplex*)p2;
  float tmp;
  squareX(&x);
  x.r = 1 - x.r;
  x.i =   - x.i;
  sqrtX(&x,&x);
  tmp =  x.r + ((scomplex*)p2)->i;
  x.r = -x.i + ((scomplex*)p2)->r;
  x.i = tmp;
  logX(&x,&x);
  ((scomplex*)p1)->r =  x.i;
  ((scomplex*)p1)->i = -x.r;
}
static void acosC(void *p1, void *p2){
  dcomplex x = *(dcomplex*)p2;
  double tmp;
  squareC(&x);
  x.r = 1 - x.r;
  x.i =   - x.i;
  sqrtC(&x,&x);
  tmp =  x.r + ((dcomplex*)p2)->i;
  x.r = -x.i + ((dcomplex*)p2)->r;
  x.i = tmp;
  logC(&x,&x);
  ((dcomplex*)p1)->r =  x.i;
  ((dcomplex*)p1)->i = -x.r;
}

na_mathfunc_t acosFuncs =
{ TpErr, TpErr, TpErr, TpErr, acosF, acosD, acosX, acosC, TpErr };

/* ------------------------- acosh --------------------------- */
static void acoshF(void *p1, void *p2){ *(float*)p1 = acosh(*(float*)p2); }
static void acoshD(void *p1, void *p2){ *(double*)p1 = acosh(*(double*)p2); }
static void acoshX(void *p1, void *p2){
  scomplex x = *(scomplex*)p2;
  squareX(&x);
  x.r -= 1;
  sqrtX(&x,&x);
  x.r += ((scomplex*)p2)->r;
  x.i += ((scomplex*)p2)->i;
  logX(p1,&x);
}
static void acoshC(void *p1, void *p2){
  dcomplex x = *(dcomplex*)p2;
  squareC(&x);
  x.r -= 1;
  sqrtC(&x,&x);
  x.r += ((dcomplex*)p2)->r;
  x.i += ((dcomplex*)p2)->i;
  logC(p1,&x);
}

na_mathfunc_t acoshFuncs =
{ TpErr, TpErr, TpErr, TpErr, acoshF, acoshD, acoshX, acoshC, TpErr };

/* ------------------------- atan --------------------------- */
static void atanF(void *p1, void *p2){ *(float*)p1 = atan(*(float*)p2); }
static void atanD(void *p1, void *p2){ *(double*)p1 = atan(*(double*)p2); }
static void atanX(void *p1, void *p2){
  scomplex x,y;
  x.r=-((scomplex*)p2)->r; x.i=1-((scomplex*)p2)->i;
  y.r= ((scomplex*)p2)->r; y.i=1+((scomplex*)p2)->i;
  divX((void*)&y,(void*)&x);
  logX((void*)&x,(void*)&y);
  ((scomplex*)p1)->r = -x.i/2;
  ((scomplex*)p1)->i =  x.r/2;
}
static void atanC(void *p1, void *p2){
  dcomplex x,y;
  x.r=-((dcomplex*)p2)->r; x.i=1-((dcomplex*)p2)->i;
  y.r= ((dcomplex*)p2)->r; y.i=1+((dcomplex*)p2)->i;
  divC((void*)&y,(void*)&x);
  logC((void*)&x,(void*)&y);
  ((dcomplex*)p1)->r = -x.i/2;
  ((dcomplex*)p1)->i =  x.r/2;
}

na_mathfunc_t atanFuncs =
{ TpErr, TpErr, TpErr, TpErr, atanF, atanD, atanX, atanC, TpErr };

/* ------------------------- atanh --------------------------- */
static void atanhF(void *p1, void *p2){ *(float*)p1 = atanh(*(float*)p2); }
static void atanhD(void *p1, void *p2){ *(double*)p1 = atanh(*(double*)p2); }
static void atanhX(void *p1, void *p2){
  scomplex x,y;
  x.r=1-((scomplex*)p2)->r; x.i=-((scomplex*)p2)->i;
  y.r=1+((scomplex*)p2)->r; y.i= ((scomplex*)p2)->i;
  divX((void*)&y,(void*)&x);
  logX((void*)&x,(void*)&y);
  ((scomplex*)p1)->r = x.r/2;
  ((scomplex*)p1)->i = x.i/2;
}
static void atanhC(void *p1, void *p2){
  dcomplex x,y;
  x.r=1-((dcomplex*)p2)->r; x.i=-((dcomplex*)p2)->i;
  y.r=1+((dcomplex*)p2)->r; y.i= ((dcomplex*)p2)->i;
  divC((void*)&y,(void*)&x);
  logC((void*)&x,(void*)&y);
  ((dcomplex*)p1)->r = x.r/2;
  ((dcomplex*)p1)->i = x.i/2;
}

na_mathfunc_t atanhFuncs =
{ TpErr, TpErr, TpErr, TpErr, atanhF, atanhD, atanhX, atanhC, TpErr };

/* ------------------------- Rcp --------------------------- */
static void RcpB(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = 1/(*(u_int8_t*)p2);
    p1+=i1; p2+=i2;
  }
}
static void RcpI(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int16_t*)p1 = 1/(*(int16_t*)p2);
    p1+=i1; p2+=i2;
  }
}
static void RcpL(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(int32_t*)p1 = 1/(*(int32_t*)p2);
    p1+=i1; p2+=i2;
  }
}
static void RcpF(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(float*)p1 = 1/(*(float*)p2);
    p1+=i1; p2+=i2;
  }
}
static void RcpD(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(double*)p1 = 1/(*(double*)p2);
    p1+=i1; p2+=i2;
  }
}
static void RcpX(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(scomplex*)p1 = recipX((scomplex*)p2);
    p1+=i1; p2+=i2;
  }
}
static void RcpC(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(dcomplex*)p1 = recipC((dcomplex*)p2);
    p1+=i1; p2+=i2;
  }
}
static void RcpO(int n, char *p1, int i1, char *p2, int i2)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(INT2FIX(1),na_id_div,1,*(VALUE*)p2);
    p1+=i1; p2+=i2;
  }
}

na_func_t RcpFuncs =
{ TpErr, RcpB, RcpI, RcpL, RcpF, RcpD, RcpX, RcpC, RcpO };

/* ------------------------- Pow --------------------------- */
static void PowBB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(u_int8_t*)p1 = powInt(*(u_int8_t*)p2,*(u_int8_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowBI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int16_t*)p1 = powInt(*(u_int8_t*)p2,*(int16_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowBL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int32_t*)p1 = powInt(*(u_int8_t*)p2,*(int32_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowBF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(float*)p1 = pow(*(u_int8_t*)p2,*(float*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowBD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 = pow(*(u_int8_t*)p2,*(double*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowIB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int16_t*)p1 = powInt(*(int16_t*)p2,*(u_int8_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowII(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int16_t*)p1 = powInt(*(int16_t*)p2,*(int16_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowIL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int32_t*)p1 = powInt(*(int16_t*)p2,*(int32_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowIF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(float*)p1 = pow(*(int16_t*)p2,*(float*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowID(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 = pow(*(int16_t*)p2,*(double*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowLB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int32_t*)p1 = powInt(*(int32_t*)p2,*(u_int8_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowLI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int32_t*)p1 = powInt(*(int32_t*)p2,*(int16_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowLL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(int32_t*)p1 = powInt(*(int32_t*)p2,*(int32_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowLF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(float*)p1 = pow(*(int32_t*)p2,*(float*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowLD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 = pow(*(int32_t*)p2,*(double*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowFB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(float*)p1 = powFi(*(float*)p2,*(u_int8_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowFI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(float*)p1 = powFi(*(float*)p2,*(int16_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowFL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(float*)p1 = powFi(*(float*)p2,*(int32_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowFF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(float*)p1 = pow(*(float*)p2,*(float*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowFD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 = pow(*(float*)p2,*(double*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowDB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 = powDi(*(double*)p2,*(u_int8_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowDI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 = powDi(*(double*)p2,*(int16_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowDL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 = powDi(*(double*)p2,*(int32_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowDF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 = pow(*(double*)p2,*(float*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowDD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(double*)p1 = pow(*(double*)p2,*(double*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowXB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(scomplex*)p1 = powXi((scomplex*)p2,*(u_int8_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowXI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(scomplex*)p1 = powXi((scomplex*)p2,*(int16_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowXL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(scomplex*)p1 = powXi((scomplex*)p2,*(int32_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowXF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    scomplex r;
    if (*(float*)p3==0)
    { ((scomplex*)p1)->r=1; ((scomplex*)p1)->i=0; } else
    if (((scomplex*)p2)->r==0 && ((scomplex*)p2)->i==0 && *(float*)p3>0)
    { ((scomplex*)p1)->r=0; ((scomplex*)p1)->i=0; } else {
    logX(&r, p2);
    r.r *= *(float*)p3;
    r.i *= *(float*)p3;
    expX(p1, &r); }
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowXD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    scomplex r;
    if (*(double*)p3==0)
    { ((dcomplex*)p1)->r=1; ((dcomplex*)p1)->i=0; } else
    if (((scomplex*)p2)->r==0 && ((scomplex*)p2)->i==0 && *(double*)p3>0)
    { ((dcomplex*)p1)->r=0; ((dcomplex*)p1)->i=0; } else {
    logX(&r, p2);
    r.r *= *(double*)p3;
    r.i *= *(double*)p3;
    expX(p1, &r); }
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowXX(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    scomplex l, r;
    if (((scomplex*)p3)->r==0 && ((scomplex*)p3)->i==0)
    { ((scomplex*)p1)->r=1; ((scomplex*)p1)->i=0; } else
    if (((scomplex*)p2)->r==0 && ((scomplex*)p2)->i==0 && ((scomplex*)p3)->r>0 && ((scomplex*)p3)->i==0)
    { ((scomplex*)p1)->r=0; ((scomplex*)p1)->i=0; } else {
    logX(&l, p2);
    r.r = ((scomplex*)p3)->r * l.r - ((scomplex*)p3)->i * l.i;
    r.i = ((scomplex*)p3)->r * l.i + ((scomplex*)p3)->i * l.r;
    expX(p1, &r); }
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowXC(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    scomplex l, r;
    if (((dcomplex*)p3)->r==0 && ((dcomplex*)p3)->i==0)
    { ((dcomplex*)p1)->r=1; ((dcomplex*)p1)->i=0; } else
    if (((scomplex*)p2)->r==0 && ((scomplex*)p2)->i==0 && ((dcomplex*)p3)->r>0 && ((dcomplex*)p3)->i==0)
    { ((dcomplex*)p1)->r=0; ((dcomplex*)p1)->i=0; } else {
    logX(&l, p2);
    r.r = ((dcomplex*)p3)->r * l.r - ((dcomplex*)p3)->i * l.i;
    r.i = ((dcomplex*)p3)->r * l.i + ((dcomplex*)p3)->i * l.r;
    expX(p1, &r); }
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowCB(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(dcomplex*)p1 = powCi((dcomplex*)p2,*(u_int8_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowCI(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(dcomplex*)p1 = powCi((dcomplex*)p2,*(int16_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowCL(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(dcomplex*)p1 = powCi((dcomplex*)p2,*(int32_t*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowCF(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    dcomplex r;
    if (*(float*)p3==0)
    { ((dcomplex*)p1)->r=1; ((dcomplex*)p1)->i=0; } else
    if (((dcomplex*)p2)->r==0 && ((dcomplex*)p2)->i==0 && *(float*)p3>0)
    { ((dcomplex*)p1)->r=0; ((dcomplex*)p1)->i=0; } else {
    logC(&r, p2);
    r.r *= *(float*)p3;
    r.i *= *(float*)p3;
    expC(p1, &r); }
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowCD(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    dcomplex r;
    if (*(double*)p3==0)
    { ((dcomplex*)p1)->r=1; ((dcomplex*)p1)->i=0; } else
    if (((dcomplex*)p2)->r==0 && ((dcomplex*)p2)->i==0 && *(double*)p3>0)
    { ((dcomplex*)p1)->r=0; ((dcomplex*)p1)->i=0; } else {
    logC(&r, p2);
    r.r *= *(double*)p3;
    r.i *= *(double*)p3;
    expC(p1, &r); }
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowCX(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    dcomplex l, r;
    if (((scomplex*)p3)->r==0 && ((scomplex*)p3)->i==0)
    { ((dcomplex*)p1)->r=1; ((dcomplex*)p1)->i=0; } else
    if (((dcomplex*)p2)->r==0 && ((dcomplex*)p2)->i==0 && ((scomplex*)p3)->r>0 && ((scomplex*)p3)->i==0)
    { ((dcomplex*)p1)->r=0; ((dcomplex*)p1)->i=0; } else {
    logC(&l, p2);
    r.r = ((scomplex*)p3)->r * l.r - ((scomplex*)p3)->i * l.i;
    r.i = ((scomplex*)p3)->r * l.i + ((scomplex*)p3)->i * l.r;
    expC(p1, &r); }
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowCC(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    dcomplex l, r;
    if (((dcomplex*)p3)->r==0 && ((dcomplex*)p3)->i==0)
    { ((dcomplex*)p1)->r=1; ((dcomplex*)p1)->i=0; } else
    if (((dcomplex*)p2)->r==0 && ((dcomplex*)p2)->i==0 && ((dcomplex*)p3)->r>0 && ((dcomplex*)p3)->i==0)
    { ((dcomplex*)p1)->r=0; ((dcomplex*)p1)->i=0; } else {
    logC(&l, p2);
    r.r = ((dcomplex*)p3)->r * l.r - ((dcomplex*)p3)->i * l.i;
    r.i = ((dcomplex*)p3)->r * l.i + ((dcomplex*)p3)->i * l.r;
    expC(p1, &r); }
    p1+=i1; p2+=i2; p3+=i3;
  }
}
static void PowOO(int n, char *p1, int i1, char *p2, int i2, char *p3, int i3)
{
  for (; n; --n) {
    *(VALUE*)p1 = rb_funcall(*(VALUE*)p2,na_id_power,1,*(VALUE*)p3);
    p1+=i1; p2+=i2; p3+=i3;
  }
}

na_setfunc_t PowFuncs = {
  { TpErr, TpErr, TpErr, TpErr, TpErr, TpErr, TpErr, TpErr, TpErr },
  { TpErr, PowBB, PowBI, PowBL, PowBF, PowBD, TpErr, TpErr, TpErr },
  { TpErr, PowIB, PowII, PowIL, PowIF, PowID, TpErr, TpErr, TpErr },
  { TpErr, PowLB, PowLI, PowLL, PowLF, PowLD, TpErr, TpErr, TpErr },
  { TpErr, PowFB, PowFI, PowFL, PowFF, PowFD, TpErr, TpErr, TpErr },
  { TpErr, PowDB, PowDI, PowDL, PowDF, PowDD, TpErr, TpErr, TpErr },
  { TpErr, PowXB, PowXI, PowXL, PowXF, PowXD, PowXX, PowXC, TpErr },
  { TpErr, PowCB, PowCI, PowCL, PowCF, PowCD, PowCX, PowCC, TpErr },
  { TpErr, TpErr, TpErr, TpErr, TpErr, TpErr, TpErr, TpErr, PowOO }
};


/* ------------------------- Execution -------------------------- */

static void
 na_exec_math(struct NARRAY *a1, struct NARRAY *a2, void (*func)())
{
  int  i, s1, s2;
  char *p1, *p2;

  s1 = na_sizeof[a1->type];
  s2 = na_sizeof[a2->type];
  p1 = a1->ptr;
  p2 = a2->ptr;
  for (i=a1->total; i ; i--) {
    (*func)( p1, p2 );
    p1 += s1;
    p2 += s2;
  }
}


static VALUE
 na_math_func(volatile VALUE self, na_mathfunc_t funcs)
{
  struct NARRAY *a1, *a2;
  VALUE ans;

  if (TYPE(self) == T_ARRAY) {
    self = na_ary_to_nary(self,cNArray);
  } else
  if (!IsNArray(self)) {
    self = na_make_scalar(self,na_object_type(self));
  }

  GetNArray(self,a2);
  if (NA_IsINTEGER(a2)) {
    self = na_upcast_type(self,NA_DFLOAT);
    GetNArray(self,a2);
  }
  ans = na_make_object(a2->type, a2->rank, a2->shape, CLASS_OF(self));
  GetNArray(ans,a1);

  na_exec_math(a1, a2, funcs[a2->type]);

  if (CLASS_OF(self) == cNArrayScalar)
    SetFuncs[NA_ROBJ][a1->type](1,&ans,0,a1->ptr,0);    

  return ans;
}

/* ------------------------- Module Methods -------------------------- */

/*
 *  call-seq:
 *     NMath.sqrt(arg)  -> narray
 */
static VALUE na_math_sqrt(VALUE obj, VALUE x)
{ return na_math_func(x,sqrtFuncs); }

/*
 *  call-seq:
 *     NMath.sin(arg)  -> narray
 */
static VALUE na_math_sin(VALUE obj, VALUE x)
{ return na_math_func(x,sinFuncs); }

/*
 *  call-seq:
 *     NMath.cos(arg)  -> narray
 */
static VALUE na_math_cos(VALUE obj, VALUE x)
{ return na_math_func(x,cosFuncs); }

/*
 *  call-seq:
 *     NMath.tan(arg)  -> narray
 */
static VALUE na_math_tan(VALUE obj, VALUE x)
{ return na_math_func(x,tanFuncs); }

/*
 *  call-seq:
 *     NMath.sinh(arg)  -> narray
 */
static VALUE na_math_sinh(VALUE obj, VALUE x)
{ return na_math_func(x,sinhFuncs); }

/*
 *  call-seq:
 *     NMath.cosh(arg)  -> narray
 */
static VALUE na_math_cosh(VALUE obj, VALUE x)
{ return na_math_func(x,coshFuncs); }

/*
 *  call-seq:
 *     NMath.tanh(arg)  -> narray
 */
static VALUE na_math_tanh(VALUE obj, VALUE x)
{ return na_math_func(x,tanhFuncs); }

/*
 *  call-seq:
 *     NMath.exp(arg)  -> narray
 */
static VALUE na_math_exp(VALUE obj, VALUE x)
{ return na_math_func(x,expFuncs); }

/*
 *  call-seq:
 *     NMath.log(arg)  -> narray
 */
static VALUE na_math_log(VALUE obj, VALUE x)
{ return na_math_func(x,logFuncs); }

/*
 *  call-seq:
 *     NMath.log10(arg)  -> narray
 */
static VALUE na_math_log10(VALUE obj, VALUE x)
{ return na_math_func(x,log10Funcs); }

/*
 *  call-seq:
 *     NMath.log2(arg)  -> narray
 */
static VALUE na_math_log2(VALUE obj, VALUE x)
{ return na_math_func(x,log2Funcs); }

/*
 *  call-seq:
 *     NMath.asin(arg)  -> narray
 */
static VALUE na_math_asin(VALUE obj, VALUE x)
{ return na_math_func(x,asinFuncs); }

/*
 *  call-seq:
 *     NMath.asinh(arg)  -> narray
 */
static VALUE na_math_asinh(VALUE obj, VALUE x)
{ return na_math_func(x,asinhFuncs); }

/*
 *  call-seq:
 *     NMath.acos(arg)  -> narray
 */
static VALUE na_math_acos(VALUE obj, VALUE x)
{ return na_math_func(x,acosFuncs); }

/*
 *  call-seq:
 *     NMath.acosh(arg)  -> narray
 */
static VALUE na_math_acosh(VALUE obj, VALUE x)
{ return na_math_func(x,acoshFuncs); }

/*
 *  call-seq:
 *     NMath.atan(arg)  -> narray
 */
static VALUE na_math_atan(VALUE obj, VALUE x)
{ return na_math_func(x,atanFuncs); }

/*
 *  call-seq:
 *     NMath.atanh(arg)  -> narray
 */
static VALUE na_math_atanh(VALUE obj, VALUE x)
{ return na_math_func(x,atanhFuncs); }


/* Initialization of NMath module */
void Init_nmath(void)
{
  /* define ExtMath module */
  rb_mNMath = rb_define_module("NMath");

  /* methods */
  rb_define_module_function(rb_mNMath,"sqrt",na_math_sqrt,1);
  rb_define_module_function(rb_mNMath,"sin",na_math_sin,1);
  rb_define_module_function(rb_mNMath,"cos",na_math_cos,1);
  rb_define_module_function(rb_mNMath,"tan",na_math_tan,1);
  rb_define_module_function(rb_mNMath,"sinh",na_math_sinh,1);
  rb_define_module_function(rb_mNMath,"cosh",na_math_cosh,1);
  rb_define_module_function(rb_mNMath,"tanh",na_math_tanh,1);
  rb_define_module_function(rb_mNMath,"exp",na_math_exp,1);
  rb_define_module_function(rb_mNMath,"log",na_math_log,1);
  rb_define_module_function(rb_mNMath,"log10",na_math_log10,1);
  rb_define_module_function(rb_mNMath,"log2",na_math_log2,1);
  rb_define_module_function(rb_mNMath,"asin",na_math_asin,1);
  rb_define_module_function(rb_mNMath,"asinh",na_math_asinh,1);
  rb_define_module_function(rb_mNMath,"acos",na_math_acos,1);
  rb_define_module_function(rb_mNMath,"acosh",na_math_acosh,1);
  rb_define_module_function(rb_mNMath,"atan",na_math_atan,1);
  rb_define_module_function(rb_mNMath,"atanh",na_math_atanh,1);
}
