#include <stdio.h>

int addition(int a, int b) {
  int result = 0, rem = 0;
  int place = 1;

  while (a > 0 || b > 0 || rem > 0) {
    int temp_a = a % 10;
    int temp_b = b % 10;

    int temp_sum = (temp_a + temp_b + rem) % 2;
    rem = (temp_a + temp_b + rem) / 2;
    result += (temp_sum * place);

    place *= 10;
    a /= 10;
    b /= 10;
  }
  return result;
}

int subtract(int a, int b) {
  int result = 0, borrow = 0;
  int place = 1;

  while (a > 0 || b > 0) {
    int temp_a = a % 10;
    int temp_b = b % 10;

    int temp_sub = temp_a - temp_b - borrow;

    if (temp_sub < 0) {
      temp_sub += 2;
      borrow = 1;
    } else {
      borrow = 0;
    }

    result += (temp_sub * place);
    place *= 10;

    a /= 10;
    b /= 10;
  }

  return result;
}

int main() {
  int op, result, b1, b2;
  printf("------------------\n");
  printf("1. Addition\n2. Subtraction\n");
  printf("------------------\n");
  printf("Enter instruction key: ");
  scanf("%d", &op);

  printf("Enter first binary number: ");
  scanf("%d", &b1);
  printf("Enter second binary number: ");
  scanf("%d", &b2);

  switch (op) {
  case 1:
    result = addition(b1, b2);
    printf("Addition: %d\n", result);
    break;
  case 2:
    result = subtract(b1, b2);
    printf("Subtraction: %d\n", result);
    break;
  default: 
    printf("Invalid input\n");
  }
}
