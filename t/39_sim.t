# make && perl -Iblib/lib t/39_sim.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests    => 77;
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

ltst( 'elephant', 'elepanto',   2 );
ltst( 'elephant', 'elephapntv', 2 );
ltst( 'elephant', 'elephapntt', 2 );
ltst( 'elephant', 'lephapnt',   2 );
ltst( 'elephant', 'blemphant',  2 );
ltst( 'elephant', 'lmphant',    2 );
ltst( 'elephant', 'velepphant', 2 );
ltst( 'elephant', 'vlepphan',   3 );
ltst( 'elephant', 'elephant',   0 );
ltst( 'elephant', 'lephant',    1 );
ltst( 'elephant', 'leowan',     4 );
ltst( 'elephant', 'leowanb',    4 );
ltst( 'elephant', 'mleowanb',   4 );
ltst( 'elephant', 'leowanb',    4 );
ltst( 'elephant', 'leolanb',    4 );
ltst( 'elephant', 'lgeolanb',   5 );
ltst( 'elephant', 'lgeodanb',   5 );
ltst( 'elephant', 'lgeodawb',   6 );
ltst( 'elephant', 'mgeodawb',   6 );
ltst( 'elephant', 'mgeodawb',   6 );
ltst( 'elephant', 'mgeodawm',   6 );
ltst( 'elephant', 'mygeodawm',  7 );
ltst( 'elephant', 'myeodawm',   6 );
ltst( 'elephant', 'myeodapwm',  7 );
ltst( 'elephant', 'myeoapwm',   7 );
ltst( 'elephant', 'myoapwm',    8 );
ltst( 'kitten', 'sitting',  3 );
ltst( 'abc', 'cba',  2 );
ltst( '', 'cba',     3 );
ltst( 'cba', '',     3 );
ltst( '', '',        0 );
ltst( 'abc', 'abc',  0 );
#ltst( undef, 'cba', 3 );
#ltst( 'cba', undef, 3 );

#print "--------------------jaro-similarity\n";
jtst('CRATE','TRACE', 11/15);#, 11/15 ); #0.73333333
jtst('DWAYNE','DUANE', 37/45);#, "DWAYNE DUANE 0.82222222 37/45" );
jtst('MARTHA',    'MARHTA',0.944444444444445);#, "MARTHA MARHTA 0.9444444444 17/18");
jtst('DIXON',     'DICKSONX', 0.7666666666666666);#, "DIXON DICKSONX 0.7666666666666666");
jtst('JELLYFISH', 'SMELLYFISH', 0.896296296296296);#, "JELLYFISH SMELLYFISH 0.896296");
#jtst('JELLYFISH', 'SMELLYFISH', 0.812962962962963);#, "JELLYFISH SMELLYFISH 0.812963 = 439/540");
jtst('ARNAB','ARANB', 0.933333333333333);#, "arnab aranb 0.933333333333333");
jtst('x','yy', 0);#, "x yy 0");
jtst('abcdef','ghiajk', 0);#, "abcdef ghiaka 0");
jtst('abcdef','ghaijk', 0.444444444444444);#, "abcdef ghaika 0.444444444444444");
jtst('abcdef','gahijk', 0.444444444444444);#, "abcdef ghaika 0.444444444444444");
#exit;

#print "--------------------jaro-winkler-similarity\n";

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
jwtst('jeraldine',  'geraldine', 0.925925925925926);# 89
jwtst02('marhta', 'martha', 0.977777777777778);# 67
jwtst00('marhta', 'martha', 0.944444444444445);# 67

sub ltst    {is( levdist($_[0],$_[1]),$_[2],"levdist: $_[0] | $_[1]   $_[2] $_[3]")}
sub jtst    {is( jsim($_[0],$_[1]),$_[2],"jsim: $_[0] | $_[1]   $_[2] $_[3]")}
sub jwtst   {is( jwsim($_[0],$_[1]    ),$_[2],"jwsim: $_[0] | $_[1]   $_[2] $_[3]")}
sub jwtst02 {is( jwsim($_[0],$_[1],0.2),$_[2],"jwsim: $_[0] | $_[1] | 0.2    $_[2] $_[3]")}
sub jwtst00 {is( jwsim($_[0],$_[1],0.0),$_[2],"jwsim: $_[0] | $_[1] | 0.0    $_[2] $_[3]")}

__END__
use Text::Levenshtein 'distance';
for(1..3000){
  my($s1,$s2)=map join('',map random(['a'..'z']),1..random(0,10)),1..2;
  my($ld1,$ld2)=map&$_($s1,$s2),*levdist,*distance;
  is( $ld1, $ld2, "$s1 $s2 $ld1 $ld2" );
}
