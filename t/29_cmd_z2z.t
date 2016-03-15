# make test
# perl Makefile.PL; make; perl -Iblib/lib t/29_cmd_z2z.t
BEGIN{require 't/common.pl'}
use Test::More tests => 3;
if($^O eq 'linux'){
  my $tf=tmp()."/acme-tools.cmd_z2z";
  writefile($tf,join" ",1..1e5);
  print qx(ls -l $tf)."\n";
  #qx(gzip $tf);
  #print qx(ls -l $tf.gz)."\n";
  Acme::Tools::cmd_z2z("-vt","gz", "$tf");
  Acme::Tools::cmd_z2z("-vt","bz2","$tf.gz");
  Acme::Tools::cmd_z2z("-vt","xz", "$tf.bz2");
  Acme::Tools::cmd_z2z("-vt","gz", "$tf.xz");
  #print qx(ls -l $tf.bz2)."\n";
  ok(1,"n$_") for 1..3
}
else{
  ok(1) for 1..3
}
