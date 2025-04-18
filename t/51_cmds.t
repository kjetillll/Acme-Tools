# make test
# perl Makefile.PL; make; perl -Iblib/lib t/51_cmds.t
# perl Makefile.PL; make; ATDEBUG=1 perl -Iblib/lib t/51_cmds.t

use lib '.'; BEGIN{require 't/common.pl'}
use Test::More;

my $d=tmp();
my $f="$d/hei.txt";

my($ci,$rlog)=map which($_), 'ci', 'rlog';
my $rcs_installed = 2==grep { length() and -x$_ and readfile($_)=~/GNU RCS/} $ci, $rlog;

my $tests=7; $rcs_installed or $tests-=2;
plan tests => $tests;

#---- cilmd
if($rcs_installed){
  $Acme::Tools::Cmd_cilmd_silenzio=1;
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
else {
  ok(1,'RCS not installed, skip those tests');
}

#---- delsub
my@opt=('-i','.bk','-s','s,e,x,y,send_importeposter','-d',$f);
for(1..2){
  my $src=join'',map"sub $_ {\n  42;\n  73;\n}\n", 'a'..'z';
  $src=~s/sub t/<<'.' . $&/e;
sub send_importeposter
{
  my $nvbfilid=$Fil[0]{Nvbfilid} or die; #hm
  return if $Resultatfil!~/^$Importloggmappe/;
}
.

  writefile($f,$src);
  Acme::Tools::cmd_delsub(@opt);
  my $src2=readfile($f);
  is( do{$src=~s/^(\s*)sub (s|e|x|y|send_importeposter)\b.+?^\1}/sub $2 {die qq(sub $2 deleted)}/smg;$src}, $src2 );
  /1/ ? ok(  -s"$f.bk", "$f.bk exist" )
      : ok( !-s"$f.bk", "$f.bk dont exist" );
  splice@opt,0,2;
  rename"$f.bk",$f;
}
#print $src2;
