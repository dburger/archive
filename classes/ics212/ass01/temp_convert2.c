#include <stdio.h>

#define LOWER 0
#define UPPER 100
#define STEP 10

float celsToFahr(int cels);

main()
{

    float fahr, celsius;

    celsius = LOWER;

    printf("+++++++++++++++++++++++++++++++\n");
    printf("Celsius to fahrenheit converter\n");
    printf("+++++++++++++++++++++++++++++++\n");

    while (celsius <= UPPER) {
        fahr = celsToFahr(celsius);
        printf("%3.0f %6.1f\n",celsius,fahr);
        celsius = celsius + STEP;
    }
}

float celsToFahr(int cels) {
  return (9.0/5.0) * cels + 32.0;
}







