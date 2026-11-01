# make test
# perl Makefile.PL && make && perl -Iblib/lib t/54_polyarea.t

use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 8;

is( polyarea([6, 8], [4, 6], [2, 6], [4, 4], [4, 2], [8, 4], [10, 6])  => 11 * 2 );
is( polyarea([3, 4], [2, 3], [1, 3], [2, 2], [2, 1], [4, 2], [5, 3])   => 11 / 2 );

is( polyarea([1, 6], [8, 5], [4, 4], [7, 2], [3, 1]        ) => 16.5 );
is( polyarea([1, 6], [8, 5], [4, 4], [7, 2], [3, 1], [1, 6] ) => 16.5 );

is( polyarea([5, 11], [12, 8], [9, 5], [5, 6], [3, 4] ) => 30 );

is( polyarea([2, 7], [10, 1], [8, 6], [11, 7], [7, 10] ) => 32 );

is( polyarea([4, 10], [9, 7], [11, 2], [2, 2]   ) => 45.5 );
is( polyarea([0, 4], [5, 1], [7, -4], [-2, -4] ) => 45.5 );   # skewed -4 and -6, also works for negative and zeros
