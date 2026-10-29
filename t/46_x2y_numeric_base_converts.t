# make && perl -Iblib/lib t/46_x2y_numeric_base_converts.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 19;

is( dec2bin(101), '1100101',          'dec2bin');
is( dec2hex(101), '65',               'dec2hex');
is( dec2oct(101), '145',              'dec2oct');
is( bin2dec(1010011110), '670',       'bin2dec');
is( bin2hex(1010011110), '29e',       'bin2hex');
is( bin2oct(1010011110), '1236',      'bin2oct');
is( hex2dec(101),        '257',       'hex2dec');
is( hex2bin(101),        '100000001', 'hex2bin');
is( hex2oct(101),        '401',       'hex2oct');
is( oct2dec(101), '65',               'oct2dec');
is( oct2bin(101), '1000001',          'oct2bin');
is( oct2hex(101), '41',               'oct2hex');

is( bitswap(10, 0..3),            5,  'bitswap');
is( bitswap(5, 0..3),            10,  'bitswap');
is( bitswap(2**30 +10, 0..3),            2**30 +5,  'bitswap');

is( bitswap(481, 0,1),          482,  'bitswap');
is( bitswap(482, 0,1),          481,  'bitswap');

is( bitswap(18, 1,4,0,2,3,5,6),  96,  'bitswap');

my $r = bitswap(678987, 0,1,3,2,4) ^ 12345;
print "r: $r\n";
is( bitswap($r^12345, 0, 2, 1, 3, 4), 678987, 'anon deanon');
__END__
my @a = map bitswap($_,0..5), 400000..999999-123456;
for(@a){
	my $x=$_^123456;
	printf "%6d %032b          %d %032b\n", $_, $_, $x, $x if length($x)>6;
	$l{length$x}++;
}
print srlz(\%l,'l','',1);

