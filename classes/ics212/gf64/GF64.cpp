#include <stdio.h>
#include <stdlib.h>
#include "GF64.h"

/*
    GF64.cpp by
    David J. Burger
    for ICS 212 under the guidance of
    Dr. Peterson.
    
    This file contains the implementation of
    the GF64 class and related operators.
*/

/* prefix increment */
GF64 GF64::operator++() {
    e++;
    return *this;
}

/* postfix increment */
GF64 GF64::operator++(int n) {
    /* save away the current state */
    GF64 t = *this;
    e++;
    /* return value before increment */
    return t;
}

/* prefix decrement */
GF64 GF64::operator--() {
    e--;
    return *this;
}

/* postfix decrement */
GF64 GF64::operator--(int n) {
    /* save away the current state */
    GF64 t = *this;
    e--;
    /* return value before decrement */
    return t;
}

/* += operator */
GF64 GF64::operator+=(GF64 a) {
    e ^= a.e;
    return *this;
}

/* + operator */
GF64 operator+(GF64 a, GF64 b) {
    GF64 t = a;
    /* uses += to do the work */
    t+=b;
    return t;
}

/* *= operator */
GF64 GF64::operator*=(GF64 a) {
    if (e==0 || a.e==0)
        e = 0;
    else {
        GF64 t = E[(L[e]+L[a.e]) % 63];
        e = t.e;
    }
    return *this;
}

/* * operator */
GF64 operator*(GF64 a, GF64 b) {    
    GF64 t = a;
    /* uses *= to do the work */
    t*=b;
    return t;
}

/* /= operator */
GF64 GF64::operator/=(GF64 a) {
    GF64 t = *this;
    t*=a.inv();
    e = t.e;
    return t;
}

/* / operator */
GF64 operator/(GF64 a, GF64 b) {
    GF64 t = a;
    /* uses /= to do the work */
    t/=b;
    return t;
}

/* != operator */
int operator!=(GF64 a, GF64 b) {
    return a.e!=b.e;
}

/* power method */
GF64 GF64::power(int n) {
    GF64 t = e, p = e;
    for (;n>1;n--)
        t = t*p;
    return t;
}

/* inverse method */
GF64 GF64::inv() {
    if (e==0) {
        printf("Error - 0 has no inverse, the program will terminate.");
        exit(0);
    }
    int n = L[e];
    if (n>0) n=63-n;
    return E[n];
}


int GF64::L[64] = 
	{  -1,    0,    1,    8,    2,   16,    9,   45,
        3,   53,   17,   41,   10,   13,   46,   24,
        4,   32,   54,   36,   18,   27,   42,   21,
       11,   51,   14,   61,   47,   49,   25,   30,
        5,   38,   33,   58,   55,   56,   37,   57,
       19,   34,   28,   59,   43,    6,   22,   39,
       12,   23,   52,   40,   15,   44,   62,    7,
       48,   29,   50,   60,   26,   20,   31,   35};



GF64 GF64::E[63] = 
	{0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x2d, 0x37,
     0x03, 0x06, 0x0c, 0x18, 0x30, 0x0d, 0x1a, 0x34,
     0x05, 0x0a, 0x14, 0x28, 0x3d, 0x17, 0x2e, 0x31,
     0x0f, 0x1e, 0x3c, 0x15, 0x2a, 0x39, 0x1f, 0x3e,
     0x11, 0x22, 0x29, 0x3f, 0x13, 0x26, 0x21, 0x2f,
     0x33, 0x0b, 0x16, 0x2c, 0x35, 0x07, 0x0e, 0x1c,
     0x38, 0x1d, 0x3a, 0x19, 0x32, 0x09, 0x12, 0x24,
     0x25, 0x27, 0x23, 0x2b, 0x3b, 0x1b, 0x36};
