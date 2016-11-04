# make test
# perl Makefile.PL; make; perl -Iblib/lib t/33_refsubs.t
BEGIN{require 't/common.pl'}
use Test::More tests => 9;

my $ref_to_array  = [1,2,3];
my $ref_to_hash   = {1,100,2,200,3,300};
my $ref_to_scalar = \"String";

ok( refa $ref_to_array  );
ok( refh $ref_to_hash   );
ok( refs $ref_to_scalar );

my $ref_to_array_of_arrays = [ [1,2,3], [2,4,8], [10,100,1000] ];
my $ref_to_array_of_hashes = [ {1=>10, 2=>100}, {first=>1, second=>2} ];
my $ref_to_hash_of_arrays  = { alice=>[1,2,3], bob=>[2,4,8], eve=>[10,100,1000] };
my $ref_to_hash_of_hashes  = { alice=>{a=>22,b=>11}, bob=>{a=>33,b=>66} };

ok( refaa $ref_to_array_of_arrays );
ok( refah $ref_to_array_of_hashes );
ok( refha $ref_to_hash_of_arrays );
ok( refhh $ref_to_hash_of_hashes );

my $a=[1,2,3];

pushr $a, 4;
ok( join("",@$a) eq "1234" ); #print "@$a\n";

pushr $a, 5, 6;
ok( join("",@$a) eq "123456" ); #print "@$a\n";

