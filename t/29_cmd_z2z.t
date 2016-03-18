# make test
# perl Makefile.PL; make; perl -Iblib/lib t/29_cmd_z2z.t
BEGIN{require 't/common.pl'}
use Test::More tests    => 7;
warn <<"" and map ok(1),1..7 and exit if $^O!~/^(linux|cygwin)$/;
Tests for cmd_z2z not available for $^O, only linux and cygwin

my $tmp=tmp();
my $tf="$tmp/acme-tools.cmd_z2z";
writefile($tf,join" ",1..1e3);
#print qx(ls -l $tf)."\n";
my($last,$n);
for(qw(gz bz2 xz gz xz bz2 gz)){
  my $prog={qw/gz gzip bz2 bzip2 xz xz/}->{$_};
  next if !qx(which $prog) and warn "Program $prog missing, test z2z -t $_" and ok(1);
  my $opt='-vt';
  $opt=~s,-,-h, if $n++>3;
  Acme::Tools::cmd_z2z($opt,$_,"$tf$last");
  ok( -s "$tf.$_" );
  $last=".$_";
}

my @f=map"$tf.$_",1..4;
my $n=0;
writefile($_,join" ",map ++$n,1..5e5) for @f;
Acme::Tools::cmd_z2z('-vpt','xz',@f);
Acme::Tools::cmd_z2z('-vht','gz',map"$_.xz",@f);
