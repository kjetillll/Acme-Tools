# make && perl -Iblib/lib t/50_primes.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 45;
my $tt=0;
my @p=(
  2,  3,  5,  7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71,
 73, 79, 83, 89, 97,101,103,107,109,113,127,131,137,139,149,151,157,163,167,173,
179,181,191,193,197,199,211,223,227,229,233,239,241,251,257,263,269,271,277,281,
283,293,307,311,313,317,331,337,347,349,353,359,367,373,379,383,389,397,401,409,
419,421,431,433,439,443,449,457,461,463,467,479,487,491,499,503,509,521,523,541,
547,557,563,569,571,577,587,593,599,601,607,613,617,619,631,641,643,647,653,659,
661,673,677,683,691,701,709,719,727,733,739,743,751,757,761,769,773,787,797,809,
811,821,823,827,829,839,853,857,859,863,877,881,883,887,907,911,919,929,937,941,
947,953,967,971,977,983,991,997);

my @tests=(
   [1000,\@p],
   [997,\@p],
   [-168,\@p],
   [-7,[2,3,5,7,11,13,17]],
   [-2,[2,3]],
   [-1,[2]],
   [0,[]],
   [1,[]],
   [2,[2]],
   [3,[2,3]],
   [4,[2,3]],
   [5,[2,3,5]]);
is_deeply([primes($$_[0])],$$_[1],"primes($$_[0])") for @tests;

my $t=0;
for( [1           => 0],  # up to => number of primes
     [10          => 4],
     [100         => 25],
     [1000        => 168],
     [10000       => 1229],
     [100000      => 9592],    #0.013s
   # [1000000     => 78498],   #0.14s
   # [10000000    => 664579],  #2.57s
   # [100000000   => 5761455],
   # [1000000000  => 50847534],
   # [10000000000 => 455052511],
){
  my $start=time_fp();
  #my@p=primes($$_[0]);
  #is( 0+@p, $$_[1], join(' => ',@$_) );
  no warnings 'uninitialized';
  is( 0+primes($$_[0]), $$_[1], join(' => ',@$_) );
  $t += time_fp()-$start;
}
print"$t sec\n" if $ENV{ATDEBUG}; #0.14 sec

for(
  [245 => 5, 7, 7],
  [753 => 3, 251],
  [23456789 => 23456789],
  [5778313123 => 11, 109, 241, 19997],
  [75778313123 => 48731, 1555033],
# [975778313123 => 3547, 275099609],
# [1375778313123 => 3, 29, 15813543829],
# [2375778313123 => 37, 64210224679],
){
  my($inp,@exp)=@$_;
  my @got = factors($inp);
  is( join(',',@got), join(',',@exp), "$inp == ".join(' * ', @got) );
}

srand(19);
for(sort{$a<=>$b}map$_*int(rand 100000),1..20){
  my $p=1; $p*=$_ for my @f=factors($_);
  is($_,$p,"factor($_)   $p == ".join('*',@f));
}

my(@t1,@t2);
for(0..30,980..1000,5000,25000){  #primes2() faster for small n
#for(1e3){
#for(1e2,1e3,1e4,1e5,2e5,5e5,1e6){ #primes() faster for large n
  my $t=time_fp();  my @p1=primes($_);  push@t1, time_fp()-$t;
     $t=time_fp();  my @p2=primes2($_); push@t2, time_fp()-$t;
  push@err,$_ if join(',',@p1)
              ne join(',',@p2);
}
#print "tt=$tt\n";
#print srlz([map sprintf('%.5f',$_),@t1],'t1');
#print srlz([map sprintf('%.5f',$_),@t2],'t2');
my @pnt;
push @pnt, 100*(shift(@t2)-$_)/$_ for @t1;
is(0+@err,0,sprintf'primes2() alternative    %.2f%%',avg(@pnt));

#for(1e5-30 .. 1e5){ primes($_); print "_=$_ bits=".length($Acme::Tools::bits)."\n" }

sub primes2($) { #inspired by https://github.com/famzah/langs-performance/blob/master/primes.pl
  my $n=shift;
  return ()  if $n<2;
  return (2) if $n==2;
  my($half,$m,$i) = ($n/2, 1, 0);
  my @s=map$_*2+1,1..$n/2;
  while($m<=$n**0.5){
    $m+=2;
    next if not $s[$i++];
    my $j = $m*$m/2 - 1.5 - $m;
    $s[$j+=$m]=undef while $j<$half;
  }
  (2, grep defined&&$_<=$n, @s)
}

sub primes3 {
  my $n = shift;
  return (2,3) if $n==-2;
  return (2)   if $n==-1 or $n==2;
  return ()    if $n==0  or $n==1;
  return (primes(do{my$N=-$n;$N*=1.1while$N/log($N)<-1.2*$n;$N}))[0..-$n-1] if $n<0;
  my( $q,$factor,$repeat,$bits ) =( sqrt($n), 1, 1, 0 x $n );
  while ( $factor <= $q ) {
    $factor += 2;
    next if substr($bits,$factor,1);
    $repeat .= 0 x (2*$factor-length$repeat);
    my $times = -($factor**2-length$bits)/2/$factor + 1;
    my $t=time_fp;
    $bits |= 0 x $factor**2  .  ($times>0?$repeat x $times:'');
    $tt+=int(1e9*(time_fp()-$t));
    $tt+=1e-3;
  }
  @{[2,map$_*2+1,grep!substr($bits,1+$_*2,1),1..$n/2-.5]};
}
$ENV{ATDEBUG}&&-s't/primes1.txt.xz'?testalot():ok(1,'skip testalot() wo ATDEBUG');
sub testalot {
  my $ant=pop//1e4;
  my @p1=primes(-$ant);
  open my $fh,"xzcat t/primes1.txt.xz|head -$ant|"||die; my@p2=map s/\D//gr,<$fh>; close($fh);
  is( join(',',@p1), join(',',@p2), "First $ant vs t/primes1.txt.xz" );
}


__END__
https://primes.utm.edu/lists/small/millions/