# make test
# perl Makefile.PL; make; perl -Iblib/lib t/37_cmd_resubst.t

use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests    => 1;
warn <<"" and map ok(1),1..1 and exit if $^O!~/^(linux|cygwin)$/;
Tests for cmd_due not available for $^O, only linux and cygwin

my $tmp=tmp();
srand(7);
writefile("$tmp/$_",join("",map{"$_ ".($_%10?"":rand())."\n"}1..100)) for 1..20;
my $p=printed{Acme::Tools::cmd_resubst('-v','-f',6,map"$tmp/$_",1..20)};
$p=~s,tmp/\w+,tmp/x,g;print$p;
ok($p eq <<"");
 1/20     26     26     560b =>     534b /tmp/x/1
 2/20     50     24     563b =>     539b /tmp/x/2
 3/20     78     28     564b =>     536b /tmp/x/3
 4/20    105     27     565b =>     538b /tmp/x/4
 5/20    131     26     565b =>     539b /tmp/x/5
 6/20    158     27     563b =>     536b /tmp/x/6
 7/20    181     23     565b =>     542b /tmp/x/7
 8/20    205     24     560b =>     536b /tmp/x/8
 9/20    231     26     564b =>     538b /tmp/x/9
10/20    256     25     563b =>     538b /tmp/x/10
11/20    281     25     563b =>     538b /tmp/x/11
12/20    306     25     561b =>     536b /tmp/x/12
13/20    334     28     562b =>     534b /tmp/x/13
14/20    362     28     564b =>     536b /tmp/x/14
15/20    387     25     562b =>     537b /tmp/x/15
16/20    415     28     562b =>     534b /tmp/x/16
17/20    443     28     562b =>     534b /tmp/x/17
18/20    471     28     563b =>     535b /tmp/x/18
19/20    498     27     562b =>     535b /tmp/x/19
20/20    523     25     560b =>     535b /tmp/x/20
