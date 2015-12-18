# make test
# perl Makefile.PL; make; perl -Iblib/lib t/27_tms.t

# TODO: much!

BEGIN{require 't/common.pl'}
use Test::More tests => 3;
#print time_fp(),"\n";
my $t=time();
my @lt=localtime($t);
ok( tms('HH:MI:SS',$t) eq sprintf("%02d:%02d:%02d",@lt[2,1,0]) ); #hm
ok( tms('HH:MI',$t)    eq sprintf("%02d:%02d",     @lt[2,1]) );
ok( tms('YYYY')        == $lt[5]+1900 );
#print time_fp(),"\n";
#print tms(),"\n";
