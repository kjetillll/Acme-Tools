# make && perl -Iblib/lib t/39_sim.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests    => 70;
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

#is( jarosim('CRATE','TRACE'), 11/15, 11/15 ); #0.73333333
is( jarosim('DWAYNE','DUANE'), 37/45, "DWAYNE DUANE 0.82222222 37/45" );
is( jarosim('MARTHA',    'MARHTA')*18, 17, "MARTHA MARHTA 0.9444444444 17/18");
is( jarosim('DIXON',     'DICKSONX'), 0.7666666666666666, "DIXON DICKSONX 0.7666666666666666");
is( jarosim('JELLYFISH', 'SMELLYFISH'), 0.896296296296296, "JELLYFISH SMELLYFISH 0.896296");
#is( jarosim('JELLYFISH', 'SMELLYFISH'), 0.812962962962963, "JELLYFISH SMELLYFISH 0.812963 = 439/540");
is( jarosim('ARNAB','ARANB'), 0.933333333333333, "arnab aranb 0.933333333333333");
#exit;

print "--------------------jaro-winkler-similarity\n";

#sub jwtst {}
sub jwtst {is( jarowinklersim($_[0],$_[1]),$_[2],"wink: $_[0] | $_[1]   $_[2] $_[3]")}

jwtst('CRATE','TRACE', 0.733333333333333, "11/15" );
jwtst('DWAYNE','DUANE', 0.84);
jwtst('MARTHA',    'MARHTA', 0.961111111111111);
jwtst('DIXON',     'DICKSONX', 0.813333333333333);
jwtst('JELLYFISH', 'SMELLYFISH', 0.896296296296296);
#jwtst('ARNAB','ARANB', 0.933333333333333);
jwtst('TRATE','TRACE', 0.906666666666667);
#jwtst('i walked to the store', 'the store walked to i', 0.7553688141923436);
#jwtst('banana','bandana', 0.9523809523809524);

#--oracle, https://docs.oracle.com/cd/E18283_01/appdev.112/e16760/u_match.htm#CHDEFJFC
jwtst('dunningham', 'cunnigham', 0.896296296296296);# 80
jwtst('abroms', 'abrams', 0.922222222222222);# 83
jwtst('lampley', 'campley', 0.904761904761905);# 86
jwtst('marhta', 'martha', 0.961111111111111);# 67
jwtst('jonathon', 'jonathan', 0.95);# 88
jwtst('jeraldine', 'geraldine', 0.925925925925926);# 89

__END__
use Text::Levenshtein 'distance';
for(1..3000){
  my($s1,$s2)=map join('',map random(['a'..'z']),1..random(0,10)),1..2;
  my($ld1,$ld2)=map&$_($s1,$s2),*levdist,*distance;
  is( $ld1, $ld2, "$s1 $s2 $ld1 $ld2" );
}
