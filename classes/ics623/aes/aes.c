/*=============================================================================
Assignment: AES project
Author:     David J. Burger
Language:   ANSI C running on UHUNIX2 (Solaris)
Compile:    by running "make" with included makefile

Class:      ICS 623
Instructor: Dr. Peterson
Due Date:   10/29/01
===============================================================================
File:         aes.c

Description:  this program implements and demonstrates the AES encription
              algorithm.  The main routine runs two tests.  The first is the
              encription of:
              
            "Secret de deux, secret de Dieu, secret de trois, secret de tous."
            
              The resulting encripted bytes are written to the screen.  The
              second test decripts some hex supplied by Dr. Peterson and 
              displays the resulting hex and ascii text on the screen.
=============================================================================*/
#include <stdio.h>
#include "aes.h"

#define Nk 4 /* Nk the number of 32 bit words in the cipher key */
#define Nb 4 /* Nb the number of 32 bit words in the block size */
#define Nr 10 /* Nr the number of rounds used in the algorithm */


void keyExpansion(unsigned char key[], unsigned long w[]);
unsigned long makeWord(unsigned char b3, unsigned char b2,
                       unsigned char b1, unsigned char b0);
unsigned long getByteFromULong(unsigned long l, int byte);
unsigned long subWord(unsigned long l);
unsigned long circShiftLeft(unsigned long l, int bits);
unsigned long rotWord(unsigned long l);
void addRoundKey(unsigned char state[][Nb], unsigned long w[], int round);
void cipher(unsigned char in[], unsigned char out[], unsigned long w[]);
void invCipher(unsigned char in[], unsigned char out[], unsigned long w[]);
void shiftRows(unsigned char state[][Nb]);
void invShiftRows(unsigned char state[][Nb]);
void mixColumns(unsigned char state[][Nb]);
void invMixColumns(unsigned char state[][Nb]);
void subBytes(unsigned char state[][Nb]);
void invSubBytes(unsigned char state[][Nb]);

void printState(unsigned char state[][Nb]);
void print16(unsigned char arr[]);
int f(int a, int b);


/*=============================================================================
Function main

Purpose:  this is the main entry point to the program, it performs the two
          encryption test specified by Dr. Peterson and outputs the results to
          the screen
          
Parameters:
          not used
          
Returns:  nothing, outputs results of encription/decription on screen
=============================================================================*/
int main(int argc, char *argv[]) {

  /* Dr. Peterson's test 1*/ 
  unsigned char key[] = { 0x47, 0x43, 0x87, 0x35, 0xb4, 0xf5, 0x18, 0x57, 
                          0x13, 0x11, 0x1d, 0xb7, 0x54, 0xd9, 0x90, 0xc5 };
  unsigned char input[] =
      "Secret de deux, secret de Dieu, secret de trois, secret de tous.";

  /* Dr. Peterson's test 2 */
  unsigned char cipherText[]={0x21, 0xaf, 0x2e, 0xb6, 0x25, 0xc2, 0x4e, 0x75, 
                              0xfa, 0x95, 0x7f, 0xea, 0xce, 0x98, 0x52, 0x27,  
                              0x2a, 0x52, 0x3b, 0xa2, 0xe6, 0x34, 0x9d, 0xac, 
                              0xe6, 0x73, 0x6b, 0x4b, 0x9b, 0x9e, 0x44, 0x1a,
                              0x9d, 0xa7, 0x3e, 0x15, 0x2a, 0x68, 0x19, 0x83, 
                              0x61, 0xcd, 0x7a, 0xbd, 0x8b, 0x9a, 0x43, 0xce,
                              0x62, 0xff, 0x17, 0xcb, 0x97, 0x10, 0x06, 0xc2, 
                              0x9e, 0xf7, 0x4b, 0x1d, 0xad, 0x87, 0x97, 0xbd,
                              0x6d, 0x75, 0x4f, 0x9a, 0xd4, 0xf4, 0x4f, 0x91, 
                              0xc5, 0xc5, 0xcd, 0xe1, 0x37, 0x3a, 0x80, 0xcc };

  unsigned long w[Nb * (Nr+1)]; /* to hold the key schedule */
  unsigned char out[4*Nb]; /* to hold the output of one ciphered block */
  int i, j; /* used for loops */

  keyExpansion(key,w); /* calculate the key schedule and put it in w */

  #ifdef DEBUG
    printf("key schedule\n");
    for (i=0;i<Nb*(Nr+1);i++)
      printf("%d %08x\n",i, w[i]);
  #endif
  
  printf("\nTest #1\n");

  /* encipher Dr. Peterson's test # 1 */
  printf("Plain text:");
  for (i=0;i<strlen(input);i++) {
    if (i%8==0) printf("\n");
    printf("%02x",input[i]);
  }
  
  printf("\n\n");

  printf("Cipher text:");
  for (i=0;i<4;i++) {
    cipher(input+(i*16),out,w);
    for (j=0;j<sizeof(out);j++) {
      if (j%8==0) printf("\n");
      printf("%02x",out[j]);
    }
  }

  printf("\n\n");

  printf("Test #2\n");

  printf("Deciphered text:\n");
  for (i=0;i<4;i++) {
    invCipher(cipherText+(i*16),out,w);
    printf("%02x%02x%02x%02x%02x%02x%02x%02x %c%c%c%c%c%c%c%c\n",
           out[0],out[1],out[2],out[3],out[4],out[5],out[6],out[7],
           out[0],out[1],out[2],out[3],out[4],out[5],out[6],out[7]);
    printf("%02x%02x%02x%02x%02x%02x%02x%02x %c%c%c%c%c%c%c%c\n",
           out[8],out[9],out[10],out[11],out[12],out[13],out[14],out[15],
           out[8],out[9],out[10],out[11],out[12],out[13],out[14],out[15]);
  }

  printf("\n");

}


/*=============================================================================
Function invCipher

Purpose:  creates a deciphered block using the AES standard
          
Parameters:
    unsigned char in[] (IN) - the data to decipher
    unsigned char out[] (OUT) - deciphered block
    unsigned long w[] (IN) - the key schedule

Returns:  out[] contains the deciphered text
=============================================================================*/
void invCipher(unsigned char in[], unsigned char out[], unsigned long w[]) {
    int r,c; /* rows and columns of the state array */
    unsigned char state[4][Nb]; /* the state array */
    int round; /* keeps track of the round */

    /* copy in to the state */
    for (r=0;r<4;r++)
      for (c=0;c<Nb;c++)
        state[r][c] = in[r+4*c];

    #ifdef DEBUG
      printf("iinput ");
      printState(state);
    #endif

    addRoundKey(state,w,Nr);

    for (round=Nr-1;round>0;round--) {

      #ifdef DEBUG
        printf("%d isstart ",round);
        printState(state);
      #endif
      
      invShiftRows(state);

      #ifdef DEBUG
        printf("%d is_row  ",round);
        printState(state);
      #endif

      invSubBytes(state);

      #ifdef DEBUG
        printf("%d is_box  ",round);
        printState(state);
      #endif

      addRoundKey(state,w,round);

      #ifdef DEBUG
        printf("%d ik_add  ",round);
        printState(state);
      #endif

      invMixColumns(state);

    }

    invShiftRows(state);
    invSubBytes(state);
    addRoundKey(state,w,0);

    /* copy state to out */
    for (r=0;r<4;r++)
      for (c=0;c<Nb;c++)
        out[r+c*4] = state[r][c];

}

/*=============================================================================
Function cipher

Purpose:  creates a cipher block using the AES standard
          
Parameters:
    unsigned char in[] (IN) - the data to encipher
    unsigned char out[] (OUT) - enciphered block
    unsigned long w[] (IN) - the key schedule

Returns:  out[] contains the enciphered text
=============================================================================*/
void cipher(unsigned char in[], unsigned char out[], unsigned long w[]) {
    int r,c; /* rows and columns of the state array */
    unsigned char state[4][Nb]; /* the state array */
    int round = 0; /* used to keep track of the round */

    /* copy in to the state */
    for (r=0;r<4;r++)
      for (c=0;c<Nb;c++)
        state[r][c] = in[r+4*c];

    
    #ifdef DEBUG
      printf("start ");
      printState(state);
    #endif
    
    addRoundKey(state, w, round);

    for (round=1;round<Nr;round++) {

      #ifdef DEBUG
        printf("%d start ",round);
        printState(state);
      #endif

      subBytes(state);
      
      #ifdef DEBUG
        printf("%d s_box ",round);
        printState(state);
      #endif
      
      shiftRows(state);

      #ifdef DEBUG
        printf("%d s_row ",round);
        printState(state);
      #endif

      mixColumns(state);
      
      #ifdef DEBUG
        printf("%d m_col ",round);
        printState(state);
      #endif 

      addRoundKey(state,w,round);
            
    }

    subBytes(state);
    shiftRows(state);
    addRoundKey(state,w,Nr);    

    /* copy state to out */
    for (r=0;r<4;r++)
      for (c=0;c<Nb;c++)
        out[r+c*4] = state[r][c];

}

/*=============================================================================
Function addRoundKey

Purpose:  manipulates the state according to the AES standard
          
Parameters:
    unsigned char state[][Nb] (IN/OUT) - current state in AES
    unsigned long w[] (IN) - the key schedule
    int round (IN) - the current round # of the AES algorithm

Returns:  the state is manipulated according to the AES standard
=============================================================================*/
void addRoundKey(unsigned char state[][Nb], unsigned long w[], int round) {
  
  int c; /* for a column loop */
  unsigned long temp; /* to hold a temporary long to back in state */
  for (c=0;c<Nb;c++) {
    temp = makeWord(state[0][c],state[1][c],state[2][c],state[3][c]) ^ w[round*Nb+c];
    state[0][c] = getByteFromULong(temp,3);
    state[1][c] = getByteFromULong(temp,2);
    state[2][c] = getByteFromULong(temp,1);
    state[3][c] = getByteFromULong(temp,0);
  }

}


/*=============================================================================
Function keyExpansion

Purpose:  to create the key schedule for the AES standard
          
Parameters:
    unsigned char key[] (IN) - the key
    unsigned long w[] (OUT) - the computed key schedule

Returns:  the computed key schedule is returned in w[] according to the AES
          standard
=============================================================================*/
void keyExpansion(unsigned char key[], unsigned long w[]) {
  int i = 0; /* for the key expansion loop */
  unsigned long temp;
  while (i<Nk)
    w[i++] = makeWord(key[4*i],key[4*i+1],key[4*i+2],key[4*i+3]);

  i = Nk;

  while (i < Nb * (Nr + 1)) {
    temp = w[i-1];

    if (i % Nk==0)
      temp = subWord(rotWord(temp)) ^ RCON[i / Nk];
    else if ((Nk == 8) && (i % Nk == 4))
      temp = subWord(temp);

    w[i++] = w[i-Nk] ^ temp;
  }

}

/*=============================================================================
Function makeWord

Purpose:  to create a word from the passed in bytes, used in the AES standard
          
Parameters:
    unsigned char b3 (IN) - high byte
    unsigned char b2 (IN) - next byte    
    unsigned char b1 (IN) - next byte    
    unsigned char b0 (IN) - low byte    

Returns:  an unsigned long is made of the bytes and returned
=============================================================================*/
unsigned long makeWord(unsigned char b3, unsigned char b2, unsigned char b1, unsigned char b0) {
  return (b3<<24) | (b2<<16) | (b1<<8) | b0;
}

/*=============================================================================
Function subWord

Purpose:  returns the S-Box transformation of the bytes of an unsigned long
          
Parameters:
    unsigned long l (IN) - word to apply S-Box transformation to

Returns:  an S-Box transformation representation of the passed in word
=============================================================================*/
unsigned long subWord(unsigned long l) {
  return (SB[getByteFromULong(l,3)]<<24 | SB[getByteFromULong(l,2)]<<16
          | SB[getByteFromULong(l,1)] << 8 | SB[getByteFromULong(l,0)]);
}

/*=============================================================================
Function subBytes

Purpose:  to manipulate the state as specified in the AES standard
          
Parameters:
    int unsigned char state[][Nb] (IN/OUT) - current state

Returns:  state is manipulated as specified in AES standard
=============================================================================*/
void subBytes(unsigned char state[][Nb]) {
    int r, c;
    for (r=0;r<4;r++)
      for (c=0;c<Nb;c++)
        state[r][c] = SB[state[r][c]];
}

/*=============================================================================
Function invSubBytes

Purpose:  to manipulate the state as specified in the AES standard
          
Parameters:
    int unsigned char state[][Nb] (IN/OUT) - current state

Returns:  state is manipulated as specified in AES standard
=============================================================================*/
void invSubBytes(unsigned char state[][Nb]) {
    int r, c;
    for (r=0;r<4;r++)
      for (c=0;c<Nb;c++)
        state[r][c] = SBI[state[r][c]];
}

/*=============================================================================
Function shiftRows

Purpose:  to manipulate the state as specified in the AES standard
          
Parameters:
    int unsigned char state[][Nb] (IN/OUT) - current state

Returns:  state is manipulated as specified in AES standard
=============================================================================*/
void shiftRows(unsigned char state[][Nb]) {
    unsigned char stateCopy[4][Nb];
    int r, c;
    for (r=0;r<4;r++)
      for (c=0;c<Nb;c++)
        stateCopy[r][c] = state[r][c];

    for (r=0;r<4;r++)
      for (c=0;c<Nb;c++)
        state[r][c] = stateCopy[r][(c+r) % Nb];

}

/*=============================================================================
Function invShiftRows

Purpose:  to manipulate the state as specified in the AES standard
          
Parameters:
    int unsigned char state[][Nb] (IN/OUT) - current state

Returns:  state is manipulated as specified in AES standard
=============================================================================*/
void invShiftRows(unsigned char state[][Nb]) {
    unsigned char stateCopy[4][Nb];
    int r, c;
    for (r=0;r<4;r++)
      for (c=0;c<Nb;c++)
        stateCopy[r][c] = state[r][c];

    for (r=0;r<4;r++)
      for (c=0;c<Nb;c++)
        state[r][(c+r) % Nb] = stateCopy[r][c];
}


/*=============================================================================
Function mixColumns

Purpose:  to manipulate the state as specified in the AES standard
          
Parameters:
    int unsigned char state[][Nb] (IN/OUT) - current state

Returns:  state is manipulated as specified in AES standard
=============================================================================*/
void mixColumns(unsigned char state[][Nb]) {
    int r, c;
    unsigned char stateCopy[4][Nb];
    for (r=0;r<4;r++)
      for (c=0;c<Nb;c++)
        stateCopy[r][c] = state[r][c];

    for (c=0;c<Nb;c++) {
      state[0][c] = f(0x02,stateCopy[0][c]) ^ f(0x03,stateCopy[1][c]) ^ stateCopy[2][c] ^ stateCopy[3][c];
      state[1][c] = stateCopy[0][c] ^ f(0x02,stateCopy[1][c]) ^ f(0x03,stateCopy[2][c]) ^ stateCopy[3][c];
      state[2][c] = stateCopy[0][c] ^ stateCopy[1][c] ^ f(0x02,stateCopy[2][c]) ^ f(0x03,stateCopy[3][c]);
      state[3][c] = f(0x03,stateCopy[0][c]) ^ stateCopy[1][c] ^ stateCopy[2][c] ^ f(0x02,stateCopy[3][c]);
    }
}

/*=============================================================================
Function invMixColumns

Purpose:  to manipulate the state as specified in the AES standard
          
Parameters:
    int unsigned char state[][Nb] (IN/OUT) - current state

Returns:  state is manipulated as specified in AES standard
=============================================================================*/
void invMixColumns(unsigned char state[][Nb]) {
    int r, c;
    unsigned char stateCopy[4][Nb];
    for (r=0;r<4;r++)
      for (c=0;c<Nb;c++)
        stateCopy[r][c] = state[r][c];

    for (c=0;c<Nb;c++) {
            state[0][c] = f(0x0e,stateCopy[0][c]) ^ f(0x0b,stateCopy[1][c]) ^ f(0x0d,stateCopy[2][c]) ^ f(0x09,stateCopy[3][c]);
            state[1][c] = f(0x09,stateCopy[0][c]) ^ f(0x0e,stateCopy[1][c]) ^ f(0x0b,stateCopy[2][c]) ^ f(0x0d,stateCopy[3][c]);
            state[2][c] = f(0x0d,stateCopy[0][c]) ^ f(0x09,stateCopy[1][c]) ^ f(0x0e,stateCopy[2][c]) ^ f(0x0b,stateCopy[3][c]);
            state[3][c] = f(0x0b,stateCopy[0][c]) ^ f(0x0d,stateCopy[1][c]) ^ f(0x09,stateCopy[2][c]) ^ f(0x0e,stateCopy[3][c]);
    }
}


/*=============================================================================
Function f

Purpose:  a wrapper around the tables - F[(L[a]+L[b])%255]; with a or b = 0
          this returns 0 as desired, otherwise uses the tables

Parameters:
    int a (IN) - first parameter of Gf multiplication
    int b (IN) - second parameter of Gf multiplication    

Returns:  0 if a or b are 0, otherwise F[L[a]+L[b]%255]
=============================================================================*/
int f(int a, int b) {
    if (a==0 || b==0)
      return 0;
    else
      return F[(L[a]+L[b])%255];
}

/*=============================================================================
Function printState

Purpose:  This function prints out the values in the state array, useful in
          debugging
          
Parameters:
    unsigned char state[][Nb] (IN) - state table to print

Returns:  nothing, but prints out the hex values to stdout
=============================================================================*/
void printState(unsigned char state[][Nb]) {
    int r, c;
    for (c=0;c<Nb;c++)
      for (r=0;r<4;r++)
        printf("%02x",state[r][c]);
    printf("\n");
}

/*=============================================================================
Function print16

Purpose:  This function prints out the hex values of a 16 byte buffer
          
Parameters:
    unsigned char arr[] (IN) - value to print

Returns:  nothing, but prints out the hex values to stdout
=============================================================================*/
void print16(unsigned char arr[]) {
    int i;
    for (i=0;i<16;i++)
        printf("%02x ",arr[i]);
    printf("\n");
}

/*=============================================================================
Function rotWord

Purpose:  This function does a left circular shift of 8 bits
          
Parameters:
    unsigned long l (IN) - value to shift

Returns:  the value of unsigned long l shifted left 8 bits
=============================================================================*/
unsigned long rotWord(unsigned long l) {
    return circShiftLeft(l,8);
}

/*=============================================================================
Function getByteFromULong

Purpose:  This function returns the indicated byte in an unsigned long isolated
          at the low position
          
Parameters:
    unsigned long l (IN) - value to retrieve a byte from
    int byte (IN) - byte to return

Returns:  the value of the byte
=============================================================================*/
unsigned long getByteFromULong(unsigned long l, int byte) {
  if (byte<0 || byte >3) return 0;
  return (l >> (byte*8)) & 0x000000ff;
}

/*=============================================================================
Function circShiftLeft

Purpose:  This function does a left circular shift on unsigned long values
          
Parameters:
    unsigned long l (IN) - value to shift
    int bits (IN) - # of places to shift

Returns:  the value of unsigned long l shifted left int bits
=============================================================================*/
unsigned long circShiftLeft(unsigned long l, int bits) {
  return (l << bits) | (l >> 32 - bits);
}
