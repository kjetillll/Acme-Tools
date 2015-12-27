# make test
# perl Makefile.PL; make; perl -Iblib/lib t/27_tms.t
BEGIN{require 't/common.pl'}
use Test::More tests => 39;

my $t =1450624919; #20151220-16:21:59 Sun
my $t2=1000000000; #20150909-03:46:40 Sun
my $t3=1560000000; #20190608-15:20:00 Sat

#my @lt=localtime($t);
#print tms($t),"<<- ".tms()."\n";
ok( tms()   eq tms(   'YYYYMMDD-HH:MI:SS') ,'no args');
ok( tms($t) eq tms($t,'YYYYMMDD-HH:MI:SS') ,'one arg');

sub tst {my($fasit,@arg)=@_;my $tms=tms(@arg); ok($tms eq $fasit, "$fasit = $tms")}
tst('16:21:59',          'HH:MI:SS',$t);
tst('16:21',             'HH:MI',$t);
tst('2015',              'YYYY',$t);
tst('2015',              $t,'YYYY');
tst('2015-DEC-20',       $t,'YYYY-MON-DD');
tst('2015-Dec-20',       $t,'YYYY-Mon-DD');
tst('2015-dec-20',       $t,'YYYY-mon-DD');
tst('Sunday 12/20-2015', $t,'Day MM/D-YYYY');
tst('Sunday 09/9-2001',  $t2,'Day MM/D-YYYY');
tst('Sun 09/9-2001',     $t2,'Dy MM/D-YYYY');
tst('Sun 9/09-2001',     $t2,'Dy M/DD-YYYY');
tst('Sat 6/8-2019',      $t3,'Dy M/D-YYYY');
tst('sat 8/6-2019',      $t3,'dy D/M-YYYY');

tst('04:21 pm',  $t,'HH12:MI pm');
tst('04:21 pm',  $t,'HH12:MI am');
tst('04:21 PM',  $t,'HH12:MI PM');
tst('04:21 PM',  $t,'HH12:MI AM');
tst('03:46 am',  $t2,'HH12:MI pm');
tst('03:46 am',  $t2,'HH12:MI am');
tst('03:46 AM',  $t2,'HH12:MI PM');
tst('03:46 AM',  $t2,'HH12:MI AM');

tst('1971',6e7,'CCYY');tst('20',16e8,'CC');tst('21',6e9,'CC');
tst('7',$t,'dow');tst('6',$t3,'dow');
tst('0',$t,'d0w');tst('6',$t3,'d0w');tst('0',$t,'dow0');tst('6',$t3,'dow0');

tst('59',    $t+0.1,'SS');
tst('59.100',$t+0.1,'SS.3');
tst('59.00090',$t+0.0009,'SS.5');
tst('59.000',$t,'SS.3');

tst('354',$t,'doy');tst('353',$t,'doy0');tst('353',$t,'d0y');

