#perl Makefile.PL && make && perl -Iblib/lib t/05_distance.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 79;

#--oslo-rio = 10434.047 meter says http://www.daftlogic.com/projects-google-maps-distance-calculator.htm

my %gps = (
    oslo    => [ 59.933983,  10.756037],
    rio     => [-22.97673,  -43.19508 ],
    london  => [ 51.507726,  -0.128079],
    jakarta => [ -6.175381, 106.828176],
);
my @test = ( ['oslo', 'rio',     10431.5],
	     ['rio',  'oslo',    10431.5],
	     ['oslo', 'london',   1153.7],
	     ['oslo', 'jakarta', 10935.3],
	     ['oslo', 'oslo',        0.0] );
for(@test){
    my($from,$to,$km_expected) = @$_;
    my($la1,$lo1,$la2,$lo2) = (@{$gps{$from}},@{$gps{$to}});
    my $km = distance($la1,$lo1,$la2,$lo2)/1000;              #meters/1000=km
    my $diff = abs( $km - $km_expected );
    my $info = sprintf"distance %-14s   got: %9.3f km    expects: %9.3f km   diff: %.3f", "$from - $to", $km, $km_expected, $diff;
    ok( $diff <= 0.1, $info );
}

#eval{require Geo::Direction::Distance};
#if($@ or $Geo::Direction::Distance::VERSION ne '0.0.2'){ok(1)}
#else{
#  my($aps1,$aps2,$t);
#  $t=time_fp(); distance(@oslo,@rio) for 1..100000; deb "ant pr sek = ".($aps1=100000/(time_fp()-$t))."\n";
#  $t=time_fp(); Geo::Direction::Distance::latlng2dirdist(@oslo,@rio) for 1..10000; deb "ant pr sek = ".($aps2=10000/(time_fp()-$t))."\n";
#  deb "times faster=".($aps1/$aps2)."\n";
#
#  my $d=(Geo::Direction::Distance::latlng2dirdist(@oslo,@rio))[1]/1000;
#  deb "distance=$d km  time=".(time_fp()-$t)."\n";
#  ok(between($d, 10407.748, 10407.749));
#}


my @t=( #tests
    [+57.64911, 10.40744, undef() => 'u4pruydqq'], #default length 9
    [+57.64911, 10.40744, 11      => 'u4pruydqqvj'],
    [+48.8583,  +2.2945,   8      => 'u09tunqu'],    # Eiffel Tower
    [+40.68925, -74.04450, 8      => 'dr5r7p62'],    # Statue of Liberty
    [+29.9753,  +31.1377,  8      => 'stq4s8cf'],    # The Great Sphinx at Giza
    [-22.95191, -43.21044, 8      => '75cm2txp'],    # Statue of Christ, Brazil
    [+71.17094, +25.78302, 8      => 'usdkfsq8'],    # North Cape
    [+90,       +180,      8      => 'zzzzzzzz'],    # North Pole
    [-90,       -180,      8      => '00000000'],    # South Pole
    [+42.605,   -5.603,    8      => 'ezs42s00'],    # Léon, Spain
    map
    [+40.80551545, -73.96538804, $_ => substr'dr72hukj3e3m',0,$_], # Tom's Restaurant New York
    1..12
    );
for(@t){
    my($lat, $lon, $len, $exp) = @$_;
    my $gh = geohash($lat, $lon, $len);
    is( $gh, $exp, "geohash: $gh" );
    my($hlat,$hlon)=geohash2latlon( $gh );
    my $d=distance($lat,$lon,$hlat,$hlon);
    deb sprintf"lat:  %.10f   lon:  %.10f\n",$lat,$lon;
    deb sprintf"hlat: %.10f   hlon: %.10f\n",$hlat,$hlon;
    deb sprintf"distance: $d m\n";
    my @pr=(0, 2500e3, 630e3, 78e3, 20e3, 2400, 610, 76, 19, 5, 1, 0.25, 0.06); #precision by length
    $len=9 if !defined$len;
    ok( $d < $pr[$len]*1.2, "len: $len   diff dist: $d meter within precision $pr[$len]");
}
eval{ geohash(-91,0)};             ok( $@, caught('south of south pole') );
eval{ geohash2latlon("stq4s8af")}; ok( $@, caught('bad char') );

my @pt=(
    [48.858312, 2.294437          => '8FW4V75V+8Q'], # Eiffel Tower
    [1.286812, 103.854563         => '6PH57VP3+PR'], # default precision = 10
    [1.286812, 103.854563, undef, => '6PH57VP3+PR'], # default precision = 10
    [1.286812, 103.854563, 10,    => '6PH57VP3+PR'], # precision = 10
    [1.286785, 103.854503, 12,    => '6PH57VP3+PR72'], # precision = 12
    [1.286785, 103.854503, 11,    => '6PH57VP3+PR6'], # 72=>6 for 5x4 subdivision
    [1.286785, 103.854503, 8,     => '6PH57VP3+'], #
    [1.286785, 103.854503, 2,     => '6P000000+'], # len 2, 0-padded
    [1.286785, 103.854503, 4,     => '6PH50000+'], #
    [1.286785, 103.854503, 6,     => '6PH57V00+'], #
    [+71.17094, +25.78302         => 'CG375QCM+96'], # North Cape, Norway
    [-22.95191, -43.21044         => '589R2QXQ+6R'], # Statue of Christ, Brazil
    );
for(@pt){
    my($lat,$lon,$precision,$exp);
    ($lat,$lon,$precision,$exp)=@$_ if @$_==4;
    ($lat,$lon,           $exp)=@$_ if @$_==3;
    my $pc;
    is( $pc=pluscode($lat,$lon,$precision), $exp,   sprintf"%-20s -> pluscode $pc","$lat, $lon" );
}
for(@pt){
    next if defined $$_[2] and $$_[2] eq '11'; #todo
    my $exp=$$_[-1];
    my $z=0+$exp=~s/0/0/g;
    my($lat,$lon)=@$_[0,1];
    my($plat,$plon)=pluscode2latlon($exp);
    my $d=distance($lat,$lon,$plat,$plon);
    ok( $d < {0=>300,2=>5000,4=>1e5,6=>1e6}->{$z}, "pluscode2latlon($exp) dist: $d   ($lat,$lon) --> ($plat,$plon)" );
}

my$pcs;
is( $pcs=pluscode_short(-22.95191, -43.21044, 'Rio'), '2QXQ+6R Rio', "pluscode_short: $pcs" );

do{
  local$SIG{__WARN__}=sub{}; #suppress warn/TODO-carp in sub pluscode_short2latlon
  is( pluscode(pluscode_short2latlon('2QXQ+6R Rio',-22.95191, -43.21044)), '589R2QXQ+5R', 'pluscode_short2latlon' ); #hm, +5R not +6R due to precision...
};

eval{ pluscode_short2latlon("xyz") }; ok( $@, caught('bad short code') );

#print srlz(\@pt,'pt','',1);

use Math::Trig;
for my $f ( qw( acos tan ) ){
  my @lst = map rand(2)-1, 1..1e1;
  @lst = $f eq 'acos' ? (-1,0,1,@lst) : (2*$PI,$PI,0,-$PI,-2*$PI,$PI/2,-$PI/2,1,2,3,@lst);
 #my @err = grep !/(=\S+ ).*\1/, map { "Acme::Tools::$f($_) != Math::Trig::$f($_)" =~ s/(\S{3,})\K/'='.eval($1).' '/ger } @lst;
  my @err = grep !/(=\S+ ).*\1/, map { my $str="Acme::Tools::$f($_) != Math::Trig::$f($_)"; $str =~ s/(\S{3,})/$1.'='.eval($1).' '/ge; $str } @lst;
  ok( !@err, $f . ( @err ? " errors: @err" : ""));
}
