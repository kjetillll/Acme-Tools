# tms() and other time stuff
# make test
# perl Makefile.PL && make && perl -Iblib/lib t/27_timestuff.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More;
use Digest::MD5 'md5_hex';
my $skip_all=$^O=~/(?<!cyg)win/i && !$ENV{ATSLEEP};
if( $skip_all ) { plan skip_all => 'POSIX::tzset not ok on windows'  }
else            { plan tests    => 70                                }

$ENV{TZ}='CET';
#$ENV{TZ}='Europe/Oslo';
#$ENV{TZ}='Asia/Kolkata';
require POSIX; POSIX::tzset();

my $t =1450624919; #20151220-16:21:59 Sun
my $t2=1000000000; #20150909-03:46:40 Sun
my $t3=1560000000; #20190608-15:20:00 Sat
my $t4=-1e9;       #19380424-23:13:20
my $t5=-9e9;       #16841019-09:00:00
my $t6=+9e9;       #22550314-17:00:00

#my @lt=localtime($t);
#print tms($t),"<<- ".tms()."\n";
ok( tms()   eq tms(   'YYYYMMDD-HH:MI:SS') ,'no args');
ok( tms($t) eq tms($t,'YYYYMMDD-HH:MI:SS') ,'one arg');
is( tms("epoch",tms("YYYY-MM-DDTHH24:MI:SS",$_)), $_,
    qq(is(tms("epoch",tms("YYYY-MM-DDTHH24:MI:SS",$_)),$_)).' '.tms('YYYYMMDD-HH24:MI:SS',$_))
  for $t,$t2,$t3,$t4,$t5,$t6,time();


sub tst {my($fasit,@arg)=@_;my $tms=tms(@arg); is($tms, $fasit, "$fasit = $tms")}
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

tst('1971',6e7,'CCYY');tst('20',16e8,'CC');
#tst('21',6e9,'CC'); #ok in newer perls

tst('7',$t,'dow');tst('6',$t3,'dow');
tst('0',$t,'d0w');tst('6',$t3,'d0w');tst('0',$t,'dow0');tst('6',$t3,'dow0');

tst('59',      $t+0.1,    'SS');
tst('59',      $t+0.1,    'SS.0');
tst('59.00',   $t,        'SS.2');
tst('59.100',  $t+0.1,    'SS.3');
tst('59.00090',$t+0.0009, 'SS.5');
tst('59.000',  $t,        'SS.3');

tst('354',$t,'doy');tst('353',$t,'doy0');tst('353',$t,'d0y');

#--------------------------------------------------------------------------------

my $tt='20151229-19:13';

# more

#-- easter
ok( '384f0eefc22c35d412ff01b2088e9e05' eq  md5_hex( join",", map{easter($_)} 1..5000), 'easter');

sub EasterSunday { #https://no.wikipedia.org/wiki/P%C3%A5skeformelen
  my $year=shift;
  my $a = $year % 19;
  my $b = int($year/100);
  my $c = $year % 100;
  my $d = int($b/4);
  my $e = $b % 4;
  my $f = int(($b+8)/25);   
  my $g = int(($b-$f+1)/3);
  my $h = (19*$a+$b-$d-$g+15) % 30;      
  my $i = int($c/4);
  my $k = $c % 4;
  my $l = (32 + 2*$e + 2*$i - $h - $k) % 7;
  my $m = int(($a+11*$h+22*$l)/451);
  my $n = int(($h+$l-7*$m+114)/31);
  my $p = ($h+$l-7*$m+114) % 31;
  (++$p,$n);
}
my @diff;
for(1498..1e4){ #1498..1e7 ok also!
  my $e1=join",",easter($_);
  my $e2=join",",EasterSunday($_);
  push @diff, "easter year $_ e1=$e1 e2=$e2" if $e1 ne $e2;
}
ok(@diff==0,'easter formula1 and 2 eq from year 1498 to 10000');

#--time_fp
ok( time_fp() =~ /^\d+\.\d+$/ , 'time_fp' );

#--sleep_fp
SKIP: {
  skip 'sleep_fp-tests',2 unless $ENV{ATSLEEP};  #some systems fails...virtual boxes? un-linux-es?
  my $test_sleep=sub{
    my($exp,$test)=@_;
    my $tfp=time_fp();
    &$test;
    $got=time_fp()-$tfp;
    my $p=100*abs(($got-$exp)/$exp); #percent
    ok($p < 30, sprintf"sleep_fp, got %.7fs vs %.7fs, %.1f%% off, < 30%% off is ok",$got,$exp,$p);
  };
  require Time::HiRes; #init
  &$test_sleep(0.001,sub{sleep_fp(0.001)});
  &$test_sleep(4*0.01,sub{
    sleeps(0.010);     #seconds
    sleepms(10);       #milliseconds 1e-3
    sleepus(10000);    #microseconds 1e-6 (10000 μs)
    sleepns(10000000); #nanoseconds  1e-9
  });
}

if(eval{require Date::Parse}){
  is(s2t("18/februar/2019:13:53","MM"),'02','s2t MM');
  is(join(" ; ",s2t("18/februar/2019:13:53","DD","MM","YYYY","YYYYMMDD-HH24:MI:SS")), '18 ; 02 ; 2019 ; 20190218-13:53:00','s2t...');
  is( s2t($$_[1]), $$_[0], "ok s2t('$$_[1]')" ) for map[split/\s/,$_,2],grep$_,map trim,split"\n","
  1555588437 20190418-13:53:57
  1555588437 2019-04-18T13:53:57
  1555588437 18. april 2019 13:53:57
  1555588437 18/Apr/2019:13:53:57
  1555588437 1555588437
  1555588437 1555588437001
  1555588380 20190418-13:53
  1555588380 2019-04-18T13:53
  1555588380 18. april 2019 13:53
  1555588380 18/Apr/2019:13:53
  1558180380 18/Mai/2019:13:53
  1558180380 18/May/2019:13:53
  1550494380 18/februar/2019:13:53
  1550494380 18/February/2019:13:53
  1000000000 9/Sep/2001:03:46:40
  1000000000 9/9/2001:03:46:40"
} else { ok(1) for 1..18 }


__END__
http://stackoverflow.com/questions/753346/how-do-i-set-the-timezone-for-perls-localtime
https://en.wikipedia.org/wiki/Tz_database
perl -MPOSIX -le'      print for tzname' #GMT GMT
perl -MPOSIX -le'tzset;print for tzname' #CET CEST
