#perl Makefile.PL;make;perl -Iblib/lib t/8_eta.t
use strict;
use warnings;
use Test::More tests => 2;
BEGIN { use_ok('Acme::Tools') };
sub deb($){print STDERR @_ if $ENV{ATDEBUG}}
ok(1);

eta("x",6,10,70);
print eta("x",8,10,80)," <---\n";


for(1..20){
  printf "%2d   %-20s   %-20s\n", $_, time_fp(), eta("",$_,20)||"";
  my $start=time_fp;
  sleep_fp(0.02);
  my $now=time_fp;
#  print "$now ".($now-$start)."\n";
}