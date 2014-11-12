use strict;
use warnings;
use Test::More;
use Acme::Tools;
sub ok_ref { ok( serialize($_[0]) eq serialize($_[1]), $_[2] ) }
sub deb($) { print STDERR @_ if $ENV{ATDEBUG} }
1;
