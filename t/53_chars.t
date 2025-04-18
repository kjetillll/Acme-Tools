# make test
# perl Makefile.PL; make; perl -Iblib/lib t/53_chars.t
# perl Makefile.PL; make; ATDEBUG=1 perl -Iblib/lib t/53_chars.t

use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 12;

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

is utf8ify("æøå"), "æøå";
is utf8ify(u2l("æøå")), "æøå";
is utf8ify("ÂÃ"), "ÂÃ";
is utf8ify(u2l("ÂÃ")), "ÂÃ";
my $s1=chr(198).chr(216).chr(197); #ÆØÅ
my $s2=utf8ify(\$s1);
is $s1, "ÆØÅ";
is $s2, "ÆØÅ";

#printf "%3d -> %3d %3d   %s\n", $$_[0], ord(substr($$_[1],0,1))
#                                      , ord(substr($$_[1],1,1)), $$_[1] for map [$_,l2u(chr($_))], 128..255;

sub utf8ify {
    my $str = shift();
    ref($str) eq 'SCALAR' ? ( $$str = utf8ify($$str) ) :
    $str =~ s/ (?<![\xC2\xC3])   [\x80-\xC1\xC4-\xFF]
             |                   [\xC2\xC3]             (?![\x80-\xBF])
             / chr(ord$&<192?194:195) . chr(ord$&&191) /gerx
}

__END__

my $tmp=tmp();
writefile("$tmp/str",$str);
writefile("$tmp/lstr",$lstr);
writefile("$tmp/ustr",$ustr);
print "tmp: $tmp\n";
