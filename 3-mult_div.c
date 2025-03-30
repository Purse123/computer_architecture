#include <stdio.h>
#include <string.h>
#include <stdlib.h>

unsigned int BIN2INT(const char *bin) {
  return (unsigned int) strtol(bin, NULL, 2);
}

unsigned int multiply(unsigned int a, unsigned int b) {
  unsigned int result = 0;
  while (b) {
    if (b & 1) {
      result += a;
    }

    a <<= 1;
    b >>= 1;
  }
  return result;
}

unsigned int divide(unsigned int dividend, unsigned int divisor) {
  if (divisor == 0) {
    printf("Error: Division by zero\n");
    return -1;
  }
  unsigned int quotient = 0;
  unsigned int remainder = 0;
  
  for (int i = 31; i >= 0; i--) {
    remainder = (remainder << 1) | ((dividend >> i) & 1);

    if (remainder >= divisor) {
      remainder -= divisor;
      quotient |= (1 << i);
    }
  }
  printf("Remainder: %u\n", remainder);
  return quotient;
}

int main() {
  int op;
  char b1[33], b2[33];
  printf("------------------\n");
  printf("1. Multiplication\n2. Divison\n");
  printf("------------------\n");
  printf("Enter instruction key: ");
  scanf("%d", &op);

  printf("Enter first binary number: ");
  scanf("%32s", b1);
  printf("Enter second binary number: ");
  scanf("%32s", b2);
  
  unsigned int a = BIN2INT(b1);
  unsigned int b = BIN2INT(b2);

  switch (op) {
  case 1:
    printf("Multiply %u\n", multiply(a, b));
    break;
  case 2:
    printf("Divide: %u\n", divide(a, b));
    break;
  default: 
    printf("Invalid input\n");
  }
}
