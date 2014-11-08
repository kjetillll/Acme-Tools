# perl Makefile.PL;make;perl -Iblib/lib t/11_part.t
use strict;
use warnings;
sub deb($){print STDERR @_ if $ENV{ATDEBUG}}
use Test::More tests => 3;
BEGIN { use_ok('Acme::Tools') };

my( $odd, $even ) = part {$_%2} 1..8;
ok( "1357" eq join("",@$odd) );
ok( "2468" eq join("",@$even) );
#print"@$odd\n";   #prints 1 3 5 7
#print"@$even\n";  #prints 2 4 6 8
