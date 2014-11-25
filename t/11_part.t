# perl Makefile.PL;make;perl -Iblib/lib t/11_part.t
BEGIN{require 't/common.pl'}
use Test::More tests => 3;

my( $odd, $even ) = part {$_%2} 1..8;
ok( "1357" eq join("",@$odd) );
ok( "2468" eq join("",@$even) );
#print"@$odd\n";   #prints 1 3 5 7
#print"@$even\n";  #prints 2 4 6 8
my %h=parth { uc(substr($_,0,1)) } qw/These are the words of this array/;
#warn serialize(\%h);
ok_ref( \%h,
	{ T=>[qw/These the this/],
	  A=>[qw/are array/],
          W=>[qw/words/],
          O=>[qw/of/] },           'parth');


