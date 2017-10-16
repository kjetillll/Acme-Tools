# make test
# perl Makefile.PL; make; perl -Iblib/lib t/36_cmd_due.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests    => 1;
warn <<"" and map ok(1),1..1 and exit if $^O!~/^(linux|cygwin)$/;
Tests for cmd_due not available for $^O, only linux and cygwin

my $tmp=tmp();
my %f=( a=>10, b=>20, c=>30 );
my $i=1;
for my $ext (qw( .gz .xz .TXT .doc .doc.gz),""){
  writefile("$tmp/$_$ext","x" x ($f{$_}*$i++)) for sort(keys%f);
}
#print qx(find $tmp -ls),"\n" if $ENV{ATDEBUG}; #!deb()
my $p=printed {
  Acme::Tools::cmd_due('-Mihz',$tmp)
};
my $ok=repl(<<'','ymd',tms('YYYY/MM/DD'));
.gz               3          140 B    3.95%  ymd ymd ymd
.xz               3          320 B    9.04%  ymd ymd ymd
.txt              3          500 B   14.12%  ymd ymd ymd
.doc              3          680 B   19.21%  ymd ymd ymd
.doc.gz           3          860 B   24.29%  ymd ymd ymd
                  3        1.02 kB   29.38%  ymd ymd ymd
Sum              18        3.46 kB  100.00%  ymd ymd ymd

ok($p eq $ok, 'due -Mihz');
deb("$p\n!=\n$ok\n") if $p ne $ok;
