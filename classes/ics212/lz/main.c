#include <stdio.h>
#include "lzroutines.h"

int main(int argc, char *argv[]) {

    /* check to see if they passed in the proper filenames */
    if (argc < 3) {
        printf("Proper usage is %s source destination.\n",argv[0]);
        exit(0);
    }

    lzdecompress(argv[1], argv[2]);

}

















