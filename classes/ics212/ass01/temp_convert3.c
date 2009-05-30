#include <stdio.h>

main() {

    int celsius;

    for (celsius=100;celsius>=0;celsius=celsius-10)
        printf("%3d %6.1f\n",celsius,(9.0/5.0)*celsius+32.0);

}
