#perl Makefile.PL;make;perl -Iblib/lib t/06_conv.t
#perl -I/ext t/06_conv.t
use strict;
use warnings;
use Test::More tests => 25;
BEGIN { use_ok('Acme::Tools') };
sub deb($){print STDERR @_ if $ENV{ATDEBUG}}

check( 1, 'cm', 'mm', 10);
check( 2.1, 'km', 'm', 2100);
check( 4, 'm', 's', 4*60 );
check( 48,'h','d', 2 );
deb "48h=".conv(48,'h','d')."\n";
deb "mpg=$_  l/mil=".conv($_,'mpg','l/mil')."\n" for qw/30 40 50 60 70/;

check(70,'mpg','l/mil',          23.5214584/70 );  # 70 miles per gallon = 0.335714285714286 liter_pr_mil
check(40,'mpg','liter_pr_100km', 23.5214584*10/40 );
ok( conv(50,'mpg','liter_pr_km')    == 2.35214584/50 );

check(1,'sqmi','km2', 2.589988110336 ); #http://en.wikipedia.org/wiki/Square_mile
check(1,'sqmi','m2',  2.589988110336e6 ); #hmm

check(48,'h','d', 2 );
check(36,'USD','NOK', 36*6.215 );
check(36,'NOK','USD', 36/6.215 );
#warn conv(4000,'NOK','BTC');
#warn conv(0.00227491,'LTC','NOK');

check( 1, "W", "BTU/h", 3600/1055.05585262 );
check( 1, "BTU/h", "W", 1055.05585262/3600 ); #0.29307107
check( 1, "BTU/h", "mW",1055055.85262/3600 ); #293.07107
check( 1, "BTU/s", "W", 1055.05585262      );

check( 4.2766288,"lp100km","mpg",      55 ); #hmm
check( 58, "mpg", "lp100km", 4.05542386206896 );

check( 41, "F", "C", 5 );
check( 50, "F", "C", 10 );
check( 5,  "C", "F", 41 );
check( 10, "C", "F", 50 );
check( 273.15, "K", "C", 0 );
check( 0,      "C", "K", 273.15 );

sub check {
  my($n, $from, $to, $answer) = @_;
  my $c=conv( $n, $from => $to );
  my $eq=sub{$_[0]==$_[1] or between($_[0]/$_[1],1-1e-6,1+1e-6)};
  ok( &$eq($c,$answer),   sprintf("%10s %-10s  =>  %10s %-10s     should be %10s %s",$n,$from,$c,$to,$answer,$to) );
}
