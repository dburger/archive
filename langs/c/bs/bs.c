#include <stdio.h>

int bs(char *a, int size, char c) {
  int hi, lo, mid;
  if (size<=0) return -1;
  lo = 0;
  hi = size - 1;
  for (mid=(hi+lo)/2;lo<=hi;mid=(hi+lo)/2) {
    if (a[mid]<c)
      lo = mid + 1;
    else if (a[mid]==c)
      return mid;
    else
      hi = mid - 1;
  }

  return -1;

}
