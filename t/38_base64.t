# make test
# perl Makefile.PL && make && perl -Iblib/lib t/38_base64.t

use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 23;
use MIME::Base64;

my($s,$b64,$b64_2)=('');
for(0..1000){
  if($_%100==0){
    $b64=encode_base64($s);
    $b64_2=base64($s);
    my $s2=unbase64($b64);
    is($s, $s2,      'yes '.length($s));
    is($b64, $b64_2, 'yes b '.length($s));
  }
  $s.=$_;
}

my $str = join'', map chr(rand 256), 1..1e4;
is(unbase64(base64($str)=~s|\+|-|gr=~s|/|_|gr), $str, 'http safe enc');
