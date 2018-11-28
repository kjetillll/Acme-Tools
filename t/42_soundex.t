# make;perl -Iblib/lib t/42_soundex.t
use strict;use warnings;
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 14;
#---- https://en.wikipedia.org/wiki/Soundex
my @test=map[split/\s+/],split"\n",<<""; #die srlz(\@test,'test','',1);
Robert      R163
Rupert      R163
Rubin       R150
Ashcraft    A261
Ashcroft    A261  #not A226, s and c becomes 2 and not 22 since h lies in between them
Tymczak     T522
Pfister     P236  #not P123, first two letters have the same number and are coded once as 'P'
Honeyman    H555
Washington  W252
Lee         L000
Gutierrez   G362
Jackson     J250
Tymczak     T522
Vandeusen   V532

#GWQHSW      G200 ?
#QXWKXHCQ    Q200 ?
#QOTWTHTA    Q330 ?

for(@test){
    my($name,$result)=@$_;
    my $r=Acme::Tools::soundex(uc($name));
   #my $r2=Text::Soundex::soundex(uc($name));
    ok($r eq $result, "$name want $result got $r");
   #ok($r eq $result && $r2 eq $result, "$name wants $result got $r (got $r2)");
}
__END__
use Text::Soundex;
srand(7);
for(1..1e4){
  my $len=1+rand(8);
  my $name=0+@test?shift(@test)->[0]:join("",map ['A'..'Z']->[rand(26)],(1..$len));
  my $result=Text::Soundex::soundex_nara($name);
  my $r=Acme::Tools::soundex($name);
  ok($r eq $result, "$name want $result got $r");
  #print $name,"\n";
}
__END__
