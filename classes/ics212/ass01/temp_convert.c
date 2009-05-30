#include <stdio.h>

/* print Fahrenheit-Celsious table
    for fahr = 0, 20, ..., 300  */
main()
{
    float fahr, celsius;
    int lower, upper, step;

    lower = 0;    /* lower limit of termperature table */
    upper = 300;  /* upper limit */
    step = 20;

    printf("==============================\n");
    printf("Temperature conversion program\n");
    printf("==============================\n");

    fahr = lower;
    while (fahr <= upper) {
        celsius = (5.0/9.0) * (fahr-32.0);
        printf("%3.0f %6.1f\n", fahr, celsius);
               fahr = fahr + step;
    }
}
