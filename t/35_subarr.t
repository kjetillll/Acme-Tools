# make test
# perl Makefile.PL && make && perl -Iblib/lib t/35_subarr.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 29;
my @a=qw(e1 e2 e3 e4 e5);

#if( $] >=5.014 ){
#  ok_str( join("+",subarr(@a,1,2)),       'e2+e3' );
#  ok_str( join("+",subarr(@a,-2,2)),      'e4+e5' );
#  ok_str( join("+",subarr(@a,-2)),        'e4+e5' );
#  ok_str( join("+",subarr(@a,-1)),        'e5'    );
#  ok_str( join("+",subarr(@a,-100)),      'e1+e2+e3+e4+e5' );
#  ok_str( join("+",subarr(@a,1,1000)),    'e2+e3+e4+e5'    );
#  ok_str( join("+",subarr(@a,-100,1000)), 'e1+e2+e3+e4+e5' );
#  ok_str( join("+",subarr\@a,-100,1000 ), 'e1+e2+e3+e4+e5' );
#}
#else{
  ok_str( join("+",subarr(\@a,1,2)),        'e2+e3' );
  eval{subarr(@a,1,2)};
  ok( $@ =~ /^subarr: first arg not array ref at / );
  ok_str( join("+",subarr(\@a,-2,2)),       'e4+e5' );
  ok_str( join("+",subarr(\@a,-2)),         'e4+e5' );
  ok_str( join("+",subarr(\@a,-1)),         'e5'    );
  ok_str( join("+",subarr(\@a,-100)),       'e1+e2+e3+e4+e5' );
  ok_str( join("+",subarr(\@a,1,1000)),     'e2+e3+e4+e5'    );
  ok_str( join("+",subarr(\@a,-100,1000)),  'e1+e2+e3+e4+e5' );
  ok_str( join("+",subarr(\@a,-100,1000) ), 'e1+e2+e3+e4+e5' );
  ok_str( join("+",subarr(\@a,-10,-1000) ), 'e1+e2+e3+e4+e5' );
  ok_str( join("+",subarr(\@a,3,-1) ),      'e4' );
  ok_str( join("+",subarr(\@a,-4,-2) ),     'e2+e3' );
  ok_str( join("+",subarr \@a,-3,2,'x3','x4','x5' ), 'e3+e4' );
  ok_str( join("+",@a), 'e1+e2+x3+x4+x5+e5' );
  subarr(\@a,3,1,undef);
  ok_str( join("+",map defined($_)?$_:'',@a), 'e1+e2+x3++x5+e5' );

  #--pod example
  my $ref = [1..10];
  @arr = subarr( $ref, -6, -4, qw(X Y ZZ) );
  ok_str( join("+",@$ref), '1+2+3+4+X+Y+ZZ+7+8+9+10' );
  ok_str( join("+",@arr), '5+6' );
#}

my @a2=subarrays( 'a', 'bb', 'c' );
is( repl(srlz(\@a2),"\n"),
    "(['a'],['bb'],['a','bb'],['c'],['a','c'],['bb','c'],['a','bb','c'])" );

is( 2**$_-1, 0+subarrays(1..$_) ) for 0..10;

