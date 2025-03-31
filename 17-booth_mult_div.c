#include <stdio.h>
#include <stdlib.h>

void booth_multiplication(int m, int q, int n) {
  int m_neg = ~m + 1;
  int q1 = 0;
  int accumulator = 0;
  int q_copy = q;

  for (int i = 0; i < n; i++) {
    printf("Step %d: A=%d Q=%d Q1=%d\n", i + 1, accumulator, q_copy, q1);

    if ((q_copy & 1) == 1 && q1 == 0) {
      accumulator += m;
    } else if ((q_copy & 1) == 0 && q1 == 1) {
      accumulator += m_neg;
    }

    int q0 = q_copy & 1;
    q_copy = (accumulator & 1) << (n - 1) | (q_copy >> 1);
    accumulator = (accumulator >> 1) & ((1 << (n - 1)) - 1);

   q1 = q0;
  }

  printf("Final Result: A = %d, Q = %d\n", accumulator, q_copy);
}

void division(int m, int q, int n) {
  int m_neg = ~m + 1;
  int q1 = 0;
  int accumulator = 0;
  int q_copy = q;

  for (int i = 0; i < n; i++) {
    printf("Step %d: A=%d Q=%d Q1=%d\n", i + 1, accumulator, q_copy, q1);

    if ((q_copy & 1) == 1 && q1 == 0) {
      accumulator += m;
    } else if ((q_copy & 1) == 0 && q1 == 1) {
      accumulator += m_neg;
    }

    int q0 = q_copy & 1;
    q_copy = (accumulator & 1) << (n - 1) | (q_copy >> 1);
    accumulator = (accumulator >> 1) & ((1 << (n - 1)) - 1);

    q1 = q0;
  }

  printf("Final Result: A = %d, Q = %d\n", accumulator, q_copy);
}

int main() {
  int m, q;
  int n;

  printf("Enter the number of bits: ");
  scanf("%d", &n);
  printf("Enter the dividend: ");
  scanf("%d", &m);
  printf("Enter the divisor: ");
  scanf("%d", &q);

  division(m, q, n);
  booth_multiplication(m, q, n);
printf("-----------------------------\n");
        printf("Programmed by: Pierce Neupane\n");

  return 0;
}
