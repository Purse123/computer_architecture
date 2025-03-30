#include <stdio.h>
#include <stdlib.h>

void booth_multiplication(int m, int q, int num_bits) {
  int m_neg = ~m + 1;
  int q1 = 0;
  int accumulator = 0;
  int q_copy = q;

  for (int i = 0; i < num_bits; i++) {
    printf("Step %d: A=%d Q=%d Q1=%d\n", i + 1, accumulator, q_copy, q1);

    if ((q_copy & 1) == 1 && q1 == 0) {
      accumulator += m;
    } else if ((q_copy & 1) == 0 && q1 == 1) {
      accumulator += m_neg;
    }

    int q0 = q_copy & 1;
    q_copy = (accumulator & 1) << (num_bits - 1) | (q_copy >> 1);
    accumulator = (accumulator >> 1) & ((1 << (num_bits - 1)) - 1);

    q1 = q0;
  }

  printf("Final Result: A = %d, Q = %d\n", accumulator, q_copy);
}

void booth_division(int m, int q, int num_bits) {
  int m_neg = ~m + 1;
  int q1 = 0;
  int accumulator = 0;
  int q_copy = q;

  for (int i = 0; i < num_bits; i++) {
    printf("Step %d: A=%d Q=%d Q1=%d\n", i + 1, accumulator, q_copy, q1);

    if ((q_copy & 1) == 1 && q1 == 0) {
      accumulator += m;
    } else if ((q_copy & 1) == 0 && q1 == 1) {
      accumulator += m_neg;
    }

    int q0 = q_copy & 1;
    q_copy = (accumulator & 1) << (num_bits - 1) | (q_copy >> 1);
    accumulator = (accumulator >> 1) & ((1 << (num_bits - 1)) - 1);

    q1 = q0;
  }

  printf("Final Result: A = %d, Q = %d\n", accumulator, q_copy);
}

int main() {
  int m, q;
  int num_bits;

  printf("Enter the number of bits: ");
  scanf("%d", &num_bits);
  printf("Enter the dividend (signed 2's complement): ");
  scanf("%d", &m);
  printf("Enter the divisor (signed 2's complement): ");
  scanf("%d", &q);

  booth_division(m, q, num_bits);
  booth_multiplication(m, q, num_bits);

  return 0;
}
