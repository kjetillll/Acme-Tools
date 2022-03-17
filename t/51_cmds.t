# make test
# perl Makefile.PL; make; perl -Iblib/lib t/51_cmds.t
# perl Makefile.PL; make; ATDEBUG=1 perl -Iblib/lib t/51_cmds.t

use lib '.'; BEGIN{require 't/common.pl'}
use Test::More;


my($ci,$rlog)=map which($_), 'ci', 'rlog';
if( 2 > grep readfile($_)=~/GNU RCS/,$ci,$rlog ){
    plan skip_all => 'ci (rcs) not installed';
    exit;
}

plan tests => 7;

#---- cilmd
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

#---- delsub
my@opt=('-i','.bk','-s','s,e,x,y',$f);
for(1..2){
  my $src=join'',map"sub $_ {\n  42;\n  73;\n}\n", 'a'..'z';
  writefile($f,$src);
  Acme::Tools::cmd_delsub(@opt);
  my $src2=readfile($f);
  is( $src=~s/^(\s*)sub (s|e|x|y).*?^\1}//smgr, $src2 );
  /1/ ? ok(  -s"$f.bk", "$f.bk exist" )
      : ok( !-s"$f.bk", "$f.bk dont exist" );
  splice@opt,0,2;
  rename"$f.bk",$f;
}
#print $src2;
