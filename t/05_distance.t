#perl Makefile.PL;make;perl -Iblib/lib t/5_distance.t
use strict;
use warnings;
use Test::More tests => 4;
BEGIN { use_ok('Acme::Tools') };
sub deb($){print STDERR @_ if $ENV{ATDEBUG}}

#--oslo-rio = 16.210 meter iflg http://www.daftlogic.com/projects-google-maps-distance-calculator.htm
my @oslo=(59.933983, 10.756037);
my @rio=(-22.97673,-43.19508);

deb sprintf "%.9f km\n",   distance(@oslo,@rio)/1000;     # 10431.5 km
deb sprintf "%.1f km\n",   distance(@rio,@oslo)/1000;     # 10431.5 km
deb sprintf "%.1f nmi\n",  distance(@oslo,@rio)/1852.000; # 5632.5 nmi   (nautical miles)
deb sprintf "%.1f miles\n",distance(@oslo,@rio)/1609.344; # 6481.8 miles

ok(between(distance(@oslo,@rio), 10_431_400, 10_431_500));
ok(abs(distance(@oslo,@rio) - distance(@rio,@oslo))<=0.1);


ok(1);

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

