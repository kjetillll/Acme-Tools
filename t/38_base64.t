# make test
# perl Makefile.PL && make && perl -Iblib/lib t/38_base64.t

use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 24;
use MIME::Base64;

my($s,$b64,$b64_2)=('');
for(0..1000){
  if($_%100==0){
    $b64=encode_base64($s);
    $b64_2=base64($s);
    my $s2=unbase64($b64);
    is($s,$s2,'yes '.length($s));
    is($b64,$b64_2,'yes b '.length($s));
  }
  $s.=$_;
}
SKIP: {
  skip 'skip test with /usr/bin/base64, not linux or not found',2 unless $^O eq 'linux' and -x '/usr/bin/base64';
  $s=qx(base64 -w 1000 Tools.pm);
  $b64=encode_base64($s);
  $b64_2=base64($s);
  my $s2=unbase64($b64);
  is($s,$s2,'yes ps '.length($s));
  is($b64,$b64_2,'yes b ps '.length($s));
}

#print "$s\n\n$b64\n";
