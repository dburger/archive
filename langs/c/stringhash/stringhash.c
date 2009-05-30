#include <stdio.h>

/* 31 and 37 give empirically good results */
#define MULTIPLIER 31

/* typical elf hash as found on ddj */
unsigned long elf_hash(const char *name) {

  unsigned long h = 0, g;
  while (*name) {
    h = (h << 4) + *name++;
    if (g = h & 0xF0000000) h ^= g >> 24;
    h &= ~g;
  }

  return h;

}

/* hash found in the practice of programming */
unsigned long simple_hash(char *s) {

  unsigned long h = 0;
  unsigned char *p = (unsigned char *)s;

  for (;*p != 0;p++) {
    h = h * MULTIPLIER + *p;
  }

  return h;

}

int main(int argc, char *argv[]) {

  printf("size of unsigned int is %d\n", sizeof(unsigned int));
  printf("size of unsigned long is %d\n", sizeof(unsigned long));
  if (argc < 2) {
    printf("Proper usage is %s string_to_hash\n", argv[0]);
    exit(-1);
  }

  /* stepping through input args and hashing each */
  while (*(++argv)) {
    printf("elf_hash(%s)    = %08x\n", *argv, elf_hash(*argv));
    printf("simple_hash(%s) = %08x\n", *argv, simple_hash(*argv));
    printf("===================================================\n");
  }

}






