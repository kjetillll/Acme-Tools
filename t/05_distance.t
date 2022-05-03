#perl Makefile.PL;make;perl -Iblib/lib t/05_distance.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 5;

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
