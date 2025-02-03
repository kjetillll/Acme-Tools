# make test
# perl Makefile.PL; make; perl -Iblib/lib t/52_comb.t

use lib '.'; BEGIN{require 't/common.pl'}
use Test::More;
plan tests => 13;
is_deeply( [ comb( [10,20,30,40,50], 3 ) ],
	   [ [10, 20, 30],
	     [10, 20, 40],
	     [10, 20, 50],
	     [10, 30, 40],
	     [10, 30, 50],
	     [10, 40, 50],
	     [20, 30, 40],
	     [20, 30, 50],
	     [20, 40, 50],
	     [30, 40, 50] ] );
is_deeply( [ comb([],5) ], [] );
is_deeply( [ comb([1..10],10) ], [[1..10]] );
is_deeply( [ comb([1..10],11) ], [] );
is_deeply( [ comb([1..10],1) ], [map[$_],1..10] );
is_deeply( [ comb([1..10],9) ], [map{//;[grep$'!=$_,1..10]}reverse 1..10] );
for my $k (1..7){
    my $n=$k*2-1;
    my $c=0+comb([1..$n],$k);
    is( $c, fak($n)/(fak($k)*fak($n-$k)), "n: $n   k: $k   count: $c");
}
sub fak { my $n=pop; $n?$n*fak($n-1):1 }
#print srlz($r,'r','',1);
