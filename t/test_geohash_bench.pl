use v5.10; use Carp; use Benchmark;
use Acme::Tools 'geohash';
#use Geo::Hash::XS; my $gh = Geo::Hash::XS->new();

my $p=12; #precision
*geohash2=*Acme::Tools::geohash_fast;
timethese(100, {
    'A::T::geohash'      => sub { srand(7);$s1=join' ',map     geohash(rand(180)-90,rand(360)-180,$p),1..50},
    'A::T::geohash_fast' => sub { srand(7);$s2=join' ',map    geohash2(rand(180)-90,rand(360)-180,$p),1..50},
#    'Geo::Hash::XS' => sub { srand(7);$s3=join' ',map $gh->encode(rand(180)-90,rand(360)-180,$p),1..50},
});

say "s1: $s1";
say "s2: $s2";
say "s3: $s3";
say $s1 eq $s2 ? "ok" : "err";
say $s1 eq $s3 ? "ok" : "err";

