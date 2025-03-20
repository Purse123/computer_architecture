#include <stdio.h>
#include <math.h>

void DEC2BIN() {
  int n, temp, i = 0;
  int bin[50];

  printf("Enter decimal number: ");
  scanf("%d", &n);

  while (n != 0) {
    temp = n % 2;
    bin[i++] = temp;
    n /= 2;
  }

  printf("Binary: ");
  for (int j = i - 1; j >= 0; j--) {
    printf("%d", bin[j]);
  }
  printf("\n");
}

void BIN2DEC() {
  int n, result = 0, i = 0, temp;

  printf("Enter binary number: ");
  scanf("%d", &n);

  while(n != 0) {
    temp = n % 10;
    result += ( pow(2, i++) * temp );
    n /= 10;
  }
  printf("Decimal: %d\n", result);
}

int main() {
  int op = 0;
  printf("___________________\n");
  printf("1. decimal to binary\n2. binary to decimal\n3. Exit\n");
  printf("___________________\n");

  while (op != 3) {
    printf("Enter mode: ");
    scanf("%d", &op);

    switch (op) {
    case 1:
      DEC2BIN();
    break;
    case 2:
      BIN2DEC();
    break;
    case 3:
      printf("Exiting...\n");
    break;
    default:
      printf("Invalid operation\n");
    }
  }
}
