/*
Generate All Permutations using BackTracking
http://www.sanfoundry.com/cpp-program-generate-permutations-using-backtracking/
time gcc -std=gnu99  test_perm.c && ./a.out ;ls -l a.out 
*/

#include <stdio.h>
void swap (char *x, char *y) { char temp; temp = *x; *x = *y; *y = temp;}
void permute (char *a, int i, int n) {
    if (i == n)  printf("%s\n",a);
    else {
      for (int j = i; j <= n; j++) {
	swap(a+i, a+j);
	permute(a, i+1, n);
	swap( a+i, a+j);
      }
    }
}
int main() {
  //char a[] = "abcdefghijk"; permute(a, 0, 10);
  char a[] = "abcdefghij"; permute(a, 0, 9);
  //char a[] = "abcd"; permute(a, 0, 3);
  return 0;
}
