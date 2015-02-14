# make test
# perl Makefile.PL; make; perl -Iblib/lib t/21_read_conf.t

BEGIN{require 't/common.pl'}
use Test::More tests => 1;

my $c=<<"END";
#tester
hei: fdas #heihei
hopp: and u dont stoppp #
#dfsa
dfsa

dsa
[section1]  #
hei: fds1 312321 123321
båt: 4231
bil: 213+123
sykkel: sdfkdsa

 [section2]

hei: fds1 312321 123321
båt: 4231
bil= 213+123:2=1  #: and = are ok in values
sykkel: sdfkdsa
 [section3]
END

my %c;
read_conf(\$c,\%c);
my %fasit=(
  ''        =>{'hei'=>'fdas',
               'hopp'=>'and u dont stoppp'},
  'section1'=>{'bil'=>'213+123',
               'båt'=>'4231',
               'hei'=>'fds1 312321 123321',
               'sykkel'=>'sdfkdsa'
              },
  'section2'=>{'bil'=>'213+123:2=1',
               'båt'=>'4231',
               'hei'=>'fds1 312321 123321',
               'sykkel'=>'sdfkdsa'
              },
  'section3'=>{}
);
my $f=serialize(\%fasit,'c','',2);
my $s=serialize(\%c,'c','',2);
#print $s;
ok($s eq $f);

#writefile('/tmp/t1',"hei\n);
#writefile('/tmp/t',<<"");
#[sec1]
#abc: xyz
#
#<INCLUDE inc.conf>
