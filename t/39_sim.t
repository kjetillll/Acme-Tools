# make && perl -Iblib/lib t/39_sim.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests    => 53;
eval 'require String::Similarity';
map ok(1,'skip -- String::Similarity is missing'),1..21 and exit if $@;
for(map[map trim,split/\|/],split/\n/,<<""){
  Humphrey DeForest Bogart | Bogart Humphrey DeForest | 0.71    |  1.00
  Humphrey Bogart          | Humphrey Gump Bogart     | 0.86    |  1.00
  Humphrey deforest Bogart | Bogart DeForest          | 0.41    |  1.00
  Humfrey DeForest Boghart | BOGART HUMPHREY          | 0.05    |  0.87
  Humphrey                 | Bogart Humphrey          | 0.70    |  1.00
  Humfrey Deforest Boghart | BOGART D. HUMFREY        | 0.15    |  0.78
  Presley, Elvis Aaron     | Elvis Presley            | 0.42424 |  1.00

  my($s1,$s2,$sim,$sim_perm)=@$_;
  ok( $sim < $sim_perm );
  is_approx(sim($s1,$s2), $sim);
  is_approx(sim_perm($s1,$s2), $sim_perm);
}
sub is_approx { my($got,$exp,$msg)=@_; my $margin=30/31; between($got/$exp, $margin,1/$margin) ? ok(1,$msg) : is($got,$exp,$msg) }

is( levdist( 'elephant', 'elepanto'),   2 );
is( levdist( 'elephant', 'elephapntv'), 2 );
is( levdist( 'elephant', 'elephapntt'), 2 );
is( levdist( 'elephant', 'lephapnt'),   2 );
is( levdist( 'elephant', 'blemphant'),  2 );
is( levdist( 'elephant', 'lmphant'),    2 );
is( levdist( 'elephant', 'velepphant'), 2 );
is( levdist( 'elephant', 'vlepphan'),   3 );
is( levdist( 'elephant', 'elephant'),   0 );
is( levdist( 'elephant', 'lephant'),    1 );
is( levdist( 'elephant', 'leowan'),     4 );
is( levdist( 'elephant', 'leowanb'),    4 );
is( levdist( 'elephant', 'mleowanb'),   4 );
is( levdist( 'elephant', 'leowanb'),    4 );
is( levdist( 'elephant', 'leolanb'),    4 );
is( levdist( 'elephant', 'lgeolanb'),   5 );
is( levdist( 'elephant', 'lgeodanb'),   5 );
is( levdist( 'elephant', 'lgeodawb'),   6 );
is( levdist( 'elephant', 'mgeodawb'),   6 );
is( levdist( 'elephant', 'mgeodawb'),   6 );
is( levdist( 'elephant', 'mgeodawm'),   6 );
is( levdist( 'elephant', 'mygeodawm'),  7 );
is( levdist( 'elephant', 'myeodawm'),   6 );
is( levdist( 'elephant', 'myeodapwm'),  7 );
is( levdist( 'elephant', 'myeoapwm'),   7 );
is( levdist( 'elephant', 'myoapwm'),    8 );
is( levdist( 'kitten', 'sitting'),  3 );
is( levdist( 'abc', 'cba'),  2 );
is( levdist( '', 'cba'),     3 );
is( levdist( 'cba', ''),     3 );
is( levdist( '', ''),        0 );
is( levdist( 'abc', 'abc'),  0 );
#is( levdist( undef, 'cba'), 3 );
#is( levdist( 'cba', undef), 3 );

is( jarosim('CRATE','TRACE'), 11/15 ); #0.73333333


__END__
use Text::Levenshtein 'distance';
for(1..3000){
  my($s1,$s2)=map join('',map random(['a'..'z']),1..random(0,10)),1..2;
  my($ld1,$ld2)=map&$_($s1,$s2),*levdist,*distance;
  is( $ld1, $ld2, "$s1 $s2 $ld1 $ld2" );
}
