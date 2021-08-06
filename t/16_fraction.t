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
     '355/113',  #~pi
     #3.141592653589793238462643383279502884197169399375105820974944592307816406286, #355/113
    (map{random(1e0,1e2) .'/'. random(1e4,1e5)}1..10),
    (map{random(1e4,1e5) .'/'. random(1e0,1e2)}1..10),
#    (map rand(), 1..10), #not yet
){
  my($min_n,$min_d,$min_diff,$min_c, $n,$d,$diff,$c)=fraction(eval$_);
  my $g="$min_n/$min_d";
  my $e=eval$_;
  my $info=sub{sprintf"%s: %-20s %-17s",$_[0],eval($_[1]),$_[1]=~m|/|?"($_[1])":''};
  $info=join('',map&$info(@$_),['got',$g],['exp',$_])."d=$diff c=$c min_c=$min_c";
  my $diff=eval($g)-$e;
  is(eval$g, $e, $info)
}
done_testing;
