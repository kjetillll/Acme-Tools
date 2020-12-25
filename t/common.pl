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
03 0.307
29 0.269
09 0.234
37 0.177
02 0.167
25 0.163
04 0.155
27 0.151
08 0.151
36 0.147
44 0.142
28 0.138
48 0.135
15 0.133
07 0.133
38 0.128
13 0.125
42 0.124
10 0.114
21 0.113
17 0.106
39 0.099
47 0.095
45 0.095
01 0.094
46 0.093
40 0.093
06 0.093
34 0.092
05 0.092
35 0.091
20 0.091
43 0.090
33 0.090
31 0.090
30 0.090
26 0.089
32 0.088
24 0.088
23 0.088
22 0.088
18 0.088
12 0.088
11 0.088
41 0.087
19 0.087
16 0.086
14 0.086
