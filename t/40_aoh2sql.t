# make;perl -Iblib/lib t/40_aoh2sql.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests    => 2;
use Encode 'encode';
if($^O ne 'linux'){ is(1,1,'skips on non-linux') for 1..2; exit }
ok(1) for 1..2;

#my $json=gunzip(readfile('t/country.json.gz')); #hm should work, why not?
my $json=do{open my $fh, 'zcat t/country.json.gz|' or die; join"",<$fh>};
$json=Encode::encode('UTF-8',$json);
#print "<<$json>>\n"."length=".length($json)."\n";
require JSON;
my $d=JSON::decode_json($json)->{rows};
#$_={subhash($_,qw(Code Name Population Area Capital Continent))} for @$d;
#map s/\.\d+$//, values%$_ for @$d;
#print srlz($d,'d','',2);
print aoh2sql($d,{name=>'country',drop=>1});
