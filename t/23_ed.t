# make test
# perl Makefile.PL; make; perl -Iblib/lib t/23_ed.t

BEGIN{require 't/common.pl'}
use Test::More tests => 3;

#--ed
my $s;
my $hw='hello world';
ok( ed('',$hw) eq $hw );
ok( ed('hello world','FaDMF verdenMD') eq 'hallo verden' );
ok( ed("A.,-\nabc.",'FMD') eq 'A.' );