use strict;
use warnings;
use Test::More;
use Acme::Tools 0.15;
sub ok_ref { ok( serialize($_[0]) eq serialize($_[1]), $_[2] ) }
sub ok_ca  { ok( abs( 1 - $_[0]/$_[1] ) < 1e-4, $_[2]) }
sub deb($) { print STDERR @_ if $ENV{ATDEBUG} }
1;
