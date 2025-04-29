# make test
# perl Makefile.PL && make && perl -Iblib/lib t/29_cmd_z2z.t
# perl Makefile.PL && make && TMPDIR=/dev/shm perl -Iblib/lib t/29_cmd_z2z.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests    => 10;
warn <<"" and map ok(1),1..10 and exit if $^O!~/^(linux|cygwin)$/;
Tests for cmd_z2z not available for $^O, only linux and cygwin

my $tmp=tmp();
my $tf="$tmp/acme-tools.cmd_z2z";
writefile($tf,join" ",1..500);
#print qx(ls -l $tf)."\n";
my($last,$n)=("",0);
for(qw(gz bz2 xz gz xz bz2 gz)){
  my $prog={qw/gz gzip bz2 bzip2 xz xz/}->{$_};
  next if !Acme::Tools::which($prog) and warn "Program $prog missing, test z2z -t $_" and ok(1);
  my $opt='-vt';
  $opt=~s,-,-h, if $n++>3;
  print qq( Acme::Tools::cmd_z2z($opt,$_,"$tf$last") )."\n";
            Acme::Tools::cmd_z2z($opt,$_,"$tf$last");
  ok( -s "$tf.$_" );
  $last=".$_";
}

my @f=map"$tf.$_",1..4;
my $nn=0;
writefile($_,join" ",map ++$nn,1..5000) for @f;
my $b4=sum(map -s$_,@f);
if( qx(which pv) and qx(which xz) and $]>=5.010){
  Acme::Tools::cmd_z2z('-vp6t','xz',@f);
  Acme::Tools::cmd_z2z('-vht','gz',map"$_.xz",@f);
}
else {
  Acme::Tools::cmd_z2z('-vht','gz',@f);
}
my $af=sum(map -s$_,map"$_.gz",@f);
ok(100*$af/$b4 < 50, "$b4 -> $af less than half");

#----------false extention .gz destroys file unless handled well
my $fn="$tf.not_gzipped";
writefile($fn,join(' ',1..100));
my $md5_pre=md5sum($fn);
rename($fn,"$fn.gz");
SKIP: {
    skip 'check raise error only with true env ATDEBUG', 2 if not $ENV{ATDEBUG};
    eval{ Acme::Tools::cmd_z2z('-t','gz',"$fn.gz") };
    $@=~/^ERR/ or warn $@;
    ok( $@=~/^ERR/, 'Check provoked error' );
    rename("$fn.gz",$fn);
    ok( $md5_pre eq md5sum($fn), 'File with erroneous extention has been saved');
}

done_testing;
