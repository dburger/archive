/* compile with gcc gdbm.c -l gdbm */

/*
 * Demonstrates usage of gdbm basic key / value database.
 * Note that dbm, and ndbm are two different database formats
 * that have very similar API's.  Check man gdbm for full details.
 * Apparent Perl's default is dbm and requires modules for other
 * formats.
 * The interface here is sloppy but for demonstration of gdbm
 * functions only.
 */

#include <stdio.h>
#include <gdbm.h>

#define BUF_SIZ 80

/* yeah, I was studying a little Perl lately */
void chomp(char *s) {
  int last = strlen(s) - 1;
  if (s[last] == '\n') s[last] = 0;
}

/* for printing datum as if string...because no NULL terminator */
void printd(datum d) {
  char *s = (char *)malloc(d.dsize + 1);
  memcpy(s, d.dptr, d.dsize);
  s[d.dsize] = 0;
  printf("%s", s);
  free(s);
}

int main(int argc, char *argv[]) {
  GDBM_FILE dbf;
  datum key, val;
  char *s;

  /* set up buffers in the datum so data can be read directly in...lazy */
  key.dptr = (char *)malloc(BUF_SIZ);
  val.dptr = (char *)malloc(BUF_SIZ);

  /* attempt to open/create file */
  if ((dbf = gdbm_open("test", 0, GDBM_WRCREAT, 0600, 0)) == NULL) {
    fprintf(stderr, "Unable to open dbm file.\n");
    exit(1);
  }

  printf("Ready to enter data, type \"quit\" to go to retrieval mode.\n");
  printf("Key: ");
  while (fgets(key.dptr, BUF_SIZ, stdin)) {
    chomp(key.dptr);
    key.dsize = strlen(key.dptr);
    if (strcmp(key.dptr, "quit") == 0) break;
    printf("Value: ");
    if (fgets(val.dptr, BUF_SIZ, stdin) == NULL) break;
    chomp(val.dptr);
    val.dsize = strlen(val.dptr);
    switch (gdbm_store(dbf, key, val, GDBM_REPLACE)) {
      case  0:
        printf("Key / Value pair inserted.\n");
        break;
      default:
        /*  1 can only occur on duplicate entry with GDBM_INSERT,
         * -1 can occur if we are not a writer, or one of the key / value
         * was NULL
         */
        printf("Key / Value pair not inserted, error occured.\n");
    }
    printf("Key: ");
  }

  /* val is going to get gdbm_fetch, so we will free our allocated buffer */
  free(val.dptr);

  printf("Ready to retrieve data, type \"quit\" to quit\n");
  printf("Key: ");
  while (fgets(key.dptr, BUF_SIZ, stdin)) {
    chomp(key.dptr);
    key.dsize = strlen(key.dptr);
    if (strcmp(key.dptr, "quit") == 0) break;
    val = gdbm_fetch(dbf, key);
    if (val.dptr) {
      printf("Value ");
      printd(val);
      printf("\n");
    } else {
      printf("Unable to fetch the data.\n");
    }
    printf("Key: ");
  }

  free(key.dptr);

  /* now going to sequentially show the data */
  key = gdbm_firstkey(dbf);
  while (key.dptr) {
    val = gdbm_fetch(dbf, key);
    if (val.dptr) {
      printf("Key: ");
      printd(key);
      printf("\n");

      printf("Value: ");
      printd(val);
      printf("\n");
    }
    key = gdbm_nextkey(dbf, key);
  }

  gdbm_close(dbf);
}
