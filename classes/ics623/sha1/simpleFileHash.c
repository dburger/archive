#include <stdio.h>

unsigned long circShiftLeft(unsigned long l, int bits);
void sha1();

unsigned long A, B, C, D, E;

unsigned long H0 = 0x67452301, H1 = 0xEFCDAB89, H2 = 0x98BADCFE,
              H3 = 0x10325476, H4 = 0xC3D2E1F0;

unsigned long W[80], TEMP;

unsigned long buffer[16]; /* buffer for reading from the file */

int main(int argc, char *argv[]) {

  FILE *fp; /* file pointer for opening the file */

  char *p; /* char pointer for working with the buffer */

  int bytesRead; /* the number of bytes read on fread call */

  int fileSize = 0; /* keeps track of the file size */

  if (argc<2) {
    printf("Proper usage is %s filename\n",argv[0]);
    exit(0);
  }

  if ((fp=fopen(argv[1],"r"))==NULL) {
    printf("Unable to open %s\n",argv[1]);
    exit(0);
  }

  while (!feof(fp)) {
    bytesRead = fread(buffer,1,sizeof(buffer),fp);
    fileSize+=bytesRead;
    if (bytesRead==sizeof(buffer)) {
      sha1(); /* computing sha1 on buffer block */
    } else { /* we have a partial block */
      p = (char *)buffer;
      p[bytesRead] = 0x80; /* put the 1 bit after last byte read */
      memset(p+bytesRead+1,0,sizeof(buffer)-bytesRead-1); /* zero out rest */
      if (sizeof(buffer)-bytesRead-1<8) { /* figure out if room for size */
        sha1(); /* no room for size in this block, compute sha1() for buffer */
        /* now make a new last block with the size */
        memset(p,0,sizeof(buffer));
	    buffer[15] = fileSize * 8;
        sha1(); /* compute sha1() for this last block */
      } else { /* room for size in the block */
        buffer[15] = fileSize*8; /* put the size in */
        sha1(); /* compute sha1() for this last block */
      }
    }
  }

  printf("File: %s Size = %d bits, or %d bytes\n",argv[1],fileSize*8,fileSize);
  printf("SHA1 HASH: %08x: %08x: %08x: %08x: %08x\n",H0,H1,H2,H3,H4);

}

unsigned long circShiftLeft(unsigned long l, int bits) {
  return (l << bits) | (l >> 32 - bits);
}

void sha1() {
  int i,t;

  for (i=0;i<16;i++)
    W[i] = buffer[i];

  for (t=16;t<80;t++)
    W[t] = circShiftLeft(W[t-3] ^ W[t-8] ^ W[t-14] ^ W[t-16],1);

  A = H0;
  B = H1;
  C = H2;
  D = H3;
  E = H4;

  for (t=0;t<20;t++) {
    TEMP = circShiftLeft(A,5) + ((B&C)|(~B&D)) + E + W[t] + 0x5A827999;
    E = D;
    D = C;
    C = circShiftLeft(B,30);
    B = A;
    A = TEMP;
  }

  for (t=20;t<40;t++) {
    TEMP = circShiftLeft(A,5) + (B^C^D) + E + W[t] + 0x6ED9EBA1;
    E = D;
    D = C;
    C = circShiftLeft(B,30);
    B = A;
    A = TEMP;
  }

  for (t=40;t<60;t++) {
    TEMP = circShiftLeft(A,5) + ((B&C)|(B&D)|(C&D)) + E + W[t] + 0x8F1BBCDC;
    E = D;
    D = C;
    C = circShiftLeft(B,30);
    B = A;
    A = TEMP;
  }

  for (t=60;t<80;t++) {
    TEMP = circShiftLeft(A,5) + (B^C^D) + E + W[t] + 0xCA62C1D6;
    E = D;
    D = C;
    C = circShiftLeft(B,30);
    B = A;
    A = TEMP;
  }

  H0+=A;
  H1+=B;
  H2+=C;
  H3+=D;
  H4+=E;

}
