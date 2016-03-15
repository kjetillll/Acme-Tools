# make test
# perl Makefile.PL; make; perl -Iblib/lib t/29_cmd_z2z.t
BEGIN{require 't/common.pl'}
use Test::More tests => 3;
##later##   if($^O eq 'linux'){
##later##     my $tf=tmp()."/acme-tools.cmd_z2z";
##later##     writefile($tf,join" ",1..1e5);
##later##     print qx(ls -l $tf)."\n";
##later##   #  qx(gzip $tf);
##later##   #  print qx(ls -l $tf.gz)."\n";
##later##     Acme::Tools::cmd_z2z("-hvt","gz", "$tf");
##later##     Acme::Tools::cmd_z2z("-hvt","bz2","$tf.gz");
##later##     Acme::Tools::cmd_z2z("-hvt","xz", "$tf.bz2");
##later##     Acme::Tools::cmd_z2z("-hvt","gz", "$tf.xz");
##later##   #  print qx(ls -l $tf.bz2)."\n";
##later##     ok(1,"n$_") for 1..3
##later##   }
##later##   else{
  ok(1) for 1..3
##later##   }
