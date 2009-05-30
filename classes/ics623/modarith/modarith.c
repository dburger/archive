/*=============================================================================
Assignment:  Modular Arithmetic
             
Author:      David J. Burger
Language:    ANSI C running on UHUNIX2 (Solaris)
Compile:     by running "make" with supplied makefile

Execute:     ./modtest

Class:       ICS 623
Instructor:  Dr. Peterson
Due Date:    10/22/01
===============================================================================
File:         modarith.c

Description:  this file contains the modular arithmetic functions.
              
Functions:    addm(ul a, ul b, ul m) - adds two numbers mod m

              subm(ul a, ul b, ul m) - subtracts two numbers mod m
              
              mult2m(ul a, ul m) - multiplies a number by 2 mod m
              
              multm(ul a, ul b, ul m) - multiplies two numbers mod m
              
              expm(ul a, ul b, ul m) - raises a number to a power mod m
                            
              multXgf(ul a, ul m) - does GF multiplication by x mod p(x)

              addgf(ul a, ul b) - does GF addition

              subgf(ul a, ul b) - does GF subtraction

              multgf(ul a, ul b, ul m) - does GF mutiplication mod p(x)

              expgf(ul a, ul b, ul m) - does exponentiation mod p(x)
=============================================================================*/

typedef unsigned long ul;

/*=============================================================================
Function addm

Purpose:  add two numbers mod m
          
Parameters:
     ul a (IN) - first operand
     ul b (IN) - second operand
     ul m (IN) - modulus

Returns:  a + b mod m
=============================================================================*/
ul addm(ul a, ul b, ul m) {
  ul t = a + b;
  if (t>=m) t-=m;
  return t;
}

/*=============================================================================
Function subm

Purpose:  subtracts two numbers mod m
          
Parameters:
     ul a (IN) - first operand
     ul b (IN) - second operand
     ul m (IN) - modulus

Returns:  a - b mod m
=============================================================================*/
ul subm(ul a, ul b, ul m) {
  if (a>=b)
    return a - b;
  else
    return (m - b) + a;
}

/*=============================================================================
Function mult2m

Purpose:  multiplies a number by 2 mod m
          
Parameters:
     ul a (IN) - operand
     ul m (IN) - modulus

Returns:  a * 2 mod m
=============================================================================*/
ul mult2m(ul a, ul m) {
  ul t=a<<1;
  if (t>=m) t-=m;
  return t;
}

/*=============================================================================
Function multm

Purpose:  multiplies two numbers mod m
          
Parameters:
     ul a (IN) - first operand
     ul b (IN) - second operand
     ul m (IN) - modulus

Returns:  a * b mod m
=============================================================================*/
ul multm(ul a, ul b, ul m) {
  ul mask = 0x80000000;
  ul i;
  ul t=0;
  for (i=0;i<32;i++) {
    t = mult2m(t,m);
    if (b&mask) t=addm(t,a,m);
    mask>>=1;
  }
  return t;
}

/*=============================================================================
Function expm

Purpose:  take a number to a power mod m
          
Parameters:
     ul a (IN) - first operand
     ul b (IN) - second operand
     ul m (IN) - modulus

Returns:  a to power b mod m
=============================================================================*/
ul expm(ul a, ul b, ul m) {
  ul mask = 0x80000000;
  ul i;
  ul t=1;
  for (i=0;i<32;i++) {
    t = multm(t,t,m);
    if (b&mask) t=multm(t,a,m);
    mask>>=1;
  }
  return t;
}

/*=============================================================================
Function multXgf

Purpose:  mutiplies a value by X in a GF mod p(x)
          
Parameters:
     ul a (IN) - operand
     ul m (IN) - modulus polynomial p(x)

Returns:  a * X mod m
=============================================================================*/
ul multXgf(ul a, ul m) {
  ul mask = 0x80000000;
  ul t=a<<1;
  if (t&mask) t^=m;
  return t;
}

/*=============================================================================
Function addgf

Purpose:  add two numbers in a GF
          
Parameters:
     ul a (IN) - first operand
     ul b (IN) - second operand

Returns:  a + b
=============================================================================*/
ul addgf(ul a, ul b) {
  return a ^ b;
}

/*=============================================================================
Function subgf

Purpose:  subtracts two numbers in a GF
          
Parameters:
     ul a (IN) - first operand
     ul b (IN) - second operand

Returns:  a - b
=============================================================================*/
ul subgf(ul a, ul b) {
  return a ^ b;
}

/*=============================================================================
Function multgf

Purpose:  multiplies two numbers in a GF mod polynomial p(x)
          
Parameters:
     ul a (IN) - first operand
     ul b (IN) - second operand
     ul m (IN) - modulus polynomial p(x)

Returns:  a * b mod m
=============================================================================*/
ul multgf(ul a, ul b, ul m) {
  ul mask = 0x80000000;
  ul i;
  ul t=0;
  for (i=0;i<32;i++) {
    t = multXgf(t,m);
    if (b&mask) t=addgf(t,a);
    mask>>=1;
  }
  return t;
}

/*=============================================================================
Function expgf

Purpose:  take a number to a power mod polynomial p(x)
          
Parameters:
     ul a (IN) - first operand
     ul b (IN) - second operand
     ul m (IN) - modulus polynomial p(x)

Returns:  a to the power b mod m
=============================================================================*/
ul expgf(ul a, ul b, ul m) {
  ul mask = 0x80000000;
  ul i;
  ul t=1;
  for (i=0;i<32;i++) {
    t = multgf(t,t,m);
    if (b&mask) t=multgf(t,a,m);
    mask>>=1;
  }
  return t;
}


