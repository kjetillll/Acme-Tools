package Acme::Tools;

our $VERSION = '0.14';

use 5.008;
use strict;
#use warnings;
use Carp;

require Exporter;

our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [ qw() ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw(
 min
 max
 mins
 maxs
 sum
 avg
 geomavg
 stddev
 median
 percentile
 $Resolve_iterations
 $Resolve_last_estimate
 resolve
 conv
 rank
 rankstr
 eqarr
 sorted
 sortedstr
 pushsort
 pushsortstr
 binsearch
 binsearchstr
 random
 random_gauss
 big
 bigi
 bigf
 bigscale
 nvl
 replace
 decode
 decode_num
 between
 distinct
 in
 in_num
 uniq
 union
 minus
 intersect
 not_intersect
 mix
 zip
 subhash
 hashtrans
 zipb64
 zipbin
 unzipb64
 unzipbin
 gzip
 gunzip
 bzip2
 bunzip2
 ipaddr
 ipnum
 webparams
 urlenc
 urldec
 ht2t
 chall
 makedir
 qrlist
 ansicolor
 ccn_ok
 KID_ok
 writefile
 readfile
 readdirectory
 range
 permutations
 trigram
 cart
 reduce
 int2roman
 num2code
 code2num
 gcd
 lcm
 pivot
 tablestring
 upper
 lower
 dserialize
 serialize
 bytes_readable
 distance
 easter
 time_fp
 sleep_fp
 eta
 sys
 recursed
 md5sum
 bfinit
 bfsum
 bfaddbf
 bfadd
 bfcheck
 bfgrep
 bfgrepnot
 bfdelete
 bfstore
 bfretrieve
 bfclone
 bfdimensions
);

=head1 NAME

Acme::Tools - Lots of more or less useful subs lumped together and exported into your namespace

=head1 SYNOPSIS

 use Acme::Tools;

 print sum(1,2,3);                   # 6
 print avg(2,3,4,6);                 # 3.75

 my @list = minus(\@listA, \@listB); # set operations
 my @list = union(\@listA, \@listB); # set operations

 print length(gzip("abc" x 1000));   # far less than 3000

 writefile("/dir/filename",$string); # convenient
 my $s=readfile("/dir/filename");    # also conventient

 print "yes!" if between($pi,3,4);

 print percentile(0.05, @numbers);

 my @even = range(1000,2000,2);      # even numbers between 1000 and 2000
 my @odd  = range(1001,2001,2);

 my $dice = random(1,6);
 my $color = random(['red','green','blue','yellow','orange']);

 ...and so on.

=head1 ABSTRACT

Useful subroutines for perl. About 90 of them.

=head1 DESCRIPTION

Subs created and collected since the mid-90s.

=head1 EXPORT

Almost every sub, about 90 of them.

Beware of namespace pollution. But what did you expect from an Acme module?

=head1 NUMBERS, SETS, ARRAYS, STATISTICS

=head2 min

Returns the smallest in a list of numbers. Undef is ignored.

 @lengths=(2,3,5,2,10,undef,5,4);
 $shortest = min(@lengths);   # returns 2

Note: The comparison operator is perls C<< < >>> which means empty strings is treated as C<0>, the number zero. The same goes for C<max()>, except of course C<< > >> is used instead.

 min(3,4,5)       # 3
 min(3,4,5,undef) # 3
 min(3,4,5,'')    # returns the empty string

=head2 max

Returns the largest in a list of numbers. Undef is ignored.

 @heights=(123,90,134,undef,132);
 $highest = max(@heights);   # 134

=head2 mins

Just as L</min>, except for strings.

 print min( 2,7,10);   # 2
 print mins(2,7,10,);  # 10

=cut

sub min  {my $min;for(@_){ $min=$_ if defined($_) and !defined($min) || $_ < $min } $min }
sub mins {my $min;for(@_){ $min=$_ if defined($_) and !defined($min) || $_ lt $min} $min }
sub max  {my $max;for(@_){ $max=$_ if defined($_) and !defined($max) || $_ > $max } $max }
sub maxs {my $max;for(@_){ $max=$_ if defined($_) and !defined($max) || $_ gt $max} $max }

=head2 sum

Returns the sum of a list of numbers.

 print sum(1,3,undef,8);   # 12

=cut

sub sum
{
  my $sum; no warnings;
  $sum+=$_ for @_;
  $sum;
}

=head2 avg

Returns the I<average> number of a list of numbers. That is C<sum / count>

 print avg(2, 4, 9);   # 5              (2+4+9) / 3 = 5

Also known as I<arithmetic mean>.

=cut

sub avg
{
  my $sum=0;
  no warnings;
  $sum+=$_ for @_;
  return $sum/@_ if @_>0;
  return undef;
}

=head2 geomavg

Returns the I<geometric average> (a.k.a I<geometric mean>) of a list of numbers.

 print geomavg(10,100,1000,10000,100000);               # 1000
 print 0+ (10*100*1000*10000*100000) ** (1/5);          # 1000 same thing
 print exp(avg(map log($_),10,100,1000,10000,100000));  # 1000 same thing, this is how geomavg() works internally

=cut

sub geomavg { exp(avg(map log($_),@_)) }


=head2 variance

C<< Variance = ( sum (x[i]-Average)**2)/(n-1) >>

=cut

sub variance
{
  my $sumx2; $sumx2+=$_*$_ for @_;
  my $sumx; $sumx+=$_ for @_;
  (@_*$sumx2-$sumx*$sumx)/(@_*(@_-1));
}

=head2 stddev

C<< Standard_Deviation = sqrt(variance) >>

Standard deviation (stddev) is a measurement of the width of a normal
distribution where one stddev on each side of the mean covers 68% and
two stddevs 95%.  Normal distributions are sometimes called Gauss curves
or Bell shapes.

 stddev(4,5,6,5,6,4,3,5,5,6,7,6,5,7,5,6,4)             # = 1.0914103126635
 avg(@IQtestscores) + stddev(@IQtestscores)            # = the score for IQ = 115 (by one definition)
 avg(@IQtestscores) - stddev(@IQtestscores)            # = the score for IQ = 85

=cut

sub stddev
{
  my $sumx2; $sumx2+=$_*$_ for @_;
  my $sumx; $sumx+=$_ for @_;
  sqrt( (@_*$sumx2-$sumx*$sumx)/(@_*(@_-1)) );
}


=head2 median

Returns the median value of a list of numbers. The list do not have to
be sorted.

Example 1, list having an odd number of numbers:

 print median(1, 100, 101);   # 100

100 is the middlemost number after sorting.

Example 2, an even number of numbers:

 print median(1005, 100, 101, 99);   # 100.5

100.5 is the average of the two middlemost numbers.

=cut

sub median
{
  no warnings;
  my @list = sort {$a<=>$b} @_;
  my $n=@list;
  $n%2
    ? $list[($n-1)/2]
    : ($list[$n/2-1] + $list[$n/2])/2;
}


=head2 percentile

Returns one or more percentiles of a list of numbers.

Percentile 50 is the same as the I<median>, percentile 25 is the first
quartile, 75 is the third quartile.

B<Input:>

First argument is your wanted percentile, or a refrence to a list of percentiles you want from the dataset.

If the first argument to percentile() is a scalar, this percentile is returned.

If the first argument is a reference to an array, then all those percentiles are returned as an array.

Second, third, fourth and so on argument are the numbers from which you want to find the percentile(s).

B<Examples:>

This finds the 50-percentile (the median) to the four numbers 1, 2, 3 and 4:

 print "Median = " . percentile(50, 1,2,3,4);   # 2.5

This:

 @data=(11, 5, 3, 5, 7, 3, 1, 17, 4, 2, 6, 4, 12, 9, 0, 5);
 @p = map percentile($_,@data), (25, 50, 75);

Is the same as this:

 @p = percentile([25, 50, 75], @data);

But the latter is faster, especially if @data is large since it sorts
the numbers only once internally.

B<Example:>

Data: 1, 4, 6, 7, 8, 9, 22, 24, 39, 49, 555, 992

Average (or mean) is 143

Median is 15.5 (which is the average of 9 and 22 who both equally lays in the middle)

The 25-percentile is 6.25 which are between 6 and 7, but closer to 6.

The 75-percentile is 46.5, which are between 39 and 49 but close to 49.

Linear interpolation is used to find the 25- and 75-percentile and any
other x-percentile which doesn't fall exactly on one of the numbers in
the set.

B<Interpolation:>

As you saw, 6.25 are closer to 6 than to 7 because 25% along the set of
the twelve numbers is closer to the third number (6) than to he fourth
(7). The median (50-percentile) is also really interpolated, but it is
always in the middle of the two center numbers if there are an even count
of numbers.

However, there is two methods of interpolation:

Example, we have only three numbers: 5, 6 and 7.

Method 1: The most common is to say that 5 and 7 lays on the 25- and
75-percentile. This method is used in Acme::Tools.

Method 2: In Oracle databases the least and greatest numbers
always lay on the 0- and 100-percentile.

As an argument on why Oracles (and others?) definition is not the best way is to
look at your data as for instance temperature measurements.  If you
place the highest temperature on the 100-percentile you are sort of
saying that there can never be a higher temperatures in future measurements.

A quick non-exhaustive Google survey suggests that method 1 here is most used.

The larger the data sets, the less difference there is between the two methods.

B<Extrapolation:>

In method one, when you want a percentile outside of any possible
interpolation, you use the smallest and second smallest to extrapolate
from. For instance in the data set C<5, 6, 7>, if you want an
x-percentile of x < 25, this is below 5.

If you feel tempted to go below 0 or above 100, C<percentile()> will
I<die> (or I<croak> to be more precise)

Another method could be to use "soft curves" instead of "straight
lines" in interpolation. Maybe B-splines or Bezier curves. This is not
used here.

For large sets of data Hoares algorithm would be faster than the
simple straightforward implementation used in C<percentile()>
here. Hoares don't sort all the numbers fully.

B<Differences between the two main methods described above:>

 Data: 1, 4, 6, 7, 8, 9, 22, 24, 39, 49, 555, 992

 Percentile  Method 1                    Method 2
             (Acme::Tools::percentile  (Oracle)
             and others)
 ----------- --------------------------- ---------
 0           -2                          1
 1           -1.61                       1.33
 25          6.25                        6.75
 50 (median) 15.5                        15.5
 75          46.5                        41.5
 99          1372.19                     943.93
 100         1429                        992

Found like this:

 perl -MAcme::Tools -le 'print for percentile([0,1,25,50,75,99,100], 1,4,6,7,8,9,22,24,39,49,555,992)'

And like this in Oracle-databases:

 create table tmp (n number);
 insert into tmp values (1); insert into tmp values (4); insert into tmp values (6);
 insert into tmp values (7); insert into tmp values (8); insert into tmp values (9);
 insert into tmp values (22); insert into tmp values (24); insert into tmp values (39);
 insert into tmp values (49); insert into tmp values (555); insert into tmp values (992);
 select
   percentile_cont(0.00) within group(order by n) per0,
   percentile_cont(0.01) within group(order by n) per1,
   percentile_cont(0.25) within group(order by n) per25,
   percentile_cont(0.50) within group(order by n) per50,
   percentile_cont(0.75) within group(order by n) per75,
   percentile_cont(0.99) within group(order by n) per99,
   percentile_cont(1.00) within group(order by n) per100
 from tmp;

(Oracle also provides a similar function: C<percentile_disc> where I<disc>
is short for I<discrete>, meaning no interpolation is taking
place. Instead the closest number from the data set is picked.)

=cut

sub percentile
{
  my(@p,@t,@ret);
  if(ref($_[0]) eq 'ARRAY'){ @p=@{shift()} }
  elsif(not ref($_[0]))    { @p=(shift())  }
  else{croak()}
  @t=@_;
  return if not @p;
  croak if not @t;
  @t=sort{$a<=>$b}@t;
  push@t,$t[0] if @t==1;
  for(@p){
    croak if $_<0 or $_>100;
    my $i=(@t+1)*$_/100-1;
    push@ret,
      $i<0       ? $t[0]+($t[1]-$t[0])*$i:
      $i>$#t     ? $t[-1]+($t[-1]-$t[-2])*($i-$#t):
      $i==int($i)? $t[$i]:
                   $t[$i]*(int($i+1)-$i) + $t[$i+1]*($i-int($i));
  }
  return @p==1 ? $ret[0] : @ret;
}

=head2 resolve

Resolves an equation by Newtons method.

B<Input:> 1-6 arguments.

First argument: must be a coderef to a subroutine (a function)

Second argument: the target, f(x)=target. Default 0.

Third argument: a start position for x. Default 0.

Fourth argument: a small delta value. Default 1e-4 (0.0001).

Fifth argument: a maximum number of iterations before resolve gives up
and carps. Default 100 (if fifth argument is not given or is
undef). The number 0 means infinite here.  If the derivative of the
start position is zero or close to zero more iterations are typically
needed.

Sixth argument: A number of seconds to run before giving up.  If both
fifth and sixth argument is given and > 0, C<resolve> stops at
whichever comes first.

B<Output:> returns the number C<x> for C<f(x)> = 0

...or equal to the second input argument if present.

B<Example:>

The equation C<< x^2 - 4x - 21 = 0 >> has two solutions: -3 and 7.

The result of C<resolve> will depend on the start position:

 print resolve(sub{ my $x=shift; $x**2 - 4*$x - 21 });        # -3 with default start position 0
 print resolve(sub{ my $x=shift; $x**2 - 4*$x - 21 },0,3);    # 7  with start position 3
 print "Iterations: $Acme::Tools::Resolve_iterations\n";      # 3 or larger, about 10-15 is normal

The variable C< $Acme::Tools::Resolve_iterations > (which is exported) will
be set to the last number of iterations C<resolve> used. Work also if
C<resolve> dies (carps).

The variable C< $Acme::Tools::Resolve_last_estimate > (which is exported) will
be set to the last estimate. This number will often be close to the solution
and can be used even if C<resolve> dies (carps).

B<BigFloat-example:>

If either second, third or fourth argument is an instance of Math::BigFloat, so will the result be:

 use Acme::Tools;
 use Math::BigFloat try => 'GMP';  # try means pure perl and no warnings if Math::GMP is not installed
 my $start=Math::BigFloat->new(1);
 my $gr1 = resolve(sub{my$x=shift; $x-1-1/$x}, 0, 1);     # 1/2 + sqrt(5)/2
 my $gr2 = resolve(sub{my$x=shift; $x-1-1/$x}, 0, $start);# 1/2 + sqrt(5)/2
 Math::BigFloat->div_scale(50); #default is 40
 my $gr3 = resolve(sub{my$x=shift; $x-1-1/$x}, 0, $start);# 1/2 + sqrt(5)/2
 print "Golden ratio 1: $gr1\n";
 print "Golden ratio 2: $gr2\n";
 print "Golden ratio 3: $gr3\n";

Output:

 Golden ratio 1: 1.61803398874989
 Golden ratio 2: 1.61803398874989484820458683436563811772029300310882395927211731893236137472439025
 Golden ratio 3: 1.6180339887498948482045868343656381177203091798057610016490334024184302360920167724737807104860909804

See:

L<http://en.wikipedia.org/wiki/Newtons_method>

L<Math::BigFloat>

L<http://en.wikipedia.org/wiki/Golden_ratio>

=cut

our $Resolve_iterations;
our $Resolve_last_estimate;

sub resolve
{
  my($f,$g,$start,$delta,$iters,$sec)=@_;
  
  $g=0        if not defined $g;
  $start=0    if not defined $start;
  $delta=1e-4 if not defined $delta;
  $iters=100  if not defined $iters;
  $sec=0      if not defined $sec;
  $iters=13e13 if $iters==0;
  croak "Iterations ($iters) or seconds ($sec) can not be a negative number" if $iters<0 or $sec<0;
  $Resolve_iterations=undef;
  $Resolve_last_estimate=undef;
  croak "Should have at least 1 argument, a coderef" if not @_;
  croak "First argument should be a coderef" if not ref($f) eq 'CODE';
  
  my @x=($start);
  my $time_start=$sec>0?time_fp():undef;
  my $timeout=0;
  my $ds=ref($start) eq 'Math::BigFloat' ? Math::BigFloat->div_scale() : undef;
  
  for my $n (0..$iters-1){
    my $fd= &$f($x[$n]+$delta*0.5) - &$f($x[$n]-$delta*0.5);
    $fd   = &$f($x[$n]+$delta*0.6) - &$f($x[$n]-$delta*0.4) if $fd==0; #wiggle...
    $fd   = &$f($x[$n]+$delta*0.3) - &$f($x[$n]-$delta*0.7) if $fd==0;
    #warn "n=$n  fd=$fd\n";
    croak "Div by zero: df(x) = $x[$n] at n'th iteration, n=$n" if $fd==0;
    $Resolve_last_estimate=
    $x[$n+1]=$x[$n]-(&$f($x[$n])-$g)/($fd/$delta);
    $Resolve_iterations=$n;
    last if $n>3 and $x[$n+1]==$x[$n] and $x[$n]==$x[$n-1];
    last if $n>3 and ref($x[$n+1]) eq 'Math::BigFloat' and substr($x[$n+1],0,$ds) eq substr($x[$n],0,$ds); #hm
    croak "Could not resolve, perhaps too little time given ($sec), iteratons=$n"
      if $sec>0 and time_fp()-$time_start>$sec and $timeout=1;
    #warn "$n: ".$x[$n+1]."\n";
  }
  croak "Could not resolve, perhaps too few iterations ($iters)" if @x>=$iters;
  return $x[-1];
}

=head2 conv

Converts between units of measurements.

Examples:

 print conv(70,"cm","in");  #prints 27.5590551181102
# See L<Math::Units>

=cut

sub conv
{
  my($num,$from,$to)=@_;
  my %f
    =(
      #length
      m       => 1,
      mil     => 10000,
      inch    => 0.0254,
      inches  => 0.0254,
      ft      => 0.0254*12,               #0.3048 m
      yard    => 0.0254*12*3,             #0.9144 m
      chain   => 0.0254*12*3*22,          #20.1168 m
      furlong => 0.0254*12*3*22*10,       #201.168 m
      mile    => 0.0254*12*3*22*10*8,     #1609.344 m
      miles   => 0.0254*12*3*22*10*8,
      league  => 0.0254*12*3*22*10*8*3,   #4828.032 m

      yard_imperical => 0.914398416,

      #area
      m2      => 1,
      km2     => 1000*1000,
      sqmi    => 0.0254*12*3*22*10*8 * 0.0254*12*3*22*10*8,
      'sq mi' => 0.0254*12*3*22*10*8 * 0.0254*12*3*22*10*8,

      #volume
      m3=>1,
      liter=>0.001,

      #weight
      g => 1,
      #ounce=>
      

      #time
      s  => 1,
      m  => 60,
      h  => 60*60,
      d  => 60*60*24,
      w  => 60*60*24*7,
      mo => 60*60*24*30, #hm 30
      y  => 60*60*24*365,#hm 365

      #ampere

      #temperature
      C=>1,
      F=>1234,

      #force
      W=>1,
      hp=>1,

      #fuel economy
     'l/mil'         => 1,
      liter_pr_mil   => 1,
      liter_pr_km    => 10,
      liter_pr_100km => 1/10,
      mpg            => -23.5214584, # negative signals inverse

      #valuta
      NOK=>1,
      SEK=>1,
      EUR=>1,
      USD=>1,

     );
  my $f=$f{$from}/$f{$to};
  my $r=( $f>0 ? $num*$f : (1/-$num)*$f );
  print STDERR "$num $from => $to    from=$f{$from}  to=$f{$to}  f=$f  r=$r\n";
  return $r;
}

=head2 pushsort

Adds one or more element to a numerically sorted array and keeps it sorted.

  pushsort @a, 13;                         # this...
  push     @a, 13; @a = sort {$a<=>$b} @a; # is the same as this, but first is faster if @a is large

=head2 pushsortstr

Same as pushsort except that the array is kept sorted alphanumerically (cmp) instead of numerically (<=>). See L</pushsort>.

  pushsort @a, "abc";                   # this...
  push     @a, "abc"; @a = sort @a;     # is the same as this, first is faster if @a is large

=cut

our $Pushsort_cmpsub=undef;
sub pushsort (\@@)
{
  my $ar=shift;

  #not needed but often faster
  if(not defined $Pushsort_cmpsub and @$ar+@_<100){ #hm speedup?
    @$ar=(sort {$a<=>$b} (@$ar,@_));
    return 0+@$ar;
  }

  for my $v (@_){

    #not needed but often faster
    if(not defined $Pushsort_cmpsub){ #faster rank() in most cases
      push    @$ar, $v and next if $v>=$$ar[-1];
      unshift @$ar, $v and next if $v< $$ar[0];
    }

    splice @$ar, binsearch($v,$ar,1,$Pushsort_cmpsub)+1, 0, $v;
  }
  0+@$ar
}
sub pushsortstr(\@@){ local $Pushsort_cmpsub=sub{$_[0]cmp$_[1]}; pushsort(@_) }

=head2 binsearch

Returns the position of an element in a numerically sorted array. Returns undef if the element is not found.

B<Input:> Two, three or four arguments

First argument: the element to find. Usually a number.

Second argument: a reference to the array to search in. The array should be sorted in ascending numerical order (se exceptions below).

Third argument:  Optional. Default false.

If the third argument is false binsearcg returns undef is the element is not found.
If the third argument is true binsearch returns 0.5 plus closest position below the searched value.
Returns C< last position + 0.5 > if the searched element is greater than all elements in the sorted array.
Returns C< -0.5 > if the searched element is less than all elements in the sorted array.

Fourth argument: Optional. Default C<< sub { $_[0] <=> $_[1] } >>.

If present, the fourth argument is a code-ref that alters the way binsearch compares two elements.

Example:

 binsearch(10,[5,10,15,20]);                                # 1
 binsearch(10,[20,15,10,5],undef,sub{$_[1]<=>$_[0]});       # 2 search arrays sorted numerically in opposite order
 binsearch("c",["a","b","c","d"],undef,sub{$_[0]cmp$_[1]}); # 2 search arrays sorted alphanumerically
 binsearchstr("b",["a","b","c","d"]);                       # 1 search arrays sorted alphanumerically

 Whether not found should return undef or a fractional position.

=head2 binsearchstr

Same as binsearch except that the arrays is sorted alphanumerically (cmp) instead of numerically (<=>) and the searched element is a string, not a number. See L</binsearch>.

=cut

our $Binsearch_steps;
our $Binsearch_maxsteps=100;
sub binsearch
{
  my($search,$aref,$insertpos,$cmpsub)=@_; #search pos of search in array
  croak "binsearch did not get arrayref as second arg" if ref($aref) ne 'ARRAY';
  croak "binsearch got fourth arg which is not a code-ref" if $cmpsub and ref($cmpsub) ne 'CODE';
  return $insertpos ? -0.5 : undef if not @$aref;
  my($min,$max)=(0,$#$aref);
  $Binsearch_steps=0;
  while (++$Binsearch_steps <= $Binsearch_maxsteps) {
    my $middle=int(($min+$max+0.5)/2);
    my $middle_value=$$aref[$middle];

    #croak "binsearch got non-sorted array" if !$cmpsub and $$aref[$min]>$$aref[$min]
    #                                       or  $cmpsub and &$cmpsub($$aref[$min],$$aref[$min])>0;

    if(   !$cmpsub and $search < $middle_value
    or     $cmpsub and &$cmpsub($search,$middle_value) < 0  ) {      #print "<\n";
      $max=$min, next                   if $middle == $max and $min != $max;
      return $insertpos ? $middle-0.5 : undef if $middle == $max;
      $max=$middle;
    }
    elsif( !$cmpsub and $search > $middle_value
    or      $cmpsub and &$cmpsub($search,$middle_value) > 0 ) {      #print ">\n";
      $min=$max, next                   if $middle == $min and $max != $min;
      return $insertpos ? $middle+0.5 : undef if $middle == $min;
      $min=$middle;
    }
    else {                                                           #print "=\n";
      return $middle;
    }
  }
  croak "binsearch exceded $Binsearch_maxsteps steps";
}

sub binsearchfast { # binary search routine finds index just below value
  my ($x,$v)=@_;
  my ($klo,$khi)=(0,$#{$x});
  my $k;
  while (($khi-$klo)>1) {
    $k=int(($khi+$klo)/2);
    if ($$x[$k]>$v) { $khi=$k; } else { $klo=$k; }
  }
  return $klo;
}


sub binsearchstr {binsearch(@_[0..2],sub{$_[0]cmp$_[1]})}

sub rank
{
  my($rank,$aref,$cmpsub)=@_;
  if($rank<0){
    $cmpsub||=sub{$_[0]<=>$_[1]};
    return rank(-$rank,$aref,sub{0-&$cmpsub});
  }
  my @sort;
  local $Pushsort_cmpsub=$cmpsub;
  for(@$aref){
    pushsort @sort, $_;
    pop @sort if @sort>$rank;
  }
  return wantarray ? @sort : $sort[$rank-1];
}
sub rankstr {wantarray?(rank(@_,sub{$_[0]cmp$_[1]})):rank(@_,sub{$_[0]cmp$_[1]})}

=head2 eqarr

B<Input:> Two or more arrays. References to two or more arrays.

B<Output:> True (1) or false (0) for whether or not the arrays are
numerically and alphanumerically equal. Comparing each element in each
array with both C< == > and C< eq >.

Examples:

 eqarr([1,2,3],[1,2,3],[1,2,3]); # 1 (true)
 eqarr([1,2,3],[1,2,3],[1,2,4]); # 0 (false)
 eqarr([1,2,3],[1,2,3,4]);       # undef (difference size, false)
 eqarr([1,2,3]);                 # croak (should be two or more arrays)
 eqarr([1,2,3],1,2,3);           # croak (not arraysrefs)

=cut

sub eqarr
{
  my @arefs=@_;
  croak if @arefs<2;
  ref($_) ne 'ARRAY' and croak for @arefs;
  @{$arefs[0]} != @{$arefs[$_]} and return undef for 1..$#arefs;
  my $ant;
  
  for my $ar (@arefs[1..$#arefs]){
    for(0..@$ar-1){
      ++$ant and $ant>100 and croak ">100";
      return 0 if $arefs[0][$_] ne $$ar[$_]
   	       or $arefs[0][$_] != $$ar[$_];
    }
  }
  return 1;
}

=head2 sorted

  @a=(1..10);
  print "array is sorted" if sorted @a;

=cut

sub sorted (\@@)
{
  my($a,$cmpsub)=@_;
  for(0..$#$a-1){
    return 0 if !$cmpsub and $$a[$_]>$$a[$_+1]
             or  $cmpsub and &$cmpsub($$a[$_],$$a[$_+1])>0;
  }
  return 1;
}
sub sortedstr { sorted(@_,sub{$_[0]cmp$_[1]}) }

#=head1 SQL INSPIRED FUNCTIONS
#Inspired from Oracles SQL.

=head2 nvl

The I<no value> function (or I<null value> function)

C<nvl()> takes two or more arguments. (Oracles take just two)

Returns the value of the first input argument with length() > 0.

Return I<undef> if there is no such input argument.

In perl 5.10 and perl 6 this will most often be easier with the C< //
> operator, although C<nvl()> and C<< // >> treats empty strings C<"">
differently. Sub nvl here considers empty strings and undef the same.

=cut

sub nvl
{
  return $_[0] if defined $_[0] and length($_[0]) or @_==1;
  return $_[1] if @_==2;
  return nvl(@_[1..$#_]) if @_>2;
  return undef;
}

=head2 replace

Return the string in the first input argument, but where pairs of search-replace strings (or rather regexes) has been run.

Works as C<replace()> in Oracle, or rather regexp_replace() in Oracle 10. Except that this C<replace()> accepts more than three arguments.

Examples:

 print replace("water","ater","ine");  # Turns water into wine
 print replace("water","ater");        # w
 print replace("water","at","eath");   # weather
 print replace("water","wa","ju",
                       "te","ic",
                       "x","y",        # No x is found, no y is returned
                       'r$',"e");      # Turns water into juice. 'r$' says that the r it wants
                                       # to change should be the last letters. This reveals that
                                       # second, fourth, sixth and so on argument is really regexs,
                                       # not normal strings. So use \ (or \\ inside "") to protect
                                       # the special characters of regexes. You probably also
                                       # should write qr/regexp/ instead of 'regexp' if you make
                                       # use of regexps here, just to make it more clear that
                                       # these are really regexps, not strings.

 print replace('JACK and JUE','J','BL'); # prints BLACK and BLUE
 print replace('JACK and JUE','J');      # prints ACK and UE
 print replace("abc","a","b","b","c");   # prints ccc           (not bcc)

If the first argument is a reference to a scalar variable, that variable is changed "in place".

Example:

 my $str="test";
 replace(\$str,'e','ee','s','S');
 print $str;                         # prints teeSt

=cut

sub replace
{
  my $str=shift;
  return $$str=replace($$str,@_) if ref($str) eq 'SCALAR';
  while(@_){
    my($fra,$til)=(shift,shift);
    defined $til ? $str=~s/$fra/$til/g : $str=~s/$fra//g;
  }
  return $str;
}

=head2 decode_num

See L</decode>.

=head2 decode

C<decode()> and C<decode_num()> works just as Oracles C<decode()>.

C<decode()> and C<decode_num()> accordingly uses perl operators C<eq> and C<==> for comparison.

Examples:

 $a=123;
 print decode($a, 123,3, 214,4, $a);     # prints 3

The first argument is tested against the second, fourth, sixth and so
on argument, and then the third, fifth, seventh and so on argument is
returned if decode() finds an equal string or number.

In the above example: 123 maps to 3, 124 maps to 4 and the last argument ($a) is returned if C<decode> as the last resort if every other fails.

Since the operator C<< => >> is synonymous to the comma operator, the above example is probably more readable rewritten like this:

 my $a=123;
 print decode($a, 123=>3, 214=>4, $a);   # 3

More examples:

 my $a=123;
 print decode($a, 123=>3, 214=>7, $a);              # also 3,  note that => is synonym for , (comma) in perl
 print decode($a, 122=>3, 214=>7, $a);              # prints 123
 print decode($a,  123.0 =>3, 214=>7);              # prints 3
 print decode($a, '123.0'=>3, 214=>7);              # prints nothing (undef), no last argument default value here
 print decode_num($a, 121=>3, 221=>7, '123.0','b'); # prints b

Sort of:

 decode($string, %conversion, $default);

The last argument is returned as a default if none of the keys in the keys/value-pairs matched.

A more perl-ish and probaby faster way of doing the same:

 {123=>3, 214=>7}->{$a} || $a                       # (beware of 0)

=cut

sub decode
{
  croak "Must have a mimimum of two arguments" if @_<2;
  my $uttrykk=shift;
  if(defined$uttrykk){ shift eq $uttrykk and return shift or shift for 1..@_/2 }
  else               { not defined shift and return shift or shift for 1..@_/2 }
  return shift;
}

sub decode_num
{
  croak "Must have a mimimum of two arguments" if @_<2;
  my $uttrykk=shift;
  if(defined$uttrykk){ shift == $uttrykk and return shift or shift for 1..@_/2 }
  else               { not defined shift and return shift or shift for 1..@_/2 }
  return shift;
}

=head2 between

Input: Three arguments.

Returns: Something I<true> if the first argument is numerically between the two next.

=cut

sub between
{
  my($test,$fom,$tom)=@_;
  no warnings;
  return $fom<$tom ? $test>=$fom&&$test<=$tom
                   : $test>=$tom&&$test<=$fom;
}

=head2 bytes_readable

Input: a number

Output:

the number with a B behind if the number is less than 1000

the number divided by 1024 with two decimals and "kB" behind if the number is less than 1024*1000

the number divided by 1048576 with two decimals and "MB" behind if the number is less than 1024*1024*1000

the number divided by 1073741824 with two decimals and "GB" behind if the number is less than 1024*1024*1024*1000

the number divided by 1099511627776 with two decimals and "TB" behind otherwise

Examples:

 print bytes_readable(999);                              # 999 B
 print bytes_readable(1000);                             # 0.98 kB
 print bytes_readable(1024);                             # 1.00 kB
 print bytes_readable(1153433.6);                        # 1.10 MB
 print bytes_readable(1181116006.4);                     # 1.10 GB
 print bytes_readable(1209462790553.6);                  # 1.10 TB
 print bytes_readable(1088516511498.24*1000);            # 990.00 TB

=cut

sub bytes_readable
{
  my $bytes=shift();
  return undef if not defined $bytes;
  return "$bytes B"                      if abs($bytes)<2** 0*1000; #bytes
  return sprintf("%.2f kB",$bytes/2**10) if abs($bytes)<2**10*1000; #kilobyte
  return sprintf("%.2f MB",$bytes/2**20) if abs($bytes)<2**20*1000; #megabyte
  return sprintf("%.2f GB",$bytes/2**30) if abs($bytes)<2**30*1000; #gigabyte
  return sprintf("%.2f TB",$bytes/2**40) if abs($bytes)<2**40*1000; #terrabyte
  return sprintf("%.2f PB",$bytes/2**50); #petabyte, exabyte, zettabyte, yottabyte
}

=head2 distance

B<Input:> the four decimal numbers of latutude1, longitude1, latitude2, longitude2

B<Output:> the air distance fra point1 to point2 in meters, the SI unit for length.

Calculation is done using the Haversine Formula for spherical distance:

  a = sin((lat2-lat1)/2)^2
    + sin((lon2-lon1)/2)^2 * cos(lat1) * cos(lat2);

  c = 2 * atan2(min(1,sqrt(a)),
	        min(1,sqrt(1-a)))

  distance = c * R

With earth radius set to:

  R = Re - (Re-Rp) * sin(abs(lat1+lat2)/2)

Where C<Re = 6378137.0> (equatorial radius) and C<Rp = 6356752.3> (polar radius).

B<Example:>

 my @oslo= (59.93942,  10.75122);
 my @rio=  (59.939362,  10.751312);
 my @rio=  (-22.97673, -43.19508);

 printf "%.1f km\n",   distance(@oslo,@rio)/1000;     # 10431.5 km
 printf "%.1f km\n",   distance(@rio,@oslo)/1000;     # 10431.5 km
 printf "%.1f nmi\n",  distance(@oslo,@rio)/1852.000; # 5632.5 nmi   (nautical miles)
 printf "%.1f miles\n",distance(@oslo,@rio)/1609.344; # 6481.8 miles

See L<http://www.faqs.org/faqs/geography/infosystems-faq/>

and L<http://mathforum.org/library/drmath/view/51879.html>

and L<http://en.wikipedia.org/wiki/Earth_radius>

and L<Geo::Direction::Distance>, Acme::Tools::distance() is about 8 times faster.

=cut

our $Distance_factor=3.141592653589793238462643383279502884197169399375105820974944592307816406286 / 180;
sub acos { atan2( sqrt(1 - $_[0] * $_[0]), $_[0] ) }
sub distance_great_circle
{
  my($lat1,$lon1,$lat2,$lon2)=map $Distance_factor*$_, @_;
  my($Re,$Rp)=( 6378137.0, 6356752.3 ); #earth equatorial and polar radius
  my $R=$Re-($Re-$Rp)*sin(abs($lat1+$lat2)/2); #approx
  return $R*acos(sin($lat1)*sin($lat2)+cos($lat1)*cos($lat2)*cos($lon2-$lon1))
}

sub distance
{
  my($lat1,$lon1,$lat2,$lon2)=map $Distance_factor*$_, @_;
  my $a= sin(($lat2-$lat1)/2)**2
       + sin(($lon2-$lon1)/2)**2 * cos($lat1) * cos($lat2);
  my $sqrt_a  =sqrt($a);    $sqrt_a  =1 if $sqrt_a  >1;
  my $sqrt_1ma=sqrt(1-$a);  $sqrt_1ma=1 if $sqrt_1ma>1;
  my $c=2*atan2($sqrt_a,$sqrt_1ma);
  my($Re,$Rp)=( 6378137.0, 6356752.3 ); #earth equatorial and polar radius
  my $R=$Re-($Re-$Rp)*sin(abs($lat1+$lat2)/2); #approx
  return $c*$R;
}

  #my $R_authalic=6371007.2; #earth radius in meters, mean, Authalic radius, real R varies 6353-6384km, http://en.wikipedia.org/wiki/Earth_radius
#*)
         #    ( 6378157.5, 6356772.2 )  #hmm
    #my $e=0.081819218048345;#sqrt(1 - $b**2/$a**2); #eccentricity of the ellipsoid
    #my($a,$b)=( 6378137.0, 6356752.3 ); #earth equatorial and polar radius
    #warn "e=$e\n";
    #warn "t=".(1 - $e**2)."\n";
    #warn "n=".((1 - $e**2 * sin(($lat1+$lat1)/2)**2)**1.5)."\n";
    #my $t=1 - $e**2;
    #my $n=(1 - $e**2 * sin(($lat1+$lat1)/2)**2)**1.5;
    #warn "t=$t\n";
    #warn "n=$n\n";
    #$a * (1 - $e**2) / ((1 - $e**2 * sin(($lat1+$lat2)/2)**2)**1.5); #hmm avg lat
    #$R=$a * $t/$n;


# =head1 veci
# 
# Perls C<vec> takes 1, 2, 4, 8, 16, 32 and possibly 64 as its third argument.
# 
# This limitation is removed with C<veci> (vec improved, but much slower)
# 
# The third argument still needs to be 32 or lower (or possibly 64 or lower).
# 
# =cut
# 
# sub vecibs ($)
# {
#   my($s,$o,$b,$new)=@_;
#   if($b=~/^(1|2|4|8|16|32|64)$/){
#     return vec($s,$o,$b)=$new if @_==4;
#     return vec($s,$o,$b);
#   }
#   my $bb=$b<4?4:$b<8?8:$b<16?16:$b<32?32:$b<64?64:die;
#   my $ob=int($o*$b/$bb);
#   my $v=vec($s,$ob,$bb)*2**$bb+vec($s,$ob+1,$bb);
#   $v & (2**$b-1)
# }

=head1 ARRAYS, HASHES

=head2 distinct

Returns the values of the input list, sorted alfanumerically, but only
one of each value. This is the same as L</uniq> except uniq does not
sort the returned list.

Example:

 print join(", ", distinct(4,9,3,4,"abc",3,"abc"));    # 3, 4, 9, abc
 print join(", ", distinct(4,9,30,4,"abc",30,"abc"));  # 30, 4, 9, abc       note: alphanumeric sort

=cut

sub distinct { return sort keys %{{map {($_,1)} @_}} }

=head2 in

Returns I<1> (true) if first argument is in the list of the remaining arguments. Uses the perl-operator C<< eq >>.

Otherwise it returns I<0> (false).

 print in(  5,   1,2,3,4,6);         # 0
 print in(  4,   1,2,3,4,6);         # 1
 print in( 'a',  'A','B','C','aa');  # 0
 print in( 'a',  'A','B','C','a');   # 1

I guess in perl 5.10 or perl 6 you could use the C<< ~~ >> operator instead.

=head2 in_num

Just as sub L</in>, but for numbers. Internally uses the perl operator C<< == >> instead of C< eq >.

 print in(5000,  '5e3');          # 0
 print in(5000,   5e3);           # 1 since 5e3 is converted to 5000 before the call
 print in_num(5000, 5e3);         # 1
 print in_num(5000, '+5.0e03');   # 1

=cut

sub in
{
  no warnings 'uninitialized';
  my $val=shift;
  for(@_){ return 1 if $_ eq $val }
  return 0;
}

sub in_num
{
  no warnings 'uninitialized';
  my $val=shift;
  for(@_){ return 1 if $_ == $val }
  return 0;
}

=head2 union

Input: Two arrayrefs. (Two lists, that is)

Output: An array containing all elements from both input lists, but no element more than once even if it occurs twice or more in the input.

Example, prints 1,2,3,4:

 perl -MAcme::Tools -le 'print join ",", union([1,2,3],[2,3,3,4,4])'              # 1,2,3,4

=cut

sub union
{
  my %seen;
  return grep{!$seen{$_}++}(@{shift()},@{shift()});
}

=head2 minus

Input: Two arrayrefs.

Output: An array containing all elements in the first input array but not in the second.

Example:

 perl -MAcme::Tools -le 'print join " ", minus( ["five", "FIVE", 1, 2, 3.0, 4], [4, 3, "FIVE"] )'

Output is C<< five 1 2 >>.

=cut

sub minus
{
  my %seen;
  my %notme=map{($_=>1)}@{$_[1]};
  return grep{!$notme{$_}&&!$seen{$_}++}@{$_[0]};
}

=head2 intersect

Input: Two arrayrefs

Output: An array containing all elements which exists in both input arrays.

Example:

 perl -MAcme::Tools -le 'print join" ", intersect( ["five", 1, 2, 3.0, 4], [4, 2+1, "five"] )'      # 4 3 five

Output: C<< 4 3 five >>

=cut

sub intersect
{
  my %first=map{($_=>1)}@{$_[0]};
  my %seen;
  return grep{$first{$_}&&!$seen{$_}++}@{$_[1]};
}

=head2 not_intersect

Input: Two arrayrefs

Output: An array containing all elements member of just one of the input arrays (not both).

Example:

 perl -MAcme::Tools -le ' print join " ", not_intersect( ["five", 1, 2, 3.0, 4], [4, 2+1, "five"] )'

The output is C<< 1 2 >>.

=cut

sub not_intersect
{
  my %code;
  my %seen;
  for(@{$_[0]}){$code{$_}|=1}
  for(@{$_[1]}){$code{$_}|=2}
  return grep{$code{$_}!=3&&!$seen{$_}++}(@{$_[0]},@{$_[1]});
}

=head2 uniq

Input:    An array of strings (or numbers)

Output:   The same array in the same order, except elements which exists earlier in the list.

Same as L</distinct> but distinct sorts the returned list, I<uniq> does not.

Example:

 my @t=(7,2,3,3,4,2,1,4,5,3,"x","xx","x",02,"07");
 print join " ", uniq @t;                          # prints  7 2 3 4 1 5 x xx 07

=cut

sub uniq(@)
{
  my %seen;
  return grep{!$seen{$_}++}@_;
}

=head2 zip

B<Input:> Two or more arrayrefs. A number of equal sized arrays
containing numbers, strings or anything really.

B<Output:> An array of those input arrays zipped (interlocked, merged) into each other.

 print join " ", zip( [1,3,5], [2,4,6] );               # 1 2 3 4 5 6
 print join " ", zip( [1,4,7], [2,5,8], [3,6,9] );      # 1 2 3 4 5 6 7 8 9

Example:

zip() creates a hash where the keys are found in the first array and values in the secord in the correct order:

 my @media = qw/CD DVD VHS LP Blueray/;
 my @count = qw/20 12  2   4  3/;
 my %count = zip(\@media,\@count);                 # or zip( [@media], [@count] )
 print "I got $count{DVD} DVDs\n";                 # I got 12 DVDs

Dies (croaks) if the two lists are of different sizes

...or any input argument is not an array ref.

=cut

sub zip
{
  my @t=@_;
  ref($_) ne 'ARRAY' and croak "ERROR: zip should have arrayrefs as arguments" for @t;
  @{$t[$_]} != @{$t[0]} and croak "ERROR: zip should have equal sized arrays" for 1..$#t;
  my @res;
  for my $i (0..@{$t[0]}-1){
    push @res, $$_[$i] for @t;
  }
  return @res;
}


=head2 subhash

Copies a subset of keys/values from one hash to another.

B<Input:> First argument is a reference to a hash. The rest of the arguments are a list of the keys of which key/value-pair you want to be copied.

B<Output:> The hash consisting of the keys and values you specified.

Example:

 %population = ( Norway=>5000000, Sweden=>9500000, Finland=>5400000,
                 Denmark=>5600000, Iceland=>320000,
                 India => 1.21e9, China=>1.35e9, USA=>313e6, UK=>62e6 );

 %scandinavia = subhash( \%population , 'Norway', 'Sweden', 'Denmark' ); # this and
 %scandinavia = (Norway=>5000000,Sweden=>9500000,Denmark=>5600000);      # this is the same

 print "Population of $_ is $scandinavia{$_}\n" for keys %scandinavia;

...prints the populations of the three scandinavian countries.

Note: The values are NOT deep copied when they are references. (Use C<< Storable::dclone() >> to do that).

=cut

sub subhash
{
  my $hr=shift;
  my @r;
  for(@_){ push@r,($_=>$$hr{$_}) }
  return @r;
}

=head2 hashtrans

B<Input:> a reference to a hash of hashes

B<Output:> a hash like the input-hash, but matrix transposed (kind of). Think of it as if X and Y has swapped places.

 %h = ( 1 => {a=>33,b=>55},
        2 => {a=>11,b=>22},
        3 => {a=>88,b=>99} );
 print serialize({hashtrans(\%h)},'v');

Gives:

 %v=( 'a'=>{'1'=>'33','2'=>'11','3'=>'88'},
      'b'=>{'1'=>'55','2'=>'22','3'=>'99'} );

=cut

#Hashtrans brukes automatisk n�r f�rste argument er -1 i sub hashtabell()

sub hashtrans
{
    my $h=shift;
    my %new;
    for my $k (keys%$h){
	my $r=$$h{$k};
	for(keys%$r){
	    $new{$_}{$k}=$$r{$_};
	}
    }
    return %new;
}

=head1 RANDOM

=head2 random

B<Input:> One or two arguments.

B<Output:>

If the argument one and two are not refs: returns a random integer between the integers in argument one and two.

If the first argument is an arrayref: returns a random member of that array without changing the array.

If the first argument is an hashref and there is no second arg: return a random key weighted by the values of that hash

If the first argument is an hashref and there is a second arg: return that many random keys weighted by the values of that hash

If there is no second argument and the first is an integer, a random integer between 0 and that number is returned. Including 0 and the number itself.

B<Examples:>

 $dice=random(1,6);                                   # 1, 2, 3, 4, 5 or 6
 $dice=random([1..6]);                                # same as previous
 $dice=random({1=>1, 2=>1, 3=>1, 4=>1, 5=>1, 6=>2});  # weighted dice with 6 being twice as likely as the others
 print random({head=>0.499,tail=>0.499,edge=>0.002}); # coin toss (sum 1 here but not required to be)
 print random(2);                                     # prints 0, 1 or 2
 print 2**random(7);                                  # prints 1, 2, 4, 8, 16, 32, 64 or 128

=cut

sub random
{
  my($from,$to)=@_;
  my $ref=ref($from);
  if($ref eq 'ARRAY'){
   #return $$from[random($#$from)];
    return $$from[rand(1+$#$from)];
  }
  elsif($ref eq 'HASH') {
    my @k=sort(keys(%$from));
    my $max=0; $$from{$_}>$max and $max=$$from{$_} or $$from{$_}<0 and die for @k;
    my @r;
    for(1 .. $to||1){
      while (1) {
	my $r=$k[rand(1+$#k)]; #random(\@k);
	push@r,$r and last if rand($max)<$$from{$r};
      }
    }
    return @_>1?@r:$r[0] ;
  }
  ($from,$to)=(0,$from) if @_==1;
  ($from,$to)=($to,$from) if $from>$to;
  return int($from+rand(1+$to-$from));
}

=head2 random_gauss

Returns an pseudo-random number with a Gaussian distribution instead
of the uniform distribution of perls C<rand()> or C<random()> in this
module.  The algorithm is a variation of the one at
L<http://www.taygeta.com/random/gaussian.html> which is both faster
and better than adding a long series of C<rand()>.

Uses perls C<rand> function internally.

B<Input:> 0 - 3 arguments.

First argument: the average of the distribution. Default 0.

Second argument: the standard deviation of the distribution. Default 1.

Third argument: If a third argument is present, C<random_gauss>
returns an array of that many pseudo-random numbers. If there is no
third argument, a number (a scalar) is returned.

B<Output:> One or more pseudo-random numbers with a Gaussian distribution. Also known as a Bell curve or Normal distribution.

Example:

 my @I=random_gauss(100, 15, 100000);         # produces 100000 pseudo-random numbers, average=100, stddev=15
 #my @I=map random_gauss(100, 15), 1..100000; # same but more than three times slower
 print "Average is:    ".avg(@I)."\n";        # prints a number close to 100
 print "Stddev  is:    ".stddev(@I)."\n";     # prints a number close to 15

 my @M=grep $_>100+15*2, @I;                  # those above 130
 print "Percent above two stddevs: ".(100*@M/@I)."%\n"; #prints a number close to 2.2%

Example 2:

 my $num=1e6;
 my @h; $h[$_/2]++ for random_gauss(100,15, $num);
 $h[$_] and printf "%3d - %3d %6d %s\n",
   $_*2,$_*2+1,$h[$_],'=' x ($h[$_]*1000/$num)
     for 1..200/2;

...prints an example of the famous Bell curve:

  44 -  45     70 
  46 -  47    114 
  48 -  49    168 
  50 -  51    250 
  52 -  53    395 
  54 -  55    588 
  56 -  57    871 
  58 -  59   1238 =
  60 -  61   1807 =
  62 -  63   2553 ==
  64 -  65   3528 ===
  66 -  67   4797 ====
  68 -  69   6490 ======
  70 -  71   8202 ========
  72 -  73  10577 ==========
  74 -  75  13319 =============
  76 -  77  16283 ================
  78 -  79  20076 ====================
  80 -  81  23742 =======================
  82 -  83  27726 ===========================
  84 -  85  32205 ================================
  86 -  87  36577 ====================================
  88 -  89  40684 ========================================
  90 -  91  44515 ============================================
  92 -  93  47575 ===============================================
  94 -  95  50098 ==================================================
  96 -  97  52062 ====================================================
  98 -  99  53338 =====================================================
 100 - 101  52834 ====================================================
 102 - 103  52185 ====================================================
 104 - 105  50472 ==================================================
 106 - 107  47551 ===============================================
 108 - 109  44471 ============================================
 110 - 111  40704 ========================================
 112 - 113  36642 ====================================
 114 - 115  32171 ================================
 116 - 117  28166 ============================
 118 - 119  23618 =======================
 120 - 121  19873 ===================
 122 - 123  16360 ================
 124 - 125  13452 =============
 126 - 127  10575 ==========
 128 - 129   8283 ========
 130 - 131   6224 ======
 132 - 133   4661 ====
 134 - 135   3527 ===
 136 - 137   2516 ==
 138 - 139   1833 =
 140 - 141   1327 =
 142 - 143    860 
 144 - 145    604 
 146 - 147    428 
 148 - 149    275 
 150 - 151    184 
 152 - 153    111 
 154 - 155     67 

=cut

sub random_gauss
{
  my($avg,$stddev,$num)=@_;
  $avg=0    if not defined $avg;
  $stddev=1 if not defined $stddev;
  $num=1    if not defined $num;
  croak "random_gauss should not have more than 3 arguments" if @_>3;
  my @r;
  while (@r<$num) {
    my($x1,$x2,$w);
    do {
      $x1=2.0*rand()-1.0;
      $x2=2.0*rand()-1.0;
      $w=$x1*$x1+$x2*$x2;
    } while $w>=1.0;
    $w=sqrt(-2.0*log($w)/$w) * $stddev;
    push @r,  $x1*$w + $avg,
              $x2*$w + $avg;
  }
  pop @r if @r > $num;
  return $r[0] if @_<3;
  return @r;
}

=head2 big

=head2 bigi

=head2 bigf

=head2 bigscale

big, bigi, bigf and bigscale are just convenient shorthands for using
L<Math::BigInt>->new() and L<Math::BigFloat>->new() preferably with
the GMP for faster calculations. Use those modules instead of the real
deal. Examples:

  my $num1 = big(3);      #returns a new Math::BigInt-object
  my $num2 = big('3.0');  #returns a new Math::BigFloat-object
  my $num3 = big(3.0);    #returns a new Math::BigInt-object
  my $num4 = big(3.1);    #returns a new Math::BigFloat-object
  my($int1,$float1,$int2,$float2) = big(3,'3.0',3.0,3.1); #returns the four new numbers, as the above four lines
                                                          #uses wantarray

  print 2**1000;          #1.60693804425899e+60
  print big(2)**1000;     #1606938044258990275541962092341162602522202993782792835301376
  print 2**big(1000);     #1606938044258990275541962092341162602522202993782792835301376

  print 1/7;              #0.142857142857143
  print 1/big(7);         #0      because of integer arithmetics
  print 1/big(7.0);       #0      because of integer arithmetics
  print 1/big('7.0');     #0.1428571428571428571428571428571428571429
  print 1/bigf(7);        #0.1428571428571428571428571428571428571429
  print bigf(1/7);        #0.142857142857143   probably not what you wanted

  bigscale(60);           #increase precesion from the default 40
  print 1/bigf(7);        #0.142857142857142857142857142857142857142857142857142857142857

Instead of guessing on int or float by looking for a C<.> character
like C<big> do, C<bigi> and C<bigf> explicitly orders int and float
respectively.

B<Note:> Acme::Tools does not itself require Math::BigInt and
Math::BigFloat and GMP, but these four big*-subs do (by internal
C<require>).  To these four (effectively) you should install
Math::BigInt::GMP and Math::BigFloat::GMP like this:

  cpan Math::BigFloat Math::GMP Math::BingInt::GMP          # or
  yum install perl-Math-BigInt-GMP perl-Math-GMP            # on RedHat, RHEL or
  apt-get install libmath-bigint-gmp-perl libmath-gmp-perl  # on Ubuntu or some other way

=cut

sub bigi
{
  eval{q(use Math::BigInt try=>"GMP")} if not $INC{'Math/BigInt.pm'};
  if (wantarray) { return (map Math::BigInt->new($_),@_)  }
  else           { return Math::BigInt->new($_[0])        }
}
sub bigf
{
  eval{q(use Math::BigFloat try=>"GMP")} if not $INC{'Math/BigFloat.pm'};
  if (wantarray) { return (map Math::BigFloat->new($_),@_)  }
  else           { return Math::BigFloat->new($_[0])        }
}
sub big
{
  wantarray 
  ? (map $_=~/\./ ? bigf($_)    : bigi($_), @_)
  :   $_[0]=~/\./ ? bigf($_[0]) : bigi($_[0]);
}
sub bigscale
{
  @_==1 or croak "bigscale requires one and only one argument";
  my $scale=shift();
  eval{q(use Math::BigInt    try=>"GMP")} if not $INC{'Math/BigInt.pm'};
  eval{q(use Math::BigFloat  try=>"GMP")} if not $INC{'Math/BigFloat.pm'};
  Math::BigInt->div_scale($scale);
  Math::BigFloat->div_scale($scale);
  return;
}

=head2 mix

C<mix()> could also have been named C<shuffle()>, as in shuffling a deck of cards.

Note: C<List::Util::shuffle()> is approximately four times faster. Both respects C<srand()>.

Example:

Mixes an array in random order. This:

 print mix("a".."z"),"\n" for 1..3;

...could write something like:

 trgoykzfqsduphlbcmxejivnwa
 qycatilmpgxbhrdezfwsovujkn
 ytogrjialbewcpvndhkxfzqsmu

B<Input:>

=over 4

=item 1.
Either a reference to an array as the only input. This array will then be mixed I<in-place>. The array will be changed:

This: C<< @a=mix(@a) >> is the same as:  C<< mix(\@a) >>.

=item 2.
Or an array of zero, one or more elements.

=back

Note that an input-array which COINCIDENTLY SOME TIMES has one element
(but more other times), and that element is an array-ref, you will
probably not get the expected result.

To check distribution:

 perl -MAcme::Tools -le 'print mix("a".."z") for 1..26000'|cut -c1|sort|uniq -c|sort -n

The letters a-z should occur around 1000 times each.

Shuffles a deck of cards: (s=spaces, h=hearts, c=clubs, d=diamonds)

 perl -MAcme::Tools -le '@cards=map join("",@$_),cart([qw/s h c d/],[2..10,qw/J Q K A/]); print join " ",mix(@cards)'

(Uses L</cart>, which is not a typo, see further down here)

=cut

sub mix
{
  if(@_==1 and ref($_[0]) eq 'ARRAY'){ #kun ett arg, og det er ref array
    my $r=$_[0];
    push@$r,splice(@$r,rand(@$r-$_),1) for 0..(@$r-1);
    return $r;
  }
  else{
    my@e=@_;
    push@e,splice(@e,rand(@e-$_),1) for 0..$#e;
    return @e;
  }
}

=head1 COMPRESSION

L</zipb64>, L</unzipb64>, L</zipbin>, L</unzipbin>, L</gzip>, and L</gunzip>
compresses and uncompresses strings to save space in disk, memory,
database or network transfer. Trades time for space. (Beware of wormholes)

=head2 zipb64

Compresses the input (text or binary) and returns a base64-encoded string of the compressed binary data.
No known limit on input length, several MB has been tested, as long as you've got the RAM...

B<Input:> One or two strings.

First argument: The string to be compressed.

Second argument is optional: A I<dictionary> string.

B<Output:> a base64-kodet string of the compressed input.

The use of an optional I<dictionary> string will result in an even
further compressed output in the dictionary string is somewhat similar
to the string that is compressed (the data in the first argument).

If x relatively similar string are to be compressed, i.e. x number
automatic of email responses to some action by a user, it will pay of
to choose one of those x as a dictionary string and store it as
such. (You will also use the same dictionary string when decompressing
using L</unzipb64>.

The returned string is base64 encoded. That is, the output is 33%
larger than it has to be.  The advantage is that this string more
easily can be stored in a database (without the hassles of CLOB/BLOB)
or perhaps easier transfer in http POST requests (it still needs some
url-encoding, normally). See L</zipbin> and L</unzipbin> for the
same without base 64 encoding.

Example 1, normal compression without dictionary:

  $txt = "Test av komprimering, hva skjer? " x 10;  # ten copies of this norwegian string, $txt is now 330 bytes (or chars rather...)
  print length($txt)," bytes input!\n";             # prints 330
  $zip = zipb64($txt);                              # compresses
  print length($zip)," bytes output!\n";            # prints 65
  print $zip;                                       # prints the base64 string ("noise")

  $output=unzipb64($zip);                              # decompresses
  print "Hurra\n" if $output eq $txt;               # prints Hurra if everything went well
  print length($output),"\n";                       # prints 330

Example 2, same compression, now with dictionary:

  $txt = "Test av komprimering, hva skjer? " x 10;  # Same original string as above
  $dict = "Testing av kompresjon, hva vil skje?";   # dictionary with certain similarities
                                                    # of the text to be compressed
  $zip2 = zipb64($txt,$dict);                          # compressing with $dict as dictionary
  print length($zip2)," bytes output!\n";           # prints 49, which is less than 65 in ex. 1 above
  $output=unzipb64($zip2,$dict);                       # uses $dict in the decompressions too
  print "Hurra\n" if $output eq $txt;               # prints Hurra if everything went well


Example 3, dictionary = string to be compressed: (out of curiosity)

  $txt = "Test av komprimering, hva skjer? " x 10;  # Same original string as above
  $zip3 = zipb64($txt,$txt);                           # hmm
  print length($zip3)," bytes output!\n";           # prints 25
  print "Hurra\n" if unzipb64($zip3,$txt) eq $txt;     # hipp hipp ...

zipb64() and zipbin() is really just wrappers around L<Compress::Zlib> and C<inflate()> & co there.

=cut

sub zipb64
{
  require MIME::Base64;
  return MIME::Base64::encode_base64(zipbin(@_));
}


=head2 zipbin

C<zipbin()> does the same as C<zipb64()> except that zipbin()
does not base64 encode the result. Returns binary data.

See L</zip> for documentation.

=cut

sub zipbin
{
  require Compress::Zlib;
  my($data,$dict)=@_;
  my $x=Compress::Zlib::deflateInit(-Dictionary=>$dict,-Level=>Compress::Zlib::Z_BEST_COMPRESSION()) or croak();
  my($output,$status)=$x->deflate($data); croak() if $status!=Compress::Zlib::Z_OK();
  my($out,$status2)=$x->flush(); croak() if $status2!=Compress::Zlib::Z_OK();
  return $output.$out;
}

=head2 unzipb64

Opposite of L</zipb64>.

Input: 

First argument: A string made by L</zipb64>

Second argument: (optional) a dictionary string which where used in L</zipb64>.

Output: The original string (be it text or binary).

See L</zipb64>.

=cut

sub unzipb64
{
  my($data,$dict)=@_;
  require MIME::Base64;
  unzipbin(MIME::Base64::decode_base64($data),$dict);
}

=head2 unzipbin

C<unzipbin()> does the same as L</unzip> except that C<unzipbin()>
wants a pure binary compressed string as input, not base64.

See L</unzipb64> for documentation.

=cut

sub unzipbin
{
  require Compress::Zlib;
  require Carp;
  my($data,$dict)=@_;
  my $x=Compress::Zlib::inflateInit(-Dictionary=>$dict) or croak();
  my($output,$status)=$x->inflate($data);
  croak() if $status!=Compress::Zlib::Z_STREAM_END();
  return $output;
}

=head2 gzip

B<Input:> A string you want to compress. Text or binary.

B<Output:> The binary compressed representation of that input string.

C<gzip()> is really the same as C< Compress:Zlib::memGzip() > except
that C<gzip()> just returns the input-string if for some reason L<Compress::Zlib>
could not be C<required>. Not installed or not found.  (L<Compress::Zlib> is a built in module in newer perl versions).

C<gzip()> uses the same compression algorithm as the well known GNU program gzip found in most unix/linux/cygwin distros. Except C<gzip()> does this in-memory. (Both using the C-library C<zlib>).

=cut

sub gzip
{
  my $s=shift();
  eval{     # tries gzip, if it works it works, else returns the input
    require Compress::Zlib;
    $s=Compress::Zlib::memGzip(\$s);
  };undef$@;
  return $s;
}

=head2 gunzip

B<Input:> A binary compressed string. I.e. something returned from 
C<gzip()> earlier or read from a C<< .gz >> file.

B<Output:> The original larger non-compressed string. Text or binary. 

=cut

sub gunzip
{
  my $s=shift();
  eval {
    require Compress::Zlib;
    $s=Compress::Zlib::memGunzip(\$s);
  };undef$@;
  return $s;
}

=head2 bzip2

See L</gzip> and L</gunzip>.

C<bzip2()> and C<bunzip2()> works just as  C<gzip()> and C<gunzip()>,
but use another compression algorithm. This is usually better but slower
than the C<gzip>-algorithm. Especially in the compression. Decompression speed is less different.

See also C<man bzip2>, C<man bunzip2> and L<Compress::Bzip2>

=cut

sub bzip2
{
  my $s=shift();
  eval{
    require Compress::Bzip2;
    $s=Compress::Bzip2::memBzip($s);
  };
  undef$@;
  return $s;
}

=head2 bunzip2

Decompressed something compressed by bzip2() or the data from a C<.bz2> file. See L</bzip2>.

=cut

sub bunzip2
{
  my $s=shift();
  eval{
    require Compress::Bzip2;
    $s=Compress::Bzip2::memBunzip($s);
  };undef$@;
  return $s;
}


=head1 NET, WEB, CGI-STUFF

=head2 ipaddr

B<Input:> an IP-number

B<Output:> either an IP-address I<machine.sld.tld> or an empty string
if the DNS lookup didn't find anything.

Example:

 perl -MAcme::Tools -le 'print ipaddr("129.240.8.200")'  # prints www.uio.no

Uses perls C<gethostbyaddr> internally.

C<ipaddr()> memoizes the results internally (using the
C<%Acme::Tools::IPADDR_memo> hash) so only the first loopup on a
particular IP number might take some time.

Some few DNS loopups can take several seconds.
Most is done in a fraction of a second. Due to this slowness, medium to high traffic web servers should
probably turn off hostname lookups in their logs and just log IP numbers by using
C<HostnameLookups Off> in Apache C<httpd.conf> and then use I<ipaddr> afterwards if necessary.

=cut

our %IPADDR_memo;
sub ipaddr
{
  my $ipnr=shift;
  return $IPADDR_memo{$ipnr} if exists $IPADDR_memo{$ipnr};

  #NB, 2-tallet p� neste kodelinje er ikke det samme p� alle os,
  #men ser ut til � funke i linux og hpux. Den Riktige M�ten(tm)
  #er konstanten AF_INET i Socket eller IO::Socket-pakken.

  my $ipaddr=gethostbyaddr(pack("C4",split("\\.",$ipnr)),2);
  $IPADDR_memo{$ipnr} = $ipaddr;
  return $IPADDR_memo{$ipnr};
}

=head2 ipnum

C<ipnum()> does the opposite of C<ipaddr()>

Does an attempt of converting an IP address (hostname) to an IP number.
Uses DNS name servers via perls internal C<gethostbyname()>.
Return empty string (undef) if unsuccessful.

 print ipnum("www.uio.no");   # prints 129.240.13.152

Does internal memoization via the hash C<%Acme::Tools::IPNUM_memo>.

=cut

our %IPNUM_memo;
sub ipnum
{
  my $ipaddr=shift;
  #croak "No $ipaddr" if not length($ipaddr);
  return $IPNUM_memo{$ipaddr} if exists $IPNUM_memo{$ipaddr};
  my $h=gethostbyname($ipaddr);
  #croak "No ipnum for $ipaddr" if not $h;
  return if not defined $h;
  my $ipnum = join(".",unpack("C4",$h));
  $IPNUM_memo{$ipaddr} = $ipnum=~/^(\d+\.){3}\d+$/ ? $ipnum : undef;
  return $IPNUM_memo{$ipaddr};
}

=head2 webparams

B<Input:> (optional)

Zero or one input argument: A string of the same type often found behind the first question mark (C<< ? >>) in URLs.

This string can have one or more parts separated by C<&> chars.

Each part consists of C<key=value> pairs (with the first C<=> char being the separation char).

Both C<key> and C<value> can be url-encoded.

If there is no input argument, C<webparams> uses C<< $ENV{QUERY_STRING} >> instead.

If also  C<< $ENV{QUERY_STRING} >> is lacking, C<webparams()> checks if C<< $ENV{REQUEST_METHOD} eq 'POST' >>.
In that case C<< $ENV{CONTENT_LENGTH} >> is taken as the number of bytes to be read from C<STDIN>
and those bytes are used as the missing input argument.

The environment variables QUERY_STRING, REQUEST_METHOD and CONTENT_LENGTH is
typically set by a web server following the CGI standard (which Apache and
most of them can do I guess) or in mod_perl by Apache. Although you are
probably better off using L<CGI>. Or C<< $R->args() >> or C<< $R->content() >> in mod_perl.

B<Output:>

C<webparams()> returns a hash of the key/value pairs in the input argument. Url-decoded.

If an input string has more than one occurrence of the same key, that keys value in the returned hash will become concatenated each value separated by a C<,> char. (A comma char)

Examples:

 use Acme::Tools;
 my %R=webparams();
 print "Content-Type: text/plain\n\n";                          # or rather \cM\cJ\cM\cJ instead of \n\n to be http-compliant
 print "My name is $R{name}";

Storing those four lines in a file in the directory designated for CGI-scripts
on your web server (or perhaps naming the file .cgi is enough), and C<chmod +x
/.../cgi-bin/script> and the URL
L<http://some.server.somewhere/cgi-bin/script?name=HAL> will print
C<My name is HAL> to the web page.

L<http://some.server.somewhere/cgi-bin/script?name=Bond&name=+James+Bond> will print C<My name is Bond, James Bond>.

=cut

sub webparams
{
  my $query=shift();
  $query=$ENV{QUERY_STRING} if not defined $query;
  if(not defined $query  and  $ENV{REQUEST_METHOD} eq "POST"){
    read(STDIN,$query , $ENV{CONTENT_LENGTH});
    $ENV{QUERY_STRING}=$query;
  }
  my %R;
  for(split("&",$query)){
    next if !length($_);
    my($nkl,$verdi)=map urldec($_),split("=",$_,2);
    $R{$nkl}=exists$R{$nkl}?"$R{$nkl},$verdi":$verdi;
  }
  return %R;
}

=head2 urlenc

Input: a string

Output: the same string URL encoded so it can be sent in URLs or POST requests.

In URLs (web addresses) certain characters are illegal. For instance I<space> and I<newline>.
And certain other chars have special meaning, such as C<+>, C<%>, C<=>, C<?>, C<&>.

These illegal and special chars needs to be encoded to be sent in
URLs.  This is done by sending them as C<%> and two hex-digits. All
chars can be URL encodes this way, but it's necessary just on some.

Example:

 $search="�stdal, �ge";
 my $url="http://machine.somewhere.com/search?q=" . urlenc($search);
 print $url;

Prints C<< http://machine.somewhere.com/search?q=%D8stdal%2C%20%C5ge >>

=cut

sub urlenc
{
  my $str=shift;
  $str=~s/([^\w\-\.\/\,\[\]])/sprintf("%%%02x",ord($1))/eg; #more chars is probably legal...
  return $str;
}

=head2 urldec

Opposite of L</urlenc>.

Example, this returns 'C< �>'. That is space and C<< � >>.

 urldec('+%C3')

=cut

sub urldec{
  my $str=shift;
  $str=~s/\+/ /gs;
  $str=~s/%([a-f\d]{2})/pack("C", hex($1))/egi;
  return $str;
}

=head2 ht2t

C<ht2t> is short for I<html-table to table>.

This sub extracts an html-C<< <table> >>s and returns its C<< <tr>s >>
and C<< <td>s >> as an array of arrayrefs. And strips away any html
inside the C<< <td>s >> as well.

 my @table = ht2t($html,'some string occuring before the <table> you want');

Input: One or two arguments.

First argument: the html where a C<< <table> >> is to be found and converted.

Second argument: (optional) If the html contains more than one C<<
<table> >>, and you do not want the first one, applying a second
argument is a way of telling C<ht2t> which to capture: the one with this word
or string occurring before it.

Output: An array of arrayrefs.

C<ht2t()> is a quick and dirty way of scraping (or harvesting as it is
also called) data from a web page. Look too L<HTML::Parse> to do this
more accurate.

Example:

 use Acme::Tools;
 use LWP::Simple;
 for(
   ht2t(
     get("http://www.norges-bank.no/templates/article____200.aspx"),
     "Effektiv kronekurs"
   )
 ){
  my($country, $countrycode, $currency) = @$_;
  print "$country ($countrycode) uses $currency\n";
 }

Output:

 Australia (AUD) uses Dollar
 Belgia (BEF) uses Franc (Euro)
 Brasil (BRL) uses Real
 Bulgaria (BGN) uses Lev
 Canada (CAD) uses Dollar
 Danmark (DKK) uses Krone

...and so on.

=cut

sub ht2t {
  my($f,$s)=@_;
  $f=~s,.*?($s).*?(<table.*?)</table.*,$2,si;
  my $e=0;$e++ while index($f,$s=chr($e))>=$[;
  $f=~s/<t(d|r|h).*?>/\l$1$s/gsi;
  $f=~s/\s*<.*?>\s*/ /gsi;
  my @t=split("r$s",$f);shift @t;
  for(@t){my @r=split(/[dh]$s/,$_);shift @r;$_=[@r]}
  @t;
}

=head1 FILES, DIRECTORIES

=head2 chall

Does chmod + utime + chown on one or more files.

Returns the number of files of which those operations was successful.

Mode, uid, gid, atime and mtime are set from the array ref in the first argument.

The first argument references an array which is exactly like an array returned from perls internal C<stat($filename)> -function.

Example:

 my @stat=stat($filenameA);
 chall( \@stat, $filenameB, $filenameC, ... );

Copies the chmod, owner, group, access time and modify time from file A to file B and C.

See C<perldoc -f stat>, C<perldoc -f chmod>, C<perldoc -f chown>, C<perldoc -f utime>

=cut



sub chall
{
  my($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks )
    = ref($_[0]) ? @{shift()} : stat(shift());
  my $successful=0;
  for(@_){ chmod($mode,$_) && utime($atime,$mtime,$_) && chown($uid,$gid,$_) && $successful++ }
  return $successful;
}

=head2 makedir

Input: One or two arguments.

Works like perls C<mkdir()> except that C<makedir()> will create nesessary parent directories if they dont exists.

First input argument: A directory name (absolute, starting with C< / > or relative).

Second input argument: (optional) permission bits. Using the normal C<< 0777^umask() >> as the default if no second input argument is provided.

Example:

 makedir("dirB/dirC")

...will create directory C<dirB> if it does not already exists, to be able to create C<dirC> inside C<dirB>.

Returns true on success, otherwise false.

C<makedir()> memoizes directories it has checked for existence before (trading memory for speed).

See also C<< perldoc -f mkdir >>, C<< man umask >>

=cut

our %MAKEDIR;

sub makedir
{
  my($d,$p,$dd)=@_;
  $p=0777^umask() if !defined$p;
  (
  $MAKEDIR{$d} or -d$d or mkdir($d,$p) #or croak("mkdir $d, $p")
  or ($dd)=($d=~m,^(.+)/+([^/]+)$,) and makedir($dd,$p) and mkdir($d,$p) #or die;
  ) and ++$MAKEDIR{$d};
}

=head1 OTHER

=head2 qrlist

Input: An array of values to be used to test againts for existence.

Output: A reference to a regular expression. That is a C<qr//>

The regex sets $1 if it match.

Example:

  my @list=qw/ABc XY DEF DEFG XYZ/;
  my $filter=qrlist("ABC","DEF","XY.");         # makes a regex of it qr/^(\QABC\E|\QDEF\E|\QXY.\E)$/
  my @filtered= grep { $_ =~ $filter } @list;   # returns DEF and XYZ, but not XYZ

Note: Filtering with hash lookups are WAY faster.

Source:

 sub qrlist (@) { my $str=join"|",map quotemeta, @_; qr/^($str)$/ }

=cut

sub qrlist (@)
{
  my $str=join"|",map quotemeta,@_;
  return qr/^($str)$/;
}

=head2 ansicolor

Perhaps easier to use than L<Term::ANSIColor> ?

B<Input:> One argument. A string where the char C<�> have special
meaning and is replaced by color codings depending on the letter
following the C<�>.

B<Output:> The same string, but with C<�letter> replaced by ANSI color codes respected by many types terminal windows. (xterm, telnet, ssh,
telnet, rlog, vt100, cygwin, rxvt and such...).

B<Codes for ansicolor():>

 �r red
 �g green
 �b blue
 �y yellow
 �m magenta
 �B bold
 �u underline
 �c clear
 �� reset, quits and returns to default text color.

B<Example:>

 print ansicolor("This is maybe �ggreen��?");

Prints I<This is maybe green?> where the word I<green> is shown in green.

If L<Term::ANSIColor> is not installed or not found, returns the input
string with every C<�> including the following code letters
removed. (That is: ansicolor is safe to use even if Term::ANSIColor is
not installed, you just don't get the colors).

See also L<Term::ANSIColor>.

=cut

sub ansicolor
{
  my $txt=shift;
  eval{require Term::ANSIColor} or return replace($txt,qr/�./);
  my %h=qw/r red  g green  b blue  y yellow  m magenta  B bold  u underline  c clear  � reset/;
  my $re=join"|",keys%h;
  $txt=~s/�($re)/Term::ANSIColor::color($h{$1})/ge;
  return $txt;
}

=head2 ccn_ok

Checks if a Credit Card number (CCN) has correct control digits according to the LUHN-algorithm from 1960.
This method of control digits is used by MasterCard, Visa, American Express,
Discover, Diners Club / Carte Blanche, JCB and others.

B<Input:>

A credit card number. Can contain non-digits, but they are removed internally before checking.

B<Output:>

Something true or false.

Or more accurately:

Returns C<undef> (false) if the input argument is missing digits.

Returns 0 (zero, which is false) is the digits is not correct according to the LUHN algorithm.

Returns 1 or the name of a credit card company (true either way) if the last digit is an ok control digit for this ccn.

The name of the credit card company is returned like this (without the C<'> character)

 Returns (wo '')                Starts on                Number of digits
 ------------------------------ ------------------------ ----------------
 'MasterCard'                   51-55                    16
 'Visa'                         4                        13 eller 16
 'American Express'             34 eller 37              15
 'Discover'                     6011                     16
 'Diners Club / Carte Blanche'  300-305, 36 eller 38     14
 'JCB'                          3                        16
 'JCB'                          2131 eller 1800          15

And should perhaps have had:

 'enRoute'                      2014 eller 2149          15

...but that card uses either another control algorithm or no control
digits at all. So C<enRoute> is never returned here.

If the control digits is valid, but the input does not match anything in the column C<starts on>, 1 is returned.

(This is also the same control digit mechanism used in Norwegian KID numbers on payment bills)

The first digit in a credit card number is supposed to tell what "industry" the card is meant for:

 MII Digit Value             Issuer Category
 --------------------------- ----------------------------------------------------
 0                           ISO/TC 68 and other industry assignments
 1                           Airlines
 2                           Airlines and other industry assignments
 3                           Travel and entertainment
 4                           Banking and financial
 5                           Banking and financial
 6                           Merchandizing and banking
 7                           Petroleum
 8                           Telecommunications and other industry assignments
 9                           National assignment

...although this has no meaning to C<Acme::Tools::ccn_ok()>.

The first six digits is I<Issuer Identifier>, that is the bank
(probably). The rest in the "account number", except the last digits,
which is the control digit. Max length on credit card numbers are 19
digits.

=cut

sub ccn_ok
{
    my $ccn=shift(); #credit card number
    $ccn=~s/\D+//g;
    if(KID_ok($ccn)){
	return "MasterCard"                   if $ccn=~/^5[1-5]\d{14}$/;
	return "Visa"                         if $ccn=~/^4\d{12}(?:\d{3})?$/;
	return "American Express"             if $ccn=~/^3[47]\d{13}$/;
	return "Discover"                     if $ccn=~/^6011\d{12}$/;
	return "Diners Club / Carte Blanche"  if $ccn=~/^3(?:0[0-5]\d{11}|[68]\d{12})$/;
	return "JCB"                          if $ccn=~/^(?:3\d{15}|(?:2131|1800)\d{11})$/;
	return 1;
    }
    #return "enRoute"                        if $ccn=~/^(?:2014|2149)\d{11}$/; #ikke LUHN-krav?
    return 0;
}

=head2 KID_ok

Checks if a norwegian KID number has an ok control digit.

To check if a customer has typed the number correctly.

This uses the  LUHN algorithm (also known as mod-10) from 1960 which is also used
internationally in control digits for credit card numbers, and Canadian social security ID numbers as well.

The algorithm, as described in Phrack (47-8) (a long time hacker online publication):

 "For a card with an even number of digits, double every odd numbered
 digit and subtract 9 if the product is greater than 9. Add up all the
 even digits as well as the doubled-odd digits, and the result must be
 a multiple of 10 or it's not a valid card. If the card has an odd
 number of digits, perform the same addition doubling the even numbered
 digits instead."

B<Input:> A KID-nummer. Must consist of digits 0-9 only, otherwise a die (croak) happens.

B<Output:>

- Returns undef if the input argument is missing.

- Returns 0 if the control digit (the last digit) does not satify the LUHN/mod-10 algorithm.

- Returns 1 if ok

B<See also:> L</ccn_ok>

=cut

sub KID_ok
{
  croak "Non-numeric argument" if $_[0]=~/\D/;
  my @k=split//,shift or return undef;
  my $s;$s+=pop(@k)+[qw/0 2 4 6 8 1 3 5 7 9/]->[pop@k] while @k;
  $s%10==0?1:0;
}


=head2 writefile

Justification:

Perl needs three or four operations to make a file out of a string:

 open my $FILE, '>', $filename  or die $!;
 print $FILE $text;
 close($FILE);

This is way simpler:

 writefile($filename,$text);

Sub writefile opens the file i binary mode (C<binmode()>) and has two usage modes:

B<Input:> Two arguments

B<First argument> is the filename. If the file exists, its overwritten.
If the file can not be opened for writing, a die (a croak really) happens.

B<Second input argument> is one of:

=over 4

=item * Either a scaler. That is a normal string to be written to the file.

=item * Or a reference to a scalar. That referred text is written to the file.

=item * Or a reference to an array of scalars. This array is the written to the
 file element by element and C<< \n >> is automatically appended to each element.

=back

Alternativelly, you can write several files at once.

Example, this:

 writefile('file1.txt','The text....tjo');
 writefile('file2.txt','The text....hip');
 writefile('file3.txt','The text....and hop');

...is the same as this:

 writefile([
   ['file1.txt','The text....tjo'],
   ['file2.txt','The text....hip'],
   ['file3.txt','The text....and hop'],
 ]);

B<Output:> Nothing (for the time being). C<die()>s (C<croak($!)> really) if something goes wrong.

=cut

sub writefile
{
    my($filename,$text)=@_;
    if(ref($filename) eq 'ARRAY'){
	writefile(@$_) for @$filename;
	return;
    }
    open(WRITEFILE,">",$filename) and binmode(WRITEFILE) or croak($!);
    if(not defined $text or not ref($text)){
	print WRITEFILE $text;
    }
    elsif(ref($text) eq 'SCALAR'){
	print WRITEFILE $$text;
    }
    elsif(ref($text) eq 'ARRAY'){
	print WRITEFILE "$_\n" for @$text;
    }
    else {
	croak;
    }
    close(WRITEFILE);
    return;
}

=head2 readfile

Just as with L</writefile> you can read in a whole file in one operation with C<readfile()>. Instead of:

 open my $FILE,'<', $filename or die $!;
 my $data = join"",<$FILE>;
 close($FILE);

This is simpler:

 my $data = readfile($filename);

B<More examples:>

Reading the content of the file to a scalar variable: (Any content in C<$data> will be overwritten)

 my $data;
 readfile('filename.txt',\$data);

Reading the lines of a file into an array:

 my @lines;
 readfile('filnavn.txt',\@lines);
 for(@lines){
   ...
 }

Note: Chomp is done on each line. That is, any newlines (C<< \n >>) will be removed.
If C<@lines> is non-empty, this will be lost.

Sub readfile is context aware. If an array is expected it returns an array of the lines without a trailing C<< \n >>.
The last example can be rewritten:

 for(readfile('filnavn.txt')){
   ...
 }

With two input arguments, nothing (undef) is returned from C<readfile()>.

=cut

sub readfile
{
  my($filename,$ref)=@_;
  if(not defined $ref){  #-- one argument
      if(wantarray){
	  my @data;
	  readfile($filename,\@data);
	  return @data;
      }
      else {
	  my $data;
	  readfile($filename,\$data);
	  return $data;
      }
  }
  else {                 #-- two arguments
      open(READFILE,'<',$filename) or croak($!);
      if(ref($ref) eq 'SCALAR'){
	  $$ref=join"",<READFILE>;
      }
      elsif(ref($ref) eq 'ARRAY'){
	  while(my $l=<READFILE>){
	      chomp($l);
	      push @$ref, $l;
	  }
      }
      else {
	  croak;
      }
      close(READFILE);
      return;
  }
}

=head2 readdirectory

B<Input:>

Name of a directory.

B<Output:>

A list of all files in it, except of  C<.> and C<..>  (on linux/unix systems, all directories have a C<.> and C<..> directory).

The names of all types of files are returned: normal files, directories, symbolic links,
pipes, semaphores. That is every thing shown by C<ls -la> except C<.> and C<..>

C<readdirectory> do not recurce down into subdirectories (but see example below).

B<Example:>

  my @files = readdirectory("/tmp");

B<Why readdirectory?>

Sometimes calling the built ins C<opendir>, C<readdir> and C<closedir> seems a tad tedious, since this:

 my $dir="/usr/bin";
 opendir(D,$dir);
 my @files=map "$dir/$_", grep {!/^\.\.?$/} readdir(D);
 closedir(D);

Is the same as this:

 my @files=readdirectory("/usr/bin");

See also: L<File::Find>

B<Why not readdirectory?>

On huge directories with perhaps tens or houndreds of thousands of
files, readdirectory() will consume more memory than perls
opendir/readdir. This isn't usually a concern anymore for modern
computers with gigabytes of RAM, but might be the rationale behind
Perls more tedious way created in the 80s.  The same argument goes for
file slurping. On the other side it's also a good practice to never
assume to much on available memory and the number of files if you
don't know for certain that enough memory is available whereever your
code is run or that the size of the directory is limited.

B<Example:>

How to get all files in the C</tmp> directory including all subdirectories below of any depth:

 my @files=("/tmp");
 map {-d $_ and unshift @files,$_ or push @files,$_} readdirectory(shift(@files)) while -d $files[0];

...or to avoid symlinks and only get real files:

 map {-d and !-l and unshift @files,$_ or -f and !-l and push @files,$_} readdirectory(shift(@files)) while -d $files[0];

=cut

sub readdirectory
{
  my $dir=shift;
  opendir(my $D,$dir);
  my @filer=map "$dir/$_", grep {!/^\.\.?$/} readdir($D);
  closedir($D);
  return @filer;
}

=head2 range

B<Input:>

One, two or tre numeric arguments: C<x> og C<y> and C<jump>.

B<Output:>

If one argument: returns the array C<(0..x-1)>

If two arguments: returns the array C<(x..y-1)>

If three arguments: returns every I<jump>th number between C<x> and C<y>.

Dies (croaks) if there are zero or more than 3 arguments, or if the third argument is zero.

B<Examples:>

 print join ",", range(11);      # prints 0,1,2,3,4,5,6,7,8,9,10      (but not 11)
 print join ",", range(2,11);    # prints 2,3,4,5,6,7,8,9,10          (but not 11)
 print join ",", range(11,2,-1); # prints 11,10,9,8,7,6,5,4,3
 print join ",", range(2,11,3);  # prints 2,5,8
 print join ",", range(11,2,-3); # prints 11,8,5
 print join ",", range(11,2,+3); # prints nothing

In the Python language, C<range> is a build in and an iterator instead of an array. This saves memory for large sets.

=cut

sub range
{
  my($x,$y,$jump)=@_;
  return (  0 .. $x-1 ) if @_==1;
  return ( $x .. $y-1 ) if @_==2;
  croak "Wrong number of arguments or jump==0" if @_!=3 or $jump==0;
  my @r;
  if($jump>0){  while($x<$y){ push @r, $x; $x+=$jump } }
  else       {  while($x>$y){ push @r, $x; $x+=$jump } }
  return @r;
}

=head2 permutations

What is permutations?

Six friends will be eating at a table with six chairs.

How many ways (permutations) can those six be placed when the number of chairs equal the number of people?

 If one person:          one
 If two persons:         two     (they can swap places)
 If three persons:       six
 If four persons:         24
 If five persons:        120
 If six  persons:        720

The formula is C<x!> where the postfix unary operator C<!>, also known as I<faculty> is defined like:
C<x! = x * (x-1) * (x-2) ... * 1>. Example: C<5! = 5 * 4 * 3 * 2 * 1 = 120>.

Run this to see the 100 first C<< n! >>

 perl -le 'use Math::BigInt lib=>'GMP';$i=Math::BigInt->new(1);print "$_! = ",$i*=$_ for 1..100'

  1!  = 1
  2!  = 2
  3!  = 6
  4!  = 24
  5!  = 120
  6!  = 720
  7!  = 5040
  8!  = 40320
  9!  = 362880
 10!  = 3628800
 .
 .
 .
 100! = 93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000

C<permutations()> takes a list and return a list of arrayrefs for each
of the permutations of the input list:

 permutations('a','b');     #returns (['a','b'],['b','a'])

 permutations('a','b','c'); #returns (['a','b','c'],['a','c','b'],
                            #         ['b','a','c'],['b','c','a'],
                            #         ['c','a','b'],['c','b','a'])

Up to five input arguments C<permutations()> is probably as fast as it
can be in this pure perl implementation (see source). For more than
five, it could be faster. How fast is it now: Running with different
n, this many time took that many seconds:

 n   times    seconds
 -- ------- ---------
  2  100000      0.32
  3  10000       0.09
  4  10000       0.33
  5  1000        0.18
  6  100         0.27
  7  10          0.21
  8  1           0.17
  9  1           1.63
 10  1          17.00

If the first argument is a coderef, that sub will be called for each permutation and the return from those calls with be the real return from C<permutations()>. For example this:

 print for permutations(sub{join"",@_},1..3);

...will print the same as:

 print for map join("",@$_), permutations(1..3);

...but the first of those two uses less RAM if 3 has been say 9.
Changing 3 with 10, and many computers hasn't enough memory 
for the latter.

The examples prints:

 123
 132
 213
 231
 312
 321

If you just want to say calculate something on each permutation,
but is not interested in the list of them, you just don't
take the return. That is:

 my $ant;
 permutations(sub{$ant++ if $_[-1]>=$_[0]*2},1..9);

...is the same as:

 $$_[-1]>=$$_[0]*2 and $ant++ for permutations(1..9);

...but the first uses next to nothing of memory compared to the latter. They have about the same speed.
(The examples just counts the permutations where the last number is at least twice as large as the first)

C<permutations()> was created to find all combinations of a persons
name. This is useful in "fuzzy" name searches with
L<String::Similarity> if you can not be certain what is first, middle
and last names. In foreign or unfamiliar names it can be difficult to
know that.

=cut

sub permutations
{
  my $code=ref($_[0]) eq 'CODE' ? shift() : undef;
  $code and @_<6 and return map &$code(@$_),permutations(@_);

  return [@_] if @_<2;

  return ([@_[0,1]],[@_[1,0]]) if @_==2;

  return ([@_[0,1,2]],[@_[0,2,1]],[@_[1,0,2]],
	  [@_[1,2,0]],[@_[2,0,1]],[@_[2,1,0]]) if @_==3;

  return ([@_[0,1,2,3]],[@_[0,1,3,2]],[@_[0,2,1,3]],[@_[0,2,3,1]],
	  [@_[0,3,1,2]],[@_[0,3,2,1]],[@_[1,0,2,3]],[@_[1,0,3,2]],
	  [@_[1,2,0,3]],[@_[1,2,3,0]],[@_[1,3,0,2]],[@_[1,3,2,0]],
	  [@_[2,0,1,3]],[@_[2,0,3,1]],[@_[2,1,0,3]],[@_[2,1,3,0]],
	  [@_[2,3,0,1]],[@_[2,3,1,0]],[@_[3,0,1,2]],[@_[3,0,2,1]],
	  [@_[3,1,0,2]],[@_[3,1,2,0]],[@_[3,2,0,1]],[@_[3,2,1,0]]) if @_==4;

  return ([@_[0,1,2,3,4]],[@_[0,1,2,4,3]],[@_[0,1,3,2,4]],[@_[0,1,3,4,2]],[@_[0,1,4,2,3]],
	  [@_[0,1,4,3,2]],[@_[0,2,1,3,4]],[@_[0,2,1,4,3]],[@_[0,2,3,1,4]],[@_[0,2,3,4,1]],
	  [@_[0,2,4,1,3]],[@_[0,2,4,3,1]],[@_[0,3,1,2,4]],[@_[0,3,1,4,2]],[@_[0,3,2,1,4]],
	  [@_[0,3,2,4,1]],[@_[0,3,4,1,2]],[@_[0,3,4,2,1]],[@_[0,4,1,2,3]],[@_[0,4,1,3,2]],
	  [@_[0,4,2,1,3]],[@_[0,4,2,3,1]],[@_[0,4,3,1,2]],[@_[0,4,3,2,1]],[@_[1,0,2,3,4]],
	  [@_[1,0,2,4,3]],[@_[1,0,3,2,4]],[@_[1,0,3,4,2]],[@_[1,0,4,2,3]],[@_[1,0,4,3,2]],
	  [@_[1,2,0,3,4]],[@_[1,2,0,4,3]],[@_[1,2,3,0,4]],[@_[1,2,3,4,0]],[@_[1,2,4,0,3]],
	  [@_[1,2,4,3,0]],[@_[1,3,0,2,4]],[@_[1,3,0,4,2]],[@_[1,3,2,0,4]],[@_[1,3,2,4,0]],
	  [@_[1,3,4,0,2]],[@_[1,3,4,2,0]],[@_[1,4,0,2,3]],[@_[1,4,0,3,2]],[@_[1,4,2,0,3]],
	  [@_[1,4,2,3,0]],[@_[1,4,3,0,2]],[@_[1,4,3,2,0]],[@_[2,0,1,3,4]],[@_[2,0,1,4,3]],
	  [@_[2,0,3,1,4]],[@_[2,0,3,4,1]],[@_[2,0,4,1,3]],[@_[2,0,4,3,1]],[@_[2,1,0,3,4]],
	  [@_[2,1,0,4,3]],[@_[2,1,3,0,4]],[@_[2,1,3,4,0]],[@_[2,1,4,0,3]],[@_[2,1,4,3,0]],
	  [@_[2,3,0,1,4]],[@_[2,3,0,4,1]],[@_[2,3,1,0,4]],[@_[2,3,1,4,0]],[@_[2,3,4,0,1]],
	  [@_[2,3,4,1,0]],[@_[2,4,0,1,3]],[@_[2,4,0,3,1]],[@_[2,4,1,0,3]],[@_[2,4,1,3,0]],
	  [@_[2,4,3,0,1]],[@_[2,4,3,1,0]],[@_[3,0,1,2,4]],[@_[3,0,1,4,2]],[@_[3,0,2,1,4]],
	  [@_[3,0,2,4,1]],[@_[3,0,4,1,2]],[@_[3,0,4,2,1]],[@_[3,1,0,2,4]],[@_[3,1,0,4,2]],
	  [@_[3,1,2,0,4]],[@_[3,1,2,4,0]],[@_[3,1,4,0,2]],[@_[3,1,4,2,0]],[@_[3,2,0,1,4]],
	  [@_[3,2,0,4,1]],[@_[3,2,1,0,4]],[@_[3,2,1,4,0]],[@_[3,2,4,0,1]],[@_[3,2,4,1,0]],
	  [@_[3,4,0,1,2]],[@_[3,4,0,2,1]],[@_[3,4,1,0,2]],[@_[3,4,1,2,0]],[@_[3,4,2,0,1]],
	  [@_[3,4,2,1,0]],[@_[4,0,1,2,3]],[@_[4,0,1,3,2]],[@_[4,0,2,1,3]],[@_[4,0,2,3,1]],
	  [@_[4,0,3,1,2]],[@_[4,0,3,2,1]],[@_[4,1,0,2,3]],[@_[4,1,0,3,2]],[@_[4,1,2,0,3]],
	  [@_[4,1,2,3,0]],[@_[4,1,3,0,2]],[@_[4,1,3,2,0]],[@_[4,2,0,1,3]],[@_[4,2,0,3,1]],
	  [@_[4,2,1,0,3]],[@_[4,2,1,3,0]],[@_[4,2,3,0,1]],[@_[4,2,3,1,0]],[@_[4,3,0,1,2]],
	  [@_[4,3,0,2,1]],[@_[4,3,1,0,2]],[@_[4,3,1,2,0]],[@_[4,3,2,0,1]],[@_[4,3,2,1,0]]) if @_==5;

  my(@r,@p,@c,@i,@n); @i=(0,@_); @p=@c=1..@_; @n=1..@_-1;
  PERM:
  while(1){
    if($code){if(defined wantarray){push(@r,&$code(@i[@p]))}else{&$code(@i[@p])}}else{push@r,[@i[@p]]}
    for my$i(@n){splice@p,$i,0,shift@p;next PERM if --$c[$i];$c[$i]=$i+1}
    return@r
  }
}

=head2 trigram

B<Input:> A string (i.e. a name). And an optional x (see example 2)

B<Output:> A list of this strings trigrams (See examlpe)

B<Example 1:>

 print join ", ", trigram("Kjetil Skotheim");

Prints:

 Kje, jet, eti, til, il , l S,  Sk, Sko, kot, oth, the, hei, eim

B<Example 2:>

Default is 3, but here 4 is used instead in the second optional input argument:

 print join ", ", trigram("Kjetil Skotheim", 4);

And this prints:

 Kjet, jeti, etil, til , il S, l Sk,  Sko, Skot, koth, othe, thei, heim

C<trigram()> was created for "fuzzy" name searching. If you have a database of many names,
addresses, phone numbers, customer numbers etc. You can use trigram() to search
among all of those at the same time. If the search form only has one input field.
One general search box.

Store all of the trigrams of the trigram-indexed input fields coupled
with each person, and when you search, you take each trigram of you
query string and adds the list of people that has that trigram. The
search result should then be sorted so that the persons with most hits
are listed first. Both the query strings and the indexed database
fields should have a space added first and last before C<trigram()>-ing
them.

This search algorithm is not includes here yet...

C<trigram()> should perhaps have been named ngram for obvious reasons.

=cut

sub trigram
{
  my($s,$x)=@_;
  $x||=3;
  return $s if length($s)<=$x;
  return map substr($s,$_,$x), 0..length($s)-$x;
}

=head2 cart

Cartesian product

B<Easy usage:>

Input: two or more arrayrefs with accordingly x, y, z and so on number of elements.

Output: An array of x * y * z number of arrayrefs. The arrays being the cartesian product of the input arrays.

It can be useful to think of this as joins in SQL. In C<select> statements
with more tables behind C<from>, but without any C<where> condition to join
the tables.

B<Advanced usage, with condition(s):>

B<Input:>

- Either two or more arrayrefs with x, y, z and so on number of
elements.

- Or coderefs to subs containing condition checks. Somewhat like
C<where> conditions in SQL.

B<Output:> An array of x * y * z number of arrayrefs (the cartesian product)
minus the ones that did not fulfill the condition(s).

This of is as joins with one or more where conditions as coderefs.

The coderef input arguments can be placed last or among the array refs
to save both runtime and memory if the conditions depend on
arrays further back.

B<Examples, this:>

 for(cart(\@a1,\@a2,\@a3)){
   my($a1,$a2,$a3) = @$_;
   print "$a1,$a2,$a3\n";
 }

Prints the same as this:

 for my $a1 (@a1){
   for my $a2 (@a2){
     for my $a3 (@a3){
       print "$a1,$a2,$a3\n";
     }
   }
 }

B<And this:> (with a condition: the sum of the first two should be dividable with 3)

 for( cart( \@a1, \@a2, sub{sum(@$_)%3==0}, \@a3 ) ) {
   my($a1,$a2,$a3)=@$_;
   print "$a1,$a2,$a3\n";
 }

Prints the same as this:

 for my $a1 (@a1){
   for my $a2 (@a2){
     next if 0==($a1+$a2)%3;
     for my $a3 (@a3){
       print "$a1,$a2,$a3\n";
     }
   }
 }

Examples, from the tests:

 my @a1 = (1,2);
 my @a2 = (10,20,30);
 my @a3 = (100,200,300,400);

 my $s = join"", map "*".join(",",@$_), cart(\@a1,\@a2,\@a3);
 ok( $s eq  "*1,10,100*1,10,200*1,10,300*1,10,400*1,20,100*1,20,200"
           ."*1,20,300*1,20,400*1,30,100*1,30,200*1,30,300*1,30,400"
           ."*2,10,100*2,10,200*2,10,300*2,10,400*2,20,100*2,20,200"
           ."*2,20,300*2,20,400*2,30,100*2,30,200*2,30,300*2,30,400");

 $s=join"",map "*".join(",",@$_), cart(\@a1,\@a2,\@a3,sub{sum(@$_)%3==0});
 ok( $s eq "*1,10,100*1,10,400*1,20,300*1,30,200*2,10,300*2,20,200*2,30,100*2,30,400");

Hash-mode returns hashrefs instead of arrayrefs:

 @cards=cart(             #100 decks of 52 cards
   deck  => [1..100],
   value => [qw/2 3 4 5 6 7 8 9 10 J Q K A/],
   col   => [qw/heart diamond club star/],
 );
 for my $card ( mix(@cards) ) {
   print "From deck number $$card{deck} we got $$card{value} $$card{col}\n";
 }

=cut

sub cart
{
  my @ars=@_;
  if(!ref($_[0])){ #if hash-mode detected
    my(@k,@v); push@k,shift@ars and push@v,shift@ars while @ars;
    return map{my%h;@h{@k}=@$_;\%h}cart(@v);
  }
  my @res=map[$_],@{shift@ars};
  for my $ar (@ars){
    @res=grep{&$ar(@$_)}@res and next if ref($ar) eq 'CODE';
    @res=map{my$r=$_;map{[@$r,$_]}@$ar}@res;
  }
  return @res;
}


=head2 reduce

From: Why Functional Programming Matters: L<http://www.md.chalmers.se/~rjmh/Papers/whyfp.pdf>

L<http://www.md.chalmers.se/~rjmh/Papers/whyfp.html>

DON'T TRY THIS AT HOME, C PROGRAMMERS.

 sub reduce (&@) {
   my ($proc, $first, @rest) = @_;
   return $first if @rest == 0;
   local ($a, $b) = ($first, reduce($proc, @rest));
   return $proc->();
 }

Many functions can then be implemented with very little code. Such as:

 sub mean { (reduce {$a + $b} @_) / @_ }

=cut

sub reduce (&@) {
  my ($proc, $first, @rest) = @_;
  return $first if @rest == 0;
  no warnings;
  local ($a, $b) = ($first, reduce($proc, @rest));
  return $proc->();
}

=head2 int2roman

Converts integers to roman numbers.

B<Examples:>

 print int2roman(1234);   # prints MCCXXXIV
 print int2roman(1971);   # prints MCMLXXI

Works for numbers up to 3999.

Subroutine from Peter J. Acklam (jacklam(&)math.uio.no)
at Mathematical institutt at University of Oslo:

 I = 1
 V = 5
 X = 10
 L = 50
 C = 100     (centum)
 D = 500
 M = 1000    (mille)

See also L<Roman>.

See L<http://en.wikipedia.org/wiki/Roman_numbers> for more.

=cut

sub int2roman{my@x=split//,sprintf'%04d',shift;my@r=('','I','V','X','L','C','D'
,'M');my@p=([],[1],[1,1],[1,1,1],[1,2],[2],[2,1],[2,1,1],[2,1,1,1],[1,3],[3])
;join'',@r[map($_+6,@{$p[$x[0]]}),map($_+4,@{$p[$x[1]]}),map($_+2,@{$p[$x[2
]]}),map($_+0,@{$p[$x[3]]})];}#print "@{[map{int2roman($_)}@ARGV]}\n";#JAPH!


=head2 num2code

See L</code2num>

=head2 code2num

C<num2code()> convert numbers (integers) from the normal decimal system to some arbitrary other number system.
That can be binary (2), oct (8), hex (16) or others.

Example:

 print num2code(255,2,"0123456789ABCDEF");  # prints FF
 print num2code(14,2,"0123456789ABCDEF");   # prints 0E

...because 255 are converted to hex (0-F) with a return of 2 digits: FF
...and 14 are converted to 0E, with leading 0 because of the second argument 2.

Example:

 print num2code(1234,16,"01")

Prints the 16 binary digits 0000010011010010 which is 1234 converted to binary 0s and 1s.

To convert back:

 print code2num("0000010011010010","01");  #prints 1234

C<num2code()> can be used to compress numeric IDs to something shorter:

 $chars='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_';
 $code=num2code("241274432",5,$chars);

=cut

sub num2code
{
  my($num,$sifre,$lovligetegn,$start)=@_;
  my $antlovligetegn=length($lovligetegn);
  my $key;
  no warnings;
  croak if $num<$start;
  $num-=$start;
  for(1..$sifre){
    $key=substr($lovligetegn,$num%$antlovligetegn,1).$key;
    $num=int($num/$antlovligetegn);
  }
  croak if $num>0;
  return $key;
}

sub code2num
{
  my($code,$lovligetegn,$start)=@_; $start=0 if not defined $start;
  my $antlovligetegn=length($lovligetegn);
  my $num=0;
  $num=$num*$antlovligetegn+index($lovligetegn,$_) for split//,$code;
  return $num+$start;
}


=head2 gcd

I< C<">The Euclidean algorithm (also called Euclid's algorithm) is an
algorithm to determine the greatest common divisor (gcd) of two
integers. It is one of the oldest algorithms known, since it appeared
in the classic Euclid's Elements around 300 BC. The algorithm does not
require factoring.C<"> >

B<Input:> two or more positive numbers (integers, without decimals that is)

B<Output:> an integer

B<Example:>

  print gcd(12, 8);   # prints 4

Because the (prime number) factors of  12  is  2 * 2 * 3 and the factors of 8 is 2 * 2 * 2
and the common ('overlapping') for both 12 and 8 is then 2 * 2, the result becomes 4.

B<Example two>:

  print gcd(90, 135, 315);               # prints 45
  print gcd(2*3*3*5, 3*3*3*5, 3*3*5*7);  # prints 45

...same tre numbers, 3*3*5 is common = 45.

 sub gcd { my($a,$b,@r)=@_; @r ? gcd($a,gcd($b,@r)) : $b==0 ? $a : gcd($b, $a % $b) }

L<http://en.wikipedia.org/wiki/Greatest_common_divisor>

L<http://en.wikipedia.org/wiki/Euclidean_algorithm>

=cut

sub gcd { my($a,$b,@r)=@_; @r ? gcd($a,gcd($b,@r)) : $b==0 ? $a : gcd($b, $a % $b) }

=head2 lcm

C<lcm()> finds the Least Common Multiple of two or more numbers (integers).

B<Input:> two or more positive numbers (integers)

B<Output:> an integer number

Example: C< 2/21 + 1/6 = 4/42 + 7/42 = 11/42>

Where 42 = lcm(21,6).

B<Example:>

  print lcm(45,120,75);   # prints 1800

Because the factors are:

  45 = 2^0 * 3^2 * 5^1
 120 = 2^3 * 3^1 * 5^1
  75 = 2^0 * 3^1 * 5^2

Take the bigest power of each primary number (2, 3 and 5 here).
Which is 2^3, 3^2 and 5^2. Multiplied this is 8 * 9 * 25 = 1800.

 sub lcm { my($a,$b,@r)=@_; @r ? lcm($a,lcm($b,@r)) : $a*$b/gcd($a,$b) }

Seems to works with L<Math::BigInt> as well: (C<lcm> of all integers from 1 to 200)

 perl -MAcme::Tools -MMath::BigInt -le'print lcm(map Math::BigInt->new($_),1..200)'

 337293588832926264639465766794841407432394382785157234228847021917234018060677390066992000

=cut

sub lcm { my($a,$b,@r)=@_; @r ? lcm($a,lcm($b,@r)) : $a*$b/gcd($a,$b) }

=head2 pivot

Resembles the pivot table function in Excel.

C<pivot()> is used to spread out a slim and long table to a visually improved layout.

For instance spreading out the results of C<group by>-selects from SQL:

 pivot( arrayref, columnname1, columnname2, ...)

 pivot( ref_to_array_of_arrayrefs, @list_of_names_to_down_fields )

The first argument is a ref to a two dimensional table.

The rest of the arguments is a list which also signals the number of
columns from left in each row that is ending up to the left of the
data table, the rest ends up at the top and the last element of
each row ends up as data.

                   top1 top1 top1 top1
 left1 left2 left3 top2 top2 top2 top2
 ----- ----- ----- ---- ---- ---- ----
                   data data data data
                   data data data data
                   data data data data

Example:

 my @table=(
               ["1997","Gerd", "Weight", "Summer",66],
               ["1997","Gerd", "Height", "Summer",170],
               ["1997","Per",  "Weight", "Summer",75],
               ["1997","Per",  "Height", "Summer",182],
               ["1997","Hilde","Weight", "Summer",62],
               ["1997","Hilde","Height", "Summer",168],
               ["1997","Tone", "Weight", "Summer",70],
 
               ["1997","Gerd", "Weight", "Winter",64],
               ["1997","Gerd", "Height", "Winter",158],
               ["1997","Per",  "Weight", "Winter",73],
               ["1997","Per",  "Height", "Winter",180],
               ["1997","Hilde","Weight", "Winter",61],
               ["1997","Hilde","Height", "Winter",164],
               ["1997","Tone", "Weight", "Winter",69],
 
               ["1998","Gerd", "Weight", "Summer",64],
               ["1998","Gerd", "Height", "Summer",171],
               ["1998","Per",  "Weight", "Summer",76],
               ["1998","Per",  "Height", "Summer",182],
               ["1998","Hilde","Weight", "Summer",62],
               ["1998","Hilde","Height", "Summer",168],
               ["1998","Tone", "Weight", "Summer",70],
 
               ["1998","Gerd", "Weight", "Winter",64],
               ["1998","Gerd", "Height", "Winter",171],
               ["1998","Per",  "Weight", "Winter",74],
               ["1998","Per",  "Height", "Winter",183],
               ["1998","Hilde","Weight", "Winter",62],
               ["1998","Hilde","Height", "Winter",168],
               ["1998","Tone", "Weight", "Winter",71],
             );

.

 my @reportA=pivot(\@table,"Year","Name");
 print "\n\nReport A\n\n".tablestring(\@reportA);

Will print:

 Report A
 
 Year Name  Height Height Weight Weight
            Summer Winter Summer Winter
 ---- ----- ------ ------ ------ ------
 1997 Gerd  170    158    66     64
 1997 Hilde 168    164    62     61
 1997 Per   182    180    75     73
 1997 Tone                70     69
 1998 Gerd  171    171    64     64
 1998 Hilde 168    168    62     62
 1998 Per   182    183    76     74
 1998 Tone                70     71

.

 my @reportB=pivot([map{$_=[@$_[0,3,2,1,4]]}(@t=@table)],"Year","Season");
 print "\n\nReport B\n\n".tablestring(\@reportB);

Will print:

 Report B
 
 Year Season Height Height Height Weight Weight Weight Weight
             Gerd   Hilde  Per    Gerd   Hilde  Per    Tone
 ---- ------ ------ ------ -----  -----  ------ ------ ------
 1997 Summer 170    168    182    66     62     75     70
 1997 Winter 158    164    180    64     61     73     69
 1998 Summer 171    168    182    64     62     76     70
 1998 Winter 171    168    183    64     62     74     71

.

 my @reportC=pivot([map{$_=[@$_[1,2,0,3,4]]}(@t=@table)],"Name","Attributt");
 print "\n\nReport C\n\n".tablestring(\@reportC);

Will print:

 Report C
 
 Name  Attributt 1997   1997   1998   1998
                 Summer Winter Summer Winter
 ----- --------- ------ ------ ------ ------
 Gerd  Height     170    158    171    171
 Gerd  Weight      66     64     64     64
 Hilde Height     168    164    168    168
 Hilde Weight      62     61     62     62
 Per   Height     182    180    182    183
 Per   Weight      75     73     76     74
 Tone  Weight      70     69     70     71

.

 my @reportD=pivot([map{$_=[@$_[1,2,0,3,4]]}(@t=@table)],"Name");
 print "\n\nReport D\n\n".tablestring(\@reportD);

Will print:

 Report D
 
 Name  Height Height Height Height Weight Weight Weight Weight
       1997   1997   1998   1998   1997   1997   1998   1998
       Summer Winter Summer Winter Summer Winter Summer Winter
 ----- ------ ------ ------ ------ ------ ------ ------ ------
 Gerd  170    158    171    171    66     64     64     64
 Hilde 168    164    168    168    62     61     62     62
 Per   182    180    182    183    75     73     76     74
 Tone                              70     69     70     71

Options:

Options to sort differently and show sums and percents are available. (...MORE DOC ON THAT LATER...)

See also L<Data::Pivot>

=cut

sub pivot
{
  my($tabref,@vertikalefelt)=@_;
  my %opt=ref($vertikalefelt[-1]) eq 'HASH' ? %{pop(@vertikalefelt)} : ();
  my $opt_sum=1 if $opt{sum};
  my $opt_pro=exists $opt{prosent}?$opt{prosent}||0:undef;
  my $sortsub          = $opt{'sortsub'}          || \&_sortsub;
  my $sortsub_bortover = $opt{'sortsub_bortover'} || $sortsub;
  my $sortsub_nedover  = $opt{'sortsub_nedover'}  || $sortsub;
  #print serialize(\%opt,'opt');
  #print serialize(\$opt_pro,'opt_pro');
  my $antned=0+@vertikalefelt;
  my $bakerst=-1+@{$$tabref[0]};
  my(%h,%feltfinnes,%sum);
  #print "Bakerst<$bakerst>\n";
  for(@$tabref){
    my $rad=join($;,@$_[0..($antned-1)]);
    my $felt=join($;,@$_[$antned..($bakerst-1)]);
    my $verdi=$$_[$bakerst];
    length($rad) or $rad=' ';
    length($felt) or $felt=' ';
    $h{$rad}{$felt}=$verdi;
    $h{$rad}{"%$felt"}=$verdi;
    if($opt_sum or defined $opt_pro){
      $h{$rad}{Sum}+=$verdi;
      $sum{$felt}+=$verdi;
      $sum{Sum}+=$verdi;
    }
    $feltfinnes{$felt}++;
    $feltfinnes{"%$felt"}++ if $opt_pro;
  }
  my @feltfinnes = sort $sortsub_bortover keys%feltfinnes;
  push @feltfinnes, "Sum" if $opt_sum;
  my @t=([@vertikalefelt,map{replace($_,$;,"\n")}@feltfinnes]);
  #print serialize(\@feltfinnes,'feltfinnes');
  #print serialize(\%h,'h');
  #print "H = ".join(", ",sort _sortsub keys%h)."\n";
  for my $rad (sort $sortsub_nedover keys(%h)){
    my @rad=(split($;,$rad),
	     map{
	       if(/^\%/ and defined $opt_pro){
		 my $sum=$h{$rad}{Sum};
		 my $verdi=$h{$rad}{$_};
		 if($sum!=0){
		   defined $verdi
                   ?sprintf("%*.*f",3+1+$opt_pro,$opt_pro,100*$verdi/$sum)
		   :$verdi;
		 }
		 else{
		   $verdi!=0?"div0":$verdi;
		 }
	       }
	       else{
		 $h{$rad}{$_};
	       }
	     }
	     @feltfinnes);
    push(@t,[@rad]);
  }
  push(@t,"-",["Sum",(map{""}(2..$antned)),map{print "<$_>\n";$sum{$_}}@feltfinnes]) if $opt_sum;
  return @t;
}

# default sortsub for pivot()

sub _sortsub {
  no warnings;
  #my $c=($a<=>$b)||($a cmp $b);
  #return $c if $c;
  #printf "%-30s %-30s  ",replace($a,$;,','),replace($b,$;,',');
  my @a=split $;,$a;
  my @b=split $;,$b;
  for(0..$#a){
    my $c=$a[$_]<=>$b[$_];
    return $c if $c and "$a[$_]$b[$_]"!~/[iI][nN][fF]|�/i; # inf(inity)
    $c=$a[$_]cmp$b[$_];
    return $c if $c;
  }
  return 0;
}

=head2 tablestring

B<Input:> a reference to an array of arrayrefs  -- a two dimensional table of strings and numbers

B<Output:> a string containing the textual table -- a string of two or more lines

The first arrayref in the list refers to a list of either column headings (scalar)
or ... (...more later...)

In this output table:

- the columns will not be wider than necessary by its widest value (any <html>-tags are removed in every internal width-calculation)

- multi-lined cell values are handled also

- and so are html-tags, if the output is to be used inside <pre>-tags on a web page.

- columns with just numeric values are right justified (header row excepted)

Example:

 print tablestring([
   [qw/AA BB CCCC/],
   [123,23,"d"],
   [12,23,34],
   [77,88,99],
   ["lin\nes",12,"asdff\nfdsa\naa"],[0,22,"adf"]
 ]);

Prints this string of 11 lines:

 AA  BB CCCC
 --- -- -----
 123 23 d
 12  23 34
 77   8 99
 
 lin 12 asdff
 es     fdsa
        aa
 
 10  22 adf

As you can see, rows containing multi-lined cells gets an empty line before and after the row to separate it more clearly.

=cut

sub tablestring
{
  my $tab=shift;
  my %o=$_[0] ? %{shift()} : ();
  my $fjern_tom=$o{fjern_tomme_kolonner};
  my $ikke_space=$o{ikke_space};
  my $nodup=$o{nodup}||0;
  my $ikke_hodestrek=$o{ikke_hodestrek};
  my $pagesize=exists $o{pagesize} ? $o{pagesize}-3 : 9999999;
  my $venstretvang=$o{venstre};
  my(@bredde,@venstre,@hoeyde,@ikketom,@nodup);
  my $hode=1;
  my $i=0;
  my $j;
  for(@$tab){
    $j=0;
    $hoeyde[$i]=0;
    my $nodup_rad=$nodup;
    if(ref($_) eq 'ARRAY'){
      for(@$_){
	my $celle=$_;
	$bredde[$j]||=0;
	if($nodup_rad and $i>0 and $$tab[$i][$j] eq $$tab[$i-1][$j] || ($nodup_rad=0)){
	  $celle=$nodup==1?"":$nodup;
	  $nodup[$i][$j]=1;
	}
	else{
	  my $hoeyde=0;
	  my $bredere;
	  no warnings;
	  $ikketom[$j]=1 if !$hode && length($celle)>0;
	  for(split("\n",$celle)){
	    $bredere=/<input.+type=text.+size=(\d+)/i?$1:0;
	    s/<[^>]+>//g;
	    $hoeyde++;
	    s/&gt;/>/g;
	    s/&lt;/</g;
	    $bredde[$j]=length($_)+1+$bredere if length($_)+1+$bredere>$bredde[$j];
	    $venstre[$j]=1 if $_ && !/^\s*[\-\+]?(\d+|\d*\.\d+)\s*\%?$/ && !$hode;
	  }
	  if( $hoeyde>1 && !$ikke_space){
	    $hoeyde++ unless $hode;
	    $hoeyde[$i-1]++ if $i>1 && $hoeyde[$i-1]==1;
	  }
	  $hoeyde[$i]=$hoeyde if $hoeyde>$hoeyde[$i];
	}
	$j++;
      }
    }
    else{
      $hoeyde[$i]=1;
      $ikke_hodestrek=1;
    }
    $hode=0;
    $i++;
  }
  $i=$#hoeyde;
  $j=$#bredde;
  if($i==0 or $venstretvang) { @venstre=map{1}(0..$j)                         }
  else { for(0..$j){ $venstre[$_]=1 if !$ikketom[$_] }  }
  my @tabut;
  my $rad_startlinje=0;
  my @overskrift;
  my $overskrift_forrige;
  for my $x (0..$i){
    if($$tab[$x] eq '-'){
      my @tegn=map {$$tab[$x-1][$_]=~/\S/?"-":" "} (0..$j);
      $tabut[$rad_startlinje]=join(" ",map {$tegn[$_] x ($bredde[$_]-1)} (0..$j));
    }
    else{
      for my $y (0..$j){
	next if $fjern_tom && !$ikketom[$y];
	no warnings;
	
	my @celle=
            !$overskrift_forrige&&$nodup&&$nodup[$x][$y]
	    ?($nodup>0?():((" " x (($bredde[$y]-length($nodup))/2)).$nodup))
            :split("\n",$$tab[$x][$y]);
	for(0..($hoeyde[$x]-1)){
	  my $linje=$rad_startlinje+$_;
	  my $txt=shift @celle || '';
	  $txt=sprintf("%*s",$bredde[$y]-1,$txt) if length($txt)>0 && !$venstre[$y] && ($x>0 || $ikke_hodestrek);
	  $tabut[$linje].=$txt;
	  if($y==$j){
	    $tabut[$linje]=~s/\s+$//;
	  }
	  else{
	    my $bredere;
	       $bredere = $txt=~/<input.+type=text.+size=(\d+)/i?1+$1:0;
	    $txt=~s/<[^>]+>//g;
	    $txt=~s/&gt;/>/g;
	    $txt=~s/&lt;/</g;
	    $tabut[$linje].= ' ' x ($bredde[$y]-length($txt)-$bredere);
	  }
	}
      }
    }
    $rad_startlinje+=$hoeyde[$x];

    #--lage streker?
    if(not $ikke_hodestrek){
      if($x==0){
	for my $y (0..$j){
	  next if $fjern_tom && !$ikketom[$y];
	  $tabut[$rad_startlinje].=('-' x ($bredde[$y]-1))." ";
	}
	$rad_startlinje++;
	@overskrift=("",@tabut);
      }
      elsif(
	    $x%$pagesize==0 || $nodup>0&&!$nodup[$x+1][$nodup-1]
	    and $x+1<@$tab
	    and !$ikke_hodestrek
	    )
      {
	push(@tabut,@overskrift);
	$rad_startlinje+=@overskrift;
	$overskrift_forrige=1;
      }
      else{
	$overskrift_forrige=0;
      }
    }
  }#for x 
  return join("\n",@tabut)."\n";
}

=head2 upper

Returns input string as uppercase.

Used if perls build in C<uc()> for some reason does not convert ��� and other letters outsize a-z.

C<< ���������������������������� => ��������?������������������� >>

See also C<< perldoc -f uc >>

=head2 lower

Returns input string as lowercase.

Used if perls build in C<lc()> for some reason does not convert ��� and other letters outsize A-Z.

C<< ��������?������������������� => ��������?������������������� >>

See also C<< perldoc -f lc >>

=cut

#sub upper {my $str=shift;$str=~tr/a-z����������������������������/A-Z����������������������������/;$str}
#sub lower {my $str=shift;$str=~tr/A-Z����������������������������/a-z����������������������������/;$str}

sub upper {no warnings;my $str=@_?shift:$_;$str=~tr/a-z����������������������������/A-Z����������������������������/;$str}
sub lower {no warnings;my $str=@_?shift:$_;$str=~tr/A-Z����������������������������/a-z����������������������������/;$str}


=head2 serialize

Returns a data structure as a string. See also C<Data::Dumper>
(serialize was created long time ago before Data::Dumper appeared on
CPAN, before CPAN even...)

B<Input:> One to four arguments.

First argument: A reference to the structure you want.

Second argument: (optional) The name the structure will get in the output string.
If second argument is missing or is undef or '', it will get no name in the output.

Third argument: (optional) The string that is returned is also put
into a created file with the name given in this argument.  Putting a
C<< > >> char in from of the filename will append that file
instead. Use C<''> or C<undef> to not write to a file if you want to
use a fourth argument.

Fourth argument: (optional) A number signalling the depth on which newlines is used in the output.
The default is infinite (some big number) so no extra newlines are output.

B<Output:> A string containing the perl-code definition that makes that data structure.
The input reference (first input argument) can be to an array, hash or a string.
Those can contain other refs and strings in a deep data structure.

Limitations:

- Code refs are not handled (just returns C<sub{die()}>)

- Regex, class refs and circular recursive structures are also not handled.

B<Examples:>

  $a = 'test';
  @b = (1,2,3);
  %c = (1=>2, 2=>3, 3=>5, 4=>7, 5=>11);
  %d = (1=>2, 2=>3, 3=>\5, 4=>7, 5=>11, 6=>[13,17,19,{1,2,3,'asdf\'\\\''}],7=>'x');
  print serialize(\$a,'a');
  print serialize(\@b,'tab');
  print serialize(\%c,'c');
  print serialize(\%d,'d');
  print serialize(\("test'n roll",'brb "brb"'));
  print serialize(\%d,'d',undef,1);

Prints accordingly:

 $a='test';
 @tab=('1','2','3');
 %c=('1','2','2','3','3','5','4','7','5','11');
 %d=('1'=>'2','2'=>'3','3'=>\'5','4'=>'7','5'=>'11','6'=>['13','17','19',{'1'=>'2','3'=>'asdf\'\\\''}]);
 ('test\'n roll','brb "brb"');
 %d=('1'=>'2',
 '2'=>'3',
 '3'=>\'5',
 '4'=>'7',
 '5'=>'11',
 '6'=>['13','17','19',{'1'=>'2','3'=>'asdf\'\\\''}],
 '7'=>'x');

Areas of use:

- Debugging (first and foremost)

- Storing arrays and hashes and data structures of those on file, database or sending them over the net

- eval earlier stored string to get back the data structure

Be aware of the security implications of C<eval>ing a perl code string
stored somewhere that unauthorized users can change them! You are
probably better of using L<YAML::Syck> or L<Storable> without
enabling the CODE-options if you have such security issues.
More on decompiling Perl-code: L<Storable> or L<B::Deparse>.

=head2 dserialize

Debug-serialize, dumping data structures for you to look at.

Same as C<serialize()> but the output is given a newline every 80th character.
(Every 80th or whatever C<$Acme::Tools::Dserialize_width> contains)

=cut

our $Dserialize_width=80;
sub dserialize{join "\n",serialize(@_)=~/(.{1,$Dserialize_width})/gs}
sub serialize
{
  no warnings;
  my($r,$navn,$filnavn,$nivaa)=@_;
  my @r=(undef,undef,($nivaa||0)-1);
  if($filnavn){
    open(FIL,">$filnavn")||croak("FEIL: could not open file $filnavn\n".kallstack());
    my $ret=serialize($r,$navn,undef,$nivaa);
    print FIL "$ret\n1;\n";
    close FIL;
    return $ret;
  }

  if(ref($r) eq 'SCALAR'){
    return "\$$navn=".serialize($r,@r).";\n" if $navn;
    return "undef" unless defined $$r;
    my $ret=$$r;
    $ret=~s/\\/\\\\/g;
    $ret=~s/\'/\\'/g;
    return "'$ret'";
  }
  elsif(ref($r) eq 'ARRAY'){
    return "\@$navn=".serialize($r,@r).";\n" if $navn;
    my $ret="(";
    for(@$r){
      $ret.=serialize(\$_,@r).",";
      $ret.="\n" if $nivaa>=0;
    }
    $ret=~s/,$//;
    $ret.=")";
    $ret.=";\n" if $navn;
    return $ret;
  }
  elsif(ref($r) eq 'HASH'){
    return "\%$navn=".serialize($r,@r).";\n" if $navn;
    my $ret="(";
    for(sort keys %$r){
      $ret.=serialize(\$_,@r)."=>".serialize(\$$r{$_},@r).",";
      $ret.="\n" if $nivaa>=0;
    }
    $ret=~s/,$//;
    $ret.=")";
    $ret.=";\n" if $navn;
    return $ret;
  }
  elsif(ref($$r) eq 'ARRAY'){
#    my $ret=serialize($$r,@r);
#    substr($ret,0,1)="[";
#    substr($ret,-1)="]\n";
#    return $ret;
    return "\@$navn=".serialize($r,@r).";\n" if $navn;
    my $ret="[";
    for(@$$r){
      $ret.=serialize(\$_,@r).",";
      $ret.="\n" if not defined $nivaa or $nivaa>=0;
    }
    $ret=~s/,$//;
    $ret.="]";
    $ret.=";\n" if $navn;
    return $ret;

  }
  elsif(ref($$r) eq 'HASH'){
#    my $ret=serialize($$r,@r);
#    substr($ret,0,1)="{";
#    substr($ret,-1,1)="}\n";
#    return $ret;
    return "\%$navn=".serialize($r,@r).";\n" if $navn;
    my $ret="{";
    for(sort keys %$$r){
      $ret.=serialize(\$_,@r)."=>".serialize(\$$$r{$_},@r).",";
      $ret.="\n" if $nivaa>=0;
    }
    $ret=~s/,$//;
    $ret.="}";
    $ret.=";\n" if $navn;
    return $ret;
  }
  elsif(ref($$r) eq 'SCALAR'){
    return "\\".serialize($$r,@r);
  }
  elsif(ref($r) eq 'LVALUE'){
    return serialize(\"$$r",@r);
  }
  elsif(ref($$r) eq 'CODE'){
    #warn "Fors�k p� � serialisere (serialize) CODE";
    return 'sub{croak "Can not serialize CODE-references, see perhaps B::Deparse and Storable"}'
  }
  elsif(ref($$r) eq 'GLOB'){
    warn "Fors�k p� � serialisere (serialize) en GLOB";
    return '\*STDERR'
  }
  else{
    my $tilbake;
    my($pakke,$fil,$linje,$sub,$hasargs,$wantarray);
      ($pakke,$fil,$linje,$sub,$hasargs,$wantarray)=caller($tilbake++) until $sub ne 'serialize' || $tilbake>20;
    croak("serialize() argument should be reference!\n".
        "\$r=$r\n".
        "ref(\$r)   = ".ref($r)."\n".
        "ref(\$\$r) = ".ref($$r)."\n".
        "kallstack:\n".kallstack());
  }
}

#todo: sub unbless eller sub damn
#todo: ..se ogs�: use Data::Structure::Util qw/unbless/;
#todo: ...og: Acme::Damn sin damn()
#todo? sub swap($$) http://www.idg.no/computerworld/article242008.ece


=head1 TIME FUNCTIONS


# =head2 timestr
# 
# Converts epoch or YYYYMMDD-HH24:MI:SS time string to other forms of time.
# 
# B<Input:> One, two or three arguments.
# 
# B<First argument:> A format string.
# 
# B<Second argument: (optional)> An epock C<time()> number or a time
# string of the form YYYYMMDD-HH24:MI:SS. I no second argument is gives,
# picks the current C<time()>.
# 
# B<Thirs argument: (optional> True eller false. If true and first argument is eight digits:
# Its interpreted as a YYYYMMDD time string, not an epoch time.
# If true and first argument is six digits its interpreted as a DDMMYY date.
# 
# B<Output:> a date or clock string on the wanted form.
# 
# B<Exsamples:>
# 
# Prints C<< 3. july 1997 >> if thats the dato today:
# 
#  perl -MAcme::Tools -le 'print timestr("D. month YYYY")'
# 
#  print timestr"HH24:MI");              # prints 23:55 if thats the time now
#  print timestr"HH24:MI",time());       # ...same,since time() is the default
#  print timestr"HH:MI",time()-5*60);    # prints 23:50 if that was the time 5 minutes ago
#  print timestr"HH:MI",time()-5*60*60); # print 18:55 if thats the time 5 hours ago
#  timestr"Day D. month YYYY HH:MI");    # Saturday  juli 2004 23:55       (stor L liten j)
#  timestr"dag D. M�ned ���� HH:MI");    # l�rdag 3. Juli 2004 23:55       (omvendt)
#  timestr"DG DD. MONTH YYYY HH24:MI");  # L�R 03. JULY 2004 23:55         (HH24 = HH, month=engelsk)
#  timestr"DD-MON-YYYY");                # 03-MAY-2004                     (mon engelsk)
#  timestr"DD-M�N-YYYY");                # 03-MAI-2004                     (m�n norsk)
# 
# B<Formatstrengen i argument to:>
# 
# Formatstrengen kan innholde en eller flere av f�lgende koder.
# 
# Formatstrengen kan inneholde tekst, som f.eks. C<< tid('Klokken er: HH:MI') >>.
# Teksten her vil ikke bli konvertert. Men det anbefales � holde tekst utenfor
# formatstrengen, siden framtidige koder kan erstatte noen tegn i teksten med tall.
# 
# Der det ikke st�r annet: bruk store bokstaver.
# 
#  YYYY    �rstallet med fire sifre
#  ����    Samme som YYYY (norsk)
#  YY      �rstallet med to sifre, f.eks. 04 for 2004 (anbefaler ikke � bruke tosifrede �r)
#  ��      Samme som YY (norsk)
#  yyyy    �rtallet med fire sifre, men skriver ingenting dersom �rstallet er �rets (plass-sparing, ala tidstrk() ).
#  ����    Samme som yyyy
#  MM      M�ned, to sifre. F.eks. 08 for august.
#  DD      Dato, alltid to sifer. F.eks 01 for f�rste dag i en m�ned.
#  D       Dato, ett eller to sifre. F.eks. 1 for f�rste dag i en m�ned.
#  HH      Time. Fra 00, 01, 02 osv opp til 23.
#  HH24    Samme som HH. Ingen forskjell. Tatt med for � fjerne tvil om det er 00-12-11 eller 00-23
#  HH12    NB: Kl 12 blir 12, kl 13 blir 01, kl 14 blir 02 osv .... 23 blir 11,
#          MEN 00 ETTER MIDNATT BLIR 12 ! Oracle er ogs� slik.
#  TT      Samme som HH. Ingen forskjell. Fra 00 til 23. TT24 og TT12 finnes ikke.
#  MI      Minutt. Fra 00 til 59.
#  SS      Sekund. Fra 00 til 59.
#  
#  M�ned   Skriver m�nedens fulle navn p� norsk. Med stor f�rstebokstav, resten sm�.
#          F.eks. Januar, Februar osv. NB: V�r oppmerksom p� at m�neder p� norsk normal
#          skrives med liten f�rstebokstav (om ikke i starten av setning). Alt for mange
#          gj�r dette feil. P� engelsk skrives de ofte med stor f�rstebokstav.
#  M�ne    Skriver m�nedens navn forkortet og uten punktum. P� norsk. De med tre eller
#          fire bokstaver forkortes ikke: Jan Feb Mars Apr Mai Juni Juli Aug Sep Okt Nov Des
#  M�ne.   Samme som M�ne, men bruker punktum der det forkortes. Bruker alltid fire tegn.
#          Jan. Feb. Mars Apr. Mai Juni Juli Aug. Sep. Okt. Nov. Des.
#  M�n     Tre bokstaver, norsk: Jan Feb Mar Apr Mai Jun Jul Aug Sep Okt Nov Des
#  
#  Month   Engelsk: January February May June July October December, ellers = norsk.
#  Mont    Engelsk: Jan Feb Mars Apr May June July Aug Sep Oct Nov Dec
#  Mont.   Engelsk: Jan. Feb. Mars Apr. May June July Aug. Sep. Oct. Nov. Dec.
#  Mon     Engelsk: Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
#  
#  m�ned m�ne m�ne. m�n       Samme, men med liten f�rstebokstav. P� norsk.
#  month mont mont. mon       Samme, men med liten f�rstebokstav. P� engelsk.
#  M�NED M�NE M�NE. M�N       Samme, men med alle bokstaver store. P� norsk.
#  MONTH MONT MONT. MON       Samme, men med alle bokstaver store. P� engelsk.
#  
#  Dag     Dagens navn p� norsk. Stor f�rstebokstav, resten sm�. Mandag Tirsdag Onsdag Torsdag
#          Fredag L�rdag S�ndag.
#  Dg      Dagens navn p� norsk forkortet. Stor f�rstebokstav, resten sm�.
#          Alltid tre bokstaver: Man Tir Ons Tor Fre L�r S�n
#  Day     Samme som Dag, men p� engelsk. Monday Tuesday Wednesday Thursday Friday Saturday Sunday
#  Dy      Samme som Dg, men p� engelsk. Alltid tre bokstaver: Mon Tue Wed Thu Fri Sat Sun
#  
#  dag dg day dy DAG DG DAY DY       ....du klarer sikkert � gjette...
#  
#  UKE     Ukenr ett eller to siffer. Bruker ISO-definisjonen som brukes stort sett i hele verden unntatt USA.
#  UKENR   Ukenr, alltid to siffer, 01 02 osv. Se uke() et annet sted i SO::Bibl for mer om dette.
# 
# 
#  Gjenst�r:  Dag- og m�nedsnavn p� nynorsk og samisk.
# 
#  Gjenst�r:  Dth => 1st eller 2nd hvis dato er den f�rste eller andre
#   
#  Gjenst�r:  M => M�ned ett eller to sifre, slik D er dato med ett eller to. Vanskelig/umulig(?)
#   
#  Gjenst�r:  J => "julian day"....
#   
#  Gjenst�r:  Sjekke om den takler tidspunkt for sv�rt lenge siden eller om sv�rt lenge...
#             Kontroll med kanskje die ved input
#   
#  Gjenst�r:  sub dit() (tid baklengs... eller et bedre navn) for � konvertere andre veien.
#             Som med to_date og to_char i Oracle. Se evt L<Date::Parse> isteden.
#   
#  Gjenst�r:  Hvis formatstrengen er DDMMYY (evt DDMM��), og det finnes en tredje argument,
#             s� vil den tredje argumenten sees p� som personnummer og DD vil bli DD+40
#             eller MM vil bli MM+50 hvis personnummeret medf�rer D- eller S-type f�dselsnr.
#             Hmm, kanskje ikke. Se heller  sub foedtdato  og  sub fnr  m.fl.
#  
#  Gjenst�r:  Testing p� tidspunkter p� mer enn hundre �r framover eller tilbake i tid.
# 
# Se ogs� L</tidstrk> og L</tidstr>
# 
# =cut
# 
# our %SObibl_tid_strenger;
# our $SObibl_tid_pattern;
# 
# sub tid
# {
#   return undef if @_>1 and not defined $_[1];
#   return 1900+(localtime())[5] if $_[0]=~/^(?:����|YYYY)$/ and @_==1; # kjappis for tid("����") og tid("YYYY")
# 
#   my($format,$time,$er_dato)=@_;
#   
# 
#   $time=time() if @_==1;
# 
#   ($time,$format)=($format,$time)
#     if $format=~/^[\d+\:\-]+$/; #swap hvis format =~ kun tall og : og -
# 
#   $format=~s,([Mm])aa,$1�,;
#   $format=~s,([Mm])AA,$1�,;
# 
#   $time = yyyymmddhh24miss_time("$1$2$3$4$5$6")
#     if $time=~/^((?:19|20|18)\d\d)          #yyyy
#                 (0[1-9]|1[012])             #mm
#                 (0[1-9]|[12]\d|3[01]) \-?   #dd
#                 ([01]\d|2[0-3])       \:?   #hh24
#                 ([0-5]\d)             \:?   #mi
#                 ([0-5]\d)             $/x;  #ss
# 
#   $time = yyyymmddhh24miss_time(dato_ok("$1$2$3")."000000")
#     if $time=~/^(\d\d)(\d\d)(\d\d)$/ and $er_dato;
# 
#   $time = yyyymmddhh24miss_time("$1$2${3}000000")
#     if $time=~/^((?:18|19|20)\d\d)(\d\d)(\d\d)$/ and $er_dato;
# 
#   my @lt=localtime($time);
#   if($format){
#     unless(defined %SObibl_tid_strenger){
#       %SObibl_tid_strenger=
# 	  ('M�NED' => [4, 'JANUAR','FEBRUAR','MARS','APRIL','MAI','JUNI','JULI',
# 		          'AUGUST','SEPTEMBER','OKTOBER','NOVEMBER','DESEMBER' ],
# 	   'M�ned' => [4, 'Januar','Februar','Mars','April','Mai','Juni','Juli',
# 		          'August','September','Oktober','November','Desember'],
# 	   'm�ned' => [4, 'januar','februar','mars','april','mai','juni','juli',
# 		          'august','september','oktober','november','desember'],
# 	   'M�NE.' => [4, 'JAN.','FEB.','MARS','APR.','MAI','JUNI','JULI','AUG.','SEP.','OKT.','NOV.','DES.'],
# 	   'M�ne.' => [4, 'Jan.','Feb.','Mars','Apr.','Mai','Juni','Juli','Aug.','Sep.','Okt.','Nov.','Des.'],
# 	   'm�ne.' => [4, 'jan.','feb.','mars','apr.','mai','juni','juli','aug.','sep.','okt.','nov.','des.'],
# 	   'M�NE'  => [4, 'JAN','FEB','MARS','APR','MAI','JUNI','JULI','AUG','SEP','OKT','NOV','DES'],
# 	   'M�ne'  => [4, 'Jan','Feb','Mars','Apr','Mai','Juni','Juli','Aug','Sep','Okt','Nov','Des'],
# 	   'm�ne'  => [4, 'jan','feb','mars','apr','mai','juni','juli','aug','sep','okt','nov','des'],
# 	   'M�N'   => [4, 'JAN','FEB','MAR','APR','MAI','JUN','JUL','AUG','SEP','OKT','NOV','DES'],
# 	   'M�n'   => [4, 'Jan','Feb','Mar','Apr','Mai','Jun','Jul','Aug','Sep','Okt','Nov','Des'],
# 	   'm�n'   => [4, 'jan','feb','mar','apr','mai','jun','jul','aug','sep','okt','nov','des'],
# 
# 	   'MONTH' => [4, 'JANUARY','FEBRUARY','MARCH','APRIL','MAY','JUNE','JULY',
# 		          'AUGUST','SEPTEMBER','OCTOBER','NOVEMBER','DECEMBER'],
# 	   'Month' => [4, 'January','February','March','April','May','June','July',
# 		          'August','September','October','November','December'],
# 	   'month' => [4, 'january','february','march','april','may','june','july',
# 		          'august','september','october','november','december'],
# 	   'MONT.' => [4, 'JAN.','FEB.','MAR.','APR.','MAY','JUNE','JULY','AUG.','SEP.','OCT.','NOV.','DEC.'],
# 	   'Mont.' => [4, 'Jan.','Feb.','Mar.','Apr.','May','June','July','Aug.','Sep.','Oct.','Nov.','Dec.'],
# 	   'mont.' => [4, 'jan.','feb.','mar.','apr.','may','june','july','aug.','sep.','oct.','nov.','dec.'],
# 	   'MONT'  => [4, 'JAN','FEB','MAR','APR','MAY','JUNE','JULY','AUG','SEP','OCT','NOV','DEC'],
# 	   'Mont'  => [4, 'Jan','Feb','Mar','Apr','May','June','July','Aug','Sep','Oct','Nov','Dec'],
# 	   'mont'  => [4, 'jan','feb','mar','apr','may','june','july','aug','sep','oct','nov','dec'],
# 	   'MON'   => [4, 'JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'],
# 	   'Mon'   => [4, 'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
# 	   'mon'   => [4, 'jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec'],
# 	   'DAY'   => [6, 'SUNDAY','MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY'],
# 	   'Day'   => [6, 'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'],
# 	   'day'   => [6, 'sunday','monday','tuesday','wednesday','thursday','friday','saturday'],
# 	   'DY'    => [6, 'SUN','MON','TUE','WED','THU','FRI','SAT'],
# 	   'Dy'    => [6, 'Sun','Mon','Tue','Wed','Thu','Fri','Sat'],
# 	   'dy'    => [6, 'sun','mon','tue','wed','thu','fri','sat'],
# 	   'DAG'   => [6, 'S�NDAG','MANDAG','TIRSDAG','ONSDAG','TORSDAG','FREDAG','L�RDAG'],
# 	   'Dag'   => [6, 'S�ndag','Mandag','Tirsdag','Onsdag','Torsdag','Fredag','L�rdag'],
# 	   'dag'   => [6, 's�ndag','mandag','tirsdag','onsdag','torsdag','fredag','l�rdag'],
# 	   'DG'    => [6, 'S�N','MAN','TIR','ONS','TOR','FRE','L�R'],
# 	   'Dg'    => [6, 'S�n','Man','Tir','Ons','Tor','Fre','L�r'],
# 	   'dg'    => [6, 's�n','man','tir','ons','tor','fre','l�r'],
# 	   );
#       for(qw(MAANED Maaned maaned MAAN Maan maan),'MAANE.','Maane.','maane.'){
# 	$SObibl_tid_strenger{$_}=$SObibl_tid_strenger{replace($_,"aa","�","AA","�")};
#       }
#       $SObibl_tid_pattern=join("|",map{quotemeta($_)}
#  	                           sort{length($b)<=>length($a)}
#                                    keys %SObibl_tid_strenger);
#       #uten sort kan "m�ned" bli "mared", fordi "m�n"=>"mar"
#     }
#     $format=~s/($SObibl_tid_pattern)/$SObibl_tid_strenger{$1}[1+$lt[$SObibl_tid_strenger{$1}[0]]]/g;
# 
#     $format=~s/TT|tt/HH/;
#     $format=~s/��/YY/g;$format=~s/��/yy/g;
#     $format=~s/YYYY             /1900+$lt[5]                  /gxe;
#     $format=~s/(\s?)yyyy        /$lt[5]==(localtime)[5]?"":$1.(1900+$lt[5])/gxe;
#     $format=~s/YY               /sprintf("%02d",$lt[5]%100)   /gxei;
#     $format=~s/MM               /sprintf("%02d",$lt[4]+1)     /gxe;
#     $format=~s/mm               /sprintf("%d",$lt[4]+1)       /gxe;
#     $format=~s/DD               /sprintf("%02d",$lt[3])       /gxe;
#     $format=~s/D(?![AaGgYyEeNn])/$lt[3]                       /gxe; #EN pga desember og wednesday
#     $format=~s/dd               /sprintf("%d",$lt[3])         /gxe;
#     $format=~s/hh12|HH12        /sprintf("%02d",$lt[2]<13?$lt[2]||12:$lt[2]-12)/gxe;
#     $format=~s/HH24|HH24|HH|hh  /sprintf("%02d",$lt[2])       /gxe;
#     $format=~s/MI               /sprintf("%02d",$lt[1])       /gxei;
#     $format=~s/SS               /sprintf("%02d",$lt[0])       /gxei;
#     $format=~s/UKENR            /sprintf("%02d",ukenr($time)) /gxei;
#     $format=~s/UKE              /ukenr($time)                 /gxei;
#     $format=~s/SS               /sprintf("%02d",$lt[0])       /gxei;
# 
#     return $format;
#   }
#   else{
#     return sprintf("%04d%02d%02d%02d%02d%02d",1900+$lt[5],1+$lt[4],@lt[3,2,1,0]);
#   }
# }

=head2 easter

Input: A year (a four digit number)

Output: array of two numbers: day and month of Easter Sunday that year. Month 3 means March and 4 means April.

 sub easter { use integer;my$Y=shift;my$C=$Y/100;my$L=($C-$C/4-($C-($C-17)/25)/3+$Y%19*19+15)%30;
             (($L-=$L>28||($L>27?1-(21-$Y%19)/11:0))-=($Y+$Y/4+$L+2-$C+$C/4)%7)<4?($L+28,3):($L-3,4) }

...is a "golfed" version of Oudins algorithm (1940) L<http://astro.nmsu.edu/~lhuber/leaphist.html>
(see also http://www.smart.net/~mmontes/ec-cal.html )

Valid for any Gregorian year. Dates repeat themselves after 70499183
lunations = 2081882250 days = ca 5699845 years. However, our planet will
by then have a different rotation and spin time...

Example:

 ( $day, $month ) = easter( 2012 ); # $day == 8 and $month == 4

Example 2:

 my @e=map sprintf("%02d%02d", reverse(easter($_))), 1800..300000;
 print "First: ".min(@e)." Last: ".max(@e)."\n"; # First: 0322 Last: 0425

=cut

sub easter { use integer;my$Y=shift;my$C=$Y/100;my$L=($C-$C/4-($C-($C-17)/25)/3+$Y%19*19+15)%30;
             (($L-=$L>28||($L>27?1-(21-$Y%19)/11:0))-=($Y+$Y/4+$L+2-$C+$C/4)%7)<4?($L+28,3):($L-3,4) }


=head2 time_fp

No input arguments.

Return the same number as perls C<time()> except with decimals (fractions of a second, _fp as in floating point number).

 print time_fp(),"\n";
 print time(),"\n";

Could write:

 1116776232.38632

...if that is the time now.

Or just:

 1116776232

...from perl's internal C<time()> if C<Time::HiRes> isn't installed and available.


=cut

sub time_fp    # {return 0+gettimeofday} is just as well?
{
    eval{ require Time::HiRes } or return time();
    my($sec,$mic)=Time::HiRes::gettimeofday();
    return $sec+$mic/1e6; #1e6 not portable?
}

=head2 sleep_fp

sleep_fp() work as the built in C<< sleep() >>, but accepts fractional seconds:

 sleep_fp(0.02);  # sleeps for 20 milliseconds

Sub sleep_fp do a C<require Time::HiRes>, thus it might take some
extra time the first call. To avoid that, add C<< use Time::HiRes >>
to your code. Sleep_fp should not be trusted for accuracy to more than
a tenth of a second. Virtual machines tend to be less accurate (sleep
longer) than physical ones. This was tested on VMware and RHEL
(Linux). See also L<Time::HiRes>.

=cut

sub sleep_fp { eval{require Time::HiRes} or (sleep(shift()),return);Time::HiRes::sleep(shift()) }

=head2 eta

Estimated time of arrival. ...NOT IMPLEMENTED YET...

=cut

our %Eta;
our $Eta_forgetfulness=2;
#http://en.wikipedia.org/wiki/Kalman_filter god id�?

sub eta
{
  my($id,$pos,$end,$time_fp)=@_;
  #@_==2 ? ("",@_) : @_==3 ? (@_) : croak"Two or three arguments to eta()";
  $time_fp=time_fp() if not defined $time_fp;
  my $a=$Eta{$id}||=[];
  push @$a, [$pos,$time_fp];
  return undef if @$a<2;
# print "$$a[-1][1] + ($end-$$a[-1][0]) * ($$a[-1][1]-$$a[-2][1])/($$a[-1][0]-$$a[-2][0])\n";
  
  my @eta;
  for(2..@$a){
    push @eta, $$a[-1][1] + ($end-$$a[-1][0]) * ($$a[-1][1]-$$a[-$_][1])/($$a[-1][0]-$$a[-$_][0]);
  }
  my($sum,$sumw,$w)=(0,0,1);
  for(@eta){
    $sum+=$w*$_;
    $sumw+=$w;
    $w/=$Eta_forgetfulness;
  }
  my $avg=$sum/$sumw;
  return $avg;
#  return avg(@eta);
 #return $$a[-1][1] + ($end-$$a[-1][0]) * ($$a[-1][1]-$$a[-2][1])/($$a[-1][0]-$$a[-2][0]);
  1;
}

=head2 sleep_until

sleep_until(0.5) sleeps until half a second has passed since the last
call to sleep_until. This example starts the next job excactly ten
seconds after the last job started even if the last job lasted for a
while (but not more than ten seconds):

 for(@jobs){
   sleep_until(10);
   print localtime()."\n";
   ...heavy job....
 }

Might print:

 Thu Jan 12 16:00:00 2012
 Thu Jan 12 16:00:10 2012
 Thu Jan 12 16:00:20 2012

...and so on even if the C<< ...heavy job... >>-part takes more than a
second to complete. Whereas if sleep(10) was used, each job would
spend more than ten seconds in average since the work time would be
added to sleep(10).

Note: sleep_until() will remember the time of ANY last call of this
sub, not just the one on the same line in the source code (this might
change in the future). The first call to sleep_until() will be the
same as sleep_fp().

=cut

our $Time_last_sleep_until;
sub sleep_until
{
  my $s=@_==1?shift():0;
  my $time=time_fp();
  my $sleep=$s-($time-nvl($Time_last_sleep_until,0));
  $Time_last_sleep_until=time;
  sleep_fp($sleep) if $sleep>0;
}

=head2 sys

Call instead of C<system> if you want C<die> if something fails. Uses Carp::croak internally.

 sub sys($){my$s=shift;system($s)==0 or croak"ERROR, sys($s) ($!) ($?)"}

=cut

sub sys($){my$s=shift;system($s)==0 or croak"ERROR, sys($s) ($!) ($?)"}

=head2 recursed

Returns true or false (actually 1 or 0) depending on whether the
current sub has been called by itself or not.

 sub xyz
 {
    xyz() if not recursed;

 }

=cut

sub recursed {(caller(1))[3] eq (caller(2))[3]?1:0}

=head2 md5sum

B<Input:> a filename.

B<Output:> a string of 32 hexadecimal chars from 0-9 or a-f.

Example, the md5sum linux command without options could be implementet like this:

 #!/usr/bin/perl
 use Acme::Tools;
 print md5sum($_)."  $_\n" for @ARGV;

This sub requires L<Digest::MD5>, which is a core perl-module since
version 5.?.?  It does not slurp the files or spawn new processes.

=cut

sub md5sum
{
  my $fn=shift;
  open my $M, '<', $fn or croak "Could not open file $fn for md5sum() $!";
  binmode($M);
  require Digest::MD5;
  return Digest::MD5->new->addfile($M)->hexdigest;
}

=head1 BLOOM FILTER SUBROUTINES

Bloom filters can be used to check whether an element (a string) is a
member of a large set using much less memory or disk space than other
data structures. Trading speed and accuracy for memory usage. While
risking false positives, Bloom filters have a very strong space
advantage over other data structures for representing sets.

In the example below, a set of 100000 phone numbers (or any string of
any length) can be "stored" in just 91230 bytes if you accept that you
can only check the data structure for existence of a string and accept
false positives with an error rate of 0.03 (that is three percent, error
rates are given in numbers larger then 0 and smaller than 1).

You can not retrieve the strings in the set without using "brute
force" methods and even then you would get slightly more strings than
you put in because of the error rate inaccuracy.

Bloom Filters have many uses.

See also: L<http://en.wikipedia.org/wiki/Bloom_filter>

See also: L<Bloom::Filter>

=head2 bfinit

Initialize a new Bloom Filter:

  my $bf = bfinit( error_rate=>0.01, capacity=>100000 );

The same:

  my $bf = bfinit( 0.01, 100000 );

since two arguments is interpreted as error_rate and capacity accordingly.


=head2 bfadd

  bfadd($bf, $_) for @phone_numbers;   # Adding strings one at a time

  bfadd($bf, @phone_numbers);          # ...or all at once (faster)

Returns 1 on success. Dies (croaks) if more strings than capacity is added.

=head2 bfcheck

  my $phone_number="97713246";
  if ( bfcheck($bf, $phone_number) ) {
    print "Yes, $phone_number was PROBABLY added\n";
  }
  else{
    print "No, $phone_number was DEFINITELY NOT added\n";
  }

Returns true if C<$phone_number> exists in C<@phone_numbers>.

Returns false most of the times, but sometimes true*), if C<$phone_number> doesn't exists in C<@phone_numbers>.

*) This is called a false positive.

Checking more than one key:

 @bools = bfcheck($bf, @keys);    #or ...
 @bools = bfcheck($bf, \@keys);   #better if @keys is large

Returns an array the same size as @keys where each element is true or false accordingly.

=head2 bfgrep

Same as C<bfcheck> except it returns the keys that exists in the bloom filter

 @found = bfgrep($bf, @keys);           #or ...
 @found = bfgrep($bf, \@keys);          #better if @keys is large, or ...
 @found = grep bfcheck($bf,$_), @keys;  #same but slower

=head2 bfgrepnot

Same as C<bfgrep> except it returns the keys that do NOT exists in the bloom filter:

 @not_found = bfgrepnot($bf, @keys);          #or ...
 @not_found = bfgrepnot($bf, \@keys);         #better if @keys is large
 @not_found = grep !bfcheck($bf,$_), @keys);  #same but slower

=head2 bfdelete

Deletes from a counting bloom filter.

To enable deleting be sure to initialize the bloom filter with the
numeric C<counting_bits> argument. The number of bits could be 2 or 3
for small filters with a small capacity (a small number of keys), but
setting the number to 4 ensures that even very large filters with very
small error rates would not overflow.

Acme::Tools do not currently support C<< counting_bits => 3 >> so 4
and 8 are the only practical alternatives.

 my $bf=bfinit(
   error_rate=>0.001,
   capacity=>10e6,
   counting_bits=>4     # a power of 2, i.e. 2, 4, 8, 16 or 32
 );
 bfadd(   $bf, @phone_numbers);     # make sure the phone numbers are unique!
 bfdelete($bf, @phone_numbers);

To examine the frequency of the counters with 4 bit counters and 4 million keys:

 my $bf=bfinit( error_rate=>0.001, capacity=>4e6, counting_bits=>4 );
 bfadd($bf,[1e3*$_+1 .. 1e3*($_+1)]) for 0..4000-1;  # adding 4 million keys one thousand at a time
 my %c; $c{vec($$bf{filter},$_,$$bf{counting_bits})}++ for 0..$$bf{filterlength}-1;
 printf "%8d counters is %2d\n",$c{$_},$_ for sort{$a<=>$b}keys%c;

The output:

 28689562 counters is  0
 19947673 counters is  1
  6941082 counters is  2
  1608250 counters is  3
   280107 counters is  4
    38859 counters is  5
     4533 counters is  6
      445 counters is  7
       46 counters is  8
        1 counters is  9

Even after the error_rate is changed from 0.001 to a percent of that, 0.00001, the limit of 16 (4 bits) is still far away:

 47162242 counters is  0
 33457237 counters is  1
 11865217 counters is  2
  2804447 counters is  3
   497308 counters is  4
    70608 counters is  5
     8359 counters is  6
      858 counters is  7
       65 counters is  8
        4 counters is  9

In algorithmic terms the number of bits needed is C<ln of ln of n>.
Thats why 4 bits (counters up to 15) is "always" good enough.

(Except when adding the same key many times, which should be avoided, and Acme::Tools::bfadd don't check for that).

Bloom filters of the counting type are not very space efficient: The tables above shows that 84%-85%
of the counters are 0 or 1. This means most bits are zero-bits. This doesn't have to be a problem if
a counting bloom filter is used to be sent over slow networks because they are very compressable by
common compression tools like I<gzip> or L<Compress::Zlib> and such.

Deletion of non-existing keys C<bfdelete> croaks on deletion of a non-existing key

=head2 bfdelete

Deletes from a counting bloom filter:

 bfdelete($bf, @keys);
 bfdelete($bf, \@keys);

Returns C<$bf> after deletion.

Croaks (dies) on deleting a non-existing key or deleting from an previouly overflown counter in a counting bloom filter.

=head2 bfaddbf

Adds another bloom filter to a bloom filter.

Bloom filters has the proberty that bit-wise I<OR>-ing the bit-filters
of two filters with the same capacity and the same number and type of
hash functions, adds the filters:

  my $bf1=bfinit(error_rate=>0.01,capacity=>$cap,keys=>[1..500]);
  my $bf2=bfinit(error_rate=>0.01,capacity=>$cap,keys=>[501..1000]);

  bfaddbf($bf1,$bf2);

  print "Yes!" if bfgrep($bf1, 1..1000) == 1000;

Prints yes since C<bfgrep> now returns an array of all the 1000 elements.

Croaks if the filters are of different dimensions.

Works for counting bloom filters as well (C<< counting_bits=>4 >> e.g.)

=head2 bfsum

Returns the number of 1's in the filter.

 my $percent=100*bfsum($bf)/$$bf{filterlength};
 printf "The filter is %.1f%% filled\n",$percent; #prints 50.0% or so if filled to capacity

Sums the counters for counting bloom filters (much slower than for non counting).

=head2 bfdimensions

Input, two numeric arguments: Capacity and error_rate.

Outputs an array of two numbers: m and k.

  m = - n * log(p) / log(2)**2   # n = capacity, m = bits in filter (divide by 8 to get bytes)
  k = log(1/p) / log(2)          # p = error_rate, uses perls internal log() with base e (2.718)

...that is: m = the best number of bits in the filter and k = the best
number of hash functions optimized for the given capacity (n) and
error_rate (p). Note that k is a dependent only of the error_rate.  At
about two percent error rate the bloom filter needs just the same
number of bytes as the number of keys.

 Storage (bytes):
 Capacity      Error-rate  Error-rate Error-rate Error-rate Error-rate Error-rate Error-rate Error-rate Error-rate Error-rate Error-rate Error-rate
               0.000000001 0.00000001 0.0000001  0.000001   0.00001    0.0001     0.001      0.01       0.02141585 0.1        0.5        0.99
 ------------- ----------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- 
            10 54.48       48.49      42.5       36.51      30.52      24.53      18.53      12.54      10.56      6.553      2.366      0.5886
           100 539.7       479.8      419.9      360        300.1      240.2      180.3      120.4      100.6      60.47      18.6       0.824
          1000 5392        4793       4194       3595       2996       2397       1798       1199       1001       599.6      180.9      3.177
         10000 5.392e+04   4.793e+04  4.194e+04  3.594e+04  2.995e+04  2.396e+04  1.797e+04  1.198e+04  1e+04      5991       1804       26.71
        100000 5.392e+05   4.793e+05  4.193e+05  3.594e+05  2.995e+05  2.396e+05  1.797e+05  1.198e+05  1e+05      5.991e+04  1.803e+04  262
       1000000 5.392e+06   4.793e+06  4.193e+06  3.594e+06  2.995e+06  2.396e+06  1.797e+06  1.198e+06  1e+06      5.991e+05  1.803e+05  2615
      10000000 5.392e+07   4.793e+07  4.193e+07  3.594e+07  2.995e+07  2.396e+07  1.797e+07  1.198e+07  1e+07      5.991e+06  1.803e+06  2.615e+04
     100000000 5.392e+08   4.793e+08  4.193e+08  3.594e+08  2.995e+08  2.396e+08  1.797e+08  1.198e+08  1e+08      5.991e+07  1.803e+07  2.615e+05
    1000000000 5.392e+09   4.793e+09  4.193e+09  3.594e+09  2.995e+09  2.396e+09  1.797e+09  1.198e+09  1e+09      5.991e+08  1.803e+08  2.615e+06
   10000000000 5.392e+10   4.793e+10  4.193e+10  3.594e+10  2.995e+10  2.396e+10  1.797e+10  1.198e+10  1e+10      5.991e+09  1.803e+09  2.615e+07
  100000000000 5.392e+11   4.793e+11  4.193e+11  3.594e+11  2.995e+11  2.396e+11  1.797e+11  1.198e+11  1e+11      5.991e+10  1.803e+10  2.615e+08
 1000000000000 5.392e+12   4.793e+12  4.193e+12  3.594e+12  2.995e+12  2.396e+12  1.797e+12  1.198e+12  1e+12      5.991e+11  1.803e+11  2.615e+09

 Error rate:               0.99   Hash functions:  1
 Error rate:                0.5   Hash functions:  1
 Error rate:                0.1   Hash functions:  3
 Error rate: 0.0214158522653385   Hash functions:  6
 Error rate:               0.01   Hash functions:  7
 Error rate:              0.001   Hash functions: 10
 Error rate:             0.0001   Hash functions: 13
 Error rate:            0.00001   Hash functions: 17
 Error rate:           0.000001   Hash functions: 20
 Error rate:          0.0000001   Hash functions: 23
 Error rate:         0.00000001   Hash functions: 27
 Error rate:        0.000000001   Hash functions: 30

=head2 bfstore

Storing and retrieving bloom filters to and from disk uses L<Storable>s C<store> and C<retrieve>. This:

 bfstore($bf,'filename.bf');

It the same as:

 use Storable qw(store retrieve);
 ...
 store($bf,'filename.bf');

=head2 bfretrieve

This:

 my $bf=bfretrieve('filename.bf');

Or this:

 my $bf=bfinit('filename.bf');

Is the same as:

 use Storable qw(store retrieve);
 my $bf=retrieve('filename.bf');

=head2 bfclone

Deep copies the bloom filter data structure. (Which is not very deep, two levels at most)

This:

 my $bfc = bfclone($bf);

Works just as:

 use Storable;
 my $bfc=Storable::dclone($bf);

=head2 Object oriented interface to bloom filters

 use Acme::Tools;
 my $bf=new Acme::Tools::BloomFilter(0.1,1000); # the same as bfinit, see bfinit above
 print ref($bf),"\n";                           # prints Acme::Tools:BloomFilter
 $bf->add(@keys);
 $bf->check($keys[0]) and print "ok\n";         # prints ok
 $bf->grep(\@keys)==@keys and print "ok\n";     # prints ok
 $bf->store('filename.bf');
 my $bf2=bfretrieve('filename.bf');
 $bf2->check($keys[0]) and print "ok\n";        # still ok

 $bf2=$bf->clone();

To instantiate a previously stored bloom filter:

 my $bf = Acme::Tools::BloomFilter->new( '/path/to/stored/bloomfilter.bf' );

The o.o. interface has the same methods as the C<bf...>-subs without the
C<bf>-prefix in the names. The C<bfretrieve> is not available as a
method, although C<bfretrieve>, C<Acme::Tools::bfretrieve> and
C<Acme::Tools::BloomFilter::retrieve> are synonyms.

=head2 Internals and speed

The internal hash-functions are C<< md5( "$key$salt" ) >> from L<Digest::MD5>.

Since C<md5> returns 128 bits and most medium to large sized bloom
filters need only a 32 bit hash function, the result from md5() are
split (C<unpack>-ed) into 4 parts 32 bits each and are treated as if 4
hash functions was called at once (speedup). Using different salts to
the key on each md5 results in different hash functions.

Digest::SHA512 would have been even better since it returns more bits,
if it werent for the fact that it's much slower than Digest::MD5.

String::CRC32::crc32 is faster than Digest::MD5, but not 4 times faster:

 time perl -e'use Digest::MD5 qw(md5);md5("asdf$_") for 1..10e6'       #5.56 sec
 time perl -e'use String::CRC32;crc32("asdf$_") for 1..10e6'           #2.79 sec, faster but not per bit
 time perl -e'use Digest::SHA qw(sha512);sha512("asdf$_") for 1..10e6' #36.10 sec, too slow (sha1, sha224, sha256 and sha384 too)

Md5 seems to be an ok choice both for speed and avoiding collitions due to skewed data keys.

=head2 Theory and math behind bloom filters

L<http://www.internetmathematics.org/volumes/1/4/Broder.pdf>

L<http://blogs.sun.com/jrose/entry/bloom_filters_in_a_nutshell>

L<http://pages.cs.wisc.edu/~cao/papers/summary-cache/node8.html>

See also Scaleable Bloom Filters: L<http://gsd.di.uminho.pt/members/cbm/ps/dbloom.pdf> (not implemented in Acme::Tools)

...and perhaps L<http://intertrack.naist.jp/Matsumoto_IEICE-ED200805.pdf>

=cut

sub bfinit
{
  return bfretrieve(@_)                             if @_==1;
  return bfinit(error_rate=>$_[0], capacity=>$_[1]) if @_==2 and 0<$_[0] and $_[0]<1 and $_[1]>1;
  return bfinit(error_rate=>$_[1], capacity=>$_[0]) if @_==2 and 0<$_[1] and $_[1]<1 and $_[0]>1;
  require Digest::MD5;
  @_%2&&croak "Arguments should be a hash of equal number of keys and values";
  my %arg=@_;
  my @ok_param=qw/error_rate capacity min_hashfuncs max_hashfuncs hashfuncs counting_bits adaptive keys/;
  my @not_ok=sort(grep!in($_,@ok_param),keys%arg);
  croak "Not ok param to bfinit: ".join(", ",@not_ok) if @not_ok;
  croak "Not an arrayref in keys-param" if exists $arg{keys} and ref($arg{keys}) ne 'ARRAY';
  croak "Not implemented counting_bits=$arg{counting_bits}, should be 2, 4, 8, 16 or 32" if not in(nvl($arg{counting_bits},1),1,2,4,8,16,32);
  croak "An bloom filters here can not be in both adaptive and counting_bits modes" if $arg{adaptive} and $arg{counting_bits}>1;
  my $bf={error_rate    => 0.001,  #default p
	  capacity      => 100000, #default n
          min_hashfuncs => 1,
          max_hashfuncs => 100,
	  counting_bits => 1,      #default: not counting filter
	  adaptive      => 0,
	  %arg,                    #arguments
	  key_count     => 0,
	  overflow      => {},
	  version       => $Acme::Tools::VERSION,
	 };
  croak "Error rate ($$bf{error_rate}) should be larger than 0 and smaller than 1" if $$bf{error_rate}<=0 or $$bf{error_rate}>=1;
  @$bf{'min_hashfuncs','max_hashfuncs'}=(map$arg{hashfuncs},1..2) if $arg{hashfuncs};
  @$bf{'filterlength','hashfuncs'}=bfdimensions($bf); #m and k
  $$bf{filter}=pack("b*", '0' x ($$bf{filterlength}*$$bf{counting_bits}) ); #hm x   new empty filter
  $$bf{unpack}= $$bf{filterlength}<=2**16/4 ? "n*" # /4 alleviates skewing if m just slightly < 2**x
               :$$bf{filterlength}<=2**32/4 ? "N*"
               :                              "Q*";
  bfadd($bf,@{$arg{keys}}) if $arg{keys};
  return $bf;
}
sub bfaddbf {
  my($bf,$bf2)=@_;
  my $differror=join"\n",
    map "Property $_ differs ($$bf{$_} vs $$bf2{$_})",
    grep $$bf{$_} ne $$bf2{$_},
    qw/capacity counting_bits adaptive hashfuncs filterlength/; #not error_rate
  croak $differror if $differror;
  croak "Can not add adaptive bloom filters" if $$bf{adaptive};
  my $count=$$bf{key_count}+$$bf2{key_count};
  croak "Exceeded filter capacity $$bf{key_count} + $$bf2{key_count} = $count > $$bf{capacity}"
    if $count > $$bf{capacity};
  $$bf{key_count}+=$$bf2{key_count};
  if($$bf{counting_bits}==1){
    $$bf{filter} |= $$bf2{filter};
    #$$bf{filter} = $$bf{filter} | $$bf2{filter}; #or-ing 
  }
  else {
    my $cb=$$bf{counting_bits};
    for(0..$$bf{filterlength}-1){
      my $sum=
      vec($$bf{filter}, $_,$cb)+
      vec($$bf2{filter},$_,$cb);
      if( $sum>2**$cb-1 ){
	$sum=2**$cb-1;
	$$bf{overflow}{$_}++;
      }
      vec($$bf{filter}, $_,$cb)=$sum;
      no warnings;
      $$bf{overflow}{$_}+=$$bf2{overflow}{$_}
	and keys(%{$$bf{overflow}})>10 #hmm, arbitrary limit
	and croak "Too many overflows, concider doubling counting_bits from $cb to ".(2*$cb)
	if exists $$bf2{overflow}{$_};
    }
  }
  return $bf; #for convenience
}
sub bfsum {
  my($bf)=@_;
  return unpack( "%32b*", $$bf{filter}) if $$bf{counting_bits}==1;
  my($sum,$cb)=(0,$$bf{counting_bits});
  $sum+=vec($$bf{filter},$_,$cb) for 0..$$bf{filterlength}-1;
  return $sum;
}
sub bfadd
{ require Digest::MD5;
  my($bf,@keys)=@_;
  return if not @keys;
  my $keysref=@keys==1 && ref($keys[0]) eq 'ARRAY' ? $keys[0] : \@keys;
  my($m,$k,$up,$n,$cb,$adaptive)=@$bf{'filterlength','hashfuncs','unpack','capacity','counting_bits','adaptive'};
  for(@$keysref){
    #croak "Key should be scalar" if ref($_);
    $$bf{key_count} >= $n and croak "Exceeded filter capacity $n"  or  $$bf{key_count}++;
    my @h; push @h, unpack $up, Digest::MD5::md5($_,0+@h) while @h<$k;
    if ($cb==1 and not $adaptive) { # normal bloom filter
      vec($$bf{filter}, $h[$_] % $m, 1) = 1 for 0..$k-1;
    }
    elsif ($cb>1) {                 # counting bloom filter
      for(0..$k-1){
	my $pos=$h[$_] % $m;
	my $c=
  	vec($$bf{filter}, $pos, $cb) =
	vec($$bf{filter}, $pos, $cb) + 1;
	if($c==0){
	  vec($$bf{filter}, $pos, $cb) = -1;
	  $$bf{overflow}{$pos}++
	    and keys(%{$$bf{overflow}})>10 #hmm, arbitrary limit
	    and croak "Too many overflows, concider doubling counting_bits from $cb to ".(2*$cb);
	}
      }
    }
    elsif ($adaptive) {             # adaptive bloom filter
      my($i,$key,$bit)=(0+@h,$_);
      for(0..$$bf{filterlength}-1){
	$i+=push(@h, unpack $up, Digest::MD5::md5($key,$i)) if not @h;
	my $pos=shift(@h) % $m;
	$bit=vec($$bf{filter}, $pos, 1);
	vec($$bf{filter}, $pos, 1)=1;
	last if $_>=$k-1 and $bit==0;
      }
    }
    else {croak}
  }
  return 1;
}
sub bfcheck
{ require Digest::MD5;
  my($bf,@keys)=@_;
  return if not @keys;
  my $keysref=@keys==1 && ref($keys[0]) eq 'ARRAY' ? $keys[0] : \@keys;
  my($m,$k,$up,$cb,$adaptive)=@$bf{'filterlength','hashfuncs','unpack','counting_bits','adaptive'};
  my $wa=wantarray();
  if(not $adaptive){ # normal bloom filter  or  counting bloom filter
    return map {
      my $match = 1; # match if every bit is on
      my @h; push @h, unpack $up, Digest::MD5::md5($_,0+@h) while @h<$k;
      vec($$bf{filter}, $h[$_] % $m, $cb) or $match=0 or last for 0..$k-1;
      return $match if not $wa;
      $match;
    } @$keysref;
  }
  else {             # adaptive bloom filter
    return map {
      my($match,$i,$key,$bit,@h)=(1,0,$_);
      for(0..$$bf{filterlength}-1){
	$i+=push(@h, unpack $up, Digest::MD5::md5($key,$i)) if not @h;
	my $pos=shift(@h) % $m;
	$bit=vec($$bf{filter}, $pos, 1);
	$match++ if $_ >  $k-1 and $bit==1;
	$match=0 if $_ <= $k-1 and $bit==0;
	last     if $bit==0;
      }
      return $match if not $wa;
      $match;
    } @$keysref;
  }
}
sub bfgrep # just a copy of bfcheck with map replaced by grep
{ require Digest::MD5;
  my($bf,@keys)=@_;
  return if not @keys;
  my $keysref=@keys==1 && ref($keys[0]) eq 'ARRAY' ? $keys[0] : \@keys;
  my($m,$k,$up,$cb)=@$bf{'filterlength','hashfuncs','unpack','counting_bits'};
  return grep {
    my $match = 1; # match if every bit is on
    my @h; push @h, unpack $up, Digest::MD5::md5($_,0+@h) while @h<$k;
    vec($$bf{filter}, $h[$_] % $m, $cb) or $match=0 or last for 0..$k-1;
    $match;
  } @$keysref;
}
sub bfgrepnot # just a copy of bfgrep with $match replaced by not $match
{ require Digest::MD5;
  my($bf,@keys)=@_;
  return if not @keys;
  my $keysref=@keys==1 && ref($keys[0]) eq 'ARRAY' ? $keys[0] : \@keys;
  my($m,$k,$up,$cb)=@$bf{'filterlength','hashfuncs','unpack','counting_bits'};
  return grep {
    my $match = 1; # match if every bit is on
    my @h; push @h, unpack $up, Digest::MD5::md5($_,0+@h) while @h<$k;
    vec($$bf{filter}, $h[$_] % $m, $cb) or $match=0 or last for 0..$k-1;
    not $match;
  } @$keysref;
}
sub bfdelete
{ require Digest::MD5;
  my($bf,@keys)=@_;
  return if not @keys;
  my $keysref=@keys==1 && ref($keys[0]) eq 'ARRAY' ? $keys[0] : \@keys;
  my($m,$k,$up,$cb)=@$bf{'filterlength','hashfuncs','unpack','counting_bits'};
  croak "Cannot delete from non-counting bloom filter (use counting_bits 4 e.g.)" if $cb==1;
  for my $key (@$keysref){
    my @h; push @h, unpack $up, Digest::MD5::md5($key,0+@h) while @h<$k;
    $$bf{key_count}==0 and croak "Deleted all and then some"  or  $$bf{key_count}--;
    my($ones,$croak,@pos)=(0);
    for(0..$k-1){
      my $pos=$h[$_] % $m;
      my $c=
      vec($$bf{filter}, $pos, $cb);
      vec($$bf{filter}, $pos, $cb)=$c-1;
      $croak="Cannot delete a non-existing key $key" if $c==0;
      $croak="Cannot delete with previously overflown position. Try doubleing counting_bits"
	if $c==1 and ++$ones and $$bf{overflow}{$pos};
    }
    if($croak){ #rollback
      vec($$bf{filter}, $h[$_] % $m, $cb)=
      vec($$bf{filter}, $h[$_] % $m, $cb)+1 for 0..$k-1;
      croak $croak;
    }
  }
  return $bf;
}
sub bfstore
{
  require Storable;
  Storable::store(@_);
}
sub bfretrieve
{
  require Storable;
  my $bf=Storable::retrieve(@_);
  carp  "Retrieved bloom filter was stored in version $$bf{version}, this is version $VERSION" if $$bf{version}>$VERSION;
  return $bf;
}
sub bfclone
{
  require Storable;
  return Storable::dclone(@_); #could be faster
}
sub bfdimensions_old
{
  my($n,$p,$mink,$maxk, $k,$flen,$m)=
    @_==1 ? (@{$_[0]}{'capacity','error_rate','min_hashfuncs','max_hashfuncs'},1)
   :@_==2 ? (@_,1,100,1)
          : croak "Wrong number of arguments (".@_."), should be 2";
  croak "p ($p) should be > 0 and < 1" if not $p>0 && $p<1;
  $m=-1*$_*$n/log(1-$p**(1/$_)) and (!defined $flen or $m<$flen) and ($flen,$k)=($m,$_) for $mink..$maxk;
  $flen = int(1+$flen);
  return ($flen,$k);
}
sub bfdimensions
{
  my($n,$p,$mink,$maxk)=
    @_==1 ? (@{$_[0]}{'capacity','error_rate','min_hashfuncs','max_hashfuncs'})
   :@_==2 ? (@_,1,100)
          : croak "Wrong number of arguments (".@_."), should be 2";
  my $k=log(1/$p)/log(2);           # k hash funcs
  my $m=-$n*log($p)/log(2)**2;      # m bits in filter
  return ($m+0.5,min($maxk,max($mink,int($k+0.5))));
}

1;

package Acme::Tools::BloomFilter;
use 5.008;
use strict;
#use warnings;
use Carp;
sub new 
{
  my($class,@p)=@_;
  my $self=Acme::Tools::bfinit(@p);
  return bless $self, $class;
}
sub add      {&Acme::Tools::bfadd}
sub addbf    {&Acme::Tools::bfaddbf}
sub check    {&Acme::Tools::bfcheck}
sub grep     {&Acme::Tools::bfgrep}
sub grepnot  {&Acme::Tools::bfgrepnot}
sub delete   {&Acme::Tools::bfdelete}
sub store    {&Acme::Tools::bfstore}
sub retrieve {&Acme::Tools::bfretrieve}
sub clone    {&Acme::Tools::bfclone}
sub sum      {&Acme::Tools::bfsum}
1;

# Ny versjon:
# + endre $VERSION
# + endre Release history under HISTORY
# + endre �rstall under COPYRIGHT AND LICENSE
# + emacs Changes
# + emacs README
# + perl            Makefile.PL;make test
# + /local/bin/perl Makefile.PL;make test
# + /usr/bin/perl   Makefile.PL;make test
# + test evt i cygwin og mingw-perl
# + make dist
# + cp -p *tar.gz /htdocs/
# + ci -l -mversjon -d `cat MANIFEST`
# + http://pause.perl.org/
# http://en.wikipedia.org/wiki/Birthday_problem#Approximations

# ~/test/deldup.pl #find duplicate files effiencently
# memoize_expire()           http://perldoc.perl.org/Memoize/Expire.html
# memoize_file_expire()
# memoize_limit_size() #lru
# memoize_file_limit_size()
# memoize_memcached         http://search.cpan.org/~dtrischuk/Memoize-Memcached-0.03/lib/Memoize/Memcached.pm
# hint on http://perl.jonallen.info/writing/articles/install-perl-modules-without-root

__END__

=head1 HISTORY

Release history

 0.13   Oct 2010   Non-linux test issue, resolve. improved: bloom filter, tests, doc
 0.12   Oct 2010   Improved tests, doc, bloom filter, random_gauss, bytes_readable
 0.11   Dec 2008   Improved doc
 0.10   Dec 2008

=head1 SEE ALSO

=head1 AUTHOR

Kjetil Skotheim, E<lt>kjetil.skotheim@gmail.comE<gt>, E<lt>kjetil.skotheim@usit.uio.noE<gt>

=head1 COPYRIGHT AND LICENSE

1995-2010, Kjetil Skotheim

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
