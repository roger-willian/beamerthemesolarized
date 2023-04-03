#include <stdio.h>

int fatorial(int n) {
  if (n < 0) return -1;

  int fat_n = 1;
  for(int i = 1; i <= n; i++) {
    fat_n *= i;
  }
  return fat_n;
}

int main() {
  int n = 0;

  puts("Digite um inteiro maior que zero:");
  scanf("%d", &n);

  printf("%d! = %d\n", n, fatorial(n));
  return 0;
}