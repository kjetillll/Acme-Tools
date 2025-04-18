# make && perl -Iblib/lib t/39_sim.t	
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests    => 79;
eval 'require String::Similarity';
if($@){ map ok(1,'skip -- String::Similarity is missing'),1..21 }
else {
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
}
sub is_approx { my($got,$exp,$msg)=@_; my $margin=30/31; between($got/$exp, $margin,1/$margin) ? ok(1,$msg) : is($got,$exp,$msg) }
my($F,$T)=(0.999999,1.000001);
sub _tst    {my$d=&{"$_[0]"}($_[1],$_[2]); my$e=eval$_[3]; ok(btw($d?$d/$e:$e==0,$F,$T),do{my$s="$_[0]: $_[1] vs $_[2] exp $e ($_[3]) got $d";$s=~s/(\S+) \(\1\)/$1/;$s})}
sub ltst    {_tst('levdist',@_)}
sub jtst    {_tst('jsim'   ,@_)}
sub jwtst   {_tst('jwsim'  ,@_)}

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

#---- jaro-similarity
jtst('CRATE',      'TRACE',      '11/15');    # 0.73333333
jtst('DWAYNE',     'DUANE',      '37/45');    # 0.82222222222222
jtst('MARTHA',     'MARHTA',     '17/18');    # 0.94444444444444
jtst('DIXON',      'DICSONX',    '83/105');   # 0.79047619047619
jtst('JELLYFISH',  'SMELLYFISH', '121/135');  # 0.896296296296296
#jtst('JELLYFISH', 'SMELLYFISH', '439/540');  # 0.812962962962963
jtst('ARNAB',      'ARANB',      '14/15');    # 0.933333333333333
jtst('x',          'yy',          0);         # 0
jtst('abcdef',     'ghiajk',      0);         # 0
jtst('abcdef',     'ghaijk',     '4/9');      # 0.444444444444444
jtst('abcdef',     'gahijk',     '4/9');      # 0.444444444444444

#---- jaro-winkler-similarity
jwtst('CRATE',                 'TRACE',                 '11/15' );    # 0.733333333333333
jwtst('DWAYNE',                'DUANE',                 '21/25');     # 0.84
jwtst('MARTHA',                'MARHTA',                '173/180');   # 0.961111111111111
jwtst('DIXON',                 'DICKSONX',              '61/75');     # 0.813333333333333
jwtst('JELLYFISH',             'SMELLYFISH',            '121/135');   # 0.896296296296296
#jwtst('ARNAB',                'ARANB',                 '14/15');     # 0.933333333333333
jwtst('TRATE',                 'TRACE',                 '68/75');     # 0.906666666666667
jwtst('i walked to the store', 'the store walked to i', '1597/2142'); # 0.745564892623716 0.7553688141923436?
jwtst('banana',                'bandana',               '29/30');     # 0.966666666666667 0.9523809523809524?

#---- oracle, https://docs.oracle.com/cd/E18283_01/appdev.112/e16760/u_match.htm#CHDEFJFC
jwtst('dunningham', 'cunnigham', 0.896296296296296);   # 80
jwtst('abroms', 'abrams', 0.922222222222222);          # 83
jwtst('lampley', 'campley', 0.904761904761905);        # 86
jwtst('marhta', 'martha', 0.961111111111111);          # 67
jwtst('jonathon', 'jonathan', 0.95);                   # 88
jwtst('jeraldine',  'geraldine', 0.925925925925926);   # 89
_tst('jwsim02','marhta', 'martha', 0.977777777777778); # 67
_tst('jwsim00','marhta', 'martha', 0.944444444444445); # 67
sub jwsim02{jwsim(@_[0,1],0.2)}
sub jwsim00{jwsim(@_[0,1],0.0)}

__END__
use Text::Levenshtein 'distance';
for(1..3000){
  my($s1,$s2)=map join('',map random(['a'..'z']),1..random(0,10)),1..2;
  my($ld1,$ld2)=map&$_($s1,$s2),*levdist,*distance;
  is( $ld1, $ld2, "$s1 $s2 $ld1 $ld2" );
}
