# make test
# perl Makefile.PL; make; perl -Iblib/lib t/51_cmds.t
# perl Makefile.PL; make; ATDEBUG=1 perl -Iblib/lib t/51_cmds.t

use lib '.'; BEGIN{require 't/common.pl'}
use Test::More;
my($ci,$rlog)=map which($_), 'ci', 'rlog';
if( 2 > grep readfile($_)=~/GNU RCS/,$ci,$rlog ){
  plan skip_all => 'ci (rcs) not installed'
}
else {
  plan tests => 3;
  $Acme::Tools::Cmd_cilmd_silenzio=1;
  my$d=tmp();
  my$f="$d/hei.txt";
  writefile($f,"This\nwas\nfun!\n");
  Acme::Tools::cmd_cilmd($f);
  ok(-s"$f,v");
  for(1..5){
    writefile(">$f","$_\n");
    Acme::Tools::cmd_cilmd($f);
  }
  my$rlog=qx($rlog $f);#print"$rlog\n";
  ok( $rlog=~/\b 1.6 \b/x );
  ok( $rlog!~/\b 1.7 \b/x );
}
