use strict;
use warnings;
use Test::More;
use Acme::Tools 0.15;
sub ok_ref {
  my($s1,$s2) = (serialize($_[0]), serialize($_[1]));
  my $ok = ok($s1 eq $s2, $_[2]) or warn "s1=$s1\ns2=$s2\n";
  $ok
}
sub ok_ca  { ok( abs( 1 - $_[0]/$_[1] ) < 1e-4, $_[2]) }
sub deb($) { print STDERR @_ if $ENV{ATDEBUG} }
1;
