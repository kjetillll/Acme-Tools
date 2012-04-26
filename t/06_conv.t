#perl Makefile.PL;make;perl -Iblib/lib t/6_conv.t
use strict;
use warnings;
use Test::More tests => 5;
BEGIN { use_ok('Acme::Tools') };
sub deb($){print STDERR @_ if $ENV{ATDEBUG}}

ok( conv(4,'m','s') == 4*60 );

ok( conv(48,'h','d') == 2 );
print STDERR "48h=".conv(48,'h','d')."\n";
print STDERR "mpg=$_  l/mil=".conv($_,'mpg','l/mil')."\n" for qw/30 40 50 60 70/;

ok( conv(70,'mpg','l/mil')          == 23.5214584/70 );  # 70 miles per gallon = 0.335714285714286 liter_pr_mil
ok( conv(40,'mpg','liter_pr_100km') == 235.214584/40 );
ok( conv(50,'mpg','liter_pr_km')    == 2.35214584/50 );

ok( conv(1,'sqmi','km2')    == 2.589988110336 ); #http://en.wikipedia.org/wiki/Square_mile
ok( conv(1,'sqmi','m2')     == 2589988.110336 );
