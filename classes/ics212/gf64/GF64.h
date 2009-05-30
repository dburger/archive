/*
    GF64.cpp by
    David J. Burger
    for ICS 212 under the guidance of
    Dr. Peterson.
*/
class GF64 {
    int e;
    static int L[64];
    static GF64 E[63];
public:
    GF64(int n=0) {e=n;};
    GF64 operator++();
    GF64 operator++(int n);
    GF64 operator--();
    GF64 operator--(int n);
    GF64 operator+=(GF64 a);
    GF64 operator*=(GF64 a);
    GF64 operator/=(GF64 a);
    GF64 power(int n);
    GF64 inv();
    /* declared friend to get at private data */
    int friend operator!=(GF64 a, GF64 b);
    int GetE() {return e;};
};

/* non class operators */
GF64 operator+(GF64 a, GF64 b);
GF64 operator*(GF64 a, GF64 b);
GF64 operator/(GF64 a, GF64 b);
