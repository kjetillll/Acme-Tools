# make test
# perl Makefile.PL; make; perl -Iblib/lib t/53_chars.t
# perl Makefile.PL; make; ATDEBUG=1 perl -Iblib/lib t/53_chars.t

use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 6;

is_deeply [chars("abcdef\cJghÆ")] => ['a'..'f',chr(10),'g','h',chr 195,chr 134];

my $l=join'',map chr,230,248,229,198,216,197,228,235,239,246,252;
my $u=l2u($l);
is $u => 'æøåÆØÅäëïöü';
is u2l($u) => $l;

use Encode ();
my $str=join'',map chr,0..255;                    #print"len str:  ".length($str)."\n";
my $ustr=Encode::encode('UTF-8', $str);           #print"len str:  ".length($str)."\n";
                                                  #print"len ustr: ".length($ustr)."\n";
is l2u($str) => $ustr;						  
my $lstr=Encode::encode('ISO-8859-1',u2l($ustr)); #print"len lstr: ".length($lstr)."\n";
is $lstr => $str;
is u2l($ustr) => $lstr;

__END__

my $tmp=tmp();
writefile("$tmp/str",$str);
writefile("$tmp/lstr",$lstr);
writefile("$tmp/ustr",$ustr);
print "tmp: $tmp\n";