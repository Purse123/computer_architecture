#include <stdio.h>
#include <stdlib.h>

int add_signed(int a, int b, int num_bits) {
  int result = a + b;
  int mask = (1 << num_bits) - 1;
  return result & mask;
}

int subtract_signed(int a, int b, int num_bits) {
  int b_neg = (~b + 1) & ((1 << num_bits) - 1);
  return add_signed(a, b_neg, num_bits);
}

void print_binary(int num, int num_bits) {
  for (int i = num_bits - 1; i >= 0; i--) {
    printf("%d", (num >> i) & 1);
  }
}

int main() {
  int num_bits, a, b;

  printf("Enter the number of bits: ");
  scanf("%d", &num_bits);

  printf("Enter first 2's comp number: ");
  scanf("%d", &a);
  printf("Enter second 2's comp number: ");
  scanf("%d", &b);

  int sum = add_signed(a, b, num_bits);
  int difference = subtract_signed(a, b, num_bits);

  printf("A + B : ");
  print_binary(sum, num_bits);

  printf("\nA - B : ");
  print_binary(difference, num_bits);
  printf("\n");
printf("-----------------------------\n");
        printf("Programmed by: Pierce Neupane\n");

  return 0;
}
