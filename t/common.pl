use strict;
use warnings;
#use Test::More;
use Acme::Tools 0.24;
#todo: faster make test, group some *.t together, 6s is too long
sub deb($) { no warnings; print STDERR @_ if $ENV{ATDEBUG} } #no w, Wide char in print...
sub tmp    { require File::Temp;File::Temp::tempdir(CLEANUP=>$ENV{ATDEBUG}?0:1,@_) }
sub ok_ca  { ok( abs( 1 - $_[0]/$_[1] ) < 1e-4, $_[2]) }
sub ok_str { my($s1,$s2)=@_; if($s1 eq $s2){ ok(1) }else{ ok(0,"s1: $s1   not eq   s2: $s2") } }
sub ok_ref {
  my($s1,$s2) = map serialize($_),@_[0,1];
  my $ok = ok($s1 eq $s2, $_[2]) or deb "s1=$s1\ns2=$s2\n";
  $ok
}
sub gz {
  return gzip(shift()) if $] >= 5.010;
  my $t=tmp().'/acme-tools.wipe2.tmp';
  writefile($t,shift());
  ''.qx(gzip<$t);
}
1;

__END__
Reveals slowest tests:
time for i in {1..9};do echo $i;for p in t/??_*.t;do time perl -Iblib/lib $p;done 2>&1|perl -nle'$n//="01";/^real/&&print$n++,$_'>/tmp/o$i;done #1m
perl -MAcme::Tools -nle'/^(\d\d).*m(.*?)s/&&push@{$t{$1}},$2;END{printf"$_ %.3f\n",avg(@{$t{$_}}) for sort keys%t}' /tmp/o?|sort -rk2
03 0.326
29 0.262
09 0.261
25 0.178
37 0.175
24 0.173
02 0.168
27 0.159
04 0.157
36 0.151
48 0.148
08 0.147
44 0.143
07 0.143
28 0.139
15 0.139
13 0.134
38 0.132
42 0.131
21 0.113
10 0.113
39 0.106
17 0.106
33 0.100
01 0.100
35 0.098
34 0.098
06 0.098
47 0.096
32 0.096
31 0.096
20 0.096
14 0.096
40 0.095
30 0.095
18 0.095
41 0.094
26 0.094
23 0.094
19 0.094
22 0.093
45 0.092
43 0.092
05 0.092
46 0.090
12 0.090
11 0.090
16 0.088
