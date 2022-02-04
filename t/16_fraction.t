# make test
# perl Makefile.PL && make && perl -Iblib/lib t/16_fraction.t

use lib '.'; BEGIN{require 't/common.pl'}
use Test::More;

my $s=int(rand(1000));
#$s=621;
$s=273;
srand($s);
for(
    '1/1',
    '0/1',
    '-1/3',
    '-17/331',
    '-171/1',
    '304/377',
#    '303/377', #ok but slow
#    '302/377', #ok but slow
#    '301/377', #ok but slow
#    '300/377', #ok but slow
    .4-1e-3,
#    .4-1e-4,  #hm err
#    .4-1e-12,
     -.745564892623716,
     1234,
     2135.135135135135135135,
     '200/600',  #1/3
     '355/113',  #~pi
     #.4176176176176176176176176, #2086/4995
     #.417617617617617617617617, #2086/4995
     #.41761761761761761761761, #2086/4995
     #.4176176176176176176176, #2086/4995
    -0.41761761761761762, #-2086/4995
     #3.141592653589793238462643383279502884197169399375105820974944592307816406286, #355/113
    (map{random(1e0,1e2) .'/'. random(1e4,1e5)}1..10),
    (map{random(1e4,1e5) .'/'. random(1e0,1e2)}1..10),
    (map{random(1e1,1e2) .'/'. random(1e1,1e2)}1..10),
#    (map rand(), 1..10), #not yet
    '3/8',
    5e6,
    7e-6,
){
  my $t=time_fp();
  my($min_n,$min_d,$min_diff,$min_c, $n,$d,$diff,$c)=fraction(eval);
  $t=int(1e6*(time_fp()-$t));
  my $g="$min_n/$min_d";
  my $info=sub{sprintf"%s: %-20s %-14s",$_[0],eval($_[1]),$_[1]=~m|/|?"($_[1])":''};
  $info=join('',map&$info(@$_),['got',$g],['exp',$_]).sprintf"%-38s %-8s","d=$min_diff c=$c mc=$min_c","$tμs";
  my $diff=eval($g)-eval;
  push@c,$c;
  is(eval$g, eval, $info)
}
print join('   ',map"$_: ".&{$_}(@c),qw(sum avg median)).$/ if $ENV{ATDEBUG};
ok(!defined fraction(sqrt(2)),'undef for sqrt(2)');
ok(!defined fraction($PI),"undef for $PI");

my$b='3/8'; #'1/37';
my($n,$d,$c)=dec2frac(eval$b);
ok("$n/$d" eq $b, "$n/$d vs $b   count=$c");

done_testing;
